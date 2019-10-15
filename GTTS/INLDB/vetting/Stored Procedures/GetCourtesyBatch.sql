CREATE PROCEDURE [vetting].[GetCourtesyBatch]
	@CourtesyBatchID BIGINT
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
	WHERE CourtesyBatchID = @CourtesyBatchID

END