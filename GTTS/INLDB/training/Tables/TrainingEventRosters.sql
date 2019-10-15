/*
    **************************************************************************
    TrainingEventRosters.sql
    **************************************************************************  
*/
CREATE TABLE [training].[TrainingEventRosters] 
(
    [TrainingEventRosterID] BIGINT IDENTITY (1, 1) NOT NULL, 
    [TrainingEventID] BIGINT NOT NULL,
    [PersonID] BIGINT NOT NULL,
    [PreTestScore] TINYINT NULL,     
    [PostTestScore] TINYINT NULL,      
    [PerformanceScore] TINYINT NULL,  
    [ProductsScore] TINYINT NULL,      
    [AttendanceScore] TINYINT NULL,  
    [FinalGradeScore] TINYINT NULL, 
    [Certificate] BIT NULL,
    [MinimumAttendanceMet] BIT NULL,
    [TrainingEventRosterDistinctionID] INT NULL,     
    [NonAttendanceReasonID] TINYINT NULL, 
    [NonAttendanceCauseID] TINYINT NULL,     
    [Comments] NVARCHAR(2000) NULL,     
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),   
    CONSTRAINT [PK_TrainingEventRosters]
        PRIMARY KEY (TrainingEventRosterID),
    CONSTRAINT [FK_TrainingEventRosters_TrainingEvents] 
        FOREIGN KEY ([TrainingEventID]) 
        REFERENCES [training].[TrainingEvents]([TrainingEventID]),
    CONSTRAINT [FK_TrainingEventRosters_Persons] 
        FOREIGN KEY ([PersonID]) 
        REFERENCES [persons].[Persons]([PersonID]), 
    CONSTRAINT [FK_TrainingEventRosters_TrainingEventRosterDistinctions] 
        FOREIGN KEY ([TrainingEventRosterDistinctionID]) 
        REFERENCES [training].[TrainingEventRosterDistinctions]([TrainingEventRosterDistinctionID]),
	CONSTRAINT [FK_TrainingEventRosters_NonAttendanceReasons] 
        FOREIGN KEY ([NonAttendanceReasonID]) 
        REFERENCES  [training].[NonAttendanceReasons]([NonAttendanceReasonID]),
	CONSTRAINT [FK_TrainingEventRosters_NonAttendanceCauses] 
        FOREIGN KEY ([NonAttendanceCauseID]) 
        REFERENCES [training].[NonAttendanceCauses]([NonAttendanceCauseID]),
    CONSTRAINT [FK_TrainingEventRosters_AppUsers] 
        FOREIGN KEY ([ModifiedByAppUserID]) 
        REFERENCES [users].[AppUsers]([AppUserID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [training].[TrainingEventRosters_History]))
GO

CREATE INDEX [IDX_TrainingEventRosters_PersonID] ON [training].[TrainingEventRosters] ([PersonID]) 
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventRosters',
	@value = N'Contains the uploaded/imported Student Roster results for a specific Training Event.'
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventRosters',
    @level2type = N'COLUMN', @level2name = N'TrainingEventRosterID',
	@value = N'Primary key & identity of the record in this table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventRosters',
    @level2type = N'COLUMN', @level2name = N'TrainingEventID',
	@value = N'Training Event ID of the Training Event associated to this TrainingEventRoster record.  Foreign key pointing to the TrainingEvents table. '
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventRosters',
    @level2type = N'COLUMN', @level2name = N'PersonID',
	@value = N'Internal database ID of the person that the record is associated with.  Foreign key pointing to the Persons table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventRosters',
    @level2type = N'COLUMN', @level2name = N'PreTestScore',
	@value = N'Participant''s initial Pre-Test Score.  The Pre-Test is intended to establish a baseline of the Participant''s knowledge of the Training Event topic at the start of the Training Event.  Comparing this score to the PostTestScore allows the system to determine if the participant improved their knowledge as a result of the Training Event.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventRosters',
    @level2type = N'COLUMN', @level2name = N'PostTestScore',
	@value = N'Participant''s unwieghted average of all aggregated Tests Scores that were part of the Training Event.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventRosters',
    @level2type = N'COLUMN', @level2name = N'PerformanceScore',
	@value = N'Participant''s unwieghted average of all aggregated Performance Scores that were part of the Training Event.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventRosters',
    @level2type = N'COLUMN', @level2name = N'ProductsScore',
	@value = N'Participant''s unwieghted average of all aggregated Products Scores that were part of the Training Event.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventRosters',
    @level2type = N'COLUMN', @level2name = N'AttendanceScore',
	@value = N'Participant''s unweighted Attendance score (% basis) of participants attendance.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventRosters',
    @level2type = N'COLUMN', @level2name = N'FinalGradeScore',
	@value = N'Participant''s Final Grade which is computed as a weighted average of all graded items needed to pass the course ((PostTestScore * TestWeighting) + 
(PerformanceScore * PerformanceWeighting) + (ProductsScore * ProductsWeighting)). Does not include PreTestScore.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventRosters',
    @level2type = N'COLUMN', @level2name = N'Certificate',
	@value = N'Boolean value that indicates if the Person passed the course and is eligible for a certficiate.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventRosters',
    @level2type = N'COLUMN', @level2name = N'MinimumAttendanceMet',
	@value = N'Boolean value that indicates if the Person met minimum attendance requirements.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventRosters',
    @level2type = N'COLUMN', @level2name = N'TrainingEventRosterDistinctionID',
	@value = N'Indicates if the Participant distinguished themselves in any specific manner.  Can be good or bad.  Nullable foreign key pointing to the TrainingEventRosterDistinctions table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventRosters',
    @level2type = N'COLUMN', @level2name = N'NonAttendanceReasonID',
	@value = N'Identifies the specific reason for a Participant not attending a day of the Training Event.  Foreign key pointing to the NonAttendanceReasons table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventRosters',
    @level2type = N'COLUMN', @level2name = N'NonAttendanceCauseID',
	@value = N'Identifies the specific cause for a Participant not attending a day of the Training Event.  Foreign key pointing to the NonAttendanceCauses table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @level0type = N'SCHEMA', @level0name = N'training',
    @level1type = N'TABLE',  @level1name = N'TrainingEventRosters',
    @level2type = N'COLUMN', @level2name = N'Comments',
	@value = N'Additional information or instructor comments about the Participant.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventRosters',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the Users table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventRosters',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventRosters',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'TrainingEventRosters',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod for which the record is valid.'
GO


