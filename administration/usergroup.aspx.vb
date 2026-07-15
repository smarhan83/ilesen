Imports System.Data.SqlClient
Partial Class html_administration_usergroup
    Inherits System.Web.UI.Page



    Protected Sub ListBox1_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ListBox1.SelectedIndexChanged
        btnUpdatePerm.Visible = True

        Dim UGN_Id As Integer
        Dim recordset As Integer

        UGN_Id = ListBox1.SelectedValue

        btnAddList.Enabled = True
        'MsgBox(sqlstr)
        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Const SQL As String = "INSERT TBL_USER_GROUPROLE (UGR_UGN_Id, UGR_UGM_Id, UGR_Read, UGR_Write, UGR_Approval)" & vbCrLf & _
            "SELECT @P_UGR_Id,UGM_Id,0 AS a,0 AS b,0 AS c FROM TBL_USER_GROUPMODULE" & vbCrLf & _
            "WHERE UGM_Id NOT IN (" & vbCrLf & _
             "SELECT UGR_UGM_Id FROM TBL_USER_GROUPROLE" & vbCrLf & _
             "WHERE UGR_UGN_Id = @P_UGR_Id" & vbCrLf & _
            ")"

            Dim myCommandInsert As New SqlCommand(SQL, myConnection)
            myCommandInsert.Parameters.AddWithValue("@P_UGR_Id", UGN_Id)

            myConnection.Open()

            recordset = myCommandInsert.ExecuteNonQuery()

            myConnection.Close()

        End Using
    End Sub

    Protected Sub Button1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddList.Click

        Dim UGN_Id As Integer = ListBox1.SelectedValue

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
            myConnection.Open()

            For Each listItem As ListItem In ListBox3.Items

                If listItem.Selected = True Then
                    Dim rowValue As Integer = listItem.Value
                    Dim recordset As Integer

                    Const SQL As String = "INSERT TBL_USER_GROUPLIST (UGL_UGN_Id, UGL_Users_Id) " & vbCrLf & _
                    "SELECT @UGN_Id,Users_Id FROM TBL_USERS" & vbCrLf & _
                    "WHERE Users_Id NOT IN (" & vbCrLf & _
                    "    SELECT UGL_Users_Id FROM TBL_USER_GROUPLIST" & vbCrLf & _
                    "    WHERE UGL_UGN_Id = @UGN_Id" & vbCrLf & _
                    ")" & vbCrLf & _
                    "AND Users_Id = @rowValue"

                    Dim myCommandInsert As New SqlCommand(SQL, myConnection)
                    myCommandInsert.Parameters.AddWithValue("@rowValue", rowValue)
                    myCommandInsert.Parameters.AddWithValue("@UGN_Id", UGN_Id)

                    recordset = myCommandInsert.ExecuteNonQuery()

                    If recordset = 1 Then
                        Dim title As String = ""
                        Dim sqlselect As String = "SELECT * FROM [TBL_USER_GROUPNAME] WHERE UGN_Id = @UGN_Id"

                        Dim myCommandSelect = New SqlCommand(sqlselect, myConnection)
                        myCommandSelect.Parameters.AddWithValue("@UGN_Id", UGN_Id)

                        Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

                        If myReader.Read Then

                            title = myReader.Item("UGN_Name")

                        End If

                        myReader.Close()

                        '//run audit trail : Insert : Update : Delete : Login : Logout
                        GlobalClass.auditTrail("Group Permission", title, "Add User Permission")

                    End If

                End If
            Next

            myConnection.Close()
        End Using
        ListBox2.DataBind()
        ListBox3.DataBind()

    End Sub

    Protected Sub Button2_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRemoveList.Click

        Dim UGN_Id As Integer = ListBox1.SelectedValue

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
            myConnection.Open()

            For Each listItem As ListItem In ListBox2.Items

                If listItem.Selected = True Then
                    Dim rowValue As Integer = listItem.Value
                    Dim recordset As Integer

                    Const SQL As String = "DELETE FROM TBL_USER_GROUPLIST WHERE UGL_Id = @rowValue"

                    Dim myCommandDelete As New SqlCommand(SQL, myConnection)
                    myCommandDelete.Parameters.AddWithValue("@rowValue", rowValue)

                    recordset = myCommandDelete.ExecuteNonQuery()

                    If recordset = 1 Then
                        Dim title As String = ""
                        Dim sqlselect As String = "SELECT * FROM [TBL_USER_GROUPNAME] WHERE UGN_Id = @UGN_Id"

                        Dim myCommandSelect = New SqlCommand(sqlselect, myConnection)
                        myCommandSelect.Parameters.AddWithValue("@UGN_Id", UGN_Id)

                        Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

                        If myReader.Read Then

                            title = myReader.Item("UGN_Name")

                        End If

                        myReader.Close()

                        '//run audit trail : Insert : Update : Delete : Login : Logout
                        GlobalClass.auditTrail("Group Permission", title, "Remove User Permission")

                    End If


                End If
            Next

            myConnection.Close()
        End Using
        ListBox2.DataBind()
        ListBox3.DataBind()
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim UGN_Id As String = ListBox1.SelectedValue
        Dim UGL_Id As String = ListBox2.SelectedValue
        Dim Users_Id As String = ListBox3.SelectedValue

        '//for << Add button
        If Users_Id = "" Then
            btnAddList.Enabled = False
        Else
            btnAddList.Enabled = True
        End If

        '//for Remove >> button
        If UGL_Id = "" Then
            btnRemoveList.Enabled = False
        Else
            btnRemoveList.Enabled = True
        End If

        '//update datasource
        If GlobalClass.isSuperAdmin(Session.Item("sessionUsersId")) Then
            SqlDataSource1.SelectCommand = "SELECT * FROM [TBL_USER_GROUPNAME]"
            SqlDataSource4.SelectCommand = "SELECT * FROM [TBL_USERS] WHERE Users_Id NOT IN (SELECT UGL_Users_Id FROM TBL_USER_GROUPLIST WHERE UGL_UGN_Id = @UGN_Id)"
        Else
            'SqlDataSource1.SelectCommand = "SELECT * FROM [TBL_USER_GROUPNAME] WHERE UGN_Id = 6"
            'SqlDataSource4.SelectCommand = "SELECT * FROM [TBL_USERS] WHERE Users_Id NOT IN (SELECT UGL_Users_Id FROM TBL_USER_GROUPLIST WHERE UGL_UGN_Id = @UGN_Id OR UGL_UGN_Id <> 6) "

            'GridView1.Visible = False
            SqlDataSource1.SelectCommand = "SELECT * FROM [TBL_USER_GROUPNAME]"
            SqlDataSource4.SelectCommand = "SELECT * FROM [TBL_USERS] WHERE Users_Id NOT IN (SELECT UGL_Users_Id FROM TBL_USER_GROUPLIST WHERE UGL_UGN_Id = @UGN_Id)"
        End If

    End Sub

    Protected Sub ListBox2_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ListBox2.SelectedIndexChanged


    End Sub

    Public Sub abc(ByVal message As String)
        MsgBox("a")
    End Sub

    Protected Sub GridView1_RowUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewUpdateEventArgs) Handles GridView1.RowUpdating
        Dim title As String = GridView1.Rows(e.RowIndex).Cells(0).Text

        '//run audit trail : Insert : Update : Delete : Login : Logout
        GlobalClass.auditTrail("Group Permission", title, "Update Permission")
    End Sub

    Protected Sub Page_PreRenderComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRenderComplete

        Dim frmview() As Object = {}
        Dim lbutton() As Object = {} '//allow control
        Dim ctlDeny() As Object = {btnAddList, btnRemoveList} '//deny control

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
    Protected Sub btnUpdatePerm_Click(sender As Object, e As EventArgs) Handles btnUpdatePerm.Click

        Dim strSql As StringBuilder = New StringBuilder(String.Empty)

        For i As Integer = 0 To GridView1.Rows.Count - 1

            Dim strID As String = GridView1.Rows(i).Cells(0).Text
            Dim cbRead As String = IIf((CType(GridView1.Rows(i).FindControl("cbRead"), CheckBox)).Checked = "True", 1, 0)
            Dim cbWrite As String = IIf((CType(GridView1.Rows(i).FindControl("cbWrite"), CheckBox)).Checked = "True", 1, 0)
            Dim cbApproval As String = IIf((CType(GridView1.Rows(i).FindControl("cbApproval"), CheckBox)).Checked = "True", 1, 0)


            Dim strUpdate As String = "Update TBL_USER_GROUPROLE set UGR_Read = " & cbRead & "," &
            " UGR_Write = " & cbWrite & "," &
            " UGR_Approval = " & cbApproval &
            " WHERE UGR_Id =" & strID & ";"
            strSql.Append(strUpdate)
        Next


        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
            myConnection.Open()

            Dim myCommand As New SqlCommand(strSql.ToString, myConnection)
            'myCommand.Parameters.AddWithValue("@rowValue", rowValue)

            If myCommand.ExecuteNonQuery() Then
                MessageBox("Record Updated Successfully.", Me)
            Else
                MessageBox("Failed To Update Record.", Me)
            End If

            myConnection.Close()
        End Using


    End Sub

    Public Sub MessageBox(ByVal Msg As String, ByVal obj As System.Web.UI.Page)
        Dim jscript As String
        Dim x = "OURServices"
        ScriptManager.RegisterClientScriptBlock(Me.Page, Me.[GetType](), "Alert", "alert('" & Msg & "');", True)

    End Sub

End Class
