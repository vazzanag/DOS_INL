using System;
using System.Collections.Generic;
using System.Text;
using INL.Services.Models;

namespace INL.VettingService.Models
{
    public interface IGetCourtesyBatch_Result : IBaseResult
    {
        ICourtesyBatch_Item item { get; set; }
    }
}
