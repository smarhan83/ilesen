<%@ Page Title="" Language="VB" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="distribution_password.aspx.vb" Inherits="administration_distribution_password" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <section class="content-header">
        <div class="container-fluid">



            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0 text-dark">Password Distribution</h1>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <%--<li class="breadcrumb-item"><a href="#">Administration</a></li>
                        <li class="breadcrumb-item active">Password Distribution</li>--%>
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

                        Password : 
                        <asp:DropDownList ID="DropDownList1" runat="server" AutoPostBack="True">
                            <asp:ListItem Value="N">NOT NULL</asp:ListItem>
                            <asp:ListItem>NULL</asp:ListItem>
                        </asp:DropDownList>
                        <br />
                        <br />
                            <div class="form-check">
                        <asp:CheckBox ID="chkSelectAll" class="form-check-input" runat="server" AutoPostBack="True" /> <asp:Label ID="Label1" runat="server" CssClass="form-check-label" Text="Select All"></asp:Label>
                                </div>
                        <br />

                        <asp:GridView ID="GridView1" runat="server" AllowSorting="True" CssClass="table table-bordered" AutoGenerateColumns="False" DataKeyNames="Users_Id" DataSourceID="SqlDataSource1" EnableModelValidation="True" PagerStyle-CssClass="pgr" AlternatingRowStyle-CssClass="alt">
                            <Columns>
                                <asp:BoundField DataField="Users_Id" HeaderText="ID" SortExpression="Users_Id" />
                                <asp:BoundField DataField="Users_Name" HeaderText="Username" SortExpression="Users_Name" />
                                <asp:BoundField DataField="Users_Fullname" HeaderText="Fullname" SortExpression="Users_Fullname" />
                                <asp:BoundField DataField="Users_Email" HeaderText="Email" SortExpression="Users_Email" />
                                <asp:BoundField DataField="Users_Enabled" HeaderText="Enabled" SortExpression="Users_Enabled" />
                                <asp:BoundField DataField="Users_Register" HeaderText="Registered" SortExpression="Users_Register" />
                                    <asp:TemplateField>
                                        <EditItemTemplate>
                                            <asp:CheckBox ID="CheckBox1" runat="server" />
                                        </EditItemTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="CheckBox1" runat="server" AutoPostBack="true" OnCheckedChanged="CheckBox1_CheckedChanged"  />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                            </Columns>
                        </asp:GridView>

                        <asp:Button ID="Button1" runat="server" CssClass="btn btn-default" Style="background-color: #024b4d; color: #fff; border-color: #024b4d" Text="Set Random Password" />

                        <asp:Button ID="Button2" runat="server" CssClass="btn btn-primary"  Text="Resend Password (Email)" />

                        <br />
                        <asp:Label ID="lblDistPassword" runat="server" ForeColor="Red"></asp:Label>

                        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" SelectCommand="SELECT Users_Id, Users_Name, Users_Fullname, Users_Email, Users_Enabled, Users_Register, Users_Password FROM TBL_USERS WHERE (Users_Register = '1') AND (Users_Enabled = '1') AND Users_Password IS NULL"> </asp:SqlDataSource>
                
                  </div>

                
            </div>
        </div>
    </section>
</asp:Content>
