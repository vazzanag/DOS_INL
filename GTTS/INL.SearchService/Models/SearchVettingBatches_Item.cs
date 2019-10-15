using System;

namespace INL.SearchService.Models
{
    public class SearchVettingBatches_Item : ISearchVettingBatches_Item
    {
        public string TrainingEventName { get; set; }
        public string TrainingNameInLocalLang { get; set; }
        public long TrainingEventID { get; set; }
        public string FundingSourceCode { get; set; }
        public string FundingSource { get; set; }
        public string AuthorizingLawCode { get; set; }
        public string AuthorizingLaw { get; set; }
        public string VettingBatchType { get; set; }
        public string VettingBatchStatus { get; set; }
        public long VettingBatchID { get; set; }
        public string VettingBatchName { get; set; }
        public int VettingBatchNumber { get; set; }
        public DateTime? DateAccepted { get; set; }
        public DateTime? DateCourtesyCompleted { get; set; }
        public DateTime? DateLeahyResultsReceived { get; set; }
        public DateTime? DateSentToCourtesy { get; set; }
        public DateTime? DateSentToLeahy { get; set; }
        public DateTime? DateSubmitted { get; set; }
        public DateTime? DateVettingResultsNeededBy { get; set; }
        public DateTime? DateVettingResultsNotified { get; set; }
        public string GTTSTrackingNumber { get; set; }
        public string LeahyTrackingNumber { get; set; }
        public string INKTrackingNumber { get; set; }
        public int? CountryID { get; set; }
        public int? AssignedToAppUserID { get; set; }
        public int PersonsCount { get; set; }
        public DateTime? EventStartDate { get; set; }
    }
}
