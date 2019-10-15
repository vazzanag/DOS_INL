/*
    **************************************************************************
    NotificationAppRoleContextTypes_Load.sql
    **************************************************************************    
*/
/*  Turn IDENTITY_INSERT ON    */
SET IDENTITY_INSERT [messaging].[NotificationAppRoleContextTypes] ON
GO

IF (NOT EXISTS(SELECT * FROM [messaging].[NotificationAppRoleContextTypes]))
	BEGIN
		/*  INSERT VALUES into the table    */
		INSERT INTO [messaging].[NotificationAppRoleContextTypes]
				(NotificationAppRoleContextTypeID,
                Code
				,[ModifiedByAppUserID])
			VALUES
                (1, 'TRAININGEVENT', 1),
                (2, 'VETTING', 1),
                (3, 'COURTESYVETTING', 1);
	END
GO

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [messaging].[NotificationAppRoleContextTypes] OFF
GO

/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('[messaging].[NotificationAppRoleContextTypes]', RESEED)
GO