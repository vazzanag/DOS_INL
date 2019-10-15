CREATE VIEW [vetting].[PersonsVettingStatusesView]
AS
    SELECT p.PersonID, b.TrainingEventID, b.VettingBatchStatusID, bs.Code AS BatchStatus, 
           v.VettingPersonStatusID, ps.Code AS PersonsVettingStatus, DateLeahyFileGenerated, RemovedFromVetting, v.VettingStatusDate, b.VettingBatchTypeID,
		    (CASE WHEN b.VettingBatchStatusID = 1 THEN DateSubmitted
				  WHEN b.VettingBatchStatusID = 2 THEN DateAccepted
				  WHEN b.VettingBatchStatusID = 3 THEN b.ModifiedDate
				  WHEN b.VettingBatchStatusID = 4 THEN DateSentToCourtesy
				  WHEN b.VettingBatchStatusID = 5 THEN DateCourtesyCompleted
				  WHEN b.VettingBatchStatusID = 6 THEN DateSentToLeahy
				  WHEN b.VettingBatchStatusID = 7 THEN DateVettingResultsNotified 
				  ELSE b.ModifiedDate 
              END) AS VettingBatchStatusDate,
		    (CASE WHEN b.VettingBatchTypeID = 1 THEN v.VettingStatusDate + 365
				  WHEN b.VettingBatchTypeID = 2 THEN lh.ExpiresDate
				  ELSE null 
              END) AS ExpirationDate
	  FROM vetting.PersonsVetting v
INNER JOIN vetting.VettingBatches b ON v.VettingBatchID = b.VettingBatchID
INNER JOIN vetting.VettingBatchStatuses bs ON b.VettingBatchStatusID = bs.VettingBatchStatusID
INNER JOIN vetting.VettingPersonStatuses ps ON v.VettingPersonStatusID = ps.VettingPersonStatusID
INNER JOIN persons.PersonsUnitLibraryInfo p ON v.PersonsUnitLibraryInfoID = p.PersonsUnitLibraryInfoID
 LEFT JOIN vetting.LeahyVettingHits lh ON v.PersonsVettingID = lh.PersonsVettingID

