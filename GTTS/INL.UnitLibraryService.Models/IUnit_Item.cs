using System;
using System.Collections.Generic;
using System.Text;

namespace INL.UnitLibraryService.Models
{
    public interface IUnit_Item
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
        bool? IsActive { get; set; }
        int ModifiedByAppUserID { get; set; }
        DateTime ModifiedDate { get; set; }
        string UnitParentJson { get; set; }
        string CountryJson { get; set; }
        string LocationJson { get; set; }
        string PostJson { get; set; }
        string MainAgencyJson { get; set; }
        string HQLocationJson { get; set; }

        List<GetUnitAlias_Item> UnitAlias { get; set; }
        GetUnitLocation_Item UnitLocation { get; set; }
        GetUnitLocation_Item HQLocation { get; set; }
        GetUnitCommander_Item Commander { get; set; }
    }
}
