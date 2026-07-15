<%@ Page Title="" Language="VB" MasterPageFile="~/MasterMenu.master" AutoEventWireup="false" CodeFile="empinfo.aspx.vb" Inherits="humanResources_empinfo" %>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="Server">
    <script src="/assets/plugins/jquery/jquery.min.js"></script>
    <script type="text/javascript">
        function verifyFile() {
            var maxFileSize = 2048000; // 4MB -> 4 * 1024 * 1024
            var fileUpload = $('#MainContent_FormView1_FileUpload1');

            if (fileUpload.val() == '') {
                return false;
            }
            else {
                if (fileUpload[0].files[0].size < maxFileSize) {
                    //$('#btnUpload').prop('disabled', false);
                    return true;
                } else {
                    $('#MainContent_FormView1_lblUploadMsg').text('Your file was not uploaded because it exceeds the 2 MB size limit.');
                    return false;
                }
            }
        }

        $(function () {
            $('#File1').bind('change', function () {
                alert('test');
                var maxFileSize = 1024000; // 1MB -> 1000 * 1024
                var fileSize;

                // If current browser is IE < 10, use ActiveX
                if (isIE() && isIE() < 10) {
                    var filePath = this.value;
                    if (filePath != '') {
                        var AxFSObj = new ActiveXObject("Scripting.FileSystemObject");
                        var AxFSObjFile = AxFSObj.getFile(filePath);
                        fileSize = AxFSObjFile.size;
                    }
                } else {
                    // IE >= 10 or not IE

                    if (this.value != '') {
                        fileSize = this.files[0].size;
                    }
                }

                if (fileSize < maxFileSize) {
                    // Enable submit button and remove any error message
                    $('#btnUpload').prop('disabled', false);
                    $('#lblUploadMsg').text('');
                } else {
                    // Disable submit button and show error message
                    $('#btnUpload').prop('disabled', true);
                    $('#lblUploadMsg').text('File too big !');
                }
            });
        });

        // Check if the browser is Internet Explorer
        function isIE() {
            var myNav = navigator.userAgent.toLowerCase();
            return (myNav.indexOf('msie') != -1) ? parseInt(myNav.split('msie')[1]) : false;
        }
    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">

    <section class="content-header">
        <div class="container-fluid">

            <asp:ScriptManager ID="ScriptManager1" runat="server">
            </asp:ScriptManager>

            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0 text-dark">Employee's Information</h1>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <%--<li class="breadcrumb-item"><a href="#">Human Resources</a></li>
                        <li class="breadcrumb-item active">Employee's Information</li>--%>
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

            <asp:FormView ID="FormView1" runat="server" DataKeyNames="objectId" DataSourceID="SqlDataSourceForm" DefaultMode="Insert" Width="100%">
                <EditItemTemplate>
                    <div class="col-12">
                        <div class="card card-warning card-tabs">
                            <div class="card-header p-0 pt-1">
                                <ul class="nav nav-tabs" id="custom-tabs-two-tab" role="tablist">
                                    <%--                            <li class="pt-2 px-3">
                                        <h3 class="card-title">Insert Employee Information</h3>
                                    </li>--%>
                                    <li class="nav-item">
                                        <a class="nav-link active" id="custom-tabs-two-home-tab" data-toggle="pill" href="#custom-tabs-two-home" role="tab" aria-controls="custom-tabs-two-home" aria-selected="true">Employee Information</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" id="custom-tabs-two-profile-tab" data-toggle="pill" href="#custom-tabs-two-profile" role="tab" aria-controls="custom-tabs-two-profile" aria-selected="false">Employee</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" id="custom-tabs-two-messages-tab" data-toggle="pill" href="#custom-tabs-two-messages" role="tab" aria-controls="custom-tabs-two-messages" aria-selected="false">Contact Details</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" id="custom-tabs-two-worker-tab" data-toggle="pill" href="#custom-tabs-two-worker" role="tab" aria-controls="custom-tabs-two-worker" aria-selected="false">Worker Details</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" id="custom-tabs-two-settings-tab" data-toggle="pill" href="#custom-tabs-two-settings" role="tab" aria-controls="custom-tabs-two-settings" aria-selected="false">Statutory Membership</a>
                                    </li>
                                </ul>
                            </div>
                            <div class="card-body">
                                <div class="tab-content" id="custom-tabs-two-tabContent">
                                    <div class="tab-pane fade show active" id="custom-tabs-two-home" role="tabpanel" aria-labelledby="custom-tabs-two-home-tab">
                                        <div class="row">
                                            <div class="col-md-12" style="text-align: left">
                                                <div class="form-group">
                                                    <asp:Image ID="Image1" runat="server" ImageUrl='<%# Bind("PHOTO") %>' Height="150" />
                                                    <br />
                                                    <asp:FileUpload ID="FileUpload1" runat="server" CssClass="btn btn-default" accept=".jpg, .jpeg, .png, .bmp, .gif, .tiff" />
                                                    <asp:Button ID="btnUpload" Text="Upload" runat="server" OnClick="UploadFile" OnClientClick="return verifyFile()" CssClass="btn bg-purple color-palette" />
                                                    <asp:Label ID="lblUploadMsg" runat="server" Text="" ForeColor="Red"></asp:Label>
                                                    <br />
                                                    <br />
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Salutation</label>
                                                    <asp:DropDownList Text='<%# Bind("TITLE_objectId") %>' CssClass="form-control" ID="DropDownList1" runat="server" DataSourceID="SqlDataSourceTitle" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                                    <asp:HiddenField ID="HiddenField1" runat="server" Value='<%# Eval("objectId") %>' />

                                                </div>
                                                <div class="form-group">
                                                    <label>Alias</label>
                                                    <asp:TextBox Text='<%# Bind("NICKNAME") %>' runat="server" ID="NICKNAMETextBox" CssClass="form-control" />
                                                </div>
                                                <!-- /.form-group -->
                                                <div class="form-group">
                                                    <label>Name</label>
                                                    <asp:TextBox Text='<%# Bind("NAME") %>' runat="server" ID="NAMETextBox" CssClass="form-control" />
                                                </div>
                                                <!-- /.form-group -->
                                                <div class="form-group">
                                                    <label>Marital Status</label>
                                                    <asp:DropDownList Text='<%# Bind("MARITAL_objectId") %>' CssClass="form-control" ID="MARITAL_objectIdTextBox" runat="server" DataSourceID="SqlDataSourceMarital" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                                </div>
                                                <!-- /.form-group -->
                                                <div class="form-group">
                                                    <label>Dialect</label>
                                                    <asp:DropDownList Text='<%# Bind("DIALECT_objectId") %>' CssClass="form-control" ID="DropDownList2" runat="server" DataSourceID="SqlDataSourceDialect" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                                </div>
                                                <!-- /.form-group -->
                                                <div class="form-group">
                                                    <label>Citizenship</label>
                                                    <asp:DropDownList Text='<%# Bind("CITIZENSHIP_objectId") %>' CssClass="form-control" ID="DropDownList3" runat="server" DataSourceID="SqlDataSourceCitizen" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                                </div>
                                                <!-- /.form-group -->
                                                <div class="form-group">
                                                    <label>Religion</label>
                                                    <asp:DropDownList Text='<%# Bind("RELIGION_objectId") %>' CssClass="form-control" ID="DropDownList4" runat="server" DataSourceID="SqlDataSourceReligion" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                                </div>
                                                <!-- /.form-group -->

                                                <!-- /.form-group -->
                                                <div class="form-group">
                                                    <label>Status</label>
                                                    <asp:RadioButtonList Text='<%# Bind("IsActive") %>' ID="RadioButtonList1" runat="server">
                                                        <asp:ListItem Value="True"> Active</asp:ListItem>
                                                        <asp:ListItem Value="False"> Suspend</asp:ListItem>
                                                    </asp:RadioButtonList>
                                                </div>
                                            </div>
                                            <!-- /.col -->
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Operating Center</label>
                                                    <asp:DropDownList Text='<%# Bind("OC_objectId") %>' Enabled="false" CssClass="form-control" ID="DropDownList6" runat="server" DataSourceID="SqlDataSourceOcs" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                                </div>
                                                <!-- /.form-group -->
                                                <div class="form-group">
                                                    <label>Emp Code</label>
                                                    <asp:TextBox Text='<%# Bind("EMPCODE") %>' runat="server" ID="EMPCODETextBox" CssClass="form-control" />
                                                </div>
                                                <!-- /.form-group -->
                                                <div class="form-group">
                                                    <label>New IC</label>
                                                    <asp:TextBox Text='<%# Bind("NRICNEW") %>' runat="server" ID="NRICNEWTextBox" CssClass="form-control" />
                                                </div>
                                                <!-- /.form-group -->
                                                <div class="form-group">
                                                    <label>IC Colour</label>
                                                    <asp:DropDownList Text='<%# Bind("NRICCOLOR_objectId") %>' CssClass="form-control" ID="DropDownList7" runat="server" DataSourceID="SqlDataSourceIcColor" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                                </div>
                                                <!-- /.form-group -->

                                                <!-- /.form-group -->
                                                <div class="form-group">
                                                    <label>DOB</label>
                                                    <asp:TextBox Text='<%# Bind("DOB") %>' runat="server" ID="DOBTextBox" CssClass="form-control" data-inputmask-alias="datetime" data-inputmask-inputformat="yyyy-mm-dd" data-mask />
                                                </div>
                                                <!-- /.form-group -->
                                                <div class="form-group">
                                                    <label>Place of Birth</label>
                                                    <asp:TextBox Text='<%# Bind("POB") %>' runat="server" ID="POBTextBox" CssClass="form-control" />
                                                </div>
                                                <div class="form-group">
                                                    <label>Race</label>
                                                    <asp:DropDownList Text='<%# Bind("RACE_objectId") %>' CssClass="form-control" ID="DropDownList5" runat="server" DataSourceID="SqlDataSourceRace" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                                </div>
                                                <!-- /.form-group -->
                                                <div class="form-group">
                                                    <label>Gender</label>
                                                    <asp:RadioButtonList Text='<%# Bind("SEX") %>' ID="SEXCheckBox" runat="server">
                                                        <asp:ListItem Value="True"> Male</asp:ListItem>
                                                        <asp:ListItem Value="False"> Female</asp:ListItem>
                                                    </asp:RadioButtonList>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="tab-pane fade" id="custom-tabs-two-profile" role="tabpanel" aria-labelledby="custom-tabs-two-profile-tab">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Employee Type</label>
                                                    <asp:DropDownList Text='<%# Bind("EMPTYPE_objectId") %>' CssClass="form-control" ID="DropDownList8" runat="server" DataSourceID="SqlDataSourceEmpType" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                                </div>
                                                <div class="form-group">
                                                    <label>Date Join</label>
                                                    <asp:TextBox Text='<%# Bind("DATEJOIN") %>' runat="server" ID="DATEJOINTextBox" CssClass="form-control" data-inputmask-alias="datetime" data-inputmask-inputformat="yyyy-mm-dd" data-mask />
                                                </div>
                                                <div class="form-group">
                                                    <label>Work Status</label>
                                                    <asp:DropDownList Text='<%# Bind("WORKSTATUS_objectId") %>' CssClass="form-control" ID="DropDownList9" runat="server" DataSourceID="SqlDataSourceworkStatus" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                                </div>
                                                <!-- /.form-group -->
                                                <%--                                        <div class="form-group">
                                                    <label>Field Div</label>
                                                    <asp:DropDownList Text='<%# Bind("DIVISION_objectId") %>' CssClass="form-control" ID="DropDownList10" runat="server" DataSourceID="SqlDataSourceDiv" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                                </div>--%>
                                                <div class="form-group">
                                                    <label>Daily Rate</label>
                                                    <asp:TextBox Text='<%# Bind("DAILYRATE") %>' runat="server" ID="DAILYRATETextBox" CssClass="form-control" />
                                                </div>
                                                <!-- /.form-group -->
                                            </div>
                                            <!-- /.col -->
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Rate Type Code</label>
                                                    <asp:TextBox Text='<%# Bind("ISLOADER") %>' runat="server" ID="ISLOADERTextBox" CssClass="form-control" />
                                                </div>
                                                <div class="form-group">
                                                    <label>Salary</label>
                                                    <asp:TextBox Text='<%# Bind("SALARY") %>' runat="server" ID="SALARYTextBox" CssClass="form-control" />
                                                </div>
                                                <div class="form-group">
                                                    <label>Remarks</label>
                                                    <asp:TextBox Text='<%# Bind("REMARKS") %>' runat="server" ID="REMARKSTextBox" CssClass="form-control" />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="tab-pane fade" id="custom-tabs-two-messages" role="tabpanel" aria-labelledby="custom-tabs-two-messages-tab">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Address1</label>
                                                    <asp:TextBox Text='<%# Bind("ADDRESS1") %>' runat="server" ID="ADDRESS1TextBox" CssClass="form-control" />
                                                </div>
                                                <!-- /.form-group -->
                                                <div class="form-group">
                                                    <label>Address2</label>
                                                    <asp:TextBox Text='<%# Bind("ADDRESS2") %>' runat="server" ID="ADDRESS2TextBox" CssClass="form-control" />
                                                </div>
                                                <!-- /.form-group -->
                                                <div class="form-group">
                                                    <label>Address3</label>
                                                    <asp:TextBox Text='<%# Bind("ADDRESS3") %>' runat="server" ID="ADDRESS3TextBox" CssClass="form-control" />
                                                </div>
                                                <!-- /.form-group -->
                                                <div class="form-group">
                                                    <label>Postcode</label>
                                                    <asp:TextBox Text='<%# Bind("POSTCODE") %>' runat="server" ID="POSTCODETextBox" CssClass="form-control" />
                                                </div>
                                                <div class="form-group">
                                                    <label>City</label>
                                                    <asp:DropDownList Text='<%# Bind("CITY_objectId") %>' CssClass="form-control" ID="DropDownList11" runat="server" DataSourceID="SqlDataSourceCity" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                                </div>
                                                <div class="form-group">
                                                    <label>State</label>
                                                    <asp:DropDownList Text='<%# Bind("STATE_objectId") %>' CssClass="form-control" ID="DropDownList12" runat="server" DataSourceID="SqlDataSourceState" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                                </div>

                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Home Tel</label>
                                                    <asp:TextBox Text='<%# Bind("HOMETEL") %>' runat="server" ID="HOMETELTextBox" CssClass="form-control" />
                                                </div>
                                                <div class="form-group">
                                                    <label>Office Tel</label>
                                                    <asp:TextBox Text='<%# Bind("OFFICETEL") %>' runat="server" ID="OFFICETELTextBox" CssClass="form-control" />
                                                </div>
                                                <div class="form-group">
                                                    <label>Mobile Tel</label>
                                                    <asp:TextBox Text='<%# Bind("MOBILETEL") %>' runat="server" ID="MOBILETELTextBox" CssClass="form-control" />
                                                </div>
                                                <div class="form-group">
                                                    <label>Extension</label>
                                                    <asp:TextBox Text='<%# Bind("EXTNO") %>' runat="server" ID="EXTNOTextBox" CssClass="form-control" />
                                                </div>
                                                <div class="form-group">
                                                    <label>Email</label>
                                                    <asp:TextBox Text='<%# Bind("EMAIL") %>' runat="server" ID="EMAILTextBox" CssClass="form-control" />
                                                </div>
                                                <div class="form-group">
                                                    <label>Country</label>
                                                    <asp:DropDownList Text='<%# Bind("COUNTRY_objectId") %>' CssClass="form-control" ID="DropDownList13" runat="server" DataSourceID="SqlDataSourceCountry" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="tab-pane fade" id="custom-tabs-two-worker" role="tabpanel" aria-labelledby="custom-tabs-two-worker-tab">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Labour CAT</label>
                                                    <asp:DropDownList Text='<%# Bind("LABOURCAT_objectId") %>' CssClass="form-control" ID="LabourCAT" runat="server" DataSourceID="SqlDataSourceLbrCat" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                                </div>
                                                <div class="form-group">
                                                    <label>Labour CD</label>
                                                    <asp:DropDownList Text='<%# Bind("LABOURCD_objectId") %>' ID="LabourCD" CssClass="form-control" runat="server" DataSourceID="SqlDataSourceLbrCode" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                                </div>
                                                <div class="form-group">
                                                    <label>Mandore</label>
                                                    <asp:RadioButtonList Text='<%# Bind("MANDORE") %>' ID="Mandore" runat="server">
                                                        <asp:ListItem Value="True"> Mandore</asp:ListItem>
                                                        <asp:ListItem Value="False" Selected="True"> Non-Mandore</asp:ListItem>
                                                    </asp:RadioButtonList>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Job Status</label>
                                                    <asp:DropDownList Text='<%# Bind("JOBSTATUS_objectId") %>' ID="JobStatus" CssClass="form-control" runat="server" DataSourceID="SqlDataSourceJobStatus" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                                </div>
                                                <div class="form-group">
                                                    <label>QTR Status</label>
                                                    <asp:DropDownList Text='<%# Bind("QTRSTATUS_objectId") %>' ID="QTRStatus" CssClass="form-control" runat="server" DataSourceID="SqlDataSourceQtrStatus" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                                </div>
                                                <div class="form-group">
                                                    <label>Gang no</label>
                                                    <asp:DropDownList Text='<%# Bind("GANGNO_objectId") %>' ID="Gangno" CssClass="form-control" runat="server" DataSourceID="SqlDataSourceGangno" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="tab-pane fade" id="custom-tabs-two-settings" role="tabpanel" aria-labelledby="custom-tabs-two-settings-tab">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Socso Status</label>
                                                    <asp:TextBox Text='<%# Bind("SOCSOSTATUS") %>' runat="server" ID="SOCSOSTATUSTextBox" CssClass="form-control" />
                                                </div>
                                                <div class="form-group">
                                                    <label>Socso No</label>
                                                    <asp:TextBox Text='<%# Bind("SOCSONO") %>' runat="server" ID="SOCSONOTextBox" CssClass="form-control" />
                                                </div>
                                                <div class="form-group">
                                                    <label>Income Tax No</label>
                                                    <asp:TextBox Text='<%# Bind("INCOMETAXNO") %>' runat="server" ID="INCOMETAXNOTextBox" CssClass="form-control" />
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>EPF Status</label>
                                                    <asp:TextBox Text='<%# Bind("EPFSTATUS") %>' runat="server" ID="EPFSTATUSTextBox" CssClass="form-control" />
                                                </div>
                                                <div class="form-group">
                                                    <label>EPF No</label>
                                                    <asp:TextBox Text='<%# Bind("EPFNO") %>' runat="server" ID="EPFNOTextBox" CssClass="form-control" />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- /.card-body -->
                            <div class="card-footer">
                                <asp:LinkButton runat="server" Text="Update" CommandName="Update" ID="UpdateButton" CausesValidation="True" CssClass="btn btn-warning" />&nbsp;<asp:LinkButton runat="server" Text="Cancel" CommandName="Cancel" ID="UpdateCancelButton" CausesValidation="False" CssClass="btn btn-default" />
                            </div>
                        </div>
                    </div>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <div class="col-12">
                        <div class="card card-primary card-tabs">
                            <div class="card-header p-0 pt-1">
                                <ul class="nav nav-tabs" id="custom-tabs-two-tab" role="tablist">
                                    <%--                            <li class="pt-2 px-3">
                                        <h3 class="card-title">Insert Employee Information</h3>
                                    </li>--%>
                                    <li class="nav-item">
                                        <a class="nav-link active" id="custom-tabs-two-home-tab" data-toggle="pill" href="#custom-tabs-two-home" role="tab" aria-controls="custom-tabs-two-home" aria-selected="true">Employee Information</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" id="custom-tabs-two-profile-tab" data-toggle="pill" href="#custom-tabs-two-profile" role="tab" aria-controls="custom-tabs-two-profile" aria-selected="false">Employee</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" id="custom-tabs-two-messages-tab" data-toggle="pill" href="#custom-tabs-two-messages" role="tab" aria-controls="custom-tabs-two-messages" aria-selected="false">Contact Details</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" id="custom-tabs-two-worker-tab" data-toggle="pill" href="#custom-tabs-two-worker" role="tab" aria-controls="custom-tabs-two-worker" aria-selected="false">Worker Details</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" id="custom-tabs-two-settings-tab" data-toggle="pill" href="#custom-tabs-two-settings" role="tab" aria-controls="custom-tabs-two-settings" aria-selected="false">Statutory Membership</a>
                                    </li>
                                </ul>
                            </div>
                            <div class="card-body">
                                <div class="tab-content" id="custom-tabs-two-tabContent">
                                    <div class="tab-pane fade show active" id="custom-tabs-two-home" role="tabpanel" aria-labelledby="custom-tabs-two-home-tab">
                                        <div class="row">
                                            <div class="col-md-12" style="text-align: left">
                                                <div class="form-group">
                                                    <asp:Image ID="Image1" runat="server" ImageUrl='<%# Bind("PHOTO") %>' Height="150" />
                                                    <br />
                                                    <asp:FileUpload ID="FileUpload1" runat="server" CssClass="btn btn-default" accept=".jpg, .jpeg, .png, .bmp, .gif, .tiff" />
                                                    <asp:Button ID="btnUpload" Text="Upload" runat="server" OnClick="UploadFile" OnClientClick="return verifyFile()" CssClass="btn bg-purple color-palette" />
                                                    <asp:Label ID="lblUploadMsg" runat="server" Text="" ForeColor="Red"></asp:Label>
                                                    <br />
                                                    <br />
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Salutation</label>
                                                    <asp:DropDownList Text='<%# Bind("TITLE_objectId") %>' CssClass="form-control" ID="DropDownList1" runat="server" DataSourceID="SqlDataSourceTitle" DataTextField="name" DataValueField="id"></asp:DropDownList>

                                                </div>
                                                <div class="form-group">
                                                    <label>Alias</label>
                                                    <asp:TextBox Text='<%# Bind("NICKNAME") %>' runat="server" ID="NICKNAMETextBox" CssClass="form-control" />
                                                    <br />
                                                </div>
                                                <!-- /.form-group -->
                                                <div class="form-group">
                                                    <label>Name</label>
                                                    <asp:TextBox Text='<%# Bind("NAME") %>' runat="server" ID="NAMETextBox" CssClass="form-control" />
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" CssClass="text-danger" runat="server" ControlToValidate="NAMETextBox" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="insertForm"></asp:RequiredFieldValidator>
                                                </div>
                                                <!-- /.form-group -->
                                                <div class="form-group">
                                                    <label>Marital  Status</label>
                                                    <asp:DropDownList Text='<%# Bind("MARITAL_objectId") %>' CssClass="form-control" ID="MARITAL_objectIdTextBox" runat="server" DataSourceID="SqlDataSourceMarital" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator13" CssClass="text-danger" runat="server" ControlToValidate="MARITAL_objectIdTextBox" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="insertForm"></asp:RequiredFieldValidator>
                                                </div>
                                                <!-- /.form-group -->
                                                <div class="form-group">
                                                    <label>Dialect</label>
                                                    <asp:DropDownList Text='<%# Bind("DIALECT_objectId") %>' CssClass="form-control" ID="DropDownList2" runat="server" DataSourceID="SqlDataSourceDialect" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator14" CssClass="text-danger" runat="server" ControlToValidate="DropDownList2" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="insertForm"></asp:RequiredFieldValidator>
                                                    <br />
                                                </div>
                                                <!-- /.form-group -->
                                                <div class="form-group">
                                                    <label>Citizenship</label>
                                                    <asp:DropDownList Text='<%# Bind("CITIZENSHIP_objectId") %>' CssClass="form-control" ID="DropDownList3" runat="server" DataSourceID="SqlDataSourceCitizen" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator15" CssClass="text-danger" runat="server" ControlToValidate="DropDownList3" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="insertForm"></asp:RequiredFieldValidator>
                                                </div>
                                                <!-- /.form-group -->
                                                <div class="form-group">
                                                    <label>Religion</label>
                                                    <asp:DropDownList Text='<%# Bind("RELIGION_objectId") %>' CssClass="form-control" ID="DropDownList4" runat="server" DataSourceID="SqlDataSourceReligion" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator16" CssClass="text-danger" runat="server" ControlToValidate="DropDownList4" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="insertForm"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="form-group">
                                                    <label>Gender</label>
                                                    <asp:RadioButtonList Text='<%# Bind("SEX") %>' ID="SEXCheckBox" runat="server">
                                                        <asp:ListItem Value="True"> Male</asp:ListItem>
                                                        <asp:ListItem Value="False"> Female</asp:ListItem>
                                                    </asp:RadioButtonList>
                                                </div>
                                                <!-- /.form-group -->

                                                <!-- /.form-group -->
                                            </div>
                                            <!-- /.col -->
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Operating Center</label>
                                                    <asp:DropDownList Text='<%# Bind("OC_objectId") %>' Enabled="false" CssClass="form-control" ID="DropDownList6" runat="server" DataSourceID="SqlDataSourceOcs" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                                </div>
                                                <!-- /.form-group -->
                                                <div class="form-group">
                                                    <label>Emp Code</label>
                                                    <asp:TextBox Text='<%# Bind("EMPCODE") %>' runat="server" ID="EMPCODETextBox" CssClass="form-control" />
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" CssClass="text-danger" runat="server" ControlToValidate="EMPCODETextBox" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="insertForm"></asp:RequiredFieldValidator>
                                                </div>
                                                <!-- /.form-group -->
                                                <div class="form-group">
                                                    <label>New IC</label>
                                                    <asp:TextBox Text='<%# Bind("NRICNEW") %>' runat="server" ID="NRICNEWTextBox" CssClass="form-control" MaxLength="12" />
                                                    <br />
                                                </div>
                                                <!-- /.form-group -->
                                                <div class="form-group">
                                                    <label>IC Colour</label>
                                                    <asp:DropDownList Text='<%# Bind("NRICCOLOR_objectId") %>' CssClass="form-control" ID="DropDownList7" runat="server" DataSourceID="SqlDataSourceIcColor" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                                </div>
                                                <br />
                                                <!-- /.form-group -->

                                                <!-- /.form-group -->
                                                <div class="form-group">
                                                    <label>DOB</label>
                                                    <asp:TextBox Text='<%# Bind("DOB") %>' runat="server" ID="DOBTextBox" CssClass="form-control" data-inputmask-alias="datetime" data-inputmask-inputformat="yyyy-mm-dd" data-mask />
                                                </div>
                                                <br />
                                                <!-- /.form-group -->
                                                <div class="form-group">
                                                    <label>Place of Birth</label>
                                                    <asp:TextBox Text='<%# Bind("POB") %>' runat="server" ID="POBTextBox" CssClass="form-control" />
                                                </div>
                                                <br />
                                                <!-- /.form-group -->
                                                <div class="form-group">
                                                    <label>Race</label>
                                                    <asp:DropDownList Text='<%# Bind("RACE_objectId") %>' CssClass="form-control" ID="DropDownList5" runat="server" DataSourceID="SqlDataSourceRace" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator17" CssClass="text-danger" runat="server" ControlToValidate="DropDownList5" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="insertForm"></asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="tab-pane fade" id="custom-tabs-two-profile" role="tabpanel" aria-labelledby="custom-tabs-two-profile-tab">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Employee Type</label>
                                                    <asp:DropDownList Text='<%# Bind("EMPTYPE_objectId") %>' CssClass="form-control" ID="DropDownList8" runat="server" DataSourceID="SqlDataSourceEmpType" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" CssClass="text-danger" runat="server" ControlToValidate="DropDownList8" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="insertForm"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="form-group">
                                                    <label>Date Join</label>
                                                    <asp:TextBox Text='<%# Bind("DATEJOIN") %>' runat="server" ID="DATEJOINTextBox" CssClass="form-control" data-inputmask-alias="datetime" data-inputmask-inputformat="yyyy-mm-dd" data-mask />
                                                </div>
                                                <div class="form-group">
                                                    <label>Work Status</label>
                                                    <asp:DropDownList Text='<%# Bind("WORKSTATUS_objectId") %>' CssClass="form-control" ID="DropDownList9" runat="server" DataSourceID="SqlDataSourceworkStatus" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" CssClass="text-danger" runat="server" ControlToValidate="DropDownList9" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="insertForm"></asp:RequiredFieldValidator>
                                                </div>
                                                <!-- /.form-group -->
                                                <%--                                        <div class="form-group">
                                                    <label>Field Div</label>
                                                    <asp:DropDownList Text='<%# Bind("DIVISION_objectId") %>' CssClass="form-control" ID="DropDownList10" runat="server" DataSourceID="SqlDataSourceDiv" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                                </div>--%>
                                                <div class="form-group">
                                                    <label>Daily Rate</label>
                                                    <asp:TextBox Text='<%# Bind("DAILYRATE") %>' runat="server" ID="DAILYRATETextBox" CssClass="form-control" />
                                                </div>
                                                <!-- /.form-group -->
                                            </div>
                                            <!-- /.col -->
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Rate Type Code</label>
                                                    <asp:TextBox Text='<%# Bind("ISLOADER") %>' runat="server" ID="ISLOADERTextBox" CssClass="form-control" />
                                                    <br />
                                                </div>
                                                <div class="form-group">
                                                    <label>Salary</label>
                                                    <asp:TextBox Text='<%# Bind("SALARY") %>' runat="server" ID="SALARYTextBox" CssClass="form-control" />
                                                </div>
                                                <div class="form-group">
                                                    <label>Remarks</label>
                                                    <asp:TextBox Text='<%# Bind("REMARKS") %>' runat="server" ID="REMARKSTextBox" CssClass="form-control" />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="tab-pane fade" id="custom-tabs-two-messages" role="tabpanel" aria-labelledby="custom-tabs-two-messages-tab">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Address1</label>
                                                    <asp:TextBox Text='<%# Bind("ADDRESS1") %>' runat="server" ID="ADDRESS1TextBox" CssClass="form-control" />
                                                </div>
                                                <!-- /.form-group -->
                                                <div class="form-group">
                                                    <label>Address2</label>
                                                    <asp:TextBox Text='<%# Bind("ADDRESS2") %>' runat="server" ID="ADDRESS2TextBox" CssClass="form-control" />
                                                </div>
                                                <!-- /.form-group -->
                                                <div class="form-group">
                                                    <label>Address3</label>
                                                    <asp:TextBox Text='<%# Bind("ADDRESS3") %>' runat="server" ID="ADDRESS3TextBox" CssClass="form-control" />
                                                </div>
                                                <!-- /.form-group -->
                                                <div class="form-group">
                                                    <label>Postcode</label>
                                                    <asp:TextBox Text='<%# Bind("POSTCODE") %>' runat="server" ID="POSTCODETextBox" CssClass="form-control" />
                                                </div>
                                                <div class="form-group">
                                                    <label>City</label>
                                                    <asp:DropDownList Text='<%# Bind("CITY_objectId") %>' CssClass="form-control" ID="DropDownList11" runat="server" DataSourceID="SqlDataSourceCity" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" CssClass="text-danger" runat="server" ControlToValidate="DropDownList11" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="insertForm"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="form-group">
                                                    <label>State</label>
                                                    <asp:DropDownList Text='<%# Bind("STATE_objectId") %>' CssClass="form-control" ID="DropDownList12" runat="server" DataSourceID="SqlDataSourceState" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator6" CssClass="text-danger" runat="server" ControlToValidate="DropDownList12" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="insertForm"></asp:RequiredFieldValidator>
                                                </div>

                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Home Tel</label>
                                                    <asp:TextBox Text='<%# Bind("HOMETEL") %>' runat="server" ID="HOMETELTextBox" CssClass="form-control" />
                                                </div>
                                                <div class="form-group">
                                                    <label>Office Tel</label>
                                                    <asp:TextBox Text='<%# Bind("OFFICETEL") %>' runat="server" ID="OFFICETELTextBox" CssClass="form-control" />
                                                </div>
                                                <div class="form-group">
                                                    <label>Mobile Tel</label>
                                                    <asp:TextBox Text='<%# Bind("MOBILETEL") %>' runat="server" ID="MOBILETELTextBox" CssClass="form-control" />
                                                </div>
                                                <div class="form-group">
                                                    <label>Extension</label>
                                                    <asp:TextBox Text='<%# Bind("EXTNO") %>' runat="server" ID="EXTNOTextBox" CssClass="form-control" />
                                                </div>
                                                <div class="form-group">
                                                    <label>Email</label>
                                                    <asp:TextBox Text='<%# Bind("EMAIL") %>' runat="server" ID="EMAILTextBox" CssClass="form-control" />
                                                </div>
                                                <br />
                                                <div class="form-group">
                                                    <label>Country</label>
                                                    <asp:DropDownList Text='<%# Bind("COUNTRY_objectId") %>' CssClass="form-control" ID="DropDownList13" runat="server" DataSourceID="SqlDataSourceCountry" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator7" CssClass="text-danger" runat="server" ControlToValidate="DropDownList13" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="insertForm"></asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="tab-pane fade" id="custom-tabs-two-worker" role="tabpanel" aria-labelledby="custom-tabs-two-worker-tab">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Labour CAT</label>
                                                    <asp:DropDownList CssClass="form-control" ID="LabourCAT" runat="server" DataSourceID="SqlDataSourceLbrCat" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator8" CssClass="text-danger" runat="server" ControlToValidate="LabourCAT" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="insertForm"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="form-group">
                                                    <label>Labour CD</label>
                                                    <asp:DropDownList ID="LabourCD" CssClass="form-control" runat="server" DataSourceID="SqlDataSourceLbrCode" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator9" CssClass="text-danger" runat="server" ControlToValidate="LabourCD" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="insertForm"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="form-group">
                                                    <label>Mandore</label>
                                                    <asp:RadioButtonList Text='<%# Bind("SEX") %>' ID="Mandore" runat="server">
                                                        <asp:ListItem Value="True"> Mandore</asp:ListItem>
                                                        <asp:ListItem Value="False" Selected="True"> Non-Mandore</asp:ListItem>
                                                    </asp:RadioButtonList>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Job Status</label>
                                                    <asp:DropDownList ID="JobStatus" CssClass="form-control" runat="server" DataSourceID="SqlDataSourceJobStatus" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator10" CssClass="text-danger" runat="server" ControlToValidate="JobStatus" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="insertForm"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="form-group">
                                                    <label>QTR Status</label>
                                                    <asp:DropDownList ID="QTRStatus" CssClass="form-control" runat="server" DataSourceID="SqlDataSourceQtrStatus" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator11" CssClass="text-danger" runat="server" ControlToValidate="QTRStatus" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="insertForm"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="form-group">
                                                    <label>Gang no</label>
                                                    <asp:DropDownList ID="Gangno" CssClass="form-control" runat="server" DataSourceID="SqlDataSourceGangno" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator12" CssClass="text-danger" runat="server" ControlToValidate="Gangno" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="insertForm"></asp:RequiredFieldValidator>

                                                    <%--<asp:DropDownList Text='<%# Bind("MARITAL_objectId") %>' CssClass="form-control" ID="DropDownList10" runat="server" DataSourceID="SqlDataSourceMarital" DataTextField="name" DataValueField="id"></asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator18" CssClass="text-danger" runat="server" ControlToValidate="MARITAL_objectIdTextBox" ErrorMessage="This Field is required!" InitialValue="" ValidationGroup="insertForm"></asp:RequiredFieldValidator>--%>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="tab-pane fade" id="custom-tabs-two-settings" role="tabpanel" aria-labelledby="custom-tabs-two-settings-tab">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Socso Status</label>
                                                    <asp:TextBox Text='<%# Bind("SOCSOSTATUS") %>' runat="server" ID="SOCSOSTATUSTextBox" CssClass="form-control" />
                                                </div>
                                                <div class="form-group">
                                                    <label>Socso No</label>
                                                    <asp:TextBox Text='<%# Bind("SOCSONO") %>' runat="server" ID="SOCSONOTextBox" CssClass="form-control" />
                                                </div>
                                                <div class="form-group">
                                                    <label>Income Tax No</label>
                                                    <asp:TextBox Text='<%# Bind("INCOMETAXNO") %>' runat="server" ID="INCOMETAXNOTextBox" CssClass="form-control" />
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>EPF Status</label>
                                                    <asp:TextBox Text='<%# Bind("EPFSTATUS") %>' runat="server" ID="EPFSTATUSTextBox" CssClass="form-control" />
                                                </div>
                                                <div class="form-group">
                                                    <label>EPF No</label>
                                                    <asp:TextBox Text='<%# Bind("EPFNO") %>' runat="server" ID="EPFNOTextBox" CssClass="form-control" />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- /.card-body -->
                            <div class="card-footer">
                                <asp:LinkButton runat="server" Text="Insert" CommandName="Insert" ValidationGroup="insertForm" ID="InsertButton" CausesValidation="True" CssClass="btn btn-primary" />&nbsp;<asp:LinkButton runat="server" Text="Cancel" CommandName="Cancel" ID="InsertCancelButton" CausesValidation="False" CssClass="btn btn-default" />
                            </div>

                        </div>
                    </div>
                </InsertItemTemplate>
                <ItemTemplate>
                    objectId:
                    <asp:Label Text='<%# Eval("objectId") %>' runat="server" ID="objectIdLabel" /><br />
                    WORKERINFO_objectId:
                    <asp:Label Text='<%# Bind("WORKERINFO_objectId") %>' runat="server" ID="WORKERINFO_objectIdLabel" /><br />
                    OC_objectId:
                    <asp:Label Text='<%# Bind("OC_objectId") %>' runat="server" ID="OC_objectIdLabel" /><br />
                    DIVISION_objectId:
                    <asp:Label Text='<%# Bind("DIVISION_objectId") %>' runat="server" ID="DIVISION_objectIdLabel" /><br />
                    EMPCODE:
                    <asp:Label Text='<%# Bind("EMPCODE") %>' runat="server" ID="EMPCODELabel" /><br />
                    TITLE_objectId:
                    <asp:Label Text='<%# Bind("TITLE_objectId") %>' runat="server" ID="TITLE_objectIdLabel" /><br />
                    NAME:
                    <asp:Label Text='<%# Bind("NAME") %>' runat="server" ID="NAMELabel" /><br />
                    NICKNAME:
                    <asp:Label Text='<%# Bind("NICKNAME") %>' runat="server" ID="NICKNAMELabel" /><br />
                    ADDRESS1:
                    <asp:Label Text='<%# Bind("ADDRESS1") %>' runat="server" ID="ADDRESS1Label" /><br />
                    ADDRESS2:
                    <asp:Label Text='<%# Bind("ADDRESS2") %>' runat="server" ID="ADDRESS2Label" /><br />
                    ADDRESS3:
                    <asp:Label Text='<%# Bind("ADDRESS3") %>' runat="server" ID="ADDRESS3Label" /><br />
                    POSTCODE:
                    <asp:Label Text='<%# Bind("POSTCODE") %>' runat="server" ID="POSTCODELabel" /><br />
                    CITY_objectId:
                    <asp:Label Text='<%# Bind("CITY_objectId") %>' runat="server" ID="CITY_objectIdLabel" /><br />
                    STATE_objectId:
                    <asp:Label Text='<%# Bind("STATE_objectId") %>' runat="server" ID="STATE_objectIdLabel" /><br />
                    COUNTRY_objectId:
                    <asp:Label Text='<%# Bind("COUNTRY_objectId") %>' runat="server" ID="COUNTRY_objectIdLabel" /><br />
                    HOMETEL:
                    <asp:Label Text='<%# Bind("HOMETEL") %>' runat="server" ID="HOMETELLabel" /><br />
                    OFFICETEL:
                    <asp:Label Text='<%# Bind("OFFICETEL") %>' runat="server" ID="OFFICETELLabel" /><br />
                    EXTNO:
                    <asp:Label Text='<%# Bind("EXTNO") %>' runat="server" ID="EXTNOLabel" /><br />
                    MOBILETEL:
                    <asp:Label Text='<%# Bind("MOBILETEL") %>' runat="server" ID="MOBILETELLabel" /><br />
                    EMAIL:
                    <asp:Label Text='<%# Bind("EMAIL") %>' runat="server" ID="EMAILLabel" /><br />
                    NRICNEW:
                    <asp:Label Text='<%# Bind("NRICNEW") %>' runat="server" ID="NRICNEWLabel" /><br />
                    NRICCOLOR_objectId:
                    <asp:Label Text='<%# Bind("NRICCOLOR_objectId") %>' runat="server" ID="NRICCOLOR_objectIdLabel" /><br />
                    SEX:
                    <asp:CheckBox Checked='<%# Bind("SEX") %>' runat="server" ID="SEXCheckBox" Enabled="false" /><br />
                    DOB:
                    <asp:Label Text='<%# Bind("DOB") %>' runat="server" ID="DOBLabel" /><br />
                    POB:
                    <asp:Label Text='<%# Bind("POB") %>' runat="server" ID="POBLabel" /><br />
                    RELIGION_objectId:
                    <asp:Label Text='<%# Bind("RELIGION_objectId") %>' runat="server" ID="RELIGION_objectIdLabel" /><br />
                    RACE_objectId:
                    <asp:Label Text='<%# Bind("RACE_objectId") %>' runat="server" ID="RACE_objectIdLabel" /><br />
                    DIALECT_objectId:
                    <asp:Label Text='<%# Bind("DIALECT_objectId") %>' runat="server" ID="DIALECT_objectIdLabel" /><br />
                    MARITAL_objectId:
                    <asp:Label Text='<%# Bind("MARITAL_objectId") %>' runat="server" ID="MARITAL_objectIdLabel" /><br />
                    CITIZENSHIP_objectId:
                    <asp:Label Text='<%# Bind("CITIZENSHIP_objectId") %>' runat="server" ID="CITIZENSHIP_objectIdLabel" /><br />
                    DATEJOIN:
                    <asp:Label Text='<%# Bind("DATEJOIN") %>' runat="server" ID="DATEJOINLabel" /><br />
                    SOCSOSTATUS:
                    <asp:Label Text='<%# Bind("SOCSOSTATUS") %>' runat="server" ID="SOCSOSTATUSLabel" /><br />
                    SOCSONO:
                    <asp:Label Text='<%# Bind("SOCSONO") %>' runat="server" ID="SOCSONOLabel" /><br />
                    INCOMETAXNO:
                    <asp:Label Text='<%# Bind("INCOMETAXNO") %>' runat="server" ID="INCOMETAXNOLabel" /><br />
                    EPFSTATUS:
                    <asp:Label Text='<%# Bind("EPFSTATUS") %>' runat="server" ID="EPFSTATUSLabel" /><br />
                    EPFNO:
                    <asp:Label Text='<%# Bind("EPFNO") %>' runat="server" ID="EPFNOLabel" /><br />
                    SALARY:
                    <asp:Label Text='<%# Bind("SALARY") %>' runat="server" ID="SALARYLabel" /><br />
                    WORKSTATUS_objectId:
                    <asp:Label Text='<%# Bind("WORKSTATUS_objectId") %>' runat="server" ID="WORKSTATUS_objectIdLabel" /><br />
                    PHOTO:
                    <asp:Label Text='<%# Bind("PHOTO") %>' runat="server" ID="PHOTOLabel" /><br />
                    KLKUSER_objectId:
                    <asp:Label Text='<%# Bind("KLKUSER_objectId") %>' runat="server" ID="KLKUSER_objectIdLabel" /><br />
                    ISLOADER:
                    <asp:Label Text='<%# Bind("ISLOADER") %>' runat="server" ID="ISLOADERLabel" /><br />
                    REMARKS:
                    <asp:Label Text='<%# Bind("REMARKS") %>' runat="server" ID="REMARKSLabel" /><br />
                    DAILYRATE:
                    <asp:Label Text='<%# Bind("DAILYRATE") %>' runat="server" ID="DAILYRATELabel" /><br />
                    createdAt:
                    <asp:Label Text='<%# Bind("createdAt") %>' runat="server" ID="createdAtLabel" /><br />
                    updatedAt:
                    <asp:Label Text='<%# Bind("updatedAt") %>' runat="server" ID="updatedAtLabel" /><br />
                    Is Active:
                    <asp:CheckBox Checked='<%# Bind("IsActive") %>' runat="server" ID="IsActiveCheckBox" Enabled="false" /><br />
                    WDR:
                    <asp:Label Text='<%# Bind("WDR") %>' runat="server" ID="WDRLabel" /><br />
                    <asp:LinkButton runat="server" Text="Edit" CommandName="Edit" ID="EditButton" CausesValidation="False" />&nbsp;<asp:LinkButton runat="server" Text="New" CommandName="New" ID="NewButton" CausesValidation="False" />
                </ItemTemplate>

            </asp:FormView>

            <asp:SqlDataSource runat="server" ID="SqlDataSourceTitle" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' SelectCommand="SELECT NULL AS id, 'Please Select' AS name UNION SELECT TBL_LOOKUPS.id, TBL_LOOKUPS.name FROM TBL_LOOKUPGRPS INNER JOIN TBL_LOOKUPS ON TBL_LOOKUPGRPS.id = TBL_LOOKUPS.lookupgrp_id WHERE (TBL_LOOKUPS.lookupgrp_id = 7)"></asp:SqlDataSource>
            <asp:SqlDataSource runat="server" ID="SqlDataSourceMarital" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' SelectCommand="SELECT NULL AS id, 'Please Select' AS name UNION SELECT TBL_LOOKUPS.id, TBL_LOOKUPS.name FROM TBL_LOOKUPGRPS INNER JOIN TBL_LOOKUPS ON TBL_LOOKUPGRPS.id = TBL_LOOKUPS.lookupgrp_id WHERE (TBL_LOOKUPS.lookupgrp_id = 4)"></asp:SqlDataSource>
            <asp:SqlDataSource runat="server" ID="SqlDataSourceDialect" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' SelectCommand="SELECT NULL AS id, 'Please Select' AS name UNION SELECT TBL_LOOKUPS.id, TBL_LOOKUPS.name FROM TBL_LOOKUPGRPS INNER JOIN TBL_LOOKUPS ON TBL_LOOKUPGRPS.id = TBL_LOOKUPS.lookupgrp_id WHERE (TBL_LOOKUPS.lookupgrp_id = 3)"></asp:SqlDataSource>
            <asp:SqlDataSource runat="server" ID="SqlDataSourceCitizen" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' SelectCommand="SELECT NULL AS id, 'Please Select' AS name UNION SELECT TBL_LOOKUPS.id, TBL_LOOKUPS.name FROM TBL_LOOKUPGRPS INNER JOIN TBL_LOOKUPS ON TBL_LOOKUPGRPS.id = TBL_LOOKUPS.lookupgrp_id WHERE (TBL_LOOKUPS.lookupgrp_id = 28)"></asp:SqlDataSource>
            <asp:SqlDataSource runat="server" ID="SqlDataSourceReligion" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' SelectCommand="SELECT NULL AS id, 'Please Select' AS name UNION SELECT TBL_LOOKUPS.id, TBL_LOOKUPS.name FROM TBL_LOOKUPGRPS INNER JOIN TBL_LOOKUPS ON TBL_LOOKUPGRPS.id = TBL_LOOKUPS.lookupgrp_id WHERE (TBL_LOOKUPS.lookupgrp_id = 1)"></asp:SqlDataSource>
            <asp:SqlDataSource runat="server" ID="SqlDataSourceRace" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' SelectCommand="SELECT NULL AS id, 'Please Select' AS name UNION SELECT TBL_LOOKUPS.id, TBL_LOOKUPS.name FROM TBL_LOOKUPGRPS INNER JOIN TBL_LOOKUPS ON TBL_LOOKUPGRPS.id = TBL_LOOKUPS.lookupgrp_id WHERE (TBL_LOOKUPS.lookupgrp_id = 2)"></asp:SqlDataSource>
            <asp:SqlDataSource runat="server" ID="SqlDataSourceIcColor" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' SelectCommand="SELECT NULL AS id, 'Please Select' AS name UNION SELECT TBL_LOOKUPS.id, TBL_LOOKUPS.name FROM TBL_LOOKUPGRPS INNER JOIN TBL_LOOKUPS ON TBL_LOOKUPGRPS.id = TBL_LOOKUPS.lookupgrp_id WHERE (TBL_LOOKUPS.lookupgrp_id = 23)"></asp:SqlDataSource>
            <asp:SqlDataSource runat="server" ID="SqlDataSourceEmpType" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' SelectCommand="SELECT NULL AS id, 'Please Select' AS name UNION SELECT TBL_LOOKUPS.id, TBL_LOOKUPS.name FROM TBL_LOOKUPGRPS INNER JOIN TBL_LOOKUPS ON TBL_LOOKUPGRPS.id = TBL_LOOKUPS.lookupgrp_id WHERE (TBL_LOOKUPS.lookupgrp_id = 10)"></asp:SqlDataSource>
            <asp:SqlDataSource runat="server" ID="SqlDataSourceworkStatus" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' SelectCommand="SELECT NULL AS id, 'Please Select' AS name UNION SELECT TBL_LOOKUPS.id, TBL_LOOKUPS.name FROM TBL_LOOKUPGRPS INNER JOIN TBL_LOOKUPS ON TBL_LOOKUPGRPS.id = TBL_LOOKUPS.lookupgrp_id WHERE (TBL_LOOKUPS.lookupgrp_id = 12) OR (TBL_LOOKUPS.lookupgrp_id = 43)"></asp:SqlDataSource>
            <asp:SqlDataSource runat="server" ID="SqlDataSourceCity" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' SelectCommand="SELECT NULL AS id, 'Please Select' AS name UNION SELECT TBL_LOOKUPS.id, TBL_LOOKUPS.name FROM TBL_LOOKUPGRPS INNER JOIN TBL_LOOKUPS ON TBL_LOOKUPGRPS.id = TBL_LOOKUPS.lookupgrp_id WHERE (TBL_LOOKUPS.lookupgrp_id = 31)"></asp:SqlDataSource>
            <asp:SqlDataSource runat="server" ID="SqlDataSourceState" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' SelectCommand="SELECT NULL AS id, 'Please Select' AS name UNION SELECT TBL_LOOKUPS.id, TBL_LOOKUPS.name FROM TBL_LOOKUPGRPS INNER JOIN TBL_LOOKUPS ON TBL_LOOKUPGRPS.id = TBL_LOOKUPS.lookupgrp_id WHERE (TBL_LOOKUPS.lookupgrp_id = 8)"></asp:SqlDataSource>
            <asp:SqlDataSource runat="server" ID="SqlDataSourceCountry" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' SelectCommand="SELECT NULL AS id, 'Please Select' AS name UNION SELECT TBL_LOOKUPS.id, TBL_LOOKUPS.name FROM TBL_LOOKUPGRPS INNER JOIN TBL_LOOKUPS ON TBL_LOOKUPGRPS.id = TBL_LOOKUPS.lookupgrp_id WHERE (TBL_LOOKUPS.lookupgrp_id = 9)"></asp:SqlDataSource>
            <asp:SqlDataSource runat="server" ID="SqlDataSourceLbrCode" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' SelectCommand="SELECT 0 AS id, 'Please Select' AS name UNION SELECT TBL_LOOKUPS.id, TBL_LOOKUPS.name FROM TBL_LOOKUPGRPS INNER JOIN TBL_LOOKUPS ON TBL_LOOKUPGRPS.id = TBL_LOOKUPS.lookupgrp_id WHERE (TBL_LOOKUPS.lookupgrp_id = 45)"></asp:SqlDataSource>
            <asp:SqlDataSource runat="server" ID="SqlDataSourceLbrCat" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' SelectCommand="SELECT 0 AS id, 'Please Select' AS name UNION SELECT TBL_LOOKUPS.id, TBL_LOOKUPS.name FROM TBL_LOOKUPGRPS INNER JOIN TBL_LOOKUPS ON TBL_LOOKUPGRPS.id = TBL_LOOKUPS.lookupgrp_id WHERE (TBL_LOOKUPS.lookupgrp_id = 25)"></asp:SqlDataSource>
            <asp:SqlDataSource runat="server" ID="SqlDataSourceJobStatus" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' SelectCommand="SELECT 0 AS id, 'Please Select' AS name UNION SELECT TBL_LOOKUPS.id, TBL_LOOKUPS.name FROM TBL_LOOKUPGRPS INNER JOIN TBL_LOOKUPS ON TBL_LOOKUPGRPS.id = TBL_LOOKUPS.lookupgrp_id WHERE (TBL_LOOKUPS.lookupgrp_id = 24)"></asp:SqlDataSource>
            <asp:SqlDataSource runat="server" ID="SqlDataSourceQtrStatus" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' SelectCommand="SELECT 0 AS id, 'Please Select' AS name UNION SELECT TBL_LOOKUPS.id, TBL_LOOKUPS.name FROM TBL_LOOKUPGRPS INNER JOIN TBL_LOOKUPS ON TBL_LOOKUPGRPS.id = TBL_LOOKUPS.lookupgrp_id WHERE (TBL_LOOKUPS.lookupgrp_id = 26)"></asp:SqlDataSource>

            <asp:SqlDataSource runat="server" ID="SqlDataSourceDiv" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' 
                SelectCommand="SELECT NULL AS id, 'Please Select' AS name UNION SELECT id, divname FROM TBL_CRDIVISIONS WHERE (status = 1)"></asp:SqlDataSource>
            <asp:SqlDataSource runat="server" ID="SqlDataSourceOcs" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' 
                SelectCommand="SELECT NULL AS id, 'Please Select' AS name UNION SELECT id, name FROM TBL_OCS WHERE (status = 1)"></asp:SqlDataSource>
            <%--<asp:SqlDataSource runat="server" ID="SqlDataSourceGangno" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' 
                SelectCommand="SELECT 0 AS id, 'Please Select' AS name UNION SELECT id, gangno FROM TBL_GANGNOMASTERS WHERE (status = 1)"></asp:SqlDataSource>--%>
            <asp:SqlDataSource runat="server" ID="SqlDataSourceGangno" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' 
                SelectCommand="SELECT 0 AS id, 'Please Select' AS name UNION SELECT id, gangno FROM TBL_GANGNOMASTERS WHERE (status = 1) AND (estate_id = @estateId)">
                <SelectParameters>
                    <asp:SessionParameter SessionField="SessionOCS" Name="estateId"></asp:SessionParameter>
                </SelectParameters>
            </asp:SqlDataSource>

            <%--<asp:SqlDataSource runat="server" ID="SqlDataSourceForm" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                InsertCommand="INSERT INTO TBL_EMPS(WORKERINFO_objectId, OC_objectId, DIVISION_objectId, EMPCODE, TITLE_objectId, NAME, NICKNAME, ADDRESS1, ADDRESS2, ADDRESS3, 
                POSTCODE, CITY_objectId, STATE_objectId, COUNTRY_objectId, HOMETEL, OFFICETEL, EXTNO, MOBILETEL, EMAIL, NRICNEW, NRICCOLOR_objectId, SEX, DOB, POB, 
                RELIGION_objectId, RACE_objectId, DIALECT_objectId, MARITAL_objectId, CITIZENSHIP_objectId, DATEJOIN, SOCSOSTATUS, SOCSONO, INCOMETAXNO, EPFSTATUS, 
                EPFNO, SALARY, WORKSTATUS_objectId, PHOTO, KLKUSER_objectId, ISLOADER, REMARKS, DAILYRATE, createdAt, IsActive, WDR, EMPTYPE_objectId) 
                VALUES (@WORKERINFO_objectId, @OC_objectId, 109, @EMPCODE, @TITLE_objectId, @NAME, @NICKNAME, @ADDRESS1, @ADDRESS2, @ADDRESS3, @POSTCODE, @CITY_objectId, 
                @STATE_objectId, @COUNTRY_objectId, @HOMETEL, @OFFICETEL, @EXTNO, @MOBILETEL, @EMAIL, @NRICNEW, @NRICCOLOR_objectId, @SEX, @DOB, @POB, @RELIGION_objectId, 
                @RACE_objectId, @DIALECT_objectId, @MARITAL_objectId, @CITIZENSHIP_objectId, @DATEJOIN, @SOCSOSTATUS, @SOCSONO, @INCOMETAXNO, @EPFSTATUS, @EPFNO, @SALARY, 
                @WORKSTATUS_objectId, @PHOTO, @KLKUSER_objectId, @ISLOADER, @REMARKS, @DAILYRATE, @createdAt, @IsActive, 0, @EMPTYPE_objectId)"
                SelectCommand="SELECT TBL_EMPS.objectId, TBL_EMPS.WORKERINFO_objectId, TBL_EMPS.OC_objectId, TBL_EMPS.DIVISION_objectId, TBL_EMPS.DEPT_objectId, 
                TBL_EMPS.UNIT_objectId, TBL_EMPS.EMPTYPE_objectId, TBL_EMPS.EMPCODE, TBL_EMPS.TITLE_objectId, TBL_EMPS.NAME, TBL_EMPS.NICKNAME, TBL_EMPS.ADDRESS1, 
                TBL_EMPS.ADDRESS2, TBL_EMPS.ADDRESS3, TBL_EMPS.POSTCODE, TBL_EMPS.CITY_objectId, TBL_EMPS.STATE_objectId, TBL_EMPS.COUNTRY_objectId, TBL_EMPS.HOMETEL, 
                TBL_EMPS.OFFICETEL, TBL_EMPS.EXTNO, TBL_EMPS.MOBILETEL, TBL_EMPS.EMAIL, TBL_EMPS.NRICNEW, TBL_EMPS.NRICOLD, TBL_EMPS.NRICCOLOR_objectId, TBL_EMPS.PASSPORT, 
                TBL_EMPS.SEX, CONVERT (NVARCHAR(50), TBL_EMPS.DOB, 23) AS DOB, TBL_EMPS.POB, TBL_EMPS.RELIGION_objectId, TBL_EMPS.RACE_objectId, TBL_EMPS.DIALECT_objectId, 
                TBL_EMPS.BUMIPUTRA, TBL_EMPS.MARITAL_objectId, TBL_EMPS.CITIZENSHIP_objectId, CONVERT (NVARCHAR(50), TBL_EMPS.DATEJOIN, 23) AS DATEJOIN, 
                TBL_EMPS.DATEJOINASSTAFF, TBL_EMPS.DATEJOINASEXEC, TBL_EMPS.DATESERVICEEXT, TBL_EMPS.SOCSOSTATUS, TBL_EMPS.SOCSONO, TBL_EMPS.INCOMETAXNO, 
                TBL_EMPS.EPFSTATUS, TBL_EMPS.EPFNO, TBL_EMPS.MESPFNO, TBL_EMPS.DESIGNATION_objectId, TBL_EMPS.SALARY, TBL_EMPS.GRADE_objectId, TBL_EMPS.WORKSTATUS_objectId, 
                TBL_EMPS.INCREDAY, TBL_EMPS.INCREMTH, TBL_EMPS.ISCONFIRMED, TBL_EMPS.PHOTO, TBL_EMPS.RECSTATUS_objectId, TBL_EMPS.KLKUSER_objectId, TBL_EMPS.LASTWORKINGDATE, 
                TBL_EMPS.TRANSFERINDATE, TBL_EMPS.DESIGNATIONSTARTDATE, TBL_EMPS.PASSPORTEXPIRYDATE, TBL_EMPS.LEVYRECORD_objectId, TBL_EMPS.LATESTPERMITNO, 
                TBL_EMPS.LATESTPERMITEXPIRYDATE, TBL_EMPS.LATESTCOUNTRYORIGIN_objectId, TBL_EMPS.ISLOADER, TBL_EMPS.REMARKS, TBL_EMPS.DAILYRATE, TBL_EMPS.createdAt, 
                TBL_EMPS.updatedAt, TBL_EMPS.IsActive, TBL_EMPS.NORMALRATE, TBL_EMPS.WRDRATE, TBL_EMPS.PHRATE, TBL_EMPS.PHNOTELIGIBLERATE, TBL_EMPS.OTNORMALRATE, 
                TBL_EMPS.OTWRDRATE, TBL_EMPS.OTPHRATE, TBL_EMPS.OTPHNOTELIGIBLERATE, TBL_EMPS.PHNOTWORKINGRATE, TBL_EMPS.MCRATE, TBL_EMPS.WorkRateMaster_objectId, 
                TBL_EMPS.WDR, TBL_WORKERINFOES.GANGNO_objectId, ISNULL(TBL_WORKERINFOES.JOBSTATUS_objectId,0) AS JOBSTATUS_objectId, 
                ISNULL(TBL_WORKERINFOES.LABOURCD_objectId,0) AS LABOURCD_objectId, ISNULL(TBL_WORKERINFOES.LABOURCAT_objectId,0) AS LABOURCAT_objectId, 
                ISNULL(TBL_WORKERINFOES.QTRSTATUS_objectId,0) As QTRSTATUS_objectId, TBL_WORKERINFOES.RATETYPE_objectId, TBL_WORKERINFOES.MANDORE 
                FROM TBL_EMPS INNER JOIN TBL_WORKERINFOES ON TBL_EMPS.objectId = TBL_WORKERINFOES.EMP_objectId WHERE (TBL_EMPS.objectId = @objectId)"
                UpdateCommand="UPDATE TBL_EMPS SET EMPCODE = @EMPCODE, TITLE_objectId = @TITLE_objectId, NAME = @NAME, NICKNAME = @NICKNAME, ADDRESS1 = @ADDRESS1, 
                ADDRESS2 = @ADDRESS2, ADDRESS3 = @ADDRESS3, POSTCODE = @POSTCODE, CITY_objectId = @CITY_objectId, STATE_objectId = @STATE_objectId, 
                COUNTRY_objectId = @COUNTRY_objectId, HOMETEL = @HOMETEL, OFFICETEL = @OFFICETEL, EXTNO = @EXTNO, MOBILETEL = @MOBILETEL, EMAIL = @EMAIL, 
                NRICNEW = @NRICNEW, NRICCOLOR_objectId = @NRICCOLOR_objectId, SEX = @SEX, DOB = @DOB, POB = @POB, RELIGION_objectId = @RELIGION_objectId, 
                RACE_objectId = @RACE_objectId, DIALECT_objectId = @DIALECT_objectId, MARITAL_objectId = @MARITAL_objectId, CITIZENSHIP_objectId = @CITIZENSHIP_objectId, 
                DATEJOIN = @DATEJOIN, SOCSOSTATUS = @SOCSOSTATUS, SOCSONO = @SOCSONO, INCOMETAXNO = @INCOMETAXNO, EPFSTATUS = @EPFSTATUS, EPFNO = @EPFNO, SALARY = @SALARY, 
                WORKSTATUS_objectId = @WORKSTATUS_objectId, PHOTO = @PHOTO, KLKUSER_objectId = @KLKUSER_objectId, ISLOADER = @ISLOADER, REMARKS = @REMARKS, 
                DAILYRATE = @DAILYRATE, updatedAt = @updatedAt, IsActive = @IsActive, EMPTYPE_objectId = @EMPTYPE_objectId WHERE (objectId = @objectId)">
                <InsertParameters>
                    <asp:Parameter Name="WORKERINFO_objectId"></asp:Parameter>
                    <asp:Parameter Name="OC_objectId"></asp:Parameter>
                    <asp:Parameter Name="EMPCODE"></asp:Parameter>
                    <asp:Parameter Name="TITLE_objectId"></asp:Parameter>
                    <asp:Parameter Name="NAME"></asp:Parameter>
                    <asp:Parameter Name="NICKNAME"></asp:Parameter>
                    <asp:Parameter Name="ADDRESS1"></asp:Parameter>
                    <asp:Parameter Name="ADDRESS2"></asp:Parameter>
                    <asp:Parameter Name="ADDRESS3"></asp:Parameter>
                    <asp:Parameter Name="POSTCODE"></asp:Parameter>
                    <asp:Parameter Name="CITY_objectId"></asp:Parameter>
                    <asp:Parameter Name="STATE_objectId"></asp:Parameter>
                    <asp:Parameter Name="COUNTRY_objectId"></asp:Parameter>
                    <asp:Parameter Name="HOMETEL"></asp:Parameter>
                    <asp:Parameter Name="OFFICETEL"></asp:Parameter>
                    <asp:Parameter Name="EXTNO"></asp:Parameter>
                    <asp:Parameter Name="MOBILETEL"></asp:Parameter>
                    <asp:Parameter Name="EMAIL"></asp:Parameter>
                    <asp:Parameter Name="NRICNEW"></asp:Parameter>
                    <asp:Parameter Name="NRICCOLOR_objectId"></asp:Parameter>
                    <asp:Parameter Name="SEX"></asp:Parameter>
                    <asp:Parameter Name="DOB"></asp:Parameter>
                    <asp:Parameter Name="POB"></asp:Parameter>
                    <asp:Parameter Name="RELIGION_objectId"></asp:Parameter>
                    <asp:Parameter Name="RACE_objectId"></asp:Parameter>
                    <asp:Parameter Name="DIALECT_objectId"></asp:Parameter>
                    <asp:Parameter Name="MARITAL_objectId"></asp:Parameter>
                    <asp:Parameter Name="CITIZENSHIP_objectId"></asp:Parameter>
                    <asp:Parameter Name="DATEJOIN"></asp:Parameter>
                    <asp:Parameter Name="SOCSOSTATUS"></asp:Parameter>
                    <asp:Parameter Name="SOCSONO"></asp:Parameter>
                    <asp:Parameter Name="INCOMETAXNO"></asp:Parameter>
                    <asp:Parameter Name="EPFSTATUS"></asp:Parameter>
                    <asp:Parameter Name="EPFNO"></asp:Parameter>
                    <asp:Parameter Name="SALARY"></asp:Parameter>
                    <asp:Parameter Name="WORKSTATUS_objectId"></asp:Parameter>
                    <asp:Parameter Name="PHOTO"></asp:Parameter>
                    <asp:Parameter Name="KLKUSER_objectId"></asp:Parameter>
                    <asp:Parameter Name="ISLOADER"></asp:Parameter>
                    <asp:Parameter Name="REMARKS"></asp:Parameter>
                    <asp:Parameter Name="DAILYRATE"></asp:Parameter>
                    <asp:Parameter Name="createdAt"></asp:Parameter>
                    <asp:Parameter Name="IsActive"></asp:Parameter>
                    <asp:Parameter Name="EMPTYPE_objectId"></asp:Parameter>
                </InsertParameters>
                <SelectParameters>
                    <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedValue" Name="objectId"></asp:ControlParameter>
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="EMPCODE"></asp:Parameter>
                    <asp:Parameter Name="TITLE_objectId"></asp:Parameter>
                    <asp:Parameter Name="NAME"></asp:Parameter>
                    <asp:Parameter Name="NICKNAME"></asp:Parameter>
                    <asp:Parameter Name="ADDRESS1"></asp:Parameter>
                    <asp:Parameter Name="ADDRESS2"></asp:Parameter>
                    <asp:Parameter Name="ADDRESS3"></asp:Parameter>
                    <asp:Parameter Name="POSTCODE"></asp:Parameter>
                    <asp:Parameter Name="CITY_objectId"></asp:Parameter>
                    <asp:Parameter Name="STATE_objectId"></asp:Parameter>
                    <asp:Parameter Name="COUNTRY_objectId"></asp:Parameter>
                    <asp:Parameter Name="HOMETEL"></asp:Parameter>
                    <asp:Parameter Name="OFFICETEL"></asp:Parameter>
                    <asp:Parameter Name="EXTNO"></asp:Parameter>
                    <asp:Parameter Name="MOBILETEL"></asp:Parameter>
                    <asp:Parameter Name="EMAIL"></asp:Parameter>
                    <asp:Parameter Name="NRICNEW"></asp:Parameter>
                    <asp:Parameter Name="NRICCOLOR_objectId"></asp:Parameter>
                    <asp:Parameter Name="SEX"></asp:Parameter>
                    <asp:Parameter Name="DOB"></asp:Parameter>
                    <asp:Parameter Name="POB"></asp:Parameter>
                    <asp:Parameter Name="RELIGION_objectId"></asp:Parameter>
                    <asp:Parameter Name="RACE_objectId"></asp:Parameter>
                    <asp:Parameter Name="DIALECT_objectId"></asp:Parameter>
                    <asp:Parameter Name="MARITAL_objectId"></asp:Parameter>
                    <asp:Parameter Name="CITIZENSHIP_objectId"></asp:Parameter>
                    <asp:Parameter Name="DATEJOIN"></asp:Parameter>
                    <asp:Parameter Name="SOCSOSTATUS"></asp:Parameter>
                    <asp:Parameter Name="SOCSONO"></asp:Parameter>
                    <asp:Parameter Name="INCOMETAXNO"></asp:Parameter>
                    <asp:Parameter Name="EPFSTATUS"></asp:Parameter>
                    <asp:Parameter Name="EPFNO"></asp:Parameter>
                    <asp:Parameter Name="SALARY"></asp:Parameter>
                    <asp:Parameter Name="WORKSTATUS_objectId"></asp:Parameter>
                    <asp:Parameter Name="PHOTO"></asp:Parameter>
                    <asp:Parameter Name="KLKUSER_objectId"></asp:Parameter>
                    <asp:Parameter Name="ISLOADER"></asp:Parameter>
                    <asp:Parameter Name="REMARKS"></asp:Parameter>
                    <asp:Parameter Name="DAILYRATE"></asp:Parameter>
                    <asp:Parameter Name="updatedAt"></asp:Parameter>
                    <asp:Parameter Name="IsActive"></asp:Parameter>
                    <asp:Parameter Name="EMPTYPE_objectId"></asp:Parameter>
                    <asp:Parameter Name="objectId"></asp:Parameter>
                </UpdateParameters>
            </asp:SqlDataSource>--%>
            <asp:SqlDataSource runat="server" ID="SqlDataSourceForm" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                InsertCommand="INSERT INTO TBL_EMPS(WORKERINFO_objectId, OC_objectId, DIVISION_objectId, EMPCODE, TITLE_objectId, NAME, NICKNAME, ADDRESS1, ADDRESS2, ADDRESS3, 
                POSTCODE, CITY_objectId, STATE_objectId, COUNTRY_objectId, HOMETEL, OFFICETEL, EXTNO, MOBILETEL, EMAIL, NRICNEW, NRICCOLOR_objectId, SEX, DOB, POB, 
                RELIGION_objectId, RACE_objectId, DIALECT_objectId, MARITAL_objectId, CITIZENSHIP_objectId, DATEJOIN, SOCSOSTATUS, SOCSONO, INCOMETAXNO, EPFSTATUS, 
                EPFNO, SALARY, WORKSTATUS_objectId, PHOTO, KLKUSER_objectId, ISLOADER, REMARKS, DAILYRATE, createdAt, IsActive, WDR, EMPTYPE_objectId) 
                VALUES (@WORKERINFO_objectId, @OC_objectId, 109, @EMPCODE, @TITLE_objectId, @NAME, @NICKNAME, @ADDRESS1, @ADDRESS2, @ADDRESS3, @POSTCODE, @CITY_objectId, 
                @STATE_objectId, @COUNTRY_objectId, @HOMETEL, @OFFICETEL, @EXTNO, @MOBILETEL, @EMAIL, @NRICNEW, @NRICCOLOR_objectId, @SEX, @DOB, @POB, @RELIGION_objectId, 
                @RACE_objectId, @DIALECT_objectId, @MARITAL_objectId, @CITIZENSHIP_objectId, @DATEJOIN, @SOCSOSTATUS, @SOCSONO, @INCOMETAXNO, @EPFSTATUS, @EPFNO, @SALARY, 
                @WORKSTATUS_objectId, @PHOTO, @KLKUSER_objectId, @ISLOADER, @REMARKS, @DAILYRATE, @createdAt, @IsActive, 0, @EMPTYPE_objectId)"
                SelectCommand="SELECT TBL_EMPS.objectId, TBL_EMPS.WORKERINFO_objectId, TBL_EMPS.OC_objectId, TBL_EMPS.DIVISION_objectId, TBL_EMPS.DEPT_objectId, 
                TBL_EMPS.UNIT_objectId, TBL_EMPS.EMPTYPE_objectId, TBL_EMPS.EMPCODE, TBL_EMPS.TITLE_objectId, TBL_EMPS.NAME, TBL_EMPS.NICKNAME, TBL_EMPS.ADDRESS1, 
                TBL_EMPS.ADDRESS2, TBL_EMPS.ADDRESS3, TBL_EMPS.POSTCODE, TBL_EMPS.CITY_objectId, TBL_EMPS.STATE_objectId, TBL_EMPS.COUNTRY_objectId, TBL_EMPS.HOMETEL, 
                TBL_EMPS.OFFICETEL, TBL_EMPS.EXTNO, TBL_EMPS.MOBILETEL, TBL_EMPS.EMAIL, TBL_EMPS.NRICNEW, TBL_EMPS.NRICOLD, TBL_EMPS.NRICCOLOR_objectId, TBL_EMPS.PASSPORT, 
                TBL_EMPS.SEX, CONVERT (NVARCHAR(50), TBL_EMPS.DOB, 23) AS DOB, TBL_EMPS.POB, TBL_EMPS.RELIGION_objectId, TBL_EMPS.RACE_objectId, TBL_EMPS.DIALECT_objectId, 
                TBL_EMPS.BUMIPUTRA, TBL_EMPS.MARITAL_objectId, TBL_EMPS.CITIZENSHIP_objectId, CONVERT (NVARCHAR(50), TBL_EMPS.DATEJOIN, 23) AS DATEJOIN, 
                TBL_EMPS.DATEJOINASSTAFF, TBL_EMPS.DATEJOINASEXEC, TBL_EMPS.DATESERVICEEXT, TBL_EMPS.SOCSOSTATUS, TBL_EMPS.SOCSONO, TBL_EMPS.INCOMETAXNO, 
                TBL_EMPS.EPFSTATUS, TBL_EMPS.EPFNO, TBL_EMPS.MESPFNO, TBL_EMPS.DESIGNATION_objectId, TBL_EMPS.SALARY, TBL_EMPS.GRADE_objectId, TBL_EMPS.WORKSTATUS_objectId, 
                TBL_EMPS.INCREDAY, TBL_EMPS.INCREMTH, TBL_EMPS.ISCONFIRMED, ISNULL(TBL_EMPS.PHOTO,'~/Archive/Employee/default.jpg') AS PHOTO, TBL_EMPS.RECSTATUS_objectId, TBL_EMPS.KLKUSER_objectId, TBL_EMPS.LASTWORKINGDATE, 
                TBL_EMPS.TRANSFERINDATE, TBL_EMPS.DESIGNATIONSTARTDATE, TBL_EMPS.PASSPORTEXPIRYDATE, TBL_EMPS.LEVYRECORD_objectId, TBL_EMPS.LATESTPERMITNO, 
                TBL_EMPS.LATESTPERMITEXPIRYDATE, TBL_EMPS.LATESTCOUNTRYORIGIN_objectId, TBL_EMPS.ISLOADER, TBL_EMPS.REMARKS, TBL_EMPS.DAILYRATE, TBL_EMPS.createdAt, 
                TBL_EMPS.updatedAt, TBL_EMPS.IsActive, TBL_EMPS.NORMALRATE, TBL_EMPS.WRDRATE, TBL_EMPS.PHRATE, TBL_EMPS.PHNOTELIGIBLERATE, TBL_EMPS.OTNORMALRATE, 
                TBL_EMPS.OTWRDRATE, TBL_EMPS.OTPHRATE, TBL_EMPS.OTPHNOTELIGIBLERATE, TBL_EMPS.PHNOTWORKINGRATE, TBL_EMPS.MCRATE, TBL_EMPS.WorkRateMaster_objectId, 
                TBL_EMPS.WDR, ISNULL(TBL_WORKERINFOES.GANGNO_objectId,0) AS GANGNO_objectId, ISNULL(TBL_WORKERINFOES.JOBSTATUS_objectId,0) AS JOBSTATUS_objectId, 
                ISNULL(TBL_WORKERINFOES.LABOURCD_objectId,0) AS LABOURCD_objectId, ISNULL(TBL_WORKERINFOES.LABOURCAT_objectId,0) AS LABOURCAT_objectId, 
                ISNULL(TBL_WORKERINFOES.QTRSTATUS_objectId,0) As QTRSTATUS_objectId, TBL_WORKERINFOES.RATETYPE_objectId, TBL_WORKERINFOES.MANDORE 
                FROM TBL_EMPS INNER JOIN TBL_WORKERINFOES ON TBL_EMPS.objectId = TBL_WORKERINFOES.EMP_objectId WHERE (TBL_EMPS.objectId = @objectId)"
                UpdateCommand="UPDATE TBL_EMPS SET EMPCODE = @EMPCODE, TITLE_objectId = @TITLE_objectId, NAME = @NAME, NICKNAME = @NICKNAME, ADDRESS1 = @ADDRESS1, 
                ADDRESS2 = @ADDRESS2, ADDRESS3 = @ADDRESS3, POSTCODE = @POSTCODE, CITY_objectId = @CITY_objectId, STATE_objectId = @STATE_objectId, 
                COUNTRY_objectId = @COUNTRY_objectId, HOMETEL = @HOMETEL, OFFICETEL = @OFFICETEL, EXTNO = @EXTNO, MOBILETEL = @MOBILETEL, EMAIL = @EMAIL, 
                NRICNEW = @NRICNEW, NRICCOLOR_objectId = @NRICCOLOR_objectId, SEX = @SEX, DOB = @DOB, POB = @POB, RELIGION_objectId = @RELIGION_objectId, 
                RACE_objectId = @RACE_objectId, DIALECT_objectId = @DIALECT_objectId, MARITAL_objectId = @MARITAL_objectId, CITIZENSHIP_objectId = @CITIZENSHIP_objectId, 
                DATEJOIN = @DATEJOIN, SOCSOSTATUS = @SOCSOSTATUS, SOCSONO = @SOCSONO, INCOMETAXNO = @INCOMETAXNO, EPFSTATUS = @EPFSTATUS, EPFNO = @EPFNO, SALARY = @SALARY, 
                WORKSTATUS_objectId = @WORKSTATUS_objectId, PHOTO = @PHOTO, KLKUSER_objectId = @KLKUSER_objectId, ISLOADER = @ISLOADER, REMARKS = @REMARKS, 
                DAILYRATE = @DAILYRATE, updatedAt = @updatedAt, IsActive = @IsActive, EMPTYPE_objectId = @EMPTYPE_objectId WHERE (objectId = @objectId)">
                <InsertParameters>
                    <asp:Parameter Name="WORKERINFO_objectId"></asp:Parameter>
                    <asp:Parameter Name="OC_objectId"></asp:Parameter>
                    <asp:Parameter Name="EMPCODE"></asp:Parameter>
                    <asp:Parameter Name="TITLE_objectId"></asp:Parameter>
                    <asp:Parameter Name="NAME"></asp:Parameter>
                    <asp:Parameter Name="NICKNAME"></asp:Parameter>
                    <asp:Parameter Name="ADDRESS1"></asp:Parameter>
                    <asp:Parameter Name="ADDRESS2"></asp:Parameter>
                    <asp:Parameter Name="ADDRESS3"></asp:Parameter>
                    <asp:Parameter Name="POSTCODE"></asp:Parameter>
                    <asp:Parameter Name="CITY_objectId"></asp:Parameter>
                    <asp:Parameter Name="STATE_objectId"></asp:Parameter>
                    <asp:Parameter Name="COUNTRY_objectId"></asp:Parameter>
                    <asp:Parameter Name="HOMETEL"></asp:Parameter>
                    <asp:Parameter Name="OFFICETEL"></asp:Parameter>
                    <asp:Parameter Name="EXTNO"></asp:Parameter>
                    <asp:Parameter Name="MOBILETEL"></asp:Parameter>
                    <asp:Parameter Name="EMAIL"></asp:Parameter>
                    <asp:Parameter Name="NRICNEW"></asp:Parameter>
                    <asp:Parameter Name="NRICCOLOR_objectId"></asp:Parameter>
                    <asp:Parameter Name="SEX"></asp:Parameter>
                    <asp:Parameter Name="DOB"></asp:Parameter>
                    <asp:Parameter Name="POB"></asp:Parameter>
                    <asp:Parameter Name="RELIGION_objectId"></asp:Parameter>
                    <asp:Parameter Name="RACE_objectId"></asp:Parameter>
                    <asp:Parameter Name="DIALECT_objectId"></asp:Parameter>
                    <asp:Parameter Name="MARITAL_objectId"></asp:Parameter>
                    <asp:Parameter Name="CITIZENSHIP_objectId"></asp:Parameter>
                    <asp:Parameter Name="DATEJOIN"></asp:Parameter>
                    <asp:Parameter Name="SOCSOSTATUS"></asp:Parameter>
                    <asp:Parameter Name="SOCSONO"></asp:Parameter>
                    <asp:Parameter Name="INCOMETAXNO"></asp:Parameter>
                    <asp:Parameter Name="EPFSTATUS"></asp:Parameter>
                    <asp:Parameter Name="EPFNO"></asp:Parameter>
                    <asp:Parameter Name="SALARY"></asp:Parameter>
                    <asp:Parameter Name="WORKSTATUS_objectId"></asp:Parameter>
                    <asp:Parameter Name="PHOTO"></asp:Parameter>
                    <asp:Parameter Name="KLKUSER_objectId"></asp:Parameter>
                    <asp:Parameter Name="ISLOADER"></asp:Parameter>
                    <asp:Parameter Name="REMARKS"></asp:Parameter>
                    <asp:Parameter Name="DAILYRATE"></asp:Parameter>
                    <asp:Parameter Name="createdAt"></asp:Parameter>
                    <asp:Parameter Name="IsActive"></asp:Parameter>
                    <asp:Parameter Name="EMPTYPE_objectId"></asp:Parameter>
                </InsertParameters>
                <SelectParameters>
                    <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedValue" Name="objectId"></asp:ControlParameter>
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="EMPCODE"></asp:Parameter>
                    <asp:Parameter Name="TITLE_objectId"></asp:Parameter>
                    <asp:Parameter Name="NAME"></asp:Parameter>
                    <asp:Parameter Name="NICKNAME"></asp:Parameter>
                    <asp:Parameter Name="ADDRESS1"></asp:Parameter>
                    <asp:Parameter Name="ADDRESS2"></asp:Parameter>
                    <asp:Parameter Name="ADDRESS3"></asp:Parameter>
                    <asp:Parameter Name="POSTCODE"></asp:Parameter>
                    <asp:Parameter Name="CITY_objectId"></asp:Parameter>
                    <asp:Parameter Name="STATE_objectId"></asp:Parameter>
                    <asp:Parameter Name="COUNTRY_objectId"></asp:Parameter>
                    <asp:Parameter Name="HOMETEL"></asp:Parameter>
                    <asp:Parameter Name="OFFICETEL"></asp:Parameter>
                    <asp:Parameter Name="EXTNO"></asp:Parameter>
                    <asp:Parameter Name="MOBILETEL"></asp:Parameter>
                    <asp:Parameter Name="EMAIL"></asp:Parameter>
                    <asp:Parameter Name="NRICNEW"></asp:Parameter>
                    <asp:Parameter Name="NRICCOLOR_objectId"></asp:Parameter>
                    <asp:Parameter Name="SEX"></asp:Parameter>
                    <asp:Parameter Name="DOB"></asp:Parameter>
                    <asp:Parameter Name="POB"></asp:Parameter>
                    <asp:Parameter Name="RELIGION_objectId"></asp:Parameter>
                    <asp:Parameter Name="RACE_objectId"></asp:Parameter>
                    <asp:Parameter Name="DIALECT_objectId"></asp:Parameter>
                    <asp:Parameter Name="MARITAL_objectId"></asp:Parameter>
                    <asp:Parameter Name="CITIZENSHIP_objectId"></asp:Parameter>
                    <asp:Parameter Name="DATEJOIN"></asp:Parameter>
                    <asp:Parameter Name="SOCSOSTATUS"></asp:Parameter>
                    <asp:Parameter Name="SOCSONO"></asp:Parameter>
                    <asp:Parameter Name="INCOMETAXNO"></asp:Parameter>
                    <asp:Parameter Name="EPFSTATUS"></asp:Parameter>
                    <asp:Parameter Name="EPFNO"></asp:Parameter>
                    <asp:Parameter Name="SALARY"></asp:Parameter>
                    <asp:Parameter Name="WORKSTATUS_objectId"></asp:Parameter>
                    <asp:Parameter Name="PHOTO"></asp:Parameter>
                    <asp:Parameter Name="KLKUSER_objectId"></asp:Parameter>
                    <asp:Parameter Name="ISLOADER"></asp:Parameter>
                    <asp:Parameter Name="REMARKS"></asp:Parameter>
                    <asp:Parameter Name="DAILYRATE"></asp:Parameter>
                    <asp:Parameter Name="updatedAt"></asp:Parameter>
                    <asp:Parameter Name="IsActive"></asp:Parameter>
                    <asp:Parameter Name="EMPTYPE_objectId"></asp:Parameter>
                    <asp:Parameter Name="objectId"></asp:Parameter>
                </UpdateParameters>
            </asp:SqlDataSource>
    
    

            <!-- Default box -->
            <%--        EmpCode:
            <asp:TextBox ID="TextBoxEmpCode" placeholder="EMPCODE" runat="server" Width="120"></asp:TextBox>
            Name:
            <asp:TextBox ID="TextBoxName" placeholder="NAME" runat="server" Width="120"></asp:TextBox>--%>
            <%--        <asp:Button ID="btnSearch" runat="server" CssClass="btn bg-purple color-palette" Text="Search" /><asp:Button ID="btnReset" CssClass="btn btn-default" runat="server" Text="Reset" /><br />--%>
            <br />


            <!-- /.card -->
            <div class="card">
                <div class="card-header">
                    <%--# START FILTER - set SortExpression at GridView as fieldname & add WHERE 1=1 at SqlDataSource - SelectCommand #--%>
                    <div class="row">
                        <div class="col-md-9">
                            <div id="pnlFilter" runat="server" class="row"></div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <asp:Button ID="btnSearch" runat="server" CssClass="btn bg-purple color-palette" Text="Search" />
                                <asp:Button ID="btnReset" CssClass="btn btn-default" runat="server" Text="Reset" />
                            </div>
                        </div>
                    </div>
                    <%--# END FILTER #--%>

                    <div class="card-tools">
                        <button type="button" class="btn btn-tool" data-card-widget="collapse" data-toggle="tooltip" title="Collapse">
                            <i class="fas fa-minus"></i>
                        </button>
                    </div>
                </div>
                <%--            <div class="card-header">
                    <h3 class="card-title">Employee List</h3>

                    <div class="card-tools">
                        <button type="button" class="btn btn-tool" data-card-widget="collapse" data-toggle="tooltip" title="Collapse">
                            <i class="fas fa-minus"></i>
                        </button>
                    </div>
                </div>--%>
                <div class="card-body p-0">
                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="objectId" DataSourceID="SqlDataSourceGrid" AllowPaging="True" PageSize="10" ShowHeaderWhenEmpty="True" EmptyDataText="No records Found" CssClass="table table-bordered projects" PagerStyle-CssClass="pgr"
                        AlternatingRowStyle-CssClass="alt" AllowSorting="True">
                        <Columns>
                            <asp:BoundField DataField="EMPCODE" HeaderText="EMPCODE" SortExpression="EMPCODE"></asp:BoundField>
                            <asp:BoundField DataField="NAME" HeaderText="NAME" SortExpression="NAME"></asp:BoundField>
                            <asp:BoundField DataField="DOB" HeaderText="DOB" SortExpression="DOB"></asp:BoundField>
                            <asp:BoundField DataField="SEX" HeaderText="SEX" SortExpression="SEX"></asp:BoundField>
                            <asp:BoundField DataField="DATEJOIN" HeaderText="DATEJOIN" SortExpression="DATEJOIN"></asp:BoundField>
                            <asp:BoundField DataField="RELIGION" HeaderText="RELIGION" SortExpression="RELIGION"></asp:BoundField>
                            <asp:BoundField DataField="ISACTIVE" HeaderText="STATUS" SortExpression="ISACTIVE"></asp:BoundField>
                            <asp:TemplateField ShowHeader="False">
                                <ItemTemplate>
                                    <asp:LinkButton runat="server" Text="Edit" CommandName="Select" CausesValidation="False" ID="LinkButton1" CssClass="btn btn-warning btn-sm"></asp:LinkButton><%--&nbsp;<asp:LinkButton runat="server" Text="Delete" CommandName="Delete" Visible="false" CausesValidation="False" ID="LinkButton2" CssClass="btn btn-danger" OnClientClick="return confirm('Are you sure to delete?');"></asp:LinkButton>--%>
                                </ItemTemplate>
                            </asp:TemplateField>

                        </Columns>
                        <PagerSettings Mode="NumericFirstLast" PageButtonCount="6" FirstPageText="First" LastPageText="Last" />
                        <PagerStyle CssClass="pgr" />
                    </asp:GridView>
                    <asp:SqlDataSource runat="server" ID="SqlDataSourceGrid" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                        DeleteCommand="DELETE FROM TBL_EMPS WHERE (objectId = @objectId)"
                        SelectCommand="select * from (SELECT TBL_EMPS.objectId, TBL_EMPS.EMPCODE, TBL_EMPS.NAME, CONVERT (NVARCHAR(50), TBL_EMPS.DOB, 23) AS DOB, 
                        IIF(TBL_EMPS.SEX=1, 'Male', 'Female') AS SEX, CONVERT (NVARCHAR(50), TBL_EMPS.DATEJOIN, 23) AS DATEJOIN, TBL_LOOKUPS.name AS Religion, TBL_EMPS.OC_objectId AS OCID, 
                        IIF(TBL_EMPS.IsActive=1, 'Active', 'Suspend') AS IsActive FROM TBL_EMPS 
                        LEFT OUTER JOIN TBL_LOOKUPS ON TBL_EMPS.RELIGION_objectId = TBL_LOOKUPS.id WHERE (TBL_EMPS.OC_objectId = @estateId)) a WHERE 1=1">
                        <DeleteParameters>
                            <asp:Parameter Name="objectId"></asp:Parameter>
                        </DeleteParameters>
                        <SelectParameters>
                            <asp:SessionParameter SessionField="SessionOCS" Name="estateId"></asp:SessionParameter>
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <asp:SqlDataSource runat="server" ID="SqlDataSourceFilter" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                        SelectCommand="select TOP 1 * from (SELECT TBL_EMPS.objectId, TBL_EMPS.EMPCODE, TBL_EMPS.NAME, CONVERT (NVARCHAR(50), TBL_EMPS.DOB, 23) AS DOB, 
                        IIF(TBL_EMPS.SEX=1, 'Male', 'Female') AS SEX, CONVERT (NVARCHAR(50), TBL_EMPS.DATEJOIN, 23) AS DATEJOIN, TBL_LOOKUPS.name AS Religion, TBL_EMPS.OC_objectId AS OCID, 
                        IIF(TBL_EMPS.IsActive=1, 'Active', 'Suspend') AS IsActive FROM TBL_EMPS 
                        LEFT OUTER JOIN TBL_LOOKUPS ON TBL_EMPS.RELIGION_objectId = TBL_LOOKUPS.id) a WHERE 1=1">
                    </asp:SqlDataSource>
                </div>
            </div>

        </div>
    </section>

    <!-- jQuery -->
    <script src="/assets/plugins/jquery/jquery.min.js"></script>
    <!-- Bootstrap 4 -->
    <script src="/assets/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
    <!-- Select2 -->
    <script src="/assets/plugins/select2/js/select2.full.min.js"></script>
    <!-- Bootstrap4 Duallistbox -->
    <script src="/assets//plugins/bootstrap4-duallistbox/jquery.bootstrap-duallistbox.min.js"></script>
    <!-- InputMask -->
    <script src="/assets/plugins/moment/moment.min.js"></script>
    <script src="/assets/plugins/inputmask/min/jquery.inputmask.bundle.min.js"></script>
    <!-- date-range-picker -->
    <script src="/assets/plugins/daterangepicker/daterangepicker.js"></script>
    <!-- bootstrap color picker -->
    <script src="/assets/plugins/bootstrap-colorpicker/js/bootstrap-colorpicker.min.js"></script>
    <!-- Bootstrap Switch -->
    <script src="/assets/plugins/bootstrap-switch/js/bootstrap-switch.min.js"></script>


    <script>
        $(function () {
            //Initialize Select2 Elements
            $('.select2').select2()

            //Initialize Select2 Elements
            $('.select2bs4').select2({
                theme: 'bootstrap4'
            })

            //Datemask dd/mm/yyyy
            $('#datemask').inputmask('yyyy-mm-dd', { 'placeholder': 'yyyy-mm-dd' })
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

        })
    </script>

</asp:Content>

