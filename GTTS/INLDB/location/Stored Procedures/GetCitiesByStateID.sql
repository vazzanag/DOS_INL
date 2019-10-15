CREATE PROCEDURE [location].[GetCitiesByStateID]
    @StateID int
AS
BEGIN   
    SELECT CityID, CityName, 
           StateID, StateName, StateCodeA2, StateAbbreviation, StateINKCode,
		   CountryID, CountryName, GENCCodeA2, CountryAbbreviation, CountryINKCode
      FROM [location].CitiesView
     WHERE StateID = @StateID
END
