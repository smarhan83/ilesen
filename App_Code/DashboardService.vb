Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.Collections.Generic
Imports System.Data
Imports System.Web.Script.Services
Imports System.Data.SqlClient
Imports System.Net.Sockets
Imports DocumentFormat.OpenXml.Bibliography

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
' <System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="http://tempuri.org/")>
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)>
<ScriptService>
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Public Class DashboardService
    Inherits System.Web.Services.WebService

    <WebMethod()>
    Public Function HelloWorld() As String
        Return "Hello World"
    End Function

#Region "getStatChartDataBunch"
    <WebMethod()>
    Public Function getStatChartDataBunch(ByVal year As String, ByVal EstateID As String) As List(Of Object)
        Dim iData As List(Of Object) = New List(Of Object)()
        Dim labels As List(Of String) = New List(Of String)()
        Dim lst_dataItem_1 As List(Of Integer) = New List(Of Integer)()
        Dim lst_dataItem_2 As List(Of Integer) = New List(Of Integer)()

        Dim dtLabels As DataTable
        dtLabels = GetDataBunch(year, EstateID)

        For Each drow As DataRow In dtLabels.Rows
            labels.Add(drow("s_mth").ToString)
            lst_dataItem_1.Add(CInt(drow("ttl_cur_yr")))
            lst_dataItem_2.Add(CInt(drow("ttl_last_yr")))
        Next
        iData.Add(labels)
        iData.Add(lst_dataItem_1)
        iData.Add(lst_dataItem_2)

        Return iData
    End Function

    Public Function GetDataBunch(ByVal strYear As String, ByVal EstateID As String) As DataTable
        Dim objMain As DALDashboard = New DALDashboard()
        Dim sTableName As String = "YieldStat"
        Dim iYear As Integer = Convert.ToInt32(strYear)
        objMain.LoadYieldStatBunchByYear(iYear, Convert.ToInt32(EstateID), sTableName)
        Return objMain.ds.Tables(sTableName)
    End Function
#End Region

#Region "getStatChartDataTonnage"
    <WebMethod()>
    Public Function getStatChartDataTonnage(ByVal year As String, ByVal EstateID As String) As List(Of Object)
        Dim iData As List(Of Object) = New List(Of Object)()
        Dim labels As List(Of String) = New List(Of String)()
        Dim lst_dataItem_1 As List(Of Integer) = New List(Of Integer)()
        Dim lst_dataItem_2 As List(Of Integer) = New List(Of Integer)()

        Dim dtLabels As DataTable
        dtLabels = GetDataTonnage(year, EstateID)

        For Each drow As DataRow In dtLabels.Rows
            labels.Add(drow("s_mth").ToString)
            lst_dataItem_1.Add(CInt(drow("ttl_cur_yr")))
            lst_dataItem_2.Add(CInt(drow("ttl_last_yr")))
        Next
        iData.Add(labels)
        iData.Add(lst_dataItem_1)
        iData.Add(lst_dataItem_2)

        Return iData
    End Function

    Public Function GetDataTonnage(ByVal strYear As String, ByVal EstateID As String) As DataTable
        Dim objMain As DALDashboard = New DALDashboard()
        Dim sTableName As String = "YieldStat"
        Dim iYear As Integer = Convert.ToInt32(strYear)
        objMain.LoadYieldStatTonnageByYear(iYear, Convert.ToInt32(EstateID), sTableName)
        Return objMain.ds.Tables(sTableName)
    End Function
#End Region

#Region "getStatChartBunchCount"
    <WebMethod()>
    Public Function getStatChartBunchCount(ByVal year As String, ByVal month As String, ByVal EstateID As String) As List(Of Object)
        Dim iData As List(Of Object) = New List(Of Object)()
        Dim labels As List(Of String) = New List(Of String)()
        Dim lst_dataItem_1 As List(Of Integer) = New List(Of Integer)()

        Dim dtLabels As DataTable
        dtLabels = GetDataBunchCount(year, month, EstateID)

        For Each dcol As DataColumn In dtLabels.Columns
            labels.Add(dcol.ColumnName)
            lst_dataItem_1.Add(CInt(dtLabels.Rows(0)(dcol.ColumnName)))
        Next
        iData.Add(labels)
        iData.Add(lst_dataItem_1)

        Return iData
    End Function

    Public Function GetDataBunchCount(ByVal strYear As String, ByVal strMonth As String, ByVal EstateID As String) As DataTable
        Dim objMain As DALDashboard = New DALDashboard()
        Dim sTableName As String = "BunchCount"
        Dim iYear As Integer = Convert.ToInt32(strYear)
        Dim iMonth As Integer = Convert.ToInt32(strMonth)
        objMain.LoadBunchCountByMonth(iYear, iMonth, Convert.ToInt32(EstateID), sTableName)
        Return objMain.ds.Tables(sTableName)
    End Function
#End Region

