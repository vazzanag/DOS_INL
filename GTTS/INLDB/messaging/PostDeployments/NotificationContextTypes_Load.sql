/*
    **************************************************************************
    NotificationContextTypes_Load.sql
    **************************************************************************    
*/
/*  Turn IDENTITY_INSERT ON    */
SET IDENTITY_INSERT [messaging].[NotificationContextTypes] ON
GO

IF (NOT EXISTS(SELECT * FROM [messaging].[NotificationContextTypes]))
	BEGIN
		/*  INSERT VALUES into the table    */
		INSERT INTO [messaging].[NotificationContextTypes]
				([NotificationContextTypeID]
				,[Name]
				,[IsActive]         -- DEFAULT TRUE (1)
				,[ModifiedByAppUserID])
			VALUES
				(1, 'Event', 1, 1),               
				(2, 'Vetting', 1, 1);
	END
GO

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [messaging].[NotificationContextTypes] OFF
GO

/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('[messaging].[NotificationContextTypes]', RESEED)
GO