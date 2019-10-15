CREATE PROCEDURE [messaging].[GetNotificationVettingBatchCourtesyCompleted]
	@VettingBatchID BIGINT,
	@VettingTypeID INT
AS
BEGIN

	SELECT vb.VettingBatchID,
		vt.VettingTypeID,
		vt.Code AS VettingType,
		vb.GTTSTrackingNumber,
		tev.[Name], 		
		tev.EventStartDate,
		tev.EventEndDate,
		vt.Code as VettingType, 						
		COUNT(pvvt.PersonsVettingID) as ParticipantsCount

	FROM vetting.VettingBatches vb
		INNER JOIN [training].[TrainingEventsView] tev 
			ON vb.TrainingEventID = tev.TrainingEventID
		INNER JOIN vetting.PersonsVetting pv
			ON pv.VettingBatchID = vb.VettingBatchID
		INNER JOIN vetting.PersonsVettingVettingTypes pvvt
			ON pvvt.PersonsVettingID = pv.PersonsVettingID
		INNER JOIN vetting.VettingTypes vt
			ON vt.VettingTypeID = pvvt.VettingTypeID
	WHERE vb.VettingBatchID = @VettingBatchID AND pvvt.VettingTypeID = @VettingTypeID AND pvvt.CourtesyVettingSkipped = 0

	GROUP BY vb.VettingBatchID, vt.VettingTypeID, vt.Code, vb.GTTSTrackingNumber, tev.[Name], tev.EventStartDate, tev.EventEndDate, vt.Code

END;