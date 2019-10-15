using INL.Services.Models;

namespace INL.VettingService.Models
{
    public interface IRejectVettingBatch_Param : IBaseParam
    {
        long? VettingBatchID { get; set; }
        string BatchRejectionReason { get; set; }
        int? ModifiedByAppUserID { get; set; }
    }
}
