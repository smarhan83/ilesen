<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ReportViewer1.aspx.vb" Inherits="wfrmReport1" %>
<%@ Register Assembly="CrystalDecisions.Web, Version=13.0.2000.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" Namespace="CrystalDecisions.Web" TagPrefix="CR" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
                <CR:CrystalReportViewer ID="reportSys" runat="server" AutoDataBind="True"
                Height="659px" ToolPanelView="None" BestFitPage="False" ToolPanelWidth="100%" Width="100%"
                EnableDatabaseLogonPrompt="False" HasCrystalLogo="False" />
        </div>
    </form>
</body>
</html>
