CREATE PROCEDURE [location].[GetCountries]
AS    
    SELECT CountryID, CountryName, GENCCodeA2, GENCCodeA3, INKCode
      FROM [location].Countries
	 WHERE IsActive = 1
