CREATE TABLE [training].[ApprovalChainLinkApprovers]
(
	[ApprovalChainLinkID] INT NOT NULL,
	[ApproverAppUserID] INT NOT NULL,
	[IsPrimary] BIT NOT NULL,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT [PK_ApprovalChainLinkApprovers] PRIMARY KEY ([ApprovalChainLinkID],[ApproverAppUserID]), 
    CONSTRAINT [FK_ApprovalChainLinkApprovers_TrainingEventApprovalChains] FOREIGN KEY ([ApprovalChainLinkID]) REFERENCES [training].[ApprovalChainLinks]([ApprovalChainLinkID]),
    CONSTRAINT [FK_ApprovalChainLinkApprovers_AppUsers] FOREIGN KEY ([ApproverAppUserID]) REFERENCES [users].[AppUsers]([AppUserID]), 
    CONSTRAINT [FK_ApprovalChainLinkApprovers_AppUsers_ModifiedByAppUserID] FOREIGN KEY ([ModifiedByAppUserID]) REFERENCES [users].[AppUsers]([AppUserID]) 
);
GO


EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level1type = N'TABLE', 
	@level0name = N'training', @level1name = N'ApprovalChainLinkApprovers',
	@value = N'The collection of approvers for each link in an approval chain.';
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level1type = N'TABLE', @level2type = N'COLUMN', 
	@level0name = N'training', @level1name = N'ApprovalChainLinkApprovers', @level2name = N'IsPrimary', 
	@value = N'Indicates whether this approver is the primary approver within the collection of approvers of this approval chain link.';
GO