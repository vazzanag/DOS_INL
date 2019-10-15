CREATE PROCEDURE training.GetTrainingEvents
AS
BEGIN
    SELECT TrainingEventID, [Name], NameInLocalLang, TrainingEventType, ProgramID, 
           BusinessUnit, BusinessUnitAcronym, OrganizerAppUserID, Organizer, 
           EventStartDate,  EventEndDate, TrainingEventStatusID, TrainingEventStatus, ModifiedByAppUserID, 
           ModifiedDate, ModifiedByAppUser, LocationsJSON, KeyActivitiesJSON
      FROM training.TrainingEventsView
  ORDER BY EventStartDate;
END