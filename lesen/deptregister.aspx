<%@ Page Title="" Language="VB" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="deptregister.aspx.vb" Inherits="deptregister" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="asp" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadContent" runat="Server">

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
            
            <asp:FormView ID="FormView1" runat="server" DataKeyNames="JabatanAgensi_ID"
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
                                        <label>Jabatan / Agensi</label>
                                        <asp:TextBox ID="txtJabatanAgensi_Description" runat="server"
                                            Text='<%# Bind("JabatanAgensi_Description") %>' CssClass="form-control" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" CssClass="cssRequiredField"
                                            ControlToValidate="txtJabatanAgensi_Description" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </div>
                            </div>

                            <div class="col-md-6">
                                   
                                    <div class="form-group">
                                        <label>Catatan</label>
                                        <asp:TextBox ID="txtJabatanAgensi_Remarks" runat="server"
                                            Text='<%# Bind("JabatanAgensi_Remarks") %>' CssClass="form-control" TextMode="MultiLine" Rows="3"/>                                       
                                    </div>

                            </div>

                          </div>

                        <div class="row">
                            <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Alamat</label>
                                        <asp:TextBox ID="TextBox2" runat="server"
                                            Text='<%# Bind("JabatanAgensi_Address") %>' CssClass="form-control" TextMode="MultiLine" Rows="3"/>  
                                      
                                    </div>
                            </div>

                            <div class="col-md-6">

                                    <div class="form-group">
                                        <label>Kategori</label>
                                        <asp:DropDownList ID="ddlJabatanAgensi_Type" runat="server"
                                            SelectedValue='<%# Bind("JabatanAgensi_Type") %>' CssClass="form-control select2">
                                            <asp:ListItem Value="A">-- Sila Pilih --</asp:ListItem>
                                            <asp:ListItem Value="J">Jabatan</asp:ListItem>
                                            <asp:ListItem Value="L">Agensi</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                            </div>

                            <div class="col-md-6" runat="server" visible="false">
                                   
                                    <div class="form-group">
                                        <label>Penyedia</label>
                                        <asp:DropDownList ID="ddlJabatanAgensi_Penyedia" Text='<%# Bind("JabatanAgensi_Penyedia") %>' CssClass="form-control select2" runat="server" 
                                        DataSourceID="SqlDataSourcePIC" DataTextField="Users_Name" DataValueField="Users_id"></asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourcePIC" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' 
                                        SelectCommand="select * from 
                                        (select NULL as Users_id, '-- Sila Pilih --' as Users_Name
                                        union all
                                        select Users_id,  Users_Name from TBL_USERS where Users_Register=1 and Users_Enabled=1
                                        ) as tbl1 order by Users_Name ">
                                        </asp:SqlDataSource>                                     
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" CssClass="cssRequiredField"
                                        ControlToValidate="ddlJabatanAgensi_Penyedia" ErrorMessage="Sila Pilih" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </div>

                            </div>

                          </div>



                           <div class="row">
                            


                            <div class="col-md-6"  runat="server" visible="false">
                                   
                                    <div class="form-group">
                                        <label>Pengesah</label>
                                        <asp:DropDownList ID="ddlJabatanAgensi_Pengesah" Text='<%# Bind("JabatanAgensi_Pengesah") %>' CssClass="form-control select2" runat="server" 
                                        DataSourceID="SqlDataSourcePengesah" DataTextField="Users_Name" DataValueField="Users_id"></asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourcePengesah" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' 
                                        SelectCommand="select * from 
                                        (select NULL as Users_id, '-- Sila Pilih --' as Users_Name
                                        union all
                                        select Users_id,  Users_Name from TBL_USERS where Users_Register=1 and Users_Enabled=1
                                        ) as tbl1 order by Users_Name ">
                                        </asp:SqlDataSource>                                     
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" CssClass="cssRequiredField"
                                        ControlToValidate="ddlJabatanAgensi_Pengesah" ErrorMessage="Sila Pilih" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </div>

                            </div>

                            <!-- /.col -->
                        </div>


                        <div class="row">

                            <div class="col-md-6">

                                    <div class="form-group">
                                       <label>Letter (Kepada)</label>
                                        <asp:TextBox ID="txtJabatanAgensi_Kepada" runat="server"
                                            Text='<%# Bind("JabatanAgensi_Kepada") %>' CssClass="form-control"/>  
                                    </div>
                            </div>

                            <div class="col-md-3">

                                    <div class="form-group">
                                        
                                            <label>Jabatan Lesen?</label><br />
                                        <div class="form-check">
                                            <asp:CheckBox ID="cbIslesen" AutoPostBack="true" runat="server" Checked='<%# Bind("JabatanAgensi_IsLesen") %>' CssClass="form-check-input"  OnCheckedChanged="cbIslesen_CheckedChanged" />
                                        </div>
                                    </div>                                 
                                <!-- /.form-group -->
                                
                            </div>
                            
                            <div class="col-md-3">

                                    <div class="form-group">
                                        
                                            <label>Aktif?</label><br />
                                        <div class="form-check">
                                            <asp:CheckBox ID="CheckBox2" runat="server" Checked='<%# Bind("JabatanAgensi_IsActive") %>' CssClass="form-check-input" />
                                        </div>
                                    </div>                                 
                                <!-- /.form-group -->
                                
                            </div>

                            <div class="col-md-6"  runat="server" visible="false">
                                   
                                    <div class="form-group">
                                        <label>Peraku</label>
                                        <asp:DropDownList ID="ddlJabatanAgensi_Peraku" Text='<%# Bind("JabatanAgensi_Peraku") %>' CssClass="form-control select2" runat="server" 
                                        DataSourceID="SqlDataSourcePeraku" DataTextField="Users_Name" DataValueField="Users_id"></asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourcePeraku" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' 
                                        SelectCommand="select * from 
                                        (select NULL as Users_id, '-- Sila Pilih --' as Users_Name
                                        union all
                                        select Users_id,  Users_Name from TBL_USERS where Users_Register=1 and Users_Enabled=1
                                        ) as tbl1 order by Users_Name ">
                                        </asp:SqlDataSource>                                     
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" CssClass="cssRequiredField"
                                        ControlToValidate="ddlJabatanAgensi_Peraku" ErrorMessage="Sila Pilih" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </div>

                            </div>

                           

                        </div>


                        <div class="row" runat="server" id="idSignLetter">


                            <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Signature</label>
                                        <asp:TextBox ID="txtJabatanAgensi_Signature" runat="server"
                                            Text='<%# Bind("JabatanAgensi_Signature") %>' CssClass="form-control" TextMode="MultiLine" Rows="10"/>  
                                        <asp:HtmlEditorExtender ID="HtmlEditorExtender4" runat="server" TargetControlID="txtJabatanAgensi_Signature" DisplaySourceTab="True"></asp:HtmlEditorExtender>
                                    </div>
                            </div>
                        </div>

                        <div class="row" runat="server" visible="false">
                            <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Letter (Section 1)</label>
                                        <asp:TextBox ID="txtJabatanAgensi_LetterSection1" runat="server"
                                            Text='<%# Bind("JabatanAgensi_LetterSection1") %>' CssClass="form-control" TextMode="MultiLine" Rows="10"/> 
                                        <asp:HtmlEditorExtender ID="HtmlEditorExtender1" runat="server" TargetControlID="txtJabatanAgensi_LetterSection1" DisplaySourceTab="True"></asp:HtmlEditorExtender>
                                      
                                    </div>
                            </div>

                            <div class="col-md-6">

                                    <div class="form-group">
                                       <label>Letter (Section 2)</label>
                                        <asp:TextBox ID="txtJabatanAgensi_LetterSection2" runat="server"
                                            Text='<%# Bind("JabatanAgensi_LetterSection2") %>' CssClass="form-control" TextMode="MultiLine" Rows="10"/>  
                                        <asp:HtmlEditorExtender ID="HtmlEditorExtender2" runat="server" TargetControlID="txtJabatanAgensi_LetterSection2" DisplaySourceTab="True"></asp:HtmlEditorExtender>
                                    </div>
                            </div>

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
                                        <label>Jabatan / Agensi</label>
                                        <asp:TextBox ID="txtJabatanAgensi_Description" runat="server"
                                            Text='<%# Bind("JabatanAgensi_Description") %>' CssClass="form-control" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" CssClass="cssRequiredField"
                                            ControlToValidate="txtJabatanAgensi_Description" ErrorMessage="Sila Isi" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </div>
                            </div>

                            <div class="col-md-6">
                                   
                                    <div class="form-group">
                                        <label>Catatan</label>
                                        <asp:TextBox ID="txtJabatanAgensi_Remarks" runat="server"
                                            Text='<%# Bind("JabatanAgensi_Remarks") %>' CssClass="form-control" TextMode="MultiLine" Rows="3"/>                                       
                                    </div>

                            </div>

                          </div>

                        <div class="row">
                            <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Alamat</label>
                                        <asp:TextBox ID="TextBox2" runat="server"
                                            Text='<%# Bind("JabatanAgensi_Address") %>' CssClass="form-control" TextMode="MultiLine" Rows="3"/>  
                                      
                                    </div>
                            </div>

                            <div class="col-md-6">

                                    <div class="form-group">
                                        <label>Kategori</label>
                                        <asp:DropDownList ID="ddlJabatanAgensi_Type" runat="server"
                                            SelectedValue='<%# Bind("JabatanAgensi_Type") %>' CssClass="form-control select2">
                                            <asp:ListItem Value="A">-- Sila Pilih --</asp:ListItem>
                                            <asp:ListItem Value="J">Jabatan</asp:ListItem>
                                            <asp:ListItem Value="L">Agensi</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                            </div>
                            <div class="col-md-6"  runat="server" visible="false">
                                   
                                    <div class="form-group">
                                        <label>Penyedia</label>
                                        <asp:DropDownList ID="ddlJabatanAgensi_Penyedia" Text='<%# Bind("JabatanAgensi_Penyedia") %>' CssClass="form-control select2" runat="server" 
                                        DataSourceID="SqlDataSourcePIC" DataTextField="Users_Name" DataValueField="Users_id"></asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourcePIC" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' 
                                        SelectCommand="select * from 
                                        (select NULL as Users_id, '-- Sila Pilih --' as Users_Name
                                        union all
                                        select Users_id,  Users_Name from TBL_USERS where Users_Register=1 and Users_Enabled=1
                                        ) as tbl1 order by Users_Name ">
                                        </asp:SqlDataSource>                                     
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" CssClass="cssRequiredField"
                                        ControlToValidate="ddlJabatanAgensi_Penyedia" ErrorMessage="Sila Pilih" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </div>

                            </div>

                          </div>

                           <div class="row">
                            


                            <div class="col-md-6"  runat="server" visible="false">
                                   
                                    <div class="form-group">
                                        <label>Pengesah</label>
                                        <asp:DropDownList ID="ddlJabatanAgensi_Pengesah" Text='<%# Bind("JabatanAgensi_Pengesah") %>' CssClass="form-control select2" runat="server" 
                                        DataSourceID="SqlDataSourcePengesah" DataTextField="Users_Name" DataValueField="Users_id"></asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourcePengesah" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' 
                                        SelectCommand="select * from 
                                        (select NULL as Users_id, '-- Sila Pilih --' as Users_Name
                                        union all
                                        select Users_id,  Users_Name from TBL_USERS where Users_Register=1 and Users_Enabled=1
                                        ) as tbl1 order by Users_Name ">
                                        </asp:SqlDataSource>                                     
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" CssClass="cssRequiredField"
                                        ControlToValidate="ddlJabatanAgensi_Pengesah" ErrorMessage="Sila Pilih" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </div>

                            </div>

                            <!-- /.col -->
                        </div>


                        <div class="row">


                            <div class="col-md-6">

                                    <div class="form-group">
                                       <label>Letter (Kepada)</label>
                                        <asp:TextBox ID="txtJabatanAgensi_Kepada" runat="server"
                                            Text='<%# Bind("JabatanAgensi_Kepada") %>' CssClass="form-control"/>  
                                    </div>
                            </div>

                            
                            <div class="col-md-3">

                                    <div class="form-group">
                                        
                                            <label>Jabatan Lesen?</label><br />
                                        <div class="form-check">
                                            <asp:CheckBox ID="cbIslesen" AutoPostBack="true" runat="server" Checked='<%# Bind("JabatanAgensi_IsLesen") %>' CssClass="form-check-input" OnCheckedChanged="cbIslesen_CheckedChanged" />
                                        </div>
                                    </div>                                 
                                <!-- /.form-group -->
                                
                            </div>

                            <div class="col-md-3">

                                    <div class="form-group">
                                        
                                            <label>Aktif?</label><br />
                                        <div class="form-check">
                                            <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("JabatanAgensi_IsActive") %>' CssClass="form-check-input" />
                                        </div>
                                    </div>                                 
                                <!-- /.form-group -->
                                
                            </div>

                            <div class="col-md-6"  runat="server" visible="false">
                                   
                                    <div class="form-group">
                                        <label>Peraku</label>
                                        <asp:DropDownList ID="ddlJabatanAgensi_Peraku" Text='<%# Bind("JabatanAgensi_Peraku") %>' CssClass="form-control select2" runat="server" 
                                        DataSourceID="SqlDataSourcePeraku" DataTextField="Users_Name" DataValueField="Users_id"></asp:DropDownList>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSourcePeraku" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' 
                                        SelectCommand="select * from 
                                        (select NULL as Users_id, '-- Sila Pilih --' as Users_Name
                                        union all
                                        select Users_id,  Users_Name from TBL_USERS where Users_Register=1 and Users_Enabled=1
                                        ) as tbl1 order by Users_Name ">
                                        </asp:SqlDataSource>                                     
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" CssClass="cssRequiredField"
                                        ControlToValidate="ddlJabatanAgensi_Peraku" ErrorMessage="Sila Pilih" ValidationGroup="frmEdit" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </div>

                            </div>

                           

                        </div>

                        <div class="row" runat="server" id="idSignLetter">


                            <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Signature</label>
                                        <asp:TextBox ID="txtJabatanAgensi_Signature" runat="server"
                                            Text='<%# Bind("JabatanAgensi_Signature") %>' CssClass="form-control" TextMode="MultiLine" Rows="10"/>  
                                        <asp:HtmlEditorExtender ID="HtmlEditorExtender4" runat="server" TargetControlID="txtJabatanAgensi_Signature" DisplaySourceTab="True"></asp:HtmlEditorExtender>
                                    </div>
                            </div>
                        </div>


                        <div class="row" runat="server" visible="false">
                            <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Letter (Section 1)</label>
                                        <asp:TextBox ID="txtJabatanAgensi_LetterSection1" runat="server"
                                            Text='<%# Bind("JabatanAgensi_LetterSection1") %>' CssClass="form-control" TextMode="MultiLine" Rows="10"/>  
                                        <asp:HtmlEditorExtender ID="HtmlEditorExtender1" runat="server" TargetControlID="txtJabatanAgensi_LetterSection1" DisplaySourceTab="True"></asp:HtmlEditorExtender>
                                    </div>
                            </div>

                            <div class="col-md-6">

                                    <div class="form-group">
                                       <label>Letter (Section 2)</label>
                                        <asp:TextBox ID="txtJabatanAgensi_LetterSection2" runat="server"
                                            Text='<%# Bind("JabatanAgensi_LetterSection2") %>' CssClass="form-control" TextMode="MultiLine" Rows="10"/>  
                                        <asp:HtmlEditorExtender ID="HtmlEditorExtender3" runat="server" TargetControlID="txtJabatanAgensi_LetterSection2" DisplaySourceTab="True"></asp:HtmlEditorExtender>
                                    </div>
                            </div>

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
                INSERT INTO LESEN_JabatanAgensi
                (JabatanAgensi_Description, JabatanAgensi_Remarks, JabatanAgensi_Kepada,JabatanAgensi_LetterSection1,JabatanAgensi_LetterSection2,
                JabatanAgensi_Address, JabatanAgensi_Penyedia,JabatanAgensi_Peraku,JabatanAgensi_Pengesah, JabatanAgensi_Type,JabatanAgensi_Signature,
                JabatanAgensi_IsActive, JabatanAgensi_IsLesen, CreatorID,CreatedDt) VALUES 
                (@JabatanAgensi_Description, @JabatanAgensi_Remarks, @JabatanAgensi_Kepada,@JabatanAgensi_LetterSection1,@JabatanAgensi_LetterSection2,
                @JabatanAgensi_Address, @JabatanAgensi_Penyedia,@JabatanAgensi_Peraku, @JabatanAgensi_Pengesah,
                @JabatanAgensi_Type, @JabatanAgensi_Signature, @JabatanAgensi_IsActive, @JabatanAgensi_IsLesen, @CreatorID,getdate())"
                SelectCommand="SELECT * FROM LESEN_JabatanAgensi WHERE JabatanAgensi_ID = @JabatanAgensi_ID"
                UpdateCommand=
                "UPDATE LESEN_JabatanAgensi 
                SET JabatanAgensi_Description = @JabatanAgensi_Description, JabatanAgensi_Remarks = @JabatanAgensi_Remarks, 
                JabatanAgensi_Kepada = @JabatanAgensi_Kepada,JabatanAgensi_LetterSection1 = @JabatanAgensi_LetterSection1,JabatanAgensi_LetterSection2 = @JabatanAgensi_LetterSection2,
                JabatanAgensi_Address = @JabatanAgensi_Address, JabatanAgensi_Penyedia = @JabatanAgensi_Penyedia, JabatanAgensi_Peraku = @JabatanAgensi_Peraku,
                JabatanAgensi_Pengesah = @JabatanAgensi_Pengesah,JabatanAgensi_Signature = @JabatanAgensi_Signature,
                JabatanAgensi_Type = @JabatanAgensi_Type, JabatanAgensi_IsActive = @JabatanAgensi_IsActive, JabatanAgensi_IsLesen = @JabatanAgensi_IsLesen,
                LastModID = @LastModID, LastModDt = getdate() WHERE (JabatanAgensi_ID = @JabatanAgensi_ID)">
                <InsertParameters>
                    <asp:Parameter Name="JabatanAgensi_Signature" />
                    <asp:Parameter Name="JabatanAgensi_Description" />
                    <asp:Parameter Name="JabatanAgensi_Remarks" />
                    <asp:Parameter Name="JabatanAgensi_Kepada" />
                    <asp:Parameter Name="JabatanAgensi_LetterSection1" />
                    <asp:Parameter Name="JabatanAgensi_LetterSection2" />
                    <asp:Parameter Name="JabatanAgensi_Address" />
                    <asp:Parameter Name="JabatanAgensi_Penyedia" />
                    <asp:Parameter Name="JabatanAgensi_Pengesah" />
                    <asp:Parameter Name="JabatanAgensi_Peraku" />                    
                    <asp:Parameter Name="JabatanAgensi_Type" />
                    <asp:Parameter Name="JabatanAgensi_IsActive"></asp:Parameter>
                    <asp:Parameter Name="JabatanAgensi_IsLesen"></asp:Parameter>                    
                    <asp:SessionParameter SessionField="sessionUserName" Name="CreatorID"></asp:SessionParameter>                   
                </InsertParameters>
                <SelectParameters>
                    <asp:ControlParameter ControlID="GridView1" Name="JabatanAgensi_ID"
                        PropertyName="SelectedValue" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="JabatanAgensi_Signature" />
                    <asp:Parameter Name="JabatanAgensi_Description" />
                    <asp:Parameter Name="JabatanAgensi_Remarks" />
                    <asp:Parameter Name="JabatanAgensi_Kepada" />
                    <asp:Parameter Name="JabatanAgensi_LetterSection1" />
                    <asp:Parameter Name="JabatanAgensi_LetterSection2" />
                    <asp:Parameter Name="JabatanAgensi_Address" />
                    <asp:Parameter Name="JabatanAgensi_Penyedia" />
                    <asp:Parameter Name="JabatanAgensi_Pengesah" />
                    <asp:Parameter Name="JabatanAgensi_Peraku" />
                    <asp:Parameter Name="JabatanAgensi_Type" />
                    <asp:Parameter Name="JabatanAgensi_IsActive"></asp:Parameter>
                    <asp:Parameter Name="JabatanAgensi_IsLesen"></asp:Parameter>
                    <asp:SessionParameter SessionField="sessionUserName" Name="LastModID"></asp:SessionParameter>    
                    <asp:ControlParameter ControlID="GridView1" DefaultValue="" Name="JabatanAgensi_ID" PropertyName="SelectedValue" />                    
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
                        AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="JabatanAgensi_ID"
                        DataSourceID="SqlDataSourceGrid"
                        CssClass="table table-bordered" PagerStyle-CssClass="pgr"
                        AlternatingRowStyle-CssClass="alt" >
                        <AlternatingRowStyle CssClass="alt" />
                        <Columns>
                            <asp:BoundField DataField="JabatanAgensi_ID" HeaderText="ID" InsertVisible="False"
                                ReadOnly="True" SortExpression="JabatanAgensi_ID"  />
                            <asp:BoundField DataField="JabatanAgensi_Description" HeaderText="Jabatan / Agensi"
                                SortExpression="JabatanAgensi_Description"  />
                            <asp:BoundField DataField="JabatanAgensi_Remarks" HeaderText="Catatan"
                                SortExpression="JabatanAgensi_Remarks" />
        
                            <asp:TemplateField HeaderText="Jenis">
                                <ItemTemplate>
                                    <asp:Label ID="Label1" runat="server" Text='<%# If(Eval("JabatanAgensi_Type") = "J", "Jabatan", If(Eval("JabatanAgensi_Type") = "L", "Agensi", "")) %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>                            

                            <asp:CheckBoxField DataField="JabatanAgensi_IsActive" HeaderText="Aktif?" SortExpression="JabatanAgensi_IsActive" />
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
        SelectCommand="SELECT * from LESEN_JabatanAgensi WHERE 1=1 ORDER BY JabatanAgensi_ID"        
        DeleteCommand="Update LESEN_JabatanAgensi set JabatanAgensi_IsActive = 0 WHERE JabatanAgensi_ID = @JabatanAgensi_ID">
        <DeleteParameters>
                    <asp:ControlParameter ControlID="GridView1" DefaultValue="" Name="JabatanAgensi_ID" PropertyName="SelectedValue" /> 
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

</asp:Content>

