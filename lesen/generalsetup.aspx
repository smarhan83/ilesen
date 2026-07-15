<%@ Page Title="" Language="VB" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="generalsetup.aspx.vb" Inherits="generalsetup" %>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">

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

    <section class="content">
        <div class="container-fluid">

            <div class="card">
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <%--<label>Tetapan</label>--%>
                            <asp:DropDownList CssClass="form-control" ID="ddlTetapan" runat="server" DataSourceID="sdsTetapan" DataTextField="name" DataValueField="id" AutoPostBack="True"></asp:DropDownList>
                            <asp:SqlDataSource runat="server" ID="sdsTetapan" 
                                ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' 
                                SelectCommand="SELECT NULL AS id, '-- Sila Pilih Tetapan --' AS name UNION ALL 
                                SELECT id, cast(id as varchar(max)) + ' - ' + name as name FROM TBL_LOOKUPGRPS where category='L' and status=1"></asp:SqlDataSource>
                            </div>
                        </div>
                    
                    </div>
                </div>
                </div>
        
                       

            <asp:FormView ID="FormView1" runat="server" DataKeyNames="id" DataSourceID="SqlDataSourceForm" DefaultMode="Insert" Width="100%">
                <EditItemTemplate>
                    <div class="card card-warning">
                        <div class="card-header">
                            <h3 class="card-title"><div runat="server" id="idWindowTitle2">Kemaskini</div></h3>

                            <div class="card-tools">
                                <button type="button" class="btn btn-tool" data-card-widget="collapse"><i class="fas fa-minus"></i></button>
                            </div>
                        </div>
                        <!-- /.card-header -->
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <%--<label>Tetapan</label>
                                        <asp:DropDownList Text='<%# Bind("lookupgrp_id") %>' CssClass="form-control" ID="DropDownListGroup" runat="server" DataSourceID="SqlDataSourceLookupGroup" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" CssClass="text-danger" runat="server" ControlToValidate="DropDownListGroup" ErrorMessage="Sila Isi" InitialValue="" ValidationGroup="updateForm"></asp:RequiredFieldValidator><br />--%>
                                        <label>Kod</label>
                                        <asp:TextBox Text='<%# Bind("shortcode") %>' CssClass="form-control" runat="server" ID="shortcodeTextBox" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" CssClass="text-danger" runat="server" ControlToValidate="shortcodeTextBox" ErrorMessage="Sila Isi" InitialValue="" ValidationGroup="updateForm"></asp:RequiredFieldValidator><br />
                                        <label>Nama</label>
                                        <asp:TextBox Text='<%# Bind("name") %>' CssClass="form-control" runat="server" ID="nameTextBox" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" CssClass="text-danger" runat="server" ControlToValidate="nameTextBox" ErrorMessage="Sila Isi" InitialValue="" ValidationGroup="updateForm"></asp:RequiredFieldValidator><br />
                                        <label>Status</label>
                                        <asp:CheckBox Checked='<%# Bind("status") %>' runat="server" ID="statusCheckBox" /><br />
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">

                                        <label>Nombor Susunan</label>
                                        <asp:TextBox Text='<%# Bind("seqno") %>'  type="number" CssClass="form-control"  runat="server" ID="seqnoTextBox" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" CssClass="text-danger" runat="server" ControlToValidate="seqnoTextBox" ErrorMessage="Sila Isi" InitialValue="" ValidationGroup="updateForm"></asp:RequiredFieldValidator><br />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="card-footer">
                            <asp:LinkButton runat="server" Text="Simpan" CommandName="Update" ValidationGroup="updateForm" CssClass="btn btn-warning" ID="LinkButton2" CausesValidation="True" />&nbsp;<asp:LinkButton runat="server" Text="Set Semula" CommandName="Cancel" ID="LinkButton3" CausesValidation="False" CssClass="btn btn-default" />
                        </div>
                    </div>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <div class="card card-primary">
                        <div class="card-header">
                            <h3 class="card-title"><div runat="server" id="idWindowTitle3">Kunci Masuk</div></h3>

                            <div class="card-tools">
                                <button type="button" class="btn btn-tool" data-card-widget="collapse"><i class="fas fa-minus"></i></button>
                            </div>
                        </div>
                        <!-- /.card-header -->
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <%--<label>Tetapan</label>
                                        <asp:DropDownList Text='<%# Bind("lookupgrp_id") %>' CssClass="form-control" ID="DropDownListGroup" runat="server" DataSourceID="SqlDataSourceLookupGroup" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" CssClass="text-danger" runat="server" ControlToValidate="DropDownListGroup" ErrorMessage="Sila Isi" InitialValue="" ValidationGroup="insertForm"></asp:RequiredFieldValidator><br />--%>
                                        <label>Kod</label>
                                        <asp:TextBox Text='<%# Bind("shortcode") %>' placeholder="Kod" CssClass="form-control" runat="server" ID="shortcodeTextBox" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" CssClass="text-danger" runat="server" ControlToValidate="shortcodeTextBox" ErrorMessage="Sila Isi" InitialValue="" ValidationGroup="insertForm"></asp:RequiredFieldValidator><br />
                                        <label>Nama</label>
                                        <asp:TextBox Text='<%# Bind("name") %>' placeholder="Nama" CssClass="form-control" runat="server" ID="nameTextBox" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" CssClass="text-danger" runat="server" ControlToValidate="nameTextBox" ErrorMessage="Sila Isi" InitialValue="" ValidationGroup="insertForm"></asp:RequiredFieldValidator><br />
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">                                        
                                        
                                        <label>Nombor Susunan</label>
                                        <asp:TextBox Text='<%# Bind("seqno") %>' type="number" placeholder="Nombor Susunan" CssClass="form-control"  runat="server" ID="seqnoTextBox" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" CssClass="text-danger" runat="server" ControlToValidate="seqnoTextBox" ErrorMessage="Sila Isi" InitialValue="" ValidationGroup="insertForm"></asp:RequiredFieldValidator><br />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="card-footer">
                            <asp:LinkButton runat="server" Text="Simpan" ValidationGroup="insertForm" CommandName="Insert" ID="LinkButton4" CausesValidation="True" CssClass="btn btn-primary" />&nbsp;<asp:LinkButton runat="server" Text="Set Semula" CommandName="Cancel" ID="LinkButton5" CausesValidation="False" CssClass="btn btn-default" />
                        </div>
                    </div>
   
                </InsertItemTemplate>
                <ItemTemplate>
               
                    <asp:LinkButton runat="server" Text="Ubah" CommandName="Edit" ID="EditButton" CausesValidation="False" />&nbsp;<asp:LinkButton runat="server" Text="New" CommandName="New" ID="NewButton" CausesValidation="False" />
                </ItemTemplate>
            </asp:FormView>


            <asp:SqlDataSource runat="server" ID="SqlDataSourceForm" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' 
                InsertCommand="INSERT INTO TBL_LOOKUPS(lookupgrp_id, shortcode, name, seqno, createdAt, status) VALUES 
                (@lookupgrp_id, @shortcode, @name, @seqno, GETDATE(), 1)" 
                SelectCommand="SELECT id, lookupgrp_id, shortcode, name, createdAt, updatedAt, status,seqno FROM TBL_LOOKUPS WHERE (id = @id)" 
                UpdateCommand="UPDATE TBL_LOOKUPS SET lookupgrp_id = @lookupgrp_id, shortcode = @shortcode, name = @name, seqno = @seqno, updatedAt = GETDATE(), status = @status WHERE (id = @id)">
                <InsertParameters>                    
                    <asp:Parameter Name="shortcode"></asp:Parameter>
                    <asp:Parameter Name="name"></asp:Parameter>
                    <asp:Parameter Name="seqno"></asp:Parameter>
                    <asp:ControlParameter ControlID="ddlTetapan" PropertyName="SelectedValue" DefaultValue="0" Name="lookupgrp_id"></asp:ControlParameter>
                </InsertParameters>
                <SelectParameters>
                    <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedValue" Name="id"></asp:ControlParameter>
                </SelectParameters>
                <UpdateParameters>
                    
                    <asp:Parameter Name="shortcode"></asp:Parameter>
                    <asp:Parameter Name="name"></asp:Parameter>
                    <asp:Parameter Name="seqno"></asp:Parameter>
                    <asp:Parameter Name="status"></asp:Parameter>
                    <asp:Parameter Name="id"></asp:Parameter>
                    <asp:ControlParameter ControlID="ddlTetapan" PropertyName="SelectedValue" DefaultValue="0" Name="lookupgrp_id"></asp:ControlParameter>
                </UpdateParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource runat="server" ID="SqlDataSourceLookupGroup" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' 
                SelectCommand="SELECT NULL AS id, '--Please Select--' AS name UNION ALL SELECT id, name FROM TBL_LOOKUPGRPS where status=1 and category='L'"></asp:SqlDataSource>

            <div class="card">
                <%--<div class="card-header">
                    <h3 class="card-title">Lookup Data</h3>
                    <div class="card-tools">
                        <button type="button" class="btn btn-tool" data-card-widget="collapse" data-toggle="tooltip" title="Collapse">
                            <i class="fas fa-minus"></i>
                        </button>
                    </div>
                </div>--%>
                <div class="card-body" style="overflow-x: auto;">                
                    
                    <%--<asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" DataKeyNames="ID" CssClass="table table-bordered table-striped" DataSourceID="SqlDataSourceGrid" AllowPaging="True" AllowSorting="True">--%>
                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="ID"
                        CssClass="table table-bordered" DataSourceID="SqlDataSourceGrid" AllowPaging="True" AllowSorting="True">
                        <Columns>
                            <%--<asp:BoundField DataField="ID" HeaderText="ID" ReadOnly="True" InsertVisible="False" SortExpression="ID"></asp:BoundField>--%>
                            <%--<asp:BoundField DataField="SHORTCODE" HeaderText="SHORTCODE" SortExpression="SHORTCODE"></asp:BoundField>--%>
                            <asp:BoundField DataField="NAME" HeaderText="Nama" SortExpression="NAME"></asp:BoundField>
                            <%--<asp:BoundField DataField="LOOKUP GROUP" HeaderText="Tetapan" SortExpression="LOOKUP GROUP"></asp:BoundField>--%>
                            <asp:TemplateField HeaderText="Status" SortExpression="STATUS">
                                <EditItemTemplate>
                                    <asp:TextBox runat="server" Text='<%# Bind("STATUS") %>' ID="TextBox1"></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <%# IIf(Eval("STATUS").ToString().Equals("True"), "Active", "Inactive") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="" ShowHeader="False">
                                <ItemTemplate>
                                    <asp:LinkButton runat="server" Text="Edit" CommandName="Select" CssClass="btn btn-warning btn-sm" CausesValidation="False" ID="LinkButton1"></asp:LinkButton>
                                    <asp:LinkButton runat="server" Text="Delete" CommandName="Delete" OnClientClick="return confirm('Are you sure to delete it?');" CssClass="btn btn-danger btn-sm" CausesValidation="False" ID="LinkButton2"></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>  
                        </Columns>
                    </asp:GridView>
                    <asp:SqlDataSource runat="server" ID="SqlDataSourceGrid" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' 
                        SelectCommand="SELECT TBL_LOOKUPS.id AS ID, TBL_LOOKUPS.shortcode AS SHORTCODE, TBL_LOOKUPS.name AS NAME, 
                        TBL_LOOKUPGRPS.name AS [LOOKUP GROUP], TBL_LOOKUPS.status AS STATUS 
                        FROM TBL_LOOKUPS 
                        INNER JOIN TBL_LOOKUPGRPS ON TBL_LOOKUPS.lookupgrp_id = TBL_LOOKUPGRPS.id 
                        WHERE TBL_LOOKUPS.lookupgrp_id = @lookupgrp_id and category = 'L'" 
                        DeleteCommand="DELETE FROM TBL_LOOKUPS WHERE (id = @id)">
                        <DeleteParameters>
                            <asp:Parameter Name="id"></asp:Parameter>
                        </DeleteParameters>
                        <SelectParameters>
                            <asp:ControlParameter ControlID="ddlTetapan" PropertyName="SelectedValue" DefaultValue="0" Name="lookupgrp_id"></asp:ControlParameter>
                        
                        </SelectParameters>
                        <SelectParameters>
                            <%--<asp:ControlParameter ControlID="TextBox2" PropertyName="Text" DefaultValue="%%" Name="NAME"></asp:ControlParameter>--%>
                            <%--<asp:ControlParameter ControlID="TextBox3" PropertyName="Text" DefaultValue="%%" Name="LOOKUPGROUP"></asp:ControlParameter>--%>
                        </SelectParameters>
                    </asp:SqlDataSource>
                </div>
            </div>

        </div>
    </section>

</asp:Content>



