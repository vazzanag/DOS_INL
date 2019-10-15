/*
    In order to maintain backwards compatibility with migrated data from TTS,
    we need to set the IDENTITY_INSERT property of the table ON before running
	the INSERT statement.  Afterwards, we set the IDENTITY_INSERT property to OFF,
	and set the seed value to the highest IDENTITY value.
*/

/*  Turn IDENTITY_INSERT ON    */
PRINT 'BEGIN training.VisaStatuses_Load'
SET IDENTITY_INSERT [training].[VisaStatuses] ON
GO

IF (NOT EXISTS(SELECT * FROM [training].[VisaStatuses]))
    BEGIN 
        /*  INSERT VALUES into the table    */
        INSERT INTO [training].[VisaStatuses]
                    ([VisaStatusID]
					,[Code]
                    ,[Description]
		            ,[IsActive]
		            ,[ModifiedByAppUserID])
                VALUES
		        (1, N'Pending', 'Participant has not yet been issued / received visa for event.', 1, 1),
		        (2, N'Received', 'Participant has been issued and received visa for event.', 1, 1),
		        (3, N'Rejected', 'Participant was denied visa for event.', 1, 1)
    END
GO


/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [training].[VisaStatuses] OFF
GO

/*  Set new INDENTIY Starting VALUE to maximum column value */
DBCC CHECKIDENT ('[training].[VisaStatuses]', RESEED)
GO