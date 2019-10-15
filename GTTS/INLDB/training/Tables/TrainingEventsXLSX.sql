CREATE TABLE [training].[TrainingEventsXLSX]
(
	[EventXLSXID] BIGINT IDENTITY (1, 1) NOT NULL,
	[TrainingEventID] BIGINT NULL,				-- Nullable FK to [TrainingEvents]
	[Name] NVARCHAR(255) NOT NULL,
	[NameInLocalLang] NVARCHAR(255)	NOT NULL,
	[OrganizerNames] NVARCHAR(120)	NOT NULL,
	[EventType]	NVARCHAR(100) NOT NULL,
	[Objectives] NTEXT NOT NULL,
	[RequestingAgency] NVARCHAR(127) NOT NULL,
	[AgencyPOCName]	NVARCHAR(200) NOT NULL,
	[AgencyPOCEmail] NVARCHAR(256) NOT NULL,
	[POCPhoneExt] NVARCHAR(50) NOT NULL,
	[ImplementingPartners] NVARCHAR(255) NULL,
	[AuthorizingDocuments] NVARCHAR(255) NULL,
	[ProjectCodes] NVARCHAR(255) NULL,
	[KeyActivity] NVARCHAR(130) NULL,
	[ParticipantProfile] NTEXT NULL,
	[Justification]	NTEXT NULL,
	[Comments] NTEXT NULL,
	[EstimatedBudget] DECIMAL NULL,
	[ActualBudget] DECIMAL NULL,
	[HostNationParticipants] INT NULL,
	[MissionDirectHires] INT NULL,
	[NonMissionDirectHires]	INT	NULL,
	[MissionOutsourcedHires] INT NULL,
	[NonUSGInstructors]	INT	NULL,
	[LoadStatus] NVARCHAR(15) NULL,
	[Validations] NVARCHAR(4000) NULL,
	[ImportVersion] INT NULL,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),
    CONSTRAINT [PK_EventXLSXID] 
		PRIMARY KEY ([EventXLSXID]),
    CONSTRAINT [FK_TrainingEventsXLSX_TrainingEvents] 
        FOREIGN KEY ([TrainingEventID]) 
        REFERENCES [training].[TrainingEvents]([TrainingEventID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [training].[TrainingEventsXLSX_History]))
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventsXLSX',
	@value = N'Upload table that holds Training Event data that is imported into the database via an upload function.  Data is imported into GTTS via a 3-step process: 1) Upload data from spreadsheet file into the corresponding upload table, 2) Validate, preview and edit uploaded data in the upload table, 3) Import the validated & edited data in the upload table into the GTTS data tables.';
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventsXLSX',
    @level2type = N'COLUMN', @level2name = N'EventXLSXID',
	@value = N'Primary key & identity of the record in this table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventsXLSX',
    @level2type = N'COLUMN', @level2name = N'TrainingEventID',
	@value = N'The [TrainingEvents].[TrainingEventID] value for the Training Event that matches the TrainingEventsXLSX data.  This is an internal management & control column that does not have a matching database data column outside of the [TrainingEventsXLSX] table.  Foreign key pointing to the TrainingEvents data table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventsXLSX',
    @level2type = N'COLUMN', @level2name = N'Name',
	@value = N'Name of the Training Event in English.  This value will be mapped to the [TrainingEvents].[Name] column.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventsXLSX',
    @level2type = N'COLUMN', @level2name = N'NameInLocalLang',
	@value = N'Name of the Training Event in the local language of the country uploading the data.  This value will be mapped to the [TrainingEvents].[NameInLocalLang] column.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventsXLSX',
    @level2type = N'COLUMN', @level2name = N'OrganizerNames',
	@value = N'Name of the Training Event organizers.  This is a semi-colon (;) delimited list.  The first name in the list will be mapped to the [TrainingEvents].[OrganizerAppUserID] column.  The remaining names in the list will be mapped to the [TrainingEventStakeholders] table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventsXLSX',
    @level2type = N'COLUMN', @level2name = N'EventType',
	@value = N'Type of Training Event.  This value will be mapped to the [TrainingEvents].[TrainingEventTypeID] column based on a string match against [TrainingEventTypes].[Name].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventsXLSX',
    @level2type = N'COLUMN', @level2name = N'Objectives',
	@value = N'Narrative detailing the objectives of the Training Event.  This value will be mapped to the [TrainingEvents].[Objectives] column.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventsXLSX',
    @level2type = N'COLUMN', @level2name = N'RequestingAgency',
	@value = N'Name of the US Government Agency requesting the training.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventsXLSX',
    @level2type = N'COLUMN', @level2name = N'AgencyPOCName',
	@value = N'Name of the Requesting Agency''s Point of Contact.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventsXLSX',
    @level2type = N'COLUMN', @level2name = N'AgencyPOCEmail',
	@value = N'Email Address of the Requesting Agency''s Point of Contact.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventsXLSX',
    @level2type = N'COLUMN', @level2name = N'POCPhoneExt',
	@value = N'Telephone number of the Requesting Agency''s Point of Contact.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventsXLSX',
    @level2type = N'COLUMN', @level2name = N'ImplementingPartners',
	@value = N'Names of any Implementing Partners (Formally known as US Partner Agencies) for the Training Event.  This is a semi-colon (;) delimited list.  The individual Partner names in the list will be mapped to the [TrainingEventImplementingPartners] table  based on a string match against [ImplementingPartners].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventsXLSX',
    @level2type = N'COLUMN', @level2name = N'AuthorizingDocuments',
	@value = N'Names of any Authorizing Documents (Formally known as InterAgency Agreements) for the Training Event.  This is a semi-colon (;) delimited list.  The individual Document  names in the list will be mapped to the [TrainingEventsAuthorizingDocuments] table   based on a string match against [AuthorizingDocuments].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventsXLSX',
    @level2type = N'COLUMN', @level2name = N'ProjectCodes',
	@value = N'Names or Codes of any Project Code(s) for the Training Event.  This is a semi-colon (;) delimited list.  The individual Project Codes in the list will be mapped to the [TrainingEventProjectCodes] table based on a string match against [ProjectCodes].[Code].'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventsXLSX',
    @level2type = N'COLUMN', @level2name = N'KeyActivity',
	@value = N'Name of the Key Activity for the Training Event.  This value will be mapped to the [TrainingEvents].[KeyActivityID] column based on a string match against [KeyActivities].[Code]..'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventsXLSX',
    @level2type = N'COLUMN', @level2name = N'ParticipantProfile',
	@value = N'Narrative detailing the objectives of the Training Event.  This value will be mapped to the [TrainingEvents].[ParticipantProfile] column.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventsXLSX',
    @level2type = N'COLUMN', @level2name = N'Justification',
	@value = N'Narrative detailing the objectives of the Training Event.  This value will be mapped to the [TrainingEvents].[Justification] column.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventsXLSX',
    @level2type = N'COLUMN', @level2name = N'Comments',
	@value = N'General comments about the Training Event that are not documented anywhere else in the upload spreadsheet.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventsXLSX',
    @level2type = N'COLUMN', @level2name = N'EstimatedBudget',
	@value = N'Proposed budget in US Dollars needed for the Training Event.  This number is for planning and approval purposes and not the actual budget amount.  This value will be mapped to the [TrainingEvents].[EstimatedBudget] column.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventsXLSX',
    @level2type = N'COLUMN', @level2name = N'ActualBudget',
	@value = N'Actual budget in US Dollars used for the Training Event.  This value will be mapped to the [TrainingEvents].[ActualBudget] column.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventsXLSX',
    @level2type = N'COLUMN', @level2name = N'HostNationParticipants',
	@value = N'Proposed number of students to attend the Training Event.  This number is for planning and approval purposes and not the actual number of students.  This value will be mapped to the [TrainingEvents].[PlannedParticipantCnt] column.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventsXLSX',
    @level2type = N'COLUMN', @level2name = N'MissionDirectHires',
	@value = N'Proposed number of direct hire staff anticipated to support the Training Event. This number is for planning and approval purposes and not the actual number of direct hire staff.  This value will be mapped to the [TrainingEvents].[PlannedMissionDirectHireCnt] column.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventsXLSX',
    @level2type = N'COLUMN', @level2name = N'NonMissionDirectHires',
	@value = N'Proposed number of non-direct hire staff anticipated to support the Training Event. This number is for planning and approval purposes and not the actual number of non-direct hire staff.  This value will be mapped to the [TrainingEvents].[PlannedNonMissionDirectHireCnt] column.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventsXLSX',
    @level2type = N'COLUMN', @level2name = N'MissionOutsourcedHires',
	@value = N'Proposed number of outsourced staff anticipated to support the Training Event. This number is for planning and approval purposes and not the actual number of outsourced staff.  This value will be mapped to the [TrainingEvents].[PlannedMissionOutsourceCnt] column.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventsXLSX',
    @level2type = N'COLUMN', @level2name = N'NonUSGInstructors',
	@value = N'Proposed number of non-US Government instructors anticipated to support the Training Event. This number is for planning and approval purposes and not the actual number of non-US Government instructors.  This value will be mapped to the [TrainingEvents].[PlannedNonOtherCnt] column.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventsXLSX',
    @level2type = N'COLUMN', @level2name = N'LoadStatus',
	@value = N'The status of the upload of the TrainingEvent data into the database data tables. Valid values for this column are ''Uploaded'', ''Imported''.  ''Uploaded'' means that the data was uploaded into the TrainingEventsXLSX table.  ''Imported'' means that the data was processed, validated, and imported into the database data tables.  This is an internal management & control column that does not have a matching database data column outside of the [TrainingEventsXLSX] table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventsXLSX',
    @level2type = N'COLUMN', @level2name = N'Validations',
	@value = N'Contains the results of the validations processing during the upload process.  This is an internal management & control column that does not have a matching database data column outside of the [TrainingEventsXLSX] table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventsXLSX',
    @level2type = N'COLUMN', @level2name = N'ImportVersion',
	@value = N'Identifies the version number of the template spreadsheets.  This is an internal management & control column that does not have a matching database data column outside of the [TrainingEventsXLSX] table.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventsXLSX',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the Users table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventsXLSX',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventsXLSX',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventsXLSX',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO