
Partial Class html_administration_deniedpage
    Inherits System.Web.UI.Page

    Private Sub html_administration_deniedpage_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Session.Item("sessionUsersId") <= 0 Then
            Response.Redirect("../Default.aspx")
        End If
    End Sub
End Class
