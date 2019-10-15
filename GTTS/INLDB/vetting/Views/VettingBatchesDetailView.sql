CREATE VIEW [vetting].[VettingBatchesDetailView]
AS
SELECT VettingBatchID
	,VettingBatchName
	,VettingBatchNumber
	,VettingBatchOrdinal
	,b.TrainingEventID
	,b.CountryID
	,c.CountryName
	,b.VettingBatchTypeID
	,t.Code AS VettingBatchType
	,AssignedToAppUserID
	,u.First AS AssignedToAppUserFirstName
	,u.Last AS AssignedToAppUserLastName
	,uSubmitted.First AS SubmittedAppUserFirstName
	,uSubmitted.Last AS SubmittedAppUserLastName
	,uAccepted.First AS AcceptedAppUserFirstName
	,uAccepted.Last AS AcceptedAppUserLastName
	,uCourtesyComplete.First AS CourtesyCompleteAppUserFirstName
	,uCourtesyComplete.Last AS CourtesyCompleteAppUserLastName
	,uSentToCourtesy.First AS SentToCourtesyAppUserFirstName
	,uSentToCourtesy.Last AS SentToCourtesyAppUserLastName
	,uSentToLeahy.First AS SentToLeahyAppUserFirstName
	,uSentToLeahy.Last AS SentToLeahyAppUserLastName
	,b.VettingBatchStatusID
	,s.Code AS VettingBatchStatus
	,IsCorrectionRequired
	,CourtesyVettingOverrideFlag
	,CourtesyVettingOverrideReason
	,GTTSTrackingNumber
	,LeahyTrackingNumber
	,INKTrackingNumber
	,DateVettingResultsNeededBy
	,DateSubmitted
	,DateAccepted
	,DateSentToCourtesy
	,DateCourtesyCompleted
	,DateSentToLeahy
	,DateLeahyResultsReceived
	,DateVettingResultsNotified
	,DateLeahyFileGenerated
	,b.VettingFundingSourceID
	,f.Code AS VettingFundingSource
	,b.AuthorizingLawID
	,l.Code AS AuthorizingLaw
	,VettingBatchNotes
	,b.ModifiedByAppUserID
	,b.ModifiedDate
	,b.FileID
    ,e.[Name] AS TrainingEventName
	,ub.Acronym as TrainingEventBusinessUnitAcronym
	,CASE WHEN ISNULL(ph.TotalHits,0) = 0 then 0 ELSE 1 end as HasHits
	,ph.TotalHits 
	,(SELECT MIN(CAST(el.EventStartDate AS DATE)) FROM training.TrainingEventLocations el WHERE TrainingEventID = e.TrainingEventID) EventStartDate
	,
	-- Persons Vettings
	(
		SELECT p.PersonsVettingID
			,p.PersonsUnitLibraryInfoID
			,ps.PersonID
			,ps.FirstMiddleNames
			,ps.LastNames
			,p.Name1
			,p.Name2
			,p.Name3
			,p.Name4
			,p.Name5
			,ps.DOB
			,ps.Gender
			,ps.NationalID
			,ps.POBCityID
			,pobc.CityName AS POBCityName
			,pobc.StateID AS POBStateID
			,pobs.StateName AS POBStateName
			,pobs.CountryID AS POBCountryID
			,pobco.CountryName AS POBCountryName
			,ui.UnitID
			,ui.UnitName
			,uv.UnitAgencyName
			,uv.UnitBreakdownLocalLang AS UnitParents
			,uv.UnitBreakdown AS UnitParentsEnglish
			,uv.VettingActivityType
            ,uv.UnitAcronym
			,ui.JobTitle
			,ui.RankName
			,p.VettingBatchID
			,p.VettingPersonStatusID
			,s.Code AS VettingStatus
			,p.VettingStatusDate
			,p.VettingNotes
			,p.ModifiedByAppUserID
			,p.ModifiedDate
			,CASE WHEN s.Code = 'REMOVED' THEN 1 ELSE 0 END AS IsRemoved
			,ui.UnitGenID
			,p.ClearedDate
			,p.AppUserIDCleared
			,p.DeniedDate
			,p.AppUserIDDenied
			,lr.Code AS LeahyHitResultCode
			,pobco.INKCode AS POBCountryINKCode
			,pobs.INKCode AS POBStateINKCode
			,ISNULL(p.RemovedFromVetting,0) AS RemovedFromVetting
			,ISNULL((SELECT TOP 1 TrainingEventParticipantID FROM [training].[TrainingEventParticipants] WHERE PersonId = ps.PersonID AND TrainingEventID = b.TrainingEventID), 0) AS ParticipantID
		FROM [vetting].[PersonsVetting] p
		LEFT JOIN persons.PersonsUnitLibraryInfoView ui ON p.PersonsUnitLibraryInfoID = ui.PersonsUnitLibraryInfoID 
		INNER JOIN persons.Persons ps ON ui.PersonID = ps.PersonID
		LEFT JOIN unitlibrary.UnitsView uv on ui.UnitID = uv.UnitID
		LEFT JOIN vetting.VettingPersonStatuses s ON p.VettingPersonStatusID = s.VettingPersonStatusID
		LEFT JOIN vetting.LeahyVettingHits lh ON p.PersonsVettingID = lh.PersonsVettingID
		LEFT JOIN vetting.VettingLeahyHitResults lr ON lh.LeahyHitResultID = lr.LeahyHitResultID
		LEFT JOIN [location].Cities as pobc on pS.POBCityID = pobc.CityID
		LEFT JOIN [location].States as pobs on pobc.StateID= pobs.StateID
		LEFT JOIN [location].Countries as pobco on pobs.CountryID = pobco.CountryID
			WHERE p.VettingBatchID = b.VettingBatchID
				ORDER BY IsRemoved ASC
			FOR JSON PATH, INCLUDE_NULL_VALUES
		) PersonsVettingJSON
		,
		(SELECT count(*) AS NumParticipants, pvt.VettingTypeCode, pvt.VettingTypeID 
			FROM [vetting].[PersonsVettingVettingTypesView] pvt
		INNER JOIN [vetting].[PersonsVetting] p on p.PersonsVettingID = pvt.PersonsVettingID
			WHERE p.VettingBatchID = b.VettingBatchID AND ISNULL(pvt.CourtesyVettingSkipped,0)=0 
				GROUP BY pvt.VettingTypeCode, pvt.VettingTypeID
			FOR JSON PATH,INCLUDE_NULL_VALUES
		) PersonVettingTypeJSON
		,
		(SELECT SUM(CASE WHEN ISNULL(pvt.HitResultID, 0) > 0 THEN 1 ELSE 0 END ) AS NumResultHits, 
				SUM(pvt.HasHitDataInTable) AS NumHits, pvt.VettingTypeCode, pvt.VettingTypeID 
			FROM [vetting].[PersonsVettingVettingTypesView] pvt
		INNER JOIN [vetting].[PersonsVetting] p on p.PersonsVettingID = pvt.PersonsVettingID
			WHERE p.VettingBatchID = b.VettingBatchID AND ISNULL(pvt.CourtesyVettingSkipped,0)=0 
				GROUP BY pvt.VettingTypeCode, pvt.VettingTypeID
			FOR JSON PATH,INCLUDE_NULL_VALUES
		) PersonVettingHitJSON
		,
		(SELECT vt.PersonsVettingID, vt.VettingTypeID, vt.VettingTypeCode, vt.CourtesyVettingSkipped, HitResultID, HitResultCode 
					FROM [vetting].[PersonsVettingVettingTypesView] vt
				INNER JOIN vetting.PersonsVetting pv on vt.PersonsVettingID = pv.PersonsVettingID
					WHERE pv.VettingBatchID = b.VettingBatchID 
				FOR JSON PATH, INCLUDE_NULL_VALUES
		) PersonVettingVettingTypesJSON
FROM vetting.VettingBatches b
INNER JOIN training.TrainingEvents e ON b.TrainingEventID = e.TrainingEventID
INNER JOIN users.BusinessUnits ub ON e.TrainingUnitID = ub.BusinessUnitID
LEFT JOIN vetting.VettingBatchStatuses s ON b.VettingBatchStatusID = s.VettingBatchStatusID
LEFT JOIN vetting.VettingBatchTypes t ON b.VettingBatchTypeID = t.VettingBatchTypeID
LEFT JOIN [location].Countries c ON b.CountryID = c.CountryID
LEFT JOIN vetting.VettingFundingSources f ON b.VettingFundingSourceID = f.VettingFundingSourceID
LEFT JOIN vetting.AuthorizingLaws l ON b.AuthorizingLawID = l.AuthorizingLawID
LEFT JOIN users.AppUsers u ON b.AssignedToAppUserID = u.AppUserID
LEFT JOIN users.AppUsers uSubmitted ON b.AppUserIDSubmitted = uSubmitted.AppUserID
LEFT JOIN users.AppUsers uAccepted ON b.AppUserIDAccepted = uAccepted.AppUserID
LEFT JOIN users.AppUsers uSentToCourtesy ON b.AppUserIDSentToCourtesy = uSentToCourtesy.AppUserID
LEFT JOIN users.AppUsers uCourtesyComplete ON b.AppUserIDCourtesyCompleted = uCourtesyComplete.AppUserID
LEFT JOIN users.AppUsers uSentToLeahy ON b.AppUserIDSentToLeahy = uSentToLeahy.AppUserID
OUTER APPLY 
	(SELECT count(*) as TotalHits FROM [vetting].PersonsVettingView pv WHERE pv.VettingBatchID = b.VettingBatchID
			and pv.HasHits = 1) as ph
GO
