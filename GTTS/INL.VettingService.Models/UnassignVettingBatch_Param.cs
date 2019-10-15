using INL.Services.Models;

namespace INL.VettingService.Models
{
    public class UnassignVettingBatch_Param : BaseParam, IUnassignVettingBatch_Param
    {
        public long VettingBatchID { get; set; }
        public long ModifiedByAppUserID { get; set; }
    }
}