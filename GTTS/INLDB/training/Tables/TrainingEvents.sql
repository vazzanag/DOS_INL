CREATE TABLE [training].[TrainingEvents](
	[TrainingEventID] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[NameInLocalLang] [nvarchar](255) NULL,
	[TrainingEventTypeID] [int] NOT NULL,
	[Justification] [ntext] NULL,
	[Objectives] [ntext] NULL,
	[ParticipantProfile] [ntext] NULL,
	[SpecialRequirements] [ntext] NULL,
	[ProgramID] [int] NULL,
	[KeyActivityID] [int] NULL,
	[TrainingUnitID] [bigint] NULL,
	[CountryID] [int] NOT NULL,
	[PostID] [int] NOT NULL,
	[ConsularDistrictID] [int] NULL,
	[OrganizerAppUserID] [int] NULL,
	[PlannedParticipantCnt] [int] NULL,
	[PlannedMissionDirectHireCnt] [int] NULL,
    [PlannedNonMissionDirectHireCnt] [int] NULL,
	[PlannedMissionOutsourceCnt] [int] NULL,
	[PlannedOtherCnt] [int] NULL,
	[EstimatedBudget] [decimal](18, 2) NULL,
	[ActualBudget] [decimal](18, 2) NULL,
	[EstimatedStudents] [int] NULL,
	[FundingSourceID] [int] NULL,
	[AuthorizingLawID] [int] NULL,
    [Comments] NVARCHAR(MAX) NULL,
	[CreatedDate] DateTime NULL,
	[ModifiedByAppUserID] [int] NOT NULL,
    [ModifiedDate] [DateTime] DEFAULT getutcdate() NOT NULL,
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL,
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),
    CONSTRAINT [PK__TrainingEvents] 
        PRIMARY KEY CLUSTERED ([TrainingEventID] ASC)
            WITH (PAD_INDEX = OFF
                  ,STATISTICS_NORECOMPUTE = OFF
                  ,IGNORE_DUP_KEY = OFF
                  ,ALLOW_ROW_LOCKS = ON
              ,ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
    CONSTRAINT [FK_TrainingEvents_Countries] 
        FOREIGN KEY ([CountryID]) 
        REFERENCES [location].[Countries]([CountryID]),
    CONSTRAINT [FK_TrainingEvents_TrainingEventTypes] 
        FOREIGN KEY ([TrainingEventTypeID]) 
        REFERENCES [training].[TrainingEventTypes]([TrainingEventTypeID]),
    CONSTRAINT [FK_TrainingEvents_AppUsers_OrganizerAppUserID] 
        FOREIGN KEY ([OrganizerAppUserID]) 
        REFERENCES [users].[AppUsers]([AppUserID]),
    CONSTRAINT [FK_TrainingEvents_AppUsers_ModifiedByAppUserID] 
        FOREIGN KEY ([ModifiedByAppUserID]) 
        REFERENCES [users].[AppUsers]([AppUserID]),
    CONSTRAINT [FK_TrainingEvents_TrainingUnitID] 
        FOREIGN KEY ([TrainingUnitID]) 
        REFERENCES [users].[BusinessUnits]([BusinessUnitID]),
    CONSTRAINT [FK_TrainingEvents_KeyActivityID] 
        FOREIGN KEY ([KeyActivityID]) 
        REFERENCES [training].[KeyActivities]([KeyActivityID]),
    )
ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [training].[TrainingEvents_History]))
GO

ALTER TABLE [training].[TrainingEvents] ADD  CONSTRAINT [DF_TrainingEvents_SysStartTime]  DEFAULT (sysutcdatetime()) FOR [SysStartTime]
GO

CREATE NONCLUSTERED INDEX [IDX_Name] ON [training].[TrainingEvents] ([Name] ASC)
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

