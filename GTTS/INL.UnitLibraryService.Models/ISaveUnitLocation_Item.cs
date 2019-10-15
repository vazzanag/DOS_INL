using System;
using System.Collections.Generic;
using System.Text;

namespace INL.UnitLibraryService.Models
{
    public interface ISaveUnitLocation_Item
    {
        int CityID { get; set; }
        string Address1 { get; set; }
        string Address2 { get; set; }
        string Address3 { get; set; }
        int ModifiedByAppUserID { get; set; }
        int? CountryID { get; set; }
        int? StateID { get; set; }
    }
}
