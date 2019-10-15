CREATE FUNCTION [unitlibrary].[ChildUnits]
(
	@UnitID bigint,
	@Depth smallint,
	@DepthLimit smallint,
    @English bit
)
RETURNS nvarchar(max)
AS
BEGIN
	DECLARE @child bigint,
			@name NVARCHAR(300),
			@returnValue NVARCHAR(MAX),
			@newDepth smallint,
			@CursorStatus int;

    -- SET TO 1+ CURRENT DEPTH FOR NEXT CALL
	SET @newDepth = @Depth + 1

    -- GET THE ENGLISH NAME OF PASSED @UnitID
    IF (@English = 1)
	    SELECT @name = UnitNameEnglish FROM unitlibrary.Units WHERE UnitID = @UnitID;
    ELSE
        SELECT @name = UnitName FROM unitlibrary.Units WHERE UnitID = @UnitID;

	-- SET DEFAULT RETURN VALUE
	SET @returnValue = @name;

	-- DECLARE CURSOR FOR CHILD UNITS
    DECLARE child_cursor CURSOR FOR 
		SELECT UnitID FROM unitlibrary.Units WHERE UnitParentID = @UnitID;
    OPEN child_cursor;

	-- GET CURSOR STATUS
	SELECT @CursorStatus = CURSOR_STATUS('local','child_cursor');

	FETCH NEXT FROM child_cursor INTO @child;  
	IF @CursorStatus > 0
	BEGIN
		-- LOOP CURSOR
		WHILE @@FETCH_STATUS = 0  
		BEGIN
			-- RECURSIVELY CALL SELF TO GET CHILD UNITS
			SET @returnValue = @returnValue + ' / ' + ISNULL(unitlibrary.ChildUnits(@child, @newDepth, @DepthLimit, @English), '');
			FETCH NEXT FROM child_cursor INTO @child;  
		END   

		-- CLOSE AND DEALLOCATE CURSORS
		CLOSE child_cursor;  
		DEALLOCATE child_cursor;  
	END

	RETURN @returnValue
END
