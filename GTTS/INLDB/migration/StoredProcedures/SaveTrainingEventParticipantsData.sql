/*
    NAME:   SaveTrainingEventParticipantsData
    
    DESCR:  This Stored Procedure will process the data in the [NewPostParticipants] table
			and write those values to new Persons related records in the GTTS primary
			data tables.  After the new [Persons] table record has been created the 
			new [PersonID] value will be written back to the [NewPostPersons] record.	         
*/
CREATE PROCEDURE [migration].[SaveTrainingEventParticipantsData]
	@NewPostImportID BIGINT
AS
BEGIN

	-- Define local variables unsed in this SP.
	DECLARE @NewPostParticipantID AS INT = NULL;
	DECLARE @NewPostParticipantIDString AS VARCHAR(12) = NULL;
	DECLARE @PersonIdentity AS BIGINT = NULL;
	DECLARE @MatchingPersonsCnt AS BIGINT = NULL;
	DECLARE @TrainingEventID AS BIGINT = NULL;
    DECLARE @Submitted AS INT = NULL; 
    DECLARE @Imported AS INT = NULL; 
    DECLARE @NotImported AS INT = NULL;
	DECLARE @DataDump AS NVARCHAR(MAX);
	DECLARE @ModifiedByAppUserIDValue AS INT = 2;	-- AppUserName = ONBOARDING 
	DECLARE @FirstMiddleNamesValue AS NVARCHAR(150) = NULL;
	DECLARE @LastNamesValue AS NVARCHAR(150) = NULL;
	DECLARE @DOBValue AS DATETIME = NULL;
	DECLARE @POBCityIDValue AS INT = NULL;
	DECLARE @GenderValue AS CHAR(1) = NULL;
	DECLARE @NationalIDValue AS NVARCHAR(100) = NULL;
	DECLARE @ResultSet AS TABLE						-- Table Variable to hold the results of the [persons].[GetMatchingPersons] SP
	(
		PersonID BIGINT,
		FirstNames NVARCHAR(150),
		LastNames NVARCHAR(150),
		DOB DATETIME,
		POBCityID INT,
		POBCityName NVARCHAR(100),
		POBStateName NVARCHAR(75),
		POBCountryName NVARCHAR(75),
		Gender CHAR(1),
		NationalID NVARCHAR(100)
	);

	-- Define cursor for processing [NewPostParticipant] table row-by-row.	   
	DECLARE ParticipantCursor CURSOR 
		LOCAL STATIC READ_ONLY FORWARD_ONLY
	FOR 
		-- Cursor should only be set for those rows that match the current NewPostImportID (passed 
		-- into this SP), have an Import Status = 'Uploaded' meaning ready for import, and that are 
		-- not missing any required data elements that must be populated in order to create a [Persons],
		-- [TrainingEventParticipants], or [PersonsUnitLibraryInfo] record.
		SELECT DISTINCT npp.[NewPostParticipantID] 
		  FROM [migration].[NewPostParticipants] npp
		 WHERE npp.[ImportStatus] = 'Uploaded' 
		   AND npp.[NewPostImportID] = @NewPostImportID
		   AND npp.[FirstMiddleName] IS NOT NULL		-- Required data value to create a [Persons] record
		   AND npp.[GenderFlag] IS NOT NULL				-- Required data value to create a [Persons] record
		   AND npp.[USCitizenFlag] IS NOT NULL;			-- Required data value to create a [Persons] record

    -- Initialize Submitted, Imported, Not Imported counters.
    SET @Submitted = (SELECT npil.[ParticipantsSubmittedCount]
		                FROM [migration].[NewPostImportLog] npil
		               WHERE npil.[NewPostImportID] = @NewPostImportID);
    SET @Imported = 0;
    SET @NotImported = 0;	

	-- Open cursor & begin processing rows identified by the cursor.	
	OPEN ParticipantCursor
	FETCH NEXT FROM ParticipantCursor INTO @NewPostParticipantID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		BEGIN TRY

			-- Initialize @PersonIdentity to NULL before each INSERT so that we
			-- test that a [Persons] record was created.
			SET @PersonIdentity = NULL;

			-- Assign [NewPostParticipants] values to variables to pass into the [persons].[GetMatchingPersons] SP.
			SELECT @FirstMiddleNamesValue = npp.[FirstMiddleName], 
				   @LastNamesValue = npp.[LastName], 
				   @DOBValue = npp.[DOB],
				   @POBCityIDValue = npp.[POBCityID],
				   @GenderValue = npp.[GenderFlag], 
				   @NationalIDValue = npp.[NationalID]						   
			  FROM [migration].[NewPostParticipants] npp
			 WHERE npp.[NewPostParticipantID] = @NewPostParticipantID;

			-- Insert the results of the [persons].[GetMatchingPersons] SP into a table variable.
			INSERT @ResultSet(PersonID, FirstNames, LastNames, DOB, POBCityID, POBCityName, POBStateName, POBCountryName, Gender, NationalID)
			EXECUTE [persons].[GetMatchingPersons] @FirstMiddleNames = @FirstMiddleNamesValue,
												   @LastNames = @LastNamesValue,
												   @DOB = @DOBValue,
												   @POBCityID = @POBCityIDValue,
												   @Gender = @GenderValue,
												   @NationalID = @NationalIDValue,
												   @ExactMatch = 1;					-- ExactMatch is required (1 = TRUE).
			
			-- Get the number of matching rows returned by the [persons].[GetMatchingPersons] SP.
			SET @MatchingPersonsCnt = (SELECT COUNT(*) FROM @ResultSet);

			IF @MatchingPersonsCnt = 0
				-- No matching record was found.  Create a new [Persons] table record.
				BEGIN
					-- Capture incoming data into a dump string, in case process errors out.
					SET @DataDump = (SELECT 'npp.[NewPostParticipantID] = ' + CAST(@NewPostParticipantID AS NVARCHAR) + 
											'[FirstMiddleNames] = ' + CAST(npp.[FirstMiddleName] AS NVARCHAR) + 
											'[LastNames] = ' + CAST(npp.[LastName] AS NVARCHAR) + 
											'[Gender] = ' + CAST(npp.[GenderFlag] AS NVARCHAR) + 
											'[IsUSCitizen] = ' + CAST(npp.[USCitizenFlag] AS NVARCHAR) + 
											'[NationalID] = ' + CAST(npp.[NationalID] AS NVARCHAR) + 
											'[ResidenceLocationID] = ' + CAST(npp.[ResidenceLocationID] AS NVARCHAR) + 
											'[ContactEmail] = ' + CAST(npp.[ContactEmail] AS NVARCHAR)  + 
											'[ContactPhone] = ' + CAST(npp.[ContactPhone] AS NVARCHAR) + 
											'[DOB] = ' + CAST(npp.[DOB] AS NVARCHAR) + 
											'[POBCityID] = ' + CAST(npp.[POBCityID] AS NVARCHAR) + 
											'[FatherName] = NULL' + 
											'[MotherName] = NULL' +
											'[HighestEducationID] = ' + CAST(npp.[HighestEducationID] AS NVARCHAR) + 
											'[FamilyIncome] = NULL' +  
											'[EnglishLanguageProficiencyID] = ' + CAST(npp.[EnglishLanguageProficiencyID] AS NVARCHAR) + 
											'[PassportNumber] = ' + CAST(npp.[PassportNumber] AS NVARCHAR) + 
											'[PassportExpirationDate] = ' + CAST(npp.[PassportExpirationDate] AS NVARCHAR) + 
											'[PassportIssuingCountryID] = NULL' + 
											'[MedicalClearanceStatus] = NULL' +
											'[MedicalClearanceDate] = NULL' +  
											'[PsychologicalClearanceStatus] = NULL' +
											'[PsychologicalClearanceDate] = NULL' +
											'[ModifiedByAppUserID] = ' + CAST(@ModifiedByAppUserIDValue AS NVARCHAR) 
									   FROM [migration].[NewPostParticipants] npp
									  WHERE npp.[NewPostParticipantID] = @NewPostParticipantID);

					INSERT INTO [persons].[Persons]
						   ([FirstMiddleNames],
							[LastNames],
							[Gender], 
							[IsUSCitizen], 
							[NationalID], 
							[ResidenceLocationID], 
							[ContactEmail], 
							[ContactPhone], 
							[DOB], 
							[POBCityID], 
							[FatherName], 
							[MotherName], 
							[HighestEducationID], 
							[FamilyIncome], 
							[EnglishLanguageProficiencyID], 
							[PassportNumber], 
							[PassportExpirationDate], 
							[PassportIssuingCountryID], 
							[MedicalClearanceStatus], 
							[MedicalClearanceDate], 
							[PsychologicalClearanceStatus], 
							[PsychologicalClearanceDate], 
							[ModifiedByAppUserID])
					SELECT npp.[FirstMiddleName], 
						   npp.[LastName], 
						   npp.[GenderFlag], 
						   npp.[USCitizenFlag], 
						   npp.[NationalID], 
						   npp.[ResidenceLocationID], 
						   npp.[ContactEmail], 
						   npp.[ContactPhone], 
						   npp.[DOB], 
						   npp.[POBCityID], 
						   NULL, 
						   NULL, 
						   npp.[HighestEducationID], 
						   NULL, 
						   npp.[EnglishLanguageProficiencyID], 
						   npp.[PassportNumber], 
						   npp.[PassportExpirationDate], 
						   NULL, 
						   NULL, 
						   NULL, 
						   NULL, 
						   NULL, 
						   @ModifiedByAppUserIDValue 
					  FROM [migration].[NewPostParticipants] npp
					 WHERE npp.[NewPostParticipantID] = @NewPostParticipantID;

					-- Get the newly [PersonID] value for the new created [Persons] table record.
					SET @PersonIdentity = SCOPE_IDENTITY();
				END
			ELSE
				-- One or more matching records were found.  Get the PersonID from the matched record.
				BEGIN
					IF @MatchingPersonsCnt = 1
						-- Get the PersonID value from the matching record.
						BEGIN
							SET @PersonIdentity = (SELECT PersonID FROM @ResultSet);
						END
					ELSE
						-- More than one match was found.  Get the first one that was created.						
						BEGIN
							SET @PersonIdentity = (SELECT TOP(1) PersonID FROM @ResultSet ORDER BY PersonID);
						END;
				END;

		-- Update the [NewPostParticipants] record with the new [PersonID] value
		-- & set the import status of the record to "Imported".
		UPDATE [migration].[NewPostParticipants]
			SET [PersonID] = @PersonIdentity, 
				[PersonExists] = 0,  
				[ImportStatus] = 'Imported', 
				[ModifiedDate] = getutcdate(), 
				[ModifiedByAppUserID] = @ModifiedByAppUserIDValue 
			WHERE [NewPostParticipantID] = @NewPostParticipantID;

		END TRY
		BEGIN CATCH
			PRINT 'An error occurred while trying to insert a new record into the [Persons] table.';
			PRINT 'Refer to the following Data Dump to see what was trying to be inserted.';
			PRINT @DataDump;
			SELECT @NewPostParticipantIDString = CAST(@NewPostParticipantID AS VARCHAR)
			RAISERROR (N'INSERT into [Persons] table failed at row %s', 16, 1, @NewPostParticipantIDString)
		END CATCH;		

		-- Test if a new Person was created or already exists.  
		IF @PersonIdentity IS NOT NULL

            -- If a new Person was created, create related records in the [TrainingEventParticipants] & [PersonsUnitLibraryInfo] tables.
			BEGIN 
                -- Create a new [TrainingEventParticipants] record to associate the newly created [Persons]
                -- record with a specific [TrainingEvents] record in the [TrainingEventParticipants] table.

				-- Get the current [TrainingEventID] value from the [NewPostTrainingEvents] table to
                -- associate the newly created Person with via the [TrainingEventParticipants] table.
				SET @TrainingEventID = (SELECT TrainingEventID FROM [migration].NewPostTrainingEvents WHERE NewPostImportID = @NewPostImportID)
			
				BEGIN TRY

					-- Capture incoming data into a dump string, in case process errors out.
					SET @DataDump = (SELECT 'npp.[NewPostParticipantID] = ' + CAST(@NewPostParticipantID AS NVARCHAR) +
											'[PersonID] = ' + CAST(@PersonIdentity AS NVARCHAR) + 
											'[TrainingEventID] = ' + CAST(@TrainingEventID AS NVARCHAR) + 		
											'[IsVIP] = 0' +  				
											'[IsParticipant] = ' + CAST(ISNULL(npp.[ParticipantFlag], 1) AS NVARCHAR) + 		
											'[IsTraveling] = 0' + 
											'[DepartureCityID] = ' + CAST(npp.[DepartureCityID] AS NVARCHAR) + 
											'[DepartureDate] = NULL' +  
											'[ReturnDate] = NULL' + 
											'[HasLocalGovTrust] = ' + CAST(ISNULL(npp.[HasLocalGovTrustFlag], 0) AS NVARCHAR) + 
											'[PassedLocalGovTrust] = ' + CAST(npp.[PassedLocalGovTrustFlag] AS NVARCHAR) + 
											'[LocalGovTrustCertDate] = ' + CAST(npp.[LocalGovTrustCertDate] AS NVARCHAR) + 
											'[OtherVetting] = ' + CAST(ISNULL(npp.[OtherVettingFlag], 0) AS NVARCHAR) + 
											'[PassedOtherVetting] = ' + CAST(npp.[PassedOtherVettingFlag] AS NVARCHAR) + 
											'[OtherVettingDescription] = ' + CAST(npp.[ExternalVettingDescription] AS NVARCHAR) + 
											'[OtherVettingDate] = ' + CAST(npp.[ExternalVettingDate] AS NVARCHAR) + 
											'[VisaStatusID] = NULL' + 
											'[PaperworkStatusID] = NULL' + 
											'[TravelDocumentStatusID] = NULL' + 
											'[RemovedFromEvent] = 0' + 
											'[Comments] = ' + CAST(npp.[Comments] AS NVARCHAR) + 
											'[ModifiedByAppUserID] = ' + CAST(@ModifiedByAppUserIDValue AS NVARCHAR) 
									   FROM [migration].NewPostParticipants npp
									  WHERE npp.[NewPostParticipantID] = @NewPostParticipantID);

					-- Create the new [TrainingEventParticipants] record.
					INSERT INTO [training].[TrainingEventParticipants]
					       ([PersonID],					-- REQUIRED
                            [TrainingEventID],			-- REQUIRED
							[TrainingEventParticipantTypeID],			-- REQUIRED
                            [IsVIP],					-- REQUIRED
                            [IsParticipant],			-- REQUIRED
                            [IsTraveling],				-- REQUIRED
                            [DepartureCityID], 
							[DepartureDate], 
							[ReturnDate], 
							[HasLocalGovTrust],			-- REQUIRED (Were they vetted by host nation?)
							[PassedLocalGovTrust],		-- Did they pass host nation vetting?
							[LocalGovTrustCertDate],	
							[OtherVetting],				-- REQUIRED (Were they vetted by an external process?)
							[PassedOtherVetting],		-- Did they pass external vetting process?
							[OtherVettingDescription], 
							[OtherVettingDate], 
							[VisaStatusID], 
							[PaperworkStatusID], 
							[TravelDocumentStatusID],
							[RemovedFromEvent],			-- REQUIRED
                            [Comments],
						    [ModifiedByAppUserID])		-- REQUIRED
					SELECT @PersonIdentity,							-- REQUIRED
                           @TrainingEventID,						-- REQUIRED
						   1,										-- REQUIRED
						   0,										-- REQUIRED
                           ISNULL(npp.[ParticipantFlag], 1),		-- REQUIRED
                           0,										-- REQUIRED
                           npp.[DepartureCityID], 
                           NULL, 
						   NULL, 
                           ISNULL(npp.[HasLocalGovTrustFlag], 0),	-- REQUIRED
						   npp.[PassedLocalGovTrustFlag], 
						   npp.[LocalGovTrustCertDate], 
						   ISNULL(npp.[OtherVettingFlag], 0),		-- REQUIRED 
						   npp.[PassedOtherVettingFlag],
						   npp.[ExternalVettingDescription],
						   npp.[ExternalVettingDate],
						   NULL, 
						   NULL, 
						   NULL,
						   0,										-- REQUIRED
                           npp.[Comments],
						   @ModifiedByAppUserIDValue				-- REQUIRED
					  FROM [migration].NewPostParticipants npp
					 WHERE npp.[NewPostParticipantID] = @NewPostParticipantID
					   AND @TrainingEventID IS NOT NULL;				-- Required data value to create a [TrainingEventParticipants] record

				END TRY
				BEGIN CATCH
					PRINT 'An error occurred while trying to insert a new record into the [TrainingEventParticipants] table.';
					PRINT 'Refer to the following Data Dump to see what was trying to be inserted.';
					PRINT @DataDump;

					SELECT @NewPostParticipantIDString = CAST(@NewPostParticipantID AS VARCHAR)
					PRINT 'Trying to add record to [TrainingEventParticipants] table';
					PRINT '@NewPostParticipantID = ' + CAST(@NewPostParticipantID AS VARCHAR);
					PRINT '@PersonIdentity = ' + CAST(@PersonIdentity AS VARCHAR);
					PRINT '@TrainingEventID = ' + CAST(@TrainingEventID AS VARCHAR);
					SELECT ERROR_MESSAGE() AS ErrorMessage;	
					RAISERROR (N'INSERT into [TrainingEventParticipants] table failed at row %s', 16, 1, @NewPostParticipantIDString)
				END CATCH
			
				-- Update the [NewPostParticipants] record with the new [TrainingEventID] value.
				UPDATE [migration].[NewPostParticipants]
				   SET [TrainingEventID] = @TrainingEventID, 
					   [ModifiedDate] = getutcdate(), 
					   [ModifiedByAppUserID] = @ModifiedByAppUserIDValue 
				 WHERE [NewPostParticipantID] = @NewPostParticipantID;			

                -- Create a new [PersonsUnitLibraryInfo] record to associate the newly created [Persons] 
                -- record with a specific Unit in the Unit Library only if a valid UnitID exists in the 
                -- [NewPostParticipants] table record.
				BEGIN TRY
				
					-- Create the new [PersonsUnitLibraryInfo] record.
					INSERT INTO [persons].[PersonsUnitLibraryInfo]
                           ([PersonID],					-- REQUIRED
                            [UnitID],					-- REQUIRED
                            [JobTitle], 
                            [YearsInPosition], 
                            [WorkEmailAddress], 
                            [RankID], 
                            [IsUnitCommander], 
                            [PoliceMilSecID], 
					        [IsVettingReq],				-- REQUIRED
                            [IsLeahyVettingReq],		-- REQUIRED
                            [IsArmedForces],			-- REQUIRED
                            [IsLawEnforcement],			-- REQUIRED
                            [IsSecurityIntelligence],	-- REQUIRED
                            [HostNationPOCName], 
					        [HostNationPOCEmail], 
                            [IsValidated],				-- REQUIRED
                            [IsActive],					-- REQUIRED
                            [ModifiedByAppUserID])		-- REQUIRED
					SELECT @PersonIdentity,						-- REQUIRED
                           npp.[UnitID],						-- REQUIRED
                           npp.[JobTitle], 
                           npp.[YearsInPosition], 
                           NULL, 
                           npp.[RankID], 
                           npp.[UnitCommanderFlag], 
                           npp.[PoliceMilSecID], 
					       ISNULL(npp.[IsVettingRequired], 0),	-- REQUIRED
                           ISNULL(npp.[IsLeahyVettingReq], 0),	-- REQUIRED
                           0,									-- REQUIRED
                           0,									-- REQUIRED
                           0,									-- REQUIRED
                           npp.[POCName], 
					       npp.[POCEmailAddress], 
                           0,									-- REQUIRED
                           1,									-- REQUIRED
                           @ModifiedByAppUserIDValue			-- REQUIRED
					  FROM [migration].[NewPostParticipants] npp
				     WHERE npp.[NewPostParticipantID] = @NewPostParticipantID
					   AND npp.[UnitID] IS NOT NULL;					-- Required data value to create a [PersonsUnitLibraryInfo] record
					   -- Commented out to allow NULL values in npp.[IsVettingRequired] & npp.[IsLeahyVettingReq] 
					   -- to not be a blocker from creating a [PersonsUnitLibraryInfo] record.  If this is good, then 
					   -- this commented code can be removed down the road. (MarkS 06/28/2019)
					   --AND npp.[IsVettingRequired] IS NOT NULL		-- Required data value to create a [PersonsUnitLibraryInfo] record
					   --AND npp.[IsLeahyVettingReq] IS NOT NULL;		-- Required data value to create a [PersonsUnitLibraryInfo] record

				END TRY
				BEGIN CATCH
					SELECT @NewPostParticipantIDString = CAST(@NewPostParticipantID AS VARCHAR)
					PRINT 'Trying to add record to [PersonsUnitLibraryInfo] table';
					SELECT ERROR_MESSAGE() AS ErrorMessage;	
					RAISERROR (N'INSERT into [PersonsUnitLibraryInfo] table failed at row %s', 16, 1, @NewPostParticipantIDString)
				END CATCH
			END;

		FETCH NEXT FROM ParticipantCursor INTO @NewPostParticipantID
		END
	
	CLOSE ParticipantCursor;
	DEALLOCATE ParticipantCursor;

	-- Update counters.
	SET @Imported = (SELECT COUNT(*)
						FROM [migration].[NewPostParticipants] npp
						WHERE npp.[NewPostImportID] = @NewPostImportID
						AND npp.[ImportStatus] = 'Imported');
	SET @NotImported = @Submitted - @Imported;

	-- Update [NewPostImportLog] table with record statistics.
	BEGIN TRANSACTION     
		UPDATE [migration].[NewPostImportLog]
			SET [ParticipantsImportedCount] = @Imported,
				[ParticipantsNotImportedCount] = @NotImported,
				[ModifiedByAppUserID] = @ModifiedByAppUserIDValue,
				[ModifiedDate] = getutcdate()
		WHERE [NewPostImportID] = @NewPostImportID;
	COMMIT;
   
END