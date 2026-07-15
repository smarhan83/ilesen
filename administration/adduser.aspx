<%@ Page Language="VB" AutoEventWireup="false" CodeFile="adduser.aspx.vb" Inherits="html_administration_user" MasterPageFile="~/MasterMenu.master" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="asp" %>

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
    <asp:TextBox ID="TextBox4" placeholder="Password" runat="server" TextMode="Password" ValidationGroup="frmEdit" CssClass="cssDisplayNone" autocomplete="off" />
    <section class="content-header">
        <div class="container-fluid">

            
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0 text-dark">Pengguna Sistem</h1>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <%--<li class="breadcrumb-item"><a href="#">Administration</a></li>
                        <li class="breadcrumb-item active">User</li>--%>
                        <%= GlobalClass.writeBreadcrumb(Request.QueryString("p_Id"), Request.QueryString("m_Id"), Session.Item("sessionSystemId")) %>
                    </ol>
                </div>
                <!-- /.col -->
            </div>
            <!-- /.row -->
        </div>
    </section>

    <asp:SqlDataSource runat="server" ID="SqlDataSourceOCS" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' 
        SelectCommand="SELECT 0 AS id, '' AS name
union all
select JabatanAgensi_ID AS ID, JabatanAgensi_Description as name
from LESEN_JabatanAgensi
where JabatanAgensi_IsActive=1
order by name "></asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource1" runat="server"
        ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
        DeleteCommand="DELETE FROM TBL_USERS WHERE (Users_Id = @Users_Id)"
        InsertCommand="INSERT INTO TBL_USERS(Users_Name, Users_Fullname, Users_Password, Users_Email, Users_Enabled, Users_Register) VALUES (@Users_Name, @Users_Fullname, @Users_Password, @Users_Email, @Users_Enabled, @Users_Register)"
        SelectCommand="">
        <DeleteParameters>
            <asp:ControlParameter ControlID="GridView1" Name="Users_Id"
                PropertyName="SelectedValue" />
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
            <asp:ControlParameter ControlID="txtUsersName" DefaultValue="%%"
                Name="Users_Name" PropertyName="Text" />
            <asp:ControlParameter ControlID="txtFullname" DefaultValue="%%"
                Name="Users_Fullname" PropertyName="Text" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSource2" runat="server"
        ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
        DeleteCommand="DELETE FROM TBL_USERS WHERE Users_Id = @Users_Id"
        InsertCommand="INSERT INTO TBL_USERS(Users_Jawatan,Users_Gred,Users_EmpNo,Users_TelNo,Users_Name, Users_Fullname,Users_Password, Users_Email, Users_Enabled, Users_Register, estate_id,Users_IsLawatanTapakUlasan,Users_IsPenilaian,Users_IsPeraku,Users_Signature,Users_IsReadOnly) 
        VALUES (@Users_Jawatan,@Users_Gred,@Users_EmpNo,@Users_TelNo,@Users_Name, @Users_Fullname, @Users_Password, @Users_Email, @Users_Enabled, @Users_Register, @estate_id,@Users_IsLawatanTapakUlasan,@Users_IsPenilaian,@Users_IsPeraku,@Users_Signature,@Users_IsReadOnly)"
        SelectCommand="SELECT * FROM [TBL_USERS] WHERE Users_Id = @Users_Id"
        UpdateCommand="UPDATE TBL_USERS SET Users_Name = @Users_Name, Users_Fullname = @Users_Fullname, estate_id = @estate_id,
