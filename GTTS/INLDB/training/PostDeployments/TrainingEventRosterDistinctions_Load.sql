/*
    **************************************************************************
    TrainingEventRosterDistinctions_Load.sql
    **************************************************************************    
*/
/*  Turn IDENTITY_INSERT ON    */
PRINT 'BEGIN TrainingEventRosterDistinctions_Load'
SET IDENTITY_INSERT [training].[TrainingEventRosterDistinctions] ON
GO

IF (NOT EXISTS(SELECT * FROM [training].[TrainingEventRosterDistinctions]))
	BEGIN
		/*  INSERT VALUES into the table    */
		INSERT INTO [training].[TrainingEventRosterDistinctions]
				([TrainingEventRosterDistinctionID]
                ,[PostID]
				,[Code]
				,[Description]
				,[IsActive]         -- DEFAULT TRUE (1)
				,[ModifiedByAppUserID])
			VALUES
				(1, NULL, 'Key Participant', 'Participant contributed significantly to the Training Event.', 1, 1),
				(2, NULL, 'Unsatisfactory', 'Participant performed at a subpar level and was not a contributor to the success of the Training Event.', 1, 1)
	END
GO

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [training].[TrainingEventRosterDistinctions] OFF
GO

/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('[training].[TrainingEventRosterDistinctions]', RESEED)
GO