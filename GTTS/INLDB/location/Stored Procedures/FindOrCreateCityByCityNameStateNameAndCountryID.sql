CREATE PROCEDURE [location].[FindOrCreateCityByCityNameStateNameAndCountryID]
	@CityName NVARCHAR(150),
	@StateName NVARCHAR(150),
	@CountryID NVARCHAR(150),
	@ModifiedbyAppUserID INT
AS
BEGIN
	DECLARE @StateID INT, @CityID INT
	IF NOT EXISTS(SELECT TOP 1 * FROM [location].CitiesView
				WHERE
	 				UPPER(REPLACE(REPLACE(@CityName, ' ', ''), '.', '')) COLLATE Latin1_general_CI_AI = UPPER(REPLACE(REPLACE(CityName, ' ', ''), '.', '')) COLLATE Latin1_general_CI_AI
				AND
					UPPER(REPLACE(REPLACE(StateName, ' ', ''), '.', '')) COLLATE Latin1_general_CI_AI = 
							CASE WHEN @StateName IS NULL OR @StateName = '' THEN UPPER(REPLACE(REPLACE(StateName, ' ', ''), '.', '')) COLLATE Latin1_general_CI_AI
							ELSE UPPER(REPLACE(REPLACE(@StateName, ' ', ''), '.', '')) COLLATE Latin1_general_CI_AI END
				AND	CountryID = @CountryID)
	BEGIN
		--Check state exists in the country
		IF NOT EXISTS(SELECT * FROM [location].States WHERE UPPER(REPLACE(REPLACE(StateName, ' ', ''), '.', '')) COLLATE Latin1_general_CI_AI = UPPER(REPLACE(REPLACE(@StateName, ' ', ''), '.', '')) COLLATE Latin1_general_CI_AI 
				AND	CountryID = @CountryID)
		BEGIN

			--Add State to country
			INSERT INTO [location].[States](CountryID, StateName, IsActive, ModifiedByAppUserID)
				VALUES
			(@CountryID, @StateName, 1, @ModifiedbyAppUserID);
			SELECT @StateID = @@IDENTITY
		END
		ELSE
		BEGIN
			SELECT @StateID = StateID FROM [location].[States] WHERE UPPER(REPLACE(REPLACE(StateName, ' ', ''), '.', '')) COLLATE Latin1_general_CI_AI = UPPER(REPLACE(REPLACE(@StateName, ' ', ''), '.', '')) COLLATE Latin1_general_CI_AI 
				AND	CountryID = @CountryID
		END

		-- check whether city exists
		IF NOT EXISTS(SELECT * FROM [location].Cities WHERE UPPER(REPLACE(REPLACE(@CityName, ' ', ''), '.', '')) COLLATE Latin1_general_CI_AI = UPPER(REPLACE(REPLACE(CityName, ' ', ''), '.', '')) COLLATE Latin1_general_CI_AI AND StateID = @StateID)
		BEGIN
			INSERT INTO [location].[Cities] ([CityName], [StateID], [IsActive], [ModifiedByAppUserID]) 
				VALUES
			(@CityName, @StateID, 1, 1);
			SELECT @CityID = @@IDENTITY
		END
		ELSE
		BEGIN
			SELECT @CityID = CityID FROM [location].Cities WHERE UPPER(REPLACE(REPLACE(@CityName, ' ', ''), '.', '')) COLLATE Latin1_general_CI_AI = UPPER(REPLACE(REPLACE(CityName, ' ', ''), '.', '')) COLLATE Latin1_general_CI_AI AND StateID = @StateID
		END 
		SELECT TOP 1 CityID, CityName, StateID, StateName, StateCodeA2, StateAbbreviation, StateINKCode, CountryID, CountryName, GENCCodeA2, CountryAbbreviation, CountryINKCode
			FROM [location].CitiesView WHERE CityID = @CityID
	END
	ELSE
	BEGIN
		SELECT TOP 1 CityID, CityName, StateID, StateName, StateCodeA2, StateAbbreviation, StateINKCode, CountryID, CountryName, GENCCodeA2, CountryAbbreviation, CountryINKCode
			FROM [location].CitiesView
		WHERE
	 		UPPER(REPLACE(REPLACE(@CityName, ' ', ''), '.', '')) COLLATE Latin1_general_CI_AI = UPPER(REPLACE(REPLACE(CityName, ' ', ''), '.', '')) COLLATE Latin1_general_CI_AI
		AND
			UPPER(REPLACE(REPLACE(StateName, ' ', ''), '.', '')) COLLATE Latin1_general_CI_AI = 
												CASE WHEN @StateName IS NULL OR @StateName = '' THEN UPPER(REPLACE(REPLACE(StateName, ' ', ''), '.', '')) COLLATE Latin1_general_CI_AI
												ELSE UPPER(REPLACE(REPLACE(@StateName, ' ', ''), '.', '')) COLLATE Latin1_general_CI_AI END
		AND	CountryID = @CountryID
	END
END
