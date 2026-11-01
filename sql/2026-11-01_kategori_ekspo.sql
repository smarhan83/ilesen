-- ============================================================================
-- Kategori Acara untuk Lesen Ekspo (appregister1.aspx)
--   * Kolum dbo.LESEN_Permohonan.KategoriEkspo            - Kategori acara ekspo/program
--   * Kolum dbo.LESEN_PermohonanPembetulan.KategoriEkspo  - Kategori acara ekspo/program (pembetulan)
-- ============================================================================

IF COL_LENGTH('dbo.LESEN_Permohonan', 'KategoriEkspo') IS NULL
BEGIN
    ALTER TABLE dbo.LESEN_Permohonan
    ADD KategoriEkspo varchar(150) NULL;
END
GO

IF COL_LENGTH('dbo.LESEN_PermohonanPembetulan', 'KategoriEkspo') IS NULL
BEGIN
    ALTER TABLE dbo.LESEN_PermohonanPembetulan
    ADD KategoriEkspo varchar(150) NULL;
END
GO

