CREATE TABLE [location].[GeoRegions]
(
	[GeoRegionID] INT IDENTITY (1, 1) NOT NULL,
    [Name] NVARCHAR(100) NOT NULL, 
	[Description] NVARCHAR(255) NULL,
	[IsActive] BIT NOT NULL DEFAULT 1,
	[ModifiedByAppUserID] INT NOT NULL,
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),
    CONSTRAINT [PK_GeoRegions] 
		PRIMARY KEY ([GeoRegionID]), 
    CONSTRAINT [FK_GeoRegions_AppUsers_ModifiedByAppUserID] 
		FOREIGN KEY ([ModifiedByAppUserID]) 
		REFERENCES [users].[AppUsers]([AppUserID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [location].[GeoRegions_History]))
GO

CREATE INDEX [IDX_Code] ON [location].[GeoRegions] ([Name] ASC)
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

EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level1type = N'TABLE', 
	@level0name = N'location', @level1name = N'GeoRegions',
	@value = N'Reference table for Geographic Regions.  Data Source is Dept. of State''s Master Reference Data (MRD) Geographic Regions Dataset.';
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'GeoRegions',
    @level2type = N'COLUMN', @level2name = N'GeoRegionID',
	@value = N'Primary key & identity of the record in this table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'GeoRegions',
    @level2type = N'COLUMN', @level2name = N'Name',
	@value = N'Name or code identifying the geographic region.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'GeoRegions',
    @level2type = N'COLUMN', @level2name = N'Description',
	@value = N'Extended description of the geographic region code.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'GeoRegions',
    @level2type = N'COLUMN', @level2name = N'IsActive',
	@value = N'Boolean value that indicates if the record is currently active and in use.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'location',
	@level1type = N'TABLE',  @level1name = N'GeoRegions',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the Users table.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'location',
	@level1type = N'TABLE',  @level1name = N'GeoRegions',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
	@level1type = N'TABLE',  @level1name = N'GeoRegions',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO