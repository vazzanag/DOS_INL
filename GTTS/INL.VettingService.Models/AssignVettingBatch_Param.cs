using INL.Services.Models;

namespace INL.VettingService.Models
{
    public class AssignVettingBatch_Param : BaseParam, IAssignVettingBatch_Param
    {
        public long VettingBatchID { get; set; }
        public long AssignedToAppUserID { get; set; }
        public long ModifiedByAppUserID { get; set; }
    }
}
