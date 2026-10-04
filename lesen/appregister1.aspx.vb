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
Imports QRCoder

Partial Class appregister1
    Inherits System.Web.UI.Page

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

#Region "Fields & Constants"
    Public Shared CS As String = ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString
    Private Const MaxFileSizeInBytes As Integer = 5 * 1024 * 1024 ' 5 MB max upload

    Public Property OriginalImageSize As Size
    Public Property NewImageSize As Size
#End Region

#Region "Page Lifecycle & Permissions"

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Try
                If CInt(Request.QueryString("pid")) = 0 Then
                    Try
                        DDL_Status.SelectedValue = 1
                        DDL_CreatedBy.SelectedValue = Session.Item("sessionUserName")
                    Catch ex As Exception
                        ' Fallback if default username or status not available
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

        Dim currPageScriptManager As ScriptManager = TryCast(ScriptManager.GetCurrent(Page), ScriptManager)
        If currPageScriptManager IsNot Nothing Then
            currPageScriptManager.RegisterPostBackControl(btnSaveLetter)
        End If
    End Sub

    Protected Sub Page_PreRenderComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRenderComplete
        Try
            If FormView1.CurrentMode = FormViewMode.Edit Then
                Dim btnBack As LinkButton = DirectCast(FormView1.FindControl("BackButton"), LinkButton)
                Dim frmview() As Object = {FormView1, FormViewMaintenanceTemplate}
                Dim lbutton() As Object = {btnBack, BT_ViewLaporan}
                Dim ctlDeny() As Object = {BtnSaveMesyuarat, btnSaveLetter, ButtonAddAssignment}

                ' Check write permissions
                Dim frmwrite As Boolean = GlobalClass.CheckPageWrite("Write", frmview, lbutton, ctlDeny)

                If Not frmwrite Then
                    ' Hide action/delete columns if user does not have write access
                    GridView1.Columns.Item(12).Visible = False
                    gvTabPublicAttach.Columns.Item(4).Visible = False
                    gvTabPublicAttach.Columns.Item(5).Visible = False
                    gvTabUlasan.Columns.Item(4).Visible = False
                    gvTabUlasan.Columns.Item(5).Visible = False
                    GridViewJabatanAgensiBatal.Columns.Item(3).Visible = False
                    GridViewMaintenanceTemplate.Columns.Item(3).Visible = False
                    gvTabBayaran.Columns.Item(4).Visible = False
                    gvTabBayaran.Columns.Item(5).Visible = False
                    gvTabBayaran.Columns.Item(6).Visible = False
                End If
            End If
        Catch ex As Exception
            ' Safe fallback
        End Try
    End Sub

    Private Sub appregister_LoadComplete(sender As Object, e As EventArgs) Handles Me.LoadComplete
        ' Reserved for lifecycle completion logic if needed
    End Sub

    Private Sub Page_PreRender(sender As Object, e As EventArgs) Handles Me.PreRender
        RegisterBantingPostBackControls()
    End Sub

#End Region

#Region "QR Code Generator"

    Protected Sub btnQrCode_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim btn As LinkButton = DirectCast(sender, LinkButton)
        Dim txtRujukan As TextBox = DirectCast(btn.NamingContainer.FindControl("TB_Rujukan"), TextBox)

        If txtRujukan Is Nothing OrElse String.IsNullOrWhiteSpace(txtRujukan.Text) Then
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "noRujukan", "alert('Sila isi No Rujukan dahulu.');", True)
            Exit Sub
        End If

        Dim baseUrl As String = Request.Url.Scheme & "://" & Request.Url.Authority & Request.ApplicationPath.TrimEnd("/"c)
        Dim encodedRujukan As String = Server.UrlEncode(txtRujukan.Text.Trim())
        Dim fullUrl As String = baseUrl & "/lesen/sepandukSemakanIK.aspx?scancode=" & encodedRujukan

        Using qrGenerator As New QRCodeGenerator()
            Dim qrCodeData As QRCodeData = qrGenerator.CreateQrCode(fullUrl, QRCodeGenerator.ECCLevel.Q)
            Using qrCode As New PngByteQRCode(qrCodeData)
                Dim qrBytes As Byte() = qrCode.GetGraphic(20)
                imgQrCode.ImageUrl = "data:image/png;base64," & Convert.ToBase64String(qrBytes)
                imgQrCode.Visible = True
            End Using
        End Using

        ' Open modal dialog on client side
        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "showQrModal", "$('#modalQrCode').modal('show');", True)
    End Sub

#End Region

#Region "Filter & Search (Main GridView1)"

    Private Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearch.Click
        GridView1.DataBind()
    End Sub

    Private Sub btnReset_Click(sender As Object, e As EventArgs) Handles btnReset.Click
        Response.Redirect(Request.RawUrl)
    End Sub

    Protected Sub GridView1_PageIndexChanged(sender As Object, e As EventArgs) Handles GridView1.PageIndexChanged
        CallFilter()
    End Sub

    Private Sub CallFilter()
        ' Reserved for custom filter paging logic if needed
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
        Dim ispublish As Boolean = CBool(GridView1.SelectedDataKey.Values("IsPublish"))
        Dim jidList() As String = CStr(GridView1.SelectedDataKey.Values("JenisLesenIdList")).Split(","c)

        If statusid > 0 Then
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

        For Each item In jidList
            If item = "27" Then
                tabMaklumat.Visible = False
                TabSurat.Visible = False
                TabJabatanAgensi.Visible = False
                TabLog.Visible = False
                TabLogBatal.Visible = False
            End If
        Next

        If tabMaklumat.Visible = True Then
            PanelAccessPembetulan(0, True)

            For Each item In jidList
                PanelAccessPembetulan(CInt(item), False)
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

            Using myConnection As New SqlConnection(CS)
                myConnection.Open()

                Dim SQL As String = "SELECT * FROM LESEN_ApprovalList WHERE Permohonan_ID = @Permohonan_ID AND ApprStatusID=10 AND IsComplete=1"
                Using myCommandSelect As New SqlCommand(SQL, myConnection)
                    myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", Permohonan_ID)
                    Using myReader As SqlDataReader = myCommandSelect.ExecuteReader()
                        If myReader.Read() Then
                            IsRevertStatus = True
                        End If
                    End Using
                End Using

                ' Delete from Approval List
                Dim Sql1 As String = "DELETE FROM LESEN_ApprovalList WHERE Permohonan_ID = @Permohonan_ID"
                If IsBatal Then
                    Sql1 = "DELETE FROM LESEN_ApprovalListBatal WHERE Permohonan_ID = @Permohonan_ID"
                End If
                Using myCommand1 As New SqlCommand(Sql1, myConnection)
                    myCommand1.Parameters.AddWithValue("@Permohonan_ID", Permohonan_ID)
                    myCommand1.ExecuteNonQuery()
                End Using

                ' Delete from Permohonan Agensi
                Dim Sql3 As String = "DELETE FROM LESEN_PermohonanAgensi WHERE Permohonan_ID = @Permohonan_ID"
                If IsBatal Then
                    Sql3 = "DELETE FROM LESEN_PermohonanAgensiBatal WHERE Permohonan_ID = @Permohonan_ID"
                End If
                Using myCommand3 As New SqlCommand(Sql3, myConnection)
                    myCommand3.Parameters.AddWithValue("@Permohonan_ID", Permohonan_ID)
                    myCommand3.ExecuteNonQuery()
                End Using

                ' Reset status in Permohonan
                Dim Sql2 As String = "UPDATE LESEN_Permohonan SET StatusID=0 WHERE Permohonan_ID = @Permohonan_ID"
                If IsRevertStatus Then
                    Sql2 = "UPDATE LESEN_Permohonan SET StatusID=10, IsBatal=0 WHERE Permohonan_ID = @Permohonan_ID"
                End If
                Using myCommand2 As New SqlCommand(Sql2, myConnection)
                    myCommand2.Parameters.AddWithValue("@Permohonan_ID", Permohonan_ID)
                    myCommand2.ExecuteNonQuery()
                End Using
            End Using

            GridView1.DataBind()

        ElseIf e.CommandName = "Hantar" Then
            Dim intRow As Integer = CInt(e.CommandArgument)
            If intRow > 9 Then
                intRow -= GridView1.PageIndex * 10
            End If

            Dim hfid As String = CStr(Me.GridView1.DataKeys(intRow)("Permohonan_ID"))
            Dim cb As Boolean = CBool(Me.GridView1.DataKeys(intRow)("IsBatal"))
            Dim extstr As String = If(cb, "Batal", "")

            Using myConnection As New SqlConnection(CS)
                myConnection.Open()

                Dim Sql1 As String = "SELECT COUNT(PermohonanAgensi_ID) AS agensi FROM LESEN_PermohonanAgensi" & extstr & " WHERE Permohonan_ID=" & hfid
                Using myCommand1 As New SqlCommand(Sql1, myConnection)
                    Using myReader As SqlDataReader = myCommand1.ExecuteReader()
                        ' Reader checked if needed
                    End Using
                End Using

                Dim result2 As Boolean = insertMaklumatPembetulan(CInt(hfid))
                If Not result2 Then
                    ShowAlert("error", "", "Gagal proses database. Sila tekan Hantar sekali lagi." & hfid)
                    Return
                End If

                Dim Sql As String = "UPDATE LESEN_Permohonan SET StatusID=1 WHERE StatusID=0 AND Permohonan_ID=" & hfid
                Dim result As Integer
                Using myCommand As New SqlCommand(Sql, myConnection)
                    result = myCommand.ExecuteNonQuery()
                End Using

                If result < 1 Then
                    ShowAlert("error", "", "Gagal hantar")
                Else
                    ShowAlert("success", "", "Berjaya hantar")
                    GridView1.DataBind()
                End If
            End Using

        ElseIf e.CommandName = "SuratAgensi" Then
            Dim rawArgument As String = e.CommandArgument.ToString()
            Dim args As String() = rawArgument.Split(","c)

            If args.Length >= 2 Then
                Dim intRow As Integer = CInt(args(0))
                Dim agensiId As Integer = CInt(args(1))

                If intRow > 9 Then
                    intRow -= GridView1.PageIndex * 10
                End If

                Dim pid As String = CStr(Me.GridView1.DataKeys(intRow)("Permohonan_ID"))

                If agensiId = 3 Then
                    If GetIsSuratFail(CInt(pid)) Then
                        ViewSuratPemeriksaanFail(pid)
                    Else
                        ViewSuratPemeriksaanAuto(pid, agensiId, True)
                    End If
                Else
                    Dim filepath As String = ""
                    Using myConnection As New SqlConnection(CS)
                        myConnection.Open()
                        Dim SQL As String = "SELECT TOP(1) UlasanFail_FilePath FROM LESEN_UlasanFail WHERE UlasanFail_ContentType='application/pdf' AND UlsanFail_PermohonanID = @Permohonan_ID AND UlasanFail_PermohonanAgensiID = @Agensi_ID"
                        Using myCommandSelect As New SqlCommand(SQL, myConnection)
                            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)
                            myCommandSelect.Parameters.AddWithValue("@Agensi_ID", agensiId)
                            Using myReader As SqlDataReader = myCommandSelect.ExecuteReader()
                                If myReader.Read() Then
                                    filepath = myReader.Item(0).ToString()
                                End If
                            End Using
                        End Using
                    End Using

                    If Not String.IsNullOrEmpty(filepath) Then
                        Response.Redirect(filepath)
                    End If
                End If
            End If

        ElseIf e.CommandName = "SuratKelulusan" OrElse e.CommandName = "Surat" Then
            Try
                Dim intRow As Integer = -1

                If TypeOf e.CommandSource Is Control Then
                    Dim row As GridViewRow = TryCast(DirectCast(e.CommandSource, Control).NamingContainer, GridViewRow)
                    If row IsNot Nothing Then
                        intRow = row.RowIndex
                    End If
                End If

                If intRow = -1 Then
                    intRow = CInt(e.CommandArgument)
                    If intRow >= GridView1.PageSize Then
                        intRow = intRow Mod GridView1.PageSize
                    End If
                End If

                Dim Permohonan_ID As String = CStr(Me.GridView1.DataKeys(intRow)("Permohonan_ID"))
                Dim IsBatal As Boolean = CBool(Me.GridView1.DataKeys(intRow)("IsBatal"))

                If IsBatal Then
                    If GetIsSuratFailPembatalan(CInt(Permohonan_ID)) Then
                        ViewSuratPembatalanFail(Permohonan_ID)
                    Else
                        ViewSuratPembatalanAuto(Permohonan_ID, True)
                    End If
                Else
                    If GetIsSuratFailKelulusan(CInt(Permohonan_ID)) Then
                        ViewSuratKelulusanFail(Permohonan_ID)
                    Else
                        ViewSuratKelulusanAuto(Permohonan_ID, True)
                    End If
                End If
            Catch ex As Exception
                MessageBox(ex.Message, Me.Page)
            End Try
        End If
    End Sub

    Private Sub GridView1_DataBound(sender As Object, e As EventArgs) Handles GridView1.DataBound
    End Sub

    Private Sub GridView1_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles GridView1.RowDataBound
        Try
            If e.Row.RowType = DataControlRowType.DataRow Then
                Dim dtTmp As DateTime = Convert.ToDateTime(e.Row.DataItem("TarikhMohon").ToString())
                Dim is24h As Boolean = Convert.ToBoolean(e.Row.DataItem("Is24jam").ToString())
                Dim isbatal As Boolean = Convert.ToBoolean(e.Row.DataItem("IsBatal").ToString())

                ' Check delayed status if needed
                If (((DateTime.Now - dtTmp).TotalHours > 24 And is24h) OrElse
                    ((DateTime.Now - dtTmp).TotalDays > 14 And Not is24h)) AndAlso
                    Not isbatal AndAlso Not e.Row.DataItem("Description").ToString().Contains("Permohonan Lulus") AndAlso
                    Not e.Row.DataItem("Description").ToString().Contains("Peraku Tidak Sokong") Then
                    ' Optional highlighting logic
                End If
            End If
        Catch ex As Exception
            MessageBox("Error checking delayed task.", Me)
        End Try
    End Sub

    Private Sub GridView1_RowDeleted(sender As Object, e As GridViewDeletedEventArgs) Handles GridView1.RowDeleted
        ShowAlert("success", "", "Rekod telah dipadam!")
    End Sub

    Private Sub backToList()
        FormView1.Visible = False
        whiteCard.Visible = True
        TabContainer1.Visible = False
        GridView1.SelectedIndex = -1
        GridView1.DataBind()
    End Sub

#End Region

#Region "FormView Lifecycle & Panel Access"

    Private Sub ButtonAddAssignment_Click(sender As Object, e As EventArgs) Handles ButtonAddAssignment.Click
        DDL_Status.SelectedValue = 0
        Session.Item("isInserted") = False
        Session.Remove("BantingDraftKey")
        FormView1.Visible = True
        FormView1.ChangeMode(FormViewMode.Insert)
        ClearFormViewInsertData()
        whiteCard.Visible = False
    End Sub

    Protected Sub BackButton_Click(sender As Object, e As EventArgs)
        If FormView1.CurrentMode = FormViewMode.Insert Then
            ClearFormViewInsertData()
        End If
        backToList()
    End Sub

    ''' <summary>
    ''' Clears all form fields, uploaded/added lists, draft keys, and panels in FormView1 when in InsertMode.
    ''' </summary>
    Private Sub ClearFormViewInsertData()
        Try
            ' Recursively clear standard inputs (TextBox, DropDownList, CheckBox, HiddenField, GridView, Repeater, BaseValidator)
            ClearControlValues(FormView1)

            ' Restore default text for read-only applicant preview fields
            Dim tbName As TextBox = TryCast(FormView1.FindControl("TB_Name"), TextBox)
            If tbName IsNot Nothing Then tbName.Text = "NULL"

            Dim tbNat As TextBox = TryCast(FormView1.FindControl("TB_Nat"), TextBox)
            If tbNat IsNot Nothing Then tbNat.Text = "NULL"

            Dim tbAddress As TextBox = TryCast(FormView1.FindControl("TB_Address"), TextBox)
            If tbAddress IsNot Nothing Then tbAddress.Text = "NULL"

            Dim tbRemarks As TextBox = TryCast(FormView1.FindControl("TB_Remarks"), TextBox)
            If tbRemarks IsNot Nothing Then tbRemarks.Text = "NULL"

            ' Reset visibility of all dynamic panels inside InsertItemTemplate
            Dim panelNames() As String = {
                "pnlpemohon", "pnlesen1", "pnlesen1a", "pnlesen1b", "pnlesen1c", "pnlesen1d", "pnlesen1e",
                "pnlesen2", "pnlesen3", "pnlesen4", "pnlesen5", "pnlesen6", "pnlbillboard", "pnlrujukan",
                "pnldeposit", "pnldeposit1", "pnlbatal", "pnlbatal1", "pnlbatal2", "pnlbatal3", "pnlbatal4", "pnlbatal5"
            }
            For Each pnlName As String In panelNames
                Dim pnl As Panel = TryCast(FormView1.FindControl(pnlName), Panel)
                If pnl IsNot Nothing Then pnl.Visible = False
            Next

            ' Reset bound child controls
            Dim rptSelectedItems As Repeater = TryCast(FormView1.FindControl("rptSelectedItems"), Repeater)
            If rptSelectedItems IsNot Nothing Then
                rptSelectedItems.DataSource = Nothing
                rptSelectedItems.DataBind()
            End If

            Dim gvIklanList As GridView = TryCast(FormView1.FindControl("gvIklanList"), GridView)
            If gvIklanList IsNot Nothing Then
                gvIklanList.DataSource = Nothing
                gvIklanList.DataBind()
            End If

            Dim gvAnjingList As GridView = TryCast(FormView1.FindControl("gvAnjingList"), GridView)
            If gvAnjingList IsNot Nothing Then
                gvAnjingList.DataSource = Nothing
                gvAnjingList.DataBind()
            End If

            ' Reset ViewState and Session collections
            ViewState("SelectedList") = New List(Of SelectedItem)()
            ViewState("IklanTable") = Nothing
            ViewState("AnjingTable") = Nothing
            Session.Remove("BantingDraftKey")
            Session.Item("isInserted") = False

            ' Hide QR code if opened
            If imgQrCode IsNot Nothing Then
                imgQrCode.Visible = False
                imgQrCode.ImageUrl = String.Empty
            End If

        Catch ex As Exception
            ' Safe fallback
        End Try
    End Sub

    ''' <summary>
    ''' Recursively traverses controls to reset input values and validation states.
    ''' </summary>
    Private Sub ClearControlValues(parent As Control)
        If parent Is Nothing Then Exit Sub

        For Each c As Control In parent.Controls
            If TypeOf c Is TextBox Then
                DirectCast(c, TextBox).Text = String.Empty
            ElseIf TypeOf c Is DropDownList Then
                Dim ddl As DropDownList = DirectCast(c, DropDownList)
                ddl.ClearSelection()
                If ddl.Items.Count > 0 Then
                    ddl.SelectedIndex = 0
                End If
            ElseIf TypeOf c Is CheckBox Then
                DirectCast(c, CheckBox).Checked = False
            ElseIf TypeOf c Is HiddenField Then
                DirectCast(c, HiddenField).Value = String.Empty
            ElseIf TypeOf c Is GridView Then
                Dim gv As GridView = DirectCast(c, GridView)
                gv.DataSource = Nothing
                gv.DataBind()
            ElseIf TypeOf c Is Repeater Then
                Dim rpt As Repeater = DirectCast(c, Repeater)
                rpt.DataSource = Nothing
                rpt.DataBind()
            ElseIf TypeOf c Is BaseValidator Then
                DirectCast(c, BaseValidator).IsValid = True
            End If

            If c.HasControls() Then
                ClearControlValues(c)
            End If
        Next
    End Sub

    Private Sub FormView1_ItemInserting(sender As Object, e As FormViewInsertEventArgs) Handles FormView1.ItemInserting
    End Sub

    Private Sub FormView1_ItemInserted(sender As Object, e As FormViewInsertedEventArgs) Handles FormView1.ItemInserted
        Session.Item("isInserted") = True
        GridView1.DataBind()
        GridViewMaintenanceTemplate.DataBind()
        TabContainer1.Visible = True
    End Sub

    Private Sub FormView1_ItemUpdating(sender As Object, e As FormViewUpdateEventArgs) Handles FormView1.ItemUpdating
        Dim cb As CheckBox = DirectCast(FormView1.FindControl("CB_IsBatal"), CheckBox)
        If cb IsNot Nothing AndAlso cb.Visible AndAlso cb.Checked Then
            e.NewValues("StatusID") = 0
        End If
    End Sub

    Private Sub FormView1_ItemUpdated(sender As Object, e As FormViewUpdatedEventArgs) Handles FormView1.ItemUpdated
        Dim PermohonanID As Integer = -1
        Dim IsBatal As Boolean
        Dim Is24Jam As String = ""
        Dim cb24h As CheckBox = DirectCast(FormView1.FindControl("CB_24h"), CheckBox)

        If Not IsDBNull(e.NewValues("Permohonan_ID")) Then
            PermohonanID = CInt(e.NewValues("Permohonan_ID"))
            IsBatal = CBool(e.NewValues("IsBatal"))

            If cb24h IsNot Nothing AndAlso Not cb24h.Checked Then
                Is24Jam = "BUKAN"
            End If

            If IsBatal AndAlso IsBatal <> CBool(e.OldValues("IsBatal")) Then
                Dim JenisBatal As Integer = CInt(e.NewValues("JenisBatal"))
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
        rptStatusProses.DataBind()
        rptStatusProsesBatal.DataBind()
        GridViewJabatanAgensiBatal.DataBind()
        ShowAlert("success", "", "Rekod permohonan " & Is24Jam & " 24 jam telah dikemaskini.")
    End Sub

    Private Sub FormView1_DataBound(sender As Object, e As EventArgs) Handles FormView1.DataBound
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
                Dim myList As List(Of SelectedItem) = DirectCast(ViewState("SelectedList"), List(Of SelectedItem))
                If myList Is Nothing Then
                    myList = New List(Of SelectedItem)()
                Else
                    myList.Clear()
                End If

                Dim JenisLesenDescList() As String = Split(HF_JenisLesenDescList.Value, ",")
                Dim JenisLesenIdList() As String = Split(HF_JenisLesenIdList.Value, ",")

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
                    If Not String.IsNullOrEmpty(item.ItemValue) Then
                        PanelAccess(CInt(item.ItemValue), False)
                    End If
                Next

                If ddl2 IsNot Nothing Then
                    If ddl2.SelectedIndex = 1 Then
                        pnlbatal1.Visible = True
                        pnlbatal3.Visible = True
                    ElseIf ddl2.SelectedIndex = 2 Then
                        pnlbatal2.Visible = True
                        pnlbatal3.Visible = True
                    End If
                End If

                ' Load Senarai Iklan
                Dim SaizIklanList() As String = Split(HF_SaizIklanList.Value, ",")
                Dim CahayaIklanList() As String = Split(HF_CahayaIklanList.Value, ",")
                Dim UnitIklanList() As String = Split(HF_UnitIklanList.Value, ",")

                If SaizIklanList.Length > 0 AndAlso Not String.IsNullOrWhiteSpace(SaizIklanList(0)) Then
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
                            newRow("Bercahaya") = If(i < CahayaIklanList.Length, CahayaIklanList(i).Trim(), "")
                            newRow("Unit") = If(i < UnitIklanList.Length, UnitIklanList(i).Trim(), "")
                            dt.Rows.Add(newRow)
                        End If
                    Next

                    ViewState("IklanTable") = dt
                    gvIklanList.DataSource = dt
                    gvIklanList.DataBind()
                End If

                ' Load Senarai Anjing
                Dim BakaAnjingList() As String = Split(HF_BakaAnjingList.Value, ",")
                Dim JantanList() As String = Split(HF_AnjingJantanList.Value, ",")
                Dim BetinaList() As String = Split(HF_AnjingBetinaList.Value, ",")
                Dim JantanMandulList() As String = Split(HF_AnjingJantanMandulList.Value, ",")
                Dim BetinaMandulList() As String = Split(HF_AnjingBetinaMandulList.Value, ",")

                If BakaAnjingList.Length > 0 AndAlso Not String.IsNullOrWhiteSpace(BakaAnjingList(0)) Then
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
                            newRow("Jantan") = If(i < JantanList.Length, JantanList(i).Trim(), "")
                            newRow("Betina") = If(i < BetinaList.Length, BetinaList(i).Trim(), "")
                            newRow("JantanMandul") = If(i < JantanMandulList.Length, JantanMandulList(i).Trim(), "")
                            newRow("BetinaMandul") = If(i < BetinaMandulList.Length, BetinaMandulList(i).Trim(), "")
                            dt.Rows.Add(newRow)
                        End If
                    Next

                    ViewState("AnjingTable") = dt
                    gvAnjingList.DataSource = dt
                    gvAnjingList.DataBind()
                End If

                ' Load Senarai Lokasi
                BindLokasiList()

                Using myConnection As New SqlConnection(CS)
                    myConnection.Open()
                    Dim SQL As String = "SELECT a.*, b.name FROM LESEN_Pemohon a " &
                                "INNER JOIN TBL_LOOKUPS b ON a.Pemohon_Nationality = b.id WHERE a.Pemohon_ID = @Pemohon_ID"
                    Using myCommandSelect As New SqlCommand(SQL, myConnection)
                        myCommandSelect.Parameters.AddWithValue("@Pemohon_ID", tbid.Text)
                        Using myReader As SqlDataReader = myCommandSelect.ExecuteReader()
                            If myReader.Read() Then
                                tbname.Text = myReader.Item("Pemohon_Name").ToString()
                                tbnation.Text = myReader.Item("name").ToString()
                                tbaddress.Text = myReader.Item("Pemohon_Address").ToString()
                                tbnote.Text = myReader.Item("Pemohon_Remarks").ToString()
                            Else
                                tbnote.Text = "NULL"
                                tbname.Text = "NULL"
                                tbnation.Text = "NULL"
                                tbaddress.Text = "NULL"
                                ShowAlert("error", "", "Rekod pemohon tiada di dalam sistem")
                            End If
                        End Using
                    End Using
                End Using
            ElseIf FormView1.CurrentMode = FormViewMode.Insert Then
                ' Lokasi dan gambar banting hanya boleh diurus dalam FormViewMode.Edit
            End If
        Catch ex As Exception
            ' Safe fallback
        End Try
    End Sub

    Private Sub SqlDataSourceForm_Inserted(sender As Object, e As SqlDataSourceStatusEventArgs) Handles SqlDataSourceForm.Inserted
        Dim PermohonanID As Integer = -1
        Dim JenisLesenIdList As String
        Dim JenisBatal As Integer
        Dim IsBatal As Boolean
        Dim Is24Jam As Boolean
        Dim strAlert As String = ""

        If Not IsDBNull(e.Command.Parameters("@Permohonan_ID").Value) Then
            PermohonanID = CInt(e.Command.Parameters("@Permohonan_ID").Value)
            JenisLesenIdList = e.Command.Parameters("@JenisLesenIdList").Value.ToString()
            IsBatal = CBool(e.Command.Parameters("@IsBatal").Value)
            Is24Jam = CBool(e.Command.Parameters("@Is24Jam").Value)

            If Not Is24Jam Then
                strAlert = "BUKAN"
            End If

            If Not IsBatal Then
                insertJabatanAgensi(JenisLesenIdList, PermohonanID)
                insertKadarBayaran(JenisLesenIdList, PermohonanID)
            Else
                JenisBatal = CInt(e.Command.Parameters("@JenisBatal").Value)
                If JenisBatal = 1 Then
                    insertJabatanAgensiBatal(PermohonanID)
                End If
            End If

            If Session("BantingDraftKey") IsNot Nothing Then
                Session.Remove("BantingDraftKey")
            End If

            ShowAlert("success", "", "Rekod permohonan " & strAlert & " 24 jam telah disimpan.")
        End If

        GridView1.DataBind()

        For n As Integer = 0 To GridView1.DataKeys.Count - 1
            If CInt(GridView1.DataKeys(n).Value) = PermohonanID Then
                GridView1.SelectRow(n)
                Exit For
            End If
        Next

        If GridView1.SelectedIndex = -1 Then
            FormView1.ChangeMode(FormViewMode.Insert)
            ButtonAddAssignment.Visible = True
        End If
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

        If clrflag Then
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

            Case 3 ' Lesen Anjing
                pnlc.Visible = True
                If FormView1.CurrentMode = FormViewMode.Insert Then
                    noruj.Text = "MPK/599/401/209/LA"
                End If

            Case 2, 25 ' Pasar Lambak, Tambah Petak
                pnlb.Visible = True

            Case 4 ' Pasar Penjaja
                pnld.Visible = True

            Case 1, 30 ' Lesen Perniagaan / Permit Perniagaan Sementara
                pnla.Visible = True
                pnla1.Visible = True

            Case 6, 7, 28 ' Tukar Alamat Perniagaan, Tambah Premis, Kurang Premis
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

            Case 13, 17, 18 ' Permit Kaki Lima, Lot Tepi Kedai, Lebuh Awam
                pnla.Visible = True

            Case 14 ' Pembatalan Lesen & Wang Amanah
                pnla.Visible = True

            Case 11, 23, 26 ' Tukar Nama Syarikat
                pnla.Visible = True
                pnla1.Visible = True
                pnla3.Visible = True
                pnla5.Visible = True

            Case 9, 24 ' Tukar Pemilik Perniagaan
                pnla.Visible = True
                pnla1.Visible = True
                pnla3.Visible = True
                pnla2.Visible = True

            Case 10, 12, 16 ' Tambah, Tukar, Pengurangan Visual Iklan
                pnla.Visible = True
                pnla1.Visible = True

            Case 5 ' Billboard
                pnla.Visible = True
                pnla1.Visible = True
                pnlbillboard.Visible = True

            Case 8, 29 ' Tambah, Pengurangan Jenis Perniagaan
                pnla.Visible = True
                pnla3.Visible = True
                pnla4.Visible = True
                lblalamat.Text = "Alamat Baru"

                If lesenid = 8 Then
                    lbljenisperniagaan.Text = "Jenis Perniagaan Tambahan"
                Else
                    lbljenisperniagaan.Text = "Pengurangan Jenis Perniagaan"
                End If

            Case 15 ' Expo
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

            Case 27 ' Banting
                pnla.Visible = True
                pnl6.Visible = True
                If FormView1.CurrentMode = FormViewMode.Edit Then
                    BindLokasiList()
                End If
        End Select
    End Sub

    Private Sub PanelAccessPembetulan(lesenid As Integer, clrflag As Boolean)
        If clrflag Then
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
            Case 3 ' Lesen Anjing
                pnlesen3_ins.Visible = True

            Case 2, 25 ' Pasar Lambak, Tambah Petak
                pnlesen2_ins.Visible = True

            Case 4 ' Pasar Penjaja
                pnlesen4_ins.Visible = True

            Case 1, 30 ' Lesen Perniagaan
                pnlesen1_ins.Visible = True
                pnlesen1a_ins.Visible = True

            Case 6, 7, 28 ' Tukar Alamat Perniagaan, Tambah Premis, Kurang Premis
                pnlesen1_ins.Visible = True
                pnlesen1a_ins.Visible = True
                pnlesen1c_ins.Visible = True

                If lesenid = 28 Then
                    Lbl_AlamatBaru_ins.Text = "Alamat Pengurangan Premis"
                ElseIf lesenid = 7 Then
                    Lbl_AlamatBaru_ins.Text = "Alamat Premis Tambahan"
                Else
                    Lbl_AlamatBaru_ins.Text = "Alamat Baru"
                End If

            Case 13, 17, 18 ' Permit Kaki Lima, Lot Tepi Kedai, Lebuh Awam
                pnlesen1_ins.Visible = True

            Case 14 ' Pembatalan Lesen & Wang Amanah
                pnlesen1_ins.Visible = True

            Case 11, 23, 26 ' Tukar Nama Syarikat
                pnlesen1_ins.Visible = True
                pnlesen1a_ins.Visible = True
                pnlesen1c_ins.Visible = True
                pnlesen1e_ins.Visible = True

            Case 9, 24 ' Tukar Pemilik Perniagaan
                pnlesen1_ins.Visible = True
                pnlesen1a_ins.Visible = True
                pnlesen1c_ins.Visible = True
                pnlesen1b_ins.Visible = True

            Case 10, 12, 16 ' Tambah, Tukar, Pengurangan Visual Iklan
                pnlesen1_ins.Visible = True
                pnlesen1a_ins.Visible = True

            Case 5 ' Billboard
                pnlesen1_ins.Visible = True
                pnlesen1a_ins.Visible = True
                pnlbillboard_ins.Visible = True

            Case 8, 29 ' Tambah, Pengurangan Jenis Perniagaan
                pnlesen1_ins.Visible = True
                pnlesen1c_ins.Visible = True
                pnlesen1d_ins.Visible = True
                Lbl_JenisPerniagaanBaru_ins.Text = "Alamat Baru"

                If lesenid = 8 Then
                    Lbl_JenisPerniagaanBaru_ins.Text = "Jenis Perniagaan Tambahan"
                Else
                    Lbl_JenisPerniagaanBaru_ins.Text = "Pengurangan Jenis Perniagaan"
                End If

            Case 15 ' Expo
                pnlesen5_ins.Visible = True

            Case 19 ' Nama + Alamat + Visual Iklan
                pnlesen1_ins.Visible = True
                pnlesen1a_ins.Visible = True
                pnlesen1c_ins.Visible = True
                pnlesen1e_ins.Visible = True

            Case 20 ' Pemilik + Alamat + Visual Iklan
                pnlesen1_ins.Visible = True
                pnlesen1a_ins.Visible = True
                pnlesen1b_ins.Visible = True
                pnlesen1c_ins.Visible = True

            Case 27 ' Pemilik + Alamat + Visual Iklan
                pnlesen1_ins.Visible = True
                pnlesen6_ins.Visible = True
        End Select
    End Sub

    Private Sub initPageName()
        Dim menuName As String = GlobalClass.writeTitlePage(Request.QueryString("m_Id"), "")
        Dim idWindowTitle2 As HtmlGenericControl = DirectCast(FormView1.FindControl("idWindowTitle2"), HtmlGenericControl)
        Dim idWindowTitle3 As HtmlGenericControl = DirectCast(FormView1.FindControl("idWindowTitle3"), HtmlGenericControl)

        If String.IsNullOrEmpty(menuName) Then
            menuName = "Permohonan"
        End If

        idWindowTitle.InnerText = menuName
        Try
            If idWindowTitle2 IsNot Nothing Then
                idWindowTitle2.InnerText = idWindowTitle2.InnerText & " " & menuName
            End If
        Catch ex As Exception
        End Try

        Try
            If idWindowTitle3 IsNot Nothing Then
                idWindowTitle3.InnerText = idWindowTitle3.InnerText & " " & menuName
            End If
        Catch ex As Exception
        End Try
    End Sub

#End Region

