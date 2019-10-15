CREATE PROCEDURE [training].[GetTrainingEventRoster]
    @TrainingEventRosterID BIGINT
AS
BEGIN
    SELECT TrainingEventRosterID, TrainingEventID, PersonID, PreTestScore, PostTestScore, PerformanceScore, ProductsScore,
           AttendanceScore, FinalGradeScore, [Certificate], MinimumAttendanceMet, TrainingEventRosterDistinctionID, 
           TrainingEventRosterDistinction, NonAttendanceReasonID, NonAttendanceReason, NonAttendanceCauseID, NonAttendanceCause, 
           Comments, ModifiedByAppUserID, ModifiedDate
      FROM training.TrainingEventRosterView
     WHERE TrainingEventRosterID = @TrainingEventRosterID;
END
