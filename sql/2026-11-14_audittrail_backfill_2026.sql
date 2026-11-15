-- ============================================================================
-- Audit Trail - jana log sejarah tahun 2026 daripada rekod sedia ada
--
-- Log aliran kerja dan muat naik dokumen (fasa 2 & 3) hanya direkod oleh sistem selepas
-- kod baru dipasang. Skrip ini membina semula log tersebut bagi tahun 2026 daripada jejak
-- yang memang tersimpan dalam pangkalan data:
--   * LESEN_ApprovalList / LESEN_ApprovalListBatal (ApprovalDate + ApproverID)
--       1 Hantar Permohonan | 2 Tetapkan Pegawai | 3 Hantar Ulasan | 4 Pengesahan Ulasan
--       5 Sokong / Tidak Sokong | 8 Lulus / Tolak (Tolak jika langkah 9 ada tarikh)
--       10 Lulus (hanya jika tiada langkah 8 - elak log berganda)
--   * LESEN_KembaliIK                         -> Kembali ke IK
--   * LESEN_PermohonanFail                    -> Muat Naik (lampiran permohonan / surat)
--   * LESEN_UlasanFail / LESEN_UlasanFailBatal -> Muat Naik (lampiran ulasan)
--   * LESEN_BantingImej                       -> Muat Naik (gambar sepanduk / bunting)
--   * LESEN_SepandukSemakanIK_Lampiran        -> Muat Naik (lampiran semakan sepanduk)
--
-- TIDAK boleh dijana (tiada jejak dalam data lama): login gagal, akses ditolak, muat turun,
-- dan butiran medan yang berubah semasa kemaskini.
--
-- Penanda: AT_Detail berakhir dengan "[Data sejarah - dijana daripada rekod sedia ada]".
-- AT_IP = '::1' (localhost) kerana rekod dijana oleh skrip di pelayan; IP sebenar tindakan tidak pernah direkod.
-- Selamat dijalankan berulang kali: rekod yang sama (atau log sebenar bagi tindakan dan rujukan
-- yang sama dalam 2 minit) tidak akan dimasukkan semula.
--
-- Prasyarat: sql/2026-11-14_audittrail_ref_detail.sql (kolum AT_Ref / AT_Detail).
--
-- CARA GUNA
--   1. Jalankan dengan @Jalankan = 0 (lalai) untuk PRATONTON - bilangan rekod dipaparkan, tiada perubahan.
--   2. Tukar @Jalankan = 1 dan jalankan semula untuk memasukkan rekod.
-- ============================================================================

SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @Jalankan bit      = 0;              -- 0 = pratonton (rollback), 1 = simpan
DECLARE @Mula     datetime = '2026-01-01';   -- tahun ini sahaja
DECLARE @Akhir    datetime = '2027-01-01';
DECLARE @Penanda  nvarchar(80) = N' | [Data sejarah - dijana daripada rekod sedia ada]';

IF COL_LENGTH('dbo.TBL_AUDITTRAIL', 'AT_Ref') IS NULL OR COL_LENGTH('dbo.TBL_AUDITTRAIL', 'AT_Detail') IS NULL
BEGIN
    RAISERROR('Kolum AT_Ref / AT_Detail belum wujud. Jalankan sql/2026-11-14_audittrail_ref_detail.sql dahulu.', 16, 1);
    RETURN;
END

-- Jangan bertindih dengan log yang dicipta oleh sistem selepas kod baru dipasang
DECLARE @Hingga datetime = (SELECT ISNULL(MIN(AT_datetime), @Akhir) FROM TBL_AUDITTRAIL
                            WHERE CAST(AT_Detail AS nvarchar(max)) NOT LIKE N'%[[]Data sejarah - %' AND AT_Ref IS NOT NULL
                              AND AT_Action IN (N'Hantar Permohonan', N'Tetapkan Pegawai', N'Hantar Ulasan', N'Pengesahan Ulasan',
                                                N'Sokong', N'Tidak Sokong', N'Lulus', N'Tolak', N'Kembali ke IK', N'Muat Naik')
                              AND AT_Module <> N'Ujian Fasa 2' AND AT_Module <> N'Dokumen');
IF @Hingga > @Akhir SET @Hingga = @Akhir;

-- Senarai sementara rekod yang akan dimasukkan
IF OBJECT_ID('tempdb..#log') IS NOT NULL DROP TABLE #log;
CREATE TABLE #log (
    AT_UserId   int            NOT NULL,
    AT_UserName varchar(225) COLLATE DATABASE_DEFAULT   NOT NULL,
    AT_Action   varchar(100) COLLATE DATABASE_DEFAULT   NOT NULL,
    AT_Module   varchar(100) COLLATE DATABASE_DEFAULT   NOT NULL,
    AT_Title    nvarchar(400) COLLATE DATABASE_DEFAULT  NOT NULL,
    AT_datetime datetime       NOT NULL,
    AT_Ref      nvarchar(100) COLLATE DATABASE_DEFAULT  NULL,
    AT_Detail   nvarchar(max) COLLATE DATABASE_DEFAULT  NULL,
    Sumber      varchar(50)    NOT NULL
);

-- ---------------------------------------------------------------------------
-- 1. Aliran kerja (permohonan baru dan pembatalan)
-- ---------------------------------------------------------------------------
;WITH Langkah AS (
    SELECT 'B' AS J, a.Permohonan_ID, a.ApprStatusID, a.AgensiID, a.ApproverID, a.ApprovalDate, s.Description
    FROM LESEN_ApprovalList a
    INNER JOIN ApprovalStatus s ON s.ApprStatusID = a.ApprStatusID
    WHERE a.ApprovalDate >= @Mula AND a.ApprovalDate < @Hingga AND a.ApprStatusID IN (1, 2, 3, 4, 5, 8, 10)
    UNION ALL
    SELECT 'P', a.Permohonan_ID, a.ApprStatusID, a.AgensiID, a.ApproverID, a.ApprovalDate, s.Description
    FROM LESEN_ApprovalListBatal a
    INNER JOIN ApprovalStatusBatal s ON s.ApprStatusID = a.ApprStatusID
    WHERE a.ApprovalDate >= @Mula AND a.ApprovalDate < @Hingga AND a.ApprStatusID IN (1, 2, 3, 4, 5, 8, 10)
),
Tindakan AS (
    SELECT l.*,
           p.Rujukan, p.StatusID AS StatusSemasa,
           j.JabatanAgensi_Description AS Agensi,
           CASE l.ApprStatusID
               WHEN 1 THEN 'Hantar Permohonan'
               WHEN 2 THEN 'Tetapkan Pegawai'
               WHEN 3 THEN 'Hantar Ulasan'
               WHEN 4 THEN 'Pengesahan Ulasan'
               WHEN 5 THEN CASE WHEN p.StatusID = 6 AND NOT EXISTS (
                                    SELECT 1 FROM LESEN_ApprovalList x WHERE l.J = 'B' AND x.Permohonan_ID = l.Permohonan_ID AND x.ApprStatusID = 8 AND x.ApprovalDate IS NOT NULL
                                    UNION ALL
                                    SELECT 1 FROM LESEN_ApprovalListBatal x WHERE l.J = 'P' AND x.Permohonan_ID = l.Permohonan_ID AND x.ApprStatusID = 8 AND x.ApprovalDate IS NOT NULL)
                               THEN 'Tidak Sokong' ELSE 'Sokong' END
               WHEN 8 THEN CASE WHEN EXISTS (
                                    SELECT 1 FROM LESEN_ApprovalList x WHERE l.J = 'B' AND x.Permohonan_ID = l.Permohonan_ID AND x.ApprStatusID = 9 AND x.ApprovalDate IS NOT NULL
                                    UNION ALL
                                    SELECT 1 FROM LESEN_ApprovalListBatal x WHERE l.J = 'P' AND x.Permohonan_ID = l.Permohonan_ID AND x.ApprStatusID = 9 AND x.ApprovalDate IS NOT NULL)
                               THEN 'Tolak' ELSE 'Lulus' END
               WHEN 10 THEN CASE WHEN EXISTS (
                                    SELECT 1 FROM LESEN_ApprovalList x WHERE l.J = 'B' AND x.Permohonan_ID = l.Permohonan_ID AND x.ApprStatusID = 8 AND x.ApprovalDate IS NOT NULL
                                    UNION ALL
                                    SELECT 1 FROM LESEN_ApprovalListBatal x WHERE l.J = 'P' AND x.Permohonan_ID = l.Permohonan_ID AND x.ApprStatusID = 8 AND x.ApprovalDate IS NOT NULL)
                                THEN NULL ELSE 'Lulus' END
           END AS Aksi
    FROM Langkah l
    INNER JOIN LESEN_Permohonan p ON p.Permohonan_ID = l.Permohonan_ID
    LEFT JOIN LESEN_JabatanAgensi j ON j.JabatanAgensi_ID = l.AgensiID
)
INSERT INTO #log (AT_UserId, AT_UserName, AT_Action, AT_Module, AT_Title, AT_datetime, AT_Ref, AT_Detail, Sumber)
SELECT ISNULL(pg.Users_Id, 0),
       ISNULL(pg.Users_Name, ''),
       t.Aksi,
       CASE WHEN t.ApprStatusID = 1 THEN 'Pendaftaran Permohonan' WHEN t.J = 'P' THEN 'Pembatalan' ELSE 'Kelulusan' END,
       t.Aksi + N' - ' + ISNULL(NULLIF(LTRIM(RTRIM(t.Rujukan)), ''), N'ID ' + CAST(t.Permohonan_ID AS nvarchar(20))),
       t.ApprovalDate,
       ISNULL(NULLIF(LTRIM(RTRIM(t.Rujukan)), ''), N'ID ' + CAST(t.Permohonan_ID AS nvarchar(20))),
       CASE WHEN t.J = 'P' THEN N'Pembatalan' ELSE N'Permohonan Baru' END
         + N' | Langkah selesai: ' + t.Description
         + ISNULL(N' | Agensi: ' + t.Agensi, N'')
         + ISNULL(N' | Pegawai: ' + pg.Senarai, N'')
         + @Penanda,
       CASE WHEN t.J = 'P' THEN 'ApprovalListBatal' ELSE 'ApprovalList' END
FROM Tindakan t
OUTER APPLY (
    -- Pengguna yang bertindak; langkah 3 (lawatan tapak) tiada ApproverID - guna pegawai yang ditetapkan
    SELECT TOP 1 u.Users_Id, u.Users_Name,
           CASE WHEN t.ApprStatusID = 3 THEN
               (SELECT STRING_AGG(CAST(u2.Users_Fullname AS nvarchar(max)), ', ')
                FROM (SELECT s.PermohonanAgensiStaffID_UsersID AS Uid FROM LESEN_PermohonanAgensiStaff s
                      INNER JOIN LESEN_PermohonanAgensi pa ON pa.PermohonanAgensi_ID = s.PermohonanAgensi_ID
                      WHERE t.J = 'B' AND pa.Permohonan_ID = t.Permohonan_ID AND pa.JabatanAgensi_ID = t.AgensiID
                      UNION
                      SELECT s.PermohonanAgensiStaffID_UsersID FROM LESEN_PermohonanAgensiStaffBatal s
                      INNER JOIN LESEN_PermohonanAgensiBatal pa ON pa.PermohonanAgensi_ID = s.PermohonanAgensi_ID
                      WHERE t.J = 'P' AND pa.Permohonan_ID = t.Permohonan_ID AND pa.JabatanAgensi_ID = t.AgensiID) st
                INNER JOIN TBL_USERS u2 ON u2.Users_Id = st.Uid)
           END AS Senarai
    FROM TBL_USERS u
    WHERE u.Users_Id = COALESCE(t.ApproverID,
                                (SELECT TOP 1 s.PermohonanAgensiStaffID_UsersID FROM LESEN_PermohonanAgensiStaff s
                                 INNER JOIN LESEN_PermohonanAgensi pa ON pa.PermohonanAgensi_ID = s.PermohonanAgensi_ID
                                 WHERE t.J = 'B' AND pa.Permohonan_ID = t.Permohonan_ID AND pa.JabatanAgensi_ID = t.AgensiID
                                 ORDER BY s.PermohonanAgensiStaffID),
                                (SELECT TOP 1 s.PermohonanAgensiStaffID_UsersID FROM LESEN_PermohonanAgensiStaffBatal s
                                 INNER JOIN LESEN_PermohonanAgensiBatal pa ON pa.PermohonanAgensi_ID = s.PermohonanAgensi_ID
                                 WHERE t.J = 'P' AND pa.Permohonan_ID = t.Permohonan_ID AND pa.JabatanAgensi_ID = t.AgensiID
                                 ORDER BY s.PermohonanAgensiStaffID))
) pg
WHERE t.Aksi IS NOT NULL;

-- ---------------------------------------------------------------------------
-- 2. Kembali ke IK
-- ---------------------------------------------------------------------------
INSERT INTO #log (AT_UserId, AT_UserName, AT_Action, AT_Module, AT_Title, AT_datetime, AT_Ref, AT_Detail, Sumber)
SELECT ISNULL(u.Users_Id, 0), ISNULL(k.CreatedBy, ''), 'Kembali ke IK',
       CASE WHEN ISNULL(p.IsBatal, 0) = 1 THEN 'Pembatalan' ELSE 'Kelulusan' END,
       N'Kembali ke IK - ' + ISNULL(NULLIF(LTRIM(RTRIM(p.Rujukan)), ''), N'ID ' + CAST(k.Permohonan_ID AS nvarchar(20))),
       k.CreatedDt,
       ISNULL(NULLIF(LTRIM(RTRIM(p.Rujukan)), ''), N'ID ' + CAST(k.Permohonan_ID AS nvarchar(20))),
       CASE WHEN ISNULL(p.IsBatal, 0) = 1 THEN N'Pembatalan' ELSE N'Permohonan Baru' END
         + ISNULL(N' | Catatan: ' + NULLIF(LEFT(k.Catatan, 300), ''), N'') + @Penanda,
       'KembaliIK'
FROM LESEN_KembaliIK k
LEFT JOIN LESEN_Permohonan p ON p.Permohonan_ID = k.Permohonan_ID
LEFT JOIN TBL_USERS u ON u.Users_Name = k.CreatedBy
WHERE k.CreatedDt >= @Mula AND k.CreatedDt < @Hingga;

-- ---------------------------------------------------------------------------
-- 3. Muat naik dokumen
-- ---------------------------------------------------------------------------
-- 3a. Lampiran permohonan / surat (LESEN_PermohonanFail). CreatorID menyimpan nama pengguna.
INSERT INTO #log (AT_UserId, AT_UserName, AT_Action, AT_Module, AT_Title, AT_datetime, AT_Ref, AT_Detail, Sumber)
SELECT ISNULL(u.Users_Id, 0), ISNULL(f.CreatorID, ''), 'Muat Naik', 'Dokumen',
       N'Muat naik: ' + ISNULL(f.PermohonanFail_FileName, N'-'),
       f.CreatedDt,
       ISNULL(NULLIF(LTRIM(RTRIM(p.Rujukan)), ''), N'ID ' + CAST(f.PermohonanFail_PermohonanID AS nvarchar(20))),
       N'Fail: ' + ISNULL(f.PermohonanFail_FileName, N'-')
         + N' | Lampiran permohonan' + ISNULL(N' (' + NULLIF(f.PermohonanFail_JenisLampiran, '') + N')', N'')
         + ISNULL(N' | Disimpan: ' + f.PermohonanFail_FilePath, N'')
         + CASE WHEN f.CreatorID IS NULL THEN N' | Dijana / dimasukkan oleh sistem' ELSE N'' END
         + @Penanda,
       'PermohonanFail'
FROM LESEN_PermohonanFail f
LEFT JOIN LESEN_Permohonan p ON p.Permohonan_ID = f.PermohonanFail_PermohonanID
LEFT JOIN TBL_USERS u ON u.Users_Name = f.CreatorID
WHERE f.CreatedDt >= @Mula AND f.CreatedDt < @Hingga;

-- 3b. Lampiran ulasan (permohonan baru dan pembatalan)
INSERT INTO #log (AT_UserId, AT_UserName, AT_Action, AT_Module, AT_Title, AT_datetime, AT_Ref, AT_Detail, Sumber)
SELECT ISNULL(f.UlasanFail_UserID, 0), ISNULL(u.Users_Name, ISNULL(f.CreatorID, '')), 'Muat Naik', 'Dokumen',
       N'Muat naik: ' + ISNULL(NULLIF(f.UlasanFail_FileName, ''), N'-'),
       f.CreatedDt,
       ISNULL(NULLIF(LTRIM(RTRIM(p.Rujukan)), ''), N'ID ' + CAST(f.UlasanFail_PermohonanID AS nvarchar(20))),
       N'Fail: ' + ISNULL(NULLIF(f.UlasanFail_FileName, ''), N'-') + N' | Lampiran ulasan'
         + ISNULL(N' | Agensi: ' + j.JabatanAgensi_Description, N'')
         + N' | Disimpan: ' + f.UlasanFail_FilePath + @Penanda,
       'UlasanFail'
FROM LESEN_UlasanFail f
LEFT JOIN LESEN_Permohonan p ON p.Permohonan_ID = f.UlasanFail_PermohonanID
LEFT JOIN TBL_USERS u ON u.Users_Id = f.UlasanFail_UserID
LEFT JOIN LESEN_JabatanAgensi j ON j.JabatanAgensi_ID = f.UlasanFail_PermohonanAgensiID
WHERE f.CreatedDt >= @Mula AND f.CreatedDt < @Hingga AND ISNULL(f.UlasanFail_FilePath, '') <> '';

INSERT INTO #log (AT_UserId, AT_UserName, AT_Action, AT_Module, AT_Title, AT_datetime, AT_Ref, AT_Detail, Sumber)
SELECT ISNULL(f.UlasanFail_UserID, 0), ISNULL(u.Users_Name, ISNULL(f.CreatorID, '')), 'Muat Naik', 'Dokumen',
       N'Muat naik: ' + ISNULL(NULLIF(f.UlasanFail_FileName, ''), N'-'),
       f.CreatedDt,
       ISNULL(NULLIF(LTRIM(RTRIM(p.Rujukan)), ''), N'ID ' + CAST(f.UlasanFail_PermohonanID AS nvarchar(20))),
       N'Fail: ' + ISNULL(NULLIF(f.UlasanFail_FileName, ''), N'-') + N' | Lampiran ulasan pembatalan'
         + ISNULL(N' | Agensi: ' + j.JabatanAgensi_Description, N'')
         + N' | Disimpan: ' + f.UlasanFail_FilePath + @Penanda,
       'UlasanFailBatal'
FROM LESEN_UlasanFailBatal f
LEFT JOIN LESEN_Permohonan p ON p.Permohonan_ID = f.UlasanFail_PermohonanID
LEFT JOIN TBL_USERS u ON u.Users_Id = f.UlasanFail_UserID
LEFT JOIN LESEN_JabatanAgensi j ON j.JabatanAgensi_ID = f.UlasanFail_PermohonanAgensiID
WHERE f.CreatedDt >= @Mula AND f.CreatedDt < @Hingga AND ISNULL(f.UlasanFail_FilePath, '') <> '';

-- 3c. Gambar sepanduk / bunting
INSERT INTO #log (AT_UserId, AT_UserName, AT_Action, AT_Module, AT_Title, AT_datetime, AT_Ref, AT_Detail, Sumber)
SELECT ISNULL(u.Users_Id, 0), ISNULL(b.CreatorID, ''), 'Muat Naik', 'Dokumen',
       N'Muat naik: ' + ISNULL(b.FileName, N'-'),
       b.CreatedDt,
       ISNULL(NULLIF(LTRIM(RTRIM(p.Rujukan)), ''), N'ID ' + CAST(b.Permohonan_ID AS nvarchar(20))),
       N'Fail: ' + ISNULL(b.FileName, N'-') + N' | Gambar sepanduk / bunting | Disimpan: ' + ISNULL(b.FilePath, N'-') + @Penanda,
       'BantingImej'
FROM LESEN_BantingImej b
LEFT JOIN LESEN_Permohonan p ON p.Permohonan_ID = b.Permohonan_ID
LEFT JOIN TBL_USERS u ON u.Users_Name = b.CreatorID
WHERE b.CreatedDt >= @Mula AND b.CreatedDt < @Hingga;

-- 3d. Lampiran semakan sepanduk (pegawai IK)
INSERT INTO #log (AT_UserId, AT_UserName, AT_Action, AT_Module, AT_Title, AT_datetime, AT_Ref, AT_Detail, Sumber)
SELECT ISNULL(u.Users_Id, 0), ISNULL(l.CreatorID, ''), 'Muat Naik', 'Dokumen',
       N'Muat naik: ' + ISNULL(l.Lampiran_FileName, N'-'),
       l.CreatedDt,
       ISNULL(NULLIF(LTRIM(RTRIM(s.SemakanIK_NoRujukan)), ''), N'Semakan IK ' + CAST(l.Lampiran_SemakanIKID AS nvarchar(20))),
       N'Fail: ' + ISNULL(l.Lampiran_FileName, N'-') + N' | Lampiran semakan sepanduk | Disimpan: ' + ISNULL(l.Lampiran_FilePath, N'-') + @Penanda,
       'SepandukLampiran'
FROM LESEN_SepandukSemakanIK_Lampiran l
LEFT JOIN LESEN_SepandukSemakanIK s ON s.SemakanIK_ID = l.Lampiran_SemakanIKID
LEFT JOIN TBL_USERS u ON u.Users_Name = l.CreatorID
WHERE l.CreatedDt >= @Mula AND l.CreatedDt < @Hingga;

-- ---------------------------------------------------------------------------
-- 4. Buang yang sudah wujud (larian semula, atau log sebenar dalam 2 minit)
-- ---------------------------------------------------------------------------
DELETE g FROM #log g
WHERE EXISTS (SELECT 1 FROM TBL_AUDITTRAIL a
              WHERE a.AT_Action = g.AT_Action
                AND a.AT_Ref = g.AT_Ref
                AND a.AT_datetime BETWEEN DATEADD(minute, -2, g.AT_datetime) AND DATEADD(minute, 2, g.AT_datetime)
                AND (CAST(a.AT_Detail AS nvarchar(max)) LIKE N'%[[]Data sejarah - %' OR CAST(a.AT_Title AS nvarchar(400)) = g.AT_Title));

-- ---------------------------------------------------------------------------
-- 5. Ringkasan dan simpan
-- ---------------------------------------------------------------------------
PRINT 'Julat: ' + CONVERT(varchar(19), @Mula, 120) + ' hingga ' + CONVERT(varchar(19), @Hingga, 120);
SELECT Sumber, AT_Action, COUNT(*) AS Bilangan, MIN(AT_datetime) AS Dari, MAX(AT_datetime) AS Hingga
FROM #log GROUP BY Sumber, AT_Action ORDER BY Sumber, AT_Action;
SELECT COUNT(*) AS JumlahAkanDimasukkan FROM #log;

IF @Jalankan = 1
BEGIN
    BEGIN TRAN;
    INSERT INTO TBL_AUDITTRAIL (AT_UserId, AT_UserName, AT_IP, AT_Action, AT_Module, AT_Title, AT_datetime, AT_Ref, AT_Detail)
    SELECT AT_UserId, LEFT(AT_UserName, 225), '::1', AT_Action, AT_Module, AT_Title, AT_datetime, LEFT(AT_Ref, 100), AT_Detail
    FROM #log
    ORDER BY AT_datetime;
    PRINT CAST(@@ROWCOUNT AS varchar(20)) + ' rekod log sejarah dimasukkan.';
    COMMIT;
END
ELSE
    PRINT 'PRATONTON sahaja - tiada rekod dimasukkan. Tukar @Jalankan = 1 untuk simpan.';

DROP TABLE #log;
