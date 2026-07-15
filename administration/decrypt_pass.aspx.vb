Imports System.Data.SqlClient

Partial Class html_administration_encrypt_pass
    Inherits System.Web.UI.Page


    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        'Label1.Text = GlobalClass.Encrypt(DirectCast(FormView1.FindControl("Users_PasswordTextBox"), TextBox).Text, "microwell", True)
        'Label1.Text = GlobalClass.Decrypt("6Ps4A8w3Fzo10hpsB+tqLg==", "microwell", True)
        
        If GlobalClass.isSuperAdmin(Session.Item("sessionUsersId")) Then
            idContentDecryptPass.Visible = True
        End If
    End Sub




    Protected Sub Button1_Click(sender As Object, e As System.EventArgs) Handles Button1.Click

        If IsPostBack Then

            If TextBox1.Text <> "" Then

                Dim Users_Name As String

                Users_Name = TextBox1.Text

                Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

                    myConnection.Open()

                    Dim Users_Password As String = ""

                    Dim SQL As String = "SELECT * FROM TBL_USERS WHERE Users_Name = @P_Users_Name"

                    Dim myCommandSelect As New SqlCommand(SQL, myConnection)
                    myCommandSelect.Parameters.AddWithValue("@P_Users_Name", Users_Name)

                    Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader


                    While myReader.Read

                        Users_Password = myReader.Item("Users_Password")
                        Label1.Text = GlobalClass.Decrypt(Users_Password, "kmbportal", True)

                    End While

                    myConnection.Close()

                End Using
            Else
                Label1.Text = ""
            End If


        End If
    End Sub
End Class