#Region "Multi-Licence Tag Selection (Jenis Lesen)"

    Protected Sub ddlItems_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        Dim ddlItems As DropDownList = DirectCast(FormView1.FindControl("ddlItems"), DropDownList)
        If String.IsNullOrEmpty(ddlItems.SelectedValue) Then Return

        Dim myList As List(Of SelectedItem) = DirectCast(ViewState("SelectedList"), List(Of SelectedItem))

        If myList.Any(Function(x) x.ItemValue = "3") OrElse
            myList.Any(Function(x) x.ItemValue = "5") OrElse
            myList.Any(Function(x) x.ItemValue = "25") OrElse
            myList.Any(Function(x) x.ItemValue = "27") OrElse
            (myList.Count > 0 AndAlso
            (ddlItems.SelectedValue = "3" OrElse
            ddlItems.SelectedValue = "5" OrElse
            ddlItems.SelectedValue = "25" OrElse
            ddlItems.SelectedValue = "27")) Then

            ShowAlert("error", "", "Jenis lesen yang dipilih tidak boleh dicampur.")
            ddlItems.SelectedIndex = 0
            Return
        End If

        If ddlItems.SelectedValue = "27" Then
            TabSurat.Visible = False
            TabJabatanAgensi.Visible = False
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
            PanelAccess(CInt(ddlItems.SelectedValue), False)

            If FormView1.CurrentMode = FormViewMode.Insert Then
                LoadPrevRekodPermohonan()
            End If
        End If

        ddlItems.SelectedIndex = 0
    End Sub

    Protected Sub rptSelectedItems_ItemCommand(ByVal source As Object, ByVal e As RepeaterCommandEventArgs)
        Dim HF_JenisLesenDescList As HiddenField = DirectCast(FormView1.FindControl("HF_JenisLesenDescList"), HiddenField)
        Dim HF_JenisLesenIdList As HiddenField = DirectCast(FormView1.FindControl("HF_JenisLesenIdList"), HiddenField)

        If e.CommandName = "Remove" Then
            Dim myList As List(Of SelectedItem) = DirectCast(ViewState("SelectedList"), List(Of SelectedItem))
            Dim valueToRemove As String = e.CommandArgument.ToString()

            myList.RemoveAll(Function(x) x.ItemValue = valueToRemove)
            ViewState("SelectedList") = myList
            BindRepeater()

            PanelAccess(0, True)

            HF_JenisLesenDescList.Value = ""
            HF_JenisLesenIdList.Value = ""

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
        Dim HF_JenisLesenDescList As HiddenField = DirectCast(FormView1.FindControl("HF_JenisLesenDescList"), HiddenField)
        Dim HF_JenisLesenIdList As HiddenField = DirectCast(FormView1.FindControl("HF_JenisLesenIdList"), HiddenField)

        If HF_JenisLesenDescList.Value.ToString().Length = 0 Then
            HF_JenisLesenDescList.Value = itemtext
        Else
            HF_JenisLesenDescList.Value += "," + itemtext
        End If

        If HF_JenisLesenIdList.Value.ToString().Length = 0 Then
            HF_JenisLesenIdList.Value = itemval
        Else
            HF_JenisLesenIdList.Value += "," + itemval
        End If
    End Sub

    Private Sub LoadPrevRekodPermohonan()
        Dim tbid As TextBox = DirectCast(FormView1.FindControl("TB_PemohonID"), TextBox)
        Dim TB_NamaSyarikat As TextBox = DirectCast(FormView1.FindControl("TB_NamaSyarikat"), TextBox)
        Dim TB_NoPendaftaran As TextBox = DirectCast(FormView1.FindControl("TB_NoPendaftaran"), TextBox)
        Dim TB_NoAkaun As TextBox = DirectCast(FormView1.FindControl("TB_NoAkaun"), TextBox)
        Dim TB_AlamatPremis As TextBox = DirectCast(FormView1.FindControl("TB_AlamatPremis"), TextBox)
        Dim TB_JenisPerniagaan As TextBox = DirectCast(FormView1.FindControl("TB_JenisPerniagaan"), TextBox)
        Dim TB_AlamatPenjajaan As TextBox = DirectCast(FormView1.FindControl("TB_AlamatPenjajaan"), TextBox)
        Dim TB_JenisPerniagaanPenjaja As TextBox = DirectCast(FormView1.FindControl("TB_JenisPerniagaanPenjaja"), TextBox)

        Dim pnla As Panel = DirectCast(FormView1.FindControl("pnlesen1"), Panel)
        Dim pnld As Panel = DirectCast(FormView1.FindControl("pnlesen4"), Panel)

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "WITH RankedData AS (
                SELECT 
                    Permohonan_PemohonID,
                    NamaSyarikat, NoPendaftaran, NoAkaun, AlamatPremis, JenisPerniagaan, 
                    AlamatBaru, JenisPerniagaanBaru, NamaBaruSyarikat, 
                    AlamatPenjajaan, JenisPerniagaanPenjaja,
                    ROW_NUMBER() OVER (PARTITION BY Permohonan_PemohonID ORDER BY CASE WHEN NamaSyarikat IS NOT NULL THEN Permohonan_ID END DESC) as rn1,
                    ROW_NUMBER() OVER (PARTITION BY Permohonan_PemohonID ORDER BY CASE WHEN NoPendaftaran IS NOT NULL THEN Permohonan_ID END DESC) as rn2,
                    ROW_NUMBER() OVER (PARTITION BY Permohonan_PemohonID ORDER BY CASE WHEN NoAkaun IS NOT NULL THEN Permohonan_ID END DESC) as rn3,
                    ROW_NUMBER() OVER (PARTITION BY Permohonan_PemohonID ORDER BY CASE WHEN AlamatPremis IS NOT NULL THEN Permohonan_ID END DESC) as rn4,
                    ROW_NUMBER() OVER (PARTITION BY Permohonan_PemohonID ORDER BY CASE WHEN JenisPerniagaan IS NOT NULL THEN Permohonan_ID END DESC) as rn5,
                    ROW_NUMBER() OVER (PARTITION BY Permohonan_PemohonID ORDER BY CASE WHEN AlamatBaru IS NOT NULL THEN Permohonan_ID END DESC) as rn6,
                    ROW_NUMBER() OVER (PARTITION BY Permohonan_PemohonID ORDER BY CASE WHEN JenisPerniagaanBaru IS NOT NULL THEN Permohonan_ID END DESC) as rn7,
                    ROW_NUMBER() OVER (PARTITION BY Permohonan_PemohonID ORDER BY CASE WHEN NamaBaruSyarikat IS NOT NULL THEN Permohonan_ID END DESC) as rn8,
                    ROW_NUMBER() OVER (PARTITION BY Permohonan_PemohonID ORDER BY CASE WHEN AlamatPenjajaan IS NOT NULL THEN Permohonan_ID END DESC) as rn9,
                    ROW_NUMBER() OVER (PARTITION BY Permohonan_PemohonID ORDER BY CASE WHEN JenisPerniagaanPenjaja IS NOT NULL THEN Permohonan_ID END DESC) as rn10
                FROM LESEN_Permohonan
                WHERE Permohonan_PemohonID = @Pemohon_ID 
            )
            SELECT 
                Permohonan_PemohonID,
                MAX(CASE WHEN rn1 = 1 THEN NamaSyarikat END) AS NamaSyarikat,
                MAX(CASE WHEN rn2 = 1 THEN NoPendaftaran END) AS NoPendaftaran,
                MAX(CASE WHEN rn3 = 1 THEN NoAkaun END) AS NoAkaun,
                MAX(CASE WHEN rn4 = 1 THEN AlamatPremis END) AS AlamatPremis,
                MAX(CASE WHEN rn5 = 1 THEN JenisPerniagaan END) AS JenisPerniagaan,
                MAX(CASE WHEN rn6 = 1 THEN AlamatBaru END) AS AlamatBaru,
                MAX(CASE WHEN rn7 = 1 THEN JenisPerniagaanBaru END) AS JenisPerniagaanBaru,
                MAX(CASE WHEN rn8 = 1 THEN NamaBaruSyarikat END) AS NamaBaruSyarikat,
                MAX(CASE WHEN rn9 = 1 THEN AlamatPenjajaan END) AS AlamatPenjajaan,
                MAX(CASE WHEN rn10 = 1 THEN JenisPerniagaanPenjaja END) AS JenisPerniagaanPenjaja
            FROM RankedData
            GROUP BY Permohonan_PemohonID;"

            Using myCommandSelect As New SqlCommand(SQL, myConnection)
                myCommandSelect.Parameters.AddWithValue("@Pemohon_ID", tbid.Text)
                Using myReader As SqlDataReader = myCommandSelect.ExecuteReader()
                    If myReader.Read() Then
                        If pnla.Visible Then
                            TB_NamaSyarikat.Text = If(myReader.Item("NamaBaruSyarikat").ToString().Length > 0, myReader.Item("NamaBaruSyarikat").ToString(), myReader.Item("NamaSyarikat").ToString())
                            TB_NoPendaftaran.Text = myReader.Item("NoPendaftaran").ToString()
                            TB_NoAkaun.Text = myReader.Item("NoAkaun").ToString()
                            TB_AlamatPremis.Text = If(myReader.Item("AlamatBaru").ToString().Length > 0, myReader.Item("AlamatBaru").ToString(), myReader.Item("AlamatPremis").ToString())
                            TB_JenisPerniagaan.Text = If(myReader.Item("JenisPerniagaanBaru").ToString().Length > 0, myReader.Item("JenisPerniagaanBaru").ToString(), myReader.Item("JenisPerniagaan").ToString())
                        End If

                        If pnld.Visible Then
                            TB_AlamatPenjajaan.Text = myReader.Item("AlamatPenjajaan").ToString()
                            TB_JenisPerniagaanPenjaja.Text = myReader.Item("JenisPerniagaanPenjaja").ToString()
                        End If
                    End If
                End Using
            End Using
        End Using
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
            Case "0"
                pnlf.Visible = False
                pnlbatal1.Visible = False
            Case "3" ' Lesen Anjing
                pnlc.Visible = True
                If FormView1.CurrentMode = FormViewMode.Insert Then
                    noruj.Text = "MPK/599/401/209/LA"
                End If
            Case "2", "25" ' Pasar Lambak, Tambah Petak
                pnlb.Visible = True
            Case "4" ' Pasar Penjaja
                pnld.Visible = True
            Case "1", "30" ' Lesen Perniagaan
                pnla.Visible = True
                pnla1.Visible = True
            Case "6", "7", "28" ' Tukar Alamat Perniagaan, Tambah Premis, Pengurangan Premis
                pnla.Visible = True
                pnla1.Visible = True
                pnla3.Visible = True
                If ddl.SelectedValue = "28" Then
                    lblalamat.Text = "Alamat Pengurangan Premis"
                ElseIf ddl.SelectedValue = "7" Then
                    lblalamat.Text = "Alamat Premis Tambahan"
                Else
                    lblalamat.Text = "Alamat Baru"
                End If
            Case "13", "17", "18" ' Permit Kaki Lima, Lot Tepi Kedai, Lebuh Awam
                pnla.Visible = True
            Case "14" ' Pembatalan Lesen & Wang Amanah
                pnla.Visible = True
            Case "11", "23", "26" ' Tukar Nama Syarikat
                pnla.Visible = True
                pnla1.Visible = True
                pnla3.Visible = True
                pnla5.Visible = True
            Case "9", "24" ' Tukar Pemilik Perniagaan
                pnla.Visible = True
                pnla1.Visible = True
                pnla3.Visible = True
                pnla2.Visible = True
            Case "10", "12", "16" ' Tambah, Tukar, Pengurangan Visual Iklan
                pnla.Visible = True
                pnla1.Visible = True
            Case "5" ' Billboard
                pnla.Visible = True
                pnla1.Visible = True
                pnlbillboard.Visible = True
            Case "8", "29" ' Tambah, Pengurangan Jenis Perniagaan
                pnla.Visible = True
                pnla3.Visible = True
                pnla4.Visible = True
                lblalamat.Text = "Alamat Baru"
                If ddl.SelectedValue = "8" Then
                    lbljenisperniagaan.Text = "Jenis Perniagaan Tambahan"
                Else
                    lbljenisperniagaan.Text = "Pengurangan Jenis Perniagaan"
                End If
            Case "15" ' Expo
                pnle.Visible = True
            Case "19"
                pnla.Visible = True
                pnla1.Visible = True
                pnla3.Visible = True
                pnla5.Visible = True
            Case "20"
                pnla.Visible = True
                pnla1.Visible = True
                pnla2.Visible = True
                pnla3.Visible = True
        End Select

        Page.SetFocus(Me.ui_btnPageBottom.ClientID)
    End Sub

#End Region

