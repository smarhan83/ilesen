Imports System
Imports System.Collections.Generic
Imports System.Configuration
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Drawing.Imaging
Imports System.IO
Imports System.Linq
Imports System.Web.UI
Imports System.Web.UI.HtmlControls
Imports System.Web.UI.WebControls

#Region "Model Classes"
''' <summary>
''' Represents a selected licence or permit item chosen from the dropdown list.
''' Stored in ViewState("SelectedList") for multi-licence selection tag display.
''' </summary>
<Serializable()>
Public Class SelectedItem
    Public Property ItemText As String
    Public Property ItemValue As String
End Class
#End Region

Partial Class appregister2
    Inherits System.Web.UI.Page

#Region "Fields & Constants"
    Public Shared ReadOnly CS As String = ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString
    Private Const MaxFileSizeInBytes As Integer = 5 * 1024 * 1024 ' 5 MB max upload
#End Region

#Region "Page Lifecycle & Permissions"

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Try
                If CInt(Request.QueryString("pid")) = 0 Then
                    Try
                        DDL_CreatedBy.SelectedValue = Session.Item("sessionUserName")
                    Catch ex As Exception
                        ' Fallback if session username not in dropdown list
                    End Try
                End If

                ViewState("SelectedList") = New List(Of SelectedItem)()
            Catch ex As Exception
                ' Safe fallback
            End Try
        Else
            Session.Item("isInserted") = False
        End If

        TB_PermohonanID.Attributes.Add("style", "display:none")

        If Not IsPostBack Then
            Try
                ' If page requested with specific Application ID (pid), auto-trigger search
                If CInt(Request.QueryString("pid")) > 0 Then
                    ButtonAddAssignment.Visible = False

                    Dim script As String = "<script>" &
                        "document.getElementById('MainContent_TB_PermohonanID').value = '" & Request.QueryString("pid") & "';" &
                        "document.getElementById('MainContent_btnSearch').click();" &
                        "</script>"

                    Page.ClientScript.RegisterStartupScript(Me.GetType(), "showPage", script, False)
                    panelFilter.Attributes.Add("style", "display:none")
                End If
            Catch ex As Exception
                ' Ignore query string parsing errors
            End Try
        End If

        Page.Form.Attributes.Add("enctype", "multipart/form-data")
    End Sub

    Protected Sub Page_PreRenderComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRenderComplete
        Try
            ' Check write permissions when FormView is in Edit mode
            If FormView1.CurrentMode = FormViewMode.Edit Then
                Dim btnBack As LinkButton = DirectCast(FormView1.FindControl("BackButton"), LinkButton)
                Dim frmview() As Object = {FormView1}
                Dim lbutton() As Object = {btnBack}
                Dim ctlDeny() As Object = {BtnSaveMesyuarat, ButtonAddAssignment}

                Dim frmwrite As Boolean = GlobalClass.CheckPageWrite("Write", frmview, lbutton, ctlDeny)

                If Not frmwrite Then
                    ' Hide action/delete columns if user does not have write access
                    gvTabPublicAttach.Columns.Item(4).Visible = False
                    gvTabPublicAttach.Columns.Item(5).Visible = False
                    gvTabUlasan.Columns.Item(4).Visible = False
                    gvTabUlasan.Columns.Item(5).Visible = False
                    gvTabBayaran.Columns.Item(4).Visible = False
                    gvTabBayaran.Columns.Item(5).Visible = False
                    gvTabBayaran.Columns.Item(6).Visible = False
                End If
            End If
        Catch ex As Exception
            ' Ignore permission check errors
        End Try
    End Sub

#End Region

