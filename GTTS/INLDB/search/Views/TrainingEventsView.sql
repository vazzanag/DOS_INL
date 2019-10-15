CREATE VIEW [search].[TrainingEventsView]
AS
SELECT e.TrainingEventID, e.[Name], e.NameInLocalLang, e.CountryID, e.TrainingUnitID, b.Acronym AS TrainingUnitAcronym, b.BusinessUnitName AS TrainingUnit, 
	   e.OrganizerAppUserID, u.FullName AS OrganizerFullName, 0 AS ParticipantCount, tet.[Name] AS TrainingEventType, 
       st.TrainingEventStatusID, st.TrainingEventStatus,

       -- Start and End dates (based on Training Event Locations)
       (SELECT MIN(CAST(el.EventStartDate AS DATE)) FROM training.TrainingEventLocations el WHERE TrainingEventID = e.TrainingEventID) EventStartDate,
       (SELECT MAX(CAST(el.EventEndDate AS DATE))   FROM training.TrainingEventLocations el WHERE TrainingEventID = e.TrainingEventID) EventEndDate,

       -- Locations
       (SELECT EventStartDate, EventEndDate, TravelStartDate, TravelEndDate, 
		       LocationName, CityName, StateName, StateAbbreviation, CountryName, CountryAbbreviation
	      FROM training.TrainingEventLocationsView u
	     WHERE u.TrainingEventID = e.TrainingEventID FOR JSON PATH) LocationsJSON,

        -- Key Activities
        (SELECT k.Code, k.[Description]
	       FROM training.TrainingEventKeyActivitiesView k
	      WHERE k.TrainingEventID = e.TrainingEventID FOR JSON PATH) KeyActivitiesJSON

FROM training.TrainingEvents e
INNER JOIN users.BusinessUnits b ON e.TrainingUnitID = b.BusinessUnitID
INNER JOIN training.TrainingEventTypes tet ON e.TrainingEventTypeID = tet.TrainingEventTypeID
 LEFT JOIN users.AppUsersView u ON e.OrganizerAppUserID = u.AppUserID
 LEFT JOIN training.TrainingEventStatusLogView st ON e.TrainingEventID = st.TrainingEventID 
												AND st.TrainingEventStatusLogID = (SELECT MAX(TrainingEventStatusLogID )
																					 FROM training.TrainingEventStatusLogView tesv
																					WHERE tesv.TrainingEventID = e.TrainingEventID);