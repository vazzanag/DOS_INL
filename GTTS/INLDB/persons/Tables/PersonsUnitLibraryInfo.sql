CREATE TABLE [persons].[PersonsUnitLibraryInfo]
(
	[PersonsUnitLibraryInfoID] BIGINT IDENTITY (1, 1) NOT NULL,
	[PersonID] BIGINT NOT NULL,
	[UnitID] BIGINT NOT NULL,
	[JobTitle] NVARCHAR(100) NULL,
	[YearsInPosition] INT NULL,
	[WorkEmailAddress] NVARCHAR(256) NULL,
	[RankID] INT NULL,
	[IsUnitCommander] BIT NULL DEFAULT (0),
	[PoliceMilSecID] NVARCHAR(100) NULL,
    [HostNationPOCName] NVARCHAR(256) NULL,
    [HostNationPOCEmail] NVARCHAR(256) NULL,
	[IsVettingReq] BIT NOT NULL DEFAULT (0),
	[IsLeahyVettingReq] BIT NOT NULL DEFAULT (0),
	[IsArmedForces] BIT NOT NULL DEFAULT (0),
	[IsLawEnforcement] BIT NOT NULL DEFAULT (0),
	[IsSecurityIntelligence] BIT NOT NULL DEFAULT (0),
    -- This column may not be needed at all.  Refer to Mark's Slack 
    -- Conversation with Oscar on Confluence.  Should this be changed to 
    -- ValidationStatus (NULL, 'In Process', 'Validated', 'Not Validated')?
	[IsValidated] BIT NOT NULL DEFAULT (0),
	[IsActive] BIT NOT NULL DEFAULT (1),
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),	
    CONSTRAINT [PK_PersonsUnitLibraryInfo] 
		PRIMARY KEY ([PersonsUnitLibraryInfoID]),	
	CONSTRAINT [FK_PersonsUnitLibraryInfo_Persons]
		FOREIGN KEY ([PersonID]) 
		REFERENCES [persons].[Persons]([PersonID]),
	CONSTRAINT [FK_PersonsUnitLibraryInfo_Units]
		FOREIGN KEY ([UnitID]) 
		REFERENCES [unitlibrary].[Units]([UnitID]),		
	CONSTRAINT [FK_PersonsUnitLibraryInfo_Ranks]
		FOREIGN KEY ([RankID]) 
		REFERENCES [persons].[Ranks]([RankID]),	
    CONSTRAINT [FK_PersonsUnitLibraryInfo_AppUsers_ModifiedByAppUserID]
		FOREIGN KEY ([ModifiedByAppUserID]) 
		REFERENCES [users].[AppUsers]([AppUserID]),
    CONSTRAINT [UC_PersonsUnit] 
		UNIQUE ([PersonID], [UnitID])        
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [persons].[PersonsUnitLibraryInfo_History]))
GO

CREATE INDEX [IDX_PersonID] ON [persons].[PersonsUnitLibraryInfo] ([PersonID] ASC)
	WITH (
			PAD_INDEX = OFF
			,STATISTICS_NORECOMPUTE = OFF
			,SORT_IN_TEMPDB = OFF
			,DROP_EXISTING = OFF
			,ONLINE = OFF
			,ALLOW_ROW_LOCKS = ON
			,ALLOW_PAGE_LOCKS = ON
			) ON [PRIMARY]
GO

CREATE INDEX [IDX_UnitID] ON [persons].[PersonsUnitLibraryInfo] ([UnitID] ASC)
	WITH (
			PAD_INDEX = OFF
			,STATISTICS_NORECOMPUTE = OFF
			,SORT_IN_TEMPDB = OFF
			,DROP_EXISTING = OFF
			,ONLINE = OFF
			,ALLOW_ROW_LOCKS = ON
			,ALLOW_PAGE_LOCKS = ON
			) ON [PRIMARY]
GO

CREATE INDEX [IDX_JobTitle] ON [persons].[PersonsUnitLibraryInfo] ([JobTitle] ASC)
	WITH (
			PAD_INDEX = OFF
			,STATISTICS_NORECOMPUTE = OFF
			,SORT_IN_TEMPDB = OFF
			,DROP_EXISTING = OFF
			,ONLINE = OFF
			,ALLOW_ROW_LOCKS = ON
			,ALLOW_PAGE_LOCKS = ON
			) ON [PRIMARY]
