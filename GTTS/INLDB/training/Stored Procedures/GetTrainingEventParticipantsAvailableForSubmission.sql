CREATE PROCEDURE [training].[GetTrainingEventParticipantsAvailableForSubmission]
	@TrainingEventID BIGINT,
	@PostID BIGINT
AS
BEGIN
	SELECT PersonID, FirstMiddleNames, LastNames, DOB, Gender, UnitID, IsUSCitizen, NationalID,
			ContactEmail, ContactPhone, RankID , RankName, UnitName, UnitNameEnglish, TrainingEventID, IsVIP, IsParticipant, IsTraveling,
			ResidenceCountryID, ResidenceStreetAddress, ResidenceStateID, ResidenceCityID, POBCountryID, POBStateID, POBCityID,
			DepartureCountryID, DepartureStateID, DepartureCityID, DepartureDate, ReturnDate,
			FatherName, MotherName, HighestEducationID, FamilyIncome, EnglishLanguageProficiencyID, PassportNumber,
			PassportExpirationDate, PoliceMilSecID, JobTitle, YearsInPosition, MedicalClearanceStatus,
			MedicalClearanceDate, PsychologicalClearanceStatus, PsychologicalClearanceDate, ParticipantType, 
			VettingTrainingEventID, VettingTrainingEventName, 
			VettingPersonStatusID, VettingPersonStatus, VisaStatusID, HasLocalGovTrust, PassedLocalGovTrust, LocalGovTrustCertDate, OtherVetting, 
			PassedOtherVetting, OtherVettingDescription, OtherVettingDate, PaperworkStatusID, TravelDocumentStatusID, RemovedFromEvent, 
			RemovalReasonID, RemovalReason, RemovalCauseID, RemovalCause,
			DateCanceled, Comments, ModifiedByAppUserID, ModifiedDate, PersonLanguagesJSON, CanBeVetted, IsReVetting	
	  FROM (
				SELECT PersonID, FirstMiddleNames, LastNames, DOB, Gender, UnitID, IsUSCitizen, NationalID,
					   ContactEmail, ContactPhone, RankID , RankName, UnitName, UnitNameEnglish, TrainingEventID, IsVIP, IsParticipant, IsTraveling,
					   ResidenceCountryID, ResidenceStreetAddress, ResidenceStateID, ResidenceCityID, POBCountryID, POBStateID, POBCityID,
					   DepartureCountryID, DepartureStateID, DepartureCityID, DepartureDate, ReturnDate,
					   FatherName, MotherName, HighestEducationID, FamilyIncome, EnglishLanguageProficiencyID, PassportNumber,
					   PassportExpirationDate, PoliceMilSecID, JobTitle, YearsInPosition, MedicalClearanceStatus,
					   MedicalClearanceDate, PsychologicalClearanceStatus, PsychologicalClearanceDate, ParticipantType, 
					   VettingTrainingEventID, VettingTrainingEventName, 
					   VettingPersonStatusID, VettingPersonStatus, VisaStatusID, HasLocalGovTrust, PassedLocalGovTrust, LocalGovTrustCertDate, OtherVetting, 
					   PassedOtherVetting, OtherVettingDescription, OtherVettingDate, PaperworkStatusID, TravelDocumentStatusID, RemovedFromEvent, 
					   RemovalReasonID, RemovalReason, RemovalCauseID, RemovalCause,
					   DateCanceled, Comments, ModifiedByAppUserID, ModifiedDate, PersonLanguagesJSON, f.CanBeVetted, f.IsReVetting 
                       
				  FROM training.TrainingEventParticipantsDetailView
				  CROSS APPLY vetting.AvailableForVettingByTrainingEventIDAndPersonID(@TrainingEventID, PersonID, @PostID, CreatedDate) f
				 WHERE TrainingEventID = @TrainingEventID
                   AND IsUSCitizen = 0
                   AND (ISNULL(IsVettingReq,0) = 1 OR ISNULL(IsLeahyVettingReq,0) = 1)
				   AND ISNULL(RemovedFromEvent,0) = 0

		   ) x
	 WHERE CanBeVetted = 1

END
