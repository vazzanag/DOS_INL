using System;
using System.Collections.Generic;

namespace INL.UnitLibraryService.Models
{
    public class GetUnit_Result : IGetUnit_Result
    {
        public IUnit_Item UnitItem { get; set; }
    }
}
