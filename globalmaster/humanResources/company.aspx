<%@ Page Title="" Language="VB" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="company.aspx.vb" Inherits="humanResources_company" %>


<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">
    <section class="content-header">
        <div class="container-fluid">

        

            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0 text-dark">Company</h1>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <%--<li class="breadcrumb-item"><a href="#">Human Resources</a></li>
                        <li class="breadcrumb-item active">Company</li>--%>
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

            <asp:FormView ID="FormView1" runat="server" DefaultMode="Insert" DataKeyNames="id" Width="100%" DataSourceID="SqlDataSourceForm">
                <EditItemTemplate>
                    <div class="card card-warning">
                        <div class="card-header">
                            <h3 class="card-title">Edit Company</h3>

                            <div class="card-tools">
                                <button type="button" class="btn btn-tool" data-card-widget="collapse"><i class="fas fa-minus"></i></button>
                            </div>
                        </div>
                        <!-- /.card-header -->
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Code</label>
                                        <asp:TextBox Text='<%# Bind("code") %>' runat="server" ID="codeTextBox" CssClass="form-control" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorCode" CssClass="text-danger" runat="server" ControlToValidate="codeTextBox" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="updateForm"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="form-group">
                                        <label>Name</label>
                                        <asp:TextBox Text='<%# Bind("name") %>' runat="server" ID="nameTextBox" CssClass="form-control" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" CssClass="text-danger" runat="server" ControlToValidate="nameTextBox" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="updateForm"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="form-group">
                                        <label>Shortname</label>
                                        <asp:TextBox Text='<%# Bind("shortname") %>' runat="server" ID="shortnameTextBox" CssClass="form-control" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" CssClass="text-danger" runat="server" ControlToValidate="shortnameTextBox" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="updateForm"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="form-group">
                                        <label>Status</label>
                                        <asp:RadioButtonList Text='<%# Bind("status") %>' ID="RadioButtonList1" runat="server">
                                            <asp:ListItem Value="True"> Active</asp:ListItem>
                                            <asp:ListItem Value="False"> Inactive</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                    <!-- /.form-group -->

                                </div>
                                <!-- /.col -->
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Speeddial</label>
                                        <asp:TextBox Text='<%# Bind("speeddial") %>' runat="server" ID="speeddialTextBox" CssClass="form-control" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" CssClass="text-danger" runat="server" ControlToValidate="speeddialTextBox" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="updateForm"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="form-group">
                                        <label>Location</label>
                                        <asp:DropDownList Text='<%# Bind("location_id") %>' ID="DropDownListLocation" runat="server" DataSourceID="SqlDataSourceLocation" DataTextField="name" CssClass="form-control" DataValueField="id"></asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorLocation" CssClass="text-danger" runat="server" ControlToValidate="DropDownListLocation" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="updateForm"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="form-group">
                                        <label>Finmthstart</label>
                                        <asp:TextBox Text='<%# Bind("finmthstart") %>' runat="server" ID="finmthstartTextBox" CssClass="form-control" TextMode="Number" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" CssClass="text-danger" runat="server" ControlToValidate="finmthstartTextBox" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="updateForm"></asp:RequiredFieldValidator>
                                    </div>
                                    <!-- /.form-group -->
                                </div>
                                <!-- /.col -->
                            </div>
                            <!-- /.row -->

                        </div>
                        <!-- /.card-body -->
                        <div class="card-footer">
                            <asp:LinkButton runat="server" Text="Update" CommandName="Update" ValidationGroup="updateForm" ID="UpdateButton" CssClass-="btn btn-warning" CausesValidation="True" />&nbsp;<asp:LinkButton runat="server" Text="Cancel" CssClass-="btn btn-default" CommandName="Cancel" ID="UpdateCancelButton" CausesValidation="False" />
                        </div>
                    </div>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <div class="card card-primary">
                        <div class="card-header">
                            <h3 class="card-title">Insert Company</h3>

                            <div class="card-tools">
                                <button type="button" class="btn btn-tool" data-card-widget="collapse"><i class="fas fa-minus"></i></button>
                            </div>
                        </div>
                        <!-- /.card-header -->
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Code</label>
                                        <asp:TextBox Text='<%# Bind("code") %>' placeholder="Code" runat="server" ID="codeTextBox" CssClass="form-control" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorCode" CssClass="text-danger" runat="server" ControlToValidate="codeTextBox" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="insertForm"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="form-group">
                                        <label>Name</label>
                                        <asp:TextBox Text='<%# Bind("name") %>' placeholder="Name" runat="server" ID="nameTextBox" CssClass="form-control" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" CssClass="text-danger" runat="server" ControlToValidate="nameTextBox" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="insertForm"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="form-group">
                                        <label>Shortname</label>
                                        <asp:TextBox Text='<%# Bind("shortname") %>' placeholder="Shortname" runat="server" ID="shortnameTextBox" CssClass="form-control" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" CssClass="text-danger" runat="server" ControlToValidate="shortnameTextBox" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="insertForm"></asp:RequiredFieldValidator>
                                    </div>
                                    <!-- /.form-group -->
                                </div>
                                <!-- /.col -->
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Finmthstart</label>
                                        <asp:TextBox Text='<%# Bind("finmthstart") %>' placeholder="Finmthstart" runat="server" ID="finmthstartTextBox" CssClass="form-control" TextMode="Number" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" CssClass="text-danger" runat="server" ControlToValidate="finmthstartTextBox" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="insertForm"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="form-group">
                                        <label>Speeddial</label>
                                        <asp:TextBox Text='<%# Bind("speeddial") %>' placeholder="Speeddial" runat="server" ID="speeddialTextBox" CssClass="form-control" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" CssClass="text-danger" runat="server" ControlToValidate="speeddialTextBox" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="insertForm"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="form-group">
                                        <label>Location</label>
                                        <asp:DropDownList Text='<%# Bind("location_id") %>' ID="DropDownList1" runat="server" DataSourceID="SqlDataSourceLocation" CssClass="form-control" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorLocation" CssClass="text-danger" runat="server" ControlToValidate="DropDownList1" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="insertForm"></asp:RequiredFieldValidator>

                                    </div>
                                    <!-- /.form-group -->
                                </div>
                                <!-- /.col -->
                            </div>
                            <!-- /.row -->

                        </div>
                        <!-- /.card-body -->
                        <div class="card-footer">
                            <asp:LinkButton runat="server" Text="Insert" CssClass-="btn btn-primary" CommandName="Insert" ID="InsertButton" ValidationGroup="insertForm" CausesValidation="True" />&nbsp;<asp:LinkButton runat="server" Text="Cancel" CssClass-="btn btn-default" CommandName="Cancel" ID="InsertCancelButton" CausesValidation="False" />
                        </div>
                    </div>
                </InsertItemTemplate>
            </asp:FormView>

            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-body">
                            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="id" DataSourceID="SqlDataSourceGrid" CssClass="table table-bordered" AllowSorting="True">
                                <Columns>
                                    <asp:BoundField DataField="code" HeaderText="Code" SortExpression="code"></asp:BoundField>
                                    <asp:BoundField DataField="name" HeaderText="Name" SortExpression="name"></asp:BoundField>
                                    <asp:BoundField DataField="shortname" HeaderText="ShortName" SortExpression="shortname"></asp:BoundField>
                                    <%--<asp:BoundField DataField="finmthstart" HeaderText="Financial Month" SortExpression="finmthstart"></asp:BoundField>--%>
                                    <asp:TemplateField HeaderText="Status" SortExpression="status">
                                        <EditItemTemplate>
                                            <asp:CheckBox runat="server" Checked='<%# Bind("status") %>' ID="CheckBox1"></asp:CheckBox>
                                        </EditItemTemplate>
                                        <ItemTemplate>
                                            <%# IIf(Eval("status").ToString().Equals("True"), "Active", "Inactive") %>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ShowHeader="False" HeaderText="Action">
                                        <ItemTemplate>
                                            <asp:LinkButton runat="server" Text="Edit" CommandName="Select" CausesValidation="False" ID="LinkButton1" CssClass="btn btn-warning btn-sm"></asp:LinkButton>&nbsp<asp:LinkButton runat="server" Text="Delete" CommandName="Delete" CausesValidation="False" ID="LinkButton2" CssClass="btn btn-danger btn-sm" OnClientClick="return confirm('Are you sure to delete?');"></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                            <asp:SqlDataSource runat="server" ID="SqlDataSourceGrid" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' SelectCommand="SELECT TBL_COMPANIES.* FROM TBL_COMPANIES" DeleteCommand="DELETE FROM TBL_COMPANIES WHERE (id = @id)">
                                <DeleteParameters>
                                    <asp:Parameter Name="ID"></asp:Parameter>
                                </DeleteParameters>
                            </asp:SqlDataSource>
                        </div>
                    </div>
                </div>
            </div>



            <asp:SqlDataSource runat="server" ID="SqlDataSourceForm" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' InsertCommand="INSERT INTO TBL_COMPANIES(code, name, shortname, finmthstart, speeddial, location_id, createdAt, status) VALUES (@code, @name, @shortname, @finmthstart, @speeddial, @location_id, GETDATE(), 1)" SelectCommand="SELECT TBL_COMPANIES.* FROM TBL_COMPANIES WHERE id = @id" UpdateCommand="UPDATE TBL_COMPANIES SET code = @code, name = @name, shortname = @shortname, finmthstart = @finmthstart, speeddial = @speeddial, location_id = @location_id, updatedAt = GETDATE(), status = @status WHERE id = @id">
                <InsertParameters>
                    <asp:Parameter Name="code"></asp:Parameter>
                    <asp:Parameter Name="name"></asp:Parameter>
                    <asp:Parameter Name="shortname"></asp:Parameter>
                    <asp:Parameter Name="finmthstart"></asp:Parameter>
                    <asp:Parameter Name="speeddial"></asp:Parameter>
                    <asp:Parameter Name="location_id"></asp:Parameter>
                </InsertParameters>
                <SelectParameters>
                    <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedValue" Name="id"></asp:ControlParameter>
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="code"></asp:Parameter>
                    <asp:Parameter Name="name"></asp:Parameter>
                    <asp:Parameter Name="shortname"></asp:Parameter>
                    <asp:Parameter Name="finmthstart"></asp:Parameter>
                    <asp:Parameter Name="speeddial"></asp:Parameter>
                    <asp:Parameter Name="location_id"></asp:Parameter>
                    <asp:Parameter Name="status"></asp:Parameter>
                    <asp:Parameter Name="id"></asp:Parameter>
                </UpdateParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource runat="server" ID="SqlDataSourceLocation" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' SelectCommand="SELECT NULL AS id, '---Select Location---' AS name UNION ALL SELECT id, name FROM TBL_LOOKUPS WHERE (lookupgrp_id = 8)"></asp:SqlDataSource>
        </div>
    </section>

    <script>
        $(function () {
            //Initialize Select2 Elements
            $('.select2').select2()

        })
    </script>
    <!-- /.content -->
</asp:Content>

