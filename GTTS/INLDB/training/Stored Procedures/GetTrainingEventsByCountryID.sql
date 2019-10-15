CREATE PROCEDURE training.GetTrainingEventsCountryID
    @CountryID BIGINT

AS
BEGIN
    SELECT  TrainingEventID, [Name], NameInLocalLang, TrainingEventType, 
	        ProgramID, BusinessUnitAcronym, BusinessUnit, 
            EventStartDate, EventEndDate,
			OrganizerAppUserID, Organizer, 
			CountryID, PostID, TrainingEventStatusID, TrainingEventStatus,
			LocationsJSON, KeyActivitiesJSON, CreatedDate,
			ModifiedByAppUserID, ModifiedByAppUser,  
			ModifiedDate
      FROM training.TrainingEventsView
	  WHERE CountryID = @CountryID
  ORDER BY EventStartDate;
END