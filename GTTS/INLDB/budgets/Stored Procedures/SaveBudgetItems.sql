CREATE PROCEDURE [budgets].[SaveBudgetItems]
	@TrainingEventID BIGINT,
	@BudgetItemsJson NVARCHAR(MAX),
	@ModifiedByAppUserID BIGINT
AS
BEGIN
	DELETE FROM budgets.BudgetItems
	WHERE 
		TrainingEventID = @TrainingEventID AND
		BudgetItemID NOT IN (SELECT j.BudgetItemID FROM OPENJSON(@BudgetItemsJson) WITH (BudgetItemID INT) j);

	UPDATE 
		budgetItems
	SET
		budgetItems.IsIncluded = jsonEntries.IsIncluded, 
		budgetItems.LocationID = jsonEntries.LocationID, 
		budgetItems.BudgetItemTypeID = jsonEntries.BudgetItemTypeID,
		budgetItems.Cost = jsonEntries.Cost,
		budgetItems.Quantity = jsonEntries.Quantity,
		budgetItems.PeopleCount = jsonEntries.PeopleCount,
		budgetItems.TimePeriodsCount = jsonEntries.TimePeriodsCount,
		budgetItems.ModifiedByAppUserID = @ModifiedByAppUserID,
		budgetItems.ModifiedDate = GETUTCDATE()
	FROM
		budgets.BudgetItems AS budgetItems 
		INNER JOIN
		(SELECT 
			j.BudgetItemID, 
			j.IsIncluded, 
			j.LocationID, 
			j.BudgetItemTypeID,
			j.Cost,
			j.Quantity,
			j.PeopleCount,
			j.TimePeriodsCount
		FROM OPENJSON(@BudgetItemsJson)
		WITH (BudgetItemID INT, IsIncluded BIT, LocationID BIGINT, BudgetItemTypeID INT, Cost MONEY, Quantity INT, PeopleCount INT, TimePeriodsCount DECIMAL(18, 2)) j) jsonEntries
		ON budgetItems.BudgetItemID = jsonEntries.BudgetItemID AND budgetItems.TrainingEventID = @TrainingEventID;

	INSERT INTO budgets.BudgetItems
			(
				TrainingEventID, IsIncluded, LocationID, BudgetItemTypeID, Cost, Quantity, PeopleCount, TimePeriodsCount, ModifiedByAppUserID
			)
		SELECT @TrainingEventID, j.IsIncluded, j.LocationID, j.BudgetItemTypeID, j.Cost, j.Quantity, j.PeopleCount, j.TimePeriodsCount, @ModifiedByAppUserID
		FROM OPENJSON(@BudgetItemsJson)
		WITH (BudgetItemID INT, IsIncluded BIT, LocationID BIGINT, BudgetItemTypeID INT, Cost MONEY, Quantity INT, PeopleCount INT, TimePeriodsCount DECIMAL(18, 2)) j
		WHERE j.BudgetItemID IS NULL;

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
	WHERE
		TrainingEventID = @TrainingEventID;
END
