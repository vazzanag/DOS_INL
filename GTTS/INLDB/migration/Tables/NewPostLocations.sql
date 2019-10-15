/*
    NAME:   NewPostLocations

    DESCR:  This is the import migration table that receives the imported records
            from the [ImportLocations] table.

            The data is initially imported from the xlsx file into the [ImportLocations] 
            table and then appended into the [NewPostLocations] table (this table 
            script).  The data is then validated and either imported into the GTTS data tables or 
            marked as an exception and not imported.
*/
CREATE TABLE [migration].[NewPostLocations]
(
	[NewPostLocationID] BIGINT IDENTITY (1, 1) NOT NULL,    -- Internal PK of table.    

	[NewPostImportID] BIGINT NULL,							-- FK to [NewPostImportLog] table.   

	[EventCity] NVARCHAR(100) NULL,                         -- Name of the City that the Training Event is taking place in.
                                                            -- This will require that the specified City in [EventCity] undergoes a reverse lookup  
                                                            -- into the [Cities] table to get its matching [CityID] value (within the specified
                                                            -- State within the specfied Country) which is then stored in the [EventCityID] column  
                                                            -- in this table.  If the specified City is not found (does not exist or is misspelled), 
                                                            -- the 'UNKNOWN CITY' value will be used when writing the [CityID] value to the 
                                                            -- [EventCityID] column. 
                                                            -- NOTE 1: Even though the column order is City, State, Country, the data elements will 
                                                            -- be processed in Country, State, City order.  
                                                            -- NOTE 2: Each State within a Country will have its own 'UNKNOWN CITY' value in the 
                                                            -- [Cities] table.
    [EventCityID] INT NULL,                                 -- Mapped to [Locations].[CityID] column.  
	
    [EventState] NVARCHAR(75) NULL,                         -- Name of the State that the Training Event is taking place in.
                                                            -- This will require that the specified State in [EventState] undergoes a reverse lookup 
                                                            -- into the [States] table to get its matching [StateID] value (within the specfied Country)
                                                            -- which is then stored in the [EventStateID] column in this table.  If the specified State 
                                                            -- is not found (does not exist or is misspelled), the 'UNKNOWN STATE' value will be used 
                                                            -- when writing the [StateID] value to the [EventStateID] column. 
                                                            -- NOTE 1: Even though the column order is City, State, Country, the data elements will 
                                                            -- be processed in Country, State, City order.  
                                                            -- NOTE 2: Each Country will have its own 'UNKNOWN STATE' value in the [States] table.
    [EventStateID] INT NULL,                                -- This value is used to find the list of Cities within the specified State.

	[EventCountry] NVARCHAR(75) NULL,                       -- Name of the Country that the Training Event is taking place in.
                                                            -- This will require that the specified Country in [EventCountry] undergoes a reverse lookup
                                                            -- into the [Countries] table to get its matching [CountryID] value which is then stored in  
                                                            -- the [EventCountryID] column in this table.  If the specified Country is not found (does 
                                                            -- not exist or is misspelled), the 'UNKNOWN COUNTRY' value will be used when writing the
                                                            -- [CountryID] value to the [EventCountryID] column. 
                                                            -- NOTE 1: Even though the column order is City, State, Country, the data elements will 
                                                            -- be processed in Country, State, City order.  
                                                            -- NOTE 2: The [Countries] table will have an 'UNKNOWN COUNTRY'.
    [EventCountryID] INT NULL,                              -- This value is used to find the list of States within the specified Country.

	[EventStartDate] DATETIME NULL,                         -- The date that the Training Event is scheduled to start.
                                                            -- Mapped to [TrainingEventLocations].[EventStartDate] column.

	[EventEndDate] DATETIME NULL,                           -- The date that the Training Event is scheduled to end.  
                                                            -- Mapped to the [TrainingEventLocations].[EventEndDate] column.

	[TravelStartDate] DATETIME NULL,                        -- The date that participants are expected to travel to the Training Event Location.
                                                            -- Mapped to the [TrainingEventLocations].[TravelStartDate] column.

	[TravelEndDate] DATETIME NULL,                          -- The date that participants are expected to return from the Training Event Location.
                                                            -- Mapped to the [TrainingEventLocations].[TravelEndDate] column.

    [LocationID] BIGINT NULL,                               -- [TrainingEventLocations].[TrainingEventLocationID] 
                                                            -- If the Event Location was matched or added to an existing Location in the [Locations] 
                                                            -- table, that [LocationID] is identified here. FK pointing to the [Locations] table.

	[ImportStatus] NVARCHAR(100) NULL,						-- Status of the import process.  Valid values are:
                                                            -- 'Uploaded'                 = Data was uploaded into the [NewPostLocations] table.
                                                            -- 'Exception - Not Imported' = Record was not imported due to data value/validation issues.
                                                            -- 'Imported                  = Record was processed, validated, and imported into the data tables.

	[Validations] NVARCHAR(4000) NULL,                      -- NOT SURE IF THIS WILL BE NEEDED

	[ImportVersion] INT NULL,                               -- Version number of the template spreadsheet file from Excel file metadata. 

	[ModifiedByAppUserID] INT NOT NULL DEFAULT(2),          -- [AppUserID] value of 2 = 'ONBOARDING'.
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),

    CONSTRAINT [PK_NewPostLocations] 
		PRIMARY KEY ([NewPostLocationID]),

    CONSTRAINT [FK_NewPostLocations_NewPostImportLog] 
        FOREIGN KEY ([NewPostImportID]) 
        REFERENCES [migration].[NewPostImportLog]([NewPostImportID]),

    CONSTRAINT [FK_NewPostLocations_TrainingEvents] 
        FOREIGN KEY ([LocationID]) 
        REFERENCES [location].[Locations]([LocationID]),

    CONSTRAINT [FK_NewPostLocations_AppUsers] 
        FOREIGN KEY ([ModifiedByAppUserID]) 
        REFERENCES [users].[AppUsers]([AppUserID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [migration].[NewPostLocations_History]))
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'migration',
	@level1type = N'TABLE',  @level1name = N'NewPostLocations',
    @value = N'Import migration table that holds the direct import results of the Locations worksheet from the Training Event template xlsx file.'
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostLocations',
    @level2type = N'COLUMN', @level2name = N'NewPostLocationID',
	@value = N'Primary key & identity value of the record in this table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostLocations',
    @level2type = N'COLUMN', @level2name = N'NewPostImportID',
	@value = N'This is the master import tracking ID that links all of the New Post Import records in the different [migration] tables to a specific import template file.  Foreign key pointing to the [NewPostImportLog] table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostLocations',
    @level2type = N'COLUMN', @level2name = N'EventCity',
	@value = N'Name of the City that the Training Event is taking place in.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostLocations',
    @level2type = N'COLUMN', @level2name = N'EventCityID',
	@value = N'The retrieved ID value from the reverse lookup string match of [EventCity] against the [Cities] table.  If no matching value was found in the [Cities] table, this column will be populated with the value of ''UNKNOWN CITY''.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostLocations',
    @level2type = N'COLUMN', @level2name = N'EventState',
	@value = N'Name of the State that the Training Event is taking place in.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostLocations',
    @level2type = N'COLUMN', @level2name = N'EventStateID',
	@value = N'The retrieved ID value from the reverse lookup string match of [EventState] against the [States] table.  If no matching value was found in the [States] table, this column will be populated with the value of ''UNKNOWN STATE''.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostLocations',
    @level2type = N'COLUMN', @level2name = N'EventCountry',
	@value = N'Name of the Country that the Training Event is taking place in.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostLocations',
    @level2type = N'COLUMN', @level2name = N'EventCountryID',
	@value = N'The retrieved ID value from the reverse lookup string match of [EventCountry] against the [Countries] table.  If no matching value was found in the [Countries] table, this column will be populated with the value of ''UNKNOWN COUNTRY''.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostLocations',
    @level2type = N'COLUMN', @level2name = N'EventStartDate',
	@value = N'The date that the Training Event is scheduled to start.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostLocations',
    @level2type = N'COLUMN', @level2name = N'EventEndDate',
	@value = N'The date that the Training Event is scheduled to end.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostLocations',
    @level2type = N'COLUMN', @level2name = N'TravelStartDate',
	@value = N'The date that participants are expected to travel to the Training Event Location.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostLocations',
    @level2type = N'COLUMN', @level2name = N'TravelEndDate',
	@value = N'The date that participants are expected to return from the Training Event Location.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostLocations',
    @level2type = N'COLUMN', @level2name = N'LocationID',
	@value = N'The [Locations].[LocationID] value of the new [Locations] table record that was created as a result of the import of this [NewPostLocations] record.  Foreign key pointing to the [Locations] table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostLocations',
    @level2type = N'COLUMN', @level2name = N'ImportStatus',
	@value = N'The status of the upload of the Locations data into the database data tables. Valid values for this column are ''Uploaded'', ''Exception - Not Imported'', and  ''Imported''.  ''Uploaded'' means that the data was uploaded into the [NewPostLocations] table.  ''Exception - Not Imported'' means that there were data value/validation issues that prevented the record from being imported into the database data tables.  Details of the specific issues will be written to the [NewPostImportExceptions] table.  ''Imported'' means that the data was processed, validated, and imported into the database data tables.  This is an internal management & control column that does not have a matching database data column outside of the [NewPostLocations] table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostLocations',
    @level2type = N'COLUMN', @level2name = N'Validations',
	@value = N'Contains the results of the validations processing during the upload process.  This is an internal management & control column that does not have a matching database data column outside of the [NewPostLocations] table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostLocations',
    @level2type = N'COLUMN', @level2name = N'ImportVersion',
	@value = N'Identifies the version number of the template spreadsheets.  This is an internal management & control column that does not have a matching database data column outside of the [NewPostLocations] table.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'migration',
	@level1type = N'TABLE',  @level1name = N'NewPostLocations',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Default value of 1 is the User known as ''NEW POST IMPORT''.  Foreign key pointing to the [AppUsers] table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'migration',
	@level1type = N'TABLE',  @level1name = N'NewPostLocations',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'migration',
	@level1type = N'TABLE',  @level1name = N'NewPostLocations',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
	@level1type = N'TABLE',  @level1name = N'NewPostLocations',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod for which the record is valid.'
GO