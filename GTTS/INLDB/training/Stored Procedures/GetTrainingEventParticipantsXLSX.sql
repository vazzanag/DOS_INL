CREATE PROCEDURE [training].[GetTrainingEventParticipantsXLSX]
	@TrainingEventID BIGINT 
AS
BEGIN
	SELECT TrainingEventID, ModifiedByAppUserID, ParticipantJSON
	 FROM  training.TrainingEventParticipantsXLSXView 
	 WHERE TrainingEventID = @TrainingEventID
END;
