using System;
using System.Collections.Generic;
using System.Text;

namespace INL.UnitLibraryService.Models
{
    public class Unit_Item : IUnit_Item
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
        public bool? IsActive { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime ModifiedDate { get; set; }
        public string UnitParentJson { get; set; }
        public string CountryJson { get; set; }
        public string LocationJson { get; set; }
        public string PostJson { get; set; }
        public string MainAgencyJson { get; set; }
        public string HQLocationJson { get; set; }

        public List<GetUnitAlias_Item> UnitAlias { get; set; }
        public GetUnitLocation_Item UnitLocation { get; set; }
        public GetUnitLocation_Item HQLocation { get; set; }
        public GetUnitCommander_Item Commander { get; set; }
    }
}
