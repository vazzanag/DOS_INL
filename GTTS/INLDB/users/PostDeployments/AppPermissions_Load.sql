﻿
/*	Turn off constraint	 */
ALTER TABLE [users].[AppPermissions]
	NOCHECK CONSTRAINT [FK_AppPermissions_AppUsers_ModifiedByAppUserID]; 

IF (NOT EXISTS(SELECT * FROM users.AppPermissions))
BEGIN
	INSERT INTO [users].[AppPermissions]
		([AppPermissionID], [Name], [ModifiedByAppUserID], [ModifiedDate])
	VALUES

		/* Training Events */
		(100, 'LIST TRAINING EVENTS', 1, GETUTCDATE()),
		(101, 'VIEW TRAINING EVENT DETAILS', 1, GETUTCDATE()),
		(102, 'CREATE TRAINING EVENT', 1, GETUTCDATE()),
		(103, 'UPDATE TRAINING EVENT', 1, GETUTCDATE()),

		/* Persons */
		(200, 'LIST PERSONS', 1, GETUTCDATE()),
		(201, 'VIEW PERSON DETAILS', 1, GETUTCDATE()),
		(202, 'CREATE PERSON', 1, GETUTCDATE()),
		(203, 'UPDATE PERSON', 1, GETUTCDATE()),

		/* Unit Library */
		(300, 'LIST UNITS', 1, GETUTCDATE()),
		(301, 'VIEW UNIT DETAILS', 1, GETUTCDATE()),
		(302, 'CREATE UNIT', 1, GETUTCDATE()),
		(303, 'UPDATE UNIT', 1, GETUTCDATE()),

		/* Vetting */
		(400, 'LIST VETTING BATCHES', 1, GETUTCDATE()),
		(401, 'VIEW BATCH DETAILS', 1, GETUTCDATE()),
		(402, 'CREATE VETTING BATCH', 1, GETUTCDATE()),
		(403, 'UPDATE VETTING BATCH', 1, GETUTCDATE()),

		/* Locations */
		(500, 'LIST LOCATIONS', 1, GETUTCDATE()),
		(501, 'VIEW LOCATION DETAILS', 1, GETUTCDATE()),
		(502, 'CREATE LOCATION', 1, GETUTCDATE()),
		(503, 'UPDATE LOCATION', 1, GETUTCDATE()),

		/* Files */
		(600, 'LIST FILES', 1, GETUTCDATE()),
		(601, 'VIEW FILE DETAILS', 1, GETUTCDATE()),
		(602, 'UPLOAD FILE', 1, GETUTCDATE()),
		(603, 'DOWNLOAD FILE', 1, GETUTCDATE())



END
GO


/*	Turn on constraint			*/
ALTER TABLE users.AppPermissions
	CHECK CONSTRAINT [FK_AppPermissions_AppUsers_ModifiedByAppUserID]; 
