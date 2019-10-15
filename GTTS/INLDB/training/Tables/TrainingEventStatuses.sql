CREATE TABLE [training].[TrainingEventStatuses]
(
	[TrainingEventStatusID] INT IDENTITY (1, 1) NOT NULL,
    [Name] NVARCHAR(100) NOT NULL, 
	[Description] NVARCHAR(255) NULL,
	[IsActive] BIT NOT NULL DEFAULT 1,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (sysutcdatetime()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),
    CONSTRAINT [PK_TrainingEventStatuses] 
		PRIMARY KEY ([TrainingEventStatusID]), 
    CONSTRAINT [FK_TrainingEventStatuses_AppUsers_ModifiedByAppUserID] 
		FOREIGN KEY ([ModifiedByAppUserID]) 
		REFERENCES [users].[AppUsers]([AppUserID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [training].[TrainingEventStatuses_History]))
GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level1type = N'TABLE', 
	@level0name = N'training', @level1name = N'TrainingEventStatuses',
	@value = N'Reference table for Training Event statuses.';
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Primary key & identity of the record in this table.',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventStatuses',
    @level2type = N'COLUMN', @level2name = N'TrainingEventStatusID'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Name or code identifying the type of training event.',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventStatuses',
    @level2type = N'COLUMN', @level2name = N'Name'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Extended description of the training event type code.',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventStatuses',
    @level2type = N'COLUMN', @level2name = N'Description'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Boolean value that indicates if the record is currently active and in use.',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventStatuses',
    @level2type = N'COLUMN', @level2name = N'IsActive'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the Users table.',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventStatuses',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventStatuses',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod fow which the record is valid.',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventStatuses',
	@level2type = N'COLUMN', @level2name = N'SysStartTime'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventStatuses',
	@level2type = N'COLUMN', @level2name = N'SysEndTime'
GO