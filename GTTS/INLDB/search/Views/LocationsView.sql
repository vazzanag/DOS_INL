CREATE VIEW [search].[LocationsView]
WITH SCHEMABINDING
AS
    SELECT l.LocationID, l.LocationName, l.IsActive, l.ModifiedByAppUserID, l.ModifiedDate,
	       l.AddressLine1, l.AddressLine2, l.AddressLine3, 
		   c.CityID, c.CityName, 
           s.StateID, s.StateName, s.StateCodeA2, s.Abbreviation AS StateAbbreviation, s.INKCode AS StateINKCode,
		   co.CountryID, co.CountryName, co.GENCCodeA2, co.GENCCodeA3 AS CountryAbbreviation, co.INKCode AS CountryINKCode,
		   l.Latitude, l.Longitude           
      FROM [location].Locations l
INNER JOIN [location].Cities c                ON l.CityID = c.CityID
INNER JOIN [location].States s                ON c.StateID = s.StateID
INNER JOIN [location].Countries co            ON s.CountryID = co.CountryID;
GO

CREATE UNIQUE CLUSTERED INDEX IDX_LocationsView_LocationID   
    ON search.LocationsView (LocationID);  
GO 


CREATE FULLTEXT INDEX ON [search].[LocationsView]
    (LocationName, AddressLine1, AddressLine2, AddressLine3, CityName, StateName, StateCodeA2, StateAbbreviation, StateINKCode,
    CountryName, GENCCodeA2, CountryAbbreviation, CountryINKCode) 
    KEY INDEX [IDX_LocationsView_LocationID] ON FullTextCatalog 
    WITH CHANGE_TRACKING AUTO; 
GO