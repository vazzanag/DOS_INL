CREATE TABLE [persons].[JobTitles]
(
	[JobTitleID] INT IDENTITY (1, 1) NOT NULL,
    [CountryID] INT NOT NULL,  
	[JobTitleCode] NVARCHAR(25) NOT NULL,
    [JobTitleLocalLanguage] NVARCHAR(150) NOT NULL,
	[JobTitleEnglish] NVARCHAR(150) NULL, 
	[IsActive] BIT NOT NULL DEFAULT 1,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),	
    CONSTRAINT [PK_JobTitles] 
		PRIMARY KEY ([JobTitleID]),
	CONSTRAINT [FK_JobTitles_CountryID_Countries]
		FOREIGN KEY ([CountryID]) 
		REFERENCES [location].[Countries]([CountryID]),        
    CONSTRAINT [FK_JobTitles_AppUsers_ModifiedByAppUserID]
		FOREIGN KEY ([ModifiedByAppUserID]) 
		REFERENCES [users].[AppUsers]([AppUserID]),
    
    -- JobTitleCode is unique within a country.
    CONSTRAINT [UC_JobTitles_CountryID_JobTitleCode]
        UNIQUE ([CountryID], [JobTitleCode]),

    -- JobTitleTitleLocalLanguage is unique within a country.
    CONSTRAINT [UC_JobTitles_CountryID_JobTitleLocalLanguage]
        UNIQUE ([CountryID], [JobTitleLocalLanguage]),

    -- JobTitleEnglish is unique within a country.    
    CONSTRAINT [UC_JobTitles_CountryID_JobTitleEnglish]
        UNIQUE ([CountryID], [JobTitleEnglish])         
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [persons].[JobTitles_History]))
GO

CREATE INDEX [IDX_JobTitleCode] ON [persons].[JobTitles] ([JobTitleCode] ASC)
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

CREATE INDEX [IDX_JobTitleLocalLanguage] ON [persons].[JobTitles] ([JobTitleLocalLanguage] ASC)
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

CREATE INDEX [IDX_JobTitleEnglish] ON [persons].[JobTitles] ([JobTitleEnglish] ASC)
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
    @level1type = N'TABLE',  @level1name = N'JobTitles',
	@value = N'Reference table listing the different job titles in the database.'
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'JobTitles',
    @level2type = N'COLUMN', @level2name = N'JobTitleID',
	@value = N'Primary key & identity of the record in this table.'
GO

/*  Other data field descriptions  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'JobTitles',
	@level2type = N'COLUMN', @level2name = N'CountryID',
	@value = N'Identifies the country associated to the specified UnitID.  Foreign key pointing to the Countries table.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'JobTitles',
	@level2type = N'COLUMN', @level2name = N'JobTitleCode',
	@value = N'Short code representing the Job Title.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'JobTitles',
	@level2type = N'COLUMN', @level2name = N'JobTitleLocalLanguage',
	@value = N'Job Title in the local language.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'JobTitles',
	@level2type = N'COLUMN', @level2name = N'JobTitleEnglish',
	@value = N'Job Title in English.'
GO

/*  IsActive column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'JobTitles',
    @level2type = N'COLUMN', @level2name = N'IsActive',
	@value = N'Boolean value that indicates if the record is currently active and in use.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'JobTitles',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the AppUsers table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'persons',
	@level1type = N'TABLE',  @level1name = N'JobTitles',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'JobTitles',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'JobTitles',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO