
Imports System.Data.SqlClient

Partial Class MasterMenu
    Inherits System.Web.UI.MasterPage

    Public Event myMasterPageListChanged As EventHandler
    'Public menuBar2 As String
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'getNotification()
        Dim CurUrl As String = HttpContext.Current.Request.Url.PathAndQuery

        If CInt(Session.Item("sessionUsersId")) > 0 Or CurUrl.Contains("semakkelulusan.aspx") Or CurUrl.Contains("pages.aspx") Or CurUrl.Contains("ResetPassword") Then


            If CurUrl.Contains("semakkelulusan.aspx") And CInt(Session.Item("sessionUsersId")) = 0 Or CurUrl.Contains("pages.aspx") And CInt(Session.Item("sessionUsersId")) = 0 Or CurUrl.Contains("ResetPassword") And CInt(Session.Item("sessionUsersId")) = 0 Then
            Else
                liLogout.Visible = True
                liNotification.Visible = True
            End If


            Try
                'If (Session.Item("sessionSystemId") = "" And Request.QueryString("m_Id") <> "") Or (Session.Item("sessionSystemId") = "0" And Request.QueryString("m_Id") <> "") Then
                If Request.QueryString("m_Id") <> "" Then
                    Session.Item("sessionSystemId") = getSessionSystemId(Request.QueryString("m_Id"))
                End If
            Catch ex As Exception

            End Try

            GlobalClass.GlobalVariables.urlSessionEnd = ""
            GlobalClass.GlobalVariables.urlSessionSystemId = Session.Item("sessionSystemId")

            '//set image profile
            Dim profilePath As String = Server.MapPath("~/profile/" & Session.Item("sessionUsersId") & ".jpeg")

            If System.IO.File.Exists(profilePath) Then
                imgProfile.ImageUrl = "~/profile/" & Session.Item("sessionUsersId") & ".jpeg"
            Else
                imgProfile.ImageUrl = "~/profile/blank.jpeg"
            End If

            '//set badge notification for approval
            Try
                setBadgeNotification()
            Catch ex As Exception

            End Try

        Else

            liLogout.Visible = False
            liNotification.Visible = False

            Try
                If HttpContext.Current.Request.Url.PathAndQuery <> "/Default.aspx" Then
                    '// set redirect page when session expired
                    Dim FullUrl As String = HttpContext.Current.Request.Url.PathAndQuery

                    GlobalClass.GlobalVariables.urlSessionEnd = FullUrl

                End If
            Catch ex As Exception

            End Try


        End If

        Dim Counter_Others As String = HttpContext.Current.Request.UserAgent
        'MsgBox(Counter_Others)
        Dim sessionUserId As Integer = 1
        Dim glblClass As New GlobalClass()

        Dim allowedAccess As Boolean = GlobalClass.CheckPagePermission("Read")
        If CurUrl.Contains("semakkelulusan.aspx") Or CurUrl.Contains("pages.aspx") Or CurUrl.Contains("ResetPassword") Then
            allowedAccess = True
        Else

        End If

        If GlobalClass.CheckPagePermission("Read", "semakansurat.aspx") Then
            divNotiSuratMohonUlasan.Visible = True
        End If


        If allowedAccess = False Then
            Response.Redirect("~/administration/deniedpage.aspx")
        End If

        '//generate dynamic menu

        lblFullname1.Text = ""
        If CInt(Session.Item("sessionUsersId")) > 0 Then
            lblFullname1.Text = Session.Item("sessionFullname")
            ProfileInfo.Visible = True '--

        Else
            ProfileInfo.Visible = False '--

        End If


        'Label1.Text = GlobalClass.WriteAdminMenu_Sub(0, 0, 0)
        'menuBar1.InnerHtml = GlobalClass.WriteAdminMenu(0, 0, 0) '//parent menu
        'menuBar1.InnerHtml = GlobalClass.WriteAdminMenu(0, 0, 0) '//sub menu'--
        Try
            menuBar1.InnerHtml = GlobalClass.WriteAdminMenuParent(0, 0, 0)
        Catch ex As Exception

        End Try




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

        '//footer size
        If Not Page.IsPostBack Then

            If Request.Browser.IsMobileDevice Then
                idFooter1.Style.Add("font-size", "8pt !important")
                'idFooter2.Style.Add("font-size", "8pt !important")
                upMain.Style.Add("font-size", "10pt !important")
				idTitleHeader.Style.Add("font-size", "12pt !important")
            End If

        End If

        'leftSubTitle.InnerText = system_Name '--
        'DropDownListUserOCS.Visible = False
    End Sub

    Private Sub setBadgeNotification()

        'lblNotiApproval.Text = "10"

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Dim strSQL As String = "SELECT count(*) as cnt FROM 
            v_LESEN_ApprovalList_Curr a
            inner join LESEN_JenisLesen d on d.JenisLesen_ID = a.JenisLesen_ID
            left join LESEN_JabatanAgensi e on e.JabatanAgensi_ID = a.AgensiID
            inner join LESEN_Pemohon f on f.Pemohon_ID = a.Permohonan_PemohonID
            inner join LESEN_Permohonan g on g.Permohonan_ID = a.Permohonan_ID
            where 1=1 and (
            a.ApprStatusID = case when @isPenyedia = 1 then 3 else 99 end 
            or a.ApprStatusID = case when @isPenilai = 1 then 2 else 99 end
            or a.ApprStatusID = case when @isPenilai = 1 then 5 else 99 end
            or a.ApprStatusID = case when @isPenilai = 1 then 4 else 99 end
            or a.ApprStatusID = case when @isPenilai = 1 and @isReadOnly = 1 and 1 = 2 then 6 else 99 end
            or a.ApprStatusID = case when @isPenilai = 1 and @isReadOnly = 1 and 1 = 2 then 7 else 99 end
            or a.ApprStatusID = case when @isPenilai = 1 and @isReadOnly = 1 and 1 = 2 then 8 else 99 end
            or a.ApprStatusID = case when @isPenilai = 1 and @isReadOnly = 1 and 1 = 2 then 9 else 99 end
            or a.ApprStatusID = case when @isPenilai = 1 and @isReadOnly = 1 and 1 = 2 then 10 else 99 end		
            or a.ApprStatusID = case when @isPeraku = 1 then 8 else 99 end
            
            )
            and case when isnull((select top 1 x.JabatanAgensi_IsLesen from LESEN_JabatanAgensi x where x.JabatanAgensi_ID = @AgensiID),0) = 1  then isnull(a.AgensiID,@AgensiID) else a.AgensiID end 
            = case when isnull((select top 1 x.JabatanAgensi_IsLesen from LESEN_JabatanAgensi x where x.JabatanAgensi_ID = @AgensiID),0) = 1  then @AgensiID else @AgensiID end                                 

            and case when a.ApprStatusID = 3 then @sessionUsersId else 0 end IN 
            (select x.PermohonanAgensiStaffID_UsersID 
            from LESEN_PermohonanAgensiStaff x 
            inner join LESEN_PermohonanAgensi x2 on x2.PermohonanAgensi_ID = x.PermohonanAgensi_ID
            where x2.Permohonan_ID = g.Permohonan_ID and x2.JabatanAgensi_ID = @AgensiID union all select 0  )  
            "

            Dim myCommand As New SqlCommand(strSQL, myConnection)
            myCommand.Parameters.AddWithValue("@AgensiID", Session.Item("sessionEstateID"))
            myCommand.Parameters.AddWithValue("@isPenyedia", Session.Item("sessionIsPenyedia"))
            myCommand.Parameters.AddWithValue("@isPenilai", Session.Item("sessionIsPenilai"))
            myCommand.Parameters.AddWithValue("@isPeraku", Session.Item("sessionIsPeraku"))
            myCommand.Parameters.AddWithValue("@sessionUsersId", Session.Item("sessionUsersId"))
			myCommand.Parameters.AddWithValue("@isReadOnly", Session.Item("sessionIsReadOnly"))

            myConnection.Open()

            Dim myReader As SqlDataReader = myCommand.ExecuteReader

            If myReader.Read Then
                Try
                    lblNotiApproval.Text = myReader.Item("cnt")
					
				If CInt(myReader.Item("cnt")) > 0 Then
					idSpanNoti.Visible = True
				End If				
					
                Catch ex As Exception
                    lblNotiApproval.Text = ""
                End Try

            End If

            myReader.Close()

            myConnection.Close()

        End Using

        '//pembatalan

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Dim strSQL As String = "SELECT count(*) as cnt FROM 
            v_LESEN_ApprovalListBatal_Curr a
            inner join LESEN_JenisLesen d on d.JenisLesen_ID = a.JenisLesen_ID
            left join LESEN_JabatanAgensi e on e.JabatanAgensi_ID = a.AgensiID
            inner join LESEN_Pemohon f on f.Pemohon_ID = a.Permohonan_PemohonID
            inner join LESEN_Permohonan g on g.Permohonan_ID = a.Permohonan_ID
            where 1=1 and (
            a.ApprStatusID = case when @isPenyedia = 1 then 3 else 99 end 
            or a.ApprStatusID = case when @isPenilai = 1 then 2 else 99 end
            or a.ApprStatusID = case when @isPenilai = 1 then 5 else 99 end
            or a.ApprStatusID = case when @isPenilai = 1 then 4 else 99 end
            or a.ApprStatusID = case when @isPenilai = 1 and @isReadOnly = 1 and 1 = 2 then 6 else 99 end
            or a.ApprStatusID = case when @isPenilai = 1 and @isReadOnly = 1 and 1 = 2 then 7 else 99 end
            or a.ApprStatusID = case when @isPenilai = 1 and @isReadOnly = 1 and 1 = 2 then 8 else 99 end
            or a.ApprStatusID = case when @isPenilai = 1 and @isReadOnly = 1 and 1 = 2 then 9 else 99 end
            or a.ApprStatusID = case when @isPenilai = 1 and @isReadOnly = 1 and 1 = 2 then 10 else 99 end			
            or a.ApprStatusID = case when @isPeraku = 1 then 8 else 99 end
            
            )
            and case when isnull((select top 1 x.JabatanAgensi_IsLesen from LESEN_JabatanAgensi x where x.JabatanAgensi_ID = @AgensiID),0) = 1 then isnull(a.AgensiID,@AgensiID) else a.AgensiID end 
            = case when isnull((select top 1 x.JabatanAgensi_IsLesen from LESEN_JabatanAgensi x where x.JabatanAgensi_ID = @AgensiID),0) = 1 then @AgensiID else @AgensiID end
                                              
            and case when a.ApprStatusID = 3 then @sessionUsersId else 0 end IN 
            (select x.PermohonanAgensiStaffID_UsersID 
            from LESEN_PermohonanAgensiStaffBatal x 
            inner join LESEN_PermohonanAgensiBatal x2 on x2.PermohonanAgensi_ID = x.PermohonanAgensi_ID
            where x2.Permohonan_ID = g.Permohonan_ID and x2.JabatanAgensi_ID = @AgensiID union all select 0  )             
            "

            Dim myCommand As New SqlCommand(strSQL, myConnection)
            myCommand.Parameters.AddWithValue("@AgensiID", Session.Item("sessionEstateID"))
            myCommand.Parameters.AddWithValue("@isPenyedia", Session.Item("sessionIsPenyedia"))
            myCommand.Parameters.AddWithValue("@isPenilai", Session.Item("sessionIsPenilai"))
            myCommand.Parameters.AddWithValue("@isPeraku", Session.Item("sessionIsPeraku"))
            myCommand.Parameters.AddWithValue("@sessionUsersId", Session.Item("sessionUsersId"))
			myCommand.Parameters.AddWithValue("@isReadOnly", Session.Item("sessionIsReadOnly"))

            myConnection.Open()

            Dim myReader As SqlDataReader = myCommand.ExecuteReader

            If myReader.Read Then
                Try
                    lblNotiApproval2.Text = myReader.Item("cnt")
					
					If CInt(myReader.Item("cnt")) > 0 Then
						idSpanNoti.Visible = True
					End If				
					
                Catch ex As Exception
                    lblNotiApproval2.Text = ""
                End Try

            End If

            myReader.Close()

            myConnection.Close()

        End Using
		
	'//surat mohon ulasan

	Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

		Dim strSQL As String = "select count(*) as cnt from (
		select
		a.Permohonan_ID,'Permohonan Baru' as jenisPermohonan,PermohonanAgensi_ID,b.JenisLesen_ID,TarikhMohon,
		JenisLesen_Description,Pemohon_Name,JabatanAgensi_Description,Permohonan_PemohonID,Rujukan,JabatanAgensi_Type
		from LESEN_PermohonanAgensi a
		inner join LESEN_Permohonan b on b.Permohonan_ID = a.Permohonan_ID
		inner join LESEN_JabatanAgensi c on c.JabatanAgensi_ID = a.JabatanAgensi_ID
		inner join LESEN_JenisLesen d on d.JenisLesen_ID = b.JenisLesen_ID
		inner join LESEN_Pemohon e on e.Pemohon_ID = b.Permohonan_PemohonID
		where reviewStatusID = 1 
		and isnull(b.StatusID,0) = 0
		and case when @isKB = 1 then isnull(a.kbApproval,2) else 99 end = case when @isKB = 1  then 2 else 99 end
		and case when @isKJ = 1 then isnull(a.kbApproval,2) else 99 end = case when @isKJ = 1 then 1 else 99 end
		and case when @isKJ = 1 then isnull(a.kjApproval,2) else 99 end = case when @isKJ = 1 then 2 else 99 end
		and case when @isKJ = 1 then c.JabatanAgensi_Type else '99' end = case when @isKJ = 1 then ('L') else ('99') end

		union all

		select 
		a.Permohonan_ID,'Pembatalan' as jenisPermohonan,PermohonanAgensi_ID,b.JenisLesen_ID,TarikhMohon,
		JenisLesen_Description,Pemohon_Name,JabatanAgensi_Description,Permohonan_PemohonID,Rujukan,JabatanAgensi_Type
		from LESEN_PermohonanAgensiBatal a
		inner join LESEN_Permohonan b on b.Permohonan_ID = a.Permohonan_ID
		inner join LESEN_JabatanAgensi c on c.JabatanAgensi_ID = a.JabatanAgensi_ID
		inner join LESEN_JenisLesen d on d.JenisLesen_ID = b.JenisLesen_ID
		inner join LESEN_Pemohon e on e.Pemohon_ID = b.Permohonan_PemohonID
		where reviewStatusID = 1 
		and isnull(b.StatusID,0) = 0
		and case when @isKB = 1 then isnull(a.kbApproval,2) else 99 end = case when @isKB = 1  then 2 else 99 end
		and case when @isKJ = 1 then isnull(a.kbApproval,2) else 99 end = case when @isKJ = 1 then 1 else 99 end
		and case when @isKJ = 1 then isnull(a.kjApproval,2) else 99 end = case when @isKJ = 1 then 2 else 99 end
		and case when @isKJ = 1 then c.JabatanAgensi_Type else '99' end = case when @isKJ = 1 then ('L') else ('99') end
		) as tbl1
		 "

		Dim myCommand As New SqlCommand(strSQL, myConnection)
		myCommand.Parameters.AddWithValue("@AgensiID", Session.Item("sessionEstateID"))
		myCommand.Parameters.AddWithValue("@isPenyedia", Session.Item("sessionIsPenyedia"))
		myCommand.Parameters.AddWithValue("@isKB", Session.Item("sessionIsPenilai"))
		myCommand.Parameters.AddWithValue("@isKJ", Session.Item("sessionIsPeraku"))
		myCommand.Parameters.AddWithValue("@sessionUsersId", Session.Item("sessionUsersId"))

		myConnection.Open()

		Dim myReader As SqlDataReader = myCommand.ExecuteReader

		If myReader.Read Then

			Try
				lblNotiApproval3.Text = myReader.Item("cnt")
				
				If CInt(myReader.Item("cnt")) > 0 Then
					idSpanNoti.Visible = True
				End If				
			Catch ex As Exception
				lblNotiApproval3.Text = "0"
			End Try

		Else

		End If

		myReader.Close()

		myConnection.Close()

	End Using		

    End Sub

    'Public Property badgeIconPropertyOnMasterPage As String
    '    Get
    '        Return badgeIcon.InnerText
    '    End Get
    '    Set(ByVal value As String)
    '        badgeIcon.InnerText = value
    '    End Set
    'End Property

    'Public Property divBadgeOnMasterPageDisplayNone As String
    '    Get
    '        Return divNotification.InnerText
    '    End Get
    '    Set(ByVal value As String)
    '        divNotification.Attributes.Add("style", value)
    '    End Set
    'End Property

    'Public Property divBadgeOnMasterPageDisplay As String
    '    Get
    '        Return divNotification.InnerText
    '    End Get
    '    Set(ByVal value As String)
    '        divNotification.Attributes.Add("style", value)
    '    End Set
    'End Property

    'Public Sub getNotification()
    '    Dim notificationCount As Integer = 0

    '    notificationCount = GlobalClass.getNotificationCount()

    '    If notificationCount = 0 Then
    '        divNotification.Attributes.Add("style", "display:none")
    '    Else
    '        divNotification.Attributes.Add("style", "")
    '        badgeIcon.InnerText = notificationCount
    '    End If

    'End Sub



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

End Class

