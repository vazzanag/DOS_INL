/*
    NAME:   CreateNewPostTrainingEventRecord
    
    DESCR:  This Stored Procedure receives 1 parameter and then inserts the 
            data from the [ImportTrainingEventHorizontal] table into a new 
            record in the [NewPostTrainingEvents] table.
*/
CREATE PROCEDURE [migration].[CreateNewPostTrainingEventRecord]
    @NewPostImportID BIGINT = NULL	-- ID value that points to the [NewPostImportLog] 
									-- record that this Run Control Log message refers to.
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION

            -- INSERT NEW RECORD
            INSERT INTO [migration].[NewPostTrainingEvents]
            (   [NewPostImportID],
                [OfficeOrSection],
                [OrganizerNames], 
                [Name], 
                [NameInLocalLang], 
                [EventType], 
                [KeyActivities], 
                [FundingSources], 
                [AuthorizingDocuments], 
                [ImplementingPartners], 
                [Objectives], 
                [ParticipantProfile], 
                [Justification], 
                [EstimatedBudget], 
                [ActualBudget], 
                [HostNationParticipants], 
                [MissionDirectHires], 
                [NonMissionDirectHires], 
                [MissionOutsourcedHires], 
                [NonUSGInstructors], 
                [Comments], 
                [ImportStatus],
                [ModifiedByAppUserID]
            )
            SELECT 
                imp.ImportID,			--   @NewPostImportID,
                imp.[OfficeOrSection],
                imp.[OrganizerNames], 
                imp.[Name], 
                imp.[NameInLocalLang], 
                imp.[EventType], 
                imp.[KeyActivities], 
                imp.[FundingSources], 
                imp.[AuthorizingDocuments], 
                imp.[ImplementingPartners], 
                imp.[Objectives], 
                imp.[ParticipantProfile], 
                imp.[Justification], 
                CAST(REPLACE(REPLACE(imp.[EstimatedBudget], '$',''), ',','')  AS decimal(18,0)),
                CAST(REPLACE(REPLACE(imp.[ActualBudget], '$',''), ',','')  AS decimal(18,0)),
                CAST(imp.[HostNationParticipants] AS int), 
                CAST(imp.[MissionDirectHires] AS int), 
                CAST(imp.[NonMissionDirectHires] AS int), 
                CAST(imp.[MissionOutsourcedHires] AS int), 
                CAST(imp.[NonUSGInstructors] AS int), 
                imp.[Comments], 
                'Uploaded',
                2
            FROM [migration].[ImportTrainingEventHorizontal] imp;

        -- NO ERRORS, COMMIT
        COMMIT;

    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
 END;