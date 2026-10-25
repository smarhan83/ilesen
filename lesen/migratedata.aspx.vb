Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Web.Services
Imports System.Web.Script.Serialization
Imports System.Text
Imports System.Text.RegularExpressions
Imports CrystalDecisions.CrystalReports.Engine
Imports CrystalDecisions.Shared

Partial Class lesen_migratedata
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Session("User_ID") Is Nothing Then
            ' Allow page load or redirect if session required; keep consistent with other lesen pages
            ' Response.Redirect("~/login.aspx")
        End If
    End Sub

#Region "Data Models for AJAX JSON Responses"

    Public Class SummaryResult
        Public Property Success As Boolean
        Public Property Message As String
        Public Property TotalPermohonan As Integer
        Public Property PendingFormatCount As Integer
        Public Property PendingJenisLesenListCount As Integer
        Public Property PendingIklanListCount As Integer
        Public Property PendingAnjingListCount As Integer
        Public Property PendingPembetulanCount As Integer
        Public Property PendingSPCount As Integer
        Public Property PendingSKCount As Integer
        Public Property PendingSBCount As Integer
        Public Property CompletedSPCount As Integer
        Public Property CompletedSKCount As Integer
        Public Property CompletedSBCount As Integer
    End Class

    Public Class QueueItem
        Public Property PermohonanID As Integer
        Public Property Rujukan As String
        Public Property JenisLesenID As Integer
        Public Property NeedFormat As Boolean
        Public Property NeedSP As Boolean
        Public Property NeedSK As Boolean
        Public Property NeedSB As Boolean
    End Class

    Public Class QueueResult
        Public Property Success As Boolean
        Public Property Message As String
        Public Property Items As List(Of QueueItem)
    End Class

    Public Class ActivityLogEntry
        Public Property Timestamp As String
        Public Property PermohonanID As Integer
        Public Property Rujukan As String
        Public Property Category As String
        Public Property Status As String ' "SUCCESS", "WARN", "ERROR", "INFO"
        Public Property Message As String
        Public Property FileUrl As String
    End Class

    Public Class ErrorLogEntry
        Public Property Timestamp As String
        Public Property PermohonanID As Integer
        Public Property Rujukan As String
        Public Property StepName As String
        Public Property ErrorMessage As String
    End Class

    Public Class BatchResult
        Public Property Success As Boolean
        Public Property Message As String
        Public Property ProcessedCount As Integer
        Public Property FormatUpdatedCount As Integer
        Public Property SPGeneratedCount As Integer
        Public Property SKGeneratedCount As Integer
        Public Property SBGeneratedCount As Integer
        Public Property ErrorCount As Integer
        Public Property Activities As List(Of ActivityLogEntry)
        Public Property Errors As List(Of ErrorLogEntry)
    End Class

#End Region

#Region "WebMethods for Real-Time Migration Progress"

    <WebMethod(EnableSession:=True)>
    Public Shared Function GetMigrationSummary() As SummaryResult
        Dim res As New SummaryResult()
        Try
            Dim connStr As String = ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString
            Using conn As New SqlConnection(connStr)
                conn.Open()

                Dim sql As String = "
                    ;WITH cte AS (
                        SELECT
                            CASE WHEN (ISNULL(LTRIM(RTRIM(a.JenisLesenIdList)), '') = '' AND ISNULL(a.JenisLesen_ID, 0) > 0)
                                   OR (LEN(LTRIM(RTRIM(ISNULL(a.SaizIklan, '')))) > 0 AND ISNULL(LTRIM(RTRIM(a.SaizIklanList)), '') = '')
                                   OR (ISNULL(LTRIM(RTRIM(CAST(a.AnjingBaka AS VARCHAR(50)))), '') NOT IN ('', '0') AND ISNULL(LTRIM(RTRIM(a.BakaAnjingList)), '') = '')
                                   OR (ISNULL(a.StatusID, 0) > 0 AND p.Permohonan_ID IS NULL)
                                   OR (p.Permohonan_ID IS NOT NULL AND LEN(LTRIM(RTRIM(ISNULL(p.SaizIklan, '')))) > 0 AND ISNULL(LTRIM(RTRIM(p.SaizIklanList)), '') = '')
                                   OR (p.Permohonan_ID IS NOT NULL AND ISNULL(LTRIM(RTRIM(CAST(p.AnjingBaka AS VARCHAR(50)))), '') NOT IN ('', '0') AND ISNULL(LTRIM(RTRIM(p.BakaAnjingList)), '') = '')
                            THEN 1 ELSE 0 END AS IsPendingFormat,
                            CASE WHEN ISNULL(LTRIM(RTRIM(a.JenisLesenIdList)), '') = '' AND ISNULL(a.JenisLesen_ID, 0) > 0 THEN 1 ELSE 0 END AS IsPendingJenisLesenList,
                            CASE WHEN (LEN(LTRIM(RTRIM(ISNULL(a.SaizIklan, '')))) > 0 AND ISNULL(LTRIM(RTRIM(a.SaizIklanList)), '') = '')
                                   OR (p.Permohonan_ID IS NOT NULL AND LEN(LTRIM(RTRIM(ISNULL(p.SaizIklan, '')))) > 0 AND ISNULL(LTRIM(RTRIM(p.SaizIklanList)), '') = '')
                            THEN 1 ELSE 0 END AS IsPendingIklanList,
                            CASE WHEN (ISNULL(LTRIM(RTRIM(CAST(a.AnjingBaka AS VARCHAR(50)))), '') NOT IN ('', '0') AND ISNULL(LTRIM(RTRIM(a.BakaAnjingList)), '') = '')
                                   OR (p.Permohonan_ID IS NOT NULL AND ISNULL(LTRIM(RTRIM(CAST(p.AnjingBaka AS VARCHAR(50)))), '') NOT IN ('', '0') AND ISNULL(LTRIM(RTRIM(p.BakaAnjingList)), '') = '')
                            THEN 1 ELSE 0 END AS IsPendingAnjingList,
                            CASE WHEN ISNULL(a.StatusID, 0) > 0 AND p.Permohonan_ID IS NULL THEN 1 ELSE 0 END AS IsPendingPembetulan,
                            CASE WHEN (LEN(LTRIM(RTRIM(ISNULL(CAST(a.SuratPemeriksaan1 AS NVARCHAR(MAX)), '')))) > 0
                                    OR LEN(LTRIM(RTRIM(ISNULL(CAST(a.SuratPemeriksaan2 AS NVARCHAR(MAX)), '')))) > 0)
                                  AND (ISNULL(a.IsSuratPemeriksaanFail, 0) = 0
                                    OR NOT EXISTS (SELECT 1 FROM LESEN_PermohonanFail pf WHERE pf.PermohonanFail_PermohonanID = a.Permohonan_ID AND pf.PermohonanFail_JenisLampiran = 'SP'))
                            THEN 1 ELSE 0 END AS IsPendingSP,
                            CASE WHEN (LEN(LTRIM(RTRIM(ISNULL(CAST(a.SuratKelulusan1 AS NVARCHAR(MAX)), '')))) > 0
                                    OR LEN(LTRIM(RTRIM(ISNULL(CAST(a.SuratKelulusan2 AS NVARCHAR(MAX)), '')))) > 0
                                    OR LEN(LTRIM(RTRIM(ISNULL(CAST(a.SuratKelulusan3 AS NVARCHAR(MAX)), '')))) > 0
                                    OR LEN(LTRIM(RTRIM(ISNULL(CAST(a.SuratKelulusan4 AS NVARCHAR(MAX)), '')))) > 0)
                                  AND (ISNULL(a.IsSuratKelulusanFail, 0) = 0
                                    OR NOT EXISTS (SELECT 1 FROM LESEN_PermohonanFail pf WHERE pf.PermohonanFail_PermohonanID = a.Permohonan_ID AND pf.PermohonanFail_JenisLampiran = 'SK'))
                            THEN 1 ELSE 0 END AS IsPendingSK,
                            CASE WHEN (LEN(LTRIM(RTRIM(ISNULL(CAST(a.SuratPembatalan1 AS NVARCHAR(MAX)), '')))) > 0
                                    OR LEN(LTRIM(RTRIM(ISNULL(CAST(a.SuratPembatalan2 AS NVARCHAR(MAX)), '')))) > 0)
                                  AND (ISNULL(a.IsSuratPembatalanFail, 0) = 0
                                    OR NOT EXISTS (SELECT 1 FROM LESEN_PermohonanFail pf WHERE pf.PermohonanFail_PermohonanID = a.Permohonan_ID AND pf.PermohonanFail_JenisLampiran = 'SB'))
                            THEN 1 ELSE 0 END AS IsPendingSB,
                            CASE WHEN ISNULL(a.IsSuratPemeriksaanFail, 0) = 1 THEN 1 ELSE 0 END AS IsCompletedSP,
                            CASE WHEN ISNULL(a.IsSuratKelulusanFail, 0) = 1 THEN 1 ELSE 0 END AS IsCompletedSK,
                            CASE WHEN ISNULL(a.IsSuratPembatalanFail, 0) = 1 THEN 1 ELSE 0 END AS IsCompletedSB
                        FROM LESEN_Permohonan a
                        LEFT JOIN LESEN_PermohonanPembetulan p ON a.Permohonan_ID = p.Permohonan_ID
                    )
                    SELECT
                        COUNT(1) AS TotalPermohonan,
                        ISNULL(SUM(IsPendingFormat), 0) AS PendingFormatCount,
                        ISNULL(SUM(IsPendingJenisLesenList), 0) AS PendingJenisLesenListCount,
                        ISNULL(SUM(IsPendingIklanList), 0) AS PendingIklanListCount,
                        ISNULL(SUM(IsPendingAnjingList), 0) AS PendingAnjingListCount,
                        ISNULL(SUM(IsPendingPembetulan), 0) AS PendingPembetulanCount,
                        ISNULL(SUM(IsPendingSP), 0) AS PendingSPCount,
                        ISNULL(SUM(IsPendingSK), 0) AS PendingSKCount,
                        ISNULL(SUM(IsPendingSB), 0) AS PendingSBCount,
                        ISNULL(SUM(IsCompletedSP), 0) AS CompletedSPCount,
                        ISNULL(SUM(IsCompletedSK), 0) AS CompletedSKCount,
                        ISNULL(SUM(IsCompletedSB), 0) AS CompletedSBCount
                    FROM cte"

                Using cmd As New SqlCommand(sql, conn)
                    cmd.CommandTimeout = 120
                    Using rdr As SqlDataReader = cmd.ExecuteReader()
                        If rdr.Read() Then
                            res.TotalPermohonan = If(IsDBNull(rdr("TotalPermohonan")), 0, Convert.ToInt32(rdr("TotalPermohonan")))
                            res.PendingFormatCount = If(IsDBNull(rdr("PendingFormatCount")), 0, Convert.ToInt32(rdr("PendingFormatCount")))
                            res.PendingJenisLesenListCount = If(IsDBNull(rdr("PendingJenisLesenListCount")), 0, Convert.ToInt32(rdr("PendingJenisLesenListCount")))
                            res.PendingIklanListCount = If(IsDBNull(rdr("PendingIklanListCount")), 0, Convert.ToInt32(rdr("PendingIklanListCount")))
                            res.PendingAnjingListCount = If(IsDBNull(rdr("PendingAnjingListCount")), 0, Convert.ToInt32(rdr("PendingAnjingListCount")))
                            res.PendingPembetulanCount = If(IsDBNull(rdr("PendingPembetulanCount")), 0, Convert.ToInt32(rdr("PendingPembetulanCount")))
                            res.PendingSPCount = If(IsDBNull(rdr("PendingSPCount")), 0, Convert.ToInt32(rdr("PendingSPCount")))
                            res.PendingSKCount = If(IsDBNull(rdr("PendingSKCount")), 0, Convert.ToInt32(rdr("PendingSKCount")))
                            res.PendingSBCount = If(IsDBNull(rdr("PendingSBCount")), 0, Convert.ToInt32(rdr("PendingSBCount")))
                            res.CompletedSPCount = If(IsDBNull(rdr("CompletedSPCount")), 0, Convert.ToInt32(rdr("CompletedSPCount")))
                            res.CompletedSKCount = If(IsDBNull(rdr("CompletedSKCount")), 0, Convert.ToInt32(rdr("CompletedSKCount")))
                            res.CompletedSBCount = If(IsDBNull(rdr("CompletedSBCount")), 0, Convert.ToInt32(rdr("CompletedSBCount")))
                        End If
                    End Using
                End Using
            End Using

            res.Success = True
            res.Message = "Berjaya mendapatkan ringkasan status data."
        Catch ex As Exception
            res.Success = False
            res.Message = "Ralat semasa menyemak status data: " & ex.Message
        End Try
        Return res
    End Function

    <WebMethod(EnableSession:=True)>
    Public Shared Function GetPendingQueue(ByVal includeFormat As Boolean, ByVal includeSP As Boolean, ByVal includeSK As Boolean, ByVal includeSB As Boolean, ByVal forceRegeneratePdf As Boolean) As QueueResult
        Dim res As New QueueResult()
        res.Items = New List(Of QueueItem)()

        Try
            Dim connStr As String = ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString
            Using conn As New SqlConnection(connStr)
                conn.Open()

                Dim sql As String = "
                    SELECT
                        a.Permohonan_ID,
                        ISNULL(a.Rujukan, '-') AS Rujukan,
                        ISNULL(a.JenisLesen_ID, 0) AS JenisLesen_ID,
                        CASE WHEN (ISNULL(LTRIM(RTRIM(a.JenisLesenIdList)), '') = '' AND ISNULL(a.JenisLesen_ID, 0) > 0)
                               OR (LEN(LTRIM(RTRIM(ISNULL(a.SaizIklan, '')))) > 0 AND ISNULL(LTRIM(RTRIM(a.SaizIklanList)), '') = '')
                               OR (ISNULL(LTRIM(RTRIM(CAST(a.AnjingBaka AS VARCHAR(50)))), '') NOT IN ('', '0') AND ISNULL(LTRIM(RTRIM(a.BakaAnjingList)), '') = '')
                               OR (ISNULL(a.StatusID, 0) > 0 AND p.Permohonan_ID IS NULL)
                               OR (p.Permohonan_ID IS NOT NULL AND LEN(LTRIM(RTRIM(ISNULL(p.SaizIklan, '')))) > 0 AND ISNULL(LTRIM(RTRIM(p.SaizIklanList)), '') = '')
                               OR (p.Permohonan_ID IS NOT NULL AND ISNULL(LTRIM(RTRIM(CAST(p.AnjingBaka AS VARCHAR(50)))), '') NOT IN ('', '0') AND ISNULL(LTRIM(RTRIM(p.BakaAnjingList)), '') = '')
                        THEN 1 ELSE 0 END AS NeedFormat,
                        CASE WHEN (LEN(LTRIM(RTRIM(ISNULL(CAST(a.SuratPemeriksaan1 AS NVARCHAR(MAX)), '')))) > 0
                                OR LEN(LTRIM(RTRIM(ISNULL(CAST(a.SuratPemeriksaan2 AS NVARCHAR(MAX)), '')))) > 0)
                              AND (@ForcePdf = 1
                                OR ISNULL(a.IsSuratPemeriksaanFail, 0) = 0
                                OR NOT EXISTS (SELECT 1 FROM LESEN_PermohonanFail pf WHERE pf.PermohonanFail_PermohonanID = a.Permohonan_ID AND pf.PermohonanFail_JenisLampiran = 'SP'))
                        THEN 1 ELSE 0 END AS NeedSP,
                        CASE WHEN (LEN(LTRIM(RTRIM(ISNULL(CAST(a.SuratKelulusan1 AS NVARCHAR(MAX)), '')))) > 0
                                OR LEN(LTRIM(RTRIM(ISNULL(CAST(a.SuratKelulusan2 AS NVARCHAR(MAX)), '')))) > 0
                                OR LEN(LTRIM(RTRIM(ISNULL(CAST(a.SuratKelulusan3 AS NVARCHAR(MAX)), '')))) > 0
                                OR LEN(LTRIM(RTRIM(ISNULL(CAST(a.SuratKelulusan4 AS NVARCHAR(MAX)), '')))) > 0)
                              AND (@ForcePdf = 1
                                OR ISNULL(a.IsSuratKelulusanFail, 0) = 0
                                OR NOT EXISTS (SELECT 1 FROM LESEN_PermohonanFail pf WHERE pf.PermohonanFail_PermohonanID = a.Permohonan_ID AND pf.PermohonanFail_JenisLampiran = 'SK'))
                        THEN 1 ELSE 0 END AS NeedSK,
                        CASE WHEN (LEN(LTRIM(RTRIM(ISNULL(CAST(a.SuratPembatalan1 AS NVARCHAR(MAX)), '')))) > 0
                                OR LEN(LTRIM(RTRIM(ISNULL(CAST(a.SuratPembatalan2 AS NVARCHAR(MAX)), '')))) > 0)
                              AND (@ForcePdf = 1
                                OR ISNULL(a.IsSuratPembatalanFail, 0) = 0
                                OR NOT EXISTS (SELECT 1 FROM LESEN_PermohonanFail pf WHERE pf.PermohonanFail_PermohonanID = a.Permohonan_ID AND pf.PermohonanFail_JenisLampiran = 'SB'))
                        THEN 1 ELSE 0 END AS NeedSB
                    FROM LESEN_Permohonan a
                    LEFT JOIN LESEN_PermohonanPembetulan p ON a.Permohonan_ID = p.Permohonan_ID
                    ORDER BY a.Permohonan_ID ASC"

                Using cmd As New SqlCommand(sql, conn)
                    cmd.CommandTimeout = 120
                    cmd.Parameters.AddWithValue("@ForcePdf", If(forceRegeneratePdf, 1, 0))
                    Using rdr As SqlDataReader = cmd.ExecuteReader()
                        While rdr.Read()
                            Dim needFmt As Boolean = (Convert.ToInt32(rdr("NeedFormat")) = 1) AndAlso includeFormat
                            Dim needSp As Boolean = (Convert.ToInt32(rdr("NeedSP")) = 1) AndAlso includeSP
                            Dim needSk As Boolean = (Convert.ToInt32(rdr("NeedSK")) = 1) AndAlso includeSK
                            Dim needSb As Boolean = (Convert.ToInt32(rdr("NeedSB")) = 1) AndAlso includeSB

                            If needFmt OrElse needSp OrElse needSk OrElse needSb Then
                                Dim item As New QueueItem()
                                item.PermohonanID = Convert.ToInt32(rdr("Permohonan_ID"))
                                item.Rujukan = Convert.ToString(rdr("Rujukan"))
                                item.JenisLesenID = Convert.ToInt32(rdr("JenisLesen_ID"))
                                item.NeedFormat = needFmt
                                item.NeedSP = needSp
                                item.NeedSK = needSk
                                item.NeedSB = needSb
                                res.Items.Add(item)
                            End If
                        End While
                    End Using
                End Using
            End Using

            res.Success = True
            res.Message = "Senarai rekod untuk dikemaskini berjaya dimuatkan (" & res.Items.Count & " rekod)."
        Catch ex As Exception
            res.Success = False
            res.Message = "Gagal mendapatkan senarai rekod: " & ex.Message
        End Try

        Return res
    End Function

    <WebMethod(EnableSession:=True)>
    Public Shared Function ProcessMigrationBatch(ByVal items As List(Of QueueItem), ByVal forceRegeneratePdf As Boolean) As BatchResult
        Dim res As New BatchResult()
        res.Activities = New List(Of ActivityLogEntry)()
        res.Errors = New List(Of ErrorLogEntry)()

        If items Is Nothing OrElse items.Count = 0 Then
            res.Success = True
            res.Message = "Tiada rekod dalam kelompok ini."
            Return res
        End If

        Try
            Dim connStr As String = ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString
            Dim docFolderPhysical As String = HttpContext.Current.Server.MapPath("~/doc/")
            If Not Directory.Exists(docFolderPhysical) Then
                Directory.CreateDirectory(docFolderPhysical)
            End If

            Using conn As New SqlConnection(connStr)
                conn.Open()

                For Each item As QueueItem In items
                    Dim pid As Integer = item.PermohonanID
                    Dim rujukan As String = If(String.IsNullOrEmpty(item.Rujukan), "-", item.Rujukan)
                    Dim jenisLesenID As Integer = item.JenisLesenID

                    ' 1. Update SQL Data Format (LESEN_Permohonan & LESEN_PermohonanPembetulan)
                    If item.NeedFormat Then
                        Try
                            UpdateRecordDataFormat(conn, pid)
                            res.FormatUpdatedCount += 1
                            res.Activities.Add(New ActivityLogEntry With {
                                .Timestamp = DateTime.Now.ToString("HH:mm:ss"),
                                .PermohonanID = pid,
                                .Rujukan = rujukan,
                                .Category = "Format Data SQL",
                                .Status = "SUCCESS",
                                .Message = "Berjaya kemaskini format jadual baharu (JenisLesenIdList / IklanList / AnjingList / Pembetulan).",
                                .FileUrl = ""
                            })
                        Catch exFmt As Exception
                            res.ErrorCount += 1
                            res.Errors.Add(New ErrorLogEntry With {
                                .Timestamp = DateTime.Now.ToString("HH:mm:ss"),
                                .PermohonanID = pid,
                                .Rujukan = rujukan,
                                .StepName = "Kemaskini Format Data SQL",
                                .ErrorMessage = exFmt.Message
                            })
                            res.Activities.Add(New ActivityLogEntry With {
                                .Timestamp = DateTime.Now.ToString("HH:mm:ss"),
                                .PermohonanID = pid,
                                .Rujukan = rujukan,
                                .Category = "Format Data SQL",
                                .Status = "ERROR",
                                .Message = "Ralat: " & exFmt.Message,
                                .FileUrl = ""
                            })
                        End Try
                    End If

                    ' 2. Generate PDF for Laporan / Surat Pemeriksaan (SP)
                    If item.NeedSP Then
                        Try
                            Dim spUrl As String = GenerateAndSaveSuratPemeriksaanPdf(conn, pid, jenisLesenID, rujukan, docFolderPhysical, forceRegeneratePdf)
                            If Not String.IsNullOrEmpty(spUrl) Then
                                res.SPGeneratedCount += 1
                                res.Activities.Add(New ActivityLogEntry With {
                                    .Timestamp = DateTime.Now.ToString("HH:mm:ss"),
                                    .PermohonanID = pid,
                                    .Rujukan = rujukan,
                                    .Category = "PDF Laporan Pemeriksaan (SP)",
                                    .Status = "SUCCESS",
                                    .Message = "Berjaya simpan PDF Laporan Pemeriksaan & kemaskini IsSuratPemeriksaanFail = 1.",
                                    .FileUrl = spUrl
                                })
                            End If
                        Catch exSp As Exception
                            res.ErrorCount += 1
                            res.Errors.Add(New ErrorLogEntry With {
                                .Timestamp = DateTime.Now.ToString("HH:mm:ss"),
                                .PermohonanID = pid,
                                .Rujukan = rujukan,
                                .StepName = "Jana PDF Laporan Pemeriksaan (SP)",
                                .ErrorMessage = exSp.Message
                            })
                            res.Activities.Add(New ActivityLogEntry With {
                                .Timestamp = DateTime.Now.ToString("HH:mm:ss"),
                                .PermohonanID = pid,
                                .Rujukan = rujukan,
                                .Category = "PDF Laporan Pemeriksaan (SP)",
                                .Status = "ERROR",
                                .Message = "Ralat: " & exSp.Message,
                                .FileUrl = ""
                            })
                        End Try
                    End If

                    ' 3. Generate PDF for Surat Kelulusan (SK)
                    If item.NeedSK Then
                        Try
                            Dim skUrl As String = GenerateAndSaveSuratKelulusanPdf(conn, pid, jenisLesenID, rujukan, docFolderPhysical, forceRegeneratePdf)
                            If Not String.IsNullOrEmpty(skUrl) Then
                                res.SKGeneratedCount += 1
                                res.Activities.Add(New ActivityLogEntry With {
                                    .Timestamp = DateTime.Now.ToString("HH:mm:ss"),
                                    .PermohonanID = pid,
                                    .Rujukan = rujukan,
                                    .Category = "PDF Surat Kelulusan (SK)",
                                    .Status = "SUCCESS",
                                    .Message = "Berjaya simpan PDF Surat Kelulusan & kemaskini IsSuratKelulusanFail = 1.",
                                    .FileUrl = skUrl
                                })
                            End If
                        Catch exSk As Exception
                            res.ErrorCount += 1
                            res.Errors.Add(New ErrorLogEntry With {
                                .Timestamp = DateTime.Now.ToString("HH:mm:ss"),
                                .PermohonanID = pid,
                                .Rujukan = rujukan,
                                .StepName = "Jana PDF Surat Kelulusan (SK)",
                                .ErrorMessage = exSk.Message
                            })
                            res.Activities.Add(New ActivityLogEntry With {
                                .Timestamp = DateTime.Now.ToString("HH:mm:ss"),
                                .PermohonanID = pid,
                                .Rujukan = rujukan,
                                .Category = "PDF Surat Kelulusan (SK)",
                                .Status = "ERROR",
                                .Message = "Ralat: " & exSk.Message,
                                .FileUrl = ""
                            })
                        End Try
                    End If

                    ' 4. Generate PDF for Surat Pembatalan (SB)
                    If item.NeedSB Then
                        Try
                            Dim sbUrl As String = GenerateAndSaveSuratPembatalanPdf(conn, pid, jenisLesenID, rujukan, docFolderPhysical, forceRegeneratePdf)
                            If Not String.IsNullOrEmpty(sbUrl) Then
                                res.SBGeneratedCount += 1
                                res.Activities.Add(New ActivityLogEntry With {
                                    .Timestamp = DateTime.Now.ToString("HH:mm:ss"),
                                    .PermohonanID = pid,
                                    .Rujukan = rujukan,
                                    .Category = "PDF Surat Pembatalan (SB)",
                                    .Status = "SUCCESS",
                                    .Message = "Berjaya simpan PDF Surat Pembatalan & kemaskini IsSuratPembatalanFail = 1.",
                                    .FileUrl = sbUrl
                                })
                            End If
                        Catch exSb As Exception
                            res.ErrorCount += 1
                            res.Errors.Add(New ErrorLogEntry With {
                                .Timestamp = DateTime.Now.ToString("HH:mm:ss"),
                                .PermohonanID = pid,
                                .Rujukan = rujukan,
                                .StepName = "Jana PDF Surat Pembatalan (SB)",
                                .ErrorMessage = exSb.Message
                            })
                            res.Activities.Add(New ActivityLogEntry With {
                                .Timestamp = DateTime.Now.ToString("HH:mm:ss"),
                                .PermohonanID = pid,
                                .Rujukan = rujukan,
                                .Category = "PDF Surat Pembatalan (SB)",
                                .Status = "ERROR",
                                .Message = "Ralat: " & exSb.Message,
                                .FileUrl = ""
                            })
                        End Try
                    End If

                    res.ProcessedCount += 1
                Next
            End Using

            ' Periodically collect garbage to release Crystal Reports unmanaged COM handles
            GC.Collect()
            GC.WaitForPendingFinalizers()

            res.Success = True
            res.Message = "Kelompok selesai diproses."
        Catch ex As Exception
            res.Success = False
            res.Message = "Ralat kelompok: " & ex.Message
        End Try

        Return res
    End Function

#End Region

#Region "SQL Data Format Migration Logic"

    Private Shared Sub UpdateRecordDataFormat(ByVal conn As SqlConnection, ByVal permohonanID As Integer)
        ' 1. Update LESEN_Permohonan:
        '    - JenisLesenIdList & JenisLesenDescList from JenisLesen_ID & LESEN_JenisLesen
        '      For combined legacy JenisLesen_ID (19, 20, 23, 24, 26), keep the primary JenisLesen_ID first
        '      so LESEN_ReportTemplate lookups still match, and also populate JenisLesenDescList.
        '    - SaizIklanList, CahayaIklanList, UnitIklanList from SaizIklan, IklanBercahaya, UnitIklan
        '    - BakaAnjingList, AnjingJantanList, AnjingBetinaList, AnjingJantanMandulList, AnjingBetinaMandulList
        '    - Default boolean flags (IsRekodLama, IsSuratPemeriksaanFail, IsSuratKelulusanFail, IsSuratPembatalanFail, IsBatal, Is24jam, IsPulang)
        Dim sqlUpdatePermohonan As String = "
            UPDATE a
            SET
                a.JenisLesenIdList = CASE
                    WHEN ISNULL(LTRIM(RTRIM(a.JenisLesenIdList)), '') = '' AND ISNULL(a.JenisLesen_ID, 0) > 0
                    THEN CAST(a.JenisLesen_ID AS VARCHAR(50))
                    ELSE a.JenisLesenIdList
                END,
                a.JenisLesenDescList = CASE
                    WHEN ISNULL(LTRIM(RTRIM(a.JenisLesenDescList)), '') = '' AND ISNULL(a.JenisLesen_ID, 0) > 0
                    THEN ISNULL(jl.JenisLesen_Description, CAST(a.JenisLesen_ID AS VARCHAR(50)))
                    ELSE a.JenisLesenDescList
                END,
                a.SaizIklanList = CASE
                    WHEN ISNULL(LTRIM(RTRIM(a.SaizIklanList)), '') = '' AND LEN(LTRIM(RTRIM(ISNULL(a.SaizIklan, '')))) > 0
                    THEN REPLACE(LTRIM(RTRIM(a.SaizIklan)), ',', ';')
                    ELSE a.SaizIklanList
                END,
                a.CahayaIklanList = CASE
                    WHEN ISNULL(LTRIM(RTRIM(a.CahayaIklanList)), '') = '' AND LEN(LTRIM(RTRIM(ISNULL(a.SaizIklan, '')))) > 0
                    THEN CASE
                        WHEN LTRIM(RTRIM(ISNULL(CAST(a.IklanBercahaya AS VARCHAR(50)), ''))) IN ('2', '0', 'Tidak', 'TIDAK', 'Tidak Bercahaya') THEN 'Tidak Bercahaya'
                        ELSE 'Bercahaya'
                    END
                    ELSE a.CahayaIklanList
                END,
                a.UnitIklanList = CASE
                    WHEN ISNULL(LTRIM(RTRIM(a.UnitIklanList)), '') = '' AND LEN(LTRIM(RTRIM(ISNULL(a.SaizIklan, '')))) > 0
                    THEN CASE
                        WHEN ISNULL(LTRIM(RTRIM(CAST(a.UnitIklan AS VARCHAR(50)))), '') IN ('', '0') THEN '1'
                        ELSE LTRIM(RTRIM(CAST(a.UnitIklan AS VARCHAR(50))))
                    END
                    ELSE a.UnitIklanList
                END,
                a.BakaAnjingList = CASE
                    WHEN ISNULL(LTRIM(RTRIM(a.BakaAnjingList)), '') = '' AND ISNULL(LTRIM(RTRIM(CAST(a.AnjingBaka AS VARCHAR(50)))), '') NOT IN ('', '0')
                    THEN ISNULL(lk.name, LTRIM(RTRIM(CAST(a.AnjingBaka AS VARCHAR(50)))))
                    ELSE a.BakaAnjingList
                END,
                a.AnjingJantanList = CASE
                    WHEN ISNULL(LTRIM(RTRIM(a.AnjingJantanList)), '') = '' AND ISNULL(LTRIM(RTRIM(CAST(a.AnjingBaka AS VARCHAR(50)))), '') NOT IN ('', '0')
                    THEN ISNULL(NULLIF(LTRIM(RTRIM(CAST(a.AnjingJantan AS VARCHAR(50)))), ''), '0')
                    ELSE a.AnjingJantanList
                END,
                a.AnjingBetinaList = CASE
                    WHEN ISNULL(LTRIM(RTRIM(a.AnjingBetinaList)), '') = '' AND ISNULL(LTRIM(RTRIM(CAST(a.AnjingBaka AS VARCHAR(50)))), '') NOT IN ('', '0')
                    THEN ISNULL(NULLIF(LTRIM(RTRIM(CAST(a.AnjingBetina AS VARCHAR(50)))), ''), '0')
                    ELSE a.AnjingBetinaList
                END,
                a.AnjingJantanMandulList = CASE
                    WHEN ISNULL(LTRIM(RTRIM(a.AnjingJantanMandulList)), '') = '' AND ISNULL(LTRIM(RTRIM(CAST(a.AnjingBaka AS VARCHAR(50)))), '') NOT IN ('', '0')
                    THEN ISNULL(NULLIF(LTRIM(RTRIM(CAST(a.AnjingJantanMandul AS VARCHAR(50)))), ''), '0')
                    ELSE a.AnjingJantanMandulList
                END,
                a.AnjingBetinaMandulList = CASE
                    WHEN ISNULL(LTRIM(RTRIM(a.AnjingBetinaMandulList)), '') = '' AND ISNULL(LTRIM(RTRIM(CAST(a.AnjingBaka AS VARCHAR(50)))), '') NOT IN ('', '0')
                    THEN ISNULL(NULLIF(LTRIM(RTRIM(CAST(a.AnjingBetinaMandul AS VARCHAR(50)))), ''), '0')
                    ELSE a.AnjingBetinaMandulList
                END,
                a.IsRekodLama = ISNULL(a.IsRekodLama, 0),
                a.IsSuratPemeriksaanFail = ISNULL(a.IsSuratPemeriksaanFail, 0),
                a.IsSuratKelulusanFail = ISNULL(a.IsSuratKelulusanFail, 0),
                a.IsSuratPembatalanFail = ISNULL(a.IsSuratPembatalanFail, 0),
                a.IsBatal = ISNULL(a.IsBatal, 0),
                a.Is24jam = ISNULL(a.Is24jam, 0),
                a.IsPulang = ISNULL(a.IsPulang, 0)
            FROM LESEN_Permohonan a
            LEFT JOIN LESEN_JenisLesen jl ON a.JenisLesen_ID = jl.JenisLesen_ID
            LEFT JOIN TBL_LOOKUPS lk ON lk.lookupgrp_id = 10004 AND CAST(lk.id AS VARCHAR(50)) = LTRIM(RTRIM(CAST(a.AnjingBaka AS VARCHAR(50))))
            WHERE a.Permohonan_ID = @PermohonanID"

        Using cmd As New SqlCommand(sqlUpdatePermohonan, conn)
            cmd.Parameters.AddWithValue("@PermohonanID", permohonanID)
            cmd.ExecuteNonQuery()
        End Using

        ' 2. Ensure LESEN_PermohonanPembetulan exists for submitted records (StatusID > 0)
        '    using the exact columns of LESEN_PermohonanPembetulan & LESEN_Permohonan (matching appregister1.aspx.vb insertMaklumatPembetulan)
        Dim sqlInsertMissingPembetulan As String = "
            IF NOT EXISTS (SELECT 1 FROM LESEN_PermohonanPembetulan WHERE Permohonan_ID = @PermohonanID)
            BEGIN
                INSERT INTO LESEN_PermohonanPembetulan (
                    Permohonan_ID, JenisLesen_ID, SaizIklan, IklanBercahaya, UnitIklan,
                    AnjingBaka, AnjingJantan, AnjingBetina, AnjingJantanMandul, AnjingBetinaMandul,
                    SaizIklanList, CahayaIklanList, UnitIklanList, LokasiList,
                    BakaAnjingList, AnjingJantanList, AnjingBetinaList, AnjingJantanMandulList, AnjingBetinaMandulList,
                    NamaSyarikat, NoPendaftaran, NoAkaun, AlamatPremis, JenisPerniagaan,
                    PemilikBaru, AlamatBaru, JenisPerniagaanBaru, NamaBaruSyarikat, BillboardLokasi, LokasiPasar1, LokasiPasar2, LokasiPasar3, JenisPasar,
                    JenisPerniagaanPasar, JumlahPetak, AnjingAlamat, AnjingJenisPremis, JenisPenjaja, StatusTanahPenjaja, AlamatPenjajaan, JenisPerniagaanPenjaja, MasaPenjaja1, MasaPenjaja2,
                    JenisKenderaanPenjaja, NoKenderaanPenjaja, TarikhBatal, PenganjurEkspo, AlamatPenganjurEkspo, PicEkspo, NoTelEkspo, NamaEkspo, LokasiEkspo, TarikhEkspo1, TarikhEkspo2,
                    MasaEkspo1, MasaEkspo2, TentatifEkspo, JemputanEkspo, PembersihanEkspo, TarikhKhemahEkspo1, TarikhKhemahEkspo2,
                    KontraktorIklan, NoTelKontraktor, UkuranBanting, BilBanting, TarikhBanting1, TarikhBanting2, NoResitBanting, NoSiriStiker, TarikhBanting3,
                    CreatorID, CreatedDt, LastModID, LastModDt
                )
                SELECT
                    Permohonan_ID, JenisLesen_ID, SaizIklan, IklanBercahaya, UnitIklan,
                    AnjingBaka, AnjingJantan, AnjingBetina, AnjingJantanMandul, AnjingBetinaMandul,
                    SaizIklanList, CahayaIklanList, UnitIklanList, LokasiList,
                    BakaAnjingList, AnjingJantanList, AnjingBetinaList, AnjingJantanMandulList, AnjingBetinaMandulList,
                    NamaSyarikat, NoPendaftaran, NoAkaun, AlamatPremis, JenisPerniagaan,
                    PemilikBaru, AlamatBaru, JenisPerniagaanBaru, NamaBaruSyarikat, BillboardLokasi, LokasiPasar1, LokasiPasar2, LokasiPasar3, JenisPasar,
                    JenisPerniagaanPasar, JumlahPetak, AnjingAlamat, AnjingJenisPremis, JenisPenjaja, StatusTanahPenjaja, AlamatPenjajaan, JenisPerniagaanPenjaja, MasaPenjaja1, MasaPenjaja2,
                    JenisKenderaanPenjaja, NoKenderaanPenjaja, TarikhBatal, PenganjurEkspo, AlamatPenganjurEkspo, PicEkspo, NoTelEkspo, NamaEkspo, LokasiEkspo, TarikhEkspo1, TarikhEkspo2,
                    MasaEkspo1, MasaEkspo2, TentatifEkspo, JemputanEkspo, PembersihanEkspo, TarikhKhemahEkspo1, TarikhKhemahEkspo2,
                    KontraktorIklan, NoTelKontraktor, UkuranBanting, BilBanting, TarikhBanting1, TarikhBanting2, NoResitBanting, NoSiriStiker, TarikhBanting3,
                    CreatorID, CreatedDt, LastModID, LastModDt
                FROM LESEN_Permohonan
                WHERE Permohonan_ID = @PermohonanID AND ISNULL(StatusID, 0) > 0
            END"

        Using cmd As New SqlCommand(sqlInsertMissingPembetulan, conn)
            cmd.Parameters.AddWithValue("@PermohonanID", permohonanID)
            cmd.ExecuteNonQuery()
        End Using

        ' 3. Update existing LESEN_PermohonanPembetulan rows so their *List columns match
        Dim sqlUpdatePembetulan As String = "
            UPDATE p
            SET
                p.SaizIklanList = CASE
                    WHEN ISNULL(LTRIM(RTRIM(p.SaizIklanList)), '') = '' AND LEN(LTRIM(RTRIM(ISNULL(p.SaizIklan, '')))) > 0
                    THEN REPLACE(LTRIM(RTRIM(p.SaizIklan)), ',', ';')
                    WHEN ISNULL(LTRIM(RTRIM(p.SaizIklanList)), '') = '' AND LEN(LTRIM(RTRIM(ISNULL(a.SaizIklanList, '')))) > 0
                    THEN a.SaizIklanList
                    ELSE p.SaizIklanList
                END,
                p.CahayaIklanList = CASE
                    WHEN ISNULL(LTRIM(RTRIM(p.CahayaIklanList)), '') = '' AND LEN(LTRIM(RTRIM(ISNULL(p.SaizIklan, '')))) > 0
                    THEN CASE
                        WHEN LTRIM(RTRIM(ISNULL(CAST(p.IklanBercahaya AS VARCHAR(50)), ''))) IN ('2', '0', 'Tidak', 'TIDAK', 'Tidak Bercahaya') THEN 'Tidak Bercahaya'
                        ELSE 'Bercahaya'
                    END
                    WHEN ISNULL(LTRIM(RTRIM(p.CahayaIklanList)), '') = '' AND LEN(LTRIM(RTRIM(ISNULL(a.CahayaIklanList, '')))) > 0
                    THEN a.CahayaIklanList
                    ELSE p.CahayaIklanList
                END,
                p.UnitIklanList = CASE
                    WHEN ISNULL(LTRIM(RTRIM(p.UnitIklanList)), '') = '' AND LEN(LTRIM(RTRIM(ISNULL(p.SaizIklan, '')))) > 0
                    THEN CASE
                        WHEN ISNULL(LTRIM(RTRIM(CAST(p.UnitIklan AS VARCHAR(50)))), '') IN ('', '0') THEN '1'
                        ELSE LTRIM(RTRIM(CAST(p.UnitIklan AS VARCHAR(50))))
                    END
                    WHEN ISNULL(LTRIM(RTRIM(p.UnitIklanList)), '') = '' AND LEN(LTRIM(RTRIM(ISNULL(a.UnitIklanList, '')))) > 0
                    THEN a.UnitIklanList
                    ELSE p.UnitIklanList
                END,
                p.BakaAnjingList = CASE
                    WHEN ISNULL(LTRIM(RTRIM(p.BakaAnjingList)), '') = '' AND ISNULL(LTRIM(RTRIM(CAST(p.AnjingBaka AS VARCHAR(50)))), '') NOT IN ('', '0')
                    THEN ISNULL(lk.name, LTRIM(RTRIM(CAST(p.AnjingBaka AS VARCHAR(50)))))
                    WHEN ISNULL(LTRIM(RTRIM(p.BakaAnjingList)), '') = '' AND LEN(LTRIM(RTRIM(ISNULL(a.BakaAnjingList, '')))) > 0
                    THEN a.BakaAnjingList
                    ELSE p.BakaAnjingList
                END,
                p.AnjingJantanList = CASE
                    WHEN ISNULL(LTRIM(RTRIM(p.AnjingJantanList)), '') = '' AND ISNULL(LTRIM(RTRIM(CAST(p.AnjingBaka AS VARCHAR(50)))), '') NOT IN ('', '0')
                    THEN ISNULL(NULLIF(LTRIM(RTRIM(CAST(p.AnjingJantan AS VARCHAR(50)))), ''), '0')
                    WHEN ISNULL(LTRIM(RTRIM(p.AnjingJantanList)), '') = '' AND LEN(LTRIM(RTRIM(ISNULL(a.AnjingJantanList, '')))) > 0
                    THEN a.AnjingJantanList
                    ELSE p.AnjingJantanList
                END,
                p.AnjingBetinaList = CASE
                    WHEN ISNULL(LTRIM(RTRIM(p.AnjingBetinaList)), '') = '' AND ISNULL(LTRIM(RTRIM(CAST(p.AnjingBaka AS VARCHAR(50)))), '') NOT IN ('', '0')
                    THEN ISNULL(NULLIF(LTRIM(RTRIM(CAST(p.AnjingBetina AS VARCHAR(50)))), ''), '0')
                    WHEN ISNULL(LTRIM(RTRIM(p.AnjingBetinaList)), '') = '' AND LEN(LTRIM(RTRIM(ISNULL(a.AnjingBetinaList, '')))) > 0
                    THEN a.AnjingBetinaList
                    ELSE p.AnjingBetinaList
                END,
                p.AnjingJantanMandulList = CASE
                    WHEN ISNULL(LTRIM(RTRIM(p.AnjingJantanMandulList)), '') = '' AND ISNULL(LTRIM(RTRIM(CAST(p.AnjingBaka AS VARCHAR(50)))), '') NOT IN ('', '0')
                    THEN ISNULL(NULLIF(LTRIM(RTRIM(CAST(p.AnjingJantanMandul AS VARCHAR(50)))), ''), '0')
                    WHEN ISNULL(LTRIM(RTRIM(p.AnjingJantanMandulList)), '') = '' AND LEN(LTRIM(RTRIM(ISNULL(a.AnjingJantanMandulList, '')))) > 0
                    THEN a.AnjingJantanMandulList
                    ELSE p.AnjingJantanMandulList
                END,
                p.AnjingBetinaMandulList = CASE
                    WHEN ISNULL(LTRIM(RTRIM(p.AnjingBetinaMandulList)), '') = '' AND ISNULL(LTRIM(RTRIM(CAST(p.AnjingBaka AS VARCHAR(50)))), '') NOT IN ('', '0')
                    THEN ISNULL(NULLIF(LTRIM(RTRIM(CAST(p.AnjingBetinaMandul AS VARCHAR(50)))), ''), '0')
                    WHEN ISNULL(LTRIM(RTRIM(p.AnjingBetinaMandulList)), '') = '' AND LEN(LTRIM(RTRIM(ISNULL(a.AnjingBetinaMandulList, '')))) > 0
                    THEN a.AnjingBetinaMandulList
                    ELSE p.AnjingBetinaMandulList
                END
            FROM LESEN_PermohonanPembetulan p
            INNER JOIN LESEN_Permohonan a ON p.Permohonan_ID = a.Permohonan_ID
            LEFT JOIN TBL_LOOKUPS lk ON lk.lookupgrp_id = 10004 AND CAST(lk.id AS VARCHAR(50)) = LTRIM(RTRIM(CAST(p.AnjingBaka AS VARCHAR(50))))
            WHERE p.Permohonan_ID = @PermohonanID"

        Using cmd As New SqlCommand(sqlUpdatePembetulan, conn)
            cmd.Parameters.AddWithValue("@PermohonanID", permohonanID)
            cmd.ExecuteNonQuery()
        End Using
    End Sub

#End Region

#Region "PDF Generation & File Attachment Logic (SP, SK, SB)"

    Private Shared Function GenerateAndSaveSuratPemeriksaanPdf(ByVal conn As SqlConnection, ByVal permohonanID As Integer, ByVal jenisLesenID As Integer, ByVal rujukan As String, ByVal docFolderPhysical As String, ByVal forceRegenerate As Boolean) As String
        ' Verify content is not empty
        Dim s1 As String = ""
        Dim s2 As String = ""
        Dim tarikhSurat As String = ""
        Using cmdCheck As New SqlCommand("SELECT ISNULL(CAST(SuratPemeriksaan1 AS NVARCHAR(MAX)), '') AS S1, ISNULL(CAST(SuratPemeriksaan2 AS NVARCHAR(MAX)), '') AS S2, ISNULL(CONVERT(VARCHAR(20), TarikhSuratPemeriksaan, 103), '') AS TarikhSurat FROM LESEN_Permohonan WHERE Permohonan_ID = @ID", conn)
            cmdCheck.Parameters.AddWithValue("@ID", permohonanID)
            Using rdr As SqlDataReader = cmdCheck.ExecuteReader()
                If rdr.Read() Then
                    s1 = Convert.ToString(rdr("S1")).Trim()
                    s2 = Convert.ToString(rdr("S2")).Trim()
                    tarikhSurat = Convert.ToString(rdr("TarikhSurat")).Trim()
                End If
            End Using
        End Using

        If String.IsNullOrEmpty(s1) AndAlso String.IsNullOrEmpty(s2) Then
            Return ""
        End If

        ' Map report template name as used in old appregister / kelulusan / pembatalan
        Dim strReportName As String() = {
            "", "sp_perniagaan", "sp_pasar", "sp_anjing", "sp_penjaja", "sp_billboard",
            "sp_tukaralamat", "sp_tambahpremis", "sp_tambahjenis", "sp_tukarpemilik", "sp_tukariklan",
            "sp_tukarnama", "sp_kurangiklan", "sp_kakilima", "sp_batal", "sp_ekspo",
            "sp_tambahiklan", "sp_tepikedai", "sp_lebuhawam", "sp_tukaralamatnamaiklan", "sp_tukarpemilikalamatiklan",
            "", "", "sp_tukarnamaiklan", "sp_tukarpemilikiklan", "sp_pasartambahpetak", "sp_tukarnamatambahpremis"
        }

        Dim rptBaseName As String = "sp_perniagaan"
        If jenisLesenID >= 1 AndAlso jenisLesenID < strReportName.Length AndAlso Not String.IsNullOrEmpty(strReportName(jenisLesenID)) Then
            rptBaseName = strReportName(jenisLesenID)
        End If

        Dim rptPhysicalPath As String = HttpContext.Current.Server.MapPath("~/lesen/report/pemeriksaan/" & rptBaseName & ".rpt")
        If Not File.Exists(rptPhysicalPath) Then
            Dim fallbackPath1 As String = HttpContext.Current.Server.MapPath("~/lesen/report/pemeriksaan/mpk_suratpemeriksaan.rpt")
            Dim fallbackPath2 As String = HttpContext.Current.Server.MapPath("~/lesen/report/pemeriksaan/sp_perniagaan.rpt")
            If File.Exists(fallbackPath1) Then
                rptPhysicalPath = fallbackPath1
            ElseIf File.Exists(fallbackPath2) Then
                rptPhysicalPath = fallbackPath2
            End If
        End If

        ' Build SQL query matching old kelulusan.aspx.vb / pembatalan.aspx.vb / appregister.aspx.vb (with safe LEFT JOINs)
        Dim sqlData As String = ""
        If jenisLesenID = 4 Then
            sqlData = "SELECT b.UlasanDesc, f.*, a.IsBatal, a.Rujukan, a.RujukanInspektorat, a.TarikhPemeriksaan, a.TarikhSuratPemeriksaan, a.SuratPemeriksaan1, a.SuratPemeriksaan2, " &
                      "c.Pemohon_Name, c.Pemohon_Address, c.Pemohon_ICNo, c.Pemohon_MobileNo, c.Pemohon_TelNo, d.Users_Fullname, d.Users_Signature " &
                      "FROM LESEN_Permohonan a " &
                      "LEFT JOIN LESEN_PermohonanPembetulan f ON a.Permohonan_ID = f.Permohonan_ID " &
                      "LEFT JOIN LESEN_PenjajaUlasan b ON b.PermohonanID = a.Permohonan_ID " &
                      "LEFT JOIN LESEN_Pemohon c ON a.Permohonan_PemohonID = c.Pemohon_ID " &
                      "LEFT JOIN TBL_USERS d ON a.TandatanganPemeriksaanId = d.Users_Id " &
                      "WHERE a.Permohonan_ID = " & permohonanID
        Else
            sqlData = "SELECT b.KadarBayaran_Desc, b.KadarBayaran_Amount, f.*, a.IsBatal, a.Rujukan, a.RujukanInspektorat, a.TarikhPemeriksaan, a.TarikhSuratPemeriksaan, a.SuratPemeriksaan1, a.SuratPemeriksaan2, " &
                      "c.Pemohon_Name, c.Pemohon_Address, c.Pemohon_ICNo, c.Pemohon_MobileNo, c.Pemohon_TelNo, d.Users_Fullname, d.Users_Signature, e.name AS AnjingJenisPremisDesc " &
                      "FROM LESEN_Permohonan a " &
                      "LEFT JOIN LESEN_PermohonanPembetulan f ON a.Permohonan_ID = f.Permohonan_ID " &
                      "LEFT JOIN LESEN_KadarBayaran b ON b.KadarBayaran_PermohonanID = a.Permohonan_ID AND b.KadarBayaran_PermohonanAgensiID = 3 " &
                      "LEFT JOIN LESEN_Pemohon c ON a.Permohonan_PemohonID = c.Pemohon_ID " &
                      "LEFT JOIN TBL_USERS d ON a.TandatanganPemeriksaanId = d.Users_Id " &
                      "LEFT JOIN TBL_LOOKUPS e ON e.id = a.AnjingJenisPremis " &
                      "WHERE a.Permohonan_ID = " & permohonanID
        End If

        Dim fileName As String = "LaporanPemeriksaan_" & permohonanID & ".pdf"
        Dim uniqueFileName As String = Guid.NewGuid().ToString() & "_" & fileName
        Dim fullPdfPath As String = Path.Combine(docFolderPhysical, uniqueFileName)
        Dim virtualPdfPath As String = "~/doc/" & uniqueFileName

        ExportReportOrFallbackToPdf(conn, rptPhysicalPath, sqlData, fullPdfPath, "LAPORAN PEMERIKSAAN", rujukan, tarikhSurat, New String() {s1, s2})

        SavePermohonanFailAndFlag(conn, permohonanID, fileName, virtualPdfPath, "SP", "IsSuratPemeriksaanFail")
        Return ResolveVirtualUrl(virtualPdfPath)
    End Function

    Private Shared Function GenerateAndSaveSuratKelulusanPdf(ByVal conn As SqlConnection, ByVal permohonanID As Integer, ByVal jenisLesenID As Integer, ByVal rujukan As String, ByVal docFolderPhysical As String, ByVal forceRegenerate As Boolean) As String
        ' Verify content is not empty
        Dim s1 As String = ""
        Dim s2 As String = ""
        Dim s3 As String = ""
        Dim s4 As String = ""
        Dim tarikhSurat As String = ""
        Using cmdCheck As New SqlCommand("SELECT ISNULL(CAST(SuratKelulusan1 AS NVARCHAR(MAX)), '') AS S1, ISNULL(CAST(SuratKelulusan2 AS NVARCHAR(MAX)), '') AS S2, ISNULL(CAST(SuratKelulusan3 AS NVARCHAR(MAX)), '') AS S3, ISNULL(CAST(SuratKelulusan4 AS NVARCHAR(MAX)), '') AS S4, ISNULL(CONVERT(VARCHAR(20), TarikhSuratKelulusan, 103), '') AS TarikhSurat FROM LESEN_Permohonan WHERE Permohonan_ID = @ID", conn)
            cmdCheck.Parameters.AddWithValue("@ID", permohonanID)
            Using rdr As SqlDataReader = cmdCheck.ExecuteReader()
                If rdr.Read() Then
                    s1 = Convert.ToString(rdr("S1")).Trim()
                    s2 = Convert.ToString(rdr("S2")).Trim()
                    s3 = Convert.ToString(rdr("S3")).Trim()
                    s4 = Convert.ToString(rdr("S4")).Trim()
                    tarikhSurat = Convert.ToString(rdr("TarikhSurat")).Trim()
                End If
            End Using
        End Using

        If String.IsNullOrEmpty(s1) AndAlso String.IsNullOrEmpty(s2) AndAlso String.IsNullOrEmpty(s3) AndAlso String.IsNullOrEmpty(s4) Then
            Return ""
        End If

        ' Map report template name as used in old semakkelulusan.aspx.vb / kelulusan.aspx.vb
        Dim strReportName As String() = {
            "", "sk_perniagaanb", "sk_pasar", "sk_anjing", "sk_penjaja", "sk_billboard",
            "sk_tukaralamat", "sk_tambahpremis", "sk_tambahjenis", "sk_tukarpemilik", "sk_tukariklan",
            "sk_tukarnama", "sk_kurangiklan", "sk_kakilima", "sk_batal", "sk_ekspo",
            "sk_tambahiklan", "sk_tepikedai", "sk_lebuhawam", "sk_tukaralamatnamaiklan", "sk_tukarpemilikalamatiklan",
            "", "", "sk_tukarnamaiklan", "sk_tukarpemilikiklan", "sk_pasartambahpetak", "sk_tukarnamatambahpremis"
        }

        Dim rptBaseName As String = "sk_perniagaanb"
        If jenisLesenID >= 1 AndAlso jenisLesenID < strReportName.Length AndAlso Not String.IsNullOrEmpty(strReportName(jenisLesenID)) Then
            rptBaseName = strReportName(jenisLesenID)
        End If

        Dim rptPhysicalPath As String = HttpContext.Current.Server.MapPath("~/lesen/report/kelulusan/" & rptBaseName & ".rpt")
        If Not File.Exists(rptPhysicalPath) Then
            ' Handle sk_tukarpemilikalamatiklan .rpt (which has a space before .rpt on disk) or fallback to sk_perniagaanb.rpt
            Dim spaceVariant As String = HttpContext.Current.Server.MapPath("~/lesen/report/kelulusan/" & rptBaseName & " .rpt")
            Dim fallbackSk As String = HttpContext.Current.Server.MapPath("~/lesen/report/kelulusan/sk_perniagaanb.rpt")
            If File.Exists(spaceVariant) Then
                rptPhysicalPath = spaceVariant
            ElseIf File.Exists(fallbackSk) Then
                rptPhysicalPath = fallbackSk
            End If
        End If

        Dim sqlData As String = "SELECT a.KadarBayaran_Desc, a.KadarBayaran_Amount, b.*, c.Pemohon_Name, c.Pemohon_Address, c.Pemohon_ICNo, c.Pemohon_MobileNo, c.Pemohon_TelNo, " &
                                "d.Users_Fullname, d.Users_Signature, e.name AS AnjingJenisPremisDesc " &
                                "FROM LESEN_Permohonan b " &
                                "LEFT JOIN LESEN_KadarBayaran a ON a.KadarBayaran_PermohonanID = b.Permohonan_ID AND a.IsSelect = 1 " &
                                "LEFT JOIN LESEN_Pemohon c ON b.Permohonan_PemohonID = c.Pemohon_ID " &
                                "LEFT JOIN TBL_USERS d ON b.TandatanganKelulusanId = d.Users_Id " &
                                "LEFT JOIN TBL_LOOKUPS e ON e.id = b.AnjingJenisPremis " &
                                "WHERE b.Permohonan_ID = " & permohonanID & " ORDER BY a.SeqNo ASC"

        Dim fileName As String = "SuratKelulusan_" & permohonanID & ".pdf"
        Dim uniqueFileName As String = Guid.NewGuid().ToString() & "_" & fileName
        Dim fullPdfPath As String = Path.Combine(docFolderPhysical, uniqueFileName)
        Dim virtualPdfPath As String = "~/doc/" & uniqueFileName

        ExportReportOrFallbackToPdf(conn, rptPhysicalPath, sqlData, fullPdfPath, "SURAT KELULUSAN", rujukan, tarikhSurat, New String() {s1, s2, s3, s4})

        SavePermohonanFailAndFlag(conn, permohonanID, fileName, virtualPdfPath, "SK", "IsSuratKelulusanFail")
        Return ResolveVirtualUrl(virtualPdfPath)
    End Function

    Private Shared Function GenerateAndSaveSuratPembatalanPdf(ByVal conn As SqlConnection, ByVal permohonanID As Integer, ByVal jenisLesenID As Integer, ByVal rujukan As String, ByVal docFolderPhysical As String, ByVal forceRegenerate As Boolean) As String
        ' Verify content is not empty
        Dim s1 As String = ""
        Dim s2 As String = ""
        Dim tarikhSurat As String = ""
        Using cmdCheck As New SqlCommand("SELECT ISNULL(CAST(SuratPembatalan1 AS NVARCHAR(MAX)), '') AS S1, ISNULL(CAST(SuratPembatalan2 AS NVARCHAR(MAX)), '') AS S2, ISNULL(CONVERT(VARCHAR(20), TarikhSuratKelulusan, 103), '') AS TarikhSurat FROM LESEN_Permohonan WHERE Permohonan_ID = @ID", conn)
            cmdCheck.Parameters.AddWithValue("@ID", permohonanID)
            Using rdr As SqlDataReader = cmdCheck.ExecuteReader()
                If rdr.Read() Then
                    s1 = Convert.ToString(rdr("S1")).Trim()
                    s2 = Convert.ToString(rdr("S2")).Trim()
                    tarikhSurat = Convert.ToString(rdr("TarikhSurat")).Trim()
                End If
            End Using
        End Using

        If String.IsNullOrEmpty(s1) AndAlso String.IsNullOrEmpty(s2) Then
            Return ""
        End If

        ' Map report template name as used in old semakpembatalan.aspx.vb / pembatalan.aspx.vb
        Dim strReportName As String() = {
            "", "sb_perniagaan", "sb_pasar", "sb_anjing", "sb_penjaja", "sb_billboard",
            "sb_tukaralamat", "sb_tambahpremis", "sb_tambahjenis", "sb_tukarpemilik", "sb_tukariklan",
            "sb_tukarnama", "sb_kurangiklan", "sb_kakilima", "sb_batal", "sb_ekspo",
            "sb_tambahiklan", "sb_tepikedai", "sb_lebuhawam", "sb_tukaralamatnamaiklan", "sb_tukarpemilikalamatiklan",
            "", "", "sb_tukarnamaiklan", "sb_tukarpemilikiklan", "sb_pasartambahpetak", "sb_tukarnamatambahpremis"
        }

        Dim rptBaseName As String = "sb_perniagaan"
        If jenisLesenID >= 1 AndAlso jenisLesenID < strReportName.Length AndAlso Not String.IsNullOrEmpty(strReportName(jenisLesenID)) Then
            rptBaseName = strReportName(jenisLesenID)
        End If

        Dim rptPhysicalPath As String = HttpContext.Current.Server.MapPath("~/lesen/report/kelulusan/" & rptBaseName & ".rpt")
        If Not File.Exists(rptPhysicalPath) Then
            Dim fallbackSb As String = HttpContext.Current.Server.MapPath("~/lesen/report/kelulusan/sb_perniagaan.rpt")
            If File.Exists(fallbackSb) Then
                rptPhysicalPath = fallbackSb
            End If
        End If

        Dim sqlData As String = "SELECT b.*, c.Pemohon_Name, c.Pemohon_Address, c.Pemohon_ICNo, c.Pemohon_MobileNo, c.Pemohon_TelNo, " &
                                "d.Users_Fullname, d.Users_Signature, e.name AS AnjingJenisPremisDesc " &
                                "FROM LESEN_Permohonan b " &
                                "LEFT JOIN LESEN_Pemohon c ON b.Permohonan_PemohonID = c.Pemohon_ID " &
                                "LEFT JOIN TBL_USERS d ON b.TandatanganKelulusanId = d.Users_Id " &
                                "LEFT JOIN TBL_LOOKUPS e ON e.id = b.AnjingJenisPremis " &
                                "WHERE b.Permohonan_ID = " & permohonanID

        Dim fileName As String = "SuratPembatalan_" & permohonanID & ".pdf"
        Dim uniqueFileName As String = Guid.NewGuid().ToString() & "_" & fileName
        Dim fullPdfPath As String = Path.Combine(docFolderPhysical, uniqueFileName)
        Dim virtualPdfPath As String = "~/doc/" & uniqueFileName

        ExportReportOrFallbackToPdf(conn, rptPhysicalPath, sqlData, fullPdfPath, "SURAT PEMBATALAN", rujukan, tarikhSurat, New String() {s1, s2})

        SavePermohonanFailAndFlag(conn, permohonanID, fileName, virtualPdfPath, "SB", "IsSuratPembatalanFail")
        Return ResolveVirtualUrl(virtualPdfPath)
    End Function

    Private Shared Sub ExportReportOrFallbackToPdf(ByVal conn As SqlConnection, ByVal rptPhysicalPath As String, ByVal sqlQuery As String, ByVal outputPdfPath As String, ByVal docTitle As String, ByVal rujukan As String, ByVal tarikhSurat As String, ByVal sections As String())
        Dim dt As New DataTable()
        Using da As New SqlDataAdapter(sqlQuery, conn)
            da.Fill(dt)
        End Using

        Dim exportedViaCrystal As Boolean = False
        If File.Exists(rptPhysicalPath) AndAlso dt.Rows.Count > 0 Then
            Dim crRep As New ReportDocument()
            Try
                crRep.Load(rptPhysicalPath)
                crRep.SetDataSource(dt)
                crRep.ExportToDisk(ExportFormatType.PortableDocFormat, outputPdfPath)
                exportedViaCrystal = File.Exists(outputPdfPath)
            Catch exCr As Exception
                ' If Crystal Reports runtime throws an error on a specific legacy template/subreport,
                ' fallback to our clean native PDF generator so the letter/report content is still preserved as PDF
                exportedViaCrystal = False
            Finally
                Try
                    crRep.Close()
                Catch
                End Try
                Try
                    crRep.Dispose()
                Catch
                End Try
            End Try
        End If

        If Not exportedViaCrystal Then
            WriteFallbackPdfFile(outputPdfPath, docTitle, rujukan, tarikhSurat, sections)
        End If
    End Sub

    Private Shared Sub SavePermohonanFailAndFlag(ByVal conn As SqlConnection, ByVal permohonanID As Integer, ByVal fileName As String, ByVal virtualFilePath As String, ByVal jenisLampiran As String, ByVal flagColumnName As String)
        ' Remove existing record for the same Permohonan_ID and JenisLampiran if any, then insert the new PDF record
        Dim sqlFail As String = "
            DELETE FROM LESEN_PermohonanFail
            WHERE PermohonanFail_PermohonanID = @PermohonanID AND PermohonanFail_JenisLampiran = @JenisLampiran;

            INSERT INTO LESEN_PermohonanFail (
                PermohonanFail_PermohonanID,
                PermohonanFail_ContentType,
                PermohonanFail_FileName,
                PermohonanFail_FilePath,
                PermohonanFail_JenisLampiran
            ) VALUES (
                @PermohonanID,
                'application/pdf',
                @FileName,
                @FilePath,
                @JenisLampiran
            );"

        Using cmd As New SqlCommand(sqlFail, conn)
            cmd.Parameters.AddWithValue("@PermohonanID", permohonanID)
            cmd.Parameters.AddWithValue("@FileName", fileName)
            cmd.Parameters.AddWithValue("@FilePath", virtualFilePath)
            cmd.Parameters.AddWithValue("@JenisLampiran", jenisLampiran)
            cmd.ExecuteNonQuery()
        End Using

        ' Update the boolean flag on LESEN_Permohonan (IsSuratPemeriksaanFail / IsSuratKelulusanFail / IsSuratPembatalanFail)
        Dim allowedFlags As String() = {"IsSuratPemeriksaanFail", "IsSuratKelulusanFail", "IsSuratPembatalanFail"}
        If Array.IndexOf(allowedFlags, flagColumnName) >= 0 Then
            Dim sqlFlag As String = "UPDATE LESEN_Permohonan SET " & flagColumnName & " = 1 WHERE Permohonan_ID = @PermohonanID"
            Using cmdFlag As New SqlCommand(sqlFlag, conn)
                cmdFlag.Parameters.AddWithValue("@PermohonanID", permohonanID)
                cmdFlag.ExecuteNonQuery()
            End Using
        End If
    End Sub

    Private Shared Function ResolveVirtualUrl(ByVal virtualPath As String) As String
        If String.IsNullOrEmpty(virtualPath) Then Return ""
        If virtualPath.StartsWith("~/") Then
            Dim appPath As String = If(HttpContext.Current IsNot Nothing AndAlso HttpContext.Current.Request IsNot Nothing, HttpContext.Current.Request.ApplicationPath, "/")
            If Not appPath.EndsWith("/") Then appPath &= "/"
            Return appPath & virtualPath.Substring(2)
        End If
        Return virtualPath
    End Function

