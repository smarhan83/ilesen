<%@ Page Title="" Language="VB" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="applicantregister.aspx.vb" Inherits="applicantregister" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadContent" runat="Server">

<style>
    .cssRequiredField{
        color : red !important;
    }
</style>


</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">

    <section class="content-header">
        <div class="container-fluid">

       

            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0 text-dark"><div runat="server" id="idWindowTitle"></div></h1>
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
            
            <asp:FormView ID="FormView1" runat="server" DataKeyNames="Pemohon_ID"
                DataSourceID="SqlDataSourceForm" DefaultMode="Insert" Width="100%">
                <EditItemTemplate>

                    <div class="card card-warning">
                    <div class="card-header">
                        <h3 class="card-title"><div runat="server" id="idWindowTitle2">Kemaskini</div></h3>

                        <div class="card-tools">
                            <button type="button" class="btn btn-tool" data-card-widget="collapse"><i class="fas fa-minus"></i></button>
                        </div>
                    </div>
                    <!-- /.card-header -->
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Nama Pemohon <label style="color:red">*</label></label>
                                        <asp:TextBox ID="txtPemohon_Name" runat="server"  TextMode="MultiLine"
                                            Text='<%# Bind("Pemohon_Name") %>' CssClass="form-control" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" CssClass="cssRequiredField"
                                            ControlToValidate="txtPemohon_Name" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </div>
                            </div>



                          </div>

                        <div class="row">

                            <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Alamat <label style="color:red">*</label></label>
                                        <asp:TextBox ID="TextBox2" runat="server"
                                            Text='<%# Bind("Pemohon_Address") %>' CssClass="form-control" TextMode="MultiLine" Rows="3"/>  
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" CssClass="cssRequiredField"
                                            ControlToValidate="TextBox2" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                      
                                    </div>
                            </div>
                            <div class="col-md-6">
                                   
                                    <div class="form-group">
                                        <label>Catatan</label>
                                        <asp:TextBox ID="txtPemohon_Remarks" runat="server"
                                            Text='<%# Bind("Pemohon_Remarks") %>' CssClass="form-control" TextMode="MultiLine" Rows="3"/>                                       
                                    </div>

                            </div>



                          </div>

                        <div class="row">

                            <div class="col-md-6">
                                   
                                    <div class="form-group">
                                        <label>Pengguna Sistem</label>
                                        <asp:DropDownList ID="ddlPemohon_PIC" Text='<%# Bind("Pemohon_PIC") %>' CssClass="form-control select2" runat="server" 
                                        DataSourceID="SqlDataSourcePIC" DataTextField="Users_Name" DataValueField="Users_id"></asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourcePIC" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' 
                                        SelectCommand="select * from 
                                        (select NULL as Users_id, '-- Sila Pilih --' as Users_Name
                                        union all
                                        select Users_id,  Users_Name from TBL_USERS where Users_Register=1 and Users_Enabled=1
                                        ) as tbl1 order by Users_Name ">
                                        </asp:SqlDataSource>                                     
                                       <%-- <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" CssClass="cssRequiredField"
                                        ControlToValidate="ddlPemohon_PIC" ErrorMessage="Sila Pilih" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>--%>
                                    </div>

                            </div>
                            <div class="col-md-6">
                                   
                                    <div class="form-group">
                                        <label>Warganegara <label style="color:red">*</label></label>
                                        <asp:DropDownList ID="ddlPemohon_Nationality" Text='<%# Bind("Pemohon_Nationality") %>' CssClass="form-control select2" runat="server" 
                                        DataSourceID="SqlDataSourceNationality" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourceNationality" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' 
                                        SelectCommand="select * from 
                                        (select NULL as id, '-- Sila Pilih --' as name
                                        union all
                                        select id,name from TBL_LOOKUPS where lookupgrp_id = (select x.id from TBL_LOOKUPGRPS x where x.name = 'CITIZENSHIP')
                                        ) as tbl1 order by name ">
                                        </asp:SqlDataSource>                                     
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" CssClass="cssRequiredField"
                                        ControlToValidate="ddlPemohon_Nationality" ErrorMessage="Sila Pilih" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </div>

                            </div>
                           

                          </div>

                           <div class="row">

                             <div class="col-md-6">
                                    <div class="form-group">
                                        <label>No Kad Pengenalan</label>
                                        <asp:TextBox ID="txtPemohon_ICNo" runat="server"
                                            Text='<%# Bind("Pemohon_ICNo") %>' CssClass="form-control" />  
                                      
                                    </div>
                            </div>

                             <div class="col-md-6">
                                    <div class="form-group">
                                        <label>No Passport</label>
                                        <asp:TextBox ID="txtPemohon_PassportNo" runat="server"
                                            Text='<%# Bind("Pemohon_PassportNo") %>' CssClass="form-control" />  
                                      
                                    </div>
                            </div>

                           </div>

                           <div class="row">

                             <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Email</label>
                                        <asp:TextBox ID="txtPemohon_Email" runat="server"
                                            Text='<%# Bind("Pemohon_Email") %>' CssClass="form-control" />  
                                      
                                    </div>
                            </div>

                             <div class="col-md-6">
                                    <div class="form-group">
                                        <label>No Telefon Bimbit</label>
                                        <asp:TextBox ID="txtPemohon_MobileNo" runat="server"
                                            Text='<%# Bind("Pemohon_MobileNo") %>' CssClass="form-control" />  
                                      
                                    </div>
                            </div>

                           </div>

                        <div class="row">

                            <div class="col-md-6">
                                   
                                    <div class="form-group">
                                        <label>Negeri</label>
                                        <asp:DropDownList ID="ddlPemohon_State" Text='<%# Bind("Pemohon_State") %>' CssClass="form-control select2" runat="server" 
                                        DataSourceID="SqlDataSourceState" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourceState" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' 
                                        SelectCommand="select * from 
                                        (select NULL as id, '-- Sila Pilih --' as name
                                        union all
                                        select id,name from TBL_LOOKUPS where lookupgrp_id = (select x.id from TBL_LOOKUPGRPS x where x.name = 'STATE')
                                        ) as tbl1 order by name ">
                                        </asp:SqlDataSource>                                     
                                        
                                    </div>

                            </div>
                            <div class="col-md-6">
                                   
                                    <div class="form-group">
                                        <label>Bangsa</label>
                                        <asp:DropDownList ID="ddlPemohon_Race" Text='<%# Bind("Pemohon_Race") %>' CssClass="form-control select2" runat="server" 
                                        DataSourceID="SqlDataSourceRace" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourceRace" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' 
                                        SelectCommand="select * from 
                                        (select NULL as id, '-- Sila Pilih --' as name
                                        union all
                                        select id,name from TBL_LOOKUPS where lookupgrp_id = (select x.id from TBL_LOOKUPGRPS x where x.name = 'RACE')
                                        ) as tbl1 order by name ">
                                        </asp:SqlDataSource>                                     

                                    </div>

                            </div>
                           

                          </div>


                           <div class="row">
                            

                            <div class="col-md-6">
                                   
                                    <div class="form-group">
                                        <label>Status Perkahwinan</label>
                                        <asp:DropDownList ID="ddlPemohon_Marital" Text='<%# Bind("Pemohon_Marital") %>' CssClass="form-control select2" runat="server" 
                                        DataSourceID="SqlDataSourceMarital" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourceMarital" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' 
                                        SelectCommand="select * from 
                                        (select NULL as id, '-- Sila Pilih --' as name
                                        union all
                                        select id,name from TBL_LOOKUPS where lookupgrp_id = (select x.id from TBL_LOOKUPGRPS x where x.name = 'MARITAL STATUS')
                                        ) as tbl1 order by name ">
                                        </asp:SqlDataSource>                                     
                                        
                                    </div>

                            </div>
                            <div class="col-md-6">

                                    <div class="form-group">
                                        <label>Jantina</label>
                                        <asp:DropDownList ID="ddlPemohon_Gender" runat="server"
                                            SelectedValue='<%# Bind("Pemohon_Gender") %>' CssClass="form-control select2">
                                            <asp:ListItem Value="A">-- Sila Pilih --</asp:ListItem>
                                            <asp:ListItem Value="L">Lelaki</asp:ListItem>
                                            <asp:ListItem Value="P">Perempuan</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                            </div>

                            </div>

                           <div class="row">

                             <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Jenis Jualan</label>
                                        <asp:TextBox ID="txtPemohon_JenisJualan" runat="server"
                                            Text='<%# Bind("Pemohon_JenisJualan") %>' CssClass="form-control" />  
                                      
                                    </div>
                            </div>

                             <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Masa Jualan</label>
                                        <asp:TextBox ID="txtPemohon_MasaJualan" runat="server"
                                            Text='<%# Bind("Pemohon_MasaJualan") %>' CssClass="form-control" />  
                                      
                                    </div>
                            </div>

                           </div>

                           <div class="row">
                            

                            <div class="col-md-6">

                                    <div class="form-group">
                                        
                                            <label>Aktif?</label><br />
                                        <div class="form-check">
                                            <asp:CheckBox ID="CheckBox2" runat="server" Checked='<%# Bind("Pemohon_IsActive") %>' CssClass="form-check-input" />
                                        </div>
                                    </div>                                 
                                <!-- /.form-group -->
                                
                            </div>
                            <!-- /.col -->
                        </div>
                        <!-- /.row -->
                    </div>
                    <!-- /.card-body -->
                    <div class="card-footer">
                        <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" CommandName="Update" Text="Kemaskini" ValidationGroup="frmEdit" CssClass="btn btn-warning" />
                        &nbsp;<asp:LinkButton ID="UpdateCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Set Semula" CssClass="btn btn-default" />
                    </div>
                    </div>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <div class="card card-primary">
                    <div class="card-header">
                        <h3 class="card-title"><div runat="server" id="idWindowTitle3">Kunci Masuk</div></h3>

                        <div class="card-tools">
                            <button type="button" class="btn btn-tool" data-card-widget="collapse"><i class="fas fa-minus"></i></button>
                        </div>
                    </div>
                    <!-- /.card-header -->
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Nama Pemohon <label style="color:red">*</label></label>
                                        <asp:TextBox ID="txtPemohon_Name" runat="server"  TextMode="MultiLine"
                                            Text='<%# Bind("Pemohon_Name") %>' CssClass="form-control" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" CssClass="cssRequiredField"
                                            ControlToValidate="txtPemohon_Name" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </div>
                            </div>



                          </div>

                        <div class="row">

                            <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Alamat <label style="color:red">*</label></label>
                                        <asp:TextBox ID="TextBox2" runat="server"
                                            Text='<%# Bind("Pemohon_Address") %>' CssClass="form-control" TextMode="MultiLine" Rows="3"/>  
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" CssClass="cssRequiredField"
                                                ControlToValidate="TextBox2" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>                                      
                                    </div>
                            </div>
                            <div class="col-md-6">
                                   
                                    <div class="form-group">
                                        <label>Catatan</label>
                                        <asp:TextBox ID="txtPemohon_Remarks" runat="server"
                                            Text='<%# Bind("Pemohon_Remarks") %>' CssClass="form-control" TextMode="MultiLine" Rows="3"/>                                       
                                    </div>

                            </div>



                          </div>

                        <div class="row">

                            <div class="col-md-6">
                                   
                                    <div class="form-group">
                                        <label>Pengguna Sistem</label>
                                        <asp:DropDownList ID="ddlPemohon_PIC" Text='<%# Bind("Pemohon_PIC") %>' CssClass="form-control select2" runat="server" 
                                        DataSourceID="SqlDataSourcePIC" DataTextField="Users_Name" DataValueField="Users_id"></asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourcePIC" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' 
                                        SelectCommand="select * from 
                                        (select NULL as Users_id, '-- Sila Pilih --' as Users_Name
                                        union all
                                        select Users_id,  Users_Name from TBL_USERS where Users_Register=1 and Users_Enabled=1
                                        ) as tbl1 order by Users_Name ">
                                        </asp:SqlDataSource>                                     
                                       <%-- <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" CssClass="cssRequiredField"
                                        ControlToValidate="ddlPemohon_PIC" ErrorMessage="Sila Pilih" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>--%>
                                    </div>

                            </div>
                            <div class="col-md-6">
                                   
                                    <div class="form-group">
                                        <label>Warganegara <label style="color:red">*</label></label>
                                        <asp:DropDownList ID="ddlPemohon_Nationality" Text='<%# Bind("Pemohon_Nationality") %>' CssClass="form-control select2" runat="server" 
                                        DataSourceID="SqlDataSourceNationality" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourceNationality" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' 
                                        SelectCommand="select * from 
                                        (select NULL as id, '-- Sila Pilih --' as name
                                        union all
                                        select id,name from TBL_LOOKUPS where lookupgrp_id = (select x.id from TBL_LOOKUPGRPS x where x.name = 'CITIZENSHIP')
                                        ) as tbl1 order by name ">
                                        </asp:SqlDataSource>                                     
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" CssClass="cssRequiredField"
                                        ControlToValidate="ddlPemohon_Nationality" ErrorMessage="Sila Pilih" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </div>

                            </div>
                           

                          </div>

                           <div class="row">

                             <div class="col-md-6">
                                    <div class="form-group">
                                        <label>No Kad Pengenalan</label>
                                        <asp:TextBox ID="txtPemohon_ICNo" runat="server"
                                            Text='<%# Bind("Pemohon_ICNo") %>' CssClass="form-control" />  
                                      
                                    </div>
                            </div>

                             <div class="col-md-6">
                                    <div class="form-group">
                                        <label>No Passport</label>
                                        <asp:TextBox ID="txtPemohon_PassportNo" runat="server"
                                            Text='<%# Bind("Pemohon_PassportNo") %>' CssClass="form-control" />  
                                      
                                    </div>
                            </div>

                           </div>

                           <div class="row">

                             <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Email</label>
                                        <asp:TextBox ID="txtPemohon_Email" runat="server"
                                            Text='<%# Bind("Pemohon_Email") %>' CssClass="form-control" />  
                                      
                                    </div>
                            </div>

                             <div class="col-md-6">
                                    <div class="form-group">
                                        <label>No Telefon Bimbit</label>
                                        <asp:TextBox ID="txtPemohon_MobileNo" runat="server"
                                            Text='<%# Bind("Pemohon_MobileNo") %>' CssClass="form-control" />  
                                      
                                    </div>
                            </div>

                           </div>

                        <div class="row">

                            <div class="col-md-6">
                                   
                                    <div class="form-group">
                                        <label>Negeri</label>
                                        <asp:DropDownList ID="ddlPemohon_State" Text='<%# Bind("Pemohon_State") %>' CssClass="form-control select2" runat="server" 
                                        DataSourceID="SqlDataSourceState" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourceState" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' 
                                        SelectCommand="select * from 
                                        (select NULL as id, '-- Sila Pilih --' as name
                                        union all
                                        select id,name from TBL_LOOKUPS where lookupgrp_id = (select x.id from TBL_LOOKUPGRPS x where x.name = 'STATE')
                                        ) as tbl1 order by name ">
                                        </asp:SqlDataSource>                                     
                                        
                                    </div>

                            </div>
                            <div class="col-md-6">
                                   
                                    <div class="form-group">
                                        <label>Bangsa</label>
                                        <asp:DropDownList ID="ddlPemohon_Race" Text='<%# Bind("Pemohon_Race") %>' CssClass="form-control select2" runat="server" 
                                        DataSourceID="SqlDataSourceRace" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourceRace" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' 
                                        SelectCommand="select * from 
                                        (select NULL as id, '-- Sila Pilih --' as name
                                        union all
                                        select id,name from TBL_LOOKUPS where lookupgrp_id = (select x.id from TBL_LOOKUPGRPS x where x.name = 'RACE')
                                        ) as tbl1 order by name ">
                                        </asp:SqlDataSource>                                     

                                    </div>

                            </div>
                           

                          </div>


                           <div class="row">
                            

                            <div class="col-md-6">
                                   
                                    <div class="form-group">
                                        <label>Status Perkahwinan</label>
                                        <asp:DropDownList ID="ddlPemohon_Marital" Text='<%# Bind("Pemohon_Marital") %>' CssClass="form-control select2" runat="server" 
                                        DataSourceID="SqlDataSourceMarital" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourceMarital" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' 
                                        SelectCommand="select * from 
                                        (select NULL as id, '-- Sila Pilih --' as name
                                        union all
                                        select id,name from TBL_LOOKUPS where lookupgrp_id = (select x.id from TBL_LOOKUPGRPS x where x.name = 'MARITAL STATUS')
                                        ) as tbl1 order by name ">
                                        </asp:SqlDataSource>                                     
                                        
                                    </div>

                            </div>
                            <div class="col-md-6">

                                    <div class="form-group">
                                        <label>Jantina</label>
                                        <asp:DropDownList ID="ddlPemohon_Gender" runat="server"
                                            SelectedValue='<%# Bind("Pemohon_Gender") %>' CssClass="form-control select2">
                                            <asp:ListItem Value="A">-- Sila Pilih --</asp:ListItem>
                                            <asp:ListItem Value="L">LELAKI</asp:ListItem>
                                            <asp:ListItem Value="P">PEREMPUAN</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                            </div>

                            </div>

                           <div class="row">

                             <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Jenis Jualan</label>
                                        <asp:TextBox ID="txtPemohon_JenisJualan" runat="server"
                                            Text='<%# Bind("Pemohon_JenisJualan") %>' CssClass="form-control" />  
                                      
                                    </div>
                            </div>

                             <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Masa Jualan</label>
                                        <asp:TextBox ID="txtPemohon_MasaJualan" runat="server"
                                            Text='<%# Bind("Pemohon_MasaJualan") %>' CssClass="form-control" />  
                                      
                                    </div>
                            </div>

                           </div>

                           <div class="row">
                            

                            <div class="col-md-6">

                                    <div class="form-group">
                                        
                                            <label>Aktif?</label><br />
                                        <div class="form-check">
                                            <asp:CheckBox ID="CheckBox2" runat="server" Checked='<%# Bind("Pemohon_IsActive") %>' CssClass="form-check-input" />
                                        </div>
                                    </div>                                 
                                <!-- /.form-group -->
                                
                            </div>
                            <!-- /.col -->
                        </div>
                        <!-- /.row -->
                    </div>
                        <!-- /.card-body -->
                        <div class="card-footer">
                            <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" Text="Kunci Masuk" ValidationGroup="frmEdit" CssClass="btn btn-primary" />
                            &nbsp;
                                <asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Set Semula" CssClass="btn btn-default" />
                        </div>
                    </div>
                </InsertItemTemplate>
            </asp:FormView>

            <asp:SqlDataSource ID="SqlDataSourceForm" runat="server"
                ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" 
                InsertCommand="
                INSERT INTO LESEN_Pemohon
                (Pemohon_Name, Pemohon_Remarks, Pemohon_Address, Pemohon_Nationality, Pemohon_ICNo, Pemohon_PassportNo, Pemohon_Email,
                Pemohon_MobileNo, Pemohon_TelNo, Pemohon_State, Pemohon_Race, Pemohon_Marital, Pemohon_Gender, 
                Pemohon_JenisJualan, Pemohon_MasaJualan, Pemohon_PIC,
                Pemohon_IsActive, CreatorID,CreatedDt) VALUES 
                (@Pemohon_Name, @Pemohon_Remarks, @Pemohon_Address, @Pemohon_Nationality, @Pemohon_ICNo, @Pemohon_PassportNo, @Pemohon_Email,
                @Pemohon_MobileNo, @Pemohon_TelNo, @Pemohon_State, @Pemohon_Race, @Pemohon_Marital, @Pemohon_Gender, 
                @Pemohon_JenisJualan, @Pemohon_MasaJualan, @Pemohon_PIC,
                @Pemohon_IsActive, @CreatorID,getdate())"
                SelectCommand="SELECT * FROM LESEN_Pemohon WHERE Pemohon_ID = @Pemohon_ID"
                UpdateCommand=
                "UPDATE LESEN_Pemohon 
                SET Pemohon_Name = @Pemohon_Name, Pemohon_Remarks = @Pemohon_Remarks, 
                Pemohon_Address = @Pemohon_Address, Pemohon_Nationality = @Pemohon_Nationality, Pemohon_ICNo = @Pemohon_ICNo, 
                Pemohon_PassportNo = @Pemohon_PassportNo, Pemohon_Email = @Pemohon_Email, Pemohon_MobileNo = @Pemohon_MobileNo, 
                Pemohon_TelNo = @Pemohon_TelNo, Pemohon_State = @Pemohon_State, Pemohon_Race = @Pemohon_Race, Pemohon_Marital = @Pemohon_Marital, 
                Pemohon_Gender = @Pemohon_Gender, Pemohon_JenisJualan = @Pemohon_JenisJualan, Pemohon_MasaJualan = @Pemohon_MasaJualan,                
                Pemohon_PIC = @Pemohon_PIC,
                Pemohon_IsActive = @Pemohon_IsActive,
                LastModID = @LastModID, LastModDt = getdate() WHERE (Pemohon_ID = @Pemohon_ID)">
                <InsertParameters>
                    <asp:Parameter Name="Pemohon_Name" />
                    <asp:Parameter Name="Pemohon_Remarks" />
                    <asp:Parameter Name="Pemohon_Address" />
                    <asp:Parameter Name="Pemohon_Nationality" />
                    <asp:Parameter Name="Pemohon_ICNo" />
                    <asp:Parameter Name="Pemohon_PassportNo" />
                    <asp:Parameter Name="Pemohon_Email" />
                    <asp:Parameter Name="Pemohon_MobileNo" />
                    <asp:Parameter Name="Pemohon_TelNo" />
                    <asp:Parameter Name="Pemohon_Race" />
                    <asp:Parameter Name="Pemohon_State" />
                    <asp:Parameter Name="Pemohon_Marital" />
                    <asp:Parameter Name="Pemohon_Gender" />
                    <asp:Parameter Name="Pemohon_JenisJualan" />
                    <asp:Parameter Name="Pemohon_MasaJualan" />
                    <asp:Parameter Name="Pemohon_PIC" />
                    <asp:Parameter Name="Pemohon_IsActive"></asp:Parameter>
                    <asp:SessionParameter SessionField="sessionUserName" Name="CreatorID"></asp:SessionParameter>                   
                </InsertParameters>
                <SelectParameters>
                    <asp:ControlParameter ControlID="GridView1" Name="Pemohon_ID"
                        PropertyName="SelectedValue" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="Pemohon_Name" />
                    <asp:Parameter Name="Pemohon_Remarks" />
                    <asp:Parameter Name="Pemohon_Address" />
                    <asp:Parameter Name="Pemohon_Nationality" />
                    <asp:Parameter Name="Pemohon_ICNo" />
                    <asp:Parameter Name="Pemohon_PassportNo" />
                    <asp:Parameter Name="Pemohon_Email" />
                    <asp:Parameter Name="Pemohon_MobileNo" />
                    <asp:Parameter Name="Pemohon_TelNo" />
                    <asp:Parameter Name="Pemohon_Race" />
                    <asp:Parameter Name="Pemohon_State" />
                    <asp:Parameter Name="Pemohon_Marital" />
                    <asp:Parameter Name="Pemohon_Gender" />
                    <asp:Parameter Name="Pemohon_JenisJualan" />
                    <asp:Parameter Name="Pemohon_MasaJualan" />
                    <asp:Parameter Name="Pemohon_PIC" />
                    <asp:Parameter Name="Pemohon_IsActive"></asp:Parameter>
                    <asp:SessionParameter SessionField="sessionUserName" Name="LastModID"></asp:SessionParameter>    
                    <asp:ControlParameter ControlID="GridView1" DefaultValue="" Name="Pemohon_ID" PropertyName="SelectedValue" />                    
                </UpdateParameters>
            </asp:SqlDataSource>

            <div class="card">
                <div class="card-body" style="overflow-x: auto;">
                        <%--# START FILTER - set SortExpression at GridView as fieldname & add WHERE 1=1 at SqlDataSource - SelectCommand #--%>
                        <div class="row">
                            <div class="col-md-10">
                                <div id="pnlFilter" runat="server" class="row"></div>
                            </div>
                            <div class="col-md-2">
                                <div class="form-group">
                                    <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-default" Text="Cari" />
                                    <asp:Button ID="btnReset" CssClass="btn btn-default" runat="server" Text="Set Semula" />
                                </div>
                            </div>
                        </div>
                        <%--# END FILTER #--%>

                    <asp:GridView ID="GridView1" runat="server"
                        AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="Pemohon_ID"
                        DataSourceID="SqlDataSourceGrid"
                        CssClass="table table-bordered" PagerStyle-CssClass="pgr"
                        AlternatingRowStyle-CssClass="alt" AllowPaging="True" PageSize="20">
                        <AlternatingRowStyle CssClass="alt" />
                        <Columns>
                            <asp:BoundField DataField="Pemohon_ID" HeaderText="ID" InsertVisible="False"
                                ReadOnly="True" SortExpression="Pemohon_ID"  />
                            <asp:BoundField DataField="Pemohon_Name" HeaderText="Nama Pemohon"
                                SortExpression="Pemohon_Name"  />
                            <asp:BoundField DataField="Pemohon_Remarks" HeaderText="Catatan"
                                SortExpression="Pemohon_Remarks" />

                            <asp:BoundField DataField="Pemohon_ICNo" HeaderText="No Kad Pengenalan"
                                SortExpression="Pemohon_ICNo" />
                            <asp:BoundField DataField="Pemohon_PassportNo" HeaderText="No Passport"
                                SortExpression="Pemohon_PassportNo" />
                            <asp:BoundField DataField="Pemohon_MobileNo" HeaderText="No Tel Bimbit"
                                SortExpression="Pemohon_MobileNo" />
                            <asp:BoundField DataField="Pemohon_Email" HeaderText="Email"
                                SortExpression="Pemohon_Email" />                       

                            <asp:CheckBoxField DataField="Pemohon_IsActive" HeaderText="Aktif?" SortExpression="Pemohon_IsActive" />
                            <asp:TemplateField ShowHeader="False">
                                <ItemTemplate>
                                    <asp:LinkButton runat="server" Text="Kemaskini" CommandName="Select" CausesValidation="False" ID="LinkButton2" CssClass="btn btn-warning btn-sm"></asp:LinkButton>
                                    <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False"
                                        CommandName="Delete" Text="Nyah Aktif" OnClientClick="return confirm('Anda Pasti Untuk Nyah Aktif rekod ini?');" CssClass="btn btn-danger btn-sm"></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <PagerStyle CssClass="pgr" />
                    </asp:GridView>                    
                </div>
            </div>

        </div>
    </section>

    <asp:SqlDataSource ID="SqlDataSourceGrid" runat="server"
        ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
        SelectCommand="SELECT * from LESEN_Pemohon WHERE 1=1 ORDER BY Pemohon_ID"        
        DeleteCommand="Update LESEN_Pemohon set Pemohon_IsActive = 0 WHERE Pemohon_ID = @Pemohon_ID">
        <DeleteParameters>
                    <asp:ControlParameter ControlID="GridView1" DefaultValue="" Name="Pemohon_ID" PropertyName="SelectedValue" /> 
        </DeleteParameters>

    </asp:SqlDataSource>

    <script>

        function pageLoad() {


            $(function () {

                $('.datepicker').datepicker({
                    dateFormat: 'dd/mm/yy',
                    defaultDate: new Date()
                })

                //Initialize Select2 Elements
                $('.select2').select2()

                //Initialize Select2 Elements
                $('.select2bs4').select2({
                    theme: 'bootstrap4'
                })

                //Datemask dd/mm/yyyy
                $('#datemask').inputmask('dd/mm/yyyy', { 'placeholder': 'dd/mm/yyyy' })
                //Datemask2 mm/dd/yyyy
                $('#datemask2').inputmask('mm/dd/yyyy', { 'placeholder': 'mm/dd/yyyy' })
                //Money Euro
                $('[data-mask]').inputmask()

                //Date range picker
                $('#reservationdate').datetimepicker({
                    format: 'L'
                });
                //Date range picker
                $('#reservation').daterangepicker()
                //Date range picker with time picker
                $('#reservationtime').daterangepicker({
                    timePicker: true,
                    timePickerIncrement: 30,
                    locale: {
                        format: 'MM/DD/YYYY hh:mm A'
                    }
                })
                //Date range as a button
                $('#daterange-btn').daterangepicker(
                    {
                        ranges: {
                            'Today': [moment(), moment()],
                            'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
                            'Last 7 Days': [moment().subtract(6, 'days'), moment()],
                            'Last 30 Days': [moment().subtract(29, 'days'), moment()],
                            'This Month': [moment().startOf('month'), moment().endOf('month')],
                            'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
                        },
                        startDate: moment().subtract(29, 'days'),
                        endDate: moment()
                    },
                    function (start, end) {
                        $('#reportrange span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'))
                    }
                )

                //Timepicker
                $('#timepicker').datetimepicker({
                    format: 'LT'
                })

                //Bootstrap Duallistbox
                $('.duallistbox').bootstrapDualListbox()

                //Colorpicker
                $('.my-colorpicker1').colorpicker()
                //color picker with addon
                $('.my-colorpicker2').colorpicker()

                $('.my-colorpicker2').on('colorpickerChange', function (event) {
                    $('.my-colorpicker2 .fa-square').css('color', event.color.toString());
                });

                $("input[data-bootstrap-switch]").each(function () {
                    $(this).bootstrapSwitch('state', $(this).prop('checked'));
                });

                $("#example1").DataTable({
                    "responsive": true,
                    "autoWidth": false,
                });
                $('#example2').DataTable({
                    "paging": true,
                    "lengthChange": false,
                    "searching": false,
                    "ordering": true,
                    "info": true,
                    "autoWidth": false,
                    "responsive": true,
                });
                $('.toastrDefaultSuccess').click(function () {
                    toastr.success('Lorem ipsum dolor sit amet, consetetur sadipscing elitr.')
                });


            })

        }
    </script>

<script type="text/javascript">
    function WebForm_OnSubmit() {
        if (typeof (ValidatorOnSubmit) == "function" && ValidatorOnSubmit() == false) {
            for (var i in Page_Validators) {
                try {
                    if (!Page_Validators[i].isvalid) {
                        var control = $("#" + Page_Validators[i].controltovalidate);

                        var top = control.offset().top;
                        $('html, body').animate({ scrollTop: top - 10 }, 800);
                        control.focus();
                        return;
                    }
                } catch (e) { }
            }
            return false;
        }
        return true;
    }
</script>

</asp:Content>

