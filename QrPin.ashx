<%@ WebHandler Language="VB" Class="QrPin" %>

Imports System
Imports System.Web
Imports System.Web.SessionState
Imports System.Data.SqlClient
Imports System.Configuration

' Sahkan No. Pin (LESEN_Permohonan.BantingID) sebelum kod QR sepanduk/banting boleh dipaparkan / dimuat turun.
'   POST QrPin.ashx   id=<Permohonan_ID>  pin=<No. Pin>   -> JSON {"ok":true|false,"msg":"...","t":"<token>"}
' Kejayaan memulangkan token pendek (QrAccess.IssueToken, tamat dalam beberapa minit) untuk URL imej QR / cetak; tiada Session. Had percubaan: 5 kali gagal bagi setiap IP + permohonan -> sekat 15 minit.
Public Class QrPin
    Implements IHttpHandler

    Private Const MAX_GAGAL As Integer = 5
    Private Const SEKAT_MINIT As Integer = 15

    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim req As HttpRequest = context.Request
        Dim res As HttpResponse = context.Response
        res.ContentType = "application/json"
        res.Cache.SetCacheability(HttpCacheability.NoCache)

        If Not String.Equals(req.HttpMethod, "POST", StringComparison.OrdinalIgnoreCase) Then
            res.StatusCode = 405
            res.Write(Balas(False, "Kaedah tidak dibenarkan."))
            Return
        End If

        Dim id As Integer
        Dim pin As String = Convert.ToString(req.Form("pin")).Trim()
        If Not Integer.TryParse(Convert.ToString(req.Form("id")), id) OrElse id <= 0 OrElse pin = "" OrElse pin.Length > 50 Then
            res.Write(Balas(False, "Sila masukkan No. Pin."))
            Return
        End If

        Dim kunci As String = "qrpin:" & req.UserHostAddress & ":" & id
        Dim gagal As Integer = 0
        Dim cache As System.Web.Caching.Cache = HttpRuntime.Cache
        If cache(kunci) IsNot Nothing Then gagal = CInt(cache(kunci))
        If gagal >= MAX_GAGAL Then
            res.StatusCode = 429
            res.Write(Balas(False, "Terlalu banyak percubaan. Sila cuba lagi selepas " & SEKAT_MINIT & " minit."))
            Return
        End If

        Dim pinSebenar As String = AmbilPin(id)
        If pinSebenar <> "" AndAlso String.Equals(pinSebenar, pin, StringComparison.OrdinalIgnoreCase) Then
            cache.Remove(kunci)
            res.Write(Balas(True, "", QrAccess.IssueToken(id)))
        Else
            cache.Insert(kunci, gagal + 1, Nothing, DateTime.UtcNow.AddMinutes(SEKAT_MINIT), System.Web.Caching.Cache.NoSlidingExpiration)
            res.Write(Balas(False, "No. Pin tidak sah."))
        End If
    End Sub

    ' Pulangkan BantingID bagi permohonan sepanduk/banting yang telah lulus & ada kod QR; kosong jika tidak layak / tiada pin
    Private Function AmbilPin(ByVal id As Integer) As String
        Dim sql As String = "SELECT p.BantingID FROM LESEN_Permohonan p " &
                            "WHERE p.Permohonan_ID = @ID AND p.StatusID = 10 AND ISNULL(p.IsBatal, 0) = 0 " &
                            "AND EXISTS (SELECT 1 FROM LESEN_BantingImej b WHERE b.Permohonan_ID = p.Permohonan_ID)"
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@ID", id)
                conn.Open()
                Dim o As Object = cmd.ExecuteScalar()
                If o Is Nothing OrElse IsDBNull(o) Then Return ""
                Return Convert.ToString(o).Trim()
            End Using
        End Using
    End Function

    Private Function Balas(ByVal ok As Boolean, ByVal msg As String, Optional ByVal token As String = "") As String
        Return "{""ok"":" & If(ok, "true", "false") & ",""msg"":""" & msg.Replace("\", "\\").Replace("""", "\""") & """,""t"":""" & token & """}"
    End Function

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class
