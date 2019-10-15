CREATE TABLE [location].[NameFormats]
(
	[NameFormatID] SMALLINT IDENTITY (1, 1) NOT NULL,
	[NameFormat] NVARCHAR(75) NOT NULL,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),	
    CONSTRAINT [PK_NameFormats] 
		PRIMARY KEY ([NameFormatID]),    
    CONSTRAINT [FK_NameFormats_AppUsers_ModifiedByAppUserID]
		FOREIGN KEY ([ModifiedByAppUserID]) 
		REFERENCES [users].[AppUsers]([AppUserID]) 	
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [location].[NameFormats_History]))
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level1type = N'TABLE', 
	@level0name = N'location', @level1name = N'NameFormats',
	@value = N'Reference table listing name format structures used by different countries in the database.'
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'NameFormats',
    @level2type = N'COLUMN', @level2name = N'NameFormatID',
	@value = N'Primary key & identity of the record in this table.'
GO

/*  Other data field descriptions  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'NameFormats',
	@level2type = N'COLUMN', @level2name = N'NameFormat',
	@value = N'Comma-delimited string value depicting the primary ordering of the 5 GTTS name fields.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'NameFormats',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the AppUsers table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'location',
	@level1type = N'TABLE',  @level1name = N'NameFormats',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'NameFormats',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'NameFormats',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO