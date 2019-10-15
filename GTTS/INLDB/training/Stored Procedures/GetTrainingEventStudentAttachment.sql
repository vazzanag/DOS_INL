CREATE PROCEDURE training.GetTrainingEventStudentAttachment
    @TrainingEventStudentAttachmentID BIGINT,
	@FileVersion INT = NULL
AS
	IF (@FileVersion IS NOT NULL)
	BEGIN
		SELECT TrainingEventStudentAttachmentID, TrainingEventID, PersonID, FileID, FileVersion, TrainingEventStudentAttachmentTypeID, TrainingEventStudentAttachmentType,
			   [Description], ModifiedByAppUserID, ModifiedDate, ModifiedByUserJSON
		  FROM training.TrainingEventStudentAttachmentsView  FOR SYSTEM_TIME ALL
		 WHERE TrainingEventStudentAttachmentID = @TrainingEventStudentAttachmentID
		AND    FileVersion = @FileVersion

	 END
	 ELSE
	 BEGIN
		SELECT TrainingEventStudentAttachmentID, TrainingEventID, PersonID, FileID, FileVersion, TrainingEventStudentAttachmentTypeID, TrainingEventStudentAttachmentType,
			   [Description], ModifiedByAppUserID, ModifiedDate, ModifiedByUserJSON
		  FROM training.TrainingEventStudentAttachmentsView 
		 WHERE TrainingEventStudentAttachmentID = @TrainingEventStudentAttachmentID
	 END