#Region "getStatCard"
    <WebMethod()>
    Public Function getStatCard(ByVal year As String, ByVal month As String, ByVal EstateID As String) As List(Of Object)
        Dim iData As List(Of Object) = New List(Of Object)()
        Dim labels As List(Of String) = New List(Of String)()
        Dim lst_dataItem_1 As List(Of Double) = New List(Of Double)()

        Dim dtLabels As DataTable
        dtLabels = GetDataCard(year, month, EstateID)

        For Each dcol As DataColumn In dtLabels.Columns
            labels.Add(dcol.ColumnName)
            lst_dataItem_1.Add(CDbl(dtLabels.Rows(0)(dcol.ColumnName)))
        Next
        iData.Add(labels)
        iData.Add(lst_dataItem_1)

        Return iData
    End Function

    Public Function GetDataCard(ByVal strYear As String, ByVal strMonth As String, ByVal EstateID As String) As DataTable
        Dim objMain As DALDashboard = New DALDashboard()
        Dim sTableName As String = "Card"
        Dim iYear As Integer = Convert.ToInt32(strYear)
        Dim iMonth As Integer = Convert.ToInt32(strMonth)
        objMain.LoadYieldStatCard(iYear, iMonth, Convert.ToInt32(EstateID), sTableName)
        Return objMain.ds.Tables(sTableName)
    End Function
#End Region

#Region "getStatTableOverallEstate"
    <WebMethod()>
    Public Function getStatTableOverallEstate(ByVal year As String, ByVal month As String) As List(Of Object)
        Dim iData As List(Of Object) = New List(Of Object)()
        Dim labels As List(Of String) = New List(Of String)()
        Dim lst_dataItem_1 As List(Of Integer) = New List(Of Integer)()

        Dim dtLabels As DataTable
        dtLabels = GetDataOverallEstate(year, month)

        'For Each dcol As DataColumn In dtLabels.Columns
        '    labels.Add(dcol.ColumnName)
        '    lst_dataItem_1.Add(CInt(dtLabels.Rows(0)(dcol.ColumnName)))
        'Next
        'iData.Add(labels)
        'iData.Add(lst_dataItem_1)

        '    For (Int() i = 0; i < dt.Rows.Count; i++)  
        '{  
        '    Student student = New Student();  
        '    student.StudentId = Convert.ToInt32(dt.Rows[i]["StudentId"]);  
        '    student.StudentName = dt.Rows[i]["StudentName"].ToString();  
        '    student.Address = dt.Rows[i]["Address"].ToString();  
        '    student.MobileNo = dt.Rows[i]["MobileNo"].ToString();  
        '    studentList.Add(student);  
        '}  

        For i As Integer = 0 To dtLabels.Rows.Count - 1
            Dim overallEstate As OverallEstate = New OverallEstate
            overallEstate.OCName = dtLabels.Rows(i)("OCNAME").ToString
            overallEstate.TonnageMonth = CDbl(dtLabels.Rows(i)("TtlTonByHectThisMth"))
            overallEstate.TonnageToDate = CDbl(dtLabels.Rows(i)("TtlTonByHectToDate"))
            overallEstate.AvgBwtMonth = CDbl(dtLabels.Rows(i)("TtlAvgBunchWeightThisMth"))
            overallEstate.AvgBwtToDate = CDbl(dtLabels.Rows(i)("TtlAvgBunchWeightToDate"))
            iData.Add(overallEstate)
        Next

        Return iData
    End Function

    Public Function GetDataOverallEstate(ByVal strYear As String, ByVal strMonth As String) As DataTable
        Dim objMain As DALDashboard = New DALDashboard()
        Dim sTableName As String = "OverallEstate"
        Dim iYear As Integer = Convert.ToInt32(strYear)
        Dim iMonth As Integer = Convert.ToInt32(strMonth)
        objMain.LoadOverallEstate(iYear, iMonth, sTableName)
        Return objMain.ds.Tables(sTableName)
    End Function
#End Region

#Region "getStatChartTotEmpByWorkerType"
    <WebMethod()>
    Public Function getStatChartTotEmpByWorkerType(ByVal EstateID As String) As List(Of Object)
        Dim iData As List(Of Object) = New List(Of Object)()
        Dim labels As List(Of String) = New List(Of String)()
        Dim lst_dataItem_1 As List(Of Integer) = New List(Of Integer)()
        Dim lst_dataItem_2 As List(Of Integer) = New List(Of Integer)()

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()


            Dim SQLSelect As String = "select count(*) as totEmp, UPPER(b.WorkTypeDesc) as WorkTypeDesc from  CREmployee a " &
            "left join WorkType b on b.WorkTypeID = a.WorkTypeID " &
            "where a.EstateID = @OCID And a.Active = 'Y' group by b.WorkTypeDesc"

            Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)

            myCommandSelect.Parameters.AddWithValue("@OCID", Convert.ToInt32(EstateID))

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            While myReader.Read

                labels.Add(myReader.Item("WorkTypeDesc").ToString)
                lst_dataItem_1.Add(CInt(myReader.Item("totEmp")))

            End While

            myReader.Close()

            myConnection.Close()

        End Using


        iData.Add(labels)
        iData.Add(lst_dataItem_1)
        'iData.Add(lst_dataItem_2)

        Return iData
    End Function

#End Region

#Region "getChartTotTicketByDepartment"
    <WebMethod()>
    Public Function getChartTotTicketByDepartment(ByVal ActYear As String, ByVal ActMonth As String, ByVal TicketType As String, ByVal TicketCategory As String) As List(Of Object)
        Dim iData As List(Of Object) = New List(Of Object)()
        Dim labels As List(Of String) = New List(Of String)()
        Dim lst_dataItem_1 As List(Of Integer) = New List(Of Integer)()
        'Dim lst_dataItem_2 As List(Of Integer) = New List(Of Integer)()
        'Dim lst_dataItem_3 As List(Of Integer) = New List(Of Integer)()

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()


            Dim SQLSelect As String = "select UPPER(a.DepartmentCode) as DepartmentCode,COUNT (*) as countTicket
            from HD_Ticket a
            inner join HD_Category b on a.categoryId=b.categoryId
            where year(a.createdDt) = (case when @year <> 9999 then @year else year(a.createdDt) end)
            and month(a.createdDt) = (case when @month <> 9999 then @month else month(a.createdDt) end)
            and (case when b.type= 'HD' then 1 when b.type='A' then 2 else 9999 end) = (case when @ticketType <> 9999 then @ticketType else (case when b.type= 'HD' then 1 when b.type='A' then 2 else 9999 end) end)
            and b.category = (case when @ticketCat <> '9999' then @ticketCat else b.category end)
            group by a.DepartmentCode "

            Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)

            myCommandSelect.Parameters.AddWithValue("@year", ActYear)
            myCommandSelect.Parameters.AddWithValue("@month", ActMonth)
            myCommandSelect.Parameters.AddWithValue("@ticketType", TicketType)
            myCommandSelect.Parameters.AddWithValue("@ticketCat", TicketCategory)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            While myReader.Read

                labels.Add(myReader.Item("DepartmentCode").ToString)
                lst_dataItem_1.Add(CInt(myReader.Item("countTicket")))
                'lst_dataItem_2.Add(CInt(myReader.Item("Hardware")))
                'lst_dataItem_3.Add(CInt(myReader.Item("Services")))

            End While

            myReader.Close()

            myConnection.Close()

        End Using


        iData.Add(labels)
        iData.Add(lst_dataItem_1)
        'iData.Add(lst_dataItem_2)
        'iData.Add(lst_dataItem_3)

        Return iData
    End Function

#End Region

#Region "getChartTotTicketMonthly"
    <WebMethod()>
    Public Function getChartTotTicketMonthly(ByVal ActYear As String, ByVal ActMonth As String, ByVal TicketType As String, ByVal TicketCategory As String) As List(Of Object)
        Dim iData As List(Of Object) = New List(Of Object)()
        Dim labels As List(Of String) = New List(Of String)()
        Dim lst_dataItem_1 As List(Of Integer) = New List(Of Integer)()
        Dim lst_dataItem_2 As List(Of Integer) = New List(Of Integer)()

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()


            Dim SQLSelect As String = "select * from (
            select 
            SUBSTRING(cast(year(a.createdDt) as varchar(50)),3,2)+'/'+cast(month(a.createdDt) as varchar(2)) as yearMonth,
			count (*) as countTicket
            from HD_Ticket a
            inner join HD_Category b on a.categoryId=b.categoryId
            where year(a.createdDt) = (case when @year <> 9999 then @year else year(a.createdDt) end)
            and month(a.createdDt) = (case when @month <> 9999 then @month else month(a.createdDt) end)
            and (case when b.type= 'HD' then 1 when b.type='A' then 2 else 9999 end) = (case when @ticketType <> 9999 then @ticketType else (case when b.type= 'HD' then 1 when b.type='A' then 2 else 9999 end) end)
            and b.category = (case when @ticketCat <> '9999' then @ticketCat else b.category end)
			group by year(a.createdDt),month(a.createdDt)) as tbl1
			group by yearMonth,countTicket"

            Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)

            myCommandSelect.Parameters.AddWithValue("@year", ActYear)
            myCommandSelect.Parameters.AddWithValue("@month", ActMonth)
            myCommandSelect.Parameters.AddWithValue("@ticketType", TicketType)
            myCommandSelect.Parameters.AddWithValue("@ticketCat", TicketCategory)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            While myReader.Read

                labels.Add(myReader.Item("yearMonth").ToString)
                lst_dataItem_1.Add(CInt(myReader.Item("countTicket")))

            End While

            myReader.Close()

            myConnection.Close()

        End Using


        iData.Add(labels)
        iData.Add(lst_dataItem_1)
        'iData.Add(lst_dataItem_2)

        Return iData
    End Function

#End Region

#Region "getChartTotTicketByCategory"
    <WebMethod()>
    Public Function getChartTotTicketByCategory(ByVal ActYear As String, ByVal ActMonth As String, ByVal TicketType As String, ByVal TicketCategory As String) As List(Of Object)
        Dim iData As List(Of Object) = New List(Of Object)()
        Dim labels As List(Of String) = New List(Of String)()
        Dim lst_dataItem_1 As List(Of Integer) = New List(Of Integer)()
        Dim lst_dataItem_2 As List(Of Integer) = New List(Of Integer)()

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()


            Dim SQLSelect As String = "select * from (
            select a.categoryId,a.category+' ('+( case when a.type = 'HD' then 'Non Asset' else 'Asset' end)+')' as type ,
            (select COUNT (*) from HD_Ticket x1
            inner join HD_Category x2 on x1.categoryId=x2.categoryId
            where year(x1.createdDt) = (case when @year <> 9999 then @year else year(x1.createdDt) end)
            and month(x1.createdDt) = (case when @month <> 9999 then @month else month(x1.createdDt) end)
            and x2.category+' ('+( case when x2.type = 'HD' then 'Non Asset' else 'Asset' end)+')'= a.category+' ('+( case when a.type = 'HD' then 'Non Asset' else 'Asset' end)+')'
            and x2.category = (case when @ticketCat <> '9999' then @ticketCat else x2.category end) ) as countTicket
            from HD_Category a
            ) as tbl1
            order by tbl1.countTicket desc "

            Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)

            myCommandSelect.Parameters.AddWithValue("@year", ActYear)
            myCommandSelect.Parameters.AddWithValue("@month", ActMonth)
            myCommandSelect.Parameters.AddWithValue("@ticketType", TicketType)
            myCommandSelect.Parameters.AddWithValue("@ticketCat", TicketCategory)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            While myReader.Read

                labels.Add(myReader.Item("type").ToString)
                lst_dataItem_1.Add(CInt(myReader.Item("countTicket")))

            End While

            myReader.Close()

            myConnection.Close()

        End Using


        iData.Add(labels)
        iData.Add(lst_dataItem_1)
        'iData.Add(lst_dataItem_2)

        Return iData
    End Function

#End Region

#Region "getChartTotTicketByPriority"
    <WebMethod()>
    Public Function getChartTotTicketByPriority(ByVal ActYear As String, ByVal ActMonth As String, ByVal TicketType As String, ByVal TicketCategory As String) As List(Of Object)
        Dim iData As List(Of Object) = New List(Of Object)()
        Dim labels As List(Of String) = New List(Of String)()
        Dim lst_dataItem_1 As List(Of Integer) = New List(Of Integer)()
        Dim lst_dataItem_2 As List(Of Integer) = New List(Of Integer)()

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQLSelect As String = "select priority, 
            (select CASE WHEN COUNT (*) > 0 THEN COUNT(*) ELSE 0 END from HD_Ticket x1
            inner join HD_Category x2 on x2.categoryId=x1.categoryId
            where year(x1.createdDt) = (case when @year <> 9999 then @year else year(x1.createdDt) end)
            and month(x1.createdDt) = (case when @month <> 9999 then @month else month(x1.createdDt) end)
            and (case when x2.type= 'HD' then 1 when x2.type='A' then 2 else 9999 end) = (case when @ticketType <> 9999 then @ticketType else (case when x2.type= 'HD' then 1 when x2.type='A' then 2 else 9999 end) end)
            and x2.category = (case when @ticketCat <> '9999' then @ticketCat else x2.category end)
            and x1.priorityId = a.priorityId ) as countTicket
            from HD_Priority a "

            Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)

            myCommandSelect.Parameters.AddWithValue("@year", ActYear)
            myCommandSelect.Parameters.AddWithValue("@month", ActMonth)
            myCommandSelect.Parameters.AddWithValue("@ticketType", TicketType)
            myCommandSelect.Parameters.AddWithValue("@ticketCat", TicketCategory)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            While myReader.Read

                labels.Add(myReader.Item("priority").ToString)
                lst_dataItem_1.Add(CInt(myReader.Item("countTicket")))

            End While

            myReader.Close()

            myConnection.Close()

        End Using


        iData.Add(labels)
        iData.Add(lst_dataItem_1)
        'iData.Add(lst_dataItem_2)

        Return iData
    End Function

#End Region

#Region "getChartTotTicketByPIC"
    <WebMethod()>
    Public Function getChartTotTicketByPIC(ByVal ActYear As String, ByVal ActMonth As String, ByVal TicketType As String, ByVal TicketCategory As String) As List(Of Object)
        Dim iData As List(Of Object) = New List(Of Object)()
        Dim labels As List(Of String) = New List(Of String)()
        Dim lst_dataItem_1 As List(Of Integer) = New List(Of Integer)()
        Dim lst_dataItem_2 As List(Of Integer) = New List(Of Integer)()

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQLSelect As String = "select b.EmpID,b.EmployeeName,COUNT (*) as countTicket
            from HD_Ticket a
            inner join Employees b on a.closeCaseId=b.EmpID
            inner join HD_Category c on a.categoryId=c.categoryId
            where year(a.createdDt) = (case when @year <> 9999 then @year else year(a.createdDt) end)
            and month(a.createdDt) = (case when @month <> 9999 then @month else month(a.createdDt) end)
            and (case when c.type= 'HD' then 1 when c.type='A' then 2 else 9999 end) = (case when @ticketType <> 9999 then @ticketType else (case when c.type= 'HD' then 1 when c.type='A' then 2 else 9999 end) end)
            and c.category = (case when @ticketCat <> '9999' then @ticketCat else c.category end)
            and a.verified = 'V'
            group by b.EmployeeName,b.EmpID "

            Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)

            myCommandSelect.Parameters.AddWithValue("@year", ActYear)
            myCommandSelect.Parameters.AddWithValue("@month", ActMonth)
            myCommandSelect.Parameters.AddWithValue("@ticketType", TicketType)
            myCommandSelect.Parameters.AddWithValue("@ticketCat", TicketCategory)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            While myReader.Read

                labels.Add(myReader.Item("EmployeeName").ToString)
                lst_dataItem_1.Add(CInt(myReader.Item("countTicket")))

            End While

            myReader.Close()

            myConnection.Close()

        End Using


        iData.Add(labels)
        iData.Add(lst_dataItem_1)
        'iData.Add(lst_dataItem_2)

        Return iData
    End Function

#End Region

