CREATE VIEW [training].[TrainingEventStatusLogView]
AS
    SELECT TrainingEventStatusLogID, TrainingEventID, l.TrainingEventStatusID, s.[Name] as TrainingEventStatus, ReasonStatusChanged,
           l.ModifiedByAppUserID, l.ModifiedDate
      FROM training.TrainingEventStatusLog l
INNER JOIN training.TrainingEventStatuses s ON l.TrainingEventStatusID = s.TrainingEventStatusID;