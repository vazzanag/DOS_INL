/*
    **************************************************************************
    VettingAttachmentTypes_Load.sql
    **************************************************************************    
*/
/*  Turn IDENTITY_INSERT ON    */
PRINT 'BEGIN VettingAttachmentTypes_Load'
SET IDENTITY_INSERT [vetting].[VettingAttachmentTypes] ON
GO

IF (NOT EXISTS(SELECT * FROM [vetting].[VettingAttachmentTypes]))
	BEGIN
		/*  INSERT VALUES into the table    */
		INSERT INTO [vetting].[VettingAttachmentTypes]
				([VettingAttachmentTypeID]
				,[Name]
				,[Description]
				,[IsActive]         -- DEFAULT TRUE (1)
				,[ModifiedByAppUserID])
			VALUES
				(1, 'INVEST FILE SENT', 'Vetting batch submission file was sent to the INVEST system.', 1, 1),               
				(2, 'INVEST FILE RECEIVED', 'Vetting batch results file was received from the INVEST system.', 1, 1)
	END
GO

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [vetting].[VettingAttachmentTypes] OFF
GO

/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('[vetting].[VettingAttachmentTypes]', RESEED)
GO