#Region "Dynamic Child Grids (Iklan, Anjing, Lokasi - Edit & Pembetulan)"

    ' --- Iklan (Regular) ---
    Protected Sub btnAddIklan_Click(sender As Object, e As EventArgs)
        Dim TB_SaizIklan1 As TextBox = DirectCast(FormView1.FindControl("TB_SaizIklan1"), TextBox)
        Dim DDL_Iklan1 As DropDownList = DirectCast(FormView1.FindControl("DDL_Iklan1"), DropDownList)
        Dim TB_UnitIklan1 As TextBox = DirectCast(FormView1.FindControl("TB_UnitIklan1"), TextBox)
        Dim gvIklanList As GridView = DirectCast(FormView1.FindControl("gvIklanList"), GridView)

        If Not String.IsNullOrWhiteSpace(TB_SaizIklan1.Text) AndAlso DDL_Iklan1.SelectedValue <> "" AndAlso Not String.IsNullOrWhiteSpace(TB_UnitIklan1.Text) Then
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
            newRow("Bercahaya") = DDL_Iklan1.SelectedValue.ToString()
            newRow("Unit") = TB_UnitIklan1.Text
            dt.Rows.Add(newRow)

            ViewState("IklanTable") = dt
            gvIklanList.DataSource = dt
            gvIklanList.DataBind()

            updateIklanList(newRow("SaizIklan").ToString(), newRow("Bercahaya").ToString(), newRow("Unit").ToString())

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
                updateIklanList(row("SaizIklan").ToString(), row("Bercahaya").ToString(), row("Unit").ToString())
            Next
        End If
    End Sub

    Private Sub updateIklanList(ByVal saizVal As String, ByVal cahayaVal As String, ByVal unitVal As String)
        Dim HF_SaizIklanList As HiddenField = DirectCast(FormView1.FindControl("HF_SaizIklanList"), HiddenField)
        Dim HF_CahayaIklanList As HiddenField = DirectCast(FormView1.FindControl("HF_CahayaIklanList"), HiddenField)
        Dim HF_UnitIklanList As HiddenField = DirectCast(FormView1.FindControl("HF_UnitIklanList"), HiddenField)

        If HF_SaizIklanList.Value.ToString().Length = 0 Then
            HF_SaizIklanList.Value = saizVal
        Else
            HF_SaizIklanList.Value += "," + saizVal
        End If

        If HF_CahayaIklanList.Value.ToString().Length = 0 Then
            HF_CahayaIklanList.Value = cahayaVal
        Else
            HF_CahayaIklanList.Value += "," + cahayaVal
        End If

        If HF_UnitIklanList.Value.ToString().Length = 0 Then
            HF_UnitIklanList.Value = unitVal
        Else
            HF_UnitIklanList.Value += "," + unitVal
        End If
    End Sub

    ' --- Anjing (Regular) ---
    Protected Sub btnAddAnjing_Click(sender As Object, e As EventArgs)
        Dim DDL_BakaAnjing1 As DropDownList = DirectCast(FormView1.FindControl("DDL_BakaAnjing1"), DropDownList)
        Dim TB_Jantan1 As TextBox = DirectCast(FormView1.FindControl("TB_Jantan1"), TextBox)
        Dim TB_Betina1 As TextBox = DirectCast(FormView1.FindControl("TB_Betina1"), TextBox)
        Dim TB_JantanMandul1 As TextBox = DirectCast(FormView1.FindControl("TB_JantanMandul1"), TextBox)
        Dim TB_BetinaMandul1 As TextBox = DirectCast(FormView1.FindControl("TB_BetinaMandul1"), TextBox)
        Dim gvAnjingList As GridView = DirectCast(FormView1.FindControl("gvAnjingList"), GridView)

        If Not String.IsNullOrWhiteSpace(TB_Jantan1.Text) AndAlso Not String.IsNullOrWhiteSpace(TB_Betina1.Text) AndAlso
            Not String.IsNullOrWhiteSpace(TB_JantanMandul1.Text) AndAlso Not String.IsNullOrWhiteSpace(TB_BetinaMandul1.Text) AndAlso
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

            updateAnjingList(newRow("Baka").ToString(), newRow("Jantan").ToString(), newRow("Betina").ToString(), newRow("JantanMandul").ToString(), newRow("BetinaMandul").ToString())

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
                updateAnjingList(row("Baka").ToString(), row("Jantan").ToString(), row("Betina").ToString(), row("JantanMandul").ToString(), row("BetinaMandul").ToString())
            Next
        End If
    End Sub

    Private Sub updateAnjingList(ByVal bakaVal As String, ByVal jantanVal As String, ByVal betinaVal As String, ByVal jMandulVal As String, ByVal bMandulVal As String)
        Dim HF_BakaAnjingList As HiddenField = DirectCast(FormView1.FindControl("HF_BakaAnjingList"), HiddenField)
        Dim HF_AnjingJantanList As HiddenField = DirectCast(FormView1.FindControl("HF_AnjingJantanList"), HiddenField)
        Dim HF_AnjingBetinaList As HiddenField = DirectCast(FormView1.FindControl("HF_AnjingBetinaList"), HiddenField)
        Dim HF_AnjingJantanMandulList As HiddenField = DirectCast(FormView1.FindControl("HF_AnjingJantanMandulList"), HiddenField)
        Dim HF_AnjingBetinaMandulList As HiddenField = DirectCast(FormView1.FindControl("HF_AnjingBetinaMandulList"), HiddenField)

        If HF_BakaAnjingList.Value.ToString().Length = 0 Then
            HF_BakaAnjingList.Value = bakaVal
        Else
            HF_BakaAnjingList.Value += "," + bakaVal
        End If

        If HF_AnjingJantanList.Value.ToString().Length = 0 Then
            HF_AnjingJantanList.Value = jantanVal
        Else
            HF_AnjingJantanList.Value += "," + jantanVal
        End If

        If HF_AnjingBetinaList.Value.ToString().Length = 0 Then
            HF_AnjingBetinaList.Value = betinaVal
        Else
            HF_AnjingBetinaList.Value += "," + betinaVal
        End If

        If HF_AnjingJantanMandulList.Value.ToString().Length = 0 Then
            HF_AnjingJantanMandulList.Value = jMandulVal
        Else
            HF_AnjingJantanMandulList.Value += "," + jMandulVal
        End If

        If HF_AnjingBetinaMandulList.Value.ToString().Length = 0 Then
            HF_AnjingBetinaMandulList.Value = bMandulVal
        Else
            HF_AnjingBetinaMandulList.Value += "," + bMandulVal
        End If
    End Sub

    ' --- Lokasi & Gambar Banting (Regular) ---
    Private Function GetCurrentPermohonanID() As Integer
        If FormView1.CurrentMode = FormViewMode.Edit Then
            If GridView1.SelectedDataKey IsNot Nothing AndAlso GridView1.SelectedDataKey.Values("Permohonan_ID") IsNot Nothing Then
                Return CInt(GridView1.SelectedDataKey.Values("Permohonan_ID"))
            End If
        End If
        Return 0
    End Function

    Private Function GetBantingDraftKey() As String
        If Session("BantingDraftKey") Is Nothing Then
            Session("BantingDraftKey") = Guid.NewGuid().ToString()
        End If
        Return Session("BantingDraftKey").ToString()
    End Function

    Private Sub BindLokasiList()
        If FormView1.CurrentMode <> FormViewMode.Edit Then Exit Sub

        Dim gvLokasiList As GridView = DirectCast(FormView1.FindControl("gvLokasiList"), GridView)
        If gvLokasiList Is Nothing Then Exit Sub

        Dim permohonanId As Integer = GetCurrentPermohonanID()
        If permohonanId <= 0 Then Exit Sub

        ' If in Edit mode, migrate any existing LokasiList into LESEN_BantingLokasi if table is currently empty
        EnsureLokasiMigrated(permohonanId)

        Dim dt As New DataTable()
        Using conn As New SqlConnection(CS)
            conn.Open()
            Dim sql As String = "SELECT Lokasi_ID, Lokasi, Permohonan_ID FROM LESEN_BantingLokasi WHERE Permohonan_ID = @Permohonan_ID ORDER BY Lokasi_ID ASC"

            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@Permohonan_ID", permohonanId)
                Using da As New SqlDataAdapter(cmd)
                    da.Fill(dt)
                End Using
            End Using
        End Using

        gvLokasiList.DataSource = dt
        gvLokasiList.DataBind()

        RegisterBantingPostBackControls()
        UpdateHF_LokasiList()
    End Sub

    Private Sub RegisterBantingPostBackControls()
        Dim gvLokasiList As GridView = DirectCast(FormView1.FindControl("gvLokasiList"), GridView)
        If gvLokasiList IsNot Nothing Then
            Dim sm As ScriptManager = ScriptManager.GetCurrent(Page)
            If sm IsNot Nothing Then
                For Each row As GridViewRow In gvLokasiList.Rows
                    Dim btnUpload As Control = row.FindControl("btnUploadBantingImg")
                    If btnUpload IsNot Nothing Then
                        sm.RegisterPostBackControl(btnUpload)
                    End If
                Next
            End If
        End If
    End Sub

    Private Sub EnsureLokasiMigrated(permohonanId As Integer)
        Using conn As New SqlConnection(CS)
            conn.Open()
            Dim checkSql As String = "SELECT COUNT(*) FROM LESEN_BantingLokasi WHERE Permohonan_ID = @Permohonan_ID"
            Using checkCmd As New SqlCommand(checkSql, conn)
                checkCmd.Parameters.AddWithValue("@Permohonan_ID", permohonanId)
                Dim count As Integer = CInt(checkCmd.ExecuteScalar())
                If count = 0 Then
                    Dim getSql As String = "SELECT LokasiList FROM LESEN_Permohonan WHERE Permohonan_ID = @Permohonan_ID"
                    Using getCmd As New SqlCommand(getSql, conn)
                        getCmd.Parameters.AddWithValue("@Permohonan_ID", permohonanId)
                        Dim objLokasi As Object = getCmd.ExecuteScalar()
                        If objLokasi IsNot Nothing AndAlso Not IsDBNull(objLokasi) Then
                            Dim strLokasi As String = objLokasi.ToString().Trim()
                            If strLokasi.Length > 0 Then
                                Dim parts() As String = Split(strLokasi, "||")
                                For Each p As String In parts
                                    Dim locText As String = p.Trim()
                                    If locText.Length > 0 Then
                                        Dim insSql As String = "INSERT INTO LESEN_BantingLokasi (Permohonan_ID, Lokasi, CreatedDt) VALUES (@Permohonan_ID, @Lokasi, GETDATE())"
                                        Using insCmd As New SqlCommand(insSql, conn)
                                            insCmd.Parameters.AddWithValue("@Permohonan_ID", permohonanId)
                                            insCmd.Parameters.AddWithValue("@Lokasi", locText)
                                            insCmd.ExecuteNonQuery()
                                        End Using
                                    End If
                                Next
                            End If
                        End If
                    End Using
                End If
            End Using
        End Using
    End Sub

    Protected Sub gvLokasiList_RowDataBound(sender As Object, e As GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim btnUpload As Control = e.Row.FindControl("btnUploadBantingImg")
            If btnUpload IsNot Nothing Then
                Dim sm As ScriptManager = ScriptManager.GetCurrent(Page)
                If sm IsNot Nothing Then
                    sm.RegisterPostBackControl(btnUpload)
                End If
            End If

            Dim gvImages As GridView = DirectCast(e.Row.FindControl("gvBantingImages"), GridView)
            If gvImages IsNot Nothing Then
                Dim rowView As DataRowView = DirectCast(e.Row.DataItem, DataRowView)
                Dim lokasiId As Integer = CInt(rowView("Lokasi_ID"))

                Dim dtImages As New DataTable()
                Using conn As New SqlConnection(CS)
                    conn.Open()
                    Dim sql As String = "SELECT Imej_ID, Lokasi_ID, Permohonan_ID, UniqueID, FileName, FilePath, Remarks, CreatedDt FROM LESEN_BantingImej WHERE Lokasi_ID = @Lokasi_ID ORDER BY Imej_ID ASC"
                    Using cmd As New SqlCommand(sql, conn)
                        cmd.Parameters.AddWithValue("@Lokasi_ID", lokasiId)
                        Using da As New SqlDataAdapter(cmd)
                            da.Fill(dtImages)
                        End Using
                    End Using
                End Using

                gvImages.DataSource = dtImages
                gvImages.DataBind()
            End If
        End If
    End Sub

    Protected Sub btnAddLokasi_Click(sender As Object, e As EventArgs)
        If FormView1.CurrentMode <> FormViewMode.Edit Then Exit Sub

        Dim TB_LokasiBanting As TextBox = DirectCast(FormView1.FindControl("TB_LokasiBanting"), TextBox)
        If TB_LokasiBanting IsNot Nothing AndAlso Not String.IsNullOrWhiteSpace(TB_LokasiBanting.Text) Then
            Dim permohonanId As Integer = GetCurrentPermohonanID()
            If permohonanId <= 0 Then Exit Sub

            Dim creatorId As String = If(Session.Item("sessionUserName") IsNot Nothing, Session.Item("sessionUserName").ToString(), "")

            Using conn As New SqlConnection(CS)
                conn.Open()
                Dim sql As String = "INSERT INTO LESEN_BantingLokasi (Permohonan_ID, Lokasi, CreatedDt, CreatorID) " &
                                    "VALUES (@Permohonan_ID, @Lokasi, GETDATE(), @CreatorID)"
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@Permohonan_ID", permohonanId)
                    cmd.Parameters.AddWithValue("@Lokasi", TB_LokasiBanting.Text.Trim())
                    cmd.Parameters.AddWithValue("@CreatorID", creatorId)
                    cmd.ExecuteNonQuery()
                End Using
            End Using

            TB_LokasiBanting.Text = ""
            BindLokasiList()
        End If
    End Sub

    Protected Sub btnRemoveLokasi_Click(sender As Object, e As EventArgs)
        If FormView1.CurrentMode <> FormViewMode.Edit Then Exit Sub

        Dim btn As LinkButton = DirectCast(sender, LinkButton)
        Dim lokasiId As Integer = CInt(btn.CommandArgument)
        DeleteLokasiFiles(lokasiId)

        Using conn As New SqlConnection(CS)
            conn.Open()
            Using cmd As New SqlCommand("DELETE FROM LESEN_BantingLokasi WHERE Lokasi_ID = @Lokasi_ID", conn)
                cmd.Parameters.AddWithValue("@Lokasi_ID", lokasiId)
                cmd.ExecuteNonQuery()
            End Using
        End Using

        BindLokasiList()
        ShowAlert("success", "", "Lokasi dan gambar banting berjaya dipadam.")
    End Sub

    Protected Sub gvLokasiList_RowDeleting(sender As Object, e As GridViewDeleteEventArgs)
        ' Stub maintained for backward compatibility
    End Sub

    Protected Sub btnUploadBantingImg_Click(sender As Object, e As EventArgs)
        If FormView1.CurrentMode <> FormViewMode.Edit Then Exit Sub

        Dim btn As LinkButton = DirectCast(sender, LinkButton)
        Dim lokasiId As Integer = CInt(btn.CommandArgument)
        
        Dim row As GridViewRow = TryCast(btn.NamingContainer, GridViewRow)
        If row Is Nothing Then
            Dim c As Control = btn.Parent
            While c IsNot Nothing AndAlso Not (TypeOf c Is GridViewRow)
                c = c.Parent
            End While
            row = TryCast(c, GridViewRow)
        End If

        Dim fu As FileUpload = If(row IsNot Nothing, DirectCast(row.FindControl("fuBantingImg"), FileUpload), Nothing)
        Dim txtRemarks As TextBox = If(row IsNot Nothing, DirectCast(row.FindControl("txtBantingRemarks"), TextBox), Nothing)

        ' Retrieve uploaded file either from fu or Request.Files fallback
        Dim postedFile As HttpPostedFile = Nothing

        If fu IsNot Nothing AndAlso fu.HasFile Then
            postedFile = fu.PostedFile
        ElseIf fu IsNot Nothing AndAlso Request.Files(fu.UniqueID) IsNot Nothing AndAlso Request.Files(fu.UniqueID).ContentLength > 0 Then
            postedFile = Request.Files(fu.UniqueID)
        Else
            ' Fallback search through Request.Files
            For i As Integer = 0 To Request.Files.Count - 1
                Dim key As String = Request.Files.GetKey(i)
                If key IsNot Nothing AndAlso (key.EndsWith("fuBantingImg") OrElse (fu IsNot Nothing AndAlso key = fu.UniqueID)) Then
                    If Request.Files(i).ContentLength > 0 Then
                        postedFile = Request.Files(i)
                        Exit For
                    End If
                End If
            Next
        End If

        If postedFile Is Nothing OrElse postedFile.ContentLength = 0 Then
            ShowAlert("error", "", "Sila pilih fail imej banting terlebih dahulu.")
            Exit Sub
        End If

        Dim ext As String = Path.GetExtension(postedFile.FileName).ToLower()
        Dim allowedExts As String() = {".jpg", ".jpeg", ".png", ".gif", ".webp", ".bmp"}
        If Not allowedExts.Contains(ext) Then
            ShowAlert("error", "", "Hanya format imej dibenarkan (JPG, PNG, GIF, WEBP, BMP).")
            Exit Sub
        End If

        Dim permohonanId As Integer = GetCurrentPermohonanID()
        If permohonanId <= 0 Then
            ShowAlert("error", "", "ID Permohonan tidak sah.")
            Exit Sub
        End If

        Dim uniqueId As String = GenerateBantingUniqueID()
        Dim uploadFolder As String = Server.MapPath("~/Uploads/Banting/")
        If Not Directory.Exists(uploadFolder) Then
            Directory.CreateDirectory(uploadFolder)
        End If

        Dim fileName As String = uniqueId & ext
        Dim savePath As String = Path.Combine(uploadFolder, fileName)
        postedFile.SaveAs(savePath)

        Dim virtualPath As String = "~/Uploads/Banting/" & fileName
        Dim remarks As String = If(txtRemarks IsNot Nothing, txtRemarks.Text.Trim(), "")
        Dim creatorId As String = If(Session.Item("sessionUserName") IsNot Nothing, Session.Item("sessionUserName").ToString(), "")

        Using conn As New SqlConnection(CS)
            conn.Open()
            Dim sql As String = "INSERT INTO LESEN_BantingImej (Lokasi_ID, Permohonan_ID, UniqueID, FileName, FilePath, ContentType, FileSize, Remarks, CreatedDt, CreatorID) " &
                                "VALUES (@Lokasi_ID, @Permohonan_ID, @UniqueID, @FileName, @FilePath, @ContentType, @FileSize, @Remarks, GETDATE(), @CreatorID)"
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@Lokasi_ID", lokasiId)
                cmd.Parameters.AddWithValue("@Permohonan_ID", permohonanId)
                cmd.Parameters.AddWithValue("@UniqueID", uniqueId)
                cmd.Parameters.AddWithValue("@FileName", Path.GetFileName(postedFile.FileName))
                cmd.Parameters.AddWithValue("@FilePath", virtualPath)
                cmd.Parameters.AddWithValue("@ContentType", postedFile.ContentType)
                cmd.Parameters.AddWithValue("@FileSize", postedFile.ContentLength)
                cmd.Parameters.AddWithValue("@Remarks", remarks)
                cmd.Parameters.AddWithValue("@CreatorID", creatorId)
                cmd.ExecuteNonQuery()
            End Using
        End Using

        BindLokasiList()
        ShowAlert("success", "", "Imej banting berjaya dimuat naik dengan ID Unik: " & uniqueId)
    End Sub

    Protected Sub btnDeleteBantingImg_Click(sender As Object, e As EventArgs)
        If FormView1.CurrentMode <> FormViewMode.Edit Then Exit Sub

        Dim btn As LinkButton = DirectCast(sender, LinkButton)
        Dim imejId As Integer = CInt(btn.CommandArgument)
        DeleteBantingImage(imejId)
        BindLokasiList()
        ShowAlert("success", "", "Imej banting berjaya dipadam.")
    End Sub

    Protected Sub btnQrCodeBanting_Click(sender As Object, e As EventArgs)
        If FormView1.CurrentMode <> FormViewMode.Edit Then Exit Sub

        Dim btn As LinkButton = DirectCast(sender, LinkButton)
        Dim uniqueId As String = btn.CommandArgument
        If Not String.IsNullOrWhiteSpace(uniqueId) Then
            DisplayBantingQRModal(uniqueId)
        End If
    End Sub

    Private Sub DisplayBantingQRModal(uniqueId As String)
        Dim baseUrl As String = Request.Url.Scheme & "://" & Request.Url.Authority & Request.ApplicationPath.TrimEnd("/"c)
        Dim fullUrl As String = baseUrl & "/lesen/sepandukSemakanIK.aspx?scancode=" & Server.UrlEncode(uniqueId)

        Using qrGenerator As New QRCodeGenerator()
            Dim qrCodeData As QRCodeData = qrGenerator.CreateQrCode(fullUrl, QRCodeGenerator.ECCLevel.Q)
            Using qrCode As New PngByteQRCode(qrCodeData)
                Dim qrBytes As Byte() = qrCode.GetGraphic(20)
                imgBantingModalQr.ImageUrl = "data:image/png;base64," & Convert.ToBase64String(qrBytes)
                imgBantingModalQr.Visible = True
            End Using
        End Using

        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "showBantingQrModal", "$('#modalBantingQrCode').modal('show');", True)
    End Sub

    Private Function GenerateBantingUniqueID() As String
        Dim uid As String = ""
        Dim isUnique As Boolean = False
        Dim attempts As Integer = 0

        While Not isUnique AndAlso attempts < 10
            attempts += 1
            Dim randomCode As String = Guid.NewGuid().ToString("N").Substring(0, 6).ToUpper()
            uid = "BTG-" & DateTime.Now.ToString("yyyyMMdd") & "-" & randomCode

            Using conn As New SqlConnection(CS)
                conn.Open()
                Using cmd As New SqlCommand("SELECT COUNT(*) FROM LESEN_BantingImej WHERE UniqueID = @UniqueID", conn)
                    cmd.Parameters.AddWithValue("@UniqueID", uid)
                    Dim cnt As Integer = CInt(cmd.ExecuteScalar())
                    If cnt = 0 Then
                        isUnique = True
                    End If
                End Using
            End Using
        End While

        Return uid
    End Function

    Private Sub DeleteBantingImage(imejId As Integer)
        Dim filePath As String = ""
        Using conn As New SqlConnection(CS)
            conn.Open()
            Using cmd As New SqlCommand("SELECT FilePath FROM LESEN_BantingImej WHERE Imej_ID = @Imej_ID", conn)
                cmd.Parameters.AddWithValue("@Imej_ID", imejId)
                Dim objPath As Object = cmd.ExecuteScalar()
                If objPath IsNot Nothing AndAlso Not IsDBNull(objPath) Then
                    filePath = objPath.ToString()
                End If
            End Using

            Using cmd As New SqlCommand("DELETE FROM LESEN_BantingImej WHERE Imej_ID = @Imej_ID", conn)
                cmd.Parameters.AddWithValue("@Imej_ID", imejId)
                cmd.ExecuteNonQuery()
            End Using
        End Using

        If Not String.IsNullOrWhiteSpace(filePath) Then
            Try
                Dim fullPath As String = Server.MapPath(filePath)
                If File.Exists(fullPath) Then
                    File.Delete(fullPath)
                End If
            Catch ex As Exception
            End Try
        End If
    End Sub

    Private Sub DeleteLokasiFiles(lokasiId As Integer)
        Dim filePaths As New List(Of String)()
        Using conn As New SqlConnection(CS)
            conn.Open()
            Using cmd As New SqlCommand("SELECT FilePath FROM LESEN_BantingImej WHERE Lokasi_ID = @Lokasi_ID", conn)
                cmd.Parameters.AddWithValue("@Lokasi_ID", lokasiId)
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        If Not IsDBNull(reader("FilePath")) Then
                            filePaths.Add(reader("FilePath").ToString())
                        End If
                    End While
                End Using
            End Using
        End Using

        For Each fp As String In filePaths
            Try
                Dim fullPath As String = Server.MapPath(fp)
                If File.Exists(fullPath) Then
                    File.Delete(fullPath)
                End If
            Catch ex As Exception
            End Try
        Next
    End Sub

    Private Sub UpdateHF_LokasiList()
        Dim HF_LokasiList As HiddenField = DirectCast(FormView1.FindControl("HF_LokasiList"), HiddenField)
        If HF_LokasiList Is Nothing Then Exit Sub

        Dim permohonanId As Integer = GetCurrentPermohonanID()
        If permohonanId <= 0 Then Exit Sub

        Dim lokasiList As New List(Of String)()
        Using conn As New SqlConnection(CS)
            conn.Open()
            Dim sql As String = "SELECT Lokasi FROM LESEN_BantingLokasi WHERE Permohonan_ID = @Permohonan_ID ORDER BY Lokasi_ID ASC"

            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@Permohonan_ID", permohonanId)
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        If Not IsDBNull(reader("Lokasi")) Then
                            lokasiList.Add(reader("Lokasi").ToString().Trim())
                        End If
                    End While
                End Using
            End Using
        End Using

        HF_LokasiList.Value = String.Join("||", lokasiList)
    End Sub

    ' --- Iklan (_ins Pembetulan) ---
    Protected Sub btnAddIklan_ins_Click(sender As Object, e As EventArgs)
        If Not String.IsNullOrWhiteSpace(TB_SaizIklan1_ins.Text) AndAlso DDL_Iklan1_ins.SelectedValue <> "" AndAlso Not String.IsNullOrWhiteSpace(TB_UnitIklan1_ins.Text) Then
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
            newRow("Bercahaya") = DDL_Iklan1_ins.SelectedValue.ToString()
            newRow("Unit") = TB_UnitIklan1_ins.Text
            dt.Rows.Add(newRow)

            ViewState("IklanTable_ins") = dt
            gvIklanList_ins.DataSource = dt
            gvIklanList_ins.DataBind()

            updateIklanList_ins(newRow("SaizIklan").ToString(), newRow("Bercahaya").ToString(), newRow("Unit").ToString())

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
                updateIklanList_ins(row("SaizIklan").ToString(), row("Bercahaya").ToString(), row("Unit").ToString())
            Next
        End If
    End Sub

    Private Sub updateIklanList_ins(ByVal saizVal As String, ByVal cahayaVal As String, ByVal unitVal As String)
        If HF_SaizIklanList_ins.Value.ToString().Length = 0 Then
            HF_SaizIklanList_ins.Value = saizVal
        Else
            HF_SaizIklanList_ins.Value += "," + saizVal
        End If

        If HF_CahayaIklanList_ins.Value.ToString().Length = 0 Then
            HF_CahayaIklanList_ins.Value = cahayaVal
        Else
            HF_CahayaIklanList_ins.Value += "," + cahayaVal
        End If

        If HF_UnitIklanList_ins.Value.ToString().Length = 0 Then
            HF_UnitIklanList_ins.Value = unitVal
        Else
            HF_UnitIklanList_ins.Value += "," + unitVal
        End If
    End Sub

    ' --- Anjing (_ins Pembetulan) ---
    Protected Sub btnAddAnjing_ins_Click(sender As Object, e As EventArgs)
        If Not String.IsNullOrWhiteSpace(TB_Jantan1_ins.Text) AndAlso Not String.IsNullOrWhiteSpace(TB_Betina1_ins.Text) AndAlso
            Not String.IsNullOrWhiteSpace(TB_JantanMandul1_ins.Text) AndAlso Not String.IsNullOrWhiteSpace(TB_BetinaMandul1_ins.Text) AndAlso
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

            updateAnjingList_ins(newRow("Baka").ToString(), newRow("Jantan").ToString(), newRow("Betina").ToString(), newRow("JantanMandul").ToString(), newRow("BetinaMandul").ToString())

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
                updateAnjingList_ins(row("Baka").ToString(), row("Jantan").ToString(), row("Betina").ToString(), row("JantanMandul").ToString(), row("BetinaMandul").ToString())
            Next
        End If
    End Sub

    Private Sub updateAnjingList_ins(ByVal bakaVal As String, ByVal jantanVal As String, ByVal betinaVal As String, ByVal jMandulVal As String, ByVal bMandulVal As String)
        If HF_BakaAnjingList_ins.Value.ToString().Length = 0 Then
            HF_BakaAnjingList_ins.Value = bakaVal
        Else
            HF_BakaAnjingList_ins.Value += "," + bakaVal
        End If

        If HF_AnjingJantanList_ins.Value.ToString().Length = 0 Then
            HF_AnjingJantanList_ins.Value = jantanVal
        Else
            HF_AnjingJantanList_ins.Value += "," + jantanVal
        End If

        If HF_AnjingBetinaList_ins.Value.ToString().Length = 0 Then
            HF_AnjingBetinaList_ins.Value = betinaVal
        Else
            HF_AnjingBetinaList_ins.Value += "," + betinaVal
        End If

        If HF_AnjingJantanMandulList_ins.Value.ToString().Length = 0 Then
            HF_AnjingJantanMandulList_ins.Value = jMandulVal
        Else
            HF_AnjingJantanMandulList_ins.Value += "," + jMandulVal
        End If

        If HF_AnjingBetinaMandulList_ins.Value.ToString().Length = 0 Then
            HF_AnjingBetinaMandulList_ins.Value = bMandulVal
        Else
            HF_AnjingBetinaMandulList_ins.Value += "," + bMandulVal
        End If
    End Sub

    ' --- Lokasi (_ins Pembetulan) ---
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
            newRow("No") = (dt.Rows.Count + 1).ToString()
            newRow("Lokasi") = TB_LokasiBanting_ins.Text
            dt.Rows.Add(newRow)

            ViewState("LokasiTable_ins") = dt
            gvLokasiList_ins.DataSource = dt
            gvLokasiList_ins.DataBind()

            updateLokasiList_ins(newRow("Lokasi").ToString())
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
                updateLokasiList_ins(row("Lokasi").ToString())
            Next
        End If
    End Sub

    Private Sub updateLokasiList_ins(ByVal lokasiVal As String)
        If HF_LokasiList_ins.Value.ToString().Length = 0 Then
            HF_LokasiList_ins.Value = lokasiVal
        Else
            HF_LokasiList_ins.Value += "||" + lokasiVal
        End If
    End Sub

#End Region

