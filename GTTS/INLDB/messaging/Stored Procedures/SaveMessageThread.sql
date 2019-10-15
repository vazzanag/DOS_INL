CREATE PROCEDURE [messaging].[SaveMessageThread]
	@MessageThreadID BIGINT = NULL,
	@MessageThreadTitle NVARCHAR(500) = NULL,
	@ThreadContextTypeID BIGINT,
	@ThreadContextID BIGINT,
	@ModifiedByAppUserID BIGINT
AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @Identity BIGINT
    BEGIN TRY
        BEGIN TRANSACTION
        IF (@MessageThreadID IS NULL OR @MessageThreadID = -1) 
            BEGIN
				IF NOT EXISTS (SELECT * FROM messaging.MessageThreads WHERE ThreadContextTypeID = @ThreadContextTypeID AND ThreadContextID = @ThreadContextID)
				BEGIN
					INSERT INTO messaging.MessageThreads
					(
						MessageThreadTitle, ThreadContextTypeID, ThreadContextID, ModifiedByAppUserID
					)
					VALUES 
					(
						@MessageThreadTitle, @ThreadContextTypeID, @ThreadContextID, @ModifiedByAppUserID
					)
					SET @Identity = SCOPE_IDENTITY();

					DECLARE @TrainingEventID BIGINT;
					IF (@ThreadContextTypeID = 1) --Training Event
					BEGIN
						SET @TrainingEventID = @ThreadContextID;
					END
					ELSE IF (@ThreadContextTypeID = 2) --Batch
					BEGIN
						SET @TrainingEventID = (SELECT TrainingEventID FROM vetting.VettingBatches WHERE VettingBatchID = @ThreadContextID);
					END
					ELSE IF (@ThreadContextTypeID = 3) --Student
					BEGIN
						SET @TrainingEventID = (SELECT TrainingEventID FROM training.TrainingEventParticipants Students WHERE TrainingEventParticipantID = @ThreadContextID AND TrainingEventParticipantTypeID != 1);
					END
					ELSE IF (@ThreadContextTypeID = 4) --Instructor
					BEGIN
						SET @TrainingEventID = (SELECT TrainingEventID FROM training.TrainingEventParticipants WHERE TrainingEventParticipantID = @ThreadContextID AND TrainingEventParticipantTypeID = 1);
					END
					INSERT INTO messaging.MessageThreadParticipants (MessageThreadID, AppUserID, Subscribed, DateLastViewed)
					SELECT
						@Identity AS MessageThreadID, 
						participants.AppUserID AS AppUserID,
						1 AS Subscribed, 
						GETUTCDATE() AS DateLastViewed
					FROM 
					(SELECT OrganizerAppUserID AS AppUserID 
						FROM training.TrainingEvents 
						WHERE TrainingEventID = @TrainingEventID AND OrganizerAppUserID IS NOT NULL
					UNION
					SELECT AppUserID 
						FROM training.TrainingEventStakeholders 
						WHERE TrainingEventID = @TrainingEventID
					UNION
					SELECT au.AppUserID 
							FROM users.AppUsers au 
							INNER JOIN users.AppUserBusinessUnits aub ON au.AppUserID = aub.AppUserID
							INNER JOIN training.TrainingEvents te ON aub.BusinessUnitID = te.TrainingUnitID 
							WHERE te.TrainingEventID = @TrainingEventID
					) AS participants;
				END
				ELSE
				BEGIN
					UPDATE messaging.MessageThreads
					SET
						MessageThreadTitle = @MessageThreadTitle,
						ModifiedByAppUserID = @ModifiedByAppUserID
					WHERE
						ThreadContextID = @ThreadContextID AND
						ThreadContextTypeID = @ThreadContextTypeID;
					SET @Identity = (SELECT MessageThreadID FROM messaging.MessageThreads WHERE ThreadContextTypeID = @ThreadContextTypeID AND ThreadContextID = @ThreadContextID);
				END

				SELECT @Identity;
            END
        ELSE
            BEGIN
                IF NOT EXISTS(SELECT * FROM messaging.MessageThreads WHERE MessageThreadID = @MessageThreadID)
                    THROW 50000,  'The requested message thread to be updated does not exist.',  1
                UPDATE messaging.MessageThreads SET
                        MessageThreadTitle =         @MessageThreadTitle, 
                        ThreadContextTypeID =        @ThreadContextTypeID, 
                        ThreadContextID =            @ThreadContextID, 
                        ModifiedByAppUserID =        @ModifiedByAppUserID, 
                        ModifiedDate =               GETUTCDATE() 
                WHERE MessageThreadID = @MessageThreadID
                SET @Identity = @MessageThreadID
				SELECT @Identity;
            END
        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END
