/*
    **************************************************************************
    MessageThreads.sql
    **************************************************************************    
*/ 
CREATE TABLE [messaging].[MessageThreads]
(
	[MessageThreadID] INT IDENTITY (1,1) NOT NULL,
	[MessageThreadTitle] NVARCHAR(500) NULL,
	[ThreadContextTypeID] INT NULL,
	[ThreadContextID] INT NULL,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT GETUTCDATE(),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),  
    CONSTRAINT [PK_MessageThreads] 
		PRIMARY KEY ([MessageThreadID]),
	CONSTRAINT [FK_MessageThreads_ThreadContextTypes] 
		FOREIGN KEY ([ThreadContextTypeID]) 
		REFERENCES [messaging].[ThreadContextTypes]([ThreadContextTypeID]),
	CONSTRAINT [FK_MessageThreads_AppUsers] 
		FOREIGN KEY ([ModifiedByAppUserID]) 
		REFERENCES [users].[AppUsers]([AppUserID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [messaging].[MessageThreads_History]))
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'MessageThreads',
	@value = N'Users can post messages to other users or other groups of users.  These messages are organized into message threads.  This table contains those threads.'
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
    @level1type = N'TABLE',  @level1name = N'MessageThreads',
    @level2type = N'COLUMN', @level2name = N'MessageThreadID',
	@value = N'Primary key & identity of the record in this table.'
GO

/*  MessageThreadTitle column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
    @level1type = N'TABLE',  @level1name = N'MessageThreads',
    @level2type = N'COLUMN', @level2name = N'MessageThreadTitle',
	@value = N'Identifies the title of the thread.'
GO

/*  ThreadContextTypeID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'MessageThreads',
	@level2type = N'COLUMN', @level2name = N'ThreadContextTypeID',
	@value = N'Identifies the thread context for this record.  Foreign key pointing to the messaging.ThreadContextType table.'
GO

/*  ThreadContextID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'MessageThreads',
	@level2type = N'COLUMN', @level2name = N'ThreadContextID',
	@value = N'The context identifier; e.g. if ThreadContext is a training event this column would contain the trainingEventID of that training event.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
    @level1type = N'TABLE',  @level1name = N'MessageThreads',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the users.AppUsers table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'MessageThreads',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'MessageThreads',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'MessageThreads',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO 