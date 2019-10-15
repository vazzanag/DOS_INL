CREATE PROCEDURE [vetting].[GetPersonsHistoricalVettingHits]
	@PersonsVettingID BIGINT,
	@VettingTypeID SMALLINT
AS
BEGIN
	DECLARE @PersonID BIGINT
	SELECT @PersonID = PersonID FROM vetting.PersonsVettingView WHERE PersonsVettingID = @PersonsVettingID

	SELECT *
		FROM [vetting].PersonVettingHitsView vt 
	INNER JOIN vetting.PersonsVettingView pvt ON vt.PersonsVettingID = pvt.PersonsVettingID
		WHERE pvt.PersonID = @PersonID 
			AND vt.VettingTypeID = @VettingTypeID 
			AND vt.PersonsVettingID <> @PersonsVettingID  
END