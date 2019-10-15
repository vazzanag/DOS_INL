CREATE PROCEDURE [messaging].[GetMessageThreadByID]
	@MessageThreadID BIGINT
AS
	SELECT
		MessageThreadID,
		MessageThreadTitle, 
		ThreadContextTypeID,
		ThreadContextType,
		ThreadContextID,
		ModifiedByAppUserID,
		ModifiedDate
	FROM messaging.MessageThreadsView
	WHERE MessageThreadID = @MessageThreadID;
