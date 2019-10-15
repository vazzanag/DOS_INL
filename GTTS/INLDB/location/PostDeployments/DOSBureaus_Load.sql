/*
    In order to maintain backwards compatibility with migrated data from TTS,
    we need to set the IDENTITY_INSERT property of the table ON before running
	the INSERT statement.  Afterwards, we set the IDENTITY_INSERT property to OFF,
	and set the seed value to the highest IDENTITY value.
*/

/*  Turn IDENTITY_INSERT ON    */
SET IDENTITY_INSERT [location].[DOSBureaus] ON
GO

IF (NOT EXISTS(SELECT * FROM [location].DOSBureaus))
	BEGIN
		/*  INSERT VALUES into the table    */
		INSERT INTO [location].[DOSBureaus]
				([DOSBureauID]
				,[Symbol]
				,[Name]
				,[GeoRegionID]
				,[IsActive]
				,[ModifiedByAppUserID])
			VALUES
				(800482, N'WHA', N'Bureau of Western Hemisphere Affairs', 1, 1, 1),
				(800509, N'EUR', N'Bureau of European & Eurasian Affairs',	2, 1, 1),
				(800549, N'EAP', N'Bureau of East Asian & Pacific Affairs', 3, 1, 1),
				(800568, N'NEA', N'Bureau of Near Eastern Affairs', 4, 1, 1),
				(800593, N'SCA', N'Bureau of South & Central Asian Affairs', 6, 1, 1),
				(800604, N'AF', N'Bureau of African Affairs', 5, 1, 1),
				(800618, N'IO', N'Bureau of Int''l Organization Affairs', 99, 1, 1),
				(802138, N'EB', N'Bureau of Economic and Business Affairs', 99, 1, 1)
	END
GO

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [location].[DOSBureaus] OFF
GO

/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('[location].[DOSBureaus]', RESEED)
GO