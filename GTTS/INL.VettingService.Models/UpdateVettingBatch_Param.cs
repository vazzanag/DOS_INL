using INL.Services.Models;
using System.Collections.Generic;

namespace INL.VettingService.Models
{
    public class UpdateVettingBatch_Param : BaseParam, IUpdateVettingBatch_Param
    {
        public UpdateVettingBatch_Param() : base() { }

        public long VettingBatchID { get; set; }
        public int? AssignedToAppUserID { get; set; }
        public int? ModifiedByAppUserID { get; set; }
        public string VettingBatchNotes { get; set; }
        public string VettingBatchStatus { get; set; }
        public int? VettingTypeID { get; set; }
        public string INKTrackingNumber { get; set; }
        public string LeahyTrackingNumber { get; set; }
    }
}
