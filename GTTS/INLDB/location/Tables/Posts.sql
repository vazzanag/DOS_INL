CREATE TABLE [location].[Posts]
(
	[PostID] INT IDENTITY (1, 1) NOT NULL,
    [Name] NVARCHAR(100) NOT NULL, 
	[FullName] NVARCHAR(255) NULL,
    [PostTypeID] INT NOT NULL, 
    [CountryID] INT NOT NULL, 
    [MissionID] INT NOT NULL, 
    [GMTOffset] INT NULL, 
	[IsActive] BIT NOT NULL DEFAULT 1,
	[ModifiedByAppUserID] INT NOT NULL,
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),
    CONSTRAINT [PK_Posts] 
		PRIMARY KEY ([PostID]),		
    CONSTRAINT [FK_Posts_AppUsers_ModifiedByAppUserID] 
		FOREIGN KEY ([ModifiedByAppUserID]) 
		REFERENCES [users].[AppUsers]([AppUserID]),
     CONSTRAINT [FK_Posts_PostTypes] 
		FOREIGN KEY ([PostTypeID]) 
		REFERENCES [location].[PostTypes]([PostTypeID]),
     CONSTRAINT [FK_Posts_Countries] 
		FOREIGN KEY ([CountryID]) 
		REFERENCES [location].[Countries]([CountryID]),         
     CONSTRAINT [FK_Posts_Missions] 
		FOREIGN KEY ([MissionID]) 
		REFERENCES [location].[Missions]([MissionID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [location].[Posts_History]))
GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level1type = N'TABLE', 
	@level0name = N'location', @level1name = N'Posts',
	@value = N'Reference table for Post Types.  Data Source is Dept. of State''s Master Reference Data (MRD) Posts Dataset.';
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'Posts',
    @level2type = N'COLUMN', @level2name = N'PostID',
	@value = N'Primary key & identity of the record in this table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'Posts',
    @level2type = N'COLUMN', @level2name = N'Name',
	@value = N'Short name identifying the post.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'Posts',
    @level2type = N'COLUMN', @level2name = N'FullName',
	@value = N'Extended formal name of the post.'
GO


EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'location',
	@level1type = N'TABLE',  @level1name = N'Posts',
	@level2type = N'COLUMN', @level2name = N'PostTypeID',
	@value = N'Identifies the type of post.  Foreign key pointing to the PostTypes table.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'location',
	@level1type = N'TABLE',  @level1name = N'Posts',
	@level2type = N'COLUMN', @level2name = N'CountryID',
	@value = N'Identifies the country that the Post is located in.  Foreign key pointing to the Countries table.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'location',
	@level1type = N'TABLE',  @level1name = N'Posts',
	@level2type = N'COLUMN', @level2name = N'MissionID',
	@value = N'Identifies the mission that the Post belongs under.  Foreign key pointing to the Missions table.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'location',
	@level1type = N'TABLE',  @level1name = N'Posts',
	@level2type = N'COLUMN', @level2name = N'GMTOffset',
	@value = N'Identifies the hours offset from Greenwich Mean Time the Post has.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
    @level1type = N'TABLE',  @level1name = N'Posts',
    @level2type = N'COLUMN', @level2name = N'IsActive',
	@value = N'Boolean value that indicates if the record is currently active and in use.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'location',
	@level1type = N'TABLE',  @level1name = N'Posts',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the Users table.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'location',
	@level1type = N'TABLE',  @level1name = N'Posts',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'location',
	@level1type = N'TABLE',  @level1name = N'Posts',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO