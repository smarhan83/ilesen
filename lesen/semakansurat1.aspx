<%@ Page MaintainScrollPositionOnPostback="true" Title="" Language="VB" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="semakansurat1.aspx.vb" Inherits="semakansurat1" %>

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

                                <div class="col-md-6">

                                    <div class="form-group">
                                        <label>Jenis Lesen</label>
                                        <asp:Label ID="Label3" runat="server" Text='<%# Bind("JenisLesen_Description") %>' CssClass="form-control"></asp:Label>
                                        
                                    </div>
                                </div>

                               <div class="col-md-6">

                                    <div class="form-group">

                                        <label>Jenis Permohonan</label><br />
                                        <asp:Label ID="Label5" runat="server" Text='<%# Bind("jenisPermohonan") %>' CssClass="form-control"></asp:Label>
                                        
                                    </div>
                                    

                                </div>

<%--                                <div class="col-md-3" runat="server" visible='<%# If(IsDBNull(Eval("JabatanAgensi_IsLesen")), "true", If(Eval("JabatanAgensi_IsLesen") = "1", "true", "false")) %>'>

                                    <div class="form-group">
                                        <label>&nbsp; </label>
                                        
                                        <asp:HyperLink ID="HyperLink1" runat="server" Visible='<%# If(IsDBNull(Eval("JabatanAgensi_IsLesen")), "true", If(Eval("JabatanAgensi_IsLesen") = "1", "true", "false")) %>'
                                            CssClass="btn btn-primary form-control" NavigateUrl='<%# "~/lesen/appregister.aspx?p_Id=3348&m_Id=3349&pid=" + Eval("Permohonan_ID").ToString() %>' Target="_blank">Lihat Maklumat Permohonan</asp:HyperLink>
                                    </div>
                                </div>--%>

                                <!-- /.col -->
                            </div>
                            <!-- /.row -->

                            <div class="row">

                                <div class="col-md-6">

                                    <div class="form-group">
                                        <label>Nama Syarikat</label>
                                        
                                        <asp:Label ID="Label20" runat="server" Text='<%# Bind("NamaSyarikat") %>' CssClass="form-control"></asp:Label>
                                    </div>
                                </div>

                               <div class="col-md-6">

                                    <div class="form-group">

                                        <label>No. Rujukan</label><br />
                                        
                                        <asp:Label ID="Label22" runat="server" Text='<%# Bind("Rujukan") %>' CssClass="form-control"></asp:Label>
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
                            <div class="row" runat="server" id="idNotaKelulusan">
                            </div>
                        </div>


                    </div>
                </InsertItemTemplate>
            </asp:FormView>

            <asp:SqlDataSource ID="SqlDataSourceForm" runat="server"
                ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                InsertCommand=""
                SelectCommand="select * from (
                select
                'Permohonan Baru' as jenisPermohonan,PermohonanAgensi_ID,b.JenisLesen_ID,TarikhMohon,JenisLesen_Description,
                Pemohon_Name,JabatanAgensi_Description,JabatanAgensi_IsLesen,a.Permohonan_ID,b.Rujukan,b.NamaSyarikat
                from LESEN_PermohonanAgensi a
                inner join LESEN_Permohonan b on b.Permohonan_ID = a.Permohonan_ID
                inner join LESEN_JabatanAgensi c on c.JabatanAgensi_ID = a.JabatanAgensi_ID
                inner join LESEN_JenisLesen d on d.JenisLesen_ID = b.JenisLesen_ID
                inner join LESEN_Pemohon e on e.Pemohon_ID = b.Permohonan_PemohonID

                union all

                select 
                'Pembatalan' as jenisPermohonan,PermohonanAgensi_ID,b.JenisLesen_ID,TarikhMohon,JenisLesen_Description,
                Pemohon_Name,JabatanAgensi_Description,JabatanAgensi_IsLesen,a.Permohonan_ID,b.Rujukan,b.NamaSyarikat
                from LESEN_PermohonanAgensiBatal a
                inner join LESEN_Permohonan b on b.Permohonan_ID = a.Permohonan_ID
                inner join LESEN_JabatanAgensi c on c.JabatanAgensi_ID = a.JabatanAgensi_ID
                inner join LESEN_JenisLesen d on d.JenisLesen_ID = b.JenisLesen_ID
                inner join LESEN_Pemohon e on e.Pemohon_ID = b.Permohonan_PemohonID
                ) as tbl1

                where PermohonanAgensi_ID = @PermohonanAgensi_ID and jenisPermohonan = @jenisPermohonan"
                UpdateCommand="">
                <InsertParameters>
         
                </InsertParameters>
                <SelectParameters>
                    <%--<asp:ControlParameter ControlID="GridView1" PropertyName="SelectedValue" Name="PermohonanAgensi_ID"></asp:ControlParameter>                    --%>
                    <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[0]" Name="PermohonanAgensi_ID"></asp:ControlParameter>
                    <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[2]" Name="jenisPermohonan"></asp:ControlParameter>
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


                <asp:TabPanel runat="server" ID="tabSurat" HeaderText="Surat" Visible="true">
                    <HeaderTemplate>Semakan</HeaderTemplate>
                    <ContentTemplate>
                       
                        <div class="card-body">
    
    <div class="row">
   

        <div class="col-md-6">

            <div class="form-group">

                <%--<label>Surat</label><br />--%>
                <asp:LinkButton runat="server" Text="Lihat Surat"  CausesValidation="False" ID="lbSurat"
                
                CssClass="btn btn-warning btn-sm" ></asp:LinkButton>
            </div>
            

        </div>


     


    </div>


</div>

                    </ContentTemplate>
                </asp:TabPanel>
				
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

						<asp:SqlDataSource ID="SqlDataSourceTabUlasan" runat="server"
							ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
							SelectCommand=" SELECT a.*, b.StatusID FROM LESEN_PermohonanFail a INNER JOIN LESEN_Permohonan b ON a.PermohonanFail_PermohonanID = b.Permohonan_ID 
							WHERE a.PermohonanFail_JenisLampiran = 'U' AND a.PermohonanFail_PermohonanID = @Permohonan_ID"
							DeleteCommand=""
							UpdateCommand="">
							<DeleteParameters>
								
							</DeleteParameters>
							<SelectParameters>
								<asp:ControlParameter ControlID="GridView1" Name="Permohonan_ID" PropertyName="SelectedDataKey.Values[4]"></asp:ControlParameter>
							</SelectParameters>
							<UpdateParameters>
				   
							</UpdateParameters>
						</asp:SqlDataSource>

					</ContentTemplate>
				</asp:TabPanel>				

            </asp:TabContainer>

            <div class="card-footer" runat="server" visible="false" id="idFooter">

            <div class="form-group">
            <div class="row">
                <div class="col-md-12" style="text-align: center"> 
                    
                <asp:FormView ID="fvApproval" runat="server" DataSourceID="sdsApproval" DefaultMode="Edit" Width="100%">
                    <EditItemTemplate>
                        <div class="card-footer" runat="server">

                         <div class="form-group">

                     <div class="row">
                         <div class="col-md-6" style="text-align: center">   
                             <label>Nota Kelulusan (Pengesah)</label>

                             <asp:TextBox ID="txtNotaKelulusanPengesah" runat="server" Text='<%# Bind("kbReview") %>'
                             Enabled='<%# If(Session.Item("sessionIsPenilai") = "True", True, False) %>'
                             CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
                             <br />

                         </div>

                         <div class="col-md-6" style="text-align: center">   
                             <label>Nota Kelulusan (Peraku)</label>

                             <asp:TextBox ID="txtNotaKelulusanPeraku" runat="server" Text='<%# Bind("kjReview") %>' 
                             Enabled='<%# If(Session.Item("sessionIsPeraku") = "True", True, False) %>'
                             CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
                             <br />

                         </div>
                     </div>

                     <div class="row">
                         <div class="col-md-12" style="text-align: center">                            



                             <asp:LinkButton ID="btnApprove" runat="server" CausesValidation="True" Text='<%# If(GridView1.SelectedDataKey.Values(3) = "L" And Session.Item("sessionIsPenilai") = "True", "Sokong", "Diluluskan") %>' OnClientClick="return confirm('Anda pasti untuk Lulus SURAT Ini?');" 
                             CommandArgument="A" ValidationGroup="frmEdit" CssClass="btn btn-warning" OnClick="btnApprove_Click1" />

                             <asp:LinkButton ID="btnReject" runat="server" CausesValidation="True" Text="Semak Semula" OnClientClick="return confirm('Anda pasti untuk semak semula SURAT Ini?');" 
                            CommandArgument="R" ValidationGroup="frmEdit" CssClass="btn btn-danger" OnClick="btnReject_Click1"  />

                             <asp:LinkButton ID="btnBack" runat="server" CausesValidation="False" Text="Kembali" CssClass="btn btn-default" OnClick="btnBack_Click" />
                         </div>

                     </div>
                 </div>
                        </div>
                    </EditItemTemplate>
                </asp:FormView>

                </div>
            </div>
            </div>

            </div>

            <asp:HiddenField ID="hfBtnAction" Value="" runat="server" />
    <asp:SqlDataSource ID="sdsApproval" runat="server"
        ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
        SelectCommand="select * from (
        select
        a.Permohonan_ID,'Permohonan Baru' as jenisPermohonan,PermohonanAgensi_ID,b.JenisLesen_ID,TarikhMohon,
        JenisLesen_Description,Pemohon_Name,JabatanAgensi_Description,Permohonan_PemohonID,Rujukan,kjReview,kbReview
        from LESEN_PermohonanAgensi a
        inner join LESEN_Permohonan b on b.Permohonan_ID = a.Permohonan_ID
        inner join LESEN_JabatanAgensi c on c.JabatanAgensi_ID = a.JabatanAgensi_ID
        inner join LESEN_JenisLesen d on d.JenisLesen_ID = b.JenisLesen_ID
        inner join LESEN_Pemohon e on e.Pemohon_ID = b.Permohonan_PemohonID

        union all
        
        select 
        a.Permohonan_ID,'Pembatalan' as jenisPermohonan,PermohonanAgensi_ID,b.JenisLesen_ID,TarikhMohon,
        JenisLesen_Description,Pemohon_Name,JabatanAgensi_Description,Permohonan_PemohonID,Rujukan,kjReview,kbReview
        from LESEN_PermohonanAgensiBatal a
        inner join LESEN_Permohonan b on b.Permohonan_ID = a.Permohonan_ID
        inner join LESEN_JabatanAgensi c on c.JabatanAgensi_ID = a.JabatanAgensi_ID
        inner join LESEN_JenisLesen d on d.JenisLesen_ID = b.JenisLesen_ID
        inner join LESEN_Pemohon e on e.Pemohon_ID = b.Permohonan_PemohonID

        ) as tbl1
        where  PermohonanAgensi_ID = @PermohonanAgensi_ID and jenisPermohonan = @jenisPermohonan
        order by Permohonan_ID desc"
        UpdateCommand=""
        DeleteCommand=""        >
   
        <UpdateParameters>
            <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[0]" Name="PermohonanAgensi_ID"></asp:ControlParameter>
            <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[2]" Name="jenisPermohonan"></asp:ControlParameter>
            <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[3]" Name="JabatanAgensi_Type"></asp:ControlParameter>
            <asp:Parameter Name="kbReview" />
            <asp:Parameter Name="kjReview" />
        </UpdateParameters>

        <SelectParameters>
            <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[0]" Name="PermohonanAgensi_ID"></asp:ControlParameter>
            <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[2]" Name="jenisPermohonan"></asp:ControlParameter>
        </SelectParameters>
    </asp:SqlDataSource>
               



            </div>

         
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
                                        (select '0' as JenisLesen_ID, '-- Lesen --' as JenisLesen_Description
                                        union all
                                        select JenisLesen_Description AS JenisLesen_ID, JenisLesen_Description from LESEN_JenisLesen where JenisLesen_IsActive=1
                                        ) as tbl1 order by JenisLesen_Description "></asp:SqlDataSource>
                                    </div>

                                </div>

                                <div class="col-md-3" runat="server" id="filterPemohon">
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

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <asp:TextBox ID="TB_TarikhMohon" runat="server"
                                            TextMode="Date" CssClass="form-control" />
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
                    <%--# END FILTER #--%>

                    <asp:GridView ID="GridView1" runat="server"
                        AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="PermohonanAgensi_ID,JenisLesen_ID,jenisPermohonan,JabatanAgensi_Type,Permohonan_ID,JenisLesenIdList"
                        DataSourceID="SqlDataSourceGrid"
                        CssClass="table table-bordered" PagerStyle-CssClass="pgr"
                        AlternatingRowStyle-CssClass="alt">
                        <AlternatingRowStyle CssClass="alt" />
                        <Columns>
                            <asp:TemplateField HeaderText="No." InsertVisible="False" SortExpression="JenisLesen_ID">
                                <EditItemTemplate>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label runat="server" Text='<%# Container.DataItemIndex + 1 %>' ID="Label2"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <%--<asp:BoundField DataField="JenisLesen_Description" HeaderText="Jenis Lesen"
                                SortExpression="JenisLesen_Description" />--%>
                             <asp:TemplateField HeaderText="Jenis Lesen">
                                 <ItemTemplate>
                                    
                                    <asp:Label ID="lblJenisLesen" runat="server" Text='<%# Eval("JenisLesen_Description") %>' ></asp:Label>
                                    <%--<asp:Label ID="lblA" runat="server" Text=" / " Font-Bold="True" ></asp:Label>--%><br />
                                    <asp:Label ID="lblJenisPermohonan" runat="server" Text='<%# "<< " + Eval("jenisPermohonan") + " >>" %>' ForeColor="Blue" ></asp:Label>
                                 </ItemTemplate>
                            </asp:TemplateField>

