CREATE VIEW [training].[TrainingEventsView]
AS 
     SELECT e.TrainingEventID, e.[Name], e.NameInLocalLang, tet.[Name] AS TrainingEventType, 
	        e.ProgramID, b.Acronym AS BusinessUnitAcronym, b.BusinessUnitName AS BusinessUnit, 
			e.CountryID, e.PostID,
			e.OrganizerAppUserID, st.TrainingEventStatusID, st.TrainingEventStatus,
			e.ModifiedByAppUserID, mu.FullName AS ModifiedByAppUser, ou.FullName AS Organizer, 
			e.ModifiedDate, e.CreatedDate,
           
           -- Start and End dates (based on Training Event Locations)
           (SELECT MIN(CAST(el.EventStartDate AS DATE)) FROM training.TrainingEventLocations el WHERE TrainingEventID = e.TrainingEventID) EventStartDate,
           (SELECT MAX(CAST(el.EventEndDate AS DATE))   FROM training.TrainingEventLocations el WHERE TrainingEventID = e.TrainingEventID) EventEndDate,
   
            -- Locations
           (SELECT TrainingEventLocationID, TrainingEventID, LocationID, 
		           EventStartDate, EventEndDate, TravelStartDate, TravelEndDate, 
				   ModifiedByAppUserID, ModifiedDate,
				   LocationName, AddressLine1, AddressLine2, AddressLine3, 
				   CityID, CityName, 
			       StateID, StateName, StateCodeA2, StateAbbreviation, StateINKCode,
				   CountryID,CountryName, CountryINKCode,
			       GENCCodeA2, CountryAbbreviation
	          FROM training.TrainingEventLocationsView u
	         WHERE u.TrainingEventID = e.TrainingEventID FOR JSON PATH) LocationsJSON,

            -- Key Activities
           (SELECT k.KeyActivityID, k.Code, k.[Description]
	          FROM training.TrainingEventKeyActivitiesView k
	         WHERE k.TrainingEventID = e.TrainingEventID FOR JSON PATH) KeyActivitiesJSON,
			
			 -- Iaas
           (SELECT ad.IAAID
	          FROM training.TrainingEventAuthorizingDocumentsView ad
	         WHERE ad.TrainingEventID = e.TrainingEventID FOR JSON PATH) IAAsJSON

      FROM training.TrainingEvents e
INNER JOIN users.BusinessUnits b ON e.TrainingUnitID = b.BusinessUnitID
INNER JOIN training.TrainingEventTypes tet ON e.TrainingEventTypeID = tet.TrainingEventTypeID
INNER JOIN users.AppUsersView mu ON e.ModifiedByAppUserID = mu.AppUserID
INNER JOIN users.AppUsersView ou ON e.OrganizerAppUserID = ou.AppUserID
 LEFT JOIN training.TrainingEventStatusLogView st ON e.TrainingEventID = st.TrainingEventID 
												AND st.TrainingEventStatusLogID = (SELECT MAX(TrainingEventStatusLogID )
																					 FROM training.TrainingEventStatusLogView tesv
																					WHERE tesv.TrainingEventID = e.TrainingEventID)
 LEFT JOIN training.KeyActivities k ON e.KeyActivityID = k.KeyActivityID
