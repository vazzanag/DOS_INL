CREATE VIEW [location].[CountriesView]
AS 
    SELECT co.CountryID, co.CountryName, co.GENCCodeA2, co.GENCCodeA3, co.INKCode      
      FROM [location].Countries co;


