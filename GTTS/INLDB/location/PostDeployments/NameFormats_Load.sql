/*  Turn IDENTITY_INSERT ON    */
SET IDENTITY_INSERT [location].[NameFormats] ON
GO

IF (NOT EXISTS(SELECT * FROM [location].[NameFormats]))
	BEGIN
		/*  INSERT VALUES into the table    */
		INSERT INTO [location].[NameFormats]
				([NameFormatID]
				,[NameFormat]
				,[ModifiedByAppUserID])
			VALUES
				(1, N'FirstMiddleNames, LastNames', 1)
	END
GO

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [location].[NameFormats] OFF
GO

/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('[location].[NameFormats]', RESEED)
GO