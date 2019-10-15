CREATE TABLE [users].[AppUserRoles]
(
    [AppUserID] INT NOT NULL , 
    [AppRoleID] INT NOT NULL, 
    [DefaultRole] BIT NOT NULL DEFAULT ((0)), 
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT sysutcdatetime(),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),
    PRIMARY KEY ([AppUserID], [AppRoleID]),  
    CONSTRAINT [FK_AppUserRoles_AppUsers] FOREIGN KEY ([AppUserID]) REFERENCES [users].[AppUsers]([AppUserID]),
	CONSTRAINT [FK_AppUserRoles_AppRoles] FOREIGN KEY ([AppRoleID]) REFERENCES [users].[AppRoles]([AppRoleID]),
    CONSTRAINT [FK_AppUSerRoles_AppUsers_ModifiedByAppUserID] FOREIGN KEY ([ModifiedByAppUserID]) REFERENCES [users].[AppUsers]([AppUserID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [users].[AppUserRoles_History]))
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'users',
    @level1type = N'TABLE',  @level1name = N'AppUserRoles',
    @level2type = N'COLUMN', @level2name = N'AppUserID',
	@value = N'Foreign key to AppUsers.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'users',
    @level1type = N'TABLE',  @level1name = N'AppUserRoles',
    @level2type = N'COLUMN', @level2name = N'AppRoleID',
	@value = N'Foreign key to AppRoles.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'users',
    @level1type = N'TABLE',  @level1name = N'AppUserRoles',
    @level2type = N'COLUMN', @level2name = N'DefaultRole',
	@value = N'Flag to indicate default role.'
GO
