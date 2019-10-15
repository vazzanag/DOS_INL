using System.Collections.Generic;
using INL.Services.Models;

namespace INL.SearchService.Models
{
    public class SearchParticipants_Result : BaseResult, ISearchParticipants_Result
    {
        public List<ISearchParticipants_Item> Collection { get; set; }
    }
}
