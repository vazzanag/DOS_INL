using INL.Services.Models;

namespace INL.VettingService.Models
{
    public class RejectVettingBatch_Param : BaseParam, IRejectVettingBatch_Param
    {
        public RejectVettingBatch_Param() : base() { }

        public long? VettingBatchID { get; set; }
        public string BatchRejectionReason { get; set; }
        public int? ModifiedByAppUserID { get; set; }
    }
}
