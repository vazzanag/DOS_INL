
namespace INL.SearchService.Models
{
    public interface ISearchUnits_Param
    {
        string SearchString { get; set; }
        /// <summary>
        /// 1: Agencies
        /// 2: Units
        /// 3: Both
        /// </summary>
        int? AgenciesOrUnits { get; set; }
        int? CountryID { get; set; }
        long? UnitMainAgencyID { get; set; }
        int? PageSize { get; set; }
        int? PageNumber { get; set; }
        string SortOrder { get; set; }
        string SortDirection { get; set; }
    }
}
