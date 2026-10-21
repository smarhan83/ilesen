-- ============================================================================
-- SP_NotiBantingPin  (hantar Permohonan_ID sahaja)
-- Hantar e-mel kepada pemohon PERMIT SEPANDUK/BUNTING (JenisLesen_ID = 27) yang telah LULUS (StatusID = 10),
-- mengandungi No. Pin (LESEN_Permohonan.BantingID) untuk memuat turun kod QR melalui menu "Semak Permohonan"
-- di http://prolesen.mpkluang.gov.my/
--
-- Tiada e-mel dihantar jika:
--   * DB disekat (dbo.fn_IsEmailDisabled() = 1, cth. ilesen_demo)
--   * permohonan bukan Permit Sepanduk/Bunting, belum lulus (StatusID <> 10) atau dibatalkan
--   * BantingID kosong (tiada No. Pin untuk dihantar)
--   * Pemohon_Email kosong / format tidak sah
--
-- Panggilan:  EXEC dbo.SP_NotiBantingPin @Permohonan_ID = 12345;
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Sekat e-mel untuk DB tertentu: dbo.fn_IsEmailDisabled()  (dipanggil di awal SP e-mel)
-- Dicipta hanya jika belum wujud. Untuk menyekat e-mel pada sesuatu DB (cth. demo / ujian yang direstore daripada
-- production), tambah nama DB dalam senarai IN (...) di bawah menggunakan ALTER FUNCTION (lihat bahagian paling bawah).
-- ----------------------------------------------------------------------------
IF OBJECT_ID('dbo.fn_IsEmailDisabled', 'FN') IS NULL
    EXEC('CREATE FUNCTION dbo.fn_IsEmailDisabled() RETURNS bit AS BEGIN RETURN CASE WHEN DB_NAME() IN (''ilesen_demo'') THEN 1 ELSE 0 END; END');
GO
-- QUOTED_IDENTIFIER mesti ON (kaedah XML .value() dalam prosedur)
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

IF OBJECT_ID('dbo.SP_NotiBantingPin', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.SP_NotiBantingPin AS BEGIN SET NOCOUNT ON; END');
GO

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

ALTER PROCEDURE [dbo].[SP_NotiBantingPin]
    @Permohonan_ID int
AS
BEGIN
    SET NOCOUNT ON;

    --## Sekat e-mel untuk DB tertentu (cth. ilesen_demo) - senarai dalam dbo.fn_IsEmailDisabled ##--
    IF dbo.fn_IsEmailDisabled() = 1 RETURN;

    DECLARE @EmailProfileName nvarchar(20) = 'MPKSender';
    DECLARE @UrlSistem varchar(200) = 'http://prolesen.mpkluang.gov.my/';

    DECLARE @NoRujukan nvarchar(200), @Pin nvarchar(100), @Emel nvarchar(400), @Pemohon nvarchar(400),
            @Syarikat nvarchar(400), @Tarikh1 varchar(10), @Tarikh2 varchar(10), @Lokasi nvarchar(max), @BilLokasi int,
            @JenisLesenID int, @StatusID int, @IsBatal bit;

    SELECT @NoRujukan = ISNULL(p.Rujukan, ''),
           @Pin       = LTRIM(RTRIM(ISNULL(p.BantingID, ''))),
           @Emel      = LTRIM(RTRIM(ISNULL(e.Pemohon_Email, ''))),
           @Pemohon   = ISNULL(e.Pemohon_Name, ''),
           @Syarikat  = ISNULL(NULLIF(p.NamaBaruSyarikat, ''), ISNULL(p.NamaSyarikat, '')),
           @Tarikh1   = CONVERT(varchar(10), p.TarikhBanting1, 103),
           @Tarikh2   = CONVERT(varchar(10), p.TarikhBanting2, 103),
           @JenisLesenID = p.JenisLesen_ID,
           @StatusID  = p.StatusID,
           @IsBatal   = ISNULL(p.IsBatal, 0)
    FROM LESEN_Permohonan p
    LEFT JOIN LESEN_Pemohon e ON e.Pemohon_ID = p.Permohonan_PemohonID
    WHERE p.Permohonan_ID = @Permohonan_ID
      AND (p.JenisLesen_ID = 27 OR (',' + ISNULL(p.JenisLesenIdList, '') + ',') LIKE '%,27,%');

    -- bukan Permit Sepanduk/Bunting / tiada rekod
    IF @NoRujukan IS NULL RETURN;
    -- hanya yang telah lulus & tidak dibatalkan
    IF @StatusID <> 10 OR @IsBatal = 1 RETURN;
    -- mesti ada No. Pin
    IF @Pin = '' RETURN;

    -- e-mel pemohon: buang ruang, ',' dan '/' dianggap pemisah (sp_send_dbmail guna ';'); semak format asas
    SET @Emel = REPLACE(REPLACE(REPLACE(@Emel, ' ', ''), ',', ';'), '/', ';');
    IF @Emel = '' OR @Emel NOT LIKE '%_@_%._%' RETURN;

    -- senarai lokasi pemasangan + bilangan kod QR
    SELECT @BilLokasi = COUNT(*) FROM LESEN_BantingLokasi WHERE Permohonan_ID = @Permohonan_ID;
    SET @Lokasi = ISNULL(STUFF((
            SELECT '<br>' + CAST(ROW_NUMBER() OVER (ORDER BY l.Lokasi_ID) AS varchar(10)) + '. ' +
                   REPLACE(REPLACE(REPLACE(ISNULL(l.Lokasi, ''), '&', '&amp;'), '<', '&lt;'), '>', '&gt;')
            FROM LESEN_BantingLokasi l
            WHERE l.Permohonan_ID = @Permohonan_ID
            ORDER BY l.Lokasi_ID
            FOR XML PATH(''), TYPE).value('.', 'nvarchar(max)'), 1, 4, ''), '-');

    -- HTML-encode nilai yang dipaparkan dalam e-mel
    SET @Pemohon  = REPLACE(REPLACE(REPLACE(@Pemohon,  '&', '&amp;'), '<', '&lt;'), '>', '&gt;');
    SET @Syarikat = REPLACE(REPLACE(REPLACE(@Syarikat, '&', '&amp;'), '<', '&lt;'), '>', '&gt;');
    SET @NoRujukan = REPLACE(REPLACE(REPLACE(@NoRujukan, '&', '&amp;'), '<', '&lt;'), '>', '&gt;');
    DECLARE @PinHtml nvarchar(200) = REPLACE(REPLACE(REPLACE(@Pin, '&', '&amp;'), '<', '&lt;'), '>', '&gt;');

    DECLARE @title nvarchar(500) = N'MPK: NO. PIN KOD QR PERMIT SEPANDUK/BUNTING - [' + @NoRujukan + N']';
    DECLARE @tempoh nvarchar(100) = CASE WHEN @Tarikh1 IS NULL OR @Tarikh2 IS NULL THEN N'-' ELSE @Tarikh1 + N' hingga ' + @Tarikh2 END;

    DECLARE @body nvarchar(max) = N'
<div style="margin:0;padding:24px 12px;background:#f3f5fb;font-family:Segoe UI,Helvetica,Arial,sans-serif;color:#1f2937;">
<table role="presentation" align="center" width="600" cellpadding="0" cellspacing="0" style="width:100%;max-width:600px;background:#ffffff;border-radius:14px;border:1px solid #e3e8f2;overflow:hidden;">

  <tr><td style="background:#2E3192;padding:22px 28px;color:#ffffff;">
    <div style="font-size:12px;letter-spacing:1px;color:#cfd2f5;">MAJLIS PERBANDARAN KLUANG</div>
    <div style="font-size:22px;font-weight:700;margin-top:4px;">ProLesen</div>
  </td></tr>

  <tr><td style="padding:28px 28px 8px 28px;">
    <div style="font-size:20px;font-weight:700;color:#1f2937;">Permohonan Anda Telah Diluluskan</div>
    <p style="font-size:14px;line-height:1.6;margin:14px 0 0 0;">Tuan/Puan <b>' + @Pemohon + N'</b>,</p>
    <p style="font-size:14px;line-height:1.6;margin:10px 0 0 0;">
      Permohonan <b>Permit Sepanduk / Bunting</b> anda telah <b style="color:#1e7e34;">diluluskan</b>.
      Sila gunakan <b>No. Pin</b> di bawah untuk memaparkan dan memuat turun <b>kod QR</b> sepanduk / bunting anda.
    </p>
  </td></tr>

  <tr><td style="padding:18px 28px 6px 28px;">
    <table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:#f4f5ff;border:2px dashed #2E3192;border-radius:12px;">
      <tr><td align="center" style="padding:18px 12px;">
        <div style="font-size:12px;letter-spacing:1.5px;color:#4b5675;font-weight:700;">NO. PIN ANDA</div>
        <div style="font-family:Consolas,Courier New,monospace;font-size:30px;font-weight:700;letter-spacing:3px;color:#2E3192;margin-top:6px;">' + @PinHtml + N'</div>
        <div style="font-size:12px;color:#6b7280;margin-top:8px;">Simpan No. Pin ini dan jangan kongsikan kepada pihak lain.</div>
      </td></tr>
    </table>
  </td></tr>

  <tr><td style="padding:18px 28px 6px 28px;">
    <div style="font-size:13px;font-weight:700;color:#2E3192;letter-spacing:.5px;margin-bottom:8px;">MAKLUMAT PERMOHONAN</div>
    <table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="font-size:13.5px;border-collapse:collapse;">
      <tr><td style="padding:7px 0;color:#6b7280;width:38%;border-bottom:1px solid #eef0f6;">No. Rujukan</td><td style="padding:7px 0;font-weight:600;border-bottom:1px solid #eef0f6;">' + @NoRujukan + N'</td></tr>
      <tr><td style="padding:7px 0;color:#6b7280;border-bottom:1px solid #eef0f6;">Pemohon</td><td style="padding:7px 0;font-weight:600;border-bottom:1px solid #eef0f6;">' + @Pemohon + N'</td></tr>
      <tr><td style="padding:7px 0;color:#6b7280;border-bottom:1px solid #eef0f6;">Syarikat</td><td style="padding:7px 0;font-weight:600;border-bottom:1px solid #eef0f6;">' + CASE WHEN @Syarikat = '' THEN N'-' ELSE @Syarikat END + N'</td></tr>
      <tr><td style="padding:7px 0;color:#6b7280;border-bottom:1px solid #eef0f6;">Tempoh Pemasangan</td><td style="padding:7px 0;font-weight:600;border-bottom:1px solid #eef0f6;">' + @tempoh + N'</td></tr>
      <tr><td style="padding:7px 0;color:#6b7280;vertical-align:top;">Lokasi (' + CAST(@BilLokasi AS nvarchar(10)) + N' kod QR)</td><td style="padding:7px 0;font-weight:600;">' + @Lokasi + N'</td></tr>
    </table>
  </td></tr>

  <tr><td style="padding:18px 28px 6px 28px;">
    <div style="font-size:13px;font-weight:700;color:#2E3192;letter-spacing:.5px;margin-bottom:8px;">CARA MEMUAT TURUN KOD QR</div>
    <table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="font-size:13.5px;line-height:1.55;">
      <tr><td style="width:30px;vertical-align:top;padding:5px 0;"><span style="display:inline-block;width:22px;height:22px;line-height:22px;text-align:center;border-radius:50%;background:#2E3192;color:#fff;font-size:12px;font-weight:700;">1</span></td>
          <td style="padding:5px 0;">Layari <a href="' + @UrlSistem + N'" style="color:#2E3192;font-weight:600;">' + @UrlSistem + N'</a></td></tr>
      <tr><td style="vertical-align:top;padding:5px 0;"><span style="display:inline-block;width:22px;height:22px;line-height:22px;text-align:center;border-radius:50%;background:#2E3192;color:#fff;font-size:12px;font-weight:700;">2</span></td>
          <td style="padding:5px 0;">Klik menu <b>Semak Permohonan</b> di bahagian atas laman.</td></tr>
      <tr><td style="vertical-align:top;padding:5px 0;"><span style="display:inline-block;width:22px;height:22px;line-height:22px;text-align:center;border-radius:50%;background:#2E3192;color:#fff;font-size:12px;font-weight:700;">3</span></td>
          <td style="padding:5px 0;">Masukkan <b>No. Pin</b> di atas (atau No. Kad Pengenalan / No. Pendaftaran Syarikat) pada kotak carian, kemudian klik <b>Semak</b>.</td></tr>
      <tr><td style="vertical-align:top;padding:5px 0;"><span style="display:inline-block;width:22px;height:22px;line-height:22px;text-align:center;border-radius:50%;background:#2E3192;color:#fff;font-size:12px;font-weight:700;">4</span></td>
          <td style="padding:5px 0;">Pada senarai permohonan, klik <b>QR Sepanduk</b> dan masukkan <b>No. Pin</b> apabila diminta.</td></tr>
      <tr><td style="vertical-align:top;padding:5px 0;"><span style="display:inline-block;width:22px;height:22px;line-height:22px;text-align:center;border-radius:50%;background:#2E3192;color:#fff;font-size:12px;font-weight:700;">5</span></td>
          <td style="padding:5px 0;">Klik <b>Muat Turun</b> atau <b>Cetak</b> bagi setiap lokasi, atau <b>Cetak Semua QR</b>.</td></tr>
    </table>
    <p style="font-size:12.5px;color:#6b7280;margin:8px 0 0 0;">Nota: No. Pin diperlukan setiap kali anda membuka kod QR.</p>
  </td></tr>

  <tr><td align="center" style="padding:20px 28px 6px 28px;">
    <a href="' + @UrlSistem + N'" style="display:inline-block;background:#2E3192;color:#ffffff;text-decoration:none;font-weight:700;font-size:14px;padding:12px 28px;border-radius:10px;">Buka ProLesen</a>
  </td></tr>

  <tr><td style="padding:22px 28px 24px 28px;">
    <div style="border-top:1px solid #eef0f6;padding-top:14px;font-size:12px;line-height:1.6;color:#6b7280;">
      <b style="color:#374151;">"BERKHIDMAT UNTUK NEGARA"</b><br>
      Bahagian Perlesenan, Majlis Perbandaran Kluang<br><br>
      *** Emel ini dijana secara automatik, sila jangan balas ***
    </div>
  </td></tr>

</table>
</div>';

    -- Kegagalan hantar e-mel (profil / SMTP / rangkaian) TIDAK boleh menggagalkan proses kelulusan yang memanggil SP ini (trigger).
    BEGIN TRY
        EXEC msdb.dbo.sp_send_dbmail
             @profile_name = @EmailProfileName,
             @recipients   = @Emel,
             @subject      = @title,
             @body         = @body,
             @body_format  = 'HTML';
    END TRY
    BEGIN CATCH
        PRINT 'SP_NotiBantingPin: e-mel gagal dihantar (Permohonan_ID ' + CAST(@Permohonan_ID AS varchar(20)) + '): ' + ERROR_MESSAGE();
    END CATCH
END
GO

-- ============================================================================
-- (PILIHAN) SAMBUNGKAN KE TRIGGER: hantar automatik bila StatusID bertukar kepada 10 (Lulus)
-- Skrip ini menambah satu baris selepas "EXEC SP_NotiPermohonan" dalam t_LESEN_Permohonan_Update (cabang permohonan baru).
-- Selamat dijalankan berulang kali (tidak menambah dua kali). SP menapis sendiri jenis lesen / BantingID / e-mel.
-- ============================================================================
DECLARE @def nvarchar(max) = OBJECT_DEFINITION(OBJECT_ID('dbo.t_LESEN_Permohonan_Update'));
IF @def IS NOT NULL AND CHARINDEX('SP_NotiBantingPin', @def) = 0
BEGIN
    DECLARE @anchor nvarchar(200) = N'print ''send email''';
    IF CHARINDEX(@anchor, @def) > 0
    BEGIN
        SET @def = STUFF(@def, CHARINDEX(@anchor, @def) + LEN(@anchor), 0,
                   CHAR(13) + CHAR(10) + N'					IF @ApprStatusID = 10 EXEC [dbo].[SP_NotiBantingPin] @Permohonan_ID; --## No. Pin kod QR (Permit Sepanduk/Bunting) ##--');
        SET @def = STUFF(@def, CHARINDEX(N'CREATE TRIGGER', @def), LEN(N'CREATE TRIGGER'), N'ALTER TRIGGER');
        EXEC (@def);
        PRINT 'Trigger t_LESEN_Permohonan_Update dikemas kini (SP_NotiBantingPin disambung).';
    END
    ELSE PRINT 'Anchor tidak dijumpai dalam trigger - sila tambah EXEC SP_NotiBantingPin secara manual.';
END
ELSE PRINT 'Trigger sudah menyebut SP_NotiBantingPin atau tidak wujud - tiada perubahan.';
GO

-- ============================================================================
-- CARA MENYEKAT / MEMBENARKAN E-MEL (semua SP e-mel: SP_NotiPermohonan, SP_NotiPermohonanAgensi, SP_NotiReviewSurat, SP_NotiBantingPin)
-- Senarai DB yang disekat berada dalam fungsi dbo.fn_IsEmailDisabled(). Ubah senarai, contoh tambah ilesen_ujian:
--
--   ALTER FUNCTION dbo.fn_IsEmailDisabled() RETURNS bit AS
--   BEGIN
--       RETURN CASE WHEN DB_NAME() IN ('ilesen_demo', 'ilesen_ujian') THEN 1 ELSE 0 END;
--   END
--
-- Semak status DB semasa:  SELECT DB_NAME() AS DB, dbo.fn_IsEmailDisabled() AS Disekat;   -- 1 = disekat
-- ============================================================================