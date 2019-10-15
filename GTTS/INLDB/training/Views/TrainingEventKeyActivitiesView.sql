CREATE VIEW [training].[TrainingEventKeyActivitiesView]
AS
    SELECT t.KeyActivityID, t.TrainingEventID, k.Code, k.[Description], t.ModifiedByAppUserID, t.ModifiedDate
      FROM training.TrainingEventKeyActivities t
INNER JOIN training.KeyActivities k ON t.KeyActivityID = k.KeyActivityID