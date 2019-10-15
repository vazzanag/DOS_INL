/*
    NAME:   ImportTrainingEventHorizontal
    
     DESCR: This is the import migration table that holds the PIVOTed output from the 
			[ImportTrainingEventVertical] table.  After the Training Event data has been
			PIVOTed into this table the data is then appended to the [NewPostTrainingEvents]
			table.  The data is then validated and either imported into the GTTS data tables
            or marked as an exception and not imported.
*/
CREATE TABLE [migration].[ImportTrainingEventHorizontal]
(
	[ImportID] BIGINT NULL,						-- Import ID Number (if known).
	
	[OfficeOrSection] VARCHAR(MAX) NULL,		-- Name of the implementing unit.

    [OrganizerNames] VARCHAR(MAX) NULL,			-- Semi-colon delimited list of the event organizers' names.
    
	[Name] VARCHAR(MAX) NULL,					-- Name of the training event.
    
	[NameInLocalLang] VARCHAR(MAX) NULL,		-- Name of the training event in the local language.
    
	[EventType] VARCHAR(MAX) NULL,				-- Type of event.
    
	[KeyActivities] VARCHAR(MAX) NULL,			-- Semi-colon delimited list of program names or key activities.
    
	[FundingSources] VARCHAR(MAX) NULL,			-- Semi-colon delimited list of funding sources.
    
	[AuthorizingDocuments] VARCHAR(MAX) NULL,	-- Semi-colon delimited list of authorizing documents (IAAs).
    
	[ImplementingPartners] VARCHAR(MAX) NULL,	-- Semi-colon delimited list of other US partner agencies involved in the event.
    
	[Objectives] VARCHAR(MAX) NULL,				-- Description of the event objectives.
    
	[ParticipantProfile] VARCHAR(MAX) NULL,		-- Description or profile of the typical participant.
    
	[Justification] VARCHAR(MAX) NULL,			-- Justification for putting on the event.
    
	[EstimatedBudget] VARCHAR(MAX) NULL,		-- Planned or estimated budget.
    
	[ActualBudget] VARCHAR(MAX) NULL,			-- Actual budget (if known) for the event.
    
	[HostNationParticipants] VARCHAR(MAX) NULL,	-- Number of participants.
    
	[MissionDirectHires] VARCHAR(MAX) NULL,		-- Number of direct hires needed to manage the event.
    
	[NonMissionDirectHires] VARCHAR(MAX) NULL,	-- Number of non-direct hires needed to manage the event.
    
	[MissionOutsourcedHires] VARCHAR(MAX) NULL,	-- Number of outsourced staff needed to manage the event.
    
	[NonUSGInstructors] VARCHAR(MAX) NULL,		-- Number of instructors needed for the event.
    
	[Comments] VARCHAR(MAX) NULL,				-- Any comments about the event.
)
ON [PRIMARY]
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'migration',
	@level1type = N'TABLE',  @level1name = N'ImportTrainingEventHorizontal',
    @value = N'Import migration table that holds the PIVOTed Training Event information from the Training Event template xlsx file.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportTrainingEventHorizontal',
    @level2type = N'COLUMN', @level2name = N'ImportID',
	@value = N'Import ID Number (if known).'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportTrainingEventHorizontal',
    @level2type = N'COLUMN', @level2name = N'OfficeOrSection',
	@value = N'Name of the implementing unit.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportTrainingEventHorizontal',
    @level2type = N'COLUMN', @level2name = N'OrganizerNames',
	@value = N'Semi-colon delimited list of the event organizers'' names.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportTrainingEventHorizontal',
    @level2type = N'COLUMN', @level2name = N'Name',
	@value = N'Name of the training event.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportTrainingEventHorizontal',
    @level2type = N'COLUMN', @level2name = N'NameInLocalLang',
	@value = N'Name of the training event in the local language.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportTrainingEventHorizontal',
    @level2type = N'COLUMN', @level2name = N'EventType',
	@value = N'Type of event.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportTrainingEventHorizontal',
    @level2type = N'COLUMN', @level2name = N'KeyActivities',
	@value = N'Semi-colon delimited list of program names or key activities.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportTrainingEventHorizontal',
    @level2type = N'COLUMN', @level2name = N'FundingSources',
	@value = N'Semi-colon delimited list of funding sources.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportTrainingEventHorizontal',
    @level2type = N'COLUMN', @level2name = N'AuthorizingDocuments',
	@value = N'Semi-colon delimited list of authorizing documents (IAAs).'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportTrainingEventHorizontal',
    @level2type = N'COLUMN', @level2name = N'ImplementingPartners',
	@value = N'Semi-colon delimited list of other US partner agencies involved in the event.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportTrainingEventHorizontal',
    @level2type = N'COLUMN', @level2name = N'Objectives',
	@value = N'Description of the event objectives.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportTrainingEventHorizontal',
    @level2type = N'COLUMN', @level2name = N'ParticipantProfile',
	@value = N'Description or profile of the typical participant.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportTrainingEventHorizontal',
    @level2type = N'COLUMN', @level2name = N'Justification',
	@value = N'Justification for putting on the event.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportTrainingEventHorizontal',
    @level2type = N'COLUMN', @level2name = N'EstimatedBudget',
	@value = N'Planned or estimated budget.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportTrainingEventHorizontal',
    @level2type = N'COLUMN', @level2name = N'ActualBudget',
	@value = N'Actual budget (if known) for the event.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportTrainingEventHorizontal',
    @level2type = N'COLUMN', @level2name = N'HostNationParticipants',
	@value = N'Number of participants.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportTrainingEventHorizontal',
    @level2type = N'COLUMN', @level2name = N'MissionDirectHires',
	@value = N'Number of direct hires needed to manage the event.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportTrainingEventHorizontal',
    @level2type = N'COLUMN', @level2name = N'NonMissionDirectHires',
	@value = N'Number of non-direct hires needed to manage the event.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportTrainingEventHorizontal',
    @level2type = N'COLUMN', @level2name = N'MissionOutsourcedHires',
	@value = N'Number of outsourced staff needed to manage the event.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportTrainingEventHorizontal',
    @level2type = N'COLUMN', @level2name = N'NonUSGInstructors',
	@value = N'Number of instructors needed for the event.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'ImportTrainingEventHorizontal',
    @level2type = N'COLUMN', @level2name = N'Comments',
	@value = N'Any comments about the event.'
GO