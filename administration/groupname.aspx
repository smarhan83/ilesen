<%@ Page Language="VB" AutoEventWireup="false" CodeFile="groupname.aspx.vb" Inherits="html_administration_groupname" MasterPageFile="~/MasterMenu.master" %>


<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadContent" runat="Server">
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="Server">
    <section class="content-header">
        <div class="container-fluid">



            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0 text-dark">User Role</h1>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <%--<li class="breadcrumb-item"><a href="#">Administration</a></li>
                        <li class="breadcrumb-item active">User Role</li>--%>
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
     
            <asp:FormView ID="FormView1" runat="server" DataKeyNames="UGN_Id" DataSourceID="SqlDataSource2" DefaultMode="Insert" Width="100%">
                        <EditItemTemplate>
                            <div class="card card-warning">
                                <div class="card-header">
                                    <h3 class="card-title">Update User Role</h3>

                                    <div class="card-tools">
                                        <button type="button" class="btn btn-tool" data-card-widget="collapse"><i class="fas fa-minus"></i></button>
                                    </div>
                                </div>
                                <!-- /.card-header -->
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Name</label>
                                                <asp:TextBox ID="UGN_NameTextBox" runat="server" Text='<%# Bind("UGN_Name") %>' CssClass="form-control" />
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="UGN_NameTextBox" ErrorMessage="*" ValidationGroup="frmInsert"></asp:RequiredFieldValidator>
                                            </div>
                                            <div class="form-group">
                                                <label>Is Admin</label>
                                                <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("UGN_IsAdmin") %>' />
                                            </div>
                                        </div>
                                        <!-- /.col -->
                                    </div>
                                    <!-- /.row -->
                                </div>
                                <!-- /.card-body -->
                                <div class="card-footer">
                                    <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" CommandName="Update" Text="Update" CssClass="btn btn-warning" />
                                    <asp:LinkButton ID="UpdateCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" CssClass="btn btn-default" />
                                </div>
                            </div>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <div class="card card-primary">
                                <div class="card-header">
                                    <h3 class="card-title">Insert User Role</h3>

                                    <div class="card-tools">
                                        <button type="button" class="btn btn-tool" data-card-widget="collapse"><i class="fas fa-minus"></i></button>
                                    </div>
                                </div>
                                <!-- /.card-header -->
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Name</label>
                                                <asp:TextBox ID="UGN_NameTextBox" runat="server" Text='<%# Bind("UGN_Name") %>' CssClass="form-control" />
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="UGN_NameTextBox" ErrorMessage="*" ValidationGroup="frmInsert"></asp:RequiredFieldValidator>
                                            </div>
                                            <div class="form-group">
                                                <label>Is Admin</label>
                                                <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("UGN_IsAdmin") %>' />
                                            </div>

                                        </div>
                                        <!-- /.col -->
                                    </div>
                                    <!-- /.row -->
                                </div>
                                <!-- /.card-body -->
                                <div class="card-footer">
                                    <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" Text="Insert" ValidationGroup="frmInsert" CssClass="btn btn-primary" />
                                    <asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" CssClass="btn btn-default" />
                                </div>
                            </div>
                        </InsertItemTemplate>
                    </asp:FormView>
            
            <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" InsertCommand="INSERT INTO TBL_USER_GROUPNAME(UGN_Name,UGN_IsAdmin) VALUES (@UGN_Name,@UGN_IsAdmin)" SelectCommand="SELECT UGN_Id, UGN_Name, UGN_IsAdmin FROM TBL_USER_GROUPNAME WHERE (UGN_Id = @UGN_Id)" UpdateCommand="UPDATE TBL_USER_GROUPNAME SET UGN_Name = @UGN_Name, UGN_IsAdmin = @UGN_IsAdmin WHERE (UGN_Id = @UGN_Id)">
                <InsertParameters>
                    <asp:Parameter Name="UGN_Name" />
                    <asp:Parameter Name="UGN_IsAdmin" />
                </InsertParameters>
                <SelectParameters>
                    <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedValue" Name="UGN_Id"></asp:ControlParameter>
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="UGN_Name"></asp:Parameter>
                    <asp:Parameter Name="UGN_IsAdmin"></asp:Parameter>
                    <asp:Parameter Name="UGN_Id"></asp:Parameter>
                </UpdateParameters>
            </asp:SqlDataSource>
                      
            <div class="card">
                <div class="card-body" style="overflow-x: auto;">

                        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="UGN_Id" DataSourceID="SqlDataSource1" CssClass="table table-bordered table-striped" AllowPaging="True" AllowSorting="True">
                            <Columns>
                                <asp:BoundField DataField="UGN_Name" HeaderText="Name" SortExpression="UGN_Name"></asp:BoundField>
                                <asp:BoundField DataField="UGN_IsAdmin" HeaderText="IsAdmin" SortExpression="UGN_IsAdmin"></asp:BoundField>
                                <asp:TemplateField ShowHeader="False">
                                    <ItemTemplate>
                                        <asp:LinkButton runat="server" Text="Select" CommandName="Select" CssClass="btn btn-warning btn-sm" CausesValidation="False" ID="LinkButton1"></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>

                </div>
            </div>
        </div>
    </section>

    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" DeleteCommand="DELETE FROM TBL_USER_GROUPNAME WHERE (UGN_Id = @UGN_Id)" SelectCommand="SELECT UGN_Id, UGN_Name, UGN_IsAdmin FROM TBL_USER_GROUPNAME ORDER BY UGN_Id">
        <DeleteParameters>
            <asp:Parameter Name="UGN_Id" />
        </DeleteParameters>
    </asp:SqlDataSource>
</asp:Content>
