/*  Load Script Identifier for Build/Publish  */
PRINT 'BEGIN training.TrainingEventGroupMemberTypes_Load'

/*  Turn IDENTITY_INSERT ON    */
SET IDENTITY_INSERT [training].[TrainingEventGroupMemberTypes] ON
GO

/*  Verify that reference table exists and populate with data.  */
IF NOT EXISTS(SELECT * FROM [training].[TrainingEventGroupMemberTypes]) 
	BEGIN
		/*  INSERT VALUES into the table  */
		INSERT INTO [training].[TrainingEventGroupMemberTypes]
				([TrainingEventGroupMemberTypeID]
				,[Name]
				,[IsActive]         -- DEFAULT TRUE (1)
				,[ModifiedByAppUserID])
			VALUES
				(1, 'Instructor', 1, 1),               
				(2, 'Student', 1, 1), 
				(3, 'Other', 1, 1)
	END

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [training].[TrainingEventGroupMemberTypes] OFF
GO

/*  Set new INDENTIY Starting VALUE to maximum column value */
DBCC CHECKIDENT ('[training].[TrainingEventGroupMemberTypes]', RESEED)
GO