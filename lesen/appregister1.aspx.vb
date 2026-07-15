
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Drawing.Imaging
Imports System.Security.Cryptography
Imports System.Security.Policy
Imports DocumentFormat.OpenXml.Bibliography
Imports Microsoft.SqlServer.Management.Smo

<Serializable()>
Public Class SelectedItem
    Public Property ItemText As String
    Public Property ItemValue As String
End Class

Partial Class appregister1
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
        'Dim jid As Integer = CInt(GridView1.SelectedDataKey.Values("JenisLesen_ID"))
        Dim ispublish As Boolean = CBool(GridView1.SelectedDataKey.Values("IsPublish"))
        Dim jidList() As String = CStr(GridView1.SelectedDataKey.Values("JenisLesenIdList")).Split(","c)

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
            PanelAccessPembetulan(0, True)

            For Each item In jidList
                PanelAccessPembetulan(item, False)
            Next

            GetPermohonanPembetulan(pid, isbatal)
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

    Private Sub PanelAccess(lesenid As Integer, clrflag As Boolean)

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

        Dim pnl6 As Panel = DirectCast(FormView1.FindControl("pnlesen6"), Panel)

        Dim pnlf As Panel = DirectCast(FormView1.FindControl("pnlrujukan"), Panel)

        Dim pnlbatal1 As Panel = DirectCast(FormView1.FindControl("pnlbatal1"), Panel)

        Dim pnlbillboard As Panel = DirectCast(FormView1.FindControl("pnlbillboard"), Panel)

        Dim noruj As TextBox = DirectCast(FormView1.FindControl("TB_Rujukan"), TextBox)

        If clrflag = True Then

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
            pnlf.Visible = False
            pnlbatal1.Visible = False
            pnl6.Visible = False

            Exit Sub

        End If

        pnlf.Visible = True
        pnlbatal1.Visible = True

        If FormView1.CurrentMode = FormViewMode.Insert Then

            noruj.Text = "MPK/599/401/"

        End If

        Select Case lesenid
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
            Case 27
                pnla.Visible = True
                pnl6.Visible = True

        End Select

    End Sub

    Private Sub updateJenisLesenList(ByVal itemval As String, ByVal itemtext As String)

        Dim HF_JenisLesenDescList As HiddenField = DirectCast(FormView1.FindControl("HF_JenisLesenDescList"), HiddenField)
        Dim HF_JenisLesenIdList As HiddenField = DirectCast(FormView1.FindControl("HF_JenisLesenIdList"), HiddenField)

        If HF_JenisLesenDescList.Value.ToString.Length = 0 Then
            HF_JenisLesenDescList.Value = itemtext
        Else
            HF_JenisLesenDescList.Value += "," + itemtext
        End If

        If HF_JenisLesenIdList.Value.ToString.Length = 0 Then
            HF_JenisLesenIdList.Value = itemval
        Else
            HF_JenisLesenIdList.Value += "," + itemval
        End If

    End Sub

    Private Sub updateIklanList(ByVal saizVal As String, ByVal cahayaVal As String, ByVal unitVal As String)
        Dim HF_SaizIklanList As HiddenField = DirectCast(FormView1.FindControl("HF_SaizIklanList"), HiddenField)
        Dim HF_CahayaIklanList As HiddenField = DirectCast(FormView1.FindControl("HF_CahayaIklanList"), HiddenField)
        Dim HF_UnitIklanList As HiddenField = DirectCast(FormView1.FindControl("HF_UnitIklanList"), HiddenField)

        If HF_SaizIklanList.Value.ToString.Length = 0 Then
            HF_SaizIklanList.Value = saizVal
        Else
            HF_SaizIklanList.Value += "," + saizVal
        End If

        If HF_CahayaIklanList.Value.ToString.Length = 0 Then
            HF_CahayaIklanList.Value = cahayaVal
        Else
            HF_CahayaIklanList.Value += "," + cahayaVal
        End If

        If HF_UnitIklanList.Value.ToString.Length = 0 Then
            HF_UnitIklanList.Value = unitVal
        Else
            HF_UnitIklanList.Value += "," + unitVal
        End If

    End Sub

    Private Sub updateAnjingList(ByVal bakaVal As String, ByVal jantanVal As String, ByVal betinaVal As String, ByVal jMandulVal As String, ByVal bMandulVal As String)
        Dim HF_BakaAnjingList As HiddenField = DirectCast(FormView1.FindControl("HF_BakaAnjingList"), HiddenField)
        Dim HF_AnjingJantanList As HiddenField = DirectCast(FormView1.FindControl("HF_AnjingJantanList"), HiddenField)
        Dim HF_AnjingBetinaList As HiddenField = DirectCast(FormView1.FindControl("HF_AnjingBetinaList"), HiddenField)
        Dim HF_AnjingJantanMandulList As HiddenField = DirectCast(FormView1.FindControl("HF_AnjingJantanMandulList"), HiddenField)
        Dim HF_AnjingBetinaMandulList As HiddenField = DirectCast(FormView1.FindControl("HF_AnjingBetinaMandulList"), HiddenField)

        If HF_BakaAnjingList.Value.ToString.Length = 0 Then
            HF_BakaAnjingList.Value = bakaVal
        Else
            HF_BakaAnjingList.Value += "," + bakaVal
        End If

        If HF_AnjingJantanList.Value.ToString.Length = 0 Then
            HF_AnjingJantanList.Value = jantanVal
        Else
            HF_AnjingJantanList.Value += "," + jantanVal
        End If

        If HF_AnjingBetinaList.Value.ToString.Length = 0 Then
            HF_AnjingBetinaList.Value = betinaVal
        Else
            HF_AnjingBetinaList.Value += "," + betinaVal
        End If

        If HF_AnjingJantanMandulList.Value.ToString.Length = 0 Then
            HF_AnjingJantanMandulList.Value = jMandulVal
        Else
            HF_AnjingJantanMandulList.Value += "," + jMandulVal
        End If

        If HF_AnjingBetinaMandulList.Value.ToString.Length = 0 Then
            HF_AnjingBetinaMandulList.Value = bMandulVal
        Else
            HF_AnjingBetinaMandulList.Value += "," + bMandulVal
        End If

    End Sub

    Private Sub updateLokasiList(ByVal lokasiVal As String)
        Dim HF_LokasiList As HiddenField = DirectCast(FormView1.FindControl("HF_SaizIklanList"), HiddenField)

        If HF_LokasiList.Value.ToString.Length = 0 Then
            HF_LokasiList.Value = lokasiVal
        Else
            HF_LokasiList.Value += "||" + lokasiVal
        End If

    End Sub

    Private Sub updateIklanList_ins(ByVal saizVal As String, ByVal cahayaVal As String, ByVal unitVal As String)

        If HF_SaizIklanList_ins.Value.ToString.Length = 0 Then
            HF_SaizIklanList_ins.Value = saizVal
        Else
            HF_SaizIklanList_ins.Value += "," + saizVal
        End If

        If HF_CahayaIklanList_ins.Value.ToString.Length = 0 Then
            HF_CahayaIklanList_ins.Value = cahayaVal
        Else
            HF_CahayaIklanList_ins.Value += "," + cahayaVal
        End If

        If HF_UnitIklanList_ins.Value.ToString.Length = 0 Then
            HF_UnitIklanList_ins.Value = unitVal
        Else
            HF_UnitIklanList_ins.Value += "," + unitVal
        End If

    End Sub

    Private Sub updateAnjingList_ins(ByVal bakaVal As String, ByVal jantanVal As String, ByVal betinaVal As String, ByVal jMandulVal As String, ByVal bMandulVal As String)

        If HF_BakaAnjingList_ins.Value.ToString.Length = 0 Then
            HF_BakaAnjingList_ins.Value = bakaVal
        Else
            HF_BakaAnjingList_ins.Value += "," + bakaVal
        End If

        If HF_AnjingJantanList_ins.Value.ToString.Length = 0 Then
            HF_AnjingJantanList_ins.Value = jantanVal
        Else
            HF_AnjingJantanList_ins.Value += "," + jantanVal
        End If

        If HF_AnjingBetinaList_ins.Value.ToString.Length = 0 Then
            HF_AnjingBetinaList_ins.Value = betinaVal
        Else
            HF_AnjingBetinaList_ins.Value += "," + betinaVal
        End If

        If HF_AnjingJantanMandulList_ins.Value.ToString.Length = 0 Then
            HF_AnjingJantanMandulList_ins.Value = jMandulVal
        Else
            HF_AnjingJantanMandulList_ins.Value += "," + jMandulVal
        End If

        If HF_AnjingBetinaMandulList_ins.Value.ToString.Length = 0 Then
            HF_AnjingBetinaMandulList_ins.Value = bMandulVal
        Else
            HF_AnjingBetinaMandulList_ins.Value += "," + bMandulVal
        End If

    End Sub

    Private Sub updateLokasiList_ins(ByVal lokasiVal As String)

        If HF_LokasiList_ins.Value.ToString.Length = 0 Then
            HF_LokasiList_ins.Value = lokasiVal
        Else
            HF_LokasiList_ins.Value += "||" + lokasiVal
        End If

    End Sub

    Protected Sub ddlItems_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        Dim ddlItems As DropDownList = DirectCast(FormView1.FindControl("ddlItems"), DropDownList)
        If String.IsNullOrEmpty(ddlItems.SelectedValue) Then Return

        Dim myList = DirectCast(ViewState("SelectedList"), List(Of SelectedItem))

        If myList.Any(Function(x) x.ItemValue = "2") Or
            myList.Any(Function(x) x.ItemValue = "3") Or
            myList.Any(Function(x) x.ItemValue = "4") Or
            myList.Any(Function(x) x.ItemValue = "5") Or
            myList.Any(Function(x) x.ItemValue = "25") Or
            (myList.Count > 0 And
            (ddlItems.SelectedValue = "2" Or
            ddlItems.SelectedValue = "3" Or
            ddlItems.SelectedValue = "4" Or
            ddlItems.SelectedValue = "5" Or
            ddlItems.SelectedValue = "25")) Then

            ShowAlert("error", "", "Jenis lesen yang dipilih tidak boleh dicampur.")
            ddlItems.SelectedIndex = 0

            Return
        End If

        ' Check for duplicates using LINQ
        If Not myList.Any(Function(x) x.ItemValue = ddlItems.SelectedValue) Then
            Dim newItem As New SelectedItem()
            newItem.ItemText = ddlItems.SelectedItem.Text
            newItem.ItemValue = ddlItems.SelectedValue
            myList.Add(newItem)
            ViewState("SelectedList") = myList
            BindRepeater()
            updateJenisLesenList(newItem.ItemValue, newItem.ItemText)
            PanelAccess(ddlItems.SelectedValue, False)
        End If

        ' Reset dropdown to the first item
        ddlItems.SelectedIndex = 0

    End Sub

    ' Triggered when you click the Red X
    Protected Sub rptSelectedItems_ItemCommand(ByVal source As Object, ByVal e As RepeaterCommandEventArgs)
        Dim HF_JenisLesenDescList As HiddenField = DirectCast(FormView1.FindControl("HF_JenisLesenDescList"), HiddenField)
        Dim HF_JenisLesenIdList As HiddenField = DirectCast(FormView1.FindControl("HF_JenisLesenIdList"), HiddenField)

        If e.CommandName = "Remove" Then
            Dim myList = DirectCast(ViewState("SelectedList"), List(Of SelectedItem))
            Dim valueToRemove As String = e.CommandArgument.ToString()

            ' Remove the item from our list
            myList.RemoveAll(Function(x) x.ItemValue = valueToRemove)

            ViewState("SelectedList") = myList
            BindRepeater()

            PanelAccess(0, True)

            HF_JenisLesenDescList.Value = ""
            HF_JenisLesenIdList.Value = ""

            For Each item In myList

                updateJenisLesenList(item.ItemValue, item.ItemText)
                PanelAccess(item.ItemValue, False)

            Next

        End If
    End Sub

    Private Sub BindRepeater()
        Dim rptSelectedItems As Repeater = DirectCast(FormView1.FindControl("rptSelectedItems"), Repeater)

        rptSelectedItems.DataSource = DirectCast(ViewState("SelectedList"), List(Of SelectedItem))
        rptSelectedItems.DataBind()
    End Sub

    Protected Sub btnAddIklan_Click(sender As Object, e As EventArgs)

        Dim TB_SaizIklan1 As TextBox = DirectCast(FormView1.FindControl("TB_SaizIklan1"), TextBox)
        Dim DDL_Iklan1 As DropDownList = DirectCast(FormView1.FindControl("DDL_Iklan1"), DropDownList)
        Dim TB_UnitIklan1 As TextBox = DirectCast(FormView1.FindControl("TB_UnitIklan1"), TextBox)
        Dim gvIklanList As GridView = DirectCast(FormView1.FindControl("gvIklanList"), GridView)

        If Not String.IsNullOrWhiteSpace(TB_SaizIklan1.Text) And DDL_Iklan1.SelectedValue <> "" And Not String.IsNullOrWhiteSpace(TB_UnitIklan1.Text) Then
            Dim dt As DataTable

            If ViewState("IklanTable") IsNot Nothing Then
                dt = DirectCast(ViewState("IklanTable"), DataTable)
            Else
                dt = New DataTable()
                dt.Columns.Add("SaizIklan", GetType(String))
                dt.Columns.Add("Bercahaya", GetType(String))
                dt.Columns.Add("Unit", GetType(String))
            End If

            Dim newRow As DataRow = dt.NewRow()
            newRow("SaizIklan") = TB_SaizIklan1.Text
            newRow("Bercahaya") = DDL_Iklan1.SelectedValue.ToString
            newRow("Unit") = TB_UnitIklan1.Text 'If(IsNumeric(txtRank.Text), Convert.ToInt32(txtRank.Text), 0)
            dt.Rows.Add(newRow)

            ViewState("IklanTable") = dt
            gvIklanList.DataSource = dt
            gvIklanList.DataBind()

            updateIklanList(newRow("SaizIklan"), newRow("Bercahaya"), newRow("Unit"))

            'Clear textboxes for next entry
            TB_SaizIklan1.Text = ""
            TB_UnitIklan1.Text = ""
            DDL_Iklan1.SelectedIndex = 0

        End If
    End Sub

    Protected Sub gvIklanList_RowDeleting(sender As Object, e As GridViewDeleteEventArgs)
        Dim HF_SaizIklanList As HiddenField = DirectCast(FormView1.FindControl("HF_SaizIklanList"), HiddenField)
        Dim HF_CahayaIklanList As HiddenField = DirectCast(FormView1.FindControl("HF_CahayaIklanList"), HiddenField)
        Dim HF_UnitIklanList As HiddenField = DirectCast(FormView1.FindControl("HF_UnitIklanList"), HiddenField)

        If ViewState("IklanTable") IsNot Nothing Then
            Dim dt As DataTable = DirectCast(ViewState("IklanTable"), DataTable)

            dt.Rows.RemoveAt(e.RowIndex)

            ViewState("IklanTable") = dt

            Dim gvIklan As GridView = DirectCast(FormView1.FindControl("gvIklanList"), GridView)
            gvIklan.DataSource = dt
            gvIklan.DataBind()

            HF_SaizIklanList.Value = ""
            HF_CahayaIklanList.Value = ""
            HF_UnitIklanList.Value = ""

            For Each row As DataRow In dt.Rows
                updateIklanList(row("SaizIklan"), row("Bercahaya"), row("Unit"))
            Next

        End If

    End Sub

    Protected Sub btnAddAnjing_Click(sender As Object, e As EventArgs)

        Dim DDL_BakaAnjing1 As DropDownList = DirectCast(FormView1.FindControl("DDL_BakaAnjing1"), DropDownList)
        Dim TB_Jantan1 As TextBox = DirectCast(FormView1.FindControl("TB_Jantan1"), TextBox)
        Dim TB_Betina1 As TextBox = DirectCast(FormView1.FindControl("TB_Betina1"), TextBox)
        Dim TB_JantanMandul1 As TextBox = DirectCast(FormView1.FindControl("TB_JantanMandul1"), TextBox)
        Dim TB_BetinaMandul1 As TextBox = DirectCast(FormView1.FindControl("TB_BetinaMandul1"), TextBox)
        Dim gvAnjingList As GridView = DirectCast(FormView1.FindControl("gvAnjingList"), GridView)

        If Not String.IsNullOrWhiteSpace(TB_Jantan1.Text) And Not String.IsNullOrWhiteSpace(TB_Betina1.Text) And
            Not String.IsNullOrWhiteSpace(TB_JantanMandul1.Text) And Not String.IsNullOrWhiteSpace(TB_BetinaMandul1.Text) And
            Not String.IsNullOrWhiteSpace(DDL_BakaAnjing1.SelectedValue) Then
            Dim dt As DataTable

            If ViewState("AnjingTable") IsNot Nothing Then
                dt = DirectCast(ViewState("AnjingTable"), DataTable)
            Else
                dt = New DataTable()
                dt.Columns.Add("Baka", GetType(String))
                dt.Columns.Add("Jantan", GetType(String))
                dt.Columns.Add("Betina", GetType(String))
                dt.Columns.Add("JantanMandul", GetType(String))
                dt.Columns.Add("BetinaMandul", GetType(String))
            End If

            Dim newRow As DataRow = dt.NewRow()
            newRow("Baka") = DDL_BakaAnjing1.SelectedItem.Text
            newRow("Jantan") = TB_Jantan1.Text
            newRow("Betina") = TB_Betina1.Text
            newRow("JantanMandul") = TB_JantanMandul1.Text
            newRow("BetinaMandul") = TB_BetinaMandul1.Text
            dt.Rows.Add(newRow)

            ViewState("AnjingTable") = dt
            gvAnjingList.DataSource = dt
            gvAnjingList.DataBind()

            updateAnjingList(newRow("Baka"), newRow("Jantan"), newRow("Betina"), newRow("JantanMandul"), newRow("BetinaMandul"))

            'Clear textboxes for next entry
            TB_Jantan1.Text = ""
            TB_Betina1.Text = ""
            TB_JantanMandul1.Text = ""
            TB_BetinaMandul1.Text = ""
            DDL_BakaAnjing1.SelectedIndex = 0

        End If
    End Sub

    Protected Sub gvAnjingList_RowDeleting(sender As Object, e As GridViewDeleteEventArgs)
        Dim HF_BakaAnjingList As HiddenField = DirectCast(FormView1.FindControl("HF_BakaAnjingList"), HiddenField)
        Dim HF_AnjingJantanList As HiddenField = DirectCast(FormView1.FindControl("HF_AnjingJantanList"), HiddenField)
        Dim HF_AnjingBetinaList As HiddenField = DirectCast(FormView1.FindControl("HF_AnjingBetinaList"), HiddenField)
        Dim HF_AnjingJantanMandulList As HiddenField = DirectCast(FormView1.FindControl("HF_AnjingJantanMandulList"), HiddenField)
        Dim HF_AnjingBetinaMandulList As HiddenField = DirectCast(FormView1.FindControl("HF_AnjingBetinaMandulList"), HiddenField)

        If ViewState("AnjingTable") IsNot Nothing Then
            Dim dt As DataTable = DirectCast(ViewState("AnjingTable"), DataTable)

            dt.Rows.RemoveAt(e.RowIndex)

            ViewState("AnjingTable") = dt

            Dim gvAnjing As GridView = DirectCast(FormView1.FindControl("gvAnjingList"), GridView)
            gvAnjing.DataSource = dt
            gvAnjing.DataBind()

            HF_BakaAnjingList.Value = ""
            HF_AnjingJantanList.Value = ""
            HF_AnjingBetinaList.Value = ""
            HF_AnjingJantanMandulList.Value = ""
            HF_AnjingBetinaMandulList.Value = ""

            For Each row As DataRow In dt.Rows
                updateAnjingList(row("Baka"), row("Jantan"), row("Betina"), row("JantanMandul"), row("BetinaMandul"))
            Next

        End If

    End Sub

    Protected Sub btnAddLokasi_Click(sender As Object, e As EventArgs)

        Dim TB_LokasiBanting As TextBox = DirectCast(FormView1.FindControl("TB_LokasiBanting"), TextBox)
        Dim gvLokasiList As GridView = DirectCast(FormView1.FindControl("gvLokasiList"), GridView)

        If Not String.IsNullOrWhiteSpace(TB_LokasiBanting.Text) Then
            Dim dt As DataTable

            If ViewState("LokasiTable") IsNot Nothing Then
                dt = DirectCast(ViewState("LokasiTable"), DataTable)
            Else
                dt = New DataTable()
                dt.Columns.Add("No", GetType(String))
                dt.Columns.Add("Lokasi", GetType(String))
            End If

            Dim newRow As DataRow = dt.NewRow()
            newRow("No") = (dt.Rows.Count + 1).ToString
            newRow("Lokasi") = TB_LokasiBanting.Text
            dt.Rows.Add(newRow)

            ViewState("LokasiTable") = dt
            gvLokasiList.DataSource = dt
            gvLokasiList.DataBind()

            updateLokasiList(newRow("Lokasi"))

            'Clear textboxes for next entry
            TB_LokasiBanting.Text = ""

        End If
    End Sub

    Protected Sub gvLokasiList_RowDeleting(sender As Object, e As GridViewDeleteEventArgs)
        Dim HF_LokasiList As HiddenField = DirectCast(FormView1.FindControl("HF_LokasiList"), HiddenField)

        If ViewState("LokasiTable") IsNot Nothing Then
            Dim dt As DataTable = DirectCast(ViewState("LokasiTable"), DataTable)

            dt.Rows.RemoveAt(e.RowIndex)

            ViewState("LokasiTable") = dt

            Dim gvLokasi As GridView = DirectCast(FormView1.FindControl("gvLokasiList"), GridView)
            gvLokasi.DataSource = dt
            gvLokasi.DataBind()

            HF_LokasiList.Value = ""

            For Each row As DataRow In dt.Rows
                updateLokasiList(row("Lokasi"))
            Next

        End If

    End Sub


    Protected Sub btnAddIklan_ins_Click(sender As Object, e As EventArgs)

        If Not String.IsNullOrWhiteSpace(TB_SaizIklan1_ins.Text) And DDL_Iklan1_ins.SelectedValue <> "" And Not String.IsNullOrWhiteSpace(TB_UnitIklan1_ins.Text) Then
            Dim dt As DataTable

            If ViewState("IklanTable_ins") IsNot Nothing Then
                dt = DirectCast(ViewState("IklanTable_ins"), DataTable)
            Else
                dt = New DataTable()
                dt.Columns.Add("SaizIklan", GetType(String))
                dt.Columns.Add("Bercahaya", GetType(String))
                dt.Columns.Add("Unit", GetType(String))
            End If

            Dim newRow As DataRow = dt.NewRow()
            newRow("SaizIklan") = TB_SaizIklan1_ins.Text
            newRow("Bercahaya") = DDL_Iklan1_ins.SelectedValue.ToString
            newRow("Unit") = TB_UnitIklan1_ins.Text 'If(IsNumeric(txtRank.Text), Convert.ToInt32(txtRank.Text), 0)
            dt.Rows.Add(newRow)

            ViewState("IklanTable_ins") = dt
            gvIklanList_ins.DataSource = dt
            gvIklanList_ins.DataBind()

            updateIklanList_ins(newRow("SaizIklan"), newRow("Bercahaya"), newRow("Unit"))

            'Clear textboxes for next entry
            TB_SaizIklan1_ins.Text = ""
            TB_UnitIklan1_ins.Text = ""
            DDL_Iklan1_ins.SelectedIndex = 0

        End If
    End Sub

    Protected Sub gvIklanList_ins_RowDeleting(sender As Object, e As GridViewDeleteEventArgs)

        If ViewState("IklanTable_ins") IsNot Nothing Then
            Dim dt As DataTable = DirectCast(ViewState("IklanTable_ins"), DataTable)

            dt.Rows.RemoveAt(e.RowIndex)

            ViewState("IklanTable_ins") = dt

            gvIklanList_ins.DataSource = dt
            gvIklanList_ins.DataBind()

            HF_SaizIklanList_ins.Value = ""
            HF_CahayaIklanList_ins.Value = ""
            HF_UnitIklanList_ins.Value = ""

            For Each row As DataRow In dt.Rows
                updateIklanList_ins(row("SaizIklan"), row("Bercahaya"), row("Unit"))
            Next

        End If

    End Sub

    Protected Sub btnAddAnjing_ins_Click(sender As Object, e As EventArgs)

        If Not String.IsNullOrWhiteSpace(TB_Jantan1_ins.Text) And Not String.IsNullOrWhiteSpace(TB_Betina1_ins.Text) And
            Not String.IsNullOrWhiteSpace(TB_JantanMandul1_ins.Text) And Not String.IsNullOrWhiteSpace(TB_BetinaMandul1_ins.Text) And
            Not String.IsNullOrWhiteSpace(DDL_BakaAnjing1_ins.SelectedValue) Then
            Dim dt As DataTable

            If ViewState("AnjingTable_ins") IsNot Nothing Then
                dt = DirectCast(ViewState("AnjingTable_ins"), DataTable)
            Else
                dt = New DataTable()
                dt.Columns.Add("Baka", GetType(String))
                dt.Columns.Add("Jantan", GetType(String))
                dt.Columns.Add("Betina", GetType(String))
                dt.Columns.Add("JantanMandul", GetType(String))
                dt.Columns.Add("BetinaMandul", GetType(String))
            End If

            Dim newRow As DataRow = dt.NewRow()
            newRow("Baka") = DDL_BakaAnjing1_ins.SelectedItem.Text
            newRow("Jantan") = TB_Jantan1_ins.Text
            newRow("Betina") = TB_Betina1_ins.Text
            newRow("JantanMandul") = TB_JantanMandul1_ins.Text
            newRow("BetinaMandul") = TB_BetinaMandul1_ins.Text
            dt.Rows.Add(newRow)

            ViewState("AnjingTable_ins") = dt
            gvAnjingList_ins.DataSource = dt
            gvAnjingList_ins.DataBind()

            updateAnjingList_ins(newRow("Baka"), newRow("Jantan"), newRow("Betina"), newRow("JantanMandul"), newRow("BetinaMandul"))

            'Clear textboxes for next entry
            TB_Jantan1_ins.Text = ""
            TB_Betina1_ins.Text = ""
            TB_JantanMandul1_ins.Text = ""
            TB_BetinaMandul1_ins.Text = ""
            DDL_BakaAnjing1_ins.SelectedIndex = 0

        End If
    End Sub

    Protected Sub gvAnjingList_ins_RowDeleting(sender As Object, e As GridViewDeleteEventArgs)

        If ViewState("AnjingTable_ins") IsNot Nothing Then
            Dim dt As DataTable = DirectCast(ViewState("AnjingTable_ins"), DataTable)

            dt.Rows.RemoveAt(e.RowIndex)

            ViewState("AnjingTable_ins") = dt

            gvAnjingList_ins.DataSource = dt
            gvAnjingList_ins.DataBind()

            HF_BakaAnjingList_ins.Value = ""
            HF_AnjingJantanList_ins.Value = ""
            HF_AnjingBetinaList_ins.Value = ""
            HF_AnjingJantanMandulList_ins.Value = ""
            HF_AnjingBetinaMandulList_ins.Value = ""

            For Each row As DataRow In dt.Rows
                updateAnjingList_ins(row("Baka"), row("Jantan"), row("Betina"), row("JantanMandul"), row("BetinaMandul"))
            Next

        End If

    End Sub

    Protected Sub btnAddLokasi_ins_Click(sender As Object, e As EventArgs)

        If Not String.IsNullOrWhiteSpace(TB_LokasiBanting_ins.Text) Then
            Dim dt As DataTable

            If ViewState("LokasiTable_ins") IsNot Nothing Then
                dt = DirectCast(ViewState("LokasiTable_ins"), DataTable)
            Else
                dt = New DataTable()
                dt.Columns.Add("No", GetType(String))
                dt.Columns.Add("Lokasi", GetType(String))
            End If

            Dim newRow As DataRow = dt.NewRow()
            newRow("No") = (dt.Rows.Count + 1).ToString
            newRow("Lokasi") = TB_LokasiBanting_ins.Text
            dt.Rows.Add(newRow)

            ViewState("LokasiTable_ins") = dt
            gvLokasiList_ins.DataSource = dt
            gvLokasiList_ins.DataBind()

            updateLokasiList_ins(newRow("Lokasi"))

            'Clear textboxes for next entry
            TB_LokasiBanting_ins.Text = ""

        End If
    End Sub

    Protected Sub gvLokasiList_ins_RowDeleting(sender As Object, e As GridViewDeleteEventArgs)

        If ViewState("LokasiTable_ins") IsNot Nothing Then
            Dim dt As DataTable = DirectCast(ViewState("LokasiTable_ins"), DataTable)

            dt.Rows.RemoveAt(e.RowIndex)

            ViewState("LokasiTable_ins") = dt

            gvLokasiList_ins.DataSource = dt
            gvLokasiList_ins.DataBind()

            HF_LokasiList_ins.Value = ""

            For Each row As DataRow In dt.Rows
                updateLokasiList_ins(row("Lokasi"))
            Next

        End If

    End Sub

    Private Sub PanelAccessPembetulan(lesenid As Integer, clrflag As Boolean)

        If clrflag = True Then

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
            pnlesen6_ins.Visible = False

            Exit Sub

        End If

        Select Case lesenid
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
            Case 27                             'Pemilik + Alamat + Visual Iklan /
                pnlesen1_ins.Visible = True
                pnlesen6_ins.Visible = True

        End Select

    End Sub

    Private Sub GetPermohonanPembetulan(permohonanID As Integer, isBatal As Boolean)

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQL As String = "SELECT * FROM LESEN_PermohonanPembetulan WHERE Permohonan_ID = @Permohonan_ID"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", permohonanID)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            Try
                If myReader.Read Then

                    If myReader.Item("SaizIklanList").ToString().Length > 0 Then
                        HF_SaizIklanList_ins.Value = myReader.Item("SaizIklanList").ToString()
                    End If

                    If myReader.Item("CahayaIklanList").ToString().Length > 0 Then
                        HF_CahayaIklanList_ins.Value = myReader.Item("CahayaIklanList").ToString()
                    End If

                    If myReader.Item("UnitIklanList").ToString().Length > 0 Then
                        HF_UnitIklanList_ins.Value = myReader.Item("UnitIklanList").ToString()
                    End If

                    If myReader.Item("LokasiList").ToString().Length > 0 Then
                        HF_LokasiList_ins.Value = myReader.Item("LokasiList").ToString()
                    End If

                    If myReader.Item("BakaAnjingList").ToString().Length > 0 Then
                        HF_BakaAnjingList_ins.Value = myReader.Item("BakaAnjingList").ToString()
                    End If

                    If myReader.Item("AnjingJantanList").ToString().Length > 0 Then
                        HF_AnjingJantanList_ins.Value = myReader.Item("AnjingJantanList").ToString()
                    End If

                    If myReader.Item("AnjingBetinaList").ToString().Length > 0 Then
                        HF_AnjingBetinaList_ins.Value = myReader.Item("AnjingBetinaList").ToString()
                    End If

                    If myReader.Item("AnjingJantanMandulList").ToString().Length > 0 Then
                        HF_AnjingJantanMandulList_ins.Value = myReader.Item("AnjingJantanMandulList").ToString()
                    End If

                    If myReader.Item("AnjingBetinaMandulList").ToString().Length > 0 Then
                        HF_AnjingBetinaMandulList_ins.Value = myReader.Item("AnjingBetinaMandulList").ToString()
                    End If

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

                    If myReader.Item("KontraktorIklan").ToString().Length > 0 Then
                        TB_KontraktorIklan_ins.Text = myReader.Item("KontraktorIklan").ToString()
                    End If

                    If myReader.Item("NoTelKontraktor").ToString().Length > 0 Then
                        TB_NoTelKontraktor_ins.Text = myReader.Item("NoTelKontraktor").ToString()
                    End If

                    If myReader.Item("UkuranBanting").ToString().Length > 0 Then
                        TB_UkuranBanting_ins.Text = myReader.Item("UkuranBanting").ToString()
                    End If

                    If myReader.Item("BilBanting").ToString().Length > 0 Then
                        TB_BilBanting_ins.Text = CInt(myReader.Item("BilBanting").ToString())
                    End If

                    If IsDBNull(myReader.Item("TarikhBanting1")) = False Then
                        TB_TarikhBanting1_ins.Text = CDate(myReader.Item("TarikhBanting1")).ToString("yyyy-MM-dd")
                    End If

                    If IsDBNull(myReader.Item("TarikhBanting2")) = False Then
                        TB_TarikhBanting2_ins.Text = CDate(myReader.Item("TarikhBanting2")).ToString("yyyy-MM-dd")
                    End If

                    If myReader.Item("NoResitBanting").ToString().Length > 0 Then
                        TB_NoResitBanting_ins.Text = myReader.Item("NoResitBanting").ToString()
                    End If

                    If myReader.Item("NoSiriStiker").ToString().Length > 0 Then
                        TB_NoSiriStiker_ins.Text = myReader.Item("NoSiriStiker").ToString()
                    End If

                    If IsDBNull(myReader.Item("TarikhBanting3")) = False Then
                        TB_TarikhBanting3_ins.Text = CDate(myReader.Item("TarikhBanting3")).ToString("yyyy-MM-dd")
                    End If

                End If

            Catch ex As Exception
                MessageBox("ERROR_GETPERMOHONANPEMBETULAN", Me)
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

        'Load Senarai Iklan
        Dim SaizIklanList() = Split(HF_SaizIklanList_ins.Value, ",")
        Dim CahayaIklanList() = Split(HF_CahayaIklanList_ins.Value, ",")
        Dim UnitIklanList() = Split(HF_UnitIklanList_ins.Value, ",")

        If SaizIklanList.Length > 0 Then

            Dim dt As DataTable

            If ViewState("IklanTable_ins") IsNot Nothing Then
                dt = DirectCast(ViewState("IklanTable_ins"), DataTable)
                dt.Clear()
            Else
                dt = New DataTable()
                dt.Columns.Add("SaizIklan", GetType(String))
                dt.Columns.Add("Bercahaya", GetType(String))
                dt.Columns.Add("Unit", GetType(String))
            End If

            For i As Integer = 0 To SaizIklanList.Length - 1
                Dim newRow As DataRow = dt.NewRow()
                newRow("SaizIklan") = SaizIklanList(i).Trim()
                newRow("Bercahaya") = CahayaIklanList(i).Trim()
                newRow("Unit") = UnitIklanList(i).Trim()

                dt.Rows.Add(newRow)
            Next

            ViewState("IklanTable_ins") = dt
            gvIklanList_ins.DataSource = dt
            gvIklanList_ins.DataBind()

        End If

        'Load Senarai Anjing
        Dim BakaAnjingList() = Split(HF_BakaAnjingList_ins.Value, ",")
        Dim JantanList() = Split(HF_AnjingJantanList_ins.Value, ",")
        Dim BetinaList() = Split(HF_AnjingBetinaList_ins.Value, ",")
        Dim JantanMandulList() = Split(HF_AnjingJantanMandulList_ins.Value, ",")
        Dim BetinaMandulList() = Split(HF_AnjingBetinaMandulList_ins.Value, ",")

        If BakaAnjingList.Length > 0 Then

            Dim dt As DataTable

            If ViewState("AnjingTable_ins") IsNot Nothing Then
                dt = DirectCast(ViewState("AnjingTable_ins"), DataTable)
                dt.Clear()
            Else
                dt = New DataTable()
                dt.Columns.Add("Baka", GetType(String))
                dt.Columns.Add("Jantan", GetType(String))
                dt.Columns.Add("Betina", GetType(String))
                dt.Columns.Add("JantanMandul", GetType(String))
                dt.Columns.Add("BetinaMandul", GetType(String))
            End If

            For i As Integer = 0 To BakaAnjingList.Length - 1
                Dim newRow As DataRow = dt.NewRow()
                newRow("Baka") = BakaAnjingList(i).Trim()
                newRow("Jantan") = JantanList(i).Trim()
                newRow("Betina") = BetinaList(i).Trim()
                newRow("JantanMandul") = JantanMandulList(i).Trim()
                newRow("BetinaMandul") = BetinaMandulList(i).Trim()

                dt.Rows.Add(newRow)
            Next

            ViewState("AnjingTable_ins") = dt
            gvAnjingList_ins.DataSource = dt
            gvAnjingList_ins.DataBind()

        End If

        'Load Senarai Lokasi
        Dim LokasiList() = Split(HF_LokasiList_ins.Value, "||")

        If LokasiList.Length > 0 Then

            Dim dt As DataTable

            If ViewState("LokasiTable_ins") IsNot Nothing Then
                dt = DirectCast(ViewState("LokasiTable_ins"), DataTable)
                dt.Clear()
            Else
                dt = New DataTable()
                dt.Columns.Add("No", GetType(String))
                dt.Columns.Add("Lokasi", GetType(String))
            End If

            For i As Integer = 0 To LokasiList.Length - 1
                Dim newRow As DataRow = dt.NewRow()
                newRow("No") = (i + 1).ToString
                newRow("Lokasi") = LokasiList(i).Trim()

                dt.Rows.Add(newRow)
            Next

            ViewState("LokasiTable_ins") = dt
            gvLokasiList_ins.DataSource = dt
            gvLokasiList_ins.DataBind()

        End If

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
                MessageBox("ERROR_GETSURATMOHON", Me)
            End Try

            myReader.Close()
            myConnection.Close()

        End Using

    End Sub

    Private Sub insertJabatanAgensiBatal(pid As Integer)

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

    Private Sub insertJabatanAgensi(jid As String, pid As Integer)

        Dim listagensi As List(Of Integer) = New List(Of Integer)

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            'Dim SQL As String = "SELECT JabatanAgensi_ID FROM LESEN_JenisLesenAgensi WHERE JenisLesen_ID = @JenisLesen_ID"
            Dim SQL As String = "SELECT JabatanAgensi_ID FROM LESEN_JenisLesenAgensi 
            WHERE ',' + @JenisLesen_ID + ',' LIKE '%,' + CAST(JenisLesen_ID AS VARCHAR) + ',%' 
            GROUP BY JabatanAgensi_ID;"
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

    Private Sub insertKadarBayaran(jid As String, pid As Integer)

        Dim listkbdesc As List(Of String) = New List(Of String)
        Dim listkbamount As List(Of String) = New List(Of String)

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            'Dim SQL As String = "SELECT JenisLesenBayaran_Description, JenisLesenBayaran_Amount FROM LESEN_JenisLesenBayaran WHERE JenisLesen_ID IN (SELECT value FROM STRING_SPLIT(@JenisLesenIdList, ','));"
            Dim SQL As String = "SELECT JenisLesenBayaran_Description, JenisLesenBayaran_Amount 
            FROM LESEN_JenisLesenBayaran 
            WHERE ',' + @JenisLesen_ID + ',' LIKE '%,' + CAST(JenisLesen_ID AS VARCHAR) + ',%' 
            GROUP BY JenisLesenBayaran_Description, JenisLesenBayaran_Amount"
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
                    INSERT INTO LESEN_PermohonanPembetulan(Permohonan_ID, SaizIklanList, CahayaIklanList, UnitIklanList, LokasiList, 
                        BakaAnjingList, AnjingJantanList, AnjingBetinaList, AnjingJantanMandulList, AnjingBetinaMandulList, 
                        NamaSyarikat, NoPendaftaran, NoAkaun, AlamatPremis, JenisPerniagaan,
                        PemilikBaru, AlamatBaru, JenisPerniagaanBaru, NamaBaruSyarikat, BillboardLokasi, LokasiPasar1, LokasiPasar2, LokasiPasar3, JenisPasar,
                        JenisPerniagaanPasar, JumlahPetak, AnjingAlamat, AnjingJenisPremis, AlamatPenjajaan, JenisPerniagaanPenjaja, 
                        TarikhBatal, PenganjurEkspo, NamaEkspo, LokasiEkspo, NoTelEkspo, TarikhEkspo1, TarikhEkspo2, MasaEkspo1, MasaEkspo2, 
                        KontraktorIklan, NoTelKontraktor, UkuranBanting, BilBanting, TarikhBanting1, TarikhBanting2, NoResitBanting, NoSiriStiker, TarikhBanting3, 
                        CreatorID, CreatedDt, LastModID, LastModDt) 
                    SELECT Permohonan_ID, SaizIklanList, CahayaIklanList, UnitIklanList, LokasiList, 
                        BakaAnjingList, AnjingJantanList, AnjingBetinaList, AnjingJantanMandulList, AnjingBetinaMandulList, 
                        NamaSyarikat, NoPendaftaran, NoAkaun, AlamatPremis, JenisPerniagaan, 
                        PemilikBaru, AlamatBaru, JenisPerniagaanBaru, NamaBaruSyarikat, BillboardLokasi, LokasiPasar1, LokasiPasar2, LokasiPasar3, JenisPasar,
                        JenisPerniagaanPasar, JumlahPetak, AnjingAlamat, AnjingJenisPremis, AlamatPenjajaan, JenisPerniagaanPenjaja, 
                        TarikhBatal, PenganjurEkspo, NamaEkspo, LokasiEkspo, NoTelEkspo, TarikhEkspo1, TarikhEkspo2, MasaEkspo1, MasaEkspo2, 
                        KontraktorIklan, NoTelKontraktor, UkuranBanting, BilBanting, TarikhBanting1, TarikhBanting2, NoResitBanting, NoSiriStiker, TarikhBanting3, 
                        CreatorID, CreatedDt, LastModID, LastModDt FROM LESEN_Permohonan 
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
        'Dim JenisLesenID As Integer
        Dim JenisLesenIdList As String
        Dim JenisBatal As Integer
        Dim IsBatal As Boolean
        Dim Is24Jam As Boolean
        Dim strAlert As String = ""

        If Not IsDBNull(e.Command.Parameters("@Permohonan_ID").Value) Then
            PermohonanID = e.Command.Parameters("@Permohonan_ID").Value
            'JenisLesenID = e.Command.Parameters("@JenisLesen_ID").Value
            JenisLesenIdList = e.Command.Parameters("@JenisLesenIdList").Value
            IsBatal = e.Command.Parameters("@IsBatal").Value
            Is24Jam = e.Command.Parameters("@Is24Jam").Value

            If Is24Jam = False Then
                strAlert = "BUKAN"
            End If

            'MessageBox(JenisLesenID, Me)

            If IsBatal = False Then
                insertJabatanAgensi(JenisLesenIdList, PermohonanID)
                insertKadarBayaran(JenisLesenIdList, PermohonanID)
            Else
                JenisBatal = e.Command.Parameters("@JenisBatal").Value

                If JenisBatal = 1 Then
                    insertJabatanAgensiBatal(PermohonanID)
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
        Dim cb24h As CheckBox = DirectCast(FormView1.FindControl("CB_24h"), CheckBox)

        If Not IsDBNull(e.NewValues("Permohonan_ID")) Then
            PermohonanID = e.NewValues("Permohonan_ID")
            JenisLesenID = e.NewValues("JenisLesen_ID")
            IsBatal = e.NewValues("IsBatal")

            If cb24h.Checked = False Then
                Is24Jam = "BUKAN"
            End If

            If IsBatal And IsBatal <> e.OldValues("IsBatal") Then
                JenisBatal = e.NewValues("JenisBatal")

                If JenisBatal = 1 Then
                    insertJabatanAgensiBatal(PermohonanID)
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

                ViewState("SelectedList") = New List(Of SelectedItem)()

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

        Dim tbid As TextBox = DirectCast(FormView1.FindControl("TB_PemohonID"), TextBox)
        Dim tbname As TextBox = DirectCast(FormView1.FindControl("TB_Name"), TextBox)
        Dim tbnation As TextBox = DirectCast(FormView1.FindControl("TB_Nat"), TextBox)
        Dim tbaddress As TextBox = DirectCast(FormView1.FindControl("TB_Address"), TextBox)
        Dim tbnote As TextBox = DirectCast(FormView1.FindControl("TB_Remarks"), TextBox)

        Dim HF_JenisLesenDescList As HiddenField = DirectCast(FormView1.FindControl("HF_JenisLesenDescList"), HiddenField)
        Dim HF_JenisLesenIdList As HiddenField = DirectCast(FormView1.FindControl("HF_JenisLesenIdList"), HiddenField)
        Dim HF_SaizIklanList As HiddenField = DirectCast(FormView1.FindControl("HF_SaizIklanList"), HiddenField)
        Dim HF_CahayaIklanList As HiddenField = DirectCast(FormView1.FindControl("HF_CahayaIklanList"), HiddenField)
        Dim HF_UnitIklanList As HiddenField = DirectCast(FormView1.FindControl("HF_UnitIklanList"), HiddenField)
        Dim HF_BakaAnjingList As HiddenField = DirectCast(FormView1.FindControl("HF_BakaAnjingList"), HiddenField)
        Dim HF_AnjingJantanList As HiddenField = DirectCast(FormView1.FindControl("HF_AnjingJantanList"), HiddenField)
        Dim HF_AnjingBetinaList As HiddenField = DirectCast(FormView1.FindControl("HF_AnjingBetinaList"), HiddenField)
        Dim HF_AnjingJantanMandulList As HiddenField = DirectCast(FormView1.FindControl("HF_AnjingJantanMandulList"), HiddenField)
        Dim HF_AnjingBetinaMandulList As HiddenField = DirectCast(FormView1.FindControl("HF_AnjingBetinaMandulList"), HiddenField)
        Dim HF_LokasiList As HiddenField = DirectCast(FormView1.FindControl("HF_LokasiList"), HiddenField)

        Dim gvIklanList As GridView = DirectCast(FormView1.FindControl("gvIklanList"), GridView)
        Dim gvAnjingList As GridView = DirectCast(FormView1.FindControl("gvAnjingList"), GridView)
        Dim gvLokasiList As GridView = DirectCast(FormView1.FindControl("gvLokasiList"), GridView)

        Dim ddl2 As DropDownList = DirectCast(FormView1.FindControl("DDL_JenisBatal"), DropDownList)
        Dim pnlbatal1 As Panel = DirectCast(FormView1.FindControl("pnlbatal3"), Panel)
        Dim pnlbatal2 As Panel = DirectCast(FormView1.FindControl("pnlbatal4"), Panel)

        Try
            If FormView1.CurrentMode = FormViewMode.Edit Then

                Dim myList = DirectCast(ViewState("SelectedList"), List(Of SelectedItem))
                myList.Clear()

                Dim JenisLesenDescList() = Split(HF_JenisLesenDescList.Value, ",")
                Dim JenisLesenIdList() = Split(HF_JenisLesenIdList.Value, ",")

                If myList Is Nothing Then
                    myList = New List(Of SelectedItem)()
                End If

                ' 2. Loop through the arrays (assuming they are the same length)
                For i As Integer = 0 To JenisLesenDescList.Length - 1
                    Dim newItem As New SelectedItem()
                    newItem.ItemText = JenisLesenDescList(i).Trim()
                    newItem.ItemValue = JenisLesenIdList(i).Trim()

                    myList.Add(newItem)
                Next

                ViewState("SelectedList") = myList
                BindRepeater()

                PanelAccess(0, True)

                For Each item In myList
                    PanelAccess(item.ItemValue, False)

                Next

                If ddl2.SelectedIndex = 1 Then
                    pnlbatal1.Visible = True

                ElseIf ddl2.SelectedIndex = 2 Then
                    pnlbatal2.Visible = True

                End If

                'Load Senarai Iklan
                Dim SaizIklanList() = Split(HF_SaizIklanList.Value, ",")
                Dim CahayaIklanList() = Split(HF_CahayaIklanList.Value, ",")
                Dim UnitIklanList() = Split(HF_UnitIklanList.Value, ",")

                If SaizIklanList.Length > 0 Then

                    Dim dt As DataTable

                    If ViewState("IklanTable") IsNot Nothing Then
                        dt = DirectCast(ViewState("IklanTable"), DataTable)
                        dt.Clear()
                    Else
                        dt = New DataTable()
                        dt.Columns.Add("SaizIklan", GetType(String))
                        dt.Columns.Add("Bercahaya", GetType(String))
                        dt.Columns.Add("Unit", GetType(String))
                    End If

                    For i As Integer = 0 To SaizIklanList.Length - 1
                        Dim newRow As DataRow = dt.NewRow()
                        newRow("SaizIklan") = SaizIklanList(i).Trim()
                        newRow("Bercahaya") = CahayaIklanList(i).Trim()
                        newRow("Unit") = UnitIklanList(i).Trim()

                        dt.Rows.Add(newRow)
                    Next

                    ViewState("IklanTable") = dt
                    gvIklanList.DataSource = dt
                    gvIklanList.DataBind()

                End If

                'Load Senarai Anjing
                Dim BakaAnjingList() = Split(HF_BakaAnjingList.Value, ",")
                Dim JantanList() = Split(HF_AnjingJantanList.Value, ",")
                Dim BetinaList() = Split(HF_AnjingBetinaList.Value, ",")
                Dim JantanMandulList() = Split(HF_AnjingJantanMandulList.Value, ",")
                Dim BetinaMandulList() = Split(HF_AnjingBetinaMandulList.Value, ",")

                If BakaAnjingList.Length > 0 Then

                    Dim dt As DataTable

                    If ViewState("AnjingTable") IsNot Nothing Then
                        dt = DirectCast(ViewState("AnjingTable"), DataTable)
                        dt.Clear()
                    Else
                        dt = New DataTable()
                        dt.Columns.Add("Baka", GetType(String))
                        dt.Columns.Add("Jantan", GetType(String))
                        dt.Columns.Add("Betina", GetType(String))
                        dt.Columns.Add("JantanMandul", GetType(String))
                        dt.Columns.Add("BetinaMandul", GetType(String))
                    End If

                    For i As Integer = 0 To BakaAnjingList.Length - 1
                        Dim newRow As DataRow = dt.NewRow()
                        newRow("Baka") = BakaAnjingList(i).Trim()
                        newRow("Jantan") = JantanList(i).Trim()
                        newRow("Betina") = BetinaList(i).Trim()
                        newRow("JantanMandul") = JantanMandulList(i).Trim()
                        newRow("BetinaMandul") = BetinaMandulList(i).Trim()

                        dt.Rows.Add(newRow)
                    Next

                    ViewState("AnjingTable") = dt
                    gvAnjingList.DataSource = dt
                    gvAnjingList.DataBind()

                End If

                'Load Senarai Lokasi
                Dim LokasiList() = Split(HF_LokasiList.Value, "||")

                If LokasiList.Length > 0 Then

                    Dim dt As DataTable

                    If ViewState("LokasiTable") IsNot Nothing Then
                        dt = DirectCast(ViewState("LokasiTable"), DataTable)
                        dt.Clear()
                    Else
                        dt = New DataTable()
                        dt.Columns.Add("No", GetType(String))
                        dt.Columns.Add("Lokasi", GetType(String))
                    End If

                    For i As Integer = 0 To LokasiList.Length - 1
                        Dim newRow As DataRow = dt.NewRow()
                        newRow("No") = (i + 1).ToString
                        newRow("Lokasi") = LokasiList(i).Trim()

                        dt.Rows.Add(newRow)
                    Next

                    ViewState("LokasiTable") = dt
                    gvLokasiList.DataSource = dt
                    gvLokasiList.DataBind()

                End If

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

                        ShowAlert("error", "", "")

                    End Try

                End Using

            End If
        Catch ex As Exception

            'ShowAlert("error", "", "Error FormDataBound")

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
        Dim JenisLesenID As String = CStr(Me.GridViewMaintenanceTemplate.DataKeys(intRow)("JenisLesenIdList"))
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
        Dim JenisLesenIdList As Integer = CStr(Me.GridViewJabatanAgensiBatal.DataKeys(intRow)("JenisLesenIdList"))
        Dim JabatanAgensi_ID As Integer = CInt(Me.GridViewJabatanAgensiBatal.DataKeys(intRow)("JabatanAgensi_ID"))
        Dim Permohonan_ID As Integer = CInt(GridView1.SelectedDataKey.Values(0))

        If e.CommandName = "Surat" Then

            ViewSuratMohonAuto(PermohonanAgensi_ID, JabatanAgensi_ID, JenisLesenIdList, True)

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

    Private Sub ViewSuratMohonAuto(permohonanAgensiID As String, jabatanAgensiID As Integer, jenislesenIdList As String, isBatal As Boolean)
        Dim strBatal As String = ""
        Dim sql As String = ""
        Dim jenisLesenDesc = {"mpk_suratmohonulasan", "mpk_suratmohonulasan_psr", "mpk_suratmohonulasan_anj", "mpk_suratmohonulasan_pjj", "mpk_suratmohonulasan_bb"}
        Dim jenisLesenDescLuar = {"mpk_suratmohonulasan_l", "mpk_suratmohonulasan_psr_l", "mpk_suratmohonulasan_anj_l", "mpk_suratmohonulasan_pjj_l", "mpk_suratmohonulasan_bb_l"}

        If isBatal = True Then
            strBatal = "Batal"
        End If

        Try
            sql = "SELECT a.Permohonan_ID, a.TarikhMohon, a.CreatedDt, CAST(a.NamaSyarikat AS varchar(200)) AS NamaSyarikat, a.NoPendaftaran, a.NoAkaun, a.AlamatPremis, a.JenisPerniagaan, a.PemilikBaru, " &
            "a.AlamatBaru, a.JenisPerniagaanBaru, a.NamaBaruSyarikat, a.BillboardLokasi, a.LokasiPasar1, a.LokasiPasar2, a.LokasiPasar3, a.JenisPasar, a.JenisPerniagaanPasar, a.JumlahPetak, a.AnjingAlamat, " &
            "a.AnjingJenisMohon, a.AnjingJenisPremis, a.AlamatPenjajaan, a.JenisPerniagaanPenjaja, a.TarikhBatal, a.PenganjurEkspo, a.NamaEkspo, a.LokasiEkspo, a.NoTelEkspo, a.TarikhEkspo1, a.TarikhEkspo2, " &
            "a.KontraktorIklan, a.NoTelKontraktor, a.UkuranBanting, a.BilBanting, a.TarikhBanting1, a.TarikhBanting2, a.NoResitBanting, a.NoSiriStiker, a.TarikhBanting3, " &
            "a.MasaEkspo1, a.MasaEkspo2, a.Rujukan, a.NoAkaunCukai, a.IsBatal, a.JenisLesenDescList, a.JenisLesenIdList, a.SaizIklanList, a.CahayaIklanList, a.UnitIklanList, a.LokasiList, a.BakaAnjingList, a.AnjingJantanList, " &
            "a.AnjingBetinaList, a.AnjingJantanMandulList, a.AnjingBetinaMandulList, e.JabatanAgensi_Address, e.JabatanAgensi_Kepada, b.Pemohon_Name, b.Pemohon_ICNo, b.Pemohon_PassportNo, b.Pemohon_Address, " &
            "b.Pemohon_Email, b.Pemohon_MobileNo, b.Pemohon_TelNo, g.Users_Fullname, g.Users_Signature " &
            "FROM LESEN_Permohonan a INNER JOIN LESEN_Pemohon b ON a.Permohonan_PemohonID = b.Pemohon_ID INNER JOIN LESEN_PermohonanAgensi" & strBatal & " d ON a.Permohonan_ID = d.Permohonan_ID " &
            "INNER JOIN LESEN_JabatanAgensi e ON d.JabatanAgensi_ID = e.JabatanAgensi_ID " &
            "LEFT JOIN TBL_USERS g ON g.Users_Id = (case when e.JabatanAgensi_Type = 'J' then a.TandatanganMohonUlasanId when e.JabatanAgensi_Type = 'L' then a.TandatanganMohonUlasanLuarId end) " &
            "WHERE d.PermohonanAgensi_ID=" & permohonanAgensiID

            Dim ReportVar As String = jenisLesenDesc(0)

            Select Case jenislesenIdList
                Case "2", "25"
                    ReportVar = jenisLesenDesc(1)
                Case "3"
                    ReportVar = jenisLesenDesc(2)
                Case "4"
                    ReportVar = jenisLesenDesc(3)
                Case "5"
                    ReportVar = jenisLesenDesc(4)
            End Select

            If jabatanAgensiID > 3 Then

                ReportVar = jenisLesenDescLuar(0)

                Select Case jenislesenIdList
                    Case "2", "25"
                        ReportVar = jenisLesenDescLuar(1)
                    Case "3"
                        ReportVar = jenisLesenDescLuar(2)
                    Case "4"
                        ReportVar = jenisLesenDescLuar(3)
                    Case "5"
                        ReportVar = jenisLesenDescLuar(4)
                End Select

            End If

            Dim pobjData(0, 1)
            Dim lStrReportName = ReportVar + ".rpt"

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
        Dim jenisLesenDesc = {"mpk_suratpemeriksaan"}

        Try

            sql = "SELECT a.Permohonan_ID, a.TarikhPemeriksaan, CAST(a.TarikhSuratPemeriksaan AS datetime) AS TarikhSuratPemeriksaan, 
                CAST(a.NamaSyarikat AS varchar(200)) AS NamaSyarikat, 
                f.NoPendaftaran, f.NoAkaun, f.AlamatPremis, f.JenisPerniagaan, f.PemilikBaru, f.AlamatBaru, 
                f.JenisPerniagaanBaru, f.NamaBaruSyarikat, f.BillboardLokasi, f.LokasiPasar1, f.LokasiPasar2, 
                f.LokasiPasar3, f.JenisPasar, f.JenisPerniagaanPasar, f.JumlahPetak, f.AnjingAlamat, e.name AS AnjingJenisPremisDesc, 
                f.AnjingJenisPremis, f.AlamatPenjajaan, f.JenisPerniagaanPenjaja, f.TarikhBatal, f.PenganjurEkspo, 
                f.NamaEkspo, f.LokasiEkspo, f.NoTelEkspo, f.TarikhEkspo1, f.TarikhEkspo2, f.MasaEkspo1, f.MasaEkspo2, 
                f.KontraktorIklan, f.NoTelKontraktor, f.UkuranBanting, f.BilBanting, f.TarikhBanting1, f.TarikhBanting2, f.NoResitBanting, f.NoSiriStiker, f.TarikhBanting3, 
                a.Rujukan, a.RujukanInspektorat, a.NoAkaunCukai, a.IsBatal, a.JenisLesenDescList, a.JenisLesenIdList, f.SaizIklanList, 
                f.CahayaIklanList, f.UnitIklanList, f.LokasiList, f.BakaAnjingList, f.AnjingJantanList, f.AnjingBetinaList, 
                f.AnjingJantanMandulList, f.AnjingBetinaMandulList, 
                b.Pemohon_Name, b.Pemohon_Address, b.Pemohon_ICNo, b.Pemohon_MobileNo, b.Pemohon_TelNo, 
                c.Users_Fullname, c.Users_Signature, d.P1, d.P2, d.P3, d.IsiKandungan 
                FROM LESEN_Permohonan a 
                INNER JOIN LESEN_PermohonanPembetulan f ON a.Permohonan_ID = f.Permohonan_ID 
                INNER JOIN LESEN_Pemohon b ON b.Pemohon_ID=a.Permohonan_PemohonID 
                LEFT JOIN TBL_USERS c ON a.TandatanganPemeriksaanId=c.Users_Id 
                LEFT JOIN LESEN_PermohonanSurat d ON d.Permohonan_ID=a.Permohonan_ID 
                LEFT JOIN TBL_LOOKUPS e ON e.id = a.AnjingJenisPremis 
                WHERE a.Permohonan_ID=@permohonanID ORDER BY d.P1, d.P2, d.P3"

            sql = sql.Replace("@permohonanID", permohonanID)

            Dim ReportVar As String = jenisLesenDesc(0)

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

            Dim SQL As String = "UPDATE LESEN_PermohonanPembetulan SET SaizIklanList=@SaizIklanList, CahayaIklanList=@CahayaIklanList, UnitIklanList=@UnitIklanList, LokasiList = @LokasiList,
                        BakaAnjingList=@BakaAnjingList, AnjingJantanList=@AnjingJantanList, AnjingBetinaList=@AnjingBetinaList, AnjingJantanMandulList=@AnjingJantanMandulList, AnjingBetinaMandulList=@AnjingBetinaMandulList, 
                        NamaSyarikat = @NamaSyarikat, NoPendaftaran = @NoPendaftaran, NoAkaun = @NoAkaun, AlamatPremis = @AlamatPremis, JenisPerniagaan = @JenisPerniagaan, PemilikBaru = @PemilikBaru, 
                        AlamatBaru = @AlamatBaru, JenisPerniagaanBaru = @JenisPerniagaanBaru, NamaBaruSyarikat = @NamaBaruSyarikat, 
                        BillboardLokasi = @BillboardLokasi, LokasiPasar1 = @LokasiPasar1, LokasiPasar2 = @LokasiPasar2, LokasiPasar3 = @LokasiPasar3,
                        JenisPasar = @JenisPasar, JenisPerniagaanPasar = @JenisPerniagaanPasar, JumlahPetak = @JumlahPetak, AnjingAlamat = @AnjingAlamat, AnjingJenisPremis = @AnjingJenisPremis, 
                        AlamatPenjajaan = @AlamatPenjajaan, JenisPerniagaanPenjaja = @JenisPerniagaanPenjaja, PenganjurEkspo = @PenganjurEkspo, NamaEkspo = @NamaEkspo, LokasiEkspo = @LokasiEkspo, NoTelEkspo = @NoTelEkspo, 
                        TarikhEkspo1 = @TarikhEkspo1, TarikhEkspo2 = @TarikhEkspo2, MasaEkspo1 = @MasaEkspo1, MasaEkspo2 = @MasaEkspo2, 
                        KontraktorIklan = @KontraktorIklan, NoTelKontraktor = @NoTelKontraktor, UkuranBanting = @UkuranBanting, BilBanting = @BilBanting, TarikhBanting1 = @TarikhBanting1, TarikhBanting2 = @TarikhBanting2, 
                        NoResitBanting = @NoResitBanting, NoSiriStiker=@NoSiriStiker, TarikhBanting3=@TarikhBanting3, LastModDt = GETDATE() 
                        WHERE Permohonan_ID = @Permohonan_ID"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", PermohonanID)
            myCommandSelect.Parameters.AddWithValue("@NamaSyarikat", TB_NamaSyarikat_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@SaizIklanList", HF_SaizIklanList_ins.Value)
            myCommandSelect.Parameters.AddWithValue("@CahayaIklanList", HF_CahayaIklanList_ins.Value)
            myCommandSelect.Parameters.AddWithValue("@UnitIklanList", HF_UnitIklanList_ins.Value)
            myCommandSelect.Parameters.AddWithValue("@LokasiList", HF_LokasiList_ins.Value)
            myCommandSelect.Parameters.AddWithValue("@BakaAnjingList", HF_BakaAnjingList_ins.Value)
            myCommandSelect.Parameters.AddWithValue("@AnjingJantanList", HF_AnjingJantanList_ins.Value)
            myCommandSelect.Parameters.AddWithValue("@AnjingBetinaList", HF_AnjingBetinaList_ins.Value)
            myCommandSelect.Parameters.AddWithValue("@AnjingJantanMandulList", HF_AnjingJantanMandulList_ins.Value)
            myCommandSelect.Parameters.AddWithValue("@AnjingBetinaMandulList", HF_AnjingBetinaMandulList_ins.Value)
            myCommandSelect.Parameters.AddWithValue("@NoPendaftaran", TB_NoPendaftaran_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@NoAkaun", TB_NoAkaun_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@AlamatPremis", TB_AlamatPremis_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@JenisPerniagaan", TB_JenisPerniagaan_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@PemilikBaru", TB_PemilikBaru_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@AlamatBaru", TB_AlamatBaru_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@JenisPerniagaanBaru", TB_JenisPerniagaanBaru_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@NamaBaruSyarikat", TB_NamaBaruSyarikat_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@BillboardLokasi", TB_BillboardLokasi_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@LokasiPasar1", TB_LokasiPasar1_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@LokasiPasar2", TB_LokasiPasar2_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@LokasiPasar3", TB_LokasiPasar3_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@JenisPasar", DDL_JenisPasar_ins.SelectedValue)
            myCommandSelect.Parameters.AddWithValue("@JenisPerniagaanPasar", TB_JenisPerniagaanPasar_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@JumlahPetak", TB_JumlahPetak_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@AnjingAlamat", TB_AnjingAlamat_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@AnjingJenisPremis", DDL_AnjingJenisPremis_ins.SelectedValue)
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
            myCommandSelect.Parameters.AddWithValue("@KontraktorIklan", TB_KontraktorIklan_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@NoTelKontraktor", TB_NoTelKontraktor_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@UkuranBanting", TB_UkuranBanting_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@BilBanting", TB_BilBanting_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@TarikhBanting1", TB_TarikhBanting1_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@TarikhBanting2", TB_TarikhBanting2_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@NoResitBanting", TB_NoResitBanting_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@NoSiriStiker", TB_NoSiriStiker_ins.Text)
            myCommandSelect.Parameters.AddWithValue("@TarikhBanting3", TB_TarikhBanting3_ins.Text)

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
