CREATE PROCEDURE [training].[GetTrainingEventStudentsByTrainingEventID]
    @TrainingEventID BIGINT,
    @TrainingEventGroupID BIGINT = NULL
AS
BEGIN
    /* DEPRICATED: Use traininGetTrainingEventParticipants */
    SELECT ParticipantType, TrainingEventID, TrainingEventParticipantID, IsParticipant, RemovedFromEvent,
            DepartureCity, DepartureDate, ReturnDate, PersonID, PersonsVettingID, IsTraveling, OnboardingComplete, VisaStatusID, VisaStatus, 
           FirstMiddleNames, LastNames, Gender, ContactEmail, DOB, TrainingEventGroupID, GroupName, 
           VettingPersonStatusID, VettingPersonStatus, VettingPersonStatusDate, VettingBatchTypeID, VettingBatchType, 
           VettingBatchStatusID, VettingBatchStatus, VettingBatchStatusDate,
           JobTitle, RankName, AgencyName, AgencyNameEnglish, UnitName, UnitNameEnglish, UnitParentName, UnitParentNameEnglish,
           IsLeahyVettingReq, IsVettingReq, IsValidated, UnitID, DocumentCount, CourtesyVettingsJSON
      FROM training.TrainingEventParticipantsView
     WHERE TrainingEventID = @TrainingEventID
       AND ParticipantType = 'Student'
       AND ISNULL(TrainingEventGroupID,0) = 	
			CASE 
				WHEN ISNULL(@TrainingEventGroupID, 0)= 0 THEN ISNULL(TrainingEventGroupID,0)
				ELSE @TrainingEventGroupID
			END;

END;