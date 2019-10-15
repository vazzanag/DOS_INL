CREATE PROCEDURE [training].[SaveTrainingEventAttendance]
    @TrainingEventAttendanceID BIGINT NULL, 
    @TrainingEventRosterID BIGINT, 
    @AttendanceDate DATETIME,
    @AttendanceIndicator BIT,
	@ModifiedByAppUserID INT
AS
BEGIN

    DECLARE @Identity BIGINT;

    IF NOT EXISTS(SELECT * FROM training.TrainingEventAttendance WHERE TrainingEventRosterID = @TrainingEventRosterID AND AttendanceDate = @AttendanceDate)
        BEGIN
            -- INSERT
            INSERT INTO training.TrainingEventAttendance
            (TrainingEventRosterID, AttendanceDate, AttendanceIndicator, ModifiedByAppUserID)
            VALUES
            (@TrainingEventRosterID, @AttendanceDate, @AttendanceIndicator, @ModifiedByAppUserID);

            SET @Identity = SCOPE_IDENTITY();
        END
    ELSE
        BEGIN
            IF NOT EXISTS(SELECT * FROM training.TrainingEventAttendance WHERE TrainingEventAttendanceID = @TrainingEventAttendanceID)
                THROW 50000,  'The requested training attendance to be updated does not exist.',  1

            -- UPDATE
            UPDATE training.TrainingEventAttendance SET
                   AttendanceIndicator = @AttendanceIndicator
             WHERE TrainingEventAttendanceID = @TrainingEventAttendanceID;

            SET @Identity = @TrainingEventAttendanceID;
        END

    SELECT @Identity
END;