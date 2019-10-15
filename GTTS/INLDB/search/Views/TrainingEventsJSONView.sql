﻿CREATE VIEW [search].[TrainingEventsJSONView]
AS
    SELECT eo.TrainingEventID, eo.CountryID,
		   (select e.TrainingEventID, e.[Name], e.NameInLocalLang, l.CountryName, l.CountryFullName, 
					b.Acronym AS TrainingUnitAcronym, b.BusinessUnitName AS TrainingUnit, b.[Description] AS TrainingUnitDescription,
				   u.FullName AS OrganizerFullName, tet.[Name] AS TrainingEventType, st.TrainingEventStatus,

				   -- Start and End dates (based on Training Event Locations)
				   (SELECT MIN(CAST(el.EventStartDate AS DATE)) FROM training.TrainingEventLocations el WHERE TrainingEventID = e.TrainingEventID) EventStartDate,
				   (SELECT MAX(CAST(el.EventEndDate AS DATE))   FROM training.TrainingEventLocations el WHERE TrainingEventID = e.TrainingEventID) EventEndDate

			  FROM training.TrainingEvents e
		INNER JOIN users.BusinessUnits b ON e.TrainingUnitID = b.BusinessUnitID
		INNER JOIN training.TrainingEventTypes tet ON e.TrainingEventTypeID = tet.TrainingEventTypeID
		INNER JOIN [location].Countries l ON e.CountryID = l.CountryID
		 LEFT JOIN users.AppUsersView u ON e.OrganizerAppUserID = u.AppUserID
		 LEFT JOIN training.TrainingEventStatusLogView st ON e.TrainingEventID = st.TrainingEventID 
													    AND st.TrainingEventStatusLogID = (SELECT MAX(TrainingEventStatusLogID )
																							 FROM training.TrainingEventStatusLogView tesv
																						    WHERE tesv.TrainingEventID = e.TrainingEventID)
				WHERE e.TrainingEventID = eo.TrainingEventID FOR JSON PATH) TrainingEventJSON,

		   -- Locations
		   (SELECT LocationName, CityName, StateName, StateAbbreviation, CountryName, CountryAbbreviation
              FROM training.TrainingEventLocationsView u
             WHERE u.TrainingEventID = eo.TrainingEventID FOR JSON PATH) LocationsJSON,

		   -- Key Activities
		   (SELECT k.Code, k.[Description]
              FROM training.TrainingEventKeyActivitiesView k
             WHERE k.TrainingEventID = eo.TrainingEventID FOR JSON PATH) KeyActivitiesJSON

	  FROM training.TrainingEvents eo;
