/*
    NAME:   DeleteAllNULLRecordsFromImportTables
    
    DESCR:  This Stored Procedure will delete all records in the [Import...] tables where the
            entire row is ALL NULL values.
*/
CREATE PROCEDURE [migration].[DeleteAllNULLRecordsFromImportTables]
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        -- Delete rows where ALL columns are NULL in the [ImportTrainingEventHorizontal] table.
        BEGIN TRANSACTION
            DELETE
            FROM [migration].[ImportTrainingEventHorizontal]
            WHERE (LEN(ISNULL([OfficeOrSection],'')) = 0) AND (LEN(ISNULL([OrganizerNames],'')) = 0) 
              AND (LEN(ISNULL([Name],'')) = 0) AND (LEN(ISNULL([NameInLocalLang],'')) = 0) 
              AND (LEN(ISNULL([EventType],'')) = 0) AND (LEN(ISNULL([KeyActivities],'')) = 0) 
              AND (LEN(ISNULL([FundingSources],'')) = 0) AND (LEN(ISNULL([AuthorizingDocuments],'')) = 0) 
              AND (LEN(ISNULL([ImplementingPartners],'')) = 0) AND (LEN(ISNULL([Objectives],'')) = 0) 
              AND (LEN(ISNULL([ParticipantProfile],'')) = 0) AND (LEN(ISNULL([Justification],'')) = 0) 
              AND (LEN(ISNULL([EstimatedBudget],'')) = 0) AND (LEN(ISNULL([ActualBudget],'')) = 0) 
              AND (LEN(ISNULL([HostNationParticipants],'')) = 0) AND (LEN(ISNULL([MissionDirectHires],'')) = 0) 
              AND (LEN(ISNULL([NonMissionDirectHires],'')) = 0) AND (LEN(ISNULL([MissionOutsourcedHires],'')) = 0) 
              AND (LEN(ISNULL([NonUSGInstructors],'')) = 0) AND (LEN(ISNULL([Comments],'')) = 0) 
        COMMIT;

        -- Delete rows where ALL columns are NULL in the [ImportLocations] table.
        BEGIN TRANSACTION
            DELETE
            FROM [migration].[ImportLocations]
            WHERE (LEN(ISNULL([EventCity],'')) = 0) 
              AND (LEN(ISNULL([EventState],'')) = 0)
              AND (LEN(ISNULL([EventCountry],'')) = 0)
              AND (LEN(ISNULL(CONVERT(VARCHAR, [EventStartDate], 101),'')) = 0)
              AND (LEN(ISNULL(CONVERT(VARCHAR, [EventEndDate], 101),'')) = 0)
              AND (LEN(ISNULL(CONVERT(VARCHAR, [TravelStartDate], 101),'')) = 0)
              AND (LEN(ISNULL(CONVERT(VARCHAR, [TravelEndDate], 101),'')) = 0)
        COMMIT;

        -- Delete rows where ALL columns are NULL in the [ImportParticipants] table OR the row is a header/non-data row.
        BEGIN TRANSACTION
            DELETE
            FROM [migration].[ImportParticipants]
            WHERE ((LEN(ISNULL([ParticipantStatus],'')) = 0) 
                   AND (LEN(ISNULL([FirstMiddleName],'')) = 0) AND (LEN(ISNULL([LastName],'')) = 0)  
                   AND (LEN(ISNULL([NationalID],'')) = 0) AND (LEN(ISNULL([Gender],'')) = 0) 
                   AND (LEN(ISNULL([IsUSCitizen],'')) = 0) AND (LEN(ISNULL([DOB],'')) = 0) 
                   AND (LEN(ISNULL([POBCity],'')) = 0) AND (LEN(ISNULL([POBState],'')) = 0) 
                   AND (LEN(ISNULL([POBCountry],'')) = 0) AND (LEN(ISNULL([ResidenceCity],'')) = 0) 
                   AND (LEN(ISNULL([ResidenceState],'')) = 0) AND (LEN(ISNULL([ResidenceCountry],'')) = 0)
                   AND (LEN(ISNULL([ContactEmail],'')) = 0) AND (LEN(ISNULL([ContactPhone],'')) = 0) 
                   AND (LEN(ISNULL([HighestEducation],'')) = 0) AND (LEN(ISNULL([HighestEducation],'')) = 0) 
                   AND (LEN(ISNULL([EnglishLanguageProficiency],'')) = 0) AND (LEN(ISNULL([UnitGenID],'')) = 0) 
                   AND (LEN(ISNULL([UnitBreakdown],'')) = 0) AND (LEN(ISNULL([UnitAlias],'')) = 0) 
                   AND (LEN(ISNULL([JobTitle],'')) = 0) AND (LEN(ISNULL([Rank],'')) = 0) 
                   AND (LEN(ISNULL([UnitCommander],'')) = 0) AND (LEN(ISNULL([YearsInPosition],'')) = 0) 
                   AND (LEN(ISNULL([PoliceMilSecID],'')) = 0) AND (LEN(ISNULL([POCName],'')) = 0) 
                   AND (LEN(ISNULL([POCEmailAddress],'')) = 0) AND (LEN(ISNULL([VettingType],'')) = 0) 
                   AND (LEN(ISNULL([HasLocalGovTrust],'')) = 0) AND (LEN(ISNULL([LocalGovTrustCertDate],'')) = 0)
                   AND (LEN(ISNULL([PassedExternalVetting],'')) = 0) AND (LEN(ISNULL([ExternalVettingDescription],'')) = 0) 
                   AND (LEN(ISNULL([ExternalVettingDate],'')) = 0) AND (LEN(ISNULL([DepartureCity],'')) = 0) 
                   AND (LEN(ISNULL([PassportNumber],'')) = 0) AND (LEN(ISNULL([PassportExpirationDate],'')) = 0) 
                   AND (LEN(ISNULL([Comments],'')) = 0))
			   OR UPPER(TRIM([FirstMiddleName])) = 'FIRST (GIVEN) / MIDDLE NAMES'
			   OR UPPER(TRIM([FirstMiddleName])) = 'ENTER THE PERSON''S FIRST (GIVEN) NAME AND ANY MIDDLE NAMES.'
			   OR UPPER(TRIM([FirstMiddleName])) = 'EXAMPLE: JOHN DAVID'
			   OR UPPER(TRIM(LEFT([Comments],10))) = 'XXXXXXXXXX'            
        COMMIT;

        -- Delete rows where ALL columns are NULL in the [ImportInstructors] table OR the row is a header/non-data row.
        BEGIN TRANSACTION
            DELETE
            FROM [migration].[ImportInstructors]
            WHERE ((LEN(ISNULL([FirstMiddleName],'')) = 0) AND (LEN(ISNULL([LastName],'')) = 0)  
                   AND (LEN(ISNULL([NationalID],'')) = 0) AND (LEN(ISNULL([Gender],'')) = 0) 
                   AND (LEN(ISNULL([IsUSCitizen],'')) = 0) AND (LEN(ISNULL([DOB],'')) = 0) 
                   AND (LEN(ISNULL([POBCity],'')) = 0) AND (LEN(ISNULL([POBState],'')) = 0) 
                   AND (LEN(ISNULL([POBCountry],'')) = 0) AND (LEN(ISNULL([ResidenceCity],'')) = 0) 
                   AND (LEN(ISNULL([ResidenceState],'')) = 0) AND (LEN(ISNULL([ResidenceCountry],'')) = 0)
                   AND (LEN(ISNULL([ContactEmail],'')) = 0) AND (LEN(ISNULL([ContactPhone],'')) = 0) 
                   AND (LEN(ISNULL([HighestEducation],'')) = 0) AND (LEN(ISNULL([HighestEducation],'')) = 0) 
                   AND (LEN(ISNULL([EnglishLanguageProficiency],'')) = 0) AND (LEN(ISNULL([UnitGenID],'')) = 0) 
                   AND (LEN(ISNULL([UnitBreakdown],'')) = 0) AND (LEN(ISNULL([UnitAlias],'')) = 0) 
                   AND (LEN(ISNULL([JobTitle],'')) = 0) AND (LEN(ISNULL([Rank],'')) = 0) 
                   AND (LEN(ISNULL([UnitCommander],'')) = 0) AND (LEN(ISNULL([YearsInPosition],'')) = 0) 
                   AND (LEN(ISNULL([PoliceMilSecID],'')) = 0) AND (LEN(ISNULL([POCName],'')) = 0) 
                   AND (LEN(ISNULL([POCEmailAddress],'')) = 0) AND (LEN(ISNULL([VettingType],'')) = 0) 
                   AND (LEN(ISNULL([HasLocalGovTrust],'')) = 0) AND (LEN(ISNULL([LocalGovTrustCertDate],'')) = 0)
                   AND (LEN(ISNULL([PassedExternalVetting],'')) = 0) AND (LEN(ISNULL([ExternalVettingDescription],'')) = 0) 
                   AND (LEN(ISNULL([ExternalVettingDate],'')) = 0) AND (LEN(ISNULL([DepartureCity],'')) = 0) 
                   AND (LEN(ISNULL([PassportNumber],'')) = 0) AND (LEN(ISNULL([PassportExpirationDate],'')) = 0) 
                   AND (LEN(ISNULL([Comments],'')) = 0))
			   OR UPPER(TRIM([FirstMiddleName])) = 'FIRST (GIVEN) / MIDDLE NAMES'
			   OR UPPER(TRIM([FirstMiddleName])) = 'ENTER THE PERSON''S FIRST (GIVEN) NAME AND ANY MIDDLE NAMES.'
			   OR UPPER(TRIM([FirstMiddleName])) = 'EXAMPLE: JOHN DAVID'
			   OR UPPER(TRIM(LEFT([Comments],10))) = 'XXXXXXXXXX'
        COMMIT;

    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
 END;