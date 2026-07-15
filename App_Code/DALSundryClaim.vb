Imports System.Configuration
Imports System.Data
Imports System.Data.SqlClient

Public Class DALSundryClaim
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

    Public Shared Function getBudgetAmount(ByVal EmpID As Integer, ByVal JobCode As String, ByVal TrxYear As Integer) As String
        Dim code As String = "0"

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
            myConnection.Open()
            Dim SQLSelect As String = "SELECT TOP 1 ISNULL(BudgetAmount,0) AS BudgetAmount
            FROM Budget A
            INNER JOIN Employees B ON A.DepartmentCode=B.DepartmentCode
            INNER JOIN COA C ON A.AccountCode=C.AGGL
            WHERE B.EmpID=" & EmpID & " AND C.JobCode='" & JobCode & "' AND A.BudgetYear=" & TrxYear.ToString

            Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)
            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader
            If myReader.Read Then
                code = myReader.Item("BudgetAmount")
            End If

            myReader.Close()
            myConnection.Close()
        End Using
        Return code
    End Function

    Public Shared Function getUtilisedAmount(ByVal EmpID As Integer, ByVal JobCode As String, ByVal TrxYear As Integer) As String
        Dim code As String = "0"

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
            myConnection.Open()
            Dim SQLSelect As String = "SELECT TOP 1 ISNULL(UtilisedAmount,0) AS UtilisedAmount
            FROM Budget A
            INNER JOIN Employees B ON A.DepartmentCode=B.DepartmentCode
            INNER JOIN COA C ON A.AccountCode=C.AGGL
            WHERE B.EmpID=" & EmpID & " AND C.JobCode='" & JobCode & "' AND A.BudgetYear=" & TrxYear.ToString

            Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)
            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader
            If myReader.Read Then
                code = myReader.Item("UtilisedAmount")
            End If

            myReader.Close()
            myConnection.Close()
        End Using
        Return code
    End Function

    Public Function LoadSubmitter(ByVal SundryClaimID As Integer) As DataSet
        Dim connString As String = ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ToString()
        Dim sqlCon As SqlConnection = New SqlConnection()
        Dim cmd As SqlCommand = New SqlCommand()
        Dim ad As SqlDataAdapter = New SqlDataAdapter()
        Dim ds As DataSet = New DataSet()
        Dim lPass As Boolean = False

        sqlCon.ConnectionString = connString

        Try
            Dim querystring As String = Nothing
            querystring = "SELECT B.Username, B.EmployeeName, B.Email FROM Sundry_Claim A " &
                "INNER JOIN Employees B ON A.EmpID=B.EmpID " &
                "WHERE A.SundryClaimID=@SundryClaimID"
            cmd.Connection = sqlCon
            cmd.CommandType = CommandType.Text
            cmd.Parameters.Clear()
            cmd.Parameters.AddWithValue("@SundryClaimID", SundryClaimID)
            cmd.CommandText = querystring
            cmd.CommandTimeout = 0
            cmd.Connection.Open()
            ad.SelectCommand = cmd
            ad.Fill(ds)
            cmd.Connection.Close()

        Catch ex As Exception
            If (cmd.Connection.State = ConnectionState.Open) Then
                cmd.Connection.Close()
            End If
            Throw
        End Try

        Return ds
    End Function

    Public Function LoadSubmitterApprover(ByVal SundryClaimApprID As Integer) As DataSet
        Dim connString As String = ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ToString()
        Dim sqlCon As SqlConnection = New SqlConnection()
        Dim cmd As SqlCommand = New SqlCommand()
        Dim ad As SqlDataAdapter = New SqlDataAdapter()
        Dim ds As DataSet = New DataSet()
        Dim lPass As Boolean = False

        sqlCon.ConnectionString = connString

        Try
            Dim querystring As String = Nothing
            querystring = "SELECT B.EmployeeName, B.Email FROM V_SundryClaimApproval A " &
                "INNER JOIN Employees B ON A.EmpID=B.EmpID " &
                "WHERE A.SundryClaimApprID=@SundryClaimApprID"
            cmd.Connection = sqlCon
            cmd.CommandType = CommandType.Text
            cmd.Parameters.Clear()
            cmd.Parameters.AddWithValue("@SundryClaimApprID", SundryClaimApprID)
            cmd.CommandText = querystring
            cmd.CommandTimeout = 0
            cmd.Connection.Open()
            ad.SelectCommand = cmd
            ad.Fill(ds)
            cmd.Connection.Close()

        Catch ex As Exception
            If (cmd.Connection.State = ConnectionState.Open) Then
                cmd.Connection.Close()
            End If
            Throw
        End Try

        Return ds
    End Function

    Public Function LoadApprover(ByVal SundryClaimID As Integer) As DataSet
        Dim connString As String = ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ToString()
        Dim sqlCon As SqlConnection = New SqlConnection()
        Dim cmd As SqlCommand = New SqlCommand()
        Dim ad As SqlDataAdapter = New SqlDataAdapter()
        Dim ds As DataSet = New DataSet()
        Dim lPass As Boolean = False

        sqlCon.ConnectionString = connString

        Try
            Dim querystring As String = Nothing
            querystring = "SELECT B.Username, B.EmployeeName, B.Email FROM V_SundryClaimApprovalPending A " &
                "INNER JOIN Employees B ON A.ApproverID=B.EmpID " &
                "WHERE A.SundryClaimID=@SundryClaimID"
            cmd.Connection = sqlCon
            cmd.CommandType = CommandType.Text
            cmd.Parameters.Clear()
            cmd.Parameters.AddWithValue("@SundryClaimID", SundryClaimID)
            cmd.CommandText = querystring
            cmd.CommandTimeout = 0
            cmd.Connection.Open()
            ad.SelectCommand = cmd
            ad.Fill(ds)
            cmd.Connection.Close()

        Catch ex As Exception
            If (cmd.Connection.State = ConnectionState.Open) Then
                cmd.Connection.Close()
            End If
            Throw
        End Try

        Return ds
    End Function

    Public Function LoadSundryClaim(ByVal SundryClaimID As Integer) As DataSet
        Dim connString As String = ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ToString()
        Dim sqlCon As SqlConnection = New SqlConnection()
        Dim cmd As SqlCommand = New SqlCommand()
        Dim ad As SqlDataAdapter = New SqlDataAdapter()
        Dim ds As DataSet = New DataSet()
        Dim lPass As Boolean = False

        sqlCon.ConnectionString = connString

        Try
            Dim querystring As String = Nothing
            querystring = "SELECT SundryClaimID, DocNo, TransDate, EmpID, EmpNo, EmpName, BenefitCode, SundryCategory, " &
                "JobCode, AccCode, AccDesc, ClaimRemarks, Rate, Quantity, Amount, Remark, BudgetAmount, UtilisedAmount, " &
                "ApprovalStatus, ApprovalStatusDesc, Active, CreatorID, CreatedDt, LastModID, LastModDt " &
                "FROM V_Sundry_Claim " &
                "WHERE SundryClaimID=@SundryClaimID"
            cmd.Connection = sqlCon
            cmd.CommandType = CommandType.Text
            cmd.Parameters.Clear()
            cmd.Parameters.AddWithValue("@SundryClaimID", SundryClaimID)
            cmd.CommandText = querystring
            cmd.CommandTimeout = 0
            cmd.Connection.Open()
            ad.SelectCommand = cmd
            ad.Fill(ds)
            cmd.Connection.Close()

        Catch ex As Exception
            If (cmd.Connection.State = ConnectionState.Open) Then
                cmd.Connection.Close()
            End If
            Throw
        End Try

        Return ds
    End Function

    Public Function LoadTicketInfo(ByVal ticketID As Integer) As DataSet
        Dim connString As String = ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ToString()
        Dim sqlCon As SqlConnection = New SqlConnection()
        Dim cmd As SqlCommand = New SqlCommand()
        Dim ad As SqlDataAdapter = New SqlDataAdapter()
        Dim ds As DataSet = New DataSet()
        Dim lPass As Boolean = False

        sqlCon.ConnectionString = connString

        Try
            Dim querystring As String = Nothing
            'querystring = "SELECT * FROM HD_Ticket A INNER JOIN Employees B ON A.EmpID=B.EmpID " &
            '    "WHERE ticketID=@ticketID"
            querystring = "SELECT A.ticketId, A.ticketNo, A.EmpID, A.titlesubject, Employees.EmployeeName AS Requestor, Employees.Email, B.EmployeeName AS Supervisor, B.Email, A.description, C.EmployeeName AS SolutionName FROM HD_Ticket A 
            INNER JOIN Employees ON A.EmpID=Employees.EmpID
            INNER JOIN Employees AS B ON SUBSTRING(Employees.Supervisor, PATINDEX('%[^0 ]%', Employees.Supervisor), LEN(Employees.Supervisor)) = SUBSTRING(B.EmployeeNo, PATINDEX('%[^0 ]%', B.EmployeeNo), 
            LEN(B.EmployeeNo))
            LEFT JOIN Employees C ON A.closeCaseId=C.EmpID
            WHERE ticketID=@ticketID"
            cmd.Connection = sqlCon
            cmd.CommandType = CommandType.Text
            cmd.Parameters.Clear()
            cmd.Parameters.AddWithValue("@ticketID", ticketID)
            cmd.CommandText = querystring
            cmd.CommandTimeout = 0
            cmd.Connection.Open()
            ad.SelectCommand = cmd
            ad.Fill(ds)
            cmd.Connection.Close()

        Catch ex As Exception
            If (cmd.Connection.State = ConnectionState.Open) Then
                cmd.Connection.Close()
            End If
            Throw
        End Try

        Return ds
    End Function

    Public Function LoadApproval(ByVal SundryClaimApprID As Integer) As DataSet
        Dim connString As String = ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ToString()
        Dim sqlCon As SqlConnection = New SqlConnection()
        Dim cmd As SqlCommand = New SqlCommand()
        Dim ad As SqlDataAdapter = New SqlDataAdapter()
        Dim ds As DataSet = New DataSet()
        Dim lPass As Boolean = False

        sqlCon.ConnectionString = connString

        Try
            Dim querystring As String = Nothing
            querystring = "SELECT SundryClaimApprID, SundryClaimID, ApproverLevel, ApproverID, ApproverEmpNo, ApproverName, " &
                "ApprovalStatus, ApprovalStatusDesc, CONVERT(varchar, ApprovalDate, 103) AS ApprovalDate, Remarks, " &
                "CONVERT(varchar, TransDate, 103) AS TransDate, EmpID, EmpNo, EmpName, BenefitCode, SundryCategory, JobCode, AccCode, AccDesc, Amount, " &
                "ClaimRemarks, BudgetAmount, UtilisedAmount, Active, IsFinalApproval " &
                "FROM V_SundryClaimApproval " &
                "WHERE SundryClaimApprID=@SundryClaimApprID"
            cmd.Connection = sqlCon
            cmd.CommandType = CommandType.Text
            cmd.Parameters.Clear()
            cmd.Parameters.AddWithValue("@SundryClaimApprID", SundryClaimApprID)
            cmd.CommandText = querystring
            cmd.CommandTimeout = 0
            cmd.Connection.Open()
            ad.SelectCommand = cmd
            ad.Fill(ds)
            cmd.Connection.Close()

        Catch ex As Exception
            If (cmd.Connection.State = ConnectionState.Open) Then
                cmd.Connection.Close()
            End If
            Throw
        End Try

        Return ds
    End Function

    Public Function getSundryClaimID(ByVal SundryClaimApprID As Integer) As Integer
        Dim SundryClaimID As Integer = 0

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
            myConnection.Open()
            Dim SQLSelect As String = "SELECT TOP 1 ISNULL(SundryClaimID,0) AS SundryClaimID
            FROM Sundry_Claim_Approval
            WHERE SundryClaimApprID=" & SundryClaimApprID

            Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)
            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader
            If myReader.Read Then
                SundryClaimID = Convert.ToInt32(myReader.Item("SundryClaimID"))
            End If

            myReader.Close()
            myConnection.Close()
        End Using
        Return SundryClaimID
    End Function

    Public Function getIsFinalApproval(ByVal SundryClaimApprID As Integer) As Boolean
        Dim SundryClaimID As Integer = 0

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
            myConnection.Open()
            Dim SQLSelect As String = "SELECT TOP 1 ISNULL(IsFinalApproval,0) AS IsFinalApproval
            FROM Sundry_Claim_Approval
            WHERE SundryClaimApprID=" & SundryClaimApprID

            Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)
            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader
            If myReader.Read Then
                SundryClaimID = Convert.ToBoolean(myReader.Item("IsFinalApproval"))
            End If

            myReader.Close()
            myConnection.Close()
        End Using
        Return SundryClaimID
    End Function

    Public Function getIsFinalApprover(ByVal EmpID As Integer) As Boolean
        Dim recCount As Integer = 0
        Dim IsFinalApprover As Boolean = False

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
            myConnection.Open()
            Dim SQLSelect As String = "SELECT COUNT(*) AS IsFinalApprover
            FROM SetupApprover
            WHERE ApproverLevel=5 AND ApproverID=" & EmpID

            Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)
            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader
            If myReader.Read Then
                recCount = Convert.ToInt32(myReader.Item("IsFinalApprover"))
            End If
            If recCount > 0 Then
                IsFinalApprover = True
            End If

            myReader.Close()
            myConnection.Close()
        End Using
        Return IsFinalApprover
    End Function
End Class
