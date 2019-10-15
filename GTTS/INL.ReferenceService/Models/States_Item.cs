using System;

namespace INL.ReferenceService.Models
{
    public class States_Item
    {
        public int StateID { get; set; }
        public string StateName { get; set; }
        public string StateCodeA2 { get; set; }
        public string Abbreviation { get; set; }
        public string INKCode { get; set; }
        public int CountryID { get; set; }
        public bool IsActive { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
    }
}
