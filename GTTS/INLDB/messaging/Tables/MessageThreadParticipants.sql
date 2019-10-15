/*
    **************************************************************************
    MessageThreadParticipants.sql
    **************************************************************************    
*/ 
CREATE TABLE [messaging].[MessageThreadParticipants]
(
	[MessageThreadID] INT NOT NULL,
	[AppUserID] INT NOT NULL,
	[Subscribed] BIT NOT NULL DEFAULT 1,
	[DateLastViewed] DATETIME NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (GETUTCDATE()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),  
    CONSTRAINT [PK_MessageThreadParticipants] 
		PRIMARY KEY ([MessageThreadID], [AppUserID]),	
	CONSTRAINT [FK_MessageThreadParticipants_MessageThreads] 
		FOREIGN KEY ([MessageThreadID]) 
		REFERENCES [messaging].[MessageThreads]([MessageThreadID]),	
	CONSTRAINT [FK_MessageThreadParticipants_AppUsers] 
		FOREIGN KEY ([AppUserID]) 
		REFERENCES [users].[AppUsers]([AppUserID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [messaging].[MessageThreadParticipants_History]))
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'MessageThreadParticipants',
	@value = N'This table holds the information related to the participants included in specific threads'
GO

/*  MessageThreadID description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
    @level1type = N'TABLE',  @level1name = N'MessageThreadParticipants',
    @level2type = N'COLUMN', @level2name = N'MessageThreadID',
	@value = N'Primary key in this table. Also a foreign key to messaging.MessageThreads table.'
GO

/*  AppUserID column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
    @level1type = N'TABLE',  @level1name = N'MessageThreadParticipants',
    @level2type = N'COLUMN', @level2name = N'AppUserID',
	@value = N'Identifies the participant of the thread.  Foreign key pointing to the users.AppUsers table.'
GO

/*  Subscribed column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'MessageThreadParticipants',
	@level2type = N'COLUMN', @level2name = N'Subscribed',
	@value = N'Identifies if the user has subscribed to this thread.'
GO

/*  DateLastViewed column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'MessageThreadParticipants',
	@level2type = N'COLUMN', @level2name = N'DateLastViewed',
	@value = N'Identifies the last time the user viewed the thread.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'MessageThreadParticipants',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'MessageThreadParticipants',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO 