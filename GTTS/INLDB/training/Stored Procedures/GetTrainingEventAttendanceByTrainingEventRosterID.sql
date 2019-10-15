CREATE PROCEDURE [training].[GetTrainingEventAttendanceByTrainingEventRosterID]
     @TrainingEventRosterID BIGINT
AS
BEGIN
    SELECT TrainingEventAttendanceID, TrainingEventRosterID, AttendanceDate, AttendanceIndicator,
           ModifiedByAppUserID, ModifiedDate
      FROM training.TrainingEventAttendance a
     WHERE TrainingEventRosterID = @TrainingEventRosterID;
END
