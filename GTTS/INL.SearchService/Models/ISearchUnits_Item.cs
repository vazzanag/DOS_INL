
namespace INL.SearchService.Models
{
    public interface ISearchUnits_Item
    {
        long UnitID { get; set; }
        string UnitAcronym { get; set; }
        string UnitName { get; set; }
        string UnitNameEnglish { get; set; }
        bool IsMainAgency { get; set; }
        long? UnitParentID { get; set; }
        string UnitParentName { get; set; }
        string UnitParentNameEnglish { get; set; }
        string AgencyName { get; set; }
        string AgencyNameEnglish { get; set; }
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
        string CommanderFirstName { get; set; }
        string CommanderLastName { get; set; }
        int CountryID { get; set; }
    }
}
