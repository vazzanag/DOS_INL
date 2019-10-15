/*  Turn IDENTITY_INSERT ON    */
SET IDENTITY_INSERT [persons].[EducationLevels] ON
GO

IF (NOT EXISTS(SELECT * FROM [persons].[EducationLevels]))
	BEGIN
		/*  INSERT VALUES into the table    */
		INSERT INTO [persons].[EducationLevels]
				([EducationLevelID]
				,[Code]
				,[Description]
				,[ModifiedByAppUserID])
			VALUES
				(1, 'Elementary', 'Basic/Primary education', 1),
				(2, 'Middle School', 'Secondary level of education before High School', 1),
				(3, 'High School', 'High School or College Prepatory', 1),
				(4, 'Technical School', 'Technical or Tradecraft school', 1),
				(5, 'University', 'College or University', 1),
				(6, 'Postgraduate Studies', 'Graduate, Doctorate, Post-Doctorate, Medical, or Law School', 1),                
				(7, 'Unknown', 'Education level is unknown', 1)
	END
GO

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [persons].[EducationLevels] OFF
GO

/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('[persons].[EducationLevels]', RESEED)
GO