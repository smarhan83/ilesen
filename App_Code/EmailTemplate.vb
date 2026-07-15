Imports Microsoft.VisualBasic
Imports System
Imports System.Configuration
Imports System.Data.SqlClient
Imports System.Data
Imports System.IO

Public Class EmailTemplate
    Private SysURL As String = HttpUtility.UrlDecode(ConfigurationManager.AppSettings("SysURL").ToString())

#Region "Submit for approval"
    Public Function SendEmail_Submitter(ByVal SundryClaimID As Integer, ByVal EmailAddress As String, ByVal EmailFullName As String, ByVal UrlString As String) As Boolean
        Dim iPass As Boolean = False
        Dim objMain As DALSundryClaim = New DALSundryClaim()
        Dim ds As DataSet = New DataSet()

        Try
            Dim delimiterChars As Char() = {","c, ";"c, ":"c}
            Dim mailto As String() = EmailAddress.Split(delimiterChars)
            ds = objMain.LoadSundryClaim(SundryClaimID)
            Dim dr As DataRow = ds.Tables(0).Rows(0)
            Dim MailSubject As String = ""

            MailSubject = "TEST EMAIL!!!KULIM ePayment: " & dr("EmpName").ToString & " - " & " Submitted For Approval"

            Dim MailMessage As String = ""
            MailMessage = "Dear " & EmailFullName & ","
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"

            MailMessage = MailMessage & "Sundry Claim Application has been submitted by you."
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & GetSundryClaimInfo(dr)
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "Thank you,"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "Kindly login to our website at <a href='" & SysURL & "'>ePayment</a> for details of the application."
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "*** This is an automatically generated email, please do not reply ***"
            Dim emailMgr As EmailManager = New EmailManager()

            If emailMgr.SendMailNoAttach(mailto, MailSubject, MailMessage, New String(-1) {}) Then
                GlobalClass.auditTrail(Path.GetFileName(UrlString), "Submitter email sent for SundryClaimID: " & SundryClaimID.ToString & ". (" & EmailAddress & ")", "Email")
                iPass = True
            Else
                GlobalClass.auditTrail(Path.GetFileName(UrlString), "Submitter failed to send for SundryClaimID: " + SundryClaimID.ToString & ". (" & EmailAddress & ")", "Email")
            End If

        Catch ex As Exception
            Throw
        End Try

        Return iPass
    End Function

    Public Function SendEmail_Approver(ByVal SundryClaimID As Integer, ByVal EmailAddress As String, ByVal EmailFullName As String, ByVal UrlString As String) As Boolean
        Dim iPass As Boolean = False
        Dim objMain As DALSundryClaim = New DALSundryClaim()
        Dim ds As DataSet = New DataSet()

        Try
            Dim delimiterChars As Char() = {","c, ";"c, ":"c}
            Dim mailto As String() = EmailAddress.Split(delimiterChars)
            ds = objMain.LoadSundryClaim(SundryClaimID)
            Dim dr As DataRow = ds.Tables(0).Rows(0)
            Dim MailSubject As String = ""

            MailSubject = "KULIM ePayment: " & dr("EmpName").ToString & " - " & " Pending For Approval"

            Dim MailMessage As String = ""
            MailMessage = "Dear " & EmailFullName & ","
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"

            MailMessage = MailMessage & "Sundry Claim Application need your approval."
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & GetSundryClaimInfo(dr)
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "Thank you,"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "Kindly login to our website at <a href='" & SysURL & "'>ePayment</a> for details of the application."
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "*** This is an automatically generated email, please do not reply ***"
            Dim emailMgr As EmailManager = New EmailManager()

            If emailMgr.SendMailNoAttach(mailto, MailSubject, MailMessage, New String(-1) {}) Then
                GlobalClass.auditTrail(Path.GetFileName(UrlString), "Approval email sent for SundryClaimID: " & SundryClaimID.ToString & ". (" & EmailAddress & ")", "Email")
                iPass = True
            Else
                GlobalClass.auditTrail(Path.GetFileName(UrlString), "Approval failed to send for SundryClaimID: " + SundryClaimID.ToString & ". (" & EmailAddress & ")", "Email")
            End If

        Catch ex As Exception
            Throw
        End Try

        Return iPass
    End Function
#End Region

#Region "Approval"
    Public Function SendEmail_Approval_Submitter(ByVal SundryClaimApprID As Integer, ByVal EmailAddress As String, ByVal EmailFullName As String, ByVal UrlString As String) As Boolean
        Dim iPass As Boolean = False
        Dim objMain As DALSundryClaim = New DALSundryClaim()
        Dim ds As DataSet = New DataSet()
        Dim dsAppr As DataSet = New DataSet()

        Try
            Dim delimiterChars As Char() = {","c, ";"c, ":"c}
            Dim mailto As String() = EmailAddress.Split(delimiterChars)

            Dim SundryClaimID As Integer = objMain.getSundryClaimID(SundryClaimApprID)
            Dim IsFinalApproval As Boolean = objMain.getIsFinalApproval(SundryClaimApprID)
            ds = objMain.LoadSundryClaim(SundryClaimID)
            dsAppr = objMain.LoadApproval(SundryClaimApprID)
            Dim dr As DataRow = ds.Tables(0).Rows(0)
            Dim drAppr As DataRow = dsAppr.Tables(0).Rows(0)
            Dim MailSubject As String = ""
            Dim ApprovalStatus As String = drAppr("ApprovalStatusDesc").ToString

            If (IsFinalApproval) Then
                ApprovalStatus = ApprovalStatus & " (Final)"
            End If
            MailSubject = "KULIM ePayment: " & dr("EmpName").ToString & " - " & " has been " & ApprovalStatus

            Dim MailMessage As String = ""
            MailMessage = "Dear " & EmailFullName & ","
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"

            MailMessage = MailMessage & "Sundry Claim Application has been <b><u>" & ApprovalStatus & "</u></b>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & GetSundryClaimInfo(dr)
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "Approver : " & drAppr("ApproverEmpNo").ToString & " - " & drAppr("ApproverName").ToString & "<br>"
            MailMessage = MailMessage & "Approval Date : " & drAppr("ApprovalDate").ToString & "<br>"
            MailMessage = MailMessage & "Approver Level : " & drAppr("ApproverLevel").ToString & "<br>"
            MailMessage = MailMessage & "Status : <b>" & ApprovalStatus & "</b><br>"
            MailMessage = MailMessage & "Approver Remarks : " & drAppr("Remarks").ToString & "<br>"

            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "Thank you,"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "Kindly login to our website at <a href='" & SysURL & "'>ePayment</a> for details of the application."
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "*** This is an automatically generated email, please do not reply ***"
            Dim emailMgr As EmailManager = New EmailManager()

            If emailMgr.SendMailNoAttach(mailto, MailSubject, MailMessage, New String(-1) {}) Then
                GlobalClass.auditTrail(Path.GetFileName(UrlString), "Submitter email sent for SundryClaimID: " & SundryClaimID.ToString & ". (" & EmailAddress & ")", "Email")
                iPass = True
            Else
                GlobalClass.auditTrail(Path.GetFileName(UrlString), "Submitter failed to send for SundryClaimID: " + SundryClaimID.ToString & ". (" & EmailAddress & ")", "Email")
            End If

        Catch ex As Exception
            Throw
        End Try

        Return iPass
    End Function
