CREATE TABLE [training].[TrainingEventTypes]
(
	[TrainingEventTypeID] INT IDENTITY (1, 1) NOT NULL,
    [Name] NVARCHAR(100) NOT NULL,
	[Description] nvarchar(255),
    [CountryID] INT NULL,
	[IsActive] BIT NOT NULL DEFAULT 1,
	[ModifiedByAppUserID] [int] NOT NULL,
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),
    CONSTRAINT [PK_TrainingEventTypes] 
		PRIMARY KEY ([TrainingEventTypeID]), 
    CONSTRAINT [FK_TrainingEventTypes_Countries] 
		FOREIGN KEY ([CountryID]) 
		REFERENCES [location].[Countries]([CountryID]), 
    CONSTRAINT [FK_TrainingEventTypes_AppUsers_ModifiedByAppUserID] 
		FOREIGN KEY ([ModifiedByAppUserID]) 
		REFERENCES [users].[AppUsers]([AppUserID]),
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [training].[TrainingEventTypes_History]))
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @value = N'Reference table for Training Event Type Codes',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventTypes'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Primary key & identity of the record in this table.',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventTypes',
    @level2type = N'COLUMN', @level2name = N'TrainingEventTypeID'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Name or code identifying the type of training event.',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventTypes',
    @level2type = N'COLUMN', @level2name = N'Name'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Extended description of the training event type code.',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventTypes',
    @level2type = N'COLUMN', @level2name = N'Description'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Associates the record to a specific country.  A NULL value indicates it is globally available to all countries that do not have any training event types specified.  Foreign key pointing to the Countries reference table.',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventTypes',
    @level2type = N'COLUMN', @level2name = N'CountryID'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Boolean value that indicates if the record is currently active and in use.',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventTypes',
    @level2type = N'COLUMN', @level2name = N'IsActive'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the Users table.',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventTypes',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod fow which the record is valid.',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventTypes',
	@level2type = N'COLUMN', @level2name = N'SysStartTime'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventTypes',
	@level2type = N'COLUMN', @level2name = N'SysEndTime'
GO