CREATE TABLE [persons].[PersonLanguages]
(
	[PersonID] BIGINT NOT NULL, 
    [LanguageID] SMALLINT NOT NULL,
    [LanguageProficiencyID] SMALLINT NULL, 
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),	
    CONSTRAINT [PK_PersonLanguages] 
		PRIMARY KEY ([PersonID], [LanguageID]), 
    CONSTRAINT [FK_PersonLanguages_Persons] 
		FOREIGN KEY ([PersonID]) 
		REFERENCES [persons].[Persons]([PersonID]),
    CONSTRAINT [FK_PersonLanguages_Languages] 
		FOREIGN KEY ([LanguageID]) 
		REFERENCES [location].[Languages]([LanguageID]),
    CONSTRAINT [FK_PersonLanguages_LanguageProficiencies] 
		FOREIGN KEY ([LanguageProficiencyID]) 
		REFERENCES [location].[LanguageProficiencies]([LanguageProficiencyID]), 
    CONSTRAINT [FK_PersonLanguages_AppUsers_ModifiedByAppUserID] 
		FOREIGN KEY ([ModifiedByAppUserID]) 
		REFERENCES [users].[AppUsers]([AppUserID]) 
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [persons].[PersonLanguages_History]))
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'persons',
	@level1type = N'TABLE',  @level1name = N'PersonLanguages',
	@value = N'Link table that links Persons table to the Languages table.'
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'persons',
	@level1type = N'TABLE',  @level1name = N'PersonLanguages',
    @level2type = N'COLUMN', @level2name = N'PersonID',
	@value = N'Persons half of the Primary key for this table.  Foreign key pointing to the Persons table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'persons',
	@level1type = N'TABLE',  @level1name = N'PersonLanguages',
    @level2type = N'COLUMN', @level2name = N'LanguageID',
	@value = N'Languages half of the Primary key for this table.  Foreign key pointing to the Languages table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'persons',
	@level1type = N'TABLE',  @level1name = N'PersonLanguages',
    @level2type = N'COLUMN', @level2name = N'LanguageProficiencyID',
	@value = N'Person''s level of proficiency with the language.  Foreign key pointing to the LanguageProficiencies table.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'persons',
	@level1type = N'TABLE',  @level1name = N'PersonLanguages',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the AppUsers table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'persons',
	@level1type = N'TABLE',  @level1name = N'PersonLanguages',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'PersonLanguages',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'persons',
    @level1type = N'TABLE',  @level1name = N'PersonLanguages',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO