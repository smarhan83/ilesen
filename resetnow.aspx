<%@ Page Title="" Language="VB" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="resetnow.aspx.vb" Inherits="resetnow" EnableEventValidation="False" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">

    <style>
        .center {
            margin: auto;
            /*border: 3px solid #73AD21;*/
            padding: 10px;
            margin-top: 32px;
            margin-bottom: 32px;
        }
		
        #upMain {
            display:none !important;
        }		

    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

<div class="bg-light min-vh-98 d-flex flex-row align-items-center dark:bg-transparent">
      <div class="container">
        <div class="row justify-content-center">
          <div class="col-lg-8">
            <div class="card-group d-block d-md-flex row">

              <div class="card col-md-5 text-white bg-primary py-5">
                <div class="card-body text-center" runat="server" id="divLogoBig" >
                  <div>
                    <h2>&nbsp;</h2>
                      <asp:Image ID="Image1" runat="server" ImageUrl="~/images/logo.png" />
                    <p></p>
                    
                  </div>
                </div>

                          <br />
            <div align="center">
                <asp:Label ID="lblStatus" runat="server"
                    Style="font-weight: 700; color: #fff"></asp:Label>

<%--<div class="center" style="text-align:center"><asp:Label ID="lblStatus" runat="server" Text="" ></asp:Label></div>--%>
   
            </div>

              </div>

                <input type="text" id="username" style="color:transparent !important;border-color:transparent;font-size:0.1pt;position:absolute;" />
                <input type="password" id="password" style="color:transparent !important;border-color:transparent;font-size:0.1pt;position:absolute;" />

              <div class="card col-md-7 p-4 mb-0" runat="server" id="myReset">
                <div class="card-body">
                  <h1>Reset Katalaluan</h1>
                  <p class="text-medium-emphasis">Sila Masukkan Katalaluan Baru</p>
                  <div class="input-group mb-3"><span class="input-group-text">
                    <svg class="icon">
                    <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-user"></use>
                    </svg></span>
                    <asp:TextBox autocomplete="new-password" CssClass="form-control" AutoCompleteType="Disabled" Text='' class="form-control form-control-user" placeholder="Katalaluan baru *" runat="server" ID="Users_Password" TextMode="Password" /><br />
                  </div>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="Users_Password" CssClass="text-danger" runat="server" ErrorMessage="Sila isi!" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator3" Display="Dynamic" runat="server" ValidationGroup="insertForm" CssClass="text-danger"
                        ControlToValidate="Users_Password" ErrorMessage="Katalaluan tidak sah! (8 huruf + huruf kecil + huruf besar + simbol)"
                        ToolTip="8 huruf + huruf kecil + huruf besar + simbol" ValidationExpression="^.*(?=.{8,})(?=.*[a-z])(?=.*[A-Z])(?=.*[\W]).*$">
                    </asp:RegularExpressionValidator>
                    <br />
                  <div class="input-group mb-4">
                      <span class="input-group-text">

                    <svg class="icon">
                    <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-lock-locked"></use>
                    </svg></span>
                        <asp:TextBox CssClass="form-control" AutoCompleteType="Disabled" Text='' class="form-control form-control-user" placeholder="Taip semula katalaluan baru *" runat="server" ID="Users_Password2" TextMode="Password" /><br />
                  </div>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" ControlToValidate="Users_Password2" CssClass="text-danger" runat="server" ErrorMessage="Sila isi!" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator4" Display="Dynamic" runat="server" ValidationGroup="insertForm" CssClass="text-danger"
                        ControlToValidate="Users_Password2" ErrorMessage="Katalaluan tidak sah! (8 huruf + huruf kecil + huruf besar + simbol)"
                        ToolTip="8 huruf + huruf kecil + huruf besar + simbol" ValidationExpression="^.*(?=.{8,})(?=.*[a-z])(?=.*[A-Z])(?=.*[\W]).*$">
                        </asp:RegularExpressionValidator>
                        <asp:CompareValidator ID="CompareValidator2" runat="server"  CssClass="text-danger" ValidationGroup="insertForm"
                        ControlToCompare="Users_Password" ControlToValidate="Users_Password2" Display="Dynamic" 
                        ErrorMessage="Katalaluan tidak sama"></asp:CompareValidator>
                  <div class="row">
                    <div class="col-6">
                        <br />
                        <%--<asp:Button ID="btnLogin" runat="server" Text="Log Masuk" CssClass="btn btn-primary px-4" />--%>
                        <asp:LinkButton runat="server" Text="Reset Katalaluan"  CssClass="btn btn-primary px-4" ValidationGroup="insertForm" ID="InsertButton" CausesValidation="True" OnClick="InsertButton_Click"  OnClientClick="return confirm('Anda pasti untuk reset katalaluan?');"/>
                         <asp:HiddenField ID="hfUID" runat="server" />
                    </div>


                    <div class="col-6 text-end">
                      
                        
                    </div>
                  </div>
                    <!-- reset password -->

                
                

                

                    <!-- end reset password -->
                </div>
              </div>

                

            </div>
          </div>
        </div>
      </div>
    </div>


    <br />

</asp:Content>

