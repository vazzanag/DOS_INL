CREATE PROCEDURE [location].[GetPosts]
AS    
    SELECT PostID, PostName, GMTOffset, CountryID, CountryName, IsActive
      FROM [location].PostsView
	 WHERE IsActive = 1