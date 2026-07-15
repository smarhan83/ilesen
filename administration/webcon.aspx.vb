Imports System.Data.SqlClient

Partial Class html_administration_webcon
    Inherits System.Web.UI.Page

    Dim myConnection As SqlConnection
    Dim myCommand, myCommandAll, myCommandSelect As SqlCommand
    Dim recordset As Integer

    Protected Sub btnSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSave.Click

        Dim Webcon_Id As String = Int(Me.txtId.Text)
        Dim Webcon_Sitetitle As String = Me.txtSitetitle.Text
        Dim Webcon_Metatag As String = Me.txtMetatag.Text
        Dim Webcon_Footer As String = Me.txtFooter.Content
        Dim Webcon_Siteurl As String = Me.txtSiteurl.Text
        Dim Webcon_Servername As String = Me.txtServername.Text
        Dim Webcon_Email As String = Me.txtEmail.Text
        Dim Webcon_EmailServer As String = Me.txtEmailServer.Text

        Dim Webcon_FrontBlock1_Title As String = Me.txtFrontBlock1_Title.Text
        Dim Webcon_FrontBlock1_Content As String = Me.txtFrontBlock1_Content.Content
        Dim Webcon_FrontBlock2_Title As String = Me.txtFrontBlock2_Title.Text
        Dim Webcon_FrontBlock2_Content As String = Me.txtFrontBlock2_Content.Content
        Dim Webcon_InsideBlock1_Title As String = Me.txtInsideBlock1_Title.Text
        Dim Webcon_InsideBlock1_Content As String = Me.txtInsideBlock1_Content.Content
        Dim Webcon_InsideBlock2_Title As String = Me.txtInsideBlock2_Title.Text
        Dim Webcon_InsideBlock2_Content As String = Me.txtInsideBlock2_Content.Content


        If Webcon_Sitetitle = "" Or Webcon_Siteurl = "" Or Webcon_Servername = "" Or Webcon_Email = "" Or Webcon_EmailServer = "" Then
            MsgBox("Please fill in required field", MsgBoxStyle.Exclamation, "Save")
            Exit Sub
        End If

        Dim sqlstr As String

        If Webcon_Id > 0 Then
            sqlstr = "UPDATE TBL_WEBCONFIG SET Webcon_Sitetitle = " & _
            "'" & Replace(Webcon_Sitetitle, "'", "''") & "', Webcon_Metatag = '" & Replace(Webcon_Metatag, "'", "''") & "' , " & _
            "Webcon_Footer = '" & Replace(Webcon_Footer, "'", "''") & "', " & _
            "Webcon_Siteurl = '" & Replace(Webcon_Siteurl, "'", "''") & "' , " & _
            "Webcon_Email = '" & Replace(Webcon_Email, "'", "''") & "' , Webcon_Servername = '" & Replace(Webcon_Servername, "'", "''") & "' ," & _
            "Webcon_EmailServer = '" & Replace(Webcon_EmailServer, "'", "''") & "' ," & _
            "Webcon_FrontBlock1_Title = '" & Replace(Webcon_FrontBlock1_Title, "'", "''") & "' ," & _
            "Webcon_FrontBlock1_Content = '" & Replace(Webcon_FrontBlock1_Content, "'", "''") & "' ," & _
            "Webcon_FrontBlock2_Title = '" & Replace(Webcon_FrontBlock2_Title, "'", "''") & "' ," & _
            "Webcon_FrontBlock2_Content = '" & Replace(Webcon_FrontBlock2_Content, "'", "''") & "' ," & _
            "Webcon_InsideBlock1_Title = '" & Replace(Webcon_InsideBlock1_Title, "'", "''") & "' ," & _
            "Webcon_InsideBlock1_Content = '" & Replace(Webcon_InsideBlock1_Content, "'", "''") & "' ," & _
            "Webcon_InsideBlock2_Title = '" & Replace(Webcon_InsideBlock2_Title, "'", "''") & "' ," & _
            "Webcon_InsideBlock2_Content = '" & Replace(Webcon_InsideBlock2_Content, "'", "''") & "' " & _
            "WHERE Webcon_Id = " & Webcon_Id & ""
        Else
            sqlstr = "INSERT INTO [TBL_WEBCONFIG] " & _
                "([Webcon_Sitetitle],[Webcon_Metatag],[Webcon_Footer],[Webcon_Siteurl]," & _
                "[Webcon_Servername],[Webcon_Email],[Webcon_Enabled]," & _
                "[Webcon_EmailServer]," & _
                "[Webcon_FrontBlock1_Title]," & _
                "[Webcon_FrontBlock1_Content]," & _
                "[Webcon_FrontBlock2_Title]," & _
                "[Webcon_FrontBlock2_Content]," & _
                "[Webcon_InsideBlock1_Title]," & _
                "[Webcon_InsideBlock1_Content]," & _
                "[Webcon_InsideBlock2_Title]," & _
                "[Webcon_InsideBlock2_Content]" & _
                ")  " & _
                "VALUES (" & " '" & Replace(Webcon_Sitetitle, "'", "''") & "','" & Replace(Webcon_Metatag, "'", "''") & "','" & Replace(Webcon_Footer, "'", "''") & "','" & Replace(Webcon_Siteurl, "'", "''") & "','" & Replace(Webcon_Servername, "'", "''") & "','" & Replace(Webcon_Email, "'", "''") & "','N', " & " " & _
                "'" & Replace(Webcon_EmailServer, "'", "''") & "'," & _
                "'" & Replace(Webcon_FrontBlock1_Title, "'", "''") & "'," & _
                "'" & Replace(Webcon_FrontBlock1_Content, "'", "''") & "'," & _
                "'" & Replace(Webcon_FrontBlock2_Title, "'", "''") & "'," & _
                "'" & Replace(Webcon_FrontBlock2_Content, "'", "''") & "'," & _
                "'" & Replace(Webcon_InsideBlock1_Title, "'", "''") & "'," & _
                "'" & Replace(Webcon_InsideBlock1_Content, "'", "''") & "'," & _
                "'" & Replace(Webcon_InsideBlock2_Title, "'", "''") & "'," & _
                "'" & Replace(Webcon_InsideBlock2_Content, "'", "''") & "'" & _
                ") "
        End If


        'Response.Write(sqlstr)
        'Response.End()

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            myCommand = New SqlCommand(sqlstr, myConnection)

            recordset = myCommand.ExecuteNonQuery()

            If recordset = 1 Then

                If Webcon_Id > 0 Then
                    '//run audit trail : Insert : Update : Delete : Login : Logout
                    GlobalClass.auditTrail("Web Configuration", Webcon_Sitetitle, "Update")
                Else
                    '//run audit trail : Insert : Update : Delete : Login : Logout
                    GlobalClass.auditTrail("Web Configuration", Webcon_Sitetitle, "Insert")
                End If

            End If

            myConnection.Close()

        End Using
        GridView1.DataBind()

        If Webcon_Id = 0 Then
            Response.Redirect("webcon.aspx")
        End If

    End Sub


    Protected Sub GridView1_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles GridView1.RowCommand

        If e.CommandName = "Use" Then '//Update enabled configuration

            Dim primaryKey As Integer = Convert.ToInt32(e.CommandArgument)

            Dim sqlstrupdateall, sqlstrupdateenabled As String
            sqlstrupdateall = "UPDATE [TBL_WEBCONFIG] SET [Webcon_Enabled] = 'N' "
            sqlstrupdateenabled = "UPDATE [TBL_WEBCONFIG] SET [Webcon_Enabled] = 'Y' WHERE [Webcon_Id] = " & primaryKey & ""

            Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

                myConnection.Open()

                '//update all record to 'N'
                myCommandAll = New SqlCommand(sqlstrupdateall, myConnection)
                recordset = myCommandAll.ExecuteNonQuery()
                '//update selected record to 'Y'
                myCommandSelect = New SqlCommand(sqlstrupdateenabled, myConnection)
                recordset = myCommandSelect.ExecuteNonQuery()

                If recordset = 1 Then
                    Dim title As String = ""
                    Dim sqlselect As String = "SELECT * FROM [TBL_WEBCONFIG] WHERE Webcon_id = @primaryKey"

                    Dim myCommandSelect = New SqlCommand(sqlselect, myConnection)
                    myCommandSelect.Parameters.AddWithValue("@primaryKey", primaryKey)

                    Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

                    If myReader.Read Then

                        title = myReader.Item("Webcon_Sitetitle")

                    End If

                    myReader.Close()

                    '//run audit trail : Insert : Update : Delete : Login : Logout
                    GlobalClass.auditTrail("Feedback Management", title, "Used")

                End If

                myConnection.Close()

            End Using

            GridView1.DataBind()

        ElseIf e.CommandName = "EditBack" Then '//Edit function

            Dim primaryKey As Integer = Convert.ToInt32(e.CommandArgument)

            Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

                Const SQL As String = "SELECT * FROM [TBL_WEBCONFIG] WHERE [Webcon_Id] = @primaryKey "

                Dim myCommandEdit As New SqlCommand(SQL, myConnection)
                myCommandEdit.Parameters.AddWithValue("@primaryKey", primaryKey)

                myConnection.Open()

                Dim myReader As SqlDataReader = myCommandEdit.ExecuteReader

                If myReader.Read Then


                    Dim Webcon_Id = myReader("Webcon_Id")
                    Dim Webcon_Sitetitle = myReader("Webcon_Sitetitle")
                    Dim Webcon_Siteurl = myReader("Webcon_Siteurl")
                    Dim Webcon_Servername = myReader("Webcon_Servername")
                    Dim Webcon_Email = myReader("Webcon_Email")
                    Dim Webcon_Metatag = myReader("Webcon_Metatag")
                    Dim Webcon_Footer = myReader("Webcon_Footer")
                    Dim Webcon_EmailServer = myReader("Webcon_EmailServer")

                    Dim Webcon_FrontBlock1_Title = myReader("Webcon_FrontBlock1_Title")
                    Dim Webcon_FrontBlock1_Content = myReader("Webcon_FrontBlock1_Content")
                    Dim Webcon_FrontBlock2_Title = myReader("Webcon_FrontBlock2_Title")
                    Dim Webcon_FrontBlock2_Content = myReader("Webcon_FrontBlock2_Content")
                    Dim Webcon_InsideBlock1_Title = myReader("Webcon_InsideBlock1_Title")
                    Dim Webcon_InsideBlock1_Content = myReader("Webcon_InsideBlock1_Content")
                    Dim Webcon_InsideBlock2_Title = myReader("Webcon_InsideBlock2_Title")
                    Dim Webcon_InsideBlock2_Content = myReader("Webcon_InsideBlock2_Content")

                    txtId.Text = Webcon_Id
                    txtSitetitle.Text = Webcon_Sitetitle.ToString
                    txtSiteurl.Text = Webcon_Siteurl.ToString
                    txtServername.Text = Webcon_Servername.ToString
                    txtEmail.Text = Webcon_Email.ToString
                    txtMetatag.Text = Webcon_Metatag.ToString
                    txtFooter.Content = Webcon_Footer.ToString
                    txtEmailServer.Text = Webcon_EmailServer.ToString

                    txtFrontBlock1_Title.Text = Webcon_FrontBlock1_Title.ToString
                    txtFrontBlock1_Content.Content = Webcon_FrontBlock1_Content.ToString
                    txtFrontBlock2_Title.Text = Webcon_FrontBlock2_Title.ToString
                    txtFrontBlock2_Content.Content = Webcon_FrontBlock2_Content.ToString
                    txtInsideBlock1_Title.Text = Webcon_InsideBlock1_Title.ToString
                    txtInsideBlock1_Content.Content = Webcon_InsideBlock1_Content.ToString
                    txtInsideBlock2_Title.Text = Webcon_InsideBlock2_Title.ToString
                    txtInsideBlock2_Content.Content = Webcon_InsideBlock2_Content.ToString



                End If

                myReader.Close()

                myConnection.Close()

            End Using

        End If

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Me.txtId.Text = "" Then
            Me.txtId.Text = 0
        End If
        GridView1.DataBind()
    End Sub

    Protected Sub Button1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnReset.Click
        Response.Redirect("webcon.aspx")
    End Sub

    Protected Sub GridView1_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs) Handles GridView1.RowDeleting
        Dim title As String = GridView1.Rows(e.RowIndex).Cells(2).Text

        '//run audit trail : Insert : Update : Delete : Login : Logout
        GlobalClass.auditTrail("Web Configuration", title, "Delete")
    End Sub

    Protected Sub Page_PreRenderComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRenderComplete

        Dim frmview() As Object = {FormView1} '//TabContainer1
        Dim lbutton() As Object = {} '//allow control
        Dim ctlDeny() As Object = {btnSave, btnReset} '//deny control


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
            GridView1.Columns.Item(0).Visible = False '//grid delete
            GridView1.Columns.Item(12).Visible = False '//grid delete

        End If
    End Sub

    Protected Sub GridView1_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles GridView1.SelectedIndexChanged
        FormView1.DataBind()
        FormView1.ChangeMode(FormViewMode.Edit)
    End Sub

    Protected Sub FormView1_ItemInserting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertEventArgs) Handles FormView1.ItemInserting

        Dim titleTxt As TextBox = DirectCast(FormView1.FindControl("Webcon_SitetitleTextBox"), TextBox)
        Dim title As String = titleTxt.Text

        '//run audit trail : Insert : Update : Delete : Login : Logout
        GlobalClass.auditTrail("Web Configuration", title, "Insert")
    End Sub

    Protected Sub FormView1_ItemUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdateEventArgs) Handles FormView1.ItemUpdating
        Dim titleTxt As TextBox = DirectCast(FormView1.FindControl("Webcon_SitetitleTextBox"), TextBox)
        Dim title As String = titleTxt.Text

        '//run audit trail : Insert : Update : Delete : Login : Logout
        GlobalClass.auditTrail("Web Configuration", title, "Update")
    End Sub

    Protected Sub FormView1_ItemInserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertedEventArgs) Handles FormView1.ItemInserted
        GridView1.DataBind()
        FormView1.ChangeMode(FormViewMode.Edit)
    End Sub

    Protected Sub FormView1_ItemUpdated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdatedEventArgs) Handles FormView1.ItemUpdated
        GridView1.DataBind()
        FormView1.ChangeMode(FormViewMode.Edit)
    End Sub
End Class
