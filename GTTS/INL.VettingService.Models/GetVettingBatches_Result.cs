using INL.Services.Models;
using System.Collections.Generic;

namespace INL.VettingService.Models
{
    public class GetVettingBatches_Result : BaseResult, IGetVettingBatches_Result
    {
        public List<IVettingBatch_Item> Batches { get; set; }
    }
}
