/*
  Aliran kelulusan permohonan 24 jam (2026-10-12)

  1. Submit -> Pengesah Jabatan Lesen (En Helmi) luluskan dahulu (lulus sementara, StatusID=10).
     Lulus24JamID / Lulus24JamDt simpan siapa & bila.
  2. Bila SEMUA agensi selesai (LESEN_ApprovalList level 2 lengkap), trigger agensi kembalikan
     permohonan ke StatusID=5 -> Pengesah -> Peraku (En Hisham) -> Lulus (10) / Tidak Lulus (9).
  3. Jika semua agensi dah selesai semasa Pengesah lulus, terus ke Peraku (aliran biasa).

  Jalankan sekali di database ilesen.
*/

IF COL_LENGTH('dbo.LESEN_Permohonan', 'Lulus24JamID') IS NULL
	ALTER TABLE dbo.LESEN_Permohonan ADD Lulus24JamID nvarchar(50) NULL;
GO
IF COL_LENGTH('dbo.LESEN_Permohonan', 'Lulus24JamDt') IS NULL
	ALTER TABLE dbo.LESEN_Permohonan ADD Lulus24JamDt datetime NULL;
GO

ALTER TRIGGER [dbo].[t_LESEN_PermohonanAgensi_Update]
   ON  [dbo].[LESEN_PermohonanAgensi]
   AFTER /*INSERT,*/ UPDATE
AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @Permohonan_ID int;
    DECLARE @JabatanAgensi_ID int;
	DECLARE @IsLawatanTapakUlasan bit;
	DECLARE @IsPenilaian bit;
	DECLARE @IsPeraku bit;
    DECLARE @StatusID int;

    DECLARE @JabatanAgensi_Type varchar(1);

    DECLARE @reviewStatusID int;
    DECLARE @reviewStatusID_OLD int;
    DECLARE @kbApproval int;
    DECLARE @kbApproval_OLD int;
    DECLARE @kjApproval int;
    DECLARE @kjApproval_OLD int;
    DECLARE @PengesahID int;
	DECLARE @ikAssign int;

	SELECT @Permohonan_ID=Permohonan_ID, @JabatanAgensi_ID=JabatanAgensi_ID, @IsLawatanTapakUlasan=ISNULL(IsLawatanTapakUlasan,0),
	@IsPenilaian=ISNULL(IsPenilaian,0), @IsPeraku=ISNULL(IsPeraku,0), @StatusID=StatusID,
	@reviewStatusID=reviewStatusID, @kbApproval=kbApproval, @kjApproval=kjApproval, @PengesahID=PengesahID, @ikAssign=ikAssign FROM inserted;

	SELECT @reviewStatusID_OLD=reviewStatusID, @kbApproval_OLD=kbApproval, @kjApproval_OLD=kjApproval FROM deleted;

	SELECT TOP 1 @JabatanAgensi_Type=ISNULL(JabatanAgensi_Type,'J') FROM LESEN_JabatanAgensi WHERE JabatanAgensi_ID=@JabatanAgensi_ID;

	IF @reviewStatusID=1 AND @reviewStatusID_OLD IS NULL --## Review Surat Mohon Ulasan ##
	 BEGIN
		--print 'Send Email ke KB Lesen untuk review surat mohon ulasan';
		EXEC [dbo].[SP_NotiReviewSurat] @Permohonan_ID, @JabatanAgensi_ID, 1;
	 END
	ELSE IF @kbApproval=1 AND @kbApproval_OLD IS NULL AND @JabatanAgensi_Type='L'
	 BEGIN
		--print 'Send Email ke KJ Lesen untuk review surat mohon ulasan';
		EXEC [dbo].[SP_NotiReviewSurat] @Permohonan_ID, @JabatanAgensi_ID, 2;
	 END
	ELSE IF @kbApproval=1 AND @kbApproval_OLD IS NULL AND @JabatanAgensi_Type='J'
	 BEGIN
		--print 'Send Email ke Kerani Lesen untuk inform surat mohon ulasan lulus';
		EXEC [dbo].[SP_NotiReviewSurat] @Permohonan_ID, @JabatanAgensi_ID, 3;
	 END
	ELSE IF @kbApproval=0 AND @kbApproval_OLD IS NULL
	 BEGIN
		--print 'Send Email ke Kerani Lesen untuk inform surat mohon ulasan reject';
		EXEC [dbo].[SP_NotiReviewSurat] @Permohonan_ID, @JabatanAgensi_ID, 4;
	 END
	ELSE IF @kjApproval=1 AND @kjApproval_OLD IS NULL
	 BEGIN
		--print 'Send Email ke Kerani Lesen untuk inform surat mohon ulasan lulus';
		EXEC [dbo].[SP_NotiReviewSurat] @Permohonan_ID, @JabatanAgensi_ID, 3;
	 END
	ELSE IF @kjApproval=0 AND @kjApproval_OLD IS NULL
	 BEGIN
		--print 'Send Email ke Kerani Lesen untuk inform surat mohon ulasan reject';
		EXEC [dbo].[SP_NotiReviewSurat] @Permohonan_ID, @JabatanAgensi_ID, 4;
	 END
	ELSE
	 BEGIN
		--## Update Status ##--
		DECLARE @ApproverID int;
		--SELECT TOP 1 @ApproverID=Users_Id FROM TBL_USERS WHERE Users_Name='admin';
		SET @ApproverID=@PengesahID;

		IF @StatusID=3
			BEGIN
				UPDATE LESEN_ApprovalList SET IsComplete=1, ApproverID=@ikAssign, ApprovalDate=GETDATE()
				WHERE Permohonan_ID=@Permohonan_ID AND AgensiID=@JabatanAgensi_ID AND ApprStatusID=2
				AND IsComplete<>1;

				IF @IsLawatanTapakUlasan=0 AND @IsPenilaian=0
					BEGIN
						EXEC [dbo].[SP_NotiPermohonan] @Permohonan_ID, @JabatanAgensi_ID, 3;
					END
			END

		IF @IsLawatanTapakUlasan=1
			BEGIN
				UPDATE LESEN_ApprovalList SET IsComplete=1, ApproverID=@ApproverID, ApprovalDate=GETDATE()
				WHERE Permohonan_ID=@Permohonan_ID AND AgensiID=@JabatanAgensi_ID AND ApprStatusID=3--2
				AND IsComplete<>1;

				IF @IsLawatanTapakUlasan=1 AND @IsPenilaian=0
					BEGIN
						EXEC [dbo].[SP_NotiPermohonan] @Permohonan_ID, @JabatanAgensi_ID, 4--3;
					END
			END

		IF @IsPenilaian=1
			BEGIN
				UPDATE LESEN_ApprovalList SET IsComplete=1, ApproverID=@ApproverID, ApprovalDate=GETDATE()
				WHERE Permohonan_ID=@Permohonan_ID AND AgensiID=@JabatanAgensi_ID AND ApprStatusID=4--3
				AND IsComplete<>1;

				--IF @IsPenilaian=1 AND @IsPeraku=0 AND EXISTS(SELECT JabatanAgensi_ID FROM LESEN_JabatanAgensi WHERE JabatanAgensi_ID=@JabatanAgensi_ID AND JabatanAgensi_Type='J')
				--	BEGIN
				--		EXEC [dbo].[SP_NotiPermohonan] @Permohonan_ID, @JabatanAgensi_ID, 4;
				--	END
			END

		--IF @IsPeraku=1
		--	BEGIN
		--		UPDATE LESEN_ApprovalList SET IsComplete=1, ApproverID=@ApproverID, ApprovalDate=GETDATE()
		--		WHERE Permohonan_ID=@Permohonan_ID AND AgensiID=@JabatanAgensi_ID AND ApprStatusID=4 AND IsComplete<>1;
		--	END

		--IF NOT EXISTS(SELECT * FROM LESEN_ApprovalList WHERE Permohonan_ID=@Permohonan_ID AND ApprLevel=2 AND IsComplete<>1)
		IF NOT EXISTS(SELECT * FROM LESEN_ApprovalList WHERE Permohonan_ID=@Permohonan_ID AND ApprLevel=2 AND IsComplete<>1
			AND AgensiID IN (SELECT JabatanAgensi_ID FROM LESEN_PermohonanAgensi WHERE Permohonan_ID=@Permohonan_ID AND IsMandatory=1))
			AND EXISTS(SELECT Permohonan_ID FROM LESEN_Permohonan WHERE Permohonan_ID=@Permohonan_ID AND ISNULL(StatusID,0)<>0)
			BEGIN
				UPDATE LESEN_Permohonan SET StatusID=5, LastModID=@ApproverID, LastModDt=GETDATE()
				WHERE Permohonan_ID=@Permohonan_ID AND StatusID<5;
			END

		--## Kes 24 jam: dah lulus sementara oleh Pengesah, semua agensi selesai -> kembali ke Pengesah untuk kelulusan penuh ##--
		IF NOT EXISTS(SELECT * FROM LESEN_ApprovalList WHERE Permohonan_ID=@Permohonan_ID AND ApprLevel=2 AND IsComplete<>1)
			AND EXISTS(SELECT * FROM LESEN_Permohonan WHERE Permohonan_ID=@Permohonan_ID AND Is24Jam=1 AND StatusID=10
				AND Lulus24JamDt IS NOT NULL AND ISNULL(IsBatal,0)=0)
			BEGIN
				UPDATE LESEN_ApprovalList SET IsComplete=0, ApproverID=NULL, ApprovalDate=NULL
				WHERE Permohonan_ID=@Permohonan_ID AND ApprStatusID IN (5, 8, 10);

				UPDATE LESEN_Permohonan SET StatusID=5, StatusIDPengesah=NULL, LastModID='AUTO', LastModDt=GETDATE()
				WHERE Permohonan_ID=@Permohonan_ID AND StatusID=10;
			END
		--## END: Kes 24 jam ##--
		--## Update Status ##--
	 END


	--############### START: TAMBAH AGENSI LEPAS SUBMIT ################--
	DECLARE @ApprStatusID int;
	SELECT @ApprStatusID=StatusID FROM LESEN_Permohonan WHERE Permohonan_ID=@Permohonan_ID;

	IF @ApprStatusID>=1 AND @reviewStatusID=2 AND NOT EXISTS(SELECT * FROM LESEN_ApprovalList WHERE Permohonan_ID=@Permohonan_ID AND AgensiID=@JabatanAgensi_ID AND ApprLevel=2)
		BEGIN
			--## Agensi Dalaman ##--
			INSERT INTO LESEN_ApprovalList(Permohonan_ID, ApprStatusID, ApprLevel, AgensiID, ApproverID, IsComplete,
			ApprovalDate, IsFinalApproval, IsResult, Remarks, CreatorID, CreatedDt, LastModID, LastModDt)
			SELECT @Permohonan_ID, B.ApprStatusID, B.ApprLevel, A.JabatanAgensi_ID, NULL AS ApproverID, 0 AS IsComplete,
			NULL AS ApprovalDate, IsFinalApproval AS IsFinalApproval, IsResult AS IsResult, NULL AS Remarks,
			'AUTO' AS CreatorID, GETDATE() AS CreatedDt, 'AUTO' AS LastModID, GETDATE() AS LastModDt
			FROM LESEN_PermohonanAgensi A, ApprovalStatus B
			WHERE Permohonan_ID=@Permohonan_ID AND ApprLevel=2 AND A.JabatanAgensi_ID=@JabatanAgensi_ID
			AND JabatanAgensi_ID IN (SELECT JabatanAgensi_ID FROM LESEN_JabatanAgensi X WHERE A.JabatanAgensi_ID=X.JabatanAgensi_ID AND X.JabatanAgensi_Type='J' AND X.JabatanAgensi_IsActive=1);
			--## END: Agensi ##--

			--## Agensi Luar ##--
			INSERT INTO LESEN_ApprovalList(Permohonan_ID, ApprStatusID, ApprLevel, AgensiID, ApproverID, IsComplete,
			ApprovalDate, IsFinalApproval, IsResult, Remarks, CreatorID, CreatedDt, LastModID, LastModDt)
			SELECT @Permohonan_ID, B.ApprStatusID, B.ApprLevel, A.JabatanAgensi_ID, NULL AS ApproverID, 0 AS IsComplete,
			NULL AS ApprovalDate, IsFinalApproval AS IsFinalApproval, IsResult AS IsResult, NULL AS Remarks,
			'AUTO' AS CreatorID, GETDATE() AS CreatedDt, 'AUTO' AS LastModID, GETDATE() AS LastModDt
			FROM LESEN_PermohonanAgensi A, ApprovalStatus B
			WHERE Permohonan_ID=@Permohonan_ID AND ApprLevel=2 AND A.JabatanAgensi_ID=@JabatanAgensi_ID
			AND JabatanAgensi_ID IN (SELECT JabatanAgensi_ID FROM LESEN_JabatanAgensi X WHERE A.JabatanAgensi_ID=X.JabatanAgensi_ID AND X.JabatanAgensi_Type='L' AND X.JabatanAgensi_IsActive=1);
			--## END: Agensi ##--

			EXEC [dbo].[SP_NotiPermohonanAgensi] @Permohonan_ID, @JabatanAgensi_ID, @ApprStatusID;
		END
	--############### END: TAMBAH AGENSI LEPAS SUBMIT ################--
