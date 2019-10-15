using INL.Services.Models;

namespace INL.VettingService.Models
{
    public interface IUnassignVettingBatch_Result : IBaseResult
    {
        long VettingBatchID { get; set; }
    }
}
