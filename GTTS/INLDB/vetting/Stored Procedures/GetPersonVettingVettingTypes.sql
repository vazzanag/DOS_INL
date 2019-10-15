CREATE PROCEDURE [vetting].[GetPersonVettingVettingTypes]
	@PersonsVettingID BIGINT
AS
BEGIN
    SELECT pv.FirstMiddleNames, pv.LastNames, pv.PersonsVettingID, pv.CourtesyVettingSkipped, 
           pv.CourtesyVettingSkippedComments, pv.VettingTypeCode, pv.VettingTypeID 
      FROM vetting.PersonsVettingVettingTypesView pv
     WHERE PersonsVettingID = @PersonsVettingID;
END;
