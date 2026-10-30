Imports System
Imports System.Drawing
Imports System.Drawing.Imaging
Imports System.IO
Imports System.Web.Hosting
Imports QRCoder

' Jana imej QR (PNG) dengan logo MPK di tengah.
' Tahap pembetulan ralat H (~30%) digunakan supaya QR masih boleh diimbas walaupun tengahnya dilitupi logo.
' Jika fail logo tiada, QR biasa (tanpa logo) dijana.
Public Class QrLogo

    Private Const LOGO_PATH As String = "~/images/logo_mpk_new.png"
    ' Biru tua tema ProLesen (#2E3192) - kontras tinggi dengan latar putih (~9:1), sesuai untuk diimbas
    Private Shared ReadOnly WARNA_QR As Color = ColorTranslator.FromHtml("#2E3192")

    Public Shared Function Png(ByVal isi As String, Optional ByVal pixelsPerModule As Integer = 20) As Byte()
        Using gen As New QRCodeGenerator()
            Dim data As QRCodeData = gen.CreateQrCode(isi, QRCodeGenerator.ECCLevel.H)

            Dim logoPath As String = HostingEnvironment.MapPath(LOGO_PATH)
            If Not String.IsNullOrEmpty(logoPath) AndAlso File.Exists(logoPath) Then
                Using logo As New Bitmap(logoPath)
                    Using qr As New QRCode(data)
                        ' logo ~28% lebar QR, dengan bingkai putih 6px supaya modul QR tidak bertindih
                        Using bmp As Bitmap = qr.GetGraphic(pixelsPerModule, WARNA_QR, Color.White, logo, 28, 6, True)
                            Using ms As New MemoryStream()
                                bmp.Save(ms, ImageFormat.Png)
                                Return ms.ToArray()
                            End Using
                        End Using
                    End Using
                End Using
            End If

            Using qr As New QRCode(data)
                Using bmp As Bitmap = qr.GetGraphic(pixelsPerModule, WARNA_QR, Color.White, True)
                    Using ms As New MemoryStream()
                        bmp.Save(ms, ImageFormat.Png)
                        Return ms.ToArray()
                    End Using
                End Using
            End Using
        End Using
    End Function

End Class
