CREATE PROCEDURE [location].[GetLocationsByCountryID]
	@CountryID INT
AS    
    SELECT LocationID, LocationName, IsActive, ModifiedByAppUserID, ModifiedDate,
	       AddressLine1, AddressLine2, AddressLine3, 
		   CityID, CityName, 
           StateID, StateName, StateCodeA2, StateAbbreviation, StateINKCode,
		   CountryID, CountryName, GENCCodeA2, CountryAbbreviation, CountryINKCode,
		   Latitude, Longitude  
      FROM [location].LocationsView
     WHERE CountryID = @CountryID
  ORDER BY CityName
