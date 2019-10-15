CREATE PROCEDURE [training].[GetTrainingEventStatusLog]
    @TrainingEventStatusLogID BIGINT
AS
BEGIN

    SELECT TrainingEventStatusLogID, TrainingEventID, TrainingEventStatusID, TrainingEventStatus, ReasonStatusChanged,
           ModifiedByAppUserID, ModifiedDate
      FROM training.TrainingEventStatusLogView
     WHERE TrainingEventStatusLogID = @TrainingEventStatusLogID
  ORDER BY ModifiedDate DESC;

END
