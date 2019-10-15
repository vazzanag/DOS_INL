/*
    **************************************************************************
    VettingHitViolationTypes_Load.sql
    **************************************************************************    
*/

PRINT 'BEGIN VettingHitViolationTypes_Load'

/*  Turn IDENTITY_INSERT ON    */
SET IDENTITY_INSERT [vetting].[VettingHitViolationTypes] ON
GO

IF (NOT EXISTS(SELECT * FROM [vetting].[VettingHitViolationTypes]))
	BEGIN
		/*  INSERT VALUES into the table    */
		INSERT INTO [vetting].[VettingHitViolationTypes]
				([ViolationTypeID]
				,[Code]
				,[Description]
				,[IsActive]         -- DEFAULT TRUE (1)
				,[ModifiedByAppUserID])
			VALUES
				(1, 'GVHR', 'Gross Violation of Human Rights', 1, 1),               
				(2, 'Non-GVHR', 'Not a Gross Violation of Human Rights', 1, 1)
	END
GO

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [vetting].[VettingHitViolationTypes] OFF
GO

/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('[vetting].[VettingHitViolationTypes]', RESEED)
GO