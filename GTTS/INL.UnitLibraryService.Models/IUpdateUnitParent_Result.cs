using INL.Services.Models;
using System;
using System.Collections.Generic;

namespace INL.UnitLibraryService.Models
{
    public interface IUpdateUnitParent_Result : IBaseResult
    {
        IUnit_Item UnitItem { get; set; }
    }
}
