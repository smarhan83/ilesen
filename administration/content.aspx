<%@ Page Title="" Language="VB" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="content.aspx.vb" Inherits="html_administration_content" %>

<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="asp" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit.HTMLEditor" tagprefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
    <style type="text/css">
        .style1
        {
            width: 161px;
        }
        .style2
        {
            width: 176px;
            height: 29px;
        }
        .style3
        {
            height: 29px;
        }
        .style4
        {
            width: 176px;
            height: 20px;
        }
        .style5
        {
            height: 20px;
        }
        .style6
        {
            width: 176px;
        }
    </style>

    
    <script type="text/javascript" language="javascript" >

        function loadAddonIcon() {

            $(".ajax__htmleditor_editor_toptoolbar").each(function (index) {
                $(this).html($(this).html() + "<img onclick=showImgManager('" + index + "') src='FileManager/icons/img-add-32.png' class='ajax__htmleditor_toolbar_button' /><img onclick=showFileManager('" + index + "') src='FileManager/icons/Files-add-32.png' class='ajax__htmleditor_toolbar_button' /><div style='display:none;float:left;width:100%;padding-top:5px;' id='divImgManager" + index + "'></div>");

            });
        }

        function openFileManager(index) {

            //window.open("FileManager/Default.aspx?sessionid=<%= Session.SessionID %>&input=" + index, "myWindow", "status = 1, height = 650, width = 950, resizable = 0")
            window.open("Gallery.aspx?sessionid=<%= Session.SessionID %>", "myWindow", "status = 1, height = 650, width = 950, resizable = 0")
        }

    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    
    <section class="content-header">
        <div class="container-fluid">

         <div class="row mb-2">
             <div class="col-sm-6">
                 <h1 class="m-0 text-dark">Content Page</h1>
             </div>
             <!-- /.col -->
             <div class="col-sm-6">
                 <ol class="breadcrumb float-sm-right">
                     <%--<li class="breadcrumb-item"><a href="#">Administration</a></li>
                     <li class="breadcrumb-item active">User</li>--%>
                     <%= GlobalClass.writeBreadcrumb(Request.QueryString("p_Id"), Request.QueryString("m_Id"), Session.Item("sessionSystemId")) %>
                 </ol>
             </div>
             <!-- /.col -->
         </div>
         <!-- /.row -->

        </div>
    </section>

    
    <!-- Main content -->
    <section class="content">
        <div class="container-fluid">

            <div class="card card-warning">
                                        
                        <div class="card-body">


                    <%--Current page usage :--%>
         <asp:FormView ID="FormView5" runat="server" DataSourceID="SqlDataSourceGraph0" visible="false"
            EnableModelValidation="True">
             <EditItemTemplate>
                 Gallery_Id:
                 <asp:Label ID="Gallery_IdLabel2" runat="server" 
                     Text='<%# Eval("Gallery_Id") %>' />
                 <br />
                 GCT_Id:
                 <asp:TextBox ID="GCT_IdTextBox0" runat="server" Text='<%# Bind("GCT_Id") %>' />
                 <br />
                 GC_Id:
                 <asp:TextBox ID="GC_IdTextBox0" runat="server" Text='<%# Bind("GC_Id") %>' />
                 <br />
                 GC_Name:
                 <asp:TextBox ID="GC_NameTextBox0" runat="server" 
                     Text='<%# Bind("GC_Name") %>' />
                 <br />
                 Gallery_Name:
                 <asp:TextBox ID="Gallery_NameTextBox0" runat="server" 
                     Text='<%# Bind("Gallery_Name") %>' />
                 <br />
                 Gallery_Description:
                 <asp:TextBox ID="Gallery_DescriptionTextBox0" runat="server" 
                     Text='<%# Bind("Gallery_Description") %>' />
                 <br />
                 Gallery_Size:
                 <asp:TextBox ID="Gallery_SizeTextBox0" runat="server" 
                     Text='<%# Bind("Gallery_Size") %>' />
                 <br />
                 Gallery_Path:
                 <asp:TextBox ID="Gallery_PathTextBox0" runat="server" 
                     Text='<%# Bind("Gallery_Path") %>' />
                 <br />
                 FileName:
                 <asp:TextBox ID="FileNameTextBox0" runat="server" 
                     Text='<%# Bind("FileName") %>' />
                 <br />
                 Gallery_CreatedBy:
                 <asp:TextBox ID="Gallery_CreatedByTextBox0" runat="server" 
                     Text='<%# Bind("Gallery_CreatedBy") %>' />
                 <br />
                 Gallery_CreatedDate:
                 <asp:TextBox ID="Gallery_CreatedDateTextBox0" runat="server" 
                     Text='<%# Bind("Gallery_CreatedDate") %>' />
                 <br />
                 Gallery_isPublish:
                 <asp:CheckBox ID="Gallery_isPublishCheckBox2" runat="server" 
                     Checked='<%# Bind("Gallery_isPublish") %>' />
                 <br />
                 <asp:LinkButton ID="UpdateButton0" runat="server" CausesValidation="True" 
                     CommandName="Update" Text="Update" />
                 &nbsp;<asp:LinkButton ID="UpdateCancelButton0" runat="server" 
                     CausesValidation="False" CommandName="Cancel" Text="Cancel" />
             </EditItemTemplate>
             <InsertItemTemplate>
                 GCT_Id:
                 <asp:TextBox ID="GCT_IdTextBox1" runat="server" Text='<%# Bind("GCT_Id") %>' />
                 <br />
                 GC_Id:
                 <asp:TextBox ID="GC_IdTextBox1" runat="server" Text='<%# Bind("GC_Id") %>' />
                 <br />
                 GC_Name:
                 <asp:TextBox ID="GC_NameTextBox1" runat="server" 
                     Text='<%# Bind("GC_Name") %>' />
                 <br />
                 Gallery_Name:
                 <asp:TextBox ID="Gallery_NameTextBox1" runat="server" 
                     Text='<%# Bind("Gallery_Name") %>' />
                 <br />
                 Gallery_Description:
                 <asp:TextBox ID="Gallery_DescriptionTextBox1" runat="server" 
                     Text='<%# Bind("Gallery_Description") %>' />
                 <br />
                 Gallery_Size:
                 <asp:TextBox ID="Gallery_SizeTextBox1" runat="server" 
                     Text='<%# Bind("Gallery_Size") %>' />
                 <br />
                 Gallery_Path:
                 <asp:TextBox ID="Gallery_PathTextBox1" runat="server" 
                     Text='<%# Bind("Gallery_Path") %>' />
                 <br />
                 FileName:
                 <asp:TextBox ID="FileNameTextBox1" runat="server" 
                     Text='<%# Bind("FileName") %>' />
                 <br />
                 Gallery_CreatedBy:
                 <asp:TextBox ID="Gallery_CreatedByTextBox1" runat="server" 
                     Text='<%# Bind("Gallery_CreatedBy") %>' />
                 <br />
                 Gallery_CreatedDate:
                 <asp:TextBox ID="Gallery_CreatedDateTextBox1" runat="server" 
                     Text='<%# Bind("Gallery_CreatedDate") %>' />
                 <br />
                 Gallery_isPublish:
                 <asp:CheckBox ID="Gallery_isPublishCheckBox3" runat="server" 
                     Checked='<%# Bind("Gallery_isPublish") %>' />
                 <br />
                 <asp:LinkButton ID="InsertButton0" runat="server" CausesValidation="True" 
                     CommandName="Insert" Text="Insert" />
                 &nbsp;<asp:LinkButton ID="InsertCancelButton0" runat="server" 
                     CausesValidation="False" CommandName="Cancel" Text="Cancel" />
             </InsertItemTemplate>
             <ItemTemplate>
                 <table cellpadding="0" cellspacing="0" height="15px" style="background-image: url(images/graph_bg.jpg);" width="191">
                     <tr>
                         <td height="15px" style="background-image: url(images/graph_usage.jpg);" 
                             width='<%# Eval("UseSpace") / Eval("LimitSpace") * 100 %>%'>
                         </td>
                         <td>&nbsp;</td>
                     </tr>
                 </table>
                 <asp:Label ID="Label3" runat="server" 
                     Text='<%# Eval("LimitSpace", "{0:F}") - Eval("UseSpace", "{0:F}") %>'></asp:Label>
                 pages free of
                 <asp:Label ID="Label4" runat="server" Text='<%# Eval("LimitSpace") %>'></asp:Label>
                 pages
             </ItemTemplate>
        </asp:FormView>
        <asp:SqlDataSource ID="SqlDataSourceGraph0" runat="server" 
            ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" 
            SelectCommand="SELECT COUNT(Content_Id) AS UseSpace, (SELECT Webcon_PageLimit FROM TBL_WEBCONFIG AS TBL_WEBCONFIG_1 WHERE (Webcon_Enabled = 'Y')) AS LimitSpace FROM TBL_CONTENT">
        </asp:SqlDataSource>
        <br />
        <br />

        <asp:GridView ID="GridView1" runat="server" AllowPaging="True" 
            AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="Content_Id" 
            DataSourceID="SqlDataSource2"
            CssClass="table table-bordered" PagerStyle-CssClass="pgr" 
            AlternatingRowStyle-CssClass="alt" PageSize="20" 
            EnableModelValidation="True">
            <AlternatingRowStyle CssClass="alt" />
            <Columns>
                <asp:BoundField DataField="Content_Id" HeaderText="Content_Id" 
                    InsertVisible="False" ReadOnly="True" SortExpression="Content_Id" 
                    Visible="False" />
                <asp:BoundField DataField="Content_NameShadow" HeaderText="Unique Name" 
                    SortExpression="Content_NameShadow" />
                <asp:BoundField DataField="Content_TitleShadow" HeaderText="Title" 
                    SortExpression="Content_TitleShadow" />
                <asp:TemplateField HeaderText="Publish" SortExpression="Content_IsPublish">
                    <ItemTemplate>
                        <asp:CheckBox ID="CheckBox5" runat="server" 
                            Checked='<%# Bind("Content_IsPublish") %>' Enabled="False" />
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="TextBox2" runat="server" 
                            Text='<%# Bind("Content_IsPublish") %>'></asp:TextBox>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="Content_ShadowStatus" HeaderText="Status" 
                    SortExpression="Content_ShadowStatus" />
                <asp:CommandField SelectText="Edit" ShowSelectButton="True" ItemStyle-HorizontalAlign="Center" />
                <asp:TemplateField ShowHeader="False" ItemStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" 
                            CommandName="Delete" Text="Delete" OnClientClick="return confirm('Are you sure to delete it?');"></asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>



                <asp:TemplateField ItemStyle-HorizontalAlign="Center" Visible="false">
                    <ItemTemplate>
                        <asp:HyperLink ID="HyperLink1" runat="server" 
                            NavigateUrl='<%# Eval("Content_Id", "../preview.aspx?id={0}") %>' Text="Preview Page" Target="_blank"></asp:HyperLink>
                    </ItemTemplate>
                </asp:TemplateField>



            </Columns>
            <PagerStyle CssClass="pgr" />
        </asp:GridView>
        
        <asp:TextBox ID="txtShadowStatus" runat="server" Visible="False"></asp:TextBox>
        <br />
        <asp:FormView ID="FormView1" runat="server" DataKeyNames="Content_Id" 
            DataSourceID="SqlDataSource1" DefaultMode="Insert" EnableModelValidation="True">
            <EditItemTemplate>
                <asp:LinkButton ID="UpdateCancelButton" runat="server" CausesValidation="False" 
                    CommandName="Cancel" Text="Back To Add New" />
                <table style="width:100%;">
                    <tr>
                        <td class="style1">
                            Unique Name</td>
                        <td>
                            :<asp:TextBox ID="Content_NameTextBox0" runat="server" 
                                Text='<%# Bind("Content_NameShadow") %>' Width="300px" />&nbsp;(Without space)&nbsp;
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                                ControlToValidate="Content_NameTextBox0" ErrorMessage="*" 
                                ValidationGroup="frmEdit"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td class="style1">
                            Title</td>
                        <td>
                            :<asp:TextBox ID="Content_TitleTextBox0" runat="server" 
                                Text='<%# Bind("Content_TitleShadow") %>' Width="300px" />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" 
                                ControlToValidate="Content_TitleTextBox0" ErrorMessage="*" 
                                ValidationGroup="frmEdit"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td class="style1" valign="top">
                            Body</td>
                        <td>
                            :<cc1:Editor ID="Editor1" runat="server" 
                                Content='<%# Bind("Content_BodyShadow") %>' Width="750px" Height="600px" />
                        </td>
                    </tr>
                    <tr style="display:none">
                        <td class="style4">
                            Publish</td>
                        <td class="style5">
                            :<asp:CheckBox ID="CheckBox3" runat="server" 
                                Checked='<%# Bind("Content_IsPublish") %>' />
                        </td>
                    </tr>
                    <tr>
                        <td class="style4">
                            Status</td>
                        <td class="style5">
                            <asp:Label ID="Label1" runat="server" 
                                Text='<%# Eval("Content_ShadowStatus") %>'></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="style1">
                            &nbsp;</td>
                        <td>
                            <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" 
                                CommandName="Update" Text="Save As Draft" ValidationGroup="frmEdit" 
                                onclick="UpdateButton_Click" OnClientClick="return confirm('Are you sure to save as draf?');"/>
                            &nbsp;
                            <asp:LinkButton ID="SubmitButton" runat="server" CausesValidation="True" 
                                CommandName="Update" onclick="SubmitButton_Click" Text="Submit For Preview" 
                                ValidationGroup="frmEdit" OnClientClick="return confirm('Are you sure to submit for preview?');" />
                                <% 
                                    Dim allowedPublish As Boolean = GlobalClass.CheckPagePermission("Approval")

                                    '//check permission for publish
                                    If allowedPublish = True Then

                                        Dim lbl As Label = DirectCast(FormView1.FindControl("Label1"), Label)
                                        Dim ContentStatus As String = lbl.Text

                                        If ContentStatus = "COMPLETE" Then
                                        %>
                                        &nbsp;&nbsp;<asp:LinkButton ID="UnPublishButton" runat="server" 
                                        onclick="UnPublishButton_Click" OnClientClick="return confirm('Are you sure to unpublish this content?');">Unpublish Content</asp:LinkButton>&nbsp;&nbsp;&nbsp;            
                                        <%
                                        Else
                                        %>
                                        &nbsp;&nbsp;<asp:LinkButton ID="PublishButton" runat="server" 
                                        onclick="PublishButton_Click" OnClientClick="return confirm('Are you sure to publish this content?');">Publish Content</asp:LinkButton>&nbsp;&nbsp;&nbsp;
                                        <%    
                                    End If
                                
                                End If
                                %>
                            <br />
                            <br />
                            <asp:CustomValidator ID="CustomValidator1" runat="server" 
                                ControlToValidate="Content_NameTextBox0" 
                                ErrorMessage="Name Already Exist!. Please Use Another Name." 
                                onservervalidate="CustomValidator1_ServerValidate" ValidationGroup="frmEdit"></asp:CustomValidator>
                            </td>
                    </tr>
                </table>
  
            </EditItemTemplate>
            <InsertItemTemplate>
                <table style="width:100%;">
                    <tr>
                        <td class="style6">
                            Unique Name</td>
                        <td>
                            :<asp:TextBox ID="Content_NameTextBox0" runat="server" 
                                Text='<%# Bind("Content_NameShadow") %>' Width="300px" />
                            &nbsp;(Without space)
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                                ControlToValidate="Content_NameTextBox0" ErrorMessage="*" 
                                ValidationGroup="frmInsert"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td class="style2">
                            Title</td>
                        <td class="style3">
                            :<asp:TextBox ID="Content_TitleTextBox0" runat="server" 
                                Text='<%# Bind("Content_TitleShadow") %>' Width="300px" />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                                ControlToValidate="Content_TitleTextBox0" ErrorMessage="*" 
                                ValidationGroup="frmInsert"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td class="style6" valign="top">
                            Body</td>
                        <td>
                            :<cc1:Editor ID="Editor1" runat="server" 
                                Content='<%# Bind("Content_BodyShadow") %>' Width="750px" Height="600px" />
                        </td>
                    </tr>
                    <tr style="display:none">
                        <td class="style4">
                            Publish</td>
                        <td class="style5">
                            :<asp:CheckBox ID="CheckBox2" runat="server" 
                                Checked='<%# Bind("Content_IsPublish") %>' />
                        </td>
                    </tr>
                    <tr>
                        <td class="style6">
                            &nbsp;</td>
                        <td>
                            <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" 
                                CommandName="Insert" Text="Insert" ValidationGroup="frmInsert" />
                            &nbsp;
                            <asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" 
                                CommandName="Cancel" Text="Cancel" />
                            &nbsp;<asp:CustomValidator ID="CustomValidator1" runat="server" 
                                ControlToValidate="Content_NameTextBox0" 
                                ErrorMessage="Name Already Exist!. Please Use Another Name." 
                                onservervalidate="CustomValidator1_ServerValidate" 
                                ValidationGroup="frmInsert"></asp:CustomValidator>
                        </td>
                    </tr>
                </table>
            </InsertItemTemplate>
            <ItemTemplate>
                Content_Id:
                <asp:Label ID="Content_IdLabel" runat="server" 
                    Text='<%# Eval("Content_Id") %>' />
                <br />
                Content_Name:
                <asp:Label ID="Content_NameLabel" runat="server" 
                    Text='<%# Bind("Content_Name") %>' />
                <br />
                Content_Title:
                <asp:Label ID="Content_TitleLabel" runat="server" 
                    Text='<%# Bind("Content_Title") %>' />
                <br />
                Content_Body:
                <asp:Label ID="Content_BodyLabel" runat="server" 
                    Text='<%# Bind("Content_Body") %>' />
                <br />
                Content_CreatedBy:
                <asp:Label ID="Content_CreatedByLabel" runat="server" 
                    Text='<%# Bind("Content_CreatedBy") %>' />
                <br />
                Content_CreatedDate:
                <asp:Label ID="Content_CreatedDateLabel" runat="server" 
                    Text='<%# Bind("Content_CreatedDate") %>' />
                <br />
                Content_PublishedBy:
                <asp:Label ID="Content_PublishedByLabel" runat="server" 
                    Text='<%# Bind("Content_PublishedBy") %>' />
                <br />
                Content_PublishedDate:
                <asp:Label ID="Content_PublishedDateLabel" runat="server" 
                    Text='<%# Bind("Content_PublishedDate") %>' />
                <br />
                Content_ModifiedBy:
                <asp:Label ID="Content_ModifiedByLabel" runat="server" 
                    Text='<%# Bind("Content_ModifiedBy") %>' />
                <br />
                Content_ModifiedDate:
                <asp:Label ID="Content_ModifiedDateLabel" runat="server" 
                    Text='<%# Bind("Content_ModifiedDate") %>' />
                <br />
                Content_IsNews:
                <asp:Label ID="Content_IsNewsLabel" runat="server" 
                    Text='<%# Bind("Content_IsNews") %>' />
                <br />
            </ItemTemplate>
        </asp:FormView>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
            ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" 
            InsertCommand="INSERT INTO TBL_CONTENT(Content_NameShadow, Content_TitleShadow, Content_BodyShadow, Content_IsPublish, Content_ShadowBy, Content_ShadowDate, Content_ShadowStatus) VALUES (@Content_NameShadow, @Content_TitleShadow, @Content_BodyShadow, 0, @Content_ShadowBy, GETDATE(), 'DRAFT')" 
            
            SelectCommand="SELECT Content_Id, Content_Name, Content_Title, Content_Body, Content_CreatedBy, Content_CreatedDate, Content_PublishedBy, Content_PublishedDate, Content_ModifiedBy, Content_ModifiedDate, Content_IsNews, Content_IsPublish, Content_NameShadow, Content_TitleShadow, Content_IsNewsShadow, Content_ShadowBy, Content_ShadowDate, Content_ShadowStatus, Content_BodyShadow FROM TBL_CONTENT WHERE (Content_Id = @Content_Id) ORDER BY Content_Id" 
            
            
            
            UpdateCommand="UPDATE TBL_CONTENT SET Content_NameShadow = @Content_NameShadow, Content_TitleShadow = @Content_TitleShadow, Content_BodyShadow = @Content_BodyShadow, Content_ShadowBy = @Content_ShadowBy, Content_ShadowDate = GETDATE(), Content_ShadowStatus = @Content_ShadowStatus WHERE (Content_Id = @Content_Id)">
            <InsertParameters>
                <asp:SessionParameter Name="Content_ShadowBy" SessionField="SessionUsersId" />
                <asp:Parameter Name="Content_NameShadow" />
                <asp:Parameter Name="Content_TitleShadow" />
                <asp:Parameter Name="Content_BodyShadow" />
            </InsertParameters>
            <SelectParameters>
                <asp:ControlParameter ControlID="GridView1" Name="Content_Id" 
                    PropertyName="SelectedValue" />
            </SelectParameters>
            <UpdateParameters>
                <asp:ControlParameter ControlID="GridView1" Name="Content_Id" 
                    PropertyName="SelectedValue" />
                <asp:SessionParameter Name="Content_ShadowBy" 
                    SessionField="SessionUsersId" />
                <asp:ControlParameter ControlID="txtShadowStatus" DefaultValue="DRAFT" 
                    Name="Content_ShadowStatus" PropertyName="Text" />
                <asp:Parameter Name="Content_NameShadow" />
                <asp:Parameter Name="Content_TitleShadow" />
                <asp:Parameter Name="Content_BodyShadow" />
            </UpdateParameters>
        </asp:SqlDataSource>
        <br />
        <asp:SqlDataSource ID="SqlDataSource2" runat="server" 
            ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" 
            DeleteCommand="DELETE FROM TBL_CONTENT WHERE Content_Id = @Content_Id " 
            SelectCommand="SELECT * FROM [TBL_CONTENT]">
            <DeleteParameters>
                <asp:Parameter Name="Content_Id" />
            </DeleteParameters>
        </asp:SqlDataSource>
        <br />


                        </div>
            </div>


        </div>
    </section>





        <script type="text/javascript">

    
        </script>


</asp:Content>

