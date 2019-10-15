using System;

namespace INL.SearchService.Models
{
    public class SearchParticipants_Item : ISearchParticipants_Item
    {
        public string ParticipantType { get; set; }
        public long PersonID { get; set; }
        public string FirstMiddleNames { get; set; }
        public string LastNames { get; set; }
        public DateTime? DOB { get; set; }
        public char? Gender { get; set; }
        public string JobTitle { get; set; }
        public string JobRank { get; set; }
        public int? CountryID { get; set; }
        public string CountryName { get; set; }
        public string CountryFullName { get; set; }
        public long? UnitID { get; set; }
        public string UnitName { get; set; }
        public string UnitNameEnglish { get; set; }
        public long? UnitMainAgencyID { get; set; }
        public string AgencyName { get; set; }
        public string AgencyNameEnglish { get; set; }
        public string VettingStatus { get; set; }
        public DateTime? VettingStatusDate { get; set; }
        public string VettingType { get; set; }
        public string Distinction { get; set; }
        public DateTime? EventStartDate { get; set; }
        public long TrainingEventID { get; set; }
        public long TrainingEventParticipantID { get; set; }
        public bool? IsParticipant { get; set; }
        public bool RemovedFromEvent { get; set; }
        public string DepartureCity { get; set; }
        public DateTime? DepartureDate { get; set; }
        public DateTime? ReturnDate { get; set; }
        public long? PersonsVettingID { get; set; }
        public bool IsTraveling { get; set; }
        public bool? OnboardingComplete { get; set; }
        public int? VisaStatusID { get; set; }
        public string VisaStatus { get; set; }
        public string ContactEmail { get; set; }
        public bool? IsUSCitizen { get; set; }
        public long? TrainingEventGroupID { get; set; }
        public string GroupName { get; set; }
        public int? VettingPersonStatusID { get; set; }
        public string VettingPersonStatus { get; set; }
        public DateTime? VettingPersonStatusDate { get; set; }
        public byte? VettingBatchTypeID { get; set; }
        public string VettingBatchType { get; set; }
        public int? VettingBatchStatusID { get; set; }
        public string VettingBatchStatus { get; set; }
        public DateTime? VettingBatchStatusDate { get; set; }
        public bool? RemovedFromVetting { get; set; }
        public string VettingTrainingEventName { get; set; }
        public bool? IsLeahyVettingReq { get; set; }
        public bool? IsVettingReq { get; set; }
        public bool? IsValidated { get; set; }
        public long? PersonsUnitLibraryInfoID { get; set; }
        public string NationalID { get; set; }
        public int? UnitTypeID { get; set; }
        public string UnitAcronym { get; set; }
        public string UnitParentName { get; set; }
        public string UnitParentNameEnglish { get; set; }
        public string UnitType { get; set; }
        public int? DocumentCount { get; set; }
        public string CourtesyVettingsJSON { get; set; }
    }
}
