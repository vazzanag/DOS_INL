/*
    NAME:   ImportLocations
    
    DESCR:  This is the import migration table that holds the direct import results of the Training 
            Event Locations (AKA "Locations") worksheet from the Training Event template xlsx
            files received from Posts that are on-boarding their historical data into GTTS.

            The data is initially imported from the xlsx file into the [ImportLocations] 
            table (this table script) and then Processed into the [NewPostLocations]
            table.  The data is then validated and either imported into the GTTS data tables or 
            marked as an exception and not imported.
*/
CREATE TABLE [migration].[ImportLocations]
(
	[ImportID] BIGINT NULL,									-- Import ID Number (if known).

	[EventCity] NVARCHAR(MAX) NULL,                         -- Name of the City that the Training Event is taking place in.
	
    [EventState] NVARCHAR(MAX) NULL,                        -- Name of the State that the Training Event is taking place in.

	[EventCountry] NVARCHAR(MAX) NULL,                      -- Name of the Country that the Training Event is taking place in.

	[EventStartDate] DATETIME NULL,                         -- The date that the Training Event is scheduled to start.

	[EventEndDate] DATETIME NULL,                           -- The date that the Training Event is scheduled to end.  

	[TravelStartDate] DATETIME NULL,                        -- The date that participants are expected to travel to the Training Event Location.

	[TravelEndDate] DATETIME NULL,                          -- The date that participants are expected to return from the Training Event Location.
)
ON [PRIMARY]
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'migration',
	@level1type = N'TABLE',  @level1name = N'ImportLocations',
    @value = N'Import migration table that holds the direct import results of the Locations worksheet from the Training Event template xlsx file.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportLocations',
    @level2type = N'COLUMN', @level2name = N'ImportID',
	@value = N'Import ID Number (if known).'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportLocations',
    @level2type = N'COLUMN', @level2name = N'EventCity',
	@value = N'Name of the City that the Training Event is taking place in.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportLocations',
    @level2type = N'COLUMN', @level2name = N'EventState',
	@value = N'Name of the State that the Training Event is taking place in.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportLocations',
    @level2type = N'COLUMN', @level2name = N'EventCountry',
	@value = N'Name of the Country that the Training Event is taking place in.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportLocations',
    @level2type = N'COLUMN', @level2name = N'EventStartDate',
	@value = N'The date that the Training Event is scheduled to start.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportLocations',
    @level2type = N'COLUMN', @level2name = N'EventEndDate',
	@value = N'The date that the Training Event is scheduled to end.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportLocations',
    @level2type = N'COLUMN', @level2name = N'TravelStartDate',
	@value = N'The date that participants are expected to travel to the Training Event Location.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportLocations',
    @level2type = N'COLUMN', @level2name = N'TravelEndDate',
	@value = N'The date that participants are expected to return from the Training Event Location.'
GO