#Region "Agency Workflow & Batch Actions"

    Private Sub insertJabatanAgensi(jid As String, pid As Integer)
        Dim listagensi As New List(Of Integer)()

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "SELECT JabatanAgensi_ID FROM LESEN_JenisLesenAgensi " &
                "WHERE ',' + @JenisLesen_ID + ',' LIKE '%,' + CAST(JenisLesen_ID AS VARCHAR) + ',%' " &
                "GROUP BY JabatanAgensi_ID;"

            Using myCommandSelect As New SqlCommand(SQL, myConnection)
                myCommandSelect.Parameters.AddWithValue("@JenisLesen_ID", jid)
                Using myReader As SqlDataReader = myCommandSelect.ExecuteReader()
                    While myReader.Read()
                        listagensi.Add(CInt(myReader.Item("JabatanAgensi_ID")))
                    End While
                End Using
            End Using

            Dim cb As CheckBox = DirectCast(FormView1.FindControl("CB_24h"), CheckBox)
            Dim ismandatory As Integer = If(cb IsNot Nothing AndAlso cb.Checked, 0, 1)

            For Each agensi In listagensi
                Dim SQL1 As String = "INSERT INTO LESEN_PermohonanAgensi(Permohonan_ID, JabatanAgensi_ID, IsMandatory) VALUES (@Permohonan_ID, @JabatanAgensi_ID, @IsMandatory)"
                Using myCommandSelect1 As New SqlCommand(SQL1, myConnection)
                    myCommandSelect1.Parameters.AddWithValue("@Permohonan_ID", pid)
                    myCommandSelect1.Parameters.AddWithValue("@JabatanAgensi_ID", agensi)
                    myCommandSelect1.Parameters.AddWithValue("@IsMandatory", ismandatory)
                    Try
                        myCommandSelect1.ExecuteNonQuery()
                    Catch ex As Exception
                    End Try
                End Using
            Next
        End Using
    End Sub

    Private Sub insertJabatanAgensiBatal(pid As Integer)
        Dim listagensi() As Integer = {3}

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim ismandatory As Integer = 1

            For Each agensi In listagensi
                Dim SQL1 As String = "INSERT INTO LESEN_PermohonanAgensiBatal(Permohonan_ID, JabatanAgensi_ID, IsMandatory) VALUES (@Permohonan_ID, @JabatanAgensi_ID, @IsMandatory)"
                Using myCommandSelect1 As New SqlCommand(SQL1, myConnection)
                    myCommandSelect1.Parameters.AddWithValue("@Permohonan_ID", pid)
                    myCommandSelect1.Parameters.AddWithValue("@JabatanAgensi_ID", agensi)
                    myCommandSelect1.Parameters.AddWithValue("@IsMandatory", ismandatory)
                    Try
                        myCommandSelect1.ExecuteNonQuery()
                    Catch ex As Exception
                    End Try
                End Using
            Next
        End Using
    End Sub

    Protected Sub cbman_CheckedChanged(sender As Object, e As EventArgs)
        Dim cb As CheckBox = DirectCast(sender, CheckBox)
        Dim row As GridViewRow = DirectCast(cb.NamingContainer, GridViewRow)
        Dim paId As String = DirectCast(row.FindControl("itemID"), Label).Text

        Using myConnection As New SqlConnection(CS)
            Dim SQL As String = "UPDATE LESEN_PermohonanAgensi SET IsMandatory = @IsMandatory WHERE PermohonanAgensi_ID = @PermohonanAgensi_ID"
            Using myCommand As New SqlCommand(SQL, myConnection)
                myCommand.Parameters.AddWithValue("@PermohonanAgensi_ID", paId)
                myCommand.Parameters.AddWithValue("@IsMandatory", If(cb.Checked, 1, 0))
                myConnection.Open()
                myCommand.ExecuteNonQuery()
            End Using
        End Using

        GridViewMaintenanceTemplate.DataBind()
        MessageBox("Berjaya Dikemaskini", Me)
    End Sub

    Protected Sub cbman_CheckedChanged2(sender As Object, e As EventArgs)
        Dim cb As CheckBox = DirectCast(sender, CheckBox)
        Dim row As GridViewRow = DirectCast(cb.NamingContainer, GridViewRow)
        Dim paId As String = DirectCast(row.FindControl("itemID"), Label).Text

        Using myConnection As New SqlConnection(CS)
            Dim SQL As String = "UPDATE LESEN_PermohonanAgensiBatal SET IsMandatory = @IsMandatory WHERE PermohonanAgensi_ID = @PermohonanAgensi_ID"
            Using myCommand As New SqlCommand(SQL, myConnection)
                myCommand.Parameters.AddWithValue("@PermohonanAgensi_ID", paId)
                myCommand.Parameters.AddWithValue("@IsMandatory", If(cb.Checked, 1, 0))
                myConnection.Open()
                myCommand.ExecuteNonQuery()
            End Using
        End Using

        GridViewMaintenanceTemplate.DataBind()
        MessageBox("Berjaya Dikemaskini", Me)
    End Sub

    Private Sub GridViewMaintenanceTemplate_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles GridViewMaintenanceTemplate.RowCommand
        Dim intRow As Integer = CInt(e.CommandArgument)
        Dim PermohonanAgensi_ID As String = CStr(Me.GridViewMaintenanceTemplate.DataKeys(intRow)("PermohonanAgensi_ID"))
        Dim JenisLesenID As String = CStr(Me.GridViewMaintenanceTemplate.DataKeys(intRow)("JenisLesenIdList"))
        Dim JabatanAgensi_ID As Integer = CInt(Me.GridViewMaintenanceTemplate.DataKeys(intRow)("JabatanAgensi_ID"))

        If e.CommandName = "Surat" Then
            ViewSuratMohonAuto(PermohonanAgensi_ID, JabatanAgensi_ID, JenisLesenID, False)

        ElseIf e.CommandName = "review" Then
            Using myConnection As New SqlConnection(CS)
                Dim SQL As String = "UPDATE LESEN_PermohonanAgensi SET reviewStatusID = 1, kbID=NULL, kjID=NULL, kjReview='', kbReview='', " &
                    "kbApproval=NULL, kjApproval=NULL " &
                    "WHERE PermohonanAgensi_ID = @PermohonanAgensi_ID"
                Using myCommand As New SqlCommand(SQL, myConnection)
                    myCommand.Parameters.AddWithValue("@PermohonanAgensi_ID", PermohonanAgensi_ID)
                    myConnection.Open()
                    myCommand.ExecuteNonQuery()
                End Using
            End Using

            GridViewMaintenanceTemplate.DataBind()
            MessageBox("Berjaya dihantar untuk semakan surat", Me)
        End If
    End Sub

    Private Sub GridViewJabatanAgensiBatal_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles GridViewJabatanAgensiBatal.RowCommand
        Dim intRow As Integer = CInt(e.CommandArgument)
        Dim PermohonanAgensi_ID As String = CStr(Me.GridViewJabatanAgensiBatal.DataKeys(intRow)("PermohonanAgensi_ID"))
        Dim JenisLesenIdList As Integer = CInt(Me.GridViewJabatanAgensiBatal.DataKeys(intRow)("JenisLesenIdList"))
        Dim JabatanAgensi_ID As Integer = CInt(Me.GridViewJabatanAgensiBatal.DataKeys(intRow)("JabatanAgensi_ID"))

        If e.CommandName = "Surat" Then
            ViewSuratMohonAuto(PermohonanAgensi_ID, JabatanAgensi_ID, JenisLesenIdList.ToString(), True)

        ElseIf e.CommandName = "review" Then
            Using myConnection As New SqlConnection(CS)
                Dim SQL As String = "UPDATE LESEN_PermohonanAgensiBatal SET reviewStatusID = 1, kbID=NULL, kjID=NULL, kjReview='', kbReview='', " &
                    "kbApproval=NULL, kjApproval=NULL " &
                    "WHERE PermohonanAgensi_ID = @PermohonanAgensi_ID"
                Using myCommand As New SqlCommand(SQL, myConnection)
                    myCommand.Parameters.AddWithValue("@PermohonanAgensi_ID", PermohonanAgensi_ID)
                    myConnection.Open()
                    myCommand.ExecuteNonQuery()
                End Using
            End Using

            GridViewJabatanAgensiBatal.DataBind()
            MessageBox("Berjaya dihantar untuk semakan surat", Me)
        End If
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

    Private Sub SqlDataSourceFormviewMaintenanceTemplate_Inserted(sender As Object, e As SqlDataSourceStatusEventArgs) Handles SqlDataSourceFormviewMaintenanceTemplate.Inserted
    End Sub

    Private Sub FormViewMaintenanceTemplate_ItemInserted(sender As Object, e As FormViewInsertedEventArgs) Handles FormViewMaintenanceTemplate.ItemInserted
        GridView1.DataBind()
        GridViewMaintenanceTemplate.DataBind()
        TabContainer1.Visible = True
        ShowAlert("success", "", "Rekod berjaya disimpan!")
        FormViewMaintenanceTemplate.DataBind()
    End Sub

    Private Sub FormViewMaintenanceTemplate_ItemUpdated(sender As Object, e As FormViewUpdatedEventArgs) Handles FormViewMaintenanceTemplate.ItemUpdated
    End Sub

    Private Sub FormViewMaintenanceTemplate_ItemInserting(sender As Object, e As FormViewInsertEventArgs) Handles FormViewMaintenanceTemplate.ItemInserting
    End Sub

    Private Sub FormViewMaintenanceTemplate_DataBound(sender As Object, e As EventArgs) Handles FormViewMaintenanceTemplate.DataBound
    End Sub

#End Region

#Region "Report & Letter Generation"

    Protected Sub OnClickBtnSubmit(ByVal sender As Object, ByVal e As CommandEventArgs)
        Dim counter As Integer = 0
        Dim extstr As String = ""
        Dim hfid As HiddenField = DirectCast(FormView1.FindControl("HF_PermohonanID"), HiddenField)
        Dim ddl As HiddenField = DirectCast(FormView1.FindControl("HF_JenisLesenIdList"), HiddenField)
        Dim cb As CheckBox = DirectCast(FormView1.FindControl("CB_IsBatal"), CheckBox)

        If reviewSurat(cb.Checked) Then
            If cb.Checked Then
                extstr = "Batal"
            End If

            Using myConnection As New SqlConnection(CS)
                myConnection.Open()

                Dim Sql1 As String = "SELECT COUNT(PermohonanAgensi_ID) FROM LESEN_PermohonanAgensi" & extstr & " WHERE Permohonan_ID = @PermohonanID"
                Using myCommand1 As New SqlCommand(Sql1, myConnection)
                    myCommand1.Parameters.AddWithValue("@PermohonanID", hfid.Value)
                    counter = Convert.ToInt32(myCommand1.ExecuteScalar())
                End Using

                If counter < 1 AndAlso Not cb.Checked AndAlso ddl.Value <> "9" AndAlso ddl.Value <> "27" Then
                    ShowAlert("error", "", "Gagal hantar. Sila tambah jabatan agensi")
                    Return
                End If

                Dim result2 As Boolean = insertMaklumatPembetulan(CInt(hfid.Value))
                If Not result2 Then
                    ShowAlert("error", "", "Gagal proses database. Sila tekan Hantar sekali lagi." & hfid.Value)
                    Return
                End If

                Dim Sql As String = "UPDATE LESEN_Permohonan SET StatusID = 1 WHERE StatusID = 0 AND Permohonan_ID = @PermohonanID"
                If ddl.Value = "27" Then
                    Sql = "UPDATE LESEN_Permohonan SET StatusID = 10 WHERE StatusID = 0 AND Permohonan_ID = @PermohonanID"
                End If

                Dim result As Integer
                Using myCommand As New SqlCommand(Sql, myConnection)
                    myCommand.Parameters.AddWithValue("@PermohonanID", hfid.Value)
                    result = myCommand.ExecuteNonQuery()
                End Using

                If result < 1 Then
                    ShowAlert("error", "", "Gagal hantar")
                Else
                    ShowAlert("success", "", "Berjaya hantar")
                    GridView1.DataBind()
                    backToList()
                End If
            End Using
        Else
            ShowAlert("error", "", "Surat belum dihantar untuk semakan.")
            TabContainer1.ActiveTabIndex = 5
        End If
    End Sub

    Protected Sub OnClickSuratKelulusanPembatalan(ByVal sender As Object, ByVal e As CommandEventArgs)
        Dim Permohonan_ID As HiddenField = DirectCast(FormView1.FindControl("HF_PermohonanID"), HiddenField)
        Dim cb As CheckBox = DirectCast(FormView1.FindControl("CB_IsBatal"), CheckBox)

        Dim isChecked As Boolean = (cb IsNot Nothing AndAlso cb.Checked)

        If isChecked Then
            If GetIsSuratFailPembatalan(CInt(Permohonan_ID.Value)) Then
                ViewSuratPembatalanFail(Permohonan_ID.Value)
            Else
                ViewSuratPembatalanAuto(Permohonan_ID.Value, True)
            End If
        Else
            If GetIsSuratFailKelulusan(CInt(Permohonan_ID.Value)) Then
                ViewSuratKelulusanFail(Permohonan_ID.Value)
            Else
                ViewSuratKelulusanAuto(Permohonan_ID.Value, True)
            End If
        End If
    End Sub

    Private Function GetIsSuratFailKelulusan(pid As Integer) As Boolean
        Dim isFail As Boolean = False

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "SELECT CASE WHEN EXISTS (SELECT 1 FROM LESEN_PermohonanFail WHERE " &
            "PermohonanFail_PermohonanID = @Permohonan_ID AND PermohonanFail_JenisLampiran = 'SK') THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS DataExists"
            Using myCommandSelect As New SqlCommand(SQL, myConnection)
                myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)
                Using myReader As SqlDataReader = myCommandSelect.ExecuteReader()
                    If myReader.Read() Then
                        isFail = CBool(myReader.Item(0))
                    End If
                End Using
            End Using
        End Using

        Return isFail
    End Function

    Private Sub ViewSuratKelulusanFail(permohonanID As String)
        Dim filepath As String = ""

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "SELECT PermohonanFail_FilePath FROM LESEN_PermohonanFail WHERE PermohonanFail_PermohonanID = @permohonanID AND PermohonanFail_JenisLampiran = 'SK'"
            Using myCommandSelect As New SqlCommand(SQL, myConnection)
                myCommandSelect.Parameters.AddWithValue("@permohonanID", permohonanID)
                Using myReader As SqlDataReader = myCommandSelect.ExecuteReader()
                    If myReader.Read() Then
                        filepath = myReader.Item("PermohonanFail_FilePath").ToString()
                        filepath = filepath.Remove(0, 1)
                        ScriptManager.RegisterClientScriptBlock(Me.Page, Me.GetType(), "", "window.open('.." & filepath & "', '_blank', '');", True)
                    End If
                End Using
            End Using
        End Using
    End Sub

    Private Sub ViewSuratKelulusanAuto(permohonanID As String, isPDF As Boolean)
        Dim totalid As Integer = 0

        ' Check if lampiran larangan merokok is needed
        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim sql1 As String = "SELECT COUNT(PSID) AS TotalID FROM LESEN_PermohonanSurat WHERE Permohonan_ID = @permohonanID " &
                "AND JenisReport LIKE 'SK%' AND IsiKandungan like '%merokok%' "
            Using myCommandSelect As New SqlCommand(sql1, myConnection)
                myCommandSelect.Parameters.AddWithValue("@permohonanID", permohonanID)
                Using myReader As SqlDataReader = myCommandSelect.ExecuteReader()
                    If myReader.Read() Then
                        totalid = CInt(myReader.Item("TotalID"))
                    End If
                End Using
            End Using
        End Using

        Try
            Dim sql As String = "SELECT a.Permohonan_ID, a.TarikhSuratKelulusan, a.CreatedDt, CAST(a.NamaSyarikat AS varchar(200)) AS NamaSyarikat, " &
                "a.NoPendaftaran, a.NoAkaun, a.AlamatPremis, a.JenisPerniagaan, a.PemilikBaru, a.AlamatBaru, " &
                "a.JenisPerniagaanBaru, a.NamaBaruSyarikat, a.BillboardLokasi, a.LokasiPasar1, a.LokasiPasar2, " &
                "a.LokasiPasar3, a.JenisPasar, a.JenisPerniagaanPasar, a.JumlahPetak, a.AnjingAlamat, a.AnjingJenisMohon, " &
                "a.AnjingJenisPremis, a.AlamatPenjajaan, a.JenisPerniagaanPenjaja, a.TarikhBatal, a.PenganjurEkspo, " &
                "a.NamaEkspo, a.LokasiEkspo, a.NoTelEkspo, a.TarikhEkspo1, a.TarikhEkspo2, a.MasaEkspo1, a.MasaEkspo2, " &
                "a.Rujukan, a.NoAkaunCukai, a.IsBatal, a.JenisLesenDescList, a.JenisLesenIdList, a.SaizIklanList, " &
                "a.CahayaIklanList, a.UnitIklanList, a.BakaAnjingList, a.AnjingJantanList, a.AnjingBetinaList, " &
                "a.AnjingJantanMandulList, a.AnjingBetinaMandulList, " &
                "b.Pemohon_Name, b.Pemohon_Address, b.Pemohon_ICNo, b.Pemohon_MobileNo, b.Pemohon_TelNo, " &
                "c.Users_Fullname, c.Users_Signature, d.P1, d.P2, d.P3, d.IsiKandungan " &
                "FROM LESEN_Permohonan a " &
                "INNER JOIN LESEN_Pemohon b ON b.Pemohon_ID=a.Permohonan_PemohonID " &
                "LEFT JOIN TBL_USERS c ON a.TandatanganKelulusanId=c.Users_Id " &
                "LEFT JOIN LESEN_PermohonanSurat d ON d.Permohonan_ID=a.Permohonan_ID AND d.JenisReport LIKE 'SK%' " &
                "WHERE a.Permohonan_ID=@permohonanID AND a.IsPublish=1 ORDER BY d.P1, d.P2, d.P3"

            sql = sql.Replace("@permohonanID", permohonanID)

            Dim ReportVar As String = "suratkelulusan_v2"
            Dim pobjData(1, 1) As Object
            Dim lStrReportName As String = ReportVar & ".rpt"

            pobjData(0, 0) = "paraSQL" : pobjData(0, 1) = sql
            pobjData(1, 0) = "isDigitalSign" : pobjData(1, 1) = isPDF

            Session.Item("ReportName" & ReportVar) = lStrReportName
            Session.Item("pobjData" & ReportVar) = pobjData
            Session.Item("pathUrl" & ReportVar) = "~/lesen/report/kelulusan"

            If isPDF Then
                Session.Item("reportPrintType") = "pdf"
            End If

            Dim reportUrl As String = ResolveUrl("~/ReportViewer.aspx?name=" & ReportVar)
            If totalid > 0 Then
                reportUrl = ResolveUrl("~/ReportViewer1.aspx?name=" & ReportVar)
            End If

            ScriptManager.RegisterClientScriptBlock(Me.Page, Me.GetType(), ReportVar, "window.open('" & reportUrl & "', '_blank', '');", True)
        Catch ex As Exception
            MessageBox(ex.Message, Me.Page)
        End Try
    End Sub

    Private Function GetIsSuratFailPembatalan(pid As Integer) As Boolean
        Dim isFail As Boolean = False

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "SELECT CASE WHEN EXISTS (SELECT 1 FROM LESEN_PermohonanFail WHERE " &
            "PermohonanFail_PermohonanID = @Permohonan_ID AND PermohonanFail_JenisLampiran = 'SB') THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS DataExists"
            Using myCommandSelect As New SqlCommand(SQL, myConnection)
                myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)
                Using myReader As SqlDataReader = myCommandSelect.ExecuteReader()
                    If myReader.Read() Then
                        isFail = CBool(myReader.Item(0))
                    End If
                End Using
            End Using
        End Using

        Return isFail
    End Function

    Private Sub ViewSuratPembatalanFail(permohonanID As String)
        Dim filepath As String = ""

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "SELECT PermohonanFail_FilePath FROM LESEN_PermohonanFail WHERE PermohonanFail_PermohonanID = @permohonanID AND PermohonanFail_JenisLampiran = 'SB'"
            Using myCommandSelect As New SqlCommand(SQL, myConnection)
                myCommandSelect.Parameters.AddWithValue("@permohonanID", permohonanID)
                Using myReader As SqlDataReader = myCommandSelect.ExecuteReader()
                    If myReader.Read() Then
                        filepath = myReader.Item("PermohonanFail_FilePath").ToString()
                        filepath = filepath.Remove(0, 1)
                        ScriptManager.RegisterClientScriptBlock(Me.Page, Me.GetType(), "", "window.open('.." & filepath & "', '_blank', '');", True)
                    End If
                End Using
            End Using
        End Using
    End Sub

    Private Sub ViewSuratPembatalanAuto(permohonanID As String, isPDF As Boolean)
        Try
            Dim sql As String = "SELECT a.Permohonan_ID, a.TarikhSuratKelulusan, a.CreatedDt, CAST(a.NamaSyarikat AS varchar(200)) AS NamaSyarikat, " &
                "a.NoPendaftaran, a.NoAkaun, a.AlamatPremis, a.JenisPerniagaan, a.PemilikBaru, a.AlamatBaru, " &
                "a.JenisPerniagaanBaru, a.NamaBaruSyarikat, a.BillboardLokasi, a.LokasiPasar1, a.LokasiPasar2, " &
                "a.LokasiPasar3, a.JenisPasar, a.JenisPerniagaanPasar, a.JumlahPetak, a.AnjingAlamat, a.AnjingJenisMohon, " &
                "a.AnjingJenisPremis, a.AlamatPenjajaan, a.JenisPerniagaanPenjaja, a.TarikhBatal, a.PenganjurEkspo, " &
                "a.NamaEkspo, a.LokasiEkspo, a.NoTelEkspo, a.TarikhEkspo1, a.TarikhEkspo2, a.MasaEkspo1, a.MasaEkspo2, " &
                "a.Rujukan, a.NoAkaunCukai, a.IsBatal, a.JenisLesenDescList, a.JenisLesenIdList, a.SaizIklanList, " &
                "a.CahayaIklanList, a.UnitIklanList, a.BakaAnjingList, a.AnjingJantanList, a.AnjingBetinaList, " &
                "a.AnjingJantanMandulList, a.AnjingBetinaMandulList, " &
                "b.Pemohon_Name, b.Pemohon_Address, b.Pemohon_ICNo, b.Pemohon_MobileNo, b.Pemohon_TelNo, " &
                "c.Users_Fullname, c.Users_Signature, d.P1, d.P2, d.P3, d.IsiKandungan " &
                "FROM LESEN_Permohonan a " &
                "INNER JOIN LESEN_Pemohon b ON b.Pemohon_ID=a.Permohonan_PemohonID " &
                "LEFT JOIN TBL_USERS c ON a.TandatanganKelulusanId=c.Users_Id " &
                "LEFT JOIN LESEN_PermohonanSurat d ON d.Permohonan_ID=a.Permohonan_ID AND d.JenisReport LIKE 'SB%' " &
                "WHERE a.Permohonan_ID=@permohonanID AND a.IsPublish=1 ORDER BY d.P1, d.P2, d.P3"

            sql = sql.Replace("@permohonanID", permohonanID)

            Dim ReportVar As String = "suratkelulusan_v2"
            Dim pobjData(1, 1) As Object
            Dim lStrReportName As String = ReportVar & ".rpt"

            pobjData(0, 0) = "paraSQL" : pobjData(0, 1) = sql
            pobjData(1, 0) = "isDigitalSign" : pobjData(1, 1) = isPDF

            Session.Item("ReportName" & ReportVar) = lStrReportName
            Session.Item("pobjData" & ReportVar) = pobjData
            Session.Item("pathUrl" & ReportVar) = "~/lesen/report/kelulusan"

            If isPDF Then
                Session.Item("reportPrintType") = "pdf"
            End If

            Dim reportUrl As String = ResolveUrl("~/ReportViewer.aspx?name=" & ReportVar)

            ScriptManager.RegisterClientScriptBlock(Me.Page, Me.GetType(), ReportVar, "window.open('" & reportUrl & "', '_blank', '');", True)
        Catch ex As Exception
            MessageBox(ex.Message, Me.Page)
        End Try
    End Sub

    Private Sub ViewSuratMohonFail(permohonanID As String)
        Dim filepath As String = ""

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "SELECT PermohonanFail_FilePath FROM LESEN_PermohonanFail WHERE PermohonanFail_PermohonanID = @permohonanID AND PermohonanFail_JenisLampiran = 'SM'"
            Using myCommandSelect As New SqlCommand(SQL, myConnection)
                myCommandSelect.Parameters.AddWithValue("@permohonanID", permohonanID)
                Using myReader As SqlDataReader = myCommandSelect.ExecuteReader()
                    If myReader.Read() Then
                        filepath = myReader.Item("PermohonanFail_FilePath").ToString()
                        filepath = filepath.Remove(0, 1)
                        ScriptManager.RegisterClientScriptBlock(Me.Page, Me.GetType(), "", "window.open('.." & filepath & "', '_blank', '');", True)
                    End If
                End Using
            End Using
        End Using
    End Sub

    Private Sub ViewSuratMohonAuto(permohonanAgensiID As String, jabatanAgensiID As Integer, jenislesenIdList As String, isBatal As Boolean)
        Dim strBatal As String = If(isBatal, "Batal", "")
        Dim sql As String = ""
        Dim jenisLesenDesc = {"mpk_suratmohonulasan", "mpk_suratmohonulasan_psr", "mpk_suratmohonulasan_anj", "mpk_suratmohonulasan_pjj", "mpk_suratmohonulasan_bb", "mpk_suratmohonulasan_ep"}
        Dim jenisLesenDescLuar = {"mpk_suratmohonulasan_l", "mpk_suratmohonulasan_psr_l", "mpk_suratmohonulasan_anj_l", "mpk_suratmohonulasan_pjj_l", "mpk_suratmohonulasan_bb_l", "mpk_suratmohonulasan_ep_l"}

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
                Case "15"
                    ReportVar = jenisLesenDesc(5)
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
                    Case "15"
                        ReportVar = jenisLesenDescLuar(5)
                End Select
            End If

            Dim pobjData(0, 1) As Object
            Dim lStrReportName As String = ReportVar & ".rpt"

            pobjData(0, 0) = "paraSQL" : pobjData(0, 1) = sql

            Session.Item("ReportName" & ReportVar) = lStrReportName
            Session.Item("pobjData" & ReportVar) = pobjData
            Session.Item("pathUrl" & ReportVar) = "~/lesen/report/mohonulasan"
            Session.Item("reportPrintType") = "pdf"

            ScriptManager.RegisterClientScriptBlock(Me.Page, Me.GetType(), ReportVar, "window.open('../ReportViewer.aspx?name=" & ReportVar & "', '_blank', '');", True)
        Catch ex As Exception
            MessageBox(ex.Message, Me)
        End Try
    End Sub

    Protected Sub BT_ViewLaporan_Command(sender As Object, e As CommandEventArgs)
        Dim jid As Integer = CInt(GridView1.SelectedDataKey.Values(3))
        Dim pid As Integer = CInt(GridView1.SelectedDataKey.Values(0))

        If GetIsSuratFail(pid) Then
            ViewSuratPemeriksaanFail(pid.ToString())
        Else
            ViewSuratPemeriksaanAuto(pid.ToString(), jid, True)
        End If
    End Sub

    Private Function GetIsSuratFail(pid As Integer) As Boolean
        Dim isFail As Boolean

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "SELECT IsSuratPemeriksaanFail FROM LESEN_Permohonan WHERE Permohonan_ID = @Permohonan_ID"
            Using myCommandSelect As New SqlCommand(SQL, myConnection)
                myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)
                Using myReader As SqlDataReader = myCommandSelect.ExecuteReader()
                    If myReader.Read() Then
                        isFail = CBool(myReader.Item("IsSuratPemeriksaanFail"))
                    End If
                End Using
            End Using
        End Using

        Return isFail
    End Function

    Private Sub ViewSuratPemeriksaanFail(permohonanID As String)
        Dim filepath As String = ""

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "SELECT PermohonanFail_FilePath FROM LESEN_PermohonanFail WHERE PermohonanFail_PermohonanID = @permohonanID AND PermohonanFail_JenisLampiran = 'SP'"
            Using myCommandSelect As New SqlCommand(SQL, myConnection)
                myCommandSelect.Parameters.AddWithValue("@permohonanID", permohonanID)
                Using myReader As SqlDataReader = myCommandSelect.ExecuteReader()
                    If myReader.Read() Then
                        filepath = myReader.Item("PermohonanFail_FilePath").ToString()
                        filepath = filepath.Remove(0, 1)
                        ScriptManager.RegisterClientScriptBlock(Me.Page, Me.GetType(), "", "window.open('.." & filepath & "', '_blank', '');", True)
                    End If
                End Using
            End Using
        End Using
    End Sub

    Private Sub ViewSuratPemeriksaanAuto(permohonanID As String, jenislesenID As Integer, isPDF As Boolean)
        Dim sql As String = ""
        Dim jenisLesenDesc = {"mpk_suratpemeriksaan"}

        Try
            sql = "SELECT a.Permohonan_ID, a.TarikhPemeriksaan, CAST(a.TarikhSuratPemeriksaan AS datetime) AS TarikhSuratPemeriksaan, " &
                "CAST(a.NamaSyarikat AS varchar(200)) AS NamaSyarikat, " &
                "f.NoPendaftaran, f.NoAkaun, f.AlamatPremis, f.JenisPerniagaan, f.PemilikBaru, f.AlamatBaru, " &
                "f.JenisPerniagaanBaru, f.NamaBaruSyarikat, f.BillboardLokasi, f.LokasiPasar1, f.LokasiPasar2, " &
                "f.LokasiPasar3, f.JenisPasar, f.JenisPerniagaanPasar, f.JumlahPetak, f.AnjingAlamat, e.name AS AnjingJenisPremisDesc, " &
                "f.AnjingJenisPremis, f.AlamatPenjajaan, f.JenisPerniagaanPenjaja, f.TarikhBatal, f.PenganjurEkspo, " &
                "f.NamaEkspo, f.LokasiEkspo, f.NoTelEkspo, f.TarikhEkspo1, f.TarikhEkspo2, f.MasaEkspo1, f.MasaEkspo2, " &
                "f.KontraktorIklan, f.NoTelKontraktor, f.UkuranBanting, f.BilBanting, f.TarikhBanting1, f.TarikhBanting2, f.NoResitBanting, f.NoSiriStiker, f.TarikhBanting3, " &
                "a.Rujukan, a.RujukanInspektorat, a.NoAkaunCukai, a.IsBatal, a.JenisLesenDescList, a.JenisLesenIdList, f.SaizIklanList, " &
                "f.CahayaIklanList, f.UnitIklanList, f.LokasiList, f.BakaAnjingList, f.AnjingJantanList, f.AnjingBetinaList, " &
                "f.AnjingJantanMandulList, f.AnjingBetinaMandulList, " &
                "b.Pemohon_Name, b.Pemohon_Address, b.Pemohon_ICNo, b.Pemohon_MobileNo, b.Pemohon_TelNo, " &
                "c.Users_Fullname, c.Users_Signature, d.P1, d.P2, d.P3, d.IsiKandungan " &
                "FROM LESEN_Permohonan a " &
                "INNER JOIN LESEN_PermohonanPembetulan f ON a.Permohonan_ID = f.Permohonan_ID " &
                "INNER JOIN LESEN_Pemohon b ON b.Pemohon_ID=a.Permohonan_PemohonID " &
                "LEFT JOIN TBL_USERS c ON a.TandatanganPemeriksaanId=c.Users_Id " &
                "LEFT JOIN LESEN_PermohonanSurat d ON d.Permohonan_ID=a.Permohonan_ID AND d.JenisReport LIKE 'LI%' " &
                "LEFT JOIN TBL_LOOKUPS e ON e.id = a.AnjingJenisPremis " &
                "WHERE a.Permohonan_ID=@permohonanID ORDER BY d.P1, d.P2, d.P3"

            sql = sql.Replace("@permohonanID", permohonanID)

            Dim ReportVar As String = jenisLesenDesc(0)
            Dim pobjData(0, 1) As Object
            Dim lStrReportName As String = ReportVar & ".rpt"

            pobjData(0, 0) = "paraSQL" : pobjData(0, 1) = sql

            Session.Item("ReportName" & ReportVar) = lStrReportName
            Session.Item("pobjData" & ReportVar) = pobjData
            Session.Item("pathUrl" & ReportVar) = "~/lesen/report/pemeriksaan"

            If isPDF Then
                Session.Item("reportPrintType") = "pdf"
            End If

            ScriptManager.RegisterClientScriptBlock(Me.Page, Me.GetType(), ReportVar, "window.open('../ReportViewer.aspx?name=" & ReportVar & "', '_blank', '');", True)
        Catch ex As Exception
            MessageBox(ex.Message, Me)
        End Try
    End Sub

    Private Function reviewSurat(checked As Boolean) As Boolean
        Dim retval As Boolean = True
        Dim hfid As HiddenField = DirectCast(FormView1.FindControl("HF_PermohonanID"), HiddenField)

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = ""
            If checked Then
                SQL = "select * from LESEN_PermohonanAgensiBatal where Permohonan_ID = @Permohonan_ID and isnull(reviewStatusID,0) IN (0,3) "
            Else
                SQL = "select * from LESEN_PermohonanAgensi where Permohonan_ID = @Permohonan_ID and isnull(reviewStatusID,0) IN (0,3) "
            End If

            Using myCommandSelect As New SqlCommand(SQL, myConnection)
                myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", CInt(hfid.Value))
                Using myReader As SqlDataReader = myCommandSelect.ExecuteReader()
                    If myReader.Read() Then
                        retval = False
                    End If
                End Using
            End Using
        End Using

        Return retval
    End Function

    Protected Sub btnSaveLetter_Click(sender As Object, e As EventArgs)
        Dim isSuccess As Boolean = True
        Dim PermohonanID As Integer = CInt(GridView1.SelectedDataKey.Values(0))

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "UPDATE LESEN_Permohonan SET TandatanganMohonUlasanId = @TandatanganMohonUlasanId, " &
                                "TandatanganMohonUlasanLuarId = @TandatanganMohonUlasanLuarId  " &
                                "WHERE Permohonan_ID = @Permohonan_ID"

            Using myCommandSelect As New SqlCommand(SQL, myConnection)
                myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", PermohonanID)
                myCommandSelect.Parameters.AddWithValue("@TandatanganMohonUlasanId", ddlTandatangan.SelectedValue)
                myCommandSelect.Parameters.AddWithValue("@TandatanganMohonUlasanLuarId", ddlTandatanganLuar.SelectedValue)
                Try
                    myCommandSelect.ExecuteNonQuery()
                Catch ex As Exception
                    isSuccess = False
                    MessageBox("ERROR", Me)
                End Try
            End Using
        End Using

        If isSuccess Then
            ShowAlert("success", "", "Surat mohon ulasan telah dikemaskini.")
        End If
    End Sub

#End Region

#Region "Tab Attachments (Public & MPK)"

    Protected Sub btnUpload_Click(sender As Object, e As EventArgs)
        ' Reserved for direct button upload handler if fired
    End Sub

    Protected Sub btnAddNewUpload_Click(sender As Object, e As EventArgs)
        Dim Permohonan_ID As Integer = CInt(GridView1.SelectedValue)

        Using myConnection As New SqlConnection(CS)
            Dim SQL As String = "INSERT INTO LESEN_PermohonanFail (PermohonanFail_PermohonanID,CreatedDt,CreatorID) VALUES " &
                                "(@Permohonan_ID, getdate(), @SessionUserName) "
            Using myCommand As New SqlCommand(SQL, myConnection)
                myCommand.Parameters.AddWithValue("@Permohonan_ID", Permohonan_ID)
                myCommand.Parameters.AddWithValue("@SessionUsersId", Session.Item("SessionUsersId"))
                myCommand.Parameters.AddWithValue("@SessionUserName", Session.Item("SessionUserName"))
                myConnection.Open()
                Dim recordset As Integer = myCommand.ExecuteNonQuery()
                If recordset > 0 Then
                    gvTabUlasan.EditIndex = CInt(gvTabUlasan.Rows.Count)
                End If
            End Using
        End Using

        gvTabUlasan.DataBind()
        Page.SetFocus(Me.ui_btnPageBottom.ClientID)
    End Sub

    Protected Sub btnAddNewUpload1_Click(sender As Object, e As EventArgs)
        Dim Permohonan_ID As Integer = CInt(GridView1.SelectedValue)

        Using myConnection As New SqlConnection(CS)
            Dim SQL As String = "INSERT INTO LESEN_PermohonanFail (PermohonanFail_PermohonanID,PermohonanFail_JenisLampiran,CreatedDt,CreatorID) VALUES " &
                                "(@Permohonan_ID, 'LA', getdate(), @SessionUserName) "
            Using myCommand As New SqlCommand(SQL, myConnection)
                myCommand.Parameters.AddWithValue("@Permohonan_ID", Permohonan_ID)
                myCommand.Parameters.AddWithValue("@SessionUsersId", Session.Item("SessionUsersId"))
                myCommand.Parameters.AddWithValue("@SessionUserName", Session.Item("SessionUserName"))
                myConnection.Open()
                Dim recordset As Integer = myCommand.ExecuteNonQuery()
                If recordset > 0 Then
                    gvTabPublicAttach.EditIndex = CInt(gvTabPublicAttach.Rows.Count)
                End If
            End Using
        End Using

        gvTabPublicAttach.DataBind()
        Page.SetFocus(Me.ui_btnPageBottom.ClientID)
    End Sub

    Private Sub gvTabPublicAttach_RowUpdated(sender As Object, e As GridViewUpdatedEventArgs) Handles gvTabPublicAttach.RowUpdated
    End Sub

    Private Sub gvTabPublicAttach_RowUpdating(sender As Object, e As GridViewUpdateEventArgs) Handles gvTabPublicAttach.RowUpdating
        Dim fu As FileUpload = CType(gvTabPublicAttach.Rows(e.RowIndex).FindControl("FU_PermohonanFail"), FileUpload)

        If fu Is Nothing OrElse Not fu.HasFiles Then
            Return
        End If

        Dim uid As Guid = Guid.NewGuid()
        Dim fn As String = System.IO.Path.GetFileName(fu.PostedFile.FileName)
        Dim localPath As String = "~/doc/" & uid.ToString() & fn
        Dim SaveLocation As String = Server.MapPath(localPath)

        If (fu.PostedFile IsNot Nothing) AndAlso (fu.PostedFile.ContentLength > 0) Then
            ' Delete previous file if replacing
            If e.OldValues("PermohonanFail_FilePath") IsNot Nothing AndAlso e.OldValues("PermohonanFail_FilePath").ToString() <> "" Then
                Dim deleteFilePath As String = Server.MapPath(e.OldValues("PermohonanFail_FilePath").ToString())
                If System.IO.File.Exists(deleteFilePath) Then
                    System.IO.File.Delete(deleteFilePath)
                End If
            End If

            If updateUploadFile(fu, SaveLocation) Then
                e.NewValues("PermohonanFail_FileName") = fu.PostedFile.FileName
                e.NewValues("PermohonanFail_ContentType") = fu.PostedFile.ContentType
                e.NewValues("PermohonanFail_FilePath") = localPath
            End If
        End If
    End Sub

    Private Sub gvTabUlasan_RowUpdated(sender As Object, e As GridViewUpdatedEventArgs) Handles gvTabUlasan.RowUpdated
    End Sub

    Private Sub gvTabUlasan_RowUpdating(sender As Object, e As GridViewUpdateEventArgs) Handles gvTabUlasan.RowUpdating
        Dim fu As FileUpload = CType(gvTabUlasan.Rows(e.RowIndex).FindControl("FU_PermohonanFail"), FileUpload)

        If fu Is Nothing OrElse Not fu.HasFiles Then
            Return
        End If

        Dim uid As Guid = Guid.NewGuid()
        Dim fn As String = System.IO.Path.GetFileName(fu.PostedFile.FileName)
        Dim localPath As String = "~/doc/" & uid.ToString() & fn
        Dim SaveLocation As String = Server.MapPath(localPath)

        If (fu.PostedFile IsNot Nothing) AndAlso (fu.PostedFile.ContentLength > 0) Then
            ' Delete previous file if replacing
            If e.OldValues("PermohonanFail_FilePath") IsNot Nothing AndAlso e.OldValues("PermohonanFail_FilePath").ToString() <> "" Then
                Dim deleteFilePath As String = Server.MapPath(e.OldValues("PermohonanFail_FilePath").ToString())
                If System.IO.File.Exists(deleteFilePath) Then
                    System.IO.File.Delete(deleteFilePath)
                End If
            End If

            If updateUploadFile(fu, SaveLocation) Then
                e.NewValues("PermohonanFail_FileName") = fu.PostedFile.FileName
                e.NewValues("PermohonanFail_ContentType") = fu.PostedFile.ContentType
                e.NewValues("PermohonanFail_FilePath") = localPath
            End If
        End If
    End Sub

    Private Function updateUploadFile(txtUlasanFail_FilePath As FileUpload, saveLocation As String) As Boolean
        Dim retval As Boolean = True

        If (txtUlasanFail_FilePath.PostedFile IsNot Nothing) AndAlso (txtUlasanFail_FilePath.PostedFile.ContentLength > 0) Then
            Try
                Dim fileExtention As String = txtUlasanFail_FilePath.PostedFile.ContentType
                Dim fileLenght As Integer = txtUlasanFail_FilePath.PostedFile.ContentLength

                If fileExtention = "image/png" OrElse fileExtention = "image/jpeg" OrElse fileExtention = "image/x-png" Then
                    If fileLenght <= MaxFileSizeInBytes Then
                        Dim bmpPostedImage As New Bitmap(txtUlasanFail_FilePath.PostedFile.InputStream)
                        Dim objImage As System.Drawing.Image = ScaleImage(bmpPostedImage, 1024)
                        objImage.Save(saveLocation, ImageFormat.Jpeg)
                    Else
                        MessageBox("Image size cannot be more than 5 MB!", Me)
                        retval = False
                    End If
                Else
                    If fileLenght <= MaxFileSizeInBytes Then
                        Try
                            txtUlasanFail_FilePath.PostedFile.SaveAs(saveLocation)
                        Catch ex As Exception
                            MessageBox(ex.Message, Me)
                        End Try
                    Else
                        MessageBox("Image size cannot be more than 5 MB!", Me)
                        retval = False
                    End If
                End If
            Catch ex As Exception
                MessageBox(ex.Message, Me)
                retval = False
            End Try
        Else
            MessageBox("Muat naik fail gagal. Sila cuba sekali lagi", Me)
            retval = False
        End If

        Return retval
    End Function

    Public Shared Function ScaleImage(ByVal image As System.Drawing.Image, ByVal maxHeight As Integer) As System.Drawing.Image
        Dim ratio As Double = CDbl(maxHeight) / image.Height
        Dim newWidth As Integer = CInt((image.Width * ratio))
        Dim newHeight As Integer = CInt((image.Height * ratio))
        Dim newImage As New Bitmap(newWidth, newHeight)

        Using g As Graphics = Graphics.FromImage(newImage)
            g.DrawImage(image, 0, 0, newWidth, newHeight)
        End Using

        Return newImage
    End Function

    Private Sub gvTabPublicAttach_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvTabPublicAttach.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim LinkButton1 As LinkButton = CType(e.Row.Cells(0).FindControl("LinkButton1"), LinkButton)
            If LinkButton1 IsNot Nothing Then
                Dim currPageScriptManager As ScriptManager = TryCast(ScriptManager.GetCurrent(Page), ScriptManager)
                If currPageScriptManager IsNot Nothing Then
                    currPageScriptManager.RegisterPostBackControl(LinkButton1)
                End If
            End If
        End If
    End Sub

    Private Sub gvTabPublicAttach_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvTabPublicAttach.RowDeleting
        If e.Values("PermohonanFail_FilePath") IsNot Nothing AndAlso e.Values("PermohonanFail_FilePath").ToString() <> "" Then
            Dim deleteFilePath As String = Server.MapPath(e.Values("PermohonanFail_FilePath").ToString())
            If System.IO.File.Exists(deleteFilePath) Then
                System.IO.File.Delete(deleteFilePath)
            End If
        End If
    End Sub

    Private Sub gvTabPublicAttach_DataBound(sender As Object, e As EventArgs) Handles gvTabPublicAttach.DataBound
    End Sub

    Private Sub gvTabUlasan_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvTabUlasan.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim LinkButton1 As LinkButton = CType(e.Row.Cells(0).FindControl("LinkButton1"), LinkButton)
            If LinkButton1 IsNot Nothing Then
                Dim currPageScriptManager As ScriptManager = TryCast(ScriptManager.GetCurrent(Page), ScriptManager)
                If currPageScriptManager IsNot Nothing Then
                    currPageScriptManager.RegisterPostBackControl(LinkButton1)
                End If
            End If
        End If
    End Sub

    Private Sub gvTabUlasan_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvTabUlasan.RowDeleting
        If e.Values("PermohonanFail_FilePath") IsNot Nothing AndAlso e.Values("PermohonanFail_FilePath").ToString() <> "" Then
            Dim deleteFilePath As String = Server.MapPath(e.Values("PermohonanFail_FilePath").ToString())
            If System.IO.File.Exists(deleteFilePath) Then
                System.IO.File.Delete(deleteFilePath)
            End If
        End If
    End Sub

    Private Sub gvTabUlasan_DataBound(sender As Object, e As EventArgs) Handles gvTabUlasan.DataBound
    End Sub