CREATE FULLTEXT INDEX ON [training].[TrainingEvents] ([Name], NameInLocalLang) 
    KEY INDEX [PK__TrainingEvents] ON [FullTextCatalog] 
    WITH CHANGE_TRACKING AUTO
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'The root table for training event instances'
	,@level0type = N'SCHEMA'
	,@level0name = N'training'
	,@level1type = N'TABLE'
	,@level1name = N'TrainingEvents'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'Primary key & identity of the record in this table.'
	,@level0type = N'SCHEMA'
	,@level0name = N'training'
	,@level1type = N'TABLE'
	,@level1name = N'TrainingEvents'
	,@level2type = N'COLUMN'
	,@level2name = N'TrainingEventID'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'Name of the specific Training Event instance in English.'
	,@level0type = N'SCHEMA'
	,@level0name = N'training'
	,@level1type = N'TABLE'
	,@level1name = N'TrainingEvents'
	,@level2type = N'COLUMN'
	,@level2name = N'Name'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'Name of the specific Training Event instance in the local language of the host nation.'
	,@level0type = N'SCHEMA'
	,@level0name = N'training'
	,@level1type = N'TABLE'
	,@level1name = N'TrainingEvents'
	,@level2type = N'COLUMN'
	,@level2name = N'NameInLocalLang'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'Identifies the event type of the Training Event instance.  Foreign key pointing to the TrainingEventTypes reference table.'
	,@level0type = N'SCHEMA'
	,@level0name = N'training'
	,@level1type = N'TABLE'
	,@level1name = N'TrainingEvents'
	,@level2type = N'COLUMN'
	,@level2name = N'TrainingEventTypeID'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'Narrative detailing the justification for conducting the Training Event instance.  Default value is the text from the related Curriculum''s CourseJustification field.'
	,@level0type = N'SCHEMA'
	,@level0name = N'training'
	,@level1type = N'TABLE'
	,@level1name = N'TrainingEvents'
	,@level2type = N'COLUMN'
	,@level2name = N'Justification'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'Narrative detailing the objectives of the Training Event instance.  Default value is the text from the related Curriculum''s CourseObjective field.'
	,@level0type = N'SCHEMA'
	,@level0name = N'training'
	,@level1type = N'TABLE'
	,@level1name = N'TrainingEvents'
	,@level2type = N'COLUMN'
	,@level2name = N'Objectives'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'Narrative describing the targetted audience of the Training Event instance.  Default value is the text from the related Curriculum''s ParticipantProfile field.'
	,@level0type = N'SCHEMA'
	,@level0name = N'training'
	,@level1type = N'TABLE'
	,@level1name = N'TrainingEvents'
	,@level2type = N'COLUMN'
	,@level2name = N'ParticipantProfile'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'Narrative detailing any special requirements or Comments for the Training Event instance.  Default value is the text from the related Curriculum''s SpecReqAndComments field.'
	,@level0type = N'SCHEMA'
	,@level0name = N'training'
	,@level1type = N'TABLE'
	,@level1name = N'TrainingEvents'
	,@level2type = N'COLUMN'
	,@level2name = N'SpecialRequirements'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'Identifies the associated program (as part of the Post''s integrated country strategy) for the Training Event instance.  Foreign key pointing to the TrainingEventPrograms reference table.'
	,@level0type = N'SCHEMA'
	,@level0name = N'training'
	,@level1type = N'TABLE'
	,@level1name = N'TrainingEvents'
	,@level2type = N'COLUMN'
	,@level2name = N'ProgramID'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'Identifies the associated key activity (as part of the Post''s integrated country strategy) for the Training Event instance.  Foreign key pointing to the TrainingEventKeyActivities reference table.'
	,@level0type = N'SCHEMA'
	,@level0name = N'training'
	,@level1type = N'TABLE'
	,@level1name = N'TrainingEvents'
	,@level2type = N'COLUMN'
	,@level2name = N'KeyActivityID'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'Identifies the US Government Agency or Unit associated to the Training Event instance.  Foreign key pointing to the UnitLibrary table.'
	,@level0type = N'SCHEMA'
	,@level0name = N'training'
	,@level1type = N'TABLE'
	,@level1name = N'TrainingEvents'
	,@level2type = N'COLUMN'
	,@level2name = N'TrainingUnitID'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'Identifies the country associated to the Training Event instance.  Foreign key pointing to the Countries reference table.'
	,@level0type = N'SCHEMA'
	,@level0name = N'training'
	,@level1type = N'TABLE'
	,@level1name = N'TrainingEvents'
	,@level2type = N'COLUMN'
	,@level2name = N'CountryID'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'Identifies the post associated to the Training Event instance.  Foreign key pointing to the Posts reference table.'
	,@level0type = N'SCHEMA'
	,@level0name = N'training'
	,@level1type = N'TABLE'
	,@level1name = N'TrainingEvents'
	,@level2type = N'COLUMN'
	,@level2name = N'PostID'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'Identifies the consular district associated to the Training Event instance.  Foreign key pointing to the Posts table.'
	,@level0type = N'SCHEMA'
	,@level0name = N'training'
	,@level1type = N'TABLE'
	,@level1name = N'TrainingEvents'
	,@level2type = N'COLUMN'
	,@level2name = N'ConsularDistrictID'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'Identifies the organizer of the Training Event instance.  Foreign key pointing to the Users table.'
	,@level0type = N'SCHEMA'
	,@level0name = N'training'
	,@level1type = N'TABLE'
	,@level1name = N'TrainingEvents'
	,@level2type = N'COLUMN'
	,@level2name = N'OrganizerAppUserID'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'Number of students anticipated to attend the Training Event instance.  This number is for planning purposes and not the actual number.'
	,@level0type = N'SCHEMA'
	,@level0name = N'training'
	,@level1type = N'TABLE'
	,@level1name = N'TrainingEvents'
	,@level2type = N'COLUMN'
	,@level2name = N'PlannedParticipantCnt'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'Number of direct hire staff anticipated to support the Training Event instance.  This number is for planning purposes and not the actual number.'
	,@level0type = N'SCHEMA'
	,@level0name = N'training'
	,@level1type = N'TABLE'
	,@level1name = N'TrainingEvents'
	,@level2type = N'COLUMN'
	,@level2name = N'PlannedMissionDirectHireCnt'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'Number of outsourced staff anticipated to support the Training Event instance.  This number is for planning purposes and not the actual number.'
	,@level0type = N'SCHEMA'
	,@level0name = N'training'
	,@level1type = N'TABLE'
	,@level1name = N'TrainingEvents'
	,@level2type = N'COLUMN'
	,@level2name = N'PlannedMissionOutsourceCnt'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'Number of other staff and/or observers anticipated to be needed for the Training Event instance.  This number is for planning purposes and not the actual number.'
	,@level0type = N'SCHEMA'
	,@level0name = N'training'
	,@level1type = N'TABLE'
	,@level1name = N'TrainingEvents'
	,@level2type = N'COLUMN'
	,@level2name = N'PlannedOtherCnt'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'Proposed budget in US Dollars needed for the Training Event instance.  This number is for planning and approval purposes and not the actual budget amount.'
	,@level0type = N'SCHEMA'
	,@level0name = N'training'
	,@level1type = N'TABLE'
	,@level1name = N'TrainingEvents'
	,@level2type = N'COLUMN'
	,@level2name = N'EstimatedBudget'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'Actual budget in US Dollars needed/used for the Training Event instance.'
	,@level0type = N'SCHEMA'
	,@level0name = N'training'
	,@level1type = N'TABLE'
	,@level1name = N'TrainingEvents'
	,@level2type = N'COLUMN'
	,@level2name = N'ActualBudget'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'Proposed number of students to attend the Training Event instance.  This number is for planning and approval purposes and not the actual number of students.'
	,@level0type = N'SCHEMA'
	,@level0name = N'training'
	,@level1type = N'TABLE'
	,@level1name = N'TrainingEvents'
	,@level2type = N'COLUMN'
	,@level2name = N'EstimatedStudents'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'Identifies the funding source associated to the Training Event instance.  Foreign key pointing to the TrainingEventFundingSources reference table.'
	,@level0type = N'SCHEMA'
	,@level0name = N'training'
	,@level1type = N'TABLE'
	,@level1name = N'TrainingEvents'
	,@level2type = N'COLUMN'
	,@level2name = N'FundingSourceID'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'Identifies the authorizing law associated to the Training Event instance.  Foreign key pointing to the TrainingEventAuthorizingLaw reference table.'
	,@level0type = N'SCHEMA'
	,@level0name = N'training'
	,@level1type = N'TABLE'
	,@level1name = N'TrainingEvents'
	,@level2type = N'COLUMN'
	,@level2name = N'AuthorizingLawID'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'Comments or notes regarding the TrainingEvent.'
	,@level0type = N'SCHEMA'
	,@level0name = N'training'
	,@level1type = N'TABLE'
	,@level1name = N'TrainingEvents'
	,@level2type = N'COLUMN'
	,@level2name = N'Comments'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the Users table.'
	,@level0type = N'SCHEMA'
	,@level0name = N'training'
	,@level1type = N'TABLE'
	,@level1name = N'TrainingEvents'
	,@level2type = N'COLUMN'
	,@level2name = N'ModifiedByAppUserID'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
	,@level0type = N'SCHEMA'
	,@level0name = N'training'
	,@level1type = N'TABLE'
	,@level1name = N'TrainingEvents'
	,@level2type = N'COLUMN'
	,@level2name = N'ModifiedDate'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod fow which the record is valid.'
	,@level0type = N'SCHEMA'
	,@level0name = N'training'
	,@level1type = N'TABLE'
	,@level1name = N'TrainingEvents'
	,@level2type = N'COLUMN'
	,@level2name = N'SysStartTime'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
	,@level0type = N'SCHEMA'
	,@level0name = N'training'
	,@level1type = N'TABLE'
	,@level1name = N'TrainingEvents'
	,@level2type = N'COLUMN'
	,@level2name = N'SysEndTime'
GO