CREATE PROCEDURE [unitlibrary].[UpdateParentBreakdownAndChildUnits]
    @UnitID BIGINT
AS
BEGIN

    DECLARE @ParentID BIGINT;

    -- UPDATE UNIT'S UnitBreakdown AND ChildUnits VALUES
    UPDATE unitlibrary.Units SET
		   UnitBreakdown = unitlibrary.UnitBreakdownLocalLang(UnitID, 0, 50, 0, -1),
		   UnitBreakdownEnglish = unitlibrary.UnitBreakdown(UnitID, 0, 50, 0, -1),
           ChildUnits = unitlibrary.ChildUnits(UnitID, 0, 50, 0),
		   ChildUnitsEnglish = unitlibrary.ChildUnits(UnitID, 0, 50, 1)
     WHERE UnitID = @UnitID;

    -- GET UNIT'S UnitParentID
    SELECT @ParentID = UnitParentID FROM unitlibrary.Units WHERE UnitID = @UnitID;

    IF (@ParentID IS NOT NULL)
        BEGIN
             -- RECURSIVELY CALL SELF TO UPDATE THIS UNIT'S PARENT UNIT
             EXEC unitlibrary.UpdateParentBreakdownAndChildUnits @ParentID;
        END
END;