#End Region

#Region "Tab Mesyuarat, Pembetulan & Kadar Bayaran"

    Protected Sub BtnSaveMesyuarat_Click(sender As Object, e As EventArgs)
        Dim PermohonanID As Integer = CInt(GridView1.SelectedDataKey.Values(0))

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "UPDATE LESEN_Permohonan SET TarikhMesyuarat = @TarikhMesyuarat, " &
                                "NoMesyuarat = @NoMesyuarat, IsPulang = @IsPulang, TarikhPulang = @TarikhPulang " &
                                "WHERE Permohonan_ID = @Permohonan_ID"

            Using myCommandSelect As New SqlCommand(SQL, myConnection)
                myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", PermohonanID)
                myCommandSelect.Parameters.AddWithValue("@TarikhMesyuarat", TB_TarikhMesyuarat.Text)
                myCommandSelect.Parameters.AddWithValue("@NoMesyuarat", TB_NoMesyuarat.Text)
                myCommandSelect.Parameters.AddWithValue("@IsPulang", CB_IsPulang.Checked.ToString())
                myCommandSelect.Parameters.AddWithValue("@TarikhPulang", TB_TarikhPulang.Text)

                Try
                    myCommandSelect.ExecuteNonQuery()
                    ShowAlert("success", "", "Rekod mesyuarat telah dikemaskini.")
                Catch ex As Exception
                    MessageBox("ERROR", Me)
                End Try
            End Using
        End Using
    End Sub

    Private Sub GetMesyuarat(pid As Integer)
        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "SELECT TarikhMesyuarat, KeputusanMesyuarat, NoMesyuarat, IsPulang, TarikhPulang FROM LESEN_Permohonan WHERE Permohonan_ID = @Permohonan_ID"
            Using myCommandSelect As New SqlCommand(SQL, myConnection)
                myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)
                Using myReader As SqlDataReader = myCommandSelect.ExecuteReader()
                    If myReader.Read() Then
                        If Not IsDBNull(myReader.Item("TarikhMesyuarat")) Then
                            TB_TarikhMesyuarat.Text = CDate(myReader.Item("TarikhMesyuarat")).ToString("yyyy-MM-dd")
                        End If

                        TB_NoMesyuarat.Text = myReader.Item("NoMesyuarat").ToString()
                        CB_IsPulang.Checked = CBool(myReader.Item("IsPulang"))

                        If CB_IsPulang.Checked Then
                            pnlpulang.Visible = True
                        End If

                        If Not IsDBNull(myReader.Item("TarikhPulang")) Then
                            TB_TarikhPulang.Text = CDate(myReader.Item("TarikhPulang")).ToString("yyyy-MM-dd")
                        End If
                    End If
                End Using
            End Using
        End Using
    End Sub

    Protected Sub CB_IsPulang_CheckedChanged(sender As Object, e As EventArgs)
        If CB_IsPulang.Checked Then
            pnlpulang.Visible = True
        Else
            pnlpulang.Visible = False
        End If
    End Sub

    Private Function insertMaklumatPembetulan(Permohonan_ID As Integer) As Boolean
        Dim recordset As Integer = -1

        Using myConnection As New SqlConnection(CS)
            Dim SQL As String = "IF NOT EXISTS(Select Permohonan_ID from LESEN_PermohonanPembetulan where Permohonan_ID=@Permohonan_ID) " &
                "BEGIN " &
                "INSERT INTO LESEN_PermohonanPembetulan(Permohonan_ID, SaizIklanList, CahayaIklanList, UnitIklanList, LokasiList, " &
                "    BakaAnjingList, AnjingJantanList, AnjingBetinaList, AnjingJantanMandulList, AnjingBetinaMandulList, " &
                "    NamaSyarikat, NoPendaftaran, NoAkaun, AlamatPremis, JenisPerniagaan, " &
                "    PemilikBaru, AlamatBaru, JenisPerniagaanBaru, NamaBaruSyarikat, BillboardLokasi, LokasiPasar1, LokasiPasar2, LokasiPasar3, JenisPasar, " &
                "    JenisPerniagaanPasar, JumlahPetak, AnjingAlamat, AnjingJenisPremis, JenisPenjaja, StatusTanahPenjaja, AlamatPenjajaan, JenisPerniagaanPenjaja, MasaPenjaja1, MasaPenjaja2, " &
                "    JenisKenderaanPenjaja, NoKenderaanPenjaja, TarikhBatal, PenganjurEkspo, AlamatPenganjurEkspo, PicEkspo, NoTelEkspo, NamaEkspo, LokasiEkspo, TarikhEkspo1, TarikhEkspo2, " &
                "    MasaEkspo1, MasaEkspo2, TentatifEkspo, JemputanEkspo, PembersihanEkspo, TarikhKhemahEkspo1, TarikhKhemahEkspo2, " &
                "    KontraktorIklan, NoTelKontraktor, UkuranBanting, BilBanting, TarikhBanting1, TarikhBanting2, NoResitBanting, NoSiriStiker, TarikhBanting3, " &
                "    CreatorID, CreatedDt, LastModID, LastModDt) " &
                "SELECT Permohonan_ID, SaizIklanList, CahayaIklanList, UnitIklanList, LokasiList, " &
                "    BakaAnjingList, AnjingJantanList, AnjingBetinaList, AnjingJantanMandulList, AnjingBetinaMandulList, " &
                "    NamaSyarikat, NoPendaftaran, NoAkaun, AlamatPremis, JenisPerniagaan, " &
                "    PemilikBaru, AlamatBaru, JenisPerniagaanBaru, NamaBaruSyarikat, BillboardLokasi, LokasiPasar1, LokasiPasar2, LokasiPasar3, JenisPasar, " &
                "    JenisPerniagaanPasar, JumlahPetak, AnjingAlamat, AnjingJenisPremis, JenisPenjaja, StatusTanahPenjaja, AlamatPenjajaan, JenisPerniagaanPenjaja, MasaPenjaja1, MasaPenjaja2, " &
                "    JenisKenderaanPenjaja, NoKenderaanPenjaja, TarikhBatal, PenganjurEkspo, AlamatPenganjurEkspo, PicEkspo, NoTelEkspo, NamaEkspo, LokasiEkspo, TarikhEkspo1, TarikhEkspo2, " &
                "    MasaEkspo1, MasaEkspo2, TentatifEkspo, JemputanEkspo, PembersihanEkspo, TarikhKhemahEkspo1, TarikhKhemahEkspo2, " &
                "    KontraktorIklan, NoTelKontraktor, UkuranBanting, BilBanting, TarikhBanting1, TarikhBanting2, NoResitBanting, NoSiriStiker, TarikhBanting3, " &
                "    CreatorID, CreatedDt, LastModID, LastModDt FROM LESEN_Permohonan " &
                "WHERE LESEN_Permohonan.Permohonan_ID = @Permohonan_ID " &
                "END"

            Using myCommand As New SqlCommand(SQL, myConnection)
                myCommand.Parameters.AddWithValue("@Permohonan_ID", Permohonan_ID)
                myConnection.Open()
                myCommand.ExecuteNonQuery()
            End Using

            Dim SQLCount As String = "SELECT COUNT(Permohonan_ID) AS totalid FROM LESEN_PermohonanPembetulan WHERE Permohonan_ID = @Permohonan_ID"
            Using myCommandSelect As New SqlCommand(SQLCount, myConnection)
                myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", Permohonan_ID)
                Using myReader As SqlDataReader = myCommandSelect.ExecuteReader()
                    If myReader.Read() Then
                        recordset = CInt(myReader.Item("totalid"))
                    End If
                End Using
            End Using
        End Using

        Return (recordset >= 1)
    End Function

    Private Sub GetPermohonanPembetulan(permohonanID As Integer, isBatal As Boolean)
        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "SELECT * FROM LESEN_PermohonanPembetulan WHERE Permohonan_ID = @Permohonan_ID"
            Using myCommandSelect As New SqlCommand(SQL, myConnection)
                myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", permohonanID)
                Using myReader As SqlDataReader = myCommandSelect.ExecuteReader()
                    If myReader.Read() Then
                        If myReader.Item("SaizIklanList").ToString().Length > 0 Then HF_SaizIklanList_ins.Value = myReader.Item("SaizIklanList").ToString()
                        If myReader.Item("CahayaIklanList").ToString().Length > 0 Then HF_CahayaIklanList_ins.Value = myReader.Item("CahayaIklanList").ToString()
                        If myReader.Item("UnitIklanList").ToString().Length > 0 Then HF_UnitIklanList_ins.Value = myReader.Item("UnitIklanList").ToString()
                        If myReader.Item("LokasiList").ToString().Length > 0 Then HF_LokasiList_ins.Value = myReader.Item("LokasiList").ToString()
                        If myReader.Item("BakaAnjingList").ToString().Length > 0 Then HF_BakaAnjingList_ins.Value = myReader.Item("BakaAnjingList").ToString()
                        If myReader.Item("AnjingJantanList").ToString().Length > 0 Then HF_AnjingJantanList_ins.Value = myReader.Item("AnjingJantanList").ToString()
                        If myReader.Item("AnjingBetinaList").ToString().Length > 0 Then HF_AnjingBetinaList_ins.Value = myReader.Item("AnjingBetinaList").ToString()
                        If myReader.Item("AnjingJantanMandulList").ToString().Length > 0 Then HF_AnjingJantanMandulList_ins.Value = myReader.Item("AnjingJantanMandulList").ToString()
                        If myReader.Item("AnjingBetinaMandulList").ToString().Length > 0 Then HF_AnjingBetinaMandulList_ins.Value = myReader.Item("AnjingBetinaMandulList").ToString()

                        If myReader.Item("NamaSyarikat").ToString().Length > 0 Then TB_NamaSyarikat_ins.Text = myReader.Item("NamaSyarikat").ToString()
                        If myReader.Item("NoPendaftaran").ToString().Length > 0 Then TB_NoPendaftaran_ins.Text = myReader.Item("NoPendaftaran").ToString()
                        If myReader.Item("NoAkaun").ToString().Length > 0 Then TB_NoAkaun_ins.Text = myReader.Item("NoAkaun").ToString()
                        If myReader.Item("AlamatPremis").ToString().Length > 0 Then TB_AlamatPremis_ins.Text = myReader.Item("AlamatPremis").ToString()
                        If myReader.Item("JenisPerniagaan").ToString().Length > 0 Then TB_JenisPerniagaan_ins.Text = myReader.Item("JenisPerniagaan").ToString()
                        If myReader.Item("PemilikBaru").ToString().Length > 0 Then TB_PemilikBaru_ins.Text = myReader.Item("PemilikBaru").ToString()
                        If myReader.Item("AlamatBaru").ToString().Length > 0 Then TB_AlamatBaru_ins.Text = myReader.Item("AlamatBaru").ToString()
                        If myReader.Item("JenisPerniagaanBaru").ToString().Length > 0 Then TB_JenisPerniagaanBaru_ins.Text = myReader.Item("JenisPerniagaanBaru").ToString()
                        If myReader.Item("NamaBaruSyarikat").ToString().Length > 0 Then TB_NamaBaruSyarikat_ins.Text = myReader.Item("NamaBaruSyarikat").ToString()
                        If myReader.Item("BillboardLokasi").ToString().Length > 0 Then TB_BillboardLokasi_ins.Text = myReader.Item("BillboardLokasi").ToString()
                        If myReader.Item("LokasiPasar1").ToString().Length > 0 Then TB_LokasiPasar1_ins.Text = myReader.Item("LokasiPasar1").ToString()
                        If myReader.Item("LokasiPasar2").ToString().Length > 0 Then TB_LokasiPasar2_ins.Text = myReader.Item("LokasiPasar2").ToString()
                        If myReader.Item("LokasiPasar3").ToString().Length > 0 Then TB_LokasiPasar3_ins.Text = myReader.Item("LokasiPasar3").ToString()
                        If myReader.Item("JenisPasar").ToString().Length > 0 Then DDL_JenisPasar_ins.SelectedValue = myReader.Item("JenisPasar").ToString()
                        If myReader.Item("JenisPerniagaanPasar").ToString().Length > 0 Then TB_JenisPerniagaanPasar_ins.Text = myReader.Item("JenisPerniagaanPasar").ToString()
                        If myReader.Item("JumlahPetak").ToString().Length > 0 Then TB_JumlahPetak_ins.Text = myReader.Item("JumlahPetak").ToString()
                        If myReader.Item("AnjingAlamat").ToString().Length > 0 Then TB_AnjingAlamat_ins.Text = myReader.Item("AnjingAlamat").ToString()

                        If myReader.Item("AnjingJenisPremis").ToString().Length > 0 Then DDL_AnjingJenisPremis_ins.SelectedValue = myReader.Item("AnjingJenisPremis").ToString()
                        If myReader.Item("JenisPenjaja").ToString().Length > 0 Then DDL_JenisPenjaja_ins.SelectedValue = myReader.Item("JenisPenjaja").ToString()
                        If myReader.Item("StatusTanahPenjaja").ToString().Length > 0 Then DDL_StatusTanahPenjaja_ins.SelectedValue = myReader.Item("StatusTanahPenjaja").ToString()
                        If myReader.Item("AlamatPenjajaan").ToString().Length > 0 Then TB_AlamatPenjajaan_ins.Text = myReader.Item("AlamatPenjajaan").ToString()
                        If myReader.Item("JenisPerniagaanPenjaja").ToString().Length > 0 Then TB_JenisPerniagaanPenjaja_ins.Text = myReader.Item("JenisPerniagaanPenjaja").ToString()
                        If myReader.Item("MasaPenjaja1").ToString().Length > 0 Then TB_MasaPenjaja1_ins.Text = myReader.Item("MasaPenjaja1").ToString()
                        If myReader.Item("MasaPenjaja2").ToString().Length > 0 Then TB_MasaPenjaja2_ins.Text = myReader.Item("MasaPenjaja2").ToString()
                        If myReader.Item("JenisKenderaanPenjaja").ToString().Length > 0 Then DDL_JenisKenderaanPenjaja_ins.SelectedValue = myReader.Item("JenisKenderaanPenjaja").ToString()
                        If myReader.Item("NoKenderaanPenjaja").ToString().Length > 0 Then TB_NoKenderaanPenjaja_ins.Text = myReader.Item("NoKenderaanPenjaja").ToString()

                        If myReader.Item("PenganjurEkspo").ToString().Length > 0 Then TB_PenganjurEkspo_ins.Text = myReader.Item("PenganjurEkspo").ToString()
                        If myReader.Item("AlamatPenganjurEkspo").ToString().Length > 0 Then TB_AlamatPenganjurEkspo_ins.Text = myReader.Item("AlamatPenganjurEkspo").ToString()
                        If myReader.Item("NamaEkspo").ToString().Length > 0 Then TB_NamaEkspo_ins.Text = myReader.Item("NamaEkspo").ToString()
                        If myReader.Item("LokasiEkspo").ToString().Length > 0 Then TB_LokasiEkspo_ins.Text = myReader.Item("LokasiEkspo").ToString()
                        If myReader.Item("PicEkspo").ToString().Length > 0 Then TB_PicEkspo_ins.Text = myReader.Item("PicEkspo").ToString()
                        If myReader.Item("NoTelEkspo").ToString().Length > 0 Then TB_NoTel_ins.Text = myReader.Item("NoTelEkspo").ToString()

                        If myReader.Item("TarikhEkspo1").ToString().Length > 0 Then TB_TarikhEkspo1_ins.Text = CDate(myReader.Item("TarikhEkspo1")).ToString("yyyy-MM-dd")
                        If myReader.Item("TarikhEkspo2").ToString().Length > 0 Then TB_TarikhEkspo2_ins.Text = CDate(myReader.Item("TarikhEkspo2")).ToString("yyyy-MM-dd")
                        If myReader.Item("MasaEkspo1").ToString().Length > 0 Then TB_MasaEkspo1_ins.Text = myReader.Item("MasaEkspo1").ToString()
                        If myReader.Item("MasaEkspo2").ToString().Length > 0 Then TB_MasaEkspo2_ins.Text = myReader.Item("MasaEkspo2").ToString()
                        If myReader.Item("TentatifEkspo").ToString().Length > 0 Then TB_TentatifEkspo_ins.Text = myReader.Item("TentatifEkspo").ToString()
                        If myReader.Item("JemputanEkspo").ToString().Length > 0 Then TB_JemputanEkspo_ins.Text = myReader.Item("JemputanEkspo").ToString()
                        If myReader.Item("PembersihanEkspo").ToString().Length > 0 Then TB_PembersihanEkspo_ins.Text = myReader.Item("PembersihanEkspo").ToString()

                        If Not IsDBNull(myReader.Item("TarikhKhemahEkspo1")) Then TB_TarikhKhemahEkspo1_ins.Text = CDate(myReader.Item("TarikhKhemahEkspo1")).ToString("yyyy-MM-dd")
                        If Not IsDBNull(myReader.Item("TarikhKhemahEkspo2")) Then TB_TarikhKhemahEkspo2_ins.Text = CDate(myReader.Item("TarikhKhemahEkspo2")).ToString("yyyy-MM-dd")

                        If myReader.Item("KontraktorIklan").ToString().Length > 0 Then TB_KontraktorIklan_ins.Text = myReader.Item("KontraktorIklan").ToString()
                        If myReader.Item("NoTelKontraktor").ToString().Length > 0 Then TB_NoTelKontraktor_ins.Text = myReader.Item("NoTelKontraktor").ToString()
                        If myReader.Item("UkuranBanting").ToString().Length > 0 Then TB_UkuranBanting_ins.Text = myReader.Item("UkuranBanting").ToString()
                        If myReader.Item("BilBanting").ToString().Length > 0 Then TB_BilBanting_ins.Text = myReader.Item("BilBanting").ToString()

                        If Not IsDBNull(myReader.Item("TarikhBanting1")) Then TB_TarikhBanting1_ins.Text = CDate(myReader.Item("TarikhBanting1")).ToString("yyyy-MM-dd")
                        If Not IsDBNull(myReader.Item("TarikhBanting2")) Then TB_TarikhBanting2_ins.Text = CDate(myReader.Item("TarikhBanting2")).ToString("yyyy-MM-dd")

                        If myReader.Item("StatusBanting").ToString().Length > 0 Then DDL_StatusDBP_ins.SelectedValue = myReader.Item("StatusBanting").ToString()
                        If myReader.Item("NoPengesahanBanting").ToString().Length > 0 Then TB_NoPengesahan_ins.Text = myReader.Item("NoPengesahanBanting").ToString()

                        If Not IsDBNull(myReader.Item("TarikhPengesahanBanting1")) Then TB_TarikhPengesahanBanting1_ins.Text = CDate(myReader.Item("TarikhPengesahanBanting1")).ToString("yyyy-MM-dd")
                        If Not IsDBNull(myReader.Item("TarikhPengesahanBanting2")) Then TB_TarikhPengesahanBanting2_ins.Text = CDate(myReader.Item("TarikhPengesahanBanting2")).ToString("yyyy-MM-dd")

                        If myReader.Item("NoResitBanting").ToString().Length > 0 Then TB_NoResitBanting_ins.Text = myReader.Item("NoResitBanting").ToString()
                        If myReader.Item("NoSiriStiker").ToString().Length > 0 Then TB_NoSiriStiker_ins.Text = myReader.Item("NoSiriStiker").ToString()
                        If Not IsDBNull(myReader.Item("TarikhBanting3")) Then TB_TarikhBanting3_ins.Text = CDate(myReader.Item("TarikhBanting3")).ToString("yyyy-MM-dd")
                    End If
                End Using
            End Using

            Dim tblName As String = If(isBatal, "Batal", "")
            Dim SQLSah As String = "SELECT COUNT(Permohonan_ID) AS totalSah FROM LESEN_PermohonanAgensi" & tblName & " WHERE JabatanAgensi_ID = 3 AND PengesahID IS NOT NULL AND Permohonan_ID = @Permohonan_ID"

            Using myCommandSelect1 As New SqlCommand(SQLSah, myConnection)
                myCommandSelect1.Parameters.AddWithValue("@Permohonan_ID", permohonanID)
                Using myReader1 As SqlDataReader = myCommandSelect1.ExecuteReader()
                    If myReader1.Read() Then
                        BT_ViewLaporan.Visible = (CInt(myReader1.Item(0)) > 0)
                    End If
                End Using
            End Using
        End Using

        ' Load Senarai Iklan (_ins)
        Dim SaizIklanList() As String = Split(HF_SaizIklanList_ins.Value, ",")
        Dim CahayaIklanList() As String = Split(HF_CahayaIklanList_ins.Value, ",")
        Dim UnitIklanList() As String = Split(HF_UnitIklanList_ins.Value, ",")

        If SaizIklanList.Length > 0 AndAlso Not String.IsNullOrWhiteSpace(SaizIklanList(0)) Then
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
                If Not String.IsNullOrWhiteSpace(SaizIklanList(i)) Then
                    Dim newRow As DataRow = dt.NewRow()
                    newRow("SaizIklan") = SaizIklanList(i).Trim()
                    newRow("Bercahaya") = If(i < CahayaIklanList.Length, CahayaIklanList(i).Trim(), "")
                    newRow("Unit") = If(i < UnitIklanList.Length, UnitIklanList(i).Trim(), "")
                    dt.Rows.Add(newRow)
                End If
            Next

            ViewState("IklanTable_ins") = dt
            gvIklanList_ins.DataSource = dt
            gvIklanList_ins.DataBind()
        End If

        ' Load Senarai Anjing (_ins)
        Dim BakaAnjingList() As String = Split(HF_BakaAnjingList_ins.Value, ",")
        Dim JantanList() As String = Split(HF_AnjingJantanList_ins.Value, ",")
        Dim BetinaList() As String = Split(HF_AnjingBetinaList_ins.Value, ",")
        Dim JantanMandulList() As String = Split(HF_AnjingJantanMandulList_ins.Value, ",")
        Dim BetinaMandulList() As String = Split(HF_AnjingBetinaMandulList_ins.Value, ",")

        If BakaAnjingList.Length > 0 AndAlso Not String.IsNullOrWhiteSpace(BakaAnjingList(0)) Then
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
                If Not String.IsNullOrWhiteSpace(BakaAnjingList(i)) Then
                    Dim newRow As DataRow = dt.NewRow()
                    newRow("Baka") = BakaAnjingList(i).Trim()
                    newRow("Jantan") = If(i < JantanList.Length, JantanList(i).Trim(), "")
                    newRow("Betina") = If(i < BetinaList.Length, BetinaList(i).Trim(), "")
                    newRow("JantanMandul") = If(i < JantanMandulList.Length, JantanMandulList(i).Trim(), "")
                    newRow("BetinaMandul") = If(i < BetinaMandulList.Length, BetinaMandulList(i).Trim(), "")
                    dt.Rows.Add(newRow)
                End If
            Next

            ViewState("AnjingTable_ins") = dt
            gvAnjingList_ins.DataSource = dt
            gvAnjingList_ins.DataBind()
        End If

        ' Load Senarai Lokasi (_ins)
        Dim LokasiList() As String = Split(HF_LokasiList_ins.Value, "||")

        If LokasiList.Length > 0 AndAlso Not String.IsNullOrWhiteSpace(LokasiList(0)) Then
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
                If Not String.IsNullOrWhiteSpace(LokasiList(i)) Then
                    Dim newRow As DataRow = dt.NewRow()
                    newRow("No") = (i + 1).ToString()
                    newRow("Lokasi") = LokasiList(i).Trim()
                    dt.Rows.Add(newRow)
                End If
            Next

            ViewState("LokasiTable_ins") = dt
            gvLokasiList_ins.DataSource = dt
            gvLokasiList_ins.DataBind()
        End If
    End Sub

    Protected Sub btnSaveInfo_Click(sender As Object, e As EventArgs)
        Dim PermohonanID As Integer = CInt(GridView1.SelectedDataKey.Values(0))

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "UPDATE LESEN_PermohonanPembetulan SET SaizIklanList=@SaizIklanList, CahayaIklanList=@CahayaIklanList, UnitIklanList=@UnitIklanList, LokasiList = @LokasiList, " &
                        "BakaAnjingList=@BakaAnjingList, AnjingJantanList=@AnjingJantanList, AnjingBetinaList=@AnjingBetinaList, AnjingJantanMandulList=@AnjingJantanMandulList, AnjingBetinaMandulList=@AnjingBetinaMandulList, " &
                        "NamaSyarikat = @NamaSyarikat, NoPendaftaran = @NoPendaftaran, NoAkaun = @NoAkaun, AlamatPremis = @AlamatPremis, JenisPerniagaan = @JenisPerniagaan, PemilikBaru = @PemilikBaru, " &
                        "AlamatBaru = @AlamatBaru, JenisPerniagaanBaru = @JenisPerniagaanBaru, NamaBaruSyarikat = @NamaBaruSyarikat, " &
                        "BillboardLokasi = @BillboardLokasi, LokasiPasar1 = @LokasiPasar1, LokasiPasar2 = @LokasiPasar2, LokasiPasar3 = @LokasiPasar3, " &
                        "JenisPasar = @JenisPasar, JenisPerniagaanPasar = @JenisPerniagaanPasar, JumlahPetak = @JumlahPetak, AnjingAlamat = @AnjingAlamat, AnjingJenisPremis = @AnjingJenisPremis, " &
                        "JenisPenjaja = @JenisPenjaja, StatusTanahPenjaja = @StatusTanahPenjaja, AlamatPenjajaan = @AlamatPenjajaan, JenisPerniagaanPenjaja = @JenisPerniagaanPenjaja, " &
                        "MasaPenjaja1 = @MasaPenjaja1, MasaPenjaja2 = @MasaPenjaja2, JenisKenderaanPenjaja = @JenisKenderaanPenjaja, NoKenderaanPenjaja = @NoKenderaanPenjaja, " &
                        "PenganjurEkspo = @PenganjurEkspo, AlamatPenganjurEkspo = @AlamatPenganjurEkspo, PicEkspo = @PicEkspo, NoTelEkspo = @NoTelEkspo,  NamaEkspo = @NamaEkspo, LokasiEkspo = @LokasiEkspo, " &
                        "TarikhEkspo1 = @TarikhEkspo1, TarikhEkspo2 = @TarikhEkspo2, MasaEkspo1 = @MasaEkspo1, MasaEkspo2 = @MasaEkspo2, TentatifEkspo = @TentatifEkspo, JemputanEkspo = @JemputanEkspo, " &
                        "PembersihanEkspo = @PembersihanEkspo, TarikhKhemahEkspo1 = @TarikhKhemahEkspo1, TarikhKhemahEkspo2 = @TarikhKhemahEkspo2, " &
                        "KontraktorIklan = @KontraktorIklan, NoTelKontraktor = @NoTelKontraktor, UkuranBanting = @UkuranBanting, BilBanting = @BilBanting, TarikhBanting1 = @TarikhBanting1, TarikhBanting2 = @TarikhBanting2, " &
                        "NoResitBanting = @NoResitBanting, NoSiriStiker=@NoSiriStiker, TarikhBanting3=@TarikhBanting3, LastModDt = GETDATE() " &
                        "WHERE Permohonan_ID = @Permohonan_ID"

            Using myCommandSelect As New SqlCommand(SQL, myConnection)
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
                myCommandSelect.Parameters.AddWithValue("@JenisPenjaja", DDL_JenisPenjaja_ins.SelectedValue)
                myCommandSelect.Parameters.AddWithValue("@StatusTanahPenjaja", DDL_StatusTanahPenjaja_ins.SelectedValue)
                myCommandSelect.Parameters.AddWithValue("@AlamatPenjajaan", TB_AlamatPenjajaan_ins.Text)
                myCommandSelect.Parameters.AddWithValue("@JenisPerniagaanPenjaja", TB_JenisPerniagaanPenjaja_ins.Text)
                myCommandSelect.Parameters.AddWithValue("@MasaPenjaja1", TB_MasaPenjaja1_ins.Text)
                myCommandSelect.Parameters.AddWithValue("@MasaPenjaja2", TB_MasaPenjaja2_ins.Text)
                myCommandSelect.Parameters.AddWithValue("@JenisKenderaanPenjaja", DDL_JenisKenderaanPenjaja_ins.SelectedValue)
                myCommandSelect.Parameters.AddWithValue("@NoKenderaanPenjaja", TB_NoKenderaanPenjaja_ins.Text)
                myCommandSelect.Parameters.AddWithValue("@PenganjurEkspo", TB_PenganjurEkspo_ins.Text)
                myCommandSelect.Parameters.AddWithValue("@AlamatPenganjurEkspo", TB_AlamatPenganjurEkspo_ins.Text)
                myCommandSelect.Parameters.AddWithValue("@PicEkspo", TB_PicEkspo_ins.Text)
                myCommandSelect.Parameters.AddWithValue("@NoTelEkspo", TB_NoTel_ins.Text)
                myCommandSelect.Parameters.AddWithValue("@NamaEkspo", TB_NamaEkspo_ins.Text)
                myCommandSelect.Parameters.AddWithValue("@LokasiEkspo", TB_LokasiEkspo_ins.Text)
                myCommandSelect.Parameters.AddWithValue("@TarikhEkspo1", TB_TarikhEkspo1_ins.Text)
                myCommandSelect.Parameters.AddWithValue("@TarikhEkspo2", TB_TarikhEkspo2_ins.Text)
                myCommandSelect.Parameters.AddWithValue("@MasaEkspo1", TB_MasaEkspo1_ins.Text)
                myCommandSelect.Parameters.AddWithValue("@MasaEkspo2", TB_MasaEkspo2_ins.Text)
                myCommandSelect.Parameters.AddWithValue("@TentatifEkspo", TB_TentatifEkspo_ins.Text)
                myCommandSelect.Parameters.AddWithValue("@JemputanEkspo", TB_JemputanEkspo_ins.Text)
                myCommandSelect.Parameters.AddWithValue("@PembersihanEkspo", TB_PembersihanEkspo_ins.Text)
                myCommandSelect.Parameters.AddWithValue("@TarikhKhemahEkspo1", TB_TarikhKhemahEkspo1_ins.Text)
                myCommandSelect.Parameters.AddWithValue("@TarikhKhemahEkspo2", TB_TarikhKhemahEkspo2_ins.Text)
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
                    myCommandSelect.ExecuteNonQuery()
                    ShowAlert("success", "", "Pembetulan maklumat permohonan telah dikemaskini.")
                Catch ex As Exception
                    MessageBox(ex.Message, Me)
                End Try
            End Using
        End Using
    End Sub

    ' --- Kadar Bayaran ---
    Private Sub insertKadarBayaran(jid As String, pid As Integer)
        Dim listkbdesc As New List(Of String)()
        Dim listkbamount As New List(Of String)()

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "SELECT JenisLesenBayaran_Description, JenisLesenBayaran_Amount " &
                "FROM LESEN_JenisLesenBayaran " &
                "WHERE ',' + @JenisLesen_ID + ',' LIKE '%,' + CAST(JenisLesen_ID AS VARCHAR) + ',%' " &
                "GROUP BY JenisLesenBayaran_Description, JenisLesenBayaran_Amount"

            Using myCommandSelect As New SqlCommand(SQL, myConnection)
                myCommandSelect.Parameters.AddWithValue("@JenisLesen_ID", jid)
                Using myReader As SqlDataReader = myCommandSelect.ExecuteReader()
                    While myReader.Read()
                        listkbdesc.Add(myReader.Item("JenisLesenBayaran_Description").ToString())
                        listkbamount.Add(myReader.Item("JenisLesenBayaran_Amount").ToString())
                    End While
                End Using
            End Using

            For counter As Integer = 0 To listkbdesc.Count - 1
                Dim SQL1 As String = "INSERT INTO LESEN_KadarBayaran(KadarBayaran_PermohonanID, KadarBayaran_PermohonanAgensiID, KadarBayaran_UserID, KadarBayaran_Desc, KadarBayaran_Amount) " &
                    "VALUES (@KadarBayaran_PermohonanID, @KadarBayaran_PermohonanAgensiID, @KadarBayaran_UserID, @KadarBayaran_Desc, @KadarBayaran_Amount)"
                Using myCommandSelect1 As New SqlCommand(SQL1, myConnection)
                    myCommandSelect1.Parameters.AddWithValue("@KadarBayaran_PermohonanID", pid)
                    myCommandSelect1.Parameters.AddWithValue("@KadarBayaran_PermohonanAgensiID", Session.Item("SessionEstateId"))
                    myCommandSelect1.Parameters.AddWithValue("@KadarBayaran_UserID", Session.Item("SessionUsersId"))
                    myCommandSelect1.Parameters.AddWithValue("@KadarBayaran_Desc", listkbdesc(counter))
                    myCommandSelect1.Parameters.AddWithValue("@KadarBayaran_Amount", listkbamount(counter))
                    Try
                        myCommandSelect1.ExecuteNonQuery()
                    Catch ex As Exception
                    End Try
                End Using
            Next
        End Using
    End Sub

    Protected Sub btnAddNew_Click(sender As Object, e As EventArgs)
        Dim Permohonan_ID As Integer = CInt(GridView1.SelectedDataKey.Values(0))

        Using myConnection As New SqlConnection(CS)
            Dim SQL As String = "Insert Into LESEN_KadarBayaran (KadarBayaran_PermohonanID,KadarBayaran_PermohonanAgensiID,KadarBayaran_UserID,CreatedDt,CreatorID) Values " &
                "(@Permohonan_ID,case when @AgensiId = 0 then NULL else @AgensiId end,@SessionUsersID, getdate(), @SessionUserName)"

            Using myCommand As New SqlCommand(SQL, myConnection)
                myCommand.Parameters.AddWithValue("@Permohonan_ID", Permohonan_ID)
                myCommand.Parameters.AddWithValue("@AgensiId", Session.Item("SessionEstateId"))
                myCommand.Parameters.AddWithValue("@SessionUsersId", Session.Item("SessionUsersId"))
                myCommand.Parameters.AddWithValue("@SessionUserName", Session.Item("SessionUserName"))
                myConnection.Open()
                Dim recordset As Integer = myCommand.ExecuteNonQuery()
                If recordset > 0 Then
                    gvTabBayaran.EditIndex = CInt(gvTabBayaran.Rows.Count)
                End If
            End Using
        End Using

        gvTabBayaran.DataBind()
        Page.SetFocus(Me.ui_btnPageBottom.ClientID)
    End Sub

    Protected Sub cbsel_CheckedChanged(sender As Object, e As EventArgs)
        Dim cb As CheckBox = DirectCast(sender, CheckBox)
        Dim row As GridViewRow = DirectCast(cb.NamingContainer, GridViewRow)
        Dim kbId As String = DirectCast(row.FindControl("Label1"), Label).Text

        Using myConnection As New SqlConnection(CS)
            Dim SQL As String = "UPDATE LESEN_KadarBayaran SET IsSelect = @IsSelect WHERE KadarBayaran_ID = @KadarBayaran_ID"
            Try
                Using myCommand As New SqlCommand(SQL, myConnection)
                    myCommand.Parameters.AddWithValue("@KadarBayaran_ID", kbId)
                    myCommand.Parameters.AddWithValue("@IsSelect", If(cb.Checked, 1, 0))
                    myConnection.Open()
                    myCommand.ExecuteNonQuery()
                End Using
            Catch ex As Exception
                MessageBox("ERROR", Me)
            End Try
        End Using

        gvTabBayaran.DataBind()
    End Sub

