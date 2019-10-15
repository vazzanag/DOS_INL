/*
    **************************************************************************
    VettingHits.sql
    **************************************************************************    
*/     
CREATE TABLE [vetting].[VettingHits] 
(
    [VettingHitID] BIGINT IDENTITY (1, 1) NOT NULL, 
    [PersonsVettingID] BIGINT NOT NULL, 
    [VettingTypeID] SMALLINT NOT NULL,     
    [FirstMiddleNames] NVARCHAR(150) NULL,  -- UI Defaults this to [Persons].[FirstMiddleNames]
    [LastNames] NVARCHAR(150) NULL,         -- UI Defaults this to [Persons].[LastNames]
	[DOBMonth] TINYINT NULL,                -- UI controls valid values: 1 - 12, NULL
    [DOBDay] TINYINT NULL,                  -- UI controls valid values: 1 - 31, NULL ; 
    [DOBYear] SMALLINT NULL,                -- YYYY format
    [PlaceOfBirth] NVARCHAR(300) NULL,
    [ReferenceSiteID] TINYINT NULL,         -- FK to [VettingHitsReferenceSites] table
    [HitMonth] TINYINT NULL,                -- UI controls valid values: 1 - 12, NULL
    [HitDay] TINYINT NULL,                  -- UI controls valid values: 1 - 31, NULL ; Not used by CONS
    [HitYear] SMALLINT NULL,                -- UI controls valid values: 1970 - 2100, NULL
    [TrackingID] NVARCHAR(100) NULL,
    [UnitID] BIGINT NULL,                   -- FK to [Units] table; Not used by CONS
	[HitUnit] NVARCHAR(200) NULL,          -- UI Control UnitID is not used anymore
    [HitLocation] NVARCHAR(300) NULL,       -- Not used by CONS
    [ViolationTypeID] TINYINT NULL,         -- FK to [VettingHitViolationTypes] table; Not used by CONS
    [CredibilityLevelID] TINYINT NULL,      -- FK to [VettingHitCredibilityLevels] table; Not used by CONS
    [HitDetails] NVARCHAR(MAX) NULL,
    [Notes] NVARCHAR(MAX) NULL,
    [VettingHitDate] DATETIME NULL,
	[VettingHitAppUserID] INT,
	[IsRemoved] BIT NULL,
	[ModifiedByAppUserID] INT NULL,         -- SPECIAL CASE FOR NULL HERE.  SEE NOTE ABOVE.
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),     
    CONSTRAINT [PK_VettingHits]
        PRIMARY KEY ([VettingHitID]),
    CONSTRAINT [FK_VettingHits_PersonsVetting]
        FOREIGN KEY ([PersonsVettingID]) 
        REFERENCES [vetting].[PersonsVetting] ([PersonsVettingID]),
    CONSTRAINT [FK_VettingHits_VettingTypes]
        FOREIGN KEY ([VettingTypeID]) 
        REFERENCES [vetting].[VettingTypes] ([VettingTypeID]),
	CONSTRAINT [FK_VettingHits_VettingHitReferenceSites]
		FOREIGN KEY ([ReferenceSiteID]) 
		REFERENCES [vetting].[VettingHitReferenceSites]([ReferenceSiteID]),	
	CONSTRAINT [FK_VettingHits_Units]
		FOREIGN KEY ([UnitID]) 
		REFERENCES [unitlibrary].[Units]([UnitID]),	        
	CONSTRAINT [FK_VettingHits_VettingHitViolationTypes]
		FOREIGN KEY ([ViolationTypeID]) 
		REFERENCES [vetting].[VettingHitViolationTypes]([ViolationTypeID]),        
	CONSTRAINT [FK_VettingHits_VettingHitCredibilityLevels]
		FOREIGN KEY ([CredibilityLevelID]) 
		REFERENCES [vetting].[VettingHitCredibilityLevels]([CredibilityLevelID]),    
	CONSTRAINT [FK_VettingHits_AppUsers_VettingHitAppUserID] 
        FOREIGN KEY ([VettingHitAppUserID]) 
        REFERENCES [users].[AppUsers]([AppUserID]),
    CONSTRAINT [FK_VettingHits_AppUsers_ModifiedByAppUserID] 
        FOREIGN KEY ([ModifiedByAppUserID]) 
        REFERENCES [users].[AppUsers]([AppUserID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [vetting].[VettingHits_History]))
GO     

CREATE FULLTEXT INDEX ON [vetting].[VettingHits] (FirstMiddleNames, LastNames, TrackingID, HitDetails) 
    KEY INDEX [PK_VettingHits] ON [FullTextCatalog] 
    WITH CHANGE_TRACKING AUTO
GO
        
