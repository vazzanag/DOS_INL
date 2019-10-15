CREATE PROCEDURE training.GetTrainingEventAttachments
    @TrainingEventID BIGINT
AS
    SELECT TrainingEventAttachmentID, TrainingEventID, FileID, FileVersion, TrainingEventAttachmentTypeID, TrainingEventAttachmentType,
           [Description], IsDeleted, ModifiedByAppUserID, ModifiedDate, ModifiedByUserJSON
      FROM training.TrainingEventAttachmentsView 
     WHERE TrainingEventID = @TrainingEventID
