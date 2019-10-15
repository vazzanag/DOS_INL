using System;
using System.Collections.Generic;
using System.Text;

namespace INL.UnitLibraryService.Models
{
    public class GetUnitLocation_Item : IGetUnitLocation_Item
    {
        public long LocationID { get; set; }
        public string LocationName { get; set; }
        public string AddressLine1 { get; set; }
        public string AddressLine2 { get; set; }
        public string AddressLine3 { get; set; }
        public int StateID { get; set; }
        public int CityID { get; set; }
        public bool IsActive { get; set; }
        public int ModifiedByAppUserID { get; set; }
    }
}
