
Partial Class Logout
    Inherits System.Web.UI.Page

    Private Sub Logout_Load(sender As Object, e As EventArgs) Handles Me.Load
        Session.Abandon()
        '//run audit trail : Insert : Update : Delete : Login : Logout
        If Not Session("sessionUsersId") Is Nothing Then
            GlobalClass.auditTrail("Logout Button", "Logout", "Logout")
        End If
        Response.Redirect("~/")
    End Sub
End Class
