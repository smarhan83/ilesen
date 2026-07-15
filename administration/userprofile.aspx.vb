Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Drawing.Imaging
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


    Protected Sub FormView1_ItemInserting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertEventArgs) Handles FormView1.ItemInserting
        'Dim titleTxt As TextBox = DirectCast(FormView1.FindControl("Users_NameTextBox"), TextBox)
        'Dim title As String = titleTxt.Text

        ''//run audit trail : Insert : Update : Delete : Login : Logout
        'GlobalClass.auditTrail("User Management", title, "Insert")
    End Sub

    Protected Sub FormView1_ItemUpdated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdatedEventArgs) Handles FormView1.ItemUpdated
        lblMessageUpdate.Text = "Kemaskini berjaya"
    End Sub

    Protected Sub FormView1_ItemUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdateEventArgs) Handles FormView1.ItemUpdating
        Dim title As String = Session.Item("sessionUserName")
        Dim ufPicture As FileUpload = DirectCast(FormView1.FindControl("ufPicture"), FileUpload)
        Dim uid As Guid = Guid.NewGuid()
        Dim fn As String = System.IO.Path.GetFileName(ufPicture.PostedFile.FileName)
        Dim localPath As String = "~/profile/" & "" & Session.Item("sessionUsersId") & ".jpeg"
        Dim SaveLocation As String = Server.MapPath(localPath)

        If (ufPicture.PostedFile IsNot Nothing) AndAlso (ufPicture.PostedFile.ContentLength > 0) Then
            If System.IO.File.Exists("~/profile/" & "" & Session.Item("sessionUsersId") & ".jpeg") Then
                System.IO.File.Delete("~/profile/" & "" & Session.Item("sessionUsersId") & ".jpeg")
            End If
        End If

        updateUploadFile(ufPicture, SaveLocation)

        '//run audit trail : Insert : Update : Delete : Login : Logout
        GlobalClass.auditTrail("User Management", title, "Update")

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Page.Form.Attributes.Add("enctype", "multipart/form-data")

        'If GlobalClass.isSuperAdmin(Session.Item("sessionUsersId")) Then
        '    SqlDataSource1.SelectCommand = "SELECT Users_Id, Users_Name, Users_Fullname, Users_Password, Users_Email, Users_Enabled, Users_Register FROM TBL_USERS WHERE (Users_Name LIKE '%' + @Users_Name + '%') AND (Users_Fullname LIKE '%' + @Users_Fullname + '%') ORDER BY Users_Name"
        'Else
        '    SqlDataSource1.SelectCommand = "SELECT Users_Id, Users_Name, Users_Fullname, Users_Password, Users_Email, Users_Enabled, Users_Register FROM TBL_USERS WHERE (Users_Name LIKE '%' + @Users_Name + '%') AND (Users_Fullname LIKE '%' + @Users_Fullname + '%') AND Users_Id IN (SELECT Users_Id FROM TBL_USERS A WHERE A.Users_Id IN (SELECT UGL_Users_Id FROM TBL_USER_GROUPLIST WHERE UGL_UGN_Id = 6) OR A.Users_Id NOT IN (SELECT UGL_Users_Id FROM TBL_USER_GROUPLIST)) ORDER BY Users_Name"
        'End If

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
            'GridView1.Columns.Item(7).Visible = False '//grid delete

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

        If FormView1.SelectedValue > 0 Then
            Users_Id = FormView1.SelectedValue
        End If



        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim Users_Password As String = ""

            Dim SQL As String = "SELECT * FROM TBL_USERS usr " &
                                "LEFT JOIN [TBL_WEBCONFIG] wc ON wc.Webcon_id = wc.Webcon_id and wc.Webcon_Enabled = 'Y' " &
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

                    MailFrom = "info@kulimecotrail.com.my" '//admin@eesb.com.my
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
                                mailSender.Host = myReader.Item("Webcon_EmailServer") '//"58.26.106.40"
                                mailSender.UseDefaultCredentials = True
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

    Private Function updateUploadFile(txtFilePath As FileUpload, saveLocation As String) As Boolean
        'lblDummy.Text = saveLocation
        Dim retval As Boolean = True

        If (txtFilePath.PostedFile IsNot Nothing) AndAlso (txtFilePath.PostedFile.ContentLength > 0) Then

            Try
                Dim fileExtention As String = txtFilePath.PostedFile.ContentType
                Dim fileLenght As Integer = txtFilePath.PostedFile.ContentLength

                If fileExtention = "image/png" OrElse fileExtention = "image/jpeg" OrElse fileExtention = "image/x-png" Then

                    '//image
                    If fileLenght <= (1048576 * 5) Then '1048576 => 1M
                        Dim bmpPostedImage As System.Drawing.Bitmap = New System.Drawing.Bitmap(txtFilePath.PostedFile.InputStream)
                        Dim objImage As System.Drawing.Image = ScaleImage(bmpPostedImage, 128)
                        objImage.Save(saveLocation, ImageFormat.Jpeg)

                        'MessageBox("Fail berjaya dimuatnaik", Me)

                    Else
                        MessageBox("Image size cannot be more then 5 MB!", Me)
                        retval = False
                    End If
                Else


                    MessageBox("Invalid Image Format!", Me)
                    retval = False

                End If

            Catch ex As Exception
                MessageBox(ex.Message, Me)
                retval = False
                'lblmsg.Text = "Error: " & ex.Message
                'lblmsg.Style.Add("Color", "Red")
            End Try
        Else
            'MessageBox("Muat naik fail gagal. Sila cuba sekali lagi", Me)
            'retval = False
        End If

        Return retval
    End Function

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

    Public Sub MessageBox(ByVal Msg As String, ByVal obj As System.Web.UI.Page)
        Dim jscript As String
        Dim x = "OURServices"
        ScriptManager.RegisterClientScriptBlock(Me.Page, Me.[GetType](), "Alert", "alert('" & Msg & "');", True)
    End Sub

    Private Sub FormView1_DataBound(sender As Object, e As EventArgs) Handles FormView1.DataBound

        If FormView1.CurrentMode = FormViewMode.Edit Then
            Dim currPageScriptManager As ScriptManager = TryCast(ScriptManager.GetCurrent(Page), ScriptManager)
            Dim UpdateButton As LinkButton = DirectCast(FormView1.FindControl("UpdateButton"), LinkButton)
            'RegisterAsyncPostBackControl
            'currPageScriptManager.RegisterPostBackControl(btnUpload)
            currPageScriptManager.RegisterPostBackControl(UpdateButton)


        End If


    End Sub

    'Private Sub FormView1_Load(sender As Object, e As EventArgs) Handles FormView1.Load
    '    '//clear password
    '    Dim Users_PasswordTextBox As TextBox = DirectCast(FormView1.FindControl("Users_PasswordTextBox"), TextBox)
    '    Dim txtRepassword As TextBox = DirectCast(FormView1.FindControl("txtRepassword"), TextBox)

    '    MsgBox(Users_PasswordTextBox.Text)

    '    Users_PasswordTextBox.Attributes.Add("value", "")
    '    txtRepassword.Attributes.Add("value", "")
    'End Sub
End Class
