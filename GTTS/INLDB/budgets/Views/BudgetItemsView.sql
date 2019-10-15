CREATE VIEW [budgets].[BudgetItemsView]
AS
	SELECT
		BudgetItemID, 
		TrainingEventID, 
		IsIncluded,
		LocationID, 
		bi.BudgetItemTypeID, 
		it.[Name] AS BudgetItemType,
		it.BudgetCategoryID,
		bc.[Name] AS BudgetCategory,
		Cost, 
		Quantity, 
		PeopleCount,
		TimePeriodsCount,
		bi.ModifiedByAppUserID
	FROM budgets.BudgetItems bi 
		INNER JOIN
		budgets.BudgetItemTypes it ON bi.BudgetItemTypeID = it.BudgetItemTypeID 
		INNER JOIN
		budgets.BudgetCategories bc ON it.BudgetCategoryID = bc.BudgetCategoryID;
