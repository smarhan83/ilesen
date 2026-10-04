<%@ Page MaintainScrollPositionOnPostback="true" Title="" Language="VB" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="semakpembatalan1.aspx.vb" Inherits="semakpembatalan1" %>

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
            font-weight: normal !important;
        }

        /* AjaxControlToolkit TabContainer Styling */
        .ajax__tab_xp .ajax__tab_header {
            background-image: url('') !important;
            font-size: 11pt !important;
            height: 40px !important;
            color: #000 !important;
        }

        .ajax__tab_xp .ajax__tab_outer,
        .ajax__tab_xp .ajax__tab_inner,
        .ajax__tab_xp .ajax__tab_tab {
            background-image: url('') !important;
        }

        .ajax__tab_xp .ajax__tab_header .ajax__tab_active .ajax__tab_inner {
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
        }

        .ajax__tab_xp .ajax__tab_header .ajax__tab_inner {
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

        .highlighted {
            background-color: #f8d7d7;
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">

    <%-- ========================================================================= --%>
    <%-- SECTION 1: PAGE HEADER & BREADCRUMB                                       --%>
    <%-- ========================================================================= --%>
    <section class="content-header">
        <div class="container-fluid">
            <asp:Label ID="lblDummy" runat="server" Text=""></asp:Label>
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0 text-dark">
                        <div runat="server" id="idWindowTitle"></div>
                    </h1>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <%= GlobalClass.writeBreadcrumb(Request.QueryString("p_Id"), Request.QueryString("m_Id"), Session.Item("sessionSystemId")) %>
                    </ol>
                </div>
            </div>
        </div>
    </section>

    <!-- Main content -->
    <section class="content">
        <div class="container-fluid">

            <%-- ========================================================================= --%>
            <%-- SECTION 2: DETAILS VIEW (FormView1 - Maklumat Permohonan)                  --%>
            <%-- ========================================================================= --%>
            <asp:FormView ID="FormView1" runat="server" DataKeyNames="JenisLesenIdList, JenisLesenDescList, Permohonan_ID, ApprStatusID"
                DataSourceID="SqlDataSourceForm" DefaultMode="Edit" Width="100%" CssClass="CustomTab">
                <EditItemTemplate>
                    <div class="card card-warning">
                        <div class="card-header">
                            <h3 class="card-title">
                                <div runat="server" id="idWindowTitle2">Maklumat</div>
                            </h3>
                            <div class="card-tools">
                                <button class="btn btn-tool" data-card-widget="collapse" type="button">
                                    <i class="fas fa-minus"></i>
                                </button>
                            </div>
                        </div>
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
                                        <asp:Label ID="Label3" runat="server" Text='<%# Bind("JenisLesenDescList") %>' CssClass="form-control"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-3" runat="server">
                                    <div class="form-group">
                                        <label>&nbsp;</label>
                                        <asp:HyperLink ID="HyperLink1" runat="server"
                                            CssClass="btn btn-primary form-control" NavigateUrl='<%# "~/lesen/appregister1.aspx?p_Id=3348&m_Id=3349&pid=" + Eval("Permohonan_ID").ToString() %>' Target="_blank">Lihat Maklumat Permohonan</asp:HyperLink>
                                    </div>
                                </div>
                            </div>
                            <hr />
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Nota (Kelulusan)</label>
                                        <asp:Label ID="Label6" runat="server" Text='<%# Bind("NotaKelulusan") %>' Height="114" CssClass="form-control"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Status</label>
                                        <asp:Label ID="Label5" runat="server" Text='<%# Eval("Description") %>' CssClass="form-control"></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Jumlah Paparan</label>
                                        <asp:Label ID="Label7" runat="server" Text='<%# Eval("TotalViews") %>' CssClass="form-control"></asp:Label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="card-footer">
                            <asp:LinkButton ID="btnBack" runat="server" CausesValidation="False" Text="Kembali ke senarai" CssClass="btn btn-default" OnClick="btnBack_Click" />
                            <asp:LinkButton runat="server" CssClass="btn btn-warning" CausesValidation="False" Text="Lihat Surat Mohon Ulasan" ID="BT_SuratMohonUlasan" Visible='<%# If(CInt(Session.Item("sessionEstateId")) = 1, False, True) %>' OnCommand="BT_SuratMohonUlasan_Command" />
                            <asp:LinkButton runat="server" CssClass="btn btn-warning" ValidationGroup="updateForm" Text="Lihat Surat Pembatalan" ID="BT_ViewMail" Visible='<%# If(Eval("ApprStatusID") < 9, False, True) %>' OnCommand="BT_ViewMail_Command" CausesValidation="False" />
                            <label style="margin-left: 50px;">Janaan Komputer?</label>
                            <asp:CheckBox ID="CB_IsDigitalSign" runat="server" Checked="true" AutoPostBack="true" Enabled='<%# If(Eval("ApprStatusID") < 9, False, True) %>'/>

                            <label style="margin-left: 50px;">Terbit Pembatalan?</label>
                            <asp:CheckBox ID="CB_IsPublish" runat="server" Checked='<%# Eval("IsPublish") %>' OnCheckedChanged="CB_IsPublish_CheckedChanged" AutoPostBack="true" Enabled='<%# If(Eval("ApprStatusID") < 9, False, True) %>'/>
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
                inner join LESEN_Pemohon f on f.Pemohon_ID = a.Permohonan_PemohonID 
                inner join LESEN_Permohonan g on g.Permohonan_ID = a.Permohonan_ID 
                where a.Permohonan_ID = @Permohonan_ID ORDER BY ApprovalID Desc " 
                UpdateCommand="">
                <SelectParameters>
                    <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[0]" Name="Permohonan_ID"></asp:ControlParameter>
                </SelectParameters>
            </asp:SqlDataSource>

            <%-- ========================================================================= --%>
            <%-- SECTION 3: DETAIL TABS (TabContainer1)                                    --%>
            <%-- ========================================================================= --%>
            <asp:TabContainer ID="TabContainer1" runat="server" ActiveTabIndex="0" Visible="false" CssClass="MyTabStyle">
                
                <%-- TAB 1: SURAT PEMBATALAN (tabSurat) --%>
                <asp:TabPanel runat="server" ID="tabSurat" HeaderText="Surat">
                    <HeaderTemplate>Surat</HeaderTemplate>
                    <ContentTemplate>
                        <br />
                        <div class="row mb-2">
                            <div class="col-md-4" runat="server" id="divtemplatsurat">
                                <div class="form-group">
                                    <asp:DropDownList ID="DDL_SuratTemplat" CssClass="form-control select2" style="width: 100%;" runat="server" AutoPostBack="false"
                                        DataSourceID="SqlDataSourceSuratTemplat" DataTextField="NamaTemplatDesc" DataValueField="NamaTemplat">
                                    </asp:DropDownList>
                                    <asp:SqlDataSource runat="server" ID="SqlDataSourceSuratTemplat" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                        SelectCommand="SELECT * FROM 
                                        (SELECT '0' AS NamaTemplat, '-- Pilih Templat Surat --' AS NamaTemplatDesc
                                        UNION ALL
                                        SELECT DISTINCT CONCAT(JenisReport, ',',NamaTemplat) AS NamaTemplat, NamaTemplat AS NamaTemplatDesc 
                                        FROM LESEN_ReportTemplate 
                                        WHERE JenisLesen_ID = TRY_CAST(
                                            CASE 
                                                WHEN CHARINDEX(',', LTRIM(@JenisLesenIdList)) > 0 
                                                    THEN LEFT(LTRIM(@JenisLesenIdList), CHARINDEX(',', LTRIM(@JenisLesenIdList)) - 1)
                                                ELSE LTRIM(@JenisLesenIdList)
                                            END AS INT
                                        ) AND (JenisReport=IIF(@ApprStatusID=9, 'SPB', 'SPL') OR JenisReport='SPL' OR JenisReport='SPB') AND NamaTemplat is not null) AS tbl1 ORDER BY NamaTemplatDesc ">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[1]" Name="ApprStatusID"></asp:ControlParameter>
                                            <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[2]" Name="JenisLesenIdList"></asp:ControlParameter>
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <asp:LinkButton runat="server" CssClass="btn btn-warning" Text="Jana Surat" ID="BT_Generate" OnCommand="BT_Generate_Command" OnClientClick="return confirm('Jana surat sekarang?');" />													
                            </div>
                        </div>
                        <div class="row mb-2">
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
                            <div class="card mb-2">
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <label>Tarikh Surat</label>
                                                <asp:TextBox ID="TB_TarikhSurat" runat="server" TextMode="Date" CssClass="form-control" />
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Tandatangan</label><br />
                                                <asp:DropDownList ID="ddlTandatangan" CssClass="form-control select2" style="width: 100%;" runat="server" AutoPostBack="false"
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
                                                        and (a.Users_IsPeraku = 1 or a.Users_IsPenilaian = 1) 
                                                        and b.JabatanAgensi_IsLesen = 1">
                                                    <SelectParameters>
                                                        <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[0]" Name="Permohonan_ID"></asp:ControlParameter>
                                                    </SelectParameters>
                                                </asp:SqlDataSource>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-footer">
                                    <div class="row">
                                        <div class="col-md-10 text-center">
                                            <asp:LinkButton ID="btnSaveLetter" runat="server" CausesValidation="False" Text="Kemaskini" CssClass="btn btn-warning" OnClick="btnSaveLetter_Click" />
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="card">
                                <div class="card-body">
                                    <div class="row mb-2">
                                        <div class="col-12">
                                            <asp:FormView ID="FormViewReport" Width="100%" DefaultMode="Insert" runat="server" DataKeyNames="PSID" DataSourceID="SqlDataSourceReport">
                                                <EditItemTemplate>
                                                    <asp:Panel runat="server">
                                                        <div class="card card-default">
                                                            <div class="card-header">
                                                                <h3 class="card-title" style="color: black">Kemaskini Isi Surat</h3>
                                                            </div>
                                                            <div class="card-body">
                                                                <div class="row">
                                                                    <div class="col-md-2">
                                                                        <div class="form-group">
                                                                            <label>No Perenggan Utama</label>
                                                                            <asp:TextBox ID="TB_P1" runat="server" TextMode="Number" Text='<%# Bind("P1") %>' CssClass="form-control" />
                                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" CssClass="cssRequiredField"
                                                                                ControlToValidate="TB_P1" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-md-2">
                                                                        <div class="form-group">
                                                                            <label>No Perenggan Sekunder</label>
                                                                            <asp:TextBox ID="TB_P2" runat="server" TextMode="Number" Text='<%# Bind("P2") %>' CssClass="form-control" />
                                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" CssClass="cssRequiredField"
                                                                                ControlToValidate="TB_P2" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-md-2">
                                                                        <div class="form-group">
                                                                            <label>No Perenggan Tertier</label>
                                                                            <asp:TextBox ID="TB_P3" runat="server" TextMode="Number" Text='<%# Bind("P3") %>' CssClass="form-control" />
                                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" CssClass="cssRequiredField"
                                                                                ControlToValidate="TB_P3" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="row">
                                                                    <div class="col-md-8">
                                                                        <div class="form-group">
                                                                            <label>Isi Kandungan</label>
                                                                            <asp:TextBox ID="TB_IsiKandungan" runat="server" TextMode="Multiline" Text='<%# Bind("IsiKandungan") %>' CssClass="form-control" />
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
                                                    <asp:Panel runat="server">
                                                        <div class="card card-default">
                                                            <div class="card-header">
                                                                <h3 class="card-title" style="color: black">Tambah Isi Surat</h3>
                                                            </div>
                                                            <div class="card-body">
                                                                <div class="row">
                                                                    <div class="col-md-2">
                                                                        <div class="form-group">
                                                                            <label>No Perenggan Utama</label>
                                                                            <asp:TextBox ID="TB_P1" runat="server" TextMode="Number" Text='<%# Bind("P1") %>' CssClass="form-control" />
                                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" CssClass="cssRequiredField"
                                                                                ControlToValidate="TB_P1" ErrorMessage="Sila Isi" ValidationGroup="frmInsert" Display="Dynamic"></asp:RequiredFieldValidator>
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-md-2">
                                                                        <div class="form-group">
                                                                            <label>No Perenggan Sekunder</label>
                                                                            <asp:TextBox ID="TB_P2" runat="server" TextMode="Number" Text='<%# Bind("P2") %>' CssClass="form-control" />
                                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" CssClass="cssRequiredField"
                                                                                ControlToValidate="TB_P2" ErrorMessage="Sila Isi" ValidationGroup="frmInsert" Display="Dynamic"></asp:RequiredFieldValidator>
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-md-2">
                                                                        <div class="form-group">
                                                                            <label>No Perenggan Tertier</label>
                                                                            <asp:TextBox ID="TB_P3" runat="server" TextMode="Number" Text='<%# Bind("P3") %>' CssClass="form-control" />
                                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" CssClass="cssRequiredField"
                                                                                ControlToValidate="TB_P3" ErrorMessage="Sila Isi" ValidationGroup="frmInsert" Display="Dynamic"></asp:RequiredFieldValidator>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="row">
                                                                    <div class="col-md-8">
                                                                        <div class="form-group">
                                                                            <label>Isi Kandungan</label>
                                                                            <asp:TextBox ID="TB_IsiKandungan" runat="server" TextMode="Multiline" Text='<%# Bind("IsiKandungan") %>' CssClass="form-control" />
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
                                                InsertCommand="INSERT INTO LESEN_PermohonanSurat (Permohonan_ID, JenisReport, P1, P2, P3, IsiKandungan, CreatedDt, ModDt) VALUES (@Permohonan_ID, IIF(@StatusID=9,'SPB','SPL'), @P1, @P2, @P3, @IsiKandungan, GETDATE(), GETDATE()); "
                                                UpdateCommand="UPDATE LESEN_PermohonanSurat SET P1=@P1, P2=@P2, P3=@P3, IsiKandungan=@IsiKandungan WHERE PSID=@PSID"
                                                SelectCommand="SELECT * FROM LESEN_PermohonanSurat WHERE PSID=@PSID">
                                                <InsertParameters>
                                                    <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[0]" Name="Permohonan_ID"></asp:ControlParameter>
                                                    <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[1]" Name="StatusID"></asp:ControlParameter>
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
                                                SelectCommand="SELECT * FROM LESEN_PermohonanSurat WHERE Permohonan_ID=@Permohonan_ID AND (JenisReport=IIF(@StatusID=9, 'SPB', 'SPL') OR JenisReport LIKE 'SP%') 
                                                ORDER BY P1, P2, P3">
                                                <DeleteParameters>
                                                    <asp:Parameter Name="PSID"></asp:Parameter>
                                                </DeleteParameters>
                                                <SelectParameters>
                                                    <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[0]" Name="Permohonan_ID"></asp:ControlParameter>
                                                    <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[1]" Name="StatusID"></asp:ControlParameter>
                                                </SelectParameters>
                                            </asp:SqlDataSource>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </asp:Panel>
                    </ContentTemplate>
                </asp:TabPanel>

                <%-- TAB 2: LAMPIRAN SYARAT & BIL (tabLampiran) --%>
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
                                                <div class="col">
                                                    <asp:FileUpload ID="FU_Lampiran1" runat="server" CssClass="form-control"/>
                                                    <asp:HyperLink ID="HL_Lampiran1" NavigateUrl="#" Text="null" runat="server" />
                                                </div>
                                                <div class="col">
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
                                                <div class="col">
                                                    <asp:FileUpload ID="FU_Lampiran2" runat="server" CssClass="form-control"/>
                                                    <asp:HyperLink ID="HL_Lampiran2" NavigateUrl="#" Text="null" runat="server" />
                                                </div>
                                                <div class="col">
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

                <%-- TAB 3: ULASAN IK (tabUlasan) --%>
                <asp:TabPanel runat="server" ID="tabUlasan" HeaderText="Ulasan">
                    <HeaderTemplate>Ulasan IK</HeaderTemplate>
                    <ContentTemplate>
                        <asp:GridView ID="gvTabUlasan" runat="server" ShowHeaderWhenEmpty="True"
                            AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="UlasanFail_ID"
                            DataSourceID="SqlDataSourceTabUlasanIK"
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
                                        Fail :
                                        <asp:HyperLink ID="hpFile" runat="server" NavigateUrl='<%# Eval("UlasanFail_FilePath") %>' Target="_blank"><%#Eval("UlasanFail_FileName") %></asp:HyperLink>
                                        <asp:HiddenField ID="hdnFldUlasanFail_FileName" Value='<%# Bind("UlasanFail_FileName") %>' runat="server" />
                                        <asp:HiddenField ID="hdnFldUlasanFail_ContentType" Value='<%# Bind("UlasanFail_ContentType") %>' runat="server" />
                                        <asp:HiddenField ID="hdnFldUlasanFail_FilePath" Value='<%# Bind("UlasanFail_FilePath") %>' runat="server" />
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:FileUpload ID="txtUlasanFail_FilePath" runat="server" CssClass="form-control"></asp:FileUpload>
                                        <asp:Button ID="btnUpload" runat="server" Text="Muat Naik" OnClick="btnUpload_Click" Visible="false"
                                            OnClientClick="return confirm('Fail sedia ada akan ditukar ke fail yang baru.');" />
                                        <asp:HiddenField ID="hdnFldUlasanFail_FileName" Value='<%# Bind("UlasanFail_FileName") %>' runat="server" />
                                        <asp:HiddenField ID="hdnFldUlasanFail_ContentType" Value='<%# Bind("UlasanFail_ContentType") %>' runat="server" />
                                        <asp:HiddenField ID="hdnFldUlasanFail_FilePath" Value='<%# Bind("UlasanFail_FilePath") %>' runat="server" />
                                    </EditItemTemplate>
                                    <HeaderStyle Width="25%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Maklumat Ulasan" HeaderStyle-Font-Size="10pt" HeaderStyle-Width="90%" ItemStyle-Width="90%">
                                    <ItemTemplate>
                                        <asp:Label ID="Label15" runat="server" Text="Ulasan :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                        <asp:Label ID="Label16" runat="server" Text='<%# If(Len(Eval("UlasanFail_Remarks").ToString()) > 0, (Eval("UlasanFail_Remarks")).Replace(vbCr, "").Replace(vbLf, vbCrLf).Replace(Environment.NewLine, "<br />"), Eval("UlasanFail_Remarks")) %>' Font-Size="10pt"></asp:Label><br />
                                        <asp:Label ID="Label9" runat="server" Text="Fail :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                        <asp:HyperLink ID="hpFileMobile" CssClass="paraGraphtext" runat="server" NavigateUrl='<%# Eval("UlasanFail_FilePath") %>' Target="_blank" Font-Bold="True" Font-Size="10pt"><%#If(Len(Eval("UlasanFail_FileName").ToString()) > 25, Eval("UlasanFail_FileName").ToString.Substring(Len(Eval("UlasanFail_FileName").ToString()) - 25), Eval("UlasanFail_FileName")) %></asp:HyperLink><br />
                                        <asp:Label ID="Label13" runat="server" Text="Jabatan/Agensi :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                        <asp:Label ID="Label19" runat="server" Text='<%# Eval("JabatanAgensi_Description") %>' Font-Size="10pt"></asp:Label><br />
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
                                    </EditItemTemplate>
                                    <ItemStyle HorizontalAlign="Left" />
                                </asp:TemplateField>
                            </Columns>
                            <PagerStyle CssClass="pgr" />
                        </asp:GridView>

                        <asp:SqlDataSource ID="SqlDataSourceTabUlasanIK" runat="server"
                            ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                            SelectCommand=" SELECT a.*,b.JabatanAgensi_Description FROM LESEN_UlasanFailBatal a
                                left join LESEN_JabatanAgensi b on b.JabatanAgensi_ID = a.UlasanFail_PermohonanAgensiID
                                where UlasanFail_PermohonanID = @PermohonanID AND UlasanFail_PermohonanAgensiID = 3 
                                order by CreatedDt asc, UlasanFail_ID asc"
                            DeleteCommand="DELETE FROM LESEN_UlasanFailBatal where UlasanFail_ID = @UlasanFail_ID"
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

                <%-- TAB 4: ULASAN AGENSI LUAR (tabUlasanLuar) --%>
                <asp:TabPanel runat="server" ID="tabUlasanLuar" HeaderText="Ulasan Agensi Luar">
                    <HeaderTemplate>Ulasan Agensi Luar</HeaderTemplate>
                    <ContentTemplate>
                        <asp:GridView ID="gvTabUlasanLuar" runat="server" ShowHeaderWhenEmpty="True"
                            AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="UlasanFail_ID"
                            DataSourceID="SqlDataSourceTabUlasanLuar"
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
                                        Fail :
                                        <asp:HyperLink ID="hpFile" runat="server" NavigateUrl='<%# Eval("UlasanFail_FilePath") %>' Target="_blank"><%#Eval("UlasanFail_FileName") %></asp:HyperLink>
                                        <asp:HiddenField ID="hdnFldUlasanFail_FileName" Value='<%# Bind("UlasanFail_FileName") %>' runat="server" />
                                        <asp:HiddenField ID="hdnFldUlasanFail_ContentType" Value='<%# Bind("UlasanFail_ContentType") %>' runat="server" />
                                        <asp:HiddenField ID="hdnFldUlasanFail_FilePath" Value='<%# Bind("UlasanFail_FilePath") %>' runat="server" />
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:FileUpload ID="txtUlasanFail_FilePath" runat="server" CssClass="form-control"></asp:FileUpload>
                                        <asp:Button ID="btnUpload" runat="server" Text="Muat Naik" OnClick="btnUpload_Click" Visible="false"
                                            OnClientClick="return confirm('Fail sedia ada akan ditukar ke fail yang baru.');" />
                                        <asp:HiddenField ID="hdnFldUlasanFail_FileName" Value='<%# Bind("UlasanFail_FileName") %>' runat="server" />
                                        <asp:HiddenField ID="hdnFldUlasanFail_ContentType" Value='<%# Bind("UlasanFail_ContentType") %>' runat="server" />
                                        <asp:HiddenField ID="hdnFldUlasanFail_FilePath" Value='<%# Bind("UlasanFail_FilePath") %>' runat="server" />
                                    </EditItemTemplate>
                                    <HeaderStyle Width="25%" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Maklumat Ulasan" HeaderStyle-Font-Size="10pt" HeaderStyle-Width="90%" ItemStyle-Width="90%">
                                    <ItemTemplate>
                                        <asp:Label ID="Label15" runat="server" Text="Ulasan :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                        <asp:Label ID="Label16" runat="server" Text='<%# If(Len(Eval("UlasanFail_Remarks").ToString()) > 0, (Eval("UlasanFail_Remarks")).Replace(vbCr, "").Replace(vbLf, vbCrLf).Replace(Environment.NewLine, "<br />"), Eval("UlasanFail_Remarks")) %>' Font-Size="10pt"></asp:Label><br />
                                        <asp:Label ID="Label9" runat="server" Text="Fail :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                        <asp:HyperLink ID="hpFileMobile" CssClass="paraGraphtext" runat="server" NavigateUrl='<%# Eval("UlasanFail_FilePath") %>' Target="_blank" Font-Bold="True" Font-Size="10pt"><%#If(Len(Eval("UlasanFail_FileName").ToString()) > 25, Eval("UlasanFail_FileName").ToString.Substring(Len(Eval("UlasanFail_FileName").ToString()) - 25), Eval("UlasanFail_FileName")) %></asp:HyperLink><br />
                                        <asp:Label ID="Label13" runat="server" Text="Jabatan/Agensi :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                        <asp:Label ID="Label19" runat="server" Text='<%# Eval("JabatanAgensi_Description") %>' Font-Size="10pt"></asp:Label><br />
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
                                    </EditItemTemplate>
                                    <ItemStyle HorizontalAlign="Left" />
                                </asp:TemplateField>
                            </Columns>
                            <PagerStyle CssClass="pgr" />
                        </asp:GridView>

                        <asp:SqlDataSource ID="SqlDataSourceTabUlasanLuar" runat="server"
                            ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                            SelectCommand=" SELECT a.*,b.JabatanAgensi_Description FROM LESEN_UlasanFailBatal a
                                left join LESEN_JabatanAgensi b on b.JabatanAgensi_ID = a.UlasanFail_PermohonanAgensiID
                                where UlasanFail_PermohonanID = @PermohonanID AND UlasanFail_PermohonanAgensiID <> 3 
                                order by CreatedDt asc, UlasanFail_ID asc"
                            DeleteCommand="DELETE FROM LESEN_UlasanFailBatal where UlasanFail_ID = @UlasanFail_ID"
                            UpdateCommand="UPDATE LESEN_UlasanFailBatal SET UlasanFail_Remarks = @UlasanFail_Remarks, 
                                UlasanFail_FileName = @UlasanFail_FileName,
                                UlasanFail_ContentType = @UlasanFail_ContentType,
                                UlasanFail_FilePath = @UlasanFail_FilePath,
                                LastModID = @LastModID, LastModDt = GETDATE()
                                WHERE (UlasanFail_ID = @UlasanFail_ID)">
                            <DeleteParameters>
                                <asp:ControlParameter ControlID="gvTabUlasanLuar" DefaultValue="" Name="UlasanFail_ID" PropertyName="SelectedValue" />
                            </DeleteParameters>
                            <SelectParameters>
                                <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedDataKey.Values[0]" Name="PermohonanID"></asp:ControlParameter>
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

                <%-- TAB 5: MESYUARAT & WANG AMANAH (tabWangAmanah) --%>
                <asp:TabPanel runat="server" ID="tabWangAmanah" HeaderText="Mesyuarat / Wang Amanah">
                    <HeaderTemplate>Mesyuarat / Wang Amanah</HeaderTemplate>
                    <ContentTemplate>
                        <br />
                        <div class="card card-outline card-primary mb-3">
                            <div class="card-header">
                                <h3 class="card-title"><i class="fas fa-users mr-1"></i> Maklumat Mesyuarat</h3>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Tarikh Mesyuarat</label>
                                            <asp:TextBox ID="TB_TarikhMesyuarat" runat="server" TextMode="Date" CssClass="form-control" />
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>No Mesyuarat</label>
                                            <asp:TextBox ID="TB_NoMesyuarat" runat="server" CssClass="form-control" />
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Tindakan Pembatalan</label>
                                            <asp:DropDownList ID="DDL_TindakanBatal" CssClass="form-control select2" style="width: 100%;" runat="server"
                                                DataSourceID="SqlDataSourceTindakan" DataTextField="name" DataValueField="id">
                                            </asp:DropDownList>
                                            <asp:SqlDataSource runat="server" ID="SqlDataSourceTindakan" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                                SelectCommand="SELECT id, name FROM TBL_LOOKUPS WHERE lookupgrp_id = 10005 AND status = 1"></asp:SqlDataSource>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="card card-outline card-secondary mb-3">
                            <div class="card-header">
                                <h3 class="card-title"><i class="fas fa-money-check-alt mr-1"></i> Maklumat Wang Amanah</h3>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Wang Amanah Diterima (RM)</label>
                                            <asp:Label ID="lblDepositAmount" runat="server" Text="0.00" CssClass="form-control"></asp:Label>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Tarikh Diterima</label>
                                            <asp:Label ID="lblDepositDate" runat="server" Text="-" CssClass="form-control"></asp:Label>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Nombor Resit</label>
                                            <asp:Label ID="lblDepositResitNo" runat="server" Text="-" CssClass="form-control"></asp:Label>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="form-group">
                                            <label>Pemulangan Wang Amanah (RM)</label>
                                            <asp:Label ID="lblDepositPulangAmount" runat="server" Text="0.00" CssClass="form-control highlighted"></asp:Label>
                                        </div>
                                    </div>
                                </div>
                                <hr />
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Hantar ke kewangan?</label>
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
                            </div>
                            <div class="card-footer">
                                <div class="row">
                                    <div class="col-md-12 text-center">
                                        <asp:LinkButton ID="BtnSaveMesyuarat" runat="server" CausesValidation="False" Text="Kemaskini" CssClass="btn btn-warning" OnClick="BtnSaveMesyuarat_Click" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <br />
                    </ContentTemplate>
                </asp:TabPanel>

            </asp:TabContainer>

            <%-- ========================================================================= --%>
            <%-- SECTION 4: MAIN LISTING & SEARCH FILTER (idListing & GridView1)           --%>
            <%-- ========================================================================= --%>
            <div class="card" runat="server" id="idListing">
                <div class="card-body" style="overflow-x: auto;">
                    <div class="row">
                        <div class="col-md-10">
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
                                            SelectCommand="SELECT * FROM 
                                        (select '0' as JenisLesen_ID, '-- Lesen --' as JenisLesen_Description
                                        union all
                                        select JenisLesen_Description AS JenisLesen_ID, JenisLesen_Description from LESEN_JenisLesen where JenisLesen_IsActive=1
                                        ) as tbl1 order by JenisLesen_Description "></asp:SqlDataSource>
                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <asp:TextBox ID="TB_TarikhBatal" runat="server" TextMode="Date" CssClass="form-control" />
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
                                        select ApprStatusID, Description from ApprovalStatusBatal
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

                    <asp:GridView ID="GridView1" runat="server" Visible="true" AllowPaging="true"
                        AllowSorting="True" AutoGenerateColumns="False" 
                        DataKeyNames="Permohonan_ID,ApprStatusID,JenisLesenIdList,IsSuratPembatalanFail,IsPublish"
                        DataSourceID="SqlDataSourceGrid"
                        CssClass="table table-bordered" PagerStyle-CssClass="pgr"
                        AlternatingRowStyle-CssClass="alt">
                        <AlternatingRowStyle CssClass="alt" />
                        <Columns>
                            <asp:BoundField DataField="RowNo" HeaderText="No" SortExpression="RowNo"></asp:BoundField>
                            <asp:BoundField DataField="Rujukan" HeaderText="No Rujukan" SortExpression="Rujukan" />
                            <asp:BoundField DataField="JenisLesenDescList" HeaderText="Jenis Lesen" SortExpression="JenisLesenDescList" />
                            <asp:BoundField DataField="Pemohon_Name" HeaderText="Nama Pemohon" SortExpression="Pemohon_Name" />
                            <asp:BoundField DataField="CreatedDt" HeaderText="Tarikh Batal" DataFormatString="{0:dd/MM/yyyy}" SortExpression="CreatedDt" />
                            <asp:BoundField DataField="StatusDesc" HeaderText="Status" SortExpression="StatusDesc" />

                            <asp:TemplateField HeaderText="Maklumat Permohonan" HeaderStyle-Font-Size="10pt" HeaderStyle-Width="90%" ItemStyle-Width="90%">
                                <ItemTemplate>
                                    <asp:Label ID="Label4" runat="server" Text="No Rujukan :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                    <asp:Label ID="Label8" runat="server" Text='<%# Eval("Rujukan") %>' Font-Size="10pt"></asp:Label><br />
                                    <asp:Label ID="Label15" runat="server" Text="Tarikh Batal :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                    <asp:Label ID="Label16" runat="server" Text='<%# Eval("CreatedDt", "{0:dd/MM/yyyy}") %>' Font-Size="10pt"></asp:Label><br />
                                    <asp:Label ID="Label9" runat="server" Text="Jenis Lesen :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                    <asp:Label ID="Label10" runat="server" Text='<%# Eval("JenisLesenDescList") %>' Font-Size="10pt"></asp:Label><br />
                                    <asp:Label ID="Label11" runat="server" Text="Nama Pemohon :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                    <asp:Label ID="Label12" runat="server" Text='<%# Eval("Pemohon_Name") %>' Font-Size="10pt"></asp:Label><br />
                                    <asp:Label ID="Label17" runat="server" Text="Status :" Font-Bold="True" Font-Size="10pt"></asp:Label><br />
                                    <asp:Label ID="Label18" runat="server" Text='<%# Eval("StatusDesc") %>' Font-Size="10pt"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:TemplateField>

                            <asp:TemplateField ShowHeader="False">
                                <ItemTemplate>
                                    <asp:LinkButton runat="server" Text="Lihat" CommandName="Select" CausesValidation="False"
                                        ID="LinkButton5" Visible='<%# If(Eval("UserType") > 0 And Eval("StatusID") > 0, True, False) %>' CssClass="btn btn-warning btn-sm"></asp:LinkButton>

                                    <asp:LinkButton runat="server" Text="Surat" CommandName="Surat" CausesValidation="False" ID="LinkButton6"
                                        Visible='<%# If(Eval("UserType") > 0 And Eval("IsPublish") = True, True, False) %>'
                                        CssClass="btn btn-warning btn-sm" CommandArgument='<%# Container.DataItemIndex %>'></asp:LinkButton>

                                    <asp:LinkButton runat="server" Text="Lampiran 1" CommandName="Lampiran1" CausesValidation="False" ID="LinkButton7"
                                        Visible='<%# If(Eval("UserType") > 0 And Eval("IsPublish") = True, True, False) %>'
                                        CssClass="btn btn-warning btn-sm" CommandArgument='<%# Container.DataItemIndex %>'></asp:LinkButton>

                                    <asp:LinkButton runat="server" Text="Lampiran 2" CommandName="Lampiran2" CausesValidation="False" ID="LinkButton3"
                                        Visible='<%# If(Eval("UserType") > 0 And Eval("IsPublish") = True, True, False) %>'
                                        CssClass="btn btn-warning btn-sm" CommandArgument='<%# Container.DataItemIndex %>'></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="TarikhMohon" HeaderText="TarikhMohon" DataFormatString="{0:dd/MM/yyyy}" SortExpression="TarikhMohon" Visible="false"></asp:BoundField>
                            <asp:BoundField DataField="Is24jam" HeaderText="Risiko" SortExpression="Is24jam" Visible="false"></asp:BoundField>
                        </Columns>
                        <PagerStyle CssClass="pgr" />
                    </asp:GridView>
					
                    <div class="row">
                        <div class="col-md-12">
                            <div class="form-group" style="text-align: right; float: right;">
                                <table>
                                    <tr>
                                        <td>
                                            <div style="background-color: #ff7070; width: 20px">&nbsp;</div>
                                        </td>
                                        <td>
                                            &nbsp;&nbsp;<asp:Label ID="legendTitle" runat="server" Text="Sedang dalam pemerhatian/proses oleh bahagian agensi" Font-Size="10pt"></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </section>

    <asp:Button ID="ui_btnPageBottom" runat="server" Text="-" Style="margin-left: -999px;" />

    <%-- ========================================================================= --%>
    <%-- SECTION 5: MAIN GRID DATA SOURCES (SqlDataSourceGrid)                    --%>
    <%-- ========================================================================= --%>
    <asp:SqlDataSource ID="SqlDataSourceGrid" runat="server"
        ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
        SelectCommand="SELECT ROW_NUMBER() OVER(ORDER BY TarikhMohon desc, Permohonan_ID desc) as RowNo, * FROM (
            SELECT ROW_NUMBER() OVER (PARTITION BY a.Permohonan_ID ORDER BY a.ApprovalID DESC) AS RepNo,
            (CASE WHEN a.ApprStatusID < 9 AND ISNULL(a.AgensiID, 0) > 0 then a.Description + ' - ' + e.JabatanAgensi_Description ELSE a.Description END) AS StatusDesc,
            @AgensiID AS UserType, a.*, g.JenisLesenIdList, g.JenisLesenDescList, g.Rujukan, g.IsSuratPembatalanFail, g.StatusID, g.IsPublish, g.Is24jam, f.Pemohon_Name, h.CreatedDt FROM 
            v_LESEN_ApprovalListBatal_Curr a 
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
            and g.JenisLesenDescList LIKE case when @LesenDesc = '0' then g.JenisLesenDescList else '%'+@LesenDesc+'%' end
            and (CONVERT(VARCHAR(25), h.CreatedDt, 126) LIKE '%'+@TarikhBatal+'%' 
            or h.CreatedDt IS NULL)
            and a.ApprStatusID = case when @statusID = -1 then a.ApprStatusID else @statusID end
            and g.StatusID > 0  
            and g.IsBatal = 1 
            and g.JenisLesenIdList is not null
            and g.JenisLesenIdList <> '27'
            ) AS tbl WHERE RepNo = 1 order by TarikhMohon desc, Permohonan_ID desc">
        <SelectParameters>
            <asp:SessionParameter SessionField="sessionEstateID" DefaultValue="0" Name="AgensiID"></asp:SessionParameter>
            <asp:ControlParameter ControlID="txtNoRujukan" PropertyName="Text" DefaultValue="%%" Name="Rujukan"></asp:ControlParameter>
            <asp:ControlParameter ControlID="DDL_JenisLesen" PropertyName="SelectedValue" Name="LesenDesc"></asp:ControlParameter>
            <asp:ControlParameter ControlID="TB_TarikhBatal" PropertyName="Text" DefaultValue="%%" Name="TarikhBatal"></asp:ControlParameter>
            <asp:ControlParameter ControlID="ddlStatus" PropertyName="SelectedValue" Name="statusID"></asp:ControlParameter>
        </SelectParameters>
    </asp:SqlDataSource>

    <%-- ========================================================================= --%>
    <%-- SECTION 6: CLIENT SCRIPTS                                                 --%>
    <%-- ========================================================================= --%>
    <script>
        function pageLoad() {
            $(function () {
                // Initialize Select2 Elements
                $('.select2').select2();
                $('.select2bs4').select2({
                    theme: 'bootstrap4'
                });

                // Initialize Datepicker
                $('.datepicker').datepicker({
                    dateFormat: 'dd/mm/yy',
                    defaultDate: new Date()
                });

                // Input Masks
                $('#datemask').inputmask('dd/mm/yyyy', { 'placeholder': 'dd/mm/yyyy' });
                $('#datemask2').inputmask('mm/dd/yyyy', { 'placeholder': 'mm/dd/yyyy' });
                $('[data-mask]').inputmask();
            });
        }
    </script>

</asp:Content>
