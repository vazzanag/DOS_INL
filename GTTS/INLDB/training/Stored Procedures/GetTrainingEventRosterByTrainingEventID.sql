CREATE PROCEDURE [training].[GetTrainingEventRosterByTrainingEventID]
    @TrainingEventID BIGINT
AS
BEGIN
    SELECT TrainingEventRosterID, TrainingEventID, PersonID, PreTestScore, PostTestScore, PerformanceScore, ProductsScore,
           AttendanceScore, FinalGradeScore, [Certificate], MinimumAttendanceMet TrainingEventRosterDistinctionID, 
           TrainingEventRosterDistinction, NonAttendanceReasonID, NonAttendanceReason, NonAttendanceCauseID, NonAttendanceCause, 
           Comments, ModifiedByAppUserID, ModifiedDate, AttendanceJSON
      FROM training.TrainingEventRosterView
     WHERE TrainingEventID = @TrainingEventID;
END
