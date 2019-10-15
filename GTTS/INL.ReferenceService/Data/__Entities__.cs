 
  




using System;


namespace INL.ReferenceService.Data
{
  
	public interface ICountriesEntity
	{
		int CountryID { get; set; }
		string CountryName { get; set; }
		string CountryFullName { get; set; }
		string GENCCodeA2 { get; set; }
		string GENCCodeA3 { get; set; }
		int? GENCCodeNumber { get; set; }
		string INKCode { get; set; }
		bool? CountryIndicator { get; set; }
		int? DOSBureauID { get; set; }
		string CurrencyName { get; set; }
		string CurrencyCodeA3 { get; set; }
		int? CurrencyCodeNumber { get; set; }
		string CurrencySymbol { get; set; }
		int? NameFormatID { get; set; }
		int? NationalIDFormatID { get; set; }
		bool IsActive { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class CountriesEntity : ICountriesEntity
    {
		public int CountryID { get; set; }
		public string CountryName { get; set; }
		public string CountryFullName { get; set; }
		public string GENCCodeA2 { get; set; }
		public string GENCCodeA3 { get; set; }
		public int? GENCCodeNumber { get; set; }
		public string INKCode { get; set; }
		public bool? CountryIndicator { get; set; }
		public int? DOSBureauID { get; set; }
		public string CurrencyName { get; set; }
		public string CurrencyCodeA3 { get; set; }
		public int? CurrencyCodeNumber { get; set; }
		public string CurrencySymbol { get; set; }
		public int? NameFormatID { get; set; }
		public int? NationalIDFormatID { get; set; }
		public bool IsActive { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface ILanguageProficienciesEntity
	{
		int LanguageProficiencyID { get; set; }
		string Code { get; set; }
		string Description { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class LanguageProficienciesEntity : ILanguageProficienciesEntity
    {
		public int LanguageProficiencyID { get; set; }
		public string Code { get; set; }
		public string Description { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface ILanguagesEntity
	{
		int LanguageID { get; set; }
		string Code { get; set; }
		string Description { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class LanguagesEntity : ILanguagesEntity
    {
		public int LanguageID { get; set; }
		public string Code { get; set; }
		public string Description { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface IPostsEntity
	{
		int PostID { get; set; }
		string Name { get; set; }
		string FullName { get; set; }
		int PostTypeID { get; set; }
		int CountryID { get; set; }
		int MissionID { get; set; }
		int? GMTOffset { get; set; }
		bool IsActive { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class PostsEntity : IPostsEntity
    {
		public int PostID { get; set; }
		public string Name { get; set; }
		public string FullName { get; set; }
		public int PostTypeID { get; set; }
		public int CountryID { get; set; }
		public int MissionID { get; set; }
		public int? GMTOffset { get; set; }
		public bool IsActive { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface IStatesEntity
	{
		int StateID { get; set; }
		string StateName { get; set; }
		string StateCodeA2 { get; set; }
		string Abbreviation { get; set; }
		string INKCode { get; set; }
		int CountryID { get; set; }
		bool IsActive { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class StatesEntity : IStatesEntity
    {
		public int StateID { get; set; }
		public string StateName { get; set; }
		public string StateCodeA2 { get; set; }
		public string Abbreviation { get; set; }
		public string INKCode { get; set; }
		public int CountryID { get; set; }
		public bool IsActive { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface IEducationLevelsEntity
	{
		int EducationLevelID { get; set; }
		string Code { get; set; }
		string Description { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class EducationLevelsEntity : IEducationLevelsEntity
    {
		public int EducationLevelID { get; set; }
		public string Code { get; set; }
		public string Description { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface IJobTitlesEntity
	{
		int JobTitleID { get; set; }
		int CountryID { get; set; }
		string JobTitleCode { get; set; }
		string JobTitleLocalLanguage { get; set; }
		string JobTitleEnglish { get; set; }
		bool IsActive { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class JobTitlesEntity : IJobTitlesEntity
    {
		public int JobTitleID { get; set; }
		public int CountryID { get; set; }
		public string JobTitleCode { get; set; }
		public string JobTitleLocalLanguage { get; set; }
		public string JobTitleEnglish { get; set; }
		public bool IsActive { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface IRanksEntity
	{
		int RankID { get; set; }
		int CountryID { get; set; }
		int RankBranchID { get; set; }
		int RankTypeID { get; set; }
		int RankGrade { get; set; }
		string RankName { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class RanksEntity : IRanksEntity
    {
		public int RankID { get; set; }
		public int CountryID { get; set; }
		public int RankBranchID { get; set; }
		public int RankTypeID { get; set; }
		public int RankGrade { get; set; }
		public string RankName { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface IKeyActivitiesEntity
	{
		int KeyActivityID { get; set; }
		string Code { get; set; }
		string Description { get; set; }
		bool IsActive { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class KeyActivitiesEntity : IKeyActivitiesEntity
    {
		public int KeyActivityID { get; set; }
		public string Code { get; set; }
		public string Description { get; set; }
		public bool IsActive { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface INonAttendanceCausesEntity
	{
		byte NonAttendanceCauseID { get; set; }
		string Description { get; set; }
		bool IsActive { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class NonAttendanceCausesEntity : INonAttendanceCausesEntity
    {
		public byte NonAttendanceCauseID { get; set; }
		public string Description { get; set; }
		public bool IsActive { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface INonAttendanceReasonsEntity
	{
		byte NonAttendanceReasonID { get; set; }
		string Description { get; set; }
		bool IsActive { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class NonAttendanceReasonsEntity : INonAttendanceReasonsEntity
    {
		public byte NonAttendanceReasonID { get; set; }
		public string Description { get; set; }
		public bool IsActive { get; set; }
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
      
	public interface IRemovalCausesEntity
	{
		int RemovalCauseID { get; set; }
		int RemovalReasonID { get; set; }
		string Description { get; set; }
		bool IsActive { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class RemovalCausesEntity : IRemovalCausesEntity
    {
		public int RemovalCauseID { get; set; }
		public int RemovalReasonID { get; set; }
		public string Description { get; set; }
		public bool IsActive { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface IRemovalReasonsEntity
	{
		int RemovalReasonID { get; set; }
		string Description { get; set; }
		bool IsActive { get; set; }
		byte SortControl { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class RemovalReasonsEntity : IRemovalReasonsEntity
    {
		public int RemovalReasonID { get; set; }
		public string Description { get; set; }
		public bool IsActive { get; set; }
		public byte SortControl { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface ITrainingEventRosterDistinctionsEntity
	{
		int TrainingEventRosterDistinctionID { get; set; }
		int? PostID { get; set; }
		string Code { get; set; }
		string Description { get; set; }
		bool IsActive { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class TrainingEventRosterDistinctionsEntity : ITrainingEventRosterDistinctionsEntity
    {
		public int TrainingEventRosterDistinctionID { get; set; }
		public int? PostID { get; set; }
		public string Code { get; set; }
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
      
	public interface IVisaStatusesEntity
	{
		int VisaStatusID { get; set; }
		string Code { get; set; }
		string Description { get; set; }
		bool IsActive { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class VisaStatusesEntity : IVisaStatusesEntity
    {
		public int VisaStatusID { get; set; }
		public string Code { get; set; }
		public string Description { get; set; }
		public bool IsActive { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface IGovtLevelsEntity
	{
		int GovtLevelID { get; set; }
		string Name { get; set; }
		string Description { get; set; }
		bool IsActive { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class GovtLevelsEntity : IGovtLevelsEntity
    {
		public int GovtLevelID { get; set; }
		public string Name { get; set; }
		public string Description { get; set; }
		public bool IsActive { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface IIAAsEntity
	{
		int IAAID { get; set; }
		string IAA { get; set; }
		string IAADescription { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }

	}

    public class IAAsEntity : IIAAsEntity
    {
		public int IAAID { get; set; }
		public string IAA { get; set; }
		public string IAADescription { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }

    }
      
	public interface IReportingTypesEntity
	{
		int ReportingTypeID { get; set; }
		string Name { get; set; }
		string Description { get; set; }
		bool IsActive { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class ReportingTypesEntity : IReportingTypesEntity
    {
		public int ReportingTypeID { get; set; }
		public string Name { get; set; }
		public string Description { get; set; }
		public bool IsActive { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface IUnitsEntity
	{
		long UnitID { get; set; }
		long? UnitParentID { get; set; }
		int CountryID { get; set; }
		long? UnitLocationID { get; set; }
		int? ConsularDistrictID { get; set; }
		string UnitName { get; set; }
		string UnitNameEnglish { get; set; }
		bool IsMainAgency { get; set; }
		long? UnitMainAgencyID { get; set; }
		string UnitAcronym { get; set; }
		string UnitGenID { get; set; }
		int UnitTypeID { get; set; }
		int? GovtLevelID { get; set; }
		int? UnitLevelID { get; set; }
		byte VettingBatchTypeID { get; set; }
		int VettingActivityTypeID { get; set; }
		int? ReportingTypeID { get; set; }
		long? UnitHeadPersonID { get; set; }
		string UnitHeadJobTitle { get; set; }
		int? UnitHeadRankID { get; set; }
		string UnitHeadRank { get; set; }
		string UnitHeadFirstMiddleNames { get; set; }
		string UnitHeadLastNames { get; set; }
		string UnitHeadIDNumber { get; set; }
		char? UnitHeadGender { get; set; }
		DateTime? UnitHeadDOB { get; set; }
		string UnitHeadPoliceMilSecID { get; set; }
		int? UnitHeadPOBCityID { get; set; }
		int? UnitHeadResidenceCityID { get; set; }
		string UnitHeadContactEmail { get; set; }
		string UnitHeadContactPhone { get; set; }
		int? UnitHeadHighestEducationID { get; set; }
		int? UnitHeadEnglishLanguageProficiencyID { get; set; }
		long? HQLocationID { get; set; }
		string POCName { get; set; }
		string POCEmailAddress { get; set; }
		string POCTelephone { get; set; }
		string VettingPrefix { get; set; }
		bool HasDutyToInform { get; set; }
		bool IsLocked { get; set; }
		bool IsActive { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class UnitsEntity : IUnitsEntity
    {
		public long UnitID { get; set; }
		public long? UnitParentID { get; set; }
		public int CountryID { get; set; }
		public long? UnitLocationID { get; set; }
		public int? ConsularDistrictID { get; set; }
		public string UnitName { get; set; }
		public string UnitNameEnglish { get; set; }
		public bool IsMainAgency { get; set; }
		public long? UnitMainAgencyID { get; set; }
		public string UnitAcronym { get; set; }
		public string UnitGenID { get; set; }
		public int UnitTypeID { get; set; }
		public int? GovtLevelID { get; set; }
		public int? UnitLevelID { get; set; }
		public byte VettingBatchTypeID { get; set; }
		public int VettingActivityTypeID { get; set; }
		public int? ReportingTypeID { get; set; }
		public long? UnitHeadPersonID { get; set; }
		public string UnitHeadJobTitle { get; set; }
		public int? UnitHeadRankID { get; set; }
		public string UnitHeadRank { get; set; }
		public string UnitHeadFirstMiddleNames { get; set; }
		public string UnitHeadLastNames { get; set; }
		public string UnitHeadIDNumber { get; set; }
		public char? UnitHeadGender { get; set; }
		public DateTime? UnitHeadDOB { get; set; }
		public string UnitHeadPoliceMilSecID { get; set; }
		public int? UnitHeadPOBCityID { get; set; }
		public int? UnitHeadResidenceCityID { get; set; }
		public string UnitHeadContactEmail { get; set; }
		public string UnitHeadContactPhone { get; set; }
		public int? UnitHeadHighestEducationID { get; set; }
		public int? UnitHeadEnglishLanguageProficiencyID { get; set; }
		public long? HQLocationID { get; set; }
		public string POCName { get; set; }
		public string POCEmailAddress { get; set; }
		public string POCTelephone { get; set; }
		public string VettingPrefix { get; set; }
		public bool HasDutyToInform { get; set; }
		public bool IsLocked { get; set; }
		public bool IsActive { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface IUnitTypesEntity
	{
		int UnitTypeID { get; set; }
		string Name { get; set; }
		string Description { get; set; }
		bool IsActive { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class UnitTypesEntity : IUnitTypesEntity
    {
		public int UnitTypeID { get; set; }
		public string Name { get; set; }
		public string Description { get; set; }
		public bool IsActive { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface IUSPartnerAgenciesEntity
	{
		int AgencyID { get; set; }
		string Name { get; set; }
		string Initials { get; set; }
		bool IsActive { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }

	}

    public class USPartnerAgenciesEntity : IUSPartnerAgenciesEntity
    {
		public int AgencyID { get; set; }
		public string Name { get; set; }
		public string Initials { get; set; }
		public bool IsActive { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }

    }
      
	public interface IAppUsersEntity
	{
		int AppUserID { get; set; }
		string ADOID { get; set; }
		string First { get; set; }
		string Middle { get; set; }
		string Last { get; set; }
		string PositionTitle { get; set; }
		string EmailAddress { get; set; }
		string PhoneNumber { get; set; }
		string PicturePath { get; set; }
		int CountryID { get; set; }
		int? PostID { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class AppUsersEntity : IAppUsersEntity
    {
		public int AppUserID { get; set; }
		public string ADOID { get; set; }
		public string First { get; set; }
		public string Middle { get; set; }
		public string Last { get; set; }
		public string PositionTitle { get; set; }
		public string EmailAddress { get; set; }
		public string PhoneNumber { get; set; }
		public string PicturePath { get; set; }
		public int CountryID { get; set; }
		public int? PostID { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface IBusinessUnitsEntity
	{
		long BusinessUnitID { get; set; }
		int BusinessUnitTypeID { get; set; }
		string BusinessUnitName { get; set; }
		string Acronym { get; set; }
		long? BusinessUnitParentID { get; set; }
		string Description { get; set; }
		bool IsActive { get; set; }
		bool IsDeleted { get; set; }
		bool HasPrograms { get; set; }
		string LogoFileName { get; set; }
		string VettingPrefix { get; set; }
		bool hasDutyToInform { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }

	}

    public class BusinessUnitsEntity : IBusinessUnitsEntity
    {
		public long BusinessUnitID { get; set; }
		public int BusinessUnitTypeID { get; set; }
		public string BusinessUnitName { get; set; }
		public string Acronym { get; set; }
		public long? BusinessUnitParentID { get; set; }
		public string Description { get; set; }
		public bool IsActive { get; set; }
		public bool IsDeleted { get; set; }
		public bool HasPrograms { get; set; }
		public string LogoFileName { get; set; }
		public string VettingPrefix { get; set; }
		public bool hasDutyToInform { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }

    }
      
	public interface IVettingActivityTypesEntity
	{
		int VettingActivityTypeID { get; set; }
		string Name { get; set; }
		string Description { get; set; }
		bool IsActive { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class VettingActivityTypesEntity : IVettingActivityTypesEntity
    {
		public int VettingActivityTypeID { get; set; }
		public string Name { get; set; }
		public string Description { get; set; }
		public bool IsActive { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      
	public interface IVettingBatchTypesEntity
	{
		byte VettingBatchTypeID { get; set; }
		string Code { get; set; }
		string Description { get; set; }
		bool IsActive { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class VettingBatchTypesEntity : IVettingBatchTypesEntity
    {
		public byte VettingBatchTypeID { get; set; }
		public string Code { get; set; }
		public string Description { get; set; }
		public bool IsActive { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      


	public interface IAgencyAtPostAuthorizingLawsViewEntity
	{
	    int PostID { get; set; }
	    long UnitID { get; set; }
	    int AuthorizingLawID { get; set; }
	    string Code { get; set; }
	    string Description { get; set; }
	    int ModifiedByAppUserID { get; set; }
	    bool IsActive { get; set; }
	    bool PostIsActive { get; set; }
	    int PostModifiedByAppUser { get; set; }
	    DateTime PostModifiedDate { get; set; }

	}

    public class AgencyAtPostAuthorizingLawsViewEntity : IAgencyAtPostAuthorizingLawsViewEntity
    {
		public int PostID { get; set; }
		public long UnitID { get; set; }
		public int AuthorizingLawID { get; set; }
		public string Code { get; set; }
		public string Description { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public bool IsActive { get; set; }
		public bool PostIsActive { get; set; }
		public int PostModifiedByAppUser { get; set; }
		public DateTime PostModifiedDate { get; set; }

    }
      
	public interface IAgencyAtPostVettingFundingSourcesViewEntity
	{
	    int PostID { get; set; }
	    long UnitID { get; set; }
	    int VettingFundingSourceID { get; set; }
	    string Code { get; set; }
	    string Description { get; set; }
	    int ModifiedByAppUserID { get; set; }
	    bool IsActive { get; set; }
	    bool PostIsActive { get; set; }
	    int PostModifiedByAppUser { get; set; }
	    DateTime PostModifiedDate { get; set; }

	}

    public class AgencyAtPostVettingFundingSourcesViewEntity : IAgencyAtPostVettingFundingSourcesViewEntity
    {
		public int PostID { get; set; }
		public long UnitID { get; set; }
		public int VettingFundingSourceID { get; set; }
		public string Code { get; set; }
		public string Description { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public bool IsActive { get; set; }
		public bool PostIsActive { get; set; }
		public int PostModifiedByAppUser { get; set; }
		public DateTime PostModifiedDate { get; set; }

    }
      



	public interface IGetReferenceTablesEntity
    {
        string ReferenceList { get; set; }
        int? CountryID { get; set; }
        int? PostID { get; set; }

    }

    public class GetReferenceTablesEntity : IGetReferenceTablesEntity
    {
		public string ReferenceList { get; set; }
		public int? CountryID { get; set; }
		public int? PostID { get; set; }

    }
      

}



