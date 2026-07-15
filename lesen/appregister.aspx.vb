
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Drawing.Imaging
Imports System.Security.Cryptography
Imports System.Security.Policy
Imports Microsoft.SqlServer.Management.Smo

Partial Class appregister
    Inherits System.Web.UI.Page

    Public Shared CS As [String] = ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString

    Protected Sub Page_PreRenderComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRenderComplete

        Try

            If FormView1.CurrentMode = 1 Then

                Dim btnBack As LinkButton = DirectCast(FormView1.FindControl("BackButton"), LinkButton)

                'Dim ApprovalStatus As String = hdnFldStatus.Value

                Dim frmview() As Object = {FormView1, FormViewMaintenanceTemplate}
                Dim lbutton() As Object = {btnBack, BT_ViewLaporan}
                Dim ctlDeny() As Object = {BtnSaveMesyuarat, btnSaveLetter, ButtonAddAssignment} '//deny control
                Dim ctlDenyRaw() As Object = {} '//deny control

                '//check Write
                Dim frmwrite As Boolean = GlobalClass.CheckPageWrite("Write", frmview, lbutton, ctlDeny)
                '// check gridview permission
                If frmwrite = False Then
                    '//gridview select view
                    GridView1.Columns.Item(12).Visible = False '//grid delete
                    'GridView1.Columns.Item(10).Visible = False '//grid delete
                    gvTabUlasan.Columns.Item(4).Visible = False '//grid delete
                    gvTabUlasan.Columns.Item(5).Visible = False '//grid delete
                    GridViewJabatanAgensiBatal.Columns.Item(3).Visible = False '//grid delete
                    GridViewMaintenanceTemplate.Columns.Item(3).Visible = False '//grid delete
                    gvTabBayaran.Columns.Item(4).Visible = False '//grid delete
                    gvTabBayaran.Columns.Item(5).Visible = False '//grid delete					
                    gvTabBayaran.Columns.Item(6).Visible = False '//grid delete
                End If

            End If

        Catch ex As Exception

        End Try

    End Sub
    Public Sub MessageBox(ByVal Msg As String, ByVal obj As System.Web.UI.Page)
        Dim jscript As String
        Dim x = "OURServices"
        ScriptManager.RegisterClientScriptBlock(Me.Page, Me.[GetType](), "Alert", "alert('" & Msg & "');", True)
    End Sub

    Private Sub ShowAlert(statusMsg As String, titleMsg As String, strMsg As String)

        ScriptManager.RegisterStartupScript(Me, Page.GetType, "Script", "Swal.fire('" & titleMsg & "','" & strMsg & "','" & statusMsg & "')", True)

    End Sub

    Private Sub GridView1_SelectedIndexChanged(sender As Object, e As EventArgs) Handles GridView1.SelectedIndexChanged

        GridViewMaintenanceTemplate.DataBind()
        TabContainer1.Visible = True

        FormView1.Visible = True
        FormView1.ChangeMode(FormViewMode.Edit)
        whiteCard.Visible = False

        Dim pid As Integer = CInt(GridView1.SelectedDataKey.Values("Permohonan_ID"))
        Dim statusid As Integer = CInt(GridView1.SelectedDataKey.Values("StatusID"))
        Dim isbatal As Boolean = CBool(GridView1.SelectedDataKey.Values("IsBatal"))
        Dim jid As Integer = CInt(GridView1.SelectedDataKey.Values("JenisLesen_ID"))
        Dim ispublish As Boolean = CBool(GridView1.SelectedDataKey.Values("IsPublish"))

        If statusid > 0 Then
            'FormViewMaintenanceTemplate.Visible = False
            tabMaklumat.Visible = True
        End If

        If statusid > 8 Then
            TabSurat.Visible = False
            BT_Maklumat.Visible = True
        Else
            TabSurat.Visible = True
            BT_Maklumat.Visible = False
        End If

        If isbatal Then
            tabKadarBayaran.Visible = False
            TabJabatanAgensi.Visible = False
            TabLog.Visible = False
            tabMesyuarat.Visible = True
            TabLogBatal.Visible = True
            TabJabatanAgensiBatal.Visible = True
            tabMaklumat.Visible = True
            GetMesyuarat(pid)
        Else
            tabKadarBayaran.Visible = True
            TabJabatanAgensi.Visible = True
            TabLog.Visible = True
            tabMesyuarat.Visible = False
            TabJabatanAgensiBatal.Visible = False
            TabLogBatal.Visible = False
        End If

        If tabMaklumat.Visible = True Then
            GetPermohonanPembetulan(pid, jid, isbatal)
        End If

        If ispublish And tabKadarBayaran.Visible = True Then
            gvTabBayaran.Columns(5).Visible = False
            gvTabBayaran.Columns(6).Visible = False
        Else
            gvTabBayaran.Columns(5).Visible = True
            gvTabBayaran.Columns(6).Visible = True
        End If

        GetSuratMohon(pid)

    End Sub

    Private Sub GridView1_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles GridView1.RowCommand

        If e.CommandName = "BatalProses" Then

            Dim intRow As Integer = CInt(e.CommandArgument)

            If intRow > 9 Then
                intRow -= GridView1.PageIndex * 10
            End If

            Dim Permohonan_ID As String = CStr(Me.GridView1.DataKeys(intRow)("Permohonan_ID"))

            Dim IsBatal As Boolean = CBool(Me.GridView1.DataKeys(intRow)("IsBatal"))
            Dim IsRevertStatus As Boolean = False

            Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

                myConnection.Open()

                Dim SQL As String = "SELECT * FROM LESEN_ApprovalList WHERE Permohonan_ID = @Permohonan_ID AND ApprStatusID=10 AND IsComplete=1"

                Dim myCommandSelect As New SqlCommand(SQL, myConnection)
                myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", Permohonan_ID)

                Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

                Try

                    If myReader.Read Then
                        IsRevertStatus = True
                    End If

                Catch ex As Exception
                    MessageBox("ERROR", Me)
                End Try

                myReader.Close()
                myConnection.Close()

                '//APPROVAL LIST

                myConnection.Open()

                Dim Sql1 = "DELETE FROM LESEN_ApprovalList WHERE Permohonan_ID= @Permohonan_ID"

                If IsBatal Then

                    Sql1 = "DELETE FROM LESEN_ApprovalListBatal WHERE Permohonan_ID= @Permohonan_ID"

                End If

                Dim myCommand1 = New SqlCommand(Sql1, myConnection)
                myCommand1.Parameters.AddWithValue("@Permohonan_ID", Permohonan_ID)

                Dim result1 = myCommand1.ExecuteNonQuery()

                myCommand1.Dispose()
                myConnection.Close()

                '//PERMOHONAN AGENSI

                myConnection.Open()

                Dim Sql3 = "DELETE FROM LESEN_PermohonanAgensi WHERE Permohonan_ID= @Permohonan_ID"

                If IsBatal Then

                    Sql3 = "DELETE FROM LESEN_PermohonanAgensiBatal WHERE Permohonan_ID= @Permohonan_ID"

                End If

                Dim myCommand3 = New SqlCommand(Sql3, myConnection)
                myCommand3.Parameters.AddWithValue("@Permohonan_ID", Permohonan_ID)

                Dim result3 = myCommand3.ExecuteNonQuery()

                myCommand3.Dispose()
                myConnection.Close()

                myConnection.Open()

                Dim Sql2 = "UPDATE LESEN_Permohonan SET StatusID=0 WHERE Permohonan_ID= @Permohonan_ID"

                If IsRevertStatus Then
                    Sql2 = "UPDATE LESEN_Permohonan SET StatusID=10, IsBatal=0 WHERE Permohonan_ID= @Permohonan_ID"
                End If

                Dim myCommand2 = New SqlCommand(Sql2, myConnection)
                myCommand2.Parameters.AddWithValue("@Permohonan_ID", Permohonan_ID)

                Dim result2 = myCommand2.ExecuteNonQuery()

                myCommand2.Dispose()
                myConnection.Close()

            End Using

            GridView1.DataBind()

        End If

    End Sub

    Private Sub GridView1_DataBound(sender As Object, e As EventArgs) Handles GridView1.DataBound

    End Sub

    Private Sub GridView1_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles GridView1.RowDataBound

        Try

            If e.Row.RowType = DataControlRowType.DataRow Then

                'Dim cbris As CheckBox = DirectCast(e.Row.Cells(6).FindControl("cbris"), CheckBox)
                'Dim cbsel As CheckBox = DirectCast(e.Row.Cells(7).FindControl("cbsel"), CheckBox)

                Dim dtTmp As DateTime = Convert.ToDateTime(e.Row.DataItem("TarikhMohon").ToString)
                Dim is24h As Boolean = Convert.ToBoolean(e.Row.DataItem("Is24jam").ToString)
                Dim isbatal As Boolean = Convert.ToBoolean(e.Row.DataItem("IsBatal").ToString)

                If (((DateTime.Now - dtTmp).TotalHours > 24 And is24h) Or
                    ((DateTime.Now - dtTmp).TotalDays > 14 And is24h = False)) And
                    isbatal = False And e.Row.DataItem("Description").ToString.Contains("Permohonan Lulus") = False And
                    e.Row.DataItem("Description").ToString.Contains("Peraku Tidak Sokong") = False Then

                    Dim clr As Color = Color.FromName("#ff7070")

                    e.Row.BackColor = clr

                End If

            End If

        Catch ex As Exception

            MessageBox("Error checking delayed task.", Me)

        End Try

    End Sub

    Private Sub GridView1_RowDeleted(sender As Object, e As GridViewDeletedEventArgs) Handles GridView1.RowDeleted
        ShowAlert("success", "", "Rekod telah dipadam!")
    End Sub

    Private Sub FormView1_ItemInserting(sender As Object, e As FormViewInsertEventArgs) Handles FormView1.ItemInserting

    End Sub

    Private Sub FormView1_ItemInserted(sender As Object, e As FormViewInsertedEventArgs) Handles FormView1.ItemInserted
        Session.Item("isInserted") = True
        GridView1.DataBind()
        GridViewMaintenanceTemplate.DataBind()
        TabContainer1.Visible = True

    End Sub

    Private Sub GetPermohonanPembetulan(permohonanID As Integer, jenislesenID As Integer, isBatal As Boolean)

        pnlbillboard_ins.Visible = False
        pnlesen1_ins.Visible = False
        pnlesen1a_ins.Visible = False
        pnlesen1b_ins.Visible = False
        pnlesen1c_ins.Visible = False
        pnlesen1d_ins.Visible = False
        pnlesen1e_ins.Visible = False
        pnlesen2_ins.Visible = False
        pnlesen3_ins.Visible = False
        pnlesen4_ins.Visible = False
        pnlesen5_ins.Visible = False

        Select Case jenislesenID
            Case 3                      'Lesen Anjing /
                pnlesen3_ins.Visible = True
            Case 2, 25                      'Pasar Lambak, Tambah Petak /
                pnlesen2_ins.Visible = True
            Case 4                      'Pasar Penjaja /
                pnlesen4_ins.Visible = True
            Case 1                      'Lesen Perniagaan /
                pnlesen1_ins.Visible = True
                pnlesen1a_ins.Visible = True
            Case 6, 7                     'Tukar Alamat Perniagaan, Tambah Premis /
                pnlesen1_ins.Visible = True
                pnlesen1a_ins.Visible = True
                pnlesen1c_ins.Visible = True
            Case 13, 17, 18                      'Permit Kaki Lima, Lot Tepi Kedai, Lebuh Awam /
                pnlesen1_ins.Visible = True
            Case 14                         'Pembatalan Lesen & Wang Amanah
                pnlesen1_ins.Visible = True
                'pnlbatal.Visible = True
            Case 11, 23, 26                     'Tukar Nama Syarikat /
                pnlesen1_ins.Visible = True
                pnlesen1a_ins.Visible = True
                pnlesen1c_ins.Visible = True
                pnlesen1e_ins.Visible = True
            Case 9, 24                          'Tukar Pemilik Perniagaan /
                pnlesen1_ins.Visible = True
                pnlesen1a_ins.Visible = True
                pnlesen1c_ins.Visible = True
                pnlesen1b_ins.Visible = True
            Case 10, 12, 16                     'Tambah, Tukar, Pengurangan Visual Iklan /
                pnlesen1_ins.Visible = True
                pnlesen1a_ins.Visible = True
            Case 5                          ' billboard /
                pnlesen1_ins.Visible = True
                pnlesen1a_ins.Visible = True
                pnlbillboard_ins.Visible = True
            Case 8                     'Jenis Perniagaan /
                pnlesen1_ins.Visible = True
                pnlesen1c_ins.Visible = True
                pnlesen1d_ins.Visible = True
            Case 15                     'Expo /
                pnlesen5_ins.Visible = True
            Case 19                             'Nama + Alamat + Visual Iklan /
                pnlesen1_ins.Visible = True
                pnlesen1a_ins.Visible = True
                pnlesen1c_ins.Visible = True
                pnlesen1e_ins.Visible = True
            Case 20                             'Pemilik + Alamat + Visual Iklan /
                pnlesen1_ins.Visible = True
                pnlesen1a_ins.Visible = True
                pnlesen1b_ins.Visible = True
                pnlesen1c_ins.Visible = True

        End Select

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQL As String = "SELECT * FROM LESEN_PermohonanPembetulan WHERE Permohonan_ID = @Permohonan_ID"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", permohonanID)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            Try
                If myReader.Read Then

                    If myReader.Item("NamaSyarikat").ToString().Length > 0 Then
                        TB_NamaSyarikat_ins.Text = myReader.Item("NamaSyarikat").ToString()
                    End If

                    If myReader.Item("NoPendaftaran").ToString().Length > 0 Then
                        TB_NoPendaftaran_ins.Text = myReader.Item("NoPendaftaran").ToString()
                    End If

                    If myReader.Item("NoAkaun").ToString().Length > 0 Then
                        TB_NoAkaun_ins.Text = myReader.Item("NoAkaun").ToString()
                    End If

                    If myReader.Item("AlamatPremis").ToString().Length > 0 Then
                        TB_AlamatPremis_ins.Text = myReader.Item("AlamatPremis").ToString()
                    End If

                    If myReader.Item("JenisPerniagaan").ToString().Length > 0 Then
                        TB_JenisPerniagaan_ins.Text = myReader.Item("JenisPerniagaan").ToString()
                    End If

                    If myReader.Item("PemilikBaru").ToString().Length > 0 Then
                        TB_PemilikBaru_ins.Text = myReader.Item("PemilikBaru").ToString()
                    End If

                    If myReader.Item("AlamatBaru").ToString().Length > 0 Then
                        TB_AlamatBaru_ins.Text = myReader.Item("AlamatBaru").ToString()
                    End If

                    If myReader.Item("JenisPerniagaanBaru").ToString().Length > 0 Then
                        TB_JenisPerniagaanBaru_ins.Text = myReader.Item("JenisPerniagaanBaru").ToString()
                    End If

                    If myReader.Item("NamaBaruSyarikat").ToString().Length > 0 Then
                        TB_NamaBaruSyarikat_ins.Text = myReader.Item("NamaBaruSyarikat").ToString()
                    End If

                    If myReader.Item("SaizIklan").ToString().Length > 0 Then
                        TB_SaizIklan_ins.Text = myReader.Item("SaizIklan").ToString()
                    End If

                    If myReader.Item("UnitIklan").ToString().Length > 0 Then
                        TB_UnitIklan_ins.Text = myReader.Item("UnitIklan").ToString()
                    End If

                    If myReader.Item("BillboardLokasi").ToString().Length > 0 Then
                        TB_BillboardLokasi_ins.Text = myReader.Item("BillboardLokasi").ToString()
                    End If

                    If myReader.Item("LokasiPasar1").ToString().Length > 0 Then
                        TB_LokasiPasar1_ins.Text = myReader.Item("LokasiPasar1").ToString()
                    End If

                    If myReader.Item("LokasiPasar2").ToString().Length > 0 Then
                        TB_LokasiPasar2_ins.Text = myReader.Item("LokasiPasar2").ToString()
                    End If

                    If myReader.Item("LokasiPasar3").ToString().Length > 0 Then
                        TB_LokasiPasar3_ins.Text = myReader.Item("LokasiPasar3").ToString()
                    End If

                    If myReader.Item("JenisPasar").ToString().Length > 0 Then
                        DDL_JenisPasar_ins.SelectedValue = myReader.Item("JenisPasar").ToString()
                    End If

                    If myReader.Item("JenisPerniagaanPasar").ToString().Length > 0 Then
                        TB_JenisPerniagaanPasar_ins.Text = myReader.Item("JenisPerniagaanPasar").ToString()
                    End If

                    If myReader.Item("JumlahPetak").ToString().Length > 0 Then
                        TB_JumlahPetak_ins.Text = myReader.Item("JumlahPetak").ToString()
                    End If

                    If myReader.Item("AnjingAlamat").ToString().Length > 0 Then
                        TB_AnjingAlamat_ins.Text = myReader.Item("AnjingAlamat").ToString()
                    End If

                    If myReader.Item("AnjingJenisPremis").ToString().Length > 0 Then
                        DDL_AnjingJenisPremis_ins.SelectedValue = CInt(myReader.Item("AnjingJenisPremis").ToString())
                    End If

                    If myReader.Item("AnjingBaka").ToString().Length > 0 Then
                        DDL_AnjingBaka_ins.SelectedValue = CInt(myReader.Item("AnjingBaka").ToString())
                    End If

                    If myReader.Item("AnjingJantan").ToString().Length > 0 Then
                        TB_AnjingJantan_ins.Text = myReader.Item("AnjingJantan").ToString()
                    End If

                    If myReader.Item("AnjingBetina").ToString().Length > 0 Then
                        TB_AnjingBetina_ins.Text = myReader.Item("AnjingBetina").ToString()
                    End If

                    If myReader.Item("AnjingJantanMandul").ToString().Length > 0 Then
                        TB_AnjingJantanMandul_ins.Text = myReader.Item("AnjingJantanMandul").ToString()
                    End If

                    If myReader.Item("AnjingBetinaMandul").ToString().Length > 0 Then
                        TB_AnjingBetinaMandul_ins.Text = myReader.Item("AnjingBetinaMandul").ToString()
                    End If

                    If myReader.Item("AlamatPenjajaan").ToString().Length > 0 Then
                        TB_AlamatPenjajaan_ins.Text = myReader.Item("AlamatPenjajaan").ToString()
                    End If

                    If myReader.Item("JenisPerniagaanPenjaja").ToString().Length > 0 Then
                        TB_JenisPerniagaanPenjaja_ins.Text = myReader.Item("JenisPerniagaanPenjaja").ToString()
                    End If

                    If myReader.Item("PenganjurEkspo").ToString().Length > 0 Then
                        TB_PenganjurEkspo_ins.Text = myReader.Item("PenganjurEkspo").ToString()
                    End If

                    If myReader.Item("NamaEkspo").ToString().Length > 0 Then
                        TB_NamaEkspo_ins.Text = myReader.Item("NamaEkspo").ToString()
                    End If

                    If myReader.Item("LokasiEkspo").ToString().Length > 0 Then
                        TB_LokasiEkspo_ins.Text = myReader.Item("LokasiEkspo").ToString()
                    End If

                    If myReader.Item("NoTelEkspo").ToString().Length > 0 Then
                        TB_NoTel_ins.Text = myReader.Item("NoTelEkspo").ToString()
                    End If

                    If myReader.Item("TarikhEkspo1").ToString().Length > 0 Then
                        TB_TarikhEkspo1_ins.Text = CDate(myReader.Item("TarikhEkspo1")).ToString("yyyy-MM-dd")
                    End If

                    If myReader.Item("TarikhEkspo2").ToString().Length > 0 Then
                        TB_TarikhEkspo2_ins.Text = CDate(myReader.Item("TarikhEkspo2")).ToString("yyyy-MM-dd")
                    End If

                    If myReader.Item("MasaEkspo1").ToString().Length > 0 Then
                        TB_MasaEkspo1_ins.Text = myReader.Item("MasaEkspo1").ToString()
                    End If

                    If myReader.Item("MasaEkspo2").ToString().Length > 0 Then
                        TB_MasaEkspo2_ins.Text = myReader.Item("MasaEkspo2").ToString()
                    End If

                End If

            Catch ex As Exception
                MessageBox("ERROR", Me)
            End Try

            myReader.Close()
            myConnection.Close()

            Dim tblName As String = ""

            If isBatal Then

                tblName = "Batal"

            End If

            myConnection.Open()

            SQL = "SELECT COUNT(Permohonan_ID) AS totalSah FROM LESEN_PermohonanAgensi" & tblName & " WHERE JabatanAgensi_ID = 3 AND PengesahID IS NOT NULL AND Permohonan_ID = @Permohonan_ID"

            Dim myCommandSelect1 As New SqlCommand(SQL, myConnection)
            myCommandSelect1.Parameters.AddWithValue("@Permohonan_ID", permohonanID)

            Dim myReader1 As SqlDataReader = myCommandSelect1.ExecuteReader

            If myReader1.Read Then

                'MessageBox(permohonanID & "/" & tblName, Me)

                If CInt(myReader1.Item(0)) > 0 Then

                    BT_ViewLaporan.Visible = True

                Else

                    BT_ViewLaporan.Visible = False

                End If

            End If

            myReader1.Close()
            myConnection.Close()

        End Using

    End Sub

    Private Sub GetSuratMohon(pid As Integer)

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQL As String = "SELECT TandatanganMohonUlasanId, TandatanganMohonUlasanLuarId FROM LESEN_Permohonan WHERE Permohonan_ID = @Permohonan_ID"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            Try
                If myReader.Read Then

                    'MessageBox(pid & "/" & myReader.Item("TandatanganMohonUlasanId").ToString() & "/" & myReader.Item("TandatanganMohonUlasanLuarId").ToString(), Me)

                    If myReader.Item("TandatanganMohonUlasanId").ToString().Length > 0 Then
                        ddlTandatangan.SelectedValue = CInt(myReader.Item("TandatanganMohonUlasanId").ToString())
                    End If

                    If myReader.Item("TandatanganMohonUlasanLuarId").ToString().Length > 0 Then
                        ddlTandatanganLuar.SelectedValue = CInt(myReader.Item("TandatanganMohonUlasanLuarId").ToString())
                    End If

                End If

            Catch ex As Exception
                MessageBox("ERROR", Me)
            End Try

            myReader.Close()
            myConnection.Close()

        End Using

    End Sub

    Private Sub insertJabatanAgensiBatal(jbid As Integer, pid As Integer)

        Dim listagensi() As Integer = {3}

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Dim ismandatory As Integer = 1

            'If jbid = 2 Then
            '    ismandatory = 0
            'End If

            For Each agensi In listagensi

                myConnection.Open()

                Dim SQL1 As String = "INSERT INTO LESEN_PermohonanAgensiBatal(Permohonan_ID, JabatanAgensi_ID, IsMandatory) VALUES (@Permohonan_ID, @JabatanAgensi_ID, @IsMandatory)"

                Dim myCommandSelect1 As New SqlCommand(SQL1, myConnection)
                myCommandSelect1.Parameters.AddWithValue("@Permohonan_ID", pid)
                myCommandSelect1.Parameters.AddWithValue("@JabatanAgensi_ID", agensi)
                myCommandSelect1.Parameters.AddWithValue("@IsMandatory", ismandatory)

                Try
                    Dim result = myCommandSelect1.ExecuteNonQuery()

                Catch ex As Exception

                End Try

                myConnection.Close()

            Next

        End Using

    End Sub

    Private Sub insertJabatanAgensi(jid As Integer, pid As Integer)

        Dim listagensi As List(Of Integer) = New List(Of Integer)

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQL As String = "SELECT JabatanAgensi_ID FROM LESEN_JenisLesenAgensi WHERE JenisLesen_ID = @JenisLesen_ID"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@JenisLesen_ID", jid)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            Try
                While myReader.Read

                    listagensi.Add(myReader.Item("JabatanAgensi_ID"))

                End While

            Catch ex As Exception

            End Try

            myReader.Close()
            myConnection.Close()

            Dim cb As CheckBox = DirectCast(FormView1.FindControl("CB_24h"), CheckBox)
            Dim ismandatory As Integer = 1

            If cb.Checked = True Then
                ismandatory = 0
            End If

            For Each agensi In listagensi

                myConnection.Open()

                Dim SQL1 As String = "INSERT INTO LESEN_PermohonanAgensi(Permohonan_ID, JabatanAgensi_ID, IsMandatory) VALUES (@Permohonan_ID, @JabatanAgensi_ID, @IsMandatory)"

                Dim myCommandSelect1 As New SqlCommand(SQL1, myConnection)
                myCommandSelect1.Parameters.AddWithValue("@Permohonan_ID", pid)
                myCommandSelect1.Parameters.AddWithValue("@JabatanAgensi_ID", agensi)
                myCommandSelect1.Parameters.AddWithValue("@IsMandatory", ismandatory)

                Try
                    Dim result = myCommandSelect1.ExecuteNonQuery()

                Catch ex As Exception

                End Try

                myConnection.Close()

            Next

        End Using

    End Sub

    Private Sub insertKadarBayaran(jid As Integer, pid As Integer)

        Dim listkbdesc As List(Of String) = New List(Of String)
        Dim listkbamount As List(Of String) = New List(Of String)

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQL As String = "SELECT JenisLesenBayaran_Description, JenisLesenBayaran_Amount FROM LESEN_JenisLesenBayaran WHERE JenisLesen_ID = @JenisLesen_ID"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@JenisLesen_ID", jid)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            Try
                While myReader.Read

                    listkbdesc.Add(myReader.Item("JenisLesenBayaran_Description"))
                    listkbamount.Add(myReader.Item("JenisLesenBayaran_Amount"))

                End While

            Catch ex As Exception

            End Try

            myReader.Close()
            myConnection.Close()

            For counter As Integer = 0 To listkbdesc.Count - 1

                myConnection.Open()

                Dim SQL1 As String = "INSERT INTO LESEN_KadarBayaran(KadarBayaran_PermohonanID, KadarBayaran_PermohonanAgensiID, KadarBayaran_UserID, KadarBayaran_Desc, KadarBayaran_Amount) 
                    VALUES (@KadarBayaran_PermohonanID, @KadarBayaran_PermohonanAgensiID, @KadarBayaran_UserID, @KadarBayaran_Desc, @KadarBayaran_Amount)"

                Dim myCommandSelect1 As New SqlCommand(SQL1, myConnection)
                myCommandSelect1.Parameters.AddWithValue("@KadarBayaran_PermohonanID", pid)
                myCommandSelect1.Parameters.AddWithValue("@KadarBayaran_PermohonanAgensiID", Session.Item("SessionEstateId"))
                myCommandSelect1.Parameters.AddWithValue("@KadarBayaran_UserID", Session.Item("SessionUsersId"))
                myCommandSelect1.Parameters.AddWithValue("@KadarBayaran_Desc", listkbdesc(counter))
                myCommandSelect1.Parameters.AddWithValue("@KadarBayaran_Amount", listkbamount(counter))

                Try
                    Dim result = myCommandSelect1.ExecuteNonQuery()

                Catch ex As Exception

                End Try

                myConnection.Close()

            Next

        End Using

    End Sub

    Private Function insertMaklumatPembetulan(Permohonan_ID As Integer) As Boolean

        'Dim Permohonan_ID As Integer = CInt(GridView1.SelectedValue)
        Dim recordset As Integer = -1

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Dim SQL As String = ""

            SQL = "IF NOT EXISTS(Select Permohonan_ID from LESEN_PermohonanPembetulan where Permohonan_ID=@Permohonan_ID) 
                    BEGIN 
                    INSERT INTO LESEN_PermohonanPembetulan(Permohonan_ID, JenisLesen_ID, NamaSyarikat, NoPendaftaran, NoAkaun, AlamatPremis, JenisPerniagaan,
                        PemilikBaru, AlamatBaru, JenisPerniagaanBaru, NamaBaruSyarikat, SaizIklan, IklanBercahaya, UnitIklan, BillboardLokasi, LokasiPasar1, LokasiPasar2, LokasiPasar3, JenisPasar,
                        JenisPerniagaanPasar, JumlahPetak, AnjingAlamat, AnjingJenisPremis, AnjingBaka, AnjingJantan, AnjingBetina, AnjingJantanMandul, AnjingBetinaMandul, AlamatPenjajaan, JenisPerniagaanPenjaja, 
                        TarikhBatal, PenganjurEkspo, NamaEkspo, LokasiEkspo, NoTelEkspo, TarikhEkspo1, TarikhEkspo2, MasaEkspo1, MasaEkspo2, CreatorID, CreatedDt, LastModID, LastModDt) 
                    SELECT Permohonan_ID, JenisLesen_ID, NamaSyarikat, NoPendaftaran, NoAkaun, AlamatPremis, JenisPerniagaan,
                        PemilikBaru, AlamatBaru, JenisPerniagaanBaru, NamaBaruSyarikat, SaizIklan, IklanBercahaya, UnitIklan, BillboardLokasi, LokasiPasar1, LokasiPasar2, LokasiPasar3, JenisPasar,
                        JenisPerniagaanPasar, JumlahPetak, AnjingAlamat, AnjingJenisPremis, AnjingBaka, AnjingJantan, AnjingBetina, AnjingJantanMandul, AnjingBetinaMandul, AlamatPenjajaan, JenisPerniagaanPenjaja, 
                        TarikhBatal, PenganjurEkspo, NamaEkspo, LokasiEkspo, NoTelEkspo, TarikhEkspo1, TarikhEkspo2, MasaEkspo1, MasaEkspo2, CreatorID, CreatedDt, LastModID, LastModDt FROM LESEN_Permohonan 
                    WHERE LESEN_Permohonan.Permohonan_ID = @Permohonan_ID
                    END"

            Dim myCommand As New SqlCommand(SQL, myConnection)

            myCommand.Parameters.AddWithValue("@Permohonan_ID", Permohonan_ID)

            myConnection.Open()
            myCommand.ExecuteNonQuery()
            myConnection.Close()

            myConnection.Open()

            SQL = "SELECT COUNT(Permohonan_ID) AS totalid FROM LESEN_PermohonanPembetulan WHERE Permohonan_ID = @Permohonan_ID"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", Permohonan_ID)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            Try
                While myReader.Read

                    recordset = myReader.Item("totalid")

                End While

            Catch ex As Exception

            End Try

            myReader.Close()
            myConnection.Close()

            If recordset < 1 Then
                Return False
            Else
                Return True
            End If

        End Using

    End Function

    Private Sub SqlDataSourceForm_Inserted(sender As Object, e As SqlDataSourceStatusEventArgs) Handles SqlDataSourceForm.Inserted
        Dim PermohonanID As Integer = -1
        Dim JenisLesenID As Integer
        Dim JenisBatal As Integer
        Dim IsBatal As Boolean
        Dim Is24Jam As Boolean
        Dim strAlert As String = ""

        If Not IsDBNull(e.Command.Parameters("@Permohonan_ID").Value) Then
            PermohonanID = e.Command.Parameters("@Permohonan_ID").Value
            JenisLesenID = e.Command.Parameters("@JenisLesen_ID").Value
            IsBatal = e.Command.Parameters("@IsBatal").Value
            Is24Jam = e.Command.Parameters("@Is24Jam").Value

            If Is24Jam = False Then
                strAlert = "BUKAN"
            End If

            'MessageBox(JenisLesenID, Me)

            If IsBatal = False Then
                insertJabatanAgensi(JenisLesenID, PermohonanID)
                insertKadarBayaran(JenisLesenID, PermohonanID)
            Else
                JenisBatal = e.Command.Parameters("@JenisBatal").Value

                If JenisBatal = 1 Then
                    insertJabatanAgensiBatal(JenisBatal, PermohonanID)
                End If

            End If

            ShowAlert("success", "", "Rekod permohonan " & strAlert & " 24 jam telah disimpan.")

        End If
        GridView1.DataBind()

        For n As Integer = 0 To GridView1.DataKeys.Count - 1

            If GridView1.DataKeys(n).Value = PermohonanID Then
                GridView1.SelectRow(n)
                Exit For
            End If

        Next

        If GridView1.SelectedIndex = -1 Then
            FormView1.ChangeMode(FormViewMode.Insert)
            ButtonAddAssignment.Visible = True
        End If
    End Sub

    Private Sub FormView1_ItemUpdating(sender As Object, e As FormViewUpdateEventArgs) Handles FormView1.ItemUpdating

        Dim cb As CheckBox = DirectCast(FormView1.FindControl("CB_IsBatal"), CheckBox)

        If cb.Visible And cb.Checked Then

            e.NewValues("StatusID") = 0

        End If

    End Sub

    Private Sub FormView1_ItemUpdated(sender As Object, e As FormViewUpdatedEventArgs) Handles FormView1.ItemUpdated

        Dim PermohonanID As Integer = -1
        Dim JenisLesenID As Integer
        Dim JenisBatal As Integer
        Dim IsBatal As Boolean
        Dim Is24Jam As String = ""

        If Not IsDBNull(e.NewValues("Permohonan_ID")) Then
            PermohonanID = e.NewValues("Permohonan_ID")
            JenisLesenID = e.NewValues("JenisLesen_ID")
            IsBatal = e.NewValues("IsBatal")

            If e.NewValues("Is24Jam") = False Then
                Is24Jam = "BUKAN"
            End If

            If IsBatal And IsBatal <> e.OldValues("IsBatal") Then
                JenisBatal = e.NewValues("JenisBatal")

                If JenisBatal = 1 Then
                    insertJabatanAgensiBatal(JenisBatal, PermohonanID)
                End If

                tabKadarBayaran.Visible = False
                TabLog.Visible = False
                TabJabatanAgensi.Visible = False
                tabMesyuarat.Visible = True
                TabLogBatal.Visible = True
                TabJabatanAgensiBatal.Visible = True
            End If

        End If

        GridView1.DataBind()
        GridViewMaintenanceTemplate.DataBind()
        GridViewLogKelulusan.DataBind()
        GridViewLogBatal.DataBind()
        GridViewJabatanAgensiBatal.DataBind()
        ShowAlert("success", "", "Rekod permohonan " & Is24Jam & " 24 jam telah dikemaskini.")
    End Sub

    '--tab1

    Private Sub SqlDataSourceFormviewMaintenanceTemplate_Inserted(sender As Object, e As SqlDataSourceStatusEventArgs) Handles SqlDataSourceFormviewMaintenanceTemplate.Inserted


    End Sub

    Private Sub FormViewMaintenanceTemplate_ItemInserted(sender As Object, e As FormViewInsertedEventArgs) Handles FormViewMaintenanceTemplate.ItemInserted
        GridView1.DataBind()
        GridViewMaintenanceTemplate.DataBind()
        TabContainer1.Visible = True

        ShowAlert("success", "", "Rekod bejaya disimpan!")
        FormViewMaintenanceTemplate.DataBind()
    End Sub

    Private Sub FormViewMaintenanceTemplate_ItemUpdated(sender As Object, e As FormViewUpdatedEventArgs) Handles FormViewMaintenanceTemplate.ItemUpdated

    End Sub

    Private Sub GridViewMaintenanceTemplate_SelectedIndexChanged(sender As Object, e As EventArgs) Handles GridViewMaintenanceTemplate.SelectedIndexChanged
        GridViewMaintenanceTemplate.DataBind()
        TabContainer1.Visible = True

        FormView1.Visible = True
        FormView1.ChangeMode(FormViewMode.Edit)
        FormViewMaintenanceTemplate.ChangeMode(FormViewMode.Edit)
        whiteCard.Visible = False
    End Sub

    Private Sub GridViewMaintenanceTemplate_RowDeleted(sender As Object, e As GridViewDeletedEventArgs) Handles GridViewMaintenanceTemplate.RowDeleted
        ShowAlert("success", "", "Rekod berjaya dibuang!")
        FormViewMaintenanceTemplate.DataBind()
    End Sub
    '--end tab1

    Private Sub ButtonAddAssignment_Click(sender As Object, e As EventArgs) Handles ButtonAddAssignment.Click
        DDL_Status.SelectedValue = 0
        Session.Item("isInserted") = False
        FormView1.Visible = True
        FormView1.ChangeMode(FormViewMode.Insert)

        whiteCard.Visible = False
    End Sub

    Protected Sub BackButton_Click(sender As Object, e As EventArgs)
        Response.Redirect(Request.Url.AbsoluteUri)
    End Sub

    Protected Sub DDL_JenisLesen_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ddl As DropDownList = DirectCast(FormView1.FindControl("DDL_JenisLesen"), DropDownList)

        Dim pnla As Panel = DirectCast(FormView1.FindControl("pnlesen1"), Panel)
        Dim pnla1 As Panel = DirectCast(FormView1.FindControl("pnlesen1a"), Panel)
        Dim pnla2 As Panel = DirectCast(FormView1.FindControl("pnlesen1b"), Panel)
        Dim pnla3 As Panel = DirectCast(FormView1.FindControl("pnlesen1c"), Panel)
        Dim pnla4 As Panel = DirectCast(FormView1.FindControl("pnlesen1d"), Panel)
        Dim pnla5 As Panel = DirectCast(FormView1.FindControl("pnlesen1e"), Panel)

        Dim pnlb As Panel = DirectCast(FormView1.FindControl("pnlesen2"), Panel)

        Dim pnlc As Panel = DirectCast(FormView1.FindControl("pnlesen3"), Panel)

        Dim pnld As Panel = DirectCast(FormView1.FindControl("pnlesen4"), Panel)

        Dim pnle As Panel = DirectCast(FormView1.FindControl("pnlesen5"), Panel)

        Dim pnlf As Panel = DirectCast(FormView1.FindControl("pnlrujukan"), Panel)

        Dim pnlbatal1 As Panel = DirectCast(FormView1.FindControl("pnlbatal1"), Panel)

        Dim pnlbillboard As Panel = DirectCast(FormView1.FindControl("pnlbillboard"), Panel)

        Dim noruj As TextBox = DirectCast(FormView1.FindControl("TB_Rujukan"), TextBox)

        pnlbillboard.Visible = False
        pnla.Visible = False
        pnla1.Visible = False
        pnla2.Visible = False
        pnla3.Visible = False
        pnla4.Visible = False
        pnla5.Visible = False
        pnlb.Visible = False
        pnlc.Visible = False
        pnld.Visible = False
        pnle.Visible = False
        pnlf.Visible = True
        pnlbatal1.Visible = True

        If FormView1.CurrentMode = FormViewMode.Insert Then

            noruj.Text = "MPK/599/401/"

        End If

        Select Case ddl.SelectedValue
            Case 0
                pnlf.Visible = False
                pnlbatal1.Visible = False

            Case 3                      'Lesen Anjing /
                pnlc.Visible = True

                If FormView1.CurrentMode = FormViewMode.Insert Then

                    noruj.Text = "MPK/599/401/209/LA"

                End If

            Case 2, 25                      'Pasar Lambak, Tambah Petak /
                pnlb.Visible = True
            Case 4                      'Pasar Penjaja /
                pnld.Visible = True
            Case 1                       'Lesen Perniagaan /
                pnla.Visible = True
                pnla1.Visible = True
            Case 6, 7                     'Tukar Alamat Perniagaan, Tambah Premis /
                pnla.Visible = True
                pnla1.Visible = True
                pnla3.Visible = True
            Case 13, 17, 18                      'Permit Kaki Lima, Lot Tepi Kedai, Lebuh Awam /
                pnla.Visible = True
            Case 14                         'Pembatalan Lesen & Wang Amanah
                pnla.Visible = True
                'pnlbatal.Visible = True
            Case 11, 23, 26                     'Tukar Nama Syarikat /
                pnla.Visible = True
                pnla1.Visible = True
                pnla3.Visible = True
                pnla5.Visible = True
            Case 9, 24                     'Tukar Pemilik Perniagaan /
                pnla.Visible = True
                pnla1.Visible = True
                pnla3.Visible = True
                pnla2.Visible = True
            Case 10, 12, 16                     'Tukar, Pengurangan Visual Iklan /
                pnla.Visible = True
                pnla1.Visible = True
            Case 5                          ' billboard /
                pnla.Visible = True
                pnla1.Visible = True
                pnlbillboard.Visible = True
            Case 8                     'Jenis Perniagaan /
                pnla.Visible = True
                pnla3.Visible = True
                pnla4.Visible = True
            Case 15                     'Expo /
                pnle.Visible = True
            Case 19
                pnla.Visible = True
                pnla1.Visible = True
                pnla3.Visible = True
                pnla5.Visible = True
            Case 20
                pnla.Visible = True
                pnla1.Visible = True
                pnla2.Visible = True
                pnla3.Visible = True

        End Select

        Page.SetFocus(Me.ui_btnPageBottom.ClientID)

    End Sub

    Private Sub appregister_LoadComplete(sender As Object, e As EventArgs) Handles Me.LoadComplete

    End Sub

    '+++++++++ START FILTER +++++++++
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        If Not IsPostBack Then
            Try

                If CInt(Request.QueryString("pid")) = 0 Then
                    Try
                        DDL_Status.SelectedValue = 1
                        DDL_CreatedBy.SelectedValue = Session.Item("sessionUserName")
                    Catch ex As Exception
                    End Try
                End If
            Catch ex As Exception
            End Try
        Else
            Session.Item("isInserted") = False
        End If
        TB_PermohonanID.Attributes.Add("style", "display:none")
        Dim gv As GridView = GridView1
        Dim ds As SqlDataSource = SqlDataSourceGrid
        'GlobalClass.GenerateFilter(gv, ds, pnlFilter) 

        If Not IsPostBack Then

            Try

                If CInt(Request.QueryString("pid")) > 0 Then
                    ButtonAddAssignment.Visible = False

                    Page.ClientScript.RegisterStartupScript(Me.[GetType](), "showPage", "<script>document.getElementById('MainContent_TB_PermohonanID').value = '" & Request.QueryString("pid") & "';
					document.getElementById('MainContent_btnSearch').click();
					</script>", False)

                    'pnlfilter.Attributes.Add("style", "display:none")
                    panelFilter.Attributes.Add("style", "display:none")
                    'btnSearch.Attributes.Add("style", "display:none")
                    'btnReset.Attributes.Add("style", "display:none")

                    'GlobalClass.procSearch(ds, pnlFilter)
                End If

                'GlobalClass.procSearch(ds, pnlFilter)

            Catch ex As Exception

            End Try

        End If

        Page.Form.Attributes.Add("enctype", "multipart/form-data")

        Dim currPageScriptManager As ScriptManager = TryCast(ScriptManager.GetCurrent(Page), ScriptManager)
        currPageScriptManager.RegisterPostBackControl(btnSaveLetter)

    End Sub

    Private Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearch.Click
        Dim ds As SqlDataSource = SqlDataSourceGrid
        'GlobalClass.procSearch(ds, pnlFilter)
        GridView1.DataBind()
    End Sub

    Private Sub btnReset_Click(sender As Object, e As EventArgs) Handles btnReset.Click
        Dim urlraw As String = Request.RawUrl
        'Dim urlnew As String = urlraw.Replace("&pid=6", "")
        'Response.Redirect(urlnew)
        Response.Redirect(Request.RawUrl)
    End Sub

    Protected Sub GridView1_PageIndexChanged(sender As Object, e As EventArgs) Handles GridView1.PageIndexChanged
        CallFilter()
    End Sub

    Private Sub CallFilter()
        Dim ds As SqlDataSource = SqlDataSourceGrid
        'GlobalClass.procSearch(ds, pnlFilter)
    End Sub

    Private Sub FormView1_DataBound(sender As Object, e As EventArgs) Handles FormView1.DataBound
        '// page name initial

        initPageName()

        Dim ddl As DropDownList = DirectCast(FormView1.FindControl("DDL_JenisLesen"), DropDownList)
        Dim tbid As TextBox = DirectCast(FormView1.FindControl("TB_PemohonID"), TextBox)
        Dim tbname As TextBox = DirectCast(FormView1.FindControl("TB_Name"), TextBox)
        Dim tbnation As TextBox = DirectCast(FormView1.FindControl("TB_Nat"), TextBox)
        Dim tbaddress As TextBox = DirectCast(FormView1.FindControl("TB_Address"), TextBox)
        Dim tbnote As TextBox = DirectCast(FormView1.FindControl("TB_Remarks"), TextBox)

        Dim pnla As Panel = DirectCast(FormView1.FindControl("pnlesen1"), Panel)
        Dim pnla1 As Panel = DirectCast(FormView1.FindControl("pnlesen1a"), Panel)
        Dim pnla2 As Panel = DirectCast(FormView1.FindControl("pnlesen1b"), Panel)
        Dim pnla3 As Panel = DirectCast(FormView1.FindControl("pnlesen1c"), Panel)
        Dim pnla4 As Panel = DirectCast(FormView1.FindControl("pnlesen1d"), Panel)
        Dim pnla5 As Panel = DirectCast(FormView1.FindControl("pnlesen1e"), Panel)

        Dim pnlb As Panel = DirectCast(FormView1.FindControl("pnlesen2"), Panel)

        Dim pnlc As Panel = DirectCast(FormView1.FindControl("pnlesen3"), Panel)

        Dim pnld As Panel = DirectCast(FormView1.FindControl("pnlesen4"), Panel)

        Dim pnle As Panel = DirectCast(FormView1.FindControl("pnlesen5"), Panel)

        Dim pnlbillboard As Panel = DirectCast(FormView1.FindControl("pnlbillboard"), Panel)

        Dim ddl2 As DropDownList = DirectCast(FormView1.FindControl("DDL_JenisBatal"), DropDownList)
        Dim pnlbatal1 As Panel = DirectCast(FormView1.FindControl("pnlbatal3"), Panel)
        Dim pnlbatal2 As Panel = DirectCast(FormView1.FindControl("pnlbatal4"), Panel)

        Try
            If FormView1.CurrentMode = FormViewMode.Edit Then

                Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

                    myConnection.Open()

                    Dim SQL As String = "SELECT a.*, b.name FROM LESEN_Pemohon a " &
                                "INNER JOIN TBL_LOOKUPS b ON a.Pemohon_Nationality = b.id WHERE a.Pemohon_ID = @Pemohon_ID"

                    Dim myCommandSelect As New SqlCommand(SQL, myConnection)
                    myCommandSelect.Parameters.AddWithValue("@Pemohon_ID", tbid.Text)

                    Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

                    Try
                        If myReader.Read Then

                            tbname.Text = myReader.Item("Pemohon_Name").ToString
                            tbnation.Text = myReader.Item("name").ToString
                            tbaddress.Text = myReader.Item("Pemohon_Address").ToString
                            tbnote.Text = myReader.Item("Pemohon_Remarks").ToString

                        Else
                            tbnote.Text = "NULL"
                            tbname.Text = "NULL"
                            tbnation.Text = "NULL"
                            tbaddress.Text = "NULL"

                            ShowAlert("error", "", "Rekod pemohon tiada di dalam sistem")

                        End If

                    Catch ex As Exception

                    End Try

                End Using

                Select Case ddl.SelectedValue
                    Case 3                      'Lesen Anjing /
                        pnlc.Visible = True
                    Case 2, 25                      'Pasar Lambak, Tambah Petak /
                        pnlb.Visible = True
                    Case 4                      'Pasar Penjaja /
                        pnld.Visible = True
                    Case 1                      'Lesen Perniagaan /
                        pnla.Visible = True
                        pnla1.Visible = True
                    Case 6, 7                     'Tukar Alamat Perniagaan /
                        pnla.Visible = True
                        pnla1.Visible = True
                        pnla3.Visible = True
                    Case 13, 17, 18                      'Permit Kaki Lima, Lot Tepi Kedai, Lebuh Awam /
                        pnla.Visible = True
                    Case 14                         'Pembatalan Lesen & Wang Amanah
                        pnla.Visible = True
                    Case 11, 23, 26                     'Tukar Nama Syarikat /
                        pnla.Visible = True
                        pnla1.Visible = True
                        pnla3.Visible = True
                        pnla5.Visible = True
                    Case 9, 24                     'Tukar Pemilik Perniagaan /
                        pnla.Visible = True
                        pnla1.Visible = True
                        pnla3.Visible = True
                        pnla2.Visible = True
                    Case 10, 12, 16                     'Tukar, Pengurangan Visual Iklan /
                        pnla.Visible = True
                        pnla1.Visible = True
                    Case 5                          ' billboard /
                        pnla.Visible = True
                        pnla1.Visible = True
                        pnlbillboard.Visible = True
                    Case 8                     'Jenis Perniagaan /
                        pnla.Visible = True
                        pnla3.Visible = True
                        pnla4.Visible = True
                    Case 15                     'Expo /
                        pnle.Visible = True
                    Case 19
                        pnla.Visible = True
                        pnla1.Visible = True
                        pnla3.Visible = True
                        pnla5.Visible = True
                    Case 20
                        pnla.Visible = True
                        pnla1.Visible = True
                        pnla2.Visible = True
                        pnla3.Visible = True


                End Select

                If ddl2.SelectedIndex = 1 Then
                    pnlbatal1.Visible = True
                ElseIf ddl2.SelectedIndex = 2 Then
                    pnlbatal2.Visible = True
                End If

            End If
        Catch ex As Exception
            'schedule.Visible = False
        End Try

    End Sub

    Private Sub initPageName()
        '// get page name
        Dim menuName As String = GlobalClass.writeTitlePage(Request.QueryString("m_Id"), "")

        Dim idWindowTitle2 As HtmlGenericControl = DirectCast(FormView1.FindControl("idWindowTitle2"), HtmlGenericControl)
        Dim idWindowTitle3 As HtmlGenericControl = DirectCast(FormView1.FindControl("idWindowTitle3"), HtmlGenericControl)

        If menuName = "" Then
            menuName = "Permohonan"
        End If

        idWindowTitle.InnerText = menuName
        Try
            idWindowTitle2.InnerText = idWindowTitle2.InnerText & " " & menuName
        Catch ex As Exception

        End Try
        Try
            idWindowTitle3.InnerText = idWindowTitle3.InnerText & " " & menuName
        Catch ex As Exception

        End Try

    End Sub

    Protected Sub OnClickBtnSubmit(ByVal sender As Object, ByVal e As CommandEventArgs)

        Dim counter As Integer = 0
        Dim counter1 As Integer = 0
        Dim extstr As String = ""
        Dim hfid As HiddenField = DirectCast(FormView1.FindControl("HF_PermohonanID"), HiddenField)
        Dim cb As CheckBox = DirectCast(FormView1.FindControl("CB_IsBatal"), CheckBox)
        Dim ddl As DropDownList = DirectCast(FormView1.FindControl("DDL_JenisLesen"), DropDownList)

        If reviewSurat(cb.Checked) Then

            If cb.Checked Then
                extstr = "Batal"
            End If

            Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

                myConnection.Open()

                Dim Sql1 = "SELECT COUNT(PermohonanAgensi_ID) AS agensi FROM LESEN_PermohonanAgensi" & extstr & " WHERE Permohonan_ID=" & hfid.Value

                Dim myCommand1 = New SqlCommand(Sql1, myConnection)

                Dim myReader As SqlDataReader = myCommand1.ExecuteReader

                If myReader.Read Then
                    counter = myReader.Item("agensi")
                End If

                myCommand1.Dispose()
                myConnection.Close()

                If counter < 1 And cb.Checked = False And ddl.SelectedValue <> 9 Then
                    ShowAlert("error", "", "Gagal hantar. Sila tambah jabatan agensi")
                    Return
                End If

                '//
                Dim result2 = insertMaklumatPembetulan(CInt(hfid.Value))

                If result2 = False Then
                    ShowAlert("error", "", "Gagal proses database. Sila tekan Hantar sekali lagi." & hfid.Value)
                    Return
                End If

                myConnection.Open()

                Dim Sql = "UPDATE LESEN_Permohonan SET StatusID=1 WHERE StatusID=0 AND Permohonan_ID=" & hfid.Value

                Dim myCommand = New SqlCommand(Sql, myConnection)

                'Dim myReader As SqlDataReader = myCommand.ExecuteReader
                Dim result = myCommand.ExecuteNonQuery()

                myCommand.Dispose()
                myConnection.Close()

                If result < 1 Then
                    ShowAlert("error", "", "Gagal hantar")
                Else
                    ShowAlert("success", "", "Berjaya hantar")
                    GridView1.DataBind()
                    backToList()
                End If

            End Using

        Else
            ShowAlert("error", "", "Surat Belum Habis Disemak")
            TabContainer1.ActiveTabIndex = 5
        End If

    End Sub

    Private Function reviewSurat(checked As Boolean) As Boolean
        Dim retval As Boolean = True
        Dim hfid As HiddenField = DirectCast(FormView1.FindControl("HF_PermohonanID"), HiddenField)

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQL As String = ""

            If checked Then
                SQL = "select * from LESEN_PermohonanAgensiBatal where Permohonan_ID = @Permohonan_ID and isnull(reviewStatusID,0) IN (0,1,3) "
            Else
                SQL = "select * from LESEN_PermohonanAgensi where Permohonan_ID = @Permohonan_ID and isnull(reviewStatusID,0) IN (0,1,3) "
            End If

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", CInt(hfid.Value))

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            Try
                If myReader.Read Then

                    retval = False
                End If

            Catch ex As Exception

            End Try

            myConnection.Close()

        End Using

        Return retval
    End Function

    Private Sub backToList()
        whiteCard.Visible = True
        TabContainer1.Visible = False
        GridView1.SelectedIndex = -1
    End Sub

    Private Sub FormViewMaintenanceTemplate_ItemInserting(sender As Object, e As FormViewInsertEventArgs) Handles FormViewMaintenanceTemplate.ItemInserting

    End Sub

    Private Sub FormViewMaintenanceTemplate_DataBound(sender As Object, e As EventArgs) Handles FormViewMaintenanceTemplate.DataBound


    End Sub



    Protected Sub btnUpload_Click(sender As Object, e As EventArgs)

        Dim btn As Button = CType(sender, Button)
        Dim row As GridViewRow = CType(btn.NamingContainer, GridViewRow)

    End Sub

    Protected Sub btnAddNewUpload_Click(sender As Object, e As EventArgs)

        Dim Permohonan_ID As Integer = CInt(GridView1.SelectedValue)

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Dim SQL As String = ""

            SQL = "INSERT INTO LESEN_PermohonanFail (PermohonanFail_PermohonanID,CreatedDt,CreatorID) VALUES 
                 (@Permohonan_ID, getdate(), @SessionUserName) "

            Dim myCommand As New SqlCommand(SQL, myConnection)

            myCommand.Parameters.AddWithValue("@Permohonan_ID", Permohonan_ID)
            myCommand.Parameters.AddWithValue("@SessionUsersId", Session.Item("SessionUsersId"))
            myCommand.Parameters.AddWithValue("@SessionUserName", Session.Item("SessionUserName"))

            myConnection.Open()

            Dim recordset As Integer = myCommand.ExecuteNonQuery()

            '//start insert

            If recordset Then
                gvTabUlasan.EditIndex = CInt(gvTabUlasan.Rows.Count)

            End If

            myConnection.Close()

            gvTabUlasan.DataBind()

            Page.SetFocus(Me.ui_btnPageBottom.ClientID)

        End Using

    End Sub

    Private Sub gvTabUlasan_RowUpdated(sender As Object, e As GridViewUpdatedEventArgs) Handles gvTabUlasan.RowUpdated
        '//
    End Sub
    Private Sub gvTabUlasan_RowUpdating(sender As Object, e As GridViewUpdateEventArgs) Handles gvTabUlasan.RowUpdating


        Dim LinkButton1 As LinkButton = CType(gvTabUlasan.Rows(e.RowIndex).FindControl("LinkButton1"), LinkButton)
        'Dim updatePanelUlasan As UpdatePanel = CType(gvTabUlasan.Rows(e.RowIndex).FindControl("updatePanelUlasan"), UpdatePanel)
        Dim fu As FileUpload = CType(gvTabUlasan.Rows(e.RowIndex).FindControl("FU_PermohonanFail"), FileUpload)
        'Dim txtPermohonanFail_FilePath As FileUpload = CType(gvTabUlasan.Rows(e.RowIndex).FindControl("txtPermohonanFail_FilePath"), FileUpload)
        Dim btnUpload As Button = CType(gvTabUlasan.Rows(e.RowIndex).FindControl("btnUpload"), Button)

        If fu.HasFiles = False Then
            'MessageBox("Muat naik fail gagal.", Me)
            Return
        End If

        Dim uid As Guid = Guid.NewGuid()
        Dim fn As String = System.IO.Path.GetFileName(fu.PostedFile.FileName)
        Dim localPath As String = "~/doc/" & "" & uid.ToString & fn
        Dim SaveLocation As String = Server.MapPath(localPath)

        If (fu.PostedFile IsNot Nothing) AndAlso (fu.PostedFile.ContentLength > 0) Then

            '//delete previous file
            If e.OldValues("PermohonanFail_FilePath") <> "" Then

                Dim deleteFilePath As String = Server.MapPath(e.OldValues("PermohonanFail_FilePath"))

                If System.IO.File.Exists(deleteFilePath) Then
                    System.IO.File.Delete(deleteFilePath)
                End If

            End If

            If updateUploadFile(fu, SaveLocation) Then

                e.NewValues("PermohonanFail_FileName") = fu.PostedFile.FileName
                e.NewValues("PermohonanFail_ContentType") = fu.PostedFile.ContentType
                e.NewValues("PermohonanFail_FilePath") = localPath

            Else

            End If


        Else

            'e.NewValues("UlasanFail_FileName") = e.OldValues("UlasanFail_FileName")
            'e.NewValues("UlasanFail_ContentType") = e.OldValues("UlasanFail_ContentType")
            'e.NewValues("UlasanFail_FilePath") = e.OldValues("UlasanFail_FilePath")
        End If



    End Sub

    Private Function updateUploadFile(txtUlasanFail_FilePath As FileUpload, saveLocation As String) As Boolean
        'lblDummy.Text = saveLocation
        Dim retval As Boolean = True

        If (txtUlasanFail_FilePath.PostedFile IsNot Nothing) AndAlso (txtUlasanFail_FilePath.PostedFile.ContentLength > 0) Then

            Try
                Dim fileExtention As String = txtUlasanFail_FilePath.PostedFile.ContentType
                Dim fileLenght As Integer = txtUlasanFail_FilePath.PostedFile.ContentLength

                If fileExtention = "image/png" OrElse fileExtention = "image/jpeg" OrElse fileExtention = "image/x-png" Then

                    '//image
                    If fileLenght <= (1048576 * 5) Then '1048576 => 1M
                        Dim bmpPostedImage As Bitmap = New Bitmap(txtUlasanFail_FilePath.PostedFile.InputStream)
                        Dim objImage As System.Drawing.Image = ScaleImage(bmpPostedImage, 1024)
                        objImage.Save(saveLocation, ImageFormat.Jpeg)

                        'MessageBox("Fail berjaya dimuatnaik", Me)

                    Else
                        MessageBox("Image size cannot be more then 5 MB!", Me)
                        retval = False
                    End If
                Else

                    '//not image
                    If fileLenght <= (1048576 * 5) Then '1048576 => 1M
                        'Dim bmpPostedImage As System.Drawing.Bitmap = New System.Drawing.Bitmap(txtUlasanFail_FilePath.PostedFile.InputStream)
                        'Dim objImage As System.Drawing.Image = ScaleImage(bmpPostedImage, 1024)
                        'objImage.Save(SaveLocation, ImageFormat.Jpeg)

                        Try
                            txtUlasanFail_FilePath.PostedFile.SaveAs(saveLocation)
                        Catch ex As Exception
                            MessageBox(ex.Message, Me)
                        End Try


                        'MessageBox("Fail berjaya dimuatnaik", Me)

                    Else
                        MessageBox("Image size cannot be more then 5 MB!", Me)
                        retval = False
                    End If

                End If

            Catch ex As Exception
                MessageBox(ex.Message, Me)
                retval = False
                'lblmsg.Text = "Error: " & ex.Message
                'lblmsg.Style.Add("Color", "Red")
            End Try
        Else
            MessageBox("Muat naik fail gagal. Sila cuba sekali lagi", Me)
            retval = False
        End If

        Return retval
    End Function

    Public Property OriginalImageSize As Size
    Public Property NewImageSize As Size

    Public Shared Function ScaleImage(ByVal image As System.Drawing.Image, ByVal maxHeight As Integer) As Image
        Dim ratio = CDbl(maxHeight) / image.Height
        Dim newWidth = CInt((image.Width * ratio))
        Dim newHeight = CInt((image.Height * ratio))
        Dim newImage = New Bitmap(newWidth, newHeight)

        Using g = Graphics.FromImage(newImage)
            g.DrawImage(image, 0, 0, newWidth, newHeight)
        End Using

        Return newImage
    End Function

    Private Sub gvTabUlasan_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvTabUlasan.RowDataBound

        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim btnUpload As Button = CType(e.Row.Cells(0).FindControl("btnUpload"), Button)
            Dim LinkButton1 As LinkButton = CType(e.Row.Cells(0).FindControl("LinkButton1"), LinkButton)

            If btnUpload IsNot Nothing Then

                Dim currPageScriptManager As ScriptManager = TryCast(ScriptManager.GetCurrent(Page), ScriptManager)

                'RegisterAsyncPostBackControl
                'currPageScriptManager.RegisterPostBackControl(btnUpload)
                currPageScriptManager.RegisterPostBackControl(LinkButton1)

            End If
        End If


    End Sub

    Private Sub gvTabUlasan_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvTabUlasan.RowDeleting


        If e.Values("PermohonanFail_FilePath") <> "" Then

            Dim deleteFilePath As String = Server.MapPath(e.Values("PermohonanFail_FilePath"))

            If System.IO.File.Exists(deleteFilePath) Then
                System.IO.File.Delete(deleteFilePath)
            End If

        End If

    End Sub

    Private Sub gvTabUlasan_DataBound(sender As Object, e As EventArgs) Handles gvTabUlasan.DataBound
    End Sub

    Private Sub GridViewMaintenanceTemplate_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles GridViewMaintenanceTemplate.RowCommand
        Dim intRow As Integer = CInt(e.CommandArgument)
        Dim PermohonanAgensi_ID As String = CStr(Me.GridViewMaintenanceTemplate.DataKeys(intRow)("PermohonanAgensi_ID"))
        Dim JenisLesenID As Integer = CInt(Me.GridViewMaintenanceTemplate.DataKeys(intRow)("JenisLesen_ID"))
        Dim JabatanAgensi_ID As Integer = CInt(Me.GridViewMaintenanceTemplate.DataKeys(intRow)("JabatanAgensi_ID"))
        Dim Permohonan_ID As Integer = CInt(GridView1.SelectedDataKey.Values(0))

        If e.CommandName = "Surat" Then

            ViewSuratMohonAuto(PermohonanAgensi_ID, JabatanAgensi_ID, JenisLesenID, False)

        ElseIf e.CommandName = "review" Then

            Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

                Dim SQL As String = ""

                SQL = "UPDATE LESEN_PermohonanAgensi SET reviewStatusID = 1,kbID=NULL,kjID=NULL,kjReview='',kbReview='',
             kbApproval=NULL,kjApproval=NULL
             WHERE PermohonanAgensi_ID = @PermohonanAgensi_ID"
                Dim myCommand As New SqlCommand(SQL, myConnection)
                myCommand.Parameters.AddWithValue("@PermohonanAgensi_ID", PermohonanAgensi_ID)
                myConnection.Open()

                Dim recordset As Integer = myCommand.ExecuteNonQuery()

                myConnection.Close()

                GridViewMaintenanceTemplate.DataBind()

                MessageBox("Berjaya dihantar untuk semakan surat", Me)

                'Page.SetFocus(Me.ui_btnPageBottom.ClientID)

            End Using

        End If
    End Sub

    Private Sub GridViewJabatanAgensiBatal_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles GridViewJabatanAgensiBatal.RowCommand
        Dim intRow As Integer = CInt(e.CommandArgument)
        Dim PermohonanAgensi_ID As String = CStr(Me.GridViewJabatanAgensiBatal.DataKeys(intRow)("PermohonanAgensi_ID"))
        Dim JenisLesenID As Integer = CInt(Me.GridViewJabatanAgensiBatal.DataKeys(intRow)("JenisLesen_ID"))
        Dim JabatanAgensi_ID As Integer = CInt(Me.GridViewJabatanAgensiBatal.DataKeys(intRow)("JabatanAgensi_ID"))
        Dim Permohonan_ID As Integer = CInt(GridView1.SelectedDataKey.Values(0))

        If e.CommandName = "Surat" Then

            ViewSuratMohonAuto(PermohonanAgensi_ID, JabatanAgensi_ID, JenisLesenID, True)

        ElseIf e.CommandName = "review" Then

            Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
                Dim SQL As String = ""

                SQL = "UPDATE LESEN_PermohonanAgensiBatal SET reviewStatusID = 1,kbID=NULL,kjID=NULL,kjReview='',kbReview='',
             kbApproval=NULL,kjApproval=NULL
             WHERE PermohonanAgensi_ID = @PermohonanAgensi_ID"
                Dim myCommand As New SqlCommand(SQL, myConnection)
                myCommand.Parameters.AddWithValue("@PermohonanAgensi_ID", PermohonanAgensi_ID)
                myConnection.Open()

                Dim recordset As Integer = myCommand.ExecuteNonQuery()
                myConnection.Close()
                GridViewJabatanAgensiBatal.DataBind()

                MessageBox("Berjaya dihantar untuk semakan surat", Me)

                'Page.SetFocus(Me.ui_btnPageBottom.ClientID)

            End Using
        End If
    End Sub

    Private Sub ViewSuratMohonFail(permohonanID As String)

        Dim filepath As String = ""

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQL As String = "SELECT PermohonanFail_FilePath FROM LESEN_PermohonanFail WHERE PermohonanFail_PermohonanID = @permohonanID AND PermohonanFail_JenisLampiran = 'SM'"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@permohonanID", permohonanID)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            Try
                If myReader.Read Then

                    filepath = myReader.Item("PermohonanFail_FilePath")
                    filepath = filepath.Remove(0, 1)
                    ScriptManager.RegisterClientScriptBlock(Me.Page, Me.[GetType](), "", "window.open('.." + filepath + "', '_blank', '');", True)
                End If

            Catch ex As Exception

            End Try

            myReader.Close()
            myConnection.Close()

        End Using

    End Sub

    Private Sub ViewSuratMohonAuto(permohonanAgensiID As String, jabatanAgensiID As Integer, jenislesenID As Integer, isBatal As Boolean)
        Dim strBatal As String = ""
        Dim sql As String = ""
        Dim jenisLesenDesc = {"", "smu_perniagaan", "smu_pasar", "smu_anjing", "smu_penjaja", "smu_billboard", "smu_tukaralamat", "smu_tambahpremis", "smu_tambahjenis",
            "smu_tukarpemilik", "smu_tukariklan", "smu_tukarnama", "smu_kurangiklan", "smu_kakilima", "null", "null", "smu_tambahiklan", "smu_tepikedai", "smu_lebuhawam",
            "smu_tukaralamatnamaiklan", "smu_tukarpemilikalamatiklan", "null", "null", "smu_tukarnamaiklan", "smu_tukarpemilikiklan", "smu_pasartambahpetak", "smu_tukarnamatambahpremis"}
        Dim jenisLesenDescLuar = {"", "smul_perniagaan", "smul_pasar", "smul_anjing", "smul_penjaja", "smul_billboard", "smul_tukaralamat", "smul_tambahpremis", "smul_tambahjenis",
            "smul_tukarpemilik", "smul_tukariklan", "smul_tukarnama", "smul_kurangiklan", "smul_kakilima", "null", "null", "smul_tambahiklan", "smul_tepikedai", "smul_lebuhawam",
            "smul_tukaralamatnamaiklan", "smul_tukarpemilikalamatiklan", "null", "null", "smul_tukarnamaiklan", "smul_tukarpemilikiklan", "smul_pasartambahpetak", "smul_tukarnamatambahpremis"}

        If isBatal Then
            strBatal = "Batal"
        End If

        Try

            sql = "SELECT a.*, f.name AS AnjingBakaDesc, e.JabatanAgensi_Address, e.JabatanAgensi_Kepada, c.JenisLesen_Description, b.Pemohon_Name, b.Pemohon_ICNo, b.Pemohon_PassportNo, b.Pemohon_Address, b.Pemohon_Email, b.Pemohon_MobileNo, b.Pemohon_TelNo, g.Users_Fullname, g.Users_Signature " &
                    "FROM LESEN_Permohonan a INNER JOIN LESEN_Pemohon b ON a.Permohonan_PemohonID = b.Pemohon_ID INNER JOIN LESEN_JenisLesen c ON a.JenisLesen_ID = c.JenisLesen_ID INNER JOIN LESEN_PermohonanAgensi" & strBatal & " d ON a.Permohonan_ID = d.Permohonan_ID " &
                    "INNER JOIN LESEN_JabatanAgensi e ON d.JabatanAgensi_ID = e.JabatanAgensi_ID LEFT JOIN TBL_LOOKUPS f ON f.id = a.AnjingBaka LEFT JOIN TBL_USERS g ON g.Users_Id = (case when e.JabatanAgensi_Type = 'J' then a.TandatanganMohonUlasanId when e.JabatanAgensi_Type = 'L' then a.TandatanganMohonUlasanLuarId end) " &
                    "WHERE d.PermohonanAgensi_ID=" & permohonanAgensiID

            Dim ReportVar As String = jenisLesenDesc(jenislesenID)

            If jabatanAgensiID > 3 Then
                ReportVar = jenisLesenDescLuar(jenislesenID)
            End If

            Dim pobjData(0, 1)
            Dim lStrReportName = ReportVar + ".rpt"

            'Dim sessionActiveMonthYearID As String = GlobalClass.getIDActiveMonthByEstateID(Session.Item("sessionEstateCode"), DirectCast(FormView1.FindControl("cmbYear"), DropDownList).SelectedValue, DirectCast(FormView1.FindControl("cmbMonth"), DropDownList).SelectedValue)

            pobjData(0, 0) = "paraSQL" : pobjData(0, 1) = sql

            Session.Item("ReportName" + ReportVar) = lStrReportName
            Session.Item("pobjData" + ReportVar) = pobjData
            Session.Item("pathUrl" + ReportVar) = "~/lesen/report/mohonulasan"
            'MessageBox(Session.Item("pathUrl" + ReportVar), Me)


            Session.Item("reportPrintType") = "pdf"
            ScriptManager.RegisterClientScriptBlock(Me.Page, Me.[GetType](), ReportVar, "window.open('../ReportViewer.aspx?name=" + ReportVar + "', '_blank', '');", True)
        Catch ex As Exception
            MessageBox(ex.Message, Me)
        End Try

    End Sub

    Protected Sub cbman_CheckedChanged(sender As Object, e As EventArgs)

        Dim cb As CheckBox = DirectCast(sender, CheckBox)
        Dim row = DirectCast(cb.NamingContainer, GridViewRow)
        Dim paId = DirectCast(row.FindControl("itemID"), Label).Text

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Dim SQL As String = ""

            SQL = "UPDATE LESEN_PermohonanAgensi SET IsMandatory = @IsMandatory WHERE PermohonanAgensi_ID = @PermohonanAgensi_ID"

            Dim myCommand As New SqlCommand(SQL, myConnection)
            myCommand.Parameters.AddWithValue("@PermohonanAgensi_ID", paId)

            If cb.Checked = True Then
                myCommand.Parameters.AddWithValue("@IsMandatory", 1)
            Else
                myCommand.Parameters.AddWithValue("@IsMandatory", 0)
            End If

            myConnection.Open()

            Dim recordset As Integer = myCommand.ExecuteNonQuery()

            myConnection.Close()

            GridViewMaintenanceTemplate.DataBind()

            MessageBox("Berjaya Dikemaskini", Me)

            'Page.SetFocus(Me.ui_btnPageBottom.ClientID)

        End Using

    End Sub

    Protected Sub cbman_CheckedChanged2(sender As Object, e As EventArgs)

        Dim cb As CheckBox = DirectCast(sender, CheckBox)
        Dim row = DirectCast(cb.NamingContainer, GridViewRow)
        Dim paId = DirectCast(row.FindControl("itemID"), Label).Text

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Dim SQL As String = ""

            SQL = "UPDATE LESEN_PermohonanAgensiBatal SET IsMandatory = @IsMandatory WHERE PermohonanAgensi_ID = @PermohonanAgensi_ID"

            Dim myCommand As New SqlCommand(SQL, myConnection)
            myCommand.Parameters.AddWithValue("@PermohonanAgensi_ID", paId)

            If cb.Checked = True Then
                myCommand.Parameters.AddWithValue("@IsMandatory", 1)
            Else
                myCommand.Parameters.AddWithValue("@IsMandatory", 0)
            End If

            myConnection.Open()

            Dim recordset As Integer = myCommand.ExecuteNonQuery()

            myConnection.Close()

            GridViewMaintenanceTemplate.DataBind()

            MessageBox("Berjaya Dikemaskini", Me)

            'Page.SetFocus(Me.ui_btnPageBottom.ClientID)

        End Using

    End Sub	

    Protected Sub ddl_Pemohon_SelectedIndexChanged(sender As Object, e As EventArgs)

        'MessageBox("DEBUG", Me)

        Dim ddl As DropDownList = DirectCast(FormView1.FindControl("ddl_Pemohon"), DropDownList)
        Dim tbid As TextBox = DirectCast(FormView1.FindControl("TB_PemohonID"), TextBox)
        Dim tbname As TextBox = DirectCast(FormView1.FindControl("TB_Name"), TextBox)
        Dim tbnation As TextBox = DirectCast(FormView1.FindControl("TB_Nat"), TextBox)
        Dim tbaddress As TextBox = DirectCast(FormView1.FindControl("TB_Address"), TextBox)
        Dim tbnote As TextBox = DirectCast(FormView1.FindControl("TB_Remarks"), TextBox)
        Dim pnl As Panel = DirectCast(FormView1.FindControl("pnlpemohon"), Panel)

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQL As String = "SELECT a.*, b.name FROM LESEN_Pemohon a " &
                                "INNER JOIN TBL_LOOKUPS b ON a.Pemohon_Nationality = b.id WHERE a.Pemohon_ID = @Pemohon_ID"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Pemohon_ID", ddl.SelectedValue)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            Try
                If myReader.Read Then

                    tbid.Text = myReader.Item("Pemohon_ID").ToString
                    'tbname.Text = HttpUtility.UrlEncode(myReader.Item("Pemohon_Name").ToString)
                    tbname.Text = myReader.Item("Pemohon_Name").ToString
                    tbnation.Text = myReader.Item("name").ToString
                    tbaddress.Text = myReader.Item("Pemohon_Address").ToString
                    tbnote.Text = myReader.Item("Pemohon_Remarks").ToString

                    pnl.Visible = True
                    ShowAlert("success", "", "Rekod pemohon jumpa")

                Else
                    tbnote.Text = "NULL"
                    tbname.Text = "NULL"
                    tbnation.Text = "NULL"
                    tbaddress.Text = "NULL"

                    pnl.Visible = False
                    ShowAlert("error", "", "Rekod pemohon tiada di dalam sistem")

                End If

            Catch ex As Exception

            End Try

            myConnection.Close()

        End Using
    End Sub

    Protected Sub btnAddNew_Click(sender As Object, e As EventArgs)
        Dim Permohonan_ID As Integer = CInt(GridView1.SelectedDataKey.Values(0))

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Dim SQL As String = ""

            SQL = "Insert Into LESEN_KadarBayaran (KadarBayaran_PermohonanID,KadarBayaran_PermohonanAgensiID,KadarBayaran_UserID,CreatedDt,CreatorID) Values 
                 (@Permohonan_ID,case when @AgensiId = 0 then NULL else @AgensiId end,@SessionUsersID, getdate(), @SessionUserName)  "

            Dim myCommand As New SqlCommand(SQL, myConnection)

            myCommand.Parameters.AddWithValue("@Permohonan_ID", Permohonan_ID)
            myCommand.Parameters.AddWithValue("@AgensiId", Session.Item("SessionEstateId"))
            myCommand.Parameters.AddWithValue("@SessionUsersId", Session.Item("SessionUsersId"))
            myCommand.Parameters.AddWithValue("@SessionUserName", Session.Item("SessionUserName"))

            myConnection.Open()

            Dim recordset As Integer = myCommand.ExecuteNonQuery()

            '//start insert - tab bayaran

            If recordset Then
                gvTabBayaran.EditIndex = CInt(gvTabBayaran.Rows.Count)

            End If

            myConnection.Close()

            gvTabBayaran.DataBind()

            Page.SetFocus(Me.ui_btnPageBottom.ClientID)

        End Using
    End Sub

    Protected Sub CB_Deposit_CheckedChanged(sender As Object, e As EventArgs)

        Dim cb As CheckBox = DirectCast(FormView1.FindControl("CB_Deposit"), CheckBox)
        Dim pnl As Panel = DirectCast(FormView1.FindControl("pnldeposit"), Panel)

        If cb.Checked = True Then
            pnl.Visible = True
        Else
            pnl.Visible = False
        End If

    End Sub

    Protected Sub CB_IsBatal_CheckedChanged(sender As Object, e As EventArgs)

        Dim cb As CheckBox = DirectCast(FormView1.FindControl("CB_IsBatal"), CheckBox)
        Dim pnl As Panel = DirectCast(FormView1.FindControl("pnlbatal2"), Panel)
        Dim pnla As Panel = DirectCast(FormView1.FindControl("pnldeposit1"), Panel)

        If cb.Checked Then
            pnl.Visible = True
            pnla.Visible = True

        Else
            pnl.Visible = False
            pnla.Visible = False
        End If

    End Sub

    Protected Sub DDL_JenisBatal_SelectedIndexChanged(sender As Object, e As EventArgs)

        Dim ddl As DropDownList = DirectCast(FormView1.FindControl("DDL_JenisBatal"), DropDownList)
        Dim pnl As Panel = DirectCast(FormView1.FindControl("pnlbatal3"), Panel)
        Dim pnl1 As Panel = DirectCast(FormView1.FindControl("pnlbatal4"), Panel)

        pnl.Visible = False
        pnl1.Visible = False

        If ddl.SelectedIndex = 1 Then
            pnl.Visible = True
        ElseIf ddl.SelectedIndex = 2 Then
            pnl1.Visible = True
        End If

    End Sub

    Protected Sub btnSaveLetter_Click(sender As Object, e As EventArgs)

        Dim isSuccess As Boolean = True
        Dim PermohonanID As Integer = CInt(GridView1.SelectedDataKey.Values(0))

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQL As String = "UPDATE LESEN_Permohonan SET TandatanganMohonUlasanId = @TandatanganMohonUlasanId, 
                                    TandatanganMohonUlasanLuarId = @TandatanganMohonUlasanLuarId  
                                    WHERE Permohonan_ID = @Permohonan_ID"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", PermohonanID)
            myCommandSelect.Parameters.AddWithValue("@TandatanganMohonUlasanId", ddlTandatangan.SelectedValue)
            myCommandSelect.Parameters.AddWithValue("@TandatanganMohonUlasanLuarId", ddlTandatanganLuar.SelectedValue)

            Try
                Dim recordset As Integer = myCommandSelect.ExecuteNonQuery()
            Catch ex As Exception
                isSuccess = False
                MessageBox("ERROR", Me)
            End Try

            myConnection.Close()

        End Using

        If isSuccess Then

            ShowAlert("success", "", "Surat mohon ulasan telah dikemaskini.")

        End If

    End Sub

    Protected Sub cbsel_CheckedChanged(sender As Object, e As EventArgs)

        Dim cb As CheckBox = DirectCast(sender, CheckBox)
        Dim row = DirectCast(cb.NamingContainer, GridViewRow)
        Dim kbId = DirectCast(row.FindControl("Label1"), Label).Text

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Dim SQL As String = ""

            SQL = "UPDATE LESEN_KadarBayaran SET IsSelect = @IsSelect WHERE KadarBayaran_ID = @KadarBayaran_ID"

            Try

                Dim myCommand As New SqlCommand(SQL, myConnection)
                myCommand.Parameters.AddWithValue("@KadarBayaran_ID", kbId)

                If cb.Checked = True Then
                    myCommand.Parameters.AddWithValue("@IsSelect", 1)
                Else
                    myCommand.Parameters.AddWithValue("@IsSelect", 0)
                End If

                myConnection.Open()

                Dim recordset As Integer = myCommand.ExecuteNonQuery()

                myConnection.Close()

                gvTabBayaran.DataBind()

                'Page.SetFocus(Me.ui_btnPageBottom.ClientID)

            Catch ex As Exception
                MessageBox("ERROR", Me)
            End Try

        End Using

    End Sub

    Protected Sub BtnSaveMesyuarat_Click(sender As Object, e As EventArgs)

        Dim PermohonanID As Integer = CInt(GridView1.SelectedDataKey.Values(0))

        'MessageBox(PermohonanID, Me)

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQL As String = "UPDATE LESEN_Permohonan SET TarikhMesyuarat = @TarikhMesyuarat,   
                                    NoMesyuarat = @NoMesyuarat, IsPulang = @IsPulang, TarikhPulang = @TarikhPulang
                                    WHERE Permohonan_ID = @Permohonan_ID"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", PermohonanID)
            myCommandSelect.Parameters.AddWithValue("@TarikhMesyuarat", TB_TarikhMesyuarat.Text)
            myCommandSelect.Parameters.AddWithValue("@NoMesyuarat", TB_NoMesyuarat.Text)
            myCommandSelect.Parameters.AddWithValue("@IsPulang", CB_IsPulang.Checked.ToString())
            myCommandSelect.Parameters.AddWithValue("@TarikhPulang", TB_TarikhPulang.Text)

            Try
                Dim recordset As Integer = myCommandSelect.ExecuteNonQuery()
                ShowAlert("success", "", "Rekod mesyuarat telah dikemaskini.")
            Catch ex As Exception
                MessageBox("ERROR", Me)
            End Try

            myConnection.Close()

        End Using

    End Sub

    Private Sub GetMesyuarat(pid As Integer)

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQL As String = "SELECT TarikhMesyuarat, KeputusanMesyuarat, NoMesyuarat, IsPulang, TarikhPulang FROM LESEN_Permohonan WHERE Permohonan_ID = @Permohonan_ID"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            If myReader.Read Then

                If IsDBNull(myReader.Item("TarikhMesyuarat")) = False Then
                    TB_TarikhMesyuarat.Text = CDate(myReader.Item("TarikhMesyuarat")).ToString("yyyy-MM-dd")
                End If

                TB_NoMesyuarat.Text = myReader.Item("NoMesyuarat").ToString()

                CB_IsPulang.Checked = CBool(myReader.Item("IsPulang"))

                If CB_IsPulang.Checked Then

                    pnlpulang.Visible = True

                End If

                If IsDBNull(myReader.Item("TarikhPulang")) = False Then
                    TB_TarikhPulang.Text = CDate(myReader.Item("TarikhPulang")).ToString("yyyy-MM-dd")
                End If

            End If

            myReader.Close()
            myConnection.Close()

        End Using

    End Sub

    Protected Sub CB_IsPulang_CheckedChanged(sender As Object, e As EventArgs)

        If CB_IsPulang.Checked Then
            pnlpulang.Visible = True
        Else
            pnlpulang.Visible = False
        End If

    End Sub


    Protected Sub DDL_JenisPasar_SelectedIndexChanged(sender As Object, e As EventArgs)

        Dim ddl As DropDownList = DirectCast(FormView1.FindControl("DDL_JenisLesen"), DropDownList)
        Dim noruj As TextBox = DirectCast(FormView1.FindControl("TB_Rujukan"), TextBox)

        Select Case ddl.SelectedIndex
            Case 1                      'Pasar Pagi /
                noruj.Text = "MPK/599/401/26/PP"

            Case 2                      'Pasar Malam /
                noruj.Text = "MPK/599/401/3/33"

            Case 3                      'Pasar Lambak /
                noruj.Text = "MPK/599/401/"

        End Select

    End Sub

    Protected Sub BT_ViewLaporan_Command(sender As Object, e As CommandEventArgs)

        Dim jid As Integer = GridView1.SelectedDataKey.Values(3)
        Dim pid As Integer = GridView1.SelectedDataKey.Values(0)

        If GetIsSuratFail(pid) Then
            ViewSuratPemeriksaanFail(pid)
        Else
            ViewSuratPemeriksaanAuto(pid, jid, True)
        End If

    End Sub

    Private Function GetIsSuratFail(pid As Integer) As Boolean

        Dim isFail As Boolean

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQL As String = "SELECT IsSuratPemeriksaanFail FROM LESEN_Permohonan WHERE Permohonan_ID = @Permohonan_ID"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            Try
                If myReader.Read Then

                    isFail = CBool(myReader.Item("IsSuratPemeriksaanFail"))

                End If

            Catch ex As Exception
                MessageBox("ERROR", Me)
            End Try

            myReader.Close()
            myConnection.Close()

        End Using

        Return isFail

    End Function

    Private Sub ViewSuratPemeriksaanFail(permohonanID As String)

        Dim filepath As String = ""

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQL As String = "SELECT PermohonanFail_FilePath FROM LESEN_PermohonanFail WHERE PermohonanFail_PermohonanID = @permohonanID AND PermohonanFail_JenisLampiran = 'SP'"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@permohonanID", permohonanID)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            Try
                If myReader.Read Then

                    filepath = myReader.Item("PermohonanFail_FilePath")
                    filepath = filepath.Remove(0, 1)
                    ScriptManager.RegisterClientScriptBlock(Me.Page, Me.[GetType](), "", "window.open('.." + filepath + "', '_blank', '');", True)
                End If

            Catch ex As Exception

            End Try

            myReader.Close()
            myConnection.Close()

        End Using

    End Sub

    Private Sub ViewSuratPemeriksaanAuto(permohonanID As String, jenislesenID As Integer, isPDF As Boolean)

        Dim sql As String = ""
        Dim jenisLesenDesc = {"", "sp_perniagaan", "sp_pasar", "sp_anjing", "sp_penjaja", "sp_billboard", "sp_tukaralamat", "sp_tambahpremis", "sp_tambahjenis",
            "sp_tukarpemilik", "sp_tukariklan", "sp_tukarnama", "sp_kurangiklan", "sp_kakilima", "", "", "sp_tambahiklan", "sp_tepikedai", "sp_lebuhawam",
            "sp_tukaralamatnamaiklan", "sp_tukarpemilikalamatiklan", "", "", "sp_tukarnamaiklan", "sp_tukarpemilikiklan", "sp_pasartambahpetak", "sp_tukarnamatambahpremis"}

        Try

            sql = "SELECT b.KadarBayaran_Desc, b.KadarBayaran_Amount, f.*, a.IsBatal, a.Rujukan, a.RujukanInspektorat, a.TarikhPemeriksaan, a.TarikhSuratPemeriksaan, a.SuratPemeriksaan1, a.SuratPemeriksaan2, " &
                    "c.Pemohon_Name, c.Pemohon_Address, c.Pemohon_ICNo, c.Pemohon_MobileNo, c.Pemohon_TelNo, d.Users_Fullname, d.Users_Signature, e.name AS AnjingJenisPremisDesc " &
                    "FROM LESEN_Permohonan a INNER JOIN LESEN_PermohonanPembetulan f ON a.Permohonan_ID = f.Permohonan_ID " &
                    "LEFT JOIN LESEN_KadarBayaran b ON b.KadarBayaran_PermohonanID = a.Permohonan_ID AND b.KadarBayaran_PermohonanAgensiID = 3 " &
                    "INNER JOIN LESEN_Pemohon c ON a.Permohonan_PemohonID = c.Pemohon_ID LEFT JOIN TBL_USERS d ON a.TandatanganPemeriksaanId = d.Users_Id " &
                    "LEFT JOIN TBL_LOOKUPS e ON e.id = a.AnjingJenisPremis " &
                    "WHERE a.Permohonan_ID=" & permohonanID

            If jenislesenID = 4 Then

                sql = "SELECT b.UlasanDesc, f.*, a.IsBatal, a.Rujukan, a.RujukanInspektorat, a.TarikhPemeriksaan, a.TarikhSuratPemeriksaan, a.SuratPemeriksaan1, a.SuratPemeriksaan2, c.Pemohon_Name, c.Pemohon_Address, " &
                        "c.Pemohon_ICNo, c.Pemohon_MobileNo, c.Pemohon_TelNo, d.Users_Fullname, d.Users_Signature " &
                        "FROM LESEN_Permohonan a INNER JOIN LESEN_PermohonanPembetulan f ON a.Permohonan_ID = f.Permohonan_ID LEFT JOIN LESEN_PenjajaUlasan b ON b.PermohonanID = a.Permohonan_ID " &
                        "INNER JOIN LESEN_Pemohon c ON a.Permohonan_PemohonID = c.Pemohon_ID LEFT JOIN TBL_USERS d ON a.TandatanganPemeriksaanId = d.Users_Id " &
                        "WHERE a.Permohonan_ID=" & permohonanID

            End If

            Dim ReportVar As String = jenisLesenDesc(jenislesenID)

            Dim pobjData(0, 1)
            Dim lStrReportName = ReportVar + ".rpt"

            'Dim sessionActiveMonthYearID As String = GlobalClass.getIDActiveMonthByEstateID(Session.Item("sessionEstateCode"), DirectCast(FormView1.FindControl("cmbYear"), DropDownList).SelectedValue, DirectCast(FormView1.FindControl("cmbMonth"), DropDownList).SelectedValue)

            pobjData(0, 0) = "paraSQL" : pobjData(0, 1) = sql

            Session.Item("ReportName" + ReportVar) = lStrReportName
            Session.Item("pobjData" + ReportVar) = pobjData
            Session.Item("pathUrl" + ReportVar) = "~/lesen/report/pemeriksaan"
            'MessageBox(Session.Item("pathUrl" + ReportVar), Me)

            If isPDF Then
                Session.Item("reportPrintType") = "pdf"
            End If

            ScriptManager.RegisterClientScriptBlock(Me.Page, Me.[GetType](), ReportVar, "window.open('../ReportViewer.aspx?name=" + ReportVar + "', '_blank', '');", True)
        Catch ex As Exception
            MessageBox(ex.Message, Me)
        End Try
    End Sub

    Protected Sub btnSaveInfo_Click(sender As Object, e As EventArgs)

        Dim isSuccess As Boolean = True
        Dim PermohonanID As Integer = CInt(GridView1.SelectedDataKey.Values(0))

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQL As String = "UPDATE LESEN_PermohonanPembetulan SET NamaSyarikat = @NamaSyarikat, 
                        NoPendaftaran = @NoPendaftaran, NoAkaun = @NoAkaun, AlamatPremis = @AlamatPremis, JenisPerniagaan = @JenisPerniagaan, PemilikBaru = @PemilikBaru, 
                        AlamatBaru = @AlamatBaru, JenisPerniagaanBaru = @JenisPerniagaanBaru, NamaBaruSyarikat = @NamaBaruSyarikat, SaizIklan = @SaizIklan, 
                        BillboardLokasi = @BillboardLokasi, LokasiPasar1 = @LokasiPasar1, LokasiPasar2 = @LokasiPasar2, LokasiPasar3 = @LokasiPasar3,
                        JenisPasar = @JenisPasar, JenisPerniagaanPasar = @JenisPerniagaanPasar, JumlahPetak = @JumlahPetak, AnjingAlamat = @AnjingAlamat, AnjingJenisPremis = @AnjingJenisPremis, AnjingBaka = @AnjingBaka,
                        AnjingJantan = @AnjingJantan, AnjingBetina = @AnjingBetina, AnjingJantanMandul = @AnjingJantanMandul, AnjingBetinaMandul = @AnjingBetinaMandul, AlamatPenjajaan = @AlamatPenjajaan, 
                        JenisPerniagaanPenjaja = @JenisPerniagaanPenjaja, PenganjurEkspo = @PenganjurEkspo, NamaEkspo = @NamaEkspo, LokasiEkspo = @LokasiEkspo, NoTelEkspo = @NoTelEkspo, 
                        TarikhEkspo1 = @TarikhEkspo1, TarikhEkspo2 = @TarikhEkspo2, MasaEkspo1 = @MasaEkspo1, MasaEkspo2 = @MasaEkspo2, LastModDt = GETDATE() 
                        WHERE Permohonan_ID = @Permohonan_ID"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", PermohonanID)
            myCommandSelect.Parameters.AddWithValue("@NamaSyarikat", TB_NamaSyarikat_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@NoPendaftaran", TB_NoPendaftaran_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@NoAkaun", TB_NoAkaun_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@AlamatPremis", TB_AlamatPremis_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@JenisPerniagaan", TB_JenisPerniagaan_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@PemilikBaru", TB_PemilikBaru_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@AlamatBaru", TB_AlamatBaru_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@JenisPerniagaanBaru", TB_JenisPerniagaanBaru_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@NamaBaruSyarikat", TB_NamaBaruSyarikat_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@SaizIklan", TB_SaizIklan_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@BillboardLokasi", TB_BillboardLokasi_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@LokasiPasar1", TB_LokasiPasar1_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@LokasiPasar2", TB_LokasiPasar2_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@LokasiPasar3", TB_LokasiPasar3_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@JenisPasar", DDL_JenisPasar_ins.SelectedValue)
            myCommandSelect.Parameters.AddWithValue("@JenisPerniagaanPasar", TB_JenisPerniagaanPasar_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@JumlahPetak", TB_JumlahPetak_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@AnjingAlamat", TB_AnjingAlamat_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@AnjingJenisPremis", DDL_AnjingJenisPremis_ins.SelectedValue)
            myCommandSelect.Parameters.AddWithValue("@AnjingBaka", DDL_AnjingBaka_ins.SelectedValue)
            myCommandSelect.Parameters.AddWithValue("@AnjingJantan", TB_AnjingJantan_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@AnjingBetina", TB_AnjingBetina_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@AnjingJantanMandul", TB_AnjingJantanMandul_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@AnjingBetinaMandul", TB_AnjingBetinaMandul_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@AlamatPenjajaan", TB_AlamatPenjajaan_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@JenisPerniagaanPenjaja", TB_JenisPerniagaanPenjaja_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@PenganjurEkspo", TB_PenganjurEkspo_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@NamaEkspo", TB_NamaEkspo_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@LokasiEkspo", TB_LokasiEkspo_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@NoTelEkspo", TB_NoTel_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@TarikhEkspo1", TB_TarikhEkspo1_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@TarikhEkspo2", TB_TarikhEkspo2_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@MasaEkspo1", TB_MasaEkspo1_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@MasaEkspo2", TB_MasaEkspo2_ins.Text)

            Try
                Dim recordset As Integer = myCommandSelect.ExecuteNonQuery()
                ShowAlert("success", "", "Pembetulan maklumat permohonan telah dikemaskini.")
            Catch ex As Exception
                isSuccess = False
                MessageBox(ex.Message, Me)
            End Try

            myConnection.Close()

        End Using

    End Sub

End Class
