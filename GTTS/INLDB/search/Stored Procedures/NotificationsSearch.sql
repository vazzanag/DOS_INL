CREATE PROCEDURE [search].[NotificationsSearch]
    @SearchString NVARCHAR(4000),
    @AppUserID INT, 
    @ContextID BIGINT = NULL,
    @ContextTypeID INT = NULL,
    @PageSize INT = NULL,
    @PageNumber INT = NULL,
    @SortOrder NVARCHAR(50) = NULL,
    @SortDirection NVARCHAR(4) = 'ASC'
AS
BEGIN
    
    -- VERIFY @SearchString HAS A VALUE
    IF (LEN(@SearchString) = 0)
        THROW 50000,  'Search criteria not specified',  1;

    DECLARE @Query NVARCHAR(4000), 
            @DelimIndex SMALLINT, 
            @Word NVARCHAR(200),
            @SearchTrimmed NVARCHAR(4000),
            @FirstWord BIT,
            @FirstDate DATE,
            @LastDate DATE,
            @SwapDate DATE;

    SET @FirstWord = 1;

	IF OBJECT_ID('tempdb..#searchSet') IS NOT NULL
        DROP TABLE #searchSet
    CREATE TABLE #searchSet 
	(
		[Rank] INT, NotificationID BIGINT, ContextName NVARCHAR(255), GTTSTrackingNumber NVARCHAR(100), LeahyTrackingNumber NVARCHAR(100),
		INKTrackingNumber NVARCHAR(100), NotificationSubject NVARCHAR(250), NotificationMessage NVARCHAR(MAX), NotificationContextType NVARCHAR(50),
		NotificationContextTypeID INT, ContextID BIGINT, ModifiedDate DATETIME, AppUserID INT, Unread BIT
	);

    -- GENERATE SERACH STRING FORMATTED FOR FULLTEXT SEARCH INDEXES
    SELECT @Query = search.BuildFullTextSearchStringForOr(@SearchString);
    
    /*
     SEARCH: 
        Union necessary for search inclusions across all fulltext indexes
        Grouping necessary to remove duplicates, taking highest rank if duplicate found
    */
	INSERT INTO #searchSet
		SELECT MAX([Rank]) AS [Rank], s.NotificationID, ContextName, GTTSTrackingNumber, LeahyTrackingNumber, INKTrackingNumber,
			   n.NotificationSubject, n.NotificationMessage, n.NotificationContextType, n.NotificationContextTypeID, n.ContextID, 
			   n.ModifiedDate, n.AppUserID, n.Unread
		  FROM (       
				SELECT r.[Rank], 'vetting' tableSource, n.NotificationID, AppUserID, VettingBatchName AS ContextName, 
					   GTTSTrackingNumber, LeahyTrackingNumber, INKTrackingNumber
				  FROM messaging.NotificationsWithRecipientsView n
			INNER JOIN search.NotificationVettingView v ON n.NotificationID = v.NotificationID
			INNER JOIN CONTAINSTABLE(search.NotificationVettingView, *, @Query)    r ON n.NotificationID = r.[Key]
					WHERE n.AppUserID = @AppUserID
					  AND n.ContextID = ISNULL(@ContextID, n.ContextID)
					  AND n.NotificationContextTypeID = ISNULL(@ContextTypeID, n.NotificationContextTypeID)
			UNION
				SELECT r.[Rank], 'event' tableSource, n.NotificationID,AppUserID,  [Name] AS ContextName, null, null, null
				  FROM messaging.NotificationsWithRecipientsView n
			INNER JOIN search.NotificationTrainingEventView v ON n.NotificationID = v.NotificationID
			INNER JOIN CONTAINSTABLE(search.NotificationTrainingEventView, *, @Query)    r ON n.NotificationID = r.[Key]
					WHERE n.AppUserID = @AppUserID
					  AND n.ContextID = ISNULL(@ContextID, n.ContextID)
					  AND n.NotificationContextTypeID = ISNULL(@ContextTypeID, n.NotificationContextTypeID)
			   )  s
	INNER JOIN messaging.NotificationsWithRecipientsView n ON s.NotificationID = n.NotificationID AND s.AppUserID = n.AppUserID
	  GROUP BY s.NotificationID, s.ContextName, GTTSTrackingNumber, LeahyTrackingNumber, INKTrackingNumber, n.NotificationSubject, 
			   n.NotificationMessage, n.NotificationContextType, n.NotificationContextTypeID, n.ContextID, n.ModifiedDate, n.AppUserID, n.Unread
	  ORDER BY Unread, MAX([Rank]) DESC;

	
	-- GET THE TOTAL NUMBER OF RECORDS RETRIEVED
	SELECT COUNT(@@ROWCOUNT) AS RecordCount FROM #searchSet;

	-- DETERMINE RESULTSET BASED ON PASSED PARAMETERS
	IF ((@PageSize IS NULL OR @PageNumber IS NULL) AND @SortOrder IS NULL)
		BEGIN
			-- NO PAGING SPECIFIED (DEFAULT SORT), RETURN FULL DATASET
			SELECT [Rank], NotificationID, ContextName, GTTSTrackingNumber, LeahyTrackingNumber, INKTrackingNumber,
				   NotificationSubject, NotificationMessage, NotificationContextType, NotificationContextTypeID, ContextID, 
				   ModifiedDate, Unread
			  FROM #searchSet;
		END
	ELSE IF ((@PageSize IS NULL OR @PageNumber IS NULL ) AND @SortOrder IS NOT NULL)
		BEGIN
			-- NO PAGING SPECIFIED, RETURN FULL DATASET
			SELECT [Rank], NotificationID, ContextName, GTTSTrackingNumber, LeahyTrackingNumber, INKTrackingNumber,
				   NotificationSubject, NotificationMessage, NotificationContextType, NotificationContextTypeID, ContextID, 
				   ModifiedDate, Unread
			  FROM #searchSet
		  ORDER BY		-- DYNAMIC SORT
			CASE WHEN @SortDirection = 'ASC' THEN
				CASE @SortOrder
				    WHEN 'NotificationContextType'  THEN NotificationContextType
				    WHEN 'NotificationSubject'      THEN NotificationSubject
				    WHEN 'ModifiedDate'             THEN CONVERT(varchar, ModifiedDate, 21) 
					WHEN 'Unread'					THEN CONVERT(VARCHAR, Unread)
				END 
			END ASC,
			CASE WHEN @SortDirection = 'DESC' THEN
				CASE @SortOrder
					WHEN 'NotificationContextType'  THEN NotificationContextType
				    WHEN 'NotificationSubject'      THEN NotificationSubject
				    WHEN 'ModifiedDate'             THEN CONVERT(varchar, ModifiedDate, 21) 
					WHEN 'Unread'					THEN CONVERT(VARCHAR, Unread)
				END
			END DESC
		END
	ELSE IF (@PageSize IS NOT NULL OR @PageNumber IS NOT NULL AND @SortOrder IS NULL)
		BEGIN
			-- PAGING PARAMETERS SPECIFIED, GENERATE REQUESTED PAGE
		    -- THEN JOIN TO TABLE TO GET FULL THE RESET OF DATA
			;WITH paged AS 
		    (
			    SELECT Unread, NotificationID, ModifiedDate
			      FROM #searchSet
		      ORDER BY		-- DYNAMIC SORT
			    CASE WHEN @SortDirection = 'ASC' THEN
				    CASE @SortOrder
				        WHEN 'NotificationContextType'  THEN NotificationContextType
				        WHEN 'NotificationSubject'      THEN NotificationSubject
				        WHEN 'ModifiedDate'             THEN CONVERT(varchar, ModifiedDate, 21) 
						WHEN 'Unread'					THEN CONVERT(VARCHAR, Unread)
				    END 
			    END ASC,
			    CASE WHEN @SortDirection = 'DESC' THEN
				    CASE @SortOrder
					    WHEN 'NotificationContextType'  THEN NotificationContextType
				        WHEN 'NotificationSubject'      THEN NotificationSubject
				        WHEN 'ModifiedDate'             THEN CONVERT(varchar, ModifiedDate, 21) 
						WHEN 'Unread'					THEN CONVERT(VARCHAR, Unread)
				    END
			    END DESC
			    OFFSET @PageSize * (@PageNumber - 1) ROWS	-- DETERMINE OFFSET
			    FETCH NEXT @PageSize ROWS ONLY				-- FETCH @PageSize RECORDS
		    )
		    SELECT [Rank], p.NotificationID, ContextName, GTTSTrackingNumber, LeahyTrackingNumber, INKTrackingNumber,
				   NotificationSubject, NotificationMessage, NotificationContextType, NotificationContextTypeID, ContextID, 
				   p.ModifiedDate, p.Unread
		      FROM paged p
	    INNER JOIN #searchSet n ON p.NotificationID = n.NotificationID
	      ORDER BY		-- DYNAMIC SORT
			    CASE WHEN @SortDirection = 'ASC' THEN
				    CASE @SortOrder
				        WHEN 'NotificationContextType'  THEN NotificationContextType
				        WHEN 'NotificationSubject'      THEN NotificationSubject
				        WHEN 'ModifiedDate'             THEN CONVERT(varchar, p.ModifiedDate, 21) 
						WHEN 'Unread'					THEN CONVERT(VARCHAR, p.Unread)
				    END 
			    END ASC,
			    CASE WHEN @SortDirection = 'DESC' THEN
				    CASE @SortOrder
					    WHEN 'NotificationContextType'  THEN NotificationContextType
				        WHEN 'NotificationSubject'      THEN NotificationSubject
				        WHEN 'ModifiedDate'             THEN CONVERT(varchar, p.ModifiedDate, 21) 
						WHEN 'Unread'					THEN CONVERT(VARCHAR, p.Unread)
				    END
			    END DESC  
		END
	ELSE
		BEGIN
			-- PAGING PARAMETERS SPECIFIED (DEFAULT SORT), GENERATE REQUESTED PAGE
		    -- THEN JOIN TO TABLE TO GET FULL THE RESET OF DATA
			;WITH paged AS 
		    (
			    SELECT Unread, NotificationID, ModifiedDate
			      FROM #searchSet
		      ORDER BY Unread DESC, Rank DESC
			    OFFSET @PageSize * (@PageNumber - 1) ROWS	-- DETERMINE OFFSET
			    FETCH NEXT @PageSize ROWS ONLY				-- FETCH @PageSize RECORDS
		    )
		    SELECT [Rank], p.NotificationID, ContextName, GTTSTrackingNumber, LeahyTrackingNumber, INKTrackingNumber,
				   NotificationSubject, NotificationMessage, NotificationContextType, NotificationContextTypeID, ContextID, 
				   p.ModifiedDate, p.Unread
		      FROM paged p
	    INNER JOIN #searchSet n ON p.NotificationID = n.NotificationID
	      ORDER BY Unread DESC, Rank DESC 
		END

END;