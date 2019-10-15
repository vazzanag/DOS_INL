CREATE PROCEDURE [persons].[GetRanksByCountryID]
	@CountryID INT
AS
	BEGIN
		SELECT RankID, RankName, CountryID
		  FROM persons.RanksView r
		 WHERE r.CountryID = @CountryID
	END