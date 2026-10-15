<%@ Page Title="" Language="VB" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="InitialDatabase.aspx.vb" Inherits="humanResources_InitialDatabase" %>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="Server">
<style>
    .idb-card { background: #fff; border: 1px solid #E3E7F1; border-radius: 12px; box-shadow: 0 2px 8px rgba(46,49,146,.06); margin-bottom: 16px; overflow: hidden; }
    .idb-head { display: flex; flex-wrap: wrap; gap: 12px; align-items: center; justify-content: space-between; padding: 18px 20px; border-bottom: 1px solid #E4DFFB; background: linear-gradient(135deg, #F4F3FF 0%, #EEF4FF 100%); border-left: 4px solid #2E3192; }
    .idb-title { font-size: 17px; font-weight: 700; color: #23267a; margin: 0; display: flex; align-items: center; gap: 10px; }
    .idb-sub { color: #5B6478; font-size: 13px; margin-top: 2px; }
    .idb-head-actions { display: flex; gap: 8px; flex-wrap: wrap; }
    .idb-body { padding: 16px 20px; }

    .idb-pill { font-size: 11.5px; font-weight: 700; padding: 3px 10px; border-radius: 999px; display: inline-flex; align-items: center; gap: 5px; border: 1px solid transparent; }
    .idb-pill.green { background: #e6f4ea; color: #0f5132; border-color: #badbcc; }
    .idb-pill.amber { background: #fef3e2; color: #8a4b00; border-color: #fbdcae; }
    .idb-pill.grey { background: #f1f3f5; color: #495057; border-color: #e3e7ec; }

    .idb-db { display: flex; flex-wrap: wrap; gap: 22px; align-items: center; border: 1px solid #E6EBF5; border-radius: 10px; padding: 12px 16px; background: #F8FAFE; }
    .idb-db .ic { font-size: 26px; color: #2E3192; }
    .idb-db .lbl { font-size: 11px; color: #6c757d; text-transform: uppercase; letter-spacing: .04em; font-weight: 600; }
    .idb-db .val { font-size: 14px; font-weight: 700; color: #212529; }
    .idb-db .meta { margin-left: auto; font-size: 12px; color: #6c757d; text-align: right; }
    .idb-db .acts { display: flex; gap: 8px; }

    .idb-kpi { position: relative; overflow: hidden; display: flex; gap: 12px; align-items: flex-start; height: 100%; padding: 14px 16px; border: 1px solid #e9ecef; border-radius: 10px; background: linear-gradient(135deg, var(--t) 0%, #fff 62%); }
    .idb-kpi::before { content: ""; position: absolute; left: 0; top: 0; bottom: 0; width: 3px; background: var(--c); }
    .idb-kpi .ic { flex: 0 0 auto; width: 40px; height: 40px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 18px; color: #fff; background: var(--c); }
    .idb-kpi .lbl { font-size: 11.5px; font-weight: 700; color: #6c757d; text-transform: uppercase; letter-spacing: .04em; }
    .idb-kpi .val { font-size: 24px; font-weight: 700; line-height: 1.2; color: var(--c); }
    .idb-kpi .sub { font-size: 12px; color: #6c757d; }
    .k-blue { --c: #2E3192; --t: #EEF0FF; } .k-green { --c: #1e8e3e; --t: #e6f4ea; } .k-amber { --c: #d97706; --t: #fef3e2; } .k-grey { --c: #5c6670; --t: #f1f3f5; }

    .idb-status { display: flex; gap: 14px; align-items: center; padding: 14px 16px; border-radius: 10px; border: 1px solid; }
    .idb-status .ic { flex: 0 0 auto; width: 44px; height: 44px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 20px; color: #fff; }
    .idb-status .ttl { font-weight: 700; font-size: 15px; }
    .idb-status .txt { font-size: 13px; color: #495057; }
    .idb-status.ok { background: linear-gradient(135deg, #e6f4ea 0%, #fff 70%); border-color: #badbcc; }
    .idb-status.ok .ic { background: #1e8e3e; } .idb-status.ok .ttl { color: #0f5132; }
    .idb-status.pending { background: linear-gradient(135deg, #fef3e2 0%, #fff 70%); border-color: #fbdcae; }
    .idb-status.pending .ic { background: #d97706; } .idb-status.pending .ttl { color: #8a4b00; }

    .idb-box { border: 1px solid #E6EBF5; border-radius: 10px; padding: 10px 12px; height: 100%; }
    .idb-box-title { font-size: 13px; font-weight: 700; color: #23267a; margin-bottom: 6px; }
    .idb-kind { width: 100%; font-size: 13px; }
    .idb-kind th, .idb-kind td { padding: 5px 8px; white-space: nowrap; }
    .idb-kind thead th { color: #6c757d; font-weight: 600; border-bottom: 1px solid #dee2e6; }
    .idb-kind td.num { text-align: right; }
    .idb-kind td.zero { color: #c4c9ce; }

    .idb-chip { border: 1px solid #dee2e6; border-radius: 999px; padding: 4px 12px; font-size: 12.5px; background: #fff; cursor: pointer; color: #495057; }
    .idb-chip.active { border-color: #2E3192; background: #EEF0FF; color: #2E3192; font-weight: 700; }
    .idb-chip .cnt { opacity: .7; margin-left: 3px; }
    .idb-tools { display: flex; flex-wrap: wrap; gap: 8px; align-items: center; margin-bottom: 8px; }
    .idb-tools .idb-search { margin-left: auto; min-width: 220px; }
    .idb-tools select, .idb-tools input { height: 34px; border: 1px solid #d0d5dd; border-radius: 6px; padding: 4px 10px; font-size: 13px; }

    .idb-scroll { max-height: 55vh; overflow: auto; border: 1px solid #E6EBF5; border-radius: 10px; }
    .idb-steps { width: 100%; font-size: 13px; border-collapse: separate; border-spacing: 0; }
    .idb-steps th, .idb-steps td { padding: 7px 10px; white-space: nowrap; border-bottom: 1px solid #f1f3f5; }
    .idb-steps thead th { position: sticky; top: 0; background: #EEF1FA; color: #3F4A6B; z-index: 2; font-weight: 600; font-size: 12px; text-transform: uppercase; letter-spacing: .03em; }
    .idb-steps tbody tr:hover td { background: #F6F7FF; }
    .idb-steps tr.running td { background: #fff8e1; }
    .idb-steps tr.err td { background: #fff5f5; }
    .idb-steps td.obj { font-family: Consolas, "Courier New", monospace; font-size: 12.5px; }
    .idb-steps td.det { color: #6c757d; max-width: 360px; overflow: hidden; text-overflow: ellipsis; }
    .idb-steps td.res { max-width: 320px; overflow: hidden; text-overflow: ellipsis; }
    .idb-badge { font-size: 11.5px; font-weight: 600; padding: 2px 8px; border-radius: 6px; border: 1px solid transparent; display: inline-block; }
    .idb-badge.missing { background: #EEF0FF; color: #2E3192; border-color: #D9D5FA; }
    .idb-badge.different { background: #fef3e2; color: #8a4b00; border-color: #fbdcae; }
    .idb-badge.ok { background: #e6f4ea; color: #0f5132; border-color: #badbcc; }
    .idb-badge.info { background: #f1f3f5; color: #495057; border-color: #e3e7ec; }
    .idb-badge.fail { background: #fdecea; color: #b42318; border-color: #f5c2c0; }
    .idb-kindtag { font-size: 11px; font-weight: 600; padding: 1px 8px; border-radius: 999px; background: #f1f3f5; color: #495057; }
    .idb-warnmini { font-size: 11px; font-weight: 600; color: #b42318; }
    .idb-foot { background: #F8FAFE; font-size: 12px; color: #6c757d; padding: 8px 12px; border-top: 1px solid #E6EBF5; }

    .idb-progress { border: 1px solid #c6dcf7; border-radius: 10px; background: #f5f9ff; padding: 12px 16px; }
    .idb-progress.done { border-color: #badbcc; background: #f3faf5; }
    .idb-progress.failed { border-color: #f5c2c0; background: #fff8f7; }
    .idb-progress .bar { height: 10px; background: #e9ecef; border-radius: 999px; overflow: hidden; }
    .idb-progress .bar > div { height: 100%; width: 0; background: #2E3192; transition: width .2s ease; }
    .idb-progress.done .bar > div { background: #1e8e3e; } .idb-progress.failed .bar > div { background: #d92d20; }
    .idb-progress .cur { font-family: Consolas, monospace; font-size: 12px; color: #6c757d; }

    .idb-preview { border: 1px solid #D9D5FA; border-radius: 12px; background: #fff; margin-bottom: 16px; overflow: hidden; }
    .idb-preview .ph { padding: 14px 18px; background: #F4F3FF; border-bottom: 1px solid #E4DFFB; font-weight: 700; color: #23267a; }
    .idb-preview .pb { padding: 14px 18px; }
    .idb-preview .pf { padding: 12px 18px; background: #F8FAFE; border-top: 1px solid #E6EBF5; display: flex; gap: 8px; flex-wrap: wrap; align-items: center; }
    .idb-chg { font-size: 11.5px; font-weight: 700; padding: 2px 8px; border-radius: 6px; }
    .idb-chg.Baru { background: #EEF0FF; color: #2E3192; } .idb-chg.Berubah { background: #fef3e2; color: #8a4b00; } .idb-chg.Dibuang { background: #fdecea; color: #b42318; }
    .idb-warnlist { margin: 0; padding-left: 18px; font-size: 12.5px; }
    .idb-warnlist li { margin-bottom: 2px; }
</style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">
    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0 text-dark">Initial Database</h1>
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
            <asp:HiddenField ID="hdnDbName" runat="server" />

            <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="alert alert-success py-2 small d-flex align-items-center gap-2">
                <i class="bi bi-check-circle-fill"></i><span><asp:Literal ID="litSuccess" runat="server" /></span>
            </asp:Panel>

            <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert alert-danger py-2 small">
                <i class="bi bi-exclamation-octagon me-1"></i><asp:Literal ID="litError" runat="server" />
            </asp:Panel>

            <asp:Panel ID="pnlSetup" runat="server" Visible="false" CssClass="alert alert-info py-2 small">
                <i class="bi bi-info-circle me-1"></i>
                Kali pertama digunakan pada DB ini. Tekan <b>Analisis struktur baru</b> - table <code>TBL_InitDbApi</code> dan
                <code>tbl_sys_InitDbLog</code> akan dicipta secara automatik sebelum skrip dijana.
            </asp:Panel>

            <%-- ================= PREVIEW: Analisis struktur baru ================= --%>
            <asp:Panel ID="pnlPreview" runat="server" Visible="false" CssClass="idb-preview">
                <div class="ph"><i class="bi bi-file-earmark-diff me-2"></i>Analisis struktur baru - semak sebelum simpan ke TBL_InitDbApi</div>
                <div class="pb">
                    <div class="small text-muted mb-2">
                        Dijana daripada <b><asp:Literal ID="litPrevSource" runat="server" /></b> dalam <asp:Literal ID="litPrevTime" runat="server" />.
                        Skrip baru <b><asp:Literal ID="litPrevSteps" runat="server" /></b> langkah, skrip semasa dalam TBL_InitDbApi <b><asp:Literal ID="litPrevSaved" runat="server" /></b> langkah.
                    </div>
                    <div class="d-flex flex-wrap gap-2 mb-2">
                        <span class="idb-chg Baru"><asp:Literal ID="litPrevAdd" runat="server" /> baru</span>
                        <span class="idb-chg Berubah"><asp:Literal ID="litPrevChg" runat="server" /> berubah</span>
                        <span class="idb-chg Dibuang"><asp:Literal ID="litPrevRem" runat="server" /> dibuang</span>
                    </div>

                    <asp:Panel ID="pnlPrevSame" runat="server" CssClass="idb-status ok mb-2">
                        <div class="ic"><i class="bi bi-check2-all"></i></div>
                        <div><div class="ttl">Tiada perubahan</div><div class="txt">Skrip dalam TBL_InitDbApi sudah sama dengan struktur DB working. Tiada apa perlu disimpan.</div></div>
                    </asp:Panel>

                    <asp:Repeater ID="rptChanges" runat="server">
                        <HeaderTemplate>
                            <div class="idb-scroll mb-2" style="max-height:30vh"><table class="idb-steps"><thead><tr><th>Perubahan</th><th>Jenis</th><th>Objek</th></tr></thead><tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr><td><span class='idb-chg <%# Eval("Change") %>'><%# Eval("Change") %></span></td><td><span class="idb-kindtag"><%# Eval("Kind") %></span></td><td class="obj"><%# HttpUtility.HtmlEncode(Eval("Name")) %></td></tr>
                        </ItemTemplate>
                        <FooterTemplate></tbody></table></div></FooterTemplate>
                    </asp:Repeater>

                    <asp:Panel ID="pnlPrevWarn" runat="server" CssClass="alert alert-warning py-2 small mb-2">
                        <b><i class="bi bi-exclamation-triangle me-1"></i>Amaran (tidak di-script, perlu disemak sendiri):</b>
                        <ul class="idb-warnlist mt-1">
                            <asp:Repeater ID="rptPrevWarn" runat="server"><ItemTemplate><li><%# HttpUtility.HtmlEncode(Container.DataItem) %></li></ItemTemplate></asp:Repeater>
                        </ul>
                    </asp:Panel>

                    <asp:Panel ID="pnlPrevRemoved" runat="server" CssClass="alert alert-danger py-2 small mb-0">
                        Ada langkah dalam skrip semasa yang <b>tidak lagi dijana</b>. Ini biasa jika baseline sudah dikemas kini (contohnya skrip pernah dijalankan pada DB baseline).
                        <div class="mt-1"><asp:CheckBox ID="chkConfirmRemoved" runat="server" Text=" Saya faham langkah tersebut akan dibuang daripada TBL_InitDbApi" /></div>
                    </asp:Panel>
                </div>
                <div class="pf">
                    <asp:LinkButton ID="btnSaveScript" runat="server" CssClass="btn btn-primary btn-sm" OnClientClick="return confirm('Simpan skrip ini ke TBL_InitDbApi? Skrip semasa akan diganti.');">
                        <i class="bi bi-save me-1"></i>Simpan ke TBL_InitDbApi
                    </asp:LinkButton>
                    <asp:LinkButton ID="btnCancelPreview" runat="server" CssClass="btn btn-default btn-sm">Batal</asp:LinkButton>
                    <span class="small text-muted ms-auto">Simpan akan menggantikan SQL Analysis &amp; Run dalam TBL_InitDbApi.</span>
                </div>
            </asp:Panel>

            <%-- ================= KAD UTAMA ================= --%>
            <div class="idb-card">
                <div class="idb-head">
                    <div>
                        <h3 class="idb-title">
                            Initial Database
                            <% If StepCount > 0 AndAlso (CntMissing + CntDifferent) = 0 Then %>
                                <span class="idb-pill green"><i class="bi bi-check-circle-fill"></i>Terkini</span>
                            <% ElseIf StepCount > 0 Then %>
                                <span class="idb-pill amber"><i class="bi bi-exclamation-circle-fill"></i><%= CntMissing + CntDifferent %> belum dijalankan</span>
                            <% Else %>
                                <span class="idb-pill grey">Tiada skrip</span>
                            <% End If %>
                        </h3>
                        <div class="idb-sub">Sediakan DB sasaran (dipulihkan daripada sistem lama) dengan table, kolum, index, FK, function, view, procedure dan trigger yang diperlukan sistem baru.</div>
                    </div>
                    <div class="idb-head-actions">
                        <asp:LinkButton ID="btnGenerate" runat="server" CssClass="btn btn-default btn-sm" ToolTip="Banding DB working dengan baseline dan jana skrip baru"
                            OnClientClick="idbBusy(this, 'Menganalisis struktur...');">
                            <i class="bi bi-diagram-3 me-1"></i>Analisis struktur baru
                        </asp:LinkButton>
                        <asp:LinkButton ID="btnAnalyse" runat="server" CssClass="btn btn-default btn-sm" ToolTip="Semak semula status DB sasaran"
                            OnClientClick="idbBusy(this, 'Menganalisis...');">
                            <i class="bi bi-arrow-clockwise me-1"></i>Analisis semula
                        </asp:LinkButton>
                    </div>
                </div>

                <div class="idb-body">
                    <%-- DB sasaran --%>
                    <div class="idb-db mb-3">
                        <div class="ic"><i class="bi bi-database"></i></div>
                        <div><div class="lbl">DB sasaran</div><div class="val"><asp:Literal ID="litDbName" runat="server" /></div></div>
                        <div><div class="lbl">DB working</div><div class="val"><%= HttpUtility.HtmlEncode(WorkingDb) %></div></div>
                        <div><div class="lbl">Server</div><div class="val"><asp:Literal ID="litServer" runat="server" /></div></div>
                        <div><div class="lbl">Versi</div><div class="val"><asp:Literal ID="litVersion" runat="server" /></div></div>
                        <div><div class="lbl">Compatibility</div><div class="val"><asp:Literal ID="litCompat" runat="server" /></div></div>
                        <div><div class="lbl">Collation</div><div class="val"><asp:Literal ID="litCollation" runat="server" /></div></div>
                        <div><div class="lbl">Table</div><div class="val"><asp:Literal ID="litTables" runat="server" /></div></div>
                        <div class="meta">
                            Dianalisis <asp:Literal ID="litAnalysedAt" runat="server" />
                            <% If ScriptNote <> "" Then %><div title="<%= HttpUtility.HtmlAttributeEncode(ScriptNote) %>"><i class="bi bi-file-earmark-code me-1"></i>Skrip <%= HttpUtility.HtmlEncode(If(ScriptNote.StartsWith("Dijana ") AndAlso ScriptNote.Length >= 23, ScriptNote.Substring(7, 16), ScriptNote)) %></div><% End If %>
                        </div>
                        <div class="acts" runat="server" id="divRunBtn">
                            <% If StepCount > 0 AndAlso (CntMissing + CntDifferent) > 0 Then %>
                                <button type="button" class="btn btn-primary btn-sm" onclick="idbOpenConfirm()"><i class="bi bi-play-fill me-1"></i>Run script</button>
                            <% ElseIf StepCount > 0 Then %>
                                <button type="button" class="btn btn-outline-success btn-sm" onclick="Swal.fire('DB sudah terkini', 'Semua langkah dalam skrip sudah dikenakan pada DB sasaran. Tiada apa perlu dijalankan.', 'info')"><i class="bi bi-check2-circle me-1"></i>Terkini</button>
                            <% End If %>
                        </div>
                    </div>

                    <asp:Panel ID="pnlNoScript" runat="server" Visible="false" CssClass="idb-status pending mb-3">
                        <div class="ic"><i class="bi bi-file-earmark-plus"></i></div>
                        <div><div class="ttl">Tiada skrip dalam TBL_InitDbApi</div><div class="txt">Tekan <b>Analisis struktur baru</b> untuk menjana skrip daripada DB working, kemudian simpan ke TBL_InitDbApi.</div></div>
                    </asp:Panel>

                    <asp:Panel ID="pnlWarning" runat="server" Visible="false" CssClass="alert alert-warning py-2 small mb-3">
                        <b><i class="bi bi-exclamation-triangle me-1"></i>Amaran skrip (tidak di-script, perlu disemak sendiri):</b>
                        <ul class="idb-warnlist mt-1">
                            <asp:Repeater ID="rptWarning" runat="server"><ItemTemplate><li><%# HttpUtility.HtmlEncode(Container.DataItem) %></li></ItemTemplate></asp:Repeater>
                        </ul>
                    </asp:Panel>

                    <% If StepCount > 0 Then %>
                    <%-- KPI --%>
                    <div class="row g-2 mb-3">
                        <div class="col-6 col-lg-3"><div class="idb-kpi k-grey"><div class="ic"><i class="bi bi-list-check"></i></div><div><div class="lbl">Langkah skrip</div><div class="val"><%= StepCount %></div><div class="sub">jumlah langkah dalam TBL_InitDbApi</div></div></div></div>
                        <div class="col-6 col-lg-3"><div class="idb-kpi k-blue"><div class="ic"><i class="bi bi-plus-lg"></i></div><div><div class="lbl">Akan dicipta</div><div class="val"><%= CntMissing %></div><div class="sub">object tiada dalam DB sasaran</div></div></div></div>
                        <div class="col-6 col-lg-3"><div class="idb-kpi <%= If(CntDifferent > 0, "k-amber", "k-grey") %>"><div class="ic"><i class="bi bi-arrow-repeat"></i></div><div><div class="lbl">Akan diganti</div><div class="val"><%= CntDifferent %></div><div class="sub">object / data berbeza dengan working</div></div></div></div>
                        <div class="col-6 col-lg-3"><div class="idb-kpi k-green"><div class="ic"><i class="bi bi-check2-all"></i></div><div><div class="lbl">Terkini</div><div class="val"><%= CntOk %></div><div class="sub"><%= Pct(CntOk, StepCount) %>% langkah akan di-skip</div></div></div></div>
                    </div>

                    <%-- Status --%>
                    <div class="mb-3" id="idbStatusBox">
                        <% If (CntMissing + CntDifferent) = 0 Then %>
                            <div class="idb-status ok"><div class="ic"><i class="bi bi-shield-check"></i></div><div><div class="ttl">DB sasaran sudah terkini</div><div class="txt"><b><%= HttpUtility.HtmlEncode(TargetDb) %></b> sudah ada semua <%= StepCount %> object dalam skrip. Tiada apa perlu dijalankan.</div></div></div>
                        <% Else %>
                            <div class="idb-status pending"><div class="ic"><i class="bi bi-database-exclamation"></i></div><div><div class="ttl"><%= CntMissing + CntDifferent %> langkah perlu dijalankan</div><div class="txt"><b><%= HttpUtility.HtmlEncode(TargetDb) %></b> belum ada <%= CntMissing %> object<%= If(CntDifferent > 0, " dan ada " & CntDifferent & " function / view / proc / trigger yang lapuk", "") %>. Semak ringkasan di bawah, kemudian tekan <b>Run script</b>.</div></div></div>
                        <% End If %>
                    </div>
                    <% End If %>

                    <%-- Progress run (diisi oleh JS) --%>
                    <div id="idbProgress" class="idb-progress mb-3" style="display:none">
                        <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-2">
                            <div class="fw-semibold" id="idbProgTitle"></div>
                            <div class="small text-muted" id="idbProgStats"></div>
                        </div>
                        <div class="bar"><div id="idbProgBar"></div></div>
                        <div class="d-flex justify-content-between align-items-center mt-2">
                            <div class="cur" id="idbProgCur"></div>
                            <div class="d-flex gap-2">
                                <button type="button" class="btn btn-outline-danger btn-sm" id="idbStopBtn" onclick="idbStop()"><i class="bi bi-stop-fill me-1"></i>Henti</button>
                                <button type="button" class="btn btn-primary btn-sm" id="idbReAnalyseBtn" style="display:none" onclick="document.getElementById('<%= btnAnalyse.ClientID %>').click()"><i class="bi bi-arrow-clockwise me-1"></i>Analisis semula</button>
                            </div>
                        </div>
                    </div>

                    <% If StepCount > 0 Then %>
                    <div class="row g-2">
                        <%-- Ringkasan ikut jenis --%>
                        <div class="col-12 col-xl-4">
                            <div class="idb-box">
                                <div class="idb-box-title">Ringkasan ikut jenis object</div>
                                <table class="idb-kind">
                                    <thead><tr><th>Jenis</th><th class="text-end">Cipta</th><th class="text-end">Ganti</th><th class="text-end">Terkini</th><th class="text-end">Jumlah</th></tr></thead>
                                    <tbody>
                                        <asp:Repeater ID="rptSummary" runat="server">
                                            <ItemTemplate>
                                                <tr>
                                                    <td><%# Eval("Label") %></td>
                                                    <td class='num <%# If(CInt(Eval("Create")) = 0, "zero", "fw-bold text-primary") %>'><%# Eval("Create") %></td>
                                                    <td class='num <%# If(CInt(Eval("Replace")) = 0, "zero", "fw-bold text-warning") %>'><%# Eval("Replace") %></td>
                                                    <td class='num <%# If(CInt(Eval("Ok")) = 0, "zero", "text-success") %>'><%# Eval("Ok") %></td>
                                                    <td class="num fw-bold"><%# Eval("Total") %></td>
                                                </tr>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <%-- Senarai langkah --%>
                        <div class="col-12 col-xl-8">
                            <div class="idb-box">
                                <div class="idb-tools">
                                    <button type="button" class="idb-chip active" data-f="ALL">Semua<span class="cnt"></span></button>
                                    <button type="button" class="idb-chip" data-f="PENDING">Perlu dijalankan<span class="cnt"></span></button>
                                    <button type="button" class="idb-chip" data-f="MISSING">Cipta<span class="cnt"></span></button>
                                    <button type="button" class="idb-chip" data-f="DIFFERENT">Ganti<span class="cnt"></span></button>
                                    <button type="button" class="idb-chip" data-f="OK">Terkini<span class="cnt"></span></button>
                                    <button type="button" class="idb-chip" data-f="FAILED" style="display:none">Gagal<span class="cnt"></span></button>
                                    <asp:DropDownList ID="ddlKind" runat="server" CssClass="idb-kind-filter" />
                                    <input type="text" class="idb-search" id="idbSearch" placeholder="Cari kod / object" />
                                </div>
                                <div class="idb-scroll">
                                    <table class="idb-steps" id="idbSteps">
                                        <thead><tr><th>Kod</th><th>Jenis</th><th>Object</th><th>Keterangan</th><th>Status</th><th>Hasil run</th></tr></thead>
                                        <tbody>
                                            <asp:Repeater ID="rptSteps" runat="server">
                                                <ItemTemplate>
                                                    <tr class="idb-row" data-code='<%# Eval("Code") %>' data-kind='<%# Eval("Kind") %>' data-state='<%# Eval("State") %>'
                                                        data-name='<%# HttpUtility.HtmlAttributeEncode(Eval("Name").ToString()) %>'>
                                                        <td class="fw-bold"><%# Eval("Code") %></td>
                                                        <td><span class="idb-kindtag"><%# KindLabel(Eval("Kind")) %></span></td>
                                                        <td class="obj"><%# HttpUtility.HtmlEncode(Eval("Name")) %></td>
                                                        <td class="det" title='<%# HttpUtility.HtmlAttributeEncode(Eval("Descr").ToString()) %>'><%# HttpUtility.HtmlEncode(Eval("Descr")) %><%# ColsNote(Eval("ColsExpected"), Eval("ColsActual"), Eval("State")) %></td>
                                                        <td><span class='idb-badge <%# StateCss(Eval("State")) %>'><%# StateLabel(Eval("State")) %></span></td>
                                                        <td class="res"></td>
                                                    </tr>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="idb-foot mt-2">Object yang sudah ada dan sama akan di-skip. Function / view / proc / trigger yang berbeza akan di-drop &amp; create semula. Data page &amp; kebenaran: rekod tiada ditambah, rekod berbeza dikemas kini. Table, kolum dan rekod tidak pernah di-drop / dipadam.</div>
                            </div>
                        </div>
                    </div>
                    <% End If %>
                </div>
            </div>

            <%-- ================= MODAL PENGESAHAN RUN ================= --%>
            <div class="modal fade" id="idbConfirm" tabindex="-1">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title"><i class="bi bi-play-circle me-2"></i>Run script</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body" style="padding:16px 20px !important">
                            <p class="small mb-2">Skrip akan dijalankan pada DB sasaran <b id="idbCfDb"></b>: <b id="idbCfCount"></b> langkah
                                (<span id="idbCfCreate"></span> cipta, <span id="idbCfReplace"></span> ganti). Setiap langkah dijalankan dalam transaksi sendiri dan direkod dalam <code>tbl_sys_InitDbLog</code>.</p>
                            <div class="alert alert-warning py-2 small" id="idbCfReplaceBox">
                                <label class="d-flex gap-2 align-items-start mb-0"><input type="checkbox" id="idbCfReplaceChk" /> <span>Saya faham <b id="idbCfReplace2"></b> langkah akan mengubah object sedia ada: function / view / proc / trigger di-drop &amp; create semula, dan rekod data (page / kebenaran) yang berbeza dikemas kini.</span></label>
                            </div>
                            <label class="d-flex gap-2 align-items-center small mb-2"><input type="checkbox" id="idbCfStop" checked /> Henti bila ada ralat</label>
                            <label class="small mb-1">Taip nama DB sasaran untuk sahkan:</label>
                            <input type="text" class="form-control" id="idbCfText" autocomplete="off" />
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default btn-sm" data-bs-dismiss="modal">Batal</button>
                            <button type="button" class="btn btn-primary btn-sm" id="idbCfGo" disabled onclick="idbRun()"><i class="bi bi-play-fill me-1"></i>Jalankan</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

<script>
    var idbRunUrl = '<%= ResolveUrl("~/globalmaster/humanResources/InitialDatabase.aspx") %>/RunStep';
    var idbFilter = 'ALL', idbStopReq = false, idbRunning = false, idbFailed = {};

    function idbBusy(btn, text) {
        setTimeout(function () { btn.classList.add('disabled'); btn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span>' + text; }, 0);
        return true;
    }

    function idbRows() { return Array.prototype.slice.call(document.querySelectorAll('#idbSteps tr.idb-row')); }

    function idbMatch(tr, f) {
        var s = tr.getAttribute('data-state');
        switch (f) {
            case 'PENDING': return s === 'MISSING' || s === 'DIFFERENT';
            case 'MISSING': return s === 'MISSING';
            case 'DIFFERENT': return s === 'DIFFERENT';
            case 'OK': return s === 'SAME' || s === 'EXISTS';
            case 'FAILED': return !!idbFailed[tr.getAttribute('data-code')];
            default: return true;
        }
    }

    function idbApplyFilter() {
        var kindSel = document.querySelector('.idb-kind-filter');
        var kind = kindSel ? kindSel.value : '';
        var q = (document.getElementById('idbSearch') || { value: '' }).value.trim().toLowerCase();
        idbRows().forEach(function (tr) {
            var ok = idbMatch(tr, idbFilter) && (!kind || tr.getAttribute('data-kind') === kind) &&
                     (!q || (tr.getAttribute('data-code') + ' ' + tr.getAttribute('data-name') + ' ' + tr.textContent).toLowerCase().indexOf(q) >= 0);
            tr.style.display = ok ? '' : 'none';
        });
        document.querySelectorAll('.idb-chip').forEach(function (c) {
            var f = c.getAttribute('data-f');
            var n = idbRows().filter(function (tr) { return (!kind || tr.getAttribute('data-kind') === kind) && idbMatch(tr, f); }).length;
            c.querySelector('.cnt').textContent = '(' + n + ')';
            c.classList.toggle('active', f === idbFilter);
        });
    }

    function idbInit() {
        document.querySelectorAll('.idb-chip').forEach(function (c) {
            c.onclick = function () { idbFilter = c.getAttribute('data-f'); idbApplyFilter(); };
        });
        var k = document.querySelector('.idb-kind-filter'); if (k) k.onchange = idbApplyFilter;
        var s = document.getElementById('idbSearch'); if (s) s.oninput = idbApplyFilter;
        var t = document.getElementById('idbCfText'); if (t) t.oninput = idbValidate;
        var r = document.getElementById('idbCfReplaceChk'); if (r) r.onchange = idbValidate;
        idbApplyFilter();
    }

    function idbPlan() { return idbRows().filter(function (tr) { var s = tr.getAttribute('data-state'); return s === 'MISSING' || s === 'DIFFERENT'; }); }

    function idbOpenConfirm() {
        var plan = idbPlan();
        if (plan.length === 0) { Swal.fire('DB sudah terkini', 'Tiada langkah perlu dijalankan.', 'info'); return; }
        var rep = plan.filter(function (tr) { return tr.getAttribute('data-state') === 'DIFFERENT'; }).length;
        document.getElementById('idbCfDb').textContent = document.getElementById('<%= hdnDbName.ClientID %>').value;
        document.getElementById('idbCfCount').textContent = plan.length;
        document.getElementById('idbCfCreate').textContent = plan.length - rep;
        document.getElementById('idbCfReplace').textContent = rep;
        document.getElementById('idbCfReplace2').textContent = rep;
        document.getElementById('idbCfReplaceBox').style.display = rep > 0 ? '' : 'none';
        document.getElementById('idbCfReplaceChk').checked = false;
        document.getElementById('idbCfText').value = '';
        idbValidate();
        bootstrap.Modal.getOrCreateInstance(document.getElementById('idbConfirm')).show();
    }

    function idbValidate() {
        var db = document.getElementById('<%= hdnDbName.ClientID %>').value;
        var rep = document.getElementById('idbCfReplaceBox').style.display !== 'none';
        var ok = document.getElementById('idbCfText').value.trim() === db && (!rep || document.getElementById('idbCfReplaceChk').checked);
        document.getElementById('idbCfGo').disabled = !ok;
    }

    function idbStop() { idbStopReq = true; var b = document.getElementById('idbStopBtn'); b.disabled = true; b.innerHTML = 'Menghenti...'; }

    function idbFmt(ms) { var s = ms / 1000; return s >= 60 ? Math.floor(s / 60) + 'm ' + Math.round(s % 60) + 's' : s.toFixed(1) + 's'; }

    function idbRun() {
        bootstrap.Modal.getOrCreateInstance(document.getElementById('idbConfirm')).hide();
        var plan = idbPlan(), stopOnError = document.getElementById('idbCfStop').checked;
        var d = new Date(), pad = function (n) { return ('0' + n).slice(-2); };
        var runId = d.getFullYear() + pad(d.getMonth() + 1) + pad(d.getDate()) + pad(d.getHours()) + pad(d.getMinutes()) + pad(d.getSeconds()) + '-' + Math.random().toString(16).slice(2, 8);
        var total = plan.length, done = 0, created = 0, replaced = 0, failed = 0, t0 = Date.now();
        idbStopReq = false; idbRunning = true; idbFailed = {};

        var box = document.getElementById('idbProgress');
        box.style.display = ''; box.className = 'idb-progress mb-3';
        document.getElementById('idbStopBtn').style.display = ''; document.getElementById('idbStopBtn').disabled = false;
        document.getElementById('idbStopBtn').innerHTML = '<i class="bi bi-stop-fill me-1"></i>Henti';
        document.getElementById('idbReAnalyseBtn').style.display = 'none';
        document.querySelectorAll('.idb-head-actions a, #<%= divRunBtn.ClientID %> button').forEach(function (b) { b.classList.add('disabled'); });
        box.scrollIntoView({ behavior: 'smooth', block: 'center' });

        function stats() {
            document.getElementById('idbProgStats').textContent = done + ' / ' + total + ' langkah · ' + created + ' dicipta · ' + replaced + ' diganti' + (failed ? ' · ' + failed + ' gagal' : '') + ' · ' + idbFmt(Date.now() - t0);
            document.getElementById('idbProgBar').style.width = (total ? Math.round(done * 100 / total) : 0) + '%';
        }

        function finish(cancelled) {
            idbRunning = false;
            box.className = 'idb-progress mb-3 ' + (failed || cancelled ? 'failed' : 'done');
            document.getElementById('idbProgTitle').innerHTML = failed ? '<i class="bi bi-x-octagon text-danger me-1"></i>Selesai dengan ' + failed + ' ralat'
                : cancelled ? '<i class="bi bi-pause-circle text-warning me-1"></i>Dihenti oleh pengguna'
                : '<i class="bi bi-check-circle text-success me-1"></i>Berjaya dijalankan';
            document.getElementById('idbProgCur').textContent = 'Run ID ' + runId;
            document.getElementById('idbStopBtn').style.display = 'none';
            document.getElementById('idbReAnalyseBtn').style.display = '';
            if (failed) { var fc = document.querySelector('.idb-chip[data-f="FAILED"]'); fc.style.display = ''; idbFilter = 'FAILED'; }
            idbApplyFilter();
            stats();
        }

        function next(i) {
            if (i >= plan.length) { finish(false); return; }
            if (idbStopReq) { finish(true); return; }
            var tr = plan[i], code = tr.getAttribute('data-code'), state = tr.getAttribute('data-state');
            tr.classList.add('running');
            document.getElementById('idbProgTitle').innerHTML = '<span class="spinner-border spinner-border-sm text-primary me-2"></span>Menjalankan skrip...';
            document.getElementById('idbProgCur').textContent = code + ' · ' + tr.children[1].textContent + ' · ' + tr.getAttribute('data-name');
            stats();

            $.ajax({ type: 'POST', url: idbRunUrl, contentType: 'application/json; charset=utf-8', dataType: 'json',
                     data: JSON.stringify({ runId: runId, code: code, state: state }) })
             .done(function (r) { handle(r && r.d ? r.d : { ok: false, message: 'Tiada respons.' }); })
             .fail(function (x) { handle({ ok: false, message: 'HTTP ' + x.status + ' ' + (x.responseJSON && x.responseJSON.Message ? x.responseJSON.Message : x.statusText) }); });

            function handle(r) {
                tr.classList.remove('running');
                var cell = tr.querySelector('td.res');
                done++;
                if (r.ok) {
                    if (state === 'DIFFERENT') replaced++; else created++;
                    cell.innerHTML = '<span class="idb-badge ok">' + (state === 'DIFFERENT' ? 'Diganti' : 'Dicipta') + '</span> <span class="text-muted small">' + idbFmt(r.ms || 0) + '</span>';
                    tr.setAttribute('data-state', 'SAME');
                    tr.querySelector('td:nth-child(5)').innerHTML = '<span class="idb-badge ok">Terkini</span>';
                } else {
                    failed++; idbFailed[code] = true;
                    tr.classList.add('err');
                    cell.innerHTML = '<span class="idb-badge fail">Gagal</span> <span class="small text-danger"></span>';
                    cell.querySelector('.text-danger').textContent = r.message || '';
                    cell.title = r.message || '';
                }
                stats();
                if (!r.ok && stopOnError) { finish(false); return; }
                next(i + 1);
            }
        }
        next(0);
    }

    window.addEventListener('beforeunload', function (e) { if (idbRunning) { e.preventDefault(); e.returnValue = ''; } });
    if (window.Sys && Sys.Application) { Sys.Application.add_load(idbInit); } else { document.addEventListener('DOMContentLoaded', idbInit); }
</script>
</asp:Content>
