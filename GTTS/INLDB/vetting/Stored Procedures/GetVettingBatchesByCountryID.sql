CREATE PROCEDURE [vetting].[GetVettingBatchesByCountryID]
	@CountryID BIGINT,
	@VettingBatchStatus NVARCHAR(30) = NULL,
	@IsCorrectionRequired INT = NULL,
	@HasHits INT = NULL,
	@CourtesyType NVARCHAR(10)
AS
BEGIN

	SELECT @VettingBatchStatus = CASE WHEN @VettingBatchStatus ='' THEN NULL 
									ELSE CASE WHEN @VettingBatchStatus = 'Courtesy Complete' THEN 'COURTESY COMPLETED' 
										ELSE CASE WHEN @VettingBatchStatus = 'Leahy Complete' THEN 'LEAHY RESULTS RETURNED'
											ELSE CASE WHEN @VettingBatchStatus = 'Results Notified' THEN 'CLOSED' 
												ELSE CASE WHEN @VettingBatchStatus = 'In Progress' THEN 'SUBMITTED TO COURTESY' ELSE @VettingBatchStatus END
											END
										END
									END
								 END
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
		WHERE CountryID = @CountryID 	
			AND IsCorrectionRequired = ISNULL(@IsCorrectionRequired, IsCorrectionRequired)	
			AND VettingBatchStatus = ISNULL(@VettingBatchStatus, VettingBatchStatus)
			AND HasHits = ISNULL(@HasHits, HasHits) 
		ORDER BY DateSubmitted DESC
	END