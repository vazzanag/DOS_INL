CREATE PROCEDURE [training].[GetTrainingEventInstructorByPersonIDAndTrainingEventID]
	@PersonID BIGINT,
	@TrainingEventID BIGINT
AS
BEGIN
	SELECT TrainingEventParticipantID AS TrainingEventInstructorID, PersonID, TrainingEventID, IsTraveling,
		   DepartureCountryID, DepartureStateID, DepartureCityID, DepartureDate, ReturnDate, IsTraveling,
		   VisaStatusID, PaperworkStatusID, TravelDocumentStatusID, RemovedFromEvent, RemovalReasonID, RemovalReason, RemovalCauseID, RemovalCause,
		   DateCanceled, Comments, ModifiedByAppUserID, ModifiedDate	
	  FROM training.TrainingEventInstructorsView
	 WHERE PersonID = @PersonID AND TrainingEventID = @TrainingEventID
END
