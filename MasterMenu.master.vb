Imports System.Data.SqlClient

Partial Class MasterMenu
    Inherits System.Web.UI.MasterPage

    Public Event myMasterPageListChanged As EventHandler
    'Public menuBar2 As String
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        '//define css
        Dim pageName As String = System.IO.Path.GetFileName(Request.Path).ToLower()

        '//If pageName <> "default.aspx" Then
        If CInt(Session.Item("sessionUsersId")) > 0 Then
            bodyTag.Attributes("class") = "compact-form"
        End If
        '//end of defined css

        If Session.Item("sessionLoginDenied") <> "" Then
            txtError.Text = Session.Item("sessionLoginDenied")
        End If

        Dim CurUrl As String = HttpContext.Current.Request.Url.PathAndQuery

        If CInt(Session.Item("sessionUsersId")) > 0 Or CurUrl.Contains("semakkelulusan.aspx") Or CurUrl.Contains("pages.aspx") Or CurUrl.Contains("ResetPassword") Then


            If CurUrl.Contains("semakkelulusan.aspx") And CInt(Session.Item("sessionUsersId")) = 0 Or CurUrl.Contains("pages.aspx") And CInt(Session.Item("sessionUsersId")) = 0 Or CurUrl.Contains("ResetPassword") And CInt(Session.Item("sessionUsersId")) = 0 Then
            Else
                'liLogout.Visible = True
                'liNotification.Visible = True
            End If


            Try

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

            If Request.Url.Host.ToLower() = "prolesen.mpkluang.gov.my" Then
                'lblTitlePage.Text = "PRO-LESEN MPK"
            Else
                'lblTitlePage.Text = "PRO-LESEN MPK (STAGING)"
            End If

        Else

            'liLogout.Visible = False
            'liNotification.Visible = False

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
        '
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
                'idFooter1.Style.Add("font-size", "8pt !important")
                'upMain.Style.Add("font-size", "10pt !important")
                'idTitleHeader.Style.Add("font-size", "12pt !important")
            End If

        End If

        'leftSubTitle.InnerText = system_Name '--
        'DropDownListUserOCS.Visible = False
    End Sub

    Protected Sub btnLogin_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLogin.Click
        Dim txtUsername = Me.txtUsername.Text
        Dim paraPassword = Me.txtPassword.Text

        Try
            If txtUsername.ToLower <> "admin" Then
                If Not txtUsername.Contains("@") Then
                    'txtUsername = txtUsername & "@kulim.com.my"
                End If
            End If
        Catch ex As Exception
        End Try

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            '//start encrypt password
            Dim txtPassword As String = GlobalClass.Encrypt(paraPassword, "kmbportal", True)
            'Dim txtPassword As String = paraPassword

            Dim sSQL As String = ""
            'If txtUsername.ToLower <> "admin" Then
            'If Not GlobalClass.getWebconOveride().ToString.ToLower.Contains(txtUsername.ToLower) Then
            '    sSQL = "SELECT VW_TBL_USERS.*,TBL_USER_GROUPLIST.UGL_UGN_Id , TBL_USER_GROUPNAME.UGN_IsAdmin from VW_TBL_USERS,TBL_USER_GROUPLIST, TBL_USER_GROUPNAME where VW_TBL_USERS.Users_Id = TBL_USER_GROUPLIST.UGL_Users_Id and TBL_USER_GROUPNAME.UGN_Id=TBL_USER_GROUPLIST.UGL_UGN_Id and 
            '    case when CHARINDEX('@',isnull(VW_TBL_USERS.Email,'')) = 0 then NULL else SUBSTRING(VW_TBL_USERS.Email,0,CHARINDEX('@',VW_TBL_USERS.Email)) end = case when CHARINDEX('@',isnull(@txtUsername,'')) = 0 
            '    then @txtUsername else SUBSTRING(@txtUsername,0,CHARINDEX('@',@txtUsername)) end
            '    and VW_TBL_USERS.Users_Enabled=1 "
            'Else
            If True Then
                sSQL = "SELECT VW_TBL_USERS.*,TBL_USER_GROUPLIST.UGL_UGN_Id , TBL_USER_GROUPNAME.UGN_IsAdmin from VW_TBL_USERS,TBL_USER_GROUPLIST, TBL_USER_GROUPNAME where VW_TBL_USERS.Users_Id = TBL_USER_GROUPLIST.UGL_Users_Id and TBL_USER_GROUPNAME.UGN_Id=TBL_USER_GROUPLIST.UGL_UGN_Id and (VW_TBL_USERS.Users_Name=@txtUsername 
                OR case when CHARINDEX('@',isnull(VW_TBL_USERS.Users_Email,'')) = 0 then NULL else SUBSTRING(VW_TBL_USERS.Users_Email,0,CHARINDEX('@',VW_TBL_USERS.Users_Email)) end = case when CHARINDEX('@',isnull(@txtUsername,'')) = 0 
                then @txtUsername else SUBSTRING(@txtUsername,0,CHARINDEX('@',@txtUsername)) end) 
                and VW_TBL_USERS.Users_Password=@txtPassword and VW_TBL_USERS.Users_Enabled=1 "
            End If


            Dim myCommand As New SqlCommand(sSQL, myConnection)
            myCommand.Parameters.AddWithValue("@txtUsername", txtUsername)
            myCommand.Parameters.AddWithValue("@txtPassword", txtPassword)

            myConnection.Open()

            Dim myReader As SqlDataReader = myCommand.ExecuteReader

            If myReader.Read Then


                Dim uid = myReader("Users_Id")
                Dim username = myReader("Users_Name")
                Dim fullname = myReader("Users_Fullname")
                Dim ocs = myReader("estate_id")
                Dim userrole = myReader("UGL_UGN_Id")
                Dim isAdmin = myReader("UGN_IsAdmin")
                Dim isRC As Boolean = CBool(myReader("IsRC"))
                Dim EmpID = myReader("EmpID")
                Dim EmployeeNo = myReader("EmployeeNo")
                Dim DivisionCode = myReader("DivisionCode")

                Session.Item("sessionUsersId") = uid
                Session.Item("sessionUserName") = username
                Session.Item("sessionFullname") = fullname
                Session.Item("sessionEstateID") = ocs
                Session.Item("sessionOCpermission") = ocs
                Session.Item("sessionOCS") = ocs
                Session.Item("sessionuserrole") = userrole
                Session.Item("sessionisadmin") = isAdmin
                Session.Item("sessionIsRC") = isRC
                Session.Item("sessionEmpID") = EmpID
                Session.Item("sessionEmployeeNo") = EmployeeNo
                Session.Item("DivisionCode") = DivisionCode

                Session.Item("sessionIsPenyedia") = myReader("Users_IsLawatanTapakUlasan")
                Session.Item("sessionIsPenilai") = myReader("Users_IsPenilaian")
                Session.Item("sessionIsPeraku") = myReader("Users_IsPeraku")
                Session.Item("sessionIsReadOnly") = myReader("Users_IsReadOnly")

                'MsgBox(isAdmin)
            End If

            myReader.Close()
            myConnection.Close()



            'Dim txtUsername = Request.QueryString("txtUsername")
            'Response.Write(SQL)
            'Response.End()
            'Else
            '    lblMessage.ForeColor = System.Drawing.Color.Red
            '    lblMessage.Text = "InValid code."
            'End If

        End Using

        Session.Item("sessionLoginDenied") = ""

        If Session.Item("sessionUsersId") > 0 Then
            '//run audit trail : Insert : Update : Delete : Login : Logout
            GlobalClass.auditTrail("Login Form", "Login", "Login")
            'MsgBox(GlobalClass.GlobalVariables.urlSessionEnd)
            If GlobalClass.GlobalVariables.urlSessionEnd = "" Then

                Response.Redirect("/")

            Else
                Session.Item("sessionSystemId") = GlobalClass.GlobalVariables.urlSessionSystemId
                If Session.Item("sessionSystemId") = "0" Or Session.Item("sessionSystemId") = "" Then
                    Response.Redirect("/")
                Else
                    Response.Redirect(GlobalClass.GlobalVariables.urlSessionEnd)
                End If

                GlobalClass.GlobalVariables.urlSessionEnd = ""
            End If
        Else
            Session.Item("sessionLoginDenied") = "Maklumat Pengguna Tidak Sah. Sila Cuba Sekali Lagi"
            txtError.Text = Session.Item("sessionLoginDenied")
            'Response.Redirect("Default.aspx")
            txtError.Visible = True

            ScriptManager.RegisterStartupScript(
            Me,
            Me.GetType(),
            "ShowLoginModal",
            "showLoginModal();",
            True)

        End If

    End Sub

    Private Sub lbFP_Click(sender As Object, e As EventArgs) Handles lbFP.Click
        txtError.Visible = False

        ScriptManager.RegisterStartupScript(
            Me,
            Me.GetType(),
            "ShowLoginModal",
            "showLoginModal();",
            True)

        Dim btnEmailVerify As LinkButton = DirectCast(fvFP.FindControl("btnEmailVerify"), LinkButton)
        Dim btnEmailReset As LinkButton = DirectCast(fvFP.FindControl("btnEmailReset"), LinkButton)
        Dim lblCheckAcc As Label = DirectCast(fvFP.FindControl("lblCheckAcc"), Label)

        myForm.Visible = False
        myCheckAcc.Visible = True

        lblCheckAcc.Text = ""
        btnEmailReset.Visible = False
        btnEmailVerify.Visible = False
    End Sub

    Protected Sub btnCheckAcc_Click(sender As Object, e As EventArgs)
        '//start check account
        ScriptManager.RegisterStartupScript(
            Me,
            Me.GetType(),
            "ShowLoginModal",
            "showLoginModal();",
            True)

        Dim Users_IsVerified As Boolean = True
        Dim Users_IsActive As Boolean = False
        Dim Users_Email As TextBox = DirectCast(fvFP.FindControl("Users_Email"), TextBox)
        Dim btnEmailVerify As LinkButton = DirectCast(fvFP.FindControl("btnEmailVerify"), LinkButton)
        Dim btnEmailReset As LinkButton = DirectCast(fvFP.FindControl("btnEmailReset"), LinkButton)
        Dim btnCheckAcc As LinkButton = DirectCast(fvFP.FindControl("btnCheckAcc"), LinkButton)
        Dim lblCheckAcc As Label = DirectCast(fvFP.FindControl("lblCheckAcc"), Label)
        Dim hfRegID As HiddenField = DirectCast(fvFP.FindControl("hfRegID"), HiddenField)
        Dim RequiredFieldValidator5 As RequiredFieldValidator = DirectCast(fvFP.FindControl("RequiredFieldValidator5"), RequiredFieldValidator)
        Dim RegularExpressionValidator1 As RegularExpressionValidator = DirectCast(fvFP.FindControl("RegularExpressionValidator1"), RegularExpressionValidator)

        If RequiredFieldValidator5.IsValid And RegularExpressionValidator1.IsValid Then

            lblCheckAcc.Visible = True
            Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

                Dim sSQL As String = ""

                sSQL = "SELECT VW_TBL_USERS.*,TBL_USER_GROUPLIST.UGL_UGN_Id , TBL_USER_GROUPNAME.UGN_IsAdmin , isnull(Users_RegID,'') as Users_VerifiedStr
            from VW_TBL_USERS,TBL_USER_GROUPLIST, TBL_USER_GROUPNAME 
            where VW_TBL_USERS.Users_Id = TBL_USER_GROUPLIST.UGL_Users_Id and TBL_USER_GROUPNAME.UGN_Id=TBL_USER_GROUPLIST.UGL_UGN_Id 
            and VW_TBL_USERS.Users_Email=@Users_Email "


                Dim myCommand As New SqlCommand(sSQL, myConnection)
                myCommand.Parameters.AddWithValue("@Users_Email", Users_Email.Text)

                myConnection.Open()

                Dim myReader As SqlDataReader = myCommand.ExecuteReader

                If myReader.Read Then


                    Dim uid = myReader("Users_Id")
                    Dim Users_Enabled = myReader("Users_Enabled")
                    Dim Users_Register = myReader("Users_Register")
                    Dim Users_VerifiedStr = myReader("Users_VerifiedStr")
                    Dim Users_RegID = myReader("Users_RegID")

                    If CInt(Users_Enabled) = 1 And CInt(Users_Register) = 1 Then
                        '// user is active
                        Users_IsActive = True
                        btnCheckAcc.Visible = False
                        Users_Email.Visible = True

                        lblCheckAcc.Text = "Akaun anda masih aktif. Anda boleh reset katalaluan anda dengan menekan butang di bawah."
                        btnEmailReset.Visible = True
                        btnEmailVerify.Visible = False
                        hfRegID.Value = uid

                    ElseIf Users_VerifiedStr <> "" Then
                        '/user not verified yet
                        Users_IsVerified = False

                        lblCheckAcc.Text = "Akaun anda sedang menunggu pengesahan. Kami telah menghantar email ke alamat email berdaftar anda. Untuk menghantar semula pautan pengesahan email sila klik butang di bawah."
                        btnEmailReset.Visible = False
                        btnEmailVerify.Visible = True
                        hfRegID.Value = Users_VerifiedStr

                    Else
                        lblCheckAcc.Text = "Terdapat beberapa isu dengan akaun anda. Sila hubungi pihak kami untuk maklumat lanjut. Terima kasih."
                        btnEmailReset.Visible = False
                        btnEmailVerify.Visible = False
                        hfRegID.Value = ""

                    End If

                Else
                    lblCheckAcc.Text = "Akaun anda tidak ada dalam rekod kami. Sila hubungi pihak kami untuk maklumat lanjut. Terima kasih."
                    btnEmailReset.Visible = False
                    btnEmailVerify.Visible = False
                End If

                myReader.Close()
                myConnection.Close()




            End Using
        End If


    End Sub

    Protected Sub btnEmailVerify_Click(sender As Object, e As EventArgs)

        ScriptManager.RegisterStartupScript(
            Me,
            Me.GetType(),
            "ShowLoginModal",
            "showLoginModal();",
            True)

        Dim btnEmailVerify As LinkButton = DirectCast(fvFP.FindControl("btnEmailVerify"), LinkButton)
        Dim btnEmailReset As LinkButton = DirectCast(fvFP.FindControl("btnEmailReset"), LinkButton)
        Dim lblCheckAcc As Label = DirectCast(fvFP.FindControl("lblCheckAcc"), Label)
        Dim hfRegID As HiddenField = DirectCast(fvFP.FindControl("hfRegID"), HiddenField)

        If sendEmailVerification(hfRegID.Value) Then

            lblCheckAcc.Text = "Kami telah menghantar semula email baharu untuk pengesahan. Sila semak email anda."
            btnEmailReset.Visible = False
            btnEmailVerify.Visible = False

            'ScriptManager.RegisterClientScriptBlock(Me.Page, Me.[GetType](), "Go to top", "Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequestHandler);function EndRequestHandler(sender, args){scrollTo(0,0);}", True)
        Else
            txtError.Text = "Penghantaran email gagal. Sila cuba sekali lagi."
            btnEmailReset.Visible = False
            btnEmailVerify.Visible = True
        End If


    End Sub

    Private Function sendEmailVerification(Users_RegID As String) As Boolean
        Dim iPass As Boolean = False
        Dim Users_Email As String = ""
        Dim Users_Fullname As String = ""
        Dim Users_Id As Integer = 0

        'Dim SysURL As String = HttpUtility.UrlDecode(ConfigurationManager.AppSettings("SysURL").ToString())
        'Dim SysURL As String = HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority)
        Dim SysURL As String = HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + Request.ApplicationPath

        If Users_RegID <> "" Then



            Try

                Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

                    Dim sSQL As String = ""

                    sSQL = "SELECT *
                        from TBL_USERS 
                        where Users_RegID=@Users_RegID "


                    Dim myCommand As New SqlCommand(sSQL, myConnection)
                    myCommand.Parameters.AddWithValue("@Users_RegID", Users_RegID)

                    myConnection.Open()

                    Dim myReader As SqlDataReader = myCommand.ExecuteReader

                    If myReader.Read Then

                        Users_Id = myReader("Users_Id")
                        Users_Email = myReader("Users_Email")
                        Users_Fullname = myReader("Users_Fullname")


                    End If

                    myReader.Close()
                    myConnection.Close()




                End Using

                Dim delimiterChars As Char() = {","c, ";"c, ":"c}
                Dim mailto As String() = Users_Email.Split(delimiterChars)

                Dim MailSubject As String = ""

                MailSubject = "ProLesen Majlis Perbandaran Kluang: Pengesahan Email "

                Dim MailMessage As String = ""
                'MailMessage = "<table style='background-color:#ececec;'>
                '<tr>
                '<td style='width:100%;text-align:center;'>
                '<center style='width:100%;'>
                '<table cellspacing='2' cellpadding='20' border='0'>
                '<tr>
                '<td>"
                'MailMessage = MailMessage & "Dear " & Users_Fullname & ","
                'MailMessage = MailMessage & "<br/>"
                'MailMessage = MailMessage & "<br/>"

                'MailMessage = MailMessage & "You have successfully registered your account with us."
                'MailMessage = MailMessage & "<br/>"
                'MailMessage = MailMessage & "<br/>"
                'MailMessage = MailMessage & "To activate your login ID kindly please click this below link<br/><br/>"
                'MailMessage = MailMessage & "<a target='_blank' style='background-color: #ffffff;color: white;padding-left: 15px 25px;text-decoration: none;' href='" & SysURL & "/activate/" & Users_RegID & "'>ACTIVATE NOW</a>"
                'MailMessage = MailMessage & "<br/><br/>"
                'MailMessage = MailMessage & "<br/><br/>"
                'MailMessage = MailMessage & "*** This is an automatically generated email, please do not reply ***"
                'MailMessage = MailMessage & "</td> 

                '                </tr>
                '                </table>
                '                </center>
                '                </td>
                '                </tr>

                '                </table>"

                MailMessage = MailMessage & "<table role='presentation' style='width:100%;border-collapse:collapse;border:0;border-spacing:0;background:#ffffff;'>"
                MailMessage = MailMessage & "<tr>"
                MailMessage = MailMessage & "<td align='center' style='padding:0;'>"
                MailMessage = MailMessage & "<table role='presentation' style='width:602px;border-collapse:collapse;border:1px solid #cccccc;border-spacing:0;text-align:left;'>"
                MailMessage = MailMessage & "<tr>"
                MailMessage = MailMessage & "<td align='center' style='padding:40px 0 30px 0;background:#ffffff;'>"
                MailMessage = MailMessage & "<img src='http://1.9.135.164/prolesen/images/logo_mpk_new.png' alt='' width='300' style='height:auto;display:block;' />"
                MailMessage = MailMessage & "</td>"
                MailMessage = MailMessage & "</tr>"
                MailMessage = MailMessage & "<tr>"
                MailMessage = MailMessage & "<td style='padding:36px 30px 42px 30px;'>"
                MailMessage = MailMessage & "<table role='presentation' style='width:100%;border-collapse:collapse;border:0;border-spacing:0;'>"
                MailMessage = MailMessage & "<tr>"
                MailMessage = MailMessage & "<td style='padding:0 0 36px 0;color:#153643;'>"
                MailMessage = MailMessage & "<h1 style='font-size:24px;margin:0 0 20px 0;font-family:Arial,sans-serif;'>Pengesahan Email</h1>"
                MailMessage = MailMessage & "<p style='margin:0 0 12px 0;font-size:16px;line-height:24px;font-family:Arial,sans-serif;'>" & Users_Fullname & ","
                MailMessage = MailMessage & "<br/><br/>"
                'MailMessage = MailMessage & "Anda telah berjaya mendaftarkan akaun anda dengan kami."
                MailMessage = MailMessage & "Untuk mengaktifkan akaun anda, sila tekan link di bawah</p>"
                MailMessage = MailMessage & "<p style='margin:0;font-size:16px;line-height:24px;font-family:Arial,sans-serif;'><a target='_blank' style='background-color: #ffffff;color: #002680;padding-left: 15px 25px;text-decoration: none;' href='" & SysURL & "/ActivateNow/" & Users_RegID & "'>AKTIFKAN SEKARANG</a></p>"
                MailMessage = MailMessage & "</td>"
                MailMessage = MailMessage & "</tr>"
                MailMessage = MailMessage & "<tr>"
                MailMessage = MailMessage & "<td style='padding:0;'>"
                MailMessage = MailMessage & "</td>"
                MailMessage = MailMessage & "</tr>"
                MailMessage = MailMessage & "</table>"
                MailMessage = MailMessage & "</td>"
                MailMessage = MailMessage & "</tr>"
                MailMessage = MailMessage & "<tr>"
                MailMessage = MailMessage & "<td style='padding:30px;background:#ee4c50;'>"
                MailMessage = MailMessage & "<table role='presentation' style='width:100%;border-collapse:collapse;border:0;border-spacing:0;font-size:9px;font-family:Arial,sans-serif;'>"
                MailMessage = MailMessage & "<tr>"
                MailMessage = MailMessage & "<td style='padding:0;width:70%;' align='left'>"
                MailMessage = MailMessage & "<p style='margin:0;font-size:14px;line-height:16px;font-family:Arial,sans-serif;color:#ffffff;'>"
                MailMessage = MailMessage & "&reg; PROLESEN Majlis Perbandaran Kluang<br/>"
                MailMessage = MailMessage & "</p>"
                MailMessage = MailMessage & "</td>"
                MailMessage = MailMessage & "<td style='padding:0;width:30%;' align='right'>"
                MailMessage = MailMessage & "<table role='presentation' style='border-collapse:collapse;border:0;border-spacing:0;'>"
                MailMessage = MailMessage & "<tr>"
                MailMessage = MailMessage & "<td style='padding:0 0 0 10px;width:38px;'>"
                MailMessage = MailMessage & "</td>"
                MailMessage = MailMessage & "<td style='padding:0 0 0 10px;width:38px;'>"
                'MailMessage = MailMessage & "<a href='http://www.facebook.com/' style='color:#ffffff;'><img src='https://assets.codepen.io/210284/fb_1.png' alt='Facebook' width='38' style='height:auto;display:block;border:0;' /></a>"
                MailMessage = MailMessage & "</td>"
                MailMessage = MailMessage & "</tr>"
                MailMessage = MailMessage & "</table>"
                MailMessage = MailMessage & "</td>"
                MailMessage = MailMessage & "</tr>"
                MailMessage = MailMessage & "</table>"
                MailMessage = MailMessage & "</td>"
                MailMessage = MailMessage & "</tr>"
                MailMessage = MailMessage & "</table>"
                MailMessage = MailMessage & "</td>"
                MailMessage = MailMessage & "</tr>"
                MailMessage = MailMessage & "</table>"

                Dim emailMgr As EmailManager = New EmailManager()

                If emailMgr.SendMailNoAttach(mailto, MailSubject, MailMessage, New String(-1) {}) Then
                    'GlobalClass.auditTrail(Path.GetFileName(Request.Url.ToString()), "Confirmation link email sent for Users_Id: " & Users_Id.ToString & ". (" & Users_Email & ")", "Email")
                    iPass = True
                Else
                    'GlobalClass.auditTrail(Path.GetFileName(Request.Url.ToString()), "Confirmation link failed to send for Users_Id: " + Users_Id.ToString & ". (" & Users_Email & ")", "Email")
                End If

            Catch ex As Exception
                'txtError.Text = ex.Message
            End Try

        End If

        Return iPass
    End Function

    Protected Sub btnBackLogin_Click(sender As Object, e As EventArgs)

        ScriptManager.RegisterStartupScript(
            Me,
            Me.GetType(),
            "ShowLoginModal",
            "showLoginModal();",
            True)

        Dim btnEmailVerify As LinkButton = DirectCast(fvFP.FindControl("btnEmailVerify"), LinkButton)
        Dim btnEmailReset As LinkButton = DirectCast(fvFP.FindControl("btnEmailReset"), LinkButton)
        Dim lblCheckAcc As Label = DirectCast(fvFP.FindControl("lblCheckAcc"), Label)

        myForm.Visible = True
        myCheckAcc.Visible = False

        lblCheckAcc.Text = ""
        btnEmailReset.Visible = False
        btnEmailVerify.Visible = False

    End Sub

    Protected Sub btnEmailReset_Click(sender As Object, e As EventArgs)

        ScriptManager.RegisterStartupScript(
            Me,
            Me.GetType(),
            "ShowLoginModal",
            "showLoginModal();",
            True)

        Dim btnEmailVerify As LinkButton = DirectCast(fvFP.FindControl("btnEmailVerify"), LinkButton)
        Dim btnEmailReset As LinkButton = DirectCast(fvFP.FindControl("btnEmailReset"), LinkButton)
        Dim lblCheckAcc As Label = DirectCast(fvFP.FindControl("lblCheckAcc"), Label)
        Dim hfRegID As HiddenField = DirectCast(fvFP.FindControl("hfRegID"), HiddenField)

        updateIsResetProfile(CInt(hfRegID.Value))

        If sendEmailReset(CInt(hfRegID.Value)) Then

            lblCheckAcc.Text = "Kami telah menghantar semula email baharu untuk menetapkan semula kata laluan. Sila semak email anda."
            btnEmailReset.Visible = False
            btnEmailVerify.Visible = False

            'ScriptManager.RegisterClientScriptBlock(Me.Page, Me.[GetType](), "Go to top", "Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequestHandler);function EndRequestHandler(sender, args){scrollTo(0,0);}", True)
        Else
            lblCheckAcc.Text = "Penghantaran email gagal. Sila cuba sekali lagi. "
            btnEmailReset.Visible = False
            btnEmailVerify.Visible = True
        End If


    End Sub

    Private Function sendEmailReset(Users_ID As Integer) As Boolean
        Dim iPass As Boolean = False
        Dim Users_Email As String = ""
        Dim Users_Fullname As String = ""
        Dim Users_IsResetPass As String = ""

        'Dim SysURL As String = HttpUtility.UrlDecode(ConfigurationManager.AppSettings("SysURL").ToString())
        'Dim SysURL As String = HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority)
        Dim SysURL As String = HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + Request.ApplicationPath

        If CInt(Users_ID) > 0 Then


            Try

                Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

                    Dim sSQL As String = ""

                    sSQL = "SELECT *
                        from TBL_USERS 
                        where Users_ID=@Users_ID "


                    Dim myCommand As New SqlCommand(sSQL, myConnection)
                    myCommand.Parameters.AddWithValue("@Users_ID", Users_ID)

                    myConnection.Open()

                    Dim myReader As SqlDataReader = myCommand.ExecuteReader

                    If myReader.Read Then

                        Users_ID = myReader("Users_Id")
                        Users_Email = myReader("Users_Email")
                        Users_Fullname = myReader("Users_Fullname")
                        Users_IsResetPass = myReader("Users_IsResetPass")


                    End If

                    myReader.Close()
                    myConnection.Close()



                End Using

                Dim delimiterChars As Char() = {","c, ";"c, ":"c}
                Dim mailto As String() = Users_Email.Split(delimiterChars)

                Dim MailSubject As String = ""

                MailSubject = "PROLESEN - Majlis Perbandaran Kluang : Reset Katalaluan "

                Dim MailMessage As String = ""

                MailMessage = MailMessage & "<table role='presentation' style='width:100%;border-collapse:collapse;border:0;border-spacing:0;background:#ffffff;'>"
                MailMessage = MailMessage & "<tr>"
                MailMessage = MailMessage & "<td align='center' style='padding:0;'>"
                MailMessage = MailMessage & "<table role='presentation' style='width:602px;border-collapse:collapse;border:1px solid #cccccc;border-spacing:0;text-align:left;'>"
                MailMessage = MailMessage & "<tr>"
                MailMessage = MailMessage & "<td align='center' style='padding:40px 0 30px 0;background:#ffffff;'>"
                MailMessage = MailMessage & "<img src='http://1.9.135.164/prolesen/images/logo_mpk_new.png' alt='' width='300' style='height:auto;display:block;' />"
                MailMessage = MailMessage & "</td>"
                MailMessage = MailMessage & "</tr>"
                MailMessage = MailMessage & "<tr>"
                MailMessage = MailMessage & "<td style='padding:36px 30px 42px 30px;'>"
                MailMessage = MailMessage & "<table role='presentation' style='width:100%;border-collapse:collapse;border:0;border-spacing:0;'>"
                MailMessage = MailMessage & "<tr>"
                MailMessage = MailMessage & "<td style='padding:0 0 36px 0;color:#153643;'>"
                MailMessage = MailMessage & "<h1 style='font-size:24px;margin:0 0 20px 0;font-family:Arial,sans-serif;'>Reset Katalaluan</h1>"
                MailMessage = MailMessage & "<p style='margin:0 0 12px 0;font-size:16px;line-height:24px;font-family:Arial,sans-serif;'>" & Users_Fullname & ","
                MailMessage = MailMessage & "<br/><br/>"
                MailMessage = MailMessage & "Anda telah meminta untuk menetapkan semula kata laluan sedia ada anda. "
                MailMessage = MailMessage & "Untuk reset katalaluan akaun anda, sila tekan link di bawah</p>"
                MailMessage = MailMessage & "<p style='margin:0;font-size:16px;line-height:24px;font-family:Arial,sans-serif;'><a target='_blank' style='background-color: #ffffff;color: #002680;padding-left: 15px 25px;text-decoration: none;' href='" & SysURL & "/ResetPassword/" & Users_IsResetPass & "'>RESET KATALALUAN</a></p>"
                MailMessage = MailMessage & "</td>"
                MailMessage = MailMessage & "</tr>"
                MailMessage = MailMessage & "<tr>"
                MailMessage = MailMessage & "<td style='padding:0;'>"
                MailMessage = MailMessage & "</td>"
                MailMessage = MailMessage & "</tr>"
                MailMessage = MailMessage & "</table>"
                MailMessage = MailMessage & "</td>"
                MailMessage = MailMessage & "</tr>"
                MailMessage = MailMessage & "<tr>"
                MailMessage = MailMessage & "<td style='padding:30px;background:#ee4c50;'>"
                MailMessage = MailMessage & "<table role='presentation' style='width:100%;border-collapse:collapse;border:0;border-spacing:0;font-size:9px;font-family:Arial,sans-serif;'>"
                MailMessage = MailMessage & "<tr>"
                MailMessage = MailMessage & "<td style='padding:0;width:70%;' align='left'>"
                MailMessage = MailMessage & "<p style='margin:0;font-size:14px;line-height:16px;font-family:Arial,sans-serif;color:#ffffff;'>"
                MailMessage = MailMessage & "&reg; PROLESEN - Majlis Perbandaran Kluang<br/>"
                MailMessage = MailMessage & "</p>"
                MailMessage = MailMessage & "</td>"
                MailMessage = MailMessage & "<td style='padding:0;width:30%;' align='right'>"
                MailMessage = MailMessage & "<table role='presentation' style='border-collapse:collapse;border:0;border-spacing:0;'>"
                MailMessage = MailMessage & "<tr>"
                MailMessage = MailMessage & "<td style='padding:0 0 0 10px;width:38px;'>"
                MailMessage = MailMessage & "</td>"
                MailMessage = MailMessage & "<td style='padding:0 0 0 10px;width:38px;'>"
                MailMessage = MailMessage & "<a href='http://www.facebook.com/' style='color:#ffffff;'><img src='https://assets.codepen.io/210284/fb_1.png' alt='Facebook' width='38' style='height:auto;display:block;border:0;' /></a>"
                MailMessage = MailMessage & "</td>"
                MailMessage = MailMessage & "</tr>"
                MailMessage = MailMessage & "</table>"
                MailMessage = MailMessage & "</td>"
                MailMessage = MailMessage & "</tr>"
                MailMessage = MailMessage & "</table>"
                MailMessage = MailMessage & "</td>"
                MailMessage = MailMessage & "</tr>"
                MailMessage = MailMessage & "</table>"
                MailMessage = MailMessage & "</td>"
                MailMessage = MailMessage & "</tr>"
                MailMessage = MailMessage & "</table>"

                Dim emailMgr As EmailManager = New EmailManager()

                If emailMgr.SendMailNoAttach(mailto, MailSubject, MailMessage, New String(-1) {}) Then
                    'GlobalClass.auditTrail(Path.GetFileName(Request.Url.ToString()), "Confirmation link email sent for Users_Id: " & Users_Id.ToString & ". (" & Users_Email & ")", "Email")
                    iPass = True
                Else
                    'GlobalClass.auditTrail(Path.GetFileName(Request.Url.ToString()), "Confirmation link failed to send for Users_Id: " + Users_Id.ToString & ". (" & Users_Email & ")", "Email")
                End If

            Catch ex As Exception
                'txtError.Text = ex.Message
            End Try

        End If

        Return iPass
    End Function

    Private Sub updateIsResetProfile(uid As Integer)

        If uid > 0 Then

            Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
                '--# MAIN TABLE
                Dim SQL As String = "update TBL_USERS set Users_IsResetPass = @Users_IsResetPass where Users_Id = @UID;"

                Dim myCommand As New SqlCommand(SQL, myConnection)

                myCommand.Parameters.AddWithValue("@Users_IsResetPass", GetRandomUniqueChar())
                myCommand.Parameters.AddWithValue("@UID", uid)

                myConnection.Open()

                Dim recordset As Integer = myCommand.ExecuteNonQuery()

                If recordset Then


                End If

                myConnection.Close()

            End Using
        End If

    End Sub

    Private Function GetRandomUniqueChar() As String

        Dim random = New Random()
        Dim chars = (DateTime.Now.Ticks).ToString & "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz123456789" + (DateTime.Now.Ticks).ToString
        Return New String(Enumerable.Repeat(chars, 30).[Select](Function(s) s(random.[Next](s.Length))).ToArray())

    End Function
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

    'Protected Sub btnLoginHeader_Click(sender As Object, e As EventArgs)

    '    ScriptManager.RegisterStartupScript(Me,
    '    Me.GetType(),
    '    "showLoginModal",
    '    "var myModal = new bootstrap.Modal(document.getElementById('loginModal')); myModal.show();",
    '    True)

    'End Sub

End Class

