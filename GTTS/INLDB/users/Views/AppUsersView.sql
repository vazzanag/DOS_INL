CREATE VIEW [users].[AppUsersView]
AS
    SELECT a.AppUserID, ADOID, 
           [First], [Middle], [Last], users.FullName([First], [Middle], [Last]) AS FullName, 
           PositionTitle, EmailAddress, PhoneNumber, PicturePath, 
           a.CountryID, c.CountryName,
           a.PostID, p.FullName AS PostName
	  FROM users.AppUsers a
INNER JOIN location.Countries c
        ON c.CountryID = a.CountryID
 LEFT JOIN location.Posts p
        ON p.PostID = a.PostID


	      
		
