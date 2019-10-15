using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public interface IVettingBatch_Item
    {
        int Ordinal { get; set; }
        long VettingBatchID { get; set; }
        string VettingBatchName { get; set; }
        int VettingBatchNumber { get; set; }
        int VettingBatchOrdinal { get; set; }
        long? TrainingEventID { get; set; }
        int? CountryID { get; set; }
        string CountryName { get; set; }
        int VettingBatchTypeID { get; set; }
        string VettingBatchType { get; set; }
        int? AssignedToAppUserID { get; set; }
        string AssignedToAppUserFirstName { get; set; }
        string AssignedToAppUserLastName { get; set; }
        int VettingBatchStatusID { get; set; }
        string VettingBatchStatus { get; set; }
        bool IsCorrectionRequired { get; set; }
        bool? CourtesyVettingOverrideFlag { get; set; }
        string CourtesyVettingOverrideReason { get; set; }
        string GTTSTrackingNumber { get; set; }
        string LeahyTrackingNumber { get; set; }
        string INKTrackingNumber { get; set; }
        DateTime? DateVettingResultsNeededBy { get; set; }
        DateTime? DateSubmitted { get; set; }
        DateTime? DateAccepted { get; set; }
        DateTime? DateSentToCourtesy { get; set; }
        DateTime? DateCourtesyCompleted { get; set; }
        DateTime? DateSentToLeahy { get; set; }
        DateTime? DateLeahyResultsReceived { get; set; }
        DateTime? DateVettingResultsNotified { get; set; }
        DateTime? EventStartDate { get; set; }
        DateTime? DateLeahyFileGenerated { get; set; }
        int VettingFundingSourceID { get; set; }
        string VettingFundingSource { get; set; }
        int AuthorizingLawID { get; set; }
        string AuthorizingLaw { get; set; }
        string VettingBatchNotes { get; set; }
        int ModifiedByAppUserID { get; set; }
        DateTime ModifiedDate { get; set; }
        string TrainingEventName { get; set; }
        string TrainingEventBusinessUnitAcronym { get; set; }
        bool HasHits { get; set; }
        string SubmittedAppUserFirstName { get; set; }
        string SubmittedAppUserLastName { get; set; }
        string AcceptedAppUserFirstName { get; set; }
        string AcceptedAppUserLastName { get; set; }
        string CourtesyCompleteAppUserFirstName { get; set; }
        string CourtesyCompleteAppUserLastName { get; set; }
        string SentToCourtesyAppUserFirstName { get; set; }
        string SentToCourtesyAppUserLastName { get; set; }
        string SentToLeahyAppUserFirstName { get; set; }
        string SentToLeahyAppUserLastName { get; set; }
        long FileID { get; set; }
        int NumOfRemovedParticipants { get; set; }
        int NumOfCanceledParticipants { get; set; }

        ICourtesyBatch_Item CourtesyBatch { get; set; }

        List<IPersonVetting_Item> PersonVettings { get; set; }
        List<IPersonVettingType_Item> PersonVettingTypes { get; set; }
        List<IPersonVettingHit_Item> PersonVettingHits { get; set; }
        List<IPersonVettingVettingType_Item> PersonVettingVettingTypes { get; set; }
    }
}
