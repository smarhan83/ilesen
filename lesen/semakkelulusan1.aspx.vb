Imports System
Imports System.Collections.Generic
Imports System.Configuration
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Drawing.Imaging
Imports System.IO
Imports System.Linq

Partial Class semakkelulusan1
    Inherits System.Web.UI.Page

#Region "Fields & Constants"

    Private ReadOnly CS As String = ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString
    Private Const MaxFileSizeInBytes As Integer = 5 * 1024 * 1024 ' 5 MB
    Private isHaveButton As Boolean = False

#End Region

#Region "Page Lifecycle & Permissions"

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Page.Form.Attributes.Add("enctype", "multipart/form-data")

        If Not Page.IsPostBack Then
            If Session.Item("sessionEstateID") Is Nothing Then
                GridView1.Visible = False
                filterJenisLesen.Attributes.Add("style", "display:none")
                filterStatus.Attributes.Add("style", "display:none")
                TB_TarikhLulus.Attributes.Add("style", "display:none")
            End If

            If Request.Browser.IsMobileDevice Then
                GridView1.Columns(0).Visible = "false"
                GridView1.Columns(1).Visible = "false"
                GridView1.Columns(2).Visible = "false"
                GridView1.Columns(3).Visible = "false"
                GridView1.Columns(4).Visible = "false"
                GridView1.Columns(5).Visible = "false"
                GridView1.Columns(6).Visible = "true"
            Else
                GridView1.Columns(6).Visible = "false"
            End If
        End If

        Try
            ' Mobile view configuration for Ulasan tabs
            If Not Page.IsPostBack Then
                If Request.Browser.IsMobileDevice Then
                    gvTabUlasan.Columns(2).Visible = "false"
                    gvTabUlasan.Columns(3).Visible = "false"
                    gvTabUlasan.Columns(5).Visible = "false"
                    gvTabUlasan.Columns(4).Visible = "true"

                    gvTabUlasanLuar.Columns(2).Visible = "false"
                    gvTabUlasanLuar.Columns(3).Visible = "false"
                    gvTabUlasanLuar.Columns(5).Visible = "false"
                    gvTabUlasanLuar.Columns(4).Visible = "true"
                Else
                    gvTabUlasan.Columns(4).Visible = "false"
                    gvTabUlasanLuar.Columns(4).Visible = "false"
                End If
            End If
        Catch ex As Exception
        End Try

        Try
            ' Mobile view configuration for Kadar Bayaran tab
            If Not Page.IsPostBack Then
                If Request.Browser.IsMobileDevice Then
                    gvTabBayaran.Columns(2).Visible = "false"
                    gvTabBayaran.Columns(3).Visible = "false"
                    gvTabBayaran.Columns(5).Visible = "false"
                    gvTabBayaran.Columns(4).Visible = "true"
                Else
                    gvTabBayaran.Columns(4).Visible = "false"
                End If
            End If
        Catch ex As Exception
        End Try
    End Sub

    Protected Sub Page_PreRenderComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRenderComplete
        Dim btnback As LinkButton = DirectCast(FormView1.FindControl("btnBack"), LinkButton)
        Dim btnsmu As LinkButton = DirectCast(FormView1.FindControl("BT_SuratMohonUlasan"), LinkButton)

        Dim frmview() As Object = {FormView1}
        Dim lbutton() As Object = {btnback, btnsmu}
        Dim ctlDeny() As Object = {}

        Dim frmwrite As Boolean = GlobalClass.CheckPageWrite("Write", frmview, lbutton, ctlDeny)
        If frmwrite = False Then
            ' Deny write permission handling if required
        End If

        Try
            If GridView1.SelectedIndex >= 0 AndAlso GridView1.SelectedDataKey IsNot Nothing Then
                Dim pid As Integer = 0
                If Integer.TryParse(GridView1.SelectedDataKey.Values(0).ToString(), pid) AndAlso pid > 0 Then
                    PopulateMaklumatPermohonanModal(pid)
                End If
            End If
        Catch ex As Exception
        End Try
    End Sub

    Private Sub initPageName()

    End Sub

#End Region

#Region "Filter & Search (Main GridView1)"

    Private Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearch.Click
        If Session.Item("sessionEstateID") Is Nothing AndAlso txtNoRujukan.Text.Trim().Length = 0 Then
            Response.Redirect(Request.RawUrl)
        End If

        GridView1.DataBind()
        GridView1.Visible = True
    End Sub

    Private Sub btnReset_Click(sender As Object, e As EventArgs) Handles btnReset.Click
        Response.Redirect(Request.RawUrl)
    End Sub

    Protected Sub GridView1_PageIndexChanged(sender As Object, e As EventArgs) Handles GridView1.PageIndexChanged
        CallFilter()
    End Sub

    Private Sub CallFilter()
        ' Hook for custom programmatic filter logic if needed
    End Sub

    Protected Sub GridView1_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles GridView1.SelectedIndexChanged
        FormView1.ChangeMode(DetailsViewMode.Edit)
        TabContainer1.Visible = True
        idListing.Visible = False

        Dim PermohonanID As Integer = CInt(GridView1.SelectedDataKey.Values(0))
        Dim ApprStatusID As Integer = CInt(GridView1.SelectedDataKey.Values(1))
        Dim IsFail As Boolean = CBool(GridView1.SelectedDataKey.Values(3))
        Dim IsPublish As Boolean = CBool(GridView1.SelectedDataKey.Values(4))

        PopulateMaklumatPermohonanModal(PermohonanID)

        If getJabatanLesen(CInt(Session.Item("sessionEstateID"))) = False OrElse ApprStatusID < 9 Then
            tabSurat.Visible = False
            tabLampiran.Visible = False
        Else
            tabSurat.Visible = True
            GetSuratContent(PermohonanID)
            GetLampiran(PermohonanID)

            If IsFail Then
                CB_SuratFail.Checked = True
                pnlSuratAuto.Visible = False
                pnlSuratFail.Visible = True
            Else
                CB_SuratFail.Checked = False
                pnlSuratAuto.Visible = True
                pnlSuratFail.Visible = False
            End If

            GetSuratFail(PermohonanID)

            If IsPublish Then
                tabSurat.Visible = False
            End If
        End If
    End Sub

    Private Sub GridView1_DataBound(sender As Object, e As EventArgs) Handles GridView1.DataBound
        If isHaveButton Then
            GridView1.Columns(7).Visible = True
        Else
            GridView1.Columns(7).Visible = False
        End If
    End Sub

    Private Sub GridView1_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles GridView1.RowDataBound
        Try
            Select Case e.Row.RowType
                Case DataControlRowType.DataRow
                    Dim LinkButton3 = DirectCast(e.Row.FindControl("LinkButton3"), LinkButton)
                    Dim LinkButton5 = DirectCast(e.Row.FindControl("LinkButton5"), LinkButton)
                    Dim LinkButton6 = DirectCast(e.Row.FindControl("LinkButton6"), LinkButton)
                    Dim LinkButton7 = DirectCast(e.Row.FindControl("LinkButton7"), LinkButton)

                    If (LinkButton3 IsNot Nothing AndAlso LinkButton3.Visible) OrElse
                       (LinkButton5 IsNot Nothing AndAlso LinkButton5.Visible) OrElse
                       (LinkButton6 IsNot Nothing AndAlso LinkButton6.Visible) OrElse
                       (LinkButton7 IsNot Nothing AndAlso LinkButton7.Visible) Then
                        isHaveButton = True
                    End If
            End Select
        Catch ex As Exception
        End Try
    End Sub

    Private Sub GridView1_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles GridView1.RowCommand
        If e.CommandName = "Surat" Then
            Dim intRow As Integer = CInt(e.CommandArgument)
            Dim Permohonan_ID As String = CStr(Me.GridView1.DataKeys(intRow)("Permohonan_ID"))

            If GetIsSuratFail(CInt(Permohonan_ID)) Then
                ViewSuratKelulusanFail(Permohonan_ID)
            Else
                ViewSuratKelulusanAuto(Permohonan_ID, True)
            End If

        ElseIf e.CommandName = "Lampiran1" Then
            Dim intRow As Integer = CInt(e.CommandArgument)
            Dim Permohonan_ID As String = CStr(Me.GridView1.DataKeys(intRow)("Permohonan_ID"))
            ViewLampiran(Permohonan_ID, "L1")

        ElseIf e.CommandName = "Lampiran2" Then
            Dim intRow As Integer = CInt(e.CommandArgument)
            Dim Permohonan_ID As String = CStr(Me.GridView1.DataKeys(intRow)("Permohonan_ID"))
            ViewLampiran(Permohonan_ID, "L2")
        End If
    End Sub

    Protected Sub GridView1_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs) Handles GridView1.RowDeleting
        Dim title As String = GridView1.Rows(e.RowIndex).Cells(1).Text
        GlobalClass.auditTrail(idWindowTitle.InnerText, title, "Nyah Aktif")
    End Sub

    Private Sub GridView1_RowDeleted(sender As Object, e As GridViewDeletedEventArgs) Handles GridView1.RowDeleted
        ShowAlert("success", "", "Rekod berjaya dikemaskini")
    End Sub

    Protected Sub btnBack_Click(sender As Object, e As EventArgs)
        backToList()
    End Sub

    Private Sub backToList()
        idListing.Visible = True
        TabContainer1.Visible = False
        GridView1.SelectedIndex = -1
        GridView1.DataBind()
    End Sub

#End Region

#Region "FormView Events (Maklumat Permohonan)"

    Private Sub FormView1_DataBound(sender As Object, e As EventArgs) Handles FormView1.DataBound
        initPageName()
        Try
            If FormView1.DataKey IsNot Nothing AndAlso FormView1.DataKey("Permohonan_ID") IsNot Nothing Then
                Dim pid As Integer = 0
                If Integer.TryParse(FormView1.DataKey("Permohonan_ID").ToString(), pid) AndAlso pid > 0 Then
                    PopulateMaklumatPermohonanModal(pid)
                End If
            End If
        Catch ex As Exception
        End Try
    End Sub

