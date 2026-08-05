Imports System.Data
Imports System.Data.SqlClient
Imports ActiveDirectoryLib
Imports DocumentFormat.OpenXml.Wordprocessing
Imports WebGrease.Css.Ast

Partial Class _Default
    Inherits Page

    Public MonthlyData As String = "[]"
    Public StatusData As String = "[]"
    Public DailyData As String = "[]"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'checkDefaultPermission()

        'If Request.Browser.IsMobileDevice Then
        '    divLogoBig.Visible = False
        'Else
        '    divLogoBig.Visible = True
        'End If

        'Session.Item("sessionSystemId") = 0
        'If Session.Item("sessionLoginDenied") <> "" Then
        '    txtError.Text = Session.Item("sessionLoginDenied")
        'End If
        If Not IsPostBack Then
            LoadKategoriDropdown()
            LoadAgensiDropdown()

        End If

        Dim pageName As String = System.IO.Path.GetFileName(Request.Url.AbsolutePath)

        If pageName.Equals("Default.aspx", StringComparison.OrdinalIgnoreCase) Then

            Try
                BindGrid()
            Catch ex As Exception
                ' Log error
            End Try

        End If

        '//set graph
        Try
            If CInt(Session.Item("sessionUsersId")) > 0 Then

                generateMonthlyData()
                generateStatusData()
                generateDailyApprovalData()
                'generateGraphBayaran()
                'generateGraphPermohonanYearly()
                'generatePieChart()

            End If
        Catch ex As Exception
            'MsgBox(ex.Message)
        End Try

        '//dashboard
        Try
            If getAdminDashboard() Then
            Else

                idTopBox.Visible = False
                'idTrafictJenis.Visible = False
                'idJenisLesen.Visible = False
            End If
        Catch ex As Exception

        End Try



    End Sub

    Private Sub generateDailyApprovalData()

        Dim dt As New DataTable()

        Using con As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
            Using cmd As New SqlCommand("
            SELECT
                h.Hari,
                ISNULL(x.TotalKelulusan,0) AS TotalKelulusan
            FROM
            (
                SELECT 1 AS Hari UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
                UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10
                UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14 UNION ALL SELECT 15
                UNION ALL SELECT 16 UNION ALL SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19 UNION ALL SELECT 20
                UNION ALL SELECT 21 UNION ALL SELECT 22 UNION ALL SELECT 23 UNION ALL SELECT 24 UNION ALL SELECT 25
                UNION ALL SELECT 26 UNION ALL SELECT 27 UNION ALL SELECT 28 UNION ALL SELECT 29 UNION ALL SELECT 30
                UNION ALL SELECT 31
            ) h
            LEFT JOIN
            (
                SELECT
                    DAY(a.TarikhMohon) AS Hari,
                    COUNT(*) AS TotalKelulusan
                FROM
                (
                    SELECT 
                        Permohonan_ID,
                        ApprStatusID,
                        AgensiID,
                        TarikhMohon
                    FROM v_LESEN_ApprovalList_Curr

                    UNION ALL

                    SELECT 
                        Permohonan_ID,
                        ApprStatusID,
                        AgensiID,
                        TarikhMohon
                    FROM v_LESEN_ApprovalListBatal_Curr
                ) a
                WHERE YEAR(a.TarikhMohon) = YEAR(GETDATE())
                AND MONTH(a.TarikhMohon) = MONTH(GETDATE())
                AND IIF(@AgensiID = 0 OR @AgensiID = 1,0,@AgensiID) =
                    IIF(@AgensiID = 0 OR @AgensiID = 1,0,a.AgensiID)
                AND a.ApprStatusID = 10
                GROUP BY DAY(a.TarikhMohon)
            ) x
            ON h.Hari = x.Hari
            ORDER BY h.Hari
            ", con)

                cmd.Parameters.AddWithValue("@AgensiID", Session.Item("sessionEstateID"))

                con.Open()

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(dt)

            End Using
        End Using


        Dim values As New List(Of String)

        For Each row As DataRow In dt.Rows
            values.Add(row("TotalKelulusan").ToString())
        Next

        DailyData = "[" & String.Join(",", values) & "]"
    End Sub

    Private Sub generateStatusData()

        Dim dt As New DataTable()

        Using con As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
            Using cmd As New SqlCommand("
            SELECT
                SUM(CASE WHEN a.ApprStatusID IN (1) THEN 1 ELSE 0 END) AS TotalPermohonan,
                SUM(CASE WHEN a.ApprStatusID IN (2,3,4,5,7,8) THEN 1 ELSE 0 END) AS TotalDalamProses,
                SUM(CASE WHEN a.ApprStatusID = 10 THEN 1 ELSE 0 END) AS Diluluskan,
                SUM(CASE WHEN a.ApprStatusID IN (6,9) THEN 1 ELSE 0 END) AS Ditolak
            FROM
            (
                SELECT 
                    Permohonan_ID,
                    ApprStatusID,
                    AgensiID
                FROM v_LESEN_ApprovalList_Curr
                WHERE YEAR(TarikhMohon) = YEAR(GETDATE())

                UNION ALL

                SELECT 
                    Permohonan_ID,
                    ApprStatusID,
                    AgensiID
                FROM v_LESEN_ApprovalListBatal_Curr
                WHERE YEAR(TarikhMohon) = YEAR(GETDATE())

            ) a
            WHERE IIF(@AgensiID = 0 OR @AgensiID = 1,0,@AgensiID) =
            IIF(@AgensiID = 0 OR @AgensiID = 1,0,a.AgensiID)
            AND a.ApprStatusID <> 0
            ", con)



                cmd.Parameters.AddWithValue("@AgensiID", Session.Item("sessionEstateID"))

                con.Open()

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(dt)

            End Using
        End Using


        Dim values As New List(Of String)

        If dt.Rows.Count > 0 Then

            Dim row As DataRow = dt.Rows(0)
            values.Add(row("TotalPermohonan").ToString())
            values.Add(row("TotalDalamProses").ToString())
            values.Add(row("Diluluskan").ToString())
            values.Add(row("Ditolak").ToString())

        End If

        StatusData = "[" & String.Join(",", values) & "]"

    End Sub

    Private Sub generateMonthlyData()

        Dim dt As New DataTable()

        Using con As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
            Using cmd As New SqlCommand("
                SELECT
                b.Bulan,
                ISNULL(x.TotalPermohonan, 0) AS TotalPermohonan
            FROM
            (
                SELECT 1 AS Bulan UNION ALL
                SELECT 2 UNION ALL
                SELECT 3 UNION ALL
                SELECT 4 UNION ALL
                SELECT 5 UNION ALL
                SELECT 6 UNION ALL
                SELECT 7 UNION ALL
                SELECT 8 UNION ALL
                SELECT 9 UNION ALL
                SELECT 10 UNION ALL
                SELECT 11 UNION ALL
                SELECT 12
            ) b
            LEFT JOIN
            (
                SELECT
                    MONTH(a.TarikhMohon) AS Bulan,
                    COUNT(DISTINCT a.Permohonan_ID) AS TotalPermohonan
                FROM
                (
                    SELECT 
                        Permohonan_ID,
                        AgensiID,
                        TarikhMohon
                    FROM v_LESEN_ApprovalList_Curr
                    WHERE ApprStatusID > 0

                    UNION ALL

                    SELECT 
                        Permohonan_ID,
                        AgensiID,
                        TarikhMohon
                    FROM v_LESEN_ApprovalListBatal_Curr
                    WHERE ApprStatusID > 0
                ) a
                WHERE YEAR(a.TarikhMohon) = YEAR(GETDATE())
                AND IIF(@AgensiID = 0 OR @AgensiID = 1,0,@AgensiID) =
                    IIF(@AgensiID = 0 OR @AgensiID = 1,0,a.AgensiID)
                GROUP BY MONTH(a.TarikhMohon)
            ) x
            ON b.Bulan = x.Bulan
            ORDER BY b.Bulan
            ", con)



                cmd.Parameters.AddWithValue("@AgensiID", Session.Item("sessionEstateID"))

                con.Open()

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(dt)

            End Using
        End Using


        Dim values As New List(Of String)

        For Each row As DataRow In dt.Rows
            values.Add(row("TotalPermohonan").ToString())
        Next

        MonthlyData = "[" & String.Join(",", values) & "]"

    End Sub

    Private Sub generatePieChart()

        Dim monthValue As String = "0,0,0,0,0,0,0,0,0,0,0,0"
        Dim totAmt As Decimal = 0.0
        Dim lblPie As String = ""
        Dim lblData As String = ""
        Dim lblColor As String = ""

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Dim SQL As String = ""
            SQL = "select JenisLesen_Description,totPerniagaan,case when totAllPerniagaan = 0 then 1 else totAllPerniagaan end as totAllPerniagaan
            from (select a.JenisLesen_Description,
            (select count(*) from LESEN_Permohonan x 
            where x.JenisLesen_ID = a.JenisLesen_ID /*and year(x.TarikhMohon) = year(getdate()) and month(x.TarikhMohon) = month(getdate())*/ and x.StatusID=10
            and iif(@AgensiID = 0 or @AgensiID = 1,0,@AgensiID) = iif(@AgensiID = 0 or @AgensiID = 1,0,(select top 1 x2.AgensiID from LESEN_ApprovalList x2 where x2.agensiID = @AgensiID and x2.Permohonan_ID = x.Permohonan_ID))
            ) as totPerniagaan,

            (select count(*) from LESEN_Permohonan x 
            where /*year(x.TarikhMohon) = year(getdate()) and month(x.TarikhMohon) = month(getdate()) and*/ x.StatusID=10
            and iif(@AgensiID = 0 or @AgensiID = 1,0,@AgensiID) = iif(@AgensiID = 0 or @AgensiID = 1,0,(select top 1 x2.AgensiID from LESEN_ApprovalList x2 where x2.agensiID = @AgensiID and x2.Permohonan_ID = x.Permohonan_ID)) 
            ) as totAllPerniagaan
            from LESEN_JenisLesen a
            where a.JenisLesen_IsActive=1 ) as tbl1 where totPerniagaan > 0"


            Dim myCommand As New SqlCommand(SQL, myConnection)
            myCommand.Parameters.AddWithValue("@AgensiID", Session.Item("sessionEstateID"))


            myConnection.Open()

            Dim myReader As SqlDataReader = myCommand.ExecuteReader

            Dim i As Integer = 0
            Dim random = New Random()

            While myReader.Read

                If i > 0 Then
                    lblPie = lblPie + ","
                    lblData = lblData + ","
                    lblColor = lblColor + ","
                End If


                Dim color = String.Format("#{0:X6}", random.[Next](&H1000000))

                lblPie = lblPie + "'" + myReader("JenisLesen_Description") + "'"
                lblData = lblData + myReader("totPerniagaan").ToString
                lblColor = lblColor + "'" + color + "'"

                'If i = 0 Then
                '    monthValue = myReader("totAmt")
                'Else
                '    monthValue = monthValue & "," & myReader("totAmt")
                'End If
                i += 1

                'lblCurrDate.Text = myReader("currDate")
                'totAmt += myReader("totAmt")
            End While


            myReader.Close()
            myConnection.Close()

        End Using
        'MsgBox(lblPie)

        Dim myScript As String = vbLf & "<script type=""text/javascript"" language=""Javascript"" id=""generatePieChart"">" & vbLf
        myScript += "      const doughnutChart = new Chart(document.getElementById('pieChart'), {
            type: 'doughnut',
            data: {
            labels: [" & lblPie & "],
            datasets: [{
            data: [" & lblData & "],
            backgroundColor: [" & lblColor & "],
            hoverBackgroundColor: [" & lblColor & "]
            }]
            },
            options: {
            responsive: true,
                plugins: {
                legend: {
                    display: true
                    },
                }
            }
            });"
        myScript += vbLf & vbLf & " </script>"

        'MsgBox(myScript)

        Page.ClientScript.RegisterStartupScript(Me.[GetType](), "myKeygeneratePieChart", myScript, False)

    End Sub

    Private Function getAdminDashboard() As Boolean
        Dim retval As Boolean = False

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Dim SQL As String = ""
            SQL = "select * from LESEN_JabatanAgensi where JabatanAgensi_IsLesen=1 
            and JabatanAgensi_IsActive=1 and JabatanAgensi_ID = @JabatanAgensi_ID"


            Dim myCommand As New SqlCommand(SQL, myConnection)
            myCommand.Parameters.AddWithValue("@JabatanAgensi_ID", Session.Item("sessionEstateID"))


            myConnection.Open()

            Dim myReader As SqlDataReader = myCommand.ExecuteReader

            Dim i As Integer = 0
            While myReader.Read
                'monthValueApprove = myReader("totCntApprove")
                retval = True

            End While

            myReader.Close()
            myConnection.Close()

        End Using

        If CInt(Session.Item("sessionisadmin")) = 1 Then
            retval = True
        End If

        Return retval
    End Function

    'Private Sub generateGraphPermohonanYearly()

    '    Dim monthValueApprove As String = "0,0,0,0,0,0,0,0,0,0,0,0"
    '    Dim monthValueReject As String = "0,0,0,0,0,0,0,0,0,0,0,0"
    '    Dim totAmt As Decimal = 0.0

    '    Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

    '        Dim SQL As String = ""

    '        If getAdminDashboard() Then
    '            SQL = "select 
    '            (select count(*) from LESEN_Permohonan x where MONTH(x.TarikhMohon) = tblMonth.monthValue and YEAR(x.TarikhMohon) = YEAR(getdate()) and x.StatusID = 10) as totCntApprove,
    '            (select count(*) from LESEN_Permohonan x where MONTH(x.TarikhMohon) = tblMonth.monthValue and YEAR(x.TarikhMohon) = YEAR(getdate()) and x.StatusID = 9) as totCntReject
    '            ,* from (
    '            select 1 as monthValue union select 2 as monthValue union select 3 as monthValue union select 4 as monthValue 
    '            union select 5 as monthValue union select 6 as monthValue union select 7 as monthValue union select 8 as monthValue union select 9 as monthValue
    '            union select 10 as monthValue union select 11 as monthValue union select 12 as monthValue
    '            ) as tblMonth"
    '        Else
    '            SQL = "select 
    '            (select count(*) from LESEN_Permohonan x inner join (select top 1 * from LESEN_PermohonanAgensi x2 where x2.JabatanAgensi_ID = @JabatanAgensi_ID ) b on b.Permohonan_ID = x.Permohonan_ID where MONTH(x.TarikhMohon) = tblMonth.monthValue and YEAR(x.TarikhMohon) = YEAR(getdate()) and x.StatusID = 10) as totCntApprove,
    '            (select count(*) from LESEN_Permohonan x inner join (select top 1 * from LESEN_PermohonanAgensi x2 where x2.JabatanAgensi_ID = @JabatanAgensi_ID ) b on b.Permohonan_ID = x.Permohonan_ID where MONTH(x.TarikhMohon) = tblMonth.monthValue and YEAR(x.TarikhMohon) = YEAR(getdate()) and x.StatusID = 9) as totCntReject
    '            ,* from (
    '            select 1 as monthValue union select 2 as monthValue union select 3 as monthValue union select 4 as monthValue 
    '            union select 5 as monthValue union select 6 as monthValue union select 7 as monthValue union select 8 as monthValue union select 9 as monthValue
    '            union select 10 as monthValue union select 11 as monthValue union select 12 as monthValue
    '            ) as tblMonth"
    '        End If



    '        Dim myCommand As New SqlCommand(SQL, myConnection)
    '        myCommand.Parameters.AddWithValue("@JabatanAgensi_ID", Session.Item("sessionEstateID"))


    '        myConnection.Open()

    '        Dim myReader As SqlDataReader = myCommand.ExecuteReader

    '        Dim i As Integer = 0
    '        While myReader.Read

    '            If i = 0 Then
    '                monthValueApprove = myReader("totCntApprove")
    '                monthValueReject = myReader("totCntReject")
    '            Else
    '                monthValueApprove = monthValueApprove & "," & myReader("totCntApprove")
    '                monthValueReject = monthValueReject & "," & myReader("totCntReject")
    '            End If

    '            i += 1

    '            'lblCurrDate.Text = myReader("currDate")
    '            'totAmt += myReader("totAmt")
    '        End While

    '        'lblTotAmtGraph1.Text = totAmt.ToString("0.00")

    '        myReader.Close()
    '        myConnection.Close()

    '    End Using

    '    Dim myScript As String = vbLf & "<script type=""text/javascript"" language=""Javascript"" id=""generateGraphPermohonanYearly"">" & vbLf
    '    myScript += "const mainBarChart = new Chart(document.getElementById('main-bar-chart'), {
    '        type: 'bar',
    '        data: {
    '            labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
    '            datasets: [
    '                {
    '                    label: 'Lulus',
    '                    backgroundColor: coreui.Utils.getStyle('--cui-primary'),
    '                    borderRadius: 6,
    '                    borderSkipped: false,
    '                    data: [" & monthValueApprove & "],
    '                    barPercentage: 0.6,
    '                    categoryPercentage: 0.5,
    '                },
    '                {
    '                    label: 'Tidak Lulus',
    '                    backgroundColor: coreui.Utils.getStyle('--cui-gray-100'),
    '                    borderRadius: 6,
    '                    borderSkipped: false,
    '                    data: [" & monthValueReject & "],
    '                    barPercentage: 0.6,
    '                    categoryPercentage: 0.5,
    '                },
    '            ],
    '        },
    '        options: {
    '            maintainAspectRatio: false,
    '            plugins: { legend: { display: false } },
    '            scales: {
    '                x: { grid: { display: false, drawBorder: false, drawTicks: false }, ticks: { color: coreui.Utils.getStyle('--cui-text-disabled'), font: { size: 14 }, padding: 16 } },
    '                y: {
    '                    grid: { drawBorder: false, borderDash: [2, 4] },
    '                    gridLines: { borderDash: [8, 4], color: '#348632' },
    '                    ticks: { beginAtZero: true, color: coreui.Utils.getStyle('--cui-text-disabled'), font: { size: 14 }, maxTicksLimit: 1000, padding: 16, stepSize: 1 },
    '                },
    '            },
    '        },
    '    });"
    '    myScript += vbLf & vbLf & " </script>"
    '    Page.ClientScript.RegisterStartupScript(Me.[GetType](), "myKeygenerateGraphPermohonanYearly", myScript, False)

    'End Sub

    'Private Sub generateGraphBayaran()

    '    Dim monthValue As String = "0,0,0,0,0,0,0,0,0,0,0,0"
    '    Dim totAmt As Decimal = 0.0

    '    Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

    '        Dim SQL As String = ""
    '        SQL = "select isnull(sum(c.KadarBayaran_Amount),0) as totAmt,tblMonth.monthValue,CONVERT(char(10), GetDate(),126) as currDate from (
    '        select 1 as monthValue union select 2 as monthValue union select 3 as monthValue union select 4 as monthValue 
    '        union select 5 as monthValue union select 6 as monthValue union select 7 as monthValue union select 8 as monthValue union select 9 as monthValue
    '        union select 10 as monthValue union select 11 as monthValue union select 12 as monthValue
    '        ) as tblMonth
    '        left join LESEN_Permohonan b on MONTH(b.TarikhMohon) = tblMonth.monthValue and YEAR(b.TarikhMohon) = YEAR(getdate()) and b.StatusID = 10
    '        left join LESEN_KadarBayaran c on c.KadarBayaran_PermohonanID = b.Permohonan_ID
    '        group by tblMonth.monthValue"


    '        Dim myCommand As New SqlCommand(SQL, myConnection)
    '        ' myCommand.Parameters.AddWithValue("@txtUsername", txtUsername)


    '        myConnection.Open()

    '        Dim myReader As SqlDataReader = myCommand.ExecuteReader

    '        Dim i As Integer = 0
    '        While myReader.Read
    '            If i = 0 Then
    '                monthValue = myReader("totAmt")
    '            Else
    '                monthValue = monthValue & "," & myReader("totAmt")
    '            End If
    '            i += 1

    '            lblCurrDate.Text = myReader("currDate")
    '            totAmt += myReader("totAmt")
    '        End While

    '        lblTotAmtGraph1.Text = totAmt.ToString("0.00")

    '        myReader.Close()
    '        myConnection.Close()

    '    End Using

    '    Dim myScript As String = vbLf & "<script type=""text/javascript"" language=""Javascript"" id=""generateGraphBayaran"">" & vbLf
    '    myScript += "const cardChartNew1 = new Chart(document.getElementById('card-chart-new1'), {
    '        type: 'line',
    '        data: {
    '            labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
    '            datasets: [
    '                {
    '                    label: 'Jumlah (RM) ',
    '                    backgroundColor: `rgba(${coreui.Utils.getStyle('--cui-primary-rgb')}, .1)`,
    '                    borderColor: coreui.Utils.getStyle('--cui-primary'),
    '                    borderWidth: 3, data: [" & monthValue & "],
    '                    fill: true
    '                },
    '            ],
    '        },
    '        options: {
    '            plugins: { legend: { display: false } },
    '            maintainAspectRatio: false,
    '            scales: { x: { display: false }, y: { beginAtZero: true, display: false } },
    '            elements: { line: { borderWidth: 2, tension: 0.4 }, point: { radius: 0, hitRadius: 10, hoverRadius: 4 } },
    '        },
    '    });"
    '    myScript += vbLf & vbLf & " </script>"
    '    Page.ClientScript.RegisterStartupScript(Me.[GetType](), "myKeygenerateGraphBayaran", myScript, False)

    'End Sub




    ' ---------------------------------------------------------------
    ' Dropdown sources
    ' ---------------------------------------------------------------
    Private Sub LoadKategoriDropdown()
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
            Using cmd As New SqlCommand(
                "SELECT JenisLesen_ID, JenisLesen_Description FROM LESEN_JenisLesen WHERE JenisLesen_IsActive = 1 ORDER BY JenisLesen_Description", conn)

                conn.Open()
                Using da As New SqlDataAdapter(cmd)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    ddlKategori.DataTextField = "JenisLesen_Description"
                    ddlKategori.DataValueField = "JenisLesen_ID"
                    ddlKategori.DataSource = dt
                    ddlKategori.DataBind()
                    ddlKategori.Items.Insert(0, New System.Web.UI.WebControls.ListItem("Semua Kategori", "0"))
                End Using
            End Using
        End Using
    End Sub

    Private Sub LoadAgensiDropdown()
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
            Using cmd As New SqlCommand(
                "SELECT JabatanAgensi_ID, JabatanAgensi_Description FROM LESEN_JabatanAgensi WHERE JabatanAgensi_IsActive = 1 ORDER BY JabatanAgensi_Description", conn)

                conn.Open()
                Using da As New SqlDataAdapter(cmd)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    ddlAgensi.DataTextField = "JabatanAgensi_Description"
                    ddlAgensi.DataValueField = "JabatanAgensi_ID"
                    ddlAgensi.DataSource = dt
                    ddlAgensi.DataBind()
                    ddlAgensi.Items.Insert(0, New System.Web.UI.WebControls.ListItem("Semua Agensi", "0"))
                End Using
            End Using
        End Using
    End Sub

    ' ---------------------------------------------------------------
    ' Main bind
    ' ---------------------------------------------------------------


    Private Sub BindGrid()
        Dim agensiId As Integer = Convert.ToInt32(ddlAgensi.SelectedValue)
        Dim jenisLesenId As Integer = Convert.ToInt32(ddlKategori.SelectedValue)
        Dim keyword As String = txtSearch.Text.Trim()

        Dim summary As DataTable = GetSummaryData(agensiId, jenisLesenId, keyword)
        Dim trendMap As Dictionary(Of Integer, List(Of Integer)) = GetTrendData(agensiId)

        ' Attach a TrendJson column so the markup can bind it directly
        summary.Columns.Add("TrendJson", GetType(String))
        For Each row As DataRow In summary.Rows
            Dim id As Integer = Convert.ToInt32(row("JenisLesen_ID"))
            Dim points As List(Of Integer)
            If trendMap.ContainsKey(id) Then
                points = trendMap(id)
            Else
                points = New List(Of Integer) From {0, 0, 0, 0, 0, 0}
            End If
            row("TrendJson") = "[" & String.Join(",", points) & "]"
        Next

        gvLesenSummary.DataSource = summary
        gvLesenSummary.DataBind()
    End Sub

    Private Function GetSummaryData(agensiId As Integer, jenisLesenId As Integer, keyword As String) As DataTable
        Const sql As String = "
SELECT
    a.JenisLesen_ID,
    a.JenisLesen_Description,
    COUNT(CASE WHEN x.StatusID = 10 THEN 1 END) AS TelahLulus,
    COUNT(CASE WHEN x.StatusID = 10
               AND DATEDIFF(DAY, appr1.ApprovalDate, appr10.ApprovalDate) < 14
          THEN 1 END) AS Kurang14Hari,
    COUNT(CASE WHEN x.StatusID = 10
               AND DATEDIFF(DAY, appr1.ApprovalDate, appr10.ApprovalDate) >= 14
          THEN 1 END) AS Lebih14Hari,
    COUNT(x.Permohonan_ID) AS Jumlah,
    ISNULL(AVG(CASE WHEN x.StatusID = 10
                    THEN DATEDIFF(DAY, appr1.ApprovalDate, appr10.ApprovalDate)
               END), 0) AS PurataSLA
FROM LESEN_JenisLesen a
LEFT JOIN LESEN_Permohonan x
       ON x.JenisLesen_ID = a.JenisLesen_ID
      AND YEAR(x.TarikhMohon)  = YEAR(GETDATE())
      AND MONTH(x.TarikhMohon) = MONTH(GETDATE())
      AND (
            (@AgensiID = 0 OR @AgensiID = 1)
            OR @AgensiID = (
                SELECT TOP 1 x2.AgensiID FROM LESEN_ApprovalList x2
                WHERE x2.AgensiID = @AgensiID AND x2.Permohonan_ID = x.Permohonan_ID
            )
          )
OUTER APPLY (
    SELECT TOP 1 ApprovalDate FROM LESEN_ApprovalList m
    WHERE m.Permohonan_ID = x.Permohonan_ID AND m.ApprStatusID = 1
) appr1
OUTER APPLY (
    SELECT TOP 1 ApprovalDate FROM LESEN_ApprovalList m
    WHERE m.Permohonan_ID = x.Permohonan_ID AND m.ApprStatusID = 10
) appr10
WHERE a.JenisLesen_IsActive = 1
  AND (@JenisLesenID = 0 OR a.JenisLesen_ID = @JenisLesenID)
  AND (@Keyword = '' OR a.JenisLesen_Description LIKE '%' + @Keyword + '%')
GROUP BY a.JenisLesen_ID, a.JenisLesen_Description
ORDER BY a.JenisLesen_Description;"

        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@AgensiID", agensiId)
                cmd.Parameters.AddWithValue("@JenisLesenID", jenisLesenId)
                cmd.Parameters.AddWithValue("@Keyword", keyword)

                conn.Open()
                Using da As New SqlDataAdapter(cmd)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    Return dt
                End Using
            End Using
        End Using
    End Function

    ''' <summary>
    ''' Returns, per JenisLesen_ID, a list of 6 integers = approved counts
    ''' for each of the last 6 months (oldest first).
    ''' </summary>
    Private Function GetTrendData(agensiId As Integer) As Dictionary(Of Integer, List(Of Integer))
        Const sql As String = "
SELECT
    a.JenisLesen_ID,
    FORMAT(DATEFROMPARTS(YEAR(appr10.ApprovalDate), MONTH(appr10.ApprovalDate), 1), 'yyyy-MM') AS BulanKey,
    COUNT(*) AS Bilangan
FROM LESEN_Permohonan x
JOIN LESEN_JenisLesen a ON a.JenisLesen_ID = x.JenisLesen_ID
OUTER APPLY (
    SELECT TOP 1 ApprovalDate FROM LESEN_ApprovalList m
    WHERE m.Permohonan_ID = x.Permohonan_ID AND m.ApprStatusID = 10
) appr10
WHERE x.StatusID = 10
  AND a.JenisLesen_IsActive = 1
  AND appr10.ApprovalDate >= DATEADD(MONTH, -5, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1))
  AND (
        (@AgensiID = 0 OR @AgensiID = 1)
        OR @AgensiID = (
            SELECT TOP 1 x2.AgensiID FROM LESEN_ApprovalList x2
            WHERE x2.AgensiID = @AgensiID AND x2.Permohonan_ID = x.Permohonan_ID
        )
      )
GROUP BY a.JenisLesen_ID,
         DATEFROMPARTS(YEAR(appr10.ApprovalDate), MONTH(appr10.ApprovalDate), 1)
ORDER BY a.JenisLesen_ID, BulanKey;"

        ' Build the list of the 6 expected month keys, oldest -> newest
        Dim monthKeys As New List(Of String)
        For i As Integer = 5 To 0 Step -1
            monthKeys.Add(DateTime.Today.AddMonths(-i).ToString("yyyy-MM"))
        Next

        Dim result As New Dictionary(Of Integer, List(Of Integer))

        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@AgensiID", agensiId)
                conn.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    Dim raw As New Dictionary(Of Integer, Dictionary(Of String, Integer))

                    While reader.Read()
                        Dim id As Integer = Convert.ToInt32(reader("JenisLesen_ID"))
                        Dim bulan As String = reader("BulanKey").ToString()
                        Dim bil As Integer = Convert.ToInt32(reader("Bilangan"))

                        If Not raw.ContainsKey(id) Then
                            raw(id) = New Dictionary(Of String, Integer)
                        End If
                        raw(id)(bulan) = bil
                    End While

                    For Each kvp As KeyValuePair(Of Integer, Dictionary(Of String, Integer)) In raw
                        Dim points As New List(Of Integer)
                        For Each mk As String In monthKeys
                            If kvp.Value.ContainsKey(mk) Then
                                points.Add(kvp.Value(mk))
                            Else
                                points.Add(0)
                            End If
                        Next
                        result(kvp.Key) = points
                    Next
                End Using
            End Using
        End Using

        Return result
    End Function

    ' ---------------------------------------------------------------
    ' Events
    ' ---------------------------------------------------------------
    Protected Sub txtSearch_TextChanged(sender As Object, e As EventArgs)
        gvLesenSummary.PageIndex = 0
        BindGrid()
    End Sub

    Protected Sub Filter_Changed(sender As Object, e As EventArgs)
        gvLesenSummary.PageIndex = 0
        BindGrid()
    End Sub

    Protected Sub btnFilter_Click(sender As Object, e As EventArgs)
        gvLesenSummary.PageIndex = 0
        BindGrid()
    End Sub

    Protected Sub gvLesenSummary_PageIndexChanging(sender As Object, e As GridViewPageEventArgs)
        gvLesenSummary.PageIndex = e.NewPageIndex
        BindGrid()
    End Sub


    Private ReadOnly Property ConnStr As String
        Get
            Return ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString
        End Get
    End Property

    ' Total rekod (semua halaman) sebelum GridView memotong ikut PageSize.
    ' Disimpan dalam ViewState supaya boleh diakses semasa RowDataBound
    ' pada baris Pager tanpa perlu query semula.
    Private Property TotalRecords As Integer
        Get
            If ViewState("TotalRecords") Is Nothing Then Return 0
            Return CInt(ViewState("TotalRecords"))
        End Get
        Set(value As Integer)
            ViewState("TotalRecords") = value
        End Set
    End Property

    Protected Sub gvLesenSummary_RowDataBound(sender As Object, e As GridViewRowEventArgs)

        If e.Row.RowType <> DataControlRowType.Pager Then Exit Sub

        Dim gv As GridView = CType(sender, GridView)
        Dim totalPages As Integer = gv.PageCount
        Dim currentPage As Integer = gv.PageIndex + 1 ' 1-based untuk paparan

        ' ---- Teks "Paparan X hingga Y dari Z rekod" ----
        Dim lblInfo As HtmlGenericControl = CType(e.Row.FindControl("lblPagerInfo"), HtmlGenericControl)
        If lblInfo IsNot Nothing Then
            If TotalRecords = 0 Then
                'lblInfo.InnerText = "Tiada rekod"
            Else
                Dim startRec As Integer = (gv.PageIndex * gv.PageSize) + 1
                Dim endRec As Integer = Math.Min((gv.PageIndex + 1) * gv.PageSize, TotalRecords)
                lblInfo.InnerText = String.Format("Paparan {0} hingga {1} dari {2} rekod", startRec, endRec, TotalRecords)
            End If
        End If

        ' ---- Segerakkan dropdown page-size dengan PageSize semasa ----
        Dim ddlSize As DropDownList = CType(e.Row.FindControl("ddlPageSize"), DropDownList)
        If ddlSize IsNot Nothing Then
            Dim item As System.Web.UI.WebControls.ListItem = ddlSize.Items.FindByValue(gv.PageSize.ToString())
            If item IsNot Nothing Then
                ddlSize.ClearSelection()
                item.Selected = True
            End If
        End If

        ' ---- Bina butang nombor halaman (1 2 3 4 5 ... ›) ----
        Dim pnl As HtmlGenericControl = CType(e.Row.FindControl("pnlPageNumbers"), HtmlGenericControl)
        If pnl IsNot Nothing Then
            BuildPagerButtons(pnl, currentPage, totalPages)
        End If

    End Sub

    ''' <summary>
    ''' Bina senarai butang nombor halaman secara dinamik, dengan "..."
    ''' bila jumlah halaman banyak. Strategi: sentiasa papar halaman 1,
    ''' halaman terakhir, dan jiran terdekat currentPage; selebihnya "...".
    ''' </summary>
    Private Sub BuildPagerButtons(container As HtmlGenericControl, currentPage As Integer, totalPages As Integer)

        container.Controls.Clear()

        If totalPages <= 0 Then Exit Sub

        ' Butang "‹" (sebelumnya)
        AddPagerLink(container, "&lsaquo;", currentPage - 1, currentPage > 1)

        Dim pagesToShow As New SortedSet(Of Integer)
        pagesToShow.Add(1)
        pagesToShow.Add(totalPages)
        For p As Integer = Math.Max(1, currentPage - 1) To Math.Min(totalPages, currentPage + 1)
            pagesToShow.Add(p)
        Next

        Dim lastRendered As Integer = 0
        For Each pageNum As Integer In pagesToShow
            If pageNum > lastRendered + 1 Then
                Dim ellipsis As New HtmlGenericControl("span")
                ellipsis.Attributes("class") = "pager-ellipsis"
                ellipsis.InnerText = "..."
                container.Controls.Add(ellipsis)
            End If

            AddPagerLink(container, pageNum.ToString(), pageNum, True, pageNum = currentPage)
            lastRendered = pageNum
        Next

        ' Butang "›" (seterusnya)
        AddPagerLink(container, "&rsaquo;", currentPage + 1, currentPage < totalPages)

    End Sub

    ''' <summary>
    ''' Tambah satu butang pager (LinkButton) ke dalam container.
    ''' targetPage adalah nombor halaman 1-based.
    ''' </summary>
    Private Sub AddPagerLink(container As HtmlGenericControl, text As String, targetPage As Integer,
                              enabled As Boolean, Optional isActive As Boolean = False)

        Dim lnk As New LinkButton()
        lnk.Text = text
        lnk.CommandName = "GotoPage" ' nama neutral - elak bubble ke GridView punya paging bawaan
        lnk.CommandArgument = targetPage.ToString()
        lnk.CssClass = "pager-btn" & If(isActive, " active", "") & If(Not enabled, " disabled", "")
        lnk.Enabled = enabled
        AddHandler lnk.Click, AddressOf PagerLink_Click
        container.Controls.Add(lnk)

    End Sub

    ''' <summary>
    ''' Handler generik untuk semua butang pager nombor. GridView.PageIndex
    ''' ditetapkan terus (0-based) berdasarkan CommandArgument (1-based).
    ''' </summary>
    Private Sub PagerLink_Click(sender As Object, e As EventArgs)
        Dim lnk As LinkButton = CType(sender, LinkButton)
        Dim targetPage As Integer = Convert.ToInt32(lnk.CommandArgument)
        gvLesenSummary.PageIndex = targetPage - 1
        BindGrid()
    End Sub

    ''' <summary>
    ''' Tukar bilangan rekod per halaman.
    ''' </summary>
    Protected Sub ddlPageSize_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ddlSize As DropDownList = CType(sender, DropDownList)
        gvLesenSummary.PageSize = Convert.ToInt32(ddlSize.SelectedValue)
        gvLesenSummary.PageIndex = 0
        BindGrid()
    End Sub



End Class