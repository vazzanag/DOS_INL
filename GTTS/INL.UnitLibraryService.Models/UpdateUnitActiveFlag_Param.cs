using System;
using System.Collections.Generic;
using System.Text;

namespace INL.UnitLibraryService.Models
{
    public class UpdateUnitActiveFlag_Param : IUpdateUnitActiveFlag_Param
    {
        public long UnitID { get; set; }
        public bool IsActive { get; set; }
    }
}
