Imports System
Imports System.Collections.Generic
Imports System.Configuration
Imports System.Data
Imports System.Data.Entity.Infrastructure
Imports System.Data.SqlClient
Imports System.IO
Imports CrystalDecisions.CrystalReports.Engine
Imports CrystalDecisions.Shared
Imports iTextSharp.text
Imports iTextSharp.text.pdf

Partial Class wfrmReport1
    Inherits System.Web.UI.Page

    Private crRep As ReportDocument
    Private crsubrep As ReportDocument
    Private crParameterFields As ParameterFields
    Private crParameterField As ParameterField
    Private crParameterValues As ParameterValues
    Private crParameterDiscreteValue As ParameterDiscreteValue

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        ShowReportKelulusan()
    End Sub

    Private Sub ShowReportKelulusan()
        Try
            CombineReportsToPDF()
        Catch ex As Exception
            ' Handle or log exception
            Response.Write("Error: " & ex.Message)
        End Try
    End Sub

    Protected Sub CombineReportsToPDF()
        Dim pdfFiles As New List(Of Byte())()

        ' 1. Validate QueryString and Session parameters
        Dim reportKey As String = Request.QueryString("name")
        If String.IsNullOrEmpty(reportKey) Then
            Response.Write("Report name parameter missing.")
            Return
        End If

        Dim pathUrlObj As Object = Session.Item("pathUrl" & reportKey)
        Dim reportNameObj As Object = Session.Item("ReportName" & reportKey)

        If pathUrlObj Is Nothing OrElse reportNameObj Is Nothing Then
            Response.Write("Session data expired or missing for key: " & reportKey)
            Return
        End If

        Dim finalPath As String = pathUrlObj.ToString() & "/" & reportNameObj.ToString()

        ' 2. Initialize and Load Crystal Report
        crRep = New ReportDocument()
        crRep.Load(Server.MapPath(finalPath), OpenReportMethod.OpenReportByDefault)

        ' 3. Configure Database Connection Info
        Dim connectionstring As String = ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString
        Dim builder As New SqlConnectionStringBuilder(connectionstring)

        Dim dbAttributes As New DbConnectionAttributes()
        dbAttributes.Collection.Set("Auto Translate", "-1")
        dbAttributes.Collection.Set("Connect Timeout", "15")
        dbAttributes.Collection.Set("Data Source", builder.DataSource)
        dbAttributes.Collection.Set("General Timeout", "0")
        dbAttributes.Collection.Set("Initial Catalog", builder.InitialCatalog)
        dbAttributes.Collection.Set("Integrated Security", False)
        dbAttributes.Collection.Set("Locale Identifier", "5129")
        dbAttributes.Collection.Set("OLE DB Services", "-5")
        dbAttributes.Collection.Set("Provider", "SQLOLEDB")
        dbAttributes.Collection.Set("Tag with column collation when possible", "0")
        dbAttributes.Collection.Set("Use DSN Default Properties", False)
        dbAttributes.Collection.Set("Use Encryption for Data", "0")

        Dim coninfo As New ConnectionInfo()
        coninfo.DatabaseName = builder.InitialCatalog
        coninfo.ServerName = builder.DataSource
        coninfo.UserID = builder.UserID
        coninfo.Password = builder.Password
        coninfo.Attributes.Collection.Set("Database DLL", "crdb_ado.dll")
        coninfo.Attributes.Collection.Set("QE_DatabaseName", builder.InitialCatalog)
        coninfo.Attributes.Collection.Set("QE_DatabaseType", "OLE DB (ADO)")
        coninfo.Attributes.Collection.Set("QE_LogonProperties", dbAttributes)
        coninfo.Attributes.Collection.Set("QE_ServerDescription", builder.DataSource)
        coninfo.Attributes.Collection.Set("QE_SQLDB", True)
        coninfo.Attributes.Collection.Set("SSO Enabled", False)
        coninfo.LogonProperties = dbAttributes.Collection

        crRep.SetDatabaseLogon(coninfo.UserID, coninfo.Password, coninfo.ServerName, coninfo.DatabaseName, True)

        ' Apply connection info to tables
        For Each temptbl As CrystalDecisions.CrystalReports.Engine.Table In crRep.Database.Tables
            Dim logoninfo As TableLogOnInfo = temptbl.LogOnInfo
            logoninfo.ConnectionInfo = coninfo
            temptbl.ApplyLogOnInfo(logoninfo)
        Next

        ' Apply connection info to subreports
        For Each crsection As CrystalDecisions.CrystalReports.Engine.Section In crRep.ReportDefinition.Sections
            For Each crrepobj As ReportObject In crsection.ReportObjects
                If crrepobj.Kind = ReportObjectKind.SubreportObject Then
                    Dim crsubrepobj As SubreportObject = CType(crrepobj, SubreportObject)
                    crsubrep = crsubrepobj.OpenSubreport(crsubrepobj.SubreportName)
                    For Each temptbl As CrystalDecisions.CrystalReports.Engine.Table In crsubrep.Database.Tables
                        Dim logoninfo As TableLogOnInfo = temptbl.LogOnInfo
                        logoninfo.ConnectionInfo = coninfo
                        temptbl.ApplyLogOnInfo(logoninfo)
                    Next
                End If
            Next
        Next

        Me.reportSys.ReportSource = crRep
        crParameterFields = reportSys.ParameterFieldInfo

        ' 4. Safely Apply Parameters
        Dim pobjData As Object(,) = TryCast(Session.Item("pobjData" & reportKey), Object(,))

        If pobjData IsNot Nothing AndAlso crParameterFields IsNot Nothing Then
            For i As Integer = 1 To crParameterFields.Count
                Dim lParaName As String = Trim(crParameterFields.Item(i - 1).ParameterFieldName)

                For j As Integer = 0 To pobjData.GetUpperBound(0)
                    If String.Equals(Trim(CStr(pobjData(j, 0))), lParaName, StringComparison.OrdinalIgnoreCase) Then

                        Dim paramVal As Object = pobjData(j, 1)

                        Select Case crParameterFields.Item(i - 1).ParameterValueKind
                            Case ParameterValueKind.BooleanParameter
                                crRep.SetParameterValue(lParaName, CBool(paramVal))
                            Case ParameterValueKind.CurrencyParameter, ParameterValueKind.NumberParameter
                                crRep.SetParameterValue(lParaName, CDbl(paramVal))
                            Case ParameterValueKind.DateParameter
                                crRep.SetParameterValue(lParaName, CDate(paramVal))
                            Case ParameterValueKind.DateTimeParameter
                                crRep.SetParameterValue(lParaName, CType(paramVal, DateTime))
                            Case ParameterValueKind.StringParameter, ParameterValueKind.TimeParameter
                                crRep.SetParameterValue(lParaName, CStr(paramVal))
                        End Select
                    End If
                Next
            Next
        End If

        ' 5. Export Crystal Report to Byte Array
        Using crStream As Stream = crRep.ExportToStream(ExportFormatType.PortableDocFormat)
            Using ms As New MemoryStream()
                crStream.CopyTo(ms)
                pdfFiles.Add(ms.ToArray())
            End Using
        End Using

        ' Cleanup Crystal Report
        If crsubrep IsNot Nothing Then
            crsubrep.Close()
            crsubrep.Dispose()
        End If
        If crRep IsNot Nothing Then
            crRep.Close()
            crRep.Dispose()
        End If

        ' 6. Append External PDF Files
        Dim serverPdfs() As String = {
            Server.MapPath("~/lesen/report/extras/Portal_Rasmi_Larangan_Merokok.pdf"),
            Server.MapPath("~/Uploads/file2.pdf")
        }

        For Each path In serverPdfs
            If File.Exists(path) Then
                pdfFiles.Add(File.ReadAllBytes(path))
            End If
        Next

        ' 7. Merge All PDFs using iTextSharp & Serve Output
        If pdfFiles.Count > 0 Then
            Using finalStream As New MemoryStream()
                Dim doc As New Document()
                Dim pdfCopy As New PdfCopy(doc, finalStream)
                doc.Open()

                For Each pdf As Byte() In pdfFiles
                    Dim reader As New PdfReader(pdf)

                    For k As Integer = 1 To reader.NumberOfPages
                        pdfCopy.AddPage(pdfCopy.GetImportedPage(reader, k))
                    Next

                    pdfCopy.FreeReader(reader)
                    reader.Close()
                Next

                doc.Close()

                Dim finalPDF As Byte() = finalStream.ToArray()

                Response.Clear()
                Response.ContentType = "application/pdf"
                Response.AddHeader("Content-Disposition", "inline; filename=CombinedReport.pdf")
                Response.OutputStream.Write(finalPDF, 0, finalPDF.Length)
                Response.Flush()
                Response.End()
            End Using
        End If
    End Sub

    Protected Sub Page_Unload(sender As Object, e As EventArgs)
        Try
            If crsubrep IsNot Nothing Then
                crsubrep.Close()
                crsubrep.Dispose()
            End If

            If crRep IsNot Nothing Then
                crRep.Close()
                crRep.Dispose()
            End If
        Catch
        End Try
    End Sub
End Class

'Imports System
'Imports System.Collections.Generic
'Imports System.Configuration
'Imports System.Data
'Imports System.Data.SqlClient
'Imports System.Globalization
'Imports System.IO
'Imports System.Reflection
'Imports System.Security.Cryptography
'Imports ClosedXML.Excel
'Imports com.itextpdf.text
'Imports CrystalDecisions.CrystalReports.Engine
'Imports CrystalDecisions.Shared
'Imports CrystalDecisions.[Shared].Json
'Imports DocumentFormat.OpenXml.Bibliography
'Imports iTextSharp.text
'Imports iTextSharp.text.pdf
'Imports Microsoft.SqlServer.Management.Smo.Mail

'Partial Class wfrmReport1
'    Inherits System.Web.UI.Page

'    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

'        ShowReportKelulusan()

'    End Sub

'    Private Sub ShowReportKelulusan()
'        Dim sql As String = ""
'        Dim sqlSub As String = ""
'        Dim rptVarList As New List(Of String)()
'        Dim reportVar As String = ""

'        Try
'            'GenerateReportKelulusan()
'            CombineReportsToPDF()

'        Catch ex As Exception
'            'MsgBox(ex.Message)
'        End Try

'    End Sub

'    Private crRep, crsubrep As ReportDocument
'    Private crParameterFields As ParameterFields
'    Private crParameterField As ParameterField
'    Private crParameterValues As ParameterValues
'    Private crParameterDiscreteValue As ParameterDiscreteValue


'    Protected Sub CombineReportsToPDF()

'        Dim coninfo As ConnectionInfo
'        Dim crTbls As Tables
'        Dim logoninfo As TableLogOnInfo
'        Dim crDatabase As Database
'        Dim crrepobjs As ReportObjects
'        Dim crsubrepobj As SubreportObject

'        Dim pdfFiles As New List(Of Byte())()
'        'Dim rptPaths As String() = {finalPath, finalPath}

'        Dim pathUrl As String
'        Dim finalPath As String
'        'Dim reportNameArr As String = "suratkelulusan_v2"

'        pathUrl = Session.Item("pathUrl" + Request.QueryString("name"))

'        finalPath = pathUrl + "/" + Session.Item("ReportName" + Request.QueryString("name"))

'        'Dim rptDoc As New ReportDocument()
'        crRep = New ReportDocument
'        'crRep.Load(Server.MapPath(path))
'        crRep.Load(Server.MapPath(finalPath), CrystalDecisions.[Shared].OpenReportMethod.OpenReportByDefault)

'        ' Kalau ada parameter / data source, set di sini
'        ' rptDoc.SetParameterValue("paramName", value)
'        ' rptDoc.SetDataSource(yourData)

'        crDatabase = crRep.Database
'        crTbls = crDatabase.Tables


