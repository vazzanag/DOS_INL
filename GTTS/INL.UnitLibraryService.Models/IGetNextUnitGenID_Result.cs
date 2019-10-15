using System;
using System.Collections.Generic;
using System.Text;
using INL.Services.Models;

namespace INL.UnitLibraryService.Models 
{
    public interface IGetNextUnitGenID_Result : IBaseResult
    {
        string UnitGenID { get; set; }
    }
}
