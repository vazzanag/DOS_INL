CREATE TABLE [training].[TrainingEventUSPartnerAgencies] 
(
    [TrainingEventID] BIGINT NOT NULL,
    [AgencyID]        INT NOT NULL, 
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT GETDATE(),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),
    CONSTRAINT [PK_TrainingEventUSPartnerAgencies] PRIMARY KEY ([TrainingEventID], [AgencyID]), 
    CONSTRAINT [FK_TrainingEventUSPartnerAgencies_TrainingEvents] FOREIGN KEY ([TrainingEventID]) REFERENCES [training].[TrainingEvents]([TrainingEventID]),
    CONSTRAINT [FK_TrainingEventUSPartnerAgencies_USPartnerAgencies] FOREIGN KEY ([AgencyID]) REFERENCES [unitlibrary].[USPartnerAgencies]([AgencyID]), 
    CONSTRAINT [FK_TrainingEventUSPartnerAgencies_AppUsers_ModifiedByAppUserID] FOREIGN KEY ([ModifiedByAppUserID]) REFERENCES [users].[AppUsers]([AppUserID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [training].[TrainingEventUSPartnerAgencies_History]))
GO


EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level1type = N'TABLE', 
	@level0name = N'training', @level1name = N'TrainingEventUSPartnerAgencies',
	@value = N'The US partner agencies associated with a particular training event.';
GO

