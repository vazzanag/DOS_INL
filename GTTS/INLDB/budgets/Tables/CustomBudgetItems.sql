/*
    **************************************************************************
    CustomBudgetItems.sql
    **************************************************************************    
*/ 
CREATE TABLE [budgets].[CustomBudgetItems]
(
	[CustomBudgetItemID] INT IDENTITY (1,1) NOT NULL,
	[TrainingEventID] BIGINT NULL,
	[IsIncluded] BIT NOT NULL DEFAULT 0,
	[LocationID] BIGINT NULL,
	[BudgetCategoryID] INT NULL,
	[CustomBudgetCategoryID] INT NULL,
	[SupportsQuantity] BIT NOT NULL DEFAULT 1,
	[SupportsPeopleCount] BIT NOT NULL DEFAULT 1,
	[SupportsTimePeriodsCount] BIT NOT NULL DEFAULT 1,
	[Name] NVARCHAR(50) NOT NULL,
	[Cost] MONEY NOT NULL DEFAULT 0,
	[Quantity] INT NULL,
	[PeopleCount] INT NULL,
	[TimePeriodsCount] DECIMAL(18, 2) NULL,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT GETUTCDATE(),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),  
	CONSTRAINT [PK_CustomBudgetItems] 
		PRIMARY KEY ([CustomBudgetItemID]),
	CONSTRAINT [FK_CustomBudgetItems_TrainingEventID] 
		FOREIGN KEY ([TrainingEventID]) 
		REFERENCES [training].[TrainingEvents]([TrainingEventID]),	
	CONSTRAINT [FK_CustomBudgetItems_LocationID] 
		FOREIGN KEY ([LocationID]) 
		REFERENCES [location].[Locations]([LocationID]),
	CONSTRAINT [FK_CustomBudgetItems_Categories] 
		FOREIGN KEY ([BudgetCategoryID]) 
		REFERENCES [budgets].[BudgetCategories]([BudgetCategoryID]),
	CONSTRAINT [FK_CustomBudgetItems_CustomCategories] 
		FOREIGN KEY ([CustomBudgetCategoryID]) 
		REFERENCES [budgets].[CustomBudgetCategories]([CustomBudgetCategoryID]) ON DELETE CASCADE,
	CONSTRAINT [FK_CustomBudgetItems_AppUsers] 
		FOREIGN KEY ([ModifiedByAppUserID]) 
		REFERENCES [users].[AppUsers]([AppUserID]),	
	CONSTRAINT [UC_CustomBudgetItems_TrainingEventCityCategoriesName] 
		UNIQUE ([TrainingEventID], [LocationID], [BudgetCategoryID], [CustomBudgetCategoryID], [Name]),
	CONSTRAINT [CK_CustomBudgetItems_TrainingEventOTBCategory]
		CHECK ((TrainingEventID IS NULL AND BudgetCategoryID IS NULL) OR (TrainingEventID IS NOT NULL AND BudgetCategoryID IS NOT NULL)),
	CONSTRAINT [CK_CustomBudgetItems_OTBCategoryCustomCategory]
		CHECK ((BudgetCategoryID IS NULL AND CustomBudgetCategoryID IS NOT NULL) OR (BudgetCategoryID IS NOT NULL AND CustomBudgetCategoryID IS NULL)),
	CONSTRAINT [CK_CustomBudgetItems_Quantity]
		CHECK (SupportsQuantity = 0 OR Quantity IS NOT NULL),
	CONSTRAINT [CK_CustomBudgetItems_PeopleCount]
		CHECK (SupportsPeopleCount = 0 OR PeopleCount IS NOT NULL),
	CONSTRAINT [CK_CustomBudgetItems_TimePeriodCounts]
		CHECK (SupportsTimePeriodsCount = 0 OR TimePeriodsCount IS NOT NULL)
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [budgets].[CustomBudgetItems_History]))
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'budgets',
	@level1type = N'TABLE',  @level1name = N'CustomBudgetItems',
	@value = N'This table holds the custom budget items for the event.'
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'CustomBudgetItems',
    @level2type = N'COLUMN', @level2name = N'CustomBudgetItemID',
	@value = N'Primary key & identity of the record in this table.'
GO

/*  Event column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'CustomBudgetItems',
    @level2type = N'COLUMN', @level2name = N'TrainingEventID',
	@value = N'Identifies the event the custom budget item is for. Must NOT be NULL if CustomBudgetCategoryID IS NULL.'
GO

/*  IsIncluded column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'CustomBudgetItems',
    @level2type = N'COLUMN', @level2name = N'IsIncluded',
	@value = N'Identifies whether the item should be included in the total costs for the training event.'
GO

/*  City column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'CustomBudgetItems',
    @level2type = N'COLUMN', @level2name = N'LocationID',
	@value = N'Identifies the location the custom budget item relates to. Can be NULL for single-city events.'
GO

/*  BudgetCategoryID column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'CustomBudgetItems',
    @level2type = N'COLUMN', @level2name = N'BudgetCategoryID',
	@value = N'Identifies the out-of-the-box category of this budget item. Must NOT be NULL if CustomBudgetCategoryID is NULL.'
GO

/*  CustomBudgetCategoryID column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'CustomBudgetItems',
    @level2type = N'COLUMN', @level2name = N'CustomBudgetCategoryID',
	@value = N'Identifies the custom category of this budget item. Must NOT be NULL if BudgetCategoryID is NULL.'
GO

/*  SupportsQuantity column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'CustomBudgetItems',
    @level2type = N'COLUMN', @level2name = N'SupportsQuantity',
	@value = N'Identifies whether this custom budget item supports the quantity field.'
GO

/*  SupportsPeopleCount column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'CustomBudgetItems',
    @level2type = N'COLUMN', @level2name = N'SupportsPeopleCount',
	@value = N'Identifies whether this custom budget item supports the Pax field.'
GO

/*  SupportsTimePeriodsCount column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'CustomBudgetItems',
    @level2type = N'COLUMN', @level2name = N'SupportsTimePeriodsCount',
	@value = N'Identifies whether this custom budget item supports the number of days / nights field.'
GO

/*  Name column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'CustomBudgetItems',
    @level2type = N'COLUMN', @level2name = N'Name',
	@value = N'Identifies the name of the custom budget item.'
GO

/*  Cost column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'CustomBudgetItems',
    @level2type = N'COLUMN', @level2name = N'Cost',
	@value = N'The cost of this custom budget item.'
GO

/*  Quantity column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'CustomBudgetItems',
    @level2type = N'COLUMN', @level2name = N'Quantity',
	@value = N'The quantity of this custom budget item. Must NOT be NULL if the item upports the quantity field.'
GO

/*  PeopleCount column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'CustomBudgetItems',
    @level2type = N'COLUMN', @level2name = N'PeopleCount',
	@value = N'The quantity of people in this custom budget item. Must NOT be NULL if the item supports the Pax field.'
GO

/*  TimePeriodsCount column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'CustomBudgetItems',
    @level2type = N'COLUMN', @level2name = N'TimePeriodsCount',
	@value = N'The quantity of days / nights of this custom budget item. Must NOT be NULL if the item supports the field.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'CustomBudgetItems',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record. Foreign key pointing to the users.AppUsers table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'budgets',
	@level1type = N'TABLE',  @level1name = N'CustomBudgetItems',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'budgets',
	@level1type = N'TABLE',  @level1name = N'CustomBudgetItems',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created. Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
	@level1type = N'TABLE',  @level1name = N'CustomBudgetItems',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated. Used to denote the end of the timeperiod for which the record is valid.'
GO 