CREATE PROCEDURE [messaging].[GetNotificationVettingBatchResultsNotifiedWithRejections]
	@VettingBatchID BIGINT    
AS
BEGIN

	SELECT vb.VettingBatchID,
		vb.VettingBatchTypeID,
		vbt.Code AS VettingBatchType,
		vb.GTTSTrackingNumber,
		tev.[Name], 
		OrganizerAppUserID,
		vb.AppUserIDSubmitted,		
		tev.EventStartDate,
		tev.EventEndDate,			

		-- Stakeholders 
           (SELECT b.AppUserID
              FROM training.TrainingEventStakeholdersView b
             WHERE b.TrainingEventID = tev.TrainingEventID FOR JSON PATH, INCLUDE_NULL_VALUES) StakeholdersJSON,

		-- Rejected Participants - VettingPersonStatusID = 3
			( SELECT pvv.FirstMiddleNames, pvv.LastNames, unitlibrary.UnitBreakdownLocalLang(pvv.UnitID, 0, -1, 0, -1) as UnitBreakdownLocalLang FROM [vetting].[PersonsVettingView] pvv
			 
			WHERE pvv.VettingBatchID = @VettingBatchID and pvv.VettingPersonStatusID = 3 FOR JSON PATH, INCLUDE_NULL_VALUES) as RejectedParticipantsJSON
			 		
	FROM vetting.VettingBatches vb
		INNER JOIN [training].[TrainingEventsView] tev 
			ON vb.TrainingEventID = tev.TrainingEventID
		INNER JOIN vetting.VettingBatchTypes vbt
			ON vbt.VettingBatchTypeID = vb.VettingBatchTypeID		
	where vb.VettingBatchID = @VettingBatchID;

END