#Region "Modal Maklumat Permohonan Details"

    Private Sub PopulateMaklumatPermohonanModal(PermohonanID As Integer)
        If PermohonanID <= 0 Then Exit Sub

        Try
            Using con As New SqlConnection(CS)
                Dim sql As String = "SELECT g.*, f.Pemohon_Name, f.Pemohon_ICNo, f.Pemohon_PassportNo, f.Pemohon_Address, f.Pemohon_Nationality, f.Pemohon_Remarks, " &
                                    "f.Pemohon_MobileNo, f.Pemohon_TelNo, f.Pemohon_Email, " &
                                    "lkNat.name AS Pemohon_NationalityDesc, " &
                                    "lkPasar.name AS JenisPasarDesc, " &
                                    "lkPenjaja.name AS JenisPenjajaDesc, " &
                                    "lkTanah.name AS StatusTanahPenjajaDesc, " &
                                    "lkKenderaan.name AS JenisKenderaanPenjajaDesc, " &
                                    "lkAnjingPremis.name AS AnjingJenisPremisDesc, " &
                                    "lkBatal1.name AS SebabBatalPermDesc, " &
                                    "lkBatal2.name AS SebabBatalTanpaPermDesc, " &
                                    "lkTindakan.name AS TindakanBatalDesc " &
                                    "FROM LESEN_Permohonan g " &
                                    "LEFT JOIN LESEN_Pemohon f ON f.Pemohon_ID = g.Permohonan_PemohonID " &
                                    "LEFT JOIN TBL_LOOKUPS lkNat ON lkNat.id = f.Pemohon_Nationality AND lkNat.lookupgrp_id = 28 " &
                                    "LEFT JOIN TBL_LOOKUPS lkPasar ON lkPasar.id = g.JenisPasar AND lkPasar.lookupgrp_id = 10001 " &
                                    "LEFT JOIN TBL_LOOKUPS lkPenjaja ON lkPenjaja.id = g.JenisPenjaja AND lkPenjaja.lookupgrp_id = 10006 " &
                                    "LEFT JOIN TBL_LOOKUPS lkTanah ON lkTanah.id = g.StatusTanahPenjaja AND lkTanah.lookupgrp_id = 10007 " &
                                    "LEFT JOIN TBL_LOOKUPS lkKenderaan ON lkKenderaan.id = g.JenisKenderaanPenjaja AND lkKenderaan.lookupgrp_id = 10008 " &
                                    "LEFT JOIN TBL_LOOKUPS lkAnjingPremis ON lkAnjingPremis.id = g.AnjingJenisPremis AND lkAnjingPremis.lookupgrp_id = 10001 " &
                                    "LEFT JOIN TBL_LOOKUPS lkBatal1 ON lkBatal1.id = g.SebabBatalPerm AND lkBatal1.lookupgrp_id = 10002 " &
                                    "LEFT JOIN TBL_LOOKUPS lkBatal2 ON lkBatal2.id = g.SebabBatalTanpaPerm AND lkBatal2.lookupgrp_id = 10003 " &
                                    "LEFT JOIN TBL_LOOKUPS lkTindakan ON lkTindakan.id = g.TindakanBatal AND lkTindakan.lookupgrp_id = 10005 " &
                                    "WHERE g.Permohonan_ID = @Permohonan_ID"

                Using cmd As New SqlCommand(sql, con)
                    cmd.Parameters.AddWithValue("@Permohonan_ID", PermohonanID)
                    con.Open()
                    Using dr As SqlDataReader = cmd.ExecuteReader()
                        If dr.Read() Then
                            ' Header / Title
                            lblModalNoRujukan.Text = If(dr("Rujukan") Is DBNull.Value, "-", dr("Rujukan").ToString())

                            ' 1. Maklumat Pemohon
                            lblModalPemohonID.Text = If(dr("Permohonan_PemohonID") Is DBNull.Value, "-", dr("Permohonan_PemohonID").ToString())
                            lblModalPemohonName.Text = If(dr("Pemohon_Name") Is DBNull.Value, "-", dr("Pemohon_Name").ToString())

                            Dim icNo As String = If(dr("Pemohon_ICNo") IsNot DBNull.Value, dr("Pemohon_ICNo").ToString(), "")
                            Dim passNo As String = If(dr("Pemohon_PassportNo") IsNot DBNull.Value, dr("Pemohon_PassportNo").ToString(), "")
                            lblModalPemohonIC.Text = If(Not String.IsNullOrEmpty(icNo), icNo, If(Not String.IsNullOrEmpty(passNo), passNo, "-"))

                            lblModalPemohonNat.Text = If(dr("Pemohon_NationalityDesc") IsNot DBNull.Value, dr("Pemohon_NationalityDesc").ToString(), If(dr("Pemohon_Nationality") IsNot DBNull.Value, dr("Pemohon_Nationality").ToString(), "-"))

                            lblModalPemohonAddress.Text = If(dr("Pemohon_Address") IsNot DBNull.Value AndAlso Not String.IsNullOrWhiteSpace(dr("Pemohon_Address").ToString()), dr("Pemohon_Address").ToString(), "-")

                            Dim mob As String = If(dr("Pemohon_MobileNo") IsNot DBNull.Value, dr("Pemohon_MobileNo").ToString().Trim(), "")
                            Dim tel As String = If(dr("Pemohon_TelNo") IsNot DBNull.Value, dr("Pemohon_TelNo").ToString().Trim(), "")
                            If Not String.IsNullOrEmpty(mob) AndAlso Not String.IsNullOrEmpty(tel) Then
                                lblModalPemohonMobile.Text = mob & " / " & tel
                            ElseIf Not String.IsNullOrEmpty(mob) Then
                                lblModalPemohonMobile.Text = mob
                            ElseIf Not String.IsNullOrEmpty(tel) Then
                                lblModalPemohonMobile.Text = tel
                            Else
                                lblModalPemohonMobile.Text = "-"
                            End If

                            lblModalPemohonEmail.Text = If(dr("Pemohon_Email") IsNot DBNull.Value AndAlso Not String.IsNullOrWhiteSpace(dr("Pemohon_Email").ToString()), dr("Pemohon_Email").ToString().Trim(), "-")

                            lblModalPemohonRemarks.Text = If(dr("Pemohon_Remarks") Is DBNull.Value, "-", dr("Pemohon_Remarks").ToString())

                            ' 2. Maklumat Permohonan
                            lblModalTarikhMohon.Text = If(dr("TarikhMohon") Is DBNull.Value, "-", Convert.ToDateTime(dr("TarikhMohon")).ToString("dd/MM/yyyy"))
                            lblModalRujukanField.Text = If(dr("Rujukan") Is DBNull.Value, "-", dr("Rujukan").ToString())
                            lblModalNoAkaunCukai.Text = If(dr("NoAkaunCukai") Is DBNull.Value, "-", dr("NoAkaunCukai").ToString())

                            ' Jenis Lesen badges
                            Dim jenisLesenDesc As String = If(dr("JenisLesenDescList") Is DBNull.Value, "", dr("JenisLesenDescList").ToString())
                            Dim jenisLesenId As String = If(dr("JenisLesenIdList") Is DBNull.Value, "", dr("JenisLesenIdList").ToString())
                            litModalJenisLesenBadges.Text = ""
                            If Not String.IsNullOrEmpty(jenisLesenDesc) Then
                                Dim descArr() As String = jenisLesenDesc.Split(","c)
                                For Each desc In descArr
                                    If Not String.IsNullOrWhiteSpace(desc) Then
                                        litModalJenisLesenBadges.Text &= "<span class='tag-pill me-1 mb-1'><i class='bi bi-check2-circle me-1 text-primary'></i>" & Server.HtmlEncode(desc.Trim()) & "</span>"
                                    End If
                                Next
                            End If

                            ' Collect license IDs
                            Dim idList As New List(Of Integer)()
                            If Not String.IsNullOrEmpty(jenisLesenId) Then
                                For Each sid In jenisLesenId.Split(","c)
                                    Dim parsedId As Integer
                                    If Integer.TryParse(sid.Trim(), parsedId) Then
                                        idList.Add(parsedId)
                                    End If
                                Next
                            End If

                            ' 3. Perniagaan / Premis Panel
                            Dim showPerniagaan As Boolean = idList.Any(Function(x) {1, 5, 6, 7, 8, 9, 28, 30}.Contains(x)) OrElse
                                                            (dr("NamaSyarikat") IsNot DBNull.Value AndAlso Not String.IsNullOrWhiteSpace(dr("NamaSyarikat").ToString())) OrElse
                                                            (dr("AlamatPremis") IsNot DBNull.Value AndAlso Not String.IsNullOrWhiteSpace(dr("AlamatPremis").ToString())) OrElse
                                                            (dr("JenisPerniagaan") IsNot DBNull.Value AndAlso Not String.IsNullOrWhiteSpace(dr("JenisPerniagaan").ToString())) OrElse
                                                            (dr("NoPendaftaran") IsNot DBNull.Value AndAlso Not String.IsNullOrWhiteSpace(dr("NoPendaftaran").ToString()))
                            pnlModalPerniagaan.Visible = showPerniagaan
                            If showPerniagaan Then
                                lblModalNamaSyarikat.Text = If(dr("NamaSyarikat") Is DBNull.Value, "-", dr("NamaSyarikat").ToString())
                                lblModalNoPendaftaran.Text = If(dr("NoPendaftaran") Is DBNull.Value, "-", dr("NoPendaftaran").ToString())
                                lblModalNoAkaun.Text = If(dr("NoAkaun") Is DBNull.Value, "-", dr("NoAkaun").ToString())
                                lblModalAlamatPremis.Text = If(dr("AlamatPremis") Is DBNull.Value, "-", dr("AlamatPremis").ToString())
                                lblModalJenisPerniagaan.Text = If(dr("JenisPerniagaan") Is DBNull.Value, "-", dr("JenisPerniagaan").ToString())

                                ' Tukar Pemilik
                                Dim showPemilikBaru As Boolean = idList.Contains(5) OrElse (dr("PemilikBaru") IsNot DBNull.Value AndAlso Not String.IsNullOrWhiteSpace(dr("PemilikBaru").ToString()))
                                pnlModalTukarPemilik.Visible = showPemilikBaru
                                lblModalPemilikBaru.Text = If(dr("PemilikBaru") Is DBNull.Value, "-", dr("PemilikBaru").ToString())

                                ' Tukar Alamat / Premis Tambahan
                                Dim showAlamatBaru As Boolean = idList.Any(Function(x) {6, 7, 28}.Contains(x)) OrElse (dr("AlamatBaru") IsNot DBNull.Value AndAlso Not String.IsNullOrWhiteSpace(dr("AlamatBaru").ToString()))
                                pnlModalTukarAlamat.Visible = showAlamatBaru
                                lblModalAlamatBaru.Text = If(dr("AlamatBaru") Is DBNull.Value, "-", dr("AlamatBaru").ToString())

                                ' Tambah Jenis Perniagaan
                                Dim showJenisPerniagaanBaru As Boolean = idList.Contains(8) OrElse (dr("JenisPerniagaanBaru") IsNot DBNull.Value AndAlso Not String.IsNullOrWhiteSpace(dr("JenisPerniagaanBaru").ToString()))
                                pnlModalTambahPerniagaan.Visible = showJenisPerniagaanBaru
                                lblModalJenisPerniagaanBaru.Text = If(dr("JenisPerniagaanBaru") Is DBNull.Value, "-", dr("JenisPerniagaanBaru").ToString())

                                ' Tukar Nama Syarikat
                                Dim showNamaBaruSyarikat As Boolean = idList.Contains(9) OrElse (dr("NamaBaruSyarikat") IsNot DBNull.Value AndAlso Not String.IsNullOrWhiteSpace(dr("NamaBaruSyarikat").ToString()))
                                pnlModalTukarNama.Visible = showNamaBaruSyarikat
                                lblModalNamaBaruSyarikat.Text = If(dr("NamaBaruSyarikat") Is DBNull.Value, "-", dr("NamaBaruSyarikat").ToString())
                            End If

                            ' 4. Papan Iklan
                            Dim saizIklanStr As String = If(dr("SaizIklanList") Is DBNull.Value, "", dr("SaizIklanList").ToString())
                            Dim cahayaIklanStr As String = If(dr("CahayaIklanList") Is DBNull.Value, "", dr("CahayaIklanList").ToString())
                            Dim unitIklanStr As String = If(dr("UnitIklanList") Is DBNull.Value, "", dr("UnitIklanList").ToString())

                            If Not String.IsNullOrWhiteSpace(saizIklanStr) Then
                                Dim saizArr() As String = saizIklanStr.Split(","c)
                                Dim cahayaArr() As String = cahayaIklanStr.Split(","c)
                                Dim unitArr() As String = unitIklanStr.Split(","c)

                                Dim dtIklan As New DataTable()
                                dtIklan.Columns.Add("SaizIklan", GetType(String))
                                dtIklan.Columns.Add("Bercahaya", GetType(String))
                                dtIklan.Columns.Add("Unit", GetType(String))

                                For i As Integer = 0 To saizArr.Length - 1
                                    If Not String.IsNullOrWhiteSpace(saizArr(i)) Then
                                        Dim row = dtIklan.NewRow()
                                        row("SaizIklan") = saizArr(i).Trim()
                                        row("Bercahaya") = If(i < cahayaArr.Length, cahayaArr(i).Trim(), "-")
                                        row("Unit") = If(i < unitArr.Length, unitArr(i).Trim(), "-")
                                        dtIklan.Rows.Add(row)
                                    End If
                                Next

                                gvModalIklan.DataSource = dtIklan
                                gvModalIklan.DataBind()
                                pnlModalIklan.Visible = (dtIklan.Rows.Count > 0)
                            Else
                                pnlModalIklan.Visible = False
                            End If

                            ' 5. Billboard
                            Dim bLokasi As String = If(dr("BillboardLokasi") IsNot DBNull.Value, dr("BillboardLokasi").ToString().Trim(), "")
                            Dim bList As String = If(dr("LokasiList") IsNot DBNull.Value, dr("LokasiList").ToString().Trim(), "")
                            Dim showBillboard As Boolean = idList.Contains(26) OrElse Not String.IsNullOrEmpty(bLokasi) OrElse Not String.IsNullOrEmpty(bList)
                            pnlModalBillboard.Visible = showBillboard
                            If showBillboard Then
                                Dim allLoc As String = bLokasi
                                If Not String.IsNullOrEmpty(bList) AndAlso Not allLoc.Contains(bList) Then
                                    If Not String.IsNullOrEmpty(allLoc) Then allLoc &= " | "
                                    allLoc &= bList
                                End If
                                lblModalBillboardLokasi.Text = If(String.IsNullOrEmpty(allLoc), "-", allLoc)
                            End If

                            ' 6. Pasar
                            Dim showPasar As Boolean = idList.Any(Function(x) {2, 25}.Contains(x)) OrElse (dr("LokasiPasar1") IsNot DBNull.Value AndAlso Not String.IsNullOrWhiteSpace(dr("LokasiPasar1").ToString()))
                            pnlModalPasar.Visible = showPasar
                            If showPasar Then
                                lblModalLokasiPasar1.Text = If(dr("LokasiPasar1") Is DBNull.Value, "-", dr("LokasiPasar1").ToString())
                                lblModalLokasiPasar2.Text = If(dr("LokasiPasar2") Is DBNull.Value, "-", dr("LokasiPasar2").ToString())
                                lblModalLokasiPasar3.Text = If(dr("LokasiPasar3") Is DBNull.Value, "-", dr("LokasiPasar3").ToString())
                                lblModalJenisPasar.Text = If(dr("JenisPasarDesc") IsNot DBNull.Value, dr("JenisPasarDesc").ToString(), If(dr("JenisPasar") IsNot DBNull.Value, dr("JenisPasar").ToString(), "-"))
                                lblModalJenisPerniagaanPasar.Text = If(dr("JenisPerniagaanPasar") Is DBNull.Value, "-", dr("JenisPerniagaanPasar").ToString())
                                lblModalJumlahPetak.Text = If(dr("JumlahPetak") Is DBNull.Value, "-", dr("JumlahPetak").ToString())
                            End If

                            ' 7. Lesen Anjing
                            Dim bakaStr As String = If(dr("BakaAnjingList") Is DBNull.Value, "", dr("BakaAnjingList").ToString())
                            Dim showAnjing As Boolean = idList.Contains(3) OrElse Not String.IsNullOrWhiteSpace(bakaStr) OrElse (dr("AnjingAlamat") IsNot DBNull.Value AndAlso Not String.IsNullOrWhiteSpace(dr("AnjingAlamat").ToString()))
                            pnlModalAnjing.Visible = showAnjing
                            If showAnjing Then
                                lblModalAnjingAlamat.Text = If(dr("AnjingAlamat") Is DBNull.Value, "-", dr("AnjingAlamat").ToString())
                                lblModalAnjingJenisPremis.Text = If(dr("AnjingJenisPremisDesc") IsNot DBNull.Value, dr("AnjingJenisPremisDesc").ToString(), If(dr("AnjingJenisPremis") IsNot DBNull.Value, dr("AnjingJenisPremis").ToString(), "-"))

                                If Not String.IsNullOrWhiteSpace(bakaStr) Then
                                    Dim bakaArr() As String = bakaStr.Split(","c)
                                    Dim jantanArr() As String = If(dr("AnjingJantanList") Is DBNull.Value, "", dr("AnjingJantanList").ToString()).Split(","c)
                                    Dim betinaArr() As String = If(dr("AnjingBetinaList") Is DBNull.Value, "", dr("AnjingBetinaList").ToString()).Split(","c)
                                    Dim jmArr() As String = If(dr("AnjingJantanMandulList") Is DBNull.Value, "", dr("AnjingJantanMandulList").ToString()).Split(","c)
                                    Dim bmArr() As String = If(dr("AnjingBetinaMandulList") Is DBNull.Value, "", dr("AnjingBetinaMandulList").ToString()).Split(","c)

                                    Dim dtAnjing As New DataTable()
                                    dtAnjing.Columns.Add("Baka", GetType(String))
                                    dtAnjing.Columns.Add("Jantan", GetType(String))
                                    dtAnjing.Columns.Add("Betina", GetType(String))
                                    dtAnjing.Columns.Add("JantanMandul", GetType(String))
                                    dtAnjing.Columns.Add("BetinaMandul", GetType(String))

                                    For i As Integer = 0 To bakaArr.Length - 1
                                        If Not String.IsNullOrWhiteSpace(bakaArr(i)) Then
                                            Dim row = dtAnjing.NewRow()
                                            row("Baka") = bakaArr(i).Trim()
                                            row("Jantan") = If(i < jantanArr.Length, jantanArr(i).Trim(), "0")
                                            row("Betina") = If(i < betinaArr.Length, betinaArr(i).Trim(), "0")
                                            row("JantanMandul") = If(i < jmArr.Length, jmArr(i).Trim(), "0")
                                            row("BetinaMandul") = If(i < bmArr.Length, bmArr(i).Trim(), "0")
                                            dtAnjing.Rows.Add(row)
                                        End If
                                    Next

                                    gvModalAnjing.DataSource = dtAnjing
                                    gvModalAnjing.DataBind()
                                End If
                            End If

                            ' 8. Penjaja
                            Dim showPenjaja As Boolean = idList.Contains(4) OrElse (dr("AlamatPenjajaan") IsNot DBNull.Value AndAlso Not String.IsNullOrWhiteSpace(dr("AlamatPenjajaan").ToString()))
                            pnlModalPenjaja.Visible = showPenjaja
                            If showPenjaja Then
                                lblModalJenisPenjaja.Text = If(dr("JenisPenjajaDesc") IsNot DBNull.Value, dr("JenisPenjajaDesc").ToString(), "-")
                                lblModalStatusTanahPenjaja.Text = If(dr("StatusTanahPenjajaDesc") IsNot DBNull.Value, dr("StatusTanahPenjajaDesc").ToString(), "-")
                                lblModalJenisPerniagaanPenjaja.Text = If(dr("JenisPerniagaanPenjaja") Is DBNull.Value, "-", dr("JenisPerniagaanPenjaja").ToString())
                                lblModalAlamatPenjajaan.Text = If(dr("AlamatPenjajaan") Is DBNull.Value, "-", dr("AlamatPenjajaan").ToString())

                                Dim masa1 As String = If(dr("MasaPenjaja1") Is DBNull.Value, "", dr("MasaPenjaja1").ToString())
                                Dim masa2 As String = If(dr("MasaPenjaja2") Is DBNull.Value, "", dr("MasaPenjaja2").ToString())
                                lblModalMasaPenjaja.Text = If(String.IsNullOrEmpty(masa1) And String.IsNullOrEmpty(masa2), "-", masa1 & " hingga " & masa2)

                                Dim kenderaanDesc As String = If(dr("JenisKenderaanPenjajaDesc") IsNot DBNull.Value, dr("JenisKenderaanPenjajaDesc").ToString(), "")
                                Dim noKenderaan As String = If(dr("NoKenderaanPenjaja") IsNot DBNull.Value, dr("NoKenderaanPenjaja").ToString(), "")
                                lblModalKenderaanPenjaja.Text = If(String.IsNullOrEmpty(kenderaanDesc) And String.IsNullOrEmpty(noKenderaan), "-", kenderaanDesc & If(Not String.IsNullOrEmpty(noKenderaan), " (" & noKenderaan & ")", ""))
                            End If

                            ' 9. Ekspo / Program
                            Dim showEkspo As Boolean = idList.Any(Function(x) (x >= 10 AndAlso x <= 24)) OrElse (dr("NamaEkspo") IsNot DBNull.Value AndAlso Not String.IsNullOrWhiteSpace(dr("NamaEkspo").ToString()))
                            pnlModalEkspo.Visible = showEkspo
                            If showEkspo Then
                                lblModalPenganjurEkspo.Text = If(dr("PenganjurEkspo") Is DBNull.Value, "-", dr("PenganjurEkspo").ToString())
                                lblModalAlamatPenganjurEkspo.Text = If(dr("AlamatPenganjurEkspo") Is DBNull.Value, "-", dr("AlamatPenganjurEkspo").ToString())
                                lblModalPicEkspo.Text = If(dr("PicEkspo") Is DBNull.Value, "-", dr("PicEkspo").ToString())
                                lblModalNoTelEkspo.Text = If(dr("NoTelEkspo") Is DBNull.Value, "-", dr("NoTelEkspo").ToString())
                                lblModalNamaEkspo.Text = If(dr("NamaEkspo") Is DBNull.Value, "-", dr("NamaEkspo").ToString())
                                lblModalLokasiEkspo.Text = If(dr("LokasiEkspo") Is DBNull.Value, "-", dr("LokasiEkspo").ToString())

                                Dim tekspo1 As String = If(dr("TarikhEkspo1") Is DBNull.Value, "", Convert.ToDateTime(dr("TarikhEkspo1")).ToString("dd/MM/yyyy"))
                                Dim tekspo2 As String = If(dr("TarikhEkspo2") Is DBNull.Value, "", Convert.ToDateTime(dr("TarikhEkspo2")).ToString("dd/MM/yyyy"))
                                lblModalTarikhEkspo.Text = If(String.IsNullOrEmpty(tekspo1) And String.IsNullOrEmpty(tekspo2), "-", tekspo1 & " hingga " & tekspo2)

                                Dim mekspo1 As String = If(dr("MasaEkspo1") Is DBNull.Value, "", dr("MasaEkspo1").ToString())
                                Dim mekspo2 As String = If(dr("MasaEkspo2") Is DBNull.Value, "", dr("MasaEkspo2").ToString())
                                lblModalMasaEkspo.Text = If(String.IsNullOrEmpty(mekspo1) And String.IsNullOrEmpty(mekspo2), "-", mekspo1 & " hingga " & mekspo2)

                                lblModalTentatifEkspo.Text = If(dr("TentatifEkspo") Is DBNull.Value, "-", dr("TentatifEkspo").ToString())
                                lblModalJemputanEkspo.Text = If(dr("JemputanEkspo") Is DBNull.Value, "-", dr("JemputanEkspo").ToString())
                                lblModalPembersihanEkspo.Text = If(dr("PembersihanEkspo") Is DBNull.Value, "-", dr("PembersihanEkspo").ToString())

                                Dim tkhemah1 As String = If(dr("TarikhKhemahEkspo1") Is DBNull.Value, "", Convert.ToDateTime(dr("TarikhKhemahEkspo1")).ToString("dd/MM/yyyy"))
                                Dim tkhemah2 As String = If(dr("TarikhKhemahEkspo2") Is DBNull.Value, "", Convert.ToDateTime(dr("TarikhKhemahEkspo2")).ToString("dd/MM/yyyy"))
                                lblModalTarikhKhemah.Text = If(String.IsNullOrEmpty(tkhemah1) And String.IsNullOrEmpty(tkhemah2), "-", tkhemah1 & " hingga " & tkhemah2)
                            End If



                            ' 12. Pembatalan
                            Dim isBatalVal As Boolean = (dr("IsBatal") IsNot DBNull.Value AndAlso Convert.ToBoolean(dr("IsBatal")))
                            pnlModalBatal.Visible = isBatalVal
                            If isBatalVal Then
                                Dim jbatal As String = If(dr("JenisBatal") Is DBNull.Value, "", dr("JenisBatal").ToString())
                                lblModalJenisBatal.Text = If(jbatal = "1", "Dengan Permohonan", If(jbatal = "2", "Tanpa Permohonan", "-"))

                                Dim sebabDesc As String = If(dr("SebabBatalPermDesc") IsNot DBNull.Value, dr("SebabBatalPermDesc").ToString(),
                                                            If(dr("SebabBatalTanpaPermDesc") IsNot DBNull.Value, dr("SebabBatalTanpaPermDesc").ToString(), "-"))
                                lblModalSebabBatal.Text = sebabDesc
                                lblModalRemarksBatal.Text = If(dr("RemarksBatal") Is DBNull.Value, "-", dr("RemarksBatal").ToString())
                                lblModalTindakanBatal.Text = If(dr("TindakanBatalDesc") IsNot DBNull.Value, dr("TindakanBatalDesc").ToString(), If(dr("TindakanBatal") IsNot DBNull.Value, dr("TindakanBatal").ToString(), "-"))
                                lblModalTarikhBatal.Text = If(dr("TarikhBatal") Is DBNull.Value, "-", Convert.ToDateTime(dr("TarikhBatal")).ToString("dd/MM/yyyy"))
                            End If
                        End If
                    End Using
                End Using
            End Using
        Catch ex As Exception
            System.Diagnostics.Trace.WriteLine("Error in PopulateMaklumatPermohonanModal: " & ex.Message)
        End Try
    End Sub

#End Region

    Protected Sub FormView1_ItemInserting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertEventArgs) Handles FormView1.ItemInserting
        Dim titleTxt As TextBox = DirectCast(FormView1.FindControl("txtJenisLesen_Description"), TextBox)
        Dim title As String = If(titleTxt IsNot Nothing, titleTxt.Text, "")
        GlobalClass.auditTrail(idWindowTitle.InnerText, title, "Maklumat")
    End Sub

    Protected Sub FormView1_ItemInserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertedEventArgs) Handles FormView1.ItemInserted
        ShowAlert("success", "", "Rekod berjaya disimpan")
        GridView1.DataBind()
    End Sub

    Protected Sub FormView1_ItemUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdateEventArgs) Handles FormView1.ItemUpdating
        Dim titleTxt As TextBox = DirectCast(FormView1.FindControl("txtJenisLesen_Description"), TextBox)
        Dim title As String = If(titleTxt IsNot Nothing, titleTxt.Text, "")
        GlobalClass.auditTrail(idWindowTitle.InnerText, title, "Kemaskini")
    End Sub

    Protected Sub FormView1_ItemUpdated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdatedEventArgs) Handles FormView1.ItemUpdated
        ShowAlert("success", "", "Rekod berjaya dikemaskini")
        GridView1.DataBind()
    End Sub

    Protected Sub CB_IsPublish_CheckedChanged(sender As Object, e As EventArgs)
        Dim PermohonanID As Integer = CInt(GridView1.SelectedDataKey.Values(0))
        Dim cb As CheckBox = DirectCast(FormView1.FindControl("CB_IsPublish"), CheckBox)

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "UPDATE LESEN_Permohonan SET IsPublish = @IsPublish, LastModDt = GETDATE() WHERE Permohonan_ID = @Permohonan_ID"
            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", PermohonanID)
            myCommandSelect.Parameters.AddWithValue("@IsPublish", cb.Checked.ToString())

            Try
                myCommandSelect.ExecuteNonQuery()
                gvTabBayaran.DataBind()

                If cb.Checked Then
                    tabSurat.Visible = False
                    ShowAlert("success", "", "Surat kelulusan diterbitkan.")
                Else
                    tabSurat.Visible = True
                    ShowAlert("error", "", "Surat kelulusan tidak diterbitkan.")
                End If
            Catch ex As Exception
                MessageBox("Error", Me)
            End Try
        End Using
    End Sub

