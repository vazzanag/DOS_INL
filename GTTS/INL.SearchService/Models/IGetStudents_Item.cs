using System;

namespace INL.SearchService.Models
{
    public interface IGetStudents_Item
    {
        long PersonID { get; set; }
        string FirstMiddleNames { get; set; }
        string LastNames { get; set; }
        
        
        
        DateTime? DOB { get; set; }
        char Gender { get; set; }
        string JobTitle { get; set; }
        int? JobRank { get; set; }
        int CountryID { get; set; }
        string CountryName { get; set; }
        string CountryFullName { get; set; }
        string UnitName { get; set; }
        string UnitNameEnglish { get; set; }
        long? UnitMainAgencyID { get; set; }
        string VettingStatus { get; set; }
        DateTime? VettingStatusDate { get; set; }
        string VettingType { get; set; }
        string Distinction { get; set; }
    }
}
