CREATE PROCEDURE [training].[GetTrainingEventInstructorsByTrainingEventID]
	@TrainingEventID BIGINT,
    @TrainingEventGroupID BIGINT = NULL
AS
BEGIN
    /* DEPRICATED: Use training.GetTrainingEventParticipants */
	SELECT TrainingEventParticipantID, PersonID, TrainingEventID, IsTraveling, 
		   DepartureCity, DepartureDate, ReturnDate, IsTraveling, VisaStatusID, 
		   RemovedFromEvent
	  FROM training.TrainingEventParticipantsView
	 WHERE TrainingEventID = @TrainingEventID
       AND ParticipantType = 'Instructor'
       AND ISNULL(TrainingEventGroupID,0) = 	
			CASE 
				WHEN ISNULL(@TrainingEventGroupID, 0)= 0 THEN ISNULL(TrainingEventGroupID,0)
				ELSE @TrainingEventGroupID
			END;

END