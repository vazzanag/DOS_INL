/*
    **************************************************************************
    BudgetItems.sql
    **************************************************************************    
*/ 
CREATE TABLE [budgets].[BudgetItems]
(
	[BudgetItemID] INT IDENTITY (1,1) NOT NULL,
	[TrainingEventID] BIGINT NOT NULL,
	[IsIncluded] BIT NOT NULL DEFAULT 0,
	[LocationID] BIGINT NULL,
	[BudgetItemTypeID] INT NOT NULL,
	[Cost] MONEY NOT NULL DEFAULT 0,
	[Quantity] INT NULL,
	[PeopleCount] INT NULL,
	[TimePeriodsCount] DECIMAL(18, 2) NULL,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT GETUTCDATE(),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),  
	CONSTRAINT [PK_BudgetItems] 
		PRIMARY KEY ([BudgetItemID]),
	CONSTRAINT [FK_BudgetItems_TrainingEventID] 
		FOREIGN KEY ([TrainingEventID]) 
		REFERENCES [training].[TrainingEvents]([TrainingEventID]),	
	CONSTRAINT [FK_BudgetItems_LocationID] 
		FOREIGN KEY ([LocationID]) 
		REFERENCES [location].[Locations]([LocationID]),
	CONSTRAINT [FK_BudgetItems_AppUsers] 
		FOREIGN KEY ([ModifiedByAppUserID]) 
		REFERENCES [users].[AppUsers]([AppUserID]),	
	CONSTRAINT [UC_BudgetItems_TrainingEventItemType] 
		UNIQUE ([TrainingEventID], [LocationID], [BudgetItemTypeID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [budgets].[BudgetItems_History]))
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'budgets',
	@level1type = N'TABLE',  @level1name = N'BudgetItems',
	@value = N'This table holds the out-of-the-box budget items for the event.'
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'BudgetItems',
    @level2type = N'COLUMN', @level2name = N'BudgetItemID',
	@value = N'Primary key & identity of the record in this table.'
GO

/*  Event column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'BudgetItems',
    @level2type = N'COLUMN', @level2name = N'TrainingEventID',
	@value = N'Identifies the event the budget item is for.'
GO

/*  IsIncluded column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'BudgetItems',
    @level2type = N'COLUMN', @level2name = N'IsIncluded',
	@value = N'Identifies whether the item should be included in the total costs for the training event.'
GO

/*  City column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'BudgetItems',
    @level2type = N'COLUMN', @level2name = N'LocationID',
	@value = N'Identifies the location the budget item relates to. Can be NULL for single-city events.'
GO

/*  BudgetItemTypeID column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'BudgetItems',
    @level2type = N'COLUMN', @level2name = N'BudgetItemTypeID',
	@value = N'Identifies the type of budget item this is.'
GO

/*  Cost column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'BudgetItems',
    @level2type = N'COLUMN', @level2name = N'Cost',
	@value = N'The cost of this budget item.'
GO

/*  Quantity column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'BudgetItems',
    @level2type = N'COLUMN', @level2name = N'Quantity',
	@value = N'The quantity of this budget item. Must NOT be null if the item type supports the quantity field.'
GO

/*  PeopleCount column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'BudgetItems',
    @level2type = N'COLUMN', @level2name = N'PeopleCount',
	@value = N'The quantity of people in this budget item. Must NOT be NULL if the item type supports the Pax field.'
GO

/*  TimePeriodsCount column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'BudgetItems',
    @level2type = N'COLUMN', @level2name = N'TimePeriodsCount',
	@value = N'The quantity of days / nights of this budget item. Must NOT be NULL if the item type supports the field.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'BudgetItems',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the users.AppUsers table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'budgets',
	@level1type = N'TABLE',  @level1name = N'BudgetItems',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'budgets',
	@level1type = N'TABLE',  @level1name = N'BudgetItems',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created. Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
	@level1type = N'TABLE',  @level1name = N'BudgetItems',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated. Used to denote the end of the timeperiod for which the record is valid.'
GO 