Users_Password = 
(
CASE
  WHEN @Users_Password &lt;&gt; '' THEN 
  @Users_Password 
  ELSE
  (SELECT Users_Password FROM TBL_USERS WHERE (Users_Id = @Users_Id))
END
), 
Users_Email = @Users_Email, Users_Enabled = @Users_Enabled, Users_Register = @Users_Register,
Users_IsLawatanTapakUlasan = @Users_IsLawatanTapakUlasan,Users_IsPenilaian = @Users_IsPenilaian,Users_IsPeraku = @Users_IsPeraku,
Users_Signature=@Users_Signature,Users_IsReadOnly=@Users_IsReadOnly,
Users_Jawatan=@Users_Jawatan,Users_Gred=@Users_Gred,Users_EmpNo=@Users_EmpNo,Users_TelNo=@Users_TelNo
WHERE (Users_Id = @Users_Id)">
        <DeleteParameters>
            <asp:ControlParameter ControlID="GridView1" Name="Users_Id"
                PropertyName="SelectedValue" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="Users_Name" />
            <asp:Parameter Name="Users_Fullname" />
            <asp:Parameter Name="Users_Password" />
            <asp:Parameter Name="Users_Email" />
            <asp:Parameter Name="Users_Enabled" />
            <asp:Parameter Name="Users_Register" />
            <asp:Parameter Name="estate_id" />
            <asp:Parameter Name="Users_IsLawatanTapakUlasan" />
            <asp:Parameter Name="Users_IsPenilaian" />
            <asp:Parameter Name="Users_IsPeraku" />
            <asp:Parameter Name="Users_Signature" />
            <asp:Parameter Name="Users_IsReadOnly" />
            <asp:Parameter Name="Users_Jawatan" />
            <asp:Parameter Name="Users_Gred" />
            <asp:Parameter Name="Users_EmpNo" />
            <asp:Parameter Name="Users_TelNo" />
        </InsertParameters>
        <SelectParameters>
            <asp:ControlParameter ControlID="GridView1" DefaultValue="" Name="Users_Id"
                PropertyName="SelectedValue" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter DefaultValue="" Name="Users_Name" />
            <asp:Parameter Name="Users_Fullname" />
            <asp:Parameter Name="Users_Password" ConvertEmptyStringToNull="False" />
            <asp:Parameter Name="Users_Email" />
            <asp:Parameter Name="Users_Enabled" />
            <asp:Parameter Name="Users_Register" />
            <asp:Parameter Name="estate_id" />
            <asp:Parameter Name="Users_IsLawatanTapakUlasan" />
            <asp:Parameter Name="Users_IsPenilaian" />
            <asp:Parameter Name="Users_IsPeraku" />
            <asp:Parameter Name="Users_Signature" />
            <asp:Parameter Name="Users_IsReadOnly" />
            <asp:Parameter Name="Users_Jawatan" />
            <asp:Parameter Name="Users_Gred" />
            <asp:Parameter Name="Users_EmpNo" />
            <asp:Parameter Name="Users_TelNo" />
            <asp:ControlParameter ControlID="GridView1" DefaultValue="" Name="Users_Id"
                PropertyName="SelectedValue" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <!-- Main content -->
    <section class="content">
        <div class="container-fluid">

            <asp:FormView ID="FormView1" runat="server" DataKeyNames="Users_Id"
                DataSourceID="SqlDataSource2" DefaultMode="Insert" EnableModelValidation="True"
                Width="100%">
                <EditItemTemplate>
                    <div class="card card-warning">
                        <div class="card-header">
                            <h3 class="card-title">Kemaskini Pengguna</h3>

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
                                        <asp:TextBox ID="Users_NameTextBox" runat="server"
                                            Text='<%# Bind("Users_Name") %>' ValidationGroup="frmEdit" CssClass="form-control" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" CssClass="text-danger"
                                            ControlToValidate="Users_NameTextBox" ErrorMessage="Sila Isi"
                                            ValidationGroup="frmEdit"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="form-group">
                                        <label>Nama Penuh</label>
                                        <asp:TextBox ID="Users_FullnameTextBox" runat="server"
                                            Text='<%# Bind("Users_Fullname") %>' CssClass="form-control" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
                                            ControlToValidate="Users_FullnameTextBox" ErrorMessage="Sila Isi" CssClass="text-danger"
                                            ValidationGroup="frmEdit"></asp:RequiredFieldValidator>
                                    </div>

                                    <div class="form-group">
                                        <label>Katalaluan</label>
                                        <asp:TextBox ID="Users_PasswordTextBox" runat="server"
                                            Text='<%# Bind("Users_Password") %>' TextMode="Password" CssClass="form-control" />
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator2" Display="Dynamic" runat="server" ValidationGroup="frmEdit" CssClass="text-danger"
                                            ControlToValidate="Users_PasswordTextBox" ErrorMessage="Katalaluan tidak sah! (8 huruf + huruf kecil + huruf besar + simbol)"
                                            ToolTip="8 huruf + huruf kecil + huruf besar + simbol" ValidationExpression="^.*(?=.{8,})(?=.*[a-z])(?=.*[A-Z])(?=.*[\W]).*$">
                                        </asp:RegularExpressionValidator>
                                    </div>


                                    <div class="form-group">
                                        <label>Jawatan</label>
                                        <asp:TextBox ID="Users_JawatanTextBox" runat="server" placeholder="Jawatan" Text='<%# Bind("Users_Jawatan") %>' ValidationGroup="frmInsert" CssClass="form-control" />
                                        
                                    </div>

                                    <div class="form-group">
                                        <label>No. Pekerja</label>
                                        <asp:TextBox ID="TextBox6" runat="server" placeholder="No. Pekerja" Text='<%# Bind("Users_EmpNo") %>' ValidationGroup="frmInsert" CssClass="form-control" />
                                        
                                    </div>

                                    <div class="form-check">
                                        <asp:CheckBox ID="CheckBox1" runat="server" CssClass="form-check-input" Checked='<%# Bind("Users_Enabled") %>' />
                                        <label>Aktif</label>
                                    </div>

                                    <br />
                                    <div class="form-check">
                                        <asp:CheckBox ID="CheckBox4" runat="server" CssClass="form-check-input" Checked='<%# Bind("Users_IsLawatanTapakUlasan") %>' />
                                        <label>Penyedia Ulasan?</label>
                                    </div>
                                    <div class="form-check">
                                        &nbsp;&nbsp;&nbsp;<asp:CheckBox ID="CheckBox9" runat="server" CssClass="form-check-input" Checked='<%# Bind("Users_IsReadOnly") %>' />
                                        <label>Lihat Sahaja</label>
                                    </div>
                                    <br />

                                    <div class="form-check">
                                        <asp:CheckBox ID="CheckBox3" runat="server" CssClass="form-check-input" Checked='<%# Bind("Users_IsPenilaian") %>' />
                                        <label>Pengesah?</label>
                                    </div>
                                    <div class="form-check">
                                        <asp:CheckBox ID="CheckBox7" runat="server" CssClass="form-check-input" Checked='<%# Bind("Users_IsPeraku") %>' />
                                        <label>Peraku?</label>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Email</label>
                                        <asp:TextBox ID="TextBox3_Email" runat="server" Text='<%# Bind("Users_Email") %>'
                                            CssClass="form-control" ValidationGroup="frmEdit"></asp:TextBox>
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server"
                                            ControlToValidate="TextBox3_Email" ErrorMessage="Invalid Email Address"
                                            ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                                            ValidationGroup="frmEdit"></asp:RegularExpressionValidator>
                                    </div>
                                    <div class="form-group">
                                        <label>Jabatan/Bahagian/Unit/Agensi</label>
                                        <asp:DropDownList Text='<%# Bind("estate_id") %>' ID="DropDownListOCS" runat="server" DataSourceID="SqlDataSourceOCS" DataTextField="name" DataValueField="id" CssClass="form-control select2"></asp:DropDownList>
                                    </div>
                                    <br />

                                    <div class="form-group">
                                        <label>Pengesahan Katalaluan</label>
                                        <asp:TextBox ID="txtRepassword" runat="server" TextMode="Password"
                                            CssClass="form-control"></asp:TextBox>
                                        <asp:CompareValidator ID="ComparePass" Display="Dynamic" runat="server" ErrorMessage="Katalaluan tidak sama"
                                            ControlToCompare="Users_PasswordTextBox" ControlToValidate="txtRepassword" ValidationGroup="frmInsert" CssClass="text-danger">
                                        </asp:CompareValidator>
                                    </div>

                                    <div class="form-group">
                                        <label>Gred</label>
                                        <asp:TextBox ID="TextBox3" runat="server" placeholder="Gred" Text='<%# Bind("Users_Gred") %>' ValidationGroup="frmInsert" CssClass="form-control" />
                                        
                                    </div>

                                    <div class="form-group">
                                        <label>No. Telefon</label>
                                        <asp:TextBox ID="TextBox7" runat="server" placeholder="No. Telefon" Text='<%# Bind("Users_TelNo") %>' ValidationGroup="frmInsert" CssClass="form-control" />
                                        
                                    </div>


                                    <div class="form-check">
                                        <asp:CheckBox ID="CheckBox2" runat="server" CssClass="form-check-input" Checked='<%# Bind("Users_Register") %>' />
                                        <label>Daftar</label>
                                    </div>

                                    <div class="form-group">
                                        <label>Tandatangan</label>
                                        <asp:TextBox ID="txtUsers_Signature" runat="server"
                                            Text='<%# Bind("Users_Signature") %>' CssClass="form-control" TextMode="MultiLine" Rows="10"/>  
