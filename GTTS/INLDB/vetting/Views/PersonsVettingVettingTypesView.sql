CREATE VIEW [vetting].[PersonsVettingVettingTypesView]
AS 
	SELECT p.FirstMiddleNames, p.LastNames, p.DOB, pv.PersonsVettingID, vtypes.VettingTypeID, vtypes.Code as VettingTypeCode, 
		vt.CourtesyVettingSkipped, vt.CourtesyVettingSkippedComments, vt.HitResultID, vt.HitResultDetails, r.Code as HitResultCode,
		CASE WHEN ISNULL((SELECT TOP 1 pvt.VettingHitID 
				   FROM vetting.VettingHits pvt 
				   WHERE pv.PersonsVettingID = pvt.PersonsVettingID 
				   AND vtypes.VettingTypeID = pvt.VettingTypeID),0) = 0 THEN 0 
			ELSE 1 END HasHitDataInTable
	FROM vetting.PersonsVetting pv
	INNER JOIN persons.PersonsUnitLibraryInfo u ON pv.PersonsUnitLibraryInfoID = u.PersonsUnitLibraryInfoID 
	INNER JOIN persons.Persons p ON u.PersonID = p.PersonID
	INNER JOIN vetting.PersonsVettingVettingTypes vt  ON pv.PersonsVettingID = vt.PersonsVettingID
	INNER JOIN vetting.VettingTypes vtypes ON vt.VettingTypeID = vtypes.VettingTypeID
	LEFT JOIN vetting.VettingHitResults r on vt.HitResultID = r.HitResultID
	OUTER APPLY
			(
				SELECT top 1 pvt.PersonsVettingID as HitID
				FROM vetting.VettingHits pvt
				WHERE  pv.PersonsVettingID = pvt.PersonsVettingID AND vtypes.VettingTypeID = pvt.VettingTypeID
			) AS vh