Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Web.SessionState.HttpSessionState
Imports System.Net
Imports System.Text
Imports System.Security.Cryptography
Imports System.Net.Mail
Imports System.Web.Providers.Entities

Public Class GlobalClass

    Public Class GlobalVariables
        Public Shared urlSessionEnd As String
        Public Shared urlSessionSystemId As String
    End Class

    Public Shared Function insertFeedbackTicket(ByVal ticketID As Integer, ByVal feedbackComment As String, ByVal feedbackStar As Integer) As Boolean

        Dim retval As Boolean = True

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Const SQL As String = "INSERT INTO [HD_FeedbackTicket] (feedbackTicket_ticketID,feedbackTicket_comment,feedbackTicket_star,createdDt,creatorId) VALUES " &
                "(@feedbackTicket_ticketID,@feedbackTicket_comment,@feedbackTicket_star,getdate(),@creatorId)"

            Dim myCommand As New SqlCommand(SQL, myConnection)

            myCommand.Parameters.AddWithValue("@feedbackTicket_ticketID", ticketID)
            myCommand.Parameters.AddWithValue("@feedbackTicket_comment", feedbackComment)
            myCommand.Parameters.AddWithValue("@feedbackTicket_star", feedbackStar)
            myCommand.Parameters.AddWithValue("@creatorId", HttpContext.Current.Session.Item("sessionUsersId"))

            myConnection.Open()

            Dim recordset As Integer = myCommand.ExecuteNonQuery()

            '//start insert

            myConnection.Close()

        End Using

        Return retval
    End Function

    Public Shared Function insertProgressTrans(ByVal empID As Integer, ByVal progressID As Integer, ByVal ticketID As Integer) As Boolean

        Dim retval As Boolean = True

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Const SQL As String = "INSERT INTO [HD_ProgressTrans] (progressTrans_EmpID,progressTrans_DateTime,progressTrans_progressDesc,progressTrans_TicketID) VALUES " &
                "(@progressTrans_EmpID,getdate(),(select top 1 x.progress_description from HD_ProgressMaster x where x.progressID = @progressID),@progressTrans_TicketID)"

            Dim myCommand As New SqlCommand(SQL, myConnection)

            myCommand.Parameters.AddWithValue("@progressTrans_EmpID", empID)
            myCommand.Parameters.AddWithValue("@progressID", progressID)
            myCommand.Parameters.AddWithValue("@progressTrans_TicketID", ticketID)

            myConnection.Open()

            Dim recordset As Integer = myCommand.ExecuteNonQuery()

            '//start insert

            myConnection.Close()

        End Using

        Return retval
    End Function

    Public Shared Function getTotalCount(ByVal Typefilter As String, ByVal fldName As String) As Integer
        Dim notificationCount As Integer
        Try
            Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

                Dim strSQL As String = "SELECT COUNT(*) AS cnt FROM (SELECT HD_Ticket.ticketId, HD_Ticket.ticketNo, HD_CRF.statusCRF, HD_Ticket.EmpID, Employees.EmployeeName, 
                                        Employees.Supervisor, Employees_1.EmployeeName AS SupervisorName, 
                                        HD_Ticket.DepartmentCode, HD_Ticket.designation, HD_Ticket.requestCategory, HD_Ticket.typeRequest, 
                                        HD_Category.category + ' | ' + HD_SubCategory.subCategory AS category, HD_Ticket.categoryId, 
                                        HD_Ticket.titlesubject, EmployeeONBehalf.EmployeeName AS onBehalf, HD_Ticket.returnStatus, 
                                        HD_Ticket.description, HD_Ticket.image, HD_Ticket.status, HD_Ticket.creatorId, HD_Ticket.verified,
                                        CONVERT (varchar, HD_Ticket.createdDt, 103) AS createdDt, HD_Ticket.verifiedModId, HD_Ticket.verifiedModDt, 
                                        HD_Ticket.assignHOU, HD_Ticket.assignHOUStatus, HOU.EmployeeName AS HOU, HD_Ticket.priorityId, HD_Priority.priority, 
                                        CASE WHEN HOU.EmployeeName IS NULL THEN 'no' ELSE 'yes' END AS AssignStatus, CASE 
                                        WHEN HD_Ticket.verified = 'R' THEN 'Rejected'
                                        WHEN HD_Ticket.verified = 'C' THEN 'Resolved'
                                        WHEN HD_Ticket.verified = 'V' THEN 'Verified'
                                        WHEN HD_Ticket.ticketNo IS NULL THEN 'Pending'
                                        WHEN HD_CRF.statusCRF = 'P' THEN 'In-Progress CRF'
                                        WHEN HD_CRF.statusCRF = 'A' THEN 'Approved CRF'
                                        WHEN HD_CRF.statusCRF = 'C' THEN 'Verified'
                                        ELSE 'In-Progress' END AS statusTicket
                                FROM HD_Ticket 
                                LEFT JOIN HD_CRF ON HD_Ticket.ticketId = HD_CRF.ticketId
                                LEFT JOIN Employees AS HOU ON HD_Ticket.assignHOU = HOU.EmpID 
                                INNER JOIN Employees ON HD_Ticket.EmpID = Employees.EmpID 
                                INNER JOIN HD_SubCategory ON HD_Ticket.subCategoryId = HD_SubCategory.subCategoryId 
                                INNER JOIN HD_Category ON HD_Ticket.categoryId = HD_Category.categoryId 
                                LEFT JOIN HD_Priority ON HD_Ticket.priorityId = HD_Priority.priorityId 
                                INNER JOIN Employees AS EmployeeONBehalf ON HD_Ticket.EmpIDONBehalf = EmployeeONBehalf.EmpID 
                                INNER JOIN Employees AS Employees_1 ON SUBSTRING(Employees.Supervisor, PATINDEX('%[^0 ]%', Employees.Supervisor), LEN(Employees.Supervisor)) = SUBSTRING(Employees_1.EmployeeNo, PATINDEX('%[^0 ]%', Employees_1.EmployeeNo), LEN(Employees_1.EmployeeNo)) 
                                        ) AS tbl1 WHERE " & fldName & " LIKE '%' + @statusTicket + '%' "

                Dim myCommand As New SqlCommand(strSQL, myConnection)
                myCommand.Parameters.AddWithValue("@statusTicket", Typefilter)

                myConnection.Open()

                Dim myReader As SqlDataReader = myCommand.ExecuteReader

                If myReader.Read Then
                    Try
                        notificationCount = myReader.Item("cnt")
                    Catch ex As Exception
                        notificationCount = 0
                    End Try

                End If

                myReader.Close()

                myConnection.Close()

            End Using
        Catch ex As Exception

        End Try
        'notificationCount = 12
        Return notificationCount
    End Function

    Public Shared Function getNotificationCount() As Integer
        Dim notificationCount As Integer
        Try
            Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

                Dim strSQL As String = "SELECT COUNT (*) AS cnt FROM (SELECT HD_Ticket.ticketId, HD_Ticket.EmpIDONBehalf, 
