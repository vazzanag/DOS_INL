CREATE PROCEDURE [unitlibrary].[GetUnitAndChildren]
	@UnitID BIGINT
AS

BEGIN
	;WITH cte AS 
	 (
	  SELECT u.UnitID, u.UnitParentID, u.UnitName, u.UnitNameEnglish, u.UnitGenID, u.UnitBreakdown, u.UnitBreakdownLocalLang, u.VettingBatchTypeID, 
             u.VettingBatchTypeCode, VettingActivityTypeID, VettingActivityType
		FROM unitlibrary.UnitsView u WHERE UnitID = @UnitID

	  UNION ALL
	  SELECT u.UnitID, u.UnitParentID, u.UnitName, u.UnitNameEnglish, u.UnitGenID, u.UnitBreakdown, u.UnitBreakdownLocalLang, u.VettingBatchTypeID, 
             u.VettingBatchTypeCode, u.VettingActivityTypeID, u.VettingActivityType
		FROM unitlibrary.UnitsView u JOIN cte c ON u.UnitParentID = c.UnitID
	  )
	  SELECT UnitID, UnitParentID, UnitName, UnitNameEnglish, UnitGenID, UnitBreakdown, UnitBreakdownLocalLang, VettingBatchTypeID, 
             VettingBatchTypeCode,  VettingActivityTypeID, VettingActivityType
        FROM cte
 END