UPDATE t 
SET t.CreatedDate = ISNULL(th.MinDate, t.ModifiedDate)
FROM training.TrainingEvents t
LEFT JOIN ( 
		SELECT TrainingEventID, MIN(SysStartTime) MinDate
		FROM training.TrainingEvents_History 
		GROUP BY TrainingEventID) th 
	ON t.TrainingEventID = th.TrainingEventID
WHERE t.CreatedDate IS NULL