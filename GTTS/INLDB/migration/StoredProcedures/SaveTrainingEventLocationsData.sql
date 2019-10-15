CREATE PROCEDURE [migration].[SaveTrainingEventLocationsData]
	@NewPostImportID BIGINT
AS
BEGIN

    -- Define local variables used in this SP.
	DECLARE @NewPostLocationID AS INT = NULL;
	DECLARE @NewPostLocationIDString AS VARCHAR(12) = NULL;
	DECLARE @PersonIdentity AS BIGINT = NULL;
	DECLARE @EventCityID AS INT = NULL;
	DECLARE @EventStateID AS INT = NULL;
	DECLARE @EventCountryID AS INT = NULL;
	DECLARE @LocationID AS INT = NULL;
    DECLARE @Submitted AS INT = NULL; 
    DECLARE @Imported AS INT = NULL; 
    DECLARE @NotImported AS INT = NULL; 
	DECLARE @ModifiedByAppUserIDValue AS INT = 2; -- AppUserName = ONBOARDING 

	DECLARE LocationCursor CURSOR 
		LOCAL STATIC READ_ONLY FORWARD_ONLY
	FOR 
		-- Cursor should only be set for those rows that match the current NewPostImportID (passed into this SP),
		-- have an Import Status = 'Uploaded' meaning ready for import, and that are not missing any required data
		-- elements that must be populated in order to create a Training Event Location.
		SELECT DISTINCT npl.[NewPostLocationID]
		  FROM [migration].[NewPostLocations] npl
		 WHERE npl.[ImportStatus] = 'Uploaded' 
		   AND npl.[NewPostImportID] = @NewPostImportID
		   AND (npl.[EventStartDate] IS NOT NULL AND npl.[EventEndDate] IS NOT NULL);

    -- Initialize Submitted, Imported, Not Imported counters.
    SET @Submitted = (SELECT npil.[LocationsSubmittedCount]
		                FROM [migration].[NewPostImportLog] npil
		               WHERE npil.[NewPostImportID] = @NewPostImportID);
    SET @Imported = 0;
    SET @NotImported = 0;

	-- Open cursor & begin processing rows identified by the cursor.
	OPEN LocationCursor
	FETCH NEXT FROM LocationCursor INTO @NewPostLocationID
	WHILE @@FETCH_STATUS = 0
		BEGIN
			BEGIN TRY
	
				-- Get Event City, State, & Country IDs from the row.
				SELECT @EventCityID = npl.[EventCityID], 
					   @EventStateID = npl.[EventStateID], 
					   @EventCountryID = npl.[EventCountryID]
				  FROM [migration].[NewPostLocations] npl
				 WHERE npl.[NewPostLocationID] = @NewPostLocationID;

				-- Call procedure to find or create the Locations table record for the passed in 
				-- City, State, & Country IDs and return the LocationID value from the procedure.
				EXECUTE @LocationID = [migration].[GetLocationID] @CountryID = @EventCountryID, 
																  @StateID = @EventStateID, 
																  @CityID = @EventCityID, 
																  @Address1 = NULL, 
																  @Address2 = NULL, 
																  @Address3 = NULL, 
																  @ModifiedByAppUserID = 2;

				-- Verify that a matching Location was found or created.
				IF @LocationID <> 0
					-- Matching location was found or created.  Generate a new [TrainingEventLocations] record 
					-- & update the [NewPostLocations] record accordingly.
					BEGIN
						-- Add the new Training Event Location to the [TrainingEventLocations] table for the corresponding 
						-- TrainingEventID from the [NewPostTrainingEvents] table.
						INSERT INTO [training].[TrainingEventLocations]
							   ([TrainingEventID], 
								[LocationID], 
								[EventStartDate], 
								[EventEndDate], 
								[TravelStartDate], 
								[TravelEndDate], 
								[ModifiedByAppUserID])
						SELECT (SELECT npte.[TrainingEventID] 
								  FROM [migration].[NewPostTrainingEvents] npte
								 WHERE npte.[NewPostImportID] = @NewPostImportID),
							   @LocationID, 
							   npl.[EventStartDate], 
							   npl.[EventEndDate], 
							   npl.[TravelStartDate], 
							   npl.[TravelEndDate], 
							   @ModifiedByAppUserIDValue
						  FROM [migration].[NewPostLocations] npl 
						 WHERE npl.[NewPostLocationID] = @NewPostLocationID;
				
						-- Update [NewPostLocations] record with new [LocationID] value
						-- & set the import status of the record to "Imported".
						UPDATE [migration].[NewPostLocations]
						   SET [LocationID] = @LocationID, 
							   [ImportStatus] = 'Imported', 
							   [ModifiedDate] = getutcdate(), 
							   [ModifiedByAppUserID] = @ModifiedByAppUserIDValue 
						 WHERE [NewPostLocationID] = @NewPostLocationID;
					END
				ELSE
					-- For some rason the system was not able to find or create a matching location.  Update the [NewPostLocations] table accordingly.
					BEGIN
						-- Update [NewPostLocations] record to indicate that the system was not able to generate a [TrainingEventLocations] table
						-- record because it was not able to find or create a matching [Locations] table record.
						UPDATE [migration].[NewPostLocations]
						   SET [LocationID] = 0, 
							   [ImportStatus] = 'Not Imported - Unable to create Location for this record', 
							   [ModifiedDate] = getutcdate(), 
							   [ModifiedByAppUserID] = @ModifiedByAppUserIDValue 
						 WHERE [NewPostLocationID] = @NewPostLocationID;						
					END;

			END TRY
			BEGIN CATCH
				SELECT @NewPostLocationIDString = CAST(@NewPostLocationID AS VARCHAR);
				RAISERROR (N'Failed at row %s', 16, 1, @NewPostLocationIDString);
			END CATCH
			FETCH NEXT FROM LocationCursor INTO @NewPostLocationID;
		END;
		
	CLOSE LocationCursor;
	DEALLOCATE LocationCursor;

    -- Update counters.
    SET @Imported = (SELECT COUNT(*)
                    FROM [migration].[NewPostLocations] npl
                    WHERE npl.[NewPostImportID] = @NewPostImportID
                        AND npl.[ImportStatus] = 'Imported');
    SET @NotImported = @Submitted - @Imported;

    -- Update [NewPostImportLog] table with record statistics.
    BEGIN TRANSACTION     
        UPDATE [migration].[NewPostImportLog]
            SET [LocationsImportedCount] = @Imported,
                [LocationsNotImportedCount] = @NotImported,
                [ModifiedByAppUserID] = @ModifiedByAppUserIDValue,
                [ModifiedDate] = getutcdate()
        WHERE [NewPostImportID] = @NewPostImportID;
    COMMIT;

END