using System;
using System.Collections.Generic;
using System.Text;

namespace INL.UnitLibraryService.Models
{
    public class GetUnits_Result : IGetUnits_Result
    {
        public List<IUnit_Item> Collection { get; set; }
    }
}
