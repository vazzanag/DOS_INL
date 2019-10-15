/*
    **************************************************************************
    Notifications.sql
    **************************************************************************    
*/ 
CREATE TABLE [messaging].[Notifications]
(
    [NotificationID] BIGINT NOT NULL IDENTITY(1,1), 
    [NotificationContextTypeID] int NULL, 
    [ContextID] BIGINT,
    [NotificationMessageID] INT NOT NULL,
    [NotificationSubject] NVARCHAR(250) NULL, 
    [NotificationMessage] NVARCHAR(MAX) NOT NULL, 
    [EmailMessage] NVARCHAR(MAX) NULL, 
    [ModifiedByAppUserID] INT NOT NULL, 
    [ModifiedDate] DATETIME NOT NULL DEFAULT getutcdate(), 
    [SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),
    CONSTRAINT [PK_Notifications] 
        PRIMARY KEY CLUSTERED ([NotificationID] ASC)
            WITH (PAD_INDEX = OFF
                  ,STATISTICS_NORECOMPUTE = OFF
                  ,IGNORE_DUP_KEY = OFF
                  ,ALLOW_ROW_LOCKS = ON
				  ,ALLOW_PAGE_LOCKS = ON) ON [PRIMARY], 
    CONSTRAINT [FK_Notifications_NotificationMessages] FOREIGN KEY ([NotificationMessageID]) REFERENCES [messaging].[NotificationMessages]([NotificationMessageID]), 
    CONSTRAINT [FK_Notifications_NotificationContextTypes] FOREIGN KEY ([NotificationContextTypeID]) REFERENCES [messaging].[NotificationContextTypes]([NotificationContextTypeID]), 
    CONSTRAINT [FK_Notifications_AppUsers] FOREIGN KEY ([ModifiedByAppUserID]) REFERENCES [users].[AppUsers]([AppUserID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [messaging].[Notifications_History]))
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'Notifications',
	@value = N'Table to hold the notification application notifications used when sending notifications.'
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
    @level1type = N'TABLE',  @level1name = N'Notifications',
    @level2type = N'COLUMN', @level2name = N'NotificationID',
	@value = N'Primary key & identity of the record in this table.'
GO

/*  NotificationContextTypeID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'Notifications',
	@level2type = N'COLUMN', @level2name = N'NotificationContextTypeID',
	@value = N'Foreign Key reference to messaging.NotificationContextTypes.NotificationContextTypeID'
GO 

/*  ContextID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'Notifications',
	@level2type = N'COLUMN', @level2name = N'ContextID',
	@value = N'Reference key based on the NotificationContextTypeID'
GO 

/*  NotificationMessageID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'Notifications',
	@level2type = N'COLUMN', @level2name = N'NotificationMessageID',
	@value = N'Foreign Key to messaging.NotificationMessages.NotificationMessageID'
GO 

/*  NotificationSubject column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'Notifications',
	@level2type = N'COLUMN', @level2name = N'NotificationSubject',
	@value = N'Subject for notification'
GO 

/*  NotificationMessage column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'Notifications',
	@level2type = N'COLUMN', @level2name = N'NotificationMessage',
	@value = N'Stores the notification message for a given notification'
GO 

/*  EmailMessage column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'Notifications',
	@level2type = N'COLUMN', @level2name = N'EmailMessage',
	@value = N'Stores the email message for a given notification'
GO 

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
    @level1type = N'TABLE',  @level1name = N'Notifications',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the users.AppUsers table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'Notifications',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'Notifications',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'Notifications',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO 