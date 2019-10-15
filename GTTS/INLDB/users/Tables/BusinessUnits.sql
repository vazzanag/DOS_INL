CREATE TABLE [users].[BusinessUnits] (
    [BusinessUnitID]       BIGINT         IDENTITY (1, 1) NOT NULL,
    [BusinessUnitName]     NVARCHAR (255) NOT NULL,
    [Acronym]              NVARCHAR (32)  NOT NULL,
    [UnitLibraryUnitID]    BIGINT         NULL,
    [PostID]               INT            NULL,
    [Description]          NVARCHAR (255) NULL,
    [IsActive]             BIT            DEFAULT ((1)) NOT NULL,
    [IsDeleted]            BIT            DEFAULT ((0)) NOT NULL,
    [LogoFileName]         NVARCHAR (512) NULL,
    [VettingPrefix]        NVARCHAR (32)  DEFAULT ('') NOT NULL,
    [HasDutyToInform]      BIT            DEFAULT ((0)) NOT NULL,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT getutcdate(),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),	

    CONSTRAINT [PK_BusinessUnits] PRIMARY KEY CLUSTERED ([BusinessUnitID] ASC),
    CONSTRAINT [FK_BusinessUnits_Units_UnitLibraryUnitID] FOREIGN KEY ([UnitLibraryUnitID]) REFERENCES [unitlibrary].[Units]([UnitID]),
    CONSTRAINT [FK_BusinessUnits_Posts_PostID] FOREIGN KEY ([PostID]) REFERENCES [location].[Posts]([PostID]),
    CONSTRAINT [FK_BusinessUnits_AppUsers_ModifiedByAppUserID] FOREIGN KEY ([ModifiedByAppUserID]) REFERENCES [users].[AppUsers]([AppUserID]),
    CONSTRAINT [UC_BusinessUnits_Acronym_And_PostID] UNIQUE ([Acronym], [PostID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [users].[BusinessUnits_History]))
GO

CREATE FULLTEXT INDEX ON users.BusinessUnits(BusinessUnitName, Acronym, [Description]) 
    KEY INDEX [PK_BusinessUnits] ON FullTextCatalog 
    WITH CHANGE_TRACKING AUTO; 
GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Catalogue of Business Units', @level0type = N'SCHEMA', @level0name = N'users', @level1type = N'TABLE', @level1name = N'BusinessUnits';
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID primary key', @level0type = N'SCHEMA', @level0name = N'users', @level1type = N'TABLE', @level1name = N'BusinessUnits', @level2type = N'COLUMN', @level2name = N'BusinessUnitID';
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Full name of the business unit', @level0type = N'SCHEMA', @level0name = N'users', @level1type = N'TABLE', @level1name = N'BusinessUnits', @level2type = N'COLUMN', @level2name = N'BusinessUnitName';
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Short name or initials of the BU.', @level0type = N'SCHEMA', @level0name = N'users', @level1type = N'TABLE', @level1name = N'BusinessUnits', @level2type = N'COLUMN', @level2name = N'Acronym';
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The ID of the unit in the unit library this business unit is in.', @level0type = N'SCHEMA', @level0name = N'users', @level1type = N'TABLE', @level1name = N'BusinessUnits', @level2type = N'COLUMN', @level2name = N'UnitLibraryUnitID';
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The ID of the post this business unit is in.', @level0type = N'SCHEMA', @level0name = N'users', @level1type = N'TABLE', @level1name = N'BusinessUnits', @level2type = N'COLUMN', @level2name = N'PostID';
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Description of what the BU represents or does.', @level0type = N'SCHEMA', @level0name = N'users', @level1type = N'TABLE', @level1name = N'BusinessUnits', @level2type = N'COLUMN', @level2name = N'Description';
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Activate/suspend use of the BU in dropdowns for new creation', @level0type = N'SCHEMA', @level0name = N'users', @level1type = N'TABLE', @level1name = N'BusinessUnits', @level2type = N'COLUMN', @level2name = N'IsActive';
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Removes completely from dropdowns', @level0type = N'SCHEMA', @level0name = N'users', @level1type = N'TABLE', @level1name = N'BusinessUnits', @level2type = N'COLUMN', @level2name = N'IsDeleted';
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Name of the image that represents the bu', @level0type = N'SCHEMA', @level0name = N'users', @level1type = N'TABLE', @level1name = N'BusinessUnits', @level2type = N'COLUMN', @level2name = N'LogoFileName';
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Word used to name Vetting batches when belong to this BU', @level0type = N'SCHEMA', @level0name = N'users', @level1type = N'TABLE', @level1name = N'BusinessUnits', @level2type = N'COLUMN', @level2name = N'VettingPrefix';
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Set True if the BU is required to notify vetting rejections to Local Gov', @level0type = N'SCHEMA', @level0name = N'users', @level1type = N'TABLE', @level1name = N'BusinessUnits', @level2type = N'COLUMN', @level2name = N'HasDutyToInform';
GO