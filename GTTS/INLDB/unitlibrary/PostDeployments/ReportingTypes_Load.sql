 /*
    **************************************************************************
    ReportingTypes_Load.sql
    **************************************************************************    
*/
/*  Turn IDENTITY_INSERT ON    */
PRINT 'BEGIN ReportingTypes_Load'
SET IDENTITY_INSERT [unitlibrary].[ReportingTypes] ON
GO

IF (NOT EXISTS(SELECT * FROM [unitlibrary].[ReportingTypes]))
	BEGIN
		/*  INSERT VALUES into the table    */
		INSERT INTO [unitlibrary].[ReportingTypes]
				([ReportingTypeID]
				,[Name]
				,[Description]
				,[CountryID]
				,[IsActive]         -- DEFAULT TRUE (1)
				,[ModifiedByAppUserID])
			VALUES
				(1, 'Prison', NULL, 2159, 1, 1),
				(2, 'Prison Academy', NULL, 2159, 1, 1),
				(3, 'Police Academy', NULL, 2159, 1, 1),
				(4, 'Police Department', NULL, 2159, 1, 1),
				(5, 'K9 Unit', NULL, 2159, 1, 1),
				(6, 'Courtroom', NULL, 2159, 1, 1),
				(7, 'Tribunal', NULL, 2159, 1, 1),
				(8, 'Drug Treatment Court', NULL, 2159, 1, 1),
				(9, 'Women''s Justice Center', NULL, 2159, 1, 1),
				(10, 'Confidence Control Center', NULL, 2159, 1, 1),
				(11, 'C4 Center', NULL, 2159, 1, 1),
				(12, 'Forensic Laboratory', NULL, 2159, 1, 1),
				(13, 'Airport', NULL, 2159, 1, 1),
				(14, 'Seaport', NULL, 2159, 1, 1),
				(15, 'Northern Border POE', NULL, 2159, 1, 1),
				(16, 'Southern Border POE', NULL, 2159, 1, 1),
				(17, 'Anti-Kidnapping Unit', NULL, 2159, 1, 1),
				(18, 'Air Wing', NULL, 2159, 1, 1),
				(19, 'Other Fixed Internal Checkpoint', NULL, 2159, 1, 1),
				(20, 'Isthmus of Tehuantepec Checkpoint', NULL, 2159, 0, 1),	-- Made Inactive to remove value from GTTS while keeping it in for TTS migration purposes.
				(21, 'Law Enforcement Analytical Unit', NULL, 2159, 1, 1),
				(22, 'Internal Affairs Unit', NULL, 2159, 1, 1),
				(23, 'Anti-Gang Unit', NULL, 2159, 1, 1)
	END
GO

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [unitlibrary].[ReportingTypes] OFF
GO

/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('[unitlibrary].[ReportingTypes]', RESEED)
GO