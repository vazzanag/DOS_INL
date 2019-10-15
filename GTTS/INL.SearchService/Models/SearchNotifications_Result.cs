using System.Collections.Generic;

namespace INL.SearchService.Models
{
    public class SearchNotifications_Result : ISearchNotifications_Result
    {
        public int RecordCount { get; set; }
        public List<SearchNotifications_Item> Collection { get; set; }
    }
}
