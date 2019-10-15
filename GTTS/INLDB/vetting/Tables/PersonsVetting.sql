/*
    **************************************************************************
    PersonsVetting.sql
    **************************************************************************  
*/
CREATE TABLE [vetting].[PersonsVetting] 
(
    [PersonsVettingID] BIGINT IDENTITY (1, 1) NOT NULL, 
	[Name1] NVARCHAR(50) NOT NULL,
	[Name2] NVARCHAR(50) NULL, 
	[Name3] NVARCHAR(50) NULL,
	[Name4] NVARCHAR(50) NULL,
	[Name5] NVARCHAR(50) NULL,
    [PersonsUnitLibraryInfoID] BIGINT NOT NULL, 
    [VettingBatchID] BIGINT NOT NULL, 
    [VettingPersonStatusID] SMALLINT NOT NULL, 
    [VettingStatusDate] DATETIME DEFAULT (getutcdate()) NULL, 
    [VettingNotes] NVARCHAR(750) NULL,
	[ClearedDate] DATETIME,
	[AppUserIDCleared] INT,
	[DeniedDate] DATETIME,
	[AppUserIDDenied] INT,
	[RemovedFromVetting] BIT DEFAULT(0),
	[IsReVetting] BIT DEFAULT(0),
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),    
    CONSTRAINT [PK_PersonsVetting]
        PRIMARY KEY (PersonsVettingID),
    CONSTRAINT [FK_PersonsVetting_PersonsUnitLibraryInfo]
        FOREIGN KEY (PersonsUnitLibraryInfoID) 
        REFERENCES [persons].[PersonsUnitLibraryInfo] ([PersonsUnitLibraryInfoID]),
    CONSTRAINT [FK_PersonsVetting_VettingBatches]
        FOREIGN KEY ([VettingBatchID]) 
        REFERENCES [vetting].[VettingBatches] ([VettingBatchID]),        
    CONSTRAINT [FK_PersonsVetting_VettingStatuses]
        FOREIGN KEY (VettingPersonStatusID) 
        REFERENCES [vetting].[VettingPersonStatuses] ([VettingPersonStatusID]),
    CONSTRAINT [FK_PersonsVetting_AppUsers] 
        FOREIGN KEY ([ModifiedByAppUserID]) 
        REFERENCES [users].[AppUsers]([AppUserID])   
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [vetting].[PersonsVetting_History]))
GO

CREATE NONCLUSTERED INDEX IDX_PersonsVetting_PersonsUnitLibraryInfoID ON vetting.PersonsVetting ([PersonsUnitLibraryInfoID])
    INCLUDE ([VettingBatchID], [VettingPersonStatusID], [VettingStatusDate]);
GO

CREATE FULLTEXT INDEX ON [vetting].[PersonsVetting] (Name1, Name2, Name3, Name4, Name5) 
    KEY INDEX [PK_PersonsVetting] ON [FullTextCatalog] 
    WITH CHANGE_TRACKING AUTO
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'PersonsVetting',
	@value = N'Link table between TrainingEventParticipants, VettingBatches, & VettingResults tables.'
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'PersonsVetting',
    @level2type = N'COLUMN', @level2name = N'PersonsVettingID',
	@value = N'Primary key & identity of the record in this table.'
GO

/*  Other data field descriptions  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'PersonsVetting',
	@level2type = N'COLUMN', @level2name = N'Name1',
	@value = N'Person''s First Name from [FirstMiddleNames] column.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'PersonsVetting',
	@level2type = N'COLUMN', @level2name = N'Name2',
	@value = N'Person''s Middle Name (if applicable) from [FirstMiddleNames] column.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'PersonsVetting',
	@level2type = N'COLUMN', @level2name = N'Name3',
	@value = N'Person''s additional Middle Name (if applicable) from [FirstMiddleNames] column or additional Last Name (if applicable) from [LastNames] column.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'PersonsVetting',
	@level2type = N'COLUMN', @level2name = N'Name4',
	@value = N'Person''s Last Name (if applicable) from [LastNames] column.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'PersonsVetting',
	@level2type = N'COLUMN', @level2name = N'Name5',
	@value = N'Person''s additional Last Name (if applicable) from [LastNames] column.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'PersonsVetting',
    @level2type = N'COLUMN', @level2name = N'PersonsUnitLibraryInfoID',
	@value = N'Identifies the Person & the Unit that the batch record is associated with.  Foreign key pointing to the PersonsUnitLibrarInfo table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'PersonsVetting',
    @level2type = N'COLUMN', @level2name = N'VettingBatchID',
	@value = N'Identifies the VettingBatch that the record is associated with.  Foreign key pointing to the VettingBatches table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'PersonsVetting',
    @level2type = N'COLUMN', @level2name = N'VettingPersonStatusID',
	@value = N'Identifies the overall Vetting Status of the Person.  Foreign key pointing to the VettingStatuses reference table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'PersonsVetting',
    @level2type = N'COLUMN', @level2name = N'VettingStatusDate',
	@value = N'Identifies the date of the Vetting Status of the Person.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'PersonsVetting',
    @level2type = N'COLUMN', @level2name = N'VettingNotes',
	@value = N'Any relevant notes on the Person and their Vetting Status.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'PersonsVetting',
    @level2type = N'COLUMN', @level2name = N'ClearedDate',
	@value = N'Date on which user cleared possible or direct match hit.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'PersonsVetting',
    @level2type = N'COLUMN', @level2name = N'AppUserIDCleared',
	@value = N'Identifies the user who cleared the hit. Foreign key pointing to the Users table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'PersonsVetting',
    @level2type = N'COLUMN', @level2name = N'DeniedDate',
	@value = N'Date on which user denied possible or direct match hit.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'PersonsVetting',
    @level2type = N'COLUMN', @level2name = N'AppUserIDDenied',
	@value = N'Identifies the user who denied the hit. Foreign key pointing to the Users table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'PersonsVetting',
    @level2type = N'COLUMN', @level2name = N'RemovedFromVetting',
	@value = N'Boolean flag for if person has been removed from vetting.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'PersonsVetting',
    @level2type = N'COLUMN', @level2name = N'IsReVetting',
	@value = N'Boolean flag for if person is submitted to vetting through re-vetting process.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'PersonsVetting',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the Users table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'PersonsVetting',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'PersonsVetting',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'PersonsVetting',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO