CREATE PROCEDURE [training].[GetRemovedParticipants]
	@TrainingEventID BIGINT
AS
	SELECT RemovedFromEvent, RemovedFromVetting, PersonID FROM training.TrainingEventParticipantsView 
		WHERE TrainingEventID = @TrainingEventID

