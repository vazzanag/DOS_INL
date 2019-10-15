CREATE VIEW [users].AppUsersDetailView
AS		
	-- Plebs
	SELECT DISTINCT
	       u.AppUserID, u.ADOID, 
           u.[First], u.[Middle], u.[Last], u.FullName, 
           u.PositionTitle, u.EmailAddress, u.PhoneNumber, u.PicturePath, 
           u.CountryID, u.CountryName,
           u.PostID, u.PostName,
		   
		   -- Default Business Unit
		   (    SELECT TOP 1 
					   abu.BusinessUnitID 
			      FROM users.AppUserBusinessUnits abu
			     WHERE abu.AppUserID = u.AppUserID
			 	  AND  abu.DefaultBusinessUnit = 1) AS DefaultBusinessUnitID,	
		   
		   -- Default App Role
		   (   SELECT TOP 1 
					  aur.AppRoleID 
			     FROM users.AppUserRoles aur
			 	WHERE aur.AppUserID = u.AppUserID
			 	AND   aur.DefaultRole = 1) AS DefaultAppRoleID,			  
			 
           -- AppRoles
           (    SELECT r.AppRoleID, r.Code, r.[Name]
	              FROM users.AppRoles r
		    INNER JOIN users.AppUserRoles ur
			        ON ur.AppRoleID = r.AppRoleID
	             WHERE ur.AppUserID = u.AppUserID FOR JSON PATH) AppRolesJSON,
			 
           -- AppPermissions
           (    SELECT p.AppPermissionID, p.[Name]
	              FROM users.AppPermissions p
		    INNER JOIN users.AppRolePermissions arp
			        ON arp.AppPermissionID = p.AppPermissionID
		    INNER JOIN users.AppUserRoles aur
		            ON aur.AppRoleID = arp.AppRoleID
	             WHERE aur.AppUserID = u.AppUserID FOR JSON PATH) AppPermissionsJSON,
		   
           -- Business Units
           (    SELECT DISTINCT 
					   b.BusinessUnitID, b.BusinessUnitName, b.Acronym, b.PostID, b.VettingPrefix
			      FROM users.AppUserBusinessUnits ubu
		    INNER JOIN users.BusinessUnits b
					ON b.BusinessUnitID = ubu.BusinessUnitID
			 	 WHERE ubu.AppUserID = u.AppUserID  FOR JSON PATH) BusinessUnitsJSON
		   
	 FROM  users.AppUsersView u
	 INNER JOIN users.AppUserRoles ur
		ON ur.AppUserID = u.AppUserID
	 WHERE ur.AppRoleID != 8

	 UNION

	 -- Global Admins
	SELECT DISTINCT
	       u.AppUserID, u.ADOID, 
           u.[First], u.[Middle], u.[Last], u.FullName, 
           u.PositionTitle, u.EmailAddress, u.PhoneNumber, u.PicturePath, 
           u.CountryID, u.CountryName,
           u.PostID, u.PostName,
		   
		   -- Default Business Unit
		   ( SELECT TOP 1 
					bu.BusinessUnitID 
		  	   FROM users.BusinessUnits bu
		  	  WHERE bu.PostID = u.PostID) AS DefaultBusinessUnitID,	
		   
		   -- Default App Role
		   ( SELECT TOP 1 
					aur.AppRoleID 
		       FROM users.AppUserRoles aur
		  	  WHERE aur.AppUserID = u.AppUserID
		  	   AND  aur.DefaultRole = 1) AS DefaultAppRoleID,			  
		  
           -- AppRoles
           (    SELECT r.AppRoleID, r.Code, r.[Name]
	              FROM users.AppRoles r
		    INNER JOIN users.AppUserRoles ur
		           ON  ur.AppRoleID = r.AppRoleID
	             WHERE ur.AppUserID = u.AppUserID FOR JSON PATH) AppRolesJSON,
		  
           -- AppPermissions
           (    SELECT p.AppPermissionID, p.[Name]
	              FROM users.AppPermissions p
		    INNER JOIN users.AppRolePermissions arp
		            ON arp.AppPermissionID = p.AppPermissionID
		    INNER JOIN users.AppUserRoles aur
		            ON aur.AppRoleID = arp.AppRoleID
	             WHERE aur.AppUserID = u.AppUserID FOR JSON PATH) AppPermissionsJSON,
		   
           -- Business Units
           (   SELECT bu.BusinessUnitID, bu.BusinessUnitName, bu.Acronym, bu.PostID, bu.VettingPrefix
		  		 FROM users.BusinessUnits bu
		  		WHERE bu.PostID = u.PostID FOR JSON PATH) BusinessUnitsJSON
		    
	 FROM  users.AppUsersView u
	 INNER JOIN users.AppUserRoles ur
		ON ur.AppUserID = u.AppUserID
	 WHERE ur.AppRoleID = 8

