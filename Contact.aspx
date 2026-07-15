<%@ Page Title="Contact" Language="VB" MasterPageFile="~/MasterMenu.Master" AutoEventWireup="true" CodeFile="Contact.aspx.vb" Inherits="Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <section class="content-header">
        <div class="container-fluid">

            <asp:ScriptManager ID="ScriptManager2" runat="server">
            </asp:ScriptManager>

            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0 text-dark"><%: Title %></h1>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="#">Kulim Sundry</a></li>
                        <li class="breadcrumb-item active"><%: Title %></li>
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
            <h3>KULIM SUNDRY SYSTEM.</h3>
            <address>
                Kulim (Malaysia) Berhad<br />
                Kulim Sundry System Administrator<br />
                <abbr title="Phone">P:</abbr>
                +607-7777777
            </address>

            <address>
                <strong>Support:</strong>   <a href="mailto:support@kplant.com.my">support@kplant.com.my</a><br />
                <strong>Marketing:</strong> <a href="mailto:marketing@kplant.com.my">marketing@kplant.com.my</a>
            </address>
        </div>
    </section>
</asp:Content>
