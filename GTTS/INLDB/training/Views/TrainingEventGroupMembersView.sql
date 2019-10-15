CREATE VIEW [training].[TrainingEventGroupMembersView]
AS 
     SELECT 
		gm.[TrainingEventGroupID] as TrainingEventGroupID,
		g.GroupName,
		gm.PersonID,
		p.FirstMiddleNames,
		p.LastNames,
		te.[TrainingEventID],
		te.[Name] as TrainingEventName,
		gm.GroupMemberTypeID as MemberTypeID,
		gmt.[Name] as MemberType,
		g.[ModifiedByAppUserID]
	FROM [training].[TrainingEventGroupMembers] gm
	INNER JOIN [training].[TrainingEventGroups] g ON gm.TrainingEventGroupID = g.TrainingEventGroupID
	INNER JOIN [training].[TrainingEvents] te ON te.TrainingEventID = g.TrainingEventID
	INNER JOIN [persons].[Persons] p ON p.PersonID = gm.PersonID
	INNER JOIN [training].TrainingEventGroupMemberTypes gmt ON gmt.TrainingEventGroupMemberTypeID = gm.GroupMemberTypeID;