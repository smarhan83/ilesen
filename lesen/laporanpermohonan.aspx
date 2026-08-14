<%@ Page Title="" Language="VB" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="laporanpermohonan.aspx.vb" Inherits="laporanpermohonan" %>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">

    <section class="content-header">
        <div class="container-fluid">

            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0 text-dark"><div runat="server" id="idWindowTitle"></div></h1>
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

    <section class="content">
        <div class="container-fluid">

            <!-- Map card -->
            <div class="card card-primary">
                <div class="card-header">
                    <h3 class="card-title">Jana Laporan Permohonan</h3>
                </div>
                <!-- /.card-header -->
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Jenis Laporan</label>
                                <asp:DropDownList ID="ddlReport" runat="server" CssClass="form-control select2">
                                    <asp:ListItem Value="0">-- Sila Pilih --</asp:ListItem> 
                                    <asp:ListItem Value="1">Lesen Perniagaan Permit</asp:ListItem>
                                    <asp:ListItem Value="2">Lesen Pembatalan</asp:ListItem>
                                    <asp:ListItem Value="3">Belum Dapat Ulasan Inspektorat</asp:ListItem>
                                    <asp:ListItem Value="4">Lesen Sepanduk</asp:ListItem>
                                    <asp:ListItem Value="5">Lesen Pasar Lambak</asp:ListItem>
                                    <asp:ListItem Value="6">Lesen Anjing</asp:ListItem>
                                    <asp:ListItem Value="7">Lesen Penjaja</asp:ListItem>
                                </asp:DropDownList>
                                <%--<asp:DropDownList ID="DropDownListFieldStatus" CssClass="form-control select2" runat="server">
                                    <asp:ListItem Value="0">-- Sila Pilih --</asp:ListItem>  
                                    <asp:ListItem Value="1">Jenis Lesen</asp:ListItem>  
                                    <asp:ListItem Value="2">Kategori</asp:ListItem>  
                                </asp:DropDownList>--%>
                            </div>
                        </div>
                    </div>
        
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>Tarikh Mula</label>
                                <asp:TextBox Text='<%# Bind("date1") %>' ID="TB_Date1" TextMode="Date" CssClass="form-control" runat="server"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="TB_Date1" CssClass="text-danger" runat="server" ErrorMessage="Sila pilih" ValidationGroup="sumbitForm"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>Tarikh Akhir</label>
                                <asp:TextBox Text='<%# Bind("date2") %>' ID="TB_Date2" TextMode="Date" CssClass="form-control" runat="server"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ControlToValidate="TB_Date2" CssClass="text-danger" runat="server" ErrorMessage="Sila pilih" ValidationGroup="sumbitForm"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <asp:Label ID="Label1" runat="server"></asp:Label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card-footer">
                    <asp:Button ID="ButtonSubmit" runat="server" Text="Jana Laporan" CssClass-="btn btn-primary" CausesValidation="true" ValidationGroup="sumbitForm" />
                </div>
            </div>

        </div>
    </section>

</asp:Content>



