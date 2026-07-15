<%@ Page Title="" Language="VB" MasterPageFile="~/administration/Site.master" AutoEventWireup="false" CodeFile="adminmenu.aspx.vb" Inherits="administration_adminmenu" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">

    <style type="text/css">


        .style1
        {
            width: 153px;
        }

    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">

    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <br />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="txtWindowTitle">
                Add/Edit Admin Menu</div>
            <br/>
            <asp:FormView ID="FormView1" runat="server" DataKeyNames="UGM_Id" 
                DataSourceID="SqlDataSource2" DefaultMode="Insert" EnableModelValidation="True">
                <EditItemTemplate>
                    <table style="width:100%;">
                        <tr>
                            <td class="style1">
                                Parent Menu</td>
                            <td>
                                :<asp:DropDownList ID="DropDownList1" runat="server" 
                                    DataSourceID="SqlDataSource1" DataTextField="UGM_Name" 
                                    DataValueField="UGM_Id" 
                                    SelectedValue='<%# Bind("UGM_ParentId") %>'>
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlDataSource1" runat="server"
                                    ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                                    SelectCommand="SELECT UGM_Id, UGM_ParentId, UGM_name, UGM_ContentId, UGM_Filename, UGM_SeqNo, UGM_level FROM (SELECT 0 AS UGM_Id, 0 AS UGM_ParentId, 'None' AS UGM_name, 0 AS UGM_ContentId, '' AS UGM_Filename, 10 AS UGM_SeqNo, 1 AS UGM_level UNION ALL SELECT UGM_Id, UGM_ParentId, (CASE WHEN TBL_USER_GROUPMODULE.UGM_Level = 1 THEN UGM_name WHEN TBL_USER_GROUPMODULE.UGM_Level = 2 THEN '- ' + UGM_name WHEN TBL_USER_GROUPMODULE.UGM_Level = 3 THEN '-- ' + UGM_name WHEN TBL_USER_GROUPMODULE.UGM_Level = 4 THEN '--- ' + UGM_name WHEN TBL_USER_GROUPMODULE.UGM_Level = 5 THEN '---- ' + UGM_name WHEN TBL_USER_GROUPMODULE.UGM_Level = 6 THEN '----- ' + UGM_name WHEN TBL_USER_GROUPMODULE.UGM_Level = 7 THEN '------ ' + UGM_name WHEN TBL_USER_GROUPMODULE.UGM_Level = 8 THEN '------- ' + UGM_name WHEN TBL_USER_GROUPMODULE.UGM_Level = 9 THEN '-------- ' + UGM_name WHEN TBL_USER_GROUPMODULE.UGM_Level = 10 THEN '--------- ' + UGM_name ELSE '' END) AS UGM_name, UGM_ContentId, UGM_Filename, UGM_SeqNo, UGM_Level FROM TBL_USER_GROUPMODULE) AS a ORDER BY UGM_SeqNo"></asp:SqlDataSource>
                            </td>
                        </tr>
                        <tr>
                            <td class="style1">
                                Menu Name</td>
                            <td>
                                :<asp:TextBox ID="Menu_NameTextBox" runat="server" 
                                    Text='<%# Bind("UGM_Name") %>' />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" 
                                    ControlToValidate="Menu_NameTextBox" ErrorMessage="*" ValidationGroup="frmEdit"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td class="style1">
                                Level</td>
                            <td>
                                :<asp:DropDownList ID="DropDownList6" runat="server" 
                                    SelectedValue='<%# Bind("UGM_Level") %>'>
                                    <asp:ListItem>1</asp:ListItem>
                                    <asp:ListItem>2</asp:ListItem>
                                    <asp:ListItem>3</asp:ListItem>
                                    <asp:ListItem>4</asp:ListItem>
                                    <asp:ListItem>5</asp:ListItem>
                                    <asp:ListItem>6</asp:ListItem>
                                    <asp:ListItem>7</asp:ListItem>
                                    <asp:ListItem>8</asp:ListItem>
                                    <asp:ListItem>9</asp:ListItem>
                                    <asp:ListItem>10</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td class="style1">
                                Content Menu</td>
                            <td>
                                :<asp:DropDownList ID="DropDownList4" runat="server" 
                                    DataSourceID="SqlDataSource2" DataTextField="Content_Name" 
                                    DataValueField="Content_Id" SelectedValue='<%# Bind("UGM_ContentId") %>'>
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlDataSource2" runat="server" 
                                    ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" SelectCommand="SELECT *  FROM 
(SELECT
0 AS Content_Id,'' AS Content_Name,'' AS Content_Title,'' AS Content_Body,
0 AS Content_CreatedBy,'' AS Content_CreatedDate,0 AS Content_PublishedBy,
'' AS Content_PublishedDate,0 AS Content_ModifiedBy,'' AS Content_ModifiedDate,
0 AS Content_IsNews,0 AS Content_IsPublish
UNION ALL
SELECT 
Content_Id,Content_Name,Content_Title,Content_Body,
Content_CreatedBy,Content_CreatedDate,Content_PublishedBy,
Content_PublishedDate,Content_ModifiedBy,Content_ModifiedDate,
Content_IsNews,Content_IsPublish

FROM [TBL_CONTENT] WHERE Content_IsPublish = 1
) a
ORDER BY Content_Name ASC"></asp:SqlDataSource>
                            </td>
                        </tr>
                        <tr>
                            <td class="style1">
                                Menu Filename</td>
                            <td>
                                :<asp:TextBox ID="Menu_FilenameTextBox" runat="server" 
                                    Text='<%# Bind("UGM_Filename") %>' />
                                &nbsp;(Default is pages.aspx)</td>
                        </tr>
                         <tr>
                            <td class="style1">
                                Menu Icon</td>
                            <td>
                                :<asp:TextBox ID="icon" runat="server" Text='<%# Bind("UGM_Menu_Icon") %>'></asp:TextBox>
                                <%--<a href ="http://glyphicons.com/" >Example Icon</a>--%>
                                <asp:HyperLink runat="server" NavigateUrl="http://glyphicons.com/" Target="_blank" Text="Example Icon"></asp:HyperLink>
                                <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" 
                                    ControlToValidate="icon" ErrorMessage="*" ValidationGroup="frmEdit"></asp:RequiredFieldValidator>--%>
                            </td>
                        </tr>
                        <tr>
                            <td class="style1">
                                Seq No</td>
                            <td>
                                :<asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("UGM_SeqNo") %>'></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                                    ControlToValidate="TextBox2" ErrorMessage="*" ValidationGroup="frmEdit"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td class="style1">
                                Is Publish</td>
                            <td>
                                :<asp:CheckBox ID="CheckBox2" runat="server" Checked='<%# Bind("UGM_IsPublish") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td class="style1">&nbsp;</td>
                            <td>
                                <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" CommandName="Update" Text="Update" ValidationGroup="frmEdit" />
                                &nbsp;<asp:LinkButton ID="UpdateCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" />
                            </td>
                        </tr>
                    </table>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <table style="width:100%;">
                        <tr>
                            <td class="style1">
                                Parent Menu</td>
                            <td>
                                :<asp:DropDownList ID="DropDownList2" runat="server" 
                                    DataSourceID="SqlDataSource1" DataTextField="UGM_Name" 
                                    DataValueField="UGM_Id" SelectedValue='<%# Bind("UGM_ParentId") %>' >
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlDataSource1" runat="server"
                                    ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" SelectCommand="SELECT UGM_Id, UGM_ParentId, UGM_name, UGM_ContentId, UGM_Filename, UGM_SeqNo, UGM_level FROM (SELECT 0 AS UGM_Id, 0 AS UGM_ParentId, 'None' AS UGM_name, 0 AS UGM_ContentId, '' AS UGM_Filename, 10 AS UGM_SeqNo, 1 AS UGM_level UNION ALL SELECT UGM_Id, UGM_ParentId, (CASE WHEN TBL_USER_GROUPMODULE.UGM_Level = 1 THEN UGM_name WHEN TBL_USER_GROUPMODULE.UGM_Level = 2 THEN '- ' + UGM_name WHEN TBL_USER_GROUPMODULE.UGM_Level = 3 THEN '-- ' + UGM_name WHEN TBL_USER_GROUPMODULE.UGM_Level = 4 THEN '--- ' + UGM_name WHEN TBL_USER_GROUPMODULE.UGM_Level = 5 THEN '---- ' + UGM_name WHEN TBL_USER_GROUPMODULE.UGM_Level = 6 THEN '----- ' + UGM_name WHEN TBL_USER_GROUPMODULE.UGM_Level = 7 THEN '------ ' + UGM_name WHEN TBL_USER_GROUPMODULE.UGM_Level = 8 THEN '------- ' + UGM_name WHEN TBL_USER_GROUPMODULE.UGM_Level = 9 THEN '-------- ' + UGM_name WHEN TBL_USER_GROUPMODULE.UGM_Level = 10 THEN '--------- ' + UGM_name ELSE '' END) AS UGM_name, UGM_ContentId, UGM_Filename, UGM_SeqNo, UGM_Level FROM TBL_USER_GROUPMODULE) AS a ORDER BY UGM_SeqNo"></asp:SqlDataSource>
                            </td>
                        </tr>
                        <tr>
                            <td class="style1">
                                Menu Name</td>
                            <td>
                                :<asp:TextBox ID="Menu_NameTextBox" runat="server" 
                                     Text='<%# Bind("UGM_Name") %>' />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                                    ControlToValidate="Menu_NameTextBox" ErrorMessage="*" 
                                    ValidationGroup="frmInsert"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td class="style1">
                                Level</td>
                            <td>
                                :<asp:DropDownList ID="DropDownList5" runat="server" 
                                    SelectedIndex='<%# Bind("UGM_Level") %>' 
                                    SelectedValue='<%# Bind("UGM_Level") %>'>
                                    <asp:ListItem Selected="True">1</asp:ListItem>
                                    <asp:ListItem>2</asp:ListItem>
                                    <asp:ListItem>3</asp:ListItem>
                                    <asp:ListItem>4</asp:ListItem>
                                    <asp:ListItem>5</asp:ListItem>
                                    <asp:ListItem>6</asp:ListItem>
                                    <asp:ListItem>7</asp:ListItem>
                                    <asp:ListItem>8</asp:ListItem>
                                    <asp:ListItem>9</asp:ListItem>
                                    <asp:ListItem>10</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td class="style1">
                                Content Menu</td>
                            <td>
                                :<asp:DropDownList ID="DropDownList3" runat="server" 
                                    DataSourceID="SqlDataSource2" DataTextField="Content_Name" 
                                    DataValueField="Content_Id" SelectedValue='<%# Bind("UGM_ContentId") %>'>
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlDataSource2" runat="server" 
                                    ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" SelectCommand="SELECT *  FROM 
