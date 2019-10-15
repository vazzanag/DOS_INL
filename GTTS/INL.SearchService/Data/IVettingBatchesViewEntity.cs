using System;

namespace INL.SearchService.Data
{
    public interface IVettingBatchesDetailViewEntity
    {
        string TrainingEventName { get; set; }
        string TrainingNameInLocalLang { get; set; }
        long TrainingEventID { get; set; }
        string FundingSourceCode { get; set; }
        string FundingSource { get; set; }
        string AuthorizingLawCode { get; set; }
        string AuthorizingLaw { get; set; }
        string VettingBatchType { get; set; }
        string VettingBatchStatus { get; set; }
        long VettingBatchID { get; set; }
        string VettingBatchName { get; set; }
        int VettingBatchNumber { get; set; }
        DateTime? DateAccepted { get; set; }
        DateTime? DateCourtesyCompleted { get; set; }
        DateTime? DateLeahyResultsReceived { get; set; }
        DateTime? DateSentToCourtesy { get; set; }
        DateTime? DateSentToLeahy { get; set; }
        DateTime? DateSubmitted { get; set; }
        DateTime? DateVettingResultsNeededBy { get; set; }
        DateTime? DateVettingResultsNotified { get; set; }
        string GTTSTrackingNumber { get; set; }
        string LeahyTrackingNumber { get; set; }
        string INKTrackingNumber { get; set; }
        int? CountryID { get; set; }
        int? AssignedToAppUserID { get; set; }
        int PersonsCount { get; set; }
        DateTime? EventStartDate { get; set; }

    }
}