<%--                            <asp:BoundField DataField="Pemohon_Name" HeaderText="Nama Pemohon"
                                SortExpression="Pemohon_Name" />--%>

                             <asp:TemplateField HeaderText="Nama Pemohon">
                                 <ItemTemplate>
                                    
                                    <asp:Label ID="lblNamaPemohon" runat="server" Text='<%# Eval("Pemohon_Name") %>' ></asp:Label><br />
                                    
                                    <asp:Label ID="lblNoRujukan" runat="server" Text='<%# Eval("Rujukan") %>' ForeColor="Blue" ></asp:Label><br />
                                     <asp:Label ID="lblNamaSyarikat" runat="server" Text='<%# Eval("NamaSyarikat") %>'  ></asp:Label>

                                 </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="JabatanAgensi_Description" HeaderText="Jabatan/Agensi" />
                            <asp:BoundField DataField="TarikhMohon" HeaderText="Tarikh Mohon" DataFormatString="{0:yyyy-MM-dd}"
                                SortExpression="TarikhMohon" />

                            <asp:TemplateField HeaderText="Maklumat Permohonan" HeaderStyle-Font-Size="10pt" HeaderStyle-Width="90%" ItemStyle-Width="90%">
                                <ItemTemplate>
                                    <asp:Label ID="Label15" runat="server" Text="Tarikh Mohon :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                    <asp:Label ID="Label16" runat="server" Text='<%# Eval("TarikhMohon", "{0:yyyy-MM-dd}") %>' Font-Size="10pt"></asp:Label><br />
                                    <asp:Label ID="Label9" runat="server" Text="Jenis Lesen :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                    <asp:Label ID="Label10" runat="server" Text='<%# Eval("JenisLesenDescList") %>' Font-Size="10pt"></asp:Label><br />
                                    <asp:Label ID="Label6" runat="server" Text="Jenis Permohonan :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                    <asp:Label ID="Label7" runat="server" Text='<%# Eval("jenisPermohonan") %>' Font-Size="10pt"></asp:Label><br />                                    
                                    <asp:Label ID="Label11" runat="server" Text="Nama Pemohon :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                    <asp:Label ID="Label12" runat="server" Text='<%# Eval("Pemohon_Name") %>' Font-Size="10pt"></asp:Label><br />                                    
                                    <asp:Label ID="Label8" runat="server" Text='<%# Eval("Rujukan") %>' Font-Size="10pt"></asp:Label><br />
                                    <asp:Label ID="Label17" runat="server" Text='<%# Eval("NamaSyarikat") %>' Font-Size="10pt"></asp:Label><br />
                                    <asp:Label ID="Label14" runat="server" Text='<%#If(IsDBNull(Eval("JabatanAgensi_Description")), "", Eval("JabatanAgensi_Description") + "<br />") %>' Font-Bold="True" Font-Size="10pt"></asp:Label>
                                    
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:TemplateField>

                            <%--<asp:CheckBoxField DataField="JenisLesen_IsActive" HeaderText="Aktif?" SortExpression="JenisLesen_IsActive" />--%>
                            <asp:TemplateField ShowHeader="False">
                                <ItemTemplate>


                                    <%--  <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False"
                                        CommandName="Delete" Text="Nyah Aktif" OnClientClick="return confirm('Anda Pasti Untuk Nyah Aktif rekod ini?');" CssClass="btn btn-danger btn-sm"></asp:LinkButton>--%>

                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-lg-12">

                                                <div class="form-group">
                                                    <asp:LinkButton runat="server" Text="Lihat" CommandName="Select" CausesValidation="False"
                                                        ID="lbLihat" CssClass="btn btn-warning btn-sm"></asp:LinkButton>
                                                </div>
                                            </div>

                                          <%--  <div class="col-lg-6">

                                                <div class="form-group">
                                                    <asp:LinkButton runat="server" Text="Surat" CommandName="Surat" CausesValidation="False" ID="lbSurat"
                                                        Visible='<%# If(IsDBNull(Eval("JabatanAgensi_ID")), False, True) %>'
                                                        CssClass="btn btn-warning btn-sm" CommandArgument='<%# Container.DataItemIndex %>'></asp:LinkButton>
                                                </div>

                                            </div>--%>

                                        </div>

                                    </div>

                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <PagerStyle CssClass="pgr" />
                    </asp:GridView>
                </div>
            </div>
        
    </section>
    <asp:Button ID="ui_btnPageBottom" runat="server" Text="-" Style="margin-left: -999px;" />


    <asp:SqlDataSource ID="SqlDataSourceGrid" runat="server"
        ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
        SelectCommand="select * from (
