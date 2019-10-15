/*
    **************************************************************************
    CourseDefinitions.sql
    **************************************************************************  
*/
CREATE TABLE [training].[CourseDefinitions] 
(
    [CourseDefinitionID] INT IDENTITY (1, 1) NOT NULL, 
    [PostID] INT NULL, 
    [Description] NVARCHAR(255) NOT NULL, 
    [CourseDefinitionProgramID] INT NOT NULL, 
    [TestsWeighting] TINYINT NULL,     
    [PerformanceWeighting] TINYINT NULL,      
    [ProductsWeighting] TINYINT NULL,  
    [MinimumAttendance] TINYINT NULL,      
    [MinimumFinalGrade] TINYINT NULL,  
    [IsActive] BIT DEFAULT 1 NOT NULL,    
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),   
    CONSTRAINT [PK_CourseDefinitions]
        PRIMARY KEY (CourseDefinitionID),
    CONSTRAINT [FK_CourseDefinitions_Posts] 
        FOREIGN KEY ([PostID]) 
        REFERENCES [location].[Posts]([PostID]),
    CONSTRAINT [FK_CourseDefinitions_CourseDefinitionPrograms] 
        FOREIGN KEY ([CourseDefinitionProgramID]) 
        REFERENCES [training].[CourseDefinitionPrograms]([CourseDefinitionProgramID]), 
    CONSTRAINT [FK_CourseDefinitions_AppUsers] 
        FOREIGN KEY ([ModifiedByAppUserID]) 
        REFERENCES [users].[AppUsers]([AppUserID])   
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [training].[CourseDefinitions_History]))
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'CourseDefinitions',
	@value = N'Defines a pre-configuration of Roster data points (weights) for a course.  Created either by a Global M&E Admin or a Post M&E Admin via an admin function.'
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'CourseDefinitions',
    @level2type = N'COLUMN', @level2name = N'CourseDefinitionID',
	@value = N'Primary key & identity of the record in this table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'CourseDefinitions',
    @level2type = N'COLUMN', @level2name = N'PostID',
	@value = N'Identifies a specific Post that that this Course Definition is associated with.  If Course Definition is global (Global M&E for all Posts), then this field is 0 or NULL.   List is displayed in the UI based on "WHERE PostID = 0 (or NULL) OR PostID = MyPostID".  Nullable foreign key pointing to the Posts table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'CourseDefinitions',
    @level2type = N'COLUMN', @level2name = N'Description',
	@value = N'Name/Description of the course.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'CourseDefinitions',
    @level2type = N'COLUMN', @level2name = N'CourseDefinitionProgramID',
	@value = N'Identifies the strategic goal program associated to the specifed Course Definition.  Foreign key pointing to the CourseDefinitionPrograms reference table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'CourseDefinitions',
    @level2type = N'COLUMN', @level2name = N'TestsWeighting',
	@value = N'Weight of all Tests Scores combined as part of the overall course grade.  Sum of all Weights must = 100.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'CourseDefinitions',
    @level2type = N'COLUMN', @level2name = N'PerformanceWeighting',
	@value = N'Weight of all Performance Scores combined as part of the overall course grade.  Sum of all Weights must = 100.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'CourseDefinitions',
    @level2type = N'COLUMN', @level2name = N'ProductsWeighting',
	@value = N'Weight of all Products Scores combined as part of the overall course grade.  Sum of all Weights must = 100.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'CourseDefinitions',
    @level2type = N'COLUMN', @level2name = N'MinimumAttendance',
	@value = N'Minimum required passing score (% basis) of participants attendance.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'CourseDefinitions',
    @level2type = N'COLUMN', @level2name = N'MinimumFinalGrade',
	@value = N'Minimum required weighted passing total score (% basis) of all graded items needed to pass the course.'
GO

/*  IsActive column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'CourseDefinitions',
    @level2type = N'COLUMN', @level2name = N'IsActive',
	@value = N'Boolean value that indicates if the record is currently active and in use.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'CourseDefinitions',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the Users table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'CourseDefinitions',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'CourseDefinitions',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'CourseDefinitions',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod for which the record is valid.'
GO