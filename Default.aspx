<%@ Page Language="VB" MasterPageFile="~/MasterMenu.Master" AutoEventWireup="true" CodeFile="Default.aspx.vb" Inherits="_Default" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadContent" runat="Server">
        <%--<link rel="stylesheet" href="/assets/dist/css/adminlte.min.css" />--%>

    <style>

        .min-vh-100 {
        min-height: 75vh!important;
        }

        .card-title{
            color : #5046E5 !important;
        }

        .blink_me {
            animation: blinker 1s linear infinite;
        }

        @keyframes blinker {
            50% {
                opacity: 0;
            }
        }
        .bg-primary-login{
            background-color : #EDECFC !important;
        }		
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
    <%--    <!-- Content Wrapper. Contains page content -->
    <div class="content-wrapper">--%>




            <%  If Session.Item("sessionUsersId") > 0 Then %>

            <div class="body flex-grow-1 px-3">
            <div class="container-lg">
                <div class="fs-2 fw-semibold">Dashboard</div>
                <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-4">
                    <li class="breadcrumb-item">
                    <!-- if breadcrumb is single--><span>Home</span>
                    </li>
                    <li class="breadcrumb-item active"><span>Dashboard</span></li>
                </ol>
                </nav>

                <div class="row">
                <div class="col-xl-4" runat="server" id="idTopBox">
                    <div class="row" runat="server">

                    <!-- start total amount as at current date -->
                    <div class="col-lg-12">
                        <div class="card mb-4">
                        <div class="card-body p-4">
                            <div class="row">
                            <div class="col">
                                <div class="card-title fs-4 fw-semibold">Jumlah Bayaran</div>
                                <div class="card-subtitle text-disabled"><br /><br />As at <asp:Label ID="lblCurrDate" runat="server" Text=""></asp:Label></div>
                            </div>
                            <div class="col text-end text-primary fs-4 fw-semibold">
                                RM <asp:Label ID="lblTotAmtGraph1" runat="server" Text=""></asp:Label></div>
                            </div>
                        </div>
                        <div class="chart-wrapper mt-3" style="height:150px;">
                            <canvas class="chart" id="card-chart-new1" height="75"></canvas>
                        </div>
                        </div>
                    </div>
                    <!-- end total amount as at current date -->

                    
                    <div class="col-lg-6">
                        <div class="card mb-4">
                        <div class="card-body">
                            <div class="d-flex justify-content-between">
                            <div class="card-title text-disabled">Pemohon</div>
                            <div class="bg-primary bg-opacity-25 text-primary p-2 rounded">
                                <svg class="icon icon-xl">
                                <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-people"></use>
                                </svg>
                            </div>
                            </div>
                            <div class="fs-4 fw-semibold pb-3">
                                <asp:FormView ID="fvPemohon" runat="server" DataSourceID="sdsPemohon">
                                    <EditItemTemplate>
                                     
                                    </EditItemTemplate>
                                    <InsertItemTemplate>
                                       
                                    </InsertItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="cntLabel" runat="server" Text='<%# Bind("cnt") %>' />
                                    </ItemTemplate>
                                </asp:FormView>
                                <asp:SqlDataSource ID="sdsPemohon" runat="server" ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" SelectCommand="select count(*) as cnt from LESEN_Pemohon where Pemohon_IsActive = 1"></asp:SqlDataSource>
                            </div>
                            <%--<small class="text-danger">(-12.4%
                            <svg class="icon">
                                <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-arrow-bottom"></use>
                            </svg>)</small>--%>
                        </div>
                        </div>
                    </div>
                    <div class="col-lg-6">
                        <div class="card mb-4">
                        <div class="card-body">
                            <div class="d-flex justify-content-between">
                            <div class="card-title text-disabled">Permohonan</div>
                            <div class="bg-primary bg-opacity-25 text-primary p-2 rounded">
                                <svg class="icon icon-xl">
                                <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-description"></use>
                                </svg>
                            </div>
                            </div>
                            <div class="fs-4 fw-semibold pb-3">
                                <asp:FormView ID="fvPermohonan" runat="server" DataSourceID="sdsPermohonan">
                                    <EditItemTemplate>
                                     
                                    </EditItemTemplate>
                                    <InsertItemTemplate>
                                       
                                    </InsertItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="cntLabel" runat="server" Text='<%# Bind("cnt") %>' />
                                    </ItemTemplate>
                                </asp:FormView>
                                <asp:SqlDataSource ID="sdsPermohonan" runat="server" ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" 
                                SelectCommand="select count(*) as cnt from LESEN_Permohonan a
                                where StatusID NOT IN (0) 
                                and iif(@AgensiID = 0 or @AgensiID = 1,0,@AgensiID) = iif(@AgensiID = 0 or @AgensiID = 1,0,(select top 1 x2.AgensiID from LESEN_ApprovalList x2 where x2.agensiID = @AgensiID and x2.Permohonan_ID = a.Permohonan_ID))">
                                <SelectParameters>
                                <asp:SessionParameter SessionField="sessionEstateID" Name="AgensiID"></asp:SessionParameter>
                                </SelectParameters>
                                </asp:SqlDataSource>

                            </div>
                            <%--<small class="text-success">(17.2%
                            <svg class="icon">
                                <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-arrow-top"></use>
                            </svg>)</small>--%>
                        </div>
                        </div>
                    </div>
                    </div>
                </div>
                <div class="col-xl-8">
                    <div class="card mb-4">
                    <div class="card-body p-4">
                        <div class="card-title fs-4 fw-semibold">Permohonan</div>
                        <div class="card-subtitle text-disabled"><br /><br />
                                <asp:FormView ID="fvDateRange" runat="server" DataSourceID="sdsDateRange">
                                    <EditItemTemplate>
                                     
                                    </EditItemTemplate>
                                    <InsertItemTemplate>
                                       
                                    </InsertItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="startdt" runat="server" Text='<%# Bind("StartOfYear") %>' /> to 
                                        <asp:Label ID="Label1" runat="server" Text='<%# Bind("EndOfYear") %>' />
                                    </ItemTemplate>
                                </asp:FormView>
                                <asp:SqlDataSource ID="sdsDateRange" runat="server" ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>" 
                                SelectCommand="SELECT CONVERT(VARCHAR(12), DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0), 107) AS StartOfYear,
                                CONVERT(VARCHAR(12), DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1), 107) AS EndOfYear"></asp:SqlDataSource>

                        </div>
                        <div class="chart-wrapper" style="height:300px;margin-top:40px;">
                        <canvas class="chart" id="main-bar-chart" height="300"></canvas>
                        </div>
                    </div>
                    </div>
                </div>
                </div>

                <div class="row" runat="server" id="idTrafictJenis">
                    <div class="col-md-6">
                        <div class="card mb-4">
                            <div class="card-body p-4">
                                <div class="card-title fs-4 fw-semibold">Trafik</div>
                                <div class="card-subtitle text-disabled border-bottom mb-3 pb-4">
                                    <br />
                                    <br />
                                    Minggu Lepas</div>
                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="row border-bottom">
                                            <div class="col-6">
                                                <div class="border-start border-start-4 border-start-info px-3 mb-3">
                                                    <small class="text-medium-emphasis text-truncate">Permohonan Selesai</small>
                                                    <div class="fs-5 fw-semibold">
                                                        <asp:FormView ID="FormView1" runat="server" DataSourceID="sdsPemohonLulus">
                                                            <EditItemTemplate>
                                                            </EditItemTemplate>
                                                            <InsertItemTemplate>
                                                            </InsertItemTemplate>
                                                            <ItemTemplate>
                                                                <asp:Label ID="cntLabel" runat="server" Text='<%# Bind("cnt") %>' />
                                                            </ItemTemplate>
                                                        </asp:FormView>
                                                        <asp:SqlDataSource ID="sdsPemohonLulus" runat="server" ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                                                            SelectCommand="select count(*) as cnt 
                                    from LESEN_Permohonan a
                                    where (a.TarikhMohon &gt;= DATEADD(dd, -1, DATEADD(ww, DATEDIFF(ww, 0, GETDATE()) - 1, 0)) 
                                    and a.TarikhMohon &lt; DATEADD(dd,  6, DATEADD(ww, DATEDIFF(ww, 0, GETDATE()) - 1, 0)))
                                    and iif(@AgensiID = 0 or @AgensiID = 1,0,@AgensiID) = iif(@AgensiID = 0 or @AgensiID = 1,0,(select top 1 x2.AgensiID from LESEN_ApprovalList x2 where x2.agensiID = @AgensiID and x2.Permohonan_ID = a.Permohonan_ID))
                                    and a.StatusID IN (9,10)">
                                                        <SelectParameters>
                                                        <asp:SessionParameter SessionField="sessionEstateID" Name="AgensiID"></asp:SessionParameter>
                                                        </SelectParameters>
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- /.col-->
                                            <div class="col-6">
                                                <div class="border-start border-start-4 border-start-danger px-3 mb-3">
                                                    <small class="text-medium-emphasis text-truncate">Permohonan Dalam Proses</small>
                                                    <div class="fs-5 fw-semibold">
                                                        <asp:FormView ID="FormView2" runat="server" DataSourceID="sdsPemohonDalamProses">
                                                            <EditItemTemplate>
                                                            </EditItemTemplate>
                                                            <InsertItemTemplate>
                                                            </InsertItemTemplate>
                                                            <ItemTemplate>
                                                                <asp:Label ID="cntLabel" runat="server" Text='<%# Bind("cnt") %>' />
                                                            </ItemTemplate>
                                                        </asp:FormView>
                                                        <asp:SqlDataSource ID="sdsPemohonDalamProses" runat="server" ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                                                            SelectCommand="select count(*) as cnt 
                                    from LESEN_Permohonan a
                                    where (a.TarikhMohon &gt;= DATEADD(dd, -1, DATEADD(ww, DATEDIFF(ww, 0, GETDATE()) - 1, 0)) 
                                    and a.TarikhMohon &lt; DATEADD(dd,  6, DATEADD(ww, DATEDIFF(ww, 0, GETDATE()) - 1, 0)))
                                    and iif(@AgensiID = 0 or @AgensiID = 1,0,@AgensiID) = iif(@AgensiID = 0 or @AgensiID = 1,0,(select top 1 x2.AgensiID from LESEN_ApprovalList x2 where x2.agensiID = @AgensiID and x2.Permohonan_ID = a.Permohonan_ID))
                                    and a.StatusID NOT IN (9,10)">
                                                        <SelectParameters>
                                                        <asp:SessionParameter SessionField="sessionEstateID" Name="AgensiID"></asp:SessionParameter>
                                                        </SelectParameters>
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- /.col-->
                                        </div>
                                        <!-- /.row-->

                                        <asp:Repeater ID="rptWeek" runat="server" DataSourceID="sdsWeek">
                                            <ItemTemplate>
                                                <div class="progress-group mb-4 pt-4 ">
                                                    <div class="progress-group-prepend">
                                                        <span class="text-disabled small">
                                                            <asp:Label ID="Label2" runat="server"
                                                                Text='<%#If(Eval("dayName") = "SUNDAY", "AHAD",
                                                                                            If(Eval("dayName") = "MONDAY", "ISNIN",
                                                                                            If(Eval("dayName") = "TUESDAY", "SELASA",
                                                                                            If(Eval("dayName") = "WEDNESDAY", "RABU",
                                                                                            If(Eval("dayName") = "THURSDAY", "KHAMIS", "OTHERS"))))) %>'></asp:Label></span>
                                                    </div>
                                                    <div class="progress-group-bars">
                                                        <div class="progress progress-thin">
                                                            <div class="progress-bar bg-info-gradient" role="progressbar" <%# "style='width : " + ((Eval("selesai") / (Eval("selesai") + Eval("takSelesai"))) * 100).ToString() + "%' aria-valuenow='" + ((Eval("selesai") / (Eval("selesai") + Eval("takSelesai"))) * 100).ToString() + "' " %> aria-valuemax="100"></div>
                                                        </div>
                                                        <div class="progress progress-thin">
                                                            <div class="progress-bar bg-danger-gradient" role="progressbar" <%# "style='width :" + ((Eval("takSelesai") / (Eval("selesai") + Eval("takSelesai"))) * 100).ToString() + "%' aria-valuenow='" + ((Eval("takSelesai") / (Eval("selesai") + Eval("takSelesai"))) * 100).ToString() + "' " %> aria-valuemin="0" aria-valuemax="100"></div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </ItemTemplate>
                                        </asp:Repeater>

                                        <asp:SqlDataSource runat="server" ID="sdsWeek" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' SelectCommand="select tbl1.dayName,
                            (select count(*) from LESEN_Permohonan a 
                            where (a.TarikhMohon &gt;= DATEADD(dd, -1, DATEADD(ww, DATEDIFF(ww, 0, GETDATE()) - 1, 0)) 
                            and a.TarikhMohon &lt; DATEADD(dd,  6, DATEADD(ww, DATEDIFF(ww, 0, GETDATE()) - 1, 0)))
                            and iif(@AgensiID = 0 or @AgensiID = 1,0,@AgensiID) = iif(@AgensiID = 0 or @AgensiID = 1,0,(select top 1 x2.AgensiID from LESEN_ApprovalList x2 where x2.agensiID = @AgensiID and x2.Permohonan_ID = a.Permohonan_ID))
                            and a.StatusID IN (9,10) and UPPER(datename(weekday,a.TarikhMohon)) = tbl1.dayName) as selesai,

                            (select count(*) from LESEN_Permohonan a 
                            where (a.TarikhMohon &gt;= DATEADD(dd, -1, DATEADD(ww, DATEDIFF(ww, 0, GETDATE()) - 1, 0)) 
                            and a.TarikhMohon &lt; DATEADD(dd,  6, DATEADD(ww, DATEDIFF(ww, 0, GETDATE()) - 1, 0)))
                            and iif(@AgensiID = 0 or @AgensiID = 1,0,@AgensiID) = iif(@AgensiID = 0 or @AgensiID = 1,0,(select top 1 x2.AgensiID from LESEN_ApprovalList x2 where x2.agensiID = @AgensiID and x2.Permohonan_ID = a.Permohonan_ID))
                            and a.StatusID NOT IN (9,10) and UPPER(datename(weekday,a.TarikhMohon)) = tbl1.dayName) as takSelesai

                            from (
                            select 'SUNDAY' as dayName union all select 'MONDAY' as dayName union all select 'TUESDAY' as dayName union all select 'WEDNESDAY' as dayName union all select 'THURSDAY' as dayName
                            ) tbl1">

                                        <SelectParameters>
                                        <asp:SessionParameter SessionField="sessionEstateID" Name="AgensiID"></asp:SessionParameter>
                                        </SelectParameters>
                                        </asp:SqlDataSource>



                                    </div>
                                    <!-- /.col-->

                                </div>
                                <!-- /.row-->
                            </div>

                        </div>
                    </div>


                    <div class="col-md-6">
                        <div class="card mb-4">
                            <div class="card-body p-4">
                                <div class="card-title fs-4 fw-semibold">Status Permohonan dan Pembatalan</div>
                                <div class="card-subtitle text-red border-bottom mb-2 pb-2">
                                    <br />
                                    <br />
                                    <div class="blink_me">Tugasan Saya - Belum Selesai</div>
                                </div>
                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="row border-bottom border-co">
                                            <div class="col-6">
                                                <div class="border-start border-start-4 border-start-info px-3 mb-3">
                                                    <a class="dropdown-item" href="<%= ResolveUrl("~/lesen/kelulusan.aspx?p_Id=3351&m_Id=3352") %>">
                                                        <small class="text-medium-emphasis text-truncate">Kelulusan - Pendaftaran</small>
                                                        <div class="fs-5 fw-semibold">
                                                            <asp:FormView ID="FormView3" runat="server" DataSourceID="sdsPemohonBaru">
                                                                <EditItemTemplate>
                                                                </EditItemTemplate>
                                                                <InsertItemTemplate>
                                                                </InsertItemTemplate>
                                                                <ItemTemplate>
                                                                    <asp:Label ID="cntLabel" runat="server" Text='<%# Bind("cnt") %>' />
                                                                </ItemTemplate>
                                                            </asp:FormView>
                                                            <asp:SqlDataSource ID="sdsPemohonBaru" runat="server" ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                                                                SelectCommand="SELECT count(*) as cnt FROM 
            v_LESEN_ApprovalList_Curr a
            inner join LESEN_JenisLesen d on d.JenisLesen_ID = a.JenisLesen_ID
            left join LESEN_JabatanAgensi e on e.JabatanAgensi_ID = a.AgensiID
            inner join LESEN_Pemohon f on f.Pemohon_ID = a.Permohonan_PemohonID
            inner join LESEN_Permohonan g on g.Permohonan_ID = a.Permohonan_ID
            where 1=1 and (
            a.ApprStatusID = case when @isPenyedia = 1 then 3 else 99 end 
            or a.ApprStatusID = case when @isPenilai = 1 then 2 else 99 end
            or a.ApprStatusID = case when @isPenilai = 1 then 5 else 99 end
            or a.ApprStatusID = case when @isPenilai = 1 then 4 else 99 end
            or a.ApprStatusID = case when @isPenilai = 1 and @isReadOnly = 1 and 1 = 2 then 6 else 99 end
            or a.ApprStatusID = case when @isPenilai = 1 and @isReadOnly = 1 and 1 = 2 then 7 else 99 end
            or a.ApprStatusID = case when @isPenilai = 1 and @isReadOnly = 1 and 1 = 2 then 8 else 99 end
            or a.ApprStatusID = case when @isPenilai = 1 and @isReadOnly = 1 and 1 = 2 then 9 else 99 end
            or a.ApprStatusID = case when @isPenilai = 1 and @isReadOnly = 1 and 1 = 2 then 10 else 99 end		
            or a.ApprStatusID = case when @isPeraku = 1 then 8 else 99 end
            
            )
            and case when isnull((select top 1 x.JabatanAgensi_IsLesen from LESEN_JabatanAgensi x where x.JabatanAgensi_ID = @AgensiID),0) = 1  then isnull(a.AgensiID,@AgensiID) else a.AgensiID end 
            = case when isnull((select top 1 x.JabatanAgensi_IsLesen from LESEN_JabatanAgensi x where x.JabatanAgensi_ID = @AgensiID),0) = 1  then @AgensiID else @AgensiID end                                 

            and case when a.ApprStatusID = 3 then @sessionUsersId else 0 end IN 
            (select x.PermohonanAgensiStaffID_UsersID 
            from LESEN_PermohonanAgensiStaff x 
            inner join LESEN_PermohonanAgensi x2 on x2.PermohonanAgensi_ID = x.PermohonanAgensi_ID
            where x2.Permohonan_ID = g.Permohonan_ID and x2.JabatanAgensi_ID = @AgensiID union all select 0  )">
                                                                <SelectParameters>
                                                                    <asp:SessionParameter SessionField="sessionEstateID" Name="AgensiID"></asp:SessionParameter>
                                                                    <asp:SessionParameter SessionField="sessionIsPenyedia" Name="isPenyedia"></asp:SessionParameter>
                                                                    <asp:SessionParameter SessionField="sessionIsPenilai" Name="isPenilai"></asp:SessionParameter>
                                                                    <asp:SessionParameter SessionField="sessionIsPeraku" Name="isPeraku"></asp:SessionParameter>
																	<asp:SessionParameter SessionField="sessionIsReadOnly" Name="isReadOnly"></asp:SessionParameter>
																	<asp:SessionParameter SessionField="sessionUsersId" Name="sessionUsersId"></asp:SessionParameter>
																	
                                                                </SelectParameters>
																
                                                            </asp:SqlDataSource>
                                                        </div>
                                                    </a>
                                                </div>
                                            </div>
                                            <!-- /.col-->
                                            <div class="col-6">
                                                <div class="border-start border-start-4 border-start-danger px-3 mb-3">
                                                    <a class="dropdown-item" href="<%= ResolveUrl("~/lesen/pembatalan.aspx?p_Id=3351&m_Id=4351") %>">
                                                        <small class="text-medium-emphasis text-truncate">Kelulusan - Pembatalan</small>
                                                        <div class="fs-5 fw-semibold">
                                                            <asp:FormView ID="FormView4" runat="server" DataSourceID="sdsPembatalanBaru">
                                                                <EditItemTemplate>
                                                                </EditItemTemplate>
                                                                <InsertItemTemplate>
                                                                </InsertItemTemplate>
                                                                <ItemTemplate>
                                                                    <asp:Label ID="cntLabel" runat="server" Text='<%# Bind("cnt") %>' />
                                                                </ItemTemplate>
                                                            </asp:FormView>
                                                            <asp:SqlDataSource ID="sdsPembatalanBaru" runat="server" ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
                                                                SelectCommand="SELECT count(*) as cnt FROM 
            v_LESEN_ApprovalListBatal_Curr a
            inner join LESEN_JenisLesen d on d.JenisLesen_ID = a.JenisLesen_ID
            left join LESEN_JabatanAgensi e on e.JabatanAgensi_ID = a.AgensiID
            inner join LESEN_Pemohon f on f.Pemohon_ID = a.Permohonan_PemohonID
            inner join LESEN_Permohonan g on g.Permohonan_ID = a.Permohonan_ID
            where 1=1 and (
            a.ApprStatusID = case when @isPenyedia = 1 then 3 else 99 end 
            or a.ApprStatusID = case when @isPenilai = 1 then 2 else 99 end
            or a.ApprStatusID = case when @isPenilai = 1 then 5 else 99 end
            or a.ApprStatusID = case when @isPenilai = 1 then 4 else 99 end
            or a.ApprStatusID = case when @isPenilai = 1 and @isReadOnly = 1 and 1 = 2 then 6 else 99 end
            or a.ApprStatusID = case when @isPenilai = 1 and @isReadOnly = 1 and 1 = 2 then 7 else 99 end
            or a.ApprStatusID = case when @isPenilai = 1 and @isReadOnly = 1 and 1 = 2 then 8 else 99 end
            or a.ApprStatusID = case when @isPenilai = 1 and @isReadOnly = 1 and 1 = 2 then 9 else 99 end
            or a.ApprStatusID = case when @isPenilai = 1 and @isReadOnly = 1 and 1 = 2 then 10 else 99 end			
            or a.ApprStatusID = case when @isPeraku = 1 then 8 else 99 end
            
            )
            and case when isnull((select top 1 x.JabatanAgensi_IsLesen from LESEN_JabatanAgensi x where x.JabatanAgensi_ID = @AgensiID),0) = 1 then isnull(a.AgensiID,@AgensiID) else a.AgensiID end 
            = case when isnull((select top 1 x.JabatanAgensi_IsLesen from LESEN_JabatanAgensi x where x.JabatanAgensi_ID = @AgensiID),0) = 1 then @AgensiID else @AgensiID end
                                              
            and case when a.ApprStatusID = 3 then @sessionUsersId else 0 end IN 
            (select x.PermohonanAgensiStaffID_UsersID 
            from LESEN_PermohonanAgensiStaffBatal x 
            inner join LESEN_PermohonanAgensiBatal x2 on x2.PermohonanAgensi_ID = x.PermohonanAgensi_ID
            where x2.Permohonan_ID = g.Permohonan_ID and x2.JabatanAgensi_ID = @AgensiID union all select 0  )">
                                                                <SelectParameters>
                                                                    <asp:SessionParameter SessionField="sessionEstateID" Name="AgensiID"></asp:SessionParameter>
                                                                    <asp:SessionParameter SessionField="sessionIsPenyedia" Name="isPenyedia"></asp:SessionParameter>
                                                                    <asp:SessionParameter SessionField="sessionIsPenilai" Name="isPenilai"></asp:SessionParameter>
                                                                    <asp:SessionParameter SessionField="sessionIsPeraku" Name="isPeraku"></asp:SessionParameter>
																	<asp:SessionParameter SessionField="sessionIsReadOnly" Name="isReadOnly"></asp:SessionParameter>
																	<asp:SessionParameter SessionField="sessionUsersId" Name="sessionUsersId"></asp:SessionParameter>
                                                                </SelectParameters>
                                                            </asp:SqlDataSource>
                                                        </div>
                                                    </a>
                                                </div>
                                            </div>
                                            <!-- /.col-->
                                        </div>
                                        <!-- /.row-->
                                        
                                <div class="card-subtitle text-disabled border-bottom mb-2 pb-2">
                                    <br />
                                    Pecahan Status Permohonan dan Pembatalan
                                </div>
                                        <asp:Repeater ID="Repeater4" runat="server" DataSourceID="sdsPermohonanStatus">
                                            <ItemTemplate>
                                                <div class="progress-group mb-2 pt-2 ">
                                                    <div class="progress-group-prepend">
                                                        <span class="text-disabled small">
                                                            <asp:Label ID="Label2" runat="server"
                                                                Text='<%#Eval("statusName") %>'></asp:Label></span>
                                                    </div>
                                                    <div class="progress-group-bars">
                                                        <div class="progress progress-thin">
                                                            <div class="progress-bar bg-info-gradient" role="progressbar" <%# "style='width : " + ((Eval("cntMohon") / Eval("cntMohonTtl")) * 100).ToString() + "%' aria-valuenow='" + ((Eval("cntMohon") / Eval("cntMohonTtl")) * 100).ToString() + "' " %> aria-valuemin="0" aria-valuemax="100"><%# Eval("cntMohon") %> (<%# CInt(((Eval("cntMohon") / Eval("cntMohonTtl")) * 100)).ToString() %>%)</div>
                                                        </div>
                                                        <div class="progress progress-thin">
                                                            <div class="progress-bar bg-danger-gradient" role="progressbar" <%# "style='width :" + ((Eval("cntBatal") / Eval("cntBatalTtl")) * 100).ToString() + "%' aria-valuenow='" + ((Eval("cntBatal") / Eval("cntBatalTtl")) * 100).ToString() + "' " %> aria-valuemin="0" aria-valuemax="100"><%# Eval("cntBatal") %> (<%# CInt(((Eval("cntBatal") / Eval("cntBatalTtl")) * 100)).ToString() %>%)</div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </ItemTemplate>
                                        </asp:Repeater>

                                        <asp:SqlDataSource runat="server" ID="sdsPermohonanStatus" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>' 
                                            SelectCommand="SELECT Description as statusName, sum(cnt1) as cntMohon, IIF(max(cnt1Ttl)=0,1,max(cnt1Ttl)) as cntMohonTtl, sum(cnt2) as cntBatal, IIF(max(cnt2Ttl)=0,1,max(cnt2Ttl)) as cntBatalTtl FROM
                                            (
	                                            SELECT ApprStatusID, Description, count(*) as cnt1,0 as cnt2,
	                                            (
		                                            SELECT count(*) as cnt1Ttl FROM 
		                                            v_LESEN_ApprovalList_Curr a
		                                            inner join LESEN_JenisLesen d on d.JenisLesen_ID = a.JenisLesen_ID
		                                            left join LESEN_JabatanAgensi e on e.JabatanAgensi_ID = a.AgensiID
		                                            inner join LESEN_Pemohon f on f.Pemohon_ID = a.Permohonan_PemohonID
		                                            where iif(@AgensiID = 0 or @AgensiID = 1,0,@AgensiID) = iif(@AgensiID = 0 or @AgensiID = 1,0,(select top 1 x2.AgensiID from LESEN_ApprovalList x2 where x2.agensiID = @AgensiID and x2.Permohonan_ID = a.Permohonan_ID)) 
	                                            ) cnt1Ttl, 0 as cnt2Ttl
	                                            FROM 
	                                            v_LESEN_ApprovalList_Curr a
	                                            inner join LESEN_JenisLesen d on d.JenisLesen_ID = a.JenisLesen_ID
	                                            left join LESEN_JabatanAgensi e on e.JabatanAgensi_ID = a.AgensiID
	                                            inner join LESEN_Pemohon f on f.Pemohon_ID = a.Permohonan_PemohonID
	                                            where iif(@AgensiID = 0 or @AgensiID = 1,0,@AgensiID) = iif(@AgensiID = 0 or @AgensiID = 1,0,(select top 1 x2.AgensiID from LESEN_ApprovalList x2 where x2.agensiID = @AgensiID and x2.Permohonan_ID = a.Permohonan_ID)) 
	                                            group by ApprStatusID, Description
	                                            union all
	                                            SELECT ApprStatusID, Description, 0 as cnt1, count(*) as cnt2, 0 as cnt1Ttl,
	                                            (
		                                            SELECT count(*) as cnt2Ttl FROM
		                                            v_LESEN_ApprovalListBatal_Curr a
		                                            inner join LESEN_JenisLesen d on d.JenisLesen_ID = a.JenisLesen_ID
		                                            left join LESEN_JabatanAgensi e on e.JabatanAgensi_ID = a.AgensiID
		                                            inner join LESEN_Pemohon f on f.Pemohon_ID = a.Permohonan_PemohonID
	                                            ) cnt2Ttl
	                                            FROM 
	                                            v_LESEN_ApprovalListBatal_Curr a
	                                            inner join LESEN_JenisLesen d on d.JenisLesen_ID = a.JenisLesen_ID
	                                            left join LESEN_JabatanAgensi e on e.JabatanAgensi_ID = a.AgensiID
	                                            inner join LESEN_Pemohon f on f.Pemohon_ID = a.Permohonan_PemohonID
	                                            where iif(@AgensiID = 0 or @AgensiID = 1,0,@AgensiID) = iif(@AgensiID = 0 or @AgensiID = 1,0,(select top 1 x2.AgensiID from LESEN_ApprovalList x2 where x2.agensiID = @AgensiID and x2.Permohonan_ID = a.Permohonan_ID)) 
	                                            group by ApprStatusID, Description
                                            ) tbl 
                                            group by ApprStatusID, Description
                                            order by ApprStatusID">

                                        <SelectParameters>
                                            <asp:SessionParameter SessionField="sessionIsPenyedia" DefaultValue="0" Name="isPenyedia"></asp:SessionParameter>
                                            <asp:SessionParameter SessionField="sessionIsPenilai" DefaultValue="0" Name="isPenilai"></asp:SessionParameter>
                                            <asp:SessionParameter SessionField="sessionIsPeraku" DefaultValue="0" Name="isPeraku"></asp:SessionParameter>
                                            <asp:SessionParameter SessionField="sessionEstateID" DefaultValue="0" Name="AgensiID"></asp:SessionParameter>
                                            <asp:SessionParameter SessionField="sessionUsersId" DefaultValue="0" Name="sessionUsersId"></asp:SessionParameter>		
                                        </SelectParameters>
                                        </asp:SqlDataSource>



                                    </div>
                                    <!-- /.col-->

                                </div>
                                <!-- /.row-->
                            </div>

                        </div>
                    </div>
                    <!-- /.col-->
                </div>
                <!-- /.row-->

                <div class="row" runat="server" id="idJenisLesen">
                    <div class="col-md-4">
                        <div class="card mb-4">
                            <div class="card-body p-4">
                                <div class="card-title fs-5 fw-semibold">Jenis Lesen - Telah Lulus</div>
                                <div class="card-subtitle text-disabled border-bottom mb-3 pb-4">
                                    <br />
                                    <br />
                                    Bulanan</div>
                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="row">

                                            <!-- /.col-->
                                            <div class="col-6">
                                                <%--<div class="border-start border-start-4 border-start-success px-3 mb-3"><small class="text-medium-emphasis text-truncate">Selesai</small>
                                <div class="fs-5 fw-semibold">49.123</div>
                                </div>--%>
                                                <%--<br /><br />--%>
                                            </div>
                                            <div class="col-6">
                                                <%--   <div class="border-start border-start-4 border-start-danger px-3 mb-3"><small class="text-medium-emphasis text-truncate">Belum Selesai</small>
                                <div class="fs-5 fw-semibold">78.623</div>
                                </div>--%>
                                                <%--<br /><br />--%>
                                            </div>
                                            <!-- /.col-->
                                        </div>
                                        <!-- /.row-->

                                        <%--                            <div class="progress-group">
                            <div class="progress-group-header">
                                <svg class="icon icon-lg me-2">
                                <use xlink:href="vendors/@coreui/icons/svg/brand.svg#cib-google"></use>
                                </svg>
                                <div>LESEN PERNIAGAAN</div>
                                <div class="ms-auto fw-semibold me-2">191</div>
                                <div class="text-disabled small">(56%)</div>
                            </div>
                            <div class="progress-group-bars">
                                <div class="progress progress-thin">
                                <div class="progress-bar bg-success-gradient" role="progressbar" style="width: 56%" aria-valuenow="56" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                            </div>
                            </div>--%>

                                        <asp:Repeater ID="Repeater1" runat="server" DataSourceID="sdsJenisLesen">
                                            <ItemTemplate>

                                                <div class="progress-group">
                                                    <div class="progress-group-header">
                                                        <svg class="icon icon-lg me-2">
                                                            <use xlink:href="vendors/@coreui/icons/svg/brand.svg#cib-google"></use>
                                                        </svg>
                                                        <div>
                                                            <asp:Label ID="lblJenis" runat="server" Text='<%# Eval("JenisLesen_Description") %>' /></div>
                                                        <div class="ms-auto fw-semibold me-2">
                                                            <asp:Label ID="Label3" runat="server" Text='<%# Eval("totPerniagaan") %>' /></div>
                                                        <div class="text-disabled small">(<asp:Label ID="Label4" runat="server" Text='<%# CInt((Eval("totPerniagaan") / Eval("totAllPerniagaan")) * 100) %>' />%)</div>
                                                    </div>
                                                    <div class="progress-group-bars">
                                                        <div class="progress progress-thin">
                                                            <div class="progress-bar bg-success-gradient" role="progressbar" <%# "style='width :" + ((Eval("totPerniagaan") / (Eval("totAllPerniagaan"))) * 100).ToString() + "%' aria-valuenow='" + ((Eval("totPerniagaan") / (Eval("totAllPerniagaan"))) * 100).ToString() + "' " %> aria-valuemin="0" aria-valuemax="100"></div>
                                                        </div>
                                                    </div>
                                                </div>

                                            </ItemTemplate>
                                        </asp:Repeater>

                                        <asp:SqlDataSource runat="server" ID="sdsJenisLesen" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            SelectCommand="select JenisLesen_Description,totPerniagaan,case when totAllPerniagaan = 0 then 1 else totAllPerniagaan end as totAllPerniagaan
                                            from (select a.JenisLesen_Description,
                                            (select count(*) from LESEN_Permohonan x 
                                            where x.JenisLesen_ID = a.JenisLesen_ID and year(x.TarikhMohon) = year(getdate()) and month(x.TarikhMohon) = month(getdate()) and x.StatusID=10
                                            and iif(@AgensiID = 0 or @AgensiID = 1,0,@AgensiID) = iif(@AgensiID = 0 or @AgensiID = 1,0,(select top 1 x2.AgensiID from LESEN_ApprovalList x2 where x2.agensiID = @AgensiID and x2.Permohonan_ID = x.Permohonan_ID))
                                            ) as totPerniagaan,

                                            (select count(*) from LESEN_Permohonan x 
                                            where year(x.TarikhMohon) = year(getdate()) and month(x.TarikhMohon) = month(getdate()) and x.StatusID=10
                                            and iif(@AgensiID = 0 or @AgensiID = 1,0,@AgensiID) = iif(@AgensiID = 0 or @AgensiID = 1,0,(select top 1 x2.AgensiID from LESEN_ApprovalList x2 where x2.agensiID = @AgensiID and x2.Permohonan_ID = x.Permohonan_ID)) 
                                            ) as totAllPerniagaan
                                            from LESEN_JenisLesen a
                                            where a.JenisLesen_IsActive=1 ) as tbl1">


                                        <SelectParameters>
                                            <asp:SessionParameter SessionField="sessionIsPenyedia" DefaultValue="0" Name="isPenyedia"></asp:SessionParameter>
                                            <asp:SessionParameter SessionField="sessionIsPenilai" DefaultValue="0" Name="isPenilai"></asp:SessionParameter>
                                            <asp:SessionParameter SessionField="sessionIsPeraku" DefaultValue="0" Name="isPeraku"></asp:SessionParameter>
                                            <asp:SessionParameter SessionField="sessionEstateID" DefaultValue="0" Name="AgensiID"></asp:SessionParameter>
                                            <asp:SessionParameter SessionField="sessionUsersId" DefaultValue="0" Name="sessionUsersId"></asp:SessionParameter>		
                                        </SelectParameters>
                                        </asp:SqlDataSource>

                                    </div>
                                    <!-- /.col-->
                                </div>
                            </div>

                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="card mb-4">
                            <div class="card-body p-4">
                                <div class="card-title fs-5 fw-semibold">Tempoh Kelulusan Lesen &lt; 14 Hari</div>
                                <div class="card-subtitle text-disabled border-bottom mb-3 pb-4">
                                    <br />
                                    <br />
                                    Bulanan
                                </div>
                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="row">
                                            <!-- /.col-->
                                            <div class="col-6">
                                            </div>
                                            <div class="col-6">
                                            </div>
                                            <!-- /.col-->
                                        </div>
                                        <!-- /.row-->

                                        <asp:Repeater ID="Repeater2" runat="server" DataSourceID="sdsTempohProsesLesen">
                                            <ItemTemplate>

                                                <div class="progress-group">
                                                    <div class="progress-group-header">
                                                        <svg class="icon icon-lg me-2">
                                                            <use xlink:href="vendors/@coreui/icons/svg/brand.svg#cib-google"></use>
                                                        </svg>
                                                        <div>
                                                            <asp:Label ID="lblJenis" runat="server" Text='<%# Eval("JenisLesen_Description") %>' />
                                                        </div>
                                                        <div class="ms-auto fw-semibold me-2">
                                                            <asp:Label ID="Label3" runat="server" Text='<%# Eval("totStatPerniagaan") %>' />
                                                        </div>
                                                        <div class="text-disabled small">(<asp:Label ID="Label4" runat="server" Text='<%# CInt((Eval("totStatPerniagaan") / Eval("totPerniagaan")) * 100) %>' />%)</div>
                                                    </div>
                                                    <div class="progress-group-bars">
                                                        <div class="progress progress-thin">
                                                            <div class="progress-bar bg-info-gradient" role="progressbar" <%# "style='width :" + ((Eval("totStatPerniagaan") / (Eval("totPerniagaan"))) * 100).ToString() + "%' aria-valuenow='" + ((Eval("totStatPerniagaan") / (Eval("totPerniagaan"))) * 100).ToString() + "' " %> aria-valuemin="0" aria-valuemax="100"></div>
                                                        </div>
                                                    </div>
                                                </div>

                                            </ItemTemplate>
                                        </asp:Repeater>

                                        <asp:SqlDataSource runat="server" ID="sdsTempohProsesLesen" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            SelectCommand="select JenisLesen_Description, totStatPerniagaan as totStatPerniagaan,
	                                        case when totPerniagaan = 0 then 1 else totPerniagaan end as totPerniagaan
	                                        from (select a.JenisLesen_Description,

	                                        (select count(*) from LESEN_Permohonan x where x.JenisLesen_ID = a.JenisLesen_ID and year(x.TarikhMohon) = year(getdate()) and month(x.TarikhMohon) = month(getdate())
                                            and iif(@AgensiID = 0 or @AgensiID = 1,0,@AgensiID) = iif(@AgensiID = 0 or @AgensiID = 1,0,(select top 1 x2.AgensiID from LESEN_ApprovalList x2 where x2.agensiID = @AgensiID and x2.Permohonan_ID = x.Permohonan_ID))
	                                        and x.StatusID=10 and DATEDIFF(DAY, (select TOP 1 ApprovalDate from LESEN_ApprovalList m where m.Permohonan_ID=x.Permohonan_ID and m.ApprStatusID=1),
	                                        (select TOP 1  ApprovalDate from LESEN_ApprovalList m where m.Permohonan_ID=x.Permohonan_ID and m.ApprStatusID=10))&lt;14) as totStatPerniagaan,

	                                        (select count(*) from LESEN_Permohonan x where x.JenisLesen_ID = a.JenisLesen_ID and year(x.TarikhMohon) = year(getdate()) and month(x.TarikhMohon) = month(getdate())
                                            and iif(@AgensiID = 0 or @AgensiID = 1,0,@AgensiID) = iif(@AgensiID = 0 or @AgensiID = 1,0,(select top 1 x2.AgensiID from LESEN_ApprovalList x2 where x2.agensiID = @AgensiID and x2.Permohonan_ID = x.Permohonan_ID))
	                                        and x.StatusID=10) as totPerniagaan
	                                        from LESEN_JenisLesen a
	                                        where a.JenisLesen_IsActive=1 ) as tbl1">

                                        <SelectParameters>
                                            <asp:SessionParameter SessionField="sessionIsPenyedia" DefaultValue="0" Name="isPenyedia"></asp:SessionParameter>
                                            <asp:SessionParameter SessionField="sessionIsPenilai" DefaultValue="0" Name="isPenilai"></asp:SessionParameter>
                                            <asp:SessionParameter SessionField="sessionIsPeraku" DefaultValue="0" Name="isPeraku"></asp:SessionParameter>
                                            <asp:SessionParameter SessionField="sessionEstateID" DefaultValue="0" Name="AgensiID"></asp:SessionParameter>
                                            <asp:SessionParameter SessionField="sessionUsersId" DefaultValue="0" Name="sessionUsersId"></asp:SessionParameter>		
                                        </SelectParameters>
                                        </asp:SqlDataSource>

                                    </div>
                                    <!-- /.col-->
                                </div>
                            </div>

                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="card mb-4">
                            <div class="card-body p-4">
                                <div class="card-title fs-5 fw-semibold">Tempoh Kelulusan Lesen &gt;= 14 Hari</div>
                                <div class="card-subtitle text-disabled border-bottom mb-3 pb-4">
                                    <br />
                                    <br />
                                    Bulanan
                                </div>
                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="row">
                                            <!-- /.col-->
                                            <div class="col-6">
                                            </div>
                                            <div class="col-6">
                                            </div>
                                            <!-- /.col-->
                                        </div>
                                        <!-- /.row-->

                                        <asp:Repeater ID="Repeater3" runat="server" DataSourceID="sdsTempohProsesLesen2">
                                            <ItemTemplate>

                                                <div class="progress-group">
                                                    <div class="progress-group-header">
                                                        <svg class="icon icon-lg me-2">
                                                            <use xlink:href="vendors/@coreui/icons/svg/brand.svg#cib-google"></use>
                                                        </svg>
                                                        <div>
                                                            <asp:Label ID="lblJenis" runat="server" Text='<%# Eval("JenisLesen_Description") %>' />
                                                        </div>
                                                        <div class="ms-auto fw-semibold me-2">
                                                            <asp:Label ID="Label3" runat="server" Text='<%# Eval("totStatPerniagaan") %>' />
                                                        </div>
                                                        <div class="text-disabled small">(<asp:Label ID="Label4" runat="server" Text='<%# CInt((Eval("totStatPerniagaan") / Eval("totPerniagaan")) * 100) %>' />%)</div>
                                                    </div>
                                                    <div class="progress-group-bars">
                                                        <div class="progress progress-thin">
                                                            <div class="progress-bar bg-danger-gradient" role="progressbar" <%# "style='width :" + ((Eval("totStatPerniagaan") / (Eval("totPerniagaan"))) * 100).ToString() + "%' aria-valuenow='" + ((Eval("totStatPerniagaan") / (Eval("totPerniagaan"))) * 100).ToString() + "' " %> aria-valuemin="0" aria-valuemax="100"></div>
                                                        </div>
                                                    </div>
                                                </div>

                                            </ItemTemplate>
                                        </asp:Repeater>

                                        <asp:SqlDataSource runat="server" ID="sdsTempohProsesLesen2" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            SelectCommand="select JenisLesen_Description, totStatPerniagaan as totStatPerniagaan,
	                                        case when totPerniagaan = 0 then 1 else totPerniagaan end as totPerniagaan
	                                        from (select a.JenisLesen_Description,

	                                        (select count(*) from LESEN_Permohonan x where x.JenisLesen_ID = a.JenisLesen_ID and year(x.TarikhMohon) = year(getdate()) and month(x.TarikhMohon) = month(getdate())
                                            and iif(@AgensiID = 0 or @AgensiID = 1,0,@AgensiID) = iif(@AgensiID = 0 or @AgensiID = 1,0,(select top 1 x2.AgensiID from LESEN_ApprovalList x2 where x2.agensiID = @AgensiID and x2.Permohonan_ID = x.Permohonan_ID))
	                                        and x.StatusID=10 and DATEDIFF(DAY, (select TOP 1 ApprovalDate from LESEN_ApprovalList m where m.Permohonan_ID=x.Permohonan_ID and m.ApprStatusID=1),
	                                        (select TOP 1  ApprovalDate from LESEN_ApprovalList m where m.Permohonan_ID=x.Permohonan_ID and m.ApprStatusID=10))&gt;=14) as totStatPerniagaan,

	                                        (select count(*) from LESEN_Permohonan x where x.JenisLesen_ID = a.JenisLesen_ID and year(x.TarikhMohon) = year(getdate()) and month(x.TarikhMohon) = month(getdate())
                                            and iif(@AgensiID = 0 or @AgensiID = 1,0,@AgensiID) = iif(@AgensiID = 0 or @AgensiID = 1,0,(select top 1 x2.AgensiID from LESEN_ApprovalList x2 where x2.agensiID = @AgensiID and x2.Permohonan_ID = x.Permohonan_ID))
	                                        and x.StatusID=10) as totPerniagaan
	                                        from LESEN_JenisLesen a
	                                        where a.JenisLesen_IsActive=1 ) as tbl1">

                                        <SelectParameters>
                                            <asp:SessionParameter SessionField="sessionIsPenyedia" DefaultValue="0" Name="isPenyedia"></asp:SessionParameter>
                                            <asp:SessionParameter SessionField="sessionIsPenilai" DefaultValue="0" Name="isPenilai"></asp:SessionParameter>
                                            <asp:SessionParameter SessionField="sessionIsPeraku" DefaultValue="0" Name="isPeraku"></asp:SessionParameter>
                                            <asp:SessionParameter SessionField="sessionEstateID" DefaultValue="0" Name="AgensiID"></asp:SessionParameter>
                                            <asp:SessionParameter SessionField="sessionUsersId" DefaultValue="0" Name="sessionUsersId"></asp:SessionParameter>		
                                        </SelectParameters>
                                        </asp:SqlDataSource>

                                    </div>
                                    <!-- /.col-->
                                </div>
                            </div>

                        </div>
                    </div>
                    <!-- /.col-->
                </div>
                <!-- /.row-->

                <div class="row" runat="server" id="listbyIKStaff">
                    <div class="col-md-12">
                        <div class="card mb-12">
                            <div class="card-body p-12">
                                <%--<div class="card-title fs-5 fw-semibold">Senarai Permohonan Dalam Proses Lawatan Tapak</div>
                                <div class="card-subtitle text-disabled border-bottom mb-3 pb-4">
                                    <br />
                                    <br />
                                    Bulanan
                                </div>--%>
                                <div class="card-title fs-4 fw-semibold">Senarai Permohonan Masih Dalam Proses Lawatan Tapak</div>
                                <br />
                                <br />
                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="row">
                                            <!-- /.col-->
                                            <div class="col-6">
                                            </div>
                                            <div class="col-6">
                                            </div>
                                            <!-- /.col-->
                                        </div>
                                        <!-- /.row-->

                                        <div class="table-responsive p-0">
                                            <table class="table align-items-center mb-0">
                                                <thead>
                                                    <tr>
                                                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Bil.</th>
                                                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">No. Rujukan</th>
                                                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Nama Pemohon</th>
                                                        <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Tarikh Mohon</th>
                                                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Staff Agensi</th>
                                                        <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Status</th>
                                                        <%--<th class="text-secondary opacity-7"></th>--%>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <asp:Repeater ID="Repeater7" runat="server" DataSourceID="sdsListStaffIK">
                                                        <ItemTemplate>
                                                            <tr>
                                                                <td class="align-middle text-center text-sm">
                                                                    <span class="text-secondary text-xs font-weight-bold"><%# DataBinder.Eval(Container, "ItemIndex", "") + 1%></span>
                                                                </td>
                                                                <td>
                                                                    <div class="d-flex px-2 py-1">
                                                                        <div>
                                                                            <%--<img src="../assets/img/team-2.jpg" class="avatar avatar-sm me-3 border-radius-lg" alt="user1">--%>
                                                                        </div>
                                                                        <div class="d-flex flex-column justify-content-center">
                                                                            <h6 class="mb-0 text-sm"><%# Eval("Rujukan") %></h6>
                                                                            <p class="text-xs text-secondary mb-0"><%# Eval("JenisLesen_Description") %></p>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <%--<span class="badge badge-sm bg-gradient-warning">Pending</span>--%>
                                                                    <span class="text-xs font-weight-bold mb-0"><%# Eval("Pemohon_Name") %></span>
                                                                </td>
                                                                <td class="align-middle text-center">
                                                                    <span class="text-secondary text-xs font-weight-bold"><%# Eval("TarikhMohon") %></span>
                                                                </td>
                                                                <td>
                                                                    <p class="text-xs font-weight-bold mb-0"><%# Eval("StaffName") %></p>
                                                                    <p class="text-xs text-secondary mb-0"><%# Eval("JabatanAgensi_Description") %></p>
                                                                </td>
                                                                <td class="align-middle text-center text-sm">
                                                                    <span class="badge badge-sm bg-gradient-warning">Belum Selesai</span>
                                                                </td>
                                                                <%--<td class="align-middle">
                                                                    <a href="javascript:;" class="text-secondary font-weight-bold text-xs" data-toggle="tooltip" data-original-title="View Details">View
                                                                    </a>
                                                                </td>--%>
                                                            </tr>
                                                        </ItemTemplate>
                                                    </asp:Repeater>
                                                </tbody>
                                            </table>
                                        </div>


                                        <asp:SqlDataSource runat="server" ID="sdsListStaffIK" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                            SelectCommand="SELECT F.Rujukan, G.JenisLesen_Description, D.PermohonanAgensiStaffID_UsersID, E.Users_Fullname AS StaffName, 
                                            convert(varchar, A.TarikhMohon, 103) AS TarikhMohon, 
                                            ApprovalID, A.Permohonan_ID, ApprStatusID, Description, ApprLevel, AgensiID, B.JabatanAgensi_Description, 
                                            ApproverID, ApprovalDate, IsComplete, IsFinalApproval, IsResult, Remarks, A.JenisLesen_ID, A.Permohonan_PemohonID, H.Pemohon_Name,
                                            A.NotaKelulusan
                                            FROM v_LESEN_ApprovalList_Curr A
                                            INNER JOIN LESEN_JabatanAgensi B ON A.AgensiID=B.JabatanAgensi_ID
                                            INNER JOIN LESEN_PermohonanAgensi C ON A.Permohonan_ID=C.Permohonan_ID AND A.AgensiID=C.JabatanAgensi_ID
                                            INNER JOIN LESEN_PermohonanAgensiStaff D ON C.PermohonanAgensi_ID=D.PermohonanAgensi_ID
                                            INNER JOIN TBL_USERS E ON D.PermohonanAgensiStaffID_UsersID=E.Users_Id
                                            INNER JOIN LESEN_Permohonan F ON A.Permohonan_ID=F.Permohonan_ID
                                            INNER JOIN LESEN_JenisLesen G ON A.JenisLesen_ID=G.JenisLesen_ID
                                            INNER JOIN LESEN_Pemohon H ON F.Permohonan_PemohonID=H.Pemohon_ID
                                            WHERE ApprStatusID=3
                                            and iif(@AgensiID = 0 or @AgensiID = 1,0,@AgensiID) = iif(@AgensiID = 0 or @AgensiID = 1,0,(select top 1 x2.AgensiID from LESEN_ApprovalList x2 where x2.agensiID = @AgensiID and x2.Permohonan_ID = A.Permohonan_ID))
                                            ORDER BY ApprovalID DESC">
                                            
                                            <SelectParameters>
                                            <asp:SessionParameter SessionField="sessionEstateID" Name="AgensiID"></asp:SessionParameter>
                                            </SelectParameters>
                                        </asp:SqlDataSource>

                                    </div>
                                    <!-- /.col-->
                                </div>
                            </div>

                        </div>
                    </div>
                    <!-- /.col-->
                </div>
                <!-- /.row-->



<!-- pie chart -->

                <div class="row" runat="server" id="Div1">
                    <div class="col-md-12">
                        <div class="card mb-12">
                            <div class="card-body p-12">
                        
                                <div class="card-title fs-4 fw-semibold">Statistic Permohonan Lesen</div>
                                <br />
                                <br />
                                <div class="row">
                                    <div class="col-sm-6">
                                        <div class="row">
                                            <!-- /.col-->
                                            <div class="col-6">
                                            </div>
                                            <div class="col-6">
                                            </div>
                                            <!-- /.col-->
                                        </div>
                                        <!-- /.row-->
                                   
                                  
                                         <div class="chart-wrapper" stye="width='25%'" >
                                         <canvas class="chart" id="pieChart" ></canvas>
                                         </div>
                          

                                    </div>
                                   
                                </div>
                            </div>

                        </div>
                    </div>
                 
                </div>

<!-- end of pie chart -->

            </div>
            </div>        

            <% Else %>

          
			<div class="bg-light d-flex flex-row align-items-center dark:bg-transparent" runat="server" visible="false">
				<div class="container">
				<div class="row justify-content-center">
					  <div class="col-lg-12 text-center">
						  <asp:Image ID="Image2" runat="server" Width="15%" ImageUrl="~/images/logo_mpk_new.png" />
					  </div>
				</div>
				</div>
			</div> 
           
            <div class="bg-light  d-flex flex-row align-items-center dark:bg-transparent">
                  <div class="container">
                    <div class="row justify-content-center">
                      <div class="col-lg-8">
                        <div class="card-group d-block d-md-flex row">

                          <div class="card col-md-5 text-white bg-primary-login py-5">
                            <div class="card-body text-center" runat="server" id="divLogoBig" >
                              <div>
                                <h2>&nbsp;</h2>
                                  <asp:Image ID="Image1" runat="server" ImageUrl="~/images/logo_mpk_new.png" Width="50%"/>
                                <p></p>
                                
                              </div>
                            </div>

                                      <br />
                        <div align="center">
                            <asp:Label ID="txtError" runat="server"
                                Style="font-weight: 700; color: #5046E5"></asp:Label>
               
                        </div>

                          </div>

                          <div class="card col-md-7 p-4 mb-0" runat="server" id="myForm">
                            <div class="card-body">
                              <h1>Log Masuk</h1>
                              <p class="text-medium-emphasis">Sila Masukkan Maklumat Anda</p>
                              <div class="input-group mb-3"><span class="input-group-text">
                                <svg class="icon">
                                <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-user"></use>
                                </svg></span>
                                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="ID Pengguna (cth : 910101014321 tanpa '-')"></asp:TextBox>
                                        
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
                                ControlToValidate="txtUsername" ErrorMessage="Sila Masukkan ID Pengguna" Display="none"></asp:RequiredFieldValidator>
                                <asp:ValidatorCalloutExtender ID="ce1" runat="server" TargetControlID="RequiredFieldValidator3">
                                </asp:ValidatorCalloutExtender>
                              </div>
                              <div class="input-group mb-4"><span class="input-group-text">

                                <svg class="icon">
                                <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-lock-locked"></use>
                                </svg></span>
                                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Katalaluan"></asp:TextBox>

                                <div class="input-group-append">  
                                <button id="show_password" class="btn btn-primary" type="button" onclick="myshowp()">  
                                <%--<span class="fa fa-eye-slash icon"></span>  --%>
                                <svg class="icon">
                                <use xlink:href="<%= ResolveUrl("~/vendors/@coreui/icons/svg/free.svg#cil-lock-unlocked") %>"></use>
                                </svg>
                                </button>  
                                </div>
                                

                               <script>
                                    function myshowp() {

                                        
                                        if (document.getElementById('<%= txtPassword.ClientID %>').type == "password") {
                                            document.getElementById('<%= txtPassword.ClientID %>').type = 'Text';
                                        }
                                        else {

                                            document.getElementById('<%= txtPassword.ClientID %>').type = 'password';
                                        }
                                        

                                    }

                               </script>
							   
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                                ControlToValidate="txtPassword" ErrorMessage="Sila Masukkan Katalaluan" Display="none"></asp:RequiredFieldValidator>
                                <asp:ValidatorCalloutExtender ID="ce2" runat="server" TargetControlID="RequiredFieldValidator2">
                                </asp:ValidatorCalloutExtender>
                              </div>
                              <div class="row">
                                <div class="col-6">
                      
                                    <asp:Button ID="btnLogin" runat="server" Text="Log Masuk" CssClass="btn btn-primary px-4" />
                                </div>
                                <div class="col-6 text-end">
                                  <%--<button class="btn btn-link px-0" type="button">Forgot password?</button>--%>
									<asp:LinkButton ID="lbFP" runat="server" CssClass="btn btn-link px-0 " ValidationGroup="frmFP">Lupa Katalaluan?</asp:LinkButton>								  
                                </div>
                              </div>
                            </div>
                          </div>
						  
                            <!-- forgot password -->
                            <div class="card col-md-7 p-4 mb-0" runat="server" id="myCheckAcc" visible="false">
                                <div class="card-body p-0">
                                    <!-- Nested Row within Card Body -->
                                    <div class="row">
                                
                                        <div class="col-lg-12" >
                                            <div class="p-5" style="/*background-image: linear-gradient(rgba(255,255,255,0.8), rgba(255,255,255,0.8)),url('../shop/img/1mrff logo.png');*/ background-repeat : no-repeat;background-position : center; ">

                                                <asp:FormView ID="fvFP" DefaultMode="Insert" Width="100%" runat="server" DataKeyNames="farmerID" DataSourceID="SqlDataSourceForm">
                                    
                                                    <InsertItemTemplate>
           
                                                        <div class="text-center">
                                                            <h2 class="h3 text-gray-900 mb-4">Pengesahan Akaun</h2>
                                                        </div>
                                                                                           


                                                        <div class="form-group row">
                                                            <div class="col-sm-12 mb-3 mb-sm-0">
                                                                <asp:TextBox AutoCompleteType="Disabled" Text='' class="form-control form-control-user" placeholder="Alamat Email *" runat="server" ID="Users_Email" />
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" ControlToValidate="Users_Email" CssClass="text-danger" runat="server" ErrorMessage="Sila masukkan alamat email!" ValidationGroup="insertForm" Display="Dynamic"></asp:RequiredFieldValidator>
                                                                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" CssClass="text-danger"
                                                                ControlToValidate="Users_Email" ErrorMessage="Alamat Email Tidak Sah"
                                                                ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                                                                ValidationGroup="insertForm" Display="Dynamic"></asp:RegularExpressionValidator>
                                                                <%--<asp:CustomValidator runat="server" OnServerValidate="EmailValidate" Display="Dynamic" ControlToValidate="Users_Email2" ID="vldEmail"></asp:CustomValidator>--%>

                                                            </div>
                                
                                                        </div>                                                 

                                        
                                                        <asp:LinkButton ID="btnCheckAcc" runat="server" Text="Semak" class="btn btn-success btn-lg btn-block" style="background-color:#0a9c18" ValidationGroup="insertForm" CausesValidation="True" OnClick="btnCheckAcc_Click"  />

                                                        <div class="center" style="text-align:center"><asp:Label ID="lblCheckAcc" runat="server" Text="" ></asp:Label></div>     
                                                        <asp:HiddenField ID="hfRegID" runat="server" />
                                                
                                                        <asp:LinkButton ID="btnEmailVerify" Visible="false" runat="server" Text="Resend Verification Link" class="btn btn-success btn-lg btn-block" style="background-color:#0a9c18" ValidationGroup="insertForm" CausesValidation="True" OnClick="btnEmailVerify_Click"  />

                                                        <asp:LinkButton ID="btnEmailReset" Visible="false" runat="server" Text="Reset Katalaluan" class="btn btn-success btn-lg btn-block" style="background-color:#0a9c18" ValidationGroup="insertForm" CausesValidation="True" OnClick="btnEmailReset_Click"  />
                                                
                                                    </InsertItemTemplate>
                                    
                                                </asp:FormView>

                                        <asp:SqlDataSource runat="server" ID="SqlDataSourceForm" ConnectionString='<%$ ConnectionStrings:webcon_ConnectionStr %>'
                                    
                                            InsertCommand="INSERT INTO TBL_USERS (Users_Name, Users_Fullname, Users_Password, Users_Email, Users_Enabled, Users_Register,Users_TelNo,Users_RegID,createdDate,estate_id,Users_Address) 
                                            VALUES (@Users_Email, @Users_Fullname, @Users_Password, @Users_Email, 0, 0,@Users_TelNo,@Users_RegID,getdate(),0,@Users_Address);
                                            SELECT @latestID = @@IDENTITY;
                                            INSERT INTO ECM_Buyers (Username,FullName,Email,Active,CreatorID,CreatedDt,LastModID,LastModDt,PhoneNo,UsersID)
                                            VALUES (@Users_Email,@Users_Fullname,@Users_Email,0,'regform',getdate(),'regform',getdate(),@Users_TelNo,@latestID);
                                            INSERT INTO TBL_USER_GROUPLIST (UGL_UGN_Id,UGL_Users_Id) VALUES (8,@latestID);
                                            ">
                                            <InsertParameters>
                                                <asp:Parameter Name="latestID" Type="Int32" Direction="Output" />  
                                                <asp:Parameter Name="Users_Name" />
                                                <asp:Parameter Name="Users_Fullname" />
                                                <asp:Parameter Name="Users_Password" />
                                                <asp:Parameter Name="Users_Email" />
                                                <asp:Parameter Name="Users_TelNo" />
                                                <asp:Parameter Name="Users_RegID" />
                                                <asp:Parameter Name="Users_Address" />
                                            </InsertParameters>
                                    
                                        </asp:SqlDataSource>                                        
                                
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>                            

                            <!-- end forgot password  -->						  

                        </div>
                      </div>
                    </div>
                  </div>
                </div>
    

				<br />

            <% End If%>
        


    <%--    </div>
    <!-- /.content-wrapper -->--%>
    <script>
        function pageLoad() {
            /*
            const doughnutChart = new Chart(document.getElementById('pieChart'), {
            type: 'doughnut',
            data: {
            labels: ['Red', 'Green', 'Yellow'],
            datasets: [{
            data: [300, 50, 100],
            backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56'],
            hoverBackgroundColor: ['#FF6384', '#36A2EB', '#FFCE56']
            }]
            },
            options: {
            responsive: true
            }
            });
            */

        }
    </script>

</asp:Content>


