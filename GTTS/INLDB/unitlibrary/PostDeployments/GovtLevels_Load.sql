 /*
    **************************************************************************
    GovtLevels_Load.sql
    **************************************************************************    
*/
/*  Turn IDENTITY_INSERT ON    */
PRINT 'BEGIN GovtLevels_Load'
SET IDENTITY_INSERT [unitlibrary].[GovtLevels] ON
GO

IF (NOT EXISTS(SELECT * FROM [unitlibrary].[GovtLevels]))
	BEGIN
		/*  INSERT VALUES into the table    */
		INSERT INTO [unitlibrary].[GovtLevels]
				([GovtLevelID]
				,[Name]
				,[Description]
				,[IsActive]         -- DEFAULT TRUE (1)
				,[ModifiedByAppUserID])
			VALUES
				(1, 'Country', 'Highest govermental level.  Represents a region of land defined by geographical features or political boundaries.  All organizations regardless of their organizational structure fall under the Country root of the org tree.', 1, 1),               
				(2, 'Federal', 'Governmental level that represents the national government of a country.', 1, 1), 
				(3, 'State', 'The second highest govermental level which represents a defined territory within a country.', 1, 1), 
				(4, 'City/Municipal', 'The lowest or local governmental level which represents a defined county, city, or town within a state.', 1, 1), 
				(5, 'N/A', 'Not Applicable', 1, 1)
	END
GO

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [unitlibrary].[GovtLevels] OFF
GO

/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('[unitlibrary].[GovtLevels]', RESEED)
GO