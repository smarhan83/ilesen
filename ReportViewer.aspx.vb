Imports System.IO
Imports CrystalDecisions.CrystalReports.Engine
Imports CrystalDecisions.Shared
Imports System.Data.Common.DbConnectionStringBuilder

Public Class wfrmReport
    Inherits System.Web.UI.Page


#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub
    'Protected WithEvents reportSys As CrystalDecisions.Web.CrystalReportViewer
    'Protected WithEvents RptName As WebControls.Lbl

    'NOTE: The following placeholder declaration is required by the Web Form Designer.
    'Do not delete or move it.
    Private designerPlaceholderDeclaration As System.Object
    'Protected WithEvents reportSys As CrystalDecisions.Web.CrystalReportViewer

    Private crRep, crsubrep As ReportDocument
    Private crParameterFields As ParameterFields
    Private crParameterField As ParameterField
    Private crParameterValues As ParameterValues
    Private crParameterDiscreteValue As ParameterDiscreteValue



    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
        'crRep.SetDatabaseLogon("sa", "qwert", "ANANDPC", "THPMIS")

        ' the Above line works even if only username and password is supplied as below

        'crReportDocument.SetDatabaseLogon("username", "password") ', "sql-server", "database")

        ' this will hide the group tree
        reportSys.DisplayGroupTree = False

        Call pLoadReport_new()
    End Sub

