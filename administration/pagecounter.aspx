<%@ Page Title="" Language="VB" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="pagecounter.aspx.vb" Inherits="html_administration_pagecounter" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="txtWindowTitle">Hit Counter Summary</div>
    <p>
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
    </p>
    <div id="idPageSummary" runat="server">
    </div>
    <p>
        &nbsp;</p>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:GridView ID="GridView1" runat="server" AllowPaging="True" 
                AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="Counter_Id" 
                CssClass="mGrid" PagerStyle-CssClass="pgr" 
                AlternatingRowStyle-CssClass="alt" PageSize="30"
                DataSourceID="SqlDataSource1" EnableModelValidation="True" Width="100%">
                <Columns>
                    <asp:BoundField DataField="Counter_Id" HeaderText="Counter_Id" 
                        InsertVisible="False" ReadOnly="True" SortExpression="Counter_Id" 
                        Visible="False" />
                    <asp:BoundField DataField="Counter_IP" HeaderText="IP Address" 
                        SortExpression="Counter_IP" />
                    <asp:BoundField DataField="Counter_OS" HeaderText="Operating System" 
                        SortExpression="Counter_OS" />
                    <asp:BoundField DataField="Counter_DateTime" HeaderText="Date/Time" 
                        SortExpression="Counter_DateTime" />
                    <asp:BoundField DataField="Counter_Browser" HeaderText="Browser" 
                        SortExpression="Counter_Browser" />
                    <asp:BoundField DataField="Counter_Others" HeaderText="Details" 
                        SortExpression="Counter_Others" />
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" 
                SelectCommand="SELECT * FROM [TBL_COUNTER]
ORDER BY Counter_Id DESC"></asp:SqlDataSource>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

