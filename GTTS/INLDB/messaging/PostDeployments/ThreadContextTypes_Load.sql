/*
    **************************************************************************
    ThreadContextTypes_Load.sql
    **************************************************************************    
*/
/*  Turn IDENTITY_INSERT ON    */
SET IDENTITY_INSERT [messaging].[ThreadContextTypes] ON
GO

IF (NOT EXISTS(SELECT * FROM [messaging].[ThreadContextTypes]))
	BEGIN
		/*  INSERT VALUES into the table    */
		INSERT INTO [messaging].[ThreadContextTypes]
				([ThreadContextTypeID]
				,[Name]
				,[IsActive]         -- DEFAULT TRUE (1)
				,[ModifiedByAppUserID])
			VALUES
				(1, 'Training Event', 1, 1),               
				(2, 'Vetting Batch', 1, 1),  
				(3, 'Student', 1, 1),  
				(4, 'Instructor', 1, 1)
	END
GO

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [messaging].[ThreadContextTypes] OFF
GO

/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('[messaging].[ThreadContextTypes]', RESEED)
GO