END
GO

--## View: status 11 'Semakan Agensi Belum Selesai' = 24 jam, lulus sementara, masih ada agensi belum selesai ##--
ALTER VIEW [dbo].[v_LESEN_ApprovalList_Curr]
AS
	--# Level=2
		SELECT ApprovalID, App.Permohonan_ID, A.ApprStatusID, B.Description, A.ApprLevel, AgensiID, ApproverID, ApprovalDate,
		IsComplete, A.IsFinalApproval, A.IsResult, Remarks, JenisLesen_ID, Permohonan_PemohonID, TarikhMohon, NotaKelulusan
		FROM LESEN_Permohonan App
		INNER JOIN LESEN_ApprovalList A ON App.Permohonan_ID=A.Permohonan_ID
		INNER JOIN ApprovalStatus B ON A.ApprStatusID=B.ApprStatusID
		WHERE A.IsComplete=0 AND A.ApprLevel=2
		AND EXISTS
		(
			SELECT * FROM
			(
				SELECT ROW_NUMBER() OVER(PARTITION BY Permohonan_ID, AgensiID ORDER BY Permohonan_ID, A.ApprStatusID, AgensiID) AS RowNo,
				ApprovalID, Permohonan_ID, A.ApprStatusID, B.Description, A.ApprLevel, AgensiID, ApproverID, ApprovalDate,
				IsComplete, A.IsFinalApproval, A.IsResult, Remarks, JenisLesen_ID, Permohonan_PemohonID, TarikhMohon, NotaKelulusan
				FROM LESEN_ApprovalList A
				INNER JOIN ApprovalStatus B ON A.ApprStatusID=B.ApprStatusID
				WHERE A.IsComplete=0 AND A.ApprLevel=2
			) tbl1 WHERE RowNo=1
			AND Permohonan_ID=App.Permohonan_ID AND ApprLevel=A.ApprLevel AND ApprStatusID=A.ApprStatusID AND AgensiID=A.AgensiID
		)
		UNION ALL
	--# Level<>2
		SELECT ApprovalID, App.Permohonan_ID, A.ApprStatusID, B.Description, A.ApprLevel, AgensiID, ApproverID, ApprovalDate,
		IsComplete, A.IsFinalApproval, A.IsResult, Remarks, JenisLesen_ID, Permohonan_PemohonID, TarikhMohon, NotaKelulusan
		FROM LESEN_Permohonan App
		INNER JOIN LESEN_ApprovalList A ON App.Permohonan_ID=A.Permohonan_ID
		INNER JOIN ApprovalStatus B ON A.ApprStatusID=B.ApprStatusID
		WHERE A.IsComplete=0 AND A.ApprLevel<>2
		/*AND EXISTS
		(
			SELECT * FROM
			(
				SELECT ROW_NUMBER() OVER(PARTITION BY Permohonan_ID ORDER BY Permohonan_ID, A.ApprStatusID, AgensiID) AS RowNo,
				ApprovalID, Permohonan_ID, A.ApprStatusID, B.Description, A.ApprLevel, AgensiID, ApproverID, ApprovalDate,
				IsComplete, A.IsFinalApproval, A.IsResult, Remarks--, JenisLesen_ID, Permohonan_PemohonID, TarikhMohon, NotaKelulusan
				FROM LESEN_ApprovalList A
				INNER JOIN ApprovalStatus B ON A.ApprStatusID=B.ApprStatusID
				WHERE A.IsComplete=0 AND A.IsResult=0
			) tbl1 WHERE RowNo=1
			AND tbl1.Permohonan_ID=App.Permohonan_ID AND tbl1.ApprLevel=A.ApprLevel AND tbl1.ApprStatusID=A.ApprStatusID
		)*/
		AND
		(
			EXISTS
			(
				SELECT * FROM
				(
					SELECT ROW_NUMBER() OVER(PARTITION BY Permohonan_ID ORDER BY Permohonan_ID, A.ApprStatusID, AgensiID) AS RowNo,
					ApprovalID, Permohonan_ID, A.ApprStatusID, B.Description, A.ApprLevel, AgensiID, ApproverID, ApprovalDate,
					IsComplete, A.IsFinalApproval, A.IsResult, Remarks--, JenisLesen_ID, Permohonan_PemohonID, TarikhMohon, NotaKelulusan
					FROM LESEN_ApprovalList A
					INNER JOIN ApprovalStatus B ON A.ApprStatusID=B.ApprStatusID
					WHERE A.IsComplete=0 AND A.IsResult=0
				) tbl1 WHERE RowNo=1
				AND tbl1.Permohonan_ID=App.Permohonan_ID AND tbl1.ApprLevel=A.ApprLevel AND tbl1.ApprStatusID=A.ApprStatusID
			)
		OR App.StatusID=A.ApprStatusID OR (App.StatusID=7 AND A.ApprStatusID=8)
		)
		AND NOT EXISTS (SELECT * FROM LESEN_ApprovalList WHERE Permohonan_ID=App.Permohonan_ID AND IsFinalApproval=1 AND IsComplete=1)
		UNION ALL
	--# Final Result
		SELECT ApprovalID, Permohonan_ID, ApprStatusID, Description, ApprLevel, AgensiID, ApproverID, ApprovalDate,
		IsComplete, IsFinalApproval, IsResult, Remarks, JenisLesen_ID, Permohonan_PemohonID, TarikhMohon, NotaKelulusan FROM
		(
			SELECT ROW_NUMBER() OVER(PARTITION BY App.Permohonan_ID ORDER BY App.Permohonan_ID, A.ApprStatusID DESC) AS RowNo,
			ApprovalID, App.Permohonan_ID, A.ApprStatusID, B.Description, A.ApprLevel, AgensiID, ApproverID, ApprovalDate,
			IsComplete, A.IsFinalApproval, A.IsResult, Remarks, JenisLesen_ID, Permohonan_PemohonID, TarikhMohon, NotaKelulusan
			FROM LESEN_Permohonan App
			INNER JOIN LESEN_ApprovalList A ON App.Permohonan_ID=A.Permohonan_ID
			INNER JOIN ApprovalStatus B ON A.ApprStatusID=B.ApprStatusID
			WHERE A.IsComplete=1 AND A.IsFinalApproval=1
		) tbl1 WHERE RowNo=1
		UNION ALL
	--# Kes 24 jam
		SELECT ApprovalID, Permohonan_ID, 11 AS ApprStatusID, 'Semakan Agensi Belum Selesai' AS Description, ApprLevel,
		AgensiID, ApproverID, ApprovalDate,
		IsComplete, IsFinalApproval, IsResult, Remarks, JenisLesen_ID, Permohonan_PemohonID, TarikhMohon, NotaKelulusan FROM
		(
			SELECT ROW_NUMBER() OVER(PARTITION BY App.Permohonan_ID ORDER BY App.Permohonan_ID, A.ApprStatusID DESC) AS RowNo,
			ApprovalID, App.Permohonan_ID, A.ApprStatusID, B.Description, A.ApprLevel, AgensiID, ApproverID, ApprovalDate,
			IsComplete, A.IsFinalApproval, A.IsResult, Remarks, JenisLesen_ID, Permohonan_PemohonID, TarikhMohon, NotaKelulusan
			FROM LESEN_Permohonan App
			INNER JOIN LESEN_ApprovalList A ON App.Permohonan_ID=A.Permohonan_ID
			INNER JOIN ApprovalStatus B ON A.ApprStatusID=B.ApprStatusID
			WHERE App.StatusID=10 AND App.Is24Jam=1
			AND EXISTS (SELECT * FROM LESEN_ApprovalList X WHERE X.Permohonan_ID=App.Permohonan_ID AND X.ApprLevel=2 AND X.IsComplete<>1)

		) tbl1 WHERE RowNo=1
		UNION ALL
	--# Kes 24 jam Pelarasan
		SELECT ApprovalID, Permohonan_ID, 12 AS ApprStatusID, 'Semakan Surat Pelarasan Kadar' AS Description, ApprLevel,
		AgensiID, ApproverID, ApprovalDate,
		IsComplete, IsFinalApproval, IsResult, Remarks, JenisLesen_ID, Permohonan_PemohonID, TarikhMohon, NotaKelulusan FROM
		(
			SELECT ROW_NUMBER() OVER(PARTITION BY App.Permohonan_ID ORDER BY App.Permohonan_ID, A.ApprStatusID DESC) AS RowNo,
			ApprovalID, App.Permohonan_ID, A.ApprStatusID, B.Description, A.ApprLevel, AgensiID, ApproverID, ApprovalDate,
			IsComplete, A.IsFinalApproval, A.IsResult, Remarks, JenisLesen_ID, Permohonan_PemohonID, TarikhMohon, NotaKelulusan
			FROM LESEN_Permohonan App
			INNER JOIN LESEN_ApprovalList A ON App.Permohonan_ID=A.Permohonan_ID
			INNER JOIN ApprovalStatus B ON A.ApprStatusID=B.ApprStatusID
			WHERE App.StatusID=10 AND App.Is24Jam=1
			AND App.IsPelarasan=1 AND ISNULL(App.IsKJAcknowledge,0)=0

		) tbl1 WHERE RowNo=1
GO
