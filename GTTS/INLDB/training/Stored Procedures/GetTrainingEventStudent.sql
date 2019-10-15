CREATE PROCEDURE [training].[GetTrainingEventStudent]
	@TrainingEventStudentID BIGINT
AS
BEGIN
	SELECT ParticipantID, ParticipantType, PersonID, FirstMiddleNames, LastNames, DOB, Gender, UnitID, IsUSCitizen, NationalID,
		   ContactEmail, ContactPhone, RankID , RankName, UnitName, UnitNameEnglish, UnitParentName, UnitParentNameEnglish, UnitTypeID, UnitType,
           AgencyName, AgencyNameEnglish, UnitMainAgencyID, TrainingEventID, IsVIP, IsParticipant, IsTraveling, IsLeahyVettingReq, IsVettingReq, IsValidated,
		   ResidenceCountryID, ResidenceStreetAddress, ResidenceStateID, ResidenceCityID, POBCountryID, POBStateID, POBCityID,
		   DepartureCountryID, DepartureStateID, DepartureState, DepartureCityID, DepartureCity, DepartureDate, ReturnDate,
           FatherName, MotherName, HighestEducationID, FamilyIncome, EnglishLanguageProficiencyID, PassportNumber,
           PassportExpirationDate, PoliceMilSecID, JobTitle, YearsInPosition, MedicalClearanceStatus,
           MedicalClearanceDate, PsychologicalClearanceStatus, PsychologicalClearanceDate, IsParticipant, IsTraveling,
		   VettingPersonStatusID, VettingPersonStatus, VettingBatchTypeID, VettingBatchType, VettingPersonStatusDate, VisaStatusID, 
           HasLocalGovTrust, PassedLocalGovTrust, LocalGovTrustCertDate, OtherVetting, PassedOtherVetting, 
		   VettingPersonStatusID, VettingPersonStatus, VettingBatchTypeID, VettingBatchType, VettingPersonStatusDate, VisaStatusID, 
           HasLocalGovTrust, PassedLocalGovTrust, LocalGovTrustCertDate, OtherVetting, PassedOtherVetting, 
		   OtherVettingDescription, OtherVettingDate, PaperworkStatusID, TravelDocumentStatusID, RemovedFromEvent, 
		   RemovalReasonID, RemovalReason, RemovalCauseID, RemovalCause,
		   DateCanceled, Comments, ModifiedByAppUserID, ModifiedDate, PersonLanguagesJSON	
	  FROM training.TrainingEventParticipantsDetailView
	 WHERE ParticipantID = @TrainingEventStudentID
       AND ParticipantType = 'Student';
END
