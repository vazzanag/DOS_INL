/*
    **************************************************************************
    NonAttendanceCauses_Load.sql
    **************************************************************************    
*/
/*  Turn IDENTITY_INSERT ON    */
PRINT 'BEGIN NonAttendanceCauses_Load'
SET IDENTITY_INSERT [training].[NonAttendanceCauses] ON
GO

IF (NOT EXISTS(SELECT * FROM [training].[NonAttendanceCauses]))
	BEGIN
		/*  INSERT VALUES into the table    */
		INSERT INTO [training].[NonAttendanceCauses]
				([NonAttendanceCauseID]
				,[Description]
				,[IsActive]         -- DEFAULT TRUE (1)
				,[ModifiedByAppUserID])
			VALUES
				(1, 'Illness/Death', 1, 1),
				(2, 'Personal Emergency', 1, 1),
				(3, 'Unknown', 1, 1),                
				(4, 'Work Related Causes', 1, 1)
	END
GO

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [training].[NonAttendanceCauses] OFF
GO

/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('[training].[NonAttendanceCauses]', RESEED)
GO