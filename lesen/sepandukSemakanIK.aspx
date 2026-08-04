<%@ Page Title="" Language="VB" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="sepandukSemakanIK.aspx.vb" Inherits="sepandukSemakanIK" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="asp" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadContent" runat="Server">

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">

    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0 text-dark"><div runat="server" id="idWindowTitle">Semakan Pegawai IK - Sepanduk / Bunting / Sepanduk Besar</div></h1>
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

            <%--# =========================== SENARAI PERMOHONAN MENUNGGU SEMAKAN =========================== #--%>
            <div class="card" runat="server" id="idListing">
                <div class="card-header">
                    <h3 class="card-title">Senarai Permohonan Menunggu Semakan</h3>
                </div>
                <div class="card-body" style="overflow-x: auto;">
                    <%--# START FILTER - set SortExpression at GridView as fieldname & add WHERE 1=1 at SqlDataSource - SelectCommand #--%>
                    <div class="row">
                        <div class="col-md-10">
                            <div id="pnlFilter" runat="server" class="row"></div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-default" Text="Cari" />
                                <asp:Button ID="btnReset" CssClass="btn btn-default" runat="server" Text="Set Semula" />
                            </div>
                        </div>
                    </div>
                    <%--# END FILTER #--%>

                    <asp:GridView ID="GridView1" runat="server"
                        AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="SepandukPermohonan_ID"
                        DataSourceID="SqlDataSourceGridIK"
                        CssClass="table table-bordered" PagerStyle-CssClass="pgr"
                        AlternatingRowStyle-CssClass="alt" >
                        <AlternatingRowStyle CssClass="alt" />
                        <Columns>
                            <asp:BoundField DataField="SepandukPermohonan_ID" HeaderText="ID" ReadOnly="True" SortExpression="SepandukPermohonan_ID" />
                            <asp:BoundField DataField="SepandukPermohonan_NoRujukan" HeaderText="No Rujukan" SortExpression="SepandukPermohonan_NoRujukan" />
                            <asp:BoundField DataField="SepandukPermohonan_JenisPermohonan" HeaderText="Jenis" SortExpression="SepandukPermohonan_JenisPermohonan" />
                            <asp:BoundField DataField="SepandukPermohonan_NamaPemohon" HeaderText="Nama Pemohon" SortExpression="SepandukPermohonan_NamaPemohon" />
                            <asp:BoundField DataField="SepandukPermohonan_LokasiPemasangan" HeaderText="Lokasi Pemasangan" SortExpression="SepandukPermohonan_LokasiPemasangan" />
                            <asp:BoundField DataField="SepandukPermohonan_NoPermit" HeaderText="No Permit" SortExpression="SepandukPermohonan_NoPermit" />
                            <asp:BoundField DataField="SepandukPermohonan_Status" HeaderText="Status" SortExpression="SepandukPermohonan_Status" />
                            <asp:TemplateField ShowHeader="False">
                                <ItemTemplate>
                                    <asp:LinkButton runat="server" Text="Semak" CommandName="Select" CausesValidation="False" ID="LinkButton2" CssClass="btn btn-primary btn-sm"></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <PagerStyle CssClass="pgr" />
                    </asp:GridView>
                </div>
            </div>

            <asp:SqlDataSource ID="SqlDataSourceGridIK" runat="server"
                ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                SelectCommand="SELECT * FROM (SELECT * FROM LESEN_SepandukPermohonan WHERE SepandukPermohonan_IsActive = 1 AND SepandukPermohonan_Status IN ('Baru','Semakan IK')) as tbl1 WHERE 1=1 ORDER BY SepandukPermohonan_ID DESC">
            </asp:SqlDataSource>

            <%--# =========================== BUTIRAN PERMOHONAN DIPILIH (READONLY) =========================== #--%>
            <asp:Panel ID="pnlDetail" runat="server" Visible="false">

                <div class="card card-info">
                    <div class="card-header">
                        <h3 class="card-title">Butiran Permohonan</h3>
                    </div>
                    <div class="card-body">
                        <asp:FormView ID="FormView1" runat="server" DataSourceID="SqlDataSourceDetail" DefaultMode="ReadOnly" RenderOuterTable="false">
                            <ItemTemplate>
                                <h4 class="section-title">Maklumat Permohonan</h4>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="info-item">
                                            <div class="info-icon"><i class="bi bi-hash"></i></div>
                                            <div>
                                                <div class="info-label">No Rujukan</div>
                                                <div class="info-value"><%# Eval("SepandukPermohonan_NoRujukan") %></div>
                                            </div>
                                        </div>

                                        <div class="info-item">
                                            <div class="info-icon"><i class="bi bi-person-fill"></i></div>
                                            <div>
                                                <div class="info-label">Nama Pemohon</div>
                                                <div class="info-value"><%# Eval("SepandukPermohonan_NamaPemohon") %></div>
                                            </div>
                                        </div>

                                        <div class="info-item">
                                            <div class="info-icon"><i class="bi bi-calendar-event"></i></div>
                                            <div>
                                                <div class="info-label">Tarikh Mohon</div>
                                                <div class="info-value"><%# Eval("SepandukPermohonan_TarikhPermohonan", "{0:dd/MM/yyyy}") %></div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="info-item">
                                            <div class="info-icon"><i class="bi bi-person-vcard-fill"></i></div>
                                            <div>
                                                <div class="info-label">Jenis Permohonan</div>
                                                <div class="info-value"><%# Eval("SepandukPermohonan_JenisPermohonan") %></div>
                                            </div>
                                        </div>

                                        <div class="info-item">
                                            <div class="info-icon"><i class="bi bi-file-earmark-text-fill"></i></div>
                                            <div>
                                                <div class="info-label">No Permit</div>
                                                <div class="info-value"><%# Eval("SepandukPermohonan_NoPermit") %></div>
                                            </div>
                                        </div>

                                        <div class="info-item">
                                            <div class="info-icon"><i class="bi bi-info-circle-fill"></i></div>
                                            <div>
                                                <div class="info-label">Status Semasa</div>
                                                <div class="info-value"><%# Eval("SepandukPermohonan_Status") %></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <hr />

                                <h4 class="section-title">Lokasi</h4>

                                <div class="address-box">
                                    <div class="info-icon"><i class="bi bi-geo-alt-fill"></i></div>
                                    <div>
                                        <div class="info-label">Lokasi Pemasangan</div>
                                        <div class="info-value"><%# Eval("SepandukPermohonan_LokasiPemasangan") %></div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:FormView>
                    </div>
                </div>                

                <asp:SqlDataSource ID="SqlDataSourceDetail" runat="server"
                    ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                    SelectCommand="SELECT * FROM LESEN_SepandukPermohonan WHERE SepandukPermohonan_ID = @SepandukPermohonan_ID">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="GridView1" Name="SepandukPermohonan_ID" PropertyName="SelectedValue" />
                    </SelectParameters>
                </asp:SqlDataSource>

                <%--# =========================== BORANG SEMAKAN IK =========================== #--%>
                <div class="card card-primary">
                    <div class="card-header">
                        <h3 class="card-title">Rekod Semakan / Ulasan / Hasil Pemerhatian</h3>
                    </div>
                    <div class="card-body">
                        <asp:FormView ID="FormView2" runat="server" DataSourceID="SqlDataSourceSemakan" DefaultMode="Insert" RenderOuterTable="false">
                            <InsertItemTemplate>
                                <div class="row">
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Status Permit</label>
                                            <asp:DropDownList ID="ddlSemakanIK_StatusPermit" runat="server"
                                                SelectedValue='<%# Bind("SemakanIK_StatusPermit") %>' CssClass="form-control select2">
                                                <asp:ListItem Value="">-- Sila Pilih --</asp:ListItem>
                                                <asp:ListItem Value="Sah">Sah (Dalam Tempoh &amp; Berdaftar)</asp:ListItem>
                                                <asp:ListItem Value="Tamat Tempoh">Tamat Tempoh (Masih Dipasang)</asp:ListItem>
                                                <asp:ListItem Value="Tidak Berdaftar">Tidak Berdaftar (Tiada Dalam ProLesen)</asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="ddlSemakanIK_StatusPermit" ErrorMessage="Sila Pilih" ValidationGroup="frmSemakan" Display="Dynamic"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Ulasan (jika permit tamat tempoh tapi masih dipasang)</label>
                                            <asp:TextBox ID="txtSemakanIK_Ulasan" runat="server"
                                                Text='<%# Bind("SemakanIK_Ulasan") %>' CssClass="form-control" TextMode="MultiLine" Rows="4" />
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Hasil Pemerhatian (jika tidak berdaftar dalam ProLesen)</label>
                                            <asp:TextBox ID="txtSemakanIK_HasilPemerhatian" runat="server"
                                                Text='<%# Bind("SemakanIK_HasilPemerhatian") %>' CssClass="form-control" TextMode="MultiLine" Rows="4" />
                                        </div>
                                    </div>
                                </div>

                                <div class="card-footer">
                                    <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" 
                                        Text="Hantar Kepada KB Inspektorat" ValidationGroup="frmSemakan" CssClass="btn btn-primary"
                                         OnClientClick="return confirm('Anda pasti untuk menghantar rekod ini?');" />
                                    &nbsp;
                                    <asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Kembali" CssClass="btn btn-default" OnClick="InsertCancelButton_Click" />
                                </div>
                            </InsertItemTemplate>
                        </asp:FormView>
                    </div>
                </div>

                <asp:SqlDataSource ID="SqlDataSourceSemakan" runat="server"
                    ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                    InsertCommand="
                    INSERT INTO LESEN_SepandukSemakanIK
                    (SemakanIK_PermohonanID, SemakanIK_PegawaiIK, SemakanIK_TarikhSemakan, SemakanIK_StatusPermit, SemakanIK_Ulasan, SemakanIK_HasilPemerhatian)
                    VALUES
                    (@SemakanIK_PermohonanID, @SemakanIK_PegawaiIK, getdate(), @SemakanIK_StatusPermit, @SemakanIK_Ulasan, @SemakanIK_HasilPemerhatian)">
                    <InsertParameters>
                        <asp:ControlParameter ControlID="GridView1" Name="SemakanIK_PermohonanID" PropertyName="SelectedValue" />
                        <%--# NOTA: sesuaikan SessionField ikut session variable ID pengguna sebenar dalam sistem awak --%>
                        <asp:SessionParameter SessionField="sessionUserId" Name="SemakanIK_PegawaiIK" />
                        <asp:Parameter Name="SemakanIK_StatusPermit" />
                        <asp:Parameter Name="SemakanIK_Ulasan" />
                        <asp:Parameter Name="SemakanIK_HasilPemerhatian" />
                    </InsertParameters>
                </asp:SqlDataSource>
            </asp:Panel>

        </div>
    </section>

    <script>
        function pageLoad() {
            $(function () {
                $('.select2').select2()
            })
        }
    </script>

</asp:Content>
