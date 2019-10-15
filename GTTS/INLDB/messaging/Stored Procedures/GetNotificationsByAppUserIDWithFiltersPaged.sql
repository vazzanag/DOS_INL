CREATE PROCEDURE [messaging].[GetNotificationsByAppUserIDWithFiltersPaged]
    @AppUserID INT,
    @NotificationContextTypeID INT = NULL,
    @ContextID BIGINT = NULL,
    @PageSize INT = NULL, 
    @PageNumber INT = NULL,
    @SortOrder NVARCHAR(100) = NULL,
    @SortDirection NVARCHAR(4) = 'ASC'
AS
BEGIN

    -- VALIDATE PARAMETERS
	IF (@AppUserID < 1 OR @AppUserID IS NULL)
		THROW 51000, 'Invalid parameters.  AppUserID is a required parameter', 1;
	
	IF (@ContextID IS NOT NULL AND @NotificationContextTypeID IS NULL)
		THROW 51000, 'Invalid parameters.  Context Type is required if Context ID is provided', 1;

	IF ((@PageSize IS NOT NULL AND @PageNumber IS NULL) OR (@PageNumber IS NOT NULL AND @PageSize IS NULL))
		THROW 51000, 'Invalid parameters.  Both page size and page number are required when either is supplied', 1;

	DECLARE @AdditionalNotifications TABLE
	(
		NotificationID bigint, Unread bit, NotificationSubject nvarchar(500), NotificationMessage nvarchar(MAX), NotificationContextType nvarchar (100),
		NotificationContextTypeID int, ContextID bigint, ModifiedDate datetime, AppUserID int, ViewedDate datetime, IncludeContextLink bit
	)
    
	IF (@NotificationContextTypeID = 1 AND @ContextID IS NOT NULL)
	BEGIN
		INSERT INTO @AdditionalNotifications
		SELECT NotificationID, Unread, NotificationSubject, NotificationMessage, NotificationContextType, 
		       NotificationContextTypeID, ContextID, ModifiedDate, AppUserID, ViewedDate, IncludeContextLink 
		  FROM messaging.NotificationsWithRecipientsView
		 WHERE AppUserID = @AppUserID
		   AND NotificationContextTypeID = 2
		   AND ContextID IN (select VettingBatchID from vetting.VettingBatches where TrainingEventID = @ContextID)
	END;

    -- GET TOTAL NUMBER OF RECORDS
    SELECT COUNT(@@ROWCOUNT) + (SELECT COUNT(@@ROWCOUNT) FROM @AdditionalNotifications) AS RecordCount
		FROM  messaging.NotificationsWithRecipientsView
		WHERE AppUserID = @AppUserID
		AND NotificationContextTypeID = ISNULL(@NotificationContextTypeID, NotificationContextTypeID)
		AND ContextID = ISNULL(@ContextID, ContextID)


	IF ((@PageSize IS NULL OR @PageNumber IS NULL) AND @SortOrder IS NULL)
	    BEGIN
            -- NO PAGING SPECIFIED (DEFAULT SORT), RETURN FULL DATASET
		    SELECT NotificationID, Unread, NotificationSubject, NotificationMessage, NotificationContextType, 
		           NotificationContextTypeID, ContextID, ModifiedDate, AppUserID, ViewedDate, IncludeContextLink 
              FROM messaging.NotificationsWithRecipientsView
		     WHERE AppUserID = @AppUserID
			   AND NotificationContextTypeID = ISNULL(@NotificationContextTypeID, NotificationContextTypeID)
			   AND ContextID = ISNULL(@ContextID, ContextID)
		UNION
			SELECT NotificationID, Unread, NotificationSubject, NotificationMessage, NotificationContextType, 
		           NotificationContextTypeID, ContextID, ModifiedDate, AppUserID, ViewedDate, IncludeContextLink 
              FROM @AdditionalNotifications
	      ORDER BY Unread DESC, ModifiedDate DESC;
	    END
    ELSE IF ((@PageSize IS NULL OR @PageNumber IS NULL ) AND @SortOrder IS NOT NULL)
        BEGIN
            -- NO PAGING SPECIFIED, RETURN FULL DATASET
			SELECT NotificationID, Unread, NotificationSubject, NotificationMessage, NotificationContextType, 
		           NotificationContextTypeID, ContextID, ModifiedDate, AppUserID, ViewedDate, IncludeContextLink 
			  FROM (
					SELECT NotificationID, Unread, NotificationSubject, NotificationMessage, NotificationContextType, 
						   NotificationContextTypeID, ContextID, ModifiedDate, AppUserID, ViewedDate, IncludeContextLink 
					  FROM messaging.NotificationsWithRecipientsView
					 WHERE AppUserID = @AppUserID
					   AND NotificationContextTypeID = ISNULL(@NotificationContextTypeID, NotificationContextTypeID)
					   AND ContextID = ISNULL(@ContextID, ContextID)
				UNION
					SELECT NotificationID, Unread, NotificationSubject, NotificationMessage, NotificationContextType, 
						   NotificationContextTypeID, ContextID, ModifiedDate, AppUserID, ViewedDate, IncludeContextLink 
					  FROM @AdditionalNotifications
					) x
          ORDER BY		-- DYNAMIC SORT
			    CASE WHEN @SortDirection = 'ASC' THEN
				    CASE @SortOrder
				        WHEN 'NotificationContextType'  THEN NotificationContextType
				        WHEN 'NotificationSubject'      THEN NotificationSubject
				        WHEN 'ModifiedDate'             THEN CONVERT(varchar, ModifiedDate, 21) 
						WHEN 'ViewedDate'				THEN CONVERT(varchar, ViewedDate, 21) 
						WHEN 'Unread'					THEN CONVERT(VARCHAR, Unread)
				    END 
			    END ASC,
			    CASE WHEN @SortDirection = 'DESC' THEN
				    CASE @SortOrder
					    WHEN 'NotificationContextType'  THEN NotificationContextType
				        WHEN 'NotificationSubject'      THEN NotificationSubject
				        WHEN 'ModifiedDate'             THEN CONVERT(varchar, ModifiedDate, 21) 
						WHEN 'ViewedDate'				THEN CONVERT(varchar, ViewedDate, 21) 
						WHEN 'Unread'					THEN CONVERT(VARCHAR, Unread)
				    END
			    END DESC
        END
     ELSE IF ((@PageSize IS NOT NULL OR @PageNumber IS NOT NULL) AND @SortOrder IS NOT NULL)
        BEGIN
		    -- PAGING PARAMETERS SPECIFIED, GENERATE REQUESTED PAGE
		    -- THEN JOIN TO TABLE TO GET FULL THE RESET OF DATA
			print '@PageSize IS NOT NULL OR @PageNumber IS NOT NULL AND @SortOrder IS NOT NULL'
		    ;WITH paged AS 
		    (
			    SELECT Unread, NotificationID, ViewedDate, ModifiedDate, NotificationContextType, NotificationSubject
				  FROM (
						SELECT Unread, NotificationID, ViewedDate, ModifiedDate, NotificationContextType, NotificationSubject
						  FROM messaging.NotificationsWithRecipientsView
						 WHERE AppUserID = @AppUserID
						   AND NotificationContextTypeID = ISNULL(@NotificationContextTypeID, NotificationContextTypeID)
						   AND ContextID = ISNULL(@ContextID, ContextID)
					UNION
						SELECT Unread, NotificationID, ViewedDate, ModifiedDate, NotificationContextType, NotificationSubject
						  FROM @AdditionalNotifications
					) x
		      ORDER BY		-- DYNAMIC SORT
			    CASE WHEN @SortDirection = 'ASC' THEN
				    CASE @SortOrder
				        WHEN 'NotificationContextType'  THEN NotificationContextType
				        WHEN 'NotificationSubject'      THEN NotificationSubject
				        WHEN 'ModifiedDate'             THEN CONVERT(varchar, ModifiedDate, 21) 
						WHEN 'ViewedDate'				THEN CONVERT(varchar, ViewedDate, 21) 
						WHEN 'Unread'					THEN CONVERT(VARCHAR, Unread)
				    END 
			    END ASC,
			    CASE WHEN @SortDirection = 'DESC' THEN
				    CASE @SortOrder
					    WHEN 'NotificationContextType'  THEN NotificationContextType
				        WHEN 'NotificationSubject'      THEN NotificationSubject
				        WHEN 'ModifiedDate'             THEN CONVERT(varchar, ModifiedDate, 21) 
						WHEN 'ViewedDate'				THEN CONVERT(varchar, ViewedDate, 21) 
						WHEN 'Unread'					THEN CONVERT(VARCHAR, Unread)
				    END
			    END DESC
			    OFFSET @PageSize * (@PageNumber - 1) ROWS	-- DETERMINE OFFSET
			    FETCH NEXT @PageSize ROWS ONLY				-- FETCH @PageSize RECORDS
		    )
		    SELECT n.NotificationID, p.Unread,	n.NotificationSubject, NotificationMessage, n.NotificationContextType, 
		           NotificationContextTypeID, ContextID, n.ModifiedDate, AppUserID, n.ViewedDate, n.IncludeContextLink 
		      FROM paged p
	    INNER JOIN messaging.NotificationsWithRecipientsView n ON p.NotificationID = n.NotificationID
		     WHERE n.AppUserID = @AppUserID
	      ORDER BY		-- DYNAMIC SORT
			    CASE WHEN @SortDirection = 'ASC' THEN
				    CASE @SortOrder
				        WHEN 'NotificationContextType'  THEN n.NotificationContextType
				        WHEN 'NotificationSubject'      THEN n.NotificationSubject
				        WHEN 'ModifiedDate'             THEN CONVERT(varchar, p.ModifiedDate, 21) 
						WHEN 'ViewedDate'				THEN CONVERT(varchar, n.ViewedDate, 21) 
						WHEN 'Unread'					THEN CONVERT(VARCHAR, p.Unread)
				    END 
			    END ASC,
			    CASE WHEN @SortDirection = 'DESC' THEN
				    CASE @SortOrder
					    WHEN 'NotificationContextType'  THEN n.NotificationContextType
				        WHEN 'NotificationSubject'      THEN n.NotificationSubject
				        WHEN 'ModifiedDate'             THEN CONVERT(varchar, p.ModifiedDate, 21) 
						WHEN 'ViewedDate'				THEN CONVERT(varchar, n.ViewedDate, 21) 
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
			    SELECT Unread, NotificationID, ViewedDate, ModifiedDate
				  FROM (
						SELECT Unread, NotificationID, ViewedDate, ModifiedDate
						  FROM messaging.NotificationsWithRecipientsView
						 WHERE AppUserID = @AppUserID
						   AND NotificationContextTypeID = ISNULL(@NotificationContextTypeID, NotificationContextTypeID)
						   AND ContextID = ISNULL(@ContextID, ContextID)
					UNION 
						SELECT Unread, NotificationID, ViewedDate, ModifiedDate
						  FROM @AdditionalNotifications
						) x
		      ORDER BY Unread DESC, ModifiedDate DESC
			    OFFSET @PageSize * (@PageNumber - 1) ROWS	-- DETERMINE OFFSET
			    FETCH NEXT @PageSize ROWS ONLY				-- FETCH @PageSize RECORDS
		    )
		    SELECT n.NotificationID, p.Unread, NotificationSubject, NotificationMessage, NotificationContextType, 
		           NotificationContextTypeID, ContextID, n.ModifiedDate, AppUserID, n.ViewedDate, n.IncludeContextLink 
		      FROM paged p
	    INNER JOIN messaging.NotificationsWithRecipientsView n ON p.NotificationID = n.NotificationID
		     WHERE n.AppUserID = @AppUserID
	      ORDER BY p.Unread DESC, p.ModifiedDate DESC
	    END
END;