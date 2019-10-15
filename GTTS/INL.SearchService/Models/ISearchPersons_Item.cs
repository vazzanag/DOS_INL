using System;

namespace INL.SearchService.Models
{
    public interface ISearchPersons_Item
    {
        long PersonID { get; set; }
        string FirstMiddleNames { get; set; }
        string LastNames { get; set; }
        string ParticipantType { get; set; }
        string VettingStatus { get; set; }
        DateTime? VettingStatusDate { get; set; }
        string VettingTypeCode { get; set; }
        long? UnitID { get; set; }
        string UnitName { get; set; }
        string UnitNameEnglish { get; set; }
        string AgencyName { get; set; }
        string AgencyNameEnglish { get; set; }
        DateTime? DOB { get; set; }
        string Distinction { get; set; }
        char Gender { get; set; }
        string JobRank { get; set; }
        string JobTitle { get; set; }
        int? CountryID { get; set; }
        string CountryName { get; set; }
        DateTime? VettingValidEndDate { get; set; }
        int RowNumber { get; set; }
    }
}
