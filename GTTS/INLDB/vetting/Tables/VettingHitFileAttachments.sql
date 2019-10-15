/*
    **************************************************************************
    VettingHitFileAttachments.sql
    **************************************************************************    
*/   
CREATE TABLE [vetting].[VettingHitFileAttachments] 
(
    [VettingHitFileAttachmentID] BIGINT IDENTITY (1, 1) NOT NULL,
    [VettingHitID] BIGINT NOT NULL, 
    [FileID] BIGINT NOT NULL, 
    [FileVersion] SMALLINT DEFAULT (1) NOT NULL, 
    [Description] NVARCHAR(500) NULL, 
    [IsDeleted] BIT DEFAULT '0' NULL, 
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),     
    CONSTRAINT [PK_VettingHitFileAttachments]
        PRIMARY KEY ([VettingHitFileAttachmentID]),
    CONSTRAINT [FK_VettingHitFileAttachments_VettingHits]
        FOREIGN KEY ([VettingHitID]) 
        REFERENCES [vetting].[VettingHits] ([VettingHitID]),      
    CONSTRAINT [FK_VettingHitFileAttachments_Files]
        FOREIGN KEY ([FileID]) 
        REFERENCES [files].[Files] ([FileID]),  
    CONSTRAINT [FK_VettingHitFileAttachments_AppUsers] 
        FOREIGN KEY ([ModifiedByAppUserID]) 
        REFERENCES [users].[AppUsers]([AppUserID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [vetting].[VettingHitFileAttachments_History]))
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'VettingHitFileAttachments',
	@value = N'Data table that contains pointer and tracking information about any documents or files specific to a Vetting Hit that have been uploaded into GTTS';
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingHitFileAttachments',
    @level2type = N'COLUMN', @level2name = N'VettingHitFileAttachmentID',
	@value = N'Primary key & identity of the record in this table.'
GO

-- OTHER COLUMNS DOCUMENTED HERE
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingHitFileAttachments',
    @level2type = N'COLUMN', @level2name = N'VettingHitID',
	@value = N'Identifies the vetting hit that the attachment file is associated with.  Foreign key pointing to the VettingHits table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingHitFileAttachments',
    @level2type = N'COLUMN', @level2name = N'FileID',
	@value = N'Identifies the record in the Files table that is directly associated with actual attachment file stored in Azure BLOB Storage.  Foreign key pointing to the Files table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingHitFileAttachments',
    @level2type = N'COLUMN', @level2name = N'FileVersion',
	@value = N'Identifies the version of the document contained in the attachment file.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingHitFileAttachments',
    @level2type = N'COLUMN', @level2name = N'Description',
	@value = N'Detailed description of the vetting hit attachment.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingHitFileAttachments',
    @level2type = N'COLUMN', @level2name = N'IsDeleted',
	@value = N'Boolean value that indicates if the attachment has been replaced by a newer version of the attachment.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'VettingHitFileAttachments',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the Users table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'VettingHitFileAttachments',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'VettingHitFileAttachments',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'VettingHitFileAttachments',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO