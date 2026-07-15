Imports System.Data.SqlClient

Partial Class pages
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim Content_Name As String
        Dim Content_Id As Integer = 0
        Dim Menu_Id As Integer = 0

        Content_Name = Request.QueryString("Content_Name")

        If Content_Name <> "" Then
            Content_Name = Convert.ToString(Content_Name)
        Else
            Content_Name = "null"
        End If

        'TrailPlaceHolder.Visible = True

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Const sqlstr As String = "SELECT content.Content_Id,content.Content_Title,content.Content_Body,menu.UGM_ParentId,menu.UGM_Id FROM [TBL_CONTENT] content " &
                                    " LEFT JOIN [TBL_USER_GROUPMODULE] menu ON content.Content_Id = menu.UGM_ContentId " &
                                    " WHERE content.Content_Name = @Content_Name AND content.Content_IsPublish = 1 "

            Dim myCommand As New SqlCommand(sqlstr, myConnection)
            myCommand.Parameters.AddWithValue("@Content_Name", Content_Name)

            myConnection.Open()

            Dim myReader As SqlDataReader = myCommand.ExecuteReader

            If myReader.Read Then

                Content_Id = myReader("Content_Id")



                If IsDBNull(myReader("UGM_Id")) Then
                    Menu_Id = 0
                Else
                    Menu_Id = myReader("UGM_Id")
                End If


                Dim Content_Body = myReader("Content_Body")
                Dim Menu_ParentId = myReader("UGM_ParentId")
                Dim Content_Title = myReader("Content_Title")

                '//write left menu
                'If Menu_ParentId > 0 Then
                ' = GlobalClass.WriteLeftMenu(Menu_ParentId)

                'End If


                If IsDBNull(Content_Body) Then
                    Content_Body = ""
                End If

                If IsDBNull(Content_Title) Then
                    Content_Title = ""
                End If


                'idContentBody.InnerHtml = Content_Body
                'ContentPageTitle.InnerHtml = Content_Title

                'generate code for translate
                Dim Lang_code As String = ""
                Lang_code = "CP" + Content_Id.ToString

                Dim Lang_code_menu As String = ""
                Lang_code_menu = "MU" + Menu_Id.ToString

                '// text_to_translate, code_translate, category, description ,if true automatic insert
                'idContentBody.InnerHtml = GlobalClass.translang(Content_Body, "Content Page", Lang_code, "Content : " + Content_Title, True)
                'ContentPageTitle.InnerHtml = GlobalClass.translang("/ " + Content_Title, "Menu", Lang_code_menu, "Menu : " + Content_Title, True)

                idContentBody.InnerHtml = Content_Body
                ContentPageTitle.InnerHtml = Content_Title

            End If

            myReader.Close()
            myConnection.Close()

        End Using
    End Sub
End Class
