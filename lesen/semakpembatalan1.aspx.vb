Imports System
Imports System.Configuration
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Drawing.Imaging
Imports System.IO

Partial Class semakpembatalan1
    Inherits System.Web.UI.Page

#Region "Fields & Constants"

    Private ReadOnly CS As String = ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString
    Private Const MaxFileSizeInBytes As Integer = 5 * 1024 * 1024 ' 5 MB
    Private isHaveButton As Boolean = False

#End Region

#Region "Page Lifecycle & Permissions"

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Page.Form.Attributes.Add("enctype", "multipart/form-data")

        If Not Page.IsPostBack Then
            If Session.Item("sessionEstateID") Is Nothing Then
                GridView1.Visible = False
                filterJenisLesen.Attributes.Add("style", "display:none")
                filterStatus.Attributes.Add("style", "display:none")
                TB_TarikhBatal.Attributes.Add("style", "display:none")
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
            ' Mobile view configuration for Ulasan tabs
            If Not Page.IsPostBack Then
                If Request.Browser.IsMobileDevice Then
                    gvTabUlasan.Columns(2).Visible = "false"
                    gvTabUlasan.Columns(3).Visible = "false"
                    gvTabUlasan.Columns(5).Visible = "false"
                    gvTabUlasan.Columns(4).Visible = "true"

                    gvTabUlasanLuar.Columns(2).Visible = "false"
                    gvTabUlasanLuar.Columns(3).Visible = "false"
                    gvTabUlasanLuar.Columns(5).Visible = "false"
                    gvTabUlasanLuar.Columns(4).Visible = "true"
                Else
                    gvTabUlasan.Columns(4).Visible = "false"
                    gvTabUlasanLuar.Columns(4).Visible = "false"
                End If
            End If
        Catch ex As Exception
        End Try
    End Sub

    Protected Sub Page_PreRenderComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRenderComplete
        Dim btnback As LinkButton = DirectCast(FormView1.FindControl("btnBack"), LinkButton)
        Dim btnsmu As LinkButton = DirectCast(FormView1.FindControl("BT_SuratMohonUlasan"), LinkButton)
        Dim btnviewmail As LinkButton = DirectCast(FormView1.FindControl("BT_ViewMail"), LinkButton)

        Dim frmview() As Object = {FormView1}
        Dim lbutton() As Object = {btnback, btnsmu, btnviewmail}
        Dim ctlDeny() As Object = {}

        Dim frmwrite As Boolean = GlobalClass.CheckPageWrite("Write", frmview, lbutton, ctlDeny)
        If frmwrite = False Then
            ' Deny write permission handling if required
        End If
    End Sub

    Private Sub initPageName()
        Dim menuName As String = GlobalClass.writeTitlePage(Request.QueryString("m_Id"), "")

        Dim idWindowTitle2 As HtmlGenericControl = DirectCast(FormView1.FindControl("idWindowTitle2"), HtmlGenericControl)
        Dim idWindowTitle3 As HtmlGenericControl = DirectCast(FormView1.FindControl("idWindowTitle3"), HtmlGenericControl)

        If String.IsNullOrEmpty(menuName) Then
            menuName = "Semak Pembatalan"
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

#Region "Filter & Search (Main GridView1)"

    Private Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearch.Click
        If Session.Item("sessionEstateID") Is Nothing AndAlso txtNoRujukan.Text.Trim().Length = 0 Then
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
        ' Hook for custom programmatic filter logic if needed
    End Sub

    Protected Sub GridView1_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles GridView1.SelectedIndexChanged
        FormView1.ChangeMode(DetailsViewMode.Edit)
        TabContainer1.Visible = True
        idListing.Visible = False

        Dim PermohonanID As Integer = CInt(GridView1.SelectedDataKey.Values(0))
        Dim ApprStatusID As Integer = CInt(GridView1.SelectedDataKey.Values(1))
        Dim IsFail As Boolean = CBool(GridView1.SelectedDataKey.Values(3))
        Dim IsPublish As Boolean = CBool(GridView1.SelectedDataKey.Values(4))

        If getJabatanLesen(CInt(Session.Item("sessionEstateID"))) = False OrElse ApprStatusID < 9 Then
            tabSurat.Visible = False
            tabLampiran.Visible = False
        Else
            tabSurat.Visible = True
            tabLampiran.Visible = True
            GetSuratContent(PermohonanID)
            GetLampiran(PermohonanID)
            GetMesyuarat(PermohonanID)

            If IsFail Then
                CB_SuratFail.Checked = True
                pnlSuratAuto.Visible = False
                pnlSuratFail.Visible = True
            Else
                CB_SuratFail.Checked = False
                pnlSuratAuto.Visible = True
                pnlSuratFail.Visible = False
            End If

            GetSuratFail(PermohonanID)

            If IsPublish Then
                tabSurat.Visible = False
            End If
        End If
    End Sub

    Private Sub GridView1_DataBound(sender As Object, e As EventArgs) Handles GridView1.DataBound
        If isHaveButton Then
            GridView1.Columns(7).Visible = True
        Else
            GridView1.Columns(7).Visible = False
        End If
    End Sub

    Private Sub GridView1_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles GridView1.RowDataBound
        Try
            Select Case e.Row.RowType
                Case DataControlRowType.DataRow
                    Dim LinkButton3 = DirectCast(e.Row.FindControl("LinkButton3"), LinkButton)
                    Dim LinkButton5 = DirectCast(e.Row.FindControl("LinkButton5"), LinkButton)
                    Dim LinkButton6 = DirectCast(e.Row.FindControl("LinkButton6"), LinkButton)
                    Dim LinkButton7 = DirectCast(e.Row.FindControl("LinkButton7"), LinkButton)

                    If (LinkButton3 IsNot Nothing AndAlso LinkButton3.Visible) OrElse
                       (LinkButton5 IsNot Nothing AndAlso LinkButton5.Visible) OrElse
                       (LinkButton6 IsNot Nothing AndAlso LinkButton6.Visible) OrElse
                       (LinkButton7 IsNot Nothing AndAlso LinkButton7.Visible) Then
                        isHaveButton = True
                    End If
            End Select
        Catch ex As Exception
        End Try

        Try
            If Session.Item("sessionEstateID") IsNot Nothing Then
                If e.Row.RowType = DataControlRowType.DataRow Then
                    Dim dtTmp As DateTime = Convert.ToDateTime(DataBinder.Eval(e.Row.DataItem, "TarikhMohon").ToString())
                    Dim is24h As Boolean = Convert.ToBoolean(DataBinder.Eval(e.Row.DataItem, "Is24jam").ToString())
                    Dim statusDesc As String = DataBinder.Eval(e.Row.DataItem, "StatusDesc").ToString()

                    If (((DateTime.Now - dtTmp).TotalHours > 24 AndAlso is24h) OrElse
                        ((DateTime.Now - dtTmp).TotalDays > 14 AndAlso Not is24h)) AndAlso
                        Not statusDesc.Contains("Permohonan Lulus") AndAlso
                        Not statusDesc.Contains("Peraku Tidak Sokong") Then

                        e.Row.BackColor = Color.FromName("#ff7070")
                    End If
                End If
            End If
        Catch ex As Exception
            MessageBox("Error checking delayed task.", Me)
        End Try
    End Sub

    Private Sub GridView1_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles GridView1.RowCommand
        If e.CommandName = "Surat" Then
            Dim intRow As Integer = CInt(e.CommandArgument)
            Dim Permohonan_ID As String = CStr(Me.GridView1.DataKeys(intRow)("Permohonan_ID"))

            If GetIsSuratFail(CInt(Permohonan_ID)) Then
                ViewSuratKelulusanFail(Permohonan_ID)
            Else
                ViewSuratPembatalanAuto(Permohonan_ID, True)
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

    Protected Sub GridView1_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs) Handles GridView1.RowDeleting
        Dim title As String = GridView1.Rows(e.RowIndex).Cells(1).Text
        GlobalClass.auditTrail(idWindowTitle.InnerText, title, "Nyah Aktif")
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
        GridView1.SelectedIndex = -1
        GridView1.DataBind()
    End Sub

#End Region

#Region "FormView Events (Maklumat Permohonan)"

    Private Sub FormView1_DataBound(sender As Object, e As EventArgs) Handles FormView1.DataBound
        initPageName()
    End Sub

    Protected Sub FormView1_ItemInserting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertEventArgs) Handles FormView1.ItemInserting
        Dim titleTxt As TextBox = DirectCast(FormView1.FindControl("txtJenisLesen_Description"), TextBox)
        Dim title As String = If(titleTxt IsNot Nothing, titleTxt.Text, "")
        GlobalClass.auditTrail(idWindowTitle.InnerText, title, "Maklumat")
    End Sub

    Protected Sub FormView1_ItemInserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertedEventArgs) Handles FormView1.ItemInserted
        ShowAlert("success", "", "Rekod berjaya disimpan")
        GridView1.DataBind()
    End Sub

    Protected Sub FormView1_ItemUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdateEventArgs) Handles FormView1.ItemUpdating
        Dim titleTxt As TextBox = DirectCast(FormView1.FindControl("txtJenisLesen_Description"), TextBox)
        Dim title As String = If(titleTxt IsNot Nothing, titleTxt.Text, "")
        GlobalClass.auditTrail(idWindowTitle.InnerText, title, "Kemaskini")
    End Sub

    Protected Sub FormView1_ItemUpdated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdatedEventArgs) Handles FormView1.ItemUpdated
        ShowAlert("success", "", "Rekod berjaya dikemaskini")
        GridView1.DataBind()
    End Sub

    Protected Sub CB_IsPublish_CheckedChanged(sender As Object, e As EventArgs)
        Dim PermohonanID As Integer = CInt(GridView1.SelectedDataKey.Values(0))
        Dim cb As CheckBox = DirectCast(FormView1.FindControl("CB_IsPublish"), CheckBox)

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "UPDATE LESEN_Permohonan SET IsPublish = @IsPublish, LastModDt = GETDATE() WHERE Permohonan_ID = @Permohonan_ID"
            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", PermohonanID)
            myCommandSelect.Parameters.AddWithValue("@IsPublish", cb.Checked.ToString())

            Try
                myCommandSelect.ExecuteNonQuery()

                If cb.Checked Then
                    tabSurat.Visible = False
                    ShowAlert("success", "", "Surat pembatalan diterbitkan.")
                Else
                    tabSurat.Visible = True
                    ShowAlert("error", "", "Surat pembatalan tidak diterbitkan.")
                End If
            Catch ex As Exception
                MessageBox("Error", Me)
            End Try
        End Using
    End Sub

#End Region

