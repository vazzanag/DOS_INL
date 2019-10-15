CREATE TABLE [training].[ApprovalChainLinks]
(
	[ApprovalChainLinkID] INT IDENTITY (1,1) NOT NULL,
	[BusinessUnitID] BIGINT NOT NULL,
	[Sequence] INT NOT NULL,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT [PK_ApprovalChainLinks] PRIMARY KEY ([ApprovalChainLinkID]),
    CONSTRAINT [FK_ApprovalChainLinks_BusinessUnits] FOREIGN KEY ([BusinessUnitID]) REFERENCES [users].[BusinessUnits]([BusinessUnitID]), 
    CONSTRAINT [FK_ApprovalChainLinks_AppUsers_ModifiedByAppUserID] FOREIGN KEY ([ModifiedByAppUserID]) REFERENCES [users].[AppUsers]([AppUserID]), 
	CONSTRAINT [UC_ApprovalChainLinks] UNIQUE ([BusinessUnitID],[Sequence])  	
);
GO


EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level1type = N'TABLE', 
	@level0name = N'training', @level1name = N'ApprovalChainLinks',
	@value = N'The training event approval levels for a business unit.';
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level1type = N'TABLE', @level2type = N'COLUMN', 
	@level0name = N'training', @level1name = N'ApprovalChainLinks', @level2name = N'Sequence', 
	@value = N'The sequential step in the approval chain where this link fits.';
GO