<%--                                        <asp:HtmlEditorExtender ID="HtmlEditorExtender4" runat="server" TargetControlID="txtUsers_Signature" DisplaySourceTab="True"></asp:HtmlEditorExtender>--%>
                                    </div>

                                </div>
                            </div>
                        </div>
                        <div class="card-footer">
                            <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" CommandName="Update" Text="Simpan" ValidationGroup="frmEdit" CssClass="btn btn-warning" />
                            <asp:LinkButton ID="UpdateCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Reset" CssClass="btn btn-default" />
                            <%--<asp:LinkButton ID="ResendPasswordButton" runat="server" OnClick="ResendPasswordButton_Click" OnClientClick="return confirm('Are you sure to resend password?');" Text="Resend Password" ValidationGroup="frmResend" CssClass="btn btn-default" />--%>
                            <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToCompare="txtRepassword" ControlToValidate="Users_PasswordTextBox" ErrorMessage="Katalaluan tidak sama"></asp:CompareValidator>
                            <asp:Label ID="lblMessage" runat="server" ForeColor="Red"></asp:Label>
                        </div>
                    </div>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <!-- Map card -->
                    <div class="card card-primary">
                        <div class="card-header">
                            <h3 class="card-title">Daftar Pengguna Baru</h3>

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
                                        <asp:TextBox ID="Users_NameTextBox" runat="server" placeholder="ID Pengguna" Text='<%# Bind("Users_Name") %>' ValidationGroup="frmInsert" CssClass="form-control" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" Display="Dynamic" runat="server" ControlToValidate="Users_NameTextBox" ErrorMessage="Sila Isi" ValidationGroup="frmInsert" CssClass="text-danger"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="form-group">
                                        <label>Nama Penuh</label>
                                        <asp:TextBox ID="Users_FullnameTextBox" runat="server" placeholder="Nama Penuh" Text='<%# Bind("Users_Fullname") %>' ValidationGroup="frmInsert" CssClass="form-control" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" Display="Dynamic" runat="server" ControlToValidate="Users_FullnameTextBox" ErrorMessage="Sila Isi" ValidationGroup="frmInsert" CssClass="text-danger"></asp:RequiredFieldValidator>
                                    </div>

                                    <div class="form-group">
                                        <label>Katalaluan</label>
                                        <asp:TextBox ID="Users_PasswordTextBox" runat="server" placeholder="Katalaluan" Text='<%# Bind("Users_Password") %>' TextMode="Password" CssClass="form-control" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" Display="Dynamic" runat="server" ControlToValidate="Users_PasswordTextBox" ErrorMessage="Sila Isi" ValidationGroup="frmInsert" CssClass="text-danger"></asp:RequiredFieldValidator>
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator2" Display="Dynamic" runat="server" ValidationGroup="frmInsert" CssClass="text-danger"
                                            ControlToValidate="Users_PasswordTextBox" ErrorMessage="Katalaluan tidak sah! (8 huruf + huruf kecil + huruf besar + simbol)"
                                            ToolTip="8 huruf + huruf kecil + huruf besar + simbol" ValidationExpression="^.*(?=.{8,})(?=.*[a-z])(?=.*[A-Z])(?=.*[\W]).*$">
                                        </asp:RegularExpressionValidator>
                                    </div>

                                    <div class="form-group">
                                        <label>Jawatan</label>
                                        <asp:TextBox ID="Users_JawatanTextBox" runat="server" placeholder="Jawatan" Text='<%# Bind("Users_Jawatan") %>' ValidationGroup="frmInsert" CssClass="form-control" />
                                        
                                    </div>

                                    <div class="form-group">
                                        <label>No. Pekerja</label>
                                        <asp:TextBox ID="TextBox6" runat="server" placeholder="No. Pekerja" Text='<%# Bind("Users_EmpNo") %>' ValidationGroup="frmInsert" CssClass="form-control" />
                                        
                                    </div>

                                    <div class="form-check">
                                        <asp:CheckBox ID="CheckBox1" runat="server" CssClass="form-check-input" Checked='<%# Bind("Users_Enabled") %>' />
                                        <label>Aktif</label>
                                    </div>


                                    <br />
                                    
                                    <div class="form-check">
                                        <asp:CheckBox ID="CheckBox4" runat="server" CssClass="form-check-input" Checked='<%# Bind("Users_IsLawatanTapakUlasan") %>' />
                                        <label>Penyedia Ulasan?</label>
                                    </div>
                                    <div class="form-check">
                                        &nbsp;&nbsp;&nbsp;<asp:CheckBox ID="CheckBox9" runat="server" CssClass="form-check-input" Checked='<%# Bind("Users_IsReadOnly") %>' />
                                        <label>Lihat Sahaja</label>
                                    </div>
                                    <br />
                                    <div class="form-check">
                                        <asp:CheckBox ID="CheckBox3" runat="server" CssClass="form-check-input" Checked='<%# Bind("Users_IsPenilaian") %>' />
                                        <label>Pengesah?</label>
                                    </div>
                                    <div class="form-check">
                                        <asp:CheckBox ID="CheckBox7" runat="server" CssClass="form-check-input" Checked='<%# Bind("Users_IsPeraku") %>' />
                                        <label>Peraku?</label>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Email</label>
                                        <asp:TextBox ID="TextBox3_Email" runat="server" placeholder="Email" Text='<%# Bind("Users_Email") %>' ValidationGroup="frmInsert" CssClass="form-control"></asp:TextBox>
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" Display="Dynamic" runat="server" ControlToValidate="TextBox3_Email" ErrorMessage="Alamat email tidak sah" CssClass="text-danger" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ValidationGroup="frmInsert"></asp:RegularExpressionValidator>
                                    </div>

                                    <div class="form-group">
                                        <label>Jabatan/Bahagian/Unit/Agensi</label>
                                        <asp:DropDownList ID="DropDownListOCS" Text='<%# Bind("estate_id") %>' runat="server" DataSourceID="SqlDataSourceOCS" DataTextField="name" DataValueField="id" CssClass="form-control select2"></asp:DropDownList>
                                    </div>
                                    <div class="form-group">
                                        <label>Pengesahan Katalaluan</label>
                                        <asp:TextBox ID="txtRepassword" runat="server" placeholder="Pengesahan Katalaluan" TextMode="Password" CssClass="form-control"></asp:TextBox>                                        
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator6" Display="Dynamic" runat="server" ControlToValidate="txtRepassword" ErrorMessage="Sila Isi" ValidationGroup="frmInsert" CssClass="text-danger"></asp:RequiredFieldValidator>
                                        <asp:CompareValidator ID="ComparePass" Display="Dynamic" runat="server" ErrorMessage="Katalaluan tidak sama"
                                            ControlToCompare="Users_PasswordTextBox" ControlToValidate="txtRepassword" ValidationGroup="frmInsert" CssClass="text-danger">
                                        </asp:CompareValidator>
                                    </div>

                                    <div class="form-group">
                                        <label>Gred</label>
                                        <asp:TextBox ID="TextBox3" runat="server" placeholder="Gred" Text='<%# Bind("Users_Gred") %>' ValidationGroup="frmInsert" CssClass="form-control" />
                                        
                                    </div>

                                    <div class="form-group">
                                        <label>No. Telefon</label>
                                        <asp:TextBox ID="TextBox7" runat="server" placeholder="No. Telefon" Text='<%# Bind("Users_TelNo") %>' ValidationGroup="frmInsert" CssClass="form-control" />
                                        
                                    </div>

                                    <div class="form-check">
                                        <asp:CheckBox ID="CheckBox2" runat="server" CssClass="form-check-input" Checked='<%# Bind("Users_Register") %>' />
                                        <label>Daftar</label>
                                    </div>

                                    <div class="form-group">
                                        <label>Tandatangan</label>
                                        <asp:TextBox ID="txtUsers_Signature" runat="server"
                                            Text='<%# Bind("Users_Signature") %>' CssClass="form-control" TextMode="MultiLine" Rows="10"/>  
                                        <%--<asp:HtmlEditorExtender ID="HtmlEditorExtender4" runat="server" TargetControlID="txtUsers_Signature" DisplaySourceTab="True"></asp:HtmlEditorExtender>--%>
                                    </div>

                                    <%--                                    <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True"
                                        CommandName="Insert" Text="Insert" ValidationGroup="frmInsert" CssClass="btn btn-primary" />
                                    &nbsp;
                                                <asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False"
                                                    CommandName="Cancel" Text="Cancel" CssClass="btn btn-default" />
                                    <asp:CompareValidator ID="CompareValidator1" runat="server"
                                        ControlToCompare="txtRepassword" ControlToValidate="Users_PasswordTextBox"
                                        ErrorMessage="Password Not Match"></asp:CompareValidator>--%>
                                </div>
                            </div>
                        </div>
                        <!-- /.card-body -->
                        <div class="card-footer">
                            <asp:LinkButton runat="server" Text="Simpan" CommandName="Insert" ValidationGroup="frmInsert" ID="LinkButton3" CausesValidation="True" CssClass-="btn btn-primary" />&nbsp;<asp:LinkButton runat="server" Text="Reset" CommandName="Cancel" ID="LinkButton4" CausesValidation="False" CssClass-="btn btn-default" />
                        </div>
                    </div>
                </InsertItemTemplate>
                <ItemTemplate>
                </ItemTemplate>
            </asp:FormView>




            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">
                            <div class="row">
                            <div class="col-4">
                                <div class="form-group">
                            <%--Username : --%>
                             <asp:TextBox ID="txtUsersName" runat="server" CssClass="form-control" placeholder="ID Pengguna" ></asp:TextBox>
                                    </div>

                                </div>
                                <div class="col-4">
                                <div class="form-group">
                            <%--Full Name:--%>
                            <asp:TextBox ID="txtFullname" runat="server" CssClass="form-control" placeholder="Nama Penuh" ></asp:TextBox>
                            
                                    </div>
                                </div>

                                <div class="col-4">
                                <div class="form-group">
                                    <asp:Button ID="btnSearch" runat="server" Text="Cari" CssClass="btn btn-info btn-sm" />
                                    </div>
                                </div>

                                </div>
                        </div>
                        <div class="card-body">
                            <asp:GridView ID="GridView1" runat="server" AllowSorting="True"
                                AutoGenerateColumns="False" DataKeyNames="Users_Id"
                                DataSourceID="SqlDataSource1"
                                AllowPaging="True" Width="100%"
                                CssClass="table table-bordered" PagerStyle-CssClass="pgr"
                                AlternatingRowStyle-CssClass="alt" PageSize="20">
                                <AlternatingRowStyle CssClass="alt" />
                                <Columns>
                                    <asp:BoundField DataField="Users_Id" HeaderText="Users_Id"
                                        InsertVisible="False" ReadOnly="True" SortExpression="Users_Id"
                                        Visible="False" />
                                    <asp:BoundField DataField="Users_Name" HeaderText="ID Pengguna"
                                        SortExpression="Users_Name" />
                                    <asp:BoundField DataField="Users_Fullname" HeaderText="Nama Penuh"
                                        SortExpression="Users_Fullname" />
                                    <asp:BoundField DataField="Users_Email" HeaderText="Email"
                                        SortExpression="Users_Email" Visible="False" />
                                    <asp:TemplateField HeaderText="Aktif" SortExpression="Users_Enabled">
                                        <EditItemTemplate>
                                            <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("Users_Enabled") %>'></asp:TextBox>
                                        </EditItemTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="CheckBox5" runat="server"
                                                Checked='<%# Bind("Users_Enabled") %>' Enabled="False" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Daftar" SortExpression="Users_Register">
                                        <EditItemTemplate>
                                            <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("Users_Register") %>'></asp:TextBox>
                                        </EditItemTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="CheckBox6" runat="server"
                                                Checked='<%# Bind("Users_Register") %>' Enabled="False" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ShowHeader="False">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False"
                                                CommandName="Select" Text="Lihat" CssClass="btn btn-warning btn-sm"></asp:LinkButton>
                                            <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False"
                                                CommandName="Delete" Text="Padam" OnClientClick="return confirm('Anda pasti untuk padam rekod ini?');" CssClass="btn btn-danger btn-sm"></asp:LinkButton>

                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <PagerStyle CssClass="pgr" />
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /.row -->


        </div>
    </section>


</asp:Content>
