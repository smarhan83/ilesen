
Partial Class html_administration_groupname
    Inherits System.Web.UI.Page


    Protected Sub FormView1_ItemInserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertedEventArgs) Handles FormView1.ItemInserted
        GridView1.DataBind()
        'Me.Page.GetType.InvokeMember("abc", System.Reflection.BindingFlags.InvokeMethod, Nothing, Me.Page, New Object() {"aa"})

    End Sub

    Protected Sub GridView1_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs) Handles GridView1.RowDeleting
        Dim title As String = GridView1.Rows(e.RowIndex).Cells(1).Text

        '//run audit trail : Insert : Update : Delete : Login : Logout
        GlobalClass.auditTrail("User Group Management", title, "Delete")
    End Sub


    Protected Sub GridView1_RowUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewUpdateEventArgs) Handles GridView1.RowUpdating

        Dim row = GridView1.Rows(e.RowIndex)
        Dim title As String = (CType((row.Cells(1).Controls(0)), TextBox)).Text

        '//run audit trail : Insert : Update : Delete : Login : Logout
        GlobalClass.auditTrail("User Group Management", title, "Update")
    End Sub

    Protected Sub FormView1_ItemInserting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertEventArgs) Handles FormView1.ItemInserting
        Dim titleTxt As TextBox = DirectCast(FormView1.FindControl("UGN_NameTextBox"), TextBox)
        Dim title As String = titleTxt.Text

        '//run audit trail : Insert : Update : Delete : Login : Logout
        GlobalClass.auditTrail("User Group Management", title, "Insert")
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
            GridView1.Columns.Item(3).Visible = False '//grid delete

        End If
    End Sub

    Private Sub GridView1_SelectedIndexChanged(sender As Object, e As EventArgs) Handles GridView1.SelectedIndexChanged
        FormView1.ChangeMode(FormViewMode.Edit)
    End Sub

    Private Sub FormView1_ItemUpdated(sender As Object, e As FormViewUpdatedEventArgs) Handles FormView1.ItemUpdated
        GridView1.DataBind()
    End Sub
End Class
