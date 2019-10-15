CREATE PROCEDURE [search].[ParticipantAndPersonSearch]
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

    DECLARE @Query NVARCHAR(4000);

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
				SELECT MAX(r.[Rank]) [Rank], 'student' tableSource, s.PersonID
				  FROM training.TrainingEventParticipants s
			INNER JOIN persons.PersonsUnitLibraryInfo l on s.PersonID = l.PersonID
			INNER JOIN unitlibrary.Units u on l.UnitID = u.UnitID
			INNER JOIN CONTAINSTABLE(persons.Persons, *, @Query)    r ON s.PersonID = r.[Key]
				 WHERE u.CountryID = ISNULL(@CountryID, u.CountryID)
                   AND s.TrainingEventID <> CASE WHEN @TrainingEventID IS NULL THEN -1 ELSE @TrainingEventID END
                   AND l.IsActive = 1
				   AND s.TrainingEventParticipantTypeID != 2 --  2 = 'instructor'
              GROUP BY s.PersonID
			UNION   -- Instructors
				SELECT MAX(r.[Rank]) [Rank], 'instructor' tableSource, i.PersonID
				  FROM training.TrainingEventParticipants i
			INNER JOIN persons.PersonsUnitLibraryInfo l on i.PersonID = l.PersonID
			INNER JOIN unitlibrary.Units u on l.UnitID = u.UnitID
			INNER JOIN CONTAINSTABLE(persons.Persons, *, @Query)    r ON i.PersonID = r.[Key]
				 WHERE u.CountryID = ISNULL(@CountryID, u.CountryID)
                   AND i.TrainingEventID <> CASE WHEN @TrainingEventID IS NULL THEN -1 ELSE @TrainingEventID END
                   AND l.IsActive = 1
				   AND i.TrainingEventParticipantTypeID = 2 --  2 = 'instructor'
              GROUP BY i.PersonID
            UNION   -- Students Unit Info
				SELECT MAX(r.[Rank]) [Rank], 'studentUnit' tableSource, s.PersonID
				  FROM training.TrainingEventParticipants s
			INNER JOIN persons.PersonsUnitLibraryInfo l on s.PersonID = l.PersonID
			INNER JOIN unitlibrary.Units u on l.UnitID = u.UnitID
			INNER JOIN CONTAINSTABLE(unitlibrary.units, *, @Query)  r ON u.UnitID= r.[Key] OR u.UnitMainAgencyID = r.[Key]
				 WHERE u.CountryID = ISNULL(@CountryID, u.CountryID)
                   AND s.TrainingEventID <> CASE WHEN @TrainingEventID IS NULL THEN -1 ELSE @TrainingEventID END
                   AND l.IsActive = 1
				   AND s.TrainingEventParticipantTypeID != 2 --  2 = 'instructor'
              GROUP BY s.PersonID
			UNION   -- Instructors Unit Info
				SELECT MAX(r.[Rank]) [Rank], 'instructorUnit' tableSource, i.PersonID
				  FROM training.TrainingEventParticipants i
			INNER JOIN persons.PersonsUnitLibraryInfo l on i.PersonID = l.PersonID
			INNER JOIN unitlibrary.Units u on l.UnitID = u.UnitID
			INNER JOIN CONTAINSTABLE(unitlibrary.units, *, @Query)  r ON u.UnitID= r.[Key] OR u.UnitMainAgencyID = r.[Key]
				 WHERE u.CountryID = ISNULL(@CountryID, u.CountryID)
                   AND i.TrainingEventID <> CASE WHEN @TrainingEventID IS NULL THEN -1 ELSE @TrainingEventID END
                   AND l.IsActive = 1
				   AND i.TrainingEventParticipantTypeID = 2 --  2 = 'instructor'
              GROUP BY i.PersonID
			UNION   -- Vetted, Non-participants
				SELECT MAX(r.[Rank]) [Rank], 'other' tableSource, p.PersonID
				  FROM persons.Persons p
			INNER JOIN persons.PersonsUnitLibraryInfo l on p.PersonID = l.PersonID
			INNER JOIN unitlibrary.Units u on l.UnitID = u.UnitID
		   CROSS APPLY
				        (
					        SELECT TOP 1 v.VettingPersonStatusID, s.Code, v.VettingStatusDate, b.VettingBatchTypeID, t.Code AS VettyingTypeCode
					          FROM [vetting].[PersonsVetting] v
				         LEFT JOIN [vetting].VettingBatches         b ON v.VettingBatchID = b.VettingBatchID
				         LEFT JOIN [vetting].[VettingBatchTypes]    t ON b.VettingBatchTypeID = t.VettingBatchTypeID
                        INNER JOIN [vetting].VettingPersonStatuses  s ON v.VettingPersonStatusID = s.VettingPersonStatusID
				        INNER JOIN [persons].PersonsUnitLibraryInfo u ON v.PersonsUnitLibraryInfoID = u.PersonsUnitLibraryInfoID
					         WHERE u.PersonID = p.PersonID
				          ORDER BY VettingStatusDate DESC
				        ) AS v
		    INNER JOIN CONTAINSTABLE(persons.Persons, *, @Query)    r ON p.PersonID = r.[Key]
				 WHERE u.CountryID = ISNULL(@CountryID, u.CountryID)
                   AND l.IsActive = 1
              GROUP BY p.PersonID
			UNION  -- Add records that meet the filter for lastClearence
				SELECT 0 AS [Rank], 'ParticipantsAndPersonsView' AS tableSource, u.PersonID
				  FROM [vetting].[PersonsVetting] v
			 LEFT JOIN [vetting].VettingPersonStatuses  s ON v.VettingPersonStatusID = s.VettingPersonStatusID
			 LEFT JOIN [vetting].VettingBatches         b ON v.VettingBatchID = b.VettingBatchID
			 LEFT JOIN [vetting].[VettingBatchTypes]    t ON b.VettingBatchTypeID = t.VettingBatchTypeID
		    INNER JOIN [persons].PersonsUnitLibraryInfo u ON v.PersonsUnitLibraryInfoID = u.PersonsUnitLibraryInfoID
			  	 WHERE '('+ t.Code +') ' + s.Code + ' '+ convert(varchar, VettingStatusDate, 101) LIKE '%' + @SearchString + '%'
			  GROUP BY PersonID
           ) s
INNER JOIN search.ParticipantsAndPersonsView p ON s.PersonID = p.PersonID
  GROUP BY s.PersonID, ParticipantType, FirstMiddleNames, LastNames, Gender, JobTitle, JobRank, UnitName, UnitNameEnglish, 
           AgencyName, AgencyNameEnglish, CountryName, DOB, VettingStatus, VettingStatusDate, VettingType, Distinction
  ORDER BY MAX([Rank]) DESC;


END