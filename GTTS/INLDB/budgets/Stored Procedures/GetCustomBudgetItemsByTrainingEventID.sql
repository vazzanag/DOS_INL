CREATE PROCEDURE [budgets].[GetCustomBudgetItemsByTrainingEventID]
	@TrainingEventID BIGINT
AS
BEGIN
	SELECT
		CustomBudgetItemID,
		TrainingEventID,
		IsIncluded,
		LocationID,
		BudgetCategoryID,
		CustomBudgetCategoryID,
		SupportsQuantity,
		SupportsPeopleCount,
		SupportsTimePeriodsCount,
		[Name],
		Cost,
		Quantity,
		PeopleCount,
		TimePeriodsCount,
		ModifiedByAppUserID,
		ModifiedDate
	FROM budgets.CustomBudgetItemsView
	WHERE TrainingEventID = @TrainingEventID;
END
