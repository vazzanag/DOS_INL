/*
    **************************************************************************
    NotificationRecipients.sql
    **************************************************************************    
*/ 
CREATE TABLE [messaging].[NotificationRecipients]
(
    [NotificationID] BIGINT NOT NULL, 
    [AppUserID] INT NOT NULL, 
    [EmailSentDate] DATETIME NULL, 
    [ViewedDate] DATETIME NULL, 
    [ModifiedDate] DATETIME NOT NULL DEFAULT getutcdate(), 
    [SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),
    CONSTRAINT [PK_NotificationRecipoents] 
        PRIMARY KEY CLUSTERED ([NotificationID], [AppUserID] ASC)
            WITH (PAD_INDEX = OFF
                  ,STATISTICS_NORECOMPUTE = OFF
                  ,IGNORE_DUP_KEY = OFF
                  ,ALLOW_ROW_LOCKS = ON
				  ,ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
    CONSTRAINT [FK_NotificationRecipients_Notifications_NotificationsID] FOREIGN KEY ([NotificationID]) REFERENCES [messaging].[Notifications]([NotificationID]), 
    CONSTRAINT [FK_NotificationRecipients_AppUsers] FOREIGN KEY ([AppUserID]) REFERENCES [users].[AppUsers]([AppUserID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [messaging].[NotificationRecipients_History]))
GO


/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'NotificationRecipients',
	@value = N'Table to hold notification recipient information'
GO

/*  NotificationID column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
    @level1type = N'TABLE',  @level1name = N'NotificationRecipients',
    @level2type = N'COLUMN', @level2name = N'NotificationID',
	@value = N'Part of table Primary Key and Foreign Key reference to messaging.Notifications.NotificationID'
GO

/*  AppUserID column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
    @level1type = N'TABLE',  @level1name = N'NotificationRecipients',
    @level2type = N'COLUMN', @level2name = N'AppUserID',
	@value = N'Part of table Primary Key and Foreign Key reference to users.AppUsers.AppUserID'
GO

/*  EmailSentDate column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
    @level1type = N'TABLE',  @level1name = N'NotificationRecipients',
    @level2type = N'COLUMN', @level2name = N'EmailSentDate',
	@value = N'Date email notification was sent'
GO

/*  ViewedDate column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
    @level1type = N'TABLE',  @level1name = N'NotificationRecipients',
    @level2type = N'COLUMN', @level2name = N'ViewedDate',
	@value = N'Date notification was viewed'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'NotificationRecipients',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'NotificationRecipients',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'NotificationRecipients',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO 