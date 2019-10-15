CREATE TABLE [persons].[PersonAttachmentTypes]
(
	[PersonAttachmentTypeID] INT IDENTITY (1,1) NOT NULL,
	[Name] NVARCHAR(100) NOT NULL,
	[Description] NVARCHAR(200) NULL,
	[IsActive] BIT NOT NULL DEFAULT 1,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT GETDATE(),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),
    CONSTRAINT [PK_PersonAttachmentTypes] PRIMARY KEY ([PersonAttachmentTypeID]), 
	CONSTRAINT [UC_PersonAttachmentTypes] UNIQUE ([Name])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [persons].[PersonAttachmentTypes_History]))
GO
