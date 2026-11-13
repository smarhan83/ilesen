-- ============================================================================
-- Audit Trail - kolum tambahan untuk keperluan audit
--   * dbo.TBL_AUDITTRAIL.AT_Ref     - rujukan rekod (cth. No. Rujukan permohonan, ID pengguna cubaan login)
--   * dbo.TBL_AUDITTRAIL.AT_Detail  - butiran tindakan (cth. sebab login gagal, status lama -> baru)
--   * Indeks AT_datetime dan AT_Ref untuk carian / penapis di administration/audittrail.aspx
-- Kod (GlobalClass.auditTrail) menyemak kewujudan kolum ini; sebelum skrip dijalankan,
-- log masih ditulis tanpa AT_Ref / AT_Detail.
-- ============================================================================

IF COL_LENGTH('dbo.TBL_AUDITTRAIL', 'AT_Ref') IS NULL
BEGIN
    ALTER TABLE dbo.TBL_AUDITTRAIL
    ADD AT_Ref nvarchar(100) NULL;
END
GO

IF COL_LENGTH('dbo.TBL_AUDITTRAIL', 'AT_Detail') IS NULL
BEGIN
    ALTER TABLE dbo.TBL_AUDITTRAIL
    ADD AT_Detail nvarchar(max) NULL;
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID('dbo.TBL_AUDITTRAIL') AND name = 'IX_TBL_AUDITTRAIL_datetime')
BEGIN
    CREATE NONCLUSTERED INDEX IX_TBL_AUDITTRAIL_datetime ON dbo.TBL_AUDITTRAIL (AT_datetime DESC);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID('dbo.TBL_AUDITTRAIL') AND name = 'IX_TBL_AUDITTRAIL_ref')
BEGIN
    -- Indeks biasa (bukan filtered) supaya INSERT dari sambungan dengan QUOTED_IDENTIFIER OFF tidak gagal
    CREATE NONCLUSTERED INDEX IX_TBL_AUDITTRAIL_ref ON dbo.TBL_AUDITTRAIL (AT_Ref);
END
GO
