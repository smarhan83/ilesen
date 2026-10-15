Imports System.Data
Imports System.Data.SqlClient
Imports System.Linq
Imports System.Diagnostics
Imports System.Text.RegularExpressions

' Initial Database - ikut konsep OMP (Master/InitialDatabase).
'  1) Analisis struktur baru : banding DB working (initdb_Working) dengan baseline (initdb_Baseline / webcon),
'                              jana skrip & simpan ke TBL_InitDbApi (INITDB_ANALYSIS / INITDB_RUN / INITDB_WARNING)
'  2) Analisis DB sasaran     : jalankan SQL INITDB_ANALYSIS pada DB sasaran (webcon_ConnectionStr)
'  3) Run script              : jalankan setiap langkah melalui RunStep (AJAX), log ke tbl_sys_InitDbLog
Partial Class humanResources_InitialDatabase
    Inherits System.Web.UI.Page

    Private Const SESS_PREVIEW As String = "InitDb_Preview"
    Private Const SESS_CANRUN As String = "InitDb_CanRun"

    Protected StepCount As Integer, CntMissing As Integer, CntDifferent As Integer, CntOk As Integer
    Protected TargetDb As String = "", WorkingDb As String = "", ScriptNote As String = ""
    Protected ApiReady As Boolean = True

    ' ================================================================ helper sambungan
    Private Shared Function TargetConn() As String
        Return ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString
    End Function

    Private Shared Function WorkingConn() As String
        Dim cs = ConfigurationManager.ConnectionStrings("initdb_Working")
        If cs Is Nothing Then Throw New Exception("Connection string 'initdb_Working' (DB sistem baru) tiada dalam web.config.")
        Return cs.ConnectionString
    End Function

    Private Shared Function BaselineConn() As String
        Dim cs = ConfigurationManager.ConnectionStrings("initdb_Baseline")
        Return If(cs Is Nothing, TargetConn(), cs.ConnectionString)
    End Function

    Private Shared Function DbNameOf(connStr As String) As String
        Return New SqlConnectionStringBuilder(connStr).InitialCatalog
    End Function

    ' ================================================================ load
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        ' Page_Load content berjalan sebelum master page semak login - jangan sentuh DB tanpa sesi pengguna
        If CInt(If(Session("sessionUsersId"), 0)) <= 0 Then Return
        If Not IsPostBack Then
            LoadAnalysis()
        End If
    End Sub

    Protected Sub Page_PreRenderComplete(sender As Object, e As EventArgs) Handles Me.PreRenderComplete
        Dim frmview() As Object = {}
        Dim lbutton() As Object = {}
        Dim ctlDeny() As Object = {btnGenerate, btnSaveScript, divRunBtn}
        Dim canWrite As Boolean = GlobalClass.CheckPageWrite("Write", frmview, lbutton, ctlDeny)
        Session(SESS_CANRUN) = canWrite
    End Sub

    Private Function GetApi(apiId As String, ByRef note As String) As String
        note = ""
        Using conn As New SqlConnection(TargetConn())
            conn.Open()
            Using cmd As New SqlCommand("SELECT apiSQL, apiNote FROM dbo.TBL_InitDbApi WHERE apiID = @id AND apiStatus = 1", conn)
                cmd.Parameters.AddWithValue("@id", apiId)
                Using r = cmd.ExecuteReader()
                    If r.Read() Then
                        note = If(IsDBNull(r(1)), "", r(1).ToString())
                        Return If(IsDBNull(r(0)), "", r(0).ToString())
                    End If
                End Using
            End Using
        End Using
        Return ""
    End Function

    ' Cipta table dalaman page ini jika belum wujud (sama seperti sql/2026-10-15_initial_database.sql)
    Private Shared Sub EnsureInternalTables()
        Const SQL As String =
            "IF OBJECT_ID('dbo.TBL_InitDbApi', 'U') IS NULL " &
            "CREATE TABLE dbo.TBL_InitDbApi (" &
            " apiID varchar(50) NOT NULL CONSTRAINT PK_TBL_InitDbApi PRIMARY KEY," &
            " apiDescription nvarchar(200) NULL, apiSQL nvarchar(max) NULL, apiNote nvarchar(1000) NULL," &
            " apiStatus bit NOT NULL CONSTRAINT DF_TBL_InitDbApi_apiStatus DEFAULT (1)," &
            " CreatorID nvarchar(50) NULL, CreatedDt datetime NOT NULL CONSTRAINT DF_TBL_InitDbApi_CreatedDt DEFAULT (GETDATE())," &
            " LastModID nvarchar(50) NULL, LastModDt datetime NULL);" &
            "IF OBJECT_ID('dbo.tbl_sys_InitDbLog', 'U') IS NULL " &
            "BEGIN " &
            " CREATE TABLE dbo.tbl_sys_InitDbLog (" &
            "  LogID int IDENTITY(1,1) NOT NULL CONSTRAINT PK_tbl_sys_InitDbLog PRIMARY KEY," &
            "  RunID varchar(40) NOT NULL, StepCode varchar(20) NOT NULL, Kind varchar(20) NULL, ObjName nvarchar(300) NULL," &
            "  StateBefore varchar(20) NULL, Status varchar(20) NOT NULL, Message nvarchar(max) NULL, DurationMs int NULL," &
            "  RunBy nvarchar(100) NULL, RunDt datetime NOT NULL CONSTRAINT DF_tbl_sys_InitDbLog_RunDt DEFAULT (GETDATE()));" &
            " CREATE INDEX IX_tbl_sys_InitDbLog_RunID ON dbo.tbl_sys_InitDbLog (RunID, StepCode);" &
            "END"
        Using conn As New SqlConnection(TargetConn())
            conn.Open()
            Using cmd As New SqlCommand(SQL, conn)
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Private Function TableExists(name As String) As Boolean
        Using conn As New SqlConnection(TargetConn())
            conn.Open()
            Using cmd As New SqlCommand("SELECT CASE WHEN OBJECT_ID(@n, 'U') IS NULL THEN 0 ELSE 1 END", conn)
                cmd.Parameters.AddWithValue("@n", name)
                Return CInt(cmd.ExecuteScalar()) = 1
            End Using
        End Using
    End Function

    Private Sub LoadAnalysis()
        pnlError.Visible = False
        pnlSuccess.Visible = False
        WorkingDb = DbNameOf(If(ConfigurationManager.ConnectionStrings("initdb_Working") Is Nothing, "", ConfigurationManager.ConnectionStrings("initdb_Working").ConnectionString))

        LoadDbInfo()

        ApiReady = TableExists("dbo.TBL_InitDbApi") AndAlso TableExists("dbo.tbl_sys_InitDbLog")
        pnlSetup.Visible = Not ApiReady
        If Not ApiReady Then
            BindSteps(New DataTable())
            Return
        End If

        Dim note As String = ""
        Dim analysisSql = GetApi(InitDbGenerator.ApiAnalysis, note)
        ScriptNote = note
        Dim warnNote As String = ""
        Dim warnings = GetApi(InitDbGenerator.ApiWarning, warnNote)
        rptWarning.DataSource = warnings.Split(New String() {vbCrLf, vbLf}, StringSplitOptions.RemoveEmptyEntries)
        rptWarning.DataBind()
        pnlWarning.Visible = rptWarning.Items.Count > 0

        Dim dt As New DataTable()
        If analysisSql <> "" Then
            Try
                Using conn As New SqlConnection(TargetConn())
                    conn.Open()
                    Using cmd As New SqlCommand(analysisSql, conn)
                        cmd.CommandTimeout = 300
                        Using da As New SqlDataAdapter(cmd)
                            da.Fill(dt)
                        End Using
                    End Using
                End Using
            Catch ex As Exception
                ShowError("Analisis DB sasaran gagal: " & ex.Message)
            End Try
        End If
        pnlNoScript.Visible = (analysisSql = "")
        BindSteps(dt)
        litAnalysedAt.Text = DateTime.Now.ToString("d MMM yyyy HH:mm:ss")
    End Sub

    Private Sub LoadDbInfo()
        Try
            Using conn As New SqlConnection(TargetConn())
                conn.Open()
                Dim sql = "SELECT @@SERVERNAME, DB_NAME(), CAST(SERVERPROPERTY('ProductVersion') AS varchar(30)), d.compatibility_level, d.collation_name, " &
                          "(SELECT COUNT(*) FROM sys.tables WHERE is_ms_shipped = 0) FROM sys.databases d WHERE d.name = DB_NAME()"
                Using cmd As New SqlCommand(sql, conn)
                    Using r = cmd.ExecuteReader()
                        If r.Read() Then
                            TargetDb = r(1).ToString()
                            litServer.Text = HttpUtility.HtmlEncode(r(0).ToString())
                            litDbName.Text = HttpUtility.HtmlEncode(r(1).ToString())
                            litVersion.Text = HttpUtility.HtmlEncode(r(2).ToString())
                            litCompat.Text = r(3).ToString()
                            litCollation.Text = HttpUtility.HtmlEncode(r(4).ToString())
                            litTables.Text = CInt(r(5)).ToString("N0")
                        End If
                    End Using
                End Using
            End Using
        Catch ex As Exception
            ShowError("Tidak dapat sambung ke DB sasaran: " & ex.Message)
        End Try
        hdnDbName.Value = TargetDb
    End Sub

    Private Sub BindSteps(dt As DataTable)
        ' belum ada skrip / analisis gagal: jadual kosong tanpa kolum - tambah skema supaya Select & binding tidak gagal
        For Each c In New String() {"Seq", "Code", "Kind", "Name", "Descr", "State", "ColsExpected", "ColsActual"}
            If Not dt.Columns.Contains(c) Then dt.Columns.Add(c, If(c = "Seq" OrElse c.StartsWith("Cols"), GetType(Integer), GetType(String)))
        Next

        StepCount = dt.Rows.Count
        CntMissing = dt.Select("State = 'MISSING'").Length
        CntDifferent = dt.Select("State = 'DIFFERENT'").Length
        CntOk = StepCount - CntMissing - CntDifferent

        rptSteps.DataSource = dt
        rptSteps.DataBind()

        ' ringkasan ikut jenis object
        Dim summary As New DataTable()
        summary.Columns.Add("Kind") : summary.Columns.Add("Label") : summary.Columns.Add("Create", GetType(Integer))
        summary.Columns.Add("Replace", GetType(Integer)) : summary.Columns.Add("Ok", GetType(Integer)) : summary.Columns.Add("Total", GetType(Integer))
        For Each k In InitDbGenerator.KindOrder
            Dim rows = dt.Select("Kind = '" & k & "'")
            If rows.Length = 0 Then Continue For
            Dim cr = rows.Count(Function(r) r("State").ToString() = "MISSING")
            Dim rp = rows.Count(Function(r) r("State").ToString() = "DIFFERENT")
            summary.Rows.Add(k, KindLabel(k), cr, rp, rows.Length - cr - rp, rows.Length)
        Next
        rptSummary.DataSource = summary
        rptSummary.DataBind()

        ' pilihan penapis jenis
        ddlKind.Items.Clear()
        ddlKind.Items.Add(New ListItem("Semua jenis", ""))
        For Each r As DataRow In summary.Rows
            ddlKind.Items.Add(New ListItem(r("Label").ToString() & " (" & r("Total").ToString() & ")", r("Kind").ToString()))
        Next
    End Sub

    ' ================================================================ butang
    Protected Sub btnAnalyse_Click(sender As Object, e As EventArgs) Handles btnAnalyse.Click
        pnlPreview.Visible = False
        LoadAnalysis()
    End Sub

    ' Analisis struktur baru: jana skrip daripada working vs baseline, papar perbezaan dengan skrip dalam TBL_InitDbApi
    Protected Sub btnGenerate_Click(sender As Object, e As EventArgs) Handles btnGenerate.Click
        ' table dalaman dicipta automatik (tiada langkah manual)
        Try
            If CBool(If(Session(SESS_CANRUN), False)) Then EnsureInternalTables()
        Catch ex As Exception
            LoadAnalysis()
            ShowError("Gagal mencipta table TBL_InitDbApi / tbl_sys_InitDbLog: " & ex.Message)
            Return
        End Try
        LoadAnalysis()
        If Not ApiReady Then Return
        Try
            Dim sw = Stopwatch.StartNew()
            Dim working = InitDbGenerator.ReadSchema(WorkingConn())
            Dim baseline = InitDbGenerator.ReadSchema(BaselineConn())
            Dim result = InitDbGenerator.Generate(working, baseline, WorkingConn())
            Session(SESS_PREVIEW) = result

            Dim savedNote As String = ""
            Dim saved = InitDbGenerator.SplitRunSql(GetApi(InitDbGenerator.ApiRun, savedNote))
            Dim savedMap = saved.GroupBy(Function(s) s.Kind & "|" & s.Name).ToDictionary(Function(g) g.Key, Function(g) g.First().RunSql)
            Dim newMap = result.Steps.ToDictionary(Function(s) s.DiffKey, Function(s) s.RunSql)

            Dim changes As New DataTable()
            changes.Columns.Add("Change") : changes.Columns.Add("Kind") : changes.Columns.Add("Name")
            For Each st In result.Steps
                If Not savedMap.ContainsKey(st.DiffKey) Then
                    changes.Rows.Add("Baru", KindLabel(st.Kind), st.Name)
                ElseIf savedMap(st.DiffKey).Trim() <> st.RunSql.Trim() Then
                    changes.Rows.Add("Berubah", KindLabel(st.Kind), st.Name)
                End If
            Next
            For Each k In savedMap.Keys.Where(Function(x) Not newMap.ContainsKey(x))
                Dim p = k.Split("|"c)
                changes.Rows.Add("Dibuang", KindLabel(p(0)), p(1))
            Next

            Dim nAdd = changes.Select("Change = 'Baru'").Length
            Dim nChg = changes.Select("Change = 'Berubah'").Length
            Dim nRem = changes.Select("Change = 'Dibuang'").Length
            litPrevSource.Text = HttpUtility.HtmlEncode(working.Database & " (working) vs " & baseline.Database & " (baseline)")
            litPrevSteps.Text = result.Steps.Count.ToString()
            litPrevSaved.Text = saved.Count.ToString()
            litPrevAdd.Text = nAdd.ToString() : litPrevChg.Text = nChg.ToString() : litPrevRem.Text = nRem.ToString()
            litPrevTime.Text = (sw.ElapsedMilliseconds / 1000.0).ToString("0.0") & "s"
            pnlPrevSame.Visible = (changes.Rows.Count = 0)
            pnlPrevRemoved.Visible = (nRem > 0)
            rptChanges.DataSource = changes
            rptChanges.DataBind()
            rptPrevWarn.DataSource = result.Warnings
            rptPrevWarn.DataBind()
            pnlPrevWarn.Visible = result.Warnings.Count > 0
            btnSaveScript.Enabled = changes.Rows.Count > 0
            chkConfirmRemoved.Checked = False
            pnlPreview.Visible = True
        Catch ex As Exception
            ShowError("Gagal menjana skrip: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnCancelPreview_Click(sender As Object, e As EventArgs) Handles btnCancelPreview.Click
        Session.Remove(SESS_PREVIEW)
        pnlPreview.Visible = False
        LoadAnalysis()
    End Sub

    Protected Sub btnSaveScript_Click(sender As Object, e As EventArgs) Handles btnSaveScript.Click
        Dim result = TryCast(Session(SESS_PREVIEW), InitDbGenerator.GenerateResult)
        If result Is Nothing OrElse Not CBool(If(Session(SESS_CANRUN), False)) Then
            pnlPreview.Visible = False
            LoadAnalysis()
            Return
        End If
        If pnlPrevRemoved.Visible AndAlso Not chkConfirmRemoved.Checked Then
            LoadAnalysis()
            pnlPreview.Visible = True
            ShowError("Sila tanda pengesahan langkah yang akan dibuang sebelum menyimpan.")
            Return
        End If

        Try
            Dim user = Convert.ToString(Session("sessionUserName"))
            Using conn As New SqlConnection(TargetConn())
                conn.Open()
                Using tx = conn.BeginTransaction()
                    SaveApi(conn, tx, InitDbGenerator.ApiAnalysis, "Initial Database - Analysis", result.AnalysisSql, result.Note, user)
                    SaveApi(conn, tx, InitDbGenerator.ApiRun, "Initial Database - Run step", result.RunSql, result.Note, user)
                    SaveApi(conn, tx, InitDbGenerator.ApiWarning, "Initial Database - Amaran", String.Join(vbCrLf, result.Warnings), result.Note, user)
                    tx.Commit()
                End Using
            End Using
            GlobalClass.auditTrail("Initial Database", result.Note, "Update")
            Session.Remove(SESS_PREVIEW)
            pnlPreview.Visible = False
            LoadAnalysis()
            Dim msg = "Skrip " & result.Steps.Count & " langkah telah disimpan ke TBL_InitDbApi. Semak senarai langkah di bawah, kemudian tekan Run script."
            ShowSuccess(msg)
            ShowAlert("success", "Skrip disimpan", msg)
        Catch ex As Exception
            LoadAnalysis()
            ShowError("Gagal menyimpan skrip: " & ex.Message)
        End Try
    End Sub

    Private Shared Sub SaveApi(conn As SqlConnection, tx As SqlTransaction, id As String, descr As String, sqlText As String, note As String, user As String)
        Const SQL As String =
            "UPDATE dbo.TBL_InitDbApi SET apiDescription = @d, apiSQL = @s, apiNote = @n, apiStatus = 1, LastModID = @u, LastModDt = GETDATE() WHERE apiID = @id;" &
            "IF @@ROWCOUNT = 0 INSERT INTO dbo.TBL_InitDbApi (apiID, apiDescription, apiSQL, apiNote, apiStatus, CreatorID, CreatedDt) VALUES (@id, @d, @s, @n, 1, @u, GETDATE());"
        Using cmd As New SqlCommand(SQL, conn, tx)
            cmd.Parameters.AddWithValue("@id", id)
            cmd.Parameters.AddWithValue("@d", descr)
            cmd.Parameters.Add("@s", SqlDbType.NVarChar, -1).Value = sqlText
            cmd.Parameters.AddWithValue("@n", note)
            cmd.Parameters.AddWithValue("@u", user)
            cmd.ExecuteNonQuery()
        End Using
    End Sub

    ' ================================================================ run satu langkah (AJAX)
    <System.Web.Services.WebMethod(EnableSession:=True)>
    Public Shared Function RunStep(runId As String, code As String, state As String) As Dictionary(Of String, Object)
        Dim res As New Dictionary(Of String, Object)
        res("ok") = False : res("ms") = 0 : res("message") = ""

        Dim ctx = HttpContext.Current
        If ctx.Session Is Nothing OrElse Not CBool(If(ctx.Session(SESS_CANRUN), False)) Then
            res("message") = "Tiada kebenaran untuk menjalankan skrip."
            Return res
        End If
        If Not Regex.IsMatch(If(code, ""), "^[A-Z][0-9]{2,4}$") OrElse Not Regex.IsMatch(If(runId, ""), "^[0-9A-Za-z\-]{6,40}$") Then
            res("message") = "Parameter tidak sah."
            Return res
        End If

        Dim user = Convert.ToString(ctx.Session("sessionUserName"))
        Dim block As InitDbGenerator.InitStep = Nothing
        Dim sw = Stopwatch.StartNew()
        Try
            Dim runSql As String = ""
            Using conn As New SqlConnection(TargetConn())
                conn.Open()
                Using cmd As New SqlCommand("SELECT apiSQL FROM dbo.TBL_InitDbApi WHERE apiID = @id AND apiStatus = 1", conn)
                    cmd.Parameters.AddWithValue("@id", InitDbGenerator.ApiRun)
                    runSql = Convert.ToString(cmd.ExecuteScalar())
                End Using
            End Using
            block = InitDbGenerator.SplitRunSql(runSql).FirstOrDefault(Function(b) b.Code = code)
            If block Is Nothing Then Throw New Exception("Langkah " & code & " tiada dalam skrip TBL_InitDbApi. Analisis semula dahulu.")

            Using conn As New SqlConnection(TargetConn())
                conn.Open()
                Using tx = conn.BeginTransaction()
                    Using cmd As New SqlCommand(block.RunSql, conn, tx)
                        cmd.CommandTimeout = 600
                        cmd.ExecuteNonQuery()
                    End Using
                    tx.Commit()
                End Using
            End Using
            res("ok") = True
        Catch ex As Exception
            res("message") = ex.Message
        End Try
        sw.Stop()
        res("ms") = sw.ElapsedMilliseconds

        ' log setiap langkah (gagal log tidak menggagalkan langkah)
        Try
            Using conn As New SqlConnection(TargetConn())
                conn.Open()
                Using cmd As New SqlCommand("INSERT INTO dbo.tbl_sys_InitDbLog (RunID, StepCode, Kind, ObjName, StateBefore, Status, Message, DurationMs, RunBy) VALUES (@r, @c, @k, @o, @sb, @st, @m, @ms, @u)", conn)
                    cmd.Parameters.AddWithValue("@r", runId)
                    cmd.Parameters.AddWithValue("@c", code)
                    cmd.Parameters.AddWithValue("@k", If(block Is Nothing, CObj(DBNull.Value), block.Kind))
                    cmd.Parameters.AddWithValue("@o", If(block Is Nothing, CObj(DBNull.Value), block.Name))
                    cmd.Parameters.AddWithValue("@sb", If(state, ""))
                    cmd.Parameters.AddWithValue("@st", If(CBool(res("ok")), "SUCCESS", "FAILED"))
                    cmd.Parameters.AddWithValue("@m", res("message"))
                    cmd.Parameters.AddWithValue("@ms", CInt(sw.ElapsedMilliseconds))
                    cmd.Parameters.AddWithValue("@u", user)
                    cmd.ExecuteNonQuery()
                End Using
            End Using
        Catch
        End Try
        Return res
    End Function

    ' ================================================================ paparan
    Public Shared Function KindLabel(k As Object) As String
        Select Case Convert.ToString(k)
            Case "TABLE" : Return "Table"
            Case "COLUMN" : Return "Kolum"
            Case "INDEX" : Return "Index"
            Case "FK" : Return "Foreign key"
            Case "DATA" : Return "Data (page & kebenaran)"
            Case "FUNCTION" : Return "Function"
            Case "VIEW" : Return "View"
            Case "PROC" : Return "Stored procedure"
            Case "TRIGGER" : Return "Trigger"
            Case Else : Return Convert.ToString(k)
        End Select
    End Function

    Protected Function StateLabel(s As Object) As String
        Select Case Convert.ToString(s)
            Case "MISSING" : Return "Akan dicipta"
            Case "DIFFERENT" : Return "Akan diganti"
            Case "SAME" : Return "Terkini"
            Case "EXISTS" : Return "Wujud"
            Case Else : Return Convert.ToString(s)
        End Select
    End Function

    Protected Function StateCss(s As Object) As String
        Select Case Convert.ToString(s)
            Case "MISSING" : Return "missing"
            Case "DIFFERENT" : Return "different"
            Case "SAME", "EXISTS" : Return "ok"
            Case Else : Return "info"
        End Select
    End Function

    Protected Function ColsNote(expected As Object, actual As Object, state As Object) As String
        If IsDBNull(expected) OrElse IsDBNull(actual) OrElse Convert.ToString(state) <> "EXISTS" Then Return ""
        If CInt(expected) = CInt(actual) Then Return ""
        Return " <span class=""idb-warnmini"" title=""Bilangan kolum berbeza - table sedia ada tidak diubah"">" & actual.ToString() & "/" & expected.ToString() & " kolum</span>"
    End Function

    Protected Function Pct(part As Integer, whole As Integer) As Integer
        Return If(whole > 0, CInt(Math.Round(part * 100.0 / whole)), 0)
    End Function

    Private Sub ShowError(msg As String)
        pnlError.Visible = True
        litError.Text = HttpUtility.HtmlEncode(msg)
    End Sub

    Private Sub ShowSuccess(msg As String)
        pnlSuccess.Visible = True
        litSuccess.Text = HttpUtility.HtmlEncode(msg)
    End Sub

    ' Popup selepas UpdatePanel selesai dikemas kini (Swal dimuat di hujung master page)
    Private Sub ShowAlert(icon As String, title As String, msg As String)
        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "idbAlert",
            "setTimeout(function () { if (window.Swal) { Swal.fire({ icon: " & Js(icon) & ", title: " & Js(title) & ", text: " & Js(msg) & ", confirmButtonText: 'OK' }); } }, 150);", True)
    End Sub

    Private Shared Function Js(s As String) As String
        Return "'" & HttpUtility.JavaScriptStringEncode(s) & "'"
    End Function

End Class
