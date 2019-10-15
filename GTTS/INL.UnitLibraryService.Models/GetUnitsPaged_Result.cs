using System;
using System.Collections.Generic;
using System.Text;

namespace INL.UnitLibraryService.Models
{
    public class GetUnitsPaged_Result : IGetUnitsPaged_Result
    {
        public List<IUnit_Item> Collection { get; set; }
    }
}
