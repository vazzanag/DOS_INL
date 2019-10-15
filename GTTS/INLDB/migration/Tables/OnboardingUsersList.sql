CREATE TABLE [migration].[OnboardingUsersList]
(
    [FirstName] NVARCHAR(255) NULL, 
	[LastName] NVARCHAR(255) NULL, 
    [EmailAddress] NVARCHAR(255) NULL, 
    [BusinessUnit] NVARCHAR(255) NULL, 			 
    [Role] NVARCHAR(255) NULL
)
ON [PRIMARY]
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'migration',
	@level1type = N'TABLE',  @level1name = N'OnboardingUsersList',
    @value = N'Used as an intermediate table to hold GTTS Users that need to be imported as part of the Onboarding Process.'
GO