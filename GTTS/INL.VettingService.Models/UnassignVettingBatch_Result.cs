using INL.Services.Models;

namespace INL.VettingService.Models
{
    public class UnassignVettingBatch_Result : BaseResult, IUnassignVettingBatch_Result
    {
        public long VettingBatchID { get; set; }
    }
}
