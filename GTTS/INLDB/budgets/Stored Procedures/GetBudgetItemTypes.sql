CREATE PROCEDURE [budgets].[GetBudgetItemTypes]
AS
BEGIN
	SELECT
		[BudgetItemTypeID],
		[BudgetCategoryID],
		BudgetCategory,
		[DefaultCost],
		[IsCostConfigurable],
		[SupportsQuantity],
		[SupportsPeopleCount],
		[SupportsTimePeriodsCount],
		[Name],
		[IsActive],
		[ModifiedByAppUserID],
		[ModifiedDate]
	FROM budgets.BudgetItemTypesView;
END
