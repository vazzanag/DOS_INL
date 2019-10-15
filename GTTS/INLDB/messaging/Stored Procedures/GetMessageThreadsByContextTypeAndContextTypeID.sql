CREATE PROCEDURE [messaging].[GetMessageThreadsByContextTypeAndContextTypeID]
	@ThreadContextTypeID BIGINT = NULL,
	@ThreadContextID BIGINT = NULL
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
	WHERE ThreadContextTypeID = @ThreadContextTypeID 
	  AND ThreadContextID = @ThreadContextID
