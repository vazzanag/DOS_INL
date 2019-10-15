using INL.Services.Models;

namespace INL.VettingService.Models
{
    public interface IAssignVettingBatch_Result : IBaseResult
    {
        long VettingBatchID { get; set; }
    }
}
