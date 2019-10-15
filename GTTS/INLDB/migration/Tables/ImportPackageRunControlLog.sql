﻿/*
    NAME:   ImportPackageRunControlLog
    
    DESCR:  This table keeps track of all of the NewPostImportIDs generated in the
			the current execution run of the SSIS Import Post Package.  
			
			The SSIS process imports all of the template files in a selected folder.
			Every time a file is processed, a new [NewPostImportID] value is generated.
			That ID value is written to this table.  After all of the files in the folder
			folder have been processed, this table can be used to control the generation
			of a Process Run Report for all of the files that were processed in a specific
			SSIS process run.  When a new SSIS process run is started, all of the records
			in this table will be purged.

			This table is also used to track any runtime processing status messages
			generated by SSIS process or the import stored procedures.
*/
CREATE TABLE [migration].[ImportPackageRunControlLog]
(
	[RecordKeyID] BIGINT IDENTITY (1, 1) NOT NULL,			-- PK for table.
	[NewPostImportID] BIGINT NULL,							-- FK to [NewPostImportLog] table.
	[Message] VARCHAR(500) NULL,							-- Process status or control messages.
	[ModifiedByAppUserID] INT NOT NULL DEFAULT(2),          -- [AppUserID] value of 2 = 'ONBOARDING'.
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),

   CONSTRAINT [PK_MasterImportPostSPTaskStatus] 
		PRIMARY KEY ([RecordKeyID]),

    CONSTRAINT [FK_MasterImportPostSPTaskStatus_NewPostImportLog] 
        FOREIGN KEY ([NewPostImportID]) 
        REFERENCES [migration].[NewPostImportLog]([NewPostImportID]),

    CONSTRAINT [FK_MasterImportPostSPTaskStatus_AppUsers] 
        FOREIGN KEY ([ModifiedByAppUserID]) 
        REFERENCES [users].[AppUsers]([AppUserID])
)
ON [PRIMARY]
GO