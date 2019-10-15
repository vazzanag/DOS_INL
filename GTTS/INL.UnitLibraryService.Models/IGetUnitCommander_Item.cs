using System;
using System.Collections.Generic;
using System.Text;

namespace INL.UnitLibraryService.Models
{
    public interface IGetUnitCommander_Item
    {
        long PersonID { get; set; }
        long UnitID { get; set; }
        string FirstMiddleNames { get; set; }
        string LastNames { get; set; }
        char Gender { get; set; }
        int ModifiedByAppUserID { get; set; }
    }
}
