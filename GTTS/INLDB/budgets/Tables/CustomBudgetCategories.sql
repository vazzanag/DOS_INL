/*
    **************************************************************************
    CustomBudgetCategories.sql
    **************************************************************************    
*/ 
CREATE TABLE [budgets].[CustomBudgetCategories]
(
	[CustomBudgetCategoryID] INT IDENTITY (1,1) NOT NULL,
	[TrainingEventID] BIGINT NOT NULL,
	[Name] NVARCHAR(50) NOT NULL,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT GETUTCDATE(),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),  
	CONSTRAINT [PK_CustomBudgetCategories] 
		PRIMARY KEY ([CustomBudgetCategoryID]),
	CONSTRAINT [FK_CustomBudgetCategories_TrainingEventID] 
		FOREIGN KEY ([TrainingEventID]) 
		REFERENCES [training].[TrainingEvents]([TrainingEventID]),	
	CONSTRAINT [FK_CustomBudgetCategories_AppUsers] 
		FOREIGN KEY ([ModifiedByAppUserID]) 
		REFERENCES [users].[AppUsers]([AppUserID]),	
	CONSTRAINT [UC_CustomBudgetCategories_TrainingEventID_Name] 
		UNIQUE ([TrainingEventID], [Name])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [budgets].[CustomBudgetCategories_History]))
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'budgets',
	@level1type = N'TABLE',  @level1name = N'CustomBudgetCategories',
	@value = N'Each budget item falls within a category. This table holds those categories manually entered by the user for the event.'
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'CustomBudgetCategories',
    @level2type = N'COLUMN', @level2name = N'CustomBudgetCategoryID',
	@value = N'Primary key & identity of the record in this table.'
GO

/*  Event column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'CustomBudgetCategories',
    @level2type = N'COLUMN', @level2name = N'TrainingEventID',
	@value = N'Identifies the event the custom budget category is for.'
GO

/*  Name column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'CustomBudgetCategories',
    @level2type = N'COLUMN', @level2name = N'Name',
	@value = N'Identifies the name of the category.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
    @level1type = N'TABLE',  @level1name = N'CustomBudgetCategories',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the users.AppUsers table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'budgets',
	@level1type = N'TABLE',  @level1name = N'CustomBudgetCategories',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'budgets',
	@level1type = N'TABLE',  @level1name = N'CustomBudgetCategories',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created. Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'budgets',
	@level1type = N'TABLE',  @level1name = N'CustomBudgetCategories',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated. Used to denote the end of the timeperiod for which the record is valid.'
GO 