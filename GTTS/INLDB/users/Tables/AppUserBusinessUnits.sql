CREATE TABLE [users].[AppUserBusinessUnits] (
    [AppUserID]              INT NOT NULL,
    [BusinessUnitID]      BIGINT NOT NULL,
    [DefaultBusinessUnit] BIT DEFAULT ((0)) NOT NULL,
    [Writeable]           BIT DEFAULT ((0)) NOT NULL,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT sysutcdatetime(),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),
    CONSTRAINT [PK_UserBusinessUnits] PRIMARY KEY CLUSTERED ([AppUserID] ASC, [BusinessUnitID] ASC),
    CONSTRAINT [FK_UserBusinessTypes_BusinessUnits] FOREIGN KEY ([BusinessUnitID]) REFERENCES [users].[BusinessUnits] ([BusinessUnitID]),
    CONSTRAINT [FK_UserBusinessTypes_AppUsers] FOREIGN KEY ([AppUserID]) REFERENCES [users].[AppUsers] ([AppUserID]), 
    CONSTRAINT [FK_UserBusinessTypes_AppUsers_ModifiedByAppUserID] FOREIGN KEY ([ModifiedByAppUserID]) REFERENCES [users].[AppUsers]([AppUserID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [users].[AppUserBusinessUnits_History]))
GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Relates which Users belong to which BusinessUnit', @level0type = N'SCHEMA', @level0name = N'users', @level1type = N'TABLE', @level1name = N'AppUserBusinessUnits';
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'References access.Users', @level0type = N'SCHEMA', @level0name = N'users', @level1type = N'TABLE', @level1name = N'AppUserBusinessUnits', @level2type = N'COLUMN', @level2name = 'AppUserID';
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'References access.BusinessUnits', @level0type = N'SCHEMA', @level0name = N'users', @level1type = N'TABLE', @level1name = N'AppUserBusinessUnits', @level2type = N'COLUMN', @level2name = N'BusinessUnitID';
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Sets if this BU is the default for user', @level0type = N'SCHEMA', @level0name = N'users', @level1type = N'TABLE', @level1name = N'AppUserBusinessUnits', @level2type = N'COLUMN', @level2name = N'DefaultBusinessUnit';
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Sets if user can write events related to this BU', @level0type = N'SCHEMA', @level0name = N'users', @level1type = N'TABLE', @level1name = N'AppUserBusinessUnits', @level2type = N'COLUMN', @level2name = N'Writeable';
GO