HD_Ticket.titlesubject, HD_Ticket.remark, HD_Ticket.solution, HD_Ticket.ticketNo, HD_CRF.statusCRF, 
HD_Category.category + ' | ' + HD_SubCategory.subCategory AS category, HD_Ticket.EmpID, Employees_1.EmpID AS SupervisorID, 
Employees.EmployeeName, Employees.Supervisor, Employees_1.EmployeeName AS SupervisorName, HD_Ticket.DepartmentCode, 
HD_Ticket.designation, HD_Ticket.requestCategory, HD_Ticket.typeRequest, HD_Ticket.returnStatus, HD_Ticket.description, 
EmployeeONBehalf.EmployeeName AS onBehalf, HD_Ticket.image, HD_Ticket.verified, HD_Ticket.status, HD_Ticket.creatorId, 
CONVERT (varchar, HD_Ticket.createdDt, 103) AS createdDt, HD_Ticket.verifiedModId, HD_Ticket.verifiedModDt, HD_Ticket.assignHOU, 
HD_Ticket.assignHOUStatus, HOU.EmployeeName AS HOU, HD_Ticket.priorityId, HD_Priority.priority, ISNULL((SELECT COUNT(*) AS Expr1 
FROM HD_Support AS X WHERE (ticketId = HD_Ticket.ticketId)), 0) AS TotalSupport 
FROM HD_Ticket 
LEFT OUTER JOIN HD_CRF ON HD_Ticket.ticketId = HD_CRF.ticketId 
LEFT OUTER JOIN Employees AS HOU ON HD_Ticket.assignHOU = HOU.EmpID 
INNER JOIN HD_SubCategory ON HD_Ticket.subCategoryId = HD_SubCategory.subCategoryId 
INNER JOIN HD_Category ON HD_Ticket.categoryId = HD_Category.categoryId 
LEFT OUTER JOIN HD_Priority ON HD_Ticket.priorityId = HD_Priority.priorityId 
INNER JOIN Employees ON HD_Ticket.EmpID = Employees.EmpID 
INNER JOIN Employees AS EmployeeONBehalf ON HD_Ticket.EmpIDONBehalf = EmployeeONBehalf.EmpID 
INNER JOIN Employees AS Employees_1 ON SUBSTRING(Employees.Supervisor, PATINDEX('%[^0 ]%', Employees.Supervisor), 
LEN(Employees.Supervisor)) = SUBSTRING(Employees_1.EmployeeNo, PATINDEX('%[^0 ]%', Employees_1.EmployeeNo), 
LEN(Employees_1.EmployeeNo)) WHERE (HD_Ticket.assignHOU = @sessionEmpID) AND (HD_Ticket.ticketNo LIKE '%' + @ticketNo + '%') 
AND (CONVERT (varchar, HD_Ticket.createdDt, 103) LIKE '%' + @createdDt + '%') 
AND (HD_Category.category + ' | ' + HD_SubCategory.subCategory LIKE '%' + @category + '%') 
AND (HD_Ticket.ticketId IN (SELECT Z.ticketId FROM HD_Ticket AS Z LEFT OUTER JOIN HD_Support AS X ON Z.ticketId = X.ticketId 
WHERE (ISNULL(X.remarks, '') LIKE CASE WHEN @keyword <> '' THEN '%' + @keyword + '%' ELSE ISNULL(X.remarks , '') END))) 
OR (HD_Ticket.ticketNo LIKE '%' + @ticketNo + '%') AND (CONVERT (varchar, HD_Ticket.createdDt, 103) LIKE '%' + @createdDt + '%') 
AND (HD_Category.category + ' | ' + HD_SubCategory.subCategory LIKE '%' + @category + '%') 
AND (HD_Ticket.ticketId IN (SELECT ticketId FROM HD_Support WHERE (EmpID = @sessionEmpID))) AND (HD_Ticket.ticketId IN (SELECT Z.ticketId FROM HD_Ticket AS Z LEFT OUTER JOIN HD_Support AS X ON Z.ticketId = X.ticketId WHERE (ISNULL(X.remarks, '') LIKE CASE WHEN @keyword <> '' THEN '%' + @keyword + '%' ELSE ISNULL(X.remarks , '') END))) OR (HD_Ticket.assignHOU = @sessionEmpID) AND (HD_Ticket.ticketNo LIKE '%' + @ticketNo + '%') AND (CONVERT (varchar, HD_Ticket.createdDt, 103) LIKE '%' + @createdDt + '%') AND (HD_Category.category + ' | ' + HD_SubCategory.subCategory LIKE '%' + @category + '%') AND (HD_Ticket.solution LIKE '%' + @keyword + '%') OR (HD_Ticket.ticketNo LIKE '%' + @ticketNo + '%') AND (CONVERT (varchar, HD_Ticket.createdDt, 103) LIKE '%' + @createdDt + '%') AND (HD_Category.category + ' | ' + HD_SubCategory.subCategory LIKE '%' + @category + '%') AND (HD_Ticket.ticketId IN (SELECT ticketId FROM HD_Support AS HD_Support_4 WHERE (EmpID = @sessionEmpID))) AND (HD_Ticket.solution LIKE '%' + @keyword + '%') OR (HD_Ticket.assignHOU = @sessionEmpID) AND (HD_Ticket.ticketNo LIKE '%' + @ticketNo + '%') AND (CONVERT (varchar, HD_Ticket.createdDt, 103) LIKE '%' + @createdDt + '%') AND (HD_Category.category + ' | ' + HD_SubCategory.subCategory LIKE '%' + @category + '%') AND (HD_Ticket.remark LIKE '%' + @keyword + '%') OR (HD_Ticket.ticketNo LIKE '%' + @ticketNo + '%') AND (CONVERT (varchar, HD_Ticket.createdDt, 103) LIKE '%' + @createdDt + '%') AND (HD_Category.category + ' | ' + HD_SubCategory.subCategory LIKE '%' + @category + '%') AND (HD_Ticket.ticketId IN (SELECT ticketId FROM HD_Support AS HD_Support_3 WHERE (EmpID = @sessionEmpID))) AND (HD_Ticket.remark LIKE '%' + @keyword + '%') OR (HD_Ticket.assignHOU = @sessionEmpID) AND (HD_Ticket.ticketNo LIKE '%' + @ticketNo + '%') AND (CONVERT (varchar, HD_Ticket.createdDt, 103) LIKE '%' + @createdDt + '%') AND (HD_Category.category + ' | ' + HD_SubCategory.subCategory LIKE '%' + @category + '%') AND (HD_Ticket.returnremark LIKE '%' + @keyword + '%') OR (HD_Ticket.ticketNo LIKE '%' + @ticketNo + '%') AND (CONVERT (varchar, HD_Ticket.createdDt, 103) LIKE '%' + @createdDt + '%') AND (HD_Category.category + ' | ' + HD_SubCategory.subCategory LIKE '%' + @category + '%') AND (HD_Ticket.ticketId IN (SELECT ticketId FROM HD_Support AS HD_Support_2 WHERE (EmpID = @sessionEmpID))) AND (HD_Ticket.returnremark LIKE '%' + @keyword + '%') OR (HD_Ticket.ticketId IN (SELECT CASE WHEN @ticketNo <> '%%' OR @createdDt <> '%%' OR @category <> '' OR @keyword <> '%%' THEN '0' ELSE ticketId END AS Expr1 FROM HD_Support AS HD_Support_1 WHERE (EmpID = @sessionEmpID))) 
) AS tbl1 WHERE tbl1.status = 1"

                Dim myCommand As New SqlCommand(strSQL, myConnection)
                myCommand.Parameters.AddWithValue("@sessionEmpID", HttpContext.Current.Session.Item("sessionEmpID"))
                myCommand.Parameters.AddWithValue("@ticketNo", "%%")
                myCommand.Parameters.AddWithValue("@category", "%%")
                myCommand.Parameters.AddWithValue("@createdDt", "%%")
                myCommand.Parameters.AddWithValue("@keyword", "%%")

                myConnection.Open()

                Dim myReader As SqlDataReader = myCommand.ExecuteReader

                If myReader.Read Then
                    Try
                        notificationCount = myReader.Item("cnt")
                    Catch ex As Exception
                        notificationCount = 0
                    End Try

                End If

                myReader.Close()

                myConnection.Close()

            End Using
        Catch ex As Exception

        End Try

        Return notificationCount
    End Function

    Public Shared Function getWebconOveride() As String

        Dim retval As String = ""

        '//start check if super admin
        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Const SQL As String = "SELECT Webcon_Overide FROM [TBL_WEBCONFIG] WHERE Webcon_Enabled = 'Y' "

            Dim myCommand As New SqlCommand(SQL, myConnection)

            myConnection.Open()

            Dim myReader As SqlDataReader = myCommand.ExecuteReader

            If myReader.Read Then

                Dim Webcon_Footer = myReader.Item("Webcon_Overide")

                retval = String.Concat(retval, Webcon_Footer)

            End If

            myReader.Close()

            myConnection.Close()

        End Using

        Return retval
    End Function

    Public Shared Function WriteAdminMenuParent(ByVal paraMenuId As Integer, ByVal userrole As Integer, ByVal isAdmin As Integer) As String
        Dim retval As String = ""

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
            myConnection.Open()

            Dim SQL As String = ""
            SQL = "SELECT UGM.UGM_SystemId,SYS.system_Name
            FROM [TBL_USER_GROUPLIST] UGL 
            INNER JOIN [TBL_USER_GROUPROLE] UGR ON UGR.UGR_UGN_Id = UGL.UGL_UGN_Id 
            INNER JOIN [TBL_USER_GROUPMODULE] UGM ON UGR.UGR_UGM_Id = UGM.UGM_Id
            LEFT JOIN TBL_SYSTEM SYS ON SYS.system_Id = UGM.UGM_SystemId 
            WHERE UGL.UGL_Users_Id = @UGL_Users_Id
            AND UGR.UGR_Read = 1
            group by UGM.UGM_SystemId,SYS.system_Name 
            "



            Dim myCommand As New SqlCommand(SQL, myConnection)
            myCommand.Parameters.AddWithValue("@UGL_Users_Id", HttpContext.Current.Session.Item("sessionUsersId"))

            Dim myReader As SqlDataReader = myCommand.ExecuteReader
            Dim j As Integer = 0
            Dim isActive As String = ""

            Do While myReader.Read()

                Dim UGM_Name = myReader.Item("UGM_SystemId")
                Dim system_Name = myReader.Item("system_Name")

                retval = String.Concat(retval, "<li class='nav-title'>" & system_Name & "</li>")
                retval = String.Concat(retval, GlobalClass.WriteAdminMenu(0, 0, 0, UGM_Name))


            Loop

            myReader.Close()

            myConnection.Close()
            myConnection.Dispose()
        End Using

        Return retval

    End Function
    Public Shared Function WriteAdminMenu(ByVal paraMenuId As Integer, ByVal userrole As Integer, ByVal isAdmin As Integer, Optional ByVal sessionSystemId As Integer = 1) As String

        isAdmin = HttpContext.Current.Session.Item("sessionisadmin")
        userrole = HttpContext.Current.Session.Item("sessionuserrole")
        Dim sessionUserId As Integer = HttpContext.Current.Session.Item("sessionUsersId")
        'Dim sessionSystemId As Integer = 0
        Try
            'sessionSystemId = HttpContext.Current.Session.Item("sessionSystemId")
        Catch ex As Exception

        End Try

        Dim retval As String
        Dim glblClass As New GlobalClass()
        retval = ""

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
            myConnection.Open()

            Dim myCommand As New SqlCommand("generateAdminMenu_PROC3", myConnection)
            myCommand.Parameters.AddWithValue("@UGM_Id", paraMenuId)
            myCommand.Parameters.AddWithValue("@UGR_UGN_Id", userrole)
            myCommand.Parameters.AddWithValue("@UGN_IsAdmin", isAdmin)
            myCommand.Parameters.AddWithValue("@userid", sessionUserId)
            myCommand.Parameters.AddWithValue("@systemID", sessionSystemId)

            myCommand.CommandType = CommandType.StoredProcedure

            Dim myReader As SqlDataReader = myCommand.ExecuteReader
            Dim j As Integer = 0
            Dim isActive As String = ""

            Do While myReader.Read()

                Dim UGM_Name = myReader.Item("UGM_Name")
                Dim UGM_ContentId = myReader.Item("UGM_ContentId")
                Dim UGM_ParentId = myReader.Item("UGM_ParentId")
                Dim UGM_Id = myReader.Item("UGM_Id")
                Dim UGM_Filename = myReader.Item("UGM_Filename")
                Dim UGR_UGN_Id = myReader.Item("UGR_UGN_Id")
                Dim UGM_Level = myReader.Item("UGM_Level")
                Dim UGN_IsAdmin = myReader.Item("UGN_IsAdmin")
                Dim UGM_Menu_Icon = myReader.Item("UGM_Menu_Icon")
                Dim UGM_Menu_SVG = myReader.Item("UGM_Menu_SVG")
                Dim filepath As String

                Dim pageFilename As String
                pageFilename = System.IO.Path.GetFileName(HttpContext.Current.Request.ServerVariables("SCRIPT_NAME"))

                j = j + 1

                If j = 1 And HttpContext.Current.Request.QueryString("p_Id") = "" Then
                    isActive = "active"
                Else
                    isActive = ""
                End If

                If InStr(UGM_Filename.ToString, "p_Id") > 0 Then
                    filepath = UGM_Filename.ToString

                Else
                    filepath = UGM_Filename.ToString + "&p_Id=" + UGM_ParentId.ToString
                End If

                If InStr(UGM_Filename.ToString, "?") > 0 Then

                    If InStr(UGM_Filename.ToString, "p_Id") > 0 Then
                        filepath = UGM_Filename.ToString
                    Else
                        filepath = UGM_Filename.ToString + "&p_Id=" + UGM_ParentId.ToString
                    End If

                Else
                    filepath = UGM_Filename.ToString + "?p_Id=" + UGM_ParentId.ToString
                End If

                '//append Menu ID
                If InStr(filepath, "?") > 0 Then
                    filepath = filepath + "&m_Id=" + UGM_Id.ToString
                Else
                    filepath = UGM_Filename.ToString + "?m_Id=" + UGM_Id.ToString
                End If

                If UGM_ContentId.ToString = "0" And UGM_Filename.ToString = "" Then '// ori : Menu_ContentId.ToString = "0" And Menu_ParentId.ToString = 0 And Menu_Filename.ToString <> "Default.aspx"

                    If UGM_Level = 1 Then
                        If UGM_Id = HttpContext.Current.Request.QueryString("p_Id") Then


                            retval = String.Concat(retval, "<li Class='nav-group'><a class='nav-link nav-group-toggle' href='#'>
                                <svg Class='nav-icon'>
                                    <use xlink :  href=' " & VirtualPathUtility.ToAbsolute("~/vendors/@coreui/icons/svg/free.svg#") & "" & UGM_Menu_SVG & "'></use>
                                </svg> " + UGM_Name + "</a>
                                <ul Class='nav-group-items'> " & GlobalClass.WriteAdminMenu_Sub(UGM_Id, 0, 0, sessionSystemId) & "</ul>
                            </li>")


                        Else

                            retval = String.Concat(retval, "<li Class='nav-group'><a class='nav-link nav-group-toggle' href='#'>
                                <svg Class='nav-icon'>
                                    <use xlink :  href='" & VirtualPathUtility.ToAbsolute("~/vendors/@coreui/icons/svg/free.svg#") & "" & UGM_Menu_SVG & "'></use>
                                </svg> " + UGM_Name + "</a>
                                <ul Class='nav-group-items'> " & GlobalClass.WriteAdminMenu_Sub(UGM_Id, 0, 0, sessionSystemId) & "</ul>
                            </li>")
                        End If

                    Else

                    End If
                Else
                    If UGM_Level = 1 Then

                    Else

                    End If

                End If


            Loop

            myReader.Close()

            myConnection.Close()
            myConnection.Dispose()
        End Using

        Return retval

    End Function

    Private Shared parentMenu As String = ""

    Public Shared Function WriteAdminMenu_Sub(ByVal paraMenuId As Integer, ByVal userrole As Integer, ByVal isAdmin As Integer, Optional ByVal sessionSystemId As Integer = 1) As String
        Dim retval As String = ""
        isAdmin = HttpContext.Current.Session.Item("sessionisadmin")
        'MsgBox(isAdmin)
        userrole = HttpContext.Current.Session.Item("sessionuserrole")
        Dim sessionUserId As Integer = HttpContext.Current.Session.Item("sessionUsersId")
        'Dim sessionSystemId As Integer = 0
        Try
            'sessionSystemId = HttpContext.Current.Session.Item("sessionSystemId")
        Catch ex As Exception

        End Try

        Dim glblClass As New GlobalClass()
        retval = ""
        Dim j As Integer = 0
        Dim parentMenu2 As String = ""
        Dim isActive As String = ""
        Dim showSubTitle As Boolean = False
        Dim UGM_NameParent As String = ""

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
            myConnection.Open()

            Dim myCommand As New SqlCommand("generateAdminMenu_PROC3", myConnection)
            myCommand.Parameters.AddWithValue("@UGM_Id", paraMenuId)
            myCommand.Parameters.AddWithValue("@UGR_UGN_Id", userrole)
            myCommand.Parameters.AddWithValue("@UGN_IsAdmin", isAdmin)
            myCommand.Parameters.AddWithValue("@userid", sessionUserId)
            myCommand.Parameters.AddWithValue("@systemID", sessionSystemId)

            myCommand.CommandType = CommandType.StoredProcedure

            Dim myReader As SqlDataReader = myCommand.ExecuteReader


            Do While myReader.Read()

                Dim UGM_Name = myReader.Item("UGM_Name")
                Dim UGM_ContentId = myReader.Item("UGM_ContentId")
                Dim UGM_ParentId = myReader.Item("UGM_ParentId")
                Dim UGM_Id = myReader.Item("UGM_Id")
                Dim UGM_Filename = myReader.Item("UGM_Filename")
                Dim UGR_UGN_Id = myReader.Item("UGR_UGN_Id")
                Dim UGM_Level = myReader.Item("UGM_Level")
                Dim UGN_IsAdmin = myReader.Item("UGN_IsAdmin")
                Dim UGM_Menu_Icon = myReader.Item("UGM_Menu_Icon")
                Dim filepath As String

                Dim pageFilename As String
                pageFilename = System.IO.Path.GetFileName(HttpContext.Current.Request.ServerVariables("SCRIPT_NAME"))

                j = j + 1


                If UGM_ParentId = 0 Then
                    parentMenu = CStr(UGM_Id)
                Else
                    parentMenu = CStr(UGM_ParentId)
                End If



                If InStr(UGM_Filename.ToString, "p_Id") > 0 Then
                    filepath = UGM_Filename.ToString

                Else
                    filepath = UGM_Filename.ToString + "&p_Id=" + UGM_ParentId.ToString
                End If


                If InStr(UGM_Filename.ToString, "?") > 0 Then

                    If InStr(UGM_Filename.ToString, "p_Id") > 0 Then
                        filepath = UGM_Filename.ToString
                    Else
                        filepath = UGM_Filename.ToString + "&p_Id=" + UGM_ParentId.ToString
                    End If

                Else
                    filepath = UGM_Filename.ToString + "?p_Id=" + UGM_ParentId.ToString
                End If

                '//append Menu ID
                If InStr(filepath, "?") > 0 Then
                    filepath = filepath + "&m_Id=" + UGM_Id.ToString
                Else
                    filepath = UGM_Filename.ToString + "?m_Id=" + UGM_Id.ToString
                End If

                If UGM_Level = 1 Then
                    'If UGM_Id = HttpContext.Current.Request.QueryString("p_Id") Then
                    '    'retval = String.Concat(retval, "<div class='tab-pane fade active show' id='A" + CStr(UGM_Id) + "' >")
                    'Else
                    '    'retval = String.Concat(retval, "<div class='tab-pane fade " + isActive + "' id='A" + CStr(UGM_Id) + "' >")
                    'End If
                    'showSubTitle = True
                    'UGM_NameParent = UGM_Name
                Else

                    If (UGM_Filename.ToString.Contains(pageFilename)) Then

                        If showSubTitle = True Then
                            'retval = String.Concat(retval, "<li class='nav-title'>" & UGM_NameParent & "</li>")

                            'retval = String.Concat(retval, "<li Class='nav-group'><a class='nav-link nav-group-toggle' href='#'><svg Class='nav-icon'><use xlink :  href='vendors/@coreui/icons/svg/free.svg#cil-puzzle'></use></svg> Base</a>")
                            'retval = String.Concat(retval, "<ul Class='nav-group-items'>")

                        End If

                        retval = String.Concat(retval, "<li class='nav-item'><a class='nav-link' href='" + VirtualPathUtility.ToAbsolute("~" + filepath) + "'><span class='nav-icon'></span> " + UGM_Name + "</a></li>")
                    Else

                        If showSubTitle = True Then
                            'retval = String.Concat(retval, "<li class='nav-title'>" & UGM_NameParent & "</li>")
                        End If



                        retval = String.Concat(retval, "<li Class='nav-item'><a class='nav-link' href='" + VirtualPathUtility.ToAbsolute("~" + filepath) + "'><span class='nav-icon'></span> " + UGM_Name + "</a></li>")
                    End If

                    showSubTitle = False
                End If


            Loop

            myReader.Close()

            myConnection.Close()
            myConnection.Dispose()
        End Using


        Return retval
    End Function

    'Public Shared Function WriteAdminMenu_Sub(ByVal paraMenuId As Integer, ByVal userrole As Integer, ByVal isAdmin As Integer) As String

    '    isAdmin = HttpContext.Current.Session.Item("sessionisadmin")
    '    'MsgBox(isAdmin)
    '    userrole = HttpContext.Current.Session.Item("sessionuserrole")
    '    Dim sessionUserId As Integer = HttpContext.Current.Session.Item("sessionUsersId")
    '    Dim sessionSystemId As Integer = 0
    '    Try
    '        sessionSystemId = HttpContext.Current.Session.Item("sessionSystemId")
    '    Catch ex As Exception

    '    End Try

    '    Dim retval As String
    '    Dim glblClass As New GlobalClass()
    '    retval = ""
    '    Dim j As Integer = 0
    '    Dim parentMenu2 As String = ""
    '    Dim isActive As String = ""
    '    Dim showSubTitle As Boolean = False
    '    Dim UGM_NameParent As String = ""

    '    Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
    '        myConnection.Open()

    '        Dim myCommand As New SqlCommand("generateAdminMenu_PROC3", myConnection)
    '        myCommand.Parameters.AddWithValue("@UGM_Id", paraMenuId)
    '        myCommand.Parameters.AddWithValue("@UGR_UGN_Id", userrole)
    '        myCommand.Parameters.AddWithValue("@UGN_IsAdmin", isAdmin)
    '        myCommand.Parameters.AddWithValue("@userid", sessionUserId)
    '        myCommand.Parameters.AddWithValue("@systemID", sessionSystemId)

    '        myCommand.CommandType = CommandType.StoredProcedure

    '        Dim myReader As SqlDataReader = myCommand.ExecuteReader


    '        Do While myReader.Read()

    '            Dim UGM_Name = myReader.Item("UGM_Name")
    '            Dim UGM_ContentId = myReader.Item("UGM_ContentId")
    '            Dim UGM_ParentId = myReader.Item("UGM_ParentId")
    '            Dim UGM_Id = myReader.Item("UGM_Id")
    '            Dim UGM_Filename = myReader.Item("UGM_Filename")
    '            Dim UGR_UGN_Id = myReader.Item("UGR_UGN_Id")
    '            Dim UGM_Level = myReader.Item("UGM_Level")
    '            Dim UGN_IsAdmin = myReader.Item("UGN_IsAdmin")
    '            Dim UGM_Menu_Icon = myReader.Item("UGM_Menu_Icon")
    '            Dim filepath As String

    '            Dim pageFilename As String
    '            pageFilename = System.IO.Path.GetFileName(HttpContext.Current.Request.ServerVariables("SCRIPT_NAME"))

    '            j = j + 1


    '            If j = 1 And HttpContext.Current.Request.QueryString("p_Id") = "" Then
    '                isActive = "active show"
    '            Else
    '                isActive = ""
    '            End If

    '            If UGM_ParentId = 0 Then
    '                parentMenu2 = CStr(UGM_Id)
    '            Else
    '                parentMenu2 = CStr(UGM_ParentId)
    '            End If

    '            If parentMenu <> parentMenu2 And j > 1 Then
    '                retval = String.Concat(retval, "</li>")
    '            End If


    '            If UGM_ParentId = 0 Then
    '                parentMenu = CStr(UGM_Id)
    '            Else
    '                parentMenu = CStr(UGM_ParentId)
    '            End If



    '            If InStr(UGM_Filename.ToString, "p_Id") > 0 Then
    '                filepath = UGM_Filename.ToString

    '            Else
    '                filepath = UGM_Filename.ToString + "&p_Id=" + UGM_ParentId.ToString
    '            End If


    '            If InStr(UGM_Filename.ToString, "?") > 0 Then

    '                If InStr(UGM_Filename.ToString, "p_Id") > 0 Then
    '                    filepath = UGM_Filename.ToString
    '                Else
    '                    filepath = UGM_Filename.ToString + "&p_Id=" + UGM_ParentId.ToString
    '                End If

    '            Else
    '                filepath = UGM_Filename.ToString + "?p_Id=" + UGM_ParentId.ToString
    '            End If

    '            '//append Menu ID
    '            If InStr(filepath, "?") > 0 Then
    '                filepath = filepath + "&m_Id=" + UGM_Id.ToString
    '            Else
    '                filepath = UGM_Filename.ToString + "?m_Id=" + UGM_Id.ToString
    '            End If

    '            If UGM_Level = 1 Then
    '                If UGM_Id = HttpContext.Current.Request.QueryString("p_Id") Then
    '                    'retval = String.Concat(retval, "<div class='tab-pane fade active show' id='A" + CStr(UGM_Id) + "' >")
    '                Else
    '                    'retval = String.Concat(retval, "<div class='tab-pane fade " + isActive + "' id='A" + CStr(UGM_Id) + "' >")
    '                End If
    '                showSubTitle = True
    '                UGM_NameParent = UGM_Name
    '            Else

    '                If (UGM_Filename.ToString.Contains(pageFilename)) Then

    '                    'retval = String.Concat(retval, "<ul class='metismenu tab-nav-menu'>")

    '                    If showSubTitle = True Then
    '                        retval = String.Concat(retval, "<li class='nav-title'>" & UGM_NameParent & "</li>")

    '                        retval = String.Concat(retval, "<li Class='nav-group'><a class='nav-link nav-group-toggle' href='#'><svg Class='nav-icon'><use xlink :  href='vendors/@coreui/icons/svg/free.svg#cil-puzzle'></use></svg> Base</a>")
    '                        retval = String.Concat(retval, "<ul Class='nav-group-items'>")

    '                    End If

    '                    retval = String.Concat(retval, "<li Class='nav-item'><a class='nav-link' href='" + filepath + "'><span class='nav-icon'></span> </a></li>")
    '                Else

    '                    'retval = String.Concat(retval, "<ul class='metismenu tab-nav-menu'>")

    '                    If showSubTitle = True Then
    '                        retval = String.Concat(retval, "<li class='nav-title'>" & UGM_NameParent & "</li>")
    '                    End If



    '                    retval = String.Concat(retval, "<li Class='nav-item'><a class='nav-link' href='" + filepath + "'><span class='nav-icon'></span> " + UGM_Name + "</a></li>")
    '                End If

    '                showSubTitle = False
    '            End If


    '        Loop

    '        myReader.Close()

    '        myConnection.Close()
    '        myConnection.Dispose()
    '    End Using

    '    If j > 0 Then
    '        retval = String.Concat(retval, "</li>")
    '    End If
    '    Return retval
    'End Function

    Public Shared Function checkDuplicate(paraListName() As String, paraListValue() As String, tableName As String, Optional ByVal whereStr As String = "", Optional ByVal primaryKey As Integer = 0, Optional ByVal primaryKeyName As String = "") As Boolean
        Dim retval As Boolean = False

        Dim i As Integer = 0
        For Each ParaValue In paraListValue

            Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

                Dim SQL As String = "select * from " & tableName & " where UPPER(" & paraListName(i) & ") = UPPER(@paraListValue) "

                If whereStr <> "" Then
                    SQL = SQL & " and " & whereStr
                End If

                If primaryKey > 0 Then
                    SQL = SQL & " and " & primaryKeyName & " <> @primaryKey "
                End If

                Dim myCommandEdit As New SqlCommand(SQL, myConnection)
                myCommandEdit.Parameters.AddWithValue("@paraListValue", paraListValue(i))
                myCommandEdit.Parameters.AddWithValue("@primaryKey", primaryKey)

                myConnection.Open()

                Dim myReader As SqlDataReader = myCommandEdit.ExecuteReader

                If myReader.Read Then
                    'MsgBox(myReader(primaryKeyName))
                    retval = True

                End If

                myReader.Close()

                myConnection.Close()

            End Using

            i = i + 1
        Next


        Return retval
    End Function

    Public Shared Function checkDuplicateBySQL(strSQL As String) As Boolean
        Dim retval As Boolean = False


        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Dim myCommandEdit As New SqlCommand(strSQL, myConnection)
            myConnection.Open()

            Dim myReader As SqlDataReader = myCommandEdit.ExecuteReader

            If myReader.Read Then
                retval = True
            End If

            myReader.Close()

            myConnection.Close()

        End Using
        Return retval
    End Function

    Public Shared Function removeSession(sessionStr As String) As Boolean

        Dim keys As New List(Of String)()
        For Each key As String In HttpContext.Current.Session.Keys
            keys.Add(key)
        Next
        For Each key As String In keys

            If key.Contains(sessionStr) Then
                HttpContext.Current.Session.Remove(key)
            End If
        Next

        Return True
    End Function
    Public Shared Function GetMonthYear(ByVal EstateID As Long, ByVal ActMyID As String, ByRef Amonth As String, ByRef Ayear As String, Optional ByRef Month As String = "") As Boolean

        Dim lstr As String
        Dim sdr As System.Data.SqlClient.SqlDataReader
        Dim lflag As Boolean

        lstr = "select Amonth , Ayear from ActiveMonthYear where EstateID=" & EstateID & " and ActMthYearID='" & ActMyID & "'"

        sdr = SysCon.ExecuteReader(lstr)

        If sdr.Read Then

            If Not sdr.IsDBNull(0) And Not sdr.IsDBNull(1) Then

                Ayear = sdr("Ayear")

                If sdr("Amonth") = 1 Then
                    Amonth = "January"
                    Month = "01"
                ElseIf sdr("Amonth") = 2 Then
                    Amonth = "February"
                    Month = "02"
                ElseIf sdr("Amonth") = 3 Then
                    Amonth = "March"
                    Month = "03"
                ElseIf sdr("Amonth") = 4 Then
                    Amonth = "April"
                    Month = "04"
                ElseIf sdr("Amonth") = 5 Then
                    Amonth = "May"
                    Month = "05"
                ElseIf sdr("Amonth") = 6 Then
                    Amonth = "June"
                    Month = "06"
                ElseIf sdr("Amonth") = 7 Then
                    Amonth = "July"
                    Month = "07"
                ElseIf sdr("Amonth") = 8 Then
                    Amonth = "August"
                    Month = "08"
                ElseIf sdr("Amonth") = 9 Then
                    Amonth = "September"
                    Month = "09"
                ElseIf sdr("Amonth") = 10 Then
                    Amonth = "October"
                    Month = "10"
                ElseIf sdr("Amonth") = 11 Then
                    Amonth = "November"
                    Month = "11"
                ElseIf sdr("Amonth") = 12 Then
                    Amonth = "December"
                    Month = "12"
                End If

                lflag = True

            End If

        End If

        If Not sdr.IsClosed Then sdr.Close()

        Return lflag

    End Function

    Public Shared Function GetMonthYearBM(ByVal EstateID As Long, ByVal ActMyID As String, ByRef Amonth As String, ByRef Ayear As String, Optional ByRef Month As String = "") As Boolean

        Dim lstr As String
        Dim sdr As System.Data.SqlClient.SqlDataReader
        Dim lflag As Boolean

        lstr = "select Amonth , Ayear from ActiveMonthYear where EstateID=" & EstateID & " and ActMthYearID='" & ActMyID & "'"

        sdr = SysCon.ExecuteReader(lstr)

        If sdr.Read Then

            If Not sdr.IsDBNull(0) And Not sdr.IsDBNull(1) Then

                Ayear = sdr("Ayear")

                If sdr("Amonth") = 1 Then
                    Amonth = "Januari"
                    Month = "01"
                ElseIf sdr("Amonth") = 2 Then
                    Amonth = "Februari"
                    Month = "02"
                ElseIf sdr("Amonth") = 3 Then
                    Amonth = "Mac"
                    Month = "03"
                ElseIf sdr("Amonth") = 4 Then
                    Amonth = "April"
                    Month = "04"
                ElseIf sdr("Amonth") = 5 Then
                    Amonth = "Mei"
                    Month = "05"
                ElseIf sdr("Amonth") = 6 Then
                    Amonth = "Jun"
                    Month = "06"
                ElseIf sdr("Amonth") = 7 Then
                    Amonth = "Julai"
                    Month = "07"
                ElseIf sdr("Amonth") = 8 Then
                    Amonth = "Ogos"
                    Month = "08"
                ElseIf sdr("Amonth") = 9 Then
                    Amonth = "September"
                    Month = "09"
                ElseIf sdr("Amonth") = 10 Then
                    Amonth = "Oktober"
                    Month = "10"
                ElseIf sdr("Amonth") = 11 Then
                    Amonth = "November"
                    Month = "11"
                ElseIf sdr("Amonth") = 12 Then
                    Amonth = "Disember"
                    Month = "12"
                End If

                lflag = True

            End If

        End If

        If Not sdr.IsClosed Then sdr.Close()

        Return lflag

    End Function

    Public Shared Function GetActMthYear(ByVal pModule As String, ByVal pMonth As Integer, ByVal pYear As Integer, ByVal pEstateID As Integer, ByVal pStatus As String) As String
        Dim lstrSql As String = "SELECT     *" &
                                  "  FROM       ActiveMonthYear a INNER JOIN " &
                                                        "Module b ON a.ModID = b.ModID AND b.EstateID = " & pEstateID _
                                   & " WHERE     (b.ModDesc = '" & pModule & "') AND (a.AMonth = " & pMonth & ") " &
                                   " AND (a.AYear = '" & pYear & "') AND a.Status = '" & pStatus & "'" &
                                   " AND a.EstateID = " & pEstateID & ""


        Dim dsGetActMthYear As DataSet
        dsGetActMthYear = SysCon.ExecuteDataset(lstrSql)

        If dsGetActMthYear.Tables(0).Rows.Count > 0 Then
            Return dsGetActMthYear.Tables(0).Rows(0).Item("ActMthYearID")
        Else
            Return "No Record Found"
        End If

    End Function
    'Public Shared Function insertTranslate(ByVal Lang_detail_text As String, Optional ByVal Lang_detail_category As String = "", Optional ByVal Lang_detail_code As String = "", Optional ByVal Lang_detail_description As String = "", Optional ByVal auto_insert As Boolean = False) As Boolean
    '    Dim retval As Boolean = False

    '    Dim Users_Id As Integer = HttpContext.Current.Session.Item("sessionUsersId")
    '    Dim Lang_hd_code As String = HttpContext.Current.Session.Item("sessionLang")

    '    If Lang_hd_code = "" Then
    '        Lang_hd_code = "MAL"
    '    End If

    '    '// check translate
    '    Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

    '        Dim SQL As String = "SELECT A.* FROM TBL_LANG_DETAIL A  WHERE A.Lang_detail_code = @Lang_detail_code AND A.Lang_detail_IsPublish = 'true' "

    '        Dim myCommand As New SqlCommand(SQL, myConnection)
    '        myCommand.Parameters.AddWithValue("@Lang_detail_code", Lang_detail_code)


    '        myConnection.Open()

    '        Dim myReader As SqlDataReader = myCommand.ExecuteReader

    '        While myReader.Read
    '            If Not IsDBNull(myReader.Item("Lang_detail_code")) Then

    '                If myReader.Item("Lang_detail_code") <> "" Then
    '                    'retval = myReader.Item("Lang_trans_text")
    '                    retval = True
    '                End If

    '            End If

    '        End While



    '        myReader.Close()

    '        myConnection.Close()

    '    End Using

    '    If retval = False Then


    '        Using myConnectionInsert As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

    '            Dim SQLInsert As String = "INSERT INTO TBL_LANG_DETAIL (Lang_detail_code,Lang_detail_category,Lang_detail_description,Lang_detail_text,Lang_detail_IsPublish,CreatedBy,CreatedDate) VALUES " & _
    '                                                                    "(@Lang_detail_code,@Lang_detail_category,@Lang_detail_description,@Lang_detail_text,'true',@CreatedBy,getdate()) "

    '            Dim myCommandInsert As New SqlCommand(SQLInsert, myConnectionInsert)
    '            myCommandInsert.Parameters.AddWithValue("@Lang_detail_code", Lang_detail_code)
    '            myCommandInsert.Parameters.AddWithValue("@Lang_detail_category", Lang_detail_category)
    '            myCommandInsert.Parameters.AddWithValue("@Lang_detail_description", Lang_detail_description)
    '            myCommandInsert.Parameters.AddWithValue("@Lang_detail_text", Lang_detail_text)
    '            myCommandInsert.Parameters.AddWithValue("@CreatedBy", Users_Id)

    '            myConnectionInsert.Open()

    '            Dim recordsetCounter As Integer = myCommandInsert.ExecuteNonQuery()

    '            myConnectionInsert.Close()

    '            retval = True

    '        End Using

    '    End If


    '    Return retval
    'End Function

    'Public Shared Function translang(ByVal Lang_detail_text As String, Optional ByVal Lang_detail_category As String = "", Optional ByVal Lang_detail_code As String = "", Optional ByVal Lang_detail_description As String = "", Optional ByVal auto_insert As Boolean = False) As String

    '    Dim retval As String = Lang_detail_text

    '    Dim Users_Id As Integer = HttpContext.Current.Session.Item("sessionUsersId")
    '    Dim Lang_hd_code As String = HttpContext.Current.Session.Item("sessionLang")

    '    If Lang_hd_code = "" Then
    '        Lang_hd_code = "MAL"
    '    End If

    '    '//start insert if true
    '    If auto_insert = True Then
    '        insertTranslate(Lang_detail_text, Lang_detail_category, Lang_detail_code, Lang_detail_description, auto_insert)
    '    End If


    '    '//start check translate
    '    Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

    '        Dim SQL As String = "SELECT A.* FROM TBL_LANG_TRANS A  "

    '        SQL = SQL + " INNER JOIN TBL_LANG_DETAIL B ON B.Lang_detail_id = A.Lang_detail_id "
    '        SQL = SQL + " INNER JOIN TBL_LANG_HD C ON C.Lang_hd_id = A.Lang_hd_id "

    '        SQL = SQL + " WHERE 1 = 1 AND C.Lang_hd_code = @Lang_hd_code"

    '        If Lang_detail_code <> "" Then
    '            SQL = SQL + " AND B.Lang_detail_code = @Lang_detail_code "
    '        Else
    '            SQL = SQL + " AND Lang_detail_text = @Lang_detail_text"
    '        End If

    '        SQL = SQL + " AND A.Lang_trans_IsPublish = 'true' "
    '        SQL = SQL + " AND B.Lang_detail_IsPublish = 'true' "
    '        SQL = SQL + " AND C.Lang_hd_IsPublish = 'true' "

    '        Dim myCommand As New SqlCommand(SQL, myConnection)
    '        myCommand.Parameters.AddWithValue("@Lang_hd_code", Lang_hd_code)

    '        If Lang_detail_code <> "" Then
    '            myCommand.Parameters.AddWithValue("@Lang_detail_code", Lang_detail_code)
    '        Else
    '            myCommand.Parameters.AddWithValue("@Lang_detail_text", Lang_detail_text)
    '        End If


    '        myConnection.Open()

    '        Dim myReader As SqlDataReader = myCommand.ExecuteReader

    '        While myReader.Read
    '            If Not IsDBNull(myReader.Item("Lang_trans_text")) Then

    '                If myReader.Item("Lang_trans_text") <> "" Then
    '                    retval = myReader.Item("Lang_trans_text")
    '                End If

    '            End If

    '        End While



    '        myReader.Close()

    '        myConnection.Close()

    '    End Using

    '    Return retval
    'End Function

    Public Shared Function isSuperAdmin(ByVal Users_Id As String) As Boolean

        Dim retval As Boolean = False

        If Users_Id = "" Then
            Users_Id = HttpContext.Current.Session.Item("sessionUsersId")
        End If

        If Users_Id > 0 Then


            '//start check if super admin
            Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

                Const SQL As String = "SELECT UGN.* " &
                "FROM [TBL_USER_GROUPLIST] UGL " &
                "INNER JOIN [TBL_USER_GROUPNAME] UGN ON UGL.UGL_UGN_Id = UGN.UGN_Id " &
                "WHERE UGL.UGL_Users_Id = @User_Id " &
                "AND UGN.UGN_IsAdmin = 1 "

                Dim myCommandEdit As New SqlCommand(SQL, myConnection)
                myCommandEdit.Parameters.AddWithValue("@User_Id", Users_Id)

                myConnection.Open()

                Dim myReader As SqlDataReader = myCommandEdit.ExecuteReader

                If myReader.Read Then

                    retval = True
                    'Response.Write("Granted")
                    'Response.End()

                End If

                myReader.Close()

                myConnection.Close()

            End Using

        End If

        Return retval
    End Function

    Public Shared Function writeBreadcrumb(ByVal Parent_Id As Integer, ByVal Menu_Content As String, ByVal System_Id As Integer) As String

        Dim retval As String = ""
        Dim glblClass As New GlobalClass()

        Try
            Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

                myConnection.Open()


                Dim SQLSelect As String = "WITH CTE_Menu AS  " &
                    "( " &
                    "	SELECT " &
                    "        P1.UGM_SeqNo " &
                    "        , P1.UGM_ParentId " &
                    "        , P1.UGM_Id " &
                    "		, CAST([UGM_Name] As NVARCHAR(MAX)) As Breadcrumb " &
                    "		, CAST([UGM_Filename] As NVARCHAR(MAX)) As Pathfile " &
                    "    From TBL_USER_GROUPMODULE As P1 " &
                    "    WHERE UGM_Id = @Menu_Content " &
                    "    UNION ALL " &
                    "	SELECT " &
                    "        P2.UGM_SeqNo " &
                    "        , P2.UGM_ParentId " &
                    "        , C.UGM_Id " &
                    "        , CAST(P2.[UGM_Name] As NVARCHAR(MAX)) " &
                    "        , CAST([UGM_Filename] As NVARCHAR(MAX)) " &
                    "    FROM " &
                    "        TBL_USER_GROUPMODULE As P2 " &
                    "		Join CTE_Menu As C " &
                    "			ON C.UGM_ParentId = P2.UGM_Id " &
                    ") " &
                    "select * from ( " &
                    "Select -1 As UGM_SeqNo,0 As UGM_ParentId,@Menu_Content As UGM_Id,a.system_Name As Breadcrumb,a.system_Path As Pathfile " &
                    "From TBL_SYSTEM a Where a.system_Id = @System_Id " &
                    "union all " &
                    "SELECT UGM_SeqNo,coalesce(UGM_ParentId,0) as UGM_ParentId,coalesce(UGM_Id,0) as UGM_Id,coalesce(Breadcrumb,'') as Breadcrumb,coalesce(Pathfile,'') as Pathfile " &
                    "From CTE_Menu ) as tbl1 " &
                    "order by UGM_SeqNo"

                Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)

                myCommandSelect.Parameters.AddWithValue("@Menu_Content", Menu_Content)
                myCommandSelect.Parameters.AddWithValue("@System_Id", System_Id)

                Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

                While myReader.Read
                    Dim namePage As String = ""
                    Dim pathfile As String = ""

                    namePage = myReader.Item("Breadcrumb")

                    If myReader.Item("Pathfile") <> "" Then
                        pathfile = VirtualPathUtility.ToAbsolute("~/" & myReader.Item("Pathfile") & "?p_Id=" & Parent_Id.ToString & "&m_Id=" & Menu_Content.ToString)
                        retval = retval + " " + "<li class='breadcrumb-item'><a href='" & pathfile & "'>" & namePage & "</a></li>"
                    Else
                        'pathfile = myReader.Item("Pathfile")
                        retval = retval + " " + "<li class='breadcrumb-item'>" & namePage & "</a></li>"
                    End If

                End While

                myReader.Close()

                myConnection.Close()

            End Using
        Catch ex As Exception

        End Try

        Return retval
    End Function

    Public Shared Function writeBlockBody(ByVal blockName As String, Optional ByVal checkPage As Boolean = False) As String

        Dim retval As String = ""
        Dim Block_Include As String = ""
        Dim Block_Exclude As String = ""
        Dim isShow As Boolean = False

        Dim pageFilename As String = System.IO.Path.GetFileName(HttpContext.Current.Request.ServerVariables("SCRIPT_NAME"))
        Dim pageRequestStr As String = System.IO.Path.GetFileName(HttpContext.Current.Request.ServerVariables("QUERY_STRING"))

        If pageRequestStr <> "" Then
            pageFilename = pageFilename + "?" + pageRequestStr
        End If

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Const SQLSelect As String = "SELECT * FROM [TBL_BLOCK] WHERE Block_Name = @blockName "

            Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)
            myCommandSelect.Parameters.AddWithValue("@blockName", blockName)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            'Dim Block_Id = myReader.Item("Block_Id")
            'Dim Block_Content = myReader.Item("Block_Content")

            While myReader.Read

                Dim Block_Id = myReader.Item("Block_Id")
                Dim Block_Content = myReader.Item("Block_Content")
                Dim Block_Title = myReader.Item("Block_Title")

                If Not IsDBNull(myReader.Item("Block_Content")) Then
                    retval = myReader.Item("Block_Content")
                End If

                If Not IsDBNull(myReader.Item("Block_Include")) Then
                    Block_Include = myReader.Item("Block_Include")
                End If

                If Not IsDBNull(myReader.Item("Block_Exclude")) Then
                    Block_Exclude = myReader.Item("Block_Exclude")
                End If

                '//start translate menu
                Dim Lang_code_menu As String = ""
                Lang_code_menu = "BLKM" + Block_Id.ToString



                '//end translate menu

            End While

            '//if true then do the check (include / exclude)
            If checkPage = True Then

                Dim i As Integer = 0
                '//will check the include page (if match then show to page)
                For Each pageInclude As String In Block_Include.Split(vbLf)
                    i = i + 1

                    If i > 1 Then
                        ' pageInclude = pageInclude.Substring(1)
                    End If

                    'MsgBox(pageFilename + "-" + pageInclude)
                    'isShow = True
                    If pageInclude = pageFilename Then
                        'MsgBox(pageFilename + "-" + pageInclude)
                        isShow = True
                    End If
                Next

                Dim j As Integer = 0
                '//will check the exclude page (if match then dont show to page)
                For Each pageExclude As String In Block_Exclude.Split(vbLf)
                    j = j + 1

                    If j > 1 Then
                        '  pageExclude = pageExclude.Substring(1)
                    End If

                    If pageExclude = pageFilename Then
                        isShow = False
                    End If
                Next

            Else

                isShow = True

            End If


            myReader.Close()

            myConnection.Close()

        End Using



        '// if isShow return false
        If isShow = False Then
            retval = ""
        End If

        Return retval
    End Function

    Public Shared Function sendNewsletter(ByVal newsletterId As Integer) As Boolean
        Dim retval As Boolean = True

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Const SQLSelect As String = "SELECT nl.Newsletter_Subject,nl.Newsletter_Message, " &
            "nl.Newsletter_Attachment, wc.Webcon_EmailServer " &
            "FROM [TBL_NEWSLETTER] nl " &
            "LEFT JOIN [TBL_WEBCONFIG] wc ON wc.Webcon_id = wc.Webcon_id and wc.Webcon_Enabled = 'Y' " &
            "WHERE nl.Newsletter_ID = @Newsletter_ID"

            Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Newsletter_ID", newsletterId)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            If myReader.Read Then

                Dim MailFrom = "info@demo.com.my" '//admin@tlp.com.my

                Dim MailTo = getNewsletterSubscriber()

                Dim title = myReader.Item("Newsletter_Subject")
                Dim emailBody = myReader.Item("Newsletter_Message")
                Dim attachmentEmail = myReader.Item("Newsletter_Attachment")

                Dim fullpath As String = ""
                If IsDBNull(attachmentEmail) Then
                Else
                    fullpath = Replace(HttpContext.Current.Server.MapPath(attachmentEmail), "/", "\")
                    fullpath = fullpath.Replace("\administration", "")
                End If

                Dim strArr() As String
                Dim count As Integer

                If MailTo <> "" Then


                    strArr = MailTo.Split(";")
                    For count = 0 To strArr.Length - 1

                        Dim fromAddress As New MailAddress(MailFrom, "Demo Website Newsletter")
                        Dim toAddress As New MailAddress(strArr(count), "")
                        Dim msg As New MailMessage(fromAddress, toAddress)

                        msg.Body = msg.Body & "" & emailBody
                        msg.Subject = "Newsletter DEMO : " + title
                        'msg.Attachments = attachmentEmail
                        msg.IsBodyHtml = True

                        If fullpath <> "" Then
                            msg.Attachments.Add(New Attachment(fullpath))
                        End If

                        Dim mailSender As New System.Net.Mail.SmtpClient()
                        mailSender.Host = myReader.Item("Webcon_EmailServer") '//"58.26.106.40"
                        mailSender.Port = 25
                        'MsgBox("test" & msg.Body.ToString)
                        Try

                            mailSender.Send(msg)


                            'lblMessage.Text = "Your feedback has been submitted."
                        Catch ex As Exception
                            'lblMessage.Text = ex.Message
                        End Try

                    Next

                End If


            End If

            myReader.Close()

            myConnection.Close()

        End Using


        Return retval

    End Function

    Public Shared Function getNewsletterSubscriber() As String

        Dim retval As String = ""

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Const SQLSelect As String = "SELECT * FROM [TBL_NEWSLETTER_SUBSCRIBER] WHERE Newsletter_isActive = 'true' "

            Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            While myReader.Read
                Dim Newsletter_email = myReader.Item("Newsletter_email")

                retval = retval + "" + Newsletter_email + ";"

            End While

            myReader.Close()

            myConnection.Close()

        End Using

        If retval <> "" Then
            retval = retval.Substring(0, retval.Length - 1)
        End If

        Return retval
    End Function


    Public Shared Function sendEmail(ByVal FromName As String, ByVal ToName As String, ByVal title As String, ByVal emailBody As String, ByVal othersInfo As String, ByVal othersInfo2 As String, Optional ByVal listEmail As String = "") As Boolean
        Dim retval As Boolean = True

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()



            Const SQLSelect As String = "SELECT * FROM [TBL_WEBCONFIG] WHERE Webcon_Enabled = 'Y'"

            Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            If myReader.Read Then

                Dim MailFrom = "info@demo.com.my"
                Dim MailTo = myReader.Item("Webcon_Email")

                If listEmail <> "" Then
                    MailTo = listEmail
                End If

                Dim strArr() As String
                Dim count As Integer

                strArr = MailTo.Split(";")
                For count = 0 To strArr.Length - 1

                    Dim fromAddress As New MailAddress(MailFrom, FromName)
                    Dim toAddress As New MailAddress(strArr(count), ToName)
                    Dim msg As New MailMessage(fromAddress, toAddress)

                    msg.Body = msg.Body & "" & emailBody
                    msg.Subject = title
                    msg.IsBodyHtml = True

                    Dim mailSender As New System.Net.Mail.SmtpClient()
                    mailSender.Host = myReader.Item("Webcon_EmailServer") '//now - "58.26.106.42"

                    Try
                        mailSender.Send(msg)
                        'lblMessage.Text = "Your feedback has been submitted."
                    Catch ex As Exception
                        'lblMessage.Text = ex.Message
                    End Try

                Next




            End If

            myReader.Close()

            myConnection.Close()

        End Using


        Return retval

    End Function

    Public Shared Function Encrypt(ByVal toEncrypt As String, ByVal key As String, ByVal useHashing As Boolean) As String
        Dim keyArray As Byte()
        Dim toEncryptArray As Byte() = UTF8Encoding.UTF8.GetBytes(toEncrypt)

        If useHashing = True Then
            Dim hashmd5 As New MD5CryptoServiceProvider()
            keyArray = hashmd5.ComputeHash(UTF8Encoding.UTF8.GetBytes(key))
        Else
            keyArray = UTF8Encoding.UTF8.GetBytes(key)
        End If

        Dim tdes As New TripleDESCryptoServiceProvider()
        tdes.Key = keyArray
        tdes.Mode = CipherMode.ECB
        tdes.Padding = PaddingMode.PKCS7

        Dim cTransform As ICryptoTransform = tdes.CreateEncryptor()
        Dim resultArray As Byte() = cTransform.TransformFinalBlock(toEncryptArray, 0, toEncryptArray.Length)

        Return (Convert.ToBase64String(resultArray, 0, resultArray.Length))
    End Function

    Public Shared Function Decrypt(ByVal toDecrypt As String, ByVal key As String, ByVal useHashing As Boolean) As String
        Dim keyArray As Byte()
        Dim toEncryptArray As Byte() = Convert.FromBase64String(toDecrypt)

        If useHashing = True Then
            Dim hashmd5 As New MD5CryptoServiceProvider()
            keyArray = hashmd5.ComputeHash(UTF8Encoding.UTF8.GetBytes(key))
        Else
            keyArray = UTF8Encoding.UTF8.GetBytes(key)
        End If

        Dim tdes As New TripleDESCryptoServiceProvider()
        tdes.Key = keyArray
        tdes.Mode = CipherMode.ECB
        tdes.Padding = PaddingMode.PKCS7

        Dim cTransform As ICryptoTransform = tdes.CreateDecryptor()
        Dim resultArray As Byte() = cTransform.TransformFinalBlock(toEncryptArray, 0, toEncryptArray.Length)

        Return UTF8Encoding.UTF8.GetString(resultArray)
    End Function

    Public Shared Function getWebCounter() As String

        Dim retval As String = ""
        Dim Webcon_Counter As Integer = 0

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Const SQLSelect As String = "SELECT * FROM [TBL_WEBCONFIG] WHERE Webcon_Enabled = 'Y'"

            Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            If myReader.Read Then

                Webcon_Counter = myReader.Item("Webcon_Counter")

            End If

            myReader.Close()

            myConnection.Close()

        End Using

        Dim TotalChar As Integer = Len(Webcon_Counter.ToString)
        Dim counterImage As String = ""

        Dim j As Integer, dg As Integer
        For j = 0 To (TotalChar - 1)
            ' Extract digit from value
            dg = Fix(Webcon_Counter / (10 ^ (TotalChar - j - 1))) - Fix(Webcon_Counter / (10 ^ (TotalChar - j))) * 10
            counterImage = counterImage & "<img src='../administration/images/counter/" & dg & ".gif'/>"
        Next j

        retval = String.Concat("<table cellspacing='3' cellpadding='3' aborder=1 width='100%'><tr><td colspan='2'><img src='../administration/images/counter/hit_Counter.png'> <div class='hitcounter'>", counterImage)
        retval = String.Concat(retval, "</div></td></tr>")
        retval = String.Concat(retval, "<tr><td width='40%'>Total Today</td><td width='60%'>: " + getWebCounterStatistic("daily") + "</td></tr>")
        retval = String.Concat(retval, "<tr><td>Total This Week</td><td>: " + getWebCounterStatistic("weekly") + "</td></tr>")
        retval = String.Concat(retval, "<tr><td>Total This Month</td><td>: " + getWebCounterStatistic("monthly") + "</td></tr>")
        retval = String.Concat(retval, "</table>")


        Return retval
    End Function


    Public Shared Function getWebCounterNumber() As String

        Dim retval As String = ""
        Dim Webcon_Counter As Integer = 0

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Const SQLSelect As String = "SELECT * FROM [TBL_WEBCONFIG] WHERE Webcon_Enabled = 'Y'"

            Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            If myReader.Read Then

                Webcon_Counter = myReader.Item("Webcon_Counter")

            End If

            myReader.Close()

            myConnection.Close()

        End Using

        Dim TotalChar As Integer = Len(Webcon_Counter.ToString)
        Dim counterImage As String = ""

        Dim j As Integer, dg As Integer
        For j = 0 To (TotalChar - 1)
            ' Extract digit from value
            dg = Fix(Webcon_Counter / (10 ^ (TotalChar - j - 1))) - Fix(Webcon_Counter / (10 ^ (TotalChar - j))) * 10
            counterImage = counterImage & "<img src='images/counter/" & dg & ".gif' />"
            'MsgBox(dg)
        Next j

        retval = String.Concat("<table cellspacing='3' cellpadding='3' aborder=1 width='100%'><tr><td width='10%'><img src='images/counter/hit_Counter.png'> </td><td width='90%' align='left'><div class='hitcounter'>", counterImage)
        retval = String.Concat(retval, "</div></td></tr>")
        retval = String.Concat(retval, "</table>")


        Return retval
    End Function

    Public Shared Function getWebCounterStatistic(ByVal statType As String) As String
        Dim retval As String = "0"
        Dim whereStr As String = ""

        If statType = "daily" Then
            whereStr = " WHERE SUBSTRING(CONVERT(varchar,Counter_DateTime),1,10) Between SUBSTRING(CONVERT(varchar,GETDATE()),1,10) AND SUBSTRING(CONVERT(varchar,GETDATE()),1,10) "
        ElseIf statType = "weekly" Then
            whereStr = " WHERE DATEPART(wk,Counter_DateTime) = DATEPART(wk,GETDATE()) "
        Else
            whereStr = " WHERE MONTH(Counter_DateTime) = MONTH(GETDATE()) "
        End If

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQLSelect As String = "SELECT COUNT(*) AS totalVisit FROM [TBL_COUNTER] "
            SQLSelect = String.Concat(SQLSelect, whereStr)

            Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            If myReader.Read Then

                retval = myReader.Item("totalVisit")

            End If

            myReader.Close()

            myConnection.Close()

        End Using


        retval = retval + " Visitors"
        Return retval
    End Function

    Public Shared Function webCounter() As Boolean

        Dim retval As Boolean = True


        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim Webcon_Counter As Integer = 0

            Const SQLSelect As String = "SELECT * FROM [TBL_WEBCONFIG] WHERE Webcon_Enabled = 'Y'"

            Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            If myReader.Read Then

                Webcon_Counter = myReader.Item("Webcon_Counter")

            End If

            myReader.Close()

            Const SQL As String = "UPDATE [TBL_WEBCONFIG] SET Webcon_Counter = @Webcon_Counter + 1 WHERE Webcon_Enabled = 'Y' "

            Dim myCommand As New SqlCommand(SQL, myConnection)
            myCommand.Parameters.AddWithValue("@Webcon_Counter", Webcon_Counter)

            If HttpContext.Current.Session.Item("sessionAT_IP") = "" Then
                Dim recordset As Integer = myCommand.ExecuteNonQuery()
                HttpContext.Current.Session.Item("sessionAT_IP") = "OK"

                If recordset Then

                    Dim browse As HttpBrowserCapabilities = HttpContext.Current.Request.Browser
                    Dim Counter_IP As String = HttpContext.Current.Request.UserHostAddress
                    Dim Counter_OS As String = browse.Platform
                    Dim Counter_Location As String = ""
                    Dim Counter_Browser As String = browse.Browser + " " + browse.Version
                    Dim Counter_Others As String = HttpContext.Current.Request.UserAgent

                    Const SQLCounter As String = "INSERT INTO [TBL_COUNTER] (Counter_IP,Counter_OS,Counter_DateTime,Counter_Location,Counter_Others,Counter_Browser) " &
                                                " VALUES (@Counter_IP,@Counter_OS,getdate(),@Counter_Location,@Counter_Others,@Counter_Browser)"

                    Dim myCommandCounter As New SqlCommand(SQLCounter, myConnection)
                    myCommandCounter.Parameters.AddWithValue("@Counter_IP", Counter_IP)
                    myCommandCounter.Parameters.AddWithValue("@Counter_OS", Counter_OS)
                    myCommandCounter.Parameters.AddWithValue("@Counter_Location", Counter_Location)
                    myCommandCounter.Parameters.AddWithValue("@Counter_Others", Counter_Others)
                    myCommandCounter.Parameters.AddWithValue("@Counter_Browser", Counter_Browser)

                    Dim recordsetCounter As Integer = myCommandCounter.ExecuteNonQuery()

                End If

            End If

            myConnection.Close()

        End Using

        Return retval
    End Function

    Public Shared Function auditTrail(ByVal paraModuleName As String, ByVal paraTitle As String, ByVal paraAction As String) As Boolean

        Dim retval As Boolean = True
        Dim AT_UserId As Integer = HttpContext.Current.Session.Item("sessionUsersId")
        Dim AT_UserName As String = HttpContext.Current.Session.Item("sessionUserName")
        'Dim AT_IP As String = ""

        Dim AT_IP As String = HttpContext.Current.Request.UserHostAddress

        'Dim host As IPHostEntry = Dns.GetHostByName(Dns.GetHostName)

        'If host.AddressList.Length > 0 Then
        '    AT_IP = host.AddressList(0).ToString
        'End If


        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Const SQL As String = "INSERT INTO [TBL_AUDITTRAIL] (AT_UserId,AT_UserName,AT_IP,AT_Action,AT_Module,AT_Title,AT_datetime) VALUES " &
                "(@AT_UserId,@AT_UserName,@AT_IP,@AT_Action,@AT_Module,@AT_Title,getdate())"

            Dim myCommand As New SqlCommand(SQL, myConnection)

            myCommand.Parameters.AddWithValue("@AT_UserId", AT_UserId)
            myCommand.Parameters.AddWithValue("@AT_UserName", AT_UserName)
            myCommand.Parameters.AddWithValue("@AT_IP", AT_IP)
            myCommand.Parameters.AddWithValue("@AT_Action", paraAction)
            myCommand.Parameters.AddWithValue("@AT_Module", paraModuleName)
            myCommand.Parameters.AddWithValue("@AT_Title", paraTitle)

            myConnection.Open()

            Dim recordset As Integer = myCommand.ExecuteNonQuery()

            '//start insert audit trail

            myConnection.Close()

        End Using

        Return retval
    End Function


    Public Shared Function writeFooter() As String

        Dim retval As String = ""

        '//start check if super admin
        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Const SQL As String = "SELECT * FROM [TBL_WEBCONFIG] WHERE Webcon_Enabled = 'Y' "

            Dim myCommand As New SqlCommand(SQL, myConnection)

            myConnection.Open()

            Dim myReader As SqlDataReader = myCommand.ExecuteReader

            If myReader.Read Then

                Dim Webcon_Footer = myReader.Item("Webcon_Footer")

                retval = String.Concat(retval, Webcon_Footer)

            End If

            myReader.Close()

            myConnection.Close()

        End Using

        Return retval
    End Function

    Public Shared Function writeMetaTag() As String

        Dim retval As String = ""

        '//start check if super admin
        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Const SQL As String = "SELECT * FROM [TBL_WEBCONFIG] WHERE Webcon_Enabled = 'Y' "

            Dim myCommand As New SqlCommand(SQL, myConnection)

            myConnection.Open()

            Dim myReader As SqlDataReader = myCommand.ExecuteReader

            If myReader.Read Then

                Dim Webcon_Metatag = myReader.Item("Webcon_Metatag")

                'retval = """" & String.Concat(retval, Webcon_Metatag) & """"
                retval = String.Concat(retval, Webcon_Metatag)

            End If

            myReader.Close()

            myConnection.Close()

        End Using

        Return retval
    End Function

    Public Shared Function writeSiteTitle() As String

        Dim retval As String = ""

        '//start check if super admin
        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Const SQL As String = "SELECT * FROM [TBL_WEBCONFIG] WHERE Webcon_Enabled = 'Y' "

            Dim myCommand As New SqlCommand(SQL, myConnection)

            myConnection.Open()

            Dim myReader As SqlDataReader = myCommand.ExecuteReader

            If myReader.Read Then

                Dim Webcon_Sitetitle = myReader.Item("Webcon_Sitetitle")

                retval = String.Concat(retval, Webcon_Sitetitle)

            End If

            myReader.Close()

            myConnection.Close()

        End Using

        Return retval
    End Function

    Public Shared Function WriteLatestNews() As String
        Dim retval As String
        Dim glblClass As New GlobalClass()
        retval = ""

        'retval = String.Concat(retval, "<div class='blockTitle'>Latest News</div><br/>")

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Const SQL As String = "SELECT Content_Id, Content_Title, Content_Body,Content_PublishedDate AS Content_PublishedDateOri, CONVERT (VARCHAR(11), Content_PublishedDate, 106) AS Content_PublishedDate FROM TBL_CONTENT WHERE Content_IsNews = 1 AND Content_IsPublish = 1 ORDER BY Content_PublishedDateOri DESC "

            'finalSQL = String.Concat(SQL, checkSql)

            Dim myCommand As New SqlCommand(SQL, myConnection)
            'myCommand.Parameters.AddWithValue("@paraBlockID", paraBlockID)

            myConnection.Open()

            Dim myReader As SqlDataReader = myCommand.ExecuteReader


            Do While myReader.Read()

                Dim Content_Id = myReader.Item("Content_Id")
                Dim Content_Body = myReader.Item("Content_Body")
                Dim Content_Title = myReader.Item("Content_Title")
                Dim Content_PublishedDate = myReader.Item("Content_PublishedDate")

                retval = String.Concat(retval, "<br/><div class='infoWhite'><b><a href='news.aspx?lid=1&cid=" + Content_Id.ToString + "'>" + Content_Title + "</a><br/>" + Content_PublishedDate + "</b></div>")
                '//retval = String.Concat(retval, "<br/>" + Content_Body + "</div>")

            Loop

            myReader.Close()

            myConnection.Close()

        End Using


        Return retval
    End Function

    Public Shared Function WriteBlock(ByVal paraBlockID As String) As String
        Dim retval As String
        Dim glblClass As New GlobalClass()
        retval = ""

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Const SQL As String = "SELECT * FROM TBL_WEBCONFIG WHERE Webcon_Enabled = 'Y' "

            'finalSQL = String.Concat(SQL, checkSql)

            Dim myCommand As New SqlCommand(SQL, myConnection)
            'myCommand.Parameters.AddWithValue("@paraBlockID", paraBlockID)

            myConnection.Open()

            Dim myReader As SqlDataReader = myCommand.ExecuteReader


            Do While myReader.Read()

                Dim fldname_title As String
                Dim fldname_content As String

                fldname_title = "Webcon_" + paraBlockID + "_Title"
                fldname_content = "Webcon_" + paraBlockID + "_Content"

                Dim Content_Title = myReader.Item(fldname_title)
                Dim Content_Body = myReader.Item(fldname_content)

                retval = Content_Body
            Loop

            myReader.Close()

            myConnection.Close()

        End Using


        Return retval
    End Function

    Public Shared Function WriteLeftMenu(ByVal paraMenuId As Integer) As String
        Dim retval As String
        Dim finalSQL As String
        Dim checkSql As String
        Dim glblClass As New GlobalClass()
        Dim sectorID As Integer = HttpContext.Current.Session.Item("sessionSectorID")
        retval = ""
        checkSql = ""

        If paraMenuId = 0 Then
            retval = String.Concat(retval, "<ul id='leftMenu'>")
        Else
            retval = String.Concat(retval, "<ul id='leftMenu'>")
        End If


        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            checkSql = "WHERE Menu_ParentId = @Menu_Id"

            Const SQL As String = "SELECT mn.Menu_Name,mn.Menu_ContentId,mn.Menu_ParentId,mn.Menu_Id,mn.Menu_Filename,ct.Content_Name " &
                " FROM TBL_MENU mn " &
                " LEFT JOIN TBL_CONTENT ct ON ct.Content_Id = mn.Menu_ContentId "

            finalSQL = String.Concat(SQL, checkSql)
            finalSQL = String.Concat(finalSQL, " ORDER BY Menu_SeqNo ")

            Dim myCommand As New SqlCommand(finalSQL, myConnection)
            myCommand.Parameters.AddWithValue("@Menu_Id", paraMenuId)

            myConnection.Open()

            Dim myReader As SqlDataReader = myCommand.ExecuteReader


            Do While myReader.Read()
                Dim Menu_Name = myReader.Item("Menu_Name")
                Dim Menu_ContentId = myReader.Item("Menu_ContentId")
                Dim Menu_ParentId = myReader.Item("Menu_ParentId")
                Dim Menu_Id = myReader.Item("Menu_Id")
                Dim Menu_Filename = myReader.Item("Menu_Filename")
                Dim filepath As String
                Dim Content_Name = myReader.Item("Content_Name")


                If InStr(Menu_Filename.ToString, "?") > 0 Then

                    If InStr(Menu_Filename.ToString, "p_Id") > 0 Then
                        filepath = Menu_Filename.ToString + "&sID=" & sectorID
                    Else
                        filepath = Menu_Filename.ToString + "&sID=" & sectorID & "&p_Id=" + Menu_ParentId.ToString
                    End If

                Else
                    filepath = Menu_Filename.ToString + "?sID=" & sectorID & "&p_Id=" + Menu_ParentId.ToString
                End If
                'Else

                'End If


                'filepath = Menu_Filename.ToString + "?p_Id=" + Menu_ParentId.ToString

                '//if filename not specified
                If IsDBNull(Menu_Filename) Then
                    filepath = "pages.aspx?sID=" & sectorID & "&Content_Name=" + Content_Name.ToString
                End If

                'retval = String.Concat(retval, "<li ><a href='" + filepath + "'>" + Menu_Name + " <img src='images/icon_bullet2.png' border='0'></a>")
                retval = String.Concat(retval, "<li ><a href='" + filepath + "'>" + Menu_Name + " </a>")

                '//if have parent menu
                'If Menu_ParentId > 0 Then
                'Dim retval2 As String = glblClass.WriteLeftMenu(Menu_Id)
                'retval = String.Concat(retval, retval2)
                'End If

                retval = String.Concat(retval, "</li>")
            Loop

            myReader.Close()

            myConnection.Close()

        End Using

        retval = String.Concat(retval, "</ul>")
        retval = retval.Replace("<ul></ul>", "")

        Return retval
    End Function

    'Public Shared Function WriteMenu(ByVal paraMenuId As Integer) As String
    '    Dim retval As String
    '    Dim finalSQL As String
    '    Dim checkSql As String
    '    Dim glblClass As New GlobalClass()
    '    ' Dim sectorID As Integer = HttpContext.Current.Session.Item("sessionSectorID")
    '    retval = ""
    '    checkSql = ""

    '    If paraMenuId = 0 Then
    '        retval = String.Concat(retval, "<ul class='nav navbar-nav navbar-right'>")
    '    Else
    '        retval = String.Concat(retval, "<ul>")
    '    End If

    '    Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("KMB_ECOTRAIL_DBConnectionString").ConnectionString)

    '        checkSql = "WHERE Menu_ParentId = @Menu_Id"

    '        Const SQL As String = "SELECT mn.Menu_Level,mn.Menu_Level,mn.Menu_Name,mn.Menu_ContentId,mn.Menu_ParentId,mn.Menu_Id,mn.Menu_Filename,ct.Content_Name " &
    '            " FROM TBL_MENU mn " &
    '            " LEFT JOIN TBL_CONTENT ct ON ct.Content_Id = mn.Menu_ContentId "

    '        finalSQL = String.Concat(SQL, checkSql)
    '        finalSQL = String.Concat(finalSQL, " ORDER BY Menu_SeqNo ")

    '        Dim myCommand As New SqlCommand(finalSQL, myConnection)
    '        myCommand.Parameters.AddWithValue("@Menu_Id", paraMenuId)
    '        'myCommand.Parameters.AddWithValue("@Menu_Cat", paraCatId)

    '        myConnection.Open()

    '        Dim myReader As SqlDataReader = myCommand.ExecuteReader
    '        Dim j As Integer = 0

    '        Do While myReader.Read()
    '            j = j + 1
    '            Dim Menu_Name = myReader.Item("Menu_Name")
    '            Dim Menu_ContentId = myReader.Item("Menu_ContentId")
    '            Dim Menu_ParentId = myReader.Item("Menu_ParentId")
    '            Dim Menu_Id = myReader.Item("Menu_Id")
    '            Dim Menu_Filename = myReader.Item("Menu_Filename")
    '            Dim Content_Name = myReader.Item("Content_Name")
    '            Dim Menu_Level = myReader.Item("Menu_Level")
    '            'Dim Menu_Cat = myReader.Item("Menu_Cat")

    '            Dim filepath As String

    '            'If InStr(Menu_Filename.ToString, "p_Id") > 0 Then
    '            '    filepath = Menu_Filename.ToString
    '            'Else
    '            '    filepath = Menu_Filename.ToString + "&p_Id=" + Menu_ParentId.ToString
    '            'End If

    '            'If InStr(Menu_Filename.ToString, "?") > 0 Then

    '            '    If InStr(Menu_Filename.ToString, "p_Id") > 0 Then
    '            '        filepath = Menu_Filename.ToString + "&sID=" & sectorID
    '            '    Else
    '            '        filepath = Menu_Filename.ToString + "&sID=" & sectorID & "&p_Id=" + Menu_ParentId.ToString
    '            '    End If

    '            'Else
    '            '    filepath = Menu_Filename.ToString + "?sID=" & sectorID & "&p_Id=" + Menu_ParentId.ToString
    '            'End If


    '            '//if filename not specified
    '            If IsDBNull(Menu_Filename) Then
    '                'filepath = "pages.aspx?sID=" & sectorID & "&Content_Name=" + Content_Name.ToString
    '            End If


    '            'MsgBox(Menu_ContentId.ToString)
    '            If Menu_ContentId.ToString = "0" And Menu_Filename.ToString = "" Then '// ori : Menu_ContentId.ToString = "0" And Menu_ParentId.ToString = 0 And Menu_Filename.ToString <> "Default.aspx"
    '                If Menu_Level = 1 Then
    '                    retval = String.Concat(retval, "<li><a class='page-scroll'> " + Menu_Name + "</a></li>")
    '                Else
    '                    retval = String.Concat(retval, "<li><a class='dropdown-menu'>" + Menu_Name + "</a></li>")
    '                End If
    '            Else

    '                If Menu_Level = 1 Then
    '                    If j = 1 Then
    '                        retval = String.Concat(retval, "<li><a class='page-scroll' href='" + filepath + "'><img src='images/icon_home.png' alt='Home' border='0' width='20'/></a>")
    '                    Else
    '                        retval = String.Concat(retval, "<li><a class='page-scroll' href='" + filepath + "'> " + Menu_Name + "</a>")
    '                    End If
    '                Else
    '                    retval = String.Concat(retval, "<li><a class='dropdown-menu' href='" + filepath + "'> " + Menu_Name + "</a>")
    '                End If '&#x2192; <--arrow symbol

    '            End If

    '            'retval = String.Concat(retval, "<li><table><tr><td><a href='" + filepath + "'>" + Menu_Name + "</a></td><td width='10px'></td></tr></table>")
    '            '//if have parent menu
    '            'If Menu_ParentId > 0 Then
    '            Dim retval2 As String = GlobalClass.WriteMenu(Menu_Id)
    '            ', Menu_Cat
    '            retval = String.Concat(retval, retval2)
    '            'End If

    '            retval = String.Concat(retval, "</li>")
    '        Loop

    '        myReader.Close()

    '        myConnection.Close()

    '    End Using

    '    retval = String.Concat(retval, "</ul>")

    '    retval = retval.Replace("<ul></ul>", "")

    '    Return retval
    'End Function

    Public Shared Function WriteMenu(ByVal paraMenuId As Integer) As String
        Dim retval As String
        Dim checkSql As String
        Dim glblClass As New GlobalClass()
        retval = ""
        checkSql = ""

        If paraMenuId = 0 Then
            retval = String.Concat(retval, "<ul class='nav navbar-nav'>")
        Else
            retval = String.Concat(retval, "<ul class='dropdown-menu'>")

        End If

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Dim myCommand As New SqlCommand("Menu_Proc", myConnection)
            myCommand.Parameters.AddWithValue("@Menu_Id", paraMenuId)
            myCommand.CommandType = CommandType.StoredProcedure

            myConnection.Open()

            Dim myReader As SqlDataReader = myCommand.ExecuteReader
            Dim j As Integer = 0

            Do While myReader.Read()
                j = j + 1

                Dim Menu_Name = myReader.Item("Menu_Name")
                Dim Menu_ContentId = myReader.Item("Menu_ContentId")
                Dim Menu_ParentId = myReader.Item("Menu_ParentId")
                Dim Menu_Id = myReader.Item("Menu_Id")
                Dim Menu_Filename = myReader.Item("Menu_Filename")
                Dim Content_Name = myReader.Item("Content_Name")
                Dim Menu_Level = myReader.Item("Menu_Level")

                Dim filepath As String

                If InStr(Menu_Filename.ToString, "?") > 0 Then

                    If InStr(Menu_Filename.ToString, "p_Id") > 0 Then
                        filepath = Menu_Filename.ToString
                    Else
                        filepath = Menu_Filename.ToString + "&p_Id=" + Menu_ParentId.ToString
                    End If

                Else
                    filepath = Menu_Filename.ToString + "?p_Id=" + Menu_ParentId.ToString
                End If


                '//if filename not specified
                If IsDBNull(Menu_Filename) Then
                    filepath = "pages.aspx?Content_Name=" + Content_Name.ToString
                End If

                '//start translate menu
                Dim Lang_code_menu As String = ""
                Lang_code_menu = "MU" + Menu_Id.ToString



                '//end translate menu

                If Menu_ContentId.ToString = "0" And Menu_Filename.ToString = "" Then '// ori : Menu_ContentId.ToString = "0" And Menu_ParentId.ToString = 0 And Menu_Filename.ToString <> "Default.aspx"
                    If Menu_Level = 1 Then
                        retval = String.Concat(retval, "<li class='dropdown'><a class='dropdown-toggle' data-toggle='dropdown' role='button' aria-haspopup='true' aria-expanded='false'>" + Menu_Name + "<span class='caret'></span></a>")

                    ElseIf Menu_Level = 2 Then

                        retval = String.Concat(retval, "<ul class='dropdown-menu'><li><a>" + Menu_Name + "</a></ul>")

                    Else
                        retval = String.Concat(retval, "<li class='dropdown'><a data-toggle='dropdown' class='dropdown-toggle'>&nbsp;&nbsp; " + Menu_Name + "</a>")

                    End If
                Else

                    If Menu_Level = 1 Then
                        If j = 1 Then
                            retval = String.Concat(retval, "<li style='color: #ED1C24'><a href='" + filepath + "'>" + Menu_Name + "</i></a>")

                        Else
                            retval = String.Concat(retval, "<li><a href='" + filepath + "'> " + Menu_Name + "</a>")

                        End If

                    ElseIf Menu_Level = 2 Then

                        retval = String.Concat(retval, "<li role='separator' class='divider'></li><li><a href='" + filepath + "'>" + Menu_Name + "</a></li>")

                    ElseIf Menu_Level = 3 Then
                        retval = Replace(retval, "<ul class='dropdown-menu'>", "<ul class=''>")

                        retval = String.Concat(retval, "<li><a href='" + filepath + "'>" + Menu_Name + "</a></li>")

                    Else
                        retval = String.Concat(retval, "<li><a href='" + filepath + "'>&#x2192;" + Menu_Name + "</a>")

                    End If

                End If


                'retval = String.Concat(retval, "<li><table><tr><td><a href='" + filepath + "'>" + Menu_Name + "</a></td><td width='10px'></td></tr></table>")
                '//if have parent menu
                'If Menu_ParentId > 0 Then
                Dim retval2 As String = glblClass.WriteMenu(Menu_Id)
                retval = String.Concat(retval, retval2)
                'End If

                retval = String.Concat(retval, "</li>")
            Loop

            myReader.Close()

            myConnection.Close()

        End Using

        retval = String.Concat(retval, "</ul>")

        retval = retval.Replace("<ul></ul>", "")

        Return retval
    End Function


    'Public Shared Function WriteAdminMenu(ByVal paraMenuId As Integer) As String
    '    Dim retval As String
    '    Dim finalSQL As String
    '    Dim checkSql As String
    '    Dim glblClass As New GlobalClass()
    '    retval = ""
    '    checkSql = ""

    '    If paraMenuId = 0 Then
    '        retval = String.Concat(retval, "<ul class='sidebar-menu'>") '"<ul id='nav'>")
    '        'retval = String.Concat(retval, "<ul class='nav navbar-nav navbar-left'>") '"<ul id='nav'>")
    '        'ElseIf paraMenuId > 0 Then
    '        '    retval = String.Concat(retval, "<ul class='treeview'>") '"<ul>")
    '        'retval = String.Concat(retval, "<ul class='dropdown-menu'>") '"<ul>")
    '    ElseIf paraMenuId > 0 Then
    '        retval = String.Concat(retval, "<ul class='treeview-menu'>") '"<ul>")
    '    End If

    '    Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

    '        'checkSql = "WHERE Menu_ParentId = @Menu_Id AND Menu_IsPublish = 1"

    '        Const SQL As String = "SELECT mn.UGM_Level,mn.UGM_Name,mn.UGM_ParentId,mn.UGM_Id,mn.UGM_Filename FROM TBL_USER_GROUPMODULE mn WHERE UGM_ParentId = @UGM_Id AND UGM_IsPublish = 1"



    '        'Const SQL As String = "SELECT mn.Menu_Level,mn.Menu_Name,mn.Menu_ContentId,mn.Menu_ParentId,mn.Menu_Id,mn.Menu_Filename,ct.Content_Name FROM TBL_MENU mn LEFT JOIN TBL_CONTENT ct ON ct.Content_Id = mn.Menu_ContentId "

    '        finalSQL = String.Concat(SQL)
    '        finalSQL = String.Concat(finalSQL, " ORDER BY UGM_SeqNo ")

    '        Dim myCommand As New SqlCommand(finalSQL, myConnection)
    '        myCommand.Parameters.AddWithValue("@UGM_Id", paraMenuId)
    '        'myCommand.CommandType = CommandType.StoredProcedure

    '        myConnection.Open()

    '        Dim myReader As SqlDataReader = myCommand.ExecuteReader
    '        Dim j As Integer = 0

    '        Do While myReader.Read()
    '            j = j + 1

    '            Dim UGM_Name = myReader.Item("UGM_Name")
    '            'Dim Menu_ContentId = myReader.Item("Menu_ContentId")
    '            Dim UGM_ParentId = myReader.Item("UGM_ParentId")
    '            Dim UGM_Id = myReader.Item("UGM_Id")
    '            Dim UGM_Filename = myReader.Item("UGM_Filename")
    '            'Dim Content_Name = myReader.Item("Content_Name")
    '            Dim UGM_Level = myReader.Item("UGM_Level")

    '            Dim filepath As String

    '            'If InStr(Menu_Filename.ToString, "p_Id") > 0 Then
    '            '    filepath = Menu_Filename.ToString
    '            'Else
    '            '    filepath = Menu_Filename.ToString + "&p_Id=" + Menu_ParentId.ToString
    '            'End If

    '            If InStr(UGM_Filename.ToString, "?") > 0 Then

    '                If InStr(UGM_Filename.ToString, "p_Id") > 0 Then
    '                    filepath = UGM_Filename.ToString
    '                Else
    '                    filepath = UGM_Filename.ToString + "&p_Id=" + UGM_ParentId.ToString
    '                End If

    '            Else
    '                filepath = UGM_Filename.ToString + "?p_Id=" + UGM_ParentId.ToString
    '            End If


    '            '//if filename not specified
    '            'If IsDBNull(Menu_Filename) Then
    '            '    filepath = "pages.aspx?Content_Name=" + Content_Name.ToString
    '            'End If


    '            'MsgBox(Menu_ContentId.ToString)
    '            If UGM_Filename.ToString = "" Then '// ori : Menu_ContentId.ToString = "0" And Menu_ParentId.ToString = 0 And Menu_Filename.ToString <> "Default.aspx"
    '                If UGM_Level = 1 Then
    '                    'retval = String.Concat(retval, "<li><table cellspacing='0' cellpadding='0'><tr valign='bottom'><td class='page-scroll'><a>&nbsp;&nbsp; " + Menu_Name + "</a></td><td class='imgMenuBorder'>&nbsp;</td></tr></table>") 'ori :  <td class='MenuContentTD'
    '                    retval = String.Concat(retval, "<li><a href='" + filepath + "'><i class='fa fa-angle-left pull-right'></i>&nbsp;&nbsp; " + UGM_Name + "</a>") 'ori :  <td class='MenuContentTD'

    '                Else
    '                    'retval = String.Concat(retval, "<li><table cellspacing='0' cellpadding='0'><tr valign='bottom'><td class=''><a>" + Menu_Name + "</a></td><td class='imgMenuBorder'>&nbsp;</td></tr></table>")
    '                    retval = String.Concat(retval, "<li><a href='" + filepath + "'><i class='fa fa-angle-left pull-right'></i>&nbsp;&nbsp; " + UGM_Name + "</a>") 'ori :  <td class='MenuContentTD'
    '                End If
    '            Else

    '                If UGM_Level = 1 Then
    '                    If j = 1 Then
    '                        'retval = String.Concat(retval, "<li><table cellspacing='0' cellpadding='0'><tr valign='bottom'><td class='MenuContentTDFirst quicklinks2'><a href='" + filepath + "'><img src='images/icon_home.png' alt='Home' border='0' width='20'/></a></td><td class='imgMenuBorder'>&nbsp;</td></tr></table>")
    '                        retval = String.Concat(retval, "<li><a href='" + filepath + "'><i class='fa fa-2x fa-home'></i></a>")

    '                    Else
    '                        'retval = String.Concat(retval, "<li><table cellspacing='0' cellpadding='0'><tr valign='bottom'><td class='MenuContentTD'><a href='" + filepath + "'>&nbsp;&nbsp; " + Menu_Name + "</a></td><td class='imgMenuBorder'>&nbsp;</td></tr></table>")
    '                        retval = String.Concat(retval, "<li><a href='" + filepath + "'><i class='fa fa-circle-o'></i>&nbsp;&nbsp; " + UGM_Name + "</a>")

    '                    End If
    '                Else
    '                    'retval = String.Concat(retval, "<li><table cellspacing='0' cellpadding='0'><tr valign='bottom'><td class='MenuContentTD'><a href='" + filepath + "'>&#x2192;&nbsp;&nbsp;" + Menu_Name + "</a></td><td class='imgMenuBorder'>&nbsp;</td></tr></table>")

    '                    retval = String.Concat(retval, "<li><a href='" + filepath + "'><i class='fa fa-circle-o'></i>&nbsp;&nbsp;" + UGM_Name + "</a>")

    '                End If

    '            End If


    '            'retval = String.Concat(retval, "<li><table><tr><td><a href='" + filepath + "'>" + Menu_Name + "</a></td><td width='10px'></td></tr></table>")
    '            '//if have parent menu
    '            'If Menu_ParentId > 0 Then
    '            Dim retval2 As String = glblClass.WriteAdminMenu(UGM_Id)
    '            retval = String.Concat(retval, retval2)
    '            'End If

    '            retval = String.Concat(retval, "</li>")
    '        Loop

    '        myReader.Close()

    '        myConnection.Close()

    '    End Using

    '    retval = String.Concat(retval, "</ul>")

    '    retval = retval.Replace("<ul></ul>", "")

    '    Return retval
    'End Function


    Public Shared Function WriteAdminMenu2(ByVal paraMenuId As Integer, ByVal userrole As Integer, ByVal isAdmin As Integer) As String

        isAdmin = HttpContext.Current.Session.Item("sessionisadmin")
        'MsgBox(isAdmin)
        userrole = HttpContext.Current.Session.Item("sessionuserrole")
        Dim sessionUserId As Integer = HttpContext.Current.Session.Item("sessionUsersId")
        Dim sessionSystemId As Integer = HttpContext.Current.Session.Item("sessionSystemId")

        Dim retval As String
        Dim glblClass As New GlobalClass()
        retval = ""

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
            myConnection.Open()
            'Dim sql As String = "SELECT mn.UGM_Level,mn.UGM_Name,mn.UGM_ParentId,mn.UGM_Id,mn.UGM_Filename,mn.UGM_ContentId FROM TBL_USER_GROUPMODULE mn WHERE UGM_ParentId = @UGM_Id AND UGM_IsPublish = 1 ORDER BY UGM_SeqNo"
            'Dim sql As String = "SELECT TBL_USER_GROUPROLE.UGR_Id, TBL_USER_GROUPROLE.UGR_UGN_Id, TBL_USER_GROUPROLE.UGR_UGM_Id, TBL_USER_GROUPROLE.UGR_Read, TBL_USER_GROUPMODULE.UGM_Id, TBL_USER_GROUPMODULE.UGM_Name, TBL_USER_GROUPMODULE.UGM_Filename, TBL_USER_GROUPMODULE.UGM_ParentId, TBL_USER_GROUPMODULE.UGM_SeqNo, TBL_USER_GROUPMODULE.UGM_Level, TBL_USER_GROUPMODULE.UGM_IsPublish, TBL_USER_GROUPMODULE.UGM_CreatedBy, TBL_USER_GROUPMODULE.UGM_CreatedDate, TBL_USER_GROUPMODULE.UGM_ContentId FROM TBL_USER_GROUPROLE INNER JOIN TBL_USER_GROUPMODULE ON TBL_USER_GROUPROLE.UGR_UGM_Id = TBL_USER_GROUPMODULE.UGM_Id WHERE (TBL_USER_GROUPROLE.UGR_Read = 1) AND (TBL_USER_GROUPROLE.UGR_UGN_Id =@UGR_UGN_Id ) AND (UGM_ParentId = @UGM_Id) AND (TBL_USER_GROUPMODULE.UGM_IsPublish = 1) ORDER BY UGM_SeqNo"
            'Dim sql As String = "SELECT  TBL_USER_GROUPMODULE.UGM_Id,TBL_USER_GROUPROLE.UGR_UGN_Id, TBL_USER_GROUPROLE.UGR_UGM_Id, TBL_USER_GROUPMODULE.UGM_Name, TBL_USER_GROUPMODULE.UGM_Filename, TBL_USER_GROUPMODULE.UGM_ParentId, TBL_USER_GROUPMODULE.UGM_SeqNo, TBL_USER_GROUPMODULE.UGM_Level, TBL_USER_GROUPMODULE.UGM_ContentId, TBL_USER_GROUPNAME.UGN_IsAdmin FROM TBL_USER_GROUPROLE  INNER JOIN TBL_USER_GROUPMODULE ON TBL_USER_GROUPROLE.UGR_UGM_Id = TBL_USER_GROUPMODULE.UGM_Id inner join TBL_USER_GROUPNAME on TBL_USER_GROUPROLE.UGR_UGN_Id  = TBL_USER_GROUPNAME.UGN_Id  WHERE (TBL_USER_GROUPROLE.UGR_Read = 1) AND (TBL_USER_GROUPROLE.UGR_UGN_Id =@UGR_UGN_Id ) AND (TBL_USER_GROUPMODULE.UGM_IsPublish = 1) and TBL_USER_GROUPNAME.UGN_IsAdmin = @UGN_IsAdmin  AND (UGM_ParentId = @UGM_Id) ORDER BY UGM_SeqNo"


            'Dim sql As String = "IF((SELECT COUNT(*)FROM TBL_USER_GROUPNAME INNER JOIN TBL_USER_GROUPLIST ON TBL_USER_GROUPLIST.UGL_UGN_Id = TBL_USER_GROUPNAME.UGN_Id INNER JOIN TBL_USERS ON TBL_USERS.Users_Id = TBL_USER_GROUPLIST.UGL_Users_Id WHERE TBL_USERS.Users_Id = 94 AND TBL_USER_GROUPNAME.UGN_IsAdmin = @UGN_IsAdmin) > 0) SELECT  TBL_USER_GROUPMODULE.UGM_Id,TBL_USER_GROUPROLE.UGR_UGN_Id, TBL_USER_GROUPROLE.UGR_UGM_Id, TBL_USER_GROUPMODULE.UGM_Name, TBL_USER_GROUPMODULE.UGM_Filename, TBL_USER_GROUPMODULE.UGM_ParentId, TBL_USER_GROUPMODULE.UGM_SeqNo, TBL_USER_GROUPMODULE.UGM_Level, TBL_USER_GROUPMODULE.UGM_ContentId, TBL_USER_GROUPNAME.UGN_IsAdmin  FROM TBL_USER_GROUPROLE INNER JOIN TBL_USER_GROUPMODULE ON TBL_USER_GROUPROLE.UGR_UGM_Id = TBL_USER_GROUPMODULE.UGM_Id  inner join TBL_USER_GROUPNAME on TBL_USER_GROUPROLE.UGR_UGN_Id  = TBL_USER_GROUPNAME.UGN_Id WHERE (TBL_USER_GROUPROLE.UGR_Read = 1) AND (TBL_USER_GROUPROLE.UGR_UGN_Id =@UGR_UGN_Id ) AND (TBL_USER_GROUPMODULE.UGM_IsPublish = 1) and (TBL_USER_GROUPNAME.UGN_IsAdmin = @UGN_IsAdmin) AND (UGM_ParentId = @UGM_Id) ORDER BY UGM_SeqNo ELSE SELECT  TBL_USER_GROUPMODULE.UGM_Id,TBL_USER_GROUPROLE.UGR_UGN_Id, TBL_USER_GROUPROLE.UGR_UGM_Id, TBL_USER_GROUPMODULE.UGM_Name, TBL_USER_GROUPMODULE.UGM_Filename, TBL_USER_GROUPMODULE.UGM_ParentId, TBL_USER_GROUPMODULE.UGM_SeqNo, TBL_USER_GROUPMODULE.UGM_Level, TBL_USER_GROUPMODULE.UGM_ContentId, TBL_USER_GROUPNAME.UGN_IsAdmin   FROM TBL_USER_GROUPROLE INNER JOIN TBL_USER_GROUPMODULE ON TBL_USER_GROUPROLE.UGR_UGM_Id = TBL_USER_GROUPMODULE.UGM_Id inner join TBL_USER_GROUPNAME on TBL_USER_GROUPROLE.UGR_UGN_Id  = TBL_USER_GROUPNAME.UGN_Id WHERE (TBL_USER_GROUPROLE.UGR_UGN_Id =@UGR_UGN_Id ) AND (TBL_USER_GROUPMODULE.UGM_IsPublish = 1) and (TBL_USER_GROUPNAME.UGN_IsAdmin = @UGN_IsAdmin) AND (UGM_ParentId = @UGM_Id) ORDER BY UGM_SeqNo"

            Dim myCommand As New SqlCommand("generateAdminMenu_PROC2", myConnection)
            myCommand.Parameters.AddWithValue("@UGM_Id", paraMenuId)
            myCommand.Parameters.AddWithValue("@UGR_UGN_Id", userrole)
            myCommand.Parameters.AddWithValue("@UGN_IsAdmin", isAdmin)
            myCommand.Parameters.AddWithValue("@userid", sessionUserId)
            myCommand.Parameters.AddWithValue("@systemID", sessionSystemId)

            myCommand.CommandType = CommandType.StoredProcedure

            'If paraMenuId = 0 Then
            '    retval = String.Concat(retval, "<li class='nav-item'>")

            'ElseIf paraMenuId <> 30 And paraMenuId <> 37 And paraMenuId <> 40 And paraMenuId <> 45 And paraMenuId <> 48 And paraMenuId <> 1046 And paraMenuId <> 1049 And paraMenuId <> 1055 And paraMenuId <> 1060 And paraMenuId <> 1065 Then
            '    retval = String.Concat(retval, "<li class='nav-item'>")


            'ElseIf paraMenuId <> 0 Then

            '    retval = String.Concat(retval, "<li class='nav-item has-treeview'>")
            '    'If ss Then

            '    'End If

            'End If
            ''MsgBox(paraMenuId)



            Dim myReader As SqlDataReader = myCommand.ExecuteReader
            Dim j As Integer = 0




            Do While myReader.Read()

                Dim UGM_Name = myReader.Item("UGM_Name")
                Dim UGM_ContentId = myReader.Item("UGM_ContentId")
                Dim UGM_ParentId = myReader.Item("UGM_ParentId")
                Dim UGM_Id = myReader.Item("UGM_Id")
                Dim UGM_Filename = myReader.Item("UGM_Filename")
                Dim UGR_UGN_Id = myReader.Item("UGR_UGN_Id")
                Dim UGM_Level = myReader.Item("UGM_Level")
                Dim UGN_IsAdmin = myReader.Item("UGN_IsAdmin")
                Dim UGM_Menu_Icon = myReader.Item("UGM_Menu_Icon")
                Dim filepath As String

                Dim pageFilename As String
                pageFilename = System.IO.Path.GetFileName(HttpContext.Current.Request.ServerVariables("SCRIPT_NAME"))

                'MsgBox(UGM_Level)
                If paraMenuId = 0 Then
                    If UGM_Id = HttpContext.Current.Request.QueryString("p_Id") Then
                        retval = String.Concat(retval, "<li class='nav-item has-treeview menu-open'>")
                    Else
                        retval = String.Concat(retval, "<li class='nav-item has-treeview'>")
                    End If

                    'ElseIf paraMenuId <> 30 And paraMenuId <> 37 And paraMenuId <> 40 And paraMenuId <> 45 And paraMenuId <> 48 And paraMenuId <> 1046 And paraMenuId <> 1049 And paraMenuId <> 1055 And paraMenuId <> 1060 And paraMenuId <> 1065 Then
                    '    retval = String.Concat(retval, "<li class='nav-item'>")

                Else
                    retval = String.Concat(retval, "<li class='nav-item'>")
                    'If (UGM_Filename.Contains(pageFilename)) Then
                    '    retval = String.Concat(retval, "<li class='nav-item active'>")
                    'Else
                    '    retval = String.Concat(retval, "<li class='nav-item'>")
                    'End If

                End If
                'MsgBox(paraMenuId)

                j = j + 1



                If InStr(UGM_Filename.ToString, "p_Id") > 0 Then
                    filepath = UGM_Filename.ToString

                Else
                    filepath = UGM_Filename.ToString + "&p_Id=" + UGM_ParentId.ToString
                End If

                If InStr(UGM_Filename.ToString, "?") > 0 Then

                    If InStr(UGM_Filename.ToString, "p_Id") > 0 Then
                        filepath = UGM_Filename.ToString
                    Else
                        filepath = UGM_Filename.ToString + "&p_Id=" + UGM_ParentId.ToString
                    End If

                Else
                    filepath = UGM_Filename.ToString + "?p_Id=" + UGM_ParentId.ToString
                End If

                '//append Menu ID
                If InStr(filepath, "?") > 0 Then
                    filepath = filepath + "&m_Id=" + UGM_Id.ToString
                Else
                    filepath = UGM_Filename.ToString + "?m_Id=" + UGM_Id.ToString
                End If


                If UGM_ContentId.ToString = "0" And UGM_Filename.ToString = "" Then '// ori : Menu_ContentId.ToString = "0" And Menu_ParentId.ToString = 0 And Menu_Filename.ToString <> "Default.aspx"
                    'If paraMenuId = UGM_Id Then
                    'retval = String.Concat(retval, "<ul>")

                    If UGM_Level = 1 Then
                        'retval = String.Concat(retval, "<li class='nav-item'><a href='" + filepath + "'><i class='" + "fas fa-edit" + "'></i> &nbsp;&nbsp;&nbsp; " + UGM_Name + "</a>") 'ori :  <td class='MenuContentTD'
                        'retval = String.Concat(retval, "<a href = '" + filepath + "' Class='nav-link'><i class='" + UGM_Menu_Icon + "'></i><p>" + UGM_Name + "<i Class='fas fa-angle-left right'></i></p></a><ul class='nav nav-treeview'>")
                        If UGM_Id = HttpContext.Current.Request.QueryString("p_Id") Then
                            retval = String.Concat(retval, "<a href = '" + filepath + "' Class='nav-link active' style='background-color: #28a745;'><i class='nav-icon fas " + UGM_Menu_Icon + "'></i><p>" + UGM_Name + "<i Class='fas fa-angle-left right'></i></p></a><ul class='nav nav-treeview'>")
                        Else
                            retval = String.Concat(retval, "<a href = '" + filepath + "' Class='nav-link'><i class='nav-icon fas " + UGM_Menu_Icon + "'></i><p>" + UGM_Name + "<i Class='fas fa-angle-left right'></i></p></a><ul class='nav nav-treeview'>")
                        End If


                    Else
                        'retval = String.Concat(retval, "<li><a href='" + filepath + "'><i class='fa fa-angle-left pull-right'></i><i class='" + UGM_Menu_Icon + "'></i> &nbsp;&nbsp;&nbsp; " + UGM_Name + "</a>") 'ori :  <td class='MenuContentTD'
                        'retval = String.Concat(retval, "<li class='nav-item'><a href='" + filepath + "'><i class='fa fa-angle-left pull-right'></i><i class='" + UGM_Menu_Icon + "'></i> &nbsp;&nbsp;&nbsp; " + UGM_Name + "</a>") 'ori :  <td class='MenuContentTD'
                        'retval = String.Concat(retval, "<a href = '" + filepath + "' class='nav-link active'><i class='" + UGM_Menu_Icon + "'></i><p>" + UGM_Name + "</p></a>")
                        If (UGM_Filename.ToString.Contains(pageFilename)) Then
                            retval = String.Concat(retval, "<a href = '" + filepath + "' class='nav-link active' style='background-color: #28a745;'><i class='nav-icon fas " + UGM_Menu_Icon + "'></i><p>" + UGM_Name + "</p></a>")
                        Else
                            retval = String.Concat(retval, "<a href = '" + filepath + "' class='nav-link'><i class='nav-icon fas " + UGM_Menu_Icon + "'></i><p>" + UGM_Name + "</p></a>")
                        End If
                    End If
                Else
                    If UGM_Level = 1 Then
                        If (UGM_Filename.ToString.Contains(pageFilename)) Then
                            retval = String.Concat(retval, "<li class='nav-item'><a href='" + filepath + "' class='nav-link active' style='background-color: rgba(255,255,255,.9);color: #343a40;'><i class='far fa-dot-circle nav-icon'></i><p>" + UGM_Name + "</p></a>")
                        Else
                            retval = String.Concat(retval, "<li class='nav-item'><a href='" + filepath + "' class='nav-link'><i class='far fa-dot-circle nav-icon'></i><p>" + UGM_Name + "</p></a>")
                        End If
                    Else
                        If (UGM_Filename.ToString.Contains(pageFilename)) Then
                            retval = String.Concat(retval, "<li class='nav-item'><a href='" + filepath + "' class='nav-link active' style='background-color: rgba(255,255,255,.9);color: #343a40;'>&nbsp;&nbsp;&nbsp;<i class='far fa-circle nav-icon'></i><p>" + UGM_Name + "</p></a>")
                        Else
                            retval = String.Concat(retval, "<li class='nav-item'><a href='" + filepath + "' class='nav-link'>&nbsp;&nbsp;&nbsp;<i class='far fa-circle nav-icon'></i><p>" + UGM_Name + "</p></a>")
                        End If
                    End If
                    'retval = String.Concat(retval, "<li class='nav-item'><a href='" + filepath + "' class='nav-link active'><i class='far fa-circle nav-icon'></i><p>" + UGM_Name + "</p></a>")
                End If

                '//if have parent menu
                'If Menu_ParentId > 0 Then
                Dim retval2 As String = GlobalClass.WriteAdminMenu(UGM_Id, UGR_UGN_Id, UGN_IsAdmin)
                retval = String.Concat(retval, retval2)
                'End If

                retval = String.Concat(retval, "</li>")

                If UGM_Menu_Icon.ToString = "last" Then
                    retval = String.Concat(retval, "</ul>")
                End If

                'retval = retval.Replace("<ul></ul>", "")
                retval = String.Concat(retval, "</li>")
            Loop

            myReader.Close()

            myConnection.Close()
            myConnection.Dispose()
        End Using



        ''retval = retval.Replace("<ul></ul>", "")
        'retval = String.Concat(retval, "</li>")
        Return retval





    End Function

    Public Shared Function WriteAdminMenuOri(ByVal paraMenuId As Integer, ByVal userrole As Integer, ByVal isAdmin As Integer) As String

        isAdmin = HttpContext.Current.Session.Item("sessionisadmin")
        'MsgBox(isAdmin)
        userrole = HttpContext.Current.Session.Item("sessionuserrole")
        Dim sessionUserId As Integer = HttpContext.Current.Session.Item("sessionUsersId")


        Dim retval As String
        Dim glblClass As New GlobalClass()
        retval = ""

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
            myConnection.Open()
            'Dim sql As String = "SELECT mn.UGM_Level,mn.UGM_Name,mn.UGM_ParentId,mn.UGM_Id,mn.UGM_Filename,mn.UGM_ContentId FROM TBL_USER_GROUPMODULE mn WHERE UGM_ParentId = @UGM_Id AND UGM_IsPublish = 1 ORDER BY UGM_SeqNo"
            'Dim sql As String = "SELECT TBL_USER_GROUPROLE.UGR_Id, TBL_USER_GROUPROLE.UGR_UGN_Id, TBL_USER_GROUPROLE.UGR_UGM_Id, TBL_USER_GROUPROLE.UGR_Read, TBL_USER_GROUPMODULE.UGM_Id, TBL_USER_GROUPMODULE.UGM_Name, TBL_USER_GROUPMODULE.UGM_Filename, TBL_USER_GROUPMODULE.UGM_ParentId, TBL_USER_GROUPMODULE.UGM_SeqNo, TBL_USER_GROUPMODULE.UGM_Level, TBL_USER_GROUPMODULE.UGM_IsPublish, TBL_USER_GROUPMODULE.UGM_CreatedBy, TBL_USER_GROUPMODULE.UGM_CreatedDate, TBL_USER_GROUPMODULE.UGM_ContentId FROM TBL_USER_GROUPROLE INNER JOIN TBL_USER_GROUPMODULE ON TBL_USER_GROUPROLE.UGR_UGM_Id = TBL_USER_GROUPMODULE.UGM_Id WHERE (TBL_USER_GROUPROLE.UGR_Read = 1) AND (TBL_USER_GROUPROLE.UGR_UGN_Id =@UGR_UGN_Id ) AND (UGM_ParentId = @UGM_Id) AND (TBL_USER_GROUPMODULE.UGM_IsPublish = 1) ORDER BY UGM_SeqNo"
            'Dim sql As String = "SELECT  TBL_USER_GROUPMODULE.UGM_Id,TBL_USER_GROUPROLE.UGR_UGN_Id, TBL_USER_GROUPROLE.UGR_UGM_Id, TBL_USER_GROUPMODULE.UGM_Name, TBL_USER_GROUPMODULE.UGM_Filename, TBL_USER_GROUPMODULE.UGM_ParentId, TBL_USER_GROUPMODULE.UGM_SeqNo, TBL_USER_GROUPMODULE.UGM_Level, TBL_USER_GROUPMODULE.UGM_ContentId, TBL_USER_GROUPNAME.UGN_IsAdmin FROM TBL_USER_GROUPROLE  INNER JOIN TBL_USER_GROUPMODULE ON TBL_USER_GROUPROLE.UGR_UGM_Id = TBL_USER_GROUPMODULE.UGM_Id inner join TBL_USER_GROUPNAME on TBL_USER_GROUPROLE.UGR_UGN_Id  = TBL_USER_GROUPNAME.UGN_Id  WHERE (TBL_USER_GROUPROLE.UGR_Read = 1) AND (TBL_USER_GROUPROLE.UGR_UGN_Id =@UGR_UGN_Id ) AND (TBL_USER_GROUPMODULE.UGM_IsPublish = 1) and TBL_USER_GROUPNAME.UGN_IsAdmin = @UGN_IsAdmin  AND (UGM_ParentId = @UGM_Id) ORDER BY UGM_SeqNo"


            'Dim sql As String = "IF((SELECT COUNT(*)FROM TBL_USER_GROUPNAME INNER JOIN TBL_USER_GROUPLIST ON TBL_USER_GROUPLIST.UGL_UGN_Id = TBL_USER_GROUPNAME.UGN_Id INNER JOIN TBL_USERS ON TBL_USERS.Users_Id = TBL_USER_GROUPLIST.UGL_Users_Id WHERE TBL_USERS.Users_Id = 94 AND TBL_USER_GROUPNAME.UGN_IsAdmin = @UGN_IsAdmin) > 0) SELECT  TBL_USER_GROUPMODULE.UGM_Id,TBL_USER_GROUPROLE.UGR_UGN_Id, TBL_USER_GROUPROLE.UGR_UGM_Id, TBL_USER_GROUPMODULE.UGM_Name, TBL_USER_GROUPMODULE.UGM_Filename, TBL_USER_GROUPMODULE.UGM_ParentId, TBL_USER_GROUPMODULE.UGM_SeqNo, TBL_USER_GROUPMODULE.UGM_Level, TBL_USER_GROUPMODULE.UGM_ContentId, TBL_USER_GROUPNAME.UGN_IsAdmin  FROM TBL_USER_GROUPROLE INNER JOIN TBL_USER_GROUPMODULE ON TBL_USER_GROUPROLE.UGR_UGM_Id = TBL_USER_GROUPMODULE.UGM_Id  inner join TBL_USER_GROUPNAME on TBL_USER_GROUPROLE.UGR_UGN_Id  = TBL_USER_GROUPNAME.UGN_Id WHERE (TBL_USER_GROUPROLE.UGR_Read = 1) AND (TBL_USER_GROUPROLE.UGR_UGN_Id =@UGR_UGN_Id ) AND (TBL_USER_GROUPMODULE.UGM_IsPublish = 1) and (TBL_USER_GROUPNAME.UGN_IsAdmin = @UGN_IsAdmin) AND (UGM_ParentId = @UGM_Id) ORDER BY UGM_SeqNo ELSE SELECT  TBL_USER_GROUPMODULE.UGM_Id,TBL_USER_GROUPROLE.UGR_UGN_Id, TBL_USER_GROUPROLE.UGR_UGM_Id, TBL_USER_GROUPMODULE.UGM_Name, TBL_USER_GROUPMODULE.UGM_Filename, TBL_USER_GROUPMODULE.UGM_ParentId, TBL_USER_GROUPMODULE.UGM_SeqNo, TBL_USER_GROUPMODULE.UGM_Level, TBL_USER_GROUPMODULE.UGM_ContentId, TBL_USER_GROUPNAME.UGN_IsAdmin   FROM TBL_USER_GROUPROLE INNER JOIN TBL_USER_GROUPMODULE ON TBL_USER_GROUPROLE.UGR_UGM_Id = TBL_USER_GROUPMODULE.UGM_Id inner join TBL_USER_GROUPNAME on TBL_USER_GROUPROLE.UGR_UGN_Id  = TBL_USER_GROUPNAME.UGN_Id WHERE (TBL_USER_GROUPROLE.UGR_UGN_Id =@UGR_UGN_Id ) AND (TBL_USER_GROUPMODULE.UGM_IsPublish = 1) and (TBL_USER_GROUPNAME.UGN_IsAdmin = @UGN_IsAdmin) AND (UGM_ParentId = @UGM_Id) ORDER BY UGM_SeqNo"

            Dim myCommand As New SqlCommand("generateAdminMenu_PROC", myConnection)
            myCommand.Parameters.AddWithValue("@UGM_Id", paraMenuId)
            myCommand.Parameters.AddWithValue("@UGR_UGN_Id", userrole)
            myCommand.Parameters.AddWithValue("@UGN_IsAdmin", isAdmin)
            myCommand.Parameters.AddWithValue("@userid", sessionUserId)
            myCommand.CommandType = CommandType.StoredProcedure

            If paraMenuId = 0 Then
                retval = String.Concat(retval, "<ul class='sidebar-menu'>")

            ElseIf paraMenuId <> 30 And paraMenuId <> 37 And paraMenuId <> 40 And paraMenuId <> 45 And paraMenuId <> 48 And paraMenuId <> 1046 And paraMenuId <> 1049 And paraMenuId <> 1055 And paraMenuId <> 1060 And paraMenuId <> 1065 Then
                retval = String.Concat(retval, "<ul>")


            ElseIf paraMenuId <> 0 Then

                retval = String.Concat(retval, "<ul class='treeview-menu'>")
                'If ss Then

                'End If

            End If
            'MsgBox(paraMenuId)



            Dim myReader As SqlDataReader = myCommand.ExecuteReader
            Dim j As Integer = 0




            Do While myReader.Read()

                j = j + 1




                Dim UGM_Name = myReader.Item("UGM_Name")
                Dim UGM_ContentId = myReader.Item("UGM_ContentId")
                Dim UGM_ParentId = myReader.Item("UGM_ParentId")
                Dim UGM_Id = myReader.Item("UGM_Id")
                Dim UGM_Filename = myReader.Item("UGM_Filename")
                Dim UGR_UGN_Id = myReader.Item("UGR_UGN_Id")
                Dim UGM_Level = myReader.Item("UGM_Level")
                Dim UGN_IsAdmin = myReader.Item("UGN_IsAdmin")
                Dim UGM_Menu_Icon = myReader.Item("UGM_Menu_Icon")
                Dim filepath As String

                'MsgBox(UGM_Level)



                If InStr(UGM_Filename.ToString, "p_Id") > 0 Then
                    filepath = UGM_Filename.ToString

                Else
                    filepath = UGM_Filename.ToString + "&p_Id=" + UGM_ParentId.ToString
                End If

                If InStr(UGM_Filename.ToString, "?") > 0 Then

                    If InStr(UGM_Filename.ToString, "p_Id") > 0 Then
                        filepath = UGM_Filename.ToString
                    Else
                        filepath = UGM_Filename.ToString + "&p_Id=" + UGM_ParentId.ToString
                    End If

                Else
                    filepath = UGM_Filename.ToString + "?p_Id=" + UGM_ParentId.ToString
                End If




                If UGM_ContentId.ToString = "0" And UGM_Filename.ToString = "" Then '// ori : Menu_ContentId.ToString = "0" And Menu_ParentId.ToString = 0 And Menu_Filename.ToString <> "Default.aspx"
                    'If paraMenuId = UGM_Id Then
                    'retval = String.Concat(retval, "<ul>")

                    If UGM_Level = 1 Then
                        retval = String.Concat(retval, "<li class='treeview'><a href='" + filepath + "' class='nav-link'><i class='fa fa-angle-left pull-right'></i><i class='" + UGM_Menu_Icon + "'></i> &nbsp;&nbsp;&nbsp; " + UGM_Name + "</a>") 'ori :  <td class='MenuContentTD'



                    Else
                        'retval = String.Concat(retval, "<li><a href='" + filepath + "'><i class='fa fa-angle-left pull-right'></i><i class='" + UGM_Menu_Icon + "'></i> &nbsp;&nbsp;&nbsp; " + UGM_Name + "</a>") 'ori :  <td class='MenuContentTD'
                        retval = String.Concat(retval, "<li class='treeview'><a href='" + filepath + "' class='nav-link'><i class='fa fa-angle-left pull-right'></i><i class='" + UGM_Menu_Icon + "'></i> &nbsp;&nbsp;&nbsp; " + UGM_Name + "</a>") 'ori :  <td class='MenuContentTD'
                    End If
                Else

                    If UGM_Level = 1 Then
                        If j = 1 Then

                            retval = String.Concat(retval, "<li><a href='" + filepath + "' class='nav-link'><i class='fa fa-2x fa-home'></i></a>")


                        Else
                            retval = String.Concat(retval, "<li><a href='" + filepath + "' class='nav-link'><i class='fa fa-circle-o'></i>&nbsp;&nbsp; " + UGM_Name + "</a>")

                        End If


                    Else

                        retval = String.Concat(retval, "<li><a href='" + filepath + "' class='nav-link'><i class='fa fa-circle-o'></i>&nbsp;&nbsp;" + UGM_Name + "</a>")
                        'MsgBox(UGM_Id)
                    End If
                    'End If
                End If





                '//if have parent menu
                'If Menu_ParentId > 0 Then
                Dim retval2 As String = glblClass.WriteAdminMenu(UGM_Id, UGR_UGN_Id, UGN_IsAdmin)
                retval = String.Concat(retval, retval2)
                'End If

                retval = String.Concat(retval, "</li>")
            Loop

            myReader.Close()

            myConnection.Close()
            myConnection.Dispose()
        End Using



        'retval = retval.Replace("<ul></ul>", "")
        retval = String.Concat(retval, "</ul>")
        Return retval





    End Function

    'Public Shared Function WriteAdminMenu2(ByVal paraMenuId As Integer) As String

    '    Dim retval As String
    '    Dim parentId As String = 0
    '    Dim glblClass As New GlobalClass()
    '    retval = ""


    '    Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)


    '        If paraMenuId = 0 Then
    '                        retval = String.Concat(retval, "<ul class='sidebar-menu'>")

    '        ElseIf paraMenuId <> 30 And paraMenuId <> 37 And paraMenuId <> 40 Then
    '                        retval = String.Concat(retval, "<ul>")


    '        Else
    '                        retval = String.Concat(retval, "<ul class='treeview-menu'>")


    '        End If



    '        Dim sql As String = "SELECT mn.UGM_Level,mn.UGM_Name,mn.UGM_ParentId,mn.UGM_Id,mn.UGM_Filename,mn.UGM_ContentId FROM TBL_USER_GROUPMODULE mn WHERE UGM_ParentId = @UGM_Id AND UGM_IsPublish = 1 ORDER BY UGM_SeqNo"

    '        Dim myCommand As New SqlCommand(sql, myConnection)
    '        myCommand.Parameters.AddWithValue("@UGM_Id", paraMenuId)


    '        Dim myReader As SqlDataReader = myCommand.ExecuteReader
    '            Dim j As Integer = 0

    '            Do While myReader.Read()
    '                j = j + 1

    '                Dim UGM_Name = myReader.Item("UGM_Name")
    '                Dim UGM_ContentId = myReader.Item("UGM_ContentId")
    '                Dim UGM_ParentId = myReader.Item("UGM_ParentId")
    '                Dim UGM_Id = myReader.Item("UGM_Id")
    '                Dim UGM_Filename = myReader.Item("UGM_Filename")

    '                Dim UGM_Level = myReader.Item("UGM_Level")

    '                Dim filepath As String

    '                If InStr(UGM_Filename.ToString, "p_Id") > 0 Then
    '                    filepath = UGM_Filename.ToString
    '                Else
    '                    filepath = UGM_Filename.ToString + "&p_Id=" + UGM_ParentId.ToString
    '                End If

    '                If InStr(UGM_Filename.ToString, "?") > 0 Then

    '                    If InStr(UGM_Filename.ToString, "p_Id") > 0 Then
    '                        filepath = UGM_Filename.ToString
    '                    Else
    '                        filepath = UGM_Filename.ToString + "&p_Id=" + UGM_ParentId.ToString
    '                    End If

    '                Else
    '                    filepath = UGM_Filename.ToString + "?p_Id=" + UGM_ParentId.ToString
    '                End If




    '                'MsgBox(Menu_ContentId.ToString)
    '                If UGM_ContentId.ToString = "0" And UGM_Filename.ToString = "" Then '// ori : Menu_ContentId.ToString = "0" And Menu_ParentId.ToString = 0 And Menu_Filename.ToString <> "Default.aspx"
    '                    If UGM_Level = 1 Then
    '                        'retval = String.Concat(retval, "<li><table cellspacing='0' cellpadding='0'><tr valign='bottom'><td class='page-scroll'><a>&nbsp;&nbsp; " + Menu_Name + "</a></td><td class='imgMenuBorder'>&nbsp;</td></tr></table>") 'ori :  <td class='MenuContentTD'
    '                        retval = String.Concat(retval, "<li class='treeview'><a href='" + filepath + "'><i class='fa fa-angle-left pull-right'></i>&nbsp;&nbsp; " + UGM_Name + "</a>") 'ori :  <td class='MenuContentTD'

    '                    Else
    '                        'retval = String.Concat(retval, "<li><table cellspacing='0' cellpadding='0'><tr valign='bottom'><td class=''><a>" + Menu_Name + "</a></td><td class='imgMenuBorder'>&nbsp;</td></tr></table>")
    '                        retval = String.Concat(retval, "<li><a href='" + filepath + "'><i class='fa fa-angle-left pull-right'></i>&nbsp;&nbsp; " + UGM_Name + "</a>") 'ori :  <td class='MenuContentTD'

    '                    End If
    '                Else

    '                    If UGM_Level = 1 Then
    '                        If j = 1 Then
    '                            'retval = String.Concat(retval, "<li><table cellspacing='0' cellpadding='0'><tr valign='bottom'><td class='MenuContentTDFirst quicklinks2'><a href='" + filepath + "'><img src='images/icon_home.png' alt='Home' border='0' width='20'/></a></td><td class='imgMenuBorder'>&nbsp;</td></tr></table>")
    '                            'retval = String.Concat(retval, "<li><a href='" + filepath + "'><i class='fa fa-2x fa-home'></i></a>")
    '                            retval = String.Concat(retval, "<li><a href='" + filepath + "'><i class='fa fa-2x fa-home'></i></a>")
    '                        Else
    '                            'retval = String.Concat(retval, "<li><table cellspacing='0' cellpadding='0'><tr valign='bottom'><td class='MenuContentTD'><a href='" + filepath + "'>&nbsp;&nbsp; " + Menu_Name + "</a></td><td class='imgMenuBorder'>&nbsp;</td></tr></table>")
    '                            retval = String.Concat(retval, "<li class='treeview'><a href='" + filepath + "'><i class='fa fa-circle-o'></i>&nbsp;&nbsp; " + UGM_Name + "</a>")

    '                        End If
    '                    Else
    '                        'retval = String.Concat(retval, "<li><table cellspacing='0' cellpadding='0'><tr valign='bottom'><td class='MenuContentTD'><a href='" + filepath + "'>&#x2192;&nbsp;&nbsp;" + Menu_Name + "</a></td><td class='imgMenuBorder'>&nbsp;</td></tr></table>")

    '                        retval = String.Concat(retval, "<li><a href='" + filepath + "'><i class='fa fa-circle-o'></i>&nbsp;&nbsp;" + UGM_Name + "</a>")

    '                    End If

    '                End If





    '                'retval = String.Concat(retval, "<li><table><tr><td><a href='" + filepath + "'>" + Menu_Name + "</a></td><td width='10px'></td></tr></table>")
    '                '//if have parent menu
    '                'If Menu_ParentId > 0 Then
    '                Dim retval2 As String = glblClass.WriteAdminMenu(UGM_Id)
    '                retval = String.Concat(retval, retval2)
    '                'End If

    '                retval = String.Concat(retval, "</li>")
    '            Loop

    '            myReader.Close()

    '            myConnection.Close()
    '        End Using


    '    retval = String.Concat(retval, "</ul>")

    '    'retval = retval.Replace("<ul></ul>", "")

    '    Return retval




    'End Function

    Public Shared Function CheckPagePermission(ByVal typeCheck As String, Optional ByVal pageName As String = "") As Boolean

        'Dim sessionUserId As Integer = Session.Item("sessionUserId")
        Dim sessionUserId As Integer = HttpContext.Current.Session.Item("sessionUsersId")
        Dim retval As Boolean = False
        Dim checkSql As String
        Dim finalSQL As String
        Dim pageFilename As String

        If pageName <> "" Then
            pageFilename = pageName
        Else
            pageFilename = System.IO.Path.GetFileName(HttpContext.Current.Request.ServerVariables("SCRIPT_NAME"))
        End If

        '//dummy for test
        'sessionUserId = 27
        'pageFilename = "feedbackadmin.aspx"

        checkSql = ""
        If typeCheck = "Read" Then
            checkSql = "AND UGR_Read = 1 "
        ElseIf typeCheck = "Write" Then
            checkSql = "AND UGR_Write = 1 "
        ElseIf typeCheck = "Approval" Then
            checkSql = "AND UGR_Approval = 1 "
        End If

        '//start check if super admin
        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Const SQL As String = "SELECT UGN.* " &
            "FROM [TBL_USER_GROUPLIST] UGL " &
            "INNER JOIN [TBL_USER_GROUPNAME] UGN ON UGL.UGL_UGN_Id = UGN.UGN_Id " &
            "WHERE UGL.UGL_Users_Id = @User_Id " &
            "AND UGN.UGN_IsAdmin = 1 "

            Dim myCommandEdit As New SqlCommand(SQL, myConnection)
            myCommandEdit.Parameters.AddWithValue("@User_Id", sessionUserId)
            'MsgBox(sessionUserId)
            myConnection.Open()

            Dim myReader As SqlDataReader = myCommandEdit.ExecuteReader

            If myReader.Read Then

                retval = True
                'Response.Write("Granted")
                'Response.End()

            End If

            myReader.Close()

            myConnection.Close()

        End Using

        '//if not super admin start check user by filename
        If retval = False Then

            Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

                Const SQL As String = "SELECT UGR.* " &
                "FROM [TBL_USER_GROUPLIST] UGL " &
                "INNER JOIN [TBL_USER_GROUPROLE] UGR ON UGR.UGR_UGN_Id = UGL.UGL_UGN_Id " &
                "INNER JOIN [TBL_USER_GROUPMODULE] UGM ON UGR.UGR_UGM_Id = UGM.UGM_Id " &
                "WHERE UGL.UGL_Users_Id = @User_Id " &
                "AND UGM.UGM_Filename LIKE '%' + @pageFilename + '%' "

                finalSQL = String.Concat(SQL, checkSql)

                Dim myCommandEdit As New SqlCommand(finalSQL, myConnection)
                myCommandEdit.Parameters.AddWithValue("@User_Id", sessionUserId)
                myCommandEdit.Parameters.AddWithValue("@pageFilename", pageFilename)
                myCommandEdit.Parameters.AddWithValue("@checkSql", checkSql)


                myConnection.Open()

                Dim myReader As SqlDataReader = myCommandEdit.ExecuteReader

                If myReader.Read Then

                    retval = True
                    'Response.Write("Granted")
                    'Response.End()

                End If

                myReader.Close()

                myConnection.Close()

            End Using

        End If

        'Response.Write("Denied")
        'Response.End()

        '//exclude page to check permission
        If pageFilename = "deniedpage.aspx" Or pageFilename = "deniedpage" Or pageFilename = "Default.aspx" Or pageFilename = "default.aspx" Or pageFilename = "Default" Or pageFilename = "Contact.aspx" Or pageFilename = "contact.aspx" Or pageFilename = "Contact" Then
            retval = True
        End If

        Return retval
    End Function

    Public Shared Function CheckPageWrite(ByVal typeCheck As String, ByVal objPage As Array, ByVal objPageControl As Array, ByVal objPageControlDeny As Array) As Boolean

        'Dim sessionUserId As Integer = Session.Item("sessionUserId")
        Dim sessionUserId As Integer = HttpContext.Current.Session.Item("sessionUsersId")
        Dim retval As Boolean = False
        Dim checkSql As String
        Dim finalSQL As String
        Dim pageFilename As String
        pageFilename = System.IO.Path.GetFileName(HttpContext.Current.Request.ServerVariables("SCRIPT_NAME"))

        checkSql = ""
        If typeCheck = "Read" Then
            checkSql = "AND UGR_Read = 1 "
        ElseIf typeCheck = "Write" Then
            checkSql = "AND UGR_Write = 1 "
        ElseIf typeCheck = "Approval" Then
            checkSql = "AND UGR_Approval = 1 "
        End If

        '//start check if super admin
        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Const SQL As String = "SELECT UGN.* " &
            "FROM [TBL_USER_GROUPLIST] UGL " &
            "INNER JOIN [TBL_USER_GROUPNAME] UGN ON UGL.UGL_UGN_Id = UGN.UGN_Id " &
            "WHERE UGL.UGL_Users_Id = @User_Id " &
            "AND UGN.UGN_IsAdmin = 1 "

            Dim myCommandEdit As New SqlCommand(SQL, myConnection)
            myCommandEdit.Parameters.AddWithValue("@User_Id", sessionUserId)

            myConnection.Open()

            Dim myReader As SqlDataReader = myCommandEdit.ExecuteReader

            If myReader.Read Then
                retval = True
            End If

            myReader.Close()

            myConnection.Close()

        End Using

        '//if not super admin start check user by filename
        If retval = False Then

            Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

                Const SQL As String = "SELECT UGR.* " &
                "FROM [TBL_USER_GROUPLIST] UGL " &
                "INNER JOIN [TBL_USER_GROUPROLE] UGR ON UGR.UGR_UGN_Id = UGL.UGL_UGN_Id " &
                "INNER JOIN [TBL_USER_GROUPMODULE] UGM ON UGR.UGR_UGM_Id = UGM.UGM_Id " &
                "WHERE UGL.UGL_Users_Id = @User_Id " &
                "AND UGM.UGM_Filename LIKE '%/' + @pageFilename + '%' "



                finalSQL = String.Concat(SQL, checkSql)

                Dim myCommandEdit As New SqlCommand(finalSQL, myConnection)
                myCommandEdit.Parameters.AddWithValue("@User_Id", sessionUserId)
                myCommandEdit.Parameters.AddWithValue("@pageFilename", pageFilename)
                myCommandEdit.Parameters.AddWithValue("@checkSql", checkSql)

                myConnection.Open()

                Dim myReader As SqlDataReader = myCommandEdit.ExecuteReader

                If myReader.Read Then

                    retval = True


                End If

                myReader.Close()

                myConnection.Close()

            End Using

        End If

        '//exclude page to check write page
        If pageFilename = "deniedpage.aspx" Or pageFilename = "deniedpage" Or pageFilename = "Default.aspx" Or pageFilename = "default.aspx" Or pageFilename = "Default" Or pageFilename = "Contact.aspx" Or pageFilename = "contact.aspx" Or pageFilename = "Contact" Then
            retval = True
        End If

        'retval = False 'uncomment this after Verified

        If retval = False Then
            '// formview setting
            Try
                For Each objPageValue In objPage
                    disabledControl(objPageValue)
                Next
            Catch ex As Exception

            End Try

            '// allow selected control
            Try
                For Each objPageControlValue In objPageControl
                    objPageControlValue.Visible = True
                    objPageControlValue.Enabled = True
                Next

            Catch ex As Exception

            End Try

            '// deny selected control
            Try

                For Each objPageControlDenyValue In objPageControlDeny
                    objPageControlDenyValue.Visible = False

                Next

            Catch ex As Exception

            End Try

        End If

        Return retval
    End Function

    Public Shared Function disabledControl(ByVal objPage As Control) As Boolean

        For Each c As Control In objPage.Controls


            If TypeOf c Is TextBox Then

                DirectCast(c, TextBox).Enabled = False

            ElseIf TypeOf c Is RadioButton Then

                DirectCast(c, RadioButton).Enabled = False

            ElseIf TypeOf c Is CheckBox Then

                DirectCast(c, CheckBox).Enabled = False

            ElseIf TypeOf c Is CheckBoxList Then

                DirectCast(c, CheckBoxList).Enabled = False

            ElseIf TypeOf c Is DropDownList Then

                DirectCast(c, DropDownList).Enabled = False

            ElseIf TypeOf c Is FileUpload Then

                DirectCast(c, FileUpload).Enabled = False

            ElseIf TypeOf c Is LinkButton Then

                DirectCast(c, LinkButton).Enabled = False
                DirectCast(c, LinkButton).Visible = False

            ElseIf TypeOf c Is Button Then

                DirectCast(c, Button).Enabled = False
                DirectCast(c, Button).Visible = False

                'ElseIf TypeOf c Is AjaxControlToolkit.HTMLEditor.Editor Then

                '    DirectCast(c, AjaxControlToolkit.HTMLEditor.Editor).ena = False

            End If

            If c.Controls.Count > 0 Then
                disabledControl(c)
            End If


        Next


        Return True

    End Function

    Private Shared Sub WriteMenu()
        Throw New NotImplementedException
    End Sub

    '+++++++++ FILTER ++++++++++
    Private Shared lstDataType As New List(Of String)({"varchar", "nvarchar", "char", "nchar(10)", "text", "bit", "int", "bigint", "decimal", "decimal(18, 2)"})
    Public Shared Sub GenerateFilter(ByVal gv As GridView, ByVal ds As SqlDataSource, ByRef pnlFilter As HtmlGenericControl)
        Dim sqlConn As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
        Dim initSelect As String = ds.SelectCommand.Substring(0, ds.SelectCommand.IndexOf("1=1") + 3)
        Dim sqlCmd As New SqlCommand(initSelect, sqlConn)
        sqlConn.Open()
        Dim sqlReader As SqlDataReader = sqlCmd.ExecuteReader()

        For i As Integer = 0 To gv.Columns.Count - 1
            If gv.Columns(i).SortExpression.Trim <> "" Then
                Dim dType As String = sqlReader.GetDataTypeName(sqlReader.GetOrdinal(gv.Columns(i).SortExpression))

                'If (dType.ToLower = "varchar" Or dType.ToLower = "nvarchar" Or dType.ToLower = "char" Or dType.ToLower = "text") Then
                If (lstDataType.Contains(dType.ToLower)) Then
                    Dim tb As TextBox = New TextBox()

                    Dim lt1 As New Literal()
                    lt1.Text = "<div class='col-md-3'><div class='form-group'>"
                    pnlFilter.Controls.Add(lt1)

                    tb.ID = gv.Columns(i).SortExpression
                    tb.CssClass = "form-control"
                    'tb.Width = 200
                    tb.Attributes.Add("placeholder", gv.Columns(i).HeaderText)
                    pnlFilter.Controls.Add(tb)

                    Dim lt2 As New Literal()
                    lt2.Text = "</div></div>"
                    pnlFilter.Controls.Add(lt2)
                End If
            End If
        Next

        sqlReader.Close()
        sqlConn.Close()
    End Sub

    Public Shared Sub GenerateFilter(ByVal gv As GridView, ByVal ds As SqlDataSource, ByRef pnlFilter As HtmlGenericControl, ByVal lstColumn As List(Of String))
        Dim sqlConn As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
        Dim initSelect As String = ds.SelectCommand.Substring(0, ds.SelectCommand.IndexOf("1=1") + 3)
        Dim sqlCmd As New SqlCommand(initSelect, sqlConn)
        sqlConn.Open()
        Dim sqlReader As SqlDataReader = sqlCmd.ExecuteReader()

        For i As Integer = 0 To gv.Columns.Count - 1
            If gv.Columns(i).SortExpression.Trim <> "" And lstColumn.Contains(gv.Columns(i).SortExpression.Trim) Then
                Dim dType As String = sqlReader.GetDataTypeName(sqlReader.GetOrdinal(gv.Columns(i).SortExpression))

                If (lstDataType.Contains(dType.ToLower)) Then
                    Dim tb As TextBox = New TextBox()

                    Dim lt1 As New Literal()
                    lt1.Text = "<div class='col-md-3'><div class='form-group'>"
                    pnlFilter.Controls.Add(lt1)

                    tb.ID = gv.Columns(i).SortExpression
                    tb.CssClass = "form-control"
                    'tb.Width = 200
                    tb.Attributes.Add("placeholder", gv.Columns(i).HeaderText)
                    pnlFilter.Controls.Add(tb)

                    Dim lt2 As New Literal()
                    lt2.Text = "</div></div>"
                    pnlFilter.Controls.Add(lt2)
                End If
            End If
        Next

        sqlReader.Close()
        sqlConn.Close()
    End Sub

    Public Shared Sub GenerateFilter2(ByVal gv As GridView, ByVal ds As SqlDataSource, ByRef pnlFilter As HtmlGenericControl, ByVal lstColumn As List(Of String))
        Dim sqlConn As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
        Dim initSelect As String = ds.SelectCommand.Substring(0, ds.SelectCommand.IndexOf("1=1") + 3)
        Dim sqlCmd As New SqlCommand(initSelect, sqlConn)
        sqlConn.Open()
        Dim sqlReader As SqlDataReader = sqlCmd.ExecuteReader()

        For i As Integer = 0 To gv.Columns.Count - 1
            If gv.Columns(i).SortExpression.Trim <> "" And lstColumn.Contains(gv.Columns(i).SortExpression.Trim) Then
                Dim dType As String = sqlReader.GetDataTypeName(sqlReader.GetOrdinal(gv.Columns(i).SortExpression))

                If (lstDataType.Contains(dType.ToLower)) Then
                    Dim tb As TextBox = New TextBox()

                    Dim lt1 As New Literal()
                    lt1.Text = "<div class='col-md-3'><div class='form-group'>"
                    pnlFilter.Controls.Add(lt1)

                    tb.ID = gv.Columns(i).SortExpression + "_2"
                    tb.CssClass = "form-control"
                    'tb.Width = 200
                    tb.Attributes.Add("placeholder", gv.Columns(i).HeaderText)
                    pnlFilter.Controls.Add(tb)

                    Dim lt2 As New Literal()
                    lt2.Text = "</div></div>"
                    pnlFilter.Controls.Add(lt2)
                End If
            End If
        Next

        sqlReader.Close()
        sqlConn.Close()
    End Sub



    Public Shared Sub procSearch(ByVal ds As SqlDataSource, ByRef pnlFilter As HtmlGenericControl)
        'Dim filterText As String = " "

        'For Each c As Control In pnlFilter.Controls
        '    If TypeOf c Is TextBox Then
        '        Dim txt As TextBox = CType(c, TextBox)
        '        If txt.Text.Trim <> "" Then
        '            filterText = filterText + " AND " + txt.ID + " LIKE '%" + txt.Text + "%'"
        '        End If
        '    End If
        'Next

        'Dim initSelect As String = ds.SelectCommand.Substring(0, ds.SelectCommand.IndexOf("1=1") + 3)
        'ds.SelectCommand = initSelect + filterText
        'ds.DataBind()

        '//new

        Dim filterText As String = " "

        For Each c As Control In pnlFilter.Controls
            If TypeOf c Is TextBox Then
                Dim txt As TextBox = CType(c, TextBox)
                If txt.Text.Trim <> "" Then
                    'If (txt.ID.Trim = "gangno") Then
                    '    filterText = filterText + " AND " + txt.ID + " LIKE '" + txt.Text + "'"
                    'Else
                    filterText = filterText + " AND " + txt.ID + " LIKE '%" + txt.Text + "%'"
                    'End If
                End If
            End If
        Next

        Dim posWhere As Integer = 0
        Dim initSelectSQL As String = ""
        Dim initSelect As String = ds.SelectCommand
        posWhere = initSelect.IndexOf("1=1")

        If posWhere > 0 Then
            initSelectSQL = ds.SelectCommand.Replace("1=1", "1=1 " & filterText)
        Else
            initSelectSQL = ds.SelectCommand
        End If

        ds.SelectCommand = initSelectSQL
        ds.DataBind()
    End Sub
    Public Shared Sub procSearch2(ByVal ds As SqlDataSource, ByRef pnlFilter As HtmlGenericControl)

        Dim filterText As String = " "

        For Each c As Control In pnlFilter.Controls
            If TypeOf c Is TextBox Then
                Dim txt As TextBox = CType(c, TextBox)
                If txt.Text.Trim <> "" Then
                    filterText = filterText + " AND " + txt.ID.Replace("_2", "") + " LIKE '%" + txt.Text + "%'"
                End If
            End If
        Next

        Dim posWhere As Integer = 0
        Dim initSelectSQL As String = ""
        Dim initSelect As String = ds.SelectCommand
        posWhere = initSelect.IndexOf("1=1")

        If posWhere > 0 Then
            initSelectSQL = ds.SelectCommand.Replace("1=1", "1=1 " & filterText)
        Else
            initSelectSQL = ds.SelectCommand
        End If

        ds.SelectCommand = initSelectSQL
        ds.DataBind()
    End Sub
    '+++++++++ END FILTER ++++++++++

    '//get Page Name
    Public Shared Function writeTitlePage(ByVal paraMenuId As Integer, Optional ByVal menu_name As String = "") As String
        Dim retval As String = ""


        '//if menu name is hardcorded
        If menu_name <> "" Then

            retval = menu_name

        Else

            If paraMenuId > 0 Then

                '// get menu name
                Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)


                    Dim SQL As String = "SELECT * from tbl_user_groupmodule A " &
                                        "WHERE A.UGM_Id = @paraMenuId"

                    Dim myCommand As New SqlCommand(SQL, myConnection)
                    myCommand.Parameters.AddWithValue("@paraMenuId", paraMenuId)


                    myConnection.Open()

                    Dim myReader As SqlDataReader = myCommand.ExecuteReader

                    While myReader.Read
                        If Not IsDBNull(myReader.Item("UGM_Name")) Then

                            retval = myReader.Item("UGM_Name")

                        End If

                    End While


                    myReader.Close()

                    myConnection.Close()

                End Using

            End If

        End If


        Return retval
    End Function


    Public Shared Function getEstateCodeByOCID(ByVal OCID As String) As String
        Dim code As String = "0"

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
            myConnection.Open()
            Dim SQLSelect As String = "SELECT code FROM [TBL_OCS] WHERE id = " & OCID
            Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)
            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader
            If myReader.Read Then
                code = myReader.Item("code")
            End If

            myReader.Close()
            myConnection.Close()
        End Using
        Return code
    End Function

    Public Shared Function getActiveMonthYearByEstateID(ByVal EstateID As String) As String
        Dim code As String = "0"

        'Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
        '    myConnection.Open()
        '    Dim SQLSelect As String = "SELECT TOP 1 ActMthYearID FROM ActiveMonthYear WHERE ModID=5 AND Status='A' AND EstateID = " & EstateID
        '    Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)
        '    Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader
        '    If myReader.Read Then
        '        code = myReader.Item("ActMthYearID")
        '    End If

        '    myReader.Close()
        '    myConnection.Close()
        'End Using
        Return code
    End Function

    Public Shared Function getActiveYearByEstateID(ByVal EstateID As String) As String
        Dim code As String = "0"

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
            myConnection.Open()
            Dim SQLSelect As String = "SELECT TOP 1 Ayear FROM ActiveMonthYear WHERE ModID=5 AND Status='A' AND EstateID = " & EstateID
            Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)
            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader
            If myReader.Read Then
                code = myReader.Item("Ayear")
            End If

            myReader.Close()
            myConnection.Close()
        End Using
        Return code
    End Function

    Public Shared Function getMonthYearIDbyParam(ByVal EstateID As String, ByVal Month As String, ByVal Year As String) As String
        Dim code As String = "0"
        If Month = "" Then
            Month = "0"
        End If
        If Year = "" Then
            Year = "0"
        End If

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
            myConnection.Open()
            Dim SQLSelect As String = "SELECT TOP 1 ActMthYearID FROM ActiveMonthYear WHERE ModID=5 AND EstateID = " & EstateID & " AND Amonth = " & Month & " AND Ayear = " & Year
            Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)
            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader
            If myReader.Read Then
                code = myReader.Item("ActMthYearID")
            End If

            myReader.Close()
            myConnection.Close()
        End Using
        Return code
    End Function

    Public Shared Function getActiveMonthByEstateID(ByVal EstateID As String) As String
        Dim code As String = "0"

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
            myConnection.Open()
            Dim SQLSelect As String = "SELECT TOP 1 Amonth FROM ActiveMonthYear WHERE ModID=5 AND Status='A' AND EstateID = " & EstateID
            Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)
            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader
            If myReader.Read Then
                code = myReader.Item("Amonth")
            End If

            myReader.Close()
            myConnection.Close()
        End Using
        Return code
    End Function

    Public Shared Function getIDActiveMonthByEstateID(ByVal EstateID As String, ByVal AYear As String, ByVal AMonth As String) As String
        Dim code As String = "0"

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
            myConnection.Open()
            Dim SQLSelect As String = "SELECT TOP 1 ActMthYearID FROM ActiveMonthYear WHERE EstateID = " & EstateID & " and AYear = " & AYear & " and Amonth = " & AMonth
            Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)
            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader
            If myReader.Read Then
                code = myReader.Item("ActMthYearID")
            End If

            myReader.Close()
            myConnection.Close()
        End Using
        Return code
    End Function

End Class




