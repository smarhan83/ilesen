<%@ Page Title="" Language="VB" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="sepandukpermohonan.aspx.vb" Inherits="sepandukpermohonan" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="asp" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadContent" runat="Server">

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">

    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0 text-dark"><div runat="server" id="idWindowTitle"></div></h1>
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

            <asp:FormView ID="FormView1" runat="server" DataKeyNames="SepandukPermohonan_ID"
                DataSourceID="SqlDataSourceForm" DefaultMode="Insert" Width="100%">
                <EditItemTemplate>

                    <div class="card card-warning">
                    <div class="card-header">
                        <h3 class="card-title"><div runat="server" id="idWindowTitle2">Kemaskini</div></h3>
                        <div class="card-tools">
                            <button type="button" class="btn btn-tool" data-card-widget="collapse"><i class="fas fa-minus"></i></button>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label>No Rujukan</label>
                                    <asp:TextBox ID="txtSepandukPermohonan_NoRujukan" runat="server"
                                        Text='<%# Bind("SepandukPermohonan_NoRujukan") %>' CssClass="form-control" />
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" CssClass="cssRequiredField"
                                        ControlToValidate="txtSepandukPermohonan_NoRujukan" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                            </div>

                            <div class="col-md-3">
                                <div class="form-group">
                                    <label>Jenis Permohonan</label>
                                    <asp:DropDownList ID="ddlSepandukPermohonan_JenisPermohonan" runat="server"
                                        SelectedValue='<%# Bind("SepandukPermohonan_JenisPermohonan") %>' CssClass="form-control select2">
                                        <asp:ListItem Value="">-- Sila Pilih --</asp:ListItem>
                                        <asp:ListItem Value="Sepanduk">Sepanduk</asp:ListItem>
                                        <asp:ListItem Value="Bunting">Bunting</asp:ListItem>
                                        <asp:ListItem Value="Sepanduk Besar">Sepanduk Besar</asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" CssClass="cssRequiredField"
                                        ControlToValidate="ddlSepandukPermohonan_JenisPermohonan" ErrorMessage="Sila Pilih" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                            </div>

                            <div class="col-md-3">
                                <div class="form-group">
                                    <label>Tarikh Permohonan</label>
                                    <asp:TextBox ID="txtSepandukPermohonan_TarikhPermohonan" runat="server"
                                        Text='<%# Bind("SepandukPermohonan_TarikhPermohonan", "{0:yyyy-MM-dd}") %>' CssClass="form-control datepicker" placeholder="yyyy-mm-dd" />
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" CssClass="cssRequiredField"
                                        ControlToValidate="txtSepandukPermohonan_TarikhPermohonan" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                            </div>

                            <div class="col-md-3">
                                <div class="form-group">
                                    <label>No Permit (jika ada)</label>
                                    <asp:TextBox ID="txtSepandukPermohonan_NoPermit" runat="server"
                                        Text='<%# Bind("SepandukPermohonan_NoPermit") %>' CssClass="form-control" />
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>Nama Pemohon</label>
                                    <asp:TextBox ID="txtSepandukPermohonan_NamaPemohon" runat="server"
                                        Text='<%# Bind("SepandukPermohonan_NamaPemohon") %>' CssClass="form-control" />
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" CssClass="cssRequiredField"
                                        ControlToValidate="txtSepandukPermohonan_NamaPemohon" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                            </div>

                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>No Telefon</label>
                                    <asp:TextBox ID="txtSepandukPermohonan_NoTelefon" runat="server"
                                        Text='<%# Bind("SepandukPermohonan_NoTelefon") %>' CssClass="form-control" />
                                </div>
                            </div>

                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>Status</label>
                                    <asp:DropDownList ID="ddlSepandukPermohonan_Status" runat="server"
                                        SelectedValue='<%# Bind("SepandukPermohonan_Status") %>' CssClass="form-control select2">
                                        <asp:ListItem Value="Baru">Baru</asp:ListItem>
                                        <asp:ListItem Value="Semakan IK">Semakan IK</asp:ListItem>
                                        <asp:ListItem Value="Semakan KB Inspektorat">Semakan KB Inspektorat</asp:ListItem>
                                        <asp:ListItem Value="Semakan KB Lesen">Semakan KB Lesen</asp:ListItem>
                                        <asp:ListItem Value="Perakuan KJ Lesen">Perakuan KJ Lesen</asp:ListItem>
                                        <asp:ListItem Value="Selesai">Selesai</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>Alamat Pemohon</label>
                                    <asp:TextBox ID="txtSepandukPermohonan_AlamatPemohon" runat="server"
                                        Text='<%# Bind("SepandukPermohonan_AlamatPemohon") %>' CssClass="form-control" TextMode="MultiLine" Rows="3" />
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>Lokasi Pemasangan</label>
                                    <asp:TextBox ID="txtSepandukPermohonan_LokasiPemasangan" runat="server"
                                        Text='<%# Bind("SepandukPermohonan_LokasiPemasangan") %>' CssClass="form-control" TextMode="MultiLine" Rows="3" />
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" CssClass="cssRequiredField"
                                        ControlToValidate="txtSepandukPermohonan_LokasiPemasangan" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label>Aktif?</label><br />
                                    <div class="form-check">
                                        <asp:CheckBox ID="cbSepandukPermohonan_IsActive" runat="server" Checked='<%# Bind("SepandukPermohonan_IsActive") %>' CssClass="form-check-input" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="card-footer">
                        <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" CommandName="Update" Text="Kemaskini" ValidationGroup="frmEdit" CssClass="btn btn-warning" />
                        &nbsp;<asp:LinkButton ID="UpdateCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Set Semula" CssClass="btn btn-default" />
                    </div>
                    </div>
                </EditItemTemplate>

                <InsertItemTemplate>
                    <div class="card card-primary">
                    <div class="card-header">
                        <h3 class="card-title"><div runat="server" id="idWindowTitle3">Kunci Masuk</div></h3>
                        <div class="card-tools">
                            <button type="button" class="btn btn-tool" data-card-widget="collapse"><i class="fas fa-minus"></i></button>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label>No Rujukan</label>
                                    <asp:TextBox ID="txtSepandukPermohonan_NoRujukan" runat="server"
                                        Text='<%# Bind("SepandukPermohonan_NoRujukan") %>' CssClass="form-control" />
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" CssClass="cssRequiredField"
                                        ControlToValidate="txtSepandukPermohonan_NoRujukan" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                            </div>

                            <div class="col-md-3">
                                <div class="form-group">
                                    <label>Jenis Permohonan</label>
                                    <asp:DropDownList ID="ddlSepandukPermohonan_JenisPermohonan" runat="server"
                                        SelectedValue='<%# Bind("SepandukPermohonan_JenisPermohonan") %>' CssClass="form-control select2">
                                        <asp:ListItem Value="">-- Sila Pilih --</asp:ListItem>
                                        <asp:ListItem Value="Sepanduk">Sepanduk</asp:ListItem>
                                        <asp:ListItem Value="Bunting">Bunting</asp:ListItem>
                                        <asp:ListItem Value="Sepanduk Besar">Sepanduk Besar</asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" CssClass="cssRequiredField"
                                        ControlToValidate="ddlSepandukPermohonan_JenisPermohonan" ErrorMessage="Sila Pilih" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                            </div>

                            <div class="col-md-3">
                                <div class="form-group">
                                    <label>Tarikh Permohonan</label>
                                    <asp:TextBox ID="txtSepandukPermohonan_TarikhPermohonan" runat="server"
                                        Text='<%# Bind("SepandukPermohonan_TarikhPermohonan", "{0:yyyy-MM-dd}") %>' CssClass="form-control datepicker" placeholder="yyyy-mm-dd"  />
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" CssClass="cssRequiredField"
                                        ControlToValidate="txtSepandukPermohonan_TarikhPermohonan" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                            </div>

                            <div class="col-md-3">
                                <div class="form-group">
                                    <label>No Permit (jika ada)</label>
                                    <asp:TextBox ID="txtSepandukPermohonan_NoPermit" runat="server"
                                        Text='<%# Bind("SepandukPermohonan_NoPermit") %>' CssClass="form-control" />
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>Nama Pemohon</label>
                                    <asp:TextBox ID="txtSepandukPermohonan_NamaPemohon" runat="server"
                                        Text='<%# Bind("SepandukPermohonan_NamaPemohon") %>' CssClass="form-control" />
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" CssClass="cssRequiredField"
                                        ControlToValidate="txtSepandukPermohonan_NamaPemohon" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                            </div>

                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>No Telefon</label>
                                    <asp:TextBox ID="txtSepandukPermohonan_NoTelefon" runat="server"
                                        Text='<%# Bind("SepandukPermohonan_NoTelefon") %>' CssClass="form-control" />
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>Alamat Pemohon</label>
                                    <asp:TextBox ID="txtSepandukPermohonan_AlamatPemohon" runat="server"
                                        Text='<%# Bind("SepandukPermohonan_AlamatPemohon") %>' CssClass="form-control" TextMode="MultiLine" Rows="3" />
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>Lokasi Pemasangan</label>
                                    <asp:TextBox ID="txtSepandukPermohonan_LokasiPemasangan" runat="server"
                                        Text='<%# Bind("SepandukPermohonan_LokasiPemasangan") %>' CssClass="form-control" TextMode="MultiLine" Rows="3" />
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" CssClass="cssRequiredField"
                                        ControlToValidate="txtSepandukPermohonan_LokasiPemasangan" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="card-footer">
                        <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" Text="Kunci Masuk" ValidationGroup="frmEdit" CssClass="btn btn-primary" />
                        &nbsp;
                        <asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Set Semula" CssClass="btn btn-default" />
                    </div>
                    </div>
                </InsertItemTemplate>
            </asp:FormView>

            <asp:SqlDataSource ID="SqlDataSourceForm" runat="server"
                ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                InsertCommand="
                INSERT INTO LESEN_SepandukPermohonan
                (SepandukPermohonan_NoRujukan, SepandukPermohonan_JenisPermohonan, SepandukPermohonan_NamaPemohon,
                SepandukPermohonan_NoTelefon, SepandukPermohonan_AlamatPemohon, SepandukPermohonan_LokasiPemasangan,
                SepandukPermohonan_NoPermit, SepandukPermohonan_TarikhPermohonan, SepandukPermohonan_Status,
                SepandukPermohonan_KeranilLesen, SepandukPermohonan_TarikhRekod, SepandukPermohonan_IsActive) VALUES
                (@SepandukPermohonan_NoRujukan, @SepandukPermohonan_JenisPermohonan, @SepandukPermohonan_NamaPemohon,
                @SepandukPermohonan_NoTelefon, @SepandukPermohonan_AlamatPemohon, @SepandukPermohonan_LokasiPemasangan,
                @SepandukPermohonan_NoPermit, @SepandukPermohonan_TarikhPermohonan, 'Baru',
                @SepandukPermohonan_KeranilLesen, getdate(), 1)"
                SelectCommand="SELECT * FROM LESEN_SepandukPermohonan WHERE SepandukPermohonan_ID = @SepandukPermohonan_ID"
                UpdateCommand="
                UPDATE LESEN_SepandukPermohonan
                SET SepandukPermohonan_NoRujukan = @SepandukPermohonan_NoRujukan, SepandukPermohonan_JenisPermohonan = @SepandukPermohonan_JenisPermohonan,
                SepandukPermohonan_NamaPemohon = @SepandukPermohonan_NamaPemohon, SepandukPermohonan_NoTelefon = @SepandukPermohonan_NoTelefon,
                SepandukPermohonan_AlamatPemohon = @SepandukPermohonan_AlamatPemohon, SepandukPermohonan_LokasiPemasangan = @SepandukPermohonan_LokasiPemasangan,
                SepandukPermohonan_NoPermit = @SepandukPermohonan_NoPermit, SepandukPermohonan_TarikhPermohonan = @SepandukPermohonan_TarikhPermohonan,
                SepandukPermohonan_Status = @SepandukPermohonan_Status, SepandukPermohonan_IsActive = @SepandukPermohonan_IsActive
                WHERE (SepandukPermohonan_ID = @SepandukPermohonan_ID)">
                <InsertParameters>
                    <asp:Parameter Name="SepandukPermohonan_NoRujukan" />
                    <asp:Parameter Name="SepandukPermohonan_JenisPermohonan" />
                    <asp:Parameter Name="SepandukPermohonan_NamaPemohon" />
                    <asp:Parameter Name="SepandukPermohonan_NoTelefon" />
                    <asp:Parameter Name="SepandukPermohonan_AlamatPemohon" />
                    <asp:Parameter Name="SepandukPermohonan_LokasiPemasangan" />
                    <asp:Parameter Name="SepandukPermohonan_NoPermit" />
                    <asp:Parameter Name="SepandukPermohonan_TarikhPermohonan" />
                    <%--# NOTA: sesuaikan SessionField ikut session variable ID pengguna sebenar dalam sistem awak --%>
                    <asp:SessionParameter SessionField="sessionUserId" Name="SepandukPermohonan_KeranilLesen" />
                </InsertParameters>
                <SelectParameters>
                    <asp:ControlParameter ControlID="GridView1" Name="SepandukPermohonan_ID" PropertyName="SelectedValue" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="SepandukPermohonan_NoRujukan" />
                    <asp:Parameter Name="SepandukPermohonan_JenisPermohonan" />
                    <asp:Parameter Name="SepandukPermohonan_NamaPemohon" />
                    <asp:Parameter Name="SepandukPermohonan_NoTelefon" />
                    <asp:Parameter Name="SepandukPermohonan_AlamatPemohon" />
                    <asp:Parameter Name="SepandukPermohonan_LokasiPemasangan" />
                    <asp:Parameter Name="SepandukPermohonan_NoPermit" />
                    <asp:Parameter Name="SepandukPermohonan_TarikhPermohonan" />
                    <asp:Parameter Name="SepandukPermohonan_Status" />
                    <asp:Parameter Name="SepandukPermohonan_IsActive" />
                    <asp:ControlParameter ControlID="GridView1" DefaultValue="" Name="SepandukPermohonan_ID" PropertyName="SelectedValue" />
                </UpdateParameters>
            </asp:SqlDataSource>

            <div class="card">
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
                        DataSourceID="SqlDataSourceGrid"
                        CssClass="table table-bordered" PagerStyle-CssClass="pgr"
                        AlternatingRowStyle-CssClass="alt" >
                        <AlternatingRowStyle CssClass="alt" />
                        <Columns>
                            <asp:BoundField DataField="SepandukPermohonan_ID" HeaderText="ID" InsertVisible="False"
                                ReadOnly="True" SortExpression="SepandukPermohonan_ID" />
                            <asp:BoundField DataField="SepandukPermohonan_NoRujukan" HeaderText="No Rujukan"
                                SortExpression="SepandukPermohonan_NoRujukan" />
                            <asp:BoundField DataField="SepandukPermohonan_JenisPermohonan" HeaderText="Jenis"
                                SortExpression="SepandukPermohonan_JenisPermohonan" />
                            <asp:BoundField DataField="SepandukPermohonan_NamaPemohon" HeaderText="Nama Pemohon"
                                SortExpression="SepandukPermohonan_NamaPemohon" />
                            <asp:BoundField DataField="SepandukPermohonan_LokasiPemasangan" HeaderText="Lokasi Pemasangan"
                                SortExpression="SepandukPermohonan_LokasiPemasangan" />
                            <asp:BoundField DataField="SepandukPermohonan_TarikhPermohonan" HeaderText="Tarikh Permohonan"
                                SortExpression="SepandukPermohonan_TarikhPermohonan" DataFormatString="{0:dd/MM/yyyy}" />
                            <asp:BoundField DataField="SepandukPermohonan_Status" HeaderText="Status"
                                SortExpression="SepandukPermohonan_Status" />
                            <asp:CheckBoxField DataField="SepandukPermohonan_IsActive" HeaderText="Aktif?" SortExpression="SepandukPermohonan_IsActive" />
                            <asp:TemplateField ShowHeader="False">
                                <ItemTemplate>
                                    <asp:LinkButton runat="server" Text="Kemaskini" CommandName="Select" CausesValidation="False" ID="LinkButton2" CssClass="btn btn-warning btn-sm"></asp:LinkButton>
                                    <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False"
                                        CommandName="Delete" Text="Nyah Aktif" OnClientClick="return confirm('Anda Pasti Untuk Nyah Aktif rekod ini?');" CssClass="btn btn-danger btn-sm"></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <PagerStyle CssClass="pgr" />
                    </asp:GridView>
                </div>
            </div>

        </div>
    </section>

    <asp:SqlDataSource ID="SqlDataSourceGrid" runat="server"
        ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
        SelectCommand="SELECT * FROM LESEN_SepandukPermohonan WHERE 1=1 ORDER BY SepandukPermohonan_ID DESC"
        DeleteCommand="UPDATE LESEN_SepandukPermohonan SET SepandukPermohonan_IsActive = 0 WHERE SepandukPermohonan_ID = @SepandukPermohonan_ID">
        <DeleteParameters>
            <asp:ControlParameter ControlID="GridView1" DefaultValue="" Name="SepandukPermohonan_ID" PropertyName="SelectedValue" />
        </DeleteParameters>
    </asp:SqlDataSource>

    <script>

        function pageLoad() {
            $(function () {
                $('.datepicker').datepicker({
                    dateFormat: 'yy-mm-dd',
                    defaultDate: new Date()
                })

                $('.select2').select2()
            })
        }
    </script>

</asp:Content>