#Region "getChartTotHardwareByCategory"
    <WebMethod()>
    Public Function getChartTotHardwareByCategory(ByVal ActYear As String, ByVal ActMonth As String, ByVal Department As String) As List(Of Object)
        Dim iData As List(Of Object) = New List(Of Object)()
        Dim labels As List(Of String) = New List(Of String)()
        Dim lst_dataItem_1 As List(Of Integer) = New List(Of Integer)()
        Dim lst_dataItem_2 As List(Of Integer) = New List(Of Integer)()

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQLSelect As String = "select a.TypeName,
            (select count(*) as countAsset from HD_Asset x1
			inner join Employees x2 on x1.AssetUser=x2.EmployeeName
            where x1.TypeID=a.TypeID
			and year(x1.createdDt) = (case when @year <> 9999 then @year else year(x1.createdDt) end)
            and month(x1.createdDt) = (case when @month <> 9999 then @month else month(x1.createdDt) end)
            and x2.DepartmentCode = (case when @department <> '9999' then '@department' else x2.DepartmentCode end)) as countAsset
            from HD_Type a
            inner join HD_Category b on a.categoryId=b.categoryId
            where b.category = 'Hardware' "

            Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)

            myCommandSelect.Parameters.AddWithValue("@year", ActYear)
            myCommandSelect.Parameters.AddWithValue("@month", ActMonth)
            myCommandSelect.Parameters.AddWithValue("@department", Department)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            While myReader.Read

                labels.Add(myReader.Item("TypeName").ToString)
                lst_dataItem_1.Add(CInt(myReader.Item("countAsset")))

            End While

            myReader.Close()

            myConnection.Close()

        End Using


        iData.Add(labels)
        iData.Add(lst_dataItem_1)
        'iData.Add(lst_dataItem_2)

        Return iData
    End Function

#End Region

#Region "getChartTotSoftwareByCategory"
    <WebMethod()>
    Public Function getChartTotSoftwareByCategory(ByVal ActYear As String, ByVal ActMonth As String, ByVal Department As String) As List(Of Object)
        Dim iData As List(Of Object) = New List(Of Object)()
        Dim labels As List(Of String) = New List(Of String)()
        Dim lst_dataItem_1 As List(Of Integer) = New List(Of Integer)()
        Dim lst_dataItem_2 As List(Of Integer) = New List(Of Integer)()

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQLSelect As String = "select a.TypeName,
            (select count(*) as countAsset from HD_Asset x1
			inner join Employees x2 on x1.AssetUser=x2.EmployeeName
            where x1.TypeID=a.TypeID
			and year(x1.createdDt) = (case when @year <> 9999 then @year else year(x1.createdDt) end)
            and month(x1.createdDt) = (case when @month <> 9999 then @month else month(x1.createdDt) end)
            and x2.DepartmentCode = (case when @department <> '9999' then @department else x2.DepartmentCode end)) as countAsset
            from HD_Type a
            inner join HD_Category b on a.categoryId=b.categoryId
            where b.category = 'Software' "

            Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)

            myCommandSelect.Parameters.AddWithValue("@year", ActYear)
            myCommandSelect.Parameters.AddWithValue("@month", ActMonth)
            myCommandSelect.Parameters.AddWithValue("@department", Department)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            While myReader.Read

                labels.Add(myReader.Item("TypeName").ToString)
                lst_dataItem_1.Add(CInt(myReader.Item("countAsset")))

            End While

            myReader.Close()

            myConnection.Close()

        End Using


        iData.Add(labels)
        iData.Add(lst_dataItem_1)
        'iData.Add(lst_dataItem_2)

        Return iData
    End Function

#End Region

#Region "getChartTotSoftwareOS"
    <WebMethod()>
    Public Function getChartTotSoftwareOS(ByVal ActYear As String, ByVal ActMonth As String, ByVal Department As String) As List(Of Object)
        Dim iData As List(Of Object) = New List(Of Object)()
        Dim labels As List(Of String) = New List(Of String)()
        Dim lst_dataItem_1 As List(Of Integer) = New List(Of Integer)()
        Dim lst_dataItem_2 As List(Of Integer) = New List(Of Integer)()

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQLSelect As String = "select ISNULL(a.Model,'No Version') as version,count(*) as countAsset from HD_Asset a
            inner join HD_SubCategory b on a.subCategoryId=b.subCategoryId
            inner join HD_Category c on a.categoryId=c.categoryId
            inner join Employees d on a.AssetUser=d.EmployeeName
            where b.subCategoryId = 10 and a.StatusAssetID in (1,2)
            and year(a.createdDt) = (case when @year <> 9999 then @year else year(a.createdDt) end)
            and month(a.createdDt) = (case when @month <> 9999 then @month else month(a.createdDt) end)
            and d.DepartmentCode = (case when @department <> '9999' then @department else d.DepartmentCode end)
            group by a.Model "

            Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)

            myCommandSelect.Parameters.AddWithValue("@year", ActYear)
            myCommandSelect.Parameters.AddWithValue("@month", ActMonth)
            myCommandSelect.Parameters.AddWithValue("@department", Department)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            While myReader.Read

                labels.Add(myReader.Item("version").ToString)
                lst_dataItem_1.Add(CInt(myReader.Item("countAsset")))

            End While

            myReader.Close()

            myConnection.Close()

        End Using


        iData.Add(labels)
        iData.Add(lst_dataItem_1)
        'iData.Add(lst_dataItem_2)

        Return iData
    End Function

#End Region

