CREATE PROCEDURE [vetting].[GetCourtesyBatchesByVettingBatchIDAndVettingTypeID]
	@VettingBatchID BIGINT,
	@VettingTypeID SMALLINT
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
	AND VettingTypeID = @VettingTypeID

END