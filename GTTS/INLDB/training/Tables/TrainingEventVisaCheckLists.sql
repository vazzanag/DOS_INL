CREATE TABLE [training].[TrainingEventVisaCheckLists]
(
	[TrainingEventVisaCheckListID] BIGINT IDENTITY(1,1) NOT NULL,
    [PersonID] BIGINT NOT NULL,
	[TrainingEventID] BIGINT NOT NULL, 
	[HasHostNationCorrespondence] BIT DEFAULT(0),
	[HasUSGCorrespondence] BIT DEFAULT(0),
	[IsApplicationComplete] BIT DEFAULT(0),
	[HasPassportAndPhotos] BIT DEFAULT(0),
	[ApplicationSubmittedDate] Datetime,
	[VisaStatusID] SMALLINT,
	[TrackingNumber] NVARCHAR(30),
	[Comments] NVARCHAR(1000),
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),
    CONSTRAINT [PK_TrainingEventVisaCheckList] 
		PRIMARY KEY ([TrainingEventVisaCheckListID]),
	CONSTRAINT [FK_TrainingEventVisaCheckLists_Persons] 
		FOREIGN KEY ([PersonID]) 
		REFERENCES [persons].[Persons]([PersonID]),
    CONSTRAINT [FK_TrainingEventVisaCheckLists_TrainingEvents] 
		FOREIGN KEY ([TrainingEventID]) 
		REFERENCES [training].[TrainingEvents]([TrainingEventID]),
	CONSTRAINT [FK_TrainingEventVisaCheckLists_VisaStatuses]
		FOREIGN KEY (VisaStatusID)
		REFERENCES [training].[VisaStatuses]([VisaStatusID]),
	CONSTRAINT [FK_TrainingEventVisaCheckLists_AppUsers] 
        FOREIGN KEY ([ModifiedByAppUserID]) 
        REFERENCES [users].[AppUsers]([AppUserID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [training].[TrainingEventVisaCheckLists_History]))
GO

/*  Table description  */
EXEC sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level1type = N'TABLE', 
	@level0name = N'training', @level1name = N'TrainingEventVisaCheckLists',
	@value = N'The cross reference table joining uploaded files to training events.';
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventVisaCheckLists',
    @level2type = N'COLUMN', @level2name = N'TrainingEventVisaCheckListID',
	@value = N'The Primary key of the record in this table.'
GO

/* FK to PersonID Table */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventVisaCheckLists',
    @level2type = N'COLUMN', @level2name = N'PersonID',
	@value = N'Indicates the person that the visa checklist is associated with.  Foreign key pointing to the Persons table.'
GO

/* FK to Training Event Table */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventVisaCheckLists',
    @level2type = N'COLUMN', @level2name = N'TrainingEventID',
	@value = N'Indicates the training event that the visa checklist is associated with.  Foreign key pointing to the TrainingEvents table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventVisaCheckLists',
    @level2type = N'COLUMN', @level2name = N'HasHostNationCorrespondence',
	@value = N'Indicates the person has host nation correspondence for the training. Default is FALSE (0).'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventVisaCheckLists',
    @level2type = N'COLUMN', @level2name = N'HasUSGCorrespondence',
	@value = N'Indicates the person has USG correspondence for the training. Default is FALSE (0).'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventVisaCheckLists',
    @level2type = N'COLUMN', @level2name = N'IsApplicationComplete',
	@value = N'Indicates person''s application is complete for the training event. Default is FALSE (0).'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventVisaCheckLists',
    @level2type = N'COLUMN', @level2name = N'HasPassportAndPhotos',
	@value = N'Indicates the whether person has passport and photos for the training event. Default is FALSE (0).'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventVisaCheckLists',
    @level2type = N'COLUMN', @level2name = N'ApplicationSubmittedDate',
	@value = N'Indicates application submitted date of the person for the training event.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventVisaCheckLists',
    @level2type = N'COLUMN', @level2name = N'VisaStatusID',
	@value = N'Indicates the visa status of the person for the training event.  Foreign key pointing to the VisaStatuses table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventVisaCheckLists',
    @level2type = N'COLUMN', @level2name = N'TrackingNumber',
	@value = N'Indicates the tracking number. Usually Fedex/DHS/UPS tracking number.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventVisaCheckLists',
    @level2type = N'COLUMN', @level2name = N'Comments',
	@value = N'Indicates comments entered by the user.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventVisaCheckLists',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the Users table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventVisaCheckLists',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventVisaCheckLists',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventVisaCheckLists',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO
