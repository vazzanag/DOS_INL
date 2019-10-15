/*
    **************************************************************************
    PostVettingConfiguration.sql
    **************************************************************************    
*/ 
CREATE TABLE [vetting].[PostVettingConfiguration]
(
    [PostID] INT NOT NULL, 
    [MaxBatchSize] INT NOT NULL DEFAULT 50, 
	[LeahyBatchLeadTime] INT NOT NULL DEFAULT 21,
	[CourtesyBatchLeadTime] INT NOT NULL DEFAULT 30,
	[CourtesyCheckTimeFrame] INT NOT NULL DEFAULT 5,
	[LeahyBatchExpirationIntervalMonths] INT NULL,
	[CourtesyBatchExpirationIntervalMonths] INT,
	[POL_POC_Email] NVARCHAR(255) NULL,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]), 
    CONSTRAINT [PK_PostVettingConfiguration] 
		PRIMARY KEY ([PostID]), 
    CONSTRAINT [FK_PostVettingConfiguration_locations_Posts] 
		FOREIGN KEY ([PostID]) 
		REFERENCES [location].[Posts]([PostID]),
    CONSTRAINT [FK_PostVettingConfiguration_AppUsers] 
        FOREIGN KEY ([ModifiedByAppUserID]) 
        REFERENCES [users].[AppUsers]([AppUserID])   
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [vetting].[PostVettingConfiguration_History]))
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'PostVettingConfiguration',
	@value = N'A table to save post-specific vetting configuration information.'
GO

/*  Primary Key (PostID) description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'PostVettingConfiguration',
    @level2type = N'COLUMN', @level2name = N'PostID',
	@value = N'The Primary key for this table.  Foreign key pointing to the locations.Posts table.'
GO

/*  MaxBatchSize column  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'PostVettingConfiguration',
    @level2type = N'COLUMN', @level2name = N'MaxBatchSize',
	@value = N'The post''s max batch size allowed when submitting for vetting.'
GO

/*  LeahyBatchLeadTime column  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'PostVettingConfiguration',
    @level2type = N'COLUMN', @level2name = N'LeahyBatchLeadTime',
	@value = N'The post''s required time for leahy vetting batch completion.'
GO

/*  LeahyBatchLeadTime column  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'PostVettingConfiguration',
    @level2type = N'COLUMN', @level2name = N'CourtesyBatchLeadTime',
	@value = N'The post''s required time for courtesy vetting batch completion.'
GO

/* CourtesyCheckTimeFrame column */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'PostVettingConfiguration',
    @level2type = N'COLUMN', @level2name = N'CourtesyCheckTimeFrame',
	@value = N'The post''s required time for courtesy name check to be completed by the courtesy unit.'
GO


/* LeahyBatchExpirationIntervalMonths column */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'PostVettingConfiguration',
    @level2type = N'COLUMN', @level2name = N'LeahyBatchExpirationIntervalMonths',
	@value = N'The post''s time for re-vetting Leahy batch before expiration.'
GO


/* CourtesyBatchExpirationIntervalMonths column */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'PostVettingConfiguration',
    @level2type = N'COLUMN', @level2name = N'CourtesyBatchExpirationIntervalMonths',
	@value = N'The post''s time for re-vetting Courtesy batch before expiration.'
GO

/*  POL_POC_Email column  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'PostVettingConfiguration',
    @level2type = N'COLUMN', @level2name = N'POL_POC_Email',
	@value = N'The email address (individual or Active Directory Distribution List) designated to receive all POL-related questions or inquiries.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'PostVettingConfiguration',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the Users table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'PostVettingConfiguration',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'PostVettingConfiguration',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'PostVettingConfiguration',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod for which the record is valid.'
GO