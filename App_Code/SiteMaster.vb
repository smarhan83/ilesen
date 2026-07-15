Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Web.SessionState.HttpSessionState
Imports System.Net
Imports System.Text
Imports System.Security.Cryptography
Imports System.Net.Mail


Public Class SiteMaster


    Public Shared Function WriteAdminMenu(ByVal paraMenuId As Integer, ByVal userrole As Integer, ByVal isAdmin As Integer) As String

        isAdmin = HttpContext.Current.Session.Item("sessionisadmin")
        'MsgBox(isAdmin)
        userrole = HttpContext.Current.Session.Item("sessionuserrole")
        Dim sessionUserId As Integer = HttpContext.Current.Session.Item("sessionUsersId")
        Dim sessionSystemId As Integer = 0
        Try
            sessionSystemId = HttpContext.Current.Session.Item("sessionSystemId")
        Catch ex As Exception

        End Try

        Dim retval As String
        Dim glblClass As New GlobalClass()
        retval = ""

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
            myConnection.Open()

            Dim myCommand As New SqlCommand("generateAdminMenu_PROC3", myConnection)
            myCommand.Parameters.AddWithValue("@UGM_Id", paraMenuId)
            myCommand.Parameters.AddWithValue("@UGR_UGN_Id", userrole)
            myCommand.Parameters.AddWithValue("@UGN_IsAdmin", isAdmin)
            myCommand.Parameters.AddWithValue("@userid", sessionUserId)
            myCommand.Parameters.AddWithValue("@systemID", sessionSystemId)

            myCommand.CommandType = CommandType.StoredProcedure

            Dim myReader As SqlDataReader = myCommand.ExecuteReader
            Dim j As Integer = 0
            Dim isActive As String = ""

            Do While myReader.Read()

                Dim UGM_Name = myReader.Item("UGM_Name")
                Dim UGM_ContentId = myReader.Item("UGM_ContentId")
                Dim UGM_ParentId = myReader.Item("UGM_ParentId")
                Dim UGM_Id = myReader.Item("UGM_Id")
                Dim UGM_Filename = myReader.Item("UGM_Filename")
                Dim UGR_UGN_Id = myReader.Item("UGR_UGN_Id")
                Dim UGM_Level = myReader.Item("UGM_Level")
                Dim UGN_IsAdmin = myReader.Item("UGN_IsAdmin")
                Dim UGM_Menu_Icon = myReader.Item("UGM_Menu_Icon")
                Dim UGM_Menu_SVG = myReader.Item("UGM_Menu_SVG")
                Dim filepath As String

                Dim pageFilename As String
                pageFilename = System.IO.Path.GetFileName(HttpContext.Current.Request.ServerVariables("SCRIPT_NAME"))

                j = j + 1

                If j = 1 And HttpContext.Current.Request.QueryString("p_Id") = "" Then
                    isActive = "active"
                Else
                    isActive = ""
                End If

                If InStr(UGM_Filename.ToString, "p_Id") > 0 Then
                    filepath = UGM_Filename.ToString

                Else
                    filepath = UGM_Filename.ToString + "&p_Id=" + UGM_ParentId.ToString
                End If

                If InStr(UGM_Filename.ToString, "?") > 0 Then

                    If InStr(UGM_Filename.ToString, "p_Id") > 0 Then
                        filepath = UGM_Filename.ToString
                    Else
                        filepath = UGM_Filename.ToString + "&p_Id=" + UGM_ParentId.ToString
                    End If

                Else
                    filepath = UGM_Filename.ToString + "?p_Id=" + UGM_ParentId.ToString
                End If

                '//append Menu ID
                If InStr(filepath, "?") > 0 Then
                    filepath = filepath + "&m_Id=" + UGM_Id.ToString
                Else
                    filepath = UGM_Filename.ToString + "?m_Id=" + UGM_Id.ToString
                End If

                If UGM_ContentId.ToString = "0" And UGM_Filename.ToString = "" Then '// ori : Menu_ContentId.ToString = "0" And Menu_ParentId.ToString = 0 And Menu_Filename.ToString <> "Default.aspx"

                    If UGM_Level = 1 Then
                        If UGM_Id = HttpContext.Current.Request.QueryString("p_Id") Then

                            retval = String.Concat(retval, "<li class='nav-item active'><a class='nav-link active' data-toggle='tab' href='#A" + CStr(UGM_Id) + "' title='" + UGM_Name + "'>")
                            retval = String.Concat(retval, "" + UGM_Menu_SVG + "</a></li>")
                        Else

                            retval = String.Concat(retval, "<li class='nav-item " + isActive + "'><a class='nav-link " + isActive + "' data-toggle='tab' href='#A" + CStr(UGM_Id) + "' title='" + UGM_Name + "'>")
                            retval = String.Concat(retval, "" + UGM_Menu_SVG + "</a></li>")
                        End If

                    Else

                    End If
                Else
                    If UGM_Level = 1 Then

                    Else

                    End If

                End If


            Loop

            myReader.Close()

            myConnection.Close()
            myConnection.Dispose()
        End Using

        Return retval

    End Function

    Private Shared parentMenu As String = ""
    Public Shared Function WriteAdminMenu_Sub(ByVal paraMenuId As Integer, ByVal userrole As Integer, ByVal isAdmin As Integer) As String

        isAdmin = HttpContext.Current.Session.Item("sessionisadmin")
        'MsgBox(isAdmin)
        userrole = HttpContext.Current.Session.Item("sessionuserrole")
        Dim sessionUserId As Integer = HttpContext.Current.Session.Item("sessionUsersId")
        Dim sessionSystemId As Integer = 0
        Try
            sessionSystemId = HttpContext.Current.Session.Item("sessionSystemId")
        Catch ex As Exception

        End Try

        Dim retval As String
        Dim glblClass As New GlobalClass()
        retval = ""
        Dim j As Integer = 0
        Dim parentMenu2 As String = ""
        Dim isActive As String = ""
        Dim showSubTitle As Boolean = False
        Dim UGM_NameParent As String = ""

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
            myConnection.Open()

            Dim myCommand As New SqlCommand("generateAdminMenu_PROC3", myConnection)
            myCommand.Parameters.AddWithValue("@UGM_Id", paraMenuId)
            myCommand.Parameters.AddWithValue("@UGR_UGN_Id", userrole)
            myCommand.Parameters.AddWithValue("@UGN_IsAdmin", isAdmin)
            myCommand.Parameters.AddWithValue("@userid", sessionUserId)
            myCommand.Parameters.AddWithValue("@systemID", sessionSystemId)

            myCommand.CommandType = CommandType.StoredProcedure

            Dim myReader As SqlDataReader = myCommand.ExecuteReader


            Do While myReader.Read()

                Dim UGM_Name = myReader.Item("UGM_Name")
                Dim UGM_ContentId = myReader.Item("UGM_ContentId")
                Dim UGM_ParentId = myReader.Item("UGM_ParentId")
                Dim UGM_Id = myReader.Item("UGM_Id")
                Dim UGM_Filename = myReader.Item("UGM_Filename")
                Dim UGR_UGN_Id = myReader.Item("UGR_UGN_Id")
                Dim UGM_Level = myReader.Item("UGM_Level")
                Dim UGN_IsAdmin = myReader.Item("UGN_IsAdmin")
                Dim UGM_Menu_Icon = myReader.Item("UGM_Menu_Icon")
                Dim filepath As String

                Dim pageFilename As String
                pageFilename = System.IO.Path.GetFileName(HttpContext.Current.Request.ServerVariables("SCRIPT_NAME"))

                j = j + 1


                If j = 1 And HttpContext.Current.Request.QueryString("p_Id") = "" Then
                    isActive = "active show"
                Else
                    isActive = ""
                End If

                If UGM_ParentId = 0 Then
                    parentMenu2 = CStr(UGM_Id)
                Else
                    parentMenu2 = CStr(UGM_ParentId)
                End If

                If parentMenu <> parentMenu2 And j > 1 Then
                    retval = String.Concat(retval, "</div>")
                End If


                If UGM_ParentId = 0 Then
                    parentMenu = CStr(UGM_Id)
                Else
                    parentMenu = CStr(UGM_ParentId)
                End If



                If InStr(UGM_Filename.ToString, "p_Id") > 0 Then
                    filepath = UGM_Filename.ToString

                Else
                    filepath = UGM_Filename.ToString + "&p_Id=" + UGM_ParentId.ToString
                End If


                If InStr(UGM_Filename.ToString, "?") > 0 Then

                    If InStr(UGM_Filename.ToString, "p_Id") > 0 Then
                        filepath = UGM_Filename.ToString
                    Else
                        filepath = UGM_Filename.ToString + "&p_Id=" + UGM_ParentId.ToString
                    End If

                Else
                    filepath = UGM_Filename.ToString + "?p_Id=" + UGM_ParentId.ToString
                End If

                '//append Menu ID
                If InStr(filepath, "?") > 0 Then
                    filepath = filepath + "&m_Id=" + UGM_Id.ToString
                Else
                    filepath = UGM_Filename.ToString + "?m_Id=" + UGM_Id.ToString
                End If

                If UGM_Level = 1 Then
                    If UGM_Id = HttpContext.Current.Request.QueryString("p_Id") Then
                        retval = String.Concat(retval, "<div class='tab-pane fade active show' id='A" + CStr(UGM_Id) + "' >")
                    Else
                        retval = String.Concat(retval, "<div class='tab-pane fade " + isActive + "' id='A" + CStr(UGM_Id) + "' >")
                    End If
                    showSubTitle = True
                    UGM_NameParent = UGM_Name
                Else

                    If (UGM_Filename.ToString.Contains(pageFilename)) Then

                        retval = String.Concat(retval, "<ul class='metismenu tab-nav-menu'>")

                        If showSubTitle = True Then
                            retval = String.Concat(retval, "<li class='nav-label'>" & UGM_NameParent & "</li>")
                        End If

                        retval = String.Concat(retval, "<li><a href ='" + filepath + "' class='ai-icon' aria-expanded='false'>")
                        retval = String.Concat(retval, "        <svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' width='24px' height='24px' viewBox='0 0 24 24' version='1.1'><g stroke='none' stroke-width='1' fill='none' fill-rule='evenodd'><polygon points='0 0 24 0 24 24 0 24'/><path d='M22,15 L22,19 C22,20.1045695 21.1045695,21 20,21 L8,21 C5.790861,21 4,19.209139 4,17 C4,14.790861 5.790861,13 8,13 L20,13 C21.1045695,13 22,13.8954305 22,15 Z M7,19 C8.1045695,19 9,18.1045695 9,17 C9,15.8954305 8.1045695,15 7,15 C5.8954305,15 5,15.8954305 5,17 C5,18.1045695 5.8954305,19 7,19 Z' fill='#000000' opacity='0.3'/><path d='M15.5421357,5.69999981 L18.3705628,8.52842693 C19.1516114,9.30947552 19.1516114,10.5758055 18.3705628,11.3568541 L9.88528147,19.8421354 C8.3231843,21.4042326 5.79052439,21.4042326 4.22842722,19.8421354 C2.66633005,18.2800383 2.66633005,15.7473784 4.22842722,14.1852812 L12.7137086,5.69999981 C13.4947572,4.91895123 14.7610871,4.91895123 15.5421357,5.69999981 Z M7,19 C8.1045695,19 9,18.1045695 9,17 C9,15.8954305 8.1045695,15 7,15 C5.8954305,15 5,15.8954305 5,17 C5,18.1045695 5.8954305,19 7,19 Z' fill='#000000' opacity='0.3'/><path d='M5,3 L9,3 C10.1045695,3 11,3.8954305 11,5 L11,17 C11,19.209139 9.209139,21 7,21 C4.790861,21 3,19.209139 3,17 L3,5 C3,3.8954305 3.8954305,3 5,3 Z M7,19 C8.1045695,19 9,18.1045695 9,17 C9,15.8954305 8.1045695,15 7,15 C5.8954305,15 5,15.8954305 5,17 C5,18.1045695 5.8954305,19 7,19 Z' fill='#000000'/></g></svg>")
                        retval = String.Concat(retval, "        <span Class='nav-text'>" + UGM_Name + "</span>")
                        retval = String.Concat(retval, "	</a></li></ul>")
                    Else

                        retval = String.Concat(retval, "<ul class='metismenu tab-nav-menu'>")

                        If showSubTitle = True Then
                            retval = String.Concat(retval, "<li class='nav-label'>" & UGM_NameParent & "</li>")
                        End If

                        retval = String.Concat(retval, "<li><a href ='" + filepath + "' class='ai-icon' aria-expanded='false'>")
                        retval = String.Concat(retval, "        <svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' width='24px' height='24px' viewBox='0 0 24 24' version='1.1'><g stroke='none' stroke-width='1' fill='none' fill-rule='evenodd'><polygon points='0 0 24 0 24 24 0 24'/><path d='M22,15 L22,19 C22,20.1045695 21.1045695,21 20,21 L8,21 C5.790861,21 4,19.209139 4,17 C4,14.790861 5.790861,13 8,13 L20,13 C21.1045695,13 22,13.8954305 22,15 Z M7,19 C8.1045695,19 9,18.1045695 9,17 C9,15.8954305 8.1045695,15 7,15 C5.8954305,15 5,15.8954305 5,17 C5,18.1045695 5.8954305,19 7,19 Z' fill='#000000' opacity='0.3'/><path d='M15.5421357,5.69999981 L18.3705628,8.52842693 C19.1516114,9.30947552 19.1516114,10.5758055 18.3705628,11.3568541 L9.88528147,19.8421354 C8.3231843,21.4042326 5.79052439,21.4042326 4.22842722,19.8421354 C2.66633005,18.2800383 2.66633005,15.7473784 4.22842722,14.1852812 L12.7137086,5.69999981 C13.4947572,4.91895123 14.7610871,4.91895123 15.5421357,5.69999981 Z M7,19 C8.1045695,19 9,18.1045695 9,17 C9,15.8954305 8.1045695,15 7,15 C5.8954305,15 5,15.8954305 5,17 C5,18.1045695 5.8954305,19 7,19 Z' fill='#000000' opacity='0.3'/><path d='M5,3 L9,3 C10.1045695,3 11,3.8954305 11,5 L11,17 C11,19.209139 9.209139,21 7,21 C4.790861,21 3,19.209139 3,17 L3,5 C3,3.8954305 3.8954305,3 5,3 Z M7,19 C8.1045695,19 9,18.1045695 9,17 C9,15.8954305 8.1045695,15 7,15 C5.8954305,15 5,15.8954305 5,17 C5,18.1045695 5.8954305,19 7,19 Z' fill='#000000'/></g></svg>")
                        retval = String.Concat(retval, "        <span Class='nav-text'>" + UGM_Name + "</span>")
                        retval = String.Concat(retval, "	</a></li></ul>")
                    End If

                    showSubTitle = False
                End If


            Loop

            myReader.Close()

            myConnection.Close()
            myConnection.Dispose()
        End Using

        If j > 0 Then
            retval = String.Concat(retval, "</div>")
        End If

        Return retval

    End Function


End Class




