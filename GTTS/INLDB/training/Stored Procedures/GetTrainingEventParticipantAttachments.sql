CREATE PROCEDURE [training].[GetTrainingEventParticipantAttachments]
    @TrainingEventID BIGINT,
    @PersonID BIGINT,
    @ParticipantType NVARCHAR(15)
AS
    SELECT TrainingEventParticipantAttachmentID, TrainingEventID, PersonID, FileID, FileVersion, 
           TrainingEventParticipantAttachmentTypeID, TrainingEventParticipantAttachmentType,
           IsDeleted, [Description], ModifiedByAppUserID, ModifiedDate, ModifiedByUserJSON
      FROM training.TrainingEventParticipantAttachmentsView 
     WHERE TrainingEventID = @TrainingEventID 
       AND PersonID = @PersonID
       AND ParticipantType = @ParticipantType;
