CREATE PROCEDURE [search].[PersonsVettingSearch]
	@SearchString NVARCHAR(3500) = NULL,
    @VettingBatchID BIGINT = NULL,
	@VettingType NVARCHAR(50) = NULL
AS
BEGIN

	IF @VettingType = '' 
		SELECT @VettingType = NULL

    -- VERIFY @SearchString HAS A VALUE
    IF (LEN(@SearchString) = 0 OR @VettingBatchID IS NULL)
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
    CREATE TABLE #inclusiveSet (PersonsVettingID BIGINT);
    CREATE TABLE #searchSet (PersonsVettingID BIGINT);

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
             TRUNCATE TABLE #searchSet;

             -- PERFORM SEARCH AND PUT RESULTS IN TEMP TABLE
             INSERT INTO #searchSet
                   SELECT PersonsVettingID
                      FROM search.PersonsVettingJSONView v
                   WHERE (v.PersonsVettingJSON LIKE CONCAT('%', @Word, '%')
                      OR v.HitResultJSON LIKE ''+CONCAT('%', '"Code":"%',@Word,'%","VettingType":"',ISNULL(@VettingType,'%'),'"%')+''
                      OR v.VettingHitsJSON LIKE CONCAT('%', @Word, '%')
                      OR v.LeahyHitsJSON LIKE CONCAT('%', @Word, '%'))
                      AND v.VettingBatchID = ISNULL(@VettingBatchID, v.VettingBatchID)
                   GROUP BY v.PersonsVettingID

            -- UPDATE #inclusionSet
            IF (@FirstWord = 1)
                  INSERT INTO #inclusiveSet
                    SELECT PersonsVettingID FROM #searchSet;
            ELSE
            DELETE FROM #inclusiveSet
                WHERE PersonsVettingID NOT IN (SELECT PersonsVettingID FROM #searchSet);
                
                    -- RESET @FirstWord
            SET @FirstWord = 0;
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
        
        TRUNCATE TABLE #searchSet;

		INSERT INTO #searchSet
		    SELECT PersonsVettingID
		 FROM search.PersonsVettingJSONView v
		      WHERE (v.PersonsVettingJSON LIKE CONCAT('%', @Word, '%')
			       OR v.HitResultJSON LIKE ''+CONCAT('%', '"Code":"%',@Word,'%","VettingType":"',ISNULL(@VettingType,'%'),'"%')+''
				   OR v.VettingHitsJSON LIKE CONCAT('%', @Word, '%')
				   OR v.LeahyHitsJSON LIKE CONCAT('%', @Word, '%'))
				   AND v.VettingBatchID = ISNULL(@VettingBatchID, v.VettingBatchID)
			       GROUP BY v.PersonsVettingID

		        -- UPDATE #inclusionSet
		        IF (@FirstWord = 1)
			        INSERT INTO #inclusiveSet
			        SELECT PersonsVettingID FROM #searchSet;
		        ELSE
			        DELETE FROM #inclusiveSet
			         WHERE PersonsVettingID NOT IN (SELECT PersonsVettingID FROM #searchSet);

                -- RESET @FirstWord
		        SET @FirstWord = 0;
 	END;

	SELECT DISTINCT PersonsVettingID FROM #searchSet

END
