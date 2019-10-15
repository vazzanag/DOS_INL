/*
    **************************************************************************
    VettingFileAttachments.sql
    **************************************************************************    
*/   
CREATE TABLE [vetting].[VettingFileAttachments] 
(
    [VettingFileAttachmentID] BIGINT IDENTITY (1, 1) NOT NULL,
    [VettingBatchID] BIGINT NOT NULL, 
    [FileID] BIGINT NOT NULL, 
    [FileVersion] SMALLINT DEFAULT (1) NOT NULL, 
    [VettingAttachmentTypeID] SMALLINT NOT NULL, 
    [Description] NVARCHAR(500) NULL, 
    [IsDeleted] BIT DEFAULT '0' NULL, 
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),     
    CONSTRAINT [PK_VettingFileAttachments]
        PRIMARY KEY ([VettingFileAttachmentID]),
    CONSTRAINT [FK_VettingFileAttachments_Files]
        FOREIGN KEY ([FileID]) 
        REFERENCES [files].[Files] ([FileID]),
    CONSTRAINT [FK_VettingFileAttachments_VettingAttachmentTypes]
        FOREIGN KEY ([VettingAttachmentTypeID]) 
        REFERENCES [vetting].[VettingAttachmentTypes] ([VettingAttachmentTypeID]),
    CONSTRAINT [FK_VettingFileAttachments_VettingBatches]
        FOREIGN KEY ([VettingBatchID]) 
        REFERENCES [vetting].[VettingBatches] ([VettingBatchID]),
    CONSTRAINT [FK_VettingFileAttachments_AppUsers] 
        FOREIGN KEY ([ModifiedByAppUserID]) 
        REFERENCES [users].[AppUsers]([AppUserID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [vetting].[VettingFileAttachments_History]))
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'VettingFileAttachments',
	@value = N'Data table that contains pointer and tracking information about any documents or files specific to Vetting that have been uploaded into GTTS';
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingFileAttachments',
    @level2type = N'COLUMN', @level2name = N'VettingFileAttachmentID',
	@value = N'Primary key & identity of the record in this table.'
GO

-- OTHER COLUMNS DOCUMENTED HERE
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingFileAttachments',
    @level2type = N'COLUMN', @level2name = N'VettingBatchID',
	@value = N'Identifies the vetting batch that the attachment file is associated with.  Foreign key pointing to the VettingBatches table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingFileAttachments',
    @level2type = N'COLUMN', @level2name = N'FileID',
	@value = N'Identifies the record in the Files table that is directly associated with actual attachment file stored in Azure BLOB Storage.  Foreign key pointing to the Files table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingFileAttachments',
    @level2type = N'COLUMN', @level2name = N'FileVersion',
	@value = N'Identifies the version of the document contained in the attachment file.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingFileAttachments',
    @level2type = N'COLUMN', @level2name = N'VettingAttachmentTypeID',
	@value = N'Identifies that type of vetting attachment.  Foreign key pointing to the VettingAttachmentTypes reference table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingFileAttachments',
    @level2type = N'COLUMN', @level2name = N'Description',
	@value = N'Detailed description of the vetting attachment.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingFileAttachments',
    @level2type = N'COLUMN', @level2name = N'IsDeleted',
	@value = N'Boolean value that indicates if the attachment has been replaced by a newer version of the attachment.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'VettingFileAttachments',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the Users table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'VettingFileAttachments',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'VettingFileAttachments',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'VettingFileAttachments',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO