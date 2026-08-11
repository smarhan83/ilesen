<%@ Page Title="" Language="VB" MaintainScrollPositionOnPostBack="true" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="sepandukSemakanIK.aspx.vb" Inherits="sepandukSemakanIK" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="asp" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadContent" runat="Server">
<style>
    /* =====================================================================
       DESIGN TOKENS - Semakan Sepanduk
       Tema: pemeriksaan/pematuhan lapangan - deep teal (kepercayaan/rasmi)
       + amber (perhatian/tindakan pending), rounded cards untuk rasa "app"
    ===================================================================== */
    :root{
        --sp-primary:#164B60;
        --sp-primary-dark:#0E3746;
        --sp-primary-light:#2E86AB;
        --sp-accent:#E8A33D;
        --sp-success:#2F9E5B;
        --sp-success-bg:#E7F6EC;
        --sp-danger:#D64545;
        --sp-danger-bg:#FCEAEA;
        --sp-warning:#B6790C;
        --sp-warning-bg:#FDF1DC;
        --sp-neutral:#5B6B73;
        --sp-neutral-bg:#EEF2F3;
        --sp-bg:#F4F7F8;
        --sp-surface:#FFFFFF;
        --sp-text:#fff;
        --sp-text-muted:#66787F;
        --sp-border:#E1E8EA;
        --sp-radius:14px;
        --sp-radius-sm:10px;
        --sp-shadow:0 2px 10px rgba(15,45,55,.06);
        --sp-shadow-lift:0 8px 24px rgba(15,45,55,.14);
    }

    .sp-shell{ background:var(--sp-bg); }
    .sp-shell .card{
        border:1px solid var(--sp-border);
        border-radius:var(--sp-radius);
        box-shadow:var(--sp-shadow);
    }
    .sp-shell .card-header{
        background:var(--sp-surface);
        border-bottom:1px solid var(--sp-border);
        border-radius:var(--sp-radius) var(--sp-radius) 0 0 !important;
        padding:16px 18px;
    }
    .sp-shell .card-header .card-title{
        font-weight:700;
        color:var(--sp-text);
        font-size:1.05rem;
    }
    .sp-shell .card-primary.card-header,
    .sp-shell .card.card-primary > .card-header{
        background:var(--sp-primary);
    }
    .sp-shell .card.card-primary > .card-header .card-title{ color:#fff; }
    .sp-shell .card.card-info > .card-header{ background:var(--sp-primary-light); }
    .sp-shell .card.card-info > .card-header .card-title{ color:#fff; }

    /* ---------- Header ringkas modul ---------- */
    .sp-page-title{
        font-weight:800;
        color:var(--sp-primary-dark);
        letter-spacing:-.01em;
    }
    .sp-page-subtitle{
        color:var(--sp-text-muted);
        font-size:.9rem;
    }

    /* ---------- Status pill (dibina via JS ikut teks status) ---------- */
    .status-pill{
        display:inline-block;
        padding:4px 12px;
        border-radius:999px;
        font-size:.78rem;
        font-weight:700;
        white-space:nowrap;
    }
    .badge-pending{ background:var(--sp-neutral-bg); color:var(--sp-neutral); }
    .badge-warning{ background:var(--sp-warning-bg); color:var(--sp-warning); }
    .badge-success{ background:var(--sp-success-bg); color:var(--sp-success); }
    .badge-danger{ background:var(--sp-danger-bg); color:var(--sp-danger); }

    /* ---------- Butang utama ---------- */
    .sp-shell .btn-primary{
        background:var(--sp-primary);
        border-color:var(--sp-primary);
        font-weight:600;
        border-radius:var(--sp-radius-sm);
    }
    .sp-shell .btn-primary:hover{ background:var(--sp-primary-dark); border-color:var(--sp-primary-dark); }
    .sp-shell .btn-default{
        border-radius:var(--sp-radius-sm);
        border-color:var(--sp-border);
        font-weight:600;
        color:var(--sp-text);
    }
    .sp-shell .btn-warning{ border-radius:var(--sp-radius-sm); font-weight:600; }
    .sp-shell .btn-info{ background:var(--sp-primary-light); border-color:var(--sp-primary-light); border-radius:var(--sp-radius-sm); }
    .sp-shell .btn-danger{ border-radius:var(--sp-radius-sm); }

    /* ---------- "+ Tambah Semakan Baharu" - jadi FAB kat mobile ---------- */
    #btnTambahSemakan{
        display:inline-flex;
        align-items:center;
        gap:8px;
        border-radius:999px;
        background:var(--sp-accent);
        border-color:var(--sp-accent);
        color:#3A2A08;
        font-weight:700;
        padding:8px 18px;
    }
    #btnTambahSemakan:hover{ background:#d6922f; color:#3A2A08; }
    #btnTambahSemakan .sp-fab-icon{ font-size:1.1rem; line-height:1; }
    #btnTambahSemakan .sp-fab-label{ }

    /* ---------- Step indicator (flow Pegawai IK) ---------- */
    .sp-steps{
        display:flex;
        align-items:center;
        justify-content:center;
        gap:6px;
        padding:14px 10px 4px;
    }
    .sp-step{
        display:flex;
        flex-direction:column;
        align-items:center;
        gap:6px;
        flex:1;
        max-width:120px;
    }
    .sp-step-dot{
        width:30px; height:30px;
        border-radius:50%;
        display:flex; align-items:center; justify-content:center;
        font-weight:700; font-size:.85rem;
        background:var(--sp-neutral-bg); color:var(--sp-neutral);
        border:2px solid var(--sp-border);
    }
    .sp-step.is-active .sp-step-dot{ background:var(--sp-primary); border-color:var(--sp-primary); color:#fff; }
    .sp-step.is-done .sp-step-dot{ background:var(--sp-success); border-color:var(--sp-success); color:#fff; }
    .sp-step-label{ font-size:.72rem; color:var(--sp-text-muted); font-weight:600; text-align:center; }
    .sp-step.is-active .sp-step-label{ color:var(--sp-primary); }
    .sp-step-line{ flex:0 0 30px; height:2px; background:var(--sp-border); margin-top:-20px; }

    /* ---------- Info list (Butiran Semakan) ---------- */
    .info-item{
        display:flex;
        justify-content:space-between;
        gap:12px;
        padding:10px 0;
        border-bottom:1px solid var(--sp-border);
    }
    .info-item:last-child{ border-bottom:none; }
    .info-label{ color:var(--sp-text-muted); font-size:.85rem; flex:0 0 40%; }
    .info-value{ color:var(--sp-text); font-weight:600; text-align:right; flex:1; }

    /* ---------- Callouts ---------- */
    .sp-shell .callout{ border-radius:var(--sp-radius-sm); }

    /* ---------- Sticky bottom action bar (form panel) - mobile ---------- */
    .sp-sticky-actions{
        position:sticky;
        bottom:0;
        background:var(--sp-surface);
        border-top:1px solid var(--sp-border);
        padding:12px 16px;
        z-index:20;
    }

    /* =====================================================================
       MOBILE (<= 768px)
    ===================================================================== */
    @media (max-width: 768px){

        .sp-page-title{ font-size:1.15rem; }

        /* Listing: table -> card list, guna urutan kolum sedia ada
           (0 ID, 1 NoRujukan, 2 JenisKes, 3 NamaSyarikat, 4 Lokasi, 5 Tarikh, 6 Status, 7 Aksi) */
        #idListing .table thead{ display:none; }
        #idListing .table, #idListing .table tbody, #idListing .table tr, #idListing .table td{
            display:block; width:100%;
        }
        #idListing .table{ border:none; }
        #idListing .table tr{
            background:var(--sp-surface);
            border:1px solid var(--sp-border);
            border-radius:var(--sp-radius);
            box-shadow:var(--sp-shadow);
            padding:12px 14px;
            margin-bottom:12px;
        }
        #idListing .table td{
            display:flex; justify-content:space-between; align-items:center;
            padding:5px 0; border:none; text-align:right;
        }
        #idListing .table td:nth-child(1){ display:none; } /* sembunyikan ID teknikal */
        #idListing .table td:nth-child(2)::before{ content:"No Rujukan"; }
        #idListing .table td:nth-child(3)::before{ content:"Jenis Kes"; }
        #idListing .table td:nth-child(4)::before{ content:"Syarikat"; }
        #idListing .table td:nth-child(5)::before{ content:"Lokasi"; }
        #idListing .table td:nth-child(6)::before{ content:"Tarikh"; }
        #idListing .table td:nth-child(7)::before{ content:"Status"; }
        #idListing .table td:nth-child(8){ justify-content:flex-end; padding-top:10px; }
        #idListing .table td::before{
            content:attr(data-lbl);
            font-size:.75rem; font-weight:700; color:var(--sp-text-muted);
            text-align:left;
        }
        #idListing .table td:nth-child(8) .btn{ width:100%; border-radius:var(--sp-radius-sm); }

        /* FAB kat mobile */
        #btnTambahSemakan{
            position:fixed;
            right:18px;
            bottom:18px;
            z-index:1030;
            width:58px; height:58px;
            padding:0;
            box-shadow:var(--sp-shadow-lift);
        }
        #btnTambahSemakan .sp-fab-label{ display:none; }
        #btnTambahSemakan .sp-fab-icon{ font-size:1.6rem; }

        .sp-sticky-actions .btn{ width:100%; margin-bottom:8px; }
        .sp-sticky-actions .btn:last-child{ margin-bottom:0; }

        .info-value{ text-align:right; }

        .sp-step-label{ font-size:.65rem; }
    }
</style>

<style>
    .btn-tambah-semakan {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 9px 16px;
    border-radius: 8px;
    font-size: 14px;
    font-weight: 500;
    line-height: 1;
    text-decoration: none !important;
    transition: all 0.2s ease;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.08);
}

.btn-tambah-semakan:hover {
    transform: translateY(-1px);
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.12);
}

.btn-tambah-semakan:active {
    transform: translateY(0);
}

.btn-tambah-icon {
    width: 22px;
    height: 22px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
    background: rgba(255, 255, 255, 0.2);
    font-size: 18px;
    font-weight: 400;
}
</style>

<link rel="stylesheet" href="<%= ResolveUrl("~/css/sepanduk-css.css") %>">

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">
<div class="sp-shell">

    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0 sp-page-title"><div runat="server" id="idWindowTitle">Semakan Sepanduk</div></h1>
                    <%--<div class="sp-page-subtitle">Sepanduk / Bunting / Sepanduk Besar</div>--%>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <%= GlobalClass.writeBreadcrumb(Request.QueryString("p_Id"), Request.QueryString("m_Id"), Session.Item("sessionSystemId")) %>
                    </ol>
                </div>
            </div>
        </div>
    </section>

    <section class="content">
        <div class="container-fluid">

            <%--# =========================== SENARAI (LISTING) =========================== #--%>
            <div class="card" runat="server" id="idListing">
                <div class="d-flex justify-content-end mb-3">
                    <asp:LinkButton ID="btnTambahSemakan"
                        runat="server"
                        CssClass="btn btn-primary btn-tambah-semakan">
                        <span class="btn-tambah-icon">+</span>
                        <span>Tambah Semakan Baharu</span>
                    </asp:LinkButton>
                </div>
                <div class="card-body" style="overflow-x: auto;">
                    <div class="row">
                        <div class="col-md-12">
                            <asp:CheckBox ID="chkAll" AutoPostBack="True" runat="server" Text="Semua Rekod" />
                        </div>
                    </div>
                    <%--# START FILTER #--%>
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
                    <div class="result-table-wrapper">
                    <asp:GridView ID="GridView1" runat="server"
                        AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="SemakanIK_ID"
                        DataSourceID="SqlDataSourceGridSemakan"
                        AllowPaging="True" PageSize="20"
                        CssClass="modern-grid" PagerStyle-CssClass="pgr"
                        AlternatingRowStyle-CssClass="alt" Width="100%"
                        OnRowCreated="GridViewCarian_RowCreated"
                        >
                        <AlternatingRowStyle CssClass="alt" />
                        <Columns>
                            <asp:TemplateField HeaderText="Bil." ItemStyle-Width="60px">
                                <ItemTemplate>
                                    <%# (GridView1.PageIndex * GridView1.PageSize) + Container.DisplayIndex + 1 %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="SemakanIK_NoRujukan" HeaderText="No Rujukan" SortExpression="SemakanIK_NoRujukan" />
                            <asp:BoundField DataField="SemakanIK_StatusLesen" HeaderText="Jenis Kes" SortExpression="SemakanIK_StatusLesen" />
                            <asp:BoundField DataField="SemakanIK_NamaSyarikat" HeaderText="Nama Syarikat" SortExpression="SemakanIK_NamaSyarikat" />
                            <asp:BoundField DataField="SemakanIK_AlamatLokasi" HeaderText="Lokasi" SortExpression="SemakanIK_AlamatLokasi" />
                            <asp:BoundField DataField="SemakanIK_TarikhSemakan" HeaderText="Tarikh Semakan" DataFormatString="{0:dd/MM/yyyy}" SortExpression="SemakanIK_TarikhSemakan" />
                            <asp:BoundField DataField="SemakanIK_Status" HeaderText="Status" SortExpression="SemakanIK_Status" />
                            <asp:TemplateField ShowHeader="False">
                                <ItemTemplate>
                                    <asp:LinkButton
                                        runat="server"
                                        Text="Lihat &rsaquo;"
                                        CommandName="Select"
                                        CausesValidation="False"
                                        ID="LinkButton2"
                                        CssClass='<%# If(CanSemak(Eval("SemakanIK_Status")), "btn btn-warning btn-sm", "btn btn-primary btn-sm") %>'
                                        ><%--Visible='<%# CanSemak(Eval("SemakanIK_Status")) %>'--%>
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <PagerStyle CssClass="pgr" />
                        <EmptyDataTemplate>
                            <div class="text-center text-muted py-4">Tiada rekod semakan buat masa ini.</div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                    </div>
                </div>
            </div>

            <asp:SqlDataSource ID="SqlDataSourceGridSemakan" runat="server"
                ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                SelectCommand="SELECT * FROM (
                                    SELECT * FROM LESEN_SepandukSemakanIK
                                    WHERE IsActive = 1
                                    AND SemakanIK_Status IN ('Semakan KB Inspektorat','Semakan KB Lesen','Perakuan KJ Lesen','Kemaskini Kewangan')
                               ) as TBL1
                               WHERE 1=1
                                AND
                                (
                                    -- LEVEL 0.5
                                    (
                                        @sessionIsPenyedia = 1
                                        AND @sessionEstateID = 3
                                        AND SemakanIK_Status IN (
                                            'Semakan KB Inspektorat',
                                            'Semakan KB Lesen',
                                            'Perakuan KJ Lesen',
                                            'Kemaskini Kewangan'
                                        )
                                    )

                                    OR
                                    -- LEVEL 1
                                    (
                                        @sessionIsPenilai = 1
                                        AND @sessionEstateID = 3
                                        AND SemakanIK_Status IN (
                                            'Semakan KB Inspektorat',
                                            'Semakan KB Lesen',
                                            'Perakuan KJ Lesen',
                                            'Kemaskini Kewangan'
                                        )
                                    )

                                    OR

                                    -- LEVEL 2
                                    (
                                        @sessionIsPenilai = 1
                                        AND @sessionEstateID = 1
                                        AND SemakanIK_Status IN (
                                            'Semakan KB Lesen',
                                            'Perakuan KJ Lesen',
                                            'Kemaskini Kewangan'
                                        )
                                    )

                                    OR

                                    -- LEVEL 3
                                    (
                                        @sessionIsPeraku = 1
                                        AND @sessionEstateID = 1
                                        AND SemakanIK_Status IN (
                                            'Perakuan KJ Lesen',
                                            'Kemaskini Kewangan'
                                        )
                                    )

                                    OR

                                    -- LEVEL 4
                                    (
                                        @sessionEstateID = 1
                                        AND @sessionIsPeraku &lt;&gt; 1
                                        AND @sessionIsPenilai &lt;&gt; 1
                                        AND SemakanIK_Status = 'Kemaskini Kewangan'
                                    )
                                )
                               AND 
                               (
                                   @chkAll = 1
                                   OR (
                                        (SemakanIK_Status = 'Semakan KB Inspektorat' AND @sessionIsPenyedia = 1 AND @sessionEstateID = 3)
                                        OR
                                        (SemakanIK_Status = 'Semakan KB Inspektorat' AND @sessionIsPenilai = 1 AND @sessionEstateID = 3)
                                        OR
                                        (SemakanIK_Status = 'Semakan KB Lesen' AND @sessionIsPenilai = 1 AND @sessionEstateID = 1)
                                        OR
                                        (SemakanIK_Status = 'Perakuan KJ Lesen' AND @sessionIsPeraku = 1 AND @sessionEstateID = 1)
                                        OR
				                        (SemakanIK_Status = 'Kemaskini Kewangan' AND @sessionEstateID = 1 AND @sessionIsPeraku &lt;&gt; 1 AND @sessionIsPenilai &lt;&gt; 1)
                                    )
                               )
                               ORDER BY SemakanIK_ID DESC">
                <SelectParameters>
                    <asp:SessionParameter SessionField="sessionIsPenyedia" DefaultValue="0" Name="sessionIsPenyedia"></asp:SessionParameter>
                    <asp:SessionParameter SessionField="sessionIsPenilai" DefaultValue="0" Name="sessionIsPenilai"></asp:SessionParameter>
                    <asp:SessionParameter SessionField="sessionIsPeraku" DefaultValue="0" Name="sessionIsPeraku"></asp:SessionParameter>
                    <%--# TODO: sahkan session field sebenar untuk Kerani Lesen, contoh sementara "sessionIsKerani" #--%>
                    <asp:SessionParameter SessionField="sessionIsKerani" DefaultValue="0" Name="sessionIsKerani"></asp:SessionParameter>
                    <asp:SessionParameter SessionField="sessionEstateID" DefaultValue="0" Name="sessionEstateID"></asp:SessionParameter>
                    <asp:ControlParameter
                        Name="chkAll"
                        ControlID="chkAll"
                        PropertyName="Checked"
                        Type="Boolean"
                        DefaultValue="False" />
                </SelectParameters>
            </asp:SqlDataSource>


            <%--# =========================================================================================== #--%>
            <%--# PANEL 1: PEGAWAI IK - CARIAN / SCAN QR SEPANDUK                                              #--%>
            <%--# =========================================================================================== #--%>
            <asp:Panel ID="pnlCarian" runat="server" Visible="false">

            <div class="search-page">

                <!-- ================= STEP INDICATOR ================= -->
                <div class="search-steps">

                    <div class="step active">
                        <div class="step-number">1</div>
                        <div class="step-label">Carian</div>
                    </div>

                    <div class="step-line"></div>

                    <div class="step">
                        <div class="step-number">2</div>
                        <div class="step-label">Rekod</div>
                    </div>

                    <div class="step-line"></div>

                    <div class="step">
                        <div class="step-number">3</div>
                        <div class="step-label">Hantar</div>
                    </div>

                </div>


                <!-- ================= MAIN CARD ================= -->
                <div class="search-card">

                    <!-- HEADER -->
                    <div class="search-card-header">

                        <div class="search-header-icon">
                            <i class="bi bi-qr-code-scan"></i>
                        </div>

                        <div>
                            <h4>Semak Status Lesen Sepanduk</h4>
                            <p>
                                Cari dan semak status pendaftaran lesen sepanduk dengan mudah.
                            </p>
                        </div>

                    </div>


                    <!-- BODY -->
                    <div class="search-card-body">

                        <!-- ================= QR SEARCH ================= -->
                        <div class="search-section">

                            <div class="section-title">
                                <i class="bi bi-qr-code"></i>
                                Imbas Kod QR
                            </div>

                            <div class="section-description">
                                Imbas kod QR untuk carian pantas
                            </div>

                            <div class="qr-search-row">

                                <div class="search-input-wrapper">

                                    <i class="bi bi-qr-code-scan input-icon"></i>

                                    <asp:TextBox
                                        ID="txtQRCode"
                                        runat="server"
                                        CssClass="modern-input"
                                        placeholder="Imbas / taip kod QR" />

                                </div>

                                <asp:Button
                                    ID="btnScanQR"
                                    runat="server"
                                    CssClass="btn-modern btn-blue"
                                    Text="Semak QR"
                                    CausesValidation="False" />

                            </div>

                        </div>


                        <!-- ================= DIVIDER ================= -->
                        <div class="search-divider">
                            <span>ATAU</span>
                        </div>


                        <!-- ================= MANUAL SEARCH ================= -->
                        <div class="search-section">

                            <div class="section-title">
                                <i class="bi bi-search"></i>
                                Carian Manual
                            </div>

                            <div class="section-description">
                                Cari mengikut No Pendaftaran / Nama Syarikat / Alamat / No Rujukan
                            </div>

                            <div class="manual-search-row">

                                <div class="search-input-wrapper">

                                    <i class="bi bi-search input-icon"></i>

                                    <asp:TextBox
                                        ID="txtCarian"
                                        runat="server"
                                        CssClass="modern-input"
                                        placeholder="No Pendaftaran / Nama Syarikat / Alamat / No Rujukan" />

                                </div>

                                <asp:Button
                                    ID="btnCariManual"
                                    runat="server"
                                    CssClass="btn-modern btn-search"
                                    Text="Cari"
                                    CausesValidation="False" />

                            </div>

                        </div>


                        <!-- ================= RESULT ================= -->
                        <div class="result-section">

                            <div class="result-header">

                                <div>
                                    <div class="result-title">
                                        <i class="bi bi-list-ul"></i>
                                        Rekod Dijumpai
                                    </div>

                                    <div class="result-subtitle">
                                        Pilih rekod untuk melihat maklumat lanjut
                                    </div>
                                </div>

                            </div>


                            <div class="result-table-wrapper">

                                <asp:GridView
                                    ID="GridViewCarian"
                                    runat="server"
                                    AutoGenerateColumns="False"
                                    DataKeyNames="Permohonan_ID"
                                    CssClass="modern-grid"
                                    OnRowCreated="GridViewCarian_RowCreated"
                                    Width="100%">

                                    <Columns>

                                        <asp:BoundField
                                            DataField="Permohonan_ID"
                                            HeaderText="ID" />

                                        <asp:BoundField
                                            DataField="NamaSyarikat"
                                            HeaderText="Nama Syarikat" />

                                        <asp:BoundField
                                            DataField="NoPendaftaran"
                                            HeaderText="No Pendaftaran" />

                                        <asp:BoundField
                                            DataField="AlamatPremis"
                                            HeaderText="Alamat" />

                                        <asp:BoundField
                                            DataField="TarikhSuratKelulusan"
                                            HeaderText="Tarikh Lulus"
                                            DataFormatString="{0:dd/MM/yyyy}" />

                                        <asp:TemplateField
                                            HeaderText="">

                                            <ItemTemplate>

                                                <asp:LinkButton
                                                    runat="server"
                                                    ID="lnkPilihRekod"
                                                    Text="Pilih"
                                                    CommandName="PilihRekod"
                                                    CommandArgument='<%# Eval("Permohonan_ID") %>'
                                                    CausesValidation="False"
                                                    CssClass="btn-modern btn-select">

                                                    <i class="bi bi-chevron-right"></i>

                                                </asp:LinkButton>

                                            </ItemTemplate>

                                        </asp:TemplateField>

                                    </Columns>

                                    <EmptyDataTemplate>

                                        <div class="empty-state">

                                            <div class="empty-icon">
                                                <%--<i class="bi bi-file-earmark-search"></i>--%>
                                        <div class="empty-state-icon-svg">
                                            <svg viewBox="0 0 240 220" xmlns="http://www.w3.org/2000/svg">
                                              <!-- decorative plus / dot marks -->
                                              <g stroke="#c7d5e8" stroke-width="3" stroke-linecap="round">
                                                <path d="M35 60 h14 M42 53 v14" />
                                                <path d="M205 55 h14 M212 48 v14" />
                                                <path d="M215 120 h12 M221 114 v12" />
                                              </g>
                                              <circle cx="30" cy="115" r="4" fill="none" stroke="#c7d5e8" stroke-width="3"/>
                                              <circle cx="185" cy="80" r="2.5" fill="#c7d5e8"/>
                                              <circle cx="198" cy="145" r="2.5" fill="#c7d5e8"/>

                                              <!-- clipboard shadow -->
                                              <rect x="58" y="42" width="110" height="140" rx="12" fill="#e8edf5"/>

                                              <!-- clipboard body -->
                                              <rect x="52" y="36" width="110" height="140" rx="12" fill="#ffffff" stroke="#c7d5e8" stroke-width="3"/>

                                              <!-- clip at top -->
                                              <rect x="87" y="26" width="40" height="20" rx="6" fill="#3d5a80" stroke="#3d5a80" stroke-width="2"/>
                                              <circle cx="107" cy="36" r="5" fill="#ffffff"/>

                                              <!-- text lines -->
                                              <g stroke="#c7d5e8" stroke-width="6" stroke-linecap="round">
                                                <line x1="72" y1="70" x2="132" y2="70"/>
                                                <line x1="72" y1="86" x2="140" y2="86"/>
                                                <line x1="72" y1="102" x2="120" y2="102"/>
                                                <line x1="72" y1="118" x2="140" y2="118"/>
                                                <line x1="72" y1="134" x2="110" y2="134"/>
                                              </g>

                                              <!-- magnifying glass -->
                                              <circle cx="150" cy="130" r="32" fill="#eaf1fb" stroke="#3d5a80" stroke-width="6"/>
                                              <line x1="173" y1="153" x2="196" y2="176" stroke="#3d5a80" stroke-width="8" stroke-linecap="round"/>
                                            </svg>
                                        </div>
                                            </div>

                                            <div class="empty-title">
                                                Tiada rekod dijumpai
                                            </div>

                                            <div class="empty-description">
                                                Sila masukkan kod QR atau kata kunci carian
                                                untuk mencari rekod.
                                            </div>

                                        </div>

                                    </EmptyDataTemplate>

                                </asp:GridView>

                            </div>

                        </div>

                    </div>


                    <!-- ================= FOOTER ================= -->
                    <div class="search-card-footer">

                        <asp:Button
                            ID="btnTiadaRekod"
                            runat="server"
                            CssClass="btn-modern btn-warning-modern"
                            Text="Tiada Rekod / Tidak Berdaftar - Teruskan"
                            CausesValidation="False" />

                        <asp:Button
                            ID="btnBatalCarian"
                            runat="server"
                            CssClass="btn-modern btn-back"
                            Text="Kembali"
                            CausesValidation="False" />

                    </div>

                </div>

            </div>

                <%--<div class="sp-steps">
                    <div class="sp-step is-active"><div class="sp-step-dot">1</div><div class="sp-step-label">Carian</div></div>
                    <div class="sp-step-line"></div>
                    <div class="sp-step"><div class="sp-step-dot">2</div><div class="sp-step-label">Rekod</div></div>
                    <div class="sp-step-line"></div>
                    <div class="sp-step"><div class="sp-step-dot">3</div><div class="sp-step-label">Hantar</div></div>
                </div>--%>


                <%--<div class="card card-info">
                    <div class="card-header">
                        <h3 class="card-title">Semak Status Lesen Sepanduk</h3>
                    </div>
                    <div class="card-body">

                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>Imbas Kod QR</label>
                                    <div class="input-group">
                                        <asp:TextBox ID="txtQRCode" runat="server" CssClass="form-control" placeholder="Imbas / taip kod QR" />
                                        <div class="input-group-append">
                                            <asp:Button ID="btnScanQR" runat="server" CssClass="btn btn-info" Text="Semak QR" CausesValidation="False" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <hr />
                        <p class="text-muted">Jika tiada QR, sila cari secara manual mengikut No Pendaftaran / Nama Syarikat / Alamat / No Rujukan:</p>

                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>Kata Kunci Carian</label>
                                    <asp:TextBox ID="txtCarian" runat="server" CssClass="form-control" placeholder="No Pendaftaran / Nama Syarikat / Alamat / Rujukan" />
                                </div>
                            </div>
                            <div class="col-md-2">
                                <div class="form-group">
                                    <label class="d-none d-md-block">&nbsp;</label>
                                    <asp:Button ID="btnCariManual" runat="server" CssClass="btn btn-default btn-block" Text="Cari" CausesValidation="False" />
                                </div>
                            </div>
                        </div>

                        <asp:GridView ID="GridViewCarian" runat="server" AutoGenerateColumns="False"
                            DataKeyNames="Permohonan_ID" CssClass="table table-bordered" Width="100%">
                            <Columns>
                                <asp:BoundField DataField="Permohonan_ID" HeaderText="ID" />
                                <asp:BoundField DataField="NamaSyarikat" HeaderText="Nama Syarikat" />
                                <asp:BoundField DataField="NoPendaftaran" HeaderText="No Pendaftaran" />
                                <asp:BoundField DataField="AlamatPremis" HeaderText="Alamat" />
                                <asp:BoundField DataField="TarikhSuratKelulusan" HeaderText="Tarikh Lulus" DataFormatString="{0:dd/MM/yyyy}" />
                                <asp:TemplateField ShowHeader="False">
                                    <ItemTemplate>
                                        <asp:LinkButton runat="server" ID="lnkPilihRekod" Text="Pilih" CommandName="PilihRekod"
                                            CommandArgument='<%# Eval("Permohonan_ID") %>' CausesValidation="False" CssClass="btn btn-primary btn-sm" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>Tiada rekod dijumpai.</EmptyDataTemplate>
                        </asp:GridView>

                        <div class="card-footer bg-white border-0 px-0 d-flex flex-wrap gap-2">
                            <asp:Button ID="btnTiadaRekod" runat="server" CssClass="btn btn-warning mr-2 mb-2" Text="Tiada Rekod / Tidak Berdaftar - Teruskan" CausesValidation="False" />
                            <asp:Button ID="btnBatalCarian" runat="server" CssClass="btn btn-default mb-2" Text="Kembali" CausesValidation="False" />
                        </div>

                    </div>
                </div>--%>
            </asp:Panel>


            <%--# =========================================================================================== #--%>
            <%--# PANEL 2: PEGAWAI IK - REKOD ULASAN / PEMERHATIAN + LAMPIRAN                                   #--%>
            <%--# =========================================================================================== #--%>
            <asp:Panel ID="pnlRekodSemakan" runat="server" Visible="false">

                <div class="search-steps">

                    <div class="step active">
                        <div class="step-number">1</div>
                        <div class="step-label">Carian</div>
                    </div>

                    <div class="step-line"></div>

                    <div class="step">
                        <div class="step-number">2</div>
                        <div class="step-label">Rekod</div>
                    </div>

                    <div class="step-line"></div>

                    <div class="step">
                        <div class="step-number">3</div>
                        <div class="step-label">Hantar</div>
                    </div>

                </div>

<div class="ru-wrap">

    <%--# Header banner #--%>
    <div class="ru-header">
        <div class="ru-header-icon">
            <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                <path d="M14 2v6h6"></path>
                <path d="M9 15l2 2 4-4"></path>
            </svg>
        </div>
        <div class="ru-header-text">
            <h3><asp:Literal ID="litTajukRekod" runat="server" Text="Rekod Ulasan - Lesen Tamat Tempoh" /></h3>
            <p>Semak dan rekod ulasan pemeriksaan permit.</p>
        </div>

        <svg class="ru-header-illustration" width="150" height="110" viewBox="0 0 150 110" aria-hidden="true">
            <rect x="30" y="10" width="60" height="80" rx="6" fill="#ffffff" opacity="0.14"></rect>
            <rect x="30" y="10" width="60" height="80" rx="6" fill="none" stroke="#ffffff" stroke-opacity="0.55" stroke-width="2"></rect>
            <line x1="42" y1="28" x2="78" y2="28" stroke="#ffffff" stroke-opacity="0.55" stroke-width="2"></line>
            <line x1="42" y1="40" x2="78" y2="40" stroke="#ffffff" stroke-opacity="0.55" stroke-width="2"></line>
            <line x1="42" y1="52" x2="64" y2="52" stroke="#ffffff" stroke-opacity="0.55" stroke-width="2"></line>
            <path d="M46 68l8 8 18-18" stroke="#a7f3d0" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" fill="none"></path>
            <circle cx="108" cy="72" r="24" fill="#ffffff" opacity="0.16"></circle>
            <circle cx="108" cy="72" r="24" fill="none" stroke="#ffffff" stroke-width="3"></circle>
            <path d="M126 90 L140 104" stroke="#ffffff" stroke-width="5" stroke-linecap="round"></path>
        </svg>
    </div>

    <div class="ru-body">

        <%--# maklumat ringkas (jika rekod dijumpai) #--%>
        <asp:Panel ID="pnlMaklumatDijumpai" runat="server" Visible="false" CssClass="ru-info-grid">
            <div class="ru-info-item">
                <div class="ru-info-icon">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 21h18M6 21V7l6-4 6 4v14M9 9h1m4 0h1m-6 4h1m4 0h1m-6 4h1m4 0h1"/></svg>
                </div>
                <div>
                    <span class="ru-info-label">Nama syarikat</span>
                    <span class="ru-info-value"><asp:Literal ID="litNamaSyarikat" runat="server" /></span>
                </div>
            </div>
            <div class="ru-info-item">
                <div class="ru-info-icon">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="16" rx="2"/><path d="M7 2v4M17 2v4M3 10h18"/></svg>
                </div>
                <div>
                    <span class="ru-info-label">No pendaftaran</span>
                    <span class="ru-info-value"><asp:Literal ID="litNoPendaftaran" runat="server" /></span>
                </div>
            </div>
            <div class="ru-info-item">
                <div class="ru-info-icon">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="16" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/></svg>
                </div>
                <div>
                    <span class="ru-info-label">Tarikh luput</span>
                    <span class="ru-info-value"><asp:Literal ID="litTarikhLuput" runat="server" /></span>
                </div>
            </div>
        </asp:Panel>

        <%--# Alamat lokasi pemeriksaan #--%>
        <div class="ru-section">
            <div class="ru-section-head">
                <div class="ru-section-icon">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 6-9 12-9 12s-9-6-9-12a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                </div>
                <h4 class="ru-section-title">Alamat lokasi pemeriksaan</h4>
            </div>
            <div class="ru-alamat-wrap">
                <asp:TextBox ID="txtAlamatLokasi" runat="server" CssClass="ru-field" TextMode="MultiLine" Rows="3" />
                <asp:RequiredFieldValidator runat="server" ID="rfvAlamat" ControlToValidate="txtAlamatLokasi"
                    ErrorMessage="Sila isi alamat lokasi" CssClass="cssRequiredField" Display="Dynamic" ValidationGroup="frmRekodSemakan" />
            </div>
        </div>

        <%--# Ulasan pemeriksaan #--%>
        <div class="ru-section">
            <div class="ru-section-head">
                <div class="ru-section-icon">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
                </div>
                <h4 class="ru-section-title"><asp:Literal ID="litJenisCatatan" runat="server" Text="Ulasan pemeriksaan" /></h4>
            </div>
            <p class="ru-section-sub">Tambah ulasan atau catatan pemeriksaan yang berkaitan.</p>

            <%--# senarai ulasan/pemerhatian yang sudah ditambah (sebelum hantar) #--%>
            <asp:GridView ID="GridViewUlasanSementara" runat="server" AutoGenerateColumns="False"
                CssClass="ru-list" GridLines="None" Width="100%">
                <HeaderStyle CssClass="ru-list-header" />
                <Columns>
                    <asp:BoundField DataField="Catatan" HeaderText="Catatan" />
                    <asp:TemplateField ShowHeader="False" ItemStyle-Width="90px" ItemStyle-HorizontalAlign="Right">
                        <ItemTemplate>
                            <asp:LinkButton runat="server" ID="lnkBuangUlasan" Text="Buang" CommandName="BuangUlasan"
                                CommandArgument='<%# Container.DataItemIndex %>' CausesValidation="False" CssClass="ru-btn-danger-sm" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <div class="ru-list-empty">
                        <div class="ru-list-empty-icon">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
                        </div>
                        <p class="ru-list-empty-title">Tiada ulasan dijumpai.</p>
                        <p class="ru-list-empty-sub">Belum ada catatan ditambah.</p>
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>

            <div class="ru-row-add">
                <asp:TextBox ID="txtCatatanBaru" runat="server" CssClass="ru-textarea" TextMode="MultiLine" Rows="2" placeholder="Taip catatan ulasan di sini..." />
                <asp:Button ID="btnTambahUlasan" runat="server" CssClass="ru-btn-primary" Text="+ Tambah ulasan" CausesValidation="False" />
            </div>
        </div>

        <%--# Lampiran #--%>
        <div class="ru-section">
            <div class="ru-section-head">
                <div class="ru-section-icon">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21.44 11.05l-9.19 9.19a5.5 5.5 0 0 1-7.78-7.78l9.19-9.19a3.5 3.5 0 0 1 4.95 4.95l-9.2 9.19a1.5 1.5 0 0 1-2.12-2.12l8.49-8.48"/></svg>
                </div>
                <h4 class="ru-section-title">Lampiran</h4>
            </div>
            <p class="ru-section-sub">Muat naik dokumen sokongan berkaitan (jika ada).</p>

            <asp:GridView ID="GridViewLampiranSementara" runat="server" AutoGenerateColumns="False"
                CssClass="ru-list" GridLines="None" Width="100%">
                <Columns>
                    <asp:BoundField DataField="FileName" HeaderText="Nama fail" />
                    <asp:TemplateField ShowHeader="False" ItemStyle-Width="90px" ItemStyle-HorizontalAlign="Right">
                        <ItemTemplate>
                            <asp:LinkButton runat="server" ID="lnkBuangLampiran" Text="Buang" CommandName="BuangLampiran"
                                CommandArgument='<%# Container.DataItemIndex %>' CausesValidation="False" CssClass="ru-btn-danger-sm" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <div class="ru-list-empty">
                        <div class="ru-list-empty-icon">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21.44 11.05l-9.19 9.19a5.5 5.5 0 0 1-7.78-7.78l9.19-9.19a3.5 3.5 0 0 1 4.95 4.95l-9.2 9.19a1.5 1.5 0 0 1-2.12-2.12l8.49-8.48"/></svg>
                        </div>
                        <p class="ru-list-empty-title">Tiada lampiran dijumpai.</p>
                        <p class="ru-list-empty-sub">Belum ada lampiran ditambah.</p>
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>

            <div class="ru-dropzone" style="margin-top:12px;">
                <div class="ru-dropzone-icon">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><path d="M17 8l-5-5-5 5"/><path d="M12 3v12"/></svg>
                </div>
                <p class="ru-dropzone-text">Seret &amp; lepas fail di sini, atau pilih fail di bawah</p>
                <p class="ru-dropzone-hint">Format dibenarkan: PDF, JPG, PNG (maks. 10MB)</p>
                <asp:FileUpload ID="fuLampiran" runat="server" CssClass="ru-field" />
                <div style="margin-top:10px;">
                    <asp:Button ID="btnTambahLampiran" runat="server" CssClass="ru-btn-outline" Text="+ Tambah lampiran" CausesValidation="False" />
                </div>
            </div>
        </div>

    </div>

    <%--# Bar tindakan (sticky) #--%>
    <div class="ru-actions sp-sticky-actions">
        <asp:Button ID="btnBatalRekod" runat="server" CssClass="ru-btn-outline" Text="Kembali" CausesValidation="False" />
        <asp:Button ID="btnHantarSemakan" runat="server" CssClass="ru-btn-primary" Text="Hantar kepada KB Inspektorat"
            ValidationGroup="frmRekodSemakan" OnClientClick="return confirm('Anda pasti untuk menghantar rekod ini?');" />
    </div>

</div>

                <%--<div class="card card-info">
                    <div class="card-header">
                        <h3 class="card-title">
                            <asp:Literal ID="litTajukRekod" runat="server" Text="Rekod Ulasan / Pemerhatian" />
                        </h3>
                    </div>
                    <div class="card-body">

                        
                        <asp:Panel ID="pnlMaklumatDijumpai" runat="server" Visible="false" CssClass="callout callout-info">
                            <div class="info-item"><span class="info-label">Nama Syarikat</span><span class="info-value"><asp:Literal ID="litNamaSyarikat" runat="server" /></span></div>
                            <div class="info-item"><span class="info-label">No Pendaftaran</span><span class="info-value"><asp:Literal ID="litNoPendaftaran" runat="server" /></span></div>
                            <div class="info-item"><span class="info-label">Tarikh Luput</span><span class="info-value"><asp:Literal ID="litTarikhLuput" runat="server" /></span></div>
                        </asp:Panel>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>Alamat Lokasi Pemeriksaan</label>
                                    <asp:TextBox ID="txtAlamatLokasi" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2" />
                                    <asp:RequiredFieldValidator runat="server" ID="rfvAlamat" ControlToValidate="txtAlamatLokasi"
                                        ErrorMessage="Sila isi alamat lokasi" CssClass="cssRequiredField" Display="Dynamic" ValidationGroup="frmRekodSemakan" />
                                </div>
                            </div>
                        </div>

                        <hr />
                        <h5><asp:Literal ID="litJenisCatatan" runat="server" Text="Ulasan" /></h5>

                        
                        <asp:GridView ID="GridViewUlasanSementara" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-sm table-bordered" Width="100%">
                            <Columns>
                                <asp:BoundField DataField="Catatan" HeaderText="Catatan" />
                                <asp:TemplateField ShowHeader="False" ItemStyle-Width="80px">
                                    <ItemTemplate>
                                        <asp:LinkButton runat="server" ID="lnkBuangUlasan" Text="Buang" CommandName="BuangUlasan"
                                            CommandArgument='<%# Container.DataItemIndex %>' CausesValidation="False" CssClass="btn btn-danger btn-sm" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>Belum ada catatan ditambah.</EmptyDataTemplate>
                        </asp:GridView>

                        <div class="row">
                            <div class="col-md-8">
                                <div class="form-group">
                                    <asp:TextBox ID="txtCatatanBaru" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2" placeholder="Taip catatan..." />
                                </div>
                            </div>
                            <div class="col-md-2">
                                <asp:Button ID="btnTambahUlasan" runat="server" CssClass="btn btn-default btn-block" Text="+ Tambah Catatan" CausesValidation="False" />
                            </div>
                        </div>

                        <hr />
                        <h5>Lampiran</h5>

                        <asp:GridView ID="GridViewLampiranSementara" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-sm table-bordered" Width="100%">
                            <Columns>
                                <asp:BoundField DataField="FileName" HeaderText="Nama Fail" />
                                <asp:TemplateField ShowHeader="False" ItemStyle-Width="80px">
                                    <ItemTemplate>
                                        <asp:LinkButton runat="server" ID="lnkBuangLampiran" Text="Buang" CommandName="BuangLampiran"
                                            CommandArgument='<%# Container.DataItemIndex %>' CausesValidation="False" CssClass="btn btn-danger btn-sm" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>Belum ada lampiran ditambah.</EmptyDataTemplate>
                        </asp:GridView>

                        <div class="row">
                            <div class="col-md-8">
                                <div class="form-group">
                                    <asp:FileUpload ID="fuLampiran" runat="server" CssClass="form-control" />
                                </div>
                            </div>
                            <div class="col-md-2">
                                <asp:Button ID="btnTambahLampiran" runat="server" CssClass="btn btn-default btn-block" Text="+ Tambah Lampiran" CausesValidation="False" />
                            </div>
                        </div>

                    </div>
                    <div class="sp-sticky-actions">
                        <asp:Button ID="btnHantarSemakan" runat="server" CssClass="btn-primary" Text="Hantar Kepada KB Inspektorat" 
                            ValidationGroup="frmRekodSemakan" OnClientClick="return confirm('Anda pasti untuk menghantar rekod ini?');"/>
                        <asp:Button ID="btnBatalRekod" runat="server" CssClass="btn btn-default" Text="Kembali" CausesValidation="False" />
                    </div>
                </div>--%>
            </asp:Panel>


            <%--# =========================================================================================== #--%>
            <%--# PAPARAN DETAIL (untuk KB Inspektorat / KB Lesen / KJ Lesen / Kerani Lesen)                    #--%>
            <%--# =========================================================================================== #--%>
            <asp:Panel ID="pnlDetail" runat="server" Visible="false">


                <div class="card">
                    <div class="card-body">
                        <div class="bs-wrap">
                            <div class="row">
                            

                                <!-- KIRI: Maklumat Kes -->
                                <div class="col-md-6">
                                    <div class="bs-card">
                                        <div class="bs-card-header">
                                            <div class="bs-card-header-icon">
                                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><path d="M14 2v6h6"/></svg>
                                            </div>
                                            <h3>Butiran semakan</h3>
                                        </div>
                                        <div class="bs-card-body">
                                            <asp:FormView ID="FormView1" runat="server" DataSourceID="SqlDataSourceDetail" DefaultMode="ReadOnly" RenderOuterTable="false">
                                                <ItemTemplate>
                                                    <div class="bs-info-row">
                                                        <div class="bs-info-icon">
                                                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 5H7a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2M9 5a2 2 0 0 0 2 2h2a2 2 0 0 0 2-2M9 5a2 2 0 0 1 2-2h2a2 2 0 0 1 2 2"/></svg>
                                                        </div>
                                                        <div>
                                                            <div class="bs-info-label">No rujukan</div>
                                                            <div class="bs-info-value"><%# Eval("SemakanIK_NoRujukan") %></div>
                                                        </div>
                                                    </div>
                                                    <div class="bs-info-row">
                                                        <div class="bs-info-icon">
                                                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
                                                        </div>
                                                        <div>
                                                            <div class="bs-info-label">Jenis kes</div>
                                                            <div class="bs-info-value"><%# Eval("SemakanIK_StatusLesen") %></div>
                                                        </div>
                                                    </div>
                                                    <div class="bs-info-row">
                                                        <div class="bs-info-icon">
                                                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 21h18M6 21V7l6-4 6 4v14M9 9h1m4 0h1m-6 4h1m4 0h1m-6 4h1m4 0h1"/></svg>
                                                        </div>
                                                        <div>
                                                            <div class="bs-info-label">Nama syarikat</div>
                                                            <div class="bs-info-value"><%# Eval("SemakanIK_NamaSyarikat") %></div>
                                                        </div>
                                                    </div>
                                                    <div class="bs-info-row">
                                                        <div class="bs-info-icon">
                                                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="16" rx="2"/><path d="M7 2v4M17 2v4M3 10h18"/></svg>
                                                        </div>
                                                        <div>
                                                            <div class="bs-info-label">No pendaftaran</div>
                                                            <div class="bs-info-value"><%# Eval("SemakanIK_NoPendaftaran") %></div>
                                                        </div>
                                                    </div>
                                                    <div class="bs-info-row">
                                                        <div class="bs-info-icon">
                                                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 6-9 12-9 12s-9-6-9-12a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                                                        </div>
                                                        <div>
                                                            <div class="bs-info-label">Alamat lokasi</div>
                                                            <div class="bs-info-value"><%# Eval("SemakanIK_AlamatLokasi") %></div>
                                                        </div>
                                                    </div>
                                                    <div class="bs-info-row">
                                                        <div class="bs-info-icon">
                                                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="16" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/></svg>
                                                        </div>
                                                        <div>
                                                            <div class="bs-info-label">Tarikh semakan</div>
                                                            <div class="bs-info-value"><%# Eval("SemakanIK_TarikhSemakan", "{0:dd/MM/yyyy}") %></div>
                                                        </div>
                                                    </div>
                                                    <div class="bs-info-row">
                                                        <div class="bs-info-icon">
                                                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 12l2 2 4-4M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0z"/></svg>
                                                        </div>
                                                        <div>
                                                            <div class="bs-info-label">Status</div>
                                                            <div class="bs-info-value"><%# Eval("SemakanIK_Status") %></div>
                                                        </div>
                                                    </div>
                                                </ItemTemplate>
                                            </asp:FormView>
                                        </div>
                                    </div>

                                    <asp:SqlDataSource ID="SqlDataSourceDetail" runat="server"
                                        ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                                        SelectCommand="SELECT * FROM LESEN_SepandukSemakanIK WHERE SemakanIK_ID = @SemakanIK_ID">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="GridView1" Name="SemakanIK_ID" PropertyName="SelectedValue" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                </div>

                                <!-- KANAN: Ulasan/Pemerhatian & Lampiran Pegawai IK (readonly) -->
                                <div class="col-md-6">
                                    <div class="bs-card">
                                        <div class="bs-card-header bs-secondary">
                                            <div class="bs-card-header-icon">
                                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
                                            </div>
                                            <h3>Ulasan &amp; pemerhatian pegawai IK</h3>
                                        </div>
                                        <div class="bs-card-body">
                                            <asp:GridView ID="GridViewUlasanIK" runat="server" AutoGenerateColumns="False"
                                                DataSourceID="SqlDataSourceUlasanIK" CssClass="bs-list" GridLines="None" Width="100%">
                                                <Columns>
                                                    <asp:BoundField DataField="Ulasan_Jenis" HeaderText="Jenis" />
                                                    <asp:BoundField DataField="Ulasan_Catatan" HeaderText="Catatan" />
                                                    <asp:BoundField DataField="Ulasan_Tarikh" HeaderText="Tarikh" DataFormatString="{0:dd/MM/yyyy hh:mm tt}" />
                                                </Columns>
                                            </asp:GridView>

                                            <div class="bs-attach-heading">
                                                <div class="bs-attach-heading-icon">
                                                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21.44 11.05l-9.19 9.19a5.5 5.5 0 0 1-7.78-7.78l9.19-9.19a3.5 3.5 0 0 1 4.95 4.95l-9.2 9.19a1.5 1.5 0 0 1-2.12-2.12l8.49-8.48"/></svg>
                                                </div>
                                                <h5>Lampiran</h5>
                                            </div>

                                            <div class="bs-attach-list">
                                                <asp:Repeater ID="RepeaterLampiranIK" runat="server" DataSourceID="SqlDataSourceLampiranIK">
                                                    <ItemTemplate>
                                                        <a class="bs-attach-item" href='<%# Eval("Lampiran_FilePath") %>' target="_blank">
                                                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><path d="M14 2v6h6"/></svg>
                                                            <%# Eval("Lampiran_FileName") %>
                                                        </a>
                                                    </ItemTemplate>
                                                </asp:Repeater>
                                            </div>
                                        </div>
                                    </div>

                                    <asp:SqlDataSource ID="SqlDataSourceUlasanIK" runat="server"
                                        ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                                        SelectCommand="SELECT * FROM LESEN_SepandukSemakanIK_Ulasan WHERE Ulasan_SemakanIKID = @SemakanIK_ID ORDER BY Ulasan_ID ASC">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="GridView1" Name="SemakanIK_ID" PropertyName="SelectedValue" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>

                                    <asp:SqlDataSource ID="SqlDataSourceLampiranIK" runat="server"
                                        ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                                        SelectCommand="SELECT * FROM LESEN_SepandukSemakanIK_Lampiran WHERE Lampiran_SemakanIKID = @SemakanIK_ID ORDER BY Lampiran_ID ASC">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="GridView1" Name="SemakanIK_ID" PropertyName="SelectedValue" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                </div>

                            </div>
                       <%-- </div>
                    </div>--%>
                        </div>

               <%-- <div class="card">
                    <div class="card-body">--%>
                        <div class="row">
                            <div class="col-md-12">

                            <div class="wf-wrap">

                    <%--# =========================== TRAIL KELULUSAN (READONLY) =========================== #--%>
                    <asp:Panel ID="pnlTrailKelulusan" runat="server" Visible="false">
                        <div class="wf-card">
                            <div class="wf-head wf-head-trail">
                                <div class="wf-head-icon">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 8v4l3 3M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0z"/></svg>
                                </div>
                                <h3>Trail kelulusan</h3>
                            </div>
                            <div class="wf-body" style="overflow-x: auto;">
                                <asp:GridView ID="GridViewTrail" runat="server" AutoGenerateColumns="False"
                                    DataSourceID="SqlDataSourceTrail" CssClass="wf-list" GridLines="None" Width="100%">
                                    <Columns>
                                        <asp:BoundField DataField="Kelulusan_Peringkat" HeaderText="Peringkat" />
                                        <asp:BoundField DataField="Kelulusan_Keputusan" HeaderText="Keputusan" />
                                        <asp:BoundField DataField="Kelulusan_Catatan" HeaderText="Catatan" />
                                        <asp:BoundField DataField="Kelulusan_Tarikh" HeaderText="Tarikh" DataFormatString="{0:dd/MM/yyyy hh:mm tt}" />
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>

                        <asp:SqlDataSource ID="SqlDataSourceTrail" runat="server"
                            ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                            SelectCommand="SELECT * FROM LESEN_SepandukKelulusan WHERE Kelulusan_SemakanIKID = @SemakanIK_ID ORDER BY Kelulusan_ID ASC">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="GridView1" Name="SemakanIK_ID" PropertyName="SelectedValue" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </asp:Panel>

                    <%--# =========================== BORANG KB INSPEKTORAT =========================== #--%>
                    <asp:Panel ID="pnlKBInspektorat" runat="server" Visible="false">
                        <div class="wf-card">
                            <div class="wf-head wf-head-ik">
                                <div class="wf-head-icon">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 12l2 2 4-4M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0z"/></svg>
                                </div>
                                <h3>Semakan &amp; sokongan - KB Inspektorat</h3>
                            </div>
                            <div class="wf-body">
                                <asp:FormView ID="FormViewKBInspektorat" runat="server" DataSourceID="SqlDataSourceKBInspektorat" DefaultMode="Insert" RenderOuterTable="false">
                                    <InsertItemTemplate>
                                        <div class="wf-row">
                                            <div class="wf-col-4">
                                                <div class="wf-form-group">
                                                    <label class="wf-label">Keputusan</label>
                                                    <asp:DropDownList ID="ddlKeputusan" runat="server" SelectedValue='<%# Bind("Kelulusan_Keputusan") %>' CssClass="wf-field select2">
                                                        <asp:ListItem Value="">-- Sila pilih --</asp:ListItem>
                                                        <asp:ListItem Value="Sokong">Sokong</asp:ListItem>
                                                        <asp:ListItem Value="Tidak Sokong">Tidak sokong</asp:ListItem>
                                                    </asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" CssClass="cssRequiredField"
                                                        ControlToValidate="ddlKeputusan" ErrorMessage="Sila pilih" ValidationGroup="frmKBInspektorat" Display="Dynamic"></asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="wf-row">
                                            <div class="wf-col-8">
                                                <div class="wf-form-group">
                                                    <label class="wf-label">Catatan</label>
                                                    <asp:TextBox ID="txtCatatan" runat="server" Text='<%# Bind("Kelulusan_Catatan") %>' CssClass="wf-field" TextMode="MultiLine" Rows="3" />
                                                </div>
                                            </div>
                                        </div>
                                        <div class="wf-actions sp-sticky-actions">
                                            <asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Kembali" CssClass="wf-btn-outline" OnClick="InsertCancelButton_Click" />
                                            <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert"
                                                Text="Hantar kepada KB Lesen" ValidationGroup="frmKBInspektorat" CssClass="wf-btn-primary"
                                                OnClientClick="return confirm('Anda pasti untuk menghantar rekod ini?');"/>
                                        </div>
                                    </InsertItemTemplate>
                                </asp:FormView>
                            </div>
                        </div>

                        <asp:SqlDataSource ID="SqlDataSourceKBInspektorat" runat="server"
                            ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                            InsertCommand="
                            INSERT INTO LESEN_SepandukKelulusan (Kelulusan_SemakanIKID, Kelulusan_Peringkat, Kelulusan_PegawaiID, Kelulusan_Keputusan, Kelulusan_Catatan, Kelulusan_Tarikh)
                            VALUES (@SemakanIKID, 'KB Inspektorat', @PegawaiID, @Kelulusan_Keputusan, @Kelulusan_Catatan, getdate())">
                            <InsertParameters>
                                <asp:ControlParameter ControlID="GridView1" Name="SemakanIKID" PropertyName="SelectedValue" />
                                <asp:SessionParameter SessionField="sessionUsersId" Name="PegawaiID" />
                                <asp:Parameter Name="Kelulusan_Keputusan" />
                                <asp:Parameter Name="Kelulusan_Catatan" />
                            </InsertParameters>
                        </asp:SqlDataSource>
                    </asp:Panel>

                    <%--# =========================== BORANG KB LESEN =========================== #--%>
                    <asp:Panel ID="pnlKBLesen" runat="server" Visible="false">
                        <div class="wf-card">
                            <div class="wf-head wf-head-kblesen">
                                <div class="wf-head-icon">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><path d="M14 2v6h6"/><path d="M9 15l2 2 4-4"/></svg>
                                </div>
                                <h3>Syorkan tindakan - KB Lesen</h3>
                            </div>
                            <div class="wf-body">
                                <asp:FormView ID="FormViewKBLesen" runat="server" DataSourceID="SqlDataSourceKBLesen" DefaultMode="Insert" RenderOuterTable="false">
                                    <InsertItemTemplate>
                                        <div class="wf-row">
                                            <div class="wf-col-4">
                                                <div class="wf-form-group">
                                                    <label class="wf-label">Syor tindakan</label>
                                                    <asp:DropDownList ID="ddlKeputusan" runat="server" SelectedValue='<%# Bind("Kelulusan_Keputusan") %>' CssClass="wf-field select2">
                                                        <asp:ListItem Value="">-- Sila pilih --</asp:ListItem>
                                                        <asp:ListItem Value="Syor Rampas Wang Amanah">Syor rampas wang amanah</asp:ListItem>
                                                        <asp:ListItem Value="Syor Kembalikan Wang Amanah">Syor kembalikan wang amanah</asp:ListItem>
                                                        <asp:ListItem Value="Catatan">Catatan</asp:ListItem>
                                                    </asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" CssClass="cssRequiredField"
                                                        ControlToValidate="ddlKeputusan" ErrorMessage="Sila pilih" ValidationGroup="frmKBLesen" Display="Dynamic"></asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="wf-row">
                                            <div class="wf-col-8">
                                                <div class="wf-form-group">
                                                    <label class="wf-label">Catatan / justifikasi</label>
                                                    <asp:TextBox ID="txtCatatan" runat="server" Text='<%# Bind("Kelulusan_Catatan") %>' CssClass="wf-field" TextMode="MultiLine" Rows="3" />
                                                </div>
                                            </div>
                                        </div>
                                        <div class="wf-actions sp-sticky-actions">
                                            <asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Kembali" CssClass="wf-btn-outline" OnClick="InsertCancelButton_Click" />
                                            <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert"
                                                Text="Hantar kepada KJ Lesen" ValidationGroup="frmKBLesen" CssClass="wf-btn-primary"
                                                OnClientClick="return confirm('Anda pasti untuk menghantar rekod ini?');"/>
                                        </div>
                                    </InsertItemTemplate>
                                </asp:FormView>
                            </div>
                        </div>

                        <asp:SqlDataSource ID="SqlDataSourceKBLesen" runat="server"
                            ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                            InsertCommand="
                            INSERT INTO LESEN_SepandukKelulusan (Kelulusan_SemakanIKID, Kelulusan_Peringkat, Kelulusan_PegawaiID, Kelulusan_Keputusan, Kelulusan_Catatan, Kelulusan_Tarikh)
                            VALUES (@SemakanIKID, 'KB Lesen', @PegawaiID, @Kelulusan_Keputusan, @Kelulusan_Catatan, getdate())">
                            <InsertParameters>
                                <asp:ControlParameter ControlID="GridView1" Name="SemakanIKID" PropertyName="SelectedValue" />
                                <asp:SessionParameter SessionField="sessionUsersId" Name="PegawaiID" />
                                <asp:Parameter Name="Kelulusan_Keputusan" />
                                <asp:Parameter Name="Kelulusan_Catatan" />
                            </InsertParameters>
                        </asp:SqlDataSource>
                    </asp:Panel>

                    <%--# =========================== BORANG KJ LESEN =========================== #--%>
                    <asp:Panel ID="pnlKJLesen" runat="server" Visible="false">
                        <div class="wf-card">
                            <div class="wf-head wf-head-kj">
                                <div class="wf-head-icon">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 15a3 3 0 1 0 0-6 3 3 0 0 0 0 6z"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 1 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg>
                                </div>
                                <h3>Perakuan - KJ Lesen</h3>
                            </div>
                            <div class="wf-body">

                                <%--# Papar syor KB Lesen supaya KJ boleh rujuk sebelum perakukan #--%>
                                <div class="wf-callout">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M12 16v-4M12 8h.01"/></svg>
                                    <div><b>Syor KB Lesen:</b> <asp:Literal ID="litSyorKBLesen" runat="server" /></div>
                                </div>

                                <asp:FormView ID="FormViewKJLesen" runat="server" DataSourceID="SqlDataSourceKJLesen" DefaultMode="Insert" RenderOuterTable="false">
                                    <InsertItemTemplate>
                                        <div class="wf-row">
                                            <div class="wf-col-4">
                                                <div class="wf-form-group">
                                                    <label class="wf-label">Keputusan</label>
                                                    <asp:DropDownList ID="ddlKeputusan" runat="server" SelectedValue='<%# Bind("Kelulusan_Keputusan") %>' CssClass="wf-field select2">
                                                        <asp:ListItem Value="">-- Sila pilih --</asp:ListItem>
                                                        <asp:ListItem Value="Diperakukan">Diperakukan</asp:ListItem>
                                                        <asp:ListItem Value="Tidak Diperakukan">Tidak diperakukan</asp:ListItem>
                                                    </asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" CssClass="cssRequiredField"
                                                        ControlToValidate="ddlKeputusan" ErrorMessage="Sila pilih" ValidationGroup="frmKJLesen" Display="Dynamic"></asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="wf-row">
                                            <div class="wf-col-8">
                                                <div class="wf-form-group">
                                                    <label class="wf-label">Catatan</label>
                                                    <asp:TextBox ID="txtCatatan" runat="server" Text='<%# Bind("Kelulusan_Catatan") %>' CssClass="wf-field" TextMode="MultiLine" Rows="3" />
                                                </div>
                                            </div>
                                        </div>
                                        <div class="wf-actions sp-sticky-actions">
                                            <asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Kembali" CssClass="wf-btn-outline" OnClick="InsertCancelButton_Click" />
                                            <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert"
                                                Text="Hantar" ValidationGroup="frmKJLesen" CssClass="wf-btn-primary"
                                                OnClientClick="return confirm('Anda pasti untuk menghantar rekod ini?');"
                                                />
                                        </div>
                                    </InsertItemTemplate>
                                </asp:FormView>
                            </div>
                        </div>

                        <asp:SqlDataSource ID="SqlDataSourceKJLesen" runat="server"
                            ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                            InsertCommand="
                            INSERT INTO LESEN_SepandukKelulusan (Kelulusan_SemakanIKID, Kelulusan_Peringkat, Kelulusan_PegawaiID, Kelulusan_Keputusan, Kelulusan_Catatan, Kelulusan_Tarikh)
                            VALUES (@SemakanIKID, 'KJ Lesen', @PegawaiID, @Kelulusan_Keputusan, @Kelulusan_Catatan, getdate())">
                            <InsertParameters>
                                <asp:ControlParameter ControlID="GridView1" Name="SemakanIKID" PropertyName="SelectedValue" />
                                <asp:SessionParameter SessionField="sessionUsersId" Name="PegawaiID" />
                                <asp:Parameter Name="Kelulusan_Keputusan" />
                                <asp:Parameter Name="Kelulusan_Catatan" />
                            </InsertParameters>
                        </asp:SqlDataSource>
                    </asp:Panel>

                    <%--# =========================== BORANG KERANI LESEN - KEMASKINI KEWANGAN =========================== #--%>
                    <asp:Panel ID="pnlKeraniLesen" runat="server" Visible="false">
                        <div class="wf-card">
                            <div class="wf-head wf-head-kerani">
                                <div class="wf-head-icon">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="5" width="20" height="14" rx="2"/><path d="M2 10h20"/></svg>
                                </div>
                                <h3>Kemaskini kewangan - Kerani Lesen</h3>
                            </div>
                            <div class="wf-body">

                                <div class="wf-callout wf-callout-warning">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><path d="M12 9v4M12 17h.01"/></svg>
                                    <div><b>Tindakan diperakukan:</b> <asp:Literal ID="litTindakanKewangan" runat="server" /></div>
                                </div>

                                <asp:FormView ID="FormViewKerani" runat="server" DataSourceID="SqlDataSourceKerani" DefaultMode="Insert" RenderOuterTable="false">
                                    <InsertItemTemplate>
                                        <asp:HiddenField ID="hdnTindakan" runat="server" Value='<%# Bind("Kewangan_Tindakan") %>' />
                                        <div class="wf-row">
                                            <div class="wf-col-4">
                                                <div class="wf-form-group">
                                                    <label class="wf-label">Jumlah (RM)</label>
                                                    <asp:TextBox ID="txtJumlah" runat="server" Text='<%# Bind("Kewangan_Jumlah") %>' CssClass="wf-field" />
                                                </div>
                                            </div>
                                            <div class="wf-col-4">
                                                <div class="wf-form-group">
                                                    <label class="wf-label">No resit</label>
                                                    <asp:TextBox ID="txtNoResit" runat="server" Text='<%# Bind("Kewangan_NoResit") %>' CssClass="wf-field" />
                                                </div>
                                            </div>
                                            <div class="wf-col-4">
                                                <div class="wf-form-group">
                                                    <label class="wf-label">Tarikh proses</label>
                                                    <asp:TextBox ID="txtTarikhProses" runat="server" Text='<%# Bind("Kewangan_TarikhProses", "{0:yyyy-MM-dd}") %>' CssClass="wf-field datepicker" placeholder="yyyy-mm-dd" />
                                                    <asp:RequiredFieldValidator runat="server" ID="rfvTarikh" ControlToValidate="txtTarikhProses"
                                                        ErrorMessage="Sila isi tarikh" CssClass="cssRequiredField" Display="Dynamic" ValidationGroup="frmKerani" />
                                                </div>
                                            </div>
                                        </div>
                                        <div class="wf-row">
                                            <div class="wf-col-8">
                                                <div class="wf-form-group">
                                                    <label class="wf-label">Catatan</label>
                                                    <asp:TextBox ID="txtCatatan" runat="server" Text='<%# Bind("Kewangan_Catatan") %>' CssClass="wf-field" TextMode="MultiLine" Rows="3" />
                                                </div>
                                            </div>
                                        </div>
                                        <div class="wf-actions sp-sticky-actions">
                                            <asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Kembali" CssClass="wf-btn-outline" OnClick="InsertCancelButton_Click" />
                                            <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert"
                                                Text="Simpan kewangan" ValidationGroup="frmKerani" CssClass="wf-btn-primary"
                                                OnClientClick="return confirm('Anda pasti untuk menghantar rekod ini?');"/>
                                        </div>
                                    </InsertItemTemplate>
                                </asp:FormView>
                            </div>
                        </div>

                        <asp:SqlDataSource ID="SqlDataSourceKerani" runat="server"
                            ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                            InsertCommand="
                            INSERT INTO LESEN_SepandukKewangan (Kewangan_SemakanIKID, Kewangan_Tindakan, Kewangan_Jumlah, Kewangan_NoResit, Kewangan_TarikhProses, Kewangan_Catatan, Kewangan_PegawaiID, CreatorID, CreatedDt)
                            VALUES (@SemakanIKID, @Kewangan_Tindakan, @Kewangan_Jumlah, @Kewangan_NoResit, @Kewangan_TarikhProses, @Kewangan_Catatan, @PegawaiID, @PegawaiID, getdate())">
                            <InsertParameters>
                                <asp:ControlParameter ControlID="GridView1" Name="SemakanIKID" PropertyName="SelectedValue" />
                                <asp:SessionParameter SessionField="sessionUsersId" Name="PegawaiID" />
                                <asp:Parameter Name="Kewangan_Tindakan" />
                                <asp:Parameter Name="Kewangan_Jumlah" Type="Decimal" />
                                <asp:Parameter Name="Kewangan_NoResit" />
                                <asp:Parameter Name="Kewangan_TarikhProses" Type="DateTime" />
                                <asp:Parameter Name="Kewangan_Catatan" />
                            </InsertParameters>
                        </asp:SqlDataSource>
                    </asp:Panel>

                </div>

                            </div>

                        </div>
                    </div>
                </div>

                <div class="sp-sticky-actions" runat="server" id="idFooterKembali">
                    <asp:Button ID="btnKembaliDetail" runat="server" CssClass="btn btn-default" Text="&larr; Kembali Ke Senarai" CausesValidation="False" />
                </div>

            </asp:Panel>

        </div>
    </section>
</div>

    <script>
        function sp_applyStatusBadges() {
            var rows = document.querySelectorAll('#idListing table tbody tr');
            rows.forEach(function (tr) {
                var cell = tr.children[6]; // kolum ke-7: Status (0-based index 6)
                if (!cell || cell.getAttribute('data-badged') === '1') return;
                var text = (cell.textContent || '').trim();
                if (!text) return;
                var cls = 'badge-pending';
                if (text.indexOf('Selesai') > -1) cls = 'badge-success';
                else if (text.indexOf('Tidak Diperakukan') > -1 || text.indexOf('Tidak Sokong') > -1) cls = 'badge-danger';
                else if (text.indexOf('Kewangan') > -1) cls = 'badge-warning';
                cell.innerHTML = '<span class="status-pill ' + cls + '">' + text + '</span>';
                cell.setAttribute('data-badged', '1');
            });
        }

        function pageLoad() {
            $(function () {
                $('.select2').select2();
                $('.datepicker').datepicker({ dateFormat: 'yy-mm-dd', autoclose: true });
            });
            sp_applyStatusBadges();
        }
    </script>

</asp:Content>
