CREATE TABLE [training].[TrainingEventStatusLog]
(
	[TrainingEventStatusLogID] BIGINT IDENTITY (1, 1) NOT NULL, 
	[TrainingEventID] BIGINT NOT NULL, 
    [TrainingEventStatusID] INT NOT NULL,
    [ReasonStatusChanged] NVARCHAR(750),
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
    CONSTRAINT [PK_TrainingEventStatusLog] 
		PRIMARY KEY ([TrainingEventStatusLogID]), 
    CONSTRAINT [FK_TrainingEventStatusLog_TrainingEvents] 
		FOREIGN KEY ([TrainingEventID]) 
		REFERENCES [training].[TrainingEvents]([TrainingEventID]),
    CONSTRAINT [FK_TrainingEventStatusLog_TrainingEventStatuses] 
		FOREIGN KEY ([TrainingEventStatusID]) 
		REFERENCES [training].[TrainingEventStatuses]([TrainingEventStatusID]), 
    CONSTRAINT [FK_TrainingEventStatusLog_AppUsers_ModifiedByAppUserID] 
		FOREIGN KEY ([ModifiedByAppUserID]) 
		REFERENCES [users].[AppUsers]([AppUserID])
);
GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level1type = N'TABLE', 
	@level0name = N'training', @level1name = N'TrainingEventStatusLog',
	@value = N'A training event''s status history.';
GO

/*  TrainingEventStatusLogID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'Primary key & identity of the record in this table.',
    @level0type = N'SCHEMA',  @level0name = N'training',
    @level1type = N'TABLE',   @level1name = N'TrainingEventStatusLog',
	@level2type = N'COLUMN',  @level2name = N'TrainingEventStatusLogID'
GO

/*  TrainingEventID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'Identifies the Training Event that is associated with the record.  Foreign key pointing to the TrainingEvents table.',
    @level0type = N'SCHEMA',  @level0name = N'training',
    @level1type = N'TABLE',   @level1name = N'TrainingEventStatusLog',
	@level2type = N'COLUMN',  @level2name = N'TrainingEventID'
GO

/*  TrainingEventStatusID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'Identifies the Training Event status that is associated with the record.  Foreign key pointing to the TrainingEventStatuses table.',
    @level0type = N'SCHEMA',  @level0name = N'training',
    @level1type = N'TABLE',   @level1name = N'TrainingEventStatusLog',
	@level2type = N'COLUMN',  @level2name = N'TrainingEventStatusID'
GO

/*  ReasonStatusChanged column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'Identifies a reason why a status was changed.',
    @level0type = N'SCHEMA',  @level0name = N'training',
    @level1type = N'TABLE',   @level1name = N'TrainingEventStatusLog',
	@level2type = N'COLUMN',  @level2name = N'ReasonStatusChanged'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the Users table.',
    @level0type = N'SCHEMA',  @level0name = N'training',
    @level1type = N'TABLE',   @level1name = N'TrainingEventStatusLog',
	@level2type = N'COLUMN',  @level2name = N'ModifiedByAppUserID'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventStatusLog',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO