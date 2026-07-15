
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Drawing.Imaging
Imports System.IO
Imports Microsoft.ReportingServices.Rendering.ExcelRenderer.ExcelGenerator.BIFF8

Partial Class pembatalan
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
        ' FormView1.ChangeMode(DetailsViewMode.Edit)
        ' TabContainer1.Visible = True
        ' idFooter.Visible = True
        ' idListing.Visible = False
        ' showOtherControl(GridView1)
		
        FormView1.ChangeMode(DetailsViewMode.Edit)
        TabContainer1.Visible = True
        idFooter.Visible = True
        idListing.Visible = False
        idNotaKelulusan.Visible = False

		showOtherControl(GridView1)

        'showFormControl(GridView1)		
		' Try
			' showOtherControl(GridView1)
        ' Catch ex As Exception

        ' End Try		

    End Sub
	
    Private Sub showOtherControl(gv1 As GridView)
	
		Session.Item("isDisablePrintSession") = "Y"
		
        Dim idSokongUlasan As HtmlGenericControl = DirectCast(fvSokongUlasan.FindControl("idSokongUlasan"), HtmlGenericControl)
        Dim idSokongUlasanPengesah As HtmlGenericControl = DirectCast(fvSokongUlasan.FindControl("idSokongUlasanPengesah"), HtmlGenericControl)
        Dim hdnFiedlJabatanAgensiType As HiddenField = DirectCast(fvSokongUlasan.FindControl("hdnFiedlJabatanAgensiType"), HiddenField)
        Dim txtNotaKelulusanPengesah As TextBox = DirectCast(fvNotaKelulusan.FindControl("txtNotaKelulusanPengesah"), TextBox)
        Dim txtNotaKelulusanPengesah2 As TextBox = DirectCast(fvNotaKelulusan.FindControl("txtNotaKelulusanPengesah2"), TextBox)
        Dim txtNotaKelulusan2 As TextBox = DirectCast(fvNotaKelulusan.FindControl("txtNotaKelulusan2"), TextBox)
        Dim txtNotaKelulusan As TextBox = DirectCast(fvNotaKelulusan.FindControl("txtNotaKelulusan"), TextBox)

        Dim ApprStatusID As Integer = CInt(gv1.SelectedDataKey.Values(2))
        Dim PermohonanID As Integer = CInt(gv1.SelectedDataKey.Values(0))
        Dim JenisLesenID As Integer = CInt(gv1.SelectedDataKey.Values(4))
        Dim IsFail As Boolean = CBool(gv1.SelectedDataKey.Values(5))
        Dim IsPenilaianStatus As Integer = CInt(gv1.SelectedDataKey.Values(6))

        Dim agensiType As String = "L"
        '//hide tab kadar bayaran
        Try
            tabKadarBayaran.Visible = False
			TabLampiran.Visible = False
            agensiType = If(IsDBNull(gv1.SelectedDataKey.Values(3)), "J", gv1.SelectedDataKey.Values(3))

            If agensiType = "J" Then
                tabKadarBayaran.Visible = True
                TabLampiran.Visible = True				
            End If

            '//tab surat
            If agensiType = "J" Then

                If Session.Item("sessionOCS") = "3" Then


                    tabSurat.Visible = True

                    If IsPenilaianStatus <> 0 Or Session.Item("sessionIsPenilai") = "True" Then
                        BT_ViewMail.Visible = True
                        Session.Item("isDisablePrintSession") = "N"
                    Else
                        'BT_ViewMail.Visible = False
                        Session.Item("isDisablePrintSession") = "Y"
                    End If

                    If Session.Item("sessionIsPenilai") = "True" Then
                        divTarikhSurat.Visible = True
                    Else
                        divTarikhSurat.Visible = False
                    End If

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

                    If Request.Browser.IsMobileDevice Then
                        tabSurat.Visible = False
                        tabKadarBayaran.Visible = False
                    Else

                    End If


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
                    End If

                    GetSuratFail(PermohonanID)

                Else

                    BT_Generate.Visible = False
                    BT_Generate1.Visible = False

                End If

                '//for approval remarks
                If ApprStatusID = 6 Or ApprStatusID = 7 Or ApprStatusID = 9 Or ApprStatusID = 10 Then

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

                ElseIf ApprStatusID = 5 Or ApprStatusID = 8 Then

                    If Session.Item("sessionIsPeraku") = "True" Or Session.Item("sessionIsPenilai") = "True" Then
                        'btnApprove.Visible = True
                        'btnReject.Visible = True
                        'idNotaKelulusan.Visible = True

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

                End If

            End If

        Catch ex As Exception

        End Try
   
        Try

            '//hide tab tetapan ik
            If ApprStatusID = 2 Then
                ' tabUlasan.Visible = False
                ' tabKadarBayaran.Visible = False
                 'tabTetapan.Visible = True
                ' tabSurat.Visible = False
                 'gvIK.Columns(1).Visible = "true"
				 
                If cint(Session.Item("sessionOCS")) = 3 Then
                    tabTetapan.Visible = True
                    gvIK.Columns(1).Visible = "True"
                End If				 
            Else
                tabTetapan.Visible = False
                'tabUlasan.Visible = True


                If cint(Session.Item("sessionOCS")) = 3 Then
                    tabTetapan.Visible = True
                    gvIK.Columns(1).Visible = "false"
                End If


            End If

				' If cint(Session.Item("sessionOCS")) = 3 Then
                    ' tabTetapan.Visible = True
                    ' gvIK.Columns(1).Visible = "false"
                ' End If
				
        Catch ex As Exception

        End Try

        '//hide column edit for kadar bayaran
        'If ApprStatusID = 5 Or ApprStatusID = 8 Then
        '    gvTabBayaran.Columns(5).Visible = "false"
        '    gvTabBayaran.Columns(6).Visible = "false"
        'End If

    End Sub	

    Private Sub showFormControl(gv1 As GridView)
		'Session.Item("isDisablePrintSession") = "Y"
		
        Dim idSokongUlasan As HtmlGenericControl = DirectCast(fvSokongUlasan.FindControl("idSokongUlasan"), HtmlGenericControl)
        Dim idSokongUlasanPengesah As HtmlGenericControl = DirectCast(fvSokongUlasan.FindControl("idSokongUlasanPengesah"), HtmlGenericControl)
        Dim hdnFiedlJabatanAgensiType As HiddenField = DirectCast(fvSokongUlasan.FindControl("hdnFiedlJabatanAgensiType"), HiddenField)
        Dim txtNotaKelulusanPengesah As TextBox = DirectCast(fvNotaKelulusan.FindControl("txtNotaKelulusanPengesah"), TextBox)
        Dim txtNotaKelulusan As TextBox = DirectCast(fvNotaKelulusan.FindControl("txtNotaKelulusan"), TextBox)

        Dim ApprStatusID As Integer = CInt(gv1.SelectedDataKey.Values(2))
        Dim PermohonanID As Integer = CInt(gv1.SelectedDataKey.Values(0))
        Dim IsFail As Boolean = CBool(gv1.SelectedDataKey.Values(5))

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
            End If

        ElseIf ApprStatusID = 5 Or ApprStatusID = 8 Then

            If Session.Item("sessionIsPeraku") = "True" Or Session.Item("sessionIsPenilai") = "True" Then
                'btnApprove.Visible = True
                'btnReject.Visible = True
                'idNotaKelulusan.Visible = True

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
					tabSurat.Visible = False
                Else

                    gvTabUlasan.Columns(4).Visible = "false"
                End If
            End If

        Catch ex As Exception

        End Try

        Try

            '//mobile view
            If Not Page.IsPostBack Then

                'If Request.Browser.IsMobileDevice Then
                '    gvTabBayaran.Columns(2).Visible = "false"
                '    gvTabBayaran.Columns(3).Visible = "false"
                '    gvTabBayaran.Columns(5).Visible = "false"
                '    gvTabBayaran.Columns(4).Visible = "true"
                'Else

                '    gvTabBayaran.Columns(4).Visible = "false"
                'End If
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

                    ' gvTabBayaran.Columns(5).Visible = "false"
                    ' gvTabBayaran.Columns(6).Visible = "false"

                    BT_Generate.Visible = "false"
                    BT_Generate1.Visible = "false"
                    'btnSaveLetter.Visible = "false"

                    idFooter.Visible = "false"
                    divBtnKembali.Visible = "true"

                End If			

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
		'Response.Redirect("/lesen/pembatalan.aspx")
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

                If TB_TarikhSurat.Text.Length = 0 or TB_TarikhSurat.Text.Contains("1900") = True Then

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

                        SQL = "UPDATE LESEN_PermohonanAgensiBatal set " & fldName & " = 3, LastModDt = getdate(), ikAssign = @PengesahID /*,PengesahID = @PengesahID  */
					where Permohonan_ID = @Permohonan_ID 
					and case when JabatanAgensi_ID is null then 0 else JabatanAgensi_ID end = @AgensiId "

                        ikAssignCheck = getikAssignCheck(Permohonan_ID)

                    ElseIf ApprStatusID = 3 Then
                        fldName = "IsLawatanTapakUlasan"

                        SQL = "UPDATE LESEN_PermohonanAgensiBatal set " & fldName & " = 1, LastModDt = getdate() 
					where Permohonan_ID = @Permohonan_ID 
					and case when JabatanAgensi_ID is null then 0 else JabatanAgensi_ID end = @AgensiId "

                    ElseIf ApprStatusID = 4 Then
                        fldName = "IsPenilaian"

                        SQL = "UPDATE LESEN_PermohonanAgensiBatal set " & fldName & " = 1, LastModDt = getdate(), 
					PengesahStatusID = @PengesahStatusID, PengesahNotaKelulusan = @PengesahNotaKelulusan,
					PengesahID = @PengesahID				
					where Permohonan_ID = @Permohonan_ID 
					and case when JabatanAgensi_ID is null then 0 else JabatanAgensi_ID end = @AgensiId "

                        Try
                            Dim hdnFiedlJabatanAgensiType As HiddenField = DirectCast(fvSokongUlasan.FindControl("hdnFiedlJabatanAgensiType"), HiddenField)

                            If hdnFiedlJabatanAgensiType.Value = "L" Then
                                SQL = SQL & ";UPDATE LESEN_PermohonanAgensiBatal set " & fldName & " = 1, LastModDt = getdate(),
								StatusID = @PengesahStatusID, NotaKelulusan = @PengesahNotaKelulusan
								where Permohonan_ID = @Permohonan_ID 
								and case when JabatanAgensi_ID is null then 0 else JabatanAgensi_ID end = @AgensiId "
                            End If
                        Catch ex As Exception

                        End Try


                    ElseIf ApprStatusID = 5 Then
                        fldName = "IsPeraku"

                        SQL = "UPDATE LESEN_PermohonanAgensiBatal set " & fldName & " = 1, LastModDt = getdate(),
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
            LESEN_PermohonanAgensiBatal a
            inner join LESEN_PermohonanAgensiStaffBatal b on b.PermohonanAgensi_ID = a.PermohonanAgensi_ID
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
                LastModID = @SessionUserName ,NotaKelulusanPengesahBatal = @NotaKelulusanPengesahBatal
                where Permohonan_ID = @Permohonan_ID "
                ElseIf ApprStatusID = 8 Then
                    SQL = "UPDATE LESEN_Permohonan set StatusID = " & statusUpdate & ", LastModDt = getdate(), 
                LastModID = @SessionUserName ,NotaKelulusanBatal = @NotaKelulusanBatal, NotaKelulusanKJ = @NotaKelulusanKJ
                where Permohonan_ID = @Permohonan_ID "
                End If

            End If

            Dim myCommand As New SqlCommand(SQL, myConnection)

            myCommand.Parameters.AddWithValue("@Permohonan_ID", Permohonan_ID)
            myCommand.Parameters.AddWithValue("@AgensiId", AgensiID)
            myCommand.Parameters.AddWithValue("@ApprStatusID", ApprStatusID)
            myCommand.Parameters.AddWithValue("@SessionUserName", Session.Item("SessionUserName"))
            myCommand.Parameters.AddWithValue("@NotaKelulusanPengesahBatal", txtNotaKelulusanPengesah.Text)
            myCommand.Parameters.AddWithValue("@NotaKelulusanBatal", txtNotaKelulusan.Text)
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
                    LastModDt = getdate(), LastModID = @SessionUserName ,NotaKelulusanPengesahBatal = @NotaKelulusanPengesahBatal
                where Permohonan_ID = @Permohonan_ID "
                Else
                    SQL = "UPDATE LESEN_Permohonan set StatusID = " & statusUpdate & ", LastModDt = getdate(), 
                LastModID = @SessionUserName ,NotaKelulusanBatal = @NotaKelulusanBatal
                where Permohonan_ID = @Permohonan_ID "
                End If

            End If

            Dim myCommand As New SqlCommand(SQL, myConnection)

            myCommand.Parameters.AddWithValue("@Permohonan_ID", Permohonan_ID)
            myCommand.Parameters.AddWithValue("@AgensiId", AgensiID)
            myCommand.Parameters.AddWithValue("@ApprStatusID", ApprStatusID)
            myCommand.Parameters.AddWithValue("@SessionUserName", Session.Item("SessionUserName"))
            myCommand.Parameters.AddWithValue("@NotaKelulusanPengesahBatal", txtNotaKelulusanPengesah.Text)
            myCommand.Parameters.AddWithValue("@NotaKelulusanBatal", txtNotaKelulusan.Text)

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



    'Protected Sub btnAddNew_Click(sender As Object, e As EventArgs)
    '    Dim Permohonan_ID As Integer = CInt(GridView1.SelectedDataKey.Values(0))
    '    Dim AgensiID As Integer = If(IsDBNull(GridView1.SelectedDataKey.Values(1)), 0, CInt(GridView1.SelectedDataKey.Values(1)))
    '    Dim ApprStatusID As Integer = CInt(GridView1.SelectedDataKey.Values(2))

    '    Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

    '        Dim SQL As String = ""

    '        SQL = "Insert Into LESEN_KadarBayaran (KadarBayaran_PermohonanID,KadarBayaran_PermohonanAgensiID,KadarBayaran_UserID,CreatedDt,CreatorID) Values 
    '             (@Permohonan_ID,case when @AgensiId = 0 then NULL else @AgensiId end,@SessionUsersID, getdate(), @SessionUserName)  "

    '        Dim myCommand As New SqlCommand(SQL, myConnection)

    '        myCommand.Parameters.AddWithValue("@Permohonan_ID", Permohonan_ID)
    '        myCommand.Parameters.AddWithValue("@AgensiId", AgensiID)
    '        myCommand.Parameters.AddWithValue("@ApprStatusID", ApprStatusID)
    '        myCommand.Parameters.AddWithValue("@SessionUsersId", Session.Item("SessionUsersId"))
    '        myCommand.Parameters.AddWithValue("@SessionUserName", Session.Item("SessionUserName"))

    '        myConnection.Open()

    '        Dim recordset As Integer = myCommand.ExecuteNonQuery()

    '        '//start insert - tab bayaran

    '        If recordset Then
    '            gvTabBayaran.EditIndex = CInt(gvTabBayaran.Rows.Count)

    '        End If

    '        myConnection.Close()

    '        gvTabBayaran.DataBind()

    '        Page.SetFocus(Me.ui_btnPageBottom.ClientID)

    '    End Using
    'End Sub

    Protected Sub btnAddNewUpload_Click(sender As Object, e As EventArgs)
        Dim Permohonan_ID As Integer = CInt(GridView1.SelectedDataKey.Values(0))
        Dim AgensiID As Integer = If(IsDBNull(GridView1.SelectedDataKey.Values(1)), 0, CInt(GridView1.SelectedDataKey.Values(1)))
        Dim ApprStatusID As Integer = CInt(GridView1.SelectedDataKey.Values(2))

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Dim SQL As String = ""

            SQL = "Insert Into LESEN_UlasanFailBatal (UlasanFail_PermohonanID,UlasanFail_PermohonanAgensiID,UlasanFail_UserID,CreatedDt,CreatorID) Values 
                 (@Permohonan_ID,case when @AgensiId = 0 then NULL else @AgensiId end,@SessionUsersID, getdate(), @SessionUserName)  "

            Dim myCommand As New SqlCommand(SQL, myConnection)

            myCommand.Parameters.AddWithValue("@Permohonan_ID", Permohonan_ID)
            myCommand.Parameters.AddWithValue("@AgensiId", AgensiID)
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
                        Dim objImage As System.Drawing.Image = ScaleImage(bmpPostedImage, 1024)
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
            Dim JenisLesenID As Integer = CInt(Me.GridView1.DataKeys(intRow)("JenisLesen_ID"))

            ViewSuratMohon(Permohonan_ID, AgensiID, JenisLesenID)

        End If

    End Sub

    Private Sub ViewSuratMohon(permohonanID As String, agensiID As String, jenislesenID As Integer)
        Dim sql As String = ""
        Dim jenisLesenDesc = {"", "smu_perniagaan", "smu_pasar", "smu_anjing", "smu_penjaja", "smu_billboard", "smu_tukaralamat", "smu_tambahpremis", "smu_tambahjenis",
            "smu_tukarpemilik", "smu_tukariklan", "smu_tukarnama", "smu_kurangiklan", "smu_kakilima", "null", "smu_ekspo", "smu_tambahiklan", "smu_tepikedai", "smu_lebuhawam",
            "smu_tukaralamatnamaiklan", "smu_tukarpemilikalamatiklan", "null", "null", "smu_tukarnamaiklan", "smu_tukarpemilikiklan", "smu_pasartambahpetak", "smu_tukarnamatambahpremis"}

        Try

            sql = "SELECT a.*, f.name AS AnjingBakaDesc, e.JabatanAgensi_Address, e.JabatanAgensi_Kepada, c.JenisLesen_Description, b.Pemohon_Name, b.Pemohon_ICNo, b.Pemohon_PassportNo, b.Pemohon_Address, b.Pemohon_Email, b.Pemohon_MobileNo, b.Pemohon_TelNo, g.Users_Fullname, g.Users_Signature " &
                    "FROM LESEN_Permohonan a INNER JOIN LESEN_Pemohon b ON a.Permohonan_PemohonID = b.Pemohon_ID INNER JOIN LESEN_JenisLesen c ON a.JenisLesen_ID = c.JenisLesen_ID INNER JOIN LESEN_PermohonanAgensiBatal d ON a.Permohonan_ID = d.Permohonan_ID " &
                    "INNER JOIN LESEN_JabatanAgensi e ON d.JabatanAgensi_ID = e.JabatanAgensi_ID LEFT JOIN TBL_LOOKUPS f ON f.id = a.AnjingBaka LEFT JOIN TBL_USERS g ON g.Users_Id = (case when e.JabatanAgensi_Type = 'J' then a.TandatanganMohonUlasanId when e.JabatanAgensi_Type = 'L' then a.TandatanganMohonUlasanLuarId end) " &
                    "WHERE a.Permohonan_ID=" & permohonanID & " AND e.JabatanAgensi_ID = " & agensiID

            Dim ReportVar As String = jenisLesenDesc(jenislesenID)

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
	
	try
        Dim Permohonan_ID As Integer = GridView1.SelectedDataKey.Values(0)
        Dim AgensiID As Integer = GridView1.SelectedDataKey.Values(1)

        Dim row As GridViewRow = (CType((CType(sender, CheckBox)).NamingContainer, GridViewRow))
        Dim index As Integer = row.RowIndex
        Dim cb1 As CheckBox = CType(gvIK.Rows(index).FindControl("cbSelect"), CheckBox)
        Dim hdID As HiddenField = CType(gvIK.Rows(index).FindControl("hdID"), HiddenField)

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Dim SQL As String = ""

            If cb1.Checked Then
                SQL = "insert into LESEN_PermohonanAgensiStaffBatal (PermohonanAgensiStaffID_UsersID,PermohonanAgensi_ID)
                        select top 1 @usersID, a.PermohonanAgensi_ID from LESEN_PermohonanAgensiBatal a 
                        where a.Permohonan_ID = @Permohonan_ID and a.JabatanAgensi_ID = @AgensiId "
            Else
					SQL = "delete a
					from LESEN_PermohonanAgensiStaffBatal a
					where a.PermohonanAgensiStaffID_UsersID = @usersID
					and PermohonanAgensi_ID IN (select x.PermohonanAgensi_ID from LESEN_PermohonanAgensiBatal x where x.Permohonan_ID=@Permohonan_ID 
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
            'ViewSuratPemeriksaanAuto(pid, jid, True)
			
			If Session.Item("isDisablePrintSession") = "Y" then
				ViewSuratPemeriksaanAuto(pid, jid, False)
			Else
				ViewSuratPemeriksaanAuto(pid, jid, True)
			End If			
        End If

    End Sub

    Protected Sub BT_Generate_Command(sender As Object, e As CommandEventArgs)

        Dim jid As Integer = CInt(Me.FormView1.DataKey("JenisLesen_ID"))
        Dim pid As Integer = GridView1.SelectedDataKey.Values(0)
        'Dim pid As Integer = CInt(Me.FormView1.DataKey("Permohonan_ID"))

        'MessageBox("Generate Mail " & pid.ToString & "/" & jid.ToString, Me)

        Dim rujukan As String = ""
        Dim isi1 As String = ""
        Dim isi2 As String = ""

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQL As String = "SELECT JenisLesen_SuratBatalIKLulus1 AS isi1, JenisLesen_SuratBatalIKLulus2 AS isi2 FROM LESEN_JenisLesen WHERE JenisLesen_ID = @JenisLesen_ID"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@JenisLesen_ID", jid)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            Try
                If myReader.Read Then

                    isi1 = myReader.Item("isi1")
                    isi2 = myReader.Item("isi2")

                End If

            Catch ex As Exception

            End Try

            myReader.Close()
            myConnection.Close()

            myConnection.Open()

            Dim SQL1 As String = "UPDATE LESEN_Permohonan SET SuratPemeriksaan1 = @SuratPemeriksaan1, SuratPemeriksaan2 = @SuratPemeriksaan2 WHERE (Permohonan_ID = @Permohonan_ID)"

            Dim myCommandSelect1 As New SqlCommand(SQL1, myConnection)
            myCommandSelect1.Parameters.AddWithValue("@SuratPemeriksaan1", isi1)
            myCommandSelect1.Parameters.AddWithValue("@SuratPemeriksaan2", isi2)
            myCommandSelect1.Parameters.AddWithValue("@Permohonan_ID", pid)

            Try
                Dim result = myCommandSelect1.ExecuteNonQuery()
                GetSuratContent(pid)
                ShowAlert("success", "", "Surat pemeriksaan telah dijana.")
            Catch ex As Exception
                MessageBox("Error", Me)
            End Try

            myConnection.Close()

        End Using

    End Sub

    Protected Sub BT_Generate1_Command(sender As Object, e As CommandEventArgs)

        Dim jid As Integer = CInt(Me.FormView1.DataKey("JenisLesen_ID"))
        Dim pid As Integer = GridView1.SelectedDataKey.Values(0)
        'Dim pid As Integer = CInt(Me.FormView1.DataKey("Permohonan_ID"))

        'MessageBox("Generate Mail " & pid.ToString & "/" & jid.ToString, Me)

        Dim rujukan As String = ""
        Dim isi1 As String = ""
        Dim isi2 As String = ""
        Dim tarikhmohon As String = ""
        Dim totalamount As Integer = 0

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQL As String = "SELECT JenisLesen_SuratBatalIKGagal1 AS isi1, JenisLesen_SuratBatalIKGagal2 AS isi2 FROM LESEN_JenisLesen WHERE JenisLesen_ID = @JenisLesen_ID"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@JenisLesen_ID", jid)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            Try
                If myReader.Read Then

                    isi1 = myReader.Item("isi1")
                    isi2 = myReader.Item("isi2")

                End If

            Catch ex As Exception

            End Try

            myReader.Close()
            myConnection.Close()

            myConnection.Open()

            Dim SQL1 As String = "UPDATE LESEN_Permohonan SET SuratPemeriksaan1 = @SuratPemeriksaan1, SuratPemeriksaan2 = @SuratPemeriksaan2 WHERE (Permohonan_ID = @Permohonan_ID)"

            Dim myCommandSelect1 As New SqlCommand(SQL1, myConnection)
            myCommandSelect1.Parameters.AddWithValue("@SuratPemeriksaan1", isi1)
            myCommandSelect1.Parameters.AddWithValue("@SuratPemeriksaan2", isi2)
            myCommandSelect1.Parameters.AddWithValue("@Permohonan_ID", pid)

            Try
                Dim result = myCommandSelect1.ExecuteNonQuery()
                GetSuratContent(pid)
                ShowAlert("success", "", "Surat pemeriksaan telah dijana.")
            Catch ex As Exception
                MessageBox("Error", Me)
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

        'Dim errStr As String = ""
        Dim isSuccess As Boolean = True
        Dim PermohonanID As Integer = CInt(GridView1.SelectedDataKey.Values(0))

        'MessageBox(PermohonanID, Me)

        If CB_SuratFail.Checked = False Then

            If TB_TarikhPeriksa.Text.Length = 0 Then

                ShowAlert("error", "", "Sila pilih tarikh pemeriksaan.")
                Return

            End If

            If TB_TarikhPeriksa.Text.Length = 0 Then

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

            EditorSurat1.Text = EditorSurat1.Text.Replace("{@TarikhPemeriksaan}", cvtDate)
            EditorSurat2.Text = EditorSurat2.Text.Replace("{@TarikhPemeriksaan}", cvtDate)

            Dim str1 = EditorSurat1.Text
            Dim str2 = EditorSurat2.Text

            str1 = str1.Replace("<div>", "").Replace("</div>", "")
            str2 = str2.Replace("<div>", "").Replace("</div>", "")

            Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

                myConnection.Open()

                Dim SQL As String = "UPDATE LESEN_Permohonan SET SuratPemeriksaan1 = @SuratPemeriksaan1, SuratPemeriksaan2 = @SuratPemeriksaan2, 
                                    TandatanganPemeriksaanId = @TandatanganPemeriksaanId, TarikhPemeriksaan = @TarikhPemeriksaan,
                                    TarikhSuratPemeriksaan = @TarikhSuratPemeriksaan, RujukanInspektorat = @RujukanInspektorat 
                                    WHERE Permohonan_ID = @Permohonan_ID"

                Dim myCommandSelect As New SqlCommand(SQL, myConnection)
                myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", PermohonanID)
                myCommandSelect.Parameters.AddWithValue("@SuratPemeriksaan1", str1)
                myCommandSelect.Parameters.AddWithValue("@SuratPemeriksaan2", str2)
                myCommandSelect.Parameters.AddWithValue("@TandatanganPemeriksaanId", ddlTandatangan.SelectedValue)
                myCommandSelect.Parameters.AddWithValue("@TarikhPemeriksaan", TB_TarikhPeriksa.Text)
                myCommandSelect.Parameters.AddWithValue("@TarikhSuratPemeriksaan", TB_TarikhSurat.Text)
                myCommandSelect.Parameters.AddWithValue("@RujukanInspektorat", TB_NoRujukan.Text)

                Try
                    Dim recordset As Integer = myCommandSelect.ExecuteNonQuery()
                    'ShowAlert("success", "", "Surat pemeriksaan telah dikemaskini.")
                Catch ex As Exception
                    'isSuccess = False
                    'MessageBox("ERROR1", Me)
                    'errStr = ex.Message
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
                            MessageBox("ERROR2", Me)
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
                MessageBox("ERROR", Me)
            End Try

            myReader.Close()
            myConnection.Close()

        End Using
    End Sub

    Private Sub GetSuratContent(pid As Integer)

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQL As String = "SELECT TarikhSuratPemeriksaan,SuratPemeriksaan1, SuratPemeriksaan2, TandatanganPemeriksaanId, TarikhPemeriksaan, RujukanInspektorat FROM LESEN_Permohonan WHERE Permohonan_ID = @Permohonan_ID"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            Try
                If myReader.Read Then

                    EditorSurat1.Text = myReader.Item("SuratPemeriksaan1").ToString
                    EditorSurat2.Text = myReader.Item("SuratPemeriksaan2").ToString

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

    Private Sub ViewSuratPemeriksaanAuto(permohonanID As String, jenislesenID As Integer, isPDF As Boolean)
        Dim sql As String = ""
        Dim jenisLesenDesc = {"", "sp_perniagaan", "sp_pasar", "sp_anjing", "sp_penjaja", "sp_billboard", "sp_tukaralamat", "sp_tambahpremis", "sp_tambahjenis",
            "sp_tukarpemilik", "sp_tukariklan", "sp_tukarnama", "sp_kurangiklan", "sp_kakilima", "sp_batal", "sp_ekspo", "sp_tambahiklan", "sp_tepikedai", "sp_lebuhawam",
            "sp_tukaralamatnamaiklan", "sp_tukarpemilikalamatiklan", "", "", "sp_tukarnamaiklan", "sp_tukarpemilikiklan", "sp_pasartambahpetak", "sp_tukarnamatambahpremis"}

        Try
            sql = "SELECT b.KadarBayaran_Desc, b.KadarBayaran_Amount, f.*, a.IsBatal, a.Rujukan, a.RujukanInspektorat, a.TarikhPemeriksaan, a.TarikhSuratPemeriksaan, a.SuratPemeriksaan1, a.SuratPemeriksaan2, " &
                    "c.Pemohon_Name, c.Pemohon_Address, c.Pemohon_ICNo, c.Pemohon_MobileNo, c.Pemohon_TelNo, d.Users_Fullname, d.Users_Signature, e.name AS AnjingJenisPremisDesc " &
                    "FROM LESEN_Permohonan a INNER JOIN LESEN_PermohonanPembetulan f ON a.Permohonan_ID = f.Permohonan_ID " &
                    "LEFT JOIN LESEN_KadarBayaran b ON b.KadarBayaran_PermohonanID = a.Permohonan_ID AND b.KadarBayaran_PermohonanAgensiID = 3 " &
                    "INNER JOIN LESEN_Pemohon c ON a.Permohonan_PemohonID = c.Pemohon_ID LEFT JOIN TBL_USERS d ON a.TandatanganPemeriksaanId = d.Users_Id " &
                    "LEFT JOIN TBL_LOOKUPS e ON e.id = a.AnjingJenisPremis " &
                    "WHERE a.Permohonan_ID=" & permohonanID

            If jenislesenID = 4 Then

                sql = "SELECT b.UlasanDesc, f.*, a.IsBatal, a.Rujukan, a.RujukanInspektorat, a.TarikhPemeriksaan, a.TarikhSuratPemeriksaan, a.SuratPemeriksaan1, a.SuratPemeriksaan2, c.Pemohon_Name, c.Pemohon_Address, " &
                        "c.Pemohon_ICNo, c.Pemohon_MobileNo, c.Pemohon_TelNo, d.Users_Fullname, d.Users_Signature " &
                        "FROM LESEN_Permohonan a INNER JOIN LESEN_PermohonanPembetulan f ON a.Permohonan_ID = f.Permohonan_ID LEFT JOIN LESEN_PenjajaUlasan b ON b.PermohonanID = a.Permohonan_ID " &
                        "INNER JOIN LESEN_Pemohon c ON a.Permohonan_PemohonID = c.Pemohon_ID LEFT JOIN TBL_USERS d ON a.TandatanganPemeriksaanId = d.Users_Id " &
                        "WHERE a.Permohonan_ID=" & permohonanID

            End If

            Dim ReportVar As String = jenisLesenDesc(jenislesenID)

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
			else
				Session.Item("reportPrintType") = ""
            End If

            ScriptManager.RegisterClientScriptBlock(Me.Page, Me.[GetType](), ReportVar, "window.open('../ReportViewer.aspx?name=" + ReportVar + "', '_blank', '');", True)
        Catch ex As Exception
            MessageBox(ex.Message, Me)
        End Try
    End Sub



    Protected Sub lbLihatSurat_Click(sender As Object, e As EventArgs)

        Dim jid As Integer = CInt(GridView1.SelectedDataKey.Values(4))
        Dim pid As Integer = CInt(GridView1.SelectedDataKey.Values(0))

        If GetIsSuratFail(pid) Then
            ViewSuratPemeriksaanFail(pid)
        Else
            ViewSuratPemeriksaanAuto(pid, jid, True)
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
            pnlSuratFail.Visible = True
            pnlSuratAuto.Visible = False
        Else
            pnlSuratFail.Visible = False
            pnlSuratAuto.Visible = True
        End If

    End Sub
	
    Private Sub rptWeek_ItemDataBound(sender As Object, e As RepeaterItemEventArgs) Handles rptWeek.ItemDataBound
        Try

            ' If e.Item.ItemType = ListItemType.AlternatingItem OrElse e.Item.ItemType = ListItemType.Item Then
            ' Dim hdn24jam As HiddenField = TryCast(e.Item.FindControl("hdn24jam"), HiddenField)

            ' If hdn24jam.Value = "True" Or Session.Item("sessionIsPeraku") = "True" Then
            ' btnApprove.Text = "Lulus"
            ' btnReject.Text = "Tolak"
            ' End If

            ' End If

            Dim txtNotaKelulusanPengesah As TextBox = DirectCast(fvNotaKelulusan.FindControl("txtNotaKelulusanPengesah"), TextBox)
            If e.Item.ItemType = ListItemType.AlternatingItem OrElse e.Item.ItemType = ListItemType.Item Then
                Dim hdn24jam As HiddenField = TryCast(e.Item.FindControl("hdn24jam"), HiddenField)
                'Dim hdnIsPelarasan As HiddenField = TryCast(e.Item.FindControl("hdnIsPelarasan"), HiddenField)

                If Session.Item("sessionIsPeraku") = "True" Then
                    btnApprove.Text = "Lulus"
                    btnReject.Text = "Tolak"
                End If

            End If

        Catch ex As Exception

        End Try
    End Sub

    Private Sub fvNotaKelulusan_DataBound(sender As Object, e As EventArgs) Handles fvNotaKelulusan.DataBound
        showFormControl(GridView1)
    End Sub	
	
    Protected Sub rblNotaKelulusanKJ_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim rblNotaKelulusanKJ As RadioButtonList = DirectCast(fvNotaKelulusan.FindControl("rblNotaKelulusanKJ"), RadioButtonList)
		Dim divNotaKelulusanPeraku As HtmlGenericControl = DirectCast(fvNotaKelulusan.FindControl("divNotaKelulusanPeraku"), HtmlGenericControl)

        If rblNotaKelulusanKJ.SelectedValue = 1 Or rblNotaKelulusanKJ.SelectedValue = 2 Or rblNotaKelulusanKJ.SelectedValue = 3 Then
            btnApprove.Visible = True
            btnReject.Visible = False
        ElseIf rblNotaKelulusanKJ.SelectedValue = 4 Then
            btnApprove.Visible = False
            btnReject.Visible = True
        Else
            btnApprove.Visible = True
            btnReject.Visible = True
        End If
		
		If rblNotaKelulusanKJ.SelectedValue = 6 or rblNotaKelulusanKJ.SelectedValue = 2 Then
            divNotaKelulusanPeraku.Visible = True
        Else
            divNotaKelulusanPeraku.Visible = False
        End If		

    End Sub		
	
    Protected Sub BT_ViewMU_Command(sender As Object, e As CommandEventArgs)
        Dim pid As Integer = GridView1.SelectedDataKey.Values(0)
        Dim AgensiID As String = "3"
        Dim JenisLesenID As Integer = GridView1.SelectedDataKey.Values(4)

        ViewSuratMohon(pid, AgensiID, JenisLesenID)

    End Sub		

End Class
