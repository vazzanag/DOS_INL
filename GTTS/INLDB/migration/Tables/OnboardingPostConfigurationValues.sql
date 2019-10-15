CREATE TABLE [migration].[OnboardingPostConfigurationValues]
(
	[CourtesyNameCheckTime] INT NULL,
	[CourtesyVettingTime] INT NULL,
	[CourtesyBatchExpirationInterval] INT NULL,
	[LeahyVettingTime] INT NULL,
	[LeahyBatchExpirationInterval] INT NULL,
	[VettingBatchSize] INT NULL,
	[CloseOutNotificiationsTime] INT NULL,
	[POL_POC_Email] NVARCHAR(255) NULL
)
ON [PRIMARY]
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'migration',
	@level1type = N'TABLE',  @level1name = N'OnboardingPostConfigurationValues',
    @value = N'Used as an intermediate table to hold GTTS Post Configuration Values that need to be imported as part of the Onboarding Process.'
GO