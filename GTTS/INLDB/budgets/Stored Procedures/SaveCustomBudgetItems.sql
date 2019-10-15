CREATE PROCEDURE [budgets].[SaveCustomBudgetItems]
	@TrainingEventID BIGINT,
	@CustomBudgetItemsJson NVARCHAR(MAX),
	@ModifiedByAppUserID BIGINT
AS
BEGIN
	DELETE FROM budgets.CustomBudgetItems
	WHERE 
		CustomBudgetItemID NOT IN (SELECT j.CustomBudgetItemID FROM OPENJSON(@CustomBudgetItemsJson) WITH (CustomBudgetItemID INT) j);

	UPDATE 
		customBudgetItems
	SET
		customBudgetItems.IsIncluded = jsonEntries.IsIncluded, 
		customBudgetItems.TrainingEventID = jsonEntries.TrainingEventID,
		customBudgetItems.LocationID = jsonEntries.LocationID, 
		customBudgetItems.BudgetCategoryID = jsonEntries.BudgetCategoryID,
		customBudgetItems.CustomBudgetCategoryID = jsonEntries.CustomBudgetCategoryID,
		customBudgetItems.SupportsQuantity = jsonEntries.SupportsQuantity,
		customBudgetItems.SupportsPeopleCount = jsonEntries.SupportsPeopleCount,
		customBudgetItems.SupportsTimePeriodsCount = jsonEntries.SupportsTimePeriodsCount,
		customBudgetItems.[Name] = jsonEntries.[Name],
		customBudgetItems.Cost = jsonEntries.Cost,
		customBudgetItems.Quantity = jsonEntries.Quantity,
		customBudgetItems.PeopleCount = jsonEntries.PeopleCount,
		customBudgetItems.TimePeriodsCount = jsonEntries.TimePeriodsCount,
		customBudgetItems.ModifiedByAppUserID = @ModifiedByAppUserID,
		customBudgetItems.ModifiedDate = GETUTCDATE()
	FROM
		budgets.CustomBudgetItems AS customBudgetItems 
		INNER JOIN
		(SELECT 
			j.CustomBudgetItemID, 
			j.IsIncluded, 
			j.TrainingEventID,
			j.LocationID, 
			j.BudgetCategoryID,
			j.CustomBudgetCategoryID,
			j.SupportsQuantity,
			j.SupportsPeopleCount,
			j.SupportsTimePeriodsCount,
			j.[Name],
			j.Cost,
			j.Quantity,
			j.PeopleCount,
			j.TimePeriodsCount
		FROM OPENJSON(@CustomBudgetItemsJson)
		WITH (CustomBudgetItemID INT, IsIncluded BIT, TrainingEventID BIGINT, LocationID BIGINT, BudgetCategoryID INT, CustomBudgetCategoryID BIGINT, SupportsQuantity BIT, SupportsPeopleCount BIT, SupportsTimePeriodsCount BIT, [Name] NVARCHAR(50), Cost MONEY, Quantity INT, PeopleCount INT, TimePeriodsCount DECIMAL(18, 2)) j) jsonEntries
		ON customBudgetItems.CustomBudgetItemID = jsonEntries.CustomBudgetItemID;

	INSERT INTO budgets.CustomBudgetItems
			(
				TrainingEventID, IsIncluded, LocationID, BudgetCategoryID, CustomBudgetCategoryID, SupportsQuantity, SupportsPeopleCount, SupportsTimePeriodsCount, [Name], Cost, Quantity, PeopleCount, TimePeriodsCount, ModifiedByAppUserID
			)
		SELECT j.TrainingEventID, j.IsIncluded, j.LocationID, j.BudgetCategoryID, j.CustomBudgetCategoryID, j.SupportsQuantity, j.SupportsPeopleCount, j.SupportsTimePeriodsCount, j.[Name], j.Cost, j.Quantity, j.PeopleCount, j.TimePeriodsCount, @ModifiedByAppUserID
		FROM OPENJSON(@CustomBudgetItemsJson)
		WITH (CustomBudgetItemID INT, TrainingEventID BIGINT, IsIncluded BIT, LocationID BIGINT, BudgetCategoryID INT, CustomBudgetCategoryID BIGINT, SupportsQuantity BIT, SupportsPeopleCount BIT, SupportsTimePeriodsCount BIT, [Name] NVARCHAR(50), Cost MONEY, Quantity INT, PeopleCount INT, TimePeriodsCount DECIMAL(18, 2)) j
		WHERE j.CustomBudgetItemID IS NULL;

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
	WHERE
		TrainingEventID = @TrainingEventID;
END
