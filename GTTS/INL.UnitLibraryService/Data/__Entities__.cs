 
  



using System;


namespace INL.UnitLibraryService.Data
{
  
	public interface IUnitAliasesEntity
	{
		int UnitAliasID { get; set; }
		long UnitID { get; set; }
		string UnitAlias { get; set; }
		int? LanguageID { get; set; }
		bool IsDefault { get; set; }
		bool IsActive { get; set; }
		int ModifiedByAppUserID { get; set; }
		DateTime ModifiedDate { get; set; }
		DateTime SysStartTime { get; set; }
		DateTime SysEndTime { get; set; }

	}

    public class UnitAliasesEntity : IUnitAliasesEntity
    {
		public int UnitAliasID { get; set; }
		public long UnitID { get; set; }
		public string UnitAlias { get; set; }
		public int? LanguageID { get; set; }
		public bool IsDefault { get; set; }
		public bool IsActive { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
		public DateTime SysStartTime { get; set; }
		public DateTime SysEndTime { get; set; }

    }
      


	public interface IReportingTypesViewEntity
	{
	    int ReportingTypeID { get; set; }
	    string Name { get; set; }
	    string Description { get; set; }
	    bool IsActive { get; set; }
	    int ModifiedByAppUserID { get; set; }
	    DateTime ModifiedDate { get; set; }

	}

    public class ReportingTypesViewEntity : IReportingTypesViewEntity
    {
		public int ReportingTypeID { get; set; }
		public string Name { get; set; }
		public string Description { get; set; }
		public bool IsActive { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }

    }
      
	public interface IUnitsViewEntity
	{
	    long UnitID { get; set; }
	    long? UnitParentID { get; set; }
	    string UnitParentName { get; set; }
	    string UnitParentNameEnglish { get; set; }
	    string AgencyName { get; set; }
	    string AgencyNameEnglish { get; set; }
	    string UnitAgencyName { get; set; }
	    string UnitParents { get; set; }
	    string UnitBreakdown { get; set; }
	    string UnitBreakdownLocalLang { get; set; }
	    int CountryID { get; set; }
	    string CountryName { get; set; }
	    long? UnitLocationID { get; set; }
	    int? ConsularDistrictID { get; set; }
	    string UnitName { get; set; }
	    string UnitNameEnglish { get; set; }
	    bool IsMainAgency { get; set; }
	    long? UnitMainAgencyID { get; set; }
	    string UnitAcronym { get; set; }
	    string UnitGenID { get; set; }
	    int UnitTypeID { get; set; }
	    string UnitType { get; set; }
	    int? GovtLevelID { get; set; }
	    string GovtLevel { get; set; }
	    int? UnitLevelID { get; set; }
	    string UnitLevel { get; set; }
	    byte VettingBatchTypeID { get; set; }
	    string VettingBatchTypeCode { get; set; }
	    int VettingActivityTypeID { get; set; }
	    string VettingActivityType { get; set; }
	    int? ReportingTypeID { get; set; }
	    string ReportingType { get; set; }
	    long? UnitHeadPersonID { get; set; }
	    string CommanderFirstName { get; set; }
	    string CommanderLastName { get; set; }
	    string CommanderEmail { get; set; }
	    string UnitHeadJobTitle { get; set; }
	    int? UnitHeadRankID { get; set; }
	    string RankName { get; set; }
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
	    string UnitAliasJson { get; set; }

	}

    public class UnitsViewEntity : IUnitsViewEntity
    {
		public long UnitID { get; set; }
		public long? UnitParentID { get; set; }
		public string UnitParentName { get; set; }
		public string UnitParentNameEnglish { get; set; }
		public string AgencyName { get; set; }
		public string AgencyNameEnglish { get; set; }
		public string UnitAgencyName { get; set; }
		public string UnitParents { get; set; }
		public string UnitBreakdown { get; set; }
		public string UnitBreakdownLocalLang { get; set; }
		public int CountryID { get; set; }
		public string CountryName { get; set; }
		public long? UnitLocationID { get; set; }
		public int? ConsularDistrictID { get; set; }
		public string UnitName { get; set; }
		public string UnitNameEnglish { get; set; }
		public bool IsMainAgency { get; set; }
		public long? UnitMainAgencyID { get; set; }
		public string UnitAcronym { get; set; }
		public string UnitGenID { get; set; }
		public int UnitTypeID { get; set; }
		public string UnitType { get; set; }
		public int? GovtLevelID { get; set; }
		public string GovtLevel { get; set; }
		public int? UnitLevelID { get; set; }
		public string UnitLevel { get; set; }
		public byte VettingBatchTypeID { get; set; }
		public string VettingBatchTypeCode { get; set; }
		public int VettingActivityTypeID { get; set; }
		public string VettingActivityType { get; set; }
		public int? ReportingTypeID { get; set; }
		public string ReportingType { get; set; }
		public long? UnitHeadPersonID { get; set; }
		public string CommanderFirstName { get; set; }
		public string CommanderLastName { get; set; }
		public string CommanderEmail { get; set; }
		public string UnitHeadJobTitle { get; set; }
		public int? UnitHeadRankID { get; set; }
		public string RankName { get; set; }
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
		public string UnitAliasJson { get; set; }

    }
      



