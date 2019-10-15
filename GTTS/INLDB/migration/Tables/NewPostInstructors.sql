/*
    NAME:   NewPostInstructors

    DESCR:  This is the import migration table that receives the imported records
            from the [ImportInstructors] table.

            The data is initially imported from the xlsx file into the [ImportInstructors] 
            table and then appended into the [NewPostInstructors] table (this table 
            script).  The data is then validated and either imported into the GTTS data tables or 
            marked as an exception and not imported.
*/
CREATE TABLE [migration].[NewPostInstructors]
(
	[NewPostInstructorID] BIGINT IDENTITY (1, 1) NOT NULL, -- Internal PK of table.    

	[NewPostImportID] BIGINT NULL,							-- FK to [NewPostImportLog] table.   

    -- *****************************************************
    -- BEGIN [Persons] BLOCK
    -- *****************************************************
	[FirstMiddleName] NVARCHAR(200) NULL,					-- The Instructor's Given & Middle Name(s).  
                                                            -- Mapped to [Persons].[FirstMiddleNames].

	[LastName] NVARCHAR(50) NULL,							-- The Instructor's Family Name.  
                                                            -- Mapped to [Persons].[LastNames].

	[NationalID] NVARCHAR(100) NULL,                        -- The Instructor's National ID (if applicable in their country).  
                                                            -- Mapped to [Persons].[NationalID].

	[Gender] NVARCHAR(10) NULL,                             -- The Instructor's gender or sex.  This value is converted to single character string
    [GenderFlag] CHAR(1) NULL,                              -- and written to [GenderFlag] as "M" for "Male" or "F" for "Female".  When the data is 
                                                            -- written to the GTTS data tables [GenderFlag] is mapped to [Persons].[Gender].

	[IsUSCitizen] NVARCHAR(3) NULL,							-- Indicates if the Instructor is a US Citizen.  This value is converted to a boolean
    [USCitizenFlag] BIT DEFAULT '0' NULL,                   -- and written to [USCitizenFlag] as "Yes" = TRUE or "No" = FALSE.  When the data is written
                                                            -- to the GTTS data tables, [USCitizenFlag] is mapped to [Persons].[IsUSCitizen] column.

	[DOB] DATETIME NULL,                                    -- Instructor's Date of Birth in MM/DD/YYYY format.  
                                                            -- Mapped to [Persons].[DOB].

	[POBCity] NVARCHAR(100) NULL,                           -- Name of the City that the Instructor was born in.
                                                            -- This will require that the specified City in [POBCity] undergoes a reverse lookup  
                                                            -- into the [Cities] table to get its matching [CityID] value (within the specified
                                                            -- State within the specfied Country) which is then stored in the [POBCityID] column  
                                                            -- in this table.  If the specified City is not found (does not exist or is misspelled), 
                                                            -- the 'UNKNOWN CITY' value will be used when writing the [CityID] value to the 
                                                            -- [POBCityID] column. 
                                                            -- NOTE 1: Even though the column order is City, State, Country, the data elements will 
                                                            -- be processed in Country, State, City order.  
                                                            -- NOTE 2: Each State within a Country will have its own 'UNKNOWN CITY' value in the 
                                                            -- [Cities] table.
    [POBCityID] INT NULL,                                   -- Mapped to [Persons].[POBCityID] column.  
	
    [POBState] NVARCHAR(75) NULL,                           -- Name of the State that the Instructor was born in.
                                                            -- This will require that the specified State in [POBState] undergoes a reverse lookup 
                                                            -- into the [States] table to get its matching [StateID] value (within the specfied Country)
                                                            -- which is then stored in the [POBStateID] column in this table.  If the specified State 
                                                            -- is not found (does not exist or is misspelled), the 'UNKNOWN STATE' value will be used 
                                                            -- when writing the [StateID] value to the [POBStateID] column. 
                                                            -- NOTE 1: Even though the column order is City, State, Country, the data elements will 
                                                            -- be processed in Country, State, City order.  
                                                            -- NOTE 2: Each Country will have its own 'UNKNOWN STATE' value in the [States] table.
    [POBStateID] INT NULL,                                  -- This value is used to find the list of Cities within the specified State.

	[POBCountry] NVARCHAR(75) NULL,                         -- Name of the Country that the Instructor was born in.
                                                            -- This will require that the specified Country in [POBCountry] undergoes a reverse lookup
                                                            -- into the [Countries] table to get its matching [CountryID] value which is then stored in  
                                                            -- the [POBCountryID] column in this table.  If the specified Country is not found (does 
                                                            -- not exist or is misspelled), the 'UNKNOWN COUNTRY' value will be used when writing the
                                                            -- [CountryID] value to the [POBCountryID] column. 
                                                            -- NOTE 1: Even though the column order is City, State, Country, the data elements will 
                                                            -- be processed in Country, State, City order.  
                                                            -- NOTE 2: The [Countries] table will have an 'UNKNOWN COUNTRY'.
    [POBCountryID] INT NULL,                                -- This value is used to find the list of States within the specified Country.

	[ResidenceCity] NVARCHAR(100) NULL,                     -- Name of the City that the Instructor resides in.
                                                            -- This will require that the specified City in [ResidenceCity] undergoes a reverse  
                                                            -- lookup into the [Cities] table to get its matching [CityID] value (within the specified
                                                            -- State within the specfied Country) which is then stored in the [ResidenceCityID] column  
                                                            -- in this table.  If the specified City is not found (does not exist or is misspelled), 
                                                            -- the 'UNKNOWN CITY' value will be used when writing the [CityID] value to the 
                                                            -- [ResidenceCityID] column. 
                                                            -- NOTE 1: Even though the column order is City, State, Country, the data elements will 
                                                            -- be processed in Country, State, City order.  
                                                            -- NOTE 2: Each State within a Country will have its own 'UNKNOWN CITY' value in the 
                                                            -- [Cities] table.
    [ResidenceCityID] INT NULL,                             -- Mapped to [Persons].[ResidenceLocationID] column.  
	
    [ResidenceState] NVARCHAR(75) NULL,                     -- Name of the State that the Instructor resides in.
                                                            -- This will require that the specified State in [ResidenceState] undergoes a reverse  
                                                            -- lookup into the [States] table to get its matching [StateID] value (within the specfied
                                                            -- Country) which is then stored in the [ResidenceStateID] column in this table.  If the
                                                            -- specified State is not found (does not exist or is misspelled), the 'UNKNOWN STATE' value
                                                            -- will be used when writing the [StateID] value to the [ResidenceStateID] column. 
                                                            -- NOTE 1: Even though the column order is City, State, Country, the data elements will 
                                                            -- be processed in Country, State, City order.  
                                                            -- NOTE 2: Each Country will have its own 'UNKNOWN STATE' value in the [States] table.
    [ResidenceStateID] INT NULL,                            -- This value is used to find the list of Cities within the specified State.

	[ResidenceCountry] NVARCHAR(75) NULL,                   -- Name of the Country that the Instructor resides in.
                                                            -- This will require that the specified Country in [ResidenceCountry] undergoes a reverse
                                                            -- lookup into the [Countries] table to get its matching [CountryID] value which is then 
                                                            -- stored in the [ResidenceCountryID] column in this table.  If the specified Country is  
                                                            -- not found (does not exist or is misspelled), the 'UNKNOWN COUNTRY' value will be used 
                                                            -- when writing the [CountryID] value to the [ResidenceCountryID] column. 
                                                            -- NOTE 1: Even though the column order is City, State, Country, the data elements will 
                                                            -- be processed in Country, State, City order.  
                                                            -- NOTE 2: The [Countries] table will have an 'UNKNOWN COUNTRY'.
    [ResidenceCountryID] INT NULL,                          -- This value is used to find the list of States within the specified Country.

	[ResidenceLocationID] BIGINT NULL,						-- LocationID from the [Locations] table for the Participant's Residence location.  This value
															-- requires that a valid [ResidenceCity], [ResidenceState], & [ResidenceCountry] exist in the database.

	[ContactEmail] NVARCHAR(256) NULL,                      -- Instructor's Email Address.  
                                                            -- Mapped to [Persons].[ContactEmail].
                                                            -- ????????????????????????????????????????????????????????????????????
                                                            -- MAPPING CHANGED TO [PersonsUnitLibraryInfo] ==> WHEN ?????
                                                            -- ???????????????????????????????????????????????????????????????????? 

	[ContactPhone] NVARCHAR(50) NULL,                       -- The Instructor's Telephone Number & Extension (if applicable).  
                                                            -- Mapped to [Persons].[ContactPhone].
                                                            -- ????????????????????????????????????????????????????????????????????
                                                            -- MAPPING CHANGED TO [PersonsUnitLibraryInfo] ==> WHEN ?????
                                                            -- ???????????????????????????????????????????????????????????????????? 

	[HighestEducation] NVARCHAR(25) NULL,                   -- The highest level of education the Instructor has completed. 
    [HighestEducationID] SMALLINT NULL,                     -- This will require a reverse lookup into the [EducationLevels] table to get its matching
                                                            -- [EducationLevelID] value which is then stored in the [HighestEducationID] column.  The 
                                                            -- value in [HighestEducationID] is mapped to [Persons].[HighestEducationID].

	[EnglishLanguageProficiency] NVARCHAR(50) NULL,         -- The level of proficiency the Instructor has in the English Language. 
    [EnglishLanguageProficiencyID] SMALLINT NULL,           -- This will require a reverse lookup into the [LanguageProficiencies] table get its
                                                            -- matching [LanguageProficiencyID] value which is then stored in the 
                                                            -- [EnglishLanguageProficiencyID] column.  The value in [EnglishLanguageProficiencyID] 
                                                            -- is mapped to [Persons].[EnglishLanguageProficiencyID].
                                                            -- ????????????????????????????????????????????????????????????????????
                                                            -- MAPPING CHANGED TO [PersonsUnitLibraryInfo] ==> WHEN ?????
                                                            -- ???????????????????????????????????????????????????????????????????? 
    -- *****************************************************
    -- END [Persons] BLOCK
    -- *****************************************************

    -- *****************************************************
    -- BEGIN [PersonsUnitLibraryInfo] & [Units] BLOCK
    -- NOTE: These values can only be used if the referenced 
    --       [UnitGentID] or [UnitBreakdown] values are found
    --       in the GTTS Unit Library ([Units] table).
    -- *****************************************************
    [UnitGenID]	NVARCHAR(50) NULL,                          -- The UnitGenID value that identifies the Instructor's assigned Unit.  
                                                            -- This value is validated against the [Units] table.  If the [UnitGenID] value in the 
                                                            -- import record does not exist in the [Units] table then the [UnitBreakdown] value 
                                                            -- should be validated against the [Units] table. If the [UnitBreakdown] value also does
                                                            -- exist in the [Units] table, then [UnitID] column in this table should be set to 0
                                                            -- and a data exception generated.  
                                                            -- If the Unit exists, then the [Units].[UnitID] value is written to [UnitID] in this
                                                            -- table and the [PersonsUnitLibraryInfo] record for the Particpant will 
                                                            -- be created or updated depending if the referenced Unit in the import matches the Unit
                                                            -- identified in the Instructor's current [PersonsUnitLibraryInfo] record.

	[UnitBreakdown] NVARCHAR(2048) NULL,                    -- Identifies the Instructor's assigned Unit.
                                                            -- This value is validated against the [Units] table.  Refer to comments above for 
                                                            -- [UnitGenID] for details on how the [UnitBreakdown] column works in tandem with 
                                                            -- the [UnitGenID] and [UnitID] columns.

    [UnitID] BIGINT NULL,                                   -- Identifies the Instructor's assigned Unit.   Refer to comments above for 
                                                            -- [UnitGenID] for details on how the [UnitID] column works in tandem with 
                                                            -- the [UnitGenID] and [UnitBreakdown] columns.
                                                            -- Mapped to [PersonsUnitLibraryInfo].[UnitID]

                                                            -- ????????????????????????????????????????????????????????????????????
    [UnitAlias] NVARCHAR(2048) NULL,                        -- NEED TO GET DETAILS ON HOW TO HANDLE THIS COLUMN.
                                                            -- ????????????????????????????????????????????????????????????????????

	[JobTitle] NVARCHAR(1024) NULL,							-- The Instructor's Job or Position Title.
                                                            -- Mapped to [PersonsUnitLibraryInfo].[JobTitle]

    [Rank] NVARCHAR(100) NULL,                              -- The name of the Instructor's Rank (if applicable).
	[RankID] INT NULL,                                      -- This will require a reverse lookup into the [Ranks] table to get its matching
                                                            -- [RankID] value which is then stored in the [RankID] column.  The 
                                                            -- value in [RankID] is mapped to [PersonsUnitLibraryInfo].[RankID]. 

	[UnitCommander] NVARCHAR(3) NULL,						-- Indicates if the Instructor is a Unit Commander.   
    [UnitCommanderFlag] BIT DEFAULT '0' NULL,               -- This value is converted to a boolean and written to [UnitCommanderFlag] as 
                                                            -- either "Yes" = TRUE or "No" = FALSE.  
                                                            -- The [UnitCommanderFlag] column is mapped to [PersonsUnitLibraryInfo].[IsUnitCommander]. 

	[YearsInPosition] INT NULL,                             -- The number of years that the Instructor has held the position indicated by [JobTitle].
                                                            -- Mapped to [PersonsUnitLibraryInfo].[YearsInPosition].

	[PoliceMilSecID] NVARCHAR(100) NULL,                    -- The Instructor's Military, Police, or Security Services Badge or ID Number.
                                                            -- Mapped to [PersonsUnitLibraryInfo].[PoliceMilSecID].

	[POCName] NVARCHAR(200) NULL,                           -- The name of the Instructor's Unit Point of Contact.
                                                            -- Mapped to [Units].[POCName].

	[POCEmailAddress] NVARCHAR(256) NULL,                   -- The Email Address for the Instructor's Unit Point of Contact.
                                                            -- Mapped to [Units].[POCEmailAddress]. 
    -- *****************************************************
    -- END [PersonsUnitLibraryInfo] & [Units] BLOCK
    -- *****************************************************

	[VettingType] NVARCHAR(75) NULL,                        -- Indicates the type of vetting that the Instructor should be undergoing.
    [IsVettingRequired] BIT NULL,                           -- This value will update the [IsVettingRequired] and [IsLeahyVettingReq] 
    [IsLeahyVettingReq] BIT NULL,                           -- columns as indicated below:
                                                            --      "NONE" ==>     Set [IsVettingRequired] = FALSE (0)
                                                            --                     Set [IsLeahyVettingReq] = FALSE (0)
                                                            --      "COURTESY" ==> Set [IsVettingRequired] = TRUE (1)
                                                            --                     Set [IsLeahyVettingReq] = FALSE (0)
                                                            --      "LEAHY" ==>    Set [IsVettingRequired] = TRUE (1)
                                                            --                     Set [IsLeahyVettingReq] = TRUE (1)
                                                            -- These columns will then be mapped to the [Persons].[IsVettingRequired] &
                                                            -- [Persons].[IsLeahyVettingReq] columns.

	[HasLocalGovTrust] NVARCHAR(20) NULL,                   -- Indicates if the Participant has been vetted by the Host Nation's Security Agency
    [HasLocalGovTrustFlag] BIT NULL,                        -- and if so, date they were vetted.  This value will be mapped to 
    [PassedLocalGovTrustFlag] BIT NULL,                     -- [HasLocalGovTrustFlag], [PassedLocalGovTrustFlag] & [LocalGovTrustCertDate] as indicated below:
	[LocalGovTrustCertDate] DATETIME NULL,                  --      "YES, PASSED"    ==> Set [HasLocalGovTrustFlag] = TRUE (1)
															--							 Set [PassedLocalGovTrustFlag] = TRUE (1)
                                                            --                           Set [LocalGovTrustCertDate] = date specified
                                                            --      "YES, FAILED"    ==> Set [HasLocalGovTrustFlag] = TRUE (1)
															--							 Set [PassedLocalGovTrustFlag] = FALSE (0)
                                                            --                           Set [LocalGovTrustCertDate] = date specified
                                                            --      "NO, NOT VETTED" ==> Set [HasLocalGovTrustFlag] = FALSE (0)
															--							 Set [PassedLocalGovTrustFlag] = FALSE (0)
                                                            --                           Set [LocalGovTrustCertDate] = NULL 
                                                            -- These columns will then be mapped to the [TrainingEventParticipants].[HasLocalGovTrust]
                                                            -- & [TrainingEventParticipants].[PassedLocalGovTrust], and 
															-- [TrainingEventParticipants].[LocalGovTrustCertDate] columns.

	[PassedExternalVetting] NVARCHAR(24) NULL,              -- Indicates if the Participant has been vetted by an external procees not covered by 
    [OtherVettingFlag] BIT NULL,							-- the [HasLocalGovTrust] flag above.  This value will be mapped to [OtherVettingFlag],
    [PassedOtherVettingFlag] BIT NULL,                      -- [PassedOtherVettingFlag] & [ExternalVettingDate] columns as indicated below:
                                                            --      "YES, PASSED"    ==> Set [OtherVettingFlag] = TRUE (1)
															--							 Set [PassedOtherVettingFlag] = TRUE (1)
                                                            --                           Set [ExternalVettingDate] = date specified   
                                                            --      "YES, FAILED"    ==> Set [OtherVettingFlag] = TRUE (1)
															--							 Set [PassedOtherVettingFlag] = FALSE (0)
                                                            --                           Set [ExternalVettingDate] = date specified   
                                                            --      "NO, NOT VETTED" ==> Set [OtherVettingFlag] = FALSE (0)
															--							 Set [PassedOtherVettingFlag] = FALSE (0)
                                                            --                           Set [ExternalVettingDate] = NULL      
                                                            -- These columns will then be mapped to the [TrainingEventParticipants].[PassedOtherVetting]
                                                            -- & [TrainingEventParticipants].[OtherVettingDate] columns. 
                                                         
	[ExternalVettingDescription] NVARCHAR(150) NULL,        -- The description of the external vetting process that was used. 
                                                            -- This column is mapped to [TrainingEventParticipants].[OtherVettingDescription].

	[ExternalVettingDate] DATETIME NULL,                    -- The date that the external vetting process that was completed.  If the value of  
                                                            -- [PassedExternalVetting] above is "NO, NOT VETTED", then this date is set to NULL.
                                                            -- This column is mapped to [TrainingEventParticipants].[OtherVettingDate].

	[DepartureCity]	NVARCHAR(127) NULL,                     -- Name of the City that the Instructor is departing from.
                                                            -- This will require that the specified City in [DepartureCity] undergoes a reverse  
                                                            -- lookup into the [Cities] table to get its matching [CityID] value (within the specified
                                                            -- State within the specfied Country) which is then stored in the [DepartureCityID] column  
                                                            -- in this table.  If the specified City is not found (does not exist or is misspelled), 
                                                            -- the 'UNKNOWN CITY' value will be used when writing the [CityID] value to the 
                                                            -- [DepartureCityID] column. 
                                                            -- ????????????????????????????????????????????????????????????????????
                                                            -- THIS SEARCH IS PERFORMED AGAINST WHAT POPULATION OF CITIES?
                                                            -- ????????????????????????????????????????????????????????????????????
    [DepartureCityID] INT NULL,                             -- Mapped to [Persons].[ResidenceLocationID] column.

	[PassportNumber] NVARCHAR(100) NULL,                    -- The Instructor's current passport identification number.  
                                                            -- This value will be mapped to [Persons].[PassportNumber].
                                                            -- ????????????????????????????????????????????????????????????????????
                                                            -- MAPPING CHANGED TO [PersonsUnitLibraryInfo] ==> WHEN ?????
                                                            -- ???????????????????????????????????????????????????????????????????? 

	[PassportExpirationDate] DATETIME NULL,                 -- The date that the Instructor's current passport expires in MM/DD/YYYY format.
                                                            -- This value will be mapped to [Persons].[PassportExpirationDate].
                                                            -- ????????????????????????????????????????????????????????????????????
                                                            -- MAPPING CHANGED TO [PersonsUnitLibraryInfo] ==> WHEN ?????
                                                            -- ????????????????????????????????????????????????????????????????????

	[Comments] NVARCHAR(4000) NULL,                         -- Comments or notes regarding the Instructor.  
                                                            -- This value will be mapped to [TrainingEventParticipants].[Comments].

    [PersonID] BIGINT NULL,                                 -- [Persons].[PersonID] & [TrainingEventParticipants].[PersonID] 
                                                            -- The [PersonID] value of the new Person record that was created (or matched to) as a result
                                                            -- of the import of the Instructor.  Foreign key pointing to the [Persons] table and also the
                                                            -- [TrainingEventParticipants] table.
    
    [PersonExists] BIT DEFAULT '0' NULL,                    -- Flag that indicates if the Instructor is new to the GTTS database (FALSE = 0) 
                                                            -- or already exists in the [Persons] table (TRUE = 1).

    [TrainingEventID] BIGINT NULL,                          -- [TrainingEventID] value of the new [TrainingEvents] table record that was created as a result
                                                            -- of the import of the Training Event that this Instructor is participating in.
                                                            -- Foreign key pointing to the [TrainingEvents] table.

	[ImportStatus] NVARCHAR(100) NULL,                      -- Status of the import process.  Valid values are:
                                                            -- 'Uploaded'                 = Data was uploaded into the [NewPostInstructors] table.
                                                            -- 'Exception - Not Imported' = Record was not imported due to data value/validation issues.
                                                            -- 'Imported                  = Record was processed, validated, and imported into the data tables.

                                                            -- ????????????????????????????????????????????????????????????????????
	[Validations] NVARCHAR(4000) NULL,                      -- NOT SURE IF THIS WILL BE NEEDED
                                                            -- ????????????????????????????????????????????????????????????????????
                                                            
	[ImportVersion] INT NULL,                               -- Version number of the template spreadsheet file from Excel file metadata. 

	[ModifiedByAppUserID] INT NOT NULL DEFAULT(2),          -- [AppUserID] value of 2 = 'ONBOARDING'.
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),

    CONSTRAINT [PK_NewPostInstructors] 
		PRIMARY KEY ([NewPostInstructorID]),

    CONSTRAINT [FK_NewPostInstructors_NewPostImportLog] 
        FOREIGN KEY ([NewPostImportID]) 
        REFERENCES [migration].[NewPostImportLog]([NewPostImportID]),

    CONSTRAINT [FK_NewPostInstructors_Persons] 
        FOREIGN KEY ([PersonID]) 
        REFERENCES [persons].[Persons]([PersonID]),

    CONSTRAINT [FK_NewPostInstructors_TrainingEvents] 
        FOREIGN KEY ([TrainingEventID]) 
        REFERENCES [training].[TrainingEvents]([TrainingEventID]),

    CONSTRAINT [FK_NewPostInstructors_AppUsers] 
        FOREIGN KEY ([ModifiedByAppUserID]) 
        REFERENCES [users].[AppUsers]([AppUserID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [migration].[NewPostInstructors_History]))
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'migration',
	@level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @value = N'Import migration table that holds the direct import results of the Instructors worksheet from the Training Event template xlsx file.'
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'NewPostInstructorID',
	@value = N'Primary key & identity value of the record in this table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'NewPostImportID',
	@value = N'This is the master import tracking ID that links all of the New Post Import records in the different [migration] tables to a specific import template file.  Foreign key pointing to the [NewPostImportLog] table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'FirstMiddleName',
	@value = N'The Instructor''s Given & Middle Name(s).  This value will be mapped to [Persons].[FirstMiddleNames].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'LastName',
	@value = N'The Instructor''s Family Name.  This value will be mapped to [Persons].[LastNames].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'NationalID',
	@value = N'The Instructor''s National ID (if applicable in their country).  This value will be mapped to [Persons].[NationalID].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'Gender',
	@value = N'The Instructor''s gender or sex.  This value is converted to single character string and written to [GenderFlag] as "M" for "Male" or "F" for "Female".'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'GenderFlag',
	@value = N'The Instructor''s gender or sex.  "M" for "Male" or "F" for "Female".  This column is mapped to mapped to [Persons].[Gender].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'IsUSCitizen',
	@value = N'Indicates if the Instructor is a US Citizen.  This value is converted to a boolean and written to [USCitizenFlag] as "Yes" = TRUE or "No" = FALSE.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'USCitizenFlag',
	@value = N'Indicates if the Instructor is a US Citizen.  "Yes" = TRUE or "No" = FALSE.  This column is mapped to mapped to [Persons].[IsUSCitizen].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'DOB',
	@value = N'Instructor''s Date of Birth in MM/DD/YYYY format.  This value will be mapped to [Persons].[DOB].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'POBCity',
	@value = N'The City that the Instructor was born in.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'POBCityID',
	@value = N'The retrieved ID value from the reverse lookup string match of [POBCity] against the [Cities] table.  If no matching value was found in the [Cities] table, this column will be populated with the value of ''UNKNOWN CITY''.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'POBState',
	@value = N'The State that the Instructor was born in.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'POBStateID',
	@value = N'The retrieved ID value from the reverse lookup string match of [POBState] against the [States] table.  If no matching value was found in the [States] table, this column will be populated with the value of ''UNKNOWN STATE''.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'POBCountry',
	@value = N'The Country that the Instructor was born in.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'POBCountryID',
	@value = N'The retrieved ID value from the reverse lookup string match of [POBCountry] against the [Countries] table.  If no matching value was found in the [Countries] table, this column will be populated with the value of ''UNKNOWN COUNTRY''.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'ResidenceCity',
	@value = N'The City that the Instructor resides in.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'ResidenceCityID',
	@value = N'The retrieved ID value from the reverse lookup string match of [ResidenceCity] against the [Cities] table.  If no matching value was found in the [Cities] table, this column will be populated with the value of ''UNKNOWN CITY''.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'ResidenceState',
	@value = N'The State that the Instructor resides in.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'ResidenceStateID',
	@value = N'The retrieved ID value from the reverse lookup string match of [ResidenceState] against the [States] table.  If no matching value was found in the [States] table, this column will be populated with the value of ''UNKNOWN STATE''.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'ResidenceCountry',
	@value = N'The Country that the Instructor resides in.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'ResidenceCountryID',
	@value = N'The retrieved ID value from the reverse lookup string match of [ResidenceCountry] against the [Countries] table.  If no matching value was found in the [Countries] table, this column will be populated with the value of ''UNKNOWN COUNTRY''.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'ResidenceLocationID',
	@value = N' LocationID from the [Locations] table for the Instructor''s Residence location.  This value requires that a valid [ResidenceCity], [ResidenceState], & [ResidenceCountry] exist in the database.'
