using System;
using System.Collections.Generic;
using System.Text;
using INL.Services.Models;

namespace INL.UnitLibraryService.Models
{
    public class GetNextUnitGenID_Result : BaseResult, IGetNextUnitGenID_Result
    {
        public string UnitGenID { get; set; }
    }
}
