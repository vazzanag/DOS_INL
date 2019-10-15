CREATE PROCEDURE [messaging].[GetNumUnreadMessageThreadMessagesByAppUserID]
	@AppUserID BIGINT
AS
	SELECT
		SUM(NumUnreadMessages) AS NumUnreadMessages
	FROM messaging.MessageThreadParticipantsView
	WHERE
		AppUserID = @AppUserID;