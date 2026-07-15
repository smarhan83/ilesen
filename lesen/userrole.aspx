<%@ Page Language="VB" AutoEventWireup="false" CodeFile="userrole.aspx.vb" Inherits="userrole" MasterPageFile="~/MasterMenu.master" %>

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
                    <h1 class="m-0 text-dark"><div runat="server" id="idWindowTitle"></div></h1>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <%--<li class="breadcrumb-item"><a href="#">Administration</a></li>
                        <li class="breadcrumb-item active">Project Menu</li>--%>
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
                <div class="card-body" >


                        <div class="row" runat="server"  style="text-align:center !important;">
                            <div class="col-md-4">
                                <b>Group List </b><%--(<asp:HyperLink ID="HyperLink1" runat="server" 
                                NavigateUrl="groupname.aspx" Target="_blank">New/Edit Group</asp:HyperLink>
                                <b>)</b>--%>
                                <asp:ListBox ID="ListBox1" runat="server" AutoPostBack="True" CssClass="form-control" 
                                    DataSourceID="SqlDataSource1" DataTextField="UGN_Name" DataValueField="UGN_Id" 
                                    Height="244px" Width="100%"></asp:ListBox>
                                <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                                    ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" 
                                    SelectCommand=""></asp:SqlDataSource>

                            </div>

                            <div class="col-md-4">
                                <b>Assigned Users</b>
                                <asp:ListBox ID="ListBox2" runat="server" AutoPostBack="True" CssClass="form-control" 
                                    DataSourceID="SqlDataSource2" DataTextField="Users_Fullname" 
                                    DataValueField="UGL_Id" Height="244px" SelectionMode="Multiple" Width="100%" BackColor="#5046E5" ForeColor="White">
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
                            </div>


                            <div class="col-md-4">
                                <b>Available User </b><%--(<asp:HyperLink ID="HyperLink2" runat="server" 
                                NavigateUrl="adduser.aspx" Target="_blank">New/Edit User</asp:HyperLink>
                                <b>)</b>--%>
                                <asp:ListBox ID="ListBox3" runat="server" AutoPostBack="True" CssClass="form-control" 
                                    DataSourceID="SqlDataSource4" DataTextField="Users_Fullname" 
                                    DataValueField="Users_Id" Height="244px" SelectionMode="Multiple" 
                                    style="margin-left: 0px" Width="100%"></asp:ListBox>
                                <asp:SqlDataSource ID="SqlDataSource4" runat="server" 
                                    ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" SelectCommand="">
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="ListBox1" Name="UGN_Id" 
                                            PropertyName="SelectedValue" />
                                    </SelectParameters>
                                </asp:SqlDataSource>

                            </div>
                        </div>

                        <div class="row" runat="server">
                            <hr />
                            <div class="col-md-4" style="text-align:center !important;">
                            </div>
                            <div class="col-md-4" style="text-align:center !important;">
                 
                                <asp:LinkButton ID="btnRemoveList" runat="server" CssClass="btn btn-primary btn-warning" 
                                OnClientClick="return confirm('Confirm to remove this assigned user?');" Visible="false"
                                Text="Remove Assigned User"  ForeColor="White" />
                            
                            </div>

                            <div class="col-md-4" style="text-align:center !important;">

                                <asp:LinkButton ID="btnAddList" runat="server" CssClass="btn btn-primary" 
                                OnClientClick="return confirm('Confirm to add this available user?');" Visible="false"
                                Text="Add Available User" ForeColor="White" />
                            
                            </div>
                        </div>

                    



                </div>
            </div>
    
        </div>
    </section>
                    
</asp:Content>
