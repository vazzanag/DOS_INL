CREATE PROCEDURE [search].[TrainingEventSearch]
    @SearchString NVARCHAR(3500) = NULL,
    @CountryID INT = NULL,
    @TrainingEventID BIGINT = NULL
AS
BEGIN

    -- CHECK FOR INVALID PARAMETERS
    IF @SearchString IS NULL AND @CountryID IS NULL
        THROW 50000,  'Invalid parameters',  1
    
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

    IF OBJECT_ID('tempdb..#inclusiveSet') IS NOT NULL
        DROP TABLE #inclusiveSet
    IF OBJECT_ID('tempdb..#searchSet') IS NOT NULL
        DROP TABLE #searchSet
    CREATE TABLE #inclusiveSet (TrainingEventID BIGINT);
    CREATE TABLE #searchSet (TrainingEventID BIGINT);

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
				        SELECT te.TrainingEventID
						FROM training.TrainingEvents te
						INNER JOIN users.BusinessUnits AS bu ON bu.BusinessUnitID = te.TrainingUnitID
						INNER JOIN training.TrainingEventLocationsView AS lov ON lov.TrainingEventID = te.TrainingEventID
						INNER JOIN training.TrainingEventTypes AS tet ON tet.TrainingEventTypeID = te.TrainingEventTypeID
						INNER JOIN training.TrainingEventKeyActivities AS teka ON teka.TrainingEventID = te.TrainingEventID
						INNER JOIN training.KeyActivities AS ka ON ka.KeyActivityID = teka.KeyActivityID
						LEFT JOIN users.AppUsersView auv ON auv.AppUserID = te.OrganizerAppUserID
						WHERE (bu.Acronym COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
								OR te.Name COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
								OR lov.LocationName COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
								OR tet.Name COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
								OR ka.Code COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
								OR auv.FullName COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%'))
								AND te.CountryID = ISNULL(@CountryID, te.CountryID)
								AND te.TrainingEventID <> ISNULL(@TrainingEventID, -1)
						GROUP BY te.TrainingEventID;

			        -- UPDATE #inclusionSet
			        IF (@FirstWord = 1)
				        INSERT INTO #inclusiveSet
				        SELECT TrainingEventID FROM #searchSet;
			        ELSE
				        DELETE FROM #inclusiveSet
				         WHERE TrainingEventID NOT IN (SELECT TrainingEventID FROM #searchSet);
                
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
			        SELECT te.TrainingEventID
					FROM training.TrainingEvents te
					INNER JOIN users.BusinessUnits AS bu ON bu.BusinessUnitID = te.TrainingUnitID
					INNER JOIN training.TrainingEventLocationsView AS lov ON lov.TrainingEventID = te.TrainingEventID
					INNER JOIN training.TrainingEventTypes AS tet ON tet.TrainingEventTypeID = te.TrainingEventTypeID
					INNER JOIN training.TrainingEventKeyActivities AS teka ON teka.TrainingEventID = te.TrainingEventID
					INNER JOIN training.KeyActivities AS ka ON ka.KeyActivityID = teka.KeyActivityID
					LEFT JOIN users.AppUsersView auv ON auv.AppUserID = te.OrganizerAppUserID
					WHERE (bu.Acronym COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
							OR te.Name COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
							OR lov.LocationName COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
							OR tet.Name COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
							OR ka.Code COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
							OR auv.FullName COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%'))
							AND te.CountryID = ISNULL(@CountryID, te.CountryID)
							AND te.TrainingEventID <> ISNULL(@TrainingEventID, -1)
					GROUP BY te.TrainingEventID;

		        -- UPDATE #inclusionSet
		        IF (@FirstWord = 1)
			        INSERT INTO #inclusiveSet
			        SELECT TrainingEventID FROM #searchSet;
		        ELSE
			        DELETE FROM #inclusiveSet
			         WHERE TrainingEventID NOT IN (SELECT TrainingEventID FROM #searchSet);

                -- RESET @FirstWord
		        SET @FirstWord = 0;
            END;
	END;


-- FINAL RESULTSET JOINING TrainingEventID FROM SEARCH TEMP TABLES WITH TrainingEventsView 
-- IN CONBINATION WITH DATES AND @FirstWord CRITERIA
IF @FirstDate IS NOT NULL AND @LastDate IS NOT NULL AND @FirstWord = 0     -- Training Events WITHIN A DATE RANGE
    SELECT i.TrainingEventID, [Name], NameInLocalLang, TrainingUnitID, TrainingUnitAcronym, TrainingUnit, 
           TrainingEventType, TrainingEventStatus, TrainingEventStatusID,
	       OrganizerAppUserID, OrganizerFullName, EventStartDate, EventEndDate, LocationsJSON, KeyActivitiesJSON,
	       [training].[GetParticipantCount]('Both', i.TrainingEventID, TrainingEventStatusID) ParticipantCount
      FROM search.TrainingEventsView v
INNER JOIN (select TrainingEventID from #inclusiveSet GROUP BY TrainingEventID) i ON v.TrainingEventID = i.TrainingEventID
     WHERE CAST(v.EventStartDate AS DATE) BETWEEN @FirstDate AND @LastDate
        OR CAST(v.EventEndDate AS DATE) BETWEEN @FirstDate AND @LastDate;

ELSE IF @FirstDate IS NOT NULL AND @LastDate IS NOT NULL AND @FirstWord = 1-- Training Events WITHIN A DATE RANGE
    SELECT TrainingEventID, [Name], NameInLocalLang, TrainingUnitID, TrainingUnitAcronym, TrainingUnit, 
           TrainingEventType, TrainingEventStatus, TrainingEventStatusID,
	       OrganizerAppUserID, OrganizerFullName, EventStartDate, EventEndDate, LocationsJSON, KeyActivitiesJSON,
	       [training].[GetParticipantCount]('Both', TrainingEventID, TrainingEventStatusID) ParticipantCount
      FROM search.TrainingEventsView v
     WHERE CAST(v.EventStartDate AS DATE) BETWEEN @FirstDate AND @LastDate
        OR CAST(v.EventEndDate AS DATE) BETWEEN @FirstDate AND @LastDate;

ELSE IF @FirstDate IS NOT NULL AND @LastDate IS NULL AND @FirstWord = 0    -- Training Events ON A CERTAIN DATE
    SELECT i.TrainingEventID, [Name], NameInLocalLang, TrainingUnitID, TrainingUnitAcronym, TrainingUnit, 
           TrainingEventType, TrainingEventStatus, TrainingEventStatusID,
	       OrganizerAppUserID, OrganizerFullName, EventStartDate, EventEndDate, LocationsJSON, KeyActivitiesJSON,
	       [training].[GetParticipantCount]('Both', i.TrainingEventID, TrainingEventStatusID) ParticipantCount
      FROM search.TrainingEventsView v
INNER JOIN (select TrainingEventID from #inclusiveSet GROUP BY TrainingEventID) i ON v.TrainingEventID = i.TrainingEventID
     WHERE CAST(v.EventStartDate AS DATE) = @FirstDate
        OR CAST(v.EventEndDate AS DATE) = @FirstDate;

ELSE IF @FirstDate IS NOT NULL AND @LastDate IS NULL AND @FirstWord = 1    -- Training Events ON A CERTAIN DATE
    SELECT TrainingEventID, [Name], NameInLocalLang, TrainingUnitID, TrainingUnitAcronym, TrainingUnit, 
           TrainingEventType, TrainingEventStatus, TrainingEventStatusID,
	       OrganizerAppUserID, OrganizerFullName, EventStartDate, EventEndDate, LocationsJSON, KeyActivitiesJSON,
	       [training].[GetParticipantCount]('Both', TrainingEventID, TrainingEventStatusID) ParticipantCount
      FROM search.TrainingEventsView v
     WHERE CAST(v.EventStartDate AS DATE) = @FirstDate
        OR CAST(v.EventEndDate AS DATE) = @FirstDate;

ELSE                                                                       -- Training Events, NO DATE FILTERING
    SELECT i.TrainingEventID, [Name], NameInLocalLang, TrainingUnitID, TrainingUnitAcronym, TrainingUnit, 
           TrainingEventType, TrainingEventStatus, TrainingEventStatusID,
	       OrganizerAppUserID, OrganizerFullName, EventStartDate, EventEndDate, LocationsJSON, KeyActivitiesJSON,
	       [training].[GetParticipantCount]('Both', i.TrainingEventID, TrainingEventStatusID) ParticipantCount
      FROM search.TrainingEventsView v
INNER JOIN (select TrainingEventID from #inclusiveSet GROUP BY TrainingEventID) i ON v.TrainingEventID = i.TrainingEventID
END
