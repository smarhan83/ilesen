<%@ Page MaintainScrollPositionOnPostback="true" Title="" Language="VB" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="pembatalan1.aspx.vb" Inherits="pembatalan1" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadContent" runat="Server">

    <style>
        .highlighted {
            background-color: #f8d7d7;
        }

        .paraGraphtext {
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            width: 150px;
        }

        .csslblUlasan {
            /*background-color : #ffffff !important;*/
            font-weight: normal !important;
        }
       
        /*NEW LAYOUT*/
.page-layout {
    display: grid;
    grid-template-columns: 1fr 340px;
    gap: 20px;
    align-items: start;
}

@media (max-width: 992px) {
    .page-layout {
        grid-template-columns: 1fr;
    }
}

/* ===== Info Card (Maklumat Permohonan + Alamat) ===== */
.info-card {
    background: #fff;
    border: 1px solid #e9ecef;
    border-radius: 10px;
    padding: 20px;
    margin-bottom: 20px;
}

.info-card-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    flex-wrap: wrap;
    gap: 15px;
    padding-bottom: 18px;
    margin-bottom: 18px;
    border-bottom: 1px solid #e9ecef;
}

.info-card-header-left {
    display: flex;
    align-items: center;
    gap: 15px;
}

.info-avatar {
    width: 56px;
    height: 56px;
    border-radius: 50%;
    background: #E4DFFB;
    color: #6C5CE7;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 24px;
    flex-shrink: 0;
}

.info-card-header-left h4 {
    margin: 0 0 4px 0;
    font-weight: 700;
    font-size: 16pt;
    color: #212529;
}

.info-card-header-left .sub-text {
    color: #6c757d;
    font-size: 9.5pt;
    margin-bottom: 2px;
}

.info-card-header-right {
    text-align: right;
}

.info-card-header-right .label {
    color: #6c757d;
    font-size: 8.5pt;
    display: flex;
    align-items: center;
    gap: 5px;
    justify-content: flex-end;
    margin-bottom: 2px;
}

.info-card-header-right .value {
    font-weight: 600;
    font-size: 10pt;
    color: #212529;
}

.badge-status-pill {
    display: inline-block;
    padding: 4px 14px;
    border-radius: 20px;
    font-size: 8.5pt;
    font-weight: 700;
    background: #FFF3CD;
    color: #B8860B;
}

.section-title {
    font-size: 9pt;
    font-weight: 700;
    letter-spacing: 0.5px;
    color: #2E3192;
    text-transform: uppercase;
    margin-bottom: 15px;
}

.info-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 20px 30px;
}

.info-item {
    display: flex;
    align-items: flex-start;
    gap: 12px;
}

.info-item i {
    color: #adb5bd;
    font-size: 15pt;
    margin-top: 2px;
}

.info-item .info-label {
    color: #6c757d;
    font-size: 8.5pt;
    margin-bottom: 2px;
}

.info-item .info-value {
    font-weight: 600;
    color: #212529;
    font-size: 10pt;
}

.address-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 20px;
}

.address-card {
    border: 1px solid #e9ecef;
    border-radius: 10px;
    padding: 15px 18px;
    display: flex;
    gap: 12px;
}

.address-card i {
    color: #adb5bd;
    font-size: 15pt;
    margin-top: 2px;
}

.address-card .addr-label {
    color: #6c757d;
    font-size: 8.5pt;
    margin-bottom: 4px;
}

.address-card .addr-value {
    font-weight: 600;
    font-size: 9.5pt;
    color: #212529;
    line-height: 1.5;
}

/* ===== Sejarah Ulasan (timeline horizontal list) ===== */
.sejarah-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 15px;
}

.sejarah-item {
    display: flex;
    gap: 15px;
    padding-bottom: 18px;
}

.sejarah-icon {
    width: 34px;
    height: 34px;
    border-radius: 50%;
    background: #E4DFFB;
    color: #6C5CE7;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 14px;
    flex-shrink: 0;
}

.sejarah-icon.success {
    background: #D4EDDA;
    color: #28a745;
}

.sejarah-date {
    font-size: 8pt;
    color: #6c757d;
    white-space: nowrap;
    min-width: 90px;
}

.sejarah-body {
    flex: 1;
}

.sejarah-body .row-top {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-bottom: 3px;
}

.sejarah-body .actor {
    font-weight: 700;
    font-size: 9.5pt;
    color: #212529;
}

.badge-mini {
    font-size: 7.5pt;
    font-weight: 700;
    padding: 2px 10px;
    border-radius: 20px;
    background: #D4EDDA;
    color: #28a745;
}

.badge-mini.blue {
    background: #DCE7FB;
    color: #2E6FD9;
}

.sejarah-body .desc {
    font-size: 8.5pt;
    color: #6c757d;
}

/* ===== Sidebar: Status Proses ===== */
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

/* ===== Sidebar: Lampiran Permohonan ===== */
.lampiran-card {
    background: #fff;
    border: 1px solid #e9ecef;
    border-radius: 10px;
    padding: 20px;
}

.lampiran-item {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 10px 0;
    border-bottom: 1px solid #f1f3f5;
}

.lampiran-item:last-of-type {
    border-bottom: none;
}

.lampiran-icon {
    width: 34px;
    height: 34px;
    border-radius: 8px;
    background: #FDEBEC;
    color: #E74C3C;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 15px;
    flex-shrink: 0;
}

.lampiran-name {
    flex: 1;
    font-size: 9pt;
    font-weight: 500;
    color: #212529;
}

.lampiran-download {
    color: #6c757d;
    font-size: 14px;
    text-decoration: none;
}

.lampiran-download:hover {
    color: #2E3192;
}

.btn-lihat-semua {
    width: 100%;
    margin-top: 12px;
    padding: 10px;
    border-radius: 8px;
    border: 1px solid #2E3192;
    background: #fff;
    color: #2E3192;
    font-weight: 600;
    font-size: 9pt;
    text-align: center;
    display: block;
    text-decoration: none;
}

.btn-lihat-semua:hover {
    background: #2E3192;
    color: #fff;
}

/* ===== Ulasan / Catatan + action buttons bawah ===== */
.ulasan-footer-card {
    background: #fff;
    border: 1px solid #e9ecef;
    border-radius: 10px;
    padding: 20px;
    margin-top: 20px;
    width : 100%;
}

.ulasan-footer-card textarea {
    width: 100%;
    border: 1px solid #e9ecef;
    border-radius: 8px;
    padding: 12px;
    font-size: 9.5pt;
    min-height: 90px;
    resize: vertical;
}

.ulasan-footer-card,
.ulasan-footer-card textarea,
.ulasan-footer-card * {
    box-sizing: border-box;
}

.ulasan-char-count {
    font-size: 8pt;
    color: #adb5bd;
    margin-top: 5px;
}

.ulasan-actions {
    display: flex;
    justify-content: flex-end;
    gap: 12px;
    margin-top: 18px;
    flex-wrap: wrap;
}

.ulasan-actions .btn-action {
    padding: 10px 20px;
    border-radius: 8px;
    font-weight: 600;
    font-size: 9pt;
    border: none;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 2px;
    min-width: 140px;
    text-align: center;
    cursor: pointer;
}

.ulasan-actions .btn-action small {
    font-weight: 400;
    font-size: 7.5pt;
    opacity: 0.85;
}

.btn-kembalikan {
    background: #fff;
    color: #E74C3C;
    border: 1px solid #F5C6CB !important;
}

.btn-simpan {
    background: #fff;
    color: #212529;
    border: 1px solid #dee2e6 !important;
}

.btn-luluskan {
    background: #2E3192;
    color: #fff;
}

.address-card .form-control-plain {
    border: none !important;
    background: transparent !important;
    padding: 0 !important;
    font-weight: 600;
    font-size: 9.5pt;
    color: #212529;
    resize: none;
    box-shadow: none !important;
    width: 100%;
}

.address-card .form-control-plain:focus {
    outline: none;
    box-shadow: none !important;
}
        /*END NEW LAYOUT*/

        /*LAMPIRAN*/

.lampiran-card {
    background: #fff;
    border: 1px solid #e9ecef;
    border-radius: 10px;
    padding: 20px;
}

.lampiran-card .lampiran-gridview {
    width: 100%;
    border-collapse: collapse;
    border: none !important;
}

.lampiran-card .lampiran-gridview tr {
    border: none !important;
}

.lampiran-card .lampiran-gridview td {
    border: none !important;
    padding: 0 !important;
}

.lampiran-item {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 10px 0;
    border-bottom: 1px solid #f1f3f5;
}

.lampiran-card .lampiran-gridview tr:last-child .lampiran-item {
    border-bottom: none;
}

.lampiran-icon {
    width: 34px;
    height: 34px;
    border-radius: 8px;
    background: #FDEBEC;
    color: #E74C3C;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 15px;
    flex-shrink: 0;
}

.lampiran-name {
    flex: 1;
    font-size: 9pt;
    font-weight: 500;
    color: #212529;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.lampiran-download {
    color: #6c757d;
    font-size: 14px;
    text-decoration: none;
    flex-shrink: 0;
}

.lampiran-download:hover {
    color: #2E3192;
}

.lampiran-empty {
    text-align: center;
    color: #adb5bd;
    font-size: 9pt;
    padding: 20px 0;
}
        /*END OF LAMPIRAN*/

        /*ULASAN*/

.nota-card {
    background: #fff;
    border: 1px solid #e9ecef;
    border-radius: 10px;
    padding: 20px;
    margin-top: 20px;
}

.nota-block {
    margin-bottom: 20px;
}

.nota-block:last-child {
    margin-bottom: 0;
}

.nota-label-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 10px;
    margin-bottom: 10px;
}

.nota-label {
    font-size: 9pt;
    font-weight: 700;
    letter-spacing: 0.3px;
    color: #2E3192;
    text-transform: uppercase;
    margin: 0;
}

.nota-signoff {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 9pt;
}

.nota-signoff .actor-name {
    font-weight: 600;
    color: #212529;
}

.nota-signoff .status-pill {
    font-size: 8pt;
    font-weight: 700;
    padding: 3px 12px;
    border-radius: 20px;
}

.nota-signoff .status-pill.support {
    background: #D4EDDA;
    color: #28a745;
}

.nota-signoff .status-pill.reject {
    background: #FDEBEC;
    color: #E74C3C;
}

.nota-card textarea.form-control {
    width: 100%;
    box-sizing: border-box;
    border: 1px solid #e9ecef;
    border-radius: 8px;
    padding: 12px;
    font-size: 9.5pt;
    resize: vertical;
}

.nota-kelulusan-options {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
}

.nota-kelulusan-options table {
    border-collapse: collapse;
    width: 100%;
}

.nota-kelulusan-options td {
    padding: 0 !important;
}

.nota-kelulusan-options input[type="radio"] {
    display: none;
}

.nota-kelulusan-options label {
    display: inline-block;
    padding: 8px 16px;
    border: 1px solid #dee2e6;
    border-radius: 20px;
    font-size: 8.5pt;
    font-weight: 600;
    color: #495057;
    cursor: pointer;
    margin: 4px 6px 4px 0;
    transition: all 0.15s ease-in-out;
}

        .nota-kelulusan-options input[type="radio"]:checked + label {
            background: #2E3192;
            color : #ffffff;
        }


.agensi-ulasan-card {
    background: #F7F6FE;
    border: 1px solid #E9ECEF;
    border-radius: 10px;
    padding: 18px;
}

.agensi-ulasan-item {
    padding-bottom: 16px;
    margin-bottom: 16px;
    border-bottom: 1px solid #E0DCF5;
}

.agensi-ulasan-item:last-child {
    border-bottom: none;
    margin-bottom: 0;
    padding-bottom: 0;
}

.agensi-ulasan-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 8px;
    margin-bottom: 8px;
}

.agensi-ulasan-name {
    font-weight: 700;
    font-size: 9.5pt;
    color: #212529;
}

.agensi-ulasan-header .btn-lihat-surat {
    padding: 4px 12px;
    font-size: 8pt;
    border-radius: 20px;
    background: #fff;
    border: 1px solid #dee2e6;
    color: #495057;
    font-weight: 600;
    text-decoration: none;
}

.agensi-ulasan-header .btn-lihat-surat:hover {
    border-color: #2E3192;
    color: #2E3192;
}

.agensi-pengesah-row {
    display: flex;
    align-items: center;
    gap: 8px;
    flex-wrap: wrap;
    font-size: 8.5pt;
    color: #495057;
    margin-bottom: 6px;
}

.agensi-pengesah-row b {
    color: #212529;
}

.status-pill-sm {
    font-size: 7.5pt;
    font-weight: 700;
    padding: 2px 10px;
    border-radius: 20px;
    display: inline-block;
}

.status-pill-sm.pending {
    background: #FFF3CD;
    color: #B8860B;
}

