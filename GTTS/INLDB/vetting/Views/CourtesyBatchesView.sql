CREATE VIEW [vetting].[CourtesyBatchesView]
AS

	SELECT
		cb.CourtesyBatchID,
		cb.VettingBatchID,
		cb.VettingTypeID,  
		vt.Code AS VettingType,
		cb.VettingBatchNotes,	
		cb.AssignedToAppUserID,	
		assignedAppUser.FullName AS AssignedToAppUserName,
		cb.ResultsSubmittedDate,
		cb.ResultsSubmittedByAppUserID,
		resultsSubmittedAppUser.FullName AS ResultsSubmittedByAppUserName
	FROM vetting.CourtesyBatches	cb
	INNER JOIN vetting.VettingTypes vt
		ON vt.VettingTypeID = cb.VettingTypeID
	LEFT JOIN users.AppUsersView assignedAppUser
		ON assignedAppUser.AppUserID = cb.AssignedToAppUserID
	LEFT JOIN users.AppUsersView resultsSubmittedAppUser
		ON resultsSubmittedAppUser.AppUserID = cb.ResultsSubmittedByAppUserID
