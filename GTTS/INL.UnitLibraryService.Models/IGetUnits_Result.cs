using System;
using System.Collections.Generic;
using System.Text;

namespace INL.UnitLibraryService.Models
{
    public interface IGetUnits_Result
    {
        List<IUnit_Item> Collection { get; set; }
    }
}
