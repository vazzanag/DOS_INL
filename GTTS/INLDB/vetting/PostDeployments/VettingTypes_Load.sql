/*
    **************************************************************************
    VettingTypes_Load.sql
    **************************************************************************    
*/
/*  Turn IDENTITY_INSERT ON    */
SET IDENTITY_INSERT [vetting].[VettingTypes] ON
GO

IF (NOT EXISTS(SELECT * FROM [vetting].[VettingTypes]))
	BEGIN
		/*  INSERT VALUES into the table    */
		INSERT INTO [vetting].[VettingTypes]
				([VettingTypeID]
				,[Code]
				,[Description]
				,[IsActive]         -- DEFAULT TRUE (1)
				,[ModifiedByAppUserID])
			VALUES
				(1, 'POL', 'US Dept. of State Political Office', 1, 1),               
				(2, 'CONS', 'US Dept. of State Consular Office', 1, 1),  
				(3, 'DEA', 'US Drug Enforcement Adminstration', 1, 1),  
				(4, 'LEAHY', 'US Dept. of State Bureau of Democracy, Human Rights and Labor (DRL) INVEST System', 1, 1)
	END
GO

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [vetting].[VettingTypes] OFF
GO

/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('[vetting].[VettingTypes]', RESEED)
GO