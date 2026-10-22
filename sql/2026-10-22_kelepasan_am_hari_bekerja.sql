-- ============================================================================
-- Hari bekerja untuk Laporan Inspektorat (KPI): tolak Sabtu, Ahad dan Kelepasan Am
--   * Jadual  dbo.LESEN_KelepasanAm   - senarai kelepasan am (diisi / dikemas kini oleh pentadbir setiap tahun)
--   * Fungsi  dbo.fn_HariBekerja(@Mula, @Tamat) - bilangan hari bekerja dalam (@Mula, @Tamat]
--       (hari mula tidak dikira, hari tamat dikira; Sabtu, Ahad dan kelepasan am yang jatuh pada hari bekerja ditolak)
--       cth. Jumaat -> Isnin = 1 hari bekerja; jika Isnin itu kelepasan am = 0.
--
-- PENTING: jadual dicipta KOSONG. Selagi tiada kelepasan am diisi, hanya Sabtu/Ahad yang ditolak
-- (Laporan Inspektorat memaparkan amaran). Isi kelepasan am Persekutuan dan Negeri Johor mengikut pekeliling rasmi
-- setiap tahun - tarikh Hari Raya, Maulidur Rasul, Deepavali dan lain-lain berubah setiap tahun.
-- ============================================================================

IF OBJECT_ID('dbo.LESEN_KelepasanAm', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.LESEN_KelepasanAm (
        Tarikh      date           NOT NULL CONSTRAINT PK_LESEN_KelepasanAm PRIMARY KEY,
        Keterangan  nvarchar(200)  NULL,
        IsActive    bit            NOT NULL CONSTRAINT DF_LESEN_KelepasanAm_IsActive DEFAULT (1),
        CreatorID   nvarchar(100)  NULL,
        CreatedDt   datetime       NULL CONSTRAINT DF_LESEN_KelepasanAm_CreatedDt DEFAULT (GETDATE())
    );
END
GO

IF OBJECT_ID('dbo.fn_HariBekerja', 'FN') IS NULL
    EXEC('CREATE FUNCTION dbo.fn_HariBekerja(@Mula date, @Tamat date) RETURNS int AS BEGIN RETURN 0; END');
GO

ALTER FUNCTION dbo.fn_HariBekerja(@Mula date, @Tamat date)
RETURNS int
AS
BEGIN
    IF @Mula IS NULL OR @Tamat IS NULL OR @Tamat <= @Mula RETURN 0;

    DECLARE @n int = DATEDIFF(day, @Mula, @Tamat);   -- bilangan hari dalam (@Mula, @Tamat]
    DECLARE @minggu int = @n / 7;
    DECLARE @baki int = @n % 7;
    DECLARE @hari int = @minggu * 5;                  -- setiap 7 hari penuh = 5 hari kerja (Isn-Jum)

    -- baki hari: semak satu persatu. 1900-01-01 ialah hari Isnin => (DATEDIFF % 7): 0=Isnin ... 4=Jumaat, 5=Sabtu, 6=Ahad
    -- (tidak bergantung pada SET DATEFIRST)
    DECLARE @d date = DATEADD(day, @minggu * 7, @Mula);
    DECLARE @i int = 1;
    WHILE @i <= @baki
    BEGIN
        SET @d = DATEADD(day, 1, @d);
        IF (DATEDIFF(day, '19000101', @d) % 7) < 5 SET @hari = @hari + 1;
        SET @i = @i + 1;
    END

    -- tolak kelepasan am yang jatuh pada hari bekerja (Isnin - Jumaat)
    SET @hari = @hari - ISNULL((
        SELECT COUNT(*) FROM dbo.LESEN_KelepasanAm k
        WHERE k.IsActive = 1 AND k.Tarikh > @Mula AND k.Tarikh <= @Tamat
          AND (DATEDIFF(day, '19000101', k.Tarikh) % 7) < 5), 0);

    RETURN CASE WHEN @hari < 0 THEN 0 ELSE @hari END;
END
GO

-- Contoh mengisi kelepasan am (GANTI dengan tarikh rasmi; jangan guna contoh ini tanpa semakan):
-- INSERT INTO dbo.LESEN_KelepasanAm (Tarikh, Keterangan, CreatorID) VALUES
--     ('2026-01-01', 'Tahun Baru', 'ADMIN'),
--     ('2026-05-01', 'Hari Pekerja', 'ADMIN'),
--     ('2026-08-31', 'Hari Kebangsaan', 'ADMIN'),
--     ('2026-09-16', 'Hari Malaysia', 'ADMIN'),
--     ('2026-12-25', 'Hari Krismas', 'ADMIN');
