CREATE PROCEDURE training.DeleteTrainingEventParticipantXLSX
	@ParticipantXLSXID BIGINT
AS
BEGIN
	DELETE FROM training.ParticipantsXLSX WHERE ParticipantXLSXID = @ParticipantXLSXID
END
