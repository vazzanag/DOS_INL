using System;
using System.Collections.Generic;

namespace INL.UnitLibraryService.Models
{
    public interface ISaveUnit_Param
    {
        long? UnitID { get; set; }
        long? UnitParentID { get; set; }
        int CountryID { get; set; }
        long? UnitLocationID { get; set; }
        int? ConsularDistrictID { get; set; }
        string UnitName { get; set; }
        string UnitNameEnglish { get; set; }
        bool? IsMainAgency { get; set; }
        long? UnitMainAgencyID { get; set; }
        string UnitAcronym { get; set; }
        string UnitGenID { get; set; }
        List<SaveUnitAlias_Item> UnitAlias { get; set; }
        int UnitTypeID { get; set; }
        int? GovtLevelID { get; set; }
        int? UnitLevelID { get; set; }
        byte VettingBatchTypeID { get; set; }
        int VettingActivityTypeID { get; set; }
        int? ReportingTypeID { get; set; }
        long? UnitHeadPersonID { get; set; }
        string UnitHeadJobTitle { get; set; }
        int? UnitHeadRankID { get; set; }
        long? HQLocationID { get; set; }
        string POCName { get; set; }
        string POCEmailAddress { get; set; }
        string POCTelephone { get; set; }
        string VettingPrefix { get; set; }
        bool HasDutyToInform { get; set; }
        bool IsLocked { get; set; }
        bool IsActive { get; set; }
        int ModifiedByAppUserID { get; set; }
        DateTime? ModifiedDate { get; set; }
        SaveUnitLocation_Item UnitLocation { get; set; }
        SaveUnitLocation_Item HQLocation { get; set; }
        SaveUnitCommander_Item Commander { get; set; }
    }
}