#Region "getChartTotSoftwareMOffice"
    <WebMethod()>
    Public Function getChartTotSoftwareMOffice(ByVal ActYear As String, ByVal ActMonth As String, ByVal Department As String) As List(Of Object)
        Dim iData As List(Of Object) = New List(Of Object)()
        Dim labels As List(Of String) = New List(Of String)()
        Dim lst_dataItem_1 As List(Of Integer) = New List(Of Integer)()
        Dim lst_dataItem_2 As List(Of Integer) = New List(Of Integer)()

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQLSelect As String = "select ISNULL(a.Model,'No Version') as version,count(*) as countAsset from HD_Asset a
            inner join HD_SubCategory b on a.subCategoryId=b.subCategoryId
            inner join HD_Category c on a.categoryId=c.categoryId
			inner join Employees d on a.AssetUser=d.EmployeeName
            where b.subCategoryId = 8 and a.StatusAssetID in (1,2)
			and year(a.createdDt) = (case when @year <> 9999 then @year else year(a.createdDt) end)
            and month(a.createdDt) = (case when @month <> 9999 then @month else month(a.createdDt) end)
            and d.DepartmentCode = (case when @department <> '9999' then @department else d.DepartmentCode end)
            group by a.Model "

            Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)

            myCommandSelect.Parameters.AddWithValue("@year", ActYear)
            myCommandSelect.Parameters.AddWithValue("@month", ActMonth)
            myCommandSelect.Parameters.AddWithValue("@department", Department)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            While myReader.Read

                labels.Add(myReader.Item("version").ToString)
                lst_dataItem_1.Add(CInt(myReader.Item("countAsset")))

            End While

            myReader.Close()

            myConnection.Close()

        End Using


        iData.Add(labels)
        iData.Add(lst_dataItem_1)
        'iData.Add(lst_dataItem_2)

        Return iData
    End Function

#End Region

#Region "getChartTotRating"
    <WebMethod()>
    Public Function getChartTotRating(ByVal ActYear As String, ByVal ActMonth As String, ByVal TicketType As String, ByVal TicketCategory As String) As List(Of Object)
        Dim iData As List(Of Object) = New List(Of Object)()
        Dim labels As List(Of String) = New List(Of String)()
        Dim lst_dataItem_1 As List(Of Integer) = New List(Of Integer)()
        Dim lst_dataItem_2 As List(Of Integer) = New List(Of Integer)()

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQLSelect As String = "; with CTE as  
(  
 select 1 rating  
 union all  
 select rating +1 from CTE where rating<5  
)  
  
select convert(varchar,rating) + ' Star' as rating,
isnull((select count (*) from HD_Ticket a
			inner join HD_Category b on a.categoryId=b.categoryId
			inner join HD_FeedbackTicket c on a.ticketId=c.feedbackTicket_ticketID
			where c.feedbackTicket_star=rating
			and year(a.createdDt) = (case when @year <> 9999 then @year else year(a.createdDt) end)
            and month(a.createdDt) = (case when @month <> 9999 then @month else month(a.createdDt) end)
            and (case when b.type= 'HD' then 1 when b.type='A' then 2 else 9999 end) = (case when @ticketType <> 9999 then @ticketType else (case when b.type= 'HD' then 1 when b.type='A' then 2 else 9999 end) end)
            and b.category = (case when @ticketCat <> '9999' then @ticketCat else b.category end)
			group by c.feedbackTicket_star),0) as countTicket
from CTE "

            Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)

            myCommandSelect.Parameters.AddWithValue("@year", ActYear)
            myCommandSelect.Parameters.AddWithValue("@month", ActMonth)
            myCommandSelect.Parameters.AddWithValue("@ticketType", TicketType)
            myCommandSelect.Parameters.AddWithValue("@ticketCat", TicketCategory)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            While myReader.Read

                labels.Add(myReader.Item("rating").ToString)
                lst_dataItem_1.Add(CInt(myReader.Item("countTicket")))

            End While

            myReader.Close()

            myConnection.Close()

        End Using


        iData.Add(labels)
        iData.Add(lst_dataItem_1)
        'iData.Add(lst_dataItem_2)

        Return iData
    End Function

#End Region

#Region "getChartTotReview"
    <WebMethod()>
    Public Function getChartTotReview(ByVal ActYear As String, ByVal ActMonth As String, ByVal TicketType As String, ByVal TicketCategory As String) As List(Of Object)
        Dim iData As List(Of Object) = New List(Of Object)()
        Dim labels As List(Of String) = New List(Of String)()
        Dim lst_dataItem_1 As List(Of Integer) = New List(Of Integer)()
        Dim lst_dataItem_2 As List(Of Integer) = New List(Of Integer)()

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQLSelect As String = "select UPPER(a.DepartmentCode) as DepartmentCode, COUNT (*) as countReview
            from HD_Ticket  a
            inner join HD_Category b on a.categoryId=b.categoryId
			inner join HD_FeedbackTicket c on c.feedbackTicket_ticketID=a.ticketId
            where year(a.createdDt) = (case when @year <> 9999 then @year else year(a.createdDt) end)
            and month(a.createdDt) = (case when @month <> 9999 then @month else month(a.createdDt) end)
            and (case when b.type= 'HD' then 1 when b.type='A' then 2 else 9999 end) = (case when @ticketType <> 9999 then @ticketType else (case when b.type= 'HD' then 1 when b.type='A' then 2 else 9999 end) end)
            and b.category = (case when @ticketCat <> '9999' then @ticketCat else b.category end)
            group by a.DepartmentCode"

            Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)

            myCommandSelect.Parameters.AddWithValue("@year", ActYear)
            myCommandSelect.Parameters.AddWithValue("@month", ActMonth)
            myCommandSelect.Parameters.AddWithValue("@ticketType", TicketType)
            myCommandSelect.Parameters.AddWithValue("@ticketCat", TicketCategory)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            While myReader.Read

                labels.Add(myReader.Item("DepartmentCode").ToString)
                lst_dataItem_1.Add(CInt(myReader.Item("countReview")))

            End While

            myReader.Close()

            myConnection.Close()

        End Using


        iData.Add(labels)
        iData.Add(lst_dataItem_1)
        'iData.Add(lst_dataItem_2)

        Return iData
    End Function

