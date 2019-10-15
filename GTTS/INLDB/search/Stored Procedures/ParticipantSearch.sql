CREATE PROCEDURE [search].[ParticipantSearch]
    @SearchString NVARCHAR(3500) = NULL,
    @CountryID INT = NULL,
    @TrainingEventID BIGINT = NULL
AS
BEGIN

    DECLARE @Query NVARCHAR(4000);

    -- CHECK FOR INVALID PARAMETERS
    IF @SearchString IS NULL AND @CountryID IS NULL
        THROW 50000,  'Invalid parameters',  1
    
    -- VERIFY @SearchString HAS A VALUE
    IF (LEN(@SearchString) = 0)
        THROW 50000,  'Search criteria not specified',  1;

    IF @TrainingEventID IS NOT NULL
        BEGIN
            DECLARE @DelimIndex SMALLINT, 
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

            CREATE TABLE #inclusiveSet (PersonID BIGINT, ParticipantType VARCHAR(10));
            CREATE NONCLUSTERED INDEX ix_inclusiveSet ON #inclusiveSet (PersonID);

            CREATE TABLE #searchSet (PersonID BIGINT, ParticipantType VARCHAR(10));
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

            -- LIMIT INITIAL SCOPE TO THE TRAINING EVENT SPECIFIED
            CREATE TABLE #fullSet
            (
				ParticipantType VARCHAR(10),TrainingEventID BIGINT,PersonID BIGINT,FirstMiddleNames NVARCHAR(300),LastNames NVARCHAR(300),
				Gender CHAR(1),DOB DATETIME,JobTitle NVARCHAR(200),JobRank NVARCHAR(200),CountryName NVARCHAR(510), CountryFullName NVARCHAR(510), 
				CountryID INT,UnitID BIGINT,UnitName NVARCHAR(600),UnitNameEnglish NVARCHAR(600),UnitAcronym NVARCHAR(100),AgencyName NVARCHAR(600),
				AgencyNameEnglish NVARCHAR(600),VettingPersonStatus NVARCHAR(50),VettingPersonStatusDate DATETIME,VettingBatchType NVARCHAR(30),
				Distinction NVARCHAR(100),NationalID NVARCHAR(200),EventStartDate DATETIME
            );

            INSERT INTO #fullset
				SELECT ParticipantType, TrainingEventID, PersonID, FirstMiddleNames, LastNames,
					   Gender, DOB, JobTitle, JobRank, CountryName, CountryFullName, 
					   CountryID, UnitID, UnitName, UnitNameEnglish, UnitAcronym, AgencyName,
					   AgencyNameEnglish, VettingPersonStatus, VettingPersonStatusDate, VettingBatchType ,
					   Distinction, NationalID, EventStartDate 
	              FROM search.ParticipantsView
	             WHERE TrainingEventID = @TrainingEventID;


            CREATE NONCLUSTERED INDEX ix_fullSet_PersonID ON #fullSet (PersonID);
			CREATE NONCLUSTERED INDEX ix_fullSet ON #fullSet (PersonID, ParticipantType)
				INCLUDE (FirstMiddleNames, LastNames, DOB, JobTitle, JobRank, UnitName, UnitNameEnglish, UnitAcronym, AgencyName,
                    AgencyNameEnglish,VettingPersonStatus, VettingPersonStatusDate,VettingBatchType, Distinction, NationalID, EventStartDate);

            INSERT INTO #inclusiveSet
                SELECT PersonID, ParticipantType 
                  FROM #fullSet
			  GROUP BY PersonID, ParticipantType;

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
                    IF (@word = 'female' OR @word = 'male')
                        BEGIN
                            IF (@word = 'male')
                                SET @Gender = 'M';
                            ELSE
                                SET @Gender = 'F';
                        END
                    ELSE
                        BEGIN
                            TRUNCATE TABLE #searchSet;
                            
                            -- SEARCH
			                IF (@FirstWord = 1)
                                BEGIN

                                    -- SPECIAL SUBSET TO KEEP TRACK OF UNIT MATCHES
                                    INSERT INTO #unitsFullSet (UnitName, UnitNameEnglish)
				                        SELECT UnitName, UnitNameEnglish
				                          FROM #fullSet v
				                         WHERE ISNULL(v.CountryID, -1) = CASE WHEN @countryid IS NULL THEN ISNULL(v.CountryID, -1) ELSE @countryid END
								           AND (UnitName COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
								               OR UnitNameEnglish COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%'))
							          GROUP BY UnitName, UnitNameEnglish;

                                    print 'inserting into #unitsInclusiveSet: ' + CAST(SYSDATETIME() AS NVARCHAR(100))
                                    INSERT INTO #unitsInclusiveSet (UnitName, UnitNameEnglish)
                                        SELECT UnitName, UnitNameEnglish FROM #unitsFullSet;

                                    -- RESET @FirstWord
		                            SET @FirstWord = 0;
                                END
			                ELSE
                                BEGIN
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
                                END;

							print 'Getting #searchSet : ' + CAST(SYSDATETIME() AS NVARCHAR(100))
                            -- THE REST OF THE SEARCH
			                INSERT INTO #searchSet
				                SELECT f.PersonID, f.ParticipantType
				                  FROM #inclusiveSet i WITH(INDEX(ix_inclusiveSet))
                            INNER JOIN #fullSet f WITH(INDEX(ix_fullSet)) on i.PersonID = f.PersonID
				                 WHERE f.ParticipantType COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%') 
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
								    OR VettingPersonStatus COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
								    OR CAST(VettingPersonStatusDate AS DATE) = CASE WHEN ISDATE(@Word) = 1 THEN CAST(@word AS DATE) ELSE GETDATE() END
								    OR VettingBatchType COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
								    OR Distinction COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
                                    OR NationalID LIKE CONCAT('%', @Word, '%')
								    OR CAST(EventStartDate  AS DATE) = CASE WHEN ISDATE(@Word) = 1 THEN CAST(@word AS DATE) ELSE GETDATE() END
							  GROUP BY f.PersonID, f.ParticipantType

                            print 'deleting #inclusiveSet: ' + CAST(SYSDATETIME() AS NVARCHAR(100))
				            DELETE FROM #inclusiveSet 
				             WHERE PersonID NOT IN (SELECT PersonID FROM #searchSet WITH(INDEX(ix_searchSet)) GROUP BY PersonID);

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
                    print 'Word: ' + @word + ' : ' + CAST(SYSDATETIME() AS NVARCHAR(100))
                    IF (@word = 'female' OR @word = 'male')
                        BEGIN
                            IF (@word = 'male')
                                SET @Gender = 'M';
                            ELSE
                                SET @Gender = 'F';
                        END
                    ELSE
                        BEGIN

                            TRUNCATE TABLE #searchSet;
                            -- SEARCH
			                IF (@FirstWord = 1)
                                BEGIN

                                    -- SPECIAL SUBSET TO KEEP TRACK OF UNIT MATCHES
                                    INSERT INTO #unitsFullSet (UnitName, UnitNameEnglish)
				                        SELECT UnitName, UnitNameEnglish
				                          FROM #fullSet v
				                         WHERE ISNULL(v.CountryID, -1) = CASE WHEN @countryid IS NULL THEN ISNULL(v.CountryID, -1) ELSE @countryid END
								           AND (UnitName COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
								               OR UnitNameEnglish COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%'))
							          GROUP BY UnitName, UnitNameEnglish;

                                    print 'inserting into #unitsInclusiveSet: ' + CAST(SYSDATETIME() AS NVARCHAR(100))
                                    INSERT INTO #unitsInclusiveSet (UnitName, UnitNameEnglish)
                                        SELECT UnitName, UnitNameEnglish FROM #unitsFullSet;

                                    -- RESET @FirstWord
		                            SET @FirstWord = 0;
                                END
			                ELSE
                                BEGIN
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
                                END;

							print 'Getting #searchSet : ' + CAST(SYSDATETIME() AS NVARCHAR(100))
                            -- THE REST OF THE SEARCH
			                INSERT INTO #searchSet
				                SELECT f.PersonID, f.ParticipantType
				                  FROM #inclusiveSet i WITH(INDEX(ix_inclusiveSet))
                            INNER JOIN #fullSet f WITH(INDEX(ix_fullSet)) on i.PersonID = f.PersonID
				                 WHERE f.ParticipantType COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%') 
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
								    OR VettingPersonStatus COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
								    OR CAST(VettingPersonStatusDate AS DATE) = CASE WHEN ISDATE(@Word) = 1 THEN CAST(@word AS DATE) ELSE GETDATE() END
								    OR VettingBatchType COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
								    OR Distinction COLLATE Latin1_General_CI_AI LIKE CONCAT('%', @Word, '%')
                                    OR NationalID LIKE CONCAT('%', @Word, '%')
								    OR CAST(EventStartDate  AS DATE) = CASE WHEN ISDATE(@Word) = 1 THEN CAST(@word AS DATE) ELSE GETDATE() END
							  GROUP BY f.PersonID, f.ParticipantType

                            print 'deleting #inclusiveSet: ' + CAST(SYSDATETIME() AS NVARCHAR(100))
				            DELETE FROM #inclusiveSet 
				             WHERE PersonID NOT IN (SELECT PersonID FROM #searchSet WITH(INDEX(ix_searchSet)) GROUP BY PersonID);

                        END;
                END;

            select @Counts = count(@@rowcount) from #inclusiveSet;
	        print 'Done with filtering (' + CAST(@Counts AS NVARCHAR(100)) + '): ' +  CAST(SYSDATETIME() AS NVARCHAR(100));

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
				         FROM #fullSet p
		           INNER JOIN #unitsSearchSet u ON p.UnitName = u.UnitName
			          ) AS source ([PersonID]) ON (target.[PersonID] = source.[PersonID])
		        WHEN NOT MATCHED BY TARGET THEN
			        INSERT ([PersonID]) VALUES ([PersonID]);
    
		        select @Counts = count(@@rowcount) from #inclusiveSet;
		        print 'Merge of people in child units complete (' + CAST(@Counts AS NVARCHAR(100)) + '): ' +  CAST(SYSDATETIME() AS NVARCHAR(100));
	        END;

			-- FINAL RESULTSET JOINING PersonID FROM #inclusiveSet TABLES WITH #fullSet
            SELECT 100 AS [Rank], p.ParticipantType, p.PersonID, FirstMiddleNames, LastNames, Gender, JobTitle, JobRank,
                   UnitName, UnitNameEnglish, AgencyName, AgencyNameEnglish, CountryName, CAST(FORMAT ( DOB, 'd', 'en-US' ) AS NVARCHAR(15)) DOB, 
                   VettingPersonStatus AS VettingStatus, VettingPersonStatusDate AS VettingStatusDate, VettingBatchType AS VettingType, p.Distinction,

				   TrainingEventParticipantID, CountryID, IsUSCitizen, UnitID, ContactEmail,UnitParentName, UnitParentNameEnglish, 
				   p.TrainingEventID, p.IsParticipant, p.IsTraveling, IsLeahyVettingReq, IsVettingReq, IsValidated,
				   DepartureCity, p.DepartureDate, p.ReturnDate,  p.IsTraveling, VettingPersonStatusID, 
				   CASE WHEN ISNULL(p.RemovedFromEvent, 0) = 0 THEN VettingPersonStatus ELSE 'Removed' END AS VettingPersonStatus, 
				   VettingPersonStatusDate, VettingBatchTypeID, VettingBatchType, VettingTrainingEventName, p.RemovedFromVetting,
				   VettingBatchStatusID, VettingBatchStatus, VettingBatchStatusDate, p.PersonsVettingID, p.VisaStatusID, VisaStatus, p.RemovedFromEvent, 
				   p.OnboardingComplete, CourtesyVettingsJSON, TrainingEventGroupID, GroupName, DocumentCount, PersonsUnitLibraryInfoID 
			  FROM search.ParticipantsView p
		INNER JOIN #inclusiveSet search WITH(INDEX(ix_inclusiveSet)) ON p.PersonID = search.PersonID
			 WHERE p.Gender = ISNULL(@Gender, p.Gender) 
			   AND p.TrainingEventID = @TrainingEventID


	        print 'Done with search: ' + CAST(SYSDATETIME() AS NVARCHAR(100)) 
        END;
    ELSE
        BEGIN

            IF (EXISTS(SELECT CountryID FROM [location].Countries WHERE @SearchString LIKE '%' + CountryName + '%' OR @SearchString LIKE '%' + CountryFullName + '%'))
            BEGIN
                SELECT @CountryID = CountryID FROM [location].Countries WHERE @SearchString LIKE '%' + CountryName + '%' OR @SearchString LIKE '%' + CountryFullName + '%'
            END

            -- GENERATE SERACH STRING FORMATTED FOR FULLTEXT SEARCH INDEXES
            SELECT @Query = search.BuildFullTextSearchStringForOr(@SearchString);
    
            /*
             SEARCH: 
                Union necessary for search inclusions across all fulltext indexes
                Grouping necessary to remove duplicates, taking highest rank if duplicate found
            */
            SELECT MAX([Rank]) AS [Rank], ParticipantType, s.PersonID, FirstMiddleNames, LastNames, Gender, JobTitle, JobRank,  
                  p.UnitName, p.UnitNameEnglish, AgencyName, AgencyNameEnglish, CountryName, CAST(FORMAT ( DOB, 'd', 'en-US' ) AS NVARCHAR(15)) DOB,
                   VettingStatus, VettingStatusDate, VettingType, Distinction
              FROM (        -- Students
				        SELECT r.[Rank], 'student' tableSource, s.PersonID
				          FROM training.TrainingEventParticipants s
			        INNER JOIN persons.PersonsUnitLibraryInfo l on s.PersonID = l.PersonID
			        INNER JOIN unitlibrary.Units u on l.UnitID = u.UnitID
			        INNER JOIN CONTAINSTABLE(persons.Persons, *, @Query)    r ON s.PersonID = r.[Key]
				         WHERE u.CountryID = ISNULL(@CountryID, u.CountryID)
                           AND s.TrainingEventID <> CASE WHEN @TrainingEventID IS NULL THEN -1 ELSE @TrainingEventID END
						   AND s.TrainingEventParticipantTypeID != 2 --  2 = 'instructor'
			        UNION   -- Instructors
				        SELECT r.[Rank], 'instructor' tableSource, i.PersonID
				          FROM training.TrainingEventParticipants i
			        INNER JOIN persons.PersonsUnitLibraryInfo l on i.PersonID = l.PersonID
			        INNER JOIN unitlibrary.Units u on l.UnitID = u.UnitID
			        INNER JOIN CONTAINSTABLE(persons.Persons, *, @Query)    r ON i.PersonID = r.[Key]
				         WHERE u.CountryID = ISNULL(@CountryID, u.CountryID)
                           AND i.TrainingEventID <> CASE WHEN @TrainingEventID IS NULL THEN -1 ELSE @TrainingEventID END
						   AND i.TrainingEventParticipantTypeID = 2 --  2 = 'instructor'
                    UNION   -- Students Unit Info
				        SELECT r.[Rank], 'studentUnit' tableSource, s.PersonID
				          FROM training.TrainingEventParticipants s
			        INNER JOIN persons.PersonsUnitLibraryInfo l on s.PersonID = l.PersonID
			        INNER JOIN unitlibrary.Units u on l.UnitID = u.UnitID
			        INNER JOIN CONTAINSTABLE(unitlibrary.units, *, @Query)  r ON u.UnitID= r.[Key] OR u.UnitMainAgencyID = r.[Key]
				         WHERE u.CountryID = ISNULL(@CountryID, u.CountryID)
                           AND s.TrainingEventID <> CASE WHEN @TrainingEventID IS NULL THEN -1 ELSE @TrainingEventID END
						   AND s.TrainingEventParticipantTypeID != 2 --  2 = 'instructor'
			        UNION   -- Instructors Unit Info
				        SELECT r.[Rank], 'instructorUnit' tableSource, i.PersonID
				          FROM training.TrainingEventParticipants i
			        INNER JOIN persons.PersonsUnitLibraryInfo l on i.PersonID = l.PersonID
			        INNER JOIN unitlibrary.Units u on l.UnitID = u.UnitID
			        INNER JOIN CONTAINSTABLE(unitlibrary.units, *, @Query)  r ON u.UnitID= r.[Key] OR u.UnitMainAgencyID = r.[Key]
				         WHERE u.CountryID = ISNULL(@CountryID, u.CountryID)
                           AND i.TrainingEventID <> CASE WHEN @TrainingEventID IS NULL THEN -1 ELSE @TrainingEventID END
						   AND i.TrainingEventParticipantTypeID = 2 --  2 = 'instructor'
                   ) s
        INNER JOIN search.ParticipantsAndPersonsView p ON s.PersonID = p.PersonID
          GROUP BY s.PersonID, ParticipantType, FirstMiddleNames, LastNames, Gender, JobTitle, JobRank, UnitName, UnitNameEnglish, 
                   AgencyName, AgencyNameEnglish, CountryName, DOB, VettingStatus, VettingStatusDate, VettingType, Distinction
          ORDER BY MAX([Rank]) DESC;
        END;
END;