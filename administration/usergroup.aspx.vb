Imports System.Data
Imports System.Data.SqlClient
Imports System.Globalization
Imports System.Linq
Imports System.Text

' Kumpulan Pengguna & Akses Sistem
'   * Senarai kumpulan (TBL_USER_GROUPNAME), matriks akses modul (TBL_USER_GROUPROLE x TBL_USER_GROUPMODULE)
'     dan ahli kumpulan (TBL_USER_GROUPLIST).
'   * Bendera akses: UGR_Read = Lihat, UGR_Write = Tambah / Kemaskini, UGR_Approval = Kelulusan
'     (bendera yang disemak oleh GlobalClass.CheckPagePermission / CheckPageWrite).
'   * Super admin melihat semua sistem dan kumpulan. Pengguna lain hanya sistem Lesen, dan kumpulan
'     pentadbir (UGN_IsAdmin = 1) disembunyikan. Sekatan ini juga dikuatkuasakan semasa simpan.
Partial Class html_administration_usergroup
    Inherits System.Web.UI.Page

    Private Const SISTEM_LESEN As String = "Lesen"

    Private ReadOnly Property ConnStr As String
        Get
            Return ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString
        End Get
    End Property

    Private _superAdmin As Boolean? = Nothing
    Private ReadOnly Property SuperAdmin As Boolean
        Get
            If Not _superAdmin.HasValue Then _superAdmin = GlobalClass.isSuperAdmin(Convert.ToString(Session.Item("sessionUsersId")))
            Return _superAdmin.Value
        End Get
    End Property

    Protected Property KumpulanId As Integer
        Get
            Return If(ViewState("ugKumpulan") Is Nothing, 0, CInt(ViewState("ugKumpulan")))
        End Get
        Set(value As Integer)
            ViewState("ugKumpulan") = value
        End Set
    End Property

    Private Property TabAhliAktif As Boolean
        Get
            Return ViewState("ugTabAhli") IsNot Nothing AndAlso CBool(ViewState("ugTabAhli"))
        End Get
        Set(value As Boolean)
            ViewState("ugTabAhli") = value
        End Set
    End Property

    Private _bolehTulis As Boolean? = Nothing
    ''' <summary>Kebenaran Write pada page ini (atau super admin).</summary>
    Private ReadOnly Property BolehTulis As Boolean
        Get
            If Not _bolehTulis.HasValue Then
                _bolehTulis = SuperAdmin OrElse GlobalClass.CheckPagePermission("Write")
            End If
            Return _bolehTulis.Value
        End Get
    End Property

    '===================== KITARAN PAGE =====================
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        Dim sm As ScriptManager = ScriptManager.GetCurrent(Page)
        If sm IsNot Nothing Then sm.RegisterPostBackControl(btnExcel)

        If Not IsPostBack Then
            Try
                Dim t As String = GlobalClass.writeTitlePage(Request.QueryString("m_Id"), "")
                If Not String.IsNullOrWhiteSpace(t) Then idWindowTitle.InnerText = t
            Catch ex As Exception
            End Try

            MuatSistem()
            Dim kumpulan As DataTable = MuatKumpulan()
            If kumpulan.Rows.Count > 0 Then KumpulanId = CInt(kumpulan.Rows(0)("UGN_Id"))
            Papar()
        End If
    End Sub

    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As EventArgs) Handles Me.PreRender
        ' Tanpa kebenaran Write: baca sahaja
        btnSimpan.Enabled = BolehTulis AndAlso KumpulanId > 0
        btnBukaTambah.Disabled = Not BolehTulis
        pnlTambahAhli.Visible = BolehTulis
        tabAkses.CssClass = If(TabAhliAktif, "", "on")
        tabAhli.CssClass = If(TabAhliAktif, "on", "")
        phCarian.Visible = Not TabAhliAktif
        btnSimpan.Visible = Not TabAhliAktif
        ddlSistem.Visible = Not TabAhliAktif
    End Sub

    '===================== DATA =====================
    Private Sub MuatSistem()
        ddlSistem.Items.Clear()
        Dim sql As String = "SELECT system_Id, system_Name FROM TBL_SYSTEM" &
                            If(SuperAdmin, "", " WHERE system_Name = @Lesen") & " ORDER BY system_Id"
        Using conn As New SqlConnection(ConnStr)
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@Lesen", SISTEM_LESEN)
                conn.Open()
                Using rdr As SqlDataReader = cmd.ExecuteReader()
                    While rdr.Read()
                        ddlSistem.Items.Add(New ListItem(Convert.ToString(rdr("system_Name")), Convert.ToString(rdr("system_Id"))))
                    End While
                End Using
            End Using
        End Using
        ' Lalai: Lesen
        Dim lesen As ListItem = ddlSistem.Items.Cast(Of ListItem)().FirstOrDefault(Function(i) String.Equals(i.Text, SISTEM_LESEN, StringComparison.OrdinalIgnoreCase))
        If lesen IsNot Nothing Then ddlSistem.SelectedValue = lesen.Value
    End Sub

    Private Function SistemId() As Integer
        Dim id As Integer = 0
        Integer.TryParse(ddlSistem.SelectedValue, id)
        Return id
    End Function

    ''' <summary>Sistem yang dibenarkan untuk pengguna ini (sekatan pelayan, bukan paparan sahaja).</summary>
    Private Function SistemDibenarkan(ByVal id As Integer) As Boolean
        Return ddlSistem.Items.Cast(Of ListItem)().Any(Function(i) i.Value = id.ToString())
    End Function

    Private Function KumpulanDibenarkan(ByVal ugnId As Integer) As Boolean
        Using conn As New SqlConnection(ConnStr)
            Using cmd As New SqlCommand("SELECT COUNT(*) FROM TBL_USER_GROUPNAME WHERE UGN_Id = @Id" & If(SuperAdmin, "", " AND ISNULL(UGN_IsAdmin, 0) = 0"), conn)
                cmd.Parameters.AddWithValue("@Id", ugnId)
                conn.Open()
                Return Convert.ToInt32(cmd.ExecuteScalar()) > 0
            End Using
        End Using
    End Function

    Private Function MuatKumpulan() As DataTable
        Dim dt As New DataTable()
        Dim sql As String = "SELECT g.UGN_Id, g.UGN_Name, ISNULL(g.UGN_IsAdmin, 0) AS UGN_IsAdmin, " &
                            "  (SELECT COUNT(*) FROM TBL_USER_GROUPLIST l WHERE l.UGL_UGN_Id = g.UGN_Id) AS Ahli " &
                            "FROM TBL_USER_GROUPNAME g" & If(SuperAdmin, "", " WHERE ISNULL(g.UGN_IsAdmin, 0) = 0") &
                            " ORDER BY g.UGN_Id"
        Using da As New SqlDataAdapter(sql, ConnStr)
            da.Fill(dt)
        End Using
        rptKumpulan.DataSource = dt
        rptKumpulan.DataBind()
        litKumpulan.Text = dt.Rows.Count.ToString()
        Return dt
    End Function

    ''' <summary>Pastikan setiap modul ada baris TBL_USER_GROUPROLE bagi kumpulan ini (seperti sebelum ini).</summary>
    Private Sub LengkapkanRole(ByVal ugnId As Integer)
        Using conn As New SqlConnection(ConnStr)
            Using cmd As New SqlCommand("INSERT TBL_USER_GROUPROLE (UGR_UGN_Id, UGR_UGM_Id, UGR_Read, UGR_Write, UGR_Approval) " &
                                        "SELECT @Ugn, m.UGM_Id, 0, 0, 0 FROM TBL_USER_GROUPMODULE m " &
                                        "WHERE NOT EXISTS (SELECT 1 FROM TBL_USER_GROUPROLE r WHERE r.UGR_UGN_Id = @Ugn AND r.UGR_UGM_Id = m.UGM_Id)", conn)
                cmd.Parameters.AddWithValue("@Ugn", ugnId)
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Private Shared Function SqlMatriks() As String
        Return "SELECT m.UGM_Id, m.UGM_Name, m.UGM_Level, m.UGM_Menu_SVG, m.UGM_SeqNo, " &
               "  CASE WHEN m.UGM_Level = 1 THEN 0 ELSE m.UGM_ParentId END AS Induk, " &
               "  r.UGR_Id, CAST(ISNULL(r.UGR_Read, 0) AS int) AS UGR_Read, CAST(ISNULL(r.UGR_Write, 0) AS int) AS UGR_Write, " &
               "  CAST(ISNULL(r.UGR_Approval, 0) AS int) AS UGR_Approval " &
               "FROM TBL_USER_GROUPMODULE m " &
               "INNER JOIN TBL_USER_GROUPROLE r ON r.UGR_UGM_Id = m.UGM_Id AND r.UGR_UGN_Id = @Ugn " &
               "WHERE m.UGM_IsPublish = 1 AND m.UGM_SystemId = @Sistem " &
               "ORDER BY m.UGM_SeqNo, m.UGM_Id"
    End Function

    Private Function MuatMatriks(ByVal ugnId As Integer, ByVal sistem As Integer) As DataTable
        Dim dt As New DataTable()
        Using conn As New SqlConnection(ConnStr)
            Using cmd As New SqlCommand(SqlMatriks(), conn)
                cmd.Parameters.AddWithValue("@Ugn", ugnId)
                cmd.Parameters.AddWithValue("@Sistem", sistem)
                Using da As New SqlDataAdapter(cmd)
                    da.Fill(dt)
                End Using
            End Using
        End Using
        Return dt
    End Function

    Private Function MuatAhli(ByVal ugnId As Integer) As DataTable
        Dim dt As New DataTable()
        Using conn As New SqlConnection(ConnStr)
            Using cmd As New SqlCommand("SELECT l.UGL_Id, u.Users_Id, u.Users_Name, u.Users_Fullname, CAST(ISNULL(u.Users_Enabled, 0) AS bit) AS Aktif " &
                                        "FROM TBL_USER_GROUPLIST l INNER JOIN TBL_USERS u ON u.Users_Id = l.UGL_Users_Id " &
                                        "WHERE l.UGL_UGN_Id = @Ugn ORDER BY u.Users_Fullname", conn)
                cmd.Parameters.AddWithValue("@Ugn", ugnId)
                Using da As New SqlDataAdapter(cmd)
                    da.Fill(dt)
                End Using
            End Using
        End Using
        Return dt
    End Function

    Private Function NamaKumpulan(ByVal ugnId As Integer) As String
        Using conn As New SqlConnection(ConnStr)
            Using cmd As New SqlCommand("SELECT UGN_Name FROM TBL_USER_GROUPNAME WHERE UGN_Id = @Id", conn)
                cmd.Parameters.AddWithValue("@Id", ugnId)
                conn.Open()
                Return Convert.ToString(cmd.ExecuteScalar())
            End Using
        End Using
    End Function

    '===================== PAPARAN =====================
    Private Sub Papar()
        Dim ada As Boolean = KumpulanId > 0 AndAlso KumpulanDibenarkan(KumpulanId)
        phTiadaKumpulan.Visible = Not ada
        phAkses.Visible = ada AndAlso Not TabAhliAktif
        phAhli.Visible = ada AndAlso TabAhliAktif
        If Not ada Then
            litNamaKumpulan.Text = "-"
            Return
        End If

        LengkapkanRole(KumpulanId)
        Dim nama As String = NamaKumpulan(KumpulanId)
        litNamaKumpulan.Text = HttpUtility.HtmlEncode(nama)
        litCetakKumpulan.Text = HttpUtility.HtmlEncode(nama)
        litCetakSistem.Text = HttpUtility.HtmlEncode(ddlSistem.SelectedItem?.Text)

        ' Matriks + ringkasan
        Dim dt As DataTable = MuatMatriks(KumpulanId, SistemId())
        rptModul.DataSource = dt
        rptModul.DataBind()
        rptModul.Visible = dt.Rows.Count > 0
        phTiadaModul.Visible = dt.Rows.Count = 0
        litModul.Text = dt.Rows.Count.ToString()
        Dim aktif As Integer = 0
        For Each r As DataRow In dt.Rows
            aktif += CInt(r("UGR_Read")) + CInt(r("UGR_Write")) + CInt(r("UGR_Approval"))
        Next
        litAktif.Text = aktif.ToString()
        litTidakAktif.Text = (dt.Rows.Count * 3 - aktif).ToString()

        ' Ahli
        Dim ahli As DataTable = MuatAhli(KumpulanId)
        litBilAhli.Text = ahli.Rows.Count.ToString()
        If TabAhliAktif Then
            rptAhli.DataSource = ahli
            rptAhli.DataBind()
            rptAhli.Visible = ahli.Rows.Count > 0
            phTiadaAhli.Visible = ahli.Rows.Count = 0
            MuatCalonAhli()
        End If
    End Sub

    Private Sub MuatCalonAhli()
        lstPengguna.Items.Clear()
        Using conn As New SqlConnection(ConnStr)
            Using cmd As New SqlCommand("SELECT Users_Id, Users_Name, Users_Fullname FROM TBL_USERS u " &
                                        "WHERE ISNULL(u.Users_Enabled, 0) = 1 AND NOT EXISTS (SELECT 1 FROM TBL_USER_GROUPLIST l WHERE l.UGL_UGN_Id = @Ugn AND l.UGL_Users_Id = u.Users_Id) " &
                                        "ORDER BY u.Users_Fullname", conn)
                cmd.Parameters.AddWithValue("@Ugn", KumpulanId)
                conn.Open()
                Using rdr As SqlDataReader = cmd.ExecuteReader()
                    While rdr.Read()
                        lstPengguna.Items.Add(New ListItem(Convert.ToString(rdr("Users_Fullname")) & " (" & Convert.ToString(rdr("Users_Name")) & ")", Convert.ToString(rdr("Users_Id"))))
                    End While
                End Using
            End Using
        End Using
    End Sub

    Protected Function IkonModul(ByVal svg As Object) As String
        Dim n As String = Convert.ToString(svg).Trim()
        If n = "" OrElse Not System.Text.RegularExpressions.Regex.IsMatch(n, "^[a-z0-9\-]+$") Then Return "<i class=""bi bi-folder2 me-2"" style=""color:var(--ug-p)""></i>"
        Return "<svg class=""mi""><use xlink:href=""" & VirtualPathUtility.ToAbsolute("~/vendors/@coreui/icons/svg/free.svg") & "#" & n & """></use></svg>"
    End Function

    Protected Shared Function Huruf(ByVal nama As Object) As String
        Dim bahagian As String() = Convert.ToString(nama).Split(New Char() {" "c}, StringSplitOptions.RemoveEmptyEntries)
        If bahagian.Length = 0 Then Return "?"
        Dim s As String = bahagian(0).Substring(0, 1)
        If bahagian.Length > 1 AndAlso Not bahagian(1).ToUpperInvariant().StartsWith("BIN") Then s &= bahagian(1).Substring(0, 1)
        Return s.ToUpperInvariant()
    End Function

    '===================== TINDAKAN =====================
    Protected Sub rptKumpulan_ItemCommand(source As Object, e As RepeaterCommandEventArgs) Handles rptKumpulan.ItemCommand
        Dim id As Integer = CInt(e.CommandArgument)
        If Not KumpulanDibenarkan(id) Then Return
        KumpulanId = id
        If e.CommandName = "Ahli" Then
            TabAhliAktif = True
        ElseIf e.CommandName = "Akses" Then
            TabAhliAktif = False
        End If
        MuatKumpulan()
        Papar()
    End Sub

    Protected Sub ddlSistem_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlSistem.SelectedIndexChanged
        MuatKumpulan()
        Papar()
    End Sub

    Protected Sub tabAkses_Click(sender As Object, e As EventArgs) Handles tabAkses.Click
        TabAhliAktif = False
        MuatKumpulan()
        Papar()
    End Sub

    Protected Sub tabAhli_Click(sender As Object, e As EventArgs) Handles tabAhli.Click
        TabAhliAktif = True
        MuatKumpulan()
        Papar()
    End Sub

    ''' <summary>Simpan matriks akses. Hanya baris bagi kumpulan dan sistem yang dibenarkan dikemaskini.</summary>
    Protected Sub btnSimpan_Click(sender As Object, e As EventArgs) Handles btnSimpan.Click
        If Not BolehTulis Then Return
        Dim sistem As Integer = SistemId()
        If KumpulanId <= 0 OrElse Not KumpulanDibenarkan(KumpulanId) OrElse Not SistemDibenarkan(sistem) Then
            Mesej("error", "Tiada kebenaran untuk mengemaskini kumpulan / sistem ini.")
            Return
        End If

        Dim semasa As DataTable = MuatMatriks(KumpulanId, sistem)
        Dim perubahan As New List(Of String)()
        Using conn As New SqlConnection(ConnStr)
            conn.Open()
            Using tx As SqlTransaction = conn.BeginTransaction()
                For Each r As DataRow In semasa.Rows
                    Dim ugrId As Integer = CInt(r("UGR_Id"))
                    Dim baruR As Integer = If(Request.Form("r_" & ugrId) = "1", 1, 0)
                    Dim baruW As Integer = If(Request.Form("w_" & ugrId) = "1", 1, 0)
                    Dim baruA As Integer = If(Request.Form("a_" & ugrId) = "1", 1, 0)
                    Dim lamaR As Integer = CInt(r("UGR_Read")), lamaW As Integer = CInt(r("UGR_Write")), lamaA As Integer = CInt(r("UGR_Approval"))
                    If baruR = lamaR AndAlso baruW = lamaW AndAlso baruA = lamaA Then Continue For

                    Using cmd As New SqlCommand("UPDATE TBL_USER_GROUPROLE SET UGR_Read = @R, UGR_Write = @W, UGR_Approval = @A WHERE UGR_Id = @Id AND UGR_UGN_Id = @Ugn", conn, tx)
                        cmd.Parameters.AddWithValue("@R", baruR)
                        cmd.Parameters.AddWithValue("@W", baruW)
                        cmd.Parameters.AddWithValue("@A", baruA)
                        cmd.Parameters.AddWithValue("@Id", ugrId)
                        cmd.Parameters.AddWithValue("@Ugn", KumpulanId)
                        cmd.ExecuteNonQuery()
                    End Using

                    Dim beza As New List(Of String)()
                    If baruR <> lamaR Then beza.Add("Lihat " & lamaR & "->" & baruR)
                    If baruW <> lamaW Then beza.Add("Tambah/Kemaskini " & lamaW & "->" & baruW)
                    If baruA <> lamaA Then beza.Add("Kelulusan " & lamaA & "->" & baruA)
                    perubahan.Add(Convert.ToString(r("UGM_Name")).Trim() & " (" & String.Join(", ", beza) & ")")
                Next
                tx.Commit()
            End Using
        End Using

        If perubahan.Count > 0 Then
            Dim nama As String = NamaKumpulan(KumpulanId)
            GlobalClass.auditTrail("Group Permission", nama & " - " & ddlSistem.SelectedItem.Text, "Kemaskini Kebenaran", nama,
                                   "Sistem: " & ddlSistem.SelectedItem.Text & " | " & perubahan.Count & " modul diubah: " & String.Join("; ", perubahan))
            Mesej("success", "Akses kumpulan disimpan (" & perubahan.Count & " modul dikemaskini).")
        Else
            Mesej("info", "Tiada perubahan untuk disimpan.")
        End If
        MuatKumpulan()
        Papar()
    End Sub

    Protected Sub btnTambahAhli_Click(sender As Object, e As EventArgs) Handles btnTambahAhli.Click
        If Not BolehTulis OrElse KumpulanId <= 0 OrElse Not KumpulanDibenarkan(KumpulanId) Then Return
        Dim nama As String = NamaKumpulan(KumpulanId)
        Dim bil As Integer = 0
        Using conn As New SqlConnection(ConnStr)
            conn.Open()
            For Each it As ListItem In lstPengguna.Items
                If Not it.Selected Then Continue For
                Using cmd As New SqlCommand("INSERT TBL_USER_GROUPLIST (UGL_UGN_Id, UGL_Users_Id) SELECT @Ugn, @Uid " &
                                            "WHERE NOT EXISTS (SELECT 1 FROM TBL_USER_GROUPLIST WHERE UGL_UGN_Id = @Ugn AND UGL_Users_Id = @Uid) " &
                                            "AND EXISTS (SELECT 1 FROM TBL_USERS WHERE Users_Id = @Uid)", conn)
                    cmd.Parameters.AddWithValue("@Ugn", KumpulanId)
                    cmd.Parameters.AddWithValue("@Uid", CInt(it.Value))
                    If cmd.ExecuteNonQuery() = 1 Then
                        bil += 1
                        GlobalClass.auditTrail("Group Permission", nama, "Add User Permission", nama, "Ahli ditambah: " & it.Text)
                    End If
                End Using
            Next
        End Using
        Mesej(If(bil > 0, "success", "info"), If(bil > 0, bil & " ahli ditambah ke " & nama & ".", "Tiada pengguna dipilih."))
        TabAhliAktif = True
        MuatKumpulan()
        Papar()
    End Sub

    Protected Sub btnBuangAhli_Click(sender As Object, e As EventArgs) Handles btnBuangAhli.Click
        If Not BolehTulis OrElse KumpulanId <= 0 OrElse Not KumpulanDibenarkan(KumpulanId) Then Return
        Dim dipilih As String() = If(Request.Form.GetValues("ahli"), New String() {})
        Dim nama As String = NamaKumpulan(KumpulanId)
        Dim bil As Integer = 0
        Using conn As New SqlConnection(ConnStr)
            conn.Open()
            For Each v As String In dipilih
                Dim uglId As Integer
                If Not Integer.TryParse(v, uglId) Then Continue For
                Dim pengguna As String = ""
                Using cmdNama As New SqlCommand("SELECT u.Users_Fullname + ' (' + u.Users_Name + ')' FROM TBL_USER_GROUPLIST l INNER JOIN TBL_USERS u ON u.Users_Id = l.UGL_Users_Id WHERE l.UGL_Id = @Id AND l.UGL_UGN_Id = @Ugn", conn)
                    cmdNama.Parameters.AddWithValue("@Id", uglId)
                    cmdNama.Parameters.AddWithValue("@Ugn", KumpulanId)
                    pengguna = Convert.ToString(cmdNama.ExecuteScalar())
                End Using
                ' Hanya keahlian dalam kumpulan yang sedang dipilih
                Using cmd As New SqlCommand("DELETE FROM TBL_USER_GROUPLIST WHERE UGL_Id = @Id AND UGL_UGN_Id = @Ugn", conn)
                    cmd.Parameters.AddWithValue("@Id", uglId)
                    cmd.Parameters.AddWithValue("@Ugn", KumpulanId)
                    If cmd.ExecuteNonQuery() = 1 Then
                        bil += 1
                        GlobalClass.auditTrail("Group Permission", nama, "Remove User Permission", nama, "Ahli dibuang: " & pengguna)
                    End If
                End Using
            Next
        End Using
        Mesej(If(bil > 0, "success", "info"), If(bil > 0, bil & " ahli dibuang daripada " & nama & ".", "Tiada ahli ditanda."))
        TabAhliAktif = True
        MuatKumpulan()
        Papar()
    End Sub

    Protected Sub btnTambahKumpulan_Click(sender As Object, e As EventArgs) Handles btnTambahKumpulan.Click
        If Not BolehTulis Then Return
        Dim nama As String = txtNamaKumpulan.Text.Trim()
        If nama = "" Then
            Mesej("error", "Sila masukkan nama kumpulan.")
            Return
        End If
        Dim idBaru As Integer = 0
        Using conn As New SqlConnection(ConnStr)
            conn.Open()
            Using cmdSemak As New SqlCommand("SELECT COUNT(*) FROM TBL_USER_GROUPNAME WHERE LTRIM(RTRIM(UGN_Name)) = @Nama", conn)
                cmdSemak.Parameters.AddWithValue("@Nama", nama)
                If Convert.ToInt32(cmdSemak.ExecuteScalar()) > 0 Then
                    Mesej("error", "Nama kumpulan telah wujud.")
                    Return
                End If
            End Using
            Using cmd As New SqlCommand("INSERT INTO TBL_USER_GROUPNAME (UGN_Name, UGN_IsAdmin) VALUES (@Nama, 0); SELECT CAST(SCOPE_IDENTITY() AS int);", conn)
                cmd.Parameters.AddWithValue("@Nama", nama)
                idBaru = Convert.ToInt32(cmd.ExecuteScalar())
            End Using
        End Using
        GlobalClass.auditTrail("User Group Management", nama, GlobalClass.AUDIT_TAMBAH, nama, "Kumpulan baru ditambah (ID " & idBaru & ")")
        txtNamaKumpulan.Text = ""
        KumpulanId = idBaru
        TabAhliAktif = False
        Mesej("success", "Kumpulan '" & nama & "' ditambah. Sila tetapkan aksesnya.")
        MuatKumpulan()
        Papar()
    End Sub

    Private Sub Mesej(ByVal jenis As String, ByVal teks As String)
        Dim js As String = "(function(){var t='" & HttpUtility.JavaScriptStringEncode(teks) & "';" &
                           "if(window.Swal){Swal.fire({icon:'" & jenis & "',text:t,timer:2600,showConfirmButton:false});}else{alert(t);}})();"
        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ugMesej", js, True)
    End Sub

    '===================== EKSPORT EXCEL (satu helaian bagi setiap kumpulan) =====================
    Protected Sub btnExcel_Click(sender As Object, e As EventArgs) Handles btnExcel.Click
        Dim kumpulan As New DataTable()
        Using da As New SqlDataAdapter("SELECT UGN_Id, UGN_Name FROM TBL_USER_GROUPNAME" & If(SuperAdmin, "", " WHERE ISNULL(UGN_IsAdmin, 0) = 0") & " ORDER BY UGN_Id", ConnStr)
            da.Fill(kumpulan)
        End Using
        Dim sistemList As List(Of ListItem) = ddlSistem.Items.Cast(Of ListItem)().ToList()

        Dim helaian As New List(Of Tuple(Of String, String))()
        Dim namaGuna As New HashSet(Of String)(StringComparer.OrdinalIgnoreCase)
        For Each g As DataRow In kumpulan.Rows
            Dim ugnId As Integer = CInt(g("UGN_Id"))
            LengkapkanRole(ugnId)
            Dim nama As String = Convert.ToString(g("UGN_Name"))
            helaian.Add(Tuple.Create(NamaHelaian(nama, namaGuna), LembaranKumpulan(ugnId, nama, sistemList)))
        Next

        Dim data As Byte() = BinaXlsx(helaian)
        GlobalClass.auditTrail("Group Permission", "Export Excel akses kumpulan", GlobalClass.AUDIT_EXPORT, "", kumpulan.Rows.Count & " kumpulan")

        Response.Clear()
        Response.Buffer = True
        Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        Response.AddHeader("Content-Disposition", "attachment; filename=AksesKumpulan_" & DateTime.Now.ToString("yyyyMMdd_HHmm") & ".xlsx")
        Response.AddHeader("Content-Length", data.Length.ToString())
        Response.BinaryWrite(data)
        Response.Flush()
        Response.SuppressContent = True
        HttpContext.Current.ApplicationInstance.CompleteRequest()
    End Sub

    Private Shared Function NamaHelaian(ByVal nama As String, ByVal guna As HashSet(Of String)) As String
        Dim s As String = System.Text.RegularExpressions.Regex.Replace(nama, "[\[\]\:\*\?\/\\]", " ").Trim()
        If s = "" Then s = "Kumpulan"
        If s.Length > 28 Then s = s.Substring(0, 28).Trim()
        Dim calon As String = s
        Dim n As Integer = 2
        While guna.Contains(calon)
            calon = s & " " & n
            n += 1
        End While
        guna.Add(calon)
        Return calon
    End Function

    Private Function LembaranKumpulan(ByVal ugnId As Integer, ByVal nama As String, ByVal sistemList As List(Of ListItem)) As String
        Dim sb As New StringBuilder()
        sb.Append("<?xml version=""1.0"" encoding=""UTF-8"" standalone=""yes""?>")
        sb.Append("<worksheet xmlns=""http://schemas.openxmlformats.org/spreadsheetml/2006/main"">")
        sb.Append("<cols><col min=""1"" max=""1"" width=""46"" customWidth=""1""/><col min=""2"" max=""4"" width=""18"" customWidth=""1""/></cols><sheetData>")
        Dim baris As Integer = 1
        sb.Append(BarisXml(baris, Sel("A", baris, "AKSES KUMPULAN: " & nama, 1))) : baris += 1
        sb.Append(BarisXml(baris, Sel("A", baris, "ProLesen - Majlis Perbandaran Kluang | Dijana " & DateTime.Now.ToString("dd/MM/yyyy hh:mm tt"), 2))) : baris += 2

        For Each s As ListItem In sistemList
            Dim dt As DataTable = MuatMatriks(ugnId, CInt(s.Value))
            If dt.Rows.Count = 0 Then Continue For
            sb.Append(BarisXml(baris, Sel("A", baris, "Sistem: " & s.Text, 3))) : baris += 1
            sb.Append(BarisXml(baris, Sel("A", baris, "Modul / Fungsi", 4) & Sel("B", baris, "Lihat", 4) & Sel("C", baris, "Tambah / Kemaskini", 4) & Sel("D", baris, "Kelulusan", 4))) : baris += 1
            For Each r As DataRow In dt.Rows
                Dim induk As Boolean = CInt(r("UGM_Level")) = 1
                Dim nm As String = If(induk, "", "    ") & Convert.ToString(r("UGM_Name")).Trim()
                sb.Append(BarisXml(baris, Sel("A", baris, nm, If(induk, 5, 6)) &
                                       Sel("B", baris, YaTidak(r("UGR_Read")), 7) &
                                       Sel("C", baris, YaTidak(r("UGR_Write")), 7) &
                                       Sel("D", baris, YaTidak(r("UGR_Approval")), 7)))
                baris += 1
            Next
            baris += 1
        Next

        Dim ahli As DataTable = MuatAhli(ugnId)
        sb.Append(BarisXml(baris, Sel("A", baris, "Ahli Kumpulan (" & ahli.Rows.Count & ")", 3))) : baris += 1
        sb.Append(BarisXml(baris, Sel("A", baris, "Nama", 4) & Sel("B", baris, "ID Pengguna", 4) & Sel("C", baris, "Status", 4))) : baris += 1
        For Each a As DataRow In ahli.Rows
            sb.Append(BarisXml(baris, Sel("A", baris, Convert.ToString(a("Users_Fullname")), 6) &
                                   Sel("B", baris, Convert.ToString(a("Users_Name")), 6) &
                                   Sel("C", baris, If(CBool(a("Aktif")), "Aktif", "Tidak aktif"), 6)))
            baris += 1
        Next

        sb.Append("</sheetData><pageMargins left=""0.5"" right=""0.5"" top=""0.6"" bottom=""0.6"" header=""0.3"" footer=""0.3""/>")
        sb.Append("<pageSetup paperSize=""9"" orientation=""portrait""/></worksheet>")
        Return sb.ToString()
    End Function

    Private Shared Function YaTidak(ByVal v As Object) As String
        Return If(CInt(v) = 1, "Ya", "-")
    End Function

    Private Shared Function BarisXml(ByVal n As Integer, ByVal sel As String) As String
        Return "<row r=""" & n & """>" & sel & "</row>"
    End Function

    Private Shared Function Sel(ByVal lajur As String, ByVal baris As Integer, ByVal teks As String, ByVal gaya As Integer) As String
        Return "<c r=""" & lajur & baris & """ s=""" & gaya & """ t=""inlineStr""><is><t xml:space=""preserve"">" &
               System.Security.SecurityElement.Escape(If(teks, "")) & "</t></is></c>"
    End Function

    ' Gaya: 0 biasa, 1 tajuk, 2 nota, 3 sub-tajuk, 4 kepala jadual, 5 modul induk, 6 teks, 7 tengah
    Private Shared Function GayaXlsx() As String
        Return "<?xml version=""1.0"" encoding=""UTF-8"" standalone=""yes""?>" &
            "<styleSheet xmlns=""http://schemas.openxmlformats.org/spreadsheetml/2006/main"">" &
            "<fonts count=""4""><font><sz val=""10""/><name val=""Calibri""/></font><font><b/><sz val=""14""/><name val=""Calibri""/></font>" &
            "<font><sz val=""10""/><color rgb=""FF555555""/><name val=""Calibri""/></font><font><b/><sz val=""10""/><name val=""Calibri""/></font></fonts>" &
            "<fills count=""4""><fill><patternFill patternType=""none""/></fill><fill><patternFill patternType=""gray125""/></fill>" &
            "<fill><patternFill patternType=""solid""><fgColor rgb=""FFEEEAFB""/><bgColor indexed=""64""/></patternFill></fill>" &
            "<fill><patternFill patternType=""solid""><fgColor rgb=""FFF6F4FE""/><bgColor indexed=""64""/></patternFill></fill></fills>" &
            "<borders count=""2""><border><left/><right/><top/><bottom/><diagonal/></border>" &
            "<border><left style=""thin""><color rgb=""FFCCCCCC""/></left><right style=""thin""><color rgb=""FFCCCCCC""/></right><top style=""thin""><color rgb=""FFCCCCCC""/></top><bottom style=""thin""><color rgb=""FFCCCCCC""/></bottom><diagonal/></border></borders>" &
            "<cellStyleXfs count=""1""><xf numFmtId=""0"" fontId=""0"" fillId=""0"" borderId=""0""/></cellStyleXfs>" &
            "<cellXfs count=""8"">" &
            "<xf numFmtId=""0"" fontId=""0"" fillId=""0"" borderId=""0"" xfId=""0""/>" &
            "<xf numFmtId=""0"" fontId=""1"" fillId=""0"" borderId=""0"" xfId=""0"" applyFont=""1""/>" &
            "<xf numFmtId=""0"" fontId=""2"" fillId=""0"" borderId=""0"" xfId=""0"" applyFont=""1""/>" &
            "<xf numFmtId=""0"" fontId=""3"" fillId=""0"" borderId=""0"" xfId=""0"" applyFont=""1""/>" &
            "<xf numFmtId=""0"" fontId=""3"" fillId=""2"" borderId=""1"" xfId=""0"" applyFont=""1"" applyFill=""1"" applyBorder=""1"" applyAlignment=""1""><alignment horizontal=""center"" vertical=""center""/></xf>" &
            "<xf numFmtId=""0"" fontId=""3"" fillId=""3"" borderId=""1"" xfId=""0"" applyFont=""1"" applyFill=""1"" applyBorder=""1""/>" &
            "<xf numFmtId=""0"" fontId=""0"" fillId=""0"" borderId=""1"" xfId=""0"" applyBorder=""1""/>" &
            "<xf numFmtId=""0"" fontId=""0"" fillId=""0"" borderId=""1"" xfId=""0"" applyBorder=""1"" applyAlignment=""1""><alignment horizontal=""center""/></xf>" &
            "</cellXfs><cellStyles count=""1""><cellStyle name=""Normal"" xfId=""0"" builtinId=""0""/></cellStyles></styleSheet>"
    End Function

    Private Shared Function BinaXlsx(ByVal helaian As List(Of Tuple(Of String, String))) As Byte()
        Dim ms As New IO.MemoryStream()
        Using zip As New IO.Compression.ZipArchive(ms, IO.Compression.ZipArchiveMode.Create, True)
            Dim ct As New StringBuilder("<?xml version=""1.0"" encoding=""UTF-8"" standalone=""yes""?><Types xmlns=""http://schemas.openxmlformats.org/package/2006/content-types"">" &
                "<Default Extension=""rels"" ContentType=""application/vnd.openxmlformats-package.relationships+xml""/><Default Extension=""xml"" ContentType=""application/xml""/>" &
                "<Override PartName=""/xl/workbook.xml"" ContentType=""application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml""/>" &
                "<Override PartName=""/xl/styles.xml"" ContentType=""application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml""/>")
            Dim wb As New StringBuilder("<?xml version=""1.0"" encoding=""UTF-8"" standalone=""yes""?><workbook xmlns=""http://schemas.openxmlformats.org/spreadsheetml/2006/main"" xmlns:r=""http://schemas.openxmlformats.org/officeDocument/2006/relationships""><sheets>")
            Dim rels As New StringBuilder("<?xml version=""1.0"" encoding=""UTF-8"" standalone=""yes""?><Relationships xmlns=""http://schemas.openxmlformats.org/package/2006/relationships"">")
            For i As Integer = 0 To helaian.Count - 1
                Dim n As Integer = i + 1
                ct.Append("<Override PartName=""/xl/worksheets/sheet" & n & ".xml"" ContentType=""application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml""/>")
                wb.Append("<sheet name=""" & System.Security.SecurityElement.Escape(helaian(i).Item1) & """ sheetId=""" & n & """ r:id=""rId" & n & """/>")
                rels.Append("<Relationship Id=""rId" & n & """ Type=""http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet"" Target=""worksheets/sheet" & n & ".xml""/>")
                Tulis(zip, "xl/worksheets/sheet" & n & ".xml", helaian(i).Item2)
            Next
            rels.Append("<Relationship Id=""rId" & (helaian.Count + 1) & """ Type=""http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles"" Target=""styles.xml""/></Relationships>")
            ct.Append("</Types>")
            wb.Append("</sheets></workbook>")
            Tulis(zip, "[Content_Types].xml", ct.ToString())
            Tulis(zip, "_rels/.rels", "<?xml version=""1.0"" encoding=""UTF-8"" standalone=""yes""?><Relationships xmlns=""http://schemas.openxmlformats.org/package/2006/relationships""><Relationship Id=""rId1"" Type=""http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument"" Target=""xl/workbook.xml""/></Relationships>")
            Tulis(zip, "xl/workbook.xml", wb.ToString())
            Tulis(zip, "xl/_rels/workbook.xml.rels", rels.ToString())
            Tulis(zip, "xl/styles.xml", GayaXlsx())
        End Using
        Return ms.ToArray()
    End Function

    Private Shared Sub Tulis(ByVal zip As IO.Compression.ZipArchive, ByVal nama As String, ByVal isi As String)
        Using s As IO.Stream = zip.CreateEntry(nama, IO.Compression.CompressionLevel.Optimal).Open()
            Dim b As Byte() = New UTF8Encoding(False).GetBytes(isi)
            s.Write(b, 0, b.Length)
        End Using
    End Sub

End Class
