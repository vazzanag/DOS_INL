using System.Collections.Generic;

namespace INL.SearchService.Models
{
    public interface ISearchVettingBatches_Result
    {
        List<ISearchVettingBatches_Item> Collection { get; set; }
    }
}
