using System.Collections.Generic;

namespace INL.SearchService.Models
{
    public interface ISearchPersons_Result
    {
        List<ISearchPersons_Item> Collection { get; set; }
        int Draw { get; set; }
        int RecordsFiltered { get; set; }
        int RecordsTotal { get; set; }
    }
}
