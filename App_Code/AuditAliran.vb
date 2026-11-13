Imports System.Data.SqlClient
Imports System.Linq
Imports Microsoft.VisualBasic

''' <summary>
''' Audit aliran kerja permohonan lesen (baru dan pembatalan).
''' Setiap tindakan direkod dalam TBL_AUDITTRAIL dengan:
'''   AT_Ref    = No. Rujukan permohonan
'''   AT_Detail = "Status: [lama] -> [baru]" serta catatan (cth. Sokong / Tidak Sokong, nota)
''' Corak guna:
'''   Dim lama As String = AuditAliran.Status(pid, agensiId, batal)   ' sebelum tindakan
'''   ... tindakan ...
'''   AuditAliran.Log("Kelulusan", AuditAliran.HANTAR_ULASAN, pid, agensiId, batal, lama, "catatan")
''' </summary>
Public Class AuditAliran

    ' Nama tindakan aliran kerja (TBL_AUDITTRAIL.AT_Action)
    Public Const HANTAR_PERMOHONAN As String = "Hantar Permohonan"
    Public Const HANTAR_SEMAKAN_SURAT As String = "Hantar Semakan Surat"
    Public Const TETAPKAN_PEGAWAI As String = "Tetapkan Pegawai"
    Public Const HANTAR_ULASAN As String = "Hantar Ulasan"
    Public Const PENGESAHAN_ULASAN As String = "Pengesahan Ulasan"
    Public Const SOKONG As String = "Sokong"
    Public Const TIDAK_SOKONG As String = "Tidak Sokong"
    Public Const LULUS As String = "Lulus"
    Public Const TOLAK As String = "Tolak"
    Public Const KEMBALI_IK As String = "Kembali ke IK"
    Public Const TERBIT_SURAT As String = "Terbit Surat"
    Public Const TARIK_SURAT As String = "Tarik Balik Surat"
    Public Const KEPUTUSAN_MESYUARAT As String = "Keputusan Mesyuarat"

    Private Shared ReadOnly Property ConnStr As String
        Get
            Return ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString
        End Get
    End Property

    ''' <summary>
    ''' Status semasa permohonan. Jika agensiId &gt; 0, status langkah agensi tersebut (jika masih belum selesai);
    ''' jika tidak, status keseluruhan permohonan (LESEN_Permohonan.StatusID).
    ''' </summary>
    Public Shared Function Status(ByVal permohonanId As Integer, ByVal agensiId As Integer, ByVal batal As Boolean) As String
        Dim sfx As String = If(batal, "Batal", "")
        Dim sql As String =
            "DECLARE @s nvarchar(200); " &
            "IF @Agensi > 0 " &
            "  SELECT TOP 1 @s = Description FROM v_LESEN_ApprovalList" & sfx & "_Curr " &
            "  WHERE Permohonan_ID = @Pid AND AgensiID = @Agensi ORDER BY ApprStatusID; " &
            "IF @s IS NULL " &
            "  SELECT @s = ISNULL(s.Description, CAST(p.StatusID AS nvarchar(10))) FROM LESEN_Permohonan p " &
            "  LEFT JOIN ApprovalStatus" & sfx & " s ON s.ApprStatusID = p.StatusID WHERE p.Permohonan_ID = @Pid; " &
            "SELECT ISNULL(@s, '-');"
        Try
            Using conn As New SqlConnection(ConnStr)
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@Pid", permohonanId)
                    cmd.Parameters.AddWithValue("@Agensi", agensiId)
                    conn.Open()
                    Return Convert.ToString(cmd.ExecuteScalar())
                End Using
            End Using
        Catch ex As Exception
            Return "-"
        End Try
    End Function

    ''' <summary>No. Rujukan permohonan (atau "ID [n]" jika tiada).</summary>
    Public Shared Function Rujukan(ByVal permohonanId As Integer) As String
        Try
            Using conn As New SqlConnection(ConnStr)
                Using cmd As New SqlCommand("SELECT ISNULL(NULLIF(LTRIM(RTRIM(Rujukan)), ''), '') FROM LESEN_Permohonan WHERE Permohonan_ID = @Pid", conn)
                    cmd.Parameters.AddWithValue("@Pid", permohonanId)
                    conn.Open()
                    Dim r As String = Convert.ToString(cmd.ExecuteScalar())
                    If r <> "" Then Return r
                End Using
            End Using
        Catch ex As Exception
        End Try
        Return "ID " & permohonanId
    End Function

    ''' <summary>
    ''' Rekod satu tindakan aliran kerja. Status baru dibaca selepas tindakan (termasuk perubahan oleh trigger).
    ''' </summary>
    Public Shared Sub Log(ByVal modul As String, ByVal tindakan As String, ByVal permohonanId As Integer,
                          ByVal agensiId As Integer, ByVal batal As Boolean, ByVal statusLama As String,
                          Optional ByVal catatan As String = "")
        Try
            Dim ruj As String = Rujukan(permohonanId)
            Dim baru As String = Status(permohonanId, agensiId, batal)
            Dim jenis As String = If(batal, "Pembatalan", "Permohonan Baru")
            Dim detail As String = jenis & " | Status: " & If(statusLama, "-") & " -> " & baru
            If Not String.IsNullOrWhiteSpace(catatan) Then detail &= " | " & catatan.Trim()
            GlobalClass.auditTrail(modul, tindakan & " - " & ruj, tindakan, ruj, detail)
        Catch ex As Exception
            ' log tidak boleh mengganggu tindakan pengguna
        End Try
    End Sub

    ''' <summary>
    ''' Rekod "Hantar Semakan Surat" bagi satu baris LESEN_PermohonanAgensi[Batal]
    ''' (surat mohon ulasan dihantar kepada KB / KJ untuk semakan).
    ''' </summary>
    Public Shared Sub LogSemakanSurat(ByVal modul As String, ByVal permohonanAgensiId As String, ByVal batal As Boolean)
        Try
            Dim sfx As String = If(batal, "Batal", "")
            Dim pid As Integer = 0
            Dim agensiId As Integer = 0
            Dim agensi As String = ""
            Using conn As New SqlConnection(ConnStr)
                Using cmd As New SqlCommand("SELECT pa.Permohonan_ID, ISNULL(pa.JabatanAgensi_ID, 0) AS JabatanAgensi_ID, ISNULL(j.JabatanAgensi_Description, '') AS Agensi " &
                                            "FROM LESEN_PermohonanAgensi" & sfx & " pa LEFT JOIN LESEN_JabatanAgensi j ON j.JabatanAgensi_ID = pa.JabatanAgensi_ID " &
                                            "WHERE pa.PermohonanAgensi_ID = @Id", conn)
                    cmd.Parameters.AddWithValue("@Id", permohonanAgensiId)
                    conn.Open()
                    Using rdr As SqlDataReader = cmd.ExecuteReader()
                        If Not rdr.Read() Then Return
                        pid = Convert.ToInt32(rdr("Permohonan_ID"))
                        agensiId = Convert.ToInt32(rdr("JabatanAgensi_ID"))
                        agensi = Convert.ToString(rdr("Agensi"))
                    End Using
                End Using
            End Using
            Dim lama As String = Status(pid, agensiId, batal)
            Log(modul, HANTAR_SEMAKAN_SURAT, pid, agensiId, batal, lama, If(agensi = "", "", "Agensi: " & agensi))
        Catch ex As Exception
        End Try
    End Sub

    '----- Perubahan maklumat (beza nilai sebelum / selepas) -----
    Public Const KEMASKINI_MAKLUMAT As String = "Kemaskini Maklumat"

    ' Kolum sistem yang tidak perlu dipaparkan dalam beza
    Private Shared ReadOnly KolumAbaikan As String() = {"LastModDt", "LastModID", "CreatedDt", "CreatorID", "totalViews"}

    ' Kolum sensitif (kata laluan) tidak pernah direkodkan, walaupun berubah
    Private Shared Function KolumSensitif(ByVal nama As String) As Boolean
        Dim n As String = nama.ToLowerInvariant()
        Return n.Contains("password") OrElse n.Contains("katalaluan") OrElse n.Contains("token") OrElse n.Contains("secret")
    End Function

    ''' <summary>
    ''' Salinan satu baris (kolum -> nilai teks). Nama jadual dan kolum kunci mesti pemalar dari kod, bukan input pengguna.
    ''' </summary>
    Public Shared Function Snapshot(ByVal jadual As String, ByVal kolumKunci As String, ByVal id As Integer) As Dictionary(Of String, String)
        Dim d As New Dictionary(Of String, String)(StringComparer.OrdinalIgnoreCase)
        Try
            Using conn As New SqlConnection(ConnStr)
                Using cmd As New SqlCommand("SELECT TOP 1 * FROM [" & jadual.Replace("]", "") & "] WHERE [" & kolumKunci.Replace("]", "") & "] = @Id", conn)
                    cmd.Parameters.AddWithValue("@Id", id)
                    conn.Open()
                    Using rdr As SqlDataReader = cmd.ExecuteReader()
                        If rdr.Read() Then
                            For i As Integer = 0 To rdr.FieldCount - 1
                                Dim v As Object = rdr.GetValue(i)
                                Dim s As String
                                If IsDBNull(v) Then
                                    s = ""
                                ElseIf TypeOf v Is Byte() Then
                                    ' Binari (cth. tandatangan): saiz + cincangan ringkas, supaya perubahan dikesan tanpa simpan kandungan
                                    Dim b As Byte() = CType(v, Byte())
                                    Dim h As Long = 17
                                    For Each x As Byte In b
                                        h = (h * 31 + x) Mod 1000000007L
                                    Next
                                    s = "[binari " & b.Length & " bait #" & h & "]"
                                ElseIf TypeOf v Is DateTime Then
                                    s = CDate(v).ToString("dd/MM/yyyy HH:mm")
                                Else
                                    s = Convert.ToString(v).Trim()
                                End If
                                d(rdr.GetName(i)) = s
                            Next
                        End If
                    End Using
                End Using
            End Using
        Catch ex As Exception
        End Try
        Return d
    End Function

    ''' <summary>Senarai kolum yang berubah: "Kolum: 'lama' -> 'baru'; ..." (nilai panjang dipendekkan).</summary>
    Public Shared Function Beza(ByVal sebelum As Dictionary(Of String, String), ByVal selepas As Dictionary(Of String, String)) As String
        Dim out As New List(Of String)()
        For Each kv In selepas
            If KolumAbaikan.Contains(kv.Key, StringComparer.OrdinalIgnoreCase) Then Continue For
            Dim sensitif As Boolean = KolumSensitif(kv.Key)
            Dim lama As String = ""
            sebelum.TryGetValue(kv.Key, lama)
            If Not String.Equals(If(lama, ""), If(kv.Value, ""), StringComparison.Ordinal) Then
                If sensitif Then
                    out.Add(kv.Key & ": (diubah)")
                Else
                    out.Add(kv.Key & ": '" & Pendek(lama) & "' -> '" & Pendek(kv.Value) & "'")
                End If
            End If
        Next
        Return String.Join("; ", out)
    End Function

    Private Shared Function Pendek(ByVal s As String) As String
        Dim t As String = If(s, "").Replace(vbCr, " ").Replace(vbLf, " ")
        Return If(t.Length > 120, t.Substring(0, 117) & "...", t)
    End Function

    ''' <summary>
    ''' Rekod perubahan pada satu rekod bukan permohonan (cth. pengguna / peranan). Tiada log jika tiada perubahan.
    ''' </summary>
    Public Shared Sub LogPerubahanRekod(ByVal modul As String, ByVal tindakan As String, ByVal rujukanRekod As String,
                                        ByVal sebelum As Dictionary(Of String, String), ByVal selepas As Dictionary(Of String, String))
        Try
            Dim b As String = Beza(sebelum, selepas)
            If b = "" Then Return
            GlobalClass.auditTrail(modul, tindakan & " - " & rujukanRekod, tindakan, rujukanRekod, "Perubahan: " & b)
        Catch ex As Exception
        End Try
    End Sub

    ''' <summary>Rekod perubahan maklumat permohonan; tiada log jika tiada kolum yang berubah.</summary>
    Public Shared Sub LogPerubahan(ByVal modul As String, ByVal permohonanId As Integer, ByVal batal As Boolean,
                                   ByVal sebelum As Dictionary(Of String, String), ByVal selepas As Dictionary(Of String, String),
                                   Optional ByVal bahagian As String = "")
        Try
            Dim b As String = Beza(sebelum, selepas)
            If b = "" Then Return
            Dim ruj As String = Rujukan(permohonanId)
            Dim jenis As String = If(batal, "Pembatalan", "Permohonan Baru")
            Dim detail As String = jenis & If(bahagian = "", "", " | " & bahagian) & " | Perubahan: " & b
            GlobalClass.auditTrail(modul, KEMASKINI_MAKLUMAT & " - " & ruj, KEMASKINI_MAKLUMAT, ruj, detail)
        Catch ex As Exception
        End Try
    End Sub

    ''' <summary>Teks nota ringkas untuk butiran audit (dipotong supaya log kekal kemas).</summary>
    Public Shared Function Nota(ByVal label As String, ByVal teks As String) As String
        Dim t As String = If(teks, "").Trim()
        If t = "" Then Return ""
        If t.Length > 300 Then t = t.Substring(0, 297) & "..."
        Return label & ": " & t
    End Function

    ''' <summary>Gabung beberapa catatan, abaikan yang kosong.</summary>
    Public Shared Function Gabung(ParamArray bahagian() As String) As String
        Return String.Join(" | ", bahagian.Where(Function(s) Not String.IsNullOrWhiteSpace(s)))
    End Function

End Class
