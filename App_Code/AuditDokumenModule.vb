Imports System.Data.SqlClient
Imports System.IO
Imports System.Linq
Imports System.Web
Imports System.Web.SessionState

''' <summary>
''' Audit muat naik dan muat turun dokumen (keperluan audit item 6).
'''
''' Muat turun : permintaan GET/HEAD ke ~/doc/ atau ~/Uploads/ dilayan oleh FailDokumenHandler
'''              (supaya sesi pengguna boleh dibaca) dan direkodkan sebagai "Muat Turun".
''' Muat naik  : setiap postback yang membawa fail direkodkan selepas permintaan selesai sebagai "Muat Naik".
''' No. Rujukan dicari daripada jadual yang menyimpan path fail bersama Permohonan_ID
''' (LESEN_PermohonanFail, LESEN_UlasanFail[Batal], LESEN_BantingImej).
'''
''' Pendaftaran (web.config, bahagian system.webServer):
'''   &lt;modules runAllManagedModulesForAllRequests="true"&gt;
'''     &lt;add name="AuditDokumen" type="AuditDokumenModule" /&gt;
'''   &lt;/modules&gt;
''' </summary>
Public Class AuditDokumenModule
    Implements IHttpModule

    ' Folder dokumen yang dipantau (relatif kepada akar aplikasi)
    Private Shared ReadOnly FolderDipantau As String() = {"doc/", "uploads/"}

    ' Jenis fail yang dilayan oleh handler; lain-lain dibiarkan kepada IIS seperti biasa
    Private Shared ReadOnly JenisDibenarkan As String() = {".pdf", ".jpg", ".jpeg", ".png", ".gif", ".webp", ".bmp", ".tif", ".tiff",
                                                          ".doc", ".docx", ".xls", ".xlsx", ".ppt", ".pptx", ".txt", ".csv", ".zip", ".rar"}

    Private Const ITEM_USER_ID As String = "AuditDokumen.UserId"
    Private Const ITEM_USER_NAME As String = "AuditDokumen.UserName"

    Public Sub Init(ByVal app As HttpApplication) Implements IHttpModule.Init
        AddHandler app.PostResolveRequestCache, AddressOf OnPostResolveRequestCache
        AddHandler app.PostAcquireRequestState, AddressOf OnPostAcquireRequestState
        AddHandler app.EndRequest, AddressOf OnEndRequest
    End Sub

    Public Sub Dispose() Implements IHttpModule.Dispose
    End Sub

    '----- Muat turun -----
    Private Sub OnPostResolveRequestCache(ByVal sender As Object, ByVal e As EventArgs)
        Dim ctx As HttpContext = CType(sender, HttpApplication).Context
        Try
            Dim req As HttpRequest = ctx.Request
            If req.HttpMethod <> "GET" AndAlso req.HttpMethod <> "HEAD" Then Return
            Dim rel As String = PathRelatif(req)
            If rel = "" OrElse Not FolderDipantau.Any(Function(f) rel.StartsWith(f, StringComparison.OrdinalIgnoreCase)) Then Return
            If Not JenisDibenarkan.Contains(Path.GetExtension(rel).ToLowerInvariant()) Then Return
            If Not File.Exists(req.PhysicalPath) Then Return
            ctx.RemapHandler(New FailDokumenHandler())
        Catch ex As Exception
            ' jika gagal, biarkan IIS melayan fail seperti biasa
        End Try
    End Sub

    '----- Muat naik: simpan pengguna semasa (sesi hilang pada EndRequest) -----
    Private Sub OnPostAcquireRequestState(ByVal sender As Object, ByVal e As EventArgs)
        Dim ctx As HttpContext = CType(sender, HttpApplication).Context
        Try
            If ctx.Session Is Nothing Then Return
            ctx.Items(ITEM_USER_ID) = ctx.Session.Item("sessionUsersId")
            ctx.Items(ITEM_USER_NAME) = ctx.Session.Item("sessionUserName")
        Catch ex As Exception
        End Try
    End Sub

    Private Sub OnEndRequest(ByVal sender As Object, ByVal e As EventArgs)
        Dim ctx As HttpContext = CType(sender, HttpApplication).Context
        Try
            Dim req As HttpRequest = ctx.Request
            If req.HttpMethod <> "POST" OrElse ctx.Response.StatusCode >= 400 Then Return
            If req.ContentType Is Nothing OrElse Not req.ContentType.StartsWith("multipart/form-data", StringComparison.OrdinalIgnoreCase) Then Return
            If req.Files.Count = 0 Then Return

            Dim userId As Integer = 0
            Integer.TryParse(Convert.ToString(ctx.Items(ITEM_USER_ID)), userId)
            Dim userName As String = Convert.ToString(ctx.Items(ITEM_USER_NAME))
            Dim page As String = req.Path

            For i As Integer = 0 To req.Files.Count - 1
                Dim f As HttpPostedFile = req.Files(i)
                If f Is Nothing OrElse f.ContentLength = 0 OrElse String.IsNullOrEmpty(f.FileName) Then Continue For
                Dim nama As String = Path.GetFileName(f.FileName)
                Dim ruj As RujukanFail = CariRujukanIkutNama(nama)
                Dim detail As String = "Fail: " & nama & " (" & SaizTeks(f.ContentLength) & ", " & f.ContentType & ") | Page: " & page &
                                       If(ruj.Disimpan, " | Disimpan: " & ruj.PathFail, " | Rekod fail tidak ditemui (mungkin ditolak oleh semakan page)") &
                                       If(ruj.Sumber = "", "", " | " & ruj.Sumber)
                GlobalClass.auditTrailUser(userId, userName, "Dokumen", "Muat naik: " & nama, "Muat Naik", ruj.Rujukan, detail)
            Next
        Catch ex As Exception
        End Try
    End Sub

    Private Shared Function PathRelatif(ByVal req As HttpRequest) As String
        Dim p As String = req.AppRelativeCurrentExecutionFilePath   ' cth. "~/doc/abc.pdf"
        If String.IsNullOrEmpty(p) Then Return ""
        Return p.TrimStart("~"c).TrimStart("/"c)
    End Function

    Friend Shared Function SaizTeks(ByVal bait As Long) As String
        If bait >= 1048576 Then Return (bait / 1048576.0).ToString("0.0") & " MB"
        Return Math.Max(1, CInt(Math.Ceiling(bait / 1024.0))) & " KB"
    End Function

    '----- Cari rujukan permohonan bagi satu fail -----
    Friend Class RujukanFail
        Public Rujukan As String = ""
        Public Sumber As String = ""
        Public PathFail As String = ""
        Public Disimpan As Boolean = False
    End Class

    ' Jadual yang menyimpan path fail, dengan kolum path dan kolum Permohonan_ID
    Private Shared ReadOnly SumberFail As String()() = {
        New String() {"LESEN_PermohonanFail", "PermohonanFail_FilePath", "PermohonanFail_PermohonanID", "Lampiran permohonan"},
        New String() {"LESEN_UlasanFail", "UlasanFail_FilePath", "UlasanFail_PermohonanID", "Lampiran ulasan"},
        New String() {"LESEN_UlasanFailBatal", "UlasanFail_FilePath", "UlasanFail_PermohonanID", "Lampiran ulasan pembatalan"},
        New String() {"LESEN_BantingImej", "FilePath", "Permohonan_ID", "Gambar sepanduk / bunting"}
    }

    ''' <summary>Rujukan bagi path tepat (cth. "~/doc/xxx.pdf"), untuk muat turun.</summary>
    Friend Shared Function CariRujukanIkutPath(ByVal virtualPath As String) As RujukanFail
        Return Cari("= @v", virtualPath)
    End Function

    ''' <summary>Rujukan bagi fail yang baru dimuat naik: path terkini yang berakhir dengan nama fail asal.</summary>
    Private Shared Function CariRujukanIkutNama(ByVal nama As String) As RujukanFail
        Dim esc As String = nama.Replace("[", "[[]").Replace("%", "[%]").Replace("_", "[_]")
        Return Cari("LIKE '%' + @v", esc)
    End Function

    Private Shared Function Cari(ByVal syarat As String, ByVal nilai As String) As RujukanFail
        Dim hasil As New RujukanFail()
        Try
            Dim bahagian As New List(Of String)()
            For Each s In SumberFail
                bahagian.Add("SELECT TOP 1 '" & s(3) & "' AS Sumber, CAST(f.[" & s(1) & "] AS nvarchar(400)) AS PathFail, p.Rujukan, f.[" & s(2) & "] AS Pid " &
                             "FROM [" & s(0) & "] f LEFT JOIN LESEN_Permohonan p ON p.Permohonan_ID = f.[" & s(2) & "] " &
                             "WHERE f.[" & s(1) & "] " & syarat & " ORDER BY f.[" & s(2) & "] DESC")
            Next
            Dim sql As String = "SELECT TOP 1 * FROM (" & String.Join(" UNION ALL ", bahagian.Select(Function(b) "SELECT * FROM (" & b & ") x")) & ") t"
            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@v", nilai)
                    conn.Open()
                    Using rdr As SqlDataReader = cmd.ExecuteReader()
                        If rdr.Read() Then
                            hasil.Disimpan = True
                            hasil.Sumber = Convert.ToString(rdr("Sumber"))
                            hasil.PathFail = Convert.ToString(rdr("PathFail"))
                            hasil.Rujukan = Convert.ToString(rdr("Rujukan")).Trim()
                            If hasil.Rujukan = "" AndAlso Not IsDBNull(rdr("Pid")) Then hasil.Rujukan = "ID " & Convert.ToString(rdr("Pid"))
                        End If
                    End Using
                End Using
            End Using
        Catch ex As Exception
        End Try
        Return hasil
    End Function

