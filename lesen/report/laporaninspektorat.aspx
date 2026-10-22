<%@ Page Title="" Language="VB" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="laporaninspektorat.aspx.vb" Inherits="laporaninspektorat" %>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">

    <style>
        .li-card { background: #fff; border-radius: 14px; box-shadow: 0 2px 10px rgba(15,23,42,.06); border: 1px solid #e9ecef; overflow: hidden; margin-bottom: 16px; max-width: 100%; }
        .li-head { padding: 16px 20px; background: linear-gradient(120deg,#F4F3FF,#EEF4FF); border-left: 4px solid #2E3192; display: flex; flex-wrap: wrap; gap: 12px; align-items: center; justify-content: space-between; }
        .li-title { font-size: 17px; font-weight: 800; color: #2E3192; margin: 0; }
        .li-sub { font-size: 13px; color: #5B6478; margin-top: 2px; }
        .li-filter { padding: 14px 20px 16px; background: #F8FAFE; border-bottom: 1px solid #E6EBF5; }
        .li-label { display: block; font-size: 12px; font-weight: 600; color: #4B5675; margin-bottom: 4px; }
        .li-frow { display: flex; flex-wrap: wrap; gap: 10px; align-items: flex-end; }
        .li-frow > .li-f { flex: 1 1 150px; min-width: 140px; }
        .li-frow > .li-f-w { flex: 1.6 1 220px; }
        .li-card .li-filter input.form-control { height: 38px !important; margin: 0 !important; border: 1px solid #d0d5dd !important; border-radius: 6px !important; background: #fff; }
        .li-card .li-filter .select2-container { margin: 0 !important; width: 100% !important; }
        .li-card .li-filter .select2-container--default .select2-selection--single { height: 38px !important; margin: 0 !important; border: 1px solid #d0d5dd !important; border-radius: 6px !important; }
        .li-card .li-filter .select2-container--default .select2-selection__rendered { line-height: 36px !important; padding-left: 10px; }
        .li-card .li-filter .select2-container--default .select2-selection__arrow { height: 36px !important; }
        .li-actions { display: flex; flex-wrap: wrap; gap: 8px; margin-left: auto; }
        .li-actions .btn { height: 38px; margin: 0 !important; display: inline-flex; align-items: center; gap: 6px; }

        .li-stats { display: grid; grid-template-columns: repeat(5, minmax(0, 1fr)); gap: 12px; padding: 16px 20px; }
        .li-stat { border: 1px solid #e3e8f2; border-radius: 12px; padding: 12px 14px; background: #fff; }
        .li-stat .k { font-size: 12px; color: #64748b; font-weight: 600; }
        .li-stat .v { font-size: 24px; font-weight: 800; color: #1f2937; line-height: 1.2; }
        .li-stat.ok .v { color: #1e7e34; } .li-stat.bad .v { color: #C0392B; } .li-stat.wait .v { color: #9A6408; } .li-stat.info .v { color: #2E3192; }

        .li-table { width: 100%; max-width: 100%; margin: 0 !important; font-size: 12px; table-layout: fixed; }
        /* custom-admin.css memaksa th satu baris (nowrap) dan fon besar - ganti dengan kekhususan lebih tinggi supaya tajuk berbalut dan tidak bertindih */
        .li-card .li-table { width: 100% !important; table-layout: fixed !important; }
        .li-card .li-table > thead > tr > th { white-space: normal !important; word-break: break-word !important; overflow-wrap: anywhere !important; overflow: hidden; font-size: 11px !important; line-height: 1.25 !important; letter-spacing: 0 !important; text-transform: none !important; padding: 8px 4px !important; }
        .li-card .li-table > tbody > tr > td { white-space: normal !important; padding: 7px 4px !important; }
        .li-table th { background: #EEF1FA; color: #3F4A6B; font-size: 11px; font-weight: 700; line-height: 1.25; padding: 8px 5px; border-bottom: 1px solid #dfe5f1; text-align: center; vertical-align: middle; overflow-wrap: anywhere; }
        .li-table td { padding: 7px 5px; border-bottom: 1px solid #f1f3f5; vertical-align: middle; color: #212529; overflow-wrap: anywhere; word-break: break-word; }
        .li-table td.c { text-align: center; }
        .li-table tr:hover td { background: #F6F7FF; }
        .li-ref { font-weight: 600; color: #2E3192; }
        .li-muted { color: #6c757d; font-size: 12px; }
        .li-badge { display: inline-block; padding: 3px 8px; border-radius: 999px; font-size: 11px; font-weight: 700; line-height: 1.25; }
        .li-badge.ok { background: #D4EDDA; color: #1e7e34; } .li-badge.bad { background: #FCEAEA; color: #C0392B; } .li-badge.wait { background: #FDF1DC; color: #9A6408; }
        .li-empty { text-align: center; padding: 40px 16px; color: #6c757d; }
        .li-note { padding: 10px 20px 14px; font-size: 12px; color: #6c757d; }
        .li-printhead { display: none; }
        .li-warn { margin: 12px 20px 0; padding: 9px 14px; border-radius: 8px; background: #FDF1DC; color: #9A6408; font-size: 12.5px; }

        @media (max-width: 991.98px) { .li-stats { grid-template-columns: repeat(2, minmax(0, 1fr)); } .li-actions { width: 100%; margin-left: 0; } .li-table { table-layout: auto; min-width: 900px; } }

        @media print {
            @page { size: A4 landscape; margin: 10mm; }
            nav, .navbar, .sidebar, .topbar, footer, #plChat, .pl-chat, .content-header, .no-print, .breadcrumb, .li-filter { display: none !important; }
            body, .admin-shell, .content, .container-fluid, .main, main { background: #fff !important; padding: 0 !important; margin: 0 !important; }
            .li-card { box-shadow: none !important; border: 0 !important; margin: 0 !important; }
            .li-head { background: none !important; border: 0 !important; padding: 0 0 6px !important; }
            .li-printhead { display: block; text-align: center; margin-bottom: 8px; }
            .li-printhead h2 { font-size: 16px; font-weight: 800; margin: 0; }
            .li-printhead div { font-size: 11px; color: #333; }
            .li-stats { padding: 6px 0 !important; gap: 6px !important; }
            .li-stat { padding: 6px 8px; } .li-stat .v { font-size: 16px; }
            .li-table { font-size: 10.5px; } .li-table th, .li-table td { padding: 4px 5px; border: 1px solid #999 !important; background: #fff !important; }
            .li-badge { border: 1px solid #999; background: #fff !important; color: #000 !important; }
            thead { display: table-header-group; } tr { page-break-inside: avoid; }
        }
    </style>

    <section class="content-header no-print">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0 text-dark"><div runat="server" id="idWindowTitle">Laporan Inspektorat</div></h1>
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

            <div class="li-card">
                <div class="li-head">
                    <div>
                        <h3 class="li-title">Laporan Inspektorat</h3>
                        <div class="li-sub">Tempoh proses permohonan di Bahagian Inspektorat (KPI: kurang 14 hari bekerja)</div>
                    </div>
                </div>

                <%--# FILTER #--%>
                <asp:Panel ID="pnlFilter" runat="server" CssClass="li-filter" DefaultButton="btnJana">
                    <div class="li-frow">
                        <div class="li-f">
                            <label class="li-label">Tarikh Diterima (Dari)</label>
                            <asp:TextBox ID="txtDari" runat="server" TextMode="Date" CssClass="form-control" />
                        </div>
                        <div class="li-f">
                            <label class="li-label">Tarikh Diterima (Hingga)</label>
                            <asp:TextBox ID="txtHingga" runat="server" TextMode="Date" CssClass="form-control" />
                        </div>
                        <div class="li-f li-f-w">
                            <label class="li-label">Jenis Lesen</label>
                            <asp:DropDownList ID="ddlJenisLesen" runat="server" CssClass="form-control select2"
                                DataSourceID="sdsJenisLesen" DataTextField="JenisLesen_Description" DataValueField="JenisLesen_ID">
                            </asp:DropDownList>
                            <asp:SqlDataSource runat="server" ID="sdsJenisLesen" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                SelectCommand="select * from
                                (select 0 as JenisLesen_ID, '-- Semua Jenis Lesen --' as JenisLesen_Description
                                 union all
                                 select JenisLesen_ID, JenisLesen_Description from LESEN_JenisLesen where JenisLesen_IsActive=1
                                ) as tbl1 order by case when JenisLesen_ID = 0 then 0 else 1 end, JenisLesen_Description"></asp:SqlDataSource>
                        </div>
                        <div class="li-f">
                            <label class="li-label">Status KPI</label>
                            <asp:DropDownList ID="ddlKpi" runat="server" CssClass="form-control select2">
                                <asp:ListItem Value="0">-- Semua --</asp:ListItem>
                                <asp:ListItem Value="1">Dalam KPI (kurang 14 hari)</asp:ListItem>
                                <asp:ListItem Value="2">Melebihi KPI (14 hari atau lebih)</asp:ListItem>
                                <asp:ListItem Value="3">Belum selesai</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="li-f li-f-w">
                            <label class="li-label">Carian</label>
                            <asp:TextBox ID="txtCari" runat="server" CssClass="form-control" placeholder="No. rujukan / nama pemohon / syarikat" />
                        </div>
                        <div class="li-actions">
                            <asp:LinkButton ID="btnJana" runat="server" CssClass="btn btn-primary" CausesValidation="false"><i class="bi bi-search"></i>Jana</asp:LinkButton>
                            <asp:LinkButton ID="btnReset" runat="server" CssClass="btn btn-default" CausesValidation="false"><i class="bi bi-arrow-counterclockwise"></i>Reset</asp:LinkButton>
                            <button type="button" class="btn btn-default" onclick="window.print();"><i class="bi bi-printer"></i>Cetak</button>
                            <asp:LinkButton ID="btnExcel" runat="server" CssClass="btn btn-success" CausesValidation="false" data-no-loader="1"><i class="bi bi-file-earmark-excel"></i>Export Excel</asp:LinkButton>
                        </div>
                    </div>
                </asp:Panel>

                <%-- Tajuk untuk cetakan --%>
                <div class="li-printhead">
                    <h2>LAPORAN INSPEKTORAT</h2>
                    <div>Majlis Perbandaran Kluang &middot; Bahagian Inspektorat</div>
                    <div><asp:Literal ID="litTempohCetak" runat="server" /></div>
                </div>

                <asp:Literal ID="litAmaran" runat="server" />

                <%-- Ringkasan --%>
                <div class="li-stats">
                    <div class="li-stat info"><div class="k">Jumlah Permohonan</div><div class="v"><asp:Literal ID="litJumlah" runat="server" Text="0" /></div></div>
                    <div class="li-stat ok"><div class="k">Dalam KPI</div><div class="v"><asp:Literal ID="litDalam" runat="server" Text="0" /></div></div>
                    <div class="li-stat bad"><div class="k">Melebihi KPI</div><div class="v"><asp:Literal ID="litLebih" runat="server" Text="0" /></div></div>
                    <div class="li-stat wait"><div class="k">Belum Selesai</div><div class="v"><asp:Literal ID="litBelum" runat="server" Text="0" /></div></div>
                    <div class="li-stat info"><div class="k">Purata Tempoh (hari)</div><div class="v"><asp:Literal ID="litPurata" runat="server" Text="-" /></div></div>
                </div>

                <div class="table-responsive">
                    <asp:Repeater ID="rptLaporan" runat="server">
                        <HeaderTemplate>
                            <table class="li-table table">
                                <colgroup><col style="width:3.5%" /><col style="width:12%" /><col style="width:13%" /><col style="width:9%" /><col style="width:10%" /><col style="width:7.5%" /><col style="width:7.5%" /><col style="width:7.5%" /><col style="width:7.5%" /><col style="width:7.5%" /><col style="width:6.5%" /><col style="width:8.5%" /></colgroup>
                                <thead>
                                    <tr>
                                        <th>Bil</th>
                                        <th>No. Rujukan</th>
                                        <th>Pemohon / Syarikat</th>
                                        <th>Jenis Lesen</th>
                                        <th>Jenis Perniagaan</th>
                                        <th>Tarikh Permohonan Diterima daripada KB Lesen (KB)</th>
                                        <th>Tarikh Penetapan Siasatan (PPKP)</th>
                                        <th>Tarikh Siasatan Tapak (PPKP)</th>
                                        <th>Tarikh Ulasan Teknikal (PPKP)</th>
                                        <th>Tarikh Semakan dan Hantar Laporan ke Lesen (KB)</th>
                                        <th>Tempoh Masa (hari bekerja)<br /><span class="li-muted">KPI: &lt;14 hari</span></th>
                                        <th>Status KPI</th>
                                    </tr>
                                </thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td class="c"><%# Container.ItemIndex + 1 %></td>
                                <td><span class="li-ref"><%# HttpUtility.HtmlEncode(Eval("Rujukan")) %></span></td>
                                <td><%# HttpUtility.HtmlEncode(Eval("Pemohon")) %></td>
                                <td><%# HttpUtility.HtmlEncode(Eval("JenisLesen")) %></td>
                                <td><%# HttpUtility.HtmlEncode(Eval("JenisPerniagaan")) %></td>
                                <td class="c"><%# Tgl(Eval("TarikhDiterima")) %></td>
                                <td class="c"><%# Tgl(Eval("TarikhPenetapan")) %></td>
                                <td class="c"><%# Tgl(Eval("TarikhSiasatan")) %></td>
                                <td class="c"><%# Tgl(Eval("TarikhUlasan")) %></td>
                                <td class="c"><%# Tgl(Eval("TarikhHantar")) %></td>
                                <td class="c"><%# Tempoh(Eval("TempohHari"), Eval("Selesai")) %></td>
                                <td class="c"><span class='li-badge <%# KpiCss(Eval("TempohHari"), Eval("Selesai")) %>'><%# KpiTeks(Eval("TempohHari"), Eval("Selesai")) %></span></td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                                </tbody>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>
                    <asp:PlaceHolder ID="phKosong" runat="server" Visible="false">
                        <div class="li-empty"><i class="bi bi-inbox" style="font-size:36px;display:block;margin-bottom:8px;"></i>Tiada rekod untuk kriteria yang dipilih.</div>
                    </asp:PlaceHolder>
                </div>

                <div class="li-note">
                    Nota: Tempoh Masa dikira daripada <b>Tarikh Permohonan Diterima</b> hingga <b>Tarikh Semakan dan Hantar Laporan ke Lesen</b>;
                    dalam <b>hari bekerja</b> (Sabtu, Ahad dan kelepasan am ditolak). Bagi permohonan yang belum selesai, ia dikira sehingga hari ini. Dalam KPI jika kurang 14 hari bekerja.
                </div>
            </div>

        </div>
    </section>
</asp:Content>
