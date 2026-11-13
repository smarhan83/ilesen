<%@ Page Title="" Language="VB" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="audittrail.aspx.vb" Inherits="html_administration_audittrail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">

    <%-- Gaya senarai sama seperti lesen/kelulusan1.aspx (kl-card / kl-head / kl-filter / kl-table / kl-pager) --%>
    <style>
        .kl-card { background: #fff; border: 1px solid #E3E7F1; border-radius: 12px; box-shadow: 0 2px 8px rgba(46,49,146,.06); margin-bottom: 16px; overflow: hidden; }
        .kl-head { display: flex; flex-wrap: wrap; gap: 12px; align-items: center; justify-content: space-between; padding: 18px 20px; border-bottom: 1px solid #e9ecef; background: #EEF1FA; border-left: 4px solid #2E3192; }
        .kl-title { font-size: 17px; font-weight: 700; color: #23267a; margin: 0; }
        .kl-sub { color: #5B6478; font-size: 13px; margin-top: 2px; }
        .kl-head-actions { display: flex; flex-wrap: wrap; gap: 14px; align-items: center; }
        .kl-count { color: #2E3192; font-size: 13px; font-weight: 700; background: #fff; border: 1px solid #dee2e6; border-radius: 999px; padding: 4px 12px; }
        .kl-rows { display: flex; align-items: center; gap: 8px; font-size: 13px; color: #5B6478; }
        .kl-card .kl-rows select.form-control { width: 78px; height: 32px !important; min-height: 32px !important; padding: 0 8px !important; margin: 0 !important; border: 1px solid #d0d5dd !important; border-radius: 6px !important; font-size: 13px; }

        .kl-export { display: flex; gap: 6px; }
        .kl-exp { display: inline-flex; align-items: center; gap: 6px; height: 32px; padding: 0 12px; border: 1px solid #E3E7F1; border-radius: 8px; background: #fff; color: #3F4A6B; font-size: 13px; font-weight: 600; text-decoration: none; transition: background .15s, border-color .15s, color .15s; }
        .kl-exp i { font-size: 15px; }
        .kl-exp.xls i { color: #1e7e34; }
        .kl-exp.pdf i { color: #C0392B; }
        .kl-exp.xls:hover { background: #EAF6EE; border-color: #B9DFC6; color: #1e7e34; }
        .kl-exp.pdf:hover { background: #FCEFEE; border-color: #F0C3BE; color: #C0392B; }

        .kl-filter { padding: 14px 20px 16px; border-bottom: 1px solid #E6EBF5; background: #F8FAFE; }
        .kl-label { display: block; font-size: 12px; font-weight: 600; color: #4B5675; margin-bottom: 4px; }
        /* Semua kawalan penapis 38px (input, select2, butang) - selector spesifik untuk atasi gaya global */
        .kl-card .kl-filter input.form-control { height: 38px !important; min-height: 38px !important; margin: 0 !important; border: 1px solid #d0d5dd !important; border-radius: 6px !important; background: #fff; }
        .kl-card .kl-filter .select2-container { margin: 0 !important; width: 100% !important; }
        .kl-card .kl-filter .select2-container--default .select2-selection--single { height: 38px !important; margin: 0 !important; border: 1px solid #d0d5dd !important; border-radius: 6px !important; }
        .kl-card .kl-filter .select2-container--default .select2-selection__rendered { line-height: 36px !important; padding-left: 10px; }
        .kl-card .kl-filter .select2-container--default .select2-selection__arrow { height: 36px !important; }
        .kl-card .kl-filter-actions .btn { height: 38px; min-width: 42px; margin: 0 !important; display: inline-flex; align-items: center; justify-content: center; }
        .kl-frow { display: flex; flex-wrap: wrap; gap: 10px; align-items: flex-end; }
        .kl-frow > .kl-f { flex: 1 1 140px; min-width: 130px; }
        .kl-frow > .kl-f-w { flex: 1.4 1 190px; }
        .kl-filter-actions { display: flex; gap: 8px; margin-left: auto; }

        .kl-stats { display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 12px; padding: 16px 20px; border-bottom: 1px solid #E6EBF5; }
        .kl-stat { border: 1px solid #e3e8f2; border-radius: 10px; padding: 12px 14px; background: #fff; display: flex; align-items: center; gap: 12px; }
        .kl-stat .ic { width: 38px; height: 38px; flex: 0 0 38px; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 17px; }
        .kl-stat .v { font-size: 20px; font-weight: 800; color: #1f2937; line-height: 1.15; }
        .kl-stat .k { font-size: 12px; color: #64748b; font-weight: 600; }
        .kl-stat.all .ic { background: #EEF1FA; color: #2E3192; }
        .kl-stat.add .ic { background: #D4EDDA; color: #1e7e34; }
        .kl-stat.upd .ic { background: #DCEBFF; color: #1D4ED8; }
        .kl-stat.del .ic { background: #FCEAEA; color: #C0392B; }
        .kl-stat.log .ic { background: #E4DFFB; color: #2E3192; }
        .kl-stat.fail .ic { background: #FFE9E3; color: #B4441F; }
        .kl-stat.wf .ic { background: #E0F2F1; color: #00695C; }
        .kl-stat.doc .ic { background: #F3E8FF; color: #7E3AF2; }

        .kl-table { margin: 0 !important; width: 100%; }
        .kl-table th { background: #EEF1FA !important; color: #3F4A6B !important; font-size: 12px; font-weight: 600; text-transform: uppercase; letter-spacing: .04em; padding: 12px 16px !important; border-bottom: 1px solid #e9ecef !important; white-space: nowrap; }
        .kl-table td { padding: 14px 16px !important; vertical-align: middle; color: #212529; font-size: 14px; background: #fff; border-bottom: 1px solid #f1f3f5; }
        .kl-table tr:hover td { background: #F6F7FF; }
        .kl-col-act { width: 1%; white-space: nowrap; text-align: right; }
        .kl-nowrap { white-space: nowrap; }
        .kl-date { font-weight: 600; white-space: nowrap; }
        .kl-time { color: #6c757d; font-size: 12.5px; white-space: nowrap; }
        .kl-user { display: flex; align-items: center; gap: 10px; }
        .kl-av { width: 34px; height: 34px; flex: 0 0 34px; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: #fff; font-weight: 700; font-size: 12.5px; }
        .kl-name { font-weight: 600; }
        .kl-addr { color: #6c757d; font-size: 12.5px; margin-top: 1px; }
        .kl-title-cell { overflow-wrap: anywhere; }
        .kl-ip { font-family: Consolas, 'Courier New', monospace; font-size: 13px; color: #495057; white-space: nowrap; }
        /* Butang butiran: ikon kecil, ringan; berwarna bila hover */
        .kl-view { width: 32px; height: 32px; padding: 0; display: inline-flex; align-items: center; justify-content: center; border: 1px solid #E3E7F1; border-radius: 8px; background: #fff; color: #6c757d; font-size: 15px; line-height: 1; cursor: pointer; transition: background .15s, color .15s, border-color .15s; }
        .kl-view:hover { background: #EEF1FA; border-color: #C9CEEB; color: #2E3192; }
        .kl-view:focus-visible { outline: 2px solid #2E3192; outline-offset: 2px; }
        .kl-table tr:hover .kl-view { border-color: #C9CEEB; color: #2E3192; }

        .kl-status-badge { display: inline-block; padding: 4px 10px; border-radius: 6px; font-size: 12px; font-weight: 600; line-height: 1.4; white-space: nowrap; }
        .kl-status-badge.add { background: #D4EDDA; color: #1e7e34; }
        .kl-status-badge.upd { background: #DCEBFF; color: #1D4ED8; }
        .kl-status-badge.del { background: #FCEAEA; color: #C0392B; }
        .kl-status-badge.log { background: #E4DFFB; color: #2E3192; }
        .kl-status-badge.oth { background: #f1f3f5; color: #6c757d; }
        .kl-status-badge.fail { background: #FFE9E3; color: #B4441F; }
        .kl-status-badge.wf { background: #E0F2F1; color: #00695C; }
        .kl-status-badge.doc { background: #F3E8FF; color: #6B21A8; }
        .kl-ref { display: inline-block; margin-top: 3px; padding: 1px 7px; border-radius: 5px; background: #EEF1FA; color: #2E3192; font-size: 11.5px; font-weight: 600; }
        .atm-detail { background: #FFF8F5; border-color: #F3D9CF; }

        .kl-empty { text-align: center; padding: 48px 16px; color: #6c757d; }
        .kl-empty i { font-size: 40px; color: #adb5bd; display: block; margin-bottom: 10px; }

        .kl-pager { display: flex; flex-wrap: wrap; justify-content: flex-end; padding: 14px 16px; }
        .kl-pager a, .kl-pager span { display: inline-flex; min-width: 34px; height: 34px; padding: 0 8px; align-items: center; justify-content: center; margin-left: 4px; border-radius: 8px; border: 1px solid #dee2e6; color: #495057; text-decoration: none; font-size: 13px; }
        .kl-pager a:hover { background: #f1f3f5; }
        .kl-pager span.on { background: #2E3192; border-color: #2E3192; color: #fff; font-weight: 600; }
        .kl-pager span.off { color: #adb5bd; }

        /* ===== Modal butiran (tema kl: biru #2E3192, latar #EEF1FA / #F8FAFE) ===== */
        .atm .modal-dialog { max-width: 560px; }
        .atm .modal-content { border: 0; border-radius: 14px; overflow: hidden; box-shadow: 0 18px 48px rgba(35,38,122,.22); }
        .atm-head { display: flex; align-items: center; gap: 12px; padding: 16px 18px 16px 20px !important; background: #EEF1FA; border-left: 4px solid #2E3192; border-bottom: 1px solid #E3E7F1; }
        .atm-head-ic { width: 38px; height: 38px; flex: 0 0 38px; border-radius: 10px; background: #fff; color: #2E3192; display: flex; align-items: center; justify-content: center; font-size: 18px; box-shadow: 0 1px 3px rgba(46,49,146,.12); }
        .atm-head-txt { flex: 1; min-width: 0; }
        .atm-head h5 { margin: 0 !important; font-size: 16px; font-weight: 700; color: #23267a; }
        .atm-sub { font-size: 12.5px; color: #5B6478; margin-top: 1px; }
        .atm-x { width: 32px; height: 32px; flex: 0 0 32px; border: 0; border-radius: 8px; background: transparent; color: #5B6478; display: flex; align-items: center; justify-content: center; font-size: 15px; cursor: pointer; }
        .atm-x:hover { background: #fff; color: #23267a; }

        .atm-body { padding: 18px 20px 6px !important; background: #fff; }
        .atm-user { display: flex; align-items: center; gap: 12px; padding: 12px 14px; border: 1px solid #E3E7F1; border-radius: 12px; background: #F8FAFE; margin-bottom: 14px; }
        .atm-av { width: 42px; height: 42px; flex: 0 0 42px; font-size: 14px; }
        .atm-user-txt { flex: 1; min-width: 0; }
        .atm-uname { font-weight: 700; color: #212529; overflow-wrap: anywhere; }
        .atm-umeta { font-size: 12.5px; color: #6c757d; overflow-wrap: anywhere; }

        .atm-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-bottom: 14px; }
        .atm-item { display: flex; align-items: flex-start; gap: 10px; padding: 10px 12px; border: 1px solid #EEF1F6; border-radius: 10px; }
        .atm-ic { width: 30px; height: 30px; flex: 0 0 30px; border-radius: 8px; background: #EEF1FA; color: #2E3192; display: flex; align-items: center; justify-content: center; font-size: 14px; }
        .atm-k { font-size: 11.5px; font-weight: 600; text-transform: uppercase; letter-spacing: .04em; color: #7A8295; }
        .atm-v { font-size: 13.5px; font-weight: 600; color: #212529; margin-top: 1px; overflow-wrap: anywhere; }
        .atm-k-title { margin-bottom: 6px; }
        .atm-title { padding: 12px 14px; border-radius: 10px; background: #F8FAFE; border: 1px solid #E3E7F1; color: #212529; font-size: 13.5px; line-height: 1.5; white-space: pre-wrap; overflow-wrap: anywhere; max-height: 220px; overflow-y: auto; margin-bottom: 14px; }

        .atm-foot { display: flex; justify-content: flex-end; padding: 12px 20px 16px !important; background: #fff; border-top: 1px solid #F1F3F5; }
        .atm-foot .btn { height: 36px; min-width: 90px; margin: 0 !important; border-radius: 8px; }
        @media (max-width: 575.98px) { .atm-grid { grid-template-columns: 1fr; } }

        @media (max-width: 1199.98px) { .kl-stats { grid-template-columns: repeat(3, minmax(0, 1fr)); } }
        @media (max-width: 767.98px) {
            .kl-head, .kl-filter, .kl-stats { padding: 14px 16px; }
            .kl-stats { grid-template-columns: repeat(2, minmax(0, 1fr)); }
            .kl-filter-actions { width: 100%; margin-left: 0; }
            .kl-filter-actions .btn { flex: 1; }
        }
    </style>

    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0 text-dark"><div runat="server" id="idWindowTitle">Audit Trail</div></h1>
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

            <div class="kl-card">

                <div class="kl-head">
                    <div>
                        <h3 class="kl-title">Activity Log</h3>
                        <div class="kl-sub"><asp:Literal ID="litShowing" runat="server" /></div>
                    </div>
                    <div class="kl-head-actions">
                        <div class="kl-rows">
                            Rows per page
                            <asp:DropDownList ID="ddlRows" runat="server" CssClass="form-control" AutoPostBack="true">
                                <asp:ListItem Value="25" Selected="True">25</asp:ListItem>
                                <asp:ListItem Value="50">50</asp:ListItem>
                                <asp:ListItem Value="100">100</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <span class="kl-count"><asp:Literal ID="litTotal" runat="server" Text="0" /> rekod</span>
                        <%-- Muat turun ikut penapis semasa (semua halaman) --%>
                        <div class="kl-export">
                            <asp:LinkButton ID="btnExcel" runat="server" CssClass="kl-exp xls" CausesValidation="false" data-no-loader="1" ToolTip="Download Excel (filtered records)"><i class="bi bi-file-earmark-excel"></i>Excel</asp:LinkButton>
                            <asp:LinkButton ID="btnPdf" runat="server" CssClass="kl-exp pdf" CausesValidation="false" data-no-loader="1" ToolTip="Download PDF (filtered records)"><i class="bi bi-file-earmark-pdf"></i>PDF</asp:LinkButton>
                        </div>
                    </div>
                </div>

                <%--# FILTER #--%>
                <asp:Panel ID="pnlFilter" runat="server" CssClass="kl-filter" DefaultButton="btnSearch">
                    <div class="kl-frow">
                        <div class="kl-f">
                            <label class="kl-label">Date From</label>
                            <asp:TextBox ID="txtDari" runat="server" TextMode="Date" CssClass="form-control" />
                        </div>
                        <div class="kl-f">
                            <label class="kl-label">Date To</label>
                            <asp:TextBox ID="txtHingga" runat="server" TextMode="Date" CssClass="form-control" />
                        </div>
                        <div class="kl-f kl-f-w">
                            <label class="kl-label">Module</label>
                            <asp:DropDownList ID="ddlModule" runat="server" CssClass="form-control select2" />
                        </div>
                        <div class="kl-f">
                            <label class="kl-label">Action</label>
                            <asp:DropDownList ID="ddlAction" runat="server" CssClass="form-control select2" />
                        </div>
                        <div class="kl-f kl-f-w">
                            <label class="kl-label">User Name</label>
                            <%-- Senarai pengguna diisi dari TBL_AUDITTRAIL (pengguna yang ada rekod), boleh dicari --%>
                            <asp:DropDownList ID="ddlUser" runat="server" CssClass="form-control select2" />
                        </div>
                        <div class="kl-f kl-f-w">
                            <label class="kl-label">Title / Keyword</label>
                            <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" placeholder="Search in title" autocomplete="off" />
                        </div>
                        <div class="kl-filter-actions">
                            <asp:LinkButton ID="btnSearch" runat="server" CssClass="btn btn-default" CausesValidation="false" ToolTip="Search"><i class="bi bi-search"></i></asp:LinkButton>
                            <asp:LinkButton ID="btnReset" runat="server" CssClass="btn btn-default" CausesValidation="false" ToolTip="Reset"><i class="bi bi-arrow-counterclockwise"></i></asp:LinkButton>
                        </div>
                    </div>
                </asp:Panel>

                <%--# RINGKASAN #--%>
                <div class="kl-stats">
                    <div class="kl-stat all"><div class="ic"><i class="bi bi-list-ul"></i></div><div><div class="v"><asp:Literal ID="litTotalStat" runat="server" Text="0" /></div><div class="k">Total Activities</div></div></div>
                    <div class="kl-stat add"><div class="ic"><i class="bi bi-plus-lg"></i></div><div><div class="v"><asp:Literal ID="litAdd" runat="server" Text="0" /></div><div class="k">Insert / Add</div></div></div>
                    <div class="kl-stat upd"><div class="ic"><i class="bi bi-pencil-fill"></i></div><div><div class="v"><asp:Literal ID="litUpd" runat="server" Text="0" /></div><div class="k">Update</div></div></div>
                    <div class="kl-stat del"><div class="ic"><i class="bi bi-trash3-fill"></i></div><div><div class="v"><asp:Literal ID="litDel" runat="server" Text="0" /></div><div class="k">Delete / Remove</div></div></div>
                    <div class="kl-stat log"><div class="ic"><i class="bi bi-box-arrow-in-right"></i></div><div><div class="v"><asp:Literal ID="litLog" runat="server" Text="0" /></div><div class="k">Login / Logout</div></div></div>
                    <div class="kl-stat wf"><div class="ic"><i class="bi bi-diagram-3"></i></div><div><div class="v"><asp:Literal ID="litWf" runat="server" Text="0" /></div><div class="k">Approval / Workflow</div></div></div>
                    <div class="kl-stat doc"><div class="ic"><i class="bi bi-file-earmark-arrow-down"></i></div><div><div class="v"><asp:Literal ID="litDoc" runat="server" Text="0" /></div><div class="k">Upload / Download</div></div></div>
                    <div class="kl-stat fail"><div class="ic"><i class="bi bi-shield-exclamation"></i></div><div><div class="v"><asp:Literal ID="litFail" runat="server" Text="0" /></div><div class="k">Failed / Denied</div></div></div>
                </div>

                <div class="table-responsive">
                    <asp:Repeater ID="rptLog" runat="server">
                        <HeaderTemplate>
                            <table class="kl-table table">
                                <thead>
                                    <tr>
                                        <th>Date / Time</th>
                                        <th>User</th>
                                        <th>Action</th>
                                        <th>Module</th>
                                        <th>Title</th>
                                        <th>IP Address</th>
                                        <th class="kl-col-act"></th>
                                    </tr>
                                </thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td>
                                    <div class="kl-date"><%# Eval("AT_datetime", "{0:dd MMM yyyy}") %></div>
                                    <div class="kl-time"><%# Eval("AT_datetime", "{0:hh:mm:ss tt}") %></div>
                                </td>
                                <td>
                                    <div class="kl-user">
                                        <span class="kl-av" style='background:<%# AvatarColour(Eval("AT_UserName")) %>'><%# HttpUtility.HtmlEncode(Initials(Eval("AT_UserName"))) %></span>
                                        <div>
                                            <div class="kl-name"><%# HttpUtility.HtmlEncode(Eval("AT_UserName")) %></div>
                                            <div class="kl-addr">ID <%# Eval("AT_UserId") %><%# If(Convert.ToString(Eval("FullName")) = "", "", " &middot; " & HttpUtility.HtmlEncode(Eval("FullName"))) %></div>
                                        </div>
                                    </div>
                                </td>
                                <td><span class='kl-status-badge <%# Eval("Kat") %>'><%# HttpUtility.HtmlEncode(Eval("AT_Action")) %></span></td>
                                <td><%# HttpUtility.HtmlEncode(Eval("AT_Module")) %></td>
                                <td class="kl-title-cell"><%# HttpUtility.HtmlEncode(Ringkas(Eval("AT_Title"))) %><%# If(Convert.ToString(Eval("AT_Ref")) = "", "", "<div><span class='kl-ref'>" & HttpUtility.HtmlEncode(Eval("AT_Ref")) & "</span></div>") %></td>
                                <td class="kl-ip"><%# HttpUtility.HtmlEncode(Eval("AT_IP")) %></td>
                                <td class="kl-col-act">
                                    <button type="button" class="kl-view" onclick="atDetails(this)" title="View details" aria-label="View details"
                                        data-id='<%# Eval("AT_Id") %>'
                                        data-dt='<%# Eval("AT_datetime", "{0:dd MMM yyyy hh:mm:ss tt}") %>'
                                        data-user='<%# HttpUtility.HtmlAttributeEncode(Convert.ToString(Eval("AT_UserName"))) %>'
                                        data-uid='<%# Eval("AT_UserId") %>'
                                        data-name='<%# HttpUtility.HtmlAttributeEncode(Convert.ToString(Eval("FullName"))) %>'
                                        data-action='<%# HttpUtility.HtmlAttributeEncode(Convert.ToString(Eval("AT_Action"))) %>'
                                        data-module='<%# HttpUtility.HtmlAttributeEncode(Convert.ToString(Eval("AT_Module"))) %>'
                                        data-title='<%# HttpUtility.HtmlAttributeEncode(Convert.ToString(Eval("AT_Title"))) %>'
                                        data-ip='<%# HttpUtility.HtmlAttributeEncode(Convert.ToString(Eval("AT_IP"))) %>'
                                        data-ref='<%# HttpUtility.HtmlAttributeEncode(Convert.ToString(Eval("AT_Ref"))) %>'
                                        data-detail='<%# HttpUtility.HtmlAttributeEncode(Convert.ToString(Eval("AT_Detail"))) %>'
                                        data-kat='<%# Eval("Kat") %>'
                                        data-ini='<%# HttpUtility.HtmlAttributeEncode(Initials(Eval("AT_UserName"))) %>'
                                        data-col='<%# AvatarColour(Eval("AT_UserName")) %>'>
                                        <i class="bi bi-eye"></i>
                                    </button>
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                                </tbody>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>
                    <asp:PlaceHolder ID="phEmpty" runat="server" Visible="false">
                        <div class="kl-empty"><i class="bi bi-inbox"></i>No activity found for the selected filters.</div>
                    </asp:PlaceHolder>
                </div>

                <asp:Repeater ID="rptPager" runat="server">
                    <HeaderTemplate><div class="kl-pager"></HeaderTemplate>
                    <ItemTemplate>
                        <asp:LinkButton runat="server" CommandName="Page" CommandArgument='<%# Eval("Page") %>' CausesValidation="false"
                            Visible='<%# CBool(Eval("Enabled")) AndAlso Not CBool(Eval("Current")) %>'><%# Eval("Text") %></asp:LinkButton>
                        <asp:PlaceHolder runat="server" Visible='<%# Not CBool(Eval("Enabled")) OrElse CBool(Eval("Current")) %>'>
                            <span class='<%# If(CBool(Eval("Current")), "on", "off") %>'><%# Eval("Text") %></span>
                        </asp:PlaceHolder>
                    </ItemTemplate>
                    <FooterTemplate></div></FooterTemplate>
                </asp:Repeater>
            </div>

        </div>
    </section>

    <%--# MODAL BUTIRAN #--%>
    <div class="modal fade atm" id="atModal" tabindex="-1" aria-labelledby="atmHeading" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="atm-head">
                    <div class="atm-head-ic"><i class="bi bi-clock-history"></i></div>
                    <div class="atm-head-txt">
                        <h5 id="atmHeading">Activity Details</h5>
                        <div class="atm-sub">Record #<span id="atmId"></span></div>
                    </div>
                    <button type="button" class="atm-x" data-bs-dismiss="modal" aria-label="Close"><i class="bi bi-x-lg"></i></button>
                </div>

                <div class="atm-body">
                    <div class="atm-user">
                        <span class="kl-av atm-av" id="atmAv"></span>
                        <div class="atm-user-txt">
                            <div class="atm-uname" id="atmName"></div>
                            <div class="atm-umeta" id="atmUser"></div>
                        </div>
                        <span class="kl-status-badge" id="atmAction"></span>
                    </div>

                    <div class="atm-grid">
                        <div class="atm-item">
                            <div class="atm-ic"><i class="bi bi-calendar-event"></i></div>
                            <div><div class="atm-k">Date / Time</div><div class="atm-v" id="atmDt"></div></div>
                        </div>
                        <div class="atm-item">
                            <div class="atm-ic"><i class="bi bi-grid"></i></div>
                            <div><div class="atm-k">Module</div><div class="atm-v" id="atmModule"></div></div>
                        </div>
                        <div class="atm-item">
                            <div class="atm-ic"><i class="bi bi-hdd-network"></i></div>
                            <div><div class="atm-k">IP Address</div><div class="atm-v kl-ip" id="atmIp"></div></div>
                        </div>
                        <div class="atm-item">
                            <div class="atm-ic"><i class="bi bi-person-badge"></i></div>
                            <div><div class="atm-k">User ID</div><div class="atm-v" id="atmUid"></div></div>
                        </div>
                        <div class="atm-item" id="atmRefBox">
                            <div class="atm-ic"><i class="bi bi-hash"></i></div>
                            <div><div class="atm-k">Reference</div><div class="atm-v" id="atmRef"></div></div>
                        </div>
                    </div>

                    <div class="atm-k atm-k-title">Title</div>
                    <div class="atm-title" id="atmTitle"></div>

                    <div id="atmDetailBox">
                        <div class="atm-k atm-k-title">Detail</div>
                        <div class="atm-title atm-detail" id="atmDetail"></div>
                    </div>
                </div>

                <div class="atm-foot">
                    <button type="button" class="btn btn-default" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        function atDetails(btn) {
            var d = btn.dataset;
            var set = function (id, v) { document.getElementById(id).textContent = v || '-'; };
            set('atmId', d.id);
            set('atmDt', d.dt);
            set('atmName', d.name || d.user);
            set('atmUser', d.name ? d.user : 'No full name recorded');
            set('atmUid', d.uid);
            set('atmModule', d.module);
            set('atmTitle', d.title);
            set('atmIp', d.ip);
            set('atmRef', d.ref);
            set('atmDetail', d.detail);
            document.getElementById('atmRefBox').style.display = d.ref ? '' : 'none';
            document.getElementById('atmDetailBox').style.display = d.detail ? '' : 'none';

            var av = document.getElementById('atmAv');
            av.textContent = d.ini || '?';
            av.style.background = d.col || '#7A8295';

            var act = document.getElementById('atmAction');
            act.textContent = d.action || '-';
            act.className = 'kl-status-badge ' + (d.kat || 'oth');

            bootstrap.Modal.getOrCreateInstance(document.getElementById('atModal')).show();
        }
    </script>

</asp:Content>
