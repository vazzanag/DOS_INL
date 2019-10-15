using System;
using System.Collections.Generic;
using INL.PersonService.Models;

namespace INL.TrainingService.Models
{
    public interface ISaveTrainingEventPersonParticipant_Param
    {
        long? ParticipantID { get; set; }
        long? PersonID { get; set; }
        string ParticipantType { get; set; }
        string FirstMiddleNames { get; set; }
        string LastNames { get; set; }
        char Gender { get; set; }
        int UnitID { get; set; }
        bool IsUSCitizen { get; set; }
        string NationalID { get; set; }
        string ResidenceStreetAddress { get; set; }
        int? ResidenceCityID { get; set; }
        string ContactEmail { get; set; }
        string ContactPhone { get; set; }
        DateTime? DOB { get; set; }
        int? POBCityID { get; set; }
        int? POBStateID { get; set; }
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
        int? YearsInPosition { get; set; }
        bool? MedicalClearanceStatus { get; set; }
        DateTime? MedicalClearanceDate { get; set; }
        bool? DentalClearanceStatus { get; set; }
        DateTime? DentalClearanceDate { get; set; }
        bool? PsychologicalClearanceStatus { get; set; }
        DateTime? PsychologicalClearanceDate { get; set; }
        Int64? TrainingEventID { get; set; }
        int? TrainingEventGroupID { get; set; }
        bool? IsVIP { get; set; }
        bool? IsParticipant { get; set; }
        bool? IsTraveling { get; set; }
        int? DepartureCityID { get; set; }
        DateTime? DepartureDate { get; set; }
        DateTime? ReturnDate { get; set; }
        int? VettingStatusID { get; set; }
        int? VettingPersonStatusID { get; set; }
        int? VisaStatusID { get; set; }
        bool HasLocalGovTrust { get; set; }
        bool? PassedLocalGovTrust { get; set; }
        DateTime? LocalGovTrustCertDate { get; set; }
        bool OtherVetting { get; set; }
        bool? PassedOtherVetting { get; set; }
        string OtherVettingDescription { get; set; }
        DateTime? OtherVettingDate { get; set; }
        int? PaperworkStatusID { get; set; }
        int? TravelDocumentStatusID { get; set; }
        bool? RemovedFromEvent { get; set; }
        string ReasonRemoved { get; set; }
        string ReasonSpecific { get; set; }
        DateTime? DateCanceled { get; set; }
        string Comments { get; set; }
        bool IsVettingReq { get; set; }
        bool IsLeahyVettingReq { get; set; }
        bool IsArmedForces { get; set; }
        bool IsLawEnforcement { get; set; }
        bool IsSecurityIntelligence { get; set; }
        bool IsValidated { get; set; }
        int? ModifiedByAppUserID { get; set; }
        bool? ExactMatch { get; set; }
        bool? IsUnitCommander { get; set; }
        List<PersonLanguage_Item> Languages { get; set; }
    }
}
