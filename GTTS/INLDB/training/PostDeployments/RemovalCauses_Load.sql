/*  Load Script Identifier for Build/Publish  */
PRINT 'BEGIN training.RemovalCauses_Load'

/*  Turn IDENTITY_INSERT ON    */
SET IDENTITY_INSERT [training].[RemovalCauses] ON
GO

/*  Verify that reference table exists and populate with data.  */
IF NOT EXISTS(SELECT * FROM [training].[RemovalCauses]) 
	BEGIN
		/*  INSERT VALUES into the table  */
		INSERT INTO [training].[RemovalCauses]
				([RemovalCauseID]
				,[RemovalReasonID]
				,[Description]
				,[IsActive]         -- DEFAULT TRUE (1)
				,[ModifiedByAppUserID])
			VALUES
				(1, 2, 'Personal emergency', 1, 1),               
				(2, 2, 'Illness or death', 1, 1), 
				(3, 2, 'Work-related issues', 1, 1), 
				(4, 4, 'Personal emergency', 1, 1), 
				(5, 4, 'Illness or death', 1, 1), 
				(6, 4, 'Work-related issues', 1, 1)
	END

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [training].[RemovalCauses] OFF
GO

/*  Set new INDENTIY Starting VALUE to maximum column value */
DBCC CHECKIDENT ('[training].[RemovalCauses]', RESEED)
GO