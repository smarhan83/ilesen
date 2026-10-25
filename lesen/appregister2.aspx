<%@ Page MaintainScrollPositionOnPostback="true" Title="" Language="VB" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="appregister2.aspx.vb" Inherits="appregister2" %>

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
        .select2-container .select2-selection--multiple {
            min-height: 38px !important;
            border: 1px solid #d1d5db !important;
            border-radius: 6px !important;
            padding: 2px 6px !important;
            display: flex !important;
            flex-wrap: wrap !important;
            align-items: center !important;
            width: 100% !important;
            box-sizing: border-box !important;
            background-color: #fff !important;
        }
        .select2-container--default .select2-selection--multiple .select2-selection__choice {
            background-color: #e0e7ff !important;
            border: 1px solid #c7d2fe !important;
            color: #3730a3 !important;
            border-radius: 4px !important;
            padding: 1px 8px !important;
            font-size: 0.8rem !important;
            font-weight: 500 !important;
            margin: 2px 4px 2px 0 !important;
            line-height: 20px !important;
        }
        .select2-container--default .select2-selection--multiple .select2-selection__choice__remove {
            color: #4338ca !important;
            margin-right: 5px !important;
            font-weight: bold !important;
        }
        .select2-container--default .select2-selection--multiple .select2-selection__choice__remove:hover {
            color: #dc2626 !important;
        }
        .select2-container--default .select2-selection--multiple .select2-search--inline .select2-search__field {
            font-size: 0.875rem !important;
            margin-top: 3px !important;
            height: 26px !important;
            line-height: 26px !important;
            color: #374151 !important;
        }
        .select2-container--default.select2-container--focus .select2-selection--multiple {
            border-color: #2563eb !important;
            box-shadow: 0 0 0 2px rgba(37, 99, 235, 0.2) !important;
            outline: none !important;
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

        /* =========================================================================
           GridView1 & Table Modern Styling (FormView1 Compatibility)
           ========================================================================= */
        .custom-gridview {
            border-collapse: separate !important;
            border-spacing: 0 !important;
            width: 100% !important;
            margin-bottom: 0 !important;
            background-color: #fff;
            border: 1px solid #e2e8f0 !important;
            border-radius: 8px !important;
            overflow: hidden;
        }
        .custom-gridview th {
            background: linear-gradient(180deg, #f8fafc 0%, #f1f5f9 100%) !important;
            color: #1e3a8a !important;
            font-size: 0.81rem !important;
            font-weight: 700 !important;
            text-transform: uppercase;
            letter-spacing: 0.4px;
            padding: 11px 12px !important;
            vertical-align: middle !important;
            border-bottom: 2px solid #cbd5e1 !important;
            border-top: none !important;
            white-space: nowrap;
        }
        .custom-gridview th a {
            color: #1e3a8a !important;
            text-decoration: none !important;
            font-weight: 700 !important;
        }
        .custom-gridview th a:hover {
            color: #2D6CDF !important;
            text-decoration: underline !important;
        }
        .custom-gridview td {
            padding: 10px 12px !important;
            vertical-align: middle !important;
            font-size: 0.84rem !important;
            border-color: #e9ecef !important;
            color: #334155;
        }
        .custom-gridview tr:hover td {
            background-color: #f8fafc !important;
        }
        .custom-gridview .badge {
            font-size: 0.76rem !important;
            font-weight: 600 !important;
            padding: 4px 8px !important;
            border-radius: 6px !important;
        }
        .custom-gridview .badge-success {
            background-color: #10b981 !important;
            color: #fff !important;
        }
        .custom-gridview .badge-warning {
            background-color: #f59e0b !important;
            color: #fff !important;
        }
        .custom-gridview .badge-secondary {
            background-color: #64748b !important;
            color: #fff !important;
        }
        .custom-gridview tr:last-child td table {
            margin: 0 !important;
        }
        .custom-gridview tr:last-child td {
            background-color: #f8fafc !important;
            border-top: 1px solid #e2e8f0 !important;
            padding: 10px 16px !important;
        }
        .custom-gridview tr:last-child td table td {
            padding: 2px 4px !important;
            border: none !important;
            background: transparent !important;
        }
        .custom-gridview tr:last-child td table td a,
        .custom-gridview tr:last-child td table td span {
            display: inline-block;
            min-width: 32px;
            height: 32px;
            line-height: 30px;
            text-align: center;
            border-radius: 6px;
            font-size: 0.84rem;
            font-weight: 600;
            text-decoration: none !important;
            border: 1px solid #d1d5db;
            margin: 0 2px;
            transition: all 0.15s ease-in-out;
        }
        .custom-gridview tr:last-child td table td a {
            background-color: #fff;
            color: #2D6CDF;
        }
        .custom-gridview tr:last-child td table td a:hover {
            background-color: #eff6ff;
            border-color: #2D6CDF;
            color: #1d4ed8;
        }
        .custom-gridview tr:last-child td table td span {
            background-color: #2D6CDF;
            border-color: #2D6CDF;
            color: #fff;
        }
        .font-weight-bold {
            font-weight: 700 !important;
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">

    <!-- ======================================================================= -->
    <!-- PAGE HEADER & BREADCRUMB                                                -->
    <!-- ======================================================================= -->
    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0 text-dark">
                        <div runat="server" id="idWindowTitle"></div>
                    </h1>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <%= GlobalClass.writeBreadcrumb(Request.QueryString("p_Id"), Request.QueryString("m_Id"), Session.Item("sessionSystemId")) %>
                    </ol>
                </div>
            </div>
        </div>
    </section>

    <!-- Main content -->
    <section class="content">
        <div class="container-fluid">

            <!-- ======================================================================= -->
            <!-- FORMVIEW: KEMASKINI & KUNCI MASUK PERMOHONAN                           -->
            <!-- ======================================================================= -->
            <asp:FormView ID="FormView1" runat="server" DataKeyNames="Permohonan_ID"
                DataSourceID="SqlDataSourceForm" Width="100%" DefaultMode="Edit">

                <%-- =================================================================== --%>
                <%-- [SECTION 1] EDIT ITEM TEMPLATE (KEMASKINI PERMOHONAN)              --%>
                <%-- =================================================================== --%>
                <EditItemTemplate>
                    <div class="card card-warning">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h3 class="card-title mb-0 font-weight-bold"><i class="bi bi-pencil-square me-2"></i>Kemaskini Permohonan</h3>
                        </div>
                        <div class="card-body">
                            <!-- Hidden Fields for Multi-Value Lists -->
                            <asp:HiddenField ID="HF_Status" Value='<%# Bind("StatusID") %>' runat="server" />
                            <asp:HiddenField ID="HF_JenisLesenDescList" Value='<%# Bind("JenisLesenDescList") %>' runat="server" />
                            <asp:HiddenField ID="HF_JenisLesenIdList" Value='<%# Bind("JenisLesenIdList") %>' runat="server" />
                            <asp:HiddenField ID="HF_SaizIklanList" Value='<%# Bind("SaizIklanList") %>' runat="server" />
                            <asp:HiddenField ID="HF_CahayaIklanList" Value='<%# Bind("CahayaIklanList") %>' runat="server" />
                            <asp:HiddenField ID="HF_UnitIklanList" Value='<%# Bind("UnitIklanList") %>' runat="server" />
                            <asp:HiddenField ID="HF_BakaAnjingList" Value='<%# Bind("BakaAnjingList") %>' runat="server" />
                            <asp:HiddenField ID="HF_AnjingJantanList" Value='<%# Bind("AnjingJantanList") %>' runat="server" />
                            <asp:HiddenField ID="HF_AnjingBetinaList" Value='<%# Bind("AnjingBetinaList") %>' runat="server" />
                            <asp:HiddenField ID="HF_AnjingJantanMandulList" Value='<%# Bind("AnjingJantanMandulList") %>' runat="server" />
                            <asp:HiddenField ID="HF_AnjingBetinaMandulList" Value='<%# Bind("AnjingBetinaMandulList") %>' runat="server" />

                            <!-- --------------------------------------------------------------- -->
                            <!-- [EDIT] Panel Search Pemohon (Draf / Status = 0 Sahaja)         -->
                            <!-- --------------------------------------------------------------- -->
                            <asp:Panel runat="server" ID="panelSearch" Visible='<%# If(Eval("StatusID") = 0 And IsDBNull(Eval("SuratKelulusan1")), True, False) %>'>
                                <asp:HiddenField ID="HF_PermohonanID" runat="server" Value='<%# Bind("Permohonan_ID") %>' />
                                <div class="row align-items-end mb-3">
                                    <div class="col-md-8 col-lg-7">
                                        <div class="form-group mb-0">
                                            <label class="form-label-custom"><i class="bi bi-search me-1 text-primary"></i>Pilih Pemohon:</label>
                                            <asp:DropDownList ID="ddl_Pemohon" CssClass="form-control select2" runat="server" OnSelectedIndexChanged="ddl_Pemohon_SelectedIndexChanged"
                                                DataSourceID="SqlDataSourcePemohon" DataTextField="PemohonDesc" DataValueField="Pemohon_ID" AutoPostBack="true" CausesValidation="false">
                                            </asp:DropDownList>
                                            <asp:SqlDataSource runat="server" ID="SqlDataSourcePemohon" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                SelectCommand="SELECT NULL AS Pemohon_ID, '-- Sila Pilih --' AS PemohonDesc UNION ALL SELECT Pemohon_ID,  Pemohon_ICNo + ' - ' + Pemohon_Name AS PemohonDesc FROM LESEN_Pemohon WHERE Pemohon_IsActive = 1"></asp:SqlDataSource>
                                        </div>
                                    </div>
                                    <div class="col-md-4 col-lg-3 mt-2 mt-md-0">
                                        <asp:HyperLink runat="server" NavigateUrl="~/lesen/applicantregister.aspx?p_Id=3354&m_Id=3355" CssClass="btn btn-outline-primary w-100">
                                            <i class="bi bi-person-plus me-1"></i>Daftar Pemohon Baru
                                        </asp:HyperLink>
                                    </div>
                                </div>
                            </asp:Panel>

                            <asp:Panel runat="server" ID="pnlpemohon">
                                <div class="form-section-header">
                                    <i class="bi bi-person-vcard"></i>
                                    <span>Maklumat Pemohon</span>
                                </div>

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
                                                            CssClass="btn-remove-tag" CausesValidation="false">&times;</asp:LinkButton>
                                                    </div>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </div>
                                    </div>
                                </div>

                                <!-- =============================================================== -->
                                <!-- [EDIT] PANEL 1: LESEN PERNIAGAAN (Berisiko / Tidak Berisiko)   -->
                                <!-- =============================================================== -->
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
                                                                CommandName="Delete" CssClass="btn btn-danger btn-sm" CausesValidation="false">&times;</asp:LinkButton>
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
                                                <div id="pnlBakaLain1" class="mt-2 pnl-baka-lain" style="display:none;">
                                                    <asp:TextBox ID="TB_BakaLain1" runat="server" CssClass="form-control" placeholder="Nyatakan Jenis Baka" MaxLength="100" oninput="this.value = this.value.replace(/[^a-zA-Z\s]/g, '');"></asp:TextBox>
                                                </div>
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
                                                                CommandName="Delete" CssClass="btn btn-danger btn-sm" CausesValidation="false">&times;</asp:LinkButton>
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

                                <!-- =============================================================== -->
                                <!-- [EDIT] PANEL RUJUKAN: NO RUJUKAN & LOKASI FAIL                 -->
                                <!-- =============================================================== -->
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

                                <asp:Panel ID="pnlbatalTarikh" runat="server" CssClass="pnl-tarikh-batal" style="display:none;">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label class="form-label-custom">Tarikh</label>
                                                <asp:TextBox ID="TB_TarikhSebabBatal" runat="server"
                                                    Text='<%# Bind("TarikhSebabBatal", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="form-control" />
                                            </div>
                                        </div>
                                    </div>
                                </asp:Panel>

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
                        <!-- Card Footer: Tindakan / Action Buttons -->
                        <div class="card-footer d-flex flex-wrap gap-2 align-items-center">
                            <asp:LinkButton runat="server" CssClass="btn btn-warning" ValidationGroup="updateForm" Text="Kemaskini" CommandName="Update" ID="UpdateFormButton" CausesValidation="True">
                                <i class="bi bi-check-lg me-1"></i> Kemaskini
                            </asp:LinkButton>
                            <asp:LinkButton runat="server" Text="Kembali" ID="BackButton" CausesValidation="False" CssClass="btn btn-outline-secondary" OnClick="BackButton_Click">
                                <i class="bi bi-arrow-left me-1"></i> Kembali
                            </asp:LinkButton>
                        </div>
                    </div>
                </EditItemTemplate>

                <%-- =================================================================== --%>
                <%-- [SECTION 2] INSERT ITEM TEMPLATE (KUNCI MASUK PERMOHONAN)          --%>
                <%-- =================================================================== --%>
                <InsertItemTemplate>
                    <div class="card card-primary">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h3 class="card-title mb-0 font-weight-bold text-white">
                                <i class="bi bi-file-earmark-plus me-2"></i>Kunci Masuk Permohonan
                            </h3>
                        </div>
                        <!-- /.card-header -->
                        <div class="card-body">
                            <!-- Hidden Fields for Multi-Value Lists -->
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
                            </asp:Panel>

                            <!-- Section: Butiran Permohonan -->
                            <div class="form-section-header">
                                <i class="bi bi-card-checklist"></i>
                                <span>Maklumat Permohonan</span>
                            </div>

                            <div class="row">
                                <div class="col-md-4 col-lg-3">
                                    <div class="form-group">
                                        <label class="form-label-custom">Tarikh Mohon <span class="text-danger">*</span></label>
                                        <asp:TextBox ID="TB_TarikhMohon" runat="server"
                                            Text='<%# Bind("TarikhMohon", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="form-control" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" CssClass="cssRequiredField"
                                            ControlToValidate="TB_TarikhMohon" ErrorMessage="Sila Pilih Tarikh Mohon" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </div>
                                </div>

                                <div class="col-md-8 col-lg-9">
                                    <div class="form-group mb-2">
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

                                    <div class="tag-container">
                                        <asp:Repeater ID="rptSelectedItems" runat="server" OnItemCommand="rptSelectedItems_ItemCommand">
                                            <ItemTemplate>
                                                <div class="tag-pill">
                                                    <span><%# Eval("ItemText") %></span>
                                                    <asp:LinkButton ID="btnRemove" runat="server" 
                                                        CommandName="Remove" 
                                                        CommandArgument='<%# Eval("ItemValue") %>' 
                                                        CssClass="btn-remove-tag"
                                                        CausesValidation="false"
                                                        ToolTip="Buang jenis lesen">&times;</asp:LinkButton>
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
                                                Text='<%# Bind("JenisPerniagaan") %>' TextMode="MultiLine" Rows="3" CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator11" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_JenisPerniagaan" ErrorMessage="Sila Isi Jenis Perniagaan" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                </div>

                                <%--# Tukar Pemilik #--%>
                                <asp:Panel ID="pnlesen1b" runat="server" Visible="False">
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

                                <%--# Tarikh Batal #--%>
                                <asp:Panel ID="pnlbatal" runat="server" Visible="False">
                                    <div class="row">
                                        <div class="col-md-4 col-lg-3">
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

                            <!-- =============================================================== -->
                            <!-- [INSERT] PANEL 1A: LESEN PAPAN IKLAN PREMIS                   -->
                            <!-- =============================================================== -->
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
                                                            CommandName="Delete" CssClass="btn btn-danger btn-sm" CausesValidation="false">&times;</asp:LinkButton>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </div>
                                </div>
                            </asp:Panel>

                            <!-- =============================================================== -->
                            <!-- [INSERT] PANEL BILLBOARD: PAPAN IKLAN LUAR / BILLBOARD        -->
                            <!-- =============================================================== -->
                            <asp:Panel ID="pnlbillboard" runat="server" Visible="False">
                                <div class="form-section-header">
                                    <i class="bi bi-display"></i>
                                    <span>Maklumat Billboard</span>
                                </div>

                                <div class="row">
                                    <div class="col-md-8 col-lg-6">
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

                            <!-- =============================================================== -->
                            <!-- [INSERT] PANEL 2: LESEN PASAR (Pagi/Malam/Lambak/Sehari)      -->
                            <!-- =============================================================== -->
                            <asp:Panel ID="pnlesen2" runat="server" Visible="False">
                                <div class="form-section-header">
                                    <i class="bi bi-basket"></i>
                                    <span>Maklumat Pasar</span>
                                </div>

                                <div class="row">
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label class="form-label-custom">Lokasi Pasar #1 <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="TB_LokasiPasar1" runat="server"
                                                Text='<%# Bind("LokasiPasar1") %>' TextMode="MultiLine" Rows="2" CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator16" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_LokasiPasar1" ErrorMessage="Sila Isi Lokasi Pasar" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
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

                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label class="form-label-custom">Jumlah Petak/Tapak/Lot <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="TB_JumlahPetak" runat="server"
                                                Text='<%# Bind("JumlahPetak") %>' CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator19" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_JumlahPetak" ErrorMessage="Sila Isi Jumlah Petak" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label class="form-label-custom">Jenis Jualan <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="TB_JenisPerniagaanPasar" runat="server"
                                                Text='<%# Bind("JenisPerniagaanPasar") %>' CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator18" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_JenisPerniagaanPasar" ErrorMessage="Sila Isi Jenis Jualan" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                </div>
                            </asp:Panel>

                            <!-- =============================================================== -->
                            <!-- [INSERT] PANEL 3: LESEN ANJING                                -->
                            <!-- =============================================================== -->
                            <asp:Panel ID="pnlesen3" runat="server" Visible="False">
                                <div class="form-section-header">
                                    <i class="bi bi-heart-pulse"></i>
                                    <span>Maklumat Lesen Anjing</span>
                                </div>

                                <div class="row">
                                    <div class="col-md-8">
                                        <div class="form-group">
                                            <label class="form-label-custom">Alamat Lokasi <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="TB_AnjingAlamat" runat="server"
                                                Text='<%# Bind("AnjingAlamat") %>' TextMode="MultiLine" Rows="2" CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_AnjingAlamat" ErrorMessage="Sila Isi Alamat Lokasi" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                    <div class="col-md-4">
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
                                    <div class="col-md-3">
                                        <div class="form-group mb-md-0">
                                            <label class="form-label-custom">Jenis Baka</label>
                                            <asp:DropDownList ID="DDL_BakaAnjing1" CssClass="form-control select2" runat="server"
                                                DataSourceID="SqlDataSourceAnjingBaka1" DataTextField="name" DataValueField="id">
                                            </asp:DropDownList>
                                            <asp:SqlDataSource runat="server" ID="SqlDataSourceAnjingBaka1" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                SelectCommand="SELECT NULL AS id, '-- Sila Pilih --' AS name UNION ALL SELECT id, name 
                                                        FROM TBL_LOOKUPS WHERE lookupgrp_id = 10004 AND status = 1"></asp:SqlDataSource>
                                                <div id="pnlBakaLain1" class="mt-2 pnl-baka-lain" style="display:none;">
                                                    <asp:TextBox ID="TB_BakaLain1" runat="server" CssClass="form-control" placeholder="Nyatakan Jenis Baka" MaxLength="100" oninput="this.value = this.value.replace(/[^a-zA-Z\s]/g, '');"></asp:TextBox>
                                                </div>
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
                                                            CommandName="Delete" CssClass="btn btn-danger btn-sm" CausesValidation="false">&times;</asp:LinkButton>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </div>
                                </div>
                            </asp:Panel>

                            <!-- =============================================================== -->
                            <!-- [INSERT] PANEL 4: LESEN PENJAJA                               -->
                            <!-- =============================================================== -->
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
                                            <label class="form-label-custom">Jenis Jualan <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="TB_JenisPerniagaanPenjaja" runat="server"
                                                Text='<%# Bind("JenisPerniagaanPenjaja") %>' CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator22" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_JenisPerniagaanPenjaja" ErrorMessage="Sila Isi Jenis Jualan" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-12">
                                        <div class="form-group">
                                            <label class="form-label-custom">Alamat Aktiviti Penjajaan <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="TB_AlamatPenjajaan" runat="server"
                                                Text='<%# Bind("AlamatPenjajaan") %>' TextMode="MultiLine" Rows="2" CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator21" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_AlamatPenjajaan" ErrorMessage="Sila Isi Alamat Penjajaan" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
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

                            <!-- =============================================================== -->
                            <!-- [INSERT] PANEL 5: PERMIT EKSPO                                  -->
                            <!-- =============================================================== -->
                            <asp:Panel ID="pnlesen5" runat="server" Visible="False">
                                <div class="form-section-header">
                                    <i class="bi bi-calendar-event"></i>
                                    <span>Maklumat Ekspo / Program</span>
                                </div>

                                <div class="row">
                                    <div class="col-md-5">
                                        <div class="form-group">
                                            <label class="form-label-custom">Nama Penganjur <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="TB_PenganjurEkspo" runat="server"
                                                Text='<%# Bind("PenganjurEkspo") %>' CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator23" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_PenganjurEkspo" ErrorMessage="Sila Isi Nama Penganjur" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
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
                                            <label class="form-label-custom">Nama Aktiviti / Program <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="TB_NamaEkspo" runat="server"
                                                Text='<%# Bind("NamaEkspo") %>' CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator24" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_NamaEkspo" ErrorMessage="Sila Isi Nama Aktiviti/Program" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
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

                            <!-- =============================================================== -->
                            <!-- [INSERT] PANEL RUJUKAN: NO RUJUKAN & LOKASI FAIL                -->
                            <!-- =============================================================== -->
                            <asp:Panel ID="pnlrujukan" runat="server" Visible="False">
                                <div class="form-section-header">
                                    <i class="bi bi-info-circle"></i>
                                    <span>Maklumat Rujukan &amp; Pentadbiran</span>
                                </div>

                                <div class="row">
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label class="form-label-custom">No Rujukan <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="TB_Rujukan" runat="server"
                                                Text='<%# Bind("Rujukan") %>' CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator29" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_Rujukan" ErrorMessage="Sila Isi No Rujukan" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label class="form-label-custom">No Akaun Cukai <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="TB_NoAkaunCukai" runat="server"
                                                Text='<%# Bind("NoAkaunCukai") %>' CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator33" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_NoAkaunCukai" ErrorMessage="Sila Isi No Akaun Cukai" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
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

                                <div class="row my-2">
                                    <div class="col-md-4 col-lg-3">
                                        <div class="checkbox-box">
                                            <asp:CheckBox ID="CB_Deposit" runat="server" OnCheckedChanged="CB_Deposit_CheckedChanged" AutoPostBack="true" CausesValidation="false" />
                                            <span class="fw-bold text-dark">Ada Deposit?</span>
                                        </div>
                                    </div>
                                </div>
                            </asp:Panel>

                            <!-- =============================================================== -->
                            <!-- [INSERT] SECTION: DEPOSIT WANG AMANAH / CAGARAN                 -->
                            <!-- =============================================================== -->
                            <asp:Panel ID="pnldeposit" runat="server" Visible="False">
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
                                            <label class="form-label-custom">No Resit</label>
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

                            <!-- =============================================================== -->
                            <!-- [INSERT] SECTION: MAKLUMAT PEMBATALAN PERMIT / LESEN            -->
                            <!-- =============================================================== -->
                            <asp:Panel ID="pnlbatal1" runat="server" Visible="false">
                                <div class="row my-2">
                                    <div class="col-md-4 col-lg-3">
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
                                                    ControlToValidate="DDL_SebabBatal1" ErrorMessage="Sila Pilih Sebab" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
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
                                                    ControlToValidate="DDL_SebabBatal2" ErrorMessage="Sila Pilih Sebab" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
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
                                                ControlToValidate="DDL_TindakanBatal" ErrorMessage="Sila Pilih Tindakan" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                </div>

                                <asp:Panel ID="pnlbatalTarikh" runat="server" CssClass="pnl-tarikh-batal" style="display:none;">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label class="form-label-custom">Tarikh</label>
                                                <asp:TextBox ID="TB_TarikhSebabBatal" runat="server"
                                                    Text='<%# Bind("TarikhSebabBatal", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="form-control" />
                                            </div>
                                        </div>
                                    </div>
                                </asp:Panel>

                                <asp:Panel ID="pnlbatal5" runat="server" Visible="false">
                                    <div class="row">
                                        <div class="col-md-12">
                                            <div class="form-group">
                                                <label class="form-label-custom">Catatan</label>
                                                <asp:TextBox ID="TB_Remarks2" runat="server" TextMode="MultiLine" Rows="2"
                                                    Text='<%# Bind("RemarksBatal") %>' CssClass="form-control" />
                                            </div>
                                        </div>
                                    </div>
                                </asp:Panel>
                            </asp:Panel>

                        </div>

                        <!-- =============================================================== -->
                        <!-- [INSERT] FORM ACTIONS (SIMPAN / KEMBALI)                        -->
                        <!-- =============================================================== -->
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

            <!-- ======================================================================= -->
            <!-- DATA SOURCE: SQLDATASOURCEFORM (INSERT / SELECT / UPDATE)               -->
            <!-- ======================================================================= -->
            <asp:SqlDataSource runat="server" ID="SqlDataSourceForm" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                InsertCommand="INSERT INTO LESEN_Permohonan(JenisLesenDescList, JenisLesenIdList, SaizIklanList, CahayaIklanList, UnitIklanList,  
                        Permohonan_PemohonID, TarikhMohon, JenisLesen_ID, StatusID, NamaSyarikat, NoPendaftaran, NoAkaun, AlamatPremis, JenisPerniagaan,
                        PemilikBaru, AlamatBaru, JenisPerniagaanBaru, NamaBaruSyarikat, BillboardLokasi, LokasiPasar1, LokasiPasar2, LokasiPasar3, JenisPasar,
                        JenisPerniagaanPasar, JumlahPetak, AnjingAlamat, AnjingJenisPremis, JenisPenjaja, StatusTanahPenjaja, AlamatPenjajaan, JenisPerniagaanPenjaja, MasaPenjaja1, MasaPenjaja2,
                        JenisKenderaanPenjaja, NoKenderaanPenjaja, TarikhBatal, PenganjurEkspo, AlamatPenganjurEkspo, PicEkspo, NoTelEkspo, NamaEkspo, LokasiEkspo, TarikhEkspo1, TarikhEkspo2, MasaEkspo1, MasaEkspo2, 
                        TentatifEkspo, JemputanEkspo, PembersihanEkspo, TarikhKhemahEkspo1, TarikhKhemahEkspo2, 
                        Rujukan, NoAkaunCukai, DepositAmount, DepositDate, DepositResitNo, DepositPulangAmount, 
                        Is24jam, IsBatal, JenisBatal, SebabBatalPerm, SebabBatalTanpaPerm, TarikhSebabBatal, RemarksBatal, TindakanBatal, IsPulang, IsSuratKelulusanFail, IsSuratPembatalanFail, IsSuratPemeriksaanFail, IsRekodLama, RemarksFail, CreatorID, CreatedDt, LastModID, LastModDt) 
                        VALUES (@JenisLesenDescList, @JenisLesenIdList, @SaizIklanList, @CahayaIklanList, @UnitIklanList, 
                        @Permohonan_PemohonID, @TarikhMohon, 0, 10, @NamaSyarikat, @NoPendaftaran, @NoAkaun, @AlamatPremis, @JenisPerniagaan, @PemilikBaru, @AlamatBaru,
                        @JenisPerniagaanBaru, @NamaBaruSyarikat, @BillboardLokasi, @LokasiPasar1, @LokasiPasar2, @LokasiPasar3, @JenisPasar, @JenisPerniagaanPasar,
                        @JumlahPetak, @AnjingAlamat, @AnjingJenisPremis, @JenisPenjaja, @StatusTanahPenjaja, @AlamatPenjajaan, @JenisPerniagaanPenjaja, @MasaPenjaja1, @MasaPenjaja2, @JenisKenderaanPenjaja, @NoKenderaanPenjaja,
                        @TarikhBatal, @PenganjurEkspo, @AlamatPenganjurEkspo, @PicEkspo, @NoTelEkspo, @NamaEkspo, @LokasiEkspo, @TarikhEkspo1, @TarikhEkspo2, @MasaEkspo1, @MasaEkspo2, 
                        @TentatifEkspo, @JemputanEkspo, @PembersihanEkspo, @TarikhKhemahEkspo1, @TarikhKhemahEkspo2, 
                        @Rujukan, @NoAkaunCukai, @DepositAmount, @DepositDate, @DepositResitNo, @DepositPulangAmount, 
                        @Is24jam, @IsBatal, @JenisBatal, @SebabBatalPerm, @SebabBatalTanpaPerm, @TarikhSebabBatal, @RemarksBatal, @TindakanBatal, 0, 0, 0, 0, 1, @RemarksFail, @CreatorId, GETDATE(), @CreatorId, GETDATE()); SELECT @Permohonan_ID = SCOPE_IDENTITY();"
                SelectCommand="SELECT * FROM LESEN_Permohonan WHERE Permohonan_ID = @Permohonan_ID"
                UpdateCommand="UPDATE LESEN_Permohonan SET JenisLesenDescList = @JenisLesenDescList, JenisLesenIdList = @JenisLesenIdList, SaizIklanList = @SaizIklanList, CahayaIklanList = @CahayaIklanList, UnitIklanList = @UnitIklanList, LokasiList = @LokasiList, 
                        Permohonan_PemohonID = @Permohonan_PemohonID, TarikhMohon = @TarikhMohon, StatusID = @StatusID, NamaSyarikat = @NamaSyarikat, NoPendaftaran = @NoPendaftaran, NoAkaun = @NoAkaun, AlamatPremis = @AlamatPremis, 
                        JenisPerniagaan = @JenisPerniagaan, PemilikBaru = @PemilikBaru, AlamatBaru = @AlamatBaru, JenisPerniagaanBaru = @JenisPerniagaanBaru, NamaBaruSyarikat = @NamaBaruSyarikat,  
                        BillboardLokasi = @BillboardLokasi, LokasiPasar1 = @LokasiPasar1, LokasiPasar2 = @LokasiPasar2, LokasiPasar3 = @LokasiPasar3,
                        JenisPasar = @JenisPasar, JenisPerniagaanPasar = @JenisPerniagaanPasar, JumlahPetak = @JumlahPetak, AnjingAlamat = @AnjingAlamat, AnjingJenisPremis = @AnjingJenisPremis, JenisPenjaja = @JenisPenjaja, StatusTanahPenjaja = @StatusTanahPenjaja,
                        AlamatPenjajaan = @AlamatPenjajaan, JenisPerniagaanPenjaja = @JenisPerniagaanPenjaja, MasaPenjaja1 = @MasaPenjaja1, MasaPenjaja2 = @MasaPenjaja2, JenisKenderaanPenjaja = @JenisKenderaanPenjaja, NoKenderaanPenjaja = @NoKenderaanPenjaja,
                        TarikhBatal = @TarikhBatal, PenganjurEkspo = @PenganjurEkspo, AlamatPenganjurEkspo = @AlamatPenganjurEkspo, PicEkspo = @PicEkspo, NoTelEkspo = @NoTelEkspo, NamaEkspo = @NamaEkspo, LokasiEkspo = @LokasiEkspo, 
                        TarikhEkspo1 = @TarikhEkspo1, TarikhEkspo2 = @TarikhEkspo2, MasaEkspo1 = @MasaEkspo1, MasaEkspo2 = @MasaEkspo2, TentatifEkspo = @TentatifEkspo, JemputanEkspo = @JemputanEkspo, PembersihanEkspo = @PembersihanEkspo, 
                        TarikhKhemahEkspo1 = @TarikhKhemahEkspo1, TarikhKhemahEkspo2 = @TarikhKhemahEkspo2, 
                        Rujukan = @Rujukan, NoAkaunCukai = @NoAkaunCukai, DepositAmount = @DepositAmount, 
                        DepositDate = @DepositDate, DepositResitNo = @DepositResitNo, DepositPulangAmount = @DepositPulangAmount, Is24jam = @Is24jam, IsBatal = @IsBatal, JenisBatal = @JenisBatal, SebabBatalPerm = @SebabBatalPerm, 
                        SebabBatalTanpaPerm = @SebabBatalTanpaPerm, TarikhSebabBatal = @TarikhSebabBatal, RemarksBatal = @RemarksBatal, TindakanBatal = @TindakanBatal, RemarksFail = @RemarksFail, LastModId = @LastModId, LastModDt = GETDATE() 
                        WHERE (Permohonan_ID = @Permohonan_ID)">
                <InsertParameters>
                    <asp:Parameter Name="JenisLesenDescList"></asp:Parameter>
                    <asp:Parameter Name="JenisLesenIdList"></asp:Parameter>
                    <asp:Parameter Name="SaizIklanList"></asp:Parameter>
                    <asp:Parameter Name="CahayaIklanList"></asp:Parameter>
                    <asp:Parameter Name="UnitIklanList"></asp:Parameter>
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
                    <asp:Parameter Name="TarikhSebabBatal"></asp:Parameter>
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
                    <asp:Parameter Name="TarikhSebabBatal"></asp:Parameter>
                    <asp:Parameter Name="RemarksBatal"></asp:Parameter>
                    <asp:Parameter Name="TindakanBatal"></asp:Parameter>
                    <asp:SessionParameter SessionField="sessionUserName" Name="LastModId"></asp:SessionParameter>
                    <asp:Parameter Name="Permohonan_ID"></asp:Parameter>
                </UpdateParameters>
            </asp:SqlDataSource>
            <br />

            <!-- ======================================================================= -->
            <!-- SECTION: SENARAI PERMOHONAN & FILTER                                    -->
            <!-- ======================================================================= -->
            <div class="row" id="whiteCard" runat="server">
                <div class="col-12">
                    <div class="card card-primary">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h3 class="card-title mb-0 font-weight-bold"><i class="bi bi-card-checklist me-2"></i>Senarai Permohonan</h3>
                            <div>
                                <asp:Button ID="ButtonAddAssignment" runat="server" Text="Rekod Permohonan Lama" CssClass="btn btn-light btn-sm fw-semibold shadow-sm" CausesValidation="false" />
                            </div>
                        </div>
                        <div class="card-body">

                            <%--# START FILTER - set SortExpression at GridView as PRName & add WHERE 1=1 at SqlDataSource - SelectCommand #--%>
                            <div class="row" id="panelFilter" runat="server">
                                <asp:HiddenField ID="hfFilterExpanded" runat="server" Value="0" />
                                <div class="col-12">
                                    <div class="form-section-header mt-0 mb-3 d-flex flex-wrap justify-content-between align-items-center gap-2">
                                        <div class="d-flex align-items-center gap-2">
                                            <i class="bi bi-funnel"></i>
                                            <span>Carian &amp; Penapis Rekod</span>
                                        </div>
                                        <%--<div>
                                            <button type="button" class="btn btn-outline-primary btn-sm d-inline-flex align-items-center gap-2 shadow-sm" 
                                                data-bs-toggle="collapse" data-bs-target="#collapseFilterExtra" aria-expanded="false" aria-controls="collapseFilterExtra" id="btnToggleFilterExtra">
                                                <i class="bi bi-sliders2"></i>
                                                <span id="btnToggleFilterExtraText">Penapis Tambahan</span>
                                                <span class="badge bg-primary text-white rounded-pill d-none" id="badgeActiveExtraCount">0</span>
                                                <i class="bi bi-chevron-down" id="iconFilterCollapse" style="transition: transform 0.25s ease;"></i>
                                            </button>
                                        </div>--%>
                                    </div>
                                </div>
                                <div class="col-md-12">
                                    <!-- ================= MAIN FILTERS (Not affected by collapse) ================= -->
                                    <div class="row">
                                        <!-- 1. Tarikh Mohon -->
                                        <div class="col-lg-4 col-md-6 col-12">
                                            <div class="form-group">
                                                <label class="form-label-custom">Tarikh Mohon</label>
                                                <asp:TextBox ID="TB_TarikhMohon" runat="server"
                                                    TextMode="Date" CssClass="form-control" />
                                            </div>
                                        </div>

                                        <!-- 2. No Rujukan -->
                                        <div class="col-lg-4 col-md-6 col-12">
                                            <div class="form-group">
                                                <label class="form-label-custom">No Rujukan</label>
                                                <asp:TextBox ID="txtNoRujukan" placeholder="No Rujukan" runat="server" CssClass="form-control"></asp:TextBox>
                                            </div>
                                        </div>

                                        <!-- 3. Dicipta Oleh -->
                                        <div class="col-lg-4 col-md-6 col-12" runat="server" id="filterCreatedBy">
                                            <div class="form-group">
                                                <label class="form-label-custom">Dicipta Oleh</label>
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
                                    </div>
                                    <!-- ================= END MAIN FILTERS ================= -->

                                    <!-- ================= COLLAPSIBLE FILTERS ================= -->
                                    <div class="collapse" id="collapseFilterExtra">
                                        <div class="p-3 mb-3 rounded-3 border shadow-sm" style="background-color: #f8fafc; border-color: #e2e8f0 !important;">
                                            <div class="d-flex align-items-center justify-content-between mb-3 pb-2 border-bottom">
                                                <span class="text-secondary small fw-bold text-uppercase d-inline-flex align-items-center gap-1">
                                                    <i class="bi bi-sliders text-primary"></i>Penapis Tambahan
                                                </span>
                                                <button type="button" class="btn btn-link btn-sm text-decoration-none p-0 text-muted small" id="btnResetExtraOnly" title="Kosongkan penapis tambahan sahaja">
                                                    <i class="bi bi-arrow-counterclockwise me-1"></i>Kosongkan Pilihan Ini
                                                </button>
                                            </div>

                                            <!-- 1. MAKLUMAT PEMOHON SECTION -->
                                            <div class="filter-section-pemohon mb-3">
                                                <div class="d-flex align-items-center justify-content-between mb-2">
                                                    <span class="fw-semibold text-dark small d-inline-flex align-items-center gap-2">
                                                        <i class="bi bi-person-vcard text-primary fs-6"></i>
                                                        <span>Maklumat Pemohon</span>
                                                    </span>
                                                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle rounded-pill small d-none" id="badgePemohonActive">0 aktif</span>
                                                </div>

                                                <div class="row g-2">
                                                    <!-- 1. Pemohon (Nama) -->
                                                    <div class="col-lg-4 col-md-6 col-12" id="wrapPemohonNama">
                                                        <div class="form-group mb-0">
                                                            <label class="form-label-custom">Nama Pemohon</label>
                                                            <asp:DropDownList ID="DDL_Pemohon" CssClass="form-control select2" runat="server" AutoPostBack="false"
                                                                DataSourceID="sdsPemohon" DataTextField="Pemohon_Name" DataValueField="Pemohon_ID">
                                                            </asp:DropDownList>
                                                            <asp:SqlDataSource runat="server" ID="sdsPemohon" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                                SelectCommand="select * from 
                                                            (select 0 as Pemohon_ID, '-- Pemohon --' as Pemohon_Name
                                                            union all
                                                            select Pemohon_ID, Pemohon_Name from LESEN_Pemohon where Pemohon_IsActive=1
                                                            ) as tbl1 order by Pemohon_Name"></asp:SqlDataSource>
                                                        </div>
                                                    </div>

                                                    <!-- 2. No Kad Pengenalan / Pasport -->
                                                    <div class="col-lg-4 col-md-6 col-12" id="wrapPemohonIC">
                                                        <div class="form-group mb-0">
                                                            <label class="form-label-custom">No. Kad Pengenalan / Pasport</label>
                                                            <asp:TextBox ID="txtFilterPemohonIC" placeholder="No. KP / Pasport Pemohon" runat="server" CssClass="form-control"></asp:TextBox>
                                                        </div>
                                                    </div>

                                                    <!-- 3. No Telefon -->
                                                    <div class="col-lg-4 col-md-6 col-12" id="wrapPemohonTel">
                                                        <div class="form-group mb-0">
                                                            <label class="form-label-custom">No. Telefon / Bimbit</label>
                                                            <asp:TextBox ID="txtFilterPemohonTel" placeholder="No. Telefon / Bimbit" runat="server" CssClass="form-control"></asp:TextBox>
                                                        </div>
                                                    </div>

                                                    <!-- 4. Emel Pemohon -->
                                                    <div class="col-lg-4 col-md-6 col-12" id="wrapPemohonEmail">
                                                        <div class="form-group mb-0">
                                                            <label class="form-label-custom">Emel Pemohon</label>
                                                            <asp:TextBox ID="txtFilterPemohonEmail" placeholder="Emel Pemohon" runat="server" CssClass="form-control"></asp:TextBox>
                                                        </div>
                                                    </div>

                                                    <!-- 5. Syarikat -->
                                                    <div class="col-lg-4 col-md-6 col-12" id="wrapPemohonSyarikat">
                                                        <div class="form-group mb-0">
                                                            <label class="form-label-custom">Nama Syarikat</label>
                                                            <asp:TextBox ID="txtFilterSyarikat" placeholder="Nama Syarikat" runat="server" CssClass="form-control"></asp:TextBox>
                                                        </div>
                                                    </div>

                                                    <!-- 6. No Pendaftaran Syarikat (SSM) -->
                                                    <div class="col-lg-4 col-md-6 col-12" id="wrapPemohonSSM">
                                                        <div class="form-group mb-0">
                                                            <label class="form-label-custom">No. Pendaftaran Syarikat (SSM)</label>
                                                            <asp:TextBox ID="txtFilterNoPendaftaran" placeholder="No. Pendaftaran Syarikat" runat="server" CssClass="form-control"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- ================= HR DIVIDER ================= -->
                                            <hr class="my-3 border-secondary-subtle" />

                                            <!-- 2. MAKLUMAT PERMOHONAN SECTION -->
                                            <div class="filter-section-permohonan">
                                                <div class="d-flex align-items-center justify-content-between mb-2">
                                                    <span class="fw-semibold text-dark small d-inline-flex align-items-center gap-2">
                                                        <i class="bi bi-file-earmark-text text-primary fs-6"></i>
                                                        <span>Maklumat Permohonan</span>
                                                    </span>
                                                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle rounded-pill small d-none" id="badgePermohonanActive">0 aktif</span>
                                                </div>

                                                <div class="row g-2">
                                                    <!-- 1. Jenis Lesen / Permit -->
                                                    <div class="col-lg-3 col-md-6 col-12" id="wrapPermohonanJenisLesen">
                                                        <div class="form-group mb-0">
                                                            <label class="form-label-custom">Jenis Lesen / Permit</label>
                                                            <asp:ListBox ID="lstJenisLesen" runat="server" SelectionMode="Multiple"
                                                                CssClass="form-control select2"
                                                                DataSourceID="SqlDataSourceLesen" DataTextField="JenisLesen_Description" DataValueField="JenisLesen_Description"
                                                                data-placeholder="-- Pilih Jenis Lesen / Permit --">
                                                            </asp:ListBox>
                                                            <asp:HiddenField ID="hfSelectedJenisLesen" runat="server" Value="" />
                                                            <asp:SqlDataSource runat="server" ID="SqlDataSourceLesen" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                                SelectCommand="SELECT JenisLesen_Description FROM LESEN_JenisLesen WHERE JenisLesen_IsActive=1 ORDER BY JenisLesen_Description">
                                                            </asp:SqlDataSource>
                                                        </div>
                                                    </div>

                                                    <!-- 2. Alamat Premis -->
                                                    <div class="col-lg-3 col-md-6 col-12" id="wrapPermohonanAlamat">
                                                        <div class="form-group mb-0">
                                                            <label class="form-label-custom">Alamat Premis / Lokasi</label>
                                                            <asp:TextBox ID="TB_Alamat" placeholder="Alamat Premis / Lokasi" runat="server" CssClass="form-control"></asp:TextBox>
                                                        </div>
                                                    </div>

                                                    <!-- 3. Jenis Perniagaan -->
                                                    <div class="col-lg-3 col-md-6 col-12" id="wrapPermohonanPerniagaan">
                                                        <div class="form-group mb-0">
                                                            <label class="form-label-custom">Jenis Perniagaan</label>
                                                            <asp:TextBox ID="txtFilterJenisPerniagaan" placeholder="Jenis Perniagaan" runat="server" CssClass="form-control"></asp:TextBox>
                                                        </div>
                                                    </div>

                                                    <!-- 4. No Akaun / Cukai -->
                                                    <div class="col-lg-3 col-md-6 col-12" id="wrapPermohonanAkaun">
                                                        <div class="form-group mb-0">
                                                            <label class="form-label-custom">No. Akaun / Cukai</label>
                                                            <asp:TextBox ID="txtFilterNoAkaun" placeholder="No. Akaun / No. Cukai" runat="server" CssClass="form-control"></asp:TextBox>
                                                        </div>
                                                    </div>

                                                    <!-- 5. Status Risiko -->
                                                    <div class="col-lg-3 col-md-6 col-12" runat="server" id="wrapPermohonanRisiko">
                                                        <div class="form-group mb-0">
                                                            <label class="form-label-custom">Status Risiko (24 Jam)</label>
                                                            <asp:DropDownList ID="DDL_Risiko" runat="server" AutoPostBack="false" CssClass="form-control select2">
                                                                <asp:ListItem Value="2">-- Risiko --</asp:ListItem>
                                                                <asp:ListItem Value="0">Berisiko</asp:ListItem>
                                                                <asp:ListItem Value="1">Tidak Berisiko</asp:ListItem>
                                                            </asp:DropDownList>
                                                        </div>
                                                    </div>

                                                    <!-- 6. Status Pembatalan -->
                                                    <div class="col-lg-3 col-md-6 col-12" runat="server" id="wrapPermohonanPembatalan">
                                                        <div class="form-group mb-0">
                                                            <label class="form-label-custom">Status Pembatalan</label>
                                                            <asp:DropDownList ID="DDL_Pembatalan" runat="server" AutoPostBack="false" CssClass="form-control select2">
                                                                <asp:ListItem Value="2">-- Pembatalan --</asp:ListItem>
                                                                <asp:ListItem Value="1">Ya</asp:ListItem>
                                                                <asp:ListItem Value="0">Tidak</asp:ListItem>
                                                            </asp:DropDownList>
                                                        </div>
                                                    </div>

                                                    <!-- 7. Catatan Permohonan -->
                                                    <div class="col-lg-6 col-md-12 col-12" id="wrapPermohonanRemarks">
                                                        <div class="form-group mb-0">
                                                            <label class="form-label-custom">Catatan Permohonan</label>
                                                            <asp:TextBox ID="txtFilterRemarksFail" placeholder="Catatan Fail / Permohonan" runat="server" CssClass="form-control"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- ================= END COLLAPSIBLE FILTERS ================= -->

                                    <!-- ================= ACTION BUTTONS ROW ================= -->
                                    <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 pt-2 border-top">
                                        <div>
                                            <button type="button" class="btn btn-outline-secondary btn-sm d-inline-flex align-items-center gap-2 shadow-sm" 
                                                data-bs-toggle="collapse" data-bs-target="#collapseFilterExtra" aria-expanded="false" aria-controls="collapseFilterExtra" id="btnToggleFilterBottom">
                                                <i class="bi bi-sliders2"></i>
                                                <span id="btnToggleFilterBottomText">Penapis Tambahan</span>
                                                <span class="badge bg-primary text-white rounded-pill d-none ms-1" id="badgeActiveExtraCountBottom">0</span>
                                                <i class="bi bi-chevron-down ms-1" id="iconFilterCollapseBottom" style="transition: transform 0.25s ease;"></i>
                                            </button>
                                        </div>
                                        <div class="d-flex gap-2">
                                            <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-primary px-4 fw-semibold shadow-sm" Text="Cari" CausesValidation="false" />
                                            <asp:Button ID="btnReset" CssClass="btn btn-outline-secondary px-3 fw-semibold shadow-sm" runat="server" Text="Reset" CausesValidation="false" />
                                        </div>
                                    </div>
                                    <!-- ================= END ACTION BUTTONS ROW ================= -->
                                </div>
                            </div>
                            <%--# END FILTER #--%>

                            <!-- GridView: Senarai Permohonan -->
                            <div class="table-responsive mt-3">
                                <asp:GridView ID="GridView1" CssClass="table table-hover table-bordered custom-gridview align-middle" AllowPaging="True" PageSize="20"
                                    ShowHeaderWhenEmpty="True" EmptyDataText="Tiada Rekod Dijumpai" AllowSorting="True" runat="server" AutoGenerateColumns="False"
                                    DataKeyNames="Permohonan_ID, StatusID, IsBatal, JenisLesen_ID, IsPublish, Is24Jam, JenisLesenIdList" DataSourceID="SqlDataSourceGrid">
                                    <PagerStyle CssClass="pagination-custom" HorizontalAlign="Right" />
                                    <Columns>
                                        <asp:BoundField DataField="Permohonan_ID" HeaderText="ID" SortExpression="Permohonan_ID" Visible="false"></asp:BoundField>
                                        <asp:BoundField DataField="RowNo" HeaderText="No" SortExpression="RowNo"></asp:BoundField>
                                        <asp:BoundField DataField="TarikhMohon" HeaderText="Tarikh" DataFormatString="{0:dd/MM/yyyy}" SortExpression="TarikhMohon"></asp:BoundField>
                                        <asp:BoundField DataField="JenisLesenDescList" HeaderText="Jenis Lesen/Permit" SortExpression="JenisLesenDescList"></asp:BoundField>
                                        <asp:TemplateField>
                                            <HeaderTemplate>
                                                <span class="fw-bold">Pemohon</span>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <div class="fw-semibold text-dark"><asp:Label ID="lblNamaPemohon" runat="server" Text='<%# Eval("Pemohon_Name") %>'></asp:Label></div>
                                                <div class="text-primary small"><i class="bi bi-upc-scan me-1"></i><asp:Label ID="lblRujukan" runat="server" Text='<%# Eval("Rujukan") %>'></asp:Label></div>
                                                <div class="text-muted small"><i class="bi bi-building me-1"></i><asp:Label ID="lblNamaSyarikatOrAlamat" runat="server" Text='<%# If(Not String.IsNullOrEmpty(Eval("NamaBaruSyarikat")?.ToString()), Eval("NamaBaruSyarikat"), If(Not String.IsNullOrEmpty(Eval("NamaSyarikat")?.ToString()), Eval("NamaSyarikat"), Eval("DisplayAlamat"))) %>'></asp:Label></div>
                                                <div class="text-secondary small"><asp:Label ID="lblNamaAlamat" runat="server" Visible='<%# If(String.IsNullOrEmpty(Eval("NamaSyarikat")?.ToString()) And String.IsNullOrEmpty(Eval("NamaBaruSyarikat")?.ToString()), False, True) %>' 
                                                    Text='<%# Eval("DisplayAlamat") %>'></asp:Label></div>
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
                                        <asp:BoundField DataField="RemarksFail" HeaderText="Catatan" SortExpression="RemarksFail"></asp:BoundField>

                                        <asp:TemplateField ShowHeader="False">
                                            <ItemTemplate>
                                                <div class="d-flex flex-wrap gap-1 align-items-center justify-content-center">
                                                    <asp:LinkButton runat="server" CssClass="btn btn-primary btn-sm text-nowrap" CommandName="Select" CausesValidation="False" ID="LinkButton1" data-toggle="tooltip" data-placement="top" title="Lihat">
                                                        <i class="bi bi-eye me-1"></i>Lihat
                                                    </asp:LinkButton>
                                                    <asp:LinkButton runat="server" CssClass="btn btn-outline-danger btn-sm text-nowrap" CommandName="Delete" CausesValidation="False" ID="LinkButton2" OnClientClick="return confirm('Anda pasti untuk memadam rekod ini?');" data-toggle="tooltip" data-placement="top" title="Padam">
                                                        <i class="bi bi-trash me-1"></i>Padam
                                                    </asp:LinkButton>
                                                </div>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>

                            <!-- Data Source: GridView Permohonan -->
                            <asp:SqlDataSource runat="server" ID="SqlDataSourceGrid" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                DeleteCommand="DELETE FROM LESEN_Permohonan WHERE Permohonan_ID = @Permohonan_ID;
                                        DELETE FROM LESEN_KadarBayaran WHERE KadarBayaran_PermohonanID = @Permohonan_ID;
                                        DELETE FROM LESEN_UlasanFail WHERE UlasanFail_PermohonanID = @Permohonan_ID;"
                                SelectCommand="SELECT ROW_NUMBER() OVER(ORDER BY a.TarikhMohon desc) as RowNo, a.*, c.Pemohon_Name, 
                                        ISNULL(a.AlamatBaru,ISNULL(a.AlamatPremis,ISNULL(a.AlamatPenjajaan,ISNULL(a.AnjingAlamat,isnull(a.LokasiPasar1,ISNULL(a.LokasiPasar2,ISNULL(a.LokasiPasar3,''))))))) as DisplayAlamat, 
                                        d.Description AS Description, 
                                        CASE WHEN a.IsBatal = 0 then a.Is24Jam 
                                        WHEN a.IsBatal = 1 then 1 END 
										AS IsNotRisk  
                                        FROM LESEN_Permohonan a 
                                        INNER JOIN LESEN_Pemohon c ON a.Permohonan_PemohonID = c.Pemohon_ID 
                                        LEFT JOIN ApprovalStatus d ON a.StatusID = d.ApprStatusID
                                        WHERE 1=1 AND a.JenisLesenIdList is not null AND a.IsRekodLama = 1  
                                        AND (@selectedLesen IS NULL OR @selectedLesen = '' OR @selectedLesen = '0' OR @selectedLesen = '%%'
                                            OR EXISTS (
                                                SELECT 1 FROM LESEN_JenisLesen jl 
                                                WHERE jl.JenisLesen_IsActive = 1 
                                                  AND CHARINDEX('|' + jl.JenisLesen_Description + '|', '|' + @selectedLesen + '|') > 0 
                                                  AND ISNULL(a.JenisLesenDescList,'') LIKE '%' + jl.JenisLesen_Description + '%'
                                            ))
                                        AND a.Permohonan_PemohonID = CASE WHEN @pemohonID = 0 THEN a.Permohonan_PemohonID ELSE @pemohonID END 
                                        AND (@namaSyarikat IS NULL OR @namaSyarikat = '' OR @namaSyarikat = '%%' OR ISNULL(a.NamaSyarikat,'') LIKE '%'+@namaSyarikat+'%' OR ISNULL(a.NamaBaruSyarikat,'') LIKE '%'+@namaSyarikat+'%')
                                        AND a.IsBatal = CASE WHEN @batalID = 2 THEN a.IsBatal ELSE @batalID END 
                                        AND a.Is24Jam = CASE WHEN @risikoID = 2 THEN a.Is24Jam ELSE @risikoID END 
                                        AND a.CreatorID = CASE WHEN @creatorID = '0' THEN a.CreatorID ELSE @creatorID END 
                                        AND (ISNULL(a.AlamatPremis,'') LIKE CASE WHEN @Alamat='' THEN ISNULL(a.AlamatPremis,'') ELSE '%'+@Alamat+'%' END
                                        OR ISNULL(a.AlamatBaru,'') LIKE CASE WHEN @Alamat='' THEN ISNULL(a.AlamatBaru,'') ELSE '%'+@Alamat+'%' END
                                        OR ISNULL(a.AnjingAlamat,'') LIKE CASE WHEN @Alamat='' THEN ISNULL(a.AnjingAlamat,'') ELSE '%'+@Alamat+'%' END
                                        OR ISNULL(a.AlamatPenjajaan,'') LIKE CASE WHEN @Alamat='' THEN ISNULL(a.AlamatPenjajaan,'') ELSE '%'+@Alamat+'%' END
                                        OR ISNULL(a.LokasiPasar1,'') LIKE CASE WHEN @Alamat='' THEN ISNULL(a.LokasiPasar1,'') ELSE '%'+@Alamat+'%' END
                                        OR ISNULL(a.LokasiPasar2,'') LIKE CASE WHEN @Alamat='' THEN ISNULL(a.LokasiPasar2,'') ELSE '%'+@Alamat+'%' END
                                        OR ISNULL(a.LokasiPasar2,'') LIKE CASE WHEN @Alamat='' THEN ISNULL(a.LokasiPasar3,'') ELSE '%'+@Alamat+'%' END) 
                                        /*AND a.AlamatBaru LIKE CASE WHEN @Alamat='' THEN a.AlamatBaru ELSE '%'+@Alamat+'%' END */
                                        /*AND a.AnjingAlamat LIKE CASE WHEN @Alamat='%%' THEN a.AnjingAlamat ELSE '%'+@Alamat+'%' END*/ 
                                        AND a.TarikhMohon LIKE '%'+@TarikhMohon+'%' 
                                        AND a.Rujukan LIKE '%'+@Rujukan+'%' 
                                        AND (@PemohonIC = '' OR @PemohonIC = '%%' OR ISNULL(c.Pemohon_ICNo,'') LIKE '%'+@PemohonIC+'%' OR ISNULL(c.Pemohon_PassportNo,'') LIKE '%'+@PemohonIC+'%') 
                                        AND (@PemohonTel = '' OR @PemohonTel = '%%' OR ISNULL(c.Pemohon_MobileNo,'') LIKE '%'+@PemohonTel+'%' OR ISNULL(c.Pemohon_TelNo,'') LIKE '%'+@PemohonTel+'%') 
                                        AND (@PemohonEmail = '' OR @PemohonEmail = '%%' OR ISNULL(c.Pemohon_Email,'') LIKE '%'+@PemohonEmail+'%') 
                                        AND (@NoPendaftaran = '' OR @NoPendaftaran = '%%' OR ISNULL(a.NoPendaftaran,'') LIKE '%'+@NoPendaftaran+'%') 
                                        AND (@JenisPerniagaan = '' OR @JenisPerniagaan = '%%' OR ISNULL(a.JenisPerniagaan,'') LIKE '%'+@JenisPerniagaan+'%' OR ISNULL(a.JenisPerniagaanBaru,'') LIKE '%'+@JenisPerniagaan+'%') 
                                        AND (@NoAkaun = '' OR @NoAkaun = '%%' OR ISNULL(a.NoAkaun,'') LIKE '%'+@NoAkaun+'%' OR ISNULL(a.NoAkaunCukai,'') LIKE '%'+@NoAkaun+'%') 
                                        AND (@RemarksFail = '' OR @RemarksFail = '%%' OR ISNULL(a.RemarksFail,'') LIKE '%'+@RemarksFail+'%') 
                                        order by a.TarikhMohon desc">
                                <DeleteParameters>
                                    <asp:Parameter Name="Permohonan_ID"></asp:Parameter>
                                </DeleteParameters>
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="txtNoRujukan" PropertyName="Text" DefaultValue="%%" Name="Rujukan"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="hfSelectedJenisLesen" PropertyName="Value" Name="selectedLesen" DefaultValue="" ConvertEmptyStringToNull="false"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="DDL_Pemohon" PropertyName="SelectedValue" Name="pemohonID"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="txtFilterSyarikat" PropertyName="Text" DefaultValue="%%" Name="namaSyarikat"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="DDL_Pembatalan" PropertyName="SelectedValue" Name="batalID"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="DDL_Risiko" PropertyName="SelectedValue" Name="risikoID"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="DDL_CreatedBy" PropertyName="SelectedValue" Name="creatorID"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="TB_TarikhMohon" PropertyName="Text" DefaultValue="%%" Name="TarikhMohon"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="TB_Alamat" PropertyName="Text" DefaultValue="%%" Name="Alamat"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="txtFilterPemohonIC" PropertyName="Text" DefaultValue="%%" Name="PemohonIC"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="txtFilterPemohonTel" PropertyName="Text" DefaultValue="%%" Name="PemohonTel"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="txtFilterPemohonEmail" PropertyName="Text" DefaultValue="%%" Name="PemohonEmail"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="txtFilterNoPendaftaran" PropertyName="Text" DefaultValue="%%" Name="NoPendaftaran"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="txtFilterJenisPerniagaan" PropertyName="Text" DefaultValue="%%" Name="JenisPerniagaan"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="txtFilterNoAkaun" PropertyName="Text" DefaultValue="%%" Name="NoAkaun"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="txtFilterRemarksFail" PropertyName="Text" DefaultValue="%%" Name="RemarksFail"></asp:ControlParameter>
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </div>
                    </div>
                </div>
            </div>
            <!-- ======================================================================= -->
            <!-- SECTION: TAB CONTAINER (LAMPIRAN, MESYUARAT, KADAR BAYARAN)             -->
            <!-- ======================================================================= -->
            <asp:TabContainer ID="TabContainer1" runat="server" ActiveTabIndex="0" Visible="false" CssClass="MyTabStyle">

                <%-- ------------------------------------------------------------------- --%>
                <%-- TAB 1: LAMPIRAN AWAM                                                --%>
                <%-- ------------------------------------------------------------------- --%>
                <asp:TabPanel runat="server" ID="tabPublicAttach" HeaderText="Lampiran Awam">
                    <HeaderTemplate>Lampiran Awam</HeaderTemplate>
                    <ContentTemplate>
                        <div class="table-responsive">
                            <asp:GridView ID="gvTabPublicAttach" runat="server" ShowHeaderWhenEmpty="True"
                                AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="PermohonanFail_ID"
                                DataSourceID="SqlDataSourceTabPublicAttach"
                                CssClass="table table-hover table-bordered custom-gridview align-middle" Width="100%">
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
                                            <div class="d-flex flex-wrap gap-1 align-items-center justify-content-center">
                                                <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="True" CommandName="Update" Text="Simpan" CssClass="btn btn-warning btn-sm">
                                                    <i class="bi bi-save me-1"></i>Simpan
                                                </asp:LinkButton>
                                                <asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="Cancel" Text="Batal" CssClass="btn btn-secondary btn-sm">
                                                    <i class="bi bi-x-circle me-1"></i>Batal
                                                </asp:LinkButton>
                                            </div>
                                        </EditItemTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lbEdit" runat="server" CausesValidation="False" CommandName="Edit" Text="Kemaskini" Visible='<%# If(CInt(Session.Item("sessionEstateID")) = 1, True, False) %>' CssClass="btn btn-warning btn-sm">
                                                <i class="bi bi-pencil-square me-1"></i>Kemaskini
                                            </asp:LinkButton>
                                        </ItemTemplate>
                                        <HeaderStyle Width="10%" />
                                        <ItemStyle HorizontalAlign="Center" />
                                    </asp:TemplateField>

                                    <asp:TemplateField>
                                        <HeaderTemplate>
                                            <asp:LinkButton ID="btnAddNew" runat="server" CssClass="btn btn-warning btn-sm" ToolTip="Tambah" Visible='<%# If(CInt(Session.Item("sessionEstateID")) = 1, True, False) %>' OnClick="btnAddNewUpload1_Click">
                                                <i class="bi bi-plus-lg me-1"></i>Tambah
                                            </asp:LinkButton>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lbDelete" runat="server" CausesValidation="False" CommandName="Delete" Text="Padam" OnClientClick="return confirm('Anda pasti untuk padam rekod ini?');" Visible='<%# If(CInt(Session.Item("sessionEstateID")) = 1, True, False) %>' CssClass="btn btn-danger btn-sm">
                                                <i class="bi bi-trash me-1"></i>Padam
                                            </asp:LinkButton>
                                        </ItemTemplate>
                                        <FooterStyle HorizontalAlign="Center" />
                                        <HeaderStyle Width="5%" HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" />
                                    </asp:TemplateField>

                                </Columns>

                                <PagerStyle CssClass="pgr" />
                            </asp:GridView>
                        </div>

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

                <%-- ------------------------------------------------------------------- --%>
                <%-- TAB 2: LAMPIRAN MPK (ULASAN)                                        --%>
                <%-- ------------------------------------------------------------------- --%>
                <asp:TabPanel runat="server" ID="tabUlasan" HeaderText="Ulasan">
                    <HeaderTemplate>Lampiran MPK</HeaderTemplate>
                    <ContentTemplate>
                        <div class="table-responsive">
                            <asp:GridView ID="gvTabUlasan" runat="server" ShowHeaderWhenEmpty="True"
                                AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="PermohonanFail_ID"
                                DataSourceID="SqlDataSourceTabUlasan"
                                CssClass="table table-hover table-bordered custom-gridview align-middle" Width="100%">
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
                                            <div class="d-flex flex-wrap gap-1 align-items-center justify-content-center">
                                                <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="True" CommandName="Update" Text="Simpan" CssClass="btn btn-warning btn-sm">
                                                    <i class="bi bi-save me-1"></i>Simpan
                                                </asp:LinkButton>
                                                <asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="Cancel" Text="Batal" CssClass="btn btn-secondary btn-sm">
                                                    <i class="bi bi-x-circle me-1"></i>Batal
                                                </asp:LinkButton>
                                            </div>
                                        </EditItemTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lbEdit" runat="server" CausesValidation="False" CommandName="Edit" Text="Kemaskini" Visible='<%# If(CInt(Session.Item("sessionEstateID")) = 1, True, False) %>' CssClass="btn btn-warning btn-sm">
                                                <i class="bi bi-pencil-square me-1"></i>Kemaskini
                                            </asp:LinkButton>
                                        </ItemTemplate>
                                        <HeaderStyle Width="10%" />
                                        <ItemStyle HorizontalAlign="Center" />
                                    </asp:TemplateField>

                                    <asp:TemplateField>
                                        <HeaderTemplate>
                                            <asp:LinkButton ID="btnAddNew" runat="server" CssClass="btn btn-warning btn-sm" ToolTip="Tambah" Visible='<%# If(CInt(Session.Item("sessionEstateID")) = 1, True, False) %>' OnClick="btnAddNewUpload_Click">
                                                <i class="bi bi-plus-lg me-1"></i>Tambah
                                            </asp:LinkButton>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lbDelete" runat="server" CausesValidation="False" CommandName="Delete" Text="Padam" OnClientClick="return confirm('Anda pasti untuk padam rekod ini?');" Visible='<%# If(CInt(Session.Item("sessionEstateID")) = 1, True, False) %>' CssClass="btn btn-danger btn-sm">
                                                <i class="bi bi-trash me-1"></i>Padam
                                            </asp:LinkButton>
                                        </ItemTemplate>
                                        <FooterStyle HorizontalAlign="Center" />
                                        <HeaderStyle Width="5%" HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" />
                                    </asp:TemplateField>

                                </Columns>

                                <PagerStyle CssClass="pgr" />
                            </asp:GridView>
                        </div>

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

                <%-- ------------------------------------------------------------------- --%>
                <%-- TAB 3: MAKLUMAT MESYUARAT & KEWANGAN                                --%>
                <%-- ------------------------------------------------------------------- --%>
                <asp:TabPanel runat="server" ID="tabMesyuarat" HeaderText="Mesyuarat">
                    <HeaderTemplate>Mesyuarat</HeaderTemplate>
                    <ContentTemplate>
                        <div class="form-section-header">
                            <i class="bi bi-calendar-event"></i>
                            <span>Maklumat Mesyuarat</span>
                        </div>

                        <div class="row">
                            <div class="col-md-4 col-lg-3">
                                <div class="form-group">
                                    <label class="form-label-custom">Tarikh Mesyuarat</label>
                                    <asp:TextBox ID="TB_TarikhMesyuarat" runat="server" TextMode="Date" CssClass="form-control" />
                                </div>
                            </div>

                            <div class="col-md-4 col-lg-3">
                                <div class="form-group">
                                    <label class="form-label-custom">No Mesyuarat</label>
                                    <asp:TextBox ID="TB_NoMesyuarat" runat="server" CssClass="form-control" />
                                </div>
                            </div>
                        </div>

                        <div class="row mt-2">
                            <div class="col-md-6 col-lg-4">
                                <div class="form-group">
                                    <label class="form-label-custom">Tindakan Kewangan</label>
                                    <div class="checkbox-box">
                                        <asp:CheckBox ID="CB_IsPulang" runat="server" OnCheckedChanged="CB_IsPulang_CheckedChanged" AutoPostBack="true" CausesValidation="false" Text=" Hantar ke kewangan?" />
                                    </div>
                                </div>
                            </div>
                        </div>

                        <asp:Panel runat="server" ID="pnlpulang" Visible="false">
                            <div class="row">
                                <div class="col-md-4 col-lg-3">
                                    <div class="form-group">
                                        <label class="form-label-custom">Tarikh hantar ke kewangan</label>
                                        <asp:TextBox ID="TB_TarikhPulang" runat="server" TextMode="Date" CssClass="form-control" />
                                    </div>
                                </div>
                            </div>
                        </asp:Panel>

                        <div class="row mt-3 mb-2">
                            <div class="col-12">
                                <asp:LinkButton ID="BtnSaveMesyuarat" runat="server" CausesValidation="False" Text="Kemaskini" CssClass="btn btn-warning px-4 fw-semibold shadow-sm" OnClick="BtnSaveMesyuarat_Click">
                                    <i class="bi bi-check-circle me-1"></i>Kemaskini
                                </asp:LinkButton>
                            </div>
                        </div>
                    </ContentTemplate>
                </asp:TabPanel>

                <%-- ------------------------------------------------------------------- --%>
                <%-- TAB 4: KADAR BAYARAN                                                --%>
                <%-- ------------------------------------------------------------------- --%>
                <asp:TabPanel runat="server" ID="tabKadarBayaran" HeaderText="Kadar Bayaran">
                    <HeaderTemplate>Kadar Bayaran</HeaderTemplate>
                    <ContentTemplate>
                        <div class="table-responsive">
                            <asp:GridView ID="gvTabBayaran" runat="server" ShowHeaderWhenEmpty="true"
                                AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="KadarBayaran_ID"
                                DataSourceID="SqlDataSourceTabBayaran"
                                CssClass="table table-hover table-bordered custom-gridview align-middle" Width="100%">
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
                                            <span class="text-secondary small fw-semibold">Jabatan/Agensi: </span>
                                            <asp:Label ID="lblJabatanAgensi_Description" runat="server" CssClass="small" Text='<%# Eval("JabatanAgensi_Description") %>'></asp:Label>
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
                                            <asp:Label ID="lblKadarBayaran_Amount" runat="server" CssClass="fw-bold" Text='<%# Eval("KadarBayaran_Amount", "{0:N2}") %>'></asp:Label>
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
                                            <asp:CheckBox ID="cbsel" runat="server" Enabled='<%# If(Eval("IsPublish") = False, True, False) %>' Checked='<%# Eval("IsSelect") %>' OnCheckedChanged="cbsel_CheckedChanged" AutoPostBack="true" CausesValidation="false" />
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField ShowHeader="False">
                                        <EditItemTemplate>
                                            <div class="d-flex flex-wrap gap-1 align-items-center justify-content-center">
                                                <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="True" CommandName="Update" Text="Simpan" CssClass="btn btn-warning btn-sm">
                                                    <i class="bi bi-save me-1"></i>Simpan
                                                </asp:LinkButton>
                                                <asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" CssClass="btn btn-secondary btn-sm">
                                                    <i class="bi bi-x-circle me-1"></i>Batal
                                                </asp:LinkButton>
                                            </div>
                                        </EditItemTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lbEdit" runat="server" CausesValidation="False" CommandName="Edit" Text="Kemaskini"
                                                Visible='<%# If(IsDBNull(Eval("KadarBayaran_PermohonanAgensiID")), True, If(Eval("KadarBayaran_PermohonanAgensiID") = Session.Item("sessionEstateId"), True, False)) %>' CssClass="btn btn-warning btn-sm">
                                                <i class="bi bi-pencil-square me-1"></i>Kemaskini
                                            </asp:LinkButton>
                                        </ItemTemplate>
                                        <HeaderStyle Width="10%" />
                                        <ItemStyle HorizontalAlign="Center" />
                                    </asp:TemplateField>

                                    <asp:TemplateField>
                                        <HeaderTemplate>
                                            <asp:LinkButton ID="btnAddNew" runat="server" CssClass="btn btn-warning btn-sm" ToolTip="Tambah" OnClick="btnAddNew_Click">
                                                <i class="bi bi-plus-lg me-1"></i>Tambah
                                            </asp:LinkButton>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lbDelete" runat="server" CausesValidation="False" CssClass="btn btn-danger btn-sm"
                                                Visible='<%# If(IsDBNull(Eval("KadarBayaran_PermohonanAgensiID")), True, If(Eval("KadarBayaran_PermohonanAgensiID") = Session.Item("sessionEstateId"), True, False)) %>' CommandName="Delete" Text="Padam" OnClientClick="return confirm('Anda pasti untuk padam rekod ini?');">
                                                <i class="bi bi-trash me-1"></i>Padam
                                            </asp:LinkButton>
                                        </ItemTemplate>
                                        <FooterStyle HorizontalAlign="Center" />
                                        <HeaderStyle Width="5%" HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" />
                                    </asp:TemplateField>

                                </Columns>

                                <PagerStyle CssClass="pgr" />
                            </asp:GridView>
                        </div>

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

            </asp:TabContainer>

        </div>
    </section>
    <asp:Button ID="ui_btnPageBottom" runat="server" Text="-" Style="margin-left: -999px;" />

    <!-- ======================================================================= -->
    <!-- CLIENT-SIDE SCRIPTS                                                     -->
    <!-- ======================================================================= -->
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

        function initTarikhSebabBatal() {
            function isTargetSebab(val, text) {
                val = (val || '').toString().trim();
                text = (text || '').toString().trim().toLowerCase();
                return (val === '30700' || val === '30701' || val === '30702' ||
                        text === 'notis' || text === 'tindakan polis' || text === 'ulasan teknikal');
            }

            function checkVisibility(animate) {
                var $pnl = $('[id$="pnlbatalTarikh"]');
                if (!$pnl.length) return;

                var $ddl2 = $('select[id$="DDL_SebabBatal2"]');
                var $ddl1 = $('select[id$="DDL_SebabBatal1"]');

                var val = '';
                var text = '';

                if ($ddl2.length && $ddl2.closest('[id$="pnlbatal4"]').is(':visible')) {
                    val = $ddl2.val();
                    text = $ddl2.find('option:selected').text();
                } else if ($ddl1.length && $ddl1.closest('[id$="pnlbatal3"]').is(':visible')) {
                    val = $ddl1.val();
                    text = $ddl1.find('option:selected').text();
                } else if ($ddl2.length && $ddl2.val()) {
                    val = $ddl2.val();
                    text = $ddl2.find('option:selected').text();
                }

                if (isTargetSebab(val, text)) {
                    if (animate) {
                        $pnl.slideDown(200);
                    } else {
                        $pnl.show();
                    }
                } else {
                    if (animate) {
                        $pnl.slideUp(200);
                    } else {
                        $pnl.hide();
                    }
                }
            }

            $(document).off('change.tarikhBatal select2:select.tarikhBatal select2:clear.tarikhBatal', 'select[id$="DDL_SebabBatal2"], select[id$="DDL_SebabBatal1"]')
                       .on('change.tarikhBatal select2:select.tarikhBatal select2:clear.tarikhBatal', 'select[id$="DDL_SebabBatal2"], select[id$="DDL_SebabBatal1"]', function () {
                           checkVisibility(true);
                       });

            $(document).off('change.tarikhBatalJenis select2:select.tarikhBatalJenis', 'select[id$="DDL_JenisBatal"]')
                       .on('change.tarikhBatalJenis select2:select.tarikhBatalJenis', 'select[id$="DDL_JenisBatal"]', function () {
                           checkVisibility(false);
                       });

            checkVisibility(false);
        }

        function initBakaLain() {
            function checkBaka($ddl) {
                if (!$ddl || !$ddl.length) return;
                var text = ($ddl.find('option:selected').text() || '').trim().toUpperCase();
                var $pnl = $ddl.closest('.form-group').find('.pnl-baka-lain');
                if (text === 'LAIN-LAIN') {
                    $pnl.slideDown(150);
                } else {
                    $pnl.hide();
                }
            }

            $('select[id$="DDL_BakaAnjing1"]').each(function () {
                var $ddl = $(this);
                checkBaka($ddl);

                $ddl.off('change.bakaLain select2:select.bakaLain select2:clear.bakaLain')
                    .on('change.bakaLain select2:select.bakaLain select2:clear.bakaLain', function () {
                        checkBaka($(this));
                    });
            });

            $(document).off('keypress.bakaLain', 'input[id*="TB_BakaLain1"]')
                       .on('keypress.bakaLain', 'input[id*="TB_BakaLain1"]', function (e) {
                           if (e.ctrlKey || e.altKey || e.metaKey || (e.key && e.key.length > 1)) {
                               return true;
                           }
                           var char = e.key || String.fromCharCode(e.which || e.keyCode);
                           if (!/^[a-zA-Z\s]$/.test(char)) {
                               e.preventDefault();
                               return false;
                           }
                       });

            $(document).off('input.bakaLain paste.bakaLain', 'input[id*="TB_BakaLain1"]')
                       .on('input.bakaLain paste.bakaLain', 'input[id*="TB_BakaLain1"]', function () {
                           var $el = $(this);
                           setTimeout(function () {
                               var clean = $el.val().replace(/[^a-zA-Z\s]/g, '');
                               if ($el.val() !== clean) {
                                   $el.val(clean);
                               }
                           }, 0);
                       });
        }

        $(document).ready(function () {
            initTarikhSebabBatal();
            initBakaLain();
            setupValidationGuards();
            resetAndHideUnsubmittedValidators();
            initFilterCollapse();
        });

        function pageLoad() {
            initTarikhSebabBatal();
            initBakaLain();
            setupValidationGuards();
            resetAndHideUnsubmittedValidators();
            initFilterCollapse();

            // Adjust tab container dimensions if rendered
            $("#ctl00_ContentPlaceHolder1_LabelAttributes1_TabContainer1").css({ 'width': 400, 'height': 400 });

            $(function () {
                // Datepicker initialization
                $('.datepicker').datepicker({
                    dateFormat: 'dd/mm/yy',
                    defaultDate: new Date()
                });

                // Initialize Select2 Elements with strict width
                // "select.select2" sahaja: span .select2-container yang dicipta oleh select2
                // juga ada kelas "select2"; kalau di-init semula ia dapat select2-hidden-accessible
                // (tinggi 1px, clip) dan dropdown nampak kosong
                $('select.select2').each(function () {
                    var $el = $(this);
                    var ph = $el.attr('data-placeholder') || undefined;
                    var isMultiple = $el.prop('multiple');
                    $el.select2({
                        width: '100%',
                        dropdownAutoWidth: false,
                        placeholder: ph,
                        closeOnSelect: !isMultiple
                    });
                });
                $('.select2bs4').each(function () {
                    $(this).select2({
                        theme: 'bootstrap4',
                        width: '100%',
                        dropdownAutoWidth: false
                    });
                });

                // Input mask initialization
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

        /* =========================================================================
           Collapsible Extra Filters (panelFilter)
           ========================================================================= */
        function initFilterCollapse() {
            var $collapse = $('#collapseFilterExtra');
            if (!$collapse.length) return;

            var $hf = $('[id$="hfFilterExpanded"]');

            var $topBtn = $('#btnToggleFilterExtra');
            var $bottomBtn = $('#btnToggleFilterBottom');
            var $topText = $('#btnToggleFilterExtraText');
            var $bottomText = $('#btnToggleFilterBottomText');
            var $topIcon = $('#iconFilterCollapse');
            var $bottomIcon = $('#iconFilterCollapseBottom');
            var $badge = $('#badgeActiveExtraCount');
            var $badgeBottom = $('#badgeActiveExtraCountBottom');
            var $badgePemohon = $('#badgePemohonActive');
            var $badgePermohonan = $('#badgePermohonanActive');

            function refreshSelect2In($container) {
                if (!$container || !$container.length) return;
                $container.find('select.select2').each(function () {
                    var $s = $(this);
                    var ph = $s.attr('data-placeholder') || undefined;
                    var isMultiple = $s.prop('multiple');
                    if ($s.data('select2')) {
                        $s.next('.select2-container').css('width', '100%');
                        // render semula supaya lebar placeholder (multi-select) dikira semasa panel kelihatan
                        $s.trigger('change.select2');
                    } else {
                        $s.select2({
                            width: '100%',
                            dropdownAutoWidth: false,
                            placeholder: ph,
                            closeOnSelect: !isMultiple
                        });
                    }
                });
            }

            // Sync multi-select Jenis Lesen
            var $lstJenis = $('[id$="lstJenisLesen"]');
            var $hfJenis = $('[id$="hfSelectedJenisLesen"]');

            if ($lstJenis.length && $hfJenis.length) {
                var savedLesen = $hfJenis.val();
                if (savedLesen && savedLesen.trim() !== '' && savedLesen !== '0') {
                    var selectedArr = savedLesen.split('|');
                    $lstJenis.val(selectedArr).trigger('change.select2');
                }

                $lstJenis.off('change.syncJenis').on('change.syncJenis', function () {
                    var vals = $(this).val();
                    var valStr = (vals && vals.length) ? vals.join('|') : '';
                    $hfJenis.val(valStr);
                    updateBadges();
                });
            }

            $('[id$="btnSearch"]').off('click.syncJenis').on('click.syncJenis', function () {
                if ($lstJenis.length && $hfJenis.length) {
                    var vals = $lstJenis.val();
                    var valStr = (vals && vals.length) ? vals.join('|') : '';
                    $hfJenis.val(valStr);
                }
            });

            // Value Checkers
            function isPemohonActive() {
                var $d = $('[id$="DDL_Pemohon"]');
                return $d.length && $d.val() && $d.val() !== '0' && $d.val() !== '';
            }
            function isPemohonICActive() {
                var $t = $('[id$="txtFilterPemohonIC"]');
                return $t.length && $t.val() && $t.val().trim() !== '';
            }
            function isPemohonTelActive() {
                var $t = $('[id$="txtFilterPemohonTel"]');
                return $t.length && $t.val() && $t.val().trim() !== '';
            }
            function isPemohonEmailActive() {
                var $t = $('[id$="txtFilterPemohonEmail"]');
                return $t.length && $t.val() && $t.val().trim() !== '';
            }
            function isSyarikatActive() {
                var $t = $('[id$="txtFilterSyarikat"]');
                return $t.length && $t.val() && $t.val().trim() !== '';
            }
            function isNoPendaftaranActive() {
                var $t = $('[id$="txtFilterNoPendaftaran"]');
                return $t.length && $t.val() && $t.val().trim() !== '';
            }

            function isJenisLesenActive() {
                var $hf = $('[id$="hfSelectedJenisLesen"]');
                if ($hf.length && $hf.val() && $hf.val().trim() !== '' && $hf.val() !== '0') return true;
                var $l = $('[id$="lstJenisLesen"]');
                return $l.length && $l.val() && $l.val().length > 0;
            }
            function isAlamatActive() {
                var $t = $('[id$="TB_Alamat"]');
                return $t.length && $t.val() && $t.val().trim() !== '';
            }
            function isPerniagaanActive() {
                var $t = $('[id$="txtFilterJenisPerniagaan"]');
                return $t.length && $t.val() && $t.val().trim() !== '';
            }
            function isAkaunActive() {
                var $t = $('[id$="txtFilterNoAkaun"]');
                return $t.length && $t.val() && $t.val().trim() !== '';
            }
            function isRisikoActive() {
                var $d = $('[id$="DDL_Risiko"]');
                return $d.length && $d.val() && $d.val() !== '2' && $d.val() !== '';
            }
            function isPembatalanActive() {
                var $d = $('[id$="DDL_Pembatalan"]');
                return $d.length && $d.val() && $d.val() !== '2' && $d.val() !== '';
            }
            function isRemarksActive() {
                var $t = $('[id$="txtFilterRemarksFail"]');
                return $t.length && $t.val() && $t.val().trim() !== '';
            }

            function countActivePemohonFilters() {
                var c = 0;
                if (isPemohonActive()) c++;
                if (isPemohonICActive()) c++;
                if (isPemohonTelActive()) c++;
                if (isPemohonEmailActive()) c++;
                if (isSyarikatActive()) c++;
                if (isNoPendaftaranActive()) c++;
                return c;
            }

            function countActivePermohonanFilters() {
                var c = 0;
                if (isJenisLesenActive()) c++;
                if (isAlamatActive()) c++;
                if (isPerniagaanActive()) c++;
                if (isAkaunActive()) c++;
                if (isRisikoActive()) c++;
                if (isPembatalanActive()) c++;
                if (isRemarksActive()) c++;
                return c;
            }

            function countActiveExtraFilters() {
                return countActivePemohonFilters() + countActivePermohonanFilters();
            }

            function updateBadges() {
                var pemohonCount = countActivePemohonFilters();
                var permohonanCount = countActivePermohonanFilters();
                var totalCount = pemohonCount + permohonanCount;

                if ($badgePemohon.length) {
                    if (pemohonCount > 0) $badgePemohon.text(pemohonCount + ' aktif').removeClass('d-none');
                    else $badgePemohon.addClass('d-none');
                }
                if ($badgePermohonan.length) {
                    if (permohonanCount > 0) $badgePermohonan.text(permohonanCount + ' aktif').removeClass('d-none');
                    else $badgePermohonan.addClass('d-none');
                }
                if ($badge.length) {
                    if (totalCount > 0) $badge.text(totalCount + ' aktif').removeClass('d-none');
                    else $badge.addClass('d-none');
                }
                if ($badgeBottom.length) {
                    if (totalCount > 0) $badgeBottom.text(totalCount + ' aktif').removeClass('d-none');
                    else $badgeBottom.addClass('d-none');
                }
            }

            function updateUiState(isOpen) {
                if ($hf.length) $hf.val(isOpen ? '1' : '0');

                var text = isOpen ? 'Kurang Penapis' : 'Penapis Tambahan';
                if ($topText.length) $topText.text(text);
                if ($bottomText.length) $bottomText.text(text);

                var rotate = isOpen ? 'rotate(180deg)' : 'rotate(0deg)';
                if ($topIcon.length) $topIcon.css('transform', rotate);
                if ($bottomIcon.length) $bottomIcon.css('transform', rotate);

                $topBtn.attr('aria-expanded', isOpen ? 'true' : 'false');
                $bottomBtn.attr('aria-expanded', isOpen ? 'true' : 'false');

                updateBadges();
            }

            // Determine if collapse should be open
            var activeCount = countActiveExtraFilters();
            var shouldOpen = ($hf.length && $hf.val() === '1') || (activeCount > 0);

            if (shouldOpen) {
                $collapse.addClass('show');
                updateUiState(true);
            } else {
                $collapse.removeClass('show');
                updateUiState(false);
            }

            // Collapse events
            $collapse.off('show.bs.collapse shown.bs.collapse hide.bs.collapse hidden.bs.collapse');
            $collapse.on('show.bs.collapse', function () {
                updateUiState(true);
            });
            $collapse.on('shown.bs.collapse', function () {
                $(window).trigger('resize');
                refreshSelect2In($collapse);
            });
            $collapse.on('hide.bs.collapse', function () {
                updateUiState(false);
            });

            // Recompute badge on filter change
            $('#collapseFilterExtra').off('change.filterBadge input.filterBadge', 'select, input');
            $('#collapseFilterExtra').on('change.filterBadge input.filterBadge', 'select, input', function () {
                updateBadges();
            });

            // Quick reset for extra filters only
            $('#btnResetExtraOnly').off('click').on('click', function (e) {
                e.preventDefault();
                var $dPemohon = $('[id$="DDL_Pemohon"]');
                var $dRisiko = $('[id$="DDL_Risiko"]');
                var $dPembatalan = $('[id$="DDL_Pembatalan"]');
                var $lstLesen = $('[id$="lstJenisLesen"]');
                var $hfLesen = $('[id$="hfSelectedJenisLesen"]');

                if ($dPemohon.length) $dPemohon.val('0').trigger('change.select2');
                if ($dRisiko.length) $dRisiko.val('2').trigger('change.select2');
                if ($dPembatalan.length) $dPembatalan.val('2').trigger('change.select2');
                if ($lstLesen.length) $lstLesen.val(null).trigger('change.select2');
                if ($hfLesen.length) $hfLesen.val('');

                $('[id$="txtFilterSyarikat"]').val('');
                $('[id$="txtFilterPemohonIC"]').val('');
                $('[id$="txtFilterPemohonTel"]').val('');
                $('[id$="txtFilterPemohonEmail"]').val('');
                $('[id$="txtFilterNoPendaftaran"]').val('');
                $('[id$="TB_Alamat"]').val('');
                $('[id$="txtFilterJenisPerniagaan"]').val('');
                $('[id$="txtFilterNoAkaun"]').val('');
                $('[id$="txtFilterRemarksFail"]').val('');

                updateBadges();
            });

            updateBadges();
            refreshSelect2In($collapse);
        }
    </script>

</asp:Content>
