CREATE TABLE [migration].[OnboardingBusinessUnitsList]
(
    [BusinessUnitName] NVARCHAR(255) NULL, 
	[Acronym] NVARCHAR(255) NULL,
    [HasDutyToInform] NVARCHAR(255) NULL,
    [CourtesyVettingUnit] NVARCHAR(255) NULL
)
ON [PRIMARY]
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'migration',
	@level1type = N'TABLE',  @level1name = N'OnboardingBusinessUnitsList',
    @value = N'Used as an intermediate table to hold GTTS Business Units that need to be imported as part of the Onboarding Process.'
GO