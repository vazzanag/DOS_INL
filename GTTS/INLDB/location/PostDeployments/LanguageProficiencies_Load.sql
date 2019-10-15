/*  Turn IDENTITY_INSERT ON    */
SET IDENTITY_INSERT [location].[LanguageProficiencies] ON
GO

IF (NOT EXISTS(SELECT * FROM [location].[LanguageProficiencies]))
	BEGIN
		/*  INSERT VALUES into the table    */
		INSERT INTO [location].[LanguageProficiencies]
				([LanguageProficiencyID]
				,[Code]
				,[Description]
				,[ModifiedByAppUserID])
			VALUES
				(1, 'Elementary Proficiency', 'The person is able to satisfy routine travel needs and minimum courtesy requirements', 1),
				(2, 'Limited Working Proficiency', 'The person is able to satisfy routine social demands and limited work requirements', 1),
				(3, 'Minimum Professional Proficiency', 'The person can speak the language with sufficient structural accuracy and vocabulary to participate effectively in most formal and informal conversations on practical, social, and professional topics', 1),
				(4, 'Full Professional Proficiency', 'The person uses the language fluently and accurately on all levels normally pertinent to professional needs', 1),
				(5, 'Native or Bilingual Proficiency', 'The person has speaking proficiency equivalent to that of an educated native speaker', 1),                
				(6, 'None', 'No experience at all with the language', 1)
	END
GO

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [location].[LanguageProficiencies] OFF
GO

/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('[location].[LanguageProficiencies]', RESEED)
GO