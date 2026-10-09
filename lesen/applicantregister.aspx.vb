
Partial Class applicantregister
    Inherits System.Web.UI.Page

    ' Page buka dengan senarai sahaja; borang dipaparkan bila Tambah / Kemaskini
    Private Sub ShowForm(show As Boolean)
        pnlForm.Visible = show
        pnlList.Visible = Not show
    End Sub

    Private Sub BackToList()
        GridView1.SelectedIndex = -1
        FormView1.ChangeMode(FormViewMode.Insert)
        ShowForm(False)
        GridView1.DataBind()
    End Sub

    Protected Sub btnTambah_Click(sender As Object, e As EventArgs) Handles btnTambah.Click
        GridView1.SelectedIndex = -1
        FormView1.ChangeMode(FormViewMode.Insert)
        ShowForm(True)
    End Sub

    Protected Sub FormView1_ItemCommand(sender As Object, e As FormViewCommandEventArgs) Handles FormView1.ItemCommand
        If e.CommandName = "Cancel" Then
            BackToList()
        End If
    End Sub

    Protected Sub FormView1_ItemInserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertedEventArgs) Handles FormView1.ItemInserted

        ShowAlert("success", "", "Rekod berjaya disimpan")
        BackToList()
    End Sub

    Protected Sub GridView1_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs) Handles GridView1.RowDeleting
        Dim lblNama As Label = DirectCast(GridView1.Rows(e.RowIndex).FindControl("lblNama"), Label)
        Dim title As String = If(lblNama IsNot Nothing, lblNama.Text, "")

        '//run audit trail : Insert : Update : Delete : Login : Logout
        GlobalClass.auditTrail(idWindowTitle.InnerText, title, "Nyah Aktif")
    End Sub

    Protected Sub GridView1_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles GridView1.SelectedIndexChanged
        FormView1.ChangeMode(DetailsViewMode.Edit)
        ShowForm(True)

        Dim titleTxt As TextBox = DirectCast(FormView1.FindControl("txtPemohon_Name"), TextBox)

        Page.SetFocus(titleTxt)

    End Sub

    '+++++++++ START FILTER +++++++++
    ' Parameter carian terikat pada txtCarian / ddlStatus; grid bind semula secara automatik
    Private Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearch.Click
        GridView1.PageIndex = 0
    End Sub

    Private Sub ddlStatus_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlStatus.SelectedIndexChanged
        GridView1.PageIndex = 0
    End Sub

    Private Sub btnReset_Click(sender As Object, e As EventArgs) Handles btnReset.Click
        Response.Redirect(Request.RawUrl)
    End Sub

    Private Sub SqlDataSourceGrid_Selected(sender As Object, e As SqlDataSourceStatusEventArgs) Handles SqlDataSourceGrid.Selected
        If e.Exception Is Nothing Then
            litJumlah.Text = String.Format("{0:N0} rekod", e.AffectedRows)
        End If
    End Sub
    '+++++++++ END FILTER +++++++++

    Protected Sub FormView1_ItemInserting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertEventArgs) Handles FormView1.ItemInserting
        Dim titleTxt As TextBox = DirectCast(FormView1.FindControl("txtPemohon_Name"), TextBox)
        Dim title As String = titleTxt.Text

        '//run audit trail : Insert : Update : Delete : Login : Logout
        GlobalClass.auditTrail(idWindowTitle.InnerText, title, "Kunci Masuk")
    End Sub

    Protected Sub FormView1_ItemUpdated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdatedEventArgs) Handles FormView1.ItemUpdated
        ShowAlert("success", "", "Rekod berjaya dikemaskini")
        e.KeepInEditMode = False
        BackToList()
    End Sub

    Protected Sub FormView1_ItemUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdateEventArgs) Handles FormView1.ItemUpdating
        Dim titleTxt As TextBox = DirectCast(FormView1.FindControl("txtPemohon_Name"), TextBox)
        Dim title As String = titleTxt.Text

        '//run audit trail : Insert : Update : Delete : Login : Logout
        GlobalClass.auditTrail(idWindowTitle.InnerText, title, "Kemaskini")
    End Sub

    Protected Sub Page_PreRenderComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRenderComplete

        Dim frmview() As Object = {FormView1}
        Dim lbutton() As Object = {} '//allow control
        Dim ctlDeny() As Object = {} '//deny control

        '//check Write
        Dim frmwrite As Boolean = GlobalClass.CheckPageWrite("Write", frmview, lbutton, ctlDeny)

        '// butang Tambah hanya pada paparan senarai & jika ada akses tulis
        btnTambah.Visible = pnlList.Visible AndAlso frmwrite

        '// check gridview permission
        If frmwrite = False Then
            GridView1.Columns.Item(GridView1.Columns.Count - 1).Visible = False '//grid kemaskini / nyah aktif
        End If
    End Sub

    Private Function GetMenuName() As String
        '// get page name
        Dim menuName As String = GlobalClass.writeTitlePage(Request.QueryString("m_Id"), "")
        If menuName = "" Then
            menuName = "Pemohon"
        End If
        Return menuName
    End Function

    Private Sub initPageName()
        Dim menuName As String = GetMenuName()

        Dim idWindowTitle2 As HtmlGenericControl = DirectCast(FormView1.FindControl("idWindowTitle2"), HtmlGenericControl)
        Dim idWindowTitle3 As HtmlGenericControl = DirectCast(FormView1.FindControl("idWindowTitle3"), HtmlGenericControl)

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

        '// rekod baru aktif secara default
        If FormView1.CurrentMode = FormViewMode.Insert Then
            Dim cbAktif As CheckBox = TryCast(FormView1.FindControl("CheckBox2"), CheckBox)
            If cbAktif IsNot Nothing Then cbAktif.Checked = True
        End If

    End Sub

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        '// tajuk page diperlukan walaupun borang belum dipaparkan
        If Not IsPostBack Then
            idWindowTitle.InnerText = GetMenuName()
        End If
    End Sub

    Protected Function GetInitial(name As Object) As String
        Dim s As String = Convert.ToString(name).Trim()
        If s = "" Then Return "?"
        Return s.Substring(0, 1).ToUpper()
    End Function

    Protected Function IsAktif(value As Object) As Boolean
        If value Is Nothing OrElse IsDBNull(value) Then Return False
        Return CBool(value)
    End Function

    Private Sub ShowAlert(statusMsg As String, titleMsg As String, strMsg As String)

        ScriptManager.RegisterStartupScript(Me, Page.GetType, "Script", "Swal.fire('" & titleMsg & "',
        '" & strMsg & "',
        '" & statusMsg & "');", True)

    End Sub

    Private Sub GridView1_RowDeleted(sender As Object, e As GridViewDeletedEventArgs) Handles GridView1.RowDeleted
        ShowAlert("success", "", "Rekod berjaya dikemaskini")
    End Sub
End Class
