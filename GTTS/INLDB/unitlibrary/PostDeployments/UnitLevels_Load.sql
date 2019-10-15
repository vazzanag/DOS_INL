 /*
    **************************************************************************
    UnitLevels_Load.sql
    **************************************************************************    
*/
/*  Turn IDENTITY_INSERT ON    */
PRINT 'BEGIN UnitLevels_Load'
SET IDENTITY_INSERT [unitlibrary].[UnitLevels] ON
GO

IF (NOT EXISTS(SELECT * FROM [unitlibrary].[UnitLevels]))
	BEGIN
		/*  INSERT VALUES into the table    */
		INSERT INTO [unitlibrary].[UnitLevels]
				([UnitLevelID]
				,[Name]
				,[Description]
                ,[Level]
				,[IsActive]         -- DEFAULT TRUE (1)
				,[ModifiedByAppUserID])
			VALUES
				(1, 'Branch', 'The highest level of organization under a Country Unit.  For example: the Executive, Legislative, & Judical branches of the United States, Senate or House of Representatives, or a private entity such as a company or academic institution.', 1, 1, 1), 
                (2, 'Department', 'Highest level of organized unit under a Branch.  For example: Executive Offices or Cabinet level units.', 1, 1, 1),               
				(3, 'Agency', 'Next highest level of organized unit under a Branch or Department.  For example, an independent governmental agency that reports to a Branch level unit or a Department level unit.', 2, 1, 1), 
				(4, 'Bureau', 'A 3rd level unit under a 1st or 2nd level unit.', 3, 1, 1), 
				(5, 'Office', 'A 4th level unit under a 1st, 2nd, or 3rd level unit.', 4, 1, 1), 
				(6, 'Division', 'A 5th level unit under a 1st, 2nd, 3rd, or 4th level unit.', 5, 1, 1), 
				(7, 'Section', 'A 6th level unit under a 1st, 2nd, 3rd, 4th, or 5th level unit.', 6, 1, 1), 
				(8, 'Section Unit', 'A 7th level unit under a 1st, 2nd, 3rd, 4th, 5th, or 6th level unit.', 7, 1, 1), 
				(9, 'N/A', 'Not Applicable', 0, 1, 1)
	END
GO

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [unitlibrary].[UnitLevels] OFF
GO

/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('[unitlibrary].[UnitLevels]', RESEED)
GO 