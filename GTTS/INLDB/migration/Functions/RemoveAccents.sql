CREATE FUNCTION [migration].[RemoveAccents]
(
	@p_OriginalString VARCHAR(50) -- Original string with accents to be removed.
)
RETURNS VARCHAR(50)		-- Function returns the same string with accents removed.
AS
BEGIN

	-- Declare variables used in this function.
	DECLARE @i INT = 1;  -- must start from 1, as SubString is 1-based
	DECLARE @OriginalString VARCHAR(100) = @p_OriginalString COLLATE SQL_Latin1_General_CP1253_CI_AI;
	DECLARE @ModifiedString VARCHAR(100) = '';
	DECLARE @ReturnValue VARCHAR(100) = '';

	-- Loop through each character in the original string.
	WHILE @i <= LEN(@OriginalString)
		BEGIN
			IF SUBSTRING(@OriginalString, @i, 1) LIKE '[a-Z]'
				BEGIN
					SET @ModifiedString = @ModifiedString + SUBSTRING(@OriginalString, @i, 1);
				END
				SET @i = @i + 1;
	END

	-- Set the return value to the value of the modified string.
    SET @ReturnValue = @ModifiedString;

	-- Exit function and return the value written to @ReturnValue.
	RETURN @ReturnValue
END;