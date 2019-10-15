using INL.Services.Models;
namespace INL.VettingService.Models
{
    public class UpdateVettingBatch_Result : BaseResult, IUpdateVettingBatch_Result
    {
        public IVettingBatch_Item Batch { get; set; }
    }
}