#Region "Alerts & Notifications"

    ''' <summary>
    ''' Displays a client-side JavaScript alert box.
    ''' </summary>
    Public Sub MessageBox(ByVal msg As String, Optional ByVal obj As System.Web.UI.Page = Nothing)
        Dim safeMsg As String = msg.Replace("'", "\'").Replace(vbCrLf, "\n")
        ScriptManager.RegisterClientScriptBlock(Me.Page, Me.GetType(), "Alert", "alert('" & safeMsg & "');", True)
    End Sub

    ''' <summary>
    ''' Displays a modern SweetAlert modal message.
    ''' </summary>
    ''' <param name="statusMsg">Icon type: 'success', 'error', 'warning', 'info'</param>
    ''' <param name="titleMsg">Title of the alert modal</param>
    ''' <param name="strMsg">Detailed body message</param>
    Private Sub ShowAlert(statusMsg As String, titleMsg As String, strMsg As String)
        Dim safeTitle As String = titleMsg.Replace("'", "\'")
        Dim safeBody As String = strMsg.Replace("'", "\'")
        Dim safeStatus As String = statusMsg.Replace("'", "\'")
        Dim script As String = String.Format("Swal.fire('{0}','{1}','{2}');", safeTitle, safeBody, safeStatus)
        ScriptManager.RegisterStartupScript(Me, Page.GetType(), "Script", script, True)
    End Sub

#End Region

#Region "Main GridView & Search Filter"

    Private Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearch.Click
        GridView1.DataBind()
    End Sub

    Private Sub btnReset_Click(sender As Object, e As EventArgs) Handles btnReset.Click
        Response.Redirect(Request.RawUrl)
    End Sub

    Private Sub ButtonAddAssignment_Click(sender As Object, e As EventArgs) Handles ButtonAddAssignment.Click
        Session.Item("isInserted") = False
        FormView1.Visible = True
        FormView1.ChangeMode(FormViewMode.Insert)
        whiteCard.Visible = False
    End Sub

    Private Sub GridView1_SelectedIndexChanged(sender As Object, e As EventArgs) Handles GridView1.SelectedIndexChanged
        TabContainer1.Visible = True
        FormView1.Visible = True
        FormView1.ChangeMode(FormViewMode.Edit)
        whiteCard.Visible = False

        Dim pid As Integer = CInt(GridView1.SelectedDataKey.Values("Permohonan_ID"))
        Dim isbatal As Boolean = CBool(GridView1.SelectedDataKey.Values("IsBatal"))
        Dim ispublish As Boolean = CBool(GridView1.SelectedDataKey.Values("IsPublish"))

        ' Toggle Kadar Bayaran vs Mesyuarat tab based on cancellation status
        If isbatal Then
            tabKadarBayaran.Visible = False
            tabMesyuarat.Visible = True
            GetMesyuarat(pid)
        Else
            tabKadarBayaran.Visible = True
            tabMesyuarat.Visible = False
        End If

        ' Hide action columns in Kadar Bayaran if record is already published
        If ispublish AndAlso tabKadarBayaran.Visible Then
            gvTabBayaran.Columns(5).Visible = False
            gvTabBayaran.Columns(6).Visible = False
        Else
            gvTabBayaran.Columns(5).Visible = True
            gvTabBayaran.Columns(6).Visible = True
        End If
    End Sub

    Private Sub GridView1_RowDeleted(sender As Object, e As GridViewDeletedEventArgs) Handles GridView1.RowDeleted
        ShowAlert("success", "", "Rekod telah dipadam!")
    End Sub

    Protected Sub BackButton_Click(sender As Object, e As EventArgs)
        backToList()
    End Sub

    Private Sub backToList()
        FormView1.Visible = False
        whiteCard.Visible = True
        TabContainer1.Visible = False
        GridView1.SelectedIndex = -1
        GridView1.DataBind()
    End Sub

#End Region

#Region "FormView Mode & Event Handlers"

    Private Sub FormView1_ItemInserted(sender As Object, e As FormViewInsertedEventArgs) Handles FormView1.ItemInserted
        Session.Item("isInserted") = True
        GridView1.DataBind()
        TabContainer1.Visible = True
    End Sub

    Private Sub FormView1_ItemUpdating(sender As Object, e As FormViewUpdateEventArgs) Handles FormView1.ItemUpdating
        Dim cb As CheckBox = DirectCast(FormView1.FindControl("CB_IsBatal"), CheckBox)
        If cb IsNot Nothing AndAlso cb.Visible AndAlso cb.Checked Then
            e.NewValues("StatusID") = 0
        End If
    End Sub

    Private Sub FormView1_ItemUpdated(sender As Object, e As FormViewUpdatedEventArgs) Handles FormView1.ItemUpdated
        Dim is24JamText As String = ""
        Dim cb24h As CheckBox = DirectCast(FormView1.FindControl("CB_24h"), CheckBox)

        If cb24h IsNot Nothing AndAlso Not cb24h.Checked Then
            is24JamText = "BUKAN"
        End If

        If Not IsDBNull(e.NewValues("Permohonan_ID")) Then
            Dim isBatal As Boolean = CBool(e.NewValues("IsBatal"))

            If isBatal AndAlso (e.OldValues("IsBatal") Is Nothing OrElse isBatal <> CBool(e.OldValues("IsBatal"))) Then
                tabKadarBayaran.Visible = False
                tabMesyuarat.Visible = True
            End If
        End If

        GridView1.DataBind()
        ShowAlert("success", "", "Rekod permohonan " & is24JamText & " telah dikemaskini.")
    End Sub

    Private Sub SqlDataSourceForm_Inserted(sender As Object, e As SqlDataSourceStatusEventArgs) Handles SqlDataSourceForm.Inserted
        Dim permohonanID As Integer = -1
        Dim strAlert As String = ""

        If Not IsDBNull(e.Command.Parameters("@Permohonan_ID").Value) Then
            permohonanID = CInt(e.Command.Parameters("@Permohonan_ID").Value)
            Dim jenisLesenIdList As String = Convert.ToString(e.Command.Parameters("@JenisLesenIdList").Value)
            Dim isBatal As Boolean = CBool(e.Command.Parameters("@IsBatal").Value)
            Dim is24Jam As Boolean = CBool(e.Command.Parameters("@Is24Jam").Value)

            If Not is24Jam Then
                strAlert = "BUKAN"
            End If

            If Not isBatal Then
                insertKadarBayaran(jenisLesenIdList, permohonanID)
            End If

            ShowAlert("success", "", "Rekod permohonan " & strAlert & " telah disimpan.")
        End If

        GridView1.DataBind()

        ' Select the newly inserted row in GridView
        For n As Integer = 0 To GridView1.DataKeys.Count - 1
            If CInt(GridView1.DataKeys(n).Value) = permohonanID Then
                GridView1.SelectRow(n)
                Exit For
            End If
        Next

        If GridView1.SelectedIndex = -1 Then
            FormView1.ChangeMode(FormViewMode.Insert)
            ButtonAddAssignment.Visible = True
        End If
    End Sub

    Private Sub FormView1_DataBound(sender As Object, e As EventArgs) Handles FormView1.DataBound
        initPageName()

        If FormView1.CurrentMode <> FormViewMode.Edit Then
            Return
        End If

        Try
            ' 1. Load Multi-Licence Tags into ViewState & Repeater
            LoadSelectedLicencesFromHiddenFields()

            ' 2. Handle Cancellation panels visibility
            Dim ddlJenisBatal As DropDownList = DirectCast(FormView1.FindControl("DDL_JenisBatal"), DropDownList)
            Dim pnlBatalSebab1 As Panel = DirectCast(FormView1.FindControl("pnlbatal3"), Panel)
            Dim pnlBatalSebab2 As Panel = DirectCast(FormView1.FindControl("pnlbatal4"), Panel)
            Dim pnlBatalCatatan As Panel = DirectCast(FormView1.FindControl("pnlbatal5"), Panel)

            If ddlJenisBatal IsNot Nothing Then
                If ddlJenisBatal.SelectedIndex = 1 Then
                    If pnlBatalSebab1 IsNot Nothing Then pnlBatalSebab1.Visible = True
                    If pnlBatalCatatan IsNot Nothing Then pnlBatalCatatan.Visible = True
                ElseIf ddlJenisBatal.SelectedIndex = 2 Then
                    If pnlBatalSebab2 IsNot Nothing Then pnlBatalSebab2.Visible = True
                    If pnlBatalCatatan IsNot Nothing Then pnlBatalCatatan.Visible = True
                End If
            End If

            ' 3. Populate Child Data Grids from Hidden Fields
            PopulateIklanGridFromHiddenFields()
            PopulateAnjingGridFromHiddenFields()
            PopulateLokasiGridFromHiddenFields()

            ' 4. Fetch & Populate Applicant Details
            Dim tbApplicantId As TextBox = DirectCast(FormView1.FindControl("TB_PemohonID"), TextBox)
            If tbApplicantId IsNot Nothing AndAlso Not String.IsNullOrWhiteSpace(tbApplicantId.Text) Then
                LoadApplicantDetails(tbApplicantId.Text)
            End If

        Catch ex As Exception
            ' Safe log or catch
        End Try
    End Sub

#End Region

#Region "License Categories & Dynamic Panels (PanelAccess)"

    ''' <summary>
    ''' Controls the visibility of category-specific form panels based on the selected licence types.
    ''' </summary>
    ''' <param name="lesenId">The licence ID to display fields for.</param>
    ''' <param name="clearAll">If true, resets all panels to hidden.</param>
    Private Sub PanelAccess(lesenId As Integer, clearAll As Boolean)
        Dim pnla As Panel = DirectCast(FormView1.FindControl("pnlesen1"), Panel)       ' Perniagaan
        Dim pnla1 As Panel = DirectCast(FormView1.FindControl("pnlesen1a"), Panel)     ' Iklan
        Dim pnla2 As Panel = DirectCast(FormView1.FindControl("pnlesen1b"), Panel)     ' Tukar Pemilik
        Dim pnla3 As Panel = DirectCast(FormView1.FindControl("pnlesen1c"), Panel)     ' Tukar Alamat
        Dim pnla4 As Panel = DirectCast(FormView1.FindControl("pnlesen1d"), Panel)     ' Tambah Perniagaan
        Dim pnla5 As Panel = DirectCast(FormView1.FindControl("pnlesen1e"), Panel)     ' Tukar Nama Syarikat
        Dim pnlb As Panel = DirectCast(FormView1.FindControl("pnlesen2"), Panel)       ' Pasar
        Dim pnlc As Panel = DirectCast(FormView1.FindControl("pnlesen3"), Panel)       ' Anjing
        Dim pnld As Panel = DirectCast(FormView1.FindControl("pnlesen4"), Panel)       ' Penjaja
        Dim pnle As Panel = DirectCast(FormView1.FindControl("pnlesen5"), Panel)       ' Ekspo
        Dim pnl6 As Panel = DirectCast(FormView1.FindControl("pnlesen6"), Panel)       ' Banting
        Dim pnlf As Panel = DirectCast(FormView1.FindControl("pnlrujukan"), Panel)     ' No Rujukan
        Dim pnlbatal1 As Panel = DirectCast(FormView1.FindControl("pnlbatal1"), Panel) ' Pembatalan
        Dim pnlbillboard As Panel = DirectCast(FormView1.FindControl("pnlbillboard"), Panel)

        Dim noruj As TextBox = DirectCast(FormView1.FindControl("TB_Rujukan"), TextBox)
        Dim lblJenisPerniagaan As Label = DirectCast(FormView1.FindControl("Lbl_JenisPerniagaanBaru"), Label)
        Dim lblAlamat As Label = DirectCast(FormView1.FindControl("Lbl_AlamatBaru"), Label)

        If clearAll Then
            If pnlbillboard IsNot Nothing Then pnlbillboard.Visible = False
            If pnla IsNot Nothing Then pnla.Visible = False
            If pnla1 IsNot Nothing Then pnla1.Visible = False
            If pnla2 IsNot Nothing Then pnla2.Visible = False
            If pnla3 IsNot Nothing Then pnla3.Visible = False
            If pnla4 IsNot Nothing Then pnla4.Visible = False
            If pnla5 IsNot Nothing Then pnla5.Visible = False
            If pnlb IsNot Nothing Then pnlb.Visible = False
            If pnlc IsNot Nothing Then pnlc.Visible = False
            If pnld IsNot Nothing Then pnld.Visible = False
            If pnle IsNot Nothing Then pnle.Visible = False
            If pnl6 IsNot Nothing Then pnl6.Visible = False
            If pnlf IsNot Nothing Then pnlf.Visible = False
            If pnlbatal1 IsNot Nothing Then pnlbatal1.Visible = False
            Exit Sub
        End If

        If pnlf IsNot Nothing Then pnlf.Visible = True
        If pnlbatal1 IsNot Nothing Then pnlbatal1.Visible = True

        If FormView1.CurrentMode = FormViewMode.Insert AndAlso noruj IsNot Nothing Then
            noruj.Text = "MPK/599/401/"
        End If

        Select Case lesenId
            Case 0
                If pnlf IsNot Nothing Then pnlf.Visible = False
                If pnlbatal1 IsNot Nothing Then pnlbatal1.Visible = False

            Case 3 ' Lesen Anjing
                If pnlc IsNot Nothing Then pnlc.Visible = True
                If FormView1.CurrentMode = FormViewMode.Insert AndAlso noruj IsNot Nothing Then
                    noruj.Text = "MPK/599/401/209/LA"
                End If

            Case 2, 25 ' Pasar Lambak, Tambah Petak
                If pnlb IsNot Nothing Then pnlb.Visible = True

            Case 4 ' Pasar Penjaja
                If pnld IsNot Nothing Then pnld.Visible = True

            Case 1, 30 ' Lesen Perniagaan / Permit Perniagaan Sementara
                If pnla IsNot Nothing Then pnla.Visible = True
                If pnla1 IsNot Nothing Then pnla1.Visible = True

            Case 6, 7, 28 ' Tukar Alamat Perniagaan, Tambah Premis, Kurang Premis
                If pnla IsNot Nothing Then pnla.Visible = True
                If pnla1 IsNot Nothing Then pnla1.Visible = True
                If pnla3 IsNot Nothing Then pnla3.Visible = True

                If lblAlamat IsNot Nothing Then
                    If lesenId = 28 Then
                        lblAlamat.Text = "Alamat Pengurangan Premis"
                    ElseIf lesenId = 7 Then
                        lblAlamat.Text = "Alamat Premis Tambahan"
                    Else
                        lblAlamat.Text = "Alamat Baru"
                    End If
                End If

            Case 13, 17, 18 ' Permit Kaki Lima, Lot Tepi Kedai, Lebuh Awam
                If pnla IsNot Nothing Then pnla.Visible = True

            Case 14 ' Pembatalan Lesen & Wang Amanah
                If pnla IsNot Nothing Then pnla.Visible = True

            Case 11, 23, 26 ' Tukar Nama Syarikat
                If pnla IsNot Nothing Then pnla.Visible = True
                If pnla1 IsNot Nothing Then pnla1.Visible = True
                If pnla3 IsNot Nothing Then pnla3.Visible = True
                If pnla5 IsNot Nothing Then pnla5.Visible = True

            Case 9, 24 ' Tukar Pemilik Perniagaan
                If pnla IsNot Nothing Then pnla.Visible = True
                If pnla1 IsNot Nothing Then pnla1.Visible = True
                If pnla3 IsNot Nothing Then pnla3.Visible = True
                If pnla2 IsNot Nothing Then pnla2.Visible = True

            Case 10, 12, 16 ' Tambah, Tukar, Pengurangan Visual Iklan
                If pnla IsNot Nothing Then pnla.Visible = True
                If pnla1 IsNot Nothing Then pnla1.Visible = True

            Case 5 ' Billboard
                If pnla IsNot Nothing Then pnla.Visible = True
                If pnla1 IsNot Nothing Then pnla1.Visible = True
                If pnlbillboard IsNot Nothing Then pnlbillboard.Visible = True

            Case 8, 29 ' Tambah, pengurangan Jenis Perniagaan
                If pnla IsNot Nothing Then pnla.Visible = True
                If pnla3 IsNot Nothing Then pnla3.Visible = True
                If pnla4 IsNot Nothing Then pnla4.Visible = True

                If lblAlamat IsNot Nothing Then lblAlamat.Text = "Alamat Baru"
                If lblJenisPerniagaan IsNot Nothing Then
                    If lesenId = 8 Then
                        lblJenisPerniagaan.Text = "Jenis Perniagaan Tambahan"
                    Else
                        lblJenisPerniagaan.Text = "Pengurangan Jenis Perniagaan"
                    End If
                End If

            Case 15 ' Expo
                If pnle IsNot Nothing Then pnle.Visible = True

            Case 19
                If pnla IsNot Nothing Then pnla.Visible = True
                If pnla1 IsNot Nothing Then pnla1.Visible = True
                If pnla3 IsNot Nothing Then pnla3.Visible = True
                If pnla5 IsNot Nothing Then pnla5.Visible = True

            Case 20
                If pnla IsNot Nothing Then pnla.Visible = True
                If pnla1 IsNot Nothing Then pnla1.Visible = True
                If pnla2 IsNot Nothing Then pnla2.Visible = True
                If pnla3 IsNot Nothing Then pnla3.Visible = True

            Case 27 ' Banting
                If pnla IsNot Nothing Then pnla.Visible = True
                If pnl6 IsNot Nothing Then pnl6.Visible = True

        End Select
    End Sub

