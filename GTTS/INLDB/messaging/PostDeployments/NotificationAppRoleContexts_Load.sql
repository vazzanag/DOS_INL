/*
    **************************************************************************
    NotificationAppRoleContexts_Load.sql
    **************************************************************************    
*/

IF (NOT EXISTS(SELECT * FROM [messaging].[NotificationAppRoleContexts]))
	BEGIN
		/*  INSERT VALUES into the table    */
		INSERT INTO [messaging].[NotificationAppRoleContexts]
				([NotificationMessageID]
				,[AppRoleID]
				,[NotificationAppRoleContextTypeID]
				,[ModifiedByAppUserID])
			VALUES
				(2, 2, 1, 1),				
				(3, 4, 3, 1),				
				(5, 2, 1, 1),
				(6, 2, 1, 1),
				(7, 2, 1, 1),
				(8, 2, 1, 1)

	END
GO