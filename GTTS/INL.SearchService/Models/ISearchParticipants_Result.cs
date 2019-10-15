using System.Collections.Generic;

namespace INL.SearchService.Models
{
    public interface ISearchParticipants_Result
    {
        List<ISearchParticipants_Item> Collection { get; set; }
    }
}
