CREATE PROCEDURE [budgets].[GetBudgetItemsByTrainingEventID]
	@TrainingEventID BIGINT
AS
BEGIN
	SELECT
		BudgetItemID, 
		TrainingEventID, 
		IsIncluded,
		LocationID, 
		BudgetItemTypeID, 
		BudgetItemType,
		BudgetCategoryID,
		BudgetCategory,
		Cost, 
		Quantity, 
		PeopleCount,
		TimePeriodsCount,
		ModifiedByAppUserID
	FROM budgets.BudgetItemsView
	WHERE TrainingEventID = @TrainingEventID;
END
