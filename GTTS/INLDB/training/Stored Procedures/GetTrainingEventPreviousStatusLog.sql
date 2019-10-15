CREATE PROCEDURE [training].[GetTrainingEventPreviousStatusLog]
    @TrainingEventID BIGINT,
    @TrainingEventStatus NVARCHAR(100)
AS
BEGIN

    DECLARE @CurrentStatusID INT;

    -- Get Status ID
    IF NOT EXISTS(SELECT TrainingEventStatusID FROM training.TrainingEventStatuses WHERE [Name] = @TrainingEventStatus)
        THROW 50000,  'The specified status not exist.',  1
    ELSE
        SELECT @CurrentStatusID = TrainingEventStatusID FROM training.TrainingEventStatuses WHERE [Name] = @TrainingEventStatus

    -- Get Status Log record
    SELECT TOP 1 TrainingEventStatusLogID, TrainingEventID, TrainingEventStatusID, 
           TrainingEventStatus, ReasonStatusChanged, ModifiedByAppUserID, ModifiedDate
      FROM training.TrainingEventStatusLogView
     WHERE TrainingEventID = @TrainingEventID
       AND TrainingEventStatusID <> @CurrentStatusID
  ORDER BY ModifiedDate DESC

END
