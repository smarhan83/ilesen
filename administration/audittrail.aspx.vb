Imports System.Data
Imports System.Data.SqlClient
Imports System.Globalization
Imports System.Linq
Imports System.Text
Imports Pdf = iTextSharp.text
Imports PdfX = iTextSharp.text.pdf

' Audit Trail (TBL_AUDITTRAIL): penapis tarikh / modul / tindakan / pengguna / tajuk,
' ringkasan mengikut kategori tindakan dan senarai dengan paging di pelayan (OFFSET/FETCH).
Partial Class html_administration_audittrail
    Inherits System.Web.UI.Page

    ' Kategori tindakan. Nama baku (GlobalClass.NormalizeAuditAction) dan nama lama dalam rekod sedia ada
    ' (Insert / Update / Delete / Maklumat / Kunci Masuk = tambah rekod, bukan log masuk).
    Private Const KAT_SQL As String =
        "CASE " &
        " WHEN a.AT_Action IN ('Login Gagal','Akses Ditolak') THEN 'fail' " &
        " WHEN a.AT_Action IN ('Muat Naik','Muat Turun','Export') THEN 'doc' " &
        " WHEN a.AT_Action IN ('Hantar','Hantar Permohonan','Hantar Semakan Surat','Tetapkan Pegawai','Hantar Ulasan','Pengesahan Ulasan'," &
        "   'Sokong','Tidak Sokong','Lulus','Tolak','Kembali ke IK','Terbit Surat','Tarik Balik Surat','Keputusan Mesyuarat') THEN 'wf' " &
        " WHEN a.AT_Action IN ('Hantar','Hantar Permohonan','Hantar Semakan Surat','Tetapkan Pegawai','Hantar Ulasan','Pengesahan Ulasan'," &
        "   'Sokong','Tidak Sokong','Lulus','Tolak','Kembali ke IK','Terbit Surat','Tarik Balik Surat','Keputusan Mesyuarat') THEN 'wf' " &
        " WHEN a.AT_Action IN ('Login','Logout','Log Keluar') THEN 'log' " &
        " WHEN a.AT_Action IN ('Delete','Nyah Aktif','Padam','Buang Kebenaran') OR a.AT_Action LIKE 'Delete%' OR a.AT_Action LIKE 'Remove%' OR a.AT_Action LIKE 'Padam%' THEN 'del' " &
        " WHEN a.AT_Action IN ('Insert','Tambah','Daftar','Maklumat','Kunci Masuk') OR a.AT_Action LIKE 'Add%' OR a.AT_Action LIKE 'Insert%' OR a.AT_Action LIKE 'Tambah%' THEN 'add' " &
        " WHEN a.AT_Action IN ('Update','Kemaskini') OR a.AT_Action LIKE 'Update%' OR a.AT_Action LIKE 'Kemaskini%' THEN 'upd' " &
        " ELSE 'oth' END"

    ' AT_Ref / AT_Detail hanya wujud selepas sql/2026-11-14_audittrail_ref_detail.sql dijalankan
    Private ReadOnly Property AdaRef As Boolean
        Get
            Return GlobalClass.AuditAdaKolumTambahan()
        End Get
    End Property

    Private ReadOnly Property RefCols As String
        Get
            Return If(AdaRef, "ISNULL(a.AT_Ref, '') AS AT_Ref, ISNULL(a.AT_Detail, '') AS AT_Detail",
                              "CAST('' AS nvarchar(100)) AS AT_Ref, CAST('' AS nvarchar(max)) AS AT_Detail")
        End Get
    End Property

    Private Property PageIndex As Integer
        Get
            Return If(ViewState("AtPage") Is Nothing, 0, CInt(ViewState("AtPage")))
        End Get
        Set(value As Integer)
            ViewState("AtPage") = value
        End Set
    End Property

    Private ReadOnly Property ConnStr As String
        Get
            Return ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString
        End Get
    End Property

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        ' Muat turun memerlukan postback penuh
        Dim sm As ScriptManager = ScriptManager.GetCurrent(Page)
        If sm IsNot Nothing Then
            sm.RegisterPostBackControl(btnExcel)
            sm.RegisterPostBackControl(btnPdf)
        End If

        If Not IsPostBack Then
            Try
                Dim menuName As String = GlobalClass.writeTitlePage(Request.QueryString("m_Id"), "")
                If Not String.IsNullOrWhiteSpace(menuName) Then idWindowTitle.InnerText = menuName
            Catch ex As Exception
            End Try

            SetDefaultDates()
            LoadFilterLists()
            PageIndex = 0
            BindLog()
        End If
    End Sub

    Protected Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearch.Click
        PageIndex = 0
        BindLog()
    End Sub

    Protected Sub btnReset_Click(sender As Object, e As EventArgs) Handles btnReset.Click
        Response.Redirect(Request.RawUrl)
    End Sub

    Protected Sub ddlRows_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlRows.SelectedIndexChanged
        PageIndex = 0
        BindLog()
    End Sub

    Protected Sub rptPager_ItemCommand(source As Object, e As RepeaterCommandEventArgs) Handles rptPager.ItemCommand
        If e.CommandName = "Page" Then
            PageIndex = CInt(e.CommandArgument)
            BindLog()
        End If
    End Sub

    '===================== PENAPIS =====================
    Private Sub SetDefaultDates()
        ' Lalai: 7 hari terakhir
        txtHingga.Text = DateTime.Today.ToString("yyyy-MM-dd")
        txtDari.Text = DateTime.Today.AddDays(-6).ToString("yyyy-MM-dd")
    End Sub

    ''' <summary>Senarai Module, Action dan User Name diisi terus daripada rekod TBL_AUDITTRAIL.</summary>
    Private Sub LoadFilterLists()
        Using conn As New SqlConnection(ConnStr)
            conn.Open()

            ddlModule.Items.Clear()
            ddlModule.Items.Add(New ListItem("All modules", ""))
            For Each v As String In ReadList(conn, "SELECT DISTINCT AT_Module FROM TBL_AUDITTRAIL WHERE ISNULL(AT_Module,'') <> '' ORDER BY AT_Module")
                ddlModule.Items.Add(New ListItem(v, v))
            Next

            ddlAction.Items.Clear()
            ddlAction.Items.Add(New ListItem("All actions", ""))
            For Each v As String In ReadList(conn, "SELECT DISTINCT AT_Action FROM TBL_AUDITTRAIL WHERE ISNULL(AT_Action,'') <> '' ORDER BY AT_Action")
                ddlAction.Items.Add(New ListItem(v, v))
            Next

            ' Pengguna yang ada rekod audit; papar nama penuh dari TBL_USERS jika ada
            ddlUser.Items.Clear()
            ddlUser.Items.Add(New ListItem("Any user", ""))
            Dim sql As String =
                "SELECT x.AT_UserName, MAX(u.Users_Fullname) AS FullName " &
                "FROM (SELECT DISTINCT AT_UserName, AT_UserId FROM TBL_AUDITTRAIL WHERE ISNULL(AT_UserName,'') <> '') x " &
                "LEFT JOIN TBL_USERS u ON u.Users_Id = x.AT_UserId " &
                "GROUP BY x.AT_UserName ORDER BY x.AT_UserName"
            Using cmd As New SqlCommand(sql, conn)
                Using rdr As SqlDataReader = cmd.ExecuteReader()
                    While rdr.Read()
                        Dim uname As String = Convert.ToString(rdr("AT_UserName"))
                        Dim fname As String = Convert.ToString(rdr("FullName")).Trim()
                        Dim teks As String = If(fname = "" OrElse String.Equals(fname, uname, StringComparison.OrdinalIgnoreCase), uname, uname & " - " & fname)
                        ddlUser.Items.Add(New ListItem(teks, uname))
                    End While
                End Using
            End Using
        End Using
    End Sub

    Private Shared Function ReadList(ByVal conn As SqlConnection, ByVal sql As String) As List(Of String)
        Dim list As New List(Of String)()
        Using cmd As New SqlCommand(sql, conn)
            Using rdr As SqlDataReader = cmd.ExecuteReader()
                While rdr.Read()
                    list.Add(Convert.ToString(rdr(0)))
                End While
            End Using
        End Using
        Return list
    End Function

    Private Function Julat() As Tuple(Of DateTime, DateTime)
        Dim dari As DateTime = DateTime.Today.AddDays(-6)
        Dim hingga As DateTime = DateTime.Today
        Dim t As DateTime
        If DateTime.TryParse(txtDari.Text, CultureInfo.InvariantCulture, DateTimeStyles.None, t) Then dari = t.Date
        If DateTime.TryParse(txtHingga.Text, CultureInfo.InvariantCulture, DateTimeStyles.None, t) Then hingga = t.Date
        If hingga < dari Then
            Dim tmp As DateTime = dari : dari = hingga : hingga = tmp
        End If
        Return Tuple.Create(dari, hingga)
    End Function

    ' Kata kunci dicari dalam Title, dan juga Rujukan / Butiran jika kolum tersebut wujud
    Private ReadOnly Property WHERE_SQL As String
        Get
            Return " WHERE a.AT_datetime >= @Dari AND a.AT_datetime < @HinggaPlus1 " &
                   "   AND (@Module = '' OR a.AT_Module = @Module) " &
                   "   AND (@Action = '' OR a.AT_Action = @Action) " &
                   "   AND (@User = '' OR a.AT_UserName = @User) " &
                   "   AND (@Title = '' OR a.AT_Title LIKE '%' + @Title + '%'" &
                   If(AdaRef, " OR a.AT_Ref LIKE '%' + @Title + '%' OR a.AT_Detail LIKE '%' + @Title + '%'", "") & ") "
        End Get
    End Property

    Private Sub AddFilterParams(ByVal cmd As SqlCommand)
        Dim j As Tuple(Of DateTime, DateTime) = Julat()
        cmd.Parameters.Add("@Dari", SqlDbType.DateTime).Value = j.Item1
        cmd.Parameters.Add("@HinggaPlus1", SqlDbType.DateTime).Value = j.Item2.AddDays(1)
        cmd.Parameters.Add("@Module", SqlDbType.VarChar, 100).Value = ddlModule.SelectedValue
        cmd.Parameters.Add("@Action", SqlDbType.VarChar, 100).Value = ddlAction.SelectedValue
        cmd.Parameters.Add("@User", SqlDbType.VarChar, 225).Value = ddlUser.SelectedValue
        cmd.Parameters.Add("@Title", SqlDbType.VarChar, 200).Value = txtTitle.Text.Trim()
    End Sub

    '===================== DATA =====================
    Private Sub BindLog()
        Dim rows As Integer = 25
        Integer.TryParse(ddlRows.SelectedValue, rows)
        If rows <= 0 Then rows = 25

        Dim total As Integer = 0
        Using conn As New SqlConnection(ConnStr)
            conn.Open()

            ' Ringkasan mengikut kategori (ikut penapis semasa)
            Dim sqlStat As String =
                "SELECT COUNT(*) AS Total, " &
                "  SUM(CASE WHEN k.Kat = 'add' THEN 1 ELSE 0 END) AS AddCnt, " &
                "  SUM(CASE WHEN k.Kat = 'upd' THEN 1 ELSE 0 END) AS UpdCnt, " &
                "  SUM(CASE WHEN k.Kat = 'del' THEN 1 ELSE 0 END) AS DelCnt, " &
                "  SUM(CASE WHEN k.Kat = 'log' THEN 1 ELSE 0 END) AS LogCnt, " &
                "  SUM(CASE WHEN k.Kat = 'wf' THEN 1 ELSE 0 END) AS WfCnt, " &
                "  SUM(CASE WHEN k.Kat = 'doc' THEN 1 ELSE 0 END) AS DocCnt, " &
                "  SUM(CASE WHEN k.Kat = 'fail' THEN 1 ELSE 0 END) AS FailCnt " &
                "FROM TBL_AUDITTRAIL a CROSS APPLY (SELECT " & KAT_SQL & " AS Kat) k " & WHERE_SQL
            Using cmd As New SqlCommand(sqlStat, conn)
                cmd.CommandTimeout = 120
                AddFilterParams(cmd)
                Using rdr As SqlDataReader = cmd.ExecuteReader()
                    If rdr.Read() Then
                        total = ToInt(rdr("Total"))
                        litTotal.Text = total.ToString("N0")
                        litTotalStat.Text = litTotal.Text
                        litAdd.Text = ToInt(rdr("AddCnt")).ToString("N0")
                        litUpd.Text = ToInt(rdr("UpdCnt")).ToString("N0")
                        litDel.Text = ToInt(rdr("DelCnt")).ToString("N0")
                        litLog.Text = ToInt(rdr("LogCnt")).ToString("N0")
                        litFail.Text = ToInt(rdr("FailCnt")).ToString("N0")
                        litWf.Text = ToInt(rdr("WfCnt")).ToString("N0")
                        litDoc.Text = ToInt(rdr("DocCnt")).ToString("N0")
                    End If
                End Using
            End Using

            Dim pageCount As Integer = Math.Max(1, CInt(Math.Ceiling(total / CDbl(rows))))
            If PageIndex >= pageCount Then PageIndex = pageCount - 1
            If PageIndex < 0 Then PageIndex = 0

            ' Satu halaman sahaja dibaca dari pangkalan data
            Dim dt As DataTable = QueryLog(conn, PageIndex * rows, rows)

            rptLog.DataSource = dt
            rptLog.DataBind()
            rptLog.Visible = dt.Rows.Count > 0
            phEmpty.Visible = dt.Rows.Count = 0

            Dim first As Integer = If(total = 0, 0, PageIndex * rows + 1)
            Dim last As Integer = Math.Min(total, (PageIndex + 1) * rows)
            litShowing.Text = "Showing " & first.ToString("N0") & "&ndash;" & last.ToString("N0") & " of " & total.ToString("N0") & " records"

            BindPager(pageCount)
        End Using
    End Sub

    ''' <summary>Rekod audit ikut penapis semasa, terbaru dahulu (skip / take untuk paging dan eksport).</summary>
    Private Function QueryLog(ByVal conn As SqlConnection, ByVal skip As Integer, ByVal take As Integer) As DataTable
        Dim sql As String =
            "SELECT a.AT_Id, a.AT_UserId, a.AT_UserName, a.AT_IP, a.AT_Action, a.AT_Module, " &
            "       CAST(a.AT_Title AS varchar(max)) AS AT_Title, a.AT_datetime, " &
            "       ISNULL(u.Users_Fullname, '') AS FullName, k.Kat, " & RefCols & " " &
            "FROM TBL_AUDITTRAIL a " &
            "LEFT JOIN TBL_USERS u ON u.Users_Id = a.AT_UserId " &
            "CROSS APPLY (SELECT " & KAT_SQL & " AS Kat) k " & WHERE_SQL &
            "ORDER BY a.AT_datetime DESC, a.AT_Id DESC " &
            "OFFSET @Skip ROWS FETCH NEXT @Take ROWS ONLY"
        Dim dt As New DataTable()
        Using cmd As New SqlCommand(sql, conn)
            cmd.CommandTimeout = 300
            AddFilterParams(cmd)
            cmd.Parameters.Add("@Skip", SqlDbType.Int).Value = skip
            cmd.Parameters.Add("@Take", SqlDbType.Int).Value = take
            Using da As New SqlDataAdapter(cmd)
                da.Fill(dt)
            End Using
        End Using
        Return dt
    End Function

    Private Sub BindPager(ByVal pageCount As Integer)
        Dim items As New List(Of Object)()
        If pageCount > 1 Then
            Dim cur As Integer = PageIndex
            items.Add(New With {.Page = cur - 1, .Text = "&lsaquo; Prev", .Enabled = cur > 0, .Current = False})
            Dim mula As Integer = Math.Max(0, cur - 2)
            Dim akhir As Integer = Math.Min(pageCount - 1, mula + 4)
            mula = Math.Max(0, akhir - 4)
            If mula > 0 Then
                items.Add(New With {.Page = 0, .Text = "1", .Enabled = True, .Current = False})
                If mula > 1 Then items.Add(New With {.Page = 0, .Text = "&hellip;", .Enabled = False, .Current = False})
            End If
            For p As Integer = mula To akhir
                items.Add(New With {.Page = p, .Text = (p + 1).ToString(), .Enabled = True, .Current = (p = cur)})
            Next
            If akhir < pageCount - 1 Then
                If akhir < pageCount - 2 Then items.Add(New With {.Page = 0, .Text = "&hellip;", .Enabled = False, .Current = False})
                items.Add(New With {.Page = pageCount - 1, .Text = pageCount.ToString(), .Enabled = True, .Current = False})
            End If
            items.Add(New With {.Page = cur + 1, .Text = "Next &rsaquo;", .Enabled = cur < pageCount - 1, .Current = False})
        End If
        rptPager.DataSource = items
        rptPager.DataBind()
        rptPager.Visible = items.Count > 0
    End Sub

    Private Shared Function ToInt(ByVal v As Object) As Integer
        If v Is Nothing OrElse IsDBNull(v) Then Return 0
        Return Convert.ToInt32(v)
    End Function

    '===================== EKSPORT (EXCEL / PDF) =====================
    ' Eksport mengikut penapis semasa (semua halaman). PDF dihadkan supaya fail kekal boleh dibuka.
    Private Const MAX_EXCEL As Integer = 500000
    Private Const MAX_PDF As Integer = 10000

    Protected Sub btnExcel_Click(sender As Object, e As EventArgs) Handles btnExcel.Click
        Dim dt As DataTable
        Using conn As New SqlConnection(ConnStr)
            conn.Open()
            dt = QueryLog(conn, 0, MAX_EXCEL)
        End Using
        LogEksport("Excel", dt.Rows.Count)
        HantarFail(BinaXlsx(dt), "AuditTrail_" & DateTime.Now.ToString("yyyyMMdd_HHmm") & ".xlsx",
                   "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
    End Sub

    Protected Sub btnPdf_Click(sender As Object, e As EventArgs) Handles btnPdf.Click
        Dim dt As DataTable
        Dim total As Integer
        Using conn As New SqlConnection(ConnStr)
            conn.Open()
            dt = QueryLog(conn, 0, MAX_PDF)
            total = KiraJumlah(conn)
        End Using
        LogEksport("PDF", dt.Rows.Count)
        HantarFail(BinaPdf(dt, total), "AuditTrail_" & DateTime.Now.ToString("yyyyMMdd_HHmm") & ".pdf", "application/pdf")
    End Sub

    Private Function KiraJumlah(ByVal conn As SqlConnection) As Integer
        Using cmd As New SqlCommand("SELECT COUNT(*) FROM TBL_AUDITTRAIL a " & WHERE_SQL, conn)
            cmd.CommandTimeout = 300
            AddFilterParams(cmd)
            Return Convert.ToInt32(cmd.ExecuteScalar())
        End Using
    End Function

    ''' <summary>Muat turun log audit itu sendiri direkodkan dalam audit trail.</summary>
    Private Sub LogEksport(ByVal jenis As String, ByVal bil As Integer)
        Try
            GlobalClass.auditTrail("Audit Trail", "Export " & jenis & " (" & bil & " records) - " & TeksPenapis(), "Export")
        Catch ex As Exception
        End Try
    End Sub

    Private Sub HantarFail(ByVal data As Byte(), ByVal nama As String, ByVal jenis As String)
        Response.Clear()
        Response.Buffer = True
        Response.ContentType = jenis
        Response.AddHeader("Content-Disposition", "attachment; filename=" & nama)
        Response.AddHeader("Content-Length", data.Length.ToString())
        Response.BinaryWrite(data)
        Response.Flush()
        Response.SuppressContent = True   ' jangan tambah HTML page selepas fail
        HttpContext.Current.ApplicationInstance.CompleteRequest()
    End Sub

    ''' <summary>Ringkasan penapis untuk tajuk fail eksport, cth. "07/11/2026 - 13/11/2026 | Module: Login Form".</summary>
    Private Function TeksPenapis() As String
        Dim j As Tuple(Of DateTime, DateTime) = Julat()
        Dim parts As New List(Of String) From {j.Item1.ToString("dd/MM/yyyy") & " - " & j.Item2.ToString("dd/MM/yyyy")}
        If ddlModule.SelectedValue <> "" Then parts.Add("Module: " & ddlModule.SelectedValue)
        If ddlAction.SelectedValue <> "" Then parts.Add("Action: " & ddlAction.SelectedValue)
        If ddlUser.SelectedValue <> "" Then parts.Add("User: " & ddlUser.SelectedValue)
        If txtTitle.Text.Trim() <> "" Then parts.Add("Keyword: " & txtTitle.Text.Trim())
        Return String.Join(" | ", parts)
    End Function

    Private Function DijanaOleh() As String
        Dim ctx As HttpContext = HttpContext.Current
        Dim u As String = If(ctx IsNot Nothing AndAlso ctx.Session IsNot Nothing, Convert.ToString(ctx.Session("sessionUserName")), "")
        Return "Generated " & DateTime.Now.ToString("dd/MM/yyyy hh:mm tt") & If(u = "", "", " by " & u)
    End Function

    '----- Excel (.xlsx sebenar tanpa pustaka luar, sama seperti Laporan Inspektorat) -----
    Private Shared ReadOnly LebarLajur() As Double = {6, 24, 18, 9, 28, 20, 20, 60, 16, 24, 50}

    Private Function BinaXlsx(ByVal dt As DataTable) As Byte()
        Dim ms As New IO.MemoryStream()
        Using zip As New IO.Compression.ZipArchive(ms, IO.Compression.ZipArchiveMode.Create, True)
            TulisBahagian(zip, "[Content_Types].xml",
                "<?xml version=""1.0"" encoding=""UTF-8"" standalone=""yes""?>" &
                "<Types xmlns=""http://schemas.openxmlformats.org/package/2006/content-types"">" &
                "<Default Extension=""rels"" ContentType=""application/vnd.openxmlformats-package.relationships+xml""/>" &
                "<Default Extension=""xml"" ContentType=""application/xml""/>" &
                "<Override PartName=""/xl/workbook.xml"" ContentType=""application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml""/>" &
                "<Override PartName=""/xl/worksheets/sheet1.xml"" ContentType=""application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml""/>" &
                "<Override PartName=""/xl/styles.xml"" ContentType=""application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml""/>" &
                "</Types>")
            TulisBahagian(zip, "_rels/.rels",
                "<?xml version=""1.0"" encoding=""UTF-8"" standalone=""yes""?>" &
                "<Relationships xmlns=""http://schemas.openxmlformats.org/package/2006/relationships"">" &
                "<Relationship Id=""rId1"" Type=""http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument"" Target=""xl/workbook.xml""/>" &
                "</Relationships>")
            TulisBahagian(zip, "xl/workbook.xml",
                "<?xml version=""1.0"" encoding=""UTF-8"" standalone=""yes""?>" &
                "<workbook xmlns=""http://schemas.openxmlformats.org/spreadsheetml/2006/main"" xmlns:r=""http://schemas.openxmlformats.org/officeDocument/2006/relationships"">" &
                "<sheets><sheet name=""Audit Trail"" sheetId=""1"" r:id=""rId1""/></sheets></workbook>")
            TulisBahagian(zip, "xl/_rels/workbook.xml.rels",
                "<?xml version=""1.0"" encoding=""UTF-8"" standalone=""yes""?>" &
                "<Relationships xmlns=""http://schemas.openxmlformats.org/package/2006/relationships"">" &
                "<Relationship Id=""rId1"" Type=""http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet"" Target=""worksheets/sheet1.xml""/>" &
                "<Relationship Id=""rId2"" Type=""http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles"" Target=""styles.xml""/>" &
                "</Relationships>")
            TulisBahagian(zip, "xl/styles.xml", GayaXlsx())
            TulisBahagian(zip, "xl/worksheets/sheet1.xml", LembaranXlsx(dt))
        End Using
        Return ms.ToArray()
    End Function

    Private Shared Sub TulisBahagian(ByVal zip As IO.Compression.ZipArchive, ByVal nama As String, ByVal kandungan As String)
        Dim en As IO.Compression.ZipArchiveEntry = zip.CreateEntry(nama, IO.Compression.CompressionLevel.Optimal)
        Using s As IO.Stream = en.Open()
            Dim b As Byte() = New UTF8Encoding(False).GetBytes(kandungan)
            s.Write(b, 0, b.Length)
        End Using
    End Sub

    ' Indeks gaya: 0 biasa, 1 tajuk, 2 nota kecil, 3 kepala jadual, 4 teks, 5 tengah, 6 tarikh+masa
    Private Shared Function GayaXlsx() As String
        Dim sb As New StringBuilder()
        sb.Append("<?xml version=""1.0"" encoding=""UTF-8"" standalone=""yes""?>")
        sb.Append("<styleSheet xmlns=""http://schemas.openxmlformats.org/spreadsheetml/2006/main"">")
        sb.Append("<numFmts count=""1""><numFmt numFmtId=""164"" formatCode=""dd/mm/yyyy hh:mm:ss AM/PM""/></numFmts>")
        sb.Append("<fonts count=""4"">")
        sb.Append("<font><sz val=""10""/><name val=""Calibri""/></font>")
        sb.Append("<font><b/><sz val=""14""/><name val=""Calibri""/></font>")
        sb.Append("<font><sz val=""10""/><color rgb=""FF555555""/><name val=""Calibri""/></font>")
        sb.Append("<font><b/><sz val=""10""/><name val=""Calibri""/></font>")
        sb.Append("</fonts>")
        sb.Append("<fills count=""3""><fill><patternFill patternType=""none""/></fill><fill><patternFill patternType=""gray125""/></fill>")
        sb.Append("<fill><patternFill patternType=""solid""><fgColor rgb=""FFEEF1FA""/><bgColor indexed=""64""/></patternFill></fill></fills>")
        sb.Append("<borders count=""2""><border><left/><right/><top/><bottom/><diagonal/></border>")
        sb.Append("<border><left style=""thin""><color rgb=""FFBBBBBB""/></left><right style=""thin""><color rgb=""FFBBBBBB""/></right><top style=""thin""><color rgb=""FFBBBBBB""/></top><bottom style=""thin""><color rgb=""FFBBBBBB""/></bottom><diagonal/></border></borders>")
        sb.Append("<cellStyleXfs count=""1""><xf numFmtId=""0"" fontId=""0"" fillId=""0"" borderId=""0""/></cellStyleXfs>")
        sb.Append("<cellXfs count=""7"">")
        sb.Append("<xf numFmtId=""0"" fontId=""0"" fillId=""0"" borderId=""0"" xfId=""0""/>")
        sb.Append("<xf numFmtId=""0"" fontId=""1"" fillId=""0"" borderId=""0"" xfId=""0"" applyFont=""1""/>")
        sb.Append("<xf numFmtId=""0"" fontId=""2"" fillId=""0"" borderId=""0"" xfId=""0"" applyFont=""1""/>")
        sb.Append("<xf numFmtId=""0"" fontId=""3"" fillId=""2"" borderId=""1"" xfId=""0"" applyFont=""1"" applyFill=""1"" applyBorder=""1"" applyAlignment=""1""><alignment horizontal=""center"" vertical=""center"" wrapText=""1""/></xf>")
        sb.Append("<xf numFmtId=""0"" fontId=""0"" fillId=""0"" borderId=""1"" xfId=""0"" applyBorder=""1"" applyAlignment=""1""><alignment vertical=""top"" wrapText=""1""/></xf>")
        sb.Append("<xf numFmtId=""0"" fontId=""0"" fillId=""0"" borderId=""1"" xfId=""0"" applyBorder=""1"" applyAlignment=""1""><alignment horizontal=""center"" vertical=""top""/></xf>")
        sb.Append("<xf numFmtId=""164"" fontId=""0"" fillId=""0"" borderId=""1"" xfId=""0"" applyNumberFormat=""1"" applyBorder=""1"" applyAlignment=""1""><alignment horizontal=""center"" vertical=""top""/></xf>")
        sb.Append("</cellXfs>")
        sb.Append("<cellStyles count=""1""><cellStyle name=""Normal"" xfId=""0"" builtinId=""0""/></cellStyles>")
        sb.Append("</styleSheet>")
        Return sb.ToString()
    End Function

    Private Function LembaranXlsx(ByVal dt As DataTable) As String
        Dim sb As New StringBuilder()
        sb.Append("<?xml version=""1.0"" encoding=""UTF-8"" standalone=""yes""?>")
        sb.Append("<worksheet xmlns=""http://schemas.openxmlformats.org/spreadsheetml/2006/main"">")
        sb.Append("<sheetViews><sheetView workbookViewId=""0""><pane ySplit=""5"" topLeftCell=""A6"" activePane=""bottomLeft"" state=""frozen""/><selection pane=""bottomLeft""/></sheetView></sheetViews>")
        sb.Append("<sheetFormatPr defaultRowHeight=""15""/>")
        sb.Append("<cols>")
        For i As Integer = 0 To LebarLajur.Length - 1
            sb.Append("<col min=""" & (i + 1) & """ max=""" & (i + 1) & """ width=""" & LebarLajur(i).ToString(CultureInfo.InvariantCulture) & """ customWidth=""1""/>")
        Next
        sb.Append("</cols><sheetData>")

        sb.Append("<row r=""1"" ht=""22"" customHeight=""1"">" & SelStr("A1", "AUDIT TRAIL", 1) & "</row>")
        sb.Append("<row r=""2"">" & SelStr("A2", "ProLesen - Majlis Perbandaran Kluang | " & TeksPenapis(), 2) & "</row>")
        sb.Append("<row r=""3"">" & SelStr("A3", DijanaOleh() & " | " & dt.Rows.Count.ToString("N0") & " records", 2) & "</row>")

        Dim tajuk() As String = {"No.", "Date / Time", "User Name", "User ID", "Full Name", "Action", "Module", "Title", "IP Address", "Reference", "Detail"}
        sb.Append("<row r=""5"">")
        For i As Integer = 0 To tajuk.Length - 1
            sb.Append(SelStr(Ruj(i, 5), tajuk(i), 3))
        Next
        sb.Append("</row>")

        Dim baris As Integer = 5
        For Each r As DataRow In dt.Rows
            baris += 1
            sb.Append("<row r=""" & baris & """>")
            sb.Append(SelNum(Ruj(0, baris), baris - 5, 5))
            sb.Append(SelTarikhMasa(Ruj(1, baris), r("AT_datetime")))
            sb.Append(SelStr(Ruj(2, baris), Convert.ToString(r("AT_UserName")), 4))
            sb.Append(SelNum(Ruj(3, baris), ToInt(r("AT_UserId")), 5))
            sb.Append(SelStr(Ruj(4, baris), Convert.ToString(r("FullName")), 4))
            sb.Append(SelStr(Ruj(5, baris), Convert.ToString(r("AT_Action")), 4))
            sb.Append(SelStr(Ruj(6, baris), Convert.ToString(r("AT_Module")), 4))
            sb.Append(SelStr(Ruj(7, baris), Convert.ToString(r("AT_Title")), 4))
            sb.Append(SelStr(Ruj(8, baris), Convert.ToString(r("AT_IP")), 4))
            sb.Append(SelStr(Ruj(9, baris), Convert.ToString(r("AT_Ref")), 4))
            sb.Append(SelStr(Ruj(10, baris), Convert.ToString(r("AT_Detail")), 4))
            sb.Append("</row>")
        Next

        sb.Append("</sheetData>")
        If baris > 5 Then sb.Append("<autoFilter ref=""A5:K" & baris & """/>")
        sb.Append("<pageMargins left=""0.4"" right=""0.4"" top=""0.5"" bottom=""0.5"" header=""0.3"" footer=""0.3""/>")
        sb.Append("<pageSetup paperSize=""9"" orientation=""landscape""/>")
        sb.Append("</worksheet>")
        Return sb.ToString()
    End Function

    Private Shared Function Ruj(ByVal lajur As Integer, ByVal baris As Integer) As String
        Return Convert.ToChar(Asc("A") + lajur).ToString() & baris
    End Function

    ''' <summary>Buang aksara kawalan yang tidak sah dalam XML, kemudian escape.</summary>
    Private Shared Function Esc(ByVal s As String) As String
        If String.IsNullOrEmpty(s) Then Return ""
        Dim bersih As New StringBuilder(s.Length)
        For Each c As Char In s
            If c = vbTab OrElse c = vbLf OrElse c = vbCr OrElse AscW(c) >= 32 Then bersih.Append(c)
        Next
        Return System.Security.SecurityElement.Escape(bersih.ToString())
    End Function

    Private Shared Function SelStr(ByVal rujukan As String, ByVal teks As String, ByVal gaya As Integer) As String
        Return "<c r=""" & rujukan & """ s=""" & gaya & """ t=""inlineStr""><is><t xml:space=""preserve"">" & Esc(teks) & "</t></is></c>"
    End Function

    Private Shared Function SelNum(ByVal rujukan As String, ByVal nilai As Integer, ByVal gaya As Integer) As String
        Return "<c r=""" & rujukan & """ s=""" & gaya & """><v>" & nilai & "</v></c>"
    End Function

    Private Shared Function SelTarikhMasa(ByVal rujukan As String, ByVal v As Object) As String
        If v Is Nothing OrElse IsDBNull(v) Then Return SelStr(rujukan, "-", 5)
        Dim siri As Double = (Convert.ToDateTime(v) - New DateTime(1899, 12, 30)).TotalDays
        Return "<c r=""" & rujukan & """ s=""6""><v>" & siri.ToString("0.########", CultureInfo.InvariantCulture) & "</v></c>"
    End Function

    '----- PDF (iTextSharp, A4 landskap, kepala jadual berulang setiap halaman) -----
    Private Function BinaPdf(ByVal dt As DataTable, ByVal total As Integer) As Byte()
        Dim ms As New IO.MemoryStream()
        Dim doc As New Pdf.Document(Pdf.PageSize.A4.Rotate(), 28, 28, 30, 34)
        Dim writer As PdfX.PdfWriter = PdfX.PdfWriter.GetInstance(doc, ms)
        writer.PageEvent = New KakiPdf(DijanaOleh())
        doc.AddTitle("Audit Trail")
        doc.Open()

        Dim biru As New Pdf.BaseColor(&H23, &H26, &H7A)
        Dim kelabu As New Pdf.BaseColor(&H5B, &H64, &H78)
        Dim fTajuk As Pdf.Font = Pdf.FontFactory.GetFont(Pdf.FontFactory.HELVETICA_BOLD, 14, biru)
        Dim fNota As Pdf.Font = Pdf.FontFactory.GetFont(Pdf.FontFactory.HELVETICA, 8.5F, kelabu)
        Dim fKepala As Pdf.Font = Pdf.FontFactory.GetFont(Pdf.FontFactory.HELVETICA_BOLD, 7.5F, New Pdf.BaseColor(&H3F, &H4A, &H6B))
        Dim fSel As Pdf.Font = Pdf.FontFactory.GetFont(Pdf.FontFactory.HELVETICA, 7.5F, Pdf.BaseColor.BLACK)

        doc.Add(New Pdf.Paragraph("AUDIT TRAIL", fTajuk))
        doc.Add(New Pdf.Paragraph("ProLesen - Majlis Perbandaran Kluang  |  " & TeksPenapis(), fNota))
        Dim ringkas As String = dt.Rows.Count.ToString("N0") & " records"
        If total > dt.Rows.Count Then
            ringkas &= " (first " & dt.Rows.Count.ToString("N0") & " of " & total.ToString("N0") & " - use Excel for the full list)"
        End If
        Dim pNota As New Pdf.Paragraph(ringkas, fNota)
        pNota.SpacingAfter = 8
        doc.Add(pNota)

        Dim tbl As New PdfX.PdfPTable(9)
        tbl.WidthPercentage = 100
        tbl.SetWidths(New Single() {4, 11, 15, 8, 11, 10, 11, 23, 7})
        tbl.HeaderRows = 1
        For Each h As String In {"No.", "Date / Time", "User", "Action", "Module", "IP Address", "Reference", "Title / Detail", "Record ID"}
            Dim c As New PdfX.PdfPCell(New Pdf.Phrase(h, fKepala))
            c.BackgroundColor = New Pdf.BaseColor(&HEE, &HF1, &HFA)
            c.BorderColor = New Pdf.BaseColor(&HDD, &HE2, &HEE)
            c.Padding = 4
            tbl.AddCell(c)
        Next
        Dim bil As Integer = 0
        Dim zebra As New Pdf.BaseColor(&HF8, &HFA, &HFE)
        For Each r As DataRow In dt.Rows
            bil += 1
            Dim latar As Pdf.BaseColor = If(bil Mod 2 = 0, zebra, Pdf.BaseColor.WHITE)
            Dim pengguna As String = Convert.ToString(r("AT_UserName")) & " (ID " & Convert.ToString(r("AT_UserId")) & ")"
            If Convert.ToString(r("FullName")) <> "" Then pengguna &= vbLf & Convert.ToString(r("FullName"))
            For Each v As String In {bil.ToString(),
                                     Convert.ToDateTime(r("AT_datetime")).ToString("dd/MM/yyyy hh:mm:ss tt"),
                                     pengguna,
                                     Convert.ToString(r("AT_Action")),
                                     Convert.ToString(r("AT_Module")),
                                     Convert.ToString(r("AT_IP")),
                                     Convert.ToString(r("AT_Ref")),
                                     TajukDanButiran(r),
                                     Convert.ToString(r("AT_Id"))}
                Dim c As New PdfX.PdfPCell(New Pdf.Phrase(v, fSel))
                c.BackgroundColor = latar
                c.BorderColor = New Pdf.BaseColor(&HE6, &HEB, &HF5)
                c.Padding = 3.5F
                tbl.AddCell(c)
            Next
        Next
        If dt.Rows.Count = 0 Then
            Dim c As New PdfX.PdfPCell(New Pdf.Phrase("No activity found for the selected filters.", fSel))
            c.Colspan = 9
            c.Padding = 10
            c.HorizontalAlignment = Pdf.Element.ALIGN_CENTER
            tbl.AddCell(c)
        End If
        doc.Add(tbl)
        doc.Close()
        Return ms.ToArray()
    End Function

    Private Shared Function TajukDanButiran(ByVal r As DataRow) As String
        Dim t As String = Convert.ToString(r("AT_Title"))
        Dim d As String = Convert.ToString(r("AT_Detail"))
        Return If(d = "", t, t & vbLf & "Detail: " & d)
    End Function

    ''' <summary>Kaki setiap halaman PDF: dijana oleh / tarikh (kiri) dan nombor halaman (kanan).</summary>
    Private Class KakiPdf
        Inherits PdfX.PdfPageEventHelper
        Private ReadOnly _teks As String
        Public Sub New(ByVal teks As String)
            _teks = teks
        End Sub
        Public Overrides Sub OnEndPage(ByVal writer As PdfX.PdfWriter, ByVal document As Pdf.Document)
            Dim f As Pdf.Font = Pdf.FontFactory.GetFont(Pdf.FontFactory.HELVETICA, 7.5F, New Pdf.BaseColor(&H6C, &H75, &H7D))
            Dim cb As PdfX.PdfContentByte = writer.DirectContent
            Dim y As Single = document.BottomMargin - 16
            PdfX.ColumnText.ShowTextAligned(cb, Pdf.Element.ALIGN_LEFT, New Pdf.Phrase(_teks, f), document.LeftMargin, y, 0)
            PdfX.ColumnText.ShowTextAligned(cb, Pdf.Element.ALIGN_RIGHT, New Pdf.Phrase("Page " & writer.PageNumber, f), document.PageSize.Width - document.RightMargin, y, 0)
        End Sub
    End Class

    '===================== PAPARAN =====================
    ''' <summary>Dua huruf pertama nama pengguna (cth. admin -> AD).</summary>
    Protected Shared Function Initials(ByVal v As Object) As String
        Dim s As String = New String(Convert.ToString(v).Where(Function(c) Char.IsLetterOrDigit(c)).ToArray())
        If s = "" Then Return "?"
        Return s.Substring(0, Math.Min(2, s.Length)).ToUpperInvariant()
    End Function

    Private Shared ReadOnly WarnaAvatar As String() = {"#E3A33B", "#5DB37E", "#5B8DEF", "#9B6BDF", "#E06C75", "#3DB2C2", "#D9822B", "#7A8295"}

    ''' <summary>Warna avatar tetap bagi setiap nama pengguna.</summary>
    Protected Shared Function AvatarColour(ByVal v As Object) As String
        Dim s As String = Convert.ToString(v)
        Dim h As Long = 0
        For Each c As Char In s
            h = (h * 31 + AscW(c)) Mod 1000000007L
        Next
        Return WarnaAvatar(CInt(h Mod WarnaAvatar.Length))
    End Function

    ''' <summary>Tajuk dipendekkan dalam jadual; tajuk penuh dalam butiran.</summary>
    Protected Shared Function Ringkas(ByVal v As Object) As String
        Dim s As String = Convert.ToString(v)
        If s.Length <= 120 Then Return s
        Return s.Substring(0, 117) & "..."
    End Function

End Class
