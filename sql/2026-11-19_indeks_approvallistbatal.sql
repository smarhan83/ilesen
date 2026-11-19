-- ============================================================================
-- LESEN_ApprovalListBatal - indeks (Permohonan_ID, AgensiID)
--   * Selaras dengan idx_LESEN_ApprovalList_PermAgensi pada dbo.LESEN_ApprovalList
--   * Digunakan oleh v_LESEN_ApprovalListBatal_Curr dan senarai di lesen/semakpembatalan1.aspx
--     (join h, EXISTS x1 ... AgensiID = @AgensiID)
-- Skrip boleh dijalankan berulang kali.
-- ============================================================================

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID('dbo.LESEN_ApprovalListBatal') AND name = 'idx_LESEN_ApprovalListBatal_PermAgensi')
BEGIN
    CREATE NONCLUSTERED INDEX idx_LESEN_ApprovalListBatal_PermAgensi ON dbo.LESEN_ApprovalListBatal (Permohonan_ID, AgensiID);
END
GO

UPDATE STATISTICS dbo.LESEN_ApprovalListBatal WITH FULLSCAN;
GO
