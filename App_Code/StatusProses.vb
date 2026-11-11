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

    Private Shared Function ToInt(ByVal value As Object) As Integer
        If value Is Nothing OrElse IsDBNull(value) Then Return 0
        Dim n As Integer
        If Integer.TryParse(value.ToString(), n) Then Return n
        Return 0
    End Function

End Class
