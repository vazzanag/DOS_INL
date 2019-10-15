/*
    **************************************************************************
    VettingPersonStatuses_Load.sql
    **************************************************************************    
*/
/*  Turn IDENTITY_INSERT ON    */
SET IDENTITY_INSERT [vetting].[VettingPersonStatuses] ON
GO

IF (NOT EXISTS(SELECT * FROM [vetting].[VettingPersonStatuses]))
	BEGIN
		/*  INSERT VALUES into the table    */
		INSERT INTO [vetting].[VettingPersonStatuses]
				([VettingPersonStatusID]
				,[Code]
				,[Description]
				,[IsActive]         -- DEFAULT TRUE (1)
				,[ModifiedByAppUserID])
			VALUES
				(1, 'SUBMITTED', 'Participant was submitted to Vetting Unit for vetting.', 1, 1),               
				(2, 'APPROVED', 'Participant was approved by Vetting Unit.', 1, 1), 
				(3, 'REJECTED', 'Participant was rejected by Vetting Unit.', 1, 1), 
				(4, 'SUSPENDED', 'Participant was suspended by Leahy Vetting Unit.', 1, 1),
				(5, 'EVENT CANCELED', 'Training Event was canceled.  No vetting occurred.', 1, 1),
				(6, 'CANCELED', 'Participant canceled from vetting batch.', 1, 1)
	END
GO

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [vetting].[VettingPersonStatuses] OFF
GO

/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('[vetting].[VettingPersonStatuses]', RESEED)
GO