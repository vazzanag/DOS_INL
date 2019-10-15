CREATE PROCEDURE [users].[GetAppUserProfileByADOID]
   @ADOID NVARCHAR(100)
AS
BEGIN

	SELECT u.AppUserID, u.ADOID, 
		   u.[First], u.[Middle], u.[Last], u.FullName, 
		   u.PositionTitle, u.EmailAddress, u.PhoneNumber, u.PicturePath, 
		   u.CountryID, u.CountryName,
		   u.PostID, u.PostName,
		   u.DefaultBusinessUnitID,
		   u.DefaultAppRoleID,
		   u.AppRolesJSON,
		   u.AppPermissionsJSON,
		   u.BusinessUnitsJSON
	  FROM users.AppUsersDetailView u
	 WHERE u.ADOID = @ADOID;
END
