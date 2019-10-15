/*
    **************************************************************************
    NonAttendanceReasons_Load.sql
    **************************************************************************    
*/
/*  Turn IDENTITY_INSERT ON    */
PRINT 'BEGIN NonAttendanceReasons_Load'
SET IDENTITY_INSERT [training].[NonAttendanceReasons] ON
GO

IF (NOT EXISTS(SELECT * FROM [training].[NonAttendanceReasons]))
	BEGIN
		/*  INSERT VALUES into the table    */
		INSERT INTO [training].[NonAttendanceReasons]
				([NonAttendanceReasonID]
				,[Description]
				,[IsActive]         -- DEFAULT TRUE (1)
				,[ModifiedByAppUserID])
			VALUES
				(1, 'Cancellation', 1, 1),
				(2, 'No Show', 1, 1)
	END
GO

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [training].[NonAttendanceReasons] OFF
GO

/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('[training].[NonAttendanceReasons]', RESEED)
GO