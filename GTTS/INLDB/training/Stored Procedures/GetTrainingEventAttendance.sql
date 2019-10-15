CREATE PROCEDURE [training].[GetTrainingEventAttendance]
    @TrainingEventAttendanceID BIGINT
AS
BEGIN
    SELECT TrainingEventAttendanceID, TrainingEventRosterID, AttendanceDate, AttendanceIndicator,
           ModifiedByAppUserID, ModifiedDate
      FROM training.TrainingEventAttendance a
     WHERE TrainingEventAttendanceID = @TrainingEventAttendanceID;
END
