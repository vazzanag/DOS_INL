CREATE VIEW [messaging].[NotificationRosterUploadedView]
AS
    SELECT TrainingEventID, [Name], t.OrganizerAppUserID,
	       
           -- Stakeholders 
           (SELECT b.AppUserID
              FROM training.TrainingEventStakeholdersView b
             WHERE b.TrainingEventID = t.TrainingEventID FOR JSON PATH, INCLUDE_NULL_VALUES) StakeholdersJSON,

            -- Key Participants
            (SELECT p.FirstMiddleNames, p.LastNames
	          FROM training.TrainingEventRosters r
		INNER JOIN persons.PersonsView p ON r.PersonID = p.PersonID
	         WHERE TrainingEventRosterDistinctionID = 1 and r.TrainingEventID = t.TrainingEventID FOR JSON PATH) KeyParticipantsJSON,

            -- Unsatisfactory
            (SELECT p.FirstMiddleNames, p.LastNames
	          FROM training.TrainingEventRosters r
		INNER JOIN persons.PersonsView p ON r.PersonID = p.PersonID
	         WHERE TrainingEventRosterDistinctionID = 2 and r.TrainingEventID = t.TrainingEventID FOR JSON PATH) UnsatisfactoryParticipantsJSON

      FROM training.TrainingEventsView t