#End Region

#Region "Multi-License Tags (Repeater & Dropdown)"

    Protected Sub ddlItems_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        Dim ddlItems As DropDownList = DirectCast(FormView1.FindControl("ddlItems"), DropDownList)
        If ddlItems Is Nothing OrElse String.IsNullOrEmpty(ddlItems.SelectedValue) Then Return

        Dim myList = DirectCast(ViewState("SelectedList"), List(Of SelectedItem))
        If myList Is Nothing Then
            myList = New List(Of SelectedItem)()
        End If

        ' Prevent mixing standalone license categories with other licenses
        Dim restrictedIds As String() = {"3", "5", "25", "27"}
        Dim hasRestrictedSelected As Boolean = myList.Any(Function(x) restrictedIds.Contains(x.ItemValue))
        Dim isCurrentRestricted As Boolean = restrictedIds.Contains(ddlItems.SelectedValue)

        If hasRestrictedSelected OrElse (myList.Count > 0 AndAlso isCurrentRestricted) Then
            ShowAlert("error", "", "Jenis lesen yang dipilih tidak boleh dicampur.")
            ddlItems.SelectedIndex = 0
            Return
        End If

        ' Check for duplicates
        If Not myList.Any(Function(x) x.ItemValue = ddlItems.SelectedValue) Then
            Dim newItem As New SelectedItem() With {
                .ItemText = ddlItems.SelectedItem.Text,
                .ItemValue = ddlItems.SelectedValue
            }
            myList.Add(newItem)
            ViewState("SelectedList") = myList

            BindRepeater()
            updateJenisLesenList(newItem.ItemValue, newItem.ItemText)
            PanelAccess(CInt(ddlItems.SelectedValue), False)
        End If

        ddlItems.SelectedIndex = 0
    End Sub

    Protected Sub rptSelectedItems_ItemCommand(ByVal source As Object, ByVal e As RepeaterCommandEventArgs)
        If e.CommandName <> "Remove" Then Return

        Dim hfDescList As HiddenField = DirectCast(FormView1.FindControl("HF_JenisLesenDescList"), HiddenField)
        Dim hfIdList As HiddenField = DirectCast(FormView1.FindControl("HF_JenisLesenIdList"), HiddenField)
        Dim myList = DirectCast(ViewState("SelectedList"), List(Of SelectedItem))
        Dim valueToRemove As String = e.CommandArgument.ToString()

        If myList IsNot Nothing Then
            myList.RemoveAll(Function(x) x.ItemValue = valueToRemove)
            ViewState("SelectedList") = myList
            BindRepeater()

            ' Reset panels and rebuild for remaining active items
            PanelAccess(0, True)

            If hfDescList IsNot Nothing Then hfDescList.Value = ""
            If hfIdList IsNot Nothing Then hfIdList.Value = ""

            For Each item In myList
                updateJenisLesenList(item.ItemValue, item.ItemText)
                PanelAccess(CInt(item.ItemValue), False)
            Next
        End If
    End Sub

    Private Sub BindRepeater()
        Dim rptSelectedItems As Repeater = DirectCast(FormView1.FindControl("rptSelectedItems"), Repeater)
        If rptSelectedItems IsNot Nothing Then
            rptSelectedItems.DataSource = DirectCast(ViewState("SelectedList"), List(Of SelectedItem))
            rptSelectedItems.DataBind()
        End If
    End Sub

    Private Sub updateJenisLesenList(ByVal itemval As String, ByVal itemtext As String)
        Dim hfDescList As HiddenField = DirectCast(FormView1.FindControl("HF_JenisLesenDescList"), HiddenField)
        Dim hfIdList As HiddenField = DirectCast(FormView1.FindControl("HF_JenisLesenIdList"), HiddenField)

        If hfDescList IsNot Nothing Then
            If String.IsNullOrEmpty(hfDescList.Value) Then
                hfDescList.Value = itemtext
            Else
                hfDescList.Value &= "," & itemtext
            End If
        End If

        If hfIdList IsNot Nothing Then
            If String.IsNullOrEmpty(hfIdList.Value) Then
                hfIdList.Value = itemval
            Else
                hfIdList.Value &= "," & itemval
            End If
        End If
    End Sub

#End Region

