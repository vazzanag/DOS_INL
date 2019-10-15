using INL.Services.Models;
using System.Collections.Generic;

namespace INL.VettingService.Models
{
    public class SaveVettingBatches_Result : BaseResult, ISaveVettingBatches_Result
    {
        public List<IVettingBatch_Item> Batches { get; set; }
    }
}
