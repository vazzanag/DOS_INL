CREATE PROCEDURE [training].[GetPersonsTrainingEvents]
	@PersonID BIGINT,
    @TrainingEventStatus NVARCHAR(100) = NULL
AS
BEGIN
	SELECT ParticipantType, [Name], EventStartDate, EventEndDate, BusinessUnitAcronym, [Certificate], TrainingEventRosterDistinction, 
           TrainingEventID, TrainingEventStatus
	  FROM [training].[PersonsTrainingEventsView]
	 WHERE PersonID = @PersonID
       AND TrainingEventStatus = ISNULL(@TrainingEventStatus, TrainingEventStatus);
END
