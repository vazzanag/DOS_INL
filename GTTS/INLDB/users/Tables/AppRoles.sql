CREATE TABLE [users].[AppRoles]
(
    [AppRoleID] INT NOT NULL, 
	[Code] NVARCHAR(50) NOT NULL,
    [Name] NVARCHAR(50) NOT NULL, 
    [Description] NVARCHAR(255) NULL, 
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT sysutcdatetime(),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),
    CONSTRAINT [PK_AppRoles] PRIMARY KEY ([AppRoleID]), 
    CONSTRAINT [FK_AppRoles_AppUsers_ModifiedByAppUserID] FOREIGN KEY ([ModifiedByAppUserID]) REFERENCES [users].[AppUsers]([AppUserID]),
	CONSTRAINT [UC_AppRoles_Code] UNIQUE ([Code])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [users].[AppRoles_History]))
GO


EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level1type = N'TABLE', 
	@level0name = N'users', @level1name = N'AppRoles',
	@value = N'Application roles that are assigned to users.  These roles are used to determine what permission the user has within the system.';
GO