CREATE VIEW [search].[VettingBatchesJSONView]
AS
    SELECT b.VettingBatchID, b.CountryID,
			(select t.[Name] AS TrainingEventName, t.NameInLocalLang AS TrainingNameInLocalLang, t.TrainingEventID, f.Code AS FundingSourceCode, 
					f.[Description] AS FundingSource, l.Code AS AuthorizingLawCode, l.[Description] AS AuthorizingLaw, bt.Code AS VettingBatchType, 
					s.Code AS VettingBatchStatus, b.VettingBatchName, b.VettingBatchNumber, b.DateAccepted, b.DateCourtesyCompleted,
					b.DateLeahyResultsReceived, b.DateSentToCourtesy, b.DateSentToLeahy, b.DateSubmitted, b.DateVettingResultsNeededBy,
					b.DateVettingResultsNotified, b.GTTSTrackingNumber, b.LeahyTrackingNumber, b.INKTrackingNumber, b.CountryID,
					u.FullName
				FROM vetting.VettingBatches b1
		INNER JOIN vetting.VettingFundingSources f ON b.VettingFundingSourceID = f.VettingFundingSourceID
		INNER JOIN vetting.VettingBatchStatuses s ON b.VettingBatchStatusID = s.VettingBatchStatusID
		INNER JOIN vetting.AuthorizingLaws l ON b.AuthorizingLawID = l.AuthorizingLawID
		INNER JOIN vetting.VettingBatchTypes bt ON b.VettingBatchTypeID = bt.VettingBatchTypeID
		INNER JOIN training.TrainingEvents t ON b.TrainingEventID = t.TrainingEventID
			LEFT JOIN users.AppUsersView u ON b.AssignedToAppUserID = u.AppUserID
				WHERE b1.VettingBatchID = b.VettingBatchID FOR JSON PATH) VettingBatchJSON,

			-- Persons Vetting
			(SELECT FirstMiddleNames, LastNames
				FROM vetting.PersonsVettingView pv
				WHERE pv.VettingBatchID = b.VettingBatchID FOR JSON PATH) PersonsVettingJSON,

			-- Vetting Hits
			(SELECT vh.FirstMiddleNames, vh.LastNames,TrackingID, HitDetails
				FROM vetting.VettingHits vh
		INNER JOIN vetting.PersonsVettingView pv on vh.PersonsVettingID = pv.PersonsVettingID
		INNER JOIN vetting.PersonsVettingVettingTypes pt on pv.PersonsVettingID = pt.PersonsVettingID
				WHERE pv.VettingBatchID = b.VettingBatchID FOR JSON PATH) VettingHitsJSON,

			-- Leahy Hits
			(SELECT Summary
				FROM vetting.LeahyVettingHitsView vh
		INNER JOIN vetting.PersonsVettingView pv on vh.PersonsVettingID = pv.PersonsVettingID
				WHERE pv.VettingBatchID = b.VettingBatchID FOR JSON PATH) LeahyHitsJSON
		FROM vetting.VettingBatches b
INNER JOIN vetting.VettingFundingSources f ON b.VettingFundingSourceID = f.VettingFundingSourceID
INNER JOIN vetting.VettingBatchStatuses s ON b.VettingBatchStatusID = s.VettingBatchStatusID
INNER JOIN vetting.AuthorizingLaws l ON b.AuthorizingLawID = l.AuthorizingLawID
INNER JOIN vetting.VettingBatchTypes bt ON b.VettingBatchTypeID = bt.VettingBatchTypeID
INNER JOIN training.TrainingEvents t ON b.TrainingEventID = t.TrainingEventID
	LEFT JOIN users.AppUsersView u ON b.AssignedToAppUserID = u.AppUserID;
