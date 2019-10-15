CREATE PROCEDURE [location].[FindCityByCityNameStateNameAndCountryName]
	@CityName NVARCHAR(150),
	@StateName NVARCHAR(150),
	@CountryName NVARCHAR(150)
AS
BEGIN
	SELECT 
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
		UPPER(REPLACE(REPLACE(@StateName, ' ', ''), '.', '')) COLLATE Latin1_general_CI_AI = UPPER(REPLACE(REPLACE(StateName, ' ', ''), '.', '')) COLLATE Latin1_general_CI_AI
		AND
		UPPER(REPLACE(REPLACE(@CountryName, ' ', ''), '.', '')) COLLATE Latin1_general_CI_AI = UPPER(REPLACE(REPLACE(CountryName, ' ', ''), '.', '')) COLLATE Latin1_general_CI_AI
END
