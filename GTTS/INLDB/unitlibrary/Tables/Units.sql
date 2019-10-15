CREATE TABLE [unitlibrary].[Units]
(
    [UnitID] BIGINT IDENTITY (1, 1) NOT NULL,
    [UnitParentID] BIGINT NULL,                 -- Self-Referential FK
    [CountryID] INT NOT NULL,                   -- FK into Countries table
    [UnitLocationID] BIGINT NULL,           -- FK into Locations table   
    [ConsularDistrictID] INT NULL,          -- FK into Posts table
    [UnitName] NVARCHAR(300) NOT NULL,    
    [UnitNameEnglish] NVARCHAR(300) NOT NULL,    
    [UnitBreakdown] NVARCHAR(MAX),
    [UnitBreakdownEnglish] NVARCHAR(MAX),
    [ChildUnits] NVARCHAR(MAX),
    [ChildUnitsEnglish] NVARCHAR(MAX),
    [IsMainAgency] BIT NOT NULL,    
    [UnitMainAgencyID] BIGINT NULL,             -- Self-Referential FK
    [UnitAcronym] NVARCHAR(50) NULL, 
    [UnitGenID] NVARCHAR(50) NOT NULL,    
    [UnitTypeID] SMALLINT NOT NULL,             -- FK into UnitType table
    [GovtLevelID] SMALLINT NULL,                -- FK into GovtLevel table
    [UnitLevelID] SMALLINT NULL,                -- FK into UnitLevel table
    [VettingBatchTypeID] TINYINT NOT NULL,      -- FK into VettingBatchTypes table
    [VettingActivityTypeID] SMALLINT NOT NULL,  -- FK into VettingActivitiesType table
    [ReportingTypeID] SMALLINT NULL,        -- FK into ReportingType table
    [UnitHeadPersonID] BIGINT NULL,         -- FK into Persons table
    [UnitHeadJobTitle] NVARCHAR(100) NULL,              -- FK into JobTitles table
    [UnitHeadRankID] INT NULL,                  -- FK into Ranks table
	[UnitHeadRank] NVARCHAR(100) NULL,
	[UnitHeadFirstMiddleNames] NVARCHAR(150) NULL,
	[UnitHeadLastNames] NVARCHAR(150) NULL,
	[UnitHeadIDNumber] VARCHAR(50) NULL,
	[UnitHeadGender] CHAR(1) NULL,
	[UnitHeadDOB] DATETIME NULL,
	[UnitHeadPoliceMilSecID] NVARCHAR(50) NULL,
	[UnitHeadPOBCityID] INT NULL, 
	[UnitHeadResidenceCityID] INT NULL,
	[UnitHeadContactEmail] NVARCHAR(256) NULL,
	[UnitHeadContactPhone] NVARCHAR(50) NULL,
	[UnitHeadHighestEducationID] SMALLINT NULL,
	[UnitHeadEnglishLanguageProficiencyID] SMALLINT	NULL,
    [HQLocationID] BIGINT NULL,             -- FK into Locations table
	[POCName] NVARCHAR(200) NULL,
	[POCEmailAddress] NVARCHAR(256) NULL,
	[POCTelephone] NVARCHAR(50) NULL,	
    [VettingPrefix] NVARCHAR(25) NULL,      -- USG ONLY
    [HasDutyToInform] BIT NOT NULL DEFAULT 0,             -- USG ONLY
    [IsLocked] BIT NOT NULL DEFAULT 0,
    [IsActive] BIT NOT NULL DEFAULT 1,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),	
    CONSTRAINT [PK_Units]
        PRIMARY KEY ([UnitID]),
 
    -- Self-Referential FK (UnitParentID ==> UnitID).
	CONSTRAINT [FK_Units_UnitParentID_UnitLibrary]
		FOREIGN KEY ([UnitParentID]) 
		REFERENCES [unitlibrary].[Units]([UnitID]),
        
    -- FK into Countries table.
	CONSTRAINT [FK_Units_CountryID_Countries]
		FOREIGN KEY ([CountryID]) 
		REFERENCES [location].[Countries]([CountryID]),

    -- FK into Locations table.      
    CONSTRAINT [FK_Units_UnitLocationID_Locations] 
		FOREIGN KEY ([UnitLocationID]) 
		REFERENCES [location].[Locations]([LocationID]),
    
    -- FK into Posts table.
	CONSTRAINT [FK_Units_ConsularDistrictID_Posts]
		FOREIGN KEY ([ConsularDistrictID]) 
		REFERENCES [location].[Posts]([PostID]),

    -- Self-Referential FK (MainAgencyID ==> UnitID).
	CONSTRAINT [FK_Units_UnitMainAgencyID_UnitLibrary]
		FOREIGN KEY ([UnitMainAgencyID]) 
		REFERENCES [unitlibrary].[Units]([UnitID]),
      
    -- FK into UnitType table.
	CONSTRAINT [FK_Units_UnitTypeID_UnitType]
		FOREIGN KEY ([UnitTypeID]) 
		REFERENCES [unitlibrary].[UnitTypes]([UnitTypeID]),
        
    -- FK into GovtLevel table.
	CONSTRAINT [FK_Units_GovtLevelID_GovtLevel]
		FOREIGN KEY ([GovtLevelID]) 
		REFERENCES [unitlibrary].[GovtLevels]([GovtLevelID]),
        
    -- FK into UnitLevel table.
	CONSTRAINT [FK_Units_UnitLevelID_UnitLevel]
		FOREIGN KEY ([UnitLevelID]) 
		REFERENCES [unitlibrary].[UnitLevels]([UnitLevelID]),
        
    -- FK into VettingType table.
	CONSTRAINT [FK_Units_VettingTypeID_VettingTypeClass]
		FOREIGN KEY ([VettingBatchTypeID]) 
		REFERENCES [vetting].[VettingBatchTypes]([VettingBatchTypeID]),
        
    -- FK into VettingActivitiesType table.
	CONSTRAINT [FK_Units_VettingActivitiesTypeID_VettingActivityTypes]
		FOREIGN KEY ([VettingActivityTypeID]) 
		REFERENCES [vetting].[VettingActivityTypes]([VettingActivityTypeID]),
        
    -- FK into ReportingType table.
	CONSTRAINT [FK_Units_ReportingTypeID_ReportingType]
		FOREIGN KEY ([ReportingTypeID]) 
		REFERENCES [unitlibrary].[ReportingTypes]([ReportingTypeID]),
    
    -- FK into Persons table.
	CONSTRAINT [FKUnits_UnitHeadPersonID_Persons]
		FOREIGN KEY ([UnitHeadPersonID]) 
		REFERENCES [persons].[Persons]([PersonID]),

    -- FK into Ranks table.
	CONSTRAINT [FK_Units_UnitHeadRankID_Ranks]
		FOREIGN KEY ([UnitHeadRankID]) 
		REFERENCES [persons].[Ranks]([RankID]),

	CONSTRAINT [FK_UnitHeadPOBCityID]
		FOREIGN KEY ([UnitHeadPOBCityID]) 
		REFERENCES [location].[Cities]([CityID]),

	CONSTRAINT [FK_UnitHeadResidenceCityID]
		FOREIGN KEY ([UnitHeadResidenceCityID]) 
		REFERENCES [location].[Cities]([CityID]),

	CONSTRAINT [FK_UnitHeadEducationLevels]
		FOREIGN KEY ([UnitHeadHighestEducationID]) 
		REFERENCES [persons].[EducationLevels]([EducationLevelID]),

    CONSTRAINT [FK_UnitHeadsLanguageProficiencies]
		FOREIGN KEY ([UnitHeadEnglishLanguageProficiencyID]) 
		REFERENCES [location].[LanguageProficiencies]([LanguageProficiencyID]),

    -- FK (HQ) into Locations table.        
    CONSTRAINT [FK_Units_HQLocationID_Locations_HQ] 
		FOREIGN KEY ([HQLocationID]) 
		REFERENCES [location].[Locations]([LocationID]),    

	-- FK into AppUsers table.
    CONSTRAINT [FK_Units_AppUsers] 
        FOREIGN KEY ([ModifiedByAppUserID]) 
        REFERENCES [users].[AppUsers]([AppUserID]),

	-- A unit may only have one parent.
    CONSTRAINT [UC_Units_UnitID_UnitParentID] 
		UNIQUE ([UnitID], [UnitParentID]),

	-- A unit may only have one "Main Agency".
    CONSTRAINT [UC_Units_UnitID_UnitMainAgencyID] 
		UNIQUE ([UnitID], [UnitMainAgencyID]),

	-- UnitGenID values must be unique within the unit's country
    CONSTRAINT [UC_Units_CountryID_UnitGenID] 
		UNIQUE ([CountryID],[UnitGenID])  
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [unitlibrary].[Units_History]))
GO

CREATE INDEX [IDX_UnitParentID] ON [unitlibrary].[Units] ([UnitParentID] ASC)
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

CREATE INDEX [IDX_CountryID] ON [unitlibrary].[Units] ([CountryID] ASC)
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

CREATE INDEX [IDX_UnitMainAgencyID] ON [unitlibrary].[Units] ([UnitMainAgencyID] ASC)
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

CREATE INDEX [IDX_UnitGenID] ON [unitlibrary].[Units] ([UnitGenID] ASC)
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

CREATE FULLTEXT INDEX ON [unitlibrary].[Units] 
    (UnitName, UnitNameEnglish, UnitGenID, UnitAcronym) 
    KEY INDEX [PK_Units] ON [FullTextCatalog] 
    WITH CHANGE_TRACKING AUTO
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
	@value = N'Primary data table that holds a country''s Unit Library information.';
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'UnitID',
	@value = N'Primary key & identity of the record in this table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'UnitParentID',
	@value = N'The UnitID value corresponding to the parent unit of the specified UnitID.  Self-referencing foreign key pointing to this table.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
	@level2type = N'COLUMN', @level2name = N'CountryID',
	@value = N'Identifies the country associated to the specified UnitID.  Foreign key pointing to the Countries table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'UnitLocationID',
	@value = N'Identifies the Location that is associated with the specified UnitID.  Foreign key pointing to the Locations table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'ConsularDistrictID',
	@value = N'Identifies the Consular District that is associated with the specified UnitID.  Foreign key pointing to the Posts table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'UnitName',
	@value = N'The complete name (in local language) of the unit identified by the specified UnitID.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'UnitNameEnglish',
	@value = N'The complete name (in English) of the unit identified by the specified UnitID.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'UnitBreakdown',
	@value = N'List of units above the unit'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'UnitBreakdownEnglish',
	@value = N'List of units above the unit in English'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'ChildUnits',
	@value = N'List of units below the u nit'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'ChildUnitsEnglish',
	@value = N'List of units below the unit in English'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'IsMainAgency',
	@value = N'Boolean that indicates if the unit identified by the specified UnitID is a "Main Agency".  A "Main Agency" is any unit defined as a top-level unit for hierarchy selection or reporting purposes.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'UnitMainAgencyID',
	@value = N'The UnitID value corresponding to the Main Agency Unit of the specified UnitID.  If the specified unit is a MainAgency (IsMainAgency = 1 or True), then MainAgencyID = UnitID.  Self-referencing foreign key pointing to this table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'UnitAcronym',
	@value = N'Acronym or initials of the unit identified by the specified UnitID. Only on units flagged as a MainAgency (IsMainAgency = 1 or True).  If unit is not a MainAgency, then this column is NULL.  The system will use this value from the MainAgency units to generate the UnitGenIDs for all units under the MainAgency unit.  If a subsidiary unit is flagged as a MainAgency, then the child unit will have it''s own acronym and restart the UnitGenID sequence.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'UnitGenID',
	@value = N'Unique system-generated human-readable ID for the specified UnitID.  Value is automatically generated in the format of Acronym of the MainAgency that this unit falls under (referenced by MainAgencyID) + a sequential 4-digit number. If MainAgencyID = UnitID, then UnitGenID is only the Acronym value.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'UnitTypeID',
	@value = N'Indicates the type of unit.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'GovtLevelID',
	@value = N'Indicates which hierarchical goverment structure the unit belongs to. Required if UnitTypeID = 2 (Government)'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'UnitLevelID',
	@value = N'Indicates the level of the Unit within the context of the Agency/Unit that the unit is a part of.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'VettingBatchTypeID',
	@value = N'Indicates the default type of vetting (Courtesy, Leahy) required for the unit.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'VettingActivityTypeID',
	@value = N'Indicates the type of activity of the unit for vetting purposes.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'ReportingTypeID',
	@value = N'Indicates the type of facility or unit for reporting purposes. '
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'UnitHeadPersonID',
	@value = N'Identifies the head or person-in-charge of the unit.  Foreign key pointing to the Persons table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = 'UnitHeadJobTitle',
	@value = N'Identifies the job or position title of the head or person-in-charge of the unit.  Foreign key pointing to the JobTitles table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'UnitHeadRankID',
	@value = N'Identifies the rank of the head or person-in-charge of the unit.  Foreign key pointing to the Ranks table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'UnitHeadRank',
	@value = N'Identifies the rank of the head or person-in-charge of the unit. Temporary column or the unit import process.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'UnitHeadFirstMiddleNames',
	@value = N'Identifies the head or person-in-charge of the unit''s first and middle names.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'UnitHeadLastNames',
	@value = N'Identifies the head or person-in-charge of the unit''s last names.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'UnitHeadIDNumber',
	@value = N'Identifies the head or person-in-charge of the unit''s ID Number.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'UnitHeadGender',
	@value = N'Identifies the head or person-in-charge of the unit''s gender.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'UnitHeadDOB',
	@value = N'Identifies the head or person-in-charge of the unit''s DOB.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'UnitHeadPoliceMilSecID',
	@value = N'Identifies the head or person-in-charge of the unit''s other ID or badge number.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'UnitHeadPOBCityID',
	@value = N'Identifies the head or person-in-charge of the unit''s city of birth.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'UnitHeadResidenceCityID',
	@value = N'Identifies the head or person-in-charge of the unit''s city of residence.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'UnitHeadContactEmail',
	@value = N'Identifies the head or person-in-charge of the unit''s contact email.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'UnitHeadContactPhone',
	@value = N'Identifies the head or person-in-charge of the unit''s contact phone.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'UnitHeadHighestEducationID',
	@value = N'Identifies the head or person-in-charge of the unit''s education level.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'UnitHeadEnglishLanguageProficiencyID',
	@value = N'Identifies the head or person-in-charge of the unit''s English proficiency.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'HQLocationID',
	@value = N'Identifies the Headquarters Location that is associated with the specified UnitID.  Foreign key pointing to the Locations table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'POCName',
	@value = N'Identifies the name of the person who is the Unit''s primary Point of Contact (POC).'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'POCEmailAddress',
	@value = N'Identifies the Email Address for the person who is the Unit''s primary Point of Contact (POC).'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'POCTelephone',
	@value = N'Identifies the Telephone Number for the person who is the Unit''s primary Point of Contact (POC).'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'VettingPrefix',
	@value = N'Indicates what (if any) characters to prepend to vetting batch names for the unit.  Only used for United States Units (CountryID = 2254)'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'HasDutyToInform',
	@value = N'Boolean that indicates if the unit is classified as a unit required to inform host nation if requested participants were rejected during the vetting process.  Only used for United States Units (CountryID = 2254)'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'IsLocked',
	@value = N'Boolean to indicate if the record is locked to disallow any subsequent modifications.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
    @level2type = N'COLUMN', @level2name = N'IsActive',
	@value = N'Boolean to indicate if the record is active to allow display of unit in application'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the AppUsers table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'unitlibrary',
	@level1type = N'TABLE',  @level1name = N'Units',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'unitlibrary',
    @level1type = N'TABLE',  @level1name = N'Units',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO




