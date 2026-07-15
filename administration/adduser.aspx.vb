Imports System.Data.SqlClient
Imports System.Net.Mail

Partial Class html_administration_user
    Inherits System.Web.UI.Page

    Public Sub passwordEncrypt()

        '//start encrypt
        DirectCast(FormView1.FindControl("Users_PasswordTextBox"), TextBox).Text = GlobalClass.Encrypt(DirectCast(FormView1.FindControl("Users_PasswordTextBox"), TextBox).Text, "kmbportal", True)

    End Sub

    Protected Sub FormView1_ItemCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewCommandEventArgs) Handles FormView1.ItemCommand

        If e.CommandName = "Update" Or e.CommandName = "Insert" Then
            If DirectCast(FormView1.FindControl("Users_PasswordTextBox"), TextBox).Text <> "" Then
                DirectCast(FormView1.FindControl("Users_PasswordTextBox"), TextBox).Text = GlobalClass.Encrypt(DirectCast(FormView1.FindControl("Users_PasswordTextBox"), TextBox).Text, "kmbportal", True)
            End If

        End If

    End Sub


    Protected Sub FormView1_ItemInserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertedEventArgs) Handles FormView1.ItemInserted
        GridView1.DataBind()
    End Sub

    Protected Sub GridView1_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs) Handles GridView1.RowDeleting
        Dim title As String = GridView1.Rows(e.RowIndex).Cells(2).Text

        '//run audit trail : Insert : Update : Delete : Login : Logout
        GlobalClass.auditTrail("User Management", title, "Delete")
    End Sub

    Protected Sub GridView1_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles GridView1.SelectedIndexChanged
        FormView1.ChangeMode(DetailsViewMode.Edit)
    End Sub

    Protected Sub FormView1_ItemInserting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertEventArgs) Handles FormView1.ItemInserting
        Dim titleTxt As TextBox = DirectCast(FormView1.FindControl("Users_NameTextBox"), TextBox)
        Dim title As String = titleTxt.Text

        Dim ParaListName() As String = {"Users_Name"}
        Dim ParaListValue() As String = {e.Values("Users_Name")}

        If GlobalClass.checkDuplicate(ParaListName, ParaListValue, "TBL_USERS", " Users_Enabled = 1 and Users_Register = 1 ") Then
            MessageBox("Failed to Insert Duplicated Record.", Me)
            e.Cancel = True
        End If

        '//run audit trail : Insert : Update : Delete : Login : Logout
        GlobalClass.auditTrail("User Management", title, "Insert")
    End Sub

    Private Sub MessageBox(ByVal Msg As String, ByVal obj As System.Web.UI.Page)
        Dim jscript As String
        Dim x = "OURServices"
        ScriptManager.RegisterClientScriptBlock(Me.Page, Me.[GetType](), "Alert", "alert('" & Msg & "');", True)
        'obj.ClientScript.RegisterClientScriptBlock(GetType(String), "Alert", "alert('" & Msg & "');")

    End Sub

    Protected Sub FormView1_ItemUpdated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdatedEventArgs) Handles FormView1.ItemUpdated
        GridView1.DataBind()
    End Sub

    Protected Sub FormView1_ItemUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdateEventArgs) Handles FormView1.ItemUpdating
        Dim titleTxt As TextBox = DirectCast(FormView1.FindControl("Users_NameTextBox"), TextBox)
        Dim title As String = titleTxt.Text

        Dim ParaListName() As String = {"Users_Name"}
        Dim ParaListValue() As String = {e.NewValues("Users_Name")}

        If GlobalClass.checkDuplicate(ParaListName, ParaListValue, "TBL_USERS", " Users_Enabled = 1 and Users_Register = 1 ", CInt(GridView1.SelectedValue), "Users_Id") Then
            MessageBox("Failed to Update Duplicated Record.", Me)
            e.Cancel = True
        End If

        '//run audit trail : Insert : Update : Delete : Login : Logout
        GlobalClass.auditTrail("User Management", title, "Update")
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If GlobalClass.isSuperAdmin(Session.Item("sessionUsersId")) Then
            SqlDataSource1.SelectCommand = "SELECT Users_Id, Users_Name, Users_Fullname, Users_Password, Users_Email, Users_Enabled, Users_Register FROM TBL_USERS WHERE (Users_Name LIKE '%' + @Users_Name + '%') AND (Users_Fullname LIKE '%' + @Users_Fullname + '%') ORDER BY Users_Name"
        Else
            SqlDataSource1.SelectCommand = "SELECT Users_Id, Users_Name, Users_Fullname, Users_Password, Users_Email, Users_Enabled, Users_Register FROM TBL_USERS WHERE (Users_Name LIKE '%' + @Users_Name + '%') AND (Users_Fullname LIKE '%' + @Users_Fullname + '%') ORDER BY Users_Name"
        End If

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
            GridView1.Columns.Item(7).Visible = False '//grid delete

        End If
    End Sub

    Protected Sub ResendPasswordButton_Click(ByVal sender As Object, ByVal e As System.EventArgs)

        'MsgBox(GridView1.SelectedValue)

        Dim Users_Name As String = ""
        Dim Users_Email As String = ""
        Dim Users_Fullname As String = ""
        Dim decryptPassWord As String = ""
        Dim Users_Id As String = "0"

        Dim MailFrom As String = ""
        Dim MailTo As String = ""
        Dim title As String = ""
        Dim emailBody As String = ""

        Dim Webcon_Siteurl As String = ""
        Dim isSuccessSend As Boolean = False

        If GridView1.SelectedValue > 0 Then
            Users_Id = GridView1.SelectedValue
        End If



        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim Users_Password As String = ""

            Dim SQL As String = "SELECT * FROM TBL_USERS usr " & _
                                "LEFT JOIN [TBL_WEBCONFIG] wc ON wc.Webcon_id = wc.Webcon_id and wc.Webcon_Enabled = 'Y' " & _
                                "WHERE usr.Users_Id = @P_Users_Id"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@P_Users_Id", Users_Id)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader


            Try


                While myReader.Read

                    Users_Password = myReader.Item("Users_Password")
                    Users_Name = myReader.Item("Users_Name")
                    Users_Fullname = myReader.Item("Users_Fullname")
                    Users_Email = myReader.Item("Users_Email")

                    Webcon_Siteurl = myReader.Item("Webcon_Siteurl")

                    MailFrom = "admin@eesb.com.my" '//admin@eesb.com.my
                    MailTo = Users_Email

                    title = "Login Access Information"

                    Try
                        decryptPassWord = GlobalClass.Decrypt(Users_Password, "kmbportal", True)
                    Catch ex As Exception
                        decryptPassWord = ""                        
                    End Try

                    If MailTo <> "" And decryptPassWord <> "" Then
                        emailBody = "Hi " & Users_Fullname & ",<br/>"
                        emailBody += "This is your details login information <br/><br/>"
                        emailBody += "<strong>User Name :</strong> " & Users_Name & "<br/>"
                        emailBody += "<strong>Password :</strong> " & decryptPassWord & "<br/><br/>"
                        emailBody += "Click below link URL to login <br/>" & Webcon_Siteurl & "<br/><br/>"
                        emailBody += "Thank You"

                        'MsgBox(emailBody)
                        '// start send email

                        Dim fullpath As String = ""
                        Dim strArr() As String
                        Dim count As Integer

                        If MailTo <> "" Then


                            strArr = MailTo.Split(";")
                            For count = 0 To strArr.Length - 1

                                Dim fromAddress As New MailAddress(MailFrom, "OHDC Administrator")
                                Dim toAddress As New MailAddress(strArr(count), "")
                                Dim msg As New MailMessage(fromAddress, toAddress)

                                msg.Body = msg.Body & "" & emailBody
                                msg.Subject = title
                                'msg.Attachments = attachmentEmail
                                msg.IsBodyHtml = True

                                If fullpath <> "" Then
                                    msg.Attachments.Add(New Attachment(fullpath))
                                End If

                                Dim mailSender As New System.Net.Mail.SmtpClient()
                                'mailSender.Host = myReader.Item("Webcon_EmailServer") '//"58.26.106.40"
                                mailSender.Host = "58.26.106.40"

                                'MsgBox(strArr(count))

                                Try
                                    '//send email
                                    mailSender.Send(msg)

                                    '//show status
                                    Dim lblMessageStr As Label = DirectCast(FormView1.FindControl("lblMessage"), Label)
                                    lblMessageStr.Text = "Resend Password Successfully"

                                    isSuccessSend = True

                                Catch ex As Exception

                                    '//show status
                                    Dim lblMessageStr As Label = DirectCast(FormView1.FindControl("lblMessage"), Label)
                                    lblMessageStr.Text = ex.Message
                                End Try

                            Next

                        End If

                    End If



                End While

            Catch ex As Exception

            End Try

            If isSuccessSend = False Then

                Dim lblMessageStr As Label = DirectCast(FormView1.FindControl("lblMessage"), Label)
                lblMessageStr.Text = "Resend Password failed. Please check email and password."

            End If
            myConnection.Close()

        End Using


    End Sub
End Class
