CREATE PROCEDURE [migration].[GetLocationID]
	@CountryID INT = NULL,
	@StateID INT = NULL,
    @CityID INT,
    @Address1 NVARCHAR(200) = NULL,
    @Address2 NVARCHAR(200) = NULL,
    @Address3 NVARCHAR(200) = NULL,
    @ModifiedByAppUserID INT
AS
BEGIN

	-- Declare a table variable to hold the results from the FindOrCreateLocation Stored Procedure.
    DECLARE @LocationIDsTbl AS TABLE
    (
        LocationID BIGINT,
        LocationName NVARCHAR(200), 
        IsActive BIT, 
        ModifiedByAppUserID INT, 
        ModifiedDate DATETIME,
        AddressLine1 NVARCHAR(200), 
        AddressLine2 NVARCHAR(200), 
        AddressLine3 NVARCHAR(200), 
        CityID INT, 
        CityName NVARCHAR(100), 
        StateID INT, 
        StateName NVARCHAR(75), 
        StateCodeA2 NCHAR(2), 
        StateAbbreviation NVARCHAR(10), 
        StateINKCode NVARCHAR(15),
        CountryID INT, 
        CountryName NVARCHAR(75), 
        GENCCodeA2 NCHAR(2), 
        CountryAbbreviation NCHAR(3), 
        CountryINKCode NVARCHAR(15),
        Latitude NVARCHAR(100), 
        Longitude NVARCHAR(100) 
    );

	-- Execute the FindOrCreateLocation Stored Procedure and save the returned row(s) into the table variable.
    INSERT INTO @LocationIDsTbl
	EXECUTE [location].[FindOrCreateLocation] @CountryID = @CountryID, 
											  @StateID = @StateID, 
											  @CityID = @CityID, 
											  @Address1 = @Address1, 
											  @Address2 = @Address2, 
											  @Address3 = @Address3, 
											  @ModifiedByAppUserID = 2;

    -- Initialize local variables.
    DECLARE @LocationID BIGINT = NULL;
    DECLARE @RowCount as INT = NULL;

	-- Get the number of rows returned from the FindOrCreateLocation Stored Procedure.
	SET @RowCount = (SELECT COUNT(*) FROM @LocationIDsTbl);

	IF @RowCount > 0
		-- At least 1 row was returned.
		BEGIN
			IF @RowCount = 1
				-- Only 1 row was returned.  Set return value to LocationID value.
				BEGIN
					SET @LocationID = (SELECT LocationID FROM @LocationIDsTbl);
				END
			ELSE
                -- More than 1 matching location record was found.  
                -- To avoid an error situation, set the return value to the LocationID of the TOP (1) record.
				BEGIN
					SET @LocationID = (SELECT TOP(1) LocationID FROM @LocationIDsTbl ORDER BY LocationID);
				END;
		END
	ELSE
		-- No matching location records were found.  Set return value to 0.
		BEGIN
			SET @LocationID = 0;
		END;

    -- Return LocationID value back to where the Stored Procedure was called from.
    RETURN @LocationID;

END;

