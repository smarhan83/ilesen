<%--<%@ Page Title="" Language="VB" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="ReportViewer.aspx.vb" Inherits="wfrmReport" %>

<%@ Register assembly="CrystalDecisions.Web, Version=13.0.2000.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" namespace="CrystalDecisions.Web" tagprefix="CR" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
        <script src='<%=ResolveUrl("~/crystalreportviewers13/js/crviewer/crv.js")%>' type="text/javascript"></script>

</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:ScriptManager ID="ScriptManager2" runat="server">
</asp:ScriptManager>
        <div runat="server" class="divMainContent">
       
        <div id ="dvReport" runat="server" class="divMainContentInner">           

        <CR:CrystalReportViewer ID="reportSys" runat="server" AutoDataBind="True" 
                Height="50px" ToolPanelView="None" ToolPanelWidth="200px" Width="100%" 
                EnableDatabaseLogonPrompt="False" HasCrystalLogo="False"/>
        <br />

            <asp:Label ID="ErrorTxt" runat="server" Text=""></asp:Label>
        </div>
        </div>
</asp:Content>--%>

<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ReportViewer.aspx.vb" Inherits="wfrmReport" %>

<%@ Register Assembly="CrystalDecisions.Web, Version=13.0.2000.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" Namespace="CrystalDecisions.Web" TagPrefix="CR" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src='<%=ResolveUrl("~/crystalreportviewers13/js/crviewer/crv.js")%>' type="text/javascript"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:ScriptManager ID="ScriptManager2" runat="server">
            </asp:ScriptManager>
            <div runat="server" class="divMainContent">

                <div id="dvReport" runat="server" class="divMainContentInner">

                    <CR:CrystalReportViewer ID="reportSys" runat="server" AutoDataBind="True"
                        Height="659px" ToolPanelView="None" BestFitPage="False" ToolPanelWidth="100%" Width="100%"
                        EnableDatabaseLogonPrompt="False" HasCrystalLogo="False" />
                    <br />

                    <asp:Label ID="ErrorTxt" runat="server" Text=""></asp:Label>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
