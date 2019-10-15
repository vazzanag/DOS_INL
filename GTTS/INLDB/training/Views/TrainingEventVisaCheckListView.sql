CREATE VIEW [training].[TrainingEventVisaCheckListsView]
AS 
	SELECT tpv.PersonID, tpv.TrainingEventID, vc.TrainingEventVisaCheckListID, tpv.FirstMiddleNames, tpv.LastNames, tpv.AgencyName, tpv.VettingPersonStatus AS VettingStatus, vc.HasHostNationCorrespondence, 
		   vc.HasUSGCorrespondence, vc.IsApplicationComplete, vc.ApplicationSubmittedDate, vc.HasPassportAndPhotos, vs.Code as VisaStatus, vc.TrackingNumber, vc.Comments
	FROM training.TrainingEventParticipantsView tpv
	
	LEFT JOIN [training].[TrainingEventVisaCheckLists] vc on tpv.PersonID = vc.PersonID and tpv.TrainingEventID = vc.TrainingEventID
	LEFT JOIN training.VisaStatuses vs on vc.VisaStatusID = vs.VisaStatusID