using System;
using System.Collections.Generic;
using System.Text;

namespace INL.SearchService.Models
{
    public class SearchPersonsVetting_Result : ISearchPersonsVetting_Result
    {
        public List<SearchPersonsVetting_Item> Collection { get; set; }
    }
}
