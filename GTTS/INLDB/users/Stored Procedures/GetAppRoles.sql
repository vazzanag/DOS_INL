CREATE PROCEDURE [users].[GetAppRoles]

AS
BEGIN

	SELECT DISTINCT	       
			AppRoleID,
			Code,
			Name,
			Description,
			ModifiedByAppUserID,
			ModifiedDate
	  FROM [users].AppRoles
  ORDER BY Code

END
