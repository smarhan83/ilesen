Imports System.Data.SqlClient
Imports System.Configuration

Partial Class sepandukSemakanIK
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim gv As GridView = GridView1
        Dim ds As SqlDataSource = SqlDataSourceGridIK
        GlobalClass.GenerateFilter(gv, ds, pnlFilter)
    End Sub

    Private Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearch.Click
        Dim ds As SqlDataSource = SqlDataSourceGridIK
        GlobalClass.procSearch(ds, pnlFilter)
    End Sub

    Private Sub btnReset_Click(sender As Object, e As EventArgs) Handles btnReset.Click
        Response.Redirect(Request.RawUrl)
    End Sub

    Protected Sub GridView1_PageIndexChanged(sender As Object, e As EventArgs) Handles GridView1.PageIndexChanged
        Dim ds As SqlDataSource = SqlDataSourceGridIK
        GlobalClass.procSearch(ds, pnlFilter)
    End Sub

    Protected Sub GridView1_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles GridView1.SelectedIndexChanged
        pnlDetail.Visible = True
        idListing.Visible = False
        FormView1.ChangeMode(FormViewMode.ReadOnly)
        FormView2.ChangeMode(FormViewMode.Insert)
        FormView1.DataBind()
    End Sub

    Protected Sub InsertCancelButton_Click(sender As Object, e As EventArgs)
        pnlDetail.Visible = False
        idListing.Visible = True
        GridView1.SelectedIndex = -1
    End Sub

    '// pastikan sekurang-kurangnya Ulasan / Hasil Pemerhatian diisi ikut Status Permit yang dipilih (lihat FormView2_ItemInserting)
    Protected Sub FormView2_ItemInserting(sender As Object, e As System.Web.UI.WebControls.FormViewInsertEventArgs) Handles FormView2.ItemInserting
        Dim ddlStatus As DropDownList = DirectCast(FormView2.FindControl("ddlSemakanIK_StatusPermit"), DropDownList)
        Dim txtUlasan As TextBox = DirectCast(FormView2.FindControl("txtSemakanIK_Ulasan"), TextBox)
        Dim txtPemerhatian As TextBox = DirectCast(FormView2.FindControl("txtSemakanIK_HasilPemerhatian"), TextBox)

        Select Case ddlStatus.SelectedValue
            Case "Tamat Tempoh"
                If String.IsNullOrWhiteSpace(txtUlasan.Text) Then
                    ShowAlert("error", "", "Sila isi Ulasan kerana Status Permit adalah Tamat Tempoh")
                    e.Cancel = True
                    Exit Sub
                End If
            Case "Tidak Berdaftar"
                If String.IsNullOrWhiteSpace(txtPemerhatian.Text) Then
                    ShowAlert("error", "", "Sila isi Hasil Pemerhatian kerana Status Permit adalah Tidak Berdaftar")
                    e.Cancel = True
                    Exit Sub
                End If
        End Select

        '//run audit trail : Insert : Update : Delete : Login : Logout
        Dim noRujukan As String = GridView1.SelectedRow.Cells(1).Text
        GlobalClass.auditTrail("Semakan IK", noRujukan, "Kunci Masuk")
    End Sub

    Protected Sub FormView2_ItemInserted(sender As Object, e As System.Web.UI.WebControls.FormViewInsertedEventArgs) Handles FormView2.ItemInserted
        If e.Exception Is Nothing Then
            '// kemaskini status permohonan utama kepada peringkat seterusnya
            UpdateStatusPermohonan(CInt(GridView1.SelectedValue), "Semakan KB Inspektorat")

            ShowAlert("success", "", "Semakan berjaya disimpan dan dihantar kepada KB Inspektorat")

            pnlDetail.Visible = False
            idListing.Visible = True
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