#Region "Child Tables Management (Iklan, Anjing, Lokasi)"

    ' -------------------------------------------------------------
    ' 1. IKLAN LIST
    ' -------------------------------------------------------------
    Protected Sub btnAddIklan_Click(sender As Object, e As EventArgs)
        Dim tbSaiz As TextBox = DirectCast(FormView1.FindControl("TB_SaizIklan1"), TextBox)
        Dim ddlIklan As DropDownList = DirectCast(FormView1.FindControl("DDL_Iklan1"), DropDownList)
        Dim tbUnit As TextBox = DirectCast(FormView1.FindControl("TB_UnitIklan1"), TextBox)
        Dim gvIklanList As GridView = DirectCast(FormView1.FindControl("gvIklanList"), GridView)

        If tbSaiz IsNot Nothing AndAlso ddlIklan IsNot Nothing AndAlso tbUnit IsNot Nothing AndAlso
           Not String.IsNullOrWhiteSpace(tbSaiz.Text) AndAlso
           Not String.IsNullOrWhiteSpace(ddlIklan.SelectedValue) AndAlso
           Not String.IsNullOrWhiteSpace(tbUnit.Text) Then

            Dim dt As DataTable = GetOrCreateIklanTable()
            Dim newRow As DataRow = dt.NewRow()
            newRow("SaizIklan") = tbSaiz.Text.Trim()
            newRow("Bercahaya") = ddlIklan.SelectedValue
            newRow("Unit") = tbUnit.Text.Trim()
            dt.Rows.Add(newRow)

            ViewState("IklanTable") = dt
            If gvIklanList IsNot Nothing Then
                gvIklanList.DataSource = dt
                gvIklanList.DataBind()
            End If

            updateIklanList(newRow("SaizIklan").ToString(), newRow("Bercahaya").ToString(), newRow("Unit").ToString())

            ' Clear input controls
            tbSaiz.Text = ""
            tbUnit.Text = ""
            ddlIklan.SelectedIndex = 0
        End If
    End Sub

    Protected Sub gvIklanList_RowDeleting(sender As Object, e As GridViewDeleteEventArgs)
        If ViewState("IklanTable") IsNot Nothing Then
            Dim dt As DataTable = DirectCast(ViewState("IklanTable"), DataTable)
            dt.Rows.RemoveAt(e.RowIndex)
            ViewState("IklanTable") = dt

            Dim gvIklan As GridView = DirectCast(FormView1.FindControl("gvIklanList"), GridView)
            If gvIklan IsNot Nothing Then
                gvIklan.DataSource = dt
                gvIklan.DataBind()
            End If

            ResetAndRebuildIklanHiddenFields(dt)
        End If
    End Sub

    Private Function GetOrCreateIklanTable() As DataTable
        If ViewState("IklanTable") IsNot Nothing Then
            Return DirectCast(ViewState("IklanTable"), DataTable)
        End If

        Dim dt As New DataTable()
        dt.Columns.Add("SaizIklan", GetType(String))
        dt.Columns.Add("Bercahaya", GetType(String))
        dt.Columns.Add("Unit", GetType(String))
        Return dt
    End Function

    Private Sub updateIklanList(ByVal saizVal As String, ByVal cahayaVal As String, ByVal unitVal As String)
        Dim hfSaiz As HiddenField = DirectCast(FormView1.FindControl("HF_SaizIklanList"), HiddenField)
        Dim hfCahaya As HiddenField = DirectCast(FormView1.FindControl("HF_CahayaIklanList"), HiddenField)
        Dim hfUnit As HiddenField = DirectCast(FormView1.FindControl("HF_UnitIklanList"), HiddenField)

        If hfSaiz IsNot Nothing Then
            hfSaiz.Value = If(String.IsNullOrEmpty(hfSaiz.Value), saizVal, hfSaiz.Value & "," & saizVal)
        End If
        If hfCahaya IsNot Nothing Then
            hfCahaya.Value = If(String.IsNullOrEmpty(hfCahaya.Value), cahayaVal, hfCahaya.Value & "," & cahayaVal)
        End If
        If hfUnit IsNot Nothing Then
            hfUnit.Value = If(String.IsNullOrEmpty(hfUnit.Value), unitVal, hfUnit.Value & "," & unitVal)
        End If
    End Sub

    Private Sub ResetAndRebuildIklanHiddenFields(dt As DataTable)
        Dim hfSaiz As HiddenField = DirectCast(FormView1.FindControl("HF_SaizIklanList"), HiddenField)
        Dim hfCahaya As HiddenField = DirectCast(FormView1.FindControl("HF_CahayaIklanList"), HiddenField)
        Dim hfUnit As HiddenField = DirectCast(FormView1.FindControl("HF_UnitIklanList"), HiddenField)

        If hfSaiz IsNot Nothing Then hfSaiz.Value = ""
        If hfCahaya IsNot Nothing Then hfCahaya.Value = ""
        If hfUnit IsNot Nothing Then hfUnit.Value = ""

        For Each row As DataRow In dt.Rows
            updateIklanList(row("SaizIklan").ToString(), row("Bercahaya").ToString(), row("Unit").ToString())
        Next
    End Sub

    ' -------------------------------------------------------------
    ' 2. ANJING LIST
    ' -------------------------------------------------------------
    Protected Sub btnAddAnjing_Click(sender As Object, e As EventArgs)
        Dim ddlBaka As DropDownList = DirectCast(FormView1.FindControl("DDL_BakaAnjing1"), DropDownList)
        Dim tbJantan As TextBox = DirectCast(FormView1.FindControl("TB_Jantan1"), TextBox)
        Dim tbBetina As TextBox = DirectCast(FormView1.FindControl("TB_Betina1"), TextBox)
        Dim tbJantanMandul As TextBox = DirectCast(FormView1.FindControl("TB_JantanMandul1"), TextBox)
        Dim tbBetinaMandul As TextBox = DirectCast(FormView1.FindControl("TB_BetinaMandul1"), TextBox)
        Dim gvAnjingList As GridView = DirectCast(FormView1.FindControl("gvAnjingList"), GridView)

        If tbJantan IsNot Nothing AndAlso tbBetina IsNot Nothing AndAlso
           tbJantanMandul IsNot Nothing AndAlso tbBetinaMandul IsNot Nothing AndAlso
           ddlBaka IsNot Nothing AndAlso
           Not String.IsNullOrWhiteSpace(tbJantan.Text) AndAlso
           Not String.IsNullOrWhiteSpace(tbBetina.Text) AndAlso
           Not String.IsNullOrWhiteSpace(tbJantanMandul.Text) AndAlso
           Not String.IsNullOrWhiteSpace(tbBetinaMandul.Text) AndAlso
           Not String.IsNullOrWhiteSpace(ddlBaka.SelectedValue) Then

            Dim dt As DataTable = GetOrCreateAnjingTable()
            Dim newRow As DataRow = dt.NewRow()
            newRow("Baka") = ddlBaka.SelectedItem.Text
            newRow("Jantan") = tbJantan.Text.Trim()
            newRow("Betina") = tbBetina.Text.Trim()
            newRow("JantanMandul") = tbJantanMandul.Text.Trim()
            newRow("BetinaMandul") = tbBetinaMandul.Text.Trim()
            dt.Rows.Add(newRow)

            ViewState("AnjingTable") = dt
            If gvAnjingList IsNot Nothing Then
                gvAnjingList.DataSource = dt
                gvAnjingList.DataBind()
            End If

            updateAnjingList(newRow("Baka").ToString(), newRow("Jantan").ToString(), newRow("Betina").ToString(), newRow("JantanMandul").ToString(), newRow("BetinaMandul").ToString())

            ' Clear inputs
            tbJantan.Text = ""
            tbBetina.Text = ""
            tbJantanMandul.Text = ""
            tbBetinaMandul.Text = ""
            ddlBaka.SelectedIndex = 0
        End If
    End Sub

    Protected Sub gvAnjingList_RowDeleting(sender As Object, e As GridViewDeleteEventArgs)
        If ViewState("AnjingTable") IsNot Nothing Then
            Dim dt As DataTable = DirectCast(ViewState("AnjingTable"), DataTable)
            dt.Rows.RemoveAt(e.RowIndex)
            ViewState("AnjingTable") = dt

            Dim gvAnjing As GridView = DirectCast(FormView1.FindControl("gvAnjingList"), GridView)
            If gvAnjing IsNot Nothing Then
                gvAnjing.DataSource = dt
                gvAnjing.DataBind()
            End If

            ResetAndRebuildAnjingHiddenFields(dt)
        End If
    End Sub

    Private Function GetOrCreateAnjingTable() As DataTable
        If ViewState("AnjingTable") IsNot Nothing Then
            Return DirectCast(ViewState("AnjingTable"), DataTable)
        End If

        Dim dt As New DataTable()
        dt.Columns.Add("Baka", GetType(String))
        dt.Columns.Add("Jantan", GetType(String))
        dt.Columns.Add("Betina", GetType(String))
        dt.Columns.Add("JantanMandul", GetType(String))
        dt.Columns.Add("BetinaMandul", GetType(String))
        Return dt
    End Function

    Private Sub updateAnjingList(bakaVal As String, jantanVal As String, betinaVal As String, jMandulVal As String, bMandulVal As String)
        Dim hfBaka As HiddenField = DirectCast(FormView1.FindControl("HF_BakaAnjingList"), HiddenField)
        Dim hfJantan As HiddenField = DirectCast(FormView1.FindControl("HF_AnjingJantanList"), HiddenField)
        Dim hfBetina As HiddenField = DirectCast(FormView1.FindControl("HF_AnjingBetinaList"), HiddenField)
        Dim hfJMandul As HiddenField = DirectCast(FormView1.FindControl("HF_AnjingJantanMandulList"), HiddenField)
        Dim hfBMandul As HiddenField = DirectCast(FormView1.FindControl("HF_AnjingBetinaMandulList"), HiddenField)

        If hfBaka IsNot Nothing Then hfBaka.Value = If(String.IsNullOrEmpty(hfBaka.Value), bakaVal, hfBaka.Value & "," & bakaVal)
        If hfJantan IsNot Nothing Then hfJantan.Value = If(String.IsNullOrEmpty(hfJantan.Value), jantanVal, hfJantan.Value & "," & jantanVal)
        If hfBetina IsNot Nothing Then hfBetina.Value = If(String.IsNullOrEmpty(hfBetina.Value), betinaVal, hfBetina.Value & "," & betinaVal)
        If hfJMandul IsNot Nothing Then hfJMandul.Value = If(String.IsNullOrEmpty(hfJMandul.Value), jMandulVal, hfJMandul.Value & "," & jMandulVal)
        If hfBMandul IsNot Nothing Then hfBMandul.Value = If(String.IsNullOrEmpty(hfBMandul.Value), bMandulVal, hfBMandul.Value & "," & bMandulVal)
    End Sub

    Private Sub ResetAndRebuildAnjingHiddenFields(dt As DataTable)
        Dim hfBaka As HiddenField = DirectCast(FormView1.FindControl("HF_BakaAnjingList"), HiddenField)
        Dim hfJantan As HiddenField = DirectCast(FormView1.FindControl("HF_AnjingJantanList"), HiddenField)
        Dim hfBetina As HiddenField = DirectCast(FormView1.FindControl("HF_AnjingBetinaList"), HiddenField)
        Dim hfJMandul As HiddenField = DirectCast(FormView1.FindControl("HF_AnjingJantanMandulList"), HiddenField)
        Dim hfBMandul As HiddenField = DirectCast(FormView1.FindControl("HF_AnjingBetinaMandulList"), HiddenField)

        If hfBaka IsNot Nothing Then hfBaka.Value = ""
        If hfJantan IsNot Nothing Then hfJantan.Value = ""
        If hfBetina IsNot Nothing Then hfBetina.Value = ""
        If hfJMandul IsNot Nothing Then hfJMandul.Value = ""
        If hfBMandul IsNot Nothing Then hfBMandul.Value = ""

        For Each row As DataRow In dt.Rows
            updateAnjingList(row("Baka").ToString(), row("Jantan").ToString(), row("Betina").ToString(), row("JantanMandul").ToString(), row("BetinaMandul").ToString())
        Next
    End Sub

    ' -------------------------------------------------------------
    ' 3. LOKASI LIST (BANTING)
    ' -------------------------------------------------------------
    Protected Sub btnAddLokasi_Click(sender As Object, e As EventArgs)
        Dim tbLokasi As TextBox = DirectCast(FormView1.FindControl("TB_LokasiBanting"), TextBox)
        Dim gvLokasiList As GridView = DirectCast(FormView1.FindControl("gvLokasiList"), GridView)

        If tbLokasi IsNot Nothing AndAlso Not String.IsNullOrWhiteSpace(tbLokasi.Text) Then
            Dim dt As DataTable = GetOrCreateLokasiTable()
            Dim newRow As DataRow = dt.NewRow()
            newRow("No") = (dt.Rows.Count + 1).ToString()
            newRow("Lokasi") = tbLokasi.Text.Trim()
            dt.Rows.Add(newRow)

            ViewState("LokasiTable") = dt
            If gvLokasiList IsNot Nothing Then
                gvLokasiList.DataSource = dt
                gvLokasiList.DataBind()
            End If

            updateLokasiList(newRow("Lokasi").ToString())
            tbLokasi.Text = ""
        End If
    End Sub

    Protected Sub gvLokasiList_RowDeleting(sender As Object, e As GridViewDeleteEventArgs)
        If ViewState("LokasiTable") IsNot Nothing Then
            Dim dt As DataTable = DirectCast(ViewState("LokasiTable"), DataTable)
            dt.Rows.RemoveAt(e.RowIndex)

            ' Re-index row numbers
            For i As Integer = 0 To dt.Rows.Count - 1
                dt.Rows(i)("No") = (i + 1).ToString()
            Next

            ViewState("LokasiTable") = dt

            Dim gvLokasi As GridView = DirectCast(FormView1.FindControl("gvLokasiList"), GridView)
            If gvLokasi IsNot Nothing Then
                gvLokasi.DataSource = dt
                gvLokasi.DataBind()
            End If

            Dim hfLokasi As HiddenField = DirectCast(FormView1.FindControl("HF_LokasiList"), HiddenField)
            If hfLokasi IsNot Nothing Then
                hfLokasi.Value = ""
                For Each row As DataRow In dt.Rows
                    updateLokasiList(row("Lokasi").ToString())
                Next
            End If
        End If
    End Sub

    Private Function GetOrCreateLokasiTable() As DataTable
        If ViewState("LokasiTable") IsNot Nothing Then
            Return DirectCast(ViewState("LokasiTable"), DataTable)
        End If

        Dim dt As New DataTable()
        dt.Columns.Add("No", GetType(String))
        dt.Columns.Add("Lokasi", GetType(String))
        Return dt
    End Function

    Private Sub updateLokasiList(ByVal lokasiVal As String)
        Dim hfLokasi As HiddenField = DirectCast(FormView1.FindControl("HF_LokasiList"), HiddenField)
        If hfLokasi IsNot Nothing Then
            hfLokasi.Value = If(String.IsNullOrEmpty(hfLokasi.Value), lokasiVal, hfLokasi.Value & "||" & lokasiVal)
        End If
    End Sub

