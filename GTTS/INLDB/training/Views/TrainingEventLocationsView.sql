CREATE VIEW [training].[TrainingEventLocationsView]
AS 
    SELECT el.TrainingEventLocationID, t.TrainingEventID, el.LocationID, 
	       el.EventStartDate, el.EventEndDate, el.TravelStartDate, el.TravelEndDate,
		   el.ModifiedByAppUserID, el.ModifiedDate,
	       l.LocationName, l.AddressLine1, l.AddressLine2, l.AddressLine3, 
		   l.CityID, l.CityName, 
		   l.StateID, l.StateName, l.StateCodeA2, l.StateAbbreviation, l.StateINKCode,
		   l.CountryID, l.CountryName, l.GENCCodeA2, l.CountryAbbreviation, l.CountryINKCode,

           -- Locations 
           (SELECT l.LocationID, l.LocationName, l.AddressLine1, l.AddressLine2, l.AddressLine3, 
		           l.CityID, l.CityName, 
		           l.StateID, l.StateName, l.StateCodeA2, l.StateAbbreviation, l.StateINKCode,
		           l.CountryID, l.CountryName, l.GENCCodeA2, l.CountryAbbreviation, l.CountryINKCode
              FROM [location].LocationsView l
             WHERE l.LocationID = el.LocationID FOR JSON PATH, INCLUDE_NULL_VALUES) LocationJSON,

           -- Modified By User
           (SELECT AppUserID, [First], [Middle], [Last], FullName
              FROM users.AppUsersView 
             WHERE AppUserID = el.ModifiedByAppUserID FOR JSON PATH, INCLUDE_NULL_VALUES) ModifiedByUserJSON

	  FROM training.TrainingEvents t
INNER JOIN training.TrainingEventLocations el ON t.TrainingEventID = el.TrainingEventID
INNER JOIN [location].LocationsView l ON l.LocationID = el.LocationID;