#Region "Tab 1: Surat Pembatalan (Auto & Fail)"

    Protected Sub CB_SuratFail_CheckedChanged(sender As Object, e As EventArgs)
        If CB_SuratFail.Checked Then
            pnlSuratFail.Visible = True
            pnlSuratAuto.Visible = False
        Else
            pnlSuratFail.Visible = False
            pnlSuratAuto.Visible = True
        End If
    End Sub

    Private Sub GetSuratContent(pid As Integer)
        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "SELECT SuratPembatalan1, SuratPembatalan2, TandatanganKelulusanId, TarikhSuratKelulusan FROM LESEN_Permohonan WHERE Permohonan_ID = @Permohonan_ID"
            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)
            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader()

            Try
                If myReader.Read() Then
                    If Not IsDBNull(myReader.Item("TarikhSuratKelulusan")) Then
                        TB_TarikhSurat.Text = CDate(myReader.Item("TarikhSuratKelulusan")).ToString("yyyy-MM-dd")
                    End If

                    If myReader.Item("TandatanganKelulusanId").ToString().Length > 0 Then
                        ddlTandatangan.SelectedValue = CInt(myReader.Item("TandatanganKelulusanId").ToString())
                    End If
                End If
            Catch ex As Exception
                MessageBox(ex.Message, Me)
            End Try
        End Using
    End Sub

    Protected Sub BT_Generate_Command(sender As Object, e As CommandEventArgs)
        Dim pid As Integer = CInt(GridView1.SelectedDataKey.Values(0))
        Dim sid As Integer = CInt(GridView1.SelectedDataKey.Values(1))
        Dim jidListStr As String = CStr(GridView1.SelectedDataKey.Values(2))
        Dim jidList() As String = jidListStr.Split(","c)
        Dim primaryJid As Integer = 1
        If jidList.Length > 0 AndAlso IsNumeric(jidList(0).Trim()) Then
            primaryJid = CInt(jidList(0).Trim())
        End If

        Dim jenisReport As String = If(sid = 9, "SPB", "SPL")
        Dim rujukan As String = ""
        Dim tarikhmohon As String = ""
        Dim sebabBatalPerm As String = ""
        Dim sebabBatalTanpaPerm As String = ""
        Dim tindakanBatal As String = ""

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()

            ' 1. Retrieve application details for keyword replacement
            Dim SQL4 As String = "SELECT a.Rujukan, CONVERT(varchar, a.TarikhMohon, 103) AS TarikhMohon, a.SebabBatalPerm, " &
                                 "LOWER(ISNULL(b.name, '')) AS SebabBatalTanpaPerm, LOWER(ISNULL(c.name, '')) AS TindakanBatal " &
                                 "FROM LESEN_Permohonan a " &
                                 "LEFT JOIN TBL_LOOKUPS b ON a.SebabBatalTanpaPerm = b.id " &
                                 "LEFT JOIN TBL_LOOKUPS c ON a.TindakanBatal = c.id WHERE a.Permohonan_ID = @Permohonan_ID"
            Dim myCommandSelect4 As New SqlCommand(SQL4, myConnection)
            myCommandSelect4.Parameters.AddWithValue("@Permohonan_ID", pid)
            Dim myReader4 As SqlDataReader = myCommandSelect4.ExecuteReader()

            Try
                If myReader4.Read() Then
                    rujukan = myReader4.Item("Rujukan").ToString()
                    tarikhmohon = myReader4.Item("TarikhMohon").ToString()
                    sebabBatalPerm = myReader4.Item("SebabBatalPerm").ToString()
                    sebabBatalTanpaPerm = myReader4.Item("SebabBatalTanpaPerm").ToString()
                    tindakanBatal = myReader4.Item("TindakanBatal").ToString()
                End If
            Catch ex As Exception
                MessageBox(ex.Message, Me)
            End Try
            myReader4.Close()

            ' 2. Determine if template exists in LESEN_ReportTemplate
            Dim isTemplateUsed As Boolean = False
            If DDL_SuratTemplat.SelectedIndex > 0 AndAlso DDL_SuratTemplat.SelectedValue <> "0" Then
                Dim namatemplatList() As String = CStr(DDL_SuratTemplat.SelectedValue).Split(","c)
                Dim namatemplat As String = If(namatemplatList.Length > 1, namatemplatList(1), namatemplatList(0))

                Dim SQLTemplate As String = "DELETE FROM LESEN_PermohonanSurat WHERE Permohonan_ID=@Permohonan_ID AND (JenisReport=@JenisReport OR JenisReport LIKE 'SP%'); " &
                                            "INSERT INTO LESEN_PermohonanSurat (Permohonan_ID, JenisReport, P1, P2, P3, IsiKandungan, CreatedDt, ModDt) " &
                                            "SELECT @Permohonan_ID AS Permohonan_ID, JenisReport, P1, P2, P3, " &
                                            "REPLACE(REPLACE(REPLACE(REPLACE( " &
                                            "CAST(IsiKandungan AS VARCHAR(MAX)), " &
                                            "'{@TahunIni}', @@TahunIni), " &
                                            "'{@Rujukan}', @@Rujukan), " &
                                            "'{@TarikhMohon}', @@TarikhMohon), " &
                                            "'{@Tindakan}', @@Tindakan) AS IsiKandungan, " &
                                            "GETDATE() AS CreatedDt, GETDATE() AS ModDt " &
                                            "FROM LESEN_ReportTemplate " &
                                            "WHERE JenisLesen_ID=@JenisLesen_ID AND JenisReport=@JenisReport AND NamaTemplat=@NamaTemplat;"

                Dim cmdTemplate As New SqlCommand(SQLTemplate, myConnection)
                cmdTemplate.Parameters.AddWithValue("@JenisLesen_ID", primaryJid)
                cmdTemplate.Parameters.AddWithValue("@JenisReport", jenisReport)
                cmdTemplate.Parameters.AddWithValue("@NamaTemplat", namatemplat)
                cmdTemplate.Parameters.AddWithValue("@Permohonan_ID", pid)
                cmdTemplate.Parameters.AddWithValue("@@TahunIni", DateTime.Now.Year.ToString())
                cmdTemplate.Parameters.AddWithValue("@@Rujukan", rujukan)
                cmdTemplate.Parameters.AddWithValue("@@TarikhMohon", tarikhmohon)
                cmdTemplate.Parameters.AddWithValue("@@Tindakan", If(tindakanBatal.Length > 0, "Jabatan ini telah mempertimbangkan supaya " & tindakanBatal, ""))

                Dim insertedRows As Integer = cmdTemplate.ExecuteNonQuery()
                If insertedRows > 0 Then
                    isTemplateUsed = True
                End If
            End If

            ' 3. Fallback to standard cancellation letter content from LESEN_JenisLesen
            If Not isTemplateUsed Then
                Dim isi1 As String = ""
                Dim isi2 As String = ""

                Dim SQLJenis As String = "SELECT JenisLesen_SuratBatalLulus1 AS isi1, JenisLesen_SuratBatalLulus2 AS isi2 FROM LESEN_JenisLesen WHERE JenisLesen_ID = @JenisLesen_ID"
                If sid = 9 Then
                    SQLJenis = "SELECT JenisLesen_SuratBatalGagal1 AS isi1, JenisLesen_SuratBatalGagal2 AS isi2 FROM LESEN_JenisLesen WHERE JenisLesen_ID = @JenisLesen_ID"
                End If

                Dim cmdJenis As New SqlCommand(SQLJenis, myConnection)
                cmdJenis.Parameters.AddWithValue("@JenisLesen_ID", primaryJid)
                Dim readerJenis As SqlDataReader = cmdJenis.ExecuteReader()

                Try
                    If readerJenis.Read() Then
                        isi1 = readerJenis.Item("isi1").ToString()
                        isi2 = readerJenis.Item("isi2").ToString()
                    End If
                Catch ex As Exception
                End Try
                readerJenis.Close()

                isi1 = isi1.Replace("{@TahunIni}", DateTime.Now.Year.ToString())
                isi2 = isi2.Replace("{@TahunIni}", DateTime.Now.Year.ToString())

                isi1 = isi1.Replace("{@Rujukan}", rujukan)
                isi2 = isi2.Replace("{@Rujukan}", rujukan)

                isi1 = isi1.Replace("{@TarikhMohon}", tarikhmohon)
                isi2 = isi2.Replace("{@TarikhMohon}", tarikhmohon)

                If sebabBatalPerm.Length > 0 Then
                    isi1 = isi1.Replace("{@Sebab}", "berdasarkan permohonan lesen tuan/puan pada <b>" & tarikhmohon & "</b>")
                    isi2 = isi2.Replace("{@Sebab}", "berdasarkan permohonan lesen tuan/puan pada <b>" & tarikhmohon & "</b>")
                ElseIf sebabBatalTanpaPerm.Length > 0 Then
                    isi1 = isi1.Replace("{@Sebab}", "kerana " & sebabBatalTanpaPerm)
                    isi2 = isi2.Replace("{@Sebab}", "kerana " & sebabBatalTanpaPerm)
                End If

                If tindakanBatal.Length > 0 Then
                    isi1 = isi1.Replace("{@Tindakan}", "Jabatan ini telah mempertimbangkan supaya " & tindakanBatal)
                    isi2 = isi2.Replace("{@Tindakan}", "Jabatan ini telah mempertimbangkan supaya " & tindakanBatal)
                End If

                ' Update LESEN_Permohonan
                Dim SQLUpdate As String = "UPDATE LESEN_Permohonan SET SuratPembatalan1 = @SuratPembatalan1, SuratPembatalan2 = @SuratPembatalan2 WHERE Permohonan_ID = @Permohonan_ID"
                Dim cmdUpdate As New SqlCommand(SQLUpdate, myConnection)
                cmdUpdate.Parameters.AddWithValue("@SuratPembatalan1", isi1)
                cmdUpdate.Parameters.AddWithValue("@SuratPembatalan2", isi2)
                cmdUpdate.Parameters.AddWithValue("@Permohonan_ID", pid)
                cmdUpdate.ExecuteNonQuery()

                ' Also populate LESEN_PermohonanSurat for GridViewReport
                Dim SQLSurat As String = "DELETE FROM LESEN_PermohonanSurat WHERE Permohonan_ID=@Permohonan_ID AND (JenisReport=@JenisReport OR JenisReport LIKE 'SP%'); " &
                                         "INSERT INTO LESEN_PermohonanSurat (Permohonan_ID, JenisReport, P1, P2, P3, IsiKandungan, CreatedDt, ModDt) VALUES " &
                                         "(@Permohonan_ID, @JenisReport, 1, 0, 0, @P1Content, GETDATE(), GETDATE()); "
                If isi2.Trim().Length > 0 Then
                    SQLSurat &= "INSERT INTO LESEN_PermohonanSurat (Permohonan_ID, JenisReport, P1, P2, P3, IsiKandungan, CreatedDt, ModDt) VALUES " &
                                "(@Permohonan_ID, @JenisReport, 2, 0, 0, @P2Content, GETDATE(), GETDATE()); "
                End If

                Dim cmdSurat As New SqlCommand(SQLSurat, myConnection)
                cmdSurat.Parameters.AddWithValue("@Permohonan_ID", pid)
                cmdSurat.Parameters.AddWithValue("@JenisReport", jenisReport)
                cmdSurat.Parameters.AddWithValue("@P1Content", isi1)
                cmdSurat.Parameters.AddWithValue("@P2Content", isi2)
                cmdSurat.ExecuteNonQuery()
            End If

            GetSuratContent(pid)
            GridViewReport.DataBind()
            ShowAlert("success", "", "Surat pembatalan berjaya dijana.")
        End Using
    End Sub

    Protected Sub btnSaveLetter_Click(sender As Object, e As EventArgs)
        If CB_SuratFail.Checked AndAlso ((FU_Lampiran3.Visible AndAlso Not FU_Lampiran3.HasFile) OrElse
            (HL_Lampiran3.Visible AndAlso HL_Lampiran3.Text.Length < 1)) Then
            ShowAlert("error", "", "Sila pilih fail surat yang ingin dimuat naik.")
            Return
        End If

        Dim isSuccess As Boolean = True
        Dim PermohonanID As Integer = CInt(GridView1.SelectedDataKey.Values(0))

        If Not CB_SuratFail.Checked Then
            If TB_TarikhSurat.Text.Length = 0 Then
                ShowAlert("error", "", "Sila pilih tarikh surat.")
                Return
            End If

            Using myConnection As New SqlConnection(CS)
                myConnection.Open()
                Dim SQL As String = "UPDATE LESEN_Permohonan SET TandatanganKelulusanId = @TandatanganKelulusanId, TarikhSuratKelulusan = @TarikhSuratKelulusan WHERE Permohonan_ID = @Permohonan_ID"
                Dim myCommandSelect As New SqlCommand(SQL, myConnection)
                myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", PermohonanID)
                myCommandSelect.Parameters.AddWithValue("@TandatanganKelulusanId", ddlTandatangan.SelectedValue)
                myCommandSelect.Parameters.AddWithValue("@TarikhSuratKelulusan", TB_TarikhSurat.Text)

                Try
                    myCommandSelect.ExecuteNonQuery()
                Catch ex As Exception
                    isSuccess = False
                    MessageBox(ex.Message, Me)
                End Try
            End Using
        End If

        Dim uid As Guid = Guid.NewGuid()

        If FU_Lampiran3.HasFile Then
            Dim fn As String = System.IO.Path.GetFileName(FU_Lampiran3.PostedFile.FileName)
            Dim localPath As String = "~/doc/" & uid.ToString() & fn
            Dim SaveLocation As String = Server.MapPath(localPath)

            If FU_Lampiran3.PostedFile IsNot Nothing AndAlso FU_Lampiran3.PostedFile.ContentLength > 0 Then
                If updateUploadFile(FU_Lampiran3, SaveLocation) Then
                    Using myConnection As New SqlConnection(CS)
                        myConnection.Open()
                        Dim SQL As String = "INSERT INTO LESEN_PermohonanFail (PermohonanFail_PermohonanID, PermohonanFail_ContentType, PermohonanFail_FileName, PermohonanFail_FilePath, PermohonanFail_JenisLampiran) " &
                                            "VALUES (@Permohonan_ID, @ContentType, @FileName, @FilePath, 'SB')"
                        Dim myCommandSelect As New SqlCommand(SQL, myConnection)
                        myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", PermohonanID)
                        myCommandSelect.Parameters.AddWithValue("@FileName", FU_Lampiran3.PostedFile.FileName)
                        myCommandSelect.Parameters.AddWithValue("@ContentType", FU_Lampiran3.PostedFile.ContentType)
                        myCommandSelect.Parameters.AddWithValue("@FilePath", localPath)

                        Try
                            myCommandSelect.ExecuteNonQuery()
                            GetSuratFail(PermohonanID)
                        Catch ex As Exception
                            isSuccess = False
                            MessageBox("ERROR", Me)
                        End Try
                    End Using
                End If
            End If
        End If

        If isSuccess Then
            ShowAlert("success", "", "Surat pembatalan telah dikemaskini.")
        End If
    End Sub

    Private Sub GetSuratFail(pid As Integer)
        BT_Cancel3.Visible = False
        HL_Lampiran3.Visible = False
        BT_Update3.Visible = False
        BT_Delete3.Visible = False

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "SELECT PermohonanFail_FileName, PermohonanFail_FilePath, PermohonanFail_JenisLampiran FROM LESEN_PermohonanFail WHERE PermohonanFail_JenisLampiran = 'SB' AND PermohonanFail_PermohonanID = @Permohonan_ID"
            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)
            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader()

            Try
                If myReader.Read() Then
                    HL_Lampiran3.Text = myReader.Item("PermohonanFail_FileName").ToString()
                    HL_Lampiran3.NavigateUrl = myReader.Item("PermohonanFail_FilePath").ToString()

                    FU_Lampiran3.Visible = False
                    BT_Cancel3.Visible = False
                    HL_Lampiran3.Visible = True
                    BT_Update3.Visible = True
                    BT_Delete3.Visible = True
                End If
            Catch ex As Exception
                MessageBox("ERROR", Me)
            End Try
        End Using
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

    Protected Sub BT_Delete3_Click(sender As Object, e As EventArgs)
        DeleteLampiran("SB")
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

#End Region

#Region "Tab 2: Lampiran (Syarat & Bil)"

    Protected Sub BT_Lampiran1_Click(sender As Object, e As EventArgs)
        DeleteLampiran("L1")
        Dim uid As Guid = Guid.NewGuid()

        If FU_Lampiran1.HasFile Then
            Dim fn As String = System.IO.Path.GetFileName(FU_Lampiran1.PostedFile.FileName)
            Dim localPath As String = "~/doc/" & uid.ToString() & fn
            Dim SaveLocation As String = Server.MapPath(localPath)

            If FU_Lampiran1.PostedFile IsNot Nothing AndAlso FU_Lampiran1.PostedFile.ContentLength > 0 Then
                If updateUploadFile(FU_Lampiran1, SaveLocation) Then
                    Dim PermohonanID As Integer = CInt(GridView1.SelectedDataKey.Values(0))

                    Using myConnection As New SqlConnection(CS)
                        myConnection.Open()
                        Dim SQL As String = "INSERT INTO LESEN_PermohonanFail (PermohonanFail_PermohonanID, PermohonanFail_ContentType, PermohonanFail_FileName, PermohonanFail_FilePath, PermohonanFail_JenisLampiran) " &
                                            "VALUES (@Permohonan_ID, @ContentType, @FileName, @FilePath, 'L1')"
                        Dim myCommandSelect As New SqlCommand(SQL, myConnection)
                        myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", PermohonanID)
                        myCommandSelect.Parameters.AddWithValue("@FileName", FU_Lampiran1.PostedFile.FileName)
                        myCommandSelect.Parameters.AddWithValue("@ContentType", FU_Lampiran1.PostedFile.ContentType)
                        myCommandSelect.Parameters.AddWithValue("@FilePath", localPath)

                        Try
                            myCommandSelect.ExecuteNonQuery()
                            GetLampiran(PermohonanID)
                        Catch ex As Exception
                            MessageBox("Error inserting to database", Me)
                        End Try
                    End Using
                End If
            End If
        End If
    End Sub

    Protected Sub BT_Lampiran2_Click(sender As Object, e As EventArgs)
        DeleteLampiran("L2")
        Dim uid As Guid = Guid.NewGuid()

        If FU_Lampiran2.HasFile Then
            Dim fn As String = System.IO.Path.GetFileName(FU_Lampiran2.PostedFile.FileName)
            Dim localPath As String = "~/doc/" & uid.ToString() & fn
            Dim SaveLocation As String = Server.MapPath(localPath)

            If FU_Lampiran2.PostedFile IsNot Nothing AndAlso FU_Lampiran2.PostedFile.ContentLength > 0 Then
                If updateUploadFile(FU_Lampiran2, SaveLocation) Then
                    Dim PermohonanID As Integer = CInt(GridView1.SelectedDataKey.Values(0))

                    Using myConnection As New SqlConnection(CS)
                        myConnection.Open()
                        Dim SQL As String = "INSERT INTO LESEN_PermohonanFail (PermohonanFail_PermohonanID, PermohonanFail_ContentType, PermohonanFail_FileName, PermohonanFail_FilePath, PermohonanFail_JenisLampiran) " &
                                            "VALUES (@Permohonan_ID, @ContentType, @FileName, @FilePath, 'L2')"
                        Dim myCommandSelect As New SqlCommand(SQL, myConnection)
                        myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", PermohonanID)
                        myCommandSelect.Parameters.AddWithValue("@FileName", FU_Lampiran2.PostedFile.FileName)
                        myCommandSelect.Parameters.AddWithValue("@ContentType", FU_Lampiran2.PostedFile.ContentType)
                        myCommandSelect.Parameters.AddWithValue("@FilePath", localPath)

                        Try
                            myCommandSelect.ExecuteNonQuery()
                            GetLampiran(PermohonanID)
                        Catch ex As Exception
                            MessageBox("Error inserting to database", Me)
                        End Try
                    End Using
                End If
            End If
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

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "SELECT PermohonanFail_FileName, PermohonanFail_FilePath, PermohonanFail_JenisLampiran FROM LESEN_PermohonanFail WHERE PermohonanFail_JenisLampiran <> 'U' AND PermohonanFail_PermohonanID = @Permohonan_ID"
            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)
            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader()

            Try
                While myReader.Read()
                    Dim jenisLampiran As String = myReader.Item("PermohonanFail_JenisLampiran").ToString()

                    If jenisLampiran = "L1" Then
                        HL_Lampiran1.Text = myReader.Item("PermohonanFail_FileName").ToString()
                        HL_Lampiran1.NavigateUrl = myReader.Item("PermohonanFail_FilePath").ToString()

                        FU_Lampiran1.Visible = False
                        BT_Lampiran1.Visible = False
                        BT_Cancel1.Visible = False
                        HL_Lampiran1.Visible = True
                        BT_Update1.Visible = True
                        BT_Delete1.Visible = True

                    ElseIf jenisLampiran = "L2" Then
                        HL_Lampiran2.Text = myReader.Item("PermohonanFail_FileName").ToString()
                        HL_Lampiran2.NavigateUrl = myReader.Item("PermohonanFail_FilePath").ToString()

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
        End Using
    End Sub

    Protected Sub DeleteLampiran(lampiran As String)
        Dim pid As Integer = CInt(GridView1.SelectedDataKey.Values(0))

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "DELETE FROM LESEN_PermohonanFail WHERE PermohonanFail_JenisLampiran = @JenisLampiran AND PermohonanFail_PermohonanID = @Permohonan_ID"
            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)
            myCommandSelect.Parameters.AddWithValue("@JenisLampiran", lampiran)

            Try
                Dim result As Integer = myCommandSelect.ExecuteNonQuery()

                If result > 0 AndAlso lampiran = "L1" Then
                    FU_Lampiran1.Visible = True
                    BT_Lampiran1.Visible = True
                    BT_Cancel1.Visible = False
                    HL_Lampiran1.Visible = False
                    BT_Update1.Visible = False
                    BT_Delete1.Visible = False

                ElseIf result > 0 AndAlso lampiran = "L2" Then
                    FU_Lampiran2.Visible = True
                    BT_Lampiran2.Visible = True
                    BT_Cancel2.Visible = False
                    HL_Lampiran2.Visible = False
                    BT_Update2.Visible = False
                    BT_Delete2.Visible = False

                ElseIf result > 0 AndAlso lampiran = "SB" Then
                    FU_Lampiran3.Visible = True
                    BT_Cancel3.Visible = False
                    HL_Lampiran3.Visible = False
                    BT_Update3.Visible = False
                    BT_Delete3.Visible = False
                End If
            Catch ex As Exception
                MessageBox("Error", Me)
            End Try
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

    Protected Sub BT_Delete1_Click(sender As Object, e As EventArgs)
        DeleteLampiran("L1")
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

    Protected Sub BT_Delete2_Click(sender As Object, e As EventArgs)
        DeleteLampiran("L2")
    End Sub

#End Region

#Region "Tab 3: Ulasan IK & Agensi Luar"

    Private Sub gvTabUlasan_RowUpdating(sender As Object, e As GridViewUpdateEventArgs) Handles gvTabUlasan.RowUpdating
        Dim txtUlasanFail_FilePath As FileUpload
        If Request.Browser.IsMobileDevice Then
            txtUlasanFail_FilePath = CType(gvTabUlasan.Rows(e.RowIndex).FindControl("txtUlasanFail_FilePathMobile"), FileUpload)
        Else
            txtUlasanFail_FilePath = CType(gvTabUlasan.Rows(e.RowIndex).FindControl("txtUlasanFail_FilePath"), FileUpload)
        End If

        Dim uid As Guid = Guid.NewGuid()
        Dim fn As String = System.IO.Path.GetFileName(txtUlasanFail_FilePath.PostedFile.FileName)
        Dim localPath As String = "~/doc/" & uid.ToString() & fn
        Dim SaveLocation As String = Server.MapPath(localPath)

        If (txtUlasanFail_FilePath.PostedFile IsNot Nothing) AndAlso (txtUlasanFail_FilePath.PostedFile.ContentLength > 0) Then
            ' Delete previous file if replacing
            If Not String.IsNullOrEmpty(CStr(e.OldValues("UlasanFail_FilePath"))) Then
                Dim deleteFilePath As String = Server.MapPath(CStr(e.OldValues("UlasanFail_FilePath")))
                If System.IO.File.Exists(deleteFilePath) Then
                    System.IO.File.Delete(deleteFilePath)
                End If
            End If

            If updateUploadFile(txtUlasanFail_FilePath, SaveLocation) Then
                e.NewValues("UlasanFail_FileName") = txtUlasanFail_FilePath.PostedFile.FileName
                e.NewValues("UlasanFail_ContentType") = txtUlasanFail_FilePath.PostedFile.ContentType
                e.NewValues("UlasanFail_FilePath") = localPath
            End If
        End If
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
                If currPageScriptManager IsNot Nothing AndAlso LinkButton1 IsNot Nothing Then
                    currPageScriptManager.RegisterPostBackControl(LinkButton1)
                End If
            End If
        End If
    End Sub

    Private Sub gvTabUlasan_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvTabUlasan.RowDeleting
        If Not String.IsNullOrEmpty(CStr(e.Values("UlasanFail_FilePath"))) Then
            Dim deleteFilePath As String = Server.MapPath(CStr(e.Values("UlasanFail_FilePath")))
            If System.IO.File.Exists(deleteFilePath) Then
                System.IO.File.Delete(deleteFilePath)
            End If
        End If
    End Sub

    Private Sub gvTabUlasanLuar_RowUpdating(sender As Object, e As GridViewUpdateEventArgs) Handles gvTabUlasanLuar.RowUpdating
        Dim txtUlasanFail_FilePath As FileUpload
        If Request.Browser.IsMobileDevice Then
            txtUlasanFail_FilePath = CType(gvTabUlasanLuar.Rows(e.RowIndex).FindControl("txtUlasanFail_FilePathMobile"), FileUpload)
        Else
            txtUlasanFail_FilePath = CType(gvTabUlasanLuar.Rows(e.RowIndex).FindControl("txtUlasanFail_FilePath"), FileUpload)
        End If

        Dim uid As Guid = Guid.NewGuid()
        Dim fn As String = System.IO.Path.GetFileName(txtUlasanFail_FilePath.PostedFile.FileName)
        Dim localPath As String = "~/doc/" & uid.ToString() & fn
        Dim SaveLocation As String = Server.MapPath(localPath)

        If (txtUlasanFail_FilePath.PostedFile IsNot Nothing) AndAlso (txtUlasanFail_FilePath.PostedFile.ContentLength > 0) Then
            ' Delete previous file if replacing
            If Not String.IsNullOrEmpty(CStr(e.OldValues("UlasanFail_FilePath"))) Then
                Dim deleteFilePath As String = Server.MapPath(CStr(e.OldValues("UlasanFail_FilePath")))
                If System.IO.File.Exists(deleteFilePath) Then
                    System.IO.File.Delete(deleteFilePath)
                End If
            End If

            If updateUploadFile(txtUlasanFail_FilePath, SaveLocation) Then
                e.NewValues("UlasanFail_FileName") = txtUlasanFail_FilePath.PostedFile.FileName
                e.NewValues("UlasanFail_ContentType") = txtUlasanFail_FilePath.PostedFile.ContentType
                e.NewValues("UlasanFail_FilePath") = localPath
            End If
        End If
    End Sub

    Private Sub gvTabUlasanLuar_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvTabUlasanLuar.RowDataBound
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
                If currPageScriptManager IsNot Nothing AndAlso LinkButton1 IsNot Nothing Then
                    currPageScriptManager.RegisterPostBackControl(LinkButton1)
                End If
            End If
        End If
    End Sub

    Private Sub gvTabUlasanLuar_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvTabUlasanLuar.RowDeleting
        If Not String.IsNullOrEmpty(CStr(e.Values("UlasanFail_FilePath"))) Then
            Dim deleteFilePath As String = Server.MapPath(CStr(e.Values("UlasanFail_FilePath")))
            If System.IO.File.Exists(deleteFilePath) Then
                System.IO.File.Delete(deleteFilePath)
            End If
        End If
    End Sub

    Protected Sub btnUpload_Click(sender As Object, e As EventArgs)
        ' Handler stub for async postback attachment triggers
    End Sub

