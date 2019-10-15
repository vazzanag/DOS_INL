/*
    ************************************************************************** 
    UnitLevels.sql
    [unitlibrary].[UnitLevels] (Department, Agency, Bureau, Office, Division, Section, Section Unit, N/A)
    ************************************************************************** 
*/
CREATE TABLE [unitlibrary].[UnitLevels] 
(
    [UnitLevelID] SMALLINT IDENTITY (1, 1) NOT NULL,
    [Name] NVARCHAR(25) NOT NULL UNIQUE, 
    [Description] NVARCHAR(300) NOT NULL,
    [Level] TINYINT NOT NULL,
    [IsActive] BIT DEFAULT '1' NOT NULL,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),  
    CONSTRAINT [PK_UnitLevels]
        PRIMARY KEY ([UnitLevelID]),
    CONSTRAINT [FK_UnitLevels_AppUsers] 
        FOREIGN KEY ([ModifiedByAppUserID]) 
        REFERENCES [users].[AppUsers]([AppUserID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [unitlibrary].[UnitLevels_History]))
GO

CREATE INDEX [IDX_Name] ON [unitlibrary].[UnitLevels] ([Name] ASC)
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
	@level0type = N'SCHEMA', @level0name = N'unitlibrary',
	@level1type = N'TABLE',  @level1name = N'UnitLevels',
	@value = N'Reference table that holds the different identification strings for all of the different unit levels in the GTTS Unit Library.';
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'unitlibrary',
	@level1type = N'TABLE',  @level1name = N'UnitLevels',
    @level2type = N'COLUMN', @level2name = N'UnitLevelID',
	@value = N'Primary key & identity of the record in this table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'unitlibrary',
	@level1type = N'TABLE',  @level1name = N'UnitLevels',
    @level2type = N'COLUMN', @level2name = N'Name',
	@value = N'Short length string that identifies the unit level.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'unitlibrary',
	@level1type = N'TABLE',  @level1name = N'UnitLevels',
    @level2type = N'COLUMN', @level2name = N'Description',
	@value = N'Detail description of the unit level.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'unitlibrary',
	@level1type = N'TABLE',  @level1name = N'UnitLevels',
    @level2type = N'COLUMN', @level2name = N'Level',
	@value = N'Indicates the hierarchical position of the level relative to other UnitLevels.'
GO

/*  IsActive column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'unitlibrary',
	@level1type = N'TABLE',  @level1name = N'UnitLevels',
    @level2type = N'COLUMN', @level2name = N'IsActive',
	@value = N'Boolean value that indicates if the record is currently active and in use.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'unitlibrary',
	@level1type = N'TABLE',  @level1name = N'UnitLevels',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the Users table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'unitlibrary',
	@level1type = N'TABLE',  @level1name = N'UnitLevels',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'unitlibrary',
	@level1type = N'TABLE',  @level1name = N'UnitLevels',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'unitlibrary',
	@level1type = N'TABLE',  @level1name = N'UnitLevels',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO 