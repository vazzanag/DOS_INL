CREATE VIEW [training].[PersonsTrainingEventsView]
AS 
		SELECT t.TrainingEventID, t.[Name], s.PersonID, tpt.[Name] AS ParticipantType, 
			   (SELECT MIN(CAST(el.EventStartDate AS DATE)) FROM training.TrainingEventLocations el (NOLOCK) WHERE TrainingEventID = t.TrainingEventID) EventStartDate,
			   (SELECT MAX(CAST(el.EventEndDate AS DATE))   FROM training.TrainingEventLocations el (NOLOCK) WHERE TrainingEventID = t.TrainingEventID) EventEndDate,
			   b.Acronym AS BusinessUnitAcronym, d.Code AS TrainingEventRosterDistinction, r.[Certificate], stat.[Name] AS TrainingEventStatus
		  FROM training.TrainingEvents t (NOLOCK)
	INNER JOIN [training].[TrainingEventParticipants] s (NOLOCK) ON t.TrainingEventID = s.TrainingEventID
	INNER JOIN [training].[TrainingEventParticipantTypes] tpt ON tpt.TrainingEventParticipantTypeID = s.TrainingEventParticipantTypeID
	INNER JOIN users.BusinessUnits b (NOLOCK) ON t.TrainingUnitID = b.BusinessUnitID
	 LEFT JOIN training.TrainingEventRosters r (NOLOCK) on s.TrainingEventID = r.TrainingEventID AND s.PersonID = r.PersonID
	 LEFT JOIN training.TrainingEventRosterDistinctions d (NOLOCK) on r.TrainingEventRosterDistinctionID = d.TrainingEventRosterDistinctionID
	 LEFT JOIN (
					SELECT MAX(TrainingEventStatusLogID) TrainingEventStatusLogID, TrainingEventStatusID, TrainingEventID
					  FROM training.TrainingEventStatusLog (NOLOCK) 
				  GROUP BY TrainingEventID, TrainingEventStatusID
				) l on t.TrainingEventID = l.TrainingEventID 
	 LEFT JOIN training.TrainingEventStatuses stat (NOLOCK) on l.TrainingEventStatusID = stat.TrainingEventStatusID

