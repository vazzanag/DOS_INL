CREATE VIEW [vetting].[PersonsVettingView]
AS
SELECT pv.PersonsVettingID
    ,u.PersonsUnitLibraryInfoID
	,p.FirstMiddleNames
	,p.LastNames
	,p.DOB
	,p.Gender
	,p.PersonID
	,p.NationalID
	,p.POBCityID
	,c.CityName AS POBCityName
	,st.StateID AS POBStateID
	,st.StateName AS POBStateName
	,st.CountryID AS POBCountryID
	,cn.CountryName AS POBCountryName
	,u.UnitID
	,u.UnitName
	,u.JobTitle
	,u.UnitType
	,pv.VettingBatchID
	,pv.VettingPersonStatusID 
	,s.Code AS VettingStatus
    ,b.VettingBatchTypeID
    ,t.Code AS VettingBatchType
    ,pv.VettingStatusDate
	,pv.VettingPersonStatusID AS LastVettingStatusID
	,s.Code AS LastVettingStatusCode
	,pv.VettingStatusDate AS LastVettingStatusDate
	,b.VettingBatchTypeID AS LastVettingTypeID
	,t.Code AS LastVettingTypeCode
	,b.TrainingEventID AS LastVettingTrainingEventID
	,b.GTTSTrackingNumber as TrackingNumber
	,b.VettingBatchID as BatchID
	,pv.RemovedFromVetting
	,CASE WHEN s.Code='APPROVED' OR s.Code = 'REJECTED' THEN 
			CASE WHEN b.VettingBatchTypeID = 1 THEN pv.VettingStatusDate ELSE lh.CertDate END ELSE NULL END AS VettingValidStartDate
	,CASE WHEN s.Code='APPROVED' OR s.Code = 'REJECTED'  THEN 
			CASE WHEN b.VettingBatchTypeID = 1 THEN DateAdd(year,1,pv.VettingStatusDate) ELSE  lh.ExpiresDate END ELSE NULL END AS VettingValidEndDate
	,CASE WHEN s.Code = 'REMOVED' THEN 1 ELSE 0 END AS IsRemoved
	,CASE WHEN vh.HitID IS NULL THEN  0 ELSE 1 END as HasHits
FROM vetting.PersonsVetting pv
INNER JOIN persons.PersonsUnitLibraryInfoView u ON pv.PersonsUnitLibraryInfoID = u.PersonsUnitLibraryInfoID 
INNER JOIN persons.Persons p ON u.PersonID = p.PersonID
INNER JOIN vetting.VettingPersonStatuses s ON pv.VettingPersonStatusID = s.VettingPersonStatusID
INNER JOIN vetting.VettingBatches b ON pv.VettingBatchID = b.VettingBatchID
INNER JOIN vetting.VettingBatchTypes t ON b.VettingBatchTypeID = t.VettingBatchTypeID
LEFT JOIN vetting.LeahyVettingHits lh ON pv.PersonsVettingID = lh.PersonsVettingID
LEFT JOIN [location].Cities c ON p.POBCityID = c.CityID
LEFT JOIN [location].States st ON c.StateID = st.StateID
LEFT JOIN [location].Countries cn ON st.CountryID = cn.CountryID
OUTER APPLY
			(
				SELECT top 1 pvt.PersonsVettingID as HitID
				FROM vetting.PersonsVettingVettingTypes pvt
			LEFT JOIN vetting.VettingHitResults r on pvt.HitResultID = r.HitResultID
				WHERE  pv.PersonsVettingID = pvt.PersonsVettingID AND ISNULL(r.Code,'') IN ('Possible Match','Direct Match')
			) AS vh