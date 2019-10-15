using System;

namespace INL.SearchService.Models
{
    public interface IGetInstructors_Item
    {
        long PersonID { get; set; }
        string FirstMiddleNames { get; set; }
        string LastNames { get; set; }
        
        
        
        DateTime? DOB { get; set; }
        int CountryID { get; set; }
        string CountryName { get; set; }
        string CountryFullName { get; set; }
        string UnitName { get; set; }
        string UnitNameEnglish { get; set; }
        long? UnitMainAgencyID { get; set; }
        decimal? Rating { get; set; }
    }
}
