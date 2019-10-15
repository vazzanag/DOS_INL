CREATE PROCEDURE training.SaveTrainingEventGroupMembers
		@TrainingEventGroupID BIGINT = NULL,
		@PersonsJSON NVARCHAR(MAX),
		@MemberTypeID BIGINT,
		@ModifiedByAppUserID BIGINT
AS
BEGIN
		DELETE FROM training.TrainingEventGroupMembers
		WHERE TrainingEventGroupID = @TrainingEventGroupID AND
		PersonID NOT IN (SELECT j.PersonID FROM OPENJSON(@PersonsJSON) WITH (PersonID INT) j) AND
		GroupMemberTypeID = @MemberTypeID;

		UPDATE 
			groupMembers
		SET
			groupMembers.GroupMemberTypeID = @MemberTypeID,
			groupMembers.ModifiedByAppUserID = @ModifiedByAppUserID,
			groupMembers.ModifiedDate = GETUTCDATE()
		FROM
			training.TrainingEventGroupMembers AS groupMembers INNER JOIN
			(SELECT j.PersonID FROM OPENJSON(@PersonsJSON) WITH (PersonID INT) j) jsonEntries
			ON groupMembers.PersonID = jsonEntries.PersonID AND groupMembers.TrainingEventGroupID = @TrainingEventGroupID

		INSERT INTO training.TrainingEventGroupMembers
			(
				TrainingEventGroupID, PersonID, GroupMemberTypeID, ModifiedByAppUserID
			)
			SELECT @TrainingEventGroupID, p.PersonID, @MemberTypeID, @ModifiedByAppUserID
			FROM OPENJSON(@PersonsJSON) WITH (PersonID INT) p
			WHERE p.PersonID NOT IN
				  (
					SELECT PersonID FROM training.TrainingEventGroupMembers WHERE PersonID = p.PersonID AND TrainingEventGroupID = @TrainingEventGroupID
				  )

	SELECT 
		TrainingEventGroupID,
		PersonID
	FROM [training].[TrainingEventGroupMembersView]
	WHERE
		TrainingEventGroupID = @TrainingEventGroupID AND
		PersonID IN (SELECT j.PersonID FROM OPENJSON(@PersonsJSON) WITH (PersonID INT) j);
END