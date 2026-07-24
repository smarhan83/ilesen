
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Drawing.Imaging
Imports System.IO
Imports Microsoft.ReportingServices.Rendering.ExcelRenderer.ExcelGenerator.BIFF8

Partial Class kelulusan1
    Inherits System.Web.UI.Page

    Protected Sub FormView1_ItemInserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertedEventArgs) Handles FormView1.ItemInserted

        ShowAlert("success", "", "Rekod berjaya disimpan")
        GridView1.DataBind()
    End Sub

    Protected Sub GridView1_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs) Handles GridView1.RowDeleting
        Dim title As String = GridView1.Rows(e.RowIndex).Cells(1).Text

        '//run audit trail : Insert : Update : Delete : Login : Logout
        GlobalClass.auditTrail(idWindowTitle.InnerText, title, "Nyah Aktif")
    End Sub

    Protected Sub GridView1_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles GridView1.SelectedIndexChanged
        FormView1.ChangeMode(DetailsViewMode.Edit)
        TabContainer1.Visible = True
        idFooter.Visible = True
        idListing.Visible = False
        idNotaKelulusan.Visible = False

        showFormControl(GridView1)



    End Sub

    Private Sub showFormControl(gv1 As GridView)
        Session.Item("isDisablePrintSession") = "Y"

        Dim idSokongUlasan As HtmlGenericControl = DirectCast(fvSokongUlasan.FindControl("idSokongUlasan"), HtmlGenericControl)
        Dim idSokongUlasanPengesah As HtmlGenericControl = DirectCast(fvSokongUlasan.FindControl("idSokongUlasanPengesah"), HtmlGenericControl)
        Dim hdnFiedlJabatanAgensiType As HiddenField = DirectCast(fvSokongUlasan.FindControl("hdnFiedlJabatanAgensiType"), HiddenField)
        Dim txtNotaKelulusanPengesah As TextBox = DirectCast(fvNotaKelulusan.FindControl("txtNotaKelulusanPengesah"), TextBox)
        Dim txtNotaKelulusan As TextBox = DirectCast(fvNotaKelulusan.FindControl("txtNotaKelulusan"), TextBox)

        Dim ApprStatusID As Integer = CInt(gv1.SelectedDataKey.Values(2))
        Dim PermohonanID As Integer = CInt(gv1.SelectedDataKey.Values(0))
        Dim JenisLesenID As Integer = CInt(gv1.SelectedDataKey.Values(4))
        Dim IsFail As Boolean = CBool(gv1.SelectedDataKey.Values(5))
        Dim IsPenilaianStatus As Integer = CInt(gv1.SelectedDataKey.Values(6))
        Dim jidList() As String = CStr(gv1.SelectedDataKey.Values("JenisLesenIdList")).Split(","c)

        '2  mohon ulasan
        '3  Penilaian Jabatan/Agensi
        '4	Peraku Jabatan/Agensi
        '5	Penilaian Jabatan Lesen
        '8	Peraku Jabatan Lesen

        btnSubmit.Visible = False
        btnApprove.Visible = False
        btnReject.Visible = False
        idNotaKelulusan.Visible = False


        If ApprStatusID = 2 Or ApprStatusID = 3 Or ApprStatusID = 4 Then
            btnSubmit.Visible = True

            If ApprStatusID = 2 Then
                btnSubmit.Text = "Simpan"
            Else
                btnSubmit.Text = "Hantar Ulasan"
            End If

            '//hide for kerani inspektorat
            If Session.Item("sessionIsPenyedia") = "True" And Session.Item("sessionIsReadOnly") = "True" Then
                btnSubmit.Visible = False
                tabSurat.Visible = False
            End If

        ElseIf ApprStatusID = 5 Or ApprStatusID = 8 Then

            If Session.Item("sessionIsPeraku") = "True" Or Session.Item("sessionIsPenilai") = "True" Then

                If getJabatanLesen(CInt(Session.Item("sessionEstateID"))) = True Then
                    If ApprStatusID = 8 And Session.Item("sessionIsPeraku") <> "True" Then
                        btnApprove.Visible = False
                        btnReject.Visible = False
                    Else
                        btnApprove.Visible = True
                        btnReject.Visible = True
                    End If
                    idNotaKelulusan.Visible = True
                    fvNotaKelulusan.Enabled = True
                End If


            End If

        ElseIf ApprStatusID = 6 Or ApprStatusID = 7 Or ApprStatusID = 9 Or ApprStatusID = 10 Then

            If Session.Item("sessionIsPeraku") = "True" Or Session.Item("sessionIsPenilai") = "True" Then

                If getJabatanLesen(CInt(Session.Item("sessionEstateID"))) = True Then
                    btnApprove.Visible = False
                    btnReject.Visible = False
                    idNotaKelulusan.Visible = True


                    Dim divNotaKelulusanPeraku As HtmlGenericControl = DirectCast(fvNotaKelulusan.FindControl("divNotaKelulusanPeraku"), HtmlGenericControl)

                    divNotaKelulusanPeraku.Visible = True

                    fvNotaKelulusan.Enabled = False


                End If


            End If

            'Try
            '    If ApprStatusID = 8 Then
            '        txtNotaKelulusanPengesah.Enabled = False
            '    Else
            '        txtNotaKelulusanPengesah.Enabled = True
            '    End If
            'Catch ex As Exception

            'End Try


        End If
        Dim agensiType As String = "L"
        '//hide tab kadar bayaran
        Try
            tabKadarBayaran.Visible = False
            tabMaklumat.Visible = False
            tabSurat.Visible = False
            TabPenjajaUlasan.Visible = False
            TabLampiran.Visible = False

            agensiType = If(IsDBNull(gv1.SelectedDataKey.Values(3)), "J", gv1.SelectedDataKey.Values(3))

            If getJabatanLesen(CInt(Session.Item("sessionEstateID"))) = True Or getJabatanDalaman(CInt(Session.Item("sessionEstateID"))) = True Then '//agensiType = "J"
                tabKadarBayaran.Visible = True
                TabLampiran.Visible = True

            End If

            '//tab surat
            If agensiType = "J" Then

                If Session.Item("sessionOCS") = "3" Then
                    tabSurat.Visible = True
                    'BT_ViewMail.Text = IsPenilaianStatus

                    If IsPenilaianStatus <> 0 Or Session.Item("sessionIsPenilai") = "True" Then
                        BT_ViewMail.Visible = True
                        Session.Item("isDisablePrintSession") = "N"
                    Else
                        'BT_ViewMail.Visible = False
                        Session.Item("isDisablePrintSession") = "Y"
                    End If

                    'If Session.Item("sessionIsPenilai") = "True" Then
                    'divTarikhSurat.Visible = True
                    'Else
                    'divTarikhSurat.Visible = False
                    'End If

                    GetSuratContent(PermohonanID)

                    '//hide for kerani inspektorat
                    If Session.Item("sessionIsPenyedia") = "True" And Session.Item("sessionIsReadOnly") = "True" Then
                        btnSubmit.Visible = False
                        tabSurat.Visible = False
                    End If

                End If

                If ApprStatusID = 3 Or ApprStatusID = 4 Then
                    BT_Generate.Visible = True
                    BT_Generate1.Visible = True

                    tabMaklumat.Visible = True

                    PanelAccessPembetulan(0, True)

                    For Each item In jidList
                        PanelAccessPembetulan(item, False)
                    Next

                    GetPermohonanPembetulan(PermohonanID)

                    If IsFail Then
                        CB_SuratFail.Checked = True
                        pnlSuratAuto.Visible = False
                        pnlSuratFail.Visible = True
                        BT_Generate.Visible = False
                        BT_Generate1.Visible = False
                    Else
                        CB_SuratFail.Checked = False
                        pnlSuratAuto.Visible = True
                        pnlSuratFail.Visible = False
                        BT_Generate.Visible = True
                        BT_Generate1.Visible = True

                        If JenisLesenID = 4 And EditorSurat1.Text.Length > 0 Then

                            TabPenjajaUlasan.Visible = True

                        End If


                    End If

                    GetSuratFail(PermohonanID)

                Else

                    BT_Generate.Visible = False
                    BT_Generate1.Visible = False

                End If
            End If


        Catch ex As Exception

        End Try

        '//hide tab tetapan ik
        If ApprStatusID = 2 Then
            tabUlasan.Visible = False
            tabKadarBayaran.Visible = False
            tabTetapan.Visible = True
            gvIK.Columns(1).Visible = "true"
        Else
            tabTetapan.Visible = False
            tabUlasan.Visible = True

            If getJabatanLesen(CInt(Session.Item("sessionEstateID"))) = True Or getJabatanDalaman(CInt(Session.Item("sessionEstateID"))) = True Then '//If agensiType = "J" Then
                'tabKadarBayaran.Visible = True
            End If

            Try
                If Session.Item("sessionOCS") = "3" Then
                    tabTetapan.Visible = True
                    gvIK.Columns(1).Visible = "false"
                End If
            Catch ex As Exception

            End Try

        End If



        '//hide column edit for kadar bayaran
        If ApprStatusID = 5 Or ApprStatusID >= 8 Then
            If Session.Item("sessionIsPenilai") = "True" Then
            Else

                gvTabBayaran.Columns(5).Visible = "false"
                gvTabBayaran.Columns(6).Visible = "false"

            End If
        End If

    End Sub

    '+++++++++ START FILTER +++++++++
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        '//generate filter
        'Dim gv As GridView = GridView1
        'Dim ds As SqlDataSource = SqlDataSourceGrid
        'GlobalClass.GenerateFilter(gv, ds, pnlFilter)

        Page.Form.Attributes.Add("enctype", "multipart/form-data")

        ''+++++ Selected column +++++
        'Dim lstColumn As New List(Of String)({"description"})
        'GlobalClass.GenerateFilter(gv, ds, pnlFilter, lstColumn)

        If Not Page.IsPostBack Then

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

            '//mobile view
            If Not Page.IsPostBack Then

                If Request.Browser.IsMobileDevice Then

                    gvTabUlasan.Columns(2).Visible = "false"
                    gvTabUlasan.Columns(3).Visible = "false"
                    gvTabUlasan.Columns(5).Visible = "false"
                    gvTabUlasan.Columns(4).Visible = "true"
                Else

                    gvTabUlasan.Columns(4).Visible = "false"
                End If
            End If

        Catch ex As Exception

        End Try

        Try

            '//mobile view
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

        Try

            '//mobile view
            If Not Page.IsPostBack Then

                If Request.Browser.IsMobileDevice Then
                    gvTabPenjajaUlasan.Columns(2).Visible = "false"
                    gvTabPenjajaUlasan.Columns(4).Visible = "false"
                    gvTabPenjajaUlasan.Columns(3).Visible = "true"

                Else

                    gvTabPenjajaUlasan.Columns(3).Visible = "false"
                End If
            End If

        Catch ex As Exception

        End Try



        '//show filter
        If getJabatanLesen(CInt(Session.Item("sessionEstateID"))) = False Then
            filterJenisLesen.Attributes.Add("style", "display:none")
            filterPemohon.Attributes.Add("style", "display:none")
        End If

        '//show all ulasan
        If Session.Item("sessionIsPenyedia") = "True" Or Session.Item("sessionIsReadOnly") = "True" Then
            divLihatSemuaUlasan.Visible = True
        Else
            divLihatSemuaUlasan.Visible = False
        End If
    End Sub

    Private Sub GetPermohonanPembetulan(permohonanID As Integer)

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQL As String = "SELECT * FROM LESEN_PermohonanPembetulan WHERE Permohonan_ID = @Permohonan_ID"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", permohonanID)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            Try
                If myReader.Read Then

                    If myReader.Item("SaizIklanList").ToString().Length > 0 Then
                        HF_SaizIklanList.Value = myReader.Item("SaizIklanList").ToString()
                    End If

                    If myReader.Item("CahayaIklanList").ToString().Length > 0 Then
                        HF_CahayaIklanList.Value = myReader.Item("CahayaIklanList").ToString()
                    End If

                    If myReader.Item("UnitIklanList").ToString().Length > 0 Then
                        HF_UnitIklanList.Value = myReader.Item("UnitIklanList").ToString()
                    End If

                    If myReader.Item("BakaAnjingList").ToString().Length > 0 Then
                        HF_BakaAnjingList.Value = myReader.Item("BakaAnjingList").ToString()
                    End If

                    If myReader.Item("AnjingJantanList").ToString().Length > 0 Then
                        HF_AnjingJantanList.Value = myReader.Item("AnjingJantanList").ToString()
                    End If

                    If myReader.Item("AnjingBetinaList").ToString().Length > 0 Then
                        HF_AnjingBetinaList.Value = myReader.Item("AnjingBetinaList").ToString()
                    End If

                    If myReader.Item("AnjingJantanMandulList").ToString().Length > 0 Then
                        HF_AnjingJantanMandulList.Value = myReader.Item("AnjingJantanMandulList").ToString()
                    End If

                    If myReader.Item("AnjingBetinaMandulList").ToString().Length > 0 Then
                        HF_AnjingBetinaMandulList.Value = myReader.Item("AnjingBetinaMandulList").ToString()
                    End If

                    If myReader.Item("NamaSyarikat").ToString().Length > 0 Then
                        TB_NamaSyarikat.Text = myReader.Item("NamaSyarikat").ToString()
                    End If

                    If myReader.Item("NoPendaftaran").ToString().Length > 0 Then
                        TB_NoPendaftaran.Text = myReader.Item("NoPendaftaran").ToString()
                    End If

                    If myReader.Item("NoAkaun").ToString().Length > 0 Then
                        TB_NoAkaun.Text = myReader.Item("NoAkaun").ToString()
                    End If

                    If myReader.Item("AlamatPremis").ToString().Length > 0 Then
                        TB_AlamatPremis.Text = myReader.Item("AlamatPremis").ToString()
                    End If

                    If myReader.Item("JenisPerniagaan").ToString().Length > 0 Then
                        TB_JenisPerniagaan.Text = myReader.Item("JenisPerniagaan").ToString()
                    End If

                    If myReader.Item("PemilikBaru").ToString().Length > 0 Then
                        TB_PemilikBaru.Text = myReader.Item("PemilikBaru").ToString()
                    End If

                    If myReader.Item("AlamatBaru").ToString().Length > 0 Then
                        TB_AlamatBaru.Text = myReader.Item("AlamatBaru").ToString()
                    End If

                    If myReader.Item("JenisPerniagaanBaru").ToString().Length > 0 Then
                        TB_JenisPerniagaanBaru.Text = myReader.Item("JenisPerniagaanBaru").ToString()
                    End If

                    If myReader.Item("NamaBaruSyarikat").ToString().Length > 0 Then
                        TB_NamaBaruSyarikat.Text = myReader.Item("NamaBaruSyarikat").ToString()
                    End If

                    If myReader.Item("BillboardLokasi").ToString().Length > 0 Then
                        TB_BillboardLokasi.Text = myReader.Item("BillboardLokasi").ToString()
                    End If

                    If myReader.Item("LokasiPasar1").ToString().Length > 0 Then
                        TB_LokasiPasar1.Text = myReader.Item("LokasiPasar1").ToString()
                    End If

                    If myReader.Item("LokasiPasar2").ToString().Length > 0 Then
                        TB_LokasiPasar2.Text = myReader.Item("LokasiPasar2").ToString()
                    End If

                    If myReader.Item("LokasiPasar3").ToString().Length > 0 Then
                        TB_LokasiPasar3.Text = myReader.Item("LokasiPasar3").ToString()
                    End If

                    If myReader.Item("JenisPasar").ToString().Length > 0 Then
                        DDL_JenisPasar.SelectedValue = myReader.Item("JenisPasar").ToString()
                    End If

                    If myReader.Item("JenisPerniagaanPasar").ToString().Length > 0 Then
                        TB_JenisPerniagaanPasar.Text = myReader.Item("JenisPerniagaanPasar").ToString()
                    End If

                    If myReader.Item("JumlahPetak").ToString().Length > 0 Then
                        TB_JumlahPetak.Text = myReader.Item("JumlahPetak").ToString()
                    End If

                    If myReader.Item("AnjingAlamat").ToString().Length > 0 Then
                        TB_AnjingAlamat.Text = myReader.Item("AnjingAlamat").ToString()
                    End If

                    If myReader.Item("AnjingJenisPremis").ToString().Length > 0 Then
                        DDL_AnjingJenisPremis.SelectedValue = CInt(myReader.Item("AnjingJenisPremis").ToString())
                    End If

                    If myReader.Item("AlamatPenjajaan").ToString().Length > 0 Then
                        TB_AlamatPenjajaan.Text = myReader.Item("AlamatPenjajaan").ToString()
                    End If

                    If myReader.Item("JenisPerniagaanPenjaja").ToString().Length > 0 Then
                        TB_JenisPerniagaanPenjaja.Text = myReader.Item("JenisPerniagaanPenjaja").ToString()
                    End If

                    If myReader.Item("PenganjurEkspo").ToString().Length > 0 Then
                        TB_PenganjurEkspo.Text = myReader.Item("PenganjurEkspo").ToString()
                    End If

                    If myReader.Item("NamaEkspo").ToString().Length > 0 Then
                        TB_NamaEkspo.Text = myReader.Item("NamaEkspo").ToString()
                    End If

                    If myReader.Item("LokasiEkspo").ToString().Length > 0 Then
                        TB_LokasiEkspo.Text = myReader.Item("LokasiEkspo").ToString()
                    End If

                    If myReader.Item("NoTelEkspo").ToString().Length > 0 Then
                        TB_NoTel.Text = myReader.Item("NoTelEkspo").ToString()
                    End If

                    If myReader.Item("TarikhEkspo1").ToString().Length > 0 Then
                        TB_TarikhEkspo1.Text = CDate(myReader.Item("TarikhEkspo1")).ToString("yyyy-MM-dd")
                    End If

                    If myReader.Item("TarikhEkspo2").ToString().Length > 0 Then
                        TB_TarikhEkspo2.Text = CDate(myReader.Item("TarikhEkspo2")).ToString("yyyy-MM-dd")
                    End If

                    If myReader.Item("MasaEkspo1").ToString().Length > 0 Then
                        TB_MasaEkspo1.Text = myReader.Item("MasaEkspo1").ToString()
                    End If

                    If myReader.Item("MasaEkspo2").ToString().Length > 0 Then
                        TB_MasaEkspo2.Text = myReader.Item("MasaEkspo2").ToString()
                    End If

                    If myReader.Item("KontraktorIklan").ToString().Length > 0 Then
                        TB_KontraktorIklan.Text = myReader.Item("KontraktorIklan").ToString()
                    End If

                    If myReader.Item("NoTelKontraktor").ToString().Length > 0 Then
                        TB_NoTelKontraktor.Text = myReader.Item("NoTelKontraktor").ToString()
                    End If

                    If myReader.Item("UkuranBanting").ToString().Length > 0 Then
                        TB_UkuranBanting.Text = myReader.Item("UkuranBanting").ToString()
                    End If

                    If myReader.Item("BilBanting").ToString().Length > 0 Then
                        TB_BilBanting.Text = CInt(myReader.Item("BilBanting").ToString())
                    End If

                    If IsDBNull(myReader.Item("TarikhBanting1")) = False Then
                        TB_TarikhBanting1.Text = CDate(myReader.Item("TarikhBanting1")).ToString("yyyy-MM-dd")
                    End If

                    If IsDBNull(myReader.Item("TarikhBanting2")) = False Then
                        TB_TarikhBanting2.Text = CDate(myReader.Item("TarikhBanting2")).ToString("yyyy-MM-dd")
                    End If

                    If myReader.Item("NoResitBanting").ToString().Length > 0 Then
                        TB_NoResitBanting.Text = myReader.Item("NoResitBanting").ToString()
                    End If

                    If myReader.Item("NoSiriStiker").ToString().Length > 0 Then
                        TB_NoSiriStiker.Text = myReader.Item("NoSiriStiker").ToString()
                    End If

                    If IsDBNull(myReader.Item("TarikhBanting3")) = False Then
                        TB_TarikhBanting3.Text = CDate(myReader.Item("TarikhBanting3")).ToString("yyyy-MM-dd")
                    End If

                End If

            Catch ex As Exception
                MessageBox("ERROR", Me)
            End Try

            myReader.Close()
            myConnection.Close()

        End Using

        'Load Senarai Iklan
        Dim SaizIklanList() = Split(HF_SaizIklanList.Value, ",")
        Dim CahayaIklanList() = Split(HF_CahayaIklanList.Value, ",")
        Dim UnitIklanList() = Split(HF_UnitIklanList.Value, ",")

        If SaizIklanList.Length > 0 Then

            Dim dt As DataTable

            If ViewState("IklanTable_ins") IsNot Nothing Then
                dt = DirectCast(ViewState("IklanTable_ins"), DataTable)
                dt.Clear()
            Else
                dt = New DataTable()
                dt.Columns.Add("SaizIklan", GetType(String))
                dt.Columns.Add("Bercahaya", GetType(String))
                dt.Columns.Add("Unit", GetType(String))
            End If

            For i As Integer = 0 To SaizIklanList.Length - 1
                Dim newRow As DataRow = dt.NewRow()
                newRow("SaizIklan") = SaizIklanList(i).Trim()
                newRow("Bercahaya") = CahayaIklanList(i).Trim()
                newRow("Unit") = UnitIklanList(i).Trim()

                dt.Rows.Add(newRow)
            Next

            ViewState("IklanTable_ins") = dt
            gvIklanList.DataSource = dt
            gvIklanList.DataBind()

        End If

        'Load Senarai Anjing
        Dim BakaAnjingList() = Split(HF_BakaAnjingList.Value, ",")
        Dim JantanList() = Split(HF_AnjingJantanList.Value, ",")
        Dim BetinaList() = Split(HF_AnjingBetinaList.Value, ",")
        Dim JantanMandulList() = Split(HF_AnjingJantanMandulList.Value, ",")
        Dim BetinaMandulList() = Split(HF_AnjingBetinaMandulList.Value, ",")

        If BakaAnjingList.Length > 0 Then

            Dim dt As DataTable

            If ViewState("AnjingTable_ins") IsNot Nothing Then
                dt = DirectCast(ViewState("AnjingTable_ins"), DataTable)
                dt.Clear()
            Else
                dt = New DataTable()
                dt.Columns.Add("Baka", GetType(String))
                dt.Columns.Add("Jantan", GetType(String))
                dt.Columns.Add("Betina", GetType(String))
                dt.Columns.Add("JantanMandul", GetType(String))
                dt.Columns.Add("BetinaMandul", GetType(String))
            End If

            For i As Integer = 0 To BakaAnjingList.Length - 1
                Dim newRow As DataRow = dt.NewRow()
                newRow("Baka") = BakaAnjingList(i).Trim()
                newRow("Jantan") = JantanList(i).Trim()
                newRow("Betina") = BetinaList(i).Trim()
                newRow("JantanMandul") = JantanMandulList(i).Trim()
                newRow("BetinaMandul") = BetinaMandulList(i).Trim()

                dt.Rows.Add(newRow)
            Next

            ViewState("AnjingTable_ins") = dt
            gvAnjingList.DataSource = dt
            gvAnjingList.DataBind()

        End If

        'Load Senarai Lokasi
        Dim LokasiList() = Split(HF_LokasiList.Value, "||")

        If LokasiList.Length > 0 Then

            Dim dt As DataTable

            If ViewState("LokasiTable_ins") IsNot Nothing Then
                dt = DirectCast(ViewState("LokasiTable_ins"), DataTable)
                dt.Clear()
            Else
                dt = New DataTable()
                dt.Columns.Add("No", GetType(String))
                dt.Columns.Add("Lokasi", GetType(String))
            End If

            For i As Integer = 0 To LokasiList.Length - 1
                Dim newRow As DataRow = dt.NewRow()
                newRow("No") = (i + 1).ToString
                newRow("Lokasi") = LokasiList(i).Trim()

                dt.Rows.Add(newRow)
            Next

            ViewState("LokasiTable_ins") = dt
            gvLokasiList.DataSource = dt
            gvLokasiList.DataBind()

        End If

    End Sub

    Private Function getJabatanLesen(agensiID As Integer) As Boolean
        Dim retval As Boolean = False

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Dim SQL As String = ""
            SQL = "select * from LESEN_JabatanAgensi where JabatanAgensi_IsLesen=1 
            and JabatanAgensi_IsActive=1 and JabatanAgensi_ID = @JabatanAgensi_ID "


            Dim myCommand As New SqlCommand(SQL, myConnection)
            myCommand.Parameters.AddWithValue("@JabatanAgensi_ID", agensiID)


            myConnection.Open()

            Dim myReader As SqlDataReader = myCommand.ExecuteReader

            Dim i As Integer = 0
            While myReader.Read
                'monthValueApprove = myReader("totCntApprove")
                retval = True

            End While

            myReader.Close()
            myConnection.Close()

        End Using

        If agensiID = 0 Then
            retval = True
        End If

        Return retval
    End Function

    Private Function getJabatanDalaman(agensiID As Integer) As Boolean
        Dim retval As Boolean = False

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Dim SQL As String = ""
            SQL = "select * from LESEN_JabatanAgensi where JabatanAgensi_Type='J'
            and JabatanAgensi_IsActive=1 and JabatanAgensi_ID = @JabatanAgensi_ID "


            Dim myCommand As New SqlCommand(SQL, myConnection)
            myCommand.Parameters.AddWithValue("@JabatanAgensi_ID", agensiID)


            myConnection.Open()

            Dim myReader As SqlDataReader = myCommand.ExecuteReader

            Dim i As Integer = 0
            While myReader.Read
                'monthValueApprove = myReader("totCntApprove")
                retval = True

            End While

            myReader.Close()
            myConnection.Close()

        End Using

        If agensiID = 0 Then
            retval = True
        End If

        Return retval
    End Function

    Private Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearch.Click
        '//generate filter
        'Dim ds As SqlDataSource = SqlDataSourceGrid
        'GlobalClass.procSearch(ds, pnlFilter)

        GridView1.DataBind()
    End Sub

    Private Sub btnReset_Click(sender As Object, e As EventArgs) Handles btnReset.Click
        Response.Redirect(Request.RawUrl)
    End Sub
    Protected Sub GridView1_PageIndexChanged(sender As Object, e As EventArgs) Handles GridView1.PageIndexChanged
        'CallFilter()
    End Sub

    Private Sub CallFilter()
        Dim ds As SqlDataSource = SqlDataSourceGrid
        'GlobalClass.procSearch(ds, pnlFilter)
    End Sub

    Protected Sub FormView1_ItemInserting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertEventArgs) Handles FormView1.ItemInserting
        Dim titleTxt As TextBox = DirectCast(FormView1.FindControl("txtJenisLesen_Description"), TextBox)
        Dim title As String = titleTxt.Text

        '//run audit trail : Insert : Update : Delete : Login : Logout
        GlobalClass.auditTrail(idWindowTitle.InnerText, title, "Maklumat")
    End Sub

    Protected Sub FormView1_ItemUpdated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdatedEventArgs) Handles FormView1.ItemUpdated

        ShowAlert("success", "", "Rekod berjaya dikemaskini")
        GridView1.DataBind()
    End Sub

    Protected Sub FormView1_ItemUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdateEventArgs) Handles FormView1.ItemUpdating
        Dim titleTxt As TextBox = DirectCast(FormView1.FindControl("txtJenisLesen_Description"), TextBox)
        Dim title As String = titleTxt.Text

        '//run audit trail : Insert : Update : Delete : Login : Logout
        GlobalClass.auditTrail(idWindowTitle.InnerText, title, "Kemaskini")
    End Sub

    Protected Sub Page_PreRenderComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRenderComplete

        Dim frmview() As Object = {FormView1}
        Dim lbutton() As Object = {} '//allow control
        Dim ctlDeny() As Object = {} '//deny control


        'If FormView1.CurrentMode = FormViewMode.Insert Then
        '    lnkSMAF.Add(DirectCast(FormView1.FindControl("InsertCancelButton"), LinkButton)) '//insert cancel
        'ElseIf FormView1.CurrentMode = FormViewMode.Edit Then
        '    lnkSMAF.Add(DirectCast(FormView1.FindControl("UpdatePrintButton"), LinkButton)) '//print
        'End If

        '//check Write
        Dim frmwrite As Boolean = GlobalClass.CheckPageWrite("Write", frmview, lbutton, ctlDeny)
        '// check gridview permission
        If frmwrite = False Then
            '//gridview select view
            GridView1.Columns.Item(5).Visible = False '//grid delete

        End If
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

    Private Sub FormView1_DataBound(sender As Object, e As EventArgs) Handles FormView1.DataBound
        '// page name initial
        initPageName()
        btnSaveLetter.Visible = "true"
        '//check all ulasan
        Try
            Dim isViewOnly As Boolean = False
            Dim ApprStatusID As Integer = CInt(GridView1.SelectedDataKey.Values(2))

            If ApprStatusID <> 3 And Session.Item("sessionIsPenilai") <> "True" Or Session.Item("sessionIsReadOnly") = "True" Then

                If Session.Item("sessionIsPenilai") = "True" And ApprStatusID > 5 Or Session.Item("sessionIsPeraku") = "True" And ApprStatusID >= 9 Then

                    gvTabUlasan.Columns(5).Visible = "false"
                    gvTabUlasan.Columns(6).Visible = "false"

                    If Session.Item("sessionIsPenilai") = "True" Then
                    Else

                        gvTabBayaran.Columns(5).Visible = "false"
                        gvTabBayaran.Columns(6).Visible = "false"

                    End If

                    BT_Generate.Visible = "false"
                    BT_Generate1.Visible = "false"
                    'btnSaveLetter.Visible = "false"
                    BT_Maklumat.Visible = "false"

                    idFooter.Visible = "false"
                    divBtnKembali.Visible = "true"

                End If

            End If
            If getJabatanLesen(CInt(Session.Item("sessionEstateID"))) = False And ApprStatusID >= 5 Then
                gvTabUlasan.Columns(5).Visible = "false"
                gvTabUlasan.Columns(6).Visible = "false"
            End If

            If Session.Item("sessionIsPeraku") = "True" Or Session.Item("sessionIsPenilai") = "True" Then
                idFooter.Visible = "true"
                divBtnKembali.Visible = "false"
            End If

        Catch ex As Exception

        End Try
    End Sub

    Private Sub ShowAlert(statusMsg As String, titleMsg As String, strMsg As String)

        ScriptManager.RegisterStartupScript(Me, Page.GetType, "Script", "Swal.fire('" & titleMsg & "',
        '" & strMsg & "',
        '" & statusMsg & "');", True)

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
        idFooter.Visible = False
        GridView1.SelectedIndex = -1
        divBtnKembali.Visible = False
    End Sub

    Protected Sub btnViewDetail_Click(sender As Object, e As EventArgs)

    End Sub

    Private Function checkMandatoryField() As Boolean

        Dim ApprStatusID As Integer = CInt(GridView1.SelectedDataKey.Values(2))

        Dim retval As Boolean = True

        If ApprStatusID = 4 Then

            If CB_SuratFail.Checked And ((FU_Lampiran1.Visible = True And FU_Lampiran1.HasFile = False) Or
        (HL_Lampiran1.Visible = True And HL_Lampiran1.Text.Length < 1)) Then

                ShowAlert("error", "", "Sila pilih fail surat yang ingin dimuat naik.")
                retval = False

            End If


            If CB_SuratFail.Checked = False Then

                If TB_TarikhPeriksa.Text.Length = 0 Then

                    ShowAlert("error", "", "Sila pilih tarikh pemeriksaan dan tekan simpan surat.")
                    retval = False

                End If

                If TB_TarikhSurat.Text.Length = 0 Or TB_TarikhSurat.Text.Contains("1900") = True Then

                    ShowAlert("error", "", "Sila pilih tarikh pengesahan dan tekan simpan surat.")
                    retval = False

                End If

                If TB_NoRujukan.Text.Length = 0 Or Trim(TB_NoRujukan.Text) = "MPK/599/401/" Then

                    ShowAlert("error", "", "Sila isi no rujukan dan tekan simpan surat.")
                    retval = False

                End If

                If ddlTandatangan.SelectedIndex = 0 Then

                    ShowAlert("error", "", "Sila pilih tandatangan dan tekan simpan surat.")
                    retval = False

                End If

            End If

        End If

        Return retval
    End Function

    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs)

        Dim agensiType As String = If(IsDBNull(GridView1.SelectedDataKey.Values(3)), "J", GridView1.SelectedDataKey.Values(3))
        'Dim isSuccess As Boolean = checkMandatoryField()

        If agensiType <> "J" Then
            processSubmit()
        Else
            If checkMandatoryField() Then
                processSubmit()
            End If
        End If



    End Sub

    Private Sub processSubmit()
        If True Then

            Dim Permohonan_ID As Integer = CInt(GridView1.SelectedDataKey.Values(0))
            Dim AgensiID As Integer = If(IsDBNull(GridView1.SelectedDataKey.Values(1)), 0, CInt(GridView1.SelectedDataKey.Values(1)))
            Dim ApprStatusID As Integer = CInt(GridView1.SelectedDataKey.Values(2))

            Dim ddlSokongUlasan As DropDownList = DirectCast(fvSokongUlasan.FindControl("ddlSokongUlasan"), DropDownList)
            Dim txtNotaUlasan As TextBox = DirectCast(fvSokongUlasan.FindControl("txtNotaUlasan"), TextBox)
            Dim ddlPengesahSokongUlasan As DropDownList = DirectCast(fvSokongUlasan.FindControl("ddlPengesahSokongUlasan"), DropDownList)
            Dim txtPengesahNotaKelulusan As TextBox = DirectCast(fvSokongUlasan.FindControl("txtPengesahNotaKelulusan"), TextBox)
            Dim ikAssignCheck As Boolean = True

            Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

                Dim SQL As String = ""

                '2  Pilih Pegawai Lawatan Tapak Jabatan/Agensi
                '3  Lawatan Tapak Jabatan/Agensi
                '4	Pengesah Jabatan/Agensi
                '5	Pengesah Jabatan Lesen

                If AgensiID > 0 Then

                    Dim fldName As String = "IsLawatanTapakUlasan"
                    If ApprStatusID = 2 Then
                        fldName = "StatusID"

                        SQL = "UPDATE LESEN_PermohonanAgensi set " & fldName & " = 3, LastModDt = getdate(), ikAssign = @PengesahID /*,PengesahID = @PengesahID */ 
					where Permohonan_ID = @Permohonan_ID 
					and case when JabatanAgensi_ID is null then 0 else JabatanAgensi_ID end = @AgensiId "

                        ikAssignCheck = getikAssignCheck(Permohonan_ID)

                    ElseIf ApprStatusID = 3 Then
                        fldName = "IsLawatanTapakUlasan"

                        SQL = "UPDATE LESEN_PermohonanAgensi set " & fldName & " = 1, LastModDt = getdate() 
					where Permohonan_ID = @Permohonan_ID 
					and case when JabatanAgensi_ID is null then 0 else JabatanAgensi_ID end = @AgensiId "

                    ElseIf ApprStatusID = 4 Then
                        fldName = "IsPenilaian"

                        SQL = "UPDATE LESEN_PermohonanAgensi set " & fldName & " = 1, LastModDt = getdate(), 
					PengesahStatusID = @PengesahStatusID, PengesahNotaKelulusan = @PengesahNotaKelulusan,
					PengesahID = @PengesahID
					where Permohonan_ID = @Permohonan_ID 
					and case when JabatanAgensi_ID is null then 0 else JabatanAgensi_ID end = @AgensiId "

                        Try
                            Dim hdnFiedlJabatanAgensiType As HiddenField = DirectCast(fvSokongUlasan.FindControl("hdnFiedlJabatanAgensiType"), HiddenField)

                            If hdnFiedlJabatanAgensiType.Value = "L" Then
                                SQL = SQL & ";UPDATE LESEN_PermohonanAgensi set " & fldName & " = 1, LastModDt = getdate(),
								StatusID = @PengesahStatusID, NotaKelulusan = @PengesahNotaKelulusan
								where Permohonan_ID = @Permohonan_ID 
								and case when JabatanAgensi_ID is null then 0 else JabatanAgensi_ID end = @AgensiId "
                            End If
                        Catch ex As Exception

                        End Try


                    ElseIf ApprStatusID = 5 Then
                        fldName = "IsPeraku"

                        SQL = "UPDATE LESEN_PermohonanAgensi set " & fldName & " = 1, LastModDt = getdate(),
					StatusID = @StatusID, NotaKelulusan = @NotaKelulusan
					where Permohonan_ID = @Permohonan_ID 
					and case when JabatanAgensi_ID is null then 0 else JabatanAgensi_ID end = @AgensiId "

                    End If

                Else

                End If

                Dim myCommand As New SqlCommand(SQL, myConnection)

                myCommand.Parameters.AddWithValue("@Permohonan_ID", Permohonan_ID)
                myCommand.Parameters.AddWithValue("@AgensiId", AgensiID)
                myCommand.Parameters.AddWithValue("@ApprStatusID", ApprStatusID)
                myCommand.Parameters.AddWithValue("@SessionUserName", Session.Item("SessionUserName"))
                myCommand.Parameters.AddWithValue("@StatusID", ddlSokongUlasan.SelectedValue)
                myCommand.Parameters.AddWithValue("@NotaKelulusan", txtNotaUlasan.Text)
                myCommand.Parameters.AddWithValue("@PengesahStatusID", ddlPengesahSokongUlasan.SelectedValue)
                myCommand.Parameters.AddWithValue("@PengesahNotaKelulusan", txtPengesahNotaKelulusan.Text)
                myCommand.Parameters.AddWithValue("@PengesahID", Session.Item("sessionUsersId"))

                If ikAssignCheck = True Then

                    myConnection.Open()

                    Dim recordset As Integer = myCommand.ExecuteNonQuery()

                    '//start insert

                    If recordset Then
                        ShowAlert("success", "", "Rekod berjaya dihantar")
                        GridView1.DataBind()
                        backToList()
                    End If

                    myConnection.Close()

                Else
                    ShowAlert("error", "", "Sila Pilih Staff")

                End If

            End Using

        End If
    End Sub

    Private Function getikAssignCheck(permohonan_ID As Integer) As Boolean
        Dim retval As Boolean = False

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Dim Sql As String = "select * from 
            LESEN_PermohonanAgensi a
            inner join LESEN_PermohonanAgensiStaff b on b.PermohonanAgensi_ID = a.PermohonanAgensi_ID
            where a.Permohonan_ID=@Permohonan_ID"

            Dim myCommand As New SqlCommand(Sql, myConnection)

            myCommand.Parameters.AddWithValue("@Permohonan_ID", permohonan_ID)

            myConnection.Open()

            Dim myReader As SqlDataReader = myCommand.ExecuteReader

            If myReader.Read Then
                retval = True
            End If
            '//start insert

            myConnection.Close()

        End Using

        Return retval
    End Function

    Protected Sub btnApprove_Click(sender As Object, e As EventArgs)

        Dim Permohonan_ID As Integer = CInt(GridView1.SelectedDataKey.Values(0))
        Dim AgensiID As Integer = If(IsDBNull(GridView1.SelectedDataKey.Values(1)), 0, CInt(GridView1.SelectedDataKey.Values(1)))
        Dim ApprStatusID As Integer = CInt(GridView1.SelectedDataKey.Values(2))
        Dim txtNotaKelulusanPengesah As TextBox = DirectCast(fvNotaKelulusan.FindControl("txtNotaKelulusanPengesah"), TextBox)
        Dim txtNotaKelulusan As TextBox = DirectCast(fvNotaKelulusan.FindControl("txtNotaKelulusan"), TextBox)
        Dim rblNotaKelulusanKJ As RadioButtonList = DirectCast(fvNotaKelulusan.FindControl("rblNotaKelulusanKJ"), RadioButtonList)

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Dim SQL As String = ""

            '2  mohon ulasan
            '3  Penilaian Jabatan/Agensi
            '4	Peraku Jabatan/Agensi
            '5	Penilaian Jabatan Lesen
            '8	Peraku Jabatan Lesen

            Dim statusUpdate As Integer = 7

            If ApprStatusID = 5 Then
                statusUpdate = 8
            ElseIf ApprStatusID = 8 Then
                statusUpdate = 10
            End If

            If AgensiID = 0 Then
                If ApprStatusID = 5 Then
                    SQL = "UPDATE LESEN_Permohonan set StatusID = " & statusUpdate & ", StatusIDPengesah = 1, LastModDt = getdate(), 
                LastModID = @SessionUserName ,NotaKelulusanPengesah = @NotaKelulusanPengesah
                where Permohonan_ID = @Permohonan_ID "
                ElseIf ApprStatusID = 8 Then
                    SQL = "UPDATE LESEN_Permohonan set StatusID = " & statusUpdate & ", LastModDt = getdate(), 
                LastModID = @SessionUserName ,NotaKelulusan = @NotaKelulusan, NotaKelulusanKJ = @NotaKelulusanKJ
                where Permohonan_ID = @Permohonan_ID "
                End If

            End If

            Dim myCommand As New SqlCommand(SQL, myConnection)

            myCommand.Parameters.AddWithValue("@Permohonan_ID", Permohonan_ID)
            myCommand.Parameters.AddWithValue("@AgensiId", AgensiID)
            myCommand.Parameters.AddWithValue("@ApprStatusID", ApprStatusID)
            myCommand.Parameters.AddWithValue("@SessionUserName", Session.Item("SessionUserName"))
            myCommand.Parameters.AddWithValue("@NotaKelulusanPengesah", txtNotaKelulusanPengesah.Text)
            myCommand.Parameters.AddWithValue("@NotaKelulusan", txtNotaKelulusan.Text)
            myCommand.Parameters.AddWithValue("@NotaKelulusanKJ", rblNotaKelulusanKJ.SelectedValue)

            myConnection.Open()

            Dim recordset As Integer = myCommand.ExecuteNonQuery()

            If recordset Then
                ShowAlert("success", "", "Rekod berjaya dihantar")
            End If
            '//start insert

            myConnection.Close()

        End Using

        GridView1.DataBind()
        backToList()

    End Sub

    Protected Sub btnReject_Click(sender As Object, e As EventArgs)

        Dim Permohonan_ID As Integer = CInt(GridView1.SelectedDataKey.Values(0))
        Dim AgensiID As Integer = If(IsDBNull(GridView1.SelectedDataKey.Values(1)), 0, CInt(GridView1.SelectedDataKey.Values(1)))
        Dim ApprStatusID As Integer = CInt(GridView1.SelectedDataKey.Values(2))
        Dim txtNotaKelulusanPengesah As TextBox = DirectCast(fvNotaKelulusan.FindControl("txtNotaKelulusanPengesah"), TextBox)
        Dim txtNotaKelulusan As TextBox = DirectCast(fvNotaKelulusan.FindControl("txtNotaKelulusan"), TextBox)

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Dim SQL As String = ""

            '2  mohon ulasan
            '3  Penilaian Jabatan/Agensi
            '4	Peraku Jabatan/Agensi
            '5	Penilaian Jabatan Lesen
            '8	Peraku Jabatan Lesen

            Dim statusUpdate As Integer = 7

            If ApprStatusID = 5 Then
                statusUpdate = 6
            ElseIf ApprStatusID = 8 Then
                statusUpdate = 9
            ElseIf ApprStatusID = 10 Then
                statusUpdate = 6
            End If

            If AgensiID = 0 Then

                If ApprStatusID = 5 Then
                    SQL = "UPDATE LESEN_Permohonan set StatusID = " & statusUpdate & ",StatusIDPengesah = 0, 
                    LastModDt = getdate(), LastModID = @SessionUserName ,NotaKelulusanPengesah = @NotaKelulusanPengesah
                where Permohonan_ID = @Permohonan_ID "
                Else
                    SQL = "UPDATE LESEN_Permohonan set StatusID = " & statusUpdate & ", LastModDt = getdate(), 
                LastModID = @SessionUserName ,NotaKelulusan = @NotaKelulusan
                where Permohonan_ID = @Permohonan_ID "
                End If

            End If

            Dim myCommand As New SqlCommand(SQL, myConnection)

            myCommand.Parameters.AddWithValue("@Permohonan_ID", Permohonan_ID)
            myCommand.Parameters.AddWithValue("@AgensiId", AgensiID)
            myCommand.Parameters.AddWithValue("@ApprStatusID", ApprStatusID)
            myCommand.Parameters.AddWithValue("@SessionUserName", Session.Item("SessionUserName"))
            myCommand.Parameters.AddWithValue("@NotaKelulusanPengesah", txtNotaKelulusanPengesah.Text)
            myCommand.Parameters.AddWithValue("@NotaKelulusan", txtNotaKelulusan.Text)

            myConnection.Open()

            Dim recordset As Integer = myCommand.ExecuteNonQuery()

            If recordset Then
                ShowAlert("success", "", "Rekod berjaya dihantar")
            End If
            '//start insert

            myConnection.Close()

        End Using

        GridView1.DataBind()
        backToList()

    End Sub

    Protected Sub btnAddNewPenjaja_Click(sender As Object, e As EventArgs)
        Dim Permohonan_ID As Integer = CInt(GridView1.SelectedDataKey.Values(0))
        Dim IsSokong As Integer = 0

        If EditorSurat1.Text.ToLower().Contains("tiada halangan") Then

            IsSokong = 1

        End If

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Dim SQL As String = ""

            SQL = "Insert Into LESEN_PenjajaUlasan (PermohonanID, CreatedDt, CreatorID) Values 
                 (@Permohonan_ID, getdate(), @SessionUserName) "

            Dim myCommand As New SqlCommand(SQL, myConnection)

            myCommand.Parameters.AddWithValue("@Permohonan_ID", Permohonan_ID)
            myCommand.Parameters.AddWithValue("@SessionUsersId", Session.Item("SessionUsersId"))
            myCommand.Parameters.AddWithValue("@SessionUserName", Session.Item("SessionUserName"))

            myConnection.Open()

            Dim recordset As Integer = myCommand.ExecuteNonQuery()

            If recordset Then
                gvTabPenjajaUlasan.EditIndex = CInt(gvTabPenjajaUlasan.Rows.Count)

            End If

            myConnection.Close()

            gvTabPenjajaUlasan.DataBind()

            Page.SetFocus(Me.ui_btnPageBottom.ClientID)

        End Using
    End Sub



    Protected Sub btnAddNew_Click(sender As Object, e As EventArgs)
        Dim Permohonan_ID As Integer = CInt(GridView1.SelectedDataKey.Values(0))
        Dim AgensiID As Integer = If(IsDBNull(GridView1.SelectedDataKey.Values(1)), 0, CInt(GridView1.SelectedDataKey.Values(1)))
        Dim ApprStatusID As Integer = CInt(GridView1.SelectedDataKey.Values(2))

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Dim SQL As String = ""

            SQL = "Insert Into LESEN_KadarBayaran (KadarBayaran_PermohonanID,KadarBayaran_PermohonanAgensiID,KadarBayaran_UserID,CreatedDt,CreatorID) Values 
                 (@Permohonan_ID,case when @AgensiId = 0 then NULL else @AgensiId end,@SessionUsersID, getdate(), @SessionUserName)  "

            Dim myCommand As New SqlCommand(SQL, myConnection)

            myCommand.Parameters.AddWithValue("@Permohonan_ID", Permohonan_ID)
            myCommand.Parameters.AddWithValue("@AgensiId", CInt(Session.Item("sessionEstateID")))
            myCommand.Parameters.AddWithValue("@ApprStatusID", ApprStatusID)
            myCommand.Parameters.AddWithValue("@SessionUsersId", Session.Item("SessionUsersId"))
            myCommand.Parameters.AddWithValue("@SessionUserName", Session.Item("SessionUserName"))

            myConnection.Open()

            Dim recordset As Integer = myCommand.ExecuteNonQuery()

            '//start insert - tab bayaran

            If recordset Then
                gvTabBayaran.EditIndex = CInt(gvTabBayaran.Rows.Count)

            End If

            myConnection.Close()

            gvTabBayaran.DataBind()

            Page.SetFocus(Me.ui_btnPageBottom.ClientID)

        End Using
    End Sub

    Protected Sub btnAddNewUpload_Click(sender As Object, e As EventArgs)
        Dim Permohonan_ID As Integer = CInt(GridView1.SelectedDataKey.Values(0))
        Dim AgensiID As Integer = If(IsDBNull(GridView1.SelectedDataKey.Values(1)), 0, CInt(GridView1.SelectedDataKey.Values(1)))
        Dim ApprStatusID As Integer = CInt(GridView1.SelectedDataKey.Values(2))

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Dim SQL As String = ""

            SQL = "Insert Into LESEN_UlasanFail (UlasanFail_PermohonanID,UlasanFail_PermohonanAgensiID,UlasanFail_UserID,CreatedDt,CreatorID) Values 
                 (@Permohonan_ID,case when @AgensiId = 0 then NULL else @AgensiId end,@SessionUsersID, getdate(), @SessionUserName)  "

            Dim myCommand As New SqlCommand(SQL, myConnection)

            myCommand.Parameters.AddWithValue("@Permohonan_ID", Permohonan_ID)
            myCommand.Parameters.AddWithValue("@AgensiId", CInt(Session.Item("sessionEstateID")))
            myCommand.Parameters.AddWithValue("@ApprStatusID", ApprStatusID)
            myCommand.Parameters.AddWithValue("@SessionUsersId", Session.Item("SessionUsersId"))
            myCommand.Parameters.AddWithValue("@SessionUserName", Session.Item("SessionUserName"))

            myConnection.Open()

            Dim recordset As Integer = myCommand.ExecuteNonQuery()

            '//start insert

            If recordset Then
                gvTabUlasan.EditIndex = CInt(gvTabUlasan.Rows.Count)

            End If

            myConnection.Close()

            gvTabUlasan.DataBind()

            Page.SetFocus(Me.ui_btnPageBottom.ClientID)

        End Using
    End Sub

    Private Sub gvTabUlasan_RowUpdated(sender As Object, e As GridViewUpdatedEventArgs) Handles gvTabUlasan.RowUpdated
        '//
    End Sub
    Private Sub gvTabUlasan_RowUpdating(sender As Object, e As GridViewUpdateEventArgs) Handles gvTabUlasan.RowUpdating
        Dim LinkButton1 As LinkButton
        Dim btnUpload As Button
        Dim txtUlasanFail_FilePath As FileUpload
        If Request.Browser.IsMobileDevice Then
            LinkButton1 = CType(gvTabUlasan.Rows(e.RowIndex).FindControl("LinkButton1Mobile"), LinkButton)
            btnUpload = CType(gvTabUlasan.Rows(e.RowIndex).FindControl("btnUploadMobile"), Button)
            txtUlasanFail_FilePath = CType(gvTabUlasan.Rows(e.RowIndex).FindControl("txtUlasanFail_FilePathMobile"), FileUpload)
        Else
            LinkButton1 = CType(gvTabUlasan.Rows(e.RowIndex).FindControl("LinkButton1"), LinkButton)
            btnUpload = CType(gvTabUlasan.Rows(e.RowIndex).FindControl("btnUpload"), Button)
            txtUlasanFail_FilePath = CType(gvTabUlasan.Rows(e.RowIndex).FindControl("txtUlasanFail_FilePath"), FileUpload)
        End If

        Dim updatePanelUlasan As UpdatePanel = CType(gvTabUlasan.Rows(e.RowIndex).FindControl("updatePanelUlasan"), UpdatePanel)
        Dim uid As Guid = Guid.NewGuid()
        Dim fn As String = System.IO.Path.GetFileName(txtUlasanFail_FilePath.PostedFile.FileName)

        Dim localPath As String = "~/doc/" & "" & uid.ToString & fn
        Dim SaveLocation As String = Server.MapPath(localPath)

        If (txtUlasanFail_FilePath.PostedFile IsNot Nothing) AndAlso (txtUlasanFail_FilePath.PostedFile.ContentLength > 0) Then

            '//delete previous file
            If e.OldValues("UlasanFail_FilePath") <> "" Then

                Dim deleteFilePath As String = Server.MapPath(e.OldValues("UlasanFail_FilePath"))

                If System.IO.File.Exists(deleteFilePath) Then
                    System.IO.File.Delete(deleteFilePath)
                End If

            End If

            If updateUploadFile(txtUlasanFail_FilePath, SaveLocation) Then

                e.NewValues("UlasanFail_FileName") = txtUlasanFail_FilePath.PostedFile.FileName
                e.NewValues("UlasanFail_ContentType") = txtUlasanFail_FilePath.PostedFile.ContentType
                e.NewValues("UlasanFail_FilePath") = localPath

            Else

            End If


        Else

            'e.NewValues("UlasanFail_FileName") = e.OldValues("UlasanFail_FileName")
            'e.NewValues("UlasanFail_ContentType") = e.OldValues("UlasanFail_ContentType")
            'e.NewValues("UlasanFail_FilePath") = e.OldValues("UlasanFail_FilePath")
        End If



    End Sub


    Private Function updateUploadFile(txtUlasanFail_FilePath As FileUpload, saveLocation As String) As Boolean
        'lblDummy.Text = saveLocation
        Dim retval As Boolean = True

        If (txtUlasanFail_FilePath.PostedFile IsNot Nothing) AndAlso (txtUlasanFail_FilePath.PostedFile.ContentLength > 0) Then

            Try
                Dim fileExtention As String = txtUlasanFail_FilePath.PostedFile.ContentType
                Dim fileLenght As Integer = txtUlasanFail_FilePath.PostedFile.ContentLength

                If fileExtention = "image/jpeg" OrElse fileExtention = "image/x-png" Then 'fileExtention = "image/png"

                    '//image
                    If fileLenght <= (1048576 * 10) Then '1048576 => 1M
                        Dim bmpPostedImage As System.Drawing.Bitmap = New System.Drawing.Bitmap(txtUlasanFail_FilePath.PostedFile.InputStream)
                        Dim fixedImage As Image = FixImageOrientation(bmpPostedImage)
                        Dim objImage As System.Drawing.Image = ScaleImage(fixedImage, 1024)
                        objImage.Save(saveLocation, ImageFormat.Jpeg)

                        'MessageBox("Fail berjaya dimuatnaik", Me)
                        ShowAlert("success", "", "Fail berjaya dimuatnaik")
                    Else
                        'MessageBox("Image size cannot be more then 5 MB!", Me)
                        ShowAlert("error", "", "Saiz imej tidak boleh melebihi 10MB!")
                        retval = False
                    End If
                Else

                    If fileExtention = "application/pdf" Then

                        '//not image
                        If fileLenght <= (1048576 * 10) Then '1048576 => 1M
                            'Dim bmpPostedImage As System.Drawing.Bitmap = New System.Drawing.Bitmap(txtUlasanFail_FilePath.PostedFile.InputStream)
                            'Dim objImage As System.Drawing.Image = ScaleImage(bmpPostedImage, 1024)
                            'objImage.Save(SaveLocation, ImageFormat.Jpeg)

                            Try
                                txtUlasanFail_FilePath.PostedFile.SaveAs(saveLocation)
                            Catch ex As Exception
                                MessageBox(ex.Message, Me)
                            End Try


                            'MessageBox("Fail berjaya dimuatnaik", Me)
                            ShowAlert("success", "", "Fail berjaya dimuatnaik")

                        Else
                            'MessageBox("Image size cannot be more then 5 MB!", Me)
                            ShowAlert("error", "", "Saiz fail tidak boleh melebihi 10MB!")
                            retval = False
                        End If

                    Else
                        'MessageBox("Format Fail PDF Sahaja!", Me)
                        ShowAlert("error", "", "Format Fail PDF Sahaja!")
                        retval = False
                    End If


                End If

            Catch ex As Exception
                MessageBox(ex.Message, Me)
                retval = False
                'lblmsg.Text = "Error: " & ex.Message
                'lblmsg.Style.Add("Color", "Red")
            End Try
        Else
            MessageBox("Muat naik fail gagal. Sila cuba sekali lagi", Me)
            retval = False
        End If

        Return retval
    End Function
    Public Shared Function FixImageOrientation(img As Image) As Image
        Const OrientationKey As Integer = &H112
        If img.PropertyIdList.Contains(OrientationKey) Then
            Dim prop = img.GetPropertyItem(OrientationKey)
            Dim orientation As Integer = BitConverter.ToUInt16(prop.Value, 0)

            Select Case orientation
                ' Case 3
                    ' img.RotateFlip(RotateFlipType.Rotate180FlipNone)
                ' Case 6
                    ' img.RotateFlip(RotateFlipType.Rotate90FlipNone)
                ' Case 8
                    ' img.RotateFlip(RotateFlipType.Rotate270FlipNone)
                Case 0, 1
                    ' No rotation required.
                Case 2
                    img.RotateFlip(RotateFlipType.RotateNoneFlipX)
                Case 3
                    img.RotateFlip(RotateFlipType.Rotate180FlipNone)
                Case 4
                    img.RotateFlip(RotateFlipType.Rotate180FlipX)
                Case 5
                    img.RotateFlip(RotateFlipType.Rotate90FlipX)
                Case 6
                    img.RotateFlip(RotateFlipType.Rotate90FlipNone)
                Case 7
                    img.RotateFlip(RotateFlipType.Rotate270FlipX)
                Case 8
                    img.RotateFlip(RotateFlipType.Rotate270FlipNone)
            End Select

            ' buang metadata supaya tak kacau lagi
            img.RemovePropertyItem(OrientationKey)
        End If
        Return img
    End Function

    Public Sub MessageBox(ByVal Msg As String, ByVal obj As System.Web.UI.Page)
        Dim jscript As String
        Dim x = "OURServices"
        ScriptManager.RegisterClientScriptBlock(Me.Page, Me.[GetType](), "Alert", "alert('" & Msg & "');", True)
    End Sub

    Public Property OriginalImageSize As Size
    Public Property NewImageSize As Size

    Public Shared Function ScaleImage(ByVal image As System.Drawing.Image, ByVal maxHeight As Integer) As System.Drawing.Image
        Dim ratio = CDbl(maxHeight) / image.Height
        Dim newWidth = CInt((image.Width * ratio))
        Dim newHeight = CInt((image.Height * ratio))
        Dim newImage = New Bitmap(newWidth, newHeight)

        Using g = Graphics.FromImage(newImage)
            g.DrawImage(image, 0, 0, newWidth, newHeight)
        End Using

        Return newImage
    End Function
    Protected Sub btnUpload_Click(sender As Object, e As EventArgs)

        Dim btn As Button = CType(sender, Button)
        Dim row As GridViewRow = CType(btn.NamingContainer, GridViewRow)

        'Dim btnUpload As Button = CType(row.FindControl("btnUpload"), Button)
        'Dim currPageScriptManager As ScriptManager = TryCast(ScriptManager.GetCurrent(Page), ScriptManager)

        'currPageScriptManager.RegisterAsyncPostBackControl(btnUpload)


        'Dim txtUlasanFail_FilePath As FileUpload = CType(row.FindControl("txtUlasanFail_FilePath"), FileUpload)
        'updateUploadFile(txtUlasanFail_FilePath)
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

                'RegisterAsyncPostBackControl
                'currPageScriptManager.RegisterPostBackControl(btnUpload)
                currPageScriptManager.RegisterPostBackControl(LinkButton1)

            End If
        End If


    End Sub

    Private Sub gvTabUlasan_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvTabUlasan.RowDeleting


        If e.Values("UlasanFail_FilePath") <> "" Then

            Dim deleteFilePath As String = Server.MapPath(e.Values("UlasanFail_FilePath"))

            If System.IO.File.Exists(deleteFilePath) Then
                System.IO.File.Delete(deleteFilePath)
            End If


        End If

    End Sub

    Private Sub gvTabUlasan_DataBound(sender As Object, e As EventArgs) Handles gvTabUlasan.DataBound

    End Sub

    Private Sub GridView1_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles GridView1.RowCommand

        If e.CommandName = "Surat" Then
            Dim intRow As Integer = CInt(e.CommandArgument)
            Dim Permohonan_ID As String = CStr(Me.GridView1.DataKeys(intRow)("Permohonan_ID"))
            'Dim AgensiID As String = CStr(Me.GridView1.DataKeys(intRow)("AgensiID"))
            Dim AgensiID As String = If(IsDBNull(Me.GridView1.DataKeys(intRow)("AgensiID")), Session.Item("sessionOCS"), CStr(Me.GridView1.DataKeys(intRow)("AgensiID")))
            Dim JenisLesenIdList As String = CStr(Me.GridView1.DataKeys(intRow)("JenisLesenIdList"))

            ViewSuratMohon(Permohonan_ID, AgensiID, JenisLesenIdList)

        End If

    End Sub

    Private Sub ViewSuratMohon(permohonanID As String, agensiID As String, JenisLesenIdList As String)
        Dim sql As String = ""
        Dim jenisLesenDesc = {"mpk_suratmohonulasan", "mpk_suratmohonulasan_psr", "mpk_suratmohonulasan_anj", "mpk_suratmohonulasan_pjj", "mpk_suratmohonulasan_bb"}
        Dim jenisLesenDescLuar = {"mpk_suratmohonulasan_l", "mpk_suratmohonulasan_psr_l", "mpk_suratmohonulasan_anj_l", "mpk_suratmohonulasan_pjj_l", "mpk_suratmohonulasan_bb_l"}

        Try
            sql = "SELECT a.Permohonan_ID, a.TarikhMohon, a.CreatedDt, CAST(a.NamaSyarikat AS varchar(200)) AS NamaSyarikat, a.NoPendaftaran, a.NoAkaun, a.AlamatPremis, a.JenisPerniagaan, a.PemilikBaru, " &
            "a.AlamatBaru, a.JenisPerniagaanBaru, a.NamaBaruSyarikat, a.BillboardLokasi, a.LokasiPasar1, a.LokasiPasar2, a.LokasiPasar3, a.JenisPasar, a.JenisPerniagaanPasar, a.JumlahPetak, a.AnjingAlamat, " &
            "a.AnjingJenisMohon, a.AnjingJenisPremis, a.AlamatPenjajaan, a.JenisPerniagaanPenjaja, a.TarikhBatal, a.PenganjurEkspo, a.NamaEkspo, a.LokasiEkspo, a.NoTelEkspo, a.TarikhEkspo1, a.TarikhEkspo2, " &
            "a.KontraktorIklan, a.NoTelKontraktor, a.UkuranBanting, a.BilBanting, a.TarikhBanting1, a.TarikhBanting2, a.NoResitBanting, a.NoSiriStiker, a.TarikhBanting3, " &
            "a.MasaEkspo1, a.MasaEkspo2, a.Rujukan, a.NoAkaunCukai, a.IsBatal, a.JenisLesenDescList, a.JenisLesenIdList, a.SaizIklanList, a.CahayaIklanList, a.UnitIklanList, a.LokasiList, a.BakaAnjingList, a.AnjingJantanList, " &
            "a.AnjingBetinaList, a.AnjingJantanMandulList, a.AnjingBetinaMandulList, e.JabatanAgensi_Address, e.JabatanAgensi_Kepada, b.Pemohon_Name, b.Pemohon_ICNo, b.Pemohon_PassportNo, b.Pemohon_Address, " &
            "b.Pemohon_Email, b.Pemohon_MobileNo, b.Pemohon_TelNo, g.Users_Fullname, g.Users_Signature " &
            "FROM LESEN_Permohonan a INNER JOIN LESEN_Pemohon b ON a.Permohonan_PemohonID = b.Pemohon_ID INNER JOIN LESEN_PermohonanAgensi d ON a.Permohonan_ID = d.Permohonan_ID " &
            "INNER JOIN LESEN_JabatanAgensi e ON d.JabatanAgensi_ID = e.JabatanAgensi_ID " &
            "LEFT JOIN TBL_USERS g ON g.Users_Id = (case when e.JabatanAgensi_Type = 'J' then a.TandatanganMohonUlasanId when e.JabatanAgensi_Type = 'L' then a.TandatanganMohonUlasanLuarId end) " &
            "WHERE a.Permohonan_ID=" & permohonanID & " AND e.JabatanAgensi_ID = " & agensiID

            Dim ReportVar As String = jenisLesenDesc(0)

            Select Case JenisLesenIdList
                Case "2", "25"
                    ReportVar = jenisLesenDesc(1)
                Case "3"
                    ReportVar = jenisLesenDesc(2)
                Case "4"
                    ReportVar = jenisLesenDesc(3)
                Case "5"
                    ReportVar = jenisLesenDesc(4)
            End Select

            If CInt(agensiID) > 3 Then

                ReportVar = jenisLesenDescLuar(0)

                Select Case JenisLesenIdList
                    Case "2", "25"
                        ReportVar = jenisLesenDescLuar(1)
                    Case "3"
                        ReportVar = jenisLesenDescLuar(2)
                    Case "4"
                        ReportVar = jenisLesenDescLuar(3)
                    Case "5"
                        ReportVar = jenisLesenDescLuar(4)
                End Select

            End If

            Dim pobjData(0, 1)
            Dim lStrReportName = ReportVar + ".rpt"

            'Dim sessionActiveMonthYearID As String = GlobalClass.getIDActiveMonthByEstateID(Session.Item("sessionEstateCode"), DirectCast(FormView1.FindControl("cmbYear"), DropDownList).SelectedValue, DirectCast(FormView1.FindControl("cmbMonth"), DropDownList).SelectedValue)

            pobjData(0, 0) = "paraSQL" : pobjData(0, 1) = sql

            Session.Item("ReportName" + ReportVar) = lStrReportName
            Session.Item("pobjData" + ReportVar) = pobjData
            Session.Item("pathUrl" + ReportVar) = "~/lesen/report/mohonulasan"
            'MessageBox(Session.Item("pathUrl" + ReportVar), Me)


            Session.Item("reportPrintType") = "pdf"
            ScriptManager.RegisterClientScriptBlock(Me.Page, Me.[GetType](), ReportVar, "window.open('../ReportViewer.aspx?name=" + ReportVar + "', '_blank', '');", True)
        Catch ex As Exception
            MessageBox(ex.Message, Me)
        End Try
    End Sub



    Protected Sub CheckBox1_CheckedChanged(sender As Object, e As EventArgs)

        Try
            Dim Permohonan_ID As Integer = GridView1.SelectedDataKey.Values(0)
            Dim AgensiID As Integer = GridView1.SelectedDataKey.Values(1)

            Dim row As GridViewRow = (CType((CType(sender, CheckBox)).NamingContainer, GridViewRow))
            Dim index As Integer = row.RowIndex
            Dim cb1 As CheckBox = CType(gvIK.Rows(index).FindControl("cbSelect"), CheckBox)
            Dim hdID As HiddenField = CType(gvIK.Rows(index).FindControl("hdID"), HiddenField)

            Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

                Dim SQL As String = ""

                If cb1.Checked Then
                    SQL = "insert into LESEN_PermohonanAgensiStaff (PermohonanAgensiStaffID_UsersID,PermohonanAgensi_ID)
							select top 1 @usersID, a.PermohonanAgensi_ID from LESEN_PermohonanAgensi a 
							where a.Permohonan_ID = @Permohonan_ID and a.JabatanAgensi_ID = @AgensiId "
                Else
                    SQL = "delete a
					from LESEN_PermohonanAgensiStaff a
					where a.PermohonanAgensiStaffID_UsersID = @usersID
					and PermohonanAgensi_ID IN (select x.PermohonanAgensi_ID from LESEN_PermohonanAgensi x where x.Permohonan_ID=@Permohonan_ID 
					and x.JabatanAgensi_ID=@AgensiId) "
                End If


                Dim myCommand As New SqlCommand(SQL, myConnection)

                myCommand.Parameters.AddWithValue("@Permohonan_ID", Permohonan_ID)
                myCommand.Parameters.AddWithValue("@AgensiId", AgensiID)
                myCommand.Parameters.AddWithValue("@usersID", CInt(hdID.Value))

                myConnection.Open()

                Dim recordset As Integer = myCommand.ExecuteNonQuery()

                '//start execute

                If recordset Then
                    gvTabUlasan.EditIndex = CInt(gvTabUlasan.Rows.Count)

                End If

                myConnection.Close()

            End Using

        Catch ex As Exception
            MessageBox(ex.Message, Me)
        End Try

    End Sub

    Private Function GetIsSuratFail(pid As Integer) As Boolean

        Dim isFail As Boolean

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQL As String = "SELECT IsSuratPemeriksaanFail FROM LESEN_Permohonan WHERE Permohonan_ID = @Permohonan_ID"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            Try
                If myReader.Read Then

                    isFail = CBool(myReader.Item("IsSuratPemeriksaanFail"))

                End If

            Catch ex As Exception
                MessageBox("ERROR", Me)
            End Try

            myReader.Close()
            myConnection.Close()

        End Using

        Return isFail

    End Function

    Protected Sub BT_ViewMail_Command(sender As Object, e As CommandEventArgs)

        Dim jid As Integer = CInt(Me.FormView1.DataKey("JenisLesen_ID"))
        Dim pid As Integer = GridView1.SelectedDataKey.Values(0)

        If GetIsSuratFail(pid) Then
            ViewSuratPemeriksaanFail(pid)
        Else
            If Session.Item("isDisablePrintSession") = "Y" Then
                ViewSuratPemeriksaanAuto(pid, False)
            Else
                ViewSuratPemeriksaanAuto(pid, True)
            End If

        End If

    End Sub

    Protected Sub BT_Generate_Command(sender As Object, e As CommandEventArgs)

        If TB_TarikhPeriksa.Text.Length = 0 Then

            ShowAlert("error", "", "Sila pilih tarikh pemeriksaan.")
            Return

        End If

        Dim jidList() As String = CStr(GridView1.SelectedDataKey.Values("JenisLesenIdList")).Split(","c)
        Dim jid As String = CStr(GridView1.SelectedDataKey.Values("JenisLesenIdList"))
        Dim pid As Integer = GridView1.SelectedDataKey.Values(0)

        If jid = "4" Then

            If TabPenjajaUlasan.Visible = False Then
                TabPenjajaUlasan.Visible = True
            End If

            insertPenjajaUlasan(pid, 1)

            Return

        End If

        Dim jenisReport As String = "LIL"
        Dim rujukan As String = ""
        Dim tarikhmohon As String = ""
        Dim jenispasar As String = ""
        Dim jumlahpetak As String = ""
        Dim jenisperniagaanpasar As String = ""
        Dim lokasipasar As String = ""
        Dim totalamount As Double = 0

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQL4 As String = "SELECT Rujukan, CONVERT(varchar, TarikhMohon, 103) AS TarikhMohon, JenisPasar, JenisPerniagaanPasar, JumlahPetak, LokasiPasar1, LokasiPasar2, LokasiPasar3 FROM LESEN_Permohonan WHERE Permohonan_ID = @Permohonan_ID"

            Dim myCommandSelect4 As New SqlCommand(SQL4, myConnection)
            myCommandSelect4.Parameters.AddWithValue("@Permohonan_ID", pid)

            Dim myReader4 As SqlDataReader = myCommandSelect4.ExecuteReader

            Try
                If myReader4.Read Then

                    rujukan = myReader4.Item("Rujukan").ToString
                    tarikhmohon = myReader4.Item("TarikhMohon").ToString
                    jenispasar = myReader4.Item("JenisPasar").ToString
                    jenisperniagaanpasar = myReader4.Item("JenisPerniagaanPasar").ToString
                    jumlahpetak = myReader4.Item("JumlahPetak").ToString
                    lokasipasar = myReader4.Item("LokasiPasar1").ToString

                    If myReader4.Item("LokasiPasar2").ToString.Length > 0 Then
                        lokasipasar = lokasipasar & ", " & myReader4.Item("LokasiPasar2").ToString
                    End If

                    If myReader4.Item("LokasiPasar3").ToString.Length > 0 Then
                        lokasipasar = lokasipasar & ", " & myReader4.Item("LokasiPasar3").ToString
                    End If

                End If

            Catch ex As Exception
                MessageBox(ex.Message, Me)
            End Try

            myReader4.Close()
            myConnection.Close()

            myConnection.Open()

            Dim SQL As String = "DELETE FROM LESEN_PermohonanSurat WHERE Permohonan_ID=@Permohonan_ID AND JenisReport=@JenisReport; 
                    INSERT INTO LESEN_PermohonanSurat (Permohonan_ID, JenisReport, P1, P2, P3, IsiKandungan, CreatedDt, ModDt)
                    SELECT @Permohonan_ID AS Permohonan_ID, JenisReport, P1, P2, P3, 
                    REPLACE(
                        REPLACE(
                            REPLACE(
                                REPLACE(
                                    REPLACE(
                                        REPLACE(
                                            REPLACE(
                                                REPLACE(CAST(IsiKandungan AS VARCHAR(MAX)), '{@TahunIni}', @@TahunIni), 
                                            '{@JumlahKadarBayaran}', @@JumlahKadarBayaran), 
                                        '{@Rujukan}', IIF(CHARINDEX(' ', @@Rujukan) > 0, @@Rujukan, REPLACE(@@Rujukan, 'MPK/599/401/', 'MPK/599/401/ ')) ),
                                    '{@TarikhPemeriksaan}',@@TarikhPemeriksaan),
                                '{@JenisPasar}',@@JenisPasar),
                            '{@JenisPerniagaanPasar}',@@JenisPerniagaanPasar),
                        '{@JumlahPetak}',@@JumlahPetak),
                    '{@LokasiPasar}',@@LokasiPasar) AS IsiKandungan, 
                    GETDATE() AS CreatedDt, GETDATE() AS ModDt 
                    FROM LESEN_ReportTemplate
                    WHERE JenisLesen_ID=@JenisLesen_ID AND JenisReport=@JenisReport;"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@JenisLesen_ID", jidList(0))
            myCommandSelect.Parameters.AddWithValue("@JenisReport", jenisReport)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)

            myCommandSelect.Parameters.AddWithValue("@@TahunIni", DateTime.Now.Year.ToString)
            myCommandSelect.Parameters.AddWithValue("@@JumlahKadarBayaran", totalamount.ToString("N2"))
            myCommandSelect.Parameters.AddWithValue("@@Rujukan", rujukan)
            'myCommandSelect.Parameters.AddWithValue("@@TarikhMohon", tarikhmohon)
            myCommandSelect.Parameters.AddWithValue("@@JenisPasar", jenispasar)
            myCommandSelect.Parameters.AddWithValue("@@JenisPerniagaanPasar", jenisperniagaanpasar)
            myCommandSelect.Parameters.AddWithValue("@@JumlahPetak", jumlahpetak)
            myCommandSelect.Parameters.AddWithValue("@@LokasiPasar", lokasipasar)

            Dim cvtDate = CDate(TB_TarikhPeriksa.Text).ToString("dd/MM/yyyy")
            myCommandSelect.Parameters.AddWithValue("@@TarikhPemeriksaan", cvtDate)

            Try
                myCommandSelect.ExecuteNonQuery()
                ShowAlert("success", "", "Laporan pemeriksaan berjaya dijana.")
                GridViewReport.DataBind()
            Catch ex As Exception
                MessageBox(ex.Message, Me)
            End Try

            myConnection.Close()

        End Using

    End Sub

    Protected Sub BT_Generate1_Command(sender As Object, e As CommandEventArgs)

        If TB_TarikhPeriksa.Text.Length = 0 Then

            ShowAlert("error", "", "Sila pilih tarikh pemeriksaan.")
            Return

        End If

        Dim jidList() As String = CStr(GridView1.SelectedDataKey.Values("JenisLesenIdList")).Split(","c)
        Dim jid As String = CStr(GridView1.SelectedDataKey.Values("JenisLesenIdList"))
        Dim pid As Integer = GridView1.SelectedDataKey.Values(0)

        If jid = "4" Then

            If TabPenjajaUlasan.Visible = False Then
                TabPenjajaUlasan.Visible = True
            End If

            insertPenjajaUlasan(pid, 0)

            Return

        End If

        Dim jenisReport As String = "LIB"
        Dim rujukan As String = ""
        Dim tarikhmohon As String = ""
        Dim jenispasar As String = ""
        Dim jumlahpetak As String = ""
        Dim jenisperniagaanpasar As String = ""
        Dim lokasipasar As String = ""
        Dim totalamount As Double = 0

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQL4 As String = "SELECT Rujukan, CONVERT(varchar, TarikhMohon, 103) AS TarikhMohon, JenisPasar, JenisPerniagaanPasar, JumlahPetak, LokasiPasar1, LokasiPasar2, LokasiPasar3 FROM LESEN_Permohonan WHERE Permohonan_ID = @Permohonan_ID"

            Dim myCommandSelect4 As New SqlCommand(SQL4, myConnection)
            myCommandSelect4.Parameters.AddWithValue("@Permohonan_ID", pid)

            Dim myReader4 As SqlDataReader = myCommandSelect4.ExecuteReader

            Try
                If myReader4.Read Then

                    rujukan = myReader4.Item("Rujukan").ToString
                    tarikhmohon = myReader4.Item("TarikhMohon").ToString
                    jenispasar = myReader4.Item("JenisPasar").ToString
                    jenisperniagaanpasar = myReader4.Item("JenisPerniagaanPasar").ToString
                    jumlahpetak = myReader4.Item("JumlahPetak").ToString
                    lokasipasar = myReader4.Item("LokasiPasar1").ToString

                    If myReader4.Item("LokasiPasar2").ToString.Length > 0 Then
                        lokasipasar = lokasipasar & ", " & myReader4.Item("LokasiPasar2").ToString
                    End If

                    If myReader4.Item("LokasiPasar3").ToString.Length > 0 Then
                        lokasipasar = lokasipasar & ", " & myReader4.Item("LokasiPasar3").ToString
                    End If

                End If

            Catch ex As Exception
                MessageBox(ex.Message, Me)
            End Try

            myReader4.Close()
            myConnection.Close()

            myConnection.Open()

            Dim SQL As String = "DELETE FROM LESEN_PermohonanSurat WHERE Permohonan_ID=@Permohonan_ID AND JenisReport=@JenisReport; 
                    INSERT INTO LESEN_PermohonanSurat (Permohonan_ID, JenisReport, P1, P2, P3, IsiKandungan, CreatedDt, ModDt)
                    SELECT @Permohonan_ID AS Permohonan_ID, JenisReport, P1, P2, P3, 
                    REPLACE(
                        REPLACE(
                            REPLACE(
                                REPLACE(
                                    REPLACE(
                                        REPLACE(
                                            REPLACE(
                                                REPLACE(CAST(IsiKandungan AS VARCHAR(MAX)), '{@TahunIni}', @@TahunIni), 
                                            '{@JumlahKadarBayaran}', @@JumlahKadarBayaran), 
                                        '{@Rujukan}', IIF(CHARINDEX(' ', @@Rujukan) > 0, @@Rujukan, REPLACE(@@Rujukan, 'MPK/599/401/', 'MPK/599/401/ ')) ),
                                    '{@TarikhPemeriksaan}',@@TarikhPemeriksaan),
                                '{@JenisPasar}',@@JenisPasar),
                            '{@JenisPerniagaanPasar}',@@JenisPerniagaanPasar),
                        '{@JumlahPetak}',@@JumlahPetak),
                    '{@LokasiPasar}',@@LokasiPasar) AS IsiKandungan, 
                    GETDATE() AS CreatedDt, GETDATE() AS ModDt 
                    FROM LESEN_ReportTemplate
                    WHERE JenisLesen_ID=@JenisLesen_ID AND JenisReport=@JenisReport;"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@JenisLesen_ID", jidList(0))
            myCommandSelect.Parameters.AddWithValue("@JenisReport", jenisReport)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)

            myCommandSelect.Parameters.AddWithValue("@@TahunIni", DateTime.Now.Year.ToString)
            myCommandSelect.Parameters.AddWithValue("@@JumlahKadarBayaran", totalamount.ToString("N2"))
            myCommandSelect.Parameters.AddWithValue("@@Rujukan", rujukan)
            'myCommandSelect.Parameters.AddWithValue("@@TarikhMohon", tarikhmohon)
            myCommandSelect.Parameters.AddWithValue("@@JenisPasar", jenispasar)
            myCommandSelect.Parameters.AddWithValue("@@JenisPerniagaanPasar", jenisperniagaanpasar)
            myCommandSelect.Parameters.AddWithValue("@@JumlahPetak", jumlahpetak)
            myCommandSelect.Parameters.AddWithValue("@@LokasiPasar", lokasipasar)

            Dim cvtDate = CDate(TB_TarikhPeriksa.Text).ToString("dd/MM/yyyy")
            myCommandSelect.Parameters.AddWithValue("@@TarikhPemeriksaan", cvtDate)

            Try
                myCommandSelect.ExecuteNonQuery()
                ShowAlert("success", "", "Laporan pemeriksaan berjaya dijana.")
                GridViewReport.DataBind()
            Catch ex As Exception
                MessageBox(ex.Message, Me)
            End Try

            myConnection.Close()

        End Using

    End Sub

    Protected Sub btnSaveLetter_Click(sender As Object, e As EventArgs)

        If CB_SuratFail.Checked And ((FU_Lampiran1.Visible = True And FU_Lampiran1.HasFile = False) Or
            (HL_Lampiran1.Visible = True And HL_Lampiran1.Text.Length < 1)) Then

            ShowAlert("error", "", "Sila pilih fail surat yang ingin dimuat naik.")
            Return

        End If

        Dim isSuccess As Boolean = True
        Dim PermohonanID As Integer = CInt(GridView1.SelectedDataKey.Values(0))

        'MessageBox(PermohonanID, Me)

        If CB_SuratFail.Checked = False Then

            If TB_TarikhPeriksa.Text.Length = 0 Then

                ShowAlert("error", "", "Sila pilih tarikh pemeriksaan.")
                Return

            End If

            If TB_TarikhSurat.Text.Length = 0 Then

                ShowAlert("error", "", "Sila pilih tarikh surat.")
                Return

            End If

            If TB_NoRujukan.Text.Length = 0 Or Trim(TB_NoRujukan.Text) = "MPK/599/401/" Then

                ShowAlert("error", "", "Sila isi no rujukan.")
                Return

            End If

            If ddlTandatangan.SelectedIndex = 0 Then

                ShowAlert("error", "", "Sila pilih tandatangan.")
                Return

            End If

            Dim cvtDate = CDate(TB_TarikhPeriksa.Text).ToString("dd/MM/yyyy")

            Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

                myConnection.Open()

                Dim SQL As String = "UPDATE LESEN_Permohonan SET TandatanganPemeriksaanId = @TandatanganPemeriksaanId, TarikhPemeriksaan = @TarikhPemeriksaan,
                                    TarikhSuratPemeriksaan = @TarikhSuratPemeriksaan, RujukanInspektorat = @RujukanInspektorat 
                                    WHERE Permohonan_ID = @Permohonan_ID"

                Dim myCommandSelect As New SqlCommand(SQL, myConnection)
                myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", PermohonanID)
                myCommandSelect.Parameters.AddWithValue("@TandatanganPemeriksaanId", ddlTandatangan.SelectedValue)
                myCommandSelect.Parameters.AddWithValue("@TarikhPemeriksaan", TB_TarikhPeriksa.Text)
                myCommandSelect.Parameters.AddWithValue("@TarikhSuratPemeriksaan", TB_TarikhSurat.Text)
                myCommandSelect.Parameters.AddWithValue("@RujukanInspektorat", TB_NoRujukan.Text)

                Try
                    Dim recordset As Integer = myCommandSelect.ExecuteNonQuery()

                Catch ex As Exception
                    isSuccess = False
                    MessageBox("ERROR", Me)

                End Try

                myConnection.Close()

            End Using

        End If

        Dim uid As Guid = Guid.NewGuid()

        If FU_Lampiran1.HasFile Then

            Dim fn As String = System.IO.Path.GetFileName(FU_Lampiran1.PostedFile.FileName)

            Dim localPath As String = "~/doc/" & "" & uid.ToString & fn
            Dim SaveLocation As String = Server.MapPath(localPath)

            If (FU_Lampiran1.PostedFile IsNot Nothing) AndAlso (FU_Lampiran1.PostedFile.ContentLength > 0) Then

                If updateUploadFile(FU_Lampiran1, SaveLocation) Then

                    Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

                        myConnection.Open()

                        Dim SQL As String = "INSERT INTO LESEN_PermohonanFail (PermohonanFail_PermohonanID, PermohonanFail_ContentType, PermohonanFail_FileName, PermohonanFail_FilePath, PermohonanFail_JenisLampiran) 
                        VALUES (@Permohonan_ID, @ContentType, @FileName, @FilePath, 'SP')"

                        Dim myCommandSelect As New SqlCommand(SQL, myConnection)
                        myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", PermohonanID)
                        myCommandSelect.Parameters.AddWithValue("@FileName", FU_Lampiran1.PostedFile.FileName)
                        myCommandSelect.Parameters.AddWithValue("@ContentType", FU_Lampiran1.PostedFile.ContentType)
                        myCommandSelect.Parameters.AddWithValue("@FilePath", localPath)

                        Try
                            Dim recordset As Integer = myCommandSelect.ExecuteNonQuery()
                            GetSuratFail(PermohonanID)
                        Catch ex As Exception
                            isSuccess = False
                            MessageBox("ERROR", Me)
                        End Try

                        myConnection.Close()

                    End Using

                Else

                End If

            Else

            End If
        Else

        End If

        If isSuccess Then

            ShowAlert("success", "", "Surat pemeriksaan telah dikemaskini.")

        End If

    End Sub

    Private Sub GetSuratFail(pid As Integer)

        BT_Cancel1.Visible = False
        HL_Lampiran1.Visible = False
        BT_Update1.Visible = False
        BT_Delete1.Visible = False

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQL As String = "SELECT PermohonanFail_FileName, PermohonanFail_FilePath, PermohonanFail_JenisLampiran FROM LESEN_PermohonanFail WHERE PermohonanFail_JenisLampiran = 'SP' AND PermohonanFail_PermohonanID = @Permohonan_ID"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            Try

                If myReader.Read Then

                    HL_Lampiran1.Text = myReader.Item("PermohonanFail_FileName").ToString
                    HL_Lampiran1.NavigateUrl = myReader.Item("PermohonanFail_FilePath").ToString

                    FU_Lampiran1.Visible = False
                    BT_Cancel1.Visible = False
                    HL_Lampiran1.Visible = True
                    BT_Update1.Visible = True
                    BT_Delete1.Visible = True

                End If

            Catch ex As Exception
                'MessageBox("ERROR", Me)
            End Try

            myReader.Close()
            myConnection.Close()

        End Using
    End Sub

    Private Sub GetSuratContent(pid As Integer)

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQL As String = "SELECT TandatanganPemeriksaanId, TarikhPemeriksaan, TarikhSuratPemeriksaan, RujukanInspektorat FROM LESEN_Permohonan WHERE Permohonan_ID = @Permohonan_ID"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            Try
                If myReader.Read Then

                    If myReader.Item("TandatanganPemeriksaanId").ToString().Length > 0 Then
                        ddlTandatangan.SelectedValue = myReader.Item("TandatanganPemeriksaanId")
                    End If

                    If myReader.Item("RujukanInspektorat").ToString().Length > 0 Then
                        TB_NoRujukan.Text = myReader.Item("RujukanInspektorat")
                    End If

                    If IsDBNull(myReader.Item("TarikhPemeriksaan")) = False Then
                        TB_TarikhPeriksa.Text = CDate(myReader.Item("TarikhPemeriksaan")).ToString("yyyy-MM-dd")
                    End If

                    If IsDBNull(myReader.Item("TarikhSuratPemeriksaan")) = False Then
                        If CDate(myReader.Item("TarikhSuratPemeriksaan")).Year > 1900 Then
                            TB_TarikhSurat.Text = CDate(myReader.Item("TarikhSuratPemeriksaan")).ToString("yyyy-MM-dd")
                        End If
                    End If

                End If

            Catch ex As Exception
                MessageBox("ERROR", Me)
            End Try

            myReader.Close()
            myConnection.Close()

        End Using

    End Sub

    Private Sub ViewSuratPemeriksaanFail(permohonanID As String)

        Dim filepath As String = ""

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQL As String = "SELECT PermohonanFail_FilePath FROM LESEN_PermohonanFail WHERE PermohonanFail_PermohonanID = @permohonanID AND PermohonanFail_JenisLampiran = 'SP'"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@permohonanID", permohonanID)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            Try
                If myReader.Read Then

                    filepath = myReader.Item("PermohonanFail_FilePath")
                    filepath = filepath.Remove(0, 1)
                    ScriptManager.RegisterClientScriptBlock(Me.Page, Me.[GetType](), "", "window.open('.." + filepath + "', '_blank', '');", True)
                End If

            Catch ex As Exception

            End Try

            myReader.Close()
            myConnection.Close()

        End Using

    End Sub

    Private Sub ViewSuratPemeriksaanAuto(permohonanID As String, isPDF As Boolean)

        Dim sql As String = ""
        Dim jenisLesenDesc = {"mpk_suratpemeriksaan"}

        Try

            sql = "SELECT a.Permohonan_ID, a.TarikhPemeriksaan, 'True' AS IsDigitalSign, CAST(a.TarikhSuratPemeriksaan AS datetime) AS TarikhSuratPemeriksaan, 
                CAST(a.NamaSyarikat AS varchar(200)) AS NamaSyarikat, 
                f.NoPendaftaran, f.NoAkaun, f.AlamatPremis, f.JenisPerniagaan, f.PemilikBaru, f.AlamatBaru, 
                f.JenisPerniagaanBaru, f.NamaBaruSyarikat, f.BillboardLokasi, f.LokasiPasar1, f.LokasiPasar2, 
                f.LokasiPasar3, f.JenisPasar, f.JenisPerniagaanPasar, f.JumlahPetak, f.AnjingAlamat, e.name AS AnjingJenisPremisDesc, 
                f.AnjingJenisPremis, f.AlamatPenjajaan, f.JenisPerniagaanPenjaja, f.TarikhBatal, f.PenganjurEkspo, 
                f.NamaEkspo, f.LokasiEkspo, f.NoTelEkspo, f.TarikhEkspo1, f.TarikhEkspo2, f.MasaEkspo1, f.MasaEkspo2, 
                f.KontraktorIklan, f.NoTelKontraktor, f.UkuranBanting, f.BilBanting, f.TarikhBanting1, f.TarikhBanting2, f.NoResitBanting, f.NoSiriStiker, f.TarikhBanting3, 
                a.Rujukan, a.RujukanInspektorat, a.NoAkaunCukai, a.IsBatal, a.JenisLesenDescList, a.JenisLesenIdList, f.SaizIklanList, 
                f.CahayaIklanList, f.UnitIklanList, f.LokasiList, f.BakaAnjingList, f.AnjingJantanList, f.AnjingBetinaList, 
                f.AnjingJantanMandulList, f.AnjingBetinaMandulList, 
                b.Pemohon_Name, b.Pemohon_Address, b.Pemohon_ICNo, b.Pemohon_MobileNo, b.Pemohon_TelNo, 
                c.Users_Fullname, c.Users_Signature, d.P1, d.P2, d.P3, d.IsiKandungan 
                FROM LESEN_Permohonan a 
                INNER JOIN LESEN_PermohonanPembetulan f ON a.Permohonan_ID = f.Permohonan_ID 
                INNER JOIN LESEN_Pemohon b ON b.Pemohon_ID=a.Permohonan_PemohonID 
                LEFT JOIN TBL_USERS c ON a.TandatanganPemeriksaanId=c.Users_Id 
                LEFT JOIN LESEN_PermohonanSurat d ON d.Permohonan_ID=a.Permohonan_ID 
                LEFT JOIN TBL_LOOKUPS e ON e.id = a.AnjingJenisPremis 
                WHERE a.Permohonan_ID=@permohonanID ORDER BY d.P1, d.P2, d.P3"

            sql = sql.Replace("@permohonanID", permohonanID)

            Dim ReportVar As String = jenisLesenDesc(0)

            Dim pobjData(0, 1)
            Dim lStrReportName = ReportVar + ".rpt"

            'Dim sessionActiveMonthYearID As String = GlobalClass.getIDActiveMonthByEstateID(Session.Item("sessionEstateCode"), DirectCast(FormView1.FindControl("cmbYear"), DropDownList).SelectedValue, DirectCast(FormView1.FindControl("cmbMonth"), DropDownList).SelectedValue)

            pobjData(0, 0) = "paraSQL" : pobjData(0, 1) = sql

            Session.Item("ReportName" + ReportVar) = lStrReportName
            Session.Item("pobjData" + ReportVar) = pobjData
            Session.Item("pathUrl" + ReportVar) = "~/lesen/report/pemeriksaan"
            'MessageBox(Session.Item("pathUrl" + ReportVar), Me)

            If isPDF Then
                Session.Item("reportPrintType") = "pdf"
            Else
                Session.Item("reportPrintType") = ""
            End If

            ScriptManager.RegisterClientScriptBlock(Me.Page, Me.[GetType](), ReportVar, "window.open('../ReportViewer.aspx?name=" + ReportVar + "', '_blank', '');", True)
        Catch ex As Exception
            MessageBox(ex.Message, Me)
        End Try
    End Sub

    Protected Sub btnSaveInfo_Click(sender As Object, e As EventArgs)

        Dim isSuccess As Boolean = True
        Dim PermohonanID As Integer = CInt(GridView1.SelectedDataKey.Values(0))

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQL As String = "UPDATE LESEN_PermohonanPembetulan SET SaizIklanList=@SaizIklanList, CahayaIklanList=@CahayaIklanList, UnitIklanList=@UnitIklanList, LokasiList = @LokasiList,
                        BakaAnjingList=@BakaAnjingList, AnjingJantanList=@AnjingJantanList, AnjingBetinaList=@AnjingBetinaList, AnjingJantanMandulList=@AnjingJantanMandulList, AnjingBetinaMandulList=@AnjingBetinaMandulList, 
                        NamaSyarikat = @NamaSyarikat, NoPendaftaran = @NoPendaftaran, NoAkaun = @NoAkaun, AlamatPremis = @AlamatPremis, JenisPerniagaan = @JenisPerniagaan, PemilikBaru = @PemilikBaru, 
                        AlamatBaru = @AlamatBaru, JenisPerniagaanBaru = @JenisPerniagaanBaru, NamaBaruSyarikat = @NamaBaruSyarikat, 
                        BillboardLokasi = @BillboardLokasi, LokasiPasar1 = @LokasiPasar1, LokasiPasar2 = @LokasiPasar2, LokasiPasar3 = @LokasiPasar3,
                        JenisPasar = @JenisPasar, JenisPerniagaanPasar = @JenisPerniagaanPasar, JumlahPetak = @JumlahPetak, AnjingAlamat = @AnjingAlamat, AnjingJenisPremis = @AnjingJenisPremis, 
                        AlamatPenjajaan = @AlamatPenjajaan, JenisPerniagaanPenjaja = @JenisPerniagaanPenjaja, PenganjurEkspo = @PenganjurEkspo, NamaEkspo = @NamaEkspo, LokasiEkspo = @LokasiEkspo, NoTelEkspo = @NoTelEkspo, 
                        TarikhEkspo1 = @TarikhEkspo1, TarikhEkspo2 = @TarikhEkspo2, MasaEkspo1 = @MasaEkspo1, MasaEkspo2 = @MasaEkspo2, 
                        KontraktorIklan = @KontraktorIklan, NoTelKontraktor = @NoTelKontraktor, UkuranBanting = @UkuranBanting, BilBanting = @BilBanting, TarikhBanting1 = @TarikhBanting1, TarikhBanting2 = @TarikhBanting2, 
                        NoResitBanting = @NoResitBanting, NoSiriStiker=@NoSiriStiker, TarikhBanting3=@TarikhBanting3, LastModDt = GETDATE() 
                        WHERE Permohonan_ID = @Permohonan_ID"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", PermohonanID)
            myCommandSelect.Parameters.AddWithValue("@NamaSyarikat", TB_NamaSyarikat.Text)
            myCommandSelect.Parameters.AddWithValue("@SaizIklanList", HF_SaizIklanList.Value)
            myCommandSelect.Parameters.AddWithValue("@CahayaIklanList", HF_CahayaIklanList.Value)
            myCommandSelect.Parameters.AddWithValue("@UnitIklanList", HF_UnitIklanList.Value)
            myCommandSelect.Parameters.AddWithValue("@LokasiList", HF_LokasiList.Value)
            myCommandSelect.Parameters.AddWithValue("@BakaAnjingList", HF_BakaAnjingList.Value)
            myCommandSelect.Parameters.AddWithValue("@AnjingJantanList", HF_AnjingJantanList.Value)
            myCommandSelect.Parameters.AddWithValue("@AnjingBetinaList", HF_AnjingBetinaList.Value)
            myCommandSelect.Parameters.AddWithValue("@AnjingJantanMandulList", HF_AnjingJantanMandulList.Value)
            myCommandSelect.Parameters.AddWithValue("@AnjingBetinaMandulList", HF_AnjingBetinaMandulList.Value)
            myCommandSelect.Parameters.AddWithValue("@NoPendaftaran", TB_NoPendaftaran.Text)
            myCommandSelect.Parameters.AddWithValue("@NoAkaun", TB_NoAkaun.Text)
            myCommandSelect.Parameters.AddWithValue("@AlamatPremis", TB_AlamatPremis.Text)
            myCommandSelect.Parameters.AddWithValue("@JenisPerniagaan", TB_JenisPerniagaan.Text)
            myCommandSelect.Parameters.AddWithValue("@PemilikBaru", TB_PemilikBaru.Text)
            myCommandSelect.Parameters.AddWithValue("@AlamatBaru", TB_AlamatBaru.Text)
            myCommandSelect.Parameters.AddWithValue("@JenisPerniagaanBaru", TB_JenisPerniagaanBaru.Text)
            myCommandSelect.Parameters.AddWithValue("@NamaBaruSyarikat", TB_NamaBaruSyarikat.Text)
            myCommandSelect.Parameters.AddWithValue("@BillboardLokasi", TB_BillboardLokasi.Text)
            myCommandSelect.Parameters.AddWithValue("@LokasiPasar1", TB_LokasiPasar1.Text)
            myCommandSelect.Parameters.AddWithValue("@LokasiPasar2", TB_LokasiPasar2.Text)
            myCommandSelect.Parameters.AddWithValue("@LokasiPasar3", TB_LokasiPasar3.Text)
            myCommandSelect.Parameters.AddWithValue("@JenisPasar", DDL_JenisPasar.SelectedValue)
            myCommandSelect.Parameters.AddWithValue("@JenisPerniagaanPasar", TB_JenisPerniagaanPasar.Text)
            myCommandSelect.Parameters.AddWithValue("@JumlahPetak", TB_JumlahPetak.Text)
            myCommandSelect.Parameters.AddWithValue("@AnjingAlamat", TB_AnjingAlamat.Text)
            myCommandSelect.Parameters.AddWithValue("@AnjingJenisPremis", DDL_AnjingJenisPremis.SelectedValue)
            myCommandSelect.Parameters.AddWithValue("@AlamatPenjajaan", TB_AlamatPenjajaan.Text)
            myCommandSelect.Parameters.AddWithValue("@JenisPerniagaanPenjaja", TB_JenisPerniagaanPenjaja.Text)
            myCommandSelect.Parameters.AddWithValue("@PenganjurEkspo", TB_PenganjurEkspo.Text)
            myCommandSelect.Parameters.AddWithValue("@NamaEkspo", TB_NamaEkspo.Text)
            myCommandSelect.Parameters.AddWithValue("@LokasiEkspo", TB_LokasiEkspo.Text)
            myCommandSelect.Parameters.AddWithValue("@NoTelEkspo", TB_NoTel.Text)
            myCommandSelect.Parameters.AddWithValue("@TarikhEkspo1", TB_TarikhEkspo1.Text)
            myCommandSelect.Parameters.AddWithValue("@TarikhEkspo2", TB_TarikhEkspo2.Text)
            myCommandSelect.Parameters.AddWithValue("@MasaEkspo1", TB_MasaEkspo1.Text)
            myCommandSelect.Parameters.AddWithValue("@MasaEkspo2", TB_MasaEkspo2.Text)
            myCommandSelect.Parameters.AddWithValue("@KontraktorIklan", TB_KontraktorIklan.Text)
            myCommandSelect.Parameters.AddWithValue("@NoTelKontraktor", TB_NoTelKontraktor.Text)
            myCommandSelect.Parameters.AddWithValue("@UkuranBanting", TB_UkuranBanting.Text)
            myCommandSelect.Parameters.AddWithValue("@BilBanting", TB_BilBanting.Text)
            myCommandSelect.Parameters.AddWithValue("@TarikhBanting1", TB_TarikhBanting1.Text)
            myCommandSelect.Parameters.AddWithValue("@TarikhBanting2", TB_TarikhBanting2.Text)
            myCommandSelect.Parameters.AddWithValue("@NoResitBanting", TB_NoResitBanting.Text)
            myCommandSelect.Parameters.AddWithValue("@NoSiriStiker", TB_NoSiriStiker.Text)
            myCommandSelect.Parameters.AddWithValue("@TarikhBanting3", TB_TarikhBanting3.Text)

            Try
                Dim recordset As Integer = myCommandSelect.ExecuteNonQuery()
                ShowAlert("success", "", "Maklumat pemeriksaan telah dikemaskini.")
            Catch ex As Exception
                isSuccess = False
                MessageBox("ERROR", Me)
            End Try

            myConnection.Close()

        End Using

    End Sub

    Private Sub insertPenjajaUlasan(pid As Integer, isSokong As Integer)

        Dim listdesc As List(Of String) = New List(Of String)

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQL As String = "SELECT SyaratSebabDesc FROM LESEN_PenjajaSyaratSebab WHERE IsSokong=@IsSokong"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@IsSokong", isSokong)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            Try
                While myReader.Read

                    listdesc.Add(myReader.Item("SyaratSebabDesc"))

                End While

            Catch ex As Exception

            End Try

            myReader.Close()
            myConnection.Close()

            myConnection.Open()

            Dim Sql2 = "DELETE FROM LESEN_PenjajaUlasan WHERE PermohonanID= @PermohonanID"

            Dim myCommand1 = New SqlCommand(Sql2, myConnection)
            myCommand1.Parameters.AddWithValue("@PermohonanID", pid)

            Dim result1 = myCommand1.ExecuteNonQuery()

            myCommand1.Dispose()
            myConnection.Close()

            For counter As Integer = 0 To listdesc.Count - 1

                myConnection.Open()

                Dim SQL1 As String = "INSERT INTO LESEN_PenjajaUlasan(PermohonanID, UlasanDesc, LastModID, LastModDt) 
                    VALUES (@PermohonanID, @UlasanDesc, @LastModID, GETDATE())"

                Dim myCommandSelect1 As New SqlCommand(SQL1, myConnection)
                myCommandSelect1.Parameters.AddWithValue("@PermohonanID", pid)
                myCommandSelect1.Parameters.AddWithValue("@LastModID", Session.Item("SessionUsersId"))
                myCommandSelect1.Parameters.AddWithValue("@UlasanDesc", listdesc(counter))

                Try
                    Dim result = myCommandSelect1.ExecuteNonQuery()
                    ShowAlert("success", "", "Laporan pemeriksaan berjaya dijana.")

                Catch ex As Exception
                    ShowAlert("error", "", "Gagal menjana laporan pemeriksaan.")

                End Try

                myConnection.Close()

            Next

        End Using

    End Sub

    Private Sub gvTabBayaran_Load(sender As Object, e As EventArgs) Handles gvTabBayaran.Load

        'Try
        '    Dim ApprStatusID As Integer = CInt(GridView1.SelectedDataKey.Values(2))

        '    MsgBox(ApprStatusID)
        '    '2  mohon ulasan
        '    '3  Penilaian Jabatan/Agensi
        '    '4	Peraku Jabatan/Agensi
        '    '5	Penilaian Jabatan Lesen
        '    '8	Peraku Jabatan Lesen

        '    If ApprStatusID = 5 Or ApprStatusID = 8 Then
        '        gvTabBayaran.Columns(5).Visible = "false"
        '        gvTabBayaran.Columns(6).Visible = "false"
        '    End If
        'Catch ex As Exception

        'End Try

    End Sub

    Protected Sub lbLihatSurat_Click(sender As Object, e As EventArgs)

        Dim pid As Integer = CInt(GridView1.SelectedDataKey.Values(0))

        If GetIsSuratFail(pid) Then
            ViewSuratPemeriksaanFail(pid)
        Else
            ViewSuratPemeriksaanAuto(pid, True)
        End If

    End Sub

    Protected Sub DeleteSuratFail()

        Dim pid As Integer = CInt(GridView1.SelectedDataKey.Values(0))

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQL As String = "DELETE FROM LESEN_PermohonanFail WHERE PermohonanFail_JenisLampiran = 'SP' AND PermohonanFail_PermohonanID = @Permohonan_ID"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)

            Try
                Dim result = myCommandSelect.ExecuteNonQuery()

                If result > 0 Then

                    FU_Lampiran1.Visible = True

                    BT_Cancel1.Visible = False
                    HL_Lampiran1.Visible = False
                    BT_Update1.Visible = False
                    BT_Delete1.Visible = False

                End If

            Catch ex As Exception
                MessageBox("Error", Me)
            End Try

            myConnection.Close()

        End Using

    End Sub

    Protected Sub BT_Update1_Click(sender As Object, e As EventArgs)

        FU_Lampiran1.Visible = True
        BT_Cancel1.Visible = True
        HL_Lampiran1.Visible = False
        BT_Update1.Visible = False
        BT_Delete1.Visible = False

    End Sub

    Protected Sub BT_Cancel1_Click(sender As Object, e As EventArgs)

        FU_Lampiran1.Visible = False
        BT_Cancel1.Visible = False
        HL_Lampiran1.Visible = True
        BT_Update1.Visible = True
        BT_Delete1.Visible = True

    End Sub

    Protected Sub BT_Delete1_Click(sender As Object, e As EventArgs)
        DeleteSuratFail()
    End Sub

    Protected Sub CB_SuratFail_CheckedChanged(sender As Object, e As EventArgs)

        If CB_SuratFail.Checked Then
            BT_Generate.Visible = False
            BT_Generate1.Visible = False
            pnlSuratFail.Visible = True
            pnlSuratAuto.Visible = False
        Else
            BT_Generate.Visible = True
            BT_Generate1.Visible = True
            pnlSuratFail.Visible = False
            pnlSuratAuto.Visible = True
        End If

    End Sub

    Private Sub rptWeek_ItemDataBound(sender As Object, e As RepeaterItemEventArgs) Handles rptWeek.ItemDataBound
        Try

            If e.Item.ItemType = ListItemType.AlternatingItem OrElse e.Item.ItemType = ListItemType.Item Then
                Dim hdn24jam As HiddenField = TryCast(e.Item.FindControl("hdn24jam"), HiddenField)

                If hdn24jam.Value = "True" Or Session.Item("sessionIsPeraku") = "True" Then
                    btnApprove.Text = "Lulus"
                    btnReject.Text = "Tolak"
                End If

            End If

        Catch ex As Exception

        End Try
    End Sub

    Protected Sub rblNotaKelulusanKJ_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim rblNotaKelulusanKJ As RadioButtonList = DirectCast(fvNotaKelulusan.FindControl("rblNotaKelulusanKJ"), RadioButtonList)
        Dim divNotaKelulusanPeraku As HtmlGenericControl = DirectCast(fvNotaKelulusan.FindControl("divNotaKelulusanPeraku"), HtmlGenericControl)

        If rblNotaKelulusanKJ.SelectedValue = 1 Or rblNotaKelulusanKJ.SelectedValue = 2 Then
            btnApprove.Visible = True
            btnReject.Visible = False
        ElseIf rblNotaKelulusanKJ.SelectedValue = 4 Then
            btnApprove.Visible = False
            btnReject.Visible = True
        Else
            btnApprove.Visible = True
            btnReject.Visible = True
        End If

        If rblNotaKelulusanKJ.SelectedValue = 6 Or rblNotaKelulusanKJ.SelectedValue = 2 Then
            divNotaKelulusanPeraku.Visible = True
        Else
            divNotaKelulusanPeraku.Visible = False
        End If

    End Sub

    Protected Sub BT_ViewMU_Command(sender As Object, e As CommandEventArgs)
        Dim pid As Integer = GridView1.SelectedDataKey.Values(0)
        Dim JenisLesenID As Integer = GridView1.SelectedDataKey.Values(4)
        Dim AgensiID As String = "3"

        ViewSuratMohon(pid, AgensiID, JenisLesenID)

    End Sub

    Private Sub updateIklanList(ByVal saizVal As String, ByVal cahayaVal As String, ByVal unitVal As String)

        If HF_SaizIklanList.Value.ToString.Length = 0 Then
            HF_SaizIklanList.Value = saizVal
        Else
            HF_SaizIklanList.Value += "," + saizVal
        End If

        If HF_CahayaIklanList.Value.ToString.Length = 0 Then
            HF_CahayaIklanList.Value = cahayaVal
        Else
            HF_CahayaIklanList.Value += "," + cahayaVal
        End If

        If HF_UnitIklanList.Value.ToString.Length = 0 Then
            HF_UnitIklanList.Value = unitVal
        Else
            HF_UnitIklanList.Value += "," + unitVal
        End If

    End Sub

    Private Sub updateAnjingList(ByVal bakaVal As String, ByVal jantanVal As String, ByVal betinaVal As String, ByVal jMandulVal As String, ByVal bMandulVal As String)

        If HF_BakaAnjingList.Value.ToString.Length = 0 Then
            HF_BakaAnjingList.Value = bakaVal
        Else
            HF_BakaAnjingList.Value += "," + bakaVal
        End If

        If HF_AnjingJantanList.Value.ToString.Length = 0 Then
            HF_AnjingJantanList.Value = jantanVal
        Else
            HF_AnjingJantanList.Value += "," + jantanVal
        End If

        If HF_AnjingBetinaList.Value.ToString.Length = 0 Then
            HF_AnjingBetinaList.Value = betinaVal
        Else
            HF_AnjingBetinaList.Value += "," + betinaVal
        End If

        If HF_AnjingJantanMandulList.Value.ToString.Length = 0 Then
            HF_AnjingJantanMandulList.Value = jMandulVal
        Else
            HF_AnjingJantanMandulList.Value += "," + jMandulVal
        End If

        If HF_AnjingBetinaMandulList.Value.ToString.Length = 0 Then
            HF_AnjingBetinaMandulList.Value = bMandulVal
        Else
            HF_AnjingBetinaMandulList.Value += "," + bMandulVal
        End If

    End Sub

    Private Sub updateLokasiList(ByVal lokasiVal As String)

        If HF_LokasiList.Value.ToString.Length = 0 Then
            HF_LokasiList.Value = lokasiVal
        Else
            HF_LokasiList.Value += "||" + lokasiVal
        End If

    End Sub


    Protected Sub btnAddIklan_Click(sender As Object, e As EventArgs)

        If Not String.IsNullOrWhiteSpace(TB_SaizIklan1.Text) And DDL_Iklan1.SelectedValue <> "" And Not String.IsNullOrWhiteSpace(TB_UnitIklan1.Text) Then
            Dim dt As DataTable

            If ViewState("IklanTable_ins") IsNot Nothing Then
                dt = DirectCast(ViewState("IklanTable_ins"), DataTable)
            Else
                dt = New DataTable()
                dt.Columns.Add("SaizIklan", GetType(String))
                dt.Columns.Add("Bercahaya", GetType(String))
                dt.Columns.Add("Unit", GetType(String))
            End If

            Dim newRow As DataRow = dt.NewRow()
            newRow("SaizIklan") = TB_SaizIklan1.Text
            newRow("Bercahaya") = DDL_Iklan1.SelectedValue.ToString
            newRow("Unit") = TB_UnitIklan1.Text 'If(IsNumeric(txtRank.Text), Convert.ToInt32(txtRank.Text), 0)
            dt.Rows.Add(newRow)

            ViewState("IklanTable_ins") = dt
            gvIklanList.DataSource = dt
            gvIklanList.DataBind()

            updateIklanList(newRow("SaizIklan"), newRow("Bercahaya"), newRow("Unit"))

            'Clear textboxes for next entry
            TB_SaizIklan1.Text = ""
            TB_UnitIklan1.Text = ""
            DDL_Iklan1.SelectedIndex = 0

        End If
    End Sub

    Protected Sub gvIklanList_RowDeleting(sender As Object, e As GridViewDeleteEventArgs)

        If ViewState("IklanTable_ins") IsNot Nothing Then
            Dim dt As DataTable = DirectCast(ViewState("IklanTable_ins"), DataTable)

            dt.Rows.RemoveAt(e.RowIndex)

            ViewState("IklanTable_ins") = dt

            gvIklanList.DataSource = dt
            gvIklanList.DataBind()

            HF_SaizIklanList.Value = ""
            HF_CahayaIklanList.Value = ""
            HF_UnitIklanList.Value = ""

            For Each row As DataRow In dt.Rows
                updateIklanList(row("SaizIklan"), row("Bercahaya"), row("Unit"))
            Next

        End If

    End Sub

    Protected Sub btnAddAnjing_Click(sender As Object, e As EventArgs)

        If Not String.IsNullOrWhiteSpace(TB_Jantan1.Text) And Not String.IsNullOrWhiteSpace(TB_Betina1.Text) And
            Not String.IsNullOrWhiteSpace(TB_JantanMandul1.Text) And Not String.IsNullOrWhiteSpace(TB_BetinaMandul1.Text) And
            Not String.IsNullOrWhiteSpace(DDL_BakaAnjing1.SelectedValue) Then
            Dim dt As DataTable

            If ViewState("AnjingTable_ins") IsNot Nothing Then
                dt = DirectCast(ViewState("AnjingTable_ins"), DataTable)
            Else
                dt = New DataTable()
                dt.Columns.Add("Baka", GetType(String))
                dt.Columns.Add("Jantan", GetType(String))
                dt.Columns.Add("Betina", GetType(String))
                dt.Columns.Add("JantanMandul", GetType(String))
                dt.Columns.Add("BetinaMandul", GetType(String))
            End If

            Dim newRow As DataRow = dt.NewRow()
            newRow("Baka") = DDL_BakaAnjing1.SelectedItem.Text
            newRow("Jantan") = TB_Jantan1.Text
            newRow("Betina") = TB_Betina1.Text
            newRow("JantanMandul") = TB_JantanMandul1.Text
            newRow("BetinaMandul") = TB_BetinaMandul1.Text
            dt.Rows.Add(newRow)

            ViewState("AnjingTable_ins") = dt
            gvAnjingList.DataSource = dt
            gvAnjingList.DataBind()

            updateAnjingList(newRow("Baka"), newRow("Jantan"), newRow("Betina"), newRow("JantanMandul"), newRow("BetinaMandul"))

            'Clear textboxes for next entry
            TB_Jantan1.Text = ""
            TB_Betina1.Text = ""
            TB_JantanMandul1.Text = ""
            TB_BetinaMandul1.Text = ""
            DDL_BakaAnjing1.SelectedIndex = 0

        End If
    End Sub

    Protected Sub gvAnjingList_RowDeleting(sender As Object, e As GridViewDeleteEventArgs)

        If ViewState("AnjingTable_ins") IsNot Nothing Then
            Dim dt As DataTable = DirectCast(ViewState("AnjingTable_ins"), DataTable)

            dt.Rows.RemoveAt(e.RowIndex)

            ViewState("AnjingTable_ins") = dt

            gvAnjingList.DataSource = dt
            gvAnjingList.DataBind()

            HF_BakaAnjingList.Value = ""
            HF_AnjingJantanList.Value = ""
            HF_AnjingBetinaList.Value = ""
            HF_AnjingJantanMandulList.Value = ""
            HF_AnjingBetinaMandulList.Value = ""

            For Each row As DataRow In dt.Rows
                updateAnjingList(row("Baka"), row("Jantan"), row("Betina"), row("JantanMandul"), row("BetinaMandul"))
            Next

        End If

    End Sub

    Protected Sub btnAddLokasi_Click(sender As Object, e As EventArgs)

        If Not String.IsNullOrWhiteSpace(TB_LokasiBanting.Text) Then
            Dim dt As DataTable

            If ViewState("LokasiTable_ins") IsNot Nothing Then
                dt = DirectCast(ViewState("LokasiTable_ins"), DataTable)
            Else
                dt = New DataTable()
                dt.Columns.Add("No", GetType(String))
                dt.Columns.Add("Lokasi", GetType(String))
            End If

            Dim newRow As DataRow = dt.NewRow()
            newRow("No") = (dt.Rows.Count + 1).ToString
            newRow("Lokasi") = TB_LokasiBanting.Text
            dt.Rows.Add(newRow)

            ViewState("LokasiTable_ins") = dt
            gvLokasiList.DataSource = dt
            gvLokasiList.DataBind()

            updateLokasiList(newRow("Lokasi"))

            'Clear textboxes for next entry
            TB_LokasiBanting.Text = ""

        End If
    End Sub

    Protected Sub gvLokasiList_RowDeleting(sender As Object, e As GridViewDeleteEventArgs)

        If ViewState("LokasiTable_ins") IsNot Nothing Then
            Dim dt As DataTable = DirectCast(ViewState("LokasiTable_ins"), DataTable)

            dt.Rows.RemoveAt(e.RowIndex)

            ViewState("LokasiTable_ins") = dt

            gvLokasiList.DataSource = dt
            gvLokasiList.DataBind()

            HF_LokasiList.Value = ""

            For Each row As DataRow In dt.Rows
                updateLokasiList(row("Lokasi"))
            Next

        End If

    End Sub

    Private Sub PanelAccessPembetulan(lesenid As Integer, clrflag As Boolean)

        If clrflag = True Then

            pnlbillboard.Visible = False
            pnlesen1.Visible = False
            pnlesen1a.Visible = False
            pnlesen1b.Visible = False
            pnlesen1c.Visible = False
            pnlesen1d.Visible = False
            pnlesen1e.Visible = False
            pnlesen2.Visible = False
            pnlesen3.Visible = False
            pnlesen4.Visible = False
            pnlesen5.Visible = False
            pnlesen6.Visible = False

            Exit Sub

        End If

        Select Case lesenid
            Case 3                      'Lesen Anjing /
                pnlesen3.Visible = True
            Case 2, 25                      'Pasar Lambak, Tambah Petak /
                pnlesen2.Visible = True
            Case 4                      'Pasar Penjaja /
                pnlesen4.Visible = True
            Case 1                      'Lesen Perniagaan /
                pnlesen1.Visible = True
                pnlesen1a.Visible = True
            Case 6, 7                     'Tukar Alamat Perniagaan, Tambah Premis /
                pnlesen1.Visible = True
                pnlesen1a.Visible = True
                pnlesen1c.Visible = True
            Case 13, 17, 18                      'Permit Kaki Lima, Lot Tepi Kedai, Lebuh Awam /
                pnlesen1.Visible = True
            Case 14                         'Pembatalan Lesen & Wang Amanah
                pnlesen1.Visible = True
                'pnlbatal.Visible = True
            Case 11, 23, 26                     'Tukar Nama Syarikat /
                pnlesen1.Visible = True
                pnlesen1a.Visible = True
                pnlesen1c.Visible = True
                pnlesen1e.Visible = True
            Case 9, 24                          'Tukar Pemilik Perniagaan /
                pnlesen1.Visible = True
                pnlesen1a.Visible = True
                pnlesen1c.Visible = True
                pnlesen1b.Visible = True
            Case 10, 12, 16                     'Tambah, Tukar, Pengurangan Visual Iklan /
                pnlesen1.Visible = True
                pnlesen1a.Visible = True
            Case 5                          ' billboard /
                pnlesen1.Visible = True
                pnlesen1a.Visible = True
                pnlbillboard.Visible = True
            Case 8                     'Jenis Perniagaan /
                pnlesen1.Visible = True
                pnlesen1c.Visible = True
                pnlesen1d.Visible = True
            Case 15                     'Expo /
                pnlesen5.Visible = True
            Case 19                             'Nama + Alamat + Visual Iklan /
                pnlesen1.Visible = True
                pnlesen1a.Visible = True
                pnlesen1c.Visible = True
                pnlesen1e.Visible = True
            Case 20                             'Pemilik + Alamat + Visual Iklan /
                pnlesen1.Visible = True
                pnlesen1a.Visible = True
                pnlesen1b.Visible = True
                pnlesen1c.Visible = True
            Case 27                             'Banting
                pnlesen1.Visible = True
                pnlesen6.Visible = True

        End Select

    End Sub

End Class
