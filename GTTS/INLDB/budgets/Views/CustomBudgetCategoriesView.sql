CREATE VIEW [budgets].[CustomBudgetCategoriesView]
AS
	SELECT
		CustomBudgetCategoryID,
		TrainingEventID,
		[Name],
		ModifiedByAppUserID,
		ModifiedDate
	FROM
		budgets.CustomBudgetCategories;
