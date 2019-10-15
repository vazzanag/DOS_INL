CREATE PROCEDURE [location].[FindOrCreateLocation]
	@CountryID INT = NULL,
	@StateID INT = NULL,
    @CityID INT,
    @Address1 NVARCHAR(200) = NULL,
    @Address2 NVARCHAR(200) = NULL,
    @Address3 NVARCHAR(200) = NULL,
    @ModifiedByAppUserID INT
AS
BEGIN

    -- Initialize local variables.
    DECLARE @LocationID BIGINT
    DECLARE @RowCountValue as INT = NULL;

	-- Clean up Address lines.
	SET @Address1 = TRIM(@Address1);
	IF (LEN(@Address1) = 0) SET @Address1 = NULL;
	SET @Address2 = TRIM(@Address2);
	IF (LEN(@Address2) = 0) SET @Address2 = NULL;
	SET @Address3 = TRIM(@Address3);
	IF (LEN(@Address3) = 0) SET @Address3 = NULL;

	-- Find CityID from StateID AND CountryID if CityID = 0
	IF ISNULL(@CityID, 0) = 0
        BEGIN
            IF ISNULL(@StateID, 0) > 0
                BEGIN
                    IF NOT EXISTS (SELECT * FROM [location].[Cities] WHERE StateID = @StateID AND CityName = 'Unknown')
                        BEGIN
                            INSERT INTO [location].[Cities]
                                ([CityName], [StateID], [IsActive], [ModifiedByAppUserID]) 
                            VALUES
                                ('Unknown', @StateID, 1, 1);
                        END;

                    SELECT @CityID = CityID FROM [location].[Cities] WHERE StateID = @StateID AND CityName = 'Unknown';
                END
            ELSE
                BEGIN
                    IF NOT EXISTS (SELECT * FROM [location].[States] WHERE CountryID = @CountryID AND StateName = 'Unknown')
                        BEGIN
                            INSERT INTO [location].[States]
                                (CountryID, StateName, StateCodeA2, Abbreviation, INKCode, IsActive, ModifiedByAppUserID)
                            VALUES
                                (@CountryID, 'Unknown', 'UN', 'UNK', 'UNK', 1, 1);
                        END;

                    SELECT @StateID = StateID FROM [location].[States] WHERE CountryID = @CountryID AND StateName = 'Unknown';

                    IF NOT EXISTS (SELECT * FROM [location].[Cities] WHERE StateID = @StateID AND CityName = 'Unknown')
                        BEGIN
                            INSERT INTO [location].[Cities]
                                ([CityName], [StateID], [IsActive], [ModifiedByAppUserID]) 
                            VALUES
                                ('Unknown', @StateID, 1, 1);
                        END;

                    SELECT @CityID = CityID FROM [location].[Cities] WHERE StateID = @StateID AND CityName = 'Unknown';
                END;
        END;

    -- Get the number of records that match the passed in parameters.
    SET @RowCountValue = (SELECT COUNT(*)
                            FROM [location].Locations 
                           WHERE CityID = @CityID 
                             AND (@Address1 IS NULL OR UPPER(TRIM(AddressLine1)) = UPPER(TRIM(@Address1)))
                             AND (@Address2 IS NULL OR UPPER(TRIM(AddressLine2)) = UPPER(TRIM(@Address2)))
                             AND (@Address3 IS NULL OR UPPER(TRIM(AddressLine3)) = UPPER(TRIM(@Address3))));
    IF @RowCountValue > 0
        -- At least 1 matching location record was found.
        BEGIN
            IF @RowCountValue = 1
                -- Only 1 matching location record was found.  Get the LocationID of the matching location record.
                BEGIN
                    SELECT @LocationID = LocationID 
                      FROM [location].Locations 
                     WHERE CityID = @CityID 
                       AND (@Address1 IS NULL OR UPPER(TRIM(AddressLine1)) = UPPER(TRIM(@Address1)))
                       AND (@Address2 IS NULL OR UPPER(TRIM(AddressLine2)) = UPPER(TRIM(@Address2)))
                       AND (@Address3 IS NULL OR UPPER(TRIM(AddressLine3)) = UPPER(TRIM(@Address3)));
                END
            ELSE
                -- More than 1 matching location record was found.  
                -- To avoid an error situation, only get the LocationID of the TOP (1) record.
                BEGIN
                    SET @LocationID = (SELECT TOP (1) LocationID 
                                         FROM [location].Locations 
                                        WHERE CityID = @CityID 
                                          AND (@Address1 IS NULL OR UPPER(TRIM(AddressLine1)) = UPPER(TRIM(@Address1)))
                                          AND (@Address2 IS NULL OR UPPER(TRIM(AddressLine2)) = UPPER(TRIM(@Address2)))
                                          AND (@Address3 IS NULL OR UPPER(TRIM(AddressLine3)) = UPPER(TRIM(@Address3)))
                                       ORDER BY LocationID);
                END;
        END
    ELSE
        -- No matching location records were found.  Create new location & get new LocationID.
        BEGIN
            INSERT INTO [location].Locations
                (CityID, LocationName, AddressLine1, AddressLine2, AddressLine3, IsActive, ModifiedByAppUserID)
            VALUES
                (@CityID, null, @Address1, @Address2, @Address3, 1, @ModifiedByAppUserID)

            SET @LocationID = SCOPE_IDENTITY();
        END;

    -- Return the LocationsView record data for the matching Location record or the newly created Location record.
    SELECT * FROM location.LocationsView WHERE LocationID = @LocationID;
END;