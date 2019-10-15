/*
    **************************************************************************
    AgencyAtPostAuthorizingLaws.sql
    **************************************************************************    
*/      
CREATE TABLE [vetting].[AgencyAtPostAuthorizingLaws] 
(
    [PostID] INT NOT NULL, 
    [AuthorizingLawID] SMALLINT NOT NULL,
	[UnitID] BIGINT NULL, 
    [IsActive] BIT DEFAULT '1' NOT NULL, 
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),     
    CONSTRAINT [PK_AgencyAtPostAuthorizingLaws]
        PRIMARY KEY ([PostID], [AuthorizingLawID]),
    CONSTRAINT [FK_AgencyAtPostAuthorizingLaws_Posts]
        FOREIGN KEY ([PostID]) 
        REFERENCES [location].[Posts]([PostID]),
	CONSTRAINT [FK_AgencyAtPostAuthorizingLaws_UnitLibrary]
		FOREIGN KEY ([UnitID]) 
		REFERENCES [unitlibrary].[Units]([UnitID]),
    CONSTRAINT [FK_AgencyAtPostAuthorizingLaws_VettingFundingSources]
        FOREIGN KEY ([AuthorizingLawID]) 
        REFERENCES [vetting].[AuthorizingLaws]([AuthorizingLawID]),
    CONSTRAINT [FK_AgencyAtPostAuthorizingLaws_AppUsers] 
        FOREIGN KEY ([ModifiedByAppUserID]) 
        REFERENCES [users].[AppUsers]([AppUserID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [vetting].[AgencyAtPostAuthorizingLaws_History]))
GO        
      
/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'AgencyAtPostAuthorizingLaws',
	@value = N'A subset of the authorizing laws (from the AuthorizingLaws table) used by a specific Agency/Unit at a Post.  Agency/Unit administrators at a Post have the ability to designate what authorizing laws are allowed to be used by their Agency/Unit users at the Post.'
GO

/*  Compound Primary Key Part 1 description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'AgencyAtPostAuthorizingLaws',
    @level2type = N'COLUMN', @level2name = N'PostID',
	@value = N'First part of the Primary key for this table.  Foreign key pointing to the Posts table.'
GO

/*  Compound Primary Key Part 2 description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'AgencyAtPostAuthorizingLaws',
    @level2type = N'COLUMN', @level2name = N'AuthorizingLawID',
	@value = N'Second part of the Primary key for this table.  Foreign key pointing to the AuthorizingLaws table.'

GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'AgencyAtPostAuthorizingLaws',
    @level2type = N'COLUMN', @level2name = N'UnitID',
	@value = N'Foreign key pointing to the Units table.'
GO

/*  IsActive column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
    @level1type = N'TABLE',  @level1name = N'AgencyAtPostAuthorizingLaws',
    @level2type = N'COLUMN', @level2name = N'IsActive',
	@value = N'Boolean value that indicates if the record is currently active and in use.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'AgencyAtPostAuthorizingLaws',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the Users table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'AgencyAtPostAuthorizingLaws',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'AgencyAtPostAuthorizingLaws',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'vetting',
	@level1type = N'TABLE',  @level1name = N'AgencyAtPostAuthorizingLaws',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO