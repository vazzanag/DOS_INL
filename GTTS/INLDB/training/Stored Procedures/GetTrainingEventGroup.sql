CREATE PROCEDURE training.GetTrainingEventGroup
    @TrainingEventGroupID BIGINT
AS
BEGIN
    SELECT
		TrainingEventGroupID,
		[TrainingEventID],
		TrainingEventName,
		[GroupName],
		[ModifiedByAppUserID]
    FROM training.TrainingEventGroupsView 
    WHERE [TrainingEventGroupID] = @TrainingEventGroupID;
END