End Class

''' <summary>
''' Melayan fail dokumen (~/doc, ~/Uploads) dengan sesi dibaca, supaya muat turun boleh direkodkan mengikut pengguna.
''' Capaian berulang pada fail yang sama oleh pengguna yang sama dalam 10 minit direkod sekali sahaja.
''' </summary>
Public Class FailDokumenHandler
    Implements IHttpHandler, IReadOnlySessionState

    Public ReadOnly Property IsReusable As Boolean Implements IHttpHandler.IsReusable
        Get
            Return True
        End Get
    End Property

    Public Sub ProcessRequest(ByVal ctx As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim req As HttpRequest = ctx.Request
        Dim res As HttpResponse = ctx.Response
        Dim fizikal As String = req.PhysicalPath
        Dim akar As String = HttpRuntime.AppDomainAppPath

        ' Hanya fail sebenar di dalam folder aplikasi
        If Not fizikal.StartsWith(akar, StringComparison.OrdinalIgnoreCase) OrElse Not File.Exists(fizikal) Then
            res.StatusCode = 404
            Return
        End If

        Dim info As New FileInfo(fizikal)
        Dim ubah As DateTime = info.LastWriteTimeUtc
        ubah = New DateTime(ubah.Year, ubah.Month, ubah.Day, ubah.Hour, ubah.Minute, ubah.Second, DateTimeKind.Utc)

        ' Cache pelayar: jika fail tidak berubah, balas 304 (tiada log kerana kandungan tidak dihantar)
        Dim sejak As DateTime
        Dim hdr As String = req.Headers("If-Modified-Since")
        If Not String.IsNullOrEmpty(hdr) AndAlso DateTime.TryParse(hdr, System.Globalization.CultureInfo.InvariantCulture,
                System.Globalization.DateTimeStyles.AdjustToUniversal Or System.Globalization.DateTimeStyles.AssumeUniversal, sejak) AndAlso ubah <= sejak Then
            res.StatusCode = 304
            Return
        End If

        res.ContentType = MimeMapping.GetMimeMapping(fizikal)
        res.Cache.SetCacheability(HttpCacheability.Private)
        res.Cache.SetLastModified(ubah)
        res.AddHeader("Content-Length", info.Length.ToString())
        If req.HttpMethod = "HEAD" Then Return
        res.TransmitFile(fizikal)

        LogMuatTurun(ctx, info)
    End Sub

    Private Shared Sub LogMuatTurun(ByVal ctx As HttpContext, ByVal info As FileInfo)
        Try
            Dim userId As Integer = 0
            Dim userName As String = ""
            If ctx.Session IsNot Nothing Then
                Integer.TryParse(Convert.ToString(ctx.Session.Item("sessionUsersId")), userId)
                userName = Convert.ToString(ctx.Session.Item("sessionUserName"))
            End If

            Dim virt As String = ctx.Request.AppRelativeCurrentExecutionFilePath   ' "~/doc/xxx.pdf"
            Dim kunci As String = "AuditMuatTurun|" & If(userId > 0, userId.ToString(), ctx.Request.UserHostAddress) & "|" & virt.ToLowerInvariant()
            If HttpRuntime.Cache(kunci) IsNot Nothing Then Return
            HttpRuntime.Cache.Insert(kunci, True, Nothing, DateTime.UtcNow.AddMinutes(10), System.Web.Caching.Cache.NoSlidingExpiration)

            Dim ruj = AuditDokumenModule.CariRujukanIkutPath(virt)
            Dim dari As String = If(ctx.Request.UrlReferrer IsNot Nothing, ctx.Request.UrlReferrer.AbsolutePath, "")
            Dim detail As String = "Fail: " & info.Name & " (" & AuditDokumenModule.SaizTeks(info.Length) & ")" &
                                   If(ruj.Sumber = "", "", " | " & ruj.Sumber) &
                                   If(dari = "", "", " | Dari page: " & dari) &
                                   If(userId > 0, "", " | Pengguna awam / tanpa sesi")
            GlobalClass.auditTrailUser(userId, userName, "Dokumen", "Muat turun: " & info.Name, "Muat Turun", ruj.Rujukan, detail)
        Catch ex As Exception
        End Try
    End Sub

End Class
