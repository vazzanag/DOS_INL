CREATE PROCEDURE [training].[GetTrainingEventInstructor]
	@TrainingEventInstructorID BIGINT
AS
BEGIN
	SELECT ParticipantID, PersonID, TrainingEventID, IsTraveling,
		   DepartureCountryID, DepartureStateID, DepartureCityID, DepartureDate, ReturnDate, IsTraveling,
		   VisaStatusID, PaperworkStatusID, TravelDocumentStatusID, RemovedFromEvent, RemovalReasonID, RemovalReason, RemovalCauseID, RemovalCause,
		   DateCanceled, Comments, ModifiedByAppUserID, ModifiedDate	
	  FROM training.TrainingEventParticipantsDetailView
	 WHERE ParticipantID = @TrainingEventInstructorID
       AND ParticipantType = 'Instructor';
END
