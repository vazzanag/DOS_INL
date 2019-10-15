/*
    **************************************************************************
    PersonsVettingVettingTypes.sql
    **************************************************************************    
*/        
CREATE TABLE [vetting].[PersonsVettingVettingTypes] 
(
    [PersonsVettingID] BIGINT NOT NULL,
    [VettingTypeID] SMALLINT NOT NULL, 
	[CourtesyVettingSkipped] BIT NOT NULL DEFAULT 0,
	[CourtesyVettingSkippedComments] NVARCHAR(MAX) NULL,
	[HitResultID] TINYINT NULL,             -- FK to [VettingHitResults] table
    [HitResultDetails] NVARCHAR(MAX) NULL,    
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),     
    CONSTRAINT [PK_PersonsVettingVettingTypes]
        PRIMARY KEY ([PersonsVettingID], [VettingTypeID]),
    CONSTRAINT [FK_PersonsVettingVettingTypes_PersonsVetting] 
        FOREIGN KEY ([PersonsVettingID]) 
        REFERENCES [vetting].[PersonsVetting]([PersonsVettingID]),        
    CONSTRAINT [FK_PersonsVettingVettingTypes_VettingTypes] 
        FOREIGN KEY ([VettingTypeID]) 
        REFERENCES [vetting].[VettingTypes]([VettingTypeID]),
	CONSTRAINT [FK_VettingHits_VettingHitResults]
		FOREIGN KEY ([HitResultID]) 
		REFERENCES [vetting].[VettingHitResults]([HitResultID]),
    CONSTRAINT [FK_PersonsVettingVettingType_AppUsers] 
        FOREIGN KEY ([ModifiedByAppUserID]) 
        REFERENCES [users].[AppUsers]([AppUserID])       
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [vetting].[PersonsVettingVettingTypes_History]))
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'PersonsVettingVettingTypes',
	@value = N'Identifies the specific vetting units associated with a specific PersonsVetting record.';
GO

/*  Primary Key description fields */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'PersonsVettingVettingTypes',
    @level2type = N'COLUMN', @level2name = N'PersonsVettingID',
	@value = N'First half of the Primary key in this table. Foreign key pointing to the PersonsVetting table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'PersonsVettingVettingTypes',
    @level2type = N'COLUMN', @level2name = N'CourtesyVettingSkipped',
	@value = N'Boolean value that indicates if coutesy vetting is skipped for the person'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'PersonsVettingVettingTypes',
    @level2type = N'COLUMN', @level2name = N'CourtesyVettingSkippedComments',
	@value = N'Comments entered by the user when coutesy vetting is skipped is updated for the person.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'PersonsVettingVettingTypes',
    @level2type = N'COLUMN', @level2name = N'VettingTypeID',
	@value = N'Second half of the Primary key in this table. Foreign key pointing to the VettingTypes table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'PersonsVettingVettingTypes',
    @level2type = N'COLUMN', @level2name = N'HitResultID',
	@value = N'Identifies the result of the hit returned.  Foreign key pointing to the [VettingHitResults] table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'PersonsVettingVettingTypes',
    @level2type = N'COLUMN', @level2name = N'HitResultDetails',
	@value = N'Specific notes or comments about the hit result determinaton.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'PersonsVettingVettingTypes',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the Users table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'PersonsVettingVettingTypes',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'PersonsVettingVettingTypes',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'PersonsVettingVettingTypes',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO 