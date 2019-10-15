CREATE TABLE [migration].[OnboardingVettingAuthorizingLawsList]
(
    [VettingAuthorizingLaw] NVARCHAR(255) NULL
)
ON [PRIMARY]
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'migration',
	@level1type = N'TABLE',  @level1name = N'OnboardingVettingAuthorizingLawsList',
    @value = N'Used as an intermediate table to hold GTTS Vetting Authorizing Laws that need to be imported as part of the Onboarding Process.'
GO