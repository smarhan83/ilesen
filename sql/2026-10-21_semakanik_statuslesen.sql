-- Betulkan SemakanIK_StatusLesen pada LESEN_SepandukSemakanIK
-- Sebab: sebelum ini kod menulis "Tamat Tempoh" secara tetap bagi setiap rekod yang dipilih daripada senarai carian.
-- Kini status dikira daripada tarikh pengesahan permohonan (TarikhPengesahanBanting1 - TarikhPengesahanBanting2).
--
-- Peraturan skrip ini (rekod sedia ada "Tamat Tempoh" sahaja):
--   * Tarikh semakan jatuh DALAM tempoh pengesahan  -> 'Berdaftar'
--   * Tarikh semakan di LUAR tempoh                 -> kekal 'Tamat Tempoh'
--   * Tiada permohonan / tiada tarikh pengesahan    -> tidak diubah
-- "Tarikh semakan" = SemakanIK_TarikhSemakan (jika kosong guna CreatedDt), iaitu keadaan semasa semakan dibuat.
--
-- LANGKAH 1: jalankan bahagian SEMAK dahulu dan lihat senarainya.
-- LANGKAH 2: jalankan bahagian KEMAS KINI (ia dalam transaksi; tukar ROLLBACK kepada COMMIT jika bilangan betul).

-------------------------------------------------------------------------------
-- SEMAK
-------------------------------------------------------------------------------
SELECT s.SemakanIK_ID, s.SemakanIK_NoRujukan, s.SemakanIK_PermohonanID,
       s.SemakanIK_StatusLesen AS StatusSekarang,
       COALESCE(s.SemakanIK_TarikhSemakan, s.CreatedDt) AS TarikhSemakan,
       p.TarikhPengesahanBanting1, p.TarikhPengesahanBanting2,
       'Berdaftar' AS StatusBaharu
FROM dbo.LESEN_SepandukSemakanIK s
INNER JOIN dbo.LESEN_Permohonan p ON p.Permohonan_ID = s.SemakanIK_PermohonanID
WHERE s.SemakanIK_StatusLesen = 'Tamat Tempoh'
  AND p.TarikhPengesahanBanting1 IS NOT NULL AND p.TarikhPengesahanBanting2 IS NOT NULL
  AND CAST(COALESCE(s.SemakanIK_TarikhSemakan, s.CreatedDt) AS date)
      BETWEEN CAST(p.TarikhPengesahanBanting1 AS date) AND CAST(p.TarikhPengesahanBanting2 AS date)
ORDER BY s.SemakanIK_ID;

-------------------------------------------------------------------------------
-- KEMAS KINI
-------------------------------------------------------------------------------
BEGIN TRAN;

UPDATE s
SET s.SemakanIK_StatusLesen = 'Berdaftar'
FROM dbo.LESEN_SepandukSemakanIK s
INNER JOIN dbo.LESEN_Permohonan p ON p.Permohonan_ID = s.SemakanIK_PermohonanID
WHERE s.SemakanIK_StatusLesen = 'Tamat Tempoh'
  AND p.TarikhPengesahanBanting1 IS NOT NULL AND p.TarikhPengesahanBanting2 IS NOT NULL
  AND CAST(COALESCE(s.SemakanIK_TarikhSemakan, s.CreatedDt) AS date)
      BETWEEN CAST(p.TarikhPengesahanBanting1 AS date) AND CAST(p.TarikhPengesahanBanting2 AS date);

SELECT @@ROWCOUNT AS BilRekodDikemaskini;

ROLLBACK TRAN;   -- tukar kepada COMMIT TRAN selepas bilangan disahkan betul