.status-pill-sm.support {
    background: #D4EDDA;
    color: #28a745;
}

.status-pill-sm.reject {
    background: #FDEBEC;
    color: #E74C3C;
}

.agensi-nota-text {
    font-size: 8.5pt;
    color: #6c757d;
    line-height: 1.5;
}
        /*END ULASAN*/


        .styleDisplayNone {
            display: none;
        }

        .table-bordered {
            text-align: center;
        }
    </style>

<style>
    .info-notice {
        display: flex;
        align-items: flex-start;
        gap: 12px;
        background: #fef2f2;
        border: 1px solid #e0e7ff;
        border-radius: 8px;
        padding: 14px 16px;
        margin-bottom: 16px;
    }

    .info-notice-icon {
        flex-shrink: 0;
        width: 22px;
        height: 22px;
        border-radius: 50%;
        background: #4338ca;
        color: #fff;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 12px;
        margin-top: 2px;
    }

    .info-notice-content {
        flex: 1;
    }

    .info-notice-title {
        font-weight: 700;
        color: #3730a3;
        font-size: 14px;
        margin-bottom: 2px;
    }

    .info-notice-desc {
        font-size: 13px;
        color: #4338ca;
        line-height: 1.5;
        margin-bottom: 10px;
    }

    /* GridView list dalam info box */
    .kik-gridview {
        width: 100%;
    }

    .kik-item {
        align-items: flex-start;
        background: #fff;
        border: 1px solid #e0e7ff;
        border-radius: 6px;
        padding: 10px 12px;
        margin-bottom: 8px;
    }

    .kik-item:last-child {
        margin-bottom: 0;
    }

    .kik-item-content {
        flex: 1;
        display: flex;
        flex-direction: column;
        gap: 4px;
    }

    .kik-item-catatan {
        font-size: 13px;
        color: #333;
        line-height: 1.4;
    }

    .kik-item-meta {
        font-size: 11px;
        color: #999;
    }
</style>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">

    <section class="content-header">
        <div class="container-fluid">

            <asp:Label ID="lblDummy" runat="server" Text=""></asp:Label>

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

    <!-- Main content -->
    <section class="content">
        <div class="container-fluid">

            <asp:Panel ID="pnlInfoNoticeKembaliIK" runat="server" CssClass="info-notice">

                <div class="info-notice-icon">
                    <i class="bi bi-info-lg"></i>
                </div>
                <div class="info-notice-content">
                    <div class="info-notice-title">Maklumat</div>
                    <div class="info-notice-desc">
                        Catatan Lawatan Tapak Sekali Lagi.
                    </div>

                    <asp:GridView ID="GridView3" runat="server"
                        ShowHeaderWhenEmpty="False"
                        ShowHeader="False"
                        AutoGenerateColumns="False"
                        DataKeyNames="ID"
                        DataSourceID="SqlDataSourceKembaliIK"
                        CssClass="lampiran-gridview kik-gridview"
                        GridLines="None"
                        OnDataBound="GridView3_DataBound">
                        <Columns>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <div class="lampiran-item kik-item">
                                        <div class="lampiran-icon"><i class="bi bi-arrow-return-left"></i></div>
                                        <div class="kik-item-content">
                                            <div class="kik-item-catatan">
                                                <%# Eval("Catatan") %>
                                            </div>
                                            <div class="kik-item-meta">
                                                <%# Eval("CreatedBy") %> &middot; 
                                                <%# CType(Eval("CreatedDt"), DateTime).ToString("dd/MM/yyyy hh:mm tt") %>
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>

                </div>
            </asp:Panel>

        <asp:SqlDataSource ID="SqlDataSourceKembaliIK" runat="server"
            ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
            SelectCommand="SELECT ID, Permohonan_ID, Catatan, CreatedBy, CreatedDt 
                            FROM LESEN_KembaliIK 
                            WHERE Permohonan_ID = @Permohonan_ID 
                            ORDER BY CreatedDt DESC">
            <SelectParameters>
                <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[0]" Name="Permohonan_ID"></asp:ControlParameter>
                
            </SelectParameters>
        </asp:SqlDataSource>

            <asp:FormView ID="FormView1" runat="server" DataKeyNames="JenisLesen_ID"
                DataSourceID="SqlDataSourceForm" DefaultMode="Edit" Width="100%" CssClass="CustomTab">
                <EditItemTemplate>

                <div class="page-layout">

                <!-- ===== KIRI: content utama ===== -->
                <div>

                <!-- Maklumat Permohonan + Alamat -->
                <div class="info-card">

                    <div class="info-card-header">
                        <div class="info-card-header-left">
                            <div class="info-avatar"><i class="bi bi-person-fill"></i></div>
                            <div>
                                <h4><asp:Label ID="Label1" runat="server" Text='<%# Eval("Pemohon_Name") %>'></asp:Label></h4>
                                <div class="sub-text"><asp:Label ID="Label3" runat="server" Text='<%# Bind("JenisLesenDescList") %>'></asp:Label></div>
                                <div class="sub-text">No. Fail : <asp:Label ID="Label26" runat="server" Text='<%# Eval("Rujukan") %>'></asp:Label></div>
                            </div>
                        </div>
                        <div class="info-card-header-right">
                            <div class="label"><i class="bi bi-calendar3"></i> Tarikh Mohon</div>
                            <div class="value"><asp:Label ID="Label2" runat="server" Text='<%# Eval("TarikhMohon", "{0:dd MMM yyyy}") %>'></asp:Label></div>
                            <br />
                            <div class="label" style="margin-top:8px;">Status Semasa</div>
                            <span class="badge-status-pill"><asp:Label ID="Label5" runat="server" Text='<%# Eval("Description") %>'></asp:Label></span>
                        </div>
                    </div>

                    <div runat="server" id="idWindowTitle2" style="display:none;">Maklumat</div>

                    <div class="section-title">Maklumat Permohonan</div>
                    <div class="info-grid">

                        <div class="info-item">
                            <i class="bi bi-person"></i>
                            <div>
                                <div class="info-label">Nama Pemohon</div>
                                <div class="info-value"><asp:Label ID="Label1b" runat="server" Text='<%# Eval("Pemohon_Name") %>'></asp:Label></div>
                            </div>
                        </div>

                        <div class="info-item">
                            <i class="bi bi-building"></i>
                            <div>
                                <div class="info-label">Nama Syarikat</div>
                                <div class="info-value"><asp:Label ID="Label145" runat="server" Text='<%# Eval("NamaSyarikat") %>'></asp:Label></div>
                            </div>
                        </div>

                        <div class="info-item">
                            <i class="bi bi-calendar3"></i>
                            <div>
                                <div class="info-label">Tarikh Mohon</div>
                                <div class="info-value"><asp:Label ID="Label2b" runat="server" Text='<%# Eval("TarikhMohon", "{0:dd MMM yyyy}") %>'></asp:Label></div>
                            </div>
                        </div>

                        <div class="info-item">
                            <i class="bi bi-file-earmark-text"></i>
                            <div>
                                <div class="info-label">Jenis Lesen</div>
                                <div class="info-value"><asp:Label ID="Label3b" runat="server" Text='<%# Bind("JenisLesenDescList") %>'></asp:Label></div>
                            </div>
                        </div>

                        <div class="info-item">
                            <i class="bi bi-person-badge"></i>
                            <div>
                                <div class="info-label">Jenis Perniagaan</div>
                                <div class="info-value"><asp:Label ID="Label22" runat="server" Text='<%# Bind("JenisPerniagaan") %>'></asp:Label></div>
                            </div>
                        </div>

                        <div class="info-item">
                            <i class="bi bi-telephone"></i>
                            <div>
                                <div class="info-label">No. Tel. Pemohon</div>
                                <div class="info-value"><asp:Label ID="Label27" runat="server" Text='<%# Eval("Pemohon_MobileNo") %>'></asp:Label></div>
                            </div>
                        </div>

                        <div class="info-item">
                            <i class="bi bi-file-earmark"></i>
                            <div>
                                <div class="info-label">No. Fail</div>
                                <div class="info-value"><asp:Label ID="Label26b" runat="server" Text='<%# Eval("Rujukan") %>'></asp:Label></div>
                            </div>
                        </div>

                        <div class="info-item">
                            <i class="bi bi-diagram-3"></i>
                            <div>
                                <div class="info-label">Jabatan/Agensi</div>
                                <div class="info-value"><asp:Label ID="Label4" runat="server" Text='<%# Bind("JabatanAgensi_Description") %>'></asp:Label></div>
                            </div>
                        </div>

                    </div>

                    <hr style="margin: 20px 0; border-color: #e9ecef;" />

                    <div class="section-title">Alamat</div>
                    <div class="address-grid">

                        <div class="address-card">
                            <i class="bi bi-geo-alt"></i>
                            <div style="flex:1;">
                                <div class="addr-label">Alamat Pemohon</div>
                                <asp:TextBox ID="txtAlamatPemohon" runat="server" Text='<%# Eval("Pemohon_Address") %>' CssClass="form-control-plain" TextMode="MultiLine" Rows="4" Enabled="false"></asp:TextBox>
                            </div>
                        </div>

                        <div class="address-card">
                            <i class="bi bi-geo-alt-fill"></i>
                            <div style="flex:1;">
                                <div class="addr-label">Alamat Lokasi</div>
                                <asp:TextBox ID="TextBox1" runat="server" Text='<%# Eval("AlamatPremis") %>' CssClass="form-control-plain" TextMode="MultiLine" Rows="4" Enabled="false"></asp:TextBox>
                            </div>
                        </div>

                    </div>

                    <!-- Lihat Maklumat Permohonan (kekalkan logic visibility asal) -->
                    <div runat="server" visible='<%# If(IsDBNull(Eval("JabatanAgensi_IsLesen")), "true", If(Eval("JabatanAgensi_IsLesen") = "1", "true", "false")) %>' style="margin-top: 15px;">
                        <asp:HyperLink ID="HyperLink1" runat="server"
                            CssClass="btn btn-primary btn-sm"
                            NavigateUrl='<%# "~/lesen/appregister.aspx?p_Id=3348&m_Id=3349&pid=" + Eval("Permohonan_ID").ToString() %>'
                            Target="_blank">Lihat Maklumat Permohonan</asp:HyperLink>
                    </div>

                </div>        

                <!-- Sejarah Ulasan -->
                <%--<div class="info-card">
                    <div class="sejarah-header">
                        <div class="section-title" style="margin-bottom:0;">Sejarah Ulasan</div>
                        <a href="#" style="font-size: 8.5pt; color:#2E3192; font-weight:600; text-decoration:none;">Lihat Sejarah Penuh <i class="bi bi-chevron-right"></i></a>
                    </div>

                    <div class="sejarah-item">
                        <div class="sejarah-icon success"><i class="bi bi-eye"></i></div>
                        <div class="sejarah-date">10 Jul 2026<br />10:15 AM</div>
                        <div class="sejarah-body">
                            <div class="row-top">
                                <span class="actor">Ketua Bahagian Pelesenan</span>
                                <span class="badge-mini blue">DISEMAK</span>
                            </div>
                            <div class="desc">Surat telah disemak.</div>
                        </div>
                    </div>

                    <div class="sejarah-item">
                        <div class="sejarah-icon"><i class="bi bi-send"></i></div>
                        <div class="sejarah-date">09 Jul 2026<br />03:20 PM</div>
                        <div class="sejarah-body">
                            <div class="row-top">
                                <span class="actor">Kerani Pelesenan</span>
                                <span class="badge-mini">DIHANTAR</span>
                            </div>
                            <div class="desc">Surat telah dikemas kini dan dihantar untuk ulasan.</div>
                        </div>
                    </div>

                    <div class="sejarah-item">
                        <div class="sejarah-icon"><i class="bi bi-send"></i></div>
                        <div class="sejarah-date">08 Jul 2026<br />09:05 AM</div>
                        <div class="sejarah-body">
                            <div class="row-top">
                                <span class="actor">Kerani Pelesenan</span>
                                <span class="badge-mini">DIHANTAR</span>
                            </div>
                            <div class="desc">Permohonan dihantar untuk ulasan.</div>
                        </div>
                    </div>
                </div>--%>

                </div>  
                    
                <!-- ===== KANAN: sidebar ===== -->
                <div>

                    <!-- Status Proses -->
