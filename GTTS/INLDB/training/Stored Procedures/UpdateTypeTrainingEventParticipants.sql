CREATE PROCEDURE [training].[UpdateTypeTrainingEventParticipants]
	@TrainingEventID BIGINT,
    @PersonsJSON NVARCHAR(MAX),
	@TrainingEventParticipantTypeID INT = 1,
	@RemovalReasonID BIGINT = NULL,
	@RemovalCauseID BIGINT = NULL,
	@DateCanceled DATETIME = NULL
AS
BEGIN
	DECLARE @RemovedFromEvent BIT = 0;
	IF @RemovalReasonID IS NOT NULL
		SET @RemovedFromEvent = 1;


    UPDATE [training].[TrainingEventParticipants]
	SET
		--RemovedFromEvent = 1,
		TrainingEventParticipantTypeID = @TrainingEventParticipantTypeID,
		RemovalReasonID = @RemovalReasonID,
		RemovalCauseID = @RemovalCauseID,
		DateCanceled = @DateCanceled,
		RemovedFromEvent = @RemovedFromEvent
    WHERE 
		TrainingEventID = @TrainingEventID AND
		PersonID IN (SELECT j.PersonID FROM OPENJSON(@PersonsJSON) WITH (PersonID INT) j);

		IF (@RemovalReasonID IS NOT NULL)
		BEGIN
			-- remove tha participant from group if the participant is removed
			DELETE tgm FROM training.TrainingEventGroupMembers tgm 
				INNER JOIN training.TrainingEventGroups tg on tgm.TrainingEventGroupID = tg.TrainingEventGroupID
				INNER JOIN training.TrainingEvents te on tg.TrainingEventID = te.TrainingEventID
				INNER JOIN OPENJSON(@PersonsJSON) WITH (PersonID INT) j ON tgm.PersonID = j.PersonID
			WHERE te.TrainingEventID = @TrainingEventID;
		END

	SELECT PersonID
	FROM training.TrainingEventParticipantsView
	WHERE PersonID IN (SELECT j.PersonID FROM OPENJSON(@PersonsJSON) WITH (PersonID INT) j)
	AND TrainingEventID = @TrainingEventID

END