'        coninfo = New ConnectionInfo

'        Dim dbAttributes As CrystalDecisions.Shared.DbConnectionAttributes

'        Dim connectionstring As String = ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ToString
'        Dim builder As System.Data.SqlClient.SqlConnectionStringBuilder = New System.Data.SqlClient.SqlConnectionStringBuilder(connectionstring)
'        Dim srvrName As String = builder.DataSource
'        Dim dbName As String = builder.InitialCatalog
'        Dim usrID As String = builder.UserID
'        Dim pssword As String = builder.Password
'        '    crRep.SetDataSource("ReportDSN2006")

'        coninfo.ServerName = srvrName
'        coninfo.DatabaseName = dbName
'        coninfo.UserID = usrID
'        coninfo.Password = pssword

'        dbAttributes = New CrystalDecisions.Shared.DbConnectionAttributes
'        dbAttributes.Collection.Set("Auto Translate", "-1")
'        dbAttributes.Collection.Set("Connect Timeout", "15")
'        dbAttributes.Collection.Set("Data Source", srvrName)
'        dbAttributes.Collection.Set("General Timeout", "0")
'        dbAttributes.Collection.Set("Initial Catalog", dbName)
'        dbAttributes.Collection.Set("Integrated Security", False)
'        dbAttributes.Collection.Set("Locale Identifier", "5129")
'        dbAttributes.Collection.Set("OLE DB Services", "-5")
'        dbAttributes.Collection.Set("Provider", "SQLOLEDB")
'        dbAttributes.Collection.Set("Tag with column collation when possible", "0")
'        dbAttributes.Collection.Set("Use DSN Default Properties", False)
'        dbAttributes.Collection.Set("Use Encryption for Data", "0")
'        'setup the connection
'        coninfo = New CrystalDecisions.Shared.ConnectionInfo
'        coninfo.LogonProperties.Clear()
'        coninfo.Attributes.Collection.Clear()
'        coninfo.DatabaseName = dbName
'        coninfo.ServerName = srvrName
'        coninfo.UserID = usrID
'        coninfo.Password = pssword
'        coninfo.Attributes.Collection.Set("Database DLL", "crdb_ado.dll")
'        coninfo.Attributes.Collection.Set("QE_DatabaseName", dbName)
'        coninfo.Attributes.Collection.Set("QE_DatabaseType", "OLE DB (ADO)")
'        coninfo.Attributes.Collection.Set("QE_LogonProperties", dbAttributes)
'        coninfo.Attributes.Collection.Set("QE_ServerDescription", srvrName)
'        coninfo.Attributes.Collection.Set("QE_SQLDB", True)
'        coninfo.Attributes.Collection.Set("SSO Enabled", False)
'        coninfo.LogonProperties = dbAttributes.Collection

'        crRep.SetDatabaseLogon(coninfo.UserID, coninfo.Password, coninfo.ServerName, coninfo.DatabaseName, True)

'        Dim temptbl As CrystalDecisions.CrystalReports.Engine.Table

'        'CrystalDecisions.CrystalReports.Engine.InternalDataSourceConnections()

'        For Each temptbl In crTbls

'            logoninfo = temptbl.LogOnInfo
'            logoninfo.ConnectionInfo = coninfo
'            temptbl.ApplyLogOnInfo(logoninfo)
'            temptbl.LogOnInfo.ConnectionInfo = coninfo

'        Next

'        'THIS STUFF HERE IS FOR REPORTS HAVING SUBREPORTS 
'        ' set the sections object to the current report's section 32:     
'        Dim crSections = crRep.ReportDefinition.Sections

'        ' loop through all the sections to find all the report objects 
'        Dim crsection As CrystalDecisions.CrystalReports.Engine.Section
'        For Each crsection In crSections
'            crrepobjs = crsection.ReportObjects
'            Dim crrepobj As ReportObject
'            For Each crrepobj In crrepobjs
'                If crrepobj.Kind = ReportObjectKind.SubreportObject Then
'                    crsubrepobj = CType(crrepobj, SubreportObject)

