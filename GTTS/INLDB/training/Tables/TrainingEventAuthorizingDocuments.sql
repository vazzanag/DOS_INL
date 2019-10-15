CREATE TABLE [training].[TrainingEventAuthorizingDocuments] 
(
    [TrainingEventID] BIGINT NOT NULL,
    [InterAgencyAgreementID] INT NOT NULL, 
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),   

    CONSTRAINT [PK_TrainingEventAuthorizingDocuments] 
		PRIMARY KEY ([TrainingEventID], [InterAgencyAgreementID]), 

    CONSTRAINT [FK_TrainingEventAuthorizingDocuments_TrainingEvents] 
		FOREIGN KEY ([TrainingEventID]) 
		REFERENCES [training].[TrainingEvents]([TrainingEventID]), 

    CONSTRAINT [FK_TrainingEventAuthorizingDocuments_InterAgencyAgreements] 
		FOREIGN KEY ([InterAgencyAgreementID]) 
		REFERENCES [training].[InterAgencyAgreements]([InterAgencyAgreementID]),

    CONSTRAINT [FK_TrainingEventAuthorizingDocuments_AppUsers_ModifiedByAppUserID] 
		FOREIGN KEY ([ModifiedByAppUserID]) 
		REFERENCES [users].[AppUsers]([AppUserID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [training].[TrainingEventAuthorizingDocuments_History]))
GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level1type = N'TABLE', 
	@level0name = N'training', @level1name = N'TrainingEventAuthorizingDocuments',
	@value = N'The collection of Authorizing Documents Codes tied to a particular training event.';
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventAuthorizingDocuments',
    @level2type = N'COLUMN', @level2name = N'TrainingEventID',
	@value = N'Training Event part of the Primary key for this table.  Identifies the Training Event associated to the specified InterAgencyAgreement Code.  Foreign key pointing to the TrainingEvents table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventAuthorizingDocuments',
    @level2type = N'COLUMN', @level2name = N'InterAgencyAgreementID',
	@value = N'Authorizing Document part of the Primary key for this table.  Identifies the InterAgencyAgreements associated to the specified Training Event.  Foreign key pointing to the InterAgencyAgreements table.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventAuthorizingDocuments',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the AppUsers table.'
GO
    
/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventAuthorizingDocuments',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventAuthorizingDocuments',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventAuthorizingDocuments',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod for which the record is valid.'
GO