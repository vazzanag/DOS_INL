CREATE PROCEDURE [location].[GetCitiesByCountryID]
	@CountryID INT
AS    
    SELECT CityID, CityName, 
           StateID, StateName, StateCodeA2, StateAbbreviation, StateINKCode,
		   CountryID, CountryName, GENCCodeA2, CountryAbbreviation, CountryINKCode
      FROM [location].CitiesView
     WHERE CountryID = @CountryID
