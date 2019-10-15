CREATE TABLE [training].[TrainingEventParticipants]
(
	[TrainingEventParticipantID] BIGINT IDENTITY (1, 1) NOT NULL, 
	[PersonID] BIGINT NOT NULL,
	[TrainingEventID] BIGINT NOT NULL,
	[TrainingEventParticipantTypeID] INT NOT NULL DEFAULT 1,
	[PersonsVettingID] BIGINT NULL,
	[IsVIP] BIT NOT NULL DEFAULT 0,
	[IsParticipant] BIT NOT NULL DEFAULT 1,
	[IsTraveling] BIT NOT NULL DEFAULT 0,	
	[DepartureCityID] INT NULL,
	[DepartureDate] DATETIME NULL,
	[ReturnDate] DATETIME NULL,
    [HasLocalGovTrust] BIT NOT NULL DEFAULT 0,
	[PassedLocalGovTrust] BIT NULL ,
	[LocalGovTrustCertDate] DATETIME NULL,
    [OtherVetting] BIT NOT NULL DEFAULT 0,
	[PassedOtherVetting] BIT NULL ,
	[OtherVettingDescription] NVARCHAR(150),
	[OtherVettingDate] DATETIME NULL,
	-- Depending on the values of the FK tables, these cols may become NOT NULL
	[VisaStatusID] SMALLINT NULL,				-- FK to VisaStatus table (TBD)
	[PaperworkStatusID] SMALLINT NULL,			-- FK to PaperworkStatus table (TBD)
	[TravelDocumentStatusID] SMALLINT  NULL,	-- FK to TravelDocumentStatus table (TBD)
    [OnboardingComplete] BIT DEFAULT 0,
	[RemovedFromEvent] BIT NOT NULL DEFAULT 0,
	[RemovedFromVetting] BIT NOT NULL DEFAULT 0,
	[RemovalReasonID] SMALLINT NULL,	
	[RemovalCauseID] SMALLINT NULL, 
	[DateCanceled] DATETIME NULL,
	[Comments] NVARCHAR(4000) NULL,
	[CreatedDate] DATETIME NULL DEFAULT (getutcdate()),
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),	
	CONSTRAINT [PK_TrainingParticipants] 
		PRIMARY KEY ([TrainingEventParticipantID]), 
    CONSTRAINT [FK_TrainingEventParticipants_Persons] 
		FOREIGN KEY ([PersonID]) 
		REFERENCES [persons].[Persons]([PersonID]),
    CONSTRAINT [FK_TrainingEventParticipants_TrainingEvents] 
		FOREIGN KEY ([TrainingEventID]) 
		REFERENCES [training].[TrainingEvents]([TrainingEventID]),
	CONSTRAINT [FK_TrainingEventParticipants_TrainingEventParticipantTypes] 
		FOREIGN KEY ([TrainingEventParticipantTypeID]) 
		REFERENCES [training].[TrainingEventParticipantTypes]([TrainingEventParticipantTypeID]),
    CONSTRAINT [FK_TrainingEventParticipants_PersonsVetting]
        FOREIGN KEY ([PersonsVettingID])
        REFERENCES [vetting].[PersonsVetting]([PersonsVettingID]),
    CONSTRAINT [FK_TrainingEventParticipants_Cities]
		FOREIGN KEY ([DepartureCityID]) 
		REFERENCES [location].[Cities]([CityID]),
    CONSTRAINT [FK_TrainingEventParticipants_VisaStatuses] 
		FOREIGN KEY ([VisaStatusID]) 
		REFERENCES [training].[VisaStatuses]([VisaStatusID]),
    CONSTRAINT [FK_TrainingEventParticipants_RemovalReasons] 
		FOREIGN KEY ([RemovalReasonID]) 
		REFERENCES [training].[RemovalReasons]([RemovalReasonID]),
    CONSTRAINT [FK_TrainingEventParticipants_RemovalCauses] 
		FOREIGN KEY ([RemovalCauseID]) 
		REFERENCES [training].[RemovalCauses]([RemovalCauseID]),
	
	-- FK CONSTRAINT to PaperworkStatus table (TBD)
	
	-- FK CONSTRAINT to TravelDocumentStatus table (TBD)

    CONSTRAINT [FK_TrainingEventParticipants_AppUsers_ModifiedByAppUserID]
		FOREIGN KEY ([ModifiedByAppUserID]) 
		REFERENCES [users].[AppUsers]([AppUserID]),
	CONSTRAINT [UC_TrainingEventParticipants] 
		UNIQUE ([PersonID], [TrainingEventID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [training].[TrainingEventParticipants_History]))
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventParticipants',
	@value = N'Link table that links Persons table to the TrainingEvents table.'
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventParticipants',
    @level2type = N'COLUMN', @level2name = N'TrainingEventParticipantID',
	@value = N'Primary key & identity of the record in this table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventParticipants',
    @level2type = N'COLUMN', @level2name = N'PersonID',
	@value = N'Persons half of the Primary key for this table.  Foreign key pointing to the Persons table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventParticipants',
    @level2type = N'COLUMN', @level2name = N'PersonsVettingID',
	@value = N'Identifies the PersonsVetting record associated to this TrainingEventStudent record.  Foreign key pointing to the PersonsVetting table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventParticipants',
    @level2type = N'COLUMN', @level2name = N'TrainingEventID',
	@value = N'TrainingEvent half of the Primary key for this table.  Foreign key pointing to the TrainingEvents table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventParticipants',
    @level2type = N'COLUMN', @level2name = N'IsVIP',
	@value = N'Boolean that indicates if the Person is to be flagged as a VIP/High Rank at this event.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventParticipants',
    @level2type = N'COLUMN', @level2name = N'IsParticipant',
	@value = N'Boolean that indicates if the Person is a Participant (TRUE) or an Alternate (FALSE).'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventParticipants',
    @level2type = N'COLUMN', @level2name = N'IsTraveling',
	@value = N'Boolean that indicates if the Person is travelling to this event.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventParticipants',
    @level2type = N'COLUMN', @level2name = N'DepartureCityID',
	@value = N'City that the Person is departing from.  Foreign key pointing to the Cities table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventParticipants',
    @level2type = N'COLUMN', @level2name = N'DepartureDate',
	@value = N'Date that the Person''s travel starts.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventParticipants',
    @level2type = N'COLUMN', @level2name = N'ReturnDate',
	@value = N'Date that the Person''s travel ends.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventParticipants',
    @level2type = N'COLUMN', @level2name = 'HasLocalGovTrust',
	@value = N'Boolean value that indicates if the Person has gone through their government''s trust control.  Applies to security forces only.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventParticipants',
    @level2type = N'COLUMN', @level2name = 'PassedLocalGovTrust',
	@value = N'Boolean value that indicates if the Person has passed their government''s trust control.  Applies to security forces only.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventParticipants',
    @level2type = N'COLUMN', @level2name = N'LocalGovTrustCertDate',
	@value = N'Date that the local government certified the Person to have passed trust control.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventParticipants',
    @level2type = N'COLUMN', @level2name = N'OtherVetting',
	@value = N'Boolean value that indicates if the Person went through a vetting process that was not covered by Courtesy, Leahy, or Host Nation processes.  For example: Polygraphs.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventParticipants',
    @level2type = N'COLUMN', @level2name = N'PassedOtherVetting',
	@value = N'Boolean value that indicates if the Person passed a vetting process that was not covered by Courtesy, Leahy, or Host Nation processes.  For example: Polygraphs.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventParticipants',
    @level2type = N'COLUMN', @level2name = N'OtherVettingDescription',
	@value = N'Description of the Other Vetting process.  For example: Polygraphs.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventParticipants',
    @level2type = N'COLUMN', @level2name = N'OtherVettingDate',
	@value = N'Date that the external 3rd Party vetted the Person.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventParticipants',
    @level2type = N'COLUMN', @level2name = N'VisaStatusID',
	@value = N'Indicates the Visa Status of the Person with respect to the specified TrainingEvent.  Foreign key pointing to the Visa table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventParticipants',
    @level2type = N'COLUMN', @level2name = N'PaperworkStatusID',
	@value = N'Indicates the Paperwork Status of the Person with respect to the specified TrainingEvent.  Foreign key pointing to the PaperworkStatus table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventParticipants',
    @level2type = N'COLUMN', @level2name = N'TravelDocumentStatusID',
	@value = N'Indicates the Status of the Person''s Travel Documents with respect to the specified TrainingEvent.  Foreign key pointing to the TravelDocumentsStatus table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventParticipants',
    @level2type = N'COLUMN', @level2name = N'OnboardingComplete',
	@value = N'Indicates if the instructor has completed all onboarding requirements'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventParticipants',
    @level2type = N'COLUMN', @level2name = N'RemovedFromEvent',
	@value = N'Boolean that indicates if the Person was removed from the specified TrainingEvent during event planning and not during closing of event attendance.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventParticipants',
    @level2type = N'COLUMN', @level2name = N'RemovedFromVetting',
	@value = N'Boolean that indicates if the Person was removed from the vetting. This is based on at what stage of the vetting process the person was removed.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventParticipants',
    @level2type = N'COLUMN', @level2name = N'RemovalReasonID',
	@value = N'Identifies the specific reason for removing the Person from the Training Event.  Foreign key pointing to the RemovalReasons table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventParticipants',
    @level2type = N'COLUMN', @level2name = N'RemovalCauseID',
	@value = N'Identifies the specific cause of a Cancellation and/or No Show reason for removing the Person from the Training Event.  Foreign key pointing to the RemovalCauses table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventParticipants',
    @level2type = N'COLUMN', @level2name = N'DateCanceled',
	@value = N'Date when the Person canceled their attendance of the specified TrainingEvent.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventParticipants',
    @level2type = N'COLUMN', @level2name = N'Comments',
	@value = N'Comments or notes regarding the Person and specified TrainingEvent.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventParticipants',
	@level2type = N'COLUMN', @level2name = N'CreatedDate',
	@value = N'Date/Time when the instructor was added to the training event.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventParticipants',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the AppUsers table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventParticipants',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventParticipants',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventParticipants',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO