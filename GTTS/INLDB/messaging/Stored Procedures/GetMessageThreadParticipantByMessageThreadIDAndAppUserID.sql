CREATE PROCEDURE [messaging].[GetMessageThreadParticipantByMessageThreadIDAndAppUserID]
	@MessageThreadID INT,
	@AppUserID INT
AS
BEGIN
	SELECT MessageThreadID, AppUserID, [First], Middle, [Last], Subscribed, DateLastViewed
	FROM [messaging].MessageThreadParticipantsView
	WHERE MessageThreadID = @MessageThreadID
	AND	AppUserID = @AppUserID
END
