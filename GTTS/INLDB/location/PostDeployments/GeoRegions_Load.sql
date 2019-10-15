/*
    In order to maintain backwards compatibility with migrated data from TTS,
    we need to set the IDENTITY_INSERT property of the table ON before running
	the INSERT statement.  Afterwards, we set the IDENTITY_INSERT property to OFF,
	and set the seed value to the highest IDENTITY value.
*/

/*  Turn IDENTITY_INSERT ON    */
SET IDENTITY_INSERT [location].[GeoRegions] ON
GO

IF (NOT EXISTS(SELECT * FROM [location].[GeoRegions]))
	BEGIN
		/*  INSERT VALUES into the table    */
		INSERT INTO [location].[GeoRegions]
				   ([GeoRegionID]
				   ,[Name]
				   ,[Description]
				   ,[IsActive]
				   ,[ModifiedByAppUserID])
			 VALUES
				(1, N'Western Hemisphere', N'North, Central, and South America and surrounding islands, including Bermuda, excluding Greenland', 1, 1),
				(2, N'Europe & Eurasia', N'Continental Europe, UK, Scandanavia, Eastern Europe, and Russia', 1, 1),
				(3, N'East Asia & Pacific', N'China, Mongolia, Japan, SE Asia, Australia, Pacific islands', 1, 1),
				(4, N'Near East', N'Middle East, North Coast of Africa', 1, 1),
				(5, N'Africa', N'Continental Africa and surrounding islands', 1, 1),
				(6, N'South & Central Asia', N'India and surrounding countries, Central Asia, Indian Ocean islands', 1, 1),
				(99, N'USA & US Territories', N'US including continental U.S., Alaska, Hawaii and US Territories', 1, 1)
	END
GO

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [location].[GeoRegions] OFF
GO

/*  Set new INDENTIY Starting VALUE to maximum column value */
DBCC CHECKIDENT ('[location].[GeoRegions]', RESEED)
GO