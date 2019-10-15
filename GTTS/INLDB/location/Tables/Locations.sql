CREATE TABLE [location].[Locations]
(
	[LocationID] BIGINT IDENTITY (1, 1) NOT NULL,
    [LocationName] NVARCHAR(200) NULL, 
	[AddressLine1] NVARCHAR(200) NULL,
	[AddressLine2] NVARCHAR(200) NULL,
	[AddressLine3] NVARCHAR(200) NULL,
    [CityID] INT NOT NULL, 
    [Latitude] NVARCHAR(100) NULL,  
    [Longitude] NVARCHAR(100) NULL, 
    [IsActive] BIT NOT NULL DEFAULT 1, 
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (sysutcdatetime()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),
    CONSTRAINT [PK_Locations]
        PRIMARY KEY ([LocationID]), 
    CONSTRAINT [FK_Locations_Cities] 
        FOREIGN KEY ([CityID]) 
        REFERENCES [location].[Cities]([CityID]),
    CONSTRAINT [FK_Locations_AppUsers_ModifiedByAppUserID] 
        FOREIGN KEY ([ModifiedByAppUserID]) 
        REFERENCES [users].[AppUsers]([AppUserID]),
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [location].[Locations_History]))
GO

CREATE INDEX [IDX_LocationName] ON [location].[Locations] ([LocationName] ASC)
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

CREATE INDEX [IDX_CityID] ON [location].[Locations] ([CityID] ASC)
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

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level1type = N'TABLE', 
	@level0name = N'location', @level1name = N'Locations',
	@value = N'Data table of different training event locations within a country.';
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'Locations',
    @level2type = N'COLUMN', @level2name = N'LocationID',
	@value = N'Primary key & identity of the record in this table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'Locations',
    @level2type = N'COLUMN', @level2name = N'LocationName',
	@value = N'A reference name for the location.  Can be used as a name for easy searching of often used locations.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'Locations',
    @level2type = N'COLUMN', @level2name = N'AddressLine1',
	@value = N'The 1st line of the location''s street address.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'Locations',
    @level2type = N'COLUMN', @level2name = N'AddressLine2',
	@value = N'The 2nd line of the location''s street address.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'Locations',
    @level2type = N'COLUMN', @level2name = N'AddressLine3',
	@value = N'The 3rd line of the location''s street address.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'Locations',
    @level2type = N'COLUMN', @level2name = N'CityID',
	@value = N'Identifies the city that the location belongs to.  Foreign key pointing to the Cities table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'Locations',
    @level2type = N'COLUMN', @level2name = N'Latitude',
	@value = N'The latitude coordinate of the location.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'Locations',
    @level2type = N'COLUMN', @level2name = N'Longitude',
	@value = N'The logitude coordinate of the location.'
GO

/*  IsActive column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'Locations',
    @level2type = N'COLUMN', @level2name = N'IsActive',
	@value = N'Boolean value that indicates if the record is currently active and in use.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'location',
	@level1type = N'TABLE',  @level1name = N'Locations',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the Users table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'location',
	@level1type = N'TABLE',  @level1name = N'Locations',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'location',
	@level1type = N'TABLE',  @level1name = N'Locations',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
	@level1type = N'TABLE',  @level1name = N'Locations',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO
