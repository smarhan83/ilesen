Imports System.Collections.Generic
Imports System.Configuration
Imports System.Data
Imports System.Data.SqlClient
Imports System.Globalization
Imports System.Text
Imports System.Web
Imports System.Web.UI
Imports System.Web.UI.WebControls

Partial Class laporanpermohonan
    Inherits System.Web.UI.Page

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

            UpdateFilterVisibility()
            BindLaporan()
        End If
    End Sub

    Protected Sub ddlReport_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlReport.SelectedIndexChanged
        UpdateFilterVisibility()
        BindLaporan()
    End Sub

    Protected Sub btnJana_Click(sender As Object, e As EventArgs) Handles btnJana.Click
        BindLaporan()
    End Sub

    Protected Sub btnReset_Click(sender As Object, e As EventArgs) Handles btnReset.Click
        Response.Redirect(Request.RawUrl)
    End Sub

    Protected Sub btnExcel_Click(sender As Object, e As EventArgs) Handles btnExcel.Click
        Dim reportType As Integer = 1
        Integer.TryParse(ddlReport.SelectedValue, reportType)

        Dim dt As DataTable = GetData(reportType)
        Dim data As Byte() = BinaXlsx(dt, reportType)
        Dim nama As String = "Laporan_" & DapatkanKodLaporan(reportType) & "_" & DateTime.Now.ToString("yyyyMMdd_HHmm") & ".xlsx"

        Response.Clear()
        Response.Buffer = True
        Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        Response.AddHeader("Content-Disposition", "attachment; filename=" & nama)
        Response.AddHeader("Content-Length", data.Length.ToString())
        Response.BinaryWrite(data)
        Response.Flush()
        HttpContext.Current.ApplicationInstance.CompleteRequest()
    End Sub

    '===================== FILTER VISIBILITY =====================
    Private Sub UpdateFilterVisibility()
        Dim rType As Integer = 1
        Integer.TryParse(ddlReport.SelectedValue, rType)

        ' Jenis Perniagaan filter khusus untuk laporan perniagaan / permit
        pnlJenisPerniagaan.Visible = (rType = 1)
        If rType <> 1 Then txtJenisPerniagaan.Text = ""

        ' Status filter sesuai untuk laporan yang mempunyai status (1, 2, 5, 6, 7)
        pnlStatus.Visible = (rType = 1 OrElse rType = 2 OrElse rType = 5 OrElse rType = 6 OrElse rType = 7)
    End Sub

    '===================== JULAT TARIKH =====================
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

    '===================== DATA =====================
    Private Function GetData(ByVal reportType As Integer) As DataTable
        Dim j As Tuple(Of DateTime, DateTime) = Julat()
        Dim cari As String = Trim(txtCari.Text)
        Dim jenisPerniagaan As String = Trim(txtJenisPerniagaan.Text)
        Dim statusFilter As Integer = 0
        Integer.TryParse(ddlStatus.SelectedValue, statusFilter)

        Dim sql As String = ""

        Select Case reportType
            Case 1
                ' 1. TEMPLATE LAPORAN PERMOHONAN LESEN PERNIAGAAN / PERMIT
                sql = "SELECT a.Permohonan_ID, a.StatusID, a.Is24Jam, a.Rujukan, " &
                      "       b.Pemohon_Name, b.Pemohon_MobileNo, " &
                      "       ISNULL(a.NamaBaruSyarikat, a.NamaSyarikat) AS NamaSyarikat, " &
                      "       ISNULL(a.JenisPerniagaanBaru, a.JenisPerniagaan) AS JenisPerniagaan, " &
                      "       b.Pemohon_Address, " &
                      "       ISNULL(a.AlamatBaru, a.AlamatPremis) AS AlamatPremis, " &
                      "       a.JenisLesenDescList, a.TarikhMohon " &
                      "FROM LESEN_Permohonan a " &
                      "INNER JOIN LESEN_Pemohon b ON a.Permohonan_PemohonID = b.Pemohon_ID " &
                      "WHERE a.IsBatal = 0 AND (a.JenisLesenDescList LIKE '%PERNIAGAAN%' OR a.JenisLesenDescList LIKE '%SEMENTARA%') " &
                      "  AND CAST(a.TarikhMohon AS date) BETWEEN @Dari AND @Hingga " &
                      "  AND (@JenisPerniagaan = '' OR ISNULL(a.JenisPerniagaanBaru, a.JenisPerniagaan) LIKE '%' + @JenisPerniagaan + '%') " &
                      "  AND (@Cari = '' OR a.Rujukan LIKE '%' + @Cari + '%' OR b.Pemohon_Name LIKE '%' + @Cari + '%' OR ISNULL(a.NamaBaruSyarikat, a.NamaSyarikat) LIKE '%' + @Cari + '%') " &
                      "  AND (@Status = 0 " &
                      "       OR (@Status = 1 AND a.StatusID NOT IN (6, 9, 10)) " &
                      "       OR (@Status = 2 AND a.StatusID = 10) " &
                      "       OR (@Status = 3 AND a.StatusID IN (6, 9))) " &
                      "ORDER BY a.TarikhMohon ASC"

            Case 2
                ' 2. TEMPLATE LAPORAN PERMOHONAN PEMBATALAN
                sql = "SELECT a.Permohonan_ID, a.StatusID, a.Is24Jam, a.Rujukan, " &
                      "       b.Pemohon_Name, b.Pemohon_MobileNo, " &
                      "       ISNULL(a.NamaBaruSyarikat, a.NamaSyarikat) AS NamaSyarikat, " &
                      "       ISNULL(a.JenisPerniagaanBaru, a.JenisPerniagaan) AS JenisPerniagaan, " &
                      "       b.Pemohon_Address, " &
                      "       ISNULL(a.AlamatBaru, a.AlamatPremis) AS AlamatPremis, " &
                      "       IIF(ISNULL(a.JenisBatal, 0) = 1, 'Dengan Permohonan', IIF(ISNULL(a.JenisBatal, 0) = 2, 'Tanpa Permohonan', '-')) AS JenisBatal, " &
                      "       ISNULL(e.name, d.name) AS SebabBatal, " &
                      "       f.name AS TindakanBatal, " &
                      "       a.JenisLesenDescList, a.TarikhMohon " &
                      "FROM LESEN_Permohonan a " &
                      "INNER JOIN LESEN_Pemohon b ON a.Permohonan_PemohonID = b.Pemohon_ID " &
                      "LEFT JOIN TBL_LOOKUPS d ON a.SebabBatalPerm = d.id " &
                      "LEFT JOIN TBL_LOOKUPS e ON a.SebabBatalTanpaPerm = e.id " &
                      "LEFT JOIN TBL_LOOKUPS f ON a.TindakanBatal = f.id " &
                      "WHERE a.IsBatal = 1 AND (a.JenisLesenDescList LIKE '%PERNIAGAAN%' OR a.JenisLesenDescList LIKE '%SEMENTARA%') " &
                      "  AND CAST(a.TarikhMohon AS date) BETWEEN @Dari AND @Hingga " &
                      "  AND (@Cari = '' OR a.Rujukan LIKE '%' + @Cari + '%' OR b.Pemohon_Name LIKE '%' + @Cari + '%' OR ISNULL(a.NamaBaruSyarikat, a.NamaSyarikat) LIKE '%' + @Cari + '%') " &
                      "  AND (@Status = 0 " &
                      "       OR (@Status = 1 AND a.StatusID NOT IN (6, 9, 10)) " &
                      "       OR (@Status = 2 AND a.StatusID = 10) " &
                      "       OR (@Status = 3 AND a.StatusID IN (6, 9))) " &
                      "ORDER BY a.TarikhMohon ASC"

            Case 3
                ' 3. TEMPLATE LAPORAN PERMOHONAN BELUM DAPAT ULASAN INSPEKTORAT
                sql = "SELECT a.Permohonan_ID, a.IsBatal, a.StatusID, a.Is24Jam, a.Rujukan, " &
                      "       b.Pemohon_Name, b.Pemohon_MobileNo, " &
                      "       ISNULL(a.NamaBaruSyarikat, a.NamaSyarikat) AS NamaSyarikat, " &
                      "       ISNULL(a.JenisPerniagaanBaru, a.JenisPerniagaan) AS JenisPerniagaan, " &
                      "       b.Pemohon_Address, " &
                      "       ISNULL(a.AlamatBaru, a.AlamatPremis) AS AlamatPremis, " &
                      "       a.JenisLesenDescList, a.TarikhMohon, " &
                      "       IIF(c.PengesahStatusID IS NULL, 'Dalam Proses', 'Selesai') AS StatusUlasan, " &
                      "       IIF(d.PengesahStatusID IS NULL, 'Dalam Proses', 'Selesai') AS StatusUlasanBatal " &
                      "FROM LESEN_Permohonan a " &
                      "INNER JOIN LESEN_Pemohon b ON a.Permohonan_PemohonID = b.Pemohon_ID " &
                      "LEFT JOIN (SELECT Permohonan_ID, JabatanAgensi_ID, PengesahStatusID FROM LESEN_PermohonanAgensi " &
                      "           WHERE JabatanAgensi_ID = 3 GROUP BY Permohonan_ID, JabatanAgensi_ID, PengesahStatusID) c ON a.Permohonan_ID = c.Permohonan_ID " &
                      "LEFT JOIN (SELECT Permohonan_ID, JabatanAgensi_ID, PengesahStatusID FROM LESEN_PermohonanAgensiBatal " &
                      "           WHERE JabatanAgensi_ID = 3 GROUP BY Permohonan_ID, JabatanAgensi_ID, PengesahStatusID) d ON a.Permohonan_ID = d.Permohonan_ID " &
                      "WHERE (a.JenisLesenDescList LIKE '%PERNIAGAAN%' OR a.JenisLesenDescList LIKE '%SEMENTARA%') " &
                      "  AND CAST(a.TarikhMohon AS date) BETWEEN @Dari AND @Hingga " &
                      "  AND (@Cari = '' OR a.Rujukan LIKE '%' + @Cari + '%' OR b.Pemohon_Name LIKE '%' + @Cari + '%' OR ISNULL(a.NamaBaruSyarikat, a.NamaSyarikat) LIKE '%' + @Cari + '%') " &
                      "ORDER BY a.TarikhMohon ASC"

            Case 4
                ' 4. TEMPLATE LAPORAN PERMOHONAN LESEN SEPANDUK
                sql = "SELECT a.Permohonan_ID, a.IsBatal, a.StatusID, a.Is24Jam, a.Rujukan, " &
                      "       b.Pemohon_Name, b.Pemohon_MobileNo, " &
                      "       ISNULL(a.NamaBaruSyarikat, a.NamaSyarikat) AS NamaSyarikat, " &
                      "       a.KontraktorIklan, a.TarikhBanting1, a.TarikhBanting2, a.LokasiList, " &
                      "       a.NoResitBanting, a.NoSiriStiker, a.UkuranBanting, a.BilBanting, a.JenisBanting, " &
                      "       a.JenisLesenDescList, a.TarikhMohon " &
                      "FROM LESEN_Permohonan a " &
                      "INNER JOIN LESEN_Pemohon b ON a.Permohonan_PemohonID = b.Pemohon_ID " &
                      "WHERE a.IsBatal = 0 AND a.JenisLesenDescList LIKE '%SEPANDUK%' " &
                      "  AND CAST(a.TarikhMohon AS date) BETWEEN @Dari AND @Hingga " &
                      "  AND (@Cari = '' OR a.Rujukan LIKE '%' + @Cari + '%' OR b.Pemohon_Name LIKE '%' + @Cari + '%' OR a.KontraktorIklan LIKE '%' + @Cari + '%' OR a.NoResitBanting LIKE '%' + @Cari + '%') " &
                      "ORDER BY a.TarikhMohon ASC"

            Case 5
                ' 5. TEMPLATE LAPORAN PERMOHONAN LESEN PASAR LAMBAK / PASAR PAGI
                sql = "SELECT a.Permohonan_ID, a.StatusID, a.Is24Jam, a.Rujukan, " &
                      "       b.Pemohon_Name, b.Pemohon_MobileNo, " &
                      "       ISNULL(a.NamaBaruSyarikat, a.NamaSyarikat) AS NamaSyarikat, " &
                      "       ISNULL(a.JenisPerniagaanBaru, a.JenisPerniagaan) AS JenisPerniagaan, " &
                      "       a.JenisPerniagaanPasar, a.JenisPerniagaanPenjaja, a.JumlahPetak, " &
                      "       b.Pemohon_Address, " &
                      "       ISNULL(a.AlamatBaru, a.AlamatPremis) AS AlamatPremis, " &
                      "       a.AlamatPenjajaan, " &
                      "       a.LokasiPasar1, a.LokasiPasar2, a.LokasiPasar3, " &
                      "       a.JenisLesenDescList, a.TarikhMohon " &
                      "FROM LESEN_Permohonan a " &
                      "INNER JOIN LESEN_Pemohon b ON a.Permohonan_PemohonID = b.Pemohon_ID " &
                      "WHERE a.IsBatal = 0 AND a.JenisLesenDescList LIKE '%PASAR%' " &
                      "  AND CAST(a.TarikhMohon AS date) BETWEEN @Dari AND @Hingga " &
                      "  AND (@Cari = '' OR a.Rujukan LIKE '%' + @Cari + '%' OR b.Pemohon_Name LIKE '%' + @Cari + '%' OR a.JenisPerniagaanPasar LIKE '%' + @Cari + '%') " &
                      "  AND (@Status = 0 " &
                      "       OR (@Status = 1 AND a.StatusID NOT IN (6, 9, 10)) " &
                      "       OR (@Status = 2 AND a.StatusID = 10) " &
                      "       OR (@Status = 3 AND a.StatusID IN (6, 9))) " &
                      "ORDER BY a.TarikhMohon ASC"

            Case 6
                ' 6. TEMPLATE LAPORAN PERMOHONAN LESEN ANJING
                sql = "SELECT a.Permohonan_ID, a.StatusID, a.Is24Jam, a.Rujukan, " &
                      "       b.Pemohon_Name, b.Pemohon_MobileNo, " &
                      "       ISNULL(a.NamaBaruSyarikat, a.NamaSyarikat) AS NamaSyarikat, " &
                      "       a.BakaAnjingList, a.AnjingJantanList, a.AnjingBetinaList, a.AnjingJantanMandulList, a.AnjingBetinaMandulList, " &
                      "       c.name AS AnjingJenisPremis, a.AnjingAlamat, " &
                      "       a.JenisLesenDescList, a.TarikhMohon " &
                      "FROM LESEN_Permohonan a " &
                      "INNER JOIN LESEN_Pemohon b ON a.Permohonan_PemohonID = b.Pemohon_ID " &
                      "LEFT JOIN TBL_LOOKUPS c ON a.AnjingJenisMohon = c.id " &
                      "WHERE a.IsBatal = 0 AND a.JenisLesenDescList LIKE '%ANJING%' " &
                      "  AND CAST(a.TarikhMohon AS date) BETWEEN @Dari AND @Hingga " &
                      "  AND (@Cari = '' OR a.Rujukan LIKE '%' + @Cari + '%' OR b.Pemohon_Name LIKE '%' + @Cari + '%' OR a.AnjingAlamat LIKE '%' + @Cari + '%' OR a.BakaAnjingList LIKE '%' + @Cari + '%') " &
                      "  AND (@Status = 0 " &
                      "       OR (@Status = 1 AND a.StatusID NOT IN (6, 9, 10)) " &
                      "       OR (@Status = 2 AND a.StatusID = 10) " &
                      "       OR (@Status = 3 AND a.StatusID IN (6, 9))) " &
                      "ORDER BY a.TarikhMohon ASC"

            Case 7
                ' 7. TEMPLATE LAPORAN PERMOHONAN LESEN PENJAJA
                sql = "SELECT a.Permohonan_ID, a.StatusID, a.Is24Jam, a.Rujukan, " &
                      "       b.Pemohon_Name, b.Pemohon_MobileNo, " &
                      "       ISNULL(a.NamaBaruSyarikat, a.NamaSyarikat) AS NamaSyarikat, " &
                      "       ISNULL(a.JenisPerniagaanBaru, a.JenisPerniagaan) AS JenisPerniagaan, " &
                      "       a.JenisPerniagaanPasar, a.JenisPerniagaanPenjaja, a.JumlahPetak, " &
                      "       b.Pemohon_Address, " &
                      "       ISNULL(a.AlamatBaru, a.AlamatPremis) AS AlamatPremis, " &
                      "       a.AlamatPenjajaan, " &
                      "       a.JenisLesenDescList, a.TarikhMohon " &
                      "FROM LESEN_Permohonan a " &
                      "INNER JOIN LESEN_Pemohon b ON a.Permohonan_PemohonID = b.Pemohon_ID " &
                      "WHERE a.IsBatal = 0 AND a.JenisLesenDescList LIKE '%PENJAJA%' " &
                      "  AND CAST(a.TarikhMohon AS date) BETWEEN @Dari AND @Hingga " &
                      "  AND (@Cari = '' OR a.Rujukan LIKE '%' + @Cari + '%' OR b.Pemohon_Name LIKE '%' + @Cari + '%' OR a.AlamatPenjajaan LIKE '%' + @Cari + '%' OR a.JenisPerniagaanPenjaja LIKE '%' + @Cari + '%') " &
                      "  AND (@Status = 0 " &
                      "       OR (@Status = 1 AND a.StatusID NOT IN (6, 9, 10)) " &
                      "       OR (@Status = 2 AND a.StatusID = 10) " &
                      "       OR (@Status = 3 AND a.StatusID IN (6, 9))) " &
                      "ORDER BY a.TarikhMohon ASC"
        End Select

        Dim dt As New DataTable()
        If String.IsNullOrWhiteSpace(sql) Then Return dt

        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
            Using cmd As New SqlCommand(sql, conn)
                cmd.CommandTimeout = 120
                cmd.Parameters.AddWithValue("@Dari", j.Item1)
                cmd.Parameters.AddWithValue("@Hingga", j.Item2)
                cmd.Parameters.AddWithValue("@Cari", cari)
                cmd.Parameters.AddWithValue("@JenisPerniagaan", jenisPerniagaan)
                cmd.Parameters.AddWithValue("@Status", statusFilter)
                Using da As New SqlDataAdapter(cmd)
                    da.Fill(dt)
                End Using
            End Using
        End Using
        Return dt
    End Function

    Private Sub BindLaporan()
        Dim rType As Integer = 1
        Integer.TryParse(ddlReport.SelectedValue, rType)

        Dim dt As DataTable = GetData(rType)
        Dim j As Tuple(Of DateTime, DateTime) = Julat()

        Dim tajuk As String = DapatkanTajukLaporan(rType)
        Dim subTajuk As String = "dari " & j.Item1.ToString("dd/MM/yyyy") & " hingga " & j.Item2.ToString("dd/MM/yyyy")

        litTajukPaparan.Text = tajuk
        litSubTajukPaparan.Text = subTajuk
        litTajukCetak.Text = tajuk.ToUpperInvariant()
        litTempohCetak.Text = subTajuk & " &middot; Dicetak: " & DateTime.Now.ToString("dd/MM/yyyy HH:mm")

        ' Statistik
        litJumlah.Text = dt.Rows.Count.ToString()

        If rType = 3 Then
            ' Report 3: Belum Dapat Ulasan Inspektorat
            Dim selesai As Integer = 0, dalamProses As Integer = 0
            For Each r As DataRow In dt.Rows
                Dim st As String = DapatkanStatusUlasan(r("IsBatal"), r("StatusUlasan"), r("StatusUlasanBatal"))
                If st.Equals("Selesai", StringComparison.OrdinalIgnoreCase) Then
                    selesai += 1
                Else
                    dalamProses += 1
                End If
            Next
            statBox1.Visible = True
            litStatLbl1.Text = "Selesai"
            litStat1.Text = selesai.ToString()

            statBox2.Visible = False

            statBox3.Visible = True
            litStatLbl3.Text = "Dalam Proses"
            litStat3.Text = dalamProses.ToString()

        ElseIf rType = 4 Then
            ' Report 4: Lesen Sepanduk
            Dim totalBanting As Integer = 0
            For Each r As DataRow In dt.Rows
                Dim qty As Integer = 0
                If r("BilBanting") IsNot Nothing AndAlso Not IsDBNull(r("BilBanting")) Then
                    Integer.TryParse(r("BilBanting").ToString(), qty)
                End If
                totalBanting += qty
            Next
            statBox1.Visible = True
            litStatLbl1.Text = "Jumlah Qty Bunting"
            litStat1.Text = totalBanting.ToString()

            statBox2.Visible = False
            statBox3.Visible = False

        Else
            ' Reports 1, 2, 5, 6, 7
            Dim lulus As Integer = 0, tolak As Integer = 0, dalamProses As Integer = 0
            For Each r As DataRow In dt.Rows
                Dim st As String = DapatkanStatus(r("StatusID"))
                If st = "Lulus" Then
                    lulus += 1
                ElseIf st = "Tolak" Then
                    tolak += 1
                Else
                    dalamProses += 1
                End If
            Next
            statBox1.Visible = True
            litStatLbl1.Text = "Lulus"
            litStat1.Text = lulus.ToString()

            statBox2.Visible = True
            litStatLbl2.Text = "Tolak"
            litStat2.Text = tolak.ToString()

            statBox3.Visible = True
            litStatLbl3.Text = "Dalam Proses"
            litStat3.Text = dalamProses.ToString()
        End If

        ' Bind repeater yang berkaitan sahaja
        rptReport1.Visible = False
        rptReport2.Visible = False
        rptReport3.Visible = False
        rptReport4.Visible = False
        rptReport5.Visible = False
        rptReport6.Visible = False
        rptReport7.Visible = False

        Dim activeRpt As Repeater = Nothing
        Select Case rType
            Case 1 : activeRpt = rptReport1
            Case 2 : activeRpt = rptReport2
            Case 3 : activeRpt = rptReport3
            Case 4 : activeRpt = rptReport4
            Case 5 : activeRpt = rptReport5
            Case 6 : activeRpt = rptReport6
            Case 7 : activeRpt = rptReport7
        End Select

        If activeRpt IsNot Nothing Then
            activeRpt.DataSource = dt
            activeRpt.DataBind()
            activeRpt.Visible = (dt.Rows.Count > 0)
        End If

        phKosong.Visible = (dt.Rows.Count = 0)
        litNota.Text = "Nota: Menunjukkan rekod permohonan dari <b>" & j.Item1.ToString("dd/MM/yyyy") & "</b> hingga <b>" & j.Item2.ToString("dd/MM/yyyy") & "</b>."
    End Sub

    '===================== PAPARAN & FORMAT DATA =====================
    Protected Function Tgl(ByVal v As Object) As String
        If v Is Nothing OrElse IsDBNull(v) Then Return "-"
        Dim d As DateTime
        If DateTime.TryParse(v.ToString(), d) Then
            Return d.ToString("dd/MM/yyyy")
        End If
        Return "-"
    End Function

    Protected Function DapatkanStatus(ByVal statusIdObj As Object) As String
        If statusIdObj Is Nothing OrElse IsDBNull(statusIdObj) Then Return "Dalam Proses"
        Dim sId As Integer = 0
        If Integer.TryParse(statusIdObj.ToString(), sId) Then
            If sId = 10 Then
                Return "Lulus"
            ElseIf sId = 6 OrElse sId = 9 Then
                Return "Tolak"
            End If
        End If
        Return "Dalam Proses"
    End Function

    Protected Function DapatkanStatusBadgeCss(ByVal statusIdObj As Object) As String
        Dim st As String = DapatkanStatus(statusIdObj)
        If st = "Lulus" Then Return "ok"
        If st = "Tolak" Then Return "bad"
        Return "wait"
    End Function

    Protected Function DapatkanStatusUlasan(ByVal isBatalObj As Object, ByVal ulasanObj As Object, ByVal ulasanBatalObj As Object) As String
        Dim isBatal As Boolean = False
        If isBatalObj IsNot Nothing AndAlso Not IsDBNull(isBatalObj) Then
            If TypeOf isBatalObj Is Boolean Then
                isBatal = CBool(isBatalObj)
            Else
                isBatal = (isBatalObj.ToString() = "1" OrElse isBatalObj.ToString().ToLower() = "true")
            End If
        End If
        Dim res As String = If(isBatal, Convert.ToString(ulasanBatalObj), Convert.ToString(ulasanObj))
        If String.IsNullOrWhiteSpace(res) Then Return "Dalam Proses"
        Return res
    End Function

    Protected Function DapatkanStatusUlasanBadgeCss(ByVal isBatalObj As Object, ByVal ulasanObj As Object, ByVal ulasanBatalObj As Object) As String
        Dim st As String = DapatkanStatusUlasan(isBatalObj, ulasanObj, ulasanBatalObj)
        If st.Equals("Selesai", StringComparison.OrdinalIgnoreCase) Then Return "ok"
        Return "wait"
    End Function

    Protected Function FormatTempohBanting(ByVal t1 As Object, ByVal t2 As Object) As String
        Dim s1 As String = ""
        Dim s2 As String = ""
        If t1 IsNot Nothing AndAlso Not IsDBNull(t1) Then
            Dim d1 As DateTime
            If DateTime.TryParse(t1.ToString(), d1) Then s1 = d1.ToString("dd/MM/yyyy")
        End If
        If t2 IsNot Nothing AndAlso Not IsDBNull(t2) Then
            Dim d2 As DateTime
            If DateTime.TryParse(t2.ToString(), d2) Then s2 = d2.ToString("dd/MM/yyyy")
        End If
        If String.IsNullOrEmpty(s1) AndAlso String.IsNullOrEmpty(s2) Then Return "-"
        If String.IsNullOrEmpty(s1) Then Return s2
        If String.IsNullOrEmpty(s2) Then Return s1
        Return s1 & " - " & s2
    End Function

    Protected Function FormatLokasiSepandukHtml(ByVal lokasiListObj As Object) As String
        If lokasiListObj Is Nothing OrElse IsDBNull(lokasiListObj) Then Return "-"
        Dim str As String = lokasiListObj.ToString()
        If String.IsNullOrWhiteSpace(str) Then Return "-"
        Dim parts = str.Split(New String() {"||"}, StringSplitOptions.RemoveEmptyEntries)
        If parts.Length = 0 Then Return "-"
        Dim sb As New StringBuilder()
        For Each p In parts
            Dim trimmed As String = p.Trim()
            If Not String.IsNullOrEmpty(trimmed) Then
                If sb.Length > 0 Then sb.Append("<br />")
                sb.Append("- ").Append(HttpUtility.HtmlEncode(trimmed))
            End If
        Next
        Return If(sb.Length > 0, sb.ToString(), "-")
    End Function

    Private Function FormatLokasiSepandukTeks(ByVal lokasiListObj As Object) As String
        If lokasiListObj Is Nothing OrElse IsDBNull(lokasiListObj) Then Return "-"
        Dim str As String = lokasiListObj.ToString()
        If String.IsNullOrWhiteSpace(str) Then Return "-"
        Dim parts = str.Split(New String() {"||"}, StringSplitOptions.RemoveEmptyEntries)
        If parts.Length = 0 Then Return "-"
        Dim sb As New StringBuilder()
        For Each p In parts
            Dim trimmed As String = p.Trim()
            If Not String.IsNullOrEmpty(trimmed) Then
                If sb.Length > 0 Then sb.Append(vbCrLf)
                sb.Append("- ").Append(trimmed)
            End If
        Next
        Return If(sb.Length > 0, sb.ToString(), "-")
    End Function

    Protected Function FormatLokasiPasarHtml(ByVal p1 As Object, ByVal p2 As Object, ByVal p3 As Object) As String
        Dim list As New List(Of String)
        If p1 IsNot Nothing AndAlso Not IsDBNull(p1) AndAlso Not String.IsNullOrWhiteSpace(p1.ToString()) Then list.Add(p1.ToString().Trim())
        If p2 IsNot Nothing AndAlso Not IsDBNull(p2) AndAlso Not String.IsNullOrWhiteSpace(p2.ToString()) Then list.Add(p2.ToString().Trim())
        If p3 IsNot Nothing AndAlso Not IsDBNull(p3) AndAlso Not String.IsNullOrWhiteSpace(p3.ToString()) Then list.Add(p3.ToString().Trim())
        If list.Count = 0 Then Return "-"
        If list.Count = 1 Then Return HttpUtility.HtmlEncode(list(0))
        Dim sb As New StringBuilder()
        For i As Integer = 0 To list.Count - 1
            If sb.Length > 0 Then sb.Append("<br />")
            sb.Append((i + 1).ToString()).Append(". ").Append(HttpUtility.HtmlEncode(list(i)))
        Next
        Return sb.ToString()
    End Function

    Private Function FormatLokasiPasarTeks(ByVal p1 As Object, ByVal p2 As Object, ByVal p3 As Object) As String
        Dim list As New List(Of String)
        If p1 IsNot Nothing AndAlso Not IsDBNull(p1) AndAlso Not String.IsNullOrWhiteSpace(p1.ToString()) Then list.Add(p1.ToString().Trim())
        If p2 IsNot Nothing AndAlso Not IsDBNull(p2) AndAlso Not String.IsNullOrWhiteSpace(p2.ToString()) Then list.Add(p2.ToString().Trim())
        If p3 IsNot Nothing AndAlso Not IsDBNull(p3) AndAlso Not String.IsNullOrWhiteSpace(p3.ToString()) Then list.Add(p3.ToString().Trim())
        If list.Count = 0 Then Return "-"
        If list.Count = 1 Then Return list(0)
        Dim sb As New StringBuilder()
        For i As Integer = 0 To list.Count - 1
            If sb.Length > 0 Then sb.Append(vbCrLf)
            sb.Append((i + 1).ToString()).Append(". ").Append(list(i))
        Next
        Return sb.ToString()
    End Function

    Protected Function FormatJumlahAnjing(ByVal jantan As Object, ByVal betina As Object, ByVal jantanMandul As Object, ByVal betinaMandul As Object) As Integer
        Dim total As Integer = 0
        total += KiraItemComma(jantan)
        total += KiraItemComma(betina)
        total += KiraItemComma(jantanMandul)
        total += KiraItemComma(betinaMandul)
        Return total
    End Function

    Private Function KiraItemComma(ByVal v As Object) As Integer
        If v Is Nothing OrElse IsDBNull(v) Then Return 0
        Dim s As String = v.ToString()
        If String.IsNullOrWhiteSpace(s) Then Return 0
        Dim parts = s.Split(","c)
        Dim sum As Integer = 0
        For Each p In parts
            Dim n As Integer = 0
            If Integer.TryParse(p.Trim(), n) Then sum += n
        Next
        Return sum
    End Function

    Protected Function FormatBakaAnjing(ByVal v As Object) As String
        If v Is Nothing OrElse IsDBNull(v) Then Return "-"
        Dim s As String = v.ToString().Trim()
        If String.IsNullOrEmpty(s) Then Return "-"
        Return s.Replace(",", ", ").ToUpperInvariant()
    End Function

    Private Function DapatkanTajukLaporan(ByVal reportType As Integer) As String
        Select Case reportType
            Case 1 : Return "LAPORAN PERMOHONAN LESEN PERNIAGAAN /PERMIT"
            Case 2 : Return "LAPORAN PERMOHONAN PEMBATALAN"
            Case 3 : Return "LAPORAN PERMOHONAN YANG BELUM DAPAT ULASAN INSPEKTORAT"
            Case 4 : Return "LAPORAN PERMOHONAN SEPANDUK"
            Case 5 : Return "LAPORAN PERMOHONAN LESEN PASAR LAMBAK / PASAR PAGI"
            Case 6 : Return "LAPORAN PERMOHONAN LESEN ANJING"
            Case 7 : Return "LAPORAN PERMOHONAN LESEN PENJAJA"
            Case Else : Return "LAPORAN PERMOHONAN"
        End Select
    End Function

    Private Function DapatkanKodLaporan(ByVal reportType As Integer) As String
        Select Case reportType
            Case 1 : Return "Perniagaan_Permit"
            Case 2 : Return "Pembatalan"
            Case 3 : Return "Belum_Ulasan_Inspektorat"
            Case 4 : Return "Sepanduk"
            Case 5 : Return "Pasar_Lambak"
            Case 6 : Return "Lesen_Anjing"
            Case 7 : Return "Lesen_Penjaja"
            Case Else : Return "Permohonan"
        End Select
    End Function

    '===================== EKSPORT EXCEL (.xlsx sebenar) =====================
    Private Function DapatkanLebarLajur(ByVal reportType As Integer) As Double()
        Select Case reportType
            Case 1 : Return New Double() {5, 18, 20, 26, 26, 32, 22, 14}
            Case 2 : Return New Double() {5, 18, 20, 24, 24, 28, 20, 18, 20, 18, 14}
            Case 3 : Return New Double() {5, 18, 20, 26, 26, 32, 24, 20}
            Case 4 : Return New Double() {5, 18, 20, 26, 24, 22, 30, 16, 16, 20, 10, 8}
            Case 5 : Return New Double() {5, 18, 20, 26, 32, 24, 14, 14}
            Case 6 : Return New Double() {5, 18, 20, 26, 32, 14, 20, 22, 14}
            Case 7 : Return New Double() {5, 18, 20, 26, 32, 24, 14}
            Case Else : Return New Double() {5, 18, 20, 26, 26, 26, 20, 14}
        End Select
    End Function

    Private Function DapatkanTajukKolum(ByVal reportType As Integer) As String()
        Select Case reportType
            Case 1
                Return New String() {"Bil", "Tarikh Permohonan", "No Fail", "Nama Pemohon", "Nama Syarikat", "Alamat Perniagaan", "Jenis Perniagaan/Permit", "Status"}
            Case 2
                Return New String() {"Bil", "Tarikh Permohonan", "No Fail", "Nama Pemohon", "Nama Syarikat", "Alamat Perniagaan", "Jenis Perniagaan/Permit", "Jenis Pembatalan", "Sebab Pembatalan", "Status Wang Amanah (tindakan pembatalan)", "Status"}
            Case 3
                Return New String() {"Bil", "Tarikh Permohonan", "No Fail", "Nama Pemohon", "Nama Syarikat", "Alamat Perniagaan", "Jenis Perniagaan/Permit/ Pembatalan", "Status Ulasan Inspektorat"}
            Case 4
                Return New String() {"Bil", "Tarikh Permohonan", "No Fail", "Nama Pemohon/ Nama Syarikat", "Nama Kontraktor Yang Memasang Iklan", "Tempoh Pemasangan", "Lokasi Pemasangan", "No Resit", "No Siri Stiker", "Jenis Permit Sepanduk /Bunting", "Ukuran", "Qty"}
            Case 5
                Return New String() {"Bil", "Tarikh Permohonan", "No Fail", "Nama Pemohon", "Lokasi Pasar Lambak", "Jenis Perniagaan (Jenis Jualan)", "Jumlah Petak", "Status"}
            Case 6
                Return New String() {"Bil", "Tarikh Permohonan", "No Fail", "Nama Pemohon", "Alamat Premis", "Jumlah Anjing", "Jenis Lesen Anjing", "Baka Anjing", "Status"}
            Case 7
                Return New String() {"Bil", "Tarikh Permohonan", "No Fail", "Nama Pemohon", "Lokasi Penjaja", "Jenis Perniagaan (Jenis Jualan)", "Status"}
            Case Else
                Return New String() {"Bil", "Tarikh Permohonan", "No Fail", "Nama Pemohon", "Status"}
        End Select
    End Function

    Private Function BinaXlsx(ByVal dt As DataTable, ByVal reportType As Integer) As Byte()
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
                "<sheets><sheet name=""Laporan Permohonan"" sheetId=""1"" r:id=""rId1""/></sheets></workbook>")
            TulisBahagian(zip, "xl/_rels/workbook.xml.rels",
                "<?xml version=""1.0"" encoding=""UTF-8"" standalone=""yes""?>" &
                "<Relationships xmlns=""http://schemas.openxmlformats.org/package/2006/relationships"">" &
                "<Relationship Id=""rId1"" Type=""http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet"" Target=""worksheets/sheet1.xml""/>" &
                "<Relationship Id=""rId2"" Type=""http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles"" Target=""styles.xml""/>" &
                "</Relationships>")
            TulisBahagian(zip, "xl/styles.xml", GayaXlsx())
            TulisBahagian(zip, "xl/worksheets/sheet1.xml", LembaranXlsx(dt, reportType, j))
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

    Private Function LembaranXlsx(ByVal dt As DataTable, ByVal reportType As Integer, ByVal j As Tuple(Of DateTime, DateTime)) As String
        Dim sb As New StringBuilder()
        Dim lebarLajur = DapatkanLebarLajur(reportType)
        Dim tajukKolum = DapatkanTajukKolum(reportType)
        Dim tajukLaporan = DapatkanTajukLaporan(reportType)

        sb.Append("<?xml version=""1.0"" encoding=""UTF-8"" standalone=""yes""?>")
        sb.Append("<worksheet xmlns=""http://schemas.openxmlformats.org/spreadsheetml/2006/main"">")
        sb.Append("<sheetPr><pageSetUpPr fitToPage=""1""/></sheetPr>")
        sb.Append("<sheetViews><sheetView workbookViewId=""0""><pane ySplit=""4"" topLeftCell=""A5"" activePane=""bottomLeft"" state=""frozen""/><selection pane=""bottomLeft""/></sheetView></sheetViews>")
        sb.Append("<sheetFormatPr defaultRowHeight=""15""/>")
        sb.Append("<cols>")
        For i As Integer = 0 To lebarLajur.Length - 1
            sb.Append("<col min=""" & (i + 1) & """ max=""" & (i + 1) & """ width=""" & lebarLajur(i).ToString(CultureInfo.InvariantCulture) & """ customWidth=""1""/>")
        Next
        sb.Append("</cols><sheetData>")

        sb.Append("<row r=""1"" ht=""22"" customHeight=""1"">" & SelStr("A1", tajukLaporan, 1) & "</row>")
        sb.Append("<row r=""2"">" & SelStr("A2", "dari " & j.Item1.ToString("dd/MM/yyyy") & " hingga " & j.Item2.ToString("dd/MM/yyyy") & " | Dijana: " & DateTime.Now.ToString("dd/MM/yyyy HH:mm"), 2) & "</row>")

        ' Baris Tajuk Jadual (Row 4)
        sb.Append("<row r=""4"" ht=""35"" customHeight=""1"">")
        For i As Integer = 0 To tajukKolum.Length - 1
            sb.Append(SelStr(Ruj(i, 4), tajukKolum(i), 3))
        Next
        sb.Append("</row>")

        Dim baris As Integer = 4
        Dim bil As Integer = 0
        For Each r As DataRow In dt.Rows
            baris += 1
            bil += 1
            sb.Append("<row r=""" & baris & """>")

            Select Case reportType
                Case 1
                    ' Bil, Tarikh, No Fail, Pemohon, Syarikat, Alamat, Jenis Perniagaan, Status
                    sb.Append(SelNum(Ruj(0, baris), bil, 5))
                    sb.Append(SelTar(Ruj(1, baris), r("TarikhMohon")))
                    sb.Append(SelStr(Ruj(2, baris), Convert.ToString(r("Rujukan")), 4))
                    sb.Append(SelStr(Ruj(3, baris), Convert.ToString(r("Pemohon_Name")), 4))
                    sb.Append(SelStr(Ruj(4, baris), Convert.ToString(r("NamaSyarikat")), 4))
                    sb.Append(SelStr(Ruj(5, baris), Convert.ToString(r("AlamatPremis")), 4))
                    sb.Append(SelStr(Ruj(6, baris), Convert.ToString(r("JenisPerniagaan")), 4))
                    sb.Append(SelStr(Ruj(7, baris), DapatkanStatus(r("StatusID")), 5))

                Case 2
                    ' Bil, Tarikh, No Fail, Pemohon, Syarikat, Alamat, Jenis Perniagaan, Jenis Batal, Sebab Batal, Status Wang Amanah, Status
                    sb.Append(SelNum(Ruj(0, baris), bil, 5))
                    sb.Append(SelTar(Ruj(1, baris), r("TarikhMohon")))
                    sb.Append(SelStr(Ruj(2, baris), Convert.ToString(r("Rujukan")), 4))
                    sb.Append(SelStr(Ruj(3, baris), Convert.ToString(r("Pemohon_Name")), 4))
                    sb.Append(SelStr(Ruj(4, baris), Convert.ToString(r("NamaSyarikat")), 4))
                    sb.Append(SelStr(Ruj(5, baris), Convert.ToString(r("AlamatPremis")), 4))
                    sb.Append(SelStr(Ruj(6, baris), Convert.ToString(r("JenisPerniagaan")), 4))
                    sb.Append(SelStr(Ruj(7, baris), Convert.ToString(r("JenisBatal")), 4))
                    sb.Append(SelStr(Ruj(8, baris), Convert.ToString(r("SebabBatal")), 4))
                    sb.Append(SelStr(Ruj(9, baris), Convert.ToString(r("TindakanBatal")), 4))
                    sb.Append(SelStr(Ruj(10, baris), DapatkanStatus(r("StatusID")), 5))

                Case 3
                    ' Bil, Tarikh, No Fail, Pemohon, Syarikat, Alamat, Jenis Perniagaan, Status Ulasan Inspektorat
                    sb.Append(SelNum(Ruj(0, baris), bil, 5))
                    sb.Append(SelTar(Ruj(1, baris), r("TarikhMohon")))
                    sb.Append(SelStr(Ruj(2, baris), Convert.ToString(r("Rujukan")), 4))
                    sb.Append(SelStr(Ruj(3, baris), Convert.ToString(r("Pemohon_Name")), 4))
                    sb.Append(SelStr(Ruj(4, baris), Convert.ToString(r("NamaSyarikat")), 4))
                    sb.Append(SelStr(Ruj(5, baris), Convert.ToString(r("AlamatPremis")), 4))
                    sb.Append(SelStr(Ruj(6, baris), Convert.ToString(r("JenisPerniagaan")), 4))
                    sb.Append(SelStr(Ruj(7, baris), DapatkanStatusUlasan(r("IsBatal"), r("StatusUlasan"), r("StatusUlasanBatal")), 5))

                Case 4
                    ' Bil, Tarikh, No Fail, Pemohon/Syarikat, Kontraktor, Tempoh, Lokasi, No Resit, No Siri Stiker, Jenis Permit, Ukuran, Qty
                    sb.Append(SelNum(Ruj(0, baris), bil, 5))
                    sb.Append(SelTar(Ruj(1, baris), r("TarikhMohon")))
                    sb.Append(SelStr(Ruj(2, baris), Convert.ToString(r("Rujukan")), 4))
                    sb.Append(SelStr(Ruj(3, baris), Convert.ToString(r("Pemohon_Name")), 4))
                    sb.Append(SelStr(Ruj(4, baris), Convert.ToString(r("KontraktorIklan")), 4))
                    sb.Append(SelStr(Ruj(5, baris), FormatTempohBanting(r("TarikhBanting1"), r("TarikhBanting2")), 5))
                    sb.Append(SelStr(Ruj(6, baris), FormatLokasiSepandukTeks(r("LokasiList")), 4))
                    sb.Append(SelStr(Ruj(7, baris), Convert.ToString(r("NoResitBanting")), 5))
                    sb.Append(SelStr(Ruj(8, baris), Convert.ToString(r("NoSiriStiker")), 5))
                    sb.Append(SelStr(Ruj(9, baris), Convert.ToString(r("JenisBanting")), 4))
                    sb.Append(SelStr(Ruj(10, baris), Convert.ToString(r("UkuranBanting")), 5))
                    sb.Append(SelStr(Ruj(11, baris), Convert.ToString(r("BilBanting")), 5))

                Case 5
                    ' Bil, Tarikh, No Fail, Pemohon, Lokasi, Jenis Perniagaan, Jumlah Petak, Status
                    sb.Append(SelNum(Ruj(0, baris), bil, 5))
                    sb.Append(SelTar(Ruj(1, baris), r("TarikhMohon")))
                    sb.Append(SelStr(Ruj(2, baris), Convert.ToString(r("Rujukan")), 4))
                    sb.Append(SelStr(Ruj(3, baris), Convert.ToString(r("Pemohon_Name")), 4))
                    sb.Append(SelStr(Ruj(4, baris), FormatLokasiPasarTeks(r("LokasiPasar1"), r("LokasiPasar2"), r("LokasiPasar3")), 4))
                    sb.Append(SelStr(Ruj(5, baris), Convert.ToString(r("JenisPerniagaanPasar")), 4))
                    sb.Append(SelStr(Ruj(6, baris), Convert.ToString(r("JumlahPetak")), 5))
                    sb.Append(SelStr(Ruj(7, baris), DapatkanStatus(r("StatusID")), 5))

                Case 6
                    ' Bil, Tarikh, No Fail, Pemohon, Alamat Premis, Jumlah Anjing, Jenis Lesen Anjing, Baka Anjing, Status
                    sb.Append(SelNum(Ruj(0, baris), bil, 5))
                    sb.Append(SelTar(Ruj(1, baris), r("TarikhMohon")))
                    sb.Append(SelStr(Ruj(2, baris), Convert.ToString(r("Rujukan")), 4))
                    sb.Append(SelStr(Ruj(3, baris), Convert.ToString(r("Pemohon_Name")), 4))
                    sb.Append(SelStr(Ruj(4, baris), Convert.ToString(r("AnjingAlamat")), 4))
                    sb.Append(SelNum(Ruj(5, baris), FormatJumlahAnjing(r("AnjingJantanList"), r("AnjingBetinaList"), r("AnjingJantanMandulList"), r("AnjingBetinaMandulList")), 5))
                    sb.Append(SelStr(Ruj(6, baris), Convert.ToString(r("AnjingJenisPremis")), 4))
                    sb.Append(SelStr(Ruj(7, baris), FormatBakaAnjing(r("BakaAnjingList")), 4))
                    sb.Append(SelStr(Ruj(8, baris), DapatkanStatus(r("StatusID")), 5))

                Case 7
                    ' Bil, Tarikh, No Fail, Pemohon, Lokasi Penjaja, Jenis Perniagaan, Status
                    sb.Append(SelNum(Ruj(0, baris), bil, 5))
                    sb.Append(SelTar(Ruj(1, baris), r("TarikhMohon")))
                    sb.Append(SelStr(Ruj(2, baris), Convert.ToString(r("Rujukan")), 4))
                    sb.Append(SelStr(Ruj(3, baris), Convert.ToString(r("Pemohon_Name")), 4))
                    sb.Append(SelStr(Ruj(4, baris), Convert.ToString(r("AlamatPenjajaan")), 4))
                    sb.Append(SelStr(Ruj(5, baris), Convert.ToString(r("JenisPerniagaanPenjaja")), 4))
                    sb.Append(SelStr(Ruj(6, baris), DapatkanStatus(r("StatusID")), 5))
            End Select

            sb.Append("</row>")
        Next

        baris += 2
        sb.Append("<row r=""" & baris & """>" & SelStr("A" & baris, "Jumlah rekod: " & dt.Rows.Count, 2) & "</row>")
        sb.Append("</sheetData>")
        sb.Append("<pageMargins left=""0.4"" right=""0.4"" top=""0.5"" bottom=""0.5"" header=""0.3"" footer=""0.3""/>")
        sb.Append("<pageSetup paperSize=""9"" orientation=""landscape"" fitToHeight=""0""/>")
        sb.Append("</worksheet>")
        Return sb.ToString()
    End Function

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
        Dim d As DateTime
        If Not DateTime.TryParse(v.ToString(), d) Then Return SelStr(rujukan, "-", 5)
        Dim siri As Double = (d.Date - New DateTime(1899, 12, 30)).TotalDays
        Return "<c r=""" & rujukan & """ s=""6""><v>" & siri.ToString(CultureInfo.InvariantCulture) & "</v></c>"
    End Function

End Class