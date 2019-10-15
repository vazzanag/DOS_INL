CREATE PROCEDURE [users].[SwitchPost]
	@AppUserID INT,
	@PostID INT
AS
BEGIN

	SET NOCOUNT ON;

	-- This is for GlobalAdmins only
	IF NOT EXISTS (SELECT 1 
					FROM users.AppUserRoles
					WHERE AppRoleID = 8 -- INLGLOBALADMIN
					AND AppUserID = @AppUserID)
	BEGIN
		RAISERROR (N'User is not a Global Admin.', 16, 1)
	END
	
	UPDATE u
	SET PostID = @PostID, CountryID = p.CountryID
	FROM users.AppUsers u
	INNER JOIN location.Posts p
		ON p.PostID = @PostID
	WHERE u.AppUserID = @AppUserID

END
