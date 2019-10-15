CREATE PROCEDURE training.GetTrainingEventAttachment
    @TrainingEventAttachmentID BIGINT,
	@FileVersion INT = NULL
AS
	IF (@FileVersion IS NOT NULL)
	BEGIN
		SELECT TrainingEventAttachmentID, TrainingEventID, FileID, FileVersion, TrainingEventAttachmentTypeID, TrainingEventAttachmentType,
			   [Description], IsDeleted, ModifiedByAppUserID, ModifiedDate, ModifiedByUserJSON
		  FROM training.TrainingEventAttachmentsView  FOR SYSTEM_TIME ALL
		 WHERE TrainingEventAttachmentID = @TrainingEventAttachmentID
		AND    FileVersion = @FileVersion

	 END
	 ELSE
	 BEGIN
		SELECT TrainingEventAttachmentID, TrainingEventID, FileID, FileVersion, TrainingEventAttachmentTypeID, TrainingEventAttachmentType,
			   [Description], IsDeleted, ModifiedByAppUserID, ModifiedDate, ModifiedByUserJSON
		  FROM training.TrainingEventAttachmentsView 
		 WHERE TrainingEventAttachmentID = @TrainingEventAttachmentID
	 END