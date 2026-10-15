/*
  Initial Database (globalmaster/humanResources/InitialDatabase.aspx)

  TBL_InitDbApi         : simpan SQL yang dijana oleh butang "Analisis struktur baru"
                    - INITDB_ANALYSIS : SQL semakan status setiap langkah pada DB sasaran
                    - INITDB_RUN      : SQL setiap langkah (dipisahkan dengan penanda /*@@STEP kod*/)
  tbl_sys_InitDbLog : log setiap langkah yang dijalankan oleh butang "Run script"

  Jalankan sekali pada DB sasaran (ilesen). Selamat dijalankan semula.
*/

IF OBJECT_ID('dbo.TBL_InitDbApi', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.TBL_InitDbApi (
        apiID          varchar(50)    NOT NULL CONSTRAINT PK_TBL_InitDbApi PRIMARY KEY,
        apiDescription nvarchar(200)  NULL,
        apiSQL         nvarchar(max)  NULL,
        apiNote        nvarchar(1000) NULL,
        apiStatus      bit            NOT NULL CONSTRAINT DF_TBL_InitDbApi_apiStatus DEFAULT (1),
        CreatorID      nvarchar(50)   NULL,
        CreatedDt      datetime       NOT NULL CONSTRAINT DF_TBL_InitDbApi_CreatedDt DEFAULT (GETDATE()),
        LastModID      nvarchar(50)   NULL,
        LastModDt      datetime       NULL
    );
END
GO

IF OBJECT_ID('dbo.tbl_sys_InitDbLog', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.tbl_sys_InitDbLog (
        LogID     int IDENTITY(1,1) NOT NULL CONSTRAINT PK_tbl_sys_InitDbLog PRIMARY KEY,
        RunID     varchar(40)    NOT NULL,
        StepCode  varchar(20)    NOT NULL,
        Kind      varchar(20)    NULL,
        ObjName   nvarchar(300)  NULL,
        StateBefore varchar(20)  NULL,
        Status    varchar(20)    NOT NULL,   -- SUCCESS / FAILED
        Message   nvarchar(max)  NULL,
        DurationMs int           NULL,
        RunBy     nvarchar(100)  NULL,
        RunDt     datetime       NOT NULL CONSTRAINT DF_tbl_sys_InitDbLog_RunDt DEFAULT (GETDATE())
    );
    CREATE INDEX IX_tbl_sys_InitDbLog_RunID ON dbo.tbl_sys_InitDbLog (RunID, StepCode);
END
GO
