using System;
using System.Collections.Generic;
using INL.PersonService.Models;

namespace INL.TrainingService.Models
{
    public class GetTrainingEventBatchParticipants_Item : IGetTrainingEventBatchParticipants_Item
    {
        public long ParticipantID { get; set; }
        public long TrainingEventParticipantID { get; set; }
        public long PersonID { get; set; }
        public string ParticipantType { get; set; }
        public long? PersonsUnitLibraryInfoID { get; set; }
        public int Ordinal { get; set; }
        public string FirstMiddleNames { get; set; }
        public string LastNames { get; set; }
        public char Gender { get; set; }
        public int UnitID { get; set; }
        public string UnitName { get; set; }
        public string UnitNameEnglish { get; set; }
        public string UnitParentName { get; set; }
        public string UnitParentNameEnglish { get; set; }
        public long UnitTypeID { get; set; }
        public string UnitType { get; set; }
        public string AgencyName { get; set; }
        public string AgencyNameEnglish { get; set; }
        public long? UnitMainAgencyID { get; set; }
        public bool IsUSCitizen { get; set; }
        public string NationalID { get; set; }
        public int ResidenceCountryID { get; set; }
        public string ResidenceStreetAddress { get; set; }
        public int ResidenceStateID { get; set; }
        public int ResidenceCityID { get; set; }
        public int POBCountryID { get; set; }
        public int POBStateID { get; set; }
        public int POBCityID { get; set; }
        public int DepartureCountryID { get; set; }
        public int DepartureStateID { get; set; }
        public int DepartureCityID { get; set; }
        public string ContactEmail { get; set; }
        public string ContactPhone { get; set; }
        public DateTime? DOB { get; set; }
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
        public string RankName { get; set; }
        public int? YearsInPosition { get; set; }
        public bool? MedicalClearanceStatus { get; set; }
        public DateTime? MedicalClearanceDate { get; set; }
        public bool? PsychologicalClearanceStatus { get; set; }
        public DateTime? PsychologicalClearanceDate { get; set; }
        public long TrainingEventID { get; set; }
        public long? TrainingEventGroupID { get; set; }
        public string GroupName { get; set; }
        public bool IsVIP { get; set; }
        public bool IsParticipant { get; set; }
        public bool IsTraveling { get; set; }
        public string DepartureCity { get; set; }
        public string DepartureState { get; set; }
        public DateTime? DepartureDate { get; set; }
        public DateTime? ReturnDate { get; set; }
        public int? VettingPersonStatusID { get; set; }
        public string VettingPersonStatus { get; set; }
        public DateTime? VettingPersonStatusDate { get; set; }
        public byte? VettingBatchTypeID { get; set; }
        public string VettingBatchType { get; set; }
        public long? VettingTrainingEventID { get; set; }
        public string VettingTrainingEventName { get; set; }
        public int? VettingBatchStatusID { get; set; }
        public string VettingBatchStatus { get; set; }
        public DateTime? VettingBatchStatusDate { get; set; }
        public long? PersonsVettingID { get; set; }
        public int? VisaStatusID { get; set; }
        public string VisaStatus { get; set; }
        public int? PaperworkStatusID { get; set; }
        public int? TravelDocumentStatusID { get; set; }
        public bool RemovedFromEvent { get; set; }
        public int? RemovalReasonID { get; set; }
        public string RemovalReason { get; set; }
        public int? RemovalCauseID { get; set; }
        public string RemovalCause { get; set; }
        public string TrainingEventRosterDistinction { get; set; }
        public DateTime? DateCanceled { get; set; }
        public string Comments { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
        public bool HasLocalGovTrust { get; set; }
        public bool? PassedLocalGovTrust { get; set; }
        public DateTime? LocalGovTrustCertDate { get; set; }
        public bool OtherVetting { get; set; }
        public bool? PassedOtherVetting { get; set; }
        public string OtherVettingDescription { get; set; }
        public DateTime? OtherVettingDate { get; set; }
        public bool IsVettingReq { get; set; }
        public bool IsLeahyVettingReq { get; set; }
        public bool IsArmedForces { get; set; }
        public bool IsLawEnforcement { get; set; }
        public bool IsSecurityIntelligence { get; set; }
        public bool IsValidated { get; set; }
        public bool? IsInVettingProcess { get; set; }
        public string WorkEmailAddress { get; set; }
        public bool IsUnitCommander { get; set; }
        public int DocumentCount { get; set; }
        public bool OnboardingComplete { get; set; }
        public bool RemovedFromVetting { get; set; }

        public DateTime? CreatedDate { get; set; }
        public bool? IsReVetting { get; set; }

        public List<CourtesyVettings_Item> CourtesyVettings { get; set; }
        public List<PersonLanguage_Item> Languages { get; set; }
    }
}
