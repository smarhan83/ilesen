Imports System.Data.SqlClient
Imports System.Configuration

Partial Class sepandukKelulusan
    Inherits System.Web.UI.Page

    Private Const COL_STATUS As Integer = 5   ' index kolum Status dalam GridView1 (0=ID,1=NoRujukan,2=Jenis,3=NamaPemohon,4=Lokasi,5=Status)

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim gv As GridView = GridView1
        Dim ds As SqlDataSource = SqlDataSourceGridKelulusan
        GlobalClass.GenerateFilter(gv, ds, pnlFilter)
    End Sub

    Private Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearch.Click
        Dim ds As SqlDataSource = SqlDataSourceGridKelulusan
        GlobalClass.procSearch(ds, pnlFilter)
    End Sub

    Private Sub btnReset_Click(sender As Object, e As EventArgs) Handles btnReset.Click
        Response.Redirect(Request.RawUrl)
    End Sub

    Protected Sub GridView1_PageIndexChanged(sender As Object, e As EventArgs) Handles GridView1.PageIndexChanged
        Dim ds As SqlDataSource = SqlDataSourceGridKelulusan
        GlobalClass.procSearch(ds, pnlFilter)
    End Sub

    Protected Sub GridView1_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles GridView1.SelectedIndexChanged
        pnlDetail.Visible = True
        idListing.Visible = False

        Dim statusSemasa As String = Trim(GridView1.SelectedRow.Cells(COL_STATUS).Text)

        pnlKBInspektorat.Visible = (statusSemasa = "Semakan KB Inspektorat")
        pnlKBLesen.Visible = (statusSemasa = "Semakan KB Lesen")
        pnlKJLesen.Visible = (statusSemasa = "Perakuan KJ Lesen")

        If True Then
            pnlTrailKelulusan.Visible = True
        Else
            pnlTrailKelulusan.Visible = False
        End If

        FormView1.ChangeMode(FormViewMode.ReadOnly)
        FormView2.ChangeMode(FormViewMode.ReadOnly)
        FormViewKBInspektorat.ChangeMode(FormViewMode.Insert)
        FormViewKBLesen.ChangeMode(FormViewMode.Insert)
        FormViewKJLesen.ChangeMode(FormViewMode.Insert)

        FormView1.DataBind()
        FormView2.DataBind()
    End Sub

    Protected Sub InsertCancelButton_Click(sender As Object, e As EventArgs)
        ResetPanel()
    End Sub

    Private Sub ResetPanel()
        pnlDetail.Visible = False
        idListing.Visible = True
        pnlKBInspektorat.Visible = False
        pnlKBLesen.Visible = False
        pnlKJLesen.Visible = False
        GridView1.SelectedIndex = -1
    End Sub

    '===================== KB INSPEKTORAT =====================
    Protected Sub FormViewKBInspektorat_ItemInserting(sender As Object, e As System.Web.UI.WebControls.FormViewInsertEventArgs) Handles FormViewKBInspektorat.ItemInserting
        Dim noRujukan As String = GridView1.SelectedRow.Cells(1).Text
        GlobalClass.auditTrail("Kelulusan KB Inspektorat", noRujukan, "Kunci Masuk")
    End Sub

    Protected Sub FormViewKBInspektorat_ItemInserted(sender As Object, e As System.Web.UI.WebControls.FormViewInsertedEventArgs) Handles FormViewKBInspektorat.ItemInserted
        If e.Exception Is Nothing Then
            UpdateStatusPermohonan(CInt(GridView1.SelectedValue), "Semakan KB Lesen")
            ShowAlert("success", "", "Rekod berjaya disimpan dan dihantar kepada KB Lesen")
            ResetPanel()
            GridView1.DataBind()
        End If
    End Sub

    '===================== KB LESEN =====================
    Protected Sub FormViewKBLesen_ItemInserting(sender As Object, e As System.Web.UI.WebControls.FormViewInsertEventArgs) Handles FormViewKBLesen.ItemInserting
        Dim noRujukan As String = GridView1.SelectedRow.Cells(1).Text
        GlobalClass.auditTrail("Kelulusan KB Lesen", noRujukan, "Kunci Masuk")
    End Sub

    Protected Sub FormViewKBLesen_ItemInserted(sender As Object, e As System.Web.UI.WebControls.FormViewInsertedEventArgs) Handles FormViewKBLesen.ItemInserted
        If e.Exception Is Nothing Then
            UpdateStatusPermohonan(CInt(GridView1.SelectedValue), "Perakuan KJ Lesen")
            ShowAlert("success", "", "Rekod berjaya disimpan dan dihantar kepada KJ Lesen")
            ResetPanel()
            GridView1.DataBind()
        End If
    End Sub

    '===================== KJ LESEN =====================
    Protected Sub FormViewKJLesen_ItemInserting(sender As Object, e As System.Web.UI.WebControls.FormViewInsertEventArgs) Handles FormViewKJLesen.ItemInserting
        Dim noRujukan As String = GridView1.SelectedRow.Cells(1).Text
        GlobalClass.auditTrail("Perakuan KJ Lesen", noRujukan, "Kunci Masuk")
    End Sub

    Protected Sub FormViewKJLesen_ItemInserted(sender As Object, e As System.Web.UI.WebControls.FormViewInsertedEventArgs) Handles FormViewKJLesen.ItemInserted
        If e.Exception Is Nothing Then
            Dim ddlKeputusan As DropDownList = DirectCast(FormViewKJLesen.FindControl("ddlKeputusan"), DropDownList)

            '// jika diperakukan, tandakan Selesai supaya Kerani Lesen boleh update Kewangan
            '// jika tidak diperakukan, kekal/pulangkan status supaya boleh disemak semula
            Dim statusBaru As String = If(ddlKeputusan IsNot Nothing AndAlso ddlKeputusan.SelectedValue = "Diperakukan", "Selesai", "Tidak Diperakukan")

            UpdateStatusPermohonan(CInt(GridView1.SelectedValue), statusBaru)
            ShowAlert("success", "", "Perakuan berjaya disimpan")
            ResetPanel()
            GridView1.DataBind()
        End If
    End Sub

    Private Sub UpdateStatusPermohonan(permohonanId As Integer, statusBaru As String)
        Dim connStr As String = ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString

        Using conn As New SqlConnection(connStr)
            Dim sql As String = "UPDATE LESEN_SepandukPermohonan SET SepandukPermohonan_Status = @Status WHERE SepandukPermohonan_ID = @ID"
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@Status", statusBaru)
                cmd.Parameters.AddWithValue("@ID", permohonanId)
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Private Sub ShowAlert(statusMsg As String, titleMsg As String, strMsg As String)
        ScriptManager.RegisterStartupScript(Me, Page.GetType, "Script", "Swal.fire('" & titleMsg & "',
        '" & strMsg & "',
        '" & statusMsg & "');", True)
    End Sub

End Class
