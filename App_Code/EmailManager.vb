Imports Microsoft.VisualBasic
Imports System
Imports System.Net
Imports System.Net.Mail
Imports System.Configuration
Imports System.Data.SqlClient
Imports System.Data
Imports System.Threading

Public Class EmailManager
    Private _objSmtpClient As SmtpClient
    Private _ntwrkCredential As NetworkCredential
    'Private objCrypt As EncryptDecrypt.cTripleDES = New EncryptDecrypt.cTripleDES()

    Public Function SendMailNoAttach(ByVal mailTo As String(), ByVal subject As String, ByVal Msgbody As String, ByVal cc As String()) As Boolean
        Try
            Dim _smtpHost As String = ConfigurationManager.AppSettings("SmtpServer").ToString()
            Dim _smtpPort As Integer = Convert.ToInt32(ConfigurationManager.AppSettings("SmtpPort").ToString())
            Dim mailFrom As String = ConfigurationManager.AppSettings("SenderMailAdd").ToString()
            Dim msgSubject As String = subject
            'Dim msgBody As String = msgBody
            Dim enableSSL As Integer = Convert.ToInt32(ConfigurationManager.AppSettings("EnableSSL"))
            Dim setCredential As Integer = Convert.ToInt32(ConfigurationManager.AppSettings("SetCredential"))
            Dim userName As String = ConfigurationManager.AppSettings("Username").ToString()
            'Dim password As String = objCrypt.Decrypt(ConfigurationManager.AppSettings("Password").ToString())
            Dim password As String = ConfigurationManager.AppSettings("Password").ToString()
            Dim domain As String = ConfigurationManager.AppSettings("Domain").ToString()
            _objSmtpClient = New SmtpClient(_smtpHost, _smtpPort)
            _objSmtpClient.UseDefaultCredentials = False

            If setCredential = 1 Then

                If domain = "" Then
                    _ntwrkCredential = New NetworkCredential(userName, password)
                Else
                    _ntwrkCredential = New NetworkCredential(userName, password, domain)
                End If

                _objSmtpClient.Credentials = _ntwrkCredential
            End If

            If enableSSL = 1 Then _objSmtpClient.EnableSsl = True
            Dim msg As MailMessage = New MailMessage()
            Dim receiver As MailAddress = New MailAddress(mailFrom)

            For Each mail As String In mailTo
                msg.[To].Add(New MailAddress(mail))
            Next

            For Each mail As String In cc
                msg.CC.Add(mail)
            Next

            msg.From = receiver
            msg.Subject = msgSubject
            msg.Body = Msgbody
            msg.IsBodyHtml = True
            msg.Priority = MailPriority.Normal
            ServicePointManager.ServerCertificateValidationCallback = Function(ByVal s As Object, ByVal certificate As System.Security.Cryptography.X509Certificates.X509Certificate, ByVal chain As System.Security.Cryptography.X509Certificates.X509Chain, ByVal sslPolicyErrors As System.Net.Security.SslPolicyErrors) True

            '//using silent job
            Dim emailSent As New Thread(Sub() _objSmtpClient.Send(msg))
            emailSent.IsBackground = True
            emailSent.Start()

            '//using normal
            '_objSmtpClient.Send(msg)

            Return True
        Catch ex2 As SmtpException
            GlobalClass.auditTrail("EmailManager", "Send Email Failed: " + mailTo(0), "Email")
            Log.WriteLog(ex2, "EmailManager.cs", "SendMailNoAttach")
            Return False
        Catch Ex As Exception
            GlobalClass.auditTrail("EmailManager", "Send Email Failed: " + mailTo(0), "Email")
            Log.WriteLog(Ex, "EmailManager.cs", "SendMailNoAttach")
            Return False
        End Try
    End Function

    Public Function SendMailWithAttach(ByVal mailFrom As String, ByVal mailTo As String(), ByVal subject As String, ByVal Msgbody As String, ByVal cc As String(), ByVal attachFileName As String) As Boolean
        Try
            Dim _smtpHost As String = ConfigurationManager.AppSettings("SmtpServer").ToString()
            Dim _smtpPort As Integer = Convert.ToInt32(ConfigurationManager.AppSettings("SmtpPort").ToString())
            Dim enableSSL As Integer = Convert.ToInt32(ConfigurationManager.AppSettings("EnableSSL"))
            Dim setCredential As Integer = Convert.ToInt32(ConfigurationManager.AppSettings("SetCredential"))
            Dim userName As String = ConfigurationManager.AppSettings("Username").ToString()
            'Dim password As String = objCrypt.Decrypt(ConfigurationManager.AppSettings("Password").ToString())
            Dim password As String = ConfigurationManager.AppSettings("Password").ToString()
            Dim domain As String = ""
            Dim msgSubject As String = subject
            'Dim msgBody As String = msgBody
            _objSmtpClient = New SmtpClient(_smtpHost, _smtpPort)

            If setCredential = 1 Then
                _objSmtpClient.DeliveryMethod = SmtpDeliveryMethod.Network

                If domain = "" Then
                    _ntwrkCredential = New NetworkCredential(userName, password)
                Else
                    _ntwrkCredential = New NetworkCredential(userName, password, domain)
                End If

                _objSmtpClient.Credentials = _ntwrkCredential
            End If

            If enableSSL = 1 Then _objSmtpClient.EnableSsl = True
            Dim msg As MailMessage = New MailMessage()
            Dim sender As MailAddress = New MailAddress(mailFrom)

            For Each mail As String In mailTo
                msg.[To].Add(New MailAddress(mail))
            Next

            For Each mail As String In cc
                msg.CC.Add(mail)
            Next

            msg.From = sender
            msg.Subject = msgSubject
            msg.Body = Msgbody
            msg.IsBodyHtml = True
            msg.Priority = MailPriority.High
            If attachFileName IsNot Nothing Then msg.Attachments.Add(New Attachment(attachFileName))

            Dim emailSent As New Thread(Sub() _objSmtpClient.Send(msg))
            emailSent.IsBackground = True
            emailSent.Start()

            '_objSmtpClient.Send(msg)

            msg.Attachments.Dispose()
            Return True
        Catch Ex As Exception
            GlobalClass.auditTrail("EmailManager", "Send Email Failed: " + mailTo(0), "Email")
            Log.WriteLog(Ex, "EmailManager.cs", "SendMailNoAttach")
            Return False
        End Try
    End Function

    Public Function IsValidEmail(ByVal email As String) As Boolean
        Try
            Dim addr = New System.Net.Mail.MailAddress(email)
            Return addr.Address = email
        Catch
            Return False
        End Try
    End Function

    'Public Function EncryptPassword(ByVal sPassword As String) As String
    '    Return objCrypt.Encrypt(sPassword)
    'End Function

    'Public Function DecryptPassword(ByVal sHash As String) As String
    '    Return objCrypt.Decrypt(sHash)
    'End Function
End Class
