CREATE VIEW [search].[VettingBatchesDetailView]
WITH SCHEMABINDING
AS 
    SELECT t.[Name] AS TrainingEventName, t.NameInLocalLang AS TrainingNameInLocalLang, t.TrainingEventID, f.Code AS FundingSourceCode, 
           f.[Description] AS FundingSource, l.Code AS AuthorizingLawCode, l.[Description] AS AuthorizingLaw, bt.Code AS VettingBatchType, 
           s.Code AS VettingBatchStatus, b.VettingBatchID, b.VettingBatchName, b.VettingBatchNumber, b.DateAccepted, b.DateCourtesyCompleted,
	       b.DateLeahyResultsReceived, b.DateSentToCourtesy, b.DateSentToLeahy, b.DateSubmitted, b.DateVettingResultsNeededBy,
	       b.DateVettingResultsNotified, b.GTTSTrackingNumber, b.LeahyTrackingNumber, b.INKTrackingNumber, b.CountryID,
           b.AssignedToAppUserID
      FROM vetting.VettingBatches b
INNER JOIN vetting.VettingFundingSources f ON b.VettingFundingSourceID = f.VettingFundingSourceID
INNER JOIN vetting.VettingBatchStatuses s ON b.VettingBatchStatusID = s.VettingBatchStatusID
INNER JOIN vetting.AuthorizingLaws l ON b.AuthorizingLawID = l.AuthorizingLawID
INNER JOIN vetting.VettingBatchTypes bt ON b.VettingBatchTypeID = bt.VettingBatchTypeID
INNER JOIN training.TrainingEvents t ON b.TrainingEventID = t.TrainingEventID 

 GO

 CREATE UNIQUE CLUSTERED INDEX IDX_VettingBatchesDetailView_VettingBatchID
    ON search.VettingBatchesDetailView (VettingBatchID);  
GO 

CREATE FULLTEXT INDEX ON [search].[VettingBatchesDetailView] 
	(TrainingEventName, TrainingNameInLocalLang, FundingSourceCode, FundingSource, AuthorizingLawCode, 
     AuthorizingLaw, VettingBatchType, VettingBatchStatus, VettingBatchName, GTTSTrackingNumber, 
     LeahyTrackingNumber, INKTrackingNumber) 
    KEY INDEX [IDX_VettingBatchesDetailView_VettingBatchID] ON [FullTextCatalog] 
    WITH CHANGE_TRACKING AUTO
GO
