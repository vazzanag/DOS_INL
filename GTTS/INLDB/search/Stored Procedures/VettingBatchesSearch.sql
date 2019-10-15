CREATE PROCEDURE [search].[VettingBatchesSearch]
    @SearchString NVARCHAR(4000) = NULL,
    @CountryID INT = NULL,
	@FilterStatus NVARCHAR(25) = NULL
AS
BEGIN

    -- CHECK FOR INVALID PARAMETERS
    IF @SearchString IS NULL AND @CountryID IS NULL
        THROW 50000,  'Invalid parameters',  1
    
    -- VERIFY @SearchString HAS A VALUE
    IF (LEN(@SearchString) = 0)
        THROW 50000,  'Search criteria not specified',  1;

	-- VERIFY @FilterStatus HAS A VALUE
	IF (LEN(TRIM(@FilterStatus)) = 0)
		SET @FilterStatus = NULL;
	DECLARE @Hits INT;
	SET @Hits = CASE WHEN @FilterStatus = 'Hits' THEN 1 ELSE NULL END; 
	
	---
	DECLARE @tblStatuses TABLE ( Value NVARCHAR(MAX) )
	IF(@FilterStatus = 'Courtesy Complete')  
		BEGIN 
			INSERT INTO @tblStatuses VALUES ('COURTESY COMPLETED')
		END 
	ELSE IF(@FilterStatus = 'Leahy Complete')
		BEGIN 
			INSERT INTO @tblStatuses VALUES ('LEAHY RESULTS RETURNED')
		END 
	ELSE IF(@FilterStatus = 'Results Notified')
		BEGIN
			INSERT INTO @tblStatuses VALUES ('CLOSED')
		END 
	ELSE IF(@FilterStatus = 'Results submitted')
		BEGIN
			INSERT INTO @tblStatuses VALUES ('CLOSED')   
			INSERT INTO @tblStatuses VALUES ('COURTESY COMPLETED')
			INSERT INTO @tblStatuses VALUES ('SUBMITTED TO COURTESY')
		END 
	ELSE IF(@FilterStatus = 'In Progress')
		BEGIN
			INSERT INTO @tblStatuses VALUES ('SUBMITTED TO COURTESY')
		END 
	ELSE IF(@FilterStatus IS NOT NULL AND @FilterStatus <> '' AND @FilterStatus <> 'All requests' AND @FilterStatus <> 'Hits')  
		BEGIN
			INSERT INTO @tblStatuses VALUES (@FilterStatus)
		END 
	ELSE
		BEGIN
			DECLARE @Code VARCHAR(MAX)

			DECLARE MY_CURSOR CURSOR 
			  LOCAL STATIC READ_ONLY FORWARD_ONLY
			FOR 
			SELECT DISTINCT Code 
			FROM [vetting].[VettingBatchStatuses]

			OPEN MY_CURSOR
			FETCH NEXT FROM MY_CURSOR INTO @Code
			WHILE @@FETCH_STATUS = 0
			BEGIN 
				INSERT INTO @tblStatuses VALUES (@Code)
				FETCH NEXT FROM MY_CURSOR INTO @Code
			END
			CLOSE MY_CURSOR
			DEALLOCATE MY_CURSOR		
		END
	---

    DECLARE @Query NVARCHAR(4000), 
            @DelimIndex SMALLINT, 
            @Word NVARCHAR(200),
            @SearchTrimmed NVARCHAR(4000),
            @FirstWord BIT,
            @FirstDate DATE,
            @LastDate DATE,
            @SwapDate DATE;

    SET @FirstWord = 1;

    IF OBJECT_ID('tempdb..#inclusiveSet') IS NOT NULL
        DROP TABLE #inclusiveSet
    IF OBJECT_ID('tempdb..#searchSet') IS NOT NULL
        DROP TABLE #searchSet
    CREATE TABLE #inclusiveSet (VettingBatchID BIGINT);
    CREATE TABLE #searchSet (VettingBatchID BIGINT);


    IF (EXISTS(SELECT CountryID FROM [location].Countries WHERE @SearchString LIKE '%' + CountryName + '%' OR @SearchString LIKE '%' + CountryFullName + '%'))
    BEGIN
        SELECT @CountryID = CountryID FROM [location].Countries WHERE @SearchString LIKE '%' + CountryName + '%' OR @SearchString LIKE '%' + CountryFullName + '%'
    END


	-- INITIALIZE VARIABLES
    SET @Query = '';
    SET @SearchTrimmed = TRIM(@SearchString)

	-- ITERATE WORDS
    SET @DelimIndex = CHARINDEX(' ', @SearchTrimmed, 0);
    WHILE (@DelimIndex != 0)
    BEGIN
        -- GET WORD
        SET @Word = TRIM(SUBSTRING(@SearchTrimmed, 0, @DelimIndex));
		IF @word <> ''
		BEGIN
            -- CHECK FOR DATE VALUE
            IF ISDATE(@word) = 1
                BEGIN
                    IF @FirstDate IS NULL
                        SET @FirstDate = CONVERT(DATE, @word);
                    ELSE
                    BEGIN
                        SET @LastDate = CONVERT(DATE, @word);
                        IF @LastDate IS NOT NULL AND @FirstDate > @LastDate
                        BEGIN
                            SET @SwapDate = @LastDate;
                            SET @LastDate = @FirstDate;
                            Set @FirstDate = @SwapDate;
                        END;
                    END;
                END;
            ELSE
                BEGIN
			        TRUNCATE TABLE #searchSet;

                    -- PERFORM SEARCH AND PUT RESULTS IN TEMP TABLE
			        INSERT INTO #searchSet
				        SELECT VettingBatchID
				          FROM search.VettingBatchesJSONView v
				         WHERE (v.VettingBatchJSON LIKE CONCAT('%', @Word, '%')
					        OR v.PersonsVettingJSON LIKE CONCAT('%', @Word, '%')
					        OR v.VettingHitsJSON LIKE CONCAT('%', @Word, '%')
					        OR v.LeahyHitsJSON LIKE CONCAT('%', @Word, '%'))
				           AND v.CountryID = ISNULL(@CountryID, v.CountryID)
			          GROUP BY v.VettingBatchID

			        -- UPDATE #inclusionSet
			        IF (@FirstWord = 1)
				        INSERT INTO #inclusiveSet
				        SELECT VettingBatchID FROM #searchSet;
			        ELSE
				        DELETE FROM #inclusiveSet
				         WHERE VettingBatchID NOT IN (SELECT VettingBatchID FROM #searchSet);
                
                    -- RESET @FirstWord
		            SET @FirstWord = 0;
                END;
        END;
		-- UPDATE @SearchTrimmed
        SET @SearchTrimmed = TRIM(SUBSTRING(@SearchTrimmed, @DelimIndex+1, LEN(@SearchTrimmed)-@DelimIndex));

        -- GET NEXT INDEX
        SET @DelimIndex = CHARINDEX(' ', @SearchTrimmed, 0);

    END;

    -- ADD THE LAST WORD
	SET @Word = @SearchTrimmed;
    IF (TRIM(@Word) <> '')
	BEGIN
        -- CHECK FOR DATE VALUE
        IF ISDATE(@word) = 1
            BEGIN
                IF @FirstDate IS NULL
                    SET @FirstDate = CONVERT(DATE, @word);
                ELSE
                BEGIN
                    SET @LastDate = CONVERT(DATE, @word);
                    IF @LastDate IS NOT NULL AND @FirstDate > @LastDate
                    BEGIN
                        SET @SwapDate = @LastDate;
                        SET @LastDate = @FirstDate;
                        Set @FirstDate = @SwapDate;
                    END;
                END;
            END;
        ELSE
            BEGIN
                TRUNCATE TABLE #searchSet;

		        INSERT INTO #searchSet
			        SELECT VettingBatchID
			          FROM search.VettingBatchesJSONView v
			         WHERE (v.VettingBatchJSON LIKE CONCAT('%', @Word, '%')
			            OR v.PersonsVettingJSON LIKE CONCAT('%', @Word, '%')
			            OR v.VettingHitsJSON LIKE CONCAT('%', @Word, '%')
			            OR v.LeahyHitsJSON LIKE CONCAT('%', @Word, '%'))
			           AND v.CountryID = ISNULL(@CountryID, v.CountryID)
		          GROUP BY v.VettingBatchID;

		        -- UPDATE #inclusionSet
		        IF (@FirstWord = 1)
			        INSERT INTO #inclusiveSet
			        SELECT VettingBatchID FROM #searchSet;
		        ELSE
			        DELETE FROM #inclusiveSet
			         WHERE VettingBatchID NOT IN (SELECT VettingBatchID FROM #searchSet);

                -- RESET @FirstWord
		        SET @FirstWord = 0;
            END;
	END;

-- FINAL RESULTSET JOINING VettingBatchID FROM SEARCH TEMP TABLES WITH VettingBatchesDetailView 
-- IN CONBINATION WITH DATES AND @FirstWord CRITERIA
IF @FirstDate IS NOT NULL AND @LastDate IS NOT NULL AND @FirstWord = 0     -- VettingBatches WITHIN A DATE RANGE
    SELECT TrainingEventName, FundingSourceCode, FundingSource, AuthorizingLawCode, AuthorizingLaw, VettingBatchType,
	       VettingBatchStatus, v.VettingBatchID, VettingBatchName, VettingBatchNumber, DateAccepted, DateCourtesyCompleted,
	       DateLeahyResultsReceived, DateSentToCourtesy, DateSentToLeahy, DateSubmitted, DateVettingResultsNeededBy,
	       DateVettingResultsNotified, GTTSTrackingNumber, LeahyTrackingNumber, INKTrackingNumber, u.FullName, AssignedToAppUserID, 
           (SELECT COUNT(@@ROWCOUNT) FROM vetting.PersonsVetting WHERE VettingBatchID = v.VettingBatchID) PersonsCount,
           (SELECT MIN(EventStartDate) FROM training.TrainingEventLocations WHERE TrainingEventID = v.TrainingEventID) EventStartDate
      FROM search.VettingBatchesDetailView v
INNER JOIN (select VettingBatchID from #inclusiveSet GROUP BY VettingBatchID) i ON v.VettingBatchID = i.VettingBatchID
 LEFT JOIN users.AppUsersView u ON v.AssignedToAppUserID = u.AppUserID
     WHERE CAST(v.DateSubmitted AS DATE) BETWEEN @FirstDate AND @LastDate AND v.VettingBatchStatus IN ((SELECT value FROM @tblStatuses));

ELSE IF @FirstDate IS NOT NULL AND @LastDate IS NOT NULL AND @FirstWord = 1-- VettingBatches WITHIN A DATE RANGE
    SELECT TrainingEventName, FundingSourceCode, FundingSource, AuthorizingLawCode, AuthorizingLaw, VettingBatchType,
	       VettingBatchStatus, v.VettingBatchID, VettingBatchName, VettingBatchNumber, DateAccepted, DateCourtesyCompleted,
	       DateLeahyResultsReceived, DateSentToCourtesy, DateSentToLeahy, DateSubmitted, DateVettingResultsNeededBy,
	       DateVettingResultsNotified, GTTSTrackingNumber, LeahyTrackingNumber, INKTrackingNumber, u.FullName, AssignedToAppUserID, 
           (SELECT COUNT(@@ROWCOUNT) FROM vetting.PersonsVetting WHERE VettingBatchID = v.VettingBatchID) PersonsCount,
           (SELECT MIN(EventStartDate) FROM training.TrainingEventLocations WHERE TrainingEventID = v.TrainingEventID) EventStartDate
      FROM search.VettingBatchesDetailView v
 LEFT JOIN users.AppUsersView u ON v.AssignedToAppUserID = u.AppUserID
     WHERE CAST(v.DateSubmitted AS DATE) BETWEEN @FirstDate AND @LastDate AND v.VettingBatchStatus IN ((SELECT value FROM @tblStatuses));

ELSE IF @FirstDate IS NOT NULL AND @LastDate IS NULL AND @FirstWord = 0    -- VettingBatches ON A CERTAIN DATE
    SELECT TrainingEventName, FundingSourceCode, FundingSource, AuthorizingLawCode, AuthorizingLaw, VettingBatchType,
	       VettingBatchStatus, v.VettingBatchID, VettingBatchName, VettingBatchNumber, DateAccepted, DateCourtesyCompleted,
	       DateLeahyResultsReceived, DateSentToCourtesy, DateSentToLeahy, DateSubmitted, DateVettingResultsNeededBy,
	       DateVettingResultsNotified, GTTSTrackingNumber, LeahyTrackingNumber, INKTrackingNumber, u.FullName, AssignedToAppUserID, 
           (SELECT COUNT(@@ROWCOUNT) FROM vetting.PersonsVetting WHERE VettingBatchID = v.VettingBatchID) PersonsCount,
           (SELECT MIN(EventStartDate) FROM training.TrainingEventLocations WHERE TrainingEventID = v.TrainingEventID) EventStartDate
      FROM search.VettingBatchesDetailView v
INNER JOIN (select VettingBatchID from #inclusiveSet GROUP BY VettingBatchID) i ON v.VettingBatchID = i.VettingBatchID
 LEFT JOIN users.AppUsersView u ON v.AssignedToAppUserID = u.AppUserID
     WHERE CAST(v.DateSubmitted AS DATE) = @FirstDate AND v.VettingBatchStatus IN ((SELECT value FROM @tblStatuses));

ELSE IF @FirstDate IS NOT NULL AND @LastDate IS NULL AND @FirstWord = 1    -- VettingBatches ON A CERTAIN DATE
    SELECT TrainingEventName, FundingSourceCode, FundingSource, AuthorizingLawCode, AuthorizingLaw, VettingBatchType,
	       VettingBatchStatus, v.VettingBatchID, VettingBatchName, VettingBatchNumber, DateAccepted, DateCourtesyCompleted,
	       DateLeahyResultsReceived, DateSentToCourtesy, DateSentToLeahy, DateSubmitted, DateVettingResultsNeededBy,
	       DateVettingResultsNotified, GTTSTrackingNumber, LeahyTrackingNumber, INKTrackingNumber, u.FullName, AssignedToAppUserID, 
           (SELECT COUNT(@@ROWCOUNT) FROM vetting.PersonsVetting WHERE VettingBatchID = v.VettingBatchID) PersonsCount,
           (SELECT MIN(EventStartDate) FROM training.TrainingEventLocations WHERE TrainingEventID = v.TrainingEventID) EventStartDate
      FROM search.VettingBatchesDetailView v
 LEFT JOIN users.AppUsersView u ON v.AssignedToAppUserID = u.AppUserID
     WHERE CAST(v.DateSubmitted AS DATE) = @FirstDate AND v.VettingBatchStatus IN ((SELECT value FROM @tblStatuses));

ELSE                                                                       -- VettingBatches, NO DATE FILTERING
    BEGIN
		IF (@Hits = 1)
		BEGIN
			SELECT TrainingEventName, FundingSourceCode, FundingSource, AuthorizingLawCode, AuthorizingLaw, VettingBatchType,
				   VettingBatchStatus, v.VettingBatchID, VettingBatchName, VettingBatchNumber, DateAccepted, DateCourtesyCompleted,
				   DateLeahyResultsReceived, DateSentToCourtesy, DateSentToLeahy, DateSubmitted, DateVettingResultsNeededBy,
				   DateVettingResultsNotified, GTTSTrackingNumber, LeahyTrackingNumber, INKTrackingNumber, u.FullName, AssignedToAppUserID, 
				   (SELECT COUNT(@@ROWCOUNT) FROM vetting.PersonsVetting WHERE VettingBatchID = v.VettingBatchID) PersonsCount,
				   (SELECT MIN(EventStartDate) FROM training.TrainingEventLocations WHERE TrainingEventID = v.TrainingEventID) EventStartDate
			  FROM search.VettingBatchesDetailView v
				INNER JOIN (select VettingBatchID from #inclusiveSet GROUP BY VettingBatchID) i ON v.VettingBatchID = i.VettingBatchID
				LEFT JOIN users.AppUsersView u ON v.AssignedToAppUserID = u.AppUserID
			  WHERE ( SELECT COUNT(CASE WHEN pv.HitResultID IS NOT NULL THEN 1 END)
					  FROM vetting.PersonsVettingVettingTypes AS pv 
						   JOIN vetting.PersonsVetting AS p ON pv.PersonsVettingID = p.PersonsVettingID
					  WHERE p.VettingBatchID = v.VettingBatchID ) >= @Hits AND v.VettingBatchStatus <> 'CLOSED';
		END
		ELSE
		BEGIN
			SELECT TrainingEventName, FundingSourceCode, FundingSource, AuthorizingLawCode, AuthorizingLaw, VettingBatchType,
				   VettingBatchStatus, v.VettingBatchID, VettingBatchName, VettingBatchNumber, DateAccepted, DateCourtesyCompleted,
				   DateLeahyResultsReceived, DateSentToCourtesy, DateSentToLeahy, DateSubmitted, DateVettingResultsNeededBy,
				   DateVettingResultsNotified, GTTSTrackingNumber, LeahyTrackingNumber, INKTrackingNumber, u.FullName, AssignedToAppUserID, 
				   (SELECT COUNT(@@ROWCOUNT) FROM vetting.PersonsVetting WHERE VettingBatchID = v.VettingBatchID) PersonsCount,
				   (SELECT MIN(EventStartDate) FROM training.TrainingEventLocations WHERE TrainingEventID = v.TrainingEventID) EventStartDate
			  FROM search.VettingBatchesDetailView v
				INNER JOIN (select VettingBatchID from #inclusiveSet GROUP BY VettingBatchID) i ON v.VettingBatchID = i.VettingBatchID
				LEFT JOIN users.AppUsersView u ON v.AssignedToAppUserID = u.AppUserID
			  WHERE v.VettingBatchStatus IN ((SELECT value FROM @tblStatuses));
		END
	END
END
