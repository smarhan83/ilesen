<%@ Page Title="" Language="VB" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="ugm2.aspx.vb" Inherits="administration_ugm2" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadContent" runat="Server">
    <!-- Select2 -->
<%--    <link rel="stylesheet" href="/assets/plugins/select2/css/select2.min.css">
    <link rel="stylesheet" href="/assets/plugins/select2-bootstrap4-theme/select2-bootstrap4.min.css">
    <link rel="stylesheet" href="/assets/plugins/jquery-ui/jquery-ui.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="/assets/dist/css/adminlte.min.css">--%>
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
            
            <asp:FormView ID="FormView1" runat="server" DataKeyNames="UGM_Id"
                DataSourceID="SqlDataSource2" DefaultMode="Insert" Width="100%">
                <EditItemTemplate>

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
                                        <label>Parent Menu</label>
                                        <asp:DropDownList ID="DropDownList1" runat="server"
                                            DataSourceID="SqlDataSource1" DataTextField="UGM_Name"
                                            DataValueField="UGM_Id"
                                            SelectedValue='<%# Bind("UGM_ParentId") %>' CssClass="form-control select2">
                                        </asp:DropDownList>
                                        <asp:SqlDataSource ID="SqlDataSource1" runat="server"
                                            ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                                            SelectCommand="SELECT UGM_Id, UGM_ParentId, UGM_name, UGM_ContentId, UGM_Filename, UGM_SeqNo, UGM_level FROM (SELECT 0 AS UGM_Id, 0 AS UGM_ParentId, 'None' AS UGM_name, 0 AS UGM_ContentId, '' AS UGM_Filename, 10 AS UGM_SeqNo, 1 AS UGM_level UNION ALL SELECT UGM_Id, UGM_ParentId, (CASE WHEN TBL_USER_GROUPMODULE.UGM_Level = 1 THEN UGM_name WHEN TBL_USER_GROUPMODULE.UGM_Level = 2 THEN '- ' + UGM_name WHEN TBL_USER_GROUPMODULE.UGM_Level = 3 THEN '-- ' + UGM_name WHEN TBL_USER_GROUPMODULE.UGM_Level = 4 THEN '--- ' + UGM_name WHEN TBL_USER_GROUPMODULE.UGM_Level = 5 THEN '---- ' + UGM_name WHEN TBL_USER_GROUPMODULE.UGM_Level = 6 THEN '----- ' + UGM_name WHEN TBL_USER_GROUPMODULE.UGM_Level = 7 THEN '------ ' + UGM_name WHEN TBL_USER_GROUPMODULE.UGM_Level = 8 THEN '------- ' + UGM_name WHEN TBL_USER_GROUPMODULE.UGM_Level = 9 THEN '-------- ' + UGM_name WHEN TBL_USER_GROUPMODULE.UGM_Level = 10 THEN '--------- ' + UGM_name ELSE '' END) AS UGM_name, UGM_ContentId, UGM_Filename, UGM_SeqNo, UGM_Level FROM TBL_USER_GROUPMODULE) AS a ORDER BY UGM_SeqNo"></asp:SqlDataSource>
                                    </div>
                                    <br />
                                    <div class="form-group">
                                        <label>Menu Name</label>
                                        <asp:TextBox ID="Menu_NameTextBox" runat="server"
                                            Text='<%# Bind("UGM_Name") %>' CssClass="form-control" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server"
                                            ControlToValidate="Menu_NameTextBox" ErrorMessage="*" ValidationGroup="frmEdit"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="form-group">
                                        <label>Level</label>
                                        <asp:DropDownList ID="DropDownList6" runat="server"
                                            SelectedValue='<%# Bind("UGM_Level") %>' CssClass="form-control">
                                            <asp:ListItem>1</asp:ListItem>
                                            <asp:ListItem>2</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                    <div class="form-group">
                                        <label>Content Menu</label>
                                        <asp:DropDownList ID="DropDownList4" runat="server"
                                            DataSourceID="SqlDataSource2" DataTextField="Content_Name"
                                            DataValueField="Content_Id" SelectedValue='<%# Bind("UGM_ContentId") %>' CssClass="form-control">
                                        </asp:DropDownList>
                                        <asp:SqlDataSource ID="SqlDataSource2" runat="server"
                                            ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" SelectCommand="SELECT *  FROM (SELECT 0 AS Content_Id,'' AS Content_Name,'' AS Content_Title,'' AS Content_Body, 0 AS Content_CreatedBy,'' AS Content_CreatedDate,0 AS Content_PublishedBy, '' AS Content_PublishedDate,0 AS Content_ModifiedBy,'' AS Content_ModifiedDate, 0 AS Content_IsNews,0 AS Content_IsPublish UNION ALL SELECT Content_Id,Content_Name,Content_Title,Content_Body, Content_CreatedBy,Content_CreatedDate,Content_PublishedBy, Content_PublishedDate,Content_ModifiedBy,Content_ModifiedDate, Content_IsNews,Content_IsPublish FROM [TBL_CONTENT] WHERE Content_IsPublish = 1) a ORDER BY Content_Name ASC"></asp:SqlDataSource>
                                    </div>
                                <div class="form-group">
                                        <label>System Menu</label>
                                        <asp:DropDownList ID="DropDownList8" runat="server"
                                            DataSourceID="SqlDataSource3" DataTextField="system_Name"
                                            DataValueField="system_Id"
                                            SelectedValue='<%# Bind("UGM_SystemId") %>' CssClass="form-control">                          
                                        </asp:DropDownList>
                                    <asp:SqlDataSource ID="SqlDataSource3" runat="server"
                                            ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" SelectCommand=
                                        "SELECT *  FROM TBL_SYSTEM "></asp:SqlDataSource>

                                    </div>
                                </div>
                            <!-- /.col -->
                            <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Menu Filename</label>
                                        <asp:TextBox ID="Menu_FilenameTextBox" runat="server"
                                            Text='<%# Bind("UGM_Filename") %>' CssClass="form-control" />
                                        &nbsp;(Default is pages.aspx)

                                    </div>
                                    <div class="form-group">
                                        <label>Menu Icon</label>
                                        <asp:TextBox ID="UGM_Menu_Icon" runat="server"
                                            Text='<%# Bind("UGM_Menu_Icon") %>' CssClass="form-control" />
                                        <asp:HyperLink ID="HyperLink1" NavigateUrl="https://fontawesome.com/v4.7.0/icons/" Target="_blank"  runat="server">Font Awesome Icon (e.g.: fa-dot-circle)</asp:HyperLink>
                                    </div>
                                    <div class="form-group">
                                        <label>Seq No</label>
                                        <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("UGM_SeqNo") %>' CssClass="form-control"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                                            ControlToValidate="TextBox2" ErrorMessage="*" ValidationGroup="frmEdit"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="form-group">
                                        <div class="form-check">
                                            <asp:CheckBox ID="CheckBox2" runat="server" Checked='<%# Bind("UGM_IsPublish") %>' CssClass="form-check-input" />
                                            <label>Is Publish</label>
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
                        <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" CommandName="Update" Text="Update" ValidationGroup="frmEdit" CssClass="btn btn-warning" />
                        &nbsp;<asp:LinkButton ID="UpdateCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" CssClass="btn btn-default" />
                    </div>
                    </div>
                </EditItemTemplate>
                <InsertItemTemplate>
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
                                        <label>Parent Menu</label>
                                        <asp:DropDownList ID="DropDownList2" runat="server"
                                            DataSourceID="SqlDataSource1" DataTextField="UGM_Name"
                                            DataValueField="UGM_Id" SelectedValue='<%# Bind("UGM_ParentId") %>' CssClass="form-control select2">
                                        </asp:DropDownList>
                                        <asp:SqlDataSource ID="SqlDataSource1" runat="server"
                                            ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" SelectCommand="SELECT UGM_Id, UGM_ParentId, UGM_name, UGM_ContentId, UGM_Filename, UGM_SeqNo, UGM_level FROM (SELECT 0 AS UGM_Id, 0 AS UGM_ParentId, 'None' AS UGM_name, 0 AS UGM_ContentId, '' AS UGM_Filename, 10 AS UGM_SeqNo, 1 AS UGM_level UNION ALL SELECT UGM_Id, UGM_ParentId, (CASE WHEN TBL_USER_GROUPMODULE.UGM_Level = 1 THEN UGM_name WHEN TBL_USER_GROUPMODULE.UGM_Level = 2 THEN '- ' + UGM_name WHEN TBL_USER_GROUPMODULE.UGM_Level = 3 THEN '-- ' + UGM_name WHEN TBL_USER_GROUPMODULE.UGM_Level = 4 THEN '--- ' + UGM_name WHEN TBL_USER_GROUPMODULE.UGM_Level = 5 THEN '---- ' + UGM_name WHEN TBL_USER_GROUPMODULE.UGM_Level = 6 THEN '----- ' + UGM_name WHEN TBL_USER_GROUPMODULE.UGM_Level = 7 THEN '------ ' + UGM_name WHEN TBL_USER_GROUPMODULE.UGM_Level = 8 THEN '------- ' + UGM_name WHEN TBL_USER_GROUPMODULE.UGM_Level = 9 THEN '-------- ' + UGM_name WHEN TBL_USER_GROUPMODULE.UGM_Level = 10 THEN '--------- ' + UGM_name ELSE '' END) AS UGM_name, UGM_ContentId, UGM_Filename, UGM_SeqNo, UGM_Level FROM TBL_USER_GROUPMODULE) AS a ORDER BY UGM_SeqNo"></asp:SqlDataSource>
                                    </div>
                                <br />
                                    <div class="form-group">
                                        <label>Menu Name</label>
                                        <asp:TextBox ID="Menu_NameTextBox" Placeholder="Menu Name" runat="server"
                                            Text='<%# Bind("UGM_Name") %>' CssClass="form-control" />
                                        <asp:RequiredFieldValidator CssClass="text-danger" ID="RequiredFieldValidator3" runat="server"
                                            ControlToValidate="Menu_NameTextBox" ErrorMessage="This Field is required!"
                                            ValidationGroup="frmInsert"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="form-group">
                                        <label>Level</label>
                                        <asp:DropDownList ID="DropDownList5" runat="server"
                                            SelectedIndex='<%# Bind("UGM_Level") %>'
                                            SelectedValue='<%# Bind("UGM_Level") %>' CssClass="form-control">
                                            <asp:ListItem Selected="True">1</asp:ListItem>
                                            <asp:ListItem>2</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                    <div class="form-group">
                                        <label>Content Menu</label>
                                        <asp:DropDownList ID="DropDownList3" runat="server"
                                            DataSourceID="SqlDataSource2" DataTextField="Content_Name"
                                            DataValueField="Content_Id" SelectedValue='<%# Bind("UGM_ContentId") %>' CssClass="form-control">
                                        </asp:DropDownList>
                                        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" SelectCommand="SELECT *  FROM (SELECT 0 AS Content_Id,'' AS Content_Name,'' AS Content_Title,'' AS Content_Body, 0 AS Content_CreatedBy,'' AS Content_CreatedDate,0 AS Content_PublishedBy, '' AS Content_PublishedDate,0 AS Content_ModifiedBy,'' AS Content_ModifiedDate, 0 AS Content_IsNews,0 AS Content_IsPublish UNION ALL SELECT Content_Id,Content_Name,Content_Title,Content_Body, Content_CreatedBy,Content_CreatedDate,Content_PublishedBy, Content_PublishedDate,Content_ModifiedBy,Content_ModifiedDate, Content_IsNews,Content_IsPublish FROM [TBL_CONTENT] WHERE Content_IsPublish = 1) a ORDER BY Content_Name ASC"></asp:SqlDataSource>
                                    </div>
                                <div class="form-group">
                                    <label>System Menu</label>
                                    <asp:DropDownList ID="DropDownList8" runat="server"
                                            DataSourceID="SqlDataSource3" DataTextField="system_Name"
                                            DataValueField="system_Id"
                                            SelectedValue='<%# Bind("UGM_SystemId") %>' CssClass="form-control">                          
                                        </asp:DropDownList>
                                    <asp:SqlDataSource ID="SqlDataSource3" runat="server"
                                            ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" SelectCommand=
                                        "SELECT *  FROM TBL_SYSTEM "></asp:SqlDataSource>
                                </div>
                                </div>
                                <!-- /.col -->
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Menu Filename</label>
                                        <asp:TextBox ID="Menu_FilenameTextBox" runat="server"
                                            Text='<%# Bind("UGM_Filename") %>' CssClass="form-control" />
                                        &nbsp;(Default is pages.aspx)
                                    </div>
                                    <div class="form-group">
                                        <label>Menu Icon</label>
                                        <asp:TextBox ID="UGM_Menu_Icon" Placeholder="Menu Icon" runat="server"
                                            Text='<%# Bind("UGM_Menu_Icon") %>' CssClass="form-control" />
                                        <asp:HyperLink ID="HyperLink1" NavigateUrl="https://fontawesome.com/v4.7.0/icons/" Target="_blank"  runat="server">Font Awesome Icon (e.g.: fa-dot-circle)</asp:HyperLink>
                                    </div>
                                    <div class="form-group">
                                        <label>Seq No</label>
                                        <asp:TextBox ID="TextBox1" runat="server" Placeholder="Seq No" Text='<%# Bind("UGM_SeqNo") %>' CssClass="form-control"></asp:TextBox>
                                        <asp:RequiredFieldValidator CssClass="text-danger" ID="RequiredFieldValidator2" runat="server"
                                            ControlToValidate="TextBox1" ErrorMessage="This Field is required!" ValidationGroup="frmInsert"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="form-group">
                                        <div class="form-check">
                                            <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("UGM_IsPublish") %>' CssClass="form-check-input" />
                                            <label>Is Publish</label>
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
                            <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" Text="Insert" ValidationGroup="frmInsert" CssClass="btn btn-primary" />
                            &nbsp;
                                <asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" CssClass="btn btn-default" />
                        </div>
                    </div>
                </InsertItemTemplate>
            </asp:FormView>

            <asp:SqlDataSource ID="SqlDataSource2" runat="server"
                ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" InsertCommand="INSERT INTO TBL_USER_GROUPMODULE(UGM_ParentId, UGM_Name, UGM_ContentId, UGM_Filename, UGM_SeqNo, UGM_Level, UGM_Menu_Icon, UGM_IsPublish, UGM_SystemId) VALUES (@UGM_ParentId, @UGM_Name, @UGM_ContentId, @UGM_Filename, @UGM_SeqNo, @UGM_Level, @UGM_Menu_Icon, @UGM_IsPublish, @UGM_SystemId)"
                SelectCommand="SELECT * FROM [TBL_USER_GROUPMODULE] WHERE UGM_Id = @UGM_Id"
                UpdateCommand="UPDATE TBL_USER_GROUPMODULE SET UGM_ParentId = @UGM_ParentId, UGM_Name = @UGM_Name, UGM_ContentId = @UGM_ContentId, UGM_Filename = @UGM_Filename, UGM_SeqNo = @UGM_SeqNo, UGM_Level = @UGM_Level, UGM_Menu_Icon = @UGM_Menu_Icon, UGM_IsPublish = @UGM_IsPublish, UGM_SystemId = @UGM_SystemId WHERE (UGM_Id = @UGM_Id)">
                <InsertParameters>
                    <asp:Parameter Name="UGM_ParentId" />
                    <asp:Parameter Name="UGM_Name" />
                    <asp:Parameter Name="UGM_ContentId" />
                    <asp:Parameter Name="UGM_Filename" />
                    <asp:Parameter Name="UGM_SeqNo" />
                    <asp:Parameter Name="UGM_Level" />
                    <asp:Parameter Name="UGM_Menu_Icon" />
                    <asp:Parameter Name="UGM_IsPublish"></asp:Parameter>
                    <asp:Parameter Name="UGM_SystemId"></asp:Parameter>
                </InsertParameters>
                <SelectParameters>
                    <asp:ControlParameter ControlID="GridView1" Name="UGM_Id"
                        PropertyName="SelectedValue" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="UGM_ParentId" />
                    <asp:Parameter Name="UGM_Name" />
                    <asp:Parameter Name="UGM_ContentId" />
                    <asp:Parameter Name="UGM_Filename" />
                    <asp:Parameter Name="UGM_SeqNo" />
                    <asp:Parameter Name="UGM_Level" />
                    <asp:Parameter Name="UGM_Menu_Icon" />
                    <asp:Parameter Name="UGM_IsPublish" />
                    <asp:Parameter Name="UGM_SystemId"></asp:Parameter>
                    <asp:Parameter Name="UGM_Id"></asp:Parameter>
                </UpdateParameters>
            </asp:SqlDataSource>

            <div class="card">
                <div class="card-body" style="overflow-x: auto;">
                        <asp:DropDownList ID="ddlSystemId" runat="server"
                        DataSourceID="sdsSystem" DataTextField="system_Name"
                        DataValueField="system_Id"
                        CssClass="form-control" AutoPostBack="True">                          
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="sdsSystem" runat="server"
                        ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" SelectCommand=
                        "SELECT *  FROM TBL_SYSTEM "></asp:SqlDataSource>

                        <asp:GridView ID="GridView1" runat="server" 
                        AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="UGM_Id"
                        DataSourceID="SqlDataSource1"
                        CssClass="table table-bordered" PagerStyle-CssClass="pgr"
                        AlternatingRowStyle-CssClass="alt" >
                        <AlternatingRowStyle CssClass="alt" />
                        <Columns>
                            <asp:BoundField DataField="UGM_Id" HeaderText="UGM_Id" InsertVisible="False"
                                ReadOnly="True" SortExpression="UGM_Id" Visible="False" />
                            <asp:BoundField DataField="UGM_ParentId" HeaderText="Parent Menu"
                                SortExpression="UGM_ParentId" Visible="False" />
                            <asp:BoundField DataField="UGM_SeqNo" HeaderText="Seq No"
                                SortExpression="UGM_SeqNo" />
                            <asp:BoundField DataField="parentMenu" HeaderText="Parent Menu"
                                SortExpression="parentMenu" />
                            <asp:BoundField DataField="UGM_Name" HeaderText="UGM Name"
                                SortExpression="UGM_Name" />
                            <asp:BoundField DataField="UGM_ContentId" HeaderText="Content Menu"
                                SortExpression="UGM_ContentId" Visible="False" />

                            <asp:BoundField DataField="UGM_Filename" HeaderText="Menu Filename"
                                SortExpression="UGM_Filename" />
                            <asp:CheckBoxField DataField="UGM_IsPublish" HeaderText="Is Publish" SortExpression="UGM_IsPublish" />
                            <asp:TemplateField ShowHeader="False">
                                <ItemTemplate>
                                    <asp:LinkButton runat="server" Text="Edit" CommandName="Select" CausesValidation="False" ID="LinkButton2" CssClass="btn btn-warning btn-sm"></asp:LinkButton>
                                    <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False"
                                        CommandName="Delete" Text="Delete" OnClientClick="return confirm('Are you sure to delete it?');" CssClass="btn btn-danger btn-sm"></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <PagerStyle CssClass="pgr" />
                    </asp:GridView>                    
                </div>
            </div>

        </div>
    </section>

    <asp:SqlDataSource ID="SqlDataSource1" runat="server"
        ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
        SelectCommand="SELECT menu2.UGM_Id, menu2.UGM_ParentId, menu2.UGM_Name, menu2.UGM_ContentId, menu2.UGM_Filename, menu2.UGM_SeqNo, menu2.UGM_Level, menu2.UGM_IsPublish, menu2.UGM_CreatedBy, menu2.UGM_CreatedDate, menu1.UGM_Name AS parentMenu FROM TBL_USER_GROUPMODULE AS menu2 LEFT OUTER JOIN TBL_USER_GROUPMODULE AS menu1 ON menu2.UGM_ParentId = menu1.UGM_Id LEFT OUTER JOIN TBL_CONTENT AS ctn ON menu2.UGM_ContentId = ctn.Content_Id 
WHERE menu2.UGM_SystemId = @systemID
ORDER BY menu2.UGM_SeqNo"
        UpdateCommand="UPDATE TBL_TBL_USER_GROUPMODULE SET UGM_ParentId = @UGM_ParentId, UGM_Name = @UGM_Name, UGM_ContentId = @UGM_ContentId, UGM_Filename = @UGM_Filename WHERE (UGM_Id = @UGM_Id)"
        DeleteCommand="DELETE FROM TBL_USER_GROUPMODULE WHERE UGM_Id = @UGM_Id">
        <DeleteParameters>
            <asp:Parameter Name="UGM_Id" />
        </DeleteParameters>
        <SelectParameters>
            <asp:ControlParameter ControlID="ddlSystemId" Name="systemID" PropertyName="SelectedValue" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="UGM_ParentId" />
            <asp:Parameter Name="UGM_Name" />
            <asp:Parameter Name="UGM_ContentId" />
            <asp:Parameter Name="UGM_Filename" />
            <asp:Parameter Name="UGM_Id" />
        </UpdateParameters>
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

