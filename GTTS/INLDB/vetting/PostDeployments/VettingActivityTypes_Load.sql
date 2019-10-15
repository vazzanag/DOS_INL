  /*
    **************************************************************************
    VettingActivityTypes_Load.sql
    **************************************************************************    
*/
/*  Turn IDENTITY_INSERT ON    */
SET IDENTITY_INSERT [vetting].[VettingActivityTypes] ON
GO

IF (NOT EXISTS(SELECT * FROM [vetting].[VettingActivityTypes]))
	BEGIN
		/*  INSERT VALUES into the table    */
		INSERT INTO [vetting].[VettingActivityTypes]
				([VettingActivityTypeID]
				,[Name]
				,[Description]
				,[IsActive]         -- DEFAULT TRUE (1)
				,[ModifiedByAppUserID])
			VALUES
				(1, 'Military', 'Activity is a funtion of military duties (national defense, counter-insurgency, etc.).', 1, 1),               
				(2, 'Police', 'Activity is a function of law enforcement duties.', 1, 1), 
				(3, 'Other', 'Activity is a function of non-military and non-police duties (intelligence, counter-terrorism, corrections).', 1, 1), 
				(4, 'N/A', 'Not Applicable', 1, 1)
	END
GO

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [vetting].[VettingActivityTypes] OFF
GO

/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('[vetting].[VettingActivityTypes]', RESEED)
GO 