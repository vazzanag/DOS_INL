/*
    **************************************************************************
    VettingBatches.sql
    **************************************************************************    
*/   
CREATE TABLE [vetting].[VettingBatches] 
(
    [VettingBatchID] BIGINT IDENTITY (1, 1) NOT NULL, 
    [VettingBatchName] NVARCHAR(150) NOT NULL, 
    [VettingBatchNumber] INT NOT NULL,
	[VettingBatchOrdinal] INT NULL,
    [TrainingEventID] BIGINT NULL, 
    [CountryID] INT NULL,
	[VettingBatchTypeID] TINYINT NOT NULL,
	[AssignedToAppUserID] INT,
	[VettingBatchStatusID] SMALLINT DEFAULT 1 NOT NULL, 
	[BatchRejectionReason] NVARCHAR(250) NULL,
	[IsCorrectionRequired] BIT DEFAULT '0' NOT NULL,
	[CourtesyVettingOverrideFlag] BIT DEFAULT '0' NULL,
	[CourtesyVettingOverrideReason] NVARCHAR(300) NULL,
    [GTTSTrackingNumber] NVARCHAR(100) NULL, 
    [LeahyTrackingNumber] NVARCHAR(100) NULL, 
	[INKTrackingNumber] NVARCHAR(50) NULL,
	[DateVettingResultsNeededBy] DATETIME NULL,
	[DateSubmitted] DATETIME NULL,
	[DateAccepted] DATETIME NULL,
	[DateSentToCourtesy] DATETIME NULL,
	[DateLeahyFileGenerated] DATETIME NULL,
	[DateCourtesyCompleted] DATETIME NULL,
	[DateSentToLeahy] DATETIME NULL,
	[DateLeahyResultsReceived] DATETIME NULL,
	[DateVettingResultsNotified] DATETIME NULL,
	[VettingFundingSourceID] SMALLINT NOT NULL,    
	[AuthorizingLawID] SMALLINT NOT NULL,    
	[VettingBatchNotes] NVARCHAR(500) NULL,
	[AppUserIDSubmitted] INT,
	[AppUserIDAccepted] INT,
	[AppUserIDSentToCourtesy] INT,
	[AppUserIDCourtesyCompleted] INT,
	[AppUserIDSentToLeahy] INT,
	[AppUserIDLeahyResultsReceived] INT,
	[FileID] BIGINT NULL,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),     
    CONSTRAINT [PK_VettingBatches]
        PRIMARY KEY ([VettingBatchID]),
    CONSTRAINT [FK_VettingBatches_TrainingEvents]
        FOREIGN KEY ([TrainingEventID]) 
        REFERENCES [training].[TrainingEvents] ([TrainingEventID]),
    CONSTRAINT [FK_VettingBatches_Countries]
        FOREIGN KEY ([CountryID]) 
        REFERENCES [location].[Countries] ([CountryID]),
	CONSTRAINT [FK_VettingBatches_VettingBatchTypes]
		FOREIGN KEY ([VettingBatchTypeID])
		REFERENCES [vetting].[VettingBatchTypes] ([VettingBatchTypeID]),
    CONSTRAINT [FK_VettingBatches_AppUsers_AssignedToAppUserID] 
        FOREIGN KEY ([AssignedToAppUserID]) 
        REFERENCES [users].[AppUsers]([AppUserID]),
	CONSTRAINT [FK_VettingBatches_VettingBatchStatuses]
		FOREIGN KEY ([VettingBatchStatusID])
		REFERENCES [vetting].[VettingBatchStatuses] ([VettingBatchStatusID]),
    CONSTRAINT [FK_VettingBatches_VettingFundingSources]
        FOREIGN KEY ([VettingFundingSourceID]) 
        REFERENCES [vetting].[VettingFundingSources] ([VettingFundingSourceID]),        
    CONSTRAINT [FK_VettingBatches_AuthorizingLaws]
        FOREIGN KEY ([AuthorizingLawID]) 
        REFERENCES [vetting].[AuthorizingLaws] ([AuthorizingLawID]),
	CONSTRAINT [FK_VettingBatches_Files]
        FOREIGN KEY (FileID) 
        REFERENCES [files].[Files] ([FileID]),  
	CONSTRAINT [FK_VettingBatches_AppUsers] 
        FOREIGN KEY ([ModifiedByAppUserID]) 
        REFERENCES [users].[AppUsers]([AppUserID]),
	CONSTRAINT [FK_VettingBatches_AppUsers1] 
        FOREIGN KEY ([AppUserIDSubmitted]) 
        REFERENCES [users].[AppUsers]([AppUserID]),
	CONSTRAINT [FK_VettingBatches_AppUsers2] 
        FOREIGN KEY ([AppUserIDAccepted]) 
        REFERENCES [users].[AppUsers]([AppUserID]),
	CONSTRAINT [FK_VettingBatches_AppUsers3] 
        FOREIGN KEY ([AppUserIDSentToCourtesy]) 
        REFERENCES [users].[AppUsers]([AppUserID]),
	CONSTRAINT [FK_VettingBatches_AppUsers4] 
        FOREIGN KEY ([AppUserIDCourtesyCompleted]) 
        REFERENCES [users].[AppUsers]([AppUserID]),
	CONSTRAINT [FK_VettingBatches_AppUsers5] 
        FOREIGN KEY ([AppUserIDSentToLeahy]) 
        REFERENCES [users].[AppUsers]([AppUserID]),
	CONSTRAINT [FK_VettingBatches_AppUsers6] 
        FOREIGN KEY ([AppUserIDLeahyResultsReceived]) 
        REFERENCES [users].[AppUsers]([AppUserID])
	)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [vetting].[VettingBatches_History]))
GO

CREATE FULLTEXT INDEX ON [vetting].[VettingBatches] (VettingBatchName, GTTSTrackingNumber, LeahyTrackingNumber, INKTrackingNumber) 
    KEY INDEX [PK_VettingBatches] ON [FullTextCatalog] 
    WITH CHANGE_TRACKING AUTO
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'VettingBatches',
	@value = N'Data table that holds information about specific Vetting Batches.  A vetting batch is a group of 1 or more Persons that have been submitted into the Vetting Process.'
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingBatches',
    @level2type = N'COLUMN', @level2name = N'VettingBatchID',
	@value = N'Primary key & identity of the record in this table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingBatches',
    @level2type = N'COLUMN', @level2name = N'VettingBatchName',
	@value = N'Name of the Vetting Batch.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingBatches',
    @level2type = N'COLUMN', @level2name = N'VettingBatchNumber',
	@value = N'The number of the batch for the year for the country'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingBatches',
    @level2type = N'COLUMN', @level2name = N'VettingBatchOrdinal',
	@value = N'The number of the batch for the training.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingBatches',
    @level2type = N'COLUMN', @level2name = N'TrainingEventID',
	@value = N'Identifies the TrainingEvent that the batch is associated with.  Foreign key pointing to the TrainingEvents table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingBatches',
    @level2type = N'COLUMN', @level2name = N'CountryID',
	@value = N'Identifies the Country that the batch is associated with.  Foreign key pointing to the locations.Countries table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingBatches',
    @level2type = N'COLUMN', @level2name = N'VettingBatchTypeID',
	@value = N'Identifies the Vetting Batch Type of the Batch.  Foreign key pointing to the VettingBatchTypes table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingBatches',
    @level2type = N'COLUMN', @level2name = N'AssignedToAppUserID',
	@value = N'Identifies the Vetting Unit user assigned to manage/process the batch.  Foreign key pointing to the Users table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingBatches',
    @level2type = N'COLUMN', @level2name = N'VettingBatchStatusID',
	@value = N'Identifies the Status of the Vetting Batch.  Foreign key pointing to the VettingBatchStatuses table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingBatches',
    @level2type = N'COLUMN', @level2name = N'BatchRejectionReason',
	@value = N'Reason why the batch was rejected.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingBatches',
    @level2type = N'COLUMN', @level2name = N'IsCorrectionRequired',
	@value = N'Boolean to indicate that the batch needs corrections made.  If the Vetting Unit identifies that some corrections are needed in the batch, this field will be set to TRUE by the Vetting Unit.  Default value is FALSE (0).'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingBatches',
    @level2type = N'COLUMN', @level2name = N'CourtesyVettingOverrideFlag',
	@value = N'Boolean to indicate that the standard vetting workflow for the batch was overridden and the batch was submitted for Leahy Vetting prior to all of the Courtesy Vetting Unit(s) checks to be completed.  Standard workflow requires that all Courtesy Vetting Units complete their work on the batch before the batch can be submitted for Leahy Vetting.  Default value is FALSE (0).'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingBatches',
    @level2type = N'COLUMN', @level2name = N'CourtesyVettingOverrideReason',
	@value = N'Reason or justification for overriding the Courtesy Vetting workflow.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingBatches',
    @level2type = N'COLUMN', @level2name = N'GTTSTrackingNumber',
	@value = N'Tracking Number that is assigned to the vetting batch by the GTTS system when the batch is created.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingBatches',
    @level2type = N'COLUMN', @level2name = N'LeahyTrackingNumber',
	@value = N'Tracking number or Case ID assigned to the vetting batch by the INVEST system when the batch is submitted to the INVEST system for Leahy Vetting.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingBatches',
    @level2type = N'COLUMN', @level2name = N'INKTrackingNumber',
	@value = N'Tracking Number that is assigned to the batch by the Consular DB system as part of the Individual Name Check (INK) process.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingBatches',
    @level2type = N'COLUMN', @level2name = N'DateVettingResultsNeededBy',
	@value = N'Date in MM/DD/YYYY format that identifies when all vetting results are need to be completed by.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingBatches',
    @level2type = N'COLUMN', @level2name = N'DateSubmitted',
	@value = N'Date in MM/DD/YYYY format that identifies when the batch was submitted by the Program Manager for vetting.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingBatches',
    @level2type = N'COLUMN', @level2name = N'DateAccepted',
	@value = N'Date in MM/DD/YYYY format that identifies when the batch was accepted by the Vetting Unit for vetting.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingBatches',
    @level2type = N'COLUMN', @level2name = N'DateSentToCourtesy',
	@value = N'Date in MM/DD/YYYY format that identifies when the batch was released to the individual Courtesy Vetting Units for vetting.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingBatches',
    @level2type = N'COLUMN', @level2name = N'DateLeahyFileGenerated',
	@value = N'Date in MM/DD/YYYY format that identifies when user clicked on Generate leahy file xls.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingBatches',
    @level2type = N'COLUMN', @level2name = N'DateCourtesyCompleted',
	@value = N'Date in MM/DD/YYYY format that identifies when the all of the individual Courtesy Vetting Units have processed all of the participants in the batch.  For example, if POL, CONS, & DEA are the individual Courtesy Vetting Units, this field will not be populated until POL and CON and DEA have completed all of their checks.  If only POL and CON have completed their checks, but DEA has not, this field will remain empty.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingBatches',
    @level2type = N'COLUMN', @level2name = N'DateSentToLeahy',
	@value = N'Date in MM/DD/YYYY format that the vetting batch was submitted to the INVEST system for Leahy Vetting.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingBatches',
    @level2type = N'COLUMN', @level2name = N'DateLeahyResultsReceived',
	@value = N'Date in MM/DD/YYYY format that the vetting batch results file was received from the INVEST system with Leahy Vetting results.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingBatches',
    @level2type = N'COLUMN', @level2name = N'DateVettingResultsNotified',
	@value = N'Date in MM/DD/YYYY format that the vetting batch results were sent to the requesting Program Manager.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingBatches',
    @level2type = N'COLUMN', @level2name = N'VettingFundingSourceID',
	@value = N'Identifies the specific Vetting Funding Source that is associated to the Vetting Batch.  Foreign key pointing to the VettingFundingSources reference table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingBatches',
    @level2type = N'COLUMN', @level2name = N'AuthorizingLawID',
	@value = N'Identifies the specific Authorizing Law that is associated to the Vetting Batch.  Foreign key pointing to the FundingSources reference table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingBatches',
    @level2type = N'COLUMN', @level2name = N'VettingBatchNotes',
	@value = N'Notes or comments about the specific batch.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'VettingBatches',
	@level2type = N'COLUMN', @level2name = N'AppUserIDSubmitted',
	@value = N'Identifies the user who changed the vetting batch status to Submitted.  Foreign key pointing to the Users table.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'VettingBatches',
	@level2type = N'COLUMN', @level2name = N'AppUserIDAccepted',
	@value = N'Identifies the user who changed the vetting batch status to Accepted.  Foreign key pointing to the Users table.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'VettingBatches',
	@level2type = N'COLUMN', @level2name = N'AppUserIDSentToCourtesy',
	@value = N'Identifies the user who changed the vetting batch status to Sent To Courtesy.  Foreign key pointing to the Users table.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'VettingBatches',
	@level2type = N'COLUMN', @level2name = N'AppUserIDCourtesyCompleted',
	@value = N'Identifies the user who changed the vetting batch status to Courtesy Completed.  Foreign key pointing to the Users table.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'VettingBatches',
	@level2type = N'COLUMN', @level2name = N'AppUserIDSentToLeahy',
	@value = N'Identifies the user who changed the vetting batch status to Sent to Leahy.  Foreign key pointing to the Users table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingBatches',
    @level2type = N'COLUMN', @level2name = N'FileID',
	@value = N'Identifies the record in the Files table that is directly associated with actual attachment file stored in Azure BLOB Storage.  Foreign key pointing to the Files table.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'VettingBatches',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the Users table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'VettingBatches',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'VettingBatches',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'VettingBatches',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO    