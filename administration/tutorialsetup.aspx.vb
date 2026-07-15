
Imports System.Data.SqlClient

Partial Class administration_checkrolltutorial
    Inherits System.Web.UI.Page

    Public pathUrlVideo As String = "/tutorial/checkroll/video/"
    Public pathUrlPdf As String = "/tutorial/checkroll/pdf/"

    Private Sub FormView1_ItemUpdated(sender As Object, e As FormViewUpdatedEventArgs) Handles FormView1.ItemUpdated

        Dim titleTxt As TextBox = DirectCast(FormView1.FindControl("tutorial_NameTextBox"), TextBox)
        Dim title As String = titleTxt.Text

        '//run audit trail : Insert : Update : Delete : Login : Logout
        GlobalClass.auditTrail(idWindowTitle.InnerText, title, "Update")
        GridView1.DataBind()
        CallFilter()
    End Sub

    Protected Sub GridView1_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs) Handles GridView1.RowDeleting
        Dim title As String = GridView1.Rows(e.RowIndex).Cells(1).Text

        '//run audit trail : Insert : Update : Delete : Login : Logout
        GlobalClass.auditTrail(idWindowTitle.InnerText, title, "Delete")
    End Sub


    Protected Sub GridView1_RowUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewUpdateEventArgs) Handles GridView1.RowUpdating

        Dim row = GridView1.Rows(e.RowIndex)
        Dim title As String = (CType((row.Cells(1).Controls(0)), TextBox)).Text

        '//run audit trail : Insert : Update : Delete : Login : Logout
        GlobalClass.auditTrail(idWindowTitle.InnerText, title, "Update")
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
            GridView1.Columns.Item(4).Visible = False '//grid delete
            FormView1.Visible = False
        End If
    End Sub

    Private Sub FormView1_ItemInserting(sender As Object, e As FormViewInsertEventArgs) Handles FormView1.ItemInserting
        e.Values("CreatedDt") = DateTime.Now

        Dim titleTxt As TextBox = DirectCast(FormView1.FindControl("tutorial_NameTextBox"), TextBox)
        Dim title As String = titleTxt.Text

        '//run audit trail : Insert : Update : Delete : Login : Logout
        GlobalClass.auditTrail(idWindowTitle.InnerText, title, "Insert")
    End Sub

    Private Sub FormView1_ItemInserted(sender As Object, e As FormViewInsertedEventArgs) Handles FormView1.ItemInserted

        'If e.Exception Is Nothing Then

        '    If e.AffectedRows = 1 Then
        '        MessageLabel.Text = "Record inserted successfully."
        '    Else
        '        MessageLabel.Text = "An error occurred during the insert operation."
        '        e.KeepInInsertMode = True
        '    End If
        'Else
        '    MessageLabel.Text = e.Exception.Message
        '    e.ExceptionHandled = True
        '    e.KeepInInsertMode = True
        'End If

        GridView1.DataBind()
        CallFilter()
    End Sub

    Private Sub GridView1_SelectedIndexChanged(sender As Object, e As EventArgs) Handles GridView1.SelectedIndexChanged
        FormView1.ChangeMode(FormViewMode.Edit)

        Dim script As String = "Sys.WebForms.PageRequestManager.getInstance()._scrollPosition = null; " & "window.scrollTo(0, 0);"
        ScriptManager.RegisterClientScriptBlock(Me.Page, Me.[GetType](), "scrollUp", script, True)

    End Sub

    Private Sub FormView1_ItemUpdating(sender As Object, e As FormViewUpdateEventArgs) Handles FormView1.ItemUpdating
        e.NewValues("LastModDt") = DateTime.Now

    End Sub

    Private Sub MessageBox(ByVal Msg As String, ByVal obj As System.Web.UI.Page)
        Dim jscript As String
        Dim x = "OURServices"
        ScriptManager.RegisterClientScriptBlock(Me.Page, Me.[GetType](), "Alert", "alert('" & Msg & "');", True)
        'obj.ClientScript.RegisterClientScriptBlock(GetType(String), "Alert", "alert('" & Msg & "');")

    End Sub

    '+++++++++ START FILTER +++++++++
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        Dim gv As GridView = GridView1
        Dim ds As SqlDataSource = SqlDataSourceGrid
        GlobalClass.GenerateFilter(gv, ds, pnlFilter)

        ''+++++ Selected column +++++
        'Dim lstColumn As New List(Of String)({"description"})
        'GlobalClass.GenerateFilter(gv, ds, pnlFilter, lstColumn)
    End Sub

    Private Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearch.Click
        Dim ds As SqlDataSource = SqlDataSourceGrid
        GlobalClass.procSearch(ds, pnlFilter)
    End Sub

    Private Sub btnReset_Click(sender As Object, e As EventArgs) Handles btnReset.Click
        Response.Redirect(Request.RawUrl)
    End Sub

    Protected Sub GridView1_PageIndexChanged(sender As Object, e As EventArgs) Handles GridView1.PageIndexChanged
        CallFilter()
    End Sub

    Private Sub CallFilter()
        Dim ds As SqlDataSource = SqlDataSourceGrid
        GlobalClass.procSearch(ds, pnlFilter)
    End Sub

    Private Sub FormView1_DataBound(sender As Object, e As EventArgs) Handles FormView1.DataBound
        '// page name initial
        initPageName()
        getTutorialPathInfo()
    End Sub

    Private Sub initPageName()
        '// get page name
        Dim menuName As String = GlobalClass.writeTitlePage(Request.QueryString("m_Id"), "")

        Dim idWindowTitle2 As HtmlGenericControl = DirectCast(FormView1.FindControl("idWindowTitle2"), HtmlGenericControl)
        Dim idWindowTitle3 As HtmlGenericControl = DirectCast(FormView1.FindControl("idWindowTitle3"), HtmlGenericControl)

        If menuName = "" Then
            menuName = "Tutorial for Checkroll Module"
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

    Private Sub ddlModule_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlModule.SelectedIndexChanged
        FormView1.DataBind()
        GridView1.DataBind()


    End Sub

    Private Sub getTutorialPathInfo()
        If ddlModule.SelectedValue = "CR" Then
            pathUrlVideo = "/tutorial/checkroll/video/"
            pathUrlPdf = "/tutorial/checkroll/pdf/"
        ElseIf ddlModule.SelectedValue = "SR" Then
            pathUrlVideo = "/tutorial/sundry/video/"
            pathUrlPdf = "/tutorial/sundry/pdf/"
        ElseIf ddlModule.SelectedValue = "HM" Then
            pathUrlVideo = "/tutorial/harvestingmobile/video/"
            pathUrlPdf = "/tutorial/harvestingmobile/pdf/"
        ElseIf ddlModule.SelectedValue = "HA" Then
            pathUrlVideo = "/tutorial/harvesting/video/"
            pathUrlPdf = "/tutorial/harvesting/pdf/"
        End If
    End Sub
    '+++++++++ END FILTER +++++++++

End Class
