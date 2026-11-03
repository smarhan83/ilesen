Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Web.Services
Imports System.Web.Script.Serialization
Imports System.Text
Imports System.Linq
Imports System.Text.RegularExpressions
Imports CrystalDecisions.CrystalReports.Engine
Imports CrystalDecisions.Shared

' Migrates records created by the old appregister.aspx into the format used by appregister1/appregister2.
' Old records are LESEN_Permohonan rows with JenisLesen_ID > 0 (new pages keep JenisLesen_ID = 0 and use JenisLesenIdList).
'
' Flow (driven by JavaScript in migratedata.aspx):
'   1. GetMigrationSummary  - counts what is still pending
'   2. GetPendingQueue      - list of Permohonan_ID that still need work
'   3. ProcessMigrationBatch - called repeatedly with a small batch of that list
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
            Dim sql As String = PendingWorkSql() & "
                SELECT
                    COUNT(1)                             AS TotalPermohonan,
                    ISNULL(SUM(NeedFormat), 0)           AS PendingFormatCount,
                    ISNULL(SUM(NeedJenisLesenList), 0)   AS PendingJenisLesenListCount,
                    ISNULL(SUM(NeedIklanList), 0)        AS PendingIklanListCount,
                    ISNULL(SUM(NeedAnjingList), 0)       AS PendingAnjingListCount,
                    ISNULL(SUM(NeedPembetulan), 0)       AS PendingPembetulanCount,
                    ISNULL(SUM(NeedSP), 0)               AS PendingSPCount,
                    ISNULL(SUM(NeedSK), 0)               AS PendingSKCount,
                    ISNULL(SUM(NeedSB), 0)               AS PendingSBCount,
                    ISNULL(SUM(IsSPDone), 0)             AS CompletedSPCount,
                    ISNULL(SUM(IsSKDone), 0)             AS CompletedSKCount,
                    ISNULL(SUM(IsSBDone), 0)             AS CompletedSBCount
                FROM RecordNeeds"

            Using conn As New SqlConnection(ConnectionString())
                conn.Open()
                Using cmd As New SqlCommand(sql, conn)
                    cmd.CommandTimeout = 120
                    cmd.Parameters.AddWithValue("@ForcePdf", 0)
                    Using rdr As SqlDataReader = cmd.ExecuteReader()
                        If rdr.Read() Then
                            res.TotalPermohonan = Convert.ToInt32(rdr("TotalPermohonan"))
                            res.PendingFormatCount = Convert.ToInt32(rdr("PendingFormatCount"))
                            res.PendingJenisLesenListCount = Convert.ToInt32(rdr("PendingJenisLesenListCount"))
                            res.PendingIklanListCount = Convert.ToInt32(rdr("PendingIklanListCount"))
                            res.PendingAnjingListCount = Convert.ToInt32(rdr("PendingAnjingListCount"))
                            res.PendingPembetulanCount = Convert.ToInt32(rdr("PendingPembetulanCount"))
                            res.PendingSPCount = Convert.ToInt32(rdr("PendingSPCount"))
                            res.PendingSKCount = Convert.ToInt32(rdr("PendingSKCount"))
                            res.PendingSBCount = Convert.ToInt32(rdr("PendingSBCount"))
                            res.CompletedSPCount = Convert.ToInt32(rdr("CompletedSPCount"))
                            res.CompletedSKCount = Convert.ToInt32(rdr("CompletedSKCount"))
                            res.CompletedSBCount = Convert.ToInt32(rdr("CompletedSBCount"))
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
            Dim sql As String = PendingWorkSql() & "
                SELECT Permohonan_ID, Rujukan, JenisLesen_ID, NeedFormat, NeedSP, NeedSK, NeedSB
                FROM RecordNeeds
                WHERE (@IncludeFormat = 1 AND NeedFormat = 1)
                   OR (@IncludeSP = 1 AND NeedSP = 1)
                   OR (@IncludeSK = 1 AND NeedSK = 1)
                   OR (@IncludeSB = 1 AND NeedSB = 1)
                ORDER BY Permohonan_ID ASC"

            Using conn As New SqlConnection(ConnectionString())
                conn.Open()
                Using cmd As New SqlCommand(sql, conn)
                    cmd.CommandTimeout = 120
                    cmd.Parameters.AddWithValue("@ForcePdf", If(forceRegeneratePdf, 1, 0))
                    cmd.Parameters.AddWithValue("@IncludeFormat", If(includeFormat, 1, 0))
                    cmd.Parameters.AddWithValue("@IncludeSP", If(includeSP, 1, 0))
                    cmd.Parameters.AddWithValue("@IncludeSK", If(includeSK, 1, 0))
                    cmd.Parameters.AddWithValue("@IncludeSB", If(includeSB, 1, 0))
                    Using rdr As SqlDataReader = cmd.ExecuteReader()
                        While rdr.Read()
                            res.Items.Add(New QueueItem With {
                                .PermohonanID = Convert.ToInt32(rdr("Permohonan_ID")),
                                .Rujukan = Convert.ToString(rdr("Rujukan")),
                                .JenisLesenID = Convert.ToInt32(rdr("JenisLesen_ID")),
                                .NeedFormat = includeFormat AndAlso Convert.ToInt32(rdr("NeedFormat")) = 1,
                                .NeedSP = includeSP AndAlso Convert.ToInt32(rdr("NeedSP")) = 1,
                                .NeedSK = includeSK AndAlso Convert.ToInt32(rdr("NeedSK")) = 1,
                                .NeedSB = includeSB AndAlso Convert.ToInt32(rdr("NeedSB")) = 1
                            })
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
            Dim docFolderPhysical As String = HttpContext.Current.Server.MapPath("~/doc/")
            If Not Directory.Exists(docFolderPhysical) Then
                Directory.CreateDirectory(docFolderPhysical)
            End If

            Using conn As New SqlConnection(ConnectionString())
                conn.Open()

                For Each item As QueueItem In items
                    Dim pid As Integer = item.PermohonanID
                    Dim jenisLesenID As Integer = item.JenisLesenID
                    Dim rujukan As String = If(String.IsNullOrEmpty(item.Rujukan), "-", item.Rujukan)

                    ' 1. Update SQL data format (LESEN_Permohonan & LESEN_PermohonanPembetulan)
                    If item.NeedFormat AndAlso RunStep(res, item, "Format Data SQL",
                            "Berjaya kemaskini format jadual baharu (JenisLesenIdList / IklanList / AnjingList / Pembetulan).",
                            Function()
                                UpdateRecordDataFormat(conn, pid)
                                Return ""
                            End Function) Then
                        res.FormatUpdatedCount += 1
                    End If

                    ' 2. Laporan / Surat Pemeriksaan (SP)
                    If item.NeedSP AndAlso RunStep(res, item, "PDF Laporan Pemeriksaan (SP)",
                            "Berjaya simpan PDF Laporan Pemeriksaan & kemaskini IsSuratPemeriksaanFail = 1.",
                            Function() GenerateSuratPemeriksaanPdf(conn, pid, jenisLesenID, rujukan, docFolderPhysical)) Then
                        res.SPGeneratedCount += 1
                    End If

                    ' 3. Surat Kelulusan (SK)
                    If item.NeedSK AndAlso RunStep(res, item, "PDF Surat Kelulusan (SK)",
                            "Berjaya simpan PDF Surat Kelulusan & kemaskini IsSuratKelulusanFail = 1.",
                            Function() GenerateSuratKelulusanPdf(conn, pid, jenisLesenID, rujukan, docFolderPhysical)) Then
                        res.SKGeneratedCount += 1
                    End If

                    ' 4. Surat Pembatalan (SB)
                    If item.NeedSB AndAlso RunStep(res, item, "PDF Surat Pembatalan (SB)",
                            "Berjaya simpan PDF Surat Pembatalan & kemaskini IsSuratPembatalanFail = 1.",
                            Function() GenerateSuratPembatalanPdf(conn, pid, jenisLesenID, rujukan, docFolderPhysical)) Then
                        res.SBGeneratedCount += 1
                    End If

                    res.ProcessedCount += 1
                Next
            End Using

            ' Release Crystal Reports unmanaged COM handles after each batch
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

    ''' <summary>
    ''' Runs one migration step for one record and writes the outcome to the activity / error log.
    ''' The step returns the URL of the generated PDF ("" when the step creates no file),
    ''' or Nothing when there was nothing to do (e.g. the letter is empty).
    ''' Returns True when the step completed successfully.
    ''' </summary>
    Private Shared Function RunStep(ByVal res As BatchResult, ByVal item As QueueItem, ByVal category As String, ByVal successMessage As String, ByVal stepWork As Func(Of String)) As Boolean
        Dim rujukan As String = If(String.IsNullOrEmpty(item.Rujukan), "-", item.Rujukan)
        Dim timestamp As String = DateTime.Now.ToString("HH:mm:ss")
        Try
            Dim fileUrl As String = stepWork()
            If fileUrl Is Nothing Then Return False

            res.Activities.Add(New ActivityLogEntry With {
                .Timestamp = timestamp, .PermohonanID = item.PermohonanID, .Rujukan = rujukan,
                .Category = category, .Status = "SUCCESS", .Message = successMessage, .FileUrl = fileUrl
            })
            Return True
        Catch ex As Exception
            res.ErrorCount += 1
            res.Errors.Add(New ErrorLogEntry With {
                .Timestamp = timestamp, .PermohonanID = item.PermohonanID, .Rujukan = rujukan,
                .StepName = category, .ErrorMessage = ex.Message
            })
            res.Activities.Add(New ActivityLogEntry With {
                .Timestamp = timestamp, .PermohonanID = item.PermohonanID, .Rujukan = rujukan,
                .Category = category, .Status = "ERROR", .Message = "Ralat: " & ex.Message, .FileUrl = ""
            })
            Return False
        End Try
    End Function

    Private Shared Function ConnectionString() As String
        Return ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString
    End Function

#End Region

#Region "Pending Work Query (shared by summary & queue)"

    ''' <summary>
    ''' Common table expressions that give one row per permohonan with 0/1 flags for each pending task.
    ''' The caller appends its own "SELECT ... FROM RecordNeeds". Requires parameter @ForcePdf (0/1).
    ''' Summary and queue both use this, so the counts on screen always match the records processed.
    ''' </summary>
    Private Shared Function PendingWorkSql() As String
        Return "
            WITH PdfFiles AS (
                SELECT
                    PermohonanFail_PermohonanID AS Permohonan_ID,
                    MAX(CASE WHEN PermohonanFail_JenisLampiran = 'SP' THEN 1 ELSE 0 END) AS HasSPFile,
                    MAX(CASE WHEN PermohonanFail_JenisLampiran = 'SK' THEN 1 ELSE 0 END) AS HasSKFile,
                    MAX(CASE WHEN PermohonanFail_JenisLampiran = 'SB' THEN 1 ELSE 0 END) AS HasSBFile
                FROM LESEN_PermohonanFail
                WHERE PermohonanFail_JenisLampiran IN ('SP', 'SK', 'SB')
                GROUP BY PermohonanFail_PermohonanID
            ),
            RecordState AS (
                SELECT
                    a.Permohonan_ID,
                    ISNULL(a.Rujukan, '-') AS Rujukan,
                    ISNULL(a.JenisLesen_ID, 0) AS JenisLesen_ID,
                    CASE WHEN ISNULL(a.JenisLesen_ID, 0) > 0 THEN 1 ELSE 0 END AS IsOldRecord,
                    CASE WHEN ISNULL(a.StatusID, 0) > 0 AND p.Permohonan_ID IS NULL THEN 1 ELSE 0 END AS MissingPembetulan,
                    CASE WHEN ISNULL(LTRIM(RTRIM(a.JenisLesenIdList)), '') = '' THEN 1 ELSE 0 END AS MissingJenisLesenList,
                    CASE WHEN " & IklanPendingSql("a") & "
                           OR (p.Permohonan_ID IS NOT NULL AND " & IklanPendingSql("p") & ")
                         THEN 1 ELSE 0 END AS IklanPending,
                    CASE WHEN " & AnjingPendingSql("a") & "
                           OR (p.Permohonan_ID IS NOT NULL AND " & AnjingPendingSql("p") & ")
                         THEN 1 ELSE 0 END AS AnjingPending,

                    CASE WHEN " & NotBlankSql("a.SuratPemeriksaan1") & " OR " & NotBlankSql("a.SuratPemeriksaan2") & "
                         THEN 1 ELSE 0 END AS HasSPText,
                    CASE WHEN " & NotBlankSql("a.SuratKelulusan1") & " OR " & NotBlankSql("a.SuratKelulusan2") & "
                           OR " & NotBlankSql("a.SuratKelulusan3") & " OR " & NotBlankSql("a.SuratKelulusan4") & "
                         THEN 1 ELSE 0 END AS HasSKText,
                    CASE WHEN " & NotBlankSql("a.SuratPembatalan1") & " OR " & NotBlankSql("a.SuratPembatalan2") & "
                         THEN 1 ELSE 0 END AS HasSBText,

                    CAST(ISNULL(a.IsSuratPemeriksaanFail, 0) AS INT) AS IsSPDone,
                    CAST(ISNULL(a.IsSuratKelulusanFail, 0) AS INT) AS IsSKDone,
                    CAST(ISNULL(a.IsSuratPembatalanFail, 0) AS INT) AS IsSBDone,
                    ISNULL(f.HasSPFile, 0) AS HasSPFile,
                    ISNULL(f.HasSKFile, 0) AS HasSKFile,
                    ISNULL(f.HasSBFile, 0) AS HasSBFile
                FROM LESEN_Permohonan a
                LEFT JOIN LESEN_PermohonanPembetulan p ON p.Permohonan_ID = a.Permohonan_ID
                LEFT JOIN PdfFiles f ON f.Permohonan_ID = a.Permohonan_ID
            ),
            RecordNeeds AS (
                SELECT s.*, n.*,
                    CASE WHEN n.NeedJenisLesenList + n.NeedIklanList + n.NeedAnjingList + n.NeedPembetulan > 0
                         THEN 1 ELSE 0 END AS NeedFormat
                FROM RecordState s
                CROSS APPLY (
                    SELECT
                        -- Data format changes only apply to old records (JenisLesen_ID > 0)
                        CASE WHEN s.IsOldRecord = 1 AND s.MissingJenisLesenList = 1 THEN 1 ELSE 0 END AS NeedJenisLesenList,
                        CASE WHEN s.IsOldRecord = 1 AND s.IklanPending = 1 THEN 1 ELSE 0 END AS NeedIklanList,
                        CASE WHEN s.IsOldRecord = 1 AND s.AnjingPending = 1 THEN 1 ELSE 0 END AS NeedAnjingList,
                        CASE WHEN s.IsOldRecord = 1 AND s.MissingPembetulan = 1 THEN 1 ELSE 0 END AS NeedPembetulan,
                        -- A PDF is needed when the letter has text and the PDF was not saved yet (or a regenerate is forced)
                        CASE WHEN s.HasSPText = 1 AND (@ForcePdf = 1 OR s.IsSPDone = 0 OR s.HasSPFile = 0) THEN 1 ELSE 0 END AS NeedSP,
                        CASE WHEN s.HasSKText = 1 AND (@ForcePdf = 1 OR s.IsSKDone = 0 OR s.HasSKFile = 0) THEN 1 ELSE 0 END AS NeedSK,
                        CASE WHEN s.HasSBText = 1 AND (@ForcePdf = 1 OR s.IsSBDone = 0 OR s.HasSBFile = 0) THEN 1 ELSE 0 END AS NeedSB
                ) n
            )"
    End Function

    ''' <summary>SQL condition: the text/ntext column has non-blank content.</summary>
    Private Shared Function NotBlankSql(ByVal column As String) As String
        Return "LEN(LTRIM(RTRIM(ISNULL(CAST(" & column & " AS NVARCHAR(MAX)), '')))) > 0"
    End Function

    ''' <summary>
    ''' SQL condition: the iklan lists of this row (alias "a" or "p") still need to be built.
    ''' Must stay in sync with <see cref="NeedsIklanMigration"/>.
    ''' </summary>
    Private Shared Function IklanPendingSql(ByVal tableAlias As String) As String
        Dim t As String = tableAlias & "."
        Return "(LTRIM(RTRIM(REPLACE(ISNULL(" & t & "SaizIklan, ''), '-', ''))) <> ''" &
               " AND (ISNULL(LTRIM(RTRIM(" & t & "SaizIklanList)), '') = ''" &
               "      OR (" & t & "SaizIklanList = REPLACE(LTRIM(RTRIM(" & t & "SaizIklan)), ',', ';') AND " & t & "CahayaIklanList = '" & CAHAYA_YA & "')))"
    End Function

    ''' <summary>SQL condition: the anjing lists of this row (alias "a" or "p") still need to be built.</summary>
    Private Shared Function AnjingPendingSql(ByVal tableAlias As String) As String
        Dim t As String = tableAlias & "."
        Return "(ISNULL(LTRIM(RTRIM(CAST(" & t & "AnjingBaka AS VARCHAR(50)))), '') NOT IN ('', '0')" &
               " AND ISNULL(LTRIM(RTRIM(" & t & "BakaAnjingList)), '') = '')"
    End Function

#End Region

#Region "SQL Data Format Migration Logic"

    ''' <summary>
    ''' Converts one old record to the new table format:
    '''   1. LESEN_Permohonan: JenisLesenIdList / JenisLesenDescList, anjing lists and default boolean flags.
    '''   2. LESEN_Permohonan: iklan lists (parsed from the old free-text SaizIklan, see "Iklan Migration Logic").
    '''   3. Create LESEN_PermohonanPembetulan if a submitted record (StatusID > 0) does not have one.
    '''   4. LESEN_PermohonanPembetulan: anjing lists and iklan lists from its own old columns.
    ''' Every list is only written when it is still empty, so running this twice is safe.
    ''' </summary>
    Private Shared Sub UpdateRecordDataFormat(ByVal conn As SqlConnection, ByVal permohonanID As Integer)
        ' 1. LESEN_Permohonan: JenisLesen, anjing & flags
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
        ExecuteForPermohonan(conn, sqlUpdatePermohonan, permohonanID)

        ' 2. LESEN_Permohonan: iklan
        MigrateIklanList(conn, "LESEN_Permohonan", permohonanID)

        ' 3. Ensure LESEN_PermohonanPembetulan exists for submitted records (StatusID > 0),
        '    copying the same columns as appregister1.aspx.vb insertMaklumatPembetulan
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
        ExecuteForPermohonan(conn, sqlInsertMissingPembetulan, permohonanID)

        ' 4. LESEN_PermohonanPembetulan: anjing (falls back to LESEN_Permohonan lists) & iklan
        Dim sqlUpdatePembetulan As String = "
            UPDATE p
            SET
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
        ExecuteForPermohonan(conn, sqlUpdatePembetulan, permohonanID)

        MigrateIklanList(conn, "LESEN_PermohonanPembetulan", permohonanID)
    End Sub

    Private Shared Sub ExecuteForPermohonan(ByVal conn As SqlConnection, ByVal sql As String, ByVal permohonanID As Integer)
        Using cmd As New SqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@PermohonanID", permohonanID)
            cmd.ExecuteNonQuery()
        End Using
    End Sub

#End Region

#Region "Iklan Migration Logic"

    ' OLD format (appregister.aspx): one free-text column for all iklan, e.g.
    '     SaizIklan = "20X4 (BERCAHAYA), 3X3 (TB), 6X3 (TB)"     UnitIklan = 3
    '     SaizIklan = "2X3 & 3X3 (TIDAK BERCAHAYA)"              UnitIklan = 2
    '     SaizIklan = "20X4/BERLAMPU"                            UnitIklan = 1
    '   IklanBercahaya was a hidden field and is normally empty, so the lighting
    '   (Bercahaya / Tidak Bercahaya) has to be read from the SaizIklan text itself.
    '
    ' NEW format (appregister1 / appregister2 / kelulusan1 / semak*1): three comma-separated lists
    ' that must have the SAME number of items (pages read CahayaIklanList(i) for each SaizIklanList(i)):
    '     SaizIklanList   = "20X4,3X3,6X3"
    '     CahayaIklanList = "Bercahaya,Tidak Bercahaya,Tidak Bercahaya"   (values of DDL_Iklan1)
    '     UnitIklanList   = "1,1,1"

    Private Const CAHAYA_YA As String = "Bercahaya"
    Private Const CAHAYA_TIDAK As String = "Tidak Bercahaya"
    Private Const TIADA_MAKLUMAT As String = "-"   ' size or lighting not stated in the old record

    ' "TIDAK BERCAHAYA", "TIDAK CAHAYA", "TIDAK BERLAMPU", "TANPA LAMPU", "(TB)"   (CA?HAYA also accepts the typo "BERCHAYA")
    Private Shared ReadOnly RxTidakBercahaya As New Regex("\b(TIDAK|TANPA)\s*(BER)?(CA?HAYA|LAMPU)\b|\bTB\b", RegexOptions.IgnoreCase)
    ' "BERCAHAYA", "CAHAYA", "BERLAMPU", "(B)", "/B", "- B"
    Private Shared ReadOnly RxBercahaya As New Regex("(BER)?CA?HAYA|BERLAMPU|\(\s*B\s*\)|[-/]\s*B\b", RegexOptions.IgnoreCase)
    ' Any lighting words, removed from the size text: "IKLAN BERCAHAYA", "TIDAK BERLAMPU", "TB", "(B)", "/B" ...
    Private Shared ReadOnly RxLightingWords As New Regex("(IKLAN\s*)?((TIDAK|TANPA)\s*)?(BER)?(CA?HAYA|LAMPU)|\bTB\b|\(\s*B\s*\)|[-/]\s*B\b", RegexOptions.IgnoreCase)
    ' "2 UNIT", "2UNIT"
    Private Shared ReadOnly RxUnitWords As New Regex("(\d+)\s*UNIT\b", RegexOptions.IgnoreCase)
    ' Separators between several iklan in one old SaizIklan: "," or "&"
    Private Shared ReadOnly RxIklanSeparator As New Regex("[,&]")

    Private Class IklanItem
        Public Property Saiz As String
        Public Property Cahaya As String
        Public Property Unit As Integer
    End Class

    ''' <summary>
    ''' Builds SaizIklanList / CahayaIklanList / UnitIklanList for one row of
    ''' LESEN_Permohonan or LESEN_PermohonanPembetulan from its old SaizIklan / IklanBercahaya / UnitIklan.
    ''' </summary>
    Private Shared Sub MigrateIklanList(ByVal conn As SqlConnection, ByVal tableName As String, ByVal permohonanID As Integer)
        If tableName <> "LESEN_Permohonan" AndAlso tableName <> "LESEN_PermohonanPembetulan" Then
            Throw New ArgumentException("Jadual tidak sah: " & tableName)
        End If

        Dim saizIklan As String = Nothing
        Dim iklanBercahaya As String = ""
        Dim unitIklan As Integer = 0
        Dim saizIklanList As String = ""
        Dim cahayaIklanList As String = ""

        Dim sqlRead As String = "SELECT SaizIklan, IklanBercahaya, UnitIklan, SaizIklanList, CahayaIklanList FROM " & tableName & " WHERE Permohonan_ID = @PermohonanID"
        Using cmd As New SqlCommand(sqlRead, conn)
            cmd.Parameters.AddWithValue("@PermohonanID", permohonanID)
            Using rdr As SqlDataReader = cmd.ExecuteReader()
                If Not rdr.Read() Then Return
                saizIklan = Convert.ToString(rdr("SaizIklan"))
                iklanBercahaya = Convert.ToString(rdr("IklanBercahaya"))
                unitIklan = If(IsDBNull(rdr("UnitIklan")), 0, Convert.ToInt32(rdr("UnitIklan")))
                saizIklanList = Convert.ToString(rdr("SaizIklanList"))
                cahayaIklanList = Convert.ToString(rdr("CahayaIklanList"))
            End Using
        End Using

        If Not NeedsIklanMigration(saizIklan, saizIklanList, cahayaIklanList) Then Return

        Dim items As List(Of IklanItem) = ParseOldIklan(saizIklan, iklanBercahaya, unitIklan)

        Dim sqlUpdate As String = "UPDATE " & tableName & " SET SaizIklanList = @SaizIklanList, CahayaIklanList = @CahayaIklanList, UnitIklanList = @UnitIklanList WHERE Permohonan_ID = @PermohonanID"
        Using cmd As New SqlCommand(sqlUpdate, conn)
            cmd.Parameters.AddWithValue("@PermohonanID", permohonanID)
            cmd.Parameters.AddWithValue("@SaizIklanList", String.Join(",", items.Select(Function(i) i.Saiz)))
            cmd.Parameters.AddWithValue("@CahayaIklanList", String.Join(",", items.Select(Function(i) i.Cahaya)))
            cmd.Parameters.AddWithValue("@UnitIklanList", String.Join(",", items.Select(Function(i) i.Unit.ToString())))
            cmd.ExecuteNonQuery()
        End Using
    End Sub

    ''' <summary>
    ''' True when the row has old iklan text and its lists are empty, or were written by the first
    ''' version of this page (which changed "," to ";" and marked every iklan as "Bercahaya").
    ''' Must stay in sync with <see cref="IklanPendingSql"/>.
    ''' </summary>
    Private Shared Function NeedsIklanMigration(ByVal saizIklan As String, ByVal saizIklanList As String, ByVal cahayaIklanList As String) As Boolean
        If Not HasIklanText(saizIklan) Then Return False
        If String.IsNullOrWhiteSpace(saizIklanList) Then Return True

        Dim writtenByFirstVersion As Boolean =
            String.Equals(saizIklanList.Trim(), saizIklan.Trim().Replace(",", ";"), StringComparison.OrdinalIgnoreCase) AndAlso
            String.Equals(If(cahayaIklanList, "").Trim(), CAHAYA_YA, StringComparison.OrdinalIgnoreCase)
        Return writtenByFirstVersion
    End Function

    ''' <summary>Old records use "-" (or blank) when there is no iklan.</summary>
    Private Shared Function HasIklanText(ByVal saizIklan As String) As Boolean
        Return Not String.IsNullOrWhiteSpace(If(saizIklan, "").Replace("-", ""))
    End Function

    ''' <summary>
    ''' Splits the old free-text SaizIklan into separate iklan items.
    ''' The text is only split when the units add up to the old UnitIklan; otherwise it is kept
    ''' as one item so the total number of units never changes.
    ''' </summary>
    Private Shared Function ParseOldIklan(ByVal saizIklan As String, ByVal iklanBercahaya As String, ByVal unitIklan As Integer) As List(Of IklanItem)
        Dim items As New List(Of IklanItem)()
        If Not HasIklanText(saizIklan) Then Return items

        Dim text As String = saizIklan.Trim()
        Dim cahayaFromOldColumn As String = CahayaFromOldIklanBercahaya(iklanBercahaya)

        ' Units written in each part, e.g. "20X4 (2 UNIT) & 36X4 (1 UNIT)" -> 2 and 1 (default 1 per part)
        Dim parts As List(Of String) = RxIklanSeparator.Split(text).Select(Function(p) p.Trim()).Where(Function(p) p <> "").ToList()
        Dim partUnits As List(Of Integer) = parts.Select(Function(p) UnitWrittenInText(p)).ToList()

        ' UnitIklan 0 / NULL means it was not filled in. Negative values (e.g. Kurang Iklan) keep their sign.
        Dim unitsMatch As Boolean = (unitIklan = 0 OrElse partUnits.Sum() = Math.Abs(unitIklan))

        If parts.Count > 1 AndAlso unitsMatch Then
            Dim sign As Integer = If(unitIklan < 0, -1, 1)
            For i As Integer = 0 To parts.Count - 1
                items.Add(New IklanItem With {
                    .Saiz = CleanSaizText(parts(i), removeUnitWords:=True),
                    .Cahaya = DetectCahaya(parts(i)),
                    .Unit = sign * partUnits(i)
                })
            Next
            FillMissingCahaya(items, cahayaFromOldColumn)
        Else
            ' Keep as one item. "," is the list separator in the new format, so it cannot stay in the text.
            Dim cahaya As String = DetectCahaya(text)
            items.Add(New IklanItem With {
                .Saiz = CleanSaizText(text, removeUnitWords:=False).Replace(",", ";"),
                .Cahaya = If(cahaya = "", cahayaFromOldColumn, cahaya),
                .Unit = If(unitIklan = 0, 1, unitIklan)
            })
        End If

        Return items
    End Function

    ''' <summary>
    ''' Items without their own lighting take it from the next item that has one, because old records
    ''' usually write it once at the end: "2X3 & 3X3 (TIDAK BERCAHAYA)" means both are Tidak Bercahaya.
    ''' If no later item has it, the previous item is used, then the old IklanBercahaya column.
    ''' </summary>
    Private Shared Sub FillMissingCahaya(ByVal items As List(Of IklanItem), ByVal defaultCahaya As String)
        For i As Integer = 0 To items.Count - 1
            If items(i).Cahaya <> "" Then Continue For

            Dim nextKnown As IklanItem = items.Skip(i + 1).FirstOrDefault(Function(x) x.Cahaya <> "")
            Dim previousKnown As IklanItem = items.Take(i).LastOrDefault(Function(x) x.Cahaya <> "")

            If nextKnown IsNot Nothing Then
                items(i).Cahaya = nextKnown.Cahaya
            ElseIf previousKnown IsNot Nothing Then
                items(i).Cahaya = previousKnown.Cahaya
            Else
                items(i).Cahaya = defaultCahaya
            End If
        Next
    End Sub

    ''' <summary>Returns "Bercahaya", "Tidak Bercahaya" or "" (not stated) from the iklan text.</summary>
    Private Shared Function DetectCahaya(ByVal text As String) As String
        If RxTidakBercahaya.IsMatch(text) Then Return CAHAYA_TIDAK ' check first: "TIDAK BERCAHAYA" also contains "BERCAHAYA"
        If RxBercahaya.IsMatch(text) Then Return CAHAYA_YA
        Return ""
    End Function

    ''' <summary>Old IklanBercahaya dropdown: 1 = Ya, 2 = Tidak.</summary>
    Private Shared Function CahayaFromOldIklanBercahaya(ByVal iklanBercahaya As String) As String
        Select Case If(iklanBercahaya, "").Trim().ToUpper()
            Case "1", "YA", "BERCAHAYA"
                Return CAHAYA_YA
            Case "2", "0", "TIDAK", "TIDAK BERCAHAYA"
                Return CAHAYA_TIDAK
            Case Else
                Return TIADA_MAKLUMAT
        End Select
    End Function

    Private Shared Function UnitWrittenInText(ByVal text As String) As Integer
        Dim m As Match = RxUnitWords.Match(text)
        Return If(m.Success, Integer.Parse(m.Groups(1).Value), 1)
    End Function

    ''' <summary>
    ''' Removes lighting words (and optionally "n UNIT") from the size text, since they now have their own columns.
    ''' "20X4 (TIDAK BERCAHAYA)" -> "20X4",  "IKLAN BERCAHAYA (20'X4')" -> "20'X4'",  "17X4-2 UNIT" -> "17X4"
    ''' Returns "-" when no size is written at all, e.g. "IKLAN BERCAHAYA".
    ''' </summary>
    Private Shared Function CleanSaizText(ByVal text As String, ByVal removeUnitWords As Boolean) As String
        Dim s As String = RxLightingWords.Replace(text, " ")
        If removeUnitWords Then s = RxUnitWords.Replace(s, " ")

        s = Regex.Replace(s, "\([\s\-/]*\)", " ")          ' brackets left empty: "20X4 ( )", "4X4 ( - )"
        s = Regex.Replace(s, "([/\-])(\s*[/\-])+", "$1")   ' repeated separators: "20X4 / /"
        s = Regex.Replace(s, "\s+", " ").Trim(" "c, "-"c, "/"c)

        ' Brackets around the whole size: "(20'X4')"
        If s.StartsWith("(") AndAlso s.EndsWith(")") AndAlso s.IndexOf(")"c) = s.Length - 1 Then
            s = s.Substring(1, s.Length - 2).Trim()
        End If

        Return If(s = "", TIADA_MAKLUMAT, s)
    End Function

#End Region

#Region "PDF Generation & File Attachment Logic (SP, SK, SB)"

    ' Report templates by JenisLesen_ID (index), as used by the old appregister / kelulusan / pembatalan pages
    Private Shared ReadOnly SP_REPORT_NAMES As String() = {
        "", "sp_perniagaan", "sp_pasar", "sp_anjing", "sp_penjaja", "sp_billboard",
        "sp_tukaralamat", "sp_tambahpremis", "sp_tambahjenis", "sp_tukarpemilik", "sp_tukariklan",
        "sp_tukarnama", "sp_kurangiklan", "sp_kakilima", "sp_batal", "sp_ekspo",
        "sp_tambahiklan", "sp_tepikedai", "sp_lebuhawam", "sp_tukaralamatnamaiklan", "sp_tukarpemilikalamatiklan",
        "", "", "sp_tukarnamaiklan", "sp_tukarpemilikiklan", "sp_pasartambahpetak", "sp_tukarnamatambahpremis"
    }

    Private Shared ReadOnly SK_REPORT_NAMES As String() = {
        "", "sk_perniagaanb", "sk_pasar", "sk_anjing", "sk_penjaja", "sk_billboard",
        "sk_tukaralamat", "sk_tambahpremis", "sk_tambahjenis", "sk_tukarpemilik", "sk_tukariklan",
        "sk_tukarnama", "sk_kurangiklan", "sk_kakilima", "sk_batal", "sk_ekspo",
        "sk_tambahiklan", "sk_tepikedai", "sk_lebuhawam", "sk_tukaralamatnamaiklan", "sk_tukarpemilikalamatiklan",
        "", "", "sk_tukarnamaiklan", "sk_tukarpemilikiklan", "sk_pasartambahpetak", "sk_tukarnamatambahpremis"
    }

    Private Shared ReadOnly SB_REPORT_NAMES As String() = {
        "", "sb_perniagaan", "sb_pasar", "sb_anjing", "sb_penjaja", "sb_billboard",
        "sb_tukaralamat", "sb_tambahpremis", "sb_tambahjenis", "sb_tukarpemilik", "sb_tukariklan",
        "sb_tukarnama", "sb_kurangiklan", "sb_kakilima", "sb_batal", "sb_ekspo",
        "sb_tambahiklan", "sb_tepikedai", "sb_lebuhawam", "sb_tukaralamatnamaiklan", "sb_tukarpemilikalamatiklan",
        "", "", "sb_tukarnamaiklan", "sb_tukarpemilikiklan", "sb_pasartambahpetak", "sb_tukarnamatambahpremis"
    }

    ''' <summary>Text of an old letter (stored in LESEN_Permohonan columns) and its date.</summary>
    Private Class LetterText
        Public Property Sections As String()
        Public Property TarikhSurat As String
    End Class

    Private Shared Function GenerateSuratPemeriksaanPdf(ByVal conn As SqlConnection, ByVal permohonanID As Integer, ByVal jenisLesenID As Integer, ByVal rujukan As String, ByVal docFolderPhysical As String) As String
        Dim letter As LetterText = ReadLetterText(conn, permohonanID, {"SuratPemeriksaan1", "SuratPemeriksaan2"}, "TarikhSuratPemeriksaan")
        If letter Is Nothing Then Return Nothing

        Dim rptPath As String = FindReportTemplate("~/lesen/report/pemeriksaan/", SP_REPORT_NAMES, jenisLesenID, "sp_perniagaan", "mpk_suratpemeriksaan", "sp_perniagaan")

        Dim sqlData As String
        If jenisLesenID = 4 Then
            sqlData = "SELECT b.UlasanDesc, f.*, a.IsBatal, a.Rujukan, a.RujukanInspektorat, a.TarikhPemeriksaan, a.TarikhSuratPemeriksaan, a.SuratPemeriksaan1, a.SuratPemeriksaan2, " &
                      "c.Pemohon_Name, c.Pemohon_Address, c.Pemohon_ICNo, c.Pemohon_MobileNo, c.Pemohon_TelNo, d.Users_Fullname, d.Users_Signature " &
                      "FROM LESEN_Permohonan a " &
                      "LEFT JOIN LESEN_PermohonanPembetulan f ON a.Permohonan_ID = f.Permohonan_ID " &
                      "LEFT JOIN LESEN_PenjajaUlasan b ON b.PermohonanID = a.Permohonan_ID " &
                      "LEFT JOIN LESEN_Pemohon c ON a.Permohonan_PemohonID = c.Pemohon_ID " &
                      "LEFT JOIN TBL_USERS d ON a.TandatanganPemeriksaanId = d.Users_Id " &
                      "WHERE a.Permohonan_ID = @PermohonanID"
        Else
            sqlData = "SELECT b.KadarBayaran_Desc, b.KadarBayaran_Amount, f.*, a.IsBatal, a.Rujukan, a.RujukanInspektorat, a.TarikhPemeriksaan, a.TarikhSuratPemeriksaan, a.SuratPemeriksaan1, a.SuratPemeriksaan2, " &
                      "c.Pemohon_Name, c.Pemohon_Address, c.Pemohon_ICNo, c.Pemohon_MobileNo, c.Pemohon_TelNo, d.Users_Fullname, d.Users_Signature, e.name AS AnjingJenisPremisDesc " &
                      "FROM LESEN_Permohonan a " &
                      "LEFT JOIN LESEN_PermohonanPembetulan f ON a.Permohonan_ID = f.Permohonan_ID " &
                      "LEFT JOIN LESEN_KadarBayaran b ON b.KadarBayaran_PermohonanID = a.Permohonan_ID AND b.KadarBayaran_PermohonanAgensiID = 3 " &
                      "LEFT JOIN LESEN_Pemohon c ON a.Permohonan_PemohonID = c.Pemohon_ID " &
                      "LEFT JOIN TBL_USERS d ON a.TandatanganPemeriksaanId = d.Users_Id " &
                      "LEFT JOIN TBL_LOOKUPS e ON e.id = a.AnjingJenisPremis " &
                      "WHERE a.Permohonan_ID = @PermohonanID"
        End If

        Return ExportAndAttachPdf(conn, permohonanID, rptPath, sqlData, letter, rujukan, docFolderPhysical,
                                  "LaporanPemeriksaan", "LAPORAN PEMERIKSAAN", "SP", "IsSuratPemeriksaanFail")
    End Function

    Private Shared Function GenerateSuratKelulusanPdf(ByVal conn As SqlConnection, ByVal permohonanID As Integer, ByVal jenisLesenID As Integer, ByVal rujukan As String, ByVal docFolderPhysical As String) As String
        Dim letter As LetterText = ReadLetterText(conn, permohonanID, {"SuratKelulusan1", "SuratKelulusan2", "SuratKelulusan3", "SuratKelulusan4"}, "TarikhSuratKelulusan")
        If letter Is Nothing Then Return Nothing

        Dim rptPath As String = FindReportTemplate("~/lesen/report/kelulusan/", SK_REPORT_NAMES, jenisLesenID, "sk_perniagaanb", "sk_perniagaanb")

        Dim sqlData As String = "SELECT a.KadarBayaran_Desc, a.KadarBayaran_Amount, b.*, c.Pemohon_Name, c.Pemohon_Address, c.Pemohon_ICNo, c.Pemohon_MobileNo, c.Pemohon_TelNo, " &
                                "d.Users_Fullname, d.Users_Signature, e.name AS AnjingJenisPremisDesc " &
                                "FROM LESEN_Permohonan b " &
                                "LEFT JOIN LESEN_KadarBayaran a ON a.KadarBayaran_PermohonanID = b.Permohonan_ID AND a.IsSelect = 1 " &
                                "LEFT JOIN LESEN_Pemohon c ON b.Permohonan_PemohonID = c.Pemohon_ID " &
                                "LEFT JOIN TBL_USERS d ON b.TandatanganKelulusanId = d.Users_Id " &
                                "LEFT JOIN TBL_LOOKUPS e ON e.id = b.AnjingJenisPremis " &
                                "WHERE b.Permohonan_ID = @PermohonanID ORDER BY a.SeqNo ASC"

        Return ExportAndAttachPdf(conn, permohonanID, rptPath, sqlData, letter, rujukan, docFolderPhysical,
                                  "SuratKelulusan", "SURAT KELULUSAN", "SK", "IsSuratKelulusanFail")
    End Function

    Private Shared Function GenerateSuratPembatalanPdf(ByVal conn As SqlConnection, ByVal permohonanID As Integer, ByVal jenisLesenID As Integer, ByVal rujukan As String, ByVal docFolderPhysical As String) As String
        ' Old pembatalan pages print TarikhSuratKelulusan as the letter date
        Dim letter As LetterText = ReadLetterText(conn, permohonanID, {"SuratPembatalan1", "SuratPembatalan2"}, "TarikhSuratKelulusan")
        If letter Is Nothing Then Return Nothing

        Dim rptPath As String = FindReportTemplate("~/lesen/report/kelulusan/", SB_REPORT_NAMES, jenisLesenID, "sb_perniagaan", "sb_perniagaan")

        Dim sqlData As String = "SELECT b.*, c.Pemohon_Name, c.Pemohon_Address, c.Pemohon_ICNo, c.Pemohon_MobileNo, c.Pemohon_TelNo, " &
                                "d.Users_Fullname, d.Users_Signature, e.name AS AnjingJenisPremisDesc " &
                                "FROM LESEN_Permohonan b " &
                                "LEFT JOIN LESEN_Pemohon c ON b.Permohonan_PemohonID = c.Pemohon_ID " &
                                "LEFT JOIN TBL_USERS d ON b.TandatanganKelulusanId = d.Users_Id " &
                                "LEFT JOIN TBL_LOOKUPS e ON e.id = b.AnjingJenisPremis " &
                                "WHERE b.Permohonan_ID = @PermohonanID"

        Return ExportAndAttachPdf(conn, permohonanID, rptPath, sqlData, letter, rujukan, docFolderPhysical,
                                  "SuratPembatalan", "SURAT PEMBATALAN", "SB", "IsSuratPembatalanFail")
    End Function

    ''' <summary>Reads the letter text columns. Returns Nothing when all of them are empty.</summary>
    Private Shared Function ReadLetterText(ByVal conn As SqlConnection, ByVal permohonanID As Integer, ByVal textColumns As String(), ByVal dateColumn As String) As LetterText
        ' Column names are constants from this class (never user input)
        Dim selectCols As String = String.Join(", ", textColumns.Select(Function(c) "ISNULL(CAST(" & c & " AS NVARCHAR(MAX)), '') AS [" & c & "]"))
        Dim sql As String = "SELECT " & selectCols & ", ISNULL(CONVERT(VARCHAR(20), " & dateColumn & ", 103), '') AS TarikhSurat " &
                            "FROM LESEN_Permohonan WHERE Permohonan_ID = @PermohonanID"

        Dim letter As New LetterText With {.Sections = New String(textColumns.Length - 1) {}, .TarikhSurat = ""}
        Using cmd As New SqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@PermohonanID", permohonanID)
            Using rdr As SqlDataReader = cmd.ExecuteReader()
                If Not rdr.Read() Then Return Nothing
                For i As Integer = 0 To textColumns.Length - 1
                    letter.Sections(i) = Convert.ToString(rdr(textColumns(i))).Trim()
                Next
                letter.TarikhSurat = Convert.ToString(rdr("TarikhSurat")).Trim()
            End Using
        End Using

        If letter.Sections.All(Function(s) s = "") Then Return Nothing
        Return letter
    End Function

    ''' <summary>
    ''' Finds the .rpt file for this JenisLesen_ID. Tries the mapped name, the same name with a space before
    ''' ".rpt" (some files on disk are named like that), then the fallback names in order.
    ''' Returns the first existing file, or the mapped path when none exist (the native PDF writer is then used).
    ''' </summary>
    Private Shared Function FindReportTemplate(ByVal folder As String, ByVal reportNames As String(), ByVal jenisLesenID As Integer, ByVal defaultName As String, ByVal ParamArray fallbackNames As String()) As String
        Dim baseName As String = defaultName
        If jenisLesenID >= 1 AndAlso jenisLesenID < reportNames.Length AndAlso reportNames(jenisLesenID) <> "" Then
            baseName = reportNames(jenisLesenID)
        End If

        Dim candidates As New List(Of String) From {baseName & ".rpt", baseName & " .rpt"}
        candidates.AddRange(fallbackNames.Select(Function(n) n & ".rpt"))

        For Each fileName As String In candidates
            Dim physicalPath As String = HttpContext.Current.Server.MapPath(folder & fileName)
            If File.Exists(physicalPath) Then Return physicalPath
        Next
        Return HttpContext.Current.Server.MapPath(folder & baseName & ".rpt")
    End Function

    ''' <summary>
    ''' Exports the letter to ~/doc/{guid}_{filePrefix}_{id}.pdf, saves it in LESEN_PermohonanFail and sets the flag column.
    ''' Returns the browser URL of the PDF.
    ''' </summary>
    Private Shared Function ExportAndAttachPdf(ByVal conn As SqlConnection, ByVal permohonanID As Integer, ByVal rptPhysicalPath As String, ByVal sqlData As String,
                                               ByVal letter As LetterText, ByVal rujukan As String, ByVal docFolderPhysical As String,
                                               ByVal filePrefix As String, ByVal docTitle As String, ByVal jenisLampiran As String, ByVal flagColumnName As String) As String
        Dim fileName As String = filePrefix & "_" & permohonanID & ".pdf"
        Dim uniqueFileName As String = Guid.NewGuid().ToString() & "_" & fileName
        Dim fullPdfPath As String = Path.Combine(docFolderPhysical, uniqueFileName)
        Dim virtualPdfPath As String = "~/doc/" & uniqueFileName

        ExportReportOrFallbackToPdf(conn, permohonanID, rptPhysicalPath, sqlData, fullPdfPath, docTitle, rujukan, letter.TarikhSurat, letter.Sections)
        SavePermohonanFailAndFlag(conn, permohonanID, fileName, virtualPdfPath, jenisLampiran, flagColumnName)
        Return ResolveVirtualUrl(virtualPdfPath)
    End Function

    Private Shared Sub ExportReportOrFallbackToPdf(ByVal conn As SqlConnection, ByVal permohonanID As Integer, ByVal rptPhysicalPath As String, ByVal sqlQuery As String, ByVal outputPdfPath As String, ByVal docTitle As String, ByVal rujukan As String, ByVal tarikhSurat As String, ByVal sections As String())
        Dim dt As New DataTable()
        Using da As New SqlDataAdapter(sqlQuery, conn)
            da.SelectCommand.Parameters.AddWithValue("@PermohonanID", permohonanID)
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
            ExecuteForPermohonan(conn, sqlFlag, permohonanID)
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
