
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Drawing.Imaging
Imports System.IO
Imports System.Security.Policy
Imports Microsoft.ReportingServices.Rendering.ExcelRenderer.ExcelGenerator.BIFF8
Imports Microsoft.SqlServer.Management.Smo

Partial Class semakkelulusan1
    Inherits System.Web.UI.Page

    Protected Sub FormView1_ItemInserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertedEventArgs) Handles FormView1.ItemInserted

        ShowAlert("success", "", "Rekod berjaya disimpan")
        GridView1.DataBind()
    End Sub

    Protected Sub GridView1_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs) Handles GridView1.RowDeleting
        Dim title As String = GridView1.Rows(e.RowIndex).Cells(1).Text

        '//run audit trail : Insert : Update : Delete : Login : Logout
        GlobalClass.auditTrail(idWindowTitle.InnerText, title, "Nyah Aktif")
    End Sub

    Protected Sub GridView1_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles GridView1.SelectedIndexChanged
        FormView1.ChangeMode(DetailsViewMode.Edit)
        TabContainer1.Visible = True
        'idFooter.Visible = True
        idListing.Visible = False
        'Dim idNotaKelulusan As HtmlGenericControl = DirectCast(FormView1.FindControl("idNotaKelulusan"), HtmlGenericControl)
        'Dim idSokongUlasan As HtmlGenericControl = DirectCast(fvSokongUlasan.FindControl("idSokongUlasan"), HtmlGenericControl)

        Dim PermohonanID As Integer = CInt(GridView1.SelectedDataKey.Values(0))
        Dim ApprStatusID As Integer = CInt(GridView1.SelectedDataKey.Values(1))
        'Dim JenisLesenID As Integer = CInt(GridView1.SelectedDataKey.Values(2))
        Dim IsFail As Boolean = CBool(GridView1.SelectedDataKey.Values(3))
        Dim IsPublish As Boolean = CBool(GridView1.SelectedDataKey.Values(4))

        If getJabatanLesen(CInt(Session.Item("sessionEstateID"))) = False Or ApprStatusID < 9 Then
            tabSurat.Visible = False
            tabLampiran.Visible = False
        Else

            GetSuratContent(PermohonanID)
            GetLampiran(PermohonanID)

            If IsFail Then
                CB_SuratFail.Checked = True
                pnlSuratAuto.Visible = False
                pnlSuratFail.Visible = True
                'BT_Generate.Visible = False
            Else
                CB_SuratFail.Checked = False
                pnlSuratAuto.Visible = True
                pnlSuratFail.Visible = False
                'BT_Generate.Visible = True
            End If

            GetSuratFail(PermohonanID)

            If IsPublish Then
                tabSurat.Visible = False
            End If

        End If

    End Sub

    Private Function getJabatanLesen(agensiID As Integer) As Boolean

        Dim retval As Boolean = False

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Dim SQL As String = ""
            SQL = "select * from LESEN_JabatanAgensi where JabatanAgensi_IsLesen=1 
            and JabatanAgensi_IsActive=1 and JabatanAgensi_ID = @JabatanAgensi_ID "


            Dim myCommand As New SqlCommand(SQL, myConnection)
            myCommand.Parameters.AddWithValue("@JabatanAgensi_ID", agensiID)

            myConnection.Open()

            Dim myReader As SqlDataReader = myCommand.ExecuteReader

            While myReader.Read

                retval = True

            End While

            myReader.Close()
            myConnection.Close()

        End Using

        If agensiID = 0 Then

            retval = True

        End If

        Return retval

    End Function

    Private Sub GetSuratContent(pid As Integer)

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQL As String = "SELECT SuratKelulusan1, SuratKelulusan2, SuratKelulusan3, SuratKelulusan4, TandatanganKelulusanId, TarikhSuratKelulusan FROM LESEN_Permohonan WHERE Permohonan_ID = @Permohonan_ID"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            Try
                If myReader.Read Then

                    If IsDBNull(myReader.Item("TarikhSuratKelulusan")) = False Then
                        TB_TarikhSurat.Text = CDate(myReader.Item("TarikhSuratKelulusan")).ToString("yyyy-MM-dd")
                    End If

                    If myReader.Item("TandatanganKelulusanId").ToString().Length > 0 Then
                        ddlTandatangan.SelectedValue = CInt(myReader.Item("TandatanganKelulusanId").ToString())
                    End If

                End If

            Catch ex As Exception
                MessageBox(ex.Message, Me)
            End Try

            myReader.Close()
            myConnection.Close()

        End Using

    End Sub

    '+++++++++ START FILTER +++++++++
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        Dim gv As GridView = GridView1
        Dim ds As SqlDataSource = SqlDataSourceGrid
        'GlobalClass.GenerateFilter(gv, ds, pnlFilter)

        Page.Form.Attributes.Add("enctype", "multipart/form-data")

        ''+++++ Selected column +++++
        'Dim lstColumn As New List(Of String)({"description"})
        'GlobalClass.GenerateFilter(gv, ds, pnlFilter, lstColumn)

        If Not Page.IsPostBack Then

            If Session.Item("sessionEstateID") Is Nothing Then
                GridView1.Visible = False
                filterJenisLesen.Attributes.Add("style", "display:none")
                filterStatus.Attributes.Add("style", "display:none")
                TB_TarikhLulus.Attributes.Add("style", "display:none")
            End If

            If Request.Browser.IsMobileDevice Then
                GridView1.Columns(0).Visible = "false"
                GridView1.Columns(1).Visible = "false"
                GridView1.Columns(2).Visible = "false"
                GridView1.Columns(3).Visible = "false"
                GridView1.Columns(4).Visible = "false"
                GridView1.Columns(5).Visible = "false"
                GridView1.Columns(6).Visible = "true"
            Else
                GridView1.Columns(6).Visible = "false"
            End If

        End If

        Try

            '//mobile view
            If Not Page.IsPostBack Then

                If Request.Browser.IsMobileDevice Then

                    gvTabUlasan.Columns(2).Visible = "false"
                    gvTabUlasan.Columns(3).Visible = "false"
                    gvTabUlasan.Columns(5).Visible = "false"
                    gvTabUlasan.Columns(4).Visible = "true"
                Else

                    gvTabUlasan.Columns(4).Visible = "false"
                End If
            End If

        Catch ex As Exception

        End Try

        Try

            '//mobile view
            If Not Page.IsPostBack Then

                If Request.Browser.IsMobileDevice Then
                    gvTabBayaran.Columns(2).Visible = "false"
                    gvTabBayaran.Columns(3).Visible = "false"
                    gvTabBayaran.Columns(5).Visible = "false"
                    gvTabBayaran.Columns(4).Visible = "true"
                Else

                    gvTabBayaran.Columns(4).Visible = "false"
                End If
            End If

        Catch ex As Exception

        End Try
    End Sub

    Private Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearch.Click
        'Dim ds As SqlDataSource = SqlDataSourceGrid
        'GlobalClass.procSearch(ds, pnlFilter)

        If Session.Item("sessionEstateID") Is Nothing And txtNoRujukan.Text.Length = 0 Then
            Response.Redirect(Request.RawUrl)
        End If

        GridView1.DataBind()
        GridView1.Visible = True

    End Sub

    Private Sub btnReset_Click(sender As Object, e As EventArgs) Handles btnReset.Click
        Response.Redirect(Request.RawUrl)
    End Sub
    Protected Sub GridView1_PageIndexChanged(sender As Object, e As EventArgs) Handles GridView1.PageIndexChanged
        CallFilter()
    End Sub

    Private Sub CallFilter()
        Dim ds As SqlDataSource = SqlDataSourceGrid
        'GlobalClass.procSearch(ds, pnlFilter)
    End Sub

    Protected Sub FormView1_ItemInserting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertEventArgs) Handles FormView1.ItemInserting
        Dim titleTxt As TextBox = DirectCast(FormView1.FindControl("txtJenisLesen_Description"), TextBox)
        Dim title As String = titleTxt.Text

        '//run audit trail : Insert : Update : Delete : Login : Logout
        GlobalClass.auditTrail(idWindowTitle.InnerText, title, "Maklumat")
    End Sub

    Protected Sub FormView1_ItemUpdated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdatedEventArgs) Handles FormView1.ItemUpdated

        ShowAlert("success", "", "Rekod berjaya dikemaskini")
        GridView1.DataBind()
    End Sub

    Protected Sub FormView1_ItemUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdateEventArgs) Handles FormView1.ItemUpdating
        Dim titleTxt As TextBox = DirectCast(FormView1.FindControl("txtJenisLesen_Description"), TextBox)
        Dim title As String = titleTxt.Text

        '//run audit trail : Insert : Update : Delete : Login : Logout
        GlobalClass.auditTrail(idWindowTitle.InnerText, title, "Kemaskini")
    End Sub

    Protected Sub Page_PreRenderComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRenderComplete

        Dim btnback As LinkButton = DirectCast(FormView1.FindControl("btnBack"), LinkButton)
        Dim btnsmu As LinkButton = DirectCast(FormView1.FindControl("BT_SuratMohonUlasan"), LinkButton)

        Dim frmview() As Object = {FormView1}
        Dim lbutton() As Object = {btnback, btnsmu} '//allow control
        Dim ctlDeny() As Object = {} '//deny control

        '//check Write
        Dim frmwrite As Boolean = GlobalClass.CheckPageWrite("Write", frmview, lbutton, ctlDeny)
        '// check gridview permission
        If frmwrite = False Then
            '//gridview select view
            'GridView1.Columns.Item(5).Visible = False '//grid delete

        End If
    End Sub

    Private Sub initPageName()
        '// get page name
        Dim menuName As String = GlobalClass.writeTitlePage(Request.QueryString("m_Id"), "")

        Dim idWindowTitle2 As HtmlGenericControl = DirectCast(FormView1.FindControl("idWindowTitle2"), HtmlGenericControl)
        Dim idWindowTitle3 As HtmlGenericControl = DirectCast(FormView1.FindControl("idWindowTitle3"), HtmlGenericControl)

        If menuName = "" Then
            menuName = "Semak Kelulusan"
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

    Private Sub FormView1_DataBound(sender As Object, e As EventArgs) Handles FormView1.DataBound
        '// page name initial
        initPageName()
    End Sub

    Private Sub ShowAlert(statusMsg As String, titleMsg As String, strMsg As String)

        ScriptManager.RegisterStartupScript(Me, Page.GetType, "Script", "Swal.fire('" & titleMsg & "',
        '" & strMsg & "',
        '" & statusMsg & "');", True)

    End Sub

    Private Sub GridView1_DataBound(sender As Object, e As EventArgs) Handles GridView1.DataBound
        If isHaveButton Then
            GridView1.Columns(7).Visible = True
        Else
            GridView1.Columns(7).Visible = False
        End If
    End Sub

    Private isHaveButton As Boolean = False
    Private Sub GridView1_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles GridView1.RowDataBound

        Try
            Select Case e.Row.RowType
                Case DataControlRowType.DataRow
                    Dim LinkButton3 = DirectCast(e.Row.FindControl("LinkButton3"), LinkButton)
                    Dim LinkButton5 = DirectCast(e.Row.FindControl("LinkButton5"), LinkButton)
                    Dim LinkButton6 = DirectCast(e.Row.FindControl("LinkButton6"), LinkButton)
                    Dim LinkButton7 = DirectCast(e.Row.FindControl("LinkButton7"), LinkButton)

                    If LinkButton3.Visible = True Or LinkButton5.Visible = True Or LinkButton6.Visible = True Or LinkButton7.Visible = True Then
                        isHaveButton = True
                    End If

            End Select


        Catch ex As Exception

        End Try

        Try

            If Session.Item("sessionEstateID") IsNot Nothing Then

                If e.Row.RowType = DataControlRowType.DataRow Then

                    Dim dtTmp As DateTime = Convert.ToDateTime(e.Row.DataItem("TarikhMohon").ToString)
                    Dim is24h As Boolean = Convert.ToBoolean(e.Row.DataItem("Is24jam").ToString)

                    If (((DateTime.Now - dtTmp).TotalHours > 24 And is24h) Or
                        ((DateTime.Now - dtTmp).TotalDays > 14 And is24h = False)) And
                        e.Row.DataItem("StatusDesc").ToString.Contains("Permohonan Lulus") = False And
                        e.Row.DataItem("StatusDesc").ToString.Contains("Peraku Tidak Sokong") = False Then

                        Dim clr As Color = Color.FromName("#ff7070")

                        e.Row.BackColor = clr

                    End If

                End If

            End If

        Catch ex As Exception

            MessageBox("Error checking delayed task.", Me)

        End Try

    End Sub

    Private Sub GridView1_RowDeleted(sender As Object, e As GridViewDeletedEventArgs) Handles GridView1.RowDeleted
        ShowAlert("success", "", "Rekod berjaya dikemaskini")
    End Sub

    Protected Sub btnBack_Click(sender As Object, e As EventArgs)
        backToList()
    End Sub

    Private Sub backToList()
        idListing.Visible = True
        TabContainer1.Visible = False
        'idFooter.Visible = False
        GridView1.SelectedIndex = -1
        GridView1.DataBind()
    End Sub

    Protected Sub btnViewDetail_Click(sender As Object, e As EventArgs)

    End Sub

    Private Sub gvTabUlasan_RowUpdated(sender As Object, e As GridViewUpdatedEventArgs) Handles gvTabUlasan.RowUpdated
        '//
    End Sub
    Private Sub gvTabUlasan_RowUpdating(sender As Object, e As GridViewUpdateEventArgs) Handles gvTabUlasan.RowUpdating
        Dim LinkButton1 As LinkButton
        Dim btnUpload As Button
        Dim txtUlasanFail_FilePath As FileUpload
        If Request.Browser.IsMobileDevice Then
            LinkButton1 = CType(gvTabUlasan.Rows(e.RowIndex).FindControl("LinkButton1Mobile"), LinkButton)
            btnUpload = CType(gvTabUlasan.Rows(e.RowIndex).FindControl("btnUploadMobile"), Button)
            txtUlasanFail_FilePath = CType(gvTabUlasan.Rows(e.RowIndex).FindControl("txtUlasanFail_FilePathMobile"), FileUpload)
        Else
            LinkButton1 = CType(gvTabUlasan.Rows(e.RowIndex).FindControl("LinkButton1"), LinkButton)
            btnUpload = CType(gvTabUlasan.Rows(e.RowIndex).FindControl("btnUpload"), Button)
            txtUlasanFail_FilePath = CType(gvTabUlasan.Rows(e.RowIndex).FindControl("txtUlasanFail_FilePath"), FileUpload)
        End If

        Dim updatePanelUlasan As UpdatePanel = CType(gvTabUlasan.Rows(e.RowIndex).FindControl("updatePanelUlasan"), UpdatePanel)
        Dim uid As Guid = Guid.NewGuid()
        Dim fn As String = System.IO.Path.GetFileName(txtUlasanFail_FilePath.PostedFile.FileName)

        Dim localPath As String = "~/doc/" & "" & uid.ToString & fn
        Dim SaveLocation As String = Server.MapPath(localPath)

        If (txtUlasanFail_FilePath.PostedFile IsNot Nothing) AndAlso (txtUlasanFail_FilePath.PostedFile.ContentLength > 0) Then

            '//delete previous file
            If e.OldValues("UlasanFail_FilePath") <> "" Then

                Dim deleteFilePath As String = Server.MapPath(e.OldValues("UlasanFail_FilePath"))

                If System.IO.File.Exists(deleteFilePath) Then
                    System.IO.File.Delete(deleteFilePath)
                End If

            End If

            If updateUploadFile(txtUlasanFail_FilePath, SaveLocation) Then

                e.NewValues("UlasanFail_FileName") = txtUlasanFail_FilePath.PostedFile.FileName
                e.NewValues("UlasanFail_ContentType") = txtUlasanFail_FilePath.PostedFile.ContentType
                e.NewValues("UlasanFail_FilePath") = localPath

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
                        Dim bmpPostedImage As System.Drawing.Bitmap = New System.Drawing.Bitmap(txtUlasanFail_FilePath.PostedFile.InputStream)
                        Dim objImage As System.Drawing.Image = ScaleImage(bmpPostedImage, 1024)
                        objImage.Save(saveLocation, ImageFormat.Jpeg)

                        MessageBox("Fail berjaya dimuatnaik", Me)

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


                        MessageBox("Fail berjaya dimuatnaik", Me)

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

    Public Sub MessageBox(ByVal Msg As String, ByVal obj As System.Web.UI.Page)
        Dim jscript As String
        Dim x = "OURServices"
        ScriptManager.RegisterClientScriptBlock(Me.Page, Me.[GetType](), "Alert", "alert('" & Msg & "');", True)
    End Sub

    Public Property OriginalImageSize As Size
    Public Property NewImageSize As Size

    Public Shared Function ScaleImage(ByVal image As System.Drawing.Image, ByVal maxHeight As Integer) As System.Drawing.Image
        Dim ratio = CDbl(maxHeight) / image.Height
        Dim newWidth = CInt((image.Width * ratio))
        Dim newHeight = CInt((image.Height * ratio))
        Dim newImage = New Bitmap(newWidth, newHeight)

        Using g = Graphics.FromImage(newImage)
            g.DrawImage(image, 0, 0, newWidth, newHeight)
        End Using

        Return newImage
    End Function
    Protected Sub btnUpload_Click(sender As Object, e As EventArgs)

        Dim btn As Button = CType(sender, Button)
        Dim row As GridViewRow = CType(btn.NamingContainer, GridViewRow)

        'Dim btnUpload As Button = CType(row.FindControl("btnUpload"), Button)
        'Dim currPageScriptManager As ScriptManager = TryCast(ScriptManager.GetCurrent(Page), ScriptManager)

        'currPageScriptManager.RegisterAsyncPostBackControl(btnUpload)


        'Dim txtUlasanFail_FilePath As FileUpload = CType(row.FindControl("txtUlasanFail_FilePath"), FileUpload)
        'updateUploadFile(txtUlasanFail_FilePath)
    End Sub

    Private Sub gvTabUlasan_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvTabUlasan.RowDataBound

        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim btnUpload As Button = CType(e.Row.Cells(0).FindControl("btnUpload"), Button)
            Dim LinkButton1 As LinkButton

            If Request.Browser.IsMobileDevice Then
                LinkButton1 = CType(e.Row.Cells(0).FindControl("LinkButton1Mobile"), LinkButton)
            Else
                LinkButton1 = CType(e.Row.Cells(0).FindControl("LinkButton1"), LinkButton)
            End If

            If btnUpload IsNot Nothing Then

                Dim currPageScriptManager As ScriptManager = TryCast(ScriptManager.GetCurrent(Page), ScriptManager)

                'RegisterAsyncPostBackControl
                'currPageScriptManager.RegisterPostBackControl(btnUpload)
                currPageScriptManager.RegisterPostBackControl(LinkButton1)

            End If
        End If

    End Sub

    Private Sub gvTabUlasan_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvTabUlasan.RowDeleting

        If e.Values("UlasanFail_FilePath") <> "" Then

            Dim deleteFilePath As String = Server.MapPath(e.Values("UlasanFail_FilePath"))

            If System.IO.File.Exists(deleteFilePath) Then
                System.IO.File.Delete(deleteFilePath)
            End If


        End If

    End Sub

    Private Sub gvTabUlasan_DataBound(sender As Object, e As EventArgs) Handles gvTabUlasan.DataBound

    End Sub

    Protected Sub GridViewReport_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles GridViewReport.SelectedIndexChanged
        FormViewReport.ChangeMode(DetailsViewMode.Edit)
    End Sub

    Private Sub FormViewReport_ItemInserted(sender As Object, e As FormViewInsertedEventArgs) Handles FormViewReport.ItemInserted
        GridViewReport.DataBind()
    End Sub

    Private Sub FormViewReport_ItemUpdated(sender As Object, e As FormViewUpdatedEventArgs) Handles FormViewReport.ItemUpdated
        ShowAlert("success", "", "Rekod berjaya dikemaskini")
        GridViewReport.DataBind()
    End Sub

    Private Sub GridViewReport_RowDeleted(sender As Object, e As GridViewDeletedEventArgs) Handles GridViewReport.RowDeleted
        ShowAlert("success", "", "Rekod berjaya dikemaskini")
        GridViewReport.DataBind()
    End Sub

    Private Sub GridView1_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles GridView1.RowCommand

        If e.CommandName = "Surat" Then
            Dim intRow As Integer = CInt(e.CommandArgument)
            Dim Permohonan_ID As String = CStr(Me.GridView1.DataKeys(intRow)("Permohonan_ID"))
            'Dim JenisLesenID As Integer = CInt(Me.GridView1.DataKeys(intRow)("JenisLesen_ID"))

            If GetIsSuratFail(Permohonan_ID) Then
                'MessageBox("ViewSuratKelulusanFail " & Permohonan_ID, Me)
                ViewSuratKelulusanFail(Permohonan_ID)
            Else
                'MessageBox("ViewSuratKelulusanAuto " & Permohonan_ID & " " & JenisLesenID, Me)
                ViewSuratKelulusanAuto(Permohonan_ID, True)
            End If

        ElseIf e.CommandName = "Lampiran1" Then
            Dim intRow As Integer = CInt(e.CommandArgument)
            Dim Permohonan_ID As String = CStr(Me.GridView1.DataKeys(intRow)("Permohonan_ID"))

            ViewLampiran(Permohonan_ID, "L1")

        ElseIf e.CommandName = "Lampiran2" Then
            Dim intRow As Integer = CInt(e.CommandArgument)
            Dim Permohonan_ID As String = CStr(Me.GridView1.DataKeys(intRow)("Permohonan_ID"))

            ViewLampiran(Permohonan_ID, "L2")

        End If

    End Sub

    Private Sub ViewLampiran(permohonanID As String, jenisLampiran As String)

        Dim filepath As String = ""

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQL As String = "SELECT PermohonanFail_FilePath FROM LESEN_PermohonanFail WHERE PermohonanFail_PermohonanID = @permohonanID AND PermohonanFail_JenisLampiran = @jenisLampiran"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@permohonanID", permohonanID)
            myCommandSelect.Parameters.AddWithValue("@jenisLampiran", jenisLampiran)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            Try
                If myReader.Read Then

                    filepath = myReader.Item("PermohonanFail_FilePath")
                    filepath = filepath.Remove(0, 1)
                    ScriptManager.RegisterClientScriptBlock(Me.Page, Me.[GetType](), "", "window.open('.." + filepath + "', '_blank', '');", True)
                Else
                    ShowAlert("error", "", "Tiada Lampiran")
                End If

            Catch ex As Exception

            End Try

            myReader.Close()
            myConnection.Close()

        End Using

    End Sub

    Private Sub ViewSuratKelulusanFail(permohonanID As String)

        Dim filepath As String = ""

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQL As String = "SELECT PermohonanFail_FilePath FROM LESEN_PermohonanFail WHERE PermohonanFail_PermohonanID = @permohonanID AND PermohonanFail_JenisLampiran = 'SK'"

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

    Private Sub ViewSuratKelulusanAuto(permohonanID As String, isPDF As Boolean)
        'Dim cb As CheckBox = DirectCast(FormView1.FindControl("CB_IsDigitalSign"), CheckBox)

        Dim sql As String = ""

        Try

            sql = "SELECT a.Permohonan_ID, a.TarikhSuratKelulusan, a.CreatedDt, CAST(a.NamaSyarikat AS varchar(200)) AS NamaSyarikat, 
                a.NoPendaftaran, a.NoAkaun, a.AlamatPremis, a.JenisPerniagaan, a.PemilikBaru, a.AlamatBaru, 
                a.JenisPerniagaanBaru, a.NamaBaruSyarikat, a.BillboardLokasi, a.LokasiPasar1, a.LokasiPasar2, 
                a.LokasiPasar3, a.JenisPasar, a.JenisPerniagaanPasar, a.JumlahPetak, a.AnjingAlamat, a.AnjingJenisMohon, 
                a.AnjingJenisPremis, a.AlamatPenjajaan, a.JenisPerniagaanPenjaja, a.TarikhBatal, a.PenganjurEkspo, 
                a.NamaEkspo, a.LokasiEkspo, a.NoTelEkspo, a.TarikhEkspo1, a.TarikhEkspo2, a.MasaEkspo1, a.MasaEkspo2, 
                a.Rujukan, a.NoAkaunCukai, a.IsBatal, a.JenisLesenDescList, a.JenisLesenIdList, a.SaizIklanList, 
                a.CahayaIklanList, a.UnitIklanList, a.BakaAnjingList, a.AnjingJantanList, a.AnjingBetinaList, 
                a.AnjingJantanMandulList, a.AnjingBetinaMandulList, 
                b.Pemohon_Name, b.Pemohon_Address, b.Pemohon_ICNo, b.Pemohon_MobileNo, b.Pemohon_TelNo, 
                c.Users_Fullname, c.Users_Signature, d.P1, d.P2, d.P3, d.IsiKandungan 
                FROM LESEN_Permohonan a 
                INNER JOIN LESEN_Pemohon b ON b.Pemohon_ID=a.Permohonan_PemohonID 
                LEFT JOIN TBL_USERS c ON a.TandatanganKelulusanId=c.Users_Id 
                LEFT JOIN LESEN_PermohonanSurat d ON d.Permohonan_ID=a.Permohonan_ID 
                WHERE a.Permohonan_ID=@permohonanID ORDER BY d.P1, d.P2, d.P3"

            sql = sql.Replace("@permohonanID", permohonanID)

            Dim ReportVar As String

            ReportVar = "suratkelulusan_v2"

            Dim pobjData(1, 1)
            Dim lStrReportName = ReportVar + ".rpt"

            pobjData(0, 0) = "paraSQL" : pobjData(0, 1) = sql
            pobjData(1, 0) = "isDigitalSign" : pobjData(1, 1) = isPDF

            Session.Item("ReportName" + ReportVar) = lStrReportName
            Session.Item("pobjData" + ReportVar) = pobjData
            Session.Item("pathUrl" + ReportVar) = "~/lesen/report/kelulusan"
            'MessageBox(Session.Item("pathUrl" + ReportVar), Me)

            If isPDF Then
                Session.Item("reportPrintType") = "pdf"
            End If

            ScriptManager.RegisterClientScriptBlock(Me.Page, Me.[GetType](), ReportVar, "window.open('../ReportViewer.aspx?name=" + ReportVar + "', '_blank', '');", True)
        Catch ex As Exception
            MessageBox(ex.Message, Me)
        End Try
    End Sub

    Private Function GetIsSuratFail(pid As Integer) As Boolean

        Dim isFail As Boolean

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQL As String = "SELECT IsSuratKelulusanFail FROM LESEN_Permohonan WHERE Permohonan_ID = @Permohonan_ID"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            Try
                If myReader.Read Then

                    isFail = CBool(myReader.Item("IsSuratKelulusanFail"))

                End If

            Catch ex As Exception
                MessageBox(ex.Message, Me)
            End Try

            myReader.Close()
            myConnection.Close()

        End Using

        Return isFail

    End Function

    Protected Sub BT_ViewMail_Command(sender As Object, e As CommandEventArgs)

        Dim pid As Integer = CInt(Me.FormView1.DataKey("Permohonan_ID"))

        'MessageBox("View Mail " & pid.ToString & "/" & jid.ToString, Me)

        If GetIsSuratFail(pid) Then
            ViewSuratKelulusanFail(pid)
        Else
            ViewSuratKelulusanAuto(pid, True)
        End If

    End Sub

    Protected Sub BT_Generate_Command(sender As Object, e As CommandEventArgs)

        'Dim jid As String = CStr(Me.FormView1.DataKey("JenisLesenIdList"))
        Dim jidList() As String = CStr(GridView1.SelectedDataKey.Values("JenisLesenIdList")).Split(","c)
        Dim pid As Integer = CInt(Me.FormView1.DataKey("Permohonan_ID"))
        Dim sid As Integer = CInt(Me.FormView1.DataKey("ApprStatusID"))

        'MessageBox("Generate Mail " & pid.ToString & "/" & jid.ToString, Me)

        Dim jenisReport As String = "SKL"
        Dim rujukan As String = ""
        Dim tarikhmohon As String = ""
        Dim jenispasar As String = ""
        Dim jumlahpetak As String = ""
        Dim jenisperniagaanpasar As String = ""
        Dim lokasipasar As String = ""
        Dim totalamount As Double = 0

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQL3 As String = "SELECT ISNULL(SUM(KadarBayaran_Amount), 0) AS TotalAmount FROM LESEN_KadarBayaran WHERE KadarBayaran_PermohonanID = @Permohonan_ID AND IsSelect = 1"

            Dim myCommandSelect3 As New SqlCommand(SQL3, myConnection)
            myCommandSelect3.Parameters.AddWithValue("@Permohonan_ID", pid)

            Dim myReader3 As SqlDataReader = myCommandSelect3.ExecuteReader

            Try
                If myReader3.Read Then

                    totalamount = myReader3.Item("TotalAmount")

                End If

            Catch ex As Exception
                MessageBox(ex.Message, Me)
            End Try

            myReader3.Close()
            myConnection.Close()

            If totalamount = 0 Then
                ShowAlert("error", "", "Gagal menjana surat kelulusan. Sila semak semula dan pilih kadar bayaran yang berkenaan.")
                Exit Sub
            End If

            myConnection.Open()

            Dim SQL4 As String = "SELECT Rujukan, CONVERT(varchar, TarikhMohon, 103) AS TarikhMohon, JenisPasar, JenisPerniagaanPasar, JumlahPetak, LokasiPasar1, LokasiPasar2, LokasiPasar3 FROM LESEN_Permohonan WHERE Permohonan_ID = @Permohonan_ID"

            Dim myCommandSelect4 As New SqlCommand(SQL4, myConnection)
            myCommandSelect4.Parameters.AddWithValue("@Permohonan_ID", pid)

            Dim myReader4 As SqlDataReader = myCommandSelect4.ExecuteReader

            Try
                If myReader4.Read Then

                    rujukan = myReader4.Item("Rujukan").ToString
                    tarikhmohon = myReader4.Item("TarikhMohon").ToString
                    jenispasar = myReader4.Item("JenisPasar").ToString
                    jenisperniagaanpasar = myReader4.Item("JenisPerniagaanPasar").ToString
                    jumlahpetak = myReader4.Item("JumlahPetak").ToString
                    lokasipasar = myReader4.Item("LokasiPasar1").ToString

                    If myReader4.Item("LokasiPasar2").ToString.Length > 0 Then
                        lokasipasar = lokasipasar & ", " & myReader4.Item("LokasiPasar2").ToString
                    End If

                    If myReader4.Item("LokasiPasar3").ToString.Length > 0 Then
                        lokasipasar = lokasipasar & ", " & myReader4.Item("LokasiPasar3").ToString
                    End If

                End If

            Catch ex As Exception
                MessageBox(ex.Message, Me)
            End Try

            myReader4.Close()
            myConnection.Close()

            myConnection.Open()

            Dim SQL As String = "DELETE FROM LESEN_PermohonanSurat WHERE Permohonan_ID=@Permohonan_ID AND JenisReport=@JenisReport; 
                    INSERT INTO LESEN_PermohonanSurat (Permohonan_ID, JenisReport, P1, P2, P3, IsiKandungan, CreatedDt, ModDt)
                    SELECT @Permohonan_ID AS Permohonan_ID, JenisReport, P1, P2, P3, 
                    REPLACE(
                        REPLACE(
                            REPLACE(
                                REPLACE(
                                    REPLACE(
                                        REPLACE(
                                            REPLACE(
                                                REPLACE(CAST(IsiKandungan AS VARCHAR(MAX)), '{@TahunIni}', @@TahunIni), 
                                            '{@JumlahKadarBayaran}', @@JumlahKadarBayaran), 
                                        '{@Rujukan}', IIF(CHARINDEX(' ', @@Rujukan) > 0, @@Rujukan, REPLACE(@@Rujukan, 'MPK/599/401/', 'MPK/599/401/ ')) ),
                                    '{@TarikhMohon}',@@TarikhMohon),
                                '{@JenisPasar}',@@JenisPasar),
                            '{@JenisPerniagaanPasar}',@@JenisPerniagaanPasar),
                        '{@JumlahPetak}',@@JumlahPetak),
                    '{@LokasiPasar}',@@LokasiPasar) AS IsiKandungan, 
                    GETDATE() AS CreatedDt, GETDATE() AS ModDt 
                    FROM LESEN_ReportTemplate
                    WHERE JenisLesen_ID=@JenisLesen_ID AND JenisReport=@JenisReport;"

            If sid = 9 Then
                jenisReport = "SKB"
            End If

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@JenisLesen_ID", jidList(0))
            myCommandSelect.Parameters.AddWithValue("@JenisReport", jenisReport)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)

            myCommandSelect.Parameters.AddWithValue("@@TahunIni", DateTime.Now.Year.ToString)
            myCommandSelect.Parameters.AddWithValue("@@JumlahKadarBayaran", totalamount.ToString("N2"))
            myCommandSelect.Parameters.AddWithValue("@@Rujukan", rujukan)
            myCommandSelect.Parameters.AddWithValue("@@TarikhMohon", tarikhmohon)
            myCommandSelect.Parameters.AddWithValue("@@JenisPasar", jenispasar)
            myCommandSelect.Parameters.AddWithValue("@@JenisPerniagaanPasar", jenisperniagaanpasar)
            myCommandSelect.Parameters.AddWithValue("@@JumlahPetak", jumlahpetak)
            myCommandSelect.Parameters.AddWithValue("@@LokasiPasar", lokasipasar)

            Try
                myCommandSelect.ExecuteNonQuery()
                ShowAlert("success", "", "Surat kelulusan berjaya dijana.")
                GridViewReport.DataBind()
            Catch ex As Exception
                MessageBox(ex.Message, Me)
            End Try

            myConnection.Close()

        End Using

    End Sub

    Protected Sub btnSaveLetter_Click(sender As Object, e As EventArgs)

        If CB_SuratFail.Checked And ((FU_Lampiran3.Visible = True And FU_Lampiran3.HasFile = False) Or
            (HL_Lampiran3.Visible = True And HL_Lampiran3.Text.Length < 1)) Then

            ShowAlert("error", "", "Sila pilih fail surat yang ingin dimuat naik.")
            Return

        End If

        Dim isSuccess As Boolean = True
        Dim PermohonanID As Integer = CInt(GridView1.SelectedDataKey.Values(0))

        If CB_SuratFail.Checked = False Then

            If TB_TarikhSurat.Text.Length = 0 Then

                ShowAlert("error", "", "Sila pilih tarikh surat.")
                Return

            End If

            'MessageBox(PermohonanID & " / " & ddlTandatangan.SelectedValue & " / " & TB_TarikhSurat.Text, Me)

            Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

                myConnection.Open()

                Dim SQL As String = "UPDATE LESEN_Permohonan SET TandatanganKelulusanId = @TandatanganKelulusanId, TarikhSuratKelulusan = @TarikhSuratKelulusan 
                                    WHERE Permohonan_ID = @Permohonan_ID"

                Dim myCommandSelect As New SqlCommand(SQL, myConnection)
                myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", PermohonanID)
                myCommandSelect.Parameters.AddWithValue("@TandatanganKelulusanId", ddlTandatangan.SelectedValue)
                myCommandSelect.Parameters.AddWithValue("@TarikhSuratKelulusan", TB_TarikhSurat.Text)

                Try
                    Dim recordset As Integer = myCommandSelect.ExecuteNonQuery()

                Catch ex As Exception
                    isSuccess = False
                    MessageBox(ex.Message, Me)
                End Try

                myConnection.Close()

            End Using

        End If

        Dim uid As Guid = Guid.NewGuid()

        If FU_Lampiran3.HasFile Then

            Dim fn As String = System.IO.Path.GetFileName(FU_Lampiran3.PostedFile.FileName)

            Dim localPath As String = "~/doc/" & "" & uid.ToString & fn
            Dim SaveLocation As String = Server.MapPath(localPath)

            If (FU_Lampiran3.PostedFile IsNot Nothing) AndAlso (FU_Lampiran3.PostedFile.ContentLength > 0) Then

                If updateUploadFile(FU_Lampiran3, SaveLocation) Then

                    Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

                        myConnection.Open()

                        Dim SQL As String = "INSERT INTO LESEN_PermohonanFail (PermohonanFail_PermohonanID, PermohonanFail_ContentType, PermohonanFail_FileName, PermohonanFail_FilePath, PermohonanFail_JenisLampiran) 
                        VALUES (@Permohonan_ID, @ContentType, @FileName, @FilePath, 'SK')"

                        Dim myCommandSelect As New SqlCommand(SQL, myConnection)
                        myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", PermohonanID)
                        myCommandSelect.Parameters.AddWithValue("@FileName", FU_Lampiran3.PostedFile.FileName)
                        myCommandSelect.Parameters.AddWithValue("@ContentType", FU_Lampiran3.PostedFile.ContentType)
                        myCommandSelect.Parameters.AddWithValue("@FilePath", localPath)

                        Try
                            Dim recordset As Integer = myCommandSelect.ExecuteNonQuery()
                            GetSuratFail(PermohonanID)
                        Catch ex As Exception
                            isSuccess = False
                            MessageBox("ERROR", Me)
                        End Try

                        myConnection.Close()

                    End Using

                Else

                End If

            Else

            End If
        Else

        End If

        If isSuccess Then

            ShowAlert("success", "", "Surat kelulusan telah dikemaskini.")

        End If

    End Sub

    Private Sub GetSuratFail(pid As Integer)

        BT_Cancel3.Visible = False
        HL_Lampiran3.Visible = False
        BT_Update3.Visible = False
        BT_Delete3.Visible = False

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQL As String = "SELECT PermohonanFail_FileName, PermohonanFail_FilePath, PermohonanFail_JenisLampiran FROM LESEN_PermohonanFail WHERE PermohonanFail_JenisLampiran = 'SK' AND PermohonanFail_PermohonanID = @Permohonan_ID"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            Try

                If myReader.Read Then

                    HL_Lampiran3.Text = myReader.Item("PermohonanFail_FileName").ToString
                    HL_Lampiran3.NavigateUrl = myReader.Item("PermohonanFail_FilePath").ToString

                    FU_Lampiran3.Visible = False
                    BT_Cancel3.Visible = False
                    HL_Lampiran3.Visible = True
                    BT_Update3.Visible = True
                    BT_Delete3.Visible = True

                End If

            Catch ex As Exception
                MessageBox("ERROR", Me)
            End Try

            myReader.Close()
            myConnection.Close()

        End Using
    End Sub

    Protected Sub CB_IsPublish_CheckedChanged(sender As Object, e As EventArgs)

        Dim PermohonanID As Integer = CInt(GridView1.SelectedDataKey.Values(0))
        Dim cb As CheckBox = DirectCast(FormView1.FindControl("CB_IsPublish"), CheckBox)
        Dim bt As LinkButton = DirectCast(FormView1.FindControl("BT_Generate"), LinkButton)

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQL As String = "UPDATE LESEN_Permohonan SET IsPublish = @IsPublish, LastModDt = GETDATE()   
                                    WHERE Permohonan_ID = @Permohonan_ID"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", PermohonanID)
            myCommandSelect.Parameters.AddWithValue("@IsPublish", cb.Checked.ToString)

            Try
                Dim recordset As Integer = myCommandSelect.ExecuteNonQuery()

                gvTabBayaran.DataBind()

                If cb.Checked Then
                    bt.Visible = False
                    tabSurat.Visible = False
                    ShowAlert("success", "", "Surat kelulusan diterbitkan.")
                Else
                    bt.Visible = True
                    tabSurat.Visible = True
                    ShowAlert("error", "", "Surat kelulusan tidak diterbitkan.")
                End If

            Catch ex As Exception
                MessageBox("ERROR", Me)
            End Try

            myConnection.Close()

        End Using

    End Sub

    Protected Sub BT_Lampiran1_Click(sender As Object, e As EventArgs)

        DeleteLampiran("L1")

        Dim uid As Guid = Guid.NewGuid()

        If FU_Lampiran1.HasFile Then

            Dim fn As String = System.IO.Path.GetFileName(FU_Lampiran1.PostedFile.FileName)

            Dim localPath As String = "~/doc/" & "" & uid.ToString & fn
            Dim SaveLocation As String = Server.MapPath(localPath)

            If (FU_Lampiran1.PostedFile IsNot Nothing) AndAlso (FU_Lampiran1.PostedFile.ContentLength > 0) Then

                If updateUploadFile(FU_Lampiran1, SaveLocation) Then

                    Dim PermohonanID As Integer = CInt(GridView1.SelectedDataKey.Values(0))

                    Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

                        myConnection.Open()

                        Dim SQL As String = "INSERT INTO LESEN_PermohonanFail (PermohonanFail_PermohonanID, PermohonanFail_ContentType, PermohonanFail_FileName, PermohonanFail_FilePath, PermohonanFail_JenisLampiran) 
                        VALUES (@Permohonan_ID, @ContentType, @FileName, @FilePath, 'L1')"

                        Dim myCommandSelect As New SqlCommand(SQL, myConnection)
                        myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", PermohonanID)
                        myCommandSelect.Parameters.AddWithValue("@FileName", FU_Lampiran1.PostedFile.FileName)
                        myCommandSelect.Parameters.AddWithValue("@ContentType", FU_Lampiran1.PostedFile.ContentType)
                        myCommandSelect.Parameters.AddWithValue("@FilePath", localPath)

                        Try
                            Dim recordset As Integer = myCommandSelect.ExecuteNonQuery()
                            GetLampiran(PermohonanID)
                        Catch ex As Exception
                            MessageBox("Error inserting to database", Me)
                        End Try

                        myConnection.Close()

                    End Using

                Else

                End If

            Else

            End If
        Else

        End If

    End Sub

    Protected Sub BT_Lampiran2_Click(sender As Object, e As EventArgs)

        DeleteLampiran("L2")

        Dim uid As Guid = Guid.NewGuid()

        If FU_Lampiran2.HasFile Then

            Dim fn As String = System.IO.Path.GetFileName(FU_Lampiran2.PostedFile.FileName)

            Dim localPath As String = "~/doc/" & "" & uid.ToString & fn
            Dim SaveLocation As String = Server.MapPath(localPath)

            If (FU_Lampiran2.PostedFile IsNot Nothing) AndAlso (FU_Lampiran2.PostedFile.ContentLength > 0) Then

                If updateUploadFile(FU_Lampiran2, SaveLocation) Then

                    Dim PermohonanID As Integer = CInt(GridView1.SelectedDataKey.Values(0))

                    Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

                        myConnection.Open()

                        Dim SQL As String = "INSERT INTO LESEN_PermohonanFail (PermohonanFail_PermohonanID, PermohonanFail_ContentType, PermohonanFail_FileName, PermohonanFail_FilePath, PermohonanFail_JenisLampiran) 
                        VALUES (@Permohonan_ID, @ContentType, @FileName, @FilePath, 'L2')"

                        Dim myCommandSelect As New SqlCommand(SQL, myConnection)
                        myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", PermohonanID)
                        myCommandSelect.Parameters.AddWithValue("@FileName", FU_Lampiran2.PostedFile.FileName)
                        myCommandSelect.Parameters.AddWithValue("@ContentType", FU_Lampiran2.PostedFile.ContentType)
                        myCommandSelect.Parameters.AddWithValue("@FilePath", localPath)

                        Try
                            Dim recordset As Integer = myCommandSelect.ExecuteNonQuery()
                            GetLampiran(PermohonanID)

                        Catch ex As Exception
                            MessageBox("Error inserting to database", Me)
                        End Try

                        myConnection.Close()

                    End Using

                    'e.NewValues("UlasanFail_FileName") = txtUlasanFail_FilePath.PostedFile.FileName
                    'e.NewValues("UlasanFail_ContentType") = txtUlasanFail_FilePath.PostedFile.ContentType
                    'e.NewValues("UlasanFail_FilePath") = localPath

                Else

                End If

            Else

            End If
        Else

        End If

    End Sub

    Private Sub GetLampiran(pid As Integer)

        FU_Lampiran1.Visible = True
        BT_Lampiran1.Visible = True
        FU_Lampiran2.Visible = True
        BT_Lampiran2.Visible = True

        BT_Cancel1.Visible = False
        HL_Lampiran1.Visible = False
        BT_Update1.Visible = False
        BT_Delete1.Visible = False
        BT_Cancel2.Visible = False
        HL_Lampiran2.Visible = False
        BT_Update2.Visible = False
        BT_Delete2.Visible = False

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQL As String = "SELECT PermohonanFail_FileName, PermohonanFail_FilePath, PermohonanFail_JenisLampiran FROM LESEN_PermohonanFail WHERE PermohonanFail_JenisLampiran <> 'U' AND PermohonanFail_PermohonanID = @Permohonan_ID"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            Try

                While myReader.Read

                    If myReader.Item("PermohonanFail_JenisLampiran").ToString = "L1" Then

                        HL_Lampiran1.Text = myReader.Item("PermohonanFail_FileName").ToString
                        HL_Lampiran1.NavigateUrl = myReader.Item("PermohonanFail_FilePath").ToString

                        FU_Lampiran1.Visible = False
                        BT_Lampiran1.Visible = False
                        BT_Cancel1.Visible = False
                        HL_Lampiran1.Visible = True
                        BT_Update1.Visible = True
                        BT_Delete1.Visible = True

                    ElseIf myReader.Item("PermohonanFail_JenisLampiran").ToString = "L2" Then

                        HL_Lampiran2.Text = myReader.Item("PermohonanFail_FileName").ToString
                        HL_Lampiran2.NavigateUrl = myReader.Item("PermohonanFail_FilePath").ToString

                        FU_Lampiran2.Visible = False
                        BT_Lampiran2.Visible = False
                        BT_Cancel2.Visible = False
                        HL_Lampiran2.Visible = True
                        BT_Update2.Visible = True
                        BT_Delete2.Visible = True

                    End If

                End While

            Catch ex As Exception
                MessageBox("ERROR", Me)
            End Try

            myReader.Close()
            myConnection.Close()

        End Using

    End Sub

    Protected Sub BT_Update1_Click(sender As Object, e As EventArgs)

        FU_Lampiran1.Visible = True
        BT_Lampiran1.Visible = True
        BT_Cancel1.Visible = True
        HL_Lampiran1.Visible = False
        BT_Update1.Visible = False
        BT_Delete1.Visible = False

    End Sub

    Protected Sub BT_Cancel1_Click(sender As Object, e As EventArgs)

        FU_Lampiran1.Visible = False
        BT_Lampiran1.Visible = False
        BT_Cancel1.Visible = False
        HL_Lampiran1.Visible = True
        BT_Update1.Visible = True
        BT_Delete1.Visible = True

    End Sub

    Protected Sub BT_Update2_Click(sender As Object, e As EventArgs)

        FU_Lampiran2.Visible = True
        BT_Lampiran2.Visible = True
        BT_Cancel2.Visible = True
        HL_Lampiran2.Visible = False
        BT_Update2.Visible = False
        BT_Delete2.Visible = False

    End Sub

    Protected Sub BT_Cancel2_Click(sender As Object, e As EventArgs)

        FU_Lampiran2.Visible = False
        BT_Lampiran2.Visible = False
        BT_Cancel2.Visible = False
        HL_Lampiran2.Visible = True
        BT_Update2.Visible = True
        BT_Delete2.Visible = True

    End Sub

    Protected Sub BT_Update3_Click(sender As Object, e As EventArgs)

        FU_Lampiran3.Visible = True
        BT_Cancel3.Visible = True
        HL_Lampiran3.Visible = False
        BT_Update3.Visible = False
        BT_Delete3.Visible = False

    End Sub

    Protected Sub BT_Cancel3_Click(sender As Object, e As EventArgs)

        FU_Lampiran3.Visible = False
        BT_Cancel3.Visible = False
        HL_Lampiran3.Visible = True
        BT_Update3.Visible = True
        BT_Delete3.Visible = True

    End Sub

    Protected Sub CB_SuratFail_CheckedChanged(sender As Object, e As EventArgs)

        If CB_SuratFail.Checked Then
            'BT_Generate.Visible = False
            'BT_Generate1.Visible = False
            pnlSuratFail.Visible = True
            pnlSuratAuto.Visible = False
        Else
            'BT_Generate.Visible = True
            'BT_Generate1.Visible = True
            pnlSuratFail.Visible = False
            pnlSuratAuto.Visible = True
        End If

    End Sub

    Protected Sub DeleteLampiran(lampiran As String)

        Dim pid As Integer = CInt(GridView1.SelectedDataKey.Values(0))

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQL As String = "DELETE FROM LESEN_PermohonanFail WHERE PermohonanFail_JenisLampiran = @JenisLampiran AND PermohonanFail_PermohonanID = @Permohonan_ID"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)
            myCommandSelect.Parameters.AddWithValue("@JenisLampiran", lampiran)

            Try
                Dim result = myCommandSelect.ExecuteNonQuery()

                If result > 0 And lampiran = "L1" Then

                    FU_Lampiran1.Visible = True
                    BT_Lampiran1.Visible = True

                    BT_Cancel1.Visible = False
                    HL_Lampiran1.Visible = False
                    BT_Update1.Visible = False
                    BT_Delete1.Visible = False

                ElseIf result > 0 And lampiran = "L2" Then

                    FU_Lampiran2.Visible = True
                    BT_Lampiran2.Visible = True

                    BT_Cancel2.Visible = False
                    HL_Lampiran2.Visible = False
                    BT_Update2.Visible = False
                    BT_Delete2.Visible = False

                ElseIf result > 0 And lampiran = "SK" Then

                    FU_Lampiran3.Visible = True

                    BT_Cancel3.Visible = False
                    HL_Lampiran3.Visible = False
                    BT_Update3.Visible = False
                    BT_Delete3.Visible = False

                End If

            Catch ex As Exception
                MessageBox("Error", Me)
            End Try

            myConnection.Close()

        End Using

    End Sub

    Protected Sub BT_Delete1_Click(sender As Object, e As EventArgs)
        DeleteLampiran("L1")
    End Sub

    Protected Sub BT_Delete2_Click(sender As Object, e As EventArgs)
        DeleteLampiran("L2")
    End Sub

    Protected Sub BT_Delete3_Click(sender As Object, e As EventArgs)
        DeleteLampiran("SK")
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

    Protected Sub txtSeqNo_TextChanged(sender As Object, e As EventArgs)

        Dim tb As TextBox = DirectCast(sender, TextBox)
        Dim row = DirectCast(tb.NamingContainer, GridViewRow)
        Dim kbId = DirectCast(row.FindControl("Label1"), Label).Text

        If tb.Text.Length > 0 Then

            Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

                Dim SQL As String = ""

                SQL = "UPDATE LESEN_KadarBayaran SET SeqNo = @SeqNo WHERE KadarBayaran_ID = @KadarBayaran_ID"

                Try

                    Dim myCommand As New SqlCommand(SQL, myConnection)
                    myCommand.Parameters.AddWithValue("@KadarBayaran_ID", kbId)
                    myCommand.Parameters.AddWithValue("@SeqNo", tb.Text)

                    myConnection.Open()

                    Dim recordset As Integer = myCommand.ExecuteNonQuery()

                    myConnection.Close()

                    gvTabBayaran.DataBind()

                    'Page.SetFocus(Me.ui_btnPageBottom.ClientID)

                Catch ex As Exception
                    MessageBox("ERROR", Me)
                End Try

            End Using

        End If

    End Sub


    Protected Sub BT_SuratMohonUlasan_Command(sender As Object, e As CommandEventArgs)

        Dim jenisLesenIdList As Integer = CStr(Me.FormView1.DataKey("JenislesenIdList"))
        Dim permohonanID As Integer = CInt(Me.FormView1.DataKey("Permohonan_ID"))
        Dim agensiID As Integer = CInt(Session.Item("sessionEstateID"))


        Dim sql As String = ""
        Dim jenisLesenDesc = {"mpk_suratmohonulasan_l", "mpk_suratmohonulasan_psr", "mpk_suratmohonulasan_anj", "mpk_suratmohonulasan_pjj", "mpk_suratmohonulasan_bb"}
        Dim jenisLesenDescLuar = {"mpk_suratmohonulasan_l", "mpk_suratmohonulasan_psr_l", "mpk_suratmohonulasan_anj_l", "mpk_suratmohonulasan_pjj_l", "mpk_suratmohonulasan_bb_l"}

        Try
            sql = "SELECT a.Permohonan_ID, a.TarikhMohon, a.CreatedDt, CAST(a.NamaSyarikat AS varchar(200)) AS NamaSyarikat, a.NoPendaftaran, a.NoAkaun, a.AlamatPremis, a.JenisPerniagaan, a.PemilikBaru, " &
            "a.AlamatBaru, a.JenisPerniagaanBaru, a.NamaBaruSyarikat, a.BillboardLokasi, a.LokasiPasar1, a.LokasiPasar2, a.LokasiPasar3, a.JenisPasar, a.JenisPerniagaanPasar, a.JumlahPetak, a.AnjingAlamat, " &
            "a.AnjingJenisMohon, a.AnjingJenisPremis, a.AlamatPenjajaan, a.JenisPerniagaanPenjaja, a.TarikhBatal, a.PenganjurEkspo, a.NamaEkspo, a.LokasiEkspo, a.NoTelEkspo, a.TarikhEkspo1, a.TarikhEkspo2, " &
            "a.MasaEkspo1, a.MasaEkspo2, a.Rujukan, a.NoAkaunCukai, a.IsBatal, a.JenisLesenDescList, a.JenisLesenIdList, a.SaizIklanList, a.CahayaIklanList, a.UnitIklanList, a.BakaAnjingList, a.AnjingJantanList, " &
            "a.AnjingBetinaList, a.AnjingJantanMandulList, a.AnjingBetinaMandulList, e.JabatanAgensi_Address, e.JabatanAgensi_Kepada, b.Pemohon_Name, b.Pemohon_ICNo, b.Pemohon_PassportNo, b.Pemohon_Address, " &
            "b.Pemohon_Email, b.Pemohon_MobileNo, b.Pemohon_TelNo, g.Users_Fullname, g.Users_Signature " &
            "FROM LESEN_Permohonan a INNER JOIN LESEN_Pemohon b ON a.Permohonan_PemohonID = b.Pemohon_ID INNER JOIN LESEN_PermohonanAgensi d ON a.Permohonan_ID = d.Permohonan_ID " &
            "INNER JOIN LESEN_JabatanAgensi e ON d.JabatanAgensi_ID = e.JabatanAgensi_ID " &
            "LEFT JOIN TBL_USERS g ON g.Users_Id = (case when e.JabatanAgensi_Type = 'J' then a.TandatanganMohonUlasanId when e.JabatanAgensi_Type = 'L' then a.TandatanganMohonUlasanLuarId end) " &
            "WHERE a.Permohonan_ID=" & permohonanID & " AND e.JabatanAgensi_ID = " & agensiID

            Dim ReportVar As String = jenisLesenDesc(0)

            Select Case jenisLesenIdList
                Case "2", "25"
                    ReportVar = jenisLesenDesc(1)
                Case "3"
                    ReportVar = jenisLesenDesc(2)
                Case "4"
                    ReportVar = jenisLesenDesc(3)
                Case "5"
                    ReportVar = jenisLesenDesc(4)
            End Select

            If getJabatanLesen(CInt(Session.Item("sessionEstateID"))) = False Then

                Select Case jenisLesenIdList
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

End Class