#End Region

#Region "Tab 1: Surat Kelulusan (Auto & Fail)"

    Protected Sub CB_SuratFail_CheckedChanged(sender As Object, e As EventArgs)
        If CB_SuratFail.Checked Then
            pnlSuratFail.Visible = True
            pnlSuratAuto.Visible = False
        Else
            pnlSuratFail.Visible = False
            pnlSuratAuto.Visible = True
        End If
    End Sub

    Private Sub GetSuratContent(pid As Integer)
        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "SELECT SuratKelulusan1, SuratKelulusan2, SuratKelulusan3, SuratKelulusan4, TandatanganKelulusanId, TarikhSuratKelulusan FROM LESEN_Permohonan WHERE Permohonan_ID = @Permohonan_ID"
            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)
            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader()

            Try
                If myReader.Read() Then
                    If Not IsDBNull(myReader.Item("TarikhSuratKelulusan")) Then
                        TB_TarikhSurat.Text = CDate(myReader.Item("TarikhSuratKelulusan")).ToString("yyyy-MM-dd")
                    End If

                    If myReader.Item("TandatanganKelulusanId").ToString().Length > 0 Then
                        ddlTandatangan.SelectedValue = CInt(myReader.Item("TandatanganKelulusanId").ToString())
                    End If
                End If
            Catch ex As Exception
                MessageBox(ex.Message, Me)
            End Try
        End Using
    End Sub

    Protected Sub BT_Generate_Command(sender As Object, e As CommandEventArgs)
        Dim jidList() As String = CStr(GridView1.SelectedDataKey.Values("JenisLesenIdList")).Split(","c)
        Dim pid As Integer = CInt(GridView1.SelectedDataKey.Values("Permohonan_ID"))
        Dim sid As Integer = CInt(GridView1.SelectedDataKey.Values("ApprStatusID"))
        Dim namatemplatList() As String = CStr(DDL_SuratTemplat.SelectedValue).Split(","c)
        Dim namatemplat As String = namatemplatList(1)

        Dim jenisReport As String = "SKL"
        Dim rujukan As String = ""
        Dim tarikhmohon As String = ""
        Dim jenispasar As String = ""
        Dim jumlahpetak As String = ""
        Dim jenisperniagaanpasar As String = ""
        Dim lokasipasar As String = ""
        Dim namaekspo As String = ""
        Dim tarikhekspo1 As String = ""
        Dim tarikhekspo2 As String = ""
        Dim lokasiekspo As String = ""
        Dim totalamount As Double = 0

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()

            ' 1. Check total fee amount
            Dim SQL3 As String = "SELECT ISNULL(SUM(KadarBayaran_Amount), 0) AS TotalAmount FROM LESEN_KadarBayaran WHERE KadarBayaran_PermohonanID = @Permohonan_ID AND IsSelect = 1"
            Dim myCommandSelect3 As New SqlCommand(SQL3, myConnection)
            myCommandSelect3.Parameters.AddWithValue("@Permohonan_ID", pid)
            Dim myReader3 As SqlDataReader = myCommandSelect3.ExecuteReader()

            Try
                If myReader3.Read() Then
                    totalamount = CDbl(myReader3.Item("TotalAmount"))
                End If
            Catch ex As Exception
                MessageBox(ex.Message, Me)
            End Try
            myReader3.Close()

            If totalamount = 0 Then
                ShowAlert("error", "", "Sila semak semula dan pilih kadar bayaran yang berkenaan.")
                Exit Sub
            End If

            ' 2. Retrieve application details for keyword replacement
            Dim SQL4 As String = "SELECT Rujukan, CONVERT(varchar, TarikhMohon, 103) AS TarikhMohon, JenisPasar, JenisPerniagaanPasar, JumlahPetak, LokasiPasar1, LokasiPasar2, LokasiPasar3, " &
                                 "NamaEkspo, TarikhEkspo1, TarikhEkspo2, LokasiEkspo FROM LESEN_Permohonan WHERE Permohonan_ID = @Permohonan_ID"
            Dim myCommandSelect4 As New SqlCommand(SQL4, myConnection)
            myCommandSelect4.Parameters.AddWithValue("@Permohonan_ID", pid)
            Dim myReader4 As SqlDataReader = myCommandSelect4.ExecuteReader()

            Try
                If myReader4.Read() Then
                    rujukan = myReader4.Item("Rujukan").ToString()
                    tarikhmohon = myReader4.Item("TarikhMohon").ToString()
                    jenispasar = myReader4.Item("JenisPasar").ToString()
                    jenisperniagaanpasar = myReader4.Item("JenisPerniagaanPasar").ToString()
                    jumlahpetak = myReader4.Item("JumlahPetak").ToString()
                    lokasipasar = myReader4.Item("LokasiPasar1").ToString()

                    If myReader4.Item("LokasiPasar2").ToString().Length > 0 Then
                        lokasipasar &= ", " & myReader4.Item("LokasiPasar2").ToString()
                    End If

                    If myReader4.Item("LokasiPasar3").ToString().Length > 0 Then
                        lokasipasar &= ", " & myReader4.Item("LokasiPasar3").ToString()
                    End If

                    namaekspo = myReader4.Item("NamaEkspo").ToString()
                    tarikhekspo1 = myReader4.Item("TarikhEkspo1").ToString()
                    tarikhekspo2 = myReader4.Item("TarikhEkspo2").ToString()
                    lokasiekspo = myReader4.Item("LokasiEkspo").ToString()
                End If
            Catch ex As Exception
                MessageBox(ex.Message, Me)
            End Try
            myReader4.Close()

            ' 3. Insert generated report text
            Dim SQL As String = "DELETE FROM LESEN_PermohonanSurat WHERE Permohonan_ID=@Permohonan_ID AND JenisReport=@JenisReport; " &
                                "INSERT INTO LESEN_PermohonanSurat (Permohonan_ID, JenisReport, P1, P2, P3, IsiKandungan, CreatedDt, ModDt) " &
                                "SELECT @Permohonan_ID AS Permohonan_ID, JenisReport, P1, P2, P3, " &
                                "REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( " &
                                "CAST(IsiKandungan AS VARCHAR(MAX)), " &
                                "'{@TahunIni}', @@TahunIni), " &
                                "'{@JumlahKadarBayaran}', @@JumlahKadarBayaran), " &
                                "'{@Rujukan}', IIF(CHARINDEX(' ', @@Rujukan) > 0, @@Rujukan, REPLACE(@@Rujukan, 'MPK/599/401/', 'MPK/599/401/ '))), " &
                                "'{@TarikhMohon}', @@TarikhMohon), " &
                                "'{@JenisPasar}', @@JenisPasar), " &
                                "'{@JenisPerniagaanPasar}', @@JenisPerniagaanPasar), " &
                                "'{@JumlahPetak}', @@JumlahPetak), " &
                                "'{@LokasiPasar}', @@LokasiPasar), " &
                                "'{@NamaEkspo}', @@NamaEkspo), " &
                                "'{@TarikhEkspo1}', @@TarikhEkspo1), " &
                                "'{@TarikhEkspo2}', @@TarikhEkspo2), " &
                                "'{@LokasiEkspo}', @@LokasiEkspo) AS IsiKandungan, " &
                                "GETDATE() AS CreatedDt, GETDATE() AS ModDt " &
                                "FROM LESEN_ReportTemplate " &
                                "WHERE JenisLesen_ID=@JenisLesen_ID AND JenisReport=@JenisReport AND NamaTemplat=@NamaTemplat;"

            If sid = 9 Then
                jenisReport = "SKB"
            End If

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@JenisLesen_ID", jidList(0))
            myCommandSelect.Parameters.AddWithValue("@JenisReport", jenisReport)
            myCommandSelect.Parameters.AddWithValue("@NamaTemplat", namatemplat)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)

            myCommandSelect.Parameters.AddWithValue("@@TahunIni", DateTime.Now.Year.ToString())
            myCommandSelect.Parameters.AddWithValue("@@JumlahKadarBayaran", totalamount.ToString("N2"))
            myCommandSelect.Parameters.AddWithValue("@@Rujukan", rujukan)
            myCommandSelect.Parameters.AddWithValue("@@TarikhMohon", tarikhmohon)
            myCommandSelect.Parameters.AddWithValue("@@JenisPasar", jenispasar)
            myCommandSelect.Parameters.AddWithValue("@@JenisPerniagaanPasar", jenisperniagaanpasar)
            myCommandSelect.Parameters.AddWithValue("@@JumlahPetak", jumlahpetak)
            myCommandSelect.Parameters.AddWithValue("@@LokasiPasar", lokasipasar)
            myCommandSelect.Parameters.AddWithValue("@@NamaEkspo", namaekspo)
            myCommandSelect.Parameters.AddWithValue("@@TarikhEkspo1", tarikhekspo1)
            myCommandSelect.Parameters.AddWithValue("@@TarikhEkspo2", tarikhekspo2)
            myCommandSelect.Parameters.AddWithValue("@@LokasiEkspo", lokasiekspo)

            Try
                myCommandSelect.ExecuteNonQuery()
                ShowAlert("success", "", "Surat kelulusan berjaya dijana.")
                GridViewReport.DataBind()
            Catch ex As Exception
                MessageBox(ex.Message, Me)
            End Try
        End Using
    End Sub

    Protected Sub btnSaveLetter_Click(sender As Object, e As EventArgs)
        If CB_SuratFail.Checked AndAlso ((FU_Lampiran3.Visible AndAlso Not FU_Lampiran3.HasFile) OrElse
            (HL_Lampiran3.Visible AndAlso HL_Lampiran3.Text.Length < 1)) Then
            ShowAlert("error", "", "Sila pilih fail surat yang ingin dimuat naik.")
            Return
        End If

        Dim isSuccess As Boolean = True
        Dim PermohonanID As Integer = CInt(GridView1.SelectedDataKey.Values(0))

        If Not CB_SuratFail.Checked Then
            If TB_TarikhSurat.Text.Length = 0 Then
                ShowAlert("error", "", "Sila pilih tarikh surat.")
                Return
            End If

            Using myConnection As New SqlConnection(CS)
                myConnection.Open()
                Dim SQL As String = "UPDATE LESEN_Permohonan SET TandatanganKelulusanId = @TandatanganKelulusanId, TarikhSuratKelulusan = @TarikhSuratKelulusan WHERE Permohonan_ID = @Permohonan_ID"
                Dim myCommandSelect As New SqlCommand(SQL, myConnection)
                myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", PermohonanID)
                myCommandSelect.Parameters.AddWithValue("@TandatanganKelulusanId", ddlTandatangan.SelectedValue)
                myCommandSelect.Parameters.AddWithValue("@TarikhSuratKelulusan", TB_TarikhSurat.Text)

                Try
                    myCommandSelect.ExecuteNonQuery()
                Catch ex As Exception
                    isSuccess = False
                    MessageBox(ex.Message, Me)
                End Try
            End Using
        End If

        Dim uid As Guid = Guid.NewGuid()

        If FU_Lampiran3.HasFile Then
            Dim fn As String = System.IO.Path.GetFileName(FU_Lampiran3.PostedFile.FileName)
            Dim localPath As String = "~/doc/" & uid.ToString() & fn
            Dim SaveLocation As String = Server.MapPath(localPath)

            If FU_Lampiran3.PostedFile IsNot Nothing AndAlso FU_Lampiran3.PostedFile.ContentLength > 0 Then
                If updateUploadFile(FU_Lampiran3, SaveLocation) Then
                    Using myConnection As New SqlConnection(CS)
                        myConnection.Open()
                        Dim SQL As String = "INSERT INTO LESEN_PermohonanFail (PermohonanFail_PermohonanID, PermohonanFail_ContentType, PermohonanFail_FileName, PermohonanFail_FilePath, PermohonanFail_JenisLampiran) " &
                                            "VALUES (@Permohonan_ID, @ContentType, @FileName, @FilePath, 'SK')"
                        Dim myCommandSelect As New SqlCommand(SQL, myConnection)
                        myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", PermohonanID)
                        myCommandSelect.Parameters.AddWithValue("@FileName", FU_Lampiran3.PostedFile.FileName)
                        myCommandSelect.Parameters.AddWithValue("@ContentType", FU_Lampiran3.PostedFile.ContentType)
                        myCommandSelect.Parameters.AddWithValue("@FilePath", localPath)

                        Try
                            myCommandSelect.ExecuteNonQuery()
                            GetSuratFail(PermohonanID)
                        Catch ex As Exception
                            isSuccess = False
                            MessageBox("ERROR", Me)
                        End Try
                    End Using
                End If
            End If
        End If

        If isSuccess Then
            ShowAlert("success", "", "Surat kelulusan telah dikemaskini.")
        End If
    End Sub

    Private Sub GetSuratFail(pid As Integer)
        BT_Cancel3.Visible = False
        HL_Lampiran3.Visible = False
        BT_Update3.Visible = False
        BT_Delete3.Visible = False

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "SELECT PermohonanFail_FileName, PermohonanFail_FilePath, PermohonanFail_JenisLampiran FROM LESEN_PermohonanFail WHERE PermohonanFail_JenisLampiran = 'SK' AND PermohonanFail_PermohonanID = @Permohonan_ID"
            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)
            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader()

            Try
                If myReader.Read() Then
                    HL_Lampiran3.Text = myReader.Item("PermohonanFail_FileName").ToString()
                    HL_Lampiran3.NavigateUrl = myReader.Item("PermohonanFail_FilePath").ToString()

                    FU_Lampiran3.Visible = False
                    BT_Cancel3.Visible = False
                    HL_Lampiran3.Visible = True
                    BT_Update3.Visible = True
                    BT_Delete3.Visible = True
                End If
            Catch ex As Exception
                MessageBox("ERROR", Me)
            End Try
        End Using
    End Sub

    Protected Sub BT_Update3_Click(sender As Object, e As EventArgs)
        FU_Lampiran3.Visible = True
        BT_Cancel3.Visible = True
        HL_Lampiran3.Visible = False
        BT_Update3.Visible = False
        BT_Delete3.Visible = False
    End Sub

    Protected Sub BT_Cancel3_Click(sender As Object, e As EventArgs)
        FU_Lampiran3.Visible = False
        BT_Cancel3.Visible = False
        HL_Lampiran3.Visible = True
        BT_Update3.Visible = True
        BT_Delete3.Visible = True
    End Sub

    Protected Sub BT_Delete3_Click(sender As Object, e As EventArgs)
        DeleteLampiran("SK")
    End Sub

    Protected Sub GridViewReport_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles GridViewReport.SelectedIndexChanged
        FormViewReport.ChangeMode(DetailsViewMode.Edit)
    End Sub

    Private Sub FormViewReport_ItemInserted(sender As Object, e As FormViewInsertedEventArgs) Handles FormViewReport.ItemInserted
        GridViewReport.DataBind()
    End Sub

    Private Sub FormViewReport_ItemUpdated(sender As Object, e As FormViewUpdatedEventArgs) Handles FormViewReport.ItemUpdated
        ShowAlert("success", "", "Rekod berjaya dikemaskini")
        GridViewReport.DataBind()
    End Sub

    Private Sub GridViewReport_RowDeleted(sender As Object, e As GridViewDeletedEventArgs) Handles GridViewReport.RowDeleted
        ShowAlert("success", "", "Rekod berjaya dikemaskini")
        GridViewReport.DataBind()
    End Sub

#End Region

#Region "Tab 2: Lampiran (Syarat & Bil)"

    Protected Sub BT_Lampiran1_Click(sender As Object, e As EventArgs)
        DeleteLampiran("L1")
        Dim uid As Guid = Guid.NewGuid()

        If FU_Lampiran1.HasFile Then
            Dim fn As String = System.IO.Path.GetFileName(FU_Lampiran1.PostedFile.FileName)
            Dim localPath As String = "~/doc/" & uid.ToString() & fn
            Dim SaveLocation As String = Server.MapPath(localPath)

            If FU_Lampiran1.PostedFile IsNot Nothing AndAlso FU_Lampiran1.PostedFile.ContentLength > 0 Then
                If updateUploadFile(FU_Lampiran1, SaveLocation) Then
                    Dim PermohonanID As Integer = CInt(GridView1.SelectedDataKey.Values(0))

                    Using myConnection As New SqlConnection(CS)
                        myConnection.Open()
                        Dim SQL As String = "INSERT INTO LESEN_PermohonanFail (PermohonanFail_PermohonanID, PermohonanFail_ContentType, PermohonanFail_FileName, PermohonanFail_FilePath, PermohonanFail_JenisLampiran) " &
                                            "VALUES (@Permohonan_ID, @ContentType, @FileName, @FilePath, 'L1')"
                        Dim myCommandSelect As New SqlCommand(SQL, myConnection)
                        myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", PermohonanID)
                        myCommandSelect.Parameters.AddWithValue("@FileName", FU_Lampiran1.PostedFile.FileName)
                        myCommandSelect.Parameters.AddWithValue("@ContentType", FU_Lampiran1.PostedFile.ContentType)
                        myCommandSelect.Parameters.AddWithValue("@FilePath", localPath)

                        Try
                            myCommandSelect.ExecuteNonQuery()
                            GetLampiran(PermohonanID)
                        Catch ex As Exception
                            MessageBox("Error inserting to database", Me)
                        End Try
                    End Using
                End If
            End If
        End If
    End Sub

    Protected Sub BT_Lampiran2_Click(sender As Object, e As EventArgs)
        DeleteLampiran("L2")
        Dim uid As Guid = Guid.NewGuid()

        If FU_Lampiran2.HasFile Then
            Dim fn As String = System.IO.Path.GetFileName(FU_Lampiran2.PostedFile.FileName)
            Dim localPath As String = "~/doc/" & uid.ToString() & fn
            Dim SaveLocation As String = Server.MapPath(localPath)

            If FU_Lampiran2.PostedFile IsNot Nothing AndAlso FU_Lampiran2.PostedFile.ContentLength > 0 Then
                If updateUploadFile(FU_Lampiran2, SaveLocation) Then
                    Dim PermohonanID As Integer = CInt(GridView1.SelectedDataKey.Values(0))

                    Using myConnection As New SqlConnection(CS)
                        myConnection.Open()
                        Dim SQL As String = "INSERT INTO LESEN_PermohonanFail (PermohonanFail_PermohonanID, PermohonanFail_ContentType, PermohonanFail_FileName, PermohonanFail_FilePath, PermohonanFail_JenisLampiran) " &
                                            "VALUES (@Permohonan_ID, @ContentType, @FileName, @FilePath, 'L2')"
                        Dim myCommandSelect As New SqlCommand(SQL, myConnection)
                        myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", PermohonanID)
                        myCommandSelect.Parameters.AddWithValue("@FileName", FU_Lampiran2.PostedFile.FileName)
                        myCommandSelect.Parameters.AddWithValue("@ContentType", FU_Lampiran2.PostedFile.ContentType)
                        myCommandSelect.Parameters.AddWithValue("@FilePath", localPath)

                        Try
                            myCommandSelect.ExecuteNonQuery()
                            GetLampiran(PermohonanID)
                        Catch ex As Exception
                            MessageBox("Error inserting to database", Me)
                        End Try
                    End Using
                End If
            End If
        End If
    End Sub

    Private Sub GetLampiran(pid As Integer)
        FU_Lampiran1.Visible = True
        BT_Lampiran1.Visible = True
        FU_Lampiran2.Visible = True
        BT_Lampiran2.Visible = True

        BT_Cancel1.Visible = False
        HL_Lampiran1.Visible = False
        BT_Update1.Visible = False
        BT_Delete1.Visible = False
        BT_Cancel2.Visible = False
        HL_Lampiran2.Visible = False
        BT_Update2.Visible = False
        BT_Delete2.Visible = False

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "SELECT PermohonanFail_FileName, PermohonanFail_FilePath, PermohonanFail_JenisLampiran FROM LESEN_PermohonanFail WHERE PermohonanFail_JenisLampiran <> 'U' AND PermohonanFail_PermohonanID = @Permohonan_ID"
            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)
            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader()

            Try
                While myReader.Read()
                    Dim jenisLampiran As String = myReader.Item("PermohonanFail_JenisLampiran").ToString()

                    If jenisLampiran = "L1" Then
                        HL_Lampiran1.Text = myReader.Item("PermohonanFail_FileName").ToString()
                        HL_Lampiran1.NavigateUrl = myReader.Item("PermohonanFail_FilePath").ToString()

                        FU_Lampiran1.Visible = False
                        BT_Lampiran1.Visible = False
                        BT_Cancel1.Visible = False
                        HL_Lampiran1.Visible = True
                        BT_Update1.Visible = True
                        BT_Delete1.Visible = True

                    ElseIf jenisLampiran = "L2" Then
                        HL_Lampiran2.Text = myReader.Item("PermohonanFail_FileName").ToString()
                        HL_Lampiran2.NavigateUrl = myReader.Item("PermohonanFail_FilePath").ToString()

                        FU_Lampiran2.Visible = False
                        BT_Lampiran2.Visible = False
                        BT_Cancel2.Visible = False
                        HL_Lampiran2.Visible = True
                        BT_Update2.Visible = True
                        BT_Delete2.Visible = True
                    End If
                End While
            Catch ex As Exception
                MessageBox("ERROR", Me)
            End Try
        End Using
    End Sub

    Protected Sub DeleteLampiran(lampiran As String)
        Dim pid As Integer = CInt(GridView1.SelectedDataKey.Values(0))

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "DELETE FROM LESEN_PermohonanFail WHERE PermohonanFail_JenisLampiran = @JenisLampiran AND PermohonanFail_PermohonanID = @Permohonan_ID"
            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)
            myCommandSelect.Parameters.AddWithValue("@JenisLampiran", lampiran)

            Try
                Dim result As Integer = myCommandSelect.ExecuteNonQuery()

                If result > 0 AndAlso lampiran = "L1" Then
                    FU_Lampiran1.Visible = True
                    BT_Lampiran1.Visible = True
                    BT_Cancel1.Visible = False
                    HL_Lampiran1.Visible = False
                    BT_Update1.Visible = False
                    BT_Delete1.Visible = False

                ElseIf result > 0 AndAlso lampiran = "L2" Then
                    FU_Lampiran2.Visible = True
                    BT_Lampiran2.Visible = True
                    BT_Cancel2.Visible = False
                    HL_Lampiran2.Visible = False
                    BT_Update2.Visible = False
                    BT_Delete2.Visible = False

                ElseIf result > 0 AndAlso lampiran = "SK" Then
                    FU_Lampiran3.Visible = True
                    BT_Cancel3.Visible = False
                    HL_Lampiran3.Visible = False
                    BT_Update3.Visible = False
                    BT_Delete3.Visible = False
                End If
            Catch ex As Exception
                MessageBox("Error", Me)
            End Try
        End Using
    End Sub

    Protected Sub BT_Update1_Click(sender As Object, e As EventArgs)
        FU_Lampiran1.Visible = True
        BT_Lampiran1.Visible = True
        BT_Cancel1.Visible = True
        HL_Lampiran1.Visible = False
        BT_Update1.Visible = False
        BT_Delete1.Visible = False
    End Sub

    Protected Sub BT_Cancel1_Click(sender As Object, e As EventArgs)
        FU_Lampiran1.Visible = False
        BT_Lampiran1.Visible = False
        BT_Cancel1.Visible = False
        HL_Lampiran1.Visible = True
        BT_Update1.Visible = True
        BT_Delete1.Visible = True
    End Sub

    Protected Sub BT_Delete1_Click(sender As Object, e As EventArgs)
        DeleteLampiran("L1")
    End Sub

    Protected Sub BT_Update2_Click(sender As Object, e As EventArgs)
        FU_Lampiran2.Visible = True
        BT_Lampiran2.Visible = True
        BT_Cancel2.Visible = True
        HL_Lampiran2.Visible = False
        BT_Update2.Visible = False
        BT_Delete2.Visible = False
    End Sub

    Protected Sub BT_Cancel2_Click(sender As Object, e As EventArgs)
        FU_Lampiran2.Visible = False
        BT_Lampiran2.Visible = False
        BT_Cancel2.Visible = False
        HL_Lampiran2.Visible = True
        BT_Update2.Visible = True
        BT_Delete2.Visible = True
    End Sub

    Protected Sub BT_Delete2_Click(sender As Object, e As EventArgs)
        DeleteLampiran("L2")
    End Sub

