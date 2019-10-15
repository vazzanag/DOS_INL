using System;
using System.Collections.Generic;
using System.Text;

namespace INL.UnitLibraryService.Models
{
    public class SaveUnitLocation_Item : ISaveUnitLocation_Item
    {
        public int CityID { get; set; }
        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string Address3 { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public int? CountryID { get; set; }
        public int? StateID { get; set; }
    }
}
