CREATE TABLE [persons].[Ranks]
(
	[RankID] INT IDENTITY (1, 1) NOT NULL,
	[RankName] NVARCHAR(100) NOT NULL,
	[CountryID] INT NOT NULL,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),	
    CONSTRAINT [PK_Ranks] 
		PRIMARY KEY ([RankID]),
	CONSTRAINT [FK_Ranks_Countries]
		FOREIGN KEY ([CountryID]) 
		REFERENCES [location].[Countries]([CountryID]),	
    CONSTRAINT [FK_Ranks_AppUsers_ModifiedByAppUserID]
		FOREIGN KEY ([ModifiedByAppUserID]) 
		REFERENCES [users].[AppUsers]([AppUserID]) 	
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [persons].[Ranks_History]))
GO

CREATE INDEX [IDX_CountryID] ON [persons].[Ranks] ([CountryID] ASC)
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

CREATE INDEX [IDX_RankName] ON [persons].[Ranks] ([RankName] ASC)
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
	@level0type = N'SCHEMA', @level1type = N'TABLE', 
	@level0name = N'persons', @level1name = N'Ranks',
	@value = N'Reference table listing the different military, police, & other agency rank structure & hierarchy.'
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'Ranks',
    @level2type = N'COLUMN', @level2name = N'RankID',
	@value = N'Primary key & identity of the record in this table.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'Ranks',
	@level2type = N'COLUMN', @level2name = N'RankName',
	@value = N'Official Rank Name.'
GO

/*  Other data field descriptions  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'Ranks',
	@level2type = N'COLUMN', @level2name = N'CountryID',
	@value = N'Country that the rank record is associated with. Foreign key pointing to the Countries table.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'Ranks',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the AppUsers table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'persons',
	@level1type = N'TABLE',  @level1name = N'Ranks',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'Ranks',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'Ranks',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO
