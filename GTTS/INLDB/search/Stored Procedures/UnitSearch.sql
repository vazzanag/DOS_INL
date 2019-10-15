CREATE PROCEDURE [search].[UnitSearch]
    @SearchString NVARCHAR(3500) = NULL,
    @AgenciesOrUnits SMALLINT,  -- 1: Agencies, 2: Units, 3: Both
    @CountryID INT = NULL,
    @UnitMainAgencyID BIGINT = NULL,
    @PageSize INT = NULL,
    @PageNumber INT = NULL,
    @SortOrder NVARCHAR(50) = NULL,
    @SortDirection NVARCHAR(4) = 'ASC'
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

    -- SETUP TEMP TABLES
    IF OBJECT_ID('tempdb..#inclusiveSet') IS NOT NULL
        DROP TABLE #inclusiveSet
    IF OBJECT_ID('tempdb..#searchSet') IS NOT NULL
        DROP TABLE #searchSet
	IF OBJECT_ID('tempdb..#fullSet') IS NOT NULL
        DROP TABLE #fullSet

    CREATE TABLE #fullSet 
	(
		UnitID bigint, UnitAcronym nvarchar(100), UnitName nvarchar(600),  UnitNameEnglish nvarchar(600), IsMainAgency bit, UnitMainAgencyID bigint, UnitParentID bigint, 
        UnitParentName nvarchar(600), UnitParentNameEnglish nvarchar(600), AgencyName	nvarchar(600), AgencyNameEnglish nvarchar(600), UnitGenID nvarchar(100),
        UnitTypeID smallint, UnitType nvarchar(50), GovtLevelID	smallint, GovtLevel	nvarchar(50), UnitLevelID smallint, UnitLevel nvarchar(50),
        VettingBatchTypeID	tinyint, VettingBatchTypeCode nvarchar(30),VettingActivityTypeID smallint, VettingActivityType nvarchar(30),
        ReportingTypeID	smallint, ReportingType	nvarchar(100), CommanderFirstName nvarchar(300), CommanderLastName	nvarchar(300), CountryID int
	);

    CREATE TABLE #inclusiveSet (UnitID BIGINT);
    CREATE NONCLUSTERED INDEX ix_inclusiveSet ON #inclusiveSet (UnitID);

    CREATE TABLE #searchSet (UnitID BIGINT);
    CREATE NONCLUSTERED INDEX ix_searchSet ON #searchSet (UnitID);


    -- CHECK IF COUNTRY WAS PROVIDED IN SEARCH STRING
    IF (EXISTS(SELECT CountryID FROM [location].Countries WHERE @SearchString LIKE '%' + CountryName + '%' OR @SearchString LIKE '%' + CountryFullName + '%'))
    BEGIN
        SELECT @CountryID = CountryID FROM [location].Countries WHERE @SearchString LIKE '%' + CountryName + '%' OR @SearchString LIKE '%' + CountryFullName + '%'
    END


	-- INITIALIZE VARIABLES
    SET @Query = '';
    SET @SearchTrimmed = TRIM(@SearchString)
    SET @FirstWord = 1;

	-- ITERATE WORDS
    SET @DelimIndex = CHARINDEX(' ', @SearchTrimmed, 0);
    WHILE (@DelimIndex != 0)
    BEGIN
		
        -- GET WORD
        SET @Word = TRIM(SUBSTRING(@SearchTrimmed, 0, @DelimIndex));
		print 'Word: ' + @word + ' : ' + CAST(SYSDATETIME() AS NVARCHAR(100))
		
		IF @word <> ''
		BEGIN
			-- SEARCH
			IF (@FirstWord = 1)
                BEGIN
                    -- PERFORM SEARCH AND PUT RESULTS IN TEMP TABLE
                    print 'Getting #fullSet : ' + CAST(SYSDATETIME() AS NVARCHAR(100))
			        INSERT INTO #fullSet
				        SELECT UnitID, UnitAcronym, UnitName, UnitNameEnglish, IsMainAgency, UnitMainAgencyID, UnitParentID, UnitParentName, UnitParentNameEnglish, AgencyName, AgencyNameEnglish,
							   UnitGenID, UnitTypeID, UnitType, GovtLevelID, GovtLevel, UnitLevelID, UnitLevel, VettingBatchTypeID, VettingBatchTypeCode, 
							   VettingActivityTypeID, VettingActivityType, ReportingTypeID, ReportingType, CommanderFirstName, CommanderLastName, CountryID
				          FROM search.UnitsView v
				         WHERE ISNULL(v.CountryID, -1) = CASE WHEN @countryid IS NULL THEN ISNULL(v.CountryID, -1) ELSE @countryid END
                           AND ISNULL(v.UnitMainAgencyID, -1) = CASE WHEN @UnitMainAgencyID IS NULL THEN ISNULL(v.UnitMainAgencyID, -1) ELSE @UnitMainAgencyID END
                           AND IsMainAgency = (case when @AgenciesOrUnits = 1 THEN 1 WHEN @AgenciesOrUnits = 2 THEN 0 ELSE IsMainAgency END)
						   AND (UnitType COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
							or UnitName COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
							or UnitNameEnglish COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
                            or UnitParentName COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
							or UnitParentNameEnglish COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
                            or AgencyName COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
							or AgencyNameEnglish COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
							or UnitGenID COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
							or UnitAcronym COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
							or GovtLevel COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
							or UnitLevel COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
							or VettingBatchTypeCode COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
							or VettingActivityType COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
							or ReportingType COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
							or CommanderFirstName COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
							or CommanderLastName COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%'))
                            
					print 'creating index: ' + CAST(SYSDATETIME() AS NVARCHAR(100))
                    --CREATE NONCLUSTERED INDEX ix_fullSet ON #fullSet (PersonID, CountryID);
					CREATE NONCLUSTERED INDEX ix_fullSet_UnitID ON #fullSet (UnitID);
					CREATE NONCLUSTERED INDEX ix_fullSet ON #fullSet (UnitID, CountryID)
						INCLUDE (UnitAcronym, UnitName, UnitNameEnglish, UnitMainAgencyID, IsMainAgency, UnitParentID, UnitParentName, UnitParentNameEnglish, AgencyName, AgencyNameEnglish,
							UnitGenID, UnitTypeID, UnitType, GovtLevelID, GovtLevel, UnitLevelID, UnitLevel, VettingBatchTypeID, VettingBatchTypeCode, 
							VettingActivityTypeID, VettingActivityType, ReportingTypeID, ReportingType, CommanderFirstName, CommanderLastName);

					print 'inserting into #inclusiveSet: ' + CAST(SYSDATETIME() AS NVARCHAR(100))
                    INSERT INTO #inclusiveSet
                        SELECT UnitID FROM #fullSet
						GROUP BY UnitID;
                END
			ELSE
                BEGIN
                    TRUNCATE TABLE #searchSet;

                    -- PERFORM SEARCH AND PUT RESULTS IN TEMP TABLE
                    print 'Getting #searchSet : ' + CAST(SYSDATETIME() AS NVARCHAR(100))
			        INSERT INTO #searchSet
				        SELECT f.UnitID
				          FROM #inclusiveSet i WITH(INDEX(ix_inclusiveSet))
                    INNER JOIN #fullSet f WITH(INDEX(ix_fullSet)) on i.UnitID = f.UnitID
				          WHERE UnitType COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
							 or UnitName COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
							 or UnitNameEnglish COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
                             or UnitParentName COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
							 or UnitParentNameEnglish COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
                             or AgencyName COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
							 or AgencyNameEnglish COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
							 or UnitGenID COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
							 or UnitAcronym COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
							 or GovtLevel COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
							 or UnitLevel COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
							 or VettingBatchTypeCode COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
							 or VettingActivityType COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
							 or ReportingType COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
							 or CommanderFirstName COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
							 or CommanderLastName COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
					GROUP BY f.UnitID

                    print 'deleting #inclusiveSet: ' + CAST(SYSDATETIME() AS NVARCHAR(100))
				    DELETE FROM #inclusiveSet 
				        WHERE UnitID NOT IN (SELECT UnitID FROM #searchSet WITH(INDEX(ix_searchSet)) GROUP BY UnitID);
                END;

            -- RESET @FirstWord
		    SET @FirstWord = 0;
        END;
		-- UPDATE @SearchTrimmed
        SET @SearchTrimmed = TRIM(SUBSTRING(@SearchTrimmed, @DelimIndex+1, LEN(@SearchTrimmed)-@DelimIndex));

        -- GET NEXT INDEX
        SET @DelimIndex = CHARINDEX(' ', @SearchTrimmed, 0);

    END ;

	-- ADD THE LAST WORD
	SET @Word = @SearchTrimmed;
    IF (TRIM(@Word) <> '')
	BEGIN
		print 'Word: ' + @word + ' : ' + CAST(SYSDATETIME() AS NVARCHAR(100))

                
				-- SEARCH
		        IF (@FirstWord = 1)
                    BEGIN
                        INSERT INTO #fullSet
				            SELECT UnitID, UnitAcronym, UnitName, UnitNameEnglish, UnitMainAgencyID, IsMainAgency, UnitParentID, UnitParentName, UnitParentNameEnglish, AgencyName, AgencyNameEnglish,
								   UnitGenID, UnitTypeID, UnitType, GovtLevelID, GovtLevel, UnitLevelID, UnitLevel, VettingBatchTypeID, VettingBatchTypeCode, 
								   VettingActivityTypeID, VettingActivityType, ReportingTypeID, ReportingType, CommanderFirstName, CommanderLastName, CountryID
				              FROM search.UnitsView v
				             WHERE ISNULL(v.CountryID, -1) = CASE WHEN @countryid IS NULL THEN ISNULL(v.CountryID, -1) ELSE @countryid END
                               AND ISNULL(v.UnitMainAgencyID, -1) = CASE WHEN @UnitMainAgencyID IS NULL THEN ISNULL(v.UnitMainAgencyID, -1) ELSE @UnitMainAgencyID END
                               AND IsMainAgency = (case when @AgenciesOrUnits = 1 THEN 1 WHEN @AgenciesOrUnits = 2 THEN 0 ELSE IsMainAgency END)
							   AND (UnitType COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
								or UnitName COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
								or UnitNameEnglish COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
                                or UnitParentName COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
							    or UnitParentNameEnglish COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
                                or AgencyName COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
							    or AgencyNameEnglish COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
								or UnitGenID COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
								or UnitAcronym COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
								or GovtLevel COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
								or UnitLevel COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
								or VettingBatchTypeCode COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
								or VettingActivityType COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
								or ReportingType COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
								or CommanderFirstName COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
								or CommanderLastName COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%'))
								
                            
                        print 'creating index: ' + CAST(SYSDATETIME() AS NVARCHAR(100))
						--CREATE NONCLUSTERED INDEX ix_fullSet ON #fullSet (PersonID, CountryID);
						CREATE NONCLUSTERED INDEX ix_fullSet_UnitID ON #fullSet (UnitID);
						CREATE NONCLUSTERED INDEX ix_fullSet ON #fullSet (UnitID, CountryID)
							INCLUDE (UnitAcronym, UnitName, UnitNameEnglish, UnitMainAgencyID, IsMainAgency, UnitParentID, UnitParentName, UnitParentNameEnglish, AgencyName, AgencyNameEnglish,
								UnitGenID, UnitTypeID, UnitType, GovtLevelID, GovtLevel, UnitLevelID, UnitLevel, VettingBatchTypeID, VettingBatchTypeCode, 
								VettingActivityTypeID, VettingActivityType, ReportingTypeID, ReportingType, CommanderFirstName, CommanderLastName);

						print 'inserting into #inclusiveSet: ' + CAST(SYSDATETIME() AS NVARCHAR(100))
                        INSERT INTO #inclusiveSet
                            SELECT UnitID FROM #fullSet GROUP BY UnitID;
                    END
		        ELSE
                    BEGIN
						TRUNCATE TABLE #searchSet;

                        print 'Getting #searchSet : ' + CAST(SYSDATETIME() AS NVARCHAR(100))
			            INSERT INTO #searchSet
				            SELECT f.UnitID
				              FROM #inclusiveSet i WITH(INDEX(ix_inclusiveSet))
                        INNER JOIN #fullSet f WITH(INDEX(ix_fullSet)) on i.UnitID = f.UnitID
				             WHERE UnitType COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
								or UnitName COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
								or UnitNameEnglish COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
                                or UnitParentName COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
							    or UnitParentNameEnglish COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
                                or AgencyName COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
							    or AgencyNameEnglish COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
								or UnitGenID COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
								or UnitAcronym COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
								or GovtLevel COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
								or UnitLevel COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
								or VettingBatchTypeCode COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
								or VettingActivityType COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
								or ReportingType COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
								or CommanderFirstName COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
								or CommanderLastName COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')

                        print 'deleting #inclusiveSet: ' + CAST(SYSDATETIME() AS NVARCHAR(100))
				        DELETE FROM #inclusiveSet 
				            WHERE UnitID NOT IN (SELECT UnitID FROM #searchSet WITH(INDEX(ix_searchSet)) GROUP BY UnitID);
                    END;

                 -- RESET @FirstWord
		         SET @FirstWord = 0;
	END;

	-- GET FULL SEARCH RESULTS
	TRUNCATE TABLE #fullSet
	INSERT INTO #fullSet
		SELECT p.UnitID, UnitAcronym, UnitName, UnitNameEnglish, UnitMainAgencyID, IsMainAgency, UnitParentID, UnitParentName, UnitParentNameEnglish, AgencyName, AgencyNameEnglish,
               UnitGenID, UnitTypeID, UnitType, GovtLevelID, GovtLevel, UnitLevelID, UnitLevel, VettingBatchTypeID, VettingBatchTypeCode, 
               VettingActivityTypeID, VettingActivityType, ReportingTypeID, ReportingType, CommanderFirstName, CommanderLastName, CountryID
		  FROM search.UnitsView p
	INNER JOIN #inclusiveSet search WITH(INDEX(ix_inclusiveSet)) ON p.UnitID = search.UnitID


    -- GET THE TOTAL NUMBER OF RECORDS RETRIEVED
	SELECT COUNT(@@ROWCOUNT) AS RecordCount FROM #fullSet;

	-- DETERMINE RESULTSET BASED ON PASSED PARAMETERS
	IF ((@PageSize IS NULL OR @PageNumber IS NULL) AND @SortOrder IS NULL)
		BEGIN
			print 'NO PAGING SPECIFIED (DEFAULT SORT), RETURN FULL DATASET';
			-- NO PAGING SPECIFIED (DEFAULT SORT), RETURN FULL DATASET
            SELECT UnitID, UnitAcronym, UnitName, UnitNameEnglish, UnitMainAgencyID, IsMainAgency, UnitParentID, UnitParentName, UnitParentNameEnglish, AgencyName, AgencyNameEnglish,
                   UnitGenID, UnitTypeID, UnitType, GovtLevelID, GovtLevel, UnitLevelID, UnitLevel, VettingBatchTypeID, VettingBatchTypeCode, 
                   VettingActivityTypeID, VettingActivityType, ReportingTypeID, ReportingType, CommanderFirstName, CommanderLastName
			  FROM #fullSet
          ORDER BY UnitNameEnglish;
		END
	ELSE IF ((@PageSize IS NULL OR @PageNumber IS NULL ) AND @SortOrder IS NOT NULL)
		BEGIN
			print 'NO PAGING SPECIFIED, RETURN FULL DATASET';
			-- NO PAGING SPECIFIED, RETURN FULL DATASET
			SELECT UnitID, UnitAcronym, UnitName, UnitNameEnglish, UnitMainAgencyID, IsMainAgency, UnitParentID, UnitParentName, UnitParentNameEnglish, AgencyName, AgencyNameEnglish,
                   UnitGenID, UnitTypeID, UnitType, GovtLevelID, GovtLevel, UnitLevelID, UnitLevel, VettingBatchTypeID, VettingBatchTypeCode, 
                   VettingActivityTypeID, VettingActivityType, ReportingTypeID, ReportingType, CommanderFirstName, CommanderLastName
			  FROM #fullSet
		  ORDER BY		-- DYNAMIC SORT
			CASE WHEN @SortDirection = 'ASC' THEN
				CASE @SortOrder
				    WHEN 'UnitAcronym'          THEN UnitAcronym
				    WHEN 'UnitName'             THEN UnitName
				    WHEN 'UnitNameEnglish'      THEN UnitNameEnglish
					WHEN 'UnitParentName'	    THEN UnitParentName
                    WHEN 'UnitLevel'	        THEN UnitLevel
                    WHEN 'VettingActivityType'	THEN VettingActivityType
                    WHEN 'UnitType'	            THEN UnitType
                    WHEN 'UnitGenID'	        THEN UnitGenID
                    WHEN 'CommanderLastName'	THEN CommanderLastName
				END 
			END ASC,
			CASE WHEN @SortDirection = 'DESC' THEN
				CASE @SortOrder
					WHEN 'UnitAcronym'          THEN UnitAcronym
				    WHEN 'UnitName'             THEN UnitName
				    WHEN 'UnitNameEnglish'      THEN UnitNameEnglish
					WHEN 'UnitParentName'	    THEN UnitParentName
                    WHEN 'UnitLevel'	        THEN UnitLevel
                    WHEN 'VettingActivityType'	THEN VettingActivityType
                    WHEN 'UnitType'	            THEN UnitType
                    WHEN 'UnitGenID'	        THEN UnitGenID
                    WHEN 'CommanderLastName'	THEN CommanderLastName
				END
			END DESC
		END
	ELSE IF (@PageSize IS NOT NULL AND @PageNumber IS NOT NULL AND @SortOrder IS NOT NULL)
		BEGIN
			print 'PAGING ANBD SORT PARAMETERS SPECIFIED';
			-- PAGING PARAMETERS SPECIFIED, GENERATE REQUESTED PAGE
		    -- THEN JOIN TO TABLE TO GET FULL THE RESET OF DATA
			;WITH paged AS 
		    (
			    SELECT UnitID
			      FROM #fullSet
		      ORDER BY		-- DYNAMIC SORT
			    CASE WHEN @SortDirection = 'ASC' THEN
				    CASE @SortOrder
				        WHEN 'UnitAcronym'          THEN UnitAcronym
				        WHEN 'UnitName'             THEN UnitName
				        WHEN 'UnitNameEnglish'      THEN UnitNameEnglish
					    WHEN 'UnitParentName'	    THEN UnitParentName
                        WHEN 'UnitLevel'	        THEN UnitLevel
                        WHEN 'VettingActivityType'	THEN VettingActivityType
                        WHEN 'UnitType'	            THEN UnitType
                        WHEN 'UnitGenID'	        THEN UnitGenID
                        WHEN 'CommanderLastName'	THEN CommanderLastName
				    END 
			    END ASC,
			    CASE WHEN @SortDirection = 'DESC' THEN
				    CASE @SortOrder
					    WHEN 'UnitAcronym'          THEN UnitAcronym
				        WHEN 'UnitName'             THEN UnitName
				        WHEN 'UnitNameEnglish'      THEN UnitNameEnglish
					    WHEN 'UnitParentName'	    THEN UnitParentName
                        WHEN 'UnitLevel'	        THEN UnitLevel
                        WHEN 'VettingActivityType'	THEN VettingActivityType
                        WHEN 'UnitType'	            THEN UnitType
                        WHEN 'UnitGenID'	        THEN UnitGenID
                        WHEN 'CommanderLastName'	THEN CommanderLastName
				    END
			    END DESC
			    OFFSET @PageSize * (@PageNumber - 1) ROWS	-- DETERMINE OFFSET
			    FETCH NEXT @PageSize ROWS ONLY				-- FETCH @PageSize RECORDS
		    )
		    SELECT p.UnitID, UnitAcronym, UnitName, UnitNameEnglish, UnitMainAgencyID, IsMainAgency, UnitParentID, UnitParentName, UnitParentNameEnglish, AgencyName, AgencyNameEnglish,
                   UnitGenID, UnitTypeID, UnitType, GovtLevelID, GovtLevel, UnitLevelID, UnitLevel, VettingBatchTypeID, VettingBatchTypeCode, 
                   VettingActivityTypeID, VettingActivityType, ReportingTypeID, ReportingType, CommanderFirstName, CommanderLastName
		      FROM paged p
	    INNER JOIN #fullSet n ON p.UnitID = n.UnitID
	      ORDER BY		-- DYNAMIC SORT
			    CASE WHEN @SortDirection = 'ASC' THEN
				    CASE @SortOrder
				        WHEN 'UnitAcronym'          THEN UnitAcronym
				        WHEN 'UnitName'             THEN UnitName
				        WHEN 'UnitNameEnglish'      THEN UnitNameEnglish
					    WHEN 'UnitParentName'	    THEN UnitParentName
                        WHEN 'UnitLevel'	        THEN UnitLevel
                        WHEN 'VettingActivityType'	THEN VettingActivityType
                        WHEN 'UnitType'	            THEN UnitType
                        WHEN 'UnitGenID'	        THEN UnitGenID
                        WHEN 'CommanderLastName'	THEN CommanderLastName
				    END 
			    END ASC,
			    CASE WHEN @SortDirection = 'DESC' THEN
				    CASE @SortOrder
					    WHEN 'UnitAcronym'          THEN UnitAcronym
				        WHEN 'UnitName'             THEN UnitName
				        WHEN 'UnitNameEnglish'      THEN UnitNameEnglish
					    WHEN 'UnitParentName'	    THEN UnitParentName
                        WHEN 'UnitLevel'	        THEN UnitLevel
                        WHEN 'VettingActivityType'	THEN VettingActivityType
                        WHEN 'UnitType'	            THEN UnitType
                        WHEN 'UnitGenID'	        THEN UnitGenID
                        WHEN 'CommanderLastName'	THEN CommanderLastName
				    END
			    END DESC  
		END
	ELSE
		BEGIN
			PRINT 'PAGING PARAMETERS SPECIFIED (DEFAULT SORT)';
			-- PAGING PARAMETERS SPECIFIED (DEFAULT SORT), GENERATE REQUESTED PAGE
		    -- THEN JOIN TO TABLE TO GET FULL THE RESET OF DATA
			;WITH paged AS 
		    (
			    SELECT UnitID
			      FROM #fullSet
		      ORDER BY UnitNameEnglish
			    OFFSET @PageSize * (@PageNumber - 1) ROWS	-- DETERMINE OFFSET
			    FETCH NEXT @PageSize ROWS ONLY				-- FETCH @PageSize RECORDS
		    )
		    SELECT p.UnitID, UnitAcronym, UnitName, UnitNameEnglish, UnitMainAgencyID, IsMainAgency, UnitParentID, UnitParentName, UnitParentNameEnglish, AgencyName, AgencyNameEnglish,
               UnitGenID, UnitTypeID, UnitType, GovtLevelID, GovtLevel, UnitLevelID, UnitLevel, VettingBatchTypeID, VettingBatchTypeCode, 
               VettingActivityTypeID, VettingActivityType, ReportingTypeID, ReportingType, CommanderFirstName, CommanderLastName
		      FROM paged p
	    INNER JOIN #fullSet n ON p.UnitID = n.UnitID
	      ORDER BY UnitNameEnglish
		END
END;
