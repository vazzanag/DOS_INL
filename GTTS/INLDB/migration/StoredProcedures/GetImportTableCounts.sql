/*
    NAME:   GetImportTableCounts
    
    DESCR:  This Stored Procedure updates the [NewPostImportLog] record identified by the
            passed in parameter with the number of records submitted in the [Import...] 
            tables.
*/
CREATE PROCEDURE [migration].[GetImportTableCounts]
    @NewPostImportID BIGINT = NULL	-- ID value that points to the [NewPostImportLog]
									-- record to be updated.
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION

            -- Define local variables used in this SP.
            DECLARE @intTrainingEventCnt AS INT;
            DECLARE @intLocationsCnt AS INT;
            DECLARE @intParticpantsCnt AS INT;
            DECLARE @intInstructorsCnt AS INT;

            -- Get the record counts from the import tables.
            SET @intTrainingEventCnt = (SELECT COUNT(*)
                                        FROM [migration].[ImportTrainingEventHorizontal]);
            SET @intLocationsCnt = (SELECT COUNT(*)
                                        FROM [migration].[ImportLocations]);
            SET @intParticpantsCnt = (SELECT COUNT(*)
                                        FROM [migration].[ImportParticipants]);
            SET @intInstructorsCnt = (SELECT COUNT(*)
                                        FROM [migration].[ImportInstructors]);            

            -- Update the [NewPostImportLog] table with the [Import...] table record counts.
            UPDATE [migration].[NewPostImportLog]
            SET [HasTrainingEvent] = IIF(@intTrainingEventCnt > 0, 1, 0),
                [TrainingEventSubmittedCount] = @intTrainingEventCnt,
                [HasLocations] = IIF(@intLocationsCnt > 0, 1, 0),
                [LocationsSubmittedCount] = @intLocationsCnt,
                [HasParticipants] = IIF(@intParticpantsCnt > 0, 1, 0),
                [ParticipantsSubmittedCount] = @intParticpantsCnt,
                [HasInstructors] = IIF(@intInstructorsCnt > 0, 1, 0), 
                [InstructorsSubmittedCount] = @intInstructorsCnt
            WHERE [NewPostImportID] = @NewPostImportID;

        -- NO ERRORS, COMMIT
        COMMIT;

    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
 END;