CREATE PROCEDURE [messaging].[SaveMessageThreadParticipant]
	@MessageThreadID INT,
	@AppUserID INT,
	@Subscribed BIT
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM [messaging].MessageThreadParticipants WHERE MessageThreadID = @MessageThreadID AND AppUserID = @AppUserID)
	BEGIN
		INSERT INTO [messaging].MessageThreadParticipants
			(MessageThreadID, AppUserID, Subscribed, DateLastViewed)
		VALUES
			(@MessageThreadID, @AppUserID, @Subscribed, GETUTCDATE())
	END
	ELSE
	BEGIN
		UPDATE [messaging].MessageThreadParticipants
		SET Subscribed = @Subscribed,
			DateLastViewed = GETUTCDATE()
		WHERE MessageThreadID = @MessageThreadID 
		  AND AppUserID = @AppUserID
	END
END