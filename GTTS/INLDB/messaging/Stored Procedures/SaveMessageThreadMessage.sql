CREATE PROCEDURE [messaging].[SaveMessageThreadMessage]
	@MessageThreadMessageID BIGINT = NULL,
	@MessageThreadID INT,
	@SenderAppUserID INT,
	@SentTime DATETIME,
	@Message TEXT = NULL,
	@AttachmentFileID BIGINT = NULL
AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @Identity BIGINT

	IF @MessageThreadMessageID IS NULL
	BEGIN
		INSERT INTO [messaging].MessageThreadMessages
			(MessageThreadID, SenderAppUserID, SentTime, [Message], AttachmentFileID)
		VALUES
			(@MessageThreadID, @SenderAppUserID, GETUTCDATE(), @Message, @AttachmentFileID)
		SET @Identity = SCOPE_IDENTITY();
		SELECT @Identity;
	END
	ELSE
	BEGIN
		UPDATE [messaging].MessageThreadMessages 
		SET MessageThreadID = @MessageThreadID,
			SenderAppUserID = @SenderAppUserID,
			SentTime = GETUTCDATE(),
			[Message] = @Message,
			AttachmentFileID = @AttachmentFileID
		WHERE MessageThreadMessageID = @MessageThreadMessageID
		SET @Identity = @MessageThreadMessageID
		SELECT @Identity;
	END
	UPDATE messaging.MessageThreadParticipants
	SET DateLastViewed = GETUTCDATE()
	WHERE AppUserID = @SenderAppUserID AND MessageThreadID = @MessageThreadID
END