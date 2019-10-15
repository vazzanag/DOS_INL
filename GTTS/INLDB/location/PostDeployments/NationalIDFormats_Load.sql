/*  Turn IDENTITY_INSERT ON    */
SET IDENTITY_INSERT [location].[NationalIDFormats] ON
GO

IF (NOT EXISTS(SELECT * FROM [location].[NationalIDFormats]))
	BEGIN
		/*  INSERT VALUES into the table    */
		INSERT INTO [location].[NationalIDFormats]
				([NationalIDFormatID]
                ,[CountryID]                
				,[RegExCode]
				,[ModifiedByAppUserID])
			VALUES
				-- (1, 2159, N'^[a-zA-Z]{4}((\d{2}((0[13578]|1[02])(0[1-9]|[12]\d|3[01])|(0[13456789]|1[012])(0[1-9]|[12]\d|30)|02(0[1-9]|1\d|2[0-8])))|([02468][048]|[13579][26])0229)(H|M)(AS|BC|BS|CC|CL|CM|CS|CH|DF|DG|GT|GR|HG|JC|MC|MN|MS|NT|NL|OC|PL|QT|QR|SP|SL|SR|TC|TS|TL|VZ|YN|ZS|SM|NE)([a-zA-Z]{3})([a-zA-Z0-9\s]{1})\d{1}$+', 1)
				(1, 2159, N'xxxxx', 1)
	END
GO

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [location].[NationalIDFormats] OFF
GO

/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('[location].[NationalIDFormats]', RESEED)
GO