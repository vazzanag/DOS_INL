CREATE TABLE [training].[TrainingEventLocationsXLSX]
(
	[EventLocationsXLSXID] INT IDENTITY (1, 1) NOT NULL,
	[EventXLSXID] BIGINT  NULL,				-- Nullable FK to [TrainingEventsXLSX]
	[LocationID] BIGINT NULL,				-- Nullable FK to [Locations]
	[EventLocationCity] NVARCHAR(100) NOT NULL,
	[EventLocationState] NVARCHAR(75) NOT NULL,
	[EventLocationCountry] NVARCHAR(75) NOT NULL,
	[EventStartDate] DATETIME NOT NULL,
	[EventEndDate] DATETIME NOT NULL,
	[TravelStartDate] DATETIME NULL,
	[TravelEndDate] DATETIME NULL,
	[Validations] NVARCHAR(4000) NULL,
	[ImportVersion] INT NULL,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),
    CONSTRAINT [PK_EventLocationsXLSXID] 
		PRIMARY KEY ([EventLocationsXLSXID]),
    CONSTRAINT [FK_EventLocationsXLSX_TrainingEventsXLSX] 
        FOREIGN KEY ([EventXLSXID]) 
        REFERENCES [training].[TrainingEventsXLSX]([EventXLSXID]),
    CONSTRAINT [FK_EventLocationsXLSX_Locations] 
        FOREIGN KEY ([LocationID]) 
        REFERENCES [location].[Locations]([LocationID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [training].[TrainingEventLocationsXLSX_History]))
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventLocationsXLSX',
	@value = N'Upload table that holds Training EventLocations data that is imported into the database via an upload function.  Data is imported into GTTS via a 3-step process: 1) Upload data from spreadsheet file into the corresponding upload table, 2) Validate, preview and edit uploaded data in the upload table, 3) Import the validated & edited data in the upload table into the GTTS data tables.';
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventLocationsXLSX',
    @level2type = N'COLUMN', @level2name = N'EventLocationsXLSXID',
	@value = N'Primary key & identity of the record in this table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventLocationsXLSX',
    @level2type = N'COLUMN', @level2name = N'EventXLSXID',
	@value = N'The [TrainingEventXLSX].[EventXLSXID] value for the [TrainingEventXLSX] record that the Training Event Location is associated with.  This is an internal management & control column that does not have a matching database data column outside of the [TrainingEventLocationsXLSX] table.  Foreign key pointing to the TrainingEventXLSX table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventLocationsXLSX',
    @level2type = N'COLUMN', @level2name = N'LocationID',
	@value = N'If the Event Location was matched to an existing Location in the [Locations] table, that [LocationID] is identified here.  This is an internal management & control column that does not have a matching database data column outside of the [TrainingEventLocationsXLSX] table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventLocationsXLSX',
    @level2type = N'COLUMN', @level2name = N'EventLocationCity',
	@value = N'The City that the Training Event is taking place in.  This column along with the [EventLocationState] & [EventLocationCountry} columns are used to identify the correct record in [Locations] that corresponds to the specified [TrainingEventLocationsXLSX] record. '
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventLocationsXLSX',
    @level2type = N'COLUMN', @level2name = N'EventLocationState',
	@value = N'The State that the Training Event is taking place in.  This column along with the [EventLocationCity] & [EventLocationCountry} columns are used to identify the correct record in [Locations] that corresponds to the specified [TrainingEventLocationsXLSX] record.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventLocationsXLSX',
    @level2type = N'COLUMN', @level2name = N'EventLocationCountry',
	@value = N'The Country that the Training Event is taking place in.  This column along with the [EventLocationCity] & [EventLocationState} columns are used to identify the correct record in [Locations] that corresponds to the specified [TrainingEventLocationsXLSX] record.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventLocationsXLSX',
    @level2type = N'COLUMN', @level2name = N'EventStartDate',
	@value = N'The date that the Training Event is scheduled to start.  This value will be mapped to the [TrainingEventLocations].[EventStartDate] column.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventLocationsXLSX',
    @level2type = N'COLUMN', @level2name = N'EventEndDate',
	@value = N'The date that the Training Event is scheduled to end.  This value will be mapped to the [TrainingEventLocations].[EventEndDate] column.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventLocationsXLSX',
    @level2type = N'COLUMN', @level2name = N'TravelStartDate',
	@value = N'The date that participants are expected to travel to the Training Event Location.  This value will be mapped to the [TrainingEventLocations].[TravelStartDate] column.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventLocationsXLSX',
    @level2type = N'COLUMN', @level2name = N'TravelEndDate',
	@value = N'The date that participants are expected to return from the Training Event Location.  This value will be mapped to the [TrainingEventLocations].[TravelEndDate] column.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventLocationsXLSX',
    @level2type = N'COLUMN', @level2name = N'Validations',
	@value = N'Contains the results of the validations processing during the upload process.  This is an internal management & control column that does not have a matching database data column outside of the [TrainingEventLocationsXLSX] table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventLocationsXLSX',
    @level2type = N'COLUMN', @level2name = N'ImportVersion',
	@value = N'Identifies the version number of the template spreadsheets.  This is an internal management & control column that does not have a matching database data column outside of the [TrainingEventLocationsXLSX] table.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventLocationsXLSX',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the Users table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventLocationsXLSX',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventLocationsXLSX',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventLocationsXLSX',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO