using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public interface ICourtesyBatch_Item
    {
        long CourtesyBatchID { get; set; }
        long VettingBatchID { get; set; }
        int VettingTypeID { get; set; }
        string VettingType { get; set; }
        string VettingBatchNotes { get; set; }
        int? AssignedToAppUserID { get; set; }
        string AssignedToAppUserName { get; set; }
        DateTime? ResultsSubmittedDate { get; set; }
        int? ResultsSubmittedByAppUserID { get; set; }
        string ResultsSubmittedByAppUserName { get; set; }
    }
}