#End Region

#Region "getChartTotTicketMonthlyIndv"
    <WebMethod()>
    Public Function getChartTotTicketMonthlyInd(ByVal EmpID As String) As List(Of Object)
        Dim iData As List(Of Object) = New List(Of Object)()
        Dim labels As List(Of String) = New List(Of String)()
        Dim lst_dataItem_1 As List(Of Integer) = New List(Of Integer)()
        Dim lst_dataItem_2 As List(Of Integer) = New List(Of Integer)()

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()


            Dim SQLSelect As String = "select * from (
            select 
            SUBSTRING(cast(year(a.createdDt) as varchar(50)),3,2)+'/'+cast(month(a.createdDt) as varchar(2)) as yearMonth,
			count (*) as countTicket
            from HD_Ticket a
            inner join HD_Category b on a.categoryId=b.categoryId
            where year(a.createdDt) = year(a.createdDt)
            and (case when b.type= 'HD' then 1 when b.type='A' then 2 else 9999 end) = (case when @ticketType <> 9999 then @ticketType else (case when b.type= 'HD' then 1 when b.type='A' then 2 else 9999 end) end)
            and b.category = (case when @ticketCat <> '9999' then @ticketCat else b.category end)
            and a.EmpID=@empID
			group by year(a.createdDt),month(a.createdDt)) as tbl1
			group by yearMonth,countTicket "

            Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)

            myCommandSelect.Parameters.AddWithValue("@year", 9999)
            myCommandSelect.Parameters.AddWithValue("@month", 9999)
            myCommandSelect.Parameters.AddWithValue("@ticketType", 9999)
            myCommandSelect.Parameters.AddWithValue("@ticketCat", "9999")
            myCommandSelect.Parameters.AddWithValue("@empID", EmpID)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            While myReader.Read

                labels.Add(myReader.Item("yearMonth").ToString)
                lst_dataItem_1.Add(CInt(myReader.Item("countTicket")))

            End While

            myReader.Close()

            myConnection.Close()

        End Using


        iData.Add(labels)
        iData.Add(lst_dataItem_1)
        'iData.Add(lst_dataItem_2)

        Return iData
    End Function

#End Region

#Region "getChartTotTicketByCategoryIndv"
    <WebMethod()>
    Public Function getChartTotTicketByCategoryIndv(ByVal EmpID As String) As List(Of Object)
        Dim iData As List(Of Object) = New List(Of Object)()
        Dim labels As List(Of String) = New List(Of String)()
        Dim lst_dataItem_1 As List(Of Integer) = New List(Of Integer)()
        Dim lst_dataItem_2 As List(Of Integer) = New List(Of Integer)()

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()


            Dim SQLSelect As String = "select * from (
            select a.categoryId,a.category+' ('+( case when a.type = 'HD' then 'Non Asset' else 'Asset' end)+')' as type ,
            (select COUNT (*) from HD_Ticket x1
            inner join HD_Category x2 on x1.categoryId=x2.categoryId
            where year(x1.createdDt) = (case when @year <> 9999 then @year else year(x1.createdDt) end)
            and month(x1.createdDt) = (case when @month <> 9999 then @month else month(x1.createdDt) end)
            and x2.category+' ('+( case when x2.type = 'HD' then 'Non Asset' else 'Asset' end)+')'= a.category+' ('+( case when a.type = 'HD' then 'Non Asset' else 'Asset' end)+')'
            and x2.category = (case when @ticketCat <> '9999' then @ticketCat else x2.category end)
            and x1.EmpID=@empID ) as countTicket
            from HD_Category a
            ) as tbl1
            order by tbl1.countTicket desc "

            Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)

            myCommandSelect.Parameters.AddWithValue("@year", 9999)
            myCommandSelect.Parameters.AddWithValue("@month", 9999)
            myCommandSelect.Parameters.AddWithValue("@ticketType", 9999)
            myCommandSelect.Parameters.AddWithValue("@ticketCat", "9999")
            myCommandSelect.Parameters.AddWithValue("@empID", EmpID)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            While myReader.Read

                labels.Add(myReader.Item("type").ToString)
                lst_dataItem_1.Add(CInt(myReader.Item("countTicket")))

            End While

            myReader.Close()

            myConnection.Close()

        End Using


        iData.Add(labels)
        iData.Add(lst_dataItem_1)
        'iData.Add(lst_dataItem_2)

        Return iData
    End Function

#End Region

#Region "getChartTotTicketByPriorityIndv"
    <WebMethod()>
    Public Function getChartTotTicketByPriorityIndv(ByVal EmpID As String) As List(Of Object)
        Dim iData As List(Of Object) = New List(Of Object)()
        Dim labels As List(Of String) = New List(Of String)()
        Dim lst_dataItem_1 As List(Of Integer) = New List(Of Integer)()
        Dim lst_dataItem_2 As List(Of Integer) = New List(Of Integer)()

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQLSelect As String = "select priority, 
            (select CASE WHEN COUNT (*) > 0 THEN COUNT(*) ELSE 0 END from HD_Ticket x1
            inner join HD_Category x2 on x2.categoryId=x1.categoryId
            where year(x1.createdDt) = (case when @year <> 9999 then @year else year(x1.createdDt) end)
            and month(x1.createdDt) = (case when @month <> 9999 then @month else month(x1.createdDt) end)
            and (case when x2.type= 'HD' then 1 when x2.type='A' then 2 else 9999 end) = (case when @ticketType <> 9999 then @ticketType else (case when x2.type= 'HD' then 1 when x2.type='A' then 2 else 9999 end) end)
            and x2.category = (case when @ticketCat <> '9999' then @ticketCat else x2.category end)
            and x1.priorityId = a.priorityId
            and x1.EmpID=@empID ) as countTicket
            from HD_Priority a "

            Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)

            myCommandSelect.Parameters.AddWithValue("@year", 9999)
            myCommandSelect.Parameters.AddWithValue("@month", 9999)
            myCommandSelect.Parameters.AddWithValue("@ticketType", 9999)
            myCommandSelect.Parameters.AddWithValue("@ticketCat", "9999")
            myCommandSelect.Parameters.AddWithValue("@empID", EmpID)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            While myReader.Read

                labels.Add(myReader.Item("priority").ToString)
                lst_dataItem_1.Add(CInt(myReader.Item("countTicket")))

            End While

            myReader.Close()

            myConnection.Close()

        End Using


        iData.Add(labels)
        iData.Add(lst_dataItem_1)
        'iData.Add(lst_dataItem_2)

        Return iData
    End Function

#End Region

#Region "getChartTotRatingIndv"
    <WebMethod()>
    Public Function getChartTotRatingIndv(ByVal EmpID As String) As List(Of Object)
        Dim iData As List(Of Object) = New List(Of Object)()
        Dim labels As List(Of String) = New List(Of String)()
        Dim lst_dataItem_1 As List(Of Integer) = New List(Of Integer)()
        Dim lst_dataItem_2 As List(Of Integer) = New List(Of Integer)()

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            myConnection.Open()

            Dim SQLSelect As String = "; with CTE as  
(  
 select 1 rating  
 union all  
 select rating +1 from CTE where rating<5  
)  
  
select convert(varchar,rating) + ' Star' as rating,
isnull((select count (*) from HD_Ticket a
			inner join HD_Category b on a.categoryId=b.categoryId
			inner join HD_FeedbackTicket c on a.ticketId=c.feedbackTicket_ticketID
			where c.feedbackTicket_star=rating
			and year(a.createdDt) = (case when @year <> 9999 then @year else year(a.createdDt) end)
            and month(a.createdDt) = (case when @month <> 9999 then @month else month(a.createdDt) end)
            and (case when b.type= 'HD' then 1 when b.type='A' then 2 else 9999 end) = (case when @ticketType <> 9999 then @ticketType else (case when b.type= 'HD' then 1 when b.type='A' then 2 else 9999 end) end)
            and b.category = (case when @ticketCat <> '9999' then @ticketCat else b.category end)
            and a.EmpID=@empID
			group by c.feedbackTicket_star),0) as countTicket
from CTE "

            Dim myCommandSelect As New SqlCommand(SQLSelect, myConnection)

            myCommandSelect.Parameters.AddWithValue("@year", 9999)
            myCommandSelect.Parameters.AddWithValue("@month", 9999)
            myCommandSelect.Parameters.AddWithValue("@ticketType", 9999)
            myCommandSelect.Parameters.AddWithValue("@ticketCat", "9999")
            myCommandSelect.Parameters.AddWithValue("@empID", EmpID)

            Dim myReader As SqlDataReader = myCommandSelect.ExecuteReader

            While myReader.Read

                labels.Add(myReader.Item("rating").ToString)
                lst_dataItem_1.Add(CInt(myReader.Item("countTicket")))

            End While

            myReader.Close()

            myConnection.Close()

        End Using


        iData.Add(labels)
        iData.Add(lst_dataItem_1)
        'iData.Add(lst_dataItem_2)

        Return iData
    End Function

#End Region

End Class

Public Class OverallEstate
    Private name As String
    Public Property OCName As String
        Get
            Return name
        End Get
        Set(ByVal value As String)
            name = value
        End Set
    End Property

    Private tonMonth As Double
    Public Property TonnageMonth As Double
        Get
            Return tonMonth
        End Get
        Set(ByVal value As Double)
            tonMonth = value
        End Set
    End Property

    Private tonToDate As Double
    Public Property TonnageToDate As Double
        Get
            Return tonToDate
        End Get
        Set(ByVal value As Double)
            tonToDate = value
        End Set
    End Property

    Private avgMonth As Double
    Public Property AvgBwtMonth As Double
        Get
            Return avgMonth
        End Get
        Set(ByVal value As Double)
            avgMonth = value
        End Set
    End Property

    Private avgToDate As Double
    Public Property AvgBwtToDate As Double
        Get
            Return avgToDate
        End Get
        Set(ByVal value As Double)
            avgToDate = value
        End Set
    End Property
End Class