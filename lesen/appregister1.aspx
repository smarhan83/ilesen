<%@ Page MaintainScrollPositionOnPostback="true" Title="" Language="VB" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="appregister1.aspx.vb" Inherits="appregister1" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadContent" runat="Server">
    <style>
        .ajax__scroll_none {
            overflow: visible !important;
        }

        .wrapperTooltip {
            /*text-transform: uppercase;
	   background: #ececec;
	   color: #555;*/
            cursor: help;
            /*font-family: "Gill Sans", Impact, sans-serif;
	   font-size: 20px;*/
            /*   margin: 100px 75px 10px 75px;
	   padding: 15px 20px;*/
            position: relative;
            text-align: center;
            width: 100%;
            -webkit-transform: translateZ(0); /* webkit flicker fix */
            -webkit-font-smoothing: antialiased; /* webkit text rendering fix */
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
                /*-webkit-transform: translateY(10px);
	   -moz-transform: translateY(10px);
	   -ms-transform: translateY(10px);
	   -o-transform: translateY(10px);
	   transform: translateY(10px);
	   -webkit-transition: all .25s ease-out;
	   -moz-transition: all .25s ease-out;
	   -ms-transition: all .25s ease-out;
	   -o-transition: all .25s ease-out;
	   transition: all .25s ease-out;*/
                -webkit-box-shadow: 2px 2px 6px rgba(0, 0, 0, 0.28);
                -moz-box-shadow: 2px 2px 6px rgba(0, 0, 0, 0.28);
                -ms-box-shadow: 2px 2px 6px rgba(0, 0, 0, 0.28);
                -o-box-shadow: 2px 2px 6px rgba(0, 0, 0, 0.28);
                box-shadow: 2px 2px 6px rgba(0, 0, 0, 0.28);
                z-index: 9999999 !important;
            }

                /* This bridges the gap so you can mouse into the tooltip without it disappearing */
                .wrapperTooltip .tooltip:before {
                    bottom: -20px;
                    content: " ";
                    display: block;
                    /*height: 500px;*/
                    left: 0;
                    position: absolute;
                    width: 100%;
                    z-index: 9999999 !important;
                }

                /* CSS Triangles - see Trevor's post */
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
                /*-webkit-transform: translateY(0px);
	   -moz-transform: translateY(0px);
	   -ms-transform: translateY(0px);
	   -o-transform: translateY(0px);
	   transform: translateY(0px);*/
                z-index: 9999999 !important;
            }

        /* IE can just show/hide with no transition */
        .lte8 .wrapperTooltip .tooltip {
            display: none;
        }

        .lte8 .wrapperTooltip:hover .tooltip {
            display: block;
        }

        .Disabled {
            pointer-events: none;
            cursor: not-allowed;
            opacity: 0.65;
            filter: alpha(opacity=65);
            -webkit-box-shadow: none;
            box-shadow: none;
        }

        .ajax__tab_xp .ajax__tab_header {
            background-image: url('') !important;
            font-size: 11pt !important;
            height: 40px !important;
            color: #000 !important;
        }

            .ajax__tab_xp .ajax__tab_header .ajax__tab_outer {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header .ajax__tab_inner {
                /* background-image: url('WebResource.axd?d=zNSHuGr6hc7c16bSY9eWXPrNBVsZSwehGbscYki57kRbdTai8trIfAuzMrttb3pm0uA8ApvgRAgRqJhPO3fCauUTiyK3qOK21RmA7QURs6o63zcRczK2Ul9bZbli-JHArtBLoeaLoTT7L8haCKoAtg2&t=636970230480000000'); */
            }

            .ajax__tab_xp .ajax__tab_header .ajax__tab_tab {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header .ajax__tab_hover .ajax__tab_outer {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header .ajax__tab_hover .ajax__tab_inner {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header .ajax__tab_hover .ajax__tab_tab {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header .ajax__tab_active .ajax__tab_outer {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header .ajax__tab_active .ajax__tab_inner {
                /* background-image: url('WebResource.axd?d=7d55T9B4j42nYTnSODbo405bsr8zp3hoGjir6Z58ZoKPdLgwtf6qu3MXJibmbhhdha0NpvsKmg-yAHSNyDR0n5oskACF5v0vuvb-ErTRvIZqPQgNHZyi6J2H6QcoTzSVIy4XafuCbAtMT3T8iHBky3A6CmqrVChVQYLFcawUCe01&t=636970230480000000'); */
            }

            .ajax__tab_xp .ajax__tab_header .ajax__tab_active .ajax__tab_tab {
                background-image: url('') !important;
            }

        .ajax__tab_xp .ajax__tab_header_verticalleft {
            background-image: url('') !important;
        }

            .ajax__tab_xp .ajax__tab_header_verticalleft .ajax__tab_outer {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_verticalleft .ajax__tab_inner {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_verticalleft .ajax__tab_tab {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_verticalleft .ajax__tab_hover .ajax__tab_outer {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_verticalleft .ajax__tab_hover .ajax__tab_inner {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_verticalleft .ajax__tab_hover .ajax__tab_tab {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_verticalleft .ajax__tab_active .ajax__tab_outer {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_verticalleft .ajax__tab_active .ajax__tab_inner {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_verticalleft .ajax__tab_active .ajax__tab_tab {
                background-image: url('') !important;
            }

        .ajax__tab_xp .ajax__tab_header_verticalright {
            background-image: url('') !important;
        }

            .ajax__tab_xp .ajax__tab_header_verticalright .ajax__tab_outer {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_verticalright .ajax__tab_inner {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_verticalright .ajax__tab_tab {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_verticalright .ajax__tab_hover .ajax__tab_outer {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_verticalright .ajax__tab_hover .ajax__tab_inner {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_verticalright .ajax__tab_hover .ajax__tab_tab {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_verticalright .ajax__tab_active .ajax__tab_outer {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_verticalright .ajax__tab_active .ajax__tab_inner {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_verticalright .ajax__tab_active .ajax__tab_tab {
                background-image: url('') !important;
            }

        .ajax__tab_xp .ajax__tab_header_bottom {
            background-image: url('') !important;
        }

            .ajax__tab_xp .ajax__tab_header_bottom .ajax__tab_outer {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_bottom .ajax__tab_inner {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_bottom .ajax__tab_tab {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_bottom .ajax__tab_hover .ajax__tab_outer {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_bottom .ajax__tab_hover .ajax__tab_inner {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_bottom .ajax__tab_hover .ajax__tab_tab {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_bottom .ajax__tab_active .ajax__tab_outer {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_bottom .ajax__tab_active .ajax__tab_inner {
                background-image: url('') !important;
            }

            .ajax__tab_xp .ajax__tab_header_bottom .ajax__tab_active .ajax__tab_tab {
                background-image: url('') !important;
            }

        .ajax__tab_xp .ajax__tab_header .ajax__tab_active .ajax__tab_inner {
            background-image: url('') !important;
            width: 150px !important;
            text-align: center !important;
            vertical-align: middle !important;
            border-top-right-radius: 10px 10px !important;
            border-top-left-radius: 10px 10px !important;
        }

            .ajax__tab_xp .ajax__tab_header .ajax__tab_active .ajax__tab_inner a {
                color: #fff !important;
                /*font-weight : bold !important;*/
            }

        .ajax__tab_xp .ajax__tab_header .ajax__tab_inner {
            background-image: url('') !important;
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
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">

    <section class="content-header">
        <div class="container-fluid">



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

    <%--<asp:UpdatePanel ID="updatePanel1" runat="server">
        <ContentTemplate>--%>
    <!-- Main content -->
    <section class="content">
        <div class="container-fluid">

            <asp:FormView ID="FormView1" runat="server" DataKeyNames="Permohonan_ID"
                DataSourceID="SqlDataSourceForm" Width="100%" DefaultMode="Edit">
                <EditItemTemplate>
                    <div class="card card-warning">
                        <div class="card-header">
                            <h3 class="card-title">Kemaskini Permohonan</h3>
                        </div>
                        <!-- /.card-header -->
                        <div class="card-body">
                            <asp:HiddenField ID="HF_Status" Value='<%# Bind("StatusID") %>' runat="server" />
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

                            <asp:Panel runat="server" ID="panelSearch" Visible='<%# If(Eval("StatusID") = 0 And IsDBNull(Eval("SuratKelulusan1")), True, False) %>'>
                                <asp:HiddenField ID="HF_PermohonanID" runat="server" Value='<%# Bind("Permohonan_ID") %>' />
                                <div class="row">

                                    <div class="col-md-6">

                                        <div class="form-group">
                                            <label>Pemohon:</label>
                                            <div class="row">
                                                <div class="col">
                                                    <asp:DropDownList ID="ddl_Pemohon" CssClass="form-control select2" runat="server" OnSelectedIndexChanged="ddl_Pemohon_SelectedIndexChanged"
                                                        DataSourceID="SqlDataSourcePemohon" DataTextField="PemohonDesc" DataValueField="Pemohon_ID" AutoPostBack="true">
                                                    </asp:DropDownList>
                                                    <asp:SqlDataSource runat="server" ID="SqlDataSourcePemohon" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                        SelectCommand="SELECT NULL AS Pemohon_ID, '-- Sila Pilih --' AS PemohonDesc UNION ALL SELECT Pemohon_ID,  Pemohon_ICNo + ' - ' + Pemohon_Name AS PemohonDesc FROM LESEN_Pemohon WHERE Pemohon_IsActive = 1"></asp:SqlDataSource>
                                                    <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" CssClass="cssRequiredField"
                                                        ControlToValidate="ddl_Pemohon" ErrorMessage="Sila Pilih" ValidationGroup="updateForm" Display="Dynamic"></asp:RequiredFieldValidator>--%>
                                                </div>
                                                <div class="col">
                                                    <asp:HyperLink runat="server" NavigateUrl="~/lesen/applicantregister.aspx?p_Id=3354&m_Id=3355" CssClass="btn btn-default">Daftar Pemohon</asp:HyperLink>

                                                </div>

                                            </div>

                                        </div>

                                    </div>
                                </div>
                                
                            </asp:Panel>

                            <asp:Panel runat="server" ID="pnlpemohon">
                                <div class="row">

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Pemohon ID</label>
                                            <asp:TextBox ID="TB_PemohonID" runat="server" Enabled="false" Text='<%# Bind("Permohonan_PemohonID") %>' CssClass="form-control" />
                                        </div>
                                    </div>
                                </div>

                                <div class="row">

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Nama Pemohon</label>
                                            <asp:TextBox ID="TB_Name" runat="server" Enabled="false" Text="NULL" CssClass="form-control" />
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Warganegara</label>
                                            <asp:TextBox ID="TB_Nat" runat="server" Enabled="false" Text="NULL" CssClass="form-control" />
                                        </div>
                                    </div>

                                </div>

                                <div class="row">

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Alamat</label>
                                            <asp:TextBox ID="TB_Address" Enabled="false" runat="server"
                                                Text="NULL" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Catatan</label>
                                            <asp:TextBox ID="TB_Remarks" Enabled="false" runat="server"
                                                Text="NULL" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                                        </div>
                                    </div>

                                </div>
                            </asp:Panel>

                            <hr style="border: 1px solid gray;" />

                            <asp:Panel runat="server" Enabled='<%# If(Eval("StatusID") = 0, True, True) %>'>
                                <div class="row">

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Tarikh Mohon</label>
                                            <asp:TextBox ID="TB_TarikhMohon" runat="server"
                                                Text='<%# Bind("TarikhMohon", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_TarikhMohon" ErrorMessage="Sila Pilih" ValidationGroup="updateForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                </div>

                                <div class="row">

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Jenis Lesen/Permit</label>
                                            <asp:DropDownList ID="ddlItems" runat="server" DataSourceID="SqlDataSource1" CssClass="form-control select2"
                                                DataTextField="JenisLesen_Description" DataValueField="JenisLesen_ID" AutoPostBack="true"
                                                OnSelectedIndexChanged="ddlItems_SelectedIndexChanged" AppendDataBoundItems="true">
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

                                        <div class="tag-container" style="display: flex; gap: 10px; flex-wrap: wrap;">
                                            <asp:Repeater ID="rptSelectedItems" runat="server" OnItemCommand="rptSelectedItems_ItemCommand">
                                                <ItemTemplate>
                                                    <div style="background: #e1e1e1; padding: 5px 10px; border-radius: 15px; display: flex; align-items: center; border: 1px solid #ccc;">
                                                        <span style="margin-right: 8px;"><%# Eval("ItemText") %></span>
                                                        <asp:LinkButton ID="btnRemove" runat="server" 
                                                            CommandName="Remove" 
                                                            CommandArgument='<%# Eval("ItemValue") %>' 
                                                            Style="color: red; text-decoration: none; font-weight: bold;">&times;</asp:LinkButton>
                                                    </div>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </div>

                                    </div>

                                </div>

                                <%--# Perniagaan Berisiko dan tidak berisiko #--%>
                                <asp:Panel ID="pnlesen1" runat="server" Visible="False">

                                    <div class="row">

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Nama Syarikat/Sediada</label>
                                                <asp:TextBox ID="TB_NamaSyarikat" runat="server"
                                                    Text='<%# Bind("NamaSyarikat") %>' CssClass="form-control" />

                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label>No Pendaftaran</label>
                                                <asp:TextBox ID="TB_NoPendaftaran" runat="server"
                                                    Text='<%# Bind("NoPendaftaran") %>' CssClass="form-control" />

                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label>No Akaun Lesen</label>
                                                <asp:TextBox ID="TB_NoAkaun" runat="server"
                                                    Text='<%# Bind("NoAkaun") %>' CssClass="form-control" />

                                            </div>
                                        </div>

                                    </div>

                                    <div class="row">

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Alamat Premis/Sediada</label>
                                                <asp:TextBox ID="TB_AlamatPremis" runat="server"
                                                    Text='<%# Bind("AlamatPremis") %>' TextMode="MultiLine" Rows="3" CssClass="form-control" />

                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Jenis Perniagaan/Sediada</label>
                                                <asp:TextBox ID="TB_JenisPerniagaan" runat="server"
                                                    Text='<%# Bind("JenisPerniagaan") %>' CssClass="form-control" />

                                            </div>
                                        </div>

                                    </div>

                                    <%--# Tukar Pemilik #--%>
                                    <asp:Panel ID="pnlesen1b" runat="server" Visible="False">
                                        <div class="row">

                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Nama Pemilik Baru</label>
                                                    <asp:TextBox ID="TB_PemilikBaru" runat="server"
                                                        Text='<%# Bind("PemilikBaru") %>' CssClass="form-control" />

                                                </div>
                                            </div>
                                        </div>
                                    </asp:Panel>

                                </asp:Panel>

                                <%--# Tukar Alamat #--%>
                                <asp:Panel ID="pnlesen1c" runat="server" Visible="False">

                                    <div class="row">

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Alamat Baru</label>
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
                                                <label>Jenis Perniagaan Tambahan</label>
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
                                                <label>Nama Baru Syarikat</label>
                                                <asp:TextBox ID="TB_NamaBaruSyarikat" runat="server"
                                                    Text='<%# Bind("NamaBaruSyarikat") %>' CssClass="form-control" />

                                            </div>
                                        </div>

                                    </div>

                                </asp:Panel>

                                <%--# Banting #--%>
                                <asp:Panel ID="pnlesen6" runat="server" Visible="False">

                                    <div class="row">

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Nama Syarikat Kontraktor Pemasang Iklan</label>
                                                <asp:TextBox ID="TB_KontraktorIklan" runat="server"
                                                    Text='<%# Bind("KontraktorIklan") %>' CssClass="form-control" />

                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>No Telefon Syarikat Kontraktor</label>
                                                <asp:TextBox ID="TB_NoTelKontraktor" runat="server"
                                                    Text='<%# Bind("NoTelKontraktor") %>' CssClass="form-control" />

                                            </div>
                                        </div>

                                    </div>

                                    <div class="row">

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Ukuran (Kaki)</label>
                                                <asp:TextBox ID="TB_UkuranBanting" runat="server"
                                                    Text='<%# Bind("UkuranBanting") %>' placeholder="Contoh: 5x10" CssClass="form-control" />

                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Bilangan Banting/Sepanduk</label>
                                                <asp:TextBox ID="TB_BilBanting" runat="server"
                                                    Text='<%# Bind("BilBanting") %>' CssClass="form-control" />

                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label>Tarikh Mula Pemasangan</label>
                                                <asp:TextBox ID="TB_TarikhBanting1" runat="server"
                                                    Text='<%# Bind("TarikhBanting1", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label>Tarikh Akhir Pemasangan</label>
                                                <asp:TextBox ID="TB_TarikhBanting2" runat="server"
                                                    Text='<%# Bind("TarikhBanting2", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="form-control" />
                                            </div>
                                        </div>

                                    </div>

                                     <div class="row">

                                         <div class="col-md-6">
                                             <div class="form-group">
                                                 <label>Lokasi/Tempat Pemasagan</label>
                                                 <asp:TextBox ID="TB_LokasiBanting" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />
                                             </div>
                                         </div>

                                         <div class="col-md-2">
                                            <div class="form-group">
                                                <label> </label>
                                                <asp:LinkButton ID="btnAddLokasi" runat="server" CssClass="btn btn-primary" Text="Tambah" OnClick="btnAddLokasi_Click" />
                                            </div>
                                        </div>

                                     </div>

                                     <div class="row">
                                        <div class="col-md-8">
                                            <asp:GridView ID="gvLokasiList" runat="server" HeaderStyle-ForeColor="Black" CssClass="table table-bordered" AutoGenerateColumns="False" 
                                                ShowHeaderWhenEmpty="true" EmptyDataText="Senarai kosong." OnRowDeleting="gvLokasiList_RowDeleting">
                                                <Columns>
                                                    <asp:BoundField DataField="No" HeaderText="No." />
                                                    <asp:BoundField DataField="Lokasi" HeaderText="Lokasi/Tempat Pemasangan" />
                                                    <asp:TemplateField>
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="btnRemove" runat="server"  
                                                                CommandName="Delete" CssClass="btn btn-danger btn-sm">&times;</asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                            </asp:GridView>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label>No Resit</label>
                                                <asp:TextBox ID="TB_NoResit1" runat="server"
                                                    Text='<%# Bind("NoResitBanting") %>' CssClass="form-control" />

                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label>No Siri Stiker</label>
                                                <asp:TextBox ID="TB_NoSiriStiker" runat="server"
                                                    Text='<%# Bind("NoSiriStiker") %>' CssClass="form-control" />

                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label>Tarikh</label>
                                                <asp:TextBox ID="TB_TarikhBanting3" runat="server"
                                                    Text='<%# Bind("TarikhBanting3", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="form-control" />

                                            </div>
                                        </div>

                                    </div>

                                </asp:Panel>

                                <%--# Papan iklan, Billboard #--%>
                                <asp:Panel ID="pnlesen1a" runat="server" Visible="False">

                                    <div class="row">

                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <label>Saiz Iklan (cm)</label>
                                                <asp:TextBox ID="TB_SaizIklan1" placeholder="Contoh:10x5" runat="server" CssClass="form-control" />
                                            </div>
                                        </div>
                                         <div class="col-md-2">
                                             <div class="form-group">
                                                 <label>Iklan Bercahaya</label>
                                                 <asp:DropDownList ID="DDL_Iklan1" runat="server"
                                                     CssClass="form-control select2">
                                                     <asp:ListItem Value="">-- Sila Pilih --</asp:ListItem>
                                                     <asp:ListItem Value="Bercahaya">Ya</asp:ListItem>
                                                     <asp:ListItem Value="Tidak Bercahaya">Tidak</asp:ListItem>
                                                 </asp:DropDownList>
                                             </div>
                                         </div>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <label>Bil. Unit</label>
                                                <div class="row">
                                                    <div class="col">
                                                        <asp:TextBox ID="TB_UnitIklan1" TextMode="Number" runat="server" CssClass="form-control" />
                                                    </div>
                                                    <div class="col">
                                                        <asp:LinkButton ID="btnAddIklan" runat="server" CssClass="btn btn-primary" Text="Tambah" OnClick="btnAddIklan_Click" />
                                                    </div>

                                                </div>
                                                
                                            </div>
                                        </div>
                                        
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <asp:GridView ID="gvIklanList" runat="server" HeaderStyle-ForeColor="Black" CssClass="table table-bordered" AutoGenerateColumns="False" 
                                                ShowHeaderWhenEmpty="true" EmptyDataText="Senarai kosong." OnRowDeleting="gvIklanList_RowDeleting">
                                                <Columns>
                                                    <asp:BoundField DataField="SaizIklan" HeaderText="Saiz Iklan (cm)" />
                                                    <asp:BoundField DataField="Bercahaya" HeaderText="Bercahaya/Tidak Bercahaya" />
                                                    <asp:BoundField DataField="Unit" HeaderText="Bil. Unit" />
                                                    <asp:TemplateField>
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="btnRemove" runat="server" Text="Remove" 
                                                                CommandName="Delete" CssClass="btn btn-danger btn-sm">&times;</asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                            </asp:GridView>
                                        </div>
                                    </div>

                                </asp:Panel>

                                <%--#  Billboard #--%>
                                <asp:Panel ID="pnlbillboard" runat="server" Visible="False">

                                    <div class="row">

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Lokasi Billboard</label>
                                                <asp:TextBox ID="TB_BillboardLokasi" runat="server"
                                                    Text='<%# Bind("BillboardLokasi") %>' TextMode="MultiLine" Rows="3" CssClass="form-control" />

                                            </div>
                                        </div>

                                    </div>

                                </asp:Panel>

                                <%--# Pasar Lambak #--%>
                                <asp:Panel ID="pnlesen2" runat="server" Visible="False">

                                    <div class="row">

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Lokasi Pasar #1</label>
                                                <asp:TextBox ID="TB_LokasiPasar1" runat="server"
                                                    Text='<%# Bind("LokasiPasar1") %>' TextMode="MultiLine" Rows="3" CssClass="form-control" />

                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Lokasi Pasar #2</label>
                                                <asp:TextBox ID="TB_LokasiPasar2" runat="server"
                                                    Text='<%# Bind("LokasiPasar2") %>' TextMode="MultiLine" Rows="3" CssClass="form-control" />

                                            </div>
                                        </div>

                                    </div>

                                    <div class="row">

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Lokasi Pasar #3</label>
                                                <asp:TextBox ID="TB_LokasiPasar3" runat="server"
                                                    Text='<%# Bind("LokasiPasar3") %>' TextMode="MultiLine" Rows="3" CssClass="form-control" />

                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Jenis Perniagaan</label>
                                                <asp:TextBox ID="TB_JenisPerniagaanPasar" runat="server"
                                                    Text='<%# Bind("JenisPerniagaanPasar") %>' CssClass="form-control" />

                                            </div>
                                        </div>

                                    </div>

                                    <div class="row">

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Jumlah Petak/Tapak/Lot</label>
                                                <asp:TextBox ID="TB_JumlahPetak" runat="server"
                                                    Text='<%# Bind("JumlahPetak") %>' CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Jenis Pasar</label>
                                                <asp:DropDownList ID="DDL_JenisPasar" Text='<%# Bind("JenisPasar") %>' runat="server"
                                                    CssClass="form-control select2">
                                                    <asp:ListItem Value="">-- Sila Pilih --</asp:ListItem>
                                                    <asp:ListItem>Pasar Pagi</asp:ListItem>
                                                    <asp:ListItem>Pasar Malam</asp:ListItem>
                                                    <asp:ListItem>Pasar Lambak</asp:ListItem>
                                                </asp:DropDownList>

                                            </div>
                                        </div>

                                    </div>

                                </asp:Panel>

                                <%--# Anjing #--%>
                                <asp:Panel ID="pnlesen3" runat="server" Visible="False">

                                    <div class="row">

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Alamat lokasi</label>
                                                <asp:TextBox ID="TB_AnjingAlamat" runat="server"
                                                    Text='<%# Bind("AnjingAlamat") %>' TextMode="MultiLine" Rows="3" CssClass="form-control" />
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" CssClass="cssRequiredField"
                                                    ControlToValidate="TB_AnjingAlamat" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Jenis Premis</label>
                                                <asp:DropDownList ID="DDL_AnjingJenisPremis" Text='<%# Bind("AnjingJenisPremis") %>' CssClass="form-control select2" runat="server"
                                                    DataSourceID="SqlDataSourceAnjingJenisPremis" DataTextField="name" DataValueField="id">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource runat="server" ID="SqlDataSourceAnjingJenisPremis" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                    SelectCommand="SELECT NULL AS id, '-- Sila Pilih --' AS name UNION ALL SELECT id, name 
                                                        FROM TBL_LOOKUPS WHERE lookupgrp_id = 10001 AND status = 1"></asp:SqlDataSource>
                                            </div>
                                        </div>

                                    </div>

                                    <div class="row">

                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <label>Jenis Baka</label>
                                                <asp:DropDownList ID="DDL_BakaAnjing1" CssClass="form-control select2" runat="server"
                                                    DataSourceID="SqlDataSourceAnjingBaka1" DataTextField="name" DataValueField="id">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource runat="server" ID="SqlDataSourceAnjingBaka1" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                    SelectCommand="SELECT NULL AS id, '-- Sila Pilih --' AS name UNION ALL SELECT id, name 
                                                            FROM TBL_LOOKUPS WHERE lookupgrp_id = 10004 AND status = 1"></asp:SqlDataSource>
                                            </div>
                                        </div>

                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <label>Bilangan anjing jantan</label>
                                                <asp:TextBox ID="TB_Jantan1" runat="server" TextMode="Number" CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <label>Bilangan anjing betina</label>
                                                <asp:TextBox ID="TB_Betina1" runat="server" TextMode="Number" CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <label>Bilangan anjing jantan mandul</label>
                                                <asp:TextBox ID="TB_JantanMandul1" runat="server" TextMode="Number" CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label>Bilangan anjing betina mandul</label>
                                                <div class="row">
                                                    <div class="col">
                                                        <asp:TextBox ID="TB_BetinaMandul1" runat="server" TextMode="Number" CssClass="form-control" />
                                                    </div>
                                                    <div class="col">
                                                        <asp:LinkButton ID="btnAddAnjing" runat="server" CssClass="btn btn-primary" Text="Tambah" OnClick="btnAddAnjing_Click" />
    
                                                    </div>

                                                </div>
            
                                            </div>
                                        </div>

                                    </div>

                                    <div class="row">
                                        <div class="col-md-12">
                                            <asp:GridView ID="gvAnjingList" runat="server" HeaderStyle-ForeColor="Black" CssClass="table table-bordered" AutoGenerateColumns="False" 
                                                ShowHeaderWhenEmpty="true" EmptyDataText="Senarai kosong." OnRowDeleting="gvAnjingList_RowDeleting">
                                                <Columns>
                                                    <asp:BoundField DataField="Baka" HeaderText="Baka Anjing" />
                                                    <asp:BoundField DataField="Jantan" HeaderText=" Bil. Jantan" />
                                                    <asp:BoundField DataField="Betina" HeaderText="Bil. Betina" />
                                                    <asp:BoundField DataField="JantanMandul" HeaderText="Bil. Jantan Mandul" />
                                                    <asp:BoundField DataField="BetinaMandul" HeaderText="Bil. Betina Mandul" />
                                                    <asp:TemplateField>
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="btnRemove" runat="server"  
                                                                CommandName="Delete" CssClass="btn btn-danger btn-sm">&times;</asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                            </asp:GridView>
                                        </div>
                                    </div>

                                </asp:Panel>

                                <%--# Penjaja #--%>
                                <asp:Panel ID="pnlesen4" runat="server" Visible="False">

                                    <div class="row">

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Alamat aktiviti penjajaan</label>
                                                <asp:TextBox ID="TB_AlamatPenjajaan" runat="server"
                                                    Text='<%# Bind("AlamatPenjajaan") %>' TextMode="MultiLine" Rows="3" CssClass="form-control" />

                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Jenis Perniagaan</label>
                                                <asp:TextBox ID="TB_JenisPerniagaanPenjaja" runat="server"
                                                    Text='<%# Bind("JenisPerniagaanPenjaja") %>' CssClass="form-control" />

                                            </div>
                                        </div>

                                    </div>

                                </asp:Panel>

                                <%--# Ekspo #--%>
                                <asp:Panel ID="pnlesen5" runat="server" Visible="False">

                                    <div class="row">

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Nama Penganjur</label>
                                                <asp:TextBox ID="TB_PenganjurEkspo" runat="server"
                                                    Text='<%# Bind("PenganjurEkspo") %>' CssClass="form-control" />

                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Nama Aktiviti/Program</label>
                                                <asp:TextBox ID="TB_NamaEkspo" runat="server"
                                                    Text='<%# Bind("NamaEkspo") %>' CssClass="form-control" />

                                            </div>
                                        </div>

                                    </div>

                                    <div class="row">

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Lokasi</label>
                                                <asp:TextBox ID="TB_LokasiEkspo" runat="server"
                                                    Text='<%# Bind("LokasiEkspo") %>' TextMode="MultiLine" Rows="3" CssClass="form-control" />

                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>No. Tel.</label>
                                                <asp:TextBox ID="TB_NoTel" runat="server"
                                                    Text='<%# Bind("NoTelEkspo") %>' CssClass="form-control" />

                                            </div>
                                        </div>

                                    </div>

                                    <div class="row">

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label>Tarikh Mula</label>
                                                <asp:TextBox ID="TB_TarikhEkspo1" runat="server"
                                                    Text='<%# Bind("TarikhEkspo1", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label>Masa Mula</label>
                                                <asp:TextBox ID="TB_MasaEkspo1" runat="server"
                                                    Text='<%# Bind("MasaEkspo1") %>' TextMode="Time" CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label>Tarikh Akhir</label>
                                                <asp:TextBox ID="TB_TarikhEkspo2" runat="server"
                                                    Text='<%# Bind("TarikhEkspo2", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label>Masa Akhir</label>
                                                <asp:TextBox ID="TB_MasaEkspo2" runat="server"
                                                    Text='<%# Bind("MasaEkspo2") %>' TextMode="Time" CssClass="form-control" />

                                            </div>
                                        </div>

                                    </div>

                                </asp:Panel>

                                <asp:Panel ID="pnlrujukan" runat="server">
                                    <hr style="border: 1px solid gray;" />
                                    <div class="row">

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label>No Rujukan</label>
                                                <asp:TextBox ID="TB_Rujukan" runat="server"
                                                    Text='<%# Bind("Rujukan") %>' CssClass="form-control" />

                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label>No Akaun Cukai</label>
                                                <asp:TextBox ID="TB_NoAkaunCukai" runat="server"
                                                    Text='<%# Bind("NoAkaunCukai") %>' CssClass="form-control" />

                                            </div>
                                        </div>

                                        <div class="col-md-2">
                                            <div class="form-group align-middle">
                                                <asp:Label runat="server" ForeColor="DarkRed" Font-Bold="true">Kelulusan 24 jam?</asp:Label>
                                                <asp:CheckBox ID="CB_24h" Checked='<%# Bind("Is24jam") %>' runat="server" />
                                            </div>
                                        </div>

                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label>Lokasi Fail</label>
                                                <asp:TextBox ID="TB_Remarks1" runat="server" TextMode="MultiLine" Rows="2"
                                                    Text='<%# Bind("RemarksFail") %>' CssClass="form-control" />

                                            </div>
                                        </div>

                                    </div>

                                </asp:Panel>

                            </asp:Panel>

                            <div class="row">

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Ada Deposit?</label>
                                        <asp:CheckBox ID="CB_Deposit" runat="server" Checked='<%# If(Eval("DepositAmount") Is DBNull.Value, False, True) %>' OnCheckedChanged="CB_Deposit_CheckedChanged" AutoPostBack="true" />
                                    </div>
                                </div>

                            </div>

                            <asp:Panel ID="pnldeposit" runat="server" Visible='<%# If(Eval("DepositAmount") Is DBNull.Value, False, True) %>'>

                                <div class="row">

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Amaun deposit (RM)</label>
                                            <asp:TextBox ID="TB_Depo" runat="server"
                                                Text='<%# Bind("DepositAmount") %>' TextMode="Number" placeholder="00.00" CssClass="form-control" />

                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Tarikh bayar deposit</label>
                                            <asp:TextBox ID="TB_TarikhDepo" runat="server"
                                                Text='<%# Bind("DepositDate", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="form-control" />

                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>No Resit</label>
                                            <asp:TextBox ID="TB_NoResit" runat="server"
                                                Text='<%# Bind("DepositResitNo") %>' CssClass="form-control" />

                                        </div>
                                    </div>

                                </div>

                            </asp:Panel>

                            <asp:Panel ID="pnldeposit1" runat="server" Visible='<%# If(Eval("IsBatal") = True And Eval("DepositAmount") IsNot DBNull.Value, True, False) %>'>

                                <div class="row">

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Amaun Pemulangan Wang Amanah (RM)</label>
                                            <asp:TextBox ID="TB_DepoPulang" runat="server"
                                                Text='<%# Bind("DepositPulangAmount") %>' TextMode="Number" placeholder="00.00" CssClass="form-control" />
                                        </div>
                                    </div>

                                </div>

                            </asp:Panel>

                            <asp:Panel ID="pnlbatal1" runat="server" Visible='<%# If(Eval("IsBatal") = False And Eval("StatusID") = 10, True, False) %>'>
                                <br />
                                <div class="row">
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <asp:Label runat="server" ForeColor="DarkRed" Font-Bold="true">Pembatalan Permit/Lesen?</asp:Label>
                                            <asp:CheckBox ID="CB_IsBatal" Checked='<%# Bind("IsBatal") %>' runat="server" OnCheckedChanged="CB_IsBatal_CheckedChanged" AutoPostBack="true" />
                                        </div>
                                    </div>
                                </div>
                            </asp:Panel>

                            <asp:Panel ID="pnlbatal2" runat="server" Visible='<%# If(Eval("IsBatal") = True, True, False) %>' Enabled='<%# If(Eval("StatusID") = 10, True, False) %>'>

                                <div class="row">

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Jenis Pembatalan</label>
                                            <asp:DropDownList ID="DDL_JenisBatal" Text='<%# Bind("JenisBatal") %>' runat="server" OnSelectedIndexChanged="DDL_JenisBatal_SelectedIndexChanged"
                                                CssClass="form-control select2" AutoPostBack="true">
                                                <asp:ListItem Value="">-- Sila Pilih --</asp:ListItem>
                                                <asp:ListItem Value="1">Dengan Permohonan</asp:ListItem>
                                                <asp:ListItem Value="2">Tanpa Permohonan</asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator36" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="DDL_JenisBatal" ErrorMessage="Sila Pilih" ForeColor="Red" ValidationGroup="updateForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <asp:Panel ID="pnlbatal3" runat="server" Visible="false">
                                                <label>Sebab Pembatalan</label>
                                                <asp:DropDownList ID="DDL_SebabBatal1" Text='<%# Bind("SebabBatalPerm") %>' CssClass="form-control select2" runat="server"
                                                    DataSourceID="SqlDataSourceSebab1" DataTextField="name" DataValueField="id">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource runat="server" ID="SqlDataSourceSebab1" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                    SelectCommand="SELECT NULL AS id, '-- Sila Pilih --' AS name UNION ALL SELECT id, name 
                                                        FROM TBL_LOOKUPS WHERE lookupgrp_id = 10002 AND status = 1"></asp:SqlDataSource>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator32" runat="server" CssClass="cssRequiredField"
                                                    ControlToValidate="DDL_SebabBatal1" ErrorMessage="Sila Pilih" ForeColor="Red" ValidationGroup="updateForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                            </asp:Panel>

                                            <asp:Panel ID="pnlbatal4" runat="server" Visible="false">
                                                <label>Sebab Pembatalan</label>
                                                <asp:DropDownList ID="DDL_SebabBatal2" Text='<%# Bind("SebabBatalTanpaPerm") %>' CssClass="form-control select2" runat="server"
                                                    DataSourceID="SqlDataSourceSebab2" DataTextField="name" DataValueField="id">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource runat="server" ID="SqlDataSourceSebab2" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                    SelectCommand="SELECT NULL AS id, '-- Sila Pilih --' AS name UNION ALL SELECT id, name 
                                                        FROM TBL_LOOKUPS WHERE lookupgrp_id = 10003 AND status = 1"></asp:SqlDataSource>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator37" runat="server" CssClass="cssRequiredField"
                                                    ControlToValidate="DDL_SebabBatal2" ErrorMessage="Sila Pilih" ForeColor="Red" ValidationGroup="updateForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                            </asp:Panel>

                                        </div>
                                    </div>

                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Tindakan Pembatalan</label>
                                            <asp:DropDownList ID="DDL_TindakanBatal" Text='<%# Bind("TindakanBatal") %>' CssClass="form-control select2" runat="server"
                                                DataSourceID="SqlDataSourceTindakan" DataTextField="name" DataValueField="id">
                                            </asp:DropDownList>
                                            <asp:SqlDataSource runat="server" ID="SqlDataSourceTindakan" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                SelectCommand="SELECT NULL AS id, '-- Sila Pilih --' AS name UNION ALL SELECT id, name 
                                                    FROM TBL_LOOKUPS WHERE lookupgrp_id = 10005 AND status = 1"></asp:SqlDataSource>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator35" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="DDL_TindakanBatal" ErrorMessage="Sila Pilih" ForeColor="Red" ValidationGroup="updateForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                </div>
                            </asp:Panel>

                        </div>
                        <div class="card-footer">
                            <asp:LinkButton runat="server" CssClass="btn btn-warning" ValidationGroup="updateForm" Text="Kemaskini" CommandName="Update" ID="UpdateFormButton" CausesValidation="True" />
                            <asp:LinkButton runat="server" CssClass="btn btn-warning" Visible='<%# If(Eval("StatusID") = 0, True, False) %>' ValidationGroup="updateForm" Text="Hantar" ID="SubmitApproval" OnCommand="OnClickBtnSubmit" CausesValidation="True" OnClientClick="return confirm('Hantar ke jabatan agensi sekarang?');" />
                            <asp:LinkButton runat="server" Text="Kembali" ID="BackButton" CausesValidation="False" CssClass-="btn btn-default" OnClick="BackButton_Click" />
                        </div>
                    </div>
                </EditItemTemplate>

                <InsertItemTemplate>
                    <div class="card card-primary">
                        <div class="card-header">
                            <h3 class="card-title">Kunci Masuk Permohonan</h3>
                        </div>
                        <!-- /.card-header -->
                        <div class="card-body">
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

                            <div class="row">

                                <div class="col-md-6">

                                    <div class="form-group">
                                        <label>Pemohon:</label>
                                        <div class="row">
                                            <div class="col">
                                                <asp:DropDownList ID="ddl_Pemohon" CssClass="form-control select2" runat="server" OnSelectedIndexChanged="ddl_Pemohon_SelectedIndexChanged"
                                                    DataSourceID="SqlDataSourcePemohon" DataTextField="PemohonDesc" DataValueField="Pemohon_ID" AutoPostBack="true">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource runat="server" ID="SqlDataSourcePemohon" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                    SelectCommand="SELECT NULL AS Pemohon_ID, '-- Sila Pilih --' AS PemohonDesc UNION ALL SELECT Pemohon_ID,  Pemohon_ICNo + ' - ' + Pemohon_Name AS PemohonDesc FROM LESEN_Pemohon WHERE Pemohon_IsActive = 1"></asp:SqlDataSource>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" CssClass="cssRequiredField"
                                                    ControlToValidate="ddl_Pemohon" ErrorMessage="Sila Pilih" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                            </div>
                                            <div class="col">
                                                <asp:HyperLink runat="server" NavigateUrl="~/lesen/applicantregister.aspx?p_Id=3354&m_Id=3355" CssClass="btn btn-default">Daftar Pemohon</asp:HyperLink>

                                            </div>

                                        </div>

                                    </div>

                                </div>
                            </div>

                            <asp:Panel runat="server" ID="pnlpemohon" Visible="false">
                                <div class="row">

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Pemohon ID</label>
                                            <asp:TextBox ID="TB_PemohonID" runat="server" Enabled="false" Text='<%# Bind("Permohonan_PemohonID") %>' CssClass="form-control" />
                                        </div>
                                    </div>
                                </div>

                                <div class="row">

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Nama Pemohon</label>
                                            <asp:TextBox ID="TB_Name" runat="server" Enabled="false" Text="NULL" CssClass="form-control" />
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Warganegara</label>
                                            <asp:TextBox ID="TB_Nat" runat="server" Enabled="false" Text="NULL" CssClass="form-control" />
                                        </div>
                                    </div>

                                </div>

                                <div class="row">

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Alamat</label>
                                            <asp:TextBox ID="TB_Address" Enabled="false" runat="server"
                                                Text="NULL" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Catatan</label>
                                            <asp:TextBox ID="TB_Remarks" Enabled="false" runat="server"
                                                Text="NULL" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                                        </div>
                                    </div>

                                </div>
                            </asp:Panel>

                            <hr style="border: 1px solid gray;" />

                            <div class="row">

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Tarikh Mohon</label>
                                        <asp:TextBox ID="TB_TarikhMohon" runat="server"
                                            Text='<%# Bind("TarikhMohon", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="form-control" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" CssClass="cssRequiredField"
                                            ControlToValidate="TB_TarikhMohon" ErrorMessage="Sila Pilih" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>

                                    </div>
                                </div>

                                <div class="col-md-8">
                                    <div class="form-group">
                                        <label>Jenis Lesen/Permit</label>
                                        <asp:DropDownList ID="ddlItems" runat="server" DataSourceID="SqlDataSource1" CssClass="form-control select2"
                                            DataTextField="JenisLesen_Description" DataValueField="JenisLesen_ID" AutoPostBack="true"
                                            OnSelectedIndexChanged="ddlItems_SelectedIndexChanged" AppendDataBoundItems="true">
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

                                    <div class="tag-container" style="display: flex; gap: 10px; flex-wrap: wrap;">
                                        <asp:Repeater ID="rptSelectedItems" runat="server" OnItemCommand="rptSelectedItems_ItemCommand">
                                            <ItemTemplate>
                                                <div style="background: #e1e1e1; padding: 5px 10px; border-radius: 15px; display: flex; align-items: center; border: 1px solid #ccc;">
                                                    <span style="margin-right: 8px;"><%# Eval("ItemText") %></span>
                                                    <asp:LinkButton ID="btnRemove" runat="server" 
                                                        CommandName="Remove" 
                                                        CommandArgument='<%# Eval("ItemValue") %>' 
                                                        Style="color: red; text-decoration: none; font-weight: bold;">&times;</asp:LinkButton>
                                                </div>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </div>

                                </div>

                            </div>

                            <br />

                            <%--# Perniagaan Berisiko dan tidak berisiko #--%>
                            <asp:Panel ID="pnlesen1" runat="server" Visible="False">

                                <div class="row">

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Nama Syarikat/Sediada</label>
                                            <asp:TextBox ID="TB_NamaSyarikat" runat="server"
                                                Text='<%# Bind("NamaSyarikat") %>' CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_NamaSyarikat" ErrorMessage="Sila Isi" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>

                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>No Pendaftaran</label>
                                            <asp:TextBox ID="TB_NoPendaftaran" runat="server"
                                                Text='<%# Bind("NoPendaftaran") %>' CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_NoPendaftaran" ErrorMessage="Sila Isi" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>

                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>No Akaun Lesen</label>
                                            <asp:TextBox ID="TB_NoAkaun" runat="server"
                                                Text='<%# Bind("NoAkaun") %>' CssClass="form-control" />

                                        </div>
                                    </div>

                                </div>

                                <div class="row">

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Alamat Premis/Sediada</label>
                                            <asp:TextBox ID="TB_AlamatPremis" runat="server"
                                                Text='<%# Bind("AlamatPremis") %>' TextMode="MultiLine" Rows="3" CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator10" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_AlamatPremis" ErrorMessage="Sila Isi" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>

                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Jenis Perniagaan/Sediada</label>
                                            <asp:TextBox ID="TB_JenisPerniagaan" runat="server"
                                                Text='<%# Bind("JenisPerniagaan") %>' CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator11" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_JenisPerniagaan" ErrorMessage="Sila Isi" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>

                                        </div>
                                    </div>

                                </div>

                                <%--# Tukar Pemilik #--%>
                                <asp:Panel ID="pnlesen1b" runat="server" Visible="False">

                                    <div class="row">

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Nama Pemilik Baru</label>
                                                <asp:TextBox ID="TB_PemilikBaru" runat="server"
                                                    Text='<%# Bind("PemilikBaru") %>' CssClass="form-control" />
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator12" runat="server" CssClass="cssRequiredField"
                                                    ControlToValidate="TB_PemilikBaru" ErrorMessage="Sila Isi" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>

                                            </div>
                                        </div>

                                    </div>
                                </asp:Panel>

                                <%--# Batal #--%>
                                <asp:Panel ID="pnlbatal" runat="server" Visible="False">
                                    <div class="row">

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label>Tarikh Batal</label>
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
                                                <label>Alamat Baru</label>
                                                <asp:TextBox ID="TB_AlamatBaru" runat="server"
                                                    Text='<%# Bind("AlamatBaru") %>' TextMode="MultiLine" Rows="3" CssClass="form-control" />
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator13" runat="server" CssClass="cssRequiredField"
                                                    ControlToValidate="TB_AlamatBaru" ErrorMessage="Sila Isi" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>

                                            </div>
                                        </div>

                                    </div>
                                </asp:Panel>

                                <%--# Tambah Jenis Perniagaan #--%>
                                <asp:Panel ID="pnlesen1d" runat="server" Visible="False">

                                    <div class="row">

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Jenis Perniagaan Tambahan</label>
                                                <asp:TextBox ID="TB_JenisPerniagaanBaru" runat="server"
                                                    Text='<%# Bind("JenisPerniagaanBaru") %>' CssClass="form-control" />
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator14" runat="server" CssClass="cssRequiredField"
                                                    ControlToValidate="TB_JenisPerniagaanBaru" ErrorMessage="Sila Isi" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>

                                            </div>
                                        </div>

                                    </div>
                                </asp:Panel>

                                <%--# Tukar Nama Syarikat #--%>
                                <asp:Panel ID="pnlesen1e" runat="server" Visible="False">

                                    <div class="row">

                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Nama Baru Syarikat</label>
                                                <asp:TextBox ID="TB_NamaBaruSyarikat" runat="server"
                                                    Text='<%# Bind("NamaBaruSyarikat") %>' CssClass="form-control" />
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator15" runat="server" CssClass="cssRequiredField"
                                                    ControlToValidate="TB_NamaBaruSyarikat" ErrorMessage="Sila Isi" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>

                                            </div>
                                        </div>

                                    </div>
                                </asp:Panel>

                            </asp:Panel>

                            <%--# Banting #--%>
                            <asp:Panel ID="pnlesen6" runat="server" Visible="False">

                                <div class="row">

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Nama Syarikat Kontraktor Pemasang Iklan</label>
                                            <asp:TextBox ID="TB_KontraktorIklan" runat="server"
                                                Text='<%# Bind("KontraktorIklan") %>' CssClass="form-control" />

                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>No Telefon Syarikat Kontraktor</label>
                                            <asp:TextBox ID="TB_NoTelKontraktor" runat="server"
                                                Text='<%# Bind("NoTelKontraktor") %>' CssClass="form-control" />

                                        </div>
                                    </div>

                                </div>

                                <div class="row">

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Ukuran (Kaki)</label>
                                            <asp:TextBox ID="TB_UkuranBanting" runat="server"
                                                Text='<%# Bind("UkuranBanting") %>' placeholder="Contoh: 5x10" CssClass="form-control" />

                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Bilangan Banting/Sepanduk</label>
                                            <asp:TextBox ID="TB_BilBanting" runat="server"
                                                Text='<%# Bind("BilBanting") %>' CssClass="form-control" />

                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Tarikh Mula Pemasangan</label>
                                            <asp:TextBox ID="TB_TarikhBanting1" runat="server"
                                                Text='<%# Bind("TarikhBanting1", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="form-control" />
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Tarikh Akhir Pemasangan</label>
                                            <asp:TextBox ID="TB_TarikhBanting2" runat="server"
                                                Text='<%# Bind("TarikhBanting2", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="form-control" />
                                        </div>
                                    </div>

                                </div>

                                 <div class="row">

                                     <div class="col-md-6">
                                         <div class="form-group">
                                             <label>Lokasi/Tempat Pemasagan</label>
                                             <asp:TextBox ID="TB_LokasiBanting" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />
                                         </div>
                                     </div>

                                     <div class="col-md-2">
                                        <div class="form-group">
                                            <label> </label>
                                            <asp:LinkButton ID="btnAddLokasi" runat="server" CssClass="btn btn-primary" Text="Tambah" OnClick="btnAddLokasi_Click" />
                                        </div>
                                    </div>

                                 </div>

                                 <div class="row">
                                    <div class="col-md-8">
                                        <asp:GridView ID="gvLokasiList" runat="server" HeaderStyle-ForeColor="Black" CssClass="table table-bordered" AutoGenerateColumns="False" 
                                            ShowHeaderWhenEmpty="true" EmptyDataText="Senarai kosong." OnRowDeleting="gvLokasiList_RowDeleting">
                                            <Columns>
                                                <asp:BoundField DataField="No" HeaderText="No." />
                                                <asp:BoundField DataField="Lokasi" HeaderText="Lokasi/Tempat Pemasangan" />
                                                <asp:TemplateField>
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="btnRemove" runat="server"  
                                                            CommandName="Delete" CssClass="btn btn-danger btn-sm">&times;</asp:LinkButton>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>No Resit</label>
                                            <asp:TextBox ID="TB_NoResit1" runat="server"
                                                Text='<%# Bind("NoResitBanting") %>' CssClass="form-control" />

                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>No Siri Stiker</label>
                                            <asp:TextBox ID="TB_NoSiriStiker" runat="server"
                                                Text='<%# Bind("NoSiriStiker") %>' CssClass="form-control" />

                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Tarikh</label>
                                            <asp:TextBox ID="TB_TarikhBanting3" runat="server"
                                                Text='<%# Bind("TarikhBanting3", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="form-control" />

                                        </div>
                                    </div>

                                </div>

                            </asp:Panel>

                            <%--# Papan iklan, Billboard #--%>
                            <asp:Panel ID="pnlesen1a" runat="server" Visible="False">

                                <div class="row">

                                    <div class="col-md-2">
                                        <div class="form-group">
                                            <label>Saiz Iklan (cm)</label>
                                            <asp:TextBox ID="TB_SaizIklan1" placeholder="Contoh:10x5" runat="server" CssClass="form-control" />
                                        </div>
                                    </div>
                                     <div class="col-md-2">
                                         <div class="form-group">
                                             <label>Iklan Bercahaya</label>
                                             <asp:DropDownList ID="DDL_Iklan1" runat="server"
                                                 CssClass="form-control select2">
                                                 <asp:ListItem Value="">-- Sila Pilih --</asp:ListItem>
                                                 <asp:ListItem Value="Bercahaya">Ya</asp:ListItem>
                                                 <asp:ListItem Value="Tidak Bercahaya">Tidak</asp:ListItem>
                                             </asp:DropDownList>
                                         </div>
                                     </div>
                                    <div class="col-md-2">
                                        <div class="form-group">
                                            <label>Bil. Unit</label>
                                            <div class="row">
                                                <div class="col">
                                                    <asp:TextBox ID="TB_UnitIklan1" runat="server" CssClass="form-control" />
                                                </div>
                                                <div class="col">
                                                    <asp:LinkButton ID="btnAddIklan" runat="server" CssClass="btn btn-primary" Text="Tambah" OnClick="btnAddIklan_Click" />
                                    
                                                </div>
                                            </div>
                                            
                                        </div>
                                    </div>

                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <asp:GridView ID="gvIklanList" runat="server" HeaderStyle-ForeColor="Black" CssClass="table table-bordered" AutoGenerateColumns="False" 
                                            ShowHeaderWhenEmpty="true" EmptyDataText="Senarai kosong." OnRowDeleting="gvIklanList_RowDeleting">
                                            <Columns>
                                                <asp:BoundField DataField="SaizIklan" HeaderText="Saiz Iklan (cm)" />
                                                <asp:BoundField DataField="Bercahaya" HeaderText="Bercahaya/Tidak Bercahaya" />
                                                <asp:BoundField DataField="Unit" HeaderText="Bil. Unit" />
                                                <asp:TemplateField>
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="btnRemove" runat="server"  
                                                            CommandName="Delete" CssClass="btn btn-danger btn-sm">&times;</asp:LinkButton>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </div>
                                </div>

                            </asp:Panel>

                            <%--#  Billboard #--%>
                            <asp:Panel ID="pnlbillboard" runat="server" Visible="False">

                                <div class="row">

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Lokasi Billboard</label>
                                            <asp:TextBox ID="TB_BillboardLokasi" runat="server"
                                                Text='<%# Bind("BillboardLokasi") %>' TextMode="MultiLine" Rows="3" CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator20" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_BillboardLokasi" ErrorMessage="Sila Isi" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>

                                        </div>
                                    </div>

                                </div>

                            </asp:Panel>

                            <%--# Pasar Lambak #--%>
                            <asp:Panel ID="pnlesen2" runat="server" Visible="False">

                                <div class="row">

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Lokasi Pasar #1</label>
                                            <asp:TextBox ID="TB_LokasiPasar1" runat="server"
                                                Text='<%# Bind("LokasiPasar1") %>' TextMode="MultiLine" Rows="3" CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator16" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_LokasiPasar1" ErrorMessage="Sila Isi" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>

                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Lokasi Pasar #2</label>
                                            <asp:TextBox ID="TB_LokasiPasar2" runat="server"
                                                Text='<%# Bind("LokasiPasar2") %>' TextMode="MultiLine" Rows="3" CssClass="form-control" />

                                        </div>
                                    </div>

                                </div>

                                <div class="row">

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Lokasi Pasar #3</label>
                                            <asp:TextBox ID="TB_LokasiPasar3" runat="server"
                                                Text='<%# Bind("LokasiPasar3") %>' TextMode="MultiLine" Rows="3" CssClass="form-control" />

                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Jenis Pasar</label>
                                            <asp:DropDownList ID="DDL_JenisPasar" Text='<%# Bind("JenisPasar") %>' runat="server" OnSelectedIndexChanged="DDL_JenisPasar_SelectedIndexChanged"
                                                CssClass="form-control select2">
                                                <asp:ListItem Value="">-- Sila Pilih --</asp:ListItem>
                                                <asp:ListItem>Pasar Pagi</asp:ListItem>
                                                <asp:ListItem>Pasar Malam</asp:ListItem>
                                                <asp:ListItem>Pasar Lambak</asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator17" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="DDL_JenisPasar" ErrorMessage="Sila Pilih" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>

                                        </div>
                                    </div>

                                </div>

                                <div class="row">

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Jenis Perniagaan</label>
                                            <asp:TextBox ID="TB_JenisPerniagaanPasar" runat="server"
                                                Text='<%# Bind("JenisPerniagaanPasar") %>' CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator18" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_JenisPerniagaanPasar" ErrorMessage="Sila Isi" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Jumlah Petak/Tapak/Lot</label>
                                            <asp:TextBox ID="TB_JumlahPetak" runat="server"
                                                Text='<%# Bind("JumlahPetak") %>' CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator19" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_JumlahPetak" ErrorMessage="Sila Isi" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                </div>

                            </asp:Panel>

                            <%--# Anjing #--%>
                            <asp:Panel ID="pnlesen3" runat="server" Visible="False">

                                <div class="row">

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Alamat lokasi</label>
                                            <asp:TextBox ID="TB_AnjingAlamat" runat="server"
                                                Text='<%# Bind("AnjingAlamat") %>' TextMode="MultiLine" Rows="3" CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_AnjingAlamat" ErrorMessage="Sila Isi" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Jenis Premis</label>
                                            <asp:DropDownList ID="DDL_AnjingJenisPremis" Text='<%# Bind("AnjingJenisPremis") %>' CssClass="form-control select2" runat="server"
                                                DataSourceID="SqlDataSourceAnjingJenisPremis" DataTextField="name" DataValueField="id">
                                            </asp:DropDownList>
                                            <asp:SqlDataSource runat="server" ID="SqlDataSourceAnjingJenisPremis" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                SelectCommand="SELECT NULL AS id, '-- Sila Pilih --' AS name UNION ALL SELECT id, name 
                                                        FROM TBL_LOOKUPS WHERE lookupgrp_id = 10001 AND status = 1"></asp:SqlDataSource>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="DDL_AnjingJenisPremis" ErrorMessage="Sila Pilih" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                </div>

                                <div class="row">

                                    <div class="col-md-2">
                                        <div class="form-group">
                                            <label>Jenis Baka</label>
                                            <asp:DropDownList ID="DDL_BakaAnjing1" CssClass="form-control select2" runat="server"
                                                DataSourceID="SqlDataSourceAnjingBaka1" DataTextField="name" DataValueField="id">
                                            </asp:DropDownList>
                                            <asp:SqlDataSource runat="server" ID="SqlDataSourceAnjingBaka1" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                SelectCommand="SELECT NULL AS id, '-- Sila Pilih --' AS name UNION ALL SELECT id, name 
                                                        FROM TBL_LOOKUPS WHERE lookupgrp_id = 10004 AND status = 1"></asp:SqlDataSource>
                                        </div>
                                    </div>

                                    <div class="col-md-2">
                                        <div class="form-group">
                                            <label>Bilangan anjing jantan</label>
                                            <asp:TextBox ID="TB_Jantan1" runat="server" TextMode="Number" CssClass="form-control" />
                                        </div>
                                    </div>

                                    <div class="col-md-2">
                                        <div class="form-group">
                                            <label>Bilangan anjing betina</label>
                                            <asp:TextBox ID="TB_Betina1" runat="server" TextMode="Number" CssClass="form-control" />
                                        </div>
                                    </div>

                                    <div class="col-md-2">
                                        <div class="form-group">
                                            <label>Bilangan anjing jantan mandul</label>
                                            <asp:TextBox ID="TB_JantanMandul1" runat="server" TextMode="Number" CssClass="form-control" />
                                        </div>
                                    </div>

                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Bilangan anjing betina mandul</label>
                                            <div class="row">
                                                <div class="col">
                                                    <asp:TextBox ID="TB_BetinaMandul1" runat="server" TextMode="Number" CssClass="form-control" />
                                                </div>
                                                <div class="col">
                                                    <asp:LinkButton ID="btnAddAnjing" runat="server" CssClass="btn btn-primary" Text="Tambah" OnClick="btnAddAnjing_Click" />
                                    
                                                </div>

                                            </div>
                                            
                                        </div>
                                    </div>

                                </div>

                                <div class="row">
                                    <div class="col-md-12">
                                        <asp:GridView ID="gvAnjingList" runat="server" HeaderStyle-ForeColor="Black" CssClass="table table-bordered" AutoGenerateColumns="False" 
                                            ShowHeaderWhenEmpty="true" EmptyDataText="Senarai kosong." OnRowDeleting="gvAnjingList_RowDeleting">
                                            <Columns>
                                                <asp:BoundField DataField="Baka" HeaderText="Baka Anjing" />
                                                <asp:BoundField DataField="Jantan" HeaderText=" Bil. Jantan" />
                                                <asp:BoundField DataField="Betina" HeaderText="Bil. Betina" />
                                                <asp:BoundField DataField="JantanMandul" HeaderText="Bil. Jantan Mandul" />
                                                <asp:BoundField DataField="BetinaMandul" HeaderText="Bil. Betina Mandul" />
                                                <asp:TemplateField>
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="btnRemove" runat="server"  
                                                            CommandName="Delete" CssClass="btn btn-danger btn-sm">&times;</asp:LinkButton>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </div>
                                </div>

                            </asp:Panel>

                            <%--# Penjaja #--%>
                            <asp:Panel ID="pnlesen4" runat="server" Visible="False">

                                <div class="row">

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Alamat aktiviti penjajaan</label>
                                            <asp:TextBox ID="TB_AlamatPenjajaan" runat="server"
                                                Text='<%# Bind("AlamatPenjajaan") %>' TextMode="MultiLine" Rows="3" CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator21" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_AlamatPenjajaan" ErrorMessage="Sila Isi" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>

                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Jenis Perniagaan</label>
                                            <asp:TextBox ID="TB_JenisPerniagaanPenjaja" runat="server"
                                                Text='<%# Bind("JenisPerniagaanPenjaja") %>' CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator22" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_JenisPerniagaanPenjaja" ErrorMessage="Sila Isi" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>

                                        </div>
                                    </div>

                                </div>

                            </asp:Panel>

                            <%--# Ekspo #--%>
                            <asp:Panel ID="pnlesen5" runat="server" Visible="False">

                                <div class="row">

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Nama Penganjur</label>
                                            <asp:TextBox ID="TB_PenganjurEkspo" runat="server"
                                                Text='<%# Bind("PenganjurEkspo") %>' CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator23" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_PenganjurEkspo" ErrorMessage="Sila Isi" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>

                                        </div>
                                    </div>


                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Nama Aktiviti/Program</label>
                                            <asp:TextBox ID="TB_NamaEkspo" runat="server"
                                                Text='<%# Bind("NamaEkspo") %>' CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator24" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_NamaEkspo" ErrorMessage="Sila Isi" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>

                                        </div>
                                    </div>

                                </div>

                                <div class="row">

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Lokasi</label>
                                            <asp:TextBox ID="TB_LokasiEkspo" runat="server"
                                                Text='<%# Bind("LokasiEkspo") %>' TextMode="MultiLine" Rows="3" CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator25" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_LokasiEkspo" ErrorMessage="Sila Isi" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>

                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>No. Tel.</label>
                                            <asp:TextBox ID="TB_NoTel" runat="server"
                                                Text='<%# Bind("NoTelEkspo") %>' CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator26" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_NoTel" ErrorMessage="Sila Isi" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>

                                        </div>
                                    </div>

                                </div>

                                <div class="row">

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Tarikh Mula</label>
                                            <asp:TextBox ID="TB_TarikhEkspo1" runat="server"
                                                Text='<%# Bind("TarikhEkspo1", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator27" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_TarikhEkspo1" ErrorMessage="Sila Pilih" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>

                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Masa Mula</label>
                                            <asp:TextBox ID="TB_MasaEkspo1" runat="server"
                                                Text='<%# Bind("MasaEkspo1") %>' TextMode="Time" CssClass="form-control" />
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Tarikh Akhir</label>
                                            <asp:TextBox ID="TB_TarikhEkspo2" runat="server"
                                                Text='<%# Bind("TarikhEkspo2", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator28" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_TarikhEkspo2" ErrorMessage="Sila Pilih" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>

                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Masa Akhir</label>
                                            <asp:TextBox ID="TB_MasaEkspo2" runat="server"
                                                Text='<%# Bind("MasaEkspo2") %>' TextMode="Time" CssClass="form-control" />

                                        </div>
                                    </div>

                                </div>

                            </asp:Panel>

                            <asp:Panel ID="pnlrujukan" runat="server" Visible="False">
                                <hr style="border: 1px solid gray;" />
                                <div class="row">

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>No Rujukan</label>
                                            <asp:TextBox ID="TB_Rujukan" runat="server"
                                                Text='<%# Bind("Rujukan") %>' CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator29" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_Rujukan" ErrorMessage="Sila Isi" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>

                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>No Akaun Cukai</label>
                                            <asp:TextBox ID="TB_NoAkaunCukai" runat="server"
                                                Text='<%# Bind("NoAkaunCukai") %>' CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator33" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_NoAkaunCukai" ErrorMessage="Sila Isi" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>

                                        </div>
                                    </div>

                                    <div class="col-md-2">
                                        <div class="form-group">
                                            <asp:Label runat="server" ForeColor="DarkRed" Font-Bold="true">Kelulusan 24 jam?></asp:Label>
                                            <asp:CheckBox ID="CB_24h" Checked='<%# Bind("Is24jam") %>' runat="server" />
                                        </div>
                                    </div>

                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Lokasi Fail</label>
                                            <asp:TextBox ID="TB_Remarks1" runat="server" TextMode="MultiLine" Rows="2"
                                                Text='<%# Bind("RemarksFail") %>' CssClass="form-control" />

                                        </div>
                                    </div>

                                </div>

                                <div class="row">

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Ada Deposit?</label>
                                            <asp:CheckBox ID="CB_Deposit" runat="server" OnCheckedChanged="CB_Deposit_CheckedChanged" AutoPostBack="true" />
                                        </div>
                                    </div>

                                </div>
                            </asp:Panel>

                            <asp:Panel ID="pnldeposit" runat="server" Visible="False">

                                <div class="row">

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Amaun deposit (RM)</label>
                                            <asp:TextBox ID="TB_Depo" runat="server"
                                                Text='<%# Bind("DepositAmount") %>' TextMode="Number" placeholder="00.00" CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator34" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TB_Depo" ErrorMessage="Sila Isi" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Tarikh bayar deposit</label>
                                            <asp:TextBox ID="TB_TarikhDepo" runat="server"
                                                Text='<%# Bind("DepositDate", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="form-control" />
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>No Resit</label>
                                            <asp:TextBox ID="TB_NoResit" runat="server"
                                                Text='<%# Bind("DepositResitNo") %>' CssClass="form-control" />

                                        </div>
                                    </div>

                                </div>

                            </asp:Panel>

                            <asp:Panel ID="pnldeposit1" runat="server" Visible="False">

                                <div class="row">

                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Amaun Pemulangan Wang Amanah (RM)</label>
                                            <asp:TextBox ID="TB_DepoPulang" runat="server"
                                                Text='<%# Bind("DepositPulangAmount") %>' TextMode="Number" placeholder="00.00" CssClass="form-control" />
                                        </div>
                                    </div>

                                </div>

                            </asp:Panel>

                            <asp:Panel ID="pnlbatal1" runat="server" Visible="false">
                                <br />
                                <div class="row">
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <asp:Label runat="server" ForeColor="DarkRed" Font-Bold="true">Pembatalan Permit/Lesen?</asp:Label>
                                            <asp:CheckBox ID="CB_IsBatal" Checked='<%# Bind("IsBatal") %>' runat="server" OnCheckedChanged="CB_IsBatal_CheckedChanged" AutoPostBack="true" />
                                        </div>
                                    </div>
                                </div>
                            </asp:Panel>

                            <asp:Panel ID="pnlbatal2" runat="server" Visible="false">

                                <div class="row">

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Jenis Pembatalan</label>
                                            <asp:DropDownList ID="DDL_JenisBatal" runat="server" Text='<%# Bind("JenisBatal") %>' OnSelectedIndexChanged="DDL_JenisBatal_SelectedIndexChanged" AutoPostBack="true"
                                                CssClass="form-control select2">
                                                <asp:ListItem Value="">-- Sila Pilih --</asp:ListItem>
                                                <asp:ListItem Value="1">Dengan Permohonan</asp:ListItem>
                                                <asp:ListItem Value="2">Tanpa Permohonan</asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator36" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="DDL_JenisBatal" ErrorMessage="Sila Pilih" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <asp:Panel ID="pnlbatal3" runat="server" Visible="false">
                                                <label>Sebab Pembatalan</label>
                                                <asp:DropDownList ID="DDL_SebabBatal1" Text='<%# Bind("SebabBatalPerm") %>' CssClass="form-control select2" runat="server"
                                                    DataSourceID="SqlDataSourceSebab1" DataTextField="name" DataValueField="id">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource runat="server" ID="SqlDataSourceSebab1" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                    SelectCommand="SELECT NULL AS id, '-- Sila Pilih --' AS name UNION ALL SELECT id, name 
                                                        FROM TBL_LOOKUPS WHERE lookupgrp_id = 10002 AND status = 1"></asp:SqlDataSource>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator38" runat="server" CssClass="cssRequiredField"
                                                    ControlToValidate="DDL_SebabBatal1" ErrorMessage="Sila Pilih" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                            </asp:Panel>

                                            <asp:Panel ID="pnlbatal4" runat="server" Visible="false">
                                                <label>Sebab Pembatalan</label>
                                                <asp:DropDownList ID="DDL_SebabBatal2" Text='<%# Bind("SebabBatalTanpaPerm") %>' CssClass="form-control select2" runat="server"
                                                    DataSourceID="SqlDataSourceSebab2" DataTextField="name" DataValueField="id">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource runat="server" ID="SqlDataSourceSebab2" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                    SelectCommand="SELECT NULL AS id, '-- Sila Pilih --' AS name UNION ALL SELECT id, name 
                                                        FROM TBL_LOOKUPS WHERE lookupgrp_id = 10003 AND status = 1"></asp:SqlDataSource>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator37" runat="server" CssClass="cssRequiredField"
                                                    ControlToValidate="DDL_SebabBatal2" ErrorMessage="Sila Pilih" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                            </asp:Panel>

                                        </div>
                                    </div>

                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Tindakan Pembatalan</label>
                                            <asp:DropDownList ID="DDL_TindakanBatal" Text='<%# Bind("TindakanBatal") %>' CssClass="form-control select2" runat="server"
                                                DataSourceID="SqlDataSourceTindakan" DataTextField="name" DataValueField="id">
                                            </asp:DropDownList>
                                            <asp:SqlDataSource runat="server" ID="SqlDataSourceTindakan" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                SelectCommand="SELECT NULL AS id, '-- Sila Pilih --' AS name UNION ALL SELECT id, name 
                                                    FROM TBL_LOOKUPS WHERE lookupgrp_id = 10005 AND status = 1"></asp:SqlDataSource>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator35" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="DDL_TindakanBatal" ErrorMessage="Sila Pilih" ForeColor="Red" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                     </div>
                                </div>
                            </asp:Panel>

                        </div>
                        <div class="card-footer">
                            <asp:LinkButton runat="server" CssClass="btn btn-primary" ValidationGroup="insertForm" Text="Simpan" CommandName="Insert" ID="LinkButton1" CausesValidation="True" />
                            &nbsp;<asp:LinkButton runat="server" Text="Kembali" ID="BackButton" CausesValidation="False" CssClass-="btn btn-default" OnClick="BackButton_Click" />
                        </div>
                    </div>
                </InsertItemTemplate>
                <ItemTemplate></ItemTemplate>
            </asp:FormView>

            <asp:SqlDataSource runat="server" ID="SqlDataSourceForm" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                InsertCommand="INSERT INTO LESEN_Permohonan(JenisLesenDescList, JenisLesenIdList, SaizIklanList, CahayaIklanList, UnitIklanList, LokasiList, 
                        Permohonan_PemohonID, TarikhMohon, JenisLesen_ID, StatusID, NamaSyarikat, NoPendaftaran, NoAkaun, AlamatPremis, JenisPerniagaan,
                        PemilikBaru, AlamatBaru, JenisPerniagaanBaru, NamaBaruSyarikat, BillboardLokasi, LokasiPasar1, LokasiPasar2, LokasiPasar3, JenisPasar,
                        JenisPerniagaanPasar, JumlahPetak, AnjingAlamat, AnjingJenisPremis, AlamatPenjajaan, JenisPerniagaanPenjaja, 
                        TarikhBatal, PenganjurEkspo, NamaEkspo, LokasiEkspo, NoTelEkspo, TarikhEkspo1, TarikhEkspo2, MasaEkspo1, MasaEkspo2, 
                        KontraktorIklan, NoTelKontraktor, UkuranBanting, BilBanting, TarikhBanting1, TarikhBanting2, NoResitBanting, NoSiriStiker, TarikhBanting3, 
                        Rujukan, NoAkaunCukai, DepositAmount, DepositDate, DepositResitNo, DepositPulangAmount, 
                        Is24jam, IsBatal, JenisBatal, SebabBatalPerm, SebabBatalTanpaPerm, TindakanBatal, IsPulang, IsSuratKelulusanFail, IsSuratPembatalanFail, IsSuratPemeriksaanFail, RemarksFail, CreatorID, CreatedDt, LastModID, LastModDt) 
                        VALUES (@JenisLesenDescList, @JenisLesenIdList, @SaizIklanList, @CahayaIklanList, @UnitIklanList, @LokasiList, 
                        @Permohonan_PemohonID, @TarikhMohon, 0, 0, @NamaSyarikat, @NoPendaftaran, @NoAkaun, @AlamatPremis, @JenisPerniagaan, @PemilikBaru, @AlamatBaru,
                        @JenisPerniagaanBaru, @NamaBaruSyarikat, @BillboardLokasi, @LokasiPasar1, @LokasiPasar3, @LokasiPasar3, @JenisPasar, @JenisPerniagaanPasar,
                        @JumlahPetak, @AnjingAlamat, @AnjingJenisPremis, @AlamatPenjajaan, @JenisPerniagaanPenjaja, @TarikhBatal, 
                        @PenganjurEkspo, @NamaEkspo, @LokasiEkspo, @NoTelEkspo, @TarikhEkspo1, @TarikhEkspo2, @MasaEkspo1, @MasaEkspo2, 
                        @KontraktorIklan, @NoTelKontraktor, @UkuranBanting, @BilBanting, @TarikhBanting1, @TarikhBanting2, @NoResitBanting, @NoSiriStiker, @TarikhBanting3,
                        @Rujukan, @NoAkaunCukai, @DepositAmount, @DepositDate, @DepositResitNo, @DepositPulangAmount, 
                        @Is24jam, @IsBatal, @JenisBatal, @SebabBatalPerm, @SebabBatalTanpaPerm, @TindakanBatal, 0, 0, 0, 0, @RemarksFail, @CreatorId, GETDATE(), @CreatorId, GETDATE()); SELECT @Permohonan_ID = SCOPE_IDENTITY();"
                SelectCommand="SELECT * FROM LESEN_Permohonan WHERE Permohonan_ID = @Permohonan_ID"
                UpdateCommand="UPDATE LESEN_Permohonan SET JenisLesenDescList = @JenisLesenDescList, JenisLesenIdList = @JenisLesenIdList, SaizIklanList = @SaizIklanList, CahayaIklanList = @CahayaIklanList, UnitIklanList = @UnitIklanList, LokasiList = @LokasiList, 
                        Permohonan_PemohonID = @Permohonan_PemohonID, TarikhMohon = @TarikhMohon, StatusID = @StatusID, NamaSyarikat = @NamaSyarikat, NoPendaftaran = @NoPendaftaran, NoAkaun = @NoAkaun, AlamatPremis = @AlamatPremis, 
                        JenisPerniagaan = @JenisPerniagaan, PemilikBaru = @PemilikBaru, AlamatBaru = @AlamatBaru, JenisPerniagaanBaru = @JenisPerniagaanBaru, NamaBaruSyarikat = @NamaBaruSyarikat,  
                        BillboardLokasi = @BillboardLokasi, LokasiPasar1 = @LokasiPasar1, LokasiPasar2 = @LokasiPasar2, LokasiPasar3 = @LokasiPasar3,
                        JenisPasar = @JenisPasar, JenisPerniagaanPasar = @JenisPerniagaanPasar, JumlahPetak = @JumlahPetak, AnjingAlamat = @AnjingAlamat, AnjingJenisPremis = @AnjingJenisPremis, 
                        AlamatPenjajaan = @AlamatPenjajaan, JenisPerniagaanPenjaja = @JenisPerniagaanPenjaja, TarikhBatal = @TarikhBatal, 
                        PenganjurEkspo = @PenganjurEkspo, NamaEkspo = @NamaEkspo, LokasiEkspo = @LokasiEkspo, NoTelEkspo = @NoTelEkspo, 
                        TarikhEkspo1 = @TarikhEkspo1, TarikhEkspo2 = @TarikhEkspo2, MasaEkspo1 = @MasaEkspo1, MasaEkspo2 = @MasaEkspo2, 
                        KontraktorIklan = @KontraktorIklan, NoTelKontraktor = @NoTelKontraktor, UkuranBanting = @UkuranBanting, BilBanting = @BilBanting, TarikhBanting1 = @TarikhBanting1, TarikhBanting2 = @TarikhBanting2, NoResitBanting = @NoResitBanting, NoSiriStiker=@NoSiriStiker, TarikhBanting3=@TarikhBanting3,
                        Rujukan = @Rujukan, NoAkaunCukai = @NoAkaunCukai, DepositAmount = @DepositAmount, 
                        DepositDate = @DepositDate, DepositResitNo = @DepositResitNo, DepositPulangAmount = @DepositPulangAmount, Is24jam = @Is24jam, IsBatal = @IsBatal, JenisBatal = @JenisBatal, SebabBatalPerm = @SebabBatalPerm, 
                        SebabBatalTanpaPerm = @SebabBatalTanpaPerm, TindakanBatal = @TindakanBatal, RemarksFail = @RemarksFail, LastModId = @LastModId, LastModDt = GETDATE() 
                        WHERE (Permohonan_ID = @Permohonan_ID)">
                <InsertParameters>
                    <asp:Parameter Name="JenisLesenDescList"></asp:Parameter>
                    <asp:Parameter Name="JenisLesenIdList"></asp:Parameter>
                    <asp:Parameter Name="SaizIklanList"></asp:Parameter>
                    <asp:Parameter Name="CahayaIklanList"></asp:Parameter>
                    <asp:Parameter Name="UnitIklanList"></asp:Parameter>
                    <asp:Parameter Name="LokasiList"></asp:Parameter>
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
                    <asp:Parameter Name="AlamatPenjajaan"></asp:Parameter>
                    <asp:Parameter Name="JenisPerniagaanPenjaja"></asp:Parameter>
                    <asp:Parameter Name="TarikhBatal"></asp:Parameter>
                    <asp:Parameter Name="PenganjurEkspo"></asp:Parameter>
                    <asp:Parameter Name="NamaEkspo"></asp:Parameter>
                    <asp:Parameter Name="LokasiEkspo"></asp:Parameter>
                    <asp:Parameter Name="NoTelEkspo"></asp:Parameter>
                    <asp:Parameter Name="TarikhEkspo1"></asp:Parameter>
                    <asp:Parameter Name="TarikhEkspo2"></asp:Parameter>
                    <asp:Parameter Name="MasaEkspo1"></asp:Parameter>
                    <asp:Parameter Name="MasaEkspo2"></asp:Parameter>
                    <asp:Parameter Name="KontraktorIklan"></asp:Parameter>
                    <asp:Parameter Name="NoTelKontraktor"></asp:Parameter>
                    <asp:Parameter Name="UkuranBanting"></asp:Parameter>
                    <asp:Parameter Name="BilBanting"></asp:Parameter>
                    <asp:Parameter Name="TarikhBanting1"></asp:Parameter>
                    <asp:Parameter Name="TarikhBanting2"></asp:Parameter>
                    <asp:Parameter Name="NoResitBanting"></asp:Parameter>
                    <asp:Parameter Name="NoSiriStiker"></asp:Parameter>
                    <asp:Parameter Name="TarikhBanting3"></asp:Parameter>
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
                    <asp:Parameter Name="AlamatPenjajaan"></asp:Parameter>
                    <asp:Parameter Name="JenisPerniagaanPenjaja"></asp:Parameter>
                    <asp:Parameter Name="TarikhBatal"></asp:Parameter>
                    <asp:Parameter Name="PenganjurEkspo"></asp:Parameter>
                    <asp:Parameter Name="NamaEkspo"></asp:Parameter>
                    <asp:Parameter Name="LokasiEkspo"></asp:Parameter>
                    <asp:Parameter Name="NoTelEkspo"></asp:Parameter>
                    <asp:Parameter Name="TarikhEkspo1"></asp:Parameter>
                    <asp:Parameter Name="TarikhEkspo2"></asp:Parameter>
                    <asp:Parameter Name="MasaEkspo1"></asp:Parameter>
                    <asp:Parameter Name="MasaEkspo2"></asp:Parameter>
                    <asp:Parameter Name="KontraktorIklan"></asp:Parameter>
                    <asp:Parameter Name="NoTelKontraktor"></asp:Parameter>
                    <asp:Parameter Name="UkuranBanting"></asp:Parameter>
                    <asp:Parameter Name="BilBanting"></asp:Parameter>
                    <asp:Parameter Name="TarikhBanting1"></asp:Parameter>
                    <asp:Parameter Name="TarikhBanting2"></asp:Parameter>
                    <asp:Parameter Name="NoResitBanting"></asp:Parameter>
                    <asp:Parameter Name="NoSiriStiker"></asp:Parameter>
                    <asp:Parameter Name="TarikhBanting3"></asp:Parameter>
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
                    <asp:Parameter Name="TindakanBatal"></asp:Parameter>
                    <asp:SessionParameter SessionField="sessionUserName" Name="LastModId"></asp:SessionParameter>
                    <asp:Parameter Name="Permohonan_ID"></asp:Parameter>
                </UpdateParameters>
            </asp:SqlDataSource>
            <br />

            <div class="row" id="whiteCard" runat="server">
                <div class="col-12">
                    <div class="card">
                        <div class="card-body">

                            <div class="row">
                                <div class="col-4">
                                    <asp:Button ID="ButtonAddAssignment" runat="server" Text="Permohonan Baru" CssClass="btn btn-block btn-primary" />
                                    <br />
                                </div>
                            </div>

                            <%--# START FILTER - set SortExpression at GridView as PRName & add WHERE 1=1 at SqlDataSource - SelectCommand #--%>
                            <div class="row" id="panelFilter" runat="server">
                                <div class="col-md-10">
                                    <%--<div id="pnlFilter" runat="server" class="row" hidden="hidden"></div>--%>

                                    <div class="row">

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <asp:TextBox ID="TB_TarikhMohon" runat="server"
                                                    TextMode="Date" CssClass="form-control" />
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <asp:TextBox ID="txtNoRujukan" placeholder="No Rujukan" runat="server" CssClass="form-control"></asp:TextBox>
                                            </div>
                                        </div>

                                        <div class="col-md-3" runat="server" id="filterPemohon">
                                            <div class="form-group">
                                                <asp:DropDownList ID="DDL_Pemohon" CssClass="form-control select2" runat="server"
                                                    DataSourceID="sdsPemohon" DataTextField="Pemohon_Name" DataValueField="Pemohon_ID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource runat="server" ID="sdsPemohon" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                    SelectCommand="select * from 
                                                (select 0 as Pemohon_ID, '-- Pemohon --' as Pemohon_Name
                                                union all
                                                select DISTINCT Pemohon_ID, Pemohon_Name from LESEN_Permohonan a INNER JOIN LESEN_Pemohon b ON b.Pemohon_ID = a.Permohonan_PemohonID where Pemohon_IsActive=1
                                                ) as tbl1 order by Pemohon_Name"></asp:SqlDataSource>
                                            </div>
                                        </div>

                                        <div class="col-md-3" runat="server" id="filterSyarikat">
                                            <div class="form-group">
                                                <asp:DropDownList ID="DDL_Syarikat" CssClass="form-control select2" runat="server"
                                                    DataSourceID="sdsSyarikat" DataTextField="NamaSyarikat" DataValueField="NamaSyarikat">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource runat="server" ID="sdsSyarikat" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                    SelectCommand="select * from 
                                                (select '-- Syarikat --' as NamaSyarikat
                                                union all
                                                select DISTINCT CONVERT(varchar(max), NamaSyarikat) AS NamaSyarikat from LESEN_Permohonan 
                                                WHERE NamaSyarikat IS NOT NULL AND CONVERT(varchar(max), NamaSyarikat) <> '-' 
                                                union all
                                                select DISTINCT CONVERT(varchar(max), NamaBaruSyarikat) AS NamaSyarikat from LESEN_Permohonan 
                                                WHERE NamaBaruSyarikat IS NOT NULL AND CONVERT(varchar(max), NamaBaruSyarikat) <> '-' ) as tbl1"></asp:SqlDataSource>
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <asp:TextBox ID="TB_Alamat" placeholder="Alamat Premis" runat="server" CssClass="form-control"></asp:TextBox>
                                            </div>
                                        </div>

                                        <div class="col-md-3" runat="server" id="filterJenisLesen">
                                            <div class="form-group">
                                                <asp:DropDownList ID="DDL_JenisLesen" CssClass="form-control select2" runat="server" AutoPostBack="false"
                                                    DataSourceID="SqlDataSourceLesen" DataTextField="JenisLesen_Description" DataValueField="JenisLesen_ID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource runat="server" ID="SqlDataSourceLesen" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                    SelectCommand="select * from 
                                                (select '0' as JenisLesen_ID, '-- Lesen/Permit --' as JenisLesen_Description
                                                union all
                                                select JenisLesen_Description AS JenisLesen_ID,  JenisLesen_Description from LESEN_JenisLesen where JenisLesen_IsActive=1
                                                ) as tbl1 order by JenisLesen_Description "></asp:SqlDataSource>
                                            </div>
                                        </div>

                                        <div class="col-md-3" runat="server" id="filterRisiko">
                                            <div class="form-group">
                                                <asp:DropDownList ID="DDL_Risiko" runat="server" AutoPostBack="false" CssClass="form-control select2">
                                                    <asp:ListItem Value="2">-- Risiko --</asp:ListItem>
                                                    <asp:ListItem Value="0">Berisiko</asp:ListItem>
                                                    <asp:ListItem Value="1">Tidak Berisiko</asp:ListItem>
                                                </asp:DropDownList>
                                            </div>
                                        </div>

                                        <div class="col-md-3" runat="server" id="filterPembatalan">
                                            <div class="form-group">
                                                <asp:DropDownList ID="DDL_Pembatalan" runat="server" AutoPostBack="false" CssClass="form-control select2">
                                                    <asp:ListItem Value="2">-- Pembatalan --</asp:ListItem>
                                                    <asp:ListItem Value="1">Ya</asp:ListItem>
                                                    <asp:ListItem Value="0">Tidak</asp:ListItem>
                                                </asp:DropDownList>
                                            </div>
                                        </div>

                                        <div class="col-md-3" runat="server" id="filterStatus">
                                            <asp:DropDownList ID="DDL_Status" CssClass="form-control select2" runat="server" AutoPostBack="false"
                                                DataSourceID="sdsStatus" DataTextField="Description" DataValueField="ApprStatusID">
                                            </asp:DropDownList>
                                            <asp:SqlDataSource runat="server" ID="sdsStatus" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                SelectCommand="select * from 
                                                (select -1 as ApprStatusID, '-- Status --' as Description
                                                union all
                                                select ApprStatusID,  Description from ApprovalStatus
                                                ) as tbl1 order by ApprStatusID "></asp:SqlDataSource>
                                        </div>

                                        <div class="col-md-3" runat="server" id="filterCreatedBy">
                                            <div class="form-group">
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

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <asp:TextBox ID="TB_PermohonanID" placeholder="ID Permohonan" runat="server" CssClass="form-control"></asp:TextBox>
                                            </div>
                                        </div>

                                    </div>

                                </div>
                                <div class="col-md-2">
                                    <div class="form-group">
                                        <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-default" Text="Cari" />
                                        <asp:Button ID="btnReset" CssClass="btn btn-default" runat="server" Text="Reset" />
                                    </div>
                                </div>
                            </div>
                            <%--# END FILTER #--%>

                            <asp:GridView ID="GridView1" HeaderStyle-ForeColor="Black" CssClass="table table-bordered" AllowPaging="True" PageSize="20"
                                ShowHeaderWhenEmpty="True" EmptyDataText="Tiada Rekod Dijumpai" AllowSorting="True" runat="server" AutoGenerateColumns="False"
                                DataKeyNames="Permohonan_ID, StatusID, IsBatal, JenisLesen_ID, IsPublish, Is24Jam, JenisLesenIdList" DataSourceID="SqlDataSourceGrid">
                                <Columns>
                                    <asp:BoundField DataField="Permohonan_ID" HeaderText="ID" SortExpression="Permohonan_ID" Visible="false"></asp:BoundField>
                                    <asp:BoundField DataField="RowNo" HeaderText="No" SortExpression="RowNo"></asp:BoundField>
                                    <asp:BoundField DataField="TarikhMohon" HeaderText="Tarikh" DataFormatString="{0:dd/MM/yyyy}" SortExpression="TarikhMohon"></asp:BoundField>
                                    <asp:BoundField DataField="JenisLesenDescList" HeaderText="Jenis Lesen/Permit" SortExpression="JenisLesenDescList"></asp:BoundField>
                                    <asp:BoundField DataField="Rujukan" HeaderText="No Rujukan" SortExpression="Rujukan"></asp:BoundField>
                                    <asp:TemplateField HeaderText="Pemohon">
                                        <ItemTemplate>
                                            <asp:Label ID="lblNamaPemohon" runat="server" Text='<%# Eval("Pemohon_Name") %>'></asp:Label><br />
                                            <asp:Label ID="lblNamaSyarikat" runat="server" Visible='<%# If(String.IsNullOrEmpty(Eval("NamaSyarikat")?.ToString()) And String.IsNullOrEmpty(Eval("NamaBaruSyarikat")?.ToString()), False, True) %>' 
                                                Text='<%# If(String.IsNullOrEmpty(Eval("NamaBaruSyarikat")?.ToString()), Eval("NamaSyarikat"), Eval("NamaBaruSyarikat")) %>' Font-Size="10pt"></asp:Label><br />
                                            <asp:Label ID="lblAlamatPremis" runat="server" Visible='<%# If(String.IsNullOrEmpty(Eval("AlamatPremis")?.ToString()) And String.IsNullOrEmpty(Eval("AlamatBaru")?.ToString()), False, True) %>' 
                                                Text='<%# If(String.IsNullOrEmpty(Eval("AlamatBaru")?.ToString()), Eval("AlamatPremis"), Eval("AlamatBaru")) %>' Font-Size="10pt"></asp:Label><br />
                               
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
                                    <asp:TemplateField ShowHeader="True" HeaderText="Surat Balasan" SortExpression="Surat">
                                        <ItemTemplate>
                                            <span runat="server" class="badge badge-secondary" visible='<%# If(Eval("Surat") = 0 And Eval("SuratBNM") = 0 And
                                                                     Eval("SuratBombaJohor") = 0 And Eval("SuratBombaPenggaram") = 0 And Eval("SuratFarmasi") = 0 And Eval("SuratJurutera") = 0 And
                                                                     Eval("SuratBangunan") = 0 And Eval("SuratPerancang") = 0 And Eval("SuratPenguatkuasa") = 0 And Eval("SuratHarta") = 0 And
                                                                     Eval("SuratKluang") = 0 And Eval("SuratKesihatan") = 0 And Eval("SuratSWCorp") = 0 And Eval("SuratKebajikan") = 0, True, False) %>'>Tiada</span>
                                            <span runat="server" class="badge badge-info" visible='<%# If(Eval("Surat") > 0, True, False) %>'>Inspektorat</span>
                                            <span runat="server" class="badge badge-info" visible='<%# If(Eval("SuratBNM") > 0, True, False) %>'>Bank Negara</span>
                                            <span runat="server" class="badge badge-info" visible='<%# If(Eval("SuratBombaJohor") > 0 Or Eval("SuratBombaPenggaram") > 0, True, False) %>'>Bomba</span>
                                            <span runat="server" class="badge badge-info" visible='<%# If(Eval("SuratFarmasi") > 0, True, False) %>'>Farmasi</span>
                                            <span runat="server" class="badge badge-info" visible='<%# If(Eval("SuratJurutera") > 0, True, False) %>'>Kejuruteraan</span>
                                            <span runat="server" class="badge badge-info" visible='<%# If(Eval("SuratBangunan") > 0, True, False) %>'>Kawalan Bangunan</span>
                                            <span runat="server" class="badge badge-info" visible='<%# If(Eval("SuratPerancang") > 0, True, False) %>'>Perjancang Bandar & Landskap</span>
                                            <span runat="server" class="badge badge-info" visible='<%# If(Eval("SuratPenguatkuasa") > 0, True, False) %>'>Penguatkuasaan</span>
                                            <span runat="server" class="badge badge-info" visible='<%# If(Eval("SuratHarta") > 0, True, False) %>'>Pengurusan Harta</span>
                                            <span runat="server" class="badge badge-info" visible='<%# If(Eval("SuratKluang") > 0, True, False) %>'>PD Kluang</span>
                                            <span runat="server" class="badge badge-info" visible='<%# If(Eval("SuratKesihatan") > 0, True, False) %>'>Kesihatan</span>
                                            <span runat="server" class="badge badge-info" visible='<%# If(Eval("SuratSWCorp") > 0, True, False) %>'>SWCorp</span>
                                            <span runat="server" class="badge badge-info" visible='<%# If(Eval("SuratKebajikan") > 0, True, False) %>'>Kebajikan Masyarakat</span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Description" HeaderText="Status" SortExpression="Description"></asp:BoundField>
                                    <asp:BoundField DataField="RemarksFail" HeaderText="Catatan" SortExpression="RemarksFail"></asp:BoundField>

                                    <asp:TemplateField ShowHeader="False">
                                        <ItemTemplate>
                                            <asp:LinkButton runat="server" CssClass="btn btn-primary btn-sm" CommandName="Select" CausesValidation="False" ID="LinkButton1" data-toggle="tooltip" data-placement="top" title="Edit" Text="Lihat" />&nbsp;
                                            
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField ShowHeader="False">
                                        <ItemTemplate>
                                            <asp:LinkButton runat="server" CommandName="Delete" CausesValidation="False" ID="LinkButton2" CssClass="btn btn-default btn-sm" OnClientClick="return confirm('Anda pasti untuk memadam rekod ini?');" data-toggle="tooltip" data-placement="top" title="Delete" Visible='<%# If(Eval("StatusID") < 1 And IsDBNull(Eval("SuratKelulusan1")) And Eval("IsSuratKelulusanFail") = False, True, False) %>'>Padam</asp:LinkButton>
                                            <asp:LinkButton runat="server" CommandName="BatalProses" CausesValidation="False" ID="LinkButton5" CssClass="btn btn-danger btn-sm" OnClientClick="return confirm('Anda pasti untuk membatalkan proses ini?');" data-toggle="tooltip" data-placement="top" title="Cancel" Visible='<%# If(Eval("StatusID") < 9 And (Eval("StatusID") > 0 Or (Eval("StatusID") >= 0 And Eval("IsBatal") = True And (IsDBNull(Eval("SuratKelulusan1")) = False Or Eval("IsSuratKelulusanFail") = True))), True, False) %>' CommandArgument='<%# Container.DataItemIndex %>'>Batal Proses</asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>

                            <asp:SqlDataSource runat="server" ID="SqlDataSourceGrid" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                DeleteCommand="DELETE FROM LESEN_Permohonan WHERE Permohonan_ID = @Permohonan_ID"
                                SelectCommand="SELECT ROW_NUMBER() OVER(ORDER BY a.TarikhMohon desc) as RowNo, a.*, c.Pemohon_Name, 
                                        CASE WHEN a.StatusID = 0 and a.IsBatal = 0 then ISNULL(d.Description + 
                                        (SELECT CASE WHEN MIN(ISNULL(reviewStatusID,0)) = 0 THEN ' (Belum Disemak)' 
                                        WHEN MIN(ISNULL(reviewStatusID,0)) = 1 THEN ' (Dalam Proses Semakan)'
                                        WHEN MIN(ISNULL(reviewStatusID,0)) = 2 THEN ' (Telah Disemak)'
                                        WHEN MIN(ISNULL(reviewStatusID,0)) = 3 THEN ' (Semakan Semula)' END
                                        AS stts 
                                        FROM LESEN_PermohonanAgensi WHERE Permohonan_ID = a.Permohonan_ID),'Draf') 
                                        WHEN a.StatusID = 0 and a.IsBatal = 1 then ISNULL(d.Description + 
                                        (SELECT CASE WHEN MIN(ISNULL(reviewStatusID,0)) = 0 THEN ' (Belum Disemak)' 
                                        WHEN MIN(ISNULL(reviewStatusID,0)) = 1 THEN ' (Dalam Proses Semakan)'
                                        WHEN MIN(ISNULL(reviewStatusID,0)) = 2 THEN ' (Telah Disemak)'
                                        WHEN MIN(ISNULL(reviewStatusID,0)) = 3 THEN ' (Semakan Semula)' END
                                        AS stts 
                                        FROM LESEN_PermohonanAgensiBatal WHERE Permohonan_ID = a.Permohonan_ID),'Draf') else d.Description END
                                        AS Description, 
                                        CASE WHEN a.IsBatal = 0 then a.Is24Jam 
                                        WHEN a.IsBatal = 1 then 1 END 
										AS IsNotRisk,
                                        CASE WHEN a.IsBatal = 0 THEN (SELECT COUNT(Permohonan_ID) AS totalSah FROM LESEN_PermohonanAgensi WHERE JabatanAgensi_ID = 3 AND PengesahID IS NOT NULL AND Permohonan_ID = a.Permohonan_ID) 
                                        ELSE (SELECT COUNT(Permohonan_ID) AS totalSah FROM LESEN_PermohonanAgensiBatal WHERE JabatanAgensi_ID = 3 AND PengesahID IS NOT NULL AND Permohonan_ID = a.Permohonan_ID) 
                                        END AS Surat,
                                        CASE WHEN a.IsBatal = 0 THEN (SELECT COUNT(Permohonan_ID) AS totalSah FROM LESEN_PermohonanAgensi WHERE JabatanAgensi_ID = 2 AND PengesahID IS NOT NULL AND Permohonan_ID = a.Permohonan_ID) 
                                        ELSE (SELECT COUNT(Permohonan_ID) AS totalSah FROM LESEN_PermohonanAgensiBatal WHERE JabatanAgensi_ID = 2 AND PengesahID IS NOT NULL AND Permohonan_ID = a.Permohonan_ID) 
                                        END AS SuratBNM, 
                                        CASE WHEN a.IsBatal = 0 THEN (SELECT COUNT(Permohonan_ID) AS totalSah FROM LESEN_PermohonanAgensi WHERE JabatanAgensi_ID = 5 AND PengesahID IS NOT NULL AND Permohonan_ID = a.Permohonan_ID) 
                                        ELSE (SELECT COUNT(Permohonan_ID) AS totalSah FROM LESEN_PermohonanAgensiBatal WHERE JabatanAgensi_ID = 5 AND PengesahID IS NOT NULL AND Permohonan_ID = a.Permohonan_ID) 
                                        END AS SuratBombaJohor, 
                                        CASE WHEN a.IsBatal = 0 THEN (SELECT COUNT(Permohonan_ID) AS totalSah FROM LESEN_PermohonanAgensi WHERE JabatanAgensi_ID = 6 AND PengesahID IS NOT NULL AND Permohonan_ID = a.Permohonan_ID) 
                                        ELSE (SELECT COUNT(Permohonan_ID) AS totalSah FROM LESEN_PermohonanAgensiBatal WHERE JabatanAgensi_ID = 6 AND PengesahID IS NOT NULL AND Permohonan_ID = a.Permohonan_ID) 
                                        END AS SuratFarmasi, 
                                        CASE WHEN a.IsBatal = 0 THEN (SELECT COUNT(Permohonan_ID) AS totalSah FROM LESEN_PermohonanAgensi WHERE JabatanAgensi_ID = 8 AND PengesahID IS NOT NULL AND Permohonan_ID = a.Permohonan_ID) 
                                        ELSE (SELECT COUNT(Permohonan_ID) AS totalSah FROM LESEN_PermohonanAgensiBatal WHERE JabatanAgensi_ID = 8 AND PengesahID IS NOT NULL AND Permohonan_ID = a.Permohonan_ID) 
                                        END AS SuratJurutera, 
                                        CASE WHEN a.IsBatal = 0 THEN (SELECT COUNT(Permohonan_ID) AS totalSah FROM LESEN_PermohonanAgensi WHERE JabatanAgensi_ID = 9 AND PengesahID IS NOT NULL AND Permohonan_ID = a.Permohonan_ID) 
                                        ELSE (SELECT COUNT(Permohonan_ID) AS totalSah FROM LESEN_PermohonanAgensiBatal WHERE JabatanAgensi_ID = 9 AND PengesahID IS NOT NULL AND Permohonan_ID = a.Permohonan_ID) 
                                        END AS SuratBangunan, 
                                        CASE WHEN a.IsBatal = 0 THEN (SELECT COUNT(Permohonan_ID) AS totalSah FROM LESEN_PermohonanAgensi WHERE JabatanAgensi_ID = 10 AND PengesahID IS NOT NULL AND Permohonan_ID = a.Permohonan_ID) 
                                        ELSE (SELECT COUNT(Permohonan_ID) AS totalSah FROM LESEN_PermohonanAgensiBatal WHERE JabatanAgensi_ID = 10 AND PengesahID IS NOT NULL AND Permohonan_ID = a.Permohonan_ID) 
                                        END AS SuratPerancang,
                                        CASE WHEN a.IsBatal = 0 THEN (SELECT COUNT(Permohonan_ID) AS totalSah FROM LESEN_PermohonanAgensi WHERE JabatanAgensi_ID = 11 AND PengesahID IS NOT NULL AND Permohonan_ID = a.Permohonan_ID) 
                                        ELSE (SELECT COUNT(Permohonan_ID) AS totalSah FROM LESEN_PermohonanAgensiBatal WHERE JabatanAgensi_ID = 11 AND PengesahID IS NOT NULL AND Permohonan_ID = a.Permohonan_ID) 
                                        END AS SuratPenguatkuasa,
                                        CASE WHEN a.IsBatal = 0 THEN (SELECT COUNT(Permohonan_ID) AS totalSah FROM LESEN_PermohonanAgensi WHERE JabatanAgensi_ID = 12 AND PengesahID IS NOT NULL AND Permohonan_ID = a.Permohonan_ID) 
                                        ELSE (SELECT COUNT(Permohonan_ID) AS totalSah FROM LESEN_PermohonanAgensiBatal WHERE JabatanAgensi_ID = 12 AND PengesahID IS NOT NULL AND Permohonan_ID = a.Permohonan_ID) 
                                        END AS SuratHarta,
                                        CASE WHEN a.IsBatal = 0 THEN (SELECT COUNT(Permohonan_ID) AS totalSah FROM LESEN_PermohonanAgensi WHERE JabatanAgensi_ID = 13 AND PengesahID IS NOT NULL AND Permohonan_ID = a.Permohonan_ID) 
                                        ELSE (SELECT COUNT(Permohonan_ID) AS totalSah FROM LESEN_PermohonanAgensiBatal WHERE JabatanAgensi_ID = 13 AND PengesahID IS NOT NULL AND Permohonan_ID = a.Permohonan_ID) 
                                        END AS SuratKluang,
                                        CASE WHEN a.IsBatal = 0 THEN (SELECT COUNT(Permohonan_ID) AS totalSah FROM LESEN_PermohonanAgensi WHERE JabatanAgensi_ID = 14 AND PengesahID IS NOT NULL AND Permohonan_ID = a.Permohonan_ID) 
                                        ELSE (SELECT COUNT(Permohonan_ID) AS totalSah FROM LESEN_PermohonanAgensiBatal WHERE JabatanAgensi_ID = 14 AND PengesahID IS NOT NULL AND Permohonan_ID = a.Permohonan_ID) 
                                        END AS SuratPolis,
                                        CASE WHEN a.IsBatal = 0 THEN (SELECT COUNT(Permohonan_ID) AS totalSah FROM LESEN_PermohonanAgensi WHERE JabatanAgensi_ID = 15 AND PengesahID IS NOT NULL AND Permohonan_ID = a.Permohonan_ID) 
                                        ELSE (SELECT COUNT(Permohonan_ID) AS totalSah FROM LESEN_PermohonanAgensiBatal WHERE JabatanAgensi_ID = 15 AND PengesahID IS NOT NULL AND Permohonan_ID = a.Permohonan_ID) 
                                        END AS SuratKesihatan,
                                        CASE WHEN a.IsBatal = 0 THEN (SELECT COUNT(Permohonan_ID) AS totalSah FROM LESEN_PermohonanAgensi WHERE JabatanAgensi_ID = 16 AND PengesahID IS NOT NULL AND Permohonan_ID = a.Permohonan_ID) 
                                        ELSE (SELECT COUNT(Permohonan_ID) AS totalSah FROM LESEN_PermohonanAgensiBatal WHERE JabatanAgensi_ID = 16 AND PengesahID IS NOT NULL AND Permohonan_ID = a.Permohonan_ID) 
                                        END AS SuratBombaPenggaram,
                                        CASE WHEN a.IsBatal = 0 THEN (SELECT COUNT(Permohonan_ID) AS totalSah FROM LESEN_PermohonanAgensi WHERE JabatanAgensi_ID = 17 AND PengesahID IS NOT NULL AND Permohonan_ID = a.Permohonan_ID) 
                                        ELSE (SELECT COUNT(Permohonan_ID) AS totalSah FROM LESEN_PermohonanAgensiBatal WHERE JabatanAgensi_ID = 17 AND PengesahID IS NOT NULL AND Permohonan_ID = a.Permohonan_ID) 
                                        END AS SuratSWCorp,
                                        CASE WHEN a.IsBatal = 0 THEN (SELECT COUNT(Permohonan_ID) AS totalSah FROM LESEN_PermohonanAgensi WHERE JabatanAgensi_ID = 18 AND PengesahID IS NOT NULL AND Permohonan_ID = a.Permohonan_ID) 
                                        ELSE (SELECT COUNT(Permohonan_ID) AS totalSah FROM LESEN_PermohonanAgensiBatal WHERE JabatanAgensi_ID = 18 AND PengesahID IS NOT NULL AND Permohonan_ID = a.Permohonan_ID) 
                                        END AS SuratKebajikan 
                                        FROM LESEN_Permohonan a 
                                        INNER JOIN LESEN_Pemohon c ON a.Permohonan_PemohonID = c.Pemohon_ID 
                                        INNER JOIN ApprovalStatus d ON a.StatusID = d.ApprStatusID 
                                        WHERE 1=1 AND a.JenisLesenIdList is not null 
                                        AND a.Permohonan_ID = CASE WHEN @pid = 0 THEN a.Permohonan_ID ELSE @pid END 
                                        AND a.JenisLesenDescList LIKE CASE WHEN @lesenID = '0' THEN a.JenisLesenDescList ELSE '%'+@lesenID+'%' END 
                                        AND a.Permohonan_PemohonID = CASE WHEN @pemohonID = 0 THEN a.Permohonan_PemohonID ELSE @pemohonID END 
                                        AND CONVERT(varchar(max), ISNULL(a.NamaSyarikat,'')) = CASE WHEN @namaSyarikat = '-- Syarikat --' THEN CONVERT(varchar(max), ISNULL(a.NamaSyarikat,'')) ELSE @namaSyarikat END 
                                        AND a.IsBatal = CASE WHEN @batalID = 2 THEN a.IsBatal ELSE @batalID END 
                                        AND a.Is24Jam = CASE WHEN @risikoID = 2 THEN a.Is24Jam ELSE @risikoID END 
                                        AND a.StatusID = CASE WHEN @statusID = -1 THEN a.StatusID ELSE @statusID END 
                                        AND a.CreatorID = CASE WHEN @creatorID = '0' THEN a.CreatorID ELSE @creatorID END 
                                        AND a.AlamatPremis LIKE CASE WHEN @Alamat='' THEN a.AlamatPremis ELSE '%'+@Alamat+'%' END 
                                        /*AND a.AlamatBaru LIKE CASE WHEN @Alamat='' THEN a.AlamatBaru ELSE '%'+@Alamat+'%' END */
                                        /*AND a.AnjingAlamat LIKE CASE WHEN @Alamat='%%' THEN a.AnjingAlamat ELSE '%'+@Alamat+'%' END*/ 
                                        AND a.TarikhMohon LIKE '%'+@TarikhMohon+'%' 
                                        AND a.Rujukan LIKE '%'+@Rujukan+'%' 
                                        order by a.TarikhMohon desc">
                                <DeleteParameters>
                                    <asp:Parameter Name="Permohonan_ID"></asp:Parameter>
                                </DeleteParameters>
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="TB_PermohonanID" PropertyName="Text" DefaultValue="0" Name="pid"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="txtNoRujukan" PropertyName="Text" DefaultValue="%%" Name="Rujukan"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="DDL_JenisLesen" PropertyName="SelectedValue" Name="lesenID"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="DDL_Pemohon" PropertyName="SelectedValue" Name="pemohonID"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="DDL_Syarikat" PropertyName="SelectedValue" Name="namaSyarikat"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="DDL_Pembatalan" PropertyName="SelectedValue" Name="batalID"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="DDL_Risiko" PropertyName="SelectedValue" Name="risikoID"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="DDL_Status" PropertyName="SelectedValue" Name="statusID"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="DDL_CreatedBy" PropertyName="SelectedValue" Name="creatorID"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="TB_TarikhMohon" PropertyName="Text" DefaultValue="%%" Name="TarikhMohon"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="TB_Alamat" PropertyName="Text" DefaultValue="%%" Name="Alamat"></asp:ControlParameter>
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </div>
                    </div>
                </div>
            </div>
            <!-- row whiteCard -->

            <asp:TabContainer ID="TabContainer1" runat="server" ActiveTabIndex="0" Visible="false" CssClass="MyTabStyle">

                <asp:TabPanel runat="server" ID="tabUlasan" HeaderText="Ulasan">
                    <HeaderTemplate>Lampiran</HeaderTemplate>
                    <ContentTemplate>

                        <asp:GridView ID="gvTabUlasan" runat="server" ShowHeaderWhenEmpty="True"
                            AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="PermohonanFail_ID"
                            DataSourceID="SqlDataSourceTabUlasan"
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
                                        <div class="row">

                                            <div class="col-md-6">

                                                <div class="form-group">
                                                    <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="True" CommandName="Update" Text="Simpan"></asp:LinkButton>
                                                </div>
                                            </div>

                                            <div class="col-md-6">

                                                <div class="form-group">
                                                    <asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="Cancel" Text="Batal"></asp:LinkButton>
                                                </div>

                                            </div>

                                        </div>

                                    </EditItemTemplate>
                                    <ItemTemplate>
									<asp:LinkButton ID="lbEdit" runat="server" CausesValidation="False" CommandName="Edit" Text="Kemaskini" Visible='<%# If(CInt(Session.Item("sessionEstateID")) = 1, True, False) %>'></asp:LinkButton><%--If(Eval("StatusID") < 2, True, False)--%>
                                    </ItemTemplate>
                                    <HeaderStyle Width="10%" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:TemplateField>

                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        <asp:LinkButton ID="btnAddNew" runat="server" Text="+" CssClass="btn btn-warning btn-sm" ToolTip="Tambah" Visible='<%# If(CInt(Session.Item("sessionEstateID")) = 1, True, False) %>' OnClick="btnAddNewUpload_Click" />
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lbDelete" runat="server" CausesValidation="False" CommandName="Delete" Text="Padam" OnClientClick="return confirm('Anda pasti untuk padam rekod ini?');" Visible='<%# If(CInt(Session.Item("sessionEstateID")) = 1, True, False) %>'></asp:LinkButton>
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

                <asp:TabPanel runat="server" ID="tabMaklumat" HeaderText="Maklumat" Visible="false">
                    <HeaderTemplate>Inspektorat</HeaderTemplate>
                    <ContentTemplate>
                        <div class="row">
                            <div class="col-md-12">
                                <asp:LinkButton runat="server" CssClass="btn btn-warning" Text="Lihat Laporan" ID="BT_ViewLaporan" OnCommand="BT_ViewLaporan_Command" CausesValidation="False" Visible="false" />
                            </div>
                        </div>
                        <br />
                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <asp:Label runat="server" Font-Bold="true">Pembetulan Maklumat Permohonan</asp:Label>
                                </div>
                            </div>

                            <asp:HiddenField ID="HF_SaizIklanList_ins" runat="server" />
                            <asp:HiddenField ID="HF_CahayaIklanList_ins" runat="server" />
                            <asp:HiddenField ID="HF_UnitIklanList_ins" runat="server" />
                            <asp:HiddenField ID="HF_LokasiList_ins" runat="server" />
                            <asp:HiddenField ID="HF_BakaAnjingList_ins" runat="server" />
                            <asp:HiddenField ID="HF_AnjingJantanList_ins" runat="server" />
                            <asp:HiddenField ID="HF_AnjingBetinaList_ins" runat="server" />
                            <asp:HiddenField ID="HF_AnjingJantanMandulList_ins" runat="server" />
                            <asp:HiddenField ID="HF_AnjingBetinaMandulList_ins" runat="server" />

                        </div>
                        
                        <%--# Perniagaan Berisiko dan tidak berisiko #--%>
                        <asp:Panel ID="pnlesen1_ins" runat="server" Visible="False" Enabled="True">

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Nama Syarikat/Sediada</label>
                                        <asp:TextBox ID="TB_NamaSyarikat_ins" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>No Pendaftaran</label>
                                        <asp:TextBox ID="TB_NoPendaftaran_ins" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>No Akaun Lesen</label>
                                        <asp:TextBox ID="TB_NoAkaun_ins" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Alamat Premis/Sediada</label>
                                        <asp:TextBox ID="TB_AlamatPremis_ins" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Jenis Perniagaan/Sediada</label>
                                        <asp:TextBox ID="TB_JenisPerniagaan_ins" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>

                            <%--# Tukar Pemilik #--%>
                            <asp:Panel ID="pnlesen1b_ins" runat="server" Visible="False" Enabled="True">
                                <div class="row">

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Nama Pemilik Baru</label>
                                            <asp:TextBox ID="TB_PemilikBaru_ins" runat="server" CssClass="form-control" />

                                        </div>
                                    </div>
                                </div>
                            </asp:Panel>

                        </asp:Panel>

                        <%--# Tukar Alamat #--%>
                        <asp:Panel ID="pnlesen1c_ins" runat="server" Visible="False" Enabled="True">

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Alamat Baru</label>
                                        <asp:TextBox ID="TB_AlamatBaru_ins" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>
                        </asp:Panel>

                        <%--# Tambah Jenis Perniagaan #--%>
                        <asp:Panel ID="pnlesen1d_ins" runat="server" Visible="False" Enabled="True">

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Jenis Perniagaan Tambahan</label>
                                        <asp:TextBox ID="TB_JenisPerniagaanBaru_ins" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>
                        </asp:Panel>

                        <%--# Tukar Nama Syarikat #--%>
                        <asp:Panel ID="pnlesen1e_ins" runat="server" Visible="False" Enabled="True">

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Nama Baru Syarikat</label>
                                        <asp:TextBox ID="TB_NamaBaruSyarikat_ins" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>

                        </asp:Panel>

                        <%--# Banting #--%>
                        <asp:Panel ID="pnlesen6_ins" runat="server" Visible="False">

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Nama Syarikat Kontraktor Pemasang Iklan</label>
                                        <asp:TextBox ID="TB_KontraktorIklan_ins" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>No Telefon Syarikat Kontraktor</label>
                                        <asp:TextBox ID="TB_NoTelKontraktor_ins" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Ukuran (Kaki)</label>
                                        <asp:TextBox ID="TB_UkuranBanting_ins" runat="server" placeholder="Contoh: 5x10" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Bilangan Banting/Sepanduk</label>
                                        <asp:TextBox ID="TB_BilBanting_ins" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Tarikh Mula Pemasangan</label>
                                        <asp:TextBox ID="TB_TarikhBanting1_ins" runat="server" TextMode="Date" CssClass="form-control" />
                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Tarikh Akhir Pemasangan</label>
                                        <asp:TextBox ID="TB_TarikhBanting2_ins" runat="server" TextMode="Date" CssClass="form-control" />
                                    </div>
                                </div>

                            </div>

                             <div class="row">

                                 <div class="col-md-6">
                                     <div class="form-group">
                                         <label>Lokasi/Tempat Pemasagan</label>
                                         <asp:TextBox ID="TB_LokasiBanting_ins" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />
                                     </div>
                                 </div>

                                 <div class="col-md-2">
                                    <div class="form-group">
                                        <label> </label>
                                        <asp:LinkButton ID="btnAddLokasi_ins" runat="server" CssClass="btn btn-primary" Text="Tambah" OnClick="btnAddLokasi_ins_Click" />
                                    </div>
                                </div>

                             </div>

                             <div class="row">
                                <div class="col-md-8">
                                    <asp:GridView ID="gvLokasiList_ins" runat="server" HeaderStyle-ForeColor="Black" CssClass="table table-bordered" AutoGenerateColumns="False" 
                                        ShowHeaderWhenEmpty="true" EmptyDataText="Senarai kosong." OnRowDeleting="gvLokasiList_ins_RowDeleting">
                                        <Columns>
                                            <asp:BoundField DataField="No" HeaderText="No." />
                                            <asp:BoundField DataField="Lokasi" HeaderText="Lokasi/Tempat Pemasangan" />
                                            <asp:TemplateField>
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="btnRemove_ins" runat="server"  
                                                        CommandName="Delete" CssClass="btn btn-danger btn-sm">&times;</asp:LinkButton>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>No Resit</label>
                                        <asp:TextBox ID="TB_NoResitBanting_ins" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>No Siri Stiker</label>
                                        <asp:TextBox ID="TB_NoSiriStiker_ins" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Tarikh</label>
                                        <asp:TextBox ID="TB_TarikhBanting3_ins" runat="server" TextMode="Date" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>

                        </asp:Panel>

                        <%--# Papan iklan, Billboard #--%>
                        <asp:Panel ID="pnlesen1a_ins" runat="server" Visible="False" Enabled="True">

                            <div class="row">

                              <div class="col-md-2">
                                  <div class="form-group">
                                      <label>Saiz Iklan (cm)</label>
                                      <asp:TextBox ID="TB_SaizIklan1_ins" placeholder="Contoh:10x5" runat="server" CssClass="form-control" />
                                  </div>
                              </div>
                               <div class="col-md-2">
                                   <div class="form-group">
                                       <label>Iklan Bercahaya</label>
                                       <asp:DropDownList ID="DDL_Iklan1_ins" runat="server"
                                           CssClass="form-control select2">
                                           <asp:ListItem Value="">-- Sila Pilih --</asp:ListItem>
                                           <asp:ListItem Value="Bercahaya">Ya</asp:ListItem>
                                           <asp:ListItem Value="Tidak Bercahaya">Tidak</asp:ListItem>
                                       </asp:DropDownList>
                                   </div>
                               </div>
                              <div class="col-md-2">
                                  <div class="form-group">
                                      <label>Bil. Unit</label>
                                      <div class="row">
                                          <div class="col">
                                              <asp:TextBox ID="TB_UnitIklan1_ins" runat="server" CssClass="form-control" />
                                          </div>
                                          <div class="col">
                                              <asp:LinkButton ID="btnAddIklan_ins" runat="server" CssClass="btn btn-primary" Text="Tambah" OnClick="btnAddIklan_ins_Click" />
      
                                          </div>
                                      </div>
              
                                  </div>
                              </div>

                          </div>

                          <div class="row">
                              <div class="col-md-6">
                                  <asp:GridView ID="gvIklanList_ins" runat="server" HeaderStyle-ForeColor="Black" CssClass="table table-bordered" AutoGenerateColumns="False" 
                                      ShowHeaderWhenEmpty="true" EmptyDataText="Senarai kosong." OnRowDeleting="gvIklanList_ins_RowDeleting">
                                      <Columns>
                                          <asp:BoundField DataField="SaizIklan" HeaderText="Saiz Iklan (cm)" />
                                          <asp:BoundField DataField="Bercahaya" HeaderText="Bercahaya/Tidak Bercahaya" />
                                          <asp:BoundField DataField="Unit" HeaderText="Bil. Unit" />
                                          <asp:TemplateField>
                                              <ItemTemplate>
                                                  <asp:LinkButton ID="btnRemove_ins" runat="server"  
                                                      CommandName="Delete" CssClass="btn btn-danger btn-sm">&times;</asp:LinkButton>
                                              </ItemTemplate>
                                          </asp:TemplateField>
                                      </Columns>
                                  </asp:GridView>
                              </div>
                          </div>

                        </asp:Panel>

                        <%--#  Billboard #--%>
                        <asp:Panel ID="pnlbillboard_ins" runat="server" Visible="False" Enabled="True">

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Lokasi Billboard</label>
                                        <asp:TextBox ID="TB_BillboardLokasi_ins" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>

                        </asp:Panel>

                        <%--# Pasar Lambak #--%>
                        <asp:Panel ID="pnlesen2_ins" runat="server" Visible="False" Enabled="True">

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Lokasi Pasar #1</label>
                                        <asp:TextBox ID="TB_LokasiPasar1_ins" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Lokasi Pasar #2</label>
                                        <asp:TextBox ID="TB_LokasiPasar2_ins" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Lokasi Pasar #3</label>
                                        <asp:TextBox ID="TB_LokasiPasar3_ins" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Jumlah Petak/Tapak/Lot</label>
                                        <asp:TextBox ID="TB_JumlahPetak_ins" runat="server" TextMode="Number" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Jenis Perniagaan</label>
                                        <asp:TextBox ID="TB_JenisPerniagaanPasar_ins" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Jenis Pasar</label>
                                        <asp:DropDownList ID="DDL_JenisPasar_ins" runat="server"
                                            CssClass="form-control select2">
                                            <asp:ListItem Value="">-- Sila Pilih --</asp:ListItem>
                                            <asp:ListItem>Pasar Pagi</asp:ListItem>
                                            <asp:ListItem>Pasar Malam</asp:ListItem>
                                            <asp:ListItem>Pasar Lambak</asp:ListItem>
                                        </asp:DropDownList>

                                    </div>
                                </div>

                            </div>

                        </asp:Panel>

                        <%--# Anjing #--%>
                        <asp:Panel ID="pnlesen3_ins" runat="server" Visible="False" Enabled="True">

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Alamat lokasi</label>
                                        <asp:TextBox ID="TB_AnjingAlamat_ins" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Jenis Premis</label>
                                        <asp:DropDownList ID="DDL_AnjingJenisPremis_ins" CssClass="form-control select2" runat="server"
                                            DataSourceID="SqlDataSourceAnjingJenisPremis_ins" DataTextField="name" DataValueField="id">
                                        </asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourceAnjingJenisPremis_ins" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            SelectCommand="SELECT NULL AS id, '-- Sila Pilih --' AS name UNION ALL SELECT id, name 
                                                FROM TBL_LOOKUPS WHERE lookupgrp_id = 10001 AND status = 1"></asp:SqlDataSource>
                                    </div>
                                </div>

                            </div>

                            <div class="row">

                             <div class="col-md-2">
                                 <div class="form-group">
                                     <label>Jenis Baka</label>
                                     <asp:DropDownList ID="DDL_BakaAnjing1_ins" CssClass="form-control select2" runat="server"
                                         DataSourceID="SqlDataSourceAnjingBaka1_ins" DataTextField="name" DataValueField="id">
                                     </asp:DropDownList>
                                     <asp:SqlDataSource runat="server" ID="SqlDataSourceAnjingBaka1_ins" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                         SelectCommand="SELECT NULL AS id, '-- Sila Pilih --' AS name UNION ALL SELECT id, name 
                                                 FROM TBL_LOOKUPS WHERE lookupgrp_id = 10004 AND status = 1"></asp:SqlDataSource>
                                 </div>
                             </div>

                             <div class="col-md-2">
                                 <div class="form-group">
                                     <label>Bilangan anjing jantan</label>
                                     <asp:TextBox ID="TB_Jantan1_ins" runat="server" TextMode="Number" CssClass="form-control" />
                                 </div>
                             </div>

                             <div class="col-md-2">
                                 <div class="form-group">
                                     <label>Bilangan anjing betina</label>
                                     <asp:TextBox ID="TB_Betina1_ins" runat="server" TextMode="Number" CssClass="form-control" />
                                 </div>
                             </div>

                             <div class="col-md-2">
                                 <div class="form-group">
                                     <label>Bilangan anjing jantan mandul</label>
                                     <asp:TextBox ID="TB_JantanMandul1_ins" runat="server" TextMode="Number" CssClass="form-control" />
                                 </div>
                             </div>

                             <div class="col-md-4">
                                 <div class="form-group">
                                     <label>Bilangan anjing betina mandul</label>
                                     <div class="row">
                                         <div class="col">
                                             <asp:TextBox ID="TB_BetinaMandul1_ins" runat="server" TextMode="Number" CssClass="form-control" />
                                         </div>
                                         <div class="col">
                                             <asp:LinkButton ID="btnAddAnjing_ins" runat="server" CssClass="btn btn-primary" Text="Tambah" OnClick="btnAddAnjing_ins_Click" />
    
                                         </div>

                                     </div>
            
                                 </div>
                             </div>

                            </div>

                             <div class="row">
                                 <div class="col-md-12">
                                     <asp:GridView ID="gvAnjingList_ins" runat="server" HeaderStyle-ForeColor="Black" CssClass="table table-bordered" AutoGenerateColumns="False" 
                                         ShowHeaderWhenEmpty="true" EmptyDataText="Senarai kosong." OnRowDeleting="gvAnjingList_ins_RowDeleting">
                                         <Columns>
                                             <asp:BoundField DataField="Baka" HeaderText="Baka Anjing" />
                                             <asp:BoundField DataField="Jantan" HeaderText=" Bil. Jantan" />
                                             <asp:BoundField DataField="Betina" HeaderText="Bil. Betina" />
                                             <asp:BoundField DataField="JantanMandul" HeaderText="Bil. Jantan Mandul" />
                                             <asp:BoundField DataField="BetinaMandul" HeaderText="Bil. Betina Mandul" />
                                             <asp:TemplateField>
                                                 <ItemTemplate>
                                                     <asp:LinkButton ID="btnRemove_ins" runat="server"  
                                                         CommandName="Delete" CssClass="btn btn-danger btn-sm">&times;</asp:LinkButton>
                                                 </ItemTemplate>
                                             </asp:TemplateField>
                                         </Columns>
                                     </asp:GridView>
                                 </div>
                             </div>

                        </asp:Panel>

                        <%--# Penjaja #--%>
                        <asp:Panel ID="pnlesen4_ins" runat="server" Visible="False" Enabled="True">

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Alamat aktiviti penjajaan</label>
                                        <asp:TextBox ID="TB_AlamatPenjajaan_ins" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Jenis Perniagaan</label>
                                        <asp:TextBox ID="TB_JenisPerniagaanPenjaja_ins" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>

                        </asp:Panel>

                        <%--# Ekspo #--%>
                        <asp:Panel ID="pnlesen5_ins" runat="server" Visible="False" Enabled="True">

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Nama Penganjur</label>
                                        <asp:TextBox ID="TB_PenganjurEkspo_ins" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Nama Aktiviti/Program</label>
                                        <asp:TextBox ID="TB_NamaEkspo_ins" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Lokasi</label>
                                        <asp:TextBox ID="TB_LokasiEkspo_ins" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>No. Tel.</label>
                                        <asp:TextBox ID="TB_NoTel_ins" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>

                            <div class="row">

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Tarikh Mula</label>
                                        <asp:TextBox ID="TB_TarikhEkspo1_ins" runat="server" TextMode="Date" CssClass="form-control" />
                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Masa Mula</label>
                                        <asp:TextBox ID="TB_MasaEkspo1_ins" runat="server" TextMode="Time" CssClass="form-control" />
                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Tarikh Akhir</label>
                                        <asp:TextBox ID="TB_TarikhEkspo2_ins" runat="server" TextMode="Date" CssClass="form-control" />
                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Masa Akhir</label>
                                        <asp:TextBox ID="TB_MasaEkspo2_ins" runat="server" TextMode="Time" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>

                        </asp:Panel>
                        <div class="row">
                            <div class="col-md-10">
                                <asp:LinkButton ID="BT_Maklumat" runat="server" CausesValidation="False" Text="Kemaskini" CssClass="btn btn-warning" OnClick="btnSaveInfo_Click"/>
                            </div>
                        </div>
                        <br />
                    </ContentTemplate>
                </asp:TabPanel>

                <asp:TabPanel runat="server" ID="tabMesyuarat" HeaderText="Mesyuarat">
                    <HeaderTemplate>Mesyuarat</HeaderTemplate>
                    <ContentTemplate>
                        <br />
                        <div class="row">
                            <label>Maklumat Mesyuarat</label>
                        </div>
                        <br />

                        <div class="row">
                            <div class="col-md-3">

                                <div class="form-group">
                                    <label>Tarikh Mesyuarat</label>
                                    <asp:TextBox ID="TB_TarikhMesyuarat" runat="server" TextMode="Date" CssClass="form-control" />
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-3">

                                <div class="form-group">
                                    <label>No Mesyuarat</label>
                                    <asp:TextBox ID="TB_NoMesyuarat" runat="server" CssClass="form-control" />
                                </div>
                            </div>
                        </div>

                        <br />
                        <div class="row">
                            <div class="col-md-6">

                                <div class="form-group">
                                    <label runat="server">Hantar ke kewangan?</label>
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
                        <br />
                        <div class="row">
                            <div class="col-md-3 text-center">
                                <asp:LinkButton ID="BtnSaveMesyuarat" runat="server" CausesValidation="False" Text="Kemaskini" CssClass="btn btn-warning" OnClick="BtnSaveMesyuarat_Click" />
                            </div>
                        </div>
                        <br />

                    </ContentTemplate>
                </asp:TabPanel>

                <asp:TabPanel runat="server" ID="tabKadarBayaran" HeaderText="Kadar Bayaran">
                    <HeaderTemplate>Kadar Bayaran</HeaderTemplate>
                    <ContentTemplate>
                        <asp:GridView ID="gvTabBayaran" runat="server" ShowHeaderWhenEmpty="true"
                            AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="KadarBayaran_ID"
                            DataSourceID="SqlDataSourceTabBayaran"
                            CssClass="table table-bordered" Width="100%">
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
                                        Jabatan/Agensi :
                                        <asp:Label ID="lblJabatanAgensi_Description" runat="server" Text='<%# Eval("JabatanAgensi_Description") %>'></asp:Label>
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
                                        <asp:Label ID="lblKadarBayaran_Amount" runat="server" Text='<%# Eval("KadarBayaran_Amount", "{0:N2}") %>'></asp:Label>
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
                                        <asp:CheckBox ID="cbsel" runat="server" Enabled='<%# If(Eval("IsPublish") = False, True, False) %>' Checked='<%# Eval("IsSelect") %>' OnCheckedChanged="cbsel_CheckedChanged" AutoPostBack="true" />
                                    </ItemTemplate>
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
                                        <asp:LinkButton ID="lbEdit" runat="server" CausesValidation="False" CommandName="Edit" Text="Kemaskini"
                                            Visible='<%# If(IsDBNull(Eval("KadarBayaran_PermohonanAgensiID")), True, If(Eval("KadarBayaran_PermohonanAgensiID") = Session.Item("sessionEstateId"), True, False)) %>' CssClass="btn btn-warning btn-sm"></asp:LinkButton>
                                    </ItemTemplate>
                                    <HeaderStyle Width="10%" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:TemplateField>

                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        <asp:LinkButton ID="btnAddNew" runat="server" Text="+" CssClass="btn btn-warning btn-sm" ToolTip="Tambah" OnClick="btnAddNew_Click" />
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lbDelete" runat="server" CausesValidation="False" CssClass="btn btn-danger btn-sm"
                                            Visible='<%# If(IsDBNull(Eval("KadarBayaran_PermohonanAgensiID")), True, If(Eval("KadarBayaran_PermohonanAgensiID") = Session.Item("sessionEstateId"), True, False)) %>' CommandName="Delete" Text="Padam" OnClientClick="return confirm('Anda pasti untuk padam rekod ini?');"></asp:LinkButton>
                                    </ItemTemplate>
                                    <FooterStyle HorizontalAlign="Center" />
                                    <HeaderStyle Width="5%" HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:TemplateField>

                            </Columns>

                            <PagerStyle CssClass="pgr" />
                        </asp:GridView>

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

                <asp:TabPanel runat="server" ID="TabSurat" HeaderText="Surat Mohon Ulasan">
                    <HeaderTemplate>Surat</HeaderTemplate>
                    <ContentTemplate>
                        <br />

                        <asp:Panel ID="pnlSuratAuto" runat="server">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Tandatangan Agensi/Jabatan Dalaman</label>
                                        <asp:DropDownList ID="ddlTandatangan" CssClass="form-control select2" runat="server" AutoPostBack="false"
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
                                                and a.Users_IsPenilaian = 1 
                                                and b.JabatanAgensi_IsLesen = 1">
                                            <DeleteParameters>
                                                <asp:Parameter Name="JenisLesenAgensi_ID"></asp:Parameter>
                                            </DeleteParameters>
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[0]" Name="Permohonan_ID"></asp:ControlParameter>
                                                <%--<asp:SessionParameter SessionField="sessionEstateID" DefaultValue="0" Name="AgensiID"></asp:SessionParameter>--%>
                                            </SelectParameters>
                                        </asp:SqlDataSource>

                                    </div>
                                </div>
                            </div>
                            <br />

                            <div class="row">
                                <div class="col-md-6">

                                    <div class="form-group">
                                        <label>Tandatangan Agensi/Jabatan Luar</label>
                                        <asp:DropDownList ID="ddlTandatanganLuar" CssClass="form-control select2" runat="server" AutoPostBack="false"
                                            DataSourceID="sdsSignatureLuar" DataTextField="Users_Fullname" DataValueField="Users_Id">
                                        </asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="sdsSignatureLuar" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
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
                                                        and a.Users_IsPeraku = 1 
                                                        and b.JabatanAgensi_IsLesen = 1">
                                            <DeleteParameters>
                                                <asp:Parameter Name="JenisLesenAgensi_ID"></asp:Parameter>
                                            </DeleteParameters>
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[0]" Name="Permohonan_ID"></asp:ControlParameter>
                                                <%--<asp:SessionParameter SessionField="sessionEstateID" DefaultValue="0" Name="AgensiID"></asp:SessionParameter>--%>
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                    </div>
                                </div>
                            </div>
                        </asp:Panel>
                        <br />
                        <div class="row">
                            <div class="col-md-6 text-center">
                                <asp:LinkButton ID="btnSaveLetter" runat="server" CausesValidation="False" Text="Simpan" CssClass="btn btn-warning" OnClick="btnSaveLetter_Click" />
                            </div>
                        </div>
                        <br />
                    </ContentTemplate>
                </asp:TabPanel>

                <asp:TabPanel runat="server" ID="TabJabatanAgensi" HeaderText="Jabatan Agensi">
                    <HeaderTemplate>Jabatan Agensi</HeaderTemplate>
                    <ContentTemplate>
                        <div class="card">
                            <div class="card-body">

                                <div class="row">
                                    <div class="col-12">
                                        <asp:FormView ID="FormViewMaintenanceTemplate" Width="100%" DefaultMode="Insert" runat="server" DataKeyNames="PermohonanAgensi_ID" DataSourceID="SqlDataSourceFormviewMaintenanceTemplate">
                                            <InsertItemTemplate>
                                                <asp:Panel runat="server">
                                                    <div class="card card-default">
                                                        <div class="card-header">
                                                            <h3 class="card-title" style="color: black">Tambah Jabatan Agensi</h3>
                                                        </div>
                                                        <!-- /.card-header -->
                                                        <div class="card-body">
                                                            <div class="row">

                                                                <div class="col-md-6">
                                                                    <div class="form-group">
                                                                        <label>Jabatan Agensi</label>
                                                                        <asp:DropDownList ID="DDL_JabatanAgensi" Text='<%# Bind("JabatanAgensi_ID") %>' CssClass="form-control select2" runat="server"
                                                                            DataSourceID="SqlDataSourceJabatanAgensi" DataTextField="JabatanAgensi_Description" DataValueField="JabatanAgensi_ID">
                                                                        </asp:DropDownList>
                                                                        <asp:SqlDataSource runat="server" ID="SqlDataSourceJabatanAgensi" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                                            SelectCommand="select * from 
                                                                    (select NULL as JabatanAgensi_ID, '-- Sila Pilih --' as JabatanAgensi_Description
                                                                    union all
                                                                    select JabatanAgensi_ID,  JabatanAgensi_Description from LESEN_JabatanAgensi where JabatanAgensi_IsActive=1
                                                                    ) as tbl1 order by JabatanAgensi_Description "></asp:SqlDataSource>
                                                                    </div>
                                                                </div>

                                                            </div>
                                                        </div>
                                                        <div class="card-footer">
                                                            <asp:LinkButton runat="server" Text="+" CssClass="btn btn-primary" ValidationGroup="insertMaintenanceTemplateForm" CommandName="Insert" ID="LinkButton3" CausesValidation="True" />
                                                        </div>
                                                    </div>
                                                </asp:Panel>
                                            </InsertItemTemplate>
                                        </asp:FormView>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourceFormviewMaintenanceTemplate" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            InsertCommand="INSERT INTO LESEN_PermohonanAgensi(Permohonan_ID, JabatanAgensi_ID, IsMandatory) VALUES (@Permohonan_ID, @JabatanAgensi_ID, 1 ^ @Is24Jam); SELECT @PermohonanAgensi_ID = SCOPE_IDENTITY();"
                                            SelectCommand="SELECT a.PermohonanAgensi_ID, a.Permohonan_ID, a.JabatanAgensi_ID, b.StatusID FROM LESEN_PermohonanAgensi a
                                            INNER JOIN LESEN_Permohonan b ON a.Permohonan_ID = b.Permohonan_ID 
                                            WHERE PermohonanAgensi_ID = @PermohonanAgensi_ID">
                                            <InsertParameters>
                                                <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedValue" Name="Permohonan_ID"></asp:ControlParameter>
                                                <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[5]" Name="Is24Jam"></asp:ControlParameter>
                                                <asp:Parameter Name="JabatanAgensi_ID"></asp:Parameter>
                                                <asp:Parameter Name="PermohonanAgensi_ID" Type="Int32" Direction="Output" />
                                            </InsertParameters>
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="GridViewMaintenanceTemplate" PropertyName="SelectedValue" Name="PermohonanAgensi_ID"></asp:ControlParameter>
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                    </div>
                                </div>
                                <!-- /.tab-1 Formview -->
                                <div class="row">
                                    <div class="col-12">
                                        <asp:GridView ID="GridViewMaintenanceTemplate" HeaderStyle-ForeColor="Black" CssClass="table table-bordered" AllowPaging="True" ShowHeaderWhenEmpty="True" EmptyDataText="No records Found" AllowSorting="True" runat="server" AutoGenerateColumns="False" DataKeyNames="PermohonanAgensi_ID, JenisLesenIdList, IsMandatory, JabatanAgensi_ID" DataSourceID="SqlDataSourceGridMaintenanceTemplate">
                                            <Columns>
                                                <asp:BoundField DataField="JabatanAgensi_Description" HeaderText="Jabatan Agensi" SortExpression="JabatanAgensi_Description"></asp:BoundField>
                                                <asp:TemplateField HeaderText="ItemID" Visible="false">
                                                    <ItemTemplate>
                                                        <asp:Label ID="itemID" runat="server" Text='<%# Eval("PermohonanAgensi_ID") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField ShowHeader="True" HeaderText="Tindakan Wajib">
                                                    <EditItemTemplate>
                                                    </EditItemTemplate>
                                                    <ItemTemplate>
                                                        <asp:CheckBox ID="cbman" runat="server" Enabled='<%# If(Eval("StatusID") < 1, True, False) %>' Checked='<%# Eval("IsMandatory") %>' OnCheckedChanged="cbman_CheckedChanged" AutoPostBack="true" />
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField ShowHeader="False">
                                                    <EditItemTemplate>
                                                    </EditItemTemplate>
                                                    <ItemTemplate>
                                                        <asp:LinkButton runat="server" Text="Surat" CommandName="Surat" CausesValidation="False" ID="lbSurat" CssClass="btn btn-warning btn-sm" CommandArgument='<%# Container.DataItemIndex %>'></asp:LinkButton>
                                                        <asp:LinkButton runat="server" CommandName="Delete" Visible='<%# If(IsDBNull(Eval("reviewStatusID")), True, If(Eval("StatusID") < 1 And Eval("reviewStatusID") <> "2", True, False)) %>' CssClass="btn btn-default btn-sm" CommandArgument='<%# Container.DataItemIndex %>' OnClientClick="return confirm('Padam pilihan ini?');" data-toggle="tooltip" data-placement="top" title="Delete" CausesValidation="False" ID="LinkButton2">Padam</asp:LinkButton>
                                                        <asp:LinkButton runat="server"
                                                            OnClientClick="return confirm('Hantar Untuk Semakan?');"
                                                            CssClass='<%# If(IsDBNull(Eval("reviewStatusID")), "btn btn-warning btn-sm", If(Eval("reviewStatusID") = "1", "btn btn-warning btn-sm Disabled", If(Eval("reviewStatusID") = "2", "btn btn-warning btn-sm Disabled", If(Eval("reviewStatusID") = "3", "btn btn-warning btn-sm", "")))) %>'
                                                            Text='<%# If(IsDBNull(Eval("reviewStatusID")), "Hantar Untuk Semakan", If(Eval("reviewStatusID") = "1", "Dalam Proses Semakan", If(Eval("reviewStatusID") = "2", "Diluluskan", If(Eval("reviewStatusID") = "3", "Semakan Semula", "")))) %>'
                                                            readonly="true"
                                                            Enabled='<%# If(IsDBNull(Eval("reviewStatusID")), True, If(Eval("reviewStatusID") = "1", False, If(Eval("reviewStatusID") = "2", False, If(Eval("reviewStatusID") = "3", True, False)))) %>'
                                                            BackColor='<%# If(IsDBNull(Eval("reviewStatusID")), System.Drawing.ColorTranslator.FromHtml("#0000ff"), If(Eval("reviewStatusID") = "1", System.Drawing.ColorTranslator.FromHtml("#FFA500"), If(Eval("reviewStatusID") = "2", System.Drawing.ColorTranslator.FromHtml("#00FF00"), If(Eval("reviewStatusID") = "3", System.Drawing.ColorTranslator.FromHtml("#FF0000"), "")))) %>'
                                                            CommandName="review" CausesValidation="False" ID="LinkButton4" CommandArgument='<%# Container.DataItemIndex %>'></asp:LinkButton>

                                                        <div class="wrapperTooltip" runat="server" visible='<%# If(IsDBNull(Eval("reviewStatusID")), False, If(Eval("reviewStatusID") = "3", True, True)) %>'>
                                                            <span style="font-weight: normal" data-placement="top" title="Lihat Ulasan" class="badge badge-danger">Lihat Ulasan</span>
                                                            <div class="tooltip">
                                                                <label style="font-weight: bold; text-decoration: underline;">Ulasan Pengesah : </label>
                                                                <asp:Label ID="lblkbReview" runat="server" Text='<%# Eval("kbReview") %>'></asp:Label>
                                                                <br />
                                                                <%--<label style="font-weight: bold; text-decoration: underline;">Ulasan Peraku : </label>
                                                                <asp:Label ID="lblkjReview" runat="server" Text='<%# Eval("kjReview") %>'></asp:Label>--%>
                                                            </div>
                                                        </div>

                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourceGridMaintenanceTemplate" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            DeleteCommand="DELETE FROM LESEN_PermohonanAgensi WHERE PermohonanAgensi_ID = @PermohonanAgensi_ID"
                                            SelectCommand="SELECT kbReview,kjReview,reviewStatusID,a.PermohonanAgensi_ID, a.Permohonan_ID, b.JabatanAgensi_ID, b.JabatanAgensi_Description, a.StatusID AS StatusAgensi, c.StatusID, a.IsMandatory, c.JenisLesenIdList FROM LESEN_PermohonanAgensi a 
                                            INNER JOIN LESEN_JabatanAgensi b ON a.JabatanAgensi_ID = b.JabatanAgensi_ID 
                                            INNER JOIN LESEN_Permohonan c ON a.Permohonan_ID = c.Permohonan_ID
                                            WHERE a.Permohonan_ID = @Permohonan_ID">
                                            <DeleteParameters>
                                                <asp:Parameter Name="PermohonanAgensi_ID"></asp:Parameter>
                                            </DeleteParameters>
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedValue" Name="Permohonan_ID"></asp:ControlParameter>
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                    </div>
                                </div>
                                <!-- /.tab-1 Gridview -->
                            </div>
                        </div>
                    </ContentTemplate>
                </asp:TabPanel>

                <asp:TabPanel runat="server" ID="TabJabatanAgensiBatal" HeaderText="Jabatan Agensi Batal">
                    <HeaderTemplate>Jabatan Agensi</HeaderTemplate>
                    <ContentTemplate>
                        <div class="card">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-12">
                                        <asp:GridView ID="GridViewJabatanAgensiBatal" HeaderStyle-ForeColor="Black" CssClass="table table-bordered" AllowPaging="True" ShowHeaderWhenEmpty="True" EmptyDataText="No records Found" AllowSorting="True" runat="server" AutoGenerateColumns="False" DataKeyNames="PermohonanAgensi_ID, JenisLesen_ID, JabatanAgensi_ID" DataSourceID="SqlDataSourceGridJabatanAgensiBatal">
                                            <Columns>
                                                <asp:BoundField DataField="JabatanAgensi_Description" HeaderText="Jabatan Agensi" SortExpression="JabatanAgensi_Description"></asp:BoundField>
                                                <asp:TemplateField HeaderText="ItemID" Visible="false">
                                                    <ItemTemplate>
                                                        <asp:Label ID="itemID" runat="server" Text='<%# Eval("PermohonanAgensi_ID") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField ShowHeader="True" HeaderText="IsWajib?">
                                                    <EditItemTemplate>
                                                    </EditItemTemplate>
                                                    <ItemTemplate>
                                                        <asp:CheckBox ID="cbman" runat="server" Enabled='<%# If(Eval("StatusID") < 1, True, False) %>' Checked='<%# Eval("IsMandatory") %>' OnCheckedChanged="cbman_CheckedChanged2" AutoPostBack="true" />
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField ShowHeader="False">
                                                    <EditItemTemplate>
                                                    </EditItemTemplate>
                                                    <ItemTemplate>
                                                        <asp:LinkButton runat="server" Text="Surat" CommandName="Surat" CausesValidation="False" ID="lbSurat" CssClass="btn btn-warning btn-sm" CommandArgument='<%# Container.DataItemIndex %>'></asp:LinkButton>
                                                        <%--<asp:LinkButton runat="server" CommandName="Delete" Visible='<%# If(Eval("StatusID") < 1, True, False) %>' CssClass="btn btn-default btn-sm" OnClientClick="return confirm('Padam pilihan ini?');" data-toggle="tooltip" data-placement="top" title="Delete" CausesValidation="False" ID="LinkButton2">Padam</asp:LinkButton>--%>
                                                        <asp:LinkButton runat="server"
                                                            OnClientClick="return confirm('Hantar Untuk Semakan?');"
                                                            CssClass='<%# If(IsDBNull(Eval("reviewStatusID")), "btn btn-warning btn-sm", If(Eval("reviewStatusID") = "1", "btn btn-warning btn-sm Disabled", If(Eval("reviewStatusID") = "2", "btn btn-warning btn-sm Disabled", If(Eval("reviewStatusID") = "3", "btn btn-warning btn-sm", "")))) %>'
                                                            Text='<%# If(IsDBNull(Eval("reviewStatusID")), "Hantar Untuk Semakan", If(Eval("reviewStatusID") = "1", "Dalam Proses Semakan", If(Eval("reviewStatusID") = "2", "Diluluskan", If(Eval("reviewStatusID") = "3", "Semakan Semula", "")))) %>'
                                                            readonly="true"
                                                            Enabled='<%# If(IsDBNull(Eval("reviewStatusID")), True, If(Eval("reviewStatusID") = "1", False, If(Eval("reviewStatusID") = "2", False, If(Eval("reviewStatusID") = "3", True, False)))) %>'
                                                            BackColor='<%# If(IsDBNull(Eval("reviewStatusID")), System.Drawing.ColorTranslator.FromHtml("#0000ff"), If(Eval("reviewStatusID") = "1", System.Drawing.ColorTranslator.FromHtml("#FFA500"), If(Eval("reviewStatusID") = "2", System.Drawing.ColorTranslator.FromHtml("#00FF00"), If(Eval("reviewStatusID") = "3", System.Drawing.ColorTranslator.FromHtml("#FF0000"), "")))) %>'
                                                            CommandName="review" CausesValidation="False" ID="LinkButton4" CommandArgument='<%# Container.DataItemIndex %>'></asp:LinkButton>

                                                        <div class="wrapperTooltip" runat="server" visible='<%# If(IsDBNull(Eval("reviewStatusID")), False, If(Eval("reviewStatusID") = "3", True, False)) %>'>
                                                            <span style="font-weight: normal" data-placement="top" title="Lihat Ulasan" class="badge badge-danger">Lihat Ulasan</span>
                                                            <div class="tooltip">
                                                                <label style="font-weight: bold; text-decoration: underline;">Ulasan Pengesah : </label>
                                                                <asp:Label ID="lblkbReview" runat="server" Text='<%# Eval("kbReview") %>'></asp:Label>
                                                                <br />
                                                                <label style="font-weight: bold; text-decoration: underline;">Ulasan Peraku : </label>
                                                                <asp:Label ID="lblkjReview" runat="server" Text='<%# Eval("kjReview") %>'></asp:Label>
                                                            </div>
                                                        </div>

                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourceGridJabatanAgensiBatal" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            DeleteCommand="DELETE FROM LESEN_PermohonanAgensiBatal WHERE PermohonanAgensi_ID = @PermohonanAgensi_ID"
                                            SelectCommand="SELECT kbReview,kjReview,reviewStatusID,a.PermohonanAgensi_ID, a.Permohonan_ID, b.JabatanAgensi_ID, b.JabatanAgensi_Description, a.StatusID AS StatusAgensi, c.StatusID, a.IsMandatory, c.JenisLesenIdlist FROM LESEN_PermohonanAgensiBatal a 
                                            INNER JOIN LESEN_JabatanAgensi b ON a.JabatanAgensi_ID = b.JabatanAgensi_ID 
                                            INNER JOIN LESEN_Permohonan c ON a.Permohonan_ID = c.Permohonan_ID
                                            WHERE a.Permohonan_ID = @Permohonan_ID">
                                            <DeleteParameters>
                                                <asp:Parameter Name="PermohonanAgensi_ID"></asp:Parameter>
                                            </DeleteParameters>
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedValue" Name="Permohonan_ID"></asp:ControlParameter>
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                    </div>
                                </div>
                                <!-- /.tab-1 Gridview -->
                            </div>
                        </div>
                    </ContentTemplate>
                </asp:TabPanel>

                <asp:TabPanel runat="server" ID="TabLog" HeaderText="Log Kelulusan">
                    <HeaderTemplate>Log Kelulusan</HeaderTemplate>
                    <ContentTemplate>
                        <div class="card">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-12">
                                        <asp:GridView ID="GridViewLogKelulusan" HeaderStyle-ForeColor="Black" CssClass="table table-bordered" AllowPaging="True" ShowHeaderWhenEmpty="True" EmptyDataText="No records Found" AllowSorting="True" runat="server" AutoGenerateColumns="False" DataKeyNames="ApprovalID" DataSourceID="SqlDataSourceLogKelulusan">
                                            <Columns>
                                                <asp:BoundField DataField="ApprovalDate" HeaderText="Tarikh/Masa Tindakan" SortExpression="ApprovalDate"></asp:BoundField>
                                                <asp:BoundField DataField="JabatanAgensi_Description" HeaderText="Jabatan Agensi" SortExpression="JabatanAgensi_Description"></asp:BoundField>
                                                <asp:BoundField DataField="Description" HeaderText="Status" SortExpression="Description"></asp:BoundField>
                                                <asp:BoundField DataField="ActionBy" HeaderText="Tindakan oleh" SortExpression="ActionBy"></asp:BoundField>
                                            </Columns>
                                        </asp:GridView>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourceLogKelulusan" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            SelectCommand="SELECT a.ApprovalDate, a.ApprStatusID, c.JabatanAgensi_Description, b.Description, a.ApprovalID, d.Users_Fullname, 
(CASE WHEN a.ApprStatusID = 3 then (SELECT STRING_AGG(d1.Users_Fullname, ', ') FROM LESEN_PermohonanAgensiStaff a1 
INNER JOIN LESEN_PermohonanAgensi b1 ON b1.Permohonan_ID = @Permohonan_ID and b1.PermohonanAgensi_ID = a1.PermohonanAgensi_ID
INNER JOIN TBL_USERS d1 ON d1.Users_Id = a1.PermohonanAgensiStaffID_UsersID) WHEN a.ApprStatusID = 1 then f.Users_Fullname ELSE d.Users_Fullname END) AS ActionBy
FROM LESEN_ApprovalList a 
                                                inner join ApprovalStatus b on b.ApprStatusID = a.ApprStatusID 
                                                left join LESEN_JabatanAgensi c on c.JabatanAgensi_ID = a.AgensiID
                                                left join TBL_USERS d on d.Users_Id = a.ApproverID
                                                inner join LESEN_Permohonan e on a.Permohonan_ID = e.Permohonan_ID
												left join TBL_USERS f on f.Users_Name = e.CreatorID
                                                WHERE a.Permohonan_ID = @Permohonan_ID and ApprovalDate is not null
												UNION ALL
												(SELECT TOP(1) a.ApprovalDate,  a.ApprStatusID, b.JabatanAgensi_Description, a.Description, a.ApprovalID, d.Users_Fullname,
												(CASE WHEN a.ApprStatusID = 3 then (SELECT STRING_AGG(d1.Users_Fullname, ', ') FROM LESEN_PermohonanAgensiStaff a1 
INNER JOIN LESEN_PermohonanAgensi b1 ON b1.Permohonan_ID = @Permohonan_ID and b1.PermohonanAgensi_ID = a1.PermohonanAgensi_ID
INNER JOIN TBL_USERS d1 ON d1.Users_Id = a1.PermohonanAgensiStaffID_UsersID) ELSE d.Users_Fullname END) AS ActionBy 
FROM v_LESEN_ApprovalList_Curr a 
                                                left join LESEN_JabatanAgensi b on b.JabatanAgensi_ID = a.AgensiID 
                                                left join TBL_USERS d on d.Users_Id = a.ApproverID 
                                                WHERE a.Permohonan_ID = @Permohonan_ID and ApprovalDate is null)">
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedValue" Name="Permohonan_ID"></asp:ControlParameter>
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                    </div>
                                </div>
                                <!-- /.tab-1 Gridview -->
                            </div>
                        </div>
                    </ContentTemplate>
                </asp:TabPanel>

                <asp:TabPanel runat="server" ID="TabLogBatal" HeaderText="Log Pembatalan">
                    <HeaderTemplate>Log Pembatalan</HeaderTemplate>
                    <ContentTemplate>
                        <div class="card">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-12">
                                        <asp:GridView ID="GridViewLogBatal" HeaderStyle-ForeColor="Black" CssClass="table table-bordered" AllowPaging="True" ShowHeaderWhenEmpty="True" EmptyDataText="No records Found" AllowSorting="True" runat="server" AutoGenerateColumns="False" DataKeyNames="ApprovalID" DataSourceID="SqlDataSourceLogBatal">
                                            <Columns>
                                                <asp:BoundField DataField="ApprovalDate" HeaderText="Tarikh/Masa Tindakan" SortExpression="ApprovalDate"></asp:BoundField>
                                                <asp:BoundField DataField="JabatanAgensi_Description" HeaderText="Jabatan Agensi" SortExpression="JabatanAgensi_Description"></asp:BoundField>
                                                <asp:BoundField DataField="Description" HeaderText="Status" SortExpression="Description"></asp:BoundField>
                                                <asp:BoundField DataField="ActionBy" HeaderText="Tindakan oleh" SortExpression="ActionBy"></asp:BoundField>
                                            </Columns>
                                        </asp:GridView>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourceLogBatal" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            SelectCommand="SELECT a.ApprovalDate, a.ApprStatusID, c.JabatanAgensi_Description, b.Description, a.ApprovalID, d.Users_Fullname, 
(CASE WHEN a.ApprStatusID = 3 then (SELECT STRING_AGG(d1.Users_Fullname, ', ') FROM LESEN_PermohonanAgensiStaffBatal a1 
INNER JOIN LESEN_PermohonanAgensiBatal b1 ON b1.Permohonan_ID = @Permohonan_ID and b1.PermohonanAgensi_ID = a1.PermohonanAgensi_ID
INNER JOIN TBL_USERS d1 ON d1.Users_Id = a1.PermohonanAgensiStaffID_UsersID) ELSE d.Users_Fullname END) AS ActionBy
FROM LESEN_ApprovalListBatal a 
                                                inner join ApprovalStatus b on b.ApprStatusID = a.ApprStatusID 
                                                left join LESEN_JabatanAgensi c on c.JabatanAgensi_ID = a.AgensiID
                                                left join TBL_USERS d on d.Users_Id = a.ApproverID
                                                WHERE a.Permohonan_ID = @Permohonan_ID and ApprovalDate is not null
												UNION ALL
												(SELECT TOP(1) a.ApprovalDate,  a.ApprStatusID, b.JabatanAgensi_Description, a.Description, a.ApprovalID, d.Users_Fullname,
												(CASE WHEN a.ApprStatusID = 3 then (SELECT STRING_AGG(d1.Users_Fullname, ', ') FROM LESEN_PermohonanAgensiStaffBatal a1 
INNER JOIN LESEN_PermohonanAgensiBatal b1 ON b1.Permohonan_ID = @Permohonan_ID and b1.PermohonanAgensi_ID = a1.PermohonanAgensi_ID
INNER JOIN TBL_USERS d1 ON d1.Users_Id = a1.PermohonanAgensiStaffID_UsersID) ELSE d.Users_Fullname END) AS ActionBy 
FROM v_LESEN_ApprovalListBatal_Curr a 
                                                left join LESEN_JabatanAgensi b on b.JabatanAgensi_ID = a.AgensiID 
                                                left join TBL_USERS d on d.Users_Id = a.ApproverID 
                                                WHERE a.Permohonan_ID = @Permohonan_ID and ApprovalDate is null)">
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedValue" Name="Permohonan_ID"></asp:ControlParameter>
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                    </div>
                                </div>
                                <!-- /.tab-1 Gridview -->
                            </div>
                        </div>
                    </ContentTemplate>
                </asp:TabPanel>

            </asp:TabContainer>

        </div>
    </section>
    <asp:Button ID="ui_btnPageBottom" runat="server" Text="-" Style="margin-left: -999px;" />
    <%--</ContentTemplate>
    </asp:UpdatePanel>--%>

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

