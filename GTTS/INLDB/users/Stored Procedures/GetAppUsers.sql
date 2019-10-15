CREATE PROCEDURE [users].[GetAppUsers]
   @CountryID INT = NULL,
   @PostID INT = NULL,
   @AppRoleID INT = NULL,
   @BusinessUnitID INT = NULL
AS
BEGIN

	SELECT DISTINCT
	       uv.AppUserID, 
		   uv.First,
		   uv.Middle, 
		   uv.Last, 
		   uv.FullName,
           uv.PositionTitle, 
		   uv.EmailAddress, 
		   uv.PhoneNumber, 
		   uv.PicturePath, 
		   uv.CountryID, uv.CountryName,
		   uv.PostID, uv.PostName
	  FROM users.AppUsersView uv
INNER JOIN users.AppUserRoles ur 
	    ON uv.AppUserID = ur.AppUserID
 LEFT JOIN users.AppUserBusinessUnits ubu
        ON ubu.AppUserID = uv.AppUserID
 LEFT JOIN users.BusinessUnits bu
        ON bu.BusinessUnitID = ubu.BusinessUnitID
	 WHERE ur.AppRoleID = ISNULL(@AppRoleID, ur.AppRoleID)
	   AND uv.CountryID = ISNULL(@CountryID, uv.CountryID)
	   AND uv.PostID = ISNULL(@PostID, uv.PostID)
	   AND ubu.BusinessUnitID = ISNULL(@BusinessUnitID, ubu.BusinessUnitID)
  ORDER BY uv.First,
		   uv.Last, 
		   uv.Middle

END
