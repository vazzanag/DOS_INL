CREATE PROCEDURE [vetting].[GetPersonsVettingHits]
	@PersonsVettingID BIGINT,
	@VettingTypeID SMALLINT
AS
	SELECT *
		FROM [vetting].PersonVettingHitsView vt 
			WHERE PersonsVettingID = @PersonsVettingID and VettingTypeID = @VettingTypeID


