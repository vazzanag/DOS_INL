/*
    NAME:   SaveTrainingEventInstructorsData
    
    DESCR:  This Stored Procedure will process the data in the [NewPostInstructors] table
			and write those values to new Persons related records in the GTTS primary
			data tables.  After the new [Persons] table record has been created the 
			new [PersonID] value will be written back to the [NewPostInstructors] record.	         
*/
CREATE PROCEDURE [migration].[SaveTrainingEventInstructorsData]
	@NewPostImportID BIGINT
AS
BEGIN

	-- Define local variables unsed in this SP.
	DECLARE @NewPostInstructorID AS INT = NULL;
	DECLARE @NewPostInstructorIDString AS VARCHAR(12) = NULL;
	DECLARE @PersonIdentity AS BIGINT = NULL;
	DECLARE @MatchingPersonsCnt AS BIGINT = NULL;
	DECLARE @TrainingEventID AS BIGINT = NULL;
    DECLARE @Submitted AS INT = NULL; 
    DECLARE @Imported AS INT = NULL; 
    DECLARE @NotImported AS INT = NULL; 
	DECLARE @ModifiedByAppUserIDValue AS INT = 2; -- AppUserName = ONBOARDING 
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
	DECLARE InstructorCursor CURSOR 
		LOCAL STATIC READ_ONLY FORWARD_ONLY
	FOR 
		-- Cursor should only be set for those rows that match the current NewPostImportID (passed 
		-- into this SP), have an Import Status = 'Uploaded' meaning ready for import, and that are 
		-- not missing any required data elements that must be populated in order to create a [Persons],
		-- [TrainingEventInstructors], or [PersonsUnitLibraryInfo] record.
		SELECT DISTINCT npi.[NewPostInstructorID] 
		  FROM [migration].[NewPostInstructors] npi
		 WHERE npi.[ImportStatus] = 'Uploaded' 
		   AND npi.[NewPostImportID] = @NewPostImportID
		   AND npi.[FirstMiddleName] IS NOT NULL		-- Required data value to create a [Persons] record
		   AND npi.[GenderFlag] IS NOT NULL				-- Required data value to create a [Persons] record
		   AND npi.[USCitizenFlag] IS NOT NULL;			-- Required data value to create a [Persons] record

    -- Initialize Submitted, Imported, Not Imported counters.
    SET @Submitted = (SELECT npil.[InstructorsSubmittedCount]
		                FROM [migration].[NewPostImportLog] npil
		               WHERE npil.[NewPostImportID] = @NewPostImportID);
    SET @Imported = 0;
    SET @NotImported = 0;	

	-- Open cursor & begin processing rows identified by the cursor.	
	OPEN InstructorCursor
	FETCH NEXT FROM InstructorCursor INTO @NewPostInstructorID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		BEGIN TRY

			-- Initialize @PersonIdentity to NULL before each INSERT so that we
			-- test that a [Persons] record was created.
			SET @PersonIdentity = NULL;

			-- Assign [NewPostInstructor] values to variables to pass into the [persons].[GetMatchingPersons] SP.
			SELECT @FirstMiddleNamesValue = npi.[FirstMiddleName], 
				   @LastNamesValue = npi.[LastName], 
			  	   @DOBValue = npi.[DOB],
				   @POBCityIDValue = npi.[POBCityID],
				   @GenderValue = npi.[GenderFlag], 
				   @NationalIDValue = npi.[NationalID]						   
			  FROM [migration].[NewPostInstructors] npi
			 WHERE npi.[NewPostInstructorID] = @NewPostInstructorID;

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
					SELECT npi.[FirstMiddleName], 
						   npi.[LastName], 
						   npi.[GenderFlag], 
						   npi.[USCitizenFlag], 
						   npi.[NationalID], 
						   npi.[ResidenceLocationID], 
						   npi.[ContactEmail], 
						   npi.[ContactPhone], 
						   npi.[DOB], 
						   npi.[POBCityID], 
						   NULL, 
						   NULL, 
						   npi.[HighestEducationID], 
						   NULL, 
						   npi.[EnglishLanguageProficiencyID], 
						   npi.[PassportNumber], 
						   npi.[PassportExpirationDate], 
						   NULL, 
						   NULL, 
						   NULL, 
						   NULL, 
						   NULL, 
						   @ModifiedByAppUserIDValue 
					  FROM [migration].[NewPostInstructors] npi
					 WHERE npi.[NewPostInstructorID] = @NewPostInstructorID;

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

		-- Update the [NewPostInstructors] record with the new [PersonID] value
		-- & set the import status of the record to "Imported".
		UPDATE [migration].[NewPostInstructors]
			SET [PersonID] = @PersonIdentity, 
				[PersonExists] = 0,  
				[ImportStatus] = 'Imported', 
				[ModifiedDate] = GETUTCDATE(), 
				[ModifiedByAppUserID] = @ModifiedByAppUserIDValue 
			WHERE [NewPostInstructorID] = @NewPostInstructorID;

		END TRY
		BEGIN CATCH
			SELECT @NewPostInstructorIDString = CAST(@NewPostInstructorID AS VARCHAR)
			RAISERROR (N'INSERT into [Persons] table failed at row %s', 16, 1, @NewPostInstructorIDString)
		END CATCH;

		-- Test if a new Person was created or already exists.  
		IF @PersonIdentity IS NOT NULL

            -- If a new Person was created, create related records in the [TrainingEventInstructors] & [PersonsUnitLibraryInfo] tables.
			BEGIN 
                -- Create a new [TrainingEventInstructors] record to associate the newly created [Persons]
                -- record with a specific [TrainingEvents] record in the [TrainingEventInstructors] table.

				-- Get the current [TrainingEventID] value from the [NewPostTrainingEvents] table to
                -- associate the newly created Person with via the [TrainingEventInstructors] table.
				SET @TrainingEventID = (SELECT TrainingEventID FROM [migration].NewPostTrainingEvents WHERE NewPostImportID = @NewPostImportID)
			
				BEGIN TRY

					-- Create the new [TrainingEventInstructors] record.
					INSERT INTO [training].[TrainingEventParticipants]
					       ([PersonID],					-- REQUIRED
                            [TrainingEventID],			-- REQUIRED
							[TrainingEventParticipantTypeID],			-- REQUIRED
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
						   2,
                           0,										-- REQUIRED
                           npi.[DepartureCityID], 
                           NULL, 
						   NULL, 
                           ISNULL(npi.[HasLocalGovTrustFlag], 0),	-- REQUIRED
						   npi.[PassedLocalGovTrustFlag], 
						   npi.[LocalGovTrustCertDate], 
						   ISNULL(npi.[OtherVettingFlag], 0),		-- REQUIRED 
						   npi.[PassedOtherVettingFlag],
						   npi.[ExternalVettingDescription],
						   npi.[ExternalVettingDate],
						   NULL, 
						   NULL, 
						   NULL,
						   0,										-- REQUIRED
                           npi.[Comments],                           
						   @ModifiedByAppUserIDValue				-- REQUIRED
					  FROM [migration].NewPostInstructors npi
					 WHERE npi.[NewPostInstructorID] = @NewPostInstructorID
					   -- Commented out to allow NULL values in npi.[HasLocalGovTrustFlag] & npi.[OtherVettingFlag] 
					   -- to not be a blocker from creating a [TrainingEventInstructors] record.  If this is good, then 
					   -- this commented code can be removed down the road. (MarkS 06/28/2019)
					   --AND npi.[HasLocalGovTrustFlag] IS NOT NULL		-- Required data value to create a [TrainingEventInstructors] record
					   --AND npi.[PassedOtherVettingFlag] IS NOT NULL	-- Required data value to create a [TrainingEventInstructors] record
					   AND @TrainingEventID IS NOT NULL;				-- Required data value to create a [TrainingEventInstructors] record

				END TRY
				BEGIN CATCH
					SELECT @NewPostInstructorIDString = CAST(@NewPostInstructorID AS VARCHAR)	
					PRINT 'Trying to add record to [TrainingEventInstructors] table';
					PRINT '@NewPostParticipantID = ' + CAST(@NewPostInstructorID AS VARCHAR);
					PRINT '@PersonIdentity = ' + CAST(@PersonIdentity AS VARCHAR);
					PRINT '@TrainingEventID = ' + CAST(@TrainingEventID AS VARCHAR);
					SELECT ERROR_MESSAGE() AS ErrorMessage;	
					RAISERROR (N'INSERT into [TrainingEventInstructors] table failed at row %s', 16, 1, @NewPostInstructorIDString)
				END CATCH
			
				-- Update the [NewPostInstructors] record with the new [TrainingEventID] value.
				UPDATE [migration].[NewPostInstructors]
				   SET [TrainingEventID] = @TrainingEventID, 
					   [ModifiedDate] = getutcdate(), 
					   [ModifiedByAppUserID] = @ModifiedByAppUserIDValue 
				 WHERE [NewPostInstructorID] = @NewPostInstructorID;			

                -- Create a new [PersonsUnitLibraryInfo] record to associate the newly created [Persons] 
                -- record with a specific Unit in the Unit Library only if a valid UnitID exists in the 
                -- [NewPostInstructors] table record.
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
                           npi.[UnitID],						-- REQUIRED
                           npi.[JobTitle], 
                           npi.[YearsInPosition], 
                           NULL, 
                           npi.[RankID], 
                           npi.[UnitCommanderFlag], 
                           npi.[PoliceMilSecID], 
					       ISNULL(npi.[IsVettingRequired], 0),	-- REQUIRED
                           ISNULL(npi.[IsLeahyVettingReq], 0),	-- REQUIRED
                           0,									-- REQUIRED
                           0,									-- REQUIRED
                           0,									-- REQUIRED
                           npi.[POCName], 
					       npi.[POCEmailAddress], 
                           0,									-- REQUIRED
                           1,									-- REQUIRED
                           @ModifiedByAppUserIDValue			-- REQUIRED
					  FROM [migration].[NewPostInstructors] npi
				     WHERE npi.[NewPostInstructorID] = @NewPostInstructorID
					   AND npi.[UnitID] IS NOT NULL;					-- Required data value to create a [PersonsUnitLibraryInfo] record
					   -- Commented out to allow NULL values in npi.[IsVettingRequired] & npi.[IsLeahyVettingReq] 
					   -- to not be a blocker from creating a [PersonsUnitLibraryInfo] record.  If this is good, then 
					   -- this commented code can be removed down the road. (MarkS 06/28/2019)
					   --AND npi.[IsVettingRequired] IS NOT NULL		-- Required data value to create a [PersonsUnitLibraryInfo] record
					   --AND npi.[IsLeahyVettingReq] IS NOT NULL;		-- Required data value to create a [PersonsUnitLibraryInfo] record

				END TRY
				BEGIN CATCH
					SELECT @NewPostInstructorIDString = CAST(@NewPostInstructorID AS VARCHAR)
					PRINT 'Trying to add record to [PersonsUnitLibraryInfo] table';
					SELECT ERROR_MESSAGE() AS ErrorMessage;	
					RAISERROR (N'INSERT into [PersonsUnitLibraryInfo] table failed at row %s', 16, 1, @NewPostInstructorIDString)
				END CATCH
			END;

		FETCH NEXT FROM InstructorCursor INTO @NewPostInstructorID
		END
	
	CLOSE InstructorCursor;
	DEALLOCATE InstructorCursor;

	-- Update counters.
	SET @Imported = (SELECT COUNT(*)
						FROM [migration].[NewPostInstructors] npi
						WHERE npi.[NewPostImportID] = @NewPostImportID
						AND npi.[ImportStatus] = 'Imported');
	SET @NotImported = @Submitted - @Imported;

	-- Update [NewPostImportLog] table with record statistics.
	BEGIN TRANSACTION     
		UPDATE [migration].[NewPostImportLog]
			SET [InstructorsImportedCount] = @Imported,
				[InstructorsNotImportedCount] = @NotImported,
				[ModifiedByAppUserID] = @ModifiedByAppUserIDValue,
				[ModifiedDate] = getutcdate()
		WHERE [NewPostImportID] = @NewPostImportID;
	COMMIT;
   
END