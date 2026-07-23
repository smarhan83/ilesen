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

            <div class="body flex-grow-1 px-3" runat="server" visible="false">
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

            <section class="admin-main">
                <!-- Topbar -->
                <div class="topbar mb-4">
                <div class="d-flex align-items-center gap-2">
                    <span class="badge-soft"><i class="bi bi-speedometer2 me-1"></i>Dashboard</span>
                    <span class="small text-muted d-none d-md-inline">Ringkasan sistem ProLesen</span>
                </div>

                <div class="search-wrap">
                    <i class="bi bi-search"></i>
                    <input type="text" class="form-control searchInput" placeholder="Cari permohonan / lesen / pengguna...">
                </div>

                <%--<!-- Profile Dropdown -->
                <div class="dropdown">
                    <div class="profile-btn" data-bs-toggle="dropdown" aria-expanded="false">
                    <img src="https://i.pravatar.cc/100?img=12" alt="Profile">
                    <div class="d-none d-md-block">
                        <div class="profile-name">Admin ProLesen</div>
                        <div class="profile-role">MPK Kluang</div>
                    </div>
                    <i class="bi bi-chevron-down ms-1 text-muted"></i>
                    </div>

                    <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0" style="border-radius:18px;">
                    <li>
                        <a class="dropdown-item py-2" href="#">
                        <i class="bi bi-person-circle me-2"></i>Lihat Profil Pengguna
                        </a>
                    </li>
                    <li>
                        <a class="dropdown-item py-2" href="#">
                        <i class="bi bi-bell me-2"></i>Notifikasi
                        <span class="badge text-bg-primary ms-2">3</span>
                        </a>
                    </li>
                    <li><hr class="dropdown-divider"></li>
                    <li>
                        <a class="dropdown-item py-2 text-danger" href="#" id="btnLogoutTop">
                        <i class="bi bi-box-arrow-right me-2"></i>Log Keluar
                        </a>
                    </li>
                    </ul>
                </div>--%>

                </div>


            </section>

            <!-- Dashboard Cards -->
            <asp:SqlDataSource ID="sdsCountStatus" runat="server" ConnectionString="<%$ ConnectionStrings:webcon_ConnectionStr %>"
            SelectCommand="
            SELECT
                COUNT(DISTINCT a.Permohonan_ID) AS TotalPermohonan,
                SUM(CASE WHEN a.ApprStatusID IN (1,2,3,4,5,7,8) THEN 1 ELSE 0 END) AS TotalDalamProses,
                SUM(CASE WHEN a.ApprStatusID = 10 THEN 1 ELSE 0 END) AS Diluluskan,
                SUM(CASE WHEN a.ApprStatusID IN (6,9) THEN 1 ELSE 0 END) AS Ditolak
            FROM
            (
                SELECT Permohonan_ID, ApprStatusID, AgensiID
                FROM v_LESEN_ApprovalList_Curr

                UNION ALL

                SELECT Permohonan_ID, ApprStatusID, AgensiID
                FROM v_LESEN_ApprovalListBatal_Curr
            ) a
            WHERE IIF(@AgensiID = 0 OR @AgensiID = 1,0,@AgensiID) =
                    IIF(@AgensiID = 0 OR @AgensiID = 1,0,a.AgensiID)
            AND a.ApprStatusID &lt;&gt; 0
            ">
            <SelectParameters>
            <asp:SessionParameter SessionField="sessionEstateID" Name="AgensiID"></asp:SessionParameter>
            </SelectParameters>
            </asp:SqlDataSource>

            <div class="row g-4 mb-4">
            <div class="col-md-6 col-xl-3">
                <div class="stat-card">
                <div class="stat-top">
                    <span class="badge-soft"><i class="bi bi-file-earmark-text me-1"></i>Permohonan</span>
                    <i class="bi bi-three-dots text-muted"></i>
                </div>
                
                <h3>
                    <asp:FormView ID="FormView5" runat="server" DataSourceID="sdsCountStatus">
                        <ItemTemplate>
                            <%# Eval("TotalPermohonan") %>
                        </ItemTemplate>
                    </asp:FormView>
                </h3>
                <p>Jumlah permohonan / pembatalan</p>
                </div>
            </div>

            <div class="col-md-6 col-xl-3">
                <div class="stat-card">
                <div class="stat-top">
                    <span class="badge-soft"><i class="bi bi-hourglass-split me-1"></i>Dalam Proses</span>
                    <i class="bi bi-three-dots text-muted"></i>
                </div>
                <h3>
                    <asp:FormView ID="FormView6" runat="server" DataSourceID="sdsCountStatus">
                        <ItemTemplate>
                            <%# Eval("TotalDalamProses") %>
                        </ItemTemplate>
                    </asp:FormView>
                </h3>
                <p>Menunggu semakan / tindakan</p>
                </div>
            </div>

            <div class="col-md-6 col-xl-3">
                <div class="stat-card">
                <div class="stat-top">
                    <span class="badge-soft"><i class="bi bi-patch-check me-1"></i>Diluluskan</span>
                    <i class="bi bi-three-dots text-muted"></i>
                </div>
                <h3>
                    <asp:FormView ID="FormView7" runat="server" DataSourceID="sdsCountStatus">
                        <ItemTemplate>
                            <%# Eval("Diluluskan") %>
                        </ItemTemplate>
                    </asp:FormView>
                </h3>
                <p>Permohonan/pembatalan diluluskan</p>
                </div>
            </div>

            <div class="col-md-6 col-xl-3">
                <div class="stat-card">
                <div class="stat-top">
                    <span class="badge-soft"><i class="bi bi-x-circle me-1"></i>Ditolak</span>
                    <i class="bi bi-three-dots text-muted"></i>
                </div>
                <h3>
                    <asp:FormView ID="FormView8" runat="server" DataSourceID="sdsCountStatus">
                        <ItemTemplate>
                            <%# Eval("Ditolak") %>
                        </ItemTemplate>
                    </asp:FormView>
                </h3>
                <p>Perlu pembetulan / semakan</p>
                </div>
            </div>
            </div>

            <!-- =======================
            Charts Section
            ======================= -->
            <div class="row g-4 mt-4">

                <!-- Bar Chart -->
                <div class="col-xl-6">
                <div class="soft-card p-4">
                    <div class="section-title">Bar Chart - Permohonan Bulanan (Tahun Semasa)</div>
                    <div style="position: relative; height: 300px;">
				                <canvas id="barMonthly"></canvas>
                    </div>
                </div>
                </div>

                <!-- Pie Chart -->
                <div class="col-xl-6">
                <div class="soft-card p-4">
                    <div class="section-title">Pie Chart - Status Permohonan (Tahun Semasa)</div>
                    <div style="position: relative; height: 300px;">
				                <canvas id="pieStatus"></canvas>
                    </div>
                </div>
                </div>

                <!-- Line Chart -->
                <div class="col-xl-12">
                <div class="soft-card p-4">
                    <div class="section-title">Line Chart - Kelulusan Harian (Bulan Semasa)</div>
                    <div style="position: relative; height: 300px;">
				                <canvas id="lineDaily"></canvas>
                    </div>
                </div>
                </div>

