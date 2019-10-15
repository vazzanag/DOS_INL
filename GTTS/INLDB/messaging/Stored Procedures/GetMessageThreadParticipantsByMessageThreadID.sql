CREATE PROCEDURE [messaging].[GetMessageThreadParticipantsByMessageThreadID]
	@MessageThreadID INT
AS
BEGIN
	SELECT MessageThreadID, AppUserID, [First], Middle, [Last], Subscribed, DateLastViewed
	FROM [messaging].MessageThreadParticipantsView
	WHERE MessageThreadID = @MessageThreadID;
END
