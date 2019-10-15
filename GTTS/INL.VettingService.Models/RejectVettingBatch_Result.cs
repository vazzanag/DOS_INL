using INL.Services.Models;

namespace INL.VettingService.Models
{
    public class RejectVettingBatch_Result : BaseResult, IRejectVettingBatch_Result
    {
        public IVettingBatch_Item Batch { get; set; }
    }
}
