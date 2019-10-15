using System;
using System.Collections.Generic;
using System.Text;

namespace INL.SearchService.Models
{
    public interface ISearchPersonsVetting_Result
    {
        List<SearchPersonsVetting_Item> Collection { get; set; }
    }
}
