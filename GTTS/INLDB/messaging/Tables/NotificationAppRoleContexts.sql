/*
    **************************************************************************
    NotificationAppRoleContexts.sql
    **************************************************************************    
*/ 
CREATE TABLE [messaging].[NotificationAppRoleContexts]
(
    [NotificationMessageID] INT NOT NULL , 
    [AppRoleID] INT NOT NULL, 
    [NotificationAppRoleContextTypeID] INT NOT NULL,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT sysutcdatetime(),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),
    CONSTRAINT [PK_NotificationAppRoleContexts] PRIMARY KEY ([NotificationMessageID], [AppRoleID]), 
    CONSTRAINT [FK_NotificationAppRoleContexts_NotificationMessages] 
        FOREIGN KEY ([NotificationMessageID]) 
        REFERENCES [messaging].[NotificationMessages]([NotificationMessageID]), 
    CONSTRAINT [FK_NotificationAppRoleContexts_NotificationAppRoleContextTypes] 
        FOREIGN KEY ([NotificationAppRoleContextTypeID]) 
        REFERENCES [messaging].[NotificationAppRoleContextTypes]([NotificationAppRoleContextTypeID]), 
    CONSTRAINT [FK_NotificationAppRoleContexts_AppUsers] FOREIGN KEY ([ModifiedByAppUserID]) REFERENCES [users].[AppUsers]([AppUserID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [messaging].[NotificationAppRoleContexts_History]))
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', 
    @level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'NotificationAppRoleContexts',
	@value = N'NotificationRedirects are used to determine the location of a notification link based on the role and message template';
GO

/*  NotificationMessageID description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
    @level1type = N'TABLE',  @level1name = N'NotificationAppRoleContexts',
    @level2type = N'COLUMN', @level2name = N'NotificationMessageID',
	@value = N'Foreign key to NotificationMessages table and part of the primary key for this table'
GO

/*  AppRoleID description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
    @level1type = N'TABLE',  @level1name = N'NotificationAppRoleContexts',
    @level2type = N'COLUMN', @level2name = N'AppRoleID',
	@value = N'Foreign key to users.AppUserRoles table and part of the primary key for this table'
GO

/*  NotificationAppRoleContextTypeID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
    @level1type = N'TABLE',  @level1name = N'NotificationAppRoleContexts',
	@level2type = N'COLUMN', @level2name = N'NotificationAppRoleContextTypeID',
	@value = N'Foreign key to messaging.NotificationApproleContextTypes'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
    @level1type = N'TABLE',  @level1name = N'NotificationAppRoleContexts',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the users.AppUsers table.'
GO


/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'NotificationAppRoleContexts',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'NotificationAppRoleContexts',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'NotificationAppRoleContexts',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO 