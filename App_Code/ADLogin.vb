Imports System.Data
Imports System.Data.SqlClient
Imports ActiveDirectoryLib
Imports Microsoft.VisualBasic

Public Class ADLogin
#Region " Declaration "
    Private connectionstring As String = ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ToString
#End Region

    Public Function checkIsUserExists(ByVal Username As String) As Boolean
        Dim iResult As Integer = 0
        Dim lPass As Boolean = False

        Using myConnection As New SqlConnection(connectionstring)
            myConnection.Open()
            Dim SQLSelect As String = "SELECT COUNT(*) AS CNT 
            FROM Employees 
            WHERE 
			case when CHARINDEX('@',isnull(Email,'')) = 0 then NULL else SUBSTRING(Email,0,CHARINDEX('@',Email)) end = case when CHARINDEX('@',isnull('" & Username & "','')) = 0 
			then '" & Username & "' else SUBSTRING('" & Username & "',0,CHARINDEX('@','" & Username & "')) end "

            Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)
            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader
            If myReader.Read Then
                iResult = Convert.ToInt32(myReader.Item("CNT"))
                If iResult > 0 Then
                    lPass = True
                End If
            End If

            myReader.Close()
            myConnection.Close()
        End Using
        Return lPass
    End Function
End Class
