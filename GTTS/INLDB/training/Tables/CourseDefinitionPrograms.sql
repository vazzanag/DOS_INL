/*
    **************************************************************************
    CourseDefinitionPrograms.sql
    **************************************************************************  
*/
CREATE TABLE [training].[CourseDefinitionPrograms] 
(
    [CourseDefinitionProgramID] INT IDENTITY (1, 1) NOT NULL, 
    [PostID] INT NULL, 
    [Code] NVARCHAR(130) NOT NULL,
    [Description] NVARCHAR(255) NULL, 
    [IsActive] BIT DEFAULT 1 NOT NULL,    
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),   
    CONSTRAINT [PK_CourseDefinitionPrograms]
        PRIMARY KEY (CourseDefinitionProgramID),
    CONSTRAINT [FK_CourseDefinitionPrograms_Posts] 
        FOREIGN KEY ([PostID]) 
        REFERENCES [location].[Posts]([PostID]),
    CONSTRAINT [FK_CourseDefinitionPrograms_AppUsers] 
        FOREIGN KEY ([ModifiedByAppUserID]) 
        REFERENCES [users].[AppUsers]([AppUserID])   
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [training].[CourseDefinitionPrograms_History]))
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'CourseDefinitionPrograms',
	@value = N'Reference table listing all of the Programs used by Posts to support Strategic Goals. Created either by a Global M&E Admin or a Post M&E Admin via an admin function.'
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'CourseDefinitionPrograms',
    @level2type = N'COLUMN', @level2name = N'CourseDefinitionProgramID',
	@value = N'Primary key & identity of the record in this table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'CourseDefinitionPrograms',
    @level2type = N'COLUMN', @level2name = N'PostID',
	@value = N'Identifies a specific Post that that this Course Definition Program is associated with.  If Course Definition Program is global (Global M&E for all Posts), then this field is 0 or NULL.  List is displayed in the UI based on "WHERE PostID = 0 (or NULL) OR PostID = MyPostID".  Nullable foreign key pointing to the Posts table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'CourseDefinitionPrograms',
    @level2type = N'COLUMN', @level2name = N'Code',
	@value = N'Short format name of Program used by Post(s) to support Strategic Goals.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'CourseDefinitionPrograms',
    @level2type = N'COLUMN', @level2name = N'Description',
	@value = N'Detailed description of the Program used by Post(s) to support Strategic Goals.'
GO

/*  IsActive column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'CourseDefinitionPrograms',
    @level2type = N'COLUMN', @level2name = N'IsActive',
	@value = N'Boolean value that indicates if the record is currently active and in use.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'CourseDefinitionPrograms',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the Users table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'CourseDefinitionPrograms',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'CourseDefinitionPrograms',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'CourseDefinitionPrograms',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod for which the record is valid.'
GO