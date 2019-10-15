
namespace INL.SearchService.Models
{
    public class SearchUnits_Param : ISearchUnits_Param
    {
        public string SearchString { get; set; }
        /// <summary>
        /// 1: Agencies
        /// 2: Units
        /// 3: Both
        /// </summary>
        public int? AgenciesOrUnits { get; set; }
        public int? CountryID { get; set; }
        public long? UnitMainAgencyID { get; set; }
        public int? PageSize { get; set; }
        public int? PageNumber { get; set; }
        public string SortOrder { get; set; }
        public string SortDirection { get; set; }
    }
}
