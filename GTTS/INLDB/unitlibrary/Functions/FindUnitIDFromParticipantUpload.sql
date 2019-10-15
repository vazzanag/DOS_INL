CREATE FUNCTION [unitlibrary].[FindUnitIDFromParticipantUpload]
(
	@DataSource VARCHAR(15),	-- Identifies the source of the value in @SearchFor.
								-- Valid values are: 'UnitBreakdown', 'UnitGenID', 'UnitAlias'.
	@SearchFor NVARCHAR(1000),  -- Value to search for.
	@CountryID BIGINT           -- CountryID to filter [Units] table on.

)
RETURNS BIGINT
AS
BEGIN
	
	-- Declare variables used in this function.
	DECLARE @ReturnValue AS BIGINT;
	DECLARE @Query AS NVARCHAR(1000);
	DECLARE @RowCount as INT;
	DECLARE @UnitIDTbl AS TABLE
	(
		UnitID BIGINT         
	);

    -- Default the return value to NULL.
    SET @ReturnValue = NULL;

	-- Standarize the contents of @SearchFor.
	SET @Query = UPPER(TRIM(REPLACE(REPLACE(@SearchFor, ' ', ''), '.', '')))


	IF @DataSource = 'UnitBreakdown'
		-- Input value is coming from the [UnitBreakdown] field in the Participants import file.
		BEGIN
			INSERT INTO @UnitIDTbl 
			(
				UnitID
			)
			SELECT u.[UnitID]
			  FROM [unitlibrary].[Units] u
			 WHERE u.[CountryID] = @CountryID
			   AND ((@Query = UPPER(TRIM(REPLACE(REPLACE(u.[UnitName], ' ', ''), '.', ''))))
					 OR (@Query = UPPER(TRIM(REPLACE(REPLACE(u.[UnitNameEnglish], ' ', ''), '.', ''))))
					 OR (@Query = UPPER(TRIM(REPLACE(REPLACE(u.[UnitBreakdown], ' ', ''), '.', ''))))      
					 OR (@Query = UPPER(TRIM(REPLACE(REPLACE(u.[UnitBreakdownEnglish], ' ', ''), '.', ''))))); 

			SET @RowCount = @@ROWCOUNT

			IF @RowCount = 1
				-- The search against some of the [UnitsView] columns returned a valid, unique match.
				-- Set @ReturnValue to the resulting UnitID value and exist the function.
				-- If @RowCount is not 1 (meaning 0 or >1), then function returns NULL to indicate that
				-- a valid match on the [UnitBreakdown] field in the Participant import file was not found.
				BEGIN
					-- Only 1 row found that matches @SearchFor.  Set @ReturnValue and exit IF.
					SET @ReturnValue = (SELECT UnitID FROM @UnitIDTbl);
				END
			ELSE
				-- Unable to identify a specfic, unique [UnitsVIew] row that matches the @SearchFor value.
				-- Set the @ReturnValue to NULL to indicate a match failure and exit the function.
				BEGIN
					SET @ReturnValue = NULL;
				END	
		END

	IF @DataSource = 'UnitGenID'
		-- Input value is coming from the [UnitGenID] field in the Participants import file.
		BEGIN
			INSERT INTO @UnitIDTbl 
			(
				UnitID
			)
			SELECT u.[UnitID]
			  FROM [unitlibrary].[Units] u
			 WHERE u.[CountryID] = @CountryID
			   AND (@Query = UPPER(TRIM(REPLACE(REPLACE(u.[UnitGenID], ' ', ''), '.', ''))));

			SET @RowCount = @@ROWCOUNT

			IF @RowCount = 1
				-- The search against some of the [UnitsView] columns returned a valid, unique match.
				-- Set @ReturnValue to the resulting UnitID value and exist the function.
				-- If @RowCount is not 1 (meaning 0 or >1), then function returns NULL to indicate that
				-- a valid match on the [UnitBreakdown] field in the Participant import file was not found.
				BEGIN
					-- Only 1 row found that matches @SearchFor.  Set @ReturnValue and exit IF.
					SET @ReturnValue = (SELECT UnitID FROM @UnitIDTbl);
				END
			ELSE
				-- Unable to identify a specfic, unique [UnitsVIew] row that matches the @SearchFor value.
				-- Set the @ReturnValue to NULL to indicate a match failure and exit the function.
				BEGIN
					SET @ReturnValue = NULL;
				END	
		END

	IF @DataSource = 'UnitAlias'
		-- Input value is coming from the [UnitAlias] field in the Participants import file.
		BEGIN
			INSERT INTO @UnitIDTbl 
			(
				UnitID
			)
			SELECT ua.[UnitID]
			  FROM [unitlibrary].[UnitAliases] ua
			 WHERE @Query = UPPER(TRIM(REPLACE(REPLACE(ua.[UnitAlias], ' ', ''), '.', '')));

			SET @RowCount = @@ROWCOUNT

			IF @RowCount = 1
				-- A valid, unique match in the [UnitAliases] table was found.  
				-- Set @ReturnValue and exit the function.
				BEGIN
					SET @ReturnValue = (SELECT UnitID FROM @UnitIDTbl);
				END
			ELSE
				-- Unable to identify a specfic, unique [UnitAliases] row that matches the @SearchFor value.
				-- Set the @ReturnValue to NULL to indicate a match failure and exit the function.
				BEGIN
					SET @ReturnValue = NULL;
				END					
		END

	RETURN @returnValue
END