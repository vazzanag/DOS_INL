CREATE VIEW [messaging].[MessageThreadParticipantsView]
AS
	SELECT 
		mt.MessageThreadID,
		mt.MessageThreadTitle, 
		mt.ThreadContextTypeID,
		mt.ThreadContextID,
		mtp.AppUserID, 
		au.[First], 
		au.Middle, 
		au.[Last], 
		mtp.Subscribed,
		DateLastViewed,
		COUNT(mtm.MessageThreadID) AS NumUnreadMessages,
		CASE 
			WHEN mt.ThreadContextTypeID = 1 THEN
				(SELECT tev.TrainingUnitID from [training].[TrainingEvents] tev WHERE TEV.TrainingEventID = mt.ThreadContextID)
			WHEN mt.ThreadContextTypeID = 2 THEN
				(SELECT tev.TrainingUnitID from [training].[TrainingEvents] tev INNER JOIN  [vetting].[VettingBatches] VBT ON TEV.TrainingEventID = VBT.TrainingEventID
				WHERE VBT.VettingBatchID = mt.ThreadContextID)
			WHEN mt.ThreadContextTypeID = 3 THEN
				(SELECT tev.TrainingUnitID from [training].[TrainingEvents] tev INNER JOIN  [training].[TrainingEventParticipants] tes ON TEV.TrainingEventID = tes.TrainingEventID AND tes.TrainingEventParticipantTypeID != 2 -- All students
				WHERE tes.TrainingEventParticipantID = mt.ThreadContextID)
			WHEN mt.ThreadContextTypeID = 4 THEN
				(SELECT tev.TrainingUnitID from [training].[TrainingEvents] tev INNER JOIN   [training].[TrainingEventParticipants] TEI ON TEV.TrainingEventID = TEI.TrainingEventID AND TEI.TrainingEventParticipantTypeID = 2 -- Instructors
				WHERE TEI.TrainingEventParticipantID = mt.ThreadContextID)
			ELSE 0
		END AS 'BusinessUnitID'	
	FROM [messaging].MessageThreadParticipants mtp 
	INNER JOIN [users].AppUsers au ON mtp.AppUserID = au.AppUserID
	INNER JOIN [messaging].MessageThreads mt ON mtp.MessageThreadID = mt.MessageThreadID
	LEFT JOIN [messaging].MessageThreadMessages mtm ON mtp.MessageThreadID = mtm.MessageThreadID AND mtp.DateLastViewed < mtm.SentTime
	GROUP BY
		mt.MessageThreadID,
		mt.MessageThreadTitle, 
		mt.ThreadContextTypeID,
		mt.ThreadContextID,
		mtp.AppUserID, 
		au.[First], 
		au.Middle, 
		au.[Last], 
		mtp.Subscribed,
		DateLastViewed;
