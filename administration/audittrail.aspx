<%@ Page Title="" Language="VB" MasterPageFile="~/MAsterMenu.master" AutoEventWireup="false" CodeFile="audittrail.aspx.vb" Inherits="html_administration_audittrail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">

        <!-- Select2 -->
    <link rel="stylesheet" href="/assets/plugins/select2/css/select2.min.css">
    <link rel="stylesheet" href="/assets/plugins/select2-bootstrap4-theme/select2-bootstrap4.min.css"> 
    <link rel="stylesheet" href="/assets/plugins/jquery-ui/jquery-ui.css">   
    <!-- Theme style -->
    <link rel="stylesheet" href="/assets/dist/css/adminlte.min.css">

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">

    <section class="content-header">
        <div class="container-fluid">

        

            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0 text-dark">Log Sistem</h1>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <%--<li class="breadcrumb-item"><a href="#">Site Management</a></li>
                        <li class="breadcrumb-item active">Audit Trail</li>--%>
                        <%= GlobalClass.writeBreadcrumb(Request.QueryString("p_Id"), Request.QueryString("m_Id"), Session.Item("sessionSystemId")) %>
                    </ol>
                </div>
                <!-- /.col -->
            </div>
            <!-- /.row -->
        </div>
    </section>

    <section class="content">
        <div class="container-fluid">

            <div class="card">

                <div class="row">
                    <div class="col-md-6">

                        <div class="card-body">
                            <div class="form-group row">
                                <label for="inputEmail3" class="col-sm-4 col-form-label">Modul </label>
                                <div class="col-sm-6">
                                    <asp:DropDownList ID="ddlModule" runat="server" AutoPostBack="True" DataSourceID="SqlDataSource2" DataTextField="AT_Module" CssClass="form-control" DataValueField="AT_Module"></asp:DropDownList>
                                </div>
                            </div>

                            <div class="form-group row">
                                <label for="inputEmail3" class="col-sm-4 col-form-label">Akiviti </label>
                                <div class="col-sm-6">
                                    <asp:DropDownList ID="ddlAction" runat="server" AutoPostBack="True" DataSourceID="SqlDataSource3" DataTextField="AT_Action" CssClass="form-control" DataValueField="AT_Action"></asp:DropDownList>
                                </div>
                            </div>

                            <div class="form-group row">
                                <label class="col-sm-4 col-form-label">ID Pengguna </label>
                                <div class="col-sm-6">
                                    <asp:TextBox ID="usernameSearchTextBox" autocomplete="off" runat="server" CssClass="form-control"  Width="250px" AutoPostBack="True"></asp:TextBox>                
                                </div>

                            </div>

                        </div>

                    </div>

                    <div class="col-md-6">

                        <div class="card-body">

                            <div class="form-group row">
                                <label class="col-sm-4 col-form-label">Tarikh Mula </label>
                                <div class="col-sm-6">
                                    <asp:TextBox ID="dateSearchTextBoxFrom" autocomplete="off" runat="server" CssClass="datepicker form-control"  Width="120px" AutoPostBack="True"></asp:TextBox>                
                                </div>

                            </div>

                            <div class="form-group row">

                                <label class="col-sm-4 col-form-label">Tarikh Akhir </label>
                                <div class="col-sm-6">
                                    <asp:TextBox ID="dateSearchTextBoxTo" autocomplete="off" runat="server" CssClass="datepicker form-control"  Width="120px" AutoPostBack="True"></asp:TextBox>                
                                </div>
                            </div>

                            <div class="form-group row">
                                <label class="col-sm-4 col-form-label">Tajuk </label>
                                <div class="col-sm-6">
                                    <asp:TextBox ID="titleSearchTextBox" autocomplete="off" runat="server" CssClass="form-control"  Width="250px" AutoPostBack="True"></asp:TextBox>                
                                </div>

                            </div>

                        </div>

                    </div>
                </div>

                <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" SelectCommand="SELECT * FROM (SELECT '' AS AT_Module UNION ALL SELECT AT_Module FROM [TBL_AUDITTRAIL]) a GROUP BY AT_Module order by a.AT_Module"></asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" SelectCommand="SELECT * FROM (SELECT '' AS AT_Action UNION ALL SELECT AT_Action FROM [TBL_AUDITTRAIL]) a GROUP BY AT_Action order by a.AT_Action"></asp:SqlDataSource>

            </div>

                <!-- Default box -->
                <div class="card">
                    <div class="card-header">
                        <%--<h3 class="card-title">Operating Center</h3>--%>

                        <div class="card-tools">
                            <button type="button" class="btn btn-tool" data-card-widget="collapse" data-toggle="tooltip" title="Collapse">
                                <i class="fas fa-minus"></i>
                            </button>
                            <%--                    <button type="button" class="btn btn-tool" data-card-widget="remove" data-toggle="tooltip" title="Remove">
                                <i class="fas fa-times"></i>
                            </button>--%>
                        </div>
                    </div>
                    <div class="card-body">

                        <asp:GridView ID="GridView1" runat="server" AllowPaging="True"
                            AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="AT_Id"
                            DataSourceID="SqlDataSource1" EnableModelValidation="True"
                            CssClass="table table-bordered" PagerStyle-CssClass="pgr"
                            AlternatingRowStyle-CssClass="alt" PageSize="30" Width="100%" >
                            <Columns>
                                <asp:BoundField DataField="AT_Id" HeaderText="AT_Id" InsertVisible="False"
                                    ReadOnly="True" SortExpression="AT_Id" Visible="False" />
                                <asp:BoundField DataField="AT_UserId" HeaderText="ID"
                                    SortExpression="AT_UserId" />
                                <asp:BoundField DataField="AT_UserName" HeaderText="Pengguna"
                                    SortExpression="AT_UserName" />
                                <asp:BoundField DataField="AT_IP" HeaderText="Alamat IP"
                                    SortExpression="AT_IP" />
                                <asp:BoundField DataField="AT_Action" HeaderText="Aktiviti"
                                    SortExpression="AT_Action" />
                                <asp:BoundField DataField="AT_Module" HeaderText="Modul"
                                    SortExpression="AT_Module" />
                                <asp:BoundField DataField="AT_Title" HeaderText="Tajuk"
                                    SortExpression="AT_Title" />
                                <asp:BoundField DataField="AT_datetime" HeaderText="Tarikh / Masa"
                                    SortExpression="AT_datetime" />
                            </Columns>
                        </asp:GridView>

                    </div>
                </div>

                <asp:SqlDataSource ID="SqlDataSource1" runat="server"
                    ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                    SelectCommand="SELECT * FROM [TBL_AUDITTRAIL] 
        WHERE AT_Module LIKE '%' + @ddlModule +'%' and AT_Action LIKE '%' + @ddlAction +'%'
        and convert(date,AT_datetime,103) between convert(date,@dateFrom,103) and convert(date,@dateTo,103) 
        and AT_UserName like '%' + @userName +'%'
        and AT_Title like '%' + @titleName +'%'
        ORDER BY AT_datetime DESC">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="ddlModule" DefaultValue="%%" Name="ddlModule"
                            PropertyName="SelectedValue" />
                        <asp:ControlParameter ControlID="ddlAction" DefaultValue="%%" Name="ddlAction"
                            PropertyName="SelectedValue" />
                        <asp:ControlParameter ControlID="dateSearchTextBoxFrom" DefaultValue="01/01/2000" Name="dateFrom"
                            PropertyName="Text" />
                        <asp:ControlParameter ControlID="dateSearchTextBoxTo" DefaultValue="31/12/9999" Name="dateTo"
                            PropertyName="Text" />
                        <asp:ControlParameter ControlID="usernameSearchTextBox" DefaultValue="%%" Name="userName"
                            PropertyName="Text" />
                        <asp:ControlParameter ControlID="titleSearchTextBox" DefaultValue="%%" Name="titleName"
                            PropertyName="Text" />
                    </SelectParameters>
                </asp:SqlDataSource>

        </div>
    </section>


    <script>
       
        function pageLoad() {

                         
            $(function () {

                $('.datepicker').datepicker({                    
                    dateFormat: 'dd/mm/yy'                    
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

    <!-- End DatePicker -->

</asp:Content>

