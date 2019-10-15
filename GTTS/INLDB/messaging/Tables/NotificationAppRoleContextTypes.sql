/*
    **************************************************************************
    NotificationAppRoleContextTypes.sql
    **************************************************************************    
*/
CREATE TABLE [messaging].[NotificationAppRoleContextTypes]
(
    [NotificationAppRoleContextTypeID] INT NOT NULL IDENTITY PRIMARY KEY, 
    [Code] NVARCHAR(25) NOT NULL, 
    [Description] NCHAR(255) NULL,
    [ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT sysutcdatetime(),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL, 
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),
    CONSTRAINT [FK_NotificationAppRoleContextTypes_AppUsers] FOREIGN KEY ([ModifiedByAppUserID]) REFERENCES [users].[AppUsers]([AppUserID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [messaging].[NotificationAppRoleContextTypes_History]))
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', 
    @level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'NotificationAppRoleContextTypes',
	@value = N'Lookup table to hold the context types of notification role routing in the application';
GO

/*  [NotificationAppRoleContextTypeID description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
    @level1type = N'TABLE',  @level1name = N'NotificationAppRoleContextTypes',
    @level2type = N'COLUMN', @level2name = N'NotificationAppRoleContextTypeID',
	@value = N'Primary key for this table'
GO

/*  Code column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
    @level1type = N'TABLE',  @level1name = N'NotificationAppRoleContextTypes',
	@level2type = N'COLUMN', @level2name = N'Code',
	@value = N'Internal code used to reference an app role context mapping'
GO

/*  Description column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
    @level1type = N'TABLE',  @level1name = N'NotificationAppRoleContextTypes',
	@level2type = N'COLUMN', @level2name = N'Description',
	@value = N'Description app role context mapping'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
    @level1type = N'TABLE',  @level1name = N'NotificationAppRoleContextTypes',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the users.AppUsers table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'NotificationAppRoleContextTypes',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'NotificationAppRoleContextTypes',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'NotificationAppRoleContextTypes',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO 