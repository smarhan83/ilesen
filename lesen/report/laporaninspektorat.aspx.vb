Imports System.Data
Imports System.Data.SqlClient
Imports System.Globalization
Imports System.Text

' Laporan Inspektorat - tempoh proses permohonan di Bahagian Inspektorat (KPI: kurang 14 hari).
' Sumber tarikh (agensi = Bahagian Inspektorat, JabatanAgensi_ID = 3):
'   Tarikh Diterima        : LESEN_ApprovalList (ApprStatusID 2, agensi ini) CreatedDt - agensi menerima permohonan; jika tiada, TarikhMohon
'   Tarikh Penetapan       : LESEN_ApprovalList ApprStatusID 2 (Pilih Pegawai Lawatan Tapak) ApprovalDate
'   Tarikh Siasatan Tapak  : LESEN_ApprovalList ApprStatusID 3 (Lawatan Tapak) ApprovalDate
'   Tarikh Ulasan Teknikal : ulasan pertama oleh pegawai Inspektorat - MIN(LESEN_UlasanFail.CreatedDt) bagi permohonan ini, pengguna dengan estate_id = agensi
'   Tarikh Semakan & Hantar: LESEN_ApprovalList ApprStatusID 4 (Pengesah Jabatan/Agensi) ApprovalDate; jika tiada, LESEN_PermohonanAgensi.LastModDt bila StatusID = 3
Partial Class laporaninspektorat
    Inherits System.Web.UI.Page

    Private Const AGENSI_INSPEKTORAT As Integer = 3
    Private Const KPI_HARI As Integer = 14

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        ' Eksport memerlukan postback penuh (bukan UpdatePanel)
        Dim sm As ScriptManager = TryCast(ScriptManager.GetCurrent(Page), ScriptManager)
        If sm IsNot Nothing Then sm.RegisterPostBackControl(btnExcel)

        If Not IsPostBack Then
            Dim menuName As String = ""
            Try
                menuName = GlobalClass.writeTitlePage(Request.QueryString("m_Id"), "")
            Catch ex As Exception
            End Try
            If Not String.IsNullOrWhiteSpace(menuName) Then idWindowTitle.InnerText = menuName

            txtDari.Text = New DateTime(DateTime.Today.Year, 1, 1).ToString("yyyy-MM-dd")
            txtHingga.Text = DateTime.Today.ToString("yyyy-MM-dd")
            BindLaporan()
        End If
    End Sub

    Protected Sub btnJana_Click(sender As Object, e As EventArgs) Handles btnJana.Click
        BindLaporan()
    End Sub

    Protected Sub btnReset_Click(sender As Object, e As EventArgs) Handles btnReset.Click
        Response.Redirect(Request.RawUrl)
    End Sub

    Protected Sub btnExcel_Click(sender As Object, e As EventArgs) Handles btnExcel.Click
        Dim dt As DataTable = GetData()
        Dim data As Byte() = BinaXlsx(dt)
        Dim nama As String = "Laporan_Inspektorat_" & DateTime.Now.ToString("yyyyMMdd_HHmm") & ".xlsx"

        Response.Clear()
        Response.Buffer = True
        Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        Response.AddHeader("Content-Disposition", "attachment; filename=" & nama)
        Response.AddHeader("Content-Length", data.Length.ToString())
        Response.BinaryWrite(data)
        Response.Flush()
        HttpContext.Current.ApplicationInstance.CompleteRequest()
    End Sub

    '===================== DATA =====================
    Private Function Julat() As Tuple(Of DateTime, DateTime)
        Dim dari As DateTime = New DateTime(DateTime.Today.Year, 1, 1)
        Dim hingga As DateTime = DateTime.Today
        Dim t As DateTime
        If DateTime.TryParse(txtDari.Text, CultureInfo.InvariantCulture, DateTimeStyles.None, t) Then dari = t.Date
        If DateTime.TryParse(txtHingga.Text, CultureInfo.InvariantCulture, DateTimeStyles.None, t) Then hingga = t.Date
        If hingga < dari Then
            Dim tmp As DateTime = dari : dari = hingga : hingga = tmp
        End If
        Return Tuple.Create(dari, hingga)
    End Function

    ' Tempoh masa dalam HARI BEKERJA (tolak Sabtu, Ahad & kelepasan am) melalui dbo.fn_HariBekerja.
    ' Jika fungsi belum dipasang (sql/2026-10-22_kelepasan_am_hari_bekerja.sql), guna beza hari kalendar sebagai sandaran.
    Private Function FungsiHariBekerjaAda() As Boolean
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
            Using cmd As New SqlCommand("SELECT CASE WHEN OBJECT_ID('dbo.fn_HariBekerja', 'FN') IS NOT NULL AND OBJECT_ID('dbo.LESEN_KelepasanAm', 'U') IS NOT NULL THEN 1 ELSE 0 END", conn)
                conn.Open()
                Return Convert.ToInt32(cmd.ExecuteScalar()) = 1
            End Using
        End Using
    End Function

    Private Function ExprTempoh() As String
        If FungsiHariBekerjaAda() Then
            Return "dbo.fn_HariBekerja(CAST(x.TarikhDiterima AS date), CAST(ISNULL(x.TarikhHantar, GETDATE()) AS date))"
        End If
        Return "DATEDIFF(day, x.TarikhDiterima, ISNULL(x.TarikhHantar, GETDATE()))"
    End Function

    ' Amaran di atas laporan: fungsi belum dipasang, atau jadual kelepasan am kosong bagi tahun dalam julat
    Private Function TeksAmaran(ByVal j As Tuple(Of DateTime, DateTime)) As String
        If Not FungsiHariBekerjaAda() Then
            Return "Fungsi hari bekerja belum dipasang pada pangkalan data - tempoh dikira mengikut hari kalendar (Sabtu, Ahad dan kelepasan am belum ditolak)."
        End If
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
            Using cmd As New SqlCommand("SELECT COUNT(*) FROM dbo.LESEN_KelepasanAm WHERE IsActive = 1 AND Tarikh BETWEEN @a AND @b", conn)
                cmd.Parameters.AddWithValue("@a", j.Item1)
                cmd.Parameters.AddWithValue("@b", j.Item2)
                conn.Open()
                If Convert.ToInt32(cmd.ExecuteScalar()) = 0 Then
                    Return "Tiada kelepasan am direkodkan bagi tempoh ini dalam jadual LESEN_KelepasanAm - hanya Sabtu dan Ahad ditolak."
                End If
            End Using
        End Using
        Return ""
    End Function
    Private Function GetData() As DataTable
        Dim j As Tuple(Of DateTime, DateTime) = Julat()
        Dim jenisId As Integer = 0
        Integer.TryParse(ddlJenisLesen.SelectedValue, jenisId)
        Dim kpi As Integer = 0
        Integer.TryParse(ddlKpi.SelectedValue, kpi)
        Dim cari As String = Trim(txtCari.Text)

        Dim sql As String =
            "SELECT * FROM (" &
            "  SELECT p.Permohonan_ID, ISNULL(p.Rujukan, '') AS Rujukan, " &
            "         ISNULL(NULLIF(p.NamaBaruSyarikat, ''), ISNULL(NULLIF(p.NamaSyarikat, ''), ISNULL(e.Pemohon_Name, ''))) AS Pemohon, " &
            "         ISNULL(NULLIF(p.JenisLesenDescList, ''), ISNULL(jl.JenisLesen_Description, '')) AS JenisLesen, " &
            "         ISNULL(NULLIF(p.JenisPerniagaanBaru, ''), ISNULL(p.JenisPerniagaan, '')) AS JenisPerniagaan, " &
            "         COALESCE(a2.CreatedDt, p.TarikhMohon) AS TarikhDiterima, " &
            "         a2.ApprovalDate AS TarikhPenetapan, a3.ApprovalDate AS TarikhSiasatan, uf.TarikhUlasan, " &
            "         COALESCE(a4.ApprovalDate, CASE WHEN pa.StatusID = 3 THEN pa.LastModDt END) AS TarikhHantar " &
            "  FROM LESEN_Permohonan p " &
            "  INNER JOIN LESEN_PermohonanAgensi pa ON pa.Permohonan_ID = p.Permohonan_ID AND pa.JabatanAgensi_ID = @Agensi " &
            "  LEFT JOIN LESEN_Pemohon e ON e.Pemohon_ID = p.Permohonan_PemohonID " &
            "  LEFT JOIN LESEN_JenisLesen jl ON jl.JenisLesen_ID = p.JenisLesen_ID " &
            "  OUTER APPLY (SELECT TOP 1 CreatedDt, ApprovalDate FROM LESEN_ApprovalList WHERE Permohonan_ID = p.Permohonan_ID AND AgensiID = @Agensi AND ApprStatusID = 2 ORDER BY ApprovalID) a2 " &
            "  OUTER APPLY (SELECT TOP 1 ApprovalDate FROM LESEN_ApprovalList WHERE Permohonan_ID = p.Permohonan_ID AND AgensiID = @Agensi AND ApprStatusID = 3 AND ApprovalDate IS NOT NULL ORDER BY ApprovalID) a3 " &
            "  OUTER APPLY (SELECT TOP 1 ApprovalDate FROM LESEN_ApprovalList WHERE Permohonan_ID = p.Permohonan_ID AND AgensiID = @Agensi AND ApprStatusID = 4 AND ApprovalDate IS NOT NULL ORDER BY ApprovalID) a4 " &
            "  OUTER APPLY (SELECT MIN(u.CreatedDt) AS TarikhUlasan FROM LESEN_UlasanFail u INNER JOIN TBL_USERS us ON us.Users_Id = u.UlasanFail_UserID WHERE u.UlasanFail_PermohonanID = p.Permohonan_ID AND us.estate_id = @Agensi) uf " &
            "  WHERE p.StatusID > 0 AND ISNULL(p.IsBatal, 0) = 0 " &
            "    AND (@JenisLesen = 0 OR p.JenisLesen_ID = @JenisLesen OR (',' + ISNULL(p.JenisLesenIdList, '') + ',') LIKE '%,' + CAST(@JenisLesen AS varchar(10)) + ',%') " &
            "    AND (@Cari = '' OR p.Rujukan LIKE '%' + @Cari + '%' OR e.Pemohon_Name LIKE '%' + @Cari + '%' OR p.NamaSyarikat LIKE '%' + @Cari + '%' OR p.NamaBaruSyarikat LIKE '%' + @Cari + '%') " &
            ") x " &
            "CROSS APPLY (SELECT CASE WHEN x.TarikhHantar IS NULL THEN 0 ELSE 1 END AS Selesai, " &
            "                    " & ExprTempoh() & " AS TempohHari) k " &
            "WHERE CAST(x.TarikhDiterima AS date) BETWEEN @Dari AND @Hingga " &
            "  AND (@Kpi = 0 " &
            "       OR (@Kpi = 1 AND k.Selesai = 1 AND k.TempohHari < @KpiHari) " &
            "       OR (@Kpi = 2 AND k.Selesai = 1 AND k.TempohHari >= @KpiHari) " &
            "       OR (@Kpi = 3 AND k.Selesai = 0)) " &
            "ORDER BY x.TarikhDiterima, x.Permohonan_ID"

        Dim dt As New DataTable()
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
            Using cmd As New SqlCommand(sql, conn)
                cmd.CommandTimeout = 120
                cmd.Parameters.AddWithValue("@Agensi", AGENSI_INSPEKTORAT)
                cmd.Parameters.AddWithValue("@JenisLesen", jenisId)
                cmd.Parameters.AddWithValue("@Cari", cari)
                cmd.Parameters.AddWithValue("@Dari", j.Item1)
                cmd.Parameters.AddWithValue("@Hingga", j.Item2)
                cmd.Parameters.AddWithValue("@Kpi", kpi)
                cmd.Parameters.AddWithValue("@KpiHari", KPI_HARI)
                Using da As New SqlDataAdapter(cmd)
                    da.Fill(dt)
                End Using
            End Using
        End Using
        Return dt
    End Function

    Private Sub BindLaporan()
        Dim dt As DataTable = GetData()
        Dim j As Tuple(Of DateTime, DateTime) = Julat()

        Dim dalam As Integer = 0, lebih As Integer = 0, belum As Integer = 0
        Dim jumlahHari As Long = 0, bilSelesai As Integer = 0
        For Each r As DataRow In dt.Rows
            If CInt(r("Selesai")) = 0 Then
                belum += 1
            Else
                Dim h As Integer = CInt(r("TempohHari"))
                bilSelesai += 1
                jumlahHari += h
                If h < KPI_HARI Then dalam += 1 Else lebih += 1
            End If
        Next

        litJumlah.Text = dt.Rows.Count.ToString()
        litDalam.Text = dalam.ToString()
        litLebih.Text = lebih.ToString()
        litBelum.Text = belum.ToString()
        litPurata.Text = If(bilSelesai > 0, (jumlahHari / bilSelesai).ToString("0.0", CultureInfo.InvariantCulture), "-")
        litTempohCetak.Text = "Tarikh diterima: " & j.Item1.ToString("dd/MM/yyyy") & " hingga " & j.Item2.ToString("dd/MM/yyyy") &
                              " &middot; Dicetak: " & DateTime.Now.ToString("dd/MM/yyyy HH:mm")

        Dim amaran As String = TeksAmaran(j)
        litAmaran.Text = If(amaran = "", "", "<div class=""li-warn""><i class=""bi bi-exclamation-triangle-fill""></i> " & HttpUtility.HtmlEncode(amaran) & "</div>")

        rptLaporan.DataSource = dt
        rptLaporan.DataBind()
        rptLaporan.Visible = dt.Rows.Count > 0
        phKosong.Visible = dt.Rows.Count = 0
    End Sub

    '===================== PAPARAN =====================
    Protected Function Tgl(ByVal v As Object) As String
        If v Is Nothing OrElse IsDBNull(v) Then Return "-"
        Return Convert.ToDateTime(v).ToString("dd/MM/yyyy")
    End Function

    Protected Function Tempoh(ByVal hari As Object, ByVal selesai As Object) As String
        If hari Is Nothing OrElse IsDBNull(hari) Then Return "-"
        Dim t As String = CInt(hari).ToString()
        Return If(CInt(selesai) = 1, t, t & "*")
    End Function

    Protected Function KpiTeks(ByVal hari As Object, ByVal selesai As Object) As String
        If CInt(selesai) = 0 Then Return "Belum selesai"
        Return If(CInt(hari) < KPI_HARI, "Dalam KPI", "Melebihi KPI")
    End Function

    Protected Function KpiCss(ByVal hari As Object, ByVal selesai As Object) As String
        If CInt(selesai) = 0 Then Return "wait"
        Return If(CInt(hari) < KPI_HARI, "ok", "bad")
    End Function

    '===================== EKSPORT EXCEL (.xlsx sebenar, tanpa pustaka luar - System.IO.Compression) =====================
    Private Shared ReadOnly LebarLajur() As Double = {5, 20, 28, 20, 24, 17, 17, 17, 17, 19, 14, 14}

    Private Function BinaXlsx(ByVal dt As DataTable) As Byte()
        Dim j As Tuple(Of DateTime, DateTime) = Julat()
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
                "<sheets><sheet name=""Laporan Inspektorat"" sheetId=""1"" r:id=""rId1""/></sheets></workbook>")
            TulisBahagian(zip, "xl/_rels/workbook.xml.rels",
                "<?xml version=""1.0"" encoding=""UTF-8"" standalone=""yes""?>" &
                "<Relationships xmlns=""http://schemas.openxmlformats.org/package/2006/relationships"">" &
                "<Relationship Id=""rId1"" Type=""http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet"" Target=""worksheets/sheet1.xml""/>" &
                "<Relationship Id=""rId2"" Type=""http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles"" Target=""styles.xml""/>" &
                "</Relationships>")
            TulisBahagian(zip, "xl/styles.xml", GayaXlsx())
            TulisBahagian(zip, "xl/worksheets/sheet1.xml", LembaranXlsx(dt, j))
        End Using
        Return ms.ToArray()
    End Function

    Private Shared Sub TulisBahagian(ByVal zip As IO.Compression.ZipArchive, ByVal nama As String, ByVal kandungan As String)
        Dim e As IO.Compression.ZipArchiveEntry = zip.CreateEntry(nama, IO.Compression.CompressionLevel.Optimal)
        Using s As IO.Stream = e.Open()
            Dim b As Byte() = New UTF8Encoding(False).GetBytes(kandungan)
            s.Write(b, 0, b.Length)
        End Using
    End Sub

    ' Indeks gaya: 0 biasa, 1 tajuk, 2 nota kecil, 3 kepala jadual, 4 teks, 5 tengah, 6 tarikh
    Private Shared Function GayaXlsx() As String
        Dim sb As New StringBuilder()
        sb.Append("<?xml version=""1.0"" encoding=""UTF-8"" standalone=""yes""?>")
        sb.Append("<styleSheet xmlns=""http://schemas.openxmlformats.org/spreadsheetml/2006/main"">")
        sb.Append("<numFmts count=""1""><numFmt numFmtId=""164"" formatCode=""dd/mm/yyyy""/></numFmts>")
        sb.Append("<fonts count=""4"">")
        sb.Append("<font><sz val=""10""/><name val=""Calibri""/></font>")
        sb.Append("<font><b/><sz val=""14""/><name val=""Calibri""/></font>")
        sb.Append("<font><sz val=""10""/><color rgb=""FF555555""/><name val=""Calibri""/></font>")
        sb.Append("<font><b/><sz val=""10""/><name val=""Calibri""/></font>")
        sb.Append("</fonts>")
        sb.Append("<fills count=""3""><fill><patternFill patternType=""none""/></fill><fill><patternFill patternType=""gray125""/></fill>")
        sb.Append("<fill><patternFill patternType=""solid""><fgColor rgb=""FFDCE3F5""/><bgColor indexed=""64""/></patternFill></fill></fills>")
        sb.Append("<borders count=""2""><border><left/><right/><top/><bottom/><diagonal/></border>")
        sb.Append("<border><left style=""thin""><color rgb=""FFBBBBBB""/></left><right style=""thin""><color rgb=""FFBBBBBB""/></right><top style=""thin""><color rgb=""FFBBBBBB""/></top><bottom style=""thin""><color rgb=""FFBBBBBB""/></bottom><diagonal/></border></borders>")
        sb.Append("<cellStyleXfs count=""1""><xf numFmtId=""0"" fontId=""0"" fillId=""0"" borderId=""0""/></cellStyleXfs>")
        sb.Append("<cellXfs count=""7"">")
        sb.Append("<xf numFmtId=""0"" fontId=""0"" fillId=""0"" borderId=""0"" xfId=""0""/>")
        sb.Append("<xf numFmtId=""0"" fontId=""1"" fillId=""0"" borderId=""0"" xfId=""0"" applyFont=""1""/>")
        sb.Append("<xf numFmtId=""0"" fontId=""2"" fillId=""0"" borderId=""0"" xfId=""0"" applyFont=""1""/>")
        sb.Append("<xf numFmtId=""0"" fontId=""3"" fillId=""2"" borderId=""1"" xfId=""0"" applyFont=""1"" applyFill=""1"" applyBorder=""1"" applyAlignment=""1""><alignment horizontal=""center"" vertical=""center"" wrapText=""1""/></xf>")
        sb.Append("<xf numFmtId=""0"" fontId=""0"" fillId=""0"" borderId=""1"" xfId=""0"" applyBorder=""1"" applyAlignment=""1""><alignment vertical=""center"" wrapText=""1""/></xf>")
        sb.Append("<xf numFmtId=""0"" fontId=""0"" fillId=""0"" borderId=""1"" xfId=""0"" applyBorder=""1"" applyAlignment=""1""><alignment horizontal=""center"" vertical=""center""/></xf>")
        sb.Append("<xf numFmtId=""164"" fontId=""0"" fillId=""0"" borderId=""1"" xfId=""0"" applyNumberFormat=""1"" applyBorder=""1"" applyAlignment=""1""><alignment horizontal=""center"" vertical=""center""/></xf>")
        sb.Append("</cellXfs>")
        sb.Append("<cellStyles count=""1""><cellStyle name=""Normal"" xfId=""0"" builtinId=""0""/></cellStyles>")
        sb.Append("</styleSheet>")
        Return sb.ToString()
    End Function

    Private Function LembaranXlsx(ByVal dt As DataTable, ByVal j As Tuple(Of DateTime, DateTime)) As String
        Dim sb As New StringBuilder()
        Dim akhir As Integer = 5 + dt.Rows.Count
        sb.Append("<?xml version=""1.0"" encoding=""UTF-8"" standalone=""yes""?>")
        sb.Append("<worksheet xmlns=""http://schemas.openxmlformats.org/spreadsheetml/2006/main"">")
        sb.Append("<sheetPr><pageSetUpPr fitToPage=""1""/></sheetPr>")
        sb.Append("<sheetViews><sheetView workbookViewId=""0""><pane ySplit=""5"" topLeftCell=""A6"" activePane=""bottomLeft"" state=""frozen""/><selection pane=""bottomLeft""/></sheetView></sheetViews>")
        sb.Append("<sheetFormatPr defaultRowHeight=""15""/>")
        sb.Append("<cols>")
        For i As Integer = 0 To LebarLajur.Length - 1
            sb.Append("<col min=""" & (i + 1) & """ max=""" & (i + 1) & """ width=""" & LebarLajur(i).ToString(CultureInfo.InvariantCulture) & """ customWidth=""1""/>")
        Next
        sb.Append("</cols><sheetData>")

        sb.Append("<row r=""1"" ht=""22"" customHeight=""1"">" & SelStr("A1", "LAPORAN INSPEKTORAT", 1) & "</row>")
        sb.Append("<row r=""2"">" & SelStr("A2", "Majlis Perbandaran Kluang - Bahagian Inspektorat", 2) & "</row>")
        sb.Append("<row r=""3"">" & SelStr("A3", "Tarikh diterima: " & j.Item1.ToString("dd/MM/yyyy") & " hingga " & j.Item2.ToString("dd/MM/yyyy") &
                  " | KPI: kurang " & KPI_HARI & " hari | Dijana: " & DateTime.Now.ToString("dd/MM/yyyy HH:mm"), 2) & "</row>")

        Dim tajuk() As String = {"Bil", "No. Rujukan", "Pemohon / Syarikat", "Jenis Lesen", "Jenis Perniagaan",
            "Tarikh Permohonan Diterima daripada KB Lesen (KB)", "Tarikh Penetapan Siasatan (PPKP)", "Tarikh Siasatan Tapak (PPKP)",
            "Tarikh Ulasan Teknikal (PPKP)", "Tarikh Semakan dan Hantar Laporan ke Lesen (KB)", "Tempoh Masa (hari bekerja)", "Status KPI"}
        sb.Append("<row r=""5"" ht=""45"" customHeight=""1"">")
        For i As Integer = 0 To tajuk.Length - 1
            sb.Append(SelStr(Ruj(i, 5), tajuk(i), 3))
        Next
        sb.Append("</row>")

        Dim baris As Integer = 5
        Dim bil As Integer = 0
        For Each r As DataRow In dt.Rows
            baris += 1
            bil += 1
            sb.Append("<row r=""" & baris & """>")
            sb.Append(SelNum(Ruj(0, baris), bil, 5))
            sb.Append(SelStr(Ruj(1, baris), Convert.ToString(r("Rujukan")), 4))
            sb.Append(SelStr(Ruj(2, baris), Convert.ToString(r("Pemohon")), 4))
            sb.Append(SelStr(Ruj(3, baris), Convert.ToString(r("JenisLesen")), 4))
            sb.Append(SelStr(Ruj(4, baris), Convert.ToString(r("JenisPerniagaan")), 4))
            sb.Append(SelTar(Ruj(5, baris), r("TarikhDiterima")))
            sb.Append(SelTar(Ruj(6, baris), r("TarikhPenetapan")))
            sb.Append(SelTar(Ruj(7, baris), r("TarikhSiasatan")))
            sb.Append(SelTar(Ruj(8, baris), r("TarikhUlasan")))
            sb.Append(SelTar(Ruj(9, baris), r("TarikhHantar")))
            sb.Append(SelNum(Ruj(10, baris), CInt(r("TempohHari")), 5))
            sb.Append(SelStr(Ruj(11, baris), KpiTeks(r("TempohHari"), r("Selesai")), 5))
            sb.Append("</row>")
        Next

        baris += 2
        sb.Append("<row r=""" & baris & """>" & SelStr("A" & baris, "Jumlah rekod: " & dt.Rows.Count & " | Tempoh dikira dalam hari bekerja (tolak Sabtu, Ahad dan kelepasan am); bagi permohonan yang belum selesai, dikira sehingga hari ini.", 2) & "</row>")
        sb.Append("</sheetData>")
        sb.Append("<pageMargins left=""0.4"" right=""0.4"" top=""0.5"" bottom=""0.5"" header=""0.3"" footer=""0.3""/>")
        sb.Append("<pageSetup paperSize=""9"" orientation=""landscape"" fitToHeight=""0""/>")
        sb.Append("</worksheet>")
        Return sb.ToString()
    End Function

    ' Rujukan sel, cth. Ruj(4, 6) = "E6" (lajur 0-berasaskan, baris 1-berasaskan)
    Private Shared Function Ruj(ByVal lajur As Integer, ByVal baris As Integer) As String
        Return Convert.ToChar(Asc("A") + lajur).ToString() & baris
    End Function

    Private Shared Function Esc(ByVal s As Object) As String
        If s Is Nothing OrElse IsDBNull(s) Then Return ""
        Return System.Security.SecurityElement.Escape(Convert.ToString(s))
    End Function

    Private Shared Function SelStr(ByVal rujukan As String, ByVal teks As String, ByVal gaya As Integer) As String
        Return "<c r=""" & rujukan & """ s=""" & gaya & """ t=""inlineStr""><is><t xml:space=""preserve"">" & Esc(teks) & "</t></is></c>"
    End Function

    Private Shared Function SelNum(ByVal rujukan As String, ByVal nilai As Integer, ByVal gaya As Integer) As String
        Return "<c r=""" & rujukan & """ s=""" & gaya & """><v>" & nilai & "</v></c>"
    End Function

    Private Shared Function SelTar(ByVal rujukan As String, ByVal v As Object) As String
        If v Is Nothing OrElse IsDBNull(v) Then Return SelStr(rujukan, "-", 5)
        Dim d As DateTime = Convert.ToDateTime(v).Date
        Dim siri As Double = (d - New DateTime(1899, 12, 30)).TotalDays
        Return "<c r=""" & rujukan & """ s=""6""><v>" & siri.ToString(CultureInfo.InvariantCulture) & "</v></c>"
    End Function

End Class
