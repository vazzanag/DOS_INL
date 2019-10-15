CREATE TABLE [users].[AppPermissions]
(
    [AppPermissionID] INT NOT NULL, 
    [Name] NVARCHAR(100) NOT NULL, 
    [Description] NVARCHAR(255) NULL, 
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT sysutcdatetime(),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),
    CONSTRAINT [PK_AppPermissions] PRIMARY KEY ([AppPermissionID]), 
    CONSTRAINT [FK_AppPermissions_AppUsers_ModifiedByAppUserID] FOREIGN KEY ([ModifiedByAppUserID]) REFERENCES [users].[AppUsers]([AppUserID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [users].[AppPermissions_History]))
GO


EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level1type = N'TABLE', 
	@level0name = N'users', @level1name = N'AppPermissions',
	@value = N'Application permissions.  These permissions are tied to roles and bound to actions.  They are used to determine whether a user has permissions to perform an action.';
GO


EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level1type = N'TABLE', @level2type = N'COLUMN', 
	@level0name = N'users', @level1name = N'AppPermissions', @level2name = N'Name', 
	@value = N'The name of the permission.  This name is used in the application to determine if the user has the required permission to perform the action.';
GO
