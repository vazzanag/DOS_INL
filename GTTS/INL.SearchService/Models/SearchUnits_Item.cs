
namespace INL.SearchService.Models
{
    public class SearchUnits_Item : ISearchUnits_Item
    {
        public long UnitID { get; set; }
        public string UnitAcronym { get; set; }
        public string UnitName { get; set; }
        public string UnitNameEnglish { get; set; }
        public bool IsMainAgency { get; set; }
        public long? UnitParentID { get; set; }
        public string UnitParentName { get; set; }
        public string UnitParentNameEnglish { get; set; }
        public string AgencyName { get; set; }
        public string AgencyNameEnglish { get; set; }
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
        public string CommanderFirstName { get; set; }
        public string CommanderLastName { get; set; }
        public int CountryID { get; set; }
    }
}
