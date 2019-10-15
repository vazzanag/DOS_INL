using System;
using System.Collections.Generic;
using System.Text;

namespace INL.UnitLibraryService.Models
{
    public class GetUnitCommander_Item : IGetUnitCommander_Item
    {
        public long PersonID { get; set; }
        public long UnitID { get; set; }
        public string FirstMiddleNames { get; set; }
        public string LastNames { get; set; }
        public char Gender { get; set; }
        public int ModifiedByAppUserID { get; set; }
    }
}