'                    'open the subreport object and logon as for the general report 
'                    crsubrep = crsubrepobj.OpenSubreport(crsubrepobj.SubreportName)
'                    crDatabase = crsubrep.Database
'                    crTbls = crDatabase.Tables

'                    For Each temptbl In crTbls

'                        logoninfo = temptbl.LogOnInfo
'                        logoninfo.ConnectionInfo = coninfo
'                        temptbl.ApplyLogOnInfo(logoninfo)
'                        temptbl.LogOnInfo.ConnectionInfo = coninfo

'                    Next

'                End If

'            Next

'        Next

'        Me.reportSys.ReportSource = crRep

'        crParameterFields = reportSys.ParameterFieldInfo

'        Dim pobjData = Session.Item("pobjData" + Request.QueryString("name"))


'        If Not pobjData Is Nothing Then
'            If crParameterFields.Count > 0 Then
'                If UBound(pobjData) <> (crParameterFields.Count - 1) Then
'                    'Me.Label1.Text = "Parameters does not match with the report"
'                End If
'            Else 'Me.Label1.Text = "Parameters does not match with the report"
'            End If
'        End If


'        Dim discreteParam As New CrystalDecisions.Shared.ParameterDiscreteValue
'        Dim currentValues As New CrystalDecisions.Shared.ParameterValues

'        ''new code
'        Dim i, j As Integer

'        With crParameterFields
'            For i = 1 To .Count

'                For j = 0 To pobjData.GetUpperBound(0)
'                    If Trim(UCase(pobjData(j, 0))) = Trim(UCase(.Item(i - 1).ParameterFieldName)) Then
'                        Dim lParaName = Trim(.Item(i - 1).ParameterFieldName)

'                        Select Case .Item(i - 1).ParameterValueKind

'                            Case ParameterValueKind.BooleanParameter
'                                ' .Add(CBool(pobjData(j, 1)))
'                                crParameterField = crParameterFields(lParaName)
'                                crParameterValues = crParameterField.CurrentValues
'                                crParameterDiscreteValue = New ParameterDiscreteValue
'                                crParameterDiscreteValue.Value = CBool(pobjData(j, 1))
'                                crParameterValues.Add(crParameterDiscreteValue)
'                                crRep.SetParameterValue(lParaName, crParameterDiscreteValue.Value)
'                            Case ParameterValueKind.CurrencyParameter
'                                '.Add(CDbl(pobjData(j, 1)))
'                                crParameterField = crParameterFields(lParaName)
'                                crParameterValues = crParameterField.CurrentValues
'                                crParameterDiscreteValue = New ParameterDiscreteValue
'                                crParameterDiscreteValue.Value = CDbl(pobjData(j, 1))
'                                crParameterValues.Add(crParameterDiscreteValue)
'                                crRep.SetParameterValue(lParaName, crParameterDiscreteValue.Value)
'                            Case ParameterValueKind.DateParameter
'                                ' .Add(CDate(pobjData(j, 1)))
'                                crParameterField = crParameterFields(lParaName)
'                                crParameterValues = crParameterField.CurrentValues
'                                crParameterDiscreteValue = New ParameterDiscreteValue
'                                crParameterDiscreteValue.Value = CDate(pobjData(j, 1))
'                                crParameterValues.Add(crParameterDiscreteValue)
'                                crRep.SetParameterValue(lParaName, crParameterDiscreteValue.Value)
'                            Case ParameterValueKind.DateTimeParameter
'                                '.Add(CType(pobjData(j, 1), DateTime))
'                                crParameterField = crParameterFields(lParaName)
'                                crParameterValues = crParameterField.CurrentValues
'                                crParameterDiscreteValue = New ParameterDiscreteValue
'                                crParameterDiscreteValue.Value = CType(pobjData(j, 1), DateTime)
'                                crParameterValues.Add(crParameterDiscreteValue)
'                                crRep.SetParameterValue(lParaName, crParameterDiscreteValue.Value)
'                            Case ParameterValueKind.NumberParameter
'                                crParameterField = crParameterFields(lParaName)
'                                crParameterValues = crParameterField.CurrentValues
'                                crParameterDiscreteValue = New ParameterDiscreteValue
'                                crParameterDiscreteValue.Value = CDbl(pobjData(j, 1))
'                                crParameterValues.Add(crParameterDiscreteValue)
'                                crRep.SetParameterValue(lParaName, crParameterDiscreteValue.Value)
'                            Case ParameterValueKind.StringParameter
'                                crParameterField = crParameterFields(lParaName)
'                                crParameterValues = crParameterField.CurrentValues
'                                crParameterDiscreteValue = New ParameterDiscreteValue
'                                crParameterDiscreteValue.Value = CStr(pobjData(j, 1))
'                                crParameterValues.Add(crParameterDiscreteValue)
'                                crRep.SetParameterValue(lParaName, crParameterDiscreteValue.Value)
'                            Case ParameterValueKind.TimeParameter
'                                '.Add(CStr(pobjData(j, 1)))
'                                crParameterField = crParameterFields(lParaName)
'                                crParameterValues = crParameterField.CurrentValues
'                                crParameterDiscreteValue = New ParameterDiscreteValue
'                                crParameterDiscreteValue.Value = CStr(pobjData(j, 1))
'                                crParameterValues.Add(crParameterDiscreteValue)
'                                crRep.SetParameterValue(lParaName, crParameterDiscreteValue.Value)
'                        End Select
'                    End If
'                Next
'            Next
'        End With

'        reportSys.ReportSource = crRep

'        Dim pdfStream As Stream = crRep.ExportToStream(ExportFormatType.PortableDocFormat)
'        Dim buffer(pdfStream.Length - 1) As Byte
'        pdfStream.Read(buffer, 0, buffer.Length)
'        pdfFiles.Add(buffer)

'        If crsubrep IsNot Nothing Then
'            crsubrep.Close() 'Added by Edi on 20260302
'            crsubrep.Dispose() 'Added by Edi on 20260302
'        End If

'        crRep.Close()
'        crRep.Dispose()

'        Dim serverPdfs() As String = {
'            Server.MapPath("~/lesen/report/extras/Portal_Rasmi_Larangan_Merokok.pdf"),
'            Server.MapPath("~/Uploads/file2.pdf")
'        }

'        For Each path In serverPdfs
'            If File.Exists(path) Then pdfFiles.Add(File.ReadAllBytes(path))
'        Next

'        Try
'            Using finalStream As New MemoryStream()
'                Dim doc As New Document()
'                Dim pdfCopy As New PdfCopy(doc, finalStream)
'                doc.Open()

'                For Each pdf As Byte() In pdfFiles
'                    Dim reader As New PdfReader(pdf)

'                    For k As Integer = 1 To reader.NumberOfPages
'                        pdfCopy.AddPage(pdfCopy.GetImportedPage(reader, k))
'                    Next

'                    pdfCopy.FreeReader(reader)
'                    reader.Close()
'                Next

'                doc.Close()

'                '' Return as download
'                Dim finalPDF As Byte() = finalStream.ToArray()

'                Response.Clear()
'                Response.ContentType = "application/pdf"
'                Response.OutputStream.Write(finalPDF, 0, finalPDF.Length)
'                Response.Flush()
'                Response.End()


'            End Using
'        Catch ex As Exception
'            'MsgBox(ex.Message)
'        End Try

'    End Sub

'    Protected Sub Page_Unload(sender As Object, e As EventArgs)
'        Try
'            'Added by Edi on 20260302
'            If crsubrep IsNot Nothing Then
'                crsubrep.Close()
'                crsubrep.Dispose()
'            End If

'            If crRep IsNot Nothing Then
'                crRep.Close()
'                crRep.Dispose()
'            End If

'            GC.Collect()
'            GC.WaitForPendingFinalizers()
'        Catch
'        End Try
'    End Sub



'End Class
