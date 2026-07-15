<%@ Page Language="VB" Debug="true" AutoEventWireup="false" CodeFile="webcon.aspx.vb" Inherits="html_administration_webcon" MasterPageFile="~/MasterMenu.master" %>

<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="asp" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit.HTMLEditor" tagprefix="cc1" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <title></title>
    
    <style type="text/css">
        .style1
        {
        }
        #TextArea1
        {
            height: 100px;
            width: 281px;
        }
        #Text1
        {
            width: 276px;
        }
        #Text2
        {
            width: 276px;
        }
        #Text3
        {
            width: 275px;
        }
        #Text4
        {
            width: 274px;
        }
        #Text5
        {
            width: 274px;
        }
        #txtSitetitle
        {
            width: 226px;
        }
        #txtFooter
        {
            width: 223px;
        }
        #txtSiteurl
        {
            width: 224px;
        }
        #txtServername
        {
            width: 221px;
        }
        #txtEmail
        {
            width: 222px;
        }
        #txtMetatag
        {
            height: 61px;
            width: 224px;
        }
        .style2
        {
            font-family : Verdana;
            font-weight : bold;
            font-size : 12px;
            height: 65px;
            width: 148px;
        }
        .style3
        {
            height: 65px;
        }
        .style4
        {
            font-family : Verdana;
            font-weight : bold;
            font-size : 12px;
            height: 26px;
            width: 148px;
        }
        .style5
        {
            height: 26px;
        }
        .style6
        {
            color: #FF0000;
        }
        .style7
        {
            color: #CC0000;
        }
        .style8
        {
            height: 65px;
            color: #CC0000;
        }
        .style9
        {
            font-family : Verdana;
            font-weight : bold;
            font-size : 12px;
        }
        .style10
        {
            width: 314px;
        }
        .style11
        {
            font-family : Verdana;
            font-weight : bold;
            font-size : 12px;
            height: 26px;
        }
    </style>
</asp:Content>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">

    <section class="content-header">
        <div class="container-fluid">
            <%--<div class="txtWindowTitle">Web Configuration            </div>--%>

       

    
    
            <asp:UpdateProgress ID="UpdateProgress1" runat="server" 
                AssociatedUpdatePanelID="UpdatePanel1">
                <ProgressTemplate>
                <asp:Panel ID="Panel1" CssClass="UpdateProgressBackground" runat="server">
                </asp:Panel>        
                <asp:Panel ID="Panel2" CssClass="UpdateProgress" runat="server">             
                    <img alt="" src="../administration/images/progress.gif" />&nbsp;&nbsp;&nbsp;Please Wait...
                </asp:Panel>        
                </ProgressTemplate>
            </asp:UpdateProgress>
    
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0 text-dark">Web Configuration</h1>
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
    
    
    <!-- Main content -->
    <section class="content">
        <div class="container-fluid">

                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>

                            <asp:TextBox ID="txtId" runat="server" Visible="False"></asp:TextBox>

                            <asp:TabContainer ID="TabContainer1" runat="server" ActiveTabIndex="0" 
                                Width="930px" Visible="False">
                            <asp:TabPanel runat="server" HeaderText="TabPanel1" ID="TabPanel1">
                                <HeaderTemplate>
                                    Global Configuration
                                </HeaderTemplate>
                                <ContentTemplate>   
                    
                                    <table style="width:100%;">
                                        <tr>
                                            <td class="style9">
                                                Site Title <span class="style6">*</span></td>
                                            <td>
                                                <asp:TextBox ID="txtSitetitle" runat="server" Width="265px"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style9">
                                                Siteurl <span class="style6">*</span></td>
                                            <td>
                                                <asp:TextBox ID="txtSiteurl" runat="server" Width="265px"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style11">
                                                Server Name <span class="style7">*</span></td>
                                            <td class="style5">
                                                <asp:TextBox ID="txtServername" runat="server" Width="265px"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style9">
                                                Mail Server <span class="style7">*</span></td>
                                            <td class="style5">
                                                <asp:TextBox ID="txtEmailServer" runat="server" Width="265px"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style4">
                                                Email <span class="style7">*</span></td>
                                            <td class="style5">
                                                <asp:TextBox ID="txtEmail" runat="server" Width="266px"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style2" valign="top">
                                                Metatag</td>
                                            <td class="style3">
                                                <asp:TextBox ID="txtMetatag" runat="server" Height="200px" TextMode="MultiLine" 
                                                    Width="600px"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style9" valign="top">
                                                Footer</td>
                                            <td>
                                                <cc1:Editor ID="txtFooter" runat="server" Width="600px" />
                                            </td>
                                        </tr>
                                        </table>

                                </ContentTemplate>
                            </asp:TabPanel>
                            <asp:TabPanel ID="TabPanel2" runat="server" HeaderText="TabPanel2" Visible="False">
                                <HeaderTemplate>
                                    Block Template
                                </HeaderTemplate>
                                <ContentTemplate>

                                    <table>
                                        <tr>
                                            <td class="style9">
                                                <br />
                                                <br />
                                                Block Configuration :</td>
                                            <td>
                                                &nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td class="style9" colspan="2">
                                                <br />
                                                <table style="width:100%;">
                                                    <tr>
                                                        <td class="style10">
                                                            Front Page (Block 1)</td>
                                                        <td>
                                                            Front Page (Block 2)</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="style10">
                                    
                                                            <asp:TextBox ID="txtFrontBlock1_Title" runat="server" Width="263px" Visible="false"></asp:TextBox>
                                                            <br />
                                                            <cc1:Editor ID="txtFrontBlock1_Content" runat="server" Width="450px" />
                                                        </td>
                                                        <td>
                                    
                                                            <asp:TextBox ID="txtFrontBlock2_Title" runat="server" Width="263px" Visible="false"></asp:TextBox>
                                                            <br />
                                                            <cc1:Editor ID="txtFrontBlock2_Content" runat="server" Width="450px" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            Content Page (Block 1)</td>
                                                        <td>
                                                            Content Page (Block 2)</td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                    
                                                            <asp:TextBox ID="txtInsideBlock1_Title" runat="server" Width="263px" Visible="false"></asp:TextBox>
                                                            <br />
                                                            <cc1:Editor ID="txtInsideBlock1_Content" runat="server" Width="450px" />
                                                        </td>
                                                        <td>
                                    
                                                            <asp:TextBox ID="txtInsideBlock2_Title" runat="server" Width="263px" Visible="false"></asp:TextBox>
                                                            <br />
                                                            <cc1:Editor ID="txtInsideBlock2_Content" runat="server" Width="450px" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                
                                     </table>
                                  
                                </ContentTemplate>
                            </asp:TabPanel>
                            </asp:TabContainer>
                                       
                            <table>
                                <tr style="display:none">
                                    <td class="style1" colspan="2">
                                        <asp:Button ID="btnSave" runat="server" Text="Save" />
                                        &nbsp;
                                        <asp:Button ID="btnReset" runat="server" Text="Reset" />
                                    </td>
                                </tr>
                            </table>

                            <br />
                            <asp:FormView ID="FormView1" runat="server" DataKeyNames="Webcon_id" 
                                DataSourceID="SqlDataSource2" DefaultMode="Insert" Width="100%">
                                <EditItemTemplate>
                                    <div class="card card-warning">
                                        <div class="card-header">
                                            <h3 class="card-title">Update Project Menu</h3>

                                            <div class="card-tools">
                                                <button type="button" class="btn btn-tool" data-card-widget="collapse"><i class="fas fa-minus"></i></button>
                                            </div>
                                        </div>
                                        <!-- /.card-header -->
                                        <div class="card-body">

                                                <table style="width:100%;" width="100%" class="table table-bordered">
                                                    <tr>
                                                        <td width="15%">
                                                            Site Title:<span class="style7">*</span></td>
                                                        <td width="85%">
                                                            <asp:TextBox ID="Webcon_SitetitleTextBox" runat="server" CssClass="form-control"
                                                                Text='<%# Bind("Webcon_Sitetitle") %>' Width="300px" />
                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                                                                ControlToValidate="Webcon_SitetitleTextBox" ErrorMessage="Please insert this field." 
                                                                ValidationGroup="frmEdit"></asp:RequiredFieldValidator>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td width="15%">
                                                            Site URL:<span class="style7">*</span></td>
                                                        <td width="85%">
                                                            <asp:TextBox ID="Webcon_SiteurlTextBox" runat="server" CssClass="form-control" 
                                                                Text='<%# Bind("Webcon_Siteurl") %>' Width="300px" />
                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                                                                ControlToValidate="Webcon_SiteurlTextBox" ErrorMessage="Please insert this field." 
                                                                ValidationGroup="frmEdit"></asp:RequiredFieldValidator>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td width="15%">
                                                            Server Name:<span class="style7">*</span></td>
                                                        <td width="85%">
                                                            <asp:TextBox ID="Webcon_ServernameTextBox" runat="server" CssClass="form-control" 
                                                                Text='<%# Bind("Webcon_Servername") %>' Width="300px" />
                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                                                                ControlToValidate="Webcon_ServernameTextBox" 
                                                                ErrorMessage="Please insert this field." ValidationGroup="frmEdit"></asp:RequiredFieldValidator>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td width="15%">
                                                            Mail Server:<span class="style7">*</span></td>
                                                        <td width="85%">
                                                            <asp:TextBox ID="Webcon_EmailServerTextBox" runat="server" CssClass="form-control" 
                                                                Text='<%# Bind("Webcon_EmailServer") %>' Width="300px" />
                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" 
                                                                ControlToValidate="Webcon_EmailServerTextBox" 
                                                                ErrorMessage="Please insert this field." ValidationGroup="frmEdit"></asp:RequiredFieldValidator>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td width="15%">
                                                            Admin Email:<span class="style7">*</span></td>
                                                        <td width="85%">
                                                            <asp:TextBox ID="Webcon_EmailTextBox" runat="server" CssClass="form-control"
                                                                Text='<%# Bind("Webcon_Email") %>' Width="300px" />&nbsp;Separated By Semicolons (;)
                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" 
                                                                ControlToValidate="Webcon_EmailTextBox" ErrorMessage="Please insert this field." 
                                                                ValidationGroup="frmEdit"></asp:RequiredFieldValidator>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td valign="top" width="15%">
                                                            Metatag:</td>
                                                        <td width="85%">
                                                            <asp:TextBox ID="Webcon_MetatagTextBox" runat="server" Height="200px" 
                                                                Text='<%# Bind("Webcon_Metatag") %>' TextMode="MultiLine" Width="600px" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td valign="top" width="15%">
                                                            Footer:</td>
                                                        <td width="85%">
                                                            <cc1:Editor ID="Editor1" runat="server" Content='<%# Bind("Webcon_Footer") %>' 
                                                                Height="300px" Width="600px" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td valign="top" width="15%">
                                                            &nbsp;</td>
                                                        <td width="85%">
                                                <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" CommandName="Update" Text="Update" ValidationGroup="frmEdit" CssClass="btn btn-warning" />
                                                &nbsp;<asp:LinkButton ID="UpdateCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" CssClass="btn btn-default" />
                                                        </td>
                                                    </tr>
                                                </table>

                                        </div>
                                    </div>
                                </EditItemTemplate>
                                <InsertItemTemplate>
                                    <div class="card card-warning">
                                        <div class="card-header">
                                            <h3 class="card-title">Insert Project Menu</h3>

                                            <div class="card-tools">
                                                <button type="button" class="btn btn-tool" data-card-widget="collapse"><i class="fas fa-minus"></i></button>
                                            </div>
                                        </div>
                                        <!-- /.card-header -->
                                        <div class="card-body">

                                            <table style="width:100%;" width="100%" class="table table-bordered">
                                                <tr>
                                                    <td width="15%">
                                                        Site Title:<span class="style7">*</span></td>
                                                    <td width="85%">
                                                        <asp:TextBox ID="Webcon_SitetitleTextBox" runat="server" CssClass="form-control"
                                                            Text='<%# Bind("Webcon_Sitetitle") %>' Width="300px" />
                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                                                            ControlToValidate="Webcon_SitetitleTextBox" ErrorMessage="Please insert this field." 
                                                            ValidationGroup="frmInsert"></asp:RequiredFieldValidator>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td width="15%">
                                                        Site URL:<span class="style7">*</span></td>
                                                    <td width="85%">
                                                        <asp:TextBox ID="Webcon_SiteurlTextBox" runat="server" CssClass="form-control"
                                                            Text='<%# Bind("Webcon_Siteurl") %>' Width="300px" />
                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                                                            ControlToValidate="Webcon_SiteurlTextBox" ErrorMessage="Please insert this field." 
                                                            ValidationGroup="frmInsert"></asp:RequiredFieldValidator>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td width="15%">
                                                        Server Name:<span class="style7">*</span></td>
                                                    <td width="85%">
                                                        <asp:TextBox ID="Webcon_ServernameTextBox" runat="server" CssClass="form-control"
                                                            Text='<%# Bind("Webcon_Servername") %>' Width="300px" />
                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                                                            ControlToValidate="Webcon_ServernameTextBox" 
                                                            ErrorMessage="Please insert this field." ValidationGroup="frmInsert"></asp:RequiredFieldValidator>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td width="15%">
                                                        Mail Server:<span class="style7">*</span></td>
                                                    <td width="85%">
                                                        <asp:TextBox ID="Webcon_EmailServerTextBox" runat="server" CssClass="form-control"
                                                            Text='<%# Bind("Webcon_EmailServer") %>' Width="300px" />
                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" 
                                                            ControlToValidate="Webcon_EmailServerTextBox" 
                                                            ErrorMessage="Please insert this field." ValidationGroup="frmInsert"></asp:RequiredFieldValidator>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td width="15%">
                                                        Admin Email:<span class="style7">*</span></td>
                                                    <td width="85%">
                                                        <asp:TextBox ID="Webcon_EmailTextBox" runat="server" CssClass="form-control"
                                                            Text='<%# Bind("Webcon_Email") %>' Width="300px" />&nbsp;Separated By Semicolons (;)
                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" 
                                                            ControlToValidate="Webcon_EmailTextBox" ErrorMessage="Please insert this field." 
                                                            ValidationGroup="frmInsert"></asp:RequiredFieldValidator>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="top" width="15%">
                                                        Metatag:</td>
                                                    <td width="85%">
                                                        <asp:TextBox ID="Webcon_MetatagTextBox" runat="server" Height="200px" CssClass="form-control"
                                                            Text='<%# Bind("Webcon_Metatag") %>' TextMode="MultiLine" Width="600px" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="top" width="15%">
                                                        Footer:</td>
                                                    <td width="85%">
                                                        <cc1:Editor ID="Editor1" runat="server" Content='<%# Bind("Webcon_Footer") %>' 
                                                            Height="300px" Width="600px" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="top" width="15%">
                                                        &nbsp;</td>
                                                    <td width="85%">
                                                        <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" Text="Insert" ValidationGroup="frmInsert" CssClass="btn btn-warning" />
                                                        &nbsp;
                                                        <asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" CssClass="btn btn-default" />
                                                    </td>
                                                </tr>
                                            </table>

                                        </div>
                                    </div>
                                </InsertItemTemplate>
                                <ItemTemplate>
                                    Webcon_id:
                                    <asp:Label ID="Webcon_idLabel" runat="server" Text='<%# Eval("Webcon_id") %>' />
                                    <br />
                                    Webcon_Sitetitle:
                                    <asp:Label ID="Webcon_SitetitleLabel" runat="server" 
                                        Text='<%# Bind("Webcon_Sitetitle") %>' />
                                    <br />
                                    Webcon_Metatag:
                                    <asp:Label ID="Webcon_MetatagLabel" runat="server" 
                                        Text='<%# Bind("Webcon_Metatag") %>' />
                                    <br />
                                    Webcon_Footer:
                                    <asp:Label ID="Webcon_FooterLabel" runat="server" 
                                        Text='<%# Bind("Webcon_Footer") %>' />
                                    <br />
                                    Webcon_Siteurl:
                                    <asp:Label ID="Webcon_SiteurlLabel" runat="server" 
                                        Text='<%# Bind("Webcon_Siteurl") %>' />
                                    <br />
                                    Webcon_Email:
                                    <asp:Label ID="Webcon_EmailLabel" runat="server" 
                                        Text='<%# Bind("Webcon_Email") %>' />
                                    <br />
                                    Webcon_Servername:
                                    <asp:Label ID="Webcon_ServernameLabel" runat="server" 
                                        Text='<%# Bind("Webcon_Servername") %>' />
                                    <br />
                                    Webcon_Enabled:
                                    <asp:Label ID="Webcon_EnabledLabel" runat="server" 
                                        Text='<%# Bind("Webcon_Enabled") %>' />
                                    <br />
                                    Webcon_FrontBlock1_Title:
                                    <asp:Label ID="Webcon_FrontBlock1_TitleLabel" runat="server" 
                                        Text='<%# Bind("Webcon_FrontBlock1_Title") %>' />
                                    <br />
                                    Webcon_FrontBlock1_Content:
                                    <asp:Label ID="Webcon_FrontBlock1_ContentLabel" runat="server" 
                                        Text='<%# Bind("Webcon_FrontBlock1_Content") %>' />
                                    <br />
                                    Webcon_FrontBlock2_Title:
                                    <asp:Label ID="Webcon_FrontBlock2_TitleLabel" runat="server" 
                                        Text='<%# Bind("Webcon_FrontBlock2_Title") %>' />
                                    <br />
                                    Webcon_FrontBlock2_Content:
                                    <asp:Label ID="Webcon_FrontBlock2_ContentLabel" runat="server" 
                                        Text='<%# Bind("Webcon_FrontBlock2_Content") %>' />
                                    <br />
                                    Webcon_InsideBlock1_Title:
                                    <asp:Label ID="Webcon_InsideBlock1_TitleLabel" runat="server" 
                                        Text='<%# Bind("Webcon_InsideBlock1_Title") %>' />
                                    <br />
                                    Webcon_InsideBlock1_Content:
                                    <asp:Label ID="Webcon_InsideBlock1_ContentLabel" runat="server" 
                                        Text='<%# Bind("Webcon_InsideBlock1_Content") %>' />
                                    <br />
                                    Webcon_InsideBlock2_Title:
                                    <asp:Label ID="Webcon_InsideBlock2_TitleLabel" runat="server" 
                                        Text='<%# Bind("Webcon_InsideBlock2_Title") %>' />
                                    <br />
                                    Webcon_InsideBlock2_Content:
                                    <asp:Label ID="Webcon_InsideBlock2_ContentLabel" runat="server" 
                                        Text='<%# Bind("Webcon_InsideBlock2_Content") %>' />
                                    <br />
                                    Webcon_Counter:
                                    <asp:Label ID="Webcon_CounterLabel" runat="server" 
                                        Text='<%# Bind("Webcon_Counter") %>' />
                                    <br />
                                    Webcon_EmailServer:
                                    <asp:Label ID="Webcon_EmailServerLabel" runat="server" 
                                        Text='<%# Bind("Webcon_EmailServer") %>' />
                                    <br />
                                </ItemTemplate>
                            </asp:FormView>
                            <asp:SqlDataSource ID="SqlDataSource2" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" 
                
                
                                SelectCommand="SELECT Webcon_id, Webcon_Sitetitle, Webcon_Metatag, Webcon_Footer, Webcon_Siteurl, Webcon_Email, Webcon_Servername, Webcon_Enabled, Webcon_FrontBlock1_Title, Webcon_FrontBlock1_Content, Webcon_FrontBlock2_Title, Webcon_FrontBlock2_Content, Webcon_InsideBlock1_Title, Webcon_InsideBlock1_Content, Webcon_InsideBlock2_Title, Webcon_InsideBlock2_Content, Webcon_Counter, Webcon_EmailServer FROM TBL_WEBCONFIG WHERE (Webcon_id = @Webcon_id)" 
                                InsertCommand="INSERT INTO TBL_WEBCONFIG(Webcon_Sitetitle, Webcon_Metatag, Webcon_Footer, Webcon_Siteurl, Webcon_Email, Webcon_Servername, Webcon_EmailServer, Webcon_Enabled) VALUES (@Webcon_Sitetitle, @Webcon_Metatag, @Webcon_Footer, @Webcon_Siteurl, @Webcon_Email, @Webcon_Servername, @Webcon_EmailServer, @Webcon_Enabled)" 
                                UpdateCommand="UPDATE TBL_WEBCONFIG SET Webcon_Sitetitle = @Webcon_Sitetitle, Webcon_Metatag = @Webcon_Metatag, Webcon_Footer = @Webcon_Footer, Webcon_Siteurl = @Webcon_Siteurl, Webcon_Email = @Webcon_Email, Webcon_Servername = @Webcon_Servername, Webcon_EmailServer = @Webcon_EmailServer WHERE (Webcon_id = @Webcon_id)">
                                <InsertParameters>
                                    <asp:Parameter Name="Webcon_Sitetitle" />
                                    <asp:Parameter Name="Webcon_Metatag" />
                                    <asp:Parameter Name="Webcon_Footer" />
                                    <asp:Parameter Name="Webcon_Siteurl" />
                                    <asp:Parameter Name="Webcon_Email" />
                                    <asp:Parameter Name="Webcon_Servername" />
                                    <asp:Parameter Name="Webcon_EmailServer" />
                                    <asp:Parameter DefaultValue="N" Name="Webcon_Enabled" />
                                </InsertParameters>
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="GridView1" Name="Webcon_id" 
                                        PropertyName="SelectedValue" />
                                </SelectParameters>
                                <UpdateParameters>
                                    <asp:Parameter Name="Webcon_Sitetitle" />
                                    <asp:Parameter Name="Webcon_Metatag" />
                                    <asp:Parameter Name="Webcon_Footer" />
                                    <asp:Parameter Name="Webcon_Siteurl" />
                                    <asp:Parameter Name="Webcon_Email" />
                                    <asp:Parameter Name="Webcon_Servername" />
                                    <asp:Parameter Name="Webcon_EmailServer" />
                                    <asp:ControlParameter ControlID="GridView1" Name="Webcon_id" 
                                        PropertyName="SelectedValue" />
                                </UpdateParameters>
                            </asp:SqlDataSource>
                            <div>
                                <i><span class="style8">*</span> Mandatory Field</i>
                            </div>

                            <div class="card card-warning">
                                        <%--<div class="card-header">
                                            <h3 class="card-title">Insert Project Menu</h3>

                                            <div class="card-tools">
                                                <button type="button" class="btn btn-tool" data-card-widget="collapse"><i class="fas fa-minus"></i></button>
                                            </div>
                                        </div>--%>
                                        <!-- /.card-header -->
                                        <div class="card-body">
                                                
                                                <asp:GridView ID="GridView1" runat="server" AllowPaging="True" Width="100%"
                                                    AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="Webcon_id" 
                                                    DataSourceID="SqlDataSource1"
                                                    CssClass="table table-bordered" PagerStyle-CssClass="pgr" 
                                                    AlternatingRowStyle-CssClass="alt" PageSize="20">
                                                    <AlternatingRowStyle CssClass="alt" />
                                                    <Columns>
                                                        <asp:TemplateField>
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="btnUse" runat="server" CssClass="btn btn-warning btn-sm" 
                                                                    CommandArgument='<%#Eval("Webcon_Id")%>' CommandName="Use">Use</asp:LinkButton>
                                                                <asp:Image ID="imgUse" runat="server" 
                                                                    ImageUrl='<%# Eval("Webcon_EnabledUrl", "../administration/images/{0}") %>' />
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Enabled" Visible="False">
                                                            <ItemTemplate>
                                                                <asp:Image ID="Image1" runat="server" 
                                                                    ImageUrl='<%# Eval("Webcon_EnabledUrl", "../administration/images/{0}") %>' />
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="tdEnabled" />
                                                        </asp:TemplateField>
                                                        <asp:BoundField DataField="Webcon_Sitetitle" HeaderText="Site Title" 
                                                            SortExpression="Webcon_Sitetitle" />
                                                        <asp:BoundField DataField="Webcon_Footer" HeaderText="Footer" 
                                                            SortExpression="Webcon_Footer" Visible="False" />
                                                        <asp:BoundField DataField="Webcon_Siteurl" HeaderText="Site URL" 
                                                            SortExpression="Webcon_Siteurl" />
                                                        <asp:BoundField DataField="Webcon_Servername" HeaderText="Server Name" 
                                                            SortExpression="Webcon_Servername" />
                                                        <asp:BoundField DataField="Webcon_Metatag" HeaderText="Meta Tag" 
                                                            SortExpression="Webcon_Metatag" Visible="False" />
                                                        <asp:BoundField DataField="Webcon_Email" HeaderText="Email" 
                                                            SortExpression="Webcon_Email" />
                                                        <asp:BoundField DataField="Webcon_Enabled" HeaderText="Enabled" ReadOnly="True" 
                                                            SortExpression="Webcon_Enabled" Visible="False" />
                                                        <asp:CommandField ShowEditButton="True" Visible="False" />
                                                        <asp:CommandField ShowSelectButton="True" ControlStyle-CssClass="btn btn-warning btn-sm" />
                                                        <asp:TemplateField Visible="False">
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="btnEdit" runat="server" CssClass="btn btn-warning" CommandArgument='<%#Eval("Webcon_Id")%>' CommandName="EditBack">Edit</asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="">
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="btnDelete" runat="server" CssClass="btn btn-danger btn-sm" CommandName="Delete" OnClientClick="return confirm('Are you sure to delete it?');">Delete</asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                    </Columns>
                                                    <PagerStyle CssClass="pgr" />
                                                </asp:GridView>

                                        </div>

                            </div>
                            <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" 
                                DeleteCommand="DELETE FROM TBL_WEBCONFIG WHERE Webcon_Id = @Webcon_Id" SelectCommand="SELECT Webcon_Sitetitle, Webcon_Metatag, Webcon_Footer, Webcon_Siteurl, Webcon_Servername, Webcon_Email, Webcon_Enabled, Webcon_id, (CASE WHEN [Webcon_Enabled] = 'Y' THEN 'enabled.png' ELSE 'disabled.png' END) AS Webcon_EnabledUrl FROM TBL_WEBCONFIG ORDER BY Webcon_id" 
                
                                UpdateCommand="UPDATE TBL_WEBCONFIG SET Webcon_Sitetitle = @Webcon_Sitetitle, Webcon_Metatag = @Webcon_Metatag, Webcon_Footer = @Webcon_Footer, Webcon_Siteurl = @Webcon_Siteurl, Webcon_Email = @Webcon_Email, Webcon_Servername = @Webcon_Servername WHERE Webcon_Id = @Webcon_Id">
                                <DeleteParameters>
                                    <asp:Parameter Name="Webcon_Id" />
                                </DeleteParameters>
                                <UpdateParameters>
                                    <asp:Parameter Name="Webcon_Sitetitle" />
                                    <asp:Parameter Name="Webcon_Metatag" />
                                    <asp:Parameter Name="Webcon_Footer" />
                                    <asp:Parameter Name="Webcon_Siteurl" />
                                    <asp:Parameter Name="Webcon_Email" />
                                    <asp:Parameter Name="Webcon_Servername" />
                                    <asp:Parameter Name="Webcon_Id" />
                                </UpdateParameters>
                            </asp:SqlDataSource>
                            <br />
                        </ContentTemplate>
                    </asp:UpdatePanel>
    

        </div>
    </section>
    
</asp:Content>
