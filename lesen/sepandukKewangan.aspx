<%@ Page Title="" Language="VB" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="sepandukKewangan.aspx.vb" Inherits="sepandukKewangan" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="asp" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadContent" runat="Server">

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">

    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0 text-dark"><div runat="server" id="idWindowTitle">Update Kewangan - Sepanduk / Bunting / Sepanduk Besar</div></h1>
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

            <%--# =========================== SENARAI PERMOHONAN SELESAI DIPERAKUKAN =========================== #--%>
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">Senarai Permohonan Sedia Untuk Update Kewangan</h3>
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
                        DataSourceID="SqlDataSourceGridKewangan"
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

            <asp:SqlDataSource ID="SqlDataSourceGridKewangan" runat="server"
                ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                SelectCommand="SELECT * FROM (SELECT * FROM LESEN_SepandukPermohonan WHERE SepandukPermohonan_IsActive = 1 AND SepandukPermohonan_Status = 'Selesai') as TBL1 WHERE 1=1 ORDER BY SepandukPermohonan_ID DESC">
            </asp:SqlDataSource>

            <asp:Panel ID="pnlDetail" runat="server" Visible="false">

                <%--# =========================== BUTIRAN PERMOHONAN =========================== #--%>
                <div class="card card-info">
                    <div class="card-header">
                        <h3 class="card-title">Butiran Permohonan</h3>
                    </div>
                    <div class="card-body">
                        <asp:FormView ID="FormView1" runat="server" DataSourceID="SqlDataSourceDetail" DefaultMode="ReadOnly"  RenderOuterTable="false">
                            <ItemTemplate>
                                <div class="row">
                                    <div class="col-md-3"><b>No Rujukan:</b><br /><%# Eval("SepandukPermohonan_NoRujukan") %></div>
                                    <div class="col-md-3"><b>Jenis:</b><br /><%# Eval("SepandukPermohonan_JenisPermohonan") %></div>
                                    <div class="col-md-3"><b>Tarikh Permohonan:</b><br /><%# Eval("SepandukPermohonan_TarikhPermohonan", "{0:dd/MM/yyyy}") %></div>
                                    <div class="col-md-3"><b>No Permit:</b><br /><%# Eval("SepandukPermohonan_NoPermit") %></div>
                                </div>
                                <hr />
                                <div class="row">
                                    <div class="col-md-6"><b>Nama Pemohon:</b><br /><%# Eval("SepandukPermohonan_NamaPemohon") %></div>
                                    <div class="col-md-6"><b>Lokasi Pemasangan:</b><br /><%# Eval("SepandukPermohonan_LokasiPemasangan") %></div>
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

                <%--# =========================== TRAIL KELULUSAN (READONLY) =========================== #--%>
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

                <%--# =========================== BORANG UPDATE KEWANGAN =========================== #--%>
                <div class="card card-primary">
                    <div class="card-header">
                        <h3 class="card-title">Update Kewangan</h3>
                    </div>
                    <div class="card-body">
                        <asp:FormView ID="FormViewKewangan" runat="server" DataSourceID="SqlDataSourceKewangan" DefaultMode="Insert"  RenderOuterTable="false">
                            <InsertItemTemplate>
                                <div class="row">
                                    <div class="col-md-8">
                                        <div class="form-group">
                                            <label>Catatan Kewangan</label>
                                            <asp:TextBox ID="txtCatatan" runat="server" Text='<%# Bind("Kelulusan_Catatan") %>' CssClass="form-control" TextMode="MultiLine" Rows="3" />
                                        </div>
                                    </div>
                                </div>
                                <div class="card-footer">
                                    <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" Text="Sahkan Update Kewangan" ValidationGroup="frmKewangan" CssClass="btn btn-primary" OnClientClick="return confirm('Anda pasti rekod ini sudah dikemaskini di Kewangan?');" />
                                    &nbsp;
                                    <asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Batal" CssClass="btn btn-default" OnClick="InsertCancelButton_Click" />
                                </div>
                            </InsertItemTemplate>
                        </asp:FormView>
                    </div>
                </div>

                <asp:SqlDataSource ID="SqlDataSourceKewangan" runat="server"
                    ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                    InsertCommand="
                    INSERT INTO LESEN_SepandukKelulusan (Kelulusan_PermohonanID, Kelulusan_Peringkat, Kelulusan_PegawaiID, Kelulusan_Keputusan, Kelulusan_Catatan, Kelulusan_Tarikh)
                    VALUES (@PermohonanID, 'Kewangan', @PegawaiID, 'Dikemaskini', @Kelulusan_Catatan, getdate())">
                    <InsertParameters>
                        <asp:ControlParameter ControlID="GridView1" Name="PermohonanID" PropertyName="SelectedValue" />
                        <asp:SessionParameter SessionField="sessionUserId" Name="PegawaiID" />
                        <asp:Parameter Name="Kelulusan_Catatan" />
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
