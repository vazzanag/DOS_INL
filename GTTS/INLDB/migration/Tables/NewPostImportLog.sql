/*
    NAME:   NewPostImportLog
    
    DESCR:  This is the import migration log table that tracks the following information
            about the New Post On-boarding Import Process:            
                a) What Training Event template files were imported
                b) When the Training Event template file was imported
                c) The size & date of the Training Event template file
                d) The results of the import process.

            There are 4 worksheets in each Training Event template file:
                a) Training Event
                b) Training Event Locations (AKA "Locations")
                c) Training Event Participants (AKA "Participants")       
                d) Training Event Instructors (AKA "Instructors")

            The results that are tracked for each of the worksheets include:
                a) If a worksheet had data
                b) The number of data records the worksheet contained
                c) The number of data records were imported from the worksheet
                d) The number of data records were not imported from the worksheet
                e) The number of exception issues that were found during the import process worksheet
*/
CREATE TABLE [migration].[NewPostImportLog]
(
    [NewPostImportID] BIGINT IDENTITY (1, 1) NOT NULL,  -- Internal PK of table.
	[ImportSessionID] INT DEFAULT '0',					-- Internal session identifier that groups a number of individual import files.
    [NewPostImportDateStamp] DATETIME NULL,				-- Date/Time file was uploaded
	[CountryName] VARCHAR(75) NULL,						-- Name of Country that the data is being imported for.
    [CountryID] INT NULL,                               -- ID of Country that the data is being imported for.
                                                        -- Retrieved at the beginning of the SSIS process and saved here.
    [PostName] VARCHAR(100) NULL,						-- Name of Post (w/in CountryID) that the data is being imported for.
	[PostID] INT NULL,                                  -- ID of Post (w/in CountryID) that the data is being imported for.
                                                        -- Retrieved at the beginning of the SSIS process and saved here.
    [FileName] VARCHAR(1000) NULL,						-- Name of the file being uploaded.
    [FileDate] DATETIME NULL,							-- Operating System's Date of the file being uploaded.
    [FileSize] INT NULL,								-- Size in bytes of the file being uploaded.
	[SourceFolderPath] VARCHAR(1000) NULL,  		    -- Folder path of the file being uploaded
	[ArchiveFolderPath] VARCHAR(1000) NULL,				-- Folder path where the file is moved to after it is uploaded.
	[SourceFullPath] VARCHAR(1000) NULL,       			-- Complete source folder path & file name of the file being uploaded.
    
    [HasTrainingEvent] BIT DEFAULT '0' NULL,            -- Flag that indicates if the import file contains Training Event data.
    [TrainingEventSubmittedCount] TINYINT NULL,         -- The number of data records submitted on the Training Event worksheet.
    [TrainingEventImportedCount] TINYINT NULL,          -- The number of data records that were imported from the Training Event worksheet.
    [TrainingEventNotImportedCount] TINYINT NULL,       -- The number of data records that were not imported from the Training Event worksheet.
    [TrainingEventExceptionsCount] SMALLINT NULL,       -- The number of exception issues that were found during the import process of the Training Event worksheet.

    [HasLocations] BIT DEFAULT '0' NULL,                -- Flag that indicates if the import file contains Locations data.
    [LocationsSubmittedCount] SMALLINT NULL,            -- The number of data records submitted on the Locations worksheet. 
    [LocationsImportedCount] SMALLINT NULL,             -- The number of data records that were imported from the Locations worksheet. 
    [LocationsNotImportedCount] SMALLINT NULL,          -- The number of data records that were not imported from the Locationst worksheet. 
    [LocationsExceptionsCount] INT NULL,                -- The number of exception issues that were found during the import process of the Locations worksheet. 

    [HasParticipants] BIT DEFAULT '0' NULL,             -- Flag that indicates if the import file contains Paricipants data.
    [ParticipantsSubmittedCount] SMALLINT NULL,         -- The number of data records submitted on the Paricipants worksheet. 
    [ParticipantsImportedCount] SMALLINT NULL,          -- The number of data records that were imported from the Paricipants worksheet. 
    [ParticipantsNotImportedCount] SMALLINT NULL,       -- The number of data records that were not imported from the Paricipants worksheet. 
    [ParticipantsExceptionsCount] INT NULL,             -- The number of exception issues that were found during the import process of the Paricipants worksheet. 

    [HasInstructors] BIT DEFAULT '0' NULL,              -- Flag that indicates if the import file contains Instructors data.
    [InstructorsSubmittedCount] SMALLINT NULL,          -- The number of data records submitted on the Instructors worksheet. 
    [InstructorsImportedCount] SMALLINT NULL,           -- The number of data records that were imported from the Instructors worksheet. 
    [InstructorsNotImportedCount] SMALLINT NULL,        -- The number of data records that were not imported from the Instructors worksheet.
    [InstructorsExceptionsCount] INT NULL,              -- The number of exception issues that were found during the import process of the Instructors worksheet.

	[ModifiedByAppUserID] INT NOT NULL DEFAULT(2),          -- [AppUserID] value of 2 = 'ONBOARDING'.
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),

    CONSTRAINT [PK_NewPostImportLog] 
		PRIMARY KEY ([NewPostImportID]),

    CONSTRAINT [FK_NewPostImportLog_AppUsers] 
        FOREIGN KEY ([ModifiedByAppUserID]) 
        REFERENCES [users].[AppUsers]([AppUserID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [migration].[NewPostImportLog_History]))
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'migration',
	@level1type = N'TABLE',  @level1name = N'NewPostImportLog',
	@value = N'Import migration table that maintains the log of Training Event template xlsx files that were processed and subsequently imported.';
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportLog',
    @level2type = N'COLUMN', @level2name = N'NewPostImportID',
	@value = N'Primary key & identity value of the record in this table.  This is the master import tracking ID that links all of the New Post Import records in the different [migration] tables to a specific import template file.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportLog',
    @level2type = N'COLUMN', @level2name = N'ImportSessionID',
	@value = N'Internal session identifier that groups a number of individual import files.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportLog',
    @level2type = N'COLUMN', @level2name = N'NewPostImportDateStamp',
	@value = N'Date & time when the file was uploaded/imported.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportLog',
    @level2type = N'COLUMN', @level2name = N'CountryName',
	@value = N'The Name of the Country that the data for being imported for. This value is retrieved at the beginning of the SSIS import package processing.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportLog',
    @level2type = N'COLUMN', @level2name = N'CountryID',
	@value = N'The ID of the Country that the data for being imported for. This value is retrieved at the beginning of the SSIS import package processing.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportLog',
    @level2type = N'COLUMN', @level2name = N'PostName',
	@value = N'The name of the Post within the country specified by [CountryID] that the data for being imported for. This value is retrieved at the beginning of the SSIS import package processing.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportLog',
    @level2type = N'COLUMN', @level2name = N'PostID',
	@value = N'The ID of the Post within the country specified by [CountryID] that the data for being imported for. This value is retrieved at the beginning of the SSIS import package processing.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportLog',
    @level2type = N'COLUMN', @level2name = N'FileName',
	@value = N'Name of the file being uploaded/imported.  This is the operating system name of the file as it exists on the user''s computer.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportLog',
    @level2type = N'COLUMN', @level2name = N'FileDate',
	@value = N'Operating system date of the file being uploaded/imported.  This is the date of the file as it exists on the user''s computer and not the actual date of the upload/import of the file''s data.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportLog',
    @level2type = N'COLUMN', @level2name = N'FileSize',
	@value = N'Size in bytes of the file being uploaded/imported.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportLog',
    @level2type = N'COLUMN', @level2name = N'SourceFolderPath',
	@value = N'Folder path of the file being uploaded.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportLog',
    @level2type = N'COLUMN', @level2name = N'ArchiveFolderPath',
	@value = N'Folder path where the file is moved to after it is uploaded.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportLog',
    @level2type = N'COLUMN', @level2name = N'SourceFullPath',
	@value = N'Complete source folder path & file name of the file being uploaded.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportLog',
    @level2type = N'COLUMN', @level2name = N'HasTrainingEvent',
	@value = N'Boolean that indicates if the Training Event template file had data on the Training Event worksheet for import.  The default value for this column is FALSE (0).  If the Training Event worksheet contains data, this column will be set to TRUE (1) by the import process.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportLog',
    @level2type = N'COLUMN', @level2name = N'TrainingEventSubmittedCount',
	@value = N'The number of data records submitted on the Training Event worksheet.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportLog',
    @level2type = N'COLUMN', @level2name = N'TrainingEventImportedCount',
	@value = N'The number of data records that were imported from the Training Event worksheet.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportLog',
    @level2type = N'COLUMN', @level2name = N'TrainingEventNotImportedCount',
	@value = N'The number of data records that were not imported from the Training Event worksheet.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportLog',
    @level2type = N'COLUMN', @level2name = N'TrainingEventExceptionsCount',
	@value = N'The number of exception issues that were found during the import process of the Training Event worksheet.  An exception issue will not always prevent a worksheet record from being imported.  All exceptions are written to the [NewPostImportExceptions] table and an Exception report will be generated at the end of an import job.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportLog',
    @level2type = N'COLUMN', @level2name = N'HasLocations',
	@value = N'Boolean that indicates if the Training Event template file had data on the Locations worksheet for import.  The default value for this column is FALSE (0).  If the Locations worksheet contains data, this column will be set to TRUE (1) by the import process.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportLog',
    @level2type = N'COLUMN', @level2name = N'LocationsSubmittedCount',
	@value = N'The number of data records submitted on the Locations worksheet.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportLog',
    @level2type = N'COLUMN', @level2name = N'LocationsImportedCount',
	@value = N'The number of data records that were imported from the Locations worksheet.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportLog',
    @level2type = N'COLUMN', @level2name = N'LocationsNotImportedCount',
	@value = N'The number of data records that were not imported from the Locations worksheet.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportLog',
    @level2type = N'COLUMN', @level2name = N'LocationsExceptionsCount',
	@value = N'The number of exception issues that were found during the import process of the Locations worksheet.  An exception issue will not always prevent a worksheet record from being imported.  All exceptions are written to the [NewPostImportExceptions] table and an Exception report will be generated at the end of an import job.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportLog',
    @level2type = N'COLUMN', @level2name = N'HasParticipants',
	@value = N'Boolean that indicates if the Training Event template file had data on the Participants worksheet for import.  The default value for this column is FALSE (0).  If the Participants worksheet contains data, this column will be set to TRUE (1) by the import process.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportLog',
    @level2type = N'COLUMN', @level2name = N'ParticipantsSubmittedCount',
	@value = N'The number of data records submitted on the Participants worksheet.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportLog',
    @level2type = N'COLUMN', @level2name = N'ParticipantsImportedCount',
	@value = N'The number of data records that were imported from the Participants worksheet.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportLog',
    @level2type = N'COLUMN', @level2name = N'ParticipantsNotImportedCount',
	@value = N'The number of data records that were not imported from the Participants worksheet.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportLog',
    @level2type = N'COLUMN', @level2name = N'ParticipantsExceptionsCount',
	@value = N'The number of exception issues that were found during the import process of the Participants worksheet.  An exception issue will not always prevent a worksheet record from being imported.  All exceptions are written to the [NewPostImportExceptions] table and an Exception report will be generated at the end of an import job.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportLog',
    @level2type = N'COLUMN', @level2name = N'HasInstructors',
	@value = N'Boolean that indicates if the Training Event template file had data on the Instructors worksheet for import.  The default value for this column is FALSE (0).  If the Instructors worksheet contains data, this column will be set to TRUE (1) by the import process.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportLog',
    @level2type = N'COLUMN', @level2name = N'InstructorsSubmittedCount',
	@value = N'The number of data records submitted on the Instructors worksheet.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportLog',
    @level2type = N'COLUMN', @level2name = N'InstructorsImportedCount',
	@value = N'The number of data records that were imported from the Instructors worksheet.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportLog',
    @level2type = N'COLUMN', @level2name = N'InstructorsNotImportedCount',
	@value = N'The number of data records that were not imported from the Instructors worksheet.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportLog',
    @level2type = N'COLUMN', @level2name = N'InstructorsExceptionsCount',
	@value = N'The number of exception issues that were found during the import process of the Instructors worksheet.  An exception issue will not always prevent a worksheet record from being imported.  All exceptions are written to the [NewPostImportExceptions] table and an Exception report will be generated at the end of an import job.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'migration',
	@level1type = N'TABLE',  @level1name = N'NewPostImportLog',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Default value of 1 is the User known as ''NEW POST IMPORT''.  Foreign key pointing to the [AppUsers] table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'migration',
	@level1type = N'TABLE',  @level1name = N'NewPostImportLog',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'migration',
	@level1type = N'TABLE',  @level1name = N'NewPostImportLog',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
	@level1type = N'TABLE',  @level1name = N'NewPostImportLog',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod for which the record is valid.'
GO