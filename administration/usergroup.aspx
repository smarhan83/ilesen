<%@ Page Language="VB" AutoEventWireup="false" CodeFile="usergroup.aspx.vb" Inherits="html_administration_usergroup" MasterPageFile="~/MasterMenu.master" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadContent" runat="Server">

    <style>
        .cssDisplayNone{
            display:none;
        }
    </style>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="Server">
         



    <section class="content-header">
        <div class="container-fluid">



            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0 text-dark">Peranan Pengguna<%--User Management--%></h1>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <%--<li class="breadcrumb-item"><a href="#">Administration</a></li>
                        <li class="breadcrumb-item active">User Management</li>--%>
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

            <div class="card">
                <div class="card-body" style="overflow-x: auto;">

                     <table style="width:100%;" class="table table-bordered">
                    <tr>
                        <td class="style4">
                            <b>Senarai Peranan </b><%--(<asp:HyperLink ID="HyperLink1" runat="server" 
                                NavigateUrl="groupname.aspx" Target="_blank">New/Edit Group</asp:HyperLink>)--%></td>
                        <td class="style13">
                            <b>Senarai Pengguna (Peranan)</b></td>
                        <td class="style13">
                            &nbsp;</td>
                        <td>
                            <b>Senarai Pengguna </b><%--(<asp:HyperLink ID="HyperLink2" runat="server" 
                                NavigateUrl="adduser.aspx" Target="_blank">New/Edit User</asp:HyperLink>)--%></td>
                    </tr>
                    <tr>
                        <td class="style8" valign="top">
                            <asp:ListBox ID="ListBox1" runat="server" AutoPostBack="True" CssClass="form-control" 
                                DataSourceID="SqlDataSource1" DataTextField="UGN_Name" DataValueField="UGN_Id" 
                                Height="244px" Width="242px"></asp:ListBox>
                            <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" 
                                SelectCommand=""></asp:SqlDataSource>
                        </td>
                        <td class="style9" valign="top">
                            <asp:ListBox ID="ListBox2" runat="server" AutoPostBack="True" CssClass="form-control" 
                                DataSourceID="SqlDataSource2" DataTextField="Users_Fullname" 
                                DataValueField="UGL_Id" Height="244px" SelectionMode="Multiple" Width="242px">
                            </asp:ListBox>
                            <asp:SqlDataSource ID="SqlDataSource2" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" SelectCommand="SELECT TBL_USERS.Users_Fullname,TBL_USER_GROUPLIST.UGL_UGN_Id,TBL_USER_GROUPLIST.UGL_Users_Id,TBL_USER_GROUPLIST.UGL_Id 
FROM TBL_USER_GROUPLIST  
INNER JOIN TBL_USERS ON TBL_USER_GROUPLIST.UGL_Users_Id = TBL_USERS.Users_Id
WHERE TBL_USER_GROUPLIST.UGL_UGN_Id = @UGL_Id">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="ListBox1" DefaultValue="" Name="UGL_Id" 
                                        PropertyName="SelectedValue" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </td>
                        <td align="center" class="style7" valign="top">
                            <br />
                            <asp:LinkButton ID="btnAddList" runat="server" CssClass="btn btn-primary" width="150px" Text="&lt;&lt; Masukkan" />
                            <br />
                            <br />
                            <asp:LinkButton ID="btnRemoveList" runat="server" CssClass="btn btn-primary btn-warning" width="150px" Text="Padam &gt;&gt;" />
                        </td>
                        <td valign="top">
                            <asp:ListBox ID="ListBox3" runat="server" AutoPostBack="True" CssClass="form-control" 
                                DataSourceID="SqlDataSource4" DataTextField="Users_Fullname" 
                                DataValueField="Users_Id" Height="244px" SelectionMode="Multiple" 
                                style="margin-left: 0px" Width="242px"></asp:ListBox>
                            <asp:SqlDataSource ID="SqlDataSource4" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" SelectCommand="">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="ListBox1" Name="UGN_Id" 
                                        PropertyName="SelectedValue" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </td>
                    </tr>
                    <tr>
                        <td class="style2" valign="top" colspan="3">
                            <strong>Senarai Akses</strong> <%--<span class="style16">(<asp:HyperLink ID="HyperLink3" 
                                runat="server" NavigateUrl="ugm2.aspx" Target="_blank">New/Edit Module</asp:HyperLink>
                            </span>)--%></td>
                        <td class="style13">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td class="style1" colspan="4" height="250" valign="top">
                            <table width="100%" border="0">
                            <tr><td width="80%">
                            <asp:DropDownList ID="ddlSystemId" runat="server"
                            DataSourceID="sdsSystem" DataTextField="system_Name"
                            DataValueField="system_Id"
                            CssClass="form-control" AutoPostBack="True">                          
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="sdsSystem" runat="server"
                            ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" SelectCommand=
                            "SELECT *  FROM TBL_SYSTEM "></asp:SqlDataSource>
                            </td><td width="20%" style="text-align:center;">
                            <asp:LinkButton ID="btnUpdatePerm" runat="server" Text="Kemaskini" OnClientClick="return confirm('Are you sure to update this record?');" Visible="False" CssClass="btn btn-primary"></asp:LinkButton>
                            </td></tr>
                            </table>
                            <asp:GridView ID="GridView1" runat="server" 
                                AutoGenerateColumns="False" DataKeyNames="UGR_Id,UGM_Id" 
                                DataSourceID="SqlDataSource3" 
                                style="text-align: center" Width="100%"
                                CssClass="mGrid" PagerStyle-CssClass="pgr" 
                                AlternatingRowStyle-CssClass="alt" PageSize="20" >
<AlternatingRowStyle CssClass="alt"></AlternatingRowStyle>
                                <Columns>
                                    <asp:BoundField DataField="UGR_Id" HeaderText="UGR_Id" InsertVisible="False" 
                                        ReadOnly="True" SortExpression="UGR_Id"  >
                                    <HeaderStyle CssClass="cssDisplayNone" />
                                    <ItemStyle CssClass="cssDisplayNone" />
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderText="Modul" SortExpression="UGM_Name">
                                        <EditItemTemplate>
                                            <asp:Label ID="Label1" runat="server" Text='<%# Eval("UGM_Name") %>' Font-Bold='<%# iif(Eval("UGM_Level").ToString = "1", True, False) %>'></asp:Label>
                                        </EditItemTemplate>
                                        <ItemTemplate>
                                            <asp:Label ID="Label4" runat="server" Text='<%# Bind("UGM_Name") %>' Font-Bold='<%# iif(Eval("UGM_Level").ToString = "1", True, False) %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Left" />
                                        <ItemStyle HorizontalAlign="Left" />
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="UGR_UGN_Id" HeaderText="UGR_UGN_Id" 
                                        SortExpression="UGR_UGN_Id" Visible="False" />
                                    <asp:BoundField DataField="UGM_Id" HeaderText="UGM_Id" InsertVisible="False" 
                                        ReadOnly="True" SortExpression="UGM_Id" Visible="False" />
                                    <asp:TemplateField HeaderText="Read" SortExpression="UGR_Read">
                                        <EditItemTemplate>
                                            
                                        </EditItemTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="cbRead" runat="server" Checked='<%# Bind("UGR_Read") %>' />
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Write" SortExpression="UGR_Write">
                                        <EditItemTemplate>
                                            
                                        </EditItemTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="cbWrite" runat="server" Checked='<%# Bind("UGR_Write") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Approval" SortExpression="UGR_Approval">
                                        <EditItemTemplate>
                                            
                                        </EditItemTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="cbApproval" runat="server" Checked='<%# Bind("UGR_Approval") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ShowHeader="True" Visible="False">
                                        <EditItemTemplate>
                                            <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="True" CommandName="Update" Text="Update"></asp:LinkButton>
                                            &nbsp;<asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" Visible="False"></asp:LinkButton>
                                        </EditItemTemplate>
                                        <HeaderTemplate>
                                            <asp:LinkButton ID="LinkButton1" runat="server" Text="Update" Visible="False"></asp:LinkButton>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Edit" Text="Edit" Visible="False"></asp:LinkButton>
                                        </ItemTemplate>
                                        <ControlStyle CssClass="btn btn-warning btn-sm" />
                                    </asp:TemplateField>
                                </Columns>

<PagerStyle CssClass="pgr"></PagerStyle>
                            </asp:GridView>
                            <asp:SqlDataSource ID="SqlDataSource3" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" SelectCommand="SELECT  
case when UGM_Level = 1 then UGM_Name when UGM_Level = 2 then CHAR(160)+CHAR(160)+CHAR(160)+CHAR(160)+UGM_Name end  as UGM_Name,
TBL_USER_GROUPROLE.UGR_Id,
TBL_USER_GROUPROLE.UGR_UGN_Id,
TBL_USER_GROUPMODULE.UGM_Id,
(CASE
  WHEN TBL_USER_GROUPROLE.UGR_Write = '1' THEN 
  '[ / ]' 
  ELSE
  ''
END) AS UGR_Write_Lbl,
(CASE
  WHEN TBL_USER_GROUPROLE.UGR_Read = '1' THEN 
  '[ / ]' 
  ELSE
  ''
END) AS UGR_Read_Lbl,
(CASE
  WHEN TBL_USER_GROUPROLE.UGR_Approval = '1' THEN 
  '[ / ]' 
  ELSE
  ''
END) AS UGR_Approval_Lbl,
TBL_USER_GROUPROLE.UGR_Read,
TBL_USER_GROUPROLE.UGR_Write,
TBL_USER_GROUPROLE.UGR_Approval,UGM_Level
FROM TBL_USER_GROUPROLE
INNER JOIN TBL_USER_GROUPMODULE ON TBL_USER_GROUPROLE.UGR_UGM_Id = TBL_USER_GROUPMODULE.UGM_Id
WHERE TBL_USER_GROUPROLE.UGR_UGN_Id = @UGN_Id AND TBL_USER_GROUPMODULE.UGM_IsPublish = 1 
                                and TBL_USER_GROUPMODULE.UGM_SystemId = @systemID
                                order by TBL_USER_GROUPMODULE.UGM_SeqNo asc" 
                                UpdateCommand="UPDATE TBL_USER_GROUPROLE SET UGR_Read = @UGR_Read, UGR_Write = @UGR_Write, UGR_Approval = @UGR_Approval WHERE UGR_Id = @UGR_Id">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="ListBox1" Name="UGN_Id" 
                                        PropertyName="SelectedValue" />
                                    <asp:ControlParameter ControlID="ddlSystemId" Name="systemID" PropertyName="SelectedValue" />
                                </SelectParameters>
                                <UpdateParameters>
                                    <asp:Parameter Name="UGR_Read" />
                                    <asp:Parameter Name="UGR_Write" />
                                    <asp:Parameter Name="UGR_Approval" />
                                    <asp:Parameter Name="UGR_Id" />
                                </UpdateParameters>
                            </asp:SqlDataSource>
                        </td>
                    </tr>
                </table>

                </div>
            </div>
    
        </div>
    </section>
                    
</asp:Content>
