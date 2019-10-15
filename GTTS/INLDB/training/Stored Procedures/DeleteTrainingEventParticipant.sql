CREATE PROCEDURE [training].[DeleteTrainingEventParticipant]
	@TrainingEventID BIGINT,
    @ParticipantID BIGINT,
	@ParticipantType NVARCHAR(15)
AS
BEGIN
	IF (UPPER(@ParticipantType) = 'INSTRUCTOR')
		BEGIN
			DELETE FROM [training].TrainingEventParticipants
			 WHERE TrainingEventID = @TrainingEventID AND TrainingEventParticipantID = @ParticipantID
			 AND TrainingEventParticipantTypeID = 2;
		END
	ELSE
		BEGIN
			DELETE FROM [training].TrainingEventParticipants
			 WHERE TrainingEventID = @TrainingEventID AND TrainingEventParticipantID = @ParticipantID
			 AND TrainingEventParticipantTypeID != 2;
		END
			  -- Remove from yet not accepted batches
		DELETE FROM [vetting].PersonsVetting 
			  WHERE VettingBatchID IN (SELECT VettingBatchID 
										 FROM vetting.VettingBatches 
										WHERE VettingBatchStatusID != 2 AND TrainingEventID = @TrainingEventID AND PersonsVettingID = @ParticipantID)
	
END
