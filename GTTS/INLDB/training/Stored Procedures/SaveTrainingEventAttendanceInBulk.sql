CREATE PROCEDURE [training].[SaveTrainingEventAttendanceInBulk]
    @TrainingEventRosterID BIGINT,
    @ModifiedByAppUserID INT, 
    @AttendanceJSON NVARCHAR(MAX)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION

        SET NOCOUNT ON;

        -- CHECK IF ASSOCIATED TrainingEventRosters EXISTS
        IF NOT EXISTS(SELECT * FROM training.TrainingEventRosters WHERE TrainingEventRosterID = @TrainingEventRosterID)
            THROW 50000,  'The associated training event roster does not exist.',  1

        -- 1. DELETE ATTENDANCE
        DELETE FROM training.TrainingEventAttendance
         WHERE TrainingEventRosterID = @TrainingEventRosterID
           AND AttendanceDate NOT IN (SELECT json.AttendanceDate from OPENJSON(@AttendanceJSON) WITH (AttendanceDate DATETIME) json);

        -- 2. UPDATE ATTENDANCE
        UPDATE training.TrainingEventAttendance SET
               AttendanceIndicator = j.AttendanceIndicator,
               ModifiedByAppUserID = @ModifiedByAppUserID,
               ModifiedDate = GETUTCDATE()
          FROM training.TrainingEventAttendance a
    INNER JOIN OPENJSON(@AttendanceJSON) WITH (TrainingEventRosterID BIGINT, AttendanceDate DATETIME, AttendanceIndicator BIT) 
                    j ON a.TrainingEventRosterID = j.TrainingEventRosterID AND a.AttendanceDate = j.AttendanceDate 
         WHERE a.TrainingEventRosterID = j.TrainingEventRosterID 
           AND a.TrainingEventRosterID = @TrainingEventRosterID 
           AND a.AttendanceDate = j.AttendanceDate

        -- 3. ADD ATTENDANCE
        INSERT INTO training.TrainingEventAttendance
        (TrainingEventRosterID, AttendanceDate, AttendanceIndicator, ModifiedByAppUserID)
        SELECT @TrainingEventRosterID, json.AttendanceDate, json.AttendanceIndicator, @ModifiedByAppUserID
          FROM OPENJSON(@AttendanceJSON) 
          WITH (TrainingEventRosterID BIGINT, AttendanceDate DATETIME, AttendanceIndicator BIT) json
         WHERE NOT EXISTS(SELECT TrainingEventAttendanceID 
                            FROM training.TrainingEventAttendance 
                           WHERE TrainingEventRosterID = @TrainingEventRosterID AND AttendanceDate = json.AttendanceDate);

        -- 4. COMMIT TRANSACTION
        COMMIT;

    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END;