GO

CREATE INDEX [IDX_RankID] ON [persons].[PersonsUnitLibraryInfo] ([RankID] ASC)
	WITH (
			PAD_INDEX = OFF
			,STATISTICS_NORECOMPUTE = OFF
			,SORT_IN_TEMPDB = OFF
			,DROP_EXISTING = OFF
			,ONLINE = OFF
			,ALLOW_ROW_LOCKS = ON
			,ALLOW_PAGE_LOCKS = ON
			) ON [PRIMARY]
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'PersonsUnitLibraryInfo',
	@value = N'Cross reference table linking a Person to a specific Unit along with information specific to that relationship.';
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'PersonsUnitLibraryInfo',
    @level2type = N'COLUMN', @level2name = N'PersonsUnitLibraryInfoID',
	@value = N'Primary key & identity of the record in this table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'PersonsUnitLibraryInfo',
    @level2type = N'COLUMN', @level2name = N'PersonID',
	@value = N'Internal database ID of the person that the record is associated with.  Foreign key pointing to the Persons table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'PersonsUnitLibraryInfo',
    @level2type = N'COLUMN', @level2name = N'UnitID',
	@value = N'Indentifier of the unit that the Person is associated with at the time that the record was created.  Foreign key pointing to the Units table.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'PersonsUnitLibraryInfo',
	@level2type = N'COLUMN', @level2name = N'JobTitle',
	@value = N'Identifies the Person''s current Job Title (if applicable).'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'PersonsUnitLibraryInfo',
    @level2type = N'COLUMN', @level2name = N'YearsInPosition',
	@value = N'Number of years that the Person has held in the position identified by JobTitleID.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'PersonsUnitLibraryInfo',
    @level2type = N'COLUMN', @level2name = N'WorkEmailAddress',
	@value = N'Person''s work-specific email address at the time the record was created.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'PersonsUnitLibraryInfo',
	@level2type = N'COLUMN', @level2name = N'RankID',
	@value = N'Identifies the Person''s current rank (if applicable).  Foreign key pointing to the Ranks table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'PersonsUnitLibraryInfo',
    @level2type = N'COLUMN', @level2name = N'IsUnitCommander',
	@value = N'Boolean value that indicates if the Person is the commander of the unit referenced by UnitID'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'PersonsUnitLibraryInfo',
    @level2type = N'COLUMN', @level2name = N'PoliceMilSecID',
	@value = N'The Person''s Police, Military, or Security ID Number.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'PersonsUnitLibraryInfo',
    @level2type = N'COLUMN', @level2name = N'HostNationPOCName',
	@value = N'The Person''s host nation POC name'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'PersonsUnitLibraryInfo',
    @level2type = N'COLUMN', @level2name = N'HostNationPOCEmail',
	@value = N'The Person''s host nation POC email address'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'PersonsUnitLibraryInfo',
    @level2type = N'COLUMN', @level2name = N'IsVettingReq',
	@value = N'Boolean value that indicates if Local or Courtesy Vetting is required.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'PersonsUnitLibraryInfo',
    @level2type = N'COLUMN', @level2name = N'IsArmedForces',
	@value = N'Boolean value that indicates if the Person is a member of their nation''s uniformed military.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'PersonsUnitLibraryInfo',
    @level2type = N'COLUMN', @level2name = N'IsSecurityIntelligence',
	@value = N'Boolean value that indicates if the Person operates in the role security or intelligence.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'PersonsUnitLibraryInfo',
    @level2type = N'COLUMN', @level2name = N'IsValidated',
	@value = N'Boolean value that indicates if the record has been validated and should not be changed.  This is to prevent modifications to the record if vetting is in progress.'
GO

/*  IsActive column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'PersonsUnitLibraryInfo',
    @level2type = N'COLUMN', @level2name = N'IsActive',
	@value = N'Boolean value that indicates if the unit is current unit for the person as there are multiple records for a person in this table.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'PersonsUnitLibraryInfo',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the AppUsers table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'persons',
	@level1type = N'TABLE',  @level1name = N'PersonsUnitLibraryInfo',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'PersonsUnitLibraryInfo',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'PersonsUnitLibraryInfo',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO
