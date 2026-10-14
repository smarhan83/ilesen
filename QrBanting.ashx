<%@ WebHandler Language="VB" Class="QrBanting" %>

Imports System
Imports System.Web
Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Text.RegularExpressions
Imports QRCoder

' Jana imej QR untuk satu sepanduk/banting (LESEN_BantingImej.UniqueID).
' Awam (dipanggil dari modal Semakan Status) - hanya untuk permohonan yang telah lulus.
'   QrBanting.ashx?id=BTG-20261006-6B37D9        -> papar PNG
'   QrBanting.ashx?id=BTG-20261006-6B37D9&dl=1   -> muat turun PNG
' Kandungan QR sama seperti appregister1.aspx (DisplayBantingQRModal).
Public Class QrBanting
    Implements IHttpHandler

    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim req As HttpRequest = context.Request
        Dim res As HttpResponse = context.Response

        Dim uniqueId As String = Convert.ToString(req.QueryString("id")).Trim()

        If uniqueId = "" OrElse uniqueId.Length > 50 OrElse Not Regex.IsMatch(uniqueId, "^[A-Za-z0-9\-]+$") OrElse Not IsBantingLulus(uniqueId) Then
            res.StatusCode = 404
            res.ContentType = "text/plain"
            res.Write("QR tidak dijumpai.")
            Return
        End If

        Dim baseUrl As String = req.Url.Scheme & "://" & req.Url.Authority & req.ApplicationPath.TrimEnd("/"c)
        Dim fullUrl As String = baseUrl & "/lesen/sepandukSemakanIK.aspx?scancode=" & HttpUtility.UrlEncode(uniqueId)

        Dim qrBytes As Byte()
        Using qrGenerator As New QRCodeGenerator()
            Dim qrCodeData As QRCodeData = qrGenerator.CreateQrCode(fullUrl, QRCodeGenerator.ECCLevel.Q)
            Using qrCode As New PngByteQRCode(qrCodeData)
                qrBytes = qrCode.GetGraphic(20)
            End Using
        End Using

        res.ContentType = "image/png"
        res.Cache.SetCacheability(HttpCacheability.Private)
        res.Cache.SetMaxAge(TimeSpan.FromHours(1))
        If req.QueryString("dl") = "1" Then
            res.AddHeader("Content-Disposition", "attachment; filename=QR-" & uniqueId & ".png")
        End If
        res.BinaryWrite(qrBytes)
    End Sub

    Private Function IsBantingLulus(ByVal uniqueId As String) As Boolean
        Dim sql As String = "SELECT COUNT(*) FROM LESEN_BantingImej b " &
                            "INNER JOIN LESEN_Permohonan p ON p.Permohonan_ID = b.Permohonan_ID " &
                            "WHERE b.UniqueID = @UniqueID AND p.StatusID = 10 AND ISNULL(p.IsBatal, 0) = 0"
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@UniqueID", uniqueId)
                conn.Open()
                Return CInt(cmd.ExecuteScalar()) > 0
            End Using
        End Using
    End Function

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return True
        End Get
    End Property

End Class
