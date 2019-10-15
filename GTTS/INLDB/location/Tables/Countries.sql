CREATE TABLE [location].[Countries]
(
	[CountryID] INT IDENTITY(1,1) NOT NULL,  
	[CountryName] NVARCHAR(75) NOT NULL,
	[CountryFullName] NVARCHAR(255) NOT NULL,
	[GENCCodeA2] NCHAR(2) NULL ,
    [GENCCodeA3] NCHAR(3) NULL , 
    [GENCCodeNumber] INT NULL , 
	[INKCode] NVARCHAR(15) NULL,
    [CountryIndicator] BIT NULL DEFAULT 1, 
    [DOSBureauID] INT NULL , 
	[CurrencyName] NVARCHAR(50) NULL, 
    [CurrencyCodeA3] NCHAR(3) NULL, 
    [CurrencyCodeNumber] INT NULL, 
    [CurrencySymbol] NVARCHAR(10) NULL , 
	[NameFormatID] SMALLINT NULL,
	[NationalIDFormatID] SMALLINT NULL,
	[IsActive] BIT NOT NULL DEFAULT 1,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),
    CONSTRAINT [PK_Countries]
		PRIMARY KEY ([CountryID]), 
    CONSTRAINT [FK_Countries_DOSBureaus] 
		FOREIGN KEY ([DOSBureauID]) 
		REFERENCES [location].[DOSBureaus]([DOSBureauID]),
    CONSTRAINT [FK_Countries_NameFormat] 
		FOREIGN KEY ([NameFormatID]) 
		REFERENCES [location].[NameFormats]([NameFormatID]),
    CONSTRAINT [FK_Countries_NationalIDFormat] 
		FOREIGN KEY ([NationalIDFormatID]) 
		REFERENCES [location].[NationalIDFormats]([NationalIDFormatID]),
    CONSTRAINT [FK_Countries_AppUsers_ModifiedByAppUserID] 
		FOREIGN KEY ([ModifiedByAppUserID]) 
		REFERENCES [users].[AppUsers]([AppUserID]),
	CONSTRAINT [UC_Countries1]
		UNIQUE ([CountryName], [IsActive]),
    CONSTRAINT [UC_Countries2] 
		UNIQUE ([GENCCodeA3], [IsActive]),
    CONSTRAINT [UC_Countries3] 
		UNIQUE ([CountryName], [GENCCodeA3])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [location].[Countries_History]))
GO

/* INDEXES HERE */
CREATE INDEX [IDX_CountryName] ON [location].[Countries] ([CountryName] ASC)
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

CREATE INDEX [IDX_GENCCodeA2] ON [location].[Countries] ([GENCCodeA2] ASC)
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

CREATE INDEX [IDX_GENCCodeA3] ON [location].[Countries] ([GENCCodeA3] ASC)
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

CREATE INDEX [IDX_GENCCodeNumber] ON [location].[Countries] ([GENCCodeNumber] ASC)
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

CREATE INDEX [IDX_INKCode] ON [location].[Countries] ([INKCode] ASC)
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
	@level0name = N'location', @level1name = N'Countries',
	@value = N'Reference table for Countries.  Data Source is Dept. of State''s Master Reference Data (MRD) Countries Dataset.';
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'Countries',
    @level2type = N'COLUMN', @level2name = N'CountryID',
	@value = N'Primary key & identity of the record in this table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'Countries',
    @level2type = N'COLUMN', @level2name = N'CountryName',
	@value = N'Short name identifying the country.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'Countries',
    @level2type = N'COLUMN', @level2name = N'CountryFullName',
	@value = N'Extended formal name of the country'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'Countries',
    @level2type = N'COLUMN', @level2name = N'GENCCodeA2',
	@value = N'2-character alphabetic country or Area Code in GENC 2 format.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'Countries',
    @level2type = N'COLUMN', @level2name = N'GENCCodeA3',
	@value = N'3-character alphabetic country or Area Code in GENC 3 format.  Also known as abbreviation.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'Countries',
    @level2type = N'COLUMN', @level2name = 'GENCCodeNumber',
	@value = N'Numeric country or Area Code in GENC Number format.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'Countries',
    @level2type = N'COLUMN', @level2name = N'INKCode',
	@value = N'DOS Consular Affairs Independent Name Check code for the country.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'Countries',
    @level2type = N'COLUMN', @level2name = N'CountryIndicator',
	@value = N'Indicates if the record is a formal country or not.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'Countries',
    @level2type = N'COLUMN', @level2name = N'DOSBureauID',
	@value = N'Identifies the regional DOS Bureau that the country falls under.  Foreign key pointing to the DOSBureaus table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'Countries',
    @level2type = N'COLUMN', @level2name = N'CurrencyName',
	@value = N'ISO4217-Currency Name of the country''s primary currency.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'Countries',
    @level2type = N'COLUMN', @level2name = N'CurrencyCodeA3',
	@value = N'ISO4217-A3 Currency Code of the country''s primary currency.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'Countries',
    @level2type = N'COLUMN', @level2name = 'CurrencyCodeNumber',
	@value = N'ISO4217-NBR Currency Code of the country''s primary currency.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'Countries',
    @level2type = N'COLUMN', @level2name = N'CurrencySymbol',
	@value = N'Symbolic indicator for the country''s primary currency.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'Countries',
    @level2type = N'COLUMN', @level2name = N'NameFormatID',
	@value = N'The ordering sequence of the 5 columns that GTTS uses to hold a person''s name.  Foreign key pointing to the NameFormats table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'Countries',
    @level2type = N'COLUMN', @level2name = N'NationalIDFormatID',
	@value = N'The Regular Expression (RegEx) for validating the FORMAT of a person''s national ID number for the specified country.  If the country does not have a structured national ID, then the column value will default to NULL.  Foreign key pointing to the NationalIDFormats table.'
GO

/*  IsActive column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'Countries',
    @level2type = N'COLUMN', @level2name = N'IsActive',
	@value = N'Boolean value that indicates if the record is currently active and in use.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'location',
	@level1type = N'TABLE',  @level1name = N'Countries',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the Users table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'location',
	@level1type = N'TABLE',  @level1name = N'Countries',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'location',
	@level1type = N'TABLE',  @level1name = N'Countries',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
	@level1type = N'TABLE',  @level1name = N'Countries',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO