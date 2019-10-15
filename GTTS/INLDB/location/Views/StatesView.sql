CREATE VIEW [location].[StatesView]
AS 
    SELECT s.StateID, s.StateName, s.StateCodeA2, s.Abbreviation AS StateAbbreviation, s.INKCode AS StateINKCode,
		   co.CountryID, co.CountryName, co.GENCCodeA2, co.GENCCodeA3 AS CountryAbbreviation, co.INKCode AS CountryINKCode
      FROM [location].States s
INNER JOIN [location].Countries co
		ON co.CountryID = s.CountryID;
