/*
    **************************************************************************
    BudgetItemTypes.sql
    **************************************************************************    
*/ 
CREATE TABLE [budgets].[BudgetItemTypes]
(
	[BudgetItemTypeID] INT IDENTITY (1,1) NOT NULL,
	[BudgetCategoryID] INT NOT NULL,
	[DefaultCost] MONEY NOT NULL,
	[IsCostConfigurable] BIT NOT NULL DEFAULT 1,
	[SupportsQuantity] BIT NOT NULL DEFAULT 1,
	[SupportsPeopleCount] BIT NOT NULL DEFAULT 1,
	[SupportsTimePeriodsCount] BIT NOT NULL DEFAULT 1,
	[Name] NVARCHAR(50) NOT NULL,
	[IsActive] BIT NOT NULL DEFAULT 1,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT GETUTCDATE(),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),  
	CONSTRAINT [PK_BudgetItemTypes] 
		PRIMARY KEY ([BudgetItemTypeID]),
	CONSTRAINT [FK_BudgetItemTypes_Categories] 
		FOREIGN KEY ([BudgetCategoryID]) 
		REFERENCES [budgets].[BudgetCategories]([BudgetCategoryID]),	
	CONSTRAINT [FK_BudgetItemTypes_AppUsers] 
		FOREIGN KEY ([ModifiedByAppUserID]) 
		REFERENCES [users].[AppUsers]([AppUserID]),	
	CONSTRAINT [UC_BudgetItemTypes_CategoryName] 
		UNIQUE ([BudgetCategoryID], [Name])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [budgets].[BudgetItemTypes_History]))
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'budgets',
	@level1type = N'TABLE',  @level1name = N'BudgetItemTypes',
	@value = N'Each budget item falls within a type. This table holds lookup values for those budget item types.'
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'BudgetItemTypes',
    @level2type = N'COLUMN', @level2name = N'BudgetItemTypeID',
	@value = N'Primary key & identity of the record in this table.'
GO

/*  Category column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'BudgetItemTypes',
    @level2type = N'COLUMN', @level2name = N'BudgetCategoryID',
	@value = N'Identifies the category the budget item type falls under.'
GO

/*  DefaultCost column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'BudgetItemTypes',
    @level2type = N'COLUMN', @level2name = N'DefaultCost',
	@value = N'Identifies the default cost the budget item type has.'
GO

/*  IsCostConfigurable column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'BudgetItemTypes',
    @level2type = N'COLUMN', @level2name = N'IsCostConfigurable',
	@value = N'Identifies whether the cost of the budget item can be modified by the user in the calculator.'
GO

/*  SupportsQuantity column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'BudgetItemTypes',
    @level2type = N'COLUMN', @level2name = N'SupportsQuantity',
	@value = N'Identifies whether this budget item type supports the quantity field.'
GO

/*  SupportsPeopleCount column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'BudgetItemTypes',
    @level2type = N'COLUMN', @level2name = N'SupportsPeopleCount',
	@value = N'Identifies whether this budget item type supports the Pax field.'
GO

/*  SupportsTimePeriodsCount column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'BudgetItemTypes',
    @level2type = N'COLUMN', @level2name = N'SupportsTimePeriodsCount',
	@value = N'Identifies whether this budget item type supports the number of days / nights field.'
GO

/*  Name column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'BudgetItemTypes',
    @level2type = N'COLUMN', @level2name = N'Name',
	@value = N'Identifies the name of the budget type.'
GO

/*  IsActive column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'budgets',
	@level1type = N'TABLE',  @level1name = N'BudgetItemTypes',
	@level2type = N'COLUMN', @level2name = N'IsActive',
	@value = N'Identifies if this record should be active or not.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'BudgetItemTypes',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the users.AppUsers table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'budgets',
	@level1type = N'TABLE',  @level1name = N'BudgetItemTypes',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'budgets',
	@level1type = N'TABLE',  @level1name = N'BudgetItemTypes',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
	@level1type = N'TABLE',  @level1name = N'BudgetItemTypes',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod for which the record is valid.'
GO 