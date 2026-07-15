Imports System.Configuration
Imports System.Data
Imports System.Data.SqlClient
Public Class DALEAForm

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

    Public Function GetEAForm(ByVal EstateID As Integer, ByVal yr As Integer, ByVal empid As String, ByVal active As Integer, ByVal filter As Integer) As Boolean
        Dim lPass As Boolean = False
        Dim obj As Object = Nothing
        Dim iResult As Integer = 0
        Dim sTableName As String = "SP_PP_EAFORM"

        Try
            Dim querystring As String
            querystring = "SP_PP_EAFORM"

            cmd.Connection = sqlCon
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Clear()
            cmd.Parameters.AddWithValue("EstateID", EstateID)
            cmd.Parameters.AddWithValue("YR", yr)
            'cmd.Parameters.AddWithValue("EmpID", empid)
            cmd.Parameters.AddWithValue("Active", active.ToString)
            cmd.Parameters.AddWithValue("Filter", filter)


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
    Public Function GetBenefit(ByVal EstateID As Integer, ByVal yr As Integer, ByVal empid As String) As Integer
        Dim lPass As Boolean = False
        Dim obj As Object = Nothing
        Dim iResult As Integer = 0
        Dim sTableName As String = "BENEFITS"

        Try
            Dim querystring As String
            querystring = "		SELECT * FROM PP_EMP_FACILITIES EF " &
    "INNER JOIN PP_FACILITIES F ON EF.FACIID=F.FACIID " &
            "WHERE (yr = " & yr & "  And F.Active = 1 And F.EstateID = " & EstateID & " AND EF.EMPID='" & empid & "' ) "

            cmd.Connection = sqlCon
            cmd.CommandType = CommandType.Text

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
    Public Function GetEstate(ByVal EstateID As Integer) As Boolean
        Dim lPass As Boolean = False
        Dim obj As Object = Nothing
        Dim iResult As Integer = 0
        Dim sTableName As String = "ESTATE"

        Try
            Dim querystring As String
            querystring = "SELECT *,'' as TTLWORKERS,'' as TTLNEWWORKERS,'' as TTLSTOPWORKERS,'' as TTLSTOPLEAVEMSIA,'' as TTLLEAVEMSIAREPORTLHDNM,'' as TTLPCBWORKERS,'' as yr FROM ESTATE WHERE  ESTATEID=" & EstateID

            cmd.Connection = sqlCon
            cmd.CommandType = CommandType.Text



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

    Public Function GetTtlWorkers(ByVal EstateID As Integer, ByVal yr As Integer) As Integer
        Dim iResult As Integer = 0

        Try
            Dim querystring As String
            querystring = "SELECT count(EMPID) as TtlWorkers FROM CREMPLOYEE WHERE stopwrkdate is null or YEAR(stopwrkdate)=" & yr & " AND ESTATEID=" & EstateID

            cmd.Connection = sqlCon
            cmd.CommandType = CommandType.Text



            cmd.CommandText = querystring
            cmd.CommandTimeout = 0
            cmd.Connection.Open()
            iResult = CInt(cmd.ExecuteScalar())
            cmd.Connection.Close()

        Catch ex As Exception
            If (cmd.Connection.State = ConnectionState.Open) Then
                cmd.Connection.Close()
            End If
            Throw
        End Try

        Return iResult
    End Function


    Public Function GetTtlNewWorkers(ByVal EstateID As Integer, ByVal yr As Integer) As Integer
        Dim iResult As Integer = 0

        Try
            Dim querystring As String
            querystring = "SELECT count(EMPID) as TtlNewWorkers  FROM CREMPLOYEE WHERE  year(DOJ)=" & yr & " AND ESTATEID=" & EstateID

            cmd.Connection = sqlCon
            cmd.CommandType = CommandType.Text



            cmd.CommandText = querystring
            cmd.CommandTimeout = 0
            cmd.Connection.Open()
            iResult = CInt(cmd.ExecuteScalar())
            cmd.Connection.Close()

        Catch ex As Exception
            If (cmd.Connection.State = ConnectionState.Open) Then
                cmd.Connection.Close()
            End If
            Throw
        End Try

        Return iResult
    End Function

    Public Function GetTtlStopWorkers(ByVal EstateID As Integer, ByVal yr As Integer) As Integer
        Dim iResult As Integer = 0

        Try
            Dim querystring As String
            querystring = "SELECT count(EMPID) as TtlNewWorkers  FROM CREMPLOYEE WHERE  year(STOPWRKDATE)=" & yr & " AND ESTATEID=" & EstateID

            cmd.Connection = sqlCon
            cmd.CommandType = CommandType.Text



            cmd.CommandText = querystring
            cmd.CommandTimeout = 0
            cmd.Connection.Open()
            iResult = CInt(cmd.ExecuteScalar())
            cmd.Connection.Close()

        Catch ex As Exception
            If (cmd.Connection.State = ConnectionState.Open) Then
                cmd.Connection.Close()
            End If
            Throw
        End Try

        Return iResult
    End Function

    Public Function GetPCBWorkers(ByVal EstateID As Integer, ByVal yr As Integer) As Integer
        Dim lPass As Boolean = False
        Dim obj As Object = Nothing
        Dim iResult As Integer = 0
        Dim sTableName As String = "SP_PCBWORKERS"

        Try
            Dim querystring As String
            querystring = "SP_PCBWORKERS"

            cmd.Connection = sqlCon
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Clear()
            cmd.Parameters.AddWithValue("EstateID", EstateID)
            cmd.Parameters.AddWithValue("YR", yr)



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

    Public Function GetTtlLeaveMsia(ByVal EstateID As Integer, ByVal yr As Integer) As Integer
        Dim iResult As Integer = 0

        Try
            Dim querystring As String
            querystring = "SELECT count(EMPID) as TtlLeaveMsia  FROM CREMPLOYEE WHERE  STOPWRKREASON='MENINGGALKAN MALAYSIA' and year(STOPWRKDATE)=" & yr & " AND ESTATEID=" & EstateID

            cmd.Connection = sqlCon
            cmd.CommandType = CommandType.Text



            cmd.CommandText = querystring
            cmd.CommandTimeout = 0
            cmd.Connection.Open()
            iResult = CInt(cmd.ExecuteScalar())
            cmd.Connection.Close()

        Catch ex As Exception
            If (cmd.Connection.State = ConnectionState.Open) Then
                cmd.Connection.Close()
            End If
            Throw
        End Try

        Return iResult
    End Function

    Public Function GetTtlLeaveMsiaReportLHDNM(ByVal EstateID As Integer, ByVal yr As Integer) As Integer
        Dim iResult As Integer = 0

        Try
            Dim querystring As String
            querystring = "SELECT count(EMPID) as TtlLeaveMsiaReport FROM CREMPLOYEE WHERE  STOPWRKREASON='MENINGGALKAN MALAYSIA' and REPORTLHDNM='Y' and year(STOPWRKDATE)=" & yr & " AND ESTATEID=" & EstateID

            cmd.Connection = sqlCon
            cmd.CommandType = CommandType.Text



            cmd.CommandText = querystring
            cmd.CommandTimeout = 0
            cmd.Connection.Open()
            iResult = CInt(cmd.ExecuteScalar())
            cmd.Connection.Close()

        Catch ex As Exception
            If (cmd.Connection.State = ConnectionState.Open) Then
                cmd.Connection.Close()
            End If
            Throw
        End Try

        Return iResult
    End Function
End Class
