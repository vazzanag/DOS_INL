/*
    NAME:   SaveTrainingEventData
    
    DESCR:  This Stored Procedure will process the data in the [NewPostTrainingEvents] table
			and write those values to new Training Event related records in the GTTS primary
			data tables.  After the new [TrainingEvents] table record has been created the 
			new [TrainingEventID] value will be written back to the [NewPostTrainingEvents]
			record.	         
*/
CREATE PROCEDURE [migration].[SaveTrainingEventData]
    @NewPostImportID BIGINT = NULL	-- ID value that points to the [NewPostImportLog] record 
									-- for the template file that this Training Event was 
                                    -- submitted in.
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        -- Get CountryID & Post ID values from [NewPostImportLog] table.
        DECLARE @intCountryID AS INT = NULL;
        DECLARE @intPostID AS INT = NULL;
        SELECT @intCountryID = npil.CountryID,
               @intPostID = npil.PostID
        FROM migration.NewPostImportLog npil
        WHERE npil.NewPostImportID = @NewPostImportID;

        -- Define local variables used in this SP.
        DECLARE @intTrainingUnitIDValue AS BIGINT = NULL;        
        DECLARE @strOrganizerIDsValue AS NVARCHAR(300) = NULL;
        DECLARE @OrganizerAppUserIDValue AS INT = NULL;
        DECLARE @StakeholdersJSON AS NVARCHAR(MAX) = NULL;
        DECLARE @strNameValue AS NVARCHAR(255) = NULL;
        DECLARE @strNameInLocalLangValue AS NVARCHAR(255) = NULL;
        DECLARE @intEventTypeIDValue AS INT = NULL;
        DECLARE @strKeyActivityIDsValue AS NVARCHAR(300) = NULL;
        DECLARE @KeyActivitiesJSON AS NVARCHAR(MAX) = NULL;
        DECLARE @strFundingSourceIDsValue AS NVARCHAR(300) = NULL;
        DECLARE @FundingSourcesJSON AS NVARCHAR(MAX) = NULL;
        DECLARE @strAuthorizingDocIDsValue AS NVARCHAR(300) = NULL;
        DECLARE @AuthorizingDocsJSON AS NVARCHAR(MAX) = NULL;
        DECLARE @strImplementingPartnerIDsValue AS NVARCHAR(300) = NULL; 
        DECLARE @ImplementingPartnersJSON AS NVARCHAR(MAX) = NULL;
        DECLARE @strObjectivesValue AS NVARCHAR(MAX) = NULL;
        DECLARE @strParticipantProfileValue AS NVARCHAR(MAX) = NULL;
        DECLARE @strJustificationValue AS NVARCHAR(MAX) = NULL;
        DECLARE @decEstimatedBudgetValue AS DECIMAL(18,2) = NULL;
        DECLARE @decActualBudgetValue AS DECIMAL(18,2) = NULL;
        DECLARE @intHostNationParticipantsValue AS INT = NULL; 
        DECLARE @intMissionDirectHiresValue AS INT = NULL; 
        DECLARE @intNonMissionDirectHiresValue AS INT = NULL; 
        DECLARE @intMissionOutsourcedHiresValue AS INT = NULL;
        DECLARE @intNonUSGInstructorsValue AS INT = NULL; 
        DECLARE @strCommentsValue AS NVARCHAR(MAX) = NULL;
        DECLARE @intTrainingEventIDValue AS BIGINT = NULL;
        DECLARE @ModifiedByAppUserIDValue AS INT = 2; -- AppUserName = ONBOARDING 
        DECLARE @TrainingEventImportedCount AS TINYINT = 0;
        DECLARE @TrainingEventNotImportedCount AS TINYINT = 0;

        -- Get values from [NewPostTrainingEvents] table.
        SELECT @intTrainingUnitIDValue = npte.[TrainingUnitBusinessUnitID], 
            @strOrganizerIDsValue = npte.[OrganizerNameIDs],
            @strNameValue = npte.[Name],
            @strNameInLocalLangValue = npte.[NameInLocalLang], 
            @intEventTypeIDValue = npte.[TrainingEventTypeID],
            @strKeyActivityIDsValue = npte.[KeyActivityIDs],
            @strFundingSourceIDsValue = npte.[FundingSourceIDs],
            @strAuthorizingDocIDsValue = npte.[AuthorizingDocumentIDs],
            @strImplementingPartnerIDsValue = npte.[ImplementingPartnerIDs],
            @strObjectivesValue = npte.[Objectives],
            @strParticipantProfileValue = npte.[ParticipantProfile],
            @strJustificationValue = npte.[Justification],
            @decEstimatedBudgetValue = npte.[EstimatedBudget],
            @decActualBudgetValue = npte.[ActualBudget],
            @intHostNationParticipantsValue = npte.[HostNationParticipants],
            @intMissionDirectHiresValue = npte.[MissionDirectHires],
            @intNonMissionDirectHiresValue = npte.[NonMissionDirectHires],
            @intMissionOutsourcedHiresValue = npte.[MissionOutsourcedHires],
            @intNonUSGInstructorsValue = npte.[NonUSGInstructors],
            @strCommentsValue = npte.[Comments]
        FROM [migration].[NewPostTrainingEvents] npte
        WHERE npte.[NewPostImportID] = @NewPostImportID;

        -- Extract delimited Organizer Names & IDs to table variable.
        DECLARE @OrganizerNameIDsTbl AS TABLE
        (
            NameValue NVARCHAR(300), 
            IDValue INT
        );

        INSERT INTO @OrganizerNameIDsTbl
        (
            NameValue,
            IDValue
        )
        SELECT TRIM(LEFT(TRIM(a.[value]),CHARINDEX(',', a.value)-1)),
            NULLIF(TRIM(SUBSTRING(a.[value],CHARINDEX(',', a.value)+1,300)), 'NULL')
        FROM (SELECT value FROM string_split(@strOrganizerIDsValue,';')) AS a;

        -- Extract first row IDValue in the @OrganizerNameIDsTbl table variable to another
        -- variable that will be written to the Training Event record.  Then delete the row
        -- containing that value from the table variable.
        SET @OrganizerAppUserIDValue = (SELECT TOP 1 tblvar.[IDValue] FROM @OrganizerNameIDsTbl tblvar);
        DELETE tblvar
        FROM @OrganizerNameIDsTbl tblvar
        WHERE tblvar.[IDValue] = @OrganizerAppUserIDValue;

        -- Convert @OrganizerNameIDsTbl table variable to a JSON string.
        SET @StakeholdersJSON = (SELECT tblvar.[IDValue] AS AppUserID
                                FROM @OrganizerNameIDsTbl tblvar
                                WHERE tblvar.[IDValue] IS NOT NULL
                                    FOR JSON AUTO);

        -- Extract delimited Key Activity Names & IDs to table variable.
        DECLARE @KeyActivityIDsTbl AS TABLE
        (
            NameValue NVARCHAR(300), 
            IDValue INT
        );

        INSERT INTO @KeyActivityIDsTbl
        (
            NameValue,
            IDValue
        )
        SELECT TRIM(LEFT(TRIM(a.[value]),CHARINDEX(',', a.value)-1)),
            NULLIF(TRIM(SUBSTRING(a.[value],CHARINDEX(',', a.value)+1,300)), 'NULL')
        FROM (SELECT value FROM string_split(@strKeyActivityIDsValue,';')) AS a;

        -- Convert @KeyActivityIDsTbl table variable to a JSON string.
        SET @KeyActivitiesJSON = (SELECT tblvar.[IDValue] AS KeyActivityID
                                    FROM @KeyActivityIDsTbl tblvar
                                WHERE tblvar.[IDValue] IS NOT NULL
                                    FOR JSON AUTO);

        -- Extract delimited Funding Source Names & IDs to table variable.
        DECLARE @FundingSourceIDsTbl AS TABLE
        (
            NameValue NVARCHAR(300), 
            IDValue INT
        );

        INSERT INTO @FundingSourceIDsTbl
        (
            NameValue, 
            IDValue
        )
        SELECT TRIM(LEFT(TRIM(a.[value]),CHARINDEX(',', a.value)-1)),
            NULLIF(TRIM(SUBSTRING(a.[value],CHARINDEX(',', a.value)+1,300)), 'NULL')
        FROM (SELECT value FROM string_split(@strFundingSourceIDsValue,';')) AS a;

        -- Convert @FundingSourceIDsTbl table variable to a JSON string.
        SET @FundingSourcesJSON = (SELECT tblvar.[IDValue] AS ProjectCodeID
                                    FROM @FundingSourceIDsTbl tblvar
                                    WHERE tblvar.[IDValue] IS NOT NULL
                                    FOR JSON AUTO);

        -- Extract delimited Authorizing Document Names & IDs to table variable.
        DECLARE @AuthorizingDocIDsTbl AS TABLE
        (
            NameValue NVARCHAR(300), 
            IDValue INT
        );

        INSERT INTO @AuthorizingDocIDsTbl
        (
            NameValue,
            IDValue
        )
        SELECT TRIM(LEFT(TRIM(a.[value]),CHARINDEX(',', a.value)-1)),
            NULLIF(TRIM(SUBSTRING(a.[value],CHARINDEX(',', a.value)+1,300)), 'NULL')
        FROM (SELECT value FROM string_split(@strAuthorizingDocIDsValue,';')) AS a;

        -- Convert @AuthorizingDocIDsTbl table variable to a JSON string.
        SET @AuthorizingDocsJSON = (SELECT tblvar.[IDValue] AS AuthorizingDocID
                                    FROM @AuthorizingDocIDsTbl tblvar
                                    WHERE tblvar.[IDValue] IS NOT NULL
                                    FOR JSON AUTO);

        -- Extract delimited Implementing Partner Names & IDs to table variable.
        DECLARE @ImplementingPartnerIDsTbl AS TABLE
        (
            NameValue NVARCHAR(300), 
            IDValue INT
        );

        INSERT INTO @ImplementingPartnerIDsTbl
        (
            NameValue,
            IDValue
        )
        SELECT TRIM(LEFT(TRIM(a.[value]),CHARINDEX(',', a.value)-1)),
            NULLIF(TRIM(SUBSTRING(a.[value],CHARINDEX(',', a.value)+1,300)), 'NULL')
        FROM (SELECT value FROM string_split(@strImplementingPartnerIDsValue,';')) AS a;

        -- Convert @ImplementingPartnerIDsTbl table variable to a JSON string.
        SET @ImplementingPartnersJSON = (SELECT tblvar.[IDValue] AS ImplementingPartnerID
                                        FROM @ImplementingPartnerIDsTbl tblvar
                                        WHERE tblvar.[IDValue] IS NOT NULL
                                            FOR JSON AUTO);

        -- Write data to [TrainingEvents] table.
        BEGIN
            BEGIN TRY
                BEGIN TRANSACTION
                    PRINT 'INSERTING NEW TRAINING EVENT RECORD';

                    -- INSERT NEW RECORD
                    INSERT INTO [training].[TrainingEvents]
                    (
                        [Name], 
                        [NameInLocalLang], 
                        [TrainingEventTypeID], 
                        [Justification], 
                        [Objectives], 
                        [ParticipantProfile], 
                        [SpecialRequirements], 
                        [ProgramID], 
                        [TrainingUnitID], 
                        [CountryID], 
                        [PostID], 
                        [ConsularDistrictID], 
                        [OrganizerAppUserID], 
                        [PlannedParticipantCnt], 
                        [PlannedMissionDirectHireCnt], 
                        [PlannedNonMissionDirectHireCnt], 
                        [PlannedMissionOutsourceCnt], 
                        [PlannedOtherCnt], 
                        [EstimatedBudget], 
                        [ActualBudget], 
                        [EstimatedStudents], 
                        [FundingSourceID], 
                        [AuthorizingLawID], 
                        [Comments], 
                        [ModifiedByAppUserID]
                    )
                    VALUES 
                    (
                        @strNameValue, 
                        @strNameInLocalLangValue, 
                        @intEventTypeIDValue, 
                        @strJustificationValue, 
                        @strObjectivesValue, 
                        @strParticipantProfileValue, 
                        @strCommentsValue, 
                        NULL,						-- ProgramID (not used)
                        @intTrainingUnitIDValue, 
                        @intCountryID, 
                        @intPostID, 
                        NULL,						-- ConsularDistrictID
                        @OrganizerAppUserIDValue, 
                        @intHostNationParticipantsValue, 
                        @intMissionDirectHiresValue, 
                        @intNonMissionDirectHiresValue, 
                        @intMissionOutsourcedHiresValue, 
                        @intNonUSGInstructorsValue, 
                        @decEstimatedBudgetValue, 
                        @decActualBudgetValue, 
                        NULL,						-- EstimatedStudents (not used) 
                        NULL,						-- FundingSourceID (not used)
                        NULL,						-- AuthorizingLawID (not used)
                        NULL,						-- Comments (not used here) 
                        @ModifiedByAppUserIDValue	-- ModifiedByAppUserID
                    );

                COMMIT;
            END TRY
            BEGIN CATCH
                ROLLBACK;
                THROW;
            END CATCH
        END

        SET @intTrainingEventIDValue = SCOPE_IDENTITY();

        -- Insert new Create Status record into the [TrainingEventStatusLog] table.
        IF @intTrainingEventIDValue IS NOT NULL
            -- Training Event was added to the [TrainingEvents] table.  
            -- Increment @TrainingEventImportedCount to 1 and leave @TrainingEventNotImportedCount = 0.
            BEGIN
                EXEC training.InsertTrainingEventStatusLog @intTrainingEventIDValue, 'Created', null, @ModifiedByAppUserIDValue;
                SET @TrainingEventImportedCount = 1;
            END
        ELSE
            -- Training Event was NOT added to the [TrainingEvents] table.
            -- Increment @TrainingEventNotImportedCount to 1 and leave @TrainingEventImportedCount = 0.
            BEGIN
                SET @TrainingEventNotImportedCount = 1;
            END;

        -- Write data to [TrainingEventStakeholders] table.
        IF (@StakeholdersJSON IS NOT NULL AND @intTrainingEventIDValue IS NOT NULL)
            BEGIN
                BEGIN TRY
                    BEGIN TRANSACTION

                        DELETE FROM [training].[TrainingEventStakeholders]
                        WHERE [TrainingEventID] = @intTrainingEventIDValue
                        AND [AppUserID] NOT IN (SELECT json.[AppUserID] 
                                                FROM OPENJSON(@StakeholdersJSON) 
                                                WITH (AppUserID INT) json);

                        INSERT INTO [training].[TrainingEventStakeholders]
                        ([TrainingEventID], [AppUserID], [ModifiedByAppUserID])
                        SELECT @intTrainingEventIDValue, json.[AppUserID], @ModifiedByAppUserIDValue
                        FROM OPENJSON(@StakeholdersJSON) 
                        WITH (AppUserID INT) json
                        WHERE NOT EXISTS(SELECT [AppUserID] 
                                            FROM [training].[TrainingEventStakeholders] 
                                        WHERE [TrainingEventID] = @intTrainingEventIDValue
                                            AND [AppUserID] = json.[AppUserID]);

                    COMMIT;

                END TRY
                BEGIN CATCH
                    ROLLBACK;
                    THROW;
                END CATCH
            END

        -- Write data to [TrainingEventKeyActivities] table.
        IF (@KeyActivitiesJSON IS NOT NULL AND @intTrainingEventIDValue IS NOT NULL)
            BEGIN
                BEGIN TRY
                    BEGIN TRANSACTION

                        DELETE FROM [training].[TrainingEventKeyActivities]
                        WHERE [TrainingEventID] = @intTrainingEventIDValue
                        AND [KeyActivityID] NOT IN (SELECT json.[KeyActivityID] 
                                                    FROM OPENJSON(@KeyActivitiesJSON) 
                                                    WITH (KeyActivityID INT) json);

                        INSERT INTO [training].[TrainingEventKeyActivities]
                        ([TrainingEventID], [KeyActivityID], [ModifiedByAppUserID])
                        SELECT @intTrainingEventIDValue, json.[KeyActivityID], @ModifiedByAppUserIDValue
                        FROM OPENJSON(@KeyActivitiesJSON) 
                        WITH (KeyActivityID INT) JSON
                        WHERE NOT EXISTS(SELECT [KeyActivityID] 
                                            FROM [training].[TrainingEventKeyActivities] 
                                            WHERE [TrainingEventID] = @intTrainingEventIDValue 
                                            AND [KeyActivityID] = json.[KeyActivityID]);

                    COMMIT;

                END TRY
                BEGIN CATCH
                    ROLLBACK;
                    THROW;
                END CATCH
            END

        -- Write data to [TrainingEventProjectCodes] table.
        IF (@FundingSourcesJSON IS NOT NULL AND @intTrainingEventIDValue IS NOT NULL)
            BEGIN
                BEGIN TRY
                    BEGIN TRANSACTION

                        DELETE FROM [training].[TrainingEventProjectCodes] 
                        WHERE [TrainingEventID] = @intTrainingEventIDValue
                        AND [ProjectCodeID] NOT IN (SELECT json.[ProjectCodeID] 
                                                    FROM OPENJSON(@FundingSourcesJSON)
                                                    WITH (ProjectCodeID INT) json);

                        INSERT INTO [training].[TrainingEventProjectCodes] 
                        ([TrainingEventID], [ProjectCodeID], [ModifiedByAppUserID])
                        SELECT @intTrainingEventIDValue, json.[ProjectCodeID], @ModifiedByAppUserIDValue
                        FROM OPENJSON(@FundingSourcesJSON) 
                        WITH (ProjectCodeID INT) JSON
                        WHERE NOT EXISTS(SELECT [ProjectCodeID] 
                                            FROM [training].[TrainingEventProjectCodes] 
                                        WHERE [TrainingEventID] = @intTrainingEventIDValue 
                                            AND [ProjectCodeID] = json.[ProjectCodeID]);

                    COMMIT;

                END TRY
                BEGIN CATCH
                    ROLLBACK;
                    THROW;
                END CATCH
            END

        -- Write data to [TrainingEventAuthorizingDocuments] table.
        IF (@AuthorizingDocsJSON IS NOT NULL AND @intTrainingEventIDValue IS NOT NULL)
            BEGIN
                BEGIN TRY
                    BEGIN TRANSACTION

                        DELETE FROM [training].[TrainingEventAuthorizingDocuments]
                        WHERE [TrainingEventID] = @intTrainingEventIDValue
                        AND [InterAgencyAgreementID] NOT IN (SELECT json.[AuthorizingDocID] 
                                                    FROM OPENJSON(@AuthorizingDocsJSON) 
                                                    WITH (AuthorizingDocID INT) json);

                        INSERT INTO [training].[TrainingEventAuthorizingDocuments]
                        ([TrainingEventID], [InterAgencyAgreementID], [ModifiedByAppUserID])
                        SELECT @intTrainingEventIDValue, json.[AuthorizingDocID], @ModifiedByAppUserIDValue
                        FROM OPENJSON(@AuthorizingDocsJSON) 
                        WITH (AuthorizingDocID INT) JSON
                        WHERE NOT EXISTS(SELECT [InterAgencyAgreementID] 
                                            FROM [training].[TrainingEventAuthorizingDocuments] 
                                            WHERE [TrainingEventID] = @intTrainingEventIDValue 
                                            AND [InterAgencyAgreementID] = json.[AuthorizingDocID]);

                    COMMIT;

                END TRY
                BEGIN CATCH
                    ROLLBACK;
                    THROW;
                END CATCH
            END

        -- Write data to [TrainingEventUSPartnerAgencies] table.
        IF (@ImplementingPartnersJSON IS NOT NULL AND @intTrainingEventIDValue IS NOT NULL)
            BEGIN
                BEGIN TRY
                    BEGIN TRANSACTION

                    DELETE FROM [training].[TrainingEventUSPartnerAgencies] 
                    WHERE [TrainingEventID] = @intTrainingEventIDValue
                    AND [AgencyID] NOT IN (SELECT json.[ImplementingPartnerID] 
                                            FROM OPENJSON(@ImplementingPartnersJSON) 
                                            WITH (ImplementingPartnerID INT) json);

                    INSERT INTO [training].[TrainingEventUSPartnerAgencies]
                    ([TrainingEventID], [AgencyID], [ModifiedByAppUserID])
                    SELECT @intTrainingEventIDValue, json.[ImplementingPartnerID], @ModifiedByAppUserIDValue
                    FROM OPENJSON(@ImplementingPartnersJSON) 
                    WITH (ImplementingPartnerID INT) JSON
                    WHERE NOT EXISTS(SELECT AgencyID 
                                        FROM [training].[TrainingEventUSPartnerAgencies] 
                                    WHERE [TrainingEventID] = @intTrainingEventIDValue 
                                        AND [AgencyID] = json.[ImplementingPartnerID]);

                    COMMIT;

                END TRY
                BEGIN CATCH
                    ROLLBACK;
                    THROW;
                END CATCH
            END

        -- Update [NewPostTrainingEvents] record with new [TrainingEventID] value
        -- & set the import status of the record to "Imported".
        IF @intTrainingEventIDValue IS NOT NULL
            BEGIN
                BEGIN TRANSACTION     
                    UPDATE [migration].[NewPostTrainingEvents]
                    SET [TrainingEventID] = @intTrainingEventIDValue,
                        [ImportStatus] = 'Imported',
                        [ModifiedByAppUserID] = @ModifiedByAppUserIDValue,
                        [ModifiedDate] = getutcdate()
                    WHERE [NewPostImportID] = @NewPostImportID;
                COMMIT;
            END;

        -- Update [NewPostImportLog] table with record statistics.
        BEGIN TRANSACTION     
            UPDATE [migration].[NewPostImportLog]
                SET [TrainingEventImportedCount] = @TrainingEventImportedCount,
                    [TrainingEventNotImportedCount] = @TrainingEventNotImportedCount,
                    [ModifiedByAppUserID] = @ModifiedByAppUserIDValue,
                    [ModifiedDate] = getutcdate()
            WHERE [NewPostImportID] = @NewPostImportID;
        COMMIT;

    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
 END;