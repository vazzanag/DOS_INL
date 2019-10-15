CREATE VIEW [training].[TrainingEventGroupsView]
AS 
     SELECT 
		[TrainingEventGroupID] as TrainingEventGroupID,
		te.[TrainingEventID],
		te.[Name] as TrainingEventName,
		[GroupName],
		g.[ModifiedByAppUserID]
	FROM [training].[TrainingEventGroups] g
	INNER JOIN [training].[TrainingEvents] te ON te.TrainingEventID = g.TrainingEventID;