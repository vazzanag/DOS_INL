CREATE PROCEDURE [training].[GetTrainingEventVisaCheckLists]
	@TrainingEventID int
AS
BEGIN
	SELECT PersonID, TrainingEventID, TrainingEventVisaCheckListID, FirstMiddleNames, LastNames, AgencyName, VettingStatus, HasHostNationCorrespondence, 
		   HasUSGCorrespondence, IsApplicationComplete, ApplicationSubmittedDate, HasPassportAndPhotos,  VisaStatus, TrackingNumber, Comments
		FROM training.TrainingEventVisaCheckListsView 
	WHERE TrainingEventID = @TrainingEventID 
END
