<%@ Page Title="" Language="VB" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="apptype.aspx.vb" Inherits="apptype" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadContent" runat="Server">
    <style>
        .ajax__tab_xp .ajax__tab_header {
            background-image: url('') !important;
            font-size: 11pt !important;
            height: 40px !important;
            color: #000 !important;
        }

            .ajax__tab_xp .ajax__tab_header .ajax__tab_outer {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header .ajax__tab_inner {
                /* background-image: url('WebResource.axd?d=zNSHuGr6hc7c16bSY9eWXPrNBVsZSwehGbscYki57kRbdTai8trIfAuzMrttb3pm0uA8ApvgRAgRqJhPO3fCauUTiyK3qOK21RmA7QURs6o63zcRczK2Ul9bZbli-JHArtBLoeaLoTT7L8haCKoAtg2&t=636970230480000000'); */
            }

            .ajax__tab_xp .ajax__tab_header .ajax__tab_tab {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header .ajax__tab_hover .ajax__tab_outer {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header .ajax__tab_hover .ajax__tab_inner {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header .ajax__tab_hover .ajax__tab_tab {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header .ajax__tab_active .ajax__tab_outer {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header .ajax__tab_active .ajax__tab_inner {
                /* background-image: url('WebResource.axd?d=7d55T9B4j42nYTnSODbo405bsr8zp3hoGjir6Z58ZoKPdLgwtf6qu3MXJibmbhhdha0NpvsKmg-yAHSNyDR0n5oskACF5v0vuvb-ErTRvIZqPQgNHZyi6J2H6QcoTzSVIy4XafuCbAtMT3T8iHBky3A6CmqrVChVQYLFcawUCe01&t=636970230480000000'); */
            }

            .ajax__tab_xp .ajax__tab_header .ajax__tab_active .ajax__tab_tab {
                background-image: url('') !important;
            }

        .ajax__tab_xp .ajax__tab_header_verticalleft {
            background-image: url('') !important;
        }

            .ajax__tab_xp .ajax__tab_header_verticalleft .ajax__tab_outer {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_verticalleft .ajax__tab_inner {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_verticalleft .ajax__tab_tab {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_verticalleft .ajax__tab_hover .ajax__tab_outer {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_verticalleft .ajax__tab_hover .ajax__tab_inner {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_verticalleft .ajax__tab_hover .ajax__tab_tab {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_verticalleft .ajax__tab_active .ajax__tab_outer {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_verticalleft .ajax__tab_active .ajax__tab_inner {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_verticalleft .ajax__tab_active .ajax__tab_tab {
                background-image: url('') !important;
            }

        .ajax__tab_xp .ajax__tab_header_verticalright {
            background-image: url('') !important;
        }

            .ajax__tab_xp .ajax__tab_header_verticalright .ajax__tab_outer {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_verticalright .ajax__tab_inner {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_verticalright .ajax__tab_tab {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_verticalright .ajax__tab_hover .ajax__tab_outer {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_verticalright .ajax__tab_hover .ajax__tab_inner {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_verticalright .ajax__tab_hover .ajax__tab_tab {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_verticalright .ajax__tab_active .ajax__tab_outer {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_verticalright .ajax__tab_active .ajax__tab_inner {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_verticalright .ajax__tab_active .ajax__tab_tab {
                background-image: url('') !important;
            }

        .ajax__tab_xp .ajax__tab_header_bottom {
            background-image: url('') !important;
        }

            .ajax__tab_xp .ajax__tab_header_bottom .ajax__tab_outer {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_bottom .ajax__tab_inner {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_bottom .ajax__tab_tab {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_bottom .ajax__tab_hover .ajax__tab_outer {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_bottom .ajax__tab_hover .ajax__tab_inner {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_bottom .ajax__tab_hover .ajax__tab_tab {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_bottom .ajax__tab_active .ajax__tab_outer {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_bottom .ajax__tab_active .ajax__tab_inner {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_bottom .ajax__tab_active .ajax__tab_tab {
                background-image: url('') !important;
            }

        .ajax__tab_xp .ajax__tab_header .ajax__tab_active .ajax__tab_inner {
            background-image: url('') !important;
            background-color: #5046E5 !important;
            width: 150px !important;
            text-align: center !important;
            vertical-align: middle !important;
            border-top-right-radius: 10px 10px !important;
            border-top-left-radius: 10px 10px !important;
            border: #5046E5 10px;
        }

            .ajax__tab_xp .ajax__tab_header .ajax__tab_active .ajax__tab_inner a {
                color: #fff !important;
                /*font-weight : bold !important;*/
            }

        .ajax__tab_xp .ajax__tab_header .ajax__tab_inner {
            background-image: url('') !important;
            background-color: #E9ECEF !important;
            width: 150px !important;
            text-align: center !important;
            vertical-align: middle !important;
            border-top-right-radius: 10px 10px !important;
            border-top-left-radius: 10px 10px !important;
        }

            .ajax__tab_xp .ajax__tab_header .ajax__tab_inner a {
                color: #413a3a !important;
            }


        .styleDisplayNone {
            display: none;
        }

        .table-bordered {
            text-align: center;
        }
    </style>
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

    <!-- Main content -->
    <section class="content">
        <div class="container-fluid">
            
            <asp:FormView ID="FormView1" runat="server" DataKeyNames="JenisLesen_ID"
                DataSourceID="SqlDataSourceForm" DefaultMode="Insert" Width="100%">
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
                                        <label>Jenis Lesen</label>
                                        <asp:TextBox ID="txtJenisLesen_Description" runat="server"
                                            Text='<%# Bind("JenisLesen_Description") %>' CssClass="form-control" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" CssClass="cssRequiredField"
                                            ControlToValidate="txtJenisLesen_Description" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </div>
                            </div>

                            <div class="col-md-6">
                                   
                                    <div class="form-group">
                                        <label>Catatan</label>
                                        <asp:TextBox ID="txtJenisLesen_Remarks" runat="server"
                                            Text='<%# Bind("JenisLesen_Remarks") %>' CssClass="form-control" TextMode="MultiLine" Rows="3"/>                                       
                                    </div>

                            </div>

                          </div>

                           <div class="row">
                            
                            <div class="col-md-6">

                                    <div class="form-group">
                                        <label>Kategori</label>
                                        <asp:DropDownList ID="ddlJenisLesen_Category" runat="server"
                                            SelectedValue='<%# Bind("JenisLesen_Category") %>' CssClass="form-control select2">
                                            <asp:ListItem Value="A">-- Kategori Lesen --</asp:ListItem>
                                            <asp:ListItem Value="R">Berisiko</asp:ListItem>
                                            <asp:ListItem Value="T">Tidak Berisiko</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                            </div>

                            <div class="col-md-6">

                                    <div class="form-group">
                                        
                                            <label>Aktif?</label><br />
                                        <div class="form-check">
                                            <asp:CheckBox ID="CheckBox2" runat="server" Checked='<%# Bind("JenisLesen_IsActive") %>' CssClass="form-check-input" />
                                        </div>
                                    </div>                                 
                                <!-- /.form-group -->
                                
                            </div>
                            <!-- /.col -->
                            </div>
                        <!-- /.row -->



                    </div>
                    <!-- /.card-body -->                                              

                        

                    <div class="card-footer">
                        <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" CommandName="Update" Text="Kemaskini" ValidationGroup="frmEdit" CssClass="btn btn-warning" />
                        &nbsp;<asp:LinkButton ID="UpdateCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Set Semula" CssClass="btn btn-default" OnClick="UpdateCancelButton_Click" />
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
                                        <label>Jenis Lesen</label>
                                        <asp:TextBox ID="txtJenisLesen_Description" runat="server"
                                            Text='<%# Bind("JenisLesen_Description") %>' CssClass="form-control" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" CssClass="cssRequiredField"
                                            ControlToValidate="txtJenisLesen_Description" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </div>
                            </div>

                            <div class="col-md-6">
                                   
                                    <div class="form-group">
                                        <label>Catatan</label>
                                        <asp:TextBox ID="txtJenisLesen_Remarks" runat="server"
                                            Text='<%# Bind("JenisLesen_Remarks") %>' CssClass="form-control" TextMode="MultiLine" Rows="3"/>                                       
                                    </div>

                            </div>

                          </div>

                           <div class="row">
                            
                            <div class="col-md-6">

                                    <div class="form-group">
                                        <label>Kategori</label>
                                        <asp:DropDownList ID="ddlJenisLesen_Category" runat="server"
                                            SelectedValue='<%# Bind("JenisLesen_Category") %>' CssClass="form-control select2">
                                            <asp:ListItem Value="A">-- Kategori Lesen --</asp:ListItem>
                                            <asp:ListItem Value="R">Berisiko</asp:ListItem>
                                            <asp:ListItem Value="T">Tidak Berisiko</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                            </div>

                            <div class="col-md-6">

                                    <div class="form-group">
                                        
                                            <label>Aktif?</label><br />
                                        <div class="form-check">
                                            <asp:CheckBox ID="CheckBox2" runat="server" Checked='<%# Bind("JenisLesen_IsActive") %>' CssClass="form-check-input" />
                                        </div>
                                    </div>                                 
                                <!-- /.form-group -->
                                
                            </div>
                            <!-- /.col -->
                        </div>
                        <!-- /.row -->


                        
                    </div>
                        <!-- /.card-body -->
                        <div class="card-footer">
                            <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" Text="Kunci Masuk" ValidationGroup="frmEdit" CssClass="btn btn-primary" />
                            &nbsp;
                                <asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Set Semula" CssClass="btn btn-default" />
                        </div>
                    </div>
                </InsertItemTemplate>
            </asp:FormView>


            <asp:TabContainer ID="TabContainer1" runat="server" ActiveTabIndex="0" Visible="false" CssClass="MyTabStyle">                

                <asp:TabPanel runat="server" ID="TabPanel1" HeaderText="Mohon Ulasan">
                    <HeaderTemplate>Mohon Ulasan</HeaderTemplate>
                    <ContentTemplate>
                        <div class="card">
                            <div class="card-body">

                                <div class="row">
                                    <div class="col-12">
                                        <asp:FormView ID="FormViewMaintenanceTemplate" Width="100%" DefaultMode="Insert" runat="server" DataKeyNames="PermohonanAgensi_ID" DataSourceID="SqlDataSourceFormviewMaintenanceTemplate">
                                            <InsertItemTemplate>
                                                <asp:Panel runat ="server">
                                                    <div class="card card-default">
                                                   <%-- <div class="card-header">
                                                        <h3 class="card-title" style="color: black">Tambah Jabatan Agensi</h3>
                                                    </div>--%>
                                                    <!-- /.card-header -->
                                                    <div class="card-body">
                                                        <div class="row">

                                                            <div class="col-md-6">
                                                                <div class="form-group">
                                                                    <label>Jabatan Agensi</label>
                                                                    <asp:DropDownList ID="DDL_JabatanAgensi" Text='<%# Bind("JabatanAgensi_ID") %>' CssClass="form-control select2" runat="server"
                                                                        DataSourceID="SqlDataSourceJabatanAgensi" DataTextField="JabatanAgensi_Description" DataValueField="JabatanAgensi_ID">
                                                                    </asp:DropDownList>
                                                                    <asp:SqlDataSource runat="server" ID="SqlDataSourceJabatanAgensi" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                                        SelectCommand="select * from 
                                                                    (select NULL as JabatanAgensi_ID, '-- Sila Pilih --' as JabatanAgensi_Description
                                                                    union all
                                                                    select JabatanAgensi_ID,  JabatanAgensi_Description from LESEN_JabatanAgensi where JabatanAgensi_IsActive=1
                                                                    ) as tbl1 order by JabatanAgensi_Description "></asp:SqlDataSource>
                                                                </div>
                                                            </div>

                                                        </div>
                                                    </div>
                                                    <div class="card-footer">
                                                        <asp:LinkButton runat="server" Text="Tambah" CssClass="btn btn-primary" ValidationGroup="insertMaintenanceTemplateForm" CommandName="Insert" ID="LinkButton3" CausesValidation="True" />
                                                    </div>
                                                </div>
                                                </asp:Panel>
                                            </InsertItemTemplate>
                                        </asp:FormView>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourceFormviewMaintenanceTemplate" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            InsertCommand="INSERT INTO LESEN_JenisLesenAgensi (JenisLesen_ID, JabatanAgensi_ID,CreatedDt) VALUES (@JenisLesen_ID, @JabatanAgensi_ID, getdate()); "
                                            SelectCommand="SELECT top 1 * FROM LESEN_JabatanAgensi a
                                            WHERE a.JabatanAgensi_IsActive = 1">
                                            <InsertParameters>
                                                <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedValue" Name="JenisLesen_ID"></asp:ControlParameter>
                                                <asp:Parameter Name="JabatanAgensi_ID"></asp:Parameter>
                                                <%--<asp:ControlParameter ControlID="GridView1" PropertyName="SelectedValue" Name="JenisLesen_ID"></asp:ControlParameter>--%>
                                            </InsertParameters>
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedValue" Name="JenisLesen_ID"></asp:ControlParameter>
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                    </div>
                                </div>
                                <!-- /.tab-1 Formview -->
                                <div class="row">
                                    <div class="col-12">
                                        <asp:GridView ID="GridViewMaintenanceTemplate" HeaderStyle-ForeColor="Black" CssClass="table table-bordered" AllowPaging="True" ShowHeaderWhenEmpty="True" EmptyDataText="No records Found" AllowSorting="True" runat="server" AutoGenerateColumns="False" DataKeyNames="JenisLesenAgensi_ID" DataSourceID="SqlDataSourceGridMaintenanceTemplate">
                                            <Columns>
                                                <asp:BoundField DataField="JabatanAgensi_Description" HeaderText="Jabatan / Agensi" SortExpression="JabatanAgensi_Description"></asp:BoundField>
                                                <asp:TemplateField ShowHeader="False">
                                                    <EditItemTemplate>
                                                    </EditItemTemplate>
                                                    <ItemTemplate>
                                                        <asp:LinkButton runat="server" CommandName="Delete" CssClass="btn btn-danger btn-sm" OnClientClick="return confirm('Padam pilihan ini?');" data-toggle="tooltip" data-placement="top" title="Delete" CausesValidation="False" ID="LinkButton2">Padam</asp:LinkButton>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourceGridMaintenanceTemplate" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            DeleteCommand="DELETE FROM LESEN_JenisLesenAgensi WHERE JenisLesenAgensi_ID = @JenisLesenAgensi_ID"
                                            SelectCommand="SELECT * FROM LESEN_JenisLesenAgensi a 
                                            INNER JOIN LESEN_JabatanAgensi b ON a.JabatanAgensi_ID = b.JabatanAgensi_ID 
                                            WHERE a.JenisLesen_ID = @JenisLesen_ID">
                                            <DeleteParameters>
                                                <asp:Parameter Name="JenisLesenAgensi_ID"></asp:Parameter>
                                            </DeleteParameters>
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedValue" Name="JenisLesen_ID"></asp:ControlParameter>
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                    </div>
                                </div>
                                <!-- /.tab-1 Gridview -->
                            </div>
                        </div>
                    </ContentTemplate>
                </asp:TabPanel>

                <asp:TabPanel runat="server" ID="TabPanel2" HeaderText="Kadar Bayaran">
                    <HeaderTemplate>Kadar Bayaran</HeaderTemplate>
                    <ContentTemplate>
                        <div class="card">
                            <div class="card-body">

                                <div class="row">
                                    <div class="col-12">
                                        <asp:FormView ID="fvBayaran" Width="100%" DefaultMode="Insert" runat="server" DataKeyNames="JenisLesenBayaran_ID" DataSourceID="sqlKadarBayaran">
                                            <InsertItemTemplate>
                                                <asp:Panel runat ="server">
                                                    <div class="card card-default">

                                                    <div class="card-body">
                                                        <div class="row">

                                                            <div class="col-md-6">
                                                                <div class="form-group">
                                                                    <label>Bayaran *</label>
                                                                    <asp:TextBox ID="txtJenisLesenBayaran_Description" runat="server"
                                                                    Text='<%# Bind("JenisLesenBayaran_Description") %>' CssClass="form-control" />
                                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" CssClass="cssRequiredField"
                                                                    ControlToValidate="txtJenisLesenBayaran_Description" ErrorMessage="Sila Isi" ValidationGroup="frmEditBayaran" Display="Dynamic"></asp:RequiredFieldValidator>                                                                    
                                                                </div>
                                                            </div>
                                                            <div class="col-md-3">
                                                                <div class="form-group">
                                                                    <label>Jumlah (RM) *</label>
                                                                    <asp:TextBox ID="txtJenisLesenBayaran_Amount" runat="server" type="number"
                                                                    Text='<%# Bind("JenisLesenBayaran_Amount") %>' CssClass="form-control" />
                                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" CssClass="cssRequiredField"
                                                                    ControlToValidate="txtJenisLesenBayaran_Amount" ErrorMessage="Sila Isi" ValidationGroup="frmEditBayaran" Display="Dynamic"></asp:RequiredFieldValidator>                                                                    
                                                                </div>
                                                            </div>

                                                        </div>
                                                    </div>
                                                    <div class="card-footer">
                                                        <asp:LinkButton runat="server" Text="Tambah" CssClass="btn btn-primary" ValidationGroup="frmEditBayaran" CommandName="Insert" ID="LinkButton3" CausesValidation="True" />
                                                    </div>
                                                </div>
                                                </asp:Panel>
                                            </InsertItemTemplate>
                                        </asp:FormView>
                                        <asp:SqlDataSource runat="server" ID="sqlKadarBayaran" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            InsertCommand="INSERT INTO LESEN_JenisLesenBayaran (JenisLesen_ID, JenisLesenBayaran_Description,JenisLesenBayaran_Amount,CreatedDt) VALUES 
                                            (@JenisLesen_ID, @JenisLesenBayaran_Description, @JenisLesenBayaran_Amount, getdate()); "
                                            SelectCommand="SELECT top 1 * FROM LESEN_JenisLesenBayaran a
                                            WHERE a.JenisLesen_ID = @JenisLesen_ID">
                                            <InsertParameters>
                                                <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedValue" Name="JenisLesen_ID"></asp:ControlParameter>
                                                <asp:Parameter Name="JenisLesenBayaran_Description"></asp:Parameter>
                                                <asp:Parameter Name="JenisLesenBayaran_Amount"></asp:Parameter>
                                            </InsertParameters>
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedValue" Name="JenisLesen_ID"></asp:ControlParameter>
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                    </div>
                                </div>
                                <!-- /.tab-1 Formview -->
                                <div class="row">
                                    <div class="col-12">
                                        <asp:GridView ID="gvBayaran" HeaderStyle-ForeColor="Black" CssClass="table table-bordered" AllowPaging="True" ShowHeaderWhenEmpty="True" EmptyDataText="No records Found" AllowSorting="True" runat="server" AutoGenerateColumns="False" 
                                            DataKeyNames="JenisLesenBayaran_ID" DataSourceID="sqlGVBayaran">
                                            <Columns>
                                                <asp:BoundField DataField="JenisLesenBayaran_Description" HeaderText="Bayaran" SortExpression="JenisLesenBayaran_Description"></asp:BoundField>
                                                <asp:BoundField DataField="JenisLesenBayaran_Amount" HeaderText="Jumlah (RM)" SortExpression="JenisLesenBayaran_Amount"></asp:BoundField>
                                                <asp:TemplateField ShowHeader="False">
                                                    <EditItemTemplate>
                                                    </EditItemTemplate>
                                                    <ItemTemplate>
                                                        <asp:LinkButton runat="server" CommandName="Delete" CssClass="btn btn-danger btn-sm" OnClientClick="return confirm('Padam pilihan ini?');" data-toggle="tooltip" data-placement="top" title="Delete" CausesValidation="False" ID="LinkButton2">Padam</asp:LinkButton>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                        <asp:SqlDataSource runat="server" ID="sqlGVBayaran" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            DeleteCommand="DELETE FROM LESEN_JenisLesenBayaran WHERE JenisLesenBayaran_ID = @JenisLesenBayaran_ID"
                                            SelectCommand="SELECT * FROM LESEN_JenisLesenBayaran a                                             
                                            WHERE a.JenisLesen_ID = @JenisLesen_ID">
                                            <DeleteParameters>
                                                <asp:Parameter Name="JenisLesenBayaran_ID"></asp:Parameter>
                                            </DeleteParameters>
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedValue" Name="JenisLesen_ID"></asp:ControlParameter>
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                    </div>
                                </div>
                                <!-- /.tab-1 Gridview -->
                            </div>
                        </div>
                    </ContentTemplate>
                </asp:TabPanel>

                <asp:TabPanel runat="server" ID="TabPanel7" HeaderText="Templat Surat">
                    <HeaderTemplate>Templat Surat</HeaderTemplate>
                    <ContentTemplate>
                        <div class="card">
                            <div class="card-body">

                                <div class="row">
                                    <div class="col-4">
                                        <div class="form-group">
                                            <label>Jenis Surat</label>
                                            <asp:DropDownList ID="DDL_ReportType" AutoPostBack="true" runat="server" CssClass="form-control">
                                                <asp:ListItem Value="SKL" Selected="True">Surat Kelulusan (Lulus)</asp:ListItem>
                                                <asp:ListItem Value="SKB">Surat Kelulusan (Batal)</asp:ListItem>
                                                <asp:ListItem Value="SPL">Surat Pembatalan (Lulus)</asp:ListItem>
                                                <asp:ListItem Value="SPB">Surat Pembatalan (Batal)</asp:ListItem>
                                                <asp:ListItem Value="LIL">Laporan Inspektorat (Lulus)</asp:ListItem>
                                                <asp:ListItem Value="LIB">Laporan Inspektorat (Batal)</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-12">

                                        <asp:FormView ID="FormViewReport" Width="100%" DefaultMode="Insert" runat="server" DataKeyNames="RTID" DataSourceID="SqlDataSourceReport">
                                            <EditItemTemplate>
                                                <asp:Panel runat ="server">
                                                    <div class="card card-default">
                                                   <div class="card-header">
                                                        <h3 class="card-title" style="color: black">Kemaskini Isi Surat</h3>
                                                    </div>
                                                    <!-- /.card-header -->
                                                    <div class="card-body">
                                                        <div class="row">

                                                            <div class="col-md-2">
                                                                <div class="form-group">
                                                                    <label>No Perenggan Utama</label>
                                                                    <asp:TextBox ID="TB_P1" runat="server"  TextMode="Number"
                                                                        Text='<%# Bind("P1") %>' CssClass="form-control" />
                                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" CssClass="cssRequiredField"
                                                                        ControlToValidate="TB_P1" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                                                </div>
                                                            </div>

                                                            <div class="col-md-2">
                                                                <div class="form-group">
                                                                    <label>No Perenggan Sekunder</label>
                                                                    <asp:TextBox ID="TB_P2" runat="server"  TextMode="Number"
                                                                        Text='<%# Bind("P2") %>' CssClass="form-control" />
                                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" CssClass="cssRequiredField"
                                                                        ControlToValidate="TB_P2" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                                                </div>
                                                            </div>

                                                            <div class="col-md-2">
                                                                <div class="form-group">
                                                                    <label>No Perenggan Tertier</label>
                                                                    <asp:TextBox ID="TB_P3" runat="server"  TextMode="Number"
                                                                        Text='<%# Bind("P3") %>' CssClass="form-control" />
                                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" CssClass="cssRequiredField"
                                                                        ControlToValidate="TB_P3" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                                                </div>
                                                            </div>

                                                        </div>

                                                        <div class="row">

                                                            <div class="col-md-8">
                                                                <div class="form-group">
                                                                    <label>Isi Kandungan</label>
                                                                    <asp:TextBox ID="TB_IsiKandungan" runat="server"  TextMode="Multiline"
                                                                        Text='<%# Bind("IsiKandungan") %>' CssClass="form-control" />
                                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" CssClass="cssRequiredField"
                                                                        ControlToValidate="TB_IsiKandungan" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                                                </div>
                                                            </div>

                                                        </div>
                                                    </div>
                                                    <div class="card-footer">
                                                        <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" CommandName="Update" Text="Simpan" ValidationGroup="frmEdit" CssClass="btn btn-primary" />
                                                        &nbsp;
                                                        <asp:LinkButton ID="UpdateCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Set Semula" CssClass="btn btn-default" />
                                                    </div>
                                                </div>
                                                </asp:Panel>
                                            </EditItemTemplate>
                                            <InsertItemTemplate>
                                                <asp:Panel runat ="server">
                                                    <div class="card card-default">
                                                   <div class="card-header">
                                                        <h3 class="card-title" style="color: black">Tambah Isi Surat</h3>
                                                    </div>
                                                    <!-- /.card-header -->
                                                    <div class="card-body">
                                                        <div class="row">

                                                            <div class="col-md-2">
                                                                <div class="form-group">
                                                                    <label>No Perenggan Utama</label>
                                                                    <asp:TextBox ID="TB_P1" runat="server"  TextMode="Number"
                                                                        Text='<%# Bind("P1") %>' CssClass="form-control" />
                                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" CssClass="cssRequiredField"
                                                                        ControlToValidate="TB_P1" ErrorMessage="Sila Isi" ValidationGroup="frmInsert" Display="Dynamic"></asp:RequiredFieldValidator>
                                                                </div>
                                                            </div>

                                                            <div class="col-md-2">
                                                                <div class="form-group">
                                                                    <label>No Perenggan Sekunder</label>
                                                                    <asp:TextBox ID="TB_P2" runat="server"  TextMode="Number"
                                                                        Text='<%# Bind("P2") %>' CssClass="form-control" />
                                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" CssClass="cssRequiredField"
                                                                        ControlToValidate="TB_P2" ErrorMessage="Sila Isi" ValidationGroup="frmInsert" Display="Dynamic"></asp:RequiredFieldValidator>
                                                                </div>
                                                            </div>

                                                            <div class="col-md-2">
                                                                <div class="form-group">
                                                                    <label>No Perenggan Tertier</label>
                                                                    <asp:TextBox ID="TB_P3" runat="server"  TextMode="Number"
                                                                        Text='<%# Bind("P3") %>' CssClass="form-control" />
                                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" CssClass="cssRequiredField"
                                                                        ControlToValidate="TB_P3" ErrorMessage="Sila Isi" ValidationGroup="frmInsert" Display="Dynamic"></asp:RequiredFieldValidator>
                                                                </div>
                                                            </div>

                                                        </div>

                                                        <div class="row">

                                                            <div class="col-md-8">
                                                                <div class="form-group">
                                                                    <label>Isi Kandungan</label>
                                                                    <asp:TextBox ID="TB_IsiKandungan" runat="server"  TextMode="Multiline"
                                                                        Text='<%# Bind("IsiKandungan") %>' CssClass="form-control" />
                                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" CssClass="cssRequiredField"
                                                                        ControlToValidate="TB_IsiKandungan" ErrorMessage="Sila Isi" ValidationGroup="frmInsert" Display="Dynamic"></asp:RequiredFieldValidator>
                                                                </div>
                                                            </div>

                                                        </div>
                                                    </div>
                                                    <div class="card-footer">
                                                        <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" Text="Kunci Masuk" ValidationGroup="frmInsert" CssClass="btn btn-primary" />
                                                        &nbsp;
                                                        <asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Set Semula" CssClass="btn btn-default" />
                                                    </div>
                                                </div>
                                                </asp:Panel>
                                            </InsertItemTemplate>
                                        </asp:FormView>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourceReport" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            InsertCommand="INSERT INTO LESEN_ReportTemplate (JenisLesen_ID, JenisReport, P1, P2, P3, IsiKandungan, CreatedDt) VALUES (@JenisLesen_ID, @JenisReport, @P1, @P2, @P3, @IsiKandungan, GETDATE()); "
                                            UpdateCommand="UPDATE LESEN_ReportTemplate SET P1=@P1, P2=@P2, P3=@P3, IsiKandungan=@IsiKandungan WHERE RTID=@RTID"
                                            SelectCommand="SELECT * FROM LESEN_ReportTemplate WHERE RTID=@RTID">
                                            <InsertParameters>
                                                <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedValue" Name="JenisLesen_ID"></asp:ControlParameter>
                                                <asp:ControlParameter ControlID="DDL_ReportType" PropertyName="SelectedValue" Name="JenisReport"></asp:ControlParameter>
                                                <asp:Parameter Name="P1"></asp:Parameter>
                                                <asp:Parameter Name="P2"></asp:Parameter>
                                                <asp:Parameter Name="P3"></asp:Parameter>
                                                <asp:Parameter Name="IsiKandungan"></asp:Parameter>
                                                <%--<asp:ControlParameter ControlID="GridView1" PropertyName="SelectedValue" Name="JenisLesen_ID"></asp:ControlParameter>--%>
                                            </InsertParameters>
                                            <UpdateParameters>
                                                <asp:Parameter Name="P1"></asp:Parameter>
                                                <asp:Parameter Name="P2"></asp:Parameter>
                                                <asp:Parameter Name="P3"></asp:Parameter>
                                                <asp:Parameter Name="IsiKandungan"></asp:Parameter>
                                                <asp:ControlParameter ControlID="DDL_ReportType" PropertyName="SelectedValue" Name="JenisReport" />
                                                <asp:ControlParameter ControlID="GridViewReport" DefaultValue="" Name="RTID" PropertyName="SelectedValue" />
                                            </UpdateParameters>
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="GridViewReport" PropertyName="SelectedValue" Name="RTID"></asp:ControlParameter>
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                    </div>
                                </div>
                                <!-- /.tab-1 Formview -->
                                <div class="row">
                                    <div class="col-12">
                                        <asp:GridView ID="GridViewReport" HeaderStyle-ForeColor="Black" CssClass="table table-bordered" AllowPaging="True" ShowHeaderWhenEmpty="True" EmptyDataText="No records Found" AllowSorting="True" runat="server" AutoGenerateColumns="False" DataKeyNames="RTID" DataSourceID="SqlDataSourceGridReport">
                                            <Columns>
                                                <asp:BoundField DataField="P1" HeaderText="No Perenggan Utama" SortExpression="P1"></asp:BoundField>
                                                <asp:BoundField DataField="P2" HeaderText="No Perenggan Sekunder" SortExpression="P2"></asp:BoundField>
                                                <asp:BoundField DataField="P3" HeaderText="No Perenggan Tertier" SortExpression="P3"></asp:BoundField>
                                                <asp:BoundField DataField="IsiKandungan" HeaderText="Isi Kandungan" SortExpression="IsiKandungan"></asp:BoundField>
                                                <asp:TemplateField ShowHeader="False">
                                                    <ItemTemplate>
                                                        <asp:LinkButton runat="server" Text="Kemaskini" CommandName="Select" CausesValidation="False" ID="LinkButton4" CssClass="btn btn-warning btn-sm"></asp:LinkButton>
                                                        <br />
                                                        <asp:LinkButton runat="server" CommandName="Delete" CssClass="btn btn-danger btn-sm" OnClientClick="return confirm('Padam pilihan ini?');" data-toggle="tooltip" data-placement="top" title="Delete" CausesValidation="False" ID="LinkButton5">Padam</asp:LinkButton>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourceGridReport" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            DeleteCommand="DELETE FROM LESEN_ReportTemplate WHERE RTID = @RTID"
                                            SelectCommand="SELECT * FROM LESEN_ReportTemplate WHERE JenisLesen_ID = @JenisLesen_ID AND JenisReport=@JenisReport 
                                            ORDER BY P1, P2, P3">
                                            <DeleteParameters>
                                                <asp:Parameter Name="JenisLesenAgensi_ID"></asp:Parameter>
                                            </DeleteParameters>
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedValue" Name="JenisLesen_ID"></asp:ControlParameter>
                                                <asp:ControlParameter ControlID="DDL_ReportType" PropertyName="SelectedValue" Name="JenisReport"></asp:ControlParameter>
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                    </div>
                                </div>
                                <!-- /.tab-1 Gridview -->
                            </div>
                        </div>
                    </ContentTemplate>
                </asp:TabPanel>

                <asp:TabPanel runat="server" ID="TabPanel3" HeaderText="Surat Kelulusan">
                    <HeaderTemplate>Surat Kelulusan</HeaderTemplate>
                    <ContentTemplate>

                    <asp:FormView ID="FormView2" runat="server" DataKeyNames="JenisLesen_ID"
                    DataSourceID="sdsFormSurat" DefaultMode="Edit" Width="100%">
                    <EditItemTemplate>
                        <div class="card">
                            <div class="card-body">

                        <div class="row" runat="server">
                            <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Bahagian 1 (LULUS)</label>
                                        <asp:TextBox ID="txtJenisLesen_SuratLulus1" runat="server"
                                            Text='<%# Bind("JenisLesen_SuratLulus1") %>' CssClass="form-control" TextMode="MultiLine" Rows="10"/> 
                                        <asp:HtmlEditorExtender ID="HtmlEditorExtender1" runat="server" TargetControlID="txtJenisLesen_SuratLulus1" DisplaySourceTab="True"></asp:HtmlEditorExtender>
                                      
                                    </div>
                            </div>

                            <div class="col-md-6">

                                    <div class="form-group">
                                        <label>Bahagian 2 (LULUS)</label>
                                        <asp:TextBox ID="txtJenisLesen_SuratLulus2" runat="server"
                                            Text='<%# Bind("JenisLesen_SuratLulus2") %>' CssClass="form-control" TextMode="MultiLine" Rows="10"/>  
                                        <asp:HtmlEditorExtender ID="HtmlEditorExtender2" runat="server" TargetControlID="txtJenisLesen_SuratLulus2" DisplaySourceTab="True"></asp:HtmlEditorExtender>
                                    </div>
                            </div>

                        </div>
                        <br /><br />
                        <div class="row" runat="server">
                            <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Bahagian 3 (LULUS)</label>
                                        <asp:TextBox ID="txtJenisLesen_SuratLulus3" runat="server"
                                            Text='<%# Bind("JenisLesen_SuratLulus3") %>' CssClass="form-control" TextMode="MultiLine" Rows="10"/> 
                                        <asp:HtmlEditorExtender ID="HtmlEditorExtender5" runat="server" TargetControlID="txtJenisLesen_SuratLulus3" DisplaySourceTab="True"></asp:HtmlEditorExtender>
                                      
                                    </div>
                            </div>

                            <div class="col-md-6">

                                    <div class="form-group">
                                        <label>Bahagian 4 (LULUS)</label>
                                        <asp:TextBox ID="txtJenisLesen_SuratLulus4" runat="server"
                                            Text='<%# Bind("JenisLesen_SuratLulus4") %>' CssClass="form-control" TextMode="MultiLine" Rows="10"/>  
                                        <asp:HtmlEditorExtender ID="HtmlEditorExtender6" runat="server" TargetControlID="txtJenisLesen_SuratLulus4" DisplaySourceTab="True"></asp:HtmlEditorExtender>
                                    </div>
                            </div>

                        </div>

                        <hr />                                
                        <hr />
                        <div class="row" runat="server">
                            <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Bahagian 1 (GAGAL)</label>
                                        <asp:TextBox ID="txtJenisLesen_SuratGagal1" runat="server"
                                            Text='<%# Bind("JenisLesen_SuratGagal1") %>' CssClass="form-control" TextMode="MultiLine" Rows="10"/> 
                                        <asp:HtmlEditorExtender ID="HtmlEditorExtender3" runat="server" TargetControlID="txtJenisLesen_SuratGagal1" DisplaySourceTab="True"></asp:HtmlEditorExtender>
                                      
                                    </div>
                            </div>

                            <div class="col-md-6">

                                    <div class="form-group">
                                        <label>Bahagian 2 (GAGAL)</label>
                                        <asp:TextBox ID="txtJenisLesen_SuratGagal2" runat="server"
                                            Text='<%# Bind("JenisLesen_SuratGagal2") %>' CssClass="form-control" TextMode="MultiLine" Rows="10"/>  
                                        <asp:HtmlEditorExtender ID="HtmlEditorExtender4" runat="server" TargetControlID="txtJenisLesen_SuratGagal2" DisplaySourceTab="True"></asp:HtmlEditorExtender>
                                    </div>
                            </div>

                        </div>                               

                            </div>
                    <br />
                    <div class="card-footer">
                        <asp:LinkButton ID="btnUpdateSuratKelulusan" runat="server" CausesValidation="True" CommandName="Update" Text="Kemaskini" ValidationGroup="frmEditSuratKelulusan" CssClass="btn btn-warning" />
                        
                    </div>
                        </div>
                    </EditItemTemplate>
                    <InsertItemTemplate></InsertItemTemplate>
                    </asp:FormView>

                    <asp:SqlDataSource ID="sdsFormSurat" runat="server"
                ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" 
                InsertCommand=""
                SelectCommand="SELECT * FROM LESEN_JenisLesen WHERE JenisLesen_ID = @JenisLesen_ID"
                UpdateCommand=
                "UPDATE LESEN_JenisLesen 
                SET 
                JenisLesen_SuratLulus1 = @JenisLesen_SuratLulus1,JenisLesen_SuratLulus2 = @JenisLesen_SuratLulus2,
                JenisLesen_SuratLulus3 = @JenisLesen_SuratLulus3,JenisLesen_SuratLulus4 = @JenisLesen_SuratLulus4,
                JenisLesen_SuratGagal1 = @JenisLesen_SuratGagal1,JenisLesen_SuratGagal2 = @JenisLesen_SuratGagal2,
                LastModID = @LastModID, LastModDt = getdate() WHERE (JenisLesen_ID = @JenisLesen_ID)">
                <InsertParameters>
                  
                </InsertParameters>
                <SelectParameters>
                    <asp:ControlParameter ControlID="GridView1" Name="JenisLesen_ID"
                        PropertyName="SelectedValue" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="JenisLesen_SuratLulus1" />
                    <asp:Parameter Name="JenisLesen_SuratLulus2" />
                    <asp:Parameter Name="JenisLesen_SuratLulus3" />
                    <asp:Parameter Name="JenisLesen_SuratLulus4" />
                    <asp:Parameter Name="JenisLesen_SuratGagal1" />
                    <asp:Parameter Name="JenisLesen_SuratGagal2" />
                    <asp:SessionParameter SessionField="sessionUserName" Name="LastModID"></asp:SessionParameter>    
                    <asp:ControlParameter ControlID="GridView1" DefaultValue="" Name="JenisLesen_ID" PropertyName="SelectedValue" />                    
                </UpdateParameters>
            </asp:SqlDataSource>

                    </ContentTemplate>
                </asp:TabPanel>

                <asp:TabPanel runat="server" ID="TabPanel4" HeaderText="Surat Pemeriksaan">
                    <HeaderTemplate>Surat Pemeriksaan</HeaderTemplate>
                    <ContentTemplate>                 

                    <asp:FormView ID="FormView3" runat="server" DataKeyNames="JenisLesen_ID"
                    DataSourceID="sdsFormPemeriksaan" DefaultMode="Edit" Width="100%">
                    <EditItemTemplate>
                        <div class="card">
                            <div class="card-body">

                        <div class="row" runat="server">
                            <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Bahagian 1 (LULUS)</label>
                                        <asp:TextBox ID="txtJenisLesen_SuratPemeriksaanLulus1" runat="server"
                                            Text='<%# Bind("JenisLesen_SuratPemeriksaanLulus1") %>' CssClass="form-control" TextMode="MultiLine" Rows="10"/> 
                                        <asp:HtmlEditorExtender ID="HtmlEditorExtender1" runat="server" TargetControlID="txtJenisLesen_SuratPemeriksaanLulus1" DisplaySourceTab="True"></asp:HtmlEditorExtender>
                                      
                                    </div>
                            </div>

                            <div class="col-md-6">

                                    <div class="form-group">
                                        <label>Bahagian 2 (LULUS)</label>
                                        <asp:TextBox ID="txtJenisLesen_SuratPemeriksaanLulus2" runat="server"
                                            Text='<%# Bind("JenisLesen_SuratPemeriksaanLulus2") %>' CssClass="form-control" TextMode="MultiLine" Rows="10"/>  
                                        <asp:HtmlEditorExtender ID="HtmlEditorExtender2" runat="server" TargetControlID="txtJenisLesen_SuratPemeriksaanLulus2" DisplaySourceTab="True"></asp:HtmlEditorExtender>
                                    </div>
                            </div>

                        </div>
                        <br /><br />
                        <div class="row" runat="server">
                            <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Bahagian 3 (LULUS)</label>
                                        <asp:TextBox ID="txtJenisLesen_SuratPemeriksaanLulus3" runat="server"
                                            Text='<%# Bind("JenisLesen_SuratPemeriksaanLulus3") %>' CssClass="form-control" TextMode="MultiLine" Rows="10"/> 
                                        <asp:HtmlEditorExtender ID="HtmlEditorExtender5" runat="server" TargetControlID="txtJenisLesen_SuratPemeriksaanLulus3" DisplaySourceTab="True"></asp:HtmlEditorExtender>
                                      
                                    </div>
                            </div>

                            <div class="col-md-6">

                                    <div class="form-group">
                                        <label>Bahagian 4 (LULUS)</label>
                                        <asp:TextBox ID="txtJenisLesen_SuratPemeriksaanLulus4" runat="server"
                                            Text='<%# Bind("JenisLesen_SuratPemeriksaanLulus4") %>' CssClass="form-control" TextMode="MultiLine" Rows="10"/>  
                                        <asp:HtmlEditorExtender ID="HtmlEditorExtender6" runat="server" TargetControlID="txtJenisLesen_SuratPemeriksaanLulus4" DisplaySourceTab="True"></asp:HtmlEditorExtender>
                                    </div>
                            </div>

                        </div>

                        <hr />                                
                        <hr />
                        <div class="row" runat="server">
                            <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Bahagian 1 (GAGAL)</label>
                                        <asp:TextBox ID="txtJenisLesen_SuratPemeriksaanGagal1" runat="server"
                                            Text='<%# Bind("JenisLesen_SuratPemeriksaanGagal1") %>' CssClass="form-control" TextMode="MultiLine" Rows="10"/> 
                                        <asp:HtmlEditorExtender ID="HtmlEditorExtender3" runat="server" TargetControlID="txtJenisLesen_SuratPemeriksaanGagal1" DisplaySourceTab="True"></asp:HtmlEditorExtender>
                                      
                                    </div>
                            </div>

                            <div class="col-md-6">

                                    <div class="form-group">
                                        <label>Bahagian 2 (GAGAL)</label>
                                        <asp:TextBox ID="txtJenisLesen_SuratPemeriksaanGagal2" runat="server"
                                            Text='<%# Bind("JenisLesen_SuratPemeriksaanGagal2") %>' CssClass="form-control" TextMode="MultiLine" Rows="10"/>  
                                        <asp:HtmlEditorExtender ID="HtmlEditorExtender4" runat="server" TargetControlID="txtJenisLesen_SuratPemeriksaanGagal2" DisplaySourceTab="True"></asp:HtmlEditorExtender>
                                    </div>
                            </div>

                        </div>
                                

                            </div>
                    <br />
                    <div class="card-footer">
                        <asp:LinkButton ID="btnUpdateSuratPemeriksaan" runat="server" CausesValidation="True" CommandName="Update" Text="Kemaskini" ValidationGroup="frmEditSuratPemeriksaan" CssClass="btn btn-warning" />
                        
                    </div>
                        </div>

                    </EditItemTemplate>
                    <InsertItemTemplate></InsertItemTemplate>
                    </asp:FormView>

                    <asp:SqlDataSource ID="sdsFormPemeriksaan" runat="server"
                ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" 
                InsertCommand=""
                SelectCommand="SELECT * FROM LESEN_JenisLesen WHERE JenisLesen_ID = @JenisLesen_ID"
                UpdateCommand=
                "UPDATE LESEN_JenisLesen 
                SET 
                JenisLesen_SuratPemeriksaanLulus1 = @JenisLesen_SuratPemeriksaanLulus1,JenisLesen_SuratPemeriksaanLulus2 = @JenisLesen_SuratPemeriksaanLulus2,
                JenisLesen_SuratPemeriksaanLulus3 = @JenisLesen_SuratPemeriksaanLulus3,JenisLesen_SuratPemeriksaanLulus4 = @JenisLesen_SuratPemeriksaanLulus4,
                JenisLesen_SuratPemeriksaanGagal1 = @JenisLesen_SuratPemeriksaanGagal1,JenisLesen_SuratPemeriksaanGagal2 = @JenisLesen_SuratPemeriksaanGagal2,
                LastModID = @LastModID, LastModDt = getdate() WHERE (JenisLesen_ID = @JenisLesen_ID)">
                <InsertParameters>
                  
                </InsertParameters>
                <SelectParameters>
                    <asp:ControlParameter ControlID="GridView1" Name="JenisLesen_ID"
                        PropertyName="SelectedValue" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="JenisLesen_SuratPemeriksaanLulus1" />
                    <asp:Parameter Name="JenisLesen_SuratPemeriksaanLulus2" />
                    <asp:Parameter Name="JenisLesen_SuratPemeriksaanLulus3" />
                    <asp:Parameter Name="JenisLesen_SuratPemeriksaanLulus4" />
                    <asp:Parameter Name="JenisLesen_SuratPemeriksaanGagal1" />
                    <asp:Parameter Name="JenisLesen_SuratPemeriksaanGagal2" />
                    <asp:SessionParameter SessionField="sessionUserName" Name="LastModID"></asp:SessionParameter>    
                    <asp:ControlParameter ControlID="GridView1" DefaultValue="" Name="JenisLesen_ID" PropertyName="SelectedValue" />                    
                </UpdateParameters>
            </asp:SqlDataSource>
                                
                          
                    </ContentTemplate>
                </asp:TabPanel>
				
                <asp:TabPanel runat="server" ID="TabPanel5" HeaderText="Surat Batal">
                    <HeaderTemplate>Surat Batal</HeaderTemplate>
                    <ContentTemplate>                 

                    <asp:FormView ID="FormView4" runat="server" DataKeyNames="JenisLesen_ID"
                    DataSourceID="sdsFormBatal" DefaultMode="Edit" Width="100%">
                    <EditItemTemplate>
                        <div class="card">
                            <div class="card-body">

                        <div class="row" runat="server">
                            <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Bahagian 1 (LULUS)</label>
                                        <asp:TextBox ID="txtJenisLesen_SuratBatalLulus1" runat="server"
                                            Text='<%# Bind("JenisLesen_SuratBatalLulus1") %>' CssClass="form-control" TextMode="MultiLine" Rows="10"/> 
                                        <asp:HtmlEditorExtender ID="HtmlEditorExtender1" runat="server" TargetControlID="txtJenisLesen_SuratBatalLulus1" DisplaySourceTab="True"></asp:HtmlEditorExtender>
                                      
                                    </div>
                            </div>

                            <div class="col-md-6">

                                    <div class="form-group">
                                        <label>Bahagian 2 (LULUS)</label>
                                        <asp:TextBox ID="txtJenisLesen_SuratBatalLulus2" runat="server"
                                            Text='<%# Bind("JenisLesen_SuratBatalLulus2") %>' CssClass="form-control" TextMode="MultiLine" Rows="10"/>  
                                        <asp:HtmlEditorExtender ID="HtmlEditorExtender2" runat="server" TargetControlID="txtJenisLesen_SuratBatalLulus2" DisplaySourceTab="True"></asp:HtmlEditorExtender>
                                    </div>
                            </div>

                        </div>
                     

                        <hr />                                
                        <hr />
                        <div class="row" runat="server">
                            <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Bahagian 1 (GAGAL)</label>
                                        <asp:TextBox ID="txtJenisLesen_SuratBatalGagal1" runat="server"
                                            Text='<%# Bind("JenisLesen_SuratBatalGagal1") %>' CssClass="form-control" TextMode="MultiLine" Rows="10"/> 
                                        <asp:HtmlEditorExtender ID="HtmlEditorExtender3" runat="server" TargetControlID="txtJenisLesen_SuratBatalGagal1" DisplaySourceTab="True"></asp:HtmlEditorExtender>
                                      
                                    </div>
                            </div>

                            <div class="col-md-6">

                                    <div class="form-group">
                                        <label>Bahagian 2 (GAGAL)</label>
                                        <asp:TextBox ID="txtJenisLesen_SuratBatalGagal2" runat="server"
                                            Text='<%# Bind("JenisLesen_SuratBatalGagal2") %>' CssClass="form-control" TextMode="MultiLine" Rows="10"/>  
                                        <asp:HtmlEditorExtender ID="HtmlEditorExtender4" runat="server" TargetControlID="txtJenisLesen_SuratBatalGagal2" DisplaySourceTab="True"></asp:HtmlEditorExtender>
                                    </div>
                            </div>

                        </div>
                                

                            </div>
                    <br />
                    <div class="card-footer">
                        <asp:LinkButton ID="btnUpdateSuratPemeriksaan" runat="server" CausesValidation="True" CommandName="Update" Text="Kemaskini" ValidationGroup="frmEditSuratPemeriksaan" CssClass="btn btn-warning" />
                        
                    </div>
                        </div>

                    </EditItemTemplate>
                    <InsertItemTemplate></InsertItemTemplate>
                    </asp:FormView>

                    <asp:SqlDataSource ID="sdsFormBatal" runat="server"
                ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" 
                InsertCommand=""
                SelectCommand="SELECT * FROM LESEN_JenisLesen WHERE JenisLesen_ID = @JenisLesen_ID"
                UpdateCommand=
                "UPDATE LESEN_JenisLesen 
                SET 
                JenisLesen_SuratBatalLulus1 = @JenisLesen_SuratBatalLulus1,JenisLesen_SuratBatalLulus2 = @JenisLesen_SuratBatalLulus2,                
                JenisLesen_SuratBatalGagal1 = @JenisLesen_SuratBatalGagal1,JenisLesen_SuratBatalGagal2 = @JenisLesen_SuratBatalGagal2,
                LastModID = @LastModID, LastModDt = getdate() WHERE (JenisLesen_ID = @JenisLesen_ID)">
                <InsertParameters>
                  
                </InsertParameters>
                <SelectParameters>
                    <asp:ControlParameter ControlID="GridView1" Name="JenisLesen_ID"
                        PropertyName="SelectedValue" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="JenisLesen_SuratBatalLulus1" />
                    <asp:Parameter Name="JenisLesen_SuratBatalLulus2" />
                    <asp:Parameter Name="JenisLesen_SuratBatalLulus3" />
                    <asp:Parameter Name="JenisLesen_SuratBatalLulus4" />
                    <asp:Parameter Name="JenisLesen_SuratBatalGagal1" />
                    <asp:Parameter Name="JenisLesen_SuratBatalGagal2" />
                    <asp:SessionParameter SessionField="sessionUserName" Name="LastModID"></asp:SessionParameter>    
                    <asp:ControlParameter ControlID="GridView1" DefaultValue="" Name="JenisLesen_ID" PropertyName="SelectedValue" />                    
                </UpdateParameters>
            </asp:SqlDataSource>
                                
                          
                    </ContentTemplate>
                </asp:TabPanel>			
                
                <asp:TabPanel runat="server" ID="TabPanel6" HeaderText="Surat Batal IK">
                    <HeaderTemplate>Surat Batal IK</HeaderTemplate>
                    <ContentTemplate>                 

                    <asp:FormView ID="FormView5" runat="server" DataKeyNames="JenisLesen_ID"
                    DataSourceID="sdsFormBatalIK" DefaultMode="Edit" Width="100%">
                    <EditItemTemplate>
                        <div class="card">
                            <div class="card-body">

                        <div class="row" runat="server">
                            <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Bahagian 1 (LULUS)</label>
                                        <asp:TextBox ID="txtJenisLesen_SuratBatalIKLulus1" runat="server"
                                            Text='<%# Bind("JenisLesen_SuratBatalIKLulus1") %>' CssClass="form-control" TextMode="MultiLine" Rows="10"/> 
                                        <asp:HtmlEditorExtender ID="HtmlEditorExtender1" runat="server" TargetControlID="txtJenisLesen_SuratBatalIKLulus1" DisplaySourceTab="True"></asp:HtmlEditorExtender>
                                      
                                    </div>
                            </div>

                            <div class="col-md-6">

                                    <div class="form-group">
                                        <label>Bahagian 2 (LULUS)</label>
                                        <asp:TextBox ID="txtJenisLesen_SuratBatalIKLulus2" runat="server"
                                            Text='<%# Bind("JenisLesen_SuratBatalIKLulus2") %>' CssClass="form-control" TextMode="MultiLine" Rows="10"/>  
                                        <asp:HtmlEditorExtender ID="HtmlEditorExtender2" runat="server" TargetControlID="txtJenisLesen_SuratBatalIKLulus2" DisplaySourceTab="True"></asp:HtmlEditorExtender>
                                    </div>
                            </div>

                        </div>
                     

                        <hr />                                
                        <hr />
                        <div class="row" runat="server">
                            <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Bahagian 1 (GAGAL)</label>
                                        <asp:TextBox ID="txtJenisLesen_SuratBatalIKGagal1" runat="server"
                                            Text='<%# Bind("JenisLesen_SuratBatalIKGagal1") %>' CssClass="form-control" TextMode="MultiLine" Rows="10"/> 
                                        <asp:HtmlEditorExtender ID="HtmlEditorExtender3" runat="server" TargetControlID="txtJenisLesen_SuratBatalIKGagal1" DisplaySourceTab="True"></asp:HtmlEditorExtender>
                                      
                                    </div>
                            </div>

                            <div class="col-md-6">

                                    <div class="form-group">
                                        <label>Bahagian 2 (GAGAL)</label>
                                        <asp:TextBox ID="txtJenisLesen_SuratBatalIKGagal2" runat="server"
                                            Text='<%# Bind("JenisLesen_SuratBatalIKGagal2") %>' CssClass="form-control" TextMode="MultiLine" Rows="10"/>  
                                        <asp:HtmlEditorExtender ID="HtmlEditorExtender4" runat="server" TargetControlID="txtJenisLesen_SuratBatalIKGagal2" DisplaySourceTab="True"></asp:HtmlEditorExtender>
                                    </div>
                            </div>

                        </div>
                                

                            </div>
                    <br />
                    <div class="card-footer">
                        <asp:LinkButton ID="btnUpdateSuratPemeriksaan" runat="server" CausesValidation="True" CommandName="Update" Text="Kemaskini" ValidationGroup="frmEditSuratPemeriksaan" CssClass="btn btn-warning" />
                        
                    </div>
                        </div>

                    </EditItemTemplate>
                    <InsertItemTemplate></InsertItemTemplate>
                    </asp:FormView>

                    <asp:SqlDataSource ID="sdsFormBatalIK" runat="server"
                ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" 
                InsertCommand=""
                SelectCommand="SELECT * FROM LESEN_JenisLesen WHERE JenisLesen_ID = @JenisLesen_ID"
                UpdateCommand=
                "UPDATE LESEN_JenisLesen 
                SET 
                JenisLesen_SuratBatalIKLulus1 = @JenisLesen_SuratBatalIKLulus1,JenisLesen_SuratBatalIKLulus2 = @JenisLesen_SuratBatalIKLulus2,                
                JenisLesen_SuratBatalIKGagal1 = @JenisLesen_SuratBatalIKGagal1,JenisLesen_SuratBatalIKGagal2 = @JenisLesen_SuratBatalIKGagal2,
                LastModID = @LastModID, LastModDt = getdate() WHERE (JenisLesen_ID = @JenisLesen_ID)">
                <InsertParameters>
                  
                </InsertParameters>
                <SelectParameters>
                    <asp:ControlParameter ControlID="GridView1" Name="JenisLesen_ID"
                        PropertyName="SelectedValue" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="JenisLesen_SuratBatalIKLulus1" />
                    <asp:Parameter Name="JenisLesen_SuratBatalIKLulus2" />
                    <asp:Parameter Name="JenisLesen_SuratBatalIKLulus3" />
                    <asp:Parameter Name="JenisLesen_SuratBatalIKLulus4" />
                    <asp:Parameter Name="JenisLesen_SuratBatalIKGagal1" />
                    <asp:Parameter Name="JenisLesen_SuratBatalIKGagal2" />
                    <asp:SessionParameter SessionField="sessionUserName" Name="LastModID"></asp:SessionParameter>    
                    <asp:ControlParameter ControlID="GridView1" DefaultValue="" Name="JenisLesen_ID" PropertyName="SelectedValue" />                    
                </UpdateParameters>
            </asp:SqlDataSource>
                        
                    </ContentTemplate>
                </asp:TabPanel>		

            </asp:TabContainer>

            <asp:SqlDataSource ID="SqlDataSourceForm" runat="server"
                ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" 
                InsertCommand="
                INSERT INTO LESEN_JenisLesen
                (JenisLesen_Description, JenisLesen_Remarks, JenisLesen_Category,                 
                JenisLesen_IsActive, CreatorID,CreatedDt) VALUES 
                (@JenisLesen_Description, @JenisLesen_Remarks, @JenisLesen_Category, 
                @JenisLesen_IsActive, @CreatorID,getdate())"
                SelectCommand="SELECT * FROM LESEN_JenisLesen WHERE JenisLesen_ID = @JenisLesen_ID"
                UpdateCommand=
                "UPDATE LESEN_JenisLesen 
                SET JenisLesen_Description = @JenisLesen_Description, JenisLesen_Remarks = @JenisLesen_Remarks, 
                JenisLesen_Category = @JenisLesen_Category, JenisLesen_IsActive = @JenisLesen_IsActive,                
                LastModID = @LastModID, LastModDt = getdate() WHERE (JenisLesen_ID = @JenisLesen_ID)">
                <InsertParameters>

                    <asp:Parameter Name="JenisLesen_Description" />
                    <asp:Parameter Name="JenisLesen_Remarks" />
                    <asp:Parameter Name="JenisLesen_Category" />
                    <asp:Parameter Name="JenisLesen_IsActive"></asp:Parameter>
                    <asp:SessionParameter SessionField="sessionUserName" Name="CreatorID"></asp:SessionParameter>                   
                </InsertParameters>
                <SelectParameters>
                    <asp:ControlParameter ControlID="GridView1" Name="JenisLesen_ID"
                        PropertyName="SelectedValue" />
                </SelectParameters>
                <UpdateParameters>

                    <asp:Parameter Name="JenisLesen_Description" />
                    <asp:Parameter Name="JenisLesen_Remarks" />
                    <asp:Parameter Name="JenisLesen_Category" />
                    <asp:Parameter Name="JenisLesen_IsActive"></asp:Parameter>
                    <asp:SessionParameter SessionField="sessionUserName" Name="LastModID"></asp:SessionParameter>    
                    <asp:ControlParameter ControlID="GridView1" DefaultValue="" Name="JenisLesen_ID" PropertyName="SelectedValue" />                    
                </UpdateParameters>
            </asp:SqlDataSource>


            <br />
            <div class="card">
                <div class="card-body" style="overflow-x: auto;">
                        <%--# START FILTER - set SortExpression at GridView as fieldname & add WHERE 1=1 at SqlDataSource - SelectCommand #--%>
                        <div class="row">
                            <div class="col-md-10">
                                <div id="pnlFilter" runat="server" class="row"></div>
                            </div>
                            <div class="col-md-2">
                                <div class="form-group">
                                    <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-default" Text="Cari" />
                                    <asp:Button ID="btnReset" CssClass="btn btn-default" runat="server" Text="Set Semula" />
                                </div>
                            </div>
                        </div>
                        <%--# END FILTER #--%>

                        <asp:GridView ID="GridView1" runat="server" 
                        AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="JenisLesen_ID"
                        DataSourceID="SqlDataSourceGrid"
                        CssClass="table table-bordered" PagerStyle-CssClass="pgr"
                        AlternatingRowStyle-CssClass="alt" >
                        <AlternatingRowStyle CssClass="alt" />
                        <Columns>
                            <asp:BoundField DataField="JenisLesen_ID" HeaderText="ID" InsertVisible="False"
                                ReadOnly="True" SortExpression="JenisLesen_ID"  />
                            <asp:BoundField DataField="JenisLesen_Description" HeaderText="Jenis Lesen"
                                SortExpression="JenisLesen_Description"  />
                            <asp:BoundField DataField="JenisLesen_Remarks" HeaderText="Catatan"
                                SortExpression="JenisLesen_Remarks" />
        
                            <asp:TemplateField HeaderText="Kategori">
                                <ItemTemplate>
                                    <asp:Label ID="Label1" runat="server" Text='<%# If(Eval("JenisLesen_Category") = "R", "Berisiko", If(Eval("JenisLesen_Category") = "T", "Tidak Berisiko", "")) %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>                            

                            <asp:CheckBoxField DataField="JenisLesen_IsActive" HeaderText="Aktif?" SortExpression="JenisLesen_IsActive" />
                            <asp:TemplateField ShowHeader="False">
                                <ItemTemplate>
                                    <asp:LinkButton runat="server" Text="Kemaskini" CommandName="Select" CausesValidation="False" ID="LinkButton2" CssClass="btn btn-warning btn-sm"></asp:LinkButton>
                                    <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False"
                                        CommandName="Delete" Text="Nyah Aktif" OnClientClick="return confirm('Anda Pasti Untuk Nyah Aktif rekod ini?');" CssClass="btn btn-danger btn-sm"></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <PagerStyle CssClass="pgr" />
                    </asp:GridView>                    
                </div>
            </div>

        </div>
    </section>

    <asp:SqlDataSource ID="SqlDataSourceGrid" runat="server"
        ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
        SelectCommand="SELECT * from LESEN_JenisLesen WHERE 1=1 ORDER BY JenisLesen_ID"        
        DeleteCommand="Update LESEN_JenisLesen set JenisLesen_IsActive = 0 WHERE JenisLesen_ID = @JenisLesen_ID">
        <DeleteParameters>
                    <asp:ControlParameter ControlID="GridView1" DefaultValue="" Name="JenisLesen_ID" PropertyName="SelectedValue" /> 
        </DeleteParameters>

    </asp:SqlDataSource>

    <script>

        function pageLoad() {


            $(function () {

                $('.datepicker').datepicker({
                    dateFormat: 'dd/mm/yy',
                    defaultDate: new Date()
                })

                //Initialize Select2 Elements
                $('.select2').select2()

                //Initialize Select2 Elements
                $('.select2bs4').select2({
                    theme: 'bootstrap4'
                })

                //Datemask dd/mm/yyyy
                $('#datemask').inputmask('dd/mm/yyyy', { 'placeholder': 'dd/mm/yyyy' })
                //Datemask2 mm/dd/yyyy
                $('#datemask2').inputmask('mm/dd/yyyy', { 'placeholder': 'mm/dd/yyyy' })
                //Money Euro
                $('[data-mask]').inputmask()

                //Date range picker
                $('#reservationdate').datetimepicker({
                    format: 'L'
                });
                //Date range picker
                $('#reservation').daterangepicker()
                //Date range picker with time picker
                $('#reservationtime').daterangepicker({
                    timePicker: true,
                    timePickerIncrement: 30,
                    locale: {
                        format: 'MM/DD/YYYY hh:mm A'
                    }
                })
                //Date range as a button
                $('#daterange-btn').daterangepicker(
                    {
                        ranges: {
                            'Today': [moment(), moment()],
                            'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
                            'Last 7 Days': [moment().subtract(6, 'days'), moment()],
                            'Last 30 Days': [moment().subtract(29, 'days'), moment()],
                            'This Month': [moment().startOf('month'), moment().endOf('month')],
                            'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
                        },
                        startDate: moment().subtract(29, 'days'),
                        endDate: moment()
                    },
                    function (start, end) {
                        $('#reportrange span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'))
                    }
                )

                //Timepicker
                $('#timepicker').datetimepicker({
                    format: 'LT'
                })

                //Bootstrap Duallistbox
                $('.duallistbox').bootstrapDualListbox()

                //Colorpicker
                $('.my-colorpicker1').colorpicker()
                //color picker with addon
                $('.my-colorpicker2').colorpicker()

                $('.my-colorpicker2').on('colorpickerChange', function (event) {
                    $('.my-colorpicker2 .fa-square').css('color', event.color.toString());
                });

                $("input[data-bootstrap-switch]").each(function () {
                    $(this).bootstrapSwitch('state', $(this).prop('checked'));
                });

                $("#example1").DataTable({
                    "responsive": true,
                    "autoWidth": false,
                });
                $('#example2').DataTable({
                    "paging": true,
                    "lengthChange": false,
                    "searching": false,
                    "ordering": true,
                    "info": true,
                    "autoWidth": false,
                    "responsive": true,
                });
                $('.toastrDefaultSuccess').click(function () {
                    toastr.success('Lorem ipsum dolor sit amet, consetetur sadipscing elitr.')
                });


            })

        }
    </script>

</asp:Content>

