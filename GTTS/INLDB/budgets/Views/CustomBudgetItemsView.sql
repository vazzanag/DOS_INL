CREATE VIEW [budgets].[CustomBudgetItemsView]
AS
	SELECT
		CustomBudgetItemID,
		ISNULL(cbi.TrainingEventID, cbc.TrainingEventID) AS TrainingEventID,
		IsIncluded,
		LocationID,
		BudgetCategoryID,
		cbi.CustomBudgetCategoryID,
		SupportsQuantity,
		SupportsPeopleCount,
		SupportsTimePeriodsCount,
		cbi.[Name],
		Cost,
		Quantity,
		PeopleCount,
		TimePeriodsCount,
		cbi.ModifiedByAppUserID,
		cbi.ModifiedDate
	FROM
		budgets.CustomBudgetItems cbi 
		LEFT JOIN
		budgets.CustomBudgetCategories cbc ON cbi.CustomBudgetCategoryID = cbc.CustomBudgetCategoryID;