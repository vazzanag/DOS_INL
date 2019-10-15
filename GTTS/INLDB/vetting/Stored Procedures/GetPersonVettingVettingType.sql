CREATE PROCEDURE [vetting].[GetPersonVettingVettingType]
	@PersonsVettingID BIGINT,
	@VettingTypeID INT
AS
BEGIN
	IF EXISTS(SELECT * FROM vetting.PersonsVettingVettingTypesView pv WHERE PersonsVettingID = @PersonsVettingID AND VettingTypeID = @VettingTypeID)
	BEGIN
		SELECT  pv.FirstMiddleNames, pv.LastNames, pv.PersonsVettingID,  pv.CourtesyVettingSkipped, pv.CourtesyVettingSkippedComments, pv.VettingTypeCode, pv.VettingTypeID 
			FROM vetting.PersonsVettingVettingTypesView pv
		WHERE PersonsVettingID = @PersonsVettingID AND VettingTypeID = @VettingTypeID 
	END
	ELSE
	BEGIN
		SELECT  pv.FirstMiddleNames, pv.LastNames, pv.PersonsVettingID, pv.DOB, NULL AS CourtesyVettingSkipped, NULL AS CourtesyVettingSkippedComments, vtypes.Code as VettingTypeCode, vtypes.VettingTypeID  
			FROM vetting.PersonsVettingView pv
		CROSS JOIN vetting.VettingTypes vtypes 
			WHERE pv.PersonsVettingID = @PersonsVettingID and vtypes.VettingTypeID = @VettingTypeID
	END
END