#End Region

#Region "Form Controls Event Handlers"

    Protected Sub ddl_Pemohon_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ddl As DropDownList = DirectCast(FormView1.FindControl("ddl_Pemohon"), DropDownList)
        Dim tbid As TextBox = DirectCast(FormView1.FindControl("TB_PemohonID"), TextBox)
        Dim tbname As TextBox = DirectCast(FormView1.FindControl("TB_Name"), TextBox)
        Dim tbnation As TextBox = DirectCast(FormView1.FindControl("TB_Nat"), TextBox)
        Dim tbaddress As TextBox = DirectCast(FormView1.FindControl("TB_Address"), TextBox)
        Dim tbnote As TextBox = DirectCast(FormView1.FindControl("TB_Remarks"), TextBox)
        Dim pnl As Panel = DirectCast(FormView1.FindControl("pnlpemohon"), Panel)

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "SELECT a.*, b.name FROM LESEN_Pemohon a " &
                                "INNER JOIN TBL_LOOKUPS b ON a.Pemohon_Nationality = b.id WHERE a.Pemohon_ID = @Pemohon_ID"
            Using myCommandSelect As New SqlCommand(SQL, myConnection)
                myCommandSelect.Parameters.AddWithValue("@Pemohon_ID", ddl.SelectedValue)
                Using myReader As SqlDataReader = myCommandSelect.ExecuteReader()
                    If myReader.Read() Then
                        tbid.Text = myReader.Item("Pemohon_ID").ToString()
                        tbname.Text = myReader.Item("Pemohon_Name").ToString()
                        tbnation.Text = myReader.Item("name").ToString()
                        tbaddress.Text = myReader.Item("Pemohon_Address").ToString()
                        tbnote.Text = myReader.Item("Pemohon_Remarks").ToString()

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
                End Using
            End Using
        End Using

        If FormView1.CurrentMode = FormViewMode.Insert Then
            LoadPrevRekodPermohonan()
        End If
    End Sub

    Protected Sub CB_Deposit_CheckedChanged(sender As Object, e As EventArgs)
        Dim cb As CheckBox = DirectCast(FormView1.FindControl("CB_Deposit"), CheckBox)
        Dim pnl As Panel = DirectCast(FormView1.FindControl("pnldeposit"), Panel)
        pnl.Visible = (cb IsNot Nothing AndAlso cb.Checked)
    End Sub

    Protected Sub CB_IsBatal_CheckedChanged(sender As Object, e As EventArgs)
        Dim cb As CheckBox = DirectCast(FormView1.FindControl("CB_IsBatal"), CheckBox)
        Dim pnl As Panel = DirectCast(FormView1.FindControl("pnlbatal2"), Panel)
        Dim pnla As Panel = DirectCast(FormView1.FindControl("pnldeposit1"), Panel)

        Dim isChecked As Boolean = (cb IsNot Nothing AndAlso cb.Checked)
        pnl.Visible = isChecked
        pnla.Visible = isChecked
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

    Protected Sub DDL_JenisPasar_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ddl As DropDownList = DirectCast(FormView1.FindControl("DDL_JenisPasar"), DropDownList)
        Dim noruj As TextBox = DirectCast(FormView1.FindControl("TB_Rujukan"), TextBox)

        Select Case ddl.SelectedIndex
            Case 1 ' Pasar Pagi
                noruj.Text = "MPK/599/401/26/PP"
            Case 2 ' Pasar Malam
                noruj.Text = "MPK/599/401/3/33"
            Case Else ' Pasar Lambak
                noruj.Text = "MPK/599/401/"
        End Select
    End Sub

    Private Sub GetSuratMohon(pid As Integer)
        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "SELECT TandatanganMohonUlasanId, TandatanganMohonUlasanLuarId FROM LESEN_Permohonan WHERE Permohonan_ID = @Permohonan_ID"
            Using myCommandSelect As New SqlCommand(SQL, myConnection)
                myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)
                Using myReader As SqlDataReader = myCommandSelect.ExecuteReader()
                    If myReader.Read() Then
                        If myReader.Item("TandatanganMohonUlasanId").ToString().Length > 0 Then
                            ddlTandatangan.SelectedValue = myReader.Item("TandatanganMohonUlasanId").ToString()
                        End If
                        If myReader.Item("TandatanganMohonUlasanLuarId").ToString().Length > 0 Then
                            ddlTandatanganLuar.SelectedValue = myReader.Item("TandatanganMohonUlasanLuarId").ToString()
                        End If
                    End If
                End Using
            End Using
        End Using
    End Sub

#End Region

#Region "Helper Utilities & Alerts"

    Public Sub MessageBox(ByVal Msg As String, ByVal obj As System.Web.UI.Page)
        ScriptManager.RegisterClientScriptBlock(Me.Page, Me.GetType(), "Alert", "alert('" & Msg.Replace("'", "\'") & "');", True)
    End Sub

    Private Sub ShowAlert(statusMsg As String, titleMsg As String, strMsg As String)
        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "Script", "Swal.fire('" & titleMsg.Replace("'", "\'") & "','" & strMsg.Replace("'", "\'") & "','" & statusMsg.Replace("'", "\'") & "')", True)
    End Sub

#End Region

End Class
