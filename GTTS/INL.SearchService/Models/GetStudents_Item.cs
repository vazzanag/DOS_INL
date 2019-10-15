using System;

namespace INL.SearchService.Models
{
    public class GetStudents_Item : IGetStudents_Item
    {
        public long PersonID { get; set; }
        public string FirstMiddleNames { get; set; }
        public string LastNames { get; set; }
        
        
        
        public DateTime? DOB { get; set; }
        public char Gender { get; set; }
        public string JobTitle { get; set; }
        public int? JobRank { get; set; }
        public int CountryID { get; set; }
        public string CountryName { get; set; }
        public string CountryFullName { get; set; }
        public string UnitName { get; set; }
        public string UnitNameEnglish { get; set; }
        public long? UnitMainAgencyID { get; set; }
        public string VettingStatus { get; set; }
        public DateTime? VettingStatusDate { get; set; }
        public string VettingType { get; set; }
        public string Distinction { get; set; }
    }
}
