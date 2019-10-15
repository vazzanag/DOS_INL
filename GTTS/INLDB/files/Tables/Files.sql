CREATE TABLE [files].[Files]
(
	[FileID] BIGINT IDENTITY (1,1) NOT NULL,
	[FileName] NVARCHAR(200) NOT NULL,
    [FileTypeID] INT NOT NULL,
	[FileLocation] NVARCHAR(500) NOT NULL,
    [FileHash] VARBINARY(50) NOT NULL,
    [FileSize] INT NOT NULL,
    [FileVersion] SMALLINT DEFAULT(1) NOT NULL,
    [ThumbnailPath] NVARCHAR(200) NULL, 
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),
    CONSTRAINT [PK_Files] 
		PRIMARY KEY ([FileID]), 
	CONSTRAINT [FK_Files_FileTypes] 
		FOREIGN KEY ([FileTypeID]) 
		REFERENCES [files].[FileTypes]([FileTypeID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [files].[Files_History]))
GO

/*  Table Indexes  */
CREATE INDEX [IDX_FileName] ON [files].[Files] ([FileName] ASC)
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
    @level1type = N'TABLE',  @level1name = N'Files',
	@value = N'Data table for all files uploaded into the GTTS application.'
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'files',
    @level1type = N'TABLE',  @level1name = N'Files',
    @level2type = N'COLUMN', @level2name = N'FileID',
	@value = N'Primary key & identity of the record in this table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'files',
    @level1type = N'TABLE',  @level1name = N'Files',
    @level2type = N'COLUMN', @level2name = N'FileName',
	@value = N'Name of the file being uploaded.  This is the operating system name of the file as it exists on the user''s computer.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'files',
    @level1type = N'TABLE',  @level1name = N'Files',
    @level2type = N'COLUMN', @level2name = N'FileTypeID',
	@value = N'Indicates the operating system type of file.  Foreign key pointing to the FileTypes table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'files',
    @level1type = N'TABLE',  @level1name = N'Files',
    @level2type = N'COLUMN', @level2name = N'FileLocation',
	@value = N'Fully qualified path to the storage location of the file in Azure BLOB Storage.  Used by the application to provide a link to the file to the user.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'files',
    @level1type = N'TABLE',  @level1name = N'Files',
    @level2type = N'COLUMN', @level2name = N'FileHash',
	@value = N'A computed value that is used to ensure that the file was not changed during the upload/download process.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'files',
    @level1type = N'TABLE',  @level1name = N'Files',
    @level2type = N'COLUMN', @level2name = N'FileSize',
	@value = N'The size in bytes of the file attachment.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'files',
    @level1type = N'TABLE',  @level1name = N'Files',
    @level2type = N'COLUMN', @level2name = N'FileVersion',
	@value = N'An integer version number for the file.  Everytime a user uploads a new version of the same document, the FileVersion value is incremented by 1.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'files',
    @level1type = N'TABLE',  @level1name = N'Files',
    @level2type = N'COLUMN', @level2name = N'ThumbnailPath',
	@value = N'Fully qualified path to the storage location of the file''s icon in Azure BLOB Storage.  Used in the user interface as a graphical representation of the file.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'files',
	@level1type = N'TABLE',  @level1name = N'Files',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the AppUsers table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'files',
	@level1type = N'TABLE',  @level1name = N'Files',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'files',
	@level1type = N'TABLE',  @level1name = N'Files',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'files',
	@level1type = N'TABLE',  @level1name = N'Files',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO