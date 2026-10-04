Imports System
Imports System.Configuration
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Drawing.Imaging
Imports System.IO

Partial Class pembatalan1
    Inherits System.Web.UI.Page

#Region "Fields & Constants"

    Private ReadOnly CS As String = ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString
    Private Const MaxFileSizeInBytes As Integer = 10 * 1024 * 1024 ' 10 MB

#End Region

#Region "Page Lifecycle & Permissions"

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Page.Form.Attributes.Add("enctype", "multipart/form-data")

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
            ' Mobile view configuration for Ulasan tab
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

        ' Filter visibility based on Jabatan Lesen
        If Not getJabatanLesen(CInt(Session.Item("sessionEstateID"))) Then
            filterJenisLesen.Attributes.Add("style", "display:none")
            filterPemohon.Attributes.Add("style", "display:none")
        End If

        ' Show all ulasan checkbox for Penyedia / ReadOnly roles
        If Session.Item("sessionIsPenyedia") = "True" OrElse Session.Item("sessionIsReadOnly") = "True" Then
            divLihatSemuaUlasan.Visible = True
        Else
            divLihatSemuaUlasan.Visible = False
        End If
    End Sub

    Protected Sub Page_PreRenderComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRenderComplete
        Dim frmview() As Object = {FormView1}
        Dim lbutton() As Object = {}
        Dim ctlDeny() As Object = {}

        Dim frmwrite As Boolean = GlobalClass.CheckPageWrite("Write", frmview, lbutton, ctlDeny)
        If Not frmwrite Then
            GridView1.Columns.Item(5).Visible = False
        End If
    End Sub

    Private Sub initPageName()
        Dim menuName As String = GlobalClass.writeTitlePage(Request.QueryString("m_Id"), "")

        Dim idWindowTitle2 As HtmlGenericControl = DirectCast(FormView1.FindControl("idWindowTitle2"), HtmlGenericControl)
        Dim idWindowTitle3 As HtmlGenericControl = DirectCast(FormView1.FindControl("idWindowTitle3"), HtmlGenericControl)

        If String.IsNullOrEmpty(menuName) Then
            menuName = "Jenis Lesen"
        End If

        idWindowTitle.InnerText = menuName
        Try
            If idWindowTitle2 IsNot Nothing Then
                idWindowTitle2.InnerText &= " " & menuName
            End If
        Catch ex As Exception
        End Try

        Try
            If idWindowTitle3 IsNot Nothing Then
                idWindowTitle3.InnerText &= " " & menuName
            End If
        Catch ex As Exception
        End Try
    End Sub

#End Region

#Region "Filter & Search (Main GridView1)"

    Private Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearch.Click
        GridView1.DataBind()
    End Sub

    Private Sub btnReset_Click(sender As Object, e As EventArgs) Handles btnReset.Click
        Response.Redirect(Request.RawUrl)
    End Sub

    Protected Sub GridView1_PageIndexChanged(sender As Object, e As EventArgs) Handles GridView1.PageIndexChanged
        ' Custom page index filtering if needed
    End Sub

    Protected Sub GridView1_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles GridView1.SelectedIndexChanged
        FormView1.ChangeMode(DetailsViewMode.Edit)
        TabContainer1.Visible = True
        idFooter.Visible = True
        idListing.Visible = False
        idNotaKelulusan.Visible = False

        showOtherControl(GridView1)
    End Sub

    Protected Sub GridView1_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs) Handles GridView1.RowDeleting
        Dim title As String = GridView1.Rows(e.RowIndex).Cells(1).Text
        GlobalClass.auditTrail(idWindowTitle.InnerText, title, "Nyah Aktif")
    End Sub

    Private Sub GridView1_RowDeleted(sender As Object, e As GridViewDeletedEventArgs) Handles GridView1.RowDeleted
        ShowAlert("success", "", "Rekod berjaya dikemaskini")
    End Sub

    Protected Sub GridView1_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles GridView1.RowCommand
        If e.CommandName = "Surat" Then
            Dim intRow As Integer = CInt(e.CommandArgument)
            Dim Permohonan_ID As String = CStr(Me.GridView1.DataKeys(intRow)("Permohonan_ID"))
            Dim AgensiID As String = If(IsDBNull(Me.GridView1.DataKeys(intRow)("AgensiID")), CStr(Session.Item("sessionOCS")), CStr(Me.GridView1.DataKeys(intRow)("AgensiID")))
            Dim JenisLesenIdList As String = CStr(Me.GridView1.DataKeys(intRow)("JenisLesenIdList"))

            Dim res As Boolean = UpdateTotalViews(Permohonan_ID, AgensiID)
            If Not res Then
                MessageBox("ERROR_UpdateTotalViews", Me)
            End If

            ViewSuratMohon(Permohonan_ID, AgensiID, JenisLesenIdList)
        End If
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

#End Region

#Region "FormView Lifecycle & Controls Display"

    Private Sub FormView1_DataBound(sender As Object, e As EventArgs) Handles FormView1.DataBound
        initPageName()
        btnSaveLetter.Visible = True

        Try
            Dim ApprStatusID As Integer = CInt(GridView1.SelectedDataKey.Values(2))

            If ApprStatusID <> 3 AndAlso Session.Item("sessionIsPenilai") <> "True" OrElse Session.Item("sessionIsReadOnly") = "True" Then
                If (Session.Item("sessionIsPenilai") = "True" AndAlso ApprStatusID > 5) OrElse
                   (Session.Item("sessionIsPeraku") = "True" AndAlso ApprStatusID >= 9) Then
                    gvTabUlasan.Columns(5).Visible = "false"
                    gvTabUlasan.Columns(6).Visible = "false"
                    BT_Generate.Visible = False
                    idFooter.Visible = False
                    divBtnKembali.Visible = True
                End If
            End If

            If Session.Item("sessionIsPeraku") = "True" OrElse Session.Item("sessionIsPenilai") = "True" Then
                idFooter.Visible = True
                divBtnKembali.Visible = False
            End If
        Catch ex As Exception
        End Try
    End Sub

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

    Private Sub showOtherControl(gv1 As GridView)
        Session.Item("isDisablePrintSession") = "Y"

        Dim ApprStatusID As Integer = CInt(gv1.SelectedDataKey.Values(2))
        Dim PermohonanID As Integer = CInt(gv1.SelectedDataKey.Values(0))
        Dim IsFail As Boolean = CBool(gv1.SelectedDataKey.Values(5))
        Dim IsPenilaianStatus As Integer = CInt(gv1.SelectedDataKey.Values(6))

        ' Bind and check Kembali ke IK button
        GridView3.DataBind()
        btnKembaliIK.Visible = (Session("sessionEstateId")?.ToString() = "3" AndAlso
                                Session("sessionIsPenilai")?.ToString() = "True" AndAlso
                                ApprStatusID = 4)

        Dim agensiType As String = "L"
        Try
            tabKadarBayaran.Visible = False
            TabLampiran.Visible = False
            agensiType = If(IsDBNull(gv1.SelectedDataKey.Values(3)), "J", CStr(gv1.SelectedDataKey.Values(3)))

            If agensiType = "J" Then
                tabKadarBayaran.Visible = True
                TabLampiran.Visible = True

                If CStr(Session.Item("sessionOCS")) = "3" Then
                    tabSurat.Visible = True

                    If IsPenilaianStatus <> 0 OrElse Session.Item("sessionIsPenilai") = "True" Then
                        BT_ViewMail.Visible = True
                        Session.Item("isDisablePrintSession") = "N"
                    Else
                        Session.Item("isDisablePrintSession") = "Y"
                    End If

                    divTarikhSurat.Visible = (Session.Item("sessionIsPenilai") = "True")
                    GetSuratContent(PermohonanID)

                    If Session.Item("sessionIsPenyedia") = "True" AndAlso Session.Item("sessionIsReadOnly") = "True" Then
                        btnSubmit.Visible = False
                        tabSurat.Visible = False
                    End If
                End If

                If ApprStatusID = 3 OrElse ApprStatusID = 4 Then
                    BT_Generate.Visible = True

                    If Request.Browser.IsMobileDevice Then
                        tabSurat.Visible = False
                        tabKadarBayaran.Visible = False
                    End If

                    If IsFail Then
                        CB_SuratFail.Checked = True
                        pnlSuratAuto.Visible = False
                        pnlSuratFail.Visible = True
                        BT_Generate.Visible = False
                    Else
                        CB_SuratFail.Checked = False
                        pnlSuratAuto.Visible = True
                        pnlSuratFail.Visible = False
                        BT_Generate.Visible = True
                    End If

                    GetSuratFail(PermohonanID)
                Else
                    BT_Generate.Visible = False
                End If

                ' Approval remarks handling
                If ApprStatusID = 6 OrElse ApprStatusID = 7 OrElse ApprStatusID = 9 OrElse ApprStatusID = 10 Then
                    If Session.Item("sessionIsPeraku") = "True" OrElse Session.Item("sessionIsPenilai") = "True" Then
                        If getJabatanLesen(CInt(Session.Item("sessionEstateID"))) Then
                            btnApprove.Visible = False
                            btnReject.Visible = False
                            idNotaKelulusan.Visible = True

                            Dim divNotaKelulusanPeraku As HtmlGenericControl = DirectCast(fvNotaKelulusan.FindControl("divNotaKelulusanPeraku"), HtmlGenericControl)
                            If divNotaKelulusanPeraku IsNot Nothing Then
                                divNotaKelulusanPeraku.Visible = True
                            End If
                            fvNotaKelulusan.Enabled = False
                        End If
                    End If

                ElseIf ApprStatusID = 5 OrElse ApprStatusID = 8 Then
                    If Session.Item("sessionIsPeraku") = "True" OrElse Session.Item("sessionIsPenilai") = "True" Then
                        If getJabatanLesen(CInt(Session.Item("sessionEstateID"))) Then
                            If ApprStatusID = 8 AndAlso Session.Item("sessionIsPeraku") <> "True" Then
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
            ' Tetapan IK tab visibility
            If ApprStatusID = 2 Then
                If CInt(Session.Item("sessionOCS")) = 3 Then
                    tabTetapan.Visible = True
                    gvIK.Columns(1).Visible = "True"
                End If
            Else
                tabTetapan.Visible = False
                If CInt(Session.Item("sessionOCS")) = 3 Then
                    tabTetapan.Visible = True
                    gvIK.Columns(1).Visible = "false"
                End If
            End If
        Catch ex As Exception
        End Try
    End Sub

    Private Sub showFormControl(gv1 As GridView)
        Dim ApprStatusID As Integer = CInt(gv1.SelectedDataKey.Values(2))

        btnSubmit.Visible = False
        btnApprove.Visible = False
        btnReject.Visible = False
        idNotaKelulusan.Visible = False

        If ApprStatusID = 2 OrElse ApprStatusID = 3 OrElse ApprStatusID = 4 Then
            btnSubmit.Visible = True
            btnSubmit.Text = If(ApprStatusID = 2, "Simpan", "Hantar Ulasan")

            If Session.Item("sessionIsPenyedia") = "True" AndAlso Session.Item("sessionIsReadOnly") = "True" Then
                btnSubmit.Visible = False
            End If

        ElseIf ApprStatusID = 5 OrElse ApprStatusID = 8 Then
            If Session.Item("sessionIsPeraku") = "True" OrElse Session.Item("sessionIsPenilai") = "True" Then
                If getJabatanLesen(CInt(Session.Item("sessionEstateID"))) Then
                    If ApprStatusID = 8 AndAlso Session.Item("sessionIsPeraku") <> "True" Then
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

        ElseIf ApprStatusID = 6 OrElse ApprStatusID = 7 OrElse ApprStatusID = 9 OrElse ApprStatusID = 10 Then
            If Session.Item("sessionIsPeraku") = "True" OrElse Session.Item("sessionIsPenilai") = "True" Then
                If getJabatanLesen(CInt(Session.Item("sessionEstateID"))) Then
                    btnApprove.Visible = False
                    btnReject.Visible = False
                    idNotaKelulusan.Visible = True

                    Dim divNotaKelulusanPeraku As HtmlGenericControl = DirectCast(fvNotaKelulusan.FindControl("divNotaKelulusanPeraku"), HtmlGenericControl)
                    If divNotaKelulusanPeraku IsNot Nothing Then
                        divNotaKelulusanPeraku.Visible = True
                    End If
                    fvNotaKelulusan.Enabled = False
                End If
            End If
        End If
    End Sub

    Private Sub fvNotaKelulusan_DataBound(sender As Object, e As EventArgs) Handles fvNotaKelulusan.DataBound
        showFormControl(GridView1)
    End Sub

    Protected Sub rblNotaKelulusanKJ_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim rblNotaKelulusanKJ As RadioButtonList = DirectCast(fvNotaKelulusan.FindControl("rblNotaKelulusanKJ"), RadioButtonList)
        Dim divNotaKelulusanPeraku As HtmlGenericControl = DirectCast(fvNotaKelulusan.FindControl("divNotaKelulusanPeraku"), HtmlGenericControl)

        If rblNotaKelulusanKJ.SelectedValue = "1" OrElse rblNotaKelulusanKJ.SelectedValue = "2" OrElse rblNotaKelulusanKJ.SelectedValue = "3" Then
            btnApprove.Visible = True
            btnReject.Visible = False
        ElseIf rblNotaKelulusanKJ.SelectedValue = "4" Then
            btnApprove.Visible = False
            btnReject.Visible = True
        Else
            btnApprove.Visible = True
            btnReject.Visible = True
        End If

        If rblNotaKelulusanKJ.SelectedValue = "6" OrElse rblNotaKelulusanKJ.SelectedValue = "2" Then
            divNotaKelulusanPeraku.Visible = True
        Else
            divNotaKelulusanPeraku.Visible = False
        End If
    End Sub

#End Region

#Region "Workflow Actions (Submit, Approve, Reject)"

    Private Function checkMandatoryField() As Boolean
        Dim ApprStatusID As Integer = CInt(GridView1.SelectedDataKey.Values(2))
        Dim retval As Boolean = True

        If ApprStatusID = 4 Then
            If CB_SuratFail.Checked AndAlso ((FU_Lampiran1.Visible AndAlso Not FU_Lampiran1.HasFile) OrElse
                (HL_Lampiran1.Visible AndAlso HL_Lampiran1.Text.Length < 1)) Then
                ShowAlert("error", "", "Sila pilih fail surat yang ingin dimuat naik.")
                retval = False
            End If

            If Not CB_SuratFail.Checked Then
                If TB_TarikhPeriksa.Text.Length = 0 Then
                    ShowAlert("error", "", "Sila pilih tarikh pemeriksaan dan tekan simpan surat.")
                    retval = False
                End If

                If TB_TarikhSurat.Text.Length = 0 OrElse TB_TarikhSurat.Text.Contains("1900") Then
                    ShowAlert("error", "", "Sila pilih tarikh pengesahan dan tekan simpan surat.")
                    retval = False
                End If

                If TB_NoRujukan.Text.Length = 0 OrElse TB_NoRujukan.Text.Trim() = "MPK/599/401/" Then
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
        Dim agensiType As String = If(IsDBNull(GridView1.SelectedDataKey.Values(3)), "J", CStr(GridView1.SelectedDataKey.Values(3)))

        If agensiType <> "J" Then
            processSubmit()
        Else
            If checkMandatoryField() Then
                processSubmit()
            End If
        End If
    End Sub

    Private Sub processSubmit()
        Dim Permohonan_ID As Integer = CInt(GridView1.SelectedDataKey.Values(0))
        Dim AgensiID As Integer = If(IsDBNull(GridView1.SelectedDataKey.Values(1)), 0, CInt(GridView1.SelectedDataKey.Values(1)))
        Dim ApprStatusID As Integer = CInt(GridView1.SelectedDataKey.Values(2))

        Dim ddlSokongUlasan As DropDownList = DirectCast(fvSokongUlasan.FindControl("ddlSokongUlasan"), DropDownList)
        Dim txtNotaUlasan As TextBox = DirectCast(fvSokongUlasan.FindControl("txtNotaUlasan"), TextBox)
        Dim ddlPengesahSokongUlasan As DropDownList = DirectCast(fvSokongUlasan.FindControl("ddlPengesahSokongUlasan"), DropDownList)
        Dim txtPengesahNotaKelulusan As TextBox = DirectCast(fvSokongUlasan.FindControl("txtPengesahNotaKelulusan"), TextBox)
        Dim ikAssignCheck As Boolean = True

        Using myConnection As New SqlConnection(CS)
            Dim SQL As String = ""

            If AgensiID > 0 Then
                Dim fldName As String = "IsLawatanTapakUlasan"
                If ApprStatusID = 2 Then
                    fldName = "StatusID"
                    SQL = "UPDATE LESEN_PermohonanAgensiBatal SET " & fldName & " = 3, LastModDt = GETDATE(), ikAssign = @PengesahID " &
                          "WHERE Permohonan_ID = @Permohonan_ID AND CASE WHEN JabatanAgensi_ID IS NULL THEN 0 ELSE JabatanAgensi_ID END = @AgensiId "
                    ikAssignCheck = getikAssignCheck(Permohonan_ID)

                ElseIf ApprStatusID = 3 Then
                    fldName = "IsLawatanTapakUlasan"
                    SQL = "UPDATE LESEN_PermohonanAgensiBatal SET " & fldName & " = 1, LastModDt = GETDATE() " &
                          "WHERE Permohonan_ID = @Permohonan_ID AND CASE WHEN JabatanAgensi_ID IS NULL THEN 0 ELSE JabatanAgensi_ID END = @AgensiId "

                ElseIf ApprStatusID = 4 Then
                    fldName = "IsPenilaian"
                    SQL = "UPDATE LESEN_PermohonanAgensiBatal SET " & fldName & " = 1, LastModDt = GETDATE(), " &
                          "PengesahStatusID = @PengesahStatusID, PengesahNotaKelulusan = @PengesahNotaKelulusan, PengesahID = @PengesahID " &
                          "WHERE Permohonan_ID = @Permohonan_ID AND CASE WHEN JabatanAgensi_ID IS NULL THEN 0 ELSE JabatanAgensi_ID END = @AgensiId "

                    Try
                        Dim hdnFiedlJabatanAgensiType As HiddenField = DirectCast(fvSokongUlasan.FindControl("hdnFiedlJabatanAgensiType"), HiddenField)
                        If hdnFiedlJabatanAgensiType.Value = "L" Then
                            SQL &= ";UPDATE LESEN_PermohonanAgensiBatal SET " & fldName & " = 1, LastModDt = GETDATE(), " &
                                   "StatusID = @PengesahStatusID, NotaKelulusan = @PengesahNotaKelulusan " &
                                   "WHERE Permohonan_ID = @Permohonan_ID AND CASE WHEN JabatanAgensi_ID IS NULL THEN 0 ELSE JabatanAgensi_ID END = @AgensiId "
                        End If
                    Catch ex As Exception
                    End Try

                ElseIf ApprStatusID = 5 Then
                    fldName = "IsPeraku"
                    SQL = "UPDATE LESEN_PermohonanAgensiBatal SET " & fldName & " = 1, LastModDt = GETDATE(), " &
                          "StatusID = @StatusID, NotaKelulusan = @NotaKelulusan " &
                          "WHERE Permohonan_ID = @Permohonan_ID AND CASE WHEN JabatanAgensi_ID IS NULL THEN 0 ELSE JabatanAgensi_ID END = @AgensiId "
                End If
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

            If ikAssignCheck Then
                myConnection.Open()
                Dim recordset As Integer = myCommand.ExecuteNonQuery()

                If recordset > 0 Then
                    ShowAlert("success", "", "Rekod berjaya dihantar")
                    GridView1.DataBind()
                    backToList()
                End If
            Else
                ShowAlert("error", "", "Sila Pilih Staff")
            End If
        End Using
    End Sub

    Private Function getikAssignCheck(permohonan_ID As Integer) As Boolean
        Dim retval As Boolean = False

        Using myConnection As New SqlConnection(CS)
            Dim Sql As String = "SELECT 1 FROM LESEN_PermohonanAgensiBatal a " &
                                "INNER JOIN LESEN_PermohonanAgensiStaffBatal b ON b.PermohonanAgensi_ID = a.PermohonanAgensi_ID " &
                                "WHERE a.Permohonan_ID = @Permohonan_ID"
            Dim myCommand As New SqlCommand(Sql, myConnection)
            myCommand.Parameters.AddWithValue("@Permohonan_ID", permohonan_ID)

            myConnection.Open()
            Dim myReader As SqlDataReader = myCommand.ExecuteReader()
            If myReader.Read() Then
                retval = True
            End If
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

        Using myConnection As New SqlConnection(CS)
            Dim SQL As String = ""
            Dim statusUpdate As Integer = 7

            If ApprStatusID = 5 Then
                statusUpdate = 8
            ElseIf ApprStatusID = 8 Then
                statusUpdate = 10
            End If

            If AgensiID = 0 Then
                If ApprStatusID = 5 Then
                    SQL = "UPDATE LESEN_Permohonan SET StatusID = " & statusUpdate & ", StatusIDPengesah = 1, LastModDt = GETDATE(), " &
                          "LastModID = @SessionUserName, NotaKelulusanPengesahBatal = @NotaKelulusanPengesahBatal " &
                          "WHERE Permohonan_ID = @Permohonan_ID"
                ElseIf ApprStatusID = 8 Then
                    SQL = "UPDATE LESEN_Permohonan SET StatusID = " & statusUpdate & ", LastModDt = GETDATE(), " &
                          "LastModID = @SessionUserName, NotaKelulusanBatal = @NotaKelulusanBatal, NotaKelulusanKJ = @NotaKelulusanKJ " &
                          "WHERE Permohonan_ID = @Permohonan_ID"
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

            If recordset > 0 Then
                ShowAlert("success", "", "Rekod berjaya dihantar")
            End If
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

        Using myConnection As New SqlConnection(CS)
            Dim SQL As String = ""
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
                    SQL = "UPDATE LESEN_Permohonan SET StatusID = " & statusUpdate & ", StatusIDPengesah = 0, " &
                          "LastModDt = GETDATE(), LastModID = @SessionUserName, NotaKelulusanPengesahBatal = @NotaKelulusanPengesahBatal " &
                          "WHERE Permohonan_ID = @Permohonan_ID"
                Else
                    SQL = "UPDATE LESEN_Permohonan SET StatusID = " & statusUpdate & ", LastModDt = GETDATE(), " &
                          "LastModID = @SessionUserName, NotaKelulusanBatal = @NotaKelulusanBatal " &
                          "WHERE Permohonan_ID = @Permohonan_ID"
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

            If recordset > 0 Then
                ShowAlert("success", "", "Rekod berjaya dihantar")
            End If
        End Using

        GridView1.DataBind()
        backToList()
    End Sub

#End Region

#Region "Kembali Ke IK Workflow & Modal"

    Protected Sub btnKembaliIK_Click(sender As Object, e As EventArgs)
        Dim Permohonan_ID As Integer = CInt(GridView1.SelectedDataKey.Values(0))
        LoadKembaliIKList(Permohonan_ID)
        OpenModalKembaliIK()
    End Sub

    Protected Sub btnTeruskanKembaliIK_Click(sender As Object, e As EventArgs)
        Dim Permohonan_ID As Integer = CInt(GridView1.SelectedDataKey.Values(0))
        Dim Catatan As String = txtCatatanKembaliIK.Text.Trim()

        Using myConnection As New SqlConnection(CS)
            Dim SQL As String = "INSERT INTO LESEN_KembaliIK (Permohonan_ID, Catatan, CreatedBy, CreatedDt) " &
                                "VALUES (@Permohonan_ID, @Catatan, @CreatedBy, GETDATE()); " &
                                "UPDATE a SET a.IsComplete = 0 FROM LESEN_ApprovalListBatal a " &
                                "INNER JOIN LESEN_Permohonan b ON a.Permohonan_ID = b.Permohonan_ID " &
                                "INNER JOIN ApprovalStatusBatal c ON a.ApprStatusID = c.ApprStatusID " &
                                "WHERE a.Permohonan_ID = @Permohonan_ID AND a.ApprStatusID = 3"

            Dim myCommand As New SqlCommand(SQL, myConnection)
            myCommand.Parameters.AddWithValue("@Permohonan_ID", Permohonan_ID)
            myCommand.Parameters.AddWithValue("@Catatan", Catatan)
            myCommand.Parameters.AddWithValue("@CreatedBy", Session.Item("SessionUserName"))

            myConnection.Open()
            myCommand.ExecuteNonQuery()
        End Using

        txtCatatanKembaliIK.Text = ""
        ShowAlert("success", "", "Rekod berjaya dikembalikan ke IK")
        GridView1.DataBind()
        backToList()
    End Sub

    Private Sub LoadKembaliIKList(Permohonan_ID As Integer)
        Using myConnection As New SqlConnection(CS)
            Dim SQL As String = "SELECT Catatan, CreatedBy, CreatedDt FROM LESEN_KembaliIK WHERE Permohonan_ID = @Permohonan_ID ORDER BY CreatedDt DESC"
            Dim myCommand As New SqlCommand(SQL, myConnection)
            myCommand.Parameters.AddWithValue("@Permohonan_ID", Permohonan_ID)

            Dim da As New SqlDataAdapter(myCommand)
            Dim dt As New DataTable()
            da.Fill(dt)

            rptKembaliIK.DataSource = dt
            rptKembaliIK.DataBind()

            lblNoRecordKembaliIK.Visible = (dt.Rows.Count = 0)
        End Using
    End Sub

    Private Sub OpenModalKembaliIK()
        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "openModal",
            "document.getElementById('modalKembaliIK').classList.add('show');", True)
    End Sub

    Protected Sub GridView3_DataBound(sender As Object, e As EventArgs)
        Try
            Dim ApprStatusID As Integer = CInt(GridView1.SelectedDataKey.Values(2))
            pnlInfoNoticeKembaliIK.Visible = (ApprStatusID = 3 AndAlso GridView3.Rows.Count > 0)
        Catch ex As Exception
            pnlInfoNoticeKembaliIK.Visible = False
        End Try
    End Sub

#End Region

#Region "Tab 1: Surat Pemeriksaan (Auto & Fail)"

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
            Dim SQL As String = "SELECT TandatanganPemeriksaanId, TarikhPemeriksaan, TarikhSuratPemeriksaan, RujukanInspektorat FROM LESEN_Permohonan WHERE Permohonan_ID = @Permohonan_ID"
            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)
            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader()

            Try
                If myReader.Read() Then
                    If myReader.Item("TandatanganPemeriksaanId").ToString().Length > 0 Then
                        ddlTandatangan.SelectedValue = myReader.Item("TandatanganPemeriksaanId").ToString()
                    End If

                    If myReader.Item("RujukanInspektorat").ToString().Length > 0 Then
                        TB_NoRujukan.Text = myReader.Item("RujukanInspektorat").ToString()
                    End If

                    If Not IsDBNull(myReader.Item("TarikhPemeriksaan")) Then
                        TB_TarikhPeriksa.Text = CDate(myReader.Item("TarikhPemeriksaan")).ToString("yyyy-MM-dd")
                    End If

                    If Not IsDBNull(myReader.Item("TarikhSuratPemeriksaan")) Then
                        If CDate(myReader.Item("TarikhSuratPemeriksaan")).Year > 1900 Then
                            TB_TarikhSurat.Text = CDate(myReader.Item("TarikhSuratPemeriksaan")).ToString("yyyy-MM-dd")
                        End If
                    End If
                End If
            Catch ex As Exception
                MessageBox("ERROR", Me)
            End Try
        End Using
    End Sub

    Protected Sub BT_Generate_Command(sender As Object, e As CommandEventArgs)
        If TB_TarikhPeriksa.Text.Length = 0 Then
            ShowAlert("error", "", "Sila pilih tarikh pemeriksaan.")
            Return
        End If

        Dim jidList() As String = CStr(GridView1.SelectedDataKey.Values("JenisLesenIdList")).Split(","c)
        Dim pid As Integer = CInt(GridView1.SelectedDataKey.Values(0))
        Dim namatemplatList() As String = CStr(DDL_SuratTemplat.SelectedValue).Split(","c)
        Dim jenisrepot As String = namatemplatList(0)
        Dim namatemplat As String = namatemplatList(1)

        Dim rujukan As String = ""
        Dim jenisperniagaan As String = ""
        Dim jenispasar As String = ""
        Dim jumlahpetak As String = ""
        Dim jenisperniagaanpasar As String = ""
        Dim lokasipasar As String = ""
        Dim totalamount As Double = 0

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()

            Dim SQL4 As String = "SELECT Rujukan, CONVERT(varchar, TarikhMohon, 103) AS TarikhMohon, " &
                                 "IIF(JenisPerniagaanBaru IS NULL, JenisPerniagaan, JenisPerniagaanBaru) AS JenisPerniagaan, JenisPasar, " &
                                 "JenisPerniagaanPasar, JumlahPetak, LokasiPasar1, LokasiPasar2, LokasiPasar3 " &
                                 "FROM LESEN_Permohonan WHERE Permohonan_ID = @Permohonan_ID"

            Dim myCommandSelect4 As New SqlCommand(SQL4, myConnection)
            myCommandSelect4.Parameters.AddWithValue("@Permohonan_ID", pid)
            Dim myReader4 As SqlDataReader = myCommandSelect4.ExecuteReader()

            Try
                If myReader4.Read() Then
                    rujukan = myReader4.Item("Rujukan").ToString()
                    jenisperniagaan = myReader4.Item("JenisPerniagaan").ToString()
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
                End If
            Catch ex As Exception
                MessageBox(ex.Message, Me)
            End Try
            myReader4.Close()

            Dim SQL As String = "DELETE FROM LESEN_PermohonanSurat WHERE Permohonan_ID=@Permohonan_ID AND JenisReport LIKE 'LIK%'; " &
                                "INSERT INTO LESEN_PermohonanSurat (Permohonan_ID, JenisReport, P1, P2, P3, IsiKandungan, CreatedDt, ModDt) " &
                                "SELECT @Permohonan_ID AS Permohonan_ID, JenisReport, P1, P2, P3, " &
                                "REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( " &
                                "CAST(IsiKandungan AS VARCHAR(MAX)), '{@TahunIni}', @@TahunIni), " &
                                "'{@JumlahKadarBayaran}', @@JumlahKadarBayaran), " &
                                "'{@Rujukan}', IIF(CHARINDEX(' ', @@Rujukan) > 0, @@Rujukan, REPLACE(@@Rujukan, 'MPK/599/401/', 'MPK/599/401/ '))), " &
                                "'{@TarikhPemeriksaan}', @@TarikhPemeriksaan), " &
                                "'{@JenisPasar}', @@JenisPasar), " &
                                "'{@JenisPerniagaanPasar}', @@JenisPerniagaanPasar), " &
                                "'{@JumlahPetak}', @@JumlahPetak), " &
                                "'{@LokasiPasar}', @@LokasiPasar), " &
                                "'{@JenisPerniagaan}', @@JenisPerniagaan) AS IsiKandungan, " &
                                "GETDATE() AS CreatedDt, GETDATE() AS ModDt " &
                                "FROM LESEN_ReportTemplate " &
                                "WHERE JenisLesen_ID=@JenisLesen_ID AND JenisReport=@JenisReport AND NamaTemplat=@NamaTemplat;"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@JenisLesen_ID", jidList(0))
            myCommandSelect.Parameters.AddWithValue("@JenisReport", jenisrepot)
            myCommandSelect.Parameters.AddWithValue("@NamaTemplat", namatemplat)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)

            myCommandSelect.Parameters.AddWithValue("@@TahunIni", DateTime.Now.Year.ToString())
            myCommandSelect.Parameters.AddWithValue("@@JumlahKadarBayaran", totalamount.ToString("N2"))
            myCommandSelect.Parameters.AddWithValue("@@Rujukan", rujukan)
            myCommandSelect.Parameters.AddWithValue("@@JenisPerniagaan", jenisperniagaan.ToLower())
            myCommandSelect.Parameters.AddWithValue("@@JenisPasar", jenispasar)
            myCommandSelect.Parameters.AddWithValue("@@JenisPerniagaanPasar", jenisperniagaanpasar)
            myCommandSelect.Parameters.AddWithValue("@@JumlahPetak", jumlahpetak)
            myCommandSelect.Parameters.AddWithValue("@@LokasiPasar", lokasipasar)

            Dim cvtDate As String = CDate(TB_TarikhPeriksa.Text).ToString("dd/MM/yyyy")
            myCommandSelect.Parameters.AddWithValue("@@TarikhPemeriksaan", cvtDate)

            Try
                myCommandSelect.ExecuteNonQuery()
                ShowAlert("success", "", "Laporan pemeriksaan berjaya dijana.")
                GridViewReport.DataBind()
            Catch ex As Exception
                MessageBox(ex.Message, Me)
            End Try
        End Using
    End Sub

    Protected Sub BT_Generate1_Command(sender As Object, e As CommandEventArgs)
        Dim jid As Integer = CInt(Me.FormView1.DataKey("JenisLesen_ID"))
        Dim pid As Integer = CInt(GridView1.SelectedDataKey.Values(0))

        Dim isi1 As String = ""
        Dim isi2 As String = ""

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "SELECT JenisLesen_SuratBatalIKGagal1 AS isi1, JenisLesen_SuratBatalIKGagal2 AS isi2 FROM LESEN_JenisLesen WHERE JenisLesen_ID = @JenisLesen_ID"
            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@JenisLesen_ID", jid)
            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader()

            Try
                If myReader.Read() Then
                    isi1 = myReader.Item("isi1").ToString()
                    isi2 = myReader.Item("isi2").ToString()
                End If
            Catch ex As Exception
            End Try
            myReader.Close()

            Dim SQL1 As String = "UPDATE LESEN_Permohonan SET SuratPemeriksaan1 = @SuratPemeriksaan1, SuratPemeriksaan2 = @SuratPemeriksaan2 WHERE Permohonan_ID = @Permohonan_ID"
            Dim myCommandSelect1 As New SqlCommand(SQL1, myConnection)
            myCommandSelect1.Parameters.AddWithValue("@SuratPemeriksaan1", isi1)
            myCommandSelect1.Parameters.AddWithValue("@SuratPemeriksaan2", isi2)
            myCommandSelect1.Parameters.AddWithValue("@Permohonan_ID", pid)

            Try
                myCommandSelect1.ExecuteNonQuery()
                GetSuratContent(pid)
                ShowAlert("success", "", "Surat pemeriksaan telah dijana.")
            Catch ex As Exception
                MessageBox("Error", Me)
            End Try
        End Using
    End Sub

    Protected Sub btnSaveLetter_Click(sender As Object, e As EventArgs)
        If CB_SuratFail.Checked AndAlso ((FU_Lampiran1.Visible AndAlso Not FU_Lampiran1.HasFile) OrElse
            (HL_Lampiran1.Visible AndAlso HL_Lampiran1.Text.Length < 1)) Then
            ShowAlert("error", "", "Sila pilih fail surat yang ingin dimuat naik.")
            Return
        End If

        Dim isSuccess As Boolean = True
        Dim PermohonanID As Integer = CInt(GridView1.SelectedDataKey.Values(0))

        If Not CB_SuratFail.Checked Then
            If TB_TarikhPeriksa.Text.Length = 0 Then
                ShowAlert("error", "", "Sila pilih tarikh pemeriksaan.")
                Return
            End If

            If TB_NoRujukan.Text.Length = 0 OrElse TB_NoRujukan.Text.Trim() = "MPK/599/401/" Then
                ShowAlert("error", "", "Sila isi no rujukan.")
                Return
            End If

            If ddlTandatangan.SelectedIndex = 0 Then
                ShowAlert("error", "", "Sila pilih tandatangan.")
                Return
            End If

            Using myConnection As New SqlConnection(CS)
                myConnection.Open()
                Dim SQL As String = "UPDATE LESEN_Permohonan SET TandatanganPemeriksaanId = @TandatanganPemeriksaanId, TarikhPemeriksaan = @TarikhPemeriksaan, " &
                                    "TarikhSuratPemeriksaan = @TarikhSuratPemeriksaan, RujukanInspektorat = @RujukanInspektorat " &
                                    "WHERE Permohonan_ID = @Permohonan_ID"

                Dim myCommandSelect As New SqlCommand(SQL, myConnection)
                myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", PermohonanID)
                myCommandSelect.Parameters.AddWithValue("@TandatanganPemeriksaanId", ddlTandatangan.SelectedValue)
                myCommandSelect.Parameters.AddWithValue("@TarikhPemeriksaan", TB_TarikhPeriksa.Text)
                myCommandSelect.Parameters.AddWithValue("@TarikhSuratPemeriksaan", TB_TarikhSurat.Text)
                myCommandSelect.Parameters.AddWithValue("@RujukanInspektorat", TB_NoRujukan.Text)

                Try
                    myCommandSelect.ExecuteNonQuery()
                Catch ex As Exception
                    isSuccess = False
                    MessageBox("ERROR", Me)
                End Try
            End Using
        End If

        Dim uid As Guid = Guid.NewGuid()

        If FU_Lampiran1.HasFile Then
            Dim fn As String = System.IO.Path.GetFileName(FU_Lampiran1.PostedFile.FileName)
            Dim localPath As String = "~/doc/" & uid.ToString() & fn
            Dim SaveLocation As String = Server.MapPath(localPath)

            If FU_Lampiran1.PostedFile IsNot Nothing AndAlso FU_Lampiran1.PostedFile.ContentLength > 0 Then
                If updateUploadFile(FU_Lampiran1, SaveLocation) Then
                    Using myConnection As New SqlConnection(CS)
                        myConnection.Open()
                        Dim SQL As String = "INSERT INTO LESEN_PermohonanFail (PermohonanFail_PermohonanID, PermohonanFail_ContentType, PermohonanFail_FileName, PermohonanFail_FilePath, PermohonanFail_JenisLampiran) " &
                                            "VALUES (@Permohonan_ID, @ContentType, @FileName, @FilePath, 'SP')"

                        Dim myCommandSelect As New SqlCommand(SQL, myConnection)
                        myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", PermohonanID)
                        myCommandSelect.Parameters.AddWithValue("@FileName", FU_Lampiran1.PostedFile.FileName)
                        myCommandSelect.Parameters.AddWithValue("@ContentType", FU_Lampiran1.PostedFile.ContentType)
                        myCommandSelect.Parameters.AddWithValue("@FilePath", localPath)

                        Try
                            myCommandSelect.ExecuteNonQuery()
                            GetSuratFail(PermohonanID)
                        Catch ex As Exception
                            isSuccess = False
                            MessageBox("ERROR2", Me)
                        End Try
                    End Using
                End If
            End If
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

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "SELECT PermohonanFail_FileName, PermohonanFail_FilePath, PermohonanFail_JenisLampiran FROM LESEN_PermohonanFail WHERE PermohonanFail_JenisLampiran = 'SP' AND PermohonanFail_PermohonanID = @Permohonan_ID"
            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)
            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader()

            Try
                If myReader.Read() Then
                    HL_Lampiran1.Text = myReader.Item("PermohonanFail_FileName").ToString()
                    HL_Lampiran1.NavigateUrl = myReader.Item("PermohonanFail_FilePath").ToString()

                    FU_Lampiran1.Visible = False
                    BT_Cancel1.Visible = False
                    HL_Lampiran1.Visible = True
                    BT_Update1.Visible = True
                    BT_Delete1.Visible = True
                End If
            Catch ex As Exception
                MessageBox("ERROR", Me)
            End Try
        End Using
    End Sub

    Protected Sub DeleteSuratFail()
        Dim pid As Integer = CInt(GridView1.SelectedDataKey.Values(0))

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "DELETE FROM LESEN_PermohonanFail WHERE PermohonanFail_JenisLampiran = 'SP' AND PermohonanFail_PermohonanID = @Permohonan_ID"
            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)

            Try
                Dim result As Integer = myCommandSelect.ExecuteNonQuery()
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

    Protected Sub lbLihatSurat_Click(sender As Object, e As EventArgs)
        Dim pid As Integer = CInt(GridView1.SelectedDataKey.Values(0))
        If GetIsSuratFail(pid) Then
            ViewSuratPemeriksaanFail(pid.ToString())
        Else
            ViewSuratPemeriksaanAuto(pid.ToString(), True)
        End If
    End Sub

    Protected Sub BT_ViewMail_Command(sender As Object, e As CommandEventArgs)
        Dim pid As Integer = CInt(GridView1.SelectedDataKey.Values(0))
        If GetIsSuratFail(pid) Then
            ViewSuratPemeriksaanFail(pid.ToString())
        Else
            If CStr(Session.Item("isDisablePrintSession")) = "Y" Then
                ViewSuratPemeriksaanAuto(pid.ToString(), False)
            Else
                ViewSuratPemeriksaanAuto(pid.ToString(), True)
            End If
        End If
    End Sub

    Private Sub ViewSuratPemeriksaanFail(permohonanID As String)
        Dim filepath As String = ""

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "SELECT PermohonanFail_FilePath FROM LESEN_PermohonanFail WHERE PermohonanFail_PermohonanID = @permohonanID AND PermohonanFail_JenisLampiran = 'SP'"
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

    Private Sub ViewSuratPemeriksaanAuto(permohonanID As String, isPDF As Boolean)
        Dim sql As String = ""
        Dim jenisLesenDesc = {"mpk_suratpemeriksaan"}

        Try
            sql = "SELECT a.Permohonan_ID, a.TarikhPemeriksaan, 'True' AS IsDigitalSign, CAST(a.TarikhSuratPemeriksaan AS datetime) AS TarikhSuratPemeriksaan, " &
                  "CAST(a.NamaSyarikat AS varchar(200)) AS NamaSyarikat, a.NoPendaftaran, a.NoAkaun, a.AlamatPremis, a.JenisPerniagaan, a.PemilikBaru, a.AlamatBaru, " &
                  "a.JenisPerniagaanBaru, a.NamaBaruSyarikat, a.BillboardLokasi, a.LokasiPasar1, a.LokasiPasar2, a.LokasiPasar3, a.JenisPasar, a.JenisPerniagaanPasar, " &
                  "a.JumlahPetak, a.AnjingAlamat, e.name AS AnjingJenisPremisDesc, a.AnjingJenisPremis, a.AlamatPenjajaan, a.JenisPerniagaanPenjaja, a.TarikhBatal, " &
                  "a.PenganjurEkspo, a.NamaEkspo, a.LokasiEkspo, a.NoTelEkspo, a.TarikhEkspo1, a.TarikhEkspo2, a.MasaEkspo1, a.MasaEkspo2, a.KontraktorIklan, " &
                  "a.NoTelKontraktor, a.UkuranBanting, a.BilBanting, a.TarikhBanting1, a.TarikhBanting2, a.NoResitBanting, a.NoSiriStiker, a.TarikhBanting3, " &
                  "a.Rujukan, a.RujukanInspektorat, a.NoAkaunCukai, a.IsBatal, a.JenisLesenDescList, a.JenisLesenIdList, a.SaizIklanList, a.CahayaIklanList, " &
                  "a.UnitIklanList, a.LokasiList, a.BakaAnjingList, a.AnjingJantanList, a.AnjingBetinaList, a.AnjingJantanMandulList, a.AnjingBetinaMandulList, " &
                  "b.Pemohon_Name, b.Pemohon_Address, b.Pemohon_ICNo, b.Pemohon_MobileNo, b.Pemohon_TelNo, c.Users_Fullname, c.Users_Signature, " &
                  "d.P1, d.P2, d.P3, d.IsiKandungan " &
                  "FROM LESEN_Permohonan a " &
                  "INNER JOIN LESEN_Pemohon b ON b.Pemohon_ID=a.Permohonan_PemohonID " &
                  "LEFT JOIN TBL_USERS c ON a.TandatanganPemeriksaanId=c.Users_Id " &
                  "LEFT JOIN LESEN_PermohonanSurat d ON d.Permohonan_ID=a.Permohonan_ID AND d.JenisReport LIKE 'LIB%' " &
                  "LEFT JOIN TBL_LOOKUPS e ON e.id = a.AnjingJenisPremis " &
                  "WHERE a.Permohonan_ID=@permohonanID ORDER BY d.P1, d.P2, d.P3"

            sql = sql.Replace("@permohonanID", permohonanID)

            Dim ReportVar As String = jenisLesenDesc(0)
            Dim pobjData(0, 1) As Object
            Dim lStrReportName As String = ReportVar & ".rpt"

            pobjData(0, 0) = "paraSQL" : pobjData(0, 1) = sql

            Session.Item("ReportName" & ReportVar) = lStrReportName
            Session.Item("pobjData" & ReportVar) = pobjData
            Session.Item("pathUrl" & ReportVar) = "~/lesen/report/pemeriksaan"
            Session.Item("reportPrintType") = If(isPDF, "pdf", "")

            ScriptManager.RegisterClientScriptBlock(Me.Page, Me.GetType(), ReportVar, "window.open('../ReportViewer.aspx?name=" & ReportVar & "', '_blank', '');", True)
        Catch ex As Exception
            MessageBox(ex.Message, Me)
        End Try
    End Sub

    Private Function GetIsSuratFail(pid As Integer) As Boolean
        Dim isFail As Boolean = False

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "SELECT IsSuratPemeriksaanFail FROM LESEN_Permohonan WHERE Permohonan_ID = @Permohonan_ID"
            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)
            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader()

            Try
                If myReader.Read() Then
                    isFail = CBool(myReader.Item("IsSuratPemeriksaanFail"))
                End If
            Catch ex As Exception
                MessageBox("ERROR", Me)
            End Try
        End Using

        Return isFail
    End Function

#End Region

#Region "Tab 2: Ulasan IK & Agensi Luar"

    Protected Sub btnAddNewUpload_Click(sender As Object, e As EventArgs)
        Dim Permohonan_ID As Integer = CInt(GridView1.SelectedDataKey.Values(0))
        Dim AgensiID As Integer = If(IsDBNull(GridView1.SelectedDataKey.Values(1)), 0, CInt(GridView1.SelectedDataKey.Values(1)))
        Dim ApprStatusID As Integer = CInt(GridView1.SelectedDataKey.Values(2))

        Using myConnection As New SqlConnection(CS)
            Dim SQL As String = "INSERT INTO LESEN_UlasanFailBatal (UlasanFail_PermohonanID, UlasanFail_PermohonanAgensiID, UlasanFail_UserID, CreatedDt, CreatorID) " &
                                "VALUES (@Permohonan_ID, CASE WHEN @AgensiId = 0 THEN NULL ELSE @AgensiId END, @SessionUsersID, GETDATE(), @SessionUserName)"

            Dim myCommand As New SqlCommand(SQL, myConnection)
            myCommand.Parameters.AddWithValue("@Permohonan_ID", Permohonan_ID)
            myCommand.Parameters.AddWithValue("@AgensiId", AgensiID)
            myCommand.Parameters.AddWithValue("@ApprStatusID", ApprStatusID)
            myCommand.Parameters.AddWithValue("@SessionUsersId", Session.Item("SessionUsersId"))
            myCommand.Parameters.AddWithValue("@SessionUserName", Session.Item("SessionUserName"))

            myConnection.Open()
            Dim recordset As Integer = myCommand.ExecuteNonQuery()

            If recordset > 0 Then
                gvTabUlasan.EditIndex = CInt(gvTabUlasan.Rows.Count)
            End If

            gvTabUlasan.DataBind()
            Page.SetFocus(Me.ui_btnPageBottom.ClientID)
        End Using
    End Sub

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

    Protected Sub btnUpload_Click(sender As Object, e As EventArgs)
        ' Async trigger stub for file upload
    End Sub

#End Region

#Region "Tab 3: Tetapan IK (Pegawai Assign)"

    Protected Sub CheckBox1_CheckedChanged(sender As Object, e As EventArgs)
        Try
            Dim Permohonan_ID As Integer = CInt(GridView1.SelectedDataKey.Values(0))
            Dim AgensiID As Integer = CInt(GridView1.SelectedDataKey.Values(1))

            Dim row As GridViewRow = CType(CType(sender, CheckBox).NamingContainer, GridViewRow)
            Dim index As Integer = row.RowIndex
            Dim cb1 As CheckBox = CType(gvIK.Rows(index).FindControl("cbSelect"), CheckBox)
            Dim hdID As HiddenField = CType(gvIK.Rows(index).FindControl("hdID"), HiddenField)

            Using myConnection As New SqlConnection(CS)
                Dim SQL As String = ""

                If cb1.Checked Then
                    SQL = "INSERT INTO LESEN_PermohonanAgensiStaffBatal (PermohonanAgensiStaffID_UsersID, PermohonanAgensi_ID) " &
                          "SELECT TOP 1 @usersID, a.PermohonanAgensi_ID FROM LESEN_PermohonanAgensiBatal a " &
                          "WHERE a.Permohonan_ID = @Permohonan_ID AND a.JabatanAgensi_ID = @AgensiId"
                Else
                    SQL = "DELETE a FROM LESEN_PermohonanAgensiStaffBatal a " &
                          "WHERE a.PermohonanAgensiStaffID_UsersID = @usersID " &
                          "AND PermohonanAgensi_ID IN (SELECT x.PermohonanAgensi_ID FROM LESEN_PermohonanAgensiBatal x " &
                          "WHERE x.Permohonan_ID=@Permohonan_ID AND x.JabatanAgensi_ID=@AgensiId)"
                End If

                Dim myCommand As New SqlCommand(SQL, myConnection)
                myCommand.Parameters.AddWithValue("@Permohonan_ID", Permohonan_ID)
                myCommand.Parameters.AddWithValue("@AgensiId", AgensiID)
                myCommand.Parameters.AddWithValue("@usersID", CInt(hdID.Value))

                myConnection.Open()
                Dim recordset As Integer = myCommand.ExecuteNonQuery()

                If recordset > 0 Then
                    gvTabUlasan.EditIndex = CInt(gvTabUlasan.Rows.Count)
                End If
            End Using
        Catch ex As Exception
        End Try
    End Sub

#End Region

#Region "Report & Letter Generation"

    Protected Sub BT_ViewMU_Command(sender As Object, e As CommandEventArgs)
        Dim pid As Integer = CInt(GridView1.SelectedDataKey.Values(0))
        Dim AgensiID As String = "3"
        Dim JenisLesenID As String = CStr(GridView1.SelectedDataKey.Values(4))

        Dim res As Boolean = UpdateTotalViews(pid.ToString(), AgensiID)
        If Not res Then
            MessageBox("ERROR_UpdateTotalViews", Me)
        End If

        ViewSuratMohon(pid.ToString(), AgensiID, JenisLesenID)
    End Sub

    Private Sub ViewSuratMohon(permohonanID As String, agensiID As String, JenisLesenIdList As String)
        Dim sql As String = ""
        Dim jenisLesenDesc = {"mpk_suratmohonulasan", "mpk_suratmohonulasan_psr", "mpk_suratmohonulasan_anj", "mpk_suratmohonulasan_pjj", "mpk_suratmohonulasan_bb", "mpk_suratmohonulasan_ep"}
        Dim jenisLesenDescLuar = {"mpk_suratmohonulasan_l", "mpk_suratmohonulasan_psr_l", "mpk_suratmohonulasan_anj_l", "mpk_suratmohonulasan_pjj_l", "mpk_suratmohonulasan_bb_l", "mpk_suratmohonulasan_ep_l"}

        Try
            sql = "SELECT a.Permohonan_ID, a.TarikhMohon, a.CreatedDt, CAST(a.NamaSyarikat AS varchar(200)) AS NamaSyarikat, a.NoPendaftaran, a.NoAkaun, a.AlamatPremis, a.JenisPerniagaan, a.PemilikBaru, " &
                  "a.AlamatBaru, a.JenisPerniagaanBaru, a.NamaBaruSyarikat, a.BillboardLokasi, a.LokasiPasar1, a.LokasiPasar2, a.LokasiPasar3, a.JenisPasar, a.JenisPerniagaanPasar, a.JumlahPetak, a.AnjingAlamat, " &
                  "a.AnjingJenisMohon, a.AnjingJenisPremis, a.AlamatPenjajaan, a.JenisPerniagaanPenjaja, a.TarikhBatal, a.PenganjurEkspo, a.NamaEkspo, a.LokasiEkspo, a.NoTelEkspo, a.TarikhEkspo1, a.TarikhEkspo2, " &
                  "a.KontraktorIklan, a.NoTelKontraktor, a.UkuranBanting, a.BilBanting, a.TarikhBanting1, a.TarikhBanting2, a.NoResitBanting, a.NoSiriStiker, a.TarikhBanting3, " &
                  "a.MasaEkspo1, a.MasaEkspo2, a.Rujukan, a.NoAkaunCukai, a.IsBatal, a.JenisLesenDescList, a.JenisLesenIdList, a.SaizIklanList, a.CahayaIklanList, a.UnitIklanList, a.LokasiList, a.BakaAnjingList, a.AnjingJantanList, " &
                  "a.AnjingBetinaList, a.AnjingJantanMandulList, a.AnjingBetinaMandulList, e.JabatanAgensi_Address, e.JabatanAgensi_Kepada, b.Pemohon_Name, b.Pemohon_ICNo, b.Pemohon_PassportNo, b.Pemohon_Address, " &
                  "b.Pemohon_Email, b.Pemohon_MobileNo, b.Pemohon_TelNo, g.Users_Fullname, g.Users_Signature " &
                  "FROM LESEN_Permohonan a " &
                  "INNER JOIN LESEN_Pemohon b ON a.Permohonan_PemohonID = b.Pemohon_ID " &
                  "INNER JOIN LESEN_PermohonanAgensiBatal d ON a.Permohonan_ID = d.Permohonan_ID " &
                  "INNER JOIN LESEN_JabatanAgensi e ON d.JabatanAgensi_ID = e.JabatanAgensi_ID " &
                  "LEFT JOIN TBL_USERS g ON g.Users_Id = (CASE WHEN e.JabatanAgensi_Type = 'J' THEN a.TandatanganMohonUlasanId WHEN e.JabatanAgensi_Type = 'L' THEN a.TandatanganMohonUlasanLuarId END) " &
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
                Case "15"
                    ReportVar = jenisLesenDesc(5)
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

    Private Function UpdateTotalViews(permohonanID As String, agensiID As String) As Boolean
        Try
            Using myConnection As New SqlConnection(CS)
                Dim SQL As String = "UPDATE LESEN_PermohonanAgensi SET totalViews = totalViews + 1 WHERE Permohonan_ID = @Permohonan_ID AND JabatanAgensi_ID = @AgensiId"
                Dim myCommand As New SqlCommand(SQL, myConnection)
                myCommand.Parameters.AddWithValue("@Permohonan_ID", permohonanID)
                myCommand.Parameters.AddWithValue("@AgensiId", agensiID)

                myConnection.Open()
                Dim recordset As Integer = myCommand.ExecuteNonQuery()
                Return (recordset > 0)
            End Using
        Catch ex As Exception
            MessageBox(ex.Message, Me)
            Return False
        End Try
    End Function

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

    Private Sub rptWeek_ItemDataBound(sender As Object, e As RepeaterItemEventArgs) Handles rptWeek.ItemDataBound
        Try
            If e.Item.ItemType = ListItemType.AlternatingItem OrElse e.Item.ItemType = ListItemType.Item Then
                If Session.Item("sessionIsPeraku") = "True" Then
                    btnApprove.Text = "Lulus"
                    btnReject.Text = "Tolak"
                End If
            End If
        Catch ex As Exception
        End Try
    End Sub

#End Region

#Region "File Upload & Scaling Helpers"

    Private Function updateUploadFile(txtUlasanFail_FilePath As FileUpload, saveLocation As String) As Boolean
        Dim retval As Boolean = True

        If (txtUlasanFail_FilePath.PostedFile IsNot Nothing) AndAlso (txtUlasanFail_FilePath.PostedFile.ContentLength > 0) Then
            Try
                Dim fileExtension As String = txtUlasanFail_FilePath.PostedFile.ContentType
                Dim fileLength As Integer = txtUlasanFail_FilePath.PostedFile.ContentLength

                If fileExtension = "image/jpeg" OrElse fileExtension = "image/x-png" Then
                    If fileLength <= MaxFileSizeInBytes Then
                        Using bmpPostedImage As New System.Drawing.Bitmap(txtUlasanFail_FilePath.PostedFile.InputStream)
                            Using objImage As System.Drawing.Image = ScaleImage(bmpPostedImage, 1024)
                                objImage.Save(saveLocation, ImageFormat.Jpeg)
                            End Using
                        End Using
                        ShowAlert("success", "", "Fail berjaya dimuatnaik")
                    Else
                        ShowAlert("error", "", "Saiz imej tidak boleh melebihi 10MB!")
                        retval = False
                    End If
                Else
                    If fileExtension = "application/pdf" Then
                        If fileLength <= MaxFileSizeInBytes Then
                            Try
                                txtUlasanFail_FilePath.PostedFile.SaveAs(saveLocation)
                            Catch ex As Exception
                                MessageBox(ex.Message, Me)
                            End Try
                            ShowAlert("success", "", "Fail berjaya dimuatnaik")
                        Else
                            ShowAlert("error", "", "Saiz fail tidak boleh melebihi 10MB!")
                            retval = False
                        End If
                    Else
                        ShowAlert("error", "", "Format Fail PDF Sahaja!")
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
