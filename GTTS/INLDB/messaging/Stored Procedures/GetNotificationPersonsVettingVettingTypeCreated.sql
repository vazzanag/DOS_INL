CREATE PROCEDURE [messaging].[GetNotificationPersonsVettingVettingTypeCreated]
	 @VettingBatchID BIGINT    
AS
BEGIN

	SELECT  VettingBatchID, GTTSTrackingNumber, pvcounts.VettingTypeID, VettingType, Name, OrganizerAppUserID, EventStartDate, EventEndDate, 
	ParticipantsCount, tev.PostID,

	(select pvc.CourtesyCheckTimeFrame from vetting.PostVettingConfiguration pvc where pvc.PostID = tev.PostID) as CourtesyCheckTimeFrame,

	(
		SELECT apbur.AppUserID from [users].[AppUsersBusinessUnitsRolesView] apbur 
		WHERE apbur.AppRoleID = 4 
		AND apbur.Acronym = (SELECT pvtv.Code FROM vetting.PostVettingTypesView pvtv WHERE pvtv.PostID = tev.PostID and pvtv.VettingTypeID = pvcounts.VettingTypeID)
		FOR JSON PATH, INCLUDE_NULL_VALUES
	) CourtesyVettersJSON

	FROM (SELECT pv.VettingBatchID, vb.GTTSTrackingNumber, vb.TrainingEventID, pvvt.VettingTypeID, vt.Code as VettingType, 
		count(pv.PersonsVettingID) as ParticipantsCount
		FROM vetting.PersonsVetting pv inner join  vetting.VettingBatches vb on vb.VettingBatchID = pv.VettingBatchID
		INNER JOIN vetting.PersonsVettingVettingTypes pvvt on pvvt.PersonsVettingID = pv.PersonsVettingID
		INNER JOIN vetting.VettingTypes vt on vt.VettingTypeID = pvvt.VettingTypeID

		where pv.VettingBatchID = @VettingBatchID
		AND vt.Code not in ('POL','LEAHY')
		AND pvvt.CourtesyVettingSkipped = 0
		group by pv.VettingBatchID, vb.GTTSTrackingNumber, vb.TrainingEventID, pvvt.VettingTypeID, vt.Code) pvcounts	
	INNER JOIN [training].[TrainingEventsView] tev ON pvcounts.TrainingEventID = tev.TrainingEventID
	
END;