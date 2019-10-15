using INL.Services.Models;
using System.Collections.Generic;

namespace INL.VettingService.Models
{
    public class SaveVettingBatches_Param : BaseParam, ISaveVettingBatches_Param
    {
        public SaveVettingBatches_Param() : base() { }
        public List<IVettingBatch_Item> Batches { get; set; }
    }
}