/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'VettingHits',
	@value = N'Data table that holds all of the vetting results from all of the vetting processes that were executed for a specific Person (via the PersonsVetting table)';
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingHits',
    @level2type = N'COLUMN', @level2name = N'VettingHitID',
	@value = N'Primary key & identity of the record in this table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingHits',
    @level2type = N'COLUMN', @level2name = N'PersonsVettingID',
	@value = N'Identifies the specific Person (via the PersonsVetting table) that the vetting result is associated with.  Foreign key pointing to the PersonsVetting table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingHits',
    @level2type = N'COLUMN', @level2name = N'VettingTypeID',
	@value = N'Identifies the type of vetting that the vetting result is associated with.  Foreign key pointing to the VettingTypes reference table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingHits',
    @level2type = N'COLUMN', @level2name = N'FirstMiddleNames',
	@value = N'First & Middle Names of the Participant being vetted.  Value is initialized to the value in [Persons].[FirstMiddleNames] and then is editable by the vetting unit.  Changes here are NOT pushed back to the [Persons] table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingHits',
    @level2type = N'COLUMN', @level2name = N'LastNames',
	@value = N'Last Names of the Participant being vetted.  Value is initialized to the value in [Persons].[LastNames] and then is editable by the vetting unit.  Changes here are NOT pushed back to the [Persons] table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingHits',
    @level2type = N'COLUMN', @level2name = N'DOBMonth',
	@value = N'Month of Date of Birth of the Participant being vetted.  Users can enter partial date.  Changes here are NOT pushed back to the [Persons] table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingHits',
    @level2type = N'COLUMN', @level2name = N'DOBDay',
	@value = N'Day of Date of Birth of the Participant being vetted.  Users can enter partial date.  Changes here are NOT pushed back to the [Persons] table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingHits',
    @level2type = N'COLUMN', @level2name = N'DOBYear',
	@value = N'Year of Date of Birth of the Participant being vetted.  Users can enter partial date.  Changes here are NOT pushed back to the [Persons] table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingHits',
    @level2type = N'COLUMN', @level2name = N'PlaceOfBirth',
	@value = N'Participant''s Place of Birth.  As the user enters characters into the field, the system will display an auto-populating drop-down list of concatenated City, State, Country values from the database that contain the entered values.  As the number of entered characters increases, the length of the list will decrease.  When the list displays what the user is looking for, they can select the item to finish populating the field.  If no match is found, the field will contain what the user has entered.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingHits',
    @level2type = N'COLUMN', @level2name = N'ReferenceSiteID',
	@value = N'Data source where the Hit was found.  Foreign key pointing to the [VettingHitReferenceSites] table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingHits',
    @level2type = N'COLUMN', @level2name = N'HitMonth',
	@value = N'Calendar month of the hit.  Valid values are 1 thru 12 & NULL.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingHits',
    @level2type = N'COLUMN', @level2name = N'HitDay',
	@value = N'Calendar day of the hit.  Valid values are 1 thru 31 & NULL.  NOTE: This value is not used by CONS vetting.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingHits',
    @level2type = N'COLUMN', @level2name = N'HitYear',
	@value = N'Calendar year of the hit.  Valid values are 1970 thru 2100 & NULL.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingHits',
    @level2type = N'COLUMN', @level2name = N'TrackingID',
	@value = N'Vetting unit tracking number of the hit.  How this field is used will vary across Posts.  It may be a unique value within the specific courtesy vetting unit or it may be specific within the Post across all courtesy vetting units.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingHits',
    @level2type = N'COLUMN', @level2name = N'UnitID',
	@value = N'Identifier of the host nation unit associated with the hit.  Foreign key pointing to the Units table. NOTE: This value is not used by CONS vetting.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingHits',
    @level2type = N'COLUMN', @level2name = 'HitUnit',
	@value = N'Identifier of the host nation unit associated with the hit.  This is a free form field on the UI. NOTE: This value is not used by CONS vetting.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingHits',
    @level2type = N'COLUMN', @level2name = N'HitLocation',
	@value = N'Location of the Hit.  As the user enters characters into the field, the system will display an auto-populating drop-down list of concatenated City, State, Country values from the database that contain the entered values.  As the number of entered characters increases, the length of the list will decrease.  When the list displays what the user is looking for, they can select the item to finish populating the field.  If no match is found, the field will contain what the user has entered. NOTE: This value is not used by CONS vetting.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingHits',
    @level2type = N'COLUMN', @level2name = N'ViolationTypeID',
	@value = N'Identifies the type of violation that the hit returned.  Foreign key pointing to the [VettingHitViolationTypes] table. NOTE: This value is not used by CONS vetting.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingHits',
    @level2type = N'COLUMN', @level2name = N'CredibilityLevelID',
	@value = N'Identifies the credibility level of hit returned.  Foreign key pointing to the [VettingHitCredibilityLevels] table. NOTE: This value is not used by CONS vetting.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingHits',
    @level2type = N'COLUMN', @level2name = N'HitDetails',
	@value = N'Details about the Hit found by the courtesy vetter.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingHits',
    @level2type = N'COLUMN', @level2name = N'Notes',
	@value = N'Miscellaneous notes or comments entered by the courtesy vetter.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingHits',
    @level2type = N'COLUMN', @level2name = N'VettingHitDate',
	@value = N'Date in MM/DD/YYYY format that the vetting process returned the results of the process.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingHits',
    @level2type = N'COLUMN', @level2name = N'VettingHitAppUserID',
	@value = N'Identifies the user who created the vetting hit record.  Foreign key pointing to the Users table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingHits',
    @level2type = N'COLUMN', @level2name = N'IsRemoved',
	@value = N'Flag that shows whether hit record is removed by the user.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'VettingHits',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the Users table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'VettingHits',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'VettingHits',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'VettingHits',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO