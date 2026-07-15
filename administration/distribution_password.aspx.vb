Imports System.Data.SqlClient
Imports System.Net.Mail

Partial Class administration_distribution_password
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then
            'Button1.Visible = True
            'Button2.Visible = False
            Dim isPassword As String = DropDownList1.SelectedValue

            If isPassword = "NULL" Then
                Button1.Visible = True
                Button2.Visible = False
                SqlDataSource1.SelectCommand = "SELECT Users_Id, Users_Name, Users_Fullname, Users_Email, Users_Enabled, Users_Register, Users_Password FROM TBL_USERS WHERE (Users_Register = '1') AND (Users_Enabled = '1') AND Users_Password IS NULL"
            Else
                Button1.Visible = False
                Button2.Visible = True
                SqlDataSource1.SelectCommand = "SELECT Users_Id, Users_Name, Users_Fullname, Users_Email, Users_Enabled, Users_Register, Users_Password FROM TBL_USERS WHERE (Users_Register = '1') AND (Users_Enabled = '1') AND Users_Password <> '' AND Users_Email <> ''"

            End If

            GridView1.DataBind()

            chkSelectAll.Checked = False
            lblDistPassword.Text = ""
        End If
    End Sub

    Protected Sub CheckBox1_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs)

        ''Dim listPath() As String = {} '//list of selected path
        'Dim listPath As New ArrayList()
        'Dim selRowIndex As Integer = DirectCast(DirectCast(sender, CheckBox).Parent.Parent, GridViewRow).RowIndex

        'Dim selectedRow As GridViewRow = DirectCast(DirectCast(sender, CheckBox).NamingContainer, GridViewRow)
        'Dim rowIndex As Integer = selectedRow.RowIndex
        'Dim chkModuleSelectAll As CheckBox = DirectCast(GridView1.Rows(rowIndex).FindControl("CheckBox1"), CheckBox)

        'Dim i As Integer
        'For i = 0 To GridView1.Rows.Count - 1

        '    Dim chkcheckbox As CheckBox = DirectCast(GridView1.Rows(i).FindControl("CheckBox1"), CheckBox)

        '    If chkcheckbox.Checked = True Then
        '        Dim title As String = GridView1.Rows(i).Cells(4).Text
        '        listPath.Add(title)
        '    End If

        '    'Label1.Text = "aa"
        'Next

        ''Label1.Text = loadGridView(listPath)


    End Sub

    Protected Sub chkSelectAll_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles chkSelectAll.CheckedChanged

        Dim i As Integer

        If chkSelectAll.Checked = True Then

            For i = 0 To GridView1.Rows.Count - 1

                Dim chkcheckbox As CheckBox = DirectCast(GridView1.Rows(i).FindControl("CheckBox1"), CheckBox)

                Dim strEmail As String = GridView1.Rows(i).Cells(3).Text

                If DropDownList1.SelectedValue = "NULL" Then

                    chkcheckbox.Checked = True

                Else

                    If strEmail <> "" And strEmail <> "&nbsp;" Then
                        chkcheckbox.Checked = True
                    End If

                End If



            Next


        Else


            For i = 0 To GridView1.Rows.Count - 1

                Dim chkcheckbox As CheckBox = DirectCast(GridView1.Rows(i).FindControl("CheckBox1"), CheckBox)
                chkcheckbox.Checked = False

            Next

        End If

        '// update html table list

        Dim listPath As New ArrayList()
        For i = 0 To GridView1.Rows.Count - 1

            Dim chkcheckbox As CheckBox = DirectCast(GridView1.Rows(i).FindControl("CheckBox1"), CheckBox)

            If chkcheckbox.Checked = True Then
                Dim title As String = GridView1.Rows(i).Cells(4).Text
                listPath.Add(title)
            End If

        Next

        'Label1.Text = loadGridView(listPath)

        '//end of update

    End Sub

    Protected Sub DropDownList1_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles DropDownList1.SelectedIndexChanged

        Dim isPassword As String = DropDownList1.SelectedValue

        If isPassword = "NULL" Then
            Button1.Visible = True
            Button2.Visible = False
            SqlDataSource1.SelectCommand = "SELECT Users_Id, Users_Name, Users_Fullname, Users_Email, Users_Enabled, Users_Register, Users_Password FROM TBL_USERS WHERE (Users_Register = '1') AND (Users_Enabled = '1') AND Users_Password IS NULL"
        Else
            Button1.Visible = False
            Button2.Visible = True
            SqlDataSource1.SelectCommand = "SELECT Users_Id, Users_Name, Users_Fullname, Users_Email, Users_Enabled, Users_Register, Users_Password FROM TBL_USERS WHERE (Users_Register = '1') AND (Users_Enabled = '1') AND Users_Password <> '' AND Users_Email <> ''"

        End If

        GridView1.DataBind()

        chkSelectAll.Checked = False
        lblDistPassword.Text = ""
    End Sub

    Protected Sub Button1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Button1.Click

        For i = 0 To GridView1.Rows.Count - 1

            Dim chkcheckbox As CheckBox = DirectCast(GridView1.Rows(i).FindControl("CheckBox1"), CheckBox)

            If chkcheckbox.Checked = True Then
                Dim selectedId As Integer = 0
                selectedId = GridView1.Rows(i).Cells(0).Text

                '//update random password
                setRandomPassword(selectedId)
            End If

        Next

    End Sub

    Protected Sub Button2_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Button2.Click

        For i = 0 To GridView1.Rows.Count - 1

            Dim chkcheckbox As CheckBox = DirectCast(GridView1.Rows(i).FindControl("CheckBox1"), CheckBox)

            If chkcheckbox.Checked = True Then
                Dim selectedId As Integer = 0
                selectedId = GridView1.Rows(i).Cells(0).Text

                '//send password by email
                sendPasswordEmail(selectedId)
            End If

        Next

    End Sub

    Private Sub setRandomPassword(ByVal selectedId As Integer)


        If selectedId > 0 Then

            Dim strPassword As String = ""
            Dim strEmail As String = ""

            strPassword = Membership.GeneratePassword(7, 1)
            strPassword = Regex.Replace(strPassword, "[^a-zA-Z0-9]", Function(m) "9")

            strPassword = GlobalClass.Encrypt(strPassword, "kmbportal", True)

            Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

                myConnection.Open()

                Const SQL As String = "UPDATE [TBL_USERS] SET Users_Password =  @Users_Password WHERE Users_Id = @Users_Id"

                Dim myCommand As New SqlCommand(SQL, myConnection)
                myCommand.Parameters.AddWithValue("@Users_Password", strPassword)
                myCommand.Parameters.AddWithValue("@Users_Id", selectedId)

                Dim recordset As Integer = myCommand.ExecuteNonQuery()

                myConnection.Close()

            End Using

            lblDistPassword.Text = "Password Updated Successfully."

        End If

    End Sub

    Private Sub sendPasswordEmail(ByVal selectedId As Integer)

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


        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim Users_Password As String = ""

            Dim SQL As String = "SELECT * FROM TBL_USERS usr " & _
                                "LEFT JOIN [TBL_WEBCONFIG] wc ON wc.Webcon_id = wc.Webcon_id and wc.Webcon_Enabled = 'Y' " & _
                                "WHERE usr.Users_Id = @P_Users_Id"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@P_Users_Id", selectedId)

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
                                mailSender.Host = myReader.Item("Webcon_EmailServer") '//"58.26.106.40"

                                'MsgBox(strArr(count))

                                Try
                                    '//send email
                                    mailSender.Send(msg)

                                    '//show status
                                    lblDistPassword.Text = "Resend Password Successfully <br/>"

                                    isSuccessSend = True

                                Catch ex As Exception

                                    '//show status
                                    lblDistPassword.Text = ex.Message
                                End Try

                            Next

                        End If

                    End If



                End While

            Catch ex As Exception

            End Try

            If isSuccessSend = False Then

                lblDistPassword.Text += "Resend Password failed. Please check email and password with User ID " + selectedId.ToString() + "<br/>"

            End If
            myConnection.Close()

        End Using

    End Sub

End Class
