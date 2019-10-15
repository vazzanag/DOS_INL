CREATE PROCEDURE [training].[DeleteTrainingEventGroup]
	@TrainingEventGroupID BIGINT
AS
BEGIN
	DELETE FROM training.TrainingEventGroupMembers WHERE TrainingEventGroupID = @TrainingEventGroupID;
	DELETE FROM training.TrainingEventGroups WHERE TrainingEventGroupID = @TrainingEventGroupID;
END
