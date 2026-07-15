Imports System.Data.SqlClient
Imports ActiveDirectoryLib
Imports DocumentFormat.OpenXml.Wordprocessing

Partial Class _Default
    Inherits Page

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

        'If txtUsername.ToLower <> "admin" Then
        'If Not GlobalClass.getWebconOveride().ToString.ToLower.Contains(txtUsername.ToLower) Then

        '    'If txtUsername.ToLower <> "admin" _
        '    'And txtUsername.ToLower <> "jaini@kulim.com.my" _
        '    'And txtUsername.ToLower <> "noorazah@kulim.com.my" _
        '    'And txtUsername.ToLower <> "harnizah@kulim.com.my" _
        '    'And txtUsername.ToLower <> "nursyazwani@kulim.com.my" _
        '    'And txtUsername.ToLower <> "deby@kulim.com.my" _
        '    'And txtUsername.ToLower <> "amalienna@kulim.com.my" _
        '    'And txtUsername.ToLower <> "mdsyuhada@kulim.com.my" Then

        '    Dim objAD As ADManager = New ADManager()
        '    If (objAD.ADLogin(txtUsername, paraPassword)) Then
        '        Dim objADLogin As ADLogin = New ADLogin()

        '        If Not (objADLogin.checkIsUserExists(txtUsername)) Then
        '            Session.Item("sessionLoginDenied") = "Failed to Login. Please try again..."
        '            txtError.Text = Session.Item("sessionLoginDenied")
        '            Response.Redirect("Default.aspx", True)
        '        End If
        '    Else
        '        Session.Item("sessionLoginDenied") = "Failed to Login. Please try again..."
        '        txtError.Text = Session.Item("sessionLoginDenied")
        '        Response.Redirect("Default.aspx", True)
        '    End If
        'End If

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            'Captcha1.ValidateCaptcha(txtCaptcha.Text.Trim())
            'If Captcha1.UserValidated Then
            'lblMessage.ForeColor = System.Drawing.Color.Green
            'lblMessage.Text = "Valid"

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

                Response.Redirect("Default.aspx")

            Else
                Session.Item("sessionSystemId") = GlobalClass.GlobalVariables.urlSessionSystemId
                If Session.Item("sessionSystemId") = "0" Or Session.Item("sessionSystemId") = "" Then
                    Response.Redirect("Default.aspx")
                Else
                    Response.Redirect(GlobalClass.GlobalVariables.urlSessionEnd)
                End If

                GlobalClass.GlobalVariables.urlSessionEnd = ""
            End If
        Else
            Session.Item("sessionLoginDenied") = "Maklumat Pengguna Tidak Sah. Sila Cuba Sekali Lagi"
            txtError.Text = Session.Item("sessionLoginDenied")
            Response.Redirect("Default.aspx")
        End If

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'checkDefaultPermission()

        If Request.Browser.IsMobileDevice Then
            divLogoBig.Visible = False
        Else
            divLogoBig.Visible = True
        End If

        'Session.Item("sessionSystemId") = 0
        If Session.Item("sessionLoginDenied") <> "" Then
            txtError.Text = Session.Item("sessionLoginDenied")
        End If

        '//set graph
        Try
            If CInt(Session.Item("sessionUsersId")) > 0 Then

                generateGraphBayaran()
                generateGraphPermohonanYearly()
                generatePieChart()

            End If
        Catch ex As Exception
            MsgBox(ex.Message)
        End Try

        '//dashboard
        Try
            If getAdminDashboard() Then
            Else

                idTopBox.Visible = False
                'idTrafictJenis.Visible = False
                'idJenisLesen.Visible = False
            End If
        Catch ex As Exception

        End Try



    End Sub

    Private Sub generatePieChart()

        Dim monthValue As String = "0,0,0,0,0,0,0,0,0,0,0,0"
        Dim totAmt As Decimal = 0.0
        Dim lblPie As String = ""
        Dim lblData As String = ""
        Dim lblColor As String = ""

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Dim SQL As String = ""
            SQL = "select JenisLesen_Description,totPerniagaan,case when totAllPerniagaan = 0 then 1 else totAllPerniagaan end as totAllPerniagaan
            from (select a.JenisLesen_Description,
            (select count(*) from LESEN_Permohonan x 
            where x.JenisLesen_ID = a.JenisLesen_ID /*and year(x.TarikhMohon) = year(getdate()) and month(x.TarikhMohon) = month(getdate())*/ and x.StatusID=10
            and iif(@AgensiID = 0 or @AgensiID = 1,0,@AgensiID) = iif(@AgensiID = 0 or @AgensiID = 1,0,(select top 1 x2.AgensiID from LESEN_ApprovalList x2 where x2.agensiID = @AgensiID and x2.Permohonan_ID = x.Permohonan_ID))
            ) as totPerniagaan,

            (select count(*) from LESEN_Permohonan x 
            where /*year(x.TarikhMohon) = year(getdate()) and month(x.TarikhMohon) = month(getdate()) and*/ x.StatusID=10
            and iif(@AgensiID = 0 or @AgensiID = 1,0,@AgensiID) = iif(@AgensiID = 0 or @AgensiID = 1,0,(select top 1 x2.AgensiID from LESEN_ApprovalList x2 where x2.agensiID = @AgensiID and x2.Permohonan_ID = x.Permohonan_ID)) 
            ) as totAllPerniagaan
            from LESEN_JenisLesen a
            where a.JenisLesen_IsActive=1 ) as tbl1 where totPerniagaan > 0"


            Dim myCommand As New SqlCommand(SQL, myConnection)
            myCommand.Parameters.AddWithValue("@AgensiID", Session.Item("sessionEstateID"))


            myConnection.Open()

            Dim myReader As SqlDataReader = myCommand.ExecuteReader

            Dim i As Integer = 0
            Dim random = New Random()

            While myReader.Read

                If i > 0 Then
                    lblPie = lblPie + ","
                    lblData = lblData + ","
                    lblColor = lblColor + ","
                End If


                Dim color = String.Format("#{0:X6}", random.[Next](&H1000000))

                lblPie = lblPie + "'" + myReader("JenisLesen_Description") + "'"
                lblData = lblData + myReader("totPerniagaan").ToString
                lblColor = lblColor + "'" + color + "'"

                'If i = 0 Then
                '    monthValue = myReader("totAmt")
                'Else
                '    monthValue = monthValue & "," & myReader("totAmt")
                'End If
                i += 1

                'lblCurrDate.Text = myReader("currDate")
                'totAmt += myReader("totAmt")
            End While


            myReader.Close()
            myConnection.Close()

        End Using
        'MsgBox(lblPie)

        Dim myScript As String = vbLf & "<script type=""text/javascript"" language=""Javascript"" id=""generatePieChart"">" & vbLf
        myScript += "      const doughnutChart = new Chart(document.getElementById('pieChart'), {
            type: 'doughnut',
            data: {
            labels: [" & lblPie & "],
            datasets: [{
            data: [" & lblData & "],
            backgroundColor: [" & lblColor & "],
            hoverBackgroundColor: [" & lblColor & "]
            }]
            },
            options: {
            responsive: true,
                plugins: {
                legend: {
                    display: true
                    },
                }
            }
            });"
        myScript += vbLf & vbLf & " </script>"

        'MsgBox(myScript)

        Page.ClientScript.RegisterStartupScript(Me.[GetType](), "myKeygeneratePieChart", myScript, False)

    End Sub

    Private Function getAdminDashboard() As Boolean
        Dim retval As Boolean = False

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Dim SQL As String = ""
            SQL = "select * from LESEN_JabatanAgensi where JabatanAgensi_IsLesen=1 
            and JabatanAgensi_IsActive=1 and JabatanAgensi_ID = @JabatanAgensi_ID"


            Dim myCommand As New SqlCommand(SQL, myConnection)
            myCommand.Parameters.AddWithValue("@JabatanAgensi_ID", Session.Item("sessionEstateID"))


            myConnection.Open()

            Dim myReader As SqlDataReader = myCommand.ExecuteReader

            Dim i As Integer = 0
            While myReader.Read
                'monthValueApprove = myReader("totCntApprove")
                retval = True

            End While

            myReader.Close()
            myConnection.Close()

        End Using

        If CInt(Session.Item("sessionisadmin")) = 1 Then
            retval = True
        End If

        Return retval
    End Function

    Private Sub generateGraphPermohonanYearly()

        Dim monthValueApprove As String = "0,0,0,0,0,0,0,0,0,0,0,0"
        Dim monthValueReject As String = "0,0,0,0,0,0,0,0,0,0,0,0"
        Dim totAmt As Decimal = 0.0

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Dim SQL As String = ""

            If getAdminDashboard() Then
                SQL = "select 
                (select count(*) from LESEN_Permohonan x where MONTH(x.TarikhMohon) = tblMonth.monthValue and YEAR(x.TarikhMohon) = YEAR(getdate()) and x.StatusID = 10) as totCntApprove,
                (select count(*) from LESEN_Permohonan x where MONTH(x.TarikhMohon) = tblMonth.monthValue and YEAR(x.TarikhMohon) = YEAR(getdate()) and x.StatusID = 9) as totCntReject
                ,* from (
                select 1 as monthValue union select 2 as monthValue union select 3 as monthValue union select 4 as monthValue 
                union select 5 as monthValue union select 6 as monthValue union select 7 as monthValue union select 8 as monthValue union select 9 as monthValue
                union select 10 as monthValue union select 11 as monthValue union select 12 as monthValue
                ) as tblMonth"
            Else
                SQL = "select 
                (select count(*) from LESEN_Permohonan x inner join (select top 1 * from LESEN_PermohonanAgensi x2 where x2.JabatanAgensi_ID = @JabatanAgensi_ID ) b on b.Permohonan_ID = x.Permohonan_ID where MONTH(x.TarikhMohon) = tblMonth.monthValue and YEAR(x.TarikhMohon) = YEAR(getdate()) and x.StatusID = 10) as totCntApprove,
                (select count(*) from LESEN_Permohonan x inner join (select top 1 * from LESEN_PermohonanAgensi x2 where x2.JabatanAgensi_ID = @JabatanAgensi_ID ) b on b.Permohonan_ID = x.Permohonan_ID where MONTH(x.TarikhMohon) = tblMonth.monthValue and YEAR(x.TarikhMohon) = YEAR(getdate()) and x.StatusID = 9) as totCntReject
                ,* from (
                select 1 as monthValue union select 2 as monthValue union select 3 as monthValue union select 4 as monthValue 
                union select 5 as monthValue union select 6 as monthValue union select 7 as monthValue union select 8 as monthValue union select 9 as monthValue
                union select 10 as monthValue union select 11 as monthValue union select 12 as monthValue
                ) as tblMonth"
            End If



            Dim myCommand As New SqlCommand(SQL, myConnection)
            myCommand.Parameters.AddWithValue("@JabatanAgensi_ID", Session.Item("sessionEstateID"))


            myConnection.Open()

            Dim myReader As SqlDataReader = myCommand.ExecuteReader

            Dim i As Integer = 0
            While myReader.Read

                If i = 0 Then
                    monthValueApprove = myReader("totCntApprove")
                    monthValueReject = myReader("totCntReject")
                Else
                    monthValueApprove = monthValueApprove & "," & myReader("totCntApprove")
                    monthValueReject = monthValueReject & "," & myReader("totCntReject")
                End If

                i += 1

                'lblCurrDate.Text = myReader("currDate")
                'totAmt += myReader("totAmt")
            End While

            'lblTotAmtGraph1.Text = totAmt.ToString("0.00")

            myReader.Close()
            myConnection.Close()

        End Using

        Dim myScript As String = vbLf & "<script type=""text/javascript"" language=""Javascript"" id=""generateGraphPermohonanYearly"">" & vbLf
        myScript += "const mainBarChart = new Chart(document.getElementById('main-bar-chart'), {
            type: 'bar',
            data: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                datasets: [
                    {
                        label: 'Lulus',
                        backgroundColor: coreui.Utils.getStyle('--cui-primary'),
                        borderRadius: 6,
                        borderSkipped: false,
                        data: [" & monthValueApprove & "],
                        barPercentage: 0.6,
                        categoryPercentage: 0.5,
                    },
                    {
                        label: 'Tidak Lulus',
                        backgroundColor: coreui.Utils.getStyle('--cui-gray-100'),
                        borderRadius: 6,
                        borderSkipped: false,
                        data: [" & monthValueReject & "],
                        barPercentage: 0.6,
                        categoryPercentage: 0.5,
                    },
                ],
            },
            options: {
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    x: { grid: { display: false, drawBorder: false, drawTicks: false }, ticks: { color: coreui.Utils.getStyle('--cui-text-disabled'), font: { size: 14 }, padding: 16 } },
                    y: {
                        grid: { drawBorder: false, borderDash: [2, 4] },
                        gridLines: { borderDash: [8, 4], color: '#348632' },
                        ticks: { beginAtZero: true, color: coreui.Utils.getStyle('--cui-text-disabled'), font: { size: 14 }, maxTicksLimit: 1000, padding: 16, stepSize: 1 },
                    },
                },
            },
        });"
        myScript += vbLf & vbLf & " </script>"
        Page.ClientScript.RegisterStartupScript(Me.[GetType](), "myKeygenerateGraphPermohonanYearly", myScript, False)

    End Sub

    Private Sub generateGraphBayaran()

        Dim monthValue As String = "0,0,0,0,0,0,0,0,0,0,0,0"
        Dim totAmt As Decimal = 0.0

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Dim SQL As String = ""
            SQL = "select isnull(sum(c.KadarBayaran_Amount),0) as totAmt,tblMonth.monthValue,CONVERT(char(10), GetDate(),126) as currDate from (
            select 1 as monthValue union select 2 as monthValue union select 3 as monthValue union select 4 as monthValue 
            union select 5 as monthValue union select 6 as monthValue union select 7 as monthValue union select 8 as monthValue union select 9 as monthValue
            union select 10 as monthValue union select 11 as monthValue union select 12 as monthValue
            ) as tblMonth
            left join LESEN_Permohonan b on MONTH(b.TarikhMohon) = tblMonth.monthValue and YEAR(b.TarikhMohon) = YEAR(getdate()) and b.StatusID = 10
            left join LESEN_KadarBayaran c on c.KadarBayaran_PermohonanID = b.Permohonan_ID
            group by tblMonth.monthValue"


            Dim myCommand As New SqlCommand(SQL, myConnection)
            ' myCommand.Parameters.AddWithValue("@txtUsername", txtUsername)


            myConnection.Open()

            Dim myReader As SqlDataReader = myCommand.ExecuteReader

            Dim i As Integer = 0
            While myReader.Read
                If i = 0 Then
                    monthValue = myReader("totAmt")
                Else
                    monthValue = monthValue & "," & myReader("totAmt")
                End If
                i += 1

                lblCurrDate.Text = myReader("currDate")
                totAmt += myReader("totAmt")
            End While

            lblTotAmtGraph1.Text = totAmt.ToString("0.00")

            myReader.Close()
            myConnection.Close()

        End Using

        Dim myScript As String = vbLf & "<script type=""text/javascript"" language=""Javascript"" id=""generateGraphBayaran"">" & vbLf
        myScript += "const cardChartNew1 = new Chart(document.getElementById('card-chart-new1'), {
            type: 'line',
            data: {
                labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
                datasets: [
                    {
                        label: 'Jumlah (RM) ',
                        backgroundColor: `rgba(${coreui.Utils.getStyle('--cui-primary-rgb')}, .1)`,
                        borderColor: coreui.Utils.getStyle('--cui-primary'),
                        borderWidth: 3, data: [" & monthValue & "],
                        fill: true
                    },
                ],
            },
            options: {
                plugins: { legend: { display: false } },
                maintainAspectRatio: false,
                scales: { x: { display: false }, y: { beginAtZero: true, display: false } },
                elements: { line: { borderWidth: 2, tension: 0.4 }, point: { radius: 0, hitRadius: 10, hoverRadius: 4 } },
            },
        });"
        myScript += vbLf & vbLf & " </script>"
        Page.ClientScript.RegisterStartupScript(Me.[GetType](), "myKeygenerateGraphBayaran", myScript, False)

    End Sub
	
    Private Sub lbFP_Click(sender As Object, e As EventArgs) Handles lbFP.Click
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

        Dim Users_IsVerified As Boolean = True
        Dim Users_IsActive As Boolean = False
        Dim Users_Email As TextBox = DirectCast(fvFP.FindControl("Users_Email"), TextBox)
        Dim btnEmailVerify As LinkButton = DirectCast(fvFP.FindControl("btnEmailVerify"), LinkButton)
        Dim btnEmailReset As LinkButton = DirectCast(fvFP.FindControl("btnEmailReset"), LinkButton)
        Dim btnCheckAcc As LinkButton = DirectCast(fvFP.FindControl("btnCheckAcc"), LinkButton)
        Dim lblCheckAcc As Label = DirectCast(fvFP.FindControl("lblCheckAcc"), Label)
        Dim hfRegID As HiddenField = DirectCast(fvFP.FindControl("hfRegID"), HiddenField)


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
                    Users_Email.Visible = False

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
    End Sub

    Protected Sub btnEmailVerify_Click(sender As Object, e As EventArgs)
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
            btnEmailVerify.Visible = False
        End If


    End Sub

    Protected Sub btnEmailReset_Click(sender As Object, e As EventArgs)
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
            txtError.Text = "Penghantaran email gagal. Sila cuba sekali lagi. "
            btnEmailReset.Visible = False
            btnEmailVerify.Visible = False
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
                txtError.Text = ex.Message
            End Try

        End If

        Return iPass
    End Function

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
                txtError.Text = ex.Message
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

End Class