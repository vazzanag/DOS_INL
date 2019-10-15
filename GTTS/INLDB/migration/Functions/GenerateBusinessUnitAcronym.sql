CREATE FUNCTION [migration].[GenerateBusinessUnitAcronym]
(
	@strTrainingUnitName VARCHAR(500),	-- The training unit name from which to generate the acronym value.
	@strAcronym VARCHAR(32),			-- Acronym value to verify.  If NULL, then the acronym will be
										-- generated from the @strTrainingUnitName value.
	@intPostID INT						-- The Post ID of the Post to filter [BusinessUnits] table on when 
										-- verifying the uniqueness of the generated acronym value.
)
RETURNS VARCHAR(32)		-- Function returns either a valid acronym value or NULL if no valid acronym was generated or verified.
AS
BEGIN

	-- Declare variables used in this function.
	DECLARE @ReturnValue AS VARCHAR(32);
	DECLARE @strNewAcronym AS VARCHAR(32);
	DECLARE @intBUID AS BIGINT = NULL;
	DECLARE @Counter AS INT = 0;

    -- Default the return value to NULL.
    SET @ReturnValue = NULL;

	-- Initialize @strNewAcronym variable based on whether of not an acronym value was passed into the function.
	SET @strNewAcronym = IIF(@strAcronym IS NULL OR LEN(TRIM(@strAcronym)) = 0, 
								LEFT(REPLACE(@strTrainingUnitName,' ', ''),32), 
								LEFT(REPLACE(@strAcronym,' ', ''),32));

	-- Initial test of the uniqueness of the acronymn value being tested.  If the acronym value
	-- is unique, @intBUID will be NULL.
	SET @intBUID = (SELECT bu.BusinessUnitID 
					  FROM users.BusinessUnits bu 
					 WHERE bu.Acronym = @strNewAcronym AND bu.[PostID] = @intPostID);

	-- Loop while the SELECT has returned a Business Unit ID (@intBUID) for a generated acronym value.
	-- The loop is completed when the SELECT does not return a Business Unit ID (@intBUID IS NULL) OR 
	-- the loop has processed more that 9,999 iterations (@Counter) of an acronym value.
	WHILE @intBUID IS NOT NULL OR @Counter > 9999
		BEGIN

			-- Increment @Counter by 1.
			SET @Counter = @Counter + 1;

			-- Set @strNewAcronym variable based on whether of not an acronym value was passed into the
			-- function.  Then append the incrementing @Counter value to the end of the acronym string.
			SET @strNewAcronym = IIF(@strAcronym IS NULL OR LEN(TRIM(@strAcronym)) = 0, 
										LEFT(REPLACE(@strTrainingUnitName,' ', ''),27), 
										LEFT(REPLACE(@strAcronym,' ', ''),27))
								 + '_' + CAST(@Counter AS varchar);

			-- Test of the uniqueness of the acronymn value being tested.  If the acronym value
			-- is unique, @intBUID will be NULL.
			SET @intBUID = (SELECT bu.BusinessUnitID 
							  FROM users.BusinessUnits bu 
							 WHERE bu.Acronym = @strNewAcronym AND bu.[PostID] = @intPostID);											 											 
		END;

	IF @Counter < 9999
		-- Valid acronym was found.  Set @ReturnValue to @strNewAcronym.
		BEGIN
			SET @ReturnValue = @strNewAcronym;
		END
	ELSE
		-- Valid acronym was not found.  Set @ReturnValue to NULL.
		BEGIN
			SET @ReturnValue = NULL
		END;

	-- Exit function and return the value written to @ReturnValue.
	RETURN @ReturnValue
END;