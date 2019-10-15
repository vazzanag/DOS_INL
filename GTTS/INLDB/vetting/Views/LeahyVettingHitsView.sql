CREATE VIEW [vetting].[LeahyVettingHitsView]
AS
	SELECT LeahyVettingHitID, 
			PersonsVettingID, 
			CaseID, 
			lvh.LeahyHitResultID, 
			lvhr.[Description] AS LeahyHitResult,
			lvhr.[Code] AS LeahyHitResultCode,
			lvh.LeahyHitAppliesToID, 
			lvhat.[Description] AS LeahyHitAppliesTo,
			ViolationTypeID, 
			CertDate, 
			ExpiresDate, 
			Summary,
			lvh.ModifiedByAppUserID,
			lvh.ModifiedDate
		FROM vetting.LeahyVettingHits lvh 
	LEFT JOIN vetting.VettingLeahyHitResults lvhr ON lvh.LeahyHitResultID = lvhr.LeahyHitResultID 
	LEFT JOIN vetting.VettingLeahyHitAppliesTo lvhat ON lvh.LeahyHitAppliesToID = lvhat.LeahyHitAppliesToID;
