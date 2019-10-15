/*
    **************************************************************************
    VettingHitReferenceSites_Load.sql
    **************************************************************************    
*/

PRINT 'BEGIN VettingHitReferenceSites_Load'

/*  Turn IDENTITY_INSERT ON    */
SET IDENTITY_INSERT [vetting].[VettingHitReferenceSites] ON
GO

IF (NOT EXISTS(SELECT * FROM [vetting].[VettingHitReferenceSites]))
	BEGIN
		/*  INSERT VALUES into the table    */
		INSERT INTO [vetting].[VettingHitReferenceSites]
				([ReferenceSiteID]
				,[Code]
				,[Description]
				,[IsActive]         -- DEFAULT TRUE (1)
				,[ModifiedByAppUserID])
			VALUES
				(1, 'ADIS', 'Arrival and Departure Information System', 1, 1),
				(2, 'CBP', 'Customs Border & Protection', 1, 1),
				(3, 'CIS', 'Citizenship and Immigration Services', 1, 1),
				(4, 'CUS', 'CUS', 1, 1),
				(5, 'DAC', 'Deportable Alien Control', 1, 1),
				(6, 'DACS', 'Deportable Alien Control System', 1, 1),
				(7, 'DEA', 'Drug Enforcement Administration', 1, 1),
				(8, 'DHS', 'Department of Homeland Security', 1, 1),
				(9, 'DPT', 'Department of State', 1, 1),
				(10, 'DSR', 'Diplomatic Security', 1, 1),
				(11, 'ESTA', 'Electronic System for Travel Authorization', 1, 1),
				(12, 'FBI', 'Federal Bureau of Investigation', 1, 1),
				(13, 'ICE', 'Immigration and Customs Enforcement', 1, 1),
				(14, 'INS', 'Immigration and Naturalization Service', 1, 1),
				(15, 'INSOLP', 'INSOLP', 1, 1),
				(16, 'IPL', 'International Police', 1, 1),
				(17, 'REC', 'REC', 1, 1),
				(18, 'OTHER', 'Other', 1, 1)
	END
GO

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [vetting].[VettingHitReferenceSites] OFF
GO

/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('[vetting].[VettingHitReferenceSites]', RESEED)
GO