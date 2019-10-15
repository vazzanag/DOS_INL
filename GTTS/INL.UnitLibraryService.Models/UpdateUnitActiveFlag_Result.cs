using System;
using System.Collections.Generic;
using System.Text;

namespace INL.UnitLibraryService.Models
{
    public class UpdateUnitActiveFlag_Result : IUpdateUnitActiveFlag_Result
    {
        public IUnit_Item UnitItem { get; set; }
    }
}