#End Region

#Region "Tab 5: Mesyuarat & Wang Amanah"

    Private Sub GetMesyuarat(pid As Integer)
        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "SELECT TarikhMesyuarat, KeputusanMesyuarat, TindakanBatal, NoMesyuarat, IsPulang, TarikhPulang, " &
                                "DepositAmount, DepositDate, DepositResitNo, DepositPulangAmount FROM LESEN_Permohonan WHERE Permohonan_ID = @Permohonan_ID"
            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)
            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader()

            If myReader.Read() Then
                If Not IsDBNull(myReader.Item("TarikhMesyuarat")) Then
                    TB_TarikhMesyuarat.Text = CDate(myReader.Item("TarikhMesyuarat")).ToString("yyyy-MM-dd")
                Else
                    TB_TarikhMesyuarat.Text = ""
                End If

                If Not IsDBNull(myReader.Item("TindakanBatal")) Then
                    Try
                        DDL_TindakanBatal.SelectedValue = myReader.Item("TindakanBatal").ToString()
                    Catch ex As Exception
                    End Try
                End If

                TB_NoMesyuarat.Text = myReader.Item("NoMesyuarat").ToString()
                CB_IsPulang.Checked = If(Not IsDBNull(myReader.Item("IsPulang")), CBool(myReader.Item("IsPulang")), False)
                pnlpulang.Visible = CB_IsPulang.Checked

                If Not IsDBNull(myReader.Item("TarikhPulang")) Then
                    TB_TarikhPulang.Text = CDate(myReader.Item("TarikhPulang")).ToString("yyyy-MM-dd")
                Else
                    TB_TarikhPulang.Text = ""
                End If

                ' Wang Amanah fields
                If Not IsDBNull(myReader.Item("DepositAmount")) Then
                    lblDepositAmount.Text = CDbl(myReader.Item("DepositAmount")).ToString("N2")
                Else
                    lblDepositAmount.Text = "0.00"
                End If

                If Not IsDBNull(myReader.Item("DepositDate")) Then
                    lblDepositDate.Text = CDate(myReader.Item("DepositDate")).ToString("dd/MM/yyyy")
                Else
                    lblDepositDate.Text = "-"
                End If

                If Not IsDBNull(myReader.Item("DepositResitNo")) Then
                    lblDepositResitNo.Text = myReader.Item("DepositResitNo").ToString()
                Else
                    lblDepositResitNo.Text = "-"
                End If

                If Not IsDBNull(myReader.Item("DepositPulangAmount")) Then
                    lblDepositPulangAmount.Text = CDbl(myReader.Item("DepositPulangAmount")).ToString("N2")
                Else
                    lblDepositPulangAmount.Text = "0.00"
                End If
            End If
        End Using
    End Sub

    Protected Sub BtnSaveMesyuarat_Click(sender As Object, e As EventArgs)
        Dim PermohonanID As Integer = CInt(GridView1.SelectedDataKey.Values(0))

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "UPDATE LESEN_Permohonan SET TarikhMesyuarat = @TarikhMesyuarat, TindakanBatal = @TindakanBatal, " &
                                "NoMesyuarat = @NoMesyuarat, IsPulang = @IsPulang, TarikhPulang = @TarikhPulang " &
                                "WHERE Permohonan_ID = @Permohonan_ID"

            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", PermohonanID)
            myCommandSelect.Parameters.AddWithValue("@TarikhMesyuarat", If(String.IsNullOrEmpty(TB_TarikhMesyuarat.Text), DBNull.Value, CObj(TB_TarikhMesyuarat.Text)))
            myCommandSelect.Parameters.AddWithValue("@TindakanBatal", If(String.IsNullOrEmpty(DDL_TindakanBatal.SelectedValue), DBNull.Value, CObj(DDL_TindakanBatal.SelectedValue)))
            myCommandSelect.Parameters.AddWithValue("@NoMesyuarat", TB_NoMesyuarat.Text.Trim())
            myCommandSelect.Parameters.AddWithValue("@IsPulang", CB_IsPulang.Checked.ToString())
            myCommandSelect.Parameters.AddWithValue("@TarikhPulang", If(String.IsNullOrEmpty(TB_TarikhPulang.Text), DBNull.Value, CObj(TB_TarikhPulang.Text)))

            Try
                myCommandSelect.ExecuteNonQuery()
                ShowAlert("success", "", "Rekod mesyuarat telah dikemaskini.")
            Catch ex As Exception
                MessageBox(ex.Message, Me)
            End Try
        End Using
    End Sub

    Protected Sub CB_IsPulang_CheckedChanged(sender As Object, e As EventArgs)
        If CB_IsPulang.Checked Then
            pnlpulang.Visible = True
        Else
            pnlpulang.Visible = False
        End If
    End Sub

#End Region

#Region "Report & Letter Generation"

    Protected Sub BT_ViewMail_Command(sender As Object, e As CommandEventArgs)
        Dim pid As Integer = CInt(Me.FormView1.DataKey("Permohonan_ID"))
        If GetIsSuratFail(pid) Then
            ViewSuratKelulusanFail(pid.ToString())
        Else
            ViewSuratPembatalanAuto(pid.ToString(), True)
        End If
    End Sub

    Private Sub ViewSuratPembatalanAuto(permohonanID As String, isPDF As Boolean)
        Dim jenisLesenDesc = {"", "sb_perniagaan", "sb_pasar", "sb_anjing", "sb_penjaja", "sb_billboard", "sb_tukaralamat", "sb_tambahpremis", "sb_tambahjenis",
            "sb_tukarpemilik", "sb_tukariklan", "sb_tukarnama", "sb_kurangiklan", "sb_kakilima", "null", "null", "sb_tambahiklan", "sb_tepikedai", "sb_lebuhawam",
            "sb_tukaralamatnamaiklan", "sb_tukarpemilikalamatiklan", "null", "null", "sb_tukarnamaiklan"}

        Dim jenisLesenIdList As String = ""
        If FormView1.DataKey("JenisLesenIdList") IsNot Nothing Then
            jenisLesenIdList = FormView1.DataKey("JenisLesenIdList").ToString()
        End If

        Dim primaryJid As Integer = 1
        If Not String.IsNullOrEmpty(jenisLesenIdList) Then
            Dim parts() As String = jenisLesenIdList.Split(","c)
            If parts.Length > 0 AndAlso IsNumeric(parts(0).Trim()) Then
                primaryJid = CInt(parts(0).Trim())
            End If
        End If

        Dim reportName As String = "sb_perniagaan"
        If primaryJid < jenisLesenDesc.Length AndAlso Not String.IsNullOrEmpty(jenisLesenDesc(primaryJid)) AndAlso jenisLesenDesc(primaryJid) <> "null" Then
            reportName = jenisLesenDesc(primaryJid)
        End If

        Try
            Dim sql As String = "SELECT b.*, c.Pemohon_Name, c.Pemohon_Address, c.Pemohon_ICNo, c.Pemohon_MobileNo, c.Pemohon_TelNo, d.Users_Fullname, d.Users_Signature, e.name AS AnjingJenisPremisDesc " &
                                "FROM LESEN_Permohonan b " &
                                "INNER JOIN LESEN_Pemohon c ON b.Permohonan_PemohonID = c.Pemohon_ID " &
                                "LEFT JOIN TBL_USERS d ON b.TandatanganKelulusanId = d.Users_Id " &
                                "LEFT JOIN TBL_LOOKUPS e ON e.id = b.AnjingJenisPremis " &
                                "WHERE b.Permohonan_ID = " & permohonanID

            Dim pobjData(0, 1) As Object
            Dim lStrReportName As String = reportName & ".rpt"

            pobjData(0, 0) = "paraSQL" : pobjData(0, 1) = sql

            Session.Item("ReportName" & reportName) = lStrReportName
            Session.Item("pobjData" & reportName) = pobjData
            Session.Item("pathUrl" & reportName) = "~/lesen/report/kelulusan"

            If isPDF Then
                Session.Item("reportPrintType") = "pdf"
            End If

            ScriptManager.RegisterClientScriptBlock(Me.Page, Me.GetType(), reportName, "window.open('../ReportViewer.aspx?name=" & reportName & "', '_blank', '');", True)
        Catch ex As Exception
            MessageBox(ex.Message, Me)
        End Try
    End Sub

    Private Sub ViewSuratKelulusanFail(permohonanID As String)
        Dim filepath As String = ""

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "SELECT PermohonanFail_FilePath FROM LESEN_PermohonanFail WHERE PermohonanFail_PermohonanID = @permohonanID AND PermohonanFail_JenisLampiran = 'SB'"
            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@permohonanID", permohonanID)
            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader()

            Try
                If myReader.Read() Then
                    filepath = myReader.Item("PermohonanFail_FilePath").ToString()
                    filepath = filepath.Remove(0, 1)
                    ScriptManager.RegisterClientScriptBlock(Me.Page, Me.GetType(), "", "window.open('.." & filepath & "', '_blank', '');", True)
                End If
            Catch ex As Exception
            End Try
        End Using
    End Sub

    Private Sub ViewLampiran(permohonanID As String, jenisLampiran As String)
        Dim filepath As String = ""

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "SELECT PermohonanFail_FilePath FROM LESEN_PermohonanFail WHERE PermohonanFail_PermohonanID = @permohonanID AND PermohonanFail_JenisLampiran = @jenisLampiran"
            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@permohonanID", permohonanID)
            myCommandSelect.Parameters.AddWithValue("@jenisLampiran", jenisLampiran)
            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader()

            Try
                If myReader.Read() Then
                    filepath = myReader.Item("PermohonanFail_FilePath").ToString()
                    filepath = filepath.Remove(0, 1)
                    ScriptManager.RegisterClientScriptBlock(Me.Page, Me.GetType(), "", "window.open('.." & filepath & "', '_blank', '');", True)
                Else
                    ShowAlert("error", "", "Tiada Lampiran")
                End If
            Catch ex As Exception
            End Try
        End Using
    End Sub

    Private Function GetIsSuratFail(pid As Integer) As Boolean
        Dim isFail As Boolean = False

        Using myConnection As New SqlConnection(CS)
            myConnection.Open()
            Dim SQL As String = "SELECT IsSuratPembatalanFail FROM LESEN_Permohonan WHERE Permohonan_ID = @Permohonan_ID"
            Dim myCommandSelect As New SqlCommand(SQL, myConnection)
            myCommandSelect.Parameters.AddWithValue("@Permohonan_ID", pid)
            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader()

            Try
                If myReader.Read() Then
                    isFail = CBool(myReader.Item("IsSuratPembatalanFail"))
                End If
            Catch ex As Exception
                MessageBox(ex.Message, Me)
            End Try
        End Using

        Return isFail
    End Function

    Protected Sub BT_SuratMohonUlasan_Command(sender As Object, e As CommandEventArgs)
        Dim jenisLesenIdList As String = ""
        If FormView1.DataKey("JenisLesenIdList") IsNot Nothing Then
            jenisLesenIdList = FormView1.DataKey("JenisLesenIdList").ToString()
        End If

        Dim primaryJid As Integer = 1
        If Not String.IsNullOrEmpty(jenisLesenIdList) Then
            Dim parts() As String = jenisLesenIdList.Split(","c)
            If parts.Length > 0 AndAlso IsNumeric(parts(0).Trim()) Then
                primaryJid = CInt(parts(0).Trim())
            End If
        End If

        Dim permohonanID As Integer = CInt(Me.FormView1.DataKey("Permohonan_ID"))
        Dim agensiID As Integer = CInt(Session.Item("sessionEstateID"))

        Dim jenisLesenDesc = {"", "smu_perniagaan", "smu_pasar", "smu_anjing", "smu_penjaja", "smu_billboard", "smu_tukaralamat", "smu_tambahpremis", "smu_tambahjenis",
            "smu_tukarpemilik", "smu_tukariklan", "smu_tukarnama", "smu_kurangiklan", "smu_kakilima", "smu_batal", "smu_ekspo", "smu_tambahiklan", "smu_tepikedai", "smu_lebuhawam",
            "smu_tukaralamatnamaiklan", "smu_tukarpemilikalamatiklan", "", "", "smu_tukarnamaiklan", "smu_tukarpemilikiklan"}

        Dim jenisLesenDescLuar = {"", "smul_perniagaan", "smul_pasar", "smul_anjing", "smul_penjaja", "smul_billboard", "smul_tukaralamat", "smul_tambahpremis", "smul_tambahjenis",
            "smul_tukarpemilik", "smul_tukariklan", "smul_tukarnama", "smul_kurangiklan", "smul_kakilima", "smul_batal", "smul_ekspo", "smul_tambahiklan", "smul_tepikedai", "smul_lebuhawam",
            "smul_tukaralamatnamaiklan", "smul_tukarpemilikalamatiklan", "", "", "smul_tukarnamaiklan", "smul_tukarpemilikiklan"}

        Try
            Dim sql As String = "SELECT a.*, f.name AS AnjingBakaDesc, e.JabatanAgensi_Address, e.JabatanAgensi_Kepada, c.JenisLesen_Description, b.Pemohon_Name, b.Pemohon_ICNo, b.Pemohon_PassportNo, b.Pemohon_Address, b.Pemohon_Email, b.Pemohon_MobileNo, b.Pemohon_TelNo, g.Users_Fullname, g.Users_Signature " &
                                "FROM LESEN_Permohonan a " &
                                "INNER JOIN LESEN_Pemohon b ON a.Permohonan_PemohonID = b.Pemohon_ID " &
                                "INNER JOIN LESEN_JenisLesen c ON a.JenisLesen_ID = c.JenisLesen_ID " &
                                "INNER JOIN LESEN_PermohonanAgensi d ON a.Permohonan_ID = d.Permohonan_ID " &
                                "INNER JOIN LESEN_JabatanAgensi e ON d.JabatanAgensi_ID = e.JabatanAgensi_ID " &
                                "LEFT JOIN TBL_LOOKUPS f ON f.id = a.AnjingBaka " &
                                "LEFT JOIN TBL_USERS g ON g.Users_Id = (CASE WHEN e.JabatanAgensi_Type = 'J' THEN a.TandatanganMohonUlasanId WHEN e.JabatanAgensi_Type = 'L' THEN a.TandatanganMohonUlasanLuarId END) " &
                                "WHERE a.Permohonan_ID=" & permohonanID & " AND e.JabatanAgensi_ID = " & agensiID

            Dim ReportVar As String = "smu_perniagaan"
            If primaryJid < jenisLesenDesc.Length AndAlso Not String.IsNullOrEmpty(jenisLesenDesc(primaryJid)) Then
                ReportVar = jenisLesenDesc(primaryJid)
            End If

            If getJabatanLesen(CInt(Session.Item("sessionEstateID"))) = False Then
                If primaryJid < jenisLesenDescLuar.Length AndAlso Not String.IsNullOrEmpty(jenisLesenDescLuar(primaryJid)) Then
                    ReportVar = jenisLesenDescLuar(primaryJid)
                Else
                    ReportVar = "smul_perniagaan"
                End If
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

    Private Function getJabatanLesen(agensiID As Integer) As Boolean
        Dim retval As Boolean = False

        Using myConnection As New SqlConnection(CS)
            Dim SQL As String = "SELECT 1 FROM LESEN_JabatanAgensi WHERE JabatanAgensi_IsLesen=1 AND JabatanAgensi_IsActive=1 AND JabatanAgensi_ID = @JabatanAgensi_ID"
            Dim myCommand As New SqlCommand(SQL, myConnection)
            myCommand.Parameters.AddWithValue("@JabatanAgensi_ID", agensiID)

            myConnection.Open()
            Dim myReader As SqlDataReader = myCommand.ExecuteReader()
            If myReader.Read() Then
                retval = True
            End If
        End Using

        If agensiID = 0 Then
            retval = True
        End If

        Return retval
    End Function

#End Region

#Region "File Upload & Scaling Helpers"

    Private Function updateUploadFile(txtUlasanFail_FilePath As FileUpload, saveLocation As String) As Boolean
        Dim retval As Boolean = True

        If (txtUlasanFail_FilePath.PostedFile IsNot Nothing) AndAlso (txtUlasanFail_FilePath.PostedFile.ContentLength > 0) Then
            Try
                Dim fileExtension As String = txtUlasanFail_FilePath.PostedFile.ContentType
                Dim fileLength As Integer = txtUlasanFail_FilePath.PostedFile.ContentLength

                If fileExtension = "image/png" OrElse fileExtension = "image/jpeg" OrElse fileExtension = "image/x-png" Then
                    If fileLength <= MaxFileSizeInBytes Then
                        Using bmpPostedImage As New System.Drawing.Bitmap(txtUlasanFail_FilePath.PostedFile.InputStream)
                            Using objImage As System.Drawing.Image = ScaleImage(bmpPostedImage, 1024)
                                objImage.Save(saveLocation, ImageFormat.Jpeg)
                            End Using
                        End Using
                        MessageBox("Fail berjaya dimuatnaik", Me)
                    Else
                        MessageBox("Image size cannot be more then 5 MB!", Me)
                        retval = False
                    End If
                Else
                    If fileLength <= MaxFileSizeInBytes Then
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
            End Try
        Else
            MessageBox("Muat naik fail gagal. Sila cuba sekali lagi", Me)
            retval = False
        End If

        Return retval
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

#End Region

#Region "Alert & Dialog Helpers"

    Public Sub MessageBox(ByVal Msg As String, ByVal obj As System.Web.UI.Page)
        Dim cleanMsg As String = Msg.Replace("'", "\'")
        ScriptManager.RegisterClientScriptBlock(Me.Page, Me.GetType(), "Alert", "alert('" & cleanMsg & "');", True)
    End Sub

    Private Sub ShowAlert(statusMsg As String, titleMsg As String, strMsg As String)
        Dim cleanTitle As String = titleMsg.Replace("'", "\'")
        Dim cleanStr As String = strMsg.Replace("'", "\'")
        ScriptManager.RegisterStartupScript(Me, Page.GetType(), "Script",
            "Swal.fire('" & cleanTitle & "', '" & cleanStr & "', '" & statusMsg & "');", True)
    End Sub

#End Region

End Class
