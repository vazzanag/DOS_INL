CREATE TABLE [users].[AppRolePermissions]
( 
    [AppRoleID] INT NOT NULL, 
    [AppPermissionID] INT NOT NULL,
    [ModifiedByAppUserID] INT NOT NULL,
    [ModifiedDate] DATETIME NOT NULL DEFAULT sysutcdatetime(),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),
    CONSTRAINT [PK_AppRolePermissions] PRIMARY KEY ([AppRoleID], [AppPermissionID]), 
    CONSTRAINT [FK_AppRolePermissions_AppRoles] FOREIGN KEY ([AppRoleID]) REFERENCES [users].[AppRoles]([AppRoleID]), 
    CONSTRAINT [FK_AppRolePermissions_AppPermissions] FOREIGN KEY ([AppPermissionID]) REFERENCES [users].[AppPermissions]([AppPermissionID]), 
    CONSTRAINT [FK_AppRolePermissions_AppUsers_ModifiedByAppUserID] FOREIGN KEY ([ModifiedByAppUserID]) REFERENCES [users].[AppUsers]([AppUserID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [users].[AppRolePermissions_History]))
GO


EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level1type = N'TABLE', 
	@level0name = N'users', @level1name = N'AppRolePermissions',
	@value = N'Permissions for each appRole';
GO
