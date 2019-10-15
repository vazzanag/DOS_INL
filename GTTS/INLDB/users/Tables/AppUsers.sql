CREATE TABLE [users].[AppUsers]
(
    [AppUserID] INT NOT NULL IDENTITY(1, 1), 
    [ADOID] NVARCHAR(100) NOT NULL UNIQUE,
    [First] NVARCHAR(35) NOT NULL, 
    [Middle] NVARCHAR(35) NULL, 
    [Last] NVARCHAR(50) NOT NULL, 
    [PositionTitle] NVARCHAR(200) NULL,
    [EmailAddress] NVARCHAR(75) NULL, 
	[PhoneNumber] NVARCHAR(50) NULL,
    [PicturePath] NVARCHAR(200) NULL, 
    [CountryID] INT NOT NULL,
    [PostID] INT NULL,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (GETUTCDATE()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (SYSUTCDATETIME()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),	
	CONSTRAINT [PK_AppUsers] 
		PRIMARY KEY ([AppUserID]), 
    CONSTRAINT [FK_AppUsers_Countries] 
		FOREIGN KEY ([CountryID]) 
		REFERENCES [location].[Countries](CountryID),	
    CONSTRAINT [FK_AppUsers_Posts] 
		FOREIGN KEY ([PostID])
		REFERENCES [location].[Posts](PostID), 
    CONSTRAINT [FK_AppUsers_AppUsers_ModifiedByAppUserID] 
		FOREIGN KEY ([ModifiedByAppUserID]) 
		REFERENCES [users].[AppUsers]([AppUserID])
   
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [users].[AppUsers_History]))
GO

CREATE FULLTEXT INDEX ON [users].[AppUsers] ([First], [Middle], [Last]) 
        KEY INDEX [PK_AppUsers] ON [FullTextCatalog] 
        WITH CHANGE_TRACKING AUTO
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'users',
	@level1type = N'TABLE',  @level1name = N'AppUsers',
	@value = N'Data table of users.';
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'users',
    @level1type = N'TABLE',  @level1name = N'AppUsers',
    @level2type = N'COLUMN', @level2name = N'AppUserID',
	@value = N'Primary key & identity of the record in this table.'
GO

/*  Other data field descriptions  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'users',
    @level1type = N'TABLE',  @level1name = N'AppUsers',
    @level2type = N'COLUMN', @level2name = N'ADOID',
	@value = N'Object ID from Active Directory.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'users',
    @level1type = N'TABLE',  @level1name = N'AppUsers',
    @level2type = N'COLUMN', @level2name = N'First',
	@value = N'User''s first or given name.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'users',
    @level1type = N'TABLE',  @level1name = N'AppUsers',
    @level2type = N'COLUMN', @level2name = N'Middle',
	@value = N'User''s middle name (if applicable).'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'users',
    @level1type = N'TABLE',  @level1name = N'AppUsers',
    @level2type = N'COLUMN', @level2name = N'Last',
	@value = N'User''s last or family name.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'users',
    @level1type = N'TABLE',  @level1name = N'AppUsers',
    @level2type = N'COLUMN', @level2name = N'EmailAddress',
	@value = N'User''s work-related email address.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'users',
    @level1type = N'TABLE',  @level1name = N'AppUsers',
    @level2type = N'COLUMN', @level2name = N'PhoneNumber',
	@value = N'User''s work-related telephone number (and extension if there is one).'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'users',
    @level1type = N'TABLE',  @level1name = N'AppUsers',
    @level2type = N'COLUMN', @level2name = N'PicturePath',
	@value = N'Fully qualified path to the storage location of the user''s photo in Azure BLOB Storage.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'users',
    @level1type = N'TABLE',  @level1name = N'AppUsers',
    @level2type = N'COLUMN', @level2name = N'PositionTitle',
	@value = N'User''s position title.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'users',
    @level1type = N'TABLE',  @level1name = N'AppUsers',
    @level2type = N'COLUMN', @level2name = N'CountryID',
	@value = N'User''s primary country. Foreign key pointing to the Countries table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'users',
    @level1type = N'TABLE',  @level1name = N'AppUsers',
    @level2type = N'COLUMN', @level2name = N'PostID',
	@value = N'User''s primary post within the country. Foreign key pointing to the Posts table.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'users',
    @level1type = N'TABLE',  @level1name = N'AppUsers',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the AppUsers table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'users',
	@level1type = N'TABLE',  @level1name = N'AppUsers',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'users',
    @level1type = N'TABLE',  @level1name = N'AppUsers',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'users',
    @level1type = N'TABLE',  @level1name = N'AppUsers',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO