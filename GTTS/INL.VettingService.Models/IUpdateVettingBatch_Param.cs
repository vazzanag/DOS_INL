using INL.Services.Models;
using System.Collections.Generic;

namespace INL.VettingService.Models
{
    public interface IUpdateVettingBatch_Param : IBaseParam
    {
        long VettingBatchID { get; set; }
        int? AssignedToAppUserID { get; set; }
        int? ModifiedByAppUserID { get; set; }
        string VettingBatchNotes { get; set; }
        string VettingBatchStatus { get; set; }
        int? VettingTypeID { get; set; }
        string INKTrackingNumber { get; set; }
        string LeahyTrackingNumber { get; set; }
    }
}
