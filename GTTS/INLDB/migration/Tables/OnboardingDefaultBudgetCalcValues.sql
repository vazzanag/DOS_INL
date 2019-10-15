CREATE TABLE [migration].[OnboardingDefaultBudgetCalcValues]
(
    [CategoryName] NVARCHAR(255) NULL, 
	[ItemType] NVARCHAR(255) NULL,
	[CostConfigurable] NVARCHAR(255) NULL,
	[Quantity] NVARCHAR(255) NULL,
	[People] NVARCHAR(255) NULL,
	[TimePeriod] NVARCHAR(255) NULL,
    [DefaultValue] MONEY NULL
)
ON [PRIMARY]
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'migration',
	@level1type = N'TABLE',  @level1name = N'OnboardingDefaultBudgetCalcValues',
    @value = N'Used as an intermediate table to hold GTTS OnboardingDefaultBudgetCalcValues that need to be imported as part of the Onboarding Process.'
GO