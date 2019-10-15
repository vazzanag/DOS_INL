CREATE TABLE [persons].[Persons]
(
	[PersonID] BIGINT IDENTITY (1, 1) NOT NULL,
	[FirstMiddleNames] NVARCHAR(150) NOT NULL,
	[LastNames] NVARCHAR(150) NULL,
	[Gender] CHAR(1) NOT NULL,
	[IsUSCitizen] BIT NOT NULL,
	[NationalID] NVARCHAR(100) NULL,
	[ResidenceLocationID] BIGINT NULL,
	[ContactEmail] NVARCHAR(256) NULL,
	[ContactPhone] NVARCHAR(50) NULL,
	[DOB] DATETIME NULL,
	[POBCityID] INT NULL,
	[FatherName] NVARCHAR(200) NULL,
	[MotherName] NVARCHAR(200) NULL,
	[HighestEducationID] SMALLINT NULL,
	[FamilyIncome] DECIMAL NULL,
	[EnglishLanguageProficiencyID] SMALLINT	NULL,
	[PassportNumber] NVARCHAR(100)  NULL,
	[PassportExpirationDate] DATETIME   NULL,
    [PassportIssuingCountryID] INT NULL,
	[MedicalClearanceStatus] BIT NULL,
	[MedicalClearanceDate] DATETIME NULL,
	[DentalClearanceStatus]  BIT NULL,
	[DentalClearanceDate] DATETIME NULL,
	[PsychologicalClearanceStatus]  BIT NULL,
	[PsychologicalClearanceDate] DATETIME NULL,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (sysutcdatetime()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),	
    CONSTRAINT [PK_Persons] 
		PRIMARY KEY ([PersonID]),
    CONSTRAINT [FK_Persons_Locations]
		FOREIGN KEY ([ResidenceLocationID]) 
		REFERENCES [location].[Locations]([LocationID]),
    CONSTRAINT [FK_POBLocationID]
		FOREIGN KEY ([POBCityID]) 
		REFERENCES [location].[Cities]([CityID]),
	CONSTRAINT [FK_Persons_EducationLevels]
		FOREIGN KEY ([HighestEducationID]) 
		REFERENCES [persons].[EducationLevels]([EducationLevelID]),
    CONSTRAINT [FK_Persons_LanguageProficiencies]
		FOREIGN KEY ([EnglishLanguageProficiencyID]) 
		REFERENCES [location].[LanguageProficiencies]([LanguageProficiencyID]),	
    CONSTRAINT [FK_Persons_PassportIssuingCountry]
		FOREIGN KEY ([PassportIssuingCountryID]) 
		REFERENCES [location].[Countries]([CountryID]),	
    CONSTRAINT [FK_Persons_AppUsers_ModifiedByAppUserID]
		FOREIGN KEY ([ModifiedByAppUserID]) 
		REFERENCES [users].[AppUsers]([AppUserID]) 	
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [persons].[Persons_History]))
GO

CREATE INDEX [IDX_FirstMiddleNames] ON [persons].[Persons] ([FirstMiddleNames] ASC)
	WITH (
			PAD_INDEX = OFF
			,STATISTICS_NORECOMPUTE = OFF
			,SORT_IN_TEMPDB = OFF
			,DROP_EXISTING = OFF
			,ONLINE = OFF
			,ALLOW_ROW_LOCKS = ON
			,ALLOW_PAGE_LOCKS = ON
			) ON [PRIMARY]
GO

CREATE INDEX [IDX_LastNames] ON [persons].[Persons] ([LastNames] ASC)
	WITH (
			PAD_INDEX = OFF
			,STATISTICS_NORECOMPUTE = OFF
			,SORT_IN_TEMPDB = OFF
			,DROP_EXISTING = OFF
			,ONLINE = OFF
			,ALLOW_ROW_LOCKS = ON
			,ALLOW_PAGE_LOCKS = ON
			) ON [PRIMARY]
GO	

CREATE INDEX [IDX_ContactEmail] ON [persons].[Persons] ([ContactEmail] ASC)
	WITH (
			PAD_INDEX = OFF
			,STATISTICS_NORECOMPUTE = OFF
			,SORT_IN_TEMPDB = OFF
			,DROP_EXISTING = OFF
			,ONLINE = OFF
			,ALLOW_ROW_LOCKS = ON
			,ALLOW_PAGE_LOCKS = ON
			) ON [PRIMARY]
GO

CREATE INDEX [IDX_ContactPhone] ON [persons].[Persons] ([ContactPhone] ASC)
	WITH (
			PAD_INDEX = OFF
			,STATISTICS_NORECOMPUTE = OFF
			,SORT_IN_TEMPDB = OFF
			,DROP_EXISTING = OFF
			,ONLINE = OFF
			,ALLOW_ROW_LOCKS = ON
			,ALLOW_PAGE_LOCKS = ON
			) ON [PRIMARY]
GO

CREATE INDEX [IDX_PassportNumber] ON [persons].[Persons] ([PassportNumber] ASC)
	WITH (
			PAD_INDEX = OFF
			,STATISTICS_NORECOMPUTE = OFF
			,SORT_IN_TEMPDB = OFF
			,DROP_EXISTING = OFF
			,ONLINE = OFF
			,ALLOW_ROW_LOCKS = ON
			,ALLOW_PAGE_LOCKS = ON
			) ON [PRIMARY]
GO

CREATE FULLTEXT INDEX ON persons.Persons(FirstMiddleNames, LastNames, NationalID) 
    KEY INDEX [PK_Persons] ON FullTextCatalog 
    WITH CHANGE_TRACKING AUTO; 
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level1type = N'TABLE', 
	@level0name = N'persons', @level1name = N'Persons',
	@value = N'Data table of participants, instructors and other persons tracked within GTTS.';
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'Persons',
    @level2type = N'COLUMN', @level2name = N'PersonID',
	@value = N'Primary key & identity of the record in this table.'
GO

/*  Other data field descriptions  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'Persons',
	@level2type = N'COLUMN', @level2name = N'FirstMiddleNames',
	@value = N'Person''s First and Middle Names.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'Persons',
	@level2type = N'COLUMN', @level2name = N'LastNames',
	@value = N'Person''s Last Names.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'Persons',
	@level2type = N'COLUMN', @level2name = N'Gender',
	@value = N'Identifies the Person''s gender.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'Persons',
	@level2type = N'COLUMN', @level2name = N'IsUSCitizen',
	@value = N'Boolean that indicates if the Person is a US Citizen.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'Persons',
	@level2type = N'COLUMN', @level2name = N'NationalID',
	@value = N'Person''s National ID value (if applicable).'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'Persons',
	@level2type = N'COLUMN', @level2name = N'ResidenceLocationID',
	@value = N'Identifies the Person''s place of residence.  Foreign key pointing to the Locations table.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'Persons',
	@level2type = N'COLUMN', @level2name = N'ContactEmail',
	@value = N'Person''s contact email address.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'Persons',
	@level2type = N'COLUMN', @level2name = N'ContactPhone',
	@value = N'Person''s contact telephone number.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'Persons',
	@level2type = N'COLUMN', @level2name = N'DOB',
	@value = N'Person''s Date of Birth.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'Persons',
	@level2type = N'COLUMN', @level2name = N'POBCityID',
	@value = N'Identifies the Person''s City of birth.  Foreign key pointing to the Cities table.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'Persons',
	@level2type = N'COLUMN', @level2name = N'FatherName',
	@value = N'Full name of Person''s Father.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'Persons',
	@level2type = N'COLUMN', @level2name = N'MotherName',
	@value = N'Full name of Person''s Mother.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'Persons',
	@level2type = N'COLUMN', @level2name = N'HighestEducationID',
	@value = N'Identifies the Person''s highest level of education completed.  Foreign key pointing to the EducationLevels table.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'Persons',
	@level2type = N'COLUMN', @level2name = N'FamilyIncome',
	@value = N'Person''s current annual family income.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'Persons',
	@level2type = N'COLUMN', @level2name = N'EnglishLanguageProficiencyID',
	@value = N'Identifies the Person''s current level of proficiency with the English Language.  Foreign key pointing to the LanguageProficiencies table.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'Persons',
	@level2type = N'COLUMN', @level2name = N'PassportNumber',
	@value = N'Person''s current passport identification number.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'Persons',
	@level2type = N'COLUMN', @level2name = N'PassportExpirationDate',
	@value = N'Date that the Person''s current passport expires.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'Persons',
	@level2type = N'COLUMN', @level2name = N'PassportIssuingCountryID',
	@value = N'Country from which the Person''s current passport was issued.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'Persons',
	@level2type = N'COLUMN', @level2name = N'MedicalClearanceStatus',
	@value = N'Boolean that indicates if the Person has a valid medical clearance to participate in training events.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'Persons',
	@level2type = N'COLUMN', @level2name = N'MedicalClearanceDate',
	@value = N'Date of the person''s last medical clearance evaluation.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'Persons',
	@level2type = N'COLUMN', @level2name = N'DentalClearanceStatus',
	@value = N'Boolean that indicates if the Person has a valid dental clearance to participate in training events.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'Persons',
	@level2type = N'COLUMN', @level2name = N'DentalClearanceDate',
	@value = N'Date of the person''s last dental clearance evaluation.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'Persons',
	@level2type = N'COLUMN', @level2name = N'PsychologicalClearanceStatus',
	@value = N'Boolean that indicates if the Person has a valid psychological clearance to participate in training events.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'Persons',
	@level2type = N'COLUMN', @level2name = N'PsychologicalClearanceDate',
	@value = N'Date of the person''s last psychological clearance evaluation.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'Persons',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the AppUsers table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'persons',
	@level1type = N'TABLE',  @level1name = N'Persons',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'Persons',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'Persons',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO