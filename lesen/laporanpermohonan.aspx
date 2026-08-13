<%@ Page Title="" Language="VB" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="laporanpermohonan.aspx.vb" Inherits="laporanpermohonan" %>

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
            
            <div class="card card-warning">
                <div class="card-header">
                    <h3 class="card-title"><div runat="server" id="idWindowTitle2">Jana Laporan Permohonan</div></h3>

                    <div class="card-tools">
                        <button type="button" class="btn btn-tool" data-card-widget="collapse"><i class="fas fa-minus"></i></button>
                    </div>
                </div>
                <!-- /.card-header -->
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Jenis Laporan</label>
                                <asp:DropDownList ID="ddlReport" runat="server" CssClass="form-control select2">
                                    <asp:ListItem Value="1">Lesen Perniagaan Permit</asp:ListItem>
                                    <asp:ListItem Value="2">Lesen Pembatalan</asp:ListItem>
                                    <asp:ListItem Value="3">Belum Dapat Ulasan Inspektorat</asp:ListItem>
                                    <asp:ListItem Value="4">Lesen Sepanduk</asp:ListItem>
                                    <asp:ListItem Value="5">Lesen Pasar Lambak</asp:ListItem>
                                    <asp:ListItem Value="6">Lesen Anjing</asp:ListItem>
                                    <asp:ListItem Value="7">Lesen Penjaja</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card-footer">
                    <asp:LinkButton ID="btnReport" runat="server" Text="Jana" CssClass="btn btn-warning" />
                </div>
            </div>
        </div>
    </section>

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

