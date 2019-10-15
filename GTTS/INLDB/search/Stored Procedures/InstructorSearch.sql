CREATE PROCEDURE [search].[InstructorSearch]
    @SearchString NVARCHAR(3500) = NULL,
    @CountryID INT = NULL
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
        Union necessary for search inclusions across both fulltext indecies and country name
        Grouping necessary to remove duplicates, taking highest rank if duplicate found
    */
    SELECT MAX([Rank]) AS [Rank], PersonID, FirstMiddleNames, LastNames, AgencyName, AgencyNameEnglish, UnitName, UnitNameEnglish, CountryName, CAST(FORMAT ( DOB, 'd', 'en-US' ) AS NVARCHAR(15)) DOB
      FROM (
		        SELECT r.[Rank], PersonID, FirstMiddleNames, LastNames, i.UnitName, i.UnitNameEnglish,
                       a.UnitName AS AgencyName, a.UnitNameEnglish AS AgencyNameEnglish, CountryName, i.DOB
		          FROM [search].[InstructorsView] i
		    INNER JOIN unitlibrary.Units                            a ON i.UnitMainAgencyID = a.UnitID
		    INNER JOIN CONTAINSTABLE(unitlibrary.Units, *, @Query)  r ON i.UnitMainAgencyID = r.[Key]
                 WHERE i.CountryID = ISNULL(@CountryID, i.CountryID)
	    UNION
		        SELECT r.[Rank], PersonID, FirstMiddleNames, LastNames, i.UnitName, i.UnitNameEnglish, 
                       a.UnitName AS AgencyName, a.UnitNameEnglish AS AgencyNameEnglish, CountryName, i.DOB
		          FROM [search].[InstructorsView] i
		    INNER JOIN unitlibrary.Units                            a ON i.UnitMainAgencyID = a.UnitID
		    INNER JOIN CONTAINSTABLE(persons.Persons, *, @Query)    r ON i.PersonID = r.[Key]
                 WHERE i.CountryID = ISNULL(@CountryID, i.CountryID)
		UNION
		        SELECT 100 AS [Rank], PersonID, FirstMiddleNames, LastNames, i.UnitName, i.UnitNameEnglish, 
                       a.UnitName AS AgencyName, a.UnitNameEnglish AS AgencyNameEnglish, CountryName, i.DOB
		          FROM [search].[InstructorsView] i
		    INNER JOIN unitlibrary.Units                            a ON i.UnitMainAgencyID = a.UnitID
                 WHERE i.CountryID = ISNULL(@CountryID, i.CountryID)
                   AND @SearchString LIKE '%' + CAST(FORMAT ( i.DOB, 'd', 'en-US' ) AS NVARCHAR(15)) + '%'
           ) s
  GROUP BY PersonID, FirstMiddleNames, LastNames, AgencyName, AgencyNameEnglish, UnitName, UnitNameEnglish, CountryName, DOB
  ORDER BY MAX([Rank]) DESC;

END