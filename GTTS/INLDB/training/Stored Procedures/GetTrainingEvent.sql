CREATE PROCEDURE training.GetTrainingEvent
    @TrainingEventID BIGINT
AS
BEGIN
    SELECT TrainingEventID, [Name], NameInLocalLang, TrainingEventTypeID, TrainingEventTypeName, Justification, Objectives, ParticipantProfile, 
           SpecialRequirements, ProgramID, KeyActivitiesJSON, TrainingUnitID, BusinessUnitName, BusinessUnitAcronym, CountryID, PostID, 
           ConsularDistrictID, OrganizerAppUserID, PlannedParticipantCnt, PlannedMissionDirectHireCnt, PlannedNonMissionDirectHireCnt, 
           PlannedMissionOutsourceCnt, PlannedOtherCnt, ActualBudget, EstimatedBudget, EstimatedStudents, FundingSourceID, AuthorizingLawID, Comments, 
           ModifiedByAppUserID, ModifiedDate, EventStartDate,  EventEndDate, TravelStartDate, TravelEndDate, ParticipantCountsJSON, TrainingEventStatusID, 
           TrainingEventStatus, ModifiedByUserJSON, ProjectCodesJSON,  LocationsJSON, IAAsJSON, USPartnerAgenciesJSON, StakeholdersJSON, AttachmentsJSON, OrganizerJSON
      FROM training.TrainingEventsDetailView 
     WHERE TrainingEventID = @TrainingEventID;
END