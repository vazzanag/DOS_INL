CREATE TABLE [files].[FileTypes]
(
	[FileTypeID] INT IDENTITY (1,1) NOT NULL,
	[Name] NVARCHAR(200) NOT NULL,
	[Extension] NVARCHAR(200) NOT NULL,
	[Description] NVARCHAR(200) NOT NULL,
	[IsActive] BIT NOT NULL DEFAULT 1,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),
    CONSTRAINT [PK_FileTypes] 
		PRIMARY KEY ([FileTypeID]), 
	CONSTRAINT [UC_FileTypes1] 
		UNIQUE ([Name]),
	CONSTRAINT [UC_FileTypes2] 
		UNIQUE ([Extension])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [files].[FileTypes_History]))
GO

/*  Table Indexes  */
CREATE INDEX [IDX_FileTypeName] ON [files].[FileTypes] ([Name] ASC)
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
    @level0type = N'SCHEMA', @level0name = N'files',
    @level1type = N'TABLE',  @level1name = N'FileTypes',
	@value = N'Reference table of the different operating system file types for files listed in the Files table.'
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'files',
    @level1type = N'TABLE',  @level1name = N'FileTypes',
    @level2type = N'COLUMN', @level2name = N'FileTypeID',
	@value = N'Primary key & identity of the record in this table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'files',
    @level1type = N'TABLE',  @level1name = N'FileTypes',
    @level2type = N'COLUMN', @level2name = N'Name',
	@value = N'Descriptive short name of the filetype.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'files',
    @level1type = N'TABLE',  @level1name = N'FileTypes',
    @level2type = N'COLUMN', @level2name = N'Extension',
	@value = N'Operating system file type extension used to identify the type of file.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'files',
    @level1type = N'TABLE',  @level1name = N'FileTypes',
    @level2type = N'COLUMN', @level2name = N'Description',
	@value = N'Extended description of the filetype.'
GO

/*  IsActive column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'files',
    @level1type = N'TABLE',  @level1name = N'FileTypes',
    @level2type = N'COLUMN', @level2name = N'IsActive',
	@value = N'Boolean value that indicates if the record is currently active and in use.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'files',
	@level1type = N'TABLE',  @level1name = N'FileTypes',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the AppUsers table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'files',
	@level1type = N'TABLE',  @level1name = N'FileTypes',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'files',
	@level1type = N'TABLE',  @level1name = N'FileTypes',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'files',
	@level1type = N'TABLE',  @level1name = N'FileTypes',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO
