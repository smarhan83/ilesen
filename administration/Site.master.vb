
Partial Class html_administration_Site
    Inherits System.Web.UI.MasterPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim Counter_Others As String = HttpContext.Current.Request.UserAgent
        'MsgBox(Counter_Others)
        Dim sessionUserId As Integer = 1
        Dim glblClass As New GlobalClass()

        Dim allowedAccess As Boolean = GlobalClass.CheckPagePermission("Read")
        If allowedAccess = False Then
            Response.Redirect("deniedpage.aspx")
        End If

        '//generate dynamic menu
        'menuBar.InnerHtml = glblClass.WriteMenu(0)
        lblFullname1.Text = ""
        lblFullname.Text = ""
        If Session.Item("sessionUsersId") > 0 Then
            lblFullname.Text = Session.Item("sessionFullname")
            lblFullname1.Text = Session.Item("sessionFullname")
        End If


        menuBar1.InnerHtml = GlobalClass.WriteAdminMenu(0, 0, 0)



    End Sub

    Protected Sub linkLogout_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles linkLogout.Click
        Session.Abandon()
        '//run audit trail : Insert : Update : Delete : Login : Logout
        GlobalClass.auditTrail("Logout Button", "Logout", "Logout")
        Response.Redirect("Default.aspx")
    End Sub

    Protected Sub LinkLogin_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles LinkLogin.Click
        Session.Abandon()
        Response.Redirect("Default.aspx")
    End Sub

    Public Function generateAdminMenu(ByVal filename As Array, ByVal menuname As Array, Optional ByVal parentname As String = "") As String

        Dim retval As String = ""
        Dim retchild As String = ""
        Dim havechild As Boolean = False

        Dim i As Integer = 0
        For i = 0 To filename.Length - 1

            If GlobalClass.CheckPagePermission("Read", filename(i)) Then
                havechild = True
                retchild = retchild + "<li runat=""server""><a href=""" + filename(i) + """>" + menuname(i) + "</a></li>"
            End If

        Next

        If havechild = True Then

            If parentname <> "" Then
                retval = retval + "<li runat=""server""><a>" + parentname + "</a><ul>"
            End If

            retval = retval + "" + retchild

            If parentname <> "" Then
                retval = retval + "</ul></li>"
            End If

        End If

        Return retval

        'Dim retval As String = ""
        'Dim retchild As String = ""
        'Dim havechild As Boolean = False

        'Dim i As Integer = 0
        'For i = 0 To filename.Length - 1            

        '    If GlobalClass.CheckPagePermission("Read", filename(i)) Then
        '        havechild = True
        '        retchild = retchild + "<li runat=""server""><a href=""" + filename(i) + """>" + menuname(i) + "</a></li>"
        '    End If

        'Next

        'If havechild = True Then

        '    If parentname <> "" Then                
        '        retval = retval + "<li runat=""server""><a>" + parentname + "</a><ul>"
        '    End If

        '    retval = retval + "" + retchild

        '    If parentname <> "" Then
        '        retval = retval + "</ul></li>"
        '    End If

        'End If

        'Return retval

    End Function

End Class

