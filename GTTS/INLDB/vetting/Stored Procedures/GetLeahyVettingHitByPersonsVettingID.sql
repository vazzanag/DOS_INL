CREATE PROCEDURE [vetting].[GetLeahyVettingHitByPersonsVettingID]
	@PersonsVettingID BIGINT
AS
	SELECT
			LeahyVettingHitID, 
			PersonsVettingID, 
			CaseID, 
			LeahyHitResultID, 
			LeahyHitResult,
			LeahyHitAppliesToID, 
			LeahyHitAppliesTo,
			ViolationTypeID, 
			CertDate, 
			ExpiresDate, 
			Summary,
			ModifiedByAppUserID,
			ModifiedDate
	FROM
		vetting.LeahyVettingHitsView
	WHERE
		PersonsVettingID = @PersonsVettingID;
