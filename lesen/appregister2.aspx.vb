Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Drawing.Imaging
Imports System.Security.Cryptography
Imports System.Security.Policy
Imports Microsoft.SqlServer.Management.Smo

<Serializable()>
Public Class SelectedItem
    Public Property ItemText As String
    Public Property ItemValue As String
End Class

Partial Class appregister2
    Inherits System.Web.UI.Page

    Public Shared CS As [String] = ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString

    Protected Sub Page_PreRenderComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRenderComplete

        Try

            If FormView1.CurrentMode = 1 Then

                Dim btnBack As LinkButton = DirectCast(FormView1.FindControl("BackButton"), LinkButton)

                'Dim ApprovalStatus As String = hdnFldStatus.Value

                Dim frmview() As Object = {FormView1}
                Dim lbutton() As Object = {btnBack}
                Dim ctlDeny() As Object = {BtnSaveMesyuarat, ButtonAddAssignment} '//deny control
                Dim ctlDenyRaw() As Object = {} '//deny control

                '//check Write
                Dim frmwrite As Boolean = GlobalClass.CheckPageWrite("Write", frmview, lbutton, ctlDeny)
                '// check gridview permission
                If frmwrite = False Then
                    '//gridview select view
                    'GridView1.Columns.Item(12).Visible = False '//grid delete
                    'GridView1.Columns.Item(10).Visible = False '//grid delete
                    gvTabPublicAttach.Columns.Item(4).Visible = False
                    gvTabPublicAttach.Columns.Item(5).Visible = False
                    gvTabUlasan.Columns.Item(4).Visible = False '//grid delete
                    gvTabUlasan.Columns.Item(5).Visible = False '//grid delete
                    'GridViewJabatanAgensiBatal.Columns.Item(3).Visible = False '//grid delete
                    'GridViewMaintenanceTemplate.Columns.Item(3).Visible = False '//grid delete
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

        TabContainer1.Visible = True

        FormView1.Visible = True
        FormView1.ChangeMode(FormViewMode.Edit)
        whiteCard.Visible = False

        Dim pid As Integer = CInt(GridView1.SelectedDataKey.Values("Permohonan_ID"))
        Dim statusid As Integer = CInt(GridView1.SelectedDataKey.Values("StatusID"))
        Dim isbatal As Boolean = CBool(GridView1.SelectedDataKey.Values("IsBatal"))
        Dim ispublish As Boolean = CBool(GridView1.SelectedDataKey.Values("IsPublish"))
        Dim jidList() As String = CStr(GridView1.SelectedDataKey.Values("JenisLesenIdList")).Split(","c)

        If isbatal Then
            tabKadarBayaran.Visible = False
            tabMesyuarat.Visible = True
            GetMesyuarat(pid)
        Else
            tabKadarBayaran.Visible = True
            tabMesyuarat.Visible = False
        End If

        If ispublish And tabKadarBayaran.Visible = True Then
            gvTabBayaran.Columns(5).Visible = False
            gvTabBayaran.Columns(6).Visible = False
        Else
            gvTabBayaran.Columns(5).Visible = True
            gvTabBayaran.Columns(6).Visible = True
        End If

    End Sub

    Private Sub GridView1_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles GridView1.RowCommand

    End Sub

    Private Sub GridView1_DataBound(sender As Object, e As EventArgs) Handles GridView1.DataBound

    End Sub

    Private Sub GridView1_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles GridView1.RowDataBound

    End Sub

    Private Sub GridView1_RowDeleted(sender As Object, e As GridViewDeletedEventArgs) Handles GridView1.RowDeleted
        ShowAlert("success", "", "Rekod telah dipadam!")
    End Sub

    Private Sub FormView1_ItemInserting(sender As Object, e As FormViewInsertEventArgs) Handles FormView1.ItemInserting

    End Sub

    Private Sub FormView1_ItemInserted(sender As Object, e As FormViewInsertedEventArgs) Handles FormView1.ItemInserted
        Session.Item("isInserted") = True
        GridView1.DataBind()
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

        Dim lbljenisperniagaan As Label = DirectCast(FormView1.FindControl("Lbl_JenisPerniagaanBaru"), Label)
        Dim lblalamat As Label = DirectCast(FormView1.FindControl("Lbl_AlamatBaru"), Label)

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
            Case 1, 30                       'Lesen Perniagaan / Permit Perniagaan Sementara
                pnla.Visible = True
                pnla1.Visible = True
            Case 6, 7, 28                     'Tukar Alamat Perniagaan, Tambah Premis, Kurang Premis /
                pnla.Visible = True
                pnla1.Visible = True
                pnla3.Visible = True

                If lesenid = 28 Then
                    lblalamat.Text = "Alamat Pengurangan Premis"
                ElseIf lesenid = 7 Then
                    lblalamat.Text = "Alamat Premis Tambahan"
                Else
                    lblalamat.Text = "Alamat Baru"
                End If
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
            Case 10, 12, 16                     'Tambah, Tukar, Pengurangan Visual Iklan /
                pnla.Visible = True
                pnla1.Visible = True
            Case 5                          ' billboard /
                pnla.Visible = True
                pnla1.Visible = True
                pnlbillboard.Visible = True
            Case 8, 29                     'Tambah, pengurangan Jenis Perniagaan /
                pnla.Visible = True
                pnla3.Visible = True
                pnla4.Visible = True

                lblalamat.Text = "Alamat Baru"

                If lesenid = 8 Then
                    lbljenisperniagaan.Text = "Jenis Perniagaan Tambahan"
                Else
                    lbljenisperniagaan.Text = "Pengurangan Jenis Perniagaan"
                End If
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
            Case 27   'Banting
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
        Dim HF_LokasiList As HiddenField = DirectCast(FormView1.FindControl("HF_LokasiList"), HiddenField)

        If HF_LokasiList.Value.ToString.Length = 0 Then
            HF_LokasiList.Value = lokasiVal
        Else
            HF_LokasiList.Value += "||" + lokasiVal
        End If

    End Sub

    Protected Sub ddlItems_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        Dim ddlItems As DropDownList = DirectCast(FormView1.FindControl("ddlItems"), DropDownList)
        If String.IsNullOrEmpty(ddlItems.SelectedValue) Then Return

        Dim myList = DirectCast(ViewState("SelectedList"), List(Of SelectedItem))

        If myList.Any(Function(x) x.ItemValue = "3") Or
            myList.Any(Function(x) x.ItemValue = "5") Or
            myList.Any(Function(x) x.ItemValue = "25") Or
            myList.Any(Function(x) x.ItemValue = "27") Or
            (myList.Count > 0 And
            (ddlItems.SelectedValue = "3" Or
            ddlItems.SelectedValue = "5" Or
            ddlItems.SelectedValue = "25" Or
            ddlItems.SelectedValue = "27")) Then

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
                insertKadarBayaran(JenisLesenIdList, PermohonanID)

            End If

            ShowAlert("success", "", "Rekod permohonan " & strAlert & " telah disimpan.")

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

                tabKadarBayaran.Visible = False
                tabMesyuarat.Visible = True
            End If

        End If

        GridView1.DataBind()
        ShowAlert("success", "", "Rekod permohonan " & Is24Jam & " telah dikemaskini.")
    End Sub

    Private Sub ButtonAddAssignment_Click(sender As Object, e As EventArgs) Handles ButtonAddAssignment.Click
        DDL_Status.SelectedValue = 0
        Session.Item("isInserted") = False
        FormView1.Visible = True
        FormView1.ChangeMode(FormViewMode.Insert)

        whiteCard.Visible = False
    End Sub

    Protected Sub BackButton_Click(sender As Object, e As EventArgs)
        'Response.Redirect(Request.Url.AbsoluteUri)
        backToList()
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

        Dim lbljenisperniagaan As Label = DirectCast(FormView1.FindControl("Lbl_JenisPerniagaanBaru"), Label)
        Dim lblalamat As Label = DirectCast(FormView1.FindControl("Lbl_AlamatBaru"), Label)

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
            Case 1, 30                       'Lesen Perniagaan /
                pnla.Visible = True
                pnla1.Visible = True
            Case 6, 7, 28                     'Tukar Alamat Perniagaan, Tambah Premis, Pengurangan Premis /
                pnla.Visible = True
                pnla1.Visible = True
                pnla3.Visible = True

                If ddl.SelectedValue = 28 Then
                    lblalamat.Text = "Alamat Pengurangan Premis"
                ElseIf ddl.SelectedValue = 7 Then
                    lblalamat.Text = "Alamat Premis Tambahan"
                Else
                    lblalamat.Text = "Alamat Baru"
                End If
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
            Case 10, 12, 16                     'Tambah, Tukar, Pengurangan Visual Iklan /
                pnla.Visible = True
                pnla1.Visible = True
            Case 5                          ' billboard /
                pnla.Visible = True
                pnla1.Visible = True
                pnlbillboard.Visible = True
            Case 8, 29                     'Tambah, Pengurangan Jenis Perniagaan /
                pnla.Visible = True
                pnla3.Visible = True
                pnla4.Visible = True

                lblalamat.Text = "Alamat Baru"

                If ddl.SelectedValue = 8 Then
                    lbljenisperniagaan.Text = "Jenis Perniagaan Tambahan"
                Else
                    lbljenisperniagaan.Text = "Pengurangan Jenis Perniagaan"
                End If
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
        Dim pnlbatal3 As Panel = DirectCast(FormView1.FindControl("pnlbatal5"), Panel)

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
                    pnlbatal3.Visible = True

                ElseIf ddl2.SelectedIndex = 2 Then
                    pnlbatal2.Visible = True
                    pnlbatal3.Visible = True
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
                        If Not String.IsNullOrWhiteSpace(SaizIklanList(i)) Then
                            Dim newRow As DataRow = dt.NewRow()
                            newRow("SaizIklan") = SaizIklanList(i).Trim()
                            newRow("Bercahaya") = CahayaIklanList(i).Trim()
                            newRow("Unit") = UnitIklanList(i).Trim()

                            dt.Rows.Add(newRow)
                        End If
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
                        If Not String.IsNullOrWhiteSpace(BakaAnjingList(i)) Then
                            Dim newRow As DataRow = dt.NewRow()
                            newRow("Baka") = BakaAnjingList(i).Trim()
                            newRow("Jantan") = JantanList(i).Trim()
                            newRow("Betina") = BetinaList(i).Trim()
                            newRow("JantanMandul") = JantanMandulList(i).Trim()
                            newRow("BetinaMandul") = BetinaMandulList(i).Trim()

                            dt.Rows.Add(newRow)
                        End If

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
                        If Not String.IsNullOrWhiteSpace(LokasiList(i)) Then
                            Dim newRow As DataRow = dt.NewRow()
                            newRow("No") = (i + 1).ToString
                            newRow("Lokasi") = LokasiList(i).Trim()

                            dt.Rows.Add(newRow)
                        End If
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

    Private Sub backToList()
        FormView1.Visible = False
        whiteCard.Visible = True
        TabContainer1.Visible = False
        GridView1.SelectedIndex = -1
        GridView1.DataBind()
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

    Protected Sub btnAddNewUpload1_Click(sender As Object, e As EventArgs)

        Dim Permohonan_ID As Integer = CInt(GridView1.SelectedValue)

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            'LA = Lampiran Awam

            Dim SQL As String = ""

            SQL = "INSERT INTO LESEN_PermohonanFail (PermohonanFail_PermohonanID,PermohonanFail_JenisLampiran,CreatedDt,CreatorID) VALUES 
                 (@Permohonan_ID, 'LA', getdate(), @SessionUserName) "

            Dim myCommand As New SqlCommand(SQL, myConnection)

            myCommand.Parameters.AddWithValue("@Permohonan_ID", Permohonan_ID)
            myCommand.Parameters.AddWithValue("@SessionUsersId", Session.Item("SessionUsersId"))
            myCommand.Parameters.AddWithValue("@SessionUserName", Session.Item("SessionUserName"))

            myConnection.Open()

            Dim recordset As Integer = myCommand.ExecuteNonQuery()

            '//start insert

            If recordset Then
                gvTabPublicAttach.EditIndex = CInt(gvTabPublicAttach.Rows.Count)

            End If

            myConnection.Close()

            gvTabPublicAttach.DataBind()

            Page.SetFocus(Me.ui_btnPageBottom.ClientID)

        End Using

    End Sub

    Private Sub gvTabPublicAttach_RowUpdated(sender As Object, e As GridViewUpdatedEventArgs) Handles gvTabPublicAttach.RowUpdated
        '//
    End Sub
    Private Sub gvTabPublicAttach_RowUpdating(sender As Object, e As GridViewUpdateEventArgs) Handles gvTabPublicAttach.RowUpdating


        Dim LinkButton1 As LinkButton = CType(gvTabPublicAttach.Rows(e.RowIndex).FindControl("LinkButton1"), LinkButton)
        'Dim updatePanelUlasan As UpdatePanel = CType(gvTabUlasan.Rows(e.RowIndex).FindControl("updatePanelUlasan"), UpdatePanel)
        Dim fu As FileUpload = CType(gvTabPublicAttach.Rows(e.RowIndex).FindControl("FU_PermohonanFail"), FileUpload)
        'Dim txtPermohonanFail_FilePath As FileUpload = CType(gvTabUlasan.Rows(e.RowIndex).FindControl("txtPermohonanFail_FilePath"), FileUpload)
        Dim btnUpload As Button = CType(gvTabPublicAttach.Rows(e.RowIndex).FindControl("btnUpload"), Button)

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

    Private Sub gvTabPublicAttach_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvTabPublicAttach.RowDataBound

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

    Private Sub gvTabPublicAttach_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvTabPublicAttach.RowDeleting


        If e.Values("PermohonanFail_FilePath") <> "" Then

            Dim deleteFilePath As String = Server.MapPath(e.Values("PermohonanFail_FilePath"))

            If System.IO.File.Exists(deleteFilePath) Then
                System.IO.File.Delete(deleteFilePath)
            End If

        End If

    End Sub

    Private Sub gvTabPublicAttach_DataBound(sender As Object, e As EventArgs) Handles gvTabPublicAttach.DataBound
    End Sub

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
        Dim pnl2 As Panel = DirectCast(FormView1.FindControl("pnlbatal5"), Panel)

        pnl.Visible = False
        pnl1.Visible = False

        If ddl.SelectedIndex = 1 Then
            pnl.Visible = True
            pnl2.Visible = True
        ElseIf ddl.SelectedIndex = 2 Then
            pnl1.Visible = True
            pnl2.Visible = True
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

        Dim ddl As DropDownList = DirectCast(FormView1.FindControl("DDL_JenisPasar"), DropDownList)
        Dim noruj As TextBox = DirectCast(FormView1.FindControl("TB_Rujukan"), TextBox)

        Select Case ddl.SelectedIndex
            Case 1                      'Pasar Pagi /
                noruj.Text = "MPK/599/401/26/PP"

            Case 2                      'Pasar Malam /
                noruj.Text = "MPK/599/401/3/33"

            Case Else                      'Pasar Lambak /
                noruj.Text = "MPK/599/401/"

        End Select

    End Sub

End Class
