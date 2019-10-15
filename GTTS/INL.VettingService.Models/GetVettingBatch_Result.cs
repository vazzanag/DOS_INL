using INL.Services.Models;

namespace INL.VettingService.Models
{
    public class GetVettingBatch_Result : BaseResult, IGetVettingBatch_Result
    {
        public IVettingBatch_Item Batch { get; set; }
    }
}