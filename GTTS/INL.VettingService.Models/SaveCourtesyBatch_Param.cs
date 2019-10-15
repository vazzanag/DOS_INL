using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public class SaveCourtesyBatch_Param : ISaveCourtesyBatch_Param
    {
        public long? CourtesyBatchID { get; set; }
        public long? VettingBatchID { get; set; }
        public int? VettingTypeID { get; set; }
        public string VettingBatchNotes { get; set; }
        public int? AssignedToAppUserID { get; set; }
        public DateTime? ResultsSubmittedDate { get; set; }
        public int? ResultsSubmittedByAppUserID { get; set; }
        public int? ModifiedByAppUserID { get; set; }
        public bool isSubmit { get; set; }
    }
}
