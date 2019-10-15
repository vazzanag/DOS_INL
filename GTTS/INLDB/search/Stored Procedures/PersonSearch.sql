CREATE PROCEDURE [search].[PersonSearch]
    @SearchString NVARCHAR(3500) = NULL,
    @CountryID INT = NULL,
	@ParticipantType NVARCHAR(20) = 'all',
	@PageSize int = 50,
    @PageNumber int = 1,
	@OrderColumn NVARCHAR(100) = 'FullName',
	@OrderDirection NVARCHAR(10) = 'ASC',
	@RecordsFiltered INT OUTPUT
AS
BEGIN  
    -- CHECK FOR INVALID PARAMETERS
    IF @SearchString IS NULL AND @CountryID IS NULL
        THROW 50000,  'Invalid parameters',  1

		PRINT LEN(@SearchString)

		 DECLARE @Query NVARCHAR(4000), 
            @DelimIndex SMALLINT, 
            @Word NVARCHAR(200),
            @SearchTrimmed NVARCHAR(4000),
            @FirstWord BIT,
            @Gender char(1),
			@Counts INT,
            @WordIsDate BIT;

    -- SETUP TEMP TABLES
    IF OBJECT_ID('tempdb..#inclusiveSet') IS NOT NULL
        DROP TABLE #inclusiveSet
    IF OBJECT_ID('tempdb..#searchSet') IS NOT NULL
        DROP TABLE #searchSet
	IF OBJECT_ID('tempdb..#fullSet') IS NOT NULL
        DROP TABLE #fullSet
    IF OBJECT_ID('tempdb..#unitsFullSet') IS NOT NULL
        DROP TABLE #unitsFullSet
    IF OBJECT_ID('tempdb..#unitsInclusiveSet') IS NOT NULL
        DROP TABLE #unitsInclusiveSet
	IF OBJECT_ID('tempdb..#unitsSearchSet') IS NOT NULL
        DROP TABLE #unitsSearchSet

    CREATE TABLE #fullSet 
	(
		ParticipantType VARCHAR (15), PersonID BIGINT, FirstMiddleNames NVARCHAR (300), LastNames NVARCHAR (300), DOB DATETIME, 
		Gender CHAR (1), JobTitle NVARCHAR (200), JobRank NVARCHAR (200), CountryID INT, CountryName NVARCHAR (150), CountryFullName NVARCHAR (510), 
		NationalID NVARCHAR(100), UnitID BIGINT, UnitName NVARCHAR (600), UnitNameEnglish NVARCHAR (600), UnitMainAgencyID BIGINT, 
		UnitAcronym NVARCHAR (100), AgencyName NVARCHAR (600), AgencyNameEnglish NVARCHAR (600), VettingStatus NVARCHAR (50), 
        VettingStatusDate DATETIME, VettingType NVARCHAR (50), Distinction NVARCHAR (100), EventStartDate DATE
	);

    CREATE TABLE #inclusiveSet (PersonID BIGINT);
    CREATE NONCLUSTERED INDEX ix_inclusiveSet ON #inclusiveSet (PersonID);

    CREATE TABLE #searchSet (PersonID BIGINT);
    CREATE NONCLUSTERED INDEX ix_searchSet ON #searchSet (PersonID);

    CREATE TABLE #unitsFullSet (UnitName nvarchar(300), UnitNameEnglish nvarchar(300), ChildUnits nvarchar(max))
	CREATE NONCLUSTERED INDEX ix_unitName ON #unitsFullSet (UnitName);
	CREATE NONCLUSTERED INDEX ix_unitNameEnglish ON #unitsFullSet (UnitNameEnglish);

	CREATE TABLE #unitsSearchSet (UnitName nvarchar(300), UnitNameEnglish nvarchar(300))
	CREATE NONCLUSTERED INDEX ix_unitSearchName ON #unitsSearchSet (UnitName);
	CREATE NONCLUSTERED INDEX ix_unitSearchNameEnglish ON #unitsSearchSet (UnitNameEnglish);

    CREATE TABLE #unitsInclusiveSet (UnitName nvarchar(300), UnitNameEnglish nvarchar(300), ChildUnits nvarchar(max))
	CREATE NONCLUSTERED INDEX ix_unitInclusiveName ON #unitsInclusiveSet (UnitName);
	CREATE NONCLUSTERED INDEX ix_unitInclusiveNameEnglish ON #unitsInclusiveSet (UnitNameEnglish);

	
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
	DECLARE Split_SearchString CURSOR LOCAL FAST_FORWARD FOR 
			SELECT * FROM STRING_SPLIT(@SearchString,' ')
 
	OPEN Split_SearchString
 
	FETCH NEXT FROM Split_SearchString 
	INTO @Word
 
	WHILE @@FETCH_STATUS = 0
	BEGIN
		print 'Word: ' + @word + ' : ' + CAST(SYSDATETIME() AS NVARCHAR(100))
		IF @word <> ''
		BEGIN
			IF (@word = 'female' OR @word = 'male')
				BEGIN
					IF (@word = 'male')
						SET @Gender = 'M';
					ELSE
						SET @Gender = 'F';
				END
			ELSE
				BEGIN
					-- SEARCH
					IF (@FirstWord = 1)
						BEGIN
							-- PERFORM SEARCH AND PUT RESULTS IN TEMP TABLE
							print 'Getting #unitsFullSet : ' + CAST(SYSDATETIME() AS NVARCHAR(100))
			                
							-- SPECIAL SUBSET TO KEEP TRACK OF UNIT MATCHES
							INSERT INTO #unitsFullSet (UnitName, UnitNameEnglish)
								SELECT UnitName, UnitNameEnglish
									FROM search.PersonsView v
									WHERE ISNULL(v.CountryID, -1) = CASE WHEN @countryid IS NULL THEN ISNULL(v.CountryID, -1) ELSE @countryid END
									AND (UnitName COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
										OR UnitNameEnglish COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%'))
								GROUP BY UnitName, UnitNameEnglish;

							print 'inserting into #unitsInclusiveSet: ' + CAST(SYSDATETIME() AS NVARCHAR(100))
							INSERT INTO #unitsInclusiveSet (UnitName, UnitNameEnglish)
								SELECT UnitName, UnitNameEnglish FROM #unitsFullSet;

							print 'Getting #fullSet : ' + CAST(SYSDATETIME() AS NVARCHAR(100))
							-- THE REST OF THE SEARCH
							INSERT INTO #fullSet
								SELECT ParticipantType, PersonID, FirstMiddleNames, LastNames, DOB, Gender, JobTitle, JobRank,
										CountryID, CountryName, CountryFullName, NationalID, UnitID, UnitName, UnitNameEnglish, UnitMainAgencyID, 
										UnitAcronym, AgencyName, AgencyNameEnglish, VettingStatus, VettingStatusDate, VettingType, Distinction, EventStartDate
									FROM search.PersonsView v
									WHERE ISNULL(v.CountryID, -1) = CASE WHEN @countryid IS NULL THEN ISNULL(v.CountryID, -1) ELSE @countryid END
									AND (ParticipantType COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
										OR FirstMiddleNames COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
										OR LastNames COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
										OR CAST(DOB AS DATE) = CASE WHEN ISDATE(@Word) = 1 THEN CAST(@word AS DATE) ELSE GETDATE() END
										OR JobTitle COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
										OR JobRank COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
										OR CountryName COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
										OR CountryFullName COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
										OR UnitName COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
										OR UnitNameEnglish COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
										OR UnitAcronym COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
										OR AgencyName COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
										OR AgencyNameEnglish COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
										OR VettingStatus COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
										OR CAST(VettingStatusDate AS DATE) = CASE WHEN ISDATE(@Word) = 1 THEN CAST(@word AS DATE) ELSE GETDATE() END
										OR VettingType COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
										OR Distinction COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
										OR NationalID LIKE CONCAT('%', @Word, '%')
										OR CAST(EventStartDate  AS DATE) = CASE WHEN ISDATE(@Word) = 1 THEN CAST(@word AS DATE) ELSE GETDATE() END)
                            
							print 'creating index: ' + CAST(SYSDATETIME() AS NVARCHAR(100))
                            
							CREATE NONCLUSTERED INDEX ix_fullSet_PersonID ON #fullSet (PersonID);
							CREATE NONCLUSTERED INDEX ix_fullSet ON #fullSet (PersonID, CountryID)
								INCLUDE (ParticipantType, FirstMiddleNames, LastNames, DOB, JobTitle, JobRank, CountryName, CountryFullName, UnitName,
								UnitNameEnglish, UnitAcronym, AgencyName, AgencyNameEnglish, VettingStatus, VettingStatusDate,
								VettingType, Distinction, EventStartDate, NationalID);

							print 'inserting into #inclusiveSet: ' + CAST(SYSDATETIME() AS NVARCHAR(100))
							INSERT INTO #inclusiveSet
								SELECT PersonID FROM #fullSet
								GROUP BY PersonID;
						END
					ELSE -- TODO try to merge (@FirstWord = 1) with (@FirstWord = 0)
						BEGIN
							TRUNCATE TABLE #searchSet;
							TRUNCATE TABLE #unitsSearchSet;

							-- PERFORM SEARCH AND PUT RESULTS IN TEMP TABLE
							print 'Getting #unitSearchSet : ' + CAST(SYSDATETIME() AS NVARCHAR(100))
							
							-- SPECIAL SUBSET TO KEEP TRACK OF UNIT MATCHES
							INSERT INTO #unitsSearchSet (UnitName, UnitNameEnglish)
								SELECT f.UnitName, f.UnitNameEnglish
									FROM #unitsInclusiveSet i WITH(INDEX(ix_unitInclusiveName))
							INNER JOIN #unitsFullSet f WITH(INDEX(ix_unitName)) ON i.UnitName = f.UnitName
									WHERE f.UnitName COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
									OR f.UnitNameEnglish COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
								GROUP BY f.UnitName, f.UnitNameEnglish;

							print 'deleting #unitsInclusiveSet: ' + CAST(SYSDATETIME() AS NVARCHAR(100))
							DELETE FROM #unitsInclusiveSet 
								WHERE UnitName NOT IN (SELECT UnitName FROM #unitsSearchSet WITH(INDEX(ix_unitSearchName)) GROUP BY UnitName);

							print 'Getting #searchSet : ' + CAST(SYSDATETIME() AS NVARCHAR(100))
							-- THE REST OF THE SEARCH
							INSERT INTO #searchSet
								SELECT f.PersonID
									FROM #inclusiveSet i WITH(INDEX(ix_inclusiveSet))
							INNER JOIN #fullSet f WITH(INDEX(ix_fullSet)) on i.PersonID = f.PersonID
									WHERE ISNULL(f.CountryID, -1) = CASE WHEN @countryid IS NULL THEN ISNULL(f.CountryID, -1) ELSE @countryid END
									AND (ParticipantType COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%') 
									OR FirstMiddleNames COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
									OR LastNames COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
									OR CAST(DOB AS DATE) = CASE WHEN ISDATE(@Word) = 1 THEN CAST(@word AS DATE) ELSE GETDATE() END
									OR JobTitle COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
									OR JobRank COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
									OR CountryName COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
									OR CountryFullName COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
									OR UnitName COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
									OR UnitNameEnglish COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
									OR UnitAcronym COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
									OR AgencyName COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
									OR AgencyNameEnglish COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
									OR VettingStatus COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
									OR CAST(VettingStatusDate AS DATE) = CASE WHEN ISDATE(@Word) = 1 THEN CAST(@word AS DATE) ELSE GETDATE() END
									OR VettingType COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
									OR Distinction COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
									OR NationalID LIKE CONCAT('%', @Word, '%')
									OR CAST(EventStartDate  AS DATE) = CASE WHEN ISDATE(@Word) = 1 THEN CAST(@word AS DATE) ELSE GETDATE() END)
								GROUP BY f.PersonID

							print 'deleting #inclusiveSet: ' + CAST(SYSDATETIME() AS NVARCHAR(100))
							DELETE FROM #inclusiveSet 
								WHERE PersonID NOT IN (SELECT PersonID FROM #searchSet WITH(INDEX(ix_searchSet)) GROUP BY PersonID);

						END;

					-- RESET @FirstWord
					SET @FirstWord = 0;
				END;
		END;

		FETCH NEXT FROM Split_SearchString 
		INTO @Word
	END 
	
	select @Counts = count(@@rowcount) from #inclusiveSet;
	PRINT 'Done with filtering (' + CAST(@Counts AS NVARCHAR(100)) + '): ' +  CAST(SYSDATETIME() AS NVARCHAR(100));
	select @Counts = count(@@rowcount) from #unitsInclusiveSet;
	
	IF @Counts > 0 
	BEGIN
		DECLARE @ChildUnits NVARCHAR(MAX);
		SELECT TOP 1 @ChildUnits =  
					stuff((
						SELECT ',' + u.UnitName
						FROM #unitsInclusiveSet u
						WHERE u.UnitName = UnitName
						ORDER BY u.UnitName
						FOR XML PATH('')
					),1,1,'') 
		  FROM #unitsInclusiveSet
	   GROUP BY UnitName
		
		print 'Additional child units to capture: ' + CAST(@Counts AS NVARCHAR(100)) + ' : ' +  CAST(SYSDATETIME() AS NVARCHAR(100));
		print @ChildUnits;

		UPDATE #unitsInclusiveSet SET
			   ChildUnits = u.ChildUnits
		  FROM #unitsInclusiveSet u1
	INNER JOIN unitlibrary.Units u on u1.UnitName = u.UnitName;

		-- POPULATE #unitsSearchSet TABLE
		TRUNCATE TABLE #unitsSearchSet;

		INSERT INTO #unitsSearchSet (UnitName)
			SELECT TRIM(s.value)
			  FROM #unitsInclusiveSet P
		CROSS APPLY STRING_SPLIT(p.ChildUnits, '/') s
		  GROUP BY s.value;

		print 'Unit list complete: ' +  CAST(SYSDATETIME() AS NVARCHAR(100));

		-- MERGE PEOPLE FROM CHILD UNITS
		MERGE INTO #inclusiveSet AS target
		USING (SELECT [PersonID] 
				 FROM search.PersonsView p
		   INNER JOIN #unitsSearchSet u ON p.UnitName = u.UnitName
			  ) AS source ([PersonID]) ON (target.[PersonID] = source.[PersonID])
		WHEN NOT MATCHED BY TARGET THEN
			INSERT ([PersonID]) VALUES ([PersonID]);
    
		select @Counts = count(@@rowcount) from #inclusiveSet;
		print 'Merge of people in child units complete (' + CAST(@Counts AS NVARCHAR(100)) + '): ' +  CAST(SYSDATETIME() AS NVARCHAR(100));
	END;

	--SELECT * from #inclusiveSet
	PRINT CONCAT('@FirstWord:', @FirstWord)
	PRINT CONCAT('@Gender:', @Gender)

	DECLARE @SQLString NVARCHAR(max);
	DECLARE @ParmDefinition NVARCHAR(500);
	DECLARE @IntVariable NVARCHAR(100);

	/* Build the SQL string one time. */
	SET @SQLString = N'';
	/* Specify the parameter format one time. */
	SET @ParmDefinition = N'@ParticipantType NVARCHAR(20), @Gender CHAR(1), @PageSize INT, @PageNumber INT';				
	DECLARE @FilterByInclusiveSet NVARCHAR(150) = N' '
	DECLARE @FilterByParticipantType NVARCHAR(150) = N' '

	IF (LEN(@SearchString) > 0 AND @Gender IS NULL)
	BEGIN
		SET @FilterByInclusiveSet = N' INNER JOIN #inclusiveSet search WITH(INDEX(ix_inclusiveSet)) ON per.PersonID = search.PersonID '
	END

	IF (@ParticipantType = 'Instructor')
		SET @FilterByParticipantType = N' WHERE TrainingEventParticipantTypeID IN (2) '
	IF (@ParticipantType = 'Student')
		SET @FilterByParticipantType = N' WHERE TrainingEventParticipantTypeID IN (1, 3, 4) '

	IF @Gender IS NULL
		PRINT concat('@Gender IS NULL: ', @Gender);
	ELSE
		PRINT concat('@Gender IS not NULL: ', @Gender);

	SET @SQLString = N'WITH ParticipantResult AS(
	SELECT par.TrainingEventID, per.PersonID, per.FullName, per.FirstMiddleNames, per.LastNames, par.TrainingEventParticipantTypeID, tpt.[Name] AS ParticipantType, per.VettingStatus, per.VettingStatusDate, VettingType AS VettingTypeCode,
	per.UnitID, per.UnitName, UnitNameEnglish, AgencyName, AgencyNameEnglish, per.DOB, per.Distinction,
	per.Gender, JobRank, per.JobTitle, CountryID, CountryName
	-- Add last vetting clearence
	, (SELECT MAX(VettingValidEndDate) FROM vetting.PersonsVettingView pvv WHERE pvv.PersonID = per.PersonID) AS VettingValidEndDate 
	FROM [training].[TrainingEventParticipants] AS par
	INNER JOIN [training].[TrainingEventParticipantTypes] tpt ON tpt.TrainingEventParticipantTypeID = par.TrainingEventParticipantTypeID
	INNER JOIN search.PersonsView per ON per.PersonID = par.PersonID'
	+ @FilterByInclusiveSet +
	'WHERE Gender = ISNULL(@Gender, Gender)
	UNION -- This UNION is to get persons that are not in trainin Event but has vetting, is a requirement of Bogota
	SELECT 0 AS TrainingEventID, per.PersonID, per.FullName, FirstMiddleNames, LastNames, 1 AS TrainingEventParticipantTypeID, ParticipantType, VettingStatus, VettingStatusDate, VettingType AS VettingTypeCode,
	UnitID, UnitName, UnitNameEnglish, AgencyName, AgencyNameEnglish, DOB, null AS Distinction,
	Gender, JobRank, JobTitle, CountryID, CountryName
	-- Add last vetting clearence
	, (SELECT MAX(VettingValidEndDate) FROM vetting.PersonsVettingView pvv WHERE pvv.PersonID = per.PersonID) AS VettingValidEndDate 
	FROM search.personsView per'
	+ @FilterByInclusiveSet +
	'WHERE Gender = ISNULL(@Gender, Gender)
	)
	SELECT ROW_NUMBER() OVER(ORDER BY ' + @OrderColumn + ' ' + @OrderDirection + ' ' + ') AS RowNumber, * FROM ParticipantResult AS pr
	-- If the participant is in many events get only the last event
	INNER JOIN (SELECT  PersonID, MAX(TrainingEventID) AS TrainingEventID FROM ParticipantResult GROUP BY PersonID) AS MaxEvent
	ON pr.PersonID = MaxEvent.PersonID AND pr.TrainingEventID = MaxEvent.TrainingEventID '
	+ @FilterByParticipantType +
	'ORDER BY ' + @OrderColumn + ' ' + @OrderDirection + ' ' +
	'OFFSET @PageSize * (@PageNumber - 1) ROWS
	FETCH NEXT @PageSize ROWS ONLY;'	

	EXECUTE sp_executesql @SQLString, @ParmDefinition, @ParticipantType, @Gender, @PageSize, @PageNumber;
	PRINT	@SQLString

	/* Specify the parameter format one time. */
	SET @ParmDefinition = N'@ParticipantType NVARCHAR(20), @Gender CHAR(1), @RecordsFiltered INT OUT';
	-- FINAL RESULTSET get count
	SET @SQLString = N'WITH ParticipantResult AS(
	SELECT par.TrainingEventID, per.PersonID, par.TrainingEventParticipantTypeID
	FROM [training].[TrainingEventParticipants] AS par
	INNER JOIN [training].[TrainingEventParticipantTypes] tpt ON tpt.TrainingEventParticipantTypeID = par.TrainingEventParticipantTypeID
	INNER JOIN search.PersonsView per ON per.PersonID = par.PersonID'
	+ @FilterByInclusiveSet +
	'WHERE Gender = ISNULL(@Gender, Gender)
	UNION -- This UNION is to get persons that are not in trainin Event but has vetting, is a requirement of Bogota
	SELECT 0 AS TrainingEventID, per.PersonID, 1 AS TrainingEventParticipantTypeID
	FROM search.personsView per'
	+ @FilterByInclusiveSet +
	'WHERE Gender = ISNULL(@Gender, Gender)
	)
	SELECT @RecordsFiltered = COUNT(*) FROM ParticipantResult AS pr
	-- If the participant is in many events get only the last event
	INNER JOIN (SELECT  PersonID, MAX(TrainingEventID) AS TrainingEventID FROM ParticipantResult GROUP BY PersonID) AS MaxEvent
	ON pr.PersonID = MaxEvent.PersonID AND pr.TrainingEventID = MaxEvent.TrainingEventID'
	+ @FilterByParticipantType;
		
	EXECUTE sp_executesql @SQLString, @ParmDefinition, @ParticipantType, @Gender, @RecordsFiltered OUT;	

	PRINT CONCAT('@RecordsFiltered: ', @RecordsFiltered);
	PRINT 'Done with search: ' + CAST(SYSDATETIME() AS NVARCHAR(100)) 

END