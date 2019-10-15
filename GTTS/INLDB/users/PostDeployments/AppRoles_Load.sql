
/*	Turn off constraint	 */
ALTER TABLE [users].[AppRoles]
	NOCHECK CONSTRAINT [FK_AppRoles_AppUsers_ModifiedByAppUserID]; 

IF (NOT EXISTS(SELECT * FROM users.AppRoles))
BEGIN
	INSERT INTO [users].[AppRoles]
		([AppRoleID], [Code], [Name], [ModifiedByAppUserID], [ModifiedDate])
	VALUES
		(1, 'INLGTTSVIEWONLY', 'GTTS View Only', 1, GETUTCDATE()),
		(2, 'INLPROGRAMMANAGER', 'Program Manager', 1, GETUTCDATE()),
		(3, 'INLVETTINGCOORDINATOR', 'Vetting Coordinator', 1, GETUTCDATE()),
		(4, 'INLCOURTESYVETTER', 'Courtesy Vetter', 1, GETUTCDATE()),
		(5, 'INLLOGISTICSCOORDINATOR', 'Logisitics Cooridinator', 1, GETUTCDATE()),
		(6, 'INLPOSTADMIN', 'Post Administrator', 1, GETUTCDATE()),
		(7, 'INLAGENCYADMIN', 'Agency Administrator', 1, GETUTCDATE()),
		(8, 'INLGLOBALADMIN', 'GTTS Global Administrator', 1, GETUTCDATE())
END
GO


/*	Turn on constraint			*/
ALTER TABLE users.AppRoles
	CHECK CONSTRAINT [FK_AppRoles_AppUsers_ModifiedByAppUserID]; 
