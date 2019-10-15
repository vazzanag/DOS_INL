using System;

namespace INL.UnitLibraryService.Models
{
    public class ReportingType_Item
    {
        public int ReportingTypeID { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public int CountryID { get; set; }
        public string Post { get; set; }
        public bool IsActive { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
    }
}
