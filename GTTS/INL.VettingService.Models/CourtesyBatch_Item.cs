using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public class CourtesyBatch_Item : ICourtesyBatch_Item
    {
        public long CourtesyBatchID { get; set; }
        public long VettingBatchID { get; set; }
        public int VettingTypeID { get; set; }
        public string VettingType { get; set; }
        public string VettingBatchNotes { get; set; }
        public int? AssignedToAppUserID { get; set; }
        public string AssignedToAppUserName { get; set; }
        public DateTime? ResultsSubmittedDate { get; set; }
        public int? ResultsSubmittedByAppUserID { get; set; }
        public string ResultsSubmittedByAppUserName { get; set; }
    }
}