<%--                    <div class="status-proses-card">
                        <div class="status-proses-title">Status Proses</div>
                        <div class="status-timeline">

                            <div class="status-step done">
                                <div class="status-step-icon"><i class="bi bi-check-lg"></i></div>
                                <div class="status-step-title">Permohonan Direkod</div>
                                <div class="status-step-date">08 Jul 2026 09:05 AM</div>
                            </div>

                            <div class="status-step done">
                                <div class="status-step-icon"><i class="bi bi-check-lg"></i></div>
                                <div class="status-step-title">Surat Mohon Ulasan Dihantar</div>
                                <div class="status-step-date">09 Jul 2026 03:20 PM</div>
                            </div>

                            <div class="status-step done">
                                <div class="status-step-icon"><i class="bi bi-check-lg"></i></div>
                                <div class="status-step-title">Surat Mohon Ulasan Disemak (KB)</div>
                                <div class="status-step-date">10 Jul 2026 10:15 AM</div>
                            </div>

                            <div class="status-step current">
                                <div class="status-step-icon"><i class="bi bi-circle-fill" style="font-size:8px;"></i></div>
                                <div class="status-step-title">Semakan KB Pelesenan</div>
                                <div class="status-step-date">Menunggu tindakan</div>
                            </div>

                            <div class="status-step pending">
                                <div class="status-step-icon"></div>
                                <div class="status-step-title">Kelulusan KJ Pelesenan</div>
                                <div class="status-step-date">Belum selesai</div>
                            </div>

                            <div class="status-step pending">
                                <div class="status-step-icon"></div>
                                <div class="status-step-title">Kelulusan Lesen</div>
                                <div class="status-step-date">Belum selesai</div>
                            </div>

                        </div>
                    </div>--%>
                    <div class="status-proses-card">
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
                     If(Eval("StepStatus").ToString() = "current", "Menunggu tindakan", Eval("ApprovalDate", "{0:dd MMM yyyy hh:mm tt}"))) %>
            </div>

            <div class="status-step-actionby" runat="server" visible='<%# Eval("StepStatus").ToString() = "done" AndAlso Not IsDBNull(Eval("ActionBy")) AndAlso Eval("ActionBy").ToString() <> "" %>'>
                <i class="bi bi-person"></i> <%# Eval("ActionBy") %>
            </div>
        </div>
    </ItemTemplate>
</asp:Repeater>

                        </div>
                    </div>

                    <asp:SqlDataSource runat="server" ID="SqlDataSourceLogKelulusan" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                        SelectCommand="WITH StepDef AS (
    SELECT StepGroup, ApprStatusID, SortOrder, PendingLabel FROM (VALUES
        (1, 1, 1, 'Permohonan Baru'),
        (2, 2, 2, 'Pilih Pegawai Lawatan Tapak Jabatan/Agensi'),
        (3, 3, 3, 'Lawatan Tapak Jabatan/Agensi'),
        (4, 4, 4, 'Pengesah Jabatan/Agensi'),
        (5, 5, 5, 'Pengesah Jabatan Lesen'),
        (6, 6, 6, 'Menunggu Pengesahan'),
        (6, 7, 6, 'Menunggu Pengesahan'),
        (7, 8, 7, 'Peraku Jabatan Lesen'),
        (8, 9, 8, 'Kelulusan Peraku'),
        (8, 10, 8, 'Kelulusan Peraku')
    ) AS x(StepGroup, ApprStatusID, SortOrder, PendingLabel)
),
Actual AS (
    SELECT 
        d.StepGroup, d.SortOrder, d.ApprStatusID, d.PendingLabel,
        a.ApprovalDate, a.ApprovalID, c.JabatanAgensi_Description,
        b.Description,
        (CASE WHEN d.ApprStatusID = 3 THEN 
            (SELECT STRING_AGG(d1.Users_Fullname, ', ') FROM LESEN_PermohonanAgensiStaff a1 
             INNER JOIN LESEN_PermohonanAgensi b1 ON b1.Permohonan_ID = @Permohonan_ID and b1.PermohonanAgensi_ID = a1.PermohonanAgensi_ID
             INNER JOIN TBL_USERS d1 ON d1.Users_Id = a1.PermohonanAgensiStaffID_UsersID)
         WHEN d.ApprStatusID = 1 THEN f.Users_Fullname 
         ELSE dd.Users_Fullname END) AS ActionBy
    FROM StepDef d
    INNER JOIN ApprovalStatusBatal b ON b.ApprStatusID = d.ApprStatusID
    LEFT JOIN LESEN_ApprovalListBatal a 
        ON a.ApprStatusID = d.ApprStatusID 
        AND a.Permohonan_ID = @Permohonan_ID 
        AND a.ApprovalDate IS NOT NULL
    LEFT JOIN LESEN_JabatanAgensi c ON c.JabatanAgensi_ID = a.AgensiID
    LEFT JOIN TBL_USERS dd ON dd.Users_Id = a.ApproverID
    LEFT JOIN LESEN_Permohonan e ON e.Permohonan_ID = @Permohonan_ID
    LEFT JOIN TBL_USERS f ON f.Users_Name = e.CreatorID
),
Picked AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY StepGroup 
            ORDER BY CASE WHEN ApprovalDate IS NOT NULL THEN 0 ELSE 1 END, ApprStatusID
        ) AS rn
    FROM Actual
),
Result AS (
    SELECT StepGroup, SortOrder, 
           CASE WHEN ApprovalDate IS NOT NULL THEN ApprStatusID ELSE NULL END AS ApprStatusID,
           CASE WHEN ApprovalDate IS NOT NULL THEN Description ELSE PendingLabel END AS Description,
           ApprovalDate, ApprovalID, 
           JabatanAgensi_Description, ActionBy,
        CASE 
            WHEN ApprovalDate IS NOT NULL THEN 'done'
            WHEN SortOrder = (SELECT MIN(SortOrder) FROM Picked WHERE rn = 1 AND ApprovalDate IS NULL) THEN 'current'
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

                    <!-- Lampiran Permohonan -->
                        <div class="lampiran-card">
                            <div class="section-title">Lampiran Permohonan</div>

                            <asp:GridView ID="GridView2" runat="server"
                                ShowHeaderWhenEmpty="False"
                                ShowHeader="False"
                                AutoGenerateColumns="False"
                                DataKeyNames="PermohonanFail_ID"
                                DataSourceID="SqlDataSourceTabLampiran"
                                CssClass="lampiran-gridview"
                                GridLines="None"
                                EmptyDataText="Tiada lampiran direkodkan.">

                                <Columns>

                                    <asp:TemplateField>
                                        <ItemTemplate>

                                            <asp:HiddenField ID="hdnFldPermohonanFail_FileName" Value='<%# Bind("PermohonanFail_FileName") %>' runat="server" />
                                            <asp:HiddenField ID="hdnFldPermohonanFail_ContentType" Value='<%# Bind("PermohonanFail_ContentType") %>' runat="server" />
                                            <asp:HiddenField ID="hdnFldPermohonanFail_FilePath" Value='<%# Bind("PermohonanFail_FilePath") %>' runat="server" />

                                            <div class="lampiran-item">
                                                <div class="lampiran-icon"><i class="bi bi-file-earmark-pdf"></i></div>
                                                <div class="lampiran-name" title='<%# Eval("PermohonanFail_FileName") %>'>
                                                    <%# If(Len(Eval("PermohonanFail_Remarks").ToString()) > 0, Eval("PermohonanFail_Remarks"), Eval("PermohonanFail_FileName")) %>
                                                </div>
                                                <asp:HyperLink ID="hpFile" runat="server"
                                                    CssClass="lampiran-download"
                                                    NavigateUrl='<%# Eval("PermohonanFail_FilePath") %>'
                                                    Target="_blank">
                                                    <i class="bi bi-download"></i>
                                                </asp:HyperLink>
                                            </div>

                                        </ItemTemplate>
                                    </asp:TemplateField>

                                </Columns>

                                <EmptyDataRowStyle CssClass="lampiran-empty" />

                            </asp:GridView>

                        </div>

						<asp:SqlDataSource ID="SqlDataSourceTabLampiran" runat="server"
							ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
							SelectCommand=" SELECT a.*, b.StatusID FROM LESEN_PermohonanFail a INNER JOIN LESEN_Permohonan b ON a.PermohonanFail_PermohonanID = b.Permohonan_ID 
							WHERE a.PermohonanFail_JenisLampiran = 'U' AND a.PermohonanFail_PermohonanID = @Permohonan_ID"
							DeleteCommand=""
							UpdateCommand="">
							<DeleteParameters>
								
							</DeleteParameters>
							<SelectParameters>
								<asp:ControlParameter ControlID="GridView1" Name="Permohonan_ID" PropertyName="SelectedDataKey.Values[0]"></asp:ControlParameter>
							</SelectParameters>
							<UpdateParameters>
				   
							</UpdateParameters>
						</asp:SqlDataSource>                    

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
                SelectCommand="SELECT g.NamaSyarikat,a.*,d.*,e.*,f.*,g.JenisPerniagaan,g.Rujukan,
                ISNULL(g.AlamatBaru,ISNULL(g.AlamatPremis,ISNULL(g.AlamatPenjajaan,ISNULL(g.AnjingAlamat,isnull(g.LokasiPasar1,ISNULL(g.LokasiPasar2,ISNULL(g.LokasiPasar3,''))))))) as AlamatPremis 
				FROM 
                v_LESEN_ApprovalListBatal_Curr a
                inner join LESEN_JenisLesen d on d.JenisLesen_ID = a.JenisLesen_ID
                left join LESEN_JabatanAgensi e on e.JabatanAgensi_ID = a.AgensiID
                inner join LESEN_Pemohon f on f.Pemohon_ID = a.Permohonan_PemohonID
                inner join LESEN_Permohonan g on g.Permohonan_ID = a.Permohonan_ID				
                where a.Permohonan_ID = @Permohonan_ID and isnull(a.AgensiID,1) = case when a.AgensiID is null then 1 else @AgensiID end"
                UpdateCommand="UPDATE LESEN_JenisLesen 
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
                    <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[0]" Name="Permohonan_ID"></asp:ControlParameter>
                    <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[1]" Name="AgensiID"></asp:ControlParameter>
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


            <asp:TabContainer ID="TabContainer1" runat="server" ActiveTabIndex="0" Visible="false" CssClass="MyTabStyle">


                <asp:TabPanel runat="server" ID="tabUlasan" HeaderText="Ulasan">
                    <HeaderTemplate>Ulasan</HeaderTemplate>
                    <ContentTemplate>
						
                        <asp:GridView ID="gvTabUlasan" runat="server" ShowHeaderWhenEmpty="True"
                            AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="UlasanFail_ID"
                            DataSourceID="SqlDataSourceTabUlasan"
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
                                        <%--<asp:Label ID="lblUlasanFail_Remarks" runat="server" Text='<%# Eval("UlasanFail_Remarks") %>'></asp:Label>--%>
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
                                        <%--<asp:Label ID="UlasanFail_FileName" runat="server" Text='<%# Eval("UlasanFail_FileName") %>'></asp:Label>--%>
                                    Fail :
                                        <asp:HyperLink ID="hpFile" runat="server" NavigateUrl='<%# Eval("UlasanFail_FilePath") %>' Target="_blank"><%#Eval("UlasanFail_FileName") %></asp:HyperLink>

                                        <asp:HiddenField ID="hdnFldUlasanFail_FileName" Value='<%# Bind("UlasanFail_FileName") %>' runat="server" />
                                        <asp:HiddenField ID="hdnFldUlasanFail_ContentType" Value='<%# Bind("UlasanFail_ContentType") %>' runat="server" />
                                        <asp:HiddenField ID="hdnFldUlasanFail_FilePath" Value='<%# Bind("UlasanFail_FilePath") %>' runat="server" />
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <%--<asp:UpdatePanel runat="server" ID="updatePanelUlasan">
                                        <ContentTemplate>--%>
                                        <asp:FileUpload ID="txtUlasanFail_FilePath" runat="server" CssClass="form-control" accept="application/pdf,image/png,image/jpeg,image/x-png"></asp:FileUpload>
                                        <asp:Button ID="btnUpload" runat="server" Text="Muat Naik" OnClick="btnUpload_Click" Visible="false"
                                            OnClientClick="return confirm('Fail sedia ada akan ditukar ke fail yang baru.');" />

                                        <asp:HiddenField ID="hdnFldUlasanFail_FileName" Value='<%# Bind("UlasanFail_FileName") %>' runat="server" />
                                        <asp:HiddenField ID="hdnFldUlasanFail_ContentType" Value='<%# Bind("UlasanFail_ContentType") %>' runat="server" />
                                        <asp:HiddenField ID="hdnFldUlasanFail_FilePath" Value='<%# Bind("UlasanFail_FilePath") %>' runat="server" />
                                        <%--    </ContentTemplate>
                                        <Triggers>
                                            <asp:PostBackTrigger ControlID="btnUpload" />
                                        </Triggers>
                                    </asp:UpdatePanel>--%>


                                        <%--<asp:RequiredFieldValidator ID="rvUlasanFail_FilePath" runat="server" CssClass="cssRequiredField"
                                    ControlToValidate="txtUlasanFail_FilePath" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>--%>
                                    </EditItemTemplate>
                                    <HeaderStyle Width="25%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Maklumat Ulasan"
                                    HeaderStyle-Font-Size="10pt" HeaderStyle-Width="90%" ItemStyle-Width="90%">
                                    <ItemTemplate>
                                        <asp:Label ID="Label15" runat="server" Text="Ulasan :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                        <asp:Label ID="Label16" runat="server" Text='<%# If(Len(Eval("UlasanFail_Remarks").ToString()) > 0, (Eval("UlasanFail_Remarks")).Replace(vbCr, "").Replace(vbLf, vbCrLf).Replace(Environment.NewLine, "<br />"), Eval("UlasanFail_Remarks")) %>' Font-Size="10pt"></asp:Label><br />
                                        <asp:Label ID="Label9" runat="server" Text="Fail :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                        <asp:HyperLink ID="hpFileMobile" CssClass="paraGraphtext" runat="server" NavigateUrl='<%# Eval("UlasanFail_FilePath") %>' Target="_blank" Font-Bold="True" Font-Size="10pt"><%#If(Len(Eval("UlasanFail_FileName").ToString()) > 0, Eval("UlasanFail_FileName").ToString.Substring(If(Len(Eval("UlasanFail_FileName").ToString()) > 25, Len(Eval("UlasanFail_FileName").ToString()) - 25, 0)), Eval("UlasanFail_FileName")) %></asp:HyperLink><br />
                                        <asp:Label ID="Label13" runat="server" Text="Jabatan/Agensi :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                        <asp:Label ID="Label19" runat="server" Text='<%# Eval("JabatanAgensi_Description") %>' Font-Size="10pt"></asp:Label><br />
                                        <br />
                                        <asp:LinkButton ID="lbEditMobile" runat="server" CausesValidation="False" CommandName="Edit" Text="Kemaskini" CssClass="btn btn-warning btn-sm"></asp:LinkButton>
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
                                        <br />

                                        <div class="row">

                                            <div class="col-md-6">

                                                <div class="form-group">
                                                    <asp:LinkButton ID="LinkButton1Mobile" runat="server" CausesValidation="True" CommandName="Update" Text="Simpan" CssClass="btn btn-warning btn-sm"></asp:LinkButton>
                                                </div>
                                            </div>

                                            <div class="col-md-6">

                                                <div class="form-group">
                                                    <asp:LinkButton ID="LinkButton2Mobile" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" CssClass="btn btn-default btn-sm"></asp:LinkButton>
                                                </div>

                                            </div>

                                        </div>

                                    </EditItemTemplate>
                                    <ItemStyle HorizontalAlign="Left" />
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
                                        <asp:LinkButton ID="lbEdit" runat="server" CausesValidation="False" CommandName="Edit" Text="Kemaskini" CssClass="btn btn-warning btn-sm"></asp:LinkButton>
                                    </ItemTemplate>
                                    <HeaderStyle Width="10%" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:TemplateField>

                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        <asp:LinkButton ID="btnAddNew" runat="server" Text="+" CssClass="btn btn-warning btn-sm" ToolTip="Tambah" OnClick="btnAddNewUpload_Click" />
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lbDelete" runat="server" CausesValidation="False" CommandName="Delete" Text="Padam" CssClass="btn btn-danger btn-sm" OnClientClick="return confirm('Anda pasti untuk padam rekod ini?');"></asp:LinkButton>
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
                            SelectCommand=" SELECT a.*,b.JabatanAgensi_Description FROM LESEN_UlasanFailBatal a
                        left join LESEN_JabatanAgensi b on b.JabatanAgensi_ID = a.UlasanFail_PermohonanAgensiID
                        where UlasanFail_PermohonanID = @PermohonanID 
                        and case when cast(@AgensiID as int) &gt; 0 then UlasanFail_PermohonanAgensiID else 0 end = case when cast(@AgensiID as int) &gt; 0 then cast(@AgensiID as int) else 0 end 
                        order by CreatedDt asc, UlasanFail_ID asc"
                            DeleteCommand="DELETE FROM LESEN_UlasanFailBatal where UlasanFail_ID = @UlasanFail_ID "
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
                                <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[1]" Name="AgensiID"></asp:ControlParameter>

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

                <asp:TabPanel runat="server" ID="tabKadarBayaran" HeaderText="Wang Amanah">
                    <HeaderTemplate>Wang Amanah</HeaderTemplate>
                    <ContentTemplate>

                        <asp:FormView ID="FormView2" runat="server" DataKeyNames="JenisLesen_ID"
                            DataSourceID="sdsWangAmanah" DefaultMode="Edit" Width="100%" CssClass="CustomTab">
                            <EditItemTemplate>

                                <div class="card card-warning">

                                    <!-- /.card-header -->
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-4">
                                                <div class="form-group">
                                                    <label>Wang Amanah Diterima (RM)</label>
                                                    <asp:Label ID="Label1" runat="server" Text='<%# Eval("DepositAmount", "{0:N}") %>' CssClass="form-control"></asp:Label>
                                                </div>
                                            </div>

                                            <div class="col-md-4">

                                                <div class="form-group">
                                                    <label>Tarikh</label>
                                                    <asp:Label ID="Label2" runat="server" Text='<%# Eval("DepositDate", "{0:yyyy-MM-dd}") %>' CssClass="form-control"></asp:Label>
                                                </div>

                                            </div>

                                            <div class="col-md-4">

                                                <div class="form-group">
                                                    <label>Nombor Resit</label>
                                                    <asp:Label ID="Label22" runat="server" Text='<%# Eval("DepositResitNo") %>' CssClass="form-control"></asp:Label>
                                                </div>

                                            </div>

                                        </div>

                                        <hr />

                                        <div class="row">
                                            <div class="col-md-4">
                                                <div class="form-group">
                                                    <label>Pemulangan Wang Amanah (RM)</label>
                                                    <asp:Label ID="Label23" runat="server" Text='<%# Eval("DepositPulangAmount", "{0:N}") %>' CssClass="form-control highlighted"></asp:Label>
                                                </div>
                                            </div>



                                        </div>



                                    </div>
                                    <!-- /.card-body -->

                                </div>
                            </EditItemTemplate>
                            <InsertItemTemplate>
                            </InsertItemTemplate>
                        </asp:FormView>

                        <asp:SqlDataSource ID="sdsWangAmanah" runat="server"
                            ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                            InsertCommand=""
                            SelectCommand="Select * from LESEN_Permohonan a where a.Permohonan_ID = @Permohonan_ID"
                            UpdateCommand="">

                            <SelectParameters>
                                <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[0]" Name="Permohonan_ID"></asp:ControlParameter>
                                <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[1]" Name="AgensiID"></asp:ControlParameter>
                            </SelectParameters>

                        </asp:SqlDataSource>

                    </ContentTemplate>
                </asp:TabPanel>

                <asp:TabPanel runat="server" ID="tabTetapan" HeaderText="Tetapan">
                    <HeaderTemplate>Tetapan</HeaderTemplate>
                    <ContentTemplate>

                        <asp:GridView width="50%" ID="gvIK" HeaderStyle-ForeColor="Black" CssClass="table table-bordered" AllowPaging="True" ShowHeaderWhenEmpty="True" EmptyDataText="No records Found"
                            AllowSorting="True" runat="server" AutoGenerateColumns="False" DataKeyNames="Users_ID" DataSourceID="sdsIK">
                            <Columns>

                                <asp:BoundField DataField="Users_Fullname" HeaderText="Nama Staff" SortExpression="Users_Fullname">
								<ItemStyle HorizontalAlign="Right" /></asp:BoundField>
                                <asp:TemplateField HeaderText="Pilih">
                                    <EditItemTemplate>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:HiddenField ID="hdID" runat="server" Value='<%# Bind("Users_ID") %>' />
                                        <asp:CheckBox ID="cbSelect" runat="server" Checked='<%# Bind("isSelect") %>' AutoPostBack="true" OnCheckedChanged="CheckBox1_CheckedChanged" />
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <%--      <asp:TemplateField ShowHeader="False">
                                <EditItemTemplate>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:LinkButton runat="server" CommandName="Delete" CssClass="btn btn-danger btn-sm" OnClientClick="return confirm('Padam pilihan ini?');" data-toggle="tooltip" data-placement="top" title="Delete" CausesValidation="False" ID="LinkButton2">Padam</asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>--%>
                            </Columns>
                        </asp:GridView>
                        <asp:SqlDataSource runat="server" ID="sdsIK" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                            DeleteCommand=""
                            SelectCommand="select Users_ID,Users_Fullname,
                        case when (
	                        select count(*) 
	                        from LESEN_PermohonanAgensiStaffBatal x 
	                        inner join LESEN_PermohonanAgensiBatal x2 on x2.PermohonanAgensi_ID = x.PermohonanAgensi_ID
	                        where x.PermohonanAgensiStaffID_UsersID = a.Users_ID
	                        and x2.Permohonan_ID = @Permohonan_ID
                        ) = 0 then 'false' else 'true' end as isSelect
                        from TBL_USERS a
                        where a.Users_Enabled=1 
                        and a.Users_Register=1
                        and a.Users_IsLawatanTapakUlasan = 1
						and a.Users_IsReadOnly = 0
                        and a.estate_id = @AgensiID 
						and (select count(*) from LESEN_Permohonan a
						inner join LESEN_PermohonanAgensiBatal b on b.Permohonan_ID = a.Permohonan_ID
						inner join LESEN_PermohonanAgensiStaffBatal c on c.PermohonanAgensi_ID = b.PermohonanAgensi_ID
						inner join TBL_USERS d on d.Users_Id =  c.PermohonanAgensiStaffID_UsersID and d.estate_id = @AgensiID						
						where a.Permohonan_ID=@Permohonan_ID /*and isnull(b.IsLawatanTapakUlasan,0) = 1*/) = 0
						
						union all
						
						select c.PermohonanAgensiStaffID_UsersID as Users_ID,Users_Fullname,'true' as isSelect from LESEN_Permohonan a
						inner join LESEN_PermohonanAgensiBatal b on b.Permohonan_ID = a.Permohonan_ID
						inner join LESEN_PermohonanAgensiStaffBatal c on c.PermohonanAgensi_ID = b.PermohonanAgensi_ID
						inner join TBL_USERS d on d.Users_Id =  c.PermohonanAgensiStaffID_UsersID and d.estate_id = @AgensiID						
						where a.Permohonan_ID=@Permohonan_ID /*and isnull(b.IsLawatanTapakUlasan,0) = 1*/">
                            <DeleteParameters>
                                <asp:Parameter Name="JenisLesenAgensi_ID"></asp:Parameter>
                            </DeleteParameters>
                            <SelectParameters>
                                <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[0]" Name="Permohonan_ID"></asp:ControlParameter>
                                <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[1]" Name="AgensiID"></asp:ControlParameter>
                            </SelectParameters>
                        </asp:SqlDataSource>

                    </ContentTemplate>
                </asp:TabPanel>

                <asp:TabPanel runat="server" ID="tabSurat" HeaderText="Surat" Visible="false">
                    <HeaderTemplate>Surat</HeaderTemplate>
                    <ContentTemplate>
                        <br />
                        <div class="row">
                            <div class="col-md-3" runat="server" id="divtemplatsurat">
                                <div class="form-group">
                                    <asp:DropDownList ID="DDL_SuratTemplat" CssClass="form-control select2" runat="server" AutoPostBack="false"
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
                                        ) AND (JenisReport='LIBL' OR JenisReport='LIBB') AND NamaTemplat is not null) AS tbl1 ORDER BY NamaTemplatDesc">
                                        <SelectParameters>
                                             <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[7]" Name="JenisLesenIdList"></asp:ControlParameter>
                                        </SelectParameters>
                                    </asp:SqlDataSource>
        
                                </div>
                            </div>
                            <div class="col-md-9">
                                <asp:LinkButton runat="server" CssClass="btn btn-warning" ValidationGroup="updateForm" Text="Jana Surat Sokong" ID="BT_Generate" OnCommand="BT_Generate_Command" CausesValidation="True" /> &nbsp;
