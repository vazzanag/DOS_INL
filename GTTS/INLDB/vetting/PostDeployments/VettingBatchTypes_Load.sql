/*
    **************************************************************************
    VettingBatchTypes_Load.sql
    **************************************************************************    
*/

PRINT 'BEGIN VettingBatchTypes_Load'

/*  Turn IDENTITY_INSERT ON    */
SET IDENTITY_INSERT [vetting].[VettingBatchTypes] ON
GO

IF (NOT EXISTS(SELECT * FROM [vetting].[VettingBatchTypes]))
	BEGIN
		/*  INSERT VALUES into the table    */
		INSERT INTO [vetting].[VettingBatchTypes]
				([VettingBatchTypeID]
				,[Code]
				,[Description]
				,[IsActive]         -- DEFAULT TRUE (1)
				,[ModifiedByAppUserID])
			VALUES
				(1, 'Courtesy', 'Any local vetting performed by the Post.', 1, 1),               
				(2, 'Leahy', 'Vetting performed by the Department of State Bureau of Democracy, Human Rights, and Labor (DRL).', 1, 1),
				(3, 'N/A', 'No vetting required.', 1, 1)
	END
GO

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [vetting].[VettingBatchTypes] OFF
GO

/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('[vetting].[VettingBatchTypes]', RESEED)
GO