#End Region

#Region "Native PDF Fallback Writer (When Crystal Runtime Is Unavailable or Fails)"

    Private Shared Sub WriteFallbackPdfFile(ByVal outputPdfPath As String, ByVal docTitle As String, ByVal rujukan As String, ByVal tarikhSurat As String, ByVal sections As String())
        ' Convert HTML / rich text sections into clean wrapped lines
        Dim allLines As New List(Of String)()
        allLines.Add("MAJLIS PERBANDARAN KLUANG")
        allLines.Add(docTitle)
        allLines.Add(New String("-"c, 75))
        If Not String.IsNullOrEmpty(rujukan) AndAlso rujukan <> "-" Then
            allLines.Add("Rujukan : " & rujukan)
        End If
        If Not String.IsNullOrEmpty(tarikhSurat) Then
            allLines.Add("Tarikh  : " & tarikhSurat)
        End If
        allLines.Add("")

        If sections IsNot Nothing Then
            For Each rawSec As String In sections
                If Not String.IsNullOrWhiteSpace(rawSec) Then
                    Dim plain As String = StripHtmlToPlainText(rawSec)
                    Dim paragraphs As String() = plain.Split(New String() {vbCrLf, vbLf, vbCr}, StringSplitOptions.None)
                    For Each para As String In paragraphs
                        Dim wrapped As List(Of String) = WrapTextLine(para.TrimEnd(), 85)
                        For Each wline As String In wrapped
                            allLines.Add(wline)
                        Next
                    Next
                    allLines.Add("")
                End If
            Next
        End If

        ' Paginate lines (50 lines per A4 page)
        Dim linesPerPage As Integer = 50
        Dim pages As New List(Of List(Of String))()
        Dim idx As Integer = 0
        While idx < allLines.Count
            Dim pageLines As New List(Of String)()
            Dim count As Integer = Math.Min(linesPerPage, allLines.Count - idx)
            For i As Integer = 0 To count - 1
                pageLines.Add(allLines(idx + i))
            Next
            pages.Add(pageLines)
            idx += count
        End While
        If pages.Count = 0 Then
            pages.Add(New List(Of String) From {docTitle})
        End If

        ' Build valid PDF 1.4 document with Helvetica Type1 font
        Using fs As New FileStream(outputPdfPath, FileMode.Create, FileAccess.Write)
            Dim enc As Encoding = Encoding.ASCII
            Dim offsets As New List(Of Long)()
            Dim WriteAscii As Action(Of String) = Sub(s As String)
                                                      Dim b As Byte() = enc.GetBytes(s)
                                                      fs.Write(b, 0, b.Length)
                                                  End Sub

            WriteAscii("%PDF-1.4" & vbLf)

            ' Object 1: Catalog
            offsets.Add(fs.Position)
            WriteAscii("1 0 obj" & vbLf & "<< /Type /Catalog /Pages 2 0 R >>" & vbLf & "endobj" & vbLf)

            ' Object 2: Pages
            Dim kidsSb As New StringBuilder()
            For p As Integer = 0 To pages.Count - 1
                Dim pageObjNum As Integer = 4 + (p * 2)
                kidsSb.Append(pageObjNum & " 0 R ")
            Next
            offsets.Add(fs.Position)
            WriteAscii("2 0 obj" & vbLf & "<< /Type /Pages /Kids [ " & kidsSb.ToString() & "] /Count " & pages.Count & " >>" & vbLf & "endobj" & vbLf)

            ' Object 3: Font (Helvetica)
            offsets.Add(fs.Position)
            WriteAscii("3 0 obj" & vbLf & "<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica /Encoding /WinAnsiEncoding >>" & vbLf & "endobj" & vbLf)

            ' Page & Content Objects
            For p As Integer = 0 To pages.Count - 1
                Dim pageObjNum As Integer = 4 + (p * 2)
                Dim contentObjNum As Integer = pageObjNum + 1

                Dim contentSb As New StringBuilder()
                contentSb.AppendLine("BT")
                contentSb.AppendLine("/F1 10 Tf")
                contentSb.AppendLine("14 TL")
                contentSb.AppendLine("50 790 Td")
                For Each line As String In pages(p)
                    contentSb.AppendLine("(" & EscapePdfString(line) & ") Tj")
                    contentSb.AppendLine("T*")
                Next
                contentSb.AppendLine("ET")
                Dim streamText As String = contentSb.ToString()
                Dim streamLen As Integer = enc.GetByteCount(streamText)

                ' Page object
                offsets.Add(fs.Position)
                WriteAscii(pageObjNum & " 0 obj" & vbLf &
                           "<< /Type /Page /Parent 2 0 R /MediaBox [0 0 595 842] /Resources << /Font << /F1 3 0 R >> >> /Contents " & contentObjNum & " 0 R >>" & vbLf &
                           "endobj" & vbLf)

                ' Content stream object
                offsets.Add(fs.Position)
                WriteAscii(contentObjNum & " 0 obj" & vbLf &
                           "<< /Length " & streamLen & " >>" & vbLf &
                           "stream" & vbLf &
                           streamText &
                           "endstream" & vbLf &
                           "endobj" & vbLf)
            Next

            ' XRef Table
            Dim xrefPos As Long = fs.Position
            Dim totalObjs As Integer = offsets.Count + 1
            WriteAscii("xref" & vbLf & "0 " & totalObjs & vbLf)
            WriteAscii("0000000000 65535 f " & vbLf)
            For Each off As Long In offsets
                WriteAscii(off.ToString("0000000000") & " 00000 n " & vbLf)
            Next

            WriteAscii("trailer" & vbLf &
                       "<< /Size " & totalObjs & " /Root 1 0 R >>" & vbLf &
                       "startxref" & vbLf &
                       xrefPos.ToString() & vbLf &
                       "%%EOF" & vbLf)
        End Using
    End Sub

    Private Shared Function StripHtmlToPlainText(ByVal input As String) As String
        If String.IsNullOrEmpty(input) Then Return ""
        Dim s As String = input
        s = Regex.Replace(s, "<br\s*/?>", vbCrLf, RegexOptions.IgnoreCase)
        s = Regex.Replace(s, "</p\s*>", vbCrLf & vbCrLf, RegexOptions.IgnoreCase)
        s = Regex.Replace(s, "</tr\s*>", vbCrLf, RegexOptions.IgnoreCase)
        s = Regex.Replace(s, "</li\s*>", vbCrLf, RegexOptions.IgnoreCase)
        s = Regex.Replace(s, "<li[^>]*>", "  - ", RegexOptions.IgnoreCase)
        s = Regex.Replace(s, "<[^>]+>", "")
        s = HttpUtility.HtmlDecode(s)
        Return s
    End Function

    Private Shared Function WrapTextLine(ByVal text As String, ByVal maxCols As Integer) As List(Of String)
        Dim res As New List(Of String)()
        If String.IsNullOrEmpty(text) Then
            res.Add("")
            Return res
        End If

        Dim words As String() = text.Split(" "c)
        Dim currentLine As New StringBuilder()
        For Each w As String In words
            If currentLine.Length = 0 Then
                currentLine.Append(w)
            ElseIf currentLine.Length + 1 + w.Length <= maxCols Then
                currentLine.Append(" "c).Append(w)
            Else
                res.Add(currentLine.ToString())
                currentLine.Clear()
                currentLine.Append(w)
            End If
        Next
        If currentLine.Length > 0 Then
            res.Add(currentLine.ToString())
        End If
        Return res
    End Function

    Private Shared Function EscapePdfString(ByVal input As String) As String
        If String.IsNullOrEmpty(input) Then Return ""
        Dim sb As New StringBuilder()
        For Each ch As Char In input
            Dim code As Integer = AscW(ch)
            If ch = "\"c OrElse ch = "("c OrElse ch = ")"c Then
                sb.Append("\"c).Append(ch)
            ElseIf code >= 32 AndAlso code <= 126 Then
                sb.Append(ch)
            Else
                sb.Append(" "c)
            End If
        Next
        Return sb.ToString()
    End Function

#End Region

End Class
