CREATE PROCEDURE [messaging].[GetMessageThreadParticipantsByAppUserID]
	@AppUserID BIGINT,
	@PageIndex INT,
	@PageSize INT
AS
	SELECT
		MessageThreadID,
		MessageThreadTitle, 
		ThreadContextTypeID,
		ThreadContextID,
		AppUserID, 
		[First], 
		Middle, 
		[Last], 
		Subscribed,
		DateLastViewed,
		NumUnreadMessages
	FROM messaging.MessageThreadParticipantsView
	WHERE
		AppUserID = @AppUserID
	ORDER BY
		NumUnreadMessages DESC,
		MessageThreadID DESC
	OFFSET (@PageSize * @PageIndex) ROWS
	FETCH NEXT @PageSize ROWS ONLY;