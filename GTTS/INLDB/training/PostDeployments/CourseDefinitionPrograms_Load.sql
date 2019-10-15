/*
    **************************************************************************
    CourseDefinitionPrograms_Load.sql
    **************************************************************************    
*/
/*  Turn IDENTITY_INSERT ON    */
PRINT 'BEGIN CourseDefinitionPrograms_Load'
SET IDENTITY_INSERT [training].[CourseDefinitionPrograms] ON
GO

IF (NOT EXISTS(SELECT * FROM [training].[CourseDefinitionPrograms]))
	BEGIN
		/*  INSERT VALUES into the table    */
		INSERT INTO [training].[CourseDefinitionPrograms]
				([CourseDefinitionProgramID]
                ,[PostID]
				,[Code]
				,[Description]
				,[IsActive]         -- DEFAULT TRUE (1)
				,[ModifiedByAppUserID])
			VALUES
				(1, NULL, 'Corrections', '', 1, 1),
				(2, NULL, 'Police Professionalism', '', 1, 1)
	END
GO

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [training].[CourseDefinitionPrograms] OFF
GO

/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('[training].[CourseDefinitionPrograms]', RESEED)
GO