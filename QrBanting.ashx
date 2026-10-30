<%@ WebHandler Language="VB" Class="QrBanting" %>

Imports System
Imports System.Web
Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Text.RegularExpressions
Imports QRCoder

' Jana imej QR untuk satu sepanduk/banting (LESEN_BantingImej.UniqueID).
' Awam (dipanggil dari modal Semakan Status) - hanya untuk permohonan yang telah lulus DAN dengan token sah daripada QrPin.ashx (No. Pin = BantingID) - &t=<token>.
'   QrBanting.ashx?id=BTG-20261006-6B37D9        -> papar PNG
'   QrBanting.ashx?id=BTG-20261006-6B37D9&dl=1   -> muat turun PNG
' Kandungan QR sama seperti appregister1.aspx (DisplayBantingQRModal).
Public Class QrBanting
    Implements IHttpHandler

    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim req As HttpRequest = context.Request
        Dim res As HttpResponse = context.Response

        Dim uniqueId As String = Convert.ToString(req.QueryString("id")).Trim()

        Dim permohonanId As Integer = If(uniqueId = "" OrElse uniqueId.Length > 50 OrElse Not Regex.IsMatch(uniqueId, "^[A-Za-z0-9\-]+$"), 0, CariPermohonanLulus(uniqueId))
        If permohonanId = 0 Then
            res.StatusCode = 404
            res.ContentType = "text/plain"
            res.Write("QR tidak dijumpai.")
            Return
        End If

        If Not QrAccess.ValidToken(permohonanId, Convert.ToString(req.QueryString("t"))) Then
            res.StatusCode = 403
            res.ContentType = "text/plain"
            res.Write("Sila masukkan No. Pin untuk mengakses kod QR.")
            Return
        End If

        Dim baseUrl As String = req.Url.Scheme & "://" & req.Url.Authority & req.ApplicationPath.TrimEnd("/"c)
        Dim fullUrl As String = baseUrl & "/lesen/sepandukSemakanIK.aspx?scancode=" & HttpUtility.UrlEncode(uniqueId)

        ' QR dengan logo MPK di tengah (App_Code/QrLogo.vb)
        Dim qrBytes As Byte() = QrLogo.Png(fullUrl, 20)

        res.ContentType = "image/png"
        res.Cache.SetCacheability(HttpCacheability.Private)
        res.Cache.SetMaxAge(TimeSpan.FromHours(1))
        If req.QueryString("dl") = "1" Then
            res.AddHeader("Content-Disposition", "attachment; filename=QR-" & uniqueId & ".png")
        End If
        res.BinaryWrite(qrBytes)
    End Sub

    Private Function CariPermohonanLulus(ByVal uniqueId As String) As Integer
        Dim sql As String = "SELECT TOP 1 p.Permohonan_ID FROM LESEN_BantingImej b " &
                            "INNER JOIN LESEN_Permohonan p ON p.Permohonan_ID = b.Permohonan_ID " &
                            "WHERE b.UniqueID = @UniqueID AND p.StatusID = 10 AND ISNULL(p.IsBatal, 0) = 0"
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@UniqueID", uniqueId)
                conn.Open()
                Dim o As Object = cmd.ExecuteScalar()
                If o Is Nothing OrElse IsDBNull(o) Then Return 0
                Return CInt(o)
            End Using
        End Using
    End Function

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return True
        End Get
    End Property

End Class