#End Region

#Region "Tab 3: Ulasan IK & Agensi Luar"

    Private Sub gvTabUlasan_RowUpdating(sender As Object, e As GridViewUpdateEventArgs) Handles gvTabUlasan.RowUpdating
        Dim txtUlasanFail_FilePath As FileUpload
        If Request.Browser.IsMobileDevice Then
            txtUlasanFail_FilePath = CType(gvTabUlasan.Rows(e.RowIndex).FindControl("txtUlasanFail_FilePathMobile"), FileUpload)
        Else
            txtUlasanFail_FilePath = CType(gvTabUlasan.Rows(e.RowIndex).FindControl("txtUlasanFail_FilePath"), FileUpload)
        End If

        Dim uid As Guid = Guid.NewGuid()
        Dim fn As String = System.IO.Path.GetFileName(txtUlasanFail_FilePath.PostedFile.FileName)
        Dim localPath As String = "~/doc/" & uid.ToString() & fn
        Dim SaveLocation As String = Server.MapPath(localPath)

        If (txtUlasanFail_FilePath.PostedFile IsNot Nothing) AndAlso (txtUlasanFail_FilePath.PostedFile.ContentLength > 0) Then
            ' Delete previous file if replacing
            If Not String.IsNullOrEmpty(CStr(e.OldValues("UlasanFail_FilePath"))) Then
                Dim deleteFilePath As String = Server.MapPath(CStr(e.OldValues("UlasanFail_FilePath")))
                If System.IO.File.Exists(deleteFilePath) Then
                    System.IO.File.Delete(deleteFilePath)
                End If
            End If

            If updateUploadFile(txtUlasanFail_FilePath, SaveLocation) Then
                e.NewValues("UlasanFail_FileName") = txtUlasanFail_FilePath.PostedFile.FileName
                e.NewValues("UlasanFail_ContentType") = txtUlasanFail_FilePath.PostedFile.ContentType
                e.NewValues("UlasanFail_FilePath") = localPath
            End If
        End If
    End Sub

    Private Sub gvTabUlasan_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvTabUlasan.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim btnUpload As Button = CType(e.Row.Cells(0).FindControl("btnUpload"), Button)
            Dim LinkButton1 As LinkButton

            If Request.Browser.IsMobileDevice Then
                LinkButton1 = CType(e.Row.Cells(0).FindControl("LinkButton1Mobile"), LinkButton)
            Else
                LinkButton1 = CType(e.Row.Cells(0).FindControl("LinkButton1"), LinkButton)
            End If

            If btnUpload IsNot Nothing Then
                Dim currPageScriptManager As ScriptManager = TryCast(ScriptManager.GetCurrent(Page), ScriptManager)
                If currPageScriptManager IsNot Nothing AndAlso LinkButton1 IsNot Nothing Then
                    currPageScriptManager.RegisterPostBackControl(LinkButton1)
                End If
            End If
        End If
    End Sub

    Private Sub gvTabUlasan_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvTabUlasan.RowDeleting
        If Not String.IsNullOrEmpty(CStr(e.Values("UlasanFail_FilePath"))) Then
            Dim deleteFilePath As String = Server.MapPath(CStr(e.Values("UlasanFail_FilePath")))
            If System.IO.File.Exists(deleteFilePath) Then
                System.IO.File.Delete(deleteFilePath)
            End If
        End If
    End Sub

    Private Sub gvTabUlasanLuar_RowUpdating(sender As Object, e As GridViewUpdateEventArgs) Handles gvTabUlasanLuar.RowUpdating
        Dim txtUlasanFail_FilePath As FileUpload
        If Request.Browser.IsMobileDevice Then
            txtUlasanFail_FilePath = CType(gvTabUlasanLuar.Rows(e.RowIndex).FindControl("txtUlasanFail_FilePathMobile"), FileUpload)
        Else
            txtUlasanFail_FilePath = CType(gvTabUlasanLuar.Rows(e.RowIndex).FindControl("txtUlasanFail_FilePath"), FileUpload)
        End If

        Dim uid As Guid = Guid.NewGuid()
        Dim fn As String = System.IO.Path.GetFileName(txtUlasanFail_FilePath.PostedFile.FileName)
        Dim localPath As String = "~/doc/" & uid.ToString() & fn
        Dim SaveLocation As String = Server.MapPath(localPath)

        If (txtUlasanFail_FilePath.PostedFile IsNot Nothing) AndAlso (txtUlasanFail_FilePath.PostedFile.ContentLength > 0) Then
            ' Delete previous file if replacing
            If Not String.IsNullOrEmpty(CStr(e.OldValues("UlasanFail_FilePath"))) Then
                Dim deleteFilePath As String = Server.MapPath(CStr(e.OldValues("UlasanFail_FilePath")))
                If System.IO.File.Exists(deleteFilePath) Then
                    System.IO.File.Delete(deleteFilePath)
                End If
            End If

            If updateUploadFile(txtUlasanFail_FilePath, SaveLocation) Then
                e.NewValues("UlasanFail_FileName") = txtUlasanFail_FilePath.PostedFile.FileName
                e.NewValues("UlasanFail_ContentType") = txtUlasanFail_FilePath.PostedFile.ContentType
                e.NewValues("UlasanFail_FilePath") = localPath
            End If
        End If
    End Sub

    Private Sub gvTabUlasanLuar_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvTabUlasanLuar.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim btnUpload As Button = CType(e.Row.Cells(0).FindControl("btnUpload"), Button)
            Dim LinkButton1 As LinkButton

            If Request.Browser.IsMobileDevice Then
                LinkButton1 = CType(e.Row.Cells(0).FindControl("LinkButton1Mobile"), LinkButton)
            Else
                LinkButton1 = CType(e.Row.Cells(0).FindControl("LinkButton1"), LinkButton)
            End If

            If btnUpload IsNot Nothing Then
                Dim currPageScriptManager As ScriptManager = TryCast(ScriptManager.GetCurrent(Page), ScriptManager)
                If currPageScriptManager IsNot Nothing AndAlso LinkButton1 IsNot Nothing Then
                    currPageScriptManager.RegisterPostBackControl(LinkButton1)
                End If
            End If
        End If
    End Sub

    Private Sub gvTabUlasanLuar_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvTabUlasanLuar.RowDeleting
        If Not String.IsNullOrEmpty(CStr(e.Values("UlasanFail_FilePath"))) Then
            Dim deleteFilePath As String = Server.MapPath(CStr(e.Values("UlasanFail_FilePath")))
            If System.IO.File.Exists(deleteFilePath) Then
                System.IO.File.Delete(deleteFilePath)
            End If
        End If
    End Sub

    Protected Sub btnUpload_Click(sender As Object, e As EventArgs)
        ' Handler stub for async postback attachment triggers
    End Sub

