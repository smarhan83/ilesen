-- Menu "Daftar Permohonan (Arkib)" di bawah folder Arkib (UGM_Id 4365)
-- Guna halaman yang sama: /lesen/appregister1.aspx?isarchive=1 (suis Arkib terpasang, papar permohonan lulus sahaja)
-- Kebenaran: beri melalui halaman kebenaran kumpulan pengguna (TBL_USER_GROUPROLE) selepas menu dicipta.
-- Nota: padanan kebenaran halaman ikut nama fail (appregister1.aspx), jadi menu ini berkongsi kebenaran dengan "Daftar Permohonan (Baru)".

IF NOT EXISTS (SELECT 1 FROM dbo.TBL_USER_GROUPMODULE WHERE UGM_Filename = '/lesen/appregister1.aspx?isarchive=1')
BEGIN
    INSERT INTO dbo.TBL_USER_GROUPMODULE
        (UGM_Name, UGM_Filename, UGM_ParentId, UGM_SeqNo, UGM_Level, UGM_IsPublish, UGM_SystemId)
    VALUES
        ('Daftar Permohonan (Arkib)', '/lesen/appregister1.aspx?isarchive=1', 4365, 1, 2, 1, 3);
END
