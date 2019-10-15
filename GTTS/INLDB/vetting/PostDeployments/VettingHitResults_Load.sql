/*
    **************************************************************************
    VettingHitResults_Load.sql
    **************************************************************************    
*/

PRINT 'BEGIN VettingHitResults_Load'

/*  Turn IDENTITY_INSERT ON    */
SET IDENTITY_INSERT [vetting].[VettingHitResults] ON
GO

IF (NOT EXISTS(SELECT * FROM [vetting].[VettingHitResults]))
	BEGIN
		/*  INSERT VALUES into the table    */
		INSERT INTO [vetting].[VettingHitResults]
				([HitResultID]
				,[Code]
				,[Description]
				,[IsActive]         -- DEFAULT TRUE (1)
				,[ModifiedByAppUserID])
			VALUES
				(1, 'No Match', 'No biodata matches', 1, 1),               
				(2, 'Possible Match', 'Some but not all biodata matches', 1, 1),  
				(3, 'Direct Match', 'Perfect biodata match', 1, 1)            
	END
GO

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [vetting].[VettingHitResults] OFF
GO

/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('[vetting].[VettingHitResults]', RESEED)
GO