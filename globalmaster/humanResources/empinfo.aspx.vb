
Imports System.Data
Imports System.Data.SqlClient
Imports System.IO

Partial Class humanResources_empinfo
    Inherits System.Web.UI.Page

    Public Shared CS As [String] = ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString

    Private Sub FormView1_ItemUpdated(sender As Object, e As FormViewUpdatedEventArgs) Handles FormView1.ItemUpdated
        Dim titleTxt As TextBox = DirectCast(FormView1.FindControl("NAMETextBox"), TextBox)
        Dim title As String = titleTxt.Text
        Dim hiddenID As HiddenField = DirectCast(FormView1.FindControl("HiddenField1"), HiddenField)
        Dim ID As String = hiddenID.Value
        Using con As New SqlConnection(CS)
            con.Open()

            Dim LabourCAT As DropDownList = TryCast(FormView1.FindControl("LabourCAT"), DropDownList)
            Dim LabourCD As DropDownList = TryCast(FormView1.FindControl("LabourCD"), DropDownList)
            Dim Mandore As RadioButtonList = TryCast(FormView1.FindControl("Mandore"), RadioButtonList)
            Dim JobStatus As DropDownList = TryCast(FormView1.FindControl("JobStatus"), DropDownList)
            Dim QTRStatus As DropDownList = TryCast(FormView1.FindControl("QTRStatus"), DropDownList)
            Dim Gangno As DropDownList = TryCast(FormView1.FindControl("Gangno"), DropDownList)
            Dim cmd As New SqlCommand("UPDATE TBL_WORKERINFOES SET LABOURCAT_objectId = '" + LabourCAT.SelectedValue + "', LABOURCD_objectId = '" + LabourCD.SelectedValue + "', MANDORE = '" + Mandore.SelectedValue + "', JOBSTATUS_objectId = '" + JobStatus.SelectedValue + "', QTRSTATUS_objectId = '" + QTRStatus.SelectedValue + "', GANGNO_objectId = '" + Gangno.SelectedValue + "', updatedAt = getdate() WHERE EMP_objectId = " + ID, con)
            cmd.ExecuteNonQuery()
        End Using
        '//run audit trail : Insert : Update : Delete : Login : Logout
        GlobalClass.auditTrail("EmpInfo", title, "Update")
        GridView1.DataBind()
        CallFilter()
    End Sub

    Protected Sub GridView1_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs) Handles GridView1.RowDeleting
        Dim title As String = GridView1.Rows(e.RowIndex).Cells(1).Text

        '//run audit trail : Insert : Update : Delete : Login : Logout
        GlobalClass.auditTrail("EmpInfo", title, "Delete")
    End Sub


    Protected Sub GridView1_RowUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewUpdateEventArgs) Handles GridView1.RowUpdating

        Dim row = GridView1.Rows(e.RowIndex)
        Dim title As String = (CType((row.Cells(1).Controls(0)), TextBox)).Text

        '//run audit trail : Insert : Update : Delete : Login : Logout
        GlobalClass.auditTrail("EmpInfo", title, "Update")
    End Sub


    Protected Sub Page_PreRenderComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRenderComplete
        Dim ddlOCS As DropDownList = DirectCast(FormView1.FindControl("DropDownList6"), DropDownList)
        ddlOCS.SelectedValue = Session.Item("sessionOCS")

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
            GridView1.Columns.Item(7).Visible = False '//grid delete

        End If
    End Sub

    Private Sub FormView1_ItemInserting(sender As Object, e As FormViewInsertEventArgs) Handles FormView1.ItemInserting
        e.Values("createdAt") = DateTime.Now
        e.Values("IsActive") = True

        Dim titleTxt As TextBox = DirectCast(FormView1.FindControl("NAMETextBox"), TextBox)
        Dim title As String = titleTxt.Text

        '//run audit trail : Insert : Update : Delete : Login : Logout
        GlobalClass.auditTrail("EmpInfo", title, "Insert")

    End Sub

    Private Sub FormView1_ItemInserted(sender As Object, e As FormViewInsertedEventArgs) Handles FormView1.ItemInserted
        Dim id As String
        Using con As New SqlConnection(CS)
            con.Open()

            Using cmdd As New SqlCommand("SELECT TOP 1 * FROM TBL_EMPS ORDER BY objectId DESC", con)
                Using sda As New SqlDataAdapter(cmdd)
                    Dim dt As New DataTable()
                    Dim LabourCAT As DropDownList = TryCast(FormView1.FindControl("LabourCAT"), DropDownList)
                    Dim LabourCD As DropDownList = TryCast(FormView1.FindControl("LabourCD"), DropDownList)
                    Dim Mandore As RadioButtonList = TryCast(FormView1.FindControl("Mandore"), RadioButtonList)
                    Dim JobStatus As DropDownList = TryCast(FormView1.FindControl("JobStatus"), DropDownList)
                    Dim QTRStatus As DropDownList = TryCast(FormView1.FindControl("QTRStatus"), DropDownList)
                    Dim Gangno As DropDownList = TryCast(FormView1.FindControl("Gangno"), DropDownList)
                    sda.Fill(dt)
                    If dt.Rows.Count <> 0 Then
                        id = dt.Rows(0)("objectId").ToString()
                        Dim cmd As New SqlCommand("INSERT INTO TBL_WORKERINFOES(EMP_objectId, LABOURCAT_objectId, LABOURCD_objectId, MANDORE, JOBSTATUS_objectId, QTRSTATUS_objectId, GANGNO_objectId, createdAt, IsActive, RESIDENT, PERMANENTRES, FORWORKER) VALUES ('" + id + "', '" + LabourCAT.SelectedValue + "', '" + LabourCD.SelectedValue + "', '" + Mandore.SelectedValue + "', '" + JobStatus.SelectedValue + "', '" + QTRStatus.SelectedValue + "', '" + Gangno.SelectedValue + "', getdate(), 0, 0, 0, 0)", con)
                        cmd.ExecuteNonQuery()
                    End If
                End Using
            End Using

            Using cmdd As New SqlCommand("SELECT TOP 1 * FROM TBL_WORKERINFOES ORDER BY objectId DESC", con)
                Using sda As New SqlDataAdapter(cmdd)
                    Dim dt As New DataTable()
                    sda.Fill(dt)
                    If dt.Rows.Count <> 0 Then
                        id = dt.Rows(0)("objectId").ToString()
                        Dim cmd As New SqlCommand("UPDATE TBL_EMPS SET WORKERINFO_objectId = '" + id + "' WHERE objectId = (SELECT MAX(objectId) FROM TBL_EMPS)", con)
                        cmd.ExecuteNonQuery()
                    End If
                End Using
            End Using

            con.Close()
        End Using

        GridView1.DataBind()
        CallFilter()
    End Sub

    Private Sub GridView1_SelectedIndexChanged(sender As Object, e As EventArgs) Handles GridView1.SelectedIndexChanged
        FormView1.ChangeMode(FormViewMode.Edit)
    End Sub

    Private Sub FormView1_ItemUpdating(sender As Object, e As FormViewUpdateEventArgs) Handles FormView1.ItemUpdating
        e.NewValues("updatedAt") = DateTime.Now
    End Sub

    Private Sub btnReset_Click(sender As Object, e As EventArgs) Handles btnReset.Click
        Response.Redirect(Request.RawUrl)
    End Sub

    Private Sub humanResources_empinfo_PreRender(sender As Object, e As EventArgs) Handles Me.PreRender
        'FormView1.DataBind()
        If FormView1.CurrentMode = FormViewMode.Insert Then
            Dim ddlOCS As DropDownList = DirectCast(FormView1.FindControl("DropDownList6"), DropDownList)
            ddlOCS.SelectedValue = Session.Item("sessionOCS")
        End If
    End Sub

    Private Sub humanResources_empinfo_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim gv As GridView = GridView1
        Dim ds As SqlDataSource = SqlDataSourceFilter
        GlobalClass.GenerateFilter(gv, ds, pnlFilter)
    End Sub

    Private Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearch.Click
        FormView1.ChangeMode(FormViewMode.Insert)
        Dim ds As SqlDataSource = SqlDataSourceGrid
        GlobalClass.procSearch(ds, pnlFilter)
    End Sub

    Protected Sub UploadFile(ByVal sender As Object, ByVal e As EventArgs)
        Dim FileUpload1 As FileUpload = CType(FormView1.FindControl("FileUpload1"), FileUpload)
        Dim Image1 As Image = CType(FormView1.FindControl("Image1"), Image)
        Dim Label1 As Label = CType(FormView1.FindControl("lblUploadMsg"), Label)
        Dim EMPCODETextBox As TextBox = CType(FormView1.FindControl("EMPCODETextBox"), TextBox)

        Label1.Text = ""

        If FileUpload1.HasFile Then
            'Dim strname As String = FileUpload1.FileName.ToString()
            Dim allowedExtensions As String() = {".jpeg", ".jpg", ".png", ".bmp", ".gif", ".tiff"}
            Dim fileType As String = Path.GetExtension(FileUpload1.FileName) '.Substring(1)
            If Not (allowedExtensions.Contains(fileType)) Then
                Label1.Visible = True
                Label1.Text = "Please select image file!"
                Label1.ForeColor = System.Drawing.Color.Red
                Exit Sub
            End If

            'Dim fileSize As Integer = FileUpload1.PostedFile.ContentLength
            'If Not (fileSize < 2048000) Then ' 1MB -> 1000 * 1024
            '    Label1.Visible = True
            '    Label1.Text = "Your file was not uploaded because " +
            '                         "it exceeds the 2 MB size limit."
            '    Label1.ForeColor = System.Drawing.Color.Red
            '    Exit Sub
            'End If

            Dim strname As String = CLng(DateTime.UtcNow.Subtract(New DateTime(1970, 1, 1)).TotalMilliseconds).ToString() + fileType
                If (EMPCODETextBox.Text.Trim <> "") Then
                    strname = EMPCODETextBox.Text.Trim + "_" + strname
                End If

                Dim strFilePath As String = Server.MapPath("~/Archive/Employee/") & strname
                Dim strFileServerPath As String = "~/Archive/Employee/" & strname
                FileUpload1.PostedFile.SaveAs(strFilePath)
                Image1.ImageUrl = strFileServerPath
                Label1.Visible = True
                Label1.Text = "Image Uploaded successfully"
                Label1.ForeColor = System.Drawing.Color.Blue
            Else
                Label1.Visible = True
            Label1.Text = "File could not be uploaded."
            Label1.ForeColor = System.Drawing.Color.Red
        End If
    End Sub

    Protected Sub FormView1_DataBound(ByVal sender As Object, ByVal e As EventArgs) Handles FormView1.DataBound
        If FormView1.CurrentMode = FormViewMode.Insert Then
            Dim Image1 As Image = CType(FormView1.FindControl("Image1"), Image)
            Image1.ImageUrl = "~/Archive/Employee/default.jpg"
        End If
    End Sub

    Protected Sub GridView1_PageIndexChanged(sender As Object, e As EventArgs) Handles GridView1.PageIndexChanged
        CallFilter()
        If FormView1.CurrentMode = FormViewMode.Edit Then
            FormView1.ChangeMode(FormViewMode.Insert)
        End If
    End Sub

    Private Sub CallFilter()
        Dim ds As SqlDataSource = SqlDataSourceGrid
        GlobalClass.procSearch(ds, pnlFilter)
    End Sub

End Class
