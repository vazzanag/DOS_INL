CREATE PROCEDURE [training].[GetTrainingEventParticipantByPersonIDAndTrainingEventID]
	@PersonID BIGINT,
	@TrainingEventID BIGINT
AS
BEGIN
	SELECT ParticipantID, ParticipantType, PersonID, FirstMiddleNames, LastNames, DOB, Gender, UnitID, IsUSCitizen, NationalID,
		   ContactEmail, ContactPhone, RankID , RankName, UnitName, UnitNameEnglish, UnitParentName, UnitParentNameEnglish, UnitTypeID, UnitType,
           AgencyName, AgencyNameEnglish, UnitMainAgencyID, TrainingEventID, IsVIP, IsParticipant, IsTraveling, IsLeahyVettingReq, IsVettingReq, IsValidated,
		   HostNationPOCName, HostNationPOCEmail, ResidenceCountryID, ResidenceStreetAddress, ResidenceStateID, ResidenceCityID, POBCountryID, POBStateID, POBCityID,
		   DepartureCountryID, DepartureStateID, DepartureState, DepartureCityID, DepartureCity, DepartureDate, ReturnDate,
           FatherName, MotherName, HighestEducationID, FamilyIncome, EnglishLanguageProficiencyID, PassportNumber,
           PassportExpirationDate, PassportIssuingCountryID, PoliceMilSecID, JobTitle, YearsInPosition, MedicalClearanceStatus,
           MedicalClearanceDate, PsychologicalClearanceStatus, PsychologicalClearanceDate, IsParticipant, IsTraveling,
		   VettingPersonStatusID, VettingPersonStatus, VettingBatchTypeID, VettingBatchType, VettingBatchStatusID, VettingPersonStatusDate, VisaStatusID, 
           HasLocalGovTrust, PassedLocalGovTrust, LocalGovTrustCertDate, OtherVetting, PassedOtherVetting, 
		   OtherVettingDescription, OtherVettingDate, PaperworkStatusID, TravelDocumentStatusID, RemovedFromEvent,
		   RemovalReasonID, RemovalReason, RemovalCauseID, RemovalCause, RemovedFromVetting, OnboardingComplete, CourtesyVettingsJSON,
		   DateCanceled, Comments, TrainingEventGroupID, GroupName, ModifiedByAppUserID, ModifiedDate, PersonLanguagesJSON, DocumentCount, PersonsUnitLibraryInfoID, 
		   IsUnitCommander, PersonsVettingID, VettingBatchStatus
	  FROM training.TrainingEventParticipantsDetailView
	 WHERE PersonID = @PersonID 
       AND TrainingEventID = @TrainingEventID
END
