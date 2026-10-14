<%@ Page MaintainScrollPositionOnPostback="true" Title="" Language="VB" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="semakpembatalan1.aspx.vb" Inherits="semakpembatalan1" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadContent" runat="Server">
    <style>
        .paraGraphtext {
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            width: 150px;
        }

        .csslblUlasan {
            font-weight: normal !important;
        }

        /* AjaxControlToolkit TabContainer Styling */
        .ajax__tab_xp .ajax__tab_header {
            background-image: url('') !important;
            font-size: 11pt !important;
            height: 40px !important;
            color: #000 !important;
        }

        .ajax__tab_xp .ajax__tab_outer,
        .ajax__tab_xp .ajax__tab_inner,
        .ajax__tab_xp .ajax__tab_tab {
            background-image: url('') !important;
        }

        .ajax__tab_xp .ajax__tab_header .ajax__tab_active .ajax__tab_inner {
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
        }

        .ajax__tab_xp .ajax__tab_header .ajax__tab_inner {
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

        .highlighted {
            background-color: #f8d7d7;
        }

        /* =========================================================================
           Design System & UI Look and Feel from appregister1.aspx
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
            margin-top: 1.25rem;
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

        /* Tag pill styling */
        .tag-container {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            margin-top: 4px;
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

        /* Checkbox Box Card */
        .checkbox-box {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 7px 12px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
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
            color: #374151;
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
            padding: 20px 24px;
        }
        .card-footer {
            background-color: #f8fafc;
            border-top: 1px solid #e2e8f0;
            padding: 14px 24px;
        }

        /* GridView Modern Styling */
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
        .custom-gridview .btn-sm {
            font-size: 0.78rem !important;
            padding: 4px 9px !important;
            border-radius: 6px !important;
            font-weight: 500 !important;
            display: inline-flex !important;
            align-items: center !important;
            justify-content: center !important;
            line-height: 1.4 !important;
            transition: all 0.15s ease-in-out !important;
        }
        .custom-gridview .btn-sm:hover {
            transform: translateY(-1px);
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

        /* Modal Details View Styling */
        #modalMaklumatPermohonan .modal-dialog {
            width: 92vw !important;
            max-width: 92vw !important;
        }
        @media (min-width: 1400px) {
            #modalMaklumatPermohonan .modal-dialog {
                width: 90vw !important;
                max-width: 90vw !important;
            }
        }

        .modal-details-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            padding: 18px 20px;
            margin-bottom: 18px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.03);
        }
        .modal-field-group {
            margin-bottom: 0.85rem;
        }
        .modal-field-label {
            display: block;
            font-size: 0.8rem;
            font-weight: 600;
            color: #475569;
            margin-bottom: 0.25rem;
        }
        .modal-field-value {
            display: block;
            width: 100%;
            min-height: 38px;
            padding: 7px 12px;
            font-size: 0.86rem;
            color: #1e293b;
            background-color: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            box-sizing: border-box;
        }
        .modal-field-value-multiline {
            min-height: 70px;
            white-space: pre-wrap;
            word-break: break-word;
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">

    <%-- ========================================================================= --%>
    <%-- SECTION 1: PAGE HEADER & BREADCRUMB                                       --%>
    <%-- ========================================================================= --%>
    <section class="content-header">
        <div class="container-fluid">
            <asp:Label ID="lblDummy" runat="server" Text=""></asp:Label>
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

            <%-- ========================================================================= --%>
            <%-- SECTION 2: DETAILS VIEW (FormView1 - Maklumat Permohonan)                  --%>
            <%-- ========================================================================= --%>
            <asp:FormView ID="FormView1" runat="server" DataKeyNames="JenisLesenIdList, JenisLesenDescList, Permohonan_ID, ApprStatusID"
                DataSourceID="SqlDataSourceForm" DefaultMode="Edit" Width="100%" CssClass="CustomTab">
                <EditItemTemplate>
                    <div class="card card-warning mb-3">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h3 class="card-title mb-0 font-weight-bold">
                                <i class="bi bi-x-octagon me-2"></i><span runat="server" id="idWindowTitle2">Maklumat Semakan Pembatalan</span>
                            </h3>
                            <div class="card-tools">
                                <button class="btn btn-tool text-white" data-card-widget="collapse" type="button">
                                    <i class="fas fa-minus"></i>
                                </button>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-label-custom"><i class="bi bi-person me-1 text-primary"></i>Nama Pemohon</label>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("Pemohon_Name") %>' CssClass="form-control" style="background-color: #f8fafc; font-weight: 600; color: #1e293b;"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-label-custom"><i class="bi bi-calendar3 me-1 text-primary"></i>Tarikh Mohon</label>
                                        <asp:Label ID="Label2" runat="server" Text='<%# Eval("TarikhMohon", "{0:dd/MM/yyyy}") %>' CssClass="form-control" style="background-color: #f8fafc;"></asp:Label>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-8">
                                    <div class="form-group">
                                        <label class="form-label-custom"><i class="bi bi-card-checklist me-1 text-primary"></i>Jenis Lesen</label>
                                        <asp:Label ID="Label3" runat="server" Text='<%# Bind("JenisLesenDescList") %>' CssClass="form-control" style="background-color: #f8fafc; font-weight: 500;"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-4 d-flex align-items-end" runat="server">
                                    <div class="form-group w-100">
                                        <label class="form-label-custom d-none d-md-block">&nbsp;</label>
                                        <asp:HyperLink ID="HyperLink1" runat="server"
                                            CssClass="btn btn-primary w-100 d-inline-flex align-items-center justify-content-center"
                                            NavigateUrl="javascript:void(0);"
                                            onclick="showPermohonanModal(); return false;"
                                            data-bs-toggle="modal" data-bs-target="#modalMaklumatPermohonan"
                                            data-toggle="modal" data-target="#modalMaklumatPermohonan">
                                            <i class="bi bi-file-earmark-text me-2"></i>Lihat Maklumat Permohonan
                                        </asp:HyperLink>
                                    </div>
                                </div>
                            </div>
                            <hr class="my-3" style="border-color: #e2e8f0;" />
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-label-custom"><i class="bi bi-journal-text me-1 text-primary"></i>Nota (Kelulusan)</label>
                                        <asp:Label ID="Label6" runat="server" Text='<%# Bind("NotaKelulusan") %>' CssClass="form-control" style="min-height: 85px; background-color: #f8fafc; white-space: pre-wrap;"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label class="form-label-custom"><i class="bi bi-info-circle me-1 text-primary"></i>Status</label>
                                        <asp:Label ID="Label5" runat="server" Text='<%# Eval("Description") %>' CssClass="form-control" style="background-color: #f8fafc;"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label class="form-label-custom"><i class="bi bi-eye me-1 text-primary"></i>Jumlah Paparan</label>
                                        <asp:Label ID="Label7" runat="server" Text='<%# Eval("TotalViews") %>' CssClass="form-control" style="background-color: #f8fafc;"></asp:Label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="card-footer d-flex flex-wrap align-items-center justify-content-between gap-3">
                            <div class="d-flex flex-wrap align-items-center gap-2">
                                <asp:LinkButton ID="btnBack" runat="server" CausesValidation="False" Text="Kembali ke senarai" CssClass="btn btn-outline-secondary d-inline-flex align-items-center" OnClick="btnBack_Click">
                                    <i class="bi bi-arrow-left me-1"></i>Kembali ke senarai
                                </asp:LinkButton>
                                <asp:LinkButton runat="server" CssClass="btn btn-warning d-inline-flex align-items-center text-dark" CausesValidation="False" Text="Lihat Surat Mohon Ulasan" ID="BT_SuratMohonUlasan" Visible='<%# If(CInt(Session.Item("sessionEstateId")) = 1, False, True) %>' OnCommand="BT_SuratMohonUlasan_Command">
                                    <i class="bi bi-envelope-paper me-1"></i>Lihat Surat Mohon Ulasan
                                </asp:LinkButton>
                                <asp:LinkButton runat="server" CssClass="btn btn-danger d-inline-flex align-items-center text-white" ValidationGroup="updateForm" Text="Lihat Surat Pembatalan" ID="BT_ViewMail" Visible='<%# If(Eval("ApprStatusID") < 9, False, True) %>' OnCommand="BT_ViewMail_Command" CausesValidation="False">
                                    <i class="bi bi-file-earmark-pdf me-1"></i>Lihat Surat Pembatalan
                                </asp:LinkButton>
                            </div>
                            <div class="d-flex flex-wrap align-items-center gap-3">
                                <div class="checkbox-box">
                                    <asp:CheckBox ID="CB_IsDigitalSign" runat="server" Checked="true" AutoPostBack="true" Enabled='<%# If(Eval("ApprStatusID") < 9, False, True) %>' Text="Janaan Komputer?" />
                                </div>
                                <div class="checkbox-box">
                                    <asp:CheckBox ID="CB_IsPublish" runat="server" Checked='<%# Eval("IsPublish") %>' OnCheckedChanged="CB_IsPublish_CheckedChanged" AutoPostBack="true" Enabled='<%# If(Eval("ApprStatusID") < 9, False, True) %>' Text="Terbit Pembatalan?" />
                                </div>
                            </div>
                        </div>
                    </div>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <div class="card card-primary">
                        <div class="card-header">
                            <h3 class="card-title">
                                <div runat="server" id="idWindowTitle3">Maklumat</div>
                            </h3>
                            <div class="card-tools">
                                <button type="button" class="btn btn-tool" data-card-widget="collapse"><i class="fas fa-minus"></i></button>
                            </div>
                            <div class="row" runat="server" id="idNotaKelulusan">
                            </div>
                        </div>
                    </div>
                </InsertItemTemplate>
            </asp:FormView>

            <asp:SqlDataSource ID="SqlDataSourceForm" runat="server"
                ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                InsertCommand=""
                SelectCommand="SELECT * FROM 
                v_LESEN_ApprovalListBatal_Curr a 
                inner join LESEN_Pemohon f on f.Pemohon_ID = a.Permohonan_PemohonID 
                inner join LESEN_Permohonan g on g.Permohonan_ID = a.Permohonan_ID 
                where a.Permohonan_ID = @Permohonan_ID ORDER BY ApprovalID Desc " 
                UpdateCommand="">
                <SelectParameters>
                    <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[0]" Name="Permohonan_ID"></asp:ControlParameter>
                </SelectParameters>
            </asp:SqlDataSource>

            <%-- ========================================================================= --%>
            <%-- SECTION 3: DETAIL TABS (TabContainer1)                                    --%>
            <%-- ========================================================================= --%>
            <asp:TabContainer ID="TabContainer1" runat="server" ActiveTabIndex="0" Visible="false" CssClass="MyTabStyle">
                
                <%-- TAB 1: SURAT PEMBATALAN (tabSurat) --%>
                <asp:TabPanel runat="server" ID="tabSurat" HeaderText="Surat">
                    <HeaderTemplate>Surat</HeaderTemplate>
                    <ContentTemplate>
                        <br />
                        <div class="row mb-2">
                            <div class="col-md-4" runat="server" id="divtemplatsurat">
                                <div class="form-group">
                                    <asp:DropDownList ID="DDL_SuratTemplat" CssClass="form-control select2" style="width: 100%;" runat="server" AutoPostBack="false"
                                        DataSourceID="SqlDataSourceSuratTemplat" DataTextField="NamaTemplatDesc" DataValueField="NamaTemplat">
                                    </asp:DropDownList>
                                    <asp:SqlDataSource runat="server" ID="SqlDataSourceSuratTemplat" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                        SelectCommand="SELECT * FROM 
                                        (SELECT '0' AS NamaTemplat, '-- Pilih Templat Surat --' AS NamaTemplatDesc
                                        UNION ALL
                                        SELECT DISTINCT CONCAT(JenisReport, ',',NamaTemplat) AS NamaTemplat, NamaTemplat AS NamaTemplatDesc 
                                        FROM LESEN_ReportTemplate 
                                        WHERE JenisLesen_ID = TRY_CAST(
                                            CASE 
                                                WHEN CHARINDEX(',', LTRIM(@JenisLesenIdList)) > 0 
                                                    THEN LEFT(LTRIM(@JenisLesenIdList), CHARINDEX(',', LTRIM(@JenisLesenIdList)) - 1)
                                                ELSE LTRIM(@JenisLesenIdList)
                                            END AS INT
                                        ) AND (JenisReport=IIF(@ApprStatusID=9, 'SPB', 'SPL') OR JenisReport='SPL' OR JenisReport='SPB') AND NamaTemplat is not null) AS tbl1 ORDER BY NamaTemplatDesc ">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[1]" Name="ApprStatusID"></asp:ControlParameter>
                                            <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[2]" Name="JenisLesenIdList"></asp:ControlParameter>
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <asp:LinkButton runat="server" CssClass="btn btn-warning" Text="Jana Surat" ID="BT_Generate" OnCommand="BT_Generate_Command" OnClientClick="return confirm('Jana surat sekarang?');" />													
                            </div>
                        </div>
                        <div class="row mb-2">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>Muat naik fail surat?</label>
                                    <asp:CheckBox ID="CB_SuratFail" runat="server" AutoPostBack="true" OnCheckedChanged="CB_SuratFail_CheckedChanged" />
                                </div>
                            </div>
                        </div>

                        <asp:Panel ID="pnlSuratFail" runat="server" Visible="false">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Fail Surat</label>
                                        <div class="row">
                                            <div class="col">
                                                <asp:FileUpload ID="FU_Lampiran3" runat="server" CssClass="form-control" accept="application/pdf" />
                                                <asp:HyperLink ID="HL_Lampiran3" NavigateUrl="#" Text="null" runat="server" />
                                            </div>
                                            <div class="col">
                                                <asp:LinkButton ID="BT_Update3" runat="server" Text="Ubah" CssClass="btn btn-warning" OnClick="BT_Update3_Click" />
                                                <asp:LinkButton ID="BT_Cancel3" runat="server" Text="Batal" CssClass="btn btn-default" OnClick="BT_Cancel3_Click" />
                                                <asp:LinkButton ID="BT_Delete3" runat="server" Text="Padam" CssClass="btn btn-default" OnClick="BT_Delete3_Click" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </asp:Panel>

                        <asp:Panel ID="pnlSuratAuto" runat="server">
                            <div class="card mb-2">
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <label>Tarikh Surat</label>
                                                <asp:TextBox ID="TB_TarikhSurat" runat="server" TextMode="Date" CssClass="form-control" />
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Tandatangan</label><br />
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
                                                        and (a.Users_IsPeraku = 1 or a.Users_IsPenilaian = 1) 
                                                        and b.JabatanAgensi_IsLesen = 1">
                                                    <SelectParameters>
                                                        <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[0]" Name="Permohonan_ID"></asp:ControlParameter>
                                                    </SelectParameters>
                                                </asp:SqlDataSource>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-footer">
                                    <div class="row">
                                        <div class="col-md-10 text-center">
                                            <asp:LinkButton ID="btnSaveLetter" runat="server" CausesValidation="False" Text="Kemaskini" CssClass="btn btn-warning" OnClick="btnSaveLetter_Click" />
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="card">
                                <div class="card-body">
                                    <div class="row mb-2">
                                        <div class="col-12">
                                            <asp:FormView ID="FormViewReport" Width="100%" DefaultMode="Insert" runat="server" DataKeyNames="PSID" DataSourceID="SqlDataSourceReport">
                                                <EditItemTemplate>
                                                    <asp:Panel runat="server">
                                                        <div class="card card-default">
                                                            <div class="card-header">
                                                                <h3 class="card-title" style="color: black">Kemaskini Isi Surat</h3>
                                                            </div>
                                                            <div class="card-body">
                                                                <div class="row">
                                                                    <div class="col-md-2">
                                                                        <div class="form-group">
                                                                            <label>No Perenggan Utama</label>
                                                                            <asp:TextBox ID="TB_P1" runat="server" TextMode="Number" Text='<%# Bind("P1") %>' CssClass="form-control" />
                                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" CssClass="cssRequiredField"
                                                                                ControlToValidate="TB_P1" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-md-2">
                                                                        <div class="form-group">
                                                                            <label>No Perenggan Sekunder</label>
                                                                            <asp:TextBox ID="TB_P2" runat="server" TextMode="Number" Text='<%# Bind("P2") %>' CssClass="form-control" />
                                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" CssClass="cssRequiredField"
                                                                                ControlToValidate="TB_P2" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-md-2">
                                                                        <div class="form-group">
                                                                            <label>No Perenggan Tertier</label>
                                                                            <asp:TextBox ID="TB_P3" runat="server" TextMode="Number" Text='<%# Bind("P3") %>' CssClass="form-control" />
                                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" CssClass="cssRequiredField"
                                                                                ControlToValidate="TB_P3" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="row">
                                                                    <div class="col-md-8">
                                                                        <div class="form-group">
                                                                            <label>Isi Kandungan</label>
                                                                            <asp:TextBox ID="TB_IsiKandungan" runat="server" TextMode="Multiline" Text='<%# Bind("IsiKandungan") %>' CssClass="form-control" />
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
                                                    <asp:Panel runat="server">
                                                        <div class="card card-default">
                                                            <div class="card-header">
                                                                <h3 class="card-title" style="color: black">Tambah Isi Surat</h3>
                                                            </div>
                                                            <div class="card-body">
                                                                <div class="row">
                                                                    <div class="col-md-2">
                                                                        <div class="form-group">
                                                                            <label>No Perenggan Utama</label>
                                                                            <asp:TextBox ID="TB_P1" runat="server" TextMode="Number" Text='<%# Bind("P1") %>' CssClass="form-control" />
                                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" CssClass="cssRequiredField"
                                                                                ControlToValidate="TB_P1" ErrorMessage="Sila Isi" ValidationGroup="frmInsert" Display="Dynamic"></asp:RequiredFieldValidator>
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-md-2">
                                                                        <div class="form-group">
                                                                            <label>No Perenggan Sekunder</label>
                                                                            <asp:TextBox ID="TB_P2" runat="server" TextMode="Number" Text='<%# Bind("P2") %>' CssClass="form-control" />
                                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" CssClass="cssRequiredField"
                                                                                ControlToValidate="TB_P2" ErrorMessage="Sila Isi" ValidationGroup="frmInsert" Display="Dynamic"></asp:RequiredFieldValidator>
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-md-2">
                                                                        <div class="form-group">
                                                                            <label>No Perenggan Tertier</label>
                                                                            <asp:TextBox ID="TB_P3" runat="server" TextMode="Number" Text='<%# Bind("P3") %>' CssClass="form-control" />
                                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" CssClass="cssRequiredField"
                                                                                ControlToValidate="TB_P3" ErrorMessage="Sila Isi" ValidationGroup="frmInsert" Display="Dynamic"></asp:RequiredFieldValidator>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="row">
                                                                    <div class="col-md-8">
                                                                        <div class="form-group">
                                                                            <label>Isi Kandungan</label>
                                                                            <asp:TextBox ID="TB_IsiKandungan" runat="server" TextMode="Multiline" Text='<%# Bind("IsiKandungan") %>' CssClass="form-control" />
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
                                                InsertCommand="INSERT INTO LESEN_PermohonanSurat (Permohonan_ID, JenisReport, P1, P2, P3, IsiKandungan, CreatedDt, ModDt) VALUES (@Permohonan_ID, IIF(@StatusID=9,'SPB','SPL'), @P1, @P2, @P3, @IsiKandungan, GETDATE(), GETDATE()); "
                                                UpdateCommand="UPDATE LESEN_PermohonanSurat SET P1=@P1, P2=@P2, P3=@P3, IsiKandungan=@IsiKandungan WHERE PSID=@PSID"
                                                SelectCommand="SELECT * FROM LESEN_PermohonanSurat WHERE PSID=@PSID">
                                                <InsertParameters>
                                                    <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[0]" Name="Permohonan_ID"></asp:ControlParameter>
                                                    <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[1]" Name="StatusID"></asp:ControlParameter>
                                                    <asp:Parameter Name="P1"></asp:Parameter>
                                                    <asp:Parameter Name="P2"></asp:Parameter>
                                                    <asp:Parameter Name="P3"></asp:Parameter>
                                                    <asp:Parameter Name="IsiKandungan"></asp:Parameter>
                                                </InsertParameters>
                                                <UpdateParameters>
                                                    <asp:Parameter Name="P1"></asp:Parameter>
                                                    <asp:Parameter Name="P2"></asp:Parameter>
                                                    <asp:Parameter Name="P3"></asp:Parameter>
                                                    <asp:Parameter Name="IsiKandungan"></asp:Parameter>
                                                    <asp:ControlParameter ControlID="GridViewReport" DefaultValue="" Name="PSID" PropertyName="SelectedValue" />
                                                </UpdateParameters>
                                                <SelectParameters>
                                                    <asp:ControlParameter ControlID="GridViewReport" PropertyName="SelectedValue" Name="PSID"></asp:ControlParameter>
                                                </SelectParameters>
                                            </asp:SqlDataSource>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-12">
                                            <asp:GridView ID="GridViewReport" HeaderStyle-ForeColor="Black" CssClass="table table-bordered" AllowPaging="True" ShowHeaderWhenEmpty="True" EmptyDataText="No records Found" AllowSorting="True" runat="server" AutoGenerateColumns="False" DataKeyNames="PSID" DataSourceID="SqlDataSourceGridReport">
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
                                                DeleteCommand="DELETE FROM LESEN_PermohonanSurat WHERE PSID=@PSID"
                                                SelectCommand="SELECT * FROM LESEN_PermohonanSurat WHERE Permohonan_ID=@Permohonan_ID AND (JenisReport=IIF(@StatusID=9, 'SPB', 'SPL') OR JenisReport LIKE 'SP%') 
                                                ORDER BY P1, P2, P3">
                                                <DeleteParameters>
                                                    <asp:Parameter Name="PSID"></asp:Parameter>
                                                </DeleteParameters>
                                                <SelectParameters>
                                                    <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[0]" Name="Permohonan_ID"></asp:ControlParameter>
                                                    <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[1]" Name="StatusID"></asp:ControlParameter>
                                                </SelectParameters>
                                            </asp:SqlDataSource>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </asp:Panel>
                    </ContentTemplate>
                </asp:TabPanel>

                <%-- TAB 2: LAMPIRAN SYARAT & BIL (tabLampiran) --%>
                <asp:TabPanel runat="server" ID="tabLampiran" HeaderText="Lampiran">
                    <HeaderTemplate>Lampiran</HeaderTemplate>
                    <ContentTemplate>
                        <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="conditional">
                            <Triggers>
                                <asp:PostBackTrigger ControlID="BT_Lampiran1" />
                                <asp:PostBackTrigger ControlID="BT_Lampiran2" />
                            </Triggers>
                            <ContentTemplate>
                                <br />
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Lampiran 1 - Syarat-syarat Lesen</label>
                                            <div class="row">
                                                <div class="col">
                                                    <asp:FileUpload ID="FU_Lampiran1" runat="server" CssClass="form-control"/>
                                                    <asp:HyperLink ID="HL_Lampiran1" NavigateUrl="#" Text="null" runat="server" />
                                                </div>
                                                <div class="col">
                                                    <asp:LinkButton ID="BT_Lampiran1" runat="server" Text="Muat Naik" CssClass="btn btn-default" OnClick="BT_Lampiran1_Click" />
                                                    <asp:LinkButton ID="BT_Update1" runat="server" Text="Ubah" CssClass="btn btn-warning" OnClick="BT_Update1_Click"/>
                                                    <asp:LinkButton ID="BT_Cancel1" runat="server" Text="Batal" CssClass="btn btn-default" OnClick="BT_Cancel1_Click"/>
                                                    <asp:LinkButton ID="BT_Delete1" runat="server" Text="Padam" CssClass="btn btn-default" OnClick="BT_Delete1_Click" />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <br />
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Lampiran 2 - Bil</label>
                                            <div class="row">
                                                <div class="col">
                                                    <asp:FileUpload ID="FU_Lampiran2" runat="server" CssClass="form-control"/>
                                                    <asp:HyperLink ID="HL_Lampiran2" NavigateUrl="#" Text="null" runat="server" />
                                                </div>
                                                <div class="col">
                                                    <asp:LinkButton ID="BT_Lampiran2" runat="server" Text="Muat Naik" CssClass="btn btn-default" OnClick="BT_Lampiran2_Click" />
                                                    <asp:LinkButton ID="BT_Update2" runat="server" Text="Ubah" CssClass="btn btn-warning" OnClick="BT_Update2_Click" />
                                                    <asp:LinkButton ID="BT_Cancel2" runat="server" Text="Batal" CssClass="btn btn-default" OnClick="BT_Cancel2_Click" />
                                                    <asp:LinkButton ID="BT_Delete2" runat="server" Text="Padam" CssClass="btn btn-default" OnClick="BT_Delete2_Click"/>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <br />
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </ContentTemplate>
                </asp:TabPanel>

                <%-- TAB 3: ULASAN IK (tabUlasan) --%>
                <asp:TabPanel runat="server" ID="tabUlasan" HeaderText="Ulasan">
                    <HeaderTemplate>Ulasan IK</HeaderTemplate>
                    <ContentTemplate>
                        <asp:GridView ID="gvTabUlasan" runat="server" ShowHeaderWhenEmpty="True"
                            AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="UlasanFail_ID"
                            DataSourceID="SqlDataSourceTabUlasanIK"
                            CssClass="table table-bordered" Width="100%">
                            <AlternatingRowStyle CssClass="alt" />
                            <Columns>
                                <asp:TemplateField HeaderText="ID" SortExpression="UlasanFail_ID">
                                    <EditItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("UlasanFail_ID") %>'></asp:Label>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Bind("UlasanFail_ID") %>'></asp:Label>
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

                                <asp:TemplateField HeaderText="Ulasan">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtUlasanFail_Remarks" runat="server" Text='<%# Bind("UlasanFail_Remarks") %>' CssClass="form-control" TextMode="MultiLine" Rows="4" ReadOnly="True" BorderStyle="None"></asp:TextBox><br />
                                        Jabatan/Agensi :
                                        <asp:Label ID="lblJabatanAgensi_Description" runat="server" Text='<%# Eval("JabatanAgensi_Description") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtUlasanFail_Remarks" runat="server" Text='<%# Bind("UlasanFail_Remarks") %>' CssClass="form-control" TextMode="MultiLine" Rows="4"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rvUlasanFail_Remarks" runat="server" CssClass="cssRequiredField"
                                            ControlToValidate="txtUlasanFail_Remarks" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </EditItemTemplate>
                                    <HeaderStyle Width="55%" HorizontalAlign="Left" />
                                    <ItemStyle HorizontalAlign="Left" />
                                </asp:TemplateField>

                                <asp:TemplateField>
                                    <ItemTemplate>
                                        Fail :
                                        <asp:HyperLink ID="hpFile" runat="server" NavigateUrl='<%# Eval("UlasanFail_FilePath") %>' Target="_blank"><%#Eval("UlasanFail_FileName") %></asp:HyperLink>
                                        <asp:HiddenField ID="hdnFldUlasanFail_FileName" Value='<%# Bind("UlasanFail_FileName") %>' runat="server" />
                                        <asp:HiddenField ID="hdnFldUlasanFail_ContentType" Value='<%# Bind("UlasanFail_ContentType") %>' runat="server" />
                                        <asp:HiddenField ID="hdnFldUlasanFail_FilePath" Value='<%# Bind("UlasanFail_FilePath") %>' runat="server" />
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:FileUpload ID="txtUlasanFail_FilePath" runat="server" CssClass="form-control"></asp:FileUpload>
                                        <asp:Button ID="btnUpload" runat="server" Text="Muat Naik" OnClick="btnUpload_Click" Visible="false"
                                            OnClientClick="return confirm('Fail sedia ada akan ditukar ke fail yang baru.');" />
                                        <asp:HiddenField ID="hdnFldUlasanFail_FileName" Value='<%# Bind("UlasanFail_FileName") %>' runat="server" />
                                        <asp:HiddenField ID="hdnFldUlasanFail_ContentType" Value='<%# Bind("UlasanFail_ContentType") %>' runat="server" />
                                        <asp:HiddenField ID="hdnFldUlasanFail_FilePath" Value='<%# Bind("UlasanFail_FilePath") %>' runat="server" />
                                    </EditItemTemplate>
                                    <HeaderStyle Width="25%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Maklumat Ulasan" HeaderStyle-Font-Size="10pt" HeaderStyle-Width="90%" ItemStyle-Width="90%">
                                    <ItemTemplate>
                                        <asp:Label ID="Label15" runat="server" Text="Ulasan :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                        <asp:Label ID="Label16" runat="server" Text='<%# If(Len(Eval("UlasanFail_Remarks").ToString()) > 0, (Eval("UlasanFail_Remarks")).Replace(vbCr, "").Replace(vbLf, vbCrLf).Replace(Environment.NewLine, "<br />"), Eval("UlasanFail_Remarks")) %>' Font-Size="10pt"></asp:Label><br />
                                        <asp:Label ID="Label9" runat="server" Text="Fail :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                        <asp:HyperLink ID="hpFileMobile" CssClass="paraGraphtext" runat="server" NavigateUrl='<%# Eval("UlasanFail_FilePath") %>' Target="_blank" Font-Bold="True" Font-Size="10pt"><%#If(Len(Eval("UlasanFail_FileName").ToString()) > 25, Eval("UlasanFail_FileName").ToString.Substring(Len(Eval("UlasanFail_FileName").ToString()) - 25), Eval("UlasanFail_FileName")) %></asp:HyperLink><br />
                                        <asp:Label ID="Label13" runat="server" Text="Jabatan/Agensi :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                        <asp:Label ID="Label19" runat="server" Text='<%# Eval("JabatanAgensi_Description") %>' Font-Size="10pt"></asp:Label><br />
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:Label ID="Label15" runat="server" Text="Ulasan :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                        <asp:TextBox ID="txtUlasanFail_RemarksMobile" runat="server" Text='<%# Bind("UlasanFail_Remarks") %>' CssClass="form-control" TextMode="MultiLine" Rows="4"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rvUlasanFail_RemarksMobile" runat="server" CssClass="cssRequiredField"
                                            ControlToValidate="txtUlasanFail_RemarksMobile" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator><br />
                                        <asp:Label ID="Label9" runat="server" Text="Fail :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                        <asp:FileUpload ID="txtUlasanFail_FilePathMobile" runat="server" CssClass="form-control"></asp:FileUpload>
                                        <asp:Button ID="btnUploadMobile" runat="server" Text="Muat Naik" OnClick="btnUpload_Click" Visible="false"
                                            OnClientClick="return confirm('Fail sedia ada akan ditukar ke fail yang baru.');" /><br />
                                        <asp:Label ID="Label13" runat="server" Text="Jabatan/Agensi :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                        <asp:Label ID="Label19" runat="server" Text='<%# Eval("JabatanAgensi_Description") %>' Font-Size="10pt"></asp:Label><br />
                                    </EditItemTemplate>
                                    <ItemStyle HorizontalAlign="Left" />
                                </asp:TemplateField>
                            </Columns>
                            <PagerStyle CssClass="pgr" />
                        </asp:GridView>

                        <asp:SqlDataSource ID="SqlDataSourceTabUlasanIK" runat="server"
                            ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                            SelectCommand=" SELECT a.*,b.JabatanAgensi_Description FROM LESEN_UlasanFailBatal a
                                left join LESEN_JabatanAgensi b on b.JabatanAgensi_ID = a.UlasanFail_PermohonanAgensiID
                                where UlasanFail_PermohonanID = @PermohonanID AND UlasanFail_PermohonanAgensiID = 3 
                                order by CreatedDt asc, UlasanFail_ID asc"
                            DeleteCommand="DELETE FROM LESEN_UlasanFailBatal where UlasanFail_ID = @UlasanFail_ID"
                            UpdateCommand="UPDATE LESEN_UlasanFailBatal SET UlasanFail_Remarks = @UlasanFail_Remarks, 
                                UlasanFail_FileName = @UlasanFail_FileName,
                                UlasanFail_ContentType = @UlasanFail_ContentType,
                                UlasanFail_FilePath = @UlasanFail_FilePath,
                                LastModID = @LastModID, LastModDt = GETDATE()
                                WHERE (UlasanFail_ID = @UlasanFail_ID)">
                            <DeleteParameters>
                                <asp:ControlParameter ControlID="gvTabUlasan" DefaultValue="" Name="UlasanFail_ID" PropertyName="SelectedValue" />
                            </DeleteParameters>
                            <SelectParameters>
                                <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[0]" Name="PermohonanID"></asp:ControlParameter>
                            </SelectParameters>
                            <UpdateParameters>
                                <asp:Parameter Name="UlasanFail_Remarks" DefaultValue="" />
                                <asp:Parameter Name="UlasanFail_FileName" />
                                <asp:Parameter Name="UlasanFail_ContentType" />
                                <asp:Parameter Name="UlasanFail_FilePath" />
                                <asp:SessionParameter Name="LastModID" SessionField="sessionUserName" />
                                <asp:Parameter Name="UlasanFail_ID" />
                            </UpdateParameters>
                        </asp:SqlDataSource>
                    </ContentTemplate>
                </asp:TabPanel>

                <%-- TAB 4: ULASAN AGENSI LUAR (tabUlasanLuar) --%>
                <asp:TabPanel runat="server" ID="tabUlasanLuar" HeaderText="Ulasan Agensi Luar">
                    <HeaderTemplate>Ulasan Agensi Luar</HeaderTemplate>
                    <ContentTemplate>
                        <asp:GridView ID="gvTabUlasanLuar" runat="server" ShowHeaderWhenEmpty="True"
                            AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="UlasanFail_ID"
                            DataSourceID="SqlDataSourceTabUlasanLuar"
                            CssClass="table table-bordered" Width="100%">
                            <AlternatingRowStyle CssClass="alt" />
                            <Columns>
                                <asp:TemplateField HeaderText="ID" SortExpression="UlasanFail_ID">
                                    <EditItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("UlasanFail_ID") %>'></asp:Label>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Bind("UlasanFail_ID") %>'></asp:Label>
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

                                <asp:TemplateField HeaderText="Ulasan">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtUlasanFail_Remarks" runat="server" Text='<%# Bind("UlasanFail_Remarks") %>' CssClass="form-control" TextMode="MultiLine" Rows="4" ReadOnly="True" BorderStyle="None"></asp:TextBox><br />
                                        Jabatan/Agensi :
                                        <asp:Label ID="lblJabatanAgensi_Description" runat="server" Text='<%# Eval("JabatanAgensi_Description") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtUlasanFail_Remarks" runat="server" Text='<%# Bind("UlasanFail_Remarks") %>' CssClass="form-control" TextMode="MultiLine" Rows="4"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rvUlasanFail_Remarks" runat="server" CssClass="cssRequiredField"
                                            ControlToValidate="txtUlasanFail_Remarks" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </EditItemTemplate>
                                    <HeaderStyle Width="55%" HorizontalAlign="Left" />
                                    <ItemStyle HorizontalAlign="Left" />
                                </asp:TemplateField>

                                <asp:TemplateField>
                                    <ItemTemplate>
                                        Fail :
                                        <asp:HyperLink ID="hpFile" runat="server" NavigateUrl='<%# Eval("UlasanFail_FilePath") %>' Target="_blank"><%#Eval("UlasanFail_FileName") %></asp:HyperLink>
                                        <asp:HiddenField ID="hdnFldUlasanFail_FileName" Value='<%# Bind("UlasanFail_FileName") %>' runat="server" />
                                        <asp:HiddenField ID="hdnFldUlasanFail_ContentType" Value='<%# Bind("UlasanFail_ContentType") %>' runat="server" />
                                        <asp:HiddenField ID="hdnFldUlasanFail_FilePath" Value='<%# Bind("UlasanFail_FilePath") %>' runat="server" />
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:FileUpload ID="txtUlasanFail_FilePath" runat="server" CssClass="form-control"></asp:FileUpload>
                                        <asp:Button ID="btnUpload" runat="server" Text="Muat Naik" OnClick="btnUpload_Click" Visible="false"
                                            OnClientClick="return confirm('Fail sedia ada akan ditukar ke fail yang baru.');" />
                                        <asp:HiddenField ID="hdnFldUlasanFail_FileName" Value='<%# Bind("UlasanFail_FileName") %>' runat="server" />
                                        <asp:HiddenField ID="hdnFldUlasanFail_ContentType" Value='<%# Bind("UlasanFail_ContentType") %>' runat="server" />
                                        <asp:HiddenField ID="hdnFldUlasanFail_FilePath" Value='<%# Bind("UlasanFail_FilePath") %>' runat="server" />
                                    </EditItemTemplate>
                                    <HeaderStyle Width="25%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Maklumat Ulasan" HeaderStyle-Font-Size="10pt" HeaderStyle-Width="90%" ItemStyle-Width="90%">
                                    <ItemTemplate>
                                        <asp:Label ID="Label15" runat="server" Text="Ulasan :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                        <asp:Label ID="Label16" runat="server" Text='<%# If(Len(Eval("UlasanFail_Remarks").ToString()) > 0, (Eval("UlasanFail_Remarks")).Replace(vbCr, "").Replace(vbLf, vbCrLf).Replace(Environment.NewLine, "<br />"), Eval("UlasanFail_Remarks")) %>' Font-Size="10pt"></asp:Label><br />
                                        <asp:Label ID="Label9" runat="server" Text="Fail :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                        <asp:HyperLink ID="hpFileMobile" CssClass="paraGraphtext" runat="server" NavigateUrl='<%# Eval("UlasanFail_FilePath") %>' Target="_blank" Font-Bold="True" Font-Size="10pt"><%#If(Len(Eval("UlasanFail_FileName").ToString()) > 25, Eval("UlasanFail_FileName").ToString.Substring(Len(Eval("UlasanFail_FileName").ToString()) - 25), Eval("UlasanFail_FileName")) %></asp:HyperLink><br />
                                        <asp:Label ID="Label13" runat="server" Text="Jabatan/Agensi :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                        <asp:Label ID="Label19" runat="server" Text='<%# Eval("JabatanAgensi_Description") %>' Font-Size="10pt"></asp:Label><br />
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:Label ID="Label15" runat="server" Text="Ulasan :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                        <asp:TextBox ID="txtUlasanFail_RemarksMobile" runat="server" Text='<%# Bind("UlasanFail_Remarks") %>' CssClass="form-control" TextMode="MultiLine" Rows="4"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rvUlasanFail_RemarksMobile" runat="server" CssClass="cssRequiredField"
                                            ControlToValidate="txtUlasanFail_RemarksMobile" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator><br />
                                        <asp:Label ID="Label9" runat="server" Text="Fail :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                        <asp:FileUpload ID="txtUlasanFail_FilePathMobile" runat="server" CssClass="form-control"></asp:FileUpload>
                                        <asp:Button ID="btnUploadMobile" runat="server" Text="Muat Naik" OnClick="btnUpload_Click" Visible="false"
                                            OnClientClick="return confirm('Fail sedia ada akan ditukar ke fail yang baru.');" /><br />
                                        <asp:Label ID="Label13" runat="server" Text="Jabatan/Agensi :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                        <asp:Label ID="Label19" runat="server" Text='<%# Eval("JabatanAgensi_Description") %>' Font-Size="10pt"></asp:Label><br />
                                    </EditItemTemplate>
                                    <ItemStyle HorizontalAlign="Left" />
                                </asp:TemplateField>
                            </Columns>
                            <PagerStyle CssClass="pgr" />
                        </asp:GridView>

                        <asp:SqlDataSource ID="SqlDataSourceTabUlasanLuar" runat="server"
                            ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                            SelectCommand=" SELECT a.*,b.JabatanAgensi_Description FROM LESEN_UlasanFailBatal a
                                left join LESEN_JabatanAgensi b on b.JabatanAgensi_ID = a.UlasanFail_PermohonanAgensiID
                                where UlasanFail_PermohonanID = @PermohonanID AND UlasanFail_PermohonanAgensiID <> 3 
                                order by CreatedDt asc, UlasanFail_ID asc"
                            DeleteCommand="DELETE FROM LESEN_UlasanFailBatal where UlasanFail_ID = @UlasanFail_ID"
                            UpdateCommand="UPDATE LESEN_UlasanFailBatal SET UlasanFail_Remarks = @UlasanFail_Remarks, 
                                UlasanFail_FileName = @UlasanFail_FileName,
                                UlasanFail_ContentType = @UlasanFail_ContentType,
                                UlasanFail_FilePath = @UlasanFail_FilePath,
                                LastModID = @LastModID, LastModDt = GETDATE()
                                WHERE (UlasanFail_ID = @UlasanFail_ID)">
                            <DeleteParameters>
                                <asp:ControlParameter ControlID="gvTabUlasanLuar" DefaultValue="" Name="UlasanFail_ID" PropertyName="SelectedValue" />
                            </DeleteParameters>
                            <SelectParameters>
                                <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[0]" Name="PermohonanID"></asp:ControlParameter>
                            </SelectParameters>
                            <UpdateParameters>
                                <asp:Parameter Name="UlasanFail_Remarks" DefaultValue="" />
                                <asp:Parameter Name="UlasanFail_FileName" />
                                <asp:Parameter Name="UlasanFail_ContentType" />
                                <asp:Parameter Name="UlasanFail_FilePath" />
                                <asp:SessionParameter Name="LastModID" SessionField="sessionUserName" />
                                <asp:Parameter Name="UlasanFail_ID" />
                            </UpdateParameters>
                        </asp:SqlDataSource>
                    </ContentTemplate>
                </asp:TabPanel>

                <%-- TAB 5: MESYUARAT & WANG AMANAH (tabWangAmanah) --%>
                <asp:TabPanel runat="server" ID="tabWangAmanah" HeaderText="Mesyuarat / Wang Amanah">
                    <HeaderTemplate>Mesyuarat / Wang Amanah</HeaderTemplate>
                    <ContentTemplate>
                        <br />
                        <div class="card card-outline card-primary mb-3">
                            <div class="card-header">
                                <h3 class="card-title"><i class="fas fa-users mr-1"></i> Maklumat Mesyuarat</h3>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Tarikh Mesyuarat</label>
                                            <asp:TextBox ID="TB_TarikhMesyuarat" runat="server" TextMode="Date" CssClass="form-control" />
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>No Mesyuarat</label>
                                            <asp:TextBox ID="TB_NoMesyuarat" runat="server" CssClass="form-control" />
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Tindakan Pembatalan</label>
                                            <asp:DropDownList ID="DDL_TindakanBatal" CssClass="form-control select2" style="width: 100%;" runat="server"
                                                DataSourceID="SqlDataSourceTindakan" DataTextField="name" DataValueField="id">
                                            </asp:DropDownList>
                                            <asp:SqlDataSource runat="server" ID="SqlDataSourceTindakan" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                SelectCommand="SELECT id, name FROM TBL_LOOKUPS WHERE lookupgrp_id = 10005 AND status = 1"></asp:SqlDataSource>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="card card-outline card-secondary mb-3">
                            <div class="card-header">
                                <h3 class="card-title"><i class="fas fa-money-check-alt mr-1"></i> Maklumat Wang Amanah</h3>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Wang Amanah Diterima (RM)</label>
                                            <asp:Label ID="lblDepositAmount" runat="server" Text="0.00" CssClass="form-control"></asp:Label>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Tarikh Diterima</label>
                                            <asp:Label ID="lblDepositDate" runat="server" Text="-" CssClass="form-control"></asp:Label>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Nombor Resit</label>
                                            <asp:Label ID="lblDepositResitNo" runat="server" Text="-" CssClass="form-control"></asp:Label>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Pemulangan Wang Amanah (RM)</label>
                                            <asp:Label ID="lblDepositPulangAmount" runat="server" Text="0.00" CssClass="form-control highlighted"></asp:Label>
                                        </div>
                                    </div>
                                </div>
                                <hr />
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Hantar ke kewangan?</label>
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
                            </div>
                            <div class="card-footer">
                                <div class="row">
                                    <div class="col-md-12 text-center">
                                        <asp:LinkButton ID="BtnSaveMesyuarat" runat="server" CausesValidation="False" Text="Kemaskini" CssClass="btn btn-warning" OnClick="BtnSaveMesyuarat_Click" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <br />
                    </ContentTemplate>
                </asp:TabPanel>

            </asp:TabContainer>

            <%-- ========================================================================= --%>
            <%-- SECTION 4: MAIN LISTING & SEARCH FILTER (idListing & GridView1)           --%>
            <%-- ========================================================================= --%>
            <div class="card card-primary" runat="server" id="idListing">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h3 class="card-title mb-0 font-weight-bold">
                        <i class="bi bi-x-octagon me-2"></i>Senarai Semakan Pembatalan
                    </h3>
                </div>
                <div class="card-body">
                    <div class="form-section-header mt-0 mb-3">
                        <i class="bi bi-funnel"></i>
                        <span>Carian & Penapis Rekod</span>
                    </div>
                    <div class="row align-items-end g-3 mb-4">
                        <div class="col-md-3">
                            <div class="form-group mb-0">
                                <label class="form-label-custom">No Rujukan</label>
                                <asp:TextBox ID="txtNoRujukan" placeholder="Cth: MPKS/..." runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                        </div>

                        <div class="col-md-3" runat="server" id="filterJenisLesen">
                            <div class="form-group mb-0">
                                <label class="form-label-custom">Jenis Lesen</label>
                                <asp:DropDownList ID="DDL_JenisLesen" CssClass="form-control select2" runat="server" AutoPostBack="false"
                                    DataSourceID="SqlDataSourceLesen" DataTextField="JenisLesen_Description" DataValueField="JenisLesen_ID">
                                </asp:DropDownList>
                                <asp:SqlDataSource runat="server" ID="SqlDataSourceLesen" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                    SelectCommand="SELECT * FROM 
                                (select '0' as JenisLesen_ID, '-- Lesen --' as JenisLesen_Description
                                union all
                                select JenisLesen_Description AS JenisLesen_ID, JenisLesen_Description from LESEN_JenisLesen where JenisLesen_IsActive=1
                                ) as tbl1 order by JenisLesen_Description "></asp:SqlDataSource>
                            </div>
                        </div>

                        <div class="col-md-2">
                            <div class="form-group mb-0">
                                <label class="form-label-custom">Tarikh Batal</label>
                                <asp:TextBox ID="TB_TarikhBatal" runat="server" TextMode="Date" CssClass="form-control" />
                            </div>
                        </div>

                        <div class="col-md-2" runat="server" id="filterStatus">
                            <div class="form-group mb-0">
                                <label class="form-label-custom">Status</label>
                                <asp:DropDownList ID="ddlStatus" CssClass="form-control select2" runat="server" AutoPostBack="false"
                                    DataSourceID="sdsStatus" DataTextField="Description" DataValueField="ApprStatusID">
                                </asp:DropDownList>
                                <asp:SqlDataSource runat="server" ID="sdsStatus" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                    SelectCommand="select * from 
                                (select -1 as ApprStatusID, '-- Status --' as Description
                                union all
                                select ApprStatusID, Description from ApprovalStatusBatal
                                WHERE ApprStatusID > 8) as tbl1 order by ApprStatusID "></asp:SqlDataSource>
                            </div>
                        </div>

                        <div class="col-md-2">
                            <div class="form-group mb-0 d-flex gap-2">
                                <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-primary flex-fill" Text="Cari" />
                                <asp:Button ID="btnReset" CssClass="btn btn-outline-secondary flex-fill" runat="server" Text="Reset" />
                            </div>
                        </div>
                    </div>

                    <div class="table-responsive">
                        <asp:GridView ID="GridView1" runat="server" Visible="true" AllowPaging="true"
                            AllowSorting="True" AutoGenerateColumns="False" 
                            DataKeyNames="Permohonan_ID,ApprStatusID,JenisLesenIdList,IsSuratPembatalanFail,IsPublish"
                            DataSourceID="SqlDataSourceGrid"
                            CssClass="table custom-gridview table-hover align-middle" PagerStyle-CssClass="pgr"
                            AlternatingRowStyle-CssClass="alt">
                            <AlternatingRowStyle CssClass="alt" />
                            <Columns>
                                <asp:BoundField DataField="RowNo" HeaderText="No" SortExpression="RowNo"></asp:BoundField>
                                <asp:BoundField DataField="Rujukan" HeaderText="No Rujukan" SortExpression="Rujukan" />
                                <asp:BoundField DataField="JenisLesenDescList" HeaderText="Jenis Lesen" SortExpression="JenisLesenDescList" />
                                <asp:BoundField DataField="Pemohon_Name" HeaderText="Nama Pemohon" SortExpression="Pemohon_Name" />
                                <asp:BoundField DataField="CreatedDt" HeaderText="Tarikh Batal" DataFormatString="{0:dd/MM/yyyy}" SortExpression="CreatedDt" />
                                <asp:BoundField DataField="StatusDesc" HeaderText="Status" SortExpression="StatusDesc" />

                                <asp:TemplateField HeaderText="Maklumat Permohonan" HeaderStyle-Font-Size="10pt" HeaderStyle-Width="90%" ItemStyle-Width="90%">
                                    <ItemTemplate>
                                        <div class="p-1">
                                            <div class="fw-bold text-primary"><%# Eval("Rujukan") %></div>
                                            <div class="text-muted small"><strong>Tarikh Batal:</strong> <%# Eval("CreatedDt", "{0:dd/MM/yyyy}") %></div>
                                            <div class="text-muted small"><strong>Lesen:</strong> <%# Eval("JenisLesenDescList") %></div>
                                            <div class="text-muted small"><strong>Pemohon:</strong> <%# Eval("Pemohon_Name") %></div>
                                            <div class="text-muted small"><strong>Status:</strong> <span class="badge bg-secondary"><%# Eval("StatusDesc") %></span></div>
                                        </div>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Left" />
                                </asp:TemplateField>

                                <asp:TemplateField ShowHeader="False">
                                    <ItemTemplate>
                                        <div class="d-flex flex-wrap gap-1 align-items-center justify-content-center">
                                            <asp:LinkButton runat="server" CssClass="btn btn-primary btn-sm text-nowrap" CommandName="Select" CausesValidation="False"
                                                ID="LinkButton5" Visible='<%# If(Eval("UserType") > 0 And Eval("StatusID") > 0, True, False) %>' data-toggle="tooltip" data-placement="top" title="Lihat">
                                                <i class="bi bi-eye me-1"></i>Lihat
                                            </asp:LinkButton>

                                            <asp:LinkButton runat="server" CssClass="btn btn-warning btn-sm text-nowrap" CommandName="Surat" CausesValidation="False" ID="LinkButton6"
                                                Visible='<%# If(Eval("UserType") > 0 And Eval("IsPublish") = True, True, False) %>' CommandArgument='<%# Container.DataItemIndex %>' data-toggle="tooltip" data-placement="top" title="Surat">
                                                <i class="bi bi-file-earmark-text me-1"></i>Surat
                                            </asp:LinkButton>

                                            <asp:LinkButton runat="server" CssClass="btn btn-outline-primary btn-sm text-nowrap" CommandName="Lampiran1" CausesValidation="False" ID="LinkButton7"
                                                Visible='<%# If(Eval("UserType") > 0 And Eval("IsPublish") = True, True, False) %>' CommandArgument='<%# Container.DataItemIndex %>' data-toggle="tooltip" data-placement="top" title="Lampiran 1">
                                                <i class="bi bi-paperclip me-1"></i>Lampiran 1
                                            </asp:LinkButton>

                                            <asp:LinkButton runat="server" CssClass="btn btn-outline-secondary btn-sm text-nowrap" CommandName="Lampiran2" CausesValidation="False" ID="LinkButton3"
                                                Visible='<%# If(Eval("UserType") > 0 And Eval("IsPublish") = True, True, False) %>' CommandArgument='<%# Container.DataItemIndex %>' data-toggle="tooltip" data-placement="top" title="Lampiran 2">
                                                <i class="bi bi-paperclip me-1"></i>Lampiran 2
                                            </asp:LinkButton>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="TarikhMohon" HeaderText="TarikhMohon" DataFormatString="{0:dd/MM/yyyy}" SortExpression="TarikhMohon" Visible="false"></asp:BoundField>
                                <asp:BoundField DataField="Is24jam" HeaderText="Risiko" SortExpression="Is24jam" Visible="false"></asp:BoundField>
                            </Columns>
                            <PagerStyle CssClass="pgr" />
                        </asp:GridView>
                    </div>
                </div>
            </div>

        </div>
    </section>

    <asp:Button ID="ui_btnPageBottom" runat="server" Text="-" Style="margin-left: -999px;" />

    <%-- ========================================================================= --%>
    <%-- SECTION 5: MAIN GRID DATA SOURCES (SqlDataSourceGrid)                    --%>
    <%-- ========================================================================= --%>
    <asp:SqlDataSource ID="SqlDataSourceGrid" runat="server"
        ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
        SelectCommand="SELECT ROW_NUMBER() OVER(ORDER BY TarikhMohon desc, Permohonan_ID desc) as RowNo, * FROM (
            SELECT ROW_NUMBER() OVER (PARTITION BY a.Permohonan_ID ORDER BY a.ApprovalID DESC) AS RepNo,
            (CASE WHEN a.ApprStatusID < 9 AND ISNULL(a.AgensiID, 0) > 0 then a.Description + ' - ' + e.JabatanAgensi_Description ELSE a.Description END) AS StatusDesc,
            @AgensiID AS UserType, a.*, g.JenisLesenIdList, g.JenisLesenDescList, g.Rujukan, g.IsSuratPembatalanFail, g.StatusID, g.IsPublish, g.Is24jam, f.Pemohon_Name, h.CreatedDt FROM 
            v_LESEN_ApprovalListBatal_Curr a 
            left join LESEN_JabatanAgensi e on e.JabatanAgensi_ID = a.AgensiID
            inner join LESEN_Pemohon f on f.Pemohon_ID = a.Permohonan_PemohonID
            inner join LESEN_Permohonan g on g.Permohonan_ID = a.Permohonan_ID 
            inner join LESEN_ApprovalListBatal h on h.Permohonan_ID = a.Permohonan_ID and h.ApprStatusID = a.ApprStatusID 
            WHERE a.Permohonan_ID in (
            SELECT x1.Permohonan_ID 
            FROM LESEN_ApprovalListBatal x1 
            where 
            case when @AgensiID = 0 then '0' when isnull((select top 1 x.JabatanAgensi_IsLesen from LESEN_JabatanAgensi x where x.JabatanAgensi_ID = @AgensiID),0) = 1 then isnull(x1.AgensiID, @AgensiID) else x1.AgensiID end 
            = case when @AgensiID = 0 then '0'  when isnull((select top 1 x.JabatanAgensi_IsLesen from LESEN_JabatanAgensi x where x.JabatanAgensi_ID = @AgensiID),0) = 1 then @AgensiID else @AgensiID end
            and RTRIM(Rujukan) like case when @AgensiID = 0 then @Rujukan else '%'+ @Rujukan +'%' end
            )
            and g.JenisLesenDescList LIKE case when @LesenDesc = '0' then g.JenisLesenDescList else '%'+@LesenDesc+'%' end
            and (CONVERT(VARCHAR(25), h.CreatedDt, 126) LIKE '%'+@TarikhBatal+'%' 
            or h.CreatedDt IS NULL)
            and a.ApprStatusID = case when @statusID = -1 then a.ApprStatusID else @statusID end
            and g.StatusID > 0  
            and g.IsBatal = 1 
            and g.JenisLesenIdList is not null
            and g.JenisLesenIdList <> '27'
            ) AS tbl WHERE RepNo = 1 order by TarikhMohon desc, Permohonan_ID desc">
        <SelectParameters>
            <asp:SessionParameter SessionField="sessionEstateID" DefaultValue="0" Name="AgensiID"></asp:SessionParameter>
            <asp:ControlParameter ControlID="txtNoRujukan" PropertyName="Text" DefaultValue="%%" Name="Rujukan"></asp:ControlParameter>
            <asp:ControlParameter ControlID="DDL_JenisLesen" PropertyName="SelectedValue" Name="LesenDesc"></asp:ControlParameter>
            <asp:ControlParameter ControlID="TB_TarikhBatal" PropertyName="Text" DefaultValue="%%" Name="TarikhBatal"></asp:ControlParameter>
            <asp:ControlParameter ControlID="ddlStatus" PropertyName="SelectedValue" Name="statusID"></asp:ControlParameter>
        </SelectParameters>
    </asp:SqlDataSource>

    <%-- ========================================================================= --%>
    <%-- SECTION 6: MODAL POPUP (Maklumat Permohonan - Excludes Banting)           --%>
    <%-- ========================================================================= --%>
    <div class="modal fade" id="modalMaklumatPermohonan" tabindex="-1" aria-labelledby="modalMaklumatPermohonanLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-scrollable" style="max-width: 92vw; width: 92vw;">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 12px; overflow: hidden;">
                <div class="modal-header bg-primary text-white py-3">
                    <h5 class="modal-title font-weight-bold d-flex align-items-center mb-0" id="modalMaklumatPermohonanLabel">
                        <i class="bi bi-info-circle-fill me-2 fs-5"></i>
                        <span>Butiran Maklumat Permohonan:</span>
                        <span class="ms-2 badge bg-white text-primary fs-6 fw-bold">
                            <asp:Label ID="lblModalNoRujukan" runat="server" Text="-"></asp:Label>
                        </span>
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4 bg-light">

                    <!-- SECTION 1: MAKLUMAT PEMOHON -->
                    <div class="card modal-details-card mb-2">
                        <div class="form-section-header mt-0">
                            <i class="bi bi-person-vcard"></i>
                            <span>Maklumat Pemohon</span>
                        </div>
                        <div class="row g-2">
                            <div class="col-md-3 col-lg-2">
                                <div class="modal-field-group">
                                    <label class="modal-field-label">Pemohon ID</label>
                                    <asp:Label ID="lblModalPemohonID" runat="server" CssClass="modal-field-value"></asp:Label>
                                </div>
                            </div>
                            <div class="col-md-5 col-lg-6">
                                <div class="modal-field-group">
                                    <label class="modal-field-label">Nama Pemohon</label>
                                    <asp:Label ID="lblModalPemohonName" runat="server" CssClass="modal-field-value"></asp:Label>
                                </div>
                            </div>
                            <div class="col-md-4 col-lg-4">
                                <div class="modal-field-group">
                                    <label class="modal-field-label">No. Kad Pengenalan / Pasport</label>
                                    <asp:Label ID="lblModalPemohonIC" runat="server" CssClass="modal-field-value"></asp:Label>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="modal-field-group">
                                    <label class="modal-field-label">Warganegara</label>
                                    <asp:Label ID="lblModalPemohonNat" runat="server" CssClass="modal-field-value"></asp:Label>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="modal-field-group">
                                    <label class="modal-field-label">No. Telefon Bimbit</label>
                                    <asp:Label ID="lblModalPemohonMobile" runat="server" CssClass="modal-field-value"></asp:Label>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="modal-field-group">
                                    <label class="modal-field-label">Emel</label>
                                    <asp:Label ID="lblModalPemohonEmail" runat="server" CssClass="modal-field-value"></asp:Label>
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="modal-field-group">
                                    <label class="modal-field-label">Alamat</label>
                                    <asp:Label ID="lblModalPemohonAddress" runat="server" CssClass="modal-field-value modal-field-value-multiline"></asp:Label>
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="modal-field-group mb-0">
                                    <label class="modal-field-label">Catatan Pemohon</label>
                                    <asp:Label ID="lblModalPemohonRemarks" runat="server" CssClass="modal-field-value modal-field-value-multiline"></asp:Label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- SECTION 2: MAKLUMAT PERMOHONAN -->
                    <div class="card modal-details-card mb-2">
                        <div class="form-section-header mt-0">
                            <i class="bi bi-file-earmark-text"></i>
                            <span>Maklumat Permohonan</span>
                        </div>
                        <div class="row g-2">
                            <div class="col-md-4">
                                <div class="modal-field-group">
                                    <label class="modal-field-label">Tarikh Mohon</label>
                                    <asp:Label ID="lblModalTarikhMohon" runat="server" CssClass="modal-field-value"></asp:Label>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="modal-field-group">
                                    <label class="modal-field-label">No Rujukan Permohonan</label>
                                    <asp:Label ID="lblModalRujukanField" runat="server" CssClass="modal-field-value"></asp:Label>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="modal-field-group">
                                    <label class="modal-field-label">No Akaun Cukai Taksiran</label>
                                    <asp:Label ID="lblModalNoAkaunCukai" runat="server" CssClass="modal-field-value"></asp:Label>
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="modal-field-group mb-0">
                                    <label class="modal-field-label">Jenis Lesen / Permit Dipohon</label>
                                    <div class="tag-container mt-1">
                                        <asp:Literal ID="litModalJenisLesenBadges" runat="server"></asp:Literal>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- SECTION 3: PERNIAGAAN / PREMIS -->
                    <asp:Panel ID="pnlModalPerniagaan" runat="server" Visible="false">
                        <div class="card modal-details-card mb-2">
                            <div class="form-section-header mt-0">
                                <i class="bi bi-shop"></i>
                                <span>Maklumat Perniagaan / Premis</span>
                            </div>
                            <div class="row g-2">
                                <div class="col-md-6">
                                    <div class="modal-field-group">
                                        <label class="modal-field-label">Nama Syarikat</label>
                                        <asp:Label ID="lblModalNamaSyarikat" runat="server" CssClass="modal-field-value"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="modal-field-group">
                                        <label class="modal-field-label">No. Pendaftaran</label>
                                        <asp:Label ID="lblModalNoPendaftaran" runat="server" CssClass="modal-field-value"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="modal-field-group">
                                        <label class="modal-field-label">No. Akaun Perniagaan</label>
                                        <asp:Label ID="lblModalNoAkaun" runat="server" CssClass="modal-field-value"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="modal-field-group">
                                        <label class="modal-field-label">Alamat Premis</label>
                                        <asp:Label ID="lblModalAlamatPremis" runat="server" CssClass="modal-field-value modal-field-value-multiline"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="modal-field-group">
                                        <label class="modal-field-label">Jenis Perniagaan</label>
                                        <asp:Label ID="lblModalJenisPerniagaan" runat="server" CssClass="modal-field-value modal-field-value-multiline"></asp:Label>
                                    </div>
                                </div>
                            </div>

                            <!-- Sub-Panel: Tukar Pemilik -->
                            <asp:Panel ID="pnlModalTukarPemilik" runat="server" Visible="false">
                                <div class="row g-2 mt-1">
                                    <div class="col-md-12">
                                        <div class="modal-field-group">
                                            <label class="modal-field-label text-primary"><i class="bi bi-person-gear me-1"></i>Nama Pemilik Baru</label>
                                            <asp:Label ID="lblModalPemilikBaru" runat="server" CssClass="modal-field-value"></asp:Label>
                                        </div>
                                    </div>
                                </div>
                            </asp:Panel>

                            <!-- Sub-Panel: Tukar Alamat / Premis Tambahan -->
                            <asp:Panel ID="pnlModalTukarAlamat" runat="server" Visible="false">
                                <div class="row g-2 mt-1">
                                    <div class="col-md-12">
                                        <div class="modal-field-group">
                                            <label class="modal-field-label text-primary"><i class="bi bi-geo-alt me-1"></i>Alamat Premis Baru / Premis Tambahan</label>
                                            <asp:Label ID="lblModalAlamatBaru" runat="server" CssClass="modal-field-value modal-field-value-multiline"></asp:Label>
                                        </div>
                                    </div>
                                </div>
                            </asp:Panel>

                            <!-- Sub-Panel: Tambah Aktiviti Perniagaan -->
                            <asp:Panel ID="pnlModalTambahPerniagaan" runat="server" Visible="false">
                                <div class="row g-2 mt-1">
                                    <div class="col-md-12">
                                        <div class="modal-field-group">
                                            <label class="modal-field-label text-primary"><i class="bi bi-plus-circle me-1"></i>Jenis Perniagaan Baru (Tambahan)</label>
                                            <asp:Label ID="lblModalJenisPerniagaanBaru" runat="server" CssClass="modal-field-value modal-field-value-multiline"></asp:Label>
                                        </div>
                                    </div>
                                </div>
                            </asp:Panel>

                            <!-- Sub-Panel: Tukar Nama Syarikat -->
                            <asp:Panel ID="pnlModalTukarNama" runat="server" Visible="false">
                                <div class="row g-2 mt-1">
                                    <div class="col-md-12">
                                        <div class="modal-field-group">
                                            <label class="modal-field-label text-primary"><i class="bi bi-building me-1"></i>Nama Baru Syarikat</label>
                                            <asp:Label ID="lblModalNamaBaruSyarikat" runat="server" CssClass="modal-field-value"></asp:Label>
                                        </div>
                                    </div>
                                </div>
                            </asp:Panel>
                        </div>
                    </asp:Panel>

                    <!-- SECTION 4: PAPAN IKLAN -->
                    <asp:Panel ID="pnlModalIklan" runat="server" Visible="false">
                        <div class="card modal-details-card mb-2">
                            <div class="form-section-header mt-0">
                                <i class="bi bi-card-image"></i>
                                <span>Maklumat Papan Iklan</span>
                            </div>
                            <div class="table-responsive">
                                <asp:GridView ID="gvModalIklan" runat="server" AutoGenerateColumns="False" CssClass="table custom-gridview table-bordered align-middle">
                                    <Columns>
                                        <asp:TemplateField HeaderText="No.">
                                            <ItemTemplate><%# Container.DataItemIndex + 1 %></ItemTemplate>
                                            <HeaderStyle Width="6%" CssClass="text-center" />
                                            <ItemStyle CssClass="text-center" />
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="SaizIklan" HeaderText="Saiz Iklan (cm)" />
                                        <asp:BoundField DataField="Bercahaya" HeaderText="Bercahaya" HeaderStyle-CssClass="text-center" ItemStyle-CssClass="text-center" />
                                        <asp:BoundField DataField="Unit" HeaderText="Bilangan Unit" HeaderStyle-CssClass="text-center" ItemStyle-CssClass="text-center" />
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>
                    </asp:Panel>

                    <!-- SECTION 5: BILLBOARD -->
                    <asp:Panel ID="pnlModalBillboard" runat="server" Visible="false">
                        <div class="card modal-details-card mb-2">
                            <div class="form-section-header mt-0">
                                <i class="bi bi-badge-ad"></i>
                                <span>Maklumat Billboard</span>
                            </div>
                            <div class="row g-2">
                                <div class="col-12">
                                    <div class="modal-field-group mb-0">
                                        <label class="modal-field-label">Lokasi Billboard</label>
                                        <asp:Label ID="lblModalBillboardLokasi" runat="server" CssClass="modal-field-value modal-field-value-multiline"></asp:Label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </asp:Panel>

                    <!-- SECTION 6: PASAR -->
                    <asp:Panel ID="pnlModalPasar" runat="server" Visible="false">
                        <div class="card modal-details-card mb-2">
                            <div class="form-section-header mt-0">
                                <i class="bi bi-basket"></i>
                                <span>Maklumat Pasar</span>
                            </div>
                            <div class="row g-2">
                                <div class="col-md-4">
                                    <div class="modal-field-group">
                                        <label class="modal-field-label">Lokasi Pasar 1</label>
                                        <asp:Label ID="lblModalLokasiPasar1" runat="server" CssClass="modal-field-value"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="modal-field-group">
                                        <label class="modal-field-label">Lokasi Pasar 2</label>
                                        <asp:Label ID="lblModalLokasiPasar2" runat="server" CssClass="modal-field-value"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="modal-field-group">
                                        <label class="modal-field-label">Lokasi Pasar 3</label>
                                        <asp:Label ID="lblModalLokasiPasar3" runat="server" CssClass="modal-field-value"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="modal-field-group">
                                        <label class="modal-field-label">Jenis Pasar</label>
                                        <asp:Label ID="lblModalJenisPasar" runat="server" CssClass="modal-field-value"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="modal-field-group">
                                        <label class="modal-field-label">Jenis Perniagaan Pasar</label>
                                        <asp:Label ID="lblModalJenisPerniagaanPasar" runat="server" CssClass="modal-field-value"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="modal-field-group">
                                        <label class="modal-field-label">Jumlah Petak</label>
                                        <asp:Label ID="lblModalJumlahPetak" runat="server" CssClass="modal-field-value"></asp:Label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </asp:Panel>

                    <!-- SECTION 7: LESEN ANJING -->
                    <asp:Panel ID="pnlModalAnjing" runat="server" Visible="false">
                        <div class="card modal-details-card mb-2">
                            <div class="form-section-header mt-0">
                                <i class="bi bi-heart-pulse"></i>
                                <span>Maklumat Lesen Anjing</span>
                            </div>
                            <div class="row g-2 mb-3">
                                <div class="col-md-8">
                                    <div class="modal-field-group">
                                        <label class="modal-field-label">Alamat Premis / Lokasi Anjing</label>
                                        <asp:Label ID="lblModalAnjingAlamat" runat="server" CssClass="modal-field-value modal-field-value-multiline"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="modal-field-group">
                                        <label class="modal-field-label">Jenis Premis</label>
                                        <asp:Label ID="lblModalAnjingJenisPremis" runat="server" CssClass="modal-field-value"></asp:Label>
                                    </div>
                                </div>
                            </div>
                            <div class="table-responsive">
                                <asp:GridView ID="gvModalAnjing" runat="server" AutoGenerateColumns="False" CssClass="table custom-gridview table-bordered align-middle">
                                    <Columns>
                                        <asp:TemplateField HeaderText="No.">
                                            <ItemTemplate><%# Container.DataItemIndex + 1 %></ItemTemplate>
                                            <HeaderStyle Width="6%" CssClass="text-center" />
                                            <ItemStyle CssClass="text-center" />
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="Baka" HeaderText="Baka Anjing" />
                                        <asp:BoundField DataField="Jantan" HeaderText="Jantan" HeaderStyle-CssClass="text-center" ItemStyle-CssClass="text-center" />
                                        <asp:BoundField DataField="Betina" HeaderText="Betina" HeaderStyle-CssClass="text-center" ItemStyle-CssClass="text-center" />
                                        <asp:BoundField DataField="JantanMandul" HeaderText="Jantan Mandul" HeaderStyle-CssClass="text-center" ItemStyle-CssClass="text-center" />
                                        <asp:BoundField DataField="BetinaMandul" HeaderText="Betina Mandul" HeaderStyle-CssClass="text-center" ItemStyle-CssClass="text-center" />
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>
                    </asp:Panel>

                    <!-- SECTION 8: PENJAJA -->
                    <asp:Panel ID="pnlModalPenjaja" runat="server" Visible="false">
                        <div class="card modal-details-card mb-2">
                            <div class="form-section-header mt-0">
                                <i class="bi bi-person-walking"></i>
                                <span>Maklumat Penjaja</span>
                            </div>
                            <div class="row g-2">
                                <div class="col-md-4">
                                    <div class="modal-field-group">
                                        <label class="modal-field-label">Jenis Penjaja</label>
                                        <asp:Label ID="lblModalJenisPenjaja" runat="server" CssClass="modal-field-value"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="modal-field-group">
                                        <label class="modal-field-label">Status Tanah Penjaja</label>
                                        <asp:Label ID="lblModalStatusTanahPenjaja" runat="server" CssClass="modal-field-value"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="modal-field-group">
                                        <label class="modal-field-label">Jenis Perniagaan Penjaja</label>
                                        <asp:Label ID="lblModalJenisPerniagaanPenjaja" runat="server" CssClass="modal-field-value"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="modal-field-group">
                                        <label class="modal-field-label">Alamat / Lokasi Penjajaan</label>
                                        <asp:Label ID="lblModalAlamatPenjajaan" runat="server" CssClass="modal-field-value modal-field-value-multiline"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="modal-field-group">
                                        <label class="modal-field-label">Masa Operasi Penjaja</label>
                                        <asp:Label ID="lblModalMasaPenjaja" runat="server" CssClass="modal-field-value"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="modal-field-group">
                                        <label class="modal-field-label">Kenderaan Penjaja</label>
                                        <asp:Label ID="lblModalKenderaanPenjaja" runat="server" CssClass="modal-field-value"></asp:Label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </asp:Panel>

                    <!-- SECTION 9: EKSPO / PROGRAM -->
                    <asp:Panel ID="pnlModalEkspo" runat="server" Visible="false">
                        <div class="card modal-details-card mb-2">
                            <div class="form-section-header mt-0">
                                <i class="bi bi-calendar-event"></i>
                                <span>Maklumat Ekspo / Program</span>
                            </div>
                            <div class="row g-2">
                                <div class="col-md-4">
                                    <div class="modal-field-group">
                                        <label class="modal-field-label">Nama Ekspo / Program</label>
                                        <asp:Label ID="lblModalNamaEkspo" runat="server" CssClass="modal-field-value fw-bold"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="modal-field-group">
                                        <label class="modal-field-label">Penganjur</label>
                                        <asp:Label ID="lblModalPenganjurEkspo" runat="server" CssClass="modal-field-value"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="modal-field-group">
                                        <label class="modal-field-label">Lokasi Ekspo</label>
                                        <asp:Label ID="lblModalLokasiEkspo" runat="server" CssClass="modal-field-value"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="modal-field-group">
                                        <label class="modal-field-label">Alamat Penganjur</label>
                                        <asp:Label ID="lblModalAlamatPenganjurEkspo" runat="server" CssClass="modal-field-value modal-field-value-multiline"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="modal-field-group">
                                        <label class="modal-field-label">Nama PIC</label>
                                        <asp:Label ID="lblModalPicEkspo" runat="server" CssClass="modal-field-value"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="modal-field-group">
                                        <label class="modal-field-label">No. Telefon PIC</label>
                                        <asp:Label ID="lblModalNoTelEkspo" runat="server" CssClass="modal-field-value"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="modal-field-group">
                                        <label class="modal-field-label">Tarikh Program</label>
                                        <asp:Label ID="lblModalTarikhEkspo" runat="server" CssClass="modal-field-value"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="modal-field-group">
                                        <label class="modal-field-label">Masa Program</label>
                                        <asp:Label ID="lblModalMasaEkspo" runat="server" CssClass="modal-field-value"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="modal-field-group">
                                        <label class="modal-field-label">Tarikh Pasang / Buka Khemah</label>
                                        <asp:Label ID="lblModalTarikhKhemah" runat="server" CssClass="modal-field-value"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="modal-field-group">
                                        <label class="modal-field-label">Kategori Jemputan</label>
                                        <asp:Label ID="lblModalJemputanEkspo" runat="server" CssClass="modal-field-value"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="modal-field-group">
                                        <label class="modal-field-label">Tentatif Program</label>
                                        <asp:Label ID="lblModalTentatifEkspo" runat="server" CssClass="modal-field-value modal-field-value-multiline"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="modal-field-group">
                                        <label class="modal-field-label">Pelan Pembersihan</label>
                                        <asp:Label ID="lblModalPembersihanEkspo" runat="server" CssClass="modal-field-value modal-field-value-multiline"></asp:Label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </asp:Panel>


                    <!-- SECTION 12: PEMBATALAN -->
                    <asp:Panel ID="pnlModalBatal" runat="server" Visible="false">
                        <div class="card modal-details-card mb-2">
                            <div class="form-section-header danger-section mt-0">
                                <i class="bi bi-x-octagon"></i>
                                <span>Maklumat Pembatalan</span>
                            </div>
                            <div class="row g-2">
                                <div class="col-md-3">
                                    <div class="modal-field-group">
                                        <label class="modal-field-label">Jenis Pembatalan</label>
                                        <asp:Label ID="lblModalJenisBatal" runat="server" CssClass="modal-field-value text-danger fw-bold"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="modal-field-group">
                                        <label class="modal-field-label">Sebab Batal</label>
                                        <asp:Label ID="lblModalSebabBatal" runat="server" CssClass="modal-field-value"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="modal-field-group">
                                        <label class="modal-field-label">Tindakan</label>
                                        <asp:Label ID="lblModalTindakanBatal" runat="server" CssClass="modal-field-value"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="modal-field-group">
                                        <label class="modal-field-label">Tarikh Batal</label>
                                        <asp:Label ID="lblModalTarikhBatal" runat="server" CssClass="modal-field-value"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-12">
                                    <div class="modal-field-group mb-0">
                                        <label class="modal-field-label">Catatan Pembatalan</label>
                                        <asp:Label ID="lblModalRemarksBatal" runat="server" CssClass="modal-field-value modal-field-value-multiline"></asp:Label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </asp:Panel>

                </div>
                <div class="modal-footer bg-light py-2">
                    <button type="button" class="btn btn-secondary px-4 d-inline-flex align-items-center" data-bs-dismiss="modal">
                        <i class="bi bi-x-lg me-1"></i>Tutup
                    </button>
                </div>
            </div>
        </div>
    </div>

    <%-- ========================================================================= --%>
    <%-- SECTION 7: CLIENT SCRIPTS                                                 --%>
    <%-- ========================================================================= --%>
    <script>
        function showPermohonanModal() {
            var modalEl = document.getElementById('modalMaklumatPermohonan');
            if (modalEl) {
                if (typeof bootstrap !== 'undefined' && bootstrap.Modal) {
                    var modalObj = bootstrap.Modal.getOrCreateInstance(modalEl);
                    modalObj.show();
                } else if (typeof $ !== 'undefined' && $.fn.modal) {
                    $('#modalMaklumatPermohonan').modal('show');
                }
            }
        }

        function pageLoad() {
            $(function () {
                // Initialize Select2 Elements
                $('.select2').select2();
                $('.select2bs4').select2({
                    theme: 'bootstrap4'
                });

                // Initialize Datepicker
                $('.datepicker').datepicker({
                    dateFormat: 'dd/mm/yy',
                    defaultDate: new Date()
                });

                // Input Masks
                $('#datemask').inputmask('dd/mm/yyyy', { 'placeholder': 'dd/mm/yyyy' });
                $('#datemask2').inputmask('mm/dd/yyyy', { 'placeholder': 'mm/dd/yyyy' });
                $('[data-mask]').inputmask();
            });
        }
    </script>

</asp:Content>
