using System;
using System.Collections.Generic;
using System.Text;

namespace INL.SearchService.Models
{
    public interface ISearchTrainingEvents_Result
    {
        List<SearchTrainingEvents_Item> Collection { get; set; }
    }
}
