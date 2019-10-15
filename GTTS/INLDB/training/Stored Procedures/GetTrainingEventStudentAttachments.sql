CREATE PROCEDURE training.GetTrainingEventStudentAttachments
    @TrainingEventID BIGINT,
	@PersonID BIGINT
AS
    SELECT TrainingEventStudentAttachmentID, TrainingEventID, PersonID, FileID, FileVersion, TrainingEventStudentAttachmentTypeID, TrainingEventStudentAttachmentType,
           [Description], ModifiedByAppUserID, ModifiedDate, ModifiedByUserJSON
      FROM training.TrainingEventStudentAttachmentsView 
     WHERE TrainingEventID = @TrainingEventID AND PersonID = @PersonID
