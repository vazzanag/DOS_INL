/*
    **************************************************************************
    ThreadContextTypes.sql
    **************************************************************************    
*/ 
CREATE TABLE [messaging].[NotificationContextTypes]
(
	[NotificationContextTypeID] INT IDENTITY (1,1) NOT NULL,
	[Name] NVARCHAR(50) NOT NULL,
	[IsActive] BIT NOT NULL DEFAULT 1,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT GETUTCDATE(),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),  
    CONSTRAINT [PK_NotificationContextTypes] 
		PRIMARY KEY ([NotificationContextTypeID]),
	CONSTRAINT [FK_NotificationContextTypes_AppUsers] 
		FOREIGN KEY ([ModifiedByAppUserID]) 
		REFERENCES [users].[AppUsers]([AppUserID]),	
	CONSTRAINT [UC_NotificationContextTypes] 
		UNIQUE ([Name])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [messaging].[NotificationContextTypes_History]))
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'NotificationContextTypes',
	@value = N'Notifications can be created within various contexts in the applicaiton.  This table holds lookup values for those notification contexts.'
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
    @level1type = N'TABLE',  @level1name = N'NotificationContextTypes',
    @level2type = N'COLUMN', @level2name = N'NotificationContextTypeID',
	@value = N'Primary key & identity of the record in this table.'
GO

/*  Name column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
    @level1type = N'TABLE',  @level1name = N'NotificationContextTypes',
    @level2type = N'COLUMN', @level2name = N'Name',
	@value = N'Identifies the name of notification context type'
GO

/*  IsActive column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'NotificationContextTypes',
	@level2type = N'COLUMN', @level2name = N'IsActive',
	@value = N'Identifies if this record should be active or not'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
    @level1type = N'TABLE',  @level1name = N'NotificationContextTypes',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the users.AppUsers table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'NotificationContextTypes',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'NotificationContextTypes',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'messaging',
	@level1type = N'TABLE',  @level1name = N'NotificationContextTypes',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO 