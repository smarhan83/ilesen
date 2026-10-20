Imports System.Data.SqlClient
Imports System.Configuration
Imports System.IO
Imports System.Data

Partial Class sepandukSemakanIK
    Inherits System.Web.UI.Page

    ' Status & No Rujukan dibaca dari DataKeyNames GridView1 (SemakanIK_ID, SemakanIK_Status, SemakanIK_NoRujukan)
    Private Const JENISLESEN_SEPANDUK As Integer = 27
    Private Const UPLOAD_FOLDER As String = "~/Uploads/Sepanduk/"

    ' ===================== Session keys (temp list sebelum Hantar) =====================
    Private Const SESS_ULASAN As String = "SepandukIK_TempUlasan"
    Private Const SESS_LAMPIRAN As String = "SepandukIK_TempLampiran"
    Private Const SESS_PERMOHONANID As String = "SepandukIK_PilihPermohonanID"
    Private Const SESS_STATUSLESEN As String = "SepandukIK_StatusLesen"           ' 'Berdaftar' / 'Tamat Tempoh' / 'Tidak Berdaftar'
    Private Const SESS_NAMASYARIKAT As String = "SepandukIK_NamaSyarikat"
    Private Const SESS_NOPENDAFTARAN As String = "SepandukIK_NoPendaftaran"
    Private Const SESS_TARIKHLUPUT As String = "SepandukIK_TarikhLuput"
    Private Const SESS_KAEDAH As String = "SepandukIK_Kaedah"                      ' 'QR' / 'Carian'
    Private Const SESS_QRCODE As String = "SepandukIK_QRCode"
    Private Const SESS_NOKELULUSAN As String = "NoPengesahanBanting"

    Private DefaultScreen As String = ""

    Protected Sub Page_Init(sender As Object, e As EventArgs) Handles Me.Init

        Dim sm As ScriptManager = ScriptManager.GetCurrent(Page)

        If sm IsNot Nothing Then
            sm.RegisterPostBackControl(btnTambahLampiran)
        End If

        '// page name initial
        initPageName()
    End Sub

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        Dim sm As ScriptManager = ScriptManager.GetCurrent(Page)

        DefaultScreen = Request.QueryString("list")

        ' Paparan awal sahaja - selepas itu panel diurus oleh butang (Visible disimpan dalam ViewState).
        ' Jika set setiap postback, panel Carian muncul semula semasa Tambah Ulasan / Lampiran.
        If Not IsPostBack Then
            If DefaultScreen = 1 Then
                idListing.Visible = True
                pnlCarian.Visible = False
            Else
                idListing.Visible = False
                pnlCarian.Visible = True
            End If
        End If

        If sm IsNot Nothing Then
            sm.RegisterPostBackControl(btnTambahLampiran)
        End If

        Dim gv As GridView = GridView1
        Dim ds As SqlDataSource = SqlDataSourceGridSemakan

        GlobalClass.GenerateFilter(gv, ds, pnlFilter)

        chkAll.InputAttributes("class") = "form-check-input"
        chkAll.InputAttributes("role") = "switch"
        chkAll.LabelAttributes("class") = "form-check-label"

        '//auto fillup
        If Not IsPostBack Then

            ClearSessionTemp()
            GridViewCarian.DataSource = Nothing
            GridViewCarian.DataBind()


            btnTambahSemakan.Visible =
            (Session.Item("sessionEstateID") IsNot Nothing AndAlso
             CStr(Session.Item("sessionEstateID")) = "3")

            Dim scanCode As String = Request.QueryString("scancode")

            If Not String.IsNullOrEmpty(scanCode) Then
                ' Request.QueryString dah auto URL-decode, so "MPK%2F599%2F401%2F" jadi "MPK/599/401/"
                txtQRCode.Text = scanCode.Trim()

                ' Terus panggil logic "Semak QR" macam button diklik
                btnScanQR_Click(sender, e)
            End If
        End If



    End Sub

    Private Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearch.Click
        Dim ds As SqlDataSource = SqlDataSourceGridSemakan
        GlobalClass.procSearch(ds, pnlFilter)
    End Sub

    Private Sub btnReset_Click(sender As Object, e As EventArgs) Handles btnReset.Click
        Response.Redirect(Request.RawUrl)
    End Sub

    Protected Sub GridView1_PageIndexChanged(sender As Object, e As EventArgs) Handles GridView1.PageIndexChanged
        Dim ds As SqlDataSource = SqlDataSourceGridSemakan
        GlobalClass.procSearch(ds, pnlFilter)
    End Sub

    Protected Sub GridView1_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles GridView1.SelectedIndexChanged
        pnlDetail.Visible = True
        idListing.Visible = False
        pnlCarian.Visible = False
        pnlRekodSemakan.Visible = False

        Dim statusSemasa As String = Trim(Convert.ToString(GridView1.SelectedDataKey("SemakanIK_Status")))
        Dim semakanIkId As Integer = CInt(GridView1.SelectedValue)

        pnlKBInspektorat.Visible = (statusSemasa = "Semakan KB Inspektorat") AndAlso CanSemak(statusSemasa)
        pnlKBLesen.Visible = (statusSemasa = "Semakan KB Lesen") AndAlso CanSemak(statusSemasa)
        pnlKJLesen.Visible = (statusSemasa = "Perakuan KJ Lesen") AndAlso CanSemak(statusSemasa)
        pnlKeraniLesen.Visible = (statusSemasa = "Kemaskini Kewangan") AndAlso CanSemak(statusSemasa)
        pnlTrailKelulusan.Visible = True
        BindTrailKelulusan(semakanIkId, statusSemasa)

        FormView1.ChangeMode(FormViewMode.ReadOnly)
        FormViewKBInspektorat.ChangeMode(FormViewMode.Insert)
        FormViewKBLesen.ChangeMode(FormViewMode.Insert)
        FormViewKJLesen.ChangeMode(FormViewMode.Insert)
        FormViewKerani.ChangeMode(FormViewMode.Insert)

        FormView1.DataBind()
        fvRingkasan.DataBind()

        If statusSemasa = "Perakuan KJ Lesen" Then
            litSyorKBLesen.Text = GetKeputusanPeringkat(semakanIkId, "KB Lesen")
        End If

        If statusSemasa = "Kemaskini Kewangan" Then
            Dim syorKBLesen As String = GetKeputusanPeringkat(semakanIkId, "KB Lesen")
            litTindakanKewangan.Text = syorKBLesen
            ' pra-isi Kewangan_Tindakan berdasarkan syor KB Lesen supaya Kerani tak perlu taip semula
            FormViewKerani.DataBind()
            Dim hdn As HiddenField = DirectCast(FormViewKerani.FindControl("hdnTindakan"), HiddenField)
            If hdn IsNot Nothing Then hdn.Value = syorKBLesen
        End If
    End Sub

    '===================== TRAIL KELULUSAN (garis masa) =====================
    ' Peringkat: Pegawai IK -> KB Inspektorat -> KB Lesen -> KJ Lesen -> Kewangan (jika syor wang amanah) -> Keputusan akhir
    Private Sub BindTrailKelulusan(semakanIkId As Integer, statusSemasa As String)
        Dim connStr As String = ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString
        Dim semakan As New DataTable(), kelulusan As New DataTable(), kewangan As New DataTable()

        Using conn As New SqlConnection(connStr)
            Dim sqlSemakan As String = "SELECT a.SemakanIK_TarikhSemakan, a.CreatedDt, a.LastModDt, a.SemakanIK_StatusPemeriksaan, u.Users_Fullname AS Oleh " &
                "FROM LESEN_SepandukSemakanIK a LEFT JOIN TBL_USERS u ON CAST(u.Users_Id AS nvarchar(50)) = a.SemakanIK_PegawaiID " &
                "WHERE a.SemakanIK_ID = @ID"
            Dim sqlKelulusan As String = "SELECT k.Kelulusan_Peringkat, k.Kelulusan_Keputusan, k.Kelulusan_Catatan, k.Kelulusan_Tarikh, u.Users_Fullname AS Oleh " &
                "FROM LESEN_SepandukKelulusan k LEFT JOIN TBL_USERS u ON u.Users_Id = k.Kelulusan_PegawaiID " &
                "WHERE k.Kelulusan_SemakanIKID = @ID ORDER BY k.Kelulusan_ID"
            Dim sqlKewangan As String = "SELECT TOP 1 w.Kewangan_Tindakan, w.Kewangan_Jumlah, w.Kewangan_NoResit, w.Kewangan_Catatan, w.CreatedDt, u.Users_Fullname AS Oleh " &
                "FROM LESEN_SepandukKewangan w LEFT JOIN TBL_USERS u ON u.Users_Id = w.Kewangan_PegawaiID " &
                "WHERE w.Kewangan_SemakanIKID = @ID ORDER BY w.Kewangan_ID DESC"
            For Each pair In {New With {.Sql = sqlSemakan, .Dt = semakan}, New With {.Sql = sqlKelulusan, .Dt = kelulusan}, New With {.Sql = sqlKewangan, .Dt = kewangan}}
                Using cmd As New SqlCommand(pair.Sql, conn)
                    cmd.Parameters.AddWithValue("@ID", semakanIkId)
                    Using da As New SqlDataAdapter(cmd)
                        da.Fill(pair.Dt)
                    End Using
                End Using
            Next
        End Using

        Dim steps As New DataTable()
        For Each c In {"StepStatus", "Tajuk", "Keputusan", "KeputusanCss", "Tarikh", "Oleh", "Catatan", "Ikon"}
            steps.Columns.Add(c)
        Next

        ' Indeks peringkat semasa (0-based). 6 = proses tamat.
        Dim semasa As Integer
        Select Case statusSemasa
            Case "Semakan KB Inspektorat" : semasa = 1
            Case "Semakan KB Lesen" : semasa = 2
            Case "Perakuan KJ Lesen" : semasa = 3
            Case "Kemaskini Kewangan" : semasa = 4
            Case Else : semasa = 6   ' Selesai / Tidak Diperakukan
        End Select

        ' 1) Pegawai IK
        If semakan.Rows.Count > 0 Then
            Dim r As DataRow = semakan.Rows(0)
            Dim tarikh As Object = If(IsDBNull(r("CreatedDt")), r("SemakanIK_TarikhSemakan"), r("CreatedDt"))
            steps.Rows.Add("done", "Semakan Pegawai IK", GetHasilText(r("SemakanIK_StatusPemeriksaan")), "kp-" & GetHasilCss(r("SemakanIK_StatusPemeriksaan")),
                           FormatTarikh(tarikh), Convert.ToString(r("Oleh")), "", "bi-search")
        End If

        ' 2-4) KB Inspektorat, KB Lesen, KJ Lesen
        Dim peringkat As String() = {"KB Inspektorat", "KB Lesen", "KJ Lesen"}
        Dim tajuk As String() = {"Semakan & Sokongan KB Inspektorat", "Syor Tindakan KB Lesen", "Perakuan KJ Lesen"}
        Dim ikon As String() = {"bi-shield-check", "bi-clipboard-check", "bi-patch-check"}
        For i As Integer = 0 To 2
            Dim rows() As DataRow = kelulusan.Select("Kelulusan_Peringkat = '" & peringkat(i) & "'")
            Dim idx As Integer = i + 1
            If rows.Length > 0 AndAlso idx < semasa Then
                Dim r As DataRow = rows(rows.Length - 1)
                Dim kep As String = Convert.ToString(r("Kelulusan_Keputusan"))
                steps.Rows.Add("done", tajuk(i), kep, KeputusanCss(kep), FormatTarikh(r("Kelulusan_Tarikh")), Convert.ToString(r("Oleh")), Convert.ToString(r("Kelulusan_Catatan")), ikon(i))
            ElseIf idx = semasa Then
                steps.Rows.Add("current", tajuk(i), "", "", "Menunggu tindakan", "", "", ikon(i))
            Else
                steps.Rows.Add("pending", tajuk(i), "", "", "Belum selesai", "", "", ikon(i))
            End If
        Next

        ' 5) Kewangan - hanya jika syor KB Lesen melibatkan wang amanah
        Dim syorKB As String = GetKeputusanPeringkat(semakanIkId, "KB Lesen")
        Dim perluKewangan As Boolean = (syorKB = "Syor Rampas Wang Amanah" OrElse syorKB = "Syor Kembalikan Wang Amanah")
        If kewangan.Rows.Count > 0 Then
            Dim r As DataRow = kewangan.Rows(0)
            Dim nota As String = "Jumlah: RM " & If(IsDBNull(r("Kewangan_Jumlah")), "-", CDec(r("Kewangan_Jumlah")).ToString("N2")) &
                                 If(IsDBNull(r("Kewangan_NoResit")) OrElse Convert.ToString(r("Kewangan_NoResit")) = "", "", " | No resit: " & Convert.ToString(r("Kewangan_NoResit")))
            If Convert.ToString(r("Kewangan_Catatan")) <> "" Then nota &= vbLf & Convert.ToString(r("Kewangan_Catatan"))
            steps.Rows.Add("done", "Kemaskini Kewangan", Convert.ToString(r("Kewangan_Tindakan")), "kp-warn", FormatTarikh(r("CreatedDt")), Convert.ToString(r("Oleh")), nota, "bi-cash-coin")
        ElseIf semasa = 4 Then
            steps.Rows.Add("current", "Kemaskini Kewangan", "", "", "Menunggu tindakan", "", "", "bi-cash-coin")
        ElseIf semasa < 4 AndAlso (perluKewangan OrElse syorKB = "") Then
            steps.Rows.Add("pending", "Kemaskini Kewangan", "", "", "Jika ada syor wang amanah", "", "", "bi-cash-coin")
        End If

        ' 6) Keputusan akhir
        If statusSemasa = "Tidak Diperakukan" Then
            steps.Rows.Add("rejected", "Tidak Diperakukan", "", "", "Proses tamat", "", "", "bi-x-octagon")
        ElseIf statusSemasa = "Selesai" Then
            steps.Rows.Add("done", "Selesai", "", "", "Proses tamat", "", "", "bi-flag")
        Else
            steps.Rows.Add("pending", "Selesai", "", "", "Belum selesai", "", "", "bi-flag")
        End If

        litTrailRoad.Text = BuildTrailRoad(steps)
    End Sub

    ' Laluan berliku: 3 checkpoint sebaris, baris genap terbalik arah (kanan -> turun -> kiri -> turun ...)
    Private Function BuildTrailRoad(steps As DataTable) As String
        Const perBaris As Integer = 3
        Dim sb As New System.Text.StringBuilder("<div class=""road"">")
        Dim n As Integer = steps.Rows.Count

        For mula As Integer = 0 To n - 1 Step perBaris
            Dim baris As Integer = mula \ perBaris
            Dim terbalik As Boolean = (baris Mod 2 = 1)
            Dim akhir As Integer = Math.Min(mula + perBaris, n) - 1
            sb.Append("<div class=""road-row" & If(terbalik, " rev", "") & """>")

            For k As Integer = 0 To perBaris - 1
                Dim i As Integer = mula + k
                If k > 0 Then
                    ' segmen hijau jika peringkat sebelumnya selesai dan peringkat ini wujud
                    Dim segCss As String = If(i > akhir, "ghost", If(steps.Rows(i - 1)("StepStatus").ToString() = "done", "done", ""))
                    sb.Append("<div class=""road-seg " & segCss & """></div>")
                End If

                If i <= akhir Then
                    Dim r As DataRow = steps.Rows(i)
                    Dim status As String = r("StepStatus").ToString()
                    Dim tarikh As String = r("Tarikh").ToString()
                    Dim subTeks As String
                    If (status = "done" OrElse status = "rejected") AndAlso tarikh.Length >= 11 AndAlso Char.IsDigit(tarikh(0)) Then
                        subTeks = tarikh.Substring(0, 11)
                    Else
                        subTeks = tarikh
                    End If
                    ' tooltip: catatan (jika ada)
                    Dim tip As String = ""
                    If r("Catatan").ToString() <> "" Then tip = "Catatan: " & r("Catatan").ToString()

                    sb.Append("<div class=""road-node " & status & """" & If(tip = "", "", " title=""" & HttpUtility.HtmlAttributeEncode(tip) & """") & ">")
                    sb.Append("<div class=""road-dot"">" & StepIcon(r("Ikon")) & "</div>")
                    sb.Append("<div class=""road-text"">")
                    sb.Append("<div class=""road-title"">" & HttpUtility.HtmlEncode(r("Tajuk").ToString()) & "</div>")
                    sb.Append("<div class=""road-sub"">" & HttpUtility.HtmlEncode(subTeks) & "</div>")
                    If r("Oleh").ToString() <> "" Then
                        sb.Append("<div class=""road-by""><i class=""bi bi-person""></i>" & HttpUtility.HtmlEncode(r("Oleh").ToString()) & "</div>")
                    End If
                    If r("Keputusan").ToString() <> "" Then
                        sb.Append("<span class=""road-badge " & r("KeputusanCss").ToString() & """>" & HttpUtility.HtmlEncode(r("Keputusan").ToString()) & "</span>")
                    End If
                    sb.Append("</div></div>")
                Else
                    sb.Append("<div class=""road-node ghost""></div>")
                End If
            Next

            ' lengkung ke baris seterusnya (di tepi kanan untuk baris biasa, kiri untuk baris terbalik)
            If akhir < n - 1 Then
                Dim curveDone As Boolean = (steps.Rows(akhir)("StepStatus").ToString() = "done")
                sb.Append("<div class=""road-curve " & If(terbalik, "left", "right") & If(curveDone, " done", "") & """></div>")
            End If

            sb.Append("</div>")
        Next

        sb.Append("</div>")
        Return sb.ToString()
    End Function

    Private Function FormatTarikh(ByVal v As Object) As String
        If v Is Nothing OrElse IsDBNull(v) Then Return "-"
        Return Convert.ToDateTime(v).ToString("dd MMM yyyy hh:mm tt")
    End Function

    Private Function KeputusanCss(ByVal keputusan As String) As String
        Select Case keputusan
            Case "Sokong", "Diperakukan" : Return "kp-ok"
            Case "Tidak Sokong", "Tidak Diperakukan" : Return "kp-bad"
            Case "Syor Rampas Wang Amanah", "Syor Kembalikan Wang Amanah" : Return "kp-warn"
            Case Else : Return "kp-info"
        End Select
    End Function

    ' Ikon proses bagi setiap peringkat; warna bulatan (CSS) menunjukkan status
    Protected Function StepIcon(ByVal ikon As Object) As String
        Return "<i class=""bi " & HttpUtility.HtmlAttributeEncode(Convert.ToString(ikon)) & """></i>"
    End Function

    Private Function GetKeputusanPeringkat(semakanIkId As Integer, peringkat As String) As String
        Dim connStr As String = ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString
        Dim hasil As String = ""
        Using conn As New SqlConnection(connStr)
            Dim sql As String = "SELECT TOP 1 Kelulusan_Keputusan FROM LESEN_SepandukKelulusan WHERE Kelulusan_SemakanIKID = @ID AND Kelulusan_Peringkat = @Peringkat ORDER BY Kelulusan_ID DESC"
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@ID", semakanIkId)
                cmd.Parameters.AddWithValue("@Peringkat", peringkat)
                conn.Open()
                Dim result = cmd.ExecuteScalar()
                If result IsNot Nothing Then hasil = CStr(result)
            End Using
        End Using
        Return hasil
    End Function

    Protected Sub InsertCancelButton_Click(sender As Object, e As EventArgs)
        ResetPanel()
    End Sub

    Protected Sub btnKembaliDetail_Click(sender As Object, e As EventArgs) Handles btnKembaliDetail.Click
        ResetPanel()
    End Sub

    Private Sub ResetPanel()

        ' Kembali ke senarai jika URL ?list=1 atau pengguna masuk melalui butang "Lihat Senarai"
        If DefaultScreen = 1 OrElse CBool(If(ViewState("PaparSenarai"), False)) Then
            idListing.Visible = True
            pnlCarian.Visible = False
        Else
            idListing.Visible = False
            pnlCarian.Visible = True
        End If

        pnlDetail.Visible = False

        pnlRekodSemakan.Visible = False

        pnlKBInspektorat.Visible = False
        pnlKBLesen.Visible = False
        pnlKJLesen.Visible = False
        pnlKeraniLesen.Visible = False
        GridView1.SelectedIndex = -1
        ClearSessionTemp()
    End Sub

    Private Sub ClearSessionTemp()
        Session.Remove(SESS_ULASAN)
        Session.Remove(SESS_LAMPIRAN)
        Session.Remove(SESS_PERMOHONANID)
        Session.Remove(SESS_STATUSLESEN)
        Session.Remove(SESS_NAMASYARIKAT)
        Session.Remove(SESS_NOPENDAFTARAN)
        Session.Remove(SESS_TARIKHLUPUT)
        Session.Remove(SESS_NOKELULUSAN)
        Session.Remove(SESS_KAEDAH)
        Session.Remove(SESS_QRCODE)
    End Sub

    '===================== PEGAWAI IK: BUKA CARIAN =====================
    Protected Sub btnTambahSemakan_Click(sender As Object, e As EventArgs) Handles btnTambahSemakan.Click
        idListing.Visible = False
        pnlCarian.Visible = True
        pnlRekodSemakan.Visible = False

        ClearSessionTemp()
        GridViewCarian.DataSource = Nothing
        GridViewCarian.DataBind()
    End Sub

    ' Butang "Lihat Senarai" pada panel Carian - terus ke senarai (ResetPanel hanya papar senarai jika URL ada ?list=1)
    Protected Sub btnBatalCarian_Click(sender As Object, e As EventArgs) Handles btnBatalCarian.Click
        ViewState("PaparSenarai") = True
        ResetPanel()
        idListing.Visible = True
        pnlCarian.Visible = False
        GridView1.DataBind()
    End Sub

    '===================== PEGAWAI IK: SCAN QR =====================
    Protected Sub btnScanQR_Click(sender As Object, e As EventArgs) Handles btnScanQR.Click
        Dim kod As String = Trim(txtQRCode.Text)
        If kod = "" Then Exit Sub

        Session.Item(SESS_KAEDAH) = "QR"
        Session.Item(SESS_QRCODE) = kod

        '// TODO: sesuaikan cara decode QR sebenar - andaian: QR menyimpan NoPendaftaran terus
        CariRekodPermohonan("(Rujukan = @kw OR Permohonan_ID IN (SELECT Permohonan_ID FROM LESEN_BantingImej WHERE UniqueID = @kw))", kod)
    End Sub

    '===================== PEGAWAI IK: CARIAN MANUAL =====================
    Protected Sub btnCariManual_Click(sender As Object, e As EventArgs) Handles btnCariManual.Click
        Dim kw As String = Trim(txtCarian.Text)
        If kw = "" Then Exit Sub

        Session.Item(SESS_KAEDAH) = "Carian"

        CariRekodPermohonan("(NoPendaftaran LIKE @kwLike OR NamaSyarikat LIKE @kwLike OR AlamatPremis LIKE @kwLike OR Rujukan LIKE @kwLike OR Permohonan_ID IN (SELECT Permohonan_ID FROM LESEN_BantingImej WHERE UniqueID LIKE @kwLike))", kw)
    End Sub

    Private Sub CariRekodPermohonan(whereClause As String, keyword As String)
        Dim connStr As String = ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString
        Dim dt As New DataTable()

        Using conn As New SqlConnection(connStr)
            Dim sql As String = "SELECT * " &
                                 "FROM LESEN_Permohonan WHERE (JenisLesen_ID = @JenisLesenID OR (',' + ISNULL(JenisLesenIdList,'') + ',') LIKE '%,' + CAST(@JenisLesenID AS VARCHAR(10)) + ',%')  AND " & whereClause

            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@JenisLesenID", JENISLESEN_SEPANDUK)
                If whereClause.Contains("@kwLike") Then
                    cmd.Parameters.AddWithValue("@kwLike", "%" & keyword & "%")
                Else
                    cmd.Parameters.AddWithValue("@kw", keyword)
                End If
                Using da As New SqlDataAdapter(cmd)
                    da.Fill(dt)
                End Using
            End Using
        End Using

        GridViewCarian.DataSource = dt
        GridViewCarian.DataBind()
    End Sub

    Protected Sub GridViewCarian_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles GridViewCarian.RowCommand
        If e.CommandName = "PilihRekod" Then
            Dim permohonanId As Integer = CInt(e.CommandArgument)
            MuatMaklumatPermohonan(permohonanId)
            ' Status lesen dikira daripada tarikh pengesahan permohonan (bukan ditetapkan tetap)
            BukaBorangRekod(statusLesen:=KiraStatusLesen(permohonanId), dijumpai:=True)

            ' Cari row index yang berkaitan dengan butang yang diklik
            Dim btn As LinkButton = DirectCast(e.CommandSource, LinkButton)
            Dim row As GridViewRow = DirectCast(btn.NamingContainer, GridViewRow)
            GridViewCarian.SelectedIndex = row.RowIndex

            FormViewIklanBerdaftar.DataBind()
        End If
    End Sub

    Private Sub MuatMaklumatPermohonan(permohonanId As Integer)
        Dim connStr As String = ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString
        Using conn As New SqlConnection(connStr)
            Dim sql As String = "SELECT * FROM LESEN_Permohonan WHERE Permohonan_ID = @ID"
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@ID", permohonanId)
                conn.Open()
                Using rdr = cmd.ExecuteReader()
                    If rdr.Read() Then
                        Session.Item(SESS_PERMOHONANID) = permohonanId
                        Session.Item(SESS_NAMASYARIKAT) = If(IsDBNull(rdr("NamaSyarikat")), "", CStr(rdr("NamaSyarikat")))
                        Session.Item(SESS_NOPENDAFTARAN) = If(IsDBNull(rdr("NoPendaftaran")), "", CStr(rdr("NoPendaftaran")))
                        Session.Item(SESS_TARIKHLUPUT) = If(IsDBNull(rdr("TarikhPengesahanBanting2")), "", CStr(rdr("TarikhPengesahanBanting2")))
                        Session.Item(txtAlamatLokasi.UniqueID) = If(IsDBNull(rdr("AlamatPremis")), "", CStr(rdr("AlamatPremis")))
                        Session.Item(SESS_NOKELULUSAN) = If(IsDBNull(rdr("NoPengesahanBanting")), "", CStr(rdr("NoPengesahanBanting")))
                    End If
                End Using
            End Using
        End Using
    End Sub

    ' Status lesen bagi rekod yang dijumpai: dalam tempoh pengesahan = Berdaftar, luar tempoh = Tamat Tempoh, tiada tarikh = Tidak Berdaftar.
    ' Logik sama dengan GetStatusIklan (banner carian).
    Private Function KiraStatusLesen(permohonanId As Integer) As String
        Dim connStr As String = ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString
        Using conn As New SqlConnection(connStr)
            Using cmd As New SqlCommand("SELECT TarikhPengesahanBanting1, TarikhPengesahanBanting2 FROM LESEN_Permohonan WHERE Permohonan_ID = @ID", conn)
                cmd.Parameters.AddWithValue("@ID", permohonanId)
                conn.Open()
                Using rdr = cmd.ExecuteReader()
                    If rdr.Read() Then
                        If IsDBNull(rdr("TarikhPengesahanBanting1")) OrElse IsDBNull(rdr("TarikhPengesahanBanting2")) Then Return "Tidak Berdaftar"
                        Dim t1 As DateTime = Convert.ToDateTime(rdr("TarikhPengesahanBanting1")).Date
                        Dim t2 As DateTime = Convert.ToDateTime(rdr("TarikhPengesahanBanting2")).Date
                        If DateTime.Now.Date >= t1 AndAlso DateTime.Now.Date <= t2 Then Return "Berdaftar"
                        Return "Tamat Tempoh"
                    End If
                End Using
            End Using
        End Using
        Return "Tidak Berdaftar"
    End Function

    '===================== PEGAWAI IK: TIADA REKOD / TIDAK BERDAFTAR =====================
    'Protected Sub btnTiadaRekod_Click(sender As Object, e As EventArgs) Handles btnTiadaRekod.Click
    '    Session.Remove(SESS_PERMOHONANID)
    '    Session.Remove(SESS_NAMASYARIKAT)
    '    Session.Remove(SESS_NOPENDAFTARAN)
    '    Session.Remove(SESS_TARIKHLUPUT)
    '    BukaBorangRekod(statusLesen:="Tidak Berdaftar")
    'End Sub

    Protected Sub btnTiadaRekod_Click(sender As Object, e As EventArgs)
        Session.Remove(SESS_PERMOHONANID)
        Session.Remove(SESS_NAMASYARIKAT)
        Session.Remove(SESS_NOPENDAFTARAN)
        Session.Remove(SESS_TARIKHLUPUT)
        Session.Remove(SESS_NOKELULUSAN)

        BukaBorangRekod(statusLesen:="Tidak Berdaftar")
    End Sub

    Private Sub BukaBorangRekod(statusLesen As String, Optional dijumpai As Boolean = False)
        Session.Item(SESS_STATUSLESEN) = statusLesen
        Session.Item(SESS_ULASAN) = New List(Of String)
        Session.Item(SESS_LAMPIRAN) = New List(Of KeyValuePair(Of String, String))  ' Key=FileName, Value=FilePath

        pnlCarian.Visible = False
        pnlRekodSemakan.Visible = True

        If dijumpai Then
            litTajukRekod.Text = "Rekod Ulasan - Lesen " & statusLesen
            litJenisCatatan.Text = "Ulasan"
            pnlMaklumatDijumpai.Visible = True
            'litNamaSyarikat.Text = CStr(Session.Item(SESS_NAMASYARIKAT))
            'litNoPendaftaran.Text = CStr(Session.Item(SESS_NOPENDAFTARAN))
            'litNoPendaftaranBanner.Text = CStr(Session.Item(SESS_NOPENDAFTARAN))
            'litTarikhLuput.Text = CStr(Session.Item(SESS_TARIKHLUPUT))
            'litNoKelulusanBanner.Text = CStr(Session.Item(SESS_NOKELULUSAN))
        Else
            litTajukRekod.Text = "Rekod Pemerhatian - Tiada Rekod Lesen / Tidak Berdaftar"
            litJenisCatatan.Text = "Pemerhatian"
            pnlMaklumatDijumpai.Visible = False
            txtAlamatLokasi.Text = ""
        End If

        txtCatatanBaru.Text = ""
        BindUlasanSementara()
        BindLampiranSementara()
    End Sub

    Protected Sub btnBatalRekod_Click(sender As Object, e As EventArgs) Handles btnBatalRekod.Click
        pnlRekodSemakan.Visible = False
        pnlCarian.Visible = True
        ClearSessionTemp()
    End Sub

    '===================== TAMBAH / BUANG ULASAN SEMENTARA =====================
    Protected Sub btnTambahUlasan_Click(sender As Object, e As EventArgs) Handles btnTambahUlasan.Click
        Dim catatan As String = Trim(txtCatatanBaru.Text)
        If catatan = "" Then Exit Sub

        Dim senarai As List(Of String) = GetSenaraiUlasan()
        senarai.Add(catatan)
        Session.Item(SESS_ULASAN) = senarai

        txtCatatanBaru.Text = ""
        BindUlasanSementara()
    End Sub

    Protected Sub GridViewUlasanSementara_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles GridViewUlasanSementara.RowCommand
        If e.CommandName = "BuangUlasan" Then
            Dim idx As Integer = CInt(e.CommandArgument)
            Dim senarai As List(Of String) = GetSenaraiUlasan()
            If idx >= 0 AndAlso idx < senarai.Count Then
                senarai.RemoveAt(idx)
                Session.Item(SESS_ULASAN) = senarai
            End If
            BindUlasanSementara()
        End If
    End Sub

    Private Function GetSenaraiUlasan() As List(Of String)
        If Session.Item(SESS_ULASAN) Is Nothing Then Session.Item(SESS_ULASAN) = New List(Of String)
        Return DirectCast(Session.Item(SESS_ULASAN), List(Of String))
    End Function

    Private Sub BindUlasanSementara()
        Dim senarai = GetSenaraiUlasan()
        Dim dt As New DataTable()
        dt.Columns.Add("Catatan")
        For Each item In senarai
            dt.Rows.Add(item)
        Next
        GridViewUlasanSementara.DataSource = dt
        GridViewUlasanSementara.DataBind()
    End Sub

    '===================== TAMBAH / BUANG LAMPIRAN SEMENTARA =====================
    Protected Sub btnTambahLampiran_Click(sender As Object, e As EventArgs) Handles btnTambahLampiran.Click
        If Not fuLampiran.HasFile Then Exit Sub

        Dim folderPath As String = Server.MapPath(UPLOAD_FOLDER)
        If Not Directory.Exists(folderPath) Then Directory.CreateDirectory(folderPath)

        Dim namaFail As String = DateTime.Now.ToString("yyyyMMddHHmmss") & "_" & Path.GetFileName(fuLampiran.FileName)
        Dim fullPath As String = Path.Combine(folderPath, namaFail)
        fuLampiran.SaveAs(fullPath)

        Dim relatifPath As String = UPLOAD_FOLDER.Replace("~", "") & namaFail

        Dim senarai As List(Of KeyValuePair(Of String, String)) = GetSenaraiLampiran()
        senarai.Add(New KeyValuePair(Of String, String)(fuLampiran.FileName, relatifPath))
        Session.Item(SESS_LAMPIRAN) = senarai

        BindLampiranSementara()
    End Sub

    Protected Sub GridViewLampiranSementara_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles GridViewLampiranSementara.RowCommand
        If e.CommandName = "BuangLampiran" Then
            Dim idx As Integer = CInt(e.CommandArgument)
            Dim senarai As List(Of KeyValuePair(Of String, String)) = GetSenaraiLampiran()
            If idx >= 0 AndAlso idx < senarai.Count Then
                senarai.RemoveAt(idx)
                Session.Item(SESS_LAMPIRAN) = senarai
            End If
            BindLampiranSementara()
        End If
    End Sub

    Private Function GetSenaraiLampiran() As List(Of KeyValuePair(Of String, String))
        If Session.Item(SESS_LAMPIRAN) Is Nothing Then Session.Item(SESS_LAMPIRAN) = New List(Of KeyValuePair(Of String, String))
        Return DirectCast(Session.Item(SESS_LAMPIRAN), List(Of KeyValuePair(Of String, String)))
    End Function

    Private Sub BindLampiranSementara()
        Dim senarai = GetSenaraiLampiran()
        Dim dt As New DataTable()
        dt.Columns.Add("FileName")
        dt.Columns.Add("FilePath")
        For Each item In senarai
            dt.Rows.Add(item.Key, item.Value)
        Next
        GridViewLampiranSementara.DataSource = dt
        GridViewLampiranSementara.DataBind()
    End Sub

    '===================== HANTAR REKOD SEMAKAN (INSERT HEADER + ULASAN + LAMPIRAN) =====================
    Protected Sub btnHantarSemakan_Click(sender As Object, e As EventArgs) Handles btnHantarSemakan.Click

        If Not Page.IsValid Then Exit Sub

        Dim senaraiUlasan As List(Of String) = GetSenaraiUlasan()
        If senaraiUlasan.Count = 0 Then
            ShowAlert("warning", "", "Sila tambah sekurang-kurangnya satu catatan sebelum menghantar")
            Exit Sub
        End If

        Dim statusLesen As String = CStr(Session.Item(SESS_STATUSLESEN))
        ' Ulasan = rekod permohonan dijumpai (SESS_PERMOHONANID ditetapkan); Pemerhatian = tiada rekod / tidak berdaftar
        Dim jenisCatatan As String = If(Session.Item(SESS_PERMOHONANID) IsNot Nothing, "Ulasan", "Pemerhatian")
        Dim permohonanId As Object = If(Session.Item(SESS_PERMOHONANID) IsNot Nothing, Session.Item(SESS_PERMOHONANID), DBNull.Value)
        Dim namaSyarikat As Object = If(Session.Item(SESS_NAMASYARIKAT) IsNot Nothing, Session.Item(SESS_NAMASYARIKAT), DBNull.Value)
        Dim noPendaftaran As Object = If(Session.Item(SESS_NOPENDAFTARAN) IsNot Nothing, Session.Item(SESS_NOPENDAFTARAN), DBNull.Value)
        Dim tarikhLuput As Object = DBNull.Value
        If Session.Item(SESS_TARIKHLUPUT) IsNot Nothing AndAlso CStr(Session.Item(SESS_TARIKHLUPUT)) <> "" Then
            tarikhLuput = CDate(Session.Item(SESS_TARIKHLUPUT))
        End If
        Dim kaedah As String = If(Session.Item(SESS_KAEDAH) IsNot Nothing, CStr(Session.Item(SESS_KAEDAH)), "Carian")
        Dim qrCode As Object = If(Session.Item(SESS_QRCODE) IsNot Nothing, Session.Item(SESS_QRCODE), DBNull.Value)
        Dim pegawaiId As String = CStr(Session.Item("sessionUsersId"))

        Dim connStr As String = ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString
        Dim noRujukan As String = "IK/" & DateTime.Now.ToString("yyyy") & "/" & DateTime.Now.ToString("MMddHHmmss")

        Using conn As New SqlConnection(connStr)
            conn.Open()
            Using trans = conn.BeginTransaction()
                Try
                    Dim newId As Integer

                    '// insert header
                    Using cmd As New SqlCommand("
                        INSERT INTO LESEN_SepandukSemakanIK
                            (SemakanIK_PermohonanID, SemakanIK_NoRujukan, SemakanIK_JenisLesen_ID, SemakanIK_KaedahSemakan, SemakanIK_QRCode,
                             SemakanIK_TarikhSemakan, SemakanIK_AlamatLokasi, SemakanIK_StatusLesen, SemakanIK_NamaSyarikat, SemakanIK_NoPendaftaran,
                             SemakanIK_TarikhLuput, SemakanIK_Status, SemakanIK_PegawaiID, SemakanIK_StatusPemeriksaan, CreatorID, CreatedDt, IsActive)
                        OUTPUT INSERTED.SemakanIK_ID
                        VALUES
                            (@PermohonanID, @NoRujukan, @JenisLesenID, @Kaedah, @QRCode,
                             getdate(), @AlamatLokasi, @StatusLesen, @NamaSyarikat, @NoPendaftaran,
                             @TarikhLuput, 'Semakan KB Inspektorat', @PegawaiID, @SemakanIK_StatusPemeriksaan, @PegawaiID, getdate(), 1)", conn, trans)

                        cmd.Parameters.AddWithValue("@PermohonanID", permohonanId)
                        cmd.Parameters.AddWithValue("@NoRujukan", noRujukan)
                        cmd.Parameters.AddWithValue("@JenisLesenID", JENISLESEN_SEPANDUK)
                        cmd.Parameters.AddWithValue("@Kaedah", kaedah)
                        cmd.Parameters.AddWithValue("@QRCode", qrCode)
                        cmd.Parameters.AddWithValue("@AlamatLokasi", txtAlamatLokasi.Text)
                        cmd.Parameters.AddWithValue("@StatusLesen", statusLesen)
                        cmd.Parameters.AddWithValue("@NamaSyarikat", namaSyarikat)
                        cmd.Parameters.AddWithValue("@NoPendaftaran", noPendaftaran)
                        cmd.Parameters.AddWithValue("@TarikhLuput", tarikhLuput)
                        cmd.Parameters.AddWithValue("@PegawaiID", pegawaiId)
                        cmd.Parameters.AddWithValue("@SemakanIK_StatusPemeriksaan", rblStatusPemeriksaan.SelectedValue)

                        newId = CInt(cmd.ExecuteScalar())

                    End Using

                    '// insert setiap ulasan/pemerhatian
                    For Each catatan In senaraiUlasan
                        Using cmd As New SqlCommand("
                            INSERT INTO LESEN_SepandukSemakanIK_Ulasan (Ulasan_SemakanIKID, Ulasan_Jenis, Ulasan_Catatan, Ulasan_PegawaiID, Ulasan_Tarikh, CreatorID, CreatedDt)
                            VALUES (@ID, @Jenis, @Catatan, @PegawaiID, getdate(), @PegawaiID, getdate())", conn, trans)
                            cmd.Parameters.AddWithValue("@ID", newId)
                            cmd.Parameters.AddWithValue("@Jenis", jenisCatatan)
                            cmd.Parameters.AddWithValue("@Catatan", catatan)
                            cmd.Parameters.AddWithValue("@PegawaiID", pegawaiId)
                            cmd.ExecuteNonQuery()

                        End Using
                    Next

                    '// insert setiap lampiran
                    For Each lampiran In GetSenaraiLampiran()
                        Using cmd As New SqlCommand("
                            INSERT INTO LESEN_SepandukSemakanIK_Lampiran (Lampiran_SemakanIKID, Lampiran_FileName, Lampiran_FilePath, CreatorID, CreatedDt)
                            VALUES (@ID, @FileName, @FilePath, @PegawaiID, getdate())", conn, trans)
                            cmd.Parameters.AddWithValue("@ID", newId)
                            cmd.Parameters.AddWithValue("@FileName", lampiran.Key)
                            cmd.Parameters.AddWithValue("@FilePath", lampiran.Value)
                            cmd.Parameters.AddWithValue("@PegawaiID", pegawaiId)
                            cmd.ExecuteNonQuery()
                        End Using
                    Next

                    trans.Commit()

                    GlobalClass.auditTrail("Semakan Sepanduk - Pegawai IK", noRujukan, "Hantar")
                    ShowAlert("success", "", "Rekod berjaya disimpan dan dihantar kepada KB Inspektorat")
                    ResetPanel()
                    GridView1.DataBind()

                Catch ex As Exception
                    trans.Rollback()
                    'MsgBox("Ralat menyimpan rekod: " & ex.Message)
                    'ShowAlert("error", "", "Ralat menyimpan rekod: " & ex.Message)
                End Try
            End Using
        End Using
    End Sub

    '===================== KB INSPEKTORAT =====================
    Protected Sub FormViewKBInspektorat_ItemInserting(sender As Object, e As System.Web.UI.WebControls.FormViewInsertEventArgs) Handles FormViewKBInspektorat.ItemInserting
        Dim noRujukan As String = Convert.ToString(GridView1.SelectedDataKey("SemakanIK_NoRujukan"))
        GlobalClass.auditTrail("Semakan KB Inspektorat", noRujukan, "Kunci Masuk")
    End Sub

    Protected Sub FormViewKBInspektorat_ItemInserted(sender As Object, e As System.Web.UI.WebControls.FormViewInsertedEventArgs) Handles FormViewKBInspektorat.ItemInserted
        If e.Exception Is Nothing Then
            UpdateStatusSemakan(CInt(GridView1.SelectedValue), "Semakan KB Lesen")
            ShowAlert("success", "", "Rekod berjaya disimpan dan dihantar kepada KB Lesen")
            ResetPanel()
            GridView1.DataBind()
        End If
    End Sub

    '===================== KB LESEN =====================
    Protected Sub FormViewKBLesen_ItemInserting(sender As Object, e As System.Web.UI.WebControls.FormViewInsertEventArgs) Handles FormViewKBLesen.ItemInserting
        Dim noRujukan As String = Convert.ToString(GridView1.SelectedDataKey("SemakanIK_NoRujukan"))
        GlobalClass.auditTrail("Semakan KB Lesen", noRujukan, "Kunci Masuk")
    End Sub

    Protected Sub FormViewKBLesen_ItemInserted(sender As Object, e As System.Web.UI.WebControls.FormViewInsertedEventArgs) Handles FormViewKBLesen.ItemInserted
        If e.Exception Is Nothing Then
            UpdateStatusSemakan(CInt(GridView1.SelectedValue), "Perakuan KJ Lesen")
            ShowAlert("success", "", "Rekod berjaya disimpan dan dihantar kepada KJ Lesen")
            ResetPanel()
            GridView1.DataBind()
        End If
    End Sub

    '===================== KJ LESEN =====================
    Protected Sub FormViewKJLesen_ItemInserting(sender As Object, e As System.Web.UI.WebControls.FormViewInsertEventArgs) Handles FormViewKJLesen.ItemInserting
        Dim noRujukan As String = Convert.ToString(GridView1.SelectedDataKey("SemakanIK_NoRujukan"))
        GlobalClass.auditTrail("Perakuan KJ Lesen", noRujukan, "Kunci Masuk")
    End Sub

    Protected Sub FormViewKJLesen_ItemInserted(sender As Object, e As System.Web.UI.WebControls.FormViewInsertedEventArgs) Handles FormViewKJLesen.ItemInserted
        If e.Exception Is Nothing Then
            Dim semakanIkId As Integer = CInt(GridView1.SelectedValue)
            Dim ddlKeputusan As DropDownList = DirectCast(FormViewKJLesen.FindControl("ddlKeputusan"), DropDownList)
            Dim keputusanKJ As String = If(ddlKeputusan IsNot Nothing, ddlKeputusan.SelectedValue, "")

            Dim statusBaru As String

            If keputusanKJ = "Diperakukan" Then
                Dim syorKBLesen As String = GetKeputusanPeringkat(semakanIkId, "KB Lesen")

                If syorKBLesen = "Syor Rampas Wang Amanah" OrElse syorKBLesen = "Syor Kembalikan Wang Amanah" Then
                    '// perlukan tindakan Kerani Lesen untuk kemaskini Wang Amanah
                    statusBaru = "Kemaskini Kewangan"
                Else
                    '// syor = Catatan sahaja, tiada tindakan kewangan diperlukan
                    statusBaru = "Selesai"
                End If
            Else
                statusBaru = "Tidak Diperakukan"
            End If

            UpdateStatusSemakan(semakanIkId, statusBaru)
            ShowAlert("success", "", "Perakuan berjaya disimpan")
            ResetPanel()
            GridView1.DataBind()
        End If
    End Sub

    '===================== KERANI LESEN - KEMASKINI KEWANGAN =====================
    Protected Sub FormViewKerani_ItemInserting(sender As Object, e As System.Web.UI.WebControls.FormViewInsertEventArgs) Handles FormViewKerani.ItemInserting
        Dim noRujukan As String = Convert.ToString(GridView1.SelectedDataKey("SemakanIK_NoRujukan"))
        GlobalClass.auditTrail("Kemaskini Kewangan - Kerani Lesen", noRujukan, "Kunci Masuk")

        '// pastikan Kewangan_Tindakan diisi dari nilai syor KB Lesen (bukan input bebas)
        Dim hdn As HiddenField = DirectCast(FormViewKerani.FindControl("hdnTindakan"), HiddenField)
        If hdn IsNot Nothing Then
            e.Values("Kewangan_Tindakan") = hdn.Value
        End If
    End Sub

    Protected Sub FormViewKerani_ItemInserted(sender As Object, e As System.Web.UI.WebControls.FormViewInsertedEventArgs) Handles FormViewKerani.ItemInserted
        If e.Exception Is Nothing Then
            UpdateStatusSemakan(CInt(GridView1.SelectedValue), "Selesai")
            ShowAlert("success", "", "Kemaskini kewangan berjaya disimpan")
            ResetPanel()
            GridView1.DataBind()
        End If
    End Sub

    '===================== HELPER =====================
    Private Sub UpdateStatusSemakan(semakanIkId As Integer, statusBaru As String)
        Dim connStr As String = ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString

        Using conn As New SqlConnection(connStr)
            Dim sql As String = "UPDATE LESEN_SepandukSemakanIK SET SemakanIK_Status = @Status, LastModID = @ModID, LastModDt = getdate() WHERE SemakanIK_ID = @ID"
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@Status", statusBaru)
                cmd.Parameters.AddWithValue("@ModID", CStr(Session.Item("sessionUsersId")))
                cmd.Parameters.AddWithValue("@ID", semakanIkId)
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Private Sub ShowAlert(statusMsg As String, titleMsg As String, strMsg As String)
        ScriptManager.RegisterStartupScript(Me, Page.GetType, "Script", "Swal.fire('" & titleMsg & "',
        '" & strMsg & "',
        '" & statusMsg & "');", True)
    End Sub

    Private Sub initPageName()
        '// get page name
        Dim menuName As String = GlobalClass.writeTitlePage(Request.QueryString("m_Id"), "")

        Dim idWindowTitle2 As HtmlGenericControl = DirectCast(FormView1.FindControl("idWindowTitle2"), HtmlGenericControl)
        Dim idWindowTitle3 As HtmlGenericControl = DirectCast(FormView1.FindControl("idWindowTitle3"), HtmlGenericControl)

        If menuName = "" Then
            menuName = "Jenis Lesen"
        End If

        'idWindowTitle.InnerText = menuName
        Try
            idWindowTitle2.InnerText = idWindowTitle2.InnerText & " " & menuName
        Catch ex As Exception

        End Try
        Try
            idWindowTitle3.InnerText = idWindowTitle3.InnerText & " " & menuName
        Catch ex As Exception

        End Try

    End Sub

    'Private Sub GridView1_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles GridView1.RowDataBound
    '    If e.Row.RowType <> DataControlRowType.DataRow Then Exit Sub

    '    Dim status As String = DataBinder.Eval(e.Row.DataItem, "SemakanIK_Status").ToString()

    '    Dim btnAction As LinkButton = CType(e.Row.FindControl("btnAction"), LinkButton)

    '    If btnAction Is Nothing Then Exit Sub

    '    Dim canAction As Boolean = False

    '    Select Case status

    '        Case "Semakan KB Inspektorat"
    '            canAction = (Session.Item("sessionIsPenilai") = 1 AndAlso Session.Item("sessionEstateID") = 3)

    '        Case "Semakan KB Lesen"
    '            canAction = (Session.Item("sessionIsPenilai") = 1 AndAlso Session.Item("sessionEstateID") = 1)

    '        Case "Perakuan KJ Lesen"
    '            canAction = (Session.Item("sessionIsPeraku") = 1 AndAlso Session.Item("sessionEstateID") = 1)

    '        Case "Kemaskini Kewangan"
    '            canAction = (
    '            Session.Item("sessionEstateID") = 1 AndAlso
    '            Session.Item("sessionIsPeraku") <> 1 AndAlso
    '            Session.Item("sessionIsPenilai") <> 1
    '        )

    '    End Select

    '    btnAction.Visible = canAction
    'End Sub

    Protected Function CanSemak(status As Object) As Boolean

        Dim sessionIsPenilai As Integer = Convert.ToInt32(Session("sessionIsPenilai"))
        Dim sessionIsPeraku As Integer = Convert.ToInt32(Session("sessionIsPeraku"))
        Dim sessionEstateID As Integer = Convert.ToInt32(Session("sessionEstateID"))

        Select Case status.ToString()

            Case "Semakan KB Inspektorat"
                Return sessionIsPenilai = 1 AndAlso sessionEstateID = 3

            Case "Semakan KB Lesen"
                Return sessionIsPenilai = 1 AndAlso sessionEstateID = 1

            Case "Perakuan KJ Lesen"
                Return sessionIsPeraku = 1 AndAlso sessionEstateID = 1

            Case "Kemaskini Kewangan"
                Return sessionEstateID = 1 AndAlso
                   sessionIsPeraku <> 1 AndAlso
                   sessionIsPenilai <> 1

        End Select

        Return False

    End Function

    Protected Sub SqlDataSourceGridSemakan_Selected(sender As Object, e As SqlDataSourceStatusEventArgs)
        If e.Exception Is Nothing Then
            litJumlah.Text = e.AffectedRows.ToString("N0") & " rekod"
        End If
    End Sub

    ' Hasil pemeriksaan (nilai rblStatusPemeriksaan) -> teks paparan
    Protected Function GetHasilText(ByVal hasil As Object) As String
        Select Case Convert.ToString(hasil)
            Case "Mematuhi" : Return "Mematuhi"
            Case "TidakMematuhi" : Return "Tidak Mematuhi"
            Case "IklanTidakDijumpai" : Return "Iklan Tidak Dijumpai"
            Case "LokasiTidakTepat" : Return "Lokasi Tidak Tepat"
            Case "IklanBerbezaDaripadaKelulusan" : Return "Iklan Berbeza Daripada Kelulusan"
            Case "" : Return "-"
            Case Else : Return Convert.ToString(hasil)
        End Select
    End Function

    Protected Function GetHasilCss(ByVal hasil As Object) As String
        Select Case Convert.ToString(hasil)
            Case "Mematuhi" : Return "ok"
            Case "TidakMematuhi", "IklanBerbezaDaripadaKelulusan" : Return "bad"
            Case "IklanTidakDijumpai", "LokasiTidakTepat" : Return "warn"
            Case Else : Return "none"
        End Select
    End Function

    Protected Function GetNilai(ByVal nilai As Object) As String
        Dim s As String = Convert.ToString(nilai)
        Return If(String.IsNullOrWhiteSpace(s), "-", HttpUtility.HtmlEncode(s))
    End Function

    Protected Function GetTempohIklan(ByVal mula As Object, ByVal tamat As Object) As String
        If mula Is Nothing OrElse IsDBNull(mula) OrElse tamat Is Nothing OrElse IsDBNull(tamat) Then Return "-"
        Return Convert.ToDateTime(mula).ToString("dd/MM/yyyy") & " - " & Convert.ToDateTime(tamat).ToString("dd/MM/yyyy")
    End Function

    ' Path lampiran disimpan sebagai "/Uploads/..." - tukar ikut virtual directory aplikasi (cth. /project/Uploads/...)
    Protected Function GetFileUrl(ByVal path As Object) As String
        Dim s As String = Convert.ToString(path).Trim()
        If s = "" Then Return "#"
        If s.StartsWith("~/") Then Return ResolveUrl(s)
        If s.StartsWith("/") AndAlso Not s.StartsWith("//") Then Return ResolveUrl("~" & s)
        Return s
    End Function

    Protected Function GetStatusCss(ByVal status As Object) As String
        Select Case Convert.ToString(status)
            Case "Semakan KB Inspektorat" : Return "st-ik"
            Case "Semakan KB Lesen" : Return "st-lesen"
            Case "Perakuan KJ Lesen" : Return "st-kj"
            Case "Kemaskini Kewangan" : Return "st-kew"
            Case "Selesai" : Return "st-done"
            Case Else : Return "st-other"
        End Select
    End Function

    Protected Sub GridViewCarian_RowCreated(sender As Object, e As GridViewRowEventArgs)

        If e.Row.RowType = DataControlRowType.Header Then
            e.Row.CssClass = "mobile-grid-header"
        End If

    End Sub

    Protected Function GetStatusAktifBanner(ByVal dataItem As Object) As String
        Dim d1 As Object = DataBinder.Eval(dataItem, "TarikhPengesahanBanting1")
        Dim d2 As Object = DataBinder.Eval(dataItem, "TarikhPengesahanBanting2")

        If d1 Is DBNull.Value OrElse d2 Is DBNull.Value OrElse d1 Is Nothing OrElse d2 Is Nothing Then
            Return "Tidak Aktif"
        End If

        Dim tarikh1 As DateTime = Convert.ToDateTime(d1)
        Dim tarikh2 As DateTime = Convert.ToDateTime(d2)

        If DateTime.Now.Date >= tarikh1.Date AndAlso DateTime.Now.Date <= tarikh2.Date Then
            Return "Aktif"
        Else
            Return "Tidak Aktif"
        End If
    End Function

    Protected Function GetTajukIklanBanner(ByVal dataItem As Object) As String
        Dim d1 As Object = DataBinder.Eval(dataItem, "TarikhPengesahanBanting1")
        Dim d2 As Object = DataBinder.Eval(dataItem, "TarikhPengesahanBanting2")

        If d1 Is DBNull.Value OrElse d2 Is DBNull.Value OrElse d1 Is Nothing OrElse d2 Is Nothing Then
            Return "TAK BERDAFTAR"
        End If

        Dim tarikh1 As DateTime = Convert.ToDateTime(d1)
        Dim tarikh2 As DateTime = Convert.ToDateTime(d2)

        If DateTime.Now.Date >= tarikh1.Date AndAlso DateTime.Now.Date <= tarikh2.Date Then
            Return "BERDAFTAR"
        Else
            Return "TEMPOH TAK SAH"
        End If
    End Function

    Protected Function GetBannerModifierClass(ByVal dataItem As Object) As String


        Select Case GetStatusIklan(dataItem)
            Case 1 : Return ""                 ' Aktif/dalam tempoh -> style asal (hijau)
            Case 0 : Return "ru-xberdaftar"     ' Luar julat / tamat tempoh
            Case Else : Return "ru-xberdaftar"  ' Tiada tarikh langsung
        End Select
    End Function

    Protected Function GetStatusIklan(ByVal dataItem As Object) As Integer
        ' Pulangkan: -1 = tiada tarikh (tak berdaftar), 0 = ada tarikh tapi luar julat (tamat tempoh), 1 = dalam julat (aktif)
        Dim d1 As Object = DataBinder.Eval(dataItem, "TarikhPengesahanBanting1")
        Dim d2 As Object = DataBinder.Eval(dataItem, "TarikhPengesahanBanting2")

        If d1 Is DBNull.Value OrElse d2 Is DBNull.Value OrElse d1 Is Nothing OrElse d2 Is Nothing Then
            Return -1
        End If

        Dim tarikh1 As DateTime = Convert.ToDateTime(d1)
        Dim tarikh2 As DateTime = Convert.ToDateTime(d2)

        If DateTime.Now.Date >= tarikh1.Date AndAlso DateTime.Now.Date <= tarikh2.Date Then
            Return 1
        Else
            Return 0
        End If
    End Function

    Protected Function GetKelulusanStatusHtml(ByVal dataItem As Object) As String
        Dim status As Object = DataBinder.Eval(dataItem, "StatusBanting")
        Dim statusStr As String = If(status Is Nothing OrElse status Is DBNull.Value, "", status.ToString())

        Dim iconSvg As String
        Dim teksStatus As String
        Dim cssClass As String

        Select Case statusStr
            Case "1"
                iconSvg = "<svg width=""16"" height=""16"" viewBox=""0 0 24 24"" fill=""none"" stroke=""currentColor"" stroke-width=""2""><circle cx=""12"" cy=""12"" r=""10""/><path d=""M8 12l2.5 2.5L16 9""/></svg>"
                teksStatus = "Diluluskan"
                cssClass = "ru-status-lulus"
            Case "0"
                iconSvg = "<svg width=""16"" height=""16"" viewBox=""0 0 24 24"" fill=""none"" stroke=""currentColor"" stroke-width=""2""><circle cx=""12"" cy=""12"" r=""10""/><path d=""M15 9l-6 6M9 9l6 6""/></svg>"
                teksStatus = "Tidak Diluluskan"
                cssClass = "ru-status-tolak"
            Case Else
                iconSvg = "<svg width=""16"" height=""16"" viewBox=""0 0 24 24"" fill=""none"" stroke=""currentColor"" stroke-width=""2""><circle cx=""12"" cy=""12"" r=""10""/><path d=""M12 8v4m0 4h.01""/></svg>"
                teksStatus = "Dalam Proses"
                cssClass = "ru-status-proses"
        End Select

        Return "<span class=""ru-status-icon-inline " & cssClass & """>" & iconSvg & "</span><span class=""" & cssClass & """>" & teksStatus & "</span>"
    End Function

    Protected Function GetSemakanIKText(value As Object) As String
        Dim count As Integer = Convert.ToInt32(value)

        If count = 0 Then
            Return ""
        End If

        Return String.Format(
            "{0} Kali Hantar Kepada KB Inspektorat",
            count
        )
    End Function
End Class
