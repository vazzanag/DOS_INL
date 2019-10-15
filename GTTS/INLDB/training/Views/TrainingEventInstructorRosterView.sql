CREATE VIEW [training].[TrainingEventInstructorRosterView]
AS
    SELECT TrainingEventRosterID, i.TrainingEventID, i.PersonID, p.FirstMiddleNames, p.LastNames, tpt.[Name] AS ParticipantType, 
           g.TrainingEventGroupID, g.GroupName, PreTestScore, PostTestScore, PerformanceScore, ProductsScore, AttendanceScore, 
           FinalGradeScore, [Certificate], r.MinimumAttendanceMet, r.TrainingEventRosterDistinctionID, d.Code AS TrainingEventRosterDistinction, 
           r.NonAttendanceReasonID, nar.[Description] AS NonAttendanceReason, r.NonAttendanceCauseID, 
           nac.[Description] AS NonAttendanceCause, r.Comments, r.ModifiedByAppUserID, r.ModifiedDate,

           -- Attendance Information
           (SELECT TrainingEventAttendanceID, TrainingEventRosterID, AttendanceDate, AttendanceIndicator,
                    ModifiedByAppUserID, ModifiedDate
	          FROM training.TrainingEventAttendanceView a
	         WHERE a.TrainingEventRosterID = r.TrainingEventRosterID FOR JSON PATH) AttendanceJSON

      FROM [training].[TrainingEventParticipants] i
	  INNER JOIN [training].[TrainingEventParticipantTypes] tpt ON tpt.TrainingEventParticipantTypeID = i.TrainingEventParticipantTypeID
INNER JOIN persons.Persons                            p ON i.PersonID = p.PersonID
 LEFT JOIN training.TrainingEventRosters			  r ON i.PersonID = r.PersonID 
 LEFT JOIN training.TrainingEventRosterDistinctions   d ON r.TrainingEventRosterDistinctionID = d.TrainingEventRosterDistinctionID
 LEFT JOIN training.NonAttendanceReasons            nar ON r.NonAttendanceReasonID = nar.NonAttendanceReasonID
 LEFT JOIN training.NonAttendanceCauses             nac ON r.NonAttendanceCauseID = nac.NonAttendanceCauseID
 LEFT JOIN training.TrainingEventGroupMembersView     g on I.PersonID = g.PersonID and g.TrainingEventID = I.TrainingEventID
 WHERE i.TrainingEventParticipantTypeID = 2 -- Instructor
