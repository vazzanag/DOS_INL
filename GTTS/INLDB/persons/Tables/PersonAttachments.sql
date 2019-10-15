CREATE TABLE [persons].[PersonAttachments]
(
    [PersonID] BIGINT NOT NULL,
    [FileID]   INT NOT NULL, 
	[PersonAttachmentTypeID] INT NOT NULL,
	[Description] NVARCHAR(500) NULL,
	[IsDeleted] BIT DEFAULT 0,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT GETDATE(),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),
    CONSTRAINT [PK_PersonAttachments] PRIMARY KEY ([PersonID], [FileID]),
    CONSTRAINT [FK_PersonAttachments_Persons] FOREIGN KEY ([PersonID]) REFERENCES [persons].[Persons]([PersonID]),
    CONSTRAINT [FK_PersonAttachments_PersonAttachmentTypes] FOREIGN KEY ([PersonAttachmentTypeID]) REFERENCES [persons].[PersonAttachmentTypes]([PersonAttachmentTypeID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [persons].[PersonAttachments_History]))
GO


EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level1type = N'TABLE', 
	@level0name = N'persons', @level1name = N'PersonAttachments',
	@value = N'The cross reference table joining uploaded files to persons.';
GO
