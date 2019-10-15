﻿CREATE TABLE [vetting].[VettingFundingSources]
(
	[VettingFundingSourceID] SMALLINT NOT NULL IDENTITY(1,1), 
    [Code] NVARCHAR(25) NOT NULL, 
    [Description] NVARCHAR(255) NOT NULL,
	[IsActive] bit NOT NULL DEFAULT 1,
	[ModifiedByAppUserID] [int] NOT NULL,
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),
    CONSTRAINT [PK_VettingFundingSources] 
        PRIMARY KEY CLUSTERED ([VettingFundingSourceID] ASC)
            WITH (PAD_INDEX = OFF
                  ,STATISTICS_NORECOMPUTE = OFF
                  ,IGNORE_DUP_KEY = OFF
                  ,ALLOW_ROW_LOCKS = ON
				  ,ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
	CONSTRAINT [FK_VettingFundingSources_AppUsers] 
        FOREIGN KEY ([ModifiedByAppUserID]) 
        REFERENCES [users].[AppUsers]([AppUserID]),
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [vetting].[VettingFundingSources_History]))
GO

CREATE INDEX [IDX_Code] ON [vetting].[VettingFundingSources] ([Code] ASC)
	WITH (
			PAD_INDEX = OFF
			,STATISTICS_NORECOMPUTE = OFF
			,SORT_IN_TEMPDB = OFF
			,DROP_EXISTING = OFF
			,ONLINE = OFF
			,ALLOW_ROW_LOCKS = ON
			,ALLOW_PAGE_LOCKS = ON
			) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @value = N'Reference table for Funding Source Code Lookup',
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'VettingFundingSources'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Primary key & identity of the record in this table.',
    @level0type = N'SCHEMA',  @level0name = N'vetting',
    @level1type = N'TABLE',   @level1name = N'VettingFundingSources',
    @level2type = N'COLUMN',  @level2name = N'VettingFundingSourceID'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Short format common identification or reference code.',
    @level0type = N'SCHEMA',  @level0name = N'vetting',
    @level1type = N'TABLE',   @level1name = N'VettingFundingSources',
    @level2type = N'COLUMN',  @level2name = N'Code'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Description explaining what the code means or identifies.',
    @level0type = N'SCHEMA',  @level0name = N'vetting',
    @level1type = N'TABLE',   @level1name = N'VettingFundingSources',
    @level2type = N'COLUMN',  @level2name = N'Description'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Boolean value that indicates if the record is currently active and in use.',
    @level0type = N'SCHEMA',  @level0name = N'vetting',
    @level1type = N'TABLE',   @level1name = N'VettingFundingSources',
    @level2type = N'COLUMN',  @level2name = N'IsActive'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the Users table.',
    @level0type = N'SCHEMA',  @level0name = N'vetting',
    @level1type = N'TABLE',   @level1name = N'VettingFundingSources',
	@level2type = N'COLUMN',  @level2name = N'ModifiedByAppUserID'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod fow which the record is valid.',
    @level0type = N'SCHEMA',  @level0name = N'vetting',
    @level1type = N'TABLE',   @level1name = N'VettingFundingSources',
	@level2type = N'COLUMN',  @level2name = N'SysStartTime'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.',
    @level0type = N'SCHEMA',  @level0name = N'vetting',
    @level1type = N'TABLE',   @level1name = N'VettingFundingSources',
	@level2type = N'COLUMN',  @level2name = N'SysEndTime'
GO