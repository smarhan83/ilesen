Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class DALDashboard
    Private connectionstring As String = ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ToString()
    Private sqlCon As SqlConnection = New SqlConnection()
    Private cmd As SqlCommand = New SqlCommand()
    Private ad As SqlDataAdapter = New SqlDataAdapter()
    Public ds As DataSet = New DataSet()

    Public Sub New()
        sqlCon.ConnectionString = connectionstring
    End Sub

    Public Function LoadYieldStatBunchByYear(ByVal iYear As Integer, ByVal iEstateID As Integer, ByVal sTblName As String) As Boolean
        Dim lPass As Boolean = False
        Dim TableName As String = sTblName

        Try
            Dim querystring As String = Nothing
            querystring = "SP_DBOARD_YIELD_STATISTIC_BUNCH"

            Using connection As SqlConnection = New SqlConnection(connectionstring)
                cmd.Connection = sqlCon
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Clear()
                cmd.Parameters.AddWithValue("@OCID", iEstateID)
                cmd.Parameters.AddWithValue("@Year", iYear)
                cmd.CommandText = querystring
                cmd.CommandTimeout = 0
                cmd.Connection.Open()
                ad.SelectCommand = cmd
                If ds.Tables.Contains(TableName) Then ds.Tables.Remove(TableName)
                ad.Fill(ds, TableName)
                cmd.Connection.Close()
                lPass = True
            End Using

        Catch ex As Exception

            If (cmd.Connection.State = ConnectionState.Open) Then
                cmd.Connection.Close()
            End If

            Throw
        End Try

        Return lPass
    End Function

    Public Function LoadYieldStatTonnageByYear(ByVal iYear As Integer, ByVal iEstateID As Integer, ByVal sTblName As String) As Boolean
        Dim lPass As Boolean = False
        Dim TableName As String = sTblName

        Try
            Dim querystring As String = Nothing
            querystring = "SP_DBOARD_YIELD_STATISTIC_TONNAGE"

            Using connection As SqlConnection = New SqlConnection(connectionstring)
                cmd.Connection = sqlCon
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Clear()
                cmd.Parameters.AddWithValue("@OCID", iEstateID)
                cmd.Parameters.AddWithValue("@Year", iYear)
                cmd.CommandText = querystring
                cmd.CommandTimeout = 0
                cmd.Connection.Open()
                ad.SelectCommand = cmd
                If ds.Tables.Contains(TableName) Then ds.Tables.Remove(TableName)
                ad.Fill(ds, TableName)
                cmd.Connection.Close()
                lPass = True
            End Using

        Catch ex As Exception

            If (cmd.Connection.State = ConnectionState.Open) Then
                cmd.Connection.Close()
            End If

            Throw
        End Try

        Return lPass
    End Function

    Public Function LoadBunchCountByMonth(ByVal iYear As Integer, ByVal iMonth As Integer, ByVal iEstateID As Integer, ByVal sTblName As String) As Boolean
        Dim lPass As Boolean = False
        Dim TableName As String = sTblName

        Try
            Dim querystring As String = Nothing
            querystring = "SP_DBOARD_BUNCH_COUNT"

            Using connection As SqlConnection = New SqlConnection(connectionstring)
                cmd.Connection = sqlCon
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Clear()
                cmd.Parameters.AddWithValue("@OCID", iEstateID)
                cmd.Parameters.AddWithValue("@Year", iYear)
                cmd.Parameters.AddWithValue("@Month", iMonth)
                cmd.CommandText = querystring
                cmd.CommandTimeout = 0
                cmd.Connection.Open()
                ad.SelectCommand = cmd
                If ds.Tables.Contains(TableName) Then ds.Tables.Remove(TableName)
                ad.Fill(ds, TableName)
                cmd.Connection.Close()
                lPass = True
            End Using

        Catch ex As Exception

            If (cmd.Connection.State = ConnectionState.Open) Then
                cmd.Connection.Close()
            End If

            Throw
        End Try

        Return lPass
    End Function

    Public Function LoadYieldStatCard(ByVal iYear As Integer, ByVal iMonth As Integer, ByVal iEstateID As Integer, ByVal sTblName As String) As Boolean
        Dim lPass As Boolean = False
        Dim TableName As String = sTblName

        Try
            Dim querystring As String = Nothing
            querystring = "SP_DBOARD_CARD"

            Using connection As SqlConnection = New SqlConnection(connectionstring)
                cmd.Connection = sqlCon
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Clear()
                cmd.Parameters.AddWithValue("@OCID", iEstateID)
                cmd.Parameters.AddWithValue("@Year", iYear)
                cmd.Parameters.AddWithValue("@Month", iMonth)
                cmd.CommandText = querystring
                cmd.CommandTimeout = 0
                cmd.Connection.Open()
                ad.SelectCommand = cmd
                If ds.Tables.Contains(TableName) Then ds.Tables.Remove(TableName)
                ad.Fill(ds, TableName)
                cmd.Connection.Close()
                lPass = True
            End Using

        Catch ex As Exception

            If (cmd.Connection.State = ConnectionState.Open) Then
                cmd.Connection.Close()
            End If

            Throw
        End Try

        Return lPass
    End Function

    Public Function LoadOverallEstate(ByVal iYear As Integer, ByVal iMonth As Integer, ByVal sTblName As String) As Boolean
        Dim lPass As Boolean = False
        Dim TableName As String = sTblName

        Try
            Dim querystring As String = Nothing
            querystring = "SP_DBOARD_ESTATE_RANK"

            Using connection As SqlConnection = New SqlConnection(connectionstring)
                cmd.Connection = sqlCon
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Clear()
                cmd.Parameters.AddWithValue("@Year", iYear)
                cmd.Parameters.AddWithValue("@Month", iMonth)
                cmd.CommandText = querystring
                cmd.CommandTimeout = 0
                cmd.Connection.Open()
                ad.SelectCommand = cmd
                If ds.Tables.Contains(TableName) Then ds.Tables.Remove(TableName)
                ad.Fill(ds, TableName)
                cmd.Connection.Close()
                lPass = True
            End Using

        Catch ex As Exception

            If (cmd.Connection.State = ConnectionState.Open) Then
                cmd.Connection.Close()
            End If

            Throw
        End Try

        Return lPass
    End Function

    Public Function LoadCullingCount(ByVal iBatch As Integer, ByVal sTblName As String) As Boolean
        Dim lPass As Boolean = False
        Dim TableName As String = sTblName

        Try
            Dim querystring As String = Nothing
            querystring = "SELECT NUR_AbnormalChar.abnormalChar AS abnor_char, SUM(NUR_Culling.number) AS cull_val FROM NUR_Culling INNER JOIN NUR_cullingStage ON NUR_Culling.cullingStagesId = NUR_cullingStage.cullingId INNER JOIN NUR_AbnormalChar ON NUR_cullingStage.abnorCharId = NUR_AbnormalChar.abnormalId WHERE NUR_Culling.batchId = @batchId GROUP BY NUR_AbnormalChar.abnormalChar"

            Using connection As SqlConnection = New SqlConnection(connectionstring)
                cmd.Connection = sqlCon
                cmd.CommandType = CommandType.Text
                cmd.Parameters.Clear()
                cmd.Parameters.AddWithValue("@batchId", iBatch)
                cmd.CommandText = querystring
                cmd.CommandTimeout = 0
                cmd.Connection.Open()
                ad.SelectCommand = cmd
                If ds.Tables.Contains(TableName) Then ds.Tables.Remove(TableName)
                ad.Fill(ds, TableName)
                cmd.Connection.Close()
                lPass = True
            End Using

        Catch ex As Exception

            If (cmd.Connection.State = ConnectionState.Open) Then
                cmd.Connection.Close()
            End If

            Throw
        End Try

        Return lPass
    End Function
End Class
