<%@ Page Language="VB" AutoEventWireup="false" CodeFile="userprofile.aspx.vb" Inherits="html_administration_user" MasterPageFile="~/MasterMenu.master" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadContent" runat="Server">

    <style>
        .cssDisplayNone{
            width : 1px;
            height : 1px;
            border : none !important;
            z-index : -99999;
            background-color : #fff !important;
        }

    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">

    <section class="content-header">
        <div class="container-fluid">  

            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0 text-dark">Info Pengguna</h1>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <%--<li class="breadcrumb-item"><a href="#">Administration</a></li>--%>
                        <li class="breadcrumb-item active">Info Pengguna</li>
                    </ol>
                </div>
                <!-- /.col -->
            </div>
            <!-- /.row -->
        </div>
    </section>
    <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" DeleteCommand="DELETE FROM TBL_USERS WHERE Users_Id = @Users_Id" 
        InsertCommand="INSERT INTO TBL_USERS(Users_Name, Users_Fullname,Users_Password, Users_Email, Users_Enabled, Users_Register) VALUES (@Users_Name, @Users_Fullname, @Users_Password, @Users_Email, @Users_Enabled, @Users_Register)" 
        SelectCommand="SELECT a.*,b.JabatanAgensi_Description FROM [TBL_USERS] a
        left join LESEN_JabatanAgensi b on b.JabatanAgensi_ID = a.estate_id
        WHERE Users_Id = @Users_Id" 
        UpdateCommand="UPDATE TBL_USERS SET Users_Password = (CASE WHEN @Users_Password &lt;&gt; '' THEN @Users_Password ELSE (SELECT Users_Password FROM TBL_USERS WHERE (Users_Id = @Users_Id))END) WHERE (Users_Id = @Users_Id)">
        <DeleteParameters>
            <asp:ControlParameter ControlID="GridView1" Name="Users_Id" PropertyName="SelectedValue" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="Users_Name" />
            <asp:Parameter Name="Users_Fullname" />
            <asp:Parameter Name="Users_Password" />
            <asp:Parameter Name="Users_Email" />
            <asp:Parameter Name="Users_Enabled" />
            <asp:Parameter Name="Users_Register" />
        </InsertParameters>
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="Users_Id" SessionField="sessionUsersId" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter ConvertEmptyStringToNull="False" Name="Users_Password" />
            <asp:SessionParameter DefaultValue="0" Name="Users_Id" SessionField="sessionUsersId" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <section class="content">
        <div class="container-fluid">

                    <asp:FormView ID="FormView1" runat="server" DataKeyNames="Users_Id" DataSourceID="SqlDataSource2" DefaultMode="Edit" EnableModelValidation="True" Width="100%">
                        <EditItemTemplate>
                            <asp:TextBox ID="TextBox4" placeholder="Password" runat="server" TextMode="Password" ValidationGroup="frmEdit" CssClass="cssDisplayNone" autocomplete="off" />
                            <div class="card card-warning">
                                <div class="card-header">
                                    <h3 class="card-title">Kemaskini Info</h3>

                                    <div class="card-tools">
                                        <button type="button" class="btn btn-tool" data-card-widget="collapse"><i class="fas fa-minus"></i></button>
                                    </div>
                                </div>
                                <!-- /.card-header -->
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>ID Pengguna</label>
                                                <asp:TextBox ID="TextBox2" runat="server" Text='<%# Eval("Users_Name") %>' CssClass="form-control" ReadOnly="true"></asp:TextBox>
                                            </div>
                                            
                                            <div class="form-group">
                                                <label>Nama</label>
                                                <asp:TextBox ID="TextBox1" runat="server" Text='<%# Eval("Users_Fullname") %>' CssClass="form-control" ReadOnly="true"></asp:TextBox>
                                            </div>

                                            <div class="form-group">
                                                <label>Jawatan</label>
                                                <asp:TextBox ID="TextBox5" runat="server" Text='<%# Eval("Users_Jawatan") %>' CssClass="form-control" ReadOnly="true"></asp:TextBox>
                                            </div>

                                            <div class="form-group">
                                                <label>No. Pekerja</label>
                                                <asp:TextBox ID="TextBox6" runat="server" Text='<%# Eval("Users_EmpNo") %>' CssClass="form-control" ReadOnly="true"></asp:TextBox>
                                            </div>

                                            <div class="form-group">
                                                <label>Email</label>
                                                <asp:TextBox ID="TextBox3" runat="server" polaceholder="Email" Text='<%# Eval("Users_Email") %>' CssClass="form-control" ReadOnly="true"></asp:TextBox>
                                            </div>

                                            <div class="form-group">
                                                <label>Gambar</label>
                                                <asp:FileUpload ID="ufPicture" runat="server" CssClass="form-control"></asp:FileUpload>
                                            </div>

                                            </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Katalaluan</label>
                                                
                                                <asp:TextBox ID="Users_PasswordTextBox" placeholder="Password" runat="server" TextMode="Password" ValidationGroup="frmEdit" CssClass="form-control" autocomplete="off" />
                                                <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="Users_PasswordTextBox" CssClass="text-danger" ErrorMessage="This Field is required!" ValidationGroup="frmEdit"></asp:RequiredFieldValidator>--%>
                                                <asp:RegularExpressionValidator ID="RegularExpressionValidator2" Display="Dynamic" runat="server" ValidationGroup="frmEdit" CssClass="text-danger"
                                                    ControlToValidate="Users_PasswordTextBox" ErrorMessage="Invalid password! (Minumun 8 character and must contain lower case, upper case and special characters)"
                                                    ToolTip="Minimum 8 character and must contain lower case, upper case and special characters" ValidationExpression="^.*(?=.{8,})(?=.*[a-z])(?=.*[A-Z])(?=.*[\W]).*$">
                                                </asp:RegularExpressionValidator>
                                            </div>
                                            <div class="form-group">
                                                <label>Pengesahan Katalaluan</label>
                                                <asp:TextBox ID="txtRepassword" runat="server" placeholder="Re-type Password" TextMode="Password" ValidationGroup="frmEdit" CssClass="form-control"></asp:TextBox>
                                                <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator6" Display="Dynamic" runat="server" ControlToValidate="txtRepassword" CssClass="text-danger" ErrorMessage="This Field is required!" ValidationGroup="frmEdit"></asp:RequiredFieldValidator>--%>
                                                <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToCompare="txtRepassword" CssClass="text-danger" ControlToValidate="Users_PasswordTextBox" ErrorMessage="Password Not Match" ValidationGroup="frmEdit" Display="Dynamic"></asp:CompareValidator>
                                            </div>

                                            <div class="form-group">
                                                <label>Gred</label>
                                                <asp:TextBox ID="TextBox7" runat="server" Text='<%# Eval("Users_Gred") %>' CssClass="form-control" ReadOnly="true"></asp:TextBox>
                                            </div>

                                            <div class="form-group">
                                                <label>No. Telefon</label>
                                                <asp:TextBox ID="TextBox8" runat="server" Text='<%# Eval("Users_TelNo") %>' CssClass="form-control" ReadOnly="true"></asp:TextBox>
                                            </div>

                                            <div class="form-group">
                                                <label>Jabatan/Bahagian/Unit/Agensi</label>
                                                <asp:TextBox ID="TextBox9" runat="server" Text='<%# Eval("JabatanAgensi_Description") %>' CssClass="form-control" ReadOnly="true"></asp:TextBox>
                                            </div>


                                        </div>
                                        <!-- /.col -->
                                    </div>
                                    <!-- /.row -->
                                </div>
                                <!-- /.card-body -->
                                <div class="card-footer">
                                        <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" CommandName="Update" Text="Kemaskini" ValidationGroup="frmEdit" CssClass="btn btn-warning" />
                                        <asp:LinkButton ID="UpdateCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" CssClass="btn btn-default" Visible="false" />
                                        <asp:LinkButton Visible="false" ID="ResendPasswordButton" runat="server" OnClick="ResendPasswordButton_Click" OnClientClick="return confirm('Are you sure to resend password?');" Text="Resend Password" ValidationGroup="frmResend" CssClass="btn btn-default" />
                                        
                                        <asp:Label ID="lblMessage" runat="server" ForeColor="Green"></asp:Label>
                                    </div>
                                
                                </div>
<%--                            <div class="alert alert-success alert-dismissible">
                                  <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                                  <h6><i class="icon fas fa-check"></i> Password Updated Successfully.</h6>
                            </div>--%>
                        </EditItemTemplate>
                    </asp:FormView>


                    <asp:Label ID="lblMessageUpdate" runat="server" ForeColor="Red"></asp:Label>

        </div>
    </section>
    <script>

        //window.onload = function () {
        //    // run code
        //    document.getElementById('MainContent_FormView1_Users_PasswordTextBox').value = "1";
        //};
     

            
    </script>
</asp:Content>
