CREATE PROCEDURE training.GetTrainingEventGroupMember
    @TrainingEventGroupID BIGINT,
	@PersonID BIGINT
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
		[TrainingEventGroupID] = @TrainingEventGroupID AND
		PersonID = @PersonID;
END