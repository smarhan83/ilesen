<%@ Page MaintainScrollPositionOnPostback="true" Title="" Language="VB" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="semakpembatalan.aspx.vb" Inherits="pembatalan" %>

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
            /*background-color : #ffffff !important;*/
            font-weight: normal !important;
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

            <asp:FormView ID="FormView1" runat="server" DataKeyNames="JenisLesen_ID, Permohonan_ID, ApprStatusID"
                DataSourceID="SqlDataSourceForm" DefaultMode="Edit" Width="100%" CssClass="CustomTab">
                <EditItemTemplate>

                    <div class="card card-warning">
                        <div class="card-header">
                            <h3 class="card-title">
                                <div runat="server" id="idWindowTitle2">Maklumat</div>
                                <h3></h3>
                                <div class="card-tools">
                                    <button class="btn btn-tool" data-card-widget="collapse" type="button">
                                        <i class="fas fa-minus"></i>
                                    </button>
                                </div>
                            </h3>

                        </div>
                        <!-- /.card-header -->
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Nama Pemohon</label>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("Pemohon_Name") %>' CssClass="form-control"></asp:Label>
                                    </div>
                                </div>

                                <div class="col-md-6">

                                    <div class="form-group">
                                        <label>Tarikh mohon</label>
                                        <asp:Label ID="Label2" runat="server" Text='<%# Eval("TarikhMohon", "{0:yyyy-MM-dd}") %>' CssClass="form-control"></asp:Label>
                                    </div>

                                </div>

                            </div>


                            <div class="row">

                                <div class="col-md-6">

                                    <div class="form-group">
                                        <label>Jenis Lesen</label>
                                        <asp:Label ID="Label3" runat="server" Text='<%# Bind("JenisLesen_Description") %>' CssClass="form-control"></asp:Label>
                                    </div>
                                </div>

                                <div class="col-md-3" runat="server">

                                    <div class="form-group">
                                        <label>&nbsp; </label>
                                        <asp:HyperLink ID="HyperLink1" runat="server"
                                            CssClass="btn btn-primary form-control" NavigateUrl='<%# "~/lesen/appregister.aspx?p_Id=3348&m_Id=3349&pid=" + Eval("Permohonan_ID").ToString() %>' Target="_blank">Lihat Maklumat Permohonan</asp:HyperLink>
                                    </div>
                                </div>

                                <!-- /.col -->
                            </div>
                            <!-- /.row -->
                            <hr />
                            <div class="row">

                                <div class="col-md-6">

                                    <div class="form-group">
                                        <label>Nota (Kelulusan)</label>
                                        <asp:Label ID="Label6" runat="server" Text='<%# Bind("NotaKelulusan") %>' Height="114" CssClass="form-control"></asp:Label>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Status</label>
                                        <asp:Label ID="Label5" runat="server" Text='<%# Eval("Description") %>' CssClass="form-control"></asp:Label>
                                    </div>
                                </div>

                            </div>

                        </div>
                        <!-- /.card-body -->
                        <div class="card-footer">
						
                            <asp:LinkButton ID="btnBack" runat="server" CausesValidation="False" Text="Kembali ke senarai" CssClass="btn btn-default" OnClick="btnBack_Click" />
                            <asp:LinkButton runat="server" CssClass="btn btn-warning" CausesValidation="False" Text="Lihat Surat Mohon Ulasan" ID="BT_SuratMohonUlasan" Visible='<%# If(CInt(Session.Item("sessionEstateId")) = 1, False, True) %>' OnCommand="BT_SuratMohonUlasan_Command" />
                            <asp:LinkButton runat="server" CssClass="btn btn-warning" ValidationGroup="updateForm" Text="Jana Surat" ID="BT_Generate" Visible='<%# If(Eval("IsPublish") = True, False, True) %>' OnCommand="BT_Generate_Command" CausesValidation="True" OnClientClick="return confirm('Jana surat ke template asal?');"/>
                            <asp:LinkButton runat="server" CssClass="btn btn-warning" ValidationGroup="updateForm" Text="Lihat Surat" ID="BT_ViewMail" OnCommand="BT_ViewMail_Command" CausesValidation="False" />
                            <label style="margin-left: 50px;">Terbit Pembatalan?</label>
                            <asp:CheckBox ID="CB_IsPublish" runat="server" Checked='<%# Eval("IsPublish") %>' OnCheckedChanged="CB_IsPublish_CheckedChanged" AutoPostBack="true" />

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
                inner join LESEN_JenisLesen d on d.JenisLesen_ID = a.JenisLesen_ID
                inner join LESEN_Pemohon f on f.Pemohon_ID = a.Permohonan_PemohonID
                inner join LESEN_Permohonan g on g.Permohonan_ID = a.Permohonan_ID
                where a.Permohonan_ID = @Permohonan_ID ORDER BY ApprovalID Desc"
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

                <asp:TabPanel runat="server" ID="tabSurat" HeaderText="Surat">
                    <HeaderTemplate>Surat</HeaderTemplate>
                    <ContentTemplate>
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

                            <div class="row">
                                <div class="col-md-2">
                                    <div class="form-group">
                                        <label>Tarikh Surat</label>
                                        <asp:TextBox ID="TB_TarikhSurat" runat="server" TextMode="Date" CssClass="form-control" />
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-10">
                                    <div class="form-group">
                                        <label>Isi Kandungan Utama (Seksyen atas)</label>
                                        <asp:TextBox ID="EditorSurat1" runat="server" Text="" TextMode="MultiLine" Rows="10" CssClass="form-control"></asp:TextBox>
                                        <asp:HtmlEditorExtender ID="HtmlEditorExtender2" runat="server" TargetControlID="EditorSurat1" DisplaySourceTab="True">
                                            <%--<Toolbar>
                                                <ajaxToolkit:Undo />
                                                <ajaxToolkit:Redo />
                                                <ajaxToolkit:Bold />
                                                <ajaxToolkit:Italic />
                                                <ajaxToolkit:Underline />
                                                <ajaxToolkit:RemoveFormat />
                                                <ajaxToolkit:SelectAll />
                                                <ajaxToolkit:UnSelect />
                                                <ajaxToolkit:Delete />
                                                <ajaxToolkit:Cut />
                                                <ajaxToolkit:Copy />
                                                <ajaxToolkit:Paste />
                                            </Toolbar>--%>
                                        </asp:HtmlEditorExtender>
                                    </div>
                                </div>
                            </div>

                            <div class="row">

                                <div class="col-md-10">

                                    <div class="form-group">
                                        <label>Isi Kandungan Utama (Seksyen bawah)</label>
                                        <asp:TextBox ID="EditorSurat2" runat="server" Text="" TextMode="MultiLine" Rows="10" CssClass="form-control"></asp:TextBox>
                                        <asp:HtmlEditorExtender ID="HtmlEditorExtender4" runat="server" TargetControlID="EditorSurat2" DisplaySourceTab="True">
                                            <%--<Toolbar>
                                                <ajaxToolkit:Undo />
                                                <ajaxToolkit:Redo />
                                                <ajaxToolkit:Bold />
                                                <ajaxToolkit:Italic />
                                                <ajaxToolkit:Underline />
                                                <ajaxToolkit:RemoveFormat />
                                                <ajaxToolkit:SelectAll />
                                                <ajaxToolkit:UnSelect />
                                                <ajaxToolkit:Delete />
                                                <ajaxToolkit:Cut />
                                                <ajaxToolkit:Copy />
                                                <ajaxToolkit:Paste />
                                            </Toolbar>--%>
                                        </asp:HtmlEditorExtender>
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
                            <div class="col-md-10 text-center">
                                <asp:LinkButton ID="btnSaveLetter" runat="server" CausesValidation="False" Text="Kemaskini" CssClass="btn btn-warning" OnClick="btnSaveLetter_Click" />
                            </div>
                        </div>
                        <br />

                    </ContentTemplate>
                </asp:TabPanel>

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
                                                    <div class ="col">
                                                        <asp:FileUpload ID="FU_Lampiran1" runat="server" CssClass="form-control"/>
                                                        <asp:HyperLink ID="HL_Lampiran1" NavigateUrl="#" Text="null" runat="server" />
                                                    </div>
                                                    <div class ="col">
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
                                                    <div class ="col">
                                                        <asp:FileUpload ID="FU_Lampiran2" runat="server" CssClass="form-control"/>
                                                        <asp:HyperLink ID="HL_Lampiran2" NavigateUrl="#" Text="null" runat="server" />
                                                    </div>
                                                    <div class ="col">
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
                                        <asp:FileUpload ID="txtUlasanFail_FilePath" runat="server" CssClass="form-control"></asp:FileUpload>
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
                                        <%--<br />
                                        <asp:LinkButton ID="lbEditMobile" runat="server" CausesValidation="False" CommandName="Edit" Text="Kemaskini" CssClass="btn btn-warning btn-sm"></asp:LinkButton>
                                    --%></ItemTemplate>
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

                                    </EditItemTemplate>
                                    <ItemStyle HorizontalAlign="Left" />
                                </asp:TemplateField>

                            </Columns>

                            <PagerStyle CssClass="pgr" />
                        </asp:GridView>

                        <asp:SqlDataSource ID="SqlDataSourceTabUlasan" runat="server"
                            ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                            SelectCommand=" SELECT a.*,b.JabatanAgensi_Description FROM LESEN_UlasanFailBatal a
                        left join LESEN_JabatanAgensi b on b.JabatanAgensi_ID = a.UlasanFail_PermohonanAgensiID
                        where UlasanFail_PermohonanID = @PermohonanID 
                        and case when (select top 1 x.JabatanAgensi_IsLesen from LESEN_JabatanAgensi x where x.JabatanAgensi_ID = @AgensiID) = 1 then 0 when cast(@AgensiID as int) &gt; 0 then UlasanFail_PermohonanAgensiID else 0 end 
						= case when (select top 1 x.JabatanAgensi_IsLesen from LESEN_JabatanAgensi x where x.JabatanAgensi_ID = @AgensiID) = 1 then 0 when cast(@AgensiID as int) &gt; 0 then cast(@AgensiID as int) else 0 end 
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
                                <%--<asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[1]" Name="AgensiID"></asp:ControlParameter>--%>
								<asp:SessionParameter SessionField="sessionEstateID" DefaultValue="0" Name="AgensiID"></asp:SessionParameter>

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

                <asp:TabPanel runat="server" ID="tabWangAmanah" HeaderText="Wang Amanah">
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

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>Tindakan Pembatalan</label>
                                    <asp:DropDownList ID="DDL_TindakanBatal" CssClass="form-control select2" runat="server"
                                        DataSourceID="SqlDataSourceTindakan" DataTextField="name" DataValueField="id">
                                    </asp:DropDownList>
                                    <asp:SqlDataSource runat="server" ID="SqlDataSourceTindakan" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                        SelectCommand="SELECT id, name 
                                            FROM TBL_LOOKUPS WHERE lookupgrp_id = 10005 AND status = 1"></asp:SqlDataSource>
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

            </asp:TabContainer>

            <div class="card" runat="server" id="idListing">
                <div class="card-body" style="overflow-x: auto;">
                    <%--# START FILTER - set SortExpression at GridView as fieldname & add WHERE 1=1 at SqlDataSource - SelectCommand #--%>
                    <div class="row">
                        <div class="col-md-10">
                            <%--<div id="pnlFilter" runat="server" class="row"></div>--%>

                            <div class="row">

                                <div class="col-md-3">

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
                                        (select 0 as JenisLesen_ID, '-- Lesen --' as JenisLesen_Description
                                        union all
                                        select JenisLesen_ID,  JenisLesen_Description from LESEN_JenisLesen where JenisLesen_IsActive=1
                                        ) as tbl1 order by JenisLesen_Description "></asp:SqlDataSource>
                                    </div>

                                </div>

                                <%--<div class="col-md-3" runat="server" id="filterPemohon">
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
                                </div>--%>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <asp:TextBox ID="TB_TarikhBatal" runat="server"
                                            TextMode="Date" CssClass="form-control" />
                                    </div>
                                </div>

                                <div class="col-md-2" runat="server" id="filterStatus">
                                    <asp:DropDownList ID="ddlStatus" CssClass="form-control select2" runat="server" AutoPostBack="false"
                                        DataSourceID="sdsStatus" DataTextField="Description" DataValueField="ApprStatusID">
                                    </asp:DropDownList>
                                    <asp:SqlDataSource runat="server" ID="sdsStatus" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                        SelectCommand="select * from 
                                        (select -1 as ApprStatusID, '-- Status --' as Description
                                        union all
                                        select ApprStatusID,  Description from ApprovalStatusBatal
                                        WHERE ApprStatusID > 8) as tbl1 order by ApprStatusID "></asp:SqlDataSource>
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

                    <asp:GridView ID="GridView1" runat="server" Visible="true"
                        AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="Permohonan_ID,StatusID,JenisLesen_ID,IsSuratPembatalanFail,IsPublish"
                        DataSourceID="SqlDataSourceGrid"
                        CssClass="table table-bordered" PagerStyle-CssClass="pgr"
                        AlternatingRowStyle-CssClass="alt" AllowPaging="True" PageSize="20">
                        <AlternatingRowStyle CssClass="alt" />
                        <Columns>
                            <%--<asp:BoundField DataField="Permohonan_ID" HeaderText="ID" InsertVisible="False"
                                ReadOnly="True" SortExpression="JenisLesen_ID" />--%>
                            <asp:BoundField DataField="RowNo" HeaderText="No" SortExpression="RowNo"></asp:BoundField>
                            <asp:BoundField DataField="Rujukan" HeaderText="No Rujukan"
                                SortExpression="Rujukan" />
                            <asp:BoundField DataField="JenisLesen_Description" HeaderText="Jenis Lesen"
                                SortExpression="JenisLesen_Description" />
                            <asp:BoundField DataField="Pemohon_Name" HeaderText="Nama Pemohon"
                                SortExpression="Pemohon_Name" />
                            <asp:BoundField DataField="CreatedDt" HeaderText="Tarikh Batal" DataFormatString="{0:dd/MM/yyyy}"
                                SortExpression="CreatedDt" />
                            <asp:BoundField DataField="StatusDesc" HeaderText="Status"
                                SortExpression="StatusDesc" />

                            <asp:TemplateField HeaderText="Maklumat Permohonan" HeaderStyle-Font-Size="10pt" HeaderStyle-Width="90%" ItemStyle-Width="90%">
                                <ItemTemplate>
                                    <asp:Label ID="Label4" runat="server" Text="No Rujukan :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                    <asp:Label ID="Label8" runat="server" Text='<%# Eval("Rujukan") %>' Font-Size="10pt"></asp:Label><br />
                                    <asp:Label ID="Label15" runat="server" Text="Tarikh Batal :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                    <asp:Label ID="Label16" runat="server" Text='<%# Eval("CreatedDt", "{0:dd/MM/yyyy}") %>' Font-Size="10pt"></asp:Label><br />
                                    <asp:Label ID="Label9" runat="server" Text="Jenis Lesen :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                    <asp:Label ID="Label10" runat="server" Text='<%# Eval("JenisLesen_Description") %>' Font-Size="10pt"></asp:Label><br />
                                    <asp:Label ID="Label11" runat="server" Text="Nama Pemohon :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                    <asp:Label ID="Label12" runat="server" Text='<%# Eval("Pemohon_Name") %>' Font-Size="10pt"></asp:Label><br />
                                    <asp:Label ID="Label17" runat="server" Text="Status :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                    <asp:Label ID="Label18" runat="server" Text='<%# Eval("StatusDesc") %>' Font-Size="10pt"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:TemplateField>

                            <%--<asp:CheckBoxField DataField="JenisLesen_IsActive" HeaderText="Aktif?" SortExpression="JenisLesen_IsActive" />--%>
                            <asp:TemplateField ShowHeader="False">
                                <ItemTemplate>


                                    <%--  <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False"
                                        CommandName="Delete" Text="Nyah Aktif" OnClientClick="return confirm('Anda Pasti Untuk Nyah Aktif rekod ini?');" CssClass="btn btn-danger btn-sm"></asp:LinkButton>--%>

                                    <asp:LinkButton runat="server" Text="Lihat" CommandName="Select" CausesValidation="False"
                                        ID="LinkButton5" Visible='<%# If(Eval("UserType") > 0 And Eval("StatusID") > 8, True, False) %>' CssClass="btn btn-warning btn-sm"></asp:LinkButton>

                                    <asp:LinkButton runat="server" Text="Surat" CommandName="Surat" CausesValidation="False" ID="LinkButton6"
                                        Visible='<%# If(Eval("UserType") > 0 And Eval("IsPublish") = True, True, False) %>'
                                        CssClass="btn btn-warning btn-sm" CommandArgument='<%# Container.DataItemIndex %>'></asp:LinkButton>

                                    <asp:LinkButton runat="server" Text="Lampiran 1" CommandName="Lampiran1" CausesValidation="False" ID="LinkButton7"
                                        Visible='<%# If(Eval("UserType") > 0 And Eval("IsPublish") = True, True, False) %>'
                                        CssClass="btn btn-warning btn-sm" CommandArgument='<%# Container.DataItemIndex %>'></asp:LinkButton>

                                    <asp:LinkButton runat="server" Text="Lampiran 2" CommandName="Lampiran2" CausesValidation="False" ID="LinkButton3"
                                        Visible='<%# If(Eval("UserType") > 0 And Eval("IsPublish") = True, True, False) %>'
                                        CssClass="btn btn-warning btn-sm" CommandArgument='<%# Container.DataItemIndex %>'></asp:LinkButton>

                                    <%--<div>
                                        <div class="row">
                                            <div class="col-md-6">

                                                <div class="form-group">
                                                    <asp:LinkButton runat="server" Text="Lihat" CommandName="Select" CausesValidation="False"
                                                        ID="lbLihat" CssClass="btn btn-warning btn-sm"></asp:LinkButton>
                                                </div>

                                            </div>

                                        </div>

                                    </div>--%>
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
        SelectCommand="SELECT ROW_NUMBER() OVER(ORDER BY TarikhMohon desc, Permohonan_ID desc) as RowNo, * FROM (
            SELECT ROW_NUMBER() OVER (PARTITION BY a.Permohonan_ID ORDER BY a.ApprovalID DESC) AS RepNo,
            (CASE WHEN a.ApprStatusID < 9 AND ISNULL(a.AgensiID, 0) > 0 then a.Description + ' - ' + e.JabatanAgensi_Description ELSE a.Description END) AS StatusDesc,
            @AgensiID AS UserType, a.*, d.JenisLesen_Description, g.Rujukan, g.IsSuratPembatalanFail, g.StatusID, g.IsPublish, f.Pemohon_Name, h.CreatedDt FROM 
            v_LESEN_ApprovalListBatal_Curr a 
            inner join LESEN_JenisLesen d on d.JenisLesen_ID = a.JenisLesen_ID 
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
            and a.JenisLesen_ID = case when @lesenID = 0 then a.JenisLesen_ID else @lesenID end
            and (CONVERT(VARCHAR(25), h.CreatedDt, 126) LIKE '%'+@TarikhBatal+'%' 
            or h.CreatedDt IS NULL)
            and a.ApprStatusID = case when @statusID = -1 then a.ApprStatusID else @statusID end
            and g.StatusID > 0 
            and g.IsBatal = 1 
            ) AS tbl WHERE RepNo = 1 order by TarikhMohon desc, Permohonan_ID desc"
        DeleteCommand="Update LESEN_JenisLesen set JenisLesen_IsActive = 0 WHERE JenisLesen_ID = @JenisLesen_ID">
        <DeleteParameters>
            <asp:ControlParameter ControlID="GridView1" DefaultValue="" Name="JenisLesen_ID" PropertyName="SelectedValue" />
        </DeleteParameters>

        <SelectParameters>
            <asp:SessionParameter SessionField="sessionEstateID" DefaultValue="0" Name="AgensiID"></asp:SessionParameter>
            <%--<asp:SessionParameter SessionField="sessionIsPenyedia" DefaultValue="0" Name="isPenyedia"></asp:SessionParameter>
            <asp:SessionParameter SessionField="sessionIsPenilai" DefaultValue="0" Name="isPenilai"></asp:SessionParameter>
            <asp:SessionParameter SessionField="sessionIsPeraku" DefaultValue="0" Name="isPeraku"></asp:SessionParameter>--%>

            <asp:ControlParameter ControlID="txtNoRujukan" PropertyName="Text" DefaultValue="%%" Name="Rujukan"></asp:ControlParameter>
            <asp:ControlParameter ControlID="DDL_JenisLesen" PropertyName="SelectedValue" Name="lesenID"></asp:ControlParameter>
            <asp:ControlParameter ControlID="TB_TarikhBatal" PropertyName="Text" DefaultValue="%%" Name="TarikhBatal"></asp:ControlParameter>
            <asp:ControlParameter ControlID="ddlStatus" PropertyName="SelectedValue" Name="statusID"></asp:ControlParameter>
        </SelectParameters>
    </asp:SqlDataSource>

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

