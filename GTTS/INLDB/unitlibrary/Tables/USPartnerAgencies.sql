CREATE TABLE [unitlibrary].[USPartnerAgencies]
(
	[AgencyID] INT IDENTITY (1,1) NOT NULL,
	[Name] NVARCHAR(100)                   NOT NULL,
	[Initials] NVARCHAR(50)                NOT NULL,
    [UnitLibraryUnitID]	BIGINT             NULL,
	[IsActive] BIT                         NOT NULL DEFAULT 1,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT GETDATE(),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),	
    CONSTRAINT [PK_USPartnerAgencies] PRIMARY KEY ([AgencyID]), 
    CONSTRAINT [FK_USPartnerAgencies_AppUsers_ModifiedByAppUserID] FOREIGN KEY ([ModifiedByAppUserID]) REFERENCES [users].[AppUsers]([AppUserID]),
    CONSTRAINT [FK_USPartnerAgencies_Units_UnitLibraryUnitID] FOREIGN KEY ([UnitLibraryUnitID]) REFERENCES [unitlibrary].[Units]([UnitID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [unitlibrary].[USPartnerAgencies_History]))
GO


EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level1type = N'TABLE', 
	@level0name = N'unitlibrary', @level1name = N'USPartnerAgencies',
	@value = N'The available US partner agencies.';
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level1type = N'TABLE', @level2type = N'COLUMN', 
	@level0name = N'unitlibrary', @level1name = N'USPartnerAgencies', @level2name = N'Initials', 
	@value = N'The abbreviated form of the agency name.';
GO
