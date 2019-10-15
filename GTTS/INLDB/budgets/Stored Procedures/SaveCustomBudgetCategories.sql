CREATE PROCEDURE [budgets].[SaveCustomBudgetCategories]
	@TrainingEventID BIGINT,
	@CustomBudgetCategoriesJson NVARCHAR(MAX),
	@ModifiedByAppUserID BIGINT
AS
BEGIN
	DELETE FROM budgets.CustomBudgetCategories
	WHERE 
		TrainingEventID = @TrainingEventID AND
		CustomBudgetCategoryID NOT IN (SELECT j.CustomBudgetCategoryID FROM OPENJSON(@CustomBudgetCategoriesJson) WITH (CustomBudgetCategoryID INT) j);

	UPDATE 
		customBudgetCategories
	SET
		customBudgetCategories.[Name] = jsonEntries.[Name],
		customBudgetCategories.ModifiedByAppUserID = @ModifiedByAppUserID,
		customBudgetCategories.ModifiedDate = GETUTCDATE()
	FROM
		budgets.CustomBudgetCategories AS customBudgetCategories 
		INNER JOIN
		(SELECT 
			j.CustomBudgetCategoryID,
			j.[Name]
		FROM OPENJSON(@CustomBudgetCategoriesJson)
		WITH (CustomBudgetCategoryID INT, [Name] NVARCHAR(50)) j) jsonEntries
		ON customBudgetCategories.CustomBudgetCategoryID = jsonEntries.CustomBudgetCategoryID AND customBudgetCategories.TrainingEventID = @TrainingEventID;

	INSERT INTO budgets.CustomBudgetCategories
			(
				TrainingEventID, [Name], ModifiedByAppUserID
			)
		SELECT @TrainingEventID, j.[Name], @ModifiedByAppUserID
		FROM OPENJSON(@CustomBudgetCategoriesJson)
		WITH (CustomBudgetCategoryID INT, [Name] NVARCHAR(50)) j
		WHERE j.CustomBudgetCategoryID IS NULL;

	SELECT 
		CustomBudgetCategoryID,
		TrainingEventID,
		[Name],
		ModifiedByAppUserID,
		ModifiedDate
	FROM budgets.CustomBudgetCategoriesView
	WHERE
		TrainingEventID = @TrainingEventID;
END
