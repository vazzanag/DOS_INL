CREATE TABLE [training].[ApprovalEventTypes]
(
	[ApprovalEventTypeID] INT IDENTITY (1,1) NOT NULL,
	[Name] NVARCHAR(50) NOT NULL,
	[IsActive] BIT NOT NULL DEFAULT 1,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT [PK_ApprovalEventTypes] PRIMARY KEY ([ApprovalEventTypeID]), 
    CONSTRAINT [FK_Approvals_AppUsers_ModifiedByAppUserID] FOREIGN KEY ([ModifiedByAppUserID]) REFERENCES [users].[AppUsers]([AppUserID])
);
GO


EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level1type = N'TABLE', 
	@level0name = N'training', @level1name = N'ApprovalEventTypes',
	@value = N'The available approval event types.';
GO
