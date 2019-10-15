CREATE PROCEDURE [vetting].[GetPersonVettings]
	@PersonID BIGINT
AS
BEGIN
	SELECT  PersonID, PersonsVettingID, TrackingNumber, BatchID, VettingStatus, VettingValidStartDate, VettingValidEndDate 
		FROM vetting.PersonsVettingView 
	  WHERE PersonID = @PersonID
END

