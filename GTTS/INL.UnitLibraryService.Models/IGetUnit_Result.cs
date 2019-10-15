using System;
using System.Collections.Generic;

namespace INL.UnitLibraryService.Models
{
    public interface IGetUnit_Result
    {
        IUnit_Item UnitItem { get; set; }
    }
}
