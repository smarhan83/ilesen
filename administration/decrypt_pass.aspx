<%@ Page Title="" Language="VB" MasterPageFile="Site.master" AutoEventWireup="false" CodeFile="decrypt_pass.aspx.vb" Inherits="html_administration_encrypt_pass" %><%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="txtWindowTitle">
        Decrypt password</div>
        <asp:ScriptManager ID="ToolkitScriptManager1" runat="server">
</asp:ScriptManager>
<asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
    <div id="idContentDecryptPass" runat="server">
        <br />
        Username :
        <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
        &nbsp;<asp:Button ID="Button1" runat="server" Text="Decrypt Password" />
        <br />
        <br />
        Password :
        <asp:Label ID="Label1" runat="server"></asp:Label>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
<br />
<br />
</asp:Content>

