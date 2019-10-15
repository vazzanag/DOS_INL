/*  Turn IDENTITY_INSERT ON    */
SET IDENTITY_INSERT [training].[TrainingEventAttachmentTypes] ON
GO

IF (NOT EXISTS(SELECT * FROM [training].[TrainingEventAttachmentTypes]))
	BEGIN
		/*  INSERT VALUES into the table    */
		INSERT INTO [training].[TrainingEventAttachmentTypes]
				([TrainingEventAttachmentTypeID]
				,[Name]
				,[Description]
				,[IsActive]
				,[ModifiedByAppUserID])
			VALUES
				(1, 'Agenda', 'Schedule of specific activities associated to a Training Event.', 1, 1),
				(2, 'Brochure', 'Booklet or handout that describes products and/or services associated to a Training Event.', 1, 1),
				(3, 'Roster', 'Listing of students or attendee of a Training Event.', 1, 1),
				(4, 'Survey', 'Questionaire provided to and completed by students/attendees at the end of a Training Event.', 1, 1)
	END
GO

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT [training].[TrainingEventAttachmentTypes] OFF
GO

/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('[training].[TrainingEventAttachmentTypes]', RESEED)
GO
