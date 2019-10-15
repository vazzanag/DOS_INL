CREATE VIEW [training].[TrainingEventAttendanceView]
AS 
SELECT TrainingEventAttendanceID, TrainingEventRosterID, CAST(AttendanceDate AS DATE) AttendanceDate, AttendanceIndicator,
       ModifiedByAppUserID, ModifiedDate
FROM training.TrainingEventAttendance a;
