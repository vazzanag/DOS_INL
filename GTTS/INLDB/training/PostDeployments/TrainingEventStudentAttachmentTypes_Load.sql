PRINT 'BEGIN training.TrainingEventStudentAttachmentTypes_Load'

/*  Turn IDENTITY_INSERT ON    */
SET IDENTITY_INSERT [training].[TrainingEventStudentAttachmentTypes] ON
GO

IF (NOT EXISTS(SELECT * FROM [training].[TrainingEventStudentAttachmentTypes]))
	BEGIN
		/*  INSERT VALUES into the table    */
		INSERT INTO [training].[TrainingEventStudentAttachmentTypes]
				([TrainingEventStudentAttachmentTypeID]
				,[Name]
				,[Description]
				,[IsActive]
				,[ModifiedByAppUserID])
			VALUES
				(1, 'Annex3', 'Annex3 document information.', 1, 1),	-- Mexico specific?  How to handle?
				(2, 'Bank Account', 'Banking information for a specific person and training event.', 1, 1),
				(3, 'Itinerary', 'Travel itinerary for a specfic person and training event.', 1, 1),
				(4, 'Passport', 'Passport information for a specific person and training event.', 1, 1),
				(5, 'Visa', 'Visa information for a specific person and training event.', 1, 1)
	END
GO

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [training].[TrainingEventStudentAttachmentTypes] OFF
GO

/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('[training].[TrainingEventStudentAttachmentTypes]', RESEED)
GO
