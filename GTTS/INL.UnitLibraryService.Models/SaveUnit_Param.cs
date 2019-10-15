using System;
using System.Collections.Generic;

namespace INL.UnitLibraryService.Models
{
    public class SaveUnit_Param : ISaveUnit_Param
    {
        public long? UnitID { get; set; }
        public long? UnitParentID { get; set; }
        public int CountryID { get; set; }
        public long? UnitLocationID { get; set; } 
        public int? ConsularDistrictID { get; set; }
        public string UnitName { get; set; }
        public string UnitNameEnglish { get; set; }
        public bool? IsMainAgency { get; set; }
        public long? UnitMainAgencyID { get; set; }
        public string UnitAcronym { get; set; }
        public string UnitGenID { get; set; }
        public List<SaveUnitAlias_Item> UnitAlias { get; set; }
        public int UnitTypeID { get; set; }
        public int? GovtLevelID { get; set; }
        public int? UnitLevelID { get; set; }
        public byte VettingBatchTypeID { get; set; }
        public int VettingActivityTypeID { get; set; }
        public int? ReportingTypeID { get; set; }
        public long? UnitHeadPersonID { get; set; }
        public string UnitHeadJobTitle { get; set; }
        public int? UnitHeadRankID { get; set; }
        public long? HQLocationID { get; set; }
        public string POCName { get; set; }
        public string POCEmailAddress { get; set; }
        public string POCTelephone { get; set; }
        public string VettingPrefix { get; set; }
        public bool HasDutyToInform { get; set; }
        public bool IsLocked { get; set; }
        public bool IsActive { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public SaveUnitLocation_Item UnitLocation { get; set; }
        public SaveUnitLocation_Item HQLocation { get; set; }
        public SaveUnitCommander_Item Commander { get; set; }
    }
}