#End Region

    Public Function GetSundryClaimInfo(ByVal dr As DataRow) As String
        'Dim objMain As DALSundryClaim = New DALSundryClaim()
        'Dim ds As DataSet = New DataSet()
        'ds = objMain.LoadSundryClaim(SundryClaimID)
        'Dim dr As DataRow = ds.Tables(0).Rows(0)
        Dim MailMessage As String = ""

        Try
            MailMessage = MailMessage & "Doc. No. : " & dr("DocNo").ToString & "<br>"
            MailMessage = MailMessage & "Submitter : " & dr("EmpNo").ToString & " - " & dr("EmpName").ToString & "<br>"
            MailMessage = MailMessage & "Date : " & dr("TransDate").ToString & "<br>"
            MailMessage = MailMessage & "Category : " & dr("BenefitCode").ToString & " - " & dr("SundryCategory").ToString & "<br>"
            MailMessage = MailMessage & "Expense Code : " & dr("AccDesc").ToString & "<br>"
            MailMessage = MailMessage & "Amount : " & dr("Amount").ToString & "<br>"
            MailMessage = MailMessage & "Remarks : " & dr("ClaimRemarks").ToString & "<br>"
        Catch Ex As Exception
            Throw
        End Try

        Return MailMessage
    End Function

    Public Function SendEmail_Helpdesk(ByVal ticketId As Integer, ByVal EmailAddress As String, ByVal EmailFullName As String, ByVal UrlString As String, ByVal IsAction As Boolean) As Boolean
        Dim iPass As Boolean = False
        Dim objMain As DALSundryClaim = New DALSundryClaim()
        Dim ds As DataSet = New DataSet()

        Try
            Dim delimiterChars As Char() = {","c, ";"c, ":"c}
            Dim mailto As String() = EmailAddress.Split(delimiterChars)
            ds = objMain.LoadTicketInfo(ticketId)
            Dim dr As DataRow = ds.Tables(0).Rows(0)
            Dim MailSubject As String = ""

            MailSubject = "KULIM Helpdesk: " & dr("Requestor").ToString & " - " & dr("titlesubject").ToString

            Dim MailMessage As String = ""
            MailMessage = "Dear " & EmailFullName & ","
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"

            MailMessage = MailMessage & "Kindly be informed that " & dr("Requestor").ToString & " has been create DSC ticket."
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "Description : "
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & " " & dr("description").ToString
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "Thank you,"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<div style='font-weight:bold; color : #002060; font-size:11pt;font-family: arial'>KULIM HELPDESK</div>"
            MailMessage = MailMessage & "<div style='color : black; font-size:10pt;font-family: arial'>Digital Division</div>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            If IsAction Then
                MailMessage = MailMessage & "Kindly login to our website at <a href='" & SysURL & "'>HelpDesk</a> for details of the application."
                MailMessage = MailMessage & "<br/>"
                MailMessage = MailMessage & "<br/>"
            End If
            MailMessage = MailMessage & "*** This is an automatically generated email, please do not reply ***"
            Dim emailMgr As EmailManager = New EmailManager()

            'MsgBox(MailMessage)

            If emailMgr.SendMailNoAttach(mailto, MailSubject, MailMessage, New String(-1) {}) Then
                'GlobalClass.auditTrail(Path.GetFileName(UrlString), "Approval email sent for SundryClaimID: " & SundryClaimID.ToString & ". (" & EmailAddress & ")", "Email")
                iPass = True
            Else
                'GlobalClass.auditTrail(Path.GetFileName(UrlString), "Approval failed to send for SundryClaimID: " + SundryClaimID.ToString & ". (" & EmailAddress & ")", "Email")
            End If

        Catch ex As Exception
            'MsgBox(ex.Message)
            Throw
        End Try

        Return iPass
    End Function

    Public Function SendEmail_HelpdeskAssign(ByVal ticketId As Integer, ByVal EmailAddress As String, ByVal EmailFullName As String, ByVal UrlString As String, ByVal IsAction As Boolean) As Boolean
        Dim iPass As Boolean = False
        Dim objMain As DALSundryClaim = New DALSundryClaim()
        Dim ds As DataSet = New DataSet()

        Try
            Dim delimiterChars As Char() = {","c, ";"c, ":"c}
            Dim mailto As String() = EmailAddress.Split(delimiterChars)
            ds = objMain.LoadTicketInfo(ticketId)
            Dim dr As DataRow = ds.Tables(0).Rows(0)
            Dim MailSubject As String = ""

            MailSubject = "KULIM Helpdesk: " & dr("Requestor").ToString & " - " & dr("titlesubject").ToString

            Dim MailMessage As String = ""
            MailMessage = "Dear " & EmailFullName & ","
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"

            MailMessage = MailMessage & "Kindly be informed that you have to assign DSC ticket no. " & dr("ticketNo").ToString & " to assist."
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "Description : "
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & " " & dr("description").ToString
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "Your cooperation is highly appreciated"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "Thank you,"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<div style='font-weight:bold; color : #002060; font-size:11pt;font-family: arial'>KULIM HELPDESK</div>"
            MailMessage = MailMessage & "<div style='color : black; font-size:10pt;font-family: arial'>Digital Division</div>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            If IsAction Then
                MailMessage = MailMessage & "Kindly login to our website at <a href='" & SysURL & "'>HelpDesk</a> for details of the application."
                MailMessage = MailMessage & "<br/>"
                MailMessage = MailMessage & "<br/>"
            End If
            MailMessage = MailMessage & "*** This is an automatically generated email, please do not reply ***"
            Dim emailMgr As EmailManager = New EmailManager()

            'MsgBox(MailMessage)

            If emailMgr.SendMailNoAttach(mailto, MailSubject, MailMessage, New String(-1) {}) Then
                'GlobalClass.auditTrail(Path.GetFileName(UrlString), "Approval email sent for SundryClaimID: " & SundryClaimID.ToString & ". (" & EmailAddress & ")", "Email")
                iPass = True
            Else
                'GlobalClass.auditTrail(Path.GetFileName(UrlString), "Approval failed to send for SundryClaimID: " + SundryClaimID.ToString & ". (" & EmailAddress & ")", "Email")
            End If

        Catch ex As Exception
            'MsgBox(ex.Message)
            Throw
        End Try

        Return iPass
    End Function

    Public Function SendEmail_HelpdeskClose(ByVal ticketId As Integer, ByVal EmailAddress As String, ByVal EmailFullName As String, ByVal UrlString As String, ByVal IsAction As Boolean) As Boolean
        Dim iPass As Boolean = False
        Dim objMain As DALSundryClaim = New DALSundryClaim()
        Dim ds As DataSet = New DataSet()

        Try
            Dim delimiterChars As Char() = {","c, ";"c, ":"c}
            Dim mailto As String() = EmailAddress.Split(delimiterChars)
            ds = objMain.LoadTicketInfo(ticketId)
            Dim dr As DataRow = ds.Tables(0).Rows(0)
            Dim MailSubject As String = ""

            MailSubject = "KULIM Helpdesk: " & dr("Requestor").ToString & " - " & dr("titlesubject").ToString

            Dim MailMessage As String = ""
            MailMessage = "Dear " & EmailFullName & ","
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"

            MailMessage = MailMessage & "Kindly be informed that your DSC ticket no. " & dr("ticketNo").ToString & " has been resolved.Please test and confirm or if you have any inquiry, please do not hesitate to contact us"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "If we do not receive a response within 3 days, we will consider this Issue as Closed"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "Thank you,"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<div style='font-weight:bold; color : #002060; font-size:11pt;font-family: arial'>KULIM HELPDESK</div>"
            MailMessage = MailMessage & "<div style='color : black; font-size:10pt;font-family: arial'>Digital Division</div>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            If IsAction Then
                MailMessage = MailMessage & "Kindly login to our website at <a href='" & SysURL & "'>HelpDesk</a> for details of the application."
                MailMessage = MailMessage & "<br/>"
                MailMessage = MailMessage & "<br/>"
            End If
            MailMessage = MailMessage & "*** This is an automatically generated email, please do not reply ***"
            Dim emailMgr As EmailManager = New EmailManager()

            'MsgBox(MailMessage)

            If emailMgr.SendMailNoAttach(mailto, MailSubject, MailMessage, New String(-1) {}) Then
                'GlobalClass.auditTrail(Path.GetFileName(UrlString), "Approval email sent for SundryClaimID: " & SundryClaimID.ToString & ". (" & EmailAddress & ")", "Email")
                iPass = True
            Else
                'GlobalClass.auditTrail(Path.GetFileName(UrlString), "Approval failed to send for SundryClaimID: " + SundryClaimID.ToString & ". (" & EmailAddress & ")", "Email")
            End If

        Catch ex As Exception
            'MsgBox(ex.Message)
            Throw
        End Try

        Return iPass
    End Function

    Public Function SendEmail_HelpdeskVerify(ByVal ticketId As Integer, ByVal EmailAddress As String, ByVal EmailFullName As String, ByVal UrlString As String, ByVal IsAction As Boolean) As Boolean
        Dim iPass As Boolean = False
        Dim objMain As DALSundryClaim = New DALSundryClaim()
        Dim ds As DataSet = New DataSet()

        Try
            Dim delimiterChars As Char() = {","c, ";"c, ":"c}
            Dim mailto As String() = EmailAddress.Split(delimiterChars)
            ds = objMain.LoadTicketInfo(ticketId)
            Dim dr As DataRow = ds.Tables(0).Rows(0)
            Dim MailSubject As String = ""

            MailSubject = "KULIM Helpdesk: " & dr("Requestor").ToString & " - " & dr("titlesubject").ToString

            Dim MailMessage As String = ""
            MailMessage = "Dear " & dr("Supervisor").ToString & ","
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"

            MailMessage = MailMessage & "Kindly be informed that you have to verify DSC ticket no. " & dr("ticketNo").ToString & " request from " & dr("Requestor").ToString & " to assist."
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "Description : "
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & " " & dr("description").ToString
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "Your cooperation is highly appreciated"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "Thank you,"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<div style='font-weight:bold; color : #002060; font-size:11pt;font-family: arial'>KULIM HELPDESK</div>"
            MailMessage = MailMessage & "<div style='color : black; font-size:10pt;font-family: arial'>Digital Division</div>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            If IsAction Then
                MailMessage = MailMessage & "Kindly login to our website at <a href='" & SysURL & "'>HelpDesk</a> for details of the application."
                MailMessage = MailMessage & "<br/>"
                MailMessage = MailMessage & "<br/>"
            End If
            MailMessage = MailMessage & "*** This is an automatically generated email, please do not reply ***"
            Dim emailMgr As EmailManager = New EmailManager()

            'MsgBox(MailMessage)

            If emailMgr.SendMailNoAttach(mailto, MailSubject, MailMessage, New String(-1) {}) Then
                'GlobalClass.auditTrail(Path.GetFileName(UrlString), "Approval email sent for SundryClaimID: " & SundryClaimID.ToString & ". (" & EmailAddress & ")", "Email")
                iPass = True
            Else
                'GlobalClass.auditTrail(Path.GetFileName(UrlString), "Approval failed to send for SundryClaimID: " + SundryClaimID.ToString & ". (" & EmailAddress & ")", "Email")
            End If

        Catch ex As Exception
            'MsgBox(ex.Message)
            Throw
        End Try

        Return iPass
    End Function

    Public Function SendEmail_HelpdeskInfo(ByVal ticketId As Integer, ByVal EmailAddress As String, ByVal EmailFullName As String, ByVal UrlString As String, ByVal IsAction As Boolean) As Boolean
        Dim iPass As Boolean = False
        Dim objMain As DALSundryClaim = New DALSundryClaim()
        Dim ds As DataSet = New DataSet()

        Try
            Dim delimiterChars As Char() = {","c, ";"c, ":"c}
            Dim mailto As String() = EmailAddress.Split(delimiterChars)
            ds = objMain.LoadTicketInfo(ticketId)
            Dim dr As DataRow = ds.Tables(0).Rows(0)
            Dim MailSubject As String = ""

            MailSubject = "KULIM Helpdesk: " & dr("Requestor").ToString & " - " & dr("titlesubject").ToString

            Dim MailMessage As String = ""
            MailMessage = "Dear " & dr("Requestor").ToString & ","
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"

            MailMessage = MailMessage & "Thank you for contacting our help desk. We have generated a ticket number for your request: " & dr("ticketNo").ToString & ". Our system admin has been notified and will begin working on it shortly."
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "If you have any further information or feedback related to your request, please don't hesitate to contact us."
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "Thank you,"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<div style='font-weight:bold; color : #002060; font-size:11pt;font-family: arial'>KULIM HELPDESK</div>"
            MailMessage = MailMessage & "<div style='color : black; font-size:10pt;font-family: arial'>Digital Division</div>"
            MailMessage = MailMessage & "<br/>"
            MailMessage = MailMessage & "<br/>"
            If IsAction Then
                MailMessage = MailMessage & "Kindly login to our website at <a href='" & SysURL & "'>HelpDesk</a> for details of the application."
                MailMessage = MailMessage & "<br/>"
                MailMessage = MailMessage & "<br/>"
            End If
            MailMessage = MailMessage & "*** This is an automatically generated email, please do not reply ***"
            Dim emailMgr As EmailManager = New EmailManager()

            'MsgBox(MailMessage)

            If emailMgr.SendMailNoAttach(mailto, MailSubject, MailMessage, New String(-1) {}) Then
                'GlobalClass.auditTrail(Path.GetFileName(UrlString), "Approval email sent for SundryClaimID: " & SundryClaimID.ToString & ". (" & EmailAddress & ")", "Email")
                iPass = True
            Else
                'GlobalClass.auditTrail(Path.GetFileName(UrlString), "Approval failed to send for SundryClaimID: " + SundryClaimID.ToString & ". (" & EmailAddress & ")", "Email")
            End If

        Catch ex As Exception
            'MsgBox(ex.Message)
            Throw
        End Try

        Return iPass
    End Function

End Class
