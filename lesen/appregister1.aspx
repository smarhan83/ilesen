<%@ Page MaintainScrollPositionOnPostback="true" Title="" Language="VB" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="appregister1.aspx.vb" Inherits="appregister1" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadContent" runat="Server">
        <style>
        .ajax__scroll_none {
            overflow: visible !important;
        }

        /* Tooltip Styling */
        .wrapperTooltip {
            cursor: help;
            position: relative;
            text-align: center;
            width: 100%;
            -webkit-transform: translateZ(0);
            -webkit-font-smoothing: antialiased;
            z-index: 9999999 !important;
        }

        .wrapperTooltip .tooltip {
            background: #1496bb;
            bottom: 100%;
            color: #fff;
            display: block;
            left: -20px;
            margin-bottom: 15px;
            opacity: 0;
            padding: 20px;
            pointer-events: none;
            position: absolute;
            width: 100%;
            box-shadow: 2px 2px 6px rgba(0, 0, 0, 0.28);
            z-index: 9999999 !important;
            transition: opacity 0.25s ease-out;
        }

        .wrapperTooltip .tooltip:before {
            bottom: -20px;
            content: " ";
            display: block;
            left: 0;
            position: absolute;
            width: 100%;
            z-index: 9999999 !important;
        }

        .wrapperTooltip .tooltip:after {
            border-left: solid transparent 10px;
            border-right: solid transparent 10px;
            border-top: solid #1496bb 10px;
            bottom: -10px;
            content: " ";
            height: 0;
            left: 50%;
            margin-left: -13px;
            position: absolute;
            width: 0;
            z-index: 9999999 !important;
        }

        .wrapperTooltip:hover .tooltip {
            opacity: 1;
            pointer-events: auto;
            z-index: 9999999 !important;
        }

        .Disabled {
            pointer-events: none;
            cursor: not-allowed;
            opacity: 0.65;
            box-shadow: none;
        }

        /* AjaxControlToolkit TabContainer Custom Styling */
        .ajax__tab_xp .ajax__tab_header,
        .ajax__tab_xp .ajax__tab_header .ajax__tab_outer,
        .ajax__tab_xp .ajax__tab_header .ajax__tab_inner,
        .ajax__tab_xp .ajax__tab_header .ajax__tab_tab,
        .ajax__tab_xp .ajax__tab_header_verticalleft,
        .ajax__tab_xp .ajax__tab_header_verticalright,
        .ajax__tab_xp .ajax__tab_header_bottom {
            background-image: none !important;
        }

        .ajax__tab_xp .ajax__tab_header {
            font-size: 11pt !important;
            height: 40px !important;
            color: #000 !important;
        }

        .ajax__tab_xp .ajax__tab_header .ajax__tab_inner {
            background-color: #E9ECEF !important;
            width: 150px !important;
            text-align: center !important;
            vertical-align: middle !important;
            border-top-right-radius: 10px !important;
            border-top-left-radius: 10px !important;
        }

        .ajax__tab_xp .ajax__tab_header .ajax__tab_inner a {
            color: #413a3a !important;
        }

        .ajax__tab_xp .ajax__tab_header .ajax__tab_active .ajax__tab_inner {
            background-color: #ffc107 !important;
            width: 150px !important;
            text-align: center !important;
            vertical-align: middle !important;
            border-top-right-radius: 10px !important;
            border-top-left-radius: 10px !important;
        }

        .ajax__tab_xp .ajax__tab_header .ajax__tab_active .ajax__tab_inner a {
            color: #fff !important;
            font-weight: 600 !important;
        }

        .styleDisplayNone {
            display: none;
        }

        .table-bordered {
            text-align: center;
        }

        /* Status Pills */
        .status-pill {
            display: inline-flex;
            align-items: flex-start;
            min-width: 190px;
            padding: 10px 12px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 13px;
            text-align: left;
        }

        .status-pill-icon {
            margin: 2px 10px 0 0;
            font-size: 15px;
            line-height: 1;
        }

        .status-pill-content {
            display: block;
        }

        .status-pill-label {
            display: block;
            line-height: 1.25;
        }

        .status-pill-description {
            display: block;
            margin-top: 3px;
            color: #6c757d;
            font-size: 11px;
            font-weight: 400;
            line-height: 1.25;
        }

        .status-pill-sent {
            background-color: #e7f8ee;
            color: #1e9e57;
        }

        .status-pill-pending {
            background-color: #fdf3dd;
            color: #d99b1f;
        }

        .status-pill-notrequired {
            background-color: #f0f1f4;
            color: #6f7786;
        }

        /* QR Code Card */
        .qr-box {
            width: 225px;
            height: 90px;
            border: 1px solid #d5d5d5;
            background-color: #fff;
            display: flex;
            align-items: center;
            padding: 10px;
            text-decoration: none !important;
            color: inherit !important;
            border-radius: 2px;
        }

        .qr-box:hover {
            background-color: #f8f8f8;
        }

        .qr-icon {
            width: 75px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .qr-icon i {
            font-size: 65px;
            line-height: 1;
        }

        .qr-text {
            padding-left: 8px;
        }

        .qr-title {
            font-weight: 600;
            font-size: 13px;
            margin-bottom: 5px;
        }

        .qr-description {
            font-size: 11px;
            line-height: 1.4;
            color: #555;
        }

        /* Banting Location List */
        .banting-lokasi-list {
            width: 100% !important;
            border: none !important;
            box-shadow: none !important;
        }
        .banting-lokasi-list > tbody > tr > td {
            border: none !important;
            padding: 0 !important;
            background: transparent !important;
            box-shadow: none !important;
        }
        .banting-lokasi-list .card {
            box-shadow: none !important;
        }

        /* Status Proses Timeline */
        .status-proses-card {
            background: #fff;
            border: 1px solid #e9ecef;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }

        .status-proses-title {
            font-size: 9pt;
            font-weight: 700;
            letter-spacing: 0.5px;
            color: #2E3192;
            text-transform: uppercase;
            margin-bottom: 20px;
        }

        .status-timeline {
            position: relative;
            padding-left: 8px;
        }

        .status-step {
            position: relative;
            padding-left: 34px;
            padding-bottom: 24px;
        }

        .status-step:last-child {
            padding-bottom: 0;
        }

        .status-step::before {
            content: '';
            position: absolute;
            left: 11px;
            top: 26px;
            bottom: -2px;
            width: 2px;
            background: #e9ecef;
        }

        .status-step:last-child::before {
            display: none;
        }

        .status-step.done::before {
            background: #28a745;
        }

        .status-step-icon {
            position: absolute;
            left: 0;
            top: 0;
            width: 24px;
            height: 24px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            color: #fff;
            background: #dee2e6;
            z-index: 1;
        }

        .status-step.done .status-step-icon {
            background: #28a745;
        }

        .status-step.current .status-step-icon {
            background: #2E3192;
            box-shadow: 0 0 0 4px rgba(46, 49, 146, 0.15);
        }

        .status-step.pending .status-step-icon {
            background: #fff;
            border: 2px solid #dee2e6;
        }

        .status-step-title {
            font-weight: 700;
            font-size: 9.5pt;
            color: #212529;
            margin-bottom: 3px;
        }

        .status-step.pending .status-step-title {
            color: #adb5bd;
            font-weight: 600;
        }

        .status-step-date {
            font-size: 8pt;
            color: #6c757d;
        }

        .status-step.current .status-step-date {
            color: #2E3192;
            font-weight: 600;
        }

        .status-step.pending .status-step-date {
            color: #adb5bd;
        }

        .status-step-agensi {
            font-size: 8pt;
            color: #6c757d;
            margin-top: 3px;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .status-step-agensi i {
            font-size: 9pt;
            color: #adb5bd;
        }

        .status-step-actionby {
            font-size: 8pt;
            font-weight: 600;
            color: #495057;
            margin-top: 4px;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .status-step-actionby i {
            font-size: 9pt;
            color: #2E3192;
        }

        .status-step.current .status-step-actionby {
            color: #2E3192;
        }

        .status-step.pending .status-step-agensi,
        .status-step.pending .status-step-actionby {
            color: #adb5bd;
        }

        /* =========================================================================
           Data Entry Form Styling Enhancements
           ========================================================================= */
        .form-section-header {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 0.95rem;
            font-weight: 700;
            color: #1e3a8a;
            background: linear-gradient(90deg, #f0f4f9 0%, #f8fafc 100%);
            padding: 9px 15px;
            border-radius: 8px;
            border-left: 4px solid #2D6CDF;
            margin-top: 1.5rem;
            margin-bottom: 1.15rem;
        }
        .form-section-header i {
            font-size: 1.1rem;
            color: #2D6CDF;
        }
        .form-section-header.danger-section {
            background: linear-gradient(90deg, #fef2f2 0%, #fff 100%);
            border-left-color: #ef4444;
            color: #991b1b;
        }
        .form-section-header.danger-section i {
            color: #ef4444;
        }
        
        .form-group {
            margin-bottom: 1.1rem;
        }
        .form-group label, .form-label-custom {
            display: block;
            font-size: 0.83rem;
            font-weight: 600;
            color: #374151;
            margin-bottom: 0.35rem;
            line-height: 1.3;
        }

        .form-control, .form-select, select.form-control {
            height: 38px;
            padding: 6px 12px;
            font-size: 0.875rem;
            border-radius: 6px;
            border: 1px solid #d1d5db;
            background-color: #fff;
            transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
        }
        textarea.form-control {
            height: auto !important;
            min-height: 76px;
            resize: vertical;
        }
        .form-control:focus, .form-select:focus {
            border-color: #2D6CDF;
            box-shadow: 0 0 0 3px rgba(45, 108, 223, 0.15);
            outline: 0;
        }
        .form-control:disabled, .form-control[readonly] {
            background-color: #f8fafc !important;
            border-color: #e2e8f0 !important;
            color: #4b5563 !important;
            cursor: not-allowed;
        }

        /* Select2 Sizing Harmonization */
        .select2.select2-container,
        .form-group .select2-container:not(.select2-container--open),
        .select2-container:not(.select2-container--open) {
            width: 100% !important;
            display: block !important;
        }
        .select2-container .select2-selection--single {
            height: 38px !important;
            border: 1px solid #d1d5db !important;
            border-radius: 6px !important;
            padding: 4px 8px !important;
            display: flex !important;
            align-items: center !important;
            width: 100% !important;
            box-sizing: border-box !important;
        }
        .select2-container--default .select2-selection--single .select2-selection__rendered {
            line-height: 28px !important;
            font-size: 0.875rem !important;
            color: #374151 !important;
            padding-left: 4px !important;
            padding-right: 24px !important;
            overflow: hidden !important;
            text-overflow: ellipsis !important;
            white-space: nowrap !important;
            display: block !important;
            width: 100% !important;
        }
        .select2-container--default .select2-selection--single .select2-selection__arrow {
            height: 36px !important;
            right: 6px !important;
        }
        .select2-container--default.select2-container--focus .select2-selection--single {
            border-color: #2D6CDF !important;
            box-shadow: 0 0 0 3px rgba(45, 108, 223, 0.15) !important;
        }

        /* Select2 Open Dropdown Sizing & Styling - strictly follows the dropdownlist width */
        .select2-container--open {
            width: auto !important;
        }
        .select2-container--open .select2-dropdown {
            box-sizing: border-box !important;
            border: 1px solid #2D6CDF !important;
            border-radius: 6px !important;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12) !important;
            overflow: hidden !important;
        }
        .select2-container--open .select2-dropdown--below {
            border-top: none !important;
            border-top-left-radius: 0 !important;
            border-top-right-radius: 0 !important;
        }
        .select2-container--open .select2-dropdown--above {
            border-bottom: none !important;
            border-bottom-left-radius: 0 !important;
            border-bottom-right-radius: 0 !important;
        }
        .select2-container--open .select2-results__option {
            font-size: 0.875rem !important;
            padding: 8px 12px !important;
            line-height: 1.35 !important;
            word-break: break-word !important;
            white-space: normal !important;
        }
        .select2-container--open .select2-results__option--highlighted[aria-selected] {
            background-color: #2D6CDF !important;
            color: #ffffff !important;
        }

        /* Tag pill styling */
        .tag-container {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            margin-top: 8px;
        }
        .tag-pill {
            background: #eff6ff;
            border: 1px solid #bfdbfe;
            color: #1e40af;
            padding: 4px 12px;
            border-radius: 20px;
            display: inline-flex;
            align-items: center;
            font-size: 0.83rem;
            font-weight: 600;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.04);
        }
        .tag-pill .btn-remove-tag {
            color: #ef4444;
            margin-left: 8px;
            text-decoration: none;
            font-weight: 700;
            font-size: 1.1rem;
            line-height: 1;
            transition: transform 0.15s;
        }
        .tag-pill .btn-remove-tag:hover {
            color: #b91c1c;
            transform: scale(1.15);
        }

        /* Checkbox Box Card */
        .checkbox-box {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 8px 12px;
            display: flex;
            align-items: center;
            gap: 10px;
            min-height: 38px;
            transition: background 0.15s, border-color 0.15s;
        }
        .checkbox-box:hover {
            background: #f1f5f9;
            border-color: #cbd5e1;
        }
        .checkbox-box input[type="checkbox"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
            accent-color: #2D6CDF;
            margin: 0;
        }
        .checkbox-box label, .checkbox-box span {
            margin: 0;
            cursor: pointer;
            font-size: 0.85rem;
            font-weight: 600;
            user-select: none;
        }

        /* Validator Message */
        .cssRequiredField {
            font-size: 0.76rem !important;
            font-weight: 500 !important;
            color: #dc2626 !important;
            margin-top: 4px !important;
        }
        span.cssRequiredField[style*="display: inline"] {
            display: block !important;
        }
        span.cssRequiredField[style*="display: none"],
        span.cssRequiredField[style*="display:none"],
        span.cssRequiredField[style*="visibility: hidden"],
        span.cssRequiredField[style*="visibility:hidden"] {
            display: none !important;
        }

        /* Card Form Enhancements */
        .card.card-warning {
            border: 1px solid rgba(245, 158, 11, 0.25);
            border-radius: 12px;
            box-shadow: 0 4px 18px rgba(0, 0, 0, 0.05);
            overflow: hidden;
        }
        .card.card-warning > .card-header {
            background: linear-gradient(135deg, #f59e0b, #d97706);
            color: #fff;
            padding: 12px 20px;
        }
        .card.card-primary {
            border: 1px solid rgba(45, 108, 223, 0.25);
            border-radius: 12px;
            box-shadow: 0 4px 18px rgba(0, 0, 0, 0.05);
            overflow: hidden;
        }
        .card.card-primary > .card-header {
            background: linear-gradient(135deg, #2D6CDF, #1d4ed8);
            color: #fff;
            padding: 12px 20px;
        }
        .card-body {
            padding: 22px 24px;
        }
        .card-footer {
            background-color: #f8fafc;
            border-top: 1px solid #e2e8f0;
            padding: 14px 24px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">

    <section class="content-header">
        <div class="container-fluid">



            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0 text-dark">
                        <div runat="server" id="idWindowTitle"></div>
                    </h1>
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

    <%--<asp:UpdatePanel ID="updatePanel1" runat="server">
        <ContentTemplate>--%>
    <!-- Main content -->
    <section class="content">
        <div class="container-fluid">

                        <%-- =========================================================================
                 SECTION 1: FormView1 - Permohonan (Edit & Insert Templates)
                 ========================================================================= --%>
            <asp:FormView ID="FormView1" runat="server" DataKeyNames="Permohonan_ID"
                DataSourceID="SqlDataSourceForm" Width="100%" DefaultMode="Edit">
                <EditItemTemplate>
                    <div class="card card-warning">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h3 class="card-title mb-0 font-weight-bold"><i class="bi bi-pencil-square me-2"></i>Kemaskini Permohonan</h3>
                        </div>
                        <!-- /.card-header -->
                        <div class="card-body">
                            <asp:HiddenField ID="HF_Status" Value='<%# Bind("StatusID") %>' runat="server" />
                            <asp:HiddenField ID="HF_JenisLesenDescList" Value='<%# Bind("JenisLesenDescList") %>' runat="server" />
                            <asp:HiddenField ID="HF_JenisLesenIdList" Value='<%# Bind("JenisLesenIdList") %>' runat="server" />
                            <asp:HiddenField ID="HF_SaizIklanList" Value='<%# Bind("SaizIklanList") %>' runat="server" />
                            <asp:HiddenField ID="HF_CahayaIklanList" Value='<%# Bind("CahayaIklanList") %>' runat="server" />
                            <asp:HiddenField ID="HF_UnitIklanList" Value='<%# Bind("UnitIklanList") %>' runat="server" />
                            <asp:HiddenField ID="HF_LokasiList" Value='<%# Bind("LokasiList") %>' runat="server" />
                            <asp:HiddenField ID="HF_BakaAnjingList" Value='<%# Bind("BakaAnjingList") %>' runat="server" />
                            <asp:HiddenField ID="HF_AnjingJantanList" Value='<%# Bind("AnjingJantanList") %>' runat="server" />
                            <asp:HiddenField ID="HF_AnjingBetinaList" Value='<%# Bind("AnjingBetinaList") %>' runat="server" />
                            <asp:HiddenField ID="HF_AnjingJantanMandulList" Value='<%# Bind("AnjingJantanMandulList") %>' runat="server" />
                            <asp:HiddenField ID="HF_AnjingBetinaMandulList" Value='<%# Bind("AnjingBetinaMandulList") %>' runat="server" />

                            <asp:Panel runat="server" ID="pnlpemohon">
                                <div class="form-section-header">
                                    <i class="bi bi-person-vcard"></i>
                                    <span>Maklumat Pemohon</span>
                                </div>

                                <asp:Panel runat="server" ID="panelSearch" Visible='<%# If(Eval("StatusID") = 0 And IsDBNull(Eval("SuratKelulusan1")), True, False) %>'>
                                    <asp:HiddenField ID="HF_PermohonanID" runat="server" Value='<%# Bind("Permohonan_ID") %>' />
                                    <div class="row mb-3">
                                        <div class="col-lg-8 col-md-10">
                                            <div class="form-group mb-0">
                                                <label class="form-label-custom"><i class="bi bi-search me-1 text-primary"></i>Pilih Pemohon:</label>
                                                <div class="d-flex flex-wrap align-items-center gap-2">
                                                    <div class="flex-grow-1" style="min-width: 280px;">
                                                        <asp:DropDownList ID="ddl_Pemohon" CssClass="form-control select2" runat="server" OnSelectedIndexChanged="ddl_Pemohon_SelectedIndexChanged"
                                                            DataSourceID="SqlDataSourcePemohon" DataTextField="PemohonDesc" DataValueField="Pemohon_ID" AutoPostBack="true" CausesValidation="false">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource runat="server" ID="SqlDataSourcePemohon" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                            SelectCommand="SELECT NULL AS Pemohon_ID, '-- Sila Pilih --' AS PemohonDesc UNION ALL SELECT Pemohon_ID,  Pemohon_ICNo + ' - ' + Pemohon_Name AS PemohonDesc FROM LESEN_Pemohon WHERE Pemohon_IsActive = 1"></asp:SqlDataSource>
                                                    </div>
                                                    <asp:HyperLink runat="server" NavigateUrl="~/lesen/applicantregister.aspx?p_Id=3354&m_Id=3355" CssClass="btn btn-outline-primary d-inline-flex align-items-center">
                                                        <i class="bi bi-person-plus me-1"></i>Daftar Pemohon Baru
                                                    </asp:HyperLink>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </asp:Panel>

                                <div class="row">
                                    <div class="col-md-3 col-lg-2">
                                        <div class="form-group">
                                            <label class="form-label-custom">Pemohon ID</label>
                                            <asp:TextBox ID="TB_PemohonID" runat="server" Enabled="false" Text='<%# Bind("Permohonan_PemohonID") %>' CssClass="form-control" />
                                        </div>
                                    </div>

                                    <div class="col-md-5 col-lg-6">
                                        <div class="form-group">
                                            <label class="form-label-custom">Nama Pemohon</label>
                                            <asp:TextBox ID="TB_Name" runat="server" Enabled="false" Text="NULL" CssClass="form-control" />
                                        </div>
                                    </div>

                                    <div class="col-md-4 col-lg-4">
                                        <div class="form-group">
                                            <label class="form-label-custom">Warganegara</label>
                                            <asp:TextBox ID="TB_Nat" runat="server" Enabled="false" Text="NULL" CssClass="form-control" />
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label-custom">Alamat</label>
                                            <asp:TextBox ID="TB_Address" Enabled="false" runat="server"
                                                Text="NULL" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label-custom">Catatan</label>
                                            <asp:TextBox ID="TB_Remarks" Enabled="false" runat="server"
                                                Text="NULL" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                                        </div>
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-4">
                                        <asp:LinkButton
                                            runat="server"
                                            ID="LinkButton7"
                                            CssClass="qr-box"
                                            OnClick="btnQrCode_Click"
                                            ToolTip="Print QR Code"
                                            CausesValidation="false">

                                            <div class="qr-icon">
                                                <i class="bi bi-qr-code"></i>
                                            </div>

                                            <div class="qr-text">
                                                <div class="qr-title">
                                                    Kod QR Permohonan
                                                </div>

                                                <div class="qr-description">
                                                    Imbas untuk melihat<br />
                                                    butiran permohonan
                                                </div>
                                            </div>

                                        </asp:LinkButton>
                                    </div>
                                </div>
                            </asp:Panel>

                            <asp:Panel runat="server" Enabled='<%# If(Eval("StatusID") = 0, True, True) %>'>
                                <div class="form-section-header">
                                    <i class="bi bi-file-earmark-text"></i>
                                    <span>Maklumat Permohonan</span>
                                </div>

                                <div class="row">
                                    <div class="col-md-4 col-lg-3">
                                        <div class="form-group">
                                            <label class="form-label-custom">Tarikh Mohon <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="TB_TarikhMohon" runat="server"
                                                Text='<%# Bind("TarikhMohon", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_TarikhMohon" ErrorMessage="Sila Pilih Tarikh Mohon" ValidationGroup="updateForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                    <div class="col-md-8 col-lg-9">
                                        <div class="form-group mb-2">
                                            <label class="form-label-custom">Jenis Lesen / Permit</label>
                                            <asp:DropDownList ID="ddlItems" runat="server" DataSourceID="SqlDataSource1" CssClass="form-control select2"
                                                DataTextField="JenisLesen_Description" DataValueField="JenisLesen_ID" AutoPostBack="true"
                                                OnSelectedIndexChanged="ddlItems_SelectedIndexChanged" AppendDataBoundItems="true" CausesValidation="false">
                                            </asp:DropDownList>
                                            <asp:SqlDataSource runat="server" ID="SqlDataSource1" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            SelectCommand="select * from 
                                            (select NULL as JenisLesen_ID, '-- Sila Pilih --' as JenisLesen_Description
                                            union all
                                            select JenisLesen_ID, JenisLesen_Description from LESEN_JenisLesen 
                                            where JenisLesen_IsActive=1 and JenisLesen_Description not like '%DAN%'
                                            ) as tbl1 order by JenisLesen_Description ">
                                            </asp:SqlDataSource>
                                        </div>

                                        <div class="tag-container">
                                            <asp:Repeater ID="rptSelectedItems" runat="server" OnItemCommand="rptSelectedItems_ItemCommand">
                                                <ItemTemplate>
                                                    <div class="tag-pill">
                                                        <span><%# Eval("ItemText") %></span>
                                                        <asp:LinkButton ID="btnRemove" runat="server" 
                                                            CommandName="Remove" 
                                                            CommandArgument='<%# Eval("ItemValue") %>' 
                                                            CssClass="btn-remove-tag"
                                                            CausesValidation="false">&times;</asp:LinkButton>
                                                    </div>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </div>
                                    </div>
                                </div>

                                <%--# Perniagaan Berisiko dan tidak berisiko #--%>
                                <asp:Panel ID="pnlesen1" runat="server" Visible="False">
                                    <div class="form-section-header">
                                        <i class="bi bi-shop"></i>
                                        <span>Maklumat Perniagaan / Premis</span>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="form-label-custom">Nama Syarikat / Sediada</label>
                                                <asp:TextBox ID="TB_NamaSyarikat" runat="server"
                                                    Text='<%# Bind("NamaSyarikat") %>' CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label class="form-label-custom">No Pendaftaran</label>
                                                <asp:TextBox ID="TB_NoPendaftaran" runat="server"
                                                    Text='<%# Bind("NoPendaftaran") %>' CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label class="form-label-custom">No Akaun Lesen</label>
                                                <asp:TextBox ID="TB_NoAkaun" runat="server"
                                                    Text='<%# Bind("NoAkaun") %>' CssClass="form-control" />
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="form-label-custom">Alamat Premis / Sediada</label>
                                                <asp:TextBox ID="TB_AlamatPremis" runat="server"
                                                    Text='<%# Bind("AlamatPremis") %>' TextMode="MultiLine" Rows="3" CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="form-label-custom">Jenis Perniagaan / Sediada</label>
                                                <asp:TextBox ID="TB_JenisPerniagaan" runat="server"
                                                    Text='<%# Bind("JenisPerniagaan") %>' TextMode="MultiLine" Rows="3" CssClass="form-control" />
                                            </div>
                                        </div>
                                    </div>

                                    <%--# Tukar Pemilik #--%>
                                    <asp:Panel ID="pnlesen1b" runat="server" Visible="False">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label class="form-label-custom">Nama Pemilik Baru</label>
                                                    <asp:TextBox ID="TB_PemilikBaru" runat="server"
                                                        Text='<%# Bind("PemilikBaru") %>' CssClass="form-control" />
                                                </div>
                                            </div>
                                        </div>
                                    </asp:Panel>

                                    <%--# Tukar Alamat #--%>
                                    <asp:Panel ID="pnlesen1c" runat="server" Visible="False">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <asp:Label ID="Lbl_AlamatBaru" runat="server" Text="Alamat Baru" CssClass="form-label-custom" />
                                                    <asp:TextBox ID="TB_AlamatBaru" runat="server"
                                                        Text='<%# Bind("AlamatBaru") %>' TextMode="MultiLine" Rows="3" CssClass="form-control" />
                                                </div>
                                            </div>
                                        </div>
                                    </asp:Panel>

                                    <%--# Tambah Jenis Perniagaan #--%>
                                    <asp:Panel ID="pnlesen1d" runat="server" Visible="False">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <asp:Label ID="Lbl_JenisPerniagaanBaru" runat="server" Text="Jenis Perniagaan Tambahan" CssClass="form-label-custom" />
                                                    <asp:TextBox ID="TB_JenisPerniagaanBaru" runat="server"
                                                        Text='<%# Bind("JenisPerniagaanBaru") %>' CssClass="form-control" />
                                                </div>
                                            </div>
                                        </div>
                                    </asp:Panel>

                                    <%--# Tukar Nama Syarikat #--%>
                                    <asp:Panel ID="pnlesen1e" runat="server" Visible="False">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label class="form-label-custom">Nama Baru Syarikat</label>
                                                    <asp:TextBox ID="TB_NamaBaruSyarikat" runat="server"
                                                        Text='<%# Bind("NamaBaruSyarikat") %>' CssClass="form-control" />
                                                </div>
                                            </div>
                                        </div>
                                    </asp:Panel>
                                </asp:Panel>

                                <%--# Banting #--%>
                                <asp:Panel ID="pnlesen6" runat="server" Visible="False">
                                    <div class="form-section-header">
                                        <i class="bi bi-flag"></i>
                                        <span>Maklumat Banting / Sepanduk</span>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label class="form-label-custom">Jenis</label>
                                                <asp:DropDownList ID="DDL_JenisBanting" Text='<%# Bind("JenisBanting") %>' runat="server" 
                                                    CssClass="form-control select2">
                                                    <asp:ListItem Value="">-- Sila Pilih --</asp:ListItem>
                                                    <asp:ListItem Value="Banting">Banting</asp:ListItem>
                                                    <asp:ListItem Value="Sepanduk">Sepanduk</asp:ListItem>
                                                    <asp:ListItem Value="Sepanduk Besar">Sepanduk Besar</asp:ListItem>
                                                </asp:DropDownList>
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="form-label-custom">Nama Syarikat Kontraktor Pemasang Iklan</label>
                                                <asp:TextBox ID="TB_KontraktorIklan" runat="server"
                                                    Text='<%# Bind("KontraktorIklan") %>' CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label class="form-label-custom">No Telefon Syarikat Kontraktor</label>
                                                <asp:TextBox ID="TB_NoTelKontraktor" runat="server"
                                                    Text='<%# Bind("NoTelKontraktor") %>' CssClass="form-control" />
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label class="form-label-custom">Ukuran (Kaki)</label>
                                                <asp:TextBox ID="TB_UkuranBanting" runat="server"
                                                    Text='<%# Bind("UkuranBanting") %>' placeholder="Contoh: 5x10" CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label class="form-label-custom">Bilangan Banting/Sepanduk</label>
                                                <asp:TextBox ID="TB_BilBanting" runat="server"
                                                    Text='<%# Bind("BilBanting") %>' CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label class="form-label-custom">Tarikh Mula Pemasangan</label>
                                                <asp:TextBox ID="TB_TarikhBanting1" runat="server"
                                                    Text='<%# Bind("TarikhBanting1", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label class="form-label-custom">Tarikh Akhir Pemasangan</label>
                                                <asp:TextBox ID="TB_TarikhBanting2" runat="server"
                                                    Text='<%# Bind("TarikhBanting2", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="form-control" />
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row align-items-end mb-3">
                                        <div class="col-md-8 col-lg-9">
                                            <div class="form-group mb-0">
                                                <label class="form-label-custom">Lokasi / Tempat Pemasangan</label>
                                                <asp:TextBox ID="TB_LokasiBanting" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-control" placeholder="Masukkan lokasi pemasangan banting..." />
                                            </div>
                                        </div>
                                        <div class="col-md-4 col-lg-3 mt-2 mt-md-0">
                                            <asp:LinkButton ID="btnAddLokasi" runat="server" CssClass="btn btn-primary w-100" OnClick="btnAddLokasi_Click" CausesValidation="false">
                                                <i class="bi bi-plus-circle me-1"></i> Tambah Lokasi
                                            </asp:LinkButton>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-12">
                                            <asp:GridView ID="gvLokasiList" runat="server" GridLines="None" ShowHeader="false" 
                                                CssClass="banting-lokasi-list no-action-dropdown" AutoGenerateColumns="False" 
                                                ShowHeaderWhenEmpty="true" EmptyDataText="<div class='text-muted small py-2'>Senarai lokasi kosong. Sila masukkan lokasi di atas dan klik 'Tambah'.</div>"
                                                DataKeyNames="Lokasi_ID" OnRowDataBound="gvLokasiList_RowDataBound">
                                                <Columns>
                                                    <asp:TemplateField ItemStyle-Width="100%" ItemStyle-CssClass="p-0 border-0">
                                                        <ItemTemplate>
                                                            <div class="card mb-3 shadow-none" style="border: 1px solid #ced4da; box-shadow: none;">
                                                                <div class="bg-light d-flex justify-content-between align-items-center py-2 px-3 lokasi-card-header">
                                                                    <!-- View Mode Panel -->
                                                                    <div class="lokasi-view-panel d-flex align-items-center flex-grow-1 me-2 overflow-hidden">
                                                                        <strong class="text-nowrap me-2">Lokasi #<%# Container.DataItemIndex + 1 %>:</strong>
                                                                        <span class="text-dark lokasi-text text-break"><%# Eval("Lokasi") %></span>
                                                                    </div>

                                                                    <!-- Edit Mode Panel -->
                                                                    <div class="lokasi-edit-panel d-none align-items-center flex-grow-1 me-2">
                                                                        <strong class="text-nowrap me-2">Lokasi #<%# Container.DataItemIndex + 1 %>:</strong>
                                                                        <asp:TextBox ID="txtEditLokasi" runat="server" Text='<%# Eval("Lokasi") %>' 
                                                                            CssClass="form-control form-control-sm lokasi-edit-input" placeholder="Masukkan lokasi..." 
                                                                            onkeydown="onLokasiEditKey(event, this);" />
                                                                    </div>

                                                                    <!-- Actions -->
                                                                    <div class="d-flex align-items-center text-nowrap">
                                                                        <!-- View Mode Actions (Edit & Delete) -->
                                                                        <div class="lokasi-actions-view d-inline-flex">
                                                                            <button type="button" class="btn btn-primary btn-sm me-1" 
                                                                                onclick="toggleLokasiEdit(this, true);" title="Kemaskini Lokasi">
                                                                                <i class="bi bi-pencil-square"></i>
                                                                            </button>
                                                                            <asp:LinkButton ID="btnRemoveLokasi" runat="server" OnClick="btnRemoveLokasi_Click" CommandArgument='<%# Eval("Lokasi_ID") %>' 
                                                                                CssClass="btn btn-danger btn-sm" CausesValidation="false" 
                                                                                OnClientClick="return confirm('Padam lokasi ini dan semua gambar banting yang telah dimuat naik?');" ToolTip="Padam Lokasi">
                                                                                <i class="bi bi-trash"></i>
                                                                            </asp:LinkButton>
                                                                        </div>

                                                                        <!-- Edit Mode Actions (Save & Cancel) -->
                                                                        <div class="lokasi-actions-edit d-none">
                                                                            <asp:LinkButton ID="btnSaveLokasi" runat="server" OnClick="btnSaveLokasi_Click" CommandArgument='<%# Eval("Lokasi_ID") %>' 
                                                                                CssClass="btn btn-success btn-sm p-4 me-1 btn-save-lokasi" CausesValidation="false" ToolTip="Simpan Lokasi">
                                                                                <i class="bi bi-check-lg"></i>
                                                                            </asp:LinkButton>
                                                                            <button type="button" class="btn btn-danger btn-sm" 
                                                                                onclick="toggleLokasiEdit(this, false);" title="Batal">
                                                                                <i class="bi bi-x-lg"></i>
                                                                            </button>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="card-body p-3">
                                                                    <div class="row align-items-end mb-3">
                                                                        <div class="col-md-5">
                                                                            <label class="form-label small mb-1">Fail Gambar Banting:</label>
                                                                            <asp:FileUpload ID="fuBantingImg" runat="server" CssClass="form-control form-control-sm" accept="image/*" />
                                                                        </div>
                                                                        <div class="col-md-5">
                                                                            <label class="form-label small mb-1">Catatan:</label>
                                                                            <asp:TextBox ID="txtBantingRemarks" runat="server" CssClass="form-control form-control-sm" placeholder="Catatan / Remarks (pilihan)" />
                                                                        </div>
                                                                        <div class="col-md-2 mt-2 mt-md-0 d-flex align-items-end">
                                                                            <asp:LinkButton ID="btnUploadBantingImg" runat="server" OnClick="btnUploadBantingImg_Click" CommandArgument='<%# Eval("Lokasi_ID") %>' 
                                                                                CssClass="btn btn-primary btn-sm" CausesValidation="false" ToolTip="Muat Naik Fail Gambar">
                                                                                <i class="bi bi-upload"></i>
                                                                            </asp:LinkButton>
                                                                        </div>
                                                                    </div>

                                                                    <div class="table-responsive">
                                                                        <asp:GridView ID="gvBantingImages" runat="server" AutoGenerateColumns="False" 
                                                                            CssClass="table table-sm table-bordered mb-0 no-action-dropdown"
                                                                            ShowHeaderWhenEmpty="true" EmptyDataText="Tiada gambar banting dimuat naik untuk lokasi ini lagi.">
                                                                            <HeaderStyle ForeColor="Black" BackColor="#f8f9fa" CssClass="small" />
                                                                            <Columns>
                                                                                <asp:TemplateField HeaderText="Bil." ItemStyle-Width="5%" ItemStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle">
                                                                                    <ItemTemplate>
                                                                                        <span class="small"><%# Container.DataItemIndex + 1 %></span>
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateField>
                                                                                <asp:TemplateField HeaderText="Imej" ItemStyle-Width="12%" ItemStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle">
                                                                                    <ItemTemplate>
                                                                                        <a href='<%# If(Eval("FilePath") IsNot Nothing AndAlso Not IsDBNull(Eval("FilePath")), ResolveUrl(Eval("FilePath").ToString()), "") %>' target="_blank">
                                                                                            <img src='<%# If(Eval("FilePath") IsNot Nothing AndAlso Not IsDBNull(Eval("FilePath")), ResolveUrl(Eval("FilePath").ToString()), "") %>' style="height: 40px; width: 55px; object-fit: cover; border: 1px solid #ced4da;" />
                                                                                        </a>
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateField>
                                                                                <asp:BoundField DataField="UniqueID" HeaderText="ID Unik" ItemStyle-Width="25%" ItemStyle-VerticalAlign="Middle" ItemStyle-CssClass="small font-weight-bold" />
                                                                                <asp:BoundField DataField="Remarks" HeaderText="Catatan" NullDisplayText="-" ItemStyle-Width="35%" ItemStyle-VerticalAlign="Middle" ItemStyle-CssClass="small" />
                                                                                <asp:TemplateField HeaderText="Kod QR" ItemStyle-Width="13%" ItemStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle">
                                                                                    <ItemTemplate>
                                                                                        <asp:LinkButton ID="btnQrCodeBanting" runat="server" CssClass="btn btn-outline-primary btn-sm p-2" OnClick="btnQrCodeBanting_Click" 
                                                                                            CommandArgument='<%# Eval("UniqueID") %>' CausesValidation="false" ToolTip="Lihat &amp; Cetak Kod QR">
                                                                                            <i class="bi bi-qr-code"></i>
                                                                                        </asp:LinkButton>
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateField>
                                                                                <asp:TemplateField HeaderText="Tindakan" ItemStyle-Width="10%" ItemStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle">
                                                                                    <ItemTemplate>
                                                                                        <asp:LinkButton ID="btnDeleteBantingImg" runat="server" CssClass="btn btn-danger btn-sm" OnClick="btnDeleteBantingImg_Click" 
                                                                                            CommandArgument='<%# Eval("Imej_ID") %>' CausesValidation="false" OnClientClick="return confirm('Adakah anda pasti untuk padam gambar ini?');" ToolTip="Padam Gambar">
                                                                                            <i class="bi bi-trash"></i>
                                                                                        </asp:LinkButton>
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateField>
                                                                            </Columns>
                                                                        </asp:GridView>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                            </asp:GridView>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label class="form-label-custom">Status Kelulusan DBP</label>
                                                <asp:DropDownList ID="DDL_StatusDBP" Text='<%# Bind("StatusBanting") %>' runat="server" 
                                                    CssClass="form-control select2">
                                                    <asp:ListItem Value="">-- Sila Pilih --</asp:ListItem>
                                                    <asp:ListItem Value="1">Lulus</asp:ListItem>
                                                    <asp:ListItem Value="0">Tidak Diluluskan</asp:ListItem>
                                                </asp:DropDownList>
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label class="form-label-custom">No Pengesahan</label>
                                                <asp:TextBox ID="TB_NoPengesahan" runat="server"
                                                    Text='<%# Bind("NoPengesahanBanting") %>' CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label class="form-label-custom">Tarikh Mula Pengesahan</label>
                                                <asp:TextBox ID="TB_TarikhPengesahanBanting1" runat="server"
                                                    Text='<%# Bind("TarikhPengesahanBanting1", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label class="form-label-custom">Tarikh Akhir Pengesahan</label>
                                                <asp:TextBox ID="TB_TarikhPengesahanBanting2" runat="server"
                                                    Text='<%# Bind("TarikhPengesahanBanting2", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="form-control" />
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label class="form-label-custom">No Resit</label>
                                                <asp:TextBox ID="TB_NoResit1" runat="server"
                                                    Text='<%# Bind("NoResitBanting") %>' CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label class="form-label-custom">No Siri Stiker</label>
                                                <asp:TextBox ID="TB_NoSiriStiker" runat="server"
                                                    Text='<%# Bind("NoSiriStiker") %>' CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label class="form-label-custom">Tarikh</label>
                                                <asp:TextBox ID="TB_TarikhBanting3" runat="server"
                                                    Text='<%# Bind("TarikhBanting3", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label class="form-label-custom">Bilangan Pembaharuan</label>
                                                <asp:DropDownList ID="DDL_RenewBanting" Text='<%# Bind("RenewBanting") %>' runat="server" 
                                                    CssClass="form-control select2">
                                                    <asp:ListItem Value="">-- Sila Pilih --</asp:ListItem>
                                                    <asp:ListItem Value="1">Kali Pertama</asp:ListItem>
                                                    <asp:ListItem Value="2">Kali Kedua</asp:ListItem>
                                                    <asp:ListItem Value="3">Kali Ketiga</asp:ListItem>
                                                </asp:DropDownList>
                                            </div>
                                        </div>
                                    </div>
                                </asp:Panel>

                                <%--# Papan iklan, Billboard #--%>
                                <asp:Panel ID="pnlesen1a" runat="server" Visible="False">
                                    <div class="form-section-header">
                                        <i class="bi bi-badge-ad"></i>
                                        <span>Maklumat Papan Iklan</span>
                                    </div>

                                    <div class="row align-items-end">
                                        <div class="col-md-3">
                                            <div class="form-group mb-md-0">
                                                <label class="form-label-custom">Saiz Iklan (cm)</label>
                                                <asp:TextBox ID="TB_SaizIklan1" placeholder="Contoh: 10x5" runat="server" CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group mb-md-0">
                                                <label class="form-label-custom">Iklan Bercahaya</label>
                                                <asp:DropDownList ID="DDL_Iklan1" runat="server" CssClass="form-control select2">
                                                    <asp:ListItem Value="">-- Sila Pilih --</asp:ListItem>
                                                    <asp:ListItem Value="Bercahaya">Ya</asp:ListItem>
                                                    <asp:ListItem Value="Tidak Bercahaya">Tidak</asp:ListItem>
                                                </asp:DropDownList>
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group mb-md-0">
                                                <label class="form-label-custom">Bil. Unit</label>
                                                <asp:TextBox ID="TB_UnitIklan1" TextMode="Number" runat="server" CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group mb-0">
                                                <asp:LinkButton ID="btnAddIklan" runat="server" CssClass="btn btn-primary w-100" Text="Tambah" OnClick="btnAddIklan_Click" CausesValidation="false">
                                                    <i class="bi bi-plus-circle me-1"></i> Tambah Iklan
                                                </asp:LinkButton>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row mt-3">
                                        <div class="col-md-12 col-lg-8">
                                            <asp:GridView ID="gvIklanList" runat="server" HeaderStyle-ForeColor="Black" CssClass="table table-bordered table-sm" AutoGenerateColumns="False" 
                                                ShowHeaderWhenEmpty="true" EmptyDataText="Senarai kosong." OnRowDeleting="gvIklanList_RowDeleting">
                                                <Columns>
                                                    <asp:BoundField DataField="SaizIklan" HeaderText="Saiz Iklan (cm)" />
                                                    <asp:BoundField DataField="Bercahaya" HeaderText="Bercahaya/Tidak Bercahaya" />
                                                    <asp:BoundField DataField="Unit" HeaderText="Bil. Unit" />
                                                    <asp:TemplateField>
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="btnRemove" runat="server" Text="Remove" 
                                                                CommandName="Delete" CssClass="btn btn-danger btn-sm" CausesValidation="false">
                                                                <i class="bi bi-trash"></i>
                                                            </asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                            </asp:GridView>
                                        </div>
                                    </div>
                                </asp:Panel>

                                <%--# Billboard #--%>
                                <asp:Panel ID="pnlbillboard" runat="server" Visible="False">
                                    <div class="form-section-header">
                                        <i class="bi bi-display"></i>
                                        <span>Maklumat Billboard</span>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-8 col-lg-6">
                                            <div class="form-group">
                                                <label class="form-label-custom">Lokasi Billboard</label>
                                                <asp:TextBox ID="TB_BillboardLokasi" runat="server"
                                                    Text='<%# Bind("BillboardLokasi") %>' TextMode="MultiLine" Rows="3" CssClass="form-control" />
                                            </div>
                                        </div>
                                    </div>
                                </asp:Panel>

                                <%--# Pasar Lambak #--%>
                                <asp:Panel ID="pnlesen2" runat="server" Visible="False">
                                    <div class="form-section-header">
                                        <i class="bi bi-basket"></i>
                                        <span>Maklumat Pasar</span>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label class="form-label-custom">Lokasi Pasar #1</label>
                                                <asp:TextBox ID="TB_LokasiPasar1" runat="server"
                                                    Text='<%# Bind("LokasiPasar1") %>' TextMode="MultiLine" Rows="2" CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label class="form-label-custom">Lokasi Pasar #2</label>
                                                <asp:TextBox ID="TB_LokasiPasar2" runat="server"
                                                    Text='<%# Bind("LokasiPasar2") %>' TextMode="MultiLine" Rows="2" CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label class="form-label-custom">Lokasi Pasar #3</label>
                                                <asp:TextBox ID="TB_LokasiPasar3" runat="server"
                                                    Text='<%# Bind("LokasiPasar3") %>' TextMode="MultiLine" Rows="2" CssClass="form-control" />
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label class="form-label-custom">Jenis Pasar</label>
                                                <asp:DropDownList ID="DDL_JenisPasar" Text='<%# Bind("JenisPasar") %>' runat="server" 
                                                    CssClass="form-control select2">
                                                    <asp:ListItem Value="">-- Sila Pilih --</asp:ListItem>
                                                    <asp:ListItem>Pasar Pagi</asp:ListItem>
                                                    <asp:ListItem>Pasar Malam</asp:ListItem>
                                                    <asp:ListItem>Pasar Lambak</asp:ListItem>
                                                    <asp:ListItem>Pasar Sehari</asp:ListItem>
                                                </asp:DropDownList>
                                            </div>
                                        </div>

                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label class="form-label-custom">Jumlah Petak/Tapak/Lot</label>
                                                <asp:TextBox ID="TB_JumlahPetak" runat="server"
                                                    Text='<%# Bind("JumlahPetak") %>' CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label class="form-label-custom">Jenis Perniagaan</label>
                                                <asp:TextBox ID="TB_JenisPerniagaanPasar" runat="server"
                                                    Text='<%# Bind("JenisPerniagaanPasar") %>' CssClass="form-control" />
                                            </div>
                                        </div>
                                    </div>
                                </asp:Panel>

                                <%--# Anjing #--%>
                                <asp:Panel ID="pnlesen3" runat="server" Visible="False">
                                    <div class="form-section-header">
                                        <i class="bi bi-heart-pulse"></i>
                                        <span>Maklumat Lesen Anjing</span>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-8">
                                            <div class="form-group">
                                                <label class="form-label-custom">Alamat Lokasi</label>
                                                <asp:TextBox ID="TB_AnjingAlamat" runat="server"
                                                    Text='<%# Bind("AnjingAlamat") %>' TextMode="MultiLine" Rows="2" CssClass="form-control" />
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" CssClass="cssRequiredField"
                                                    ControlToValidate="TB_AnjingAlamat" ErrorMessage="Sila Isi Alamat" ValidationGroup="updateForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                            </div>
                                        </div>

                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label class="form-label-custom">Jenis Premis</label>
                                                <asp:DropDownList ID="DDL_AnjingJenisPremis" Text='<%# Bind("AnjingJenisPremis") %>' CssClass="form-control select2" runat="server"
                                                    DataSourceID="SqlDataSourceAnjingJenisPremis" DataTextField="name" DataValueField="id">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource runat="server" ID="SqlDataSourceAnjingJenisPremis" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                    SelectCommand="SELECT NULL AS id, '-- Sila Pilih --' AS name UNION ALL SELECT id, name 
                                                        FROM TBL_LOOKUPS WHERE lookupgrp_id = 10001 AND status = 1"></asp:SqlDataSource>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row align-items-end">
                                        <div class="col-md-3">
                                            <div class="form-group mb-md-0">
                                                <label class="form-label-custom">Jenis Baka</label>
                                                <asp:DropDownList ID="DDL_BakaAnjing1" CssClass="form-control select2" runat="server"
                                                    DataSourceID="SqlDataSourceAnjingBaka1" DataTextField="name" DataValueField="id">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource runat="server" ID="SqlDataSourceAnjingBaka1" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                    SelectCommand="SELECT NULL AS id, '-- Sila Pilih --' AS name UNION ALL SELECT id, name 
                                                            FROM TBL_LOOKUPS WHERE lookupgrp_id = 10004 AND status = 1"></asp:SqlDataSource>
                                            </div>
                                        </div>

                                        <div class="col-6 col-md-2">
                                            <div class="form-group mb-md-0">
                                                <label class="form-label-custom">Bil. Jantan</label>
                                                <asp:TextBox ID="TB_Jantan1" runat="server" TextMode="Number" CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-6 col-md-2">
                                            <div class="form-group mb-md-0">
                                                <label class="form-label-custom">Bil. Betina</label>
                                                <asp:TextBox ID="TB_Betina1" runat="server" TextMode="Number" CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-6 col-md-2">
                                            <div class="form-group mb-md-0">
                                                <label class="form-label-custom">Jantan Mandul</label>
                                                <asp:TextBox ID="TB_JantanMandul1" runat="server" TextMode="Number" CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-6 col-md-3">
                                            <div class="form-group mb-0">
                                                <label class="form-label-custom">Betina Mandul</label>
                                                <div class="d-flex gap-2">
                                                    <asp:TextBox ID="TB_BetinaMandul1" runat="server" TextMode="Number" CssClass="form-control" />
                                                    <asp:LinkButton ID="btnAddAnjing" runat="server" CssClass="btn btn-primary text-nowrap" Text="Tambah" OnClick="btnAddAnjing_Click" CausesValidation="false">
                                                        <i class="bi bi-plus-circle me-1"></i> Tambah
                                                    </asp:LinkButton>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row mt-3">
                                        <div class="col-md-12">
                                            <asp:GridView ID="gvAnjingList" runat="server" HeaderStyle-ForeColor="Black" CssClass="table table-bordered table-sm" AutoGenerateColumns="False" 
                                                ShowHeaderWhenEmpty="true" EmptyDataText="Senarai kosong." OnRowDeleting="gvAnjingList_RowDeleting">
                                                <Columns>
                                                    <asp:BoundField DataField="Baka" HeaderText="Baka Anjing" />
                                                    <asp:BoundField DataField="Jantan" HeaderText="Bil. Jantan" />
                                                    <asp:BoundField DataField="Betina" HeaderText="Bil. Betina" />
                                                    <asp:BoundField DataField="JantanMandul" HeaderText="Bil. Jantan Mandul" />
                                                    <asp:BoundField DataField="BetinaMandul" HeaderText="Bil. Betina Mandul" />
                                                    <asp:TemplateField>
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="btnRemove" runat="server"  
                                                                CommandName="Delete" CssClass="btn btn-danger btn-sm" CausesValidation="false">
                                                                <i class="bi bi-trash"></i>
                                                            </asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                            </asp:GridView>
                                        </div>
                                    </div>
                                </asp:Panel>

                                <%--# Penjaja #--%>
                                <asp:Panel ID="pnlesen4" runat="server" Visible="False">
                                    <div class="form-section-header">
                                        <i class="bi bi-truck"></i>
                                        <span>Maklumat Penjaja</span>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label class="form-label-custom">Jenis Penjaja</label>
                                                <asp:DropDownList ID="DDL_JenisPenjaja" CssClass="form-control select2" runat="server"
                                                    DataSourceID="SqlDataSourceJenisPenjaja" DataTextField="name" DataValueField="id">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource runat="server" ID="SqlDataSourceJenisPenjaja" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                    SelectCommand="SELECT NULL AS id, '-- Sila Pilih --' AS name UNION ALL SELECT id, name 
                                                            FROM TBL_LOOKUPS WHERE lookupgrp_id = 10006 AND status = 1"></asp:SqlDataSource>
                                            </div>
                                        </div>

                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label class="form-label-custom">Status Tanah</label>
                                                <asp:DropDownList ID="DDL_StatusTanahPenjaja" CssClass="form-control select2" runat="server"
                                                    DataSourceID="SqlDataSourceStatusTanahPenjaja" DataTextField="name" DataValueField="id">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource runat="server" ID="SqlDataSourceStatusTanahPenjaja" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                    SelectCommand="SELECT NULL AS id, '-- Sila Pilih --' AS name UNION ALL SELECT id, name 
                                                            FROM TBL_LOOKUPS WHERE lookupgrp_id = 10007 AND status = 1"></asp:SqlDataSource>
                                            </div>
                                        </div>

                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label class="form-label-custom">Jenis Jualan</label>
                                                <asp:TextBox ID="TB_JenisPerniagaanPenjaja" runat="server"
                                                    Text='<%# Bind("JenisPerniagaanPenjaja") %>' CssClass="form-control" />
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-12">
                                            <div class="form-group">
                                                <label class="form-label-custom">Alamat Aktiviti Penjajaan</label>
                                                <asp:TextBox ID="TB_AlamatPenjajaan" runat="server"
                                                    Text='<%# Bind("AlamatPenjajaan") %>' TextMode="MultiLine" Rows="2" CssClass="form-control" />
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label class="form-label-custom">Masa Mula Jualan</label>
                                                <asp:TextBox ID="TB_MasaPenjaja1" runat="server" TextMode="Time"
                                                    Text='<%# Bind("MasaPenjaja1") %>' CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label class="form-label-custom">Masa Tamat Jualan</label>
                                                <asp:TextBox ID="TB_MasaPenjaja2" runat="server" TextMode="Time"
                                                    Text='<%# Bind("MasaPenjaja2") %>' CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label class="form-label-custom">Jenis Kenderaan (Penjaja Berkenderaan)</label>
                                                <asp:DropDownList ID="DDL_JenisKenderaanPenjaja" CssClass="form-control select2" runat="server"
                                                    DataSourceID="SqlDataSourceJenisKenderaanPenjaja" DataTextField="name" DataValueField="id">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource runat="server" ID="SqlDataSourceJenisKenderaanPenjaja" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                    SelectCommand="SELECT NULL AS id, '-- Sila Pilih --' AS name UNION ALL SELECT id, name 
                                                            FROM TBL_LOOKUPS WHERE lookupgrp_id = 10008 AND status = 1"></asp:SqlDataSource>
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label class="form-label-custom">No Pendaftaran Kenderaan</label>
                                                <asp:TextBox ID="TB_NoKenderaanPenjaja" runat="server" 
                                                    Text='<%# Bind("NoKenderaanPenjaja") %>' CssClass="form-control" />
                                            </div>
                                        </div>
                                    </div>
                                </asp:Panel>

                                <%--# Ekspo #--%>
                                <asp:Panel ID="pnlesen5" runat="server" Visible="False">
                                    <div class="form-section-header">
                                        <i class="bi bi-calendar-event"></i>
                                        <span>Maklumat Ekspo / Program</span>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-5">
                                            <div class="form-group">
                                                <label class="form-label-custom">Nama Penganjur</label>
                                                <asp:TextBox ID="TB_PenganjurEkspo" runat="server"
                                                    Text='<%# Bind("PenganjurEkspo") %>' CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label class="form-label-custom">PIC Penganjur</label>
                                                <asp:TextBox ID="TB_PicEkspo" runat="server"
                                                    Text='<%# Bind("PicEkspo") %>' CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label class="form-label-custom">No. Tel. PIC</label>
                                                <asp:TextBox ID="TB_NoTel" runat="server"
                                                    Text='<%# Bind("NoTelEkspo") %>' CssClass="form-control" />
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-12">
                                            <div class="form-group">
                                                <label class="form-label-custom">Alamat Penganjur</label>
                                                <asp:TextBox ID="TB_AlamatPenganjurEkspo" runat="server"
                                                    Text='<%# Bind("AlamatPenganjurEkspo") %>' TextMode="MultiLine" Rows="2" CssClass="form-control" />
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="form-label-custom">Nama Aktiviti / Program</label>
                                                <asp:TextBox ID="TB_NamaEkspo" runat="server"
                                                    Text='<%# Bind("NamaEkspo") %>' CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="form-label-custom">Lokasi Program</label>
                                                <asp:TextBox ID="TB_LokasiEkspo" runat="server"
                                                    Text='<%# Bind("LokasiEkspo") %>' TextMode="MultiLine" Rows="2" CssClass="form-control" />
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label class="form-label-custom">Tarikh Mula</label>
                                                <asp:TextBox ID="TB_TarikhEkspo1" runat="server"
                                                    Text='<%# Bind("TarikhEkspo1", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label class="form-label-custom">Tarikh Tamat</label>
                                                <asp:TextBox ID="TB_TarikhEkspo2" runat="server"
                                                    Text='<%# Bind("TarikhEkspo2", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label class="form-label-custom">Masa Mula</label>
                                                <asp:TextBox ID="TB_MasaEkspo1" runat="server"
                                                    Text='<%# Bind("MasaEkspo1") %>' TextMode="Time" CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label class="form-label-custom">Masa Tamat</label>
                                                <asp:TextBox ID="TB_MasaEkspo2" runat="server"
                                                    Text='<%# Bind("MasaEkspo2") %>' TextMode="Time" CssClass="form-control" />
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="form-label-custom">Tentatif Program</label>
                                                <asp:TextBox ID="TB_TentatifEkspo" runat="server"
                                                    Text='<%# Bind("TentatifEkspo") %>' TextMode="MultiLine" Rows="3" CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="form-label-custom">Selebriti / Penceramah / Artis Terlibat</label>
                                                <asp:TextBox ID="TB_JemputanEkspo" runat="server"
                                                    Text='<%# Bind("JemputanEkspo") %>' TextMode="MultiLine" Rows="3" CssClass="form-control" />
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="form-label-custom">Kontraktor Pembersihan</label>
                                                <asp:TextBox ID="TB_PembersihanEkspo" runat="server"
                                                    Text='<%# Bind("PembersihanEkspo") %>' CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label class="form-label-custom">Tarikh Pasang Khemah</label>
                                                <asp:TextBox ID="TB_TarikhKhemahEkspo1" runat="server" TextMode="Date"
                                                    Text='<%# Bind("TarikhKhemahEkspo1", "{0:yyyy-MM-dd}") %>' CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label class="form-label-custom">Tarikh Buka Khemah</label>
                                                <asp:TextBox ID="TB_TarikhKhemahEkspo2" runat="server" TextMode="Date"
                                                    Text='<%# Bind("TarikhKhemahEkspo2", "{0:yyyy-MM-dd}") %>' CssClass="form-control" />
                                            </div>
                                        </div>
                                    </div>
                                </asp:Panel>

                                <asp:Panel ID="pnlrujukan" runat="server">
                                    <div class="form-section-header">
                                        <i class="bi bi-info-circle"></i>
                                        <span>Maklumat Rujukan &amp; Pentadbiran</span>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label class="form-label-custom">No Rujukan</label>
                                                <asp:TextBox ID="TB_Rujukan" runat="server"
                                                    Text='<%# Bind("Rujukan") %>' CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label class="form-label-custom">No Akaun Cukai</label>
                                                <asp:TextBox ID="TB_NoAkaunCukai" runat="server"
                                                    Text='<%# Bind("NoAkaunCukai") %>' CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label class="form-label-custom">Lokasi Fail</label>
                                                <asp:TextBox ID="TB_Remarks1" runat="server"
                                                    Text='<%# Bind("RemarksFail") %>' CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label class="form-label-custom">&nbsp;</label>
                                                <div class="checkbox-box">
                                                    <asp:CheckBox ID="CB_24h" Checked='<%# Bind("Is24jam") %>' runat="server" />
                                                    <span class="text-danger fw-bold">Kelulusan 24 jam?</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </asp:Panel>
                            </asp:Panel>

                            <div class="row my-2">
                                <div class="col-md-4 col-lg-3">
                                    <div class="checkbox-box">
                                        <asp:CheckBox ID="CB_Deposit" runat="server" Checked='<%# If(Eval("DepositAmount") Is DBNull.Value, False, True) %>' OnCheckedChanged="CB_Deposit_CheckedChanged" AutoPostBack="true" CausesValidation="false" />
                                        <span class="fw-bold text-dark">Ada Deposit?</span>
                                    </div>
                                </div>
                            </div>

                            <asp:Panel ID="pnldeposit" runat="server" Visible='<%# If(Eval("DepositAmount") Is DBNull.Value, False, True) %>'>
                                <div class="row">
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label class="form-label-custom">Amaun Deposit (RM)</label>
                                            <asp:TextBox ID="TB_Depo" runat="server"
                                                Text='<%# Bind("DepositAmount") %>' TextMode="Number" placeholder="00.00" CssClass="form-control" />
                                        </div>
                                    </div>

                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label class="form-label-custom">Tarikh Bayar Deposit</label>
                                            <asp:TextBox ID="TB_TarikhDepo" runat="server"
                                                Text='<%# Bind("DepositDate", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="form-control" />
                                        </div>
                                    </div>

                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label class="form-label-custom">No Resit</label>
                                            <asp:TextBox ID="TB_NoResit" runat="server"
                                                Text='<%# Bind("DepositResitNo") %>' CssClass="form-control" />
                                        </div>
                                    </div>
                                </div>
                            </asp:Panel>

                            <asp:Panel ID="pnldeposit1" runat="server" Visible='<%# If(Eval("IsBatal") = True And Eval("DepositAmount") IsNot DBNull.Value, True, False) %>'>
                                <div class="row">
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label class="form-label-custom">Amaun Pemulangan Wang Amanah (RM)</label>
                                            <asp:TextBox ID="TB_DepoPulang" runat="server"
                                                Text='<%# Bind("DepositPulangAmount") %>' TextMode="Number" placeholder="00.00" CssClass="form-control" />
                                        </div>
                                    </div>
                                </div>
                            </asp:Panel>

                            <asp:Panel ID="pnlbatal1" runat="server" Visible='<%# If(Eval("IsBatal") = False And Eval("StatusID") = 10, True, False) %>'>
                                <div class="row my-2">
                                    <div class="col-md-4 col-lg-3">
                                        <div class="checkbox-box border-danger-subtle bg-danger-subtle">
                                            <asp:CheckBox ID="CB_IsBatal" Checked='<%# Bind("IsBatal") %>' runat="server" OnCheckedChanged="CB_IsBatal_CheckedChanged" AutoPostBack="true" CausesValidation="false" />
                                            <span class="fw-bold text-danger">Pembatalan Permit / Lesen?</span>
                                        </div>
                                    </div>
                                </div>
                            </asp:Panel>

                            <asp:Panel ID="pnlbatal2" runat="server" Visible='<%# If(Eval("IsBatal") = True, True, False) %>' Enabled='<%# If(Eval("StatusID") = 10, True, False) %>'>
                                <div class="form-section-header danger-section">
                                    <i class="bi bi-x-circle"></i>
                                    <span>Maklumat Pembatalan</span>
                                </div>

                                <div class="row">
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label class="form-label-custom">Jenis Pembatalan <span class="text-danger">*</span></label>
                                            <asp:DropDownList ID="DDL_JenisBatal" Text='<%# Bind("JenisBatal") %>' runat="server" OnSelectedIndexChanged="DDL_JenisBatal_SelectedIndexChanged"
                                                CssClass="form-control select2" AutoPostBack="true" CausesValidation="false">
                                                <asp:ListItem Value="">-- Sila Pilih --</asp:ListItem>
                                                <asp:ListItem Value="1">Dengan Permohonan</asp:ListItem>
                                                <asp:ListItem Value="2">Tanpa Permohonan</asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator36" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="DDL_JenisBatal" ErrorMessage="Sila Pilih Jenis Pembatalan" ForeColor="Red" ValidationGroup="updateForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <asp:Panel ID="pnlbatal3" runat="server" Visible="false">
                                                <label class="form-label-custom">Sebab Pembatalan <span class="text-danger">*</span></label>
                                                <asp:DropDownList ID="DDL_SebabBatal1" Text='<%# Bind("SebabBatalPerm") %>' CssClass="form-control select2" runat="server"
                                                    DataSourceID="SqlDataSourceSebab1" DataTextField="name" DataValueField="id">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource runat="server" ID="SqlDataSourceSebab1" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                    SelectCommand="SELECT NULL AS id, '-- Sila Pilih --' AS name UNION ALL SELECT id, name 
                                                        FROM TBL_LOOKUPS WHERE lookupgrp_id = 10002 AND status = 1"></asp:SqlDataSource>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator32" runat="server" CssClass="cssRequiredField"
                                                    ControlToValidate="DDL_SebabBatal1" ErrorMessage="Sila Pilih Sebab" ForeColor="Red" ValidationGroup="updateForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                            </asp:Panel>

                                            <asp:Panel ID="pnlbatal4" runat="server" Visible="false">
                                                <label class="form-label-custom">Sebab Pembatalan <span class="text-danger">*</span></label>
                                                <asp:DropDownList ID="DDL_SebabBatal2" Text='<%# Bind("SebabBatalTanpaPerm") %>' CssClass="form-control select2" runat="server"
                                                    DataSourceID="SqlDataSourceSebab2" DataTextField="name" DataValueField="id">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource runat="server" ID="SqlDataSourceSebab2" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                    SelectCommand="SELECT NULL AS id, '-- Sila Pilih --' AS name UNION ALL SELECT id, name 
                                                        FROM TBL_LOOKUPS WHERE lookupgrp_id = 10003 AND status = 1"></asp:SqlDataSource>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator37" runat="server" CssClass="cssRequiredField"
                                                    ControlToValidate="DDL_SebabBatal2" ErrorMessage="Sila Pilih Sebab" ForeColor="Red" ValidationGroup="updateForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                            </asp:Panel>
                                        </div>
                                    </div>

                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label class="form-label-custom">Tindakan Pembatalan <span class="text-danger">*</span></label>
                                            <asp:DropDownList ID="DDL_TindakanBatal" Text='<%# Bind("TindakanBatal") %>' CssClass="form-control select2" runat="server"
                                                DataSourceID="SqlDataSourceTindakan" DataTextField="name" DataValueField="id">
                                            </asp:DropDownList>
                                            <asp:SqlDataSource runat="server" ID="SqlDataSourceTindakan" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                SelectCommand="SELECT NULL AS id, '-- Sila Pilih --' AS name UNION ALL SELECT id, name 
                                                    FROM TBL_LOOKUPS WHERE lookupgrp_id = 10005 AND status = 1"></asp:SqlDataSource>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator35" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="DDL_TindakanBatal" ErrorMessage="Sila Pilih Tindakan" ForeColor="Red" ValidationGroup="updateForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                </div>

                                <asp:Panel ID="pnlbatal5" runat="server" Visible="false">
                                    <div class="row">
                                        <div class="col-md-12">
                                            <div class="form-group">
                                                <label class="form-label-custom">Catatan Pembatalan</label>
                                                <asp:TextBox ID="TB_Remarks2" runat="server" TextMode="MultiLine" Rows="2"
                                                    Text='<%# Bind("RemarksBatal") %>' CssClass="form-control" />
                                            </div>
                                        </div>
                                    </div>
                                </asp:Panel>
                            </asp:Panel>

                        </div>
                        <div class="card-footer d-flex flex-wrap gap-2 align-items-center">
                            <asp:LinkButton runat="server" CssClass="btn btn-primary" ValidationGroup="updateForm" Text="Kemaskini" CommandName="Update" ID="UpdateFormButton" CausesValidation="True">
                                <i class="bi bi-check-lg me-1"></i> Kemaskini
                            </asp:LinkButton>
                            <asp:LinkButton runat="server" CssClass="btn btn-success text-white" Visible='<%# If(Eval("StatusID") = 0, True, False) %>' ValidationGroup="updateForm" Text="Hantar" ID="SubmitApproval" OnCommand="OnClickBtnSubmit" CausesValidation="False" OnClientClick="return confirm('Hantar ke jabatan agensi sekarang?');">
                                <i class="bi bi-send me-1"></i> Hantar
                            </asp:LinkButton>
                            <asp:LinkButton runat="server" CssClass="btn btn-info text-white" Visible='<%# If(Eval("StatusID") = 10 And Eval("JenisLesenIdList") <> "27", True, False) %>' Text='<%# If(Eval("IsBatal") = False, "Surat Kelulusan", "Surat Pembatalan") %>' ID="ViewSuratKelulusanPembatalan" OnCommand="OnClickSuratKelulusanPembatalan" CausesValidation="False">
                                <i class="bi bi-file-earmark-pdf me-1"></i> <%# If(Eval("IsBatal") = False, "Surat Kelulusan", "Surat Pembatalan") %>
                            </asp:LinkButton>
                            <asp:LinkButton runat="server" Text="Kembali" ID="BackButton" CausesValidation="False" CssClass="btn btn-outline-secondary" OnClick="BackButton_Click">
                                <i class="bi bi-arrow-left me-1"></i> Kembali
                            </asp:LinkButton>
                        </div>
                    </div>
                </EditItemTemplate>

                <InsertItemTemplate>
                    <div class="card card-primary">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h3 class="card-title mb-0 font-weight-bold text-white">
                                <i class="bi bi-file-earmark-plus me-2"></i>Kunci Masuk Permohonan
                            </h3>
                        </div>
                        <!-- /.card-header -->
                        <div class="card-body p-4">
                            <asp:HiddenField ID="HF_JenisLesenDescList" Value='<%# Bind("JenisLesenDescList") %>' runat="server" />
                            <asp:HiddenField ID="HF_JenisLesenIdList" Value='<%# Bind("JenisLesenIdList") %>' runat="server" />
                            <asp:HiddenField ID="HF_SaizIklanList" Value='<%# Bind("SaizIklanList") %>' runat="server" />
                            <asp:HiddenField ID="HF_CahayaIklanList" Value='<%# Bind("CahayaIklanList") %>' runat="server" />
                            <asp:HiddenField ID="HF_UnitIklanList" Value='<%# Bind("UnitIklanList") %>' runat="server" />
                            <asp:HiddenField ID="HF_LokasiList" Value='<%# Bind("LokasiList") %>' runat="server" />
                            <asp:HiddenField ID="HF_BakaAnjingList" Value='<%# Bind("BakaAnjingList") %>' runat="server" />
                            <asp:HiddenField ID="HF_AnjingJantanList" Value='<%# Bind("AnjingJantanList") %>' runat="server" />
                            <asp:HiddenField ID="HF_AnjingBetinaList" Value='<%# Bind("AnjingBetinaList") %>' runat="server" />
                            <asp:HiddenField ID="HF_AnjingJantanMandulList" Value='<%# Bind("AnjingJantanMandulList") %>' runat="server" />
                            <asp:HiddenField ID="HF_AnjingBetinaMandulList" Value='<%# Bind("AnjingBetinaMandulList") %>' runat="server" />

                            <!-- Section: Carian / Pemilihan Pemohon -->
                            <div class="form-section-header">
                                <i class="bi bi-person-badge"></i>
                                <span>Maklumat Pemohon</span>
                            </div>

                            <div class="row mb-3">
                                <div class="col-lg-8 col-md-10">
                                    <div class="form-group mb-0">
                                        <label class="form-label-custom">Pilih Pemohon <span class="text-danger">*</span></label>
                                        <div class="d-flex flex-wrap align-items-center gap-2">
                                            <div class="flex-grow-1" style="min-width: 280px;">
                                                <asp:DropDownList ID="ddl_Pemohon" CssClass="form-control select2" runat="server" OnSelectedIndexChanged="ddl_Pemohon_SelectedIndexChanged"
                                                    DataSourceID="SqlDataSourcePemohon" DataTextField="PemohonDesc" DataValueField="Pemohon_ID" AutoPostBack="true" CausesValidation="false">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource runat="server" ID="SqlDataSourcePemohon" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                    SelectCommand="SELECT NULL AS Pemohon_ID, '-- Sila Pilih --' AS PemohonDesc UNION ALL SELECT Pemohon_ID,  Pemohon_ICNo + ' - ' + Pemohon_Name AS PemohonDesc FROM LESEN_Pemohon WHERE Pemohon_IsActive = 1"></asp:SqlDataSource>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" CssClass="cssRequiredField"
                                                    ControlToValidate="ddl_Pemohon" ErrorMessage="Sila Pilih Pemohon" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                            </div>
                                            <asp:HyperLink runat="server" NavigateUrl="~/lesen/applicantregister.aspx?p_Id=3354&m_Id=3355" CssClass="btn btn-outline-primary d-inline-flex align-items-center">
                                                <i class="bi bi-person-plus me-1"></i> Daftar Pemohon Baru
                                            </asp:HyperLink>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <asp:Panel runat="server" ID="pnlpemohon" Visible="false">
                                <div class="row">
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label class="form-label-custom">Pemohon ID</label>
                                            <asp:TextBox ID="TB_PemohonID" runat="server" Enabled="false" Text='<%# Bind("Permohonan_PemohonID") %>' CssClass="form-control" />
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label-custom">Nama Pemohon</label>
                                            <asp:TextBox ID="TB_Name" runat="server" Enabled="false" Text="NULL" CssClass="form-control" />
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label class="form-label-custom">Warganegara</label>
                                            <asp:TextBox ID="TB_Nat" runat="server" Enabled="false" Text="NULL" CssClass="form-control" />
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label-custom">Alamat</label>
                                            <asp:TextBox ID="TB_Address" Enabled="false" runat="server"
                                                Text="NULL" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label-custom">Catatan</label>
                                            <asp:TextBox ID="TB_Remarks" Enabled="false" runat="server"
                                                Text="NULL" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                                        </div>
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-6 col-lg-5">
                                        <asp:LinkButton
                                            runat="server"
                                            ID="LinkButton7"
                                            CssClass="qr-box mt-1"
                                            OnClick="btnQrCode_Click"
                                            ToolTip="Print QR Code"
                                            CausesValidation="false">
                                            <div class="qr-icon">
                                                <i class="bi bi-qr-code"></i>
                                            </div>
                                            <div class="qr-text">
                                                <div class="qr-title">Kod QR Permohonan</div>
                                                <div class="qr-description">Imbas untuk melihat butiran permohonan</div>
                                            </div>
                                        </asp:LinkButton>
                                    </div>
                                </div>
                            </asp:Panel>

                            <!-- Section: Butiran Permohonan -->
                            <div class="form-section-header">
                                <i class="bi bi-card-checklist"></i>
                                <span>Maklumat Permohonan</span>
                            </div>

                            <div class="row">
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label class="form-label-custom">Tarikh Mohon <span class="text-danger">*</span></label>
                                        <asp:TextBox ID="TB_TarikhMohon" runat="server"
                                            Text='<%# Bind("TarikhMohon", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="form-control" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" CssClass="cssRequiredField"
                                            ControlToValidate="TB_TarikhMohon" ErrorMessage="Sila Pilih Tarikh" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </div>
                                </div>

                                <div class="col-md-9">
                                    <div class="form-group">
                                        <label class="form-label-custom">Jenis Lesen / Permit <span class="text-danger">*</span></label>
                                        <asp:DropDownList ID="ddlItems" runat="server" DataSourceID="SqlDataSource1" CssClass="form-control select2"
                                            DataTextField="JenisLesen_Description" DataValueField="JenisLesen_ID" AutoPostBack="true"
                                            OnSelectedIndexChanged="ddlItems_SelectedIndexChanged" AppendDataBoundItems="true" CausesValidation="false">
                                        </asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSource1" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                        SelectCommand="select * from 
                                        (select NULL as JenisLesen_ID, '-- Sila Pilih --' as JenisLesen_Description
                                        union all
                                        select JenisLesen_ID, JenisLesen_Description from LESEN_JenisLesen 
                                        where JenisLesen_IsActive=1 and JenisLesen_Description not like '%DAN%'
                                        ) as tbl1 order by JenisLesen_Description ">
                                        </asp:SqlDataSource>
                                    </div>

                                    <div class="tag-container d-flex flex-wrap gap-2 mt-2">
                                        <asp:Repeater ID="rptSelectedItems" runat="server" OnItemCommand="rptSelectedItems_ItemCommand">
                                            <ItemTemplate>
                                                <div class="tag-pill">
                                                    <span><%# Eval("ItemText") %></span>
                                                    <asp:LinkButton ID="btnRemove" runat="server" 
                                                        CommandName="Remove" 
                                                        CommandArgument='<%# Eval("ItemValue") %>' 
                                                        CssClass="btn-remove-tag"
                                                        ToolTip="Buang jenis lesen"
                                                        CausesValidation="false">&times;</asp:LinkButton>
                                                </div>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </div>
                                </div>
                            </div>

                            <%--# Perniagaan Berisiko dan tidak berisiko #--%>
                            <asp:Panel ID="pnlesen1" runat="server" Visible="False">
                                <div class="form-section-header">
                                    <i class="bi bi-shop"></i>
                                    <span>Maklumat Premis & Perniagaan</span>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label-custom">Nama Syarikat / Sediada <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="TB_NamaSyarikat" runat="server"
                                                Text='<%# Bind("NamaSyarikat") %>' CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_NamaSyarikat" ErrorMessage="Sila Isi Nama Syarikat" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label class="form-label-custom">No. Pendaftaran <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="TB_NoPendaftaran" runat="server"
                                                Text='<%# Bind("NoPendaftaran") %>' CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_NoPendaftaran" ErrorMessage="Sila Isi No. Pendaftaran" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label class="form-label-custom">No. Akaun Lesen</label>
                                            <asp:TextBox ID="TB_NoAkaun" runat="server"
                                                Text='<%# Bind("NoAkaun") %>' CssClass="form-control" />
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label-custom">Alamat Premis / Sediada <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="TB_AlamatPremis" runat="server"
                                                Text='<%# Bind("AlamatPremis") %>' TextMode="MultiLine" Rows="3" CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator10" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_AlamatPremis" ErrorMessage="Sila Isi Alamat Premis" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label-custom">Jenis Perniagaan / Sediada <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="TB_JenisPerniagaan" runat="server"
                                                Text='<%# Bind("JenisPerniagaan") %>' CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator11" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_JenisPerniagaan" ErrorMessage="Sila Isi Jenis Perniagaan" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                </div>

                                <%--# Tukar Pemilik #--%>
                                <asp:Panel ID="pnlesen1b" runat="server" Visible="False">
                                    <div class="form-section-header">
                                        <i class="bi bi-person-gear"></i>
                                        <span>Maklumat Pertukaran Pemilik</span>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="form-label-custom">Nama Pemilik Baru <span class="text-danger">*</span></label>
                                                <asp:TextBox ID="TB_PemilikBaru" runat="server"
                                                    Text='<%# Bind("PemilikBaru") %>' CssClass="form-control" />
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator12" runat="server" CssClass="cssRequiredField"
                                                    ControlToValidate="TB_PemilikBaru" ErrorMessage="Sila Isi Nama Pemilik Baru" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                            </div>
                                        </div>
                                    </div>
                                </asp:Panel>

                                <%--# Batal #--%>
                                <asp:Panel ID="pnlbatal" runat="server" Visible="False">
                                    <div class="form-section-header danger-section">
                                        <i class="bi bi-calendar-x"></i>
                                        <span>Tarikh Pembatalan</span>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label class="form-label-custom">Tarikh Batal</label>
                                                <asp:TextBox ID="TB_TarikhBatal" runat="server"
                                                    Text='<%# Bind("TarikhBatal", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="form-control" />
                                            </div>
                                        </div>
                                    </div>
                                </asp:Panel>

                                <%--# Tukar Alamat #--%>
                                <asp:Panel ID="pnlesen1c" runat="server" Visible="False">
                                    <div class="form-section-header">
                                        <i class="bi bi-geo-alt"></i>
                                        <span>Maklumat Pertukaran Alamat</span>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <asp:Label ID="Lbl_AlamatBaru" runat="server" Text="Alamat Baru" CssClass="form-label-custom" />
                                                <asp:TextBox ID="TB_AlamatBaru" runat="server"
                                                    Text='<%# Bind("AlamatBaru") %>' TextMode="MultiLine" Rows="3" CssClass="form-control" />
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator13" runat="server" CssClass="cssRequiredField"
                                                    ControlToValidate="TB_AlamatBaru" ErrorMessage="Sila Isi Alamat Baru" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                            </div>
                                        </div>
                                    </div>
                                </asp:Panel>

                                <%--# Tambah Jenis Perniagaan #--%>
                                <asp:Panel ID="pnlesen1d" runat="server" Visible="False">
                                    <div class="form-section-header">
                                        <i class="bi bi-plus-square"></i>
                                        <span>Tambah Jenis Perniagaan</span>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <asp:Label ID="Lbl_JenisPerniagaanBaru" runat="server" Text="Jenis Perniagaan Tambahan" CssClass="form-label-custom" />
                                                <asp:TextBox ID="TB_JenisPerniagaanBaru" runat="server"
                                                    Text='<%# Bind("JenisPerniagaanBaru") %>' CssClass="form-control" />
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator14" runat="server" CssClass="cssRequiredField"
                                                    ControlToValidate="TB_JenisPerniagaanBaru" ErrorMessage="Sila Isi Jenis Perniagaan Tambahan" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                            </div>
                                        </div>
                                    </div>
                                </asp:Panel>

                                <%--# Tukar Nama Syarikat #--%>
                                <asp:Panel ID="pnlesen1e" runat="server" Visible="False">
                                    <div class="form-section-header">
                                        <i class="bi bi-pencil"></i>
                                        <span>Tukar Nama Syarikat</span>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="form-label-custom">Nama Baru Syarikat <span class="text-danger">*</span></label>
                                                <asp:TextBox ID="TB_NamaBaruSyarikat" runat="server"
                                                    Text='<%# Bind("NamaBaruSyarikat") %>' CssClass="form-control" />
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator15" runat="server" CssClass="cssRequiredField"
                                                    ControlToValidate="TB_NamaBaruSyarikat" ErrorMessage="Sila Isi Nama Baru Syarikat" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                            </div>
                                        </div>
                                    </div>
                                </asp:Panel>
                            </asp:Panel>

                            <%--# Banting #--%>
                            <asp:Panel ID="pnlesen6" runat="server" Visible="False">
                                <div class="form-section-header">
                                    <i class="bi bi-flag"></i>
                                    <span>Maklumat Banting / Sepanduk</span>
                                </div>

                                <div class="row">
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label class="form-label-custom">Kategori <span class="text-danger">*</span></label>
                                            <asp:DropDownList ID="DDL_JenisBanting" Text='<%# Bind("JenisBanting") %>' runat="server" 
                                                CssClass="form-control select2">
                                                <asp:ListItem Value="">-- Sila Pilih --</asp:ListItem>
                                                <asp:ListItem Value="Banting">Banting</asp:ListItem>
                                                <asp:ListItem Value="Sepanduk">Sepanduk</asp:ListItem>
                                                <asp:ListItem Value="Sepanduk Besar">Sepanduk Besar</asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator42" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="DDL_JenisBanting" ErrorMessage="Sila Pilih Kategori" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                    <div class="col-md-5">
                                        <div class="form-group">
                                            <label class="form-label-custom">Nama Syarikat Kontraktor Pemasang Iklan</label>
                                            <asp:TextBox ID="TB_KontraktorIklan" runat="server"
                                                Text='<%# Bind("KontraktorIklan") %>' CssClass="form-control" />
                                        </div>
                                    </div>

                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label class="form-label-custom">No. Telefon Syarikat Kontraktor</label>
                                            <asp:TextBox ID="TB_NoTelKontraktor" runat="server"
                                                Text='<%# Bind("NoTelKontraktor") %>' CssClass="form-control" />
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label class="form-label-custom">Ukuran (Kaki)</label>
                                            <asp:TextBox ID="TB_UkuranBanting" runat="server"
                                                Text='<%# Bind("UkuranBanting") %>' placeholder="Contoh: 5x10" CssClass="form-control" />
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label class="form-label-custom">Bilangan Banting / Sepanduk</label>
                                            <asp:TextBox ID="TB_BilBanting" runat="server"
                                                Text='<%# Bind("BilBanting") %>' CssClass="form-control" />
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label class="form-label-custom">Tarikh Mula Pemasangan</label>
                                            <asp:TextBox ID="TB_TarikhBanting1" runat="server"
                                                Text='<%# Bind("TarikhBanting1", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="form-control" />
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label class="form-label-custom">Tarikh Akhir Pemasangan</label>
                                            <asp:TextBox ID="TB_TarikhBanting2" runat="server"
                                                Text='<%# Bind("TarikhBanting2", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="form-control" />
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-12">
                                        <div class="alert alert-info d-flex align-items-center py-2 px-3 mb-3 small">
                                            <i class="bi bi-info-circle-fill me-2 fs-6"></i>
                                            <div><strong>Peringatan:</strong> Penambahan senarai lokasi dan muat naik gambar banting hanya boleh dilakukan selepas maklumat permohonan disimpan.</div>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label class="form-label-custom">Status Kelulusan DBP <span class="text-danger">*</span></label>
                                            <asp:DropDownList ID="DDL_StatusDBP" Text='<%# Bind("StatusBanting") %>' runat="server" 
                                                CssClass="form-control select2">
                                                <asp:ListItem Value="">-- Sila Pilih --</asp:ListItem>
                                                <asp:ListItem Value="1">Lulus</asp:ListItem>
                                                <asp:ListItem Value="2">Tidak Diluluskan</asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="DDL_StatusDBP" ErrorMessage="Sila Pilih Status DBP" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label class="form-label-custom">No. Pengesahan DBP <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="TB_NoPengesahan" runat="server"
                                                Text='<%# Bind("NoPengesahanBanting") %>' CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator26" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_NoPengesahan" ErrorMessage="Sila Isi No. Pengesahan" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label class="form-label-custom">Tarikh Mula Pengesahan <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="TB_TarikhPengesahanBanting1" runat="server"
                                                Text='<%# Bind("TarikhPengesahanBanting1", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator30" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_TarikhPengesahanBanting1" ErrorMessage="Sila Pilih Tarikh Mula" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label class="form-label-custom">Tarikh Akhir Pengesahan <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="TB_TarikhPengesahanBanting2" runat="server"
                                                Text='<%# Bind("TarikhPengesahanBanting2", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator31" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_TarikhPengesahanBanting2" ErrorMessage="Sila Pilih Tarikh Akhir" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label class="form-label-custom">No. Resit <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="TB_NoResit1" runat="server"
                                                Text='<%# Bind("NoResitBanting") %>' CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator39" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_NoResit1" ErrorMessage="Sila Isi No. Resit" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label class="form-label-custom">No. Siri Stiker <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="TB_NoSiriStiker" runat="server"
                                                Text='<%# Bind("NoSiriStiker") %>' CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator40" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_NoSiriStiker" ErrorMessage="Sila Isi No. Siri Stiker" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label class="form-label-custom">Tarikh Resit</label>
                                            <asp:TextBox ID="TB_TarikhBanting3" runat="server"
                                                Text='<%# Bind("TarikhBanting3", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="form-control" />
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label class="form-label-custom">Bilangan Pembaharuan <span class="text-danger">*</span></label>
                                            <asp:DropDownList ID="DDL_RenewBanting" Text='<%# Bind("RenewBanting") %>' runat="server" 
                                                CssClass="form-control select2">
                                                <asp:ListItem Value="">-- Sila Pilih --</asp:ListItem>
                                                <asp:ListItem Value="1">Kali Pertama</asp:ListItem>
                                                <asp:ListItem Value="2">Kali Kedua</asp:ListItem>
                                                <asp:ListItem Value="3">Kali Ketiga</asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator41" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="DDL_RenewBanting" ErrorMessage="Sila Pilih Pembaharuan" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                </div>
                            </asp:Panel>

                            <%--# Papan iklan, Billboard #--%>
                            <asp:Panel ID="pnlesen1a" runat="server" Visible="False">
                                <div class="form-section-header">
                                    <i class="bi bi-badge-ad"></i>
                                    <span>Maklumat Papan Iklan</span>
                                </div>

                                <div class="row align-items-end">
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label class="form-label-custom">Saiz Iklan (cm)</label>
                                            <asp:TextBox ID="TB_SaizIklan1" placeholder="Contoh: 10x5" runat="server" CssClass="form-control" />
                                        </div>
                                    </div>

                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label class="form-label-custom">Iklan Bercahaya</label>
                                            <asp:DropDownList ID="DDL_Iklan1" runat="server" CssClass="form-control select2">
                                                <asp:ListItem Value="">-- Sila Pilih --</asp:ListItem>
                                                <asp:ListItem Value="Bercahaya">Ya</asp:ListItem>
                                                <asp:ListItem Value="Tidak Bercahaya">Tidak</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>

                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label class="form-label-custom">Bil. Unit</label>
                                            <div class="d-flex gap-2">
                                                <asp:TextBox ID="TB_UnitIklan1" runat="server" CssClass="form-control" />
                                                <asp:LinkButton ID="btnAddIklan" runat="server" CssClass="btn btn-primary d-inline-flex align-items-center text-nowrap" Text="Tambah" OnClick="btnAddIklan_Click" CausesValidation="false">
                                                    <i class="bi bi-plus-lg me-1"></i> Tambah
                                                </asp:LinkButton>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="row mt-2">
                                    <div class="col-md-12 col-lg-8">
                                        <asp:GridView ID="gvIklanList" runat="server" HeaderStyle-ForeColor="Black" CssClass="table table-bordered table-hover align-middle shadow-none" AutoGenerateColumns="False" 
                                            ShowHeaderWhenEmpty="true" EmptyDataText="Senarai kosong." OnRowDeleting="gvIklanList_RowDeleting">
                                            <Columns>
                                                <asp:BoundField DataField="SaizIklan" HeaderText="Saiz Iklan (cm)" />
                                                <asp:BoundField DataField="Bercahaya" HeaderText="Bercahaya / Tidak" />
                                                <asp:BoundField DataField="Unit" HeaderText="Bil. Unit" />
                                                <asp:TemplateField ItemStyle-Width="60px" ItemStyle-CssClass="text-center">
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="btnRemove" runat="server"  
                                                            CommandName="Delete" CssClass="btn btn-outline-danger btn-sm" ToolTip="Padam" CausesValidation="false">
                                                            <i class="bi bi-trash"></i>
                                                        </asp:LinkButton>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </div>
                                </div>
                            </asp:Panel>

                            <%--#  Billboard #--%>
                            <asp:Panel ID="pnlbillboard" runat="server" Visible="False">
                                <div class="form-section-header">
                                    <i class="bi bi-display"></i>
                                    <span>Maklumat Billboard</span>
                                </div>

                                <div class="row">
                                    <div class="col-md-8">
                                        <div class="form-group">
                                            <label class="form-label-custom">Lokasi Billboard <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="TB_BillboardLokasi" runat="server"
                                                Text='<%# Bind("BillboardLokasi") %>' TextMode="MultiLine" Rows="3" CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator20" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_BillboardLokasi" ErrorMessage="Sila Isi Lokasi Billboard" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                </div>
                            </asp:Panel>

                            <%--# Pasar Lambak #--%>
                            <asp:Panel ID="pnlesen2" runat="server" Visible="False">
                                <div class="form-section-header">
                                    <i class="bi bi-basket"></i>
                                    <span>Maklumat Pasar Lambak / Pagi / Malam</span>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label-custom">Lokasi Pasar #1 <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="TB_LokasiPasar1" runat="server"
                                                Text='<%# Bind("LokasiPasar1") %>' TextMode="MultiLine" Rows="2" CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator16" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_LokasiPasar1" ErrorMessage="Sila Isi Lokasi Pasar #1" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label-custom">Lokasi Pasar #2</label>
                                            <asp:TextBox ID="TB_LokasiPasar2" runat="server"
                                                Text='<%# Bind("LokasiPasar2") %>' TextMode="MultiLine" Rows="2" CssClass="form-control" />
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label-custom">Lokasi Pasar #3</label>
                                            <asp:TextBox ID="TB_LokasiPasar3" runat="server"
                                                Text='<%# Bind("LokasiPasar3") %>' TextMode="MultiLine" Rows="2" CssClass="form-control" />
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label-custom">Jenis Pasar <span class="text-danger">*</span></label>
                                            <asp:DropDownList ID="DDL_JenisPasar" Text='<%# Bind("JenisPasar") %>' runat="server" OnSelectedIndexChanged="DDL_JenisPasar_SelectedIndexChanged"
                                                CssClass="form-control select2" AutoPostBack="true" CausesValidation="false">
                                                <asp:ListItem Value="">-- Sila Pilih --</asp:ListItem>
                                                <asp:ListItem>Pasar Pagi</asp:ListItem>
                                                <asp:ListItem>Pasar Malam</asp:ListItem>
                                                <asp:ListItem>Pasar Lambak</asp:ListItem>
                                                <asp:ListItem>Pasar Sehari</asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator17" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="DDL_JenisPasar" ErrorMessage="Sila Pilih Jenis Pasar" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label-custom">Jenis Jualan <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="TB_JenisPerniagaanPasar" runat="server"
                                                Text='<%# Bind("JenisPerniagaanPasar") %>' CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator18" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_JenisPerniagaanPasar" ErrorMessage="Sila Isi Jenis Jualan" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label-custom">Jumlah Petak / Tapak / Lot <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="TB_JumlahPetak" runat="server"
                                                Text='<%# Bind("JumlahPetak") %>' CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator19" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_JumlahPetak" ErrorMessage="Sila Isi Jumlah Petak" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                </div>
                            </asp:Panel>

                            <%--# Anjing #--%>
                            <asp:Panel ID="pnlesen3" runat="server" Visible="False">
                                <div class="form-section-header">
                                    <i class="bi bi-shield-check"></i>
                                    <span>Maklumat Lesen Anjing</span>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label-custom">Alamat Lokasi <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="TB_AnjingAlamat" runat="server"
                                                Text='<%# Bind("AnjingAlamat") %>' TextMode="MultiLine" Rows="2" CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_AnjingAlamat" ErrorMessage="Sila Isi Alamat Lokasi" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label-custom">Jenis Premis <span class="text-danger">*</span></label>
                                            <asp:DropDownList ID="DDL_AnjingJenisPremis" Text='<%# Bind("AnjingJenisPremis") %>' CssClass="form-control select2" runat="server"
                                                DataSourceID="SqlDataSourceAnjingJenisPremis" DataTextField="name" DataValueField="id">
                                            </asp:DropDownList>
                                            <asp:SqlDataSource runat="server" ID="SqlDataSourceAnjingJenisPremis" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                SelectCommand="SELECT NULL AS id, '-- Sila Pilih --' AS name UNION ALL SELECT id, name 
                                                        FROM TBL_LOOKUPS WHERE lookupgrp_id = 10001 AND status = 1"></asp:SqlDataSource>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="DDL_AnjingJenisPremis" ErrorMessage="Sila Pilih Jenis Premis" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                </div>

                                <div class="row align-items-end">
                                    <div class="col-md-4 col-lg-3">
                                        <div class="form-group">
                                            <label class="form-label-custom">Jenis Baka</label>
                                            <asp:DropDownList ID="DDL_BakaAnjing1" CssClass="form-control select2" runat="server"
                                                DataSourceID="SqlDataSourceAnjingBaka1" DataTextField="name" DataValueField="id">
                                            </asp:DropDownList>
                                            <asp:SqlDataSource runat="server" ID="SqlDataSourceAnjingBaka1" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                SelectCommand="SELECT NULL AS id, '-- Sila Pilih --' AS name UNION ALL SELECT id, name 
                                                        FROM TBL_LOOKUPS WHERE lookupgrp_id = 10004 AND status = 1"></asp:SqlDataSource>
                                        </div>
                                    </div>

                                    <div class="col-md-4 col-lg-2">
                                        <div class="form-group">
                                            <label class="form-label-custom">Bil. Jantan</label>
                                            <asp:TextBox ID="TB_Jantan1" runat="server" TextMode="Number" CssClass="form-control" />
                                        </div>
                                    </div>

                                    <div class="col-md-4 col-lg-2">
                                        <div class="form-group">
                                            <label class="form-label-custom">Bil. Betina</label>
                                            <asp:TextBox ID="TB_Betina1" runat="server" TextMode="Number" CssClass="form-control" />
                                        </div>
                                    </div>

                                    <div class="col-md-6 col-lg-2">
                                        <div class="form-group">
                                            <label class="form-label-custom">Bil. Jantan Mandul</label>
                                            <asp:TextBox ID="TB_JantanMandul1" runat="server" TextMode="Number" CssClass="form-control" />
                                        </div>
                                    </div>

                                    <div class="col-md-6 col-lg-3">
                                        <div class="form-group">
                                            <label class="form-label-custom">Bil. Betina Mandul</label>
                                            <div class="d-flex gap-2">
                                                <asp:TextBox ID="TB_BetinaMandul1" runat="server" TextMode="Number" CssClass="form-control" />
                                                <asp:LinkButton ID="btnAddAnjing" runat="server" CssClass="btn btn-primary d-inline-flex align-items-center text-nowrap" Text="Tambah" OnClick="btnAddAnjing_Click" CausesValidation="false">
                                                    <i class="bi bi-plus-lg me-1"></i> Tambah
                                                </asp:LinkButton>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="row mt-2">
                                    <div class="col-md-12">
                                        <asp:GridView ID="gvAnjingList" runat="server" HeaderStyle-ForeColor="Black" CssClass="table table-bordered table-hover align-middle shadow-none" AutoGenerateColumns="False" 
                                            ShowHeaderWhenEmpty="true" EmptyDataText="Senarai kosong." OnRowDeleting="gvAnjingList_RowDeleting">
                                            <Columns>
                                                <asp:BoundField DataField="Baka" HeaderText="Baka Anjing" />
                                                <asp:BoundField DataField="Jantan" HeaderText="Bil. Jantan" />
                                                <asp:BoundField DataField="Betina" HeaderText="Bil. Betina" />
                                                <asp:BoundField DataField="JantanMandul" HeaderText="Bil. Jantan Mandul" />
                                                <asp:BoundField DataField="BetinaMandul" HeaderText="Bil. Betina Mandul" />
                                                <asp:TemplateField ItemStyle-Width="60px" ItemStyle-CssClass="text-center">
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="btnRemove" runat="server"  
                                                            CommandName="Delete" CssClass="btn btn-outline-danger btn-sm" ToolTip="Padam" CausesValidation="false">
                                                            <i class="bi bi-trash"></i>
                                                        </asp:LinkButton>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </div>
                                </div>
                            </asp:Panel>

                            <%--# Penjaja #--%>
                            <asp:Panel ID="pnlesen4" runat="server" Visible="False">
                                <div class="form-section-header">
                                    <i class="bi bi-truck"></i>
                                    <span>Maklumat Penjaja</span>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label-custom">Jenis Penjaja</label>
                                            <asp:DropDownList ID="DDL_JenisPenjaja" CssClass="form-control select2" runat="server"
                                                DataSourceID="SqlDataSourceJenisPenjaja" DataTextField="name" DataValueField="id">
                                            </asp:DropDownList>
                                            <asp:SqlDataSource runat="server" ID="SqlDataSourceJenisPenjaja" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                SelectCommand="SELECT NULL AS id, '-- Sila Pilih --' AS name UNION ALL SELECT id, name 
                                                        FROM TBL_LOOKUPS WHERE lookupgrp_id = 10006 AND status = 1"></asp:SqlDataSource>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label-custom">Status Tanah</label>
                                            <asp:DropDownList ID="DDL_StatusTanahPenjaja" CssClass="form-control select2" runat="server"
                                                DataSourceID="SqlDataSourceStatusTanahPenjaja" DataTextField="name" DataValueField="id">
                                            </asp:DropDownList>
                                            <asp:SqlDataSource runat="server" ID="SqlDataSourceStatusTanahPenjaja" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                SelectCommand="SELECT NULL AS id, '-- Sila Pilih --' AS name UNION ALL SELECT id, name 
                                                        FROM TBL_LOOKUPS WHERE lookupgrp_id = 10007 AND status = 1"></asp:SqlDataSource>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label-custom">Alamat Aktiviti Penjajaan <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="TB_AlamatPenjajaan" runat="server"
                                                Text='<%# Bind("AlamatPenjajaan") %>' TextMode="MultiLine" Rows="2" CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator21" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_AlamatPenjajaan" ErrorMessage="Sila Isi Alamat Aktiviti" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label-custom">Jenis Jualan <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="TB_JenisPerniagaanPenjaja" runat="server"
                                                Text='<%# Bind("JenisPerniagaanPenjaja") %>' CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator22" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_JenisPerniagaanPenjaja" ErrorMessage="Sila Isi Jenis Jualan" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label class="form-label-custom">Masa Mula Jualan <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="TB_MasaPenjaja1" runat="server" TextMode="Time"
                                                Text='<%# Bind("MasaPenjaja1") %>' CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_MasaPenjaja1" ErrorMessage="Sila Isi Masa Mula" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label class="form-label-custom">Masa Tamat Jualan <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="TB_MasaPenjaja2" runat="server" TextMode="Time"
                                                Text='<%# Bind("MasaPenjaja2") %>' CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_MasaPenjaja2" ErrorMessage="Sila Isi Masa Tamat" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label class="form-label-custom">Jenis Kenderaan</label>
                                            <asp:DropDownList ID="DDL_JenisKenderaanPenjaja" CssClass="form-control select2" runat="server"
                                                DataSourceID="SqlDataSourceJenisKenderaanPenjaja" DataTextField="name" DataValueField="id">
                                            </asp:DropDownList>
                                            <asp:SqlDataSource runat="server" ID="SqlDataSourceJenisKenderaanPenjaja" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                SelectCommand="SELECT NULL AS id, '-- Sila Pilih --' AS name UNION ALL SELECT id, name 
                                                        FROM TBL_LOOKUPS WHERE lookupgrp_id = 10008 AND status = 1"></asp:SqlDataSource>
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label class="form-label-custom">No. Pendaftaran Kenderaan</label>
                                            <asp:TextBox ID="TB_NoKenderaanPenjaja" runat="server" 
                                                Text='<%# Bind("NoKenderaanPenjaja") %>' CssClass="form-control" />
                                        </div>
                                    </div>
                                </div>
                            </asp:Panel>

                            <%--# Ekspo #--%>
                            <asp:Panel ID="pnlesen5" runat="server" Visible="False">
                                <div class="form-section-header">
                                    <i class="bi bi-calendar-event"></i>
                                    <span>Maklumat Ekspo / Program</span>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label-custom">Nama Penganjur <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="TB_PenganjurEkspo" runat="server"
                                                Text='<%# Bind("PenganjurEkspo") %>' CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator23" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_PenganjurEkspo" ErrorMessage="Sila Isi Nama Penganjur" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label-custom">Alamat Penganjur</label>
                                            <asp:TextBox ID="TB_AlamatPenganjurEkspo" runat="server"
                                                Text='<%# Bind("AlamatPenganjurEkspo") %>' TextMode="MultiLine" Rows="2" CssClass="form-control" />
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label-custom">PIC Penganjur</label>
                                            <asp:TextBox ID="TB_PicEkspo" runat="server"
                                                Text='<%# Bind("PicEkspo") %>' CssClass="form-control" />
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label-custom">No. Telefon</label>
                                            <asp:TextBox ID="TB_NoTel" runat="server"
                                                Text='<%# Bind("NoTelEkspo") %>' CssClass="form-control" />
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label-custom">Nama Aktiviti / Program <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="TB_NamaEkspo" runat="server"
                                                Text='<%# Bind("NamaEkspo") %>' CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator24" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_NamaEkspo" ErrorMessage="Sila Isi Nama Program" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label-custom">Lokasi Program <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="TB_LokasiEkspo" runat="server"
                                                Text='<%# Bind("LokasiEkspo") %>' TextMode="MultiLine" Rows="2" CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator25" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_LokasiEkspo" ErrorMessage="Sila Isi Lokasi Program" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label class="form-label-custom">Tarikh Mula <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="TB_TarikhEkspo1" runat="server"
                                                Text='<%# Bind("TarikhEkspo1", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator27" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_TarikhEkspo1" ErrorMessage="Sila Pilih Tarikh Mula" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label class="form-label-custom">Tarikh Tamat <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="TB_TarikhEkspo2" runat="server"
                                                Text='<%# Bind("TarikhEkspo2", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator28" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_TarikhEkspo2" ErrorMessage="Sila Pilih Tarikh Tamat" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label class="form-label-custom">Masa Mula</label>
                                            <asp:TextBox ID="TB_MasaEkspo1" runat="server"
                                                Text='<%# Bind("MasaEkspo1") %>' TextMode="Time" CssClass="form-control" />
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label class="form-label-custom">Masa Tamat</label>
                                            <asp:TextBox ID="TB_MasaEkspo2" runat="server"
                                                Text='<%# Bind("MasaEkspo2") %>' TextMode="Time" CssClass="form-control" />
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label-custom">Tentatif Program</label>
                                            <asp:TextBox ID="TB_TentatifEkspo" runat="server"
                                                Text='<%# Bind("TentatifEkspo") %>' TextMode="MultiLine" Rows="2" CssClass="form-control" />
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label-custom">Selebriti / Artis Terlibat</label>
                                            <asp:TextBox ID="TB_JemputanEkspo" runat="server"
                                                Text='<%# Bind("JemputanEkspo") %>' TextMode="MultiLine" Rows="2" CssClass="form-control" />
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label-custom">Kontraktor Pembersihan</label>
                                            <asp:TextBox ID="TB_PembersihanEkspo" runat="server"
                                                Text='<%# Bind("PembersihanEkspo") %>' CssClass="form-control" />
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label class="form-label-custom">Tarikh Pasang Khemah</label>
                                            <asp:TextBox ID="TB_TarikhKhemahEkspo1" runat="server" TextMode="Date"
                                                Text='<%# Bind("TarikhKhemahEkspo1", "{0:yyyy-MM-dd}") %>' CssClass="form-control" />
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label class="form-label-custom">Tarikh Buka Khemah</label>
                                            <asp:TextBox ID="TB_TarikhKhemahEkspo2" runat="server" TextMode="Date"
                                                Text='<%# Bind("TarikhKhemahEkspo2", "{0:yyyy-MM-dd}") %>' CssClass="form-control" />
                                        </div>
                                    </div>
                                </div>
                            </asp:Panel>

                            <%--# Pentadbiran & Rujukan #--%>
                            <asp:Panel ID="pnlrujukan" runat="server" Visible="False">
                                <div class="form-section-header">
                                    <i class="bi bi-file-earmark-text"></i>
                                    <span>Maklumat Pentadbiran & Rujukan</span>
                                </div>

                                <div class="row">
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label class="form-label-custom">No. Rujukan <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="TB_Rujukan" runat="server"
                                                Text='<%# Bind("Rujukan") %>' CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator29" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_Rujukan" ErrorMessage="Sila Isi No. Rujukan" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label class="form-label-custom">No. Akaun Cukai <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="TB_NoAkaunCukai" runat="server"
                                                Text='<%# Bind("NoAkaunCukai") %>' CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator33" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_NoAkaunCukai" ErrorMessage="Sila Isi No. Akaun Cukai" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label class="form-label-custom">Lokasi Fail</label>
                                            <asp:TextBox ID="TB_Remarks1" runat="server" TextMode="MultiLine" Rows="2"
                                                Text='<%# Bind("RemarksFail") %>' CssClass="form-control" />
                                        </div>
                                    </div>
                                </div>

                                <div class="row my-2 g-3">
                                    <div class="col-md-6 col-lg-3">
                                        <div class="checkbox-box">
                                            <asp:CheckBox ID="CB_24h" Checked='<%# Bind("Is24jam") %>' runat="server" />
                                            <span class="text-danger fw-bold">Kelulusan 24 Jam?</span>
                                        </div>
                                    </div>

                                    <div class="col-md-6 col-lg-3">
                                        <div class="checkbox-box">
                                            <asp:CheckBox ID="CB_Deposit" runat="server" OnCheckedChanged="CB_Deposit_CheckedChanged" AutoPostBack="true" CausesValidation="false" />
                                            <span class="fw-bold text-dark">Ada Deposit?</span>
                                        </div>
                                    </div>
                                </div>
                            </asp:Panel>

                            <%--# Deposit #--%>
                            <asp:Panel ID="pnldeposit" runat="server" Visible="False">
                                <div class="form-section-header">
                                    <i class="bi bi-cash-stack"></i>
                                    <span>Maklumat Deposit</span>
                                </div>

                                <div class="row">
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label class="form-label-custom">Amaun Deposit (RM) <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="TB_Depo" runat="server"
                                                Text='<%# Bind("DepositAmount") %>' TextMode="Number" placeholder="00.00" CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator34" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_Depo" ErrorMessage="Sila Isi Amaun Deposit" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label class="form-label-custom">Tarikh Bayar Deposit</label>
                                            <asp:TextBox ID="TB_TarikhDepo" runat="server"
                                                Text='<%# Bind("DepositDate", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="form-control" />
                                        </div>
                                    </div>

                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label class="form-label-custom">No. Resit</label>
                                            <asp:TextBox ID="TB_NoResit" runat="server"
                                                Text='<%# Bind("DepositResitNo") %>' CssClass="form-control" />
                                        </div>
                                    </div>
                                </div>
                            </asp:Panel>

                            <asp:Panel ID="pnldeposit1" runat="server" Visible="False">
                                <div class="row">
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label class="form-label-custom">Amaun Pemulangan Wang Amanah (RM)</label>
                                            <asp:TextBox ID="TB_DepoPulang" runat="server"
                                                Text='<%# Bind("DepositPulangAmount") %>' TextMode="Number" placeholder="00.00" CssClass="form-control" />
                                        </div>
                                    </div>
                                </div>
                            </asp:Panel>

                            <%--# Pembatalan #--%>
                            <asp:Panel ID="pnlbatal1" runat="server" Visible="false">
                                <div class="row my-2">
                                    <div class="col-md-6 col-lg-4">
                                        <div class="checkbox-box border-danger-subtle bg-danger-subtle">
                                            <asp:CheckBox ID="CB_IsBatal" Checked='<%# Bind("IsBatal") %>' runat="server" OnCheckedChanged="CB_IsBatal_CheckedChanged" AutoPostBack="true" CausesValidation="false" />
                                            <span class="fw-bold text-danger">Pembatalan Permit / Lesen?</span>
                                        </div>
                                    </div>
                                </div>
                            </asp:Panel>

                            <asp:Panel ID="pnlbatal2" runat="server" Visible="false">
                                <div class="form-section-header danger-section">
                                    <i class="bi bi-x-circle"></i>
                                    <span>Maklumat Pembatalan</span>
                                </div>

                                <div class="row">
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label class="form-label-custom">Jenis Pembatalan <span class="text-danger">*</span></label>
                                            <asp:DropDownList ID="DDL_JenisBatal" runat="server" Text='<%# Bind("JenisBatal") %>' OnSelectedIndexChanged="DDL_JenisBatal_SelectedIndexChanged" AutoPostBack="true" CausesValidation="false"
                                                CssClass="form-control select2">
                                                <asp:ListItem Value="">-- Sila Pilih --</asp:ListItem>
                                                <asp:ListItem Value="1">Dengan Permohonan</asp:ListItem>
                                                <asp:ListItem Value="2">Tanpa Permohonan</asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator36" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="DDL_JenisBatal" ErrorMessage="Sila Pilih Jenis Pembatalan" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <asp:Panel ID="pnlbatal3" runat="server" Visible="false">
                                                <label class="form-label-custom">Sebab Pembatalan <span class="text-danger">*</span></label>
                                                <asp:DropDownList ID="DDL_SebabBatal1" Text='<%# Bind("SebabBatalPerm") %>' CssClass="form-control select2" runat="server"
                                                    DataSourceID="SqlDataSourceSebab1" DataTextField="name" DataValueField="id">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource runat="server" ID="SqlDataSourceSebab1" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                    SelectCommand="SELECT NULL AS id, '-- Sila Pilih --' AS name UNION ALL SELECT id, name 
                                                        FROM TBL_LOOKUPS WHERE lookupgrp_id = 10002 AND status = 1"></asp:SqlDataSource>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator38" runat="server" CssClass="cssRequiredField"
                                                    ControlToValidate="DDL_SebabBatal1" ErrorMessage="Sila Pilih Sebab Pembatalan" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                            </asp:Panel>

                                            <asp:Panel ID="pnlbatal4" runat="server" Visible="false">
                                                <label class="form-label-custom">Sebab Pembatalan <span class="text-danger">*</span></label>
                                                <asp:DropDownList ID="DDL_SebabBatal2" Text='<%# Bind("SebabBatalTanpaPerm") %>' CssClass="form-control select2" runat="server"
                                                    DataSourceID="SqlDataSourceSebab2" DataTextField="name" DataValueField="id">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource runat="server" ID="SqlDataSourceSebab2" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                    SelectCommand="SELECT NULL AS id, '-- Sila Pilih --' AS name UNION ALL SELECT id, name 
                                                        FROM TBL_LOOKUPS WHERE lookupgrp_id = 10003 AND status = 1"></asp:SqlDataSource>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator37" runat="server" CssClass="cssRequiredField"
                                                    ControlToValidate="DDL_SebabBatal2" ErrorMessage="Sila Pilih Sebab Pembatalan" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                            </asp:Panel>
                                        </div>
                                    </div>

                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label class="form-label-custom">Tindakan Pembatalan <span class="text-danger">*</span></label>
                                            <asp:DropDownList ID="DDL_TindakanBatal" Text='<%# Bind("TindakanBatal") %>' CssClass="form-control select2" runat="server"
                                                DataSourceID="SqlDataSourceTindakan" DataTextField="name" DataValueField="id">
                                            </asp:DropDownList>
                                            <asp:SqlDataSource runat="server" ID="SqlDataSourceTindakan" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                SelectCommand="SELECT NULL AS id, '-- Sila Pilih --' AS name UNION ALL SELECT id, name 
                                                    FROM TBL_LOOKUPS WHERE lookupgrp_id = 10005 AND status = 1"></asp:SqlDataSource>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator35" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="DDL_TindakanBatal" ErrorMessage="Sila Pilih Tindakan Pembatalan" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                </div>

                                <asp:Panel ID="pnlbatal5" runat="server" Visible="false">
                                    <div class="row">
                                        <div class="col-md-12">
                                            <div class="form-group">
                                                <label class="form-label-custom">Catatan Pembatalan</label>
                                                <asp:TextBox ID="TB_Remarks2" runat="server" TextMode="MultiLine" Rows="2"
                                                    Text='<%# Bind("RemarksBatal") %>' CssClass="form-control" />
                                            </div>
                                        </div>
                                    </div>
                                </asp:Panel>
                            </asp:Panel>

                        </div>
                        <div class="card-footer d-flex flex-wrap gap-2 align-items-center">
                            <asp:LinkButton runat="server" CssClass="btn btn-primary" ValidationGroup="insertForm" Text="Simpan" CommandName="Insert" ID="LinkButton1" CausesValidation="True">
                                <i class="bi bi-save me-1"></i> Simpan
                            </asp:LinkButton>
                            <asp:LinkButton runat="server" Text="Kembali" ID="BackButton" CausesValidation="False" CssClass="btn btn-outline-secondary" OnClick="BackButton_Click">
                                <i class="bi bi-arrow-left me-1"></i> Kembali
                            </asp:LinkButton>
                        </div>
                    </div>
                </InsertItemTemplate>
                <ItemTemplate></ItemTemplate>
            </asp:FormView>

                        <%-- =========================================================================
                 SECTION 2: Modal QR Code
                 ========================================================================= --%>
            <!-- Modal QR Code -->
            <div class="modal fade" id="modalQrCode" tabindex="-1" role="dialog" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">QR Code</h5>
                                                                
                            
                        </div>
                        <div class="modal-body text-center" id="qrPrintArea">
                            <asp:Image runat="server" ID="imgQrCode" Visible="false" CssClass="img-fluid" Style="max-width: 250px;" />
                        </div>
                        <div class="modal-footer justify-content-center">
                            <button type="button" class="btn btn-primary" onclick="printQrOnly()">
                                <i class="fas fa-print"></i> Cetak
                            </button>
                            <button type="button" class="btn btn-secondary" onclick="closeQrModal()">Tutup</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal QR Code Banting -->
            <div class="modal fade" id="modalBantingQrCode" tabindex="-1" role="dialog" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title font-weight-bold">
                                Kod QR Banting / Sepanduk
                            </h5>
                        </div>
                        <div class="modal-body text-center" id="bantingQrPrintArea">
                            <asp:Image runat="server" ID="imgBantingModalQr" Visible="false" CssClass="img-fluid" Style="max-width: 250px;" AlternateText="Kod QR Banting" />
                        </div>
                        <div class="modal-footer justify-content-center">
                            <button type="button" class="btn btn-primary" onclick="printBantingQrOnly()">
                                <i class="fas fa-print"></i>Cetak</button>
                            <button type="button" class="btn btn-secondary" onclick="closeBantingQrModal()">Tutup</button>
                        </div>
                    </div>
                </div>
            </div>

                        <%-- =========================================================================
                 SECTION 3: SqlDataSourceForm (Insert / Update / Select)
                 ========================================================================= --%>
            <asp:SqlDataSource runat="server" ID="SqlDataSourceForm" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                InsertCommand="INSERT INTO LESEN_Permohonan(JenisLesenDescList, JenisLesenIdList, SaizIklanList, CahayaIklanList, UnitIklanList, LokasiList, 
                        Permohonan_PemohonID, TarikhMohon, JenisLesen_ID, StatusID, NamaSyarikat, NoPendaftaran, NoAkaun, AlamatPremis, JenisPerniagaan,
                        PemilikBaru, AlamatBaru, JenisPerniagaanBaru, NamaBaruSyarikat, BillboardLokasi, LokasiPasar1, LokasiPasar2, LokasiPasar3, JenisPasar,
                        JenisPerniagaanPasar, JumlahPetak, AnjingAlamat, AnjingJenisPremis, JenisPenjaja, StatusTanahPenjaja, AlamatPenjajaan, JenisPerniagaanPenjaja, MasaPenjaja1, MasaPenjaja2,
                        JenisKenderaanPenjaja, NoKenderaanPenjaja, TarikhBatal, PenganjurEkspo, AlamatPenganjurEkspo, PicEkspo, NoTelEkspo, NamaEkspo, LokasiEkspo, TarikhEkspo1, TarikhEkspo2, MasaEkspo1, MasaEkspo2, 
                        TentatifEkspo, JemputanEkspo, PembersihanEkspo, TarikhKhemahEkspo1, TarikhKhemahEkspo2, 
                        KontraktorIklan, NoTelKontraktor, UkuranBanting, BilBanting, TarikhBanting1, TarikhBanting2, StatusBanting, NoPengesahanBanting, TarikhPengesahanBanting1, TarikhPengesahanBanting2, NoResitBanting, NoSiriStiker, 
                        TarikhBanting3, RenewBanting, JenisBanting, 
                        Rujukan, NoAkaunCukai, DepositAmount, DepositDate, DepositResitNo, DepositPulangAmount, 
                        Is24jam, IsBatal, JenisBatal, SebabBatalPerm, SebabBatalTanpaPerm, RemarksBatal, TindakanBatal, IsPulang, IsSuratKelulusanFail, IsSuratPembatalanFail, IsSuratPemeriksaanFail, RemarksFail, CreatorID, CreatedDt, LastModID, LastModDt) 
                        VALUES (@JenisLesenDescList, @JenisLesenIdList, @SaizIklanList, @CahayaIklanList, @UnitIklanList, @LokasiList, 
                        @Permohonan_PemohonID, @TarikhMohon, 0, 0, @NamaSyarikat, @NoPendaftaran, @NoAkaun, @AlamatPremis, @JenisPerniagaan, @PemilikBaru, @AlamatBaru,
                        @JenisPerniagaanBaru, @NamaBaruSyarikat, @BillboardLokasi, @LokasiPasar1, @LokasiPasar2, @LokasiPasar3, @JenisPasar, @JenisPerniagaanPasar,
                        @JumlahPetak, @AnjingAlamat, @AnjingJenisPremis, @JenisPenjaja, @StatusTanahPenjaja, @AlamatPenjajaan, @JenisPerniagaanPenjaja, @MasaPenjaja1, @MasaPenjaja2, @JenisKenderaanPenjaja, @NoKenderaanPenjaja,
                        @TarikhBatal, @PenganjurEkspo, @AlamatPenganjurEkspo, @PicEkspo, @NoTelEkspo, @NamaEkspo, @LokasiEkspo, @TarikhEkspo1, @TarikhEkspo2, @MasaEkspo1, @MasaEkspo2, 
                        @TentatifEkspo, @JemputanEkspo, @PembersihanEkspo, @TarikhKhemahEkspo1, @TarikhKhemahEkspo2, 
                        @KontraktorIklan, @NoTelKontraktor, @UkuranBanting, @BilBanting, @TarikhBanting1, @TarikhBanting2, @StatusBanting, @NoPengesahanBanting, @TarikhPengesahanBanting1, @TarikhPengesahanBanting2, @NoResitBanting, @NoSiriStiker, 
                        @TarikhBanting3, @RenewBanting, @JenisBanting,
                        @Rujukan, @NoAkaunCukai, @DepositAmount, @DepositDate, @DepositResitNo, @DepositPulangAmount, 
                        @Is24jam, @IsBatal, @JenisBatal, @SebabBatalPerm, @SebabBatalTanpaPerm, @RemarksBatal, @TindakanBatal, 0, 0, 0, 0, @RemarksFail, @CreatorId, GETDATE(), @CreatorId, GETDATE()); SELECT @Permohonan_ID = SCOPE_IDENTITY();"
                SelectCommand="SELECT * FROM LESEN_Permohonan WHERE Permohonan_ID = @Permohonan_ID"
                UpdateCommand="UPDATE LESEN_Permohonan SET JenisLesenDescList = @JenisLesenDescList, JenisLesenIdList = @JenisLesenIdList, SaizIklanList = @SaizIklanList, CahayaIklanList = @CahayaIklanList, UnitIklanList = @UnitIklanList, LokasiList = @LokasiList, 
                        Permohonan_PemohonID = @Permohonan_PemohonID, TarikhMohon = @TarikhMohon, NamaSyarikat = @NamaSyarikat, NoPendaftaran = @NoPendaftaran, NoAkaun = @NoAkaun, AlamatPremis = @AlamatPremis, 
                        JenisPerniagaan = @JenisPerniagaan, PemilikBaru = @PemilikBaru, AlamatBaru = @AlamatBaru, JenisPerniagaanBaru = @JenisPerniagaanBaru, NamaBaruSyarikat = @NamaBaruSyarikat,  
                        BillboardLokasi = @BillboardLokasi, LokasiPasar1 = @LokasiPasar1, LokasiPasar2 = @LokasiPasar2, LokasiPasar3 = @LokasiPasar3,
                        JenisPasar = @JenisPasar, JenisPerniagaanPasar = @JenisPerniagaanPasar, JumlahPetak = @JumlahPetak, AnjingAlamat = @AnjingAlamat, AnjingJenisPremis = @AnjingJenisPremis, JenisPenjaja = @JenisPenjaja, StatusTanahPenjaja = @StatusTanahPenjaja,
                        AlamatPenjajaan = @AlamatPenjajaan, JenisPerniagaanPenjaja = @JenisPerniagaanPenjaja, MasaPenjaja1 = @MasaPenjaja1, MasaPenjaja2 = @MasaPenjaja2, JenisKenderaanPenjaja = @JenisKenderaanPenjaja, NoKenderaanPenjaja = @NoKenderaanPenjaja,
                        TarikhBatal = @TarikhBatal, PenganjurEkspo = @PenganjurEkspo, AlamatPenganjurEkspo = @AlamatPenganjurEkspo, PicEkspo = @PicEkspo, NoTelEkspo = @NoTelEkspo, NamaEkspo = @NamaEkspo, LokasiEkspo = @LokasiEkspo, 
                        TarikhEkspo1 = @TarikhEkspo1, TarikhEkspo2 = @TarikhEkspo2, MasaEkspo1 = @MasaEkspo1, MasaEkspo2 = @MasaEkspo2, TentatifEkspo = @TentatifEkspo, JemputanEkspo = @JemputanEkspo, PembersihanEkspo = @PembersihanEkspo, 
                        TarikhKhemahEkspo1 = @TarikhKhemahEkspo1, TarikhKhemahEkspo2 = @TarikhKhemahEkspo2, 
                        KontraktorIklan = @KontraktorIklan, NoTelKontraktor = @NoTelKontraktor, UkuranBanting = @UkuranBanting, BilBanting = @BilBanting, TarikhBanting1 = @TarikhBanting1, TarikhBanting2 = @TarikhBanting2, StatusBanting = @StatusBanting, 
                        NoPengesahanBanting = @NoPengesahanBanting, TarikhPengesahanBanting1 = @TarikhPengesahanBanting1, TarikhPengesahanBanting2 = @TarikhPengesahanBanting2, NoResitBanting = @NoResitBanting, NoSiriStiker = @NoSiriStiker, 
                        TarikhBanting3 = @TarikhBanting3, RenewBanting = @RenewBanting, JenisBanting = @JenisBanting, 
                        Rujukan = @Rujukan, NoAkaunCukai = @NoAkaunCukai, DepositAmount = @DepositAmount, 
                        DepositDate = @DepositDate, DepositResitNo = @DepositResitNo, DepositPulangAmount = @DepositPulangAmount, Is24jam = @Is24jam, IsBatal = @IsBatal, JenisBatal = @JenisBatal, SebabBatalPerm = @SebabBatalPerm, 
                        SebabBatalTanpaPerm = @SebabBatalTanpaPerm, RemarksBatal = @RemarksBatal, TindakanBatal = @TindakanBatal, RemarksFail = @RemarksFail, LastModId = @LastModId, LastModDt = GETDATE() 
                        WHERE (Permohonan_ID = @Permohonan_ID)">
                <InsertParameters>
                    <asp:Parameter Name="JenisLesenDescList"></asp:Parameter>
                    <asp:Parameter Name="JenisLesenIdList"></asp:Parameter>
                    <asp:Parameter Name="SaizIklanList"></asp:Parameter>
                    <asp:Parameter Name="CahayaIklanList"></asp:Parameter>
                    <asp:Parameter Name="UnitIklanList"></asp:Parameter>
                    <asp:Parameter Name="LokasiList"></asp:Parameter>
                    <asp:Parameter Name="Permohonan_PemohonID"></asp:Parameter>
                    <asp:Parameter Name="TarikhMohon"></asp:Parameter>
                    <asp:Parameter Name="NamaSyarikat"></asp:Parameter>
                    <asp:Parameter Name="NoPendaftaran"></asp:Parameter>
                    <asp:Parameter Name="NoAkaun"></asp:Parameter>
                    <asp:Parameter Name="AlamatPremis"></asp:Parameter>
                    <asp:Parameter Name="JenisPerniagaan"></asp:Parameter>
                    <asp:Parameter Name="PemilikBaru"></asp:Parameter>
                    <asp:Parameter Name="AlamatBaru"></asp:Parameter>
                    <asp:Parameter Name="JenisPerniagaanBaru"></asp:Parameter>
                    <asp:Parameter Name="NamaBaruSyarikat"></asp:Parameter>
                    <asp:Parameter Name="BillboardLokasi"></asp:Parameter>
                    <asp:Parameter Name="LokasiPasar1"></asp:Parameter>
                    <asp:Parameter Name="LokasiPasar2"></asp:Parameter>
                    <asp:Parameter Name="LokasiPasar3"></asp:Parameter>
                    <asp:Parameter Name="JenisPasar"></asp:Parameter>
                    <asp:Parameter Name="JenisPerniagaanPasar"></asp:Parameter>
                    <asp:Parameter Name="JumlahPetak"></asp:Parameter>
                    <asp:Parameter Name="AnjingAlamat"></asp:Parameter>
                    <asp:Parameter Name="AnjingJenisPremis"></asp:Parameter>
                    <asp:Parameter Name="JenisPenjaja"></asp:Parameter>
                    <asp:Parameter Name="StatusTanahPenjaja"></asp:Parameter>
                    <asp:Parameter Name="AlamatPenjajaan"></asp:Parameter>
                    <asp:Parameter Name="JenisPerniagaanPenjaja"></asp:Parameter>
                    <asp:Parameter Name="MasaPenjaja1"></asp:Parameter>
                    <asp:Parameter Name="MasaPenjaja2"></asp:Parameter>
                    <asp:Parameter Name="JenisKenderaanPenjaja"></asp:Parameter>
                    <asp:Parameter Name="NoKenderaanPenjaja"></asp:Parameter>
                    <asp:Parameter Name="TarikhBatal"></asp:Parameter>
                    <asp:Parameter Name="PenganjurEkspo"></asp:Parameter>
                    <asp:Parameter Name="AlamatPenganjurEkspo"></asp:Parameter>
                    <asp:Parameter Name="PicEkspo"></asp:Parameter>
                    <asp:Parameter Name="NoTelEkspo"></asp:Parameter>
                    <asp:Parameter Name="NamaEkspo"></asp:Parameter>
                    <asp:Parameter Name="LokasiEkspo"></asp:Parameter>
                    <asp:Parameter Name="TarikhEkspo1"></asp:Parameter>
                    <asp:Parameter Name="TarikhEkspo2"></asp:Parameter>
                    <asp:Parameter Name="MasaEkspo1"></asp:Parameter>
                    <asp:Parameter Name="MasaEkspo2"></asp:Parameter>
                    <asp:Parameter Name="TentatifEkspo"></asp:Parameter>
                    <asp:Parameter Name="JemputanEkspo"></asp:Parameter>
                    <asp:Parameter Name="PembersihanEkspo"></asp:Parameter>
                    <asp:Parameter Name="TarikhKhemahEkspo1"></asp:Parameter>
                    <asp:Parameter Name="TarikhKhemahEkspo2"></asp:Parameter>
                    <asp:Parameter Name="KontraktorIklan"></asp:Parameter>
                    <asp:Parameter Name="NoTelKontraktor"></asp:Parameter>
                    <asp:Parameter Name="UkuranBanting"></asp:Parameter>
                    <asp:Parameter Name="BilBanting"></asp:Parameter>
                    <asp:Parameter Name="TarikhBanting1"></asp:Parameter>
                    <asp:Parameter Name="TarikhBanting2"></asp:Parameter>
                    <asp:Parameter Name="StatusBanting"></asp:Parameter>
                    <asp:Parameter Name="NoPengesahanBanting"></asp:Parameter>
                    <asp:Parameter Name="TarikhPengesahanBanting1"></asp:Parameter>
                    <asp:Parameter Name="TarikhPengesahanBanting2"></asp:Parameter>
                    <asp:Parameter Name="NoResitBanting"></asp:Parameter>
                    <asp:Parameter Name="NoSiriStiker"></asp:Parameter>
                    <asp:Parameter Name="TarikhBanting3"></asp:Parameter>
                    <asp:Parameter Name="RenewBanting"></asp:Parameter>
                    <asp:Parameter Name="JenisBanting"></asp:Parameter>
                    <asp:Parameter Name="Rujukan"></asp:Parameter>
                    <asp:Parameter Name="NoAkaunCukai"></asp:Parameter>
                    <asp:Parameter Name="DepositAmount"></asp:Parameter>
                    <asp:Parameter Name="DepositDate"></asp:Parameter>
                    <asp:Parameter Name="DepositResitNo"></asp:Parameter>
                    <asp:Parameter Name="DepositPulangAmount"></asp:Parameter>
                    <asp:Parameter Name="Is24jam"></asp:Parameter>
                    <asp:Parameter Name="RemarksFail"></asp:Parameter>
                    <asp:Parameter Name="IsBatal"></asp:Parameter>
                    <asp:Parameter Name="JenisBatal"></asp:Parameter>
                    <asp:Parameter Name="SebabBatalPerm"></asp:Parameter>
                    <asp:Parameter Name="SebabBatalTanpaPerm"></asp:Parameter>
                    <asp:Parameter Name="RemarksBatal"></asp:Parameter>
                    <asp:Parameter Name="TindakanBatal"></asp:Parameter>
                    <asp:SessionParameter SessionField="sessionUserName" Name="CreatorID"></asp:SessionParameter>
                    <asp:Parameter Name="Permohonan_ID" Type="Int32" Direction="Output" />
                </InsertParameters>
                <SelectParameters>
                    <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedValue" Name="Permohonan_ID"></asp:ControlParameter>
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="JenisLesenDescList"></asp:Parameter>
                    <asp:Parameter Name="JenisLesenIdList"></asp:Parameter>
                    <asp:Parameter Name="SaizIklanList"></asp:Parameter>
                    <asp:Parameter Name="CahayaIklanList"></asp:Parameter>
                    <asp:Parameter Name="UnitIklanList"></asp:Parameter>
                    <asp:Parameter Name="Permohonan_PemohonID"></asp:Parameter>
                    <asp:Parameter Name="TarikhMohon"></asp:Parameter>
                    <asp:Parameter Name="StatusID"></asp:Parameter>
                    <asp:Parameter Name="NamaSyarikat"></asp:Parameter>
                    <asp:Parameter Name="NoPendaftaran"></asp:Parameter>
                    <asp:Parameter Name="NoAkaun"></asp:Parameter>
                    <asp:Parameter Name="AlamatPremis"></asp:Parameter>
                    <asp:Parameter Name="JenisPerniagaan"></asp:Parameter>
                    <asp:Parameter Name="PemilikBaru"></asp:Parameter>
                    <asp:Parameter Name="AlamatBaru"></asp:Parameter>
                    <asp:Parameter Name="JenisPerniagaanBaru"></asp:Parameter>
                    <asp:Parameter Name="NamaBaruSyarikat"></asp:Parameter>
                    <asp:Parameter Name="BillboardLokasi"></asp:Parameter>
                    <asp:Parameter Name="LokasiPasar1"></asp:Parameter>
                    <asp:Parameter Name="LokasiPasar2"></asp:Parameter>
                    <asp:Parameter Name="LokasiPasar3"></asp:Parameter>
                    <asp:Parameter Name="JenisPasar"></asp:Parameter>
                    <asp:Parameter Name="JenisPerniagaanPasar"></asp:Parameter>
                    <asp:Parameter Name="JumlahPetak"></asp:Parameter>
                    <asp:Parameter Name="AnjingAlamat"></asp:Parameter>
                    <asp:Parameter Name="AnjingJenisPremis"></asp:Parameter>
                    <asp:Parameter Name="JenisPenjaja"></asp:Parameter>
                    <asp:Parameter Name="StatusTanahPenjaja"></asp:Parameter>
                    <asp:Parameter Name="AlamatPenjajaan"></asp:Parameter>
                    <asp:Parameter Name="JenisPerniagaanPenjaja"></asp:Parameter>
                    <asp:Parameter Name="MasaPenjaja1"></asp:Parameter>
                    <asp:Parameter Name="MasaPenjaja2"></asp:Parameter>
                    <asp:Parameter Name="JenisKenderaanPenjaja"></asp:Parameter>
                    <asp:Parameter Name="NoKenderaanPenjaja"></asp:Parameter>
                    <asp:Parameter Name="TarikhBatal"></asp:Parameter>
                    <asp:Parameter Name="PenganjurEkspo"></asp:Parameter>
                    <asp:Parameter Name="AlamatPenganjurEkspo"></asp:Parameter>
                    <asp:Parameter Name="PicEkspo"></asp:Parameter>
                    <asp:Parameter Name="NoTelEkspo"></asp:Parameter>
                    <asp:Parameter Name="NamaEkspo"></asp:Parameter>
                    <asp:Parameter Name="LokasiEkspo"></asp:Parameter>
                    <asp:Parameter Name="TarikhEkspo1"></asp:Parameter>
                    <asp:Parameter Name="TarikhEkspo2"></asp:Parameter>
                    <asp:Parameter Name="MasaEkspo1"></asp:Parameter>
                    <asp:Parameter Name="MasaEkspo2"></asp:Parameter>
                    <asp:Parameter Name="TentatifEkspo"></asp:Parameter>
                    <asp:Parameter Name="JemputanEkspo"></asp:Parameter>
                    <asp:Parameter Name="PembersihanEkspo"></asp:Parameter>
                    <asp:Parameter Name="TarikhKhemahEkspo1"></asp:Parameter>
                    <asp:Parameter Name="TarikhKhemahEkspo2"></asp:Parameter>
                    <asp:Parameter Name="KontraktorIklan"></asp:Parameter>
                    <asp:Parameter Name="NoTelKontraktor"></asp:Parameter>
                    <asp:Parameter Name="UkuranBanting"></asp:Parameter>
                    <asp:Parameter Name="BilBanting"></asp:Parameter>
                    <asp:Parameter Name="TarikhBanting1"></asp:Parameter>
                    <asp:Parameter Name="TarikhBanting2"></asp:Parameter>
                    <asp:Parameter Name="StatusBanting"></asp:Parameter>
                    <asp:Parameter Name="NoPengesahanBanting"></asp:Parameter>
                    <asp:Parameter Name="TarikhPengesahanBanting1"></asp:Parameter>
                    <asp:Parameter Name="TarikhPengesahanBanting2"></asp:Parameter>
                    <asp:Parameter Name="NoResitBanting"></asp:Parameter>
                    <asp:Parameter Name="NoSiriStiker"></asp:Parameter>
                    <asp:Parameter Name="TarikhBanting3"></asp:Parameter>
                    <asp:Parameter Name="RenewBanting"></asp:Parameter>
                    <asp:Parameter Name="JenisBanting"></asp:Parameter>
                    <asp:Parameter Name="Rujukan"></asp:Parameter>
                    <asp:Parameter Name="NoAkaunCukai"></asp:Parameter>
                    <asp:Parameter Name="DepositAmount"></asp:Parameter>
                    <asp:Parameter Name="DepositDate"></asp:Parameter>
                    <asp:Parameter Name="DepositResitNo"></asp:Parameter>
                    <asp:Parameter Name="DepositPulangAmount"></asp:Parameter>
                    <asp:Parameter Name="Is24jam"></asp:Parameter>
                    <asp:Parameter Name="RemarksFail"></asp:Parameter>
                    <asp:Parameter Name="IsBatal"></asp:Parameter>
                    <asp:Parameter Name="JenisBatal"></asp:Parameter>
                    <asp:Parameter Name="SebabBatalPerm"></asp:Parameter>
                    <asp:Parameter Name="SebabBatalTanpaPerm"></asp:Parameter>
                    <asp:Parameter Name="RemarksBatal"></asp:Parameter>
                    <asp:Parameter Name="TindakanBatal"></asp:Parameter>
                    <asp:SessionParameter SessionField="sessionUserName" Name="LastModId"></asp:SessionParameter>
                    <asp:Parameter Name="Permohonan_ID"></asp:Parameter>
                </UpdateParameters>
            </asp:SqlDataSource>
            <br />

                        <%-- =========================================================================
                 SECTION 4: Search Filter & Main GridView (whiteCard)
                 ========================================================================= --%>
            <div class="row" id="whiteCard" runat="server">
                <div class="col-12">
                    <div class="card">
                        <div class="card-body">

                            <div class="row mb-4">
                                <div class="col-12 text-end">
                                    <asp:Button ID="ButtonAddAssignment" runat="server" Text="Permohonan Baru" CssClass="btn btn-block btn-primary" CausesValidation="false" />
                                    <br />
                                </div>
                            </div>

                            <%--# START FILTER - set SortExpression at GridView as PRName & add WHERE 1=1 at SqlDataSource - SelectCommand #--%>
                            <div class="row" id="panelFilter" runat="server">
                                <div class="col-md-10">
                                    <%--<div id="pnlFilter" runat="server" class="row" hidden="hidden"></div>--%>

                                    <div class="row">

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <asp:TextBox ID="TB_TarikhMohon" runat="server"
                                                    TextMode="Date" CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <asp:TextBox ID="txtNoRujukan" placeholder="No Rujukan" runat="server" CssClass="form-control"></asp:TextBox>
                                            </div>
                                        </div>

                                        <div class="col-md-3" runat="server" id="filterPemohon">
                                            <div class="form-group">
                                                <asp:DropDownList ID="DDL_Pemohon" CssClass="form-control select2" runat="server"
                                                    DataSourceID="sdsPemohon" DataTextField="Pemohon_Name" DataValueField="Pemohon_ID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource runat="server" ID="sdsPemohon" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                    SelectCommand="select * from 
                                                (select 0 as Pemohon_ID, '-- Pemohon --' as Pemohon_Name
                                                union all
                                                select DISTINCT Pemohon_ID, Pemohon_Name from LESEN_Permohonan a INNER JOIN LESEN_Pemohon b ON b.Pemohon_ID = a.Permohonan_PemohonID where Pemohon_IsActive=1
                                                ) as tbl1 order by Pemohon_Name"></asp:SqlDataSource>
                                            </div>
                                        </div>

                                        <div class="col-md-3" runat="server" id="filterSyarikat">
                                            <div class="form-group">
                                                <asp:DropDownList ID="DDL_Syarikat" CssClass="form-control select2" runat="server"
                                                    DataSourceID="sdsSyarikat" DataTextField="NamaSyarikat" DataValueField="NamaSyarikat">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource runat="server" ID="sdsSyarikat" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                    SelectCommand="select * from 
                                                (select '-- Syarikat --' as NamaSyarikat
                                                union all
                                                select DISTINCT CONVERT(varchar(max), NamaSyarikat) AS NamaSyarikat from LESEN_Permohonan 
                                                WHERE NamaSyarikat IS NOT NULL AND CONVERT(varchar(max), NamaSyarikat) <> '-' 
                                                union all
                                                select DISTINCT CONVERT(varchar(max), NamaBaruSyarikat) AS NamaSyarikat from LESEN_Permohonan 
                                                WHERE NamaBaruSyarikat IS NOT NULL AND CONVERT(varchar(max), NamaBaruSyarikat) <> '-' ) as tbl1"></asp:SqlDataSource>
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <asp:TextBox ID="TB_Alamat" placeholder="Alamat" runat="server" CssClass="form-control"></asp:TextBox>
                                            </div>
                                        </div>

                                        <div class="col-md-3" runat="server" id="filterJenisLesen">
                                            <div class="form-group">
                                                <asp:DropDownList ID="DDL_JenisLesen" CssClass="form-control select2" runat="server" AutoPostBack="false"
                                                    DataSourceID="SqlDataSourceLesen" DataTextField="JenisLesen_Description" DataValueField="JenisLesen_ID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource runat="server" ID="SqlDataSourceLesen" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                    SelectCommand="select * from 
                                                (select '0' as JenisLesen_ID, '-- Lesen/Permit --' as JenisLesen_Description
                                                union all
                                                select JenisLesen_Description AS JenisLesen_ID,  JenisLesen_Description from LESEN_JenisLesen where JenisLesen_IsActive=1
                                                ) as tbl1 order by JenisLesen_Description "></asp:SqlDataSource>
                                            </div>
                                        </div>

                                        <div class="col-md-3" runat="server" id="filterRisiko">
                                            <div class="form-group">
                                                <asp:DropDownList ID="DDL_Risiko" runat="server" AutoPostBack="false" CssClass="form-control select2">
                                                    <asp:ListItem Value="2">-- Risiko --</asp:ListItem>
                                                    <asp:ListItem Value="0">Berisiko</asp:ListItem>
                                                    <asp:ListItem Value="1">Tidak Berisiko</asp:ListItem>
                                                </asp:DropDownList>
                                            </div>
                                        </div>

                                        <div class="col-md-3" runat="server" id="filterPembatalan">
                                            <div class="form-group">
                                                <asp:DropDownList ID="DDL_Pembatalan" runat="server" AutoPostBack="false" CssClass="form-control select2">
                                                    <asp:ListItem Value="2">-- Pembatalan --</asp:ListItem>
                                                    <asp:ListItem Value="1">Ya</asp:ListItem>
                                                    <asp:ListItem Value="0">Tidak</asp:ListItem>
                                                </asp:DropDownList>
                                            </div>
                                        </div>

                                        <div class="col-md-3" runat="server" id="filterStatus">
                                            <asp:DropDownList ID="DDL_Status" CssClass="form-control select2" runat="server" AutoPostBack="false"
                                                DataSourceID="sdsStatus" DataTextField="Description" DataValueField="ApprStatusID">
                                            </asp:DropDownList>
                                            <asp:SqlDataSource runat="server" ID="sdsStatus" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                SelectCommand="select * from 
                                                (select -1 as ApprStatusID, '-- Status --' as Description
                                                union all
                                                select ApprStatusID,  Description from ApprovalStatus
                                                ) as tbl1 order by ApprStatusID "></asp:SqlDataSource>
                                        </div>

                                        <div class="col-md-3" runat="server" id="filterCreatedBy">
                                            <div class="form-group">
                                                <asp:DropDownList ID="DDL_CreatedBy" CssClass="form-control select2" runat="server" AutoPostBack="false"
                                                    DataSourceID="sdsCreatedBy" DataTextField="Users_Fullname" DataValueField="Users_Name">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource runat="server" ID="sdsCreatedBy" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                    SelectCommand="select Users_Name, Users_Fullname from 
                                                (select '0' as Users_Name, '-- Semua Pengguna --' as Users_Fullname
                                                union all
                                                select Users_Name,  Users_Fullname from TBL_USERS where Users_Enabled=1 AND Users_Name NOT LIKE '%[^0-9]%'
								                                        union all
								                                        select @username AS Users_Name, @fullname AS Users_Fullname 
                                                ) as tbl1 group by Users_Name, Users_Fullname order by Users_Fullname ">
                                                    <SelectParameters>
                                                        <asp:SessionParameter Name="username" SessionField="sessionUserName" />
                                                        <asp:SessionParameter Name="fullname" SessionField="sessionFullname" />
                                                    </SelectParameters>
                                                </asp:SqlDataSource>
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <asp:TextBox ID="TB_PermohonanID" placeholder="ID Permohonan" runat="server" CssClass="form-control"></asp:TextBox>
                                            </div>
                                        </div>

                                    </div>

                                </div>
                                <div class="col-md-2">
                                    <div class="form-group">
                                        <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-default" Text="Cari" CausesValidation="false" />
                                        <asp:Button ID="btnReset" CssClass="btn btn-default" runat="server" Text="Reset" CausesValidation="false" />
                                    </div>
                                </div>
                            </div>
                            <%--# END FILTER #--%>

                            <asp:GridView ID="GridView1" HeaderStyle-ForeColor="Black" CssClass="table table-bordered" AllowPaging="True" PageSize="20"
                                ShowHeaderWhenEmpty="True" EmptyDataText="Tiada Rekod Dijumpai" AllowSorting="True" runat="server" AutoGenerateColumns="False"
                                DataKeyNames="Permohonan_ID, StatusID, IsBatal, JenisLesen_ID, IsPublish, Is24Jam, JenisLesenIdList" DataSourceID="SqlDataSourceGrid">
                                <Columns>
                                    <asp:BoundField DataField="Permohonan_ID" HeaderText="ID" SortExpression="Permohonan_ID" Visible="false"></asp:BoundField>
                                    <asp:BoundField DataField="RowNo" HeaderText="No" SortExpression="RowNo"></asp:BoundField>
                                    <asp:BoundField DataField="TarikhMohon" HeaderText="Tarikh" DataFormatString="{0:dd/MM/yyyy}" SortExpression="TarikhMohon"></asp:BoundField>
                                    <asp:BoundField DataField="JenisLesenDescList" HeaderText="Jenis Lesen/Permit" SortExpression="JenisLesenDescList"></asp:BoundField>
                                    <asp:BoundField DataField="Rujukan" HeaderText="No Rujukan" SortExpression="Rujukan"></asp:BoundField>
                                    <asp:TemplateField HeaderText="Pemohon">
                                        <ItemTemplate>
                                            <asp:Label ID="lblNamaPemohon" runat="server" Text='<%# Eval("Pemohon_Name") %>'></asp:Label><br />
                                            <asp:Label ID="lblNamaSyarikatOrAlamat" runat="server" Text='<%# If(Not String.IsNullOrEmpty(Eval("NamaBaruSyarikat")?.ToString()), Eval("NamaBaruSyarikat"), If(Not String.IsNullOrEmpty(Eval("NamaSyarikat")?.ToString()), Eval("NamaSyarikat"), Eval("DisplayAlamat"))) %>' 
                                                Font-Size="10pt"></asp:Label><br />
                                            <asp:Label ID="lblNamaAlamat" runat="server" Visible='<%# If(String.IsNullOrEmpty(Eval("NamaSyarikat")?.ToString()) And String.IsNullOrEmpty(Eval("NamaBaruSyarikat")?.ToString()), False, True) %>' 
                                                Text='<%# Eval("DisplayAlamat") %>' Font-Size="10pt"></asp:Label>
                               
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ShowHeader="True" HeaderText="Berisiko" SortExpression="IsNotRisk">
                                        <ItemTemplate>
                                            <span runat="server" class="badge badge-success" visible='<%# If(Eval("IsNotRisk") = False, True, False) %>'>Ya</span>
                                            <span runat="server" class="badge badge-secondary" visible='<%# If(Eval("IsNotRisk"), True, False) %>'>Tidak</span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ShowHeader="True" HeaderText="Pembatalan" SortExpression="IsBatal">
                                        <ItemTemplate>
                                            <span runat="server" class="badge badge-success" visible='<%# If(Eval("IsBatal"), True, False) %>'>Ya</span>
                                            <span runat="server" class="badge badge-secondary" visible='<%# If(Eval("IsBatal") = False, True, False) %>'>Tidak</span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ShowHeader="True" HeaderText="Surat Balasan" SortExpression="InvolvedAgensiInfo">
                                        <ItemTemplate>
                                            <asp:Repeater ID="rptAgensi" runat="server" DataSource='<%# GetAgensiList(Eval("InvolvedAgensiInfo"), Eval("Permohonan_ID")) %>' OnItemCommand="rptAgensi_ItemCommand">
                                                <ItemTemplate>
                                                    <asp:LinkButton runat="server" 
                                                        ID="btnSuratAgensi"
                                                        Visible='<%# If(Eval("Status").ToString() = "completed", True, False) %>'
                                                        CssClass="badge badge-success"
                                                        CommandName="SuratAgensi" 
                                                        CommandArgument='<%# Eval("CommandArg") %>'
                                                        Text='<%# Eval("Name") %>'
                                                        ToolTip='<%# Eval("TooltipText") %>'
                                                        style="margin-right: 3px; margin-bottom: 2px; display: inline-block; text-decoration: none;" />
                                                    <span runat="server" 
                                                        visible='<%# If(Eval("Status").ToString() = "in-progress", True, False) %>'
                                                        class="badge badge-warning"
                                                        title='<%# Eval("TooltipText") %>'
                                                        style="margin-right: 3px; margin-bottom: 2px; display: inline-block;"><%# Eval("Name") %></span>
                                                    <span runat="server" 
                                                        visible='<%# If(Eval("Status").ToString() = "pending", True, False) %>'
                                                        class="badge badge-secondary"
                                                        title='<%# Eval("TooltipText") %>'
                                                        style="margin-right: 3px; margin-bottom: 2px; display: inline-block;"><%# Eval("Name") %></span>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                            <span runat="server" class="badge badge-secondary" visible='<%# If(String.IsNullOrEmpty(Eval("InvolvedAgensiInfo")?.ToString()), True, False) %>'>Tiada</span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Description" HeaderText="Status" SortExpression="Description"></asp:BoundField>
                                    <asp:BoundField DataField="LastModDt" HeaderText="Tarikh Dikemaskini" DataFormatString="{0:dd/MM/yyyy}" SortExpression="LastModDt" NullDisplayText="-"></asp:BoundField>
                                    <asp:BoundField DataField="RemarksFail" HeaderText="Catatan" SortExpression="RemarksFail"></asp:BoundField>

                                    <asp:TemplateField ShowHeader="False">
                                        <ItemTemplate>
                                            <asp:LinkButton runat="server" CssClass="btn btn-primary btn-sm" CommandName="Hantar" CausesValidation="False" ID="LinkButton6" data-toggle="tooltip" data-placement="top" title="Send" Text="Hantar" Visible='<%# If(Eval("Description") = "Draf (Telah Disemak)", True, False) %>' OnClientClick="return confirm('Hantar ke jabatan agensi sekarang?');" CommandArgument='<%# Container.DataItemIndex %>'/> 
                                            <asp:LinkButton runat="server" CssClass="btn btn-primary btn-sm" CommandName="Select" CausesValidation="False" ID="LinkButton1" data-toggle="tooltip" data-placement="top" title="Edit" Text="Lihat" />
                                            <asp:LinkButton runat="server" CssClass="btn btn-warning btn-sm" CommandName="SuratKelulusan" CausesValidation="False" ID="lbSuratKelulusan" data-toggle="tooltip" data-placement="top" title='<%# If(Eval("IsBatal") = False, "Surat Kelulusan", "Surat Pembatalan") %>' Text='<%# If(Eval("IsBatal") = False, "Surat Kelulusan", "Surat Pembatalan") %>' Visible='<%# If(Eval("StatusID") = 10, True, False) %>' CommandArgument='<%# Container.DataItemIndex %>' />
                                            <asp:LinkButton runat="server" CssClass="btn btn-default btn-sm" CommandName="Delete" CausesValidation="False" ID="LinkButton2" OnClientClick="return confirm('Anda pasti untuk memadam rekod ini?');" data-toggle="tooltip" data-placement="top" title="Delete" Visible='<%# If(Eval("StatusID") < 1 And IsDBNull(Eval("SuratKelulusan1")) And Eval("IsSuratKelulusanFail") = False, True, False) %>'>Padam</asp:LinkButton>
                                            <asp:LinkButton runat="server" CssClass="btn btn-danger btn-sm" CommandName="BatalProses" CausesValidation="False" ID="LinkButton5" OnClientClick="return confirm('Anda pasti untuk membatalkan proses ini?');" data-toggle="tooltip" data-placement="top" title="Cancel" Visible='<%# If(Eval("StatusID") < 9 And (Eval("StatusID") > 0 Or (Eval("StatusID") >= 0 And Eval("IsBatal") = True And (IsDBNull(Eval("SuratKelulusan1")) = False Or Eval("IsSuratKelulusanFail") = True))), True, False) %>' CommandArgument='<%# Container.DataItemIndex %>'>Batal Proses</asp:LinkButton>
                                        
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>

                            <asp:SqlDataSource runat="server" ID="SqlDataSourceGrid" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                DeleteCommand="DELETE FROM LESEN_Permohonan WHERE Permohonan_ID = @Permohonan_ID"
                                SelectCommand="SELECT ROW_NUMBER() OVER(ORDER BY a.TarikhMohon desc) as RowNo, a.*, c.Pemohon_Name, 
                                        ISNULL(a.AlamatBaru,ISNULL(a.AlamatPremis,ISNULL(a.AlamatPenjajaan,ISNULL(a.AnjingAlamat,isnull(a.LokasiPasar1,ISNULL(a.LokasiPasar2,ISNULL(a.LokasiPasar3,''))))))) as DisplayAlamat, 
                                        CASE WHEN a.StatusID = 0 and a.IsBatal = 0 then ISNULL(d.Description + 
                                        (SELECT CASE WHEN MIN(ISNULL(reviewStatusID,0)) = 0 THEN ' (Belum Disemak)' 
                                        WHEN MIN(ISNULL(reviewStatusID,0)) = 1 THEN ' (Dalam Proses Semakan)'
                                        WHEN MIN(ISNULL(reviewStatusID,0)) = 2 THEN ' (Telah Disemak)'
                                        WHEN MIN(ISNULL(reviewStatusID,0)) = 3 THEN ' (Semakan Semula)' END
                                        AS stts 
                                        FROM LESEN_PermohonanAgensi WHERE Permohonan_ID = a.Permohonan_ID),'Draf') 
                                        WHEN a.StatusID = 0 and a.IsBatal = 1 then ISNULL(d.Description + 
                                        (SELECT CASE WHEN MIN(ISNULL(reviewStatusID,0)) = 0 THEN ' (Belum Disemak)' 
                                        WHEN MIN(ISNULL(reviewStatusID,0)) = 1 THEN ' (Dalam Proses Semakan)'
                                        WHEN MIN(ISNULL(reviewStatusID,0)) = 2 THEN ' (Telah Disemak)'
                                        WHEN MIN(ISNULL(reviewStatusID,0)) = 3 THEN ' (Semakan Semula)' END
                                        AS stts 
                                        FROM LESEN_PermohonanAgensiBatal WHERE Permohonan_ID = a.Permohonan_ID),'Draf') else d.Description END
                                        AS Description, 
                                        CASE WHEN a.IsBatal = 0 then a.Is24Jam 
                                        WHEN a.IsBatal = 1 then 1 END 
										AS IsNotRisk,
                                        (SELECT STRING_AGG(
                                            CONCAT(
                                                pa.JabatanAgensi_ID, ':', 
                                                CASE pa.JabatanAgensi_ID
                                                    WHEN 1 THEN 'Perlesenan'
                                                    WHEN 2 THEN 'Bank Negara'
                                                    WHEN 3 THEN 'Inspektorat'
                                                    WHEN 4 THEN 'Kesihatan'
                                                    WHEN 5 THEN 'Bomba'
                                                    WHEN 6 THEN 'Farmasi'
                                                    WHEN 7 THEN 'IT'
                                                    WHEN 8 THEN 'Kejuruteraan'
                                                    WHEN 9 THEN 'Kawalan Bangunan'
                                                    WHEN 10 THEN 'Perancang Bandar & Landskap'
                                                    WHEN 11 THEN 'Penguatkuasaan'
                                                    WHEN 12 THEN 'Pengurusan Harta'
                                                    WHEN 13 THEN 'PD Kluang'
                                                    WHEN 14 THEN 'Polis'
                                                    WHEN 15 THEN 'Kesihatan'
                                                    WHEN 16 THEN 'Bomba'
                                                    WHEN 17 THEN 'SWCorp'
                                                    WHEN 18 THEN 'Kebajikan Masyarakat'
                                                    WHEN 19 THEN 'Pendidikan'
                                                    WHEN 20 THEN 'Pelancongan'
                                                    ELSE ISNULL(ja.JabatanAgensi_Description, 'Agensi')
                                                END, ':',
                                                CASE 
                                                    WHEN pa.PengesahID IS NOT NULL THEN 'completed'
                                                    WHEN pa.ikAssign IS NOT NULL OR ISNULL(pa.IsLawatanTapakUlasan,0) = 1 OR ISNULL(pa.totalViews,0) > 0 THEN 'in-progress'
                                                    ELSE 'pending'
                                                END
                                            ), ';'
                                        ) WITHIN GROUP (ORDER BY pa.JabatanAgensi_ID)
                                        FROM (
                                            SELECT JabatanAgensi_ID, PengesahID, ikAssign, IsLawatanTapakUlasan, totalViews
                                            FROM LESEN_PermohonanAgensi WHERE Permohonan_ID = a.Permohonan_ID AND a.IsBatal = 0
                                            UNION ALL
                                            SELECT JabatanAgensi_ID, PengesahID, ikAssign, IsLawatanTapakUlasan, totalViews
                                            FROM LESEN_PermohonanAgensiBatal WHERE Permohonan_ID = a.Permohonan_ID AND a.IsBatal = 1
                                        ) pa
                                        LEFT JOIN LESEN_JabatanAgensi ja ON ja.JabatanAgensi_ID = pa.JabatanAgensi_ID
                                        ) AS InvolvedAgensiInfo
                                        FROM LESEN_Permohonan a 
                                        INNER JOIN LESEN_Pemohon c ON a.Permohonan_PemohonID = c.Pemohon_ID 
                                        INNER JOIN ApprovalStatus d ON a.StatusID = d.ApprStatusID 
                                        WHERE 1=1 AND a.JenisLesenIdList is not null AND a.IsRekodLama = 0 
                                        AND a.Permohonan_ID = CASE WHEN @pid = 0 THEN a.Permohonan_ID ELSE @pid END 
                                        AND a.JenisLesenDescList LIKE CASE WHEN @lesenID = '0' THEN a.JenisLesenDescList ELSE '%'+@lesenID+'%' END 
                                        AND a.Permohonan_PemohonID = CASE WHEN @pemohonID = 0 THEN a.Permohonan_PemohonID ELSE @pemohonID END 
                                        AND CONVERT(varchar(max), ISNULL(a.NamaSyarikat,'')) = CASE WHEN @namaSyarikat = '-- Syarikat --' THEN CONVERT(varchar(max), ISNULL(a.NamaSyarikat,'')) ELSE @namaSyarikat END 
                                        AND a.IsBatal = CASE WHEN @batalID = 2 THEN a.IsBatal ELSE @batalID END 
                                        AND a.Is24Jam = CASE WHEN @risikoID = 2 THEN a.Is24Jam ELSE @risikoID END 
                                        AND a.StatusID = CASE WHEN @statusID = -1 THEN a.StatusID ELSE @statusID END 
                                        AND a.CreatorID = CASE WHEN @creatorID = '0' THEN a.CreatorID ELSE @creatorID END 
                                        AND (ISNULL(a.AlamatPremis,'') LIKE CASE WHEN @Alamat='' THEN ISNULL(a.AlamatPremis,'') ELSE '%'+@Alamat+'%' END
                                        OR ISNULL(a.AlamatBaru,'') LIKE CASE WHEN @Alamat='' THEN ISNULL(a.AlamatBaru,'') ELSE '%'+@Alamat+'%' END
                                        OR ISNULL(a.AnjingAlamat,'') LIKE CASE WHEN @Alamat='' THEN ISNULL(a.AnjingAlamat,'') ELSE '%'+@Alamat+'%' END
                                        OR ISNULL(a.AlamatPenjajaan,'') LIKE CASE WHEN @Alamat='' THEN ISNULL(a.AlamatPenjajaan,'') ELSE '%'+@Alamat+'%' END
                                        OR ISNULL(a.LokasiPasar1,'') LIKE CASE WHEN @Alamat='' THEN ISNULL(a.LokasiPasar1,'') ELSE '%'+@Alamat+'%' END
                                        OR ISNULL(a.LokasiPasar2,'') LIKE CASE WHEN @Alamat='' THEN ISNULL(a.LokasiPasar2,'') ELSE '%'+@Alamat+'%' END
                                        OR ISNULL(a.LokasiPasar3,'') LIKE CASE WHEN @Alamat='' THEN ISNULL(a.LokasiPasar3,'') ELSE '%'+@Alamat+'%' END) 
                                        /*AND a.AlamatBaru LIKE CASE WHEN @Alamat='' THEN a.AlamatBaru ELSE '%'+@Alamat+'%' END */
                                        /*AND a.AnjingAlamat LIKE CASE WHEN @Alamat='%%' THEN a.AnjingAlamat ELSE '%'+@Alamat+'%' END*/ 
                                        AND a.TarikhMohon LIKE '%'+@TarikhMohon+'%' 
                                        AND a.Rujukan LIKE '%'+@Rujukan+'%' 
                                        order by a.TarikhMohon desc">
                                <DeleteParameters>
                                    <asp:Parameter Name="Permohonan_ID"></asp:Parameter>
                                </DeleteParameters>
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="TB_PermohonanID" PropertyName="Text" DefaultValue="0" Name="pid"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="txtNoRujukan" PropertyName="Text" DefaultValue="%%" Name="Rujukan"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="DDL_JenisLesen" PropertyName="SelectedValue" Name="lesenID"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="DDL_Pemohon" PropertyName="SelectedValue" Name="pemohonID"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="DDL_Syarikat" PropertyName="SelectedValue" Name="namaSyarikat"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="DDL_Pembatalan" PropertyName="SelectedValue" Name="batalID"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="DDL_Risiko" PropertyName="SelectedValue" Name="risikoID"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="DDL_Status" PropertyName="SelectedValue" Name="statusID"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="DDL_CreatedBy" PropertyName="SelectedValue" Name="creatorID"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="TB_TarikhMohon" PropertyName="Text" DefaultValue="%%" Name="TarikhMohon"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="TB_Alamat" PropertyName="Text" DefaultValue="%%" Name="Alamat"></asp:ControlParameter>
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </div>
                    </div>
                </div>
            </div>
            <!-- row whiteCard -->

                        <%-- =========================================================================
                 SECTION 5: TabContainer1 - Tabs (Lampiran, Maklumat, Mesyuarat, Agensi)
                 ========================================================================= --%>
            <asp:TabContainer ID="TabContainer1" runat="server" ActiveTabIndex="0" Visible="false" CssClass="MyTabStyle">

                <%-- --- Tab 1: Lampiran Awam --- --%>
                <asp:TabPanel runat="server" ID="tabPublicAttach" HeaderText="Lampiran Awam">
                    <HeaderTemplate>Lampiran Awam</HeaderTemplate>
                    <ContentTemplate>

                        <asp:GridView ID="gvTabPublicAttach" runat="server" ShowHeaderWhenEmpty="True"
                            AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="PermohonanFail_ID"
                            DataSourceID="SqlDataSourceTabPublicAttach"
                            CssClass="table table-bordered" Width="100%">
                            <AlternatingRowStyle CssClass="alt" />
                            <Columns>

                                <asp:TemplateField HeaderText="ID" SortExpression="PermohonanFail_ID">
                                    <EditItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("PermohonanFail_ID") %>'></asp:Label>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Bind("PermohonanFail_ID") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="styleDisplayNone" />
                                    <ItemStyle CssClass="styleDisplayNone" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="No.">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex + 1 %>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <%# Container.DataItemIndex + 1 %>
                                    </EditItemTemplate>
                                    <HeaderStyle Width="5%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Lampiran">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtPermohonanFail_Remarks" runat="server" Text='<%# Bind("PermohonanFail_Remarks") %>' CssClass="form-control" TextMode="MultiLine" Rows="4" ReadOnly="True" BorderStyle="None"></asp:TextBox>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtPermohonanFail_Remarks" runat="server" Text='<%# Bind("PermohonanFail_Remarks") %>' CssClass="form-control" TextMode="MultiLine" Rows="4"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rvUlasanFail_Remarks" runat="server" CssClass="cssRequiredField"
                                            ControlToValidate="txtPermohonanFail_Remarks" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </EditItemTemplate>
                                    <HeaderStyle Width="55%" HorizontalAlign="Left" />
                                    <ItemStyle HorizontalAlign="Left" />
                                </asp:TemplateField>

                                <asp:TemplateField>
                                    <ItemTemplate>
                                        Fail :
                                        <asp:HyperLink ID="hpFile" runat="server" NavigateUrl='<%# Eval("PermohonanFail_FilePath") %>' Target="_blank"><%# Eval("PermohonanFail_FileName")  %></asp:HyperLink>

                                        <asp:HiddenField ID="hdnFldPermohonanFail_FileName" Value='<%# Bind("PermohonanFail_FileName") %>' runat="server" />
                                        <asp:HiddenField ID="hdnFldPermohonanFail_ContentType" Value='<%# Bind("PermohonanFail_ContentType") %>' runat="server" />
                                        <asp:HiddenField ID="hdnFldPermohonanFail_FilePath" Value='<%# Bind("PermohonanFail_FilePath") %>' runat="server" />
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:FileUpload ID="FU_PermohonanFail" runat="server" CssClass="form-control"></asp:FileUpload>
                                        <asp:Button ID="btnUpload" runat="server" Text="Muat Naik" OnClick="btnUpload_Click" Visible="false"
                                            OnClientClick="return confirm('Fail sedia ada akan ditukar ke fail yang baru.');" />

                                        <asp:HiddenField ID="hdnFldPermohonanFail_FileName" Value='<%# Bind("PermohonanFail_FileName") %>' runat="server" />
                                        <asp:HiddenField ID="hdnFldPermohonanFail_ContentType" Value='<%# Bind("PermohonanFail_ContentType") %>' runat="server" />
                                        <asp:HiddenField ID="hdnFldPermohonanFail_FilePath" Value='<%# Bind("PermohonanFail_FilePath") %>' runat="server" />
                                    </EditItemTemplate>
                                    <HeaderStyle Width="25%" />
                                </asp:TemplateField>

                                <asp:TemplateField ShowHeader="False">
                                    <EditItemTemplate>
                                        <div class="row">

                                            <div class="col-md-6">

                                                <div class="form-group">
                                                    <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="True" CommandName="Update" Text="Simpan"></asp:LinkButton>
                                                </div>
                                            </div>

                                            <div class="col-md-6">

                                                <div class="form-group">
                                                    <asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="Cancel" Text="Batal"></asp:LinkButton>
                                                </div>

                                            </div>

                                        </div>

                                    </EditItemTemplate>
                                    <ItemTemplate>
								                <asp:LinkButton ID="lbEdit" runat="server" CausesValidation="False" CommandName="Edit" Text="Kemaskini" Visible='<%# If(CInt(Session.Item("sessionEstateID")) = 1, True, False) %>'></asp:LinkButton><%--If(Eval("StatusID") < 2, True, False)--%>
                                    </ItemTemplate>
                                    <HeaderStyle Width="10%" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:TemplateField>

                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        <asp:LinkButton ID="btnAddNew" runat="server" Text="+" CssClass="btn btn-warning btn-sm" ToolTip="Tambah" Visible='<%# If(CInt(Session.Item("sessionEstateID")) = 1, True, False) %>' OnClick="btnAddNewUpload1_Click" />
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lbDelete" runat="server" CausesValidation="False" CommandName="Delete" Text="Padam" OnClientClick="return confirm('Anda pasti untuk padam rekod ini?');" Visible='<%# If(CInt(Session.Item("sessionEstateID")) = 1, True, False) %>'></asp:LinkButton>
                                    </ItemTemplate>
                                    <FooterStyle HorizontalAlign="Center" />
                                    <HeaderStyle Width="5%" HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:TemplateField>

                            </Columns>

                            <PagerStyle CssClass="pgr" />
                        </asp:GridView>

                        <asp:SqlDataSource ID="SqlDataSourceTabPublicAttach" runat="server"
                            ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                            SelectCommand=" SELECT a.*, b.StatusID FROM LESEN_PermohonanFail a INNER JOIN LESEN_Permohonan b ON a.PermohonanFail_PermohonanID = b.Permohonan_ID 
                                WHERE a.PermohonanFail_JenisLampiran = 'LA' AND a.PermohonanFail_PermohonanID = @Permohonan_ID"
                            DeleteCommand="DELETE FROM LESEN_PermohonanFail WHERE PermohonanFail_ID = @PermohonanFail_ID "
                            UpdateCommand="UPDATE LESEN_PermohonanFail SET PermohonanFail_Remarks = @PermohonanFail_Remarks, 
                                PermohonanFail_FileName = @PermohonanFail_FileName,
                                PermohonanFail_ContentType = @PermohonanFail_ContentType,
                                PermohonanFail_FilePath = @PermohonanFail_FilePath,
                                LastModID = @LastModID, LastModDt = GETDATE()
                                WHERE (PermohonanFail_ID = @PermohonanFail_ID)">
                            <DeleteParameters>
                                <asp:ControlParameter ControlID="gvTabPublicAttach" DefaultValue="" Name="PermohonanFail_ID" PropertyName="SelectedValue" />
                            </DeleteParameters>
                            <SelectParameters>
                                <asp:ControlParameter ControlID="GridView1" Name="Permohonan_ID" PropertyName="SelectedValue"></asp:ControlParameter>
                            </SelectParameters>
                            <UpdateParameters>
                                <asp:Parameter Name="PermohonanFail_Remarks" />
                                <asp:Parameter Name="PermohonanFail_FileName" />
                                <asp:Parameter Name="PermohonanFail_ContentType" />
                                <asp:Parameter Name="PermohonanFail_FilePath" />
                                <asp:SessionParameter Name="LastModID" SessionField="sessionUserName" />
                                <asp:Parameter Name="PermohonanFail_ID" />
                            </UpdateParameters>
                        </asp:SqlDataSource>

                    </ContentTemplate>
                </asp:TabPanel>

                <%-- --- Tab 2: Ulasan (Lampiran MPK) --- --%>
                <asp:TabPanel runat="server" ID="tabUlasan" HeaderText="Ulasan">
                    <HeaderTemplate>Lampiran MPK</HeaderTemplate>
                    <ContentTemplate>

                        <asp:GridView ID="gvTabUlasan" runat="server" ShowHeaderWhenEmpty="True"
                            AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="PermohonanFail_ID"
                            DataSourceID="SqlDataSourceTabUlasan"
                            CssClass="table table-bordered" Width="100%">
                            <AlternatingRowStyle CssClass="alt" />
                            <Columns>

                                <asp:TemplateField HeaderText="ID" SortExpression="PermohonanFail_ID">
                                    <EditItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("PermohonanFail_ID") %>'></asp:Label>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Bind("PermohonanFail_ID") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="styleDisplayNone" />
                                    <ItemStyle CssClass="styleDisplayNone" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="No.">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex + 1 %>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <%# Container.DataItemIndex + 1 %>
                                    </EditItemTemplate>
                                    <HeaderStyle Width="5%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Lampiran">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtPermohonanFail_Remarks" runat="server" Text='<%# Bind("PermohonanFail_Remarks") %>' CssClass="form-control" TextMode="MultiLine" Rows="4" ReadOnly="True" BorderStyle="None"></asp:TextBox>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtPermohonanFail_Remarks" runat="server" Text='<%# Bind("PermohonanFail_Remarks") %>' CssClass="form-control" TextMode="MultiLine" Rows="4"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rvUlasanFail_Remarks" runat="server" CssClass="cssRequiredField"
                                            ControlToValidate="txtPermohonanFail_Remarks" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </EditItemTemplate>
                                    <HeaderStyle Width="55%" HorizontalAlign="Left" />
                                    <ItemStyle HorizontalAlign="Left" />
                                </asp:TemplateField>

                                <asp:TemplateField>
                                    <ItemTemplate>
                                        Fail :
                                        <asp:HyperLink ID="hpFile" runat="server" NavigateUrl='<%# Eval("PermohonanFail_FilePath") %>' Target="_blank"><%# Eval("PermohonanFail_FileName")  %></asp:HyperLink>

                                        <asp:HiddenField ID="hdnFldPermohonanFail_FileName" Value='<%# Bind("PermohonanFail_FileName") %>' runat="server" />
                                        <asp:HiddenField ID="hdnFldPermohonanFail_ContentType" Value='<%# Bind("PermohonanFail_ContentType") %>' runat="server" />
                                        <asp:HiddenField ID="hdnFldPermohonanFail_FilePath" Value='<%# Bind("PermohonanFail_FilePath") %>' runat="server" />
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:FileUpload ID="FU_PermohonanFail" runat="server" CssClass="form-control"></asp:FileUpload>
                                        <asp:Button ID="btnUpload" runat="server" Text="Muat Naik" OnClick="btnUpload_Click" Visible="false"
                                            OnClientClick="return confirm('Fail sedia ada akan ditukar ke fail yang baru.');" />

                                        <asp:HiddenField ID="hdnFldPermohonanFail_FileName" Value='<%# Bind("PermohonanFail_FileName") %>' runat="server" />
                                        <asp:HiddenField ID="hdnFldPermohonanFail_ContentType" Value='<%# Bind("PermohonanFail_ContentType") %>' runat="server" />
                                        <asp:HiddenField ID="hdnFldPermohonanFail_FilePath" Value='<%# Bind("PermohonanFail_FilePath") %>' runat="server" />
                                    </EditItemTemplate>
                                    <HeaderStyle Width="25%" />
                                </asp:TemplateField>

                                <asp:TemplateField ShowHeader="False">
                                    <EditItemTemplate>
                                        <div class="row">

                                            <div class="col-md-6">

                                                <div class="form-group">
                                                    <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="True" CommandName="Update" Text="Simpan"></asp:LinkButton>
                                                </div>
                                            </div>

                                            <div class="col-md-6">

                                                <div class="form-group">
                                                    <asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="Cancel" Text="Batal"></asp:LinkButton>
                                                </div>

                                            </div>

                                        </div>

                                    </EditItemTemplate>
                                    <ItemTemplate>
									<asp:LinkButton ID="lbEdit" runat="server" CausesValidation="False" CommandName="Edit" Text="Kemaskini" Visible='<%# If(CInt(Session.Item("sessionEstateID")) = 1, True, False) %>'></asp:LinkButton><%--If(Eval("StatusID") < 2, True, False)--%>
                                    </ItemTemplate>
                                    <HeaderStyle Width="10%" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:TemplateField>

                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        <asp:LinkButton ID="btnAddNew" runat="server" Text="+" CssClass="btn btn-warning btn-sm" ToolTip="Tambah" Visible='<%# If(CInt(Session.Item("sessionEstateID")) = 1, True, False) %>' OnClick="btnAddNewUpload_Click" />
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lbDelete" runat="server" CausesValidation="False" CommandName="Delete" Text="Padam" OnClientClick="return confirm('Anda pasti untuk padam rekod ini?');" Visible='<%# If(CInt(Session.Item("sessionEstateID")) = 1, True, False) %>'></asp:LinkButton>
                                    </ItemTemplate>
                                    <FooterStyle HorizontalAlign="Center" />
                                    <HeaderStyle Width="5%" HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:TemplateField>

                            </Columns>

                            <PagerStyle CssClass="pgr" />
                        </asp:GridView>

                        <asp:SqlDataSource ID="SqlDataSourceTabUlasan" runat="server"
                            ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                            SelectCommand=" SELECT a.*, b.StatusID FROM LESEN_PermohonanFail a INNER JOIN LESEN_Permohonan b ON a.PermohonanFail_PermohonanID = b.Permohonan_ID 
                                WHERE a.PermohonanFail_JenisLampiran = 'U' AND a.PermohonanFail_PermohonanID = @Permohonan_ID"
                            DeleteCommand="DELETE FROM LESEN_PermohonanFail WHERE PermohonanFail_ID = @PermohonanFail_ID "
                            UpdateCommand="UPDATE LESEN_PermohonanFail SET PermohonanFail_Remarks = @PermohonanFail_Remarks, 
                                PermohonanFail_FileName = @PermohonanFail_FileName,
                                PermohonanFail_ContentType = @PermohonanFail_ContentType,
                                PermohonanFail_FilePath = @PermohonanFail_FilePath,
                                LastModID = @LastModID, LastModDt = GETDATE()
                                WHERE (PermohonanFail_ID = @PermohonanFail_ID)">
                            <DeleteParameters>
                                <asp:ControlParameter ControlID="gvTabUlasan" DefaultValue="" Name="PermohonanFail_ID" PropertyName="SelectedValue" />
                            </DeleteParameters>
                            <SelectParameters>
                                <asp:ControlParameter ControlID="GridView1" Name="Permohonan_ID" PropertyName="SelectedValue"></asp:ControlParameter>
                            </SelectParameters>
                            <UpdateParameters>
                                <asp:Parameter Name="PermohonanFail_Remarks" />
                                <asp:Parameter Name="PermohonanFail_FileName" />
                                <asp:Parameter Name="PermohonanFail_ContentType" />
                                <asp:Parameter Name="PermohonanFail_FilePath" />
                                <asp:SessionParameter Name="LastModID" SessionField="sessionUserName" />
                                <asp:Parameter Name="PermohonanFail_ID" />
                            </UpdateParameters>
                        </asp:SqlDataSource>

                    </ContentTemplate>
                </asp:TabPanel>

                <%-- --- Tab 3: Maklumat (Inspektorat / Pembetulan Maklumat) --- --%>
                <asp:TabPanel runat="server" ID="tabMaklumat" HeaderText="Maklumat" Visible="false">
                    <HeaderTemplate>Inspektorat</HeaderTemplate>
                    <ContentTemplate>
                        <div class="row">
                            <div class="col-md-12">
                                <asp:LinkButton runat="server" CssClass="btn btn-warning" Text="Lihat Laporan" ID="BT_ViewLaporan" OnCommand="BT_ViewLaporan_Command" CausesValidation="False" Visible="false" />
                            </div>
                        </div>
                        <br />
                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <asp:Label runat="server" Font-Bold="true" Font-Underline="true">Pembetulan Maklumat Permohonan</asp:Label>
                                </div>
                            </div>
                            <br />

                            <asp:HiddenField ID="HF_SaizIklanList_ins" runat="server" />
                            <asp:HiddenField ID="HF_CahayaIklanList_ins" runat="server" />
                            <asp:HiddenField ID="HF_UnitIklanList_ins" runat="server" />
                            <asp:HiddenField ID="HF_LokasiList_ins" runat="server" />
                            <asp:HiddenField ID="HF_BakaAnjingList_ins" runat="server" />
                            <asp:HiddenField ID="HF_AnjingJantanList_ins" runat="server" />
                            <asp:HiddenField ID="HF_AnjingBetinaList_ins" runat="server" />
                            <asp:HiddenField ID="HF_AnjingJantanMandulList_ins" runat="server" />
                            <asp:HiddenField ID="HF_AnjingBetinaMandulList_ins" runat="server" />

                        </div>
                        
                        <%--# Perniagaan Berisiko dan tidak berisiko #--%>
                        <asp:Panel ID="pnlesen1_ins" runat="server" Visible="False" Enabled="True">

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Nama Syarikat/Sediada</label>
                                        <asp:TextBox ID="TB_NamaSyarikat_ins" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>No Pendaftaran</label>
                                        <asp:TextBox ID="TB_NoPendaftaran_ins" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>No Akaun Lesen</label>
                                        <asp:TextBox ID="TB_NoAkaun_ins" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Alamat Premis/Sediada</label>
                                        <asp:TextBox ID="TB_AlamatPremis_ins" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Jenis Perniagaan/Sediada</label>
                                        <asp:TextBox ID="TB_JenisPerniagaan_ins" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>

                            <%--# Tukar Pemilik #--%>
                            <asp:Panel ID="pnlesen1b_ins" runat="server" Visible="False" Enabled="True">
                                <div class="row">

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Nama Pemilik Baru</label>
                                            <asp:TextBox ID="TB_PemilikBaru_ins" runat="server" CssClass="form-control" />

                                        </div>
                                    </div>
                                </div>
                            </asp:Panel>

                        </asp:Panel>

                        <%--# Tukar Alamat #--%>
                        <asp:Panel ID="pnlesen1c_ins" runat="server" Visible="False" Enabled="True">

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <asp:Label ID="Lbl_AlamatBaru_ins" runat="server" Text="Alamat Baru" Font-Bold="true"/>
                                        <asp:TextBox ID="TB_AlamatBaru_ins" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>
                        </asp:Panel>

                        <%--# Tambah Jenis Perniagaan #--%>
                        <asp:Panel ID="pnlesen1d_ins" runat="server" Visible="False" Enabled="True">

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <asp:Label ID="Lbl_JenisPerniagaanBaru_ins" runat="server" Text="Jenis Perniagaan Tambahan" Font-Bold="true" />
                                        <asp:TextBox ID="TB_JenisPerniagaanBaru_ins" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>
                        </asp:Panel>

                        <%--# Tukar Nama Syarikat #--%>
                        <asp:Panel ID="pnlesen1e_ins" runat="server" Visible="False" Enabled="True">

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Nama Baru Syarikat</label>
                                        <asp:TextBox ID="TB_NamaBaruSyarikat_ins" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>

                        </asp:Panel>

                        <%--# Banting #--%>
                        <asp:Panel ID="pnlesen6_ins" runat="server" Visible="False">

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Nama Syarikat Kontraktor Pemasang Iklan</label>
                                        <asp:TextBox ID="TB_KontraktorIklan_ins" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>No Telefon Syarikat Kontraktor</label>
                                        <asp:TextBox ID="TB_NoTelKontraktor_ins" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Ukuran (Kaki)</label>
                                        <asp:TextBox ID="TB_UkuranBanting_ins" runat="server" placeholder="Contoh: 5x10" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Bilangan Banting/Sepanduk</label>
                                        <asp:TextBox ID="TB_BilBanting_ins" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Tarikh Mula Pemasangan</label>
                                        <asp:TextBox ID="TB_TarikhBanting1_ins" runat="server" TextMode="Date" CssClass="form-control" />
                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Tarikh Akhir Pemasangan</label>
                                        <asp:TextBox ID="TB_TarikhBanting2_ins" runat="server" TextMode="Date" CssClass="form-control" />
                                    </div>
                                </div>

                            </div>

                             <div class="row">

                                 <div class="col-md-6">
                                     <div class="form-group">
                                         <label>Lokasi/Tempat Pemasagan</label>
                                         <asp:TextBox ID="TB_LokasiBanting_ins" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />
                                     </div>
                                 </div>

                                 <div class="col-md-2">
                                    <div class="form-group">
                                        <label> </label>
                                        <asp:LinkButton ID="btnAddLokasi_ins" runat="server" CssClass="btn btn-primary" Text="Tambah" OnClick="btnAddLokasi_ins_Click" />
                                    </div>
                                </div>

                             </div>

                             <div class="row">
                                <div class="col-md-8">
                                    <asp:GridView ID="gvLokasiList_ins" runat="server" HeaderStyle-ForeColor="Black" CssClass="table table-bordered" AutoGenerateColumns="False" 
                                        ShowHeaderWhenEmpty="true" EmptyDataText="Senarai kosong." OnRowDeleting="gvLokasiList_ins_RowDeleting">
                                        <Columns>
                                            <asp:BoundField DataField="No" HeaderText="No." />
                                            <asp:BoundField DataField="Lokasi" HeaderText="Lokasi/Tempat Pemasangan" />
                                            <asp:TemplateField>
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="btnRemove_ins" runat="server"  
                                                        CommandName="Delete" CssClass="btn btn-danger btn-sm">&times;</asp:LinkButton>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Status Kelulusan DBP</label>
                                        <asp:DropDownList ID="DDL_StatusDBP_ins" runat="server" 
                                            CssClass="form-control select2">
                                            <asp:ListItem Value="">-- Sila Pilih --</asp:ListItem>
                                            <asp:ListItem Value="1">Lulus</asp:ListItem>
                                            <asp:ListItem Value="0">Tidak Diluluskan</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>No Pengesahan</label>
                                        <asp:TextBox ID="TB_NoPengesahan_ins" runat="server" CssClass="form-control" />
                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Tarikh Mula Pengesahan</label>
                                        <asp:TextBox ID="TB_TarikhPengesahanBanting1_ins" runat="server" TextMode="Date" CssClass="form-control" />
                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Tarikh Akhir Pengesahan</label>
                                        <asp:TextBox ID="TB_TarikhPengesahanBanting2_ins" runat="server" TextMode="Date" CssClass="form-control" />
                                    </div>
                                </div>

                            </div>

                            <div class="row">
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>No Resit</label>
                                        <asp:TextBox ID="TB_NoResitBanting_ins" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>No Siri Stiker</label>
                                        <asp:TextBox ID="TB_NoSiriStiker_ins" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Tarikh</label>
                                        <asp:TextBox ID="TB_TarikhBanting3_ins" runat="server" TextMode="Date" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>

                        </asp:Panel>

                        <%--# Papan iklan, Billboard #--%>
                        <asp:Panel ID="pnlesen1a_ins" runat="server" Visible="False" Enabled="True">

                            <div class="row">

                              <div class="col-md-2">
                                  <div class="form-group">
                                      <label>Saiz Iklan (cm)</label>
                                      <asp:TextBox ID="TB_SaizIklan1_ins" placeholder="Contoh:10x5" runat="server" CssClass="form-control" />
                                  </div>
                              </div>
                               <div class="col-md-2">
                                   <div class="form-group">
                                       <label>Iklan Bercahaya</label>
                                       <asp:DropDownList ID="DDL_Iklan1_ins" runat="server"
                                           CssClass="form-control select2" style="width: 100%;">
                                           <asp:ListItem Value="">-- Sila Pilih --</asp:ListItem>
                                           <asp:ListItem Value="Bercahaya">Ya</asp:ListItem>
                                           <asp:ListItem Value="Tidak Bercahaya">Tidak</asp:ListItem>
                                       </asp:DropDownList>
                                   </div>
                               </div>
                              <div class="col-md-2">
                                  <div class="form-group">
                                      <label>Bil. Unit</label>
                                      <div class="row">
                                          <div class="col">
                                              <asp:TextBox ID="TB_UnitIklan1_ins" runat="server" CssClass="form-control" />
                                          </div>
                                          <div class="col">
                                              <asp:LinkButton ID="btnAddIklan_ins" runat="server" CssClass="btn btn-primary" Text="Tambah" OnClick="btnAddIklan_ins_Click" />
      
                                          </div>
                                      </div>
              
                                  </div>
                              </div>

                          </div>

                          <div class="row">
                              <div class="col-md-6">
                                  <asp:GridView ID="gvIklanList_ins" runat="server" HeaderStyle-ForeColor="Black" CssClass="table table-bordered" AutoGenerateColumns="False" 
                                      ShowHeaderWhenEmpty="true" EmptyDataText="Senarai kosong." OnRowDeleting="gvIklanList_ins_RowDeleting">
                                      <Columns>
                                          <asp:BoundField DataField="SaizIklan" HeaderText="Saiz Iklan (cm)" />
                                          <asp:BoundField DataField="Bercahaya" HeaderText="Bercahaya/Tidak Bercahaya" />
                                          <asp:BoundField DataField="Unit" HeaderText="Bil. Unit" />
                                          <asp:TemplateField>
                                              <ItemTemplate>
                                                  <asp:LinkButton ID="btnRemove_ins" runat="server"  
                                                      CommandName="Delete" CssClass="btn btn-danger btn-sm">
                                                      <i class="bi bi-trash"></i>
                                                  </asp:LinkButton>
                                              </ItemTemplate>
                                          </asp:TemplateField>
                                      </Columns>
                                  </asp:GridView>
                              </div>
                          </div>

                        </asp:Panel>

                        <%--#  Billboard #--%>
                        <asp:Panel ID="pnlbillboard_ins" runat="server" Visible="False" Enabled="True">

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Lokasi Billboard</label>
                                        <asp:TextBox ID="TB_BillboardLokasi_ins" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>

                        </asp:Panel>

                        <%--# Pasar Lambak #--%>
                        <asp:Panel ID="pnlesen2_ins" runat="server" Visible="False" Enabled="True">

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Lokasi Pasar #1</label>
                                        <asp:TextBox ID="TB_LokasiPasar1_ins" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Lokasi Pasar #2</label>
                                        <asp:TextBox ID="TB_LokasiPasar2_ins" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Lokasi Pasar #3</label>
                                        <asp:TextBox ID="TB_LokasiPasar3_ins" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Jumlah Petak/Tapak/Lot</label>
                                        <asp:TextBox ID="TB_JumlahPetak_ins" runat="server" TextMode="Number" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Jenis Jualan</label>
                                        <asp:TextBox ID="TB_JenisPerniagaanPasar_ins" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Jenis Pasar</label>
                                        <asp:DropDownList ID="DDL_JenisPasar_ins" runat="server"
                                            CssClass="form-control select2">
                                            <asp:ListItem Value="">-- Sila Pilih --</asp:ListItem>
                                            <asp:ListItem>Pasar Pagi</asp:ListItem>
                                            <asp:ListItem>Pasar Malam</asp:ListItem>
                                            <asp:ListItem>Pasar Lambak</asp:ListItem>
                                            <asp:ListItem>Pasar Sehari</asp:ListItem>
                                        </asp:DropDownList>

                                    </div>
                                </div>

                            </div>

                        </asp:Panel>

                        <%--# Anjing #--%>
                        <asp:Panel ID="pnlesen3_ins" runat="server" Visible="False" Enabled="True">

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Alamat lokasi</label>
                                        <asp:TextBox ID="TB_AnjingAlamat_ins" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Jenis Premis</label>
                                        <asp:DropDownList ID="DDL_AnjingJenisPremis_ins" CssClass="form-control select2" runat="server"
                                            DataSourceID="SqlDataSourceAnjingJenisPremis_ins" DataTextField="name" DataValueField="id">
                                        </asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourceAnjingJenisPremis_ins" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            SelectCommand="SELECT NULL AS id, '-- Sila Pilih --' AS name UNION ALL SELECT id, name 
                                                FROM TBL_LOOKUPS WHERE lookupgrp_id = 10001 AND status = 1"></asp:SqlDataSource>
                                    </div>
                                </div>

                            </div>

                            <div class="row">

                             <div class="col-md-2">
                                 <div class="form-group">
                                     <label>Jenis Baka</label>
                                     <asp:DropDownList ID="DDL_BakaAnjing1_ins" CssClass="form-control select2" runat="server"
                                         DataSourceID="SqlDataSourceAnjingBaka1_ins" DataTextField="name" DataValueField="id">
                                     </asp:DropDownList>
                                     <asp:SqlDataSource runat="server" ID="SqlDataSourceAnjingBaka1_ins" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                         SelectCommand="SELECT NULL AS id, '-- Sila Pilih --' AS name UNION ALL SELECT id, name 
                                                 FROM TBL_LOOKUPS WHERE lookupgrp_id = 10004 AND status = 1"></asp:SqlDataSource>
                                 </div>
                             </div>

                             <div class="col-md-2">
                                 <div class="form-group">
                                     <label>Bilangan anjing jantan</label>
                                     <asp:TextBox ID="TB_Jantan1_ins" runat="server" TextMode="Number" CssClass="form-control" />
                                 </div>
                             </div>

                             <div class="col-md-2">
                                 <div class="form-group">
                                     <label>Bilangan anjing betina</label>
                                     <asp:TextBox ID="TB_Betina1_ins" runat="server" TextMode="Number" CssClass="form-control" />
                                 </div>
                             </div>

                             <div class="col-md-2">
                                 <div class="form-group">
                                     <label>Bilangan anjing jantan mandul</label>
                                     <asp:TextBox ID="TB_JantanMandul1_ins" runat="server" TextMode="Number" CssClass="form-control" />
                                 </div>
                             </div>

                             <div class="col-md-4">
                                 <div class="form-group">
                                     <label>Bilangan anjing betina mandul</label>
                                     <div class="row">
                                         <div class="col">
                                             <asp:TextBox ID="TB_BetinaMandul1_ins" runat="server" TextMode="Number" CssClass="form-control" />
                                         </div>
                                         <div class="col">
                                             <asp:LinkButton ID="btnAddAnjing_ins" runat="server" CssClass="btn btn-primary" Text="Tambah" OnClick="btnAddAnjing_ins_Click" />
    
                                         </div>

                                     </div>
            
                                 </div>
                             </div>

                            </div>

                             <div class="row">
                                 <div class="col-md-12">
                                     <asp:GridView ID="gvAnjingList_ins" runat="server" HeaderStyle-ForeColor="Black" CssClass="table table-bordered" AutoGenerateColumns="False" 
                                         ShowHeaderWhenEmpty="true" EmptyDataText="Senarai kosong." OnRowDeleting="gvAnjingList_ins_RowDeleting">
                                         <Columns>
                                             <asp:BoundField DataField="Baka" HeaderText="Baka Anjing" />
                                             <asp:BoundField DataField="Jantan" HeaderText=" Bil. Jantan" />
                                             <asp:BoundField DataField="Betina" HeaderText="Bil. Betina" />
                                             <asp:BoundField DataField="JantanMandul" HeaderText="Bil. Jantan Mandul" />
                                             <asp:BoundField DataField="BetinaMandul" HeaderText="Bil. Betina Mandul" />
                                             <asp:TemplateField>
                                                 <ItemTemplate>
                                                     <asp:LinkButton ID="btnRemove_ins" runat="server"  
                                                         CommandName="Delete" CssClass="btn btn-danger btn-sm">
                                                         <i class="bi bi-trash"></i>
                                                     </asp:LinkButton>
                                                 </ItemTemplate>
                                             </asp:TemplateField>
                                         </Columns>
                                     </asp:GridView>
                                 </div>
                             </div>

                        </asp:Panel>

                        <%--# Penjaja #--%>
                        <asp:Panel ID="pnlesen4_ins" runat="server" Visible="False" Enabled="True">

                            <div class="row">

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Jenis Penjaja</label>
                                        <asp:DropDownList ID="DDL_JenisPenjaja_ins" CssClass="form-control select2" runat="server"
                                            DataSourceID="SqlDataSourceJenisPenjaja_ins" DataTextField="name" DataValueField="id">
                                        </asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourceJenisPenjaja_ins" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            SelectCommand="SELECT NULL AS id, '-- Sila Pilih --' AS name UNION ALL SELECT id, name 
                                                    FROM TBL_LOOKUPS WHERE lookupgrp_id = 10006 AND status = 1"></asp:SqlDataSource>
                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Status Tanah</label>
                                        <asp:DropDownList ID="DDL_StatusTanahPenjaja_ins" CssClass="form-control select2" runat="server"
                                            DataSourceID="SqlDataSourceStatusTanahPenjaja_ins" DataTextField="name" DataValueField="id">
                                        </asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourceStatusTanahPenjaja_ins" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            SelectCommand="SELECT NULL AS id, '-- Sila Pilih --' AS name UNION ALL SELECT id, name 
                                                    FROM TBL_LOOKUPS WHERE lookupgrp_id = 10007 AND status = 1"></asp:SqlDataSource>
                                    </div>
                                </div>

                            </div>

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Alamat aktiviti penjajaan</label>
                                        <asp:TextBox ID="TB_AlamatPenjajaan_ins" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Jenis Jualan</label>
                                        <asp:TextBox ID="TB_JenisPerniagaanPenjaja_ins" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>

                            <div class="row">
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Masa Mula Jualan</label>
                                        <asp:TextBox ID="TB_MasaPenjaja1_ins" runat="server" TextMode="Time" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Masa Tamat Jualan</label>
                                        <asp:TextBox ID="TB_MasaPenjaja2_ins" runat="server" TextMode="Time" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Jenis Kenderaan (Penjaja Berkenderaan)</label>
                                        <asp:DropDownList ID="DDL_JenisKenderaanPenjaja_ins" CssClass="form-control select2" runat="server"
                                            DataSourceID="SqlDataSourceJenisKenderaanPenjaja_ins" DataTextField="name" DataValueField="id">
                                        </asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourceJenisKenderaanPenjaja_ins" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            SelectCommand="SELECT NULL AS id, '-- Sila Pilih --' AS name UNION ALL SELECT id, name 
                                                    FROM TBL_LOOKUPS WHERE lookupgrp_id = 10008 AND status = 1"></asp:SqlDataSource>
                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>No Pendaftaran Kenderaan</label>
                                        <asp:TextBox ID="TB_NoKenderaanPenjaja_ins" runat="server" CssClass="form-control" />

                                    </div>
                                </div>
                            </div>

                        </asp:Panel>

                        <%--# Ekspo #--%>
                        <asp:Panel ID="pnlesen5_ins" runat="server" Visible="False" Enabled="True">

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Nama Penganjur</label>
                                        <asp:TextBox ID="TB_PenganjurEkspo_ins" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Alamat Penganjur</label>
                                        <asp:TextBox ID="TB_AlamatPenganjurEkspo_ins" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>PIC Penganjur</label>
                                        <asp:TextBox ID="TB_PicEkspo_ins" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>No. Tel.</label>
                                        <asp:TextBox ID="TB_NoTel_ins" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Nama Aktiviti/Program</label>
                                        <asp:TextBox ID="TB_NamaEkspo_ins" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Lokasi Program</label>
                                        <asp:TextBox ID="TB_LokasiEkspo_ins" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>

                            <div class="row">

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Tarikh Mula</label>
                                        <asp:TextBox ID="TB_TarikhEkspo1_ins" runat="server" TextMode="Date" CssClass="form-control" />
                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Tarikh Tamat</label>
                                        <asp:TextBox ID="TB_TarikhEkspo2_ins" runat="server" TextMode="Date" CssClass="form-control" />
                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Masa Mula</label>
                                        <asp:TextBox ID="TB_MasaEkspo1_ins" runat="server" TextMode="Time" CssClass="form-control" />
                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Masa Tamat</label>
                                        <asp:TextBox ID="TB_MasaEkspo2_ins" runat="server" TextMode="Time" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Tentatif Program</label>
                                        <asp:TextBox ID="TB_TentatifEkspo_ins" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Selebriti/Penceramah/Artis Yang Dijangka Terlibat</label>
                                        <asp:TextBox ID="TB_JemputanEkspo_ins" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Kontraktor Pembersihan</label>
                                        <asp:TextBox ID="TB_PembersihanEkspo_ins" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>

                            <div class="row">
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Cadangan Tarikh Mula Pasang Khemah</label>
                                        <asp:TextBox ID="TB_TarikhKhemahEkspo1_ins" runat="server" TextMode="Date" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Cadangan Tarikh Buka Khemah</label>
                                        <asp:TextBox ID="TB_TarikhKhemahEkspo2_ins" runat="server" TextMode="Date" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>

                        </asp:Panel>
                        <div class="row">
                            <div class="col-md-10">
                                <asp:LinkButton ID="BT_Maklumat" runat="server" CausesValidation="False" Text="Kemaskini" CssClass="btn btn-warning" OnClick="btnSaveInfo_Click"/>
                            </div>
                        </div>
                        <br />
                    </ContentTemplate>
                </asp:TabPanel>

                <%-- --- Tab 4: Mesyuarat --- --%>
                <asp:TabPanel runat="server" ID="tabMesyuarat" HeaderText="Mesyuarat">
                    <HeaderTemplate>Mesyuarat</HeaderTemplate>
                    <ContentTemplate>
                        <br />
                        <div class="row">
                            <label>Maklumat Mesyuarat</label>
                        </div>
                        <br />

                        <div class="row">
                            <div class="col-md-3">

                                <div class="form-group">
                                    <label>Tarikh Mesyuarat</label>
                                    <asp:TextBox ID="TB_TarikhMesyuarat" runat="server" TextMode="Date" CssClass="form-control" />
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-3">

                                <div class="form-group">
                                    <label>No Mesyuarat</label>
                                    <asp:TextBox ID="TB_NoMesyuarat" runat="server" CssClass="form-control" />
                                </div>
                            </div>
                        </div>

                        <br />
                        <div class="row">
                            <div class="col-md-6">

                                <div class="form-group">
                                    <label runat="server">Hantar ke kewangan?</label>
                                    <asp:CheckBox ID="CB_IsPulang" runat="server" OnCheckedChanged="CB_IsPulang_CheckedChanged" AutoPostBack="true" />
                                </div>
                            </div>
                        </div>

                        <asp:Panel runat="server" ID="pnlpulang" Visible="false">
                            <div class="row">
                                <div class="col-md-3">

                                    <div class="form-group">
                                        <label>Tarikh hantar ke kewangan</label>
                                        <asp:TextBox ID="TB_TarikhPulang" runat="server" TextMode="Date" CssClass="form-control" />
                                    </div>
                                </div>
                            </div>
                        </asp:Panel>
                        <br />
                        <div class="row">
                            <div class="col-md-3 text-center">
                                <asp:LinkButton ID="BtnSaveMesyuarat" runat="server" CausesValidation="False" Text="Kemaskini" CssClass="btn btn-warning" OnClick="BtnSaveMesyuarat_Click" />
                            </div>
                        </div>
                        <br />

                    </ContentTemplate>
                </asp:TabPanel>

                <%-- --- Tab 5: Kadar Bayaran --- --%>
                <asp:TabPanel runat="server" ID="tabKadarBayaran" HeaderText="Kadar Bayaran">
                    <HeaderTemplate>Kadar Bayaran</HeaderTemplate>
                    <ContentTemplate>
                        <asp:GridView ID="gvTabBayaran" runat="server" ShowHeaderWhenEmpty="true"
                            AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="KadarBayaran_ID"
                            DataSourceID="SqlDataSourceTabBayaran"
                            CssClass="table table-bordered" Width="100%">
                            <AlternatingRowStyle CssClass="alt" />
                            <Columns>

                                <asp:TemplateField HeaderText="ID" SortExpression="KadarBayaran_ID">
                                    <EditItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("KadarBayaran_ID") %>'></asp:Label>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Bind("KadarBayaran_ID") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="styleDisplayNone" />
                                    <ItemStyle CssClass="styleDisplayNone" />
                                </asp:TemplateField>


                                <asp:TemplateField HeaderText="No.">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex + 1 %>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <%# Container.DataItemIndex + 1 %>
                                    </EditItemTemplate>
                                    <HeaderStyle Width="5%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Bayaran">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtKadarBayaran_Desc" runat="server" Text='<%# Bind("KadarBayaran_Desc") %>' CssClass="form-control" ReadOnly="true" BorderStyle="None"></asp:TextBox><br />
                                        Jabatan/Agensi :
                                        <asp:Label ID="lblJabatanAgensi_Description" runat="server" Text='<%# Eval("JabatanAgensi_Description") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtKadarBayaran_Desc" runat="server" Text='<%# Bind("KadarBayaran_Desc") %>' onkeyup="this.value=this.value.toUpperCase()" CssClass="form-control"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rvKadarBayaran_Desc" runat="server" CssClass="cssRequiredField"
                                            ControlToValidate="txtKadarBayaran_Desc" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </EditItemTemplate>
                                    <HeaderStyle Width="55%" HorizontalAlign="Left" />
                                    <ItemStyle HorizontalAlign="Left" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Jumlah (RM)">
                                    <ItemTemplate>
                                        <asp:Label ID="lblKadarBayaran_Amount" runat="server" Text='<%# Eval("KadarBayaran_Amount", "{0:N2}") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtKadarBayaran_Amount" runat="server" Text='<%# Bind("KadarBayaran_Amount") %>' CssClass="form-control" type="number"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rvKadarBayaran_Amount" runat="server" CssClass="cssRequiredField"
                                            ControlToValidate="txtKadarBayaran_Amount" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </EditItemTemplate>
                                    <HeaderStyle Width="25%" />
                                </asp:TemplateField>

                                <asp:TemplateField ShowHeader="True" HeaderText="Pilih?">
                                    <EditItemTemplate>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:CheckBox ID="cbsel" runat="server" Enabled='<%# If(Eval("IsPublish") = False, True, False) %>' Checked='<%# Eval("IsSelect") %>' OnCheckedChanged="cbsel_CheckedChanged" AutoPostBack="true" />
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField ShowHeader="False">
                                    <EditItemTemplate>
                                        <div class="row">

                                            <div class="col-md-12">

                                                <div class="form-group">
                                                    <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="True" CommandName="Update" Text="Simpan" CssClass="btn btn-warning btn-sm"></asp:LinkButton>
                                                </div>
                                            </div>

                                            <div class="col-md-12">

                                                <div class="form-group">
                                                    <asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" CssClass="btn btn-default btn-sm"></asp:LinkButton>
                                                </div>

                                            </div>

                                        </div>

                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lbEdit" runat="server" CausesValidation="False" CommandName="Edit" Text="Kemaskini"
                                            Visible='<%# If(IsDBNull(Eval("KadarBayaran_PermohonanAgensiID")), True, If(Eval("KadarBayaran_PermohonanAgensiID") = Session.Item("sessionEstateId"), True, False)) %>' CssClass="btn btn-warning btn-sm"></asp:LinkButton>
                                    </ItemTemplate>
                                    <HeaderStyle Width="10%" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:TemplateField>

                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        <asp:LinkButton ID="btnAddNew" runat="server" Text="+" CssClass="btn btn-warning btn-sm" ToolTip="Tambah" OnClick="btnAddNew_Click" />
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lbDelete" runat="server" CausesValidation="False" CssClass="btn btn-danger btn-sm"
                                            Visible='<%# If(IsDBNull(Eval("KadarBayaran_PermohonanAgensiID")), True, If(Eval("KadarBayaran_PermohonanAgensiID") = Session.Item("sessionEstateId"), True, False)) %>' CommandName="Delete" Text="Padam" OnClientClick="return confirm('Anda pasti untuk padam rekod ini?');"></asp:LinkButton>
                                    </ItemTemplate>
                                    <FooterStyle HorizontalAlign="Center" />
                                    <HeaderStyle Width="5%" HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:TemplateField>

                            </Columns>

                            <PagerStyle CssClass="pgr" />
                        </asp:GridView>

                        <asp:SqlDataSource ID="SqlDataSourceTabBayaran" runat="server"
                            ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                            SelectCommand=" SELECT a.*,b.JabatanAgensi_Description, c.IsPublish ,isnull(a.KadarBayaran_PermohonanAgensiID,0) as KadarBayaran_PermohonanAgensiID
                        FROM LESEN_KadarBayaran a
                        left join LESEN_JabatanAgensi b on b.JabatanAgensi_ID = a.KadarBayaran_PermohonanAgensiID
                        left join LESEN_Permohonan c on c.Permohonan_ID = a.KadarBayaran_PermohonanID 
                        where KadarBayaran_PermohonanID = @PermohonanID 
                        and case when isnull(b.JabatanAgensi_Type,'J') = 'J' then 0 when cast(@AgensiID as int) &gt; 0 then KadarBayaran_PermohonanAgensiID else 0 end = case when isnull(b.JabatanAgensi_Type,'J') = 'J' then 0 when cast(@AgensiID as int) &gt; 0 then cast(@AgensiID as int) else 0 end 
                        order by CreatedDt asc, KadarBayaran_ID asc"
                            DeleteCommand="DELETE FROM LESEN_KadarBayaran where KadarBayaran_ID = @KadarBayaran_ID "
                            UpdateCommand="UPDATE LESEN_KadarBayaran SET KadarBayaran_Desc = @KadarBayaran_Desc, LastModID = @LastModID, LastModDt = GETDATE(), KadarBayaran_Amount = @KadarBayaran_Amount WHERE (KadarBayaran_ID = @KadarBayaran_ID)">
                            <DeleteParameters>
                                <asp:ControlParameter ControlID="gvTabBayaran" DefaultValue="" Name="KadarBayaran_ID" PropertyName="SelectedValue" />

                            </DeleteParameters>

                            <SelectParameters>
                                <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[0]" Name="PermohonanID"></asp:ControlParameter>
                                <asp:SessionParameter SessionField="sessionEstateID" DefaultValue="0" Name="AgensiID"></asp:SessionParameter>

                            </SelectParameters>
                            <UpdateParameters>
                                <asp:Parameter Name="KadarBayaran_Desc" />
                                <asp:SessionParameter Name="LastModID" SessionField="sessionUserName" />
                                <asp:Parameter Name="KadarBayaran_Amount" />
                                <asp:Parameter Name="KadarBayaran_ID" />
                            </UpdateParameters>
                        </asp:SqlDataSource>

                    </ContentTemplate>
                </asp:TabPanel>

                <%-- --- Tab 6: Surat Mohon Ulasan --- --%>
                <asp:TabPanel runat="server" ID="TabSurat" HeaderText="Surat Mohon Ulasan">
                    <HeaderTemplate>Surat</HeaderTemplate>
                    <ContentTemplate>
                        <br />

                        <asp:Panel ID="pnlSuratAuto" runat="server">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Tandatangan Agensi/Jabatan Dalaman</label>
                                        <asp:DropDownList ID="ddlTandatangan" CssClass="form-control select2" style="width: 100%;" runat="server" AutoPostBack="false"
                                            DataSourceID="sdsSignature" DataTextField="Users_Fullname" DataValueField="Users_Id">
                                        </asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="sdsSignature" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            DeleteCommand=""
                                            SelectCommand="select *,
                                                case when (
                                                    select count(*) 
                                                    from LESEN_PermohonanAgensiStaff x 
                                                    inner join LESEN_PermohonanAgensi x2 on x2.PermohonanAgensi_ID = x.PermohonanAgensi_ID
                                                    where x.PermohonanAgensiStaffID_UsersID = a.Users_ID 
                                                    and x2.Permohonan_ID = @Permohonan_ID
                                                ) = 0 then 'false' else 'true' end as isSelect
                                                from TBL_USERS a
                                                INNER JOIN LESEN_JabatanAgensi b ON b.JabatanAgensi_ID = a.estate_id
                                                where a.Users_Enabled=1 
                                                and a.Users_Register=1
                                                and a.Users_IsPenilaian = 1 
                                                and b.JabatanAgensi_IsLesen = 1">
                                            <DeleteParameters>
                                                <asp:Parameter Name="JenisLesenAgensi_ID"></asp:Parameter>
                                            </DeleteParameters>
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[0]" Name="Permohonan_ID"></asp:ControlParameter>
                                                <%--<asp:SessionParameter SessionField="sessionEstateID" DefaultValue="0" Name="AgensiID"></asp:SessionParameter>--%>
                                            </SelectParameters>
                                        </asp:SqlDataSource>

                                    </div>
                                </div>
                            </div>
                            <br />

                            <div class="row">
                                <div class="col-md-6">

                                    <div class="form-group">
                                        <label>Tandatangan Agensi/Jabatan Luar</label>
                                        <asp:DropDownList ID="ddlTandatanganLuar" CssClass="form-control select2" style="width: 100%;" runat="server" AutoPostBack="false"
                                            DataSourceID="sdsSignatureLuar" DataTextField="Users_Fullname" DataValueField="Users_Id">
                                        </asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="sdsSignatureLuar" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            DeleteCommand=""
                                            SelectCommand="select *,
                                                        case when (
                                                        select count(*) 
                                                        from LESEN_PermohonanAgensiStaff x 
                                                        inner join LESEN_PermohonanAgensi x2 on x2.PermohonanAgensi_ID = x.PermohonanAgensi_ID
                                                        where x.PermohonanAgensiStaffID_UsersID = a.Users_ID
                                                        and x2.Permohonan_ID = @Permohonan_ID
                                                        ) = 0 then 'false' else 'true' end as isSelect
                                                        from TBL_USERS a
                                                        INNER JOIN LESEN_JabatanAgensi b ON b.JabatanAgensi_ID = a.estate_id
                                                        where a.Users_Enabled=1 
                                                        and a.Users_Register=1
                                                        and a.Users_IsPeraku = 1 
                                                        and b.JabatanAgensi_IsLesen = 1">
                                            <DeleteParameters>
                                                <asp:Parameter Name="JenisLesenAgensi_ID"></asp:Parameter>
                                            </DeleteParameters>
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[0]" Name="Permohonan_ID"></asp:ControlParameter>
                                                <%--<asp:SessionParameter SessionField="sessionEstateID" DefaultValue="0" Name="AgensiID"></asp:SessionParameter>--%>
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                    </div>
                                </div>
                            </div>
                        </asp:Panel>
                        <br />
                        <div class="row">
                            <div class="col-md-6 text-center">
                                <asp:LinkButton ID="btnSaveLetter" runat="server" CausesValidation="False" Text="Simpan" CssClass="btn btn-warning" OnClick="btnSaveLetter_Click" />
                            </div>
                        </div>
                        <br />
                    </ContentTemplate>
                </asp:TabPanel>

                <%-- --- Tab 7: Jabatan Agensi --- --%>
                <asp:TabPanel runat="server" ID="TabJabatanAgensi" HeaderText="Jabatan Agensi">
                    <HeaderTemplate>Jabatan Agensi</HeaderTemplate>
                    <ContentTemplate>
                        <div class="card">
                            <div class="card-body">

                                <div class="row">
                                    <div class="col-12">
                                        <asp:FormView ID="FormViewMaintenanceTemplate" Width="100%" DefaultMode="Insert" runat="server" DataKeyNames="PermohonanAgensi_ID" DataSourceID="SqlDataSourceFormviewMaintenanceTemplate">
                                            <InsertItemTemplate>
                                                <asp:Panel runat="server">
                                                    <div class="card card-default shadow-none">
                                                        <div class="card-header">
                                                            <h3 class="card-title" style="color: white">Tambah Jabatan Agensi</h3>
                                                        </div>
                                                        <!-- /.card-header -->
                                                        <div class="card-body">
                                                            <div class="row">
                                                                <div class="col-md-6">
                                                                    <div class="form-group">
                                                                        <label>Jabatan Agensi</label>
                                                                        <asp:DropDownList ID="DDL_JabatanAgensi" Text='<%# Bind("JabatanAgensi_ID") %>' CssClass="form-control select2" style="width: 100%;" runat="server"
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
                                                                <div class="col-md-2">
                                                                    <br />
                                                                    <asp:LinkButton runat="server" Text="Tambah" CssClass="btn btn-primary" ValidationGroup="insertMaintenanceTemplateForm" CommandName="Insert" ID="LinkButton3" CausesValidation="True" />
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </asp:Panel>
                                            </InsertItemTemplate>
                                        </asp:FormView>
                                        <br />
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourceFormviewMaintenanceTemplate" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            InsertCommand="INSERT INTO LESEN_PermohonanAgensi(Permohonan_ID, JabatanAgensi_ID, IsMandatory) VALUES (@Permohonan_ID, @JabatanAgensi_ID, 1 ^ @Is24Jam); SELECT @PermohonanAgensi_ID = SCOPE_IDENTITY();"
                                            SelectCommand="SELECT a.PermohonanAgensi_ID, a.Permohonan_ID, a.JabatanAgensi_ID, b.StatusID FROM LESEN_PermohonanAgensi a
                                            INNER JOIN LESEN_Permohonan b ON a.Permohonan_ID = b.Permohonan_ID 
                                            WHERE PermohonanAgensi_ID = @PermohonanAgensi_ID">
                                            <InsertParameters>
                                                <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedValue" Name="Permohonan_ID"></asp:ControlParameter>
                                                <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[5]" Name="Is24Jam"></asp:ControlParameter>
                                                <asp:Parameter Name="JabatanAgensi_ID"></asp:Parameter>
                                                <asp:Parameter Name="PermohonanAgensi_ID" Type="Int32" Direction="Output" />
                                            </InsertParameters>
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="GridViewMaintenanceTemplate" PropertyName="SelectedValue" Name="PermohonanAgensi_ID"></asp:ControlParameter>
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                    </div>
                                </div>
                                <!-- /.tab-1 Formview -->
                                <div class="row">
                                    <div class="col-12">
                                        <asp:GridView ID="GridViewMaintenanceTemplate" HeaderStyle-ForeColor="Black" CssClass="table table-bordered" AllowPaging="True" ShowHeaderWhenEmpty="True" EmptyDataText="No records Found" AllowSorting="True" runat="server" AutoGenerateColumns="False" DataKeyNames="PermohonanAgensi_ID, JenisLesenIdList, IsMandatory, JabatanAgensi_ID" DataSourceID="SqlDataSourceGridMaintenanceTemplate">
                                            <Columns>
                                                <asp:BoundField DataField="JabatanAgensi_Description" HeaderText="Jabatan Agensi" SortExpression="JabatanAgensi_Description"></asp:BoundField>
                                                <asp:TemplateField HeaderText="ItemID" Visible="false">
                                                    <ItemTemplate>
                                                        <asp:Label ID="itemID" runat="server" Text='<%# Eval("PermohonanAgensi_ID") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField ShowHeader="True" HeaderText="Tindakan Wajib">
                                                    <EditItemTemplate>
                                                    </EditItemTemplate>
                                                    <ItemTemplate>
                                                        <asp:CheckBox ID="cbman" runat="server" Enabled='<%# If(Eval("StatusID") < 1, True, False) %>' Checked='<%# Eval("IsMandatory") %>' OnCheckedChanged="cbman_CheckedChanged" AutoPostBack="true" />
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Status Dihantar" SortExpression="SendStatus">
                                                    <ItemTemplate>
                                                        <span class='<%# If(Eval("SendStatus") = "Dihantar", "status-pill status-pill-sent", If(Eval("SendStatus") = "Belum Dihantar", "status-pill status-pill-pending", "status-pill status-pill-notrequired")) %>'>
                                                            <i class='<%# If(Eval("SendStatus") = "Dihantar", "bi bi-check-circle-fill status-pill-icon", If(Eval("SendStatus") = "Belum Dihantar", "bi bi-clock-fill status-pill-icon", "bi bi-info-circle-fill status-pill-icon")) %>' aria-hidden="true"></i>
                                                            <span class="status-pill-content">
                                                                <span class="status-pill-label"><%# If(Eval("SendStatus") = "Dihantar", "Telah Dihantar", If(Eval("SendStatus") = "Belum Dihantar", "Belum Dihantar", "Tidak Diperlukan")) %></span>
                                                                <span class="status-pill-description"><%# If(Eval("SendStatus") = "Dihantar", "Surat telah berjaya dihantar", If(Eval("SendStatus") = "Belum Dihantar", "Surat belum dihantar ke agensi", "Tiada tindakan diperlukan")) %></span>
                                                            </span>
                                                        </span>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="ViewStatus" HeaderText="Status Dibaca" SortExpression="ViewStatus"></asp:BoundField>
                                                <asp:TemplateField ShowHeader="False">
                                                    <EditItemTemplate>
                                                    </EditItemTemplate>
                                                    <ItemTemplate>
                                                        <asp:LinkButton runat="server" Text="Surat" CommandName="Surat" CausesValidation="False" ID="lbSurat" CssClass="btn btn-warning btn-sm" CommandArgument='<%# Container.DataItemIndex %>'></asp:LinkButton>
                                                        <asp:LinkButton runat="server" CommandName="Delete" Visible='<%# If(IsDBNull(Eval("reviewStatusID")), True, If(Eval("reviewStatusID") <> "2", True, False)) %>' CssClass="btn btn-warning btn-sm" CommandArgument='<%# Container.DataItemIndex %>' OnClientClick="return confirm('Padam pilihan ini?');" title="Delete" CausesValidation="False" ID="lbPadam">Padam</asp:LinkButton>
                                                        <asp:LinkButton runat="server"
                                                            OnClientClick="return confirm('Hantar Untuk Semakan?');"
                                                            CssClass='<%# If(IsDBNull(Eval("reviewStatusID")), "btn btn-warning btn-sm", If(Eval("reviewStatusID") = "1", "btn btn-warning btn-sm Disabled", If(Eval("reviewStatusID") = "2", "btn btn-warning btn-sm Disabled", If(Eval("reviewStatusID") = "3", "btn btn-warning btn-sm", "")))) %>'
                                                            Text='<%# If(IsDBNull(Eval("reviewStatusID")), "Hantar Untuk Semakan", If(Eval("reviewStatusID") = "1", "Dalam Proses Semakan", If(Eval("reviewStatusID") = "2", "Diluluskan", If(Eval("reviewStatusID") = "3", "Semakan Semula", "")))) %>'
                                                            readonly="true"
                                                            Enabled='<%# If(IsDBNull(Eval("reviewStatusID")), True, If(Eval("reviewStatusID") = "1", False, If(Eval("reviewStatusID") = "2", False, If(Eval("reviewStatusID") = "3", True, False)))) %>'
                                                            BackColor='<%# If(IsDBNull(Eval("reviewStatusID")), System.Drawing.ColorTranslator.FromHtml("#0000ff"), If(Eval("reviewStatusID") = "1", System.Drawing.ColorTranslator.FromHtml("#FFA500"), If(Eval("reviewStatusID") = "2", System.Drawing.ColorTranslator.FromHtml("#00FF00"), If(Eval("reviewStatusID") = "3", System.Drawing.ColorTranslator.FromHtml("#FF0000"), "")))) %>'
                                                            CommandName="review" CausesValidation="False" ID="LinkButton4" CommandArgument='<%# Container.DataItemIndex %>'></asp:LinkButton>

                                                        <div class="wrapperTooltip" runat="server" visible='<%# If(IsDBNull(Eval("reviewStatusID")), False, If(Eval("reviewStatusID") = "3", True, True)) %>'>
                                                            <span style="font-weight: normal" data-placement="top" title="Lihat Ulasan" class="badge badge-danger">Lihat Ulasan</span>
                                                            <div class="tooltip">
                                                                <label style="font-weight: bold; text-decoration: underline;">Ulasan Pengesah : </label>
                                                                <asp:Label ID="lblkbReview" runat="server" Text='<%# Eval("kbReview") %>'></asp:Label>
                                                                <br />
                                                                <%--<label style="font-weight: bold; text-decoration: underline;">Ulasan Peraku : </label>
                                                                <asp:Label ID="lblkjReview" runat="server" Text='<%# Eval("kjReview") %>'></asp:Label>--%>
                                                            </div>
                                                        </div>

                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourceGridMaintenanceTemplate" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            DeleteCommand="DELETE FROM LESEN_PermohonanAgensi WHERE PermohonanAgensi_ID = @PermohonanAgensi_ID"
                                            SelectCommand="SELECT kbReview,kjReview,reviewStatusID,a.PermohonanAgensi_ID, a.Permohonan_ID, b.JabatanAgensi_ID, b.JabatanAgensi_Description, 
                                            a.StatusID AS StatusAgensi, c.StatusID, a.IsMandatory, c.JenisLesenIdList, 
                                            IIF(ISNULL(a.IsMandatory,0)=0 AND c.StatusID=0, 'Tidak Diperlukan' ,IIF(c.StatusID &gt; 0, 'Dihantar', 'Belum Dihantar')) AS SendStatus, 
                                            IIF(a.totalViews &gt; 0, 'Dibaca', 'Belum Dibaca') AS ViewStatus 
                                            FROM LESEN_PermohonanAgensi a 
                                            INNER JOIN LESEN_JabatanAgensi b ON a.JabatanAgensi_ID = b.JabatanAgensi_ID 
                                            INNER JOIN LESEN_Permohonan c ON a.Permohonan_ID = c.Permohonan_ID 
                                            WHERE a.Permohonan_ID = @Permohonan_ID">
                                            <DeleteParameters>
                                                <asp:Parameter Name="PermohonanAgensi_ID"></asp:Parameter>
                                            </DeleteParameters>
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedValue" Name="Permohonan_ID"></asp:ControlParameter>
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                    </div>
                                </div>
                                <!-- /.tab-1 Gridview -->
                            </div>
                        </div>
                    </ContentTemplate>
                </asp:TabPanel>

                <%-- --- Tab 8: Jabatan Agensi Batal --- --%>
                <asp:TabPanel runat="server" ID="TabJabatanAgensiBatal" HeaderText="Jabatan Agensi Batal">
                    <HeaderTemplate>Jabatan Agensi</HeaderTemplate>
                    <ContentTemplate>
                        <div class="card">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-12">
                                        <asp:GridView ID="GridViewJabatanAgensiBatal" HeaderStyle-ForeColor="Black" CssClass="table table-bordered" AllowPaging="True" ShowHeaderWhenEmpty="True" EmptyDataText="No records Found" AllowSorting="True" runat="server" AutoGenerateColumns="False" DataKeyNames="PermohonanAgensi_ID, JenisLesenIdlist, JabatanAgensi_ID, IsMandatory" DataSourceID="SqlDataSourceGridJabatanAgensiBatal">
                                            <Columns>
                                                <asp:BoundField DataField="JabatanAgensi_Description" HeaderText="Jabatan Agensi" SortExpression="JabatanAgensi_Description"></asp:BoundField>
                                                <asp:TemplateField HeaderText="ItemID" Visible="false">
                                                    <ItemTemplate>
                                                        <asp:Label ID="itemID" runat="server" Text='<%# Eval("PermohonanAgensi_ID") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField ShowHeader="True" HeaderText="Tindakan Wajib">
                                                    <EditItemTemplate>
                                                    </EditItemTemplate>
                                                    <ItemTemplate>
                                                        <asp:CheckBox ID="cbman" runat="server" Enabled='<%# If(Eval("StatusID") < 1, True, False) %>' Checked='<%# Eval("IsMandatory") %>' OnCheckedChanged="cbman_CheckedChanged2" AutoPostBack="true" />
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Status Dihantar" SortExpression="SendStatus">
                                                    <ItemTemplate>
                                                        <span class='<%# If(Eval("SendStatus") = "Dihantar", "status-pill status-pill-sent", If(Eval("SendStatus") = "Belum Dihantar", "status-pill status-pill-pending", "status-pill status-pill-notrequired")) %>'>
                                                            <i class='<%# If(Eval("SendStatus") = "Dihantar", "bi bi-check-circle-fill status-pill-icon", If(Eval("SendStatus") = "BELUM Dihantar", "bi bi-clock-fill status-pill-icon", "bi bi-info-circle-fill status-pill-icon")) %>' aria-hidden="true"></i>
                                                            <span class="status-pill-content">
                                                                <span class="status-pill-label"><%# If(Eval("SendStatus") = "Dihantar", "Telah Dihantar", If(Eval("SendStatus") = "Belum Dihantar", "Belum Dihantar", "Tidak Diperlukan")) %></span>
                                                                <span class="status-pill-description"><%# If(Eval("SendStatus") = "Dihantar", "Surat telah berjaya dihantar", If(Eval("SendStatus") = "Belum Dihantar", "Surat belum dihantar ke agensi", "Tiada tindakan diperlukan")) %></span>
                                                            </span>
                                                        </span>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="ViewStatus" HeaderText="Status Dibaca" SortExpression="ViewStatus"></asp:BoundField>
                                                <asp:TemplateField ShowHeader="False">
                                                    <EditItemTemplate>
                                                    </EditItemTemplate>
                                                    <ItemTemplate>
                                                        <asp:LinkButton runat="server" Text="Surat" CommandName="Surat" CausesValidation="False" ID="lbSurat" CssClass="btn btn-warning btn-sm" CommandArgument='<%# Container.DataItemIndex %>'></asp:LinkButton>
                                                        <asp:LinkButton runat="server" CommandName="Delete" Visible='<%# If(IsDBNull(Eval("reviewStatusID")), True, If(Eval("reviewStatusID") <> "2", True, False)) %>' CssClass="btn btn-warning btn-sm" CommandArgument='<%# Container.DataItemIndex %>' OnClientClick="return confirm('Padam pilihan ini?');" title="Delete" CausesValidation="False" ID="lbPadam">Padam</asp:LinkButton>
                                                        <asp:LinkButton runat="server"
                                                            OnClientClick="return confirm('Hantar Untuk Semakan?');"
                                                            CssClass='<%# If(IsDBNull(Eval("reviewStatusID")), "btn btn-warning btn-sm", If(Eval("reviewStatusID") = "1", "btn btn-warning btn-sm Disabled", If(Eval("reviewStatusID") = "2", "btn btn-warning btn-sm Disabled", If(Eval("reviewStatusID") = "3", "btn btn-warning btn-sm", "")))) %>'
                                                            Text='<%# If(IsDBNull(Eval("reviewStatusID")), "Hantar Untuk Semakan", If(Eval("reviewStatusID") = "1", "Dalam Proses Semakan", If(Eval("reviewStatusID") = "2", "Diluluskan", If(Eval("reviewStatusID") = "3", "Semakan Semula", "")))) %>'
                                                            readonly="true"
                                                            Enabled='<%# If(IsDBNull(Eval("reviewStatusID")), True, If(Eval("reviewStatusID") = "1", False, If(Eval("reviewStatusID") = "2", False, If(Eval("reviewStatusID") = "3", True, False)))) %>'
                                                            BackColor='<%# If(IsDBNull(Eval("reviewStatusID")), System.Drawing.ColorTranslator.FromHtml("#0000ff"), If(Eval("reviewStatusID") = "1", System.Drawing.ColorTranslator.FromHtml("#FFA500"), If(Eval("reviewStatusID") = "2", System.Drawing.ColorTranslator.FromHtml("#00FF00"), If(Eval("reviewStatusID") = "3", System.Drawing.ColorTranslator.FromHtml("#FF0000"), "")))) %>'
                                                            CommandName="review" CausesValidation="False" ID="LinkButton4" CommandArgument='<%# Container.DataItemIndex %>'></asp:LinkButton>

                                                        <div class="wrapperTooltip" runat="server" visible='<%# If(IsDBNull(Eval("reviewStatusID")), False, If(Eval("reviewStatusID") = "3", True, False)) %>'>
                                                            <span style="font-weight: normal" data-placement="top" title="Lihat Ulasan" class="badge badge-danger">Lihat Ulasan</span>
                                                            <div class="tooltip">
                                                                <label style="font-weight: bold; text-decoration: underline;">Ulasan Pengesah : </label>
                                                                <asp:Label ID="lblkbReview" runat="server" Text='<%# Eval("kbReview") %>'></asp:Label>
                                                                <br />
                                                                <label style="font-weight: bold; text-decoration: underline;">Ulasan Peraku : </label>
                                                                <asp:Label ID="lblkjReview" runat="server" Text='<%# Eval("kjReview") %>'></asp:Label>
                                                            </div>
                                                        </div>

                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourceGridJabatanAgensiBatal" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            DeleteCommand="DELETE FROM LESEN_PermohonanAgensiBatal WHERE PermohonanAgensi_ID = @PermohonanAgensi_ID"
                                            SelectCommand="SELECT kbReview,kjReview,reviewStatusID,a.PermohonanAgensi_ID, a.Permohonan_ID, b.JabatanAgensi_ID, b.JabatanAgensi_Description, 
                                            a.StatusID AS StatusAgensi, c.StatusID, a.IsMandatory, c.JenisLesenIdlist, 
                                            IIF(ISNULL(a.IsMandatory,0)=0 AND c.StatusID=0, 'Tidak Diperlukan' ,IIF(c.StatusID &gt; 0, 'Dihantar', 'Belum Dihantar')) AS SendStatus, 
                                            IIF(a.totalViews &gt; 0, 'Dibaca', 'Belum Dibaca') AS ViewStatus 
                                            FROM LESEN_PermohonanAgensiBatal a 
                                            INNER JOIN LESEN_JabatanAgensi b ON a.JabatanAgensi_ID = b.JabatanAgensi_ID 
                                            INNER JOIN LESEN_Permohonan c ON a.Permohonan_ID = c.Permohonan_ID
                                            WHERE a.Permohonan_ID = @Permohonan_ID">
                                            <DeleteParameters>
                                                <asp:Parameter Name="PermohonanAgensi_ID"></asp:Parameter>
                                            </DeleteParameters>
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedValue" Name="Permohonan_ID"></asp:ControlParameter>
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                    </div>
                                </div>
                                <!-- /.tab-1 Gridview -->
                            </div>
                        </div>
                    </ContentTemplate>
                </asp:TabPanel>

                <%-- --- Tab 9: Log Kelulusan --- --%>
                <asp:TabPanel runat="server" ID="TabLog" HeaderText="Log Kelulusan">
                    <HeaderTemplate>Log Kelulusan</HeaderTemplate>
                    <ContentTemplate>
                        <div class="card">
                            <div class="card-body">
                                <div class="status-proses-card" style="border: none; padding: 10px 15px; margin-bottom: 0;">
                                    <div class="status-proses-title">Status Proses</div>
                                    <div class="status-timeline">
                                        <asp:Repeater ID="rptStatusProses" runat="server" DataSourceID="SqlDataSourceLogKelulusan">
                                            <ItemTemplate>
                                                <div class="status-step <%# Eval("StepStatus") %>">
                                                    <div class="status-step-icon">
                                                        <%# If(Eval("StepStatus").ToString() = "done", "<i class=""bi bi-check-lg""></i>",
                                                             If(Eval("StepStatus").ToString() = "current", "<i class=""bi bi-circle-fill"" style=""font-size:8px;""></i>", "")) %>
                                                    </div>
                                                    <div class="status-step-title"><%# Eval("Description") %></div>

                                                    <div class="status-step-agensi" runat="server" visible='<%# Not IsDBNull(Eval("JabatanAgensi_Description")) AndAlso Eval("JabatanAgensi_Description").ToString() <> "" %>'>
                                                        <i class="bi bi-building"></i> <%# Eval("JabatanAgensi_Description") %>
                                                    </div>

                                                    <div class="status-step-date">
                                                        <%# If(Eval("StepStatus").ToString() = "pending", "Belum selesai",
                                                             If(Eval("StepStatus").ToString() = "current" AndAlso IsDBNull(Eval("ApprovalDate")), "Menunggu tindakan", Eval("ApprovalDate", "{0:dd MMM yyyy hh:mm tt}"))) %>
                                                    </div>

                                                    <div class="status-step-actionby" runat="server" visible='<%# (Eval("StepStatus").ToString() = "done" OrElse (Eval("StepStatus").ToString() = "current" AndAlso Not IsDBNull(Eval("ApprovalDate")))) AndAlso Not IsDBNull(Eval("ActionBy")) AndAlso Eval("ActionBy").ToString() <> "" %>'>
                                                        <i class="bi bi-person"></i> <%# Eval("ActionBy") %>
                                                    </div>
                                                </div>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </div>
                                </div>
                                <asp:SqlDataSource runat="server" ID="SqlDataSourceLogKelulusan" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                    SelectCommand="WITH PermohonanData AS (
    SELECT e.Permohonan_ID, e.StatusID, e.IsBatal, e.CreatedDt, e.CreatorID, f.Users_Fullname AS CreatorName,
           ISNULL('Draf' + 
           (SELECT CASE WHEN MIN(ISNULL(reviewStatusID,0)) = 0 THEN ' (Belum Disemak)' 
                        WHEN MIN(ISNULL(reviewStatusID,0)) = 1 THEN ' (Dalam Proses Semakan)'
                        WHEN MIN(ISNULL(reviewStatusID,0)) = 2 THEN ' (Telah Disemak)'
                        WHEN MIN(ISNULL(reviewStatusID,0)) = 3 THEN ' (Semakan Semula)' END
            FROM LESEN_PermohonanAgensi WHERE Permohonan_ID = e.Permohonan_ID),'Draf') AS DrafDesc
    FROM LESEN_Permohonan e
    LEFT JOIN TBL_USERS f ON f.Users_Name = e.CreatorID
    WHERE e.Permohonan_ID = @Permohonan_ID
),
AgensiList AS (
    SELECT pa.JabatanAgensi_ID AS AgensiID, ja.JabatanAgensi_Description, ISNULL(pa.IsMandatory, 1) AS IsMandatory
    FROM LESEN_PermohonanAgensi pa
    JOIN LESEN_JabatanAgensi ja ON ja.JabatanAgensi_ID = pa.JabatanAgensi_ID
    WHERE pa.Permohonan_ID = @Permohonan_ID
    UNION
    SELECT al.AgensiID, ja.JabatanAgensi_Description, 1 AS IsMandatory
    FROM LESEN_ApprovalList al
    JOIN LESEN_JabatanAgensi ja ON ja.JabatanAgensi_ID = al.AgensiID
    WHERE al.Permohonan_ID = @Permohonan_ID AND al.AgensiID IS NOT NULL
),
AgensiNumbered AS (
    SELECT AgensiID, JabatanAgensi_Description, IsMandatory,
           ROW_NUMBER() OVER (ORDER BY AgensiID) AS AgensiNo
    FROM AgensiList
),
StepDef AS (
    SELECT 0 AS StepGroup, 0 AS ApprStatusID, 0 AS SortOrder, 'Draf' AS PendingLabel,
           CAST(NULL AS INT) AS AgensiID, CAST(NULL AS NVARCHAR(255)) AS JabatanAgensi_Description, 1 AS IsMandatory
    WHERE EXISTS (SELECT 1 FROM PermohonanData p WHERE p.StatusID = 0)
    
    UNION ALL
    
    SELECT 1 AS StepGroup, 1 AS ApprStatusID, 1 AS SortOrder, 'Permohonan Baru' AS PendingLabel,
           CAST(NULL AS INT) AS AgensiID, CAST(NULL AS NVARCHAR(255)) AS JabatanAgensi_Description, 1 AS IsMandatory
    
    UNION ALL
    
    SELECT s.StepGroup, s.ApprStatusID, 
           (s.StepGroup * 100) + a.AgensiNo AS SortOrder,
           s.PendingLabel,
           a.AgensiID, a.JabatanAgensi_Description, a.IsMandatory
    FROM (VALUES
        (2, 2, 'Pilih Pegawai Lawatan Tapak Jabatan/Agensi'),
        (3, 3, 'Lawatan Tapak Jabatan/Agensi'),
        (4, 4, 'Pengesah Jabatan/Agensi')
    ) AS s(StepGroup, ApprStatusID, PendingLabel)
    CROSS JOIN AgensiNumbered a
    
    UNION ALL
    
    SELECT s.StepGroup, s.ApprStatusID, s.SortOrder, s.PendingLabel,
           CAST(NULL AS INT) AS AgensiID, CAST(NULL AS NVARCHAR(255)) AS JabatanAgensi_Description, 1 AS IsMandatory
    FROM (VALUES
        (5, 5, 800, 'Pengesah Jabatan Lesen'),
        (6, 6, 810, 'Menunggu Pengesahan'),
        (6, 7, 810, 'Menunggu Pengesahan'),
        (7, 8, 820, 'Peraku Jabatan Lesen'),
        (8, 9, 830, 'Kelulusan Peraku'),
        (8, 10, 830, 'Kelulusan Peraku')
    ) AS s(StepGroup, ApprStatusID, SortOrder, PendingLabel)
),
Actual AS (
    SELECT 
        d.StepGroup, d.SortOrder, d.ApprStatusID, d.PendingLabel,
        d.AgensiID, d.JabatanAgensi_Description, d.IsMandatory,
        CASE 
            WHEN d.ApprStatusID = 0 THEN p.CreatedDt 
            WHEN d.ApprStatusID = 1 AND p.StatusID >= 1 THEN ISNULL(a.ApprovalDate, p.CreatedDt)
            ELSE a.ApprovalDate 
        END AS ApprovalDate,
        a.ApprovalID, 
        CASE WHEN d.ApprStatusID = 0 THEN p.DrafDesc ELSE b.Description END AS Description,
        CASE 
            WHEN d.ApprStatusID = 0 THEN ISNULL(p.CreatorName, p.CreatorID)
            WHEN d.ApprStatusID = 1 THEN ISNULL(dd.Users_Fullname, p.CreatorName)
            WHEN d.ApprStatusID = 3 THEN 
                ISNULL(
                    (SELECT STRING_AGG(d1.Users_Fullname, ', ') FROM LESEN_PermohonanAgensiStaff a1 
                     INNER JOIN LESEN_PermohonanAgensi b1 ON b1.Permohonan_ID = @Permohonan_ID 
                         AND b1.PermohonanAgensi_ID = a1.PermohonanAgensi_ID 
                         AND b1.JabatanAgensi_ID = d.AgensiID
                     INNER JOIN TBL_USERS d1 ON d1.Users_Id = a1.PermohonanAgensiStaffID_UsersID),
                    dd.Users_Fullname
                )
            ELSE dd.Users_Fullname 
        END AS ActionBy,
        p.StatusID AS PermohonanStatusID
    FROM StepDef d
    CROSS JOIN PermohonanData p
    LEFT JOIN ApprovalStatus b ON b.ApprStatusID = d.ApprStatusID
    LEFT JOIN LESEN_ApprovalList a 
        ON a.ApprStatusID = d.ApprStatusID 
        AND a.Permohonan_ID = @Permohonan_ID 
        AND ((d.AgensiID IS NOT NULL AND a.AgensiID = d.AgensiID) OR (d.AgensiID IS NULL AND a.AgensiID IS NULL))
        AND a.ApprovalDate IS NOT NULL
    LEFT JOIN TBL_USERS dd ON dd.Users_Id = a.ApproverID
),
Picked AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY StepGroup, ISNULL(AgensiID, 0)
            ORDER BY CASE WHEN ApprovalDate IS NOT NULL AND ApprStatusID > 0 THEN 0 ELSE 1 END, ApprStatusID
        ) AS rn
    FROM Actual
),
Result AS (
    SELECT StepGroup, SortOrder, AgensiID, IsMandatory,
           CASE WHEN ApprovalDate IS NOT NULL THEN ApprStatusID ELSE NULL END AS ApprStatusID,
           CASE WHEN ApprovalDate IS NOT NULL THEN Description ELSE PendingLabel END AS Description,
           ApprovalDate, ApprovalID, 
           JabatanAgensi_Description, ActionBy,
        CASE 
            WHEN PermohonanStatusID = 0 AND ApprStatusID = 0 THEN 'current'
            WHEN PermohonanStatusID = 0 AND ApprStatusID > 0 THEN 'pending'
            WHEN ApprovalDate IS NOT NULL THEN 'done'
            WHEN PermohonanStatusID IN (6, 9, 10) THEN 'pending'
            WHEN AgensiID IS NOT NULL AND StepGroup = (
                SELECT MIN(p2.StepGroup) FROM Picked p2 
                WHERE p2.rn = 1 AND p2.AgensiID = Picked.AgensiID AND p2.ApprovalDate IS NULL
            ) THEN 'current'
            WHEN StepGroup = 5 AND (
                PermohonanStatusID >= 5 OR NOT EXISTS (
                    SELECT 1 FROM Picked p2 
                    WHERE p2.rn = 1 AND p2.AgensiID IS NOT NULL AND p2.IsMandatory = 1 AND p2.ApprovalDate IS NULL
                )
            ) THEN 'current'
            WHEN StepGroup = 7 AND (
                PermohonanStatusID >= 8 OR EXISTS (
                    SELECT 1 FROM Picked p2 WHERE p2.rn = 1 AND p2.StepGroup = 5 AND p2.ApprovalDate IS NOT NULL
                )
            ) THEN 'current'
            ELSE 'pending'
        END AS StepStatus
    FROM Picked
    WHERE rn = 1
)
SELECT * FROM Result
WHERE NOT (StepGroup IN (6, 8) AND StepStatus <> 'done')
ORDER BY 
    CASE StepStatus WHEN 'done' THEN 1 WHEN 'current' THEN 2 ELSE 3 END,
    SortOrder">
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedValue" Name="Permohonan_ID"></asp:ControlParameter>
                                    </SelectParameters>
                                </asp:SqlDataSource>
                            </div>
                        </div>
                    </ContentTemplate>
                </asp:TabPanel>

                <%-- --- Tab 10: Log Pembatalan --- --%>
                <asp:TabPanel runat="server" ID="TabLogBatal" HeaderText="Log Pembatalan">
                    <HeaderTemplate>Log Pembatalan</HeaderTemplate>
                    <ContentTemplate>
                        <div class="card">
                            <div class="card-body">
                                <div class="status-proses-card" style="border: none; padding: 10px 15px; margin-bottom: 0;">
                                    <div class="status-proses-title">Status Proses</div>
                                    <div class="status-timeline">
                                        <asp:Repeater ID="rptStatusProsesBatal" runat="server" DataSourceID="SqlDataSourceLogBatal">
                                            <ItemTemplate>
                                                <div class="status-step <%# Eval("StepStatus") %>">
                                                    <div class="status-step-icon">
                                                        <%# If(Eval("StepStatus").ToString() = "done", "<i class=""bi bi-check-lg""></i>",
                                                             If(Eval("StepStatus").ToString() = "current", "<i class=""bi bi-circle-fill"" style=""font-size:8px;""></i>", "")) %>
                                                    </div>
                                                    <div class="status-step-title"><%# Eval("Description") %></div>

                                                    <div class="status-step-agensi" runat="server" visible='<%# Not IsDBNull(Eval("JabatanAgensi_Description")) AndAlso Eval("JabatanAgensi_Description").ToString() <> "" %>'>
                                                        <i class="bi bi-building"></i> <%# Eval("JabatanAgensi_Description") %>
                                                    </div>

                                                    <div class="status-step-date">
                                                        <%# If(Eval("StepStatus").ToString() = "pending", "Belum selesai",
                                                             If(Eval("StepStatus").ToString() = "current" AndAlso IsDBNull(Eval("ApprovalDate")), "Menunggu tindakan", Eval("ApprovalDate", "{0:dd MMM yyyy hh:mm tt}"))) %>
                                                    </div>

                                                    <div class="status-step-actionby" runat="server" visible='<%# (Eval("StepStatus").ToString() = "done" OrElse (Eval("StepStatus").ToString() = "current" AndAlso Not IsDBNull(Eval("ApprovalDate")))) AndAlso Not IsDBNull(Eval("ActionBy")) AndAlso Eval("ActionBy").ToString() <> "" %>'>
                                                        <i class="bi bi-person"></i> <%# Eval("ActionBy") %>
                                                    </div>
                                                </div>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </div>
                                </div>
                                <asp:SqlDataSource runat="server" ID="SqlDataSourceLogBatal" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                    SelectCommand="WITH PermohonanData AS (
    SELECT e.Permohonan_ID, e.StatusID, e.IsBatal, e.CreatedDt, e.CreatorID, f.Users_Fullname AS CreatorName,
           ISNULL('Draf' + 
           (SELECT CASE WHEN MIN(ISNULL(reviewStatusID,0)) = 0 THEN ' (Belum Disemak)' 
                        WHEN MIN(ISNULL(reviewStatusID,0)) = 1 THEN ' (Dalam Proses Semakan)'
                        WHEN MIN(ISNULL(reviewStatusID,0)) = 2 THEN ' (Telah Disemak)'
                        WHEN MIN(ISNULL(reviewStatusID,0)) = 3 THEN ' (Semakan Semula)' END
            FROM LESEN_PermohonanAgensiBatal WHERE Permohonan_ID = e.Permohonan_ID),'Draf') AS DrafDesc
    FROM LESEN_Permohonan e
    LEFT JOIN TBL_USERS f ON f.Users_Name = e.CreatorID
    WHERE e.Permohonan_ID = @Permohonan_ID
),
AgensiList AS (
    SELECT pa.JabatanAgensi_ID AS AgensiID, ja.JabatanAgensi_Description, ISNULL(pa.IsMandatory, 1) AS IsMandatory
    FROM LESEN_PermohonanAgensiBatal pa
    JOIN LESEN_JabatanAgensi ja ON ja.JabatanAgensi_ID = pa.JabatanAgensi_ID
    WHERE pa.Permohonan_ID = @Permohonan_ID
    UNION
    SELECT al.AgensiID, ja.JabatanAgensi_Description, 1 AS IsMandatory
    FROM LESEN_ApprovalListBatal al
    JOIN LESEN_JabatanAgensi ja ON ja.JabatanAgensi_ID = al.AgensiID
    WHERE al.Permohonan_ID = @Permohonan_ID AND al.AgensiID IS NOT NULL
),
AgensiNumbered AS (
    SELECT AgensiID, JabatanAgensi_Description, IsMandatory,
           ROW_NUMBER() OVER (ORDER BY AgensiID) AS AgensiNo
    FROM AgensiList
),
StepDef AS (
    SELECT 0 AS StepGroup, 0 AS ApprStatusID, 0 AS SortOrder, 'Draf' AS PendingLabel,
           CAST(NULL AS INT) AS AgensiID, CAST(NULL AS NVARCHAR(255)) AS JabatanAgensi_Description, 1 AS IsMandatory
    WHERE EXISTS (SELECT 1 FROM PermohonanData p WHERE p.StatusID = 0)
    
    UNION ALL
    
    SELECT 1 AS StepGroup, 1 AS ApprStatusID, 1 AS SortOrder, 'Permohonan Baru' AS PendingLabel,
           CAST(NULL AS INT) AS AgensiID, CAST(NULL AS NVARCHAR(255)) AS JabatanAgensi_Description, 1 AS IsMandatory
    
    UNION ALL
    
    SELECT s.StepGroup, s.ApprStatusID, 
           (s.StepGroup * 100) + a.AgensiNo AS SortOrder,
           s.PendingLabel,
           a.AgensiID, a.JabatanAgensi_Description, a.IsMandatory
    FROM (VALUES
        (2, 2, 'Pilih Pegawai Lawatan Tapak Jabatan/Agensi'),
        (3, 3, 'Lawatan Tapak Jabatan/Agensi'),
        (4, 4, 'Pengesah Jabatan/Agensi')
    ) AS s(StepGroup, ApprStatusID, PendingLabel)
    CROSS JOIN AgensiNumbered a
    
    UNION ALL
    
    SELECT s.StepGroup, s.ApprStatusID, s.SortOrder, s.PendingLabel,
           CAST(NULL AS INT) AS AgensiID, CAST(NULL AS NVARCHAR(255)) AS JabatanAgensi_Description, 1 AS IsMandatory
    FROM (VALUES
        (5, 5, 800, 'Pengesah Jabatan Lesen'),
        (6, 6, 810, 'Menunggu Pengesahan'),
        (6, 7, 810, 'Menunggu Pengesahan'),
        (7, 8, 820, 'Peraku Jabatan Lesen'),
        (8, 9, 830, 'Kelulusan Peraku'),
        (8, 10, 830, 'Kelulusan Peraku')
    ) AS s(StepGroup, ApprStatusID, SortOrder, PendingLabel)
),
Actual AS (
    SELECT 
        d.StepGroup, d.SortOrder, d.ApprStatusID, d.PendingLabel,
        d.AgensiID, d.JabatanAgensi_Description, d.IsMandatory,
        CASE 
            WHEN d.ApprStatusID = 0 THEN p.CreatedDt 
            WHEN d.ApprStatusID = 1 AND p.StatusID >= 1 THEN ISNULL(a.ApprovalDate, p.CreatedDt)
            ELSE a.ApprovalDate 
        END AS ApprovalDate,
        a.ApprovalID, 
        CASE WHEN d.ApprStatusID = 0 THEN p.DrafDesc ELSE b.Description END AS Description,
        CASE 
            WHEN d.ApprStatusID = 0 THEN ISNULL(p.CreatorName, p.CreatorID)
            WHEN d.ApprStatusID = 1 THEN ISNULL(dd.Users_Fullname, p.CreatorName)
            WHEN d.ApprStatusID = 3 THEN 
                ISNULL(
                    (SELECT STRING_AGG(d1.Users_Fullname, ', ') FROM LESEN_PermohonanAgensiStaffBatal a1 
                     INNER JOIN LESEN_PermohonanAgensiBatal b1 ON b1.Permohonan_ID = @Permohonan_ID 
                         AND b1.PermohonanAgensi_ID = a1.PermohonanAgensi_ID 
                         AND b1.JabatanAgensi_ID = d.AgensiID
                     INNER JOIN TBL_USERS d1 ON d1.Users_Id = a1.PermohonanAgensiStaffID_UsersID),
                    ISNULL(
                        (SELECT STRING_AGG(d1.Users_Fullname, ', ') FROM LESEN_PermohonanAgensiStaff a1 
                         INNER JOIN LESEN_PermohonanAgensi b1 ON b1.Permohonan_ID = @Permohonan_ID 
                             AND b1.PermohonanAgensi_ID = a1.PermohonanAgensi_ID 
                             AND b1.JabatanAgensi_ID = d.AgensiID
                         INNER JOIN TBL_USERS d1 ON d1.Users_Id = a1.PermohonanAgensiStaffID_UsersID),
                        dd.Users_Fullname
                    )
                )
            ELSE dd.Users_Fullname 
        END AS ActionBy,
        p.StatusID AS PermohonanStatusID
    FROM StepDef d
    CROSS JOIN PermohonanData p
    LEFT JOIN ApprovalStatusBatal b ON b.ApprStatusID = d.ApprStatusID
    LEFT JOIN LESEN_ApprovalListBatal a 
        ON a.ApprStatusID = d.ApprStatusID 
        AND a.Permohonan_ID = @Permohonan_ID 
        AND ((d.AgensiID IS NOT NULL AND a.AgensiID = d.AgensiID) OR (d.AgensiID IS NULL AND a.AgensiID IS NULL))
        AND a.ApprovalDate IS NOT NULL
    LEFT JOIN TBL_USERS dd ON dd.Users_Id = a.ApproverID
),
Picked AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY StepGroup, ISNULL(AgensiID, 0)
            ORDER BY CASE WHEN ApprovalDate IS NOT NULL AND ApprStatusID > 0 THEN 0 ELSE 1 END, ApprStatusID
        ) AS rn
    FROM Actual
),
Result AS (
    SELECT StepGroup, SortOrder, AgensiID, IsMandatory,
           CASE WHEN ApprovalDate IS NOT NULL THEN ApprStatusID ELSE NULL END AS ApprStatusID,
           CASE WHEN ApprovalDate IS NOT NULL THEN Description ELSE PendingLabel END AS Description,
           ApprovalDate, ApprovalID, 
           JabatanAgensi_Description, ActionBy,
        CASE 
            WHEN PermohonanStatusID = 0 AND ApprStatusID = 0 THEN 'current'
            WHEN PermohonanStatusID = 0 AND ApprStatusID > 0 THEN 'pending'
            WHEN ApprovalDate IS NOT NULL THEN 'done'
            WHEN EXISTS (SELECT 1 FROM Picked p2 WHERE p2.rn = 1 AND p2.ApprStatusID IN (6, 9, 10) AND p2.ApprovalDate IS NOT NULL) THEN 'pending'
            WHEN AgensiID IS NOT NULL AND StepGroup = (
                SELECT MIN(p2.StepGroup) FROM Picked p2 
                WHERE p2.rn = 1 AND p2.AgensiID = Picked.AgensiID AND p2.ApprovalDate IS NULL
            ) THEN 'current'
            WHEN StepGroup = 5 AND (
                PermohonanStatusID >= 5 OR NOT EXISTS (
                    SELECT 1 FROM Picked p2 
                    WHERE p2.rn = 1 AND p2.AgensiID IS NOT NULL AND p2.IsMandatory = 1 AND p2.ApprovalDate IS NULL
                )
            ) THEN 'current'
            WHEN StepGroup = 7 AND (
                PermohonanStatusID >= 8 OR EXISTS (
                    SELECT 1 FROM Picked p2 WHERE p2.rn = 1 AND p2.StepGroup = 5 AND p2.ApprovalDate IS NOT NULL
                )
            ) THEN 'current'
            ELSE 'pending'
        END AS StepStatus
    FROM Picked
    WHERE rn = 1
)
SELECT * FROM Result
WHERE NOT (StepGroup IN (6, 8) AND StepStatus <> 'done')
ORDER BY 
    CASE StepStatus WHEN 'done' THEN 1 WHEN 'current' THEN 2 ELSE 3 END,
    SortOrder">
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedValue" Name="Permohonan_ID"></asp:ControlParameter>
                                    </SelectParameters>
                                </asp:SqlDataSource>
                            </div>
                        </div>
                    </ContentTemplate>
                </asp:TabPanel>

            </asp:TabContainer>

        </div>
    </section>
    <asp:Button ID="ui_btnPageBottom" runat="server" Text="-" Style="margin-left: -999px;" />
    <%--</ContentTemplate>
    </asp:UpdatePanel>--%>

        <%-- =========================================================================
         SECTION 6: Client Scripts (Initializers & QR Modal)
         ========================================================================= --%>
    <script type="text/javascript">
        // =========================================================================
        // FormView1 Validation Guards:
        // Ensure RequiredFieldValidators for insertForm and updateForm only trigger
        // AFTER the user clicks "Simpan" or "Kemaskini".
        // =========================================================================
        var formValidationTriggered = {
            insertForm: false,
            updateForm: false
        };

        function setupValidationGuards() {
            if (typeof window.Page_ClientValidate === 'function' && !window.Page_ClientValidate._isGuarded) {
                var _origPageClientValidate = window.Page_ClientValidate;
                window.Page_ClientValidate = function (validationGroup) {
                    if (validationGroup === 'insertForm' || validationGroup === 'updateForm') {
                        formValidationTriggered[validationGroup] = true;
                    }
                    return _origPageClientValidate.apply(this, arguments);
                };
                window.Page_ClientValidate._isGuarded = true;
            }

            if (typeof window.ValidatorValidate === 'function' && !window.ValidatorValidate._isGuarded) {
                var _origValidatorValidate = window.ValidatorValidate;
                window.ValidatorValidate = function (val, validationGroup, event) {
                    if (!val) return;
                    var grp = val.validationGroup;
                    if (grp === 'insertForm' || grp === 'updateForm') {
                        if (!formValidationTriggered[grp]) {
                            // User has not clicked Simpan / Kemaskini yet; keep valid & hidden
                            val.isvalid = true;
                            if (typeof ValidatorUpdateDisplay === 'function') {
                                ValidatorUpdateDisplay(val);
                            } else {
                                val.style.display = 'none';
                                val.style.visibility = 'hidden';
                            }
                            return;
                        }
                    }
                    return _origValidatorValidate.apply(this, arguments);
                };
                window.ValidatorValidate._isGuarded = true;
            }
        }

        function resetAndHideUnsubmittedValidators() {
            formValidationTriggered.insertForm = false;
            formValidationTriggered.updateForm = false;

            if (typeof Page_Validators !== 'undefined' && Page_Validators && Page_Validators.length) {
                for (var i = 0; i < Page_Validators.length; i++) {
                    var v = Page_Validators[i];
                    if (v && (v.validationGroup === 'insertForm' || v.validationGroup === 'updateForm')) {
                        v.isvalid = true;
                        if (typeof ValidatorUpdateDisplay === 'function') {
                            ValidatorUpdateDisplay(v);
                        } else {
                            v.style.display = 'none';
                            v.style.visibility = 'hidden';
                        }
                    }
                }
                if (typeof ValidatorUpdateIsValid === 'function') {
                    ValidatorUpdateIsValid();
                }
            }
        }

        $(document).ready(function () {
            setupValidationGuards();
            resetAndHideUnsubmittedValidators();
        });

        function pageLoad() {
            setupValidationGuards();
            resetAndHideUnsubmittedValidators();

            $(function () {
                $('.datepicker').datepicker({
                    dateFormat: 'dd/mm/yy',
                    defaultDate: new Date()
                });

                // Initialize Select2 Elements
                $('.select2').each(function () {
                    $(this).select2({
                        width: '100%',
                        dropdownAutoWidth: false
                    });
                });
                $('.select2bs4').each(function () {
                    $(this).select2({
                        theme: 'bootstrap4',
                        width: '100%',
                        dropdownAutoWidth: false
                    });
                });

                // Datemasks
                $('#datemask').inputmask('dd/mm/yyyy', { 'placeholder': 'dd/mm/yyyy' });
                $('#datemask2').inputmask('mm/dd/yyyy', { 'placeholder': 'mm/dd/yyyy' });
                $('[data-mask]').inputmask();
            });
        }

        // Dynamically lock opened dropdown width to match the dropdownlist size exactly
        $(document).on('select2:open', function (e) {
            var $target = $(e.target);
            var $container = null;
            if ($target.data('select2') && $target.data('select2').$container) {
                $container = $target.data('select2').$container;
            } else {
                $container = $target.next('.select2-container');
                if (!$container.length) {
                    $container = $target.siblings('.select2-container');
                }
            }

            if ($container && $container.length) {
                var width = $container.outerWidth();
                if (width > 0) {
                    var $open = $('.select2-container--open');
                    $open.css({
                        'width': width + 'px',
                        'min-width': width + 'px',
                        'max-width': width + 'px'
                    });
                    $open.find('.select2-dropdown').css({
                        'width': width + 'px',
                        'min-width': width + 'px',
                        'max-width': width + 'px'
                    });
                }
            }
        });

        function printQrOnly() {
            var printContents = document.getElementById('qrPrintArea').innerHTML;
            var printWindow = window.open('', '_blank', 'width=400,height=500');
            printWindow.document.write('<html><head><title>Cetak QR Code</title></head><body style="text-align:center; padding-top:40px;">' + printContents + '</body></html>');
            printWindow.document.close();
            printWindow.focus();
            printWindow.print();
            printWindow.close();
        }

        function closeQrModal() {
            if (typeof $ !== 'undefined' && $.fn.modal) {
                $('#modalQrCode').modal('hide');
            } else if (typeof bootstrap !== 'undefined') {
                var modalEl = document.getElementById('modalQrCode');
                var modalInstance = bootstrap.Modal.getInstance(modalEl);
                if (modalInstance) modalInstance.hide();
            }
        }

        function printBantingQrOnly() {
            var printContents = document.getElementById('bantingQrPrintArea').innerHTML;
            var printWindow = window.open('', '_blank', 'width=520,height=620');
            printWindow.document.write('<html><head><title>Cetak Kod QR Banting</title>');
            printWindow.document.write('<style>');
            printWindow.document.write('body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif; text-align: center; padding: 25px; margin: 0; }');
            printWindow.document.write('.badge { display: inline-block; padding: 4px 8px; font-size: 13px; font-weight: bold; background: #007bff; color: #fff; border-radius: 4px; }');
            printWindow.document.write('.row { display: flex; margin-bottom: 6px; text-align: left; }');
            printWindow.document.write('.col-4 { width: 35%; font-size: 12px; font-weight: bold; color: #555; }');
            printWindow.document.write('.col-8 { width: 65%; font-size: 12px; color: #222; }');
            printWindow.document.write('img { max-width: 220px; height: auto; }');
            printWindow.document.write('@media print { body { padding: 10px; } }');
            printWindow.document.write('</style></head><body>');
            printWindow.document.write('<div style="border: 2px dashed #007bff; border-radius: 8px; padding: 20px; max-width: 360px; margin: 0 auto;">');
            printWindow.document.write('<h4 style="margin: 0 0 10px 0; color: #007bff;">KOD QR BANTING / SEPANDUK</h4>');
            printWindow.document.write(printContents);
            printWindow.document.write('</div>');
            printWindow.document.write('</body></html>');
            printWindow.document.close();
            printWindow.focus();
            setTimeout(function () {
                printWindow.print();
                printWindow.close();
            }, 300);
        }

        function closeBantingQrModal() {
            if (typeof $ !== 'undefined' && $.fn.modal) {
                $('#modalBantingQrCode').modal('hide');
            } else if (typeof bootstrap !== 'undefined') {
                var modalEl = document.getElementById('modalBantingQrCode');
                var modalInstance = bootstrap.Modal.getInstance(modalEl);
                if (modalInstance) modalInstance.hide();
            }
        }

        function toggleLokasiEdit(el, isEdit) {
            var header = el.closest('.lokasi-card-header');
            if (!header) return false;

            var viewPanel = header.querySelector('.lokasi-view-panel');
            var editPanel = header.querySelector('.lokasi-edit-panel');
            var actionsView = header.querySelector('.lokasi-actions-view');
            var actionsEdit = header.querySelector('.lokasi-actions-edit');
            var input = editPanel ? editPanel.querySelector('.lokasi-edit-input') : null;
            var displayText = viewPanel ? viewPanel.querySelector('.lokasi-text') : null;

            if (isEdit) {
                if (viewPanel) {
                    viewPanel.classList.add('d-none');
                    viewPanel.classList.remove('d-flex');
                }
                if (actionsView) {
                    actionsView.classList.add('d-none');
                    actionsView.classList.remove('d-inline-flex');
                }
                if (editPanel) {
                    editPanel.classList.remove('d-none');
                    editPanel.classList.add('d-flex');
                }
                if (actionsEdit) {
                    actionsEdit.classList.remove('d-none');
                    actionsEdit.classList.add('d-inline-flex');
                }
                if (input && displayText) {
                    input.value = displayText.textContent.trim();
                    input.focus();
                    input.select();
                }
            } else {
                if (editPanel) {
                    editPanel.classList.add('d-none');
                    editPanel.classList.remove('d-flex');
                }
                if (actionsEdit) {
                    actionsEdit.classList.add('d-none');
                    actionsEdit.classList.remove('d-inline-flex');
                }
                if (viewPanel) {
                    viewPanel.classList.remove('d-none');
                    viewPanel.classList.add('d-flex');
                }
                if (actionsView) {
                    actionsView.classList.remove('d-none');
                    actionsView.classList.add('d-inline-flex');
                }
                if (input && displayText) {
                    input.value = displayText.textContent.trim();
                }
            }
            return false;
        }

        function onLokasiEditKey(event, input) {
            if (event.key === 'Enter') {
                event.preventDefault();
                var header = input.closest('.lokasi-card-header');
                if (header) {
                    var saveBtn = header.querySelector('.btn-save-lokasi');
                    if (saveBtn) {
                        saveBtn.click();
                    }
                }
            } else if (event.key === 'Escape') {
                event.preventDefault();
                toggleLokasiEdit(input, false);
            }
        }
    </script>
</asp:Content>