<%--                                <asp:LinkButton runat="server" CssClass="btn btn-warning" ValidationGroup="updateForm" Text="Jana Surat Tidak Sokong" ID="BT_Generate1" OnCommand="BT_Generate1_Command" CausesValidation="True" /> &nbsp;--%>
                                <asp:LinkButton runat="server" CssClass="btn btn-warning" ValidationGroup="updateForm" Text="Lihat Surat" ID="BT_ViewMail" OnCommand="BT_ViewMail_Command" CausesValidation="True" />
								<asp:LinkButton runat="server" CssClass="btn btn-warning" ValidationGroup="updateForm" Text="Surat Mohon Ulasan" ID="BT_ViewMU" OnCommand="BT_ViewMU_Command" CausesValidation="True" />																
                            </div>
                        </div>
                        <br />
                        <div class="row">
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
                                                <asp:FileUpload ID="FU_Lampiran1" runat="server" CssClass="form-control" accept="application/pdf" />
                                                <asp:HyperLink ID="HL_Lampiran1" NavigateUrl="#" Text="null" runat="server" />
                                            </div>
                                            <div class="col">
                                                <asp:LinkButton ID="BT_Update1" runat="server" Text="Ubah" CssClass="btn btn-warning" OnClick="BT_Update1_Click" />
                                                <asp:LinkButton ID="BT_Cancel1" runat="server" Text="Batal" CssClass="btn btn-default" OnClick="BT_Cancel1_Click" />
                                                <asp:LinkButton ID="BT_Delete1" runat="server" Text="Padam" CssClass="btn btn-default" OnClick="BT_Delete1_Click" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </asp:Panel>

                        <asp:Panel ID="pnlSuratAuto" runat="server">
                            <div class="row">

                                <div class="col-md-2" runat="server" ID="divTarikhSurat" >

                                    <div class="form-group">
                                        <label>Tarikh Pengesahan KB</label>
                                        <asp:TextBox ID="TB_TarikhSurat" runat="server" TextMode="Date" CssClass="form-control" />
                                    </div>
                                </div>

                                <div class="col-md-2">

                                    <div class="form-group">
                                        <label>Tarikh Pemeriksaan IK</label>
                                        <asp:TextBox ID="TB_TarikhPeriksa" runat="server" TextMode="Date" CssClass="form-control" />
                                    </div>
                                </div>

                                <div class="col-md-4">

                                    <div class="form-group">
                                        <label>No Rujukan</label>
                                        <asp:TextBox ID="TB_NoRujukan" Text="MPK/599/401/" runat="server" CssClass="form-control" />
                                    </div>
                                </div>

                            </div>

                            <div class="row">
                                <div class="col-md-6">

                                    <div class="form-group">
                                        <label>Tandatangan</label>
                                        <asp:DropDownList ID="ddlTandatangan" CssClass="form-control select2" runat="server" AutoPostBack="false"
                                            DataSourceID="sdsSignature" DataTextField="Users_Fullname" DataValueField="Users_Id">
                                        </asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="sdsSignature" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            DeleteCommand=""
                                            SelectCommand="SELECT 0 AS Users_Id, '--- Sila Pilih ---' AS Users_Fullname 
                                            UNION ALL select Users_Id,Users_Fullname/* *,
                                            case when (
                                            select count(*) 
                                            from LESEN_PermohonanAgensiStaff x 
                                            inner join LESEN_PermohonanAgensi x2 on x2.PermohonanAgensi_ID = x.PermohonanAgensi_ID
                                            where x.PermohonanAgensiStaffID_UsersID = a.Users_ID
                                            and x2.Permohonan_ID = @Permohonan_ID
                                            ) = 0 then 'false' else 'true' end as isSelect*/
                                            from TBL_USERS a
                                            where a.Users_Enabled=1 
                                            and a.Users_Register=1
                                            and (a.Users_IsPenilaian = 1 or a.Users_IsPeraku = 1)
                                            and a.estate_id = case when cast(isnull(@AgensiID,0) as int) = 0 then 3 else @AgensiID end ">
                                            <DeleteParameters>
                                                <asp:Parameter Name="JenisLesenAgensi_ID"></asp:Parameter>
                                            </DeleteParameters>
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[0]" Name="Permohonan_ID"></asp:ControlParameter>
                                                <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[1]" Name="AgensiID" DefaultValue="3"></asp:ControlParameter>
                                            </SelectParameters>
                                        </asp:SqlDataSource>

                                    </div>
                                </div>
                            </div>
                        </asp:Panel>

                        <div class="row">
                            <div class="col-md-10">
                                <asp:LinkButton ID="btnSaveLetter" runat="server" CausesValidation="False" Text="Simpan" CssClass="btn btn-warning" OnClick="btnSaveLetter_Click" />
                            </div>
                        </div>
                        <br />

                        <asp:Panel ID="pnlSuratContentAuto" runat="server">

                            <div class="card">
                                <div class="card-body">

                                    <div class="row">
                                        <div class="col-12">

                                            <asp:FormView ID="FormViewReport" Width="100%" DefaultMode="Insert" runat="server" DataKeyNames="PSID" DataSourceID="SqlDataSourceReport">
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
                                                InsertCommand="INSERT INTO LESEN_PermohonanSurat (Permohonan_ID, JenisReport, P1, P2, P3, IsiKandungan, CreatedDt, ModDt) VALUES 'LIB', @P1, @P2, @P3, @IsiKandungan, GETDATE(), GETDATE()); "
                                                UpdateCommand="UPDATE LESEN_PermohonanSurat SET P1=@P1, P2=@P2, P3=@P3, IsiKandungan=@IsiKandungan WHERE PSID=@PSID"
                                                SelectCommand="SELECT * FROM LESEN_PermohonanSurat WHERE PSID=@PSID">
                                                <InsertParameters>
                                                    <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[0]" Name="Permohonan_ID"></asp:ControlParameter>
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
                                    <!-- /.tab-1 Formview -->
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
                                                SelectCommand="SELECT * FROM LESEN_PermohonanSurat WHERE Permohonan_ID=@Permohonan_ID AND (JenisReport='LIBB' OR JenisReport='LIBL') 
                                                ORDER BY P1, P2, P3">
                                                <DeleteParameters>
                                                    <asp:Parameter Name="PSID"></asp:Parameter>
                                                </DeleteParameters>
                                                <SelectParameters>
                                                    <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[0]" Name="Permohonan_ID"></asp:ControlParameter>
                                                    <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[2]" Name="StatusID"></asp:ControlParameter>
                                                </SelectParameters>
                                            </asp:SqlDataSource>
                                        </div>
                                    </div>
                                    <!-- /.tab-1 Gridview -->
                                </div>
                            </div>

                        </asp:Panel>

                    </ContentTemplate>
                </asp:TabPanel>
				
                <asp:TabPanel runat="server" ID="TabLampiran" HeaderText="Ulasan">
				                <HeaderTemplate>Lampiran</HeaderTemplate>
				                <ContentTemplate>

                        <%--<asp:LinkButton runat="server" Text="Lihat Surat Mohon Ulasan"  CausesValidation="False" ID="lbSurat" CssClass="btn btn-warning btn-sm" ></asp:LinkButton>--%>

					                <asp:GridView ID="GridView2" runat="server" ShowHeaderWhenEmpty="True"
						                AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="PermohonanFail_ID"
						                DataSourceID="SqlDataSourceTabLampiran"
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
									
								                </EditItemTemplate>
								                <HeaderStyle Width="5%" />
							                </asp:TemplateField>

							                <asp:TemplateField HeaderText="Lampiran">
								                <ItemTemplate>
									                <asp:TextBox ID="txtPermohonanFail_Remarks" runat="server" Text='<%# Bind("PermohonanFail_Remarks") %>' CssClass="form-control" TextMode="MultiLine" Rows="4" ReadOnly="True" BorderStyle="None"></asp:TextBox>
								                </ItemTemplate>
								                <EditItemTemplate>
								 
								                </EditItemTemplate>
								                <HeaderStyle Width="60%" HorizontalAlign="Left" />
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
									
								                </EditItemTemplate>
								                <HeaderStyle Width="35%" />
							                </asp:TemplateField>

						

						                </Columns>

						                <PagerStyle CssClass="pgr" />
					                </asp:GridView>

					                <asp:SqlDataSource ID="SqlDataSourceTabLampiran" runat="server"
						                ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
						                SelectCommand=" SELECT a.*, b.StatusID FROM LESEN_PermohonanFail a INNER JOIN LESEN_Permohonan b ON a.PermohonanFail_PermohonanID = b.Permohonan_ID 
						                WHERE a.PermohonanFail_JenisLampiran = 'U' AND a.PermohonanFail_PermohonanID = @Permohonan_ID"
						                DeleteCommand=""
						                UpdateCommand="">
						                <DeleteParameters>
							
						                </DeleteParameters>
						                <SelectParameters>
							                <asp:ControlParameter ControlID="GridView1" Name="Permohonan_ID" PropertyName="SelectedDataKey.Values[0]"></asp:ControlParameter>
						                </SelectParameters>
						                <UpdateParameters>
   
						                </UpdateParameters>
					                </asp:SqlDataSource>

				                </ContentTemplate>
                </asp:TabPanel>				

            </asp:TabContainer>


            <div class="card-footer" runat="server" visible="false" id="idFooter">
                <div runat="server" id="idNotaKelulusan">
                    <div class="card">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">

                                    <asp:FormView ID="fvNotaKelulusan" runat="server" DataKeyNames="JenisLesen_ID"
                                        DataSourceID="sdsNotaKelulusan" DefaultMode="Edit" Width="100%" CssClass="CustomTab">
                                        <EditItemTemplate>
                                            <div class="form-group">


                                                <div class="row">
                                                    <div class="col-md-12">

                                                        <div class="form-group">
                                                            <label>Nota Kelulusan (Bahagian Perlesenan)</label>
                                                            <div runat="server" visible='<%# If(Eval("ApprStatusID") > 5, True, False) %>'>
                                                                <asp:Label ID="Label25" runat="server" Text='<%# Bind("Users_Fullname") %>'></asp:Label>
                                                                <asp:Label ID="Label8" runat="server" Font-Bold="true"
                                                                    ForeColor='<%#If(Eval("StatusIDPengesah2") = 1, System.Drawing.Color.Green, System.Drawing.Color.Red)%>'
                                                                    Text='<%# "<< " + If(Eval("StatusIDPengesah2") = 1, "Sokong", "Tidak Sokong") + " >>"%>'></asp:Label>
                                                            </div>


                                                            <asp:TextBox ID="txtNotaKelulusanPengesah" runat="server" Text='<%# Bind("NotaKelulusanPengesahBatal") %>'
                                                                Enabled='<%# If(Eval("ApprStatusID") = "8", False, True) %>'
                                                                CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
                                                        </div>
                                                    </div>

                                                </div>

                                                <div class="row" runat="server" visible='<%# If(Eval("ApprStatusID") > 5 And Session.Item("sessionIsPeraku") = "True", True, False) %>'>
                                                    <div class="col-md-12" runat="server" id="divNotaKelulusanPeraku" visible='<%# If(Eval("NotaKelulusanKJ2") = 0, False, False) %>'>

                                                        <div class="form-group">
                                                            <label>Nota Kelulusan (Peraku)</label><br />

                                                            <asp:TextBox ID="txtNotaKelulusan" runat="server" Text='<%# Bind("NotaKelulusanBatal") %>' CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
                                                        </div>
                                                    </div>
													
                                                    <div class="col-md-12" runat="server" visible="true">

                                                        <div class="form-group">
                                                        <asp:RadioButtonList  id="rblNotaKelulusanKJ" runat="server" AutoPostBack="true" SelectedValue='<%# Bind("NotaKelulusanKJ2") %>' OnSelectedIndexChanged="rblNotaKelulusanKJ_SelectedIndexChanged">
                                                        <asp:ListItem Value="0">&nbsp;-- Kelulusan --</asp:ListItem>
                                                        <asp:ListItem Value="1">&nbsp;Setuju untuk proses pembatalan</asp:ListItem>
                                                        <asp:ListItem Value="2">&nbsp;Setuju untuk proses pembatalan dengan pindaan</asp:ListItem>
                                                        <asp:ListItem Value="3">&nbsp;Setuju untuk proses pembatalan dan Wang Deposit dirampas</asp:ListItem>
														<asp:ListItem Value="5">&nbsp;Setuju untuk proses pembatalan dan Wang Deposit dipulangkan</asp:ListItem>
                                                        <asp:ListItem Value="4">&nbsp;Setuju untuk memproses pembatalan ini ditolak</asp:ListItem> 														
														<asp:ListItem Value="6">&nbsp;Lain-lain</asp:ListItem>                                                        
                                                        </asp:RadioButtonList>
                                                        </div>
                                                    </div>														

                                                </div>

                                            </div>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                        </InsertItemTemplate>
                                    </asp:FormView>

                                    <asp:SqlDataSource ID="sdsNotaKelulusan" runat="server"
                                        ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                                        SelectCommand="/*SELECT top 1 a.*,isnull(d.Users_Fullname,'') as Users_Fullname,
                c.ApprStatusID,isnull(e.Description,'') as Description, isnull(a.StatusIDPengesah,0) as StatusIDPengesah2,
                isnull(a.NotaKelulusanKJ,0) as NotaKelulusanKJ2				
                FROM LESEN_Permohonan a 
                inner join LESEN_ApprovalListBatal c on c.Permohonan_ID = a.Permohonan_ID and c.ApprStatusID = a.StatusID
                left join TBL_USERS d on d.Users_Id = c.ApproverID
                inner join ApprovalStatusBatal e on e.ApprStatusID = c.ApprStatusID
                where a.Permohonan_ID = @Permohonan_ID*/

                                        SELECT top 1 a.*,
                (select isnull(x2.Users_Fullname,'') from 
                                        LESEN_ApprovalListBatal x
                                        inner join TBL_USERS x2 on x2.Users_Id = x.ApproverID 
                                        where x.Permohonan_ID = a.Permohonan_ID and x.ApprStatusID = 5
                                         ) as Users_Fullname,
                c.ApprStatusID,isnull(e.Description,'') as Description, isnull(a.StatusIDPengesah,0) as StatusIDPengesah2,
				isnull(a.NotaKelulusanKJ,0) as NotaKelulusanKJ2
                FROM LESEN_Permohonan a 
				inner join v_LESEN_ApprovalListBatal_Curr c on c.Permohonan_ID = a.Permohonan_ID
                /*inner join LESEN_ApprovalListBatal c on c.Permohonan_ID = a.Permohonan_ID and c.ApprStatusID = a.StatusID*/
                /*left join TBL_USERS d on d.Users_Id = c.ApproverID*/
                inner join ApprovalStatusBatal e on e.ApprStatusID = c.ApprStatusID
                where a.Permohonan_ID = @Permohonan_ID">

                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[0]" Name="Permohonan_ID"></asp:ControlParameter>

                                        </SelectParameters>

                                    </asp:SqlDataSource>



                                </div>

                                <div class="col-md-6">
                                    <%--<asp:Label ID="Label7" runat="server" Text="ULASAN AGENSI / JABATAN"></asp:Label><br /><br />--%>
                                    <div class="form-group" style="background-color: #EDECFC; padding: 10px !important; font-size: 10pt !important; border-radius: 5px; border: 1px solid #E9ECEF !important;">

                                        <asp:Repeater ID="rptWeek" runat="server" DataSourceID="sdsAgensiUlasan">
                                            <ItemTemplate>

                                                <label runat="server" id="lblAgensiDesc"><%# Eval("JabatanAgensi_Description") %></label>
                                                &nbsp;&nbsp;                                   
                                    <asp:LinkButton ID="lbLihatSurat" runat="server" CausesValidation="False" Text="Lihat Surat" CssClass="btn btn-warning btn-sm"
                                        Visible='<%#If(Eval("JabatanAgensi_Type") = "J", True, False)%>' OnClick="lbLihatSurat_Click"></asp:LinkButton>
                                                <br />
                                                <asp:Label CssClass="csslblUlasan" ID="Label6" runat="server" Text='<%# "<b>Pengesah</b> : " + Eval("Pengesah") %>'></asp:Label>
                                                -
                                    <asp:Label ID="Label8" runat="server" Font-Bold="true" ForeColor='<%#If(Eval("currStatusPengesah") = -1, System.Drawing.Color.Orange, If(Eval("currStatusPengesah") = 1, System.Drawing.Color.Green, System.Drawing.Color.Red))%>'
                                        Text='<%#If(Eval("currStatusPengesah") = -1, "Belum Selesai", If(Eval("currStatusPengesah") = 1, "SOKONG", "TIDAK SOKONG"))%>'></asp:Label>
                                                <br />
                                                <asp:Label CssClass="csslblUlasan" ID="Label21" runat="server" Text='<%# (Eval("PengesahNotaKelulusan")).Replace(vbCr, "").Replace(vbLf, vbCrLf).Replace(Environment.NewLine, "<br />") %>'></asp:Label>

                                                <%--<br />                                    

                                    <div runat="server" visible='<%# If(Eval("JabatanAgensi_Type") = "J", True, False) %>'>
                                    <asp:Label CssClass="csslblUlasan" ID="Label22" runat="server" Text='<%# "<b>Peraku</b> : " + Eval("Peraku") %>'></asp:Label> -
                                    <asp:Label ID="Label24" runat="server" Font-Bold="true" ForeColor='<%#If(Eval("currStatusPeraku") = -1, System.Drawing.Color.Orange, If(Eval("currStatusPeraku") = 1, System.Drawing.Color.Green, System.Drawing.Color.Red))%>' 
                                    Text='<%#If(Eval("currStatusPeraku") = -1, "Belum Selesai", If(Eval("currStatusPeraku") = 1, "SOKONG", "TIDAK SOKONG"))%>'></asp:Label>
                                    <br />
                                    <asp:Label CssClass="csslblUlasan" ID="Label23" runat="server" Text='<%# (Eval("NotaKelulusan")).Replace(vbCr, "").Replace(vbLf, vbCrLf).Replace(Environment.NewLine, "<br />") %>'></asp:Label>
                                    </div>--%>

                                                <hr style="border-color: #808080 !important" />
                                            </ItemTemplate>
                                        </asp:Repeater>

                                        <asp:SqlDataSource runat="server" ID="sdsAgensiUlasan" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            SelectCommand="select isnull(JabatanAgensi_Type,'J') as JabatanAgensi_Type,JabatanAgensi_Description,isnull(NotaKelulusan,'') as NotaKelulusan,
                            isnull(PengesahNotaKelulusan,'') as PengesahNotaKelulusan,
                            case when IsPenilaian = 1 /*and IsPeraku = 1 and JabatanAgensi_Type = 'J' then StatusID 
                            when IsPenilaian = 1 and JabatanAgensi_Type = 'L'*/ then isnull(PengesahStatusID,0)
                            else -1 end as currStatusPengesah,
                            case when IsPeraku = 1 then isnull(StatusID,0)
                            else -1 end as currStatusPeraku,
                            (select top 1 d.Users_Fullname from LESEN_ApprovalListBatal c
                            inner join TBL_USERS d on d.Users_Id = c.ApproverID
                            where c.Permohonan_ID = a.Permohonan_ID and c.AgensiID = a.JabatanAgensi_ID and c.ApprStatusID = 4) as Pengesah2,
                            (select top 1 d.Users_Fullname from TBL_USERS d 
                            where d.Users_Id = a.PengesahID ) as Pengesah,							
                            (select top 1 d.Users_Fullname from LESEN_ApprovalListBatal c
                            inner join TBL_USERS d on d.Users_Id = c.ApproverID
                            where c.Permohonan_ID = a.Permohonan_ID and c.AgensiID = a.JabatanAgensi_ID and c.ApprStatusID = 8) as Peraku
                            from LESEN_PermohonanAgensiBatal a
                            inner join LESEN_JabatanAgensi b on b.JabatanAgensi_ID = a.JabatanAgensi_ID
                            where a.Permohonan_ID=@Permohonan_ID">
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[0]" Name="Permohonan_ID"></asp:ControlParameter>


                                            </SelectParameters>
                                        </asp:SqlDataSource>

                                    </div>
                                </div>

                            </div>

                        </div>
                    </div>
                </div>

                <asp:FormView Width="100%" ID="fvSokongUlasan" runat="server" DataSourceID="sdsSokongUlasan" DefaultMode="Edit" DataKeyNames="PermohonanAgensi_ID">
                    <EditItemTemplate>
                        <%--StatusID:
                        <asp:TextBox Text='<%# Bind("StatusID") %>' runat="server" ID="StatusIDTextBox" /><br />
                        NotaKelulusan:
                        <asp:TextBox Text='<%# Bind("NotaKelulusan") %>' runat="server" ID="NotaKelulusanTextBox" /><br />
                        <asp:LinkButton runat="server" Text="Update" CommandName="Update" ID="UpdateButton" CausesValidation="True" />&nbsp;<asp:LinkButton runat="server" Text="Cancel" CommandName="Cancel" ID="UpdateCancelButton" CausesValidation="False" />--%>

                        <asp:HiddenField ID="hdnFiedlJabatanAgensiType" runat="server" Value='<%# Bind("JabatanAgensi_Type") %>' />
                        <!-- sokong / tak sokong pengesah -->
                        <div class="card" runat="server" id="idSokongUlasanPengesah"
                            visible='<%# If(GridView1.SelectedDataKey.Values(2) = "4" Or GridView1.SelectedDataKey.Values(2) = "5", True, False) %>'>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-6">

                                        <div class="form-group">

                                            <asp:Label ID="Label20" runat="server" Text="Nota Kelulusan (Pengesah)"></asp:Label><br />
                                            <asp:TextBox ID="txtPengesahNotaKelulusan" Text='<%# Bind("PengesahNotaKelulusan") %>' runat="server"
                                                Enabled='<%# If(GridView1.SelectedDataKey.Values(2) = "5", False, True) %>'
                                                CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>

                                            <label>Sokongan</label>
                                            <asp:DropDownList ID="ddlPengesahSokongUlasan" runat="server" Text='<%# Bind("PengesahStatusID") %>'
                                                Enabled='<%# If(GridView1.SelectedDataKey.Values(2) = "5", False, True) %>'
                                                CssClass="form-control select2">
                                                <asp:ListItem Value="1">Sokong</asp:ListItem>
                                                <asp:ListItem Value="0">Tidak Sokong</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>


                                    </div>

                                    <div class="col-md-6" runat="server" id="idSokongUlasan"
                                        visible='<%# If(GridView1.SelectedDataKey.Values(2) = "5", True, False) %>'>

                                        <div class="form-group">

                                            <asp:Label ID="Label7" runat="server" Text="Nota Kelulusan (Peraku)"></asp:Label><br />
                                            <asp:TextBox ID="txtNotaUlasan" Text='<%# Bind("NotaKelulusan") %>' runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>

                                            <label>Sokongan</label>
                                            <asp:DropDownList ID="ddlSokongUlasan" runat="server" Text='<%# Bind("StatusID") %>' CssClass="form-control select2">
                                                <asp:ListItem Value="1">Sokong</asp:ListItem>
                                                <asp:ListItem Value="0">Tidak Sokong</asp:ListItem>
                                                <asp:ListItem Value="3">Pilih Staff</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>


                                    </div>



                                </div>

                            </div>
                        </div>
                    </EditItemTemplate>
                    <InsertItemTemplate>
                    </InsertItemTemplate>
                    <ItemTemplate>
                    </ItemTemplate>
                </asp:FormView>

                <asp:SqlDataSource runat="server" ID="sdsSokongUlasan" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                    SelectCommand="SELECT PermohonanAgensi_ID, isnull(StatusID,1) as StatusID, isnull(PengesahStatusID,1) as PengesahStatusID, 
                    [NotaKelulusan],[PengesahNotaKelulusan], isnull(JabatanAgensi_Type,'J') as JabatanAgensi_Type
                    FROM [LESEN_PermohonanAgensiBatal] a
                    left join LESEN_JabatanAgensi b on b.JabatanAgensi_ID = a.JabatanAgensi_ID
                    WHERE (([Permohonan_ID] = @Permohonan_ID) AND (a.JabatanAgensi_ID = case when cast(@JabatanAgensi_ID as int) = 0 then a.JabatanAgensi_ID else @JabatanAgensi_ID end))">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[0]" Name="Permohonan_ID"></asp:ControlParameter>
                        <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[1]" Name="JabatanAgensi_ID"></asp:ControlParameter>
                    </SelectParameters>
                </asp:SqlDataSource>




                <div class="form-group">
                    <div class="row">
                        <div class="col-md-12" style="text-align: center">

                            <asp:LinkButton ID="btnSubmit" runat="server" CausesValidation="True" Text="Hantar Ulasan" OnClientClick="return confirm('Anda pasti untuk meneruskan proses ini?');" OnClick="btnSubmit_Click" ValidationGroup="frmEdit" CssClass="btn btn-warning" />

                            <asp:LinkButton ID="btnKembaliIK" runat="server" CausesValidation="False" 
                                Text="Kembalikan Ke IK" 
                                OnClick="btnKembaliIK_Click" 
                                ValidationGroup="frmEdit" CssClass="btn btn-danger" />

                            <asp:LinkButton ID="btnApprove" runat="server" CausesValidation="True" Text="Sokong" OnClientClick="return confirm('Anda pasti untuk Sokong Rekod Ini?');" OnClick="btnApprove_Click" ValidationGroup="frmEdit" CssClass="btn btn-warning" />


                            <asp:LinkButton ID="btnReject" runat="server" CausesValidation="True" Text="Tidak Sokong" OnClientClick="return confirm('Anda pasti untuk Tidak Sokong Rekod Ini?');" OnClick="btnReject_Click" ValidationGroup="frmEdit" CssClass="btn btn-warning" />

                            <asp:LinkButton ID="btnBack" runat="server" CausesValidation="False" Text="Kembali" CssClass="btn btn-default" OnClick="btnBack_Click" />
                        </div>

                    </div>
                </div>



            </div>
			
            <div class="row" runat="server" id="divBtnKembali" visible="false">
                <div class="col-md-12" style="text-align: center">
                    <br />
                    <asp:LinkButton ID="LinkButton3" runat="server" CausesValidation="False" Text="Kembali" CssClass="btn btn-default" OnClick="btnBack_Click" />
                </div>
            </div>			

            <div class="card" runat="server" id="idListing">
                <div class="card-body" style="overflow-x: auto;">
                    <%--# START FILTER - set SortExpression at GridView as fieldname & add WHERE 1=1 at SqlDataSource - SelectCommand #--%>
                    <div class="row">
                        <div class="col-md-10">
                            <%--<div id="pnlFilter" runat="server" class="row"></div>--%>

                            <div class="row">

                                <div class="col-md-2">

                                    <div class="form-group">
                                        <asp:TextBox ID="txtNoRujukan" placeholder="No Rujukan" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>

                                </div>

                                <div class="col-md-3" runat="server" id="filterJenisLesen">

                                    <div class="form-group">
                                        <asp:DropDownList ID="DDL_JenisLesen" CssClass="form-control select2" runat="server" AutoPostBack="false"
                                            DataSourceID="SqlDataSourceLesen" DataTextField="JenisLesen_Description" DataValueField="JenisLesen_ID">
                                        </asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourceLesen" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            SelectCommand="select * from 
                                        (select '0' as JenisLesen_ID, '-- Lesen --' as JenisLesen_Description
                                        union all
                                        select JenisLesen_Description AS JenisLesen_ID,  JenisLesen_Description from LESEN_JenisLesen where JenisLesen_IsActive=1
                                        ) as tbl1 order by JenisLesen_Description "></asp:SqlDataSource>
                                    </div>

                                </div>

                                <div class="col-md-2" runat="server" id="filterPemohon">
                                    <div class="form-group">
                                        <asp:DropDownList ID="ddlPemohonCari" CssClass="form-control select2" runat="server"
                                            DataSourceID="sdsPemohon" DataTextField="Pemohon_Name" DataValueField="Pemohon_ID">
                                        </asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="sdsPemohon" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            SelectCommand="select * from 
                                        (select 0 as Pemohon_ID, '-- Pemohon --' as Pemohon_Name
                                        union all
                                        select Pemohon_ID,  Pemohon_Name from LESEN_Pemohon where Pemohon_IsActive=1
                                        ) as tbl1 order by Pemohon_Name "></asp:SqlDataSource>
                                    </div>
                                </div>

                                <%--                                <div class="col-md-3">
                                        <asp:DropDownList ID="DDL_JabatanAgensi" CssClass="form-control select2" runat="server"
                                        DataSourceID="SqlDataSourceJabatanAgensi" DataTextField="JabatanAgensi_Description" DataValueField="JabatanAgensi_ID">
                                        </asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourceJabatanAgensi" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                        SelectCommand="select * from 
                                        (select 0 as JabatanAgensi_ID, '-- Jabatan/Agensi --' as JabatanAgensi_Description
                                        union all
                                        select JabatanAgensi_ID,  JabatanAgensi_Description from LESEN_JabatanAgensi where JabatanAgensi_IsActive=1
                                        ) as tbl1 order by JabatanAgensi_Description "></asp:SqlDataSource>
                                </div>--%>

                                <div class="col-md-2">
                                    <div class="form-group">
                                        <asp:TextBox ID="TB_TarikhMohon" runat="server"
                                            TextMode="Date" CssClass="form-control" />
                                    </div>
                                </div>
								
                                <div class="col-md-3">
                                    <div class="form-group">

                                    <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <asp:DropDownList ID="ddlYear" CssClass="form-control select2" runat="server"
                                            DataSourceID="sdsYear" DataTextField="yearName" DataValueField="yearMohon">
                                        </asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="sdsYear" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            SelectCommand="select 0 as yearMohon,'Tahun' as yearName
                                            union all
                                            select year(TarikhMohon) as yearMohon,cast(year(TarikhMohon) as varchar(20)) as yearName from LESEN_Permohonan
				                            group by year(TarikhMohon)"></asp:SqlDataSource>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <asp:DropDownList ID="ddlMonth" runat="server" CssClass="form-control select2" Width="100px">
                                        <asp:ListItem Value="0">Bulan</asp:ListItem>
                                        <asp:ListItem>1</asp:ListItem>
                                        <asp:ListItem>2</asp:ListItem>
                                        <asp:ListItem>3</asp:ListItem>
                                        <asp:ListItem>4</asp:ListItem>
                                        <asp:ListItem>5</asp:ListItem>
                                        <asp:ListItem>6</asp:ListItem>
                                        <asp:ListItem>7</asp:ListItem>
                                        <asp:ListItem>8</asp:ListItem>
                                        <asp:ListItem>9</asp:ListItem>
                                        <asp:ListItem>10</asp:ListItem>
                                        <asp:ListItem>11</asp:ListItem>
                                        <asp:ListItem>12</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>

                            </div>
                                                                                                                         
                                    </div>
                                </div>								

                                <%--                                <div class="col-md-2">
                                        <asp:DropDownList ID="ddlStatus" CssClass="form-control select2" runat="server"
                                        DataSourceID="sdsStatus" DataTextField="Description" DataValueField="ApprStatusID">
                                        </asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="sdsStatus" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                        SelectCommand="select * from 
                                        (select NULL as ApprStatusID, '-- Pemohon --' as Description
                                        union all
                                        select ApprStatusID,  Description from ApprovalStatusBatal 
                                        where ApprStatusID IN (2,3,4,5,8)
                                        ) as tbl1 order by ApprStatusID "></asp:SqlDataSource>
                                </div>--%>
                            </div>

                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-default" Text="Cari" />
                                <asp:Button ID="btnReset" CssClass="btn btn-default" runat="server" Text="Reset" />
                            </div>
                        </div>
                    </div>
					
                    <div class="row" runat="server" id="divLihatSemuaUlasan">
                        <div class="col-md-2">
                            <div class="form-group">
                                <label>Lihat Semua Ulasan</label>
                                <asp:CheckBox ID="cbAllUlasan" runat="server" AutoPostBack="true" />
                            </div>
                        </div>
						
                        <div class="col-md-4">
                            <div class="form-group">
                                <%--<label>Status</label>--%>
                                <asp:DropDownList ID="DDL_Status" CssClass="form-control select2" runat="server" AutoPostBack="false"
                                    DataSourceID="sdsStatus" DataTextField="Description" DataValueField="ApprStatusID">
                                </asp:DropDownList>
                                <asp:SqlDataSource runat="server" ID="sdsStatus" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                    SelectCommand="select * from 
                                    (select -1 as ApprStatusID, '-- Status --' as Description
                                    union all
                                    select ApprStatusID,  Description from ApprovalStatus where ApprStatusID IN (2,3,4,5,6,7,8,9,10)
                                    ) as tbl1 order by ApprStatusID "></asp:SqlDataSource>
                            </div>
                        </div>								

                    </div>					
                    <%--# END FILTER #--%>

                    <asp:GridView ID="GridView1" runat="server"
                        AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="Permohonan_ID,AgensiID,ApprStatusID,JabatanAgensi_Type,JenisLesen_ID,IsSuratPemeriksaanFail,IsPenilaianStatus,JenisLesenIdList"
                        DataSourceID="SqlDataSourceGrid"
                        CssClass="table table-bordered" PagerStyle-CssClass="pgr"
                        AlternatingRowStyle-CssClass="alt">
                        <AlternatingRowStyle CssClass="alt" />
                        <Columns>
                            <asp:TemplateField HeaderText="No." InsertVisible="False" SortExpression="JenisLesen_ID">
                                <EditItemTemplate>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label runat="server" Text='<%# Container.DataItemIndex + 1 %>' ID="Label2"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:BoundField DataField="JenisLesenDescList" HeaderText="Jenis Lesen"
                                SortExpression="JenisLesenDescList" />
                           <%-- <asp:BoundField DataField="Pemohon_Name" HeaderText="Nama Pemohon"
                                SortExpression="Pemohon_Name" />--%>

                            <asp:TemplateField HeaderText="Pemohon">
                                <ItemTemplate>
                                    <asp:Label ID="lblNamaPemohon" runat="server" Text='<%# Eval("Pemohon_Name") %>' Font-Size="12pt"></asp:Label><br />
                                    <asp:Label ID="lblAlamatPremis" runat="server" Text='<%# Eval("AlamatPremis") %>' Font-Size="10pt"></asp:Label><br />
									<asp:Label ID="lblSyarikat" runat="server" Text='<%# Eval("NamaSyarikat") %>' Font-Size="12pt" ForeColor="Blue"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="JabatanAgensi_Description" HeaderText="Jabatan/Agensi" />
                            <asp:BoundField DataField="TarikhMohon" HeaderText="Tarikh Mohon" DataFormatString="{0:yyyy-MM-dd}"
                                SortExpression="TarikhMohon" />
                            <asp:BoundField DataField="Description" HeaderText="Status"
                                SortExpression="Description" />

                            <asp:TemplateField HeaderText="Maklumat Permohonan" HeaderStyle-Font-Size="10pt" HeaderStyle-Width="90%" ItemStyle-Width="90%">
                                <ItemTemplate>
                                    <asp:Label ID="Label15" runat="server" Text="Tarikh Mohon :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                    <asp:Label ID="Label16" runat="server" Text='<%# Eval("TarikhMohon", "{0:yyyy-MM-dd}") %>' Font-Size="10pt"></asp:Label><br />
                                    <asp:Label ID="Label9" runat="server" Text="Jenis Lesen :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                    <asp:Label ID="Label10" runat="server" Text='<%# Eval("JenisLesenDescList") %>' Font-Size="10pt"></asp:Label><br />
                                    <asp:Label ID="Label11" runat="server" Text="Nama Pemohon :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                    <asp:Label ID="Label12" runat="server" Text='<%# Eval("Pemohon_Name") %>' Font-Size="10pt"></asp:Label><br />
                                    <asp:Label ID="Label17" runat="server" Text="Status :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                    <asp:Label ID="Label14" runat="server" Text='<%#If(IsDBNull(Eval("JabatanAgensi_Description")), "", Eval("JabatanAgensi_Description") + "<br />") %>' Font-Bold="True" Font-Size="10pt"></asp:Label>
                                    <asp:Label ID="Label18" runat="server" Text='<%# Eval("Description") %>' Font-Size="10pt"></asp:Label><br />
									<asp:Label ID="lblAlamatPremis2" runat="server" Text='<%# Eval("AlamatPremis") %>' Font-Size="10pt"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:TemplateField>

                            <%--<asp:CheckBoxField DataField="JenisLesen_IsActive" HeaderText="Aktif?" SortExpression="JenisLesen_IsActive" />--%>
                            <asp:TemplateField HeaderText="Operasi">
                                <ItemTemplate>


                                    <%--  <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False"
                                        CommandName="Delete" Text="Nyah Aktif" OnClientClick="return confirm('Anda Pasti Untuk Nyah Aktif rekod ini?');" CssClass="btn btn-danger btn-sm"></asp:LinkButton>--%>

                                    <div>
                                        <div class="row">
                                            <div class="col-lg-6">

                                                <div class="form-group">
                                                    <asp:LinkButton runat="server" Text="Lihat Maklumat" CommandName="Select" CausesValidation="False"
                                                        ID="lbLihat" CssClass="btn btn-warning btn-sm"></asp:LinkButton>
                                                </div>

                                            </div>

                                            <div class="col-lg-6">

                                                <div class="form-group">
                                                    <asp:LinkButton runat="server" Text="Surat Mohon Ulasan" CommandName="Surat" CausesValidation="False" ID="lbSurat"
                                                        Visible='<%# If(IsDBNull(Eval("AgensiID")), True, True) %>'
                                                        CssClass="btn btn-warning btn-sm" CommandArgument='<%# Container.DataItemIndex %>'></asp:LinkButton>
                                                </div>

                                            </div>

                                        </div>

                                    </div>

                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <PagerStyle CssClass="pgr" />
                    </asp:GridView>
                </div>
            </div>

        </div>
    </section>
    <asp:Button ID="ui_btnPageBottom" runat="server" Text="-" Style="margin-left: -999px;" />


    <asp:SqlDataSource ID="SqlDataSourceGrid" runat="server"
        ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
        SelectCommand="SELECT g.NamaSyarikat,a.*,d.*,e.*,f.*, g.IsSuratPemeriksaanFail,g.IsSuratPemeriksaanFail,ISNULL(g.AlamatBaru,ISNULL(g.AlamatPremis,ISNULL(g.AlamatPenjajaan,ISNULL(g.AnjingAlamat,isnull(g.LokasiPasar1,ISNULL(g.LokasiPasar2,ISNULL(g.LokasiPasar3,''))))))) as AlamatPremis, isnull(h.IsPenilaian,0) as IsPenilaianStatus 
            g.JenisLesenDescList, g.JenisLesenIdList FROM 
            v_LESEN_ApprovalListBatal_Curr a
            inner join LESEN_JenisLesen d on d.JenisLesen_ID = a.JenisLesen_ID
            left join LESEN_JabatanAgensi e on e.JabatanAgensi_ID = a.AgensiID
            inner join LESEN_Pemohon f on f.Pemohon_ID = a.Permohonan_PemohonID
            inner join LESEN_Permohonan g on g.Permohonan_ID = a.Permohonan_ID
			left join LESEN_PermohonanAgensiBatal h on h.Permohonan_ID = g.Permohonan_ID and h.JabatanAgensi_ID = 3
            where 1=1 and (
            case when @cbUlasan = 1 then 3 else a.ApprStatusID end = case when @isPenyedia = 1 then 3 else 99 end 
            or a.ApprStatusID = case when @isPenilai = 1 then 2 else 99 end
            or a.ApprStatusID = case when @isPenilai = 1 then 5 else 99 end
            or a.ApprStatusID = case when @isPenilai = 1 then 4 else 99 end
			or a.ApprStatusID = case when (@isPenilai = 1) and @isReadOnly = 1 and @cbUlasan = 1 then 3 else 99 end
            or a.ApprStatusID = case when (@isPenilai = 1 or @isPeraku = 1) and @isReadOnly = 1 and @cbUlasan = 1 then 6 else 99 end
            or a.ApprStatusID = case when (@isPenilai = 1 or @isPeraku = 1) and @isReadOnly = 1 and @cbUlasan = 1 then 7 else 99 end
            or a.ApprStatusID = case when (@isPenilai = 1 or @isPeraku = 1) and @isReadOnly = 1 and @cbUlasan = 1 then 8 else 99 end
            or a.ApprStatusID = case when (@isPenilai = 1 or @isPeraku = 1) and @isReadOnly = 1 and @cbUlasan = 1 then 9 else 99 end
            or a.ApprStatusID = case when (@isPenilai = 1 or @isPeraku = 1) and @isReadOnly = 1 and @cbUlasan = 1 then 10 else 99 end			
            or a.ApprStatusID = case when @isPeraku = 1 then 8 else 99 end
            
            )
			/*
            and case when isnull((select top 1 x.JabatanAgensi_IsLesen from LESEN_JabatanAgensi x where x.JabatanAgensi_ID = @AgensiID),0) = 1 
			or (@cbUlasan = 1 and isnull((select top 1 x.JabatanAgensi_Type from LESEN_JabatanAgensi x where x.JabatanAgensi_ID = @AgensiID),'L') = 'J' ) then isnull(a.AgensiID,@AgensiID) else isnull(a.AgensiID,0) end 
            = case when isnull((select top 1 x.JabatanAgensi_IsLesen from LESEN_JabatanAgensi x where x.JabatanAgensi_ID = @AgensiID),0) = 1 or @cbUlasan = 1 then @AgensiID else @AgensiID end
			*/
			
            and case when isnull((select top 1 x.JabatanAgensi_IsLesen from LESEN_JabatanAgensi x where x.JabatanAgensi_ID = @AgensiID),0) = 1 
			then isnull(a.AgensiID,@AgensiID) 
			when @cbUlasan = 1 and isnull((select top 1 x.JabatanAgensi_Type from LESEN_JabatanAgensi x where x.JabatanAgensi_ID = @AgensiID),'L') = 'J' 
			then IIF(a.AgensiID = @AgensiID or a.AgensiID is null,@AgensiID,0) 
			else isnull(a.AgensiID,0) end 
            = @AgensiID
			
            and isnull(g.Rujukan,'') like '%'+@Rujukan+'%'
            and g.JenisLesenDescList like case when @lesenID = '0' then g.JenisLesenDescList else '%'+@lesenID+'%' end
            and a.Permohonan_PemohonID = case when @pemohonID = 0 then a.Permohonan_PemohonID else @pemohonID end
            and g.TarikhMohon like '%'+@TarikhMohon+'%'
            and case when case when @cbUlasan = 1 then 3 else a.ApprStatusID end = 3 then 
                case when @isReadOnly = 1 then 0 else @sessionUsersId end
            else 0 end IN  
            (select x.PermohonanAgensiStaffID_UsersID 
            from LESEN_PermohonanAgensiStaffBatal x 
            inner join LESEN_PermohonanAgensiBatal x2 on x2.PermohonanAgensi_ID = x.PermohonanAgensi_ID
            where x2.Permohonan_ID = g.Permohonan_ID and x2.JabatanAgensi_ID = @AgensiID union all select 0  )       
			and case when @isReadOnly = 1 and @isPenyedia = 1 then case when a.ApprStatusID IN (1,2) then 999 else a.ApprStatusID end else a.ApprStatusID end = a.ApprStatusID
            and year(a.TarikhMohon) = case when @yearValue = 0 then year(a.TarikhMohon) else @yearValue end
            and month(a.TarikhMohon) = case when @monthValue = 0 then month(a.TarikhMohon) else @monthValue end		
			and a.ApprStatusID = case when @statusFilter = -1 then a.ApprStatusID else @statusFilter end			
            order by a.TarikhMohon"
        DeleteCommand="Update LESEN_JenisLesen set JenisLesen_IsActive = 0 WHERE JenisLesen_ID = @JenisLesen_ID">
        <DeleteParameters>
            <asp:ControlParameter ControlID="GridView1" DefaultValue="" Name="JenisLesen_ID" PropertyName="SelectedValue" />
        </DeleteParameters>

        <SelectParameters>
            <asp:SessionParameter SessionField="sessionIsPenyedia" DefaultValue="0" Name="isPenyedia"></asp:SessionParameter>
            <asp:SessionParameter SessionField="sessionIsPenilai" DefaultValue="0" Name="isPenilai"></asp:SessionParameter>
            <asp:SessionParameter SessionField="sessionIsPeraku" DefaultValue="0" Name="isPeraku"></asp:SessionParameter>
            <asp:SessionParameter SessionField="sessionEstateID" DefaultValue="0" Name="AgensiID"></asp:SessionParameter>
            <asp:SessionParameter SessionField="sessionUsersId" DefaultValue="0" Name="sessionUsersId"></asp:SessionParameter>

            <asp:ControlParameter ControlID="txtNoRujukan" PropertyName="Text" DefaultValue="%%" Name="Rujukan"></asp:ControlParameter>
            <asp:ControlParameter ControlID="DDL_JenisLesen" PropertyName="SelectedValue" Name="lesenID"></asp:ControlParameter>
            <asp:ControlParameter ControlID="ddlPemohonCari" PropertyName="SelectedValue" Name="pemohonID"></asp:ControlParameter>
            <asp:ControlParameter ControlID="TB_TarikhMohon" PropertyName="Text" DefaultValue="%%" Name="TarikhMohon"></asp:ControlParameter>

			<asp:ControlParameter ControlID="DDL_Status" PropertyName="SelectedValue" Name="statusFilter"></asp:ControlParameter>
			<asp:ControlParameter ControlID="cbAllUlasan" DefaultValue="0" Name="cbUlasan" PropertyName="Checked" />
			<asp:SessionParameter SessionField="sessionIsReadOnly" DefaultValue="0" Name="isReadOnly"></asp:SessionParameter>
			
            <asp:ControlParameter ControlID="ddlMonth" PropertyName="SelectedValue" Name="monthValue"></asp:ControlParameter>
            <asp:ControlParameter ControlID="ddlYear" PropertyName="SelectedValue" Name="yearValue"></asp:ControlParameter>			
						
        </SelectParameters>
    </asp:SqlDataSource>

    <%-- Modal Popup --%>
    <%-- Modal Overlay --%>
    <div id="modalKembaliIK" class="kik-modal-overlay">
        <div class="kik-modal-box">
            <div class="kik-modal-header">
                <span>Kembalikan Ke IK</span>
                <span class="kik-modal-close" onclick="closeModalKembaliIK();">&times;</span>
            </div>
            <div class="kik-modal-body">
                <label class="kik-label">Catatan / Remarks</label>
                <asp:TextBox ID="txtCatatanKembaliIK" runat="server" TextMode="MultiLine" 
                    Rows="4" CssClass="kik-textarea" placeholder="Sila nyatakan sebab kembalikan ke IK..." />
            </div>
            <div class="kik-modal-footer">
                <button type="button" class="kik-btn kik-btn-cancel" onclick="closeModalKembaliIK();">Batal</button>
                <asp:LinkButton ID="btnTeruskanKembaliIK" runat="server" Text="Teruskan" 
                    CssClass="kik-btn kik-btn-primary" OnClick="btnTeruskanKembaliIK_Click" 
                    CausesValidation="False" OnClientClick="return validateKembaliIK();" />
            </div>

            <%-- Senarai rujukan --%>
            <div class="kik-list-section">
                <div class="kik-list-title">Senarai Kembali Ke IK (Rujukan)</div>
                <asp:Repeater ID="rptKembaliIK" runat="server">
                    <HeaderTemplate>
                        <table class="kik-table">
                            <tr>
                                <th style="width:20%">Tarikh</th>
                                <th style="width:20%">Oleh</th>
                                <th>Catatan</th>
                            </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                            <tr>
                                <td><%# CType(Eval("CreatedDt"), DateTime).ToString("dd/MM/yyyy hh:mm tt") %></td>
                                <td><%# Eval("CreatedBy") %></td>
                                <td><%# Eval("Catatan") %></td>
                            </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                        </table>
                    </FooterTemplate>
                </asp:Repeater>
                <asp:Label ID="lblNoRecordKembaliIK" runat="server" Text="Tiada rekod." CssClass="kik-no-record" Visible="false" />
            </div>
        </div>
    </div>

    <style>
        .kik-modal-overlay {
            display: none;
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(0,0,0,0.5);
            z-index: 9999;
            justify-content: center;
            align-items: center;
        }

        .kik-modal-overlay.show {
            display: flex;
        }

        .kik-modal-box {
            background: #fff;
            width: 620px;             /* was 420px */
            max-width: 92%;
            max-height: 85vh;
            border-radius: 8px;
            box-shadow: 0 6px 24px rgba(0,0,0,0.25);
            overflow-y: auto;         /* scroll kalau list panjang */
            font-family: Arial, sans-serif;
        }

        .kik-modal-header {
            background: #f0ad4e;
            color: #fff;
            padding: 14px 18px;
            font-size: 16px;
            font-weight: bold;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 1;
        }

        .kik-modal-close {
            cursor: pointer;
            font-size: 20px;
            line-height: 1;
        }

        .kik-modal-body {
            padding: 18px;
        }

        .kik-label {
            display: block;
            margin-bottom: 6px;
            font-size: 13px;
            color: #333;
            font-weight: 600;
        }

        .kik-textarea {
            width: 100%;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 4px;
            padding: 8px;
            font-size: 14px;
            resize: vertical;
        }

        .kik-modal-footer {
            padding: 12px 18px;
            display: flex;
            justify-content: flex-end;
            gap: 8px;
            background: #f9f9f9;
            border-top: 1px solid #eee;
            border-bottom: 1px solid #eee;
        }

        .kik-btn {
            padding: 8px 16px;
            border-radius: 4px;
            border: none;
            font-size: 14px;
            cursor: pointer;
        }

        .kik-btn-cancel { background: #e0e0e0; color: #333; }
        .kik-btn-cancel:hover { background: #d0d0d0; }
        .kik-btn-primary { background: #f0ad4e; color: #fff; text-decoration: none; }
        .kik-btn-primary:hover { background: #ec971f; color: #fff; }

        /* Senarai rujukan */
        .kik-list-section {
            padding: 16px 18px 20px;
        }

        .kik-list-title {
            font-size: 13px;
            font-weight: 700;
            color: #555;
            margin-bottom: 8px;
            text-transform: uppercase;
        }

        .kik-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }

        .kik-table th {
            background: #f5f5f5;
            text-align: left;
            padding: 6px 8px;
            border-bottom: 2px solid #ddd;
            font-size: 12px;
            color: #666;
        }

        .kik-table td {
            padding: 6px 8px;
            border-bottom: 1px solid #eee;
            vertical-align: top;
        }

        .kik-no-record {
            font-size: 13px;
            color: #999;
            font-style: italic;
        }
    </style>

<script>
    function closeModalKembaliIK() {
        document.getElementById('modalKembaliIK').classList.remove('show');
    }

    function validateKembaliIK() {
        var txt = document.getElementById('<%= txtCatatanKembaliIK.ClientID %>').value.trim();
        if (txt === "") {
            alert('Sila isi catatan sebelum teruskan.');
            return false;
        }
        return confirm('Anda pasti untuk kembalikan rekod ini ke pegawai IK?');
    }
</script>

    <script>

        function pageLoad() {

            $("#ctl00_ContentPlaceHolder1_LabelAttributes1_TabContainer1").css({ 'width': 400, 'height': 400 });

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