#End Region

#Region "Tab 4: Kadar Bayaran"

    Protected Sub cbsel_CheckedChanged(sender As Object, e As EventArgs)
        Dim cb As CheckBox = DirectCast(sender, CheckBox)
        Dim row As GridViewRow = DirectCast(cb.NamingContainer, GridViewRow)
        Dim kbId As String = DirectCast(row.FindControl("Label1"), Label).Text

        Using myConnection As New SqlConnection(CS)
            Dim SQL As String = "UPDATE LESEN_KadarBayaran SET IsSelect = @IsSelect WHERE KadarBayaran_ID = @KadarBayaran_ID"
            Try
                Dim myCommand As New SqlCommand(SQL, myConnection)
                myCommand.Parameters.AddWithValue("@KadarBayaran_ID", kbId)
                myCommand.Parameters.AddWithValue("@IsSelect", If(cb.Checked, 1, 0))

                myConnection.Open()
                myCommand.ExecuteNonQuery()
                gvTabBayaran.DataBind()
            Catch ex As Exception
                MessageBox("ERROR", Me)
            End Try
        End Using
    End Sub

    Protected Sub txtSeqNo_TextChanged(sender As Object, e As EventArgs)
        Dim tb As TextBox = DirectCast(sender, TextBox)
        Dim row As GridViewRow = DirectCast(tb.NamingContainer, GridViewRow)
        Dim kbId As String = DirectCast(row.FindControl("Label1"), Label).Text

        If tb.Text.Trim().Length > 0 Then
            Using myConnection As New SqlConnection(CS)
                Dim SQL As String = "UPDATE LESEN_KadarBayaran SET SeqNo = @SeqNo WHERE KadarBayaran_ID = @KadarBayaran_ID"
                Try
                    Dim myCommand As New SqlCommand(SQL, myConnection)
                    myCommand.Parameters.AddWithValue("@KadarBayaran_ID", kbId)
                    myCommand.Parameters.AddWithValue("@SeqNo", tb.Text)

                    myConnection.Open()
                    myCommand.ExecuteNonQuery()
                    gvTabBayaran.DataBind()
                Catch ex As Exception
                    MessageBox("ERROR", Me)
                End Try
            End Using
        End If
    End Sub

#End Region

