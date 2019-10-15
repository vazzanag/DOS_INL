using System;
using System.Collections.Generic;
using System.Text;
using INL.Services.Models;

namespace INL.VettingService.Models
{
    public class CancelVettingBatch_Result : BaseResult, ICancelVettingBatch_Result
    {
        public List<long> VettingBatchID { get; set; }
    }
}
