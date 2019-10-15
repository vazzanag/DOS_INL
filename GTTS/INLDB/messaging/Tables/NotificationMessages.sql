/*
    **************************************************************************
    NotificationMessages.sql
    **************************************************************************    
*/ 
CREATE TABLE [messaging].[NotificationMessages]
(
    [NotificationMessageID] INT NOT NULL IDENTITY(1,1), 
    [Code] NVARCHAR(50) NOT NULL,
    [MessageTemplateName] NVARCHAR(50) NOT NULL,
    [MessageTemplate] NVARCHAR(MAX) NOT NULL, 
    [IncludeContextLink] BIT NOT NULL DEFAULT 0,
    [ModifiedDate] DATETIME NOT NULL DEFAULT getutcdate(), 
    [ModifiedByAppUserID] INT NOT NULL,
    [SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),
    CONSTRAINT [PK_NotificationMessages] 
        PRIMARY KEY CLUSTERED ([NotificationMessageID] ASC)
            WITH (PAD_INDEX = OFF
                  ,STATISTICS_NORECOMPUTE = OFF
                  ,IGNORE_DUP_KEY = OFF
                  ,ALLOW_ROW_LOCKS = ON
				  ,ALLOW_PAGE_LOCKS = ON) ON [PRIMARY], 
    CONSTRAINT [FK_NotificationMessages_AppUsers] FOREIGN KEY ([ModifiedByAppUserID]) REFERENCES [users].[AppUsers]([AppUserID]),
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [messaging].[NotificationMessages_History]))
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'NotificationMessages',
	@value = N'Table to hold the notification message templates used when sending notifications.'
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
    @level1type = N'TABLE',  @level1name = N'NotificationMessages',
    @level2type = N'COLUMN', @level2name = N'NotificationMessageID',
	@value = N'Primary key & identity of the record in this table.'
GO

/*  Code column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
    @level1type = N'TABLE',  @level1name = N'NotificationMessages',
    @level2type = N'COLUMN', @level2name = N'Code',
	@value = N'Internal code used to reference a template'
GO

/*  MessageTemplateName column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
    @level1type = N'TABLE',  @level1name = N'NotificationMessages',
    @level2type = N'COLUMN', @level2name = N'MessageTemplateName',
	@value = N'Name of the notification template'
GO

/*  MessageTemplate column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
    @level1type = N'TABLE',  @level1name = N'NotificationMessages',
    @level2type = N'COLUMN', @level2name = N'MessageTemplate',
	@value = N'Holds the message template data'
GO

/*  IncludeContextLink column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
    @level1type = N'TABLE',  @level1name = N'NotificationMessages',
    @level2type = N'COLUMN', @level2name = N'IncludeContextLink',
	@value = N'Flag to determine if this template has a link to its context'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
    @level1type = N'TABLE',  @level1name = N'NotificationMessages',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the users.AppUsers table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'NotificationMessages',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'NotificationMessages',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'NotificationMessages',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO 