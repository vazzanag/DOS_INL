/*
    **************************************************************************
    VettingBatchStatuses_Load.sql
    **************************************************************************    
*/
/*  Turn IDENTITY_INSERT ON    */
PRINT 'BEGIN VettingBatchStatuses_Load'
SET IDENTITY_INSERT [vetting].[VettingBatchStatuses] ON
GO

IF (NOT EXISTS(SELECT * FROM [vetting].[VettingBatchStatuses]))
	BEGIN
		/*  INSERT VALUES into the table    */
		INSERT INTO [vetting].[VettingBatchStatuses]
				([VettingBatchStatusID]
				,[Code]
				,[Description]
				,[IsActive]         -- DEFAULT TRUE (1)
				,[ModifiedByAppUserID])
			VALUES
				(1, 'SUBMITTED', 'Batch was submitted to vetting unit.', 1, 1),
				(2, 'ACCEPTED', 'Batch was accepted by the Vetting Unit and assigned to a specific Vetter.', 1, 1),               
				(3, 'REJECTED BY VETTING', 'Batch was rejected by the Vetting Unit and returned back to the Program Manager.', 1, 1),
				(4, 'SUBMITTED TO COURTESY', 'Batch was released to the Courtesy Vetting Units.', 1, 1),
				(5, 'COURTESY COMPLETED', 'All records in the batch have been reviewed by each of the Courtesy Vetting Units.', 1, 1),
				(6, 'SUBMITTED TO LEAHY', 'Batch was submitted for Leahy Vetting (INVEST).', 1, 1),
				(7, 'LEAHY RESULTS RETURNED', 'Leahy Vetting results for the batch have been received.', 1, 1),
				(8, 'CLOSED', 'The Vetter Unit has processed all of the returns from the Courtesy Vetting Units and flagged all of the recipients in the batch as Passed or Failed.', 1, 1),
				(9, 'CANCELED', 'Batch was canceled as a result of the associated training event being canceled.', 1, 1)
	END
GO

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [vetting].[VettingBatchStatuses] OFF
GO

/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('[vetting].[VettingBatchStatuses]', RESEED)
GO