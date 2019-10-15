using System;
using System.Collections.Generic;
using INL.PersonService.Models;

namespace INL.TrainingService.Models
{
    public class SaveTrainingEventPersonParticipant_Param : ISaveTrainingEventPersonParticipant_Param
    {
        public long? ParticipantID { get; set; }
        public long? PersonID { get; set; }      
        public string ParticipantType { get; set; }
        public string FirstMiddleNames { get; set; }
        public string LastNames { get; set; }
        public char Gender { get; set; }
        public int UnitID { get; set; }
        public bool IsUSCitizen { get; set; }
        public string NationalID { get; set; }
        public string ResidenceStreetAddress { get; set; }
        public int? ResidenceCityID { get; set; }
        public string ContactEmail { get; set; }
        public string ContactPhone { get; set; }
        public DateTime? DOB { get; set; }
        public int? POBCityID { get; set; }
        public int? POBStateID { get; set; }
        public string FatherName { get; set; }
        public string MotherName { get; set; }
        public int? HighestEducationID { get; set; }
        public decimal? FamilyIncome { get; set; }
        public int? EnglishLanguageProficiencyID { get; set; }
        public string PassportNumber { get; set; }
        public DateTime? PassportExpirationDate { get; set; }
        public int? PassportIssuingCountryID { get; set; }
        public string PoliceMilSecID { get; set; }
        public string HostNationPOCName { get; set; }
        public string HostNationPOCEmail { get; set; }
        public string JobTitle { get; set; }
        public int? RankID { get; set; }
        public int? YearsInPosition { get; set; }
        public bool? MedicalClearanceStatus { get; set; }
        public DateTime? MedicalClearanceDate { get; set; }
        public bool? DentalClearanceStatus { get; set; }
        public DateTime? DentalClearanceDate { get; set; }
        public bool? PsychologicalClearanceStatus { get; set; }
        public DateTime? PsychologicalClearanceDate { get; set; }
        public long? TrainingEventID { get; set; }
        public int? TrainingEventGroupID { get; set; }
        public bool? IsVIP { get; set; }
        public bool? IsParticipant { get; set; }
        public bool? IsTraveling { get; set; }
        public int? DepartureCityID { get; set; }
        public DateTime? DepartureDate { get; set; }
        public DateTime? ReturnDate { get; set; }
        public int? VettingPersonStatusID { get; set; }
        public int? VettingStatusID { get; set; }
        public int? VisaStatusID { get; set; }
        public bool HasLocalGovTrust { get; set; }
        public bool? PassedLocalGovTrust { get; set; }
        public DateTime? LocalGovTrustCertDate { get; set; }
        public bool OtherVetting { get; set; }
        public bool? PassedOtherVetting { get; set; }
        public string OtherVettingDescription { get; set; }
        public DateTime? OtherVettingDate { get; set; }
        public int? PaperworkStatusID { get; set; }
        public int? TravelDocumentStatusID { get; set; }
        public bool? RemovedFromEvent { get; set; }
        public string ReasonRemoved { get; set; }
        public string ReasonSpecific { get; set; }
        public DateTime? DateCanceled { get; set; }
        public string Comments { get; set; }
        public int? ModifiedByAppUserID { get; set; }
        public bool IsVettingReq { get; set; }
        public bool IsLeahyVettingReq { get; set; }
        public bool IsArmedForces { get; set; }
        public bool IsLawEnforcement { get; set; }
        public bool IsSecurityIntelligence { get; set; }
        public bool IsValidated { get; set; }
        public bool? ExactMatch { get; set; }
        public bool? IsUnitCommander { get; set; }

        public List<PersonLanguage_Item> Languages { get; set; }
    }
}
