<%@ Page MaintainScrollPositionOnPostback="true" Title="" Language="VB" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="kelulusan1.aspx.vb" Inherits="kelulusan1" %>

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
        /*.MyTabStyle .ajax__tab_header
        {
            font-family: "Helvetica Neue" , Arial, Sans-Serif;
            font-size: 14px;
            font-weight:bold;
            display: block;

        }
        .MyTabStyle .ajax__tab_header .ajax__tab_outer
        {
            border-color: #222;
            color: #222;
            padding-left: 10px;
            margin-right: 3px;
            border:solid 1px #d7d7d7;
        }
        .MyTabStyle .ajax__tab_header .ajax__tab_inner
        {
            border-color: #666;
            color: #666;
            padding: 3px 10px 2px 0px;
        }
        .MyTabStyle .ajax__tab_hover .ajax__tab_outer
        {
            background-color:#9c3;
        }
        .MyTabStyle .ajax__tab_hover .ajax__tab_inner
        {
            color: #fff;
        }
        .MyTabStyle .ajax__tab_active .ajax__tab_outer
        {
            border-bottom-color: #ffffff;
            background-color: #d7d7d7;
        }
        .MyTabStyle .ajax__tab_active .ajax__tab_inner
        {
            color: #000;
            border-color: #333;
        }
        .MyTabStyle .ajax__tab_body
        {
            font-family: verdana,tahoma,helvetica;
            font-size: 10pt;
            background-color: #fff;
            border-top-width: 0;
            border: solid 1px #d7d7d7;
            border-top-color: #ffffff;
        }
*/


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
            width: 120px !important;
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
            width: 120px !important;
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

            <asp:FormView ID="FormView1" runat="server" DataKeyNames="JenisLesen_ID"
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

                                <div class="col-md-4">

                                    <div class="form-group">
                                        <label>Jenis Lesen</label>
                                        <asp:Label ID="Label3" runat="server" Text='<%# Bind("JenisLesenDescList") %>' CssClass="form-control"></asp:Label>
                                    </div>
                                </div>
								
                                <div class="col-md-4">

                                    <div class="form-group">
                                        <label>Jenis Perniagaan</label>
                                        <asp:Label ID="Label22" runat="server" Text='<%# Bind("JenisPerniagaan") %>' CssClass="form-control"></asp:Label>
                                    </div>
                                </div>								

                                <div class="col-md-4" runat="server" visible='<%# If(IsDBNull(Eval("JabatanAgensi_IsLesen")), "true", If(Eval("JabatanAgensi_IsLesen") = "1", "true", "false")) %>'>

                                    <div class="form-group">
                                        <label>&nbsp; </label>
                                        <%-- <asp:LinkButton ID="btnViewDetail" runat="server" CausesValidation="False"  Text="Lihat Maklumat Permohonan" 
                                            Visible='<%# If(IsDBNull(Eval("JabatanAgensi_IsLesen")), "true", If(Eval("JabatanAgensi_IsLesen") = "True", "true", "false")) %>'
                                            CssClass="btn btn-primary form-control" OnClick="btnViewDetail_Click"  />--%>
                                        <asp:HyperLink ID="HyperLink1" runat="server" Visible='<%# If(IsDBNull(Eval("JabatanAgensi_IsLesen")), "true", If(Eval("JabatanAgensi_IsLesen") = "1", "true", "false")) %>'
                                            CssClass="btn btn-primary form-control" NavigateUrl='<%# "~/lesen/appregister.aspx?p_Id=3348&m_Id=3349&pid=" + Eval("Permohonan_ID").ToString() %>' Target="_blank">Lihat Maklumat Permohonan</asp:HyperLink>
                                    </div>
                                </div>

                                <!-- /.col -->
                            </div>
                            <!-- /.row -->
							
                            <div class="row">
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Alamat Pemohon</label>
                                        <asp:TextBox ID="txtAlamatPemohon" runat="server" Text='<%# Eval("Pemohon_Address") %>' CssClass="form-control" BackColor="White" TextMode="MultiLine" Rows="4" Enabled="false"></asp:TextBox>
                                    </div>
                                </div>

                                <div class="col-md-3">

                                    <div class="form-group">
                                        <label>Alamat Lokasi</label>
                                        <asp:TextBox ID="TextBox1" runat="server" Text='<%# Eval("AlamatPremis") %>' CssClass="form-control" BackColor="White" TextMode="MultiLine" Rows="4" Enabled="false"></asp:TextBox>
                                    </div>

                                </div>

                                <div class="col-md-3">

                                    <div class="form-group">
                                        <label>No. Fail</label>
                                        <asp:Label ID="Label26" runat="server" Text='<%# Eval("Rujukan") %>' CssClass="form-control" ></asp:Label>
                                    </div>

                                </div>

                                <div class="col-md-3">

                                    <div class="form-group">
                                        <label>No. Tel. Pemohon</label>
                                        <asp:Label ID="Label27" runat="server" Text='<%# Eval("Pemohon_MobileNo") %>' CssClass="form-control"></asp:Label>
                                    </div>

                                </div>

                            </div>
							
                            <hr />
                            <div class="row">
                                <div class="col-md-6">

                                    <div class="form-group">

                                        <label>Jabatan/Agensi</label><br />
                                        <asp:Label ID="Label4" runat="server" Text='<%# Bind("JabatanAgensi_Description") %>' CssClass="form-control"></asp:Label>
                                    </div>
                                    <!-- /.form-group -->

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
                            <div class="row" runat="server" id="idNotaKelulusan" visible="false">
                            </div>
                        </div>


                    </div>
                </InsertItemTemplate>
            </asp:FormView>

            <asp:SqlDataSource ID="SqlDataSourceForm" runat="server"
                ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                InsertCommand=""
                SelectCommand="SELECT a.*,e.*,f.*,g.JenisLesenIdList,g.JenisLesenDescList,g.JenisPerniagaan,g.Rujukan,
                ISNULL(g.AlamatBaru,ISNULL(g.AlamatPremis,ISNULL(g.AlamatPenjajaan,ISNULL(g.AnjingAlamat,isnull(g.LokasiPasar1,ISNULL(g.LokasiPasar2,ISNULL(g.LokasiPasar3,''))))))) as AlamatPremis 
				FROM 
                v_LESEN_ApprovalList_Curr a 
                left join LESEN_JabatanAgensi e on e.JabatanAgensi_ID = a.AgensiID
                inner join LESEN_Pemohon f on f.Pemohon_ID = a.Permohonan_PemohonID
				inner join LESEN_Permohonan g on g.Permohonan_ID = a.Permohonan_ID				
                where a.Permohonan_ID = @Permohonan_ID and isnull(a.AgensiID,1) = case when a.AgensiID is null then 1 else @AgensiID end"
                UpdateCommand="">
                <InsertParameters>
                    <asp:SessionParameter SessionField="sessionUserName" Name="CreatorID"></asp:SessionParameter>
                </InsertParameters>
                <SelectParameters>
                    <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[0]" Name="Permohonan_ID"></asp:ControlParameter>
                    <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[1]" Name="AgensiID"></asp:ControlParameter>
                </SelectParameters>
                <UpdateParameters>
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
                            SelectCommand=" SELECT a.*,b.JabatanAgensi_Description 
                         FROM LESEN_UlasanFail a
                        left join LESEN_JabatanAgensi b on b.JabatanAgensi_ID = a.UlasanFail_PermohonanAgensiID                       
                        where UlasanFail_PermohonanID = @PermohonanID 
                        /*and case when cast(@AgensiID as int) &gt; 0 then UlasanFail_PermohonanAgensiID else 0 end = case when cast(@AgensiID as int) &gt; 0 then cast(@AgensiID as int) else 0 end */
                        and UlasanFail_PermohonanAgensiID = case when 
                            (select top 1 x.JabatanAgensi_IsLesen from LESEN_JabatanAgensi x where x.JabatanAgensi_IsActive=1 and x.JabatanAgensi_ID = @sessionEstateID) = 1
                            then UlasanFail_PermohonanAgensiID else @sessionEstateID end
                        order by CreatedDt asc, UlasanFail_ID asc"
                            DeleteCommand="DELETE FROM LESEN_UlasanFail where UlasanFail_ID = @UlasanFail_ID "
                            UpdateCommand="UPDATE LESEN_UlasanFail SET UlasanFail_Remarks = @UlasanFail_Remarks, 
                        UlasanFail_FileName = @UlasanFail_FileName,
                        UlasanFail_ContentType = @UlasanFail_ContentType,
                        UlasanFail_FilePath = @UlasanFail_FilePath,
                        LastModID = @LastModID, LastModDt = GETDATE()
                        WHERE (UlasanFail_ID = @UlasanFail_ID)">
                            <DeleteParameters>
                                <asp:ControlParameter ControlID="gvTabUlasan" DefaultValue="" Name="UlasanFail_ID" PropertyName="SelectedValue" />

                            </DeleteParameters>

                            <SelectParameters>
							<asp:SessionParameter SessionField="sessionEstateID" DefaultValue="0" Name="sessionEstateID"></asp:SessionParameter>
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
                                        <asp:TextBox ID="txtKadarBayaran_Desc"  onkeyup="this.value=this.value.toUpperCase()" runat="server" Text='<%# Bind("KadarBayaran_Desc") %>' CssClass="form-control"></asp:TextBox>
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

                                <asp:TemplateField HeaderText="Maklumat Bayaran" HeaderStyle-Font-Size="10pt" HeaderStyle-Width="90%" ItemStyle-Width="90%">
                                    <ItemTemplate>
                                        <asp:Label ID="Label15" runat="server" Text="Bayaran :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                        <asp:Label ID="Label16" runat="server" Text='<%# Eval("KadarBayaran_Desc") %>' Font-Size="10pt"></asp:Label><br />
                                        <asp:Label ID="Label9" runat="server" Text="Jumlah (RM) :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                        <asp:Label ID="Label19" runat="server" Text='<%# Eval("KadarBayaran_Amount", "{0:N2}") %>' Font-Size="10pt"></asp:Label><br />
                                        <br />
                                        <asp:LinkButton ID="lbEditMobile" runat="server" CausesValidation="False" CommandName="Edit" Text="Kemaskini" CssClass="btn btn-warning btn-sm"></asp:LinkButton>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:Label ID="Label15" runat="server" Text="Bayaran :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                        <asp:TextBox ID="txtKadarBayaran_DescMobile" runat="server" Text='<%# Bind("KadarBayaran_Desc") %>' CssClass="form-control"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rvKadarBayaran_DescMobile" runat="server" CssClass="cssRequiredField"
                                            ControlToValidate="txtKadarBayaran_DescMobile" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                        <asp:Label ID="Label9" runat="server" Text="Jumlah (RM) :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                        <asp:TextBox ID="txtKadarBayaran_AmountMobile" runat="server" Text='<%# Bind("KadarBayaran_Amount") %>' CssClass="form-control" type="number"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rvKadarBayaran_AmountMobile" runat="server" CssClass="cssRequiredField"
                                            ControlToValidate="txtKadarBayaran_AmountMobile" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator><br />
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
                                        <asp:LinkButton ID="lbEdit" runat="server" CausesValidation="False" CommandName="Edit" Text="Kemaskini"
                                            Visible='<%# If(Eval("KadarBayaran_PermohonanAgensiID") = Session.Item("sessionEstateId"), True, False) %>' CssClass="btn btn-warning btn-sm"></asp:LinkButton>
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
                                            Visible='<%# If(Eval("KadarBayaran_PermohonanAgensiID") = Session.Item("sessionEstateId"), True, False) %>' CommandName="Delete" Text="Padam" OnClientClick="return confirm('Anda pasti untuk padam rekod ini?');"></asp:LinkButton>
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
                            SelectCommand=" SELECT a.*,b.JabatanAgensi_Description 
                                FROM LESEN_KadarBayaran a
                                left join LESEN_JabatanAgensi b on b.JabatanAgensi_ID = a.KadarBayaran_PermohonanAgensiID
                                where KadarBayaran_PermohonanID = @PermohonanID 
                                and (KadarBayaran_PermohonanAgensiID = isnull(@AgensiID, 1)
						        or KadarBayaran_PermohonanAgensiID = case when isnull(@AgensiID, 1) = 1 then 3 else 0 end) 
                                order by CreatedDt asc, KadarBayaran_ID asc"
                            DeleteCommand="DELETE FROM LESEN_KadarBayaran where KadarBayaran_ID = @KadarBayaran_ID "
                            UpdateCommand="UPDATE LESEN_KadarBayaran SET KadarBayaran_Desc = @KadarBayaran_Desc, LastModID = @LastModID, LastModDt = GETDATE(), KadarBayaran_Amount = @KadarBayaran_Amount WHERE (KadarBayaran_ID = @KadarBayaran_ID)">
                            <DeleteParameters>
                                <asp:ControlParameter ControlID="gvTabBayaran" DefaultValue="" Name="KadarBayaran_ID" PropertyName="SelectedValue" />

                            </DeleteParameters>

                            <SelectParameters>
                                <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[0]" Name="PermohonanID"></asp:ControlParameter>
                                <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[1]" Name="AgensiID"></asp:ControlParameter>

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
	                        from LESEN_PermohonanAgensiStaff x 
	                        inner join LESEN_PermohonanAgensi x2 on x2.PermohonanAgensi_ID = x.PermohonanAgensi_ID
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
						inner join LESEN_PermohonanAgensi b on b.Permohonan_ID = a.Permohonan_ID
						inner join LESEN_PermohonanAgensiStaff c on c.PermohonanAgensi_ID = b.PermohonanAgensi_ID
						inner join TBL_USERS d on d.Users_Id =  c.PermohonanAgensiStaffID_UsersID and d.estate_id = @AgensiID						
						where a.Permohonan_ID=@Permohonan_ID /*and isnull(b.IsLawatanTapakUlasan,0) = 1*/) = 0
						
						union all
						
						select c.PermohonanAgensiStaffID_UsersID as Users_ID,Users_Fullname,'true' as isSelect from LESEN_Permohonan a
						inner join LESEN_PermohonanAgensi b on b.Permohonan_ID = a.Permohonan_ID
						inner join LESEN_PermohonanAgensiStaff c on c.PermohonanAgensi_ID = b.PermohonanAgensi_ID
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
                
                <asp:TabPanel runat="server" ID="tabMaklumat" HeaderText="Maklumat" Visible="false">
                    <HeaderTemplate>Kemaskini Info</HeaderTemplate>
                    <ContentTemplate>
                        <br />

                        <asp:HiddenField ID="HF_SaizIklanList" runat="server" />
                        <asp:HiddenField ID="HF_CahayaIklanList" runat="server" />
                        <asp:HiddenField ID="HF_UnitIklanList" runat="server" />
                        <asp:HiddenField ID="HF_LokasiList" runat="server" />
                        <asp:HiddenField ID="HF_BakaAnjingList" runat="server" />
                        <asp:HiddenField ID="HF_AnjingJantanList" runat="server" />
                        <asp:HiddenField ID="HF_AnjingBetinaList" runat="server" />
                        <asp:HiddenField ID="HF_AnjingJantanMandulList" runat="server" />
                        <asp:HiddenField ID="HF_AnjingBetinaMandulList" runat="server" />

                        <%--# Perniagaan Berisiko dan tidak berisiko #--%>
                        <asp:Panel ID="pnlesen1" runat="server" Visible="False">

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Nama Syarikat/Sediada</label>
                                        <asp:TextBox ID="TB_NamaSyarikat" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>No Pendaftaran</label>
                                        <asp:TextBox ID="TB_NoPendaftaran" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>No Akaun Lesen</label>
                                        <asp:TextBox ID="TB_NoAkaun" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Alamat Premis/Sediada</label>
                                        <asp:TextBox ID="TB_AlamatPremis" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Jenis Perniagaan/Sediada</label>
                                        <asp:TextBox ID="TB_JenisPerniagaan" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>

                            <%--# Tukar Pemilik #--%>
                            <asp:Panel ID="pnlesen1b" runat="server" Visible="False">
                                <div class="row">

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Nama Pemilik Baru</label>
                                            <asp:TextBox ID="TB_PemilikBaru" runat="server" CssClass="form-control" />

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
                                        <asp:TextBox ID="TB_AlamatBaru" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />

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
                                        <asp:TextBox ID="TB_JenisPerniagaanBaru" runat="server" CssClass="form-control" />

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
                                        <asp:TextBox ID="TB_NamaBaruSyarikat" runat="server" CssClass="form-control" />

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
                                        <asp:TextBox ID="TB_KontraktorIklan" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>No Telefon Syarikat Kontraktor</label>
                                        <asp:TextBox ID="TB_NoTelKontraktor" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Ukuran (Kaki)</label>
                                        <asp:TextBox ID="TB_UkuranBanting" runat="server" placeholder="Contoh: 5x10" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Bilangan Banting/Sepanduk</label>
                                        <asp:TextBox ID="TB_BilBanting" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Tarikh Mula Pemasangan</label>
                                        <asp:TextBox ID="TB_TarikhBanting1" runat="server" TextMode="Date" CssClass="form-control" />
                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Tarikh Akhir Pemasangan</label>
                                        <asp:TextBox ID="TB_TarikhBanting2" runat="server" TextMode="Date" CssClass="form-control" />
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
                                        <asp:TextBox ID="TB_NoResitBanting" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>No Siri Stiker</label>
                                        <asp:TextBox ID="TB_NoSiriStiker" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Tarikh</label>
                                        <asp:TextBox ID="TB_TarikhBanting3" runat="server" TextMode="Date" CssClass="form-control" />

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
                                        <asp:TextBox ID="TB_BillboardLokasi" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />

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
                                        <asp:TextBox ID="TB_LokasiPasar1" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Lokasi Pasar #2</label>
                                        <asp:TextBox ID="TB_LokasiPasar2" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Lokasi Pasar #3</label>
                                        <asp:TextBox ID="TB_LokasiPasar3" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Jumlah Petak/Tapak/Lot</label>
                                        <asp:TextBox ID="TB_JumlahPetak" runat="server" TextMode="Number" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Jenis Perniagaan</label>
                                        <asp:TextBox ID="TB_JenisPerniagaanPasar" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Jenis Pasar</label>
                                        <asp:DropDownList ID="DDL_JenisPasar" runat="server"
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
                                        <asp:TextBox ID="TB_AnjingAlamat" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" CssClass="cssRequiredField"
                                            ControlToValidate="TB_AnjingAlamat" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Jenis Premis</label>
                                        <asp:DropDownList ID="DDL_AnjingJenisPremis" CssClass="form-control select2" runat="server"
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
                        <asp:Panel ID="pnlesen4" runat="server" Visible="False">

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Alamat aktiviti penjajaan</label>
                                        <asp:TextBox ID="TB_AlamatPenjajaan" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Jenis Perniagaan</label>
                                        <asp:TextBox ID="TB_JenisPerniagaanPenjaja" runat="server" CssClass="form-control" />

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
                                        <asp:TextBox ID="TB_PenganjurEkspo" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Nama Aktiviti/Program</label>
                                        <asp:TextBox ID="TB_NamaEkspo" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>

                            <div class="row">

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Lokasi</label>
                                        <asp:TextBox ID="TB_LokasiEkspo" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />

                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>No. Tel.</label>
                                        <asp:TextBox ID="TB_NoTel" runat="server" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>

                            <div class="row">

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Tarikh Mula</label>
                                        <asp:TextBox ID="TB_TarikhEkspo1" runat="server" TextMode="Date" CssClass="form-control" />
                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Masa Mula</label>
                                        <asp:TextBox ID="TB_MasaEkspo1" runat="server" TextMode="Time" CssClass="form-control" />
                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Tarikh Akhir</label>
                                        <asp:TextBox ID="TB_TarikhEkspo2" runat="server" TextMode="Date" CssClass="form-control" />
                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Masa Akhir</label>
                                        <asp:TextBox ID="TB_MasaEkspo2" runat="server" TextMode="Time" CssClass="form-control" />

                                    </div>
                                </div>

                            </div>

                        </asp:Panel>

                         <div class="row">
                             <div class="col-md-10">
                                 <asp:LinkButton ID="BT_Maklumat" runat="server" CausesValidation="False" Text="Kemaskini" CssClass="btn btn-warning" OnClick="btnSaveInfo_Click" />
                             </div>
                         </div>
                        <br />
                    </ContentTemplate>
                </asp:TabPanel>

                <asp:TabPanel runat="server" ID="tabSurat" HeaderText="Surat" Visible="false">
                    <HeaderTemplate>Surat</HeaderTemplate>
                    <ContentTemplate>
                        <br />
                        <div class="row">

                            <div class="col-md-12">
                                <asp:LinkButton runat="server" CssClass="btn btn-warning" ValidationGroup="updateForm" Text="Jana Surat Sokong" ID="BT_Generate" OnCommand="BT_Generate_Command" CausesValidation="True" /> &nbsp;
                                <asp:LinkButton runat="server" CssClass="btn btn-warning" ValidationGroup="updateForm" Text="Jana Surat Tidak Sokong" ID="BT_Generate1" OnCommand="BT_Generate1_Command" CausesValidation="True" /> &nbsp;
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

                            <div class="row" hidden="hidden">

                                <div class="col-md-10">

                                    <div class="form-group">
                                        <label>Isi Kandungan (Seksyen atas)</label>
                                        <asp:TextBox ID="EditorSurat1" runat="server" Text="" TextMode="MultiLine" Rows="12" CssClass="form-control"></asp:TextBox>
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
                            <div class="row" hidden="hidden">

                                <div class="col-md-10">

                                    <div class="form-group">
                                        <label>Isi Kandungan (Seksyen bawah)</label>
                                        <asp:TextBox ID="EditorSurat2" runat="server" Text="" TextMode="MultiLine" Rows="12" CssClass="form-control"></asp:TextBox>
                                        <asp:HtmlEditorExtender ID="HtmlEditorExtender1" runat="server" TargetControlID="EditorSurat2" DisplaySourceTab="True">
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
                                                InsertCommand="INSERT INTO LESEN_PermohonanSurat (Permohonan_ID, JenisReport, P1, P2, P3, IsiKandungan, CreatedDt, ModDt) VALUES (@Permohonan_ID, 'LI', @P1, @P2, @P3, @IsiKandungan, GETDATE(), GETDATE()); "
                                                UpdateCommand="UPDATE LESEN_PermohonanSurat SET P1=@P1, P2=@P2, P3=@P3, IsiKandungan=@IsiKandungan WHERE PSID=@PSID"
                                                SelectCommand="SELECT * FROM LESEN_PermohonanSurat WHERE PSID=@PSID">
                                                <InsertParameters>
                                                    <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[0]" Name="Permohonan_ID"></asp:ControlParameter>
                                                    <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[2]" Name="StatusID"></asp:ControlParameter>
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
                                                SelectCommand="SELECT * FROM LESEN_PermohonanSurat WHERE Permohonan_ID=@Permohonan_ID AND JenisReport=IIF(@StatusID=9, 'LIB', 'LIL') 
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

                <asp:TabPanel runat="server" ID="TabPenjajaUlasan" HeaderText="Syarat/Sebab">
                    <HeaderTemplate>Syarat/Sebab</HeaderTemplate>
                    <ContentTemplate>
                        <asp:GridView ID="gvTabPenjajaUlasan" runat="server" ShowHeaderWhenEmpty="true"
                            AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="PenjajaUlasanID"
                            DataSourceID="SqlDataSourceTabPenjaja"
                            CssClass="table table-bordered" Width="100%">
                            <AlternatingRowStyle CssClass="alt" />
                            <Columns>

                                <asp:TemplateField HeaderText="ID" SortExpression="PenjajaUlasanID">
                                    <EditItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("PenjajaUlasanID") %>'></asp:Label>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Bind("PenjajaUlasanID") %>'></asp:Label>
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

                                <asp:TemplateField HeaderText="Syarat/Sebab">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtUlasanDesc" runat="server" Text='<%# Bind("UlasanDesc") %>' CssClass="form-control" TextMode="MultiLine" Rows="4" ReadOnly="true" BorderStyle="None"></asp:TextBox>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtUlasanDesc" runat="server" Text='<%# Bind("UlasanDesc") %>' CssClass="form-control" TextMode="MultiLine" Rows="4"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rvtxtUlasanDesc" runat="server" CssClass="cssRequiredField"
                                            ControlToValidate="txtUlasanDesc" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </EditItemTemplate>
                                    <HeaderStyle Width="80%" HorizontalAlign="Left" />
                                    <ItemStyle HorizontalAlign="Left" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Maklumat Syarat/Sebab" HeaderStyle-Font-Size="10pt" HeaderStyle-Width="90%" ItemStyle-Width="90%">
                                    <ItemTemplate>
                                        <asp:Label ID="Label15" runat="server" Text="Syarat/Sebab :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                        <asp:Label ID="Label16" runat="server" Text='<%# Eval("UlasanDesc") %>' Font-Size="10pt"></asp:Label><br />
                                        <br />
                                        <asp:LinkButton ID="lbEditMobile" runat="server" CausesValidation="False" CommandName="Edit" Text="Kemaskini" CssClass="btn btn-warning btn-sm"></asp:LinkButton>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:Label ID="Label15" runat="server" Text="Syarat/Sebab :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                        <asp:TextBox ID="txtUlasanDescMobile" runat="server" Text='<%# Bind("UlasanDesc") %>' CssClass="form-control"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rvUlasanDescMobile" runat="server" CssClass="cssRequiredField"
                                            ControlToValidate="txtUlasanDescMobile" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>

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
                                        <asp:LinkButton ID="btnAddNew" runat="server" Text="+" CssClass="btn btn-warning btn-sm" ToolTip="Tambah" OnClick="btnAddNewPenjaja_Click" />
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lbDelete" runat="server" CausesValidation="False" CssClass="btn btn-danger btn-sm" CommandName="Delete" Text="Padam" OnClientClick="return confirm('Anda pasti untuk padam rekod ini?');"></asp:LinkButton>
                                    </ItemTemplate>
                                    <FooterStyle HorizontalAlign="Center" />
                                    <HeaderStyle Width="5%" HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:TemplateField>

                            </Columns>

                            <PagerStyle CssClass="pgr" />
                        </asp:GridView>

                        <asp:SqlDataSource ID="SqlDataSourceTabPenjaja" runat="server"
                            ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                            SelectCommand=" SELECT * FROM LESEN_PenjajaUlasan WHERE PermohonanID = @PermohonanID  
                                ORDER BY PenjajaUlasanID ASC"
                            DeleteCommand="DELETE FROM LESEN_PenjajaUlasan where PenjajaUlasanID = @PenjajaUlasanID "
                            UpdateCommand="UPDATE LESEN_PenjajaUlasan SET UlasanDesc = @UlasanDesc, LastModID = @LastModID, LastModDt = GETDATE() WHERE (PenjajaUlasanID = @PenjajaUlasanID)">
                            <DeleteParameters>
                                <asp:ControlParameter ControlID="gvTabPenjajaUlasan" DefaultValue="" Name="PenjajaUlasanID" PropertyName="SelectedValue" />

                            </DeleteParameters>

                            <SelectParameters>
                                <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[0]" Name="PermohonanID"></asp:ControlParameter>

                            </SelectParameters>
                            <UpdateParameters>
                                <asp:Parameter Name="UlasanDesc" />
                                <asp:SessionParameter Name="LastModID" SessionField="sessionUserName" />
                                <asp:Parameter Name="PenjajaUlasanID" />
                            </UpdateParameters>
                        </asp:SqlDataSource>

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
                <div runat="server" id="idNotaKelulusan"  visible="false">
                    <div class="card">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">

                                    <asp:FormView ID="fvNotaKelulusan" runat="server" DataKeyNames="Permohonan_ID"
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


                                                            <asp:TextBox ID="txtNotaKelulusanPengesah" runat="server" Text='<%# Bind("NotaKelulusanPengesah") %>'
                                                                Enabled='<%# If(Eval("ApprStatusID") = "8", False, True) %>'
                                                                CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
                                                        </div>
                                                    </div>

                                                </div>

                                                <div class="row" runat="server" visible='<%# If(Eval("ApprStatusID") > 5  And Session.Item("sessionIsPeraku") = "True", True, False) %>'>
                                                    <div class="col-md-12" runat="server" id="divNotaKelulusanPeraku" visible='<%# If(Eval("NotaKelulusanKJ2") = 0, False, True) %>'>

                                                        <div class="form-group">
                                                            <label>Nota Kelulusan (Peraku)</label><br />

                                                            <asp:TextBox ID="txtNotaKelulusan" runat="server" Text='<%# Bind("NotaKelulusan") %>' CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
                                                        </div>
                                                    </div>

                                                    <div class="col-md-12" runat="server" visible="true">

                                                        <div class="form-group">
                                                        <asp:RadioButtonList  id="rblNotaKelulusanKJ" runat="server" AutoPostBack="true" SelectedValue='<%# Bind("NotaKelulusanKJ2") %>' OnSelectedIndexChanged="rblNotaKelulusanKJ_SelectedIndexChanged">
                                                        <asp:ListItem Value="0">&nbsp;-- Kelulusan --</asp:ListItem>
                                                        <asp:ListItem Value="1">&nbsp;Diluluskan</asp:ListItem>
                                                        <asp:ListItem Value="2">&nbsp;Diluluskan dengan pindaan</asp:ListItem>                                                        
                                                        <asp:ListItem Value="4">&nbsp;Ditolak</asp:ListItem>     
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
                                        SelectCommand="SELECT top 1 a.*,
                                        (select isnull(x2.Users_Fullname,'') from 
                                        LESEN_ApprovalList x
                                        inner join TBL_USERS x2 on x2.Users_Id = x.ApproverID 
                                        where x.Permohonan_ID = a.Permohonan_ID and x.ApprStatusID = 5
                                         ) as Users_Fullname,
                                        c.ApprStatusID,isnull(e.Description,'') as Description, isnull(a.StatusIDPengesah,0) as StatusIDPengesah2,
				                        isnull(a.NotaKelulusanKJ,0) as NotaKelulusanKJ2
                                        FROM LESEN_Permohonan a 
				                        inner join v_LESEN_ApprovalList_Curr c on c.Permohonan_ID = a.Permohonan_ID
                                        /*inner join LESEN_ApprovalList c on c.Permohonan_ID = a.Permohonan_ID and c.ApprStatusID = a.StatusID*/
                                        /*left join TBL_USERS d on d.Users_Id = c.ApproverID*/
                                        inner join ApprovalStatus e on e.ApprStatusID = c.ApprStatusID
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
												<asp:HiddenField ID="hdn24jam" runat="server" value='<%# Eval("Is24Jam") %>' />
                                                <label runat="server" id="lblAgensiDesc"><%# Eval("JabatanAgensi_Description") %></label>
                                                &nbsp;&nbsp;                                   
                                    <asp:LinkButton ID="lbLihatSurat" runat="server" CausesValidation="False" Text="Lihat Surat" CssClass="btn btn-warning btn-sm"
                                        Visible='<%#If(Eval("JabatanAgensi_Type") = "J", True, False)%>' OnClick="lbLihatSurat_Click"></asp:LinkButton>
                                                <br />
                                                <asp:Label CssClass="csslblUlasan" ID="Label6" runat="server" Text='<%# "<b>Pengesah</b> : " + Eval("Pengesah") %>'></asp:Label>
                                                -
                                    <asp:Label ID="Label8" runat="server" Font-Bold="true" ForeColor='<%#If(Eval("currStatusPengesah") = -1, System.Drawing.Color.Orange, If(Eval("currStatusPengesah") = 1, System.Drawing.Color.Green, System.Drawing.Color.Red))%>'
                                        Text='<%#If(Eval("currStatusPengesah") = -1, If(Eval("Is24Jam") = 0, "Belum Selesai", "Belum Selesai (Kelulusan 24 Jam)"), If(Eval("currStatusPengesah") = 1, "SOKONG", "TIDAK SOKONG"))%>'></asp:Label>
                                                <br />
                                                <asp:Label CssClass="csslblUlasan" ID="Label21" runat="server" Text='<%# (Eval("PengesahNotaKelulusan")).Replace(vbCr, "").Replace(vbLf, vbCrLf).Replace(Environment.NewLine, "<br />") %>'></asp:Label>

                                                <%--<br />                                    

                                    <div runat="server" visible='<%# If(Eval("JabatanAgensi_Type") = "J", True, False) %>'>
                                    <asp:Label CssClass="csslblUlasan" ID="Label22" runat="server" Text='<%# "<b>Peraku</b> : " + Eval("Peraku") %>'></asp:Label> -
                                    <asp:Label ID="Label24" runat="server" Font-Bold="true" ForeColor='<%#If(Eval("currStatusPeraku") = -1, System.Drawing.Color.Orange, If(Eval("currStatusPeraku") = 1, System.Drawing.Color.Green, System.Drawing.Color.Red))%>' 
                                    Text='<%#If(Eval("currStatusPeraku") = -1, If(Eval("Is24Jam") = 0, "Belum Selesai", "Belum Selesai (Kelulusan 24 Jam)"), If(Eval("currStatusPeraku") = 1, "SOKONG", "TIDAK SOKONG"))%>'></asp:Label>
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
                            (select top 1 d.Users_Fullname from LESEN_ApprovalList c
                            inner join TBL_USERS d on d.Users_Id = c.ApproverID
                            where c.Permohonan_ID = a.Permohonan_ID and c.AgensiID = a.JabatanAgensi_ID and c.ApprStatusID = 4) as Pengesah2,
                            (select top 1 d.Users_Fullname from TBL_USERS d 
                            where d.Users_Id = a.PengesahID ) as Pengesah,							
                            (select top 1 d.Users_Fullname from LESEN_ApprovalList c
                            inner join TBL_USERS d on d.Users_Id = c.ApproverID
                            where c.Permohonan_ID = a.Permohonan_ID and c.AgensiID = a.JabatanAgensi_ID and c.ApprStatusID = 8) as Peraku,
							(select top 1 isnull(x.Is24Jam,0) from LESEN_Permohonan x where x.Permohonan_ID = @Permohonan_ID) as Is24Jam
                            from LESEN_PermohonanAgensi a
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
                            visible='<%# If(GridView1.SelectedDataKey.Values(2) = "4" Or GridView1.SelectedDataKey.Values(2) = "5", If(Session.Item("sessionIsPeraku") = "True" Or Session.Item("sessionIsPenilai") = "True", True, False), False) %>'>
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
                    FROM [LESEN_PermohonanAgensi] a
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
                                        select ApprStatusID,  Description from ApprovalStatus 
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
                        AlternatingRowStyle-CssClass="alt" AllowPaging="True" PageSize="20">
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
                                    <asp:Label ID="lblRujukan" runat="server" Text='<%# Eval("Rujukan") %>' Font-Size="12pt"></asp:Label>
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
									<asp:Label ID="lblAlamatPremis2" runat="server" Text='<%# Eval("AlamatPremis") %>' Font-Size="10pt"></asp:Label><br/>
									<asp:Label ID="lblRujukan2" runat="server" Text='<%# Eval("Rujukan") %>' Font-Size="10pt"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:TemplateField>

                            <%--<asp:CheckBoxField DataField="JenisLesen_IsActive" HeaderText="Aktif?" SortExpression="JenisLesen_IsActive" />--%>
                            <asp:TemplateField HeaderText="Operasi">
                                <ItemTemplate>


                                    <%--  <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False"
                                        CommandName="Delete" Text="Nyah Aktif" OnClientClick="return confirm('Anda Pasti Untuk Nyah Aktif rekod ini?');" CssClass="btn btn-danger btn-sm"></asp:LinkButton>--%>

                                    <div class="card-body">
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
        SelectCommand="SELECT a.*,e.*,f.*, g.Rujukan,g.IsSuratPemeriksaanFail,ISNULL(g.AlamatBaru,ISNULL(g.AlamatPremis,ISNULL(g.AlamatPenjajaan,ISNULL(g.AnjingAlamat,isnull(g.LokasiPasar1,ISNULL(g.LokasiPasar2,ISNULL(g.LokasiPasar3,''))))))) as AlamatPremis, isnull(h.IsPenilaian,0) as IsPenilaianStatus,   
            g.JenisLesenDescList, g.JenisLesenIdList FROM 
            v_LESEN_ApprovalList_Curr a 
            left join LESEN_JabatanAgensi e on e.JabatanAgensi_ID = a.AgensiID
            inner join LESEN_Pemohon f on f.Pemohon_ID = a.Permohonan_PemohonID
            inner join LESEN_Permohonan g on g.Permohonan_ID = a.Permohonan_ID
			left join LESEN_PermohonanAgensi h on h.Permohonan_ID = g.Permohonan_ID and h.JabatanAgensi_ID = 3
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
            and 
			case when case when @cbUlasan = 1 then 3 else a.ApprStatusID end = 3 then 
                case when @isReadOnly = 1 then 0 else @sessionUsersId end
            else 0 end IN 
            (select x.PermohonanAgensiStaffID_UsersID 
            from LESEN_PermohonanAgensiStaff x 
            inner join LESEN_PermohonanAgensi x2 on x2.PermohonanAgensi_ID = x.PermohonanAgensi_ID
            where x2.Permohonan_ID = g.Permohonan_ID and x2.JabatanAgensi_ID = @AgensiID union all select 0  )       
			and case when @isReadOnly = 1 and @isPenyedia = 1 then case when a.ApprStatusID IN (1,2) then 999 else a.ApprStatusID end else a.ApprStatusID end = a.ApprStatusID
            and year(a.TarikhMohon) = case when @yearValue = 0 then year(a.TarikhMohon) else @yearValue end
            and month(a.TarikhMohon) = case when @monthValue = 0 then month(a.TarikhMohon) else @monthValue end	
			and a.ApprStatusID = case when @statusFilter = -1 then a.ApprStatusID else @statusFilter end	
            and g.JenisLesenIdList is not null 
            order by a.TarikhMohon"
        DeleteCommand="">
        <DeleteParameters>
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

