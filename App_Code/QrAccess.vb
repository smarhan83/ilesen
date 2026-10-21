Imports System
Imports System.Text
Imports System.Web
Imports System.Web.Security

' Akses kod QR sepanduk/banting untuk pengguna awam (modal Semakan Status).
' Setiap kali pengguna membuka panel QR, No. Pin (LESEN_Permohonan.BantingID) mesti dimasukkan (QrPin.ashx).
' Kejayaan menghasilkan token pendek (disulitkan dengan MachineKey, terikat pada Permohonan_ID, tamat dalam beberapa minit)
' yang disertakan pada URL imej QR / cetak. TIADA Session digunakan - token tidak boleh dipalsukan atau digunakan untuk permohonan lain.
Public Class QrAccess

    Private Const PURPOSE As String = "ProLesen.QrAkses.v1"
    Public Const MINIT_SAH As Integer = 5

    Public Shared Function IssueToken(ByVal permohonanId As Integer) As String
        Dim tamat As Long = DateTime.UtcNow.AddMinutes(MINIT_SAH).Ticks
        Dim data As Byte() = Encoding.UTF8.GetBytes(permohonanId.ToString() & "|" & tamat.ToString())
        Dim terlindung As Byte() = MachineKey.Protect(data, PURPOSE)
        Return HttpServerUtility.UrlTokenEncode(terlindung)
    End Function

    Public Shared Function ValidToken(ByVal permohonanId As Integer, ByVal token As String) As Boolean
        If String.IsNullOrWhiteSpace(token) OrElse token.Length > 600 Then Return False
        Try
            Dim terlindung As Byte() = HttpServerUtility.UrlTokenDecode(token)
            If terlindung Is Nothing Then Return False
            Dim data As Byte() = MachineKey.Unprotect(terlindung, PURPOSE)
            If data Is Nothing Then Return False
            Dim bahagian As String() = Encoding.UTF8.GetString(data).Split("|"c)
            If bahagian.Length <> 2 Then Return False
            Dim id As Integer, tamat As Long
            If Not Integer.TryParse(bahagian(0), id) OrElse Not Long.TryParse(bahagian(1), tamat) Then Return False
            Return id = permohonanId AndAlso DateTime.UtcNow.Ticks <= tamat
        Catch
            Return False
        End Try
    End Function

End Class