select
a.Permohonan_ID,'Permohonan Baru' as jenisPermohonan,PermohonanAgensi_ID,b.JenisLesen_ID,TarikhMohon,
Pemohon_Name,JabatanAgensi_Description,Permohonan_PemohonID,Rujukan,JabatanAgensi_Type,NamaSyarikat,
JenisLesenIdList, JenisLesenDescList 
from LESEN_PermohonanAgensi a
inner join LESEN_Permohonan b on b.Permohonan_ID = a.Permohonan_ID
inner join LESEN_JabatanAgensi c on c.JabatanAgensi_ID = a.JabatanAgensi_ID
inner join LESEN_Pemohon e on e.Pemohon_ID = b.Permohonan_PemohonID
where reviewStatusID = 1 
/*and isnull(b.StatusID,0) = 0*/
and case when @isKB = 1 then isnull(a.kbApproval,2) else 99 end = case when @isKB = 1  then 2 else 99 end
and case when @isKJ = 1 then isnull(a.kbApproval,2) else 99 end = case when @isKJ = 1 then 1 else 99 end
and case when @isKJ = 1 then isnull(a.kjApproval,2) else 99 end = case when @isKJ = 1 then 2 else 99 end
and case when @isKJ = 1 then c.JabatanAgensi_Type else '99' end = case when @isKJ = 1 then ('L') else ('99') end

union all
        
select 
a.Permohonan_ID,'Pembatalan' as jenisPermohonan,PermohonanAgensi_ID,b.JenisLesen_ID,TarikhMohon,
Pemohon_Name,JabatanAgensi_Description,Permohonan_PemohonID,Rujukan,JabatanAgensi_Type,NamaSyarikat,
JenisLesenIdList, JenisLesenDescList 
from LESEN_PermohonanAgensiBatal a
inner join LESEN_Permohonan b on b.Permohonan_ID = a.Permohonan_ID
inner join LESEN_JabatanAgensi c on c.JabatanAgensi_ID = a.JabatanAgensi_ID
inner join LESEN_Pemohon e on e.Pemohon_ID = b.Permohonan_PemohonID
where reviewStatusID = 1 
/*and isnull(b.StatusID,0) = 0*/
and case when @isKB = 1 then isnull(a.kbApproval,2) else 99 end = case when @isKB = 1  then 2 else 99 end
and case when @isKJ = 1 then isnull(a.kbApproval,2) else 99 end = case when @isKJ = 1 then 1 else 99 end
and case when @isKJ = 1 then isnull(a.kjApproval,2) else 99 end = case when @isKJ = 1 then 2 else 99 end
and case when @isKJ = 1 then c.JabatanAgensi_Type else '99' end = case when @isKJ = 1 then ('L') else ('99') end
) as tbl1
where  isnull(Rujukan,'') like '%'+@Rujukan+'%'
and JenisLesenDescList like case when @lesenID = '0' then JenisLesenDescList else '%'+@lesenID+'%' end
and Permohonan_PemohonID = case when @pemohonID = 0 then Permohonan_PemohonID else @pemohonID end
and TarikhMohon like '%'+@TarikhMohon+'%' 
and JenisLesenIdList is not null 
order by Permohonan_ID desc"
        DeleteCommand="">
        <DeleteParameters>
            <asp:ControlParameter ControlID="GridView1" DefaultValue="" Name="JenisLesen_ID" PropertyName="SelectedValue" />
        </DeleteParameters>

        <SelectParameters>
            <asp:SessionParameter SessionField="sessionIsPenyedia" DefaultValue="0" Name="isPenyedia"></asp:SessionParameter>
            <asp:SessionParameter SessionField="sessionIsPenilai" DefaultValue="0" Name="isKB"></asp:SessionParameter>
            <asp:SessionParameter SessionField="sessionIsPeraku" DefaultValue="0" Name="isKJ"></asp:SessionParameter>
            <asp:SessionParameter SessionField="sessionEstateID" DefaultValue="0" Name="AgensiID"></asp:SessionParameter>
            <asp:SessionParameter SessionField="sessionUsersId" DefaultValue="0" Name="sessionUsersId"></asp:SessionParameter>

            <asp:ControlParameter ControlID="txtNoRujukan" PropertyName="Text" DefaultValue="%%" Name="Rujukan"></asp:ControlParameter>
            <asp:ControlParameter ControlID="DDL_JenisLesen" PropertyName="SelectedValue" Name="lesenID"></asp:ControlParameter>
            <asp:ControlParameter ControlID="ddlPemohonCari" PropertyName="SelectedValue" Name="pemohonID"></asp:ControlParameter>
            <asp:ControlParameter ControlID="TB_TarikhMohon" PropertyName="Text" DefaultValue="%%" Name="TarikhMohon"></asp:ControlParameter>

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

