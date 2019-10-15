using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public interface ISaveCourtesyBatch_Param 
    {
        long? CourtesyBatchID { get; set; }
        long? VettingBatchID { get; set; }
        int? VettingTypeID { get; set; }
        string VettingBatchNotes { get; set; }
        int? AssignedToAppUserID { get; set; }
        DateTime? ResultsSubmittedDate { get; set; }
        int? ResultsSubmittedByAppUserID { get; set; }
        int? ModifiedByAppUserID { get; set; }
        bool isSubmit { get; set; }
    }
}
