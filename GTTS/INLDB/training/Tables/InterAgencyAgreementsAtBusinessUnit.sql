CREATE TABLE [training].[InterAgencyAgreementsAtBusinessUnit]
(
    [BusinessUnitID] BIGINT NOT NULL, 
    [InterAgencyAgreementID] INT NOT NULL, 
    [IsActive] BIT DEFAULT 1 NOT NULL, 
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),  
    CONSTRAINT [PK_InterAgencyAgreementsAtBusinessUnit]
        PRIMARY KEY ([BusinessUnitID], [InterAgencyAgreementID]),
    CONSTRAINT [FK_InterAgencyAgreementsAtBusinessUunit_BusinessUnit]
        FOREIGN KEY ([BusinessUnitID]) 
        REFERENCES [users].[BusinessUnits]([BusinessUnitID]),
    CONSTRAINT [FK_InterAgencyAgreementsAtBusinessUnit_InterAgencyAgreementID]
        FOREIGN KEY ([InterAgencyAgreementID]) 
        REFERENCES [training].[InterAgencyAgreements]([InterAgencyAgreementID]),        
    CONSTRAINT [FK_InterAgencyAgreementsAtBusinessUnit_AppUsers] 
        FOREIGN KEY ([ModifiedByAppUserID]) 
        REFERENCES [users].[AppUsers]([AppUserID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [training].[InterAgencyAgreementsAtBusinessunit_History]))
GO  

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'InterAgencyAgreementsAtBusinessUnit',
    @value = N'A subset of project codes used at a specific business unit.'
GO

/*  Compound Primary Key Part 1 description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'InterAgencyAgreementsAtBusinessUnit',
    @level2type = N'COLUMN', @level2name = N'BusinessUnitID',
	@value = N'First part of the Primary key for this table.  Foreign key pointing to the users.BusinessUnits table.'
GO

/*  Compound Primary Key Part 2 description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'InterAgencyAgreementsAtBusinessUnit',
    @level2type = N'COLUMN', @level2name = N'InterAgencyAgreementID',
	@value = N'Second part of the Primary key for this table.  Foreign key pointing to the InterAgencyAgreement table.'
GO

/*  IsActive column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'InterAgencyAgreementsAtBusinessUnit',
    @level2type = N'COLUMN', @level2name = N'IsActive',
	@value = N'Boolean value that indicates if the record is currently active and in use.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'InterAgencyAgreementsAtBusinessUnit',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the Users table.'
GO

/*  ModifiedDate column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'InterAgencyAgreementsAtBusinessUnit',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'InterAgencyAgreementsAtBusinessUnit',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'InterAgencyAgreementsAtBusinessUnit',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO
