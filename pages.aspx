<%@ Page Title="" Language="VB" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="pages.aspx.vb" Inherits="pages" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server"></asp:Content>



<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" Runat="Server">
    
<%--    <div class="divContentPageMain">
        <div class="divContentPage">

        <div id="ContentPageTitle" class="divTitlePage" runat="server"></div>
        <div id="idContentBody" runat="Server" class="contentBox"></div>
        
        <div class="clear"></div>
        </div>
    </div>--%>

    <section class="content-header">
        <div class="container-fluid">

            <asp:Label ID="lblDummy" runat="server" Text=""></asp:Label>

            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0 text-dark">
                        <div runat="server" id="ContentPageTitle"></div>
                    </h1>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        
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

           <div id="idContentBody" runat="Server" ></div>

        </div>
    </section>

</asp:Content>

