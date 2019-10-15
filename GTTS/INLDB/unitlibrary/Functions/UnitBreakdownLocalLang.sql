CREATE FUNCTION [unitlibrary].[UnitBreakdownLocalLang]
(
	@UnitID bigint,
	@Depth smallint,
	@DepthLimit smallint,
	@FullBreakDown smallint = 0, 
	@UnitMainAgencyID bigint = -1
)
RETURNS nvarchar(max)
AS
BEGIN
	DECLARE @parent bigint,
			@name NVARCHAR(300),
			@returnValue NVARCHAR(MAX),
			@newDepth smallint

	-- FIRST TIME Get UnitMagencyID
	IF @UnitMainAgencyID < 0
	BEGIN
		SELECT @UnitMainAgencyID = UnitMainAgencyID FROM unitlibrary.Units WHERE UnitID = @UnitID
	END
    -- SET TO 1+ CURRENT DEPTH FOR NEXT CALL
	SET @newDepth = @Depth + 1

    -- GET THE PARENT ID BASED ON THE PASSED @UnitID FOR NEXT CALL
	SELECT @parent = UnitParentID FROM unitlibrary.Units WHERE UnitID = @UnitID

    -- GET THE NAME OF PASSED @UnitID IN THE LOCAL LANGUAGE
	SELECT @name = UnitName FROM unitlibrary.Units WHERE UnitID = @UnitID

    -- IF NO PARENT, DEPTHLIMIT REACHED OR DEPTH IS > 20, STOP AND RETURN NAME
	IF (@FullBreakDown = 1)
	BEGIN
		IF (@parent IS NULL OR (@Depth = @DepthLimit AND @DepthLimit <> -1) OR @Depth > 20)
		BEGIN
			-- NO PARENTS OR DEPTHLIMIT CRITERIA MET
			SET @returnValue = @name
		END
		ELSE
		BEGIN
			 -- RECURSIVELY CALL SELF TO BUILD UNIT BREAKDOWN
			SET @returnValue = unitlibrary.UnitBreakdownLocalLang(@parent, @newDepth, @DepthLimit, @FullBreakDown, @UnitMainAgencyID) + ' / '+ @name
		END
	END
	ELSE
	BEGIN
		IF (@parent IS NULL OR @UnitID = @UnitMainAgencyID OR (@Depth = @DepthLimit AND @DepthLimit <> -1) OR @Depth > 20)
		BEGIN
			-- NO PARENTS OR DEPTHLIMIT CRITERIA MET
			SET @returnValue = @name
		END
		ELSE
		BEGIN
			 -- RECURSIVELY CALL SELF TO BUILD UNIT BREAKDOWN
			SET @returnValue = unitlibrary.UnitBreakdownLocalLang(@parent, @newDepth, @DepthLimit, @FullBreakDown, @UnitMainAgencyID) + ' / '+ @name
		END
	END

	RETURN @returnValue
END

