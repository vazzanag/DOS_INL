using System;
using System.Collections.Generic;
using System.Text;

namespace INL.UnitLibraryService.Models
{
    public interface IGetUnitLocation_Item
    {
        long LocationID { get; set; }
        string LocationName { get; set; }
        string AddressLine1 { get; set; }
        string AddressLine2 { get; set; }
        string AddressLine3 { get; set; }
        int StateID { get; set; }
        int CityID { get; set; }
        bool IsActive { get; set; }
        int ModifiedByAppUserID { get; set; }
    }
}
