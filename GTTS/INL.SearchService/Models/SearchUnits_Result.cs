using System.Collections.Generic;

namespace INL.SearchService.Models
{
    public class SearchUnits_Result : ISearchUnits_Result
    {
        public int RecordCount { get; set; }
        public List<SearchUnits_Item> Collection { get; set; }
    }
}