<%--                <!-- Scatter Chart -->
                <div class="col-xl-6">
                <div class="soft-card p-4">
                    <div class="section-title">Scatter Chart - Proses vs Masa</div>
                    <div style="position: relative; height: 300px;">
				                <canvas id="scatterProcess"></canvas>
                    </div>
                </div>
                </div>--%>

   <%--             <!-- Radar Chart -->
                <div class="col-xl-6">
                <div class="soft-card p-4">
                    <div class="section-title">Radar Chart - Skor Jabatan</div>
                    <div style="position: relative; height: 300px;">
				                <canvas id="radarDept"></canvas>
                    </div>
                </div>
                </div>
			  
            <div class="col-xl-6">
                <div class="soft-card p-4">
                <div class="section-title">Doughnut Chart - Kategori</div>
                <div style="position: relative; height: 300px;">
                    <canvas id="doughnutCategory"></canvas>
                </div>
                </div>
            </div>--%>
			  

            </div>

            <!-- Activity + Table -->
            <div class="row g-4 mt-4">
            <div class="col-xl-7">
                <div class="soft-card p-4">
                <div class="d-flex justify-content-between align-items-start flex-wrap gap-2">
                    <div>
                    <div class="section-title">Aktiviti Terkini</div>
                    <p class="section-subtitle">Log ringkas untuk pemantauan</p>
                    </div>
                    <button class="btn btn-soft btn-sm"><i class="bi bi-arrow-repeat me-1"></i>Refresh</button>
                </div>

                <div class="mt-3">
                    <div class="d-flex align-items-start gap-3 py-2">
                    <div class="feature-icon" style="width:38px;height:38px;border-radius:14px;">
                        <i class="bi bi-file-earmark-plus"></i>
                    </div>
                    <div>
                        <div style="font-weight:800;">Permohonan baru diterima</div>
                        <div class="small text-muted">No. Rujukan: PL-2026-00081 • 5 minit lepas</div>
                    </div>
                    </div>

                    <div class="d-flex align-items-start gap-3 py-2">
                    <div class="feature-icon" style="width:38px;height:38px;border-radius:14px;">
                        <i class="bi bi-patch-check"></i>
                    </div>
                    <div>
                        <div style="font-weight:800;">Kelulusan telah direkodkan</div>
                        <div class="small text-muted">No. Rujukan: PL-2026-00067 • 1 jam lepas</div>
                    </div>
                    </div>

                    <div class="d-flex align-items-start gap-3 py-2">
                    <div class="feature-icon" style="width:38px;height:38px;border-radius:14px;">
                        <i class="bi bi-bell"></i>
                    </div>
                    <div>
                        <div style="font-weight:800;">Notifikasi dihantar kepada pemohon</div>
                        <div class="small text-muted">3 notifikasi dihantar • Hari ini</div>
                    </div>
                    </div>

                </div>
                </div>
            </div>

            <div class="col-xl-5">
                <div class="soft-card p-4">
                <div class="d-flex justify-content-between align-items-start flex-wrap gap-2">
                    <div>
                    <div class="section-title">Permohonan Perlu Tindakan</div>
                    <p class="section-subtitle">Senarai ringkas untuk semakan</p>
                    </div>
                    <span class="badge-soft"><i class="bi bi-exclamation-triangle me-1"></i>Action</span>
                </div>

                <div class="table-responsive mt-3">
                    <table class="table mini-table align-middle">
                    <thead>
                        <tr class="text-muted small">
                        <th>Rujukan</th>
                        <th>Status</th>
                        <th class="text-end">Tindakan</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                        <td>
                            <div style="font-weight:800;">PL-2026-00081</div>
                            <div class="small text-muted">Premis Makanan</div>
                        </td>
                        <td><span class="badge text-bg-warning">Semak</span></td>
                        <td class="text-end">
                            <button class="btn btn-soft btn-sm"><i class="bi bi-eye me-1"></i>Lihat</button>
                        </td>
                        </tr>

                        <tr>
                        <td>
                            <div style="font-weight:800;">PL-2026-00079</div>
                            <div class="small text-muted">Perniagaan Runcit</div>
                        </td>
                        <td><span class="badge text-bg-info">Proses</span></td>
                        <td class="text-end">
                            <button class="btn btn-soft btn-sm"><i class="bi bi-eye me-1"></i>Lihat</button>
                        </td>
                        </tr>

                        <tr>
                        <td>
                            <div style="font-weight:800;">PL-2026-00073</div>
                            <div class="small text-muted">Lesen Iklan</div>
                        </td>
                        <td><span class="badge text-bg-danger">Pembetulan</span></td>
                        <td class="text-end">
                            <button class="btn btn-soft btn-sm"><i class="bi bi-eye me-1"></i>Lihat</button>
                        </td>
                        </tr>

                    </tbody>
                    </table>
                </div>

                </div>
            </div>
            </div>
            <% Else %>

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

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    $(document).ready(function () {
        // Bar Chart - Permohonan Bulanan
        new Chart(document.getElementById("barMonthly"), {
            type: "bar",
            data: {
                labels: ["Jan", "Feb", "Mar", "Apr", "Mei", "Jun", "Jul", "Ogos", "Sep", "Okt", "Nov", "Dis"],
                datasets: [{
                    label: "Jumlah Permohonan",
                    //data: [12, 19, 15, 25, 18, 22, 20, 30, 28, 24, 16, 10],
                    data: <%= MonthlyData %>,
                    backgroundColor: "#0ea5e9"
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: { y: { beginAtZero: true } }
            }
        });

        // Pie Chart - Status Permohonan
        new Chart(document.getElementById("pieStatus"), {
            type: "pie",
            data: {
                labels: ["Baru", "Proses", "Diluluskan", "Ditolak"],
                datasets: [{
                    //data: [50, 30, 70, 20],
                    data: <%= StatusData %>,
                    backgroundColor: ["#0ea5e9", "#0b3b7a", "#34d399", "#fb7185"]
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { position: 'bottom' } }
            }
        });

        // Line Chart - Kelulusan Harian
        new Chart(document.getElementById("lineDaily"), {
            type: "line",
            data: {
                labels: [
                    "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
                    "11", "12", "13", "14", "15", "16", "17", "18", "19", "20",
                    "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"
                ],
                datasets: [{
                    label: "Kelulusan",
                    data: <%= DailyData %>,
                    borderColor: "#34d399",
                    backgroundColor: "rgba(52,211,153,0.2)",
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { position: 'top' } },
                scales: {
                    x: {
                        title: {
                            display: true,
                            text: "HARI"
                        }
                    },
                    y: {
                        beginAtZero: true,
                        title: {
                            display: true,
                            text: "JUMLAH KELULUSAN"
                        }
                    }
                }
            }
        });

        // Scatter Chart - Proses vs Masa
        new Chart(document.getElementById("scatterProcess"), {
            type: "scatter",
            data: {
                datasets: [{
                    label: "Proses vs Masa",
                    data: [
                        { x: 1, y: 2 }, { x: 2, y: 3 }, { x: 3, y: 1 }, { x: 4, y: 4 }, { x: 5, y: 2 }
                    ],
                    backgroundColor: "#facc15"
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { position: 'top' } },
                scales: { x: { title: { display: true, text: "Masa (hari)" } }, y: { title: { display: true, text: "Proses" } } }
            }
        });

        // Radar Chart - Skor Jabatan
        new Chart(document.getElementById("radarDept"), {
            type: "radar",
            data: {
                labels: ["Jabatan A", "Jabatan B", "Jabatan C", "Jabatan D", "Jabatan E"],
                datasets: [{
                    label: "Skor",
                    data: [65, 59, 90, 81, 56],
                    fill: true,
                    backgroundColor: "rgba(59,130,246,0.2)",
                    borderColor: "#3b82f6",
                    pointBackgroundColor: "#3b82f6"
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { position: 'top' } },
                scales: { r: { beginAtZero: true } }
            }
        });

        new Chart(document.getElementById("doughnutCategory"), {
            type: "doughnut",
            data: {
                labels: ["Kategori A", "Kategori B", "Kategori C", "Kategori D"],
                datasets: [{
                    data: [25, 40, 20, 15],
                    backgroundColor: ["#f59e0b", "#10b981", "#3b82f6", "#ef4444"]
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { position: 'bottom' } }
            }
        });



    });
</script>

</asp:Content>


