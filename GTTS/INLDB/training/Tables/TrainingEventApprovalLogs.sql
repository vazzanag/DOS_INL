CREATE TABLE [training].[TrainingEventApprovalLogs]
(
	[TrainingEventApprovalLogID] BIGINT IDENTITY (1,1) NOT NULL,
	[TrainingEventID] BIGINT                        NOT NULL,
	[ApprovalChainLinkID] INT                    NOT NULL,
	[ApprovalEventTypeID] INT					 NOT NULL,
	[ApprovalEventDate] DATETIME                 NOT NULL,
	[ApproverAppUserID] INT                         NULL,
	[Comments] NVARCHAR(1000)                    NULL,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT [PK_TrainingEventApprovalLogs] PRIMARY KEY ([TrainingEventApprovalLogID]), 
    CONSTRAINT [FK_TrainingEventApprovalLogs_TrainingEvents] FOREIGN KEY ([TrainingEventID]) REFERENCES [training].[TrainingEvents]([TrainingEventID]),
    CONSTRAINT [FK_TrainingEventApprovalLogs_TrainingEventApprovalChains] FOREIGN KEY ([ApprovalChainLinkID]) REFERENCES [training].[ApprovalChainLinks]([ApprovalChainLinkID]),
    CONSTRAINT [FK_TrainingEventApprovalLogs_ApprovalEventTypes] FOREIGN KEY ([ApprovalEventTypeID]) REFERENCES [training].[ApprovalEventTypes]([ApprovalEventTypeID]),
    CONSTRAINT [FK_TrainingEventApprovalLogs_AppUsers] FOREIGN KEY ([ApproverAppUserID]) REFERENCES [users].[AppUsers]([AppUserID]), 
    CONSTRAINT [FK_TrainingEventApprovalLogs_AppUsers_ModifiedByAppUserID] FOREIGN KEY ([ModifiedByAppUserID]) REFERENCES [users].[AppUsers]([AppUserID])
);
GO


EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level1type = N'TABLE', 
	@level0name = N'training', @level1name = N'TrainingEventApprovalLogs',
	@value = N'The events that have occurred in the approval flow of a training event.';
GO
