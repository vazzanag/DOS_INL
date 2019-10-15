using System.Collections.Generic;

namespace INL.SearchService.Models
{
    public interface ISearchNotifications_Result
    {
        int RecordCount { get; set; }
        List<SearchNotifications_Item> Collection { get; set; }
    }
}
