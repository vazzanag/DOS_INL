 
  




using System;


namespace INL.TrainingService.Data
{
  
	public interface IApprovalChainLinkApproversEntity
	{
		int ApprovalChainLinkID { get; set; }
		int ApproverAppUserID { get; set; }
		bool IsPrimary { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }

	}

    public class ApprovalChainLinkApproversEntity : IApprovalChainLinkApproversEntity
    {
		public int ApprovalChainLinkID { get; set; }
		public int ApproverAppUserID { get; set; }
		public bool IsPrimary { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }

    }
      
	public interface IApprovalChainLinksEntity
	{
		int ApprovalChainLinkID { get; set; }
		long BusinessUnitID { get; set; }
		int Sequence { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }

	}

    public class ApprovalChainLinksEntity : IApprovalChainLinksEntity
    {
		public int ApprovalChainLinkID { get; set; }
		public long BusinessUnitID { get; set; }
		public int Sequence { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }

    }
      
	public interface IApprovalEventTypesEntity
	{
		int ApprovalEventTypeID { get; set; }
		string Name { get; set; }
		bool IsActive { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }

	}

    public class ApprovalEventTypesEntity : IApprovalEventTypesEntity
    {
		public int ApprovalEventTypeID { get; set; }
		public string Name { get; set; }
		public bool IsActive { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }

    }
      
