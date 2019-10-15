using System;

namespace INL.SearchService.Models
{
    public interface ISearchParticipants_Item
    {
        string ParticipantType { get; set; }
        long PersonID { get; set; }
        string FirstMiddleNames { get; set; }
        string LastNames { get; set; }
        DateTime? DOB { get; set; }
        char? Gender { get; set; }
        string JobTitle { get; set; }
        string JobRank { get; set; }
        int? CountryID { get; set; }
        string CountryName { get; set; }
        string CountryFullName { get; set; }
        long? UnitID { get; set; }
        string UnitName { get; set; }
        string UnitNameEnglish { get; set; }
        long? UnitMainAgencyID { get; set; }
        string AgencyName { get; set; }
        string AgencyNameEnglish { get; set; }
        string VettingStatus { get; set; }
        DateTime? VettingStatusDate { get; set; }
        string VettingType { get; set; }
        string Distinction { get; set; }
        DateTime? EventStartDate { get; set; }
        long TrainingEventID { get; set; }
        long TrainingEventParticipantID { get; set; }
        bool? IsParticipant { get; set; }
        bool RemovedFromEvent { get; set; }
        string DepartureCity { get; set; }
        DateTime? DepartureDate { get; set; }
        DateTime? ReturnDate { get; set; }
        long? PersonsVettingID { get; set; }
        bool IsTraveling { get; set; }
        bool? OnboardingComplete { get; set; }
        int? VisaStatusID { get; set; }
        string VisaStatus { get; set; }
        string ContactEmail { get; set; }
        bool? IsUSCitizen { get; set; }
        long? TrainingEventGroupID { get; set; }
        string GroupName { get; set; }
        int? VettingPersonStatusID { get; set; }
        string VettingPersonStatus { get; set; }
        DateTime? VettingPersonStatusDate { get; set; }
        byte? VettingBatchTypeID { get; set; }
        string VettingBatchType { get; set; }
        int? VettingBatchStatusID { get; set; }
        string VettingBatchStatus { get; set; }
        DateTime? VettingBatchStatusDate { get; set; }
        bool? RemovedFromVetting { get; set; }
        string VettingTrainingEventName { get; set; }
        bool? IsLeahyVettingReq { get; set; }
        bool? IsVettingReq { get; set; }
        bool? IsValidated { get; set; }
        long? PersonsUnitLibraryInfoID { get; set; }
        string NationalID { get; set; }
        int? UnitTypeID { get; set; }
        string UnitAcronym { get; set; }
        string UnitParentName { get; set; }
        string UnitParentNameEnglish { get; set; }
        string UnitType { get; set; }
        int? DocumentCount { get; set; }
        string CourtesyVettingsJSON { get; set; }
    }
}
