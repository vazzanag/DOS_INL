CREATE PROCEDURE [vetting].[GetVettingBatchesFromJson]
	@VettingBatchesJSON NVARCHAR(MAX)
AS
	SELECT VettingBatchID
			,VettingBatchName
			,VettingBatchNumber
			,VettingBatchOrdinal
			,TrainingEventID
			,CountryID
			,CountryName
			,VettingBatchTypeID
			,VettingBatchType
			,AssignedToAppUserID
			,AssignedToAppUserFirstName
			,AssignedToAppUserLastName
			,VettingBatchStatusID
			,VettingBatchStatus
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
			,VettingFundingSourceID
			,VettingFundingSource
			,AuthorizingLawID
			,AuthorizingLaw
			,VettingBatchNotes
			,ModifiedByAppUserID
			,ModifiedDate
			,TrainingEventName
			,TrainingEventBusinessUnitAcronym
			,TotalHits
			,PersonsVettingJSON
			,PersonVettingTypeJSON
			,PersonVettingHitJSON
			,EventStartDate
	FROM vetting.VettingBatchesDetailView 
     WHERE  VettingBatchID IN (SELECT j.VettingBatchID FROM OPENJSON(@VettingBatchesJSON) WITH (VettingBatchID INT) j);
