CREATE TABLE [users].[StaffTypes] (
    [StaffTypeID]          INT            IDENTITY (1, 1) NOT NULL,
    [StaffType]   NVARCHAR (63)  NOT NULL,
    [Description] NVARCHAR (255) NULL,
    [IsActive]    BIT            DEFAULT ((1)) NOT NULL,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT [PK_StaffTypes] PRIMARY KEY CLUSTERED ([StaffTypeID] ASC), 
    CONSTRAINT [FK_StaffTypes_AppUsers_ModifiedByAppUserID] FOREIGN KEY ([ModifiedByAppUserID]) REFERENCES [users].[AppUsers]([AppUserID]),
    UNIQUE NONCLUSTERED ([StaffType] ASC)
);

