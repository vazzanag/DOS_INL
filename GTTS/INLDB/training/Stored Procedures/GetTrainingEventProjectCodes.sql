CREATE PROCEDURE [training].[GetTrainingEventProjectCodes]
    @TrainingEventID BIGINT
AS
    SELECT TrainingEventID,  ProjectCodeID,  Code, [Description], ModifiedByAppUserID,  ModifiedDate,  ProjectCodeJSON,  ModifiedByUserJSON
	  FROM training.TrainingEventProjectCodesView
	 WHERE TrainingEventID = @TrainingEventID;
