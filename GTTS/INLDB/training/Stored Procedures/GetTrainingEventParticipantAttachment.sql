CREATE PROCEDURE [training].[GetTrainingEventParticipantAttachment]
    @TrainingEventParticipantAttachmentID BIGINT,
    @ParticipantType NVARCHAR(15),
    @FileVersion INT = NULL
AS
	IF (@FileVersion IS NOT NULL)
	BEGIN
		SELECT TrainingEventParticipantAttachmentID, TrainingEventID, PersonID, FileID, 
               FileVersion, TrainingEventParticipantAttachmentTypeID, TrainingEventParticipantAttachmentType,
			   [Description], ModifiedByAppUserID, ModifiedDate, ModifiedByUserJSON
		  FROM training.TrainingEventParticipantAttachmentsView  FOR SYSTEM_TIME ALL
		 WHERE TrainingEventParticipantAttachmentID = @TrainingEventParticipantAttachmentID
		   AND FileVersion = @FileVersion
           AND ParticipantType = @ParticipantType;
	 END
	 ELSE
	 BEGIN
		SELECT TrainingEventParticipantAttachmentID, TrainingEventID, PersonID, FileID, 
               FileVersion, TrainingEventParticipantAttachmentTypeID, TrainingEventParticipantAttachmentType,
			   [Description], ModifiedByAppUserID, ModifiedDate, ModifiedByUserJSON
		  FROM training.TrainingEventParticipantAttachmentsView 
		 WHERE TrainingEventParticipantAttachmentID = @TrainingEventParticipantAttachmentID
           AND ParticipantType = @ParticipantType;
	 END