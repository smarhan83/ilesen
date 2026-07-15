Imports System
Imports System.Net
Imports System.IO
Imports System.Web
Imports Ionic.Zip
Imports System.Data.SqlClient

Imports System.Collections.Generic
Imports System.Linq
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports Microsoft.SqlServer.Management.Smo
Imports Microsoft.SqlServer.Management.Common
Imports Newtonsoft.Json.Linq
Imports System.Web.Script.Serialization

Partial Class auto_close
    Inherits System.Web.UI.Page

    Private Sub ouuploadfile_Load(sender As Object, e As EventArgs) Handles Me.Load


        Dim json As String
        Dim lPass As Boolean = False
        Dim msgResult As String = "Success"
        Dim isrun As String = Request.QueryString("isrun")

        Try

            If isrun = "1" Then

                '//insert into log
                Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

                    Dim SQL As String = "select * from HD_Ticket a
                    left join HD_CRF b on b.ticketId = a.ticketId
                    where b.statusCRF = 'C' and DATEDIFF(day,a.closeCaseDt,GETDATE() ) >= 3"


                    Dim myCommand As New SqlCommand(SQL, myConnection)
                    'myCommand.Parameters.AddWithValue("@Lang_hd_code", Lang_hd_code)


                    myConnection.Open()

                    Dim myReader As SqlDataReader = myCommand.ExecuteReader

                    While myReader.Read
                        If Not IsDBNull(myReader.Item("EmpID")) Then

                            GlobalClass.insertProgressTrans(myReader.Item("EmpID"), 6, myReader.Item("ticketId"))
                        End If

                    End While



                    myReader.Close()

                    myConnection.Close()

                End Using

                '//update status
                Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
                    '--# MAIN TABLE
                    Dim SQL As String = "update a set a.verified = 'V', a.verifiedModDt = getdate(), a.verifiedModId = a.EmpID, a.status = 0
                    from HD_Ticket a
                    left join HD_CRF b on b.ticketId = a.ticketId
                    where a.verified = 'C' and DATEDIFF(day,a.closeCaseDt,GETDATE() ) >= 3;
                    update b set b.statusCRF='V'
                    from HD_Ticket a
                    left join HD_CRF b on b.ticketId = a.ticketId
                    where b.statusCRF = 'C' and DATEDIFF(day,a.closeCaseDt,GETDATE() ) >= 3;"

                    Dim myCommand As New SqlCommand(SQL, myConnection)

                    'myCommand.Parameters.AddWithValue("@ticketId", "")

                    myConnection.Open()
                    Dim SundryClaimID As Integer = myCommand.ExecuteScalar()
                    myConnection.Close()


                End Using

            End If


            lPass = True

        Catch ex As Exception
            msgResult = ex.Message
        End Try

        Dim jsonResult As String = GetResultJson(lPass, msgResult)

        Response.Clear()
        Response.ContentType = "application/json; charset=utf-8"
        Response.Write(jsonResult)
        Response.[End]()




    End Sub


    Public Function GetResultJson(ByVal result As Boolean, ByVal msgResult As String) As String
        Dim res As Object

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Dim SQL As String = ""

            msgResult = msgResult.Replace("'", "")
            SQL = "SELECT '" & result & "' AS Result, '" & msgResult & "' AS Message " &
                "FOR JSON PATH "

            Dim myCommand As New SqlCommand(SQL, myConnection)

            myConnection.Open()

            Dim myReader As SqlDataReader = myCommand.ExecuteReader
            myReader.Read()

            res = myReader(0)

            myConnection.Close()
        End Using


        Return res

    End Function





End Class
