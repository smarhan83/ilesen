-- ============================================================================
-- Kelulusan Sementara untuk Borang Lesen Perniagaan (appregister1.aspx)
--   * Kolum   dbo.LESEN_Permohonan.IsKelulusanSementara - penanda pilihan Kelulusan Sementara (bukan 24 jam)
--   * Jadual  dbo.LESEN_KelulusanSementara              - rekod tarikh mula & tarikh tamat kelulusan sementara
--                                                         (maksimum 5 kali pembaharuan bagi setiap Permohonan_ID)
-- ============================================================================

IF COL_LENGTH('dbo.LESEN_Permohonan', 'IsKelulusanSementara') IS NULL
BEGIN
    ALTER TABLE dbo.LESEN_Permohonan
    ADD IsKelulusanSementara bit NOT NULL
        CONSTRAINT DF_LESEN_Permohonan_IsKelulusanSementara DEFAULT (0);
END
GO

IF OBJECT_ID('dbo.LESEN_KelulusanSementara', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.LESEN_KelulusanSementara (
        KelulusanSementara_ID int IDENTITY(1,1) NOT NULL CONSTRAINT PK_LESEN_KelulusanSementara PRIMARY KEY,
        Permohonan_ID         int               NOT NULL,
        TarikhMula            date              NOT NULL,
        TarikhTamat           date              NOT NULL,
        CreatorID             nvarchar(100)     NULL,
        CreatedDt             datetime          NOT NULL CONSTRAINT DF_LESEN_KelulusanSementara_CreatedDt DEFAULT (GETDATE()),
        LastModID             nvarchar(100)     NULL,
        LastModDt             datetime          NULL
    );

    CREATE INDEX IX_LESEN_KelulusanSementara_PermohonanID
        ON dbo.LESEN_KelulusanSementara (Permohonan_ID, KelulusanSementara_ID);
END
GO
