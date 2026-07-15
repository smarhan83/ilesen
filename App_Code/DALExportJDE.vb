Imports System.Configuration
Imports System.Data
Imports System.Data.SqlClient

Public Class DALExportJDE
#Region " Declaration "
    Dim connectionstring As String = ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ToString
    Private sqlCon As New SqlConnection
    Private cmd As New SqlCommand
    Private ad As New SqlDataAdapter
    Public ds As New DataSet
#End Region

    Public Sub New()
        sqlCon.ConnectionString = connectionstring
    End Sub

    Public Function GetSundryExportJDE(ByVal EstateID As Integer, ByVal YR As Integer, ByVal MTH As Integer, ByVal sTableName As String) As Boolean
        Dim lPass As Boolean = False
        Dim obj As Object = Nothing
        Dim iResult As Integer = 0

        Try
            Dim querystring As String
            querystring = "SP_PP_SundryExportJDE"

            cmd.Connection = sqlCon
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Clear()
            cmd.Parameters.AddWithValue("EstateID", EstateID)
            cmd.Parameters.AddWithValue("YR", YR)
            cmd.Parameters.AddWithValue("MTH", MTH)

            cmd.CommandText = querystring
            cmd.CommandTimeout = 0
            cmd.Connection.Open()
            ad.SelectCommand = cmd

            If ds.Tables.Contains(sTableName) Then
                ds.Tables.Remove(sTableName)
            End If
            ad.Fill(ds, sTableName)
            cmd.Connection.Close()
            lPass = True
        Catch ex As Exception
            If (cmd.Connection.State = ConnectionState.Open) Then
                cmd.Connection.Close()
            End If
            Throw
        End Try

        Return lPass
    End Function

End Class
