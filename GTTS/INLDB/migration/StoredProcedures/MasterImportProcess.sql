/*
    NAME:   MasterImportProcess
    
    DESCR:  This is the Master Stored Procedure for the New Post Import Process.  This is the 
            top-level stored procedure that manages all of the other stored procedures that perform
            the import, validation, and load procedures on the Training Event, Locations, 
            Participants, & Instructors being imported from the Training Event Template XLSX files.
*/
CREATE PROCEDURE [migration].[MasterImportProcess]
    @NewPostImportIDValue BIGINT = NULL -- ID value that points to the [NewPostImportLog] 
									    -- record that refers to the template file being processed.
AS
    SET NOCOUNT ON;

    -- If @NewPostImportIDValue is missing or NULL, abort the SP.
    IF @NewPostImportIDValue IS NULL
        BEGIN
            PRINT 'No NewPostImportIDValue was passed in.  [MasterImportProcess] will abort.'
            RETURN
        END;

    -- Write the File Import Process Started status message to the [ImportPackageRunControlLog] table.
    DECLARE @FileName AS VARCHAR(1000);		-- Holds the name of the XLSX file being imported.
	DECLARE @strMessage AS VARCHAR(500);	-- Holds the generated message text.

	SET @FileName = (SELECT npil.FileName	
				       FROM migration.NewPostImportLog npil
				      WHERE npil.NewPostImportID = @NewPostImportIDValue);
	SET @strMessage = '4.1 - File "' + @FileName + '" Import Process Started';
    EXECUTE [migration].[WriteToImportPackageRunControlLog]
            @NewPostImportID = @NewPostImportIDValue,
			@Message = @strMessage;

	-- Get rid of all [Import...] rows that has ALL NULL columns.
	EXECUTE [migration].[DeleteAllNULLRecordsFromImportTables]
	SET @strMessage = '4.1.1 - NULL Values Deleted from Import tables';
    EXECUTE [migration].[WriteToImportPackageRunControlLog]
            @NewPostImportID = @NewPostImportIDValue,
			@Message = @strMessage;

	-- Update [NewPostImportLog] table with [Import...] row counts.
    EXECUTE [migration].[GetImportTableCounts]
            @NewPostImportID = @NewPostImportIDValue;
	SET @strMessage = '4.1.2 - Import Row Counts written to the [NewPostImportLog] table';
    EXECUTE [migration].[WriteToImportPackageRunControlLog]
            @NewPostImportID = @NewPostImportIDValue,
			@Message = @strMessage;

    -- Upload the data from the [Import...] tables to the [NewPost...] tables.
	-- Training Event Data.
    EXECUTE [migration].[WriteToImportPackageRunControlLog]
            @NewPostImportID = @NewPostImportIDValue,
			@Message = '4.1.3.1 - Upload of [ImportTrainingEvent] data to [NewPostTrainingEvents] table STARTED';
    EXECUTE [migration].[CreateNewPostTrainingEventRecord]
            @NewPostImportID = @NewPostImportIDValue;
    EXECUTE [migration].[WriteToImportPackageRunControlLog]
            @NewPostImportID = @NewPostImportIDValue,
			@Message = '4.1.3.2 - Upload of [ImportTrainingEvent] data to [NewPostTrainingEvents] table COMPLETED';

	-- Training Event Locations Data.
    EXECUTE [migration].[WriteToImportPackageRunControlLog]
            @NewPostImportID = @NewPostImportIDValue,
			@Message = '4.1.3.3 - Upload of [ImportLocations] data to [NewPostLocations] table STARTED';
    EXECUTE [migration].[CreateNewPostLocationsRecords]
            @NewPostImportID = @NewPostImportIDValue;
    EXECUTE [migration].[WriteToImportPackageRunControlLog]
            @NewPostImportID = @NewPostImportIDValue,
			@Message = '4.1.3.4 - Upload of [ImportLocations] data to [NewPostLocations] table COMPLETED';

	-- Training Event Participants Data.
    EXECUTE [migration].[WriteToImportPackageRunControlLog]
            @NewPostImportID = @NewPostImportIDValue,
			@Message = '4.1.3.5 - Upload of [ImportParticipants] data to [NewPostParticipants] table STARTED';
    EXECUTE [migration].[CreateNewPostParticipantsRecords]
            @NewPostImportID = @NewPostImportIDValue;
    EXECUTE [migration].[WriteToImportPackageRunControlLog]
            @NewPostImportID = @NewPostImportIDValue,
			@Message = '4.1.3.6 - Upload of [ImportParticipants] data to [NewPostParticipants] table COMPLETED';

	-- Training Event Instructors Data.
    EXECUTE [migration].[WriteToImportPackageRunControlLog]
            @NewPostImportID = @NewPostImportIDValue,
			@Message = '4.1.3.7 - Upload of [ImportInstructors] data to [NewPostInstructors] table STARTED';
    EXECUTE [migration].[CreateNewPostInstructorsRecords]
            @NewPostImportID = @NewPostImportIDValue;
    EXECUTE [migration].[WriteToImportPackageRunControlLog]
            @NewPostImportID = @NewPostImportIDValue,
			@Message = '4.1.3.8 - Upload of [ImportInstructors] data to [NewPostInstructors] table COMPLETED';


    -- Perform reverse-lookups to get the reference data elements from the different GTTS database tables and update [NewPost...] tables.
	-- Training Event Data.
    EXECUTE [migration].[WriteToImportPackageRunControlLog]
            @NewPostImportID = @NewPostImportIDValue,
			@Message = '4.1.4.1 - Reverse lookups of Post supplied Training Event values STARTED';
	EXECUTE [migration].[ReverseLookupTrainingEventValues]
			@NewPostImportID = @NewPostImportIDValue;
    EXECUTE [migration].[WriteToImportPackageRunControlLog]
            @NewPostImportID = @NewPostImportIDValue,
			@Message = '4.1.4.2 - Reverse lookups of Post supplied Training Event values COMPLETED';

	-- Training Event Locations Data.
    EXECUTE [migration].[WriteToImportPackageRunControlLog]
            @NewPostImportID = @NewPostImportIDValue,
			@Message = '4.1.4.3 - Reverse lookups of Post supplied Locations values STARTED';
	EXECUTE [migration].[ReverseLookupLocationValues]
			@NewPostImportID = @NewPostImportIDValue;
    EXECUTE [migration].[WriteToImportPackageRunControlLog]
            @NewPostImportID = @NewPostImportIDValue,
			@Message = '4.1.4.4 - Reverse lookups of Post supplied Locations values COMPLETED';

	-- Training Event Participants Data.
    EXECUTE [migration].[WriteToImportPackageRunControlLog]
            @NewPostImportID = @NewPostImportIDValue,
			@Message = '4.1.4.5 - Reverse lookups of Post supplied Participants values STARTED';
	EXECUTE [migration].[ReverseLookupParticipantValues]
			@NewPostImportID = @NewPostImportIDValue;
    EXECUTE [migration].[WriteToImportPackageRunControlLog]
            @NewPostImportID = @NewPostImportIDValue,
			@Message = '4.1.4.6 - Reverse lookups of Post supplied Participants values COMPLETED';

	-- Training Event Instructors Data.
    EXECUTE [migration].[WriteToImportPackageRunControlLog]
            @NewPostImportID = @NewPostImportIDValue,
			@Message = '4.1.4.7 - Reverse lookups of Post supplied Instructors values STARTED';
	EXECUTE [migration].[ReverseLookupInstructorValues]
			@NewPostImportID = @NewPostImportIDValue;
    EXECUTE [migration].[WriteToImportPackageRunControlLog]
            @NewPostImportID = @NewPostImportIDValue,
			@Message = '4.1.4.8 - Reverse lookups of Post supplied Instructors values COMPLETED';
  
	-- Process the updated [NewPost...] tables and identify any Import Data Exceptions that need to be cataloged and reported back to Post.
	/*
		This section is being skipped in unitil after the 
		[SaveNewPost...] Stored Procedures have been developed.

    -- Write the "Import Data Exceptions identified and logged" status message to the [ImportPackageRunControlLog] table.
	SET @strMessage = 'Import Data Exceptions identified and logged';
    EXECUTE [migration].[WriteToImportPackageRunControlLog]
            @NewPostImportID = @NewPostImportIDValue,
			@Message = @strMessage;
	*/


	-- Write the records in the [NewPost...] tables into the primary GTTS database tables.
	-- Training Event Data.
    EXECUTE [migration].[WriteToImportPackageRunControlLog]
            @NewPostImportID = @NewPostImportIDValue,
			@Message = '4.1.6.1 - Import of [NewPostTrainingEvents] table data to the GTTS data tables STARTED';
	EXECUTE [migration].[SaveTrainingEventData]
			@NewPostImportID = @NewPostImportIDValue;
    EXECUTE [migration].[WriteToImportPackageRunControlLog]
            @NewPostImportID = @NewPostImportIDValue,
			@Message = '4.1.6.2 - Import of [NewPostTrainingEvents] table data to the GTTS data tables COMPLETED';

	-- Training Event Locations Data.
    EXECUTE [migration].[WriteToImportPackageRunControlLog]
            @NewPostImportID = @NewPostImportIDValue,
			@Message = '4.1.6.3 - Import of [NewPostLocations] table data to the GTTS data tables STARTED';
	EXECUTE [migration].[SaveTrainingEventLocationsData]
			@NewPostImportID = @NewPostImportIDValue;
    EXECUTE [migration].[WriteToImportPackageRunControlLog]
            @NewPostImportID = @NewPostImportIDValue,
			@Message = '4.1.6.4 - Import of [NewPostLocations] table data to the GTTS data tables COMPLETED';

	-- Training Event Participants Data.
    EXECUTE [migration].[WriteToImportPackageRunControlLog]
            @NewPostImportID = @NewPostImportIDValue,
			@Message = '4.1.6.5 - Import of [NewPostParticipants] table data to the GTTS data tables STARTED';
	EXECUTE [migration].[SaveTrainingEventParticipantsData]
			@NewPostImportID = @NewPostImportIDValue;
    EXECUTE [migration].[WriteToImportPackageRunControlLog]
            @NewPostImportID = @NewPostImportIDValue,
			@Message = '4.1.6.6 - Import of [NewPostParticipants] table data to the GTTS data tables COMPLETED';

	-- Training Event Instructors Data.
    EXECUTE [migration].[WriteToImportPackageRunControlLog]
            @NewPostImportID = @NewPostImportIDValue,
			@Message = '4.1.6.7 - Import of [NewPostInstructors] table data to the GTTS data tables STARTED';
	EXECUTE [migration].[SaveTrainingEventInstructorsData]
			@NewPostImportID = @NewPostImportIDValue;
    EXECUTE [migration].[WriteToImportPackageRunControlLog]
            @NewPostImportID = @NewPostImportIDValue,
			@Message = '4.1.6.8 - Import of [NewPostInstructors] table data to the GTTS data tables COMPLETED';
			   		 	  
    -- Write the File Import Process Completed status message to the [ImportPackageRunControlLog] table.
	SET @strMessage = '4.2 - File "' + @FileName + '" Import Process Completed';
    EXECUTE [migration].[WriteToImportPackageRunControlLog]
            @NewPostImportID = @NewPostImportIDValue,
			@Message = @strMessage;
GO