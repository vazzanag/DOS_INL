CREATE PROCEDURE [users].[SaveAppUserRoles]
	@AppUserID INT,
	@ModifiedByAppUserID INT,
	@AppRoles NVARCHAR(MAX)
AS
BEGIN

	SET NOCOUNT ON;

    DELETE FROM users.AppUserRoles
     WHERE AppUserID = @AppUserID
       AND AppRoleID NOT IN (SELECT json.AppRoleID FROM OPENJSON(@AppRoles) WITH (AppRoleID INT) json);

    INSERT INTO users.AppUserRoles
		(AppUserID, AppRoleID, ModifiedByAppUserID)
    SELECT @AppUserID, json.AppRoleID, @ModifiedByAppUserID
      FROM OPENJSON(@AppRoles) 
           WITH (AppRoleID INT) json
     WHERE NOT EXISTS(SELECT AppUserID FROM users.AppUserRoles WHERE AppUserID = @AppUserID and AppRoleID = json.AppRoleID);

END

