/*
    **************************************************************************
    BudgetCategories_Load.sql
    **************************************************************************    
*/
/*  Turn IDENTITY_INSERT ON    */
SET IDENTITY_INSERT [budgets].[BudgetCategories] ON
GO

IF (NOT EXISTS(SELECT * FROM [budgets].[BudgetCategories]))
	BEGIN
		/*  INSERT VALUES into the table    */
		INSERT INTO [budgets].[BudgetCategories]
				([BudgetCategoryID]
				,[Name]
				,[IsActive]         -- DEFAULT TRUE (1)
				,[ModifiedByAppUserID])
			VALUES
				(1, 'Air Transportation', 1, 1),               
				(2, 'Ground Transportation', 1, 1),  
				(3, 'Lodging', 1, 1),  
				(4, 'M&IE', 1, 1),
				(5, 'Insurance', 1, 1),
				(6, 'Conference Rooms', 1, 1),
				(7, 'Equipment', 1, 1),
				(8, 'Meals & Refreshments', 1, 1),
				(9, 'Interpretation Services', 1, 1),
				(10, 'Event Registration', 1, 1),
				(11, 'Training Supplies', 1, 1),
				(12, 'Special Services / Other', 1, 1)
	END
GO

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [budgets].[BudgetCategories] OFF
GO

/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('[budgets].[BudgetCategories]', RESEED)
GO