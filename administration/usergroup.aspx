<%@ Page Language="VB" AutoEventWireup="false" CodeFile="usergroup.aspx.vb" Inherits="html_administration_usergroup" MasterPageFile="~/MasterMenu.master" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadContent" runat="Server">
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="Server">

    <style>
        :root { --ug-p: #5B3CC4; --ug-p-soft: #EFEBFC; --ug-line: #E6E8F0; --ug-muted: #6B7280; }
        .ug-wrap { padding-bottom: 20px; }
        .ug-card { background: #fff; border: 1px solid var(--ug-line); border-radius: 14px; box-shadow: 0 2px 10px rgba(30,27,75,.05); }

        .ug-head { display: flex; flex-wrap: wrap; gap: 14px; align-items: center; justify-content: space-between; padding: 18px 22px; margin-bottom: 14px; }
        .ug-title { display: flex; align-items: center; gap: 14px; }
        .ug-title .ic { width: 46px; height: 46px; border-radius: 12px; background: var(--ug-p-soft); color: var(--ug-p); display: flex; align-items: center; justify-content: center; font-size: 22px; }
        .ug-title h3 { margin: 0; font-size: 19px; font-weight: 800; color: #1E1B4B; }
        .ug-title .sub { color: var(--ug-muted); font-size: 13px; margin-top: 2px; }
        .ug-actions { display: flex; flex-wrap: wrap; gap: 8px; }
        .ug-btn { display: inline-flex; align-items: center; gap: 7px; height: 38px; padding: 0 14px; border-radius: 9px; border: 1px solid var(--ug-line); background: #fff; color: #374151; font-weight: 600; font-size: 13.5px; text-decoration: none; cursor: pointer; }
        .ug-btn:hover { background: #F8F7FE; color: #1E1B4B; }
        .ug-btn.primary { background: var(--ug-p); border-color: var(--ug-p); color: #fff; }
        .ug-btn.primary:hover { background: #4B2FB0; color: #fff; }
        .ug-btn.xls i { color: #1e7e34; } .ug-btn.prt i { color: #374151; }
        .ug-btn[disabled], .ug-btn.aspNetDisabled { opacity: .5; pointer-events: none; }

        .ug-stats { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 12px; margin-bottom: 14px; }
        .ug-stat { display: flex; align-items: center; gap: 14px; padding: 14px 16px; border-radius: 12px; }
        .ug-stat .ic { width: 42px; height: 42px; border-radius: 50%; background: #fff; display: flex; align-items: center; justify-content: center; font-size: 19px; }
        .ug-stat .k { font-size: 12.5px; color: #4B5563; }
        .ug-stat .v { font-size: 22px; font-weight: 800; color: #111827; line-height: 1.15; }
        .ug-stat.s1 { background: #F1EDFD; } .ug-stat.s1 .ic { color: var(--ug-p); }
        .ug-stat.s2 { background: #EAF2FF; } .ug-stat.s2 .ic { color: #2563EB; }
        .ug-stat.s3 { background: #E9F8EF; } .ug-stat.s3 .ic { color: #16A34A; }
        .ug-stat.s4 { background: #FFF1E6; } .ug-stat.s4 .ic { color: #EA7A1A; }

        .ug-body { display: grid; grid-template-columns: 250px minmax(0, 1fr); gap: 14px; align-items: start; }
        .ug-groups { padding: 14px 10px; }
        .ug-groups h4 { font-size: 14.5px; font-weight: 800; color: #1E1B4B; margin: 2px 8px 10px; }
        .ug-gitem { display: flex; align-items: center; gap: 8px; border-radius: 10px; margin-bottom: 2px; }
        .ug-gitem a.nm { flex: 1; min-width: 0; display: flex; align-items: center; gap: 10px; padding: 9px 10px; color: #374151; font-size: 13.5px; text-decoration: none; border-radius: 10px; }
        .ug-gitem a.nm span.t { overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
        .ug-gitem a.nm .cnt { margin-left: auto; font-size: 11px; color: var(--ug-muted); background: #F3F4F6; border-radius: 999px; padding: 1px 7px; }
        .ug-gitem a.nm i { color: var(--ug-muted); }
        .ug-gitem:hover { background: #F8F7FE; }
        .ug-gitem.on { background: var(--ug-p-soft); }
        .ug-gitem.on a.nm { color: #1E1B4B; font-weight: 700; }
        .ug-gitem.on a.nm i { color: var(--ug-p); }
        .ug-kebab { border: 0; background: transparent; width: 28px; height: 28px; border-radius: 7px; color: var(--ug-muted); }
        .ug-kebab:hover { background: #fff; color: #1E1B4B; }

        .ug-panel-head { display: flex; flex-wrap: wrap; gap: 10px; align-items: center; justify-content: space-between; padding: 14px 16px; border-bottom: 1px solid var(--ug-line); }
        .ug-panel-head h4 { display: flex; align-items: center; gap: 10px; margin: 0; font-size: 15.5px; font-weight: 800; color: #1E1B4B; }
        .ug-panel-head h4 i { color: var(--ug-p); font-size: 19px; }
        .ug-tools { display: flex; flex-wrap: wrap; gap: 8px; align-items: center; }
        .ug-card .ug-tools select.form-control { height: 38px !important; min-height: 38px !important; margin: 0 !important; width: 170px; border: 1px solid #D0D5DD !important; border-radius: 9px !important; font-size: 13.5px; }
        .ug-search { position: relative; }
        .ug-search i { position: absolute; left: 11px; top: 50%; transform: translateY(-50%); color: var(--ug-muted); }
        .ug-search input { height: 38px; width: 220px; padding: 0 12px 0 32px; border: 1px solid #D0D5DD; border-radius: 9px; font-size: 13.5px; outline: none; }
        .ug-search input:focus { border-color: var(--ug-p); box-shadow: 0 0 0 3px rgba(91,60,196,.12); }

        .ug-tabs { display: flex; gap: 4px; padding: 0 16px; border-bottom: 1px solid var(--ug-line); }
        .ug-tabs a { padding: 11px 12px; font-size: 13.5px; font-weight: 600; color: var(--ug-muted); text-decoration: none; border-bottom: 2px solid transparent; margin-bottom: -1px; }
        .ug-tabs a.on { color: var(--ug-p); border-bottom-color: var(--ug-p); }

        .ug-matrix { width: 100%; border-collapse: separate; border-spacing: 0; font-size: 13.5px; }
        .ug-matrix th { background: #EEEAFB; color: #1E1B4B; font-weight: 700; padding: 10px 12px; text-align: left; position: sticky; top: 0; z-index: 1; }
        .ug-matrix th.c { text-align: center; width: 15%; border-left: 1px solid #fff; }
        .ug-matrix th.c .hi { display: block; font-size: 16px; margin-bottom: 2px; }
        .ug-matrix th.c label { display: flex; flex-direction: column; align-items: center; gap: 4px; margin: 0; cursor: pointer; font-weight: 700; }
        .ug-matrix td { padding: 7px 12px; border-bottom: 1px solid #F1F2F6; }
        .ug-matrix td.c { text-align: center; border-left: 1px solid #F4F4F8; }
        .ug-matrix tr.l1 td { background: #F6F4FE; font-weight: 700; color: #1E1B4B; }
        .ug-matrix tr.l2 td.nm { padding-left: 40px; color: #374151; }
        .ug-matrix tr.l2 td.nm i { color: #9CA3AF; margin-right: 8px; }
        .ug-matrix tr.l1 .tg { border: 0; background: transparent; width: 22px; color: #6B7280; padding: 0; margin-right: 4px; transition: transform .15s; }
        .ug-matrix tr.l1.tutup .tg { transform: rotate(-90deg); }
        .ug-matrix tr.l1 .mi { width: 16px; height: 16px; vertical-align: -3px; margin-right: 8px; fill: currentColor; color: var(--ug-p); }
        .ug-matrix tr:hover td { background: #FBFAFF; }
        .ug-matrix input[type=checkbox] { width: 17px; height: 17px; accent-color: var(--ug-p); cursor: pointer; vertical-align: middle; }
        .ug-matrix tr.sorok { display: none; }
        .ug-scroll { max-height: 62vh; overflow: auto; }
        .ug-empty { text-align: center; color: var(--ug-muted); padding: 40px 16px; }
        .ug-empty i { font-size: 36px; display: block; margin-bottom: 8px; color: #C4B5FD; }
        .ug-note { font-size: 12px; color: var(--ug-muted); padding: 10px 16px 14px; }
        .ug-changed { display: none; font-size: 12.5px; color: #B45309; background: #FFF7E6; border: 1px solid #FCE3B5; border-radius: 8px; padding: 4px 10px; }

        .ug-members { padding: 14px 16px; }
        .ug-addrow { display: flex; flex-wrap: wrap; gap: 8px; align-items: center; margin-bottom: 12px; }
        .ug-addrow .select2-container { min-width: 280px; flex: 1; }
        .ug-mtable { width: 100%; font-size: 13.5px; border-collapse: collapse; }
        .ug-mtable th { background: #F6F4FE; color: #1E1B4B; font-weight: 700; padding: 9px 12px; text-align: left; }
        .ug-mtable td { padding: 8px 12px; border-bottom: 1px solid #F1F2F6; }
        .ug-mtable input[type=checkbox] { width: 16px; height: 16px; accent-color: var(--ug-p); }
        .ug-av { width: 30px; height: 30px; border-radius: 50%; background: var(--ug-p-soft); color: var(--ug-p); display: inline-flex; align-items: center; justify-content: center; font-weight: 700; font-size: 12px; margin-right: 10px; }

        .ug-printhead { display: none; }
        @media (max-width: 1199.98px) { .ug-stats { grid-template-columns: repeat(2, minmax(0, 1fr)); } }
        @media (max-width: 991.98px) { .ug-body { grid-template-columns: 1fr; } .ug-search input { width: 100%; } }
        @media print {
            @page { size: A4 portrait; margin: 12mm; }
            nav, .navbar, .sidebar, footer, #plChat, .pl-chat, .content-header, .no-print, .ug-groups, .ug-actions, .ug-tools, .ug-tabs, .ug-stats, .ug-note, .ug-changed { display: none !important; }
            .ug-body { display: block; }
            .ug-card { border: 0; box-shadow: none; }
            .ug-head { display: none; }
            .ug-printhead { display: block; margin-bottom: 8px; }
            .ug-printhead h2 { font-size: 16px; font-weight: 800; margin: 0 0 2px; }
            .ug-printhead div { font-size: 11.5px; color: #333; }
            .ug-scroll { max-height: none; overflow: visible; }
            .ug-matrix tr.sorok { display: table-row !important; }
            .ug-matrix th { position: static; background: #eee !important; }
            .ug-matrix td, .ug-matrix th { border: 1px solid #999 !important; padding: 4px 8px; font-size: 11px; }
            .ug-matrix .tg { display: none; }
            tr { page-break-inside: avoid; }
        }
    </style>

    <section class="content-header no-print">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6"><h1 class="m-0 text-dark"><div runat="server" id="idWindowTitle">Kumpulan Pengguna</div></h1></div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <%= GlobalClass.writeBreadcrumb(Request.QueryString("p_Id"), Request.QueryString("m_Id"), Session.Item("sessionSystemId")) %>
                    </ol>
                </div>
            </div>
        </div>
    </section>

    <section class="content ug-wrap">
        <div class="container-fluid">

            <%--# KEPALA #--%>
            <div class="ug-card ug-head">
                <div class="ug-title">
                    <div class="ic"><i class="bi bi-people"></i></div>
                    <div>
                        <h3>Kumpulan Pengguna &amp; Akses Sistem</h3>
                        <div class="sub">Tetapkan akses modul dan fungsi bagi setiap kumpulan pengguna.</div>
                    </div>
                </div>
                <div class="ug-actions">
                    <button type="button" class="ug-btn" data-bs-toggle="modal" data-bs-target="#ugPanduan"><i class="bi bi-question-circle"></i>Panduan</button>
                    <asp:LinkButton ID="btnExcel" runat="server" CssClass="ug-btn xls" CausesValidation="false" data-no-loader="1" ToolTip="Muat turun akses semua kumpulan (Excel)"><i class="bi bi-file-earmark-excel"></i>Excel</asp:LinkButton>
                    <button type="button" class="ug-btn prt" onclick="ugCetak()"><i class="bi bi-printer"></i>Cetak</button>
                    <button type="button" class="ug-btn primary" runat="server" id="btnBukaTambah" data-bs-toggle="modal" data-bs-target="#ugTambah"><i class="bi bi-plus-lg"></i>Tambah Kumpulan</button>
                </div>
            </div>

            <%--# RINGKASAN #--%>
            <div class="ug-stats">
                <div class="ug-stat s1"><div class="ic"><i class="bi bi-people"></i></div><div><div class="k">Jumlah Kumpulan</div><div class="v"><asp:Literal ID="litKumpulan" runat="server" Text="0" /></div></div></div>
                <div class="ug-stat s2"><div class="ic"><i class="bi bi-grid"></i></div><div><div class="k">Jumlah Modul</div><div class="v"><asp:Literal ID="litModul" runat="server" Text="0" /></div></div></div>
                <div class="ug-stat s3"><div class="ic"><i class="bi bi-check-circle"></i></div><div><div class="k">Fungsi Aktif</div><div class="v"><asp:Literal ID="litAktif" runat="server" Text="0" /></div></div></div>
                <div class="ug-stat s4"><div class="ic"><i class="bi bi-person-x"></i></div><div><div class="k">Fungsi Tidak Aktif</div><div class="v"><asp:Literal ID="litTidakAktif" runat="server" Text="0" /></div></div></div>
            </div>

            <div class="ug-body">

                <%--# SENARAI KUMPULAN #--%>
                <div class="ug-card ug-groups">
                    <h4>Kumpulan Pengguna</h4>
                    <asp:Repeater ID="rptKumpulan" runat="server">
                        <ItemTemplate>
                            <div class='ug-gitem <%# If(CInt(Eval("UGN_Id")) = KumpulanId, "on", "") %>'>
                                <asp:LinkButton runat="server" CssClass="nm" CommandName="Pilih" CommandArgument='<%# Eval("UGN_Id") %>' CausesValidation="false">
                                    <i class="bi bi-people"></i><span class="t"><%# HttpUtility.HtmlEncode(Eval("UGN_Name")) %></span><span class="cnt" title="Bilangan ahli"><%# Eval("Ahli") %></span>
                                </asp:LinkButton>
                                <div class="dropdown">
                                    <button type="button" class="ug-kebab" data-bs-toggle="dropdown" aria-expanded="false" title="Pilihan"><i class="bi bi-three-dots-vertical"></i></button>
                                    <ul class="dropdown-menu dropdown-menu-end">
                                        <li><asp:LinkButton runat="server" CssClass="dropdown-item" CommandName="Akses" CommandArgument='<%# Eval("UGN_Id") %>' CausesValidation="false"><i class="bi bi-shield-check me-2"></i>Tetapan Akses</asp:LinkButton></li>
                                        <li><asp:LinkButton runat="server" CssClass="dropdown-item" CommandName="Ahli" CommandArgument='<%# Eval("UGN_Id") %>' CausesValidation="false"><i class="bi bi-person-lines-fill me-2"></i>Ahli Kumpulan</asp:LinkButton></li>
                                    </ul>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <%--# PANEL KANAN #--%>
                <div class="ug-card">
                    <div class="ug-printhead">
                        <h2>Tetapan Akses Kumpulan: <asp:Literal ID="litCetakKumpulan" runat="server" /></h2>
                        <div>Sistem: <asp:Literal ID="litCetakSistem" runat="server" /> &middot; Dicetak: <%= DateTime.Now.ToString("dd/MM/yyyy hh:mm tt") %></div>
                    </div>

                    <div class="ug-panel-head">
                        <h4><i class="bi bi-people"></i>Tetapan Akses : <asp:Literal ID="litNamaKumpulan" runat="server" /></h4>
                        <div class="ug-tools">
                            <span class="ug-changed" id="ugChanged"><i class="bi bi-exclamation-circle me-1"></i>Ada perubahan belum disimpan</span>
                            <asp:DropDownList ID="ddlSistem" runat="server" CssClass="form-control" AutoPostBack="true" ToolTip="Sistem" />
                            <asp:PlaceHolder ID="phCarian" runat="server">
                                <div class="ug-search"><i class="bi bi-search"></i><input type="text" id="ugCari" placeholder="Cari modul atau fungsi..." autocomplete="off" oninput="ugTapis(this.value)" /></div>
                            </asp:PlaceHolder>
                            <asp:LinkButton ID="btnSimpan" runat="server" CssClass="ug-btn primary" CausesValidation="false" OnClientClick="ugSimpanOk=true;"><i class="bi bi-save"></i>Simpan</asp:LinkButton>
                        </div>
                    </div>

                    <div class="ug-tabs no-print">
                        <asp:LinkButton ID="tabAkses" runat="server" CausesValidation="false"><i class="bi bi-shield-check me-1"></i>Akses Modul</asp:LinkButton>
                        <asp:LinkButton ID="tabAhli" runat="server" CausesValidation="false"><i class="bi bi-person-lines-fill me-1"></i>Ahli Kumpulan (<asp:Literal ID="litBilAhli" runat="server" Text="0" />)</asp:LinkButton>
                    </div>

                    <%--# TAB: AKSES MODUL #--%>
                    <asp:PlaceHolder ID="phAkses" runat="server">
                        <div class="ug-scroll">
                            <asp:Repeater ID="rptModul" runat="server">
                                <HeaderTemplate>
                                    <table class="ug-matrix" id="ugMatrix">
                                        <thead>
                                            <tr>
                                                <th>Modul / Fungsi</th>
                                                <th class="c"><label><i class="bi bi-eye hi"></i>Lihat<input type="checkbox" class="no-print" data-semua="r" title="Tanda semua" /></label></th>
                                                <th class="c"><label><i class="bi bi-pencil-square hi"></i>Tambah / Kemaskini<input type="checkbox" class="no-print" data-semua="w" title="Tanda semua" /></label></th>
                                                <th class="c"><label><i class="bi bi-patch-check hi"></i>Kelulusan<input type="checkbox" class="no-print" data-semua="a" title="Tanda semua" /></label></th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr class='<%# If(CInt(Eval("UGM_Level")) = 1, "l1", "l2") %>' data-id='<%# Eval("UGM_Id") %>' data-induk='<%# Eval("Induk") %>' data-nama='<%# HttpUtility.HtmlAttributeEncode(Convert.ToString(Eval("UGM_Name")).ToLowerInvariant()) %>'>
                                        <td class="nm">
                                            <%# If(CInt(Eval("UGM_Level")) = 1, "<button type=""button"" class=""tg"" onclick=""ugLipat(this)"" title=""Buka / tutup""><i class=""bi bi-chevron-down""></i></button>" & IkonModul(Eval("UGM_Menu_SVG")), "<i class=""bi bi-file-earmark-text""></i>") %>
                                            <%# HttpUtility.HtmlEncode(Eval("UGM_Name")) %>
                                        </td>
                                        <td class="c"><input type="checkbox" name='r_<%# Eval("UGR_Id") %>' value="1" data-k="r" <%# If(CInt(Eval("UGR_Read")) = 1, "checked", "") %> /></td>
                                        <td class="c"><input type="checkbox" name='w_<%# Eval("UGR_Id") %>' value="1" data-k="w" <%# If(CInt(Eval("UGR_Write")) = 1, "checked", "") %> /></td>
                                        <td class="c"><input type="checkbox" name='a_<%# Eval("UGR_Id") %>' value="1" data-k="a" <%# If(CInt(Eval("UGR_Approval")) = 1, "checked", "") %> /></td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate>
                                        </tbody>
                                    </table>
                                </FooterTemplate>
                            </asp:Repeater>
                            <asp:PlaceHolder ID="phTiadaModul" runat="server" Visible="false">
                                <div class="ug-empty"><i class="bi bi-grid"></i>Tiada modul untuk sistem ini.</div>
                            </asp:PlaceHolder>
                        </div>
                        <div class="ug-note">
                            <b>Lihat</b> = boleh buka page &middot; <b>Tambah / Kemaskini</b> = boleh simpan, tambah, ubah dan padam rekod &middot;
                            <b>Kelulusan</b> = boleh membuat keputusan sokong / lulus. Tanda pada modul induk menanda semua fungsi di bawahnya.
                        </div>
                    </asp:PlaceHolder>

                    <%--# TAB: AHLI KUMPULAN #--%>
                    <asp:PlaceHolder ID="phAhli" runat="server" Visible="false">
                        <div class="ug-members">
                            <asp:Panel ID="pnlTambahAhli" runat="server" CssClass="ug-addrow">
                                <asp:ListBox ID="lstPengguna" runat="server" SelectionMode="Multiple" CssClass="form-control select2" data-placeholder="Pilih pengguna untuk ditambah..." />
                                <asp:LinkButton ID="btnTambahAhli" runat="server" CssClass="ug-btn primary" CausesValidation="false"><i class="bi bi-person-plus"></i>Tambah Ahli</asp:LinkButton>
                                <asp:LinkButton ID="btnBuangAhli" runat="server" CssClass="ug-btn" CausesValidation="false" OnClientClick="return confirm('Buang ahli yang ditanda daripada kumpulan ini?');"><i class="bi bi-person-dash"></i>Buang Ditanda</asp:LinkButton>
                            </asp:Panel>
                            <asp:Repeater ID="rptAhli" runat="server">
                                <HeaderTemplate>
                                    <table class="ug-mtable">
                                        <thead><tr><th style="width:36px;"><input type="checkbox" onclick="document.querySelectorAll('.ug-ahli-cb').forEach(c=>c.checked=this.checked)" title="Tanda semua" /></th><th>Nama</th><th>ID Pengguna</th><th>Status</th></tr></thead>
                                        <tbody>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td><input type="checkbox" class="ug-ahli-cb" name="ahli" value='<%# Eval("UGL_Id") %>' /></td>
                                        <td><span class="ug-av"><%# HttpUtility.HtmlEncode(Huruf(Eval("Users_Fullname"))) %></span><%# HttpUtility.HtmlEncode(Eval("Users_Fullname")) %></td>
                                        <td><%# HttpUtility.HtmlEncode(Eval("Users_Name")) %></td>
                                        <td><%# If(CBool(Eval("Aktif")), "<span class='text-success'>Aktif</span>", "<span class='text-muted'>Tidak aktif</span>") %></td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate></tbody></table></FooterTemplate>
                            </asp:Repeater>
                            <asp:PlaceHolder ID="phTiadaAhli" runat="server" Visible="false">
                                <div class="ug-empty"><i class="bi bi-person"></i>Tiada ahli dalam kumpulan ini.</div>
                            </asp:PlaceHolder>
                        </div>
                    </asp:PlaceHolder>

                    <asp:PlaceHolder ID="phTiadaKumpulan" runat="server" Visible="false">
                        <div class="ug-empty"><i class="bi bi-people"></i>Pilih kumpulan pengguna di sebelah kiri.</div>
                    </asp:PlaceHolder>
                </div>
            </div>
        </div>
    </section>

    <%--# MODAL: TAMBAH KUMPULAN #--%>
    <div class="modal fade" id="ugTambah" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="border-radius:14px;">
                <div class="modal-header"><h5 class="modal-title"><i class="bi bi-people me-2"></i>Tambah Kumpulan</h5><button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Tutup"></button></div>
                <div class="modal-body">
                    <label class="form-label" for="<%= txtNamaKumpulan.ClientID %>">Nama kumpulan</label>
                    <asp:TextBox ID="txtNamaKumpulan" runat="server" CssClass="form-control" MaxLength="100" placeholder="cth. Pegawai Penguatkuasa" />
                    <div class="form-text">Akses kumpulan baru bermula kosong; tetapkan selepas kumpulan ditambah.</div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="ug-btn" data-bs-dismiss="modal">Batal</button>
                    <asp:LinkButton ID="btnTambahKumpulan" runat="server" CssClass="ug-btn primary" CausesValidation="false"><i class="bi bi-plus-lg"></i>Tambah</asp:LinkButton>
                </div>
            </div>
        </div>
    </div>

    <%--# MODAL: PANDUAN #--%>
    <div class="modal fade" id="ugPanduan" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content" style="border-radius:14px;">
                <div class="modal-header"><h5 class="modal-title"><i class="bi bi-question-circle me-2"></i>Panduan</h5><button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Tutup"></button></div>
                <div class="modal-body" style="font-size:14px;">
                    <ol>
                        <li>Pilih <b>kumpulan pengguna</b> di sebelah kiri.</li>
                        <li>Pilih <b>sistem</b> (cth. Lesen), kemudian tanda akses bagi setiap modul / fungsi:
                            <ul>
                                <li><b>Lihat</b> - pengguna boleh membuka page dan melihat rekod.</li>
                                <li><b>Tambah / Kemaskini</b> - pengguna boleh menyimpan, menambah, mengubah dan memadam rekod.</li>
                                <li><b>Kelulusan</b> - pengguna boleh membuat keputusan sokong / lulus / tolak.</li>
                            </ul>
                        </li>
                        <li>Tanda pada <b>modul induk</b> menanda semua fungsi di bawahnya. Tanda di kepala lajur menanda keseluruhan lajur.</li>
                        <li>Tekan <b>Simpan</b>. Setiap perubahan direkod dalam Audit Trail.</li>
                        <li>Tab <b>Ahli Kumpulan</b> untuk menambah atau membuang pengguna daripada kumpulan.</li>
                        <li><b>Excel</b> memuat turun akses semua kumpulan (satu helaian bagi setiap kumpulan); <b>Cetak</b> mencetak kumpulan yang dipilih.</li>
                    </ol>
                </div>
            </div>
        </div>
    </div>

    <script>
        var ugSimpanOk = false, ugUbah = false;

        // Pastikan keadaan kotak induk / kepala lajur selari dengan fungsi di bawahnya
        function ugSegarInduk() {
            var t = document.getElementById('ugMatrix'); if (!t) return;
            t.querySelectorAll('tr.l1').forEach(function (p) {
                ['r', 'w', 'a'].forEach(function (k) {
                    var anak = t.querySelectorAll('tr[data-induk="' + p.dataset.id + '"] input[data-k="' + k + '"]');
                    if (!anak.length) return;
                    var on = 0; anak.forEach(function (c) { if (c.checked) on++; });
                    var cb = p.querySelector('input[data-k="' + k + '"]');
                    cb.indeterminate = on > 0 && on < anak.length;
                    if (on === anak.length) cb.checked = true; else if (on === 0) cb.checked = false;
                });
            });
            ['r', 'w', 'a'].forEach(function (k) {
                var semua = t.querySelectorAll('tbody input[data-k="' + k + '"]'), on = 0;
                semua.forEach(function (c) { if (c.checked) on++; });
                var h = t.querySelector('input[data-semua="' + k + '"]');
                if (h) { h.checked = semua.length > 0 && on === semua.length; h.indeterminate = on > 0 && on < semua.length; }
            });
        }

        function ugTandaUbah() { ugUbah = true; var e = document.getElementById('ugChanged'); if (e) e.style.display = 'inline-block'; }

        document.addEventListener('change', function (e) {
            var c = e.target; if (!c.matches || !c.matches('#ugMatrix input[type=checkbox]')) return;
            var t = document.getElementById('ugMatrix');
            if (c.dataset.semua) {
                t.querySelectorAll('tbody input[data-k="' + c.dataset.semua + '"]').forEach(function (x) { x.checked = c.checked; });
            } else {
                var tr = c.closest('tr');
                if (tr.classList.contains('l1')) {
                    t.querySelectorAll('tr[data-induk="' + tr.dataset.id + '"] input[data-k="' + c.dataset.k + '"]').forEach(function (x) { x.checked = c.checked; });
                }
            }
            ugSegarInduk(); ugTandaUbah();
        });

        function ugLipat(btn) {
            var tr = btn.closest('tr'); tr.classList.toggle('tutup');
            var tutup = tr.classList.contains('tutup');
            document.querySelectorAll('#ugMatrix tr[data-induk="' + tr.dataset.id + '"]').forEach(function (x) { x.classList.toggle('sorok', tutup); });
        }

        function ugTapis(q) {
            q = (q || '').trim().toLowerCase();
            var t = document.getElementById('ugMatrix'); if (!t) return;
            t.querySelectorAll('tr.l1').forEach(function (p) {
                var anak = t.querySelectorAll('tr[data-induk="' + p.dataset.id + '"]'), ada = false;
                var padanInduk = !q || p.dataset.nama.indexOf(q) >= 0;
                anak.forEach(function (x) {
                    var padan = !q || padanInduk || x.dataset.nama.indexOf(q) >= 0;
                    x.classList.toggle('sorok', !padan || (!q && p.classList.contains('tutup')));
                    if (padan) ada = true;
                });
                p.classList.toggle('sorok', !(padanInduk || ada));
            });
        }

        function ugCetak() {
            document.querySelectorAll('#ugMatrix tr.l1.tutup').forEach(function (tr) { tr.querySelector('.tg').click(); });
            window.print();
        }

        window.addEventListener('beforeunload', function (e) { if (ugUbah && !ugSimpanOk) { e.preventDefault(); e.returnValue = ''; } });
        document.addEventListener('DOMContentLoaded', ugSegarInduk);
        if (window.Sys && Sys.Application) Sys.Application.add_load(ugSegarInduk);
    </script>

</asp:Content>
