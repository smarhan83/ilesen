<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ugm.aspx.vb" Inherits="html_administration_ugm" MasterPageFile="~/MasterMenu.master" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <style type="text/css">



    </style>
  </asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <div>
    
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div class="txtWindowTitle">
                    Add/Edit Module</div>
                <asp:FormView ID="FormView1" runat="server" DataKeyNames="UGM_Id" 
                    DataSourceID="SqlDataSource1" DefaultMode="Insert" 
                    EnableModelValidation="True" Width="563px">
                    <EditItemTemplate>
                        UGM_Id:
                        <asp:Label ID="UGM_IdLabel1" runat="server" Text='<%# Eval("UGM_Id") %>' />
                        <br />
                        UGM_Name:
                        <asp:TextBox ID="UGM_NameTextBox" runat="server" 
                            Text='<%# Bind("UGM_Name") %>' />
                        <br />
                        UGM_Filename:
                        <asp:TextBox ID="UGM_FilenameTextBox" runat="server" 
                            Text='<%# Bind("UGM_Filename") %>' />
                        <br />
                        <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" 
                            CommandName="Update" Text="Update" />
                        &nbsp;<asp:LinkButton ID="UpdateCancelButton" runat="server" 
                            CausesValidation="False" CommandName="Cancel" Text="Cancel" />
                    </EditItemTemplate>
                    <InsertItemTemplate>
                        <br />
                        <table style="width:100%;">
                            <tr valign="top">
                                <td nowrap>
                                    Module Name:
                                </td>
                                <td>
                                    <asp:TextBox ID="UGM_NameTextBox" runat="server" Text='<%# Bind("UGM_Name") %>' 
                                        Width="473px" />
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                                        ControlToValidate="UGM_NameTextBox" ErrorMessage="*" 
                                        ValidationGroup="frmInsert"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top" nowrap>
                                    Filename:&nbsp;</td>
                                <td>
                                    <asp:TextBox ID="UGM_FilenameTextBox" runat="server" Height="55px" 
                                        Text='<%# Bind("UGM_Filename") %>' TextMode="MultiLine" Width="473px" Rows="3" />
                                </td>
                            </tr>
                        </table>
                        <br />
                        <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" 
                            CommandName="Insert" Text="Insert" ValidationGroup="frmInsert" />
                        &nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" 
                            CausesValidation="False" CommandName="Cancel" Text="Cancel" />
                    </InsertItemTemplate>
                    <ItemTemplate>
                        UGM_Id:
                        <asp:Label ID="UGM_IdLabel" runat="server" Text='<%# Eval("UGM_Id") %>' />
                        <br />
                        UGM_Name:
                        <asp:Label ID="UGM_NameLabel" runat="server" Text='<%# Bind("UGM_Name") %>' />
                        Filename:
                        <asp:Label ID="UGM_FilenameLabel" runat="server" 
                            Text='<%# Bind("UGM_Filename") %>' />
                        <br />
                        <asp:LinkButton ID="EditButton" runat="server" CausesValidation="False" 
                            CommandName="Edit" Text="Edit" />
                        &nbsp;<asp:LinkButton ID="DeleteButton" runat="server" CausesValidation="False" 
                            CommandName="Delete" Text="Delete" />
                        &nbsp;<asp:LinkButton ID="NewButton" runat="server" CausesValidation="False" 
                            CommandName="New" Text="New" />
                    </ItemTemplate>
                </asp:FormView>
                <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" 
                    DeleteCommand="DELETE FROM TBL_USER_GROUPMODULE WHERE UGM_Id = @UGM_Id" 
                    InsertCommand="INSERT INTO TBL_USER_GROUPMODULE(UGM_Name, UGM_Filename) VALUES (@UGM_Name, @UGM_Filename)" 
                    SelectCommand="SELECT UGM_Id, UGM_Name, UGM_Filename FROM TBL_USER_GROUPMODULE ORDER BY UGM_Id" 
                    
                    UpdateCommand="UPDATE TBL_USER_GROUPMODULE SET UGM_Name = @UGM_Name, UGM_Filename = @UGM_Filename WHERE UGM_Id = @UGM_Id">
                    <DeleteParameters>
                        <asp:Parameter Name="UGM_Id" />
                    </DeleteParameters>
                    <InsertParameters>
                        <asp:Parameter Name="UGM_Name" />
                        <asp:Parameter Name="UGM_Filename" />
                    </InsertParameters>
                    <UpdateParameters>
                        <asp:Parameter Name="UGM_Name" />
                        <asp:Parameter Name="UGM_Filename" />
                        <asp:Parameter Name="UGM_Id" />
                    </UpdateParameters>
                </asp:SqlDataSource>
                <br />
                <asp:GridView ID="GridView1" runat="server" AllowPaging="True" 
                    AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="UGM_Id" 
                    DataSourceID="SqlDataSource1" EnableModelValidation="True" Width="100%"
                    CssClass="mGrid" PagerStyle-CssClass="pgr" 
                    AlternatingRowStyle-CssClass="alt" PageSize="20">
                    <Columns>
                        <asp:BoundField DataField="UGM_Name" HeaderText="Module Name" 
                            SortExpression="UGM_Name" />
                        <asp:TemplateField HeaderText="Filename" SortExpression="UGM_Filename">
                            <EditItemTemplate>
                                <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("UGM_Filename") %>' 
                                    Height="59px" TextMode="MultiLine" Width="333px" Rows="4"></asp:TextBox>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="Label1" runat="server" Text='<%# Bind("UGM_Filename") %>'></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle Width="250px" Wrap="False" />
                            <ItemStyle Width="200px" Wrap="False" />
                        </asp:TemplateField>
                        <asp:TemplateField ShowHeader="False">
                            <ItemTemplate>
                                <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" 
                                    CommandName="Delete" Text="Delete" OnClientClick="return confirm('Are you sure to delete it?');"></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:CommandField ShowEditButton="True" />
                        <asp:BoundField DataField="UGM_Id" HeaderText="UGM_Id" 
                            SortExpression="UGM_Id" InsertVisible="False" ReadOnly="True" 
                            Visible="False" />
                    </Columns>
                </asp:GridView>
            </ContentTemplate>
        </asp:UpdatePanel>
    
    </div>
</asp:Content>
