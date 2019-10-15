CREATE PROCEDURE [training].[GetTrainingEventStudentRosterByTrainingEventID]
    @TrainingEventID BIGINT
AS
BEGIN
    SELECT TrainingEventRosterID, TrainingEventID, PersonID, FirstMiddleNames, LastNames, ParticipantType, TrainingEventGroupID, 
           GroupName, PreTestScore, PostTestScore, PerformanceScore, ProductsScore, AttendanceScore, FinalGradeScore, [Certificate], 
           MinimumAttendanceMet, TrainingEventRosterDistinctionID, TrainingEventRosterDistinction, NonAttendanceReasonID, NonAttendanceReason, 
           NonAttendanceCauseID, NonAttendanceCause, Comments, ModifiedByAppUserID, ModifiedDate, AttendanceJSON
      FROM training.TrainingEventStudentRosterView
     WHERE TrainingEventID = @TrainingEventID;
END