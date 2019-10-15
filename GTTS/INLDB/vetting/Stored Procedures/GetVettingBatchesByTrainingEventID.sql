CREATE PROCEDURE [vetting].[GetVettingBatchesByTrainingEventID] 
    @TrainingEventID BIGINT
AS
BEGIN
	SELECT VettingBatchID, VettingBatchName, VettingBatchNumber, VettingBatchOrdinal, TrainingEventID, CountryID, CountryName, VettingBatchTypeID, 
           VettingBatchType, DateVettingResultsNeededBy, DateSubmitted,
		   VettingBatchStatusID, VettingBatchStatus, IsCorrectionRequired, CourtesyVettingOverrideFlag, CourtesyVettingOverrideReason, 
		   AssignedToAppUserID,	GTTSTrackingNumber, INKTrackingNumber, DateSentToCourtesy, DateCourtesyCompleted, DateVettingResultsNotified,
		   LeahyTrackingNumber, DateSentToLeahy, DateLeahyResultsReceived, VettingFundingSourceID, VettingFundingSource,
		   AuthorizingLawID, AuthorizingLaw, FileID, ModifiedByAppUserID, PersonsVettingJSON
	FROM vetting.VettingBatchesDetailView
		WHERE TrainingEventID = @TrainingEventID
END
