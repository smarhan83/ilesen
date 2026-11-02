<%@ Page Title="" Language="VB" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="laporanpermohonan.aspx.vb" Inherits="laporanpermohonan" %>

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

        .li-stats { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 12px; padding: 16px 20px; }
        .li-stat { border: 1px solid #e3e8f2; border-radius: 12px; padding: 12px 14px; background: #fff; }
        .li-stat .k { font-size: 12px; color: #64748b; font-weight: 600; }
        .li-stat .v { font-size: 24px; font-weight: 800; color: #1f2937; line-height: 1.2; }
        .li-stat.ok .v { color: #1e7e34; } .li-stat.bad .v { color: #C0392B; } .li-stat.wait .v { color: #9A6408; } .li-stat.info .v { color: #2E3192; }

        .li-table { width: 100%; max-width: 100%; margin: 0 !important; font-size: 12px; table-layout: fixed; }
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
                    <h1 class="m-0 text-dark"><div runat="server" id="idWindowTitle">Laporan Permohonan</div></h1>
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
                        <h3 class="li-title"><asp:Literal ID="litTajukPaparan" runat="server" Text="Laporan Permohonan Lesen Perniagaan / Permit" /></h3>
                        <div class="li-sub"><asp:Literal ID="litSubTajukPaparan" runat="server" Text="Senarai permohonan lesen mengikut jenis laporan yang dipilih" /></div>
                    </div>
                </div>

                <%--# FILTER #--%>
                <asp:Panel ID="pnlFilter" runat="server" CssClass="li-filter" DefaultButton="btnJana">
                    <div class="li-frow">
                        <div class="li-f li-f-w">
                            <label class="li-label">Jenis Laporan</label>
                            <asp:DropDownList ID="ddlReport" runat="server" CssClass="form-control select2" AutoPostBack="true" CausesValidation="false">
                                <asp:ListItem Value="1" Selected="True">Lesen Perniagaan / Permit</asp:ListItem>
                                <asp:ListItem Value="2">Lesen Pembatalan</asp:ListItem>
                                <asp:ListItem Value="3">Belum Dapat Ulasan Inspektorat</asp:ListItem>
                                <asp:ListItem Value="4">Lesen Sepanduk</asp:ListItem>
                                <asp:ListItem Value="5">Lesen Pasar Lambak / Pasar Pagi</asp:ListItem>
                                <asp:ListItem Value="6">Lesen Anjing</asp:ListItem>
                                <asp:ListItem Value="7">Lesen Penjaja</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="li-f">
                            <label class="li-label">Tarikh Mohon (Dari)</label>
                            <asp:TextBox ID="txtDari" runat="server" TextMode="Date" CssClass="form-control" />
                        </div>
                        <div class="li-f">
                            <label class="li-label">Tarikh Mohon (Hingga)</label>
                            <asp:TextBox ID="txtHingga" runat="server" TextMode="Date" CssClass="form-control" />
                        </div>
                        <div class="li-f" id="pnlStatus" runat="server">
                            <label class="li-label">Status</label>
                            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control select2">
                                <asp:ListItem Value="0">-- Semua Status --</asp:ListItem>
                                <asp:ListItem Value="1">Dalam Proses</asp:ListItem>
                                <asp:ListItem Value="2">Lulus</asp:ListItem>
                                <asp:ListItem Value="3">Tolak</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="li-f" id="pnlJenisPerniagaan" runat="server">
                            <label class="li-label">Jenis Perniagaan</label>
                            <asp:TextBox ID="txtJenisPerniagaan" runat="server" CssClass="form-control" placeholder="Cth: Runcit / Restoran" />
                        </div>
                        <div class="li-f li-f-w">
                            <label class="li-label">Carian</label>
                            <asp:TextBox ID="txtCari" runat="server" CssClass="form-control" placeholder="No. fail / nama pemohon / syarikat" />
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
                    <h2><asp:Literal ID="litTajukCetak" runat="server" /></h2>
                    <div><asp:Literal ID="litTempohCetak" runat="server" /></div>
                </div>

                <asp:Literal ID="litAmaran" runat="server" />

                <%-- Ringkasan Statistik --%>
                <div class="li-stats" id="pnlStats" runat="server">
                    <div class="li-stat info">
                        <div class="k">Jumlah Permohonan</div>
                        <div class="v"><asp:Literal ID="litJumlah" runat="server" Text="0" /></div>
                    </div>
                    <div class="li-stat ok" id="statBox1" runat="server">
                        <div class="k"><asp:Literal ID="litStatLbl1" runat="server" Text="Lulus" /></div>
                        <div class="v"><asp:Literal ID="litStat1" runat="server" Text="0" /></div>
                    </div>
                    <div class="li-stat bad" id="statBox2" runat="server">
                        <div class="k"><asp:Literal ID="litStatLbl2" runat="server" Text="Tolak" /></div>
                        <div class="v"><asp:Literal ID="litStat2" runat="server" Text="0" /></div>
                    </div>
                    <div class="li-stat wait" id="statBox3" runat="server">
                        <div class="k"><asp:Literal ID="litStatLbl3" runat="server" Text="Dalam Proses" /></div>
                        <div class="v"><asp:Literal ID="litStat3" runat="server" Text="0" /></div>
                    </div>
                </div>

                <div class="table-responsive">

                    <%-- 1. TEMPLATE LAPORAN PERMOHONAN LESEN PERNIAGAAN / PERMIT --%>
                    <asp:Repeater ID="rptReport1" runat="server" Visible="false">
                        <HeaderTemplate>
                            <table class="li-table table">
                                <colgroup>
                                    <col style="width:3.5%" /><col style="width:10%" /><col style="width:13%" /><col style="width:16%" /><col style="width:16%" /><col style="width:20%" /><col style="width:12%" /><col style="width:9.5%" />
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>Bil</th>
                                        <th>Tarikh Permohonan</th>
                                        <th>No Fail</th>
                                        <th>Nama Pemohon</th>
                                        <th>Nama Syarikat</th>
                                        <th>Alamat Perniagaan</th>
                                        <th>Jenis Perniagaan/Permit</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td class="c"><%# Container.ItemIndex + 1 %></td>
                                <td class="c"><%# Tgl(Eval("TarikhMohon")) %></td>
                                <td><span class="li-ref"><%# HttpUtility.HtmlEncode(Eval("Rujukan")) %></span></td>
                                <td><%# HttpUtility.HtmlEncode(Eval("Pemohon_Name")) %></td>
                                <td><%# HttpUtility.HtmlEncode(Eval("NamaSyarikat")) %></td>
                                <td><%# HttpUtility.HtmlEncode(Eval("AlamatPremis")) %></td>
                                <td><%# HttpUtility.HtmlEncode(Eval("JenisPerniagaan")) %></td>
                                <td class="c"><span class='li-badge <%# DapatkanStatusBadgeCss(Eval("StatusID")) %>'><%# DapatkanStatus(Eval("StatusID")) %></span></td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                                </tbody>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>

                    <%-- 2. TEMPLATE LAPORAN PERMOHONAN PEMBATALAN --%>
                    <asp:Repeater ID="rptReport2" runat="server" Visible="false">
                        <HeaderTemplate>
                            <table class="li-table table">
                                <colgroup>
                                    <col style="width:3%" /><col style="width:8%" /><col style="width:10%" /><col style="width:12%" /><col style="width:12%" /><col style="width:15%" /><col style="width:10%" /><col style="width:9%" /><col style="width:9%" /><col style="width:6%" /><col style="width:6%" />
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>Bil</th>
                                        <th>Tarikh Permohonan</th>
                                        <th>No Fail</th>
                                        <th>Nama Pemohon</th>
                                        <th>Nama Syarikat</th>
                                        <th>Alamat Perniagaan</th>
                                        <th>Jenis Perniagaan/Permit</th>
                                        <th>Jenis Pembatalan</th>
                                        <th>Sebab Pembatalan</th>
                                        <th>Status Wang Amanah (tindakan pembatalan)</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td class="c"><%# Container.ItemIndex + 1 %></td>
                                <td class="c"><%# Tgl(Eval("TarikhMohon")) %></td>
                                <td><span class="li-ref"><%# HttpUtility.HtmlEncode(Eval("Rujukan")) %></span></td>
                                <td><%# HttpUtility.HtmlEncode(Eval("Pemohon_Name")) %></td>
                                <td><%# HttpUtility.HtmlEncode(Eval("NamaSyarikat")) %></td>
                                <td><%# HttpUtility.HtmlEncode(Eval("AlamatPremis")) %></td>
                                <td><%# HttpUtility.HtmlEncode(Eval("JenisPerniagaan")) %></td>
                                <td><%# HttpUtility.HtmlEncode(Eval("JenisBatal")) %></td>
                                <td><%# HttpUtility.HtmlEncode(Eval("SebabBatal")) %></td>
                                <td><%# HttpUtility.HtmlEncode(Eval("TindakanBatal")) %></td>
                                <td class="c"><span class='li-badge <%# DapatkanStatusBadgeCss(Eval("StatusID")) %>'><%# DapatkanStatus(Eval("StatusID")) %></span></td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                                </tbody>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>

                    <%-- 3. TEMPLATE LAPORAN PERMOHONAN BELUM DAPAT ULASAN INSPEKTORAT --%>
                    <asp:Repeater ID="rptReport3" runat="server" Visible="false">
                        <HeaderTemplate>
                            <table class="li-table table">
                                <colgroup>
                                    <col style="width:3.5%" /><col style="width:10%" /><col style="width:13%" /><col style="width:16%" /><col style="width:16%" /><col style="width:20%" /><col style="width:12%" /><col style="width:9.5%" />
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>Bil</th>
                                        <th>Tarikh Permohonan</th>
                                        <th>No Fail</th>
                                        <th>Nama Pemohon</th>
                                        <th>Nama Syarikat</th>
                                        <th>Alamat Perniagaan</th>
                                        <th>Jenis Perniagaan/Permit/ Pembatalan</th>
                                        <th>Status Ulasan Inspektorat</th>
                                    </tr>
                                </thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td class="c"><%# Container.ItemIndex + 1 %></td>
                                <td class="c"><%# Tgl(Eval("TarikhMohon")) %></td>
                                <td><span class="li-ref"><%# HttpUtility.HtmlEncode(Eval("Rujukan")) %></span></td>
                                <td><%# HttpUtility.HtmlEncode(Eval("Pemohon_Name")) %></td>
                                <td><%# HttpUtility.HtmlEncode(Eval("NamaSyarikat")) %></td>
                                <td><%# HttpUtility.HtmlEncode(Eval("AlamatPremis")) %></td>
                                <td><%# HttpUtility.HtmlEncode(Eval("JenisPerniagaan")) %></td>
                                <td class="c"><span class='li-badge <%# DapatkanStatusUlasanBadgeCss(Eval("IsBatal"), Eval("StatusUlasan"), Eval("StatusUlasanBatal")) %>'><%# DapatkanStatusUlasan(Eval("IsBatal"), Eval("StatusUlasan"), Eval("StatusUlasanBatal")) %></span></td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                                </tbody>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>

                    <%-- 4. TEMPLATE LAPORAN PERMOHONAN LESEN SEPANDUK --%>
                    <asp:Repeater ID="rptReport4" runat="server" Visible="false">
                        <HeaderTemplate>
                            <table class="li-table table">
                                <colgroup>
                                    <col style="width:3%" /><col style="width:8%" /><col style="width:10%" /><col style="width:13%" /><col style="width:12%" /><col style="width:11%" /><col style="width:16%" /><col style="width:8%" /><col style="width:7%" /><col style="width:6%" /><col style="width:3%" /><col style="width:3%" />
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>Bil</th>
                                        <th>Tarikh Permohonan</th>
                                        <th>No Fail</th>
                                        <th>Nama Pemohon/ Nama Syarikat</th>
                                        <th>Nama Kontraktor Yang Memasang Iklan</th>
                                        <th>Tempoh Pemasangan</th>
                                        <th>Lokasi Pemasangan</th>
                                        <th>No Resit</th>
                                        <th>No Siri Stiker</th>
                                        <th>Jenis Permit Sepanduk /Bunting</th>
                                        <th>Ukuran</th>
                                        <th>Qty</th>
                                    </tr>
                                </thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td class="c"><%# Container.ItemIndex + 1 %></td>
                                <td class="c"><%# Tgl(Eval("TarikhMohon")) %></td>
                                <td><span class="li-ref"><%# HttpUtility.HtmlEncode(Eval("Rujukan")) %></span></td>
                                <td><%# HttpUtility.HtmlEncode(Eval("Pemohon_Name")) %></td>
                                <td><%# HttpUtility.HtmlEncode(Eval("KontraktorIklan")) %></td>
                                <td class="c"><%# FormatTempohBanting(Eval("TarikhBanting1"), Eval("TarikhBanting2")) %></td>
                                <td><%# FormatLokasiSepandukHtml(Eval("LokasiList")) %></td>
                                <td class="c"><%# HttpUtility.HtmlEncode(Eval("NoResitBanting")) %></td>
                                <td class="c"><%# HttpUtility.HtmlEncode(Eval("NoSiriStiker")) %></td>
                                <td><%# HttpUtility.HtmlEncode(Eval("JenisBanting")) %></td>
                                <td class="c"><%# HttpUtility.HtmlEncode(Eval("UkuranBanting")) %></td>
                                <td class="c"><%# HttpUtility.HtmlEncode(Eval("BilBanting")) %></td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                                </tbody>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>

                    <%-- 5. TEMPLATE LAPORAN PERMOHONAN LESEN PASAR LAMBAK / PASAR PAGI --%>
                    <asp:Repeater ID="rptReport5" runat="server" Visible="false">
                        <HeaderTemplate>
                            <table class="li-table table">
                                <colgroup>
                                    <col style="width:3.5%" /><col style="width:10%" /><col style="width:13%" /><col style="width:16%" /><col style="width:22%" /><col style="width:17%" /><col style="width:8.5%" /><col style="width:10%" />
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>Bil</th>
                                        <th>Tarikh Permohonan</th>
                                        <th>No Fail</th>
                                        <th>Nama Pemohon</th>
                                        <th>Lokasi Pasar Lambak</th>
                                        <th>Jenis Perniagaan (Jenis Jualan)</th>
                                        <th>Jumlah Petak</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td class="c"><%# Container.ItemIndex + 1 %></td>
                                <td class="c"><%# Tgl(Eval("TarikhMohon")) %></td>
                                <td><span class="li-ref"><%# HttpUtility.HtmlEncode(Eval("Rujukan")) %></span></td>
                                <td><%# HttpUtility.HtmlEncode(Eval("Pemohon_Name")) %></td>
                                <td><%# FormatLokasiPasarHtml(Eval("LokasiPasar1"), Eval("LokasiPasar2"), Eval("LokasiPasar3")) %></td>
                                <td><%# HttpUtility.HtmlEncode(Eval("JenisPerniagaanPasar")) %></td>
                                <td class="c"><%# HttpUtility.HtmlEncode(Eval("JumlahPetak")) %></td>
                                <td class="c"><span class='li-badge <%# DapatkanStatusBadgeCss(Eval("StatusID")) %>'><%# DapatkanStatus(Eval("StatusID")) %></span></td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                                </tbody>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>

                    <%-- 6. TEMPLATE LAPORAN PERMOHONAN LESEN ANJING --%>
                    <asp:Repeater ID="rptReport6" runat="server" Visible="false">
                        <HeaderTemplate>
                            <table class="li-table table">
                                <colgroup>
                                    <col style="width:3.5%" /><col style="width:9%" /><col style="width:12%" /><col style="width:15%" /><col style="width:21%" /><col style="width:7%" /><col style="width:12%" /><col style="width:11%" /><col style="width:9.5%" />
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>Bil</th>
                                        <th>Tarikh Permohonan</th>
                                        <th>No Fail</th>
                                        <th>Nama Pemohon</th>
                                        <th>Alamat Premis</th>
                                        <th>Jumlah Anjing</th>
                                        <th>Jenis Lesen Anjing</th>
                                        <th>Baka Anjing</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td class="c"><%# Container.ItemIndex + 1 %></td>
                                <td class="c"><%# Tgl(Eval("TarikhMohon")) %></td>
                                <td><span class="li-ref"><%# HttpUtility.HtmlEncode(Eval("Rujukan")) %></span></td>
                                <td><%# HttpUtility.HtmlEncode(Eval("Pemohon_Name")) %></td>
                                <td><%# HttpUtility.HtmlEncode(Eval("AnjingAlamat")) %></td>
                                <td class="c"><%# FormatJumlahAnjing(Eval("AnjingJantanList"), Eval("AnjingBetinaList"), Eval("AnjingJantanMandulList"), Eval("AnjingBetinaMandulList")) %></td>
                                <td><%# HttpUtility.HtmlEncode(Eval("AnjingJenisPremis")) %></td>
                                <td><%# HttpUtility.HtmlEncode(FormatBakaAnjing(Eval("BakaAnjingList"))) %></td>
                                <td class="c"><span class='li-badge <%# DapatkanStatusBadgeCss(Eval("StatusID")) %>'><%# DapatkanStatus(Eval("StatusID")) %></span></td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                                </tbody>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>

                    <%-- 7. TEMPLATE LAPORAN PERMOHONAN LESEN PENJAJA --%>
                    <asp:Repeater ID="rptReport7" runat="server" Visible="false">
                        <HeaderTemplate>
                            <table class="li-table table">
                                <colgroup>
                                    <col style="width:4%" /><col style="width:11%" /><col style="width:14%" /><col style="width:18%" /><col style="width:25%" /><col style="width:18%" /><col style="width:10%" />
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>Bil</th>
                                        <th>Tarikh Permohonan</th>
                                        <th>No Fail</th>
                                        <th>Nama Pemohon</th>
                                        <th>Lokasi Penjaja</th>
                                        <th>Jenis Perniagaan (Jenis Jualan)</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td class="c"><%# Container.ItemIndex + 1 %></td>
                                <td class="c"><%# Tgl(Eval("TarikhMohon")) %></td>
                                <td><span class="li-ref"><%# HttpUtility.HtmlEncode(Eval("Rujukan")) %></span></td>
                                <td><%# HttpUtility.HtmlEncode(Eval("Pemohon_Name")) %></td>
                                <td><%# HttpUtility.HtmlEncode(Eval("AlamatPenjajaan")) %></td>
                                <td><%# HttpUtility.HtmlEncode(Eval("JenisPerniagaanPenjaja")) %></td>
                                <td class="c"><span class='li-badge <%# DapatkanStatusBadgeCss(Eval("StatusID")) %>'><%# DapatkanStatus(Eval("StatusID")) %></span></td>
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
                    <asp:Literal ID="litNota" runat="server" />
                </div>
            </div>

        </div>
    </section>

</asp:Content>