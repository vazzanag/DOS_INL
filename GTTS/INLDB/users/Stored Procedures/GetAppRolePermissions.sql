CREATE PROCEDURE [users].[GetAppRolePermissions]
	@AppRoleID INT
AS
BEGIN

	SELECT DISTINCT	       
			p.AppPermissionID,
			p.Name,
			p.Description,
			p.ModifiedByAppUserID,
			p.ModifiedDate
	FROM users.AppPermissions p
	INNER JOIN users.AppRolePermissions arp
		ON arp.AppPermissionID = p.AppPermissionID
	WHERE arp.AppRoleID = @AppRoleID
  ORDER BY p.Name

END
