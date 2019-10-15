 /*
    **************************************************************************
    UnitTypes_Load.sql
    **************************************************************************    
*/
/*  Turn IDENTITY_INSERT ON    */
PRINT 'BEGIN UnitTypes_Load'
SET IDENTITY_INSERT [unitlibrary].[UnitTypes] ON
GO

IF (NOT EXISTS(SELECT * FROM [unitlibrary].[UnitTypes]))
	BEGIN
		/*  INSERT VALUES into the table    */
		INSERT INTO [unitlibrary].[UnitTypes]
				([UnitTypeID]
				,[Name]
				,[Description]
				,[IsActive]         -- DEFAULT TRUE (1)
				,[ModifiedByAppUserID])
			VALUES
				(1, 'Academia', 'An entity that is primarily concerned with the pursuit of research, education, and scholarship.', 1, 1),               
				(2, 'Government', 'An entity that is part of a national, state, or local government.', 1, 1), 
				(3, 'NGO', 'An entity that is not part of a government, is not an academic institution or a news/media organization, and is classified as a non-profit organization.', 1, 1), 
				(4, 'Press', 'An entity that is a news/media organization (newspaper, magazine, broadcast journalist, etc.).', 1, 1),
				(5, 'Private Sector', 'An entity that is privately owned (directly or via stock market shares) and provides goods/services to customers for the purposes of generating profit.', 1, 1)
	END
GO

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [unitlibrary].[UnitTypes] OFF
GO

/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('[unitlibrary].[UnitTypes]', RESEED)
GO 