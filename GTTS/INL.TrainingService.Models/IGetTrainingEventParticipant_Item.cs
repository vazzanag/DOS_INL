using System;
using System.Collections.Generic;
using INL.PersonService.Models;

namespace INL.TrainingService.Models
{
    public interface IGetTrainingEventParticipant_Item
    {
        long ParticipantID { get; set; }
        long TrainingEventParticipantID { get; set; }
        long PersonID { get; set; }
        string ParticipantType { get; set; }
        int Ordinal { get; set; }
        string FirstMiddleNames { get; set; }
        string LastNames { get; set; }
        char Gender { get; set; }
        int UnitID { get; set; }
        string UnitName { get; set; }
        string UnitNameEnglish { get; set; }
        string UnitParentName { get; set; }
        string UnitParentNameEnglish { get; set; }
        long UnitTypeID { get; set; }
        string UnitType { get; set; }
        string AgencyName { get; set; }
        string AgencyNameEnglish { get; set; }
        long? UnitMainAgencyID { get; set; }
        bool IsUSCitizen { get; set; }
        string NationalID { get; set; }
        int ResidenceCountryID { get; set; }
        string ResidenceStreetAddress { get; set; }
        int ResidenceStateID { get; set; }
        int ResidenceCityID { get; set; }
        int POBCountryID { get; set; }
        int POBStateID { get; set; }
        int POBCityID { get; set; }
        int DepartureCountryID { get; set; }
        int DepartureStateID { get; set; }
        int DepartureCityID { get; set; }
        string ContactEmail { get; set; }
        string ContactPhone { get; set; }
        DateTime? DOB { get; set; }
        string FatherName { get; set; }
        string MotherName { get; set; }
        int? HighestEducationID { get; set; }
        decimal? FamilyIncome { get; set; }
        int? EnglishLanguageProficiencyID { get; set; }
        string PassportNumber { get; set; }
        DateTime? PassportExpirationDate { get; set; }
        int? PassportIssuingCountryID { get; set; }
        string PoliceMilSecID { get; set; }
        string HostNationPOCName { get; set; }
        string HostNationPOCEmail { get; set; }
        string JobTitle { get; set; }
        int? RankID { get; set; }
        string RankName { get; set; }
        int? YearsInPosition { get; set; }
        bool? MedicalClearanceStatus { get; set; }
        DateTime? MedicalClearanceDate { get; set; }
        bool? PsychologicalClearanceStatus { get; set; }
        DateTime? PsychologicalClearanceDate { get; set; }
        long TrainingEventID { get; set; }
        long? TrainingEventGroupID { get; set; }
        string GroupName { get; set; }
        bool IsVIP { get; set; }
        bool IsParticipant { get; set; }
        bool IsTraveling { get; set; }
        string DepartureCity { get; set; }
        string DepartureState { get; set; }
        DateTime? DepartureDate { get; set; }
        DateTime? ReturnDate { get; set; }
        int? VettingPersonStatusID { get; set; }
        string VettingPersonStatus { get; set; }
        DateTime? VettingPersonStatusDate { get; set; }
        byte? VettingBatchTypeID { get; set; }
        long? VettingTrainingEventID { get; set; }
        string VettingTrainingEventName { get; set; }
        string VettingBatchType { get; set; }
        int? VettingBatchStatusID { get; set; }
        string VettingBatchStatus { get; set; }
        DateTime? VettingBatchStatusDate { get; set; }
        long? PersonsVettingID { get; set; }
        int? VisaStatusID { get; set; }
        string VisaStatus { get; set; }
        int? PaperworkStatusID { get; set; }
        int? TravelDocumentStatusID { get; set; }
        bool RemovedFromEvent { get; set; }
        int? RemovalReasonID { get; set; }
        string RemovalReason { get; set; }
        int? RemovalCauseID { get; set; }
        string RemovalCause { get; set; }
        string TrainingEventRosterDistinction { get; set; }
        DateTime? DateCanceled { get; set; }
        string Comments { get; set; }
        int ModifiedByAppUserID { get; set; }
        DateTime ModifiedDate { get; set; }
        bool HasLocalGovTrust { get; set; }
        bool? PassedLocalGovTrust { get; set; }
        DateTime? LocalGovTrustCertDate { get; set; }
        bool OtherVetting { get; set; }
        bool? PassedOtherVetting { get; set; }
        string OtherVettingDescription { get; set; }
        DateTime? OtherVettingDate { get; set; }
        bool IsVettingReq { get; set; }
        bool IsLeahyVettingReq { get; set; }
        bool IsArmedForces { get; set; }
        bool IsLawEnforcement { get; set; }
        bool IsSecurityIntelligence { get; set; }
        bool IsValidated { get; set; }
        int DocumentCount { get; set; }
        bool OnboardingComplete { get; set; }
        bool RemovedFromVetting { get; set; }
        long? PersonsUnitLibraryInfoID { get; set; }

        DateTime? CreatedDate { get; set; }

        List<PersonLanguage_Item> Languages { get; set; }
        List<CourtesyVettings_Item> CourtesyVettings { get; set; }
    }
}
