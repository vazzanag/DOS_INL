CREATE TABLE [migration].[OnboardingExternalLocations]
(
    [CountryName] NVARCHAR(255) NULL, 
	[StateName] NVARCHAR(255) NULL,
    [CityName] NVARCHAR(255) NULL 
)
ON [PRIMARY]
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'migration',
	@level1type = N'TABLE',  @level1name = N'OnboardingExternalLocations',
    @value = N'Used as an intermediate table to hold any External Countries, States, & Cities that need to be imported as part of the Onboarding Process.'
GO