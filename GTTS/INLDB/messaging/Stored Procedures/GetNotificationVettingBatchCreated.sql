CREATE PROCEDURE [messaging].[GetNotificationVettingBatchCreated]
    @VettingBatchID BIGINT    
AS
BEGIN

	SELECT vb.VettingBatchID,
		vb.VettingBatchTypeID,
		vbt.Code AS VettingBatchType,
		tev.[Name], 
		OrganizerAppUserID,
		tev.EventStartDate,
		tev.EventEndDate, 				
		usv.FullName AS SubmittedBy,
		(SELECT Count(PersonsVettingID) FROM vetting.PersonsVetting WHERE VettingBatchID = vb.VettingBatchID) AS ParticipantsCount,		

		-- Stakeholders 
           (SELECT b.AppUserID
              FROM training.TrainingEventStakeholdersView b
             WHERE b.TrainingEventID = tev.TrainingEventID FOR JSON PATH, INCLUDE_NULL_VALUES) StakeholdersJSON

	FROM vetting.VettingBatches vb
		INNER JOIN [training].[TrainingEventsView] tev 
			ON vb.TrainingEventID = tev.TrainingEventID
		INNER JOIN vetting.VettingBatchTypes vbt
			ON vbt.VettingBatchTypeID = vb.VettingBatchTypeID
		INNER JOIN users.AppUsersView usv
			ON usv.AppUserID = vb.AppUserIDSubmitted
	where vb.VettingBatchID = @VettingBatchID;

END;