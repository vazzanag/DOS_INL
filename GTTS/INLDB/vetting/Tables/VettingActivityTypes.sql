/*
    ************************************************************************** 
    VettingActivityTypes.sql
    [vetting].[VettingActivityTypes] (Military, Police, Other, N/A)
    **************************************************************************     
*/
CREATE TABLE [vetting].[VettingActivityTypes] 
(
    [VettingActivityTypeID] SMALLINT IDENTITY (1, 1) NOT NULL,
    [Name] NVARCHAR(15) NOT NULL UNIQUE, 
    [Description] NVARCHAR(300) NOT NULL, 
    [IsActive] BIT DEFAULT '1' NOT NULL,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),  
    CONSTRAINT [PK_VettingActivityTypes]
        PRIMARY KEY ([VettingActivityTypeID]),
    CONSTRAINT [FK_VettingActivityTypes_AppUsers] 
        FOREIGN KEY ([ModifiedByAppUserID]) 
        REFERENCES [users].[AppUsers]([AppUserID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [vetting].[VettingActivityTypes_History]))
GO

CREATE INDEX [IDX_Name] ON [vetting].[VettingActivityTypes] ([Name] ASC)
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
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'VettingActivityTypes',
	@value = N'Reference table that holds the different identification strings for all of the different types of vetting activity tracked by GTTS.';
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingActivityTypes',
    @level2type = N'COLUMN', @level2name = N'VettingActivityTypeID',
	@value = N'Primary key & identity of the record in this table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingActivityTypes',
    @level2type = N'COLUMN', @level2name = N'Name',
	@value = N'Short length string that identifies the type of vetting activity.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingActivityTypes',
    @level2type = N'COLUMN', @level2name = N'Description',
	@value = N'Detail description of the type of vetting activity.'
GO

/*  IsActive column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingActivityTypes',
    @level2type = N'COLUMN', @level2name = N'IsActive',
	@value = N'Boolean value that indicates if the record is currently active and in use.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingActivityTypes',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the Users table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingActivityTypes',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingActivityTypes',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'VettingActivityTypes',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO 