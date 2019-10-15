
namespace INL.SearchService.Models
{
    public interface ISearchNotifications_Param
    {
        string SearchString { get; set; }
        int? AppUserID { get; set; }
        long? ContextID { get; set; }
        int? ContextTypeID { get; set; }
        int? PageSize { get; set; }
        int? PageNumber { get; set; }
        string SortOrder { get; set; }
        string SortDirection { get; set; }
    }
}
