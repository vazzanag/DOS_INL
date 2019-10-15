/*
    **************************************************************************
    MessageThreadMessages.sql
    **************************************************************************    
*/  
CREATE TABLE [messaging].[MessageThreadMessages]
(
	[MessageThreadMessageID] BIGINT IDENTITY (1,1) NOT NULL,
	[MessageThreadID] INT NOT NULL,
	[SenderAppUserID] INT NOT NULL,
	[SentTime] DATETIME NOT NULL DEFAULT GETUTCDATE(),
	[Message] TEXT NULL,
	[AttachmentFileID] BIGINT NULL,
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),  
    CONSTRAINT [PK_MessageThreadMessages] 
		PRIMARY KEY ([MessageThreadMessageID]),	
	CONSTRAINT [FK_MessageThreadMessages_MessageThreads] 
		FOREIGN KEY ([MessageThreadID]) 
		REFERENCES [messaging].[MessageThreads]([MessageThreadID]),	
	CONSTRAINT [FK_MessageThreadMessages_AppUsers] 
		FOREIGN KEY ([SenderAppUserID]) 
		REFERENCES [users].[AppUsers]([AppUserID]),	
	CONSTRAINT [FK_MessageThreadMessages_Files] 
		FOREIGN KEY ([AttachmentFileID]) 
		REFERENCES [files].[Files]([FileID]),
	CONSTRAINT [UC_MessageThreadMessages] 
		UNIQUE ([MessageThreadID], [SenderAppUserID], [SentTime])
)
ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [messaging].[MessageThreadMessages_History]))
GO
      
/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'MessageThreadMessages',
	@value = N'Users can post messages to other users or other groups of users.  These messages are organized into message threads.  This table contains the individual messages within a message thread.'
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
    @level1type = N'TABLE',  @level1name = N'MessageThreadMessages',
    @level2type = N'COLUMN', @level2name = N'MessageThreadMessageID',
	@value = N'Primary key & identity of the record in this table.'
GO

/*  MessageThreadID column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
    @level1type = N'TABLE',  @level1name = N'MessageThreadMessages',
    @level2type = N'COLUMN', @level2name = N'MessageThreadID',
	@value = N'Identifies the message thread this message belongs to.  Foreign key pointing to the MessageThreads table..'
GO

/*  SenderAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'MessageThreadMessages',
	@level2type = N'COLUMN', @level2name = N'SenderAppUserID',
	@value = N'Identifies the user who created the record.  Foreign key pointing to the users.Users table.'
GO

/*  SentTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'MessageThreadMessages',
	@level2type = N'COLUMN', @level2name = N'SentTime',
	@value = N'Date/Time when the record was created.'
GO

/*  Message column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'MessageThreadMessages',
	@level2type = N'COLUMN', @level2name = N'Message',
	@value = N'The text content of the message.'
GO

/*  AttachmentFileID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'MessageThreadMessages',
	@level2type = N'COLUMN', @level2name = N'AttachmentFileID',
	@value = N'If the message has a file attachment, this value points to the record in the Files table.  Foreign key pointing to the files.Files table.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'MessageThreadMessages',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'MessageThreadMessages',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO 