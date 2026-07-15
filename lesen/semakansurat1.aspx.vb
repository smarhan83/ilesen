
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Drawing.Imaging
Imports System.IO
Imports System.ServiceModel.PeerResolvers
Imports Microsoft.ReportingServices.Rendering.ExcelRenderer.ExcelGenerator.BIFF8

Partial Class semakansurat1
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
        'MsgBox(GridView1.SelectedValue)
        FormView1.ChangeMode(DetailsViewMode.Edit)
        fvApproval.ChangeMode(DetailsViewMode.Edit)
        TabContainer1.Visible = True
        idFooter.Visible = True
        idListing.Visible = False

        'showFormControl(GridView1)



    End Sub

    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs)

        '    Dim Permohonan_ID As Integer = CInt(GridView1.SelectedDataKey.Values(0))
        '    Dim AgensiID As Integer = If(IsDBNull(GridView1.SelectedDataKey.Values(1)), 0, CInt(GridView1.SelectedDataKey.Values(1)))
        '    Dim ApprStatusID As Integer = CInt(GridView1.SelectedDataKey.Values(2))

        '    Dim ddlSokongUlasan As DropDownList = DirectCast(fvSokongUlasan.FindControl("ddlSokongUlasan"), DropDownList)
        '    Dim txtNotaUlasan As TextBox = DirectCast(fvSokongUlasan.FindControl("txtNotaUlasan"), TextBox)
        '    Dim ddlPengesahSokongUlasan As DropDownList = DirectCast(fvSokongUlasan.FindControl("ddlPengesahSokongUlasan"), DropDownList)
        '    Dim txtPengesahNotaKelulusan As TextBox = DirectCast(fvSokongUlasan.FindControl("txtPengesahNotaKelulusan"), TextBox)

        '    Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

        '        Dim SQL As String = ""

        '        '2  Pilih Pegawai Lawatan Tapak Jabatan/Agensi
        '        '3  Lawatan Tapak Jabatan/Agensi
        '        '4	Pengesah Jabatan/Agensi
        '        '5	Pengesah Jabatan Lesen

        '        If AgensiID > 0 Then

        '            Dim fldName As String = "IsLawatanTapakUlasan"
        '            If ApprStatusID = 2 Then
        '                fldName = "StatusID"

        '                SQL = "UPDATE LESEN_PermohonanAgensi set " & fldName & " = 3, LastModDt = getdate() 
        '            where Permohonan_ID = @Permohonan_ID 
        '            and case when JabatanAgensi_ID is null then 0 else JabatanAgensi_ID end = @AgensiId "

        '            ElseIf ApprStatusID = 3 Then
        '                fldName = "IsLawatanTapakUlasan"

        '                SQL = "UPDATE LESEN_PermohonanAgensi set " & fldName & " = 1, LastModDt = getdate() 
        '            where Permohonan_ID = @Permohonan_ID 
        '            and case when JabatanAgensi_ID is null then 0 else JabatanAgensi_ID end = @AgensiId "

        '            ElseIf ApprStatusID = 4 Then
        '                fldName = "IsPenilaian"

        '                SQL = "UPDATE LESEN_PermohonanAgensi set " & fldName & " = 1, LastModDt = getdate(), 
        '            PengesahStatusID = @PengesahStatusID, PengesahNotaKelulusan = @PengesahNotaKelulusan,
        'PengesahID = @PengesahID
        '            where Permohonan_ID = @Permohonan_ID 
        '            and case when JabatanAgensi_ID is null then 0 else JabatanAgensi_ID end = @AgensiId "

        '                Try
        '                    Dim hdnFiedlJabatanAgensiType As HiddenField = DirectCast(fvSokongUlasan.FindControl("hdnFiedlJabatanAgensiType"), HiddenField)

        '                    If hdnFiedlJabatanAgensiType.Value = "L" Then
        '                        SQL = SQL & ";UPDATE LESEN_PermohonanAgensi set " & fldName & " = 1, LastModDt = getdate(),
        '                        StatusID = @PengesahStatusID, NotaKelulusan = @PengesahNotaKelulusan
        '                        where Permohonan_ID = @Permohonan_ID 
        '                        and case when JabatanAgensi_ID is null then 0 else JabatanAgensi_ID end = @AgensiId "
        '                    End If
        '                Catch ex As Exception

        '                End Try


        '            ElseIf ApprStatusID = 5 Then
        '                fldName = "IsPeraku"

        '                SQL = "UPDATE LESEN_PermohonanAgensi set " & fldName & " = 1, LastModDt = getdate(),
        '            StatusID = @StatusID, NotaKelulusan = @NotaKelulusan
        '            where Permohonan_ID = @Permohonan_ID 
        '            and case when JabatanAgensi_ID is null then 0 else JabatanAgensi_ID end = @AgensiId "

        '            End If

        '        Else

        '        End If

        '        Dim myCommand As New SqlCommand(SQL, myConnection)

        '        myCommand.Parameters.AddWithValue("@Permohonan_ID", Permohonan_ID)
        '        myCommand.Parameters.AddWithValue("@AgensiId", AgensiID)
        '        myCommand.Parameters.AddWithValue("@ApprStatusID", ApprStatusID)
        '        myCommand.Parameters.AddWithValue("@SessionUserName", Session.Item("SessionUserName"))
        '        myCommand.Parameters.AddWithValue("@StatusID", ddlSokongUlasan.SelectedValue)
        '        myCommand.Parameters.AddWithValue("@NotaKelulusan", txtNotaUlasan.Text)
        '        myCommand.Parameters.AddWithValue("@PengesahStatusID", ddlPengesahSokongUlasan.SelectedValue)
        '        myCommand.Parameters.AddWithValue("@PengesahNotaKelulusan", txtPengesahNotaKelulusan.Text)
        '        myCommand.Parameters.AddWithValue("@PengesahID", Session.Item("sessionUsersId"))

        '        myConnection.Open()

        '        Dim recordset As Integer = myCommand.ExecuteNonQuery()

        '        '//start insert

        '        If recordset Then
        '            ShowAlert("success", "", "Rekod berjaya dihantar")
        '        End If

        '        myConnection.Close()

        '    End Using

        GridView1.DataBind()
        backToList()

    End Sub


    'Private Sub showFormControl(gv1 As GridView)

    '    Dim idSokongUlasan As HtmlGenericControl = DirectCast(fvSokongUlasan.FindControl("idSokongUlasan"), HtmlGenericControl)
    '    Dim idSokongUlasanPengesah As HtmlGenericControl = DirectCast(fvSokongUlasan.FindControl("idSokongUlasanPengesah"), HtmlGenericControl)
    '    Dim hdnFiedlJabatanAgensiType As HiddenField = DirectCast(fvSokongUlasan.FindControl("hdnFiedlJabatanAgensiType"), HiddenField)
    '    Dim txtNotaKelulusanPengesah As TextBox = DirectCast(fvNotaKelulusan.FindControl("txtNotaKelulusanPengesah"), TextBox)
    '    Dim txtNotaKelulusan As TextBox = DirectCast(fvNotaKelulusan.FindControl("txtNotaKelulusan"), TextBox)

    '    Dim ApprStatusID As Integer = CInt(gv1.SelectedDataKey.Values(2))
    '    Dim PermohonanID As Integer = CInt(gv1.SelectedDataKey.Values(0))

    '    '2  mohon ulasan
    '    '3  Penilaian Jabatan/Agensi
    '    '4	Peraku Jabatan/Agensi
    '    '5	Penilaian Jabatan Lesen
    '    '8	Peraku Jabatan Lesen

    '    btnSubmit.Visible = False
    '    btnApprove.Visible = False
    '    btnReject.Visible = False
    '    idNotaKelulusan.Visible = False

    '    If ApprStatusID = 2 Or ApprStatusID = 3 Or ApprStatusID = 4 Then
    '        btnSubmit.Visible = True

    '        If ApprStatusID = 2 Then
    '            btnSubmit.Text = "Simpan"
    '        Else
    '            btnSubmit.Text = "Hantar Ulasan"
    '        End If

    '    ElseIf ApprStatusID = 5 Or ApprStatusID = 8 Then
    '        btnApprove.Visible = True
    '        btnReject.Visible = True
    '        idNotaKelulusan.Visible = True

    '        'Try
    '        '    If ApprStatusID = 8 Then
    '        '        txtNotaKelulusanPengesah.Enabled = False
    '        '    Else
    '        '        txtNotaKelulusanPengesah.Enabled = True
    '        '    End If
    '        'Catch ex As Exception

    '        'End Try


    '    End If

    '    '//hide tab kadar bayaran
    '    Try
    '        tabKadarBayaran.Visible = False
    '        tabSurat.Visible = False

    '        Dim agensiType As String = If(IsDBNull(gv1.SelectedDataKey.Values(3)), "J", gv1.SelectedDataKey.Values(3))

    '        If agensiType = "J" Then
    '            tabKadarBayaran.Visible = True
    '        End If

    '        '//tab surat
    '        If agensiType = "J" And (ApprStatusID = 3 Or ApprStatusID = 4) Then
    '            tabSurat.Visible = True
    '            GetSuratContent(PermohonanID)
    '        End If

    '    Catch ex As Exception

    '    End Try

    '    '//hide tab tetapan ik
    '    If ApprStatusID = 2 Then
    '        tabUlasan.Visible = False
    '        tabKadarBayaran.Visible = False
    '        tabTetapan.Visible = True
    '        tabSurat.Visible = False
    '    Else
    '        tabTetapan.Visible = False
    '        tabUlasan.Visible = True
    '    End If

    '    '//hide column edit for kadar bayaran
    '    If ApprStatusID = 5 Or ApprStatusID = 8 Then
    '        gvTabBayaran.Columns(5).Visible = "false"
    '        gvTabBayaran.Columns(6).Visible = "false"
    '    End If

    'End Sub

    '+++++++++ START FILTER +++++++++
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        '//generate filter
        'Dim gv As GridView = GridView1
        'Dim ds As SqlDataSource = SqlDataSourceGrid
        'GlobalClass.GenerateFilter(gv, ds, pnlFilter)

        Page.Form.Attributes.Add("enctype", "multipart/form-data")

        ''+++++ Selected column +++++
        'Dim lstColumn As New List(Of String)({"description"})
        'GlobalClass.GenerateFilter(gv, ds, pnlFilter, lstColumn)

        If Not Page.IsPostBack Then

            If Request.Browser.IsMobileDevice Then
                GridView1.Columns(0).Visible = "false"
                GridView1.Columns(1).Visible = "false"
                GridView1.Columns(2).Visible = "false"
                GridView1.Columns(3).Visible = "false"
                GridView1.Columns(4).Visible = "false"
                GridView1.Columns(5).Visible = "true"

            Else
                GridView1.Columns(5).Visible = "false"
            End If
        End If



        '//show filter
        If getJabatanLesen(CInt(Session.Item("sessionEstateID"))) = False Then
            filterJenisLesen.Attributes.Add("style", "display:none")
            filterPemohon.Attributes.Add("style", "display:none")
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

            Dim i As Integer = 0
            While myReader.Read
                'monthValueApprove = myReader("totCntApprove")
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

    Private Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearch.Click
        '//generate filter
        'Dim ds As SqlDataSource = SqlDataSourceGrid
        'GlobalClass.procSearch(ds, pnlFilter)

        GridView1.DataBind()
    End Sub

    Private Sub btnReset_Click(sender As Object, e As EventArgs) Handles btnReset.Click
        Response.Redirect(Request.RawUrl)
    End Sub
    Protected Sub GridView1_PageIndexChanged(sender As Object, e As EventArgs) Handles GridView1.PageIndexChanged
        'CallFilter()
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

        Dim frmview() As Object = {FormView1}
        Dim lbutton() As Object = {} '//allow control
        Dim ctlDeny() As Object = {} '//deny control


        'If FormView1.CurrentMode = FormViewMode.Insert Then
        '    lnkSMAF.Add(DirectCast(FormView1.FindControl("InsertCancelButton"), LinkButton)) '//insert cancel
        'ElseIf FormView1.CurrentMode = FormViewMode.Edit Then
        '    lnkSMAF.Add(DirectCast(FormView1.FindControl("UpdatePrintButton"), LinkButton)) '//print
        'End If

        '//check Write
        Dim frmwrite As Boolean = GlobalClass.CheckPageWrite("Write", frmview, lbutton, ctlDeny)
        '// check gridview permission
        If frmwrite = False Then
            '//gridview select view
            GridView1.Columns.Item(4).Visible = False '//grid delete

        End If
    End Sub

    Private Sub initPageName()
        '// get page name
        Dim menuName As String = GlobalClass.writeTitlePage(Request.QueryString("m_Id"), "")

        Dim idWindowTitle2 As HtmlGenericControl = DirectCast(FormView1.FindControl("idWindowTitle2"), HtmlGenericControl)
        Dim idWindowTitle3 As HtmlGenericControl = DirectCast(FormView1.FindControl("idWindowTitle3"), HtmlGenericControl)

        If menuName = "" Then
            menuName = "Jenis Lesen"
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
        idFooter.Visible = False
    End Sub

    Protected Sub btnViewDetail_Click(sender As Object, e As EventArgs)

    End Sub

    'Protected Sub btnSubmit_Click(sender As Object, e As EventArgs)

    '    Dim Permohonan_ID As Integer = CInt(GridView1.SelectedDataKey.Values(0))
    '    Dim AgensiID As Integer = If(IsDBNull(GridView1.SelectedDataKey.Values(1)), 0, CInt(GridView1.SelectedDataKey.Values(1)))
    '    Dim ApprStatusID As Integer = CInt(GridView1.SelectedDataKey.Values(2))

    '    Dim ddlSokongUlasan As DropDownList = DirectCast(fvSokongUlasan.FindControl("ddlSokongUlasan"), DropDownList)
    '    Dim txtNotaUlasan As TextBox = DirectCast(fvSokongUlasan.FindControl("txtNotaUlasan"), TextBox)
    '    Dim ddlPengesahSokongUlasan As DropDownList = DirectCast(fvSokongUlasan.FindControl("ddlPengesahSokongUlasan"), DropDownList)
    '    Dim txtPengesahNotaKelulusan As TextBox = DirectCast(fvSokongUlasan.FindControl("txtPengesahNotaKelulusan"), TextBox)

    '    Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

    '        Dim SQL As String = ""

    '        '2  Pilih Pegawai Lawatan Tapak Jabatan/Agensi
    '        '3  Lawatan Tapak Jabatan/Agensi
    '        '4	Pengesah Jabatan/Agensi
    '        '5	Pengesah Jabatan Lesen

    '        If AgensiID > 0 Then

    '            Dim fldName As String = "IsLawatanTapakUlasan"
    '            If ApprStatusID = 2 Then
    '                fldName = "StatusID"

    '                SQL = "UPDATE LESEN_PermohonanAgensi set " & fldName & " = 3, LastModDt = getdate() 
    '            where Permohonan_ID = @Permohonan_ID 
    '            and case when JabatanAgensi_ID is null then 0 else JabatanAgensi_ID end = @AgensiId "

    '            ElseIf ApprStatusID = 3 Then
    '                fldName = "IsLawatanTapakUlasan"

    '                SQL = "UPDATE LESEN_PermohonanAgensi set " & fldName & " = 1, LastModDt = getdate() 
    '            where Permohonan_ID = @Permohonan_ID 
    '            and case when JabatanAgensi_ID is null then 0 else JabatanAgensi_ID end = @AgensiId "

    '            ElseIf ApprStatusID = 4 Then
    '                fldName = "IsPenilaian"

    '                SQL = "UPDATE LESEN_PermohonanAgensi set " & fldName & " = 1, LastModDt = getdate(), 
    '            PengesahStatusID = @PengesahStatusID, PengesahNotaKelulusan = @PengesahNotaKelulusan,
    'PengesahID = @PengesahID
    '            where Permohonan_ID = @Permohonan_ID 
    '            and case when JabatanAgensi_ID is null then 0 else JabatanAgensi_ID end = @AgensiId "

    '                Try
    '                    Dim hdnFiedlJabatanAgensiType As HiddenField = DirectCast(fvSokongUlasan.FindControl("hdnFiedlJabatanAgensiType"), HiddenField)

    '                    If hdnFiedlJabatanAgensiType.Value = "L" Then
    '                        SQL = SQL & ";UPDATE LESEN_PermohonanAgensi set " & fldName & " = 1, LastModDt = getdate(),
    '                        StatusID = @PengesahStatusID, NotaKelulusan = @PengesahNotaKelulusan
    '                        where Permohonan_ID = @Permohonan_ID 
    '                        and case when JabatanAgensi_ID is null then 0 else JabatanAgensi_ID end = @AgensiId "
    '                    End If
    '                Catch ex As Exception

    '                End Try


    '            ElseIf ApprStatusID = 5 Then
    '                fldName = "IsPeraku"

    '                SQL = "UPDATE LESEN_PermohonanAgensi set " & fldName & " = 1, LastModDt = getdate(),
    '            StatusID = @StatusID, NotaKelulusan = @NotaKelulusan
    '            where Permohonan_ID = @Permohonan_ID 
    '            and case when JabatanAgensi_ID is null then 0 else JabatanAgensi_ID end = @AgensiId "

    '            End If

    '        Else

    '        End If

    '        Dim myCommand As New SqlCommand(SQL, myConnection)

    '        myCommand.Parameters.AddWithValue("@Permohonan_ID", Permohonan_ID)
    '        myCommand.Parameters.AddWithValue("@AgensiId", AgensiID)
    '        myCommand.Parameters.AddWithValue("@ApprStatusID", ApprStatusID)
    '        myCommand.Parameters.AddWithValue("@SessionUserName", Session.Item("SessionUserName"))
    '        myCommand.Parameters.AddWithValue("@StatusID", ddlSokongUlasan.SelectedValue)
    '        myCommand.Parameters.AddWithValue("@NotaKelulusan", txtNotaUlasan.Text)
    '        myCommand.Parameters.AddWithValue("@PengesahStatusID", ddlPengesahSokongUlasan.SelectedValue)
    '        myCommand.Parameters.AddWithValue("@PengesahNotaKelulusan", txtPengesahNotaKelulusan.Text)
    '        myCommand.Parameters.AddWithValue("@PengesahID", Session.Item("sessionUsersId"))

    '        myConnection.Open()

    '        Dim recordset As Integer = myCommand.ExecuteNonQuery()

    '        '//start insert

    '        If recordset Then
    '            ShowAlert("success", "", "Rekod berjaya dihantar")
    '        End If

    '        myConnection.Close()

    '    End Using

    '    GridView1.DataBind()
    '    backToList()

    'End Sub

    'Protected Sub btnApprove_Click(sender As Object, e As EventArgs)

    '    Dim Permohonan_ID As Integer = CInt(GridView1.SelectedDataKey.Values(0))
    '    Dim AgensiID As Integer = If(IsDBNull(GridView1.SelectedDataKey.Values(1)), 0, CInt(GridView1.SelectedDataKey.Values(1)))
    '    Dim ApprStatusID As Integer = CInt(GridView1.SelectedDataKey.Values(2))
    '    Dim txtNotaKelulusanPengesah As TextBox = DirectCast(fvNotaKelulusan.FindControl("txtNotaKelulusanPengesah"), TextBox)
    '    Dim txtNotaKelulusan As TextBox = DirectCast(fvNotaKelulusan.FindControl("txtNotaKelulusan"), TextBox)

    '    Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

    '        Dim SQL As String = ""

    '        '2  mohon ulasan
    '        '3  Penilaian Jabatan/Agensi
    '        '4	Peraku Jabatan/Agensi
    '        '5	Penilaian Jabatan Lesen
    '        '8	Peraku Jabatan Lesen

    '        Dim statusUpdate As Integer = 7

    '        If ApprStatusID = 5 Then
    '            statusUpdate = 8
    '        ElseIf ApprStatusID = 8 Then
    '            statusUpdate = 10
    '        End If

    '        If AgensiID = 0 Then
    '            If ApprStatusID = 5 Then
    '                SQL = "UPDATE LESEN_Permohonan set StatusID = " & statusUpdate & ", StatusIDPengesah = 1, LastModDt = getdate(), 
    '            LastModID = @SessionUserName ,NotaKelulusanPengesah = @NotaKelulusanPengesah
    '            where Permohonan_ID = @Permohonan_ID "
    '            ElseIf ApprStatusID = 8 Then
    '                SQL = "UPDATE LESEN_Permohonan set StatusID = " & statusUpdate & ", LastModDt = getdate(), 
    '            LastModID = @SessionUserName ,NotaKelulusan = @NotaKelulusan
    '            where Permohonan_ID = @Permohonan_ID "
    '            End If

    '        End If

    '        Dim myCommand As New SqlCommand(SQL, myConnection)

    '        myCommand.Parameters.AddWithValue("@Permohonan_ID", Permohonan_ID)
    '        myCommand.Parameters.AddWithValue("@AgensiId", AgensiID)
    '        myCommand.Parameters.AddWithValue("@ApprStatusID", ApprStatusID)
    '        myCommand.Parameters.AddWithValue("@SessionUserName", Session.Item("SessionUserName"))
    '        myCommand.Parameters.AddWithValue("@NotaKelulusanPengesah", txtNotaKelulusanPengesah.Text)
    '        myCommand.Parameters.AddWithValue("@NotaKelulusan", txtNotaKelulusan.Text)


    '        myConnection.Open()

    '        Dim recordset As Integer = myCommand.ExecuteNonQuery()

    '        If recordset Then
    '            ShowAlert("success", "", "Rekod berjaya dihantar")
    '        End If
    '        '//start insert

    '        myConnection.Close()

    '    End Using

    '    GridView1.DataBind()
    '    backToList()

    'End Sub

    'Protected Sub btnReject_Click(sender As Object, e As EventArgs)

    '    Dim Permohonan_ID As Integer = CInt(GridView1.SelectedDataKey.Values(0))
    '    Dim AgensiID As Integer = If(IsDBNull(GridView1.SelectedDataKey.Values(1)), 0, CInt(GridView1.SelectedDataKey.Values(1)))
    '    Dim ApprStatusID As Integer = CInt(GridView1.SelectedDataKey.Values(2))
    '    Dim txtNotaKelulusanPengesah As TextBox = DirectCast(fvNotaKelulusan.FindControl("txtNotaKelulusanPengesah"), TextBox)
    '    Dim txtNotaKelulusan As TextBox = DirectCast(fvNotaKelulusan.FindControl("txtNotaKelulusan"), TextBox)

    '    Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

    '        Dim SQL As String = ""

    '        '2  mohon ulasan
    '        '3  Penilaian Jabatan/Agensi
    '        '4	Peraku Jabatan/Agensi
    '        '5	Penilaian Jabatan Lesen
    '        '8	Peraku Jabatan Lesen

    '        Dim statusUpdate As Integer = 7

    '        If ApprStatusID = 5 Then
    '            statusUpdate = 8
    '        ElseIf ApprStatusID = 8 Then
    '            statusUpdate = 9
    '        End If

    '        If AgensiID = 0 Then

    '            If ApprStatusID = 5 Then
    '                SQL = "UPDATE LESEN_Permohonan set StatusID = " & statusUpdate & ",StatusIDPengesah = 0, 
    '                LastModDt = getdate(), LastModID = @SessionUserName ,NotaKelulusanPengesah = @NotaKelulusanPengesah
    '            where Permohonan_ID = @Permohonan_ID "
    '            Else
    '                SQL = "UPDATE LESEN_Permohonan set StatusID = " & statusUpdate & ", LastModDt = getdate(), 
    '            LastModID = @SessionUserName ,NotaKelulusan = @NotaKelulusan
    '            where Permohonan_ID = @Permohonan_ID "
    '            End If

    '        End If

    '        Dim myCommand As New SqlCommand(SQL, myConnection)

    '        myCommand.Parameters.AddWithValue("@Permohonan_ID", Permohonan_ID)
    '        myCommand.Parameters.AddWithValue("@AgensiId", AgensiID)
    '        myCommand.Parameters.AddWithValue("@ApprStatusID", ApprStatusID)
    '        myCommand.Parameters.AddWithValue("@SessionUserName", Session.Item("SessionUserName"))
    '        myCommand.Parameters.AddWithValue("@NotaKelulusanPengesah", txtNotaKelulusanPengesah.Text)
    '        myCommand.Parameters.AddWithValue("@NotaKelulusan", txtNotaKelulusan.Text)

    '        myConnection.Open()

    '        Dim recordset As Integer = myCommand.ExecuteNonQuery()

    '        If recordset Then
    '            ShowAlert("success", "", "Rekod berjaya dihantar")
    '        End If
    '        '//start insert

    '        myConnection.Close()

    '    End Using

    '    GridView1.DataBind()
    '    backToList()

    'End Sub




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

                        'MessageBox("Fail berjaya dimuatnaik", Me)
                        ShowAlert("success", "", "Fail berjaya dimuatnaik")
                    Else
                        'MessageBox("Image size cannot be more then 5 MB!", Me)
                        ShowAlert("error", "", "Image size cannot be more then 5 MB!")
                        retval = False
                    End If
                Else

                    If fileExtention = "application/pdf" Then

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
                            ShowAlert("success", "", "Fail berjaya dimuatnaik")

                        Else
                            'MessageBox("Image size cannot be more then 5 MB!", Me)
                            ShowAlert("error", "", "Image size cannot be more then 5 MB!")
                            retval = False
                        End If

                    Else
                        'MessageBox("Format Fail PDF Sahaja!", Me)
                        ShowAlert("error", "", "Format Fail PDF Sahaja!")
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

    Private Sub GridView1_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles GridView1.RowCommand

        If e.CommandName = "Surat" Then
            Dim intRow As Integer = CInt(e.CommandArgument)
            Dim Permohonan_ID As String = CStr(Me.GridView1.DataKeys(intRow)("Permohonan_ID"))
            Dim AgensiID As String = CStr(Me.GridView1.DataKeys(intRow)("AgensiID"))
            Dim JenisLesenIdList As String = CStr(Me.GridView1.DataKeys(intRow)("JenisLesenIdList"))

            ViewSuratMohon(Permohonan_ID, AgensiID, JenisLesenIdList)

        End If

    End Sub

    Private Sub ViewSuratMohon(permohonanID As String, agensiID As String, JenisLesenIdList As String)
        Dim sql As String = ""
        Dim jenisLesenDesc = {"mpk_suratmohonulasan", "mpk_suratmohonulasan_psr", "mpk_suratmohonulasan_anj", "mpk_suratmohonulasan_pjj", "mpk_suratmohonulasan_bb"}
        Dim jenisLesenDescLuar = {"mpk_suratmohonulasan_l", "mpk_suratmohonulasan_psr_l", "mpk_suratmohonulasan_anj_l", "mpk_suratmohonulasan_pjj_l", "mpk_suratmohonulasan_bb_l"}

        Try
            sql = "SELECT a.Permohonan_ID, a.TarikhMohon, a.CreatedDt, CAST(a.NamaSyarikat AS varchar(200)) AS NamaSyarikat, a.NoPendaftaran, a.NoAkaun, a.AlamatPremis, a.JenisPerniagaan, a.PemilikBaru, " &
            "a.AlamatBaru, a.JenisPerniagaanBaru, a.NamaBaruSyarikat, a.BillboardLokasi, a.LokasiPasar1, a.LokasiPasar2, a.LokasiPasar3, a.JenisPasar, a.JenisPerniagaanPasar, a.JumlahPetak, a.AnjingAlamat, " &
            "a.AnjingJenisMohon, a.AnjingJenisPremis, a.AlamatPenjajaan, a.JenisPerniagaanPenjaja, a.TarikhBatal, a.PenganjurEkspo, a.NamaEkspo, a.LokasiEkspo, a.NoTelEkspo, a.TarikhEkspo1, a.TarikhEkspo2, " &
            "a.KontraktorIklan, a.NoTelKontraktor, a.UkuranBanting, a.BilBanting, a.TarikhBanting1, a.TarikhBanting2, a.NoResitBanting, a.NoSiriStiker, a.TarikhBanting3, " &
            "a.MasaEkspo1, a.MasaEkspo2, a.Rujukan, a.NoAkaunCukai, a.IsBatal, a.JenisLesenDescList, a.JenisLesenIdList, a.SaizIklanList, a.CahayaIklanList, a.UnitIklanList, a.LokasiList, a.BakaAnjingList, a.AnjingJantanList, " &
            "a.AnjingBetinaList, a.AnjingJantanMandulList, a.AnjingBetinaMandulList, e.JabatanAgensi_Address, e.JabatanAgensi_Kepada, b.Pemohon_Name, b.Pemohon_ICNo, b.Pemohon_PassportNo, b.Pemohon_Address, " &
            "b.Pemohon_Email, b.Pemohon_MobileNo, b.Pemohon_TelNo, g.Users_Fullname, g.Users_Signature " &
            "FROM LESEN_Permohonan a INNER JOIN LESEN_Pemohon b ON a.Permohonan_PemohonID = b.Pemohon_ID INNER JOIN LESEN_PermohonanAgensi d ON a.Permohonan_ID = d.Permohonan_ID " &
            "INNER JOIN LESEN_JabatanAgensi e ON d.JabatanAgensi_ID = e.JabatanAgensi_ID " &
            "LEFT JOIN TBL_USERS g ON g.Users_Id = (case when e.JabatanAgensi_Type = 'J' then a.TandatanganMohonUlasanId when e.JabatanAgensi_Type = 'L' then a.TandatanganMohonUlasanLuarId end) " &
            "WHERE a.Permohonan_ID=" & permohonanID & " AND e.JabatanAgensi_ID = " & agensiID

            Dim ReportVar As String = jenisLesenDesc(0)

            Select Case JenisLesenIdList
                Case "2", "25"
                    ReportVar = jenisLesenDesc(1)
                Case "3"
                    ReportVar = jenisLesenDesc(2)
                Case "4"
                    ReportVar = jenisLesenDesc(3)
                Case "5"
                    ReportVar = jenisLesenDesc(4)
            End Select

            If CInt(agensiID) > 3 Then

                ReportVar = jenisLesenDescLuar(0)

                Select Case JenisLesenIdList
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


    Protected Sub BT_ViewMail_Command(sender As Object, e As CommandEventArgs)

        Dim pid As Integer = GridView1.SelectedDataKey.Values(0)

        ViewSuratPemeriksaan(pid)

    End Sub


    Private Sub ViewSuratPemeriksaan(permohonanID As String)

        Dim sql As String = ""
        Dim jenisLesenDesc = {"mpk_suratpemeriksaan"}

        Try
            sql = "Select a.Permohonan_ID, a.TarikhPemeriksaan, a.TarikhSuratPemeriksaan, CAST(a.NamaSyarikat As varchar(200)) As NamaSyarikat, 
                f.NoPendaftaran, f.NoAkaun, f.AlamatPremis, f.JenisPerniagaan, f.PemilikBaru, f.AlamatBaru,
                f.JenisPerniagaanBaru, f.NamaBaruSyarikat, f.BillboardLokasi, f.LokasiPasar1, f.LokasiPasar2,
                f.LokasiPasar3, f.JenisPasar, f.JenisPerniagaanPasar, f.JumlahPetak, f.AnjingAlamat, e.name As AnjingJenisPremisDesc, 
                f.AnjingJenisPremis, f.AlamatPenjajaan, f.JenisPerniagaanPenjaja, f.TarikhBatal, f.PenganjurEkspo,
                f.NamaEkspo, f.LokasiEkspo, f.NoTelEkspo, f.TarikhEkspo1, f.TarikhEkspo2, f.MasaEkspo1, f.MasaEkspo2, 
                f.KontraktorIklan, f.NoTelKontraktor, f.TarikhBanting1, f.TarikhBanting2, f.NoResitBanting, f.NoSiriStiker, f.TarikhBanting3, 
                a.Rujukan, a.RujukanInspektorat, a.NoAkaunCukai, a.IsBatal, a.JenisLesenDescList, a.JenisLesenIdList, f.SaizIklanList, 
                f.CahayaIklanList, f.UnitIklanList, f.LokasiList, f.BakaAnjingList, f.AnjingJantanList, f.AnjingBetinaList,
                f.AnjingJantanMandulList, f.AnjingBetinaMandulList,
                b.Pemohon_Name, b.Pemohon_Address, b.Pemohon_ICNo, b.Pemohon_MobileNo, b.Pemohon_TelNo,
                c.Users_Fullname, c.Users_Signature, d.P1, d.P2, d.P3, d.IsiKandungan 
                From LESEN_Permohonan a 
                INNER Join LESEN_PermohonanPembetulan f ON a.Permohonan_ID = f.Permohonan_ID 
                INNER Join LESEN_Pemohon b ON b.Pemohon_ID=a.Permohonan_PemohonID 
                Left Join TBL_USERS c ON a.TandatanganPemeriksaanId=c.Users_Id 
                Left Join LESEN_PermohonanSurat d ON d.Permohonan_ID=a.Permohonan_ID 
                Left Join TBL_LOOKUPS e ON e.id = a.AnjingJenisPremis 
                WHERE a.Permohonan_ID =@permohonanID ORDER BY d.P1, d.P2, d.P3"

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


            'Session.Item("reportPrintType") = "pdf"
            ScriptManager.RegisterClientScriptBlock(Me.Page, Me.[GetType](), ReportVar, "window.open('../ReportViewer.aspx?name=" + ReportVar + "', '_blank', '');", True)
        Catch ex As Exception
            MessageBox(ex.Message, Me)
        End Try
    End Sub

    Protected Sub lbLihatSurat_Click(sender As Object, e As EventArgs)

        Dim pid As Integer = CInt(GridView1.SelectedDataKey.Values(0))

        ViewSuratPemeriksaan(pid)

    End Sub

    Protected Sub lbSurat_Click(sender As Object, e As EventArgs) Handles lbSurat.Click

        Dim isBatal As Boolean = False

        If GridView1.SelectedDataKey.Values(2) = "Pembatalan" Then
            isBatal = True
        End If

        ViewSuratMohon(GridView1.SelectedDataKey.Values(0), GridView1.SelectedDataKey.Values("JenisLesenIdList"), isBatal)
    End Sub

    Private Sub ViewSuratMohon(permohonanAgensiID As String, jenislesenIdList As String, isBatal As Boolean)
        Dim strBatal As String = ""
        Dim sql As String = ""
        Dim jenisLesenDesc = {"mpk_suratmohonulasan", "mpk_suratmohonulasan_psr", "mpk_suratmohonulasan_anj", "mpk_suratmohonulasan_pjj", "mpk_suratmohonulasan_bb"}

        If isBatal Then
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

    'Private Sub fvApproval_ItemDeleted(sender As Object, e As FormViewDeletedEventArgs) Handles fvApproval.ItemDeleted
    '    btnReject_Click()
    'End Sub
    Private Sub fvApproval_ItemUpdated(sender As Object, e As FormViewUpdatedEventArgs) Handles fvApproval.ItemUpdated
        'Dim btn As Button = CType(sender, Button)

        'Dim ddlSokongUlasan As DropDownList = DirectCast(fvSokongUlasan.FindControl("ddlSokongUlasan"), DropDownList)

        'If btn.CommandArgument = "A" Then
        '    btnApprove_Click()
        'ElseIf btn.CommandArgument = "R" Then
        '    btnReject_Click()
        'End If


    End Sub

    Private Sub btnReject_Click()
        Dim PermohonanAgensi_ID As Integer = CInt(GridView1.SelectedDataKey.Values(0))
        Dim JenisLesen_ID As Integer = CInt(GridView1.SelectedDataKey.Values(1))
        Dim jenisPermohonan As String = GridView1.SelectedDataKey.Values(2)


        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Dim SQL As String = ""


            If LCase(jenisPermohonan) = "pembatalan" Then

                If Session.Item("sessionIsPenilai") = "True" Then
                    SQL = "update LESEN_PermohonanAgensiBatal set kbID = @SessionUsersId, kbApproval = 0,
                    reviewStatusID = 3
                    where PermohonanAgensi_ID = @PermohonanAgensi_ID "
                ElseIf Session.Item("sessionIsPeraku") = "True" Then
                    SQL = "update LESEN_PermohonanAgensiBatal set kjID = @SessionUsersId, kjApproval = 0,
                    reviewStatusID = 3
                    where PermohonanAgensi_ID = @PermohonanAgensi_ID "
                End If


            Else
                If Session.Item("sessionIsPenilai") = "True" Then
                    SQL = "update LESEN_PermohonanAgensi set kbID = @SessionUsersId, kbApproval = 0,
                    reviewStatusID = 3
                    where PermohonanAgensi_ID = @PermohonanAgensi_ID "
                ElseIf Session.Item("sessionIsPeraku") = "True" Then
                    SQL = "update LESEN_PermohonanAgensi set kjID = @SessionUsersId, kjApproval = 0,
                    reviewStatusID = 3
                    where PermohonanAgensi_ID = @PermohonanAgensi_ID "
                End If

            End If

            Dim myCommand As New SqlCommand(SQL, myConnection)

            myCommand.Parameters.AddWithValue("@PermohonanAgensi_ID", PermohonanAgensi_ID)
            myCommand.Parameters.AddWithValue("@kbkjReview", "")
            myCommand.Parameters.AddWithValue("@sessionIsPenilai", Session.Item("sessionIsPenilai"))
            myCommand.Parameters.AddWithValue("@sessionIsPeraku", Session.Item("sessionIsPeraku"))
            myCommand.Parameters.AddWithValue("@SessionUsersId", Session.Item("SessionUsersId"))


            myConnection.Open()

            Dim recordset As Integer = myCommand.ExecuteNonQuery()

            If recordset Then
                ShowAlert("success", "", "Surat Mohon Ulasan berjaya dihantar untuk semakan semula")
            End If
            '//start insert

            myConnection.Close()

        End Using

        GridView1.DataBind()
        backToList()

    End Sub

    Private Sub btnApprove_Click()
        Dim PermohonanAgensi_ID As Integer = CInt(GridView1.SelectedDataKey.Values(0))
        Dim JenisLesen_ID As Integer = CInt(GridView1.SelectedDataKey.Values(1))
        Dim jenisPermohonan As String = GridView1.SelectedDataKey.Values(2)


        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Dim SQL As String = ""

            If LCase(jenisPermohonan) = "pembatalan" Then

                If Session.Item("sessionIsPenilai") = "True" Then
                    SQL = "update LESEN_PermohonanAgensiBatal set kbID = @SessionUsersId, kbApproval = 1,
                    reviewStatusID = case when (select top 1 x.JabatanAgensi_Type from LESEN_JabatanAgensi x 
                    inner join LESEN_PermohonanAgensiBatal x2 on x2.JabatanAgensi_ID = x.JabatanAgensi_ID 
                    where x2.PermohonanAgensi_ID = @PermohonanAgensi_ID ) = 'J' then 2 else reviewStatusID end
                    where PermohonanAgensi_ID = @PermohonanAgensi_ID "
                ElseIf Session.Item("sessionIsPeraku") = "True" Then
                    SQL = "update LESEN_PermohonanAgensiBatal set kjID = @SessionUsersId, kjApproval = 1,
                    reviewStatusID = 2
                    where PermohonanAgensi_ID = @PermohonanAgensi_ID "
                End If


            Else
                If Session.Item("sessionIsPenilai") = "True" Then
                    SQL = "update LESEN_PermohonanAgensi set kbID = @SessionUsersId, kbApproval = 1, 
                    reviewStatusID = case when (select top 1 x.JabatanAgensi_Type from LESEN_JabatanAgensi x 
                    inner join LESEN_PermohonanAgensi x2 on x2.JabatanAgensi_ID = x.JabatanAgensi_ID 
                    where x2.PermohonanAgensi_ID = @PermohonanAgensi_ID ) = 'J' then 2 else reviewStatusID end
                    where PermohonanAgensi_ID = @PermohonanAgensi_ID "
                ElseIf Session.Item("sessionIsPeraku") = "True" Then
                    SQL = "update LESEN_PermohonanAgensi set kjID = @SessionUsersId, kjApproval = 1,
                    reviewStatusID = 2
                    where PermohonanAgensi_ID = @PermohonanAgensi_ID "
                End If

            End If

            Dim myCommand As New SqlCommand(SQL, myConnection)

            myCommand.Parameters.AddWithValue("@PermohonanAgensi_ID", PermohonanAgensi_ID)
            myCommand.Parameters.AddWithValue("@kbkjReview", "")
            myCommand.Parameters.AddWithValue("@sessionIsPenilai", Session.Item("sessionIsPenilai"))
            myCommand.Parameters.AddWithValue("@sessionIsPeraku", Session.Item("sessionIsPeraku"))
            myCommand.Parameters.AddWithValue("@SessionUsersId", Session.Item("SessionUsersId"))


            myConnection.Open()

            Dim recordset As Integer = myCommand.ExecuteNonQuery()

            If recordset Then
                'sdsApproval.Update()

                ShowAlert("success", "", "Semakan Surat Diluluskan")
            End If
            '//start insert

            myConnection.Close()

        End Using

        GridView1.DataBind()
        backToList()

    End Sub


    Protected Sub btnApprove_Click1(sender As Object, e As EventArgs)
        UpdateInfoUlasan()
        btnApprove_Click()

    End Sub

    Protected Sub btnReject_Click1(sender As Object, e As EventArgs)
        UpdateInfoUlasan()
        btnReject_Click()
    End Sub

    Private Sub UpdateInfoUlasan()
        Dim txtNotaKelulusanPengesah As TextBox = DirectCast(fvApproval.FindControl("txtNotaKelulusanPengesah"), TextBox)
        Dim txtNotaKelulusanPeraku As TextBox = DirectCast(fvApproval.FindControl("txtNotaKelulusanPeraku"), TextBox)

        Dim PermohonanAgensi_ID As Integer = CInt(GridView1.SelectedDataKey.Values(0))
        Dim JenisLesen_ID As Integer = CInt(GridView1.SelectedDataKey.Values(1))
        Dim jenisPermohonan As String = GridView1.SelectedDataKey.Values(2)

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Dim SQL As String = ""

            SQL = "Update LESEN_PermohonanAgensi set kbReview=@kbReview,kjReview=@kjReview 
            where PermohonanAgensi_ID = case when LOWER(@jenisPermohonan) = 'pembatalan' then -9999 else @PermohonanAgensi_ID end;
            Update LESEN_PermohonanAgensiBatal set kbReview=@kbReview,kjReview=@kjReview 
            where PermohonanAgensi_ID =  case when LOWER(@jenisPermohonan) = 'pembatalan' then @PermohonanAgensi_ID else -9999 end"

            Dim myCommand As New SqlCommand(SQL, myConnection)

            myCommand.Parameters.AddWithValue("@PermohonanAgensi_ID", PermohonanAgensi_ID)
            myCommand.Parameters.AddWithValue("@jenisPermohonan", jenisPermohonan)
            myCommand.Parameters.AddWithValue("@kbReview", txtNotaKelulusanPengesah.Text)
            myCommand.Parameters.AddWithValue("@kjReview", txtNotaKelulusanPeraku.Text)



            myConnection.Open()

            Dim recordset As Integer = myCommand.ExecuteNonQuery()

            If recordset Then
                'sdsApproval.Update()

                'ShowAlert("success", "", "Semakan Surat Diluluskan")
            End If
            '//start insert

            myConnection.Close()

        End Using

    End Sub

End Class
