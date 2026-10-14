<%@ Page Title="" Language="VB" MaintainScrollPositionOnPostBack="true" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="sepandukSemakanIK.aspx.vb" Inherits="sepandukSemakanIK" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="asp" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadContent" runat="Server">
<style>

    .btn-danger-modern {
    background-color: #dc3545;
    color: white;
    border: none;
}

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

        .sp-sticky-actions .btn{ width:100%; margin-bottom:8px; }
        .sp-sticky-actions .btn:last-child{ margin-bottom:0; }

        .info-value{ text-align:right; }

        .sp-step-label{ font-size:.65rem; }
    }
</style>

<style>
    /* =====================================================================
       SENARAI SEMAKAN - tema ikut lesen/applicantregister.aspx (ar-*)
    ===================================================================== */
    .ss-card {
        background: #fff; border: 1px solid #E3E7F1; border-radius: 12px; overflow: hidden;
        box-shadow: 0 2px 8px rgba(46,49,146,.06);
    }

    /* ---------- Header ---------- */
    .ss-head {
        display: flex; flex-wrap: wrap; gap: 12px; align-items: center; justify-content: space-between;
        padding: 18px 20px; border-bottom: 1px solid #E4DFFB;
        background: linear-gradient(135deg, #F4F3FF 0%, #EEF4FF 100%); border-left: 4px solid #2E3192;
    }
    .ss-title { font-size: 17px; font-weight: 700; color: #23267a; margin: 0; }
    .ss-sub { color: #5B6478; font-size: 13px; margin-top: 2px; }
    .ss-head-actions { display: flex; flex-wrap: wrap; gap: 14px; align-items: center; }
    .ss-btn-add { display: inline-flex; align-items: center; gap: 8px; font-weight: 600; }

    /* Switch "Semua Rekod" - custom-admin.css paksa .form-check-input 20px tanpa border */
    .ss-switch { display: flex; align-items: center; gap: 8px; margin: 0; padding-left: 2.6em; min-height: 0; }
    .ss-switch .form-check-input {
        width: 2.2em !important; height: 1.15em !important; margin-top: 0; cursor: pointer;
        border: 1px solid #adb5bd !important;
    }
    .ss-switch .form-check-input:checked { background-color: #2E3192; border-color: #2E3192 !important; }
    .ss-switch .form-check-label { font-size: 13px; font-weight: 600; color: #495057; cursor: pointer; }

    /* ---------- Filter ---------- */
    .ss-filter {
        display: flex; flex-wrap: wrap; gap: 10px; align-items: flex-start; /* butang sebaris dengan baris pertama penapis */
        padding: 14px 20px; border-bottom: 1px solid #E6EBF5; background: #F8FAFE;
    }
    .ss-filter-fields { flex: 1 1 520px; margin: calc(-1 * var(--bs-gutter-y)) 0 0; } /* kekalkan offset .row.g-2 supaya baris pertama bermula di atas */
    .ss-filter-fields .form-group { margin: 0; }
    .ss-filter .ss-filter-fields input.form-control {
        border: 1px solid #d0d5dd !important; border-radius: 6px !important; background: #fff;
    }
    .ss-filter .ss-filter-fields input.form-control:focus { border-color: #3b82f6 !important; box-shadow: 0 0 0 4px rgba(59,130,246,.15); }
    .ss-filter-actions { display: flex; gap: 8px; align-items: center; flex-wrap: wrap; }
    .ss-filter-actions .btn { height: 38px; margin: 0 !important; display: inline-flex; align-items: center; justify-content: center; }
    /* custom-admin.css (.compact-form input.form-control) paksa tinggi 34px + margin 5px - samakan dengan butang */
    .ss-filter .ss-filter-fields input.form-control { height: 38px !important; min-height: 38px !important; margin: 0 !important; }
    .ss-count { color: #2E3192; font-size: 13px; font-weight: 700; white-space: nowrap; margin-left: 4px; background: #fff; border: 1px solid #D9D5FA; border-radius: 999px; padding: 4px 12px; }

    /* ---------- Table ---------- */
    .ss-table { margin: 0; width: 100%; }
    /* table-bordered diperlukan oleh skrip master (butang tindakan); buang garisan menegak */
    .ss-table.table-bordered, .ss-table.table-bordered > :not(caption) > * { border-width: 0; }
    .ss-table.table-bordered > :not(caption) > * > * { border-width: 0 0 1px 0; border-color: #f1f3f5; }
    .ss-table th {
        background: #EEF1FA; color: #3F4A6B; font-size: 12px; font-weight: 600;
        text-transform: uppercase; letter-spacing: .04em;
        padding: 12px 16px; border-bottom: 1px solid #e9ecef; white-space: nowrap;
    }
    .ss-table th a { color: #3F4A6B; text-decoration: none; }
    .ss-table th a:hover { color: #2E3192; }
    .ss-table td { padding: 14px 16px; vertical-align: middle; border-bottom: 1px solid #f1f3f5; color: #212529; font-size: 14px; }
    .ss-table tr:hover td { background: #F6F7FF; }
    .ss-col-bil { width: 56px; color: #adb5bd !important; }
    .ss-col-act { width: 1%; text-align: right; white-space: nowrap; }
    /* Saiz butang Lihat seragam (btn-warning & btn-primary ada padding/border berbeza) supaya ikon sebaris */
    .ss-col-act .btn {
        width: 34px; height: 34px; padding: 0 !important; border-radius: 8px !important; margin: 0 !important; /* custom-admin.css beri .btn-warning margin 5px */
        display: inline-flex; align-items: center; justify-content: center; vertical-align: middle;
    }
    .ss-col-act .btn i { margin: 0 !important; }
    .ss-nowrap { white-space: nowrap; }

    .ss-ref { font-weight: 600; color: #2E3192; white-space: nowrap; }
    .ss-name { font-weight: 600; }
    .ss-loc { display: inline-block; max-width: 240px; color: #495057; font-size: 13px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; vertical-align: middle; }
    .ss-loc i { color: #adb5bd; margin-right: 6px; }

    /* Hasil pemeriksaan */
    .ss-badge { display: inline-flex; align-items: center; gap: 6px; padding: 4px 10px; border-radius: 999px; font-size: 12px; font-weight: 600; white-space: nowrap; }
    .ss-badge::before { content: ""; width: 6px; height: 6px; border-radius: 50%; background: currentColor; }
    .ss-badge.ok { background: #D4EDDA; color: #1e7e34; }
    .ss-badge.bad { background: #FCEAEA; color: #C0392B; }
    .ss-badge.warn { background: #FDF1DC; color: #9A6408; }
    .ss-badge.none { background: #f1f3f5; color: #6c757d; }

    /* Status aliran */
    .ss-status { display: inline-block; padding: 4px 10px; border-radius: 6px; font-size: 12px; font-weight: 600; white-space: nowrap; }
    .ss-status.st-ik { background: #E4DFFB; color: #2E3192; }
    .ss-status.st-lesen { background: #DCEBFF; color: #1D4ED8; }
    .ss-status.st-kj { background: #FDF1DC; color: #9A6408; }
    .ss-status.st-kew { background: #E0F2F1; color: #00695C; }
    .ss-status.st-done { background: #D4EDDA; color: #1e7e34; }
    .ss-status.st-other { background: #f1f3f5; color: #6c757d; }

    .ss-empty { text-align: center; padding: 48px 16px; color: #6c757d; }
    .ss-empty i { font-size: 40px; color: #adb5bd; display: block; margin-bottom: 10px; }

    .ss-pager td { padding: 14px 16px; border: 0; }
    .ss-pager table { margin-left: auto; }
    .ss-pager a, .ss-pager span {
        display: inline-flex; min-width: 34px; height: 34px; padding: 0 8px;
        align-items: center; justify-content: center; margin-left: 4px;
        border-radius: 8px; border: 1px solid #dee2e6; color: #495057;
        text-decoration: none; font-size: 13px;
    }
    .ss-pager span { background: #2E3192; border-color: #2E3192; color: #fff; font-weight: 600; }
    .ss-pager a:hover { background: #f1f3f5; }

    /* =====================================================================
       PAPARAN DETAIL - override bs-* / wf-* (css/sepanduk-css.css) dalam .ss-detail sahaja
    ===================================================================== */
    .ss-detail { color: #212529; }
    .ss-detail .bs-wrap, .ss-detail .wf-wrap { font-family: inherit; color: inherit; }
    .ss-detail .wf-wrap { margin: 16px 0 0; }

    /* Ringkasan */
    .ss-summary {
        display: flex; flex-wrap: wrap; gap: 16px; align-items: center; justify-content: space-between;
        background: linear-gradient(135deg, #F4F3FF 0%, #EEF4FF 100%); border: 1px solid #E3E7F1; border-left: 4px solid #2E3192;
        border-radius: 12px; box-shadow: 0 2px 8px rgba(46,49,146,.06);
        padding: 18px 20px; margin-bottom: 16px;
    }
    .ss-summary-main { display: flex; gap: 14px; align-items: center; min-width: 0; }
    .ss-summary-icon {
        width: 46px; height: 46px; border-radius: 12px; flex-shrink: 0;
        background: #E4DFFB; color: #2E3192; font-size: 20px;
        display: flex; align-items: center; justify-content: center;
    }
    .ss-summary-label { font-size: 12px; font-weight: 600; color: #6c757d; text-transform: uppercase; letter-spacing: .04em; }
    .ss-summary-title { font-size: 19px; font-weight: 700; margin: 2px 0 4px; color: #212529; word-break: break-word; }
    .ss-summary-sub { display: flex; flex-wrap: wrap; gap: 4px 16px; color: #6c757d; font-size: 13px; }
    .ss-summary-sub i { color: #adb5bd; margin-right: 6px; }
    .ss-summary-tags { display: flex; flex-wrap: wrap; gap: 8px; }

    /* Kad (Butiran / Ulasan / Trail / Borang) */
    .ss-detail .bs-card, .ss-detail .wf-card {
        background: #fff; border: 1px solid #e9ecef; border-radius: 12px;
        box-shadow: 0 1px 3px rgba(16,24,40,.04); margin-bottom: 16px;
    }
    .ss-detail .bs-card { height: auto; }
    .ss-detail .bs-card-header, .ss-detail .bs-card-header.bs-secondary, .ss-detail .wf-head {
        background: #fff !important; color: #212529;
        padding: 14px 20px; border-bottom: 1px solid #e9ecef; gap: 10px;
    }
    .ss-detail .bs-card-header h3, .ss-detail .wf-head h3 { font-size: 15px; font-weight: 700; }
    .ss-detail .bs-card-header-icon, .ss-detail .wf-head-icon {
        width: 32px; height: 32px; border-radius: 8px; background: #fff; color: #2E3192;
        box-shadow: 0 1px 2px rgba(16,24,40,.08);
    }
    .ss-detail .bs-card, .ss-detail .wf-card { overflow: hidden; }

    /* Warna lembut ikut bahagian supaya tak nampak semua putih */
    .ss-detail .bs-card-header                    { background: #F3F2FF !important; border-bottom-color: #E4DFFB; }  /* Butiran - indigo */
    .ss-detail .bs-card-header.bs-secondary       { background: #EDF8F6 !important; border-bottom-color: #CDEBE6; }  /* Ulasan - teal */
    .ss-detail .bs-card-header.bs-secondary .bs-card-header-icon { color: #00695C; }
    .ss-detail .wf-head-trail                     { background: #F4F5F7 !important; border-bottom-color: #E6E8EB; }  /* Trail - kelabu */
    .ss-detail .wf-head-trail .wf-head-icon       { color: #495057; }
    .ss-detail .wf-head-ik                        { background: #F3F2FF !important; border-bottom-color: #E4DFFB; }  /* KB Inspektorat - indigo */
    .ss-detail .wf-head-kblesen                   { background: #EEF4FF !important; border-bottom-color: #D6E4FF; }  /* KB Lesen - biru */
    .ss-detail .wf-head-kblesen .wf-head-icon     { color: #1D4ED8; }
    .ss-detail .wf-head-kj                        { background: #FFF7EA !important; border-bottom-color: #FBE5BF; }  /* KJ Lesen - amber */
    .ss-detail .wf-head-kj .wf-head-icon          { color: #9A6408; }
    .ss-detail .wf-head-kerani                    { background: #EDF8F6 !important; border-bottom-color: #CDEBE6; }  /* Kerani - teal */
    .ss-detail .wf-head-kerani .wf-head-icon      { color: #00695C; }
    .ss-detail .bs-card-body, .ss-detail .wf-body { padding: 18px 20px; }

    /* Butiran: grid label / nilai */
    .ss-info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px 20px; margin: 0; }
    .ss-info { min-width: 0; }
    .ss-info-wide { grid-column: 1 / -1; }
    .ss-info dt { font-size: 12px; font-weight: 600; color: #6c757d; margin-bottom: 4px; }
    .ss-info dt i { color: #adb5bd; margin-right: 6px; }
    .ss-info dd { margin: 0; font-size: 14px; font-weight: 600; color: #212529; word-break: break-word; }

    /* Jadual ulasan & trail */
    .ss-detail .bs-list, .ss-detail .wf-list { border: 1px solid #e9ecef; border-radius: 8px; font-size: 13.5px; }
    .ss-detail .bs-list th, .ss-detail .wf-list th { background: #f8f9fa; color: #6c757d; font-size: 11.5px; font-weight: 600; letter-spacing: .04em; }
    .ss-detail .bs-list td, .ss-detail .wf-list td { border-bottom-color: #f1f3f5; }
    .ss-muted-note { color: #6c757d; font-size: 13px; }

    /* Lampiran */
    .ss-detail .bs-attach-heading { margin: 18px 0 10px; }
    .ss-detail .bs-attach-heading-icon { background: #EEF0FF; color: #2E3192; }
    .ss-detail .bs-attach-item { border: 1px solid #e9ecef; border-radius: 8px; color: #2E3192; padding: 10px 12px; }
    .ss-detail .bs-attach-item:hover { background: #fafbff; border-color: #c7d2fe; }
    .ss-detail .bs-attach-item .bi-file-earmark { color: #adb5bd; }
    .ss-attach-name { flex: 1; min-width: 0; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
    .ss-attach-open { color: #adb5bd; font-size: 12px; }

    /* Borang tindakan */
    .ss-detail .wf-callout { border-radius: 8px; }
    .ss-detail .wf-field, .ss-detail select.wf-field, .ss-detail textarea.wf-field { border-color: #d0d5dd; border-radius: 6px; }
    .ss-detail .wf-field:focus { border-color: #3b82f6; box-shadow: 0 0 0 4px rgba(59,130,246,.15); }
    .ss-detail .wf-actions { border-top-color: #e9ecef; }
    .ss-detail .wf-btn-primary { background: #2E3192; border-radius: 8px; }
    .ss-detail .wf-btn-primary:hover { background: #23267a; }
    .ss-detail .wf-btn-outline { border-radius: 8px; border-color: #d0d5dd; }

    .ss-detail-foot { padding: 4px 0 8px; }

    /* Trail kelulusan - laluan berliku (3 checkpoint sebaris; baris genap terbalik arah) */
    .road { padding: 6px 30px 4px; }
    .road-row { display: flex; align-items: flex-start; position: relative; height: 156px; }
    .road-row:last-child { height: auto; }
    .road-row.rev { flex-direction: row-reverse; }
    .road-node { width: 120px; flex-shrink: 0; display: flex; flex-direction: column; align-items: center; text-align: center; position: relative; z-index: 1; }
    .road-node.ghost { visibility: hidden; }
    .road-dot {
        width: 40px; height: 40px; border-radius: 50%; display: flex; align-items: center; justify-content: center;
        font-size: 17px; color: #fff; background: #dee2e6;
    }
    .road-node.done .road-dot { background: #28a745; }
    .road-node.current .road-dot { background: #2E3192; box-shadow: 0 0 0 5px rgba(46,49,146,.15); }
    .road-node.pending .road-dot { background: #fff; border: 2px solid #dee2e6; color: #adb5bd; }
    .road-node.rejected .road-dot { background: #dc3545; }
    .road-title { font-size: 12px; font-weight: 700; color: #212529; margin-top: 8px; line-height: 1.3; padding: 0 4px; background: #fff; }
    .road-node.pending .road-title { color: #adb5bd; font-weight: 600; }
    .road-node.rejected .road-title { color: #C0392B; }
    .road-sub { font-size: 11px; color: #6c757d; margin-top: 2px; }
    .road-node.current .road-sub { color: #2E3192; font-weight: 600; }
    .road-node.pending .road-sub { color: #adb5bd; }
    .road-seg { flex: 1; height: 4px; margin-top: 18px; border-radius: 2px; background: #e9ecef; }
    .road-seg.done { background: #28a745; }
    .road-seg.ghost { visibility: hidden; }
    /* Lengkung belokan: dari bulatan terakhir baris ini, keluar ke tepi, turun, masuk ke bulatan pertama baris bawah */
    .road-curve { position: absolute; top: 18px; height: 160px; width: 88px; border: 4px solid #e9ecef; z-index: 0; }
    .road-curve.right { right: -28px; border-left: 0; border-radius: 0 40px 40px 0; }
    .road-curve.left { left: -28px; border-right: 0; border-radius: 40px 0 0 40px; }
    .road-curve.done { border-color: #28a745; }    .road-badge { display: inline-block; margin-top: 4px; padding: 1px 8px; border-radius: 999px; font-size: 10.5px; font-weight: 600; }
    .road-badge.kp-ok   { background: #D4EDDA; color: #1e7e34; }
    .road-badge.kp-bad  { background: #FCEAEA; color: #C0392B; }
    .road-badge.kp-warn { background: #FDF1DC; color: #9A6408; }
    .road-badge.kp-info, .road-badge.kp-none { background: #EEF4FF; color: #1D4ED8; }
    .road-node[title] { cursor: help; }
    .road-text { display: flex; flex-direction: column; align-items: center; }

    /* Mobile: checkpoint disusun menegak (bulatan kiri, teks kanan) */
    @media (max-width: 640px) {
        .road { padding: 4px 0 6px; border-bottom: 0; margin-bottom: 0; }
        .road-row, .road-row.rev { flex-direction: column; height: auto; }
        .road-seg, .road-curve, .road-node.ghost { display: none; }
        .road-node { width: 100%; flex-direction: row; align-items: flex-start; text-align: left; gap: 12px; padding-bottom: 14px; }
        .road-text { align-items: flex-start; padding-top: 2px; }
        .road-title { margin-top: 0; padding: 0; }
    }


    @media (max-width: 768px) {
        .ss-summary { padding: 16px; }
        .ss-summary-title { font-size: 17px; }
        .ss-info-grid { grid-template-columns: 1fr; }
        .ss-detail-foot .btn { width: 100%; }
    }

    /* ---------- Mobile: baris jadi kad ---------- */
    @media (max-width: 768px) {
        .ss-head { padding: 16px; }
        .ss-head-actions { width: 100%; justify-content: space-between; }
        .ss-filter { padding: 12px 16px; }
        .ss-filter-actions { width: 100%; }
        .ss-filter-actions .btn { flex: 1; }
        .ss-count { width: 100%; text-align: right; }

        .ss-table thead, .ss-table tr:first-child:has(th) { display: none; }
        .ss-table, .ss-table tbody, .ss-table tr, .ss-table td { display: block; width: 100%; }
        .ss-table tr { border-bottom: 1px solid #e9ecef; padding: 12px 16px; }
        .ss-table tr:hover td { background: transparent; }
        .ss-table td { display: flex; justify-content: space-between; align-items: center; gap: 12px; padding: 5px 0; border: 0 !important; text-align: right; }
        .ss-table td::before { font-size: 12px; font-weight: 600; color: #6c757d; text-align: left; flex-shrink: 0; }
        .ss-table td.ss-col-bil { display: none; }
        .ss-table td:nth-child(2)::before { content: "No Rujukan"; }
        .ss-table td:nth-child(3)::before { content: "Nama Syarikat"; }
        .ss-table td:nth-child(4)::before { content: "Lokasi"; }
        .ss-table td:nth-child(5)::before { content: "Tarikh Semakan"; }
        .ss-table td:nth-child(6)::before { content: "Hasil Pemeriksaan"; }
        .ss-table td:nth-child(7)::before { content: "Status"; }
        .ss-table td.ss-col-act { width: 100%; padding-top: 10px; }
        .ss-table td.ss-col-act .btn { width: 100%; }
        .ss-loc { max-width: 60vw; }
        .ss-table tr.ss-pager, .ss-table tr.ss-pager td { padding: 8px 0; }
        .ss-table tr.ss-pager td::before { content: none; }
    }
</style>

<link rel="stylesheet" href="<%= ResolveUrl("~/css/sepanduk-css.css") %>">
<link rel="stylesheet" href="<%= ResolveUrl("~/css/ru-style.css") %>">

<script src="https://unpkg.com/html5-qrcode@2.3.8/html5-qrcode.min.js"></script>
<script>
    var currentTextBoxId = null;
    var html5QrCode = null;
    var allowManualFocus = false; // <-- flag baru

    function handleFocus(el) {
        if (allowManualFocus) {
            // Ni focus dari closeModalAndFocus(), biarkan je, jangan buka modal / blur
            allowManualFocus = false;
            return;
        }
        currentTextBoxId = el.id;
        document.getElementById('qrChoiceModal').style.display = 'flex';
        el.blur();
    }

    function showQRModal(el) {
        currentTextBoxId = el.id;
        document.getElementById('qrChoiceModal').style.display = 'flex';
    }

    function closeQRModal() {
        document.getElementById('qrChoiceModal').style.display = 'none';
    }

    function closeModalAndFocus() {
        closeQRModal();
        allowManualFocus = true;
        var el = document.getElementById(currentTextBoxId);
        el.focus(); // sekarang tak akan trigger modal/blur balik
    }

    function startQRScan() {
        closeQRModal();
        document.getElementById('qrScannerModal').style.display = 'flex';

        html5QrCode = new Html5Qrcode("qrReader", /* verbose= */ true);

        var config = {
            fps: 10,
            qrbox: function (viewfinderWidth, viewfinderHeight) {
                // guna 70% dari saiz video, elak qrbox lebih besar dari video
                var minEdge = Math.min(viewfinderWidth, viewfinderHeight);
                var size = Math.floor(minEdge * 0.7);
                return { width: size, height: size };
            },
            aspectRatio: 1.0
        };

        html5QrCode.start(
            { facingMode: "environment" },
            config,
            function (decodedText, decodedResult) {
                console.log("QR detected:", decodedText); // <-- confirm callback jalan
                document.getElementById(currentTextBoxId).value = decodedText;
                stopQRScan();

                var el = document.getElementById(currentTextBoxId);
                el.dispatchEvent(new Event('change', { bubbles: true }));
            },
            function (errorMessage) {
                // ni akan spam banyak kali (normal, frame takde QR)
                // console.log("scan error:", errorMessage);
            }
        ).catch(function (err) {
            console.error("Camera start failed:", err);
            alert("Tak dapat akses kamera: " + err);
        });
    }

    //function startQRScan() {
    //    closeQRModal();
    //    document.getElementById('qrScannerModal').style.display = 'flex';

    //    html5QrCode = new Html5Qrcode("qrReader");
    //    html5QrCode.start(
    //        { facingMode: "environment" }, // kamera belakang
    //        { fps: 10, qrbox: 250 },
    //        function (decodedText) {
    //            // Berjaya scan
    //            document.getElementById(currentTextBoxId).value = decodedText;
    //            stopQRScan();

    //            // Optional: trigger event supaya server-side tahu value berubah
    //            var el = document.getElementById(currentTextBoxId);
    //            var evt = new Event('change', { bubbles: true });
    //            el.dispatchEvent(evt);
    //        },
    //        function (errorMessage) {
    //            // scan error frame-by-frame, boleh diabaikan
    //        }
    //    ).catch(function (err) {
    //        alert("Tak dapat akses kamera: " + err);
    //    });
    //}

    function stopQRScan() {
        if (html5QrCode) {
            html5QrCode.stop().then(function () {
                html5QrCode.clear();
                document.getElementById('qrScannerModal').style.display = 'none';
            }).catch(function () {
                document.getElementById('qrScannerModal').style.display = 'none';
            });
        } else {
            document.getElementById('qrScannerModal').style.display = 'none';
        }
    }
</script>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">
<div class="sp-shell">

<%--    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0 sp-page-title"><div runat="server" id="idWindowTitle">Semakan Sepanduk</div></h1>
                    
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <%= GlobalClass.writeBreadcrumb(Request.QueryString("p_Id"), Request.QueryString("m_Id"), Session.Item("sessionSystemId")) %>
                    </ol>
                </div>
            </div>
        </div>
    </section>--%>

    <section class="content">
        <div class="container-fluid">

            <%--# =========================== SENARAI (LISTING) =========================== #--%>
            <div class="ss-card" runat="server" id="idListing" Visible="false">

                <div class="ss-head">
                    <div>
                        <h3 class="ss-title">Senarai Semakan Sepanduk</h3>
                        <div class="ss-sub">Rekod pemeriksaan sepanduk / bunting di lapangan</div>
                    </div>
                    <div class="ss-head-actions">
                        <div class="form-check form-switch ss-switch" title="Papar semua rekod, bukan tugasan saya sahaja">
                            <asp:CheckBox ID="chkAll" AutoPostBack="True" runat="server" Text="Semua Rekod" />
                        </div>
                        <asp:LinkButton ID="btnTambahSemakan" runat="server" CssClass="btn btn-primary ss-btn-add">
                            <i class="bi bi-plus-lg"></i><span>Tambah Semakan Baharu</span>
                        </asp:LinkButton>
                    </div>
                </div>

                <%--# START FILTER #--%>
                <asp:Panel ID="pnlFilterBox" runat="server" CssClass="ss-filter" DefaultButton="btnSearch">
                    <div id="pnlFilter" runat="server" class="row g-2 ss-filter-fields"></div>
                    <div class="ss-filter-actions">
                        <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-default" Text="Cari" />
                        <asp:Button ID="btnReset" CssClass="btn btn-default" runat="server" Text="Set Semula" />
                        <span class="ss-count"><asp:Literal ID="litJumlah" runat="server" /></span>
                    </div>
                </asp:Panel>
                <%--# END FILTER #--%>

                <div class="table-responsive">
                    <asp:GridView ID="GridView1" runat="server"
                        AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="SemakanIK_ID,SemakanIK_Status,SemakanIK_NoRujukan"
                        DataSourceID="SqlDataSourceGridSemakan"
                        AllowPaging="True" PageSize="20" GridLines="None"
                        CssClass="ss-table table-bordered" PagerStyle-CssClass="ss-pager">
                        <PagerSettings Mode="NumericFirstLast" PageButtonCount="5" FirstPageText="&laquo;" LastPageText="&raquo;" />
                        <Columns>
                            <asp:TemplateField HeaderText="Bil." HeaderStyle-CssClass="ss-col-bil" ItemStyle-CssClass="ss-col-bil">
                                <ItemTemplate>
                                    <%# (GridView1.PageIndex * GridView1.PageSize) + Container.DisplayIndex + 1 %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="No Rujukan" SortExpression="SemakanIK_NoRujukan">
                                <ItemTemplate>
                                    <span class="ss-ref"><%# Eval("SemakanIK_NoRujukan") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Nama Syarikat" SortExpression="SemakanIK_NamaSyarikat">
                                <ItemTemplate>
                                    <span class="ss-name"><%# Eval("SemakanIK_NamaSyarikat") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Lokasi" SortExpression="SemakanIK_AlamatLokasi">
                                <ItemTemplate>
                                    <span class="ss-loc" title='<%# Eval("SemakanIK_AlamatLokasi") %>'><i class="bi bi-geo-alt"></i><%# Eval("SemakanIK_AlamatLokasi") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="SemakanIK_TarikhSemakan" HeaderText="Tarikh Semakan" DataFormatString="{0:dd/MM/yyyy}" SortExpression="SemakanIK_TarikhSemakan" ItemStyle-CssClass="ss-nowrap" />
                            <asp:TemplateField HeaderText="Hasil Pemeriksaan" SortExpression="SemakanIK_StatusPemeriksaan">
                                <ItemTemplate>
                                    <span class='ss-badge <%# GetHasilCss(Eval("SemakanIK_StatusPemeriksaan")) %>'><%# GetHasilText(Eval("SemakanIK_StatusPemeriksaan")) %></span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Status" SortExpression="SemakanIK_Status">
                                <ItemTemplate>
                                    <span class='ss-status <%# GetStatusCss(Eval("SemakanIK_Status")) %>'><%# Eval("SemakanIK_Status") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField ShowHeader="False" ItemStyle-CssClass="ss-col-act">
                                <ItemTemplate>
                                    <asp:LinkButton
                                        runat="server"
                                        Text="Lihat"
                                        CommandName="Select"
                                        CausesValidation="False"
                                        ID="LinkButton2"
                                        CssClass='<%# If(CanSemak(Eval("SemakanIK_Status")), "btn btn-warning btn-sm", "btn btn-primary btn-sm") %>'
                                        />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="ss-empty">
                                <i class="bi bi-clipboard-check"></i>
                                Tiada rekod semakan buat masa ini.
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>

            <asp:SqlDataSource ID="SqlDataSourceGridSemakan" runat="server" OnSelected="SqlDataSourceGridSemakan_Selected"
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
            <asp:Panel ID="pnlCarian" runat="server" Visible="true">

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
                                        placeholder="Imbas / taip kod QR"
                                        onfocus="handleFocus(this);"
                                        autocomplete="off" />

                                </div>

                                <asp:Button
                                    ID="btnScanQR"
                                    runat="server"
                                    CssClass="btn-modern btn-blue"
                                    Text="Semak QR"
                                    CausesValidation="False" />

                            </div>

                        </div>


                        <style>
                        .qr-modal-overlay {
                            position: fixed; top:0; left:0; width:100%; height:100%;
                            background: rgba(0,0,0,0.5); z-index: 9999;
                            display: flex; align-items: center; justify-content: center;
                        }
                        .qr-modal-box, .qr-scanner-box {
                            background:#fff; padding:20px; border-radius:10px;
                            width:90%; max-width:360px; text-align:center;
                        }
                        .qr-modal-box button, .qr-scanner-box button {
                            display:block; width:100%; margin:8px 0; padding:12px;
                            border-radius:8px; border:1px solid #ccc; font-size:15px; cursor:pointer;
                        }
                        .btn-scan { background:#2e7d32; color:#fff; border:none; }
                        .btn-manual { background:#1565c0; color:#fff; border:none; }
                        .btn-cancel { background:#eee; }
                        </style>
                        <!-- Modal pilihan -->
                        <div id="qrChoiceModal" class="qr-modal-overlay" style="display:none;">
                            <div class="qr-modal-box">
                                <h4>Pilih cara masukkan kod QR</h4>
                                <button type="button" class="btn-scan" onclick="startQRScan()">
                                    📷 Imbas QR
                                </button>
                                <button type="button" class="btn-manual" onclick="closeModalAndFocus()">
                                    ⌨️ Masukkan Manual
                                </button>
                                <button type="button" class="btn-cancel" onclick="closeQRModal()">
                                    Batal
                                </button>
                            </div>
                        </div>

                        <!-- Modal camera scanner -->
                        <div id="qrScannerModal" class="qr-modal-overlay" style="display:none;">
                            <div class="qr-scanner-box">
                                <div id="qrReader" style="width:100%;"></div>
                                <button type="button" class="btn-cancel" onclick="stopQRScan()">Tutup Kamera</button>
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
                                            DataField="TarikhPengesahanBanting2"
                                            HeaderText="Tarikh Luput"
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
                                                <%--Tiada rekod dijumpai--%>
                                                <asp:Button
                                                    ID="btnTiadaRekod"
                                                    runat="server"
                                                    CssClass="btn-modern btn-danger-modern"
                                                    Text="Cipta Rekod Permeriksaan Baharu"
                                                    CausesValidation="False"
                                                    OnClick="btnTiadaRekod_Click" />
                                            </div>

                                            <div class="empty-description">
                                                Tiada Rekod / Tidak Berdaftar.
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
                            ID="btnBatalCarian"
                            runat="server"
                            CssClass="btn-modern btn-back"
                            Text="Lihat Senarai"
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

    <asp:Panel ID="pnlIklanBerdaftar" runat="server">
        
<%--            <div class="wf-head wf-head-ik">
                <div class="wf-head-icon">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 6L9 17l-5-5"/></svg>
                </div>
                <h3>Status Pendaftaran Iklan</h3>
            </div>--%>
            <div class="wf-body">

                <asp:FormView ID="FormViewIklanBerdaftar" runat="server"
                    DataSourceID="SqlDataSourceIklanBerdaftar"
                    DefaultMode="ReadOnly" RenderOuterTable="false">
                    <ItemTemplate>
                        <div class='<%# "ru-berdaftar-banner " & GetBannerModifierClass(Container.DataItem) %>'>

                            <div class="ru-berdaftar-check">
                                <svg class="ru-icon-ok" width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6L9 17l-5-5"/></svg>
                                <svg class="ru-icon-x" width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><path d="M18 6L6 18M6 6l12 12"/></svg>
                            </div>

                            <div class="ru-berdaftar-main">
                                <p class="ru-berdaftar-title"><%# GetTajukIklanBanner(Container.DataItem) %></p>
                                <p class="ru-berdaftar-sub">No. Pendaftaran :
                                    <span class="ru-berdaftar-strongval"><%# Eval("NoPendaftaran") %></span>
                                </p>
                                <p class="ru-berdaftar-sub"><b><i>
                                    <%# GetSemakanIKText(Eval("cntSemakanIK")) %>
                                </i></b></p>
                            </div>

                            <%--<div class="ru-berdaftar-divider"></div>--%>

                            <div class="ru-berdaftar-item">
                                <div class="ru-berdaftar-icon">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/></svg>
                                </div>
                                <div>
                                    <p class="ru-berdaftar-label">Tempoh Iklan</p>
                                    <p class="ru-berdaftar-value">
                                        <%# Eval("TarikhPengesahanBanting1", "{0:dd MMM yyyy}") %> – <%# Eval("TarikhPengesahanBanting2", "{0:dd MMM yyyy}") %>
                                    </p>
                                </div>
                            </div>

                            <div class="ru-berdaftar-divider"></div>

                            <div class="ru-berdaftar-item">
                                <div class="ru-berdaftar-icon">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 12l2 2 4-4"/><rect x="3" y="3" width="18" height="18" rx="4"/></svg>
                                </div>
                                <div>
                                    <p class="ru-berdaftar-label">Kelulusan DBP</p>
                                    <p class="ru-berdaftar-value ru-berdaftar-value--strong">
                                        <%# IIf(Eval("StatusBanting").ToString() = "1", "LULUS", IIf(Eval("StatusBanting").ToString() = "0", "TIDAK LULUS", "DALAM PROSES")) %></p>
                                    <p class="ru-berdaftar-note">
                                        No. Kelulusan :<br />
                                        <%# Eval("NoPengesahanBanting") %>
                                    </p>
                                </div>
                            </div>

<%--<asp:Label ID="lblStatusAktifBanner" runat="server" CssClass="ru-pill-aktif"
    Text='<%# GetStatusAktifBanner(Container.DataItem) %>' />--%>

                                                    </div>
                    </ItemTemplate>
                    <EmptyDataTemplate>
                        <p class="ru-list-empty-sub">Tiada data pendaftaran dijumpai.</p>
                    </EmptyDataTemplate>
                </asp:FormView>

            </div>
        
    </asp:Panel>

    <asp:SqlDataSource ID="SqlDataSourceIklanBerdaftar" runat="server"
        ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
        SelectCommand="
        SELECT *,
        (SELECT COUNT(*) FROM LESEN_SepandukSemakanIK x where x.SemakanIK_PermohonanID = a.Permohonan_ID ) as cntSemakanIK
        FROM LESEN_Permohonan a
        
        WHERE a.Permohonan_ID = @Permohonan_ID">
        <SelectParameters>
            <asp:ControlParameter ControlID="GridViewCarian" Name="Permohonan_ID" PropertyName="SelectedValue" />
        </SelectParameters>
    </asp:SqlDataSource>

        <%--# maklumat ringkas (jika rekod dijumpai) #--%>
        <asp:Panel ID="pnlMaklumatDijumpai" runat="server" Visible="false" >

        <%--maklumat iklan--%>
        <div class="ru-section">
            <div class="ru-section-head">
                <div class="ru-section-icon">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2 2 7l10 5 10-5-10-5Z"/><path d="M2 17l10 5 10-5"/><path d="M2 12l10 5 10-5"/></svg>
                </div>
                <h4 class="ru-section-title">Maklumat Iklan</h4>
            </div>

            <asp:FormView ID="FormViewMaklumatIklan" runat="server"
                DataSourceID="SqlDataSourceIklanBerdaftar"
                DefaultMode="ReadOnly" RenderOuterTable="false">
                <ItemTemplate>
                    <div class="ru-detail-list">

                        <div class="ru-detail-row">
                            <div class="ru-detail-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 21h18M6 21V7l6-4 6 4v14M9 9h1m4 0h1m-6 4h1m4 0h1m-6 4h1m4 0h1"/></svg>
                            </div>
                            <div class="ru-detail-text">
                                <span class="ru-detail-label">Nama Pencetak / Syarikat</span>
                                <span class="ru-detail-colon">:</span>
                                <span class="ru-detail-value"><%# Eval("KontraktorIklan") %></span>
                            </div>
                        </div>

                        <div class="ru-detail-row">
                            <div class="ru-detail-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                            </div>
                            <div class="ru-detail-text">
                                <span class="ru-detail-label">Nama Pemilik Iklan</span>
                                <span class="ru-detail-colon">:</span>
                                <span class="ru-detail-value"><%# Eval("NamaSyarikat") %></span>
                            </div>
                        </div>

                        <div class="ru-detail-row">
                            <div class="ru-detail-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/></svg>
                            </div>
                            <div class="ru-detail-text">
                                <span class="ru-detail-label">Tempoh Iklan</span>
                                <span class="ru-detail-colon">:</span>
                                <span class="ru-detail-value">
                                    <%# Eval("TarikhPengesahanBanting1", "{0:dd MMM yyyy}") %> – <%# Eval("TarikhPengesahanBanting2", "{0:dd MMM yyyy}") %>
                                </span>
                            </div>
                        </div>

                        <div class="ru-detail-row">
                            <div class="ru-detail-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 12l2 2 4-4"/><rect x="3" y="3" width="18" height="18" rx="4"/></svg>
                            </div>
                            <div class="ru-detail-text">
                                <span class="ru-detail-label">Kelulusan DBP</span>
                                <span class="ru-detail-colon">:</span>
                                <span class="ru-detail-value ru-detail-value--status"><%# GetKelulusanStatusHtml(Container.DataItem) %></span>
                            </div>
                        </div>

                        <div class="ru-detail-row">
                            <div class="ru-detail-icon-empty"></div>
                            <div class="ru-detail-text">
                                <span class="ru-detail-label">No. Kelulusan DBP</span>
                                <span class="ru-detail-colon">:</span>
                                <span class="ru-detail-value"><%# Eval("NoPengesahanBanting") %></span>
                            </div>
                        </div>

                    </div>
                </ItemTemplate>
                <EmptyDataTemplate>
                    <p class="ru-list-empty-sub">Tiada maklumat iklan dijumpai.</p>
                </EmptyDataTemplate>
            </asp:FormView>
        </div>

        <%--maklumat gambar--%>
        <div class="ru-section">
            <div class="ru-section-head">
                <div class="ru-section-icon">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><path d="M21 15l-5-5L5 21"/></svg>
                </div>
                <h4 class="ru-section-title">Ilustrasi / Gambar Sepanduk</h4>
            </div>

            <asp:FormView ID="FormViewGambarSepanduk" runat="server"
                DataSourceID="SqlDataSourceIklanBerdaftar"
                DefaultMode="ReadOnly" RenderOuterTable="false">
                <ItemTemplate>
                    <div class="ru-gambar-row">

                        <div class="ru-gambar-preview">
                            <asp:FormView ID="FormViewGambarPreview" runat="server"
                                DataSourceID="SqlDataSourceGambarPreview"
                                DefaultMode="ReadOnly" RenderOuterTable="false">
                                <ItemTemplate>
                                    <asp:Image ID="imgSepandukPreview" runat="server"
                                        ImageUrl='<%# Eval("PermohonanFail_FilePath") %>'
                                        AlternateText="Gambar Sepanduk"
                                        CssClass="ru-gambar-img" />
                                </ItemTemplate>
                                <EmptyDataTemplate>
                                    <div class="ru-gambar-img-placeholder">Tiada gambar</div>
                                </EmptyDataTemplate>
                            </asp:FormView>
                        </div>

                        <div class="ru-gambar-info">
                            <div>
                                <div class="ru-detail-row">
                                    <div class="ru-detail-icon">
                                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.59 13.41L11 3.83A2 2 0 0 0 9.59 3.17L4 3a1 1 0 0 0-1 1l.17 5.59a2 2 0 0 0 .66 1.41l9.58 9.58a2 2 0 0 0 2.83 0l4.35-4.35a2 2 0 0 0 0-2.83z"/><circle cx="7.5" cy="7.5" r="1.5"/></svg>
                                    </div>
                                    <div class="ru-detail-text">
                                        <span class="ru-detail-label">Jenis Iklan</span>
                                        <span class="ru-detail-colon">:</span>
                                        <span class="ru-detail-value"><%# Eval("JenisLesenDescList") %></span>
                                    </div>
                                </div>

                                <div class="ru-detail-row">
                                    <div class="ru-detail-icon">
                                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M15 3h6v6M9 21H3v-6M21 3l-7 7M3 21l7-7"/></svg>
                                    </div>
                                    <div class="ru-detail-text">
                                        <span class="ru-detail-label">Saiz</span>
                                        <span class="ru-detail-colon">:</span>
                                        <span class="ru-detail-value"><%# Eval("UkuranBanting") %></span>
                                    </div>
                                </div>

                                <div class="ru-detail-row">
                                    <div class="ru-detail-icon">
                                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2 2 7l10 5 10-5-10-5Z"/><path d="M2 17l10 5 10-5"/><path d="M2 12l10 5 10-5"/></svg>
                                    </div>
                                    <div class="ru-detail-text">
                                        <span class="ru-detail-label">Bilangan</span>
                                        <span class="ru-detail-colon">:</span>
                                        <span class="ru-detail-value"><%# Eval("BilBanting") %> unit</span>
                                    </div>
                                </div>
                            </div>

                            <button type="button" class="ru-btn-lihat-gambar" onclick="ruBukaModalGambar()">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/></svg>
                                Lihat Semua Gambar
                            </button>
                        </div>

                    </div>
                </ItemTemplate>
                <EmptyDataTemplate>
                    <p class="ru-list-empty-sub">Tiada gambar sepanduk dijumpai.</p>
                </EmptyDataTemplate>
            </asp:FormView>


            <asp:SqlDataSource ID="SqlDataSourceGambarPreview" runat="server"
                ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                SelectCommand="
                SELECT TOP 1 a.* FROM LESEN_PermohonanFail a
                INNER JOIN LESEN_Permohonan b ON a.PermohonanFail_PermohonanID = b.Permohonan_ID
                WHERE a.PermohonanFail_JenisLampiran = 'U' AND a.PermohonanFail_PermohonanID = @Permohonan_ID
                ORDER BY a.PermohonanFail_ID">
                <SelectParameters>
                    <asp:ControlParameter ControlID="GridViewCarian" Name="Permohonan_ID" PropertyName="SelectedValue" />
                </SelectParameters>
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="SqlDataSourceGambarSepanduk" runat="server"
                ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                SelectCommand="
                SELECT a.*, b.StatusID FROM LESEN_PermohonanFail a
                INNER JOIN LESEN_Permohonan b ON a.PermohonanFail_PermohonanID = b.Permohonan_ID
                WHERE a.PermohonanFail_JenisLampiran = 'U' 
                AND PermohonanFail_ContentType like '%image%'
                AND a.PermohonanFail_PermohonanID = @Permohonan_ID">
                <SelectParameters>
                    <asp:ControlParameter ControlID="GridViewCarian" Name="Permohonan_ID" PropertyName="SelectedValue" />
                </SelectParameters>
            </asp:SqlDataSource>

        </div>

        <div id="ruModalGambar" class="ru-modal-overlay">
            <div class="ru-modal-content">
                <button type="button" class="ru-modal-close" onclick="ruTutupModalGambar()">&times;</button>
                <button type="button" class="ru-modal-arrow ru-modal-arrow-left" onclick="ruGambarSebelum()">&#10094;</button>

                <div class="ru-modal-slides">
                    <asp:Repeater ID="RepeaterGambarSepanduk" runat="server" DataSourceID="SqlDataSourceGambarSepanduk">
                        <ItemTemplate>
                            <div class="ru-modal-slide">
                                <img src='<%# ResolveUrl(Eval("PermohonanFail_FilePath").ToString()) %>' alt="Gambar Sepanduk" />
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <button type="button" class="ru-modal-arrow ru-modal-arrow-right" onclick="ruGambarSeterusnya()">&#10095;</button>
                <div class="ru-modal-counter"><span id="ruModalCounterText">1 / 1</span></div>
            </div>
        </div>

        </asp:Panel>

        <%--# Alamat lokasi pemeriksaan #--%>
        <div class="ru-row-2col">

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

            <%--# Hasil Pemeriksaan #--%>
            <div class="ru-section">
                <div class="ru-section-head">
                    <div class="ru-section-icon">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 12l2 2 4-4"/><circle cx="12" cy="12" r="9"/></svg>
                    </div>
                    <h4 class="ru-section-title">Hasil Pemeriksaan</h4>
                </div>

                <asp:RadioButtonList ID="rblStatusPemeriksaan" runat="server"
                    CssClass="ru-radio-list" RepeatLayout="Table"
                    RepeatDirection="Vertical" RepeatColumns="2">
                    <asp:ListItem Text="Mematuhi" Value="Mematuhi" Selected="True" />
                    <asp:ListItem Text="Tidak Mematuhi" Value="TidakMematuhi" />
                    <asp:ListItem Text="Iklan Tidak Dijumpai" Value="IklanTidakDijumpai" />
                    <asp:ListItem Text="Lokasi Tidak Tepat" Value="LokasiTidakTepat" />
                    <asp:ListItem Text="Iklan Berbeza Daripada Kelulusan" Value="IklanBerbezaDaripadaKelulusan" />
                </asp:RadioButtonList>
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

                
            </asp:Panel>


            <%--# =========================================================================================== #--%>
            <%--# PAPARAN DETAIL (untuk KB Inspektorat / KB Lesen / KJ Lesen / Kerani Lesen)                    #--%>
            <%--# =========================================================================================== #--%>
            <asp:Panel ID="pnlDetail" runat="server" Visible="false">

                <div class="ss-detail">

                    <%--# Ringkasan kes #--%>
                    <asp:FormView ID="fvRingkasan" runat="server" DataSourceID="SqlDataSourceDetail" DefaultMode="ReadOnly" RenderOuterTable="false">
                        <ItemTemplate>
                            <div class="ss-summary">
                                <div class="ss-summary-main">
                                    <div class="ss-summary-icon"><i class="bi bi-clipboard-check"></i></div>
                                    <div>
                                        <div class="ss-summary-label">Semakan Sepanduk</div>
                                        <h3 class="ss-summary-title"><%# Eval("SemakanIK_NoRujukan") %></h3>
                                        <div class="ss-summary-sub">
                                            <span><i class="bi bi-building"></i><%# If(String.IsNullOrWhiteSpace(Convert.ToString(Eval("SemakanIK_NamaSyarikat"))), "-", Eval("SemakanIK_NamaSyarikat")) %></span>
                                            <span><i class="bi bi-calendar3"></i><%# Eval("SemakanIK_TarikhSemakan", "{0:dd/MM/yyyy}") %></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="ss-summary-tags">
                                    <span class='ss-badge <%# GetHasilCss(Eval("SemakanIK_StatusPemeriksaan")) %>'><%# GetHasilText(Eval("SemakanIK_StatusPemeriksaan")) %></span>
                                    <span class='ss-status <%# GetStatusCss(Eval("SemakanIK_Status")) %>'><%# Eval("SemakanIK_Status") %></span>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:FormView>

                        <div class="bs-wrap">
                            <div class="row g-3">

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
                                                    <dl class="ss-info-grid">
                                                        <div class="ss-info">
                                                            <dt><i class="bi bi-hash"></i>No rujukan</dt>
                                                            <dd><%# Eval("SemakanIK_NoRujukan") %></dd>
                                                        </div>
                                                        <div class="ss-info">
                                                            <dt><i class="bi bi-calendar3"></i>Tarikh semakan</dt>
                                                            <dd><%# Eval("SemakanIK_TarikhSemakan", "{0:dd/MM/yyyy}") %></dd>
                                                        </div>
                                                        <div class="ss-info ss-info-wide">
                                                            <dt><i class="bi bi-building"></i>Nama syarikat</dt>
                                                            <dd><%# GetNilai(Eval("SemakanIK_NamaSyarikat")) %></dd>
                                                        </div>
                                                        <div class="ss-info">
                                                            <dt><i class="bi bi-card-text"></i>No pendaftaran</dt>
                                                            <dd><%# GetNilai(Eval("SemakanIK_NoPendaftaran")) %></dd>
                                                        </div>
                                                        <div class="ss-info">
                                                            <dt><i class="bi bi-patch-check"></i>Status lesen</dt>
                                                            <dd><%# GetNilai(Eval("SemakanIK_StatusLesen")) %></dd>
                                                        </div>
                                                        <div class="ss-info ss-info-wide">
                                                            <dt><i class="bi bi-geo-alt"></i>Alamat lokasi</dt>
                                                            <dd><%# GetNilai(Eval("SemakanIK_AlamatLokasi")) %></dd>
                                                        </div>
                                                        <div class="ss-info">
                                                            <dt><i class="bi bi-clipboard-check"></i>Hasil pemeriksaan</dt>
                                                            <dd><span class='ss-badge <%# GetHasilCss(Eval("SemakanIK_StatusPemeriksaan")) %>'><%# GetHasilText(Eval("SemakanIK_StatusPemeriksaan")) %></span></dd>
                                                        </div>
                                                        <div class="ss-info">
                                                            <dt><i class="bi bi-calendar-range"></i>Tempoh iklan</dt>
                                                            <dd><%# GetTempohIklan(Eval("TarikhPengesahanBanting1"), Eval("TarikhPengesahanBanting2")) %></dd>
                                                        </div>
                                                    </dl>
                                                </ItemTemplate>
                                                <EmptyDataTemplate>
                                                    <div class="ss-empty"><i class="bi bi-file-earmark-x"></i>Butiran semakan tidak dijumpai.</div>
                                                </EmptyDataTemplate>
                                            </asp:FormView>
                                        </div>
                                    </div>

                                    <%--# LEFT JOIN: semakan "Tidak Berdaftar" tiada permohonan #--%>
                                    <asp:SqlDataSource ID="SqlDataSourceDetail" runat="server"
                                        ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                                        SelectCommand="SELECT a.*,b.TarikhPengesahanBanting1,b.TarikhPengesahanBanting2 FROM LESEN_SepandukSemakanIK a
                                        LEFT JOIN LESEN_Permohonan b ON a.SemakanIK_PermohonanID = b.Permohonan_ID
                                        WHERE SemakanIK_ID = @SemakanIK_ID">
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
                                                    <asp:BoundField DataField="Ulasan_Tarikh" HeaderText="Tarikh" DataFormatString="{0:dd/MM/yyyy hh:mm tt}" ItemStyle-CssClass="ss-nowrap" />
                                                </Columns>
                                                <EmptyDataTemplate>
                                                    <span class="ss-muted-note">Tiada ulasan.</span>
                                                </EmptyDataTemplate>
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
                                                        <a class="bs-attach-item" href='<%# GetFileUrl(Eval("Lampiran_FilePath")) %>' target="_blank" rel="noopener">
                                                            <i class="bi bi-file-earmark"></i>
                                                            <span class="ss-attach-name"><%# Eval("Lampiran_FileName") %></span>
                                                            <i class="bi bi-box-arrow-up-right ss-attach-open"></i>
                                                        </a>
                                                    </ItemTemplate>
                                                    <FooterTemplate>
                                                        <asp:Label runat="server" CssClass="ss-muted-note" Text="Tiada lampiran."
                                                            Visible='<%# DirectCast(DirectCast(Container, RepeaterItem).NamingContainer, Repeater).Items.Count = 0 %>' />
                                                    </FooterTemplate>
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
                            <div class="wf-body">
                                <%-- Laluan berliku (ringkasan): kanan -> turun -> kiri -> turun. Dibina dalam BuildTrailRoad() --%>
                                <asp:Literal ID="litTrailRoad" runat="server" />

                            </div>
                        </div>
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

                    <div class="ss-detail-foot" runat="server" id="idFooterKembali">
                        <asp:Button ID="btnKembaliDetail" runat="server" CssClass="btn btn-default" Text="&larr; Kembali Ke Senarai" CausesValidation="False" />
                    </div>
                </div>

            </asp:Panel>

        </div>
    </section>
</div>

    <script>
        function pageLoad() {
            $(function () {
                $('.select2').select2();
                $('.datepicker').datepicker({ dateFormat: 'yy-mm-dd', autoclose: true });
            });
        }
    </script>

<script>
    var ruSlideIndex = 0;

    function ruBukaModalGambar() {
        document.getElementById('ruModalGambar').classList.add('is-open');
        ruSlideIndex = 0;
        ruPaparSlide();
    }

    function ruTutupModalGambar() {
        document.getElementById('ruModalGambar').classList.remove('is-open');
    }

    function ruGambarSeterusnya() {
        var slides = document.querySelectorAll('#ruModalGambar .ru-modal-slide');
        if (slides.length === 0) return;
        ruSlideIndex = (ruSlideIndex + 1) % slides.length;
        ruPaparSlide();
    }

    function ruGambarSebelum() {
        var slides = document.querySelectorAll('#ruModalGambar .ru-modal-slide');
        if (slides.length === 0) return;
        ruSlideIndex = (ruSlideIndex - 1 + slides.length) % slides.length;
        ruPaparSlide();
    }

    function ruPaparSlide() {
        var slides = document.querySelectorAll('#ruModalGambar .ru-modal-slide');
        slides.forEach(function (slide, i) {
            slide.style.display = (i === ruSlideIndex) ? 'flex' : 'none';
        });
        var counter = document.getElementById('ruModalCounterText');
        if (counter) counter.innerText = (ruSlideIndex + 1) + ' / ' + slides.length;
    }
</script>

</asp:Content>
