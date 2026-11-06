Imports System.Collections.Generic
Imports System.Data.SqlClient
Imports System.IO
Imports System.Linq
Imports System.Web.Services

' Selaraskan fail upload sistem baru dengan DB sasaran (sistem lama).
'  - DB sasaran : webcon_ConnectionStr - sumber kebenaran senarai fail
'  - Sumber fail : appSetting "OldFileRoot" (folder akar sistem lama) - HANYA DIBACA, tidak pernah diubah
'  - Destinasi  : folder akar web app ini (Server.MapPath("~/")) - sistem baru
'  1) Salin   : fail yang dirujuk DB sasaran tetapi belum ada di sistem baru (fail sedia ada dilangkau)
'  2) Padam   : fail di sistem baru yang tidak dirujuk DB sasaran (fail yatim / ujian)
Partial Class lesen_migratefile
    Inherits System.Web.UI.Page

    Private Const SESS_CANRUN As String = "MigFile_CanRun"

    ' Hanya folder ini dibenarkan (laluan dalam DB di luar senarai ini diabaikan)
    Private Shared ReadOnly FolderDibenarkan As String() = {"doc", "uploads"}

    ' Folder sistem baru yang diimbas untuk fail yatim (fail terus di dalam folder sahaja, bukan sub-folder)
    Private Shared ReadOnly FolderYatim As String() = {"doc", "Uploads\Banting", "Uploads\Sepanduk"}

    Private Shared ReadOnly Sumber As String()() = {
        New String() {"LESEN_PermohonanFail", "PermohonanFail_FilePath"},
        New String() {"LESEN_UlasanFail", "UlasanFail_FilePath"},
        New String() {"LESEN_UlasanFailBatal", "UlasanFail_FilePath"},
        New String() {"LESEN_BantingImej", "FilePath"},
        New String() {"LESEN_SepandukSemakanIK_Lampiran", "Lampiran_FilePath"}
    }

    Protected OldRoot As String = ""
    Protected NewRoot As String = ""
    Protected DbSasaran As String = ""

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        OldRoot = Convert.ToString(ConfigurationManager.AppSettings("OldFileRoot"))
        NewRoot = Server.MapPath("~/")
        Try
            DbSasaran = New SqlConnectionStringBuilder(Conn()).InitialCatalog
        Catch
        End Try
    End Sub

    Protected Sub Page_PreRenderComplete(sender As Object, e As EventArgs) Handles Me.PreRenderComplete
        Dim frmview() As Object = {}
        Dim lbutton() As Object = {}
        Dim ctlDeny() As Object = {}
        Session(SESS_CANRUN) = GlobalClass.CheckPageWrite("Write", frmview, lbutton, ctlDeny)
    End Sub

    ' ------------------------------------------------------------ helper
    Private Shared Function Conn() As String
        Return ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString
    End Function

    Private Shared Function BolehGuna() As Boolean
        Dim s = HttpContext.Current.Session
        Return s IsNot Nothing AndAlso CInt(If(s("sessionUsersId"), 0)) > 0 AndAlso CBool(If(s(SESS_CANRUN), False))
    End Function

    ' "~/doc/abc.pdf" atau "/Uploads/Sepanduk/x.pdf" -> "doc\abc.pdf"; Nothing jika tidak sah / di luar folder dibenarkan
    Private Shared Function Relatif(raw As String) As String
        If String.IsNullOrWhiteSpace(raw) Then Return Nothing
        Dim p = raw.Trim().Replace("\", "/")
        If p.StartsWith("~") Then p = p.Substring(1)
        p = p.TrimStart("/"c)
        If p.Contains("..") OrElse p.Contains(":") Then Return Nothing
        Dim i = p.IndexOf("/"c)
        If i <= 0 Then Return Nothing
        If Array.IndexOf(FolderDibenarkan, p.Substring(0, i).ToLowerInvariant()) < 0 Then Return Nothing
        Return p.Replace("/", "\")
    End Function

    ' Gabung akar + relatif dan pastikan hasilnya kekal di dalam akar
    Private Shared Function Gabung(root As String, rel As String) As String
        Dim rootFull = Path.GetFullPath(root).TrimEnd("\"c) & "\"
        Dim full = Path.GetFullPath(Path.Combine(rootFull, rel))
        If Not full.StartsWith(rootFull, StringComparison.OrdinalIgnoreCase) Then Return Nothing
        Return full
    End Function

    Private Shared Function OldRootConfigured() As String
        Return Convert.ToString(ConfigurationManager.AppSettings("OldFileRoot")).Trim()
    End Function

    ' Folder lama tidak boleh sama dengan / bertindih dengan folder sistem baru - sistem lama hanya dibaca
    Private Shared Function FolderSelamat(oldRoot As String, newRoot As String) As Boolean
        Dim a = Path.GetFullPath(oldRoot).TrimEnd("\"c) & "\"
        Dim b = Path.GetFullPath(newRoot).TrimEnd("\"c) & "\"
        Return Not a.StartsWith(b, StringComparison.OrdinalIgnoreCase) AndAlso Not b.StartsWith(a, StringComparison.OrdinalIgnoreCase)
    End Function

    ' Semua laluan fail (relatif) yang dirujuk oleh DB sasaran
    Private Shared Function MuatRujukan(ByRef dbName As String, tables As List(Of String), ByRef diabaikan As Integer) As HashSet(Of String)
        Dim paths As New HashSet(Of String)(StringComparer.OrdinalIgnoreCase)
        Using c As New SqlConnection(Conn())
            c.Open()
            dbName = c.Database
            For Each s In Sumber
                Dim tbl = s(0), col = s(1)
                Using chk As New SqlCommand("SELECT CASE WHEN COL_LENGTH(@t, @c) IS NULL THEN 0 ELSE 1 END", c)
                    chk.Parameters.AddWithValue("@t", "dbo." & tbl)
                    chk.Parameters.AddWithValue("@c", col)
                    If CInt(chk.ExecuteScalar()) = 0 Then
                        If tables IsNot Nothing Then tables.Add(tbl & " (tiada)")
                        Continue For
                    End If
                End Using
                Dim n As Integer = 0
                Using cmd As New SqlCommand("SELECT DISTINCT [" & col & "] FROM dbo.[" & tbl & "] WHERE [" & col & "] IS NOT NULL", c)
                    Using rd = cmd.ExecuteReader()
                        While rd.Read()
                            Dim rel = Relatif(rd.GetString(0))
                            If rel Is Nothing Then
                                diabaikan += 1
                            Else
                                paths.Add(rel)
                                n += 1
                            End If
                        End While
                    End Using
                End Using
                If tables IsNot Nothing Then tables.Add(tbl & " (" & n & ")")
            Next
        End Using
        Return paths
    End Function

    ' ------------------------------------------------------------ 1) analisis salin
    Public Class AnalisisResult
        Public Ok As Boolean
        Public Message As String
        Public Db As String
        Public Total, ToCopy, Exists, NoSource, Ignored As Integer
        Public Bytes As Long
        Public Copy As List(Of String)
        Public Missing As List(Of String)
        Public Tables As List(Of String)
    End Class

    <WebMethod(EnableSession:=True)>
    Public Shared Function Analisis() As AnalisisResult
        Dim r As New AnalisisResult With {.Copy = New List(Of String)(), .Missing = New List(Of String)(), .Tables = New List(Of String)()}
        If Not BolehGuna() Then r.Message = "Tiada kebenaran." : Return r
        Dim oldRoot = OldRootConfigured()
        If oldRoot = "" OrElse Not Directory.Exists(oldRoot) Then
            r.Message = "appSetting 'OldFileRoot' belum ditetapkan atau folder tidak wujud: " & oldRoot
            Return r
        End If
        Dim newRoot = HttpContext.Current.Server.MapPath("~/")
        If Not FolderSelamat(oldRoot, newRoot) Then r.Message = "OldFileRoot tidak boleh sama dengan atau berada dalam folder sistem baru." : Return r

        Try
            Dim paths = MuatRujukan(r.Db, r.Tables, r.Ignored)
            r.Total = paths.Count
            For Each rel In paths
                Dim dst = Gabung(newRoot, rel), src = Gabung(oldRoot, rel)
                If dst Is Nothing OrElse src Is Nothing Then
                    r.Ignored += 1
                ElseIf File.Exists(dst) Then
                    r.Exists += 1
                ElseIf File.Exists(src) Then
                    r.ToCopy += 1
                    r.Bytes += New FileInfo(src).Length
                    r.Copy.Add(rel)
                Else
                    r.NoSource += 1
                    r.Missing.Add(rel)
                End If
            Next
            r.Ok = True
            r.Message = "OK"
        Catch ex As Exception
            r.Ok = False : r.Message = ex.Message
        End Try
        Return r
    End Function

    ' ------------------------------------------------------------ salin (kelompok)
    Public Class CopyResult
        Public Ok As Boolean
        Public Message As String
        Public Copied, Skipped, Failed As Integer     ' Copied = bilangan disalin / dipadam
        Public Errors As List(Of String)
    End Class

    <WebMethod(EnableSession:=True)>
    Public Shared Function SalinKelompok(items As List(Of String)) As CopyResult
        Dim r As New CopyResult With {.Errors = New List(Of String)()}
        If Not BolehGuna() Then r.Message = "Tiada kebenaran." : Return r
        Dim oldRoot = OldRootConfigured()
        If oldRoot = "" OrElse Not Directory.Exists(oldRoot) Then r.Message = "OldFileRoot tidak sah." : Return r
        If items Is Nothing OrElse items.Count > 200 Then r.Message = "Kelompok tidak sah." : Return r
        Dim newRoot = HttpContext.Current.Server.MapPath("~/")
        If Not FolderSelamat(oldRoot, newRoot) Then r.Message = "OldFileRoot tidak sah." : Return r

        For Each raw In items
            Try
                Dim rel = Relatif(raw)
                If rel Is Nothing Then Throw New Exception("laluan tidak sah")
                Dim src = Gabung(oldRoot, rel), dst = Gabung(newRoot, rel)
                If src Is Nothing OrElse dst Is Nothing Then Throw New Exception("laluan di luar akar")
                If File.Exists(dst) Then r.Skipped += 1 : Continue For
                If Not File.Exists(src) Then Throw New Exception("fail sumber tiada")
                Directory.CreateDirectory(Path.GetDirectoryName(dst))
                File.Copy(src, dst, False)     ' sistem lama hanya dibaca
                r.Copied += 1
            Catch ex As Exception
                r.Failed += 1
                r.Errors.Add(raw & " : " & ex.Message)
            End Try
        Next
        r.Ok = True
        Return r
    End Function

    ' ------------------------------------------------------------ 2) fail yatim di sistem baru
    Public Class YatimResult
        Public Ok As Boolean
        Public Message As String
        Public Db As String
        Public Rujukan, Total As Integer
        Public Bytes As Long
        Public Files As List(Of String)
        Public Info As List(Of String)    ' "path|saiz|tarikh" untuk paparan
    End Class

    <WebMethod(EnableSession:=True)>
    Public Shared Function AnalisisYatim() As YatimResult
        Dim r As New YatimResult With {.Files = New List(Of String)(), .Info = New List(Of String)()}
        If Not BolehGuna() Then r.Message = "Tiada kebenaran." : Return r
        Try
            Dim abaikan As Integer
            Dim ref = MuatRujukan(r.Db, Nothing, abaikan)
            r.Rujukan = ref.Count
            ' keselamatan: DB salah / kosong akan menjadikan SEMUA fail yatim
            If ref.Count = 0 Then r.Message = "DB '" & r.Db & "' tidak merujuk sebarang fail. Semak webcon_ConnectionStr - pemadaman dibatalkan." : Return r

            Dim newRoot = HttpContext.Current.Server.MapPath("~/")
            For Each f In FolderYatim
                Dim dir = Gabung(newRoot, f)
                If dir Is Nothing OrElse Not Directory.Exists(dir) Then Continue For
                For Each full In Directory.GetFiles(dir)
                    Dim fi As New FileInfo(full)
                    If fi.Name.StartsWith(".") OrElse fi.Name.Equals("web.config", StringComparison.OrdinalIgnoreCase) Then Continue For
                    Dim rel = f & "\" & fi.Name
                    r.Total += 1
                    If Not ref.Contains(rel) Then
                        r.Files.Add(rel)
                        r.Bytes += fi.Length
                        r.Info.Add(rel & "|" & fi.Length & "|" & fi.LastWriteTime.ToString("yyyy-MM-dd HH:mm"))
                    End If
                Next
            Next
            r.Ok = True
            r.Message = "OK"
        Catch ex As Exception
            r.Ok = False : r.Message = ex.Message
        End Try
        Return r
    End Function

    <WebMethod(EnableSession:=True)>
    Public Shared Function PadamYatim(items As List(Of String)) As CopyResult
        Dim r As New CopyResult With {.Errors = New List(Of String)()}
        If Not BolehGuna() Then r.Message = "Tiada kebenaran." : Return r
        If items Is Nothing OrElse items.Count > 200 Then r.Message = "Kelompok tidak sah." : Return r
        Try
            Dim abaikan As Integer, db As String = ""
            Dim ref = MuatRujukan(db, Nothing, abaikan)
            If ref.Count = 0 Then r.Message = "DB tidak merujuk sebarang fail - dibatalkan." : Return r
            Dim newRoot = HttpContext.Current.Server.MapPath("~/")

            For Each raw In items
                Try
                    Dim rel = Relatif(raw)
                    If rel Is Nothing Then Throw New Exception("laluan tidak sah")
                    ' hanya fail terus dalam folder yang dibenarkan
                    Dim dirRel = Path.GetDirectoryName(rel)
                    If Not FolderYatim.Contains(dirRel, StringComparer.OrdinalIgnoreCase) Then Throw New Exception("folder tidak dibenarkan")
                    If ref.Contains(rel) Then r.Skipped += 1 : Continue For      ' dirujuk DB sasaran - jangan padam
                    Dim full = Gabung(newRoot, rel)
                    If full Is Nothing Then Throw New Exception("laluan di luar akar")
                    If Not File.Exists(full) Then r.Skipped += 1 : Continue For
                    File.Delete(full)
                    r.Copied += 1
                Catch ex As Exception
                    r.Failed += 1
                    r.Errors.Add(raw & " : " & ex.Message)
                End Try
            Next
            r.Ok = True
        Catch ex As Exception
            r.Ok = False : r.Message = ex.Message
        End Try
        Return r
    End Function

End Class
