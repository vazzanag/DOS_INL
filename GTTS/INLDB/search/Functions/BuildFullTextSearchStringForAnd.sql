CREATE FUNCTION [search].[BuildFullTextSearchStringForAnd]
(
    @SearchString NVARCHAR(4000)
)
RETURNS NVARCHAR(4000)
AS
BEGIN
    DECLARE @Query NVARCHAR(4000), 
            @DelimIndex SMALLINT, 
            @Word NVARCHAR(200),
            @SearchTrimmed NVARCHAR(4000);

    -- INITIALIZE VARIABLES
    SET @Query = '';
    SET @SearchTrimmed = TRIM(@SearchString)

    -- BUILD FULLTEXT SEARCH STRING
    SET @DelimIndex = CHARINDEX(' ', @SearchTrimmed, 0);
    WHILE (@DelimIndex != 0)
    BEGIN
        -- ADD "OR" IF NECESSARY
	    IF @Query <> '' 
            SET @Query = @Query + ' AND ';

        -- GET WORD
        SET @Word = SUBSTRING(@SearchTrimmed, 0, @DelimIndex);

        -- ADD WORD TO @query
        SET @Query = @Query + '"' + @Word + '*"';

        -- UPDATE @SearchTrimmed
        SET @SearchTrimmed = SUBSTRING(@SearchTrimmed, @DelimIndex+1, LEN(@SearchTrimmed)-@DelimIndex);

        -- GET NEXT INDEX
        SET @DelimIndex = CHARINDEX(' ', @SearchTrimmed, 0);
    END ;

    -- ADD THE LAST WORD
    IF (@Query <> '' AND @SearchTrimmed <> '')
        SET @Query = @Query + ' AND "' + @SearchTrimmed + '*"';
    ELSE 
        SET @Query = '"' + @SearchTrimmed + '*"';


    RETURN @Query;
END
