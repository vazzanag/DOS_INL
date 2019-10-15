
namespace INL.SearchService.Models
{
    public class SearchPersons_Param : ISearchPersons_Param
    {
        public string SearchString { get; set; }
        public int? CountryID { get; set; }
        public int? PageSize { get; set; }
        public int? PageNumber { get; set; }
        public string OrderColumn { get; set; }
        public string OrderDirection { get; set; }
        public string ParticipantType { get; set; }
    }
}
