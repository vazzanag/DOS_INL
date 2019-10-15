CREATE PROCEDURE training.GetTrainingEventGroupSByTrainingEventID
    @TrainingEventID BIGINT
AS
BEGIN
    SELECT
		TrainingEventGroupID,
		[TrainingEventID],
		TrainingEventName,
		[GroupName],
		[ModifiedByAppUserID]
    FROM training.TrainingEventGroupsView 
    WHERE [TrainingEventID] = @TrainingEventID;
END