#End Region

#Region "Attachments Management (Lampiran Awam & MPK)"

    ' -------------------------------------------------------------
    ' ADD NEW ATTACHMENT
    ' -------------------------------------------------------------
    Protected Sub btnAddNewUpload1_Click(sender As Object, e As EventArgs)
        ' Add Lampiran Awam ('LA')
        AddNewAttachment("LA", gvTabPublicAttach)
    End Sub

    Protected Sub btnAddNewUpload_Click(sender As Object, e As EventArgs)
        ' Add Lampiran MPK / Ulasan ('U')
        AddNewAttachment("U", gvTabUlasan)
    End Sub

    Private Sub AddNewAttachment(jenisLampiran As String, targetGridView As GridView)
        If GridView1.SelectedValue Is Nothing Then Return
        Dim permohonanId As Integer = CInt(GridView1.SelectedValue)

        Using myConnection As New SqlConnection(CS)
            Dim sql As String = "INSERT INTO LESEN_PermohonanFail (PermohonanFail_PermohonanID, PermohonanFail_JenisLampiran, CreatedDt, CreatorID) " &
                                "VALUES (@Permohonan_ID, @JenisLampiran, GETDATE(), @SessionUserName)"

            Using myCommand As New SqlCommand(sql, myConnection)
                myCommand.Parameters.AddWithValue("@Permohonan_ID", permohonanId)
                myCommand.Parameters.AddWithValue("@JenisLampiran", jenisLampiran)
                myCommand.Parameters.AddWithValue("@SessionUserName", Convert.ToString(Session.Item("SessionUserName")))

                myConnection.Open()
                Dim rowsAffected As Integer = myCommand.ExecuteNonQuery()

                If rowsAffected > 0 Then
                    targetGridView.EditIndex = targetGridView.Rows.Count
                End If
            End Using
        End Using

        targetGridView.DataBind()
        Page.SetFocus(Me.ui_btnPageBottom.ClientID)
    End Sub

    Protected Sub btnUpload_Click(sender As Object, e As EventArgs)
        ' Placeholder event handler referenced by hidden btnUpload in GridView EditItemTemplate
    End Sub

    ' -------------------------------------------------------------
    ' ROW UPDATING & FILE SAVING
    ' -------------------------------------------------------------
    Private Sub gvTabPublicAttach_RowUpdating(sender As Object, e As GridViewUpdateEventArgs) Handles gvTabPublicAttach.RowUpdating
        ProcessAttachmentUpload(gvTabPublicAttach, e)
    End Sub

    Private Sub gvTabUlasan_RowUpdating(sender As Object, e As GridViewUpdateEventArgs) Handles gvTabUlasan.RowUpdating
        ProcessAttachmentUpload(gvTabUlasan, e)
    End Sub

    Private Sub ProcessAttachmentUpload(gv As GridView, e As GridViewUpdateEventArgs)
        Dim fu As FileUpload = DirectCast(gv.Rows(e.RowIndex).FindControl("FU_PermohonanFail"), FileUpload)
        If fu Is Nothing OrElse Not fu.HasFile Then
            Return
        End If

        Dim uid As Guid = Guid.NewGuid()
        Dim originalFileName As String = Path.GetFileName(fu.PostedFile.FileName)
        Dim localVirtualPath As String = "~/doc/" & uid.ToString() & "_" & originalFileName
        Dim physicalSavePath As String = Server.MapPath(localVirtualPath)

        ' Delete old physical file if exists
        If e.OldValues("PermohonanFail_FilePath") IsNot Nothing Then
            DeletePhysicalFile(Convert.ToString(e.OldValues("PermohonanFail_FilePath")))
        End If

        ' Save new file (with image compression/resize if image)
        If SaveUploadedFile(fu, physicalSavePath) Then
            e.NewValues("PermohonanFail_FileName") = originalFileName
            e.NewValues("PermohonanFail_ContentType") = fu.PostedFile.ContentType
            e.NewValues("PermohonanFail_FilePath") = localVirtualPath
        End If
    End Sub

    Private Function SaveUploadedFile(fu As FileUpload, savePath As String) As Boolean
        If fu.PostedFile Is Nothing OrElse fu.PostedFile.ContentLength = 0 Then
            MessageBox("Muat naik fail gagal. Sila cuba sekali lagi.", Me)
            Return False
        End If

        If fu.PostedFile.ContentLength > MaxFileSizeInBytes Then
            MessageBox("Saiz fail tidak boleh melebihi 5 MB!", Me)
            Return False
        End If

        Try
            Dim contentType As String = fu.PostedFile.ContentType.ToLower()
            Dim isImage As Boolean = contentType.Contains("image/png") OrElse contentType.Contains("image/jpeg") OrElse contentType.Contains("image/x-png")

            If isImage Then
                Using bmpStream As Stream = fu.PostedFile.InputStream
                    Using originalBmp As New Bitmap(bmpStream)
                        Using scaledImage As System.Drawing.Image = ScaleImage(originalBmp, 1024)
                            scaledImage.Save(savePath, ImageFormat.Jpeg)
                        End Using
                    End Using
                End Using
            Else
                fu.PostedFile.SaveAs(savePath)
            End If

            Return True
        Catch ex As Exception
            MessageBox("Ralat memuat naik fail: " & ex.Message, Me)
            Return False
        End Try
    End Function

    Public Shared Function ScaleImage(ByVal image As System.Drawing.Image, ByVal maxHeight As Integer) As System.Drawing.Image
        Dim ratio As Double = CDbl(maxHeight) / image.Height
        Dim newWidth As Integer = CInt(image.Width * ratio)
        Dim newHeight As Integer = CInt(image.Height * ratio)
        Dim newImage As New Bitmap(newWidth, newHeight)

        Using g As Graphics = Graphics.FromImage(newImage)
            g.DrawImage(image, 0, 0, newWidth, newHeight)
        End Using

        Return newImage
    End Function

    ' -------------------------------------------------------------
    ' ROW DELETING & POSTBACK REGISTRATION
    ' -------------------------------------------------------------
    Private Sub gvTabPublicAttach_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvTabPublicAttach.RowDeleting
        If e.Values("PermohonanFail_FilePath") IsNot Nothing Then
            DeletePhysicalFile(Convert.ToString(e.Values("PermohonanFail_FilePath")))
        End If
    End Sub

    Private Sub gvTabUlasan_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvTabUlasan.RowDeleting
        If e.Values("PermohonanFail_FilePath") IsNot Nothing Then
            DeletePhysicalFile(Convert.ToString(e.Values("PermohonanFail_FilePath")))
        End If
    End Sub

    Private Sub DeletePhysicalFile(virtualPath As String)
        If String.IsNullOrWhiteSpace(virtualPath) Then Return

        Try
            Dim physicalPath As String = Server.MapPath(virtualPath)
            If File.Exists(physicalPath) Then
                File.Delete(physicalPath)
            End If
        Catch ex As Exception
            ' Ignore file deletion errors
        End Try
    End Sub

    Private Sub gvTabPublicAttach_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvTabPublicAttach.RowDataBound
        RegisterPostBackForAttachment(e)
    End Sub

    Private Sub gvTabUlasan_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvTabUlasan.RowDataBound
        RegisterPostBackForAttachment(e)
    End Sub

    Private Sub RegisterPostBackForAttachment(e As GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim linkBtn As LinkButton = DirectCast(e.Row.FindControl("LinkButton1"), LinkButton)
            If linkBtn IsNot Nothing Then
                Dim sm As ScriptManager = ScriptManager.GetCurrent(Page)
                If sm IsNot Nothing Then
                    sm.RegisterPostBackControl(linkBtn)
                End If
            End If
        End If
    End Sub

#End Region

#Region "Kadar Bayaran & Mesyuarat"

    Private Sub insertKadarBayaran(jid As String, pid As Integer)
        Dim listDesc As New List(Of String)()
        Dim listAmount As New List(Of String)()

        Using conn As New SqlConnection(CS)
            Dim selectSql As String = "SELECT JenisLesenBayaran_Description, JenisLesenBayaran_Amount " &
                                     "FROM LESEN_JenisLesenBayaran " &
                                     "WHERE ',' + @JenisLesen_ID + ',' LIKE '%,' + CAST(JenisLesen_ID AS VARCHAR) + ',%' " &
                                     "GROUP BY JenisLesenBayaran_Description, JenisLesenBayaran_Amount"

            Using cmdSelect As New SqlCommand(selectSql, conn)
                cmdSelect.Parameters.AddWithValue("@JenisLesen_ID", jid)
                conn.Open()
                Using reader As SqlDataReader = cmdSelect.ExecuteReader()
                    While reader.Read()
                        listDesc.Add(Convert.ToString(reader("JenisLesenBayaran_Description")))
                        listAmount.Add(Convert.ToString(reader("JenisLesenBayaran_Amount")))
                    End While
                End Using
            End Using

            ' Insert retrieved fees for the application
            Dim insertSql As String = "INSERT INTO LESEN_KadarBayaran (KadarBayaran_PermohonanID, KadarBayaran_PermohonanAgensiID, KadarBayaran_UserID, KadarBayaran_Desc, KadarBayaran_Amount) " &
                                      "VALUES (@KadarBayaran_PermohonanID, @KadarBayaran_PermohonanAgensiID, @KadarBayaran_UserID, @KadarBayaran_Desc, @KadarBayaran_Amount)"

            For i As Integer = 0 To listDesc.Count - 1
                Using cmdInsert As New SqlCommand(insertSql, conn)
                    cmdInsert.Parameters.AddWithValue("@KadarBayaran_PermohonanID", pid)
                    cmdInsert.Parameters.AddWithValue("@KadarBayaran_PermohonanAgensiID", If(Session.Item("SessionEstateId"), DBNull.Value))
                    cmdInsert.Parameters.AddWithValue("@KadarBayaran_UserID", If(Session.Item("SessionUsersId"), DBNull.Value))
                    cmdInsert.Parameters.AddWithValue("@KadarBayaran_Desc", listDesc(i))
                    cmdInsert.Parameters.AddWithValue("@KadarBayaran_Amount", listAmount(i))
                    cmdInsert.ExecuteNonQuery()
                End Using
            Next
        End Using
    End Sub

    Protected Sub btnAddNew_Click(sender As Object, e As EventArgs)
        If GridView1.SelectedDataKey Is Nothing Then Return
        Dim permohonanId As Integer = CInt(GridView1.SelectedDataKey.Values(0))

        Using conn As New SqlConnection(CS)
            Dim sql As String = "INSERT INTO LESEN_KadarBayaran (KadarBayaran_PermohonanID, KadarBayaran_PermohonanAgensiID, KadarBayaran_UserID, CreatedDt, CreatorID) " &
                                "VALUES (@Permohonan_ID, CASE WHEN @AgensiId = 0 THEN NULL ELSE @AgensiId END, @SessionUsersID, GETDATE(), @SessionUserName)"

            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@Permohonan_ID", permohonanId)
                cmd.Parameters.AddWithValue("@AgensiId", If(Session.Item("SessionEstateId"), 0))
                cmd.Parameters.AddWithValue("@SessionUsersID", If(Session.Item("SessionUsersId"), DBNull.Value))
                cmd.Parameters.AddWithValue("@SessionUserName", Convert.ToString(Session.Item("SessionUserName")))

                conn.Open()
                Dim rowsAffected As Integer = cmd.ExecuteNonQuery()
                If rowsAffected > 0 Then
                    gvTabBayaran.EditIndex = gvTabBayaran.Rows.Count
                End If
            End Using
        End Using

        gvTabBayaran.DataBind()
        Page.SetFocus(Me.ui_btnPageBottom.ClientID)
    End Sub

    Protected Sub cbsel_CheckedChanged(sender As Object, e As EventArgs)
        Dim cb As CheckBox = DirectCast(sender, CheckBox)
        Dim row As GridViewRow = DirectCast(cb.NamingContainer, GridViewRow)
        Dim lblId As Label = DirectCast(row.FindControl("Label1"), Label)
        If lblId Is Nothing Then Return

        Using conn As New SqlConnection(CS)
            Dim sql As String = "UPDATE LESEN_KadarBayaran SET IsSelect = @IsSelect WHERE KadarBayaran_ID = @KadarBayaran_ID"
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@KadarBayaran_ID", lblId.Text)
                cmd.Parameters.AddWithValue("@IsSelect", If(cb.Checked, 1, 0))
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using

        gvTabBayaran.DataBind()
    End Sub

    Protected Sub BtnSaveMesyuarat_Click(sender As Object, e As EventArgs)
        If GridView1.SelectedDataKey Is Nothing Then Return
        Dim permohonanId As Integer = CInt(GridView1.SelectedDataKey.Values(0))

        Using conn As New SqlConnection(CS)
            Dim sql As String = "UPDATE LESEN_Permohonan SET TarikhMesyuarat = @TarikhMesyuarat, NoMesyuarat = @NoMesyuarat, " &
                                "IsPulang = @IsPulang, TarikhPulang = @TarikhPulang WHERE Permohonan_ID = @Permohonan_ID"

            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@Permohonan_ID", permohonanId)
                cmd.Parameters.AddWithValue("@TarikhMesyuarat", If(String.IsNullOrWhiteSpace(TB_TarikhMesyuarat.Text), DBNull.Value, CObj(TB_TarikhMesyuarat.Text)))
                cmd.Parameters.AddWithValue("@NoMesyuarat", TB_NoMesyuarat.Text.Trim())
                cmd.Parameters.AddWithValue("@IsPulang", CB_IsPulang.Checked)
                cmd.Parameters.AddWithValue("@TarikhPulang", If(String.IsNullOrWhiteSpace(TB_TarikhPulang.Text), DBNull.Value, CObj(TB_TarikhPulang.Text)))

                conn.Open()
                cmd.ExecuteNonQuery()
                ShowAlert("success", "", "Rekod mesyuarat telah dikemaskini.")
            End Using
        End Using
    End Sub

    Private Sub GetMesyuarat(pid As Integer)
        Using conn As New SqlConnection(CS)
            Dim sql As String = "SELECT TarikhMesyuarat, KeputusanMesyuarat, NoMesyuarat, IsPulang, TarikhPulang " &
                                "FROM LESEN_Permohonan WHERE Permohonan_ID = @Permohonan_ID"

            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@Permohonan_ID", pid)
                conn.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        If Not IsDBNull(reader("TarikhMesyuarat")) Then
                            TB_TarikhMesyuarat.Text = CDate(reader("TarikhMesyuarat")).ToString("yyyy-MM-dd")
                        End If

                        TB_NoMesyuarat.Text = Convert.ToString(reader("NoMesyuarat"))
                        CB_IsPulang.Checked = If(IsDBNull(reader("IsPulang")), False, CBool(reader("IsPulang")))
                        pnlpulang.Visible = CB_IsPulang.Checked

                        If Not IsDBNull(reader("TarikhPulang")) Then
                            TB_TarikhPulang.Text = CDate(reader("TarikhPulang")).ToString("yyyy-MM-dd")
                        End If
                    End If
                End Using
            End Using
        End Using
    End Sub

#End Region

#Region "Field Change & Toggle Handlers"

    Protected Sub ddl_Pemohon_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ddl As DropDownList = DirectCast(FormView1.FindControl("ddl_Pemohon"), DropDownList)
        If ddl IsNot Nothing Then
            LoadApplicantDetails(ddl.SelectedValue)
        End If
    End Sub

    Protected Sub CB_Deposit_CheckedChanged(sender As Object, e As EventArgs)
        Dim cb As CheckBox = DirectCast(FormView1.FindControl("CB_Deposit"), CheckBox)
        Dim pnl As Panel = DirectCast(FormView1.FindControl("pnldeposit"), Panel)
        If cb IsNot Nothing AndAlso pnl IsNot Nothing Then
            pnl.Visible = cb.Checked
        End If
    End Sub

    Protected Sub CB_IsBatal_CheckedChanged(sender As Object, e As EventArgs)
        Dim cb As CheckBox = DirectCast(FormView1.FindControl("CB_IsBatal"), CheckBox)
        Dim pnlBatal As Panel = DirectCast(FormView1.FindControl("pnlbatal2"), Panel)
        Dim pnlDepoPulang As Panel = DirectCast(FormView1.FindControl("pnldeposit1"), Panel)

        If cb IsNot Nothing Then
            If pnlBatal IsNot Nothing Then pnlBatal.Visible = cb.Checked
            If pnlDepoPulang IsNot Nothing Then pnlDepoPulang.Visible = cb.Checked
        End If
    End Sub

    Protected Sub DDL_JenisBatal_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ddl As DropDownList = DirectCast(FormView1.FindControl("DDL_JenisBatal"), DropDownList)
        Dim pnlSebab1 As Panel = DirectCast(FormView1.FindControl("pnlbatal3"), Panel)
        Dim pnlSebab2 As Panel = DirectCast(FormView1.FindControl("pnlbatal4"), Panel)
        Dim pnlCatatan As Panel = DirectCast(FormView1.FindControl("pnlbatal5"), Panel)

        If pnlSebab1 IsNot Nothing Then pnlSebab1.Visible = False
        If pnlSebab2 IsNot Nothing Then pnlSebab2.Visible = False
        If pnlCatatan IsNot Nothing Then pnlCatatan.Visible = False

        If ddl IsNot Nothing Then
            If ddl.SelectedIndex = 1 Then
                If pnlSebab1 IsNot Nothing Then pnlSebab1.Visible = True
                If pnlCatatan IsNot Nothing Then pnlCatatan.Visible = True
            ElseIf ddl.SelectedIndex = 2 Then
                If pnlSebab2 IsNot Nothing Then pnlSebab2.Visible = True
                If pnlCatatan IsNot Nothing Then pnlCatatan.Visible = True
            End If
        End If
    End Sub

    Protected Sub CB_IsPulang_CheckedChanged(sender As Object, e As EventArgs)
        pnlpulang.Visible = CB_IsPulang.Checked
    End Sub

    Protected Sub DDL_JenisPasar_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ddl As DropDownList = DirectCast(FormView1.FindControl("DDL_JenisPasar"), DropDownList)
        Dim noruj As TextBox = DirectCast(FormView1.FindControl("TB_Rujukan"), TextBox)
        If ddl Is Nothing OrElse noruj Is Nothing Then Return

        Select Case ddl.SelectedIndex
            Case 1 ' Pasar Pagi
                noruj.Text = "MPK/599/401/26/PP"
            Case 2 ' Pasar Malam
                noruj.Text = "MPK/599/401/3/33"
            Case Else ' Pasar Lambak / Default
                noruj.Text = "MPK/599/401/"
        End Select
    End Sub

#End Region

#Region "Helper Methods & Data Loaders"

    ''' <summary>
    ''' Sets the page title in the header from navigation settings.
    ''' </summary>
    Private Sub initPageName()
        Dim menuName As String = GlobalClass.writeTitlePage(Request.QueryString("m_Id"), "")
        If String.IsNullOrEmpty(menuName) Then
            menuName = "Permohonan"
        End If
        idWindowTitle.InnerText = menuName
    End Sub

    ''' <summary>
    ''' Loads applicant details from LESEN_Pemohon and populates the applicant display panel.
    ''' </summary>
    Private Sub LoadApplicantDetails(pemohonId As String)
        Dim tbId As TextBox = DirectCast(FormView1.FindControl("TB_PemohonID"), TextBox)
        Dim tbName As TextBox = DirectCast(FormView1.FindControl("TB_Name"), TextBox)
        Dim tbNat As TextBox = DirectCast(FormView1.FindControl("TB_Nat"), TextBox)
        Dim tbAddress As TextBox = DirectCast(FormView1.FindControl("TB_Address"), TextBox)
        Dim tbRemarks As TextBox = DirectCast(FormView1.FindControl("TB_Remarks"), TextBox)
        Dim pnl As Panel = DirectCast(FormView1.FindControl("pnlpemohon"), Panel)

        If String.IsNullOrWhiteSpace(pemohonId) Then
            If pnl IsNot Nothing Then pnl.Visible = False
            Return
        End If

        Using conn As New SqlConnection(CS)
            Dim sql As String = "SELECT a.*, b.name FROM LESEN_Pemohon a " &
                                "INNER JOIN TBL_LOOKUPS b ON a.Pemohon_Nationality = b.id " &
                                "WHERE a.Pemohon_ID = @Pemohon_ID"

            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@Pemohon_ID", pemohonId)
                conn.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        If tbId IsNot Nothing Then tbId.Text = reader("Pemohon_ID").ToString()
                        If tbName IsNot Nothing Then tbName.Text = reader("Pemohon_Name").ToString()
                        If tbNat IsNot Nothing Then tbNat.Text = Convert.ToString(reader("name"))
                        If tbAddress IsNot Nothing Then tbAddress.Text = Convert.ToString(reader("Pemohon_Address"))
                        If tbRemarks IsNot Nothing Then tbRemarks.Text = Convert.ToString(reader("Pemohon_Remarks"))

                        If pnl IsNot Nothing Then pnl.Visible = True
                    Else
                        If tbId IsNot Nothing Then tbId.Text = ""
                        If tbName IsNot Nothing Then tbName.Text = "NULL"
                        If tbNat IsNot Nothing Then tbNat.Text = "NULL"
                        If tbAddress IsNot Nothing Then tbAddress.Text = "NULL"
                        If tbRemarks IsNot Nothing Then tbRemarks.Text = "NULL"

                        If pnl IsNot Nothing Then pnl.Visible = False
                        ShowAlert("error", "", "Rekod pemohon tiada di dalam sistem.")
                    End If
                End Using
            End Using
        End Using
    End Sub

    ''' <summary>
    ''' Unpacks comma-separated licence IDs and descriptions into ViewState and binds the repeater.
    ''' </summary>
    Private Sub LoadSelectedLicencesFromHiddenFields()
        Dim hfDescList As HiddenField = DirectCast(FormView1.FindControl("HF_JenisLesenDescList"), HiddenField)
        Dim hfIdList As HiddenField = DirectCast(FormView1.FindControl("HF_JenisLesenIdList"), HiddenField)

        If hfDescList Is Nothing OrElse hfIdList Is Nothing Then Return
        If String.IsNullOrWhiteSpace(hfDescList.Value) OrElse String.IsNullOrWhiteSpace(hfIdList.Value) Then Return

        Dim descArray As String() = hfDescList.Value.Split(","c)
        Dim idArray As String() = hfIdList.Value.Split(","c)
        Dim myList As New List(Of SelectedItem)()

        For i As Integer = 0 To Math.Min(descArray.Length, idArray.Length) - 1
            Dim desc As String = descArray(i).Trim()
            Dim idVal As String = idArray(i).Trim()
            If Not String.IsNullOrEmpty(idVal) Then
                myList.Add(New SelectedItem() With {.ItemText = desc, .ItemValue = idVal})
            End If
        Next

        ViewState("SelectedList") = myList
        BindRepeater()

        ' Reset panels and apply access for each selected licence
        PanelAccess(0, True)
        For Each item In myList
            Dim numericId As Integer
            If Integer.TryParse(item.ItemValue, numericId) Then
                PanelAccess(numericId, False)
            End If
        Next
    End Sub

    ''' <summary>
    ''' Populates the Iklan GridView from the stored hidden fields.
    ''' </summary>
    Private Sub PopulateIklanGridFromHiddenFields()
        Dim hfSaiz As HiddenField = DirectCast(FormView1.FindControl("HF_SaizIklanList"), HiddenField)
        Dim hfCahaya As HiddenField = DirectCast(FormView1.FindControl("HF_CahayaIklanList"), HiddenField)
        Dim hfUnit As HiddenField = DirectCast(FormView1.FindControl("HF_UnitIklanList"), HiddenField)
        Dim gv As GridView = DirectCast(FormView1.FindControl("gvIklanList"), GridView)

        If hfSaiz Is Nothing OrElse String.IsNullOrWhiteSpace(hfSaiz.Value) Then Return

        Dim saizArr As String() = hfSaiz.Value.Split(","c)
        Dim cahayaArr As String() = If(hfCahaya IsNot Nothing, hfCahaya.Value.Split(","c), Array.Empty(Of String)())
        Dim unitArr As String() = If(hfUnit IsNot Nothing, hfUnit.Value.Split(","c), Array.Empty(Of String)())

        Dim dt As New DataTable()
        dt.Columns.Add("SaizIklan", GetType(String))
        dt.Columns.Add("Bercahaya", GetType(String))
        dt.Columns.Add("Unit", GetType(String))

        For i As Integer = 0 To saizArr.Length - 1
            If Not String.IsNullOrWhiteSpace(saizArr(i)) Then
                Dim newRow As DataRow = dt.NewRow()
                newRow("SaizIklan") = saizArr(i).Trim()
                newRow("Bercahaya") = If(i < cahayaArr.Length, cahayaArr(i).Trim(), "")
                newRow("Unit") = If(i < unitArr.Length, unitArr(i).Trim(), "")
                dt.Rows.Add(newRow)
            End If
        Next

        ViewState("IklanTable") = dt
        If gv IsNot Nothing Then
            gv.DataSource = dt
            gv.DataBind()
        End If
    End Sub

    ''' <summary>
    ''' Populates the Anjing GridView from the stored hidden fields.
    ''' </summary>
    Private Sub PopulateAnjingGridFromHiddenFields()
        Dim hfBaka As HiddenField = DirectCast(FormView1.FindControl("HF_BakaAnjingList"), HiddenField)
        Dim hfJantan As HiddenField = DirectCast(FormView1.FindControl("HF_AnjingJantanList"), HiddenField)
        Dim hfBetina As HiddenField = DirectCast(FormView1.FindControl("HF_AnjingBetinaList"), HiddenField)
        Dim hfJMandul As HiddenField = DirectCast(FormView1.FindControl("HF_AnjingJantanMandulList"), HiddenField)
        Dim hfBMandul As HiddenField = DirectCast(FormView1.FindControl("HF_AnjingBetinaMandulList"), HiddenField)
        Dim gv As GridView = DirectCast(FormView1.FindControl("gvAnjingList"), GridView)

        If hfBaka Is Nothing OrElse String.IsNullOrWhiteSpace(hfBaka.Value) Then Return

        Dim bakaArr As String() = hfBaka.Value.Split(","c)
        Dim jantanArr As String() = If(hfJantan IsNot Nothing, hfJantan.Value.Split(","c), Array.Empty(Of String)())
        Dim betinaArr As String() = If(hfBetina IsNot Nothing, hfBetina.Value.Split(","c), Array.Empty(Of String)())
        Dim jMandulArr As String() = If(hfJMandul IsNot Nothing, hfJMandul.Value.Split(","c), Array.Empty(Of String)())
        Dim bMandulArr As String() = If(hfBMandul IsNot Nothing, hfBMandul.Value.Split(","c), Array.Empty(Of String)())

        Dim dt As New DataTable()
        dt.Columns.Add("Baka", GetType(String))
        dt.Columns.Add("Jantan", GetType(String))
        dt.Columns.Add("Betina", GetType(String))
        dt.Columns.Add("JantanMandul", GetType(String))
        dt.Columns.Add("BetinaMandul", GetType(String))

        For i As Integer = 0 To bakaArr.Length - 1
            If Not String.IsNullOrWhiteSpace(bakaArr(i)) Then
                Dim newRow As DataRow = dt.NewRow()
                newRow("Baka") = bakaArr(i).Trim()
                newRow("Jantan") = If(i < jantanArr.Length, jantanArr(i).Trim(), "")
                newRow("Betina") = If(i < betinaArr.Length, betinaArr(i).Trim(), "")
                newRow("JantanMandul") = If(i < jMandulArr.Length, jMandulArr(i).Trim(), "")
                newRow("BetinaMandul") = If(i < bMandulArr.Length, bMandulArr(i).Trim(), "")
                dt.Rows.Add(newRow)
            End If
        Next

        ViewState("AnjingTable") = dt
        If gv IsNot Nothing Then
            gv.DataSource = dt
            gv.DataBind()
        End If
    End Sub

    ''' <summary>
    ''' Populates the Lokasi (Banting) GridView from the stored hidden fields.
    ''' </summary>
    Private Sub PopulateLokasiGridFromHiddenFields()
        Dim hfLokasi As HiddenField = DirectCast(FormView1.FindControl("HF_LokasiList"), HiddenField)
        Dim gv As GridView = DirectCast(FormView1.FindControl("gvLokasiList"), GridView)

        If hfLokasi Is Nothing OrElse String.IsNullOrWhiteSpace(hfLokasi.Value) Then Return

        Dim lokasiArr As String() = hfLokasi.Value.Split(New String() {"||"}, StringSplitOptions.RemoveEmptyEntries)
        Dim dt As New DataTable()
        dt.Columns.Add("No", GetType(String))
        dt.Columns.Add("Lokasi", GetType(String))

        For i As Integer = 0 To lokasiArr.Length - 1
            Dim lokasiText As String = lokasiArr(i).Trim()
            If Not String.IsNullOrWhiteSpace(lokasiText) Then
                Dim newRow As DataRow = dt.NewRow()
                newRow("No") = (i + 1).ToString()
                newRow("Lokasi") = lokasiText
                dt.Rows.Add(newRow)
            End If
        Next

        ViewState("LokasiTable") = dt
        If gv IsNot Nothing Then
            gv.DataSource = dt
            gv.DataBind()
        End If
    End Sub

#End Region

End Class
