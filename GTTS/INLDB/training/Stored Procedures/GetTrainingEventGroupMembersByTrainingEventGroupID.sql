CREATE PROCEDURE training.GetTrainingEventGroupMembersByTrainingEventGroupID
    @TrainingEventGroupID BIGINT
AS
BEGIN
    SELECT
		TrainingEventGroupID,
		GroupName,
		PersonID,
		FirstMiddleNames,
		LastNames,
		[TrainingEventID],
		TrainingEventName,
		MemberTypeID,
		MemberType,
		[ModifiedByAppUserID]
    FROM training.TrainingEventGroupMembersView 
    WHERE 
		[TrainingEventGroupID] = @TrainingEventGroupID
END