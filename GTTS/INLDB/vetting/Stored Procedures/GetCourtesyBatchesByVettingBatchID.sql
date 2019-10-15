CREATE PROCEDURE [vetting].[GetCourtesyBatchesByVettingBatchID]
	@VettingBatchID BIGINT
AS
BEGIN

	SELECT
		CourtesyBatchID,
		VettingBatchID,
		VettingTypeID,  
		VettingType,
		VettingBatchNotes,	
		AssignedToAppUserID,	
		AssignedToAppUserName,
		ResultsSubmittedDate,
		ResultsSubmittedByAppUserID,
		ResultsSubmittedByAppUserName
	FROM vetting.CourtesyBatchesView
	WHERE VettingBatchID = @VettingBatchID

END