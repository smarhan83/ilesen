Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.Script.Serialization
Imports System.Web.Services

Partial Class sync_HR
    Inherits System.Web.UI.Page
    Private sqlCon As SqlConnection = New SqlConnection()
    Private cmd As SqlCommand = New SqlCommand()
    Private connectionstringSource As String = ConfigurationManager.ConnectionStrings("FlexHR_ConnectionStr").ToString()
    Private connectionstringDest As String = ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ToString()

    Private Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim lPass As Boolean = False
        Dim msgResult As String = "Success"

        Try
            If EmptyIMTableEmpInfo() Then
                If GetDataEmpInfo() Then
                    If TransferIMTableEmpInfo() Then

                    End If
                End If
            End If

            If EmptyTableCategory() Then
                If GetDataCategory() Then
                End If
            End If

            If EmptyTableJobCode() Then
                If GetDataJobCode() Then
                End If
            End If

            lPass = True

            updateDuplicateProfile("Y")

        Catch ex As Exception
            msgResult = ex.Message
        End Try

        Dim json As String = GetJson(lPass, msgResult)

        Response.Clear()
        Response.ContentType = "application/json; charset=utf-8"
        Response.Write(json)
        Response.[End]()

    End Sub
	
	Private Sub updateDuplicateProfile(fileName As String)

        Try

            Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

                Dim SQL As String = "update a set Email = ''
				from Employees a
				where Email like  'rohani@kulim.com.my%' and RTRIM(EmployeeNo) not in ('000950312');
				update a set Users_Email = ''
				from TBL_USERS a
				where Users_Email like  'rohani@kulim.com.my%' and RTRIM(Users_Name) not in ('000950312');
				update a set Email = ''
				from Employees a
				where Email like  'affidah@kulim.com.my%' and RTRIM(EmployeeNo) not in ('000950134');
				update a set Users_Email = ''
				from TBL_USERS a
				where Users_Email like  'affidah@kulim.com.my%' and RTRIM(Users_Name) not in ('000950134');
				update a set Email = ''
				from Employees a
				where Email like  'amaniza@kulim.com.my%' and RTRIM(EmployeeNo) not in ('00080934F');
				update a set Users_Email = ''
				from TBL_USERS a
				where Users_Email like  'amaniza@kulim.com.my%' and RTRIM(Users_Name) not in ('00080934F');
				update a set Email = ''
				from Employees a
				where Email like  'jamilah_awang@kulim.com.my%' and RTRIM(EmployeeNo) not in ('000951222');
				update a set Users_Email = ''
				from TBL_USERS a
				where Users_Email like  'jamilah_awang@kulim.com.my%' and RTRIM(Users_Name) not in ('000951222');
				update a set Email = ''
				from Employees a
				where Email like  'fauziahg@kulim.com.my%' and RTRIM(EmployeeNo) not in ('000950164');
				update a set Users_Email = ''
				from TBL_USERS a
				where Users_Email like  'fauziahg@kulim.com.my%' and RTRIM(Users_Name) not in ('000950164'); 
				update a set Email = ''
				from Employees a
				where Email like  'emma@kulim.com.my%' and RTRIM(EmployeeNo) not in ('00081135E');
				update a set Users_Email = ''
				from TBL_USERS a
				where Users_Email like  'emma@kulim.com.my%' and RTRIM(Users_Name) not in ('00081135E');
				update a set Email = ''
				from Employees a
				where Email like  'ismailishak@kulim.com.my%' and RTRIM(EmployeeNo) not in ('000951635');
				update a set Users_Email = ''
				from TBL_USERS a
				where Users_Email like  'ismailishak@kulim.com.my%' and RTRIM(Users_Name) not in ('000951635');
				update a set Email = ''
				from Employees a
				where Email like  'manwar@kulim.com.my%' and RTRIM(EmployeeNo) not in ('00080990H');
				update a set Users_Email = ''
				from TBL_USERS a
				where Users_Email like  'manwar@kulim.com.my%' and RTRIM(Users_Name) not in ('00080990H');
				update a set Email = ''
				from Employees a
				where Email like  'mohdnajib@extremedge.com.my%' and RTRIM(EmployeeNo) not in ('951918');
				update a set Users_Email = ''
				from TBL_USERS a
				where Users_Email like  'mohdnajib@extremedge.com.my%' and RTRIM(Users_Name) not in ('951918');
				update a set Email = ''
				from Employees a
				where Email like  'nooratiqah@kulim.com.my%' and RTRIM(EmployeeNo) not in ('000951978');
				update a set Users_Email = ''
				from TBL_USERS a
				where Users_Email like  'nooratiqah@kulim.com.my%' and RTRIM(Users_Name) not in ('000951978');
				update a set Email = ''
				from Employees a
				where Email like  'norashikin@kulim.com.my%' and RTRIM(EmployeeNo) not in ('00081081B');
				update a set Users_Email = ''
				from TBL_USERS a
				where Users_Email like  'norashikin@kulim.com.my%' and RTRIM(Users_Name) not in ('00081081B');
				update a set Email = ''
				from Employees a
				where Email like  'norhawiyah@kulim.com.my%' and RTRIM(EmployeeNo) not in ('000950462');
				update a set Users_Email = ''
				from TBL_USERS a
				where Users_Email like  'norhawiyah@kulim.com.my%' and RTRIM(Users_Name) not in ('000950462');
				update a set Email = ''
				from Employees a
				where Email like  'norliza@kulim.com.my%' and RTRIM(EmployeeNo) not in ('000951188');
				update a set Users_Email = ''
				from TBL_USERS a
				where Users_Email like  'norliza@kulim.com.my%' and RTRIM(Users_Name) not in ('000951188');
				update a set Email = ''
				from Employees a
				where Email like  'norsyafina@kulim.com.my%' and RTRIM(EmployeeNo) not in ('000951163');
				update a set Users_Email = ''
				from TBL_USERS a
				where Users_Email like  'norsyafina@kulim.com.my%' and RTRIM(Users_Name) not in ('000951163');
				update a set Email = ''
				from Employees a
				where Email like  'nurabidah@kulim.com.my%' and RTRIM(EmployeeNo) not in ('000951537');
				update a set Users_Email = ''
				from TBL_USERS a
				where Users_Email like  'nurabidah@kulim.com.my%' and RTRIM(Users_Name) not in ('000951537');
				update a set Email = ''
				from Employees a
				where Email like  'nurulain@kulim.com.my%' and RTRIM(EmployeeNo) not in ('000951881');
				update a set Users_Email = ''
				from TBL_USERS a
				where Users_Email like  'nurulain@kulim.com.my%' and RTRIM(Users_Name) not in ('000951881');
				update a set Email = ''
				from Employees a
				where Email like  'nuruljannah@kulim.com.my%' and RTRIM(EmployeeNo) not in ('000951963');
				update a set Users_Email = ''
				from TBL_USERS a
				where Users_Email like  'nuruljannah@kulim.com.my%' and RTRIM(Users_Name) not in ('000951963');
				update a set Email = ''
				from Employees a
				where Email like  'suhaida@kulim.com.my%' and RTRIM(EmployeeNo) not in ('000951157');
				update a set Users_Email = ''
				from TBL_USERS a
				where Users_Email like  'suhaida@kulim.com.my%' and RTRIM(Users_Name) not in ('000951157');
				update a set Email = ''
				from Employees a
				where Email like  'suhaida@kulim.com.my%' and RTRIM(EmployeeNo) not in ('000951157');
				update a set Users_Email = ''
				from TBL_USERS a
				where Users_Email like  'suhaida@kulim.com.my%' and RTRIM(Users_Name) not in ('000951157');"
				
                'update Employees set Email = 'harnizah@kulim.com.my' where EmployeeName LIKE '%deby%';  	                        
                'update Employees set Email = 'harnizah@kulim.com.my' where EmployeeName LIKE '%jamiran%';
                'update Employees set Email = 'harnizah@kulim.com.my' where EmployeeName LIKE '%kamisah%';				

                Dim myCommand As New SqlCommand(SQL, myConnection)

                myConnection.Open()

                Dim recordset As Integer = myCommand.ExecuteNonQuery()

                myConnection.Close()

            End Using

        Catch ex As Exception
            'MsgBox(ex.ToString)
        End Try

    End Sub	

#Region "Employees"
    Public Function EmptyIMTableEmpInfo() As Boolean
        Dim lPass As Boolean = False
        Dim sResult As Integer

        sqlCon.ConnectionString = connectionstringDest

        Try
            Dim querystring As String = Nothing
            querystring = "DELETE FROM Employees_IM"
            cmd.Connection = sqlCon
            cmd.CommandType = CommandType.Text
            cmd.Parameters.Clear()
            cmd.CommandText = querystring
            cmd.CommandTimeout = 0
            cmd.Connection.Open()
            sResult = cmd.ExecuteNonQuery
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

    Function GetDataEmpInfo() As Boolean
        Dim lPass As Boolean = False
        Try
            Dim strConSrc As New SqlConnection(connectionstringSource)
            Dim strConDest As New SqlConnection(connectionstringDest)

            Dim sqlSource As String = "SELECT A.EmployeeNo AS EmployeeNo, E.us_Username AS Username, EmployeeName, SupervisorCode AS Supervisor, SuperiorCode AS Superior, Gender, 
            MaritalStatus, RaceDescr AS Race, ReligionDescr AS Religion, BirthDate, NewIc, PassportNo, NationalityDescr AS Nationality, Email, ServiceStartDate, ServiceEndDate, 
            BenefitSchemeCode, BenefitSchemeDescr, JobCode, JobDescr, GradeCode, GradeDescr, CostCenterCode, CostCenterDescr, 
            ParentCompanyCode, CompanyCode, CompanyName, DivisionCode, DivisionDescr, DepartmentCode, DepartmentDescr, SectionCode, SectionDescr,                   
            AccessCode, AccessDescr, PayrollGroupCode, PayrollGroupDescr
            FROM EmployeesInfo A
            LEFT OUTER JOIN KMBHR_PRD_VfsSecurity.dbo.SFSUserInformations D ON A.EmployeeNo=D.EmployeeNo
            LEFT OUTER JOIN KMBHR_PRD_VfsSecurity.dbo.SFSUsers E ON D.Users_fk=E.us_pk
            WHERE  GETDATE() between ServiceStartDate and ServiceEndDate 
            and GETDATE() between ShiftgrpStartDate and ShiftgrpEndDate AND E.us_Username IS NOT NULL"

            Dim strComm As New SqlCommand(sqlSource, strConSrc)

            strConSrc.Open()
            Dim drCopy As SqlDataReader = strComm.ExecuteReader

            Dim bcCopy As New SqlBulkCopy(strConDest)

            strConDest.Open()
            bcCopy.DestinationTableName = "Employees_IM"
            bcCopy.WriteToServer(drCopy)

            drCopy.Close()

            strConSrc.Close()
            strConDest.Close()

            lPass = True
        Catch ex As Exception
            Throw
        End Try

        Return lPass
    End Function

    Public Function TransferIMTableEmpInfo() As Boolean
        Dim lPass As Boolean = False
        Dim sResult As Integer

        sqlCon.ConnectionString = connectionstringDest

        Try
            Dim querystring As String = Nothing
            querystring = "SP_IM_Employees"
            cmd.Connection = sqlCon
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Clear()
            cmd.CommandText = querystring
            cmd.CommandTimeout = 0
            cmd.Connection.Open()
            sResult = cmd.ExecuteNonQuery
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
#End Region

