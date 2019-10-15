﻿CREATE TABLE [training].[KeyActivities]
(
	[KeyActivityID] INT NOT NULL IDENTITY(1,1), 
    [Code] NVARCHAR(255) NOT NULL, 
    [Description] NVARCHAR(255) NULL,
	[IsActive] bit NOT NULL DEFAULT 1,
	[ModifiedByAppUserID] [int] NOT NULL,
	[ModifiedDate] DATETIME NOT NULL DEFAULT (sysutcdatetime()),
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL DEFAULT (sysutcdatetime()),
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime]),
    CONSTRAINT [PK__KeyActivities] 
        PRIMARY KEY CLUSTERED ([KeyActivityID] ASC)
            WITH (PAD_INDEX = OFF
                  ,STATISTICS_NORECOMPUTE = OFF
                  ,IGNORE_DUP_KEY = OFF
                  ,ALLOW_ROW_LOCKS = ON
				  ,ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
	CONSTRAINT [FK_KeyActivities_AppUsers_ModifiedByAppUserID] 
        FOREIGN KEY ([ModifiedByAppUserID]) 
        REFERENCES [users].[AppUsers]([AppUserID]),
)
ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [training].[KeyActivities_History]))
GO

CREATE INDEX [IDX_Code] ON [training].[KeyActivities] ([Code] ASC)
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

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
    @value = N'Reference table for Key Activities Code Lookup',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'KeyActivities'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Primary key & identity of the record in this table.',
    @level0type = N'SCHEMA',  @level0name = N'training',
    @level1type = N'TABLE',   @level1name = N'KeyActivities',
    @level2type = N'COLUMN',  @level2name = N'KeyActivityID'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Short format common identification or reference code.',
    @level0type = N'SCHEMA',  @level0name = N'training',
    @level1type = N'TABLE',   @level1name = N'KeyActivities',
    @level2type = N'COLUMN',  @level2name = N'Code'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Description explaining what the code means or identifies.',
    @level0type = N'SCHEMA',  @level0name = N'training',
    @level1type = N'TABLE',   @level1name = N'KeyActivities',
    @level2type = N'COLUMN',  @level2name = N'Description'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Boolean value that indicates if the record is currently active and in use.',
    @level0type = N'SCHEMA',  @level0name = N'training',
    @level1type = N'TABLE',   @level1name = N'KeyActivities',
    @level2type = N'COLUMN',  @level2name = N'IsActive'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'Identifies the user who created or updated the record.  Foreign key pointing to the Users table.',
    @level0type = N'SCHEMA',  @level0name = N'training',
    @level1type = N'TABLE',   @level1name = N'KeyActivities',
	@level2type = N'COLUMN',  @level2name = N'ModifiedByAppUserID'
GO

/*  ModifiedDate column description  */
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
	@level0type = N'SCHEMA', @level0name = N'training',
	@level1type = N'TABLE',  @level1name = N'KeyActivities',
	@level2type = N'COLUMN', @level2name = N'ModifiedDate',
	@value = N'Date/Time when the record was modified or created.  Normally would be in sync with SysStartTime.  Used by the application to track changes regardless if the table is temporalized or not.'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'System Date/Time when the record was created.  Used to denote the start of the timeperiod fow which the record is valid.',
    @level0type = N'SCHEMA',  @level0name = N'training',
    @level1type = N'TABLE',   @level1name = N'KeyActivities',
	@level2type = N'COLUMN',  @level2name = N'SysStartTime'
GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description'
	,@value = N'System Date/Time when the record was updated.  Used to denote the end of the timeperiod fow which the record is valid.',
    @level0type = N'SCHEMA',  @level0name = N'training',
    @level1type = N'TABLE',   @level1name = N'KeyActivities',
	@level2type = N'COLUMN',  @level2name = N'SysEndTime'
GO