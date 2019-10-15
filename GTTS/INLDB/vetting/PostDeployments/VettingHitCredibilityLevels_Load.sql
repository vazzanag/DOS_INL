/*
    **************************************************************************
    VettingHitCredibilityLevels_Load.sql
    **************************************************************************    
*/

PRINT 'BEGIN VettingHitCredibilityLevels_Load'

/*  Turn IDENTITY_INSERT ON    */
SET IDENTITY_INSERT [vetting].[VettingHitCredibilityLevels] ON
GO

IF (NOT EXISTS(SELECT * FROM [vetting].[VettingHitCredibilityLevels]))
	BEGIN
		/*  INSERT VALUES into the table    */
		INSERT INTO [vetting].[VettingHitCredibilityLevels]
				(CredibilityLevelID
				,[Code]
				,[Description]
				,[IsActive]         -- DEFAULT TRUE (1)
				,[ModifiedByAppUserID])
			VALUES
				(1, 'Low', 'Low or Minimal level of credibility', 1, 1),               
				(2, 'Medium', 'Medium or Moderate level of credibility', 1, 1),  
				(3, 'High', 'High or Superior level of credibility', 1, 1)
	END
GO

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [vetting].[VettingHitCredibilityLevels] OFF
GO

/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('[vetting].[VettingHitCredibilityLevels]', RESEED)
GO