CREATE PROCEDURE [training].[GetTrainingEventStatusLogs]
    @TrainingEventID BIGINT
AS
BEGIN

    SELECT TrainingEventStatusLogID, TrainingEventID, TrainingEventStatusID, TrainingEventStatus, ReasonStatusChanged,
           ModifiedByAppUserID, ModifiedDate
      FROM training.TrainingEventStatusLogView
     WHERE TrainingEventID = @TrainingEventID
  ORDER BY ModifiedDate DESC;

END
