using INL.Services.Models;

namespace INL.VettingService.Models
{
    public interface IAssignVettingBatch_Param : IBaseParam
    {
        long VettingBatchID { get; set; }
        long AssignedToAppUserID { get; set; }
        long ModifiedByAppUserID { get; set; }
    }
}
