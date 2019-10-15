CREATE PROCEDURE [unitlibrary].[GetNextUnitGenID]
    @CountryID INT,
    @UnitMainAgencyID BIGINT = NULL,
    @Identifier NVARCHAR(30),
	@IncludeCountryCode BIT = 1,
	@UnitParentID BIGINT = NULL
AS
BEGIN

    DECLARE @Sequence INT, 
	        @UnitGenID NVARCHAR(50) = NULL, 
			@CountryCode NVARCHAR(2)

    -- USE COUNT AS NEXT SEQUENCE
	IF @UnitMainAgencyID IS NOT NULL 
		SELECT @Sequence = COUNT(@@ROWCOUNT) + 1 FROM unitlibrary.Units WHERE CountryID = @CountryID AND UnitMainAgencyID = @UnitMainAgencyID;
	ELSE IF ISNULL(@UnitParentID, 0) > 0
		SELECT @Sequence = COUNT(@@ROWCOUNT) + 1 FROM unitlibrary.Units WHERE CountryID = @CountryID AND UnitMainAgencyID =  @UnitParentID
	ELSE
		SELECT @Sequence = COUNT(@@ROWCOUNT) + 1 FROM unitlibrary.Units WHERE CountryID = @CountryID AND IsMainAgency = 1;
	
	IF (@IncludeCountryCode = 1)
	BEGIN
		SELECT @CountryCode = GENCCodeA2
		FROM [location].Countries
		WHERE CountryID = @CountryID

		SET @Identifier = @CountryCode + @Identifier;
	END
		
    -- LOOP WHILE UnitGenID EXISTS
    WHILE (@UnitGenID IS NULL OR EXISTS(SELECT UnitGenID FROM unitlibrary.Units WHERE UnitGenID = @UnitGenID))
    BEGIN
        SET @Sequence = @Sequence + 1;
        SET @UnitGenID = @Identifier + RIGHT('0000' + CAST(ISNULL(@Sequence, 0) AS VARCHAR(5)), 5);
    END

    SELECT @UnitGenID AS UnitGenID;
END
