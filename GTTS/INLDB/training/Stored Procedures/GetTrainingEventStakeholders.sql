CREATE PROCEDURE [training].[GetTrainingEventStakeholders]
    @TrainingEventID bigint
AS
BEGIN
    SELECT TrainingEventID, AppUserID,
           [First], [Middle], [Last], FullName     
      FROM training.TrainingEventStakeholdersView s
     WHERE TrainingEventID = @TrainingEventID;
END
