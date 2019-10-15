CREATE TABLE [location].[NationalIDFormats]
(
	[NationalIDFormatID] SMALLINT IDENTITY (1, 1) NOT NULL,
    [CountryID] INT NOT NULL,
	-- [RegExCode] NVARCHAR(500) NOT NULL,
	[RegExCode] NVARCHAR(100) NOT NULL,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),	
    CONSTRAINT [PK_NationalIDFormats] 
		PRIMARY KEY ([NationalIDFormatID]),
    CONSTRAINT [FK_NationalIDFormats_AppUsers_ModifiedByAppUserID]
		FOREIGN KEY ([ModifiedByAppUserID]) 
		REFERENCES [users].[AppUsers]([AppUserID]) 	
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [location].[NationalIDFormats_History]))
GO

CREATE INDEX [IDX_CountryID] ON [location].[NationalIDFormats] ([CountryID] ASC)
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
	@level0name = N'location', @level1name = N'NationalIDFormats',
	@value = N'Reference table listing national ID formating RegEx & Validation codes used by different countries in the database.'
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'NationalIDFormats',
    @level2type = N'COLUMN', @level2name = N'NationalIDFormatID',
	@value = N'Primary key & identity of the record in this table.'
GO

/*  Other data field descriptions  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'NationalIDFormats',
	@level2type = N'COLUMN', @level2name = N'CountryID',
	@value = N'Country that the name format record is associated with. Foreign key pointing to the Countries table.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'NationalIDFormats',
	@level2type = N'COLUMN', @level2name = N'RegExCode',
	@value = N'Regular expression (RegEx) string that validates if the value entered as a country''s national ID is formatted properly.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'NationalIDFormats',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the AppUsers table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'location',
	@level1type = N'TABLE',  @level1name = N'NationalIDFormats',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'NationalIDFormats',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'NationalIDFormats',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO
