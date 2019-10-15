/*
    NAME:   NewPostImportExceptions
    
    DESCR:  This is the import migration exceptions table that tracks the following information 
            about data exceptions found during the New Post On-boarding Import Process:

            1) ID of the associated Import Log record
            2) Name of the Training Event template file worksheet:
                a) "TE" = Training Event
                b) "L"  = Training Event Locations (AKA "Locations")
                c) "P"  = Training Event Participants (AKA "Participants")       
                d) "I"  = Training Event Instructors (AKA "Instructors")
            3) Location of the Data Element with the exception/error in Excel A1 format
            4) Name of the Data Element with the exception/error
            5) Value of the Data Element with the exception/error
            6) Description of the Exception/Error
            7) Impact or result of the Exception/Error:
                a) Record or row was not imported
                b) Record was imported but the specified data element value was not imported
*/
CREATE TABLE [migration].[NewPostImportExceptions]
(
	[NewPostImportExceptionsID] BIGINT IDENTITY (1, 1) NOT NULL,        

	[NewPostImportID] BIGINT NULL,					-- FK to [NewPostImportLog] table.   
    [WorksheetID] NVARCHAR(2) NULL,					-- Identifies the specific worksheet in the file referenced by [NewPostImportID].
    [DataElementLocation] NVARCHAR(10) NULL,        -- Column & Row location of the data element with the exception/error.  
                                                    -- Format is Excel ''A1'' format (Column Letter followed by Row Number).  
    [DataElementName] NVARCHAR(10) NULL,            -- Name of the data element with the exception/error.
    [DataElementValue] NVARCHAR(500) NULL,          -- Value of the data element generating the exception/error.
    [ExceptionDescription] NVARCHAR(500) NULL,      -- Description of the exception/error
    [ExceptionResult] NVARCHAR(200) NULL,           -- Impact of the exception/error.  Did the exception prevent the record data from being imported?
	[ModifiedByAppUserID] INT NOT NULL DEFAULT(2),  -- [AppUserID] value of 2 = 'ONBOARDING'.
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),

    CONSTRAINT [PK_NewPostImportExceptions] 
		PRIMARY KEY ([NewPostImportExceptionsID]),

    CONSTRAINT [FK_NewPostImportExceptions_AppUsers] 
        FOREIGN KEY ([ModifiedByAppUserID]) 
        REFERENCES [users].[AppUsers]([AppUserID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [migration].[NewPostImportExceptions_History]))
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'migration',
	@level1type = N'TABLE',  @level1name = N'NewPostImportExceptions',
	@value = N'Import migration table that maintains the log of data exceptions found during the processing & import of Training Event template xlsx files.';
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportExceptions',
    @level2type = N'COLUMN', @level2name = N'NewPostImportExceptionsID',
	@value = N'Primary key & identity value of the record in this table.  This is the master import tracking ID that links all of the New Post Import records in the different [migration] tables to a specific import template file.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportExceptions',
    @level2type = N'COLUMN', @level2name = N'NewPostImportID',
	@value = N'This is the master import tracking ID that links all of the New Post Import records in the different [migration] tables to a specific import template file.  Foreign key pointing to the [NewPostImportLog] table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportExceptions',
    @level2type = N'COLUMN', @level2name = N'WorksheetID',
	@value = N'Identifies the specific worksheet in the file referenced by [NewPostImportID].  Valid values are: ''TE'' (Training Event), ''L'' (Training Event Locations, AKA ''Locations''),  ''P'' (Training Event Participants, AKA ''Participants''),  ''I'' (Training Event Instructors, AKA ''Instructors'').'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportExceptions',
    @level2type = N'COLUMN', @level2name = N'DataElementLocation',
	@value = N'Column & Row location of the data element with the exception/error.  Format is Excel ''A1'' format (Column Letter followed by Row Number).'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportExceptions',
    @level2type = N'COLUMN', @level2name = N'DataElementName',
	@value = N'Name of the data element with the exception/error.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportExceptions',
    @level2type = N'COLUMN', @level2name = N'DataElementValue',
	@value = N'Value of the data element generating the exception/error.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportExceptions',
    @level2type = N'COLUMN', @level2name = N'ExceptionDescription',
	@value = N'Description of the exception/error'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
    @level1type = N'TABLE',  @level1name = N'NewPostImportExceptions',
    @level2type = N'COLUMN', @level2name = N'ExceptionResult',
	@value = N'Impact of the exception/error.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'migration',
	@level1type = N'TABLE',  @level1name = N'NewPostImportExceptions',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Default value of 1 is the User known as ''NEW POST IMPORT''.  Foreign key pointing to the [AppUsers] table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'migration',
	@level1type = N'TABLE',  @level1name = N'NewPostImportExceptions',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'migration',
	@level1type = N'TABLE',  @level1name = N'NewPostImportExceptions',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'migration',
	@level1type = N'TABLE',  @level1name = N'NewPostImportExceptions',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod for which the record is valid.'
GO