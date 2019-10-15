

IF (NOT EXISTS(SELECT * FROM users.AppRolePermissions))
BEGIN

	DECLARE @AppRoleID INT;

	/* INL PROGRAM MANAGER */
	SELECT @AppRoleID = AppRoleID FROM users.AppRoles WHERE Code = 'INLPROGRAMMANAGER';
    INSERT INTO users.AppRolePermissions
	    (AppRoleID, AppPermissionID, ModifiedByAppUserID) 
    SELECT @AppRoleID, AppPermissionID, 1 FROM users.AppPermissions
	WHERE Name IN (	
	
		/* Training Events */
		'LIST TRAINING EVENTS',
		'VIEW TRAINING EVENT DETAILS',
		'CREATE TRAINING EVENT',
		'UPDATE TRAINING EVENT',
	
		/* Persons */
		'LIST PERSONS',
		'VIEW PERSON DETAILS',
		'CREATE PERSON',
		'UPDATE PERSON',		

		/* Unit Library */
		'LIST UNITS',
		'VIEW UNIT DETAILS',

		/* Vetting */
		'LIST VETTING BATCHES',
		'VIEW BATCH DETAILS',
		'CREATE VETTING BATCH',
		'UPDATE VETTING BATCH',
		
		/* Locations */
		'LIST LOCATIONS',
		'VIEW LOCATION DETAILS',
		'CREATE LOCATION',
		'UPDATE LOCATION',
		
		/* Files */
		'LIST FILES',
		'VIEW FILE DETAILS',
		'UPLOAD FILE',
		'DOWNLOAD FILE'
		
	)


	/* INL VETTING COORDINATOR */
	SELECT @AppRoleID = AppRoleID FROM users.AppRoles WHERE Code = 'INLVETTINGCOORDINATOR';
	INSERT INTO users.AppRolePermissions
	    (AppRoleID, AppPermissionID, ModifiedByAppUserID) 
    SELECT @AppRoleID, AppPermissionID, 1 FROM users.AppPermissions
	WHERE Name IN (	
		
		/* Persons */
		'LIST PERSONS',
		'VIEW PERSON DETAILS',
		'UPDATE PERSON',		

		/* Unit Library */
		'LIST UNITS',
		'VIEW UNIT DETAILS',

		/* Vetting */
		'LIST VETTING BATCHES',
		'VIEW BATCH DETAILS',
		'UPDATE VETTING BATCH',
		
		/* Locations */
		'LIST LOCATIONS',
		'VIEW LOCATION DETAILS',
		'CREATE LOCATION',
		'UPDATE LOCATION',
		
		/* Files */
		'LIST FILES',
		'VIEW FILE DETAILS',
		'UPLOAD FILE',
		'DOWNLOAD FILE'
		
	)

	/* INL COURTESY VETTER */
	SELECT @AppRoleID = AppRoleID FROM users.AppRoles WHERE Code = 'INLCOURTESYVETTER';
	INSERT INTO users.AppRolePermissions
	    (AppRoleID, AppPermissionID, ModifiedByAppUserID) 
    SELECT @AppRoleID, AppPermissionID, 1 FROM users.AppPermissions
	WHERE Name IN (	
	
		/* Persons */
		'LIST PERSONS',
		'VIEW PERSON DETAILS',	

		/* Unit Library */
		'LIST UNITS',
		'VIEW UNIT DETAILS',

		/* Vetting */
		'LIST VETTING BATCHES',
		'VIEW BATCH DETAILS',
		'UPDATE VETTING BATCH',
		
		/* Locations */
		'LIST LOCATIONS',
		'VIEW LOCATION DETAILS',
		
		/* Files */
		'LIST FILES',
		'VIEW FILE DETAILS',
		'UPLOAD FILE',
		'DOWNLOAD FILE'		
	)

	/* INL GLOBAL ADMINISTRATOR */
	SELECT @AppRoleID = AppRoleID FROM users.AppRoles WHERE Code = 'INLGLOBALADMIN';
	INSERT INTO users.AppRolePermissions
	    (AppRoleID, AppPermissionID, ModifiedByAppUserID) 
    SELECT @AppRoleID, AppPermissionID, 1 FROM users.AppPermissions
	WHERE Name IN (	
	
		/* Training Events */
		'LIST TRAINING EVENTS', 
		'VIEW TRAINING EVENT DETAILS', 
		'CREATE TRAINING EVENT', 
		'UPDATE TRAINING EVENT', 

		/* Persons */
		'LIST PERSONS', 
		'VIEW PERSON DETAILS', 
		'CREATE PERSON', 
		'UPDATE PERSON', 

		/* Unit Library */
		'LIST UNITS', 
		'VIEW UNIT DETAILS', 
		'CREATE UNIT', 
		'UPDATE UNIT', 

		/* Vetting */
		'LIST VETTING BATCHES', 
		'VIEW BATCH DETAILS', 
		'CREATE VETTING BATCH', 
		'UPDATE VETTING BATCH', 

		/* Locations */
		'LIST LOCATIONS', 
		'VIEW LOCATION DETAILS', 
		'CREATE LOCATION', 
		'UPDATE LOCATION', 

		/* Files */
		'LIST FILES', 
		'VIEW FILE DETAILS', 
		'UPLOAD FILE',
		'DOWNLOAD FILE'	
	)


END
GO



