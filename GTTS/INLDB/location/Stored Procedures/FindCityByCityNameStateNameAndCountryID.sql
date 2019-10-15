CREATE PROCEDURE [location].[FindCityByCityNameStateNameAndCountryID]
	@CityName NVARCHAR(150),
	@StateName NVARCHAR(150),
	@CountryID NVARCHAR(150)
AS
BEGIN
	SELECT TOP 1
		CityID,
		CityName, 
        StateID,
		StateName,
		StateCodeA2,
		StateAbbreviation,
		StateINKCode,
		CountryID, 
		CountryName,
		GENCCodeA2,
		CountryAbbreviation,
		CountryINKCode
	FROM 
		[location].CitiesView
	WHERE
	 	UPPER(REPLACE(REPLACE(@CityName, ' ', ''), '.', '')) COLLATE Latin1_general_CI_AI = UPPER(REPLACE(REPLACE(CityName, ' ', ''), '.', '')) COLLATE Latin1_general_CI_AI
		AND
		UPPER(REPLACE(REPLACE(StateName, ' ', ''), '.', '')) COLLATE Latin1_general_CI_AI = 
												CASE WHEN @StateName IS NULL OR @StateName = '' THEN UPPER(REPLACE(REPLACE(StateName, ' ', ''), '.', '')) COLLATE Latin1_general_CI_AI
												ELSE UPPER(REPLACE(REPLACE(@StateName, ' ', ''), '.', '')) COLLATE Latin1_general_CI_AI END
		AND
		CountryID = @CountryID
END
