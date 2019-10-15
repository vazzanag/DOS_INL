CREATE TABLE [vetting].[CourtesyBatches]
(
	[CourtesyBatchID] BIGINT IDENTITY (1, 1) NOT NULL,
	[VettingBatchID] BIGINT NOT NULL,
	[VettingTypeID] SMALLINT NOT NULL,  
	[VettingBatchNotes] NVARCHAR(500),	
	[AssignedToAppUserID] INT,	
	[ResultsSubmittedDate] DATETIME,
	[ResultsSubmittedByAppUserID] INT,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),   
    CONSTRAINT [PK_CourtesyBatches]
        PRIMARY KEY ([CourtesyBatchID]),
    CONSTRAINT [FK_CourtesyBatches_VettingBatches]
        FOREIGN KEY ([VettingBatchID]) 
        REFERENCES [vetting].[VettingBatches] ([VettingBatchID]),
    CONSTRAINT [FK_CourtesyBatches_VettingTypes]
        FOREIGN KEY ([VettingTypeID]) 
        REFERENCES [vetting].[VettingTypes] ([VettingTypeID]),
    CONSTRAINT [FK_CourtesyBatches_AppUsers]
        FOREIGN KEY ([ResultsSubmittedByAppUserID]) 
        REFERENCES [users].[AppUsers] ([AppUserID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [vetting].[CourtesyBatches_History]))
GO
