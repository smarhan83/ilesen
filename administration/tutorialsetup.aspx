<%@ Page Title="" Language="VB" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="tutorialsetup.aspx.vb" Inherits="administration_checkrolltutorial" %>


<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadContent" runat="Server">

<style>
    .cssDisplayNone{
        display:none;
    }
</style>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="Server">
    <section class="content-header">
        <div class="container-fluid">

            

            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0 text-dark"><div runat="server" id="idWindowTitle"></div></h1>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">                        
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
    
            <label>Module</label> <br />
            <asp:DropDownList ID="ddlModule" runat="server"  AutoPostBack="True">
                <asp:ListItem Value="CR">Checkroll Module</asp:ListItem>
                <asp:ListItem Value="SR">Sundry Module</asp:ListItem>
                <asp:ListItem Value="HM">Harvesting Mobile App</asp:ListItem>
                <asp:ListItem Value="HA">Harvesting Module</asp:ListItem>
            </asp:DropDownList>
            <br /><br />

            <asp:FormView ID="FormView1" runat="server" DataKeyNames="tutorial_ID" DataSourceID="SqlDataSourceForm" DefaultMode="Insert" Width="100%">
                <EditItemTemplate>
                    <!-- Map card -->
                    <div class="card card-warning">
                        <div class="card-header">
                            <h3 class="card-title"><div runat="server" id="idWindowTitle2">Update</div></h3>

                            <div class="card-tools">
                                <button type="button" class="btn btn-tool" data-card-widget="collapse"><i class="fas fa-minus"></i></button>
                            </div>
                        </div>
                        <!-- /.card-header -->
                        <div class="card-body">
                            <div class="row">
                                  <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Seq No.</label>
                                        <asp:TextBox Text='<%# Bind("tutorial_seqNo") %>' TextMode="number" placeholder="Seq No" runat="server" ID="tutorial_seqNoTextBox" CssClass="form-control"/>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" CssClass="text-danger" runat="server" ControlToValidate="tutorial_seqNoTextBox" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="updateForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </div>

                                    <div class="form-group">
                                        <label>Tutorial Name</label>
                                        <asp:TextBox Text='<%# Bind("tutorial_Name") %>' placeholder="Tutorial Name" runat="server" ID="tutorial_NameTextBox" CssClass="form-control" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" CssClass="text-danger" runat="server" ControlToValidate="tutorial_NameTextBox" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="updateForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </div>


                                                                        
                                </div>

                               <div class="col-md-6">

                                    <div class="form-group">
                                        <label>Video Filename</label>    
                                        <i>(Video Path : <%=pathUrlVideo %>)</i>                                  
                                        <asp:TextBox Text='<%# Bind("tutorial_FilenameVideo") %>' placeholder="Example : empTutorial.mp4" runat="server" ID="tutorial_FilenameVideoTextBox" CssClass="form-control"/>
                                    </div>

                                    <div class="form-group">
                                        <label>PDF Filename</label>                                        
                                        <i>(Video Path : <%=pathUrlPdf %>)</i>                                      
                                        <asp:TextBox Text='<%# Bind("tutorial_FilenamePdf") %>' placeholder="Example : empTutorial.pdf" runat="server" ID="tutorial_FilenamePdfTextBox" CssClass="form-control"/>
                                    </div>
                                    
                                </div>
              

                        

                            </div>
                        </div>                        
                        <!-- /.card-body -->
                        <div class="card-footer">
                            <asp:LinkButton runat="server" Text="Update" CommandName="Update" ID="UpdateButton" CausesValidation="True" CssClass-="btn btn-warning" ValidationGroup="updateForm" />&nbsp;<asp:LinkButton runat="server" Text="Cancel" CommandName="Cancel" ID="UpdateCancelButton" CausesValidation="False" CssClass-="btn btn-default" />
                        </div>
                    </div>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <!-- Map card -->
                    <div class="card card-primary">
                        <div class="card-header">
                            <h3 class="card-title"><div runat="server" id="idWindowTitle3">Insert</div></h3>

                            <div class="card-tools">
                                <button type="button" class="btn btn-tool" data-card-widget="collapse"><i class="fas fa-minus"></i></button>
                            </div>
                        </div>
                        <!-- /.card-header -->
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">

                                    <div class="form-group">
                                        <label>Seq No.</label>
                                        <asp:TextBox Text='<%# Bind("tutorial_seqNo") %>' TextMode="number" placeholder="Seq No" runat="server" ID="tutorial_seqNoTextBox" CssClass="form-control"/>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" CssClass="text-danger" runat="server" ControlToValidate="tutorial_seqNoTextBox" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="updateForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </div>

                                    <div class="form-group">
                                        <label>Tutorial Name</label>
                                        <asp:TextBox Text='<%# Bind("tutorial_Name") %>' placeholder="Tutorial Name" runat="server" ID="tutorial_NameTextBox" CssClass="form-control" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" CssClass="text-danger" runat="server" ControlToValidate="tutorial_NameTextBox" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="updateForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                    </div>
                                                                        
                                </div>

                                <div class="col-md-6">
  
                                    <div class="form-group">
                                        <label>Video Filename</label>    
                                        <i>(Video Path : <%=pathUrlVideo %>)</i>                                  
                                        <asp:TextBox Text='<%# Bind("tutorial_FilenameVideo") %>' placeholder="Example : empTutorial.mp4" runat="server" ID="tutorial_FilenameVideoTextBox" CssClass="form-control"/>
                                    </div>

                                    <div class="form-group">
                                        <label>PDF Filename</label>                                        
                                        <i>(Video Path : <%=pathUrlPdf %>)</i>                                      
                                        <asp:TextBox Text='<%# Bind("tutorial_FilenamePdf") %>' placeholder="Example : empTutorial.pdf" runat="server" ID="tutorial_FilenamePdfTextBox" CssClass="form-control"/>
                                    </div>
                                    
                                </div>
              

                        

                            </div>
                        </div>
                        <!-- /.card-body -->
                        <div class="card-footer">
                            <asp:LinkButton runat="server" Text="Insert" CommandName="Insert" ValidationGroup="updateForm" ID="InsertButton" CausesValidation="True" CssClass-="btn btn-primary" />&nbsp;<asp:LinkButton runat="server" Text="Cancel" CommandName="Cancel" ID="InsertCancelButton" CausesValidation="False" CssClass-="btn btn-default" />
                        </div>
                        
                    </div>
                </InsertItemTemplate>
            </asp:FormView>
            <asp:Label ID="MessageLabel" runat="server" ></asp:Label>
            <asp:SqlDataSource runat="server" ID="SqlDataSourceForm" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' 
                InsertCommand="INSERT INTO TBL_TUTORIAL (tutorial_seqNo, tutorial_Name, tutorial_Module,tutorial_FilenameVideo,tutorial_FilenamePdf, CreatorID,CreatedDt,LastModID,LastModDt) 
                VALUES (@tutorial_seqNo, @tutorial_Name, @tutorial_Module,@tutorial_FilenameVideo,@tutorial_FilenamePdf, @sessionUsersId, GETDATE(),@sessionUsersId,getdate())" 
                SelectCommand="SELECT * FROM TBL_TUTORIAL WHERE tutorial_ID = @tutorial_ID" 
                UpdateCommand="UPDATE TBL_TUTORIAL SET tutorial_seqNo = @tutorial_seqNo,tutorial_Name=@tutorial_Name,tutorial_FilenameVideo=@tutorial_FilenameVideo,tutorial_FilenamePdf=@tutorial_FilenamePdf,  LastModID = @sessionUsersId, LastModDt = GETDATE() WHERE (tutorial_ID = @tutorial_ID)">
                <InsertParameters>

                    <asp:SessionParameter DefaultValue="0" Name="sessionUsersId" SessionField="sessionUsersId" />

                    <asp:Parameter Name="tutorial_seqNo" />
                    <asp:Parameter Name="tutorial_Name" />

                    <asp:ControlParameter ControlID="ddlModule" DefaultValue="0" Name="tutorial_Module" PropertyName="SelectedValue" />
                    <asp:Parameter Name="tutorial_FilenameVideo" />
                    <asp:Parameter Name="tutorial_FilenamePdf" />

                </InsertParameters>
                <SelectParameters>
                    <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedValue" Name="tutorial_ID"></asp:ControlParameter>
                </SelectParameters>
                <UpdateParameters>

                    <asp:SessionParameter DefaultValue="0" Name="sessionUsersId" SessionField="sessionUsersId" />
                    <asp:Parameter Name="tutorial_ID" />
                    <asp:Parameter Name="tutorial_seqNo" />
                    
                    <asp:Parameter Name="tutorial_Name" />
                    <asp:Parameter Name="tutorial_Module" />
                    <asp:Parameter Name="tutorial_FilenameVideo" />
                    <asp:Parameter Name="tutorial_FilenamePdf" />
                    
                </UpdateParameters>
            </asp:SqlDataSource>

            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-body">
                            <%--# START FILTER - set SortExpression at GridView as fieldname & add WHERE 1=1 at SqlDataSource - SelectCommand #--%>
                            <div class="row" runat="server" visible="true">
                                <div class="col-md-10">
                                    <div id="pnlFilter" runat="server" class="row"></div>
                                </div>
                                <div class="col-md-2">
                                    <div class="form-group">
                                        <asp:Button ID="btnSearch" runat="server" CssClass="btn bg-purple color-palette" Text="Search" />
                                        <asp:Button ID="btnReset" CssClass="btn btn-default" runat="server" Text="Reset" />
                                    </div>
                                </div>
                            </div>
                            <%--# END FILTER #--%>
                            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="tutorial_ID" DataSourceID="SqlDataSourceGrid" CssClass="table table-bordered" AllowSorting="True">
                                <Columns>
                                    <asp:BoundField DataField="tutorial_seqNo" HeaderText="No." />
                                    <asp:BoundField DataField="tutorial_Name" HeaderText="Tutorial Name" SortExpression="tutorial_Name" />
<%--                                    <asp:TemplateField HeaderText="Status" >
                                        <EditItemTemplate>
                                            <asp:CheckBox runat="server" Checked='<%# Bind("BankStatus") %>' ID="CheckBox1"></asp:CheckBox>
                                        </EditItemTemplate>
                                        <ItemTemplate>
                                            <%# IIf(Eval("BankStatus").ToString().Equals("True"), "Active", "Inactive") %>
                                        </ItemTemplate>
                                    </asp:TemplateField>--%>
                                    <asp:TemplateField ShowHeader="False">
                                        <ItemTemplate>
                                            <asp:HyperLink ID="hlVideo" runat="server" NavigateUrl='<%# pathUrlVideo + Eval("tutorial_FilenameVideo") %>' visible='<%# If(IsDBNull(Eval("tutorial_FilenameVideo")), False, If(Eval("tutorial_FilenameVideo") <> "", True, False)) %>' CssClass="btn bg-purple color-palette" Target="_blank">View Video</asp:HyperLink>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <asp:TemplateField ShowHeader="False">
                                        <ItemTemplate>
                                            
                                            <asp:HyperLink ID="hlPdf" runat="server" NavigateUrl='<%# pathUrlPdf + Eval("tutorial_FilenamePdf") %>' visible='<%# If(IsDBNull(Eval("tutorial_FilenamePdf")), False, If(Eval("tutorial_FilenamePdf") <> "", True, False)) %>' CssClass="btn btn-warning btn-sm" Target="_blank">View PDF</asp:HyperLink>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <asp:TemplateField ShowHeader="False">
                                        <ItemTemplate>
                                            <asp:LinkButton runat="server" Text="Edit" CommandName="Select" CausesValidation="False" ID="LinkButton1" CssClass="btn btn-warning btn-sm" ></asp:LinkButton>&nbsp<asp:LinkButton runat="server" Text="Delete" CommandName="Delete" CausesValidation="False" ID="LinkButton2" CssClass="btn btn-danger btn-sm" OnClientClick="return confirm('Are you sure to delete?');"></asp:LinkButton>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="tutorial_FilenameVideo" HeaderText="Video Filename"  >
                                    <HeaderStyle CssClass="cssDisplayNone" />
                                    <ItemStyle CssClass="cssDisplayNone" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="tutorial_FilenamePdf" HeaderText="Pdf Filename"  >
                                    <HeaderStyle CssClass="cssDisplayNone" />
                                    <ItemStyle CssClass="cssDisplayNone" />
                                    </asp:BoundField>
                                </Columns>
                            </asp:GridView>
                            <asp:SqlDataSource runat="server" ID="SqlDataSourceGrid" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                SelectCommand="SELECT * FROM TBL_TUTORIAL WHERE 1=1 and tutorial_Module = @ddlModule "
                                DeleteCommand="delete from TBL_TUTORIAL where tutorial_ID = @tutorial_ID">
                                <DeleteParameters>
                                    <asp:ControlParameter ControlID="GridView1" DefaultValue="0" Name="tutorial_ID" PropertyName="SelectedValue" />
                                </DeleteParameters>
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="ddlModule" DefaultValue="0" Name="ddlModule" PropertyName="SelectedValue" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </div>
                    </div>
                </div>
            </div>
            <!--/.row -->
        </div>

        <asp:SqlDataSource runat="server" ID="SqlDataSourceState" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' SelectCommand="SELECT NULL as CountryStateID,'-- Please Select -' as StateDesc union all SELECT CountryStateID,StateDesc FROM CountryState where status = 1 order by StateDesc"></asp:SqlDataSource>
        
    </section>

</asp:Content>

