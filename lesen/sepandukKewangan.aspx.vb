Imports System.Data.SqlClient
Imports System.Configuration

Partial Class sepandukKewangan
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim gv As GridView = GridView1
        Dim ds As SqlDataSource = SqlDataSourceGridKewangan
        GlobalClass.GenerateFilter(gv, ds, pnlFilter)
    End Sub

    Private Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearch.Click
        Dim ds As SqlDataSource = SqlDataSourceGridKewangan
        GlobalClass.procSearch(ds, pnlFilter)
    End Sub

    Private Sub btnReset_Click(sender As Object, e As EventArgs) Handles btnReset.Click
        Response.Redirect(Request.RawUrl)
    End Sub

    Protected Sub GridView1_PageIndexChanged(sender As Object, e As EventArgs) Handles GridView1.PageIndexChanged
        Dim ds As SqlDataSource = SqlDataSourceGridKewangan
        GlobalClass.procSearch(ds, pnlFilter)
    End Sub

    Protected Sub GridView1_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles GridView1.SelectedIndexChanged
        pnlDetail.Visible = True
        FormView1.ChangeMode(FormViewMode.ReadOnly)
        FormViewKewangan.ChangeMode(FormViewMode.Insert)
        FormView1.DataBind()
        GridViewTrail.DataBind()
    End Sub

    Protected Sub InsertCancelButton_Click(sender As Object, e As EventArgs)
        pnlDetail.Visible = False
        GridView1.SelectedIndex = -1
    End Sub

    Protected Sub FormViewKewangan_ItemInserting(sender As Object, e As System.Web.UI.WebControls.FormViewInsertEventArgs) Handles FormViewKewangan.ItemInserting
        Dim noRujukan As String = GridView1.SelectedRow.Cells(1).Text
        GlobalClass.auditTrail("Update Kewangan", noRujukan, "Kunci Masuk")
    End Sub

    Protected Sub FormViewKewangan_ItemInserted(sender As Object, e As System.Web.UI.WebControls.FormViewInsertedEventArgs) Handles FormViewKewangan.ItemInserted
        If e.Exception Is Nothing Then
            UpdateStatusPermohonan(CInt(GridView1.SelectedValue), "Dikemaskini Kewangan")
            ShowAlert("success", "", "Permohonan berjaya dikemaskini di Kewangan")

            pnlDetail.Visible = False
            GridView1.SelectedIndex = -1
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
