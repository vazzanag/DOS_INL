using System;
using System.Collections.Generic;

namespace INL.VettingService.Models
{
    public class VettingBatch_Item : IVettingBatch_Item
    {
        public int Ordinal { get; set; }
        public long VettingBatchID { get; set; }
        public string VettingBatchName { get; set; }
        public int VettingBatchNumber { get; set; }
        public int VettingBatchOrdinal { get; set; }
        public long? TrainingEventID { get; set; }
        public int? CountryID { get; set; }
        public string CountryName { get; set; }
        public int VettingBatchTypeID { get; set; }
        public string VettingBatchType { get; set; }
        public int? AssignedToAppUserID { get; set; }
        public string AssignedToAppUserFirstName { get; set; }
        public string AssignedToAppUserLastName { get; set; }
        public int VettingBatchStatusID { get; set; }
        public string VettingBatchStatus { get; set; }
        public bool IsCorrectionRequired { get; set; }
        public bool? CourtesyVettingOverrideFlag { get; set; }
        public string CourtesyVettingOverrideReason { get; set; }
        public string GTTSTrackingNumber { get; set; }
        public string LeahyTrackingNumber { get; set; }
        public string INKTrackingNumber { get; set; }
        public DateTime? DateVettingResultsNeededBy { get; set; }
        public DateTime? DateSubmitted { get; set; }
        public DateTime? DateAccepted { get; set; }
        public DateTime? DateSentToCourtesy { get; set; }
        public DateTime? DateCourtesyCompleted { get; set; }
        public DateTime? DateSentToLeahy { get; set; }
        public DateTime? DateLeahyResultsReceived { get; set; }
        public DateTime? DateVettingResultsNotified { get; set; }
        public DateTime? EventStartDate { get; set; }
        public DateTime? DateLeahyFileGenerated { get; set; }
        public int VettingFundingSourceID { get; set; }
        public string VettingFundingSource { get; set; }
        public int AuthorizingLawID { get; set; }
        public string AuthorizingLaw { get; set; }
        public string VettingBatchNotes { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
        public string TrainingEventName { get; set; }
        public string TrainingEventBusinessUnitAcronym { get; set; }
        public Boolean HasHits { get; set; }
        public int TotalHits { get; set; }
        public string SubmittedAppUserFirstName { get; set; }
        public string SubmittedAppUserLastName { get; set; }
        public string AcceptedAppUserFirstName { get; set; }
        public string AcceptedAppUserLastName { get; set; }
        public string CourtesyCompleteAppUserFirstName { get; set; }
        public string CourtesyCompleteAppUserLastName { get; set; }
        public string SentToCourtesyAppUserFirstName { get; set; }
        public string SentToCourtesyAppUserLastName { get; set; }
        public string SentToLeahyAppUserFirstName { get; set; }
        public string SentToLeahyAppUserLastName { get; set; }
        public long FileID { get; set; }
        public int NumOfRemovedParticipants { get; set; }
        public int NumOfCanceledParticipants { get; set; }

        public ICourtesyBatch_Item CourtesyBatch { get; set; }
        public List<IPersonVetting_Item> PersonVettings { get; set; }
        public List<IPersonVettingType_Item> PersonVettingTypes { get; set; }
        public List<IPersonVettingHit_Item> PersonVettingHits { get; set; }
        public List<IPersonVettingVettingType_Item> PersonVettingVettingTypes { get; set; }
    }
}
