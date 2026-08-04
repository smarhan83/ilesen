<%@ Page Title="" Language="VB" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="sepandukKelulusan.aspx.vb" Inherits="sepandukKelulusan" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="asp" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadContent" runat="Server">

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">

    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0 text-dark"><div runat="server" id="idWindowTitle">Kelulusan - Sepanduk / Bunting / Sepanduk Besar</div></h1>
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

            <%--# =========================== SENARAI PERMOHONAN MENUNGGU KELULUSAN =========================== #--%>
            <div class="card" runat="server" id="idListing">
                <div class="card-header">
                    <h3 class="card-title">Senarai Permohonan Menunggu Kelulusan</h3>
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
                        DataSourceID="SqlDataSourceGridKelulusan"
                        CssClass="table table-bordered" PagerStyle-CssClass="pgr"
                        AlternatingRowStyle-CssClass="alt" >
                        <AlternatingRowStyle CssClass="alt" />
                        <Columns>
                            <asp:BoundField DataField="SepandukPermohonan_ID" HeaderText="ID" ReadOnly="True" SortExpression="SepandukPermohonan_ID" />
                            <asp:BoundField DataField="SepandukPermohonan_NoRujukan" HeaderText="No Rujukan" SortExpression="SepandukPermohonan_NoRujukan" />
                            <asp:BoundField DataField="SepandukPermohonan_JenisPermohonan" HeaderText="Jenis" SortExpression="SepandukPermohonan_JenisPermohonan" />
                            <asp:BoundField DataField="SepandukPermohonan_NamaPemohon" HeaderText="Nama Pemohon" SortExpression="SepandukPermohonan_NamaPemohon" />
                            <asp:BoundField DataField="SepandukPermohonan_LokasiPemasangan" HeaderText="Lokasi Pemasangan" SortExpression="SepandukPermohonan_LokasiPemasangan" />
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

            <asp:SqlDataSource ID="SqlDataSourceGridKelulusan" runat="server"
                ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                SelectCommand="SELECT * FROM (SELECT * FROM LESEN_SepandukPermohonan WHERE SepandukPermohonan_IsActive = 1 AND SepandukPermohonan_Status IN ('Semakan KB Inspektorat','Semakan KB Lesen','Perakuan KJ Lesen')) as TBL1 WHERE 1=1 ORDER BY SepandukPermohonan_ID DESC">
            </asp:SqlDataSource>

            <asp:Panel ID="pnlDetail" runat="server" Visible="false">

                <div class="card">
                    <div class="card-body">

        <%--<h2 class="section-title">MAKLUMAT PERMOHONAN</h2>--%>

                    <div class="row">

                        <!-- KIRI -->
                        <div class="col-md-6">

                        <%--# =========================== BUTIRAN PERMOHONAN =========================== #--%>
                        <div class="card card-info">
                            <div class="card-header">
                                <h3 class="card-title">Butiran Permohonan</h3>
                            </div>
                            <div class="card-body">
                                <asp:FormView ID="FormView1" runat="server" DataSourceID="SqlDataSourceDetail" DefaultMode="ReadOnly" RenderOuterTable="false">
                                    <ItemTemplate>
                                        <h4 class="section-title">Maklumat Permohonan</h4>

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

                                        <hr />

                                        <h4 class="section-title">Lokasi</h4>

                                        <div class="address-box">
                                            <div class="info-icon"><i class="bi bi-geo-alt-fill"></i></div>
                                            <div>
                                                <div class="info-label">Lokasi Pemasangan</div>
                                                <div class="info-value"><%# Eval("SepandukPermohonan_LokasiPemasangan") %></div>
                                            </div>
                                        </div>

                                        <div class="info-item">
                                            <div class="info-icon"><i class="bi bi-info-circle-fill"></i></div>
                                            <div>
                                                <div class="info-label">Status Semasa</div>
                                                <div class="info-value"><%# Eval("SepandukPermohonan_Status") %></div>
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

                        </div>
                        <div class="col-md-6">
                        <%--# =========================== SEMAKAN PEGAWAI IK (READONLY) =========================== #--%>
                        <div class="card card-secondary">
                            <div class="card-header">
                                <h3 class="card-title">Semakan Pegawai IK</h3>
                            </div>
                            <div class="card-body">
                                <asp:FormView ID="FormView2" runat="server" DataSourceID="SqlDataSourceSemakanIK" DefaultMode="ReadOnly" RenderOuterTable="false">
                                    <ItemTemplate>
                                        <h4 class="section-title">Maklumat Semakan</h4>

                                        <div class="info-item">
                                            <div class="info-icon"><i class="bi bi-clipboard-check-fill"></i></div>
                                            <div>
                                                <div class="info-label">Status Permit</div>
                                                <div class="info-value"><%# Eval("SemakanIK_StatusPermit") %></div>
                                            </div>
                                        </div>

                                        <div class="info-item">
                                            <div class="info-icon"><i class="bi bi-calendar-event"></i></div>
                                            <div>
                                                <div class="info-label">Tarikh Semakan</div>
                                                <div class="info-value"><%# Eval("SemakanIK_TarikhSemakan", "{0:dd/MM/yyyy}") %></div>
                                            </div>
                                        </div>

                                        <hr />

                                        <h4 class="section-title">Ulasan &amp; Pemerhatian</h4>

                                        <div class="address-box">
                                            <div class="info-icon"><i class="bi bi-chat-square-text-fill"></i></div>
                                            <div>
                                                <div class="info-label">Ulasan</div>
                                                <div class="info-value"><%# Eval("SemakanIK_Ulasan") %></div>
                                            </div>
                                        </div>

                                        <div class="address-box">
                                            <div class="info-icon"><i class="bi bi-eye-fill"></i></div>
                                            <div>
                                                <div class="info-label">Hasil Pemerhatian</div>
                                                <div class="info-value"><%# Eval("SemakanIK_HasilPemerhatian") %></div>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                    <EmptyDataTemplate>
                                        <p class="text-muted">Tiada rekod semakan IK.</p>
                                    </EmptyDataTemplate>
                                </asp:FormView>
                            </div>
                        </div>

                        <asp:SqlDataSource ID="SqlDataSourceSemakanIK" runat="server"
                            ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                            SelectCommand="SELECT TOP 1 * FROM LESEN_SepandukSemakanIK WHERE SemakanIK_PermohonanID = @SepandukPermohonan_ID ORDER BY SemakanIK_ID DESC">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="GridView1" Name="SepandukPermohonan_ID" PropertyName="SelectedValue" />
                            </SelectParameters>
                        </asp:SqlDataSource>

                        </div>

                    </div>

                    </div>
                </div>

                <%--# =========================== TRAIL KELULUSAN (READONLY) =========================== #--%>
                <asp:Panel ID="pnlTrailKelulusan" runat="server" Visible="false">
                <div class="card card-secondary">
                    <div class="card-header">
                        <h3 class="card-title">Trail Kelulusan</h3>
                    </div>
                    <div class="card-body" style="overflow-x: auto;">
                        <asp:GridView ID="GridViewTrail" runat="server" AutoGenerateColumns="False"
                            DataSourceID="SqlDataSourceTrail" CssClass="table table-bordered" Width="100%">
                            <Columns>
                                <asp:BoundField DataField="Kelulusan_Peringkat" HeaderText="Peringkat" />
                                <asp:BoundField DataField="Kelulusan_Keputusan" HeaderText="Keputusan" />
                                <asp:BoundField DataField="Kelulusan_Catatan" HeaderText="Catatan" />
                                <asp:BoundField DataField="Kelulusan_Tarikh" HeaderText="Tarikh" DataFormatString="{0:dd/MM/yyyy hh:mm tt}" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>

                <asp:SqlDataSource ID="SqlDataSourceTrail" runat="server"
                    ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                    SelectCommand="SELECT * FROM LESEN_SepandukKelulusan WHERE Kelulusan_PermohonanID = @SepandukPermohonan_ID ORDER BY Kelulusan_ID ASC">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="GridView1" Name="SepandukPermohonan_ID" PropertyName="SelectedValue" />
                    </SelectParameters>
                </asp:SqlDataSource>
                </asp:Panel>

                <%--# =========================== BORANG KB INSPEKTORAT =========================== #--%>
                <asp:Panel ID="pnlKBInspektorat" runat="server" Visible="false">
                    <div class="card card-primary">
                        <div class="card-header">
                            <h3 class="card-title">Semakan &amp; Sokongan - KB Inspektorat</h3>
                        </div>
                        <div class="card-body">
                            <asp:FormView ID="FormViewKBInspektorat" runat="server" DataSourceID="SqlDataSourceKBInspektorat" DefaultMode="Insert" RenderOuterTable="false">
                                <InsertItemTemplate>
                                    <div class="row">
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label>Keputusan</label>
                                                <asp:DropDownList ID="ddlKeputusan" runat="server" SelectedValue='<%# Bind("Kelulusan_Keputusan") %>' CssClass="form-control select2">
                                                    <asp:ListItem Value="">-- Sila Pilih --</asp:ListItem>
                                                    <asp:ListItem Value="Sokong">Sokong</asp:ListItem>
                                                    <asp:ListItem Value="Tidak Sokong">Tidak Sokong</asp:ListItem>
                                                </asp:DropDownList>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" CssClass="cssRequiredField"
                                                    ControlToValidate="ddlKeputusan" ErrorMessage="Sila Pilih" ValidationGroup="frmKBInspektorat" Display="Dynamic"></asp:RequiredFieldValidator>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-8">
                                            <div class="form-group">
                                                <label>Catatan</label>
                                                <asp:TextBox ID="txtCatatan" runat="server" Text='<%# Bind("Kelulusan_Catatan") %>' CssClass="form-control" TextMode="MultiLine" Rows="3" />
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card-footer">
                                        <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" 
                                            Text="Hantar Kepada KB Lesen" ValidationGroup="frmKBInspektorat" CssClass="btn btn-primary" 
                                            OnClientClick="return confirm('Anda pasti untuk menghantar rekod ini?');"/>
                                        &nbsp;
                                        <asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Kembali" CssClass="btn btn-default" OnClick="InsertCancelButton_Click" />
                                    </div>
                                </InsertItemTemplate>
                            </asp:FormView>
                        </div>
                    </div>

                    <asp:SqlDataSource ID="SqlDataSourceKBInspektorat" runat="server"
                        ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                        InsertCommand="
                        INSERT INTO LESEN_SepandukKelulusan (Kelulusan_PermohonanID, Kelulusan_Peringkat, Kelulusan_PegawaiID, Kelulusan_Keputusan, Kelulusan_Catatan, Kelulusan_Tarikh)
                        VALUES (@PermohonanID, 'KB Inspektorat', @PegawaiID, @Kelulusan_Keputusan, @Kelulusan_Catatan, getdate())">
                        <InsertParameters>
                            <asp:ControlParameter ControlID="GridView1" Name="PermohonanID" PropertyName="SelectedValue" />
                            <asp:SessionParameter SessionField="sessionUserId" Name="PegawaiID" />
                            <asp:Parameter Name="Kelulusan_Keputusan" />
                            <asp:Parameter Name="Kelulusan_Catatan" />
                        </InsertParameters>
                    </asp:SqlDataSource>
                </asp:Panel>

                <%--# =========================== BORANG KB LESEN =========================== #--%>
                <asp:Panel ID="pnlKBLesen" runat="server" Visible="false">
                    <div class="card card-primary">
                        <div class="card-header">
                            <h3 class="card-title">Syorkan Tindakan - KB Lesen</h3>
                        </div>
                        <div class="card-body">
                            <asp:FormView ID="FormViewKBLesen" runat="server" DataSourceID="SqlDataSourceKBLesen" DefaultMode="Insert" RenderOuterTable="false">
                                <InsertItemTemplate>
                                    <div class="row">
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label>Syor Tindakan</label>
                                                <asp:DropDownList ID="ddlKeputusan" runat="server" SelectedValue='<%# Bind("Kelulusan_Keputusan") %>' CssClass="form-control select2">
                                                    <asp:ListItem Value="">-- Sila Pilih --</asp:ListItem>
                                                    <asp:ListItem Value="Syor Rampas Wang Amanah">Syor Rampas Wang Amanah</asp:ListItem>
                                                    <asp:ListItem Value="Syor Kembalikan Wang Amanah">Syor Kembalikan Wang Amanah</asp:ListItem>
                                                    <asp:ListItem Value="Catatan">Catatan</asp:ListItem>
                                                </asp:DropDownList>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" CssClass="cssRequiredField"
                                                    ControlToValidate="ddlKeputusan" ErrorMessage="Sila Pilih" ValidationGroup="frmKBLesen" Display="Dynamic"></asp:RequiredFieldValidator>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-8">
                                            <div class="form-group">
                                                <label>Catatan / Justifikasi</label>
                                                <asp:TextBox ID="txtCatatan" runat="server" Text='<%# Bind("Kelulusan_Catatan") %>' CssClass="form-control" TextMode="MultiLine" Rows="3" />
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card-footer">
                                        <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" 
                                            Text="Hantar Kepada KJ Lesen" ValidationGroup="frmKBLesen" CssClass="btn btn-primary"
                                            OnClientClick="return confirm('Anda pasti untuk menghantar rekod ini?');"/>
                                        &nbsp;
                                        <asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Kembali" CssClass="btn btn-default" OnClick="InsertCancelButton_Click" />
                                    </div>
                                </InsertItemTemplate>
                            </asp:FormView>
                        </div>
                    </div>

                    <asp:SqlDataSource ID="SqlDataSourceKBLesen" runat="server"
                        ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                        InsertCommand="
                        INSERT INTO LESEN_SepandukKelulusan (Kelulusan_PermohonanID, Kelulusan_Peringkat, Kelulusan_PegawaiID, Kelulusan_Keputusan, Kelulusan_Catatan, Kelulusan_Tarikh)
                        VALUES (@PermohonanID, 'KB Lesen', @PegawaiID, @Kelulusan_Keputusan, @Kelulusan_Catatan, getdate())">
                        <InsertParameters>
                            <asp:ControlParameter ControlID="GridView1" Name="PermohonanID" PropertyName="SelectedValue" />
                            <asp:SessionParameter SessionField="sessionUserId" Name="PegawaiID" />
                            <asp:Parameter Name="Kelulusan_Keputusan" />
                            <asp:Parameter Name="Kelulusan_Catatan" />
                        </InsertParameters>
                    </asp:SqlDataSource>
                </asp:Panel>



                <%--# =========================== BORANG KJ LESEN =========================== #--%>
                <asp:Panel ID="pnlKJLesen" runat="server" Visible="false">
                    <div class="card card-primary">
                        <div class="card-header">
                            <h3 class="card-title">Perakuan - KJ Lesen</h3>
                        </div>
                        <div class="card-body">
                            <asp:FormView ID="FormViewKJLesen" runat="server" DataSourceID="SqlDataSourceKJLesen" DefaultMode="Insert" RenderOuterTable="false">
                                <InsertItemTemplate>
                                    <div class="row">
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label>Keputusan</label>
                                                <asp:DropDownList ID="ddlKeputusan" runat="server" SelectedValue='<%# Bind("Kelulusan_Keputusan") %>' CssClass="form-control select2">
                                                    <asp:ListItem Value="">-- Sila Pilih --</asp:ListItem>
                                                    <asp:ListItem Value="Diperakukan">Diperakukan</asp:ListItem>
                                                    <asp:ListItem Value="Tidak Diperakukan">Tidak Diperakukan</asp:ListItem>
                                                </asp:DropDownList>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" CssClass="cssRequiredField"
                                                    ControlToValidate="ddlKeputusan" ErrorMessage="Sila Pilih" ValidationGroup="frmKJLesen" Display="Dynamic"></asp:RequiredFieldValidator>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-8">
                                            <div class="form-group">
                                                <label>Catatan</label>
                                                <asp:TextBox ID="txtCatatan" runat="server" Text='<%# Bind("Kelulusan_Catatan") %>' CssClass="form-control" TextMode="MultiLine" Rows="3" />
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card-footer">
                                        <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" 
                                            Text="Hantar" ValidationGroup="frmKJLesen" CssClass="btn btn-primary" 
                                            OnClientClick="return confirm('Anda pasti untuk menghantar rekod ini?');"
                                            />
                                        &nbsp;
                                        <asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Kembali" CssClass="btn btn-default" OnClick="InsertCancelButton_Click" />
                                    </div>
                                </InsertItemTemplate>
                            </asp:FormView>
                        </div>
                    </div>

                    <asp:SqlDataSource ID="SqlDataSourceKJLesen" runat="server"
                        ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                        InsertCommand="
                        INSERT INTO LESEN_SepandukKelulusan (Kelulusan_PermohonanID, Kelulusan_Peringkat, Kelulusan_PegawaiID, Kelulusan_Keputusan, Kelulusan_Catatan, Kelulusan_Tarikh)
                        VALUES (@PermohonanID, 'KJ Lesen', @PegawaiID, @Kelulusan_Keputusan, @Kelulusan_Catatan, getdate())">
                        <InsertParameters>
                            <asp:ControlParameter ControlID="GridView1" Name="PermohonanID" PropertyName="SelectedValue" />
                            <asp:SessionParameter SessionField="sessionUserId" Name="PegawaiID" />
                            <asp:Parameter Name="Kelulusan_Keputusan" />
                            <asp:Parameter Name="Kelulusan_Catatan" />
                        </InsertParameters>
                    </asp:SqlDataSource>
                </asp:Panel>

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
