/*  Turn IDENTITY_INSERT ON    */
SET IDENTITY_INSERT [persons].[JobTitles] ON
GO

IF (NOT EXISTS(SELECT * FROM [persons].[JobTitles]))
	BEGIN
		/*  INSERT VALUES into the table    */
		-- These values are temporary until we get an approved list from MXC.
		INSERT INTO [persons].[JobTitles]
				([JobTitleID]
				,[CountryID]
				,[JobTitleCode]
				,[JobTitleLocalLanguage]
				,[JobTitleEnglish]
				,[IsActive]
				,[ModifiedByAppUserID])
			VALUES	-- CountryID, Code, TitleLocalLang, TitleEnglish
				(1, 2254, 'CEO', 'Chief Executive Officer', 'Chief Executive Officer', 1, 1),
				(2, 2254, 'DIR', 'Director', 'Director', 1, 1),
				(3, 2254, 'MGR', 'Manager', 'Manager', 1, 1),
				(4, 2254, 'EXECASSIST', 'Executive Assistant', 'Executive Assistant', 1, 1),
				(5, 2254, 'TECHDIR', 'Technical Director', 'Technical Director', 1, 1),
				(6, 2254, 'OPSDIR', 'Operations Director', 'Operations Director', 1, 1),
				(7, 2254, 'ADMINDIR', 'Administrative Director', 'Administrative Director', 1, 1),
				(8, 2254, 'DIRGEN', 'Director General', 'Director General', 1, 1),
				(9, 2254, 'DIVDIR', 'Division Chief', 'Division Chief', 1, 1),
				(10, 2254, 'UNITDIR', 'Unit Chief', 'Unit Chief', 1, 1),
				(11, 2254, 'REGDIR', 'Regional Director', 'Regional Director', 1, 1),
				(12, 2159, 'CEO', 'Director Ejecutivo', 'Chief Executive Officer', 1, 1),
				(13, 2159, 'DIR', 'Director', 'Director', 1, 1),
				(14, 2159, 'MGR', 'Gerente', 'Manager', 1, 1),
				(15, 2159, 'EXECASSIST', 'Asistente Ejecutiva', 'Executive Assistant', 1, 1),
				(16, 2159, 'TECHDIR', 'Director Técnico', 'Technical Director', 1, 1),
				(17, 2159, 'OPSDIR', 'Director de Operaciones', 'Operations Director', 1, 1),
				(18, 2159, 'ADMINDIR', 'Director Administrativo', 'Administrative Director', 1, 1),
				(19, 2159, 'DIRGEN', 'Director General', 'Director General', 1, 1),
				(20, 2159, 'DIVDIR', 'Jefe de Division', 'Division Chief', 1, 1),
				(21, 2159, 'UNITDIR', 'Jefe de Unidad', 'Unit Chief', 1, 1),
				(22, 2159, 'REGDIR', 'Director Regional', 'Regional Director', 1, 1)
	END
GO

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [persons].[JobTitles] OFF
GO

/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('[persons].[JobTitles]', RESEED)
GO