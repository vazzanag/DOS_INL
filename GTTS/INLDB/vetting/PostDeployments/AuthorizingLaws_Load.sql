/*  Turn IDENTITY_INSERT ON    */
SET IDENTITY_INSERT [vetting].[AuthorizingLaws] ON
GO

IF (NOT EXISTS(SELECT * FROM [vetting].[AuthorizingLaws]))
	BEGIN
		/*  INSERT VALUES into the table    */
		INSERT INTO [vetting].[AuthorizingLaws]
				   ([AuthorizingLawID]
				   ,[Code]
				   ,[Description]
				   ,[IsActive]
				   ,[ModifiedByAppUserID])
			 VALUES
				   (1, 'AECA', 'Arms Export Control Act',1,1),
				   (2, 'DODAA', 'DOD Annual Appropriations Act',1,1),
				   (3, 'FAA', 'Foreign Assistance Act',1,1)
	END
GO

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [vetting].[AuthorizingLaws] OFF
GO

/*  Set new IDENTITY Starting VALUE */
PRINT '[vetting].[AuthorizingLaws] _Load'
DBCC CHECKIDENT ('[vetting].[AuthorizingLaws]', RESEED)
GO