#Region "Report & Letter Generation"

    Protected Sub BT_ViewMail_Command(sender As Object, e As CommandEventArgs)
        Dim pid As Integer = CInt(Me.FormView1.DataKey("Permohonan_ID"))
        If GetIsSuratFail(pid) Then
            ViewSuratKelulusanFail(pid.ToString())
        Else
            ViewSuratKelulusanAuto(pid.ToString(), True)
        End If
    End Sub

    Private Sub ViewSuratKelulusanAuto(permohonanID As String, isPDF As Boolean)
        Dim totalid As Integer = 0

        ' Check if lampiran larangan merokok is needed
        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim sql1 As String = "SELECT COUNT(PSID) AS TotalID FROM LESEN_PermohonanSurat WHERE Permohonan_ID = @permohonanID " &
                                 "AND JenisReport LIKE 'SK%' AND IsiKandungan like '%merokok%' "
            Dim myCommandSelect As New SqlCommand(sql1, myConnection)
            myCommandSelect.Parameters.AddWithValue("@permohonanID", permohonanID)
            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader()

            Try
                If myReader.Read() Then
                    totalid = CInt(myReader.Item("TotalID"))
                Else
                    ShowAlert("error", "", "Checking Lampiran Larangan Merokok.")
                End If
            Catch ex As Exception
            End Try
        End Using

        Dim sql As String = ""
        Try
            sql = "SELECT a.Permohonan_ID, a.TarikhSuratKelulusan, a.CreatedDt, CAST(a.NamaSyarikat AS varchar(200)) AS NamaSyarikat, " &
                  "a.NoPendaftaran, a.NoAkaun, a.AlamatPremis, a.JenisPerniagaan, a.PemilikBaru, a.AlamatBaru, " &
                  "a.JenisPerniagaanBaru, a.NamaBaruSyarikat, a.BillboardLokasi, a.LokasiPasar1, a.LokasiPasar2, " &
                  "a.LokasiPasar3, a.JenisPasar, a.JenisPerniagaanPasar, a.JumlahPetak, a.AnjingAlamat, a.AnjingJenisMohon, " &
                  "a.AnjingJenisPremis, a.AlamatPenjajaan, a.JenisPerniagaanPenjaja, a.TarikhBatal, a.PenganjurEkspo, " &
                  "a.NamaEkspo, a.LokasiEkspo, a.NoTelEkspo, a.TarikhEkspo1, a.TarikhEkspo2, a.MasaEkspo1, a.MasaEkspo2, " &
                  "a.Rujukan, a.NoAkaunCukai, a.IsBatal, a.JenisLesenDescList, a.JenisLesenIdList, a.SaizIklanList, " &
                  "a.CahayaIklanList, a.UnitIklanList, a.BakaAnjingList, a.AnjingJantanList, a.AnjingBetinaList, " &
                  "a.AnjingJantanMandulList, a.AnjingBetinaMandulList, " &
                  "b.Pemohon_Name, b.Pemohon_Address, b.Pemohon_ICNo, b.Pemohon_MobileNo, b.Pemohon_TelNo, " &
                  "c.Users_Fullname, c.Users_Signature, d.P1, d.P2, d.P3, d.IsiKandungan " &
                  "FROM LESEN_Permohonan a " &
                  "INNER JOIN LESEN_Pemohon b ON b.Pemohon_ID=a.Permohonan_PemohonID " &
                  "LEFT JOIN TBL_USERS c ON a.TandatanganKelulusanId=c.Users_Id " &
                  "LEFT JOIN LESEN_PermohonanSurat d ON d.Permohonan_ID=a.Permohonan_ID AND d.JenisReport LIKE 'SK%' " &
                  "WHERE a.Permohonan_ID=@permohonanID ORDER BY d.P1, d.P2, d.P3"

            sql = sql.Replace("@permohonanID", permohonanID)

            Dim ReportVar As String = "suratkelulusan_v2"
            Dim pobjData(1, 1) As Object
            Dim lStrReportName As String = ReportVar & ".rpt"

            pobjData(0, 0) = "paraSQL" : pobjData(0, 1) = sql
            pobjData(1, 0) = "isDigitalSign" : pobjData(1, 1) = isPDF

            Session.Item("ReportName" & ReportVar) = lStrReportName
            Session.Item("pobjData" & ReportVar) = pobjData
            Session.Item("pathUrl" & ReportVar) = "~/lesen/report/kelulusan"

            If isPDF Then
                Session.Item("reportPrintType") = "pdf"
            End If

            If totalid = 0 Then
                ScriptManager.RegisterClientScriptBlock(Me.Page, Me.GetType(), ReportVar, "window.open('../ReportViewer.aspx?name=" & ReportVar & "', '_blank', '');", True)
            Else
                ScriptManager.RegisterClientScriptBlock(Me.Page, Me.GetType(), ReportVar, "window.open('../ReportViewer1.aspx?name=" & ReportVar & "', '_blank', '');", True)
            End If
        Catch ex As Exception
            MessageBox(ex.Message, Me)
        End Try
    End Sub

    Private Sub ViewSuratKelulusanFail(permohonanID As String)
        Dim filepath As String = ""

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "SELECT PermohonanFail_FilePath FROM LESEN_PermohonanFail WHERE PermohonanFail_PermohonanID = @permohonanID AND PermohonanFail_JenisLampiran = 'SK'"
            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@permohonanID", permohonanID)
            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader()

            Try
                If myReader.Read() Then
                    filepath = myReader.Item("PermohonanFail_FilePath").ToString()
                    filepath = filepath.Remove(0, 1)
                    ScriptManager.RegisterClientScriptBlock(Me.Page, Me.GetType(), "", "window.open('.." & filepath & "', '_blank', '');", True)
                End If
            Catch ex As Exception
            End Try
        End Using
    End Sub

    Private Sub ViewLampiran(permohonanID As String, jenisLampiran As String)
        Dim filepath As String = ""

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "SELECT PermohonanFail_FilePath FROM LESEN_PermohonanFail WHERE PermohonanFail_PermohonanID = @permohonanID AND PermohonanFail_JenisLampiran = @jenisLampiran"
            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@permohonanID", permohonanID)
            myCommandSelect.Parameters.AddWithValue("@jenisLampiran", jenisLampiran)
            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader()

            Try
                If myReader.Read() Then
                    filepath = myReader.Item("PermohonanFail_FilePath").ToString()
                    filepath = filepath.Remove(0, 1)
                    ScriptManager.RegisterClientScriptBlock(Me.Page, Me.GetType(), "", "window.open('.." & filepath & "', '_blank', '');", True)
                Else
                    ShowAlert("error", "", "Tiada Lampiran")
                End If
            Catch ex As Exception
            End Try
        End Using
    End Sub

    Private Function GetIsSuratFail(pid As Integer) As Boolean
        Dim isFail As Boolean = False

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "SELECT IsSuratKelulusanFail FROM LESEN_Permohonan WHERE Permohonan_ID = @Permohonan_ID"
            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)
            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader()

            Try
                If myReader.Read() Then
                    isFail = CBool(myReader.Item("IsSuratKelulusanFail"))
                End If
            Catch ex As Exception
                MessageBox(ex.Message, Me)
            End Try
        End Using

        Return isFail
    End Function

    Protected Sub BT_SuratMohonUlasan_Command(sender As Object, e As CommandEventArgs)
        Dim jenisLesenIdList As String = CStr(Me.FormView1.DataKey("JenisLesenIdList"))
        Dim permohonanID As Integer = CInt(Me.FormView1.DataKey("Permohonan_ID"))
        Dim agensiID As Integer = CInt(Session.Item("sessionEstateID"))

        Dim sql As String = ""
        Dim jenisLesenDesc = {"mpk_suratmohonulasan_l", "mpk_suratmohonulasan_psr", "mpk_suratmohonulasan_anj", "mpk_suratmohonulasan_pjj", "mpk_suratmohonulasan_bb", "mpk_suratmohonulasan_ep"}
        Dim jenisLesenDescLuar = {"mpk_suratmohonulasan_l", "mpk_suratmohonulasan_psr_l", "mpk_suratmohonulasan_anj_l", "mpk_suratmohonulasan_pjj_l", "mpk_suratmohonulasan_bb_l", "mpk_suratmohonulasan_ep_l"}

        Try
            sql = "SELECT a.Permohonan_ID, a.TarikhMohon, a.CreatedDt, CAST(a.NamaSyarikat AS varchar(200)) AS NamaSyarikat, a.NoPendaftaran, a.NoAkaun, a.AlamatPremis, a.JenisPerniagaan, a.PemilikBaru, " &
                  "a.AlamatBaru, a.JenisPerniagaanBaru, a.NamaBaruSyarikat, a.BillboardLokasi, a.LokasiPasar1, a.LokasiPasar2, a.LokasiPasar3, a.JenisPasar, a.JenisPerniagaanPasar, a.JumlahPetak, a.AnjingAlamat, " &
                  "a.AnjingJenisMohon, a.AnjingJenisPremis, a.AlamatPenjajaan, a.JenisPerniagaanPenjaja, a.TarikhBatal, a.PenganjurEkspo, a.NamaEkspo, a.LokasiEkspo, a.NoTelEkspo, a.TarikhEkspo1, a.TarikhEkspo2, " &
                  "a.MasaEkspo1, a.MasaEkspo2, a.Rujukan, a.NoAkaunCukai, a.IsBatal, a.JenisLesenDescList, a.JenisLesenIdList, a.SaizIklanList, a.CahayaIklanList, a.UnitIklanList, a.BakaAnjingList, a.AnjingJantanList, " &
                  "a.AnjingBetinaList, a.AnjingJantanMandulList, a.AnjingBetinaMandulList, e.JabatanAgensi_Address, e.JabatanAgensi_Kepada, b.Pemohon_Name, b.Pemohon_ICNo, b.Pemohon_PassportNo, b.Pemohon_Address, " &
                  "b.Pemohon_Email, b.Pemohon_MobileNo, b.Pemohon_TelNo, g.Users_Fullname, g.Users_Signature " &
                  "FROM LESEN_Permohonan a " &
                  "INNER JOIN LESEN_Pemohon b ON a.Permohonan_PemohonID = b.Pemohon_ID " &
                  "INNER JOIN LESEN_PermohonanAgensi d ON a.Permohonan_ID = d.Permohonan_ID " &
                  "INNER JOIN LESEN_JabatanAgensi e ON d.JabatanAgensi_ID = e.JabatanAgensi_ID " &
                  "LEFT JOIN TBL_USERS g ON g.Users_Id = (CASE WHEN e.JabatanAgensi_Type = 'J' THEN a.TandatanganMohonUlasanId WHEN e.JabatanAgensi_Type = 'L' THEN a.TandatanganMohonUlasanLuarId END) " &
                  "WHERE a.Permohonan_ID=" & permohonanID & " AND e.JabatanAgensi_ID = " & agensiID

            Dim ReportVar As String = jenisLesenDesc(0)

            Select Case jenisLesenIdList
                Case "2", "25"
                    ReportVar = jenisLesenDesc(1)
                Case "3"
                    ReportVar = jenisLesenDesc(2)
                Case "4"
                    ReportVar = jenisLesenDesc(3)
                Case "5"
                    ReportVar = jenisLesenDesc(4)
                Case "15"
                    ReportVar = jenisLesenDesc(5)
            End Select

            If getJabatanLesen(CInt(Session.Item("sessionEstateID"))) = False Then
                Select Case jenisLesenIdList
                    Case "2", "25"
                        ReportVar = jenisLesenDescLuar(1)
                    Case "3"
                        ReportVar = jenisLesenDescLuar(2)
                    Case "4"
                        ReportVar = jenisLesenDescLuar(3)
                    Case "5"
                        ReportVar = jenisLesenDescLuar(4)
                    Case "15"
                        ReportVar = jenisLesenDescLuar(5)
                End Select
            End If

            Dim pobjData(0, 1) As Object
            Dim lStrReportName As String = ReportVar & ".rpt"

            pobjData(0, 0) = "paraSQL" : pobjData(0, 1) = sql

            Session.Item("ReportName" & ReportVar) = lStrReportName
            Session.Item("pobjData" & ReportVar) = pobjData
            Session.Item("pathUrl" & ReportVar) = "~/lesen/report/mohonulasan"
            Session.Item("reportPrintType") = "pdf"

            ScriptManager.RegisterClientScriptBlock(Me.Page, Me.GetType(), ReportVar, "window.open('../ReportViewer.aspx?name=" & ReportVar & "', '_blank', '');", True)
        Catch ex As Exception
            MessageBox(ex.Message, Me)
        End Try
    End Sub

    Private Function getJabatanLesen(agensiID As Integer) As Boolean
        Dim retval As Boolean = False

        Using myConnection As New SqlConnection(CS)
            Dim SQL As String = "SELECT 1 FROM LESEN_JabatanAgensi WHERE JabatanAgensi_IsLesen=1 AND JabatanAgensi_IsActive=1 AND JabatanAgensi_ID = @JabatanAgensi_ID"
            Dim myCommand As New SqlCommand(SQL, myConnection)
            myCommand.Parameters.AddWithValue("@JabatanAgensi_ID", agensiID)

            myConnection.Open()
            Dim myReader As SqlDataReader = myCommand.ExecuteReader()
            If myReader.Read() Then
                retval = True
            End If
        End Using

        If agensiID = 0 Then
            retval = True
        End If

        Return retval
    End Function

#End Region

#Region "File Upload & Scaling Helpers"

    Private Function updateUploadFile(txtUlasanFail_FilePath As FileUpload, saveLocation As String) As Boolean
        Dim retval As Boolean = True

        If (txtUlasanFail_FilePath.PostedFile IsNot Nothing) AndAlso (txtUlasanFail_FilePath.PostedFile.ContentLength > 0) Then
            Try
                Dim fileExtension As String = txtUlasanFail_FilePath.PostedFile.ContentType
                Dim fileLength As Integer = txtUlasanFail_FilePath.PostedFile.ContentLength

                If fileExtension = "image/png" OrElse fileExtension = "image/jpeg" OrElse fileExtension = "image/x-png" Then
                    If fileLength <= MaxFileSizeInBytes Then
                        Using bmpPostedImage As New System.Drawing.Bitmap(txtUlasanFail_FilePath.PostedFile.InputStream)
                            Using objImage As System.Drawing.Image = ScaleImage(bmpPostedImage, 1024)
                                objImage.Save(saveLocation, ImageFormat.Jpeg)
                            End Using
                        End Using
                        MessageBox("Fail berjaya dimuatnaik", Me)
                    Else
                        MessageBox("Image size cannot be more then 5 MB!", Me)
                        retval = False
                    End If
                Else
                    If fileLength <= MaxFileSizeInBytes Then
                        Try
                            txtUlasanFail_FilePath.PostedFile.SaveAs(saveLocation)
                        Catch ex As Exception
                            MessageBox(ex.Message, Me)
                        End Try
                        MessageBox("Fail berjaya dimuatnaik", Me)
                    Else
                        MessageBox("Image size cannot be more then 5 MB!", Me)
                        retval = False
                    End If
                End If
            Catch ex As Exception
                MessageBox(ex.Message, Me)
                retval = False
            End Try
        Else
            MessageBox("Muat naik fail gagal. Sila cuba sekali lagi", Me)
            retval = False
        End If

        Return retval
    End Function

    Public Shared Function ScaleImage(ByVal image As System.Drawing.Image, ByVal maxHeight As Integer) As System.Drawing.Image
        Dim ratio As Double = CDbl(maxHeight) / image.Height
        Dim newWidth As Integer = CInt(image.Width * ratio)
        Dim newHeight As Integer = CInt(image.Height * ratio)
        Dim newImage As New Bitmap(newWidth, newHeight)

        Using g As Graphics = Graphics.FromImage(newImage)
            g.DrawImage(image, 0, 0, newWidth, newHeight)
        End Using

        Return newImage
    End Function

#End Region

#Region "Alert & Dialog Helpers"

    Public Sub MessageBox(ByVal Msg As String, ByVal obj As System.Web.UI.Page)
        Dim cleanMsg As String = Msg.Replace("'", "\'")
        ScriptManager.RegisterClientScriptBlock(Me.Page, Me.GetType(), "Alert", "alert('" & cleanMsg & "');", True)
    End Sub

    Private Sub ShowAlert(statusMsg As String, titleMsg As String, strMsg As String)
        Dim cleanTitle As String = titleMsg.Replace("'", "\'")
        Dim cleanStr As String = strMsg.Replace("'", "\'")
        ScriptManager.RegisterStartupScript(Me, Page.GetType(), "Script",
            "Swal.fire('" & cleanTitle & "', '" & cleanStr & "', '" & statusMsg & "');", True)
    End Sub

#End Region

End Class
