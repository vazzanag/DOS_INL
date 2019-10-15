 
  




using System;


namespace INL.VettingService.Data
{
  
	public interface IPersonsVettingEntity
	{
		long PersonsVettingID { get; set; }
		string Name1 { get; set; }
		string Name2 { get; set; }
		string Name3 { get; set; }
		string Name4 { get; set; }
		string Name5 { get; set; }
		long PersonsUnitLibraryInfoID { get; set; }
		long VettingBatchID { get; set; }
		int VettingPersonStatusID { get; set; }
		DateTime? VettingStatusDate { get; set; }
		string VettingNotes { get; set; }
		DateTime? ClearedDate { get; set; }
		int? AppUserIDCleared { get; set; }
		DateTime? DeniedDate { get; set; }
		int? AppUserIDDenied { get; set; }
		bool? RemovedFromVetting { get; set; }
		bool? IsReVetting { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class PersonsVettingEntity : IPersonsVettingEntity
    {
		public long PersonsVettingID { get; set; }
		public string Name1 { get; set; }
		public string Name2 { get; set; }
		public string Name3 { get; set; }
		public string Name4 { get; set; }
		public string Name5 { get; set; }
		public long PersonsUnitLibraryInfoID { get; set; }
		public long VettingBatchID { get; set; }
		public int VettingPersonStatusID { get; set; }
		public DateTime? VettingStatusDate { get; set; }
		public string VettingNotes { get; set; }
		public DateTime? ClearedDate { get; set; }
		public int? AppUserIDCleared { get; set; }
		public DateTime? DeniedDate { get; set; }
		public int? AppUserIDDenied { get; set; }
		public bool? RemovedFromVetting { get; set; }
		public bool? IsReVetting { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface IVettingBatchesEntity
	{
		long VettingBatchID { get; set; }
		string VettingBatchName { get; set; }
		int VettingBatchNumber { get; set; }
		int? VettingBatchOrdinal { get; set; }
		long? TrainingEventID { get; set; }
		int? CountryID { get; set; }
		byte VettingBatchTypeID { get; set; }
		int? AssignedToAppUserID { get; set; }
		int VettingBatchStatusID { get; set; }
		string BatchRejectionReason { get; set; }
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
		DateTime? DateLeahyFileGenerated { get; set; }
		DateTime? DateCourtesyCompleted { get; set; }
		DateTime? DateSentToLeahy { get; set; }
		DateTime? DateLeahyResultsReceived { get; set; }
		DateTime? DateVettingResultsNotified { get; set; }
		int VettingFundingSourceID { get; set; }
		int AuthorizingLawID { get; set; }
		string VettingBatchNotes { get; set; }
		int? AppUserIDSubmitted { get; set; }
		int? AppUserIDAccepted { get; set; }
		int? AppUserIDSentToCourtesy { get; set; }
		int? AppUserIDCourtesyCompleted { get; set; }
		int? AppUserIDSentToLeahy { get; set; }
		int? AppUserIDLeahyResultsReceived { get; set; }
		long? FileID { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class VettingBatchesEntity : IVettingBatchesEntity
    {
		public long VettingBatchID { get; set; }
		public string VettingBatchName { get; set; }
		public int VettingBatchNumber { get; set; }
		public int? VettingBatchOrdinal { get; set; }
		public long? TrainingEventID { get; set; }
		public int? CountryID { get; set; }
		public byte VettingBatchTypeID { get; set; }
		public int? AssignedToAppUserID { get; set; }
		public int VettingBatchStatusID { get; set; }
		public string BatchRejectionReason { get; set; }
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
		public DateTime? DateLeahyFileGenerated { get; set; }
		public DateTime? DateCourtesyCompleted { get; set; }
		public DateTime? DateSentToLeahy { get; set; }
		public DateTime? DateLeahyResultsReceived { get; set; }
		public DateTime? DateVettingResultsNotified { get; set; }
		public int VettingFundingSourceID { get; set; }
		public int AuthorizingLawID { get; set; }
		public string VettingBatchNotes { get; set; }
		public int? AppUserIDSubmitted { get; set; }
		public int? AppUserIDAccepted { get; set; }
		public int? AppUserIDSentToCourtesy { get; set; }
		public int? AppUserIDCourtesyCompleted { get; set; }
		public int? AppUserIDSentToLeahy { get; set; }
		public int? AppUserIDLeahyResultsReceived { get; set; }
		public long? FileID { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      


	public interface ICourtesyBatchesViewEntity
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

    public class CourtesyBatchesViewEntity : ICourtesyBatchesViewEntity
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
      
	public interface IInvestBatchDetailViewEntity
	{
	    long VettingBatchID { get; set; }
	    long PersonsVettingID { get; set; }
	    long PersonID { get; set; }
	    string FirstMiddleNames { get; set; }
	    string LastNames { get; set; }
	    DateTime? DOB { get; set; }
	    char Gender { get; set; }
	    string NationalID { get; set; }
	    string POBCityName { get; set; }
	    string POBStateName { get; set; }
	    string POBCountryName { get; set; }
	    string UnitName { get; set; }
	    string UnitType { get; set; }
	    string JobTitle { get; set; }

	}

    public class InvestBatchDetailViewEntity : IInvestBatchDetailViewEntity
    {
		public long VettingBatchID { get; set; }
		public long PersonsVettingID { get; set; }
		public long PersonID { get; set; }
		public string FirstMiddleNames { get; set; }
		public string LastNames { get; set; }
		public DateTime? DOB { get; set; }
		public char Gender { get; set; }
		public string NationalID { get; set; }
		public string POBCityName { get; set; }
		public string POBStateName { get; set; }
		public string POBCountryName { get; set; }
		public string UnitName { get; set; }
		public string UnitType { get; set; }
		public string JobTitle { get; set; }

    }
      
	public interface ILeahyVettingHitsViewEntity
	{
	    long LeahyVettingHitID { get; set; }
	    long PersonsVettingID { get; set; }
	    string CaseID { get; set; }
	    byte? LeahyHitResultID { get; set; }
	    string LeahyHitResult { get; set; }
	    string LeahyHitResultCode { get; set; }
	    byte? LeahyHitAppliesToID { get; set; }
	    string LeahyHitAppliesTo { get; set; }
	    byte? ViolationTypeID { get; set; }
	    DateTime? CertDate { get; set; }
	    DateTime? ExpiresDate { get; set; }
	    string Summary { get; set; }
	    int ModifiedByAppUserID { get; set; }
	    DateTime ModifiedDate { get; set; }

	}

    public class LeahyVettingHitsViewEntity : ILeahyVettingHitsViewEntity
    {
		public long LeahyVettingHitID { get; set; }
		public long PersonsVettingID { get; set; }
		public string CaseID { get; set; }
		public byte? LeahyHitResultID { get; set; }
		public string LeahyHitResult { get; set; }
		public string LeahyHitResultCode { get; set; }
		public byte? LeahyHitAppliesToID { get; set; }
		public string LeahyHitAppliesTo { get; set; }
		public byte? ViolationTypeID { get; set; }
		public DateTime? CertDate { get; set; }
		public DateTime? ExpiresDate { get; set; }
		public string Summary { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }

    }
      
	public interface IPersonsVettingStatusesViewEntity
	{
	    long PersonID { get; set; }
	    long? TrainingEventID { get; set; }
	    int VettingBatchStatusID { get; set; }
	    string BatchStatus { get; set; }
	    int VettingPersonStatusID { get; set; }
	    string PersonsVettingStatus { get; set; }
	    DateTime? DateLeahyFileGenerated { get; set; }
	    bool? RemovedFromVetting { get; set; }
	    DateTime? VettingStatusDate { get; set; }
	    byte VettingBatchTypeID { get; set; }
	    DateTime? VettingBatchStatusDate { get; set; }
	    DateTime? ExpirationDate { get; set; }

	}

    public class PersonsVettingStatusesViewEntity : IPersonsVettingStatusesViewEntity
    {
		public long PersonID { get; set; }
		public long? TrainingEventID { get; set; }
		public int VettingBatchStatusID { get; set; }
		public string BatchStatus { get; set; }
		public int VettingPersonStatusID { get; set; }
		public string PersonsVettingStatus { get; set; }
		public DateTime? DateLeahyFileGenerated { get; set; }
		public bool? RemovedFromVetting { get; set; }
		public DateTime? VettingStatusDate { get; set; }
		public byte VettingBatchTypeID { get; set; }
		public DateTime? VettingBatchStatusDate { get; set; }
		public DateTime? ExpirationDate { get; set; }

    }
      
	public interface IPersonsVettingVettingTypesViewEntity
	{
	    string FirstMiddleNames { get; set; }
	    string LastNames { get; set; }
	    DateTime? DOB { get; set; }
	    long PersonsVettingID { get; set; }
	    int VettingTypeID { get; set; }
	    string VettingTypeCode { get; set; }
	    bool CourtesyVettingSkipped { get; set; }
	    string CourtesyVettingSkippedComments { get; set; }
	    byte? HitResultID { get; set; }
	    string HitResultDetails { get; set; }
	    string HitResultCode { get; set; }
	    int HasHitDataInTable { get; set; }

	}

    public class PersonsVettingVettingTypesViewEntity : IPersonsVettingVettingTypesViewEntity
    {
		public string FirstMiddleNames { get; set; }
		public string LastNames { get; set; }
		public DateTime? DOB { get; set; }
		public long PersonsVettingID { get; set; }
		public int VettingTypeID { get; set; }
		public string VettingTypeCode { get; set; }
		public bool CourtesyVettingSkipped { get; set; }
		public string CourtesyVettingSkippedComments { get; set; }
		public byte? HitResultID { get; set; }
		public string HitResultDetails { get; set; }
		public string HitResultCode { get; set; }
		public int HasHitDataInTable { get; set; }

    }
      
	public interface IPersonsVettingViewEntity
	{
	    long PersonsVettingID { get; set; }
	    long PersonsUnitLibraryInfoID { get; set; }
	    string FirstMiddleNames { get; set; }
	    string LastNames { get; set; }
	    DateTime? DOB { get; set; }
	    char Gender { get; set; }
	    long PersonID { get; set; }
	    string NationalID { get; set; }
	    int? POBCityID { get; set; }
	    string POBCityName { get; set; }
	    int? POBStateID { get; set; }
	    string POBStateName { get; set; }
	    int? POBCountryID { get; set; }
	    string POBCountryName { get; set; }
	    long UnitID { get; set; }
	    string UnitName { get; set; }
	    string JobTitle { get; set; }
	    string UnitType { get; set; }
	    long VettingBatchID { get; set; }
	    int VettingPersonStatusID { get; set; }
	    string VettingStatus { get; set; }
	    byte VettingBatchTypeID { get; set; }
	    string VettingBatchType { get; set; }
	    DateTime? VettingStatusDate { get; set; }
	    int LastVettingStatusID { get; set; }
	    string LastVettingStatusCode { get; set; }
	    DateTime? LastVettingStatusDate { get; set; }
	    byte LastVettingTypeID { get; set; }
	    string LastVettingTypeCode { get; set; }
	    long? LastVettingTrainingEventID { get; set; }
	    string TrackingNumber { get; set; }
	    long BatchID { get; set; }
	    bool? RemovedFromVetting { get; set; }
	    DateTime? VettingValidStartDate { get; set; }
	    DateTime? VettingValidEndDate { get; set; }
	    int IsRemoved { get; set; }
	    int HasHits { get; set; }

	}

    public class PersonsVettingViewEntity : IPersonsVettingViewEntity
    {
		public long PersonsVettingID { get; set; }
		public long PersonsUnitLibraryInfoID { get; set; }
		public string FirstMiddleNames { get; set; }
		public string LastNames { get; set; }
		public DateTime? DOB { get; set; }
		public char Gender { get; set; }
		public long PersonID { get; set; }
		public string NationalID { get; set; }
		public int? POBCityID { get; set; }
		public string POBCityName { get; set; }
		public int? POBStateID { get; set; }
		public string POBStateName { get; set; }
		public int? POBCountryID { get; set; }
		public string POBCountryName { get; set; }
		public long UnitID { get; set; }
		public string UnitName { get; set; }
		public string JobTitle { get; set; }
		public string UnitType { get; set; }
		public long VettingBatchID { get; set; }
		public int VettingPersonStatusID { get; set; }
		public string VettingStatus { get; set; }
		public byte VettingBatchTypeID { get; set; }
		public string VettingBatchType { get; set; }
		public DateTime? VettingStatusDate { get; set; }
		public int LastVettingStatusID { get; set; }
		public string LastVettingStatusCode { get; set; }
		public DateTime? LastVettingStatusDate { get; set; }
		public byte LastVettingTypeID { get; set; }
		public string LastVettingTypeCode { get; set; }
		public long? LastVettingTrainingEventID { get; set; }
		public string TrackingNumber { get; set; }
		public long BatchID { get; set; }
		public bool? RemovedFromVetting { get; set; }
		public DateTime? VettingValidStartDate { get; set; }
		public DateTime? VettingValidEndDate { get; set; }
		public int IsRemoved { get; set; }
		public int HasHits { get; set; }

    }
      
	public interface IPersonVettingHitsViewEntity
	{
	    long PersonsVettingID { get; set; }
	    int VettingTypeID { get; set; }
	    byte? HitResultID { get; set; }
	    string HitResultDetails { get; set; }
	    string VettingHitsJSON { get; set; }

	}

    public class PersonVettingHitsViewEntity : IPersonVettingHitsViewEntity
    {
		public long PersonsVettingID { get; set; }
		public int VettingTypeID { get; set; }
		public byte? HitResultID { get; set; }
		public string HitResultDetails { get; set; }
		public string VettingHitsJSON { get; set; }

    }
      
	public interface IPostVettingConfigurationViewEntity
	{
	    int PostID { get; set; }
	    int MaxBatchSize { get; set; }
	    int LeahyBatchLeadTime { get; set; }
	    int CourtesyBatchLeadTime { get; set; }
	    int? LeahyBatchExpirationIntervalMonths { get; set; }
	    int? CourtesyBatchExpirationIntervalMonths { get; set; }

	}

    public class PostVettingConfigurationViewEntity : IPostVettingConfigurationViewEntity
    {
		public int PostID { get; set; }
		public int MaxBatchSize { get; set; }
		public int LeahyBatchLeadTime { get; set; }
		public int CourtesyBatchLeadTime { get; set; }
		public int? LeahyBatchExpirationIntervalMonths { get; set; }
		public int? CourtesyBatchExpirationIntervalMonths { get; set; }

    }
      
	public interface IPostVettingTypesViewEntity
	{
	    int PostID { get; set; }
	    int VettingTypeID { get; set; }
	    string Code { get; set; }
	    string Description { get; set; }
	    bool IsActive { get; set; }

	}

    public class PostVettingTypesViewEntity : IPostVettingTypesViewEntity
    {
		public int PostID { get; set; }
		public int VettingTypeID { get; set; }
		public string Code { get; set; }
		public string Description { get; set; }
		public bool IsActive { get; set; }

    }
      
	public interface IVettingBatchesDetailViewEntity
	{
	    long VettingBatchID { get; set; }
	    string VettingBatchName { get; set; }
	    int VettingBatchNumber { get; set; }
	    int? VettingBatchOrdinal { get; set; }
	    long? TrainingEventID { get; set; }
	    int? CountryID { get; set; }
	    string CountryName { get; set; }
	    byte VettingBatchTypeID { get; set; }
	    string VettingBatchType { get; set; }
	    int? AssignedToAppUserID { get; set; }
	    string AssignedToAppUserFirstName { get; set; }
	    string AssignedToAppUserLastName { get; set; }
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
	    DateTime? DateLeahyFileGenerated { get; set; }
	    int VettingFundingSourceID { get; set; }
	    string VettingFundingSource { get; set; }
	    int AuthorizingLawID { get; set; }
	    string AuthorizingLaw { get; set; }
	    string VettingBatchNotes { get; set; }
	    int ModifiedByAppUserID { get; set; }
	    DateTime ModifiedDate { get; set; }
	    long? FileID { get; set; }
	    string TrainingEventName { get; set; }
	    string TrainingEventBusinessUnitAcronym { get; set; }
	    int HasHits { get; set; }
	    int? TotalHits { get; set; }
	    DateTime? EventStartDate { get; set; }
	    string PersonsVettingJSON { get; set; }
	    string PersonVettingTypeJSON { get; set; }
	    string PersonVettingHitJSON { get; set; }
	    string PersonVettingVettingTypesJSON { get; set; }

	}

    public class VettingBatchesDetailViewEntity : IVettingBatchesDetailViewEntity
    {
		public long VettingBatchID { get; set; }
		public string VettingBatchName { get; set; }
		public int VettingBatchNumber { get; set; }
		public int? VettingBatchOrdinal { get; set; }
		public long? TrainingEventID { get; set; }
		public int? CountryID { get; set; }
		public string CountryName { get; set; }
		public byte VettingBatchTypeID { get; set; }
		public string VettingBatchType { get; set; }
		public int? AssignedToAppUserID { get; set; }
		public string AssignedToAppUserFirstName { get; set; }
		public string AssignedToAppUserLastName { get; set; }
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
		public DateTime? DateLeahyFileGenerated { get; set; }
		public int VettingFundingSourceID { get; set; }
		public string VettingFundingSource { get; set; }
		public int AuthorizingLawID { get; set; }
		public string AuthorizingLaw { get; set; }
		public string VettingBatchNotes { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public long? FileID { get; set; }
		public string TrainingEventName { get; set; }
		public string TrainingEventBusinessUnitAcronym { get; set; }
		public int HasHits { get; set; }
		public int? TotalHits { get; set; }
		public DateTime? EventStartDate { get; set; }
		public string PersonsVettingJSON { get; set; }
		public string PersonVettingTypeJSON { get; set; }
		public string PersonVettingHitJSON { get; set; }
		public string PersonVettingVettingTypesJSON { get; set; }

    }
      
	public interface IVettingBatchesViewEntity
	{
	    long VettingBatchID { get; set; }
	    int VettingBatchStatusID { get; set; }
	    long? TrainingEventID { get; set; }
	    int VettingPersonStatusID { get; set; }
	    long PersonsUnitLibraryInfoID { get; set; }
	    long PersonsVettingID { get; set; }

	}

    public class VettingBatchesViewEntity : IVettingBatchesViewEntity
    {
		public long VettingBatchID { get; set; }
		public int VettingBatchStatusID { get; set; }
		public long? TrainingEventID { get; set; }
		public int VettingPersonStatusID { get; set; }
		public long PersonsUnitLibraryInfoID { get; set; }
		public long PersonsVettingID { get; set; }

    }
      
	public interface IVettingHitAttachmentViewEntity
	{
	    long VettingHitFileAttachmentID { get; set; }
	    long VettingHitID { get; set; }
	    long FileID { get; set; }
	    int FileVersion { get; set; }
	    string FileName { get; set; }
	    string FileLocation { get; set; }
	    byte[] FileHash { get; set; }
	    string ThumbnailPath { get; set; }
	    string Description { get; set; }
	    bool? IsDeleted { get; set; }
	    int ModifiedByAppUserID { get; set; }
	    DateTime ModifiedDate { get; set; }
	    string FileJSON { get; set; }
	    string ModifiedByUserJSON { get; set; }

	}

    public class VettingHitAttachmentViewEntity : IVettingHitAttachmentViewEntity
    {
		public long VettingHitFileAttachmentID { get; set; }
		public long VettingHitID { get; set; }
		public long FileID { get; set; }
		public int FileVersion { get; set; }
		public string FileName { get; set; }
		public string FileLocation { get; set; }
		public byte[] FileHash { get; set; }
		public string ThumbnailPath { get; set; }
		public string Description { get; set; }
		public bool? IsDeleted { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public string FileJSON { get; set; }
		public string ModifiedByUserJSON { get; set; }

    }
      
	public interface IVettingHitsViewEntity
	{
	    long VettingHitID { get; set; }
	    long PersonsVettingID { get; set; }
	    int VettingTypeID { get; set; }
	    string FirstMiddleNames { get; set; }
	    string LastNames { get; set; }
	    int? DOBYear { get; set; }
	    byte? DOBMonth { get; set; }
	    byte? DOBDay { get; set; }
	    string PlaceOfBirth { get; set; }
	    byte? ReferenceSiteID { get; set; }
	    byte? HitMonth { get; set; }
	    byte? HitDay { get; set; }
	    int? HitYear { get; set; }
	    string HitUnit { get; set; }
	    string HitLocation { get; set; }
	    byte? ViolationTypeID { get; set; }
	    byte? CredibilityLevelID { get; set; }
	    string HitDetails { get; set; }
	    string Notes { get; set; }
	    string TrackingID { get; set; }
	    DateTime? VettingHitDate { get; set; }
	    string First { get; set; }
	    string Middle { get; set; }
	    string Last { get; set; }
	    bool? IsRemoved { get; set; }
	    string VettingHitFileAttachmentJSON { get; set; }

	}

    public class VettingHitsViewEntity : IVettingHitsViewEntity
    {
		public long VettingHitID { get; set; }
		public long PersonsVettingID { get; set; }
		public int VettingTypeID { get; set; }
		public string FirstMiddleNames { get; set; }
		public string LastNames { get; set; }
		public int? DOBYear { get; set; }
		public byte? DOBMonth { get; set; }
		public byte? DOBDay { get; set; }
		public string PlaceOfBirth { get; set; }
		public byte? ReferenceSiteID { get; set; }
		public byte? HitMonth { get; set; }
		public byte? HitDay { get; set; }
		public int? HitYear { get; set; }
		public string HitUnit { get; set; }
		public string HitLocation { get; set; }
		public byte? ViolationTypeID { get; set; }
		public byte? CredibilityLevelID { get; set; }
		public string HitDetails { get; set; }
		public string Notes { get; set; }
		public string TrackingID { get; set; }
		public DateTime? VettingHitDate { get; set; }
		public string First { get; set; }
		public string Middle { get; set; }
		public string Last { get; set; }
		public bool? IsRemoved { get; set; }
		public string VettingHitFileAttachmentJSON { get; set; }

    }
      



	public interface IGetCourtesyBatchEntity
    {
        long? CourtesyBatchID { get; set; }

    }

    public class GetCourtesyBatchEntity : IGetCourtesyBatchEntity
    {
		public long? CourtesyBatchID { get; set; }

    }
      
	public interface IGetCourtesyBatchesByVettingBatchIDAndVettingTypeIDEntity
    {
        long? VettingBatchID { get; set; }
        int? VettingTypeID { get; set; }

    }

    public class GetCourtesyBatchesByVettingBatchIDAndVettingTypeIDEntity : IGetCourtesyBatchesByVettingBatchIDAndVettingTypeIDEntity
    {
		public long? VettingBatchID { get; set; }
		public int? VettingTypeID { get; set; }

    }
      
	public interface IGetCourtesyBatchPersonsEntity
    {
        long? CourtesyBatchID { get; set; }

    }

    public class GetCourtesyBatchPersonsEntity : IGetCourtesyBatchPersonsEntity
    {
		public long? CourtesyBatchID { get; set; }

    }
      
	public interface IGetLeahyVettingHitByPersonsVettingIDEntity
    {
        long? PersonsVettingID { get; set; }

    }

    public class GetLeahyVettingHitByPersonsVettingIDEntity : IGetLeahyVettingHitByPersonsVettingIDEntity
    {
		public long? PersonsVettingID { get; set; }

    }
      
	public interface IGetPersonVettingVettingTypeEntity
    {
        long? PersonsVettingID { get; set; }
        int? VettingTypeID { get; set; }

    }

    public class GetPersonVettingVettingTypeEntity : IGetPersonVettingVettingTypeEntity
    {
		public long? PersonsVettingID { get; set; }
		public int? VettingTypeID { get; set; }

    }
      
	public interface IGetVettingBatchDetailEntity
    {
        long? VettingBatchID { get; set; }

    }

    public class GetVettingBatchDetailEntity : IGetVettingBatchDetailEntity
    {
		public long? VettingBatchID { get; set; }

    }
      
	public interface IGetVettingBatchesByCountryIDEntity
    {
        long? CountryID { get; set; }
        string VettingBatchStatus { get; set; }
        int? IsCorrectionRequired { get; set; }
        int? HasHits { get; set; }
        string CourtesyType { get; set; }

    }

    public class GetVettingBatchesByCountryIDEntity : IGetVettingBatchesByCountryIDEntity
    {
		public long? CountryID { get; set; }
		public string VettingBatchStatus { get; set; }
		public int? IsCorrectionRequired { get; set; }
		public int? HasHits { get; set; }
		public string CourtesyType { get; set; }

    }
      
	public interface IGetVettingBatchesByTrainingEventIDEntity
    {
        long? TrainingEventID { get; set; }

    }

    public class GetVettingBatchesByTrainingEventIDEntity : IGetVettingBatchesByTrainingEventIDEntity
    {
		public long? TrainingEventID { get; set; }

    }
      
	public interface IRejectVettingBatchEntity
    {
        long? VettingBatchID { get; set; }
        string BatchRejectionReason { get; set; }
        int? ModifiedByAppUserID { get; set; }

    }

    public class RejectVettingBatchEntity : IRejectVettingBatchEntity
    {
		public long? VettingBatchID { get; set; }
		public string BatchRejectionReason { get; set; }
		public int? ModifiedByAppUserID { get; set; }

    }
      
	public interface IRemoveParticipantFromVettingEntity
    {
        long? TrainingEventID { get; set; }
        string PersonsJSON { get; set; }
        long? ModifiedByAppUserID { get; set; }

    }

    public class RemoveParticipantFromVettingEntity : IRemoveParticipantFromVettingEntity
    {
		public long? TrainingEventID { get; set; }
		public string PersonsJSON { get; set; }
		public long? ModifiedByAppUserID { get; set; }

    }
      
	public interface ISaveCourtesyBatchEntity
    {
        long? CourtesyBatchID { get; set; }
        long? VettingBatchID { get; set; }
        int? VettingTypeID { get; set; }
        string VettingBatchNotes { get; set; }
        int? AssignedToAppUserID { get; set; }
        DateTime? ResultsSubmittedDate { get; set; }
        int? ResultsSubmittedByAppUserID { get; set; }
        int? ModifiedByAppUserID { get; set; }

    }

    public class SaveCourtesyBatchEntity : ISaveCourtesyBatchEntity
    {
		public long? CourtesyBatchID { get; set; }
		public long? VettingBatchID { get; set; }
		public int? VettingTypeID { get; set; }
		public string VettingBatchNotes { get; set; }
		public int? AssignedToAppUserID { get; set; }
		public DateTime? ResultsSubmittedDate { get; set; }
		public int? ResultsSubmittedByAppUserID { get; set; }
		public int? ModifiedByAppUserID { get; set; }

    }
      
	public interface ISaveLeahyVettingHitEntity
    {
        long? LeahyVettingHitID { get; set; }
        long? PersonsVettingID { get; set; }
        string CaseID { get; set; }
        byte? LeahyHitResultID { get; set; }
        byte? LeahyHitAppliesToID { get; set; }
        byte? ViolationTypeID { get; set; }
        DateTime? CertDate { get; set; }
        DateTime? ExpiresDate { get; set; }
        string Summary { get; set; }
        long? ModifiedByAppUserID { get; set; }

    }

    public class SaveLeahyVettingHitEntity : ISaveLeahyVettingHitEntity
    {
		public long? LeahyVettingHitID { get; set; }
		public long? PersonsVettingID { get; set; }
		public string CaseID { get; set; }
		public byte? LeahyHitResultID { get; set; }
		public byte? LeahyHitAppliesToID { get; set; }
		public byte? ViolationTypeID { get; set; }
		public DateTime? CertDate { get; set; }
		public DateTime? ExpiresDate { get; set; }
		public string Summary { get; set; }
		public long? ModifiedByAppUserID { get; set; }

    }
      
	public interface ISavePersonsVettingStatusEntity
    {
        long? PersonsVettingID { get; set; }
        string VettingStatus { get; set; }
        bool? IsClear { get; set; }
        bool? IsDeny { get; set; }
        int? ModifiedAppUserID { get; set; }

    }

    public class SavePersonsVettingStatusEntity : ISavePersonsVettingStatusEntity
    {
		public long? PersonsVettingID { get; set; }
		public string VettingStatus { get; set; }
		public bool? IsClear { get; set; }
		public bool? IsDeny { get; set; }
		public int? ModifiedAppUserID { get; set; }

    }
      
	public interface ISavePersonVettingVettingTypeEntity
    {
        long? PersonVettingID { get; set; }
        int? VettingTypeID { get; set; }
        bool? CourtesySkippedFlag { get; set; }
        string CourtesySkippedComments { get; set; }
        int? ModifiedAppUserID { get; set; }

    }

    public class SavePersonVettingVettingTypeEntity : ISavePersonVettingVettingTypeEntity
    {
		public long? PersonVettingID { get; set; }
		public int? VettingTypeID { get; set; }
		public bool? CourtesySkippedFlag { get; set; }
		public string CourtesySkippedComments { get; set; }
		public int? ModifiedAppUserID { get; set; }

    }
      
	public interface ISaveVettingBatchEntity
    {
        string VettingBatchName { get; set; }
        long? TrainingEventID { get; set; }
        int? CountryID { get; set; }
        byte? VettingBatchTypeID { get; set; }
        int? AssignedToAppUserID { get; set; }
        int? VettingBatchStatusID { get; set; }
        string BatchRejectionReason { get; set; }
        bool? IsCorrectionRequired { get; set; }
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
        int? VettingFundingSourceID { get; set; }
        int? AuthorizingLawID { get; set; }
        string VettingBatchNotes { get; set; }
        int? ModifiedByAppUserID { get; set; }
        DateTime? ModifiedDate { get; set; }
        string PersonVettings { get; set; }

    }

    public class SaveVettingBatchEntity : ISaveVettingBatchEntity
    {
		public string VettingBatchName { get; set; }
		public long? TrainingEventID { get; set; }
		public int? CountryID { get; set; }
		public byte? VettingBatchTypeID { get; set; }
		public int? AssignedToAppUserID { get; set; }
		public int? VettingBatchStatusID { get; set; }
		public string BatchRejectionReason { get; set; }
		public bool? IsCorrectionRequired { get; set; }
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
		public int? VettingFundingSourceID { get; set; }
		public int? AuthorizingLawID { get; set; }
		public string VettingBatchNotes { get; set; }
		public int? ModifiedByAppUserID { get; set; }
		public DateTime? ModifiedDate { get; set; }
		public string PersonVettings { get; set; }

    }
      
	public interface ISaveVettingHitEntity
    {
        int? VettingHitID { get; set; }
        int? PersonsVettingID { get; set; }
        int? VettingTypeID { get; set; }
        string FirstMiddleNames { get; set; }
        string LastNames { get; set; }
        byte? DOBMonth { get; set; }
        byte? DOBDay { get; set; }
        int? DOBYear { get; set; }
        string PlaceOfBirth { get; set; }
        int? ReferenceSiteID { get; set; }
        byte? HitMonth { get; set; }
        byte? HitDay { get; set; }
        int? HitYear { get; set; }
        string TrackingID { get; set; }
        string HitUnit { get; set; }
        string HitLocation { get; set; }
        byte? ViolationTypeID { get; set; }
        byte? CredibilityLevelID { get; set; }
        string HitDetails { get; set; }
        string Notes { get; set; }
        bool? IsRemoved { get; set; }
        byte? HitResultID { get; set; }
        string HitResultDetails { get; set; }
        int? ModifiedByAppUserID { get; set; }

    }

    public class SaveVettingHitEntity : ISaveVettingHitEntity
    {
		public int? VettingHitID { get; set; }
		public int? PersonsVettingID { get; set; }
		public int? VettingTypeID { get; set; }
		public string FirstMiddleNames { get; set; }
		public string LastNames { get; set; }
		public byte? DOBMonth { get; set; }
		public byte? DOBDay { get; set; }
		public int? DOBYear { get; set; }
		public string PlaceOfBirth { get; set; }
		public int? ReferenceSiteID { get; set; }
		public byte? HitMonth { get; set; }
		public byte? HitDay { get; set; }
		public int? HitYear { get; set; }
		public string TrackingID { get; set; }
		public string HitUnit { get; set; }
		public string HitLocation { get; set; }
		public byte? ViolationTypeID { get; set; }
		public byte? CredibilityLevelID { get; set; }
		public string HitDetails { get; set; }
		public string Notes { get; set; }
		public bool? IsRemoved { get; set; }
		public byte? HitResultID { get; set; }
		public string HitResultDetails { get; set; }
		public int? ModifiedByAppUserID { get; set; }

    }
      
	public interface ISaveVettingHitAttachmentEntity
    {
        long? VettingHitFileAttachmentID { get; set; }
        long? VettingHitID { get; set; }
        long? FileID { get; set; }
        int? FileVersion { get; set; }
        string Description { get; set; }
        bool? IsDeleted { get; set; }
        int? ModifiedByAppUserID { get; set; }

    }

    public class SaveVettingHitAttachmentEntity : ISaveVettingHitAttachmentEntity
    {
		public long? VettingHitFileAttachmentID { get; set; }
		public long? VettingHitID { get; set; }
		public long? FileID { get; set; }
		public int? FileVersion { get; set; }
		public string Description { get; set; }
		public bool? IsDeleted { get; set; }
		public int? ModifiedByAppUserID { get; set; }

    }
      
	public interface IUpdateVettingBatchEntity
    {
        long? VettingBatchID { get; set; }
        int? ModifiedByAppUserID { get; set; }
        string INKTrackingNumber { get; set; }
        string LeahyTrackingNumber { get; set; }
        string VettingBatchNotes { get; set; }

    }

    public class UpdateVettingBatchEntity : IUpdateVettingBatchEntity
    {
		public long? VettingBatchID { get; set; }
		public int? ModifiedByAppUserID { get; set; }
		public string INKTrackingNumber { get; set; }
		public string LeahyTrackingNumber { get; set; }
		public string VettingBatchNotes { get; set; }

    }
      
	public interface IUpdateVettingBatchStatusEntity
    {
        long? VettingBatchID { get; set; }
        string VettingBatchStatus { get; set; }
        int? ModifiedByAppUserID { get; set; }

    }

    public class UpdateVettingBatchStatusEntity : IUpdateVettingBatchStatusEntity
    {
		public long? VettingBatchID { get; set; }
		public string VettingBatchStatus { get; set; }
		public int? ModifiedByAppUserID { get; set; }

    }
      





}



