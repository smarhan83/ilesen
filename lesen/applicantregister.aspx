<%@ Page Title="" Language="VB" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="applicantregister.aspx.vb" Inherits="applicantregister" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadContent" runat="Server">

<style>
    .cssRequiredField { color: #E74C3C !important; font-size: 12px; }


    /* ---------- Cards ---------- */
    .ar-card {
        background: #fff; border: 1px solid #e9ecef; border-radius: 12px;
        box-shadow: 0 1px 3px rgba(16, 24, 40, .04);
    }

    /* ---------- Toolbar ---------- */
    .ar-toolbar {
        display: flex; flex-wrap: wrap; gap: 10px; align-items: center;
        padding: 16px 20px; border-bottom: 1px solid #e9ecef;
    }
    /* Kotak carian: border pada pembalut, ikon & input bersebelahan (tak bertindih).
       Selector .ar-toolbar .ar-search input.form-control perlu lebih kuat daripada
       .compact-form input.form-control dalam css/custom-admin.css */
    .ar-search {
        flex: 1 1 280px; display: flex; align-items: center; gap: 8px;
        background: #fff; border: 1px solid #d0d5dd; border-radius: 6px; padding: 0 12px;
        transition: all .2s ease;
    }
    .ar-search:focus-within { border-color: #3b82f6; box-shadow: 0 0 0 4px rgba(59,130,246,.15); }
    .ar-search > i { color: #adb5bd; flex-shrink: 0; }
    .ar-toolbar .ar-search input.form-control {
        flex: 1; min-width: 0; margin: 0 !important;
        border: 0 !important; box-shadow: none !important; background: transparent;
        padding: 6px 0 !important; border-radius: 0 !important;
    }
    .ar-toolbar .form-select { width: auto; min-width: 160px; }
    .ar-count { margin-left: auto; color: #6c757d; font-size: 13px; white-space: nowrap; }

    /* ---------- Table ---------- */
    .ar-table { margin: 0; width: 100%; }
    /* table-bordered diperlukan oleh skrip master (butang tindakan -> menu 3 titik); buang garisan menegak */
    .ar-table.table-bordered, .ar-table.table-bordered > :not(caption) > * { border-width: 0; }
    .ar-table.table-bordered > :not(caption) > * > * { border-width: 0 0 1px 0; border-color: #f1f3f5; }
    .ar-table th {
        background: #f8f9fa; color: #6c757d; font-size: 12px; font-weight: 600;
        text-transform: uppercase; letter-spacing: .04em;
        padding: 12px 16px; border-bottom: 1px solid #e9ecef; white-space: nowrap;
    }
    .ar-table th a { color: #6c757d; text-decoration: none; }
    .ar-table td { padding: 14px 16px; vertical-align: middle; border-bottom: 1px solid #f1f3f5; color: #212529; font-size: 14px; }
    .ar-table tr:hover td { background: #fafbff; }

    .ar-person { display: flex; align-items: center; gap: 12px; }
    .ar-avatar {
        width: 38px; height: 38px; border-radius: 50%; flex-shrink: 0;
        background: #E4DFFB; color: #2E3192; font-weight: 700;
        display: flex; align-items: center; justify-content: center;
    }
    .ar-name { font-weight: 600; line-height: 1.3; }
    .ar-muted { color: #6c757d; font-size: 12px; }
    .ar-contact { display: flex; flex-direction: column; gap: 2px; font-size: 13px; }
    .ar-contact i { color: #adb5bd; margin-right: 6px; }
    .ar-remarks { max-width: 240px; color: #6c757d; font-size: 13px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }

    .ar-badge { display: inline-flex; align-items: center; gap: 6px; padding: 4px 10px; border-radius: 999px; font-size: 12px; font-weight: 600; }
    .ar-badge::before { content: ""; width: 6px; height: 6px; border-radius: 50%; background: currentColor; }
    .ar-badge.on { background: #D4EDDA; color: #1e7e34; }
    .ar-badge.off { background: #f1f3f5; color: #6c757d; }

    .ar-actions { display: flex; gap: 6px; justify-content: flex-end; white-space: nowrap; }

    .ar-empty { text-align: center; padding: 48px 16px; color: #6c757d; }
    .ar-empty i { font-size: 40px; color: #adb5bd; display: block; margin-bottom: 10px; }

    .ar-pager td { padding: 14px 16px; border: 0; }
    .ar-pager table { margin-left: auto; }
    .ar-pager a, .ar-pager span {
        display: inline-flex; min-width: 34px; height: 34px; padding: 0 8px;
        align-items: center; justify-content: center; margin-left: 4px;
        border-radius: 8px; border: 1px solid #dee2e6; color: #495057;
        text-decoration: none; font-size: 13px;
    }
    .ar-pager span { background: #2E3192; border-color: #2E3192; color: #fff; font-weight: 600; }
    .ar-pager a:hover { background: #f1f3f5; }

    /* ---------- Form ---------- */
    .ar-form-head {
        display: flex; justify-content: space-between; align-items: center;
        padding: 18px 24px; border-bottom: 1px solid #e9ecef;
    }
    .ar-form-head h3 { font-size: 17px; font-weight: 700; margin: 0; }
    .ar-form-body { padding: 8px 24px 4px; }
    .ar-section { padding: 18px 0; border-bottom: 1px dashed #e9ecef; }
    .ar-section:last-child { border-bottom: 0; }
    .ar-section-title {
        font-size: 13px; font-weight: 700; color: #2E3192; text-transform: uppercase;
        letter-spacing: .05em; margin-bottom: 14px; display: flex; align-items: center; gap: 8px;
    }
    .ar-form-body label { font-size: 13px; font-weight: 600; color: #495057; margin-bottom: 6px; }
    .ar-form-body .req { color: #E74C3C; }
    .ar-form-body .form-control { border-radius: 8px; }
    .ar-form-foot {
        display: flex; justify-content: flex-start; gap: 8px;
        padding: 16px 24px; background: #f8f9fa; border-top: 1px solid #e9ecef;
        border-radius: 0 0 12px 12px;
    }
    .ar-switch { display: flex; align-items: center; gap: 10px; }
    .ar-switch input { width: 18px; height: 18px; }
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

            <!-- ===== Senarai ===== -->
            <asp:Panel ID="pnlList" runat="server" CssClass="ar-card" DefaultButton="btnSearch">

                <div class="ar-toolbar">
                    <div class="ar-search">
                        <i class="bi bi-search"></i>
                        <asp:TextBox ID="txtCarian" runat="server" CssClass="form-control"
                            placeholder="Cari nama, no. KP, passport, telefon atau emel" />
                    </div>
                    <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select" AutoPostBack="true">
                        <asp:ListItem Value="">Semua status</asp:ListItem>
                        <asp:ListItem Value="1">Aktif</asp:ListItem>
                        <asp:ListItem Value="0">Tidak aktif</asp:ListItem>
                    </asp:DropDownList>
                    <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-default" Text="Cari" CausesValidation="False" />
                    <asp:Button ID="btnReset" runat="server" CssClass="btn btn-default" Text="Set Semula" CausesValidation="False" />
                    <span class="ar-count"><asp:Literal ID="litJumlah" runat="server" /></span>
                    <asp:LinkButton ID="btnTambah" runat="server" CssClass="btn btn-primary" CausesValidation="False" Text="Tambah" />
                </div>

                <div class="table-responsive">
                    <asp:GridView ID="GridView1" runat="server"
                        AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="Pemohon_ID"
                        DataSourceID="SqlDataSourceGrid" GridLines="None"
                        CssClass="ar-table table-bordered" PagerStyle-CssClass="ar-pager"
                        AllowPaging="True" PageSize="20">
                        <PagerSettings Mode="NumericFirstLast" PageButtonCount="5" FirstPageText="&laquo;" LastPageText="&raquo;" />
                        <Columns>
                            <asp:TemplateField HeaderText="Pemohon" SortExpression="Pemohon_Name">
                                <ItemTemplate>
                                    <div class="ar-person">
                                        <div class="ar-avatar"><%# GetInitial(Eval("Pemohon_Name")) %></div>
                                        <div>
                                            <div class="ar-name"><asp:Label ID="lblNama" runat="server" Text='<%# Eval("Pemohon_Name") %>' /></div>
                                            <div class="ar-muted">ID #<%# Eval("Pemohon_ID") %></div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="No. Pengenalan" SortExpression="Pemohon_ICNo">
                                <ItemTemplate>
                                    <div><%# If(String.IsNullOrWhiteSpace(Convert.ToString(Eval("Pemohon_ICNo"))), "-", Eval("Pemohon_ICNo")) %></div>
                                    <div class="ar-muted" runat="server" visible='<%# Not String.IsNullOrWhiteSpace(Convert.ToString(Eval("Pemohon_PassportNo"))) %>'>
                                        Passport: <%# Eval("Pemohon_PassportNo") %>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Hubungi" SortExpression="Pemohon_MobileNo">
                                <ItemTemplate>
                                    <div class="ar-contact">
                                        <span><i class="bi bi-telephone"></i><%# If(String.IsNullOrWhiteSpace(Convert.ToString(Eval("Pemohon_MobileNo"))), "-", Eval("Pemohon_MobileNo")) %></span>
                                        <span class="ar-muted"><i class="bi bi-envelope"></i><%# If(String.IsNullOrWhiteSpace(Convert.ToString(Eval("Pemohon_Email"))), "-", Eval("Pemohon_Email")) %></span>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Catatan" SortExpression="Pemohon_Remarks"
                                HeaderStyle-CssClass="d-none d-lg-table-cell" ItemStyle-CssClass="d-none d-lg-table-cell">
                                <ItemTemplate>
                                    <div class="ar-remarks" title='<%# Eval("Pemohon_Remarks") %>'><%# Eval("Pemohon_Remarks") %></div>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Status" SortExpression="Pemohon_IsActive">
                                <ItemTemplate>
                                    <span class='ar-badge <%# If(IsAktif(Eval("Pemohon_IsActive")), "on", "off") %>'>
                                        <%# If(IsAktif(Eval("Pemohon_IsActive")), "Aktif", "Tidak aktif") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="">
                                <ItemTemplate>
                                    <div class="ar-actions">
                                        <asp:LinkButton runat="server" Text="Kemaskini" CommandName="Select" CausesValidation="False" ID="LinkButton2" CssClass="btn btn-warning btn-sm" />
                                        <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Delete"
                                            Visible='<%# IsAktif(Eval("Pemohon_IsActive")) %>'
                                            OnClientClick="return confirm('Anda pasti untuk nyah aktif rekod ini?');"
                                            Text="Nyah Aktif" CssClass="btn btn-danger btn-sm" />
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="ar-empty">
                                <i class="bi bi-people"></i>
                                Tiada rekod pemohon dijumpai.
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </asp:Panel>

            <!-- ===== Borang Tambah / Kemaskini ===== -->
            <asp:Panel ID="pnlForm" runat="server" Visible="false">

            <asp:FormView ID="FormView1" runat="server" DataKeyNames="Pemohon_ID"
                DataSourceID="SqlDataSourceForm" DefaultMode="Insert" RenderOuterTable="false">
                <EditItemTemplate>
                    <div class="ar-card">
                        <div class="ar-form-head">
                            <h3><div runat="server" id="idWindowTitle2">Kemaskini</div></h3>
                            <span class="ar-muted">ID #<%# Eval("Pemohon_ID") %></span>
                        </div>
                        <div class="ar-form-body">

                            <div class="ar-section">
                                <div class="ar-section-title"><i class="bi bi-person-vcard"></i> Maklumat Peribadi</div>
                                <div class="row g-3">
                                    <div class="col-md-12">
                                        <label>Nama Pemohon <span class="req">*</span></label>
                                        <asp:TextBox ID="txtPemohon_Name" runat="server" Text='<%# Bind("Pemohon_Name") %>' CssClass="form-control" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" CssClass="cssRequiredField"
                                            ControlToValidate="txtPemohon_Name" ErrorMessage="Sila isi nama pemohon" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="col-md-4">
                                        <label>Warganegara <span class="req">*</span></label>
                                        <asp:DropDownList ID="ddlPemohon_Nationality" Text='<%# Bind("Pemohon_Nationality") %>' CssClass="form-control select2" runat="server"
                                            DataSourceID="SqlDataSourceNationality" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourceNationality" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            SelectCommand="select * from
                                            (select NULL as id, '-- Sila Pilih --' as name
                                            union all
                                            select id,name from TBL_LOOKUPS where lookupgrp_id = (select x.id from TBL_LOOKUPGRPS x where x.name = 'CITIZENSHIP')
                                            ) as tbl1 order by name ">
                                        </asp:SqlDataSource>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" CssClass="cssRequiredField"
                                            ControlToValidate="ddlPemohon_Nationality" ErrorMessage="Sila pilih warganegara" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="col-md-4">
                                        <label>No. Kad Pengenalan</label>
                                        <asp:TextBox ID="txtPemohon_ICNo" runat="server" Text='<%# Bind("Pemohon_ICNo") %>' CssClass="form-control" />
                                    </div>
                                    <div class="col-md-4">
                                        <label>No. Passport</label>
                                        <asp:TextBox ID="txtPemohon_PassportNo" runat="server" Text='<%# Bind("Pemohon_PassportNo") %>' CssClass="form-control" />
                                    </div>
                                    <div class="col-md-4">
                                        <label>Jantina</label>
                                        <asp:DropDownList ID="ddlPemohon_Gender" runat="server" SelectedValue='<%# Bind("Pemohon_Gender") %>' CssClass="form-control select2">
                                            <asp:ListItem Value="A">-- Sila Pilih --</asp:ListItem>
                                            <asp:ListItem Value="L">Lelaki</asp:ListItem>
                                            <asp:ListItem Value="P">Perempuan</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                    <div class="col-md-4">
                                        <label>Bangsa</label>
                                        <asp:DropDownList ID="ddlPemohon_Race" Text='<%# Bind("Pemohon_Race") %>' CssClass="form-control select2" runat="server"
                                            DataSourceID="SqlDataSourceRace" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourceRace" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            SelectCommand="select * from
                                            (select NULL as id, '-- Sila Pilih --' as name
                                            union all
                                            select id,name from TBL_LOOKUPS where lookupgrp_id = (select x.id from TBL_LOOKUPGRPS x where x.name = 'RACE')
                                            ) as tbl1 order by name ">
                                        </asp:SqlDataSource>
                                    </div>
                                    <div class="col-md-4">
                                        <label>Status Perkahwinan</label>
                                        <asp:DropDownList ID="ddlPemohon_Marital" Text='<%# Bind("Pemohon_Marital") %>' CssClass="form-control select2" runat="server"
                                            DataSourceID="SqlDataSourceMarital" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourceMarital" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            SelectCommand="select * from
                                            (select NULL as id, '-- Sila Pilih --' as name
                                            union all
                                            select id,name from TBL_LOOKUPS where lookupgrp_id = (select x.id from TBL_LOOKUPGRPS x where x.name = 'MARITAL STATUS')
                                            ) as tbl1 order by name ">
                                        </asp:SqlDataSource>
                                    </div>
                                </div>
                            </div>

                            <div class="ar-section">
                                <div class="ar-section-title"><i class="bi bi-geo-alt"></i> Hubungan &amp; Alamat</div>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label>No. Telefon Bimbit</label>
                                        <asp:TextBox ID="txtPemohon_MobileNo" runat="server" Text='<%# Bind("Pemohon_MobileNo") %>' CssClass="form-control" />
                                    </div>
                                    <div class="col-md-6">
                                        <label>Emel</label>
                                        <asp:TextBox ID="txtPemohon_Email" runat="server" Text='<%# Bind("Pemohon_Email") %>' CssClass="form-control" />
                                    </div>
                                    <div class="col-md-8">
                                        <label>Alamat <span class="req">*</span></label>
                                        <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("Pemohon_Address") %>' CssClass="form-control" TextMode="MultiLine" Rows="3" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" CssClass="cssRequiredField"
                                            ControlToValidate="TextBox2" ErrorMessage="Sila isi alamat" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="col-md-4">
                                        <label>Negeri</label>
                                        <asp:DropDownList ID="ddlPemohon_State" Text='<%# Bind("Pemohon_State") %>' CssClass="form-control select2" runat="server"
                                            DataSourceID="SqlDataSourceState" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourceState" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            SelectCommand="select * from
                                            (select NULL as id, '-- Sila Pilih --' as name
                                            union all
                                            select id,name from TBL_LOOKUPS where lookupgrp_id = (select x.id from TBL_LOOKUPGRPS x where x.name = 'STATE')
                                            ) as tbl1 order by name ">
                                        </asp:SqlDataSource>
                                    </div>
                                </div>
                            </div>

                            <div class="ar-section">
                                <div class="ar-section-title"><i class="bi bi-shop"></i> Maklumat Jualan</div>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label>Jenis Jualan</label>
                                        <asp:TextBox ID="txtPemohon_JenisJualan" runat="server" Text='<%# Bind("Pemohon_JenisJualan") %>' CssClass="form-control" />
                                    </div>
                                    <div class="col-md-6">
                                        <label>Masa Jualan</label>
                                        <asp:TextBox ID="txtPemohon_MasaJualan" runat="server" Text='<%# Bind("Pemohon_MasaJualan") %>' CssClass="form-control" />
                                    </div>
                                </div>
                            </div>

                            <div class="ar-section">
                                <div class="ar-section-title"><i class="bi bi-gear"></i> Tetapan</div>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label>Pengguna Sistem</label>
                                        <asp:DropDownList ID="ddlPemohon_PIC" Text='<%# Bind("Pemohon_PIC") %>' CssClass="form-control select2" runat="server"
                                            DataSourceID="SqlDataSourcePIC" DataTextField="Users_Name" DataValueField="Users_id"></asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourcePIC" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            SelectCommand="select * from
                                            (select NULL as Users_id, '-- Sila Pilih --' as Users_Name
                                            union all
                                            select Users_id,  Users_Name from TBL_USERS where Users_Register=1 and Users_Enabled=1
                                            ) as tbl1 order by Users_Name ">
                                        </asp:SqlDataSource>
                                    </div>
                                    <div class="col-md-6">
                                        <label>Status</label>
                                        <div class="ar-switch">
                                            <asp:CheckBox ID="CheckBox2" runat="server" Checked='<%# Bind("Pemohon_IsActive") %>' Text="Aktif" />
                                        </div>
                                    </div>
                                    <div class="col-md-12">
                                        <label>Catatan</label>
                                        <asp:TextBox ID="txtPemohon_Remarks" runat="server" Text='<%# Bind("Pemohon_Remarks") %>' CssClass="form-control" TextMode="MultiLine" Rows="2" />
                                    </div>
                                </div>
                            </div>

                        </div>
                        <div class="ar-form-foot">
                            <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" CommandName="Update" Text="Kemaskini" ValidationGroup="frmEdit" CssClass="btn btn-warning" />
                            <asp:LinkButton ID="UpdateCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Batal" CssClass="btn btn-default" />
                        </div>
                    </div>
                </EditItemTemplate>

                <InsertItemTemplate>
                    <div class="ar-card">
                        <div class="ar-form-head">
                            <h3><div runat="server" id="idWindowTitle3">Tambah</div></h3>
                            <span class="ar-muted"><span class="req" style="color:#E74C3C">*</span> Wajib diisi</span>
                        </div>
                        <div class="ar-form-body">

                            <div class="ar-section">
                                <div class="ar-section-title"><i class="bi bi-person-vcard"></i> Maklumat Peribadi</div>
                                <div class="row g-3">
                                    <div class="col-md-12">
                                        <label>Nama Pemohon <span class="req">*</span></label>
                                        <asp:TextBox ID="txtPemohon_Name" runat="server" Text='<%# Bind("Pemohon_Name") %>' CssClass="form-control" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" CssClass="cssRequiredField"
                                            ControlToValidate="txtPemohon_Name" ErrorMessage="Sila isi nama pemohon" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="col-md-4">
                                        <label>Warganegara <span class="req">*</span></label>
                                        <asp:DropDownList ID="ddlPemohon_Nationality" Text='<%# Bind("Pemohon_Nationality") %>' CssClass="form-control select2" runat="server"
                                            DataSourceID="SqlDataSourceNationality" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourceNationality" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            SelectCommand="select * from
                                            (select NULL as id, '-- Sila Pilih --' as name
                                            union all
                                            select id,name from TBL_LOOKUPS where lookupgrp_id = (select x.id from TBL_LOOKUPGRPS x where x.name = 'CITIZENSHIP')
                                            ) as tbl1 order by name ">
                                        </asp:SqlDataSource>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" CssClass="cssRequiredField"
                                            ControlToValidate="ddlPemohon_Nationality" ErrorMessage="Sila pilih warganegara" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="col-md-4">
                                        <label>No. Kad Pengenalan</label>
                                        <asp:TextBox ID="txtPemohon_ICNo" runat="server" Text='<%# Bind("Pemohon_ICNo") %>' CssClass="form-control" />
                                    </div>
                                    <div class="col-md-4">
                                        <label>No. Passport</label>
                                        <asp:TextBox ID="txtPemohon_PassportNo" runat="server" Text='<%# Bind("Pemohon_PassportNo") %>' CssClass="form-control" />
                                    </div>
                                    <div class="col-md-4">
                                        <label>Jantina</label>
                                        <asp:DropDownList ID="ddlPemohon_Gender" runat="server" SelectedValue='<%# Bind("Pemohon_Gender") %>' CssClass="form-control select2">
                                            <asp:ListItem Value="A">-- Sila Pilih --</asp:ListItem>
                                            <asp:ListItem Value="L">Lelaki</asp:ListItem>
                                            <asp:ListItem Value="P">Perempuan</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                    <div class="col-md-4">
                                        <label>Bangsa</label>
                                        <asp:DropDownList ID="ddlPemohon_Race" Text='<%# Bind("Pemohon_Race") %>' CssClass="form-control select2" runat="server"
                                            DataSourceID="SqlDataSourceRace" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourceRace" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            SelectCommand="select * from
                                            (select NULL as id, '-- Sila Pilih --' as name
                                            union all
                                            select id,name from TBL_LOOKUPS where lookupgrp_id = (select x.id from TBL_LOOKUPGRPS x where x.name = 'RACE')
                                            ) as tbl1 order by name ">
                                        </asp:SqlDataSource>
                                    </div>
                                    <div class="col-md-4">
                                        <label>Status Perkahwinan</label>
                                        <asp:DropDownList ID="ddlPemohon_Marital" Text='<%# Bind("Pemohon_Marital") %>' CssClass="form-control select2" runat="server"
                                            DataSourceID="SqlDataSourceMarital" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourceMarital" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            SelectCommand="select * from
                                            (select NULL as id, '-- Sila Pilih --' as name
                                            union all
                                            select id,name from TBL_LOOKUPS where lookupgrp_id = (select x.id from TBL_LOOKUPGRPS x where x.name = 'MARITAL STATUS')
                                            ) as tbl1 order by name ">
                                        </asp:SqlDataSource>
                                    </div>
                                </div>
                            </div>

                            <div class="ar-section">
                                <div class="ar-section-title"><i class="bi bi-geo-alt"></i> Hubungan &amp; Alamat</div>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label>No. Telefon Bimbit</label>
                                        <asp:TextBox ID="txtPemohon_MobileNo" runat="server" Text='<%# Bind("Pemohon_MobileNo") %>' CssClass="form-control" />
                                    </div>
                                    <div class="col-md-6">
                                        <label>Emel</label>
                                        <asp:TextBox ID="txtPemohon_Email" runat="server" Text='<%# Bind("Pemohon_Email") %>' CssClass="form-control" />
                                    </div>
                                    <div class="col-md-8">
                                        <label>Alamat <span class="req">*</span></label>
                                        <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("Pemohon_Address") %>' CssClass="form-control" TextMode="MultiLine" Rows="3" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" CssClass="cssRequiredField"
                                            ControlToValidate="TextBox2" ErrorMessage="Sila isi alamat" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="col-md-4">
                                        <label>Negeri</label>
                                        <asp:DropDownList ID="ddlPemohon_State" Text='<%# Bind("Pemohon_State") %>' CssClass="form-control select2" runat="server"
                                            DataSourceID="SqlDataSourceState" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourceState" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            SelectCommand="select * from
                                            (select NULL as id, '-- Sila Pilih --' as name
                                            union all
                                            select id,name from TBL_LOOKUPS where lookupgrp_id = (select x.id from TBL_LOOKUPGRPS x where x.name = 'STATE')
                                            ) as tbl1 order by name ">
                                        </asp:SqlDataSource>
                                    </div>
                                </div>
                            </div>

                            <div class="ar-section">
                                <div class="ar-section-title"><i class="bi bi-shop"></i> Maklumat Jualan</div>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label>Jenis Jualan</label>
                                        <asp:TextBox ID="txtPemohon_JenisJualan" runat="server" Text='<%# Bind("Pemohon_JenisJualan") %>' CssClass="form-control" />
                                    </div>
                                    <div class="col-md-6">
                                        <label>Masa Jualan</label>
                                        <asp:TextBox ID="txtPemohon_MasaJualan" runat="server" Text='<%# Bind("Pemohon_MasaJualan") %>' CssClass="form-control" />
                                    </div>
                                </div>
                            </div>

                            <div class="ar-section">
                                <div class="ar-section-title"><i class="bi bi-gear"></i> Tetapan</div>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label>Pengguna Sistem</label>
                                        <asp:DropDownList ID="ddlPemohon_PIC" Text='<%# Bind("Pemohon_PIC") %>' CssClass="form-control select2" runat="server"
                                            DataSourceID="SqlDataSourcePIC" DataTextField="Users_Name" DataValueField="Users_id"></asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourcePIC" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            SelectCommand="select * from
                                            (select NULL as Users_id, '-- Sila Pilih --' as Users_Name
                                            union all
                                            select Users_id,  Users_Name from TBL_USERS where Users_Register=1 and Users_Enabled=1
                                            ) as tbl1 order by Users_Name ">
                                        </asp:SqlDataSource>
                                    </div>
                                    <div class="col-md-6">
                                        <label>Status</label>
                                        <div class="ar-switch">
                                            <asp:CheckBox ID="CheckBox2" runat="server" Checked='<%# Bind("Pemohon_IsActive") %>' Text="Aktif" />
                                        </div>
                                    </div>
                                    <div class="col-md-12">
                                        <label>Catatan</label>
                                        <asp:TextBox ID="txtPemohon_Remarks" runat="server" Text='<%# Bind("Pemohon_Remarks") %>' CssClass="form-control" TextMode="MultiLine" Rows="2" />
                                    </div>
                                </div>
                            </div>

                        </div>
                        <div class="ar-form-foot">
                            <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" Text="Kunci Masuk" ValidationGroup="frmEdit" CssClass="btn btn-primary" />
                            <asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Batal" CssClass="btn btn-default" />
                        </div>
                    </div>
                </InsertItemTemplate>
            </asp:FormView>

            </asp:Panel>

            <asp:SqlDataSource ID="SqlDataSourceForm" runat="server"
                ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                InsertCommand="
                INSERT INTO LESEN_Pemohon
                (Pemohon_Name, Pemohon_Remarks, Pemohon_Address, Pemohon_Nationality, Pemohon_ICNo, Pemohon_PassportNo, Pemohon_Email,
                Pemohon_MobileNo, Pemohon_TelNo, Pemohon_State, Pemohon_Race, Pemohon_Marital, Pemohon_Gender,
                Pemohon_JenisJualan, Pemohon_MasaJualan, Pemohon_PIC,
                Pemohon_IsActive, CreatorID,CreatedDt) VALUES
                (@Pemohon_Name, @Pemohon_Remarks, @Pemohon_Address, @Pemohon_Nationality, @Pemohon_ICNo, @Pemohon_PassportNo, @Pemohon_Email,
                @Pemohon_MobileNo, @Pemohon_TelNo, @Pemohon_State, @Pemohon_Race, @Pemohon_Marital, @Pemohon_Gender,
                @Pemohon_JenisJualan, @Pemohon_MasaJualan, @Pemohon_PIC,
                @Pemohon_IsActive, @CreatorID,getdate())"
                SelectCommand="SELECT * FROM LESEN_Pemohon WHERE Pemohon_ID = @Pemohon_ID"
                UpdateCommand=
                "UPDATE LESEN_Pemohon
                SET Pemohon_Name = @Pemohon_Name, Pemohon_Remarks = @Pemohon_Remarks,
                Pemohon_Address = @Pemohon_Address, Pemohon_Nationality = @Pemohon_Nationality, Pemohon_ICNo = @Pemohon_ICNo,
                Pemohon_PassportNo = @Pemohon_PassportNo, Pemohon_Email = @Pemohon_Email, Pemohon_MobileNo = @Pemohon_MobileNo,
                Pemohon_TelNo = @Pemohon_TelNo, Pemohon_State = @Pemohon_State, Pemohon_Race = @Pemohon_Race, Pemohon_Marital = @Pemohon_Marital,
                Pemohon_Gender = @Pemohon_Gender, Pemohon_JenisJualan = @Pemohon_JenisJualan, Pemohon_MasaJualan = @Pemohon_MasaJualan,
                Pemohon_PIC = @Pemohon_PIC,
                Pemohon_IsActive = @Pemohon_IsActive,
                LastModID = @LastModID, LastModDt = getdate() WHERE (Pemohon_ID = @Pemohon_ID)">
                <InsertParameters>
                    <asp:Parameter Name="Pemohon_Name" />
                    <asp:Parameter Name="Pemohon_Remarks" />
                    <asp:Parameter Name="Pemohon_Address" />
                    <asp:Parameter Name="Pemohon_Nationality" />
                    <asp:Parameter Name="Pemohon_ICNo" />
                    <asp:Parameter Name="Pemohon_PassportNo" />
                    <asp:Parameter Name="Pemohon_Email" />
                    <asp:Parameter Name="Pemohon_MobileNo" />
                    <asp:Parameter Name="Pemohon_TelNo" />
                    <asp:Parameter Name="Pemohon_Race" />
                    <asp:Parameter Name="Pemohon_State" />
                    <asp:Parameter Name="Pemohon_Marital" />
                    <asp:Parameter Name="Pemohon_Gender" />
                    <asp:Parameter Name="Pemohon_JenisJualan" />
                    <asp:Parameter Name="Pemohon_MasaJualan" />
                    <asp:Parameter Name="Pemohon_PIC" />
                    <asp:Parameter Name="Pemohon_IsActive"></asp:Parameter>
                    <asp:SessionParameter SessionField="sessionUserName" Name="CreatorID"></asp:SessionParameter>
                </InsertParameters>
                <SelectParameters>
                    <asp:ControlParameter ControlID="GridView1" Name="Pemohon_ID"
                        PropertyName="SelectedValue" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="Pemohon_Name" />
                    <asp:Parameter Name="Pemohon_Remarks" />
                    <asp:Parameter Name="Pemohon_Address" />
                    <asp:Parameter Name="Pemohon_Nationality" />
                    <asp:Parameter Name="Pemohon_ICNo" />
                    <asp:Parameter Name="Pemohon_PassportNo" />
                    <asp:Parameter Name="Pemohon_Email" />
                    <asp:Parameter Name="Pemohon_MobileNo" />
                    <asp:Parameter Name="Pemohon_TelNo" />
                    <asp:Parameter Name="Pemohon_Race" />
                    <asp:Parameter Name="Pemohon_State" />
                    <asp:Parameter Name="Pemohon_Marital" />
                    <asp:Parameter Name="Pemohon_Gender" />
                    <asp:Parameter Name="Pemohon_JenisJualan" />
                    <asp:Parameter Name="Pemohon_MasaJualan" />
                    <asp:Parameter Name="Pemohon_PIC" />
                    <asp:Parameter Name="Pemohon_IsActive"></asp:Parameter>
                    <asp:SessionParameter SessionField="sessionUserName" Name="LastModID"></asp:SessionParameter>
                    <asp:ControlParameter ControlID="GridView1" DefaultValue="" Name="Pemohon_ID" PropertyName="SelectedValue" />
                </UpdateParameters>
            </asp:SqlDataSource>

        </div>
    </section>

    <asp:SqlDataSource ID="SqlDataSourceGrid" runat="server"
        ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
        SelectCommand="SELECT * FROM LESEN_Pemohon
            WHERE (@Carian = '' OR Pemohon_Name LIKE '%' + @Carian + '%' OR Pemohon_ICNo LIKE '%' + @Carian + '%'
                   OR Pemohon_PassportNo LIKE '%' + @Carian + '%' OR Pemohon_MobileNo LIKE '%' + @Carian + '%'
                   OR Pemohon_Email LIKE '%' + @Carian + '%')
            AND (@Status = '' OR ISNULL(Pemohon_IsActive, 0) = CASE WHEN @Status = '1' THEN 1 ELSE 0 END)
            ORDER BY Pemohon_ID DESC"
        DeleteCommand="Update LESEN_Pemohon set Pemohon_IsActive = 0 WHERE Pemohon_ID = @Pemohon_ID">
        <SelectParameters>
            <asp:ControlParameter ControlID="txtCarian" PropertyName="Text" Name="Carian" DefaultValue="" ConvertEmptyStringToNull="false" />
            <asp:ControlParameter ControlID="ddlStatus" PropertyName="SelectedValue" Name="Status" DefaultValue="" ConvertEmptyStringToNull="false" />
        </SelectParameters>
        <DeleteParameters>
            <asp:ControlParameter ControlID="GridView1" DefaultValue="" Name="Pemohon_ID" PropertyName="SelectedValue" />
        </DeleteParameters>
    </asp:SqlDataSource>

    <script>
        function pageLoad() {
            $('.select2').select2({ width: '100%', dropdownAutoWidth: true });
        }
    </script>

<script type="text/javascript">
    function WebForm_OnSubmit() {
        if (typeof (ValidatorOnSubmit) == "function" && ValidatorOnSubmit() == false) {
            for (var i in Page_Validators) {
                try {
                    if (!Page_Validators[i].isvalid) {
                        var control = $("#" + Page_Validators[i].controltovalidate);

                        var top = control.offset().top;
                        $('html, body').animate({ scrollTop: top - 10 }, 800);
                        control.focus();
                        return;
                    }
                } catch (e) { }
            }
            return false;
        }
        return true;
    }
</script>

</asp:Content>
