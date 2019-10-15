CREATE VIEW [location].[CitiesView]
WITH SCHEMABINDING
AS 
    SELECT c.CityID, c.CityName, 
           s.StateID, s.StateName, s.StateCodeA2, s.Abbreviation AS StateAbbreviation, s.INKCode AS StateINKCode,
		   co.CountryID, co.CountryName, co.GENCCodeA2, co.GENCCodeA3 AS CountryAbbreviation, co.INKCode AS CountryINKCode
      FROM [location].Cities c
INNER JOIN [location].States s
	    ON s.StateID = c.StateID
INNER JOIN [location].Countries co
		ON co.CountryID = s.CountryID;
GO


CREATE UNIQUE CLUSTERED INDEX IDX_CitiesView_CityID
    ON location.CitiesView (CityID);  
GO 