(SELECT
0 AS Content_Id,'' AS Content_Name,'' AS Content_Title,'' AS Content_Body,
0 AS Content_CreatedBy,'' AS Content_CreatedDate,0 AS Content_PublishedBy,
'' AS Content_PublishedDate,0 AS Content_ModifiedBy,'' AS Content_ModifiedDate,
0 AS Content_IsNews,0 AS Content_IsPublish
UNION ALL
SELECT 
Content_Id,Content_Name,Content_Title,Content_Body,
Content_CreatedBy,Content_CreatedDate,Content_PublishedBy,
Content_PublishedDate,Content_ModifiedBy,Content_ModifiedDate,
Content_IsNews,Content_IsPublish

FROM [TBL_CONTENT] WHERE Content_IsPublish = 1
) a
ORDER BY Content_Name ASC"></asp:SqlDataSource>
                            </td>
                        </tr>
                        <tr>
                            <td class="style1">
                                Menu Filename</td>
                            <td>
                                :<asp:TextBox ID="Menu_FilenameTextBox" runat="server" 
                                    Text='<%# Bind("UGM_Filename") %>' />
                                &nbsp;(Default is pages.aspx)</td>
                        </tr>
                         <tr>
                            <td class="style1">
                                Menu Icon </td>
                            <td>
                                :<asp:TextBox ID="icon" runat="server" Text='<%# Bind("UGM_Menu_Icon") %>' />
                                 <asp:HyperLink runat="server" NavigateUrl="http://glyphicons.com/" Target="_blank" Text="Example Icon"></asp:HyperLink>
                                <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" 
                                    ControlToValidate="icon" ErrorMessage="*" ValidationGroup="frmInsert"></asp:RequiredFieldValidator>--%>
                            </td>
                        </tr>
                        <tr>
                            <td class="style1">
                                Seq No</td>
                            <td>
                                :<asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("UGM_SeqNo") %>' 
                                    ></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                                    ControlToValidate="TextBox1" ErrorMessage="*" ValidationGroup="frmInsert"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td class="style1">
                                Is Publish</td>
                            <td>
                                :<asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("UGM_IsPublish") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td class="style1">&nbsp;</td>
                            <td>
                                <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" Text="Insert" ValidationGroup="frmInsert" />
                                &nbsp;
                                <asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" />
                            </td>
                        </tr>
                    </table>
                </InsertItemTemplate>
                <ItemTemplate>
                    Menu_Id:
                    <asp:Label ID="Menu_IdLabel" runat="server" Text='<%# Eval("UGM_Id") %>' />
                    <br />
                    Menu_ParentId:
                    <asp:Label ID="Menu_ParentIdLabel" runat="server" 
                        Text='<%# Bind("UGM_ParentId") %>' />
                    <br />
                    Menu_Name:
                    <asp:Label ID="Menu_NameLabel" runat="server" Text='<%# Bind("UGM_Name") %>' />
                    <br />
                    Menu_ContentId:
                    <asp:Label ID="Menu_ContentIdLabel" runat="server" 
                        Text='<%# Bind("UGM_ContentId") %>' />
                    <br />
                    Menu_Filename:
                    <asp:Label ID="Menu_FilenameLabel" runat="server" 
                        Text='<%# Bind("UGM_Filename") %>' />
                    <br />
                </ItemTemplate>
                </asp:FormView>

            <asp:SqlDataSource ID="SqlDataSource2" runat="server" 
                ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" InsertCommand="INSERT INTO TBL_USER_GROUPMODULE(UGM_ParentId, UGM_Name, UGM_ContentId, UGM_Filename, UGM_SeqNo, UGM_Level, UGM_IsPublish, UGM_Menu_Icon) VALUES (@UGM_ParentId, @UGM_Name, @UGM_ContentId, @UGM_Filename, @UGM_SeqNo, @UGM_Level, @UGM_IsPublish, @UGM_Menu_Icon)" 
                SelectCommand="SELECT * FROM [TBL_USER_GROUPMODULE] WHERE UGM_Id = @UGM_Id" 
                
                
                UpdateCommand="UPDATE TBL_USER_GROUPMODULE SET UGM_ParentId = @UGM_ParentId, UGM_Name = @UGM_Name, UGM_ContentId = @UGM_ContentId, UGM_Filename = @UGM_Filename, UGM_SeqNo = @UGM_SeqNo, UGM_Level = @UGM_Level, UGM_IsPublish = @UGM_IsPublish, UGM_Menu_Icon = @UGM_Menu_Icon WHERE (UGM_Id = @UGM_Id)">
                <InsertParameters>
                    <asp:Parameter Name="UGM_ParentId" />
                    <asp:Parameter Name="UGM_Name" />
                    <asp:Parameter Name="UGM_ContentId" />
                    <asp:Parameter Name="UGM_Filename" />
                    <asp:Parameter Name="UGM_SeqNo" />
                    <asp:Parameter Name="UGM_Level" />
                    <asp:Parameter Name="UGM_IsPublish" />
                    <asp:Parameter Name="UGM_Menu_Icon" />
                </InsertParameters>
                <SelectParameters>
                    <asp:ControlParameter ControlID="GridView1" Name="UGM_Id" 
                        PropertyName="SelectedValue" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="UGM_ParentId" />
                    <asp:Parameter Name="UGM_Name" />
                    <asp:Parameter Name="UGM_ContentId" />
                    <asp:Parameter Name="UGM_Filename" />
                    <asp:Parameter Name="UGM_SeqNo" />
                    <asp:Parameter Name="UGM_Level" />
                    <asp:Parameter Name="UGM_IsPublish" />
                    <asp:Parameter Name="UGM_Menu_Icon" />
                    <asp:Parameter Name="UGM_Id" />
                </UpdateParameters>
            </asp:SqlDataSource>
            <br />
            <asp:GridView ID="GridView1" runat="server" AllowPaging="True" 
                AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="UGM_Id" 
                DataSourceID="SqlDataSource1"
                CssClass="mGrid" PagerStyle-CssClass="pgr" 
                AlternatingRowStyle-CssClass="alt" PageSize="20" EnableModelValidation="True">
                <AlternatingRowStyle CssClass="alt" />
                <Columns>
                    <asp:BoundField DataField="UGM_Id" HeaderText="UGM_Id" InsertVisible="False" 
                        ReadOnly="True" SortExpression="UGM_Id" Visible="False" />
                    <asp:BoundField DataField="UGM_ParentId" HeaderText="Parent Menu" 
                        SortExpression="UGM_ParentId" Visible="False" />
                    <asp:BoundField DataField="UGM_SeqNo" HeaderText="Seq No" 
                        SortExpression="UGM_SeqNo" />
                    <asp:BoundField DataField="parentMenu" HeaderText="Parent Menu" 
                        SortExpression="parentMenu" />
                    <asp:BoundField DataField="UGM_Name" HeaderText="UGM Name" 
                        SortExpression="UGM_Name" />
                    <asp:BoundField DataField="UGM_ContentId" HeaderText="Content Menu" 
                        SortExpression="UGM_ContentId" Visible="False" />
                    
                    <asp:BoundField DataField="UGM_Filename" HeaderText="Menu Filename" 
                        SortExpression="UGM_Filename" />
                    <asp:CheckBoxField DataField="UGM_IsPublish" HeaderText="Is Publish" SortExpression="UGM_IsPublish" />
                    <asp:CommandField ShowSelectButton="True" SelectText="Edit" />
                    <asp:TemplateField ShowHeader="False">
                        <ItemTemplate>
                            <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" 
                                CommandName="Delete" Text="Delete" OnClientClick="return confirm('Are you sure to delete it?');"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <PagerStyle CssClass="pgr" />
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" 
                SelectCommand="SELECT menu2.UGM_Id, menu2.UGM_ParentId, menu2.UGM_Name, menu2.UGM_ContentId, menu2.UGM_Filename, menu2.UGM_SeqNo, menu2.UGM_Level, menu2.UGM_IsPublish, menu2.UGM_CreatedBy, menu2.UGM_CreatedDate, menu1.UGM_Name AS parentMenu FROM TBL_USER_GROUPMODULE AS menu2 LEFT OUTER JOIN TBL_USER_GROUPMODULE AS menu1 ON menu2.UGM_ParentId = menu1.UGM_Id LEFT OUTER JOIN TBL_CONTENT AS ctn ON menu2.UGM_ContentId = ctn.Content_Id ORDER BY menu2.UGM_SeqNo" 
                
                UpdateCommand="UPDATE TBL_TBL_USER_GROUPMODULE SET UGM_ParentId = @UGM_ParentId, UGM_Name = @UGM_Name, UGM_ContentId = @UGM_ContentId, UGM_Filename = @UGM_Filename WHERE (UGM_Id = @UGM_Id)" 
                DeleteCommand="DELETE FROM TBL_USER_GROUPMODULE WHERE UGM_Id = @UGM_Id">
                <DeleteParameters>
                    <asp:Parameter Name="UGM_Id" />
                </DeleteParameters>
                <UpdateParameters>
                    <asp:Parameter Name="UGM_ParentId" />
                    <asp:Parameter Name="UGM_Name" />
                    <asp:Parameter Name="UGM_ContentId" />
                    <asp:Parameter Name="UGM_Filename" />
                    <asp:Parameter Name="UGM_Id" />
                </UpdateParameters>
            </asp:SqlDataSource>

            <br />

        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>

