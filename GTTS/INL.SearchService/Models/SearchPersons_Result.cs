using System.Collections.Generic;

namespace INL.SearchService.Models
{
    public class SearchPersons_Result : ISearchPersons_Result
    {
        public List<ISearchPersons_Item> Collection { get; set; }
        public int Draw { get; set; }
        public int RecordsFiltered { get; set; }
        public int RecordsTotal { get; set; }
    }
}
