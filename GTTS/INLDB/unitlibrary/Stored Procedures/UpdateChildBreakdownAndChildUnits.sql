CREATE PROCEDURE [unitlibrary].[UpdateChildBreakdownAndChildUnits]
    @UnitID BIGINT
AS
BEGIN

    DECLARE @child bigint,
			@name NVARCHAR(300),
			@returnValue NVARCHAR(MAX),
			@newDepth smallint,
			@CursorStatus int;


    -- UPDATE UNIT'S UnitBreakdown AND ChildUnits VALUES
    UPDATE unitlibrary.Units SET
           UnitBreakdown = unitlibrary.UnitBreakdownLocalLang(UnitID, 0, 50, 0, -1),
		   UnitBreakdownEnglish = unitlibrary.UnitBreakdown(UnitID, 0, 50, 0, -1),
		   ChildUnits = unitlibrary.ChildUnits(UnitID, 0, 50, 0),
		   ChildUnitsEnglish = unitlibrary.ChildUnits(UnitID, 0, 50, 1)
     WHERE UnitID = @UnitID;

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
            -- RECURSIVELY CALL SELF TO UPDATE THIS UNIT'S CHILD UNITS
            EXEC unitlibrary.UpdateChildBreakdownAndChildUnits @Child;

            -- GET NEXT RECORD IN CURSOR
			FETCH NEXT FROM child_cursor INTO @child;  
		END   

		-- CLOSE AND DEALLOCATE CURSORS
		CLOSE child_cursor;  
		DEALLOCATE child_cursor;  
	END
END;