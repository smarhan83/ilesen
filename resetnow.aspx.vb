Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.IO
Imports System.Security.Cryptography
Imports System.Web.Script.Serialization
Imports DocumentFormat.OpenXml.Drawing.Spreadsheet

Partial Class resetnow
    Inherits System.Web.UI.Page

    Dim category As String = ""

    Protected Sub InsertButton_Click(sender As Object, e As EventArgs)

        resetPassword(CInt(hfUID.Value))

    End Sub

    Private Sub resetPassword(UID As Integer)

        'Dim Users_Password As TextBox = DirectCast(FormView1.FindControl("Users_Password"), TextBox)

        If UID > 0 And Users_Password.Text <> "" And Page.IsValid Then

            Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
                '--# MAIN TABLE
                Dim SQL As String = "update TBL_USERS set Users_Password = @Users_Password where Users_Id = @UID;"

                Dim myCommand As New SqlCommand(SQL, myConnection)

                myCommand.Parameters.AddWithValue("@UID", UID)
                myCommand.Parameters.AddWithValue("@Users_Password", GlobalClass.Encrypt(Users_Password.Text, "kmbportal", True))

                myConnection.Open()

                Dim recordset As Integer = myCommand.ExecuteNonQuery()

                If recordset Then
                    'Session.Item("sessionStatusConfirm") = "Y"
                    'Response.Redirect("/shop/shop_login")
                    lblStatus.Text = "Katalaluan anda sudah dikemaskini. Sila login menggunakan katalaluan yang baharu."

                    updateIsResetProfile(UID)
                    myReset.Visible = False
                End If

                myConnection.Close()

            End Using

        Else

        End If



    End Sub

    Private Sub resetnow_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim UID As String = ""
        hfUID.Value = 0


        Try
            'hfUID.Value = RouteData.Values("UID")

            Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

                Dim sSQL As String = ""

                sSQL = "select * from tbl_users where Users_IsResetPass = @Users_IsResetPass "


                Dim myCommand As New SqlCommand(sSQL, myConnection)
                myCommand.Parameters.AddWithValue("@Users_IsResetPass", RouteData.Values("UID"))

                myConnection.Open()

                Dim myReader As SqlDataReader = myCommand.ExecuteReader

                If myReader.Read Then

                    hfUID.Value = myReader("Users_Id")
                    myReset.Visible = True
                Else

                    lblStatus.Text = "Reset password tidak berjaya."
                    myReset.Visible = False
                End If

                myReader.Close()
                myConnection.Close()




            End Using


        Catch ex As Exception
            lblStatus.Text = "Reset password tidak berjaya." 'ex.Message
            myReset.Visible = False
        End Try


    End Sub

    Private Sub updateIsResetProfile(uid As Integer)

        If uid > 0 Then
            Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
                '--# MAIN TABLE
                Dim SQL As String = "update TBL_USERS set Users_IsResetPass = '' where Users_Id = @UID;"

                Dim myCommand As New SqlCommand(SQL, myConnection)

                myCommand.Parameters.AddWithValue("@UID", uid)

                myConnection.Open()

                Dim recordset As Integer = myCommand.ExecuteNonQuery()

                If recordset Then


                End If

                myConnection.Close()

            End Using
        End If

    End Sub


End Class