	public interface IFindUnitByNameAndCountryIDEntity
    {
        string Name { get; set; }
        long? CountryID { get; set; }

    }

    public class FindUnitByNameAndCountryIDEntity : IFindUnitByNameAndCountryIDEntity
    {
		public string Name { get; set; }
		public long? CountryID { get; set; }

    }
      
	public interface IGetNextUnitGenIDEntity
    {
        int? CountryID { get; set; }
        long? UnitMainAgencyID { get; set; }
        string Identifier { get; set; }
        bool? IncludeCountryCode { get; set; }
        long? UnitParentID { get; set; }

    }

    public class GetNextUnitGenIDEntity : IGetNextUnitGenIDEntity
    {
		public int? CountryID { get; set; }
		public long? UnitMainAgencyID { get; set; }
		public string Identifier { get; set; }
		public bool? IncludeCountryCode { get; set; }
		public long? UnitParentID { get; set; }

    }
      
	public interface IGetReportingTypesByCountryIDEntity
    {

    }

    public class GetReportingTypesByCountryIDEntity : IGetReportingTypesByCountryIDEntity
    {

    }
      
	public interface IGetUnitEntity
    {
        long? UnitID { get; set; }

    }

    public class GetUnitEntity : IGetUnitEntity
    {
		public long? UnitID { get; set; }

    }
      
	public interface IGetUnitAndChildrenEntity
    {
        long? UnitID { get; set; }

    }

    public class GetUnitAndChildrenEntity : IGetUnitAndChildrenEntity
    {
		public long? UnitID { get; set; }

    }
      
	public interface IGetUnitsPagedEntity
    {
        int? PageSize { get; set; }
        int? PageNumber { get; set; }
        string SortDirection { get; set; }
        string SortColumn { get; set; }
        int? CountryID { get; set; }
        bool? IsMainAgency { get; set; }
        long? UnitMainAgencyID { get; set; }
        bool? IsActive { get; set; }

    }

    public class GetUnitsPagedEntity : IGetUnitsPagedEntity
    {
		public int? PageSize { get; set; }
		public int? PageNumber { get; set; }
		public string SortDirection { get; set; }
		public string SortColumn { get; set; }
		public int? CountryID { get; set; }
		public bool? IsMainAgency { get; set; }
		public long? UnitMainAgencyID { get; set; }
		public bool? IsActive { get; set; }

    }
      
	public interface ISaveUnitEntity
    {
        long? UnitID { get; set; }
        long? UnitParentID { get; set; }
        int? CountryID { get; set; }
        long? UnitLocationID { get; set; }
        int? ConsularDistrictID { get; set; }
        string UnitName { get; set; }
        string UnitNameEnglish { get; set; }
        bool? IsMainAgency { get; set; }
        long? UnitMainAgencyID { get; set; }
        string UnitAcronym { get; set; }
        string UnitGenID { get; set; }
        int? UnitTypeID { get; set; }
        int? GovtLevelID { get; set; }
        int? UnitLevelID { get; set; }
        byte? VettingBatchTypeID { get; set; }
        int? VettingActivityTypeID { get; set; }
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
        bool? HasDutyToInform { get; set; }
        bool? IsLocked { get; set; }
        bool? IsActive { get; set; }
        string UnitAliases { get; set; }
        int? ModifiedByAppUserID { get; set; }
        DateTime? ModifiedDate { get; set; }

    }

    public class SaveUnitEntity : ISaveUnitEntity
    {
		public long? UnitID { get; set; }
		public long? UnitParentID { get; set; }
		public int? CountryID { get; set; }
		public long? UnitLocationID { get; set; }
		public int? ConsularDistrictID { get; set; }
		public string UnitName { get; set; }
		public string UnitNameEnglish { get; set; }
		public bool? IsMainAgency { get; set; }
		public long? UnitMainAgencyID { get; set; }
		public string UnitAcronym { get; set; }
		public string UnitGenID { get; set; }
		public int? UnitTypeID { get; set; }
		public int? GovtLevelID { get; set; }
		public int? UnitLevelID { get; set; }
		public byte? VettingBatchTypeID { get; set; }
		public int? VettingActivityTypeID { get; set; }
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
		public bool? HasDutyToInform { get; set; }
		public bool? IsLocked { get; set; }
		public bool? IsActive { get; set; }
		public string UnitAliases { get; set; }
		public int? ModifiedByAppUserID { get; set; }
		public DateTime? ModifiedDate { get; set; }

    }
      
	public interface IUpdateUnitActiveFlagEntity
    {
        long? UnitID { get; set; }
        bool? IsActive { get; set; }

    }

    public class UpdateUnitActiveFlagEntity : IUpdateUnitActiveFlagEntity
    {
		public long? UnitID { get; set; }
		public bool? IsActive { get; set; }

    }
      
	public interface IUpdateUnitParentEntity
    {
        long? UnitID { get; set; }
        long? UnitParentID { get; set; }

    }

    public class UpdateUnitParentEntity : IUpdateUnitParentEntity
    {
		public long? UnitID { get; set; }
		public long? UnitParentID { get; set; }

    }
      





}



