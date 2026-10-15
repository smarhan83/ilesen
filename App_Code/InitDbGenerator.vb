Imports System.Data
Imports System.Data.SqlClient
Imports System.Linq
Imports System.Text
Imports System.Text.RegularExpressions

' =====================================================================================
'  Initial Database - generator skrip (globalmaster/humanResources/InitialDatabase.aspx)
'
'  Konsep ikut OMP (Master/InitialDatabase): banding struktur DB "working" (sistem baru)
'  dengan DB "baseline" (sistem lama), kemudian jana:
'    - SQL Analysis : satu SELECT yang pulangkan status setiap langkah pada DB sasaran
'    - SQL Run      : blok SQL setiap langkah, dipisahkan penanda  /*@@STEP kod|jenis|nama@@*/
'  Kedua-duanya disimpan dalam TBL_InitDbApi (INITDB_ANALYSIS / INITDB_RUN).
'
'  Langkah: T table, C column, I index/PK/UQ, K foreign key, D data (page & kebenaran),
'           F function, V view, P procedure, G trigger (baru), R function/view/proc/trigger yang berubah.
'  Idempotent: object yang sudah ada di-skip. Table & column tidak pernah di-drop.
'  Data: rekod DB working dibenamkan dalam skrip - tambah yang tiada, kemas kini yang berbeza, tidak pernah padam.
' =====================================================================================
Public Class InitDbGenerator

    Public Const ApiAnalysis As String = "INITDB_ANALYSIS"
    Public Const ApiRun As String = "INITDB_RUN"
    Public Const ApiWarning As String = "INITDB_WARNING"
    Public Const StepMarker As String = "/*@@STEP "

    Public Shared ReadOnly KindOrder As String() = {"TABLE", "COLUMN", "INDEX", "FK", "DATA", "FUNCTION", "VIEW", "PROC", "TRIGGER"}

    ' ------------------------------------------------------------------ data seed (page & kebenaran pengguna)
    Public Class SeedLookup
        Public Col, RefTable, RefKey, RefId As String     ' Col dipadankan melalui RefTable.RefKey (cth. Users_Name -> Users_Id)
    End Class

    Public Class SeedDef
        Public Table As String                             ' schema.name
        Public KeyCols As String()                         ' kunci padanan rekod
        Public PreserveIdentity As Boolean                 ' True = ID dikekalkan (IDENTITY_INSERT)
        Public Lookups As New List(Of SeedLookup)
        Public Note As String
    End Class

    ' Susunan penting: group & module dahulu (ID dikekalkan), kemudian role & ahli group yang merujuknya
    Public Shared ReadOnly Seeds As SeedDef() = {
        New SeedDef With {.Table = "dbo.TBL_USER_GROUPNAME", .KeyCols = {"UGN_Id"}, .PreserveIdentity = True, .Note = "Kumpulan pengguna"},
        New SeedDef With {.Table = "dbo.TBL_USER_GROUPMODULE", .KeyCols = {"UGM_Id"}, .PreserveIdentity = True, .Note = "Page / menu (ID dikekalkan - dirujuk oleh m_Id & UGM_ParentId)"},
        New SeedDef With {.Table = "dbo.TBL_USER_GROUPROLE", .KeyCols = {"UGR_UGN_Id", "UGR_UGM_Id"}, .PreserveIdentity = False, .Note = "Kebenaran page bagi setiap kumpulan"},
        New SeedDef With {.Table = "dbo.TBL_USER_GROUPLIST", .KeyCols = {"UGL_UGN_Id", "UGL_Users_Id"}, .PreserveIdentity = False, .Note = "Ahli kumpulan (pengguna dipadankan ikut Users_Name)",
                          .Lookups = New List(Of SeedLookup) From {New SeedLookup With {.Col = "UGL_Users_Id", .RefTable = "dbo.TBL_USERS", .RefKey = "Users_Name", .RefId = "Users_Id"}}}
    }

    ' Table dalaman page ini - tidak dibanding / tidak di-script
    Private Shared ReadOnly InternalTables As New HashSet(Of String)({"dbo.TBL_InitDbApi", "dbo.tbl_sys_InitDbLog"}, StringComparer.OrdinalIgnoreCase)

    ' ------------------------------------------------------------------ model
    Public Class ColInfo
        Public Name, TypeName, DefaultName, DefaultDef, ComputedDef As String
        Public MaxLength, Precision, Scale As Integer
        Public Nullable, Identity, Computed, Persisted As Boolean
        Public Seed, Increment As String
    End Class

    Public Class IdxInfo
        Public Name, TypeDesc, Filter As String
        Public IsUnique, IsPK, IsUQ As Boolean
        Public KeyCols As New List(Of String)       ' [col] ASC/DESC
        Public IncludeCols As New List(Of String)
    End Class

    Public Class TableInfo
        Public Schema, Name As String
        Public Cols As New List(Of ColInfo)
        Public Indexes As New List(Of IdxInfo)
        Public ReadOnly Property Key As String
            Get
                Return Schema & "." & Name
            End Get
        End Property
    End Class

    Public Class FkInfo
        Public Schema, Name, TableKey, RefKey, OnDelete, OnUpdate As String
        Public Cols As New List(Of String)
        Public RefCols As New List(Of String)
    End Class

    Public Class ModInfo
        Public Schema, Name, Type, Definition, Hash As String
        Public ReadOnly Property Key As String
            Get
                Return Schema & "." & Name
            End Get
        End Property
    End Class

    Public Class DbSchema
        Public Server, Database As String
        Public Tables As New Dictionary(Of String, TableInfo)(StringComparer.OrdinalIgnoreCase)
        Public Fks As New Dictionary(Of String, FkInfo)(StringComparer.OrdinalIgnoreCase)
        Public Modules As New Dictionary(Of String, ModInfo)(StringComparer.OrdinalIgnoreCase)
        Public Deps As New List(Of KeyValuePair(Of String, String))   ' referencing -> referenced
    End Class

    Public Class InitStep
        Public Seq As Integer
        Public Code, Kind, Name, Descr, CheckSql, RunSql As String
        Public AnalysisPrep As String = ""     ' SQL disediakan sebelum SELECT analisis (cth. table variable data)
        Public DescrSql As String = ""         ' ungkapan SQL untuk keterangan dinamik (ganti Descr)
        Public ColsExpected As Integer = -1
        Public ReadOnly Property DiffKey As String
            Get
                Return Kind & "|" & Name
            End Get
        End Property
    End Class

    Public Class GenerateResult
        Public Steps As New List(Of InitStep)
        Public Warnings As New List(Of String)
        Public AnalysisSql, RunSql, Note As String
    End Class

    ' ------------------------------------------------------------------ baca schema
    Public Shared Function ReadSchema(connStr As String) As DbSchema
        Dim s As New DbSchema()
        Dim sql As String =
            "SELECT @@SERVERNAME, DB_NAME();" &
            "SELECT t.object_id, SCHEMA_NAME(t.schema_id), t.name FROM sys.tables t WHERE t.is_ms_shipped = 0;" &
            "SELECT c.object_id, c.column_id, c.name, TYPE_NAME(c.user_type_id), c.max_length, c.precision, c.scale, c.is_nullable, c.is_identity," &
            " CAST(ic.seed_value AS varchar(30)), CAST(ic.increment_value AS varchar(30)), dc.name, dc.definition, c.is_computed, cc.definition, ISNULL(cc.is_persisted,0)" &
            " FROM sys.columns c JOIN sys.tables t ON t.object_id = c.object_id AND t.is_ms_shipped = 0" &
            " LEFT JOIN sys.identity_columns ic ON ic.object_id = c.object_id AND ic.column_id = c.column_id" &
            " LEFT JOIN sys.default_constraints dc ON dc.object_id = c.default_object_id" &
            " LEFT JOIN sys.computed_columns cc ON cc.object_id = c.object_id AND cc.column_id = c.column_id" &
            " ORDER BY c.object_id, c.column_id;" &
            "SELECT i.object_id, i.index_id, i.name, i.is_unique, i.type_desc, i.filter_definition, i.is_primary_key, i.is_unique_constraint" &
            " FROM sys.indexes i JOIN sys.tables t ON t.object_id = i.object_id AND t.is_ms_shipped = 0" &
            " WHERE i.index_id > 0 AND i.name IS NOT NULL AND i.is_hypothetical = 0;" &
            "SELECT ic.object_id, ic.index_id, col.name, ic.is_descending_key, ic.is_included_column, ic.key_ordinal" &
            " FROM sys.index_columns ic JOIN sys.columns col ON col.object_id = ic.object_id AND col.column_id = ic.column_id" &
            " JOIN sys.tables t ON t.object_id = ic.object_id AND t.is_ms_shipped = 0 ORDER BY ic.object_id, ic.index_id, ic.key_ordinal, ic.index_column_id;" &
            "SELECT f.object_id, SCHEMA_NAME(f.schema_id), f.name, OBJECT_SCHEMA_NAME(f.parent_object_id), OBJECT_NAME(f.parent_object_id)," &
            " OBJECT_SCHEMA_NAME(f.referenced_object_id), OBJECT_NAME(f.referenced_object_id), f.delete_referential_action_desc, f.update_referential_action_desc" &
            " FROM sys.foreign_keys f;" &
            "SELECT k.constraint_object_id, pc.name, rc.name FROM sys.foreign_key_columns k" &
            " JOIN sys.columns pc ON pc.object_id = k.parent_object_id AND pc.column_id = k.parent_column_id" &
            " JOIN sys.columns rc ON rc.object_id = k.referenced_object_id AND rc.column_id = k.referenced_column_id" &
            " ORDER BY k.constraint_object_id, k.constraint_column_id;" &
            "SELECT SCHEMA_NAME(o.schema_id), o.name, RTRIM(o.type), m.definition," &
            " CONVERT(varchar(66), HASHBYTES('SHA2_256', REPLACE(m.definition, NCHAR(13), N'')), 1)" &
            " FROM sys.objects o JOIN sys.sql_modules m ON m.object_id = o.object_id" &
            " WHERE o.is_ms_shipped = 0 AND o.type IN ('FN','IF','TF','V','P','TR');" &
            "SELECT OBJECT_SCHEMA_NAME(d.referencing_id) + '.' + OBJECT_NAME(d.referencing_id), OBJECT_SCHEMA_NAME(d.referenced_id) + '.' + OBJECT_NAME(d.referenced_id)" &
            " FROM sys.sql_expression_dependencies d WHERE d.referenced_id IS NOT NULL AND d.referencing_id <> d.referenced_id;"

        Dim byId As New Dictionary(Of Integer, TableInfo)()
        Dim idxById As New Dictionary(Of String, IdxInfo)()
        Dim fkById As New Dictionary(Of Integer, FkInfo)()

        Using conn As New SqlConnection(connStr)
            conn.Open()
            Using cmd As New SqlCommand(sql, conn)
                cmd.CommandTimeout = 300
                Using r As SqlDataReader = cmd.ExecuteReader()
                    If r.Read() Then s.Server = Str(r(0)) : s.Database = Str(r(1))

                    r.NextResult()
                    While r.Read()
                        Dim t As New TableInfo With {.Schema = Str(r(1)), .Name = Str(r(2))}
                        If InternalTables.Contains(t.Key) Then Continue While
                        byId(CInt(r(0))) = t
                        s.Tables(t.Key) = t
                    End While

                    r.NextResult()
                    While r.Read()
                        Dim t As TableInfo = Nothing
                        If Not byId.TryGetValue(CInt(r(0)), t) Then Continue While
                        t.Cols.Add(New ColInfo With {
                            .Name = Str(r(2)), .TypeName = Str(r(3)), .MaxLength = CInt(r(4)), .Precision = CInt(r(5)), .Scale = CInt(r(6)),
                            .Nullable = CBool(r(7)), .Identity = CBool(r(8)), .Seed = Str(r(9)), .Increment = Str(r(10)),
                            .DefaultName = Str(r(11)), .DefaultDef = Str(r(12)), .Computed = CBool(r(13)), .ComputedDef = Str(r(14)), .Persisted = CBool(r(15))})
                    End While

                    r.NextResult()
                    While r.Read()
                        Dim t As TableInfo = Nothing
                        If Not byId.TryGetValue(CInt(r(0)), t) Then Continue While
                        Dim ix As New IdxInfo With {.Name = Str(r(2)), .IsUnique = CBool(r(3)), .TypeDesc = Str(r(4)), .Filter = Str(r(5)), .IsPK = CBool(r(6)), .IsUQ = CBool(r(7))}
                        t.Indexes.Add(ix)
                        idxById(r(0).ToString() & "." & r(1).ToString()) = ix
                    End While

                    r.NextResult()
                    While r.Read()
                        Dim ix As IdxInfo = Nothing
                        If Not idxById.TryGetValue(r(0).ToString() & "." & r(1).ToString(), ix) Then Continue While
                        If CBool(r(4)) Then
                            ix.IncludeCols.Add(Q(Str(r(2))))
                        Else
                            ix.KeyCols.Add(Q(Str(r(2))) & If(CBool(r(3)), " DESC", " ASC"))
                        End If
                    End While

                    r.NextResult()
                    While r.Read()
                        Dim fk As New FkInfo With {.Schema = Str(r(1)), .Name = Str(r(2)), .TableKey = Str(r(3)) & "." & Str(r(4)),
                                                   .RefKey = Str(r(5)) & "." & Str(r(6)), .OnDelete = Str(r(7)), .OnUpdate = Str(r(8))}
                        fkById(CInt(r(0))) = fk
                        s.Fks(fk.Schema & "." & fk.Name) = fk
                    End While

                    r.NextResult()
                    While r.Read()
                        Dim fk As FkInfo = Nothing
                        If Not fkById.TryGetValue(CInt(r(0)), fk) Then Continue While
                        fk.Cols.Add(Q(Str(r(1))))
                        fk.RefCols.Add(Q(Str(r(2))))
                    End While

                    r.NextResult()
                    While r.Read()
                        Dim m As New ModInfo With {.Schema = Str(r(0)), .Name = Str(r(1)), .Type = Str(r(2)), .Definition = Str(r(3)), .Hash = Str(r(4))}
                        s.Modules(m.Key) = m
                    End While

                    r.NextResult()
                    While r.Read()
                        s.Deps.Add(New KeyValuePair(Of String, String)(Str(r(0)), Str(r(1))))
                    End While
                End Using
            End Using
        End Using
        Return s
    End Function

    ' ------------------------------------------------------------------ jana skrip
    Public Shared Function Generate(working As DbSchema, baseline As DbSchema, Optional workingConn As String = Nothing) As GenerateResult
        Dim res As New GenerateResult()
        Dim tables As New List(Of InitStep), cols As New List(Of InitStep), idxs As New List(Of InitStep), fks As New List(Of InitStep)
        Dim datas As New List(Of InitStep)

        For Each t In working.Tables.Values.OrderBy(Function(x) x.Key)
            Dim bt As TableInfo = Nothing
            If Not baseline.Tables.TryGetValue(t.Key, bt) Then
                ' table baru (PK / UQ dalam CREATE TABLE; index lain jadi langkah berasingan)
                tables.Add(New InitStep With {
                    .Kind = "TABLE", .Name = t.Key, .Descr = t.Cols.Count & " kolum",
                    .ColsExpected = t.Cols.Count,
                    .CheckSql = "CASE WHEN OBJECT_ID(" & NLit(QN(t)) & ", 'U') IS NULL THEN 'MISSING' ELSE 'EXISTS' END",
                    .RunSql = "IF OBJECT_ID(" & NLit(QN(t)) & ", 'U') IS NULL" & vbCrLf & "BEGIN" & vbCrLf & CreateTableSql(t) & vbCrLf & "END"})
                For Each ix In t.Indexes.Where(Function(x) Not x.IsPK AndAlso Not x.IsUQ)
                    idxs.Add(IndexStep(t, ix))
                Next
                Continue For
            End If

            ' kolum baru dalam table sedia ada
            For Each c In t.Cols
                Dim bc = bt.Cols.FirstOrDefault(Function(x) String.Equals(x.Name, c.Name, StringComparison.OrdinalIgnoreCase))
                If bc Is Nothing Then
                    If Not c.Nullable AndAlso Not c.Identity AndAlso Not c.Computed AndAlso c.DefaultDef = "" Then
                        res.Warnings.Add("Kolum NOT NULL tanpa default: " & t.Key & "." & c.Name & " - akan gagal jika table ada data.")
                    End If
                    cols.Add(New InitStep With {
                        .Kind = "COLUMN", .Name = t.Key & "." & c.Name, .Descr = ColTypeSql(c) & If(c.Nullable, " NULL", " NOT NULL"),
                        .CheckSql = "CASE WHEN COL_LENGTH(" & NLit(QN(t)) & ", " & NLit(c.Name) & ") IS NULL THEN 'MISSING' ELSE 'SAME' END",
                        .RunSql = "IF COL_LENGTH(" & NLit(QN(t)) & ", " & NLit(c.Name) & ") IS NULL" & vbCrLf &
                                  "    ALTER TABLE " & QN(t) & " ADD " & ColumnDefSql(c) & ";"})
                ElseIf ColTypeSql(bc) <> ColTypeSql(c) OrElse bc.Nullable <> c.Nullable Then
                    res.Warnings.Add("Jenis kolum berbeza (tidak di-script): " & t.Key & "." & c.Name & " - lama " & ColTypeSql(bc) & If(bc.Nullable, " NULL", " NOT NULL") &
                                     ", baru " & ColTypeSql(c) & If(c.Nullable, " NULL", " NOT NULL"))
                End If
            Next

            ' index / PK / UQ baru dalam table sedia ada
            For Each ix In t.Indexes
                Dim nm = ix.Name
                If Not bt.Indexes.Any(Function(x) String.Equals(x.Name, nm, StringComparison.OrdinalIgnoreCase)) Then
                    ' PK/UQ nama auto (PK__...) yang setara sudah ada dalam baseline -> abaikan
                    If (ix.IsPK AndAlso bt.Indexes.Any(Function(x) x.IsPK)) Then Continue For
                    idxs.Add(IndexStep(t, ix))
                End If
            Next
        Next

        For Each fk In working.Fks.Values.OrderBy(Function(x) x.Name)
            If baseline.Fks.ContainsKey(fk.Schema & "." & fk.Name) Then Continue For
            Dim tk = fk.TableKey
            fks.Add(New InitStep With {
                .Kind = "FK", .Name = fk.Schema & "." & fk.Name, .Descr = fk.TableKey & " -> " & fk.RefKey,
                .CheckSql = "CASE WHEN OBJECT_ID(" & NLit(Q(fk.Schema) & "." & Q(fk.Name)) & ", 'F') IS NULL THEN 'MISSING' ELSE 'SAME' END",
                .RunSql = "IF OBJECT_ID(" & NLit(Q(fk.Schema) & "." & Q(fk.Name)) & ", 'F') IS NULL" & vbCrLf &
                          "    ALTER TABLE " & QK(fk.TableKey) & " ADD CONSTRAINT " & Q(fk.Name) &
                          " FOREIGN KEY (" & String.Join(", ", fk.Cols) & ") REFERENCES " & QK(fk.RefKey) & " (" & String.Join(", ", fk.RefCols) & ")" &
                          If(fk.OnDelete <> "NO_ACTION", " ON DELETE " & fk.OnDelete.Replace("_", " "), "") &
                          If(fk.OnUpdate <> "NO_ACTION", " ON UPDATE " & fk.OnUpdate.Replace("_", " "), "") & ";"})
        Next

        ' data seed: page / menu & kebenaran pengguna
        If Not String.IsNullOrEmpty(workingConn) Then
            Dim n As Integer = 0
            For Each sd In Seeds
                Dim t As TableInfo = Nothing
                If Not working.Tables.TryGetValue(sd.Table, t) Then
                    res.Warnings.Add("Table data seed tiada dalam DB working: " & sd.Table)
                    Continue For
                End If
                n += 1
                ' hanya kolum yang ada dalam kedua-dua DB (SQL analisis dijalankan sebelum kolum baru dicipta)
                Dim bt As TableInfo = Nothing
                Dim tUse As TableInfo = t
                If baseline.Tables.TryGetValue(sd.Table, bt) Then
                    tUse = New TableInfo With {.Schema = t.Schema, .Name = t.Name}
                    For Each c In t.Cols
                        Dim nm = c.Name
                        If bt.Cols.Any(Function(x) String.Equals(x.Name, nm, StringComparison.OrdinalIgnoreCase)) Then
                            tUse.Cols.Add(c)
                        Else
                            res.Warnings.Add("Data seed " & sd.Table & ": kolum baru " & c.Name & " tidak dibawa (tiada dalam baseline).")
                        End If
                    Next
                End If
                datas.Add(SeedStep(sd, tUse, ReadSeedRows(workingConn, sd, tUse), "@seed" & n))
            Next
        End If

        ' module: baru / berubah, ikut susunan dependency (function & view), kemudian proc, trigger
        Dim mods = working.Modules.Values.Where(Function(m)
                                                    Dim bm As ModInfo = Nothing
                                                    Return Not baseline.Modules.TryGetValue(m.Key, bm) OrElse bm.Hash <> m.Hash
                                                End Function).ToList()
        Dim modSteps As New List(Of InitStep)
        For Each m In OrderModules(mods, working.Deps)
            Dim isNew As Boolean = Not baseline.Modules.ContainsKey(m.Key)
            Dim kind = ModKind(m.Type)
            Dim check = "CASE WHEN OBJECT_ID(" & NLit(QM(m)) & ") IS NULL THEN 'MISSING'" &
                        " WHEN HASHBYTES('SHA2_256', REPLACE(OBJECT_DEFINITION(OBJECT_ID(" & NLit(QM(m)) & ")), NCHAR(13), N'')) = " & m.Hash & " THEN 'SAME'" &
                        " ELSE 'DIFFERENT' END"
            Dim body = "EXEC sp_executesql " & NLit(m.Definition) & ";"
            Dim run As String
            If isNew Then
                run = "IF OBJECT_ID(" & NLit(QM(m)) & ") IS NULL" & vbCrLf & "    " & body
            Else
                run = "IF OBJECT_ID(" & NLit(QM(m)) & ") IS NOT NULL" & vbCrLf & "    DROP " & DropWord(m.Type) & " " & QM(m) & ";" & vbCrLf & body
            End If
            modSteps.Add(New InitStep With {.Kind = kind, .Name = m.Key, .Descr = If(isNew, "Baru", "Berubah - drop & create"), .CheckSql = check, .RunSql = run})
        Next

        ' nombor kod ikut jenis: T01 C01 I01 K01 F01 V01 P01 G01 ; berubah = R01
        Dim all As New List(Of InitStep)
        all.AddRange(tables) : all.AddRange(cols) : all.AddRange(idxs) : all.AddRange(fks) : all.AddRange(datas) : all.AddRange(modSteps)
        Dim counters As New Dictionary(Of String, Integer)
        Dim seq As Integer = 0
        For Each st In all
            Dim prefix As String
            If st.Descr.StartsWith("Berubah") Then
                prefix = "R"
            Else
                prefix = PrefixFor(st.Kind)
            End If
            Dim n As Integer = 0
            counters.TryGetValue(prefix, n)
            n += 1
            counters(prefix) = n
            seq += 1
            st.Seq = seq
            st.Code = prefix & n.ToString("00")
        Next
        res.Steps = all

        For Each bm In baseline.Modules.Values.Where(Function(m) Not working.Modules.ContainsKey(m.Key))
            res.Warnings.Add("Hanya ada dalam baseline (tidak di-script, tidak di-drop): " & ModKind(bm.Type).ToLower() & " " & bm.Key)
        Next
        For Each bt In baseline.Tables.Values.Where(Function(t) Not working.Tables.ContainsKey(t.Key))
            res.Warnings.Add("Table hanya ada dalam baseline (tidak di-drop): " & bt.Key)
        Next

        res.Note = "Dijana " & DateTime.Now.ToString("yyyy-MM-dd HH:mm") & " | working " & working.Server & "/" & working.Database &
                   " vs baseline " & baseline.Server & "/" & baseline.Database & " | " & all.Count & " langkah"
        res.AnalysisSql = BuildAnalysisSql(all, res.Note)
        res.RunSql = BuildRunSql(all, res.Note)
        Return res
    End Function

    ' ------------------------------------------------------------------ SQL Analysis / Run
    Private Shared Function BuildAnalysisSql(steps As List(Of InitStep), note As String) As String
        Dim sb As New StringBuilder()
        sb.AppendLine("/* Initial Database - Analysis. " & note & " */")
        sb.AppendLine("SET NOCOUNT ON;")
        If steps.Count = 0 Then
            sb.AppendLine("SELECT CAST(0 AS int) AS Seq, CAST('' AS varchar(20)) AS Code, CAST('' AS varchar(20)) AS Kind, CAST(N'' AS nvarchar(300)) AS Name, CAST(N'' AS nvarchar(300)) AS Descr, CAST('' AS varchar(20)) AS State, CAST(NULL AS int) AS ColsExpected, CAST(NULL AS int) AS ColsActual WHERE 1 = 0;")
            Return sb.ToString()
        End If
        ' data seed: table variable disediakan dahulu
        For Each st In steps.Where(Function(x) x.AnalysisPrep <> "")
            sb.AppendLine(st.AnalysisPrep)
        Next
        For i As Integer = 0 To steps.Count - 1
            Dim st = steps(i)
            Dim colsActual As String = "CAST(NULL AS int)"
            If st.Kind = "TABLE" Then colsActual = "(SELECT COUNT(*) FROM sys.columns WHERE object_id = OBJECT_ID(" & NLit(QK(st.Name)) & "))"
            sb.Append(If(i = 0, "SELECT ", "UNION ALL SELECT "))
            sb.Append(st.Seq & " AS Seq, '" & st.Code & "' AS Code, '" & st.Kind & "' AS Kind, " & NLit(st.Name) & " AS Name, " &
                      If(st.DescrSql <> "", "CAST(" & st.DescrSql & " AS nvarchar(300))", NLit(st.Descr)) & " AS Descr, ")
            sb.Append(st.CheckSql & " AS State, ")
            sb.Append(If(st.ColsExpected >= 0, "CAST(" & st.ColsExpected & " AS int)", "CAST(NULL AS int)") & " AS ColsExpected, " & colsActual & " AS ColsActual")
            sb.AppendLine()
        Next
        sb.AppendLine("ORDER BY Seq;")
        Return sb.ToString()
    End Function

    Private Shared Function BuildRunSql(steps As List(Of InitStep), note As String) As String
        Dim sb As New StringBuilder()
        sb.AppendLine("/* Initial Database - Run. " & note & " */")
        For Each st In steps
            sb.AppendLine(StepMarker & st.Code & "|" & st.Kind & "|" & st.Name & "@@*/")
            sb.AppendLine(st.RunSql)
        Next
        Return sb.ToString()
    End Function

    ''' <summary>Pecahkan SQL Run kepada blok ikut penanda langkah: kunci = kod langkah.</summary>
    Public Shared Function SplitRunSql(runSql As String) As List(Of InitStep)
        Dim list As New List(Of InitStep)
        If String.IsNullOrEmpty(runSql) Then Return list
        Dim ms = Regex.Matches(runSql, "/\*@@STEP (?<code>[^|]+)\|(?<kind>[^|]+)\|(?<name>.*?)@@\*/\r?\n")
        For i As Integer = 0 To ms.Count - 1
            Dim startPos = ms(i).Index + ms(i).Length
            Dim endPos = If(i + 1 < ms.Count, ms(i + 1).Index, runSql.Length)
            list.Add(New InitStep With {.Code = ms(i).Groups("code").Value, .Kind = ms(i).Groups("kind").Value, .Name = ms(i).Groups("name").Value,
                                        .RunSql = runSql.Substring(startPos, endPos - startPos).TrimEnd(), .Seq = i + 1})
        Next
        Return list
    End Function

    ' ------------------------------------------------------------------ data seed
    ' Kolum yang dibawa: semua kecuali computed / rowversion; kolum identity hanya jika ID dikekalkan
    Private Shared Function SeedCols(sd As SeedDef, t As TableInfo) As List(Of ColInfo)
        Return t.Cols.Where(Function(c) Not c.Computed AndAlso
                                        c.TypeName.ToLowerInvariant() <> "timestamp" AndAlso c.TypeName.ToLowerInvariant() <> "rowversion" AndAlso
                                        (Not c.Identity OrElse sd.PreserveIdentity)).ToList()
    End Function

    Private Shared Function LkCol(lk As SeedLookup) As String
        Return "__lk_" & lk.Col
    End Function

    Private Shared Function ReadSeedRows(connStr As String, sd As SeedDef, t As TableInfo) As DataTable
        Dim cols = SeedCols(sd, t)
        Dim sel As New List(Of String)(cols.Select(Function(c) "t." & Q(c.Name)))
        Dim joins As New StringBuilder()
        Dim i As Integer = 0
        For Each lk In sd.Lookups
            i += 1
            sel.Add("lk" & i & "." & Q(lk.RefKey) & " AS " & Q(LkCol(lk)))
            joins.Append(" LEFT JOIN " & QK(lk.RefTable) & " lk" & i & " ON lk" & i & "." & Q(lk.RefId) & " = t." & Q(lk.Col))
        Next
        Dim sql = "SELECT " & String.Join(", ", sel) & " FROM " & QK(sd.Table) & " t" & joins.ToString() &
                  " ORDER BY " & String.Join(", ", sd.KeyCols.Select(Function(k) "t." & Q(k)))
        Dim dt As New DataTable()
        Using conn As New SqlConnection(connStr)
            Using cmd As New SqlCommand(sql, conn)
                cmd.CommandTimeout = 300
                Using da As New SqlDataAdapter(cmd)
                    da.Fill(dt)
                End Using
            End Using
        End Using
        Return dt
    End Function

    Private Shared Function SeedSqlType(c As ColInfo) As String
        Select Case c.TypeName.ToLowerInvariant()
            Case "text", "ntext" : Return "nvarchar(max)"
            Case "image" : Return "varbinary(max)"
            Case Else : Return ColTypeSql(c)
        End Select
    End Function

    ' Kolum table sasaran untuk perbandingan: text / ntext / image tidak boleh dibanding terus
    Private Shared Function TargetExpr(c As ColInfo) As String
        Select Case c.TypeName.ToLowerInvariant()
            Case "text", "ntext" : Return "CAST(t." & Q(c.Name) & " AS nvarchar(max))"
            Case "image" : Return "CAST(t." & Q(c.Name) & " AS varbinary(max))"
            Case Else : Return "t." & Q(c.Name)
        End Select
    End Function

    Private Shared Function SqlLit(v As Object) As String
        If v Is Nothing OrElse IsDBNull(v) Then Return "NULL"
        Dim inv = System.Globalization.CultureInfo.InvariantCulture
        If TypeOf v Is Boolean Then Return If(CBool(v), "1", "0")
        If TypeOf v Is Byte OrElse TypeOf v Is Short OrElse TypeOf v Is Integer OrElse TypeOf v Is Long OrElse TypeOf v Is Decimal Then Return Convert.ToString(v, inv)
        If TypeOf v Is Double Then Return CDbl(v).ToString("R", inv)
        If TypeOf v Is Single Then Return CSng(v).ToString("R", inv)
        If TypeOf v Is DateTime Then Return "'" & CDate(v).ToString("yyyy-MM-ddTHH:mm:ss.fff", inv) & "'"
        If TypeOf v Is DateTimeOffset Then Return "'" & DirectCast(v, DateTimeOffset).ToString("o", inv) & "'"
        If TypeOf v Is TimeSpan Then Return "'" & DirectCast(v, TimeSpan).ToString("c", inv) & "'"
        If TypeOf v Is Byte() Then Return "0x" & BitConverter.ToString(DirectCast(v, Byte())).Replace("-", "")
        Return NLit(v.ToString())
    End Function

    Private Shared Function SeedStep(sd As SeedDef, t As TableInfo, rows As DataTable, v As String) As InitStep
        Dim cols = SeedCols(sd, t)
        Dim keySet As New HashSet(Of String)(sd.KeyCols, StringComparer.OrdinalIgnoreCase)
        Dim cmp = cols.Where(Function(c) Not keySet.Contains(c.Name) AndAlso Not c.Identity).ToList()
        Dim tq = QK(sd.Table)

        ' --- table variable + data
        Dim prep As New StringBuilder()
        Dim defs As New List(Of String)(cols.Select(Function(c) Q(c.Name) & " " & SeedSqlType(c) & " NULL"))
        Dim insCols As New List(Of String)(cols.Select(Function(c) Q(c.Name)))
        For Each lk In sd.Lookups
            defs.Add(Q(LkCol(lk)) & " nvarchar(256) NULL")
            insCols.Add(Q(LkCol(lk)))
        Next
        prep.AppendLine("DECLARE " & v & " TABLE (" & String.Join(", ", defs) & ");")
        Const Chunk As Integer = 500
        For start As Integer = 0 To rows.Rows.Count - 1 Step Chunk
            prep.AppendLine("INSERT INTO " & v & " (" & String.Join(", ", insCols) & ") VALUES")
            Dim lines As New List(Of String)
            For r As Integer = start To Math.Min(start + Chunk, rows.Rows.Count) - 1
                Dim row = rows.Rows(r)
                Dim vals As New List(Of String)(cols.Select(Function(c) SqlLit(row(c.Name))))
                For Each lk In sd.Lookups
                    vals.Add(SqlLit(row(LkCol(lk))))
                Next
                lines.Add("(" & String.Join(", ", vals) & ")")
            Next
            prep.AppendLine(String.Join("," & vbCrLf, lines) & ";")
        Next
        ' padan rujukan ikut kunci perniagaan (cth. Users_Name) dalam DB sasaran; buang jika tiada
        For Each lk In sd.Lookups
            prep.AppendLine("UPDATE s SET s." & Q(lk.Col) & " = (SELECT TOP 1 r." & Q(lk.RefId) & " FROM " & QK(lk.RefTable) & " r WHERE r." & Q(lk.RefKey) & " = s." & Q(LkCol(lk)) & ") FROM " & v & " s;")
            prep.AppendLine("DELETE FROM " & v & " WHERE " & Q(lk.Col) & " IS NULL;")
        Next

        Dim keyMatch = String.Join(" AND ", sd.KeyCols.Select(Function(k) "t." & Q(k) & " = s." & Q(k)))
        Dim notSame = If(cmp.Count = 0, "1 = 0",
                         "NOT EXISTS (SELECT " & String.Join(", ", cmp.Select(Function(c) "s." & Q(c.Name))) &
                         " INTERSECT SELECT " & String.Join(", ", cmp.Select(Function(c) TargetExpr(c))) & ")")
        Dim missCnt = "(SELECT COUNT(*) FROM " & v & " s WHERE NOT EXISTS (SELECT 1 FROM " & tq & " t WHERE " & keyMatch & "))"
        Dim diffCnt = "(SELECT COUNT(*) FROM " & v & " s JOIN " & tq & " t ON " & keyMatch & " WHERE " & notSame & ")"

        ' --- run: kemas kini yang berbeza, tambah yang tiada (tiada padam)
        Dim run As New StringBuilder()
        run.AppendLine("SET NOCOUNT ON;")
        run.Append(prep.ToString())
        If cmp.Count > 0 Then
            run.AppendLine("UPDATE t SET " & String.Join(", ", cmp.Select(Function(c) "t." & Q(c.Name) & " = s." & Q(c.Name))) &
                           " FROM " & tq & " t JOIN " & v & " s ON " & keyMatch & " WHERE " & notSame & ";")
        End If
        Dim colList = String.Join(", ", cols.Select(Function(c) Q(c.Name)))
        Dim hasIdentity = sd.PreserveIdentity AndAlso cols.Any(Function(c) c.Identity)
        If hasIdentity Then run.AppendLine("SET IDENTITY_INSERT " & tq & " ON;")
        run.AppendLine("INSERT INTO " & tq & " (" & colList & ") SELECT " & String.Join(", ", cols.Select(Function(c) "s." & Q(c.Name))) &
                       " FROM " & v & " s WHERE NOT EXISTS (SELECT 1 FROM " & tq & " t WHERE " & keyMatch & ");")
        If hasIdentity Then run.AppendLine("SET IDENTITY_INSERT " & tq & " OFF;")

        Return New InitStep With {
            .Kind = "DATA", .Name = sd.Table, .Descr = sd.Note,
            .AnalysisPrep = prep.ToString(),
            .CheckSql = "CASE WHEN " & missCnt & " > 0 THEN 'MISSING' WHEN " & diffCnt & " > 0 THEN 'DIFFERENT' ELSE 'SAME' END",
            .DescrSql = "CAST(" & missCnt & " AS varchar(10)) + ' tambah, ' + CAST(" & diffCnt & " AS varchar(10)) + ' kemas kini (" & rows.Rows.Count & " rekod sumber)'",
            .RunSql = run.ToString().TrimEnd()}
    End Function

    ' ------------------------------------------------------------------ helper SQL
    Private Shared Function IndexStep(t As TableInfo, ix As IdxInfo) As InitStep
        Dim run As String
        Dim clustered = If(ix.TypeDesc = "CLUSTERED", "CLUSTERED", "NONCLUSTERED")
        If ix.IsPK OrElse ix.IsUQ Then
            run = "ALTER TABLE " & QN(t) & " ADD CONSTRAINT " & Q(ix.Name) & If(ix.IsPK, " PRIMARY KEY ", " UNIQUE ") & clustered & " (" & String.Join(", ", ix.KeyCols) & ");"
        Else
            run = "CREATE " & If(ix.IsUnique, "UNIQUE ", "") & clustered & " INDEX " & Q(ix.Name) & " ON " & QN(t) & " (" & String.Join(", ", ix.KeyCols) & ")" &
                  If(ix.IncludeCols.Count > 0, " INCLUDE (" & String.Join(", ", ix.IncludeCols) & ")", "") &
                  If(ix.Filter <> "", " WHERE " & ix.Filter, "") & ";"
        End If
        Dim exists = "EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(" & NLit(QN(t)) & ") AND name = " & NLit(ix.Name) & ")"
        Return New InitStep With {
            .Kind = "INDEX", .Name = t.Key & "." & ix.Name,
            .Descr = If(ix.IsPK, "Primary key", If(ix.IsUQ, "Unique constraint", If(ix.IsUnique, "Unique index", "Index"))) & " (" & String.Join(", ", ix.KeyCols).Replace(" ASC", "") & ")",
            .CheckSql = "CASE WHEN " & exists & " THEN 'SAME' ELSE 'MISSING' END",
            .RunSql = "IF NOT " & exists & vbCrLf & "    " & run}
    End Function

    Private Shared Function CreateTableSql(t As TableInfo) As String
        Dim lines As New List(Of String)
        For Each c In t.Cols
            lines.Add("    " & ColumnDefSql(c))
        Next
        For Each ix In t.Indexes.Where(Function(x) x.IsPK OrElse x.IsUQ)
            Dim nm = If(IsSystemName(ix.Name), "", "CONSTRAINT " & Q(ix.Name) & " ")
            lines.Add("    " & nm & If(ix.IsPK, "PRIMARY KEY ", "UNIQUE ") & If(ix.TypeDesc = "CLUSTERED", "CLUSTERED", "NONCLUSTERED") & " (" & String.Join(", ", ix.KeyCols) & ")")
        Next
        Return "    CREATE TABLE " & QN(t) & " (" & vbCrLf & String.Join("," & vbCrLf, lines) & vbCrLf & "    );"
    End Function

    Private Shared Function ColumnDefSql(c As ColInfo) As String
        If c.Computed Then Return Q(c.Name) & " AS " & c.ComputedDef & If(c.Persisted, " PERSISTED", "")
        Dim s = Q(c.Name) & " " & ColTypeSql(c)
        If c.Identity Then s &= " IDENTITY(" & If(c.Seed = "", "1", c.Seed) & "," & If(c.Increment = "", "1", c.Increment) & ")"
        s &= If(c.Nullable, " NULL", " NOT NULL")
        If c.DefaultDef <> "" Then s &= If(IsSystemName(c.DefaultName), "", " CONSTRAINT " & Q(c.DefaultName)) & " DEFAULT " & c.DefaultDef
        Return s
    End Function

    Public Shared Function ColTypeSql(c As ColInfo) As String
        Dim t = c.TypeName.ToLowerInvariant()
        Select Case t
            Case "nvarchar", "nchar"
                Return t & "(" & If(c.MaxLength = -1, "max", (c.MaxLength \ 2).ToString()) & ")"
            Case "varchar", "char", "varbinary", "binary"
                Return t & "(" & If(c.MaxLength = -1, "max", c.MaxLength.ToString()) & ")"
            Case "decimal", "numeric"
                Return t & "(" & c.Precision & "," & c.Scale & ")"
            Case "datetime2", "time", "datetimeoffset"
                Return t & "(" & c.Scale & ")"
            Case "float"
                Return If(c.Precision = 53, "float", "float(" & c.Precision & ")")
            Case Else
                Return t
        End Select
    End Function

    Private Shared Function OrderModules(mods As List(Of ModInfo), deps As List(Of KeyValuePair(Of String, String))) As List(Of ModInfo)
        Dim result As New List(Of ModInfo)
        ' function & view: susun topologi supaya object yang dirujuk dicipta dahulu
        Dim fv = mods.Where(Function(m) ModKind(m.Type) = "FUNCTION" OrElse ModKind(m.Type) = "VIEW").ToList()
        Dim keys As New HashSet(Of String)(fv.Select(Function(m) m.Key), StringComparer.OrdinalIgnoreCase)
        Dim done As New HashSet(Of String)(StringComparer.OrdinalIgnoreCase)
        Dim remaining = fv.OrderBy(Function(m) If(ModKind(m.Type) = "FUNCTION", 0, 1)).ThenBy(Function(m) m.Key).ToList()
        While remaining.Count > 0
            Dim ready = remaining.FirstOrDefault(Function(m) Not deps.Any(Function(d) String.Equals(d.Key, m.Key, StringComparison.OrdinalIgnoreCase) AndAlso keys.Contains(d.Value) AndAlso Not done.Contains(d.Value)))
            If ready Is Nothing Then ready = remaining(0)   ' kitaran: ikut susunan asal
            result.Add(ready)
            done.Add(ready.Key)
            remaining.Remove(ready)
        End While
        result.AddRange(mods.Where(Function(m) ModKind(m.Type) = "PROC").OrderBy(Function(m) m.Key))
        result.AddRange(mods.Where(Function(m) ModKind(m.Type) = "TRIGGER").OrderBy(Function(m) m.Key))
        Return result
    End Function

    Public Shared Function ModKind(type As String) As String
        Select Case type
            Case "FN", "IF", "TF" : Return "FUNCTION"
            Case "V" : Return "VIEW"
            Case "P" : Return "PROC"
            Case "TR" : Return "TRIGGER"
            Case Else : Return type
        End Select
    End Function

    Private Shared Function DropWord(type As String) As String
        Select Case type
            Case "FN", "IF", "TF" : Return "FUNCTION"
            Case "V" : Return "VIEW"
            Case "P" : Return "PROCEDURE"
            Case "TR" : Return "TRIGGER"
            Case Else : Return type
        End Select
    End Function

    Private Shared Function PrefixFor(kind As String) As String
        Select Case kind
            Case "TABLE" : Return "T"
            Case "COLUMN" : Return "C"
            Case "INDEX" : Return "I"
            Case "FK" : Return "K"
            Case "DATA" : Return "D"
            Case "FUNCTION" : Return "F"
            Case "VIEW" : Return "V"
            Case "PROC" : Return "P"
            Case "TRIGGER" : Return "G"
            Case Else : Return "X"
        End Select
    End Function

    ' Nama auto SQL Server (PK__, UQ__, DF__) - biar SQL Server jana semula
    Private Shared Function IsSystemName(name As String) As Boolean
        If String.IsNullOrEmpty(name) Then Return True
        Return Regex.IsMatch(name, "^(PK|UQ|DF)__.*__[0-9A-F]{8,}$", RegexOptions.IgnoreCase)
    End Function

    Private Shared Function Q(name As String) As String
        Return "[" & name.Replace("]", "]]") & "]"
    End Function
    Private Shared Function QN(t As TableInfo) As String
        Return Q(t.Schema) & "." & Q(t.Name)
    End Function
    Private Shared Function QM(m As ModInfo) As String
        Return Q(m.Schema) & "." & Q(m.Name)
    End Function
    Private Shared Function QK(key As String) As String
        Dim i = key.IndexOf("."c)
        Return Q(key.Substring(0, i)) & "." & Q(key.Substring(i + 1))
    End Function
    Public Shared Function NLit(s As String) As String
        Return "N'" & If(s, "").Replace("'", "''") & "'"
    End Function
    Private Shared Function Str(o As Object) As String
        Return If(o Is Nothing OrElse IsDBNull(o), "", o.ToString())
    End Function

End Class
