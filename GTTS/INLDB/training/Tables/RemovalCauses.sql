/*
    RemovalCauses Reference Table
*/
CREATE TABLE [training].[RemovalCauses]
(
	[RemovalCauseID] SMALLINT IDENTITY (1, 1) NOT NULL,
	[RemovalReasonID] SMALLINT NOT NULL,
    [Description] NVARCHAR(100) NOT NULL, 
	[IsActive] BIT NOT NULL DEFAULT 1,
	[ModifiedByAppUserID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (getutcdate()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),
    CONSTRAINT [PK_RemovalCauses] 
        PRIMARY KEY ([RemovalCauseID]), 
	CONSTRAINT [FK_RemovalCauses_RemovalReasons]
        FOREIGN KEY ([RemovalReasonID]) 
		REFERENCES [training].[RemovalReasons]([RemovalReasonID]),
    CONSTRAINT [FK_RemovalCauses_AppUsers_ModifiedByAppUserID] 
        FOREIGN KEY ([ModifiedByAppUserID]) 
		REFERENCES [users].[AppUsers]([AppUserID]),
    CONSTRAINT [UC_RemovalCauses_RemovalReasons] 
		UNIQUE ([RemovalCauseID], [RemovalReasonID])
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [training].[RemovalCauses_History]))
GO

/*  Table description  */
EXECUTE sp_addextendedproperty @name = N'MS_Description', 
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'RemovalCauses',
	@value = N'Reference (lookup) table of possible causes for removing a Person from a Training Event. Not every Removal Reason has/requires a Cause.  Only those Reasons that have/require a Cause will be referenced in this table.';
GO

/*  Primary Key description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'RemovalCauses',
    @level2type = N'COLUMN', @level2name = N'RemovalCauseID',
	@value = N'Primary key & identity of the record in this table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'RemovalCauses',
    @level2type = N'COLUMN', @level2name = N'RemovalReasonID',
	@value = N'Identifies the ReasonRemoval record that the specificd Remove Cause is associated to.  Foreign key pointing to the RemovalReasons table.'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'RemovalCauses',
    @level2type = N'COLUMN', @level2name = N'Description',
	@value = N'Description of the Removal Cause code.'
GO

/*  IsActive column description  */
EXEC sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'RemovalCauses',
    @level2type = N'COLUMN', @level2name = N'IsActive',
	@value = N'Boolean value that indicates if the record is currently active and in use.'
GO

/*  ModifiedByAppUserID column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'RemovalCauses',
	@level2type = N'COLUMN', @level2name = N'ModifiedByAppUserID',
	@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the Users table.'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'RemovalCauses',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

/*  SysStartTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'RemovalCauses',
	@level2type = N'COLUMN', @level2name = N'SysStartTime',
	@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod for which the record is valid.'
GO

/*  SysEndTime column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'RemovalCauses',
	@level2type = N'COLUMN', @level2name = N'SysEndTime',
	@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.'
GO 