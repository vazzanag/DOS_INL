using System;

namespace INL.SearchService.Models
{
    public class GetInstructors_Item : IGetInstructors_Item
    {
        public long PersonID { get; set; }
        public string FirstMiddleNames { get; set; }
        public string LastNames { get; set; }
        
        
        
        public DateTime? DOB { get; set; }
        public int CountryID { get; set; }
        public string CountryName { get; set; }
        public string CountryFullName { get; set; }
        public string UnitName { get; set; }
        public string UnitNameEnglish { get; set; }
        public long? UnitMainAgencyID { get; set; }
        public decimal? Rating { get; set; }
    }
}
