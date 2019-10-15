CREATE VIEW [training].[TrainingEventRosterView]
AS 
    SELECT TrainingEventRosterID, TrainingEventID, PersonID, PreTestScore, PostTestScore, PerformanceScore, ProductsScore,
           AttendanceScore, FinalGradeScore, [Certificate], r.MinimumAttendanceMet, r.TrainingEventRosterDistinctionID, 
           d.Code AS TrainingEventRosterDistinction, r.NonAttendanceReasonID, nar.[Description] AS NonAttendanceReason, 
           r.NonAttendanceCauseID, nac.[Description] AS NonAttendanceCause, r.Comments, r.ModifiedByAppUserID, r.ModifiedDate,

           -- Attendance Information
           (SELECT TrainingEventAttendanceID, TrainingEventRosterID, AttendanceDate, AttendanceIndicator,
                    ModifiedByAppUserID, ModifiedDate
	          FROM training.TrainingEventAttendanceView a
	         WHERE a.TrainingEventRosterID = r.TrainingEventRosterID FOR JSON PATH) AttendanceJSON

      FROM training.TrainingEventRosters r
 LEFT JOIN training.TrainingEventRosterDistinctions   d ON r.TrainingEventRosterDistinctionID = d.TrainingEventRosterDistinctionID
 LEFT JOIN training.NonAttendanceReasons            nar ON r.NonAttendanceReasonID = nar.NonAttendanceReasonID
 LEFT JOIN training.NonAttendanceCauses             nac ON r.NonAttendanceCauseID = nac.NonAttendanceCauseID;