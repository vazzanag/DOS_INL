CREATE TABLE [unitlibrary].[UnitAliases]
(
	[UnitAliasID] [int] IDENTITY(1,1) NOT NULL,
	[UnitID] BIGINT NOT NULL,
	[UnitAlias] [nvarchar](256) NOT NULL,
	[LanguageID] SMALLINT NULL,
	[IsDefault] [bit] NOT NULL DEFAULT 0,
	[IsActive] [bit] NOT NULL DEFAULT 0,
	[ModifiedByAppUserID] INT NOT NULL,
    [ModifiedDate] [datetime] NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),	
    CONSTRAINT [PK_UnitAliases] PRIMARY KEY ([UnitAliasID]), 
    CONSTRAINT [FK_UnitAliases_Languages] FOREIGN KEY ([LanguageID]) REFERENCES [location].[Languages]([LanguageID]),
    CONSTRAINT [FK_UnitsAliases_AppUsers] FOREIGN KEY ([ModifiedByAppUserID]) REFERENCES [users].[AppUsers]([AppUserID]), 
    CONSTRAINT [FK_UnitAliases_Units] FOREIGN KEY ([UnitID]) REFERENCES [unitlibrary].[Units]([UnitID]),
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [unitlibrary].[UnitAliases_History]))
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Other names related to Agency' , @level0type=N'SCHEMA',@level0name=N'unitlibrary', @level1type=N'TABLE',@level1name=N'UnitAliases'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ID primary key' , @level0type=N'SCHEMA',@level0name=N'unitlibrary', @level1type=N'TABLE',@level1name=N'UnitAliases', @level2type=N'COLUMN',@level2name=N'UnitAliasID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'UnitID foreign key to Units table ' , @level0type=N'SCHEMA',@level0name=N'unitlibrary', @level1type=N'TABLE',@level1name=N'UnitAliases', @level2type=N'COLUMN',@level2name=N'UnitID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The alias or additional name of the Agency' , @level0type=N'SCHEMA',@level0name=N'unitlibrary', @level1type=N'TABLE',@level1name=N'UnitAliases', @level2type=N'COLUMN',@level2name='UnitAlias'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Language of the Alias' , @level0type=N'SCHEMA',@level0name=N'unitlibrary', @level1type=N'TABLE',@level1name=N'UnitAliases', @level2type=N'COLUMN',@level2name=N'LanguageID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Set true if this Alias is the main' , @level0type=N'SCHEMA',@level0name=N'unitlibrary', @level1type=N'TABLE',@level1name=N'UnitAliases', @level2type=N'COLUMN',@level2name=N'IsDefault'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Enable/Disable alias' , @level0type=N'SCHEMA',@level0name=N'unitlibrary', @level1type=N'TABLE',@level1name=N'UnitAliases', @level2type=N'COLUMN',@level2name=N'IsActive'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who modified the record' , @level0type=N'SCHEMA',@level0name=N'unitlibrary', @level1type=N'TABLE',@level1name=N'UnitAliases', @level2type=N'COLUMN',@level2name=N'ModifiedByAppUserID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'When record was modified' , @level0type=N'SCHEMA',@level0name=N'unitlibrary', @level1type=N'TABLE',@level1name=N'UnitAliases', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
GO