#End Region

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'Call pLoadReport_new()
        If Session.Item("isDisablePrintSession") = "Y" Then
            reportSys.HasExportButton = False
            reportSys.HasPrintButton = False
        End If

    End Sub
    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)

    End Sub

    Private Sub Button2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)

        crRep.PrintOptions.PrinterName = "\\COMMAN\hp color LaserJet 2550 PCL 6"
        crRep.PrintToPrinter(1, False, 0, 0)

    End Sub

    Sub pLoadReport_new()
        'Put user code to initialize the page here
        If Not IsPostBack Then
            'Me.RptName.Text = Context.Items("ReportName")
        End If
        'MsgBox("")
        Try

            Dim coninfo As ConnectionInfo
            Dim crTbls As Tables
            Dim logoninfo As TableLogOnInfo
            Dim crDatabase As Database
            Dim crrepobjs As ReportObjects
            Dim crsubrepobj As SubreportObject


            Dim cntr As Integer
            crRep = New ReportDocument

            Dim pathUrl As String = Session.Item("pathUrl" + Request.QueryString("name"))

            Dim finalPath As String = pathUrl + "/" + Session.Item("ReportName" + Request.QueryString("name"))
            ' crRep.Load(Server.MapPath(RptName.Text), OpenReportMethod.OpenReportByDefault)

            crRep.Load(Server.MapPath(finalPath), CrystalDecisions.[Shared].OpenReportMethod.OpenReportByDefault)

            'Dim oStream As New MemoryStream '

            crDatabase = crRep.Database
            crTbls = crDatabase.Tables


            coninfo = New ConnectionInfo

            Dim dbAttributes As CrystalDecisions.Shared.DbConnectionAttributes
            'Dim srvrName As String = "172.19.30.32\DB"
            'Dim dbName As String = "IDEAS_2020_DB"
            'Dim usrID As String = "sa"
            'Dim pssword As String = "P@ssword"

            Dim connectionstring As String = ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ToString
            Dim builder As System.Data.SqlClient.SqlConnectionStringBuilder = New System.Data.SqlClient.SqlConnectionStringBuilder(connectionstring)
            Dim srvrName As String = builder.DataSource
            Dim dbName As String = builder.InitialCatalog
            Dim usrID As String = builder.UserID
            Dim pssword As String = builder.Password
            '    crRep.SetDataSource("ReportDSN2006")

            coninfo.ServerName = srvrName
            coninfo.DatabaseName = dbName
            coninfo.UserID = usrID
            coninfo.Password = pssword

            dbAttributes = New CrystalDecisions.Shared.DbConnectionAttributes
            dbAttributes.Collection.Set("Auto Translate", "-1")
            dbAttributes.Collection.Set("Connect Timeout", "15")
            dbAttributes.Collection.Set("Data Source", srvrName)
            dbAttributes.Collection.Set("General Timeout", "0")
            dbAttributes.Collection.Set("Initial Catalog", dbName)
            dbAttributes.Collection.Set("Integrated Security", False)
            dbAttributes.Collection.Set("Locale Identifier", "5129")
            dbAttributes.Collection.Set("OLE DB Services", "-5")
            dbAttributes.Collection.Set("Provider", "SQLOLEDB")
            dbAttributes.Collection.Set("Tag with column collation when possible", "0")
            dbAttributes.Collection.Set("Use DSN Default Properties", False)
            dbAttributes.Collection.Set("Use Encryption for Data", "0")
            'setup the connection
            coninfo = New CrystalDecisions.Shared.ConnectionInfo
            coninfo.LogonProperties.Clear()
            coninfo.Attributes.Collection.Clear()
            coninfo.DatabaseName = dbName
            coninfo.ServerName = srvrName
            coninfo.UserID = usrID
            coninfo.Password = pssword
            coninfo.Attributes.Collection.Set("Database DLL", "crdb_ado.dll")
            coninfo.Attributes.Collection.Set("QE_DatabaseName", dbName)
            coninfo.Attributes.Collection.Set("QE_DatabaseType", "OLE DB (ADO)")
            coninfo.Attributes.Collection.Set("QE_LogonProperties", dbAttributes)
            coninfo.Attributes.Collection.Set("QE_ServerDescription", srvrName)
            coninfo.Attributes.Collection.Set("QE_SQLDB", True)
            coninfo.Attributes.Collection.Set("SSO Enabled", False)
            coninfo.LogonProperties = dbAttributes.Collection

            crRep.SetDatabaseLogon(coninfo.UserID, coninfo.Password, coninfo.ServerName, coninfo.DatabaseName, True)

            Dim temptbl As CrystalDecisions.CrystalReports.Engine.Table

            'CrystalDecisions.CrystalReports.Engine.InternalDataSourceConnections()

            For Each temptbl In crTbls

                logoninfo = temptbl.LogOnInfo
                logoninfo.ConnectionInfo = coninfo
                temptbl.ApplyLogOnInfo(logoninfo)
                temptbl.LogOnInfo.ConnectionInfo = coninfo

            Next

            'THIS STUFF HERE IS FOR REPORTS HAVING SUBREPORTS 
            ' set the sections object to the current report's section 32:     
            Dim crSections = crRep.ReportDefinition.Sections

            ' loop through all the sections to find all the report objects 
            Dim crsection As Section
            For Each crsection In crSections
                crrepobjs = crsection.ReportObjects
                Dim crrepobj As ReportObject
                For Each crrepobj In crrepobjs
                    If crrepobj.Kind = ReportObjectKind.SubreportObject Then
                        crsubrepobj = CType(crrepobj, SubreportObject)

                        'open the subreport object and logon as for the general report 
                        crsubrep = crsubrepobj.OpenSubreport(crsubrepobj.SubreportName)
                        crDatabase = crsubrep.Database
                        crTbls = crDatabase.Tables

                        For Each temptbl In crTbls

                            logoninfo = temptbl.LogOnInfo
                            logoninfo.ConnectionInfo = coninfo
                            temptbl.ApplyLogOnInfo(logoninfo)
                            temptbl.LogOnInfo.ConnectionInfo = coninfo

                        Next

                        'crsubParameterField = crsubParameterFields("pEstateID")
                        'crsubParameterValues = crsubParameterField.CurrentValues
                        'crsubParameterDiscreteValue = New ParameterDiscreteValue
                        'crsubParameterDiscreteValue.Value = 1
                        'crsubParameterValues.Add(crsubParameterDiscreteValue)

                    End If

                Next

            Next

            Me.reportSys.ReportSource = crRep

            crParameterFields = reportSys.ParameterFieldInfo

            Dim pobjData = Session.Item("pobjData" + Request.QueryString("name"))


            ''Dim pobjData(1, 1) As String
            ''pobjData(0, 0) = "pCategory" : pobjData(0, 1) = "Fixed"
            ''pobjData(1, 0) = "pNumber" : pobjData(1, 1) = 123

            If Not pobjData Is Nothing Then
                If crParameterFields.Count > 0 Then
                    If UBound(pobjData) <> (crParameterFields.Count - 1) Then
                        'Me.Label1.Text = "Parameters does not match with the report"
                    End If
                Else 'Me.Label1.Text = "Parameters does not match with the report"
                End If
            End If


            Dim discreteParam As New CrystalDecisions.Shared.ParameterDiscreteValue
            Dim currentValues As New CrystalDecisions.Shared.ParameterValues

            ''new code
            Dim i, j As Integer

            With crParameterFields
                For i = 1 To .Count

                    For j = 0 To pobjData.GetUpperBound(0)
                        If Trim(UCase(pobjData(j, 0))) = Trim(UCase(.Item(i - 1).ParameterFieldName)) Then
                            Dim lParaName = Trim(.Item(i - 1).ParameterFieldName)

                            Select Case .Item(i - 1).ParameterValueKind

                                Case ParameterValueKind.BooleanParameter
                                    ' .Add(CBool(pobjData(j, 1)))
                                    crParameterField = crParameterFields(lParaName)
                                    crParameterValues = crParameterField.CurrentValues
                                    crParameterDiscreteValue = New ParameterDiscreteValue
                                    crParameterDiscreteValue.Value = CBool(pobjData(j, 1))
                                    crParameterValues.Add(crParameterDiscreteValue)
                                    crRep.SetParameterValue(lParaName, crParameterDiscreteValue.Value)
                                Case ParameterValueKind.CurrencyParameter
                                    '.Add(CDbl(pobjData(j, 1)))
                                    crParameterField = crParameterFields(lParaName)
                                    crParameterValues = crParameterField.CurrentValues
                                    crParameterDiscreteValue = New ParameterDiscreteValue
                                    crParameterDiscreteValue.Value = CDbl(pobjData(j, 1))
                                    crParameterValues.Add(crParameterDiscreteValue)
                                    crRep.SetParameterValue(lParaName, crParameterDiscreteValue.Value)
                                Case ParameterValueKind.DateParameter
                                    ' .Add(CDate(pobjData(j, 1)))
                                    crParameterField = crParameterFields(lParaName)
                                    crParameterValues = crParameterField.CurrentValues
                                    crParameterDiscreteValue = New ParameterDiscreteValue
                                    crParameterDiscreteValue.Value = CDate(pobjData(j, 1))
                                    crParameterValues.Add(crParameterDiscreteValue)
                                    crRep.SetParameterValue(lParaName, crParameterDiscreteValue.Value)
                                Case ParameterValueKind.DateTimeParameter
                                    '.Add(CType(pobjData(j, 1), DateTime))
                                    crParameterField = crParameterFields(lParaName)
                                    crParameterValues = crParameterField.CurrentValues
                                    crParameterDiscreteValue = New ParameterDiscreteValue
                                    crParameterDiscreteValue.Value = CType(pobjData(j, 1), DateTime)
                                    crParameterValues.Add(crParameterDiscreteValue)
                                    crRep.SetParameterValue(lParaName, crParameterDiscreteValue.Value)
                                Case ParameterValueKind.NumberParameter
                                    crParameterField = crParameterFields(lParaName)
                                    crParameterValues = crParameterField.CurrentValues
                                    crParameterDiscreteValue = New ParameterDiscreteValue
                                    crParameterDiscreteValue.Value = CDbl(pobjData(j, 1))
                                    crParameterValues.Add(crParameterDiscreteValue)
                                    crRep.SetParameterValue(lParaName, crParameterDiscreteValue.Value)
                                Case ParameterValueKind.StringParameter
                                    crParameterField = crParameterFields(lParaName)
                                    crParameterValues = crParameterField.CurrentValues
                                    crParameterDiscreteValue = New ParameterDiscreteValue
                                    crParameterDiscreteValue.Value = CStr(pobjData(j, 1))
                                    crParameterValues.Add(crParameterDiscreteValue)
                                    crRep.SetParameterValue(lParaName, crParameterDiscreteValue.Value)
                                Case ParameterValueKind.TimeParameter
                                    '.Add(CStr(pobjData(j, 1)))
                                    crParameterField = crParameterFields(lParaName)
                                    crParameterValues = crParameterField.CurrentValues
                                    crParameterDiscreteValue = New ParameterDiscreteValue
                                    crParameterDiscreteValue.Value = CStr(pobjData(j, 1))
                                    crParameterValues.Add(crParameterDiscreteValue)
                                    crRep.SetParameterValue(lParaName, crParameterDiscreteValue.Value)
                            End Select
                        End If
                    Next
                Next
            End With

            reportSys.ReportSource = crRep

            'For i As Integer = 0 To UBound(pobjData)
            '    crRep.SetParameterValue(pobjData(i, 0), pobjData(i, 1))
            '    'MsgBox(pobjData(i, 0) + " - " + pobjData(i, 1))
            'Next

        Catch ex As Exception
            '  Throw New System.Exception(ex.Message)
            ErrorTxt.Text = ex.Message
        Finally

            'crRep.PrintOptions.PrinterName = "\\COMMAN\hp color LaserJet 2550 PCL 6"
            'crRep.PrintToPrinter(1, False, 1, 0)
        End Try
    End Sub

    Private Sub reportSys_Load(sender As Object, e As EventArgs) Handles reportSys.Load

        Dim reportPrintType As String = LCase(Session.Item("reportPrintType"))
        If reportPrintType = "pdf" Then

            Call Me.PrintToPDF(Me, New System.EventArgs)

        ElseIf reportPrintType = "excel" Or reportPrintType = "word" Or reportPrintType = "csv" Then

            Call Me.Export(Me, New System.EventArgs)

        End If

    End Sub

    Protected Sub Export(sender As Object, e As EventArgs)

        Dim formatType As ExportFormatType = ExportFormatType.NoFormat
        'rbFormat.SelectedItem.Value

        Select Case LCase(Session.Item("reportPrintType"))
            Case "word"
                formatType = ExportFormatType.WordForWindows
                Exit Select
            Case "pdf"
                formatType = ExportFormatType.PortableDocFormat
                Exit Select
            Case "excel"
                formatType = ExportFormatType.Excel
                Exit Select
            Case "csv"
                formatType = ExportFormatType.CharacterSeparatedValues
                Exit Select
        End Select
        crRep.ExportToHttpResponse(formatType, Response, True, Session.Item("reportName" + Request.QueryString("name")))
        Response.End()
    End Sub

    Protected Sub PrintToPDF(sender As Object, e As EventArgs)

        crRep.ExportToHttpResponse(CrystalDecisions.[Shared].ExportFormatType.PortableDocFormat, Context.Response, False, Session.Item("reportName" + Request.QueryString("name")))

    End Sub

    Private Sub reportSys_Unload(sender As Object, e As EventArgs) Handles reportSys.Unload
        crRep.Close()
        crRep.Dispose()
    End Sub
End Class
