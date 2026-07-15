
Imports System.Data.SqlClient

Partial Class MasterMenu
    Inherits System.Web.UI.MasterPage

    Public Event myMasterPageListChanged As EventHandler
    'Public menuBar2 As String
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        getNotification()

        If Session.Item("sessionUsersId") > 0 Then

            Try
                'If (Session.Item("sessionSystemId") = "" And Request.QueryString("m_Id") <> "") Or (Session.Item("sessionSystemId") = "0" And Request.QueryString("m_Id") <> "") Then
                If Request.QueryString("m_Id") <> "" Then
                    Session.Item("sessionSystemId") = getSessionSystemId(Request.QueryString("m_Id"))
                End If
            Catch ex As Exception

            End Try

            GlobalClass.GlobalVariables.urlSessionEnd = ""
            GlobalClass.GlobalVariables.urlSessionSystemId = Session.Item("sessionSystemId")
        Else

            Try
                If HttpContext.Current.Request.Url.PathAndQuery <> "/Default.aspx" Then
                    '// set redirect page when session expired
                    Dim FullUrl As String = HttpContext.Current.Request.Url.PathAndQuery

                    GlobalClass.GlobalVariables.urlSessionEnd = FullUrl
                    'GlobalClass.GlobalVariables.urlSessionSystemId = getSessionSystemId(Request.QueryString("m_Id"))
                    'Response.Redirect("\Default")
                End If
            Catch ex As Exception

            End Try


        End If

        Dim Counter_Others As String = HttpContext.Current.Request.UserAgent
        'MsgBox(Counter_Others)
        Dim sessionUserId As Integer = 1
        Dim glblClass As New GlobalClass()

        Dim allowedAccess As Boolean = GlobalClass.CheckPagePermission("Read")
        If allowedAccess = False Then
            Response.Redirect("~/administration/deniedpage.aspx")
        End If

        '//generate dynamic menu
        'menuBar.InnerHtml = glblClass.WriteMenu(0)
        lblFullname1.Text = ""
        'lblFullname.Text = ""
        If CInt(Session.Item("sessionUsersId")) > 0 Then
            'lblFullname.Text = Session.Item("sessionFullname")
            lblFullname1.Text = Session.Item("sessionFullname")
            profileInfo.Visible = True '--
            DropDownListUserOCS.Visible = True
            lblMonthYear.Visible = True '--
        Else
            profileInfo.Visible = False '--
            DropDownListUserOCS.Visible = False
            lblMonthYear.Visible = False '--
        End If


        'menuBar1.InnerHtml = GlobalClass.WriteAdminMenu(0, 0, 0)
        'MsgBox(GlobalClass.WriteAdminMenu2021_Sub(0, 0, 0))

        menuBar1.InnerHtml = GlobalClass.WriteAdminMenu(0, 0, 0) '//parent menu
        menuBar2.InnerHtml = GlobalClass.WriteAdminMenu_Sub(0, 0, 0) '//sub menu'--

        If Not IsPostBack Then
            If Session.Item("sessionOCpermission") = 0 Then
                If (Session.Item("sessionOCS") = 0) Then
                    Session.Item("sessionOCS") = "586"
                    Session.Item("sessionEstateCode") = GlobalClass.getEstateCodeByOCID(Session.Item("sessionOCS").ToString())
                    Session.Item("sessionActiveMonthYearID") = GlobalClass.getActiveMonthYearByEstateID(Session.Item("sessionEstateCode").ToString())
                End If

                DropDownListUserOCS.SelectedValue = Session.Item("sessionOCS")
                DropDownListUserOCS.Enabled = True
            Else
                DropDownListUserOCS.SelectedValue = Session.Item("sessionOCS")
                DropDownListUserOCS.Enabled = False
            End If
        End If

        '--Add by edi 20210628
        lblMonthYear.Text = ""
        If Session.Item("sessionActiveMonthYearID") <> "0" And Session.Item("sessionActiveMonthYearID") <> "" Then
            Dim sAmonth As String
            Dim sMonth As String
            Dim sAYear As String
            If GlobalClass.GetMonthYear(Session("sessionEstateCode"), Session("sessionActiveMonthYearID"), sAmonth, sAYear, sMonth) Then
                Session.Item("LoginYear") = Convert.ToInt16(sAYear)
                Session.Item("LoginMonth") = Convert.ToInt16(sMonth)
                lblMonthYear.Text = "&nbsp;&nbsp;&nbsp;<b>" + sAmonth + "/" + sAYear + "</b>"
            End If
        End If
        '--End Add

        '//initial for left sub title
        Dim dr As System.Data.SqlClient.SqlDataReader
        Dim lstr As String
        Dim lflag As Boolean
        Dim system_Name As String = "KulimSundry"


        Try

            lstr = "select system_Name from TBL_SYSTEM where system_Id = @systemSession "

            Dim parameters = New SqlParameter() {New SqlParameter("@systemSession", Session.Item("sessionSystemId"))}

            dr = SysCon.ExecuteReader(lstr, parameters)

            If dr.Read Then
                If Not IsDBNull(dr.Item("system_Name")) Then
                    system_Name = dr.Item("system_Name")
                End If
            End If


            If Not dr.IsClosed Then dr.Close()
        Catch ex As Exception

        End Try


        leftSubTitle.InnerText = system_Name '--
        DropDownListUserOCS.Visible = False
    End Sub

    Public Property badgeIconPropertyOnMasterPage As String
        Get
            Return badgeIcon.InnerText
        End Get
        Set(ByVal value As String)
            badgeIcon.InnerText = value
        End Set
    End Property

    Public Property divBadgeOnMasterPageDisplayNone As String
        Get
            Return divNotification.InnerText
        End Get
        Set(ByVal value As String)
            divNotification.Attributes.Add("style", value)
        End Set
    End Property

    Public Property divBadgeOnMasterPageDisplay As String
        Get
            Return divNotification.InnerText
        End Get
        Set(ByVal value As String)
            divNotification.Attributes.Add("style", value)
        End Set
    End Property

    Public Sub getNotification()
        Dim notificationCount As Integer = 0

        notificationCount = GlobalClass.getNotificationCount()

        If notificationCount = 0 Then
            divNotification.Attributes.Add("style", "display:none")
        Else
            divNotification.Attributes.Add("style", "")
            badgeIcon.InnerText = notificationCount
        End If

    End Sub

    '	Private Sub getNotification()
    '        Dim notificationCount As Integer = 0

    '        Try
    '            Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

    '                Dim strSQL As String = "SELECT COUNT (*) AS cnt
    'FROM HD_Ticket 
    'LEFT JOIN HD_CRF ON HD_Ticket.ticketId = HD_CRF.ticketId
    'LEFT JOIN Employees AS HOU ON HD_Ticket.assignHOU = HOU.EmpID
    'INNER JOIN HD_SubCategory ON HD_Ticket.subCategoryId = HD_SubCategory.subCategoryId 
    'INNER JOIN HD_Category ON HD_Ticket.categoryId = HD_Category.categoryId 
    'LEFT JOIN HD_Priority ON HD_Ticket.priorityId = HD_Priority.priorityId 
    'INNER JOIN Employees ON HD_Ticket.EmpID = Employees.EmpID 
    'INNER JOIN Employees AS EmployeeONBehalf ON HD_Ticket.EmpIDONBehalf = EmployeeONBehalf.EmpID 
    'INNER JOIN Employees AS Employees_1 ON SUBSTRING(Employees.Supervisor, PATINDEX('%[^0 ]%', Employees.Supervisor), LEN(Employees.Supervisor)) = SUBSTRING(Employees_1.EmployeeNo, PATINDEX('%[^0 ]%', Employees_1.EmployeeNo), LEN(Employees_1.EmployeeNo)) 
    'WHERE assignHOU = @sessionEmpID AND HD_Ticket.verified = 'P' "

    '                Dim myCommand As New SqlCommand(strSQL, myConnection)
    '                myCommand.Parameters.AddWithValue("@sessionEmpID", Session.Item("sessionEmpID"))

    '                myConnection.Open()

    '                Dim myReader As SqlDataReader = myCommand.ExecuteReader

    '                If myReader.Read Then
    '                    Try
    '                        notificationCount = myReader.Item("cnt")
    '                    Catch ex As Exception
    '                        notificationCount = 0
    '                    End Try

    '                End If

    '                myReader.Close()

    '                myConnection.Close()

    '            End Using
    '        Catch ex As Exception

    '        End Try


    '        If notificationCount = 0 Then
    '            divNotification.Attributes.Add("style", "display:none")
    '        Else
    '            divNotification.Attributes.Add("style", "")
    '            badgeIcon.InnerText = notificationCount
    '        End If

    '    End Sub

    Protected Sub showList(ByVal sender As Object, ByVal e As EventArgs)
        Response.Redirect("/helpdesk/tasklisting.aspx?p_Id=2273&m_Id=3331")
    End Sub
	
    Private Function getSessionSystemId(m_Id As String) As Object
        Dim retval As Integer = 0

        Try

            Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

                Dim strSQL As String = "select top 1 * from TBL_USER_GROUPMODULE where UGM_Id = @UGM_Id"

                Dim myCommand As New SqlCommand(strSQL, myConnection)
                myCommand.Parameters.AddWithValue("@UGM_Id", m_Id)

                myConnection.Open()

                Dim myReader As SqlDataReader = myCommand.ExecuteReader

                If myReader.Read Then
                    Try
                        retval = myReader.Item("UGM_SystemId")
                    Catch ex As Exception
                        retval = 0
                    End Try

                End If

                myReader.Close()

                myConnection.Close()

            End Using
        Catch ex As Exception

        End Try

        Return retval
    End Function	

    'Protected Sub linkLogout_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles linkLogout.Click
    '    Session.Abandon()
    '    '//run audit trail : Insert : Update : Delete : Login : Logout
    '    GlobalClass.auditTrail("Logout Button", "Logout", "Logout")
    '    Response.Redirect("~/Default.aspx")
    'End Sub


    Public Function generateAdminMenu(ByVal filename As Array, ByVal menuname As Array, Optional ByVal parentname As String = "") As String

        Dim retval As String = ""
        Dim retchild As String = ""
        Dim havechild As Boolean = False

        Dim i As Integer = 0
        For i = 0 To filename.Length - 1

            If GlobalClass.CheckPagePermission("Read", filename(i)) Then
                havechild = True
                retchild = retchild + "<li runat=""server""><a href=""" + filename(i) + """>" + menuname(i) + "</a></li>"
            End If

        Next

        If havechild = True Then

            If parentname <> "" Then
                retval = retval + "<li runat=""server""><a>" + parentname + "</a><ul>"
            End If

            retval = retval + "" + retchild

            If parentname <> "" Then
                retval = retval + "</ul></li>"
            End If

        End If

        Return retval



    End Function

    Private Sub DropDownListUserOCS_SelectedIndexChanged(sender As Object, e As EventArgs) Handles DropDownListUserOCS.SelectedIndexChanged
        Session.Item("sessionOCS") = DropDownListUserOCS.SelectedValue.ToString
        Session.Item("sessionEstateCode") = GlobalClass.getEstateCodeByOCID(Session.Item("sessionOCS").ToString())
        Session.Item("sessionActiveMonthYearID") = GlobalClass.getActiveMonthYearByEstateID(Session.Item("sessionEstateCode").ToString())
        If Session.Item("sessionActiveMonthYearID") <> "0" And Session.Item("sessionActiveMonthYearID") <> "" Then
            Dim sAmonth As String
            Dim sMonth As String
            Dim sAYear As String
            If Not GlobalClass.GetMonthYear(Session("sessionEstateCode"), Session("sessionActiveMonthYearID"), sAmonth, sAYear, sMonth) Then Exit Sub
            Session.Item("LoginYear") = Convert.ToInt16(sAYear)
            Session.Item("LoginMonth") = Convert.ToInt16(sMonth)
        End If
        Response.Redirect(Request.RawUrl)
    End Sub

    Private Sub DropDownListUserOCS_DataBound(sender As Object, e As EventArgs) Handles DropDownListUserOCS.DataBound
        If DropDownListUserOCS.Items.Contains(New ListItem(Session.Item("sessionOCS").ToString())) Then
            Session.Item("sessionOCS") = "586"
            Session.Item("sessionEstateCode") = GlobalClass.getEstateCodeByOCID(Session.Item("sessionOCS").ToString())
            Session.Item("sessionActiveMonthYearID") = GlobalClass.getActiveMonthYearByEstateID(Session.Item("sessionEstateCode").ToString())
            If Session.Item("sessionActiveMonthYearID") <> "0" And Session.Item("sessionActiveMonthYearID") <> "" Then
                Dim sAmonth As String
                Dim sMonth As String
                Dim sAYear As String
                If Not GlobalClass.GetMonthYear(Session("sessionEstateCode"), Session("sessionActiveMonthYearID"), sAmonth, sAYear, sMonth) Then Exit Sub
                Session.Item("LoginYear") = Convert.ToInt16(sAYear)
                Session.Item("LoginMonth") = Convert.ToInt16(sMonth)
            End If
        End If
    End Sub
End Class

