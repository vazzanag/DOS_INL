using INL.Services.Models;
using System.Collections.Generic;

namespace INL.VettingService.Models
{
    public interface IGetVettingBatches_Result : IBaseResult
    {
        List<IVettingBatch_Item> Batches { get; set; }
    }
}
