CREATE VIEW [budgets].[BudgetItemTypesView]
AS 
	SELECT
		[BudgetItemTypeID],
		c.[BudgetCategoryID],
		c.[Name] AS BudgetCategory,
		[DefaultCost],
		[IsCostConfigurable],
		[SupportsQuantity],
		[SupportsPeopleCount],
		[SupportsTimePeriodsCount],
		it.[Name],
		it.[IsActive],
		it.[ModifiedByAppUserID],
		it.[ModifiedDate]
	FROM [budgets].BudgetItemTypes it 
	INNER JOIN [budgets].BudgetCategories c ON it.BudgetCategoryID = c.BudgetCategoryID;

