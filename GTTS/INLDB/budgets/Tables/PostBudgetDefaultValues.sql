/*
    **************************************************************************
    PostBudgetDefaultValues.sql
    **************************************************************************    
*/ 
CREATE TABLE [budgets].[PostBudgetDefaultValues]
(
	[PostDefaultValueID] INT IDENTITY (1,1) NOT NULL,
	[PostID] INT NOT NULL,
    [BudgetItemTypeID] INT NOT NULL,
    [DefaultCost] MONEY NOT NULL,
	[IsActive] BIT NOT NULL DEFAULT 1,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT getutcdate(),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),  
	CONSTRAINT [PK_PostBudgetDefaultValues] 
		PRIMARY KEY ([PostDefaultValueID]),      
	CONSTRAINT [FK_PostBudgetDefaultValues_Posts] 
		FOREIGN KEY ([PostID]) 
		REFERENCES [location].[Posts]([PostID]),	
    CONSTRAINT [FK_PostBudgetDefaultValues_BudgetItemTypes] 
		FOREIGN KEY ([BudgetItemTypeID]) 
		REFERENCES [budgets].[BudgetItemTypes]([BudgetItemTypeID]),	    
    CONSTRAINT [FK_PostBudgetDefaultValues_AppUsers] 
		FOREIGN KEY ([ModifiedByAppUserID]) 
		REFERENCES [users].[AppUsers]([AppUserID]),	
	CONSTRAINT [UC_PostID_BudgetItemTypeID] 
		UNIQUE ([PostID], [BudgetItemTypeID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [budgets].[PostBudgetDefaultValues_History]))
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'budgets',
	@level1type = N'TABLE',  @level1name = N'PostBudgetDefaultValues',
	@value = N'Each Post can have it''s own set of default costs the global budget item types.'
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'PostBudgetDefaultValues',
    @level2type = N'COLUMN', @level2name = N'PostDefaultValueID',
	@value = N'Primary key & identity of the record in this table.'
GO

/*  PostID column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'PostBudgetDefaultValues',
    @level2type = N'COLUMN', @level2name = N'PostID',
	@value = N'Identifies the Post that this default cost value is associated to.  Foreign key pointing to the location.Posts table.'
GO

/*  BudgetItemTypeID column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'PostBudgetDefaultValues',
    @level2type = N'COLUMN', @level2name = N'BudgetItemTypeID',
	@value = N'Identifies the Budget Item Type that this default cost value is associated to.  Foreign key pointing to the budgets.BudgetItemType table.'
GO

/*  DefaultCost column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'PostBudgetDefaultValues',
    @level2type = N'COLUMN', @level2name = N'DefaultCost',
	@value = N'Identifies the Post specific default cost value.'
GO

/*  IsActive column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'budgets',
	@level1type = N'TABLE',  @level1name = N'PostBudgetDefaultValues',
	@level2type = N'COLUMN', @level2name = N'IsActive',
	@value = N'Identifies if this record should be active or not.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'PostBudgetDefaultValues',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the users.AppUsers table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'budgets',
	@level1type = N'TABLE',  @level1name = N'PostBudgetDefaultValues',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'budgets',
	@level1type = N'TABLE',  @level1name = N'PostBudgetDefaultValues',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
	@level1type = N'TABLE',  @level1name = N'PostBudgetDefaultValues',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod for which the record is valid.'
GO 