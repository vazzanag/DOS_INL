using System.Collections.Generic;

namespace INL.SearchService.Models
{
    public interface ISearchUnits_Result
    {
        int RecordCount { get; set; }
        List<SearchUnits_Item> Collection { get; set; }
    }
}
