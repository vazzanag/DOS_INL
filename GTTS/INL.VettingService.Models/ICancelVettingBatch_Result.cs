using INL.Services.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public interface ICancelVettingBatch_Result : IBaseResult
    {
        List<long> VettingBatchID { get; set; }
    }
}

