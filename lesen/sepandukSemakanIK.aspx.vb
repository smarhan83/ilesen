Imports System.Data.SqlClient
Imports System.Configuration
Imports System.IO
Imports System.Data

Partial Class sepandukSemakanIK
    Inherits System.Web.UI.Page

    Private Const COL_STATUS As Integer = 6   ' index kolum Status dalam GridView1 (0=ID,1=NoRujukan,2=JenisKes,3=NamaSyarikat,4=Lokasi,5=TarikhSemakan,6=Status)
    Private Const JENISLESEN_SEPANDUK As Integer = 27
    Private Const UPLOAD_FOLDER As String = "~/Uploads/Sepanduk/"

    ' ===================== Session keys (temp list sebelum Hantar) =====================
    Private Const SESS_ULASAN As String = "SepandukIK_TempUlasan"
    Private Const SESS_LAMPIRAN As String = "SepandukIK_TempLampiran"
    Private Const SESS_PERMOHONANID As String = "SepandukIK_PilihPermohonanID"
    Private Const SESS_STATUSLESEN As String = "SepandukIK_StatusLesen"           ' 'Tamat Tempoh' / 'Tidak Berdaftar'
    Private Const SESS_NAMASYARIKAT As String = "SepandukIK_NamaSyarikat"
    Private Const SESS_NOPENDAFTARAN As String = "SepandukIK_NoPendaftaran"
    Private Const SESS_TARIKHLUPUT As String = "SepandukIK_TarikhLuput"
    Private Const SESS_KAEDAH As String = "SepandukIK_Kaedah"                      ' 'QR' / 'Carian'
    Private Const SESS_QRCODE As String = "SepandukIK_QRCode"

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

        If sm IsNot Nothing Then
            sm.RegisterPostBackControl(btnTambahLampiran)
        End If

        Dim gv As GridView = GridView1
        Dim ds As SqlDataSource = SqlDataSourceGridSemakan

        GlobalClass.GenerateFilter(gv, ds, pnlFilter)

        If Not IsPostBack Then
            btnTambahSemakan.Visible =
            (Session.Item("sessionEstateID") IsNot Nothing AndAlso
             CStr(Session.Item("sessionEstateID")) = "3")
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

        Dim statusSemasa As String = Trim(GridView1.SelectedRow.Cells(COL_STATUS).Text)
        Dim semakanIkId As Integer = CInt(GridView1.SelectedValue)

        pnlKBInspektorat.Visible = (statusSemasa = "Semakan KB Inspektorat")
        pnlKBLesen.Visible = (statusSemasa = "Semakan KB Lesen")
        pnlKJLesen.Visible = (statusSemasa = "Perakuan KJ Lesen")
        pnlKeraniLesen.Visible = (statusSemasa = "Kemaskini Kewangan")
        pnlTrailKelulusan.Visible = True

        FormView1.ChangeMode(FormViewMode.ReadOnly)
        FormViewKBInspektorat.ChangeMode(FormViewMode.Insert)
        FormViewKBLesen.ChangeMode(FormViewMode.Insert)
        FormViewKJLesen.ChangeMode(FormViewMode.Insert)
        FormViewKerani.ChangeMode(FormViewMode.Insert)

        FormView1.DataBind()

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
        pnlDetail.Visible = False
        pnlCarian.Visible = False
        pnlRekodSemakan.Visible = False
        idListing.Visible = True
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

    Protected Sub btnBatalCarian_Click(sender As Object, e As EventArgs) Handles btnBatalCarian.Click
        ResetPanel()
    End Sub

    '===================== PEGAWAI IK: SCAN QR =====================
    Protected Sub btnScanQR_Click(sender As Object, e As EventArgs) Handles btnScanQR.Click
        Dim kod As String = Trim(txtQRCode.Text)
        If kod = "" Then Exit Sub

        Session.Item(SESS_KAEDAH) = "QR"
        Session.Item(SESS_QRCODE) = kod

        '// TODO: sesuaikan cara decode QR sebenar - andaian: QR menyimpan NoPendaftaran terus
        CariRekodPermohonan("NoPendaftaran = @kw", kod)
    End Sub

    '===================== PEGAWAI IK: CARIAN MANUAL =====================
    Protected Sub btnCariManual_Click(sender As Object, e As EventArgs) Handles btnCariManual.Click
        Dim kw As String = Trim(txtCarian.Text)
        If kw = "" Then Exit Sub

        Session.Item(SESS_KAEDAH) = "Carian"

        CariRekodPermohonan("(NoPendaftaran LIKE @kwLike OR NamaSyarikat LIKE @kwLike OR AlamatPremis LIKE @kwLike OR Rujukan LIKE @kwLike)", kw)
    End Sub

    Private Sub CariRekodPermohonan(whereClause As String, keyword As String)
        Dim connStr As String = ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString
        Dim dt As New DataTable()

        Using conn As New SqlConnection(connStr)
            Dim sql As String = "SELECT Permohonan_ID, NamaSyarikat, NoPendaftaran, AlamatPremis, TarikhSuratKelulusan " &
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
            BukaBorangRekod(statusLesen:="Tamat Tempoh")
        End If
    End Sub

    Private Sub MuatMaklumatPermohonan(permohonanId As Integer)
        Dim connStr As String = ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString
        Using conn As New SqlConnection(connStr)
            Dim sql As String = "SELECT NamaSyarikat, NoPendaftaran, AlamatPremis, TarikhSuratKelulusan FROM LESEN_Permohonan WHERE Permohonan_ID = @ID"
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@ID", permohonanId)
                conn.Open()
                Using rdr = cmd.ExecuteReader()
                    If rdr.Read() Then
                        Session.Item(SESS_PERMOHONANID) = permohonanId
                        Session.Item(SESS_NAMASYARIKAT) = If(IsDBNull(rdr("NamaSyarikat")), "", CStr(rdr("NamaSyarikat")))
                        Session.Item(SESS_NOPENDAFTARAN) = If(IsDBNull(rdr("NoPendaftaran")), "", CStr(rdr("NoPendaftaran")))
                        Session.Item(SESS_TARIKHLUPUT) = If(IsDBNull(rdr("TarikhSuratKelulusan")), "", CStr(rdr("TarikhSuratKelulusan")))
                        Session.Item(txtAlamatLokasi.UniqueID) = If(IsDBNull(rdr("AlamatPremis")), "", CStr(rdr("AlamatPremis")))
                    End If
                End Using
            End Using
        End Using
    End Sub

    '===================== PEGAWAI IK: TIADA REKOD / TIDAK BERDAFTAR =====================
    Protected Sub btnTiadaRekod_Click(sender As Object, e As EventArgs) Handles btnTiadaRekod.Click
        Session.Remove(SESS_PERMOHONANID)
        Session.Remove(SESS_NAMASYARIKAT)
        Session.Remove(SESS_NOPENDAFTARAN)
        Session.Remove(SESS_TARIKHLUPUT)
        BukaBorangRekod(statusLesen:="Tidak Berdaftar")
    End Sub

    Private Sub BukaBorangRekod(statusLesen As String)
        Session.Item(SESS_STATUSLESEN) = statusLesen
        Session.Item(SESS_ULASAN) = New List(Of String)
        Session.Item(SESS_LAMPIRAN) = New List(Of KeyValuePair(Of String, String))  ' Key=FileName, Value=FilePath

        pnlCarian.Visible = False
        pnlRekodSemakan.Visible = True

        If statusLesen = "Tamat Tempoh" Then
            litTajukRekod.Text = "Rekod Ulasan - Lesen Tamat Tempoh"
            litJenisCatatan.Text = "Ulasan"
            pnlMaklumatDijumpai.Visible = True
            litNamaSyarikat.Text = CStr(Session.Item(SESS_NAMASYARIKAT))
            litNoPendaftaran.Text = CStr(Session.Item(SESS_NOPENDAFTARAN))
            litTarikhLuput.Text = CStr(Session.Item(SESS_TARIKHLUPUT))
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
        Dim jenisCatatan As String = If(statusLesen = "Tamat Tempoh", "Ulasan", "Pemerhatian")
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
                             SemakanIK_TarikhLuput, SemakanIK_Status, SemakanIK_PegawaiID, CreatorID, CreatedDt, IsActive)
                        OUTPUT INSERTED.SemakanIK_ID
                        VALUES
                            (@PermohonanID, @NoRujukan, @JenisLesenID, @Kaedah, @QRCode,
                             getdate(), @AlamatLokasi, @StatusLesen, @NamaSyarikat, @NoPendaftaran,
                             @TarikhLuput, 'Semakan KB Inspektorat', @PegawaiID, @PegawaiID, getdate(), 1)", conn, trans)

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
        Dim noRujukan As String = GridView1.SelectedRow.Cells(1).Text
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
        Dim noRujukan As String = GridView1.SelectedRow.Cells(1).Text
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
        Dim noRujukan As String = GridView1.SelectedRow.Cells(1).Text
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
        Dim noRujukan As String = GridView1.SelectedRow.Cells(1).Text
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

        idWindowTitle.InnerText = menuName
        Try
            idWindowTitle2.InnerText = idWindowTitle2.InnerText & " " & menuName
        Catch ex As Exception

        End Try
        Try
            idWindowTitle3.InnerText = idWindowTitle3.InnerText & " " & menuName
        Catch ex As Exception

        End Try

    End Sub

End Class