GO

-- ????????????????????????????????????????????????????????????????????
-- MAPPING CHANGED TO [PersonsUnitLibraryInfo] ==> WHEN ?????
-- ???????????????????????????????????????????????????????????????????? 
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'ContactEmail',
	@value = N'The Instructor''s Email Address.   This value will be mapped to [Persons].[ContactEmail].'
GO

-- ????????????????????????????????????????????????????????????????????
-- MAPPING CHANGED TO [PersonsUnitLibraryInfo] ==> WHEN ?????
-- ???????????????????????????????????????????????????????????????????? 
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'ContactPhone',
	@value = N'The Instructor''s Telephone Number & Extension (if applicable).   This value will be mapped to [Persons].[ContactPhone].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'HighestEducation',
	@value = N'The highest level of education that the Instructor has completed.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'HighestEducationID',
	@value = N'The retrieved ID value from the reverse lookup string match of [EducationLevelID] in the [EducationLevels] table to get the corresponding [EducationLevels].[EducationLevelID] value which is then stored in [Persons].[HighestEducationID].'
GO

-- ????????????????????????????????????????????????????????????????????
-- MAPPING CHANGED TO [PersonsUnitLibraryInfo] ==> WHEN ?????
-- ???????????????????????????????????????????????????????????????????? 
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'EnglishLanguageProficiency',
	@value = N'The level of proficiency that the Instructor has in the English Language.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'EnglishLanguageProficiencyID',
	@value = N'The retrieved ID value from the reverse lookup string match of [EnglishLanguageProficiency] in the [LanguageProficiencies] table to get the corresponding [LanguageProficiencies].[LanguageProficiencyID] value which is then stored in [Persons].[EnglishLanguageProficiencyID].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'UnitGenID',
	@value = N'If the Unit Library for the Host Nation is in the [Units] table and the [UnitGenID] value for the Unit is known, then it will be in this column.  Otherwise this column will be NULL.  Refer to the [Units] table for details on how the [UnitGenID] is created.  This value will be used to validate the Instructor''s Unit information against the UnitLibrary for the Host Nation.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'UnitBreakdown',
	@value = N'If the Unit Library for the Host Nation is NOT in the [Units] table or the [UnitGenID] value for the Unit is not known, then this column will contain a Unit Breakdown of the Instructor''s Unit.  The Unit Breakdown is comprised of the Name of the Instructor''s Unit and the next 4 parent units of the Instructor''s Unit.  Format should be: Great-Great-Grandparent Unit / Great-Grandparent Unit / Grandparent Unit / Parent Unit / Unit.  This value will be used to validate the Instructor''s Unit information against the UnitLibrary for the Host Nation.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'UnitID',
	@value = N'Identifies the Instructor''s assigned Unit. This value is validated against the [Units] table.  If the Unit specified by [UnitGenID] and/or [UnitBreakdown] exists, the Unit''s UnitID value is stored in this column.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'UnitAlias',
	@value = N'If the Unit Library for the Host Nation is NOT in the [Units] table or the [UnitGenID] for the Unit is not known, then this column will contain any aliases or alternative names for the Instructor''s Unit.  This value will be used to validate the Instructor''s Unit information against the UnitLibrary for the Host Nation.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'JobTitle',
	@value = N'The Instructor''s Job or Position Title.  This column is mapped to [PersonsUnitLibraryInfo].[JobTitle]'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'Rank',
	@value = N'The name of the Instructor''s Rank (if applicable).'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'RankID',
	@value = N'The retrieved ID value from the reverse lookup string match of [Rank] in the [Ranks] table to get the corresponding [Ranks].[RankID] value which is then stored in [PersonsUnitLibraryInfo].[RankID].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'UnitCommander',
	@value = N'Indicates if the Instructor is a Unit Commander.  This value is converted to a boolean and written to [UnitCommanderFlag] as "Yes" = TRUE or "No" = FALSE.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'UnitCommanderFlag',
	@value = N'Indicates if the Instructor is a Unit Commander.  Yes" = TRUE or "No" = FALSE.  This column is mapped to mapped to [PersonsUnitLibraryInfo].[IsUnitCommander].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'YearsInPosition',
	@value = N'The number of years that the Instructor has held the position indicated by [JobTitle].  Mapped to [PersonsUnitLibraryInfo].[YearsInPosition].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'PoliceMilSecID',
	@value = N'The Instructor''s Military, Police, or Security Services Badge or ID Number.  Mapped to [PersonsUnitLibraryInfo].[PoliceMilSecID].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'POCName',
	@value = N'The name of the Point of Contact for the Particpant''s Unit.  This value will be mapped & validated against [Units].[POCName].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'POCEmailAddress',
	@value = N'The Email Address for the Point of Contact for the Particpant''s Unit.  This value will be mapped & validated against [Units].[POCEmailAddress].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'VettingType',
	@value = N'Indicates the type of vetting that the Instructor should be undergoing.  This value will be mapped to both [IsVettingRequired] and[IsLeahyVettingReq] as follows:  NONE ==> ([IsVettingRequired] = NO & [IsLeahyVettingReq] = NO), COURTESTY ==> ([IsVettingRequired] = YES & [IsLeahyVettingReq] = NO), or LEHY ==> ([IsVettingRequired] = YES & [IsLeahyVettingReq] = YES)  These are boolean columns where "YES" = TRUE, "NO" = FALSE.'  
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'IsVettingRequired',
	@value = N'Result of validation of the [NewPostInstructors].[VettingType] column.  Mapped to [Persons].[IsVettingRequired].'  
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'IsLeahyVettingReq',
	@value = N'Result of validation of the [NewPostInstructors].[VettingType] column.  Mapped to [Persons].[IsLeahyVettingReq].'  
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'HasLocalGovTrust',
	@value = N'Indicates if the Participant has been vetted by the Host Nation''s Security Agency & if they passed or failed.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'HasLocalGovTrustFlag',
	@value = N'Indicates if the Participant was vetted by the Host Nation''s Security Agency.  Mapped to [TrainingEventParticipants].[HasLocalGovTrust].'  
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'PassedLocalGovTrustFlag',
	@value = N'Indicates if the Participant passed or failed vetting by their Host Nation''s Security Agency.  Mapped to [TrainingEventParticipants].[PassedLocalGovTrustFlag].'  
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'LocalGovTrustCertDate',
	@value = N'The date that the Participant was vetted by the Host Nation''s Security Agency.  Mapped to [TrainingEventParticipants].[LocalGovTrustCertDate].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'PassedExternalVetting',
	@value = N'Indicates if the Participant has been vetted by an external process not covered by the [HasLocalGovTrust] flag above.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'OtherVettingFlag',
	@value = N'Indicates if the Participant underwent an external vetting process not covered by the [HasGovTrust] flag.  Mapped to [TrainingEventInstructors].[OtherVettinglag].'  
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'PassedOtherVettingFlag',
	@value = N'Indicates if the Participant passed or failed the external vetting process.  Mapped to [TrainingEventParticipants].[PassedOtherVetting].'  
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'ExternalVettingDescription',
	@value = N'The description of the external vetting process that was used. Mapped to [TrainingEventParticipants].[OtherVettingDescription].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'ExternalVettingDate',
	@value = N'The date that the external vetting process that was completed.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'DepartureCity',
	@value = N'The name of the City that the Instructor will be travelling from if they will need to travel to attend the Training Event.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'DepartureCityID',
	@value = N'The retrieved ID value from the reverse lookup string match of [DepartureCity] against the [Cities] table.  If no matching value was found in the [Cities] table, this column will be populated with the value of ''UNKNOWN CITY''.'
GO

-- ????????????????????????????????????????????????????????????????????
-- MAPPING CHANGED TO [PersonsUnitLibraryInfo] ==> WHEN ?????
-- ???????????????????????????????????????????????????????????????????? 
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'PassportNumber',
	@value = N'The Instructor''s current passport identification number.  This value will be mapped to [Persons].[PassportNumber].'
GO

-- ????????????????????????????????????????????????????????????????????
-- MAPPING CHANGED TO [PersonsUnitLibraryInfo] ==> WHEN ?????
-- ???????????????????????????????????????????????????????????????????? 
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'PassportExpirationDate',
	@value = N'The date that the Instructor''s current passport expires in MM/DD/YYYY format.   This value will be mapped to [Persons].[PassportExpirationDate].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'Comments',
	@value = N'Comments or notes regarding the Instructor.  This value will be mapped to [TrainingEventParticipants].[Comments].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'PersonID',
	@value = N'The [PersonID] value of the new Person record that was created (or matched to) as a result of the import of the Instructor.  Foreign key pointing to the [Persons] table and also the [TrainingEventParticipants] table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'PersonExists',
	@value = N'Flag that indicates if the Instructor is new to the GTTS database (FALSE = 0) or already exists in the [Persons] table (TRUE = 1).'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'TrainingEventID',
	@value = N'The [TrainingEventID] value of the new [TrainingEvents] table record that was created as a result of the import of the Training Event that this Instructor is participating in.  Foreign key pointing to the [TrainingEvents] table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'ImportStatus',
	@value = N'The status of the upload of the Locations data into the database data tables. Valid values for this column are ''Uploaded'', ''Exception - Not Imported'', and  ''Imported''.  ''Uploaded'' means that the data was uploaded into the [NewPostInstructors] table.  ''Exception - Not Imported'' means that there were data value/validation issues that prevented the record from being imported into the database data tables.  Details of the specific issues will be written to the [NewPostImportExceptions] table.  ''Imported'' means that the data was processed, validated, and imported into the database data tables.  This is an internal management & control column that does not have a matching database data column outside of the [NewPostInstructors] table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'Validations',
	@value = N'Contains the results of the validations processing during the upload process.  This is an internal management & control column that does not have a matching database data column outside of the [NewPostInstructors] table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostInstructors',
    @level2type = N'COLUMN', @level2name = N'ImportVersion',
	@value = N'Identifies the version number of the template spreadsheets.  This is an internal management & control column that does not have a matching database data column outside of the [NewPostInstructors] table.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'migration',
	@level1type = N'TABLE',  @level1name = N'NewPostInstructors',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Default value of 1 is the User known as ''NEW POST IMPORT''.  Foreign key pointing to the [AppUsers] table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'migration',
	@level1type = N'TABLE',  @level1name = N'NewPostInstructors',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'migration',
	@level1type = N'TABLE',  @level1name = N'NewPostInstructors',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
	@level1type = N'TABLE',  @level1name = N'NewPostInstructors',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod for which the record is valid.'
GO