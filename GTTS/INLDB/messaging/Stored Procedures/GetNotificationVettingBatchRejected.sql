CREATE PROCEDURE [messaging].[GetNotificationVettingBatchRejected]
    @VettingBatchID BIGINT    
AS
BEGIN

	SELECT vb.VettingBatchID,
		vb.VettingBatchTypeID,
		vbt.Code AS VettingBatchType,
		tev.[Name], 
		OrganizerAppUserID,
		vb.AppUserIDSubmitted,
		vb.BatchRejectionReason,
		tev.EventStartDate,
		tev.EventEndDate,
		
		--Participants count not removed
		(SELECT count(pv1.PersonsVettingID) FROM vetting.PersonsVetting pv1 
		inner join vetting.VettingBatches vb1 on vb1.VettingBatchID = pv1.VettingBatchID
		inner join training.TrainingEventParticipantsView tepv on tepv.TrainingEventID = vb1.TrainingEventID and pv1.PersonsUnitLibraryInfoID = tepv.PersonsUnitLibraryInfoID
		where pv1.VettingBatchID = @VettingBatchID and isnull(pv1.RemovedFromVetting,0) = 0
		) AS ParticipantsCount,

		-- Stakeholders 
           (SELECT b.AppUserID
              FROM training.TrainingEventStakeholdersView b
             WHERE b.TrainingEventID = tev.TrainingEventID FOR JSON PATH, INCLUDE_NULL_VALUES) StakeholdersJSON

	FROM vetting.VettingBatches vb
		INNER JOIN [training].[TrainingEventsView] tev 
			ON vb.TrainingEventID = tev.TrainingEventID
		INNER JOIN vetting.VettingBatchTypes vbt
			ON vbt.VettingBatchTypeID = vb.VettingBatchTypeID		
	where vb.VettingBatchID = @VettingBatchID;

END;