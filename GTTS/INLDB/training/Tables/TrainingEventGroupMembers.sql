CREATE TABLE [training].[TrainingEventGroupMembers]
(
	[TrainingEventGroupID] BIGINT NOT NULL, 
	[PersonID] BIGINT NOT NULL,
	[GroupMemberTypeID] INT NOT NULL, 	
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),
    CONSTRAINT [PK_TrainingEventGroupMembers] 
        PRIMARY KEY ([TrainingEventGroupID], [PersonID]),  
    CONSTRAINT [FK_TrainingEventGroupMembers_TrainingEventGroups] 
        FOREIGN KEY ([TrainingEventGroupID]) 
        REFERENCES [training].[TrainingEventGroups]([TrainingEventGroupID]),
    CONSTRAINT [FK_TrainingEventGroupMembers_Persons] 
        FOREIGN KEY ([PersonID]) 
        REFERENCES [persons].[Persons]([PersonID]),    
    CONSTRAINT [FK_TrainingEventGroupMembers_GroupMemberTypes] 
        FOREIGN KEY ([GroupMemberTypeID]) 
        REFERENCES [training].[TrainingEventGroupMemberTypes]([TrainingEventGroupMemberTypeID]),    
    CONSTRAINT [FK_TrainingEventGroupMembers_AppUsers_ModifiedByAppUserID] 
        FOREIGN KEY ([ModifiedByAppUserID]) 
        REFERENCES [users].[AppUsers]([AppUserID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [training].[TrainingEventGroupMembers_History]))
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventGroupMembers',
	@value = N'The members of a particular group within a training event.';
GO

/*  Primary Key Part 1 Description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventGroupMembers',
    @level2type = N'COLUMN', @level2name = N'TrainingEventGroupID',
	@value = N'Part 1 of the Primary key in this table.  Foreign key pointing to the TrainingEventGroups table.'
GO

/*  Primary Key Part 2 Description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventGroupMembers',
    @level2type = N'COLUMN', @level2name = N'PersonID',
	@value = N'Part 2 of the Primary key in this table.  Foreign key pointing to the Persons table.'
GO


EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventGroupMembers',
    @level2type = N'COLUMN', @level2name = N'GroupMemberTypeID',
	@value = N'Identifies the group member type of the Person (PersonID) associated with the record.  Foreign key pointing to the GroupMemberTypes table.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventGroupMembers',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the Users table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventGroupMembers',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventGroupMembers',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventGroupMembers',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO 