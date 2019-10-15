CREATE PROCEDURE [training].[GetTrainingEventParticipants]
	@TrainingEventID BIGINT,
    @TrainingEventGroupID BIGINT = NULL,
    @ParticipantType NVARCHAR(15) = NULL
AS
BEGIN
	SELECT TrainingEventParticipantID, ParticipantType, PersonID, FirstMiddleNames, LastNames, DOB, IsUSCitizen, Gender, UnitID, NationalID,
		   ContactEmail, RankName, UnitName, UnitNameEnglish, UnitParentName, UnitParentNameEnglish, 
           AgencyName, AgencyNameEnglish, TrainingEventID, IsParticipant, IsTraveling, IsLeahyVettingReq, IsVettingReq, IsValidated,
		   DepartureCity, DepartureDate, ReturnDate, JobTitle,  IsParticipant, IsTraveling, VettingPersonStatusID, 
		   CASE WHEN ISNULL(RemovedFromEvent, 0) = 0 THEN VettingPersonStatus ELSE 'Removed' END AS VettingPersonStatus, 
		   VettingPersonStatusDate, VettingBatchTypeID, VettingBatchType, VettingTrainingEventName,
           VettingBatchStatusID, VettingBatchStatus, VettingBatchStatusDate, PersonsVettingID, VisaStatusID, VisaStatus, RemovedFromEvent, 
		   OnboardingComplete, CourtesyVettingsJSON, TrainingEventGroupID, GroupName, DocumentCount, RemovedFromVetting, PersonsUnitLibraryInfoID, CreatedDate
	  FROM training.TrainingEventParticipantsView
	 WHERE TrainingEventID = @TrainingEventID
       AND ParticipantType = ISNULL(@ParticipantType, ParticipantType)
     AND ISNULL(TrainingEventGroupID,0) = 	
			CASE 
				WHEN ISNULL(@TrainingEventGroupID, 0)= 0 THEN ISNULL(TrainingEventGroupID,0)
				ELSE @TrainingEventGroupID
			END
END