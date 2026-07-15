<%@ Page Title="" Language="VB" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="ocs.aspx.vb" Inherits="humanResources_ocs" %>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">

    <section class="content-header">
        <div class="container-fluid">

            <asp:ScriptManager ID="ScriptManager1" runat="server">
            </asp:ScriptManager>

            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0 text-dark">Estate Master</h1>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <%--<li class="breadcrumb-item"><a href="#">Human Resources</a></li>
                        <li class="breadcrumb-item active">Operating Center</li>--%>
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

            <asp:FormView ID="FormView1" runat="server" DataKeyNames="id" DataSourceID="SqlDataSourceForm" DefaultMode="Insert" Width="100%">
                <EditItemTemplate>
                    <div class="card card-warning">
                        <div class="card-header">
                            <h3 class="card-title">Edit Operating Center</h3>

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
                                    </div>
                                    <!-- /.form-group -->
                                    <div class="form-group">
                                        <label>Name</label>
                                        <asp:TextBox Text='<%# Bind("name") %>' runat="server" ID="nameTextBox" CssClass="form-control" />
                                    </div>
                                    <!-- /.form-group -->
                                    <div class="form-group">
                                        <label>Short Name</label>
                                        <asp:TextBox Text='<%# Bind("shortname") %>' runat="server" ID="shortnameTextBox" CssClass="form-control" />
                                    </div>
                                    <!-- /.form-group -->
                                    <div class="form-group">
                                        <label>Address1</label>
                                        <asp:TextBox Text='<%# Bind("address1") %>' runat="server" ID="address1TextBox" CssClass="form-control" />
                                    </div>
                                    <!-- /.form-group -->
                                    <div class="form-group">
                                        <label>Address2</label>
                                        <asp:TextBox Text='<%# Bind("address2") %>' runat="server" ID="address2TextBox" CssClass="form-control" />
                                    </div>
                                    <!-- /.form-group -->
                                    <div class="form-group">
                                        <label>Address3</label>
                                        <asp:TextBox Text='<%# Bind("address3") %>' runat="server" ID="address3TextBox" CssClass="form-control" />
                                    </div>
                                    <!-- /.form-group -->
                                    <div class="form-group">
                                        <label>Postcode</label>
                                        <asp:TextBox Text='<%# Bind("postcode") %>' runat="server" ID="postcodeTextBox" CssClass="form-control" />
                                    </div>
                                    <!-- /.form-group -->
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
                                        <label>City</label>
                                        <asp:DropDownList Text='<%# Bind("city_id") %>' CssClass="form-control" ID="DropDownList7" runat="server" DataSourceID="SqlDataSourceCity" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                    </div>
                                    <!-- /.form-group -->
                                    <div class="form-group">
                                        <label>State</label>
                                        <asp:DropDownList Text='<%# Bind("state_id") %>' CssClass="form-control" ID="DropDownList8" runat="server" DataSourceID="SqlDataSourceState" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                    </div>
                                    <!-- /.form-group -->
                                    <div class="form-group">
                                        <label>Country</label>
                                        <asp:DropDownList Text='<%# Bind("country_id") %>' CssClass="form-control" ID="DropDownList9" runat="server" DataSourceID="SqlDataSourceCountry" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                    </div>
                                    <!-- /.form-group -->
                                    <div class="form-group">
                                        <label>Category</label>
                                        <asp:DropDownList Text='<%# Bind("occategory_id") %>' CssClass="form-control" ID="DropDownList10" runat="server" DataSourceID="SqlDataSourceOcc" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                    </div>
                                    <!-- /.form-group -->
                                    <div class="form-group">
                                        <label>Region</label>
                                        <asp:DropDownList Text='<%# Bind("region_id") %>' CssClass="form-control" ID="DropDownList11" runat="server" DataSourceID="SqlDataSourceRegion" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                    </div>
                                    <!-- /.form-group -->
                                    <div class="form-group">
                                        <label>Speeddial</label>
                                        <asp:TextBox Text='<%# Bind("speeddial") %>' runat="server" ID="speeddialTextBox" CssClass="form-control" />
                                    </div>
                                    <!-- /.form-group -->
                                    <div class="form-group">
                                        <label>Company</label>
                                        <asp:DropDownList Text='<%# Bind("company_id") %>' CssClass="form-control" ID="DropDownList12" runat="server" DataSourceID="SqlDataSourceCompany" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                    </div>
                                    <!-- /.form-group -->                        
                                </div>
                                <!-- /.col -->
                            </div>
                            <!-- /.row -->

                        </div>
                        <!-- /.card-body -->
                        <div class="card-footer">
                            <asp:LinkButton runat="server" Text="Update" CommandName="Update" ID="UpdateButton" CausesValidation="True" CssClass="btn btn-warning" />&nbsp;<asp:LinkButton runat="server" Text="Cancel" CommandName="Cancel" ID="UpdateCancelButton" CausesValidation="False" CssClass="btn btn-default" />
                        </div>
                    </div>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <div class="card card-primary">
                        <div class="card-header">
                            <h3 class="card-title">Insert Operating Center</h3>

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
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" CssClass="text-danger" runat="server" ControlToValidate="codeTextBox" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="insertForm"></asp:RequiredFieldValidator>
                                    </div>
                                    <!-- /.form-group -->
                                    <div class="form-group">
                                        <label>Name</label>
                                        <asp:TextBox Text='<%# Bind("name") %>' placeholder="Name" runat="server" ID="nameTextBox" CssClass="form-control" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" CssClass="text-danger" runat="server" ControlToValidate="nameTextBox" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="insertForm"></asp:RequiredFieldValidator>
                                    </div>
                                    <!-- /.form-group -->
                                    <div class="form-group">
                                        <label>Short Name</label>
                                        <asp:TextBox Text='<%# Bind("shortname") %>' placeholder="Short Name" runat="server" ID="shortnameTextBox" CssClass="form-control" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" CssClass="text-danger" runat="server" ControlToValidate="shortnameTextBox" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="insertForm"></asp:RequiredFieldValidator>
                                    </div>
                                    <!-- /.form-group -->
                                    <div class="form-group">
                                        <label>Address1</label>
                                        <asp:TextBox Text='<%# Bind("address1") %>' runat="server" placeholder="Address1" ID="address1TextBox" CssClass="form-control" />
                                        <br />
                                    </div>
                                    <!-- /.form-group -->
                                    <div class="form-group">
                                        <label>Address2</label>
                                        <asp:TextBox Text='<%# Bind("address2") %>' runat="server" placeholder="Address2" ID="address2TextBox" CssClass="form-control" />
                                        <br />
                                    </div>
                                    <!-- /.form-group -->
                                    <div class="form-group">
                                        <label>Address3</label>
                                        <asp:TextBox Text='<%# Bind("address3") %>' runat="server" placeholder="Address3" ID="address3TextBox" CssClass="form-control" />
                                    </div>
                                    <!-- /.form-group -->
                                    <div class="form-group">
                                        <label>Postcode</label>
                                        <asp:TextBox Text='<%# Bind("postcode") %>' runat="server" placeholder="Postcode" ID="postcodeTextBox" CssClass="form-control" />
                                    </div>
                                    <!-- /.form-group -->
                                </div>
                                <!-- /.col -->
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>City</label>
                                        <asp:DropDownList Text='<%# Bind("city_id") %>' CssClass="form-control" ID="DropDownList1" runat="server" DataSourceID="SqlDataSourceCity" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator7" CssClass="text-danger" runat="server" ControlToValidate="DropDownList1" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="insertForm"></asp:RequiredFieldValidator>
                                    </div>
                                    <!-- /.form-group -->
                                    <div class="form-group">
                                        <label>State</label>
                                        <asp:DropDownList Text='<%# Bind("state_id") %>' CssClass="form-control" ID="DropDownList2" runat="server" DataSourceID="SqlDataSourceState" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator6" CssClass="text-danger" runat="server" ControlToValidate="DropDownList2" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="insertForm"></asp:RequiredFieldValidator>
                                    </div>
                                    <!-- /.form-group -->
                                    <div class="form-group">
                                        <label>Country</label>
                                        <asp:DropDownList Text='<%# Bind("country_id") %>' CssClass="form-control" ID="DropDownList3" runat="server" DataSourceID="SqlDataSourceCountry" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" CssClass="text-danger" runat="server" ControlToValidate="DropDownList3" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="insertForm"></asp:RequiredFieldValidator>
                                    </div>
                                    <!-- /.form-group -->
                                    <div class="form-group">
                                        <label>Category</label>
                                        <asp:DropDownList Text='<%# Bind("occategory_id") %>' CssClass="form-control" ID="DropDownList4" runat="server" DataSourceID="SqlDataSourceOcc" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator8" CssClass="text-danger" runat="server" ControlToValidate="DropDownList4" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="insertForm"></asp:RequiredFieldValidator>
                                    </div>
                                    <!-- /.form-group -->
                                    <div class="form-group">
                                        <label>Region</label>
                                        <asp:DropDownList Text='<%# Bind("region_id") %>' CssClass="form-control" ID="DropDownList5" runat="server" DataSourceID="SqlDataSourceRegion" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator9" CssClass="text-danger" runat="server" ControlToValidate="DropDownList5" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="insertForm"></asp:RequiredFieldValidator>
                                    </div>
                                    <!-- /.form-group -->
                                    <div class="form-group">
                                        <label>Speeddial</label>
                                        <asp:TextBox Text='<%# Bind("speeddial") %>'  runat="server" placeholder="Speeddial" ID="speeddialTextBox" CssClass="form-control" />
                                    </div>
                                    <!-- /.form-group -->
                                    <div class="form-group">
                                        <label>Company</label>
                                        <asp:DropDownList Text='<%# Bind("company_id") %>' CssClass="form-control" ID="DropDownList6" runat="server" DataSourceID="SqlDataSourceCompany" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" CssClass="text-danger" runat="server" ControlToValidate="DropDownList6" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="insertForm"></asp:RequiredFieldValidator>
                                    </div>
                                    <!-- /.form-group -->
                                </div>
                                <!-- /.col -->
                            </div>
                            <!-- /.row -->

                        </div>
                        <!-- /.card-body -->
                        <div class="card-footer">
                            <asp:LinkButton runat="server" Text="Insert" CommandName="Insert" ValidationGroup="insertForm" ID="InsertButton" CausesValidation="True" CssClass="btn btn-primary" />&nbsp;<asp:LinkButton runat="server" Text="Cancel" CommandName="Cancel" ID="InsertCancelButton" CausesValidation="False" CssClass="btn btn-default" />
                        </div>
                    </div>
                </InsertItemTemplate>
                <ItemTemplate>
                    id:
                    <asp:Label Text='<%# Eval("id") %>' runat="server" ID="idLabel" /><br />
                    code:
                    <asp:Label Text='<%# Bind("code") %>' runat="server" ID="codeLabel" /><br />
                    name:
                    <asp:Label Text='<%# Bind("name") %>' runat="server" ID="nameLabel" /><br />
                    shortname:
                    <asp:Label Text='<%# Bind("shortname") %>' runat="server" ID="shortnameLabel" /><br />
                    address1:
                    <asp:Label Text='<%# Bind("address1") %>' runat="server" ID="address1Label" /><br />
                    address2:
                    <asp:Label Text='<%# Bind("address2") %>' runat="server" ID="address2Label" /><br />
                    address3:
                    <asp:Label Text='<%# Bind("address3") %>' runat="server" ID="address3Label" /><br />
                    postcode:
                    <asp:Label Text='<%# Bind("postcode") %>' runat="server" ID="postcodeLabel" /><br />
                    city_id:
                    <asp:Label Text='<%# Bind("city_id") %>' runat="server" ID="city_idLabel" /><br />
                    state_id:
                    <asp:Label Text='<%# Bind("state_id") %>' runat="server" ID="state_idLabel" /><br />
                    country_id:
                    <asp:Label Text='<%# Bind("country_id") %>' runat="server" ID="country_idLabel" /><br />
                    occategory_id:
                    <asp:Label Text='<%# Bind("occategory_id") %>' runat="server" ID="occategory_idLabel" /><br />
                    region_id:
                    <asp:Label Text='<%# Bind("region_id") %>' runat="server" ID="region_idLabel" /><br />
                    speeddial:
                    <asp:Label Text='<%# Bind("speeddial") %>' runat="server" ID="speeddialLabel" /><br />
                    company_id:
                    <asp:Label Text='<%# Bind("company_id") %>' runat="server" ID="company_idLabel" /><br />
                    emptypeids:
                    <asp:Label Text='<%# Bind("emptypeids") %>' runat="server" ID="emptypeidsLabel" /><br />
                    nextempcode:
                    <asp:Label Text='<%# Bind("nextempcode") %>' runat="server" ID="nextempcodeLabel" /><br />
                    createdAt:
                    <asp:Label Text='<%# Bind("createdAt") %>' runat="server" ID="createdAtLabel" /><br />
                    updatedAt:
                    <asp:Label Text='<%# Bind("updatedAt") %>' runat="server" ID="updatedAtLabel" /><br />
                    status:
                    <asp:CheckBox Checked='<%# Bind("status") %>' runat="server" ID="statusCheckBox" Enabled="false" /><br />
                    <asp:LinkButton runat="server" Text="Edit" CommandName="Edit" ID="EditButton" CausesValidation="False" />&nbsp;<asp:LinkButton runat="server" Text="New" CommandName="New" ID="NewButton" CausesValidation="False" />
                </ItemTemplate>
            </asp:FormView>

            <!-- Default box -->
            <div class="card">
                <div class="card-header">
                    <%--<h3 class="card-title">Operating Center</h3>--%>

                    <div class="card-tools">
                        <button type="button" class="btn btn-tool" data-card-widget="collapse" data-toggle="tooltip" title="Collapse">
                            <i class="fas fa-minus"></i>
                        </button>
                        <%--                    <button type="button" class="btn btn-tool" data-card-widget="remove" data-toggle="tooltip" title="Remove">
                            <i class="fas fa-times"></i>
                        </button>--%>
                    </div>
                </div>
                <div class="card-body p-0">
                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="id" DataSourceID="SqlDataSourceGrid" CssClass="table table-bordered projects">
                        <Columns>
                            <asp:TemplateField HeaderText="Name" SortExpression="name">
                                <EditItemTemplate>
                                    <asp:TextBox runat="server" Text='<%# Bind("name") %>' ID="TextBox1"></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label runat="server" Text='<%# Bind("name") %>' ID="Label1"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Code" SortExpression="code">
                                <EditItemTemplate>
                                    <asp:TextBox runat="server" Text='<%# Bind("code") %>' ID="TextBox2"></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label runat="server" Text='<%# Bind("code") %>' ID="Label2"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Status" SortExpression="status">
                                <EditItemTemplate>
                                    <asp:CheckBox runat="server" Checked='<%# Bind("status") %>' ID="CheckBox1"></asp:CheckBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <%# IIf(Eval("status").ToString().Equals("True"), "Active", "Inactive") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField ShowHeader="False">
                                <ItemTemplate>
                                    <asp:LinkButton runat="server" Text="Edit" CommandName="Select" CausesValidation="False" ID="LinkButton1" CssClass="btn btn-warning btn-sm"></asp:LinkButton>&nbsp;<asp:LinkButton runat="server" Text="Delete" CommandName="Delete" CausesValidation="False" ID="LinkButton2" CssClass="btn btn-danger btn-sm" OnClientClick="return confirm('Are you sure to delete?');"></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>

                        </Columns>
                    </asp:GridView>
                    <asp:SqlDataSource runat="server" ID="SqlDataSourceGrid" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' SelectCommand="SELECT TBL_OCS.* FROM TBL_OCS" DeleteCommand="DELETE FROM TBL_OCS WHERE id = @id">
                        <DeleteParameters>
                            <asp:Parameter Name="id"></asp:Parameter>
                        </DeleteParameters>
                    </asp:SqlDataSource>
                </div>
            </div>

        

            <asp:SqlDataSource runat="server" ID="SqlDataSourceForm" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' InsertCommand="INSERT INTO TBL_OCS(code, name, shortname, address1, address2, address3, postcode, city_id, state_id, country_id, occategory_id, region_id, speeddial, company_id, createdAt, status) VALUES (@code, @name, @shortname, @address1, @address2, @address3, @postcode, @city_id, @state_id, @country_id, @occategory_id, @region_id, @speeddial, @company_id, @createdAt, @status)" SelectCommand="SELECT TBL_OCS.* FROM TBL_OCS WHERE id = @id" UpdateCommand="UPDATE TBL_OCS SET code = @code, name = @name, shortname = @shortname, address1 = @address1, address2 = @address2, address3 = @address3, postcode = @postcode, city_id = @city_id, state_id = @state_id, country_id = @country_id, occategory_id = @occategory_id, region_id = @region_id, speeddial = @speeddial, company_id = @company_id, updatedAt = @updatedAt, status = @status WHERE id = @id">
                <InsertParameters>
                    <asp:Parameter Name="code"></asp:Parameter>
                    <asp:Parameter Name="name"></asp:Parameter>
                    <asp:Parameter Name="shortname"></asp:Parameter>
                    <asp:Parameter Name="address1"></asp:Parameter>
                    <asp:Parameter Name="address2"></asp:Parameter>
                    <asp:Parameter Name="address3"></asp:Parameter>
                    <asp:Parameter Name="postcode"></asp:Parameter>
                    <asp:Parameter Name="city_id"></asp:Parameter>
                    <asp:Parameter Name="state_id"></asp:Parameter>
                    <asp:Parameter Name="country_id"></asp:Parameter>
                    <asp:Parameter Name="occategory_id"></asp:Parameter>
                    <asp:Parameter Name="region_id"></asp:Parameter>
                    <asp:Parameter Name="speeddial"></asp:Parameter>
                    <asp:Parameter Name="company_id"></asp:Parameter>
                    <asp:Parameter Name="createdAt"></asp:Parameter>
                    <asp:Parameter Name="status"></asp:Parameter>
                </InsertParameters>
                <SelectParameters>
                    <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedValue" Name="id"></asp:ControlParameter>
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="code"></asp:Parameter>
                    <asp:Parameter Name="name"></asp:Parameter>
                    <asp:Parameter Name="shortname"></asp:Parameter>
                    <asp:Parameter Name="address1"></asp:Parameter>
                    <asp:Parameter Name="address2"></asp:Parameter>
                    <asp:Parameter Name="address3"></asp:Parameter>
                    <asp:Parameter Name="postcode"></asp:Parameter>
                    <asp:Parameter Name="city_id"></asp:Parameter>
                    <asp:Parameter Name="state_id"></asp:Parameter>
                    <asp:Parameter Name="country_id"></asp:Parameter>
                    <asp:Parameter Name="occategory_id"></asp:Parameter>
                    <asp:Parameter Name="region_id"></asp:Parameter>
                    <asp:Parameter Name="speeddial"></asp:Parameter>
                    <asp:Parameter Name="company_id"></asp:Parameter>
                    <asp:Parameter Name="updatedAt"></asp:Parameter>
                    <asp:Parameter Name="status"></asp:Parameter>
                    <asp:Parameter Name="id"></asp:Parameter>
                </UpdateParameters>
            </asp:SqlDataSource>

            <asp:SqlDataSource runat="server" ID="SqlDataSourceCity" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' SelectCommand="SELECT NULL AS id, 'Please Select' AS name UNION SELECT TBL_LOOKUPS.id, TBL_LOOKUPS.name FROM TBL_LOOKUPGRPS INNER JOIN TBL_LOOKUPS ON TBL_LOOKUPGRPS.id = TBL_LOOKUPS.lookupgrp_id WHERE (TBL_LOOKUPS.lookupgrp_id = 31)"></asp:SqlDataSource>
            <asp:SqlDataSource runat="server" ID="SqlDataSourceState" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' SelectCommand="SELECT NULL AS id, 'Please Select' AS name UNION SELECT TBL_LOOKUPS.id, TBL_LOOKUPS.name FROM TBL_LOOKUPGRPS INNER JOIN TBL_LOOKUPS ON TBL_LOOKUPGRPS.id = TBL_LOOKUPS.lookupgrp_id WHERE (TBL_LOOKUPS.lookupgrp_id = 8)"></asp:SqlDataSource>
            <asp:SqlDataSource runat="server" ID="SqlDataSourceCountry" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' SelectCommand="SELECT NULL AS id, 'Please Select' AS name UNION SELECT TBL_LOOKUPS.id, TBL_LOOKUPS.name FROM TBL_LOOKUPGRPS INNER JOIN TBL_LOOKUPS ON TBL_LOOKUPGRPS.id = TBL_LOOKUPS.lookupgrp_id WHERE (TBL_LOOKUPS.lookupgrp_id = 9)"></asp:SqlDataSource>
            <asp:SqlDataSource runat="server" ID="SqlDataSourceOcc" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' SelectCommand="SELECT NULL AS id, 'Please Select' AS name UNION SELECT TBL_LOOKUPS.id, TBL_LOOKUPS.name FROM TBL_LOOKUPGRPS INNER JOIN TBL_LOOKUPS ON TBL_LOOKUPGRPS.id = TBL_LOOKUPS.lookupgrp_id WHERE (TBL_LOOKUPS.lookupgrp_id = 15)"></asp:SqlDataSource>
            <asp:SqlDataSource runat="server" ID="SqlDataSourceRegion" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' SelectCommand="SELECT NULL AS id, 'Please Select' AS name UNION SELECT TBL_LOOKUPS.id, TBL_LOOKUPS.name FROM TBL_LOOKUPGRPS INNER JOIN TBL_LOOKUPS ON TBL_LOOKUPGRPS.id = TBL_LOOKUPS.lookupgrp_id WHERE (TBL_LOOKUPS.lookupgrp_id = 20)"></asp:SqlDataSource>
            <asp:SqlDataSource runat="server" ID="SqlDataSourceCompany" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' SelectCommand="SELECT NULL AS id, 'Please Select' AS name UNION SELECT id, name FROM TBL_COMPANIES"></asp:SqlDataSource>

        </div>
    </section>

    <script>
        $(function () {
            //Initialize Select2 Elements
            $('.select2').select2()

        })
    </script>

</asp:Content>

