/*
    NAME:   NewPostTrainingEvents
    
    DESCR:  This is the import migration table that receives the transposed (PIVOTed) results
            from the [NewPostTrainingEventVertical] table.

            The data is initially imported from the xlsx file into the [NewPostTrainingEventVertical] 
            table and then transposed (PIVOTed) into the [NewPostTrainingEvents] table (this table 
            script).  The data is then validated and either imported into the GTTS data tables or 
            marked as an exception and not imported.

            NOTE: For Version 1, all Training Events that are imported as part of the On-boarding process
            will be imported as NEW Training Events without any checks for duplicate Training Events.  The
            ability to check for duplicate Training Events may be incorporated in a future release/version.
*/
CREATE TABLE [migration].[NewPostTrainingEvents]
(
	[NewPostTrainingEventID] BIGINT IDENTITY (1, 1) NOT NULL,   -- Internal PK of table.         

	[NewPostImportID] BIGINT NULL,				-- FK to [NewPostImportLog] table.   

    [OfficeOrSection] NVARCHAR(500) NULL,		-- Name of Unit implementing the event.
                                                -- This needs a reverse lookup into [Units] table to get the matching UnitID & BusinessUnitID.
    [UnitID] BIGINT NULL,					    -- Unit Library UnitID if the OfficeOrSection is a unit in the Unit Library.
	[IsTrainingUnitInUnitLibrary] BIT NULL,		-- Indicates if the OfficeOrSection (Training Unit) exists in the [Units] table.
	[IsTrainingUnitInBusinessUnits] BIT NULL,	-- Indicates if the OfficeOrSection (Training Unit) is in the [BusinessUnits] table.
	[TrainingUnitBusinessUnitID] BIGINT NULL,	-- Business Unit ID of the Training Unit.  Maps to [TrainingEvents].[TrainingUnitID]
	
    [OrganizerNames] NVARCHAR(1000) NULL,		-- Semi-colon delimited list of name(s) of the event organizers.
    [OrganizerNameIDs] NVARCHAR(300) NULL,      -- This will require that each delimited name undergoes a reverse lookup into the 
                                                -- [AppUsers] table to get it's matching [AppUserID] which is then stored as part
                                                -- of a delimited list of IDs in the [OrganizerNameIDs] column in this table.
                                                -- When the data is written to the GTTS data tables, the first value in [OrganizerNameIDs]
                                                -- will be saved to the [TrainingEvents].[OrganizerAppUserID] column and the remaining
                                                -- values in [OrganizerNameIDs] will be saved to the [TrainingEventStakeholders] table.
	
    [Name] NVARCHAR(255) NULL,					-- [TrainingEvents].[Name]

	[NameInLocalLang] NVARCHAR(255)	NULL,       -- [TrainingEvents].[NameInLocalLang]
	
    [EventType]	NVARCHAR(100) NULL,				-- This needs a reverse lookup into [TrainingEventTypes] table to get the [TrainingEventTypeID]
    [TrainingEventTypeID]  INT NULL,			-- [TrainingEvents].[TrainingEventTypeID]

    [KeyActivities] NVARCHAR(1000) NULL,        -- Semi-colon delimited list of Programs & Key Activities for the event.
    [KeyActivityIDs] NVARCHAR(300) NULL,        -- This will require that each delimited Key Activity undergoes a reverse lookup into the 
                                                -- [KeyActivities] reference table to get it's matching [KeyActivityID] which is then stored
                                                -- as part of a delimited list of IDs in the [KeyActivityIDs] column in this table.
                                                -- When the data is written to the GTTS data tables, the delimited values in [KeyActivityIDs]
                                                -- will be saved to the [TrainingEventKeyActivities] table.    

    [FundingSources] NVARCHAR(1000) NULL,       -- Semi-colon delimited list of Project Code(s) for the Training Event.
    [FundingSourceIDs] NVARCHAR(300) NULL,      -- This will require that each delimited Funding Source undergoes a reverse lookup into the 
                                                -- [ProjectCodes] table to get it's matching [ProjectCodeID] which is then stored as part
                                                -- of a delimited list of IDs in the [FundingSourceIDs] column in this table.  When the data
                                                -- is written to the GTTS data tables, the delimited values in [FundingSourceIDs] will be 
                                                -- saved to the [TrainingEventProjectCodes] table.   

    [AuthorizingDocuments] NVARCHAR(1000) NULL,  -- Semi-colon delimited list of Authorizing Documents for the event.
    [AuthorizingDocumentIDs] NVARCHAR(300) NULL, -- This will require that each delimited Authorizing undergoes a reverse lookup into the 
                                                 -- [InterAgencyAgreements] table to get it's matching [InterAgencyAgreementID] which is then 
                                                 -- stored as part of a delimited list of IDs in the [AuthorizingDocumentIDs] column in this table.
                                                 -- When the data is written to the GTTS data tables, the delimited values in [AuthorizingDocumentIDs] 
                                                 -- will be saved to the [TrainingEventAuthorizingDocuments] table.

    [ImplementingPartners] NVARCHAR(1000) NULL,  -- Semi-colon delimited list of partner agencies/units for the event.
    [ImplementingPartnerIDs] NVARCHAR(300) NULL, -- This will require that each delimited Implementing Partner undergoes a reverse lookup into  
                                                 -- the [Units] table to get it's matching [UnitID] which is then stored as part of a delimited
                                                 -- list of IDs in the [ImplementingPartnerIDs] column in this table. When the data is written  
                                                 -- to the GTTS data tables, the delimited values in [ImplementingPartnerIDs] will be saved to 
                                                 -- the [TrainingEventUSPartnerAgencies] table.

    [Objectives] NTEXT NULL,					-- [TrainingEvents].[Objectives]

	[ParticipantProfile] NTEXT NULL,            -- [TrainingEvents].[ParticipantProfile]
	
    [Justification]	NTEXT NULL,                 -- [TrainingEvents].[Justification]

	[EstimatedBudget] DECIMAL NULL,             -- [TrainingEvents].[EstimatedBudget]

	[ActualBudget] DECIMAL NULL,                -- [TrainingEvents].[ActualBudget]
	
    [HostNationParticipants] INT NULL,          -- [TrainingEvents].[PlannedParticipantCnt]
	
    [MissionDirectHires] INT NULL,              -- [TrainingEvents].[PlannedMissionDirectHireCnt]
	
    [NonMissionDirectHires]	INT	NULL,           -- [TrainingEvents].[PlannedNonMissionDirectHireCnt]
	
    [MissionOutsourcedHires] INT NULL,          -- [TrainingEvents].[PlannedMissionOutsourceCnt]
	
    [NonUSGInstructors]	INT	NULL,               -- [TrainingEvents].[PlannedNonOtherCnt]

	[Comments] NTEXT NULL,                      -- [TrainingEvents].[SpecialRequirements]

	[TrainingEventID] BIGINT NULL,              -- [TrainingEventID] value of the new [TrainingEvents] table record that was created as a result of the 
                                                -- import of this [NewPostTrainingEvents] record.  Foreign key pointing to the [TrainingEvents] table.

	[ImportStatus] NVARCHAR(100) NULL,          -- Status of the import process.  Valid values are:
                                                -- 'Uploaded'                 = Data was uploaded into the [NewPostTrainingEvents] table.
                                                -- 'Exception - Not Imported' = Record was not imported due to data value/validation issues.
                                                -- 'Imported                  = Record was processed, validated, and imported into the data tables.

	[Validations] NVARCHAR(4000) NULL,          -- NOT SURE IF THIS WILL BE NEEDED

	[ImportVersion] INT NULL,                   -- Version number of the template spreadsheet file from Excel file metadata.  

	[ModifiedByAppUserID] INT NOT NULL DEFAULT(2),          -- [AppUserID] value of 2 = 'ONBOARDING'.
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),

    CONSTRAINT [PK_NewPostTrainingEvents] 
		PRIMARY KEY ([NewPostTrainingEventID]),

    CONSTRAINT [FK_NewPostTrainingEvents_NewPostImportLog] 
        FOREIGN KEY ([NewPostImportID]) 
        REFERENCES [migration].[NewPostImportLog]([NewPostImportID]),

    CONSTRAINT [FK_NewPostTrainingEvents_TrainingEvents] 
        FOREIGN KEY ([TrainingEventID]) 
        REFERENCES [training].[TrainingEvents]([TrainingEventID]),

    CONSTRAINT [FK_NewPostTrainingEvents_AppUsers] 
        FOREIGN KEY ([ModifiedByAppUserID]) 
        REFERENCES [users].[AppUsers]([AppUserID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [migration].[NewPostTrainingEvents_History]))
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'migration',
	@level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
    @value = N'Import migration table that holds the transposed (PIVOTed) results from the [NewPostTrainingEventVertical] table.'
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
    @level2type = N'COLUMN', @level2name = N'NewPostTrainingEventID',
	@value = N'Primary key & identity value of the record in this table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
    @level2type = N'COLUMN', @level2name = N'NewPostImportID',
	@value = N'This is the master import tracking ID that links all of the New Post Import records in the different [migration] tables to a specific import template file.  Foreign key pointing to the [NewPostImportLog] table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
    @level2type = N'COLUMN', @level2name = N'OfficeOrSection',
	@value = N'Name of the unit that is implementing the event.  Mapped to [TrainingEvents].[TrainingUnitID].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
    @level2type = N'COLUMN', @level2name = N'UnitID',
	@value = N'Unit Library ID value of the Office or Section (AKA Training Unit).'    
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
    @level2type = N'COLUMN', @level2name = N'IsTrainingUnitInUnitLibrary',
	@value = N'Boolean value that indicates if the Office or Section (AKA Training Unit) exists as a specific Unit in the Unit Library.'    
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
    @level2type = N'COLUMN', @level2name = N'IsTrainingUnitInBusinessUnits',
	@value = N'Boolean value that indicates if the Office or Section (AKA Training Unit) already exists in the [BusinessUnits] table.'    
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
    @level2type = N'COLUMN', @level2name = N'TrainingUnitBusinessUnitID',
	@value = N'Busines Units ID value of the Office or Section (AKA Training Unit) from the [BusinessUnits] table.'    
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
    @level2type = N'COLUMN', @level2name = N'OrganizerNames',
	@value = N'Names of the Training Event organizers.  The semi-colon (;) delimted values in this field are cross-referenced against the [AppUsers] table.  The [AppUserID] results of the cross-reference will be written to the delimited list of values in the [OrganizerNameIDs] column.  Non-matches will be written as ''NOT_FOUND'' to the delimited list in the [OrganizerNameIDs] column as well as the [NewPostImportExceptions] table.'    
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
    @level2type = N'COLUMN', @level2name = N'OrganizerNameIDs',
	@value = N'A semi-colon (;) delimted list of [AppUsers] table values matching the delimited names in the [OrganizerNames] column.  Non-matches will be written as ''NOT_FOUND'' as well as captured in the [NewPostImportExceptions] table.'    
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
    @level2type = N'COLUMN', @level2name = N'Name',
	@value = N'Name of the Training Event in English.  This value will be mapped to the [TrainingEvents].[Name] column.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
    @level2type = N'COLUMN', @level2name = N'NameInLocalLang',
	@value = N'Name of the Training Event in the local language of the country uploading the data.  This value will be mapped to the [TrainingEvents].[NameInLocalLang] column.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
    @level2type = N'COLUMN', @level2name = N'EventType',
	@value = N'Type of Training Event.  This value will be mapped to the [TrainingEvents].[TrainingEventTypeID] column based on a reverse lookup string match against [TrainingEventTypes].[Name].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
    @level2type = N'COLUMN', @level2name = N'TrainingEventTypeID',
	@value = N'The retrieved ID value from the reverse lookup string match of [EventTypes] against the [TrainingEventTypes] table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
    @level2type = N'COLUMN', @level2name = N'KeyActivities',
	@value = N'Names of the Key Activities for the Training Event.  The semi-colon (;) delimted values in this field are cross-referenced against the [KeyActivities] reference table.  The [KeyActivityID] results of the cross-reference will be written to the delimited list of values in the [KeyActivityIDs] column.  Non-matches will be written as ''NOT_FOUND'' to the delimited list in [OrganizerNameIDs] as well as the [NewPostImportExceptions] table.'    
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
    @level2type = N'COLUMN', @level2name = N'KeyActivityIDs',
	@value = N'A semi-colon (;) delimted list of [KeyActivities] reference table values matching the delimited names in the [KeyActivities] column.  Non-matches will be written as ''NOT_FOUND'' as well as captured in the [NewPostImportExceptions] table.'    
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
    @level2type = N'COLUMN', @level2name = N'FundingSources',
	@value = N'Names of Project Codes (AKA Funding Sources) for the Training Event.  The semi-colon (;) delimted values in this field are cross-referenced against the [ProjectCodes] reference table.  The [ProjectCodeID] results of the cross-reference will be written to the delimited list of values in the [FundingSourceIDs] column.  Non-matches will be written as ''NOT_FOUND'' to the delimited list in [FundingSourceIDs] as well as the [NewPostImportExceptions] table.' 
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
    @level2type = N'COLUMN', @level2name = N'FundingSourceIDs',
	@value = N'A semi-colon (;) delimted list of [ProjectCodes] reference table values matching the delimited names in the [FundingSources] column.  Non-matches will be written as ''NOT_FOUND'' as well as captured in the [NewPostImportExceptions] table.'  
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
    @level2type = N'COLUMN', @level2name = N'AuthorizingDocuments',
	@value = N'Names of any Authorizing Documents (formally known as InterAgency Agreements) for the Training Event.  The semi-colon (;) delimted values in this field are cross-referenced against the [InterAgencyAgreements] reference table.  The [InterAgencyAgreementID] results of the cross-reference will be written to the delimited list of values in the [AuthorizingDocumentIDs] column.  Non-matches will be written as ''NOT_FOUND'' to the delimited list in [AuthorizingDocumentIDs] as well as the [NewPostImportExceptions] table.' 
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
    @level2type = N'COLUMN', @level2name = N'AuthorizingDocumentIDs',
	@value = N'A semi-colon (;) delimted list of [InterAgencyAgreements] reference table values matching the delimited names in the [AuthorizingDocuments] column.  Non-matches will be written as ''NOT_FOUND'' as well as captured in the [NewPostImportExceptions] table.' 
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
    @level2type = N'COLUMN', @level2name = N'ImplementingPartners',
	@value = N'Names of any Implementing Partners (formally known as US Partner Agencies) for the Training Event.  The semi-colon (;) delimted values in this field are cross-referenced against the [Units] data table (AKA Unit Library).  The [UnitID] results of the cross-reference will be written to the delimited list of values in the [ImplementingPartnerIDs] column.  Non-matches will be written as ''NOT_FOUND'' to the delimited list in [ImplementingPartnerIDs] as well as the [NewPostImportExceptions] table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
    @level2type = N'COLUMN', @level2name = N'ImplementingPartnerIDs',
	@value = N'A semi-colon (;) delimted list of [Units] data table (AKA Unit Library) values matching the delimited names in the [ImplementingPartners] column.  Non-matches will be written as ''NOT_FOUND'' as well as captured in the [NewPostImportExceptions] table.' 
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
    @level2type = N'COLUMN', @level2name = N'Objectives',
	@value = N'Narrative detailing the objectives of the Training Event.  This value will be mapped to the [TrainingEvents].[Objectives] column.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
    @level2type = N'COLUMN', @level2name = N'ParticipantProfile',
	@value = N'Narrative detailing the objectives of the Training Event.  This value will be mapped to the [TrainingEvents].[ParticipantProfile] column.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
    @level2type = N'COLUMN', @level2name = N'Justification',
	@value = N'Narrative detailing the objectives of the Training Event.  This value will be mapped to the [TrainingEvents].[Justification] column.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
    @level2type = N'COLUMN', @level2name = N'EstimatedBudget',
	@value = N'Proposed budget in US Dollars needed for the Training Event.  This number is for planning and approval purposes and not the actual budget amount.  This value will be mapped to the [TrainingEvents].[EstimatedBudget] column.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
    @level2type = N'COLUMN', @level2name = N'ActualBudget',
	@value = N'Actual budget in US Dollars used for the Training Event.  This value will be mapped to the [TrainingEvents].[ActualBudget] column.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
    @level2type = N'COLUMN', @level2name = N'HostNationParticipants',
	@value = N'Proposed number of students to attend the Training Event.  This number is for planning and approval purposes and not the actual number of students.  This value will be mapped to the [TrainingEvents].[PlannedParticipantCnt] column.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
    @level2type = N'COLUMN', @level2name = N'MissionDirectHires',
	@value = N'Proposed number of direct hire staff anticipated to support the Training Event. This number is for planning and approval purposes and not the actual number of direct hire staff.  This value will be mapped to the [TrainingEvents].[PlannedMissionDirectHireCnt] column.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
    @level2type = N'COLUMN', @level2name = N'NonMissionDirectHires',
	@value = N'Proposed number of non-direct hire staff anticipated to support the Training Event. This number is for planning and approval purposes and not the actual number of non-direct hire staff.  This value will be mapped to the [TrainingEvents].[PlannedNonMissionDirectHireCnt] column.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
    @level2type = N'COLUMN', @level2name = N'MissionOutsourcedHires',
	@value = N'Proposed number of outsourced staff anticipated to support the Training Event. This number is for planning and approval purposes and not the actual number of outsourced staff.  This value will be mapped to the [TrainingEvents].[PlannedMissionOutsourceCnt] column.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
    @level2type = N'COLUMN', @level2name = N'NonUSGInstructors',
	@value = N'Proposed number of non-US Government instructors anticipated to support the Training Event. This number is for planning and approval purposes and not the actual number of non-US Government instructors.  This value will be mapped to the [TrainingEvents].[PlannedNonOtherCnt] column.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
    @level2type = N'COLUMN', @level2name = N'Comments',
	@value = N'General comments about the Training Event that are not documented anywhere else in the upload spreadsheet.  This value will be mapped to the [TrainingEvents].[SpecialRequirements] column.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
    @level2type = N'COLUMN', @level2name = N'TrainingEventID',
	@value = N'The [TrainingEvents].[TrainingEventID] value of the new [TrainingEvents] table record that was created as a result of the import of this [NewPostTrainingEvents] record.  Foreign key pointing to the [TrainingEvents] table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
    @level2type = N'COLUMN', @level2name = N'ImportStatus',
	@value = N'The status of the upload of the TrainingEvent data into the database data tables. Valid values for this column are ''Uploaded'', ''Exception - Not Imported'', and  ''Imported''.  ''Uploaded'' means that the data was uploaded into the [NewPostTrainingEvents] table.  ''Exception - Not Imported'' means that there were data value/validation issues that prevented the record from being imported into the database data tables.  Details of the specific issues will be written to the [NewPostImportExceptions] table.  
    ''Imported'' means that the data was processed, validated, and imported into the database data tables.  This is an internal management & control column that does not have a matching database data column outside of the [NewPostTrainingEvents] table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
    @level2type = N'COLUMN', @level2name = N'Validations',
	@value = N'Contains the results of the validations processing during the upload process.  This is an internal management & control column that does not have a matching database data column outside of the [NewPostTrainingEvents] table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
    @level2type = N'COLUMN', @level2name = N'ImportVersion',
	@value = N'Identifies the version number of the template spreadsheets.  This is an internal management & control column that does not have a matching database data column outside of the [NewPostTrainingEvents] table.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'migration',
	@level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Default value of 1 is the User known as ''NEW POST IMPORT''.  Foreign key pointing to the [AppUsers] table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'migration',
	@level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'migration',
	@level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
	@level1type = N'TABLE',  @level1name = N'NewPostTrainingEvents',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod for which the record is valid.'
GO