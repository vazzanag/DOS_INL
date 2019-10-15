CREATE PROCEDURE [training].[RemoveTrainingEventStudent]
	@TrainingEventID BIGINT,
    @PersonID BIGINT,
	@RemovalReasonID BIGINT = NULL,
	@RemovalCauseID BIGINT = NULL,
	@DateCanceled DATETIME = NULL
AS
BEGIN

    UPDATE [training].TrainingEventStudents
	SET
		RemovedFromEvent = 1,
		RemovalReasonID = @RemovalReasonID,
		RemovalCauseID = @RemovalCauseID,
		DateCanceled = @DateCanceled
    WHERE 
		TrainingEventID = @TrainingEventID AND
		PersonID = @PersonID;

	-- Remove the participant from unaccepted batches
	DELETE pv
	FROM [vetting].PersonsVetting pv
	INNER JOIN [vetting].VettingBatches vb
			ON vb.VettingBatchID = pv.VettingBatchID
	INNER JOIN [training].TrainingEventStudents tes
			ON tes.PersonsVettingID = pv.PersonsVettingID
	WHERE vb.VettingBatchStatusID != 2 
	AND   tes.PersonID = @PersonID
	AND   tes.TrainingEventID = @TrainingEventID	
	
END