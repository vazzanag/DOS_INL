using System;
using System.Collections.Generic;
using System.Text;

namespace INL.UnitLibraryService.Models
{
    public interface IUpdateUnitActiveFlag_Param
    {
        long UnitID { get; set; }
        bool IsActive { get; set; }
    }
}
