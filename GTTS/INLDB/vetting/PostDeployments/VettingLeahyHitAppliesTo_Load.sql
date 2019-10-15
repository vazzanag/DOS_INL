/*
    **************************************************************************
    VettingLeahyHitAppliesTo_Load.sql
    **************************************************************************    
*/

PRINT 'BEGIN VettingLeahyHitAppliesTo_Load'

/*  Turn IDENTITY_INSERT ON    */
SET IDENTITY_INSERT [vetting].[VettingLeahyHitAppliesTo] ON
GO

IF (NOT EXISTS(SELECT * FROM [vetting].[VettingLeahyHitAppliesTo]))
	BEGIN
		/*  INSERT VALUES into the table    */
		INSERT INTO [vetting].[VettingLeahyHitAppliesTo]
				([LeahyHitAppliesToID]
				,[Code]
				,[Description]
				,[IsActive]         -- DEFAULT TRUE (1)
				,[ModifiedByAppUserID])
			VALUES
				(1, 'Individual', 'Leahy Hit applies to a specific individual.', 1, 1),               
				(2, 'Unit', 'Leahy Hit applies to a specific unit.', 1, 1), 
				(3, 'Both', 'Leahy Hit applies to a specific individual AND a specific unit.', 1, 1)
	END
GO

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [vetting].[VettingLeahyHitAppliesTo] OFF
GO

/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('[vetting].[VettingLeahyHitAppliesTo]', RESEED)
GO