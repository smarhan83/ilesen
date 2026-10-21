Imports System.Data
Imports System.Data.SqlClient
Imports System.Text.RegularExpressions

' Halaman cetak label QR sepanduk/banting (awam, dibuka dari modal Semakan Status).
' Dikunci dengan kod unik (LESEN_BantingImej.UniqueID) dan token No. Pin (BantingID) - lihat QrAccess / QrPin.ashx.
'   CetakQRBanting.aspx?id=<UniqueID>          -> satu label
'   CetakQRBanting.aspx?id=<UniqueID>&semua=1  -> semua label bagi permohonan yang sama
Partial Class CetakQRBanting
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If IsPostBack Then Return

        Dim uniqueId As String = Convert.ToString(Request.QueryString("id")).Trim()
        Dim semua As Boolean = (Request.QueryString("semua") = "1")

        Dim dt As New DataTable()

        If uniqueId <> "" AndAlso uniqueId.Length <= 50 AndAlso Regex.IsMatch(uniqueId, "^[A-Za-z0-9\-]+$") Then
            Dim sql As String =
                "SELECT b.Permohonan_ID, b.UniqueID, l.Lokasi, p.Rujukan, ISNULL(NULLIF(p.NamaBaruSyarikat, ''), p.NamaSyarikat) AS NamaSyarikat, " &
                "       p.TarikhBanting1, p.TarikhBanting2, " &
                "       DENSE_RANK() OVER (ORDER BY b.Lokasi_ID) AS LokasiNo " &
                "FROM LESEN_BantingImej b " &
                "INNER JOIN LESEN_Permohonan p ON p.Permohonan_ID = b.Permohonan_ID " &
                "LEFT JOIN LESEN_BantingLokasi l ON l.Lokasi_ID = b.Lokasi_ID " &
                "WHERE b.Permohonan_ID = (SELECT TOP 1 x.Permohonan_ID FROM LESEN_BantingImej x WHERE x.UniqueID = @UniqueID) " &
                "  AND p.StatusID = 10 AND ISNULL(p.IsBatal, 0) = 0 " &
                "ORDER BY b.Lokasi_ID, b.Imej_ID"

            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@UniqueID", uniqueId)
                    Using da As New SqlDataAdapter(cmd)
                        da.Fill(dt)
                    End Using
                End Using
            End Using

            ' Penomboran lokasi dikira atas semua kod, kemudian tapis jika satu label sahaja
            If Not semua AndAlso dt.Rows.Count > 0 Then
                Dim dv As New DataView(dt)
                dv.RowFilter = "UniqueID = '" & uniqueId.Replace("'", "''") & "'"
                dt = dv.ToTable()
            End If
        End If

        ' Wajib sahkan No. Pin dahulu (token &t= daripada QrPin.ashx) - jika tiada / tamat, tiada label dipaparkan
        Dim tiadaAkses As Boolean = False
        If dt.Rows.Count > 0 AndAlso Not QrAccess.ValidToken(CInt(dt.Rows(0)("Permohonan_ID")), Convert.ToString(Request.QueryString("t"))) Then
            dt.Clear()
            tiadaAkses = True
        End If

        rptLabel.DataSource = dt
        rptLabel.DataBind()

        phTiada.Visible = (dt.Rows.Count = 0)

        If dt.Rows.Count > 0 Then
            litRingkasan.Text = HttpUtility.HtmlEncode(Nilai(dt.Rows(0)("Rujukan"))) & " &middot; " & dt.Rows.Count & " label"
        Else
            litRingkasan.Text = If(tiadaAkses, "Akses dinafikan - sila masukkan No. Pin pada Semakan Status Permohonan dahulu", "Tiada label untuk dicetak")
        End If
    End Sub

    Protected Function Nilai(ByVal v As Object) As String
        Dim s As String = Convert.ToString(v)
        Return If(String.IsNullOrWhiteSpace(s), "-", s.Trim())
    End Function

    Protected Function Tempoh(ByVal mula As Object, ByVal tamat As Object) As String
        If mula Is Nothing OrElse IsDBNull(mula) OrElse tamat Is Nothing OrElse IsDBNull(tamat) Then Return "-"
        Return Convert.ToDateTime(mula).ToString("dd/MM/yyyy") & " - " & Convert.ToDateTime(tamat).ToString("dd/MM/yyyy")
    End Function

End Class