	public interface IParticipantsXLSXEntity
	{
		long ParticipantXLSXID { get; set; }
		long? EventXLSXID { get; set; }
		long? TrainingEventID { get; set; }
		long? PersonID { get; set; }
		string ParticipantStatus { get; set; }
		string FirstMiddleName { get; set; }
		string LastName { get; set; }
		string NationalID { get; set; }
		char Gender { get; set; }
		string IsUSCitizen { get; set; }
		DateTime? DOB { get; set; }
		string POBCity { get; set; }
		string POBState { get; set; }
		string POBCountry { get; set; }
		string ResidenceCity { get; set; }
		string ResidenceState { get; set; }
		string ResidenceCountry { get; set; }
		string ContactEmail { get; set; }
		string ContactPhone { get; set; }
		string HighestEducation { get; set; }
		string EnglishLanguageProficiency { get; set; }
		string UnitGenID { get; set; }
		string UnitBreakdown { get; set; }
		string UnitAlias { get; set; }
		string JobTitle { get; set; }
		string Rank { get; set; }
		string IsUnitCommander { get; set; }
		int? YearsInPosition { get; set; }
		string PoliceMilSecID { get; set; }
		string POCName { get; set; }
		string POCEmailAddress { get; set; }
		string VettingType { get; set; }
		string HasLocalGovTrust { get; set; }
		DateTime? LocalGovTrustCertDate { get; set; }
		string PassedExternalVetting { get; set; }
		string ExternalVettingDescription { get; set; }
		DateTime? ExternalVettingDate { get; set; }
		string DepartureCity { get; set; }
		int? DepartureCityID { get; set; }
		int? DepartureStateID { get; set; }
		int? DepartureCountryID { get; set; }
		string PassportNumber { get; set; }
		DateTime? PassportExpirationDate { get; set; }
		string Comments { get; set; }
		string MarkForAction { get; set; }
		string LoadStatus { get; set; }
		string Validations { get; set; }
		int? ImportVersion { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class ParticipantsXLSXEntity : IParticipantsXLSXEntity
    {
		public long ParticipantXLSXID { get; set; }
		public long? EventXLSXID { get; set; }
		public long? TrainingEventID { get; set; }
		public long? PersonID { get; set; }
		public string ParticipantStatus { get; set; }
		public string FirstMiddleName { get; set; }
		public string LastName { get; set; }
		public string NationalID { get; set; }
		public char Gender { get; set; }
		public string IsUSCitizen { get; set; }
		public DateTime? DOB { get; set; }
		public string POBCity { get; set; }
		public string POBState { get; set; }
		public string POBCountry { get; set; }
		public string ResidenceCity { get; set; }
		public string ResidenceState { get; set; }
		public string ResidenceCountry { get; set; }
		public string ContactEmail { get; set; }
		public string ContactPhone { get; set; }
		public string HighestEducation { get; set; }
		public string EnglishLanguageProficiency { get; set; }
		public string UnitGenID { get; set; }
		public string UnitBreakdown { get; set; }
		public string UnitAlias { get; set; }
		public string JobTitle { get; set; }
		public string Rank { get; set; }
		public string IsUnitCommander { get; set; }
		public int? YearsInPosition { get; set; }
		public string PoliceMilSecID { get; set; }
		public string POCName { get; set; }
		public string POCEmailAddress { get; set; }
		public string VettingType { get; set; }
		public string HasLocalGovTrust { get; set; }
		public DateTime? LocalGovTrustCertDate { get; set; }
		public string PassedExternalVetting { get; set; }
		public string ExternalVettingDescription { get; set; }
		public DateTime? ExternalVettingDate { get; set; }
		public string DepartureCity { get; set; }
		public int? DepartureCityID { get; set; }
		public int? DepartureStateID { get; set; }
		public int? DepartureCountryID { get; set; }
		public string PassportNumber { get; set; }
		public DateTime? PassportExpirationDate { get; set; }
		public string Comments { get; set; }
		public string MarkForAction { get; set; }
		public string LoadStatus { get; set; }
		public string Validations { get; set; }
		public int? ImportVersion { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface IProjectCodesEntity
	{
		int ProjectCodeID { get; set; }
		string Code { get; set; }
		string Description { get; set; }
		bool IsActive { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class ProjectCodesEntity : IProjectCodesEntity
    {
		public int ProjectCodeID { get; set; }
		public string Code { get; set; }
		public string Description { get; set; }
		public bool IsActive { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface ITrainingEventApprovalLogsEntity
	{
		long TrainingEventApprovalLogID { get; set; }
		long TrainingEventID { get; set; }
		int ApprovalChainLinkID { get; set; }
		int ApprovalEventTypeID { get; set; }
		DateTime ApprovalEventDate { get; set; }
		int? ApproverAppUserID { get; set; }
		string Comments { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }

	}

    public class TrainingEventApprovalLogsEntity : ITrainingEventApprovalLogsEntity
    {
		public long TrainingEventApprovalLogID { get; set; }
		public long TrainingEventID { get; set; }
		public int ApprovalChainLinkID { get; set; }
		public int ApprovalEventTypeID { get; set; }
		public DateTime ApprovalEventDate { get; set; }
		public int? ApproverAppUserID { get; set; }
		public string Comments { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }

    }
      
	public interface ITrainingEventAttachmentsEntity
	{
		long TrainingEventAttachmentID { get; set; }
		long TrainingEventID { get; set; }
		long FileID { get; set; }
		int FileVersion { get; set; }
		int TrainingEventAttachmentTypeID { get; set; }
		string Description { get; set; }
		bool? IsDeleted { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class TrainingEventAttachmentsEntity : ITrainingEventAttachmentsEntity
    {
		public long TrainingEventAttachmentID { get; set; }
		public long TrainingEventID { get; set; }
		public long FileID { get; set; }
		public int FileVersion { get; set; }
		public int TrainingEventAttachmentTypeID { get; set; }
		public string Description { get; set; }
		public bool? IsDeleted { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface ITrainingEventAttachmentTypesEntity
	{
		int TrainingEventAttachmentTypeID { get; set; }
		string Name { get; set; }
		string Description { get; set; }
		bool IsActive { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class TrainingEventAttachmentTypesEntity : ITrainingEventAttachmentTypesEntity
    {
		public int TrainingEventAttachmentTypeID { get; set; }
		public string Name { get; set; }
		public string Description { get; set; }
		public bool IsActive { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface ITrainingEventAuthorizingDocumentsEntity
	{
		long TrainingEventID { get; set; }
		int InterAgencyAgreementID { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class TrainingEventAuthorizingDocumentsEntity : ITrainingEventAuthorizingDocumentsEntity
    {
		public long TrainingEventID { get; set; }
		public int InterAgencyAgreementID { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface ITrainingEventGroupMembersEntity
	{
		long TrainingEventGroupID { get; set; }
		long PersonID { get; set; }
		int GroupMemberTypeID { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class TrainingEventGroupMembersEntity : ITrainingEventGroupMembersEntity
    {
		public long TrainingEventGroupID { get; set; }
		public long PersonID { get; set; }
		public int GroupMemberTypeID { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface ITrainingEventGroupMemberTypesEntity
	{
		int TrainingEventGroupMemberTypeID { get; set; }
		string Name { get; set; }
		bool IsActive { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class TrainingEventGroupMemberTypesEntity : ITrainingEventGroupMemberTypesEntity
    {
		public int TrainingEventGroupMemberTypeID { get; set; }
		public string Name { get; set; }
		public bool IsActive { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface ITrainingEventGroupsEntity
	{
		long TrainingEventGroupID { get; set; }
		long TrainingEventID { get; set; }
		string GroupName { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class TrainingEventGroupsEntity : ITrainingEventGroupsEntity
    {
		public long TrainingEventGroupID { get; set; }
		public long TrainingEventID { get; set; }
		public string GroupName { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface ITrainingEventLocationsEntity
	{
		int TrainingEventLocationID { get; set; }
		long TrainingEventID { get; set; }
		long LocationID { get; set; }
		DateTime EventStartDate { get; set; }
		DateTime EventEndDate { get; set; }
		DateTime? TravelStartDate { get; set; }
		DateTime? TravelEndDate { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class TrainingEventLocationsEntity : ITrainingEventLocationsEntity
    {
		public int TrainingEventLocationID { get; set; }
		public long TrainingEventID { get; set; }
		public long LocationID { get; set; }
		public DateTime EventStartDate { get; set; }
		public DateTime EventEndDate { get; set; }
		public DateTime? TravelStartDate { get; set; }
		public DateTime? TravelEndDate { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface ITrainingEventProjectCodesEntity
	{
		long TrainingEventID { get; set; }
		int ProjectCodeID { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class TrainingEventProjectCodesEntity : ITrainingEventProjectCodesEntity
    {
		public long TrainingEventID { get; set; }
		public int ProjectCodeID { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface ITrainingEventsEntity
	{
		long TrainingEventID { get; set; }
		string Name { get; set; }
		string NameInLocalLang { get; set; }
		int TrainingEventTypeID { get; set; }
		string Justification { get; set; }
		string Objectives { get; set; }
		string ParticipantProfile { get; set; }
		string SpecialRequirements { get; set; }
		int? ProgramID { get; set; }
		int? KeyActivityID { get; set; }
		long? TrainingUnitID { get; set; }
		int CountryID { get; set; }
		int PostID { get; set; }
		int? ConsularDistrictID { get; set; }
		int? OrganizerAppUserID { get; set; }
		int? PlannedParticipantCnt { get; set; }
		int? PlannedMissionDirectHireCnt { get; set; }
		int? PlannedNonMissionDirectHireCnt { get; set; }
		int? PlannedMissionOutsourceCnt { get; set; }
		int? PlannedOtherCnt { get; set; }
		decimal? EstimatedBudget { get; set; }
		decimal? ActualBudget { get; set; }
		int? EstimatedStudents { get; set; }
		int? FundingSourceID { get; set; }
		int? AuthorizingLawID { get; set; }
		string Comments { get; set; }
		DateTime? CreatedDate { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class TrainingEventsEntity : ITrainingEventsEntity
    {
		public long TrainingEventID { get; set; }
		public string Name { get; set; }
		public string NameInLocalLang { get; set; }
		public int TrainingEventTypeID { get; set; }
		public string Justification { get; set; }
		public string Objectives { get; set; }
		public string ParticipantProfile { get; set; }
		public string SpecialRequirements { get; set; }
		public int? ProgramID { get; set; }
		public int? KeyActivityID { get; set; }
		public long? TrainingUnitID { get; set; }
		public int CountryID { get; set; }
		public int PostID { get; set; }
		public int? ConsularDistrictID { get; set; }
		public int? OrganizerAppUserID { get; set; }
		public int? PlannedParticipantCnt { get; set; }
		public int? PlannedMissionDirectHireCnt { get; set; }
		public int? PlannedNonMissionDirectHireCnt { get; set; }
		public int? PlannedMissionOutsourceCnt { get; set; }
		public int? PlannedOtherCnt { get; set; }
		public decimal? EstimatedBudget { get; set; }
		public decimal? ActualBudget { get; set; }
		public int? EstimatedStudents { get; set; }
		public int? FundingSourceID { get; set; }
		public int? AuthorizingLawID { get; set; }
		public string Comments { get; set; }
		public DateTime? CreatedDate { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface ITrainingEventStakeholdersEntity
	{
		long TrainingEventID { get; set; }
		int AppUserID { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class TrainingEventStakeholdersEntity : ITrainingEventStakeholdersEntity
    {
		public long TrainingEventID { get; set; }
		public int AppUserID { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface ITrainingEventStatusesEntity
	{
		int TrainingEventStatusID { get; set; }
		string Name { get; set; }
		string Description { get; set; }
		bool IsActive { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class TrainingEventStatusesEntity : ITrainingEventStatusesEntity
    {
		public int TrainingEventStatusID { get; set; }
		public string Name { get; set; }
		public string Description { get; set; }
		public bool IsActive { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface ITrainingEventStatusLogEntity
	{
		long TrainingEventStatusLogID { get; set; }
		long TrainingEventID { get; set; }
		int TrainingEventStatusID { get; set; }
		string ReasonStatusChanged { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }

	}

    public class TrainingEventStatusLogEntity : ITrainingEventStatusLogEntity
    {
		public long TrainingEventStatusLogID { get; set; }
		public long TrainingEventID { get; set; }
		public int TrainingEventStatusID { get; set; }
		public string ReasonStatusChanged { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }

    }
      
	public interface ITrainingEventStudentAttachmentsEntity
	{
		long TrainingEventStudentAttachmentID { get; set; }
		long PersonID { get; set; }
		long TrainingEventID { get; set; }
		long FileID { get; set; }
		int FileVersion { get; set; }
		int TrainingEventStudentAttachmentTypeID { get; set; }
		string Description { get; set; }
		bool? IsDeleted { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class TrainingEventStudentAttachmentsEntity : ITrainingEventStudentAttachmentsEntity
    {
		public long TrainingEventStudentAttachmentID { get; set; }
		public long PersonID { get; set; }
		public long TrainingEventID { get; set; }
		public long FileID { get; set; }
		public int FileVersion { get; set; }
		public int TrainingEventStudentAttachmentTypeID { get; set; }
		public string Description { get; set; }
		public bool? IsDeleted { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface ITrainingEventStudentAttachmentTypesEntity
	{
		int TrainingEventStudentAttachmentTypeID { get; set; }
		string Name { get; set; }
		string Description { get; set; }
		bool IsActive { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class TrainingEventStudentAttachmentTypesEntity : ITrainingEventStudentAttachmentTypesEntity
    {
		public int TrainingEventStudentAttachmentTypeID { get; set; }
		public string Name { get; set; }
		public string Description { get; set; }
		public bool IsActive { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface ITrainingEventTypesEntity
	{
		int TrainingEventTypeID { get; set; }
		string Name { get; set; }
		string Description { get; set; }
		int? CountryID { get; set; }
		bool IsActive { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class TrainingEventTypesEntity : ITrainingEventTypesEntity
    {
		public int TrainingEventTypeID { get; set; }
		public string Name { get; set; }
		public string Description { get; set; }
		public int? CountryID { get; set; }
		public bool IsActive { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface ITrainingEventUSPartnerAgenciesEntity
	{
		long TrainingEventID { get; set; }
		int AgencyID { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class TrainingEventUSPartnerAgenciesEntity : ITrainingEventUSPartnerAgenciesEntity
    {
		public long TrainingEventID { get; set; }
		public int AgencyID { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      


	public interface IInterAgencyAgreementsAtBusinessUnitViewEntity
	{
	    int InterAgencyAgreementID { get; set; }
	    string Code { get; set; }
	    string Description { get; set; }
	    long BusinessUnitID { get; set; }
	    string Acronym { get; set; }
	    string BusinessUnitName { get; set; }
	    bool BusinessUnitActive { get; set; }
	    bool InterAgencyAgreementBusinessUnitActive { get; set; }

	}

    public class InterAgencyAgreementsAtBusinessUnitViewEntity : IInterAgencyAgreementsAtBusinessUnitViewEntity
    {
		public int InterAgencyAgreementID { get; set; }
		public string Code { get; set; }
		public string Description { get; set; }
		public long BusinessUnitID { get; set; }
		public string Acronym { get; set; }
		public string BusinessUnitName { get; set; }
		public bool BusinessUnitActive { get; set; }
		public bool InterAgencyAgreementBusinessUnitActive { get; set; }

    }
      
	public interface IKeyActivitesAtBusinessUnitViewEntity
	{
	    int KeyActivityID { get; set; }
	    string Code { get; set; }
	    long BusinessUnitID { get; set; }
	    string Acronym { get; set; }
	    string BusinessUnitName { get; set; }
	    bool BusinessUnitActive { get; set; }
	    bool KeyActivityBusinessUnitActive { get; set; }

	}

    public class KeyActivitesAtBusinessUnitViewEntity : IKeyActivitesAtBusinessUnitViewEntity
    {
		public int KeyActivityID { get; set; }
		public string Code { get; set; }
		public long BusinessUnitID { get; set; }
		public string Acronym { get; set; }
		public string BusinessUnitName { get; set; }
		public bool BusinessUnitActive { get; set; }
		public bool KeyActivityBusinessUnitActive { get; set; }

    }
      
	public interface IPersonsTrainingEventsViewEntity
	{
	    long TrainingEventID { get; set; }
	    string Name { get; set; }
	    long PersonID { get; set; }
	    string ParticipantType { get; set; }
	    DateTime? EventStartDate { get; set; }
	    DateTime? EventEndDate { get; set; }
	    string BusinessUnitAcronym { get; set; }
	    string TrainingEventRosterDistinction { get; set; }
	    bool? Certificate { get; set; }
	    string TrainingEventStatus { get; set; }

	}

    public class PersonsTrainingEventsViewEntity : IPersonsTrainingEventsViewEntity
    {
		public long TrainingEventID { get; set; }
		public string Name { get; set; }
		public long PersonID { get; set; }
		public string ParticipantType { get; set; }
		public DateTime? EventStartDate { get; set; }
		public DateTime? EventEndDate { get; set; }
		public string BusinessUnitAcronym { get; set; }
		public string TrainingEventRosterDistinction { get; set; }
		public bool? Certificate { get; set; }
		public string TrainingEventStatus { get; set; }

    }
      
	public interface IProjectCodesAtBusinessUnitViewEntity
	{
	    int ProjectCodeID { get; set; }
	    string Code { get; set; }
	    string Description { get; set; }
	    long BusinessUnitID { get; set; }
	    string Acronym { get; set; }
	    string BusinessUnitName { get; set; }
	    bool BusinessUnitActive { get; set; }
	    bool ProjectCodeBusinessUnitActive { get; set; }

	}

    public class ProjectCodesAtBusinessUnitViewEntity : IProjectCodesAtBusinessUnitViewEntity
    {
		public int ProjectCodeID { get; set; }
		public string Code { get; set; }
		public string Description { get; set; }
		public long BusinessUnitID { get; set; }
		public string Acronym { get; set; }
		public string BusinessUnitName { get; set; }
		public bool BusinessUnitActive { get; set; }
		public bool ProjectCodeBusinessUnitActive { get; set; }

    }
      
	public interface ITrainingEventAttachmentsViewEntity
	{
	    long TrainingEventAttachmentID { get; set; }
	    long TrainingEventID { get; set; }
	    long FileID { get; set; }
	    int FileVersion { get; set; }
	    int TrainingEventAttachmentTypeID { get; set; }
	    string TrainingEventAttachmentType { get; set; }
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

    public class TrainingEventAttachmentsViewEntity : ITrainingEventAttachmentsViewEntity
    {
		public long TrainingEventAttachmentID { get; set; }
		public long TrainingEventID { get; set; }
		public long FileID { get; set; }
		public int FileVersion { get; set; }
		public int TrainingEventAttachmentTypeID { get; set; }
		public string TrainingEventAttachmentType { get; set; }
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
      
	public interface ITrainingEventAttendanceViewEntity
	{
	    long TrainingEventAttendanceID { get; set; }
	    long TrainingEventRosterID { get; set; }
	    DateTime? AttendanceDate { get; set; }
	    bool AttendanceIndicator { get; set; }
	    int ModifiedByAppUserID { get; set; }
	    DateTime ModifiedDate { get; set; }

	}

    public class TrainingEventAttendanceViewEntity : ITrainingEventAttendanceViewEntity
    {
		public long TrainingEventAttendanceID { get; set; }
		public long TrainingEventRosterID { get; set; }
		public DateTime? AttendanceDate { get; set; }
		public bool AttendanceIndicator { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }

    }
      
	public interface ITrainingEventAuthorizingDocumentsViewEntity
	{
	    long TrainingEventID { get; set; }
	    int IAAID { get; set; }
	    int ModifiedByAppUserID { get; set; }
	    DateTime ModifiedDate { get; set; }
	    string IAAsAsJSON { get; set; }
	    string ModifiedByUserAsJSON { get; set; }

	}

    public class TrainingEventAuthorizingDocumentsViewEntity : ITrainingEventAuthorizingDocumentsViewEntity
    {
		public long TrainingEventID { get; set; }
		public int IAAID { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public string IAAsAsJSON { get; set; }
		public string ModifiedByUserAsJSON { get; set; }

    }
      
	public interface ITrainingEventCourseDefinitionsViewEntity
	{
	    long TrainingEventCourseDefinitionID { get; set; }
	    long TrainingEventID { get; set; }
	    int? CourseDefinitionID { get; set; }
	    string CourseRosterKey { get; set; }
	    byte? TestsWeighting { get; set; }
	    byte? PerformanceWeighting { get; set; }
	    byte? ProductsWeighting { get; set; }
	    byte? MinimumAttendance { get; set; }
	    byte? MinimumFinalGrade { get; set; }
	    bool IsActive { get; set; }
	    string CourseDefinition { get; set; }
	    string CourseProgram { get; set; }
	    bool PerformanceRosterUploaded { get; set; }
	    int? PerformanceRosterUploadedByAppUserID { get; set; }
	    string PerformanceRosterUploadedByFirstName { get; set; }
	    string PerformanceRosterUploadedByLastName { get; set; }
	    DateTime? PerformanceRosterUploadedDate { get; set; }
	    int ModifiedByAppUserID { get; set; }
	    DateTime ModifiedDate { get; set; }

	}

    public class TrainingEventCourseDefinitionsViewEntity : ITrainingEventCourseDefinitionsViewEntity
    {
		public long TrainingEventCourseDefinitionID { get; set; }
		public long TrainingEventID { get; set; }
		public int? CourseDefinitionID { get; set; }
		public string CourseRosterKey { get; set; }
		public byte? TestsWeighting { get; set; }
		public byte? PerformanceWeighting { get; set; }
		public byte? ProductsWeighting { get; set; }
		public byte? MinimumAttendance { get; set; }
		public byte? MinimumFinalGrade { get; set; }
		public bool IsActive { get; set; }
		public string CourseDefinition { get; set; }
		public string CourseProgram { get; set; }
		public bool PerformanceRosterUploaded { get; set; }
		public int? PerformanceRosterUploadedByAppUserID { get; set; }
		public string PerformanceRosterUploadedByFirstName { get; set; }
		public string PerformanceRosterUploadedByLastName { get; set; }
		public DateTime? PerformanceRosterUploadedDate { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }

    }
      
	public interface ITrainingEventGroupMembersViewEntity
	{
	    long TrainingEventGroupID { get; set; }
	    string GroupName { get; set; }
	    long PersonID { get; set; }
	    string FirstMiddleNames { get; set; }
	    string LastNames { get; set; }
	    long TrainingEventID { get; set; }
	    string TrainingEventName { get; set; }
	    int MemberTypeID { get; set; }
	    string MemberType { get; set; }
	    int ModifiedByAppUserID { get; set; }

	}

    public class TrainingEventGroupMembersViewEntity : ITrainingEventGroupMembersViewEntity
    {
		public long TrainingEventGroupID { get; set; }
		public string GroupName { get; set; }
		public long PersonID { get; set; }
		public string FirstMiddleNames { get; set; }
		public string LastNames { get; set; }
		public long TrainingEventID { get; set; }
		public string TrainingEventName { get; set; }
		public int MemberTypeID { get; set; }
		public string MemberType { get; set; }
		public int ModifiedByAppUserID { get; set; }

    }
      
	public interface ITrainingEventGroupsViewEntity
	{
	    long TrainingEventGroupID { get; set; }
	    long TrainingEventID { get; set; }
	    string TrainingEventName { get; set; }
	    string GroupName { get; set; }
	    int ModifiedByAppUserID { get; set; }

	}

    public class TrainingEventGroupsViewEntity : ITrainingEventGroupsViewEntity
    {
		public long TrainingEventGroupID { get; set; }
		public long TrainingEventID { get; set; }
		public string TrainingEventName { get; set; }
		public string GroupName { get; set; }
		public int ModifiedByAppUserID { get; set; }

    }
      
	public interface ITrainingEventInstructorRosterViewEntity
	{
	    long? TrainingEventRosterID { get; set; }
	    long TrainingEventID { get; set; }
	    long PersonID { get; set; }
	    string FirstMiddleNames { get; set; }
	    string LastNames { get; set; }
	    string ParticipantType { get; set; }
	    long? TrainingEventGroupID { get; set; }
	    string GroupName { get; set; }
	    byte? PreTestScore { get; set; }
	    byte? PostTestScore { get; set; }
	    byte? PerformanceScore { get; set; }
	    byte? ProductsScore { get; set; }
	    byte? AttendanceScore { get; set; }
	    byte? FinalGradeScore { get; set; }
	    bool? Certificate { get; set; }
	    bool? MinimumAttendanceMet { get; set; }
	    int? TrainingEventRosterDistinctionID { get; set; }
	    string TrainingEventRosterDistinction { get; set; }
	    byte? NonAttendanceReasonID { get; set; }
	    string NonAttendanceReason { get; set; }
	    byte? NonAttendanceCauseID { get; set; }
	    string NonAttendanceCause { get; set; }
	    string Comments { get; set; }
	    int? ModifiedByAppUserID { get; set; }
	    DateTime? ModifiedDate { get; set; }
	    string AttendanceJSON { get; set; }

	}

    public class TrainingEventInstructorRosterViewEntity : ITrainingEventInstructorRosterViewEntity
    {
		public long? TrainingEventRosterID { get; set; }
		public long TrainingEventID { get; set; }
		public long PersonID { get; set; }
		public string FirstMiddleNames { get; set; }
		public string LastNames { get; set; }
		public string ParticipantType { get; set; }
		public long? TrainingEventGroupID { get; set; }
		public string GroupName { get; set; }
		public byte? PreTestScore { get; set; }
		public byte? PostTestScore { get; set; }
		public byte? PerformanceScore { get; set; }
		public byte? ProductsScore { get; set; }
		public byte? AttendanceScore { get; set; }
		public byte? FinalGradeScore { get; set; }
		public bool? Certificate { get; set; }
		public bool? MinimumAttendanceMet { get; set; }
		public int? TrainingEventRosterDistinctionID { get; set; }
		public string TrainingEventRosterDistinction { get; set; }
		public byte? NonAttendanceReasonID { get; set; }
		public string NonAttendanceReason { get; set; }
		public byte? NonAttendanceCauseID { get; set; }
		public string NonAttendanceCause { get; set; }
		public string Comments { get; set; }
		public int? ModifiedByAppUserID { get; set; }
		public DateTime? ModifiedDate { get; set; }
		public string AttendanceJSON { get; set; }

    }
      
	public interface ITrainingEventInstructorsViewEntity
	{
	    long TrainingEventParticipantID { get; set; }
	    long PersonID { get; set; }
	    int? DepartureCountryID { get; set; }
	    int? DepartureStateID { get; set; }
	    int? DepartureCityID { get; set; }
	    long TrainingEventID { get; set; }
	    bool IsTraveling { get; set; }
	    string DepartureCity { get; set; }
	    DateTime? DepartureDate { get; set; }
	    string DepartureState { get; set; }
	    DateTime? ReturnDate { get; set; }
	    int? VisaStatusID { get; set; }
	    string VisaStatus { get; set; }
	    long? PersonsVettingID { get; set; }
	    int? PaperworkStatusID { get; set; }
	    int? TravelDocumentStatusID { get; set; }
	    bool RemovedFromEvent { get; set; }
	    int? RemovalReasonID { get; set; }
	    string RemovalReason { get; set; }
	    int? RemovalCauseID { get; set; }
	    string RemovalCause { get; set; }
	    DateTime? DateCanceled { get; set; }
	    string Comments { get; set; }
	    int ModifiedByAppUserID { get; set; }
	    DateTime ModifiedDate { get; set; }

	}

    public class TrainingEventInstructorsViewEntity : ITrainingEventInstructorsViewEntity
    {
		public long TrainingEventParticipantID { get; set; }
		public long PersonID { get; set; }
		public int? DepartureCountryID { get; set; }
		public int? DepartureStateID { get; set; }
		public int? DepartureCityID { get; set; }
		public long TrainingEventID { get; set; }
		public bool IsTraveling { get; set; }
		public string DepartureCity { get; set; }
		public DateTime? DepartureDate { get; set; }
		public string DepartureState { get; set; }
		public DateTime? ReturnDate { get; set; }
		public int? VisaStatusID { get; set; }
		public string VisaStatus { get; set; }
		public long? PersonsVettingID { get; set; }
		public int? PaperworkStatusID { get; set; }
		public int? TravelDocumentStatusID { get; set; }
		public bool RemovedFromEvent { get; set; }
		public int? RemovalReasonID { get; set; }
		public string RemovalReason { get; set; }
		public int? RemovalCauseID { get; set; }
		public string RemovalCause { get; set; }
		public DateTime? DateCanceled { get; set; }
		public string Comments { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }

    }
      
	public interface ITrainingEventKeyActivitiesViewEntity
	{
	    int KeyActivityID { get; set; }
	    long TrainingEventID { get; set; }
	    string Code { get; set; }
	    string Description { get; set; }
	    int ModifiedByAppUserID { get; set; }
	    DateTime ModifiedDate { get; set; }

	}

    public class TrainingEventKeyActivitiesViewEntity : ITrainingEventKeyActivitiesViewEntity
    {
		public int KeyActivityID { get; set; }
		public long TrainingEventID { get; set; }
		public string Code { get; set; }
		public string Description { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }

    }
      
	public interface ITrainingEventLocationsViewEntity
	{
	    int TrainingEventLocationID { get; set; }
	    long TrainingEventID { get; set; }
	    long LocationID { get; set; }
	    DateTime EventStartDate { get; set; }
	    DateTime EventEndDate { get; set; }
	    DateTime? TravelStartDate { get; set; }
	    DateTime? TravelEndDate { get; set; }
	    int ModifiedByAppUserID { get; set; }
	    DateTime ModifiedDate { get; set; }
	    string LocationName { get; set; }
	    string AddressLine1 { get; set; }
	    string AddressLine2 { get; set; }
	    string AddressLine3 { get; set; }
	    int CityID { get; set; }
	    string CityName { get; set; }
	    int StateID { get; set; }
	    string StateName { get; set; }
	    string StateCodeA2 { get; set; }
	    string StateAbbreviation { get; set; }
	    string StateINKCode { get; set; }
	    int CountryID { get; set; }
	    string CountryName { get; set; }
	    string GENCCodeA2 { get; set; }
	    string CountryAbbreviation { get; set; }
	    string CountryINKCode { get; set; }
	    string LocationJSON { get; set; }
	    string ModifiedByUserJSON { get; set; }

	}

    public class TrainingEventLocationsViewEntity : ITrainingEventLocationsViewEntity
    {
		public int TrainingEventLocationID { get; set; }
		public long TrainingEventID { get; set; }
		public long LocationID { get; set; }
		public DateTime EventStartDate { get; set; }
		public DateTime EventEndDate { get; set; }
		public DateTime? TravelStartDate { get; set; }
		public DateTime? TravelEndDate { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public string LocationName { get; set; }
		public string AddressLine1 { get; set; }
		public string AddressLine2 { get; set; }
		public string AddressLine3 { get; set; }
		public int CityID { get; set; }
		public string CityName { get; set; }
		public int StateID { get; set; }
		public string StateName { get; set; }
		public string StateCodeA2 { get; set; }
		public string StateAbbreviation { get; set; }
		public string StateINKCode { get; set; }
		public int CountryID { get; set; }
		public string CountryName { get; set; }
		public string GENCCodeA2 { get; set; }
		public string CountryAbbreviation { get; set; }
		public string CountryINKCode { get; set; }
		public string LocationJSON { get; set; }
		public string ModifiedByUserJSON { get; set; }

    }
      
	public interface ITrainingEventParticipantAttachmentsViewEntity
	{
	    string ParticipantType { get; set; }
	    long TrainingEventParticipantAttachmentID { get; set; }
	    long TrainingEventID { get; set; }
	    long PersonID { get; set; }
	    long FileID { get; set; }
	    int FileVersion { get; set; }
	    int TrainingEventParticipantAttachmentTypeID { get; set; }
	    string TrainingEventParticipantAttachmentType { get; set; }
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

    public class TrainingEventParticipantAttachmentsViewEntity : ITrainingEventParticipantAttachmentsViewEntity
    {
		public string ParticipantType { get; set; }
		public long TrainingEventParticipantAttachmentID { get; set; }
		public long TrainingEventID { get; set; }
		public long PersonID { get; set; }
		public long FileID { get; set; }
		public int FileVersion { get; set; }
		public int TrainingEventParticipantAttachmentTypeID { get; set; }
		public string TrainingEventParticipantAttachmentType { get; set; }
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
      
	public interface ITrainingEventParticipantsDetailViewEntity
	{
	    string ParticipantType { get; set; }
	    long ParticipantID { get; set; }
	    long TrainingEventID { get; set; }
	    bool IsVIP { get; set; }
	    bool IsParticipant { get; set; }
	    bool IsTraveling { get; set; }
	    long? PersonID { get; set; }
	    string FirstMiddleNames { get; set; }
	    string LastNames { get; set; }
	    char? Gender { get; set; }
	    long? PersonsUnitLibraryInfoID { get; set; }
	    string PoliceMilSecID { get; set; }
	    string JobTitle { get; set; }
	    int? RankID { get; set; }
	    string RankName { get; set; }
	    int? YearsInPosition { get; set; }
	    bool? IsValidated { get; set; }
	    bool? IsUnitCommander { get; set; }
	    bool? IsVettingReq { get; set; }
	    bool? IsLeahyVettingReq { get; set; }
	    string HostNationPOCName { get; set; }
	    string HostNationPOCEmail { get; set; }
	    long? UnitID { get; set; }
	    string UnitName { get; set; }
	    string UnitNameEnglish { get; set; }
	    long? UnitMainAgencyID { get; set; }
	    int? UnitTypeID { get; set; }
	    string UnitParentName { get; set; }
	    string UnitParentNameEnglish { get; set; }
	    string UnitType { get; set; }
	    string AgencyName { get; set; }
	    string AgencyNameEnglish { get; set; }
	    bool? IsUSCitizen { get; set; }
	    string NationalID { get; set; }
	    long? ResidenceLocationID { get; set; }
	    string ResidenceStreetAddress { get; set; }
	    int? ResidenceCityID { get; set; }
	    int? ResidenceStateID { get; set; }
	    int? ResidenceCountryID { get; set; }
	    int? POBCityID { get; set; }
	    string POBCityName { get; set; }
	    int? POBStateID { get; set; }
	    string POBStateName { get; set; }
	    int? POBCountryID { get; set; }
	    string POBCountryName { get; set; }
	    string ContactEmail { get; set; }
	    string ContactPhone { get; set; }
	    DateTime? DOB { get; set; }
	    string FatherName { get; set; }
	    string MotherName { get; set; }
	    int? HighestEducationID { get; set; }
	    decimal? FamilyIncome { get; set; }
	    int? EnglishLanguageProficiencyID { get; set; }
	    string PassportNumber { get; set; }
	    DateTime? PassportExpirationDate { get; set; }
	    int? PassportIssuingCountryID { get; set; }
	    bool? MedicalClearanceStatus { get; set; }
	    DateTime? MedicalClearanceDate { get; set; }
	    bool? PsychologicalClearanceStatus { get; set; }
	    DateTime? PsychologicalClearanceDate { get; set; }
	    int? DepartureCountryID { get; set; }
	    int? DepartureStateID { get; set; }
	    int? DepartureCityID { get; set; }
	    string DepartureCity { get; set; }
	    DateTime? DepartureDate { get; set; }
	    string DepartureState { get; set; }
	    DateTime? ReturnDate { get; set; }
	    int? VettingPersonStatusID { get; set; }
	    string VettingPersonStatus { get; set; }
	    byte? VettingBatchTypeID { get; set; }
	    long? VettingTrainingEventID { get; set; }
	    string VettingTrainingEventName { get; set; }
	    string VettingBatchType { get; set; }
	    int? VettingBatchStatusID { get; set; }
	    DateTime? VettingPersonStatusDate { get; set; }
	    long? PersonsVettingID { get; set; }
	    string VettingBatchStatus { get; set; }
	    bool? IsReVetting { get; set; }
	    int? VisaStatusID { get; set; }
	    string VisaStatus { get; set; }
	    bool HasLocalGovTrust { get; set; }
	    bool? PassedLocalGovTrust { get; set; }
	    bool? OnboardingComplete { get; set; }
	    DateTime? LocalGovTrustCertDate { get; set; }
	    bool OtherVetting { get; set; }
	    bool? PassedOtherVetting { get; set; }
	    string OtherVettingDescription { get; set; }
	    DateTime? OtherVettingDate { get; set; }
	    int? PaperworkStatusID { get; set; }
	    int? TravelDocumentStatusID { get; set; }
	    bool RemovedFromEvent { get; set; }
	    int? RemovalReasonID { get; set; }
	    string RemovalReason { get; set; }
	    bool? RemovedFromVetting { get; set; }
	    int? RemovalCauseID { get; set; }
	    string RemovalCause { get; set; }
	    string TrainingEventRosterDistinction { get; set; }
	    DateTime? DateCanceled { get; set; }
	    string Comments { get; set; }
	    long? TrainingEventGroupID { get; set; }
	    string GroupName { get; set; }
	    int ModifiedByAppUserID { get; set; }
	    DateTime ModifiedDate { get; set; }
	    DateTime? CreatedDate { get; set; }
	    int? DocumentCount { get; set; }
	    string PersonLanguagesJSON { get; set; }
	    string CourtesyVettingsJSON { get; set; }

	}

    public class TrainingEventParticipantsDetailViewEntity : ITrainingEventParticipantsDetailViewEntity
    {
		public string ParticipantType { get; set; }
		public long ParticipantID { get; set; }
		public long TrainingEventID { get; set; }
		public bool IsVIP { get; set; }
		public bool IsParticipant { get; set; }
		public bool IsTraveling { get; set; }
		public long? PersonID { get; set; }
		public string FirstMiddleNames { get; set; }
		public string LastNames { get; set; }
		public char? Gender { get; set; }
		public long? PersonsUnitLibraryInfoID { get; set; }
		public string PoliceMilSecID { get; set; }
		public string JobTitle { get; set; }
		public int? RankID { get; set; }
		public string RankName { get; set; }
		public int? YearsInPosition { get; set; }
		public bool? IsValidated { get; set; }
		public bool? IsUnitCommander { get; set; }
		public bool? IsVettingReq { get; set; }
		public bool? IsLeahyVettingReq { get; set; }
		public string HostNationPOCName { get; set; }
		public string HostNationPOCEmail { get; set; }
		public long? UnitID { get; set; }
		public string UnitName { get; set; }
		public string UnitNameEnglish { get; set; }
		public long? UnitMainAgencyID { get; set; }
		public int? UnitTypeID { get; set; }
		public string UnitParentName { get; set; }
		public string UnitParentNameEnglish { get; set; }
		public string UnitType { get; set; }
		public string AgencyName { get; set; }
		public string AgencyNameEnglish { get; set; }
		public bool? IsUSCitizen { get; set; }
		public string NationalID { get; set; }
		public long? ResidenceLocationID { get; set; }
		public string ResidenceStreetAddress { get; set; }
		public int? ResidenceCityID { get; set; }
		public int? ResidenceStateID { get; set; }
		public int? ResidenceCountryID { get; set; }
		public int? POBCityID { get; set; }
		public string POBCityName { get; set; }
		public int? POBStateID { get; set; }
		public string POBStateName { get; set; }
		public int? POBCountryID { get; set; }
		public string POBCountryName { get; set; }
		public string ContactEmail { get; set; }
		public string ContactPhone { get; set; }
		public DateTime? DOB { get; set; }
		public string FatherName { get; set; }
		public string MotherName { get; set; }
		public int? HighestEducationID { get; set; }
		public decimal? FamilyIncome { get; set; }
		public int? EnglishLanguageProficiencyID { get; set; }
		public string PassportNumber { get; set; }
		public DateTime? PassportExpirationDate { get; set; }
		public int? PassportIssuingCountryID { get; set; }
		public bool? MedicalClearanceStatus { get; set; }
		public DateTime? MedicalClearanceDate { get; set; }
		public bool? PsychologicalClearanceStatus { get; set; }
		public DateTime? PsychologicalClearanceDate { get; set; }
		public int? DepartureCountryID { get; set; }
		public int? DepartureStateID { get; set; }
		public int? DepartureCityID { get; set; }
		public string DepartureCity { get; set; }
		public DateTime? DepartureDate { get; set; }
		public string DepartureState { get; set; }
		public DateTime? ReturnDate { get; set; }
		public int? VettingPersonStatusID { get; set; }
		public string VettingPersonStatus { get; set; }
		public byte? VettingBatchTypeID { get; set; }
		public long? VettingTrainingEventID { get; set; }
		public string VettingTrainingEventName { get; set; }
		public string VettingBatchType { get; set; }
		public int? VettingBatchStatusID { get; set; }
		public DateTime? VettingPersonStatusDate { get; set; }
		public long? PersonsVettingID { get; set; }
		public string VettingBatchStatus { get; set; }
		public bool? IsReVetting { get; set; }
		public int? VisaStatusID { get; set; }
		public string VisaStatus { get; set; }
		public bool HasLocalGovTrust { get; set; }
		public bool? PassedLocalGovTrust { get; set; }
		public bool? OnboardingComplete { get; set; }
		public DateTime? LocalGovTrustCertDate { get; set; }
		public bool OtherVetting { get; set; }
		public bool? PassedOtherVetting { get; set; }
		public string OtherVettingDescription { get; set; }
		public DateTime? OtherVettingDate { get; set; }
		public int? PaperworkStatusID { get; set; }
		public int? TravelDocumentStatusID { get; set; }
		public bool RemovedFromEvent { get; set; }
		public int? RemovalReasonID { get; set; }
		public string RemovalReason { get; set; }
		public bool? RemovedFromVetting { get; set; }
		public int? RemovalCauseID { get; set; }
		public string RemovalCause { get; set; }
		public string TrainingEventRosterDistinction { get; set; }
		public DateTime? DateCanceled { get; set; }
		public string Comments { get; set; }
		public long? TrainingEventGroupID { get; set; }
		public string GroupName { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime? CreatedDate { get; set; }
		public int? DocumentCount { get; set; }
		public string PersonLanguagesJSON { get; set; }
		public string CourtesyVettingsJSON { get; set; }

    }
      
	public interface ITrainingEventParticipantsViewEntity
	{
	    string ParticipantType { get; set; }
	    long TrainingEventID { get; set; }
	    long TrainingEventParticipantID { get; set; }
	    bool IsParticipant { get; set; }
	    bool RemovedFromEvent { get; set; }
	    string DepartureCity { get; set; }
	    DateTime? DepartureDate { get; set; }
	    DateTime? ReturnDate { get; set; }
	    long PersonID { get; set; }
	    long? PersonsVettingID { get; set; }
	    bool IsTraveling { get; set; }
	    bool? OnboardingComplete { get; set; }
	    int? VisaStatusID { get; set; }
	    string VisaStatus { get; set; }
	    string FirstMiddleNames { get; set; }
	    string LastNames { get; set; }
	    char? Gender { get; set; }
	    string ContactEmail { get; set; }
	    DateTime? DOB { get; set; }
	    bool? IsUSCitizen { get; set; }
	    long? TrainingEventGroupID { get; set; }
	    string GroupName { get; set; }
	    int? VettingPersonStatusID { get; set; }
	    string VettingPersonStatus { get; set; }
	    DateTime? VettingPersonStatusDate { get; set; }
	    byte? VettingBatchTypeID { get; set; }
	    string VettingBatchType { get; set; }
	    int? VettingBatchStatusID { get; set; }
	    string VettingBatchStatus { get; set; }
	    DateTime? VettingBatchStatusDate { get; set; }
	    string VettingTrainingEventName { get; set; }
	    string JobTitle { get; set; }
	    string RankName { get; set; }
	    string AgencyName { get; set; }
	    string AgencyNameEnglish { get; set; }
	    string UnitName { get; set; }
	    string UnitNameEnglish { get; set; }
	    string UnitParentName { get; set; }
	    string UnitParentNameEnglish { get; set; }
	    bool? IsLeahyVettingReq { get; set; }
	    bool? IsVettingReq { get; set; }
	    bool? IsValidated { get; set; }
	    long? UnitID { get; set; }
	    bool? RemovedFromVetting { get; set; }
	    long? PersonsUnitLibraryInfoID { get; set; }
	    DateTime? CreatedDate { get; set; }
	    string NationalID { get; set; }
	    int? DocumentCount { get; set; }
	    string CourtesyVettingsJSON { get; set; }

	}

    public class TrainingEventParticipantsViewEntity : ITrainingEventParticipantsViewEntity
    {
		public string ParticipantType { get; set; }
		public long TrainingEventID { get; set; }
		public long TrainingEventParticipantID { get; set; }
		public bool IsParticipant { get; set; }
		public bool RemovedFromEvent { get; set; }
		public string DepartureCity { get; set; }
		public DateTime? DepartureDate { get; set; }
		public DateTime? ReturnDate { get; set; }
		public long PersonID { get; set; }
		public long? PersonsVettingID { get; set; }
		public bool IsTraveling { get; set; }
		public bool? OnboardingComplete { get; set; }
		public int? VisaStatusID { get; set; }
		public string VisaStatus { get; set; }
		public string FirstMiddleNames { get; set; }
		public string LastNames { get; set; }
		public char? Gender { get; set; }
		public string ContactEmail { get; set; }
		public DateTime? DOB { get; set; }
		public bool? IsUSCitizen { get; set; }
		public long? TrainingEventGroupID { get; set; }
		public string GroupName { get; set; }
		public int? VettingPersonStatusID { get; set; }
		public string VettingPersonStatus { get; set; }
		public DateTime? VettingPersonStatusDate { get; set; }
		public byte? VettingBatchTypeID { get; set; }
		public string VettingBatchType { get; set; }
		public int? VettingBatchStatusID { get; set; }
		public string VettingBatchStatus { get; set; }
		public DateTime? VettingBatchStatusDate { get; set; }
		public string VettingTrainingEventName { get; set; }
		public string JobTitle { get; set; }
		public string RankName { get; set; }
		public string AgencyName { get; set; }
		public string AgencyNameEnglish { get; set; }
		public string UnitName { get; set; }
		public string UnitNameEnglish { get; set; }
		public string UnitParentName { get; set; }
		public string UnitParentNameEnglish { get; set; }
		public bool? IsLeahyVettingReq { get; set; }
		public bool? IsVettingReq { get; set; }
		public bool? IsValidated { get; set; }
		public long? UnitID { get; set; }
		public bool? RemovedFromVetting { get; set; }
		public long? PersonsUnitLibraryInfoID { get; set; }
		public DateTime? CreatedDate { get; set; }
		public string NationalID { get; set; }
		public int? DocumentCount { get; set; }
		public string CourtesyVettingsJSON { get; set; }

    }
      
	public interface ITrainingEventParticipantsXLSXViewEntity
	{
	    long? TrainingEventID { get; set; }
	    int ModifiedByAppUserID { get; set; }
	    string ParticipantJSON { get; set; }

	}

    public class TrainingEventParticipantsXLSXViewEntity : ITrainingEventParticipantsXLSXViewEntity
    {
		public long? TrainingEventID { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public string ParticipantJSON { get; set; }

    }
      
	public interface ITrainingEventProjectCodesViewEntity
	{
	    long TrainingEventID { get; set; }
	    int ProjectCodeID { get; set; }
	    string Code { get; set; }
	    string Description { get; set; }
	    int ModifiedByAppUserID { get; set; }
	    DateTime ModifiedDate { get; set; }
	    string ProjectCodeJSON { get; set; }
	    string ModifiedByUserJSON { get; set; }

	}

    public class TrainingEventProjectCodesViewEntity : ITrainingEventProjectCodesViewEntity
    {
		public long TrainingEventID { get; set; }
		public int ProjectCodeID { get; set; }
		public string Code { get; set; }
		public string Description { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public string ProjectCodeJSON { get; set; }
		public string ModifiedByUserJSON { get; set; }

    }
      
	public interface ITrainingEventRosterViewEntity
	{
	    long TrainingEventRosterID { get; set; }
	    long TrainingEventID { get; set; }
	    long PersonID { get; set; }
	    byte? PreTestScore { get; set; }
	    byte? PostTestScore { get; set; }
	    byte? PerformanceScore { get; set; }
	    byte? ProductsScore { get; set; }
	    byte? AttendanceScore { get; set; }
	    byte? FinalGradeScore { get; set; }
	    bool? Certificate { get; set; }
	    bool? MinimumAttendanceMet { get; set; }
	    int? TrainingEventRosterDistinctionID { get; set; }
	    string TrainingEventRosterDistinction { get; set; }
	    byte? NonAttendanceReasonID { get; set; }
	    string NonAttendanceReason { get; set; }
	    byte? NonAttendanceCauseID { get; set; }
	    string NonAttendanceCause { get; set; }
	    string Comments { get; set; }
	    int ModifiedByAppUserID { get; set; }
	    DateTime ModifiedDate { get; set; }
	    string AttendanceJSON { get; set; }

	}

    public class TrainingEventRosterViewEntity : ITrainingEventRosterViewEntity
    {
		public long TrainingEventRosterID { get; set; }
		public long TrainingEventID { get; set; }
		public long PersonID { get; set; }
		public byte? PreTestScore { get; set; }
		public byte? PostTestScore { get; set; }
		public byte? PerformanceScore { get; set; }
		public byte? ProductsScore { get; set; }
		public byte? AttendanceScore { get; set; }
		public byte? FinalGradeScore { get; set; }
		public bool? Certificate { get; set; }
		public bool? MinimumAttendanceMet { get; set; }
		public int? TrainingEventRosterDistinctionID { get; set; }
		public string TrainingEventRosterDistinction { get; set; }
		public byte? NonAttendanceReasonID { get; set; }
		public string NonAttendanceReason { get; set; }
		public byte? NonAttendanceCauseID { get; set; }
		public string NonAttendanceCause { get; set; }
		public string Comments { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public string AttendanceJSON { get; set; }

    }
      
	public interface ITrainingEventsDetailViewEntity
	{
	    long TrainingEventID { get; set; }
	    string Name { get; set; }
	    string NameInLocalLang { get; set; }
	    int TrainingEventTypeID { get; set; }
	    string TrainingEventTypeName { get; set; }
	    string Justification { get; set; }
	    string Objectives { get; set; }
	    string ParticipantProfile { get; set; }
	    string SpecialRequirements { get; set; }
	    int? ProgramID { get; set; }
	    long? TrainingUnitID { get; set; }
	    string BusinessUnitAcronym { get; set; }
	    string BusinessUnitName { get; set; }
	    int CountryID { get; set; }
	    int PostID { get; set; }
	    int? ConsularDistrictID { get; set; }
	    int? OrganizerAppUserID { get; set; }
	    int? PlannedParticipantCnt { get; set; }
	    int? PlannedMissionDirectHireCnt { get; set; }
	    int? PlannedNonMissionDirectHireCnt { get; set; }
	    int? PlannedMissionOutsourceCnt { get; set; }
	    int? PlannedOtherCnt { get; set; }
	    decimal? ActualBudget { get; set; }
	    decimal? EstimatedBudget { get; set; }
	    int? EstimatedStudents { get; set; }
	    int? FundingSourceID { get; set; }
	    int? AuthorizingLawID { get; set; }
	    string Comments { get; set; }
	    int ModifiedByAppUserID { get; set; }
	    DateTime ModifiedDate { get; set; }
	    DateTime? EventStartDate { get; set; }
	    DateTime? EventEndDate { get; set; }
	    DateTime? TravelStartDate { get; set; }
	    DateTime? TravelEndDate { get; set; }
	    int? StudentCount { get; set; }
	    int? InstructorCount { get; set; }
	    string ParticipantCountsJSON { get; set; }
	    int? TrainingEventStatusID { get; set; }
	    string TrainingEventStatus { get; set; }
	    string ModifiedByUserJSON { get; set; }
	    string ProjectCodesJSON { get; set; }
	    string LocationsJSON { get; set; }
	    string USPartnerAgenciesJSON { get; set; }
	    string IAAsJSON { get; set; }
	    string StakeholdersJSON { get; set; }
	    string AttachmentsJSON { get; set; }
	    string OrganizerJSON { get; set; }
	    string CourseProgramJSON { get; set; }
	    string KeyActivitiesJSON { get; set; }

	}

    public class TrainingEventsDetailViewEntity : ITrainingEventsDetailViewEntity
    {
		public long TrainingEventID { get; set; }
		public string Name { get; set; }
		public string NameInLocalLang { get; set; }
		public int TrainingEventTypeID { get; set; }
		public string TrainingEventTypeName { get; set; }
		public string Justification { get; set; }
		public string Objectives { get; set; }
		public string ParticipantProfile { get; set; }
		public string SpecialRequirements { get; set; }
		public int? ProgramID { get; set; }
		public long? TrainingUnitID { get; set; }
		public string BusinessUnitAcronym { get; set; }
		public string BusinessUnitName { get; set; }
		public int CountryID { get; set; }
		public int PostID { get; set; }
		public int? ConsularDistrictID { get; set; }
		public int? OrganizerAppUserID { get; set; }
		public int? PlannedParticipantCnt { get; set; }
		public int? PlannedMissionDirectHireCnt { get; set; }
		public int? PlannedNonMissionDirectHireCnt { get; set; }
		public int? PlannedMissionOutsourceCnt { get; set; }
		public int? PlannedOtherCnt { get; set; }
		public decimal? ActualBudget { get; set; }
		public decimal? EstimatedBudget { get; set; }
		public int? EstimatedStudents { get; set; }
		public int? FundingSourceID { get; set; }
		public int? AuthorizingLawID { get; set; }
		public string Comments { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime? EventStartDate { get; set; }
		public DateTime? EventEndDate { get; set; }
		public DateTime? TravelStartDate { get; set; }
		public DateTime? TravelEndDate { get; set; }
		public int? StudentCount { get; set; }
		public int? InstructorCount { get; set; }
		public string ParticipantCountsJSON { get; set; }
		public int? TrainingEventStatusID { get; set; }
		public string TrainingEventStatus { get; set; }
		public string ModifiedByUserJSON { get; set; }
		public string ProjectCodesJSON { get; set; }
		public string LocationsJSON { get; set; }
		public string USPartnerAgenciesJSON { get; set; }
		public string IAAsJSON { get; set; }
		public string StakeholdersJSON { get; set; }
		public string AttachmentsJSON { get; set; }
		public string OrganizerJSON { get; set; }
		public string CourseProgramJSON { get; set; }
		public string KeyActivitiesJSON { get; set; }

    }
      
	public interface ITrainingEventStakeholdersViewEntity
	{
	    long TrainingEventID { get; set; }
	    int AppUserID { get; set; }
	    string First { get; set; }
	    string Middle { get; set; }
	    string Last { get; set; }
	    string FullName { get; set; }
	    string PositionTitle { get; set; }
	    string EmailAddress { get; set; }
	    string PhoneNumber { get; set; }

	}

    public class TrainingEventStakeholdersViewEntity : ITrainingEventStakeholdersViewEntity
    {
		public long TrainingEventID { get; set; }
		public int AppUserID { get; set; }
		public string First { get; set; }
		public string Middle { get; set; }
		public string Last { get; set; }
		public string FullName { get; set; }
		public string PositionTitle { get; set; }
		public string EmailAddress { get; set; }
		public string PhoneNumber { get; set; }

    }
      
	public interface ITrainingEventStatusLogViewEntity
	{
	    long TrainingEventStatusLogID { get; set; }
	    long TrainingEventID { get; set; }
	    int TrainingEventStatusID { get; set; }
	    string TrainingEventStatus { get; set; }
	    string ReasonStatusChanged { get; set; }
	    int ModifiedByAppUserID { get; set; }
	    DateTime ModifiedDate { get; set; }

	}

    public class TrainingEventStatusLogViewEntity : ITrainingEventStatusLogViewEntity
    {
		public long TrainingEventStatusLogID { get; set; }
		public long TrainingEventID { get; set; }
		public int TrainingEventStatusID { get; set; }
		public string TrainingEventStatus { get; set; }
		public string ReasonStatusChanged { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }

    }
      
	public interface ITrainingEventStudentAttachmentsViewEntity
	{
	    long TrainingEventStudentAttachmentID { get; set; }
	    long TrainingEventID { get; set; }
	    long PersonID { get; set; }
	    long FileID { get; set; }
	    int FileVersion { get; set; }
	    int TrainingEventStudentAttachmentTypeID { get; set; }
	    string TrainingEventStudentAttachmentType { get; set; }
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

    public class TrainingEventStudentAttachmentsViewEntity : ITrainingEventStudentAttachmentsViewEntity
    {
		public long TrainingEventStudentAttachmentID { get; set; }
		public long TrainingEventID { get; set; }
		public long PersonID { get; set; }
		public long FileID { get; set; }
		public int FileVersion { get; set; }
		public int TrainingEventStudentAttachmentTypeID { get; set; }
		public string TrainingEventStudentAttachmentType { get; set; }
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
      
	public interface ITrainingEventStudentRosterViewEntity
	{
	    long? TrainingEventRosterID { get; set; }
	    long TrainingEventID { get; set; }
	    long PersonID { get; set; }
	    string FirstMiddleNames { get; set; }
	    string LastNames { get; set; }
	    string ParticipantType { get; set; }
	    long? TrainingEventGroupID { get; set; }
	    string GroupName { get; set; }
	    byte? PreTestScore { get; set; }
	    byte? PostTestScore { get; set; }
	    byte? PerformanceScore { get; set; }
	    byte? ProductsScore { get; set; }
	    byte? AttendanceScore { get; set; }
	    byte? FinalGradeScore { get; set; }
	    bool? Certificate { get; set; }
	    bool? MinimumAttendanceMet { get; set; }
	    int? TrainingEventRosterDistinctionID { get; set; }
	    string TrainingEventRosterDistinction { get; set; }
	    byte? NonAttendanceReasonID { get; set; }
	    string NonAttendanceReason { get; set; }
	    byte? NonAttendanceCauseID { get; set; }
	    string NonAttendanceCause { get; set; }
	    string Comments { get; set; }
	    int? ModifiedByAppUserID { get; set; }
	    DateTime? ModifiedDate { get; set; }
	    string AttendanceJSON { get; set; }

	}

    public class TrainingEventStudentRosterViewEntity : ITrainingEventStudentRosterViewEntity
    {
		public long? TrainingEventRosterID { get; set; }
		public long TrainingEventID { get; set; }
		public long PersonID { get; set; }
		public string FirstMiddleNames { get; set; }
		public string LastNames { get; set; }
		public string ParticipantType { get; set; }
		public long? TrainingEventGroupID { get; set; }
		public string GroupName { get; set; }
		public byte? PreTestScore { get; set; }
		public byte? PostTestScore { get; set; }
		public byte? PerformanceScore { get; set; }
		public byte? ProductsScore { get; set; }
		public byte? AttendanceScore { get; set; }
		public byte? FinalGradeScore { get; set; }
		public bool? Certificate { get; set; }
		public bool? MinimumAttendanceMet { get; set; }
		public int? TrainingEventRosterDistinctionID { get; set; }
		public string TrainingEventRosterDistinction { get; set; }
		public byte? NonAttendanceReasonID { get; set; }
		public string NonAttendanceReason { get; set; }
		public byte? NonAttendanceCauseID { get; set; }
		public string NonAttendanceCause { get; set; }
		public string Comments { get; set; }
		public int? ModifiedByAppUserID { get; set; }
		public DateTime? ModifiedDate { get; set; }
		public string AttendanceJSON { get; set; }

    }
      
	public interface ITrainingEventsViewEntity
	{
	    long TrainingEventID { get; set; }
	    string Name { get; set; }
	    string NameInLocalLang { get; set; }
	    string TrainingEventType { get; set; }
	    int? ProgramID { get; set; }
	    string BusinessUnitAcronym { get; set; }
	    string BusinessUnit { get; set; }
	    int CountryID { get; set; }
	    int PostID { get; set; }
	    int? OrganizerAppUserID { get; set; }
	    int? TrainingEventStatusID { get; set; }
	    string TrainingEventStatus { get; set; }
	    int ModifiedByAppUserID { get; set; }
	    string ModifiedByAppUser { get; set; }
	    string Organizer { get; set; }
	    DateTime ModifiedDate { get; set; }
	    DateTime? CreatedDate { get; set; }
	    DateTime? EventStartDate { get; set; }
	    DateTime? EventEndDate { get; set; }
	    string LocationsJSON { get; set; }
	    string KeyActivitiesJSON { get; set; }
	    string IAAsJSON { get; set; }

	}

    public class TrainingEventsViewEntity : ITrainingEventsViewEntity
    {
		public long TrainingEventID { get; set; }
		public string Name { get; set; }
		public string NameInLocalLang { get; set; }
		public string TrainingEventType { get; set; }
		public int? ProgramID { get; set; }
		public string BusinessUnitAcronym { get; set; }
		public string BusinessUnit { get; set; }
		public int CountryID { get; set; }
		public int PostID { get; set; }
		public int? OrganizerAppUserID { get; set; }
		public int? TrainingEventStatusID { get; set; }
		public string TrainingEventStatus { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public string ModifiedByAppUser { get; set; }
		public string Organizer { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime? CreatedDate { get; set; }
		public DateTime? EventStartDate { get; set; }
		public DateTime? EventEndDate { get; set; }
		public string LocationsJSON { get; set; }
		public string KeyActivitiesJSON { get; set; }
		public string IAAsJSON { get; set; }

    }
      
	public interface ITrainingEventTypesAtBusinessUnitViewEntity
	{
	    int TrainingEventTypeID { get; set; }
	    string TrainingEventTypeName { get; set; }
	    long BusinessUnitID { get; set; }
	    string Acronym { get; set; }
	    string BusinessUnitName { get; set; }
	    bool BusinessUnitActive { get; set; }
	    bool TrainingEventTypeBusinessUnitActive { get; set; }

	}

    public class TrainingEventTypesAtBusinessUnitViewEntity : ITrainingEventTypesAtBusinessUnitViewEntity
    {
		public int TrainingEventTypeID { get; set; }
		public string TrainingEventTypeName { get; set; }
		public long BusinessUnitID { get; set; }
		public string Acronym { get; set; }
		public string BusinessUnitName { get; set; }
		public bool BusinessUnitActive { get; set; }
		public bool TrainingEventTypeBusinessUnitActive { get; set; }

    }
      
	public interface ITrainingEventUSPartnerAgenciesViewEntity
	{
	    long TrainingEventID { get; set; }
	    int AgencyID { get; set; }
	    int ModifiedByAppUserID { get; set; }
	    DateTime ModifiedDate { get; set; }
	    string Name { get; set; }
	    string Initials { get; set; }
	    bool IsActive { get; set; }
	    string AgencyJSON { get; set; }
	    string ModifiedByUserJSON { get; set; }

	}

    public class TrainingEventUSPartnerAgenciesViewEntity : ITrainingEventUSPartnerAgenciesViewEntity
    {
		public long TrainingEventID { get; set; }
		public int AgencyID { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public string Name { get; set; }
		public string Initials { get; set; }
		public bool IsActive { get; set; }
		public string AgencyJSON { get; set; }
		public string ModifiedByUserJSON { get; set; }

    }
      
	public interface ITrainingEventVisaCheckListsViewEntity
	{
	    long PersonID { get; set; }
	    long TrainingEventID { get; set; }
	    long? TrainingEventVisaCheckListID { get; set; }
	    string FirstMiddleNames { get; set; }
	    string LastNames { get; set; }
	    string AgencyName { get; set; }
	    string VettingStatus { get; set; }
	    bool? HasHostNationCorrespondence { get; set; }
	    bool? HasUSGCorrespondence { get; set; }
	    bool? IsApplicationComplete { get; set; }
	    DateTime? ApplicationSubmittedDate { get; set; }
	    bool? HasPassportAndPhotos { get; set; }
	    string VisaStatus { get; set; }
	    string TrackingNumber { get; set; }
	    string Comments { get; set; }

	}

    public class TrainingEventVisaCheckListsViewEntity : ITrainingEventVisaCheckListsViewEntity
    {
		public long PersonID { get; set; }
		public long TrainingEventID { get; set; }
		public long? TrainingEventVisaCheckListID { get; set; }
		public string FirstMiddleNames { get; set; }
		public string LastNames { get; set; }
		public string AgencyName { get; set; }
		public string VettingStatus { get; set; }
		public bool? HasHostNationCorrespondence { get; set; }
		public bool? HasUSGCorrespondence { get; set; }
		public bool? IsApplicationComplete { get; set; }
		public DateTime? ApplicationSubmittedDate { get; set; }
		public bool? HasPassportAndPhotos { get; set; }
		public string VisaStatus { get; set; }
		public string TrackingNumber { get; set; }
		public string Comments { get; set; }

    }
      
	public interface IUSPartnerAgenciesAtBusinessUnitViewEntity
	{
	    int AgencyID { get; set; }
	    string Name { get; set; }
	    long BusinessUnitID { get; set; }
	    string Acronym { get; set; }
	    string BusinessUnitName { get; set; }
	    bool BusinessUnitActive { get; set; }
	    bool USPartnerAgenciesBusinessUnitActive { get; set; }

	}

    public class USPartnerAgenciesAtBusinessUnitViewEntity : IUSPartnerAgenciesAtBusinessUnitViewEntity
    {
		public int AgencyID { get; set; }
		public string Name { get; set; }
		public long BusinessUnitID { get; set; }
		public string Acronym { get; set; }
		public string BusinessUnitName { get; set; }
		public bool BusinessUnitActive { get; set; }
		public bool USPartnerAgenciesBusinessUnitActive { get; set; }

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
      



	public interface IDeleteTrainingEventGroupMemberEntity
    {
        long? TrainingEventGroupID { get; set; }
        long? PersonID { get; set; }

    }

    public class DeleteTrainingEventGroupMemberEntity : IDeleteTrainingEventGroupMemberEntity
    {
		public long? TrainingEventGroupID { get; set; }
		public long? PersonID { get; set; }

    }
      
	public interface IDeleteTrainingEventParticipantXLSXEntity
    {
        long? ParticipantXLSXID { get; set; }

    }

    public class DeleteTrainingEventParticipantXLSXEntity : IDeleteTrainingEventParticipantXLSXEntity
    {
		public long? ParticipantXLSXID { get; set; }

    }
      
	public interface IGetPersonsTrainingEventsEntity
    {
        long? PersonID { get; set; }
        string TrainingEventStatus { get; set; }

    }

    public class GetPersonsTrainingEventsEntity : IGetPersonsTrainingEventsEntity
    {
		public long? PersonID { get; set; }
		public string TrainingEventStatus { get; set; }

    }
      
	public interface IGetTrainingEventEntity
    {
        long? TrainingEventID { get; set; }

    }

    public class GetTrainingEventEntity : IGetTrainingEventEntity
    {
		public long? TrainingEventID { get; set; }

    }
      
	public interface IGetTrainingEventAttachmentEntity
    {
        long? TrainingEventAttachmentID { get; set; }
        int? FileVersion { get; set; }

    }

    public class GetTrainingEventAttachmentEntity : IGetTrainingEventAttachmentEntity
    {
		public long? TrainingEventAttachmentID { get; set; }
		public int? FileVersion { get; set; }

    }
      
	public interface IGetTrainingEventAttachmentsEntity
    {
        long? TrainingEventID { get; set; }

    }

    public class GetTrainingEventAttachmentsEntity : IGetTrainingEventAttachmentsEntity
    {
		public long? TrainingEventID { get; set; }

    }
      
	public interface IGetTrainingEventAttendanceEntity
    {
        long? TrainingEventAttendanceID { get; set; }

    }

    public class GetTrainingEventAttendanceEntity : IGetTrainingEventAttendanceEntity
    {
		public long? TrainingEventAttendanceID { get; set; }

    }
      
	public interface IGetTrainingEventAttendanceByTrainingEventRosterIDEntity
    {
        long? TrainingEventRosterID { get; set; }

    }

    public class GetTrainingEventAttendanceByTrainingEventRosterIDEntity : IGetTrainingEventAttendanceByTrainingEventRosterIDEntity
    {
		public long? TrainingEventRosterID { get; set; }

    }
      
	public interface IGetTrainingEventCourseDefinitionByTrainingEventIDEntity
    {
        long? TrainingEventID { get; set; }

    }

    public class GetTrainingEventCourseDefinitionByTrainingEventIDEntity : IGetTrainingEventCourseDefinitionByTrainingEventIDEntity
    {
		public long? TrainingEventID { get; set; }

    }
      
	public interface IGetTrainingEventGroupEntity
    {
        long? TrainingEventGroupID { get; set; }

    }

    public class GetTrainingEventGroupEntity : IGetTrainingEventGroupEntity
    {
		public long? TrainingEventGroupID { get; set; }

    }
      
	public interface IGetTrainingEventGroupMemberEntity
    {
        long? TrainingEventGroupID { get; set; }
        long? PersonID { get; set; }

    }

    public class GetTrainingEventGroupMemberEntity : IGetTrainingEventGroupMemberEntity
    {
		public long? TrainingEventGroupID { get; set; }
		public long? PersonID { get; set; }

    }
      
	public interface IGetTrainingEventGroupMembersByTrainingEventGroupIDEntity
    {
        long? TrainingEventGroupID { get; set; }

    }

    public class GetTrainingEventGroupMembersByTrainingEventGroupIDEntity : IGetTrainingEventGroupMembersByTrainingEventGroupIDEntity
    {
		public long? TrainingEventGroupID { get; set; }

    }
      
	public interface IGetTrainingEventInstructorEntity
    {
        long? TrainingEventInstructorID { get; set; }

    }

    public class GetTrainingEventInstructorEntity : IGetTrainingEventInstructorEntity
    {
		public long? TrainingEventInstructorID { get; set; }

    }
      
	public interface IGetTrainingEventInstructorByPersonIDAndTrainingEventIDEntity
    {
        long? PersonID { get; set; }
        long? TrainingEventID { get; set; }

    }

    public class GetTrainingEventInstructorByPersonIDAndTrainingEventIDEntity : IGetTrainingEventInstructorByPersonIDAndTrainingEventIDEntity
    {
		public long? PersonID { get; set; }
		public long? TrainingEventID { get; set; }

    }
      
	public interface IGetTrainingEventInstructorRosterByTrainingEventIDEntity
    {
        long? TrainingEventID { get; set; }

    }

    public class GetTrainingEventInstructorRosterByTrainingEventIDEntity : IGetTrainingEventInstructorRosterByTrainingEventIDEntity
    {
		public long? TrainingEventID { get; set; }

    }
      
	public interface IGetTrainingEventInstructorsByTrainingEventIDEntity
    {
        long? TrainingEventID { get; set; }
        long? TrainingEventGroupID { get; set; }

    }

    public class GetTrainingEventInstructorsByTrainingEventIDEntity : IGetTrainingEventInstructorsByTrainingEventIDEntity
    {
		public long? TrainingEventID { get; set; }
		public long? TrainingEventGroupID { get; set; }

    }
      
	public interface IGetTrainingEventParticipantAttachmentEntity
    {
        long? TrainingEventParticipantAttachmentID { get; set; }
        string ParticipantType { get; set; }
        int? FileVersion { get; set; }

    }

    public class GetTrainingEventParticipantAttachmentEntity : IGetTrainingEventParticipantAttachmentEntity
    {
		public long? TrainingEventParticipantAttachmentID { get; set; }
		public string ParticipantType { get; set; }
		public int? FileVersion { get; set; }

    }
      
	public interface IGetTrainingEventParticipantAttachmentsEntity
    {
        long? TrainingEventID { get; set; }
        long? PersonID { get; set; }
        string ParticipantType { get; set; }

    }

    public class GetTrainingEventParticipantAttachmentsEntity : IGetTrainingEventParticipantAttachmentsEntity
    {
		public long? TrainingEventID { get; set; }
		public long? PersonID { get; set; }
		public string ParticipantType { get; set; }

    }
      
	public interface IGetTrainingEventParticipantByPersonIDAndTrainingEventIDEntity
    {
        long? PersonID { get; set; }
        long? TrainingEventID { get; set; }

    }

    public class GetTrainingEventParticipantByPersonIDAndTrainingEventIDEntity : IGetTrainingEventParticipantByPersonIDAndTrainingEventIDEntity
    {
		public long? PersonID { get; set; }
		public long? TrainingEventID { get; set; }

    }
      
	public interface IGetTrainingEventParticipantsEntity
    {
        long? TrainingEventID { get; set; }
        long? TrainingEventGroupID { get; set; }
        string ParticipantType { get; set; }

    }

    public class GetTrainingEventParticipantsEntity : IGetTrainingEventParticipantsEntity
    {
		public long? TrainingEventID { get; set; }
		public long? TrainingEventGroupID { get; set; }
		public string ParticipantType { get; set; }

    }
      
	public interface IGetTrainingEventRosterEntity
    {
        long? TrainingEventRosterID { get; set; }

    }

    public class GetTrainingEventRosterEntity : IGetTrainingEventRosterEntity
    {
		public long? TrainingEventRosterID { get; set; }

    }
      
	public interface IGetTrainingEventsEntity
    {

    }

    public class GetTrainingEventsEntity : IGetTrainingEventsEntity
    {

    }
      
	public interface IGetTrainingEventStakeholdersEntity
    {
        long? TrainingEventID { get; set; }

    }

    public class GetTrainingEventStakeholdersEntity : IGetTrainingEventStakeholdersEntity
    {
		public long? TrainingEventID { get; set; }

    }
      
	public interface IGetTrainingEventStatusLogEntity
    {
        long? TrainingEventStatusLogID { get; set; }

    }

    public class GetTrainingEventStatusLogEntity : IGetTrainingEventStatusLogEntity
    {
		public long? TrainingEventStatusLogID { get; set; }

    }
      
	public interface IGetTrainingEventStatusLogsEntity
    {
        long? TrainingEventID { get; set; }

    }

    public class GetTrainingEventStatusLogsEntity : IGetTrainingEventStatusLogsEntity
    {
		public long? TrainingEventID { get; set; }

    }
      
	public interface IGetTrainingEventStudentEntity
    {
        long? TrainingEventStudentID { get; set; }

    }

    public class GetTrainingEventStudentEntity : IGetTrainingEventStudentEntity
    {
		public long? TrainingEventStudentID { get; set; }

    }
      
	public interface IGetTrainingEventStudentAttachmentEntity
    {
        long? TrainingEventStudentAttachmentID { get; set; }
        int? FileVersion { get; set; }

    }

    public class GetTrainingEventStudentAttachmentEntity : IGetTrainingEventStudentAttachmentEntity
    {
		public long? TrainingEventStudentAttachmentID { get; set; }
		public int? FileVersion { get; set; }

    }
      
	public interface IGetTrainingEventStudentAttachmentsEntity
    {
        long? TrainingEventID { get; set; }
        long? PersonID { get; set; }

    }

    public class GetTrainingEventStudentAttachmentsEntity : IGetTrainingEventStudentAttachmentsEntity
    {
		public long? TrainingEventID { get; set; }
		public long? PersonID { get; set; }

    }
      
	public interface IGetTrainingEventStudentRosterByTrainingEventIDEntity
    {
        long? TrainingEventID { get; set; }

    }

    public class GetTrainingEventStudentRosterByTrainingEventIDEntity : IGetTrainingEventStudentRosterByTrainingEventIDEntity
    {
		public long? TrainingEventID { get; set; }

    }
      
	public interface IGetTrainingEventStudentsByTrainingEventIDEntity
    {
        long? TrainingEventID { get; set; }
        long? TrainingEventGroupID { get; set; }

    }

    public class GetTrainingEventStudentsByTrainingEventIDEntity : IGetTrainingEventStudentsByTrainingEventIDEntity
    {
		public long? TrainingEventID { get; set; }
		public long? TrainingEventGroupID { get; set; }

    }
      
	public interface IInsertTrainingEventStatusLogEntity
    {
        long? TrainingEventID { get; set; }
        string TrainingEventStatus { get; set; }
        string ReasonStatusChanged { get; set; }
        int? ModifiedByAppUserID { get; set; }

    }

    public class InsertTrainingEventStatusLogEntity : IInsertTrainingEventStatusLogEntity
    {
		public long? TrainingEventID { get; set; }
		public string TrainingEventStatus { get; set; }
		public string ReasonStatusChanged { get; set; }
		public int? ModifiedByAppUserID { get; set; }

    }
      
	public interface IMigrateTrainingEventParticipantsEntity
    {
        long? TrainingEventID { get; set; }
        string PersonsJSON { get; set; }
        bool? ToInstructor { get; set; }
        bool? IsParticipant { get; set; }
        int? ModifiedByAppUserID { get; set; }

    }

    public class MigrateTrainingEventParticipantsEntity : IMigrateTrainingEventParticipantsEntity
    {
		public long? TrainingEventID { get; set; }
		public string PersonsJSON { get; set; }
		public bool? ToInstructor { get; set; }
		public bool? IsParticipant { get; set; }
		public int? ModifiedByAppUserID { get; set; }

    }
      
	public interface IRemoveTrainingEventParticipantsEntity
    {
        long? TrainingEventID { get; set; }
        string PersonsJSON { get; set; }
        long? RemovalReasonID { get; set; }
        long? RemovalCauseID { get; set; }
        DateTime? DateCanceled { get; set; }

    }

    public class RemoveTrainingEventParticipantsEntity : IRemoveTrainingEventParticipantsEntity
    {
		public long? TrainingEventID { get; set; }
		public string PersonsJSON { get; set; }
		public long? RemovalReasonID { get; set; }
		public long? RemovalCauseID { get; set; }
		public DateTime? DateCanceled { get; set; }

    }
      
	public interface ISaveTrainingEventEntity
    {
        long? TrainingEventID { get; set; }
        string Name { get; set; }
        string NameInLocalLang { get; set; }
        int? TrainingEventTypeID { get; set; }
        string Justification { get; set; }
        string Objectives { get; set; }
        string ParticipantProfile { get; set; }
        string SpecialRequirements { get; set; }
        int? ProgramID { get; set; }
        long? TrainingUnitID { get; set; }
        int? CountryID { get; set; }
        int? PostID { get; set; }
        int? ConsularDistrictID { get; set; }
        int? OrganizerAppUserID { get; set; }
        int? PlannedParticipantCnt { get; set; }
        int? PlannedMissionDirectHireCnt { get; set; }
        int? PlannedNonMissionDirectHireCnt { get; set; }
        int? PlannedMissionOutsourceCnt { get; set; }
        int? PlannedOtherCnt { get; set; }
        decimal? EstimatedBudget { get; set; }
        decimal? ActualBudget { get; set; }
        int? EstimatedStudents { get; set; }
        int? FundingSourceID { get; set; }
        int? AuthorizingLawID { get; set; }
        string Comments { get; set; }
        int? ModifiedByAppUserID { get; set; }
        string Locations { get; set; }
        string USPartnerAgencies { get; set; }
        string ProjectCodes { get; set; }
        string Stakeholders { get; set; }
        string IAAs { get; set; }
        string KeyActivities { get; set; }

    }

    public class SaveTrainingEventEntity : ISaveTrainingEventEntity
    {
		public long? TrainingEventID { get; set; }
		public string Name { get; set; }
		public string NameInLocalLang { get; set; }
		public int? TrainingEventTypeID { get; set; }
		public string Justification { get; set; }
		public string Objectives { get; set; }
		public string ParticipantProfile { get; set; }
		public string SpecialRequirements { get; set; }
		public int? ProgramID { get; set; }
		public long? TrainingUnitID { get; set; }
		public int? CountryID { get; set; }
		public int? PostID { get; set; }
		public int? ConsularDistrictID { get; set; }
		public int? OrganizerAppUserID { get; set; }
		public int? PlannedParticipantCnt { get; set; }
		public int? PlannedMissionDirectHireCnt { get; set; }
		public int? PlannedNonMissionDirectHireCnt { get; set; }
		public int? PlannedMissionOutsourceCnt { get; set; }
		public int? PlannedOtherCnt { get; set; }
		public decimal? EstimatedBudget { get; set; }
		public decimal? ActualBudget { get; set; }
		public int? EstimatedStudents { get; set; }
		public int? FundingSourceID { get; set; }
		public int? AuthorizingLawID { get; set; }
		public string Comments { get; set; }
		public int? ModifiedByAppUserID { get; set; }
		public string Locations { get; set; }
		public string USPartnerAgencies { get; set; }
		public string ProjectCodes { get; set; }
		public string Stakeholders { get; set; }
		public string IAAs { get; set; }
		public string KeyActivities { get; set; }

    }
      
	public interface ISaveTrainingEventAttachmentEntity
    {
        long? TrainingEventAttachmentID { get; set; }
        long? TrainingEventID { get; set; }
        long? FileID { get; set; }
        int? FileVersion { get; set; }
        int? TrainingEventAttachmentTypeID { get; set; }
        string Description { get; set; }
        bool? IsDeleted { get; set; }
        int? ModifiedByAppUserID { get; set; }

    }

    public class SaveTrainingEventAttachmentEntity : ISaveTrainingEventAttachmentEntity
    {
		public long? TrainingEventAttachmentID { get; set; }
		public long? TrainingEventID { get; set; }
		public long? FileID { get; set; }
		public int? FileVersion { get; set; }
		public int? TrainingEventAttachmentTypeID { get; set; }
		public string Description { get; set; }
		public bool? IsDeleted { get; set; }
		public int? ModifiedByAppUserID { get; set; }

    }
      
	public interface ISaveTrainingEventAttendanceEntity
    {
        long? TrainingEventAttendanceID { get; set; }
        long? TrainingEventRosterID { get; set; }
        DateTime? AttendanceDate { get; set; }
        bool? AttendanceIndicator { get; set; }
        int? ModifiedByAppUserID { get; set; }

    }

    public class SaveTrainingEventAttendanceEntity : ISaveTrainingEventAttendanceEntity
    {
		public long? TrainingEventAttendanceID { get; set; }
		public long? TrainingEventRosterID { get; set; }
		public DateTime? AttendanceDate { get; set; }
		public bool? AttendanceIndicator { get; set; }
		public int? ModifiedByAppUserID { get; set; }

    }
      
	public interface ISaveTrainingEventAttendanceInBulkEntity
    {
        long? TrainingEventRosterID { get; set; }
        int? ModifiedByAppUserID { get; set; }
        string AttendanceJSON { get; set; }

    }

    public class SaveTrainingEventAttendanceInBulkEntity : ISaveTrainingEventAttendanceInBulkEntity
    {
		public long? TrainingEventRosterID { get; set; }
		public int? ModifiedByAppUserID { get; set; }
		public string AttendanceJSON { get; set; }

    }
      
	public interface ISaveTrainingEventCourseDefinitionEntity
    {
        long? TrainingEventID { get; set; }
        int? CourseDefinitionID { get; set; }
        string CourseRosterKey { get; set; }
        byte? TestsWeighting { get; set; }
        byte? PerformanceWeighting { get; set; }
        byte? ProductsWeighting { get; set; }
        byte? MinimumAttendance { get; set; }
        byte? MinimumFinalGrade { get; set; }
        bool? IsActive { get; set; }
        int? ModifiedByAppUserID { get; set; }

    }

    public class SaveTrainingEventCourseDefinitionEntity : ISaveTrainingEventCourseDefinitionEntity
    {
		public long? TrainingEventID { get; set; }
		public int? CourseDefinitionID { get; set; }
		public string CourseRosterKey { get; set; }
		public byte? TestsWeighting { get; set; }
		public byte? PerformanceWeighting { get; set; }
		public byte? ProductsWeighting { get; set; }
		public byte? MinimumAttendance { get; set; }
		public byte? MinimumFinalGrade { get; set; }
		public bool? IsActive { get; set; }
		public int? ModifiedByAppUserID { get; set; }

    }
      
	public interface ISaveTrainingEventCourseDefinitionUploadStatusEntity
    {
        long? TrainingEventID { get; set; }
        bool? PerformanceRosterUploaded { get; set; }
        int? PerformanceRosterUploadedByAppUserID { get; set; }

    }

    public class SaveTrainingEventCourseDefinitionUploadStatusEntity : ISaveTrainingEventCourseDefinitionUploadStatusEntity
    {
		public long? TrainingEventID { get; set; }
		public bool? PerformanceRosterUploaded { get; set; }
		public int? PerformanceRosterUploadedByAppUserID { get; set; }

    }
      
	public interface ISaveTrainingEventGroupEntity
    {
        long? TrainingEventGroupID { get; set; }
        long? TrainingEventID { get; set; }
        string GroupName { get; set; }
        long? ModifiedByAppUserID { get; set; }

    }

    public class SaveTrainingEventGroupEntity : ISaveTrainingEventGroupEntity
    {
		public long? TrainingEventGroupID { get; set; }
		public long? TrainingEventID { get; set; }
		public string GroupName { get; set; }
		public long? ModifiedByAppUserID { get; set; }

    }
      
	public interface ISaveTrainingEventGroupMemberEntity
    {
        long? TrainingEventGroupID { get; set; }
        long? PersonID { get; set; }
        long? MemberTypeID { get; set; }
        long? ModifiedByAppUserID { get; set; }

    }

    public class SaveTrainingEventGroupMemberEntity : ISaveTrainingEventGroupMemberEntity
    {
		public long? TrainingEventGroupID { get; set; }
		public long? PersonID { get; set; }
		public long? MemberTypeID { get; set; }
		public long? ModifiedByAppUserID { get; set; }

    }
      
	public interface ISaveTrainingEventGroupMembersEntity
    {
        long? TrainingEventGroupID { get; set; }
        string PersonsJSON { get; set; }
        long? MemberTypeID { get; set; }
        long? ModifiedByAppUserID { get; set; }

    }

    public class SaveTrainingEventGroupMembersEntity : ISaveTrainingEventGroupMembersEntity
    {
		public long? TrainingEventGroupID { get; set; }
		public string PersonsJSON { get; set; }
		public long? MemberTypeID { get; set; }
		public long? ModifiedByAppUserID { get; set; }

    }
      
	public interface ISaveTrainingEventInstructorEntity
    {
        long? PersonID { get; set; }
        long? TrainingEventID { get; set; }
        bool? IsTraveling { get; set; }
        long? PersonsVettingID { get; set; }
        int? DepartureCityID { get; set; }
        DateTime? DepartureDate { get; set; }
        DateTime? ReturnDate { get; set; }
        int? VisaStatusID { get; set; }
        bool? HasLocalGovTrust { get; set; }
        bool? PassedLocalGovTrust { get; set; }
        DateTime? LocalGovTrustCertDate { get; set; }
        bool? OtherVetting { get; set; }
        bool? PassedOtherVetting { get; set; }
        string OtherVettingDescription { get; set; }
        DateTime? OtherVettingDate { get; set; }
        int? PaperworkStatusID { get; set; }
        int? TravelDocumentStatusID { get; set; }
        bool? RemovedFromEvent { get; set; }
        int? RemovalReasonID { get; set; }
        int? RemovalCauseID { get; set; }
        DateTime? DateCanceled { get; set; }
        string Comments { get; set; }
        int? ModifiedByAppUserID { get; set; }

    }

    public class SaveTrainingEventInstructorEntity : ISaveTrainingEventInstructorEntity
    {
		public long? PersonID { get; set; }
		public long? TrainingEventID { get; set; }
		public bool? IsTraveling { get; set; }
		public long? PersonsVettingID { get; set; }
		public int? DepartureCityID { get; set; }
		public DateTime? DepartureDate { get; set; }
		public DateTime? ReturnDate { get; set; }
		public int? VisaStatusID { get; set; }
		public bool? HasLocalGovTrust { get; set; }
		public bool? PassedLocalGovTrust { get; set; }
		public DateTime? LocalGovTrustCertDate { get; set; }
		public bool? OtherVetting { get; set; }
		public bool? PassedOtherVetting { get; set; }
		public string OtherVettingDescription { get; set; }
		public DateTime? OtherVettingDate { get; set; }
		public int? PaperworkStatusID { get; set; }
		public int? TravelDocumentStatusID { get; set; }
		public bool? RemovedFromEvent { get; set; }
		public int? RemovalReasonID { get; set; }
		public int? RemovalCauseID { get; set; }
		public DateTime? DateCanceled { get; set; }
		public string Comments { get; set; }
		public int? ModifiedByAppUserID { get; set; }

    }
      
	public interface ISaveTrainingEventInstructorsEntity
    {
        long? TrainingEventID { get; set; }
        int? ModifiedByAppUserID { get; set; }
        string PersonsJSON { get; set; }

    }

    public class SaveTrainingEventInstructorsEntity : ISaveTrainingEventInstructorsEntity
    {
		public long? TrainingEventID { get; set; }
		public int? ModifiedByAppUserID { get; set; }
		public string PersonsJSON { get; set; }

    }
      
	public interface ISaveTrainingEventLocationsEntity
    {
        long? TrainingEventID { get; set; }
        int? ModifiedByAppUserID { get; set; }
        string Locations { get; set; }

    }

    public class SaveTrainingEventLocationsEntity : ISaveTrainingEventLocationsEntity
    {
		public long? TrainingEventID { get; set; }
		public int? ModifiedByAppUserID { get; set; }
		public string Locations { get; set; }

    }
      
	public interface ISaveTrainingEventParticipantEntity
    {
        long? ParticipantID { get; set; }
        long? PersonID { get; set; }
        string ParticipantType { get; set; }
        long? TrainingEventID { get; set; }
        bool? IsVIP { get; set; }
        bool? IsParticipant { get; set; }
        bool? IsTraveling { get; set; }
        int? DepartureCityID { get; set; }
        DateTime? DepartureDate { get; set; }
        DateTime? ReturnDate { get; set; }
        int? VisaStatusID { get; set; }
        bool? HasLocalGovTrust { get; set; }
        bool? PassedLocalGovTrust { get; set; }
        DateTime? LocalGovTrustCertDate { get; set; }
        bool? OtherVetting { get; set; }
        bool? PassedOtherVetting { get; set; }
        string OtherVettingDescription { get; set; }
        DateTime? OtherVettingDate { get; set; }
        int? PaperworkStatusID { get; set; }
        int? TravelDocumentStatusID { get; set; }
        bool? RemovedFromEvent { get; set; }
        int? RemovalReasonID { get; set; }
        int? RemovalCauseID { get; set; }
        DateTime? DateCanceled { get; set; }
        string Comments { get; set; }
        int? ModifiedByAppUserID { get; set; }

    }

    public class SaveTrainingEventParticipantEntity : ISaveTrainingEventParticipantEntity
    {
		public long? ParticipantID { get; set; }
		public long? PersonID { get; set; }
		public string ParticipantType { get; set; }
		public long? TrainingEventID { get; set; }
		public bool? IsVIP { get; set; }
		public bool? IsParticipant { get; set; }
		public bool? IsTraveling { get; set; }
		public int? DepartureCityID { get; set; }
		public DateTime? DepartureDate { get; set; }
		public DateTime? ReturnDate { get; set; }
		public int? VisaStatusID { get; set; }
		public bool? HasLocalGovTrust { get; set; }
		public bool? PassedLocalGovTrust { get; set; }
		public DateTime? LocalGovTrustCertDate { get; set; }
		public bool? OtherVetting { get; set; }
		public bool? PassedOtherVetting { get; set; }
		public string OtherVettingDescription { get; set; }
		public DateTime? OtherVettingDate { get; set; }
		public int? PaperworkStatusID { get; set; }
		public int? TravelDocumentStatusID { get; set; }
		public bool? RemovedFromEvent { get; set; }
		public int? RemovalReasonID { get; set; }
		public int? RemovalCauseID { get; set; }
		public DateTime? DateCanceled { get; set; }
		public string Comments { get; set; }
		public int? ModifiedByAppUserID { get; set; }

    }
      
	public interface ISaveTrainingEventParticipantAttachmentEntity
    {
        long? TrainingEventParticipantAttachmentID { get; set; }
        long? TrainingEventID { get; set; }
        long? PersonID { get; set; }
        string ParticipantType { get; set; }
        long? FileID { get; set; }
        int? FileVersion { get; set; }
        int? TrainingEventParticipantAttachmentTypeID { get; set; }
        string Description { get; set; }
        bool? IsDeleted { get; set; }
        int? ModifiedByAppUserID { get; set; }

    }

    public class SaveTrainingEventParticipantAttachmentEntity : ISaveTrainingEventParticipantAttachmentEntity
    {
		public long? TrainingEventParticipantAttachmentID { get; set; }
		public long? TrainingEventID { get; set; }
		public long? PersonID { get; set; }
		public string ParticipantType { get; set; }
		public long? FileID { get; set; }
		public int? FileVersion { get; set; }
		public int? TrainingEventParticipantAttachmentTypeID { get; set; }
		public string Description { get; set; }
		public bool? IsDeleted { get; set; }
		public int? ModifiedByAppUserID { get; set; }

    }
      
	public interface ISaveTrainingEventParticipantsXLSXEntity
    {
        long? TrainingEventID { get; set; }
        int? ModifiedByAppUserID { get; set; }
        string Participants { get; set; }

    }

    public class SaveTrainingEventParticipantsXLSXEntity : ISaveTrainingEventParticipantsXLSXEntity
    {
		public long? TrainingEventID { get; set; }
		public int? ModifiedByAppUserID { get; set; }
		public string Participants { get; set; }

    }
      
	public interface ISaveTrainingEventParticipantValueEntity
    {
        string ColumnName { get; set; }
        string Value { get; set; }
        string ParticipantType { get; set; }
        long? PersonID { get; set; }
        long? TrainingEventID { get; set; }

    }

    public class SaveTrainingEventParticipantValueEntity : ISaveTrainingEventParticipantValueEntity
    {
		public string ColumnName { get; set; }
		public string Value { get; set; }
		public string ParticipantType { get; set; }
		public long? PersonID { get; set; }
		public long? TrainingEventID { get; set; }

    }
      
	public interface ISaveTrainingEventParticipantXLSXEntity
    {
        long? ParticipantXLSXID { get; set; }
        string ParticipantStatus { get; set; }
        string FirstMiddleName { get; set; }
        string LastName { get; set; }
        string NationalID { get; set; }
        char? Gender { get; set; }
        string IsUSCitizen { get; set; }
        DateTime? DOB { get; set; }
        string POBCity { get; set; }
        string POBState { get; set; }
        string POBCountry { get; set; }
        string ResidenceCity { get; set; }
        string ResidenceState { get; set; }
        string ResidenceCountry { get; set; }
        string ContactEmail { get; set; }
        string ContactPhone { get; set; }
        string UnitGenID { get; set; }
        string VettingType { get; set; }
        string JobTitle { get; set; }
        int? YearsInPosition { get; set; }
        string IsUnitCommander { get; set; }
        string PoliceMilSecID { get; set; }
        string POCName { get; set; }
        string POCEmail { get; set; }
        string DepartureCity { get; set; }
        int? DepartureCityID { get; set; }
        int? DepartureStateID { get; set; }
        int? DepartureCountryID { get; set; }
        string PassportNumber { get; set; }
        DateTime? PassportExpirationDate { get; set; }
        string Comments { get; set; }
        string HasLocalGovTrust { get; set; }
        DateTime? LocalGovTrustCertDate { get; set; }
        string PassedExternalVetting { get; set; }
        string ExternalVettingDescription { get; set; }
        DateTime? ExternalVettingDate { get; set; }
        string EnglishLanguageProficiency { get; set; }
        string HighestEducation { get; set; }
        string Rank { get; set; }
        long? PersonID { get; set; }
        int? ModifiedByAppUserID { get; set; }

    }

    public class SaveTrainingEventParticipantXLSXEntity : ISaveTrainingEventParticipantXLSXEntity
    {
		public long? ParticipantXLSXID { get; set; }
		public string ParticipantStatus { get; set; }
		public string FirstMiddleName { get; set; }
		public string LastName { get; set; }
		public string NationalID { get; set; }
		public char? Gender { get; set; }
		public string IsUSCitizen { get; set; }
		public DateTime? DOB { get; set; }
		public string POBCity { get; set; }
		public string POBState { get; set; }
		public string POBCountry { get; set; }
		public string ResidenceCity { get; set; }
		public string ResidenceState { get; set; }
		public string ResidenceCountry { get; set; }
		public string ContactEmail { get; set; }
		public string ContactPhone { get; set; }
		public string UnitGenID { get; set; }
		public string VettingType { get; set; }
		public string JobTitle { get; set; }
		public int? YearsInPosition { get; set; }
		public string IsUnitCommander { get; set; }
		public string PoliceMilSecID { get; set; }
		public string POCName { get; set; }
		public string POCEmail { get; set; }
		public string DepartureCity { get; set; }
		public int? DepartureCityID { get; set; }
		public int? DepartureStateID { get; set; }
		public int? DepartureCountryID { get; set; }
		public string PassportNumber { get; set; }
		public DateTime? PassportExpirationDate { get; set; }
		public string Comments { get; set; }
		public string HasLocalGovTrust { get; set; }
		public DateTime? LocalGovTrustCertDate { get; set; }
		public string PassedExternalVetting { get; set; }
		public string ExternalVettingDescription { get; set; }
		public DateTime? ExternalVettingDate { get; set; }
		public string EnglishLanguageProficiency { get; set; }
		public string HighestEducation { get; set; }
		public string Rank { get; set; }
		public long? PersonID { get; set; }
		public int? ModifiedByAppUserID { get; set; }

    }
      
	public interface ISaveTrainingEventProjectCodesEntity
    {
        long? TrainingEventID { get; set; }
        int? ModifiedByAppUserID { get; set; }
        string ProjectCodes { get; set; }

    }

    public class SaveTrainingEventProjectCodesEntity : ISaveTrainingEventProjectCodesEntity
    {
		public long? TrainingEventID { get; set; }
		public int? ModifiedByAppUserID { get; set; }
		public string ProjectCodes { get; set; }

    }
      
	public interface ISaveTrainingEventRosterEntity
    {
        long? TrainingEventRosterID { get; set; }
        long? TrainingEventID { get; set; }
        long? PersonID { get; set; }
        byte? PreTestScore { get; set; }
        byte? PostTestScore { get; set; }
        byte? PerformanceScore { get; set; }
        byte? ProductsScore { get; set; }
        byte? AttendanceScore { get; set; }
        byte? FinalGradeScore { get; set; }
        bool? Certificate { get; set; }
        bool? MinimumAttendanceMet { get; set; }
        int? TrainingEventRosterDistinctionID { get; set; }
        string TrainingEventRosterDistinction { get; set; }
        byte? NonAttendanceReasonID { get; set; }
        string NonAttendanceReason { get; set; }
        byte? NonAttendanceCauseID { get; set; }
        string NonAttendanceCause { get; set; }
        string Comments { get; set; }
        int? ModifiedByAppUserID { get; set; }

    }

    public class SaveTrainingEventRosterEntity : ISaveTrainingEventRosterEntity
    {
		public long? TrainingEventRosterID { get; set; }
		public long? TrainingEventID { get; set; }
		public long? PersonID { get; set; }
		public byte? PreTestScore { get; set; }
		public byte? PostTestScore { get; set; }
		public byte? PerformanceScore { get; set; }
		public byte? ProductsScore { get; set; }
		public byte? AttendanceScore { get; set; }
		public byte? FinalGradeScore { get; set; }
		public bool? Certificate { get; set; }
		public bool? MinimumAttendanceMet { get; set; }
		public int? TrainingEventRosterDistinctionID { get; set; }
		public string TrainingEventRosterDistinction { get; set; }
		public byte? NonAttendanceReasonID { get; set; }
		public string NonAttendanceReason { get; set; }
		public byte? NonAttendanceCauseID { get; set; }
		public string NonAttendanceCause { get; set; }
		public string Comments { get; set; }
		public int? ModifiedByAppUserID { get; set; }

    }
      
	public interface ISaveTrainingEventStakeholdersEntity
    {
        long? TrainingEventID { get; set; }
        int? ModifiedByAppUserID { get; set; }
        string Stakeholders { get; set; }

    }

    public class SaveTrainingEventStakeholdersEntity : ISaveTrainingEventStakeholdersEntity
    {
		public long? TrainingEventID { get; set; }
		public int? ModifiedByAppUserID { get; set; }
		public string Stakeholders { get; set; }

    }
      
	public interface ISaveTrainingEventStudentAttachmentEntity
    {
        long? TrainingEventStudentAttachmentID { get; set; }
        long? TrainingEventID { get; set; }
        long? PersonID { get; set; }
        long? FileID { get; set; }
        int? FileVersion { get; set; }
        int? TrainingEventStudentAttachmentTypeID { get; set; }
        string Description { get; set; }
        bool? IsDeleted { get; set; }
        int? ModifiedByAppUserID { get; set; }

    }

    public class SaveTrainingEventStudentAttachmentEntity : ISaveTrainingEventStudentAttachmentEntity
    {
		public long? TrainingEventStudentAttachmentID { get; set; }
		public long? TrainingEventID { get; set; }
		public long? PersonID { get; set; }
		public long? FileID { get; set; }
		public int? FileVersion { get; set; }
		public int? TrainingEventStudentAttachmentTypeID { get; set; }
		public string Description { get; set; }
		public bool? IsDeleted { get; set; }
		public int? ModifiedByAppUserID { get; set; }

    }
      
	public interface ISaveTrainingEventStudentsEntity
    {
        long? TrainingEventID { get; set; }
        int? ModifiedByAppUserID { get; set; }
        string PersonsJSON { get; set; }

    }

    public class SaveTrainingEventStudentsEntity : ISaveTrainingEventStudentsEntity
    {
		public long? TrainingEventID { get; set; }
		public int? ModifiedByAppUserID { get; set; }
		public string PersonsJSON { get; set; }

    }
      
	public interface ISaveTrainingEventUSPartnerAgenciesEntity
    {
        long? TrainingEventID { get; set; }
        int? ModifiedByAppUserID { get; set; }
        string USPartnerAgencies { get; set; }

    }

    public class SaveTrainingEventUSPartnerAgenciesEntity : ISaveTrainingEventUSPartnerAgenciesEntity
    {
		public long? TrainingEventID { get; set; }
		public int? ModifiedByAppUserID { get; set; }
		public string USPartnerAgencies { get; set; }

    }
      
	public interface ISaveTrainingEventVisaCheckListsEntity
    {
        long? TrainingEventID { get; set; }
        string VisaCheckListJSON { get; set; }
        long? ModifiedByAppUserID { get; set; }

    }

    public class SaveTrainingEventVisaCheckListsEntity : ISaveTrainingEventVisaCheckListsEntity
    {
		public long? TrainingEventID { get; set; }
		public string VisaCheckListJSON { get; set; }
		public long? ModifiedByAppUserID { get; set; }

    }
      
	public interface IUpdateTrainingEventStudentsParticipantFlagEntity
    {
        long? TrainingEventID { get; set; }
        string PersonsJSON { get; set; }
        bool? IsParticipant { get; set; }

    }

    public class UpdateTrainingEventStudentsParticipantFlagEntity : IUpdateTrainingEventStudentsParticipantFlagEntity
    {
		public long? TrainingEventID { get; set; }
		public string PersonsJSON { get; set; }
		public bool? IsParticipant { get; set; }

    }
      
	public interface IUpdateTypeTrainingEventParticipantsEntity
    {
        long? TrainingEventID { get; set; }
        string PersonsJSON { get; set; }
        int? TrainingEventParticipantTypeID { get; set; }
        long? RemovalReasonID { get; set; }
        long? RemovalCauseID { get; set; }
        DateTime? DateCanceled { get; set; }

    }

    public class UpdateTypeTrainingEventParticipantsEntity : IUpdateTypeTrainingEventParticipantsEntity
    {
		public long? TrainingEventID { get; set; }
		public string PersonsJSON { get; set; }
		public int? TrainingEventParticipantTypeID { get; set; }
		public long? RemovalReasonID { get; set; }
		public long? RemovalCauseID { get; set; }
		public DateTime? DateCanceled { get; set; }

    }
      





}



