CREATE TABLE [training].[TrainingEventAttachments]
(
    [TrainingEventAttachmentID] BIGINT IDENTITY(1,1) NOT NULL,
    [TrainingEventID] BIGINT NOT NULL, 
    [FileID] BIGINT NOT NULL, 
    [FileVersion] SMALLINT NOT NULL, 
	[TrainingEventAttachmentTypeID] INT NOT NULL,
	[Description] NVARCHAR(500) NULL,
	[IsDeleted] BIT DEFAULT 0,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),
    CONSTRAINT [PK_TrainingEventAttachments] 
	PRIMARY KEY ([TrainingEventAttachmentID]),
    CONSTRAINT [FK_TrainingEventAttachments_TrainingEvents] 
		FOREIGN KEY ([TrainingEventID]) 
		REFERENCES [training].[TrainingEvents]([TrainingEventID]),
	CONSTRAINT [FK_TrainingEventAttachments_Files]
		FOREIGN KEY (FileID)
		REFERENCES [files].[Files]([FileID]),
    CONSTRAINT [FK_TrainingEventAttachments_TrainingEventAttachmentTypes] 
		FOREIGN KEY ([TrainingEventAttachmentTypeID]) 
		REFERENCES [training].[TrainingEventAttachmentTypes]([TrainingEventAttachmentTypeID]),
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [training].[TrainingEventAttachments_History]))
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level1type = N'TABLE', 
	@level0name = N'training', @level1name = N'TrainingEventAttachments',
	@value = N'The cross reference table joining uploaded files to training events.';
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventAttachments',
    @level2type = N'COLUMN', @level2name = N'TrainingEventAttachmentID',
	@value = N'The Primary key of the record in this table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventAttachments',
    @level2type = N'COLUMN', @level2name = N'TrainingEventID',
	@value = N'Indicates the Training Event that the file attachment is associated with.  Foreign key pointing to the TrainingEvents table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventAttachments',
    @level2type = N'COLUMN', @level2name = N'FileID',
	@value = N'Internal ID value from the Files table of the actual uploaded file.  Foreign key pointing to the Files table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventAttachments',
    @level2type = N'COLUMN', @level2name = N'FileVersion',
	@value = N'An integer version number for the file.  Everytime a user uploads a new version of the same document, the FileVersion value is incremented by 1..'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventAttachments',
    @level2type = N'COLUMN', @level2name = N'TrainingEventAttachmentTypeID',
	@value = N'Indicates the type of Training Event document.  Foreign key pointing to the TrainingEventAttachmentTypes table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventAttachments',
    @level2type = N'COLUMN', @level2name = N'Description',
	@value = N'Extended description of the specific file.  This description is provided by the user when they upload the file.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventAttachments',
    @level2type = N'COLUMN', @level2name = N'IsDeleted',
	@value = N'Boolean value that indicates if the record has been flagged as an old/deleted record.  If the record is current and active, this value will be FALSE (0).'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventAttachments',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the Users table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventAttachments',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventAttachments',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventAttachments',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO