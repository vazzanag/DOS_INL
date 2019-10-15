using INL.Services.Models;

namespace INL.VettingService.Models
{
    public class AssignVettingBatch_Result : BaseResult, IAssignVettingBatch_Result
    {
        public long VettingBatchID { get; set; }
    }
}
