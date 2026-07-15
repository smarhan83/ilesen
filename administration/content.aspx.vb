Imports AjaxControlToolkit.HTMLEditor
Imports System.Data.SqlClient

Partial Class html_administration_content
    Inherits System.Web.UI.Page

    Protected Sub GridView1_RowDeleted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeletedEventArgs) Handles GridView1.RowDeleted
        FormView1.DataBind()
        FormView5.DataBind()
    End Sub

    Protected Sub GridView1_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs) Handles GridView1.RowDeleting
        Dim title As String = GridView1.Rows(e.RowIndex).Cells(1).Text

        '//run audit trail : Insert : Update : Delete : Login : Logout
        GlobalClass.auditTrail("Content Management", title, "Delete")
    End Sub

    Protected Sub GridView1_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles GridView1.SelectedIndexChanged
        FormView1.ChangeMode(DetailsViewMode.Edit)



    End Sub


    Protected Sub FormView1_ItemInserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertedEventArgs) Handles FormView1.ItemInserted
        GridView1.DataBind()
        FormView5.DataBind()
    End Sub

    Protected Sub FormView1_ItemInserting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertEventArgs) Handles FormView1.ItemInserting
        Dim titleTxt As TextBox = DirectCast(FormView1.FindControl("Content_NameTextBox0"), TextBox)
        Dim title As String = titleTxt.Text

        '//run audit trail : Insert : Update : Delete : Login : Logout
        GlobalClass.auditTrail("Content Management", title, "Insert")
    End Sub


    Protected Sub FormView1_ItemUpdated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdatedEventArgs) Handles FormView1.ItemUpdated
        GridView1.DataBind()
    End Sub


    Protected Sub FormView1_ItemUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdateEventArgs) Handles FormView1.ItemUpdating
        Dim nameTxt As TextBox = DirectCast(FormView1.FindControl("Content_NameTextBox0"), TextBox)
        Dim name As String = nameTxt.Text

        'Dim titleTxt As TextBox = DirectCast(FormView1.FindControl("Content_TitleTextBox0"), TextBox)
        'Dim title As String = titleTxt.Text

        'Dim bodyTxt As Editor = DirectCast(FormView1.FindControl("Editor1"), Editor)
        'Dim body As String = bodyTxt.Content

        'Dim newsTxt As CheckBox = DirectCast(FormView1.FindControl("CheckBox1"), CheckBox)
        'Dim news As String = newsTxt.Checked
        'Editor1
        'CheckBox1

        '//run audit trail : Insert : Update : Delete : Login : Logout
        GlobalClass.auditTrail("Content Management", name, "Update")
    End Sub

    Protected Sub UpdateButton_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        txtShadowStatus.Text = "DRAFT"
    End Sub

    Protected Sub SubmitButton_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        txtShadowStatus.Text = "NEW"
    End Sub

    Protected Sub PublishButton_Click(ByVal sender As Object, ByVal e As System.EventArgs)



        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Const SQL As String = "UPDATE [TBL_CONTENT] SET " & _
                "Content_Name = Content_NameShadow," & _
                "Content_Title=Content_TitleShadow," & _
                "Content_Body=Content_BodyShadow," & _
                "Content_CreatedBy=@Content_CreatedBy," & _
                "Content_CreatedDate=GETDATE()," & _
                "Content_PublishedBy=@Content_PublishedBy," & _
                "Content_PublishedDate=GETDATE()," & _
                "Content_ModifiedBy=@Content_ModifiedBy," & _
                "Content_ModifiedDate=GETDATE()," & _
                "Content_IsNews=Content_IsNewsShadow," & _
                "Content_IsPublish=1," & _
                "Content_ShadowStatus='COMPLETE' WHERE Content_Id = @Content_Id"

            Dim myCommand As New SqlCommand(SQL, myConnection)
            myCommand.Parameters.AddWithValue("@Content_Id", GridView1.SelectedValue)
            myCommand.Parameters.AddWithValue("@Content_CreatedBy", Session.Item("sessionUsersId"))
            myCommand.Parameters.AddWithValue("@Content_PublishedBy", Session.Item("sessionUsersId"))
            myCommand.Parameters.AddWithValue("@Content_ModifiedBy", Session.Item("sessionUsersId"))


            Dim recordset As Integer = myCommand.ExecuteNonQuery()

            myConnection.Close()

        End Using

        FormView1.DataBind()
        GridView1.DataBind()


    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        ScriptManager.RegisterStartupScript(Me.FormView1, FormView1.GetType, "loadAddonIcon", "loadAddonIcon();", True)


    End Sub

    Protected Sub UnPublishButton_Click(ByVal sender As Object, ByVal e As System.EventArgs)

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Const SQL As String = "UPDATE [TBL_CONTENT] SET " & _
                "Content_IsPublish=0," & _
                "Content_ShadowStatus='DRAFT' WHERE Content_Id = @Content_Id"

            Dim myCommand As New SqlCommand(SQL, myConnection)
            myCommand.Parameters.AddWithValue("@Content_Id", GridView1.SelectedValue)


            Dim recordset As Integer = myCommand.ExecuteNonQuery()

            myConnection.Close()

        End Using

        FormView1.DataBind()
        GridView1.DataBind()

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
            GridView1.Columns.Item(6).Visible = False '//grid delete

        End If
    End Sub

    Protected Sub CustomValidator1_ServerValidate(ByVal source As Object, ByVal args As System.Web.UI.WebControls.ServerValidateEventArgs)


        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQLSelect As String = "SELECT * FROM [TBL_CONTENT] WHERE Content_NameShadow =  @paraValue "

            If GridView1.SelectedValue > 0 Then
                SQLSelect = String.Concat(SQLSelect, " AND Content_Id <> @paraSelectedId ")
            End If

            Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)
            myCommandSelect.Parameters.AddWithValue("@paraValue", args.Value)

            If GridView1.SelectedValue > 0 Then
                myCommandSelect.Parameters.AddWithValue("@paraSelectedId", GridView1.SelectedValue)
            End If

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            If myReader.Read Then
                args.IsValid = False



                If FormView1.CurrentMode = FormViewMode.Insert Then
                    Dim lb As LinkButton = DirectCast(FormView1.FindControl("InsertButton"), LinkButton)
                    ScriptManager.GetCurrent(Page).RegisterPostBackControl(lb)
                ElseIf FormView1.CurrentMode = FormViewMode.Edit Then
                    Dim lb As LinkButton = DirectCast(FormView1.FindControl("UpdateButton"), LinkButton)
                    ScriptManager.GetCurrent(Page).RegisterPostBackControl(lb)

                    Dim lb2 As LinkButton = DirectCast(FormView1.FindControl("SubmitButton"), LinkButton)
                    ScriptManager.GetCurrent(Page).RegisterPostBackControl(lb2)
                End If

            Else
                args.IsValid = True
            End If

            myReader.Close()

            myConnection.Close()

        End Using

    End Sub



    Protected Sub FormView1_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles FormView1.DataBound



        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQLSelect As String = "SELECT COUNT(Content_Id) AS TotalPage," & _
                                    " (SELECT Webcon_PageLimit FROM [TBL_WEBCONFIG] WHERE Webcon_Enabled = 'Y') AS MaxPage " & _
                                    " FROM [TBL_CONTENT] "

            Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            If myReader.Read Then

                Dim TotalPage As Integer = myReader.Item("TotalPage") '// in bytes
                Dim MaxPage As Integer = myReader.Item("MaxPage") '// in MB

                'Label2.Text = "Total Content : " + TotalPage.ToString + "<br/>Maximum Content Allowed : " + MaxPage.ToString

                If TotalPage >= MaxPage Then

                    'args.IsValid = False

                    Try

                        If FormView1.CurrentMode = FormViewMode.Insert Then
                            Dim lb As LinkButton = DirectCast(FormView1.FindControl("InsertButton"), LinkButton)
                            lb.Visible = False
                        End If
                        

                        'If FormView1.CurrentMode = FormViewMode.Insert Then
                        '    Dim lb As LinkButton = DirectCast(FormView1.FindControl("InsertButton"), LinkButton)
                        '    ScriptManager.GetCurrent(Page).RegisterPostBackControl(lb)
                        'ElseIf FormView1.CurrentMode = FormViewMode.Edit Then
                        '    Dim lb As LinkButton = DirectCast(FormView1.FindControl("UpdateButton"), LinkButton)
                        '    ScriptManager.GetCurrent(Page).RegisterPostBackControl(lb)
                        'End If

                    Catch ex As Exception

                    End Try

                Else
                    If FormView1.CurrentMode = FormViewMode.Insert Then
                        Dim lb As LinkButton = DirectCast(FormView1.FindControl("InsertButton"), LinkButton)
                        lb.Visible = True
                    End If
                    
                    'args.IsValid = True
                End If


            Else
                If FormView1.CurrentMode = FormViewMode.Insert Then
                    Dim lb As LinkButton = DirectCast(FormView1.FindControl("InsertButton"), LinkButton)
                    lb.Visible = True
                End If
                
                'args.IsValid = True
            End If

            myReader.Close()

            myConnection.Close()

        End Using



    End Sub


End Class
