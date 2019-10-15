CREATE PROCEDURE [budgets].[GetCustomBudgetCategoriesByTrainingEventID]
	@TrainingEventID BIGINT
AS
BEGIN
	SELECT
		CustomBudgetCategoryID,
		TrainingEventID,
		[Name],
		ModifiedByAppUserID,
		ModifiedDate
	FROM
		budgets.CustomBudgetCategoriesView
	WHERE
		TrainingEventID = @TrainingEventID;
END
