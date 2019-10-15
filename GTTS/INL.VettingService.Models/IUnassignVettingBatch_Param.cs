using INL.Services.Models;

namespace INL.VettingService.Models
{
    public interface IUnassignVettingBatch_Param : IBaseParam
    {
        long VettingBatchID { get; set; }
        long ModifiedByAppUserID { get; set; }
    }
}