#Region "Sundry_Claim_Category"
    Public Function EmptyTableCategory() As Boolean
        Dim lPass As Boolean = False
        Dim sResult As Integer

        sqlCon.ConnectionString = connectionstringDest

        Try
            Dim querystring As String = Nothing
            querystring = "DELETE FROM Sundry_Claim_Category"
            cmd.Connection = sqlCon
            cmd.CommandType = CommandType.Text
            cmd.Parameters.Clear()
            cmd.CommandText = querystring
            cmd.CommandTimeout = 0
            cmd.Connection.Open()
            sResult = cmd.ExecuteNonQuery
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

    Function GetDataCategory() As Boolean
        Dim lPass As Boolean = False
        Try
            Dim strConSrc As New SqlConnection(connectionstringSource)
            Dim strConDest As New SqlConnection(connectionstringDest)

            Dim sqlSource As String = "SELECT EmployeeNo, A.BenefitCode, B.Description AS SundryCategory, EntitleYear, 
            1 AS Active, 'FlexHR' AS CreatorID, GETDATE() AS CreatedDt, 'FlexHR' AS LastModID, GETDATE() LastModDt
            FROM BenefitEntitlements A
            INNER JOIN BenefitCodes B ON A.BenefitCode=B.BenefitCode"

            Dim strComm As New SqlCommand(sqlSource, strConSrc)

            strConSrc.Open()
            Dim drCopy As SqlDataReader = strComm.ExecuteReader

            Dim bcCopy As New SqlBulkCopy(strConDest)

            strConDest.Open()
            bcCopy.DestinationTableName = "Sundry_Claim_Category"
            bcCopy.WriteToServer(drCopy)

            drCopy.Close()

            strConSrc.Close()
            strConDest.Close()

            lPass = True
        Catch ex As Exception
            Throw
        End Try

        Return lPass
    End Function
#End Region

#Region "JobCode"
    Public Function EmptyTableJobCode() As Boolean
        Dim lPass As Boolean = False
        Dim sResult As Integer

        sqlCon.ConnectionString = connectionstringDest

        Try
            Dim querystring As String = Nothing
            querystring = "DELETE FROM COA"
            cmd.Connection = sqlCon
            cmd.CommandType = CommandType.Text
            cmd.Parameters.Clear()
            cmd.CommandText = querystring
            cmd.CommandTimeout = 0
            cmd.Connection.Open()
            sResult = cmd.ExecuteNonQuery
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

    Function GetDataJobCode() As Boolean
        Dim lPass As Boolean = False
        Try
            Dim strConSrc As New SqlConnection(connectionstringSource)
            Dim strConDest As New SqlConnection(connectionstringDest)

            Dim sqlSource As String = "SELECT ExpenseCode AS JobCode, A.BenefitCode, SUBSTRING(A.Description,0,CHARINDEX(' ',A.Description,0)) AS AGGL, 
            A.Description AS Descp, 
            'FlexHR' AS CreatorID, GETDATE() AS CreatedDt, 'FlexHR' AS LastModID, GETDATE() AS LastModDt
            FROM Expenses A"

            Dim strComm As New SqlCommand(sqlSource, strConSrc)

            strConSrc.Open()
            Dim drCopy As SqlDataReader = strComm.ExecuteReader

            Dim bcCopy As New SqlBulkCopy(strConDest)

            strConDest.Open()
            bcCopy.DestinationTableName = "COA"
            bcCopy.WriteToServer(drCopy)

            drCopy.Close()

            strConSrc.Close()
            strConDest.Close()

            lPass = True
        Catch ex As Exception
            Throw
        End Try

        Return lPass
    End Function
#End Region


    Public Function GetJson(ByVal result As Boolean, ByVal msgResult As String) As String
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
