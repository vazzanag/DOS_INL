
namespace INL.SearchService.Models
{
    public class SearchNotifications_Param : ISearchNotifications_Param
    {
        public string SearchString { get; set; }
        public int? AppUserID { get; set; }
        public long? ContextID { get; set; }
        public int? ContextTypeID { get; set; }
        public int? PageSize { get; set; }
        public int? PageNumber { get; set; }
        public string SortOrder { get; set; }
        public string SortDirection { get; set; }
    }
}
