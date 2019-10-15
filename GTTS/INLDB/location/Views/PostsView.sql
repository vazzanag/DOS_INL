CREATE VIEW [location].[PostsView]
AS 
    SELECT PostID, Name AS PostName, GMTOffset, p.CountryID, CountryName, p.IsActive
      FROM [location].Posts p
INNER JOIN [location].Countries c
		ON c.CountryID = p.CountryID
	 WHERE p.IsActive = 1

