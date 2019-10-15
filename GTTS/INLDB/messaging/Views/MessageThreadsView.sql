CREATE VIEW [messaging].[MessageThreadsView]
AS 
	SELECT
		MessageThreadID,
		MessageThreadTitle, 
		tct.ThreadContextTypeID,
		tct.[Name] ThreadContextType,
		ThreadContextID,
		mt.ModifiedByAppUserID,
		mt.ModifiedDate
	FROM [messaging].MessageThreads mt 
	LEFT JOIN [messaging].ThreadContextTypes tct ON mt.ThreadContextTypeID = tct.ThreadContextTypeID;
