Imports System.Data.SqlClient
Partial Class userrole
    Inherits System.Web.UI.Page


    Private Sub initPageName()
        '// get page name
        Dim menuName As String = GlobalClass.writeTitlePage(Request.QueryString("m_Id"), "")


        If menuName = "" Then
            menuName = "Peranan"
        End If

        idWindowTitle.InnerText = menuName

    End Sub
    Protected Sub ListBox1_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ListBox1.SelectedIndexChanged

        Dim UGN_Id As Integer
        Dim recordset As Integer

        UGN_Id = ListBox1.SelectedValue

        btnAddList.Enabled = True
        'MsgBox(sqlstr)
        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Const SQL As String = "INSERT TBL_USER_GROUPROLE (UGR_UGN_Id, UGR_UGM_Id, UGR_Read, UGR_Write, UGR_Approval)" & vbCrLf &
            "SELECT @P_UGR_Id,UGM_Id,0 AS a,0 AS b,0 AS c FROM TBL_USER_GROUPMODULE" & vbCrLf &
            "WHERE UGM_Id NOT IN (" & vbCrLf &
             "SELECT UGR_UGM_Id FROM TBL_USER_GROUPROLE" & vbCrLf &
             "WHERE UGR_UGN_Id = @P_UGR_Id" & vbCrLf &
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

                    Const SQL As String = "INSERT TBL_USER_GROUPLIST (UGL_UGN_Id, UGL_Users_Id) " & vbCrLf &
                    "SELECT @UGN_Id,Users_Id FROM TBL_USERS" & vbCrLf &
                    "WHERE Users_Id NOT IN (" & vbCrLf &
                    "    SELECT UGL_Users_Id FROM TBL_USER_GROUPLIST" & vbCrLf &
                    "    WHERE UGL_UGN_Id = @UGN_Id" & vbCrLf &
                    ")" & vbCrLf &
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
        initPageName()

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
        SqlDataSource1.SelectCommand = "SELECT * FROM [TBL_USER_GROUPNAME] where UGN_IsAdmin = 0 "
        SqlDataSource4.SelectCommand = "SELECT * FROM [TBL_USERS] WHERE Users_Id NOT IN (SELECT UGL_Users_Id FROM TBL_USER_GROUPLIST WHERE UGL_UGN_Id = @UGN_Id)"

        'If GlobalClass.isSuperAdmin(Session.Item("sessionUsersId")) Then
        '    SqlDataSource1.SelectCommand = "SELECT * FROM [TBL_USER_GROUPNAME]"
        '    SqlDataSource4.SelectCommand = "SELECT * FROM [TBL_USERS] WHERE Users_Id NOT IN (SELECT UGL_Users_Id FROM TBL_USER_GROUPLIST WHERE UGL_UGN_Id = @UGN_Id)"
        'Else
        '    'SqlDataSource1.SelectCommand = "SELECT * FROM [TBL_USER_GROUPNAME] WHERE UGN_Id = 6"
        '    'SqlDataSource4.SelectCommand = "SELECT * FROM [TBL_USERS] WHERE Users_Id NOT IN (SELECT UGL_Users_Id FROM TBL_USER_GROUPLIST WHERE UGL_UGN_Id = @UGN_Id OR UGL_UGN_Id <> 6) "

        '    'GridView1.Visible = False
        '    SqlDataSource1.SelectCommand = "SELECT * FROM [TBL_USER_GROUPNAME]"
        '    SqlDataSource4.SelectCommand = "SELECT * FROM [TBL_USERS] WHERE Users_Id NOT IN (SELECT UGL_Users_Id FROM TBL_USER_GROUPLIST WHERE UGL_UGN_Id = @UGN_Id)"
        'End If

    End Sub

    Protected Sub ListBox2_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ListBox2.SelectedIndexChanged

        btnRemoveList.Visible = True
        btnAddList.Visible = False

    End Sub

    Private Sub ListBox3_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ListBox3.SelectedIndexChanged
        btnRemoveList.Visible = False
        btnAddList.Visible = True
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
            'GridView1.Columns.Item(7).Visible = False '//grid delete

        End If
    End Sub

    Public Sub MessageBox(ByVal Msg As String, ByVal obj As System.Web.UI.Page)
        Dim jscript As String
        Dim x = "OURServices"
        ScriptManager.RegisterClientScriptBlock(Me.Page, Me.[GetType](), "Alert", "alert('" & Msg & "');", True)

    End Sub


End Class
