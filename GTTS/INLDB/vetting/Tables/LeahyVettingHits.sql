/*
    **************************************************************************
    LeahyVettingHits.sql
    **************************************************************************    
*/     
CREATE TABLE [vetting].[LeahyVettingHits] 
(
	[LeahyVettingHitID] BIGINT IDENTITY (1, 1) NOT NULL,
    [PersonsVettingID] BIGINT NOT NULL,		-- FK to [PersonsVetting] table
    [CaseID] NVARCHAR(25) NULL,     
    [LeahyHitResultID] TINYINT NULL,        -- FK to [VettingLeahyHitResults] table
    [LeahyHitAppliesToID] TINYINT NULL,     -- FK to [VettingLeahyHitAppliesTo] table
    [ViolationTypeID] TINYINT NULL,         -- FK to [VettingHitViolationTypes] table
    [CertDate] DATETIME NULL,
    [ExpiresDate] DATETIME NULL,    
    [Summary] NVARCHAR(MAX) NULL,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),     
    CONSTRAINT [PK_LeahyVettingHits]
        PRIMARY KEY ([LeahyVettingHitID]),    
    CONSTRAINT [FK_LeahyVettingHits_PersonsVetting]
        FOREIGN KEY ([PersonsVettingID]) 
        REFERENCES [vetting].[PersonsVetting] ([PersonsVettingID]),        
    CONSTRAINT [FK_LeahyVettingHits_VettingLeahyHitResults]
        FOREIGN KEY ([LeahyHitResultID]) 
        REFERENCES [vetting].[VettingLeahyHitResults] ([LeahyHitResultID]),        
    CONSTRAINT [FK_LeahyVettingHits_VettingLeahyHitAppliesTo]
        FOREIGN KEY ([LeahyHitAppliesToID]) 
        REFERENCES [vetting].[VettingLeahyHitAppliesTo] ([LeahyHitAppliesToID]),
	CONSTRAINT [FK_LeahyVettingHits_VettingHitViolationTypes]
		FOREIGN KEY ([ViolationTypeID]) 
		REFERENCES [vetting].[VettingHitViolationTypes]([ViolationTypeID]),        
    CONSTRAINT [FK_LeahyVettingHits_AppUsers_ModifiedByAppUserID] 
        FOREIGN KEY ([ModifiedByAppUserID]) 
        REFERENCES [users].[AppUsers]([AppUserID]),
	CONSTRAINT [UC_LeahyVettingHits_PersonsVettingID] 
        UNIQUE ([PersonsVettingID]) 
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [vetting].[LeahyVettingHits_History]))
GO       

CREATE FULLTEXT INDEX ON [vetting].[LeahyVettingHits] (Summary) 
    KEY INDEX [PK_LeahyVettingHits] ON [FullTextCatalog] 
    WITH CHANGE_TRACKING AUTO
GO
        
/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'LeahyVettingHits',
	@value = N'Data table that holds all of the Leahy vetting results from the INVEST system for a specific Person (via the PersonsVetting table)';
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'LeahyVettingHits',
    @level2type = N'COLUMN', @level2name = N'LeahyVettingHitID',
	@value = N'Primary key & identity of the record in this table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'LeahyVettingHits',
    @level2type = N'COLUMN', @level2name = N'PersonsVettingID',
	@value = N'Identifies the specific Person (via the PersonsVetting table) that the vetting result is associated with.  Foreign key pointing to the [PersonsVetting] table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'LeahyVettingHits',
    @level2type = N'COLUMN', @level2name = N'CaseID',
	@value = N'Identifies a specific INVEST Case Number that the Leahy result is based on.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'LeahyVettingHits',
    @level2type = N'COLUMN', @level2name = N'LeahyHitResultID',
	@value = N'Identifies the Leahy Vetting result from the Leahy INVEST system.  Foreign key pointing to the [VettingLeahyHitResults] table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'LeahyVettingHits',
    @level2type = N'COLUMN', @level2name = N'LeahyHitAppliesToID',
	@value = N'Identifies whether the Leahy Hit applies to an Individual, Unit, or both.  Foreign key pointing to the [VettingLeahyHitAppliesTo] table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'LeahyVettingHits',
    @level2type = N'COLUMN', @level2name = N'ViolationTypeID',
	@value = N'Identifies the type of violation that the hit returned.  Foreign key pointing to the [VettingHitViolationTypes] table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'LeahyVettingHits',
    @level2type = N'COLUMN', @level2name = N'CertDate',
	@value = N'Date in MM/DD/YYYY format that identifies when the curent Leahy Vetting status was effective from.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'LeahyVettingHits',
    @level2type = N'COLUMN', @level2name = N'ExpiresDate',
	@value = N'Date in MM/DD/YYYY format that identifies when the Leahy Vetting status expires.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'LeahyVettingHits',
    @level2type = N'COLUMN', @level2name = N'Summary',
	@value = N'Summary and notes about the Leahy Vetting results entered by the Vetting Unit.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'LeahyVettingHits',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the Users table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'LeahyVettingHits',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'LeahyVettingHits',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'LeahyVettingHits',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO