Imports Microsoft.VisualBasic

''' <summary>
''' Ikon bagi setiap langkah dalam timeline "Status Proses"
''' (kelulusan, kelulusan1, pembatalan, pembatalan1, appregister1).
''' Setiap langkah ada ikon sendiri; langkah selesai berwarna hijau dengan tanda selesai kecil.
''' </summary>
Public Class StatusProses

    ''' <summary>Kelas Bootstrap Icons bagi satu langkah (StepGroup dari query timeline).</summary>
    Public Shared Function StepIconClass(ByVal stepGroup As Object, ByVal apprStatusID As Object) As String
        Dim grp As Integer = ToInt(stepGroup)
        Dim appr As Integer = ToInt(apprStatusID)

        Select Case grp
            Case 0 : Return "bi-pencil-square"          ' Draf
            Case 1 : Return "bi-file-earmark-plus"      ' Permohonan Baru
            Case 2 : Return "bi-person-check"           ' Pilih Pegawai Lawatan Tapak
            Case 3 : Return "bi-geo-alt"                ' Lawatan Tapak
            Case 4 : Return "bi-building-check"         ' Pengesah Jabatan/Agensi (KB)
            Case 5 : Return "bi-clipboard-check"        ' Pengesah Jabatan Lesen
            Case 6                                      ' Pengesah Sokong / Tidak Sokong
                If appr = 6 Then Return "bi-hand-thumbs-down"
                If appr = 7 Then Return "bi-hand-thumbs-up"
                Return "bi-hourglass-split"
            Case 7 : Return "bi-pen"                    ' Peraku Jabatan Lesen
            Case 8                                      ' Kelulusan: Lulus / Tidak Sokong
                If appr = 9 Then Return "bi-x-octagon"
                Return "bi-award"
            Case Else : Return "bi-circle"
        End Select
    End Function

    ''' <summary>HTML di dalam .status-step-icon: ikon langkah, dan tanda selesai kecil jika langkah telah selesai.</summary>
    Public Shared Function StepIcon(ByVal stepGroup As Object, ByVal apprStatusID As Object, ByVal stepStatus As Object) As String
        Dim status As String = If(stepStatus Is Nothing OrElse IsDBNull(stepStatus), "", stepStatus.ToString())
        Dim iconClass As String = StepIconClass(stepGroup, apprStatusID)

        Select Case status
            Case "done"
                Return "<i class=""bi " & iconClass & """ style=""font-size:12px;line-height:1;""></i>" &
                       "<span style=""position:absolute;right:-5px;bottom:-5px;width:14px;height:14px;border-radius:50%;" &
                       "background:#fff;border:1.5px solid #28a745;color:#28a745;display:flex;align-items:center;" &
                       "justify-content:center;box-sizing:border-box;"" title=""Selesai"">" &
                       "<i class=""bi bi-check-lg"" style=""font-size:9px;line-height:1;""></i></span>"
            Case "current"
                Return "<i class=""bi " & iconClass & """ style=""font-size:12px;line-height:1;""></i>"
            Case Else   ' pending
                Return "<i class=""bi " & iconClass & """ style=""font-size:11px;line-height:1;color:#adb5bd;""></i>"
        End Select
    End Function

    ''' <summary>
    ''' Kotak ulasan di bawah langkah timeline (ulasan KB Agensi, Pengesah Jabatan Lesen, Peraku dan keputusan KJ).
    ''' Lajur Nota / NotaKJ datang dari query timeline; kosong = tiada apa dipaparkan.
    ''' </summary>
    Public Shared Function NotaHtml(ByVal nota As Object, ByVal notaKJ As Object) As String
        Dim teks As String = If(nota Is Nothing OrElse IsDBNull(nota), "", nota.ToString().Trim())
        Dim kj As String = If(notaKJ Is Nothing OrElse IsDBNull(notaKJ), "", notaKJ.ToString().Trim())
        If teks = "" AndAlso kj = "" Then Return ""

        Dim sb As New System.Text.StringBuilder()
        sb.Append("<div class=""status-step-nota"" style=""margin-top:6px;max-width:620px;background:#fffbeb;border:1px solid #fde68a;" &
                  "border-left:3px solid #f59e0b;border-radius:6px;padding:7px 10px;"">")
        If kj <> "" Then
            sb.Append("<div style=""display:inline-flex;align-items:center;gap:5px;font-size:7.5pt;font-weight:700;color:#92400e;" &
                      "background:#fef3c7;border-radius:999px;padding:2px 8px;margin-bottom:5px;"">" &
                      "<i class=""bi bi-flag-fill"" style=""font-size:7pt;""></i>Keputusan: ")
            sb.Append(System.Web.HttpUtility.HtmlEncode(kj))
            sb.Append("</div>")
        End If
        If teks <> "" Then
            sb.Append("<div style=""font-size:7pt;font-weight:700;text-transform:uppercase;letter-spacing:.05em;color:#b45309;margin-bottom:2px;"">" &
                      "<i class=""bi bi-chat-left-quote"" style=""margin-right:4px;""></i>Ulasan</div>")
            sb.Append("<div style=""font-size:8.5pt;color:#374151;white-space:pre-wrap;word-break:break-word;line-height:1.45;"">")
            sb.Append(System.Web.HttpUtility.HtmlEncode(teks))
            sb.Append("</div>")
        End If
        sb.Append("</div>")
        Return sb.ToString()
    End Function

    Private Shared Function ToInt(ByVal value As Object) As Integer
        If value Is Nothing OrElse IsDBNull(value) Then Return 0
        Dim n As Integer
        If Integer.TryParse(value.ToString(), n) Then Return n
        Return 0
    End Function

End Class
