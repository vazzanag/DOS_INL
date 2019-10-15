CREATE TABLE [training].[ParticipantsXLSX]
(
	[ParticipantXLSXID] BIGINT IDENTITY (1, 1) NOT NULL,
	[EventXLSXID] BIGINT  NULL,				-- Nullable FK to [TrainingEventsXLSX]
	[TrainingEventID] BIGINT NULL,			-- Nullable FK to [TrainingEvents]
	[PersonID] BIGINT NULL,					-- Nullable FK to [Persons]
	[ParticipantStatus] NVARCHAR(15) NOT NULL,
	[FirstMiddleName] NVARCHAR(200) NOT NULL,
	[LastName] NVARCHAR(50) NOT NULL,
	[NationalID] NVARCHAR(100) NULL,
	[Gender] CHAR(1) NOT NULL,
	[IsUSCitizen] NVARCHAR(3) NOT NULL,
	[DOB] DATETIME NULL,
	[POBCity] NVARCHAR(100) NULL,
	[POBState] NVARCHAR(75) NULL,
	[POBCountry] NVARCHAR(75) NULL,
	[ResidenceCity] NVARCHAR(100) NULL,
	[ResidenceState] NVARCHAR(75) NULL,
	[ResidenceCountry] NVARCHAR(75) NULL,
	[ContactEmail] NVARCHAR(256) NULL,
	[ContactPhone] NVARCHAR(50) NULL,
	[HighestEducation] NVARCHAR(25) NULL,
	[EnglishLanguageProficiency] NVARCHAR(50) NULL,
	[UnitGenID]	NVARCHAR(50) NULL,
	[UnitBreakdown] NVARCHAR(2048) NULL,
	[UnitAlias] NVARCHAR(2048) NULL,
	[JobTitle] NVARCHAR(1024) NOT NULL,
	[Rank] NVARCHAR(100) NULL,
	[IsUnitCommander] NVARCHAR(3) NULL,
	[YearsInPosition] INT NULL,
	[PoliceMilSecID] NVARCHAR(100) NULL,
	[POCName] NVARCHAR(200) NULL,
	[POCEmailAddress] NVARCHAR(256) NULL,
	[VettingType] NVARCHAR(75) NULL,
	[HasLocalGovTrust] NVARCHAR(20) NULL,
	[LocalGovTrustCertDate] DATETIME NULL,
	[PassedExternalVetting] NVARCHAR(24) NULL,
	[ExternalVettingDescription] NVARCHAR(100) NULL,
	[ExternalVettingDate] DATETIME NULL,
	[DepartureCity]	NVARCHAR(127) NULL,
	[DepartureCityID] INT NULL,
	[DepartureStateID] INT NULL,
	[DepartureCountryID] INT NULL,
	[PassportNumber] NVARCHAR(100) NULL,
	[PassportExpirationDate] DATETIME NULL,
	[Comments] NVARCHAR(4000) NULL,
	[MarkForAction] NVARCHAR(15) NULL,
	[LoadStatus] NVARCHAR(15) NULL,
	[Validations] NVARCHAR(4000) NULL,
	[ImportVersion] INT NULL,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),
    CONSTRAINT [PK_ParticipantXLSXID] 
		PRIMARY KEY ([ParticipantXLSXID]),
    CONSTRAINT [FK_ParticipantsXLSX_TrainingEventsXLSX] 
        FOREIGN KEY ([EventXLSXID]) 
        REFERENCES [training].[TrainingEventsXLSX]([EventXLSXID]),
    CONSTRAINT [FK_ParticipantsXLSX_TrainingEvents] 
        FOREIGN KEY ([TrainingEventID]) 
        REFERENCES [training].[TrainingEvents]([TrainingEventID]),
    CONSTRAINT [FK_ParticipantsXLSX_Persons] 
        FOREIGN KEY ([PersonID]) 
        REFERENCES [persons].[Persons]([PersonID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [training].[ParticipantsXLSX_History]))
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
	@value = N'Upload table that holds the Participants data that is imported into the database via an upload function.  Data is imported into GTTS via a 3-step process: 1) Upload data from spreadsheet file into the corresponding upload table, 2) Validate, preview and edit uploaded data in the upload table, 3) Import the validated & edited data in the upload table into the GTTS data tables.';
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'ParticipantXLSXID',
	@value = N'Primary key & identity of the record in this table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'EventXLSXID',
	@value = N'The [TrainingEventXLSX].[EventXLSXID] value for the [TrainingEventXLSX] record that the Participant is associated with.  If the Participant is being uploaded into an existing Training Event (vs. migrating data from new posts), then this value will be NULL.  This is an internal management & control column that does not have a matching database data column outside of the [ParticipantsXLSX] table.  Foreign key pointing to the TrainingEventXLSX table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'TrainingEventID',
	@value = N'The [TrainingEvents].[TrainingEventID] value for the Training Event that the Participant is being uploaded into.  This is an internal management & control column that does not have a matching database data column outside of the [ParticipantsXLSX] table.  Foreign key pointing to the TrainingEvents data table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'PersonID',
	@value = N'If the Participant was matched to an existing Person in the [Persons] table, that [PersonID] is identified here.  This is an internal management & control column that does not have a matching database data column outside of the [ParticipantsXLSX] table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'ParticipantStatus',
	@value = N'Indicates if the Participant is an Event Participant or Event Alternate.  This value will be mapped as a boolean value to [TrainingEventParticipants].[IsParticipant].  Event Participant = TRUE, Event Alternate = FALSE.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'FirstMiddleName',
	@value = N'The Participant''s Given & Middle Name(s).  This value will be mapped to [Persons].[FirstMiddleNames].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'LastName',
	@value = N'The Participant''s Family Name.  This value will be mapped to [Persons].[LastNames].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'NationalID',
	@value = N'The Participant''s National ID (if applicable in their country).  This value will be mapped to [Persons].[NationalID].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'Gender',
	@value = N'The Participant''s gender or sex.  Valid values would be Male or Female.  This value will be mapped to [Persons].[Gender].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'IsUSCitizen',
	@value = N'Indicates if the Participant is a US Citizen or not.  Valid values would be "Yes" = TRUE, "No" = FALSE.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'DOB',
	@value = N'Participant''s Date of Birth in MM/DD/YYYY format.  This value will be mapped to [Persons].[DOB].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'POBCity',
	@value = N'The City that the Participant was born in.  This value will be mapped to [Persons].[POBLocationID] which is a FK to the [Locations] table.  This column along with the [POBState] & [POBCountry} columns are used to identify the correct record in [Locations] that corresponds to the specified [Locations] record.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'POBState',
	@value = N'The State that the Participant was born in.  This value will be mapped to [Persons].[POBLocationID] which is a FK to the [Locations] table.  This column along with the [POBCity] & [POBCountry} columns are used to identify the correct record in [Locations] that corresponds to the specified [Locations] record.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'POBCountry',
	@value = N'The Country that the Participant was born in.  This value will be mapped to [Persons].[POBLocationID] which is a FK to the [Locations] table.  This column along with the [POBCity] & [POBState} columns are used to identify the correct record in [Locations] that corresponds to the specified [Locations] record.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'ResidenceCity',
	@value = N'The City that the Participant resides in.  This value will be mapped to [Persons].[ResidenceLocationID] which is a FK to the [Locations] table.  This column along with the [ResidenceState] & [ResidenceCountry} columns are used to identify the correct record in [Locations] that corresponds to the specified [Locations] record.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'ResidenceState',
	@value = N'The State that the Participant resides in.  This value will be mapped to [Persons].[ResidenceLocationID] which is a FK to the [Locations] table.  This column along with the [ResidenceCity] & [ResidenceCountry} columns are used to identify the correct record in [Locations] that corresponds to the specified [Locations] record.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'ResidenceCountry',
	@value = N'The Country that the Participant resides in.  This value will be mapped to [Persons].[ResidenceLocationID] which is a FK to the [Locations] table.  This column along with the [ResidenceCity] & [ResidenceState} columns are used to identify the correct record in [Locations] that corresponds to the specified [Locations] record.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'ContactEmail',
	@value = N'The Participant''s Email Address.   This value will be mapped to [Persons].[ContactEmail].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'ContactPhone',
	@value = N'The Participant''s Telephone Number & Extension (if applicable).   This value will be mapped to [Persons].[ContactPhone].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'HighestEducation',
	@value = N'The highest level of education that the Participant has completed.  This value will be mapped to [EducationLevels].[Code} in order to get the proper [EducationLevels].[EducationLevelID] value which is then stored in [Persons].[HighestEducationID].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'EnglishLanguageProficiency',
	@value = N'The level of proficiency that the Participant has in the English Language.  This value will be mapped to [LanguageProficiencies].[Code} in order to get the proper [LanguageProficiencies].[LanguageProficiencyID] value which is then stored in [Persons].[EnglishLanguageProficiencyID].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'UnitGenID',
	@value = N'If the Unit Library for the Host Nation is in the [UnitLibrary] table and [UnitGenID] for the Unit is known, then it will be in this column.  Otherwise this column will be NULL.  Refer to the [UnitLibrary] table for details on how the [UnitGenID] is created.  This value will be used to validate the Participant''s Unit information against the UnitLibrary for the Host Nation.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'UnitBreakdown',
	@value = N'If the Unit Library for the Host Nation is NOT in the [UnitLibrary] table or the [UnitGenID] for the Unit is not known, then this column will contain a Unit Breakdown of the Participant''s Unit.  The Unit Breakdown is comprised of the Name of the Participant''s Unit and the next 4 parent units of the Participant''s Unit.  Format should be: Great-Great-Grandparent Unit / Great-Grandparent Unit / Grandparent Unit / Parent Unit / Unit.  This value will be used to validate the Participant''s Unit information against the UnitLibrary for the Host Nation.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'UnitAlias',
	@value = N'If the Unit Library for the Host Nation is NOT in the [UnitLibrary] table or the [UnitGenID] for the Unit is not known, then this column will contain any aliases or alternative names for the Participant''s Unit.  This value will be used to validate the Participant''s Unit information against the UnitLibrary for the Host Nation.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'JobTitle',
	@value = N'The name of the Participant''s current job title.  This value will be validated against [JobTitles].[JobTitleCode], [JobTitles].[JobTitleLocalLanguage], and  [JobTitles].[JobTitleEnglish] in order to get the correct [JobTitles].[JobTitleID] to store in [PersonsUnitLibraryInfo].[JobTitleID].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'Rank',
	@value = N'The name of the Participant''s Rank (if applicable).  This value will be validated against [Ranks].[RankName] in order to get the correct [Ranks].[RankID] to store in [PersonsUnitLibraryInfo].[RankID].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'IsUnitCommander',
	@value = N'Indicates if the Participant is a Unit Commander.  This value will be mapped as a boolean value to [PersonsUnitLibraryInfo].[IsUnitCommander].  "Yes" = TRUE, "No" = FALSE.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'YearsInPosition',
	@value = N'The number of years that the Participant has held the position indicated by [JobTitle].  This value will be mapped to [PersonsUnitLibraryInfo].[YearsInPosition].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'PoliceMilSecID',
	@value = N'The Participant''s Military, Police, or Security Services Badge or ID Number.  This value is mapped to [PersonsUnitLibraryInfo].[PoliceMilSecID].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'POCName',
	@value = N'The name of the Point of Contact for the Particpant''s Unit.  This value will be validated against [UnitLibrary].[POCName].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'POCEmailAddress',
	@value = N'The Email Address for the Point of Contact for the Particpant''s Unit.  This value will be validated against [UnitLibrary].[POCEmailAddress].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'VettingType',
	@value = N'Indicates the type of vetting that the Participant should be undergoing.  This value will be mapped to both [Persons].[IsVettingRequired] and [Persons].[[IsLeahyVettingReq]] as follows:  NONE ==> ([IsVettingRequired] = NO & [IsLeahyVettingReq] = NO), Courtesy ==> ([IsVettingRequired] = YES & [IsLeahyVettingReq] = NO), or Leahy ==> ([IsVettingRequired] = YES & [IsLeahyVettingReq] = YES)  These are boolean columns where "YES" = TRUE, "NO" = FALSE.'  
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'HasLocalGovTrust',
	@value = N'Indicates if the Participant has been vetted by the Host Nation.  This value will be mapped as a boolean value to [PersonsUnitLibraryInfo].[HasLocalGovTrust].  "Yes" = TRUE, "No" = FALSE.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'LocalGovTrustCertDate',
	@value = N'The date that the Participant was vetted by the Host Nation in MM/DD/YYYY format.  This value will be mapped to [PersonsUnitLibraryInfo].[LocalGovTrustCertDate].  "Yes" = TRUE, "No" = FALSE.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'PassedExternalVetting',
	@value = N'Indicates if the Participant has been vetted by an external 3rd Party.  This value will be mapped as a boolean value to [PersonsUnitLibraryInfo].[PassedExternalVetting].  "Yes" = TRUE, "No" = FALSE.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'ExternalVettingDescription',
	@value = N'The description of the external 3rd Party that vetted the Participant.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'ExternalVettingDate',
	@value = N'The date that the Participant was vetted by an external 3rd Party in MM/DD/YYYY format.  This value will be mapped to [PersonsUnitLibraryInfo].[ExternalVettingDate].  "Yes" = TRUE, "No" = FALSE.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'DepartureCity',
	@value = N'The name of the City that the Participant will be travelling from if they will need to travel to attend the Training Event.  This value is used to identify the correct [Cities].[CityID] value to be stored in [TrainingEventParticipants].[DepartureCityID].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'DepartureCityID',
	@value = N'The ID of the City that the Participant will be travelling from if they will need to travel to attend the Training Event.  This value is used to identify the correct [Cities].[CityID] value to be stored in [TrainingEventParticipants].[DepartureCityID].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'DepartureStateID',
	@value = N'The ID of the State that the Participant will be travelling from if they will need to travel to attend the Training Event.  This value is used to identify the correct [Cities].[CityID] value to be stored in [TrainingEventParticipants].[DepartureCityID].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'DepartureCountryID',
	@value = N'The name of the Country that the Participant will be travelling from if they will need to travel to attend the Training Event.  This value is used to identify the correct [Cities].[CityID] value to be stored in [TrainingEventParticipants].[DepartureCityID].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'PassportNumber',
	@value = N'The Participant''s current passport identification number.  This value will be mapped to [Persons].[PassportNumber].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'PassportExpirationDate',
	@value = N'The date that the Participant''s current passport expires in MM/DD/YYYY format.   This value will be mapped to [Persons].[PassportExpirationDate].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'Comments',
	@value = N'Comments or notes regarding the Participant.  This value will be mapped to [TrainingEventParticipants].[Comments].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'MarkForAction',
	@value = N'Identifies the current processing status of the record with respect to the Upload/Validate/Import process.  This is an internal management & control column that does not have a matching database data column outside of the [ParticipantsXLSX] table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'LoadStatus',
	@value = N'The status of the upload of the Participants data into the database data tables. Valid values for this column are ''Uploaded'', ''Imported''.  ''Uploaded'' means that the data was uploaded into the ParticipantXLSX table.  ''Imported'' means that the data was processed, validated, and imported into the database data tables.  This is an internal management & control column that does not have a matching database data column outside of the [ParticipantsXLSX] table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'Validations',
	@value = N'Contains the results of the validations processing during the upload process.  This is an internal management & control column that does not have a matching database data column outside of the [ParticipantsXLSX] table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
    @level2type = N'COLUMN', @level2name = N'ImportVersion',
	@value = N'Identifies the version number of the template spreadsheets.  This is an internal management & control column that does not have a matching database data column outside of the [ParticipantsXLSX] table.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the Users table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'ParticipantsXLSX',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO