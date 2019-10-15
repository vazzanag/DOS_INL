using System;
using System.Collections.Generic;
using System.Text;

namespace INL.SearchService.Models
{
    public class SearchPersonsVetting_Param : ISearchPersonsVetting_Param
    {
        public string SearchString { get; set; }
        public string VettingType { get; set; }
    }
}
