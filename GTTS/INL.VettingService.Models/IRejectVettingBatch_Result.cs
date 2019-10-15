using INL.Services.Models;

namespace INL.VettingService.Models
{
    public interface IRejectVettingBatch_Result : IBaseResult
    {
        IVettingBatch_Item Batch { get; set; }
    }
}
