using System.Collections.Generic;
using INL.Services.Models;

namespace INL.SearchService.Models
{
    public class SearchTrainingEvents_Result : BaseResult, ISearchTrainingEvents_Result
    {
        public List<SearchTrainingEvents_Item